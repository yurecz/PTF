*&---------------------------------------------------------------------*
*& Include          PTF_RUN
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form PTF_RUN
*&---------------------------------------------------------------------*
FORM ptf_run.

  DATA:
    lv_log_status         TYPE sysubrc,      "0:run ok   1:run failed
    lv_varname_external   TYPE ptf_varname,
    lv_varname            TYPE ptf_varname,
    lv_alv_ok             TYPE abap_bool,
    lv_started_externally TYPE abap_bool,
    lv_timestamp_start    TYPE timestampl,
    lv_timestamp_end      TYPE timestampl,
    lo_ptf_run            TYPE REF TO cl_ptf_run.

  CLEAR gv_step_index. "as there were cases were the value survived between ECA calls
  CLEAR gt_full_log.
  CLEAR gv_failed_bo.
  CLEAR gv_failed_bo_action.

  gv_log_rcode = 1.   " 'Test failed'

  PERFORM refresh_outtab_result_fields CHANGING gt_outtab_step.
  PERFORM clear_transnt_step_data_fields CHANGING gt_step_data.
  PERFORM update_step_data               CHANGING gt_step_data.
  PERFORM fill_check_flag                CHANGING gt_step_data.

  cl_ptf_wrapper=>get_variant( IMPORTING ev_variant = lv_varname_external ).

  go_variant = NEW cl_ptf_variant( ).
  DATA(lo_error) = go_variant->check_syntax( gt_step_data ).

  IF lv_varname_external IS INITIAL.
    "started from SAPGUI
    lv_varname = gs_varhead-varname.
    IF g_grid_step IS NOT INITIAL.
      "clear ALV from results of a previous run
      g_grid_step->refresh_table_display( ).
      CALL METHOD cl_gui_cfw=>flush EXCEPTIONS OTHERS = 1.
    ENDIF.
    IF lo_error IS BOUND.
      lo_error->raise_message( display_type = 'E' ).
      PERFORM set_focus_oo USING lo_error.
      RETURN.
    ENDIF.
  ELSE.
    "externally started run
    lv_varname = lv_varname_external.
    lv_started_externally = abap_true.
    IF lo_error IS BOUND.
      DATA(text) = lo_error->get_text( ).
      APPEND VALUE #( message = 'Script cannot be executed:' ) TO gt_full_log.
      APPEND VALUE #( message = text ) TO gt_full_log.
      PERFORM output_ecatt.
      RETURN.
    ENDIF.
  ENDIF.

  lo_ptf_run = NEW cl_ptf_run( it_ptf_steps = gt_step_data ).
  lo_ptf_run->set_variant_name( lv_varname ).

  GET TIME STAMP FIELD lv_timestamp_start.

  cl_ptf_util=>create_run_head(
    EXPORTING
      iv_variant         = lv_varname
      iv_timestamp_start = lv_timestamp_start
      iv_is_batch        = lv_started_externally
    IMPORTING
      es_run_head        = DATA(ls_run_head) "only the uuid is needed here
    ).

*  gv_step_index = 0.   "0 is the first step
  ASSERT lv_log_status IS INITIAL. "temp

  "Execute the run
  lo_ptf_run->execute(
    EXPORTING
      iv_run_uuid   = ls_run_head-run_uuid
    IMPORTING
      ev_step_index = gv_step_index
      ev_log_status = lv_log_status    "this is a non-final best case assumption only, as it considers only failed checks. even if it is 0 (ok), it might be set to 1 (failed) below
  ).


  GET TIME STAMP FIELD lv_timestamp_end.
  DATA(lv_run_time) = cl_abap_tstmp=>subtract( EXPORTING tstmp1 = lv_timestamp_end tstmp2 = lv_timestamp_start ).


  gt_step_data = lo_ptf_run->get_all_steps( ). "overwrites all columns of gt_step_data, not only the transient ones. slight risk.

  "Log
  gt_full_log  = lo_ptf_run->get_log( ).
  APPEND VALUE #( message = '************************************' ) TO gt_full_log.
  IF lv_varname IS NOT INITIAL.
    APPEND VALUE #( message = |PTF Run took { lv_run_time } seconds for variant { lv_varname }| ) TO gt_full_log.
  ELSE.
    APPEND VALUE #( message = |PTF Run took { lv_run_time } seconds| ) TO gt_full_log.
  ENDIF.
  APPEND VALUE #( message = '******************STABLE VERSION OF PTF******************' ) TO gt_full_log.


  LOOP AT gt_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data_v2>).
    IF <ls_step_data_v2>-bus_obj IS INITIAL
      AND <ls_step_data_v2>-action IS INITIAL
      AND <ls_step_data_v2>-variant IS INITIAL.
      "End of PTF Variant reached
      EXIT.
    ENDIF.
    PERFORM output_alv USING <ls_step_data_v2>.   "changes gv_log_rcode, enriches gt_outtab_step(with icons)
  ENDLOOP.

  PERFORM overall_status USING lv_log_status.  "consumes gt_step_data and global field gv_step_index. changes gv_step_index. sets gv_log_rcode, gv_failed_bo, gv_failed_bo_action .
  PERFORM output_ecatt.    "read access to gt_full_log, gv_log_rcode, gt_return, gv_step_index(expected to show the failing step if failed),   gv_failed_bo, gv_failed_bo_action.  Sents data to cl_ptf_wrapper.

  PERFORM check_last_step USING gt_step_data lv_started_externally.

  IF g_grid_step IS NOT INITIAL.
    g_grid_step->refresh_table_display( ).
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form overall_status
*&---------------------------------------------------------------------*
FORM overall_status USING iv_log_status.
  "IF gv_log_status EQ 0 AND gv_step_index GT 0. Discuss why gv_log_status should be zero
  CHECK iv_log_status EQ 0.
  CHECK gv_step_index GT 0. "Ensure that at least one step was executed with gv_step_index GT 0

  READ TABLE gt_step_data ASSIGNING FIELD-SYMBOL(<ls_last_step_data>) INDEX gv_step_index.    "INDEX starts with 1 for the first record   "gv_step_index should do the same(seems to fit, for non failed scripts, and only these are handled here)
*  CHECK <ls_last_step_data> IS ASSIGNED.
  IF <ls_last_step_data> IS NOT ASSIGNED    OR
    <ls_last_step_data>-bus_obj IS INITIAL.
    BREAK griesec.
    gv_log_rcode = 7.
    RETURN.
  ENDIF.

  IF <ls_last_step_data>-check_flag EQ abap_true AND <ls_last_step_data>-check_status EQ abap_true.
    "last executed step was a check, and succesful
    gv_log_rcode = 0.

  ELSEIF <ls_last_step_data>-check_flag EQ abap_false.
    "last executed step was a normal action. Check whether there was at least one failed normal action, then set run to failed       too hard, this blocks negative tests (if not last step is a check step)
    "                                        better look only at the last step (also if no check step), if this normal action is successful, the script is successful

    LOOP AT gt_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data>).
      IF <ls_step_data>-execution_status EQ abap_false      AND <ls_step_data>-check_status EQ abap_false. "not all check actions fill the execution status, so check also the check status
        gv_log_rcode        = 1.
        gv_failed_bo        = <ls_step_data>-bus_obj.
        gv_failed_bo_action = <ls_step_data>-action.
        EXIT.
      ENDIF.
      gv_step_index = gv_step_index - 1.
      IF gv_step_index EQ 0.
        gv_log_rcode = 0.
        EXIT.
      ENDIF.
    ENDLOOP.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form OUTPUT_ECATT
*&---------------------------------------------------------------------*
FORM output_ecatt .

  DATA: lv_ecatt_comment TYPE string,
        lt_ecatt_log     TYPE cl_ptf_wrapper=>tt_ptf_log,
        ls_ecatt_log     TYPE cl_ptf_wrapper=>ty_ptf_log.

  IF gv_log_rcode EQ 0.
    lv_ecatt_comment = 'Test ended successfully.'.
  ELSEIF gv_log_rcode EQ 7.
    lv_ecatt_comment = '!! ERROR IN FORM overall_status. RCODE cannot be set.'.
  ELSE.
    lv_ecatt_comment = 'Test failed.'.
    READ TABLE gt_step_data INTO DATA(failed_step) INDEX gv_step_index + 1 .
    gv_failed_bo        = failed_step-bus_obj.
    gv_failed_bo_action = failed_step-action.
  ENDIF.

  LOOP AT gt_full_log INTO DATA(gs_log).
    IF gs_log-type IS INITIAL AND gs_log-id IS INITIAL AND gs_log-number IS INITIAL.
      MOVE gs_log-message TO ls_ecatt_log-row.
    ELSEIF gs_log-type IS INITIAL AND gs_log-number IS INITIAL.
      CONCATENATE  gs_log-id                           gs_log-message  INTO ls_ecatt_log-row SEPARATED BY space. "id is filled with StepNo at first log record per step
    ELSEIF gs_log-number IS INITIAL.
      CONCATENATE  gs_log-type gs_log-id               gs_log-message  INTO ls_ecatt_log-row SEPARATED BY space.
    ELSE.
      CONCATENATE  gs_log-type gs_log-id gs_log-number gs_log-message  INTO ls_ecatt_log-row SEPARATED BY space.
    ENDIF.
    APPEND ls_ecatt_log TO lt_ecatt_log.
  ENDLOOP.

  cl_ptf_wrapper=>set_result(
    EXPORTING
      iv_rcode            = gv_log_rcode
      iv_log_comment      = lv_ecatt_comment
      iv_failed_bo        = gv_failed_bo
      iv_failed_bo_action = gv_failed_bo_action
      it_ptf_log          = lt_ecatt_log
      it_ptf_step_data    = gt_step_data
  ).

ENDFORM.

*&---------------------------------------------------------------------*
*& Form OUTPUT_ALV - called per record
*&---------------------------------------------------------------------*
FORM output_alv USING is_step_data TYPE cl_ptf_util=>gt_ptf_step.

  READ TABLE gt_outtab_step ASSIGNING FIELD-SYMBOL(<ls_outtab_step>) INDEX is_step_data-step_number.

  <ls_outtab_step>-check_status = is_step_data-check_status.

  IF is_step_data-check_flag EQ abap_true.
    "Check action
    IF is_step_data-check_status EQ abap_true.
      <ls_outtab_step>-check_status = icon_led_green.
      gv_log_rcode = 0.
    ELSE.
      <ls_outtab_step>-check_status = icon_led_red.
      gv_log_rcode = 1.
    ENDIF.
  ELSE.
    "Action
    IF is_step_data-execution_status EQ abap_true.
      <ls_outtab_step>-execution_status =  icon_led_green.
      gv_log_rcode = 0.
    ELSE.
      <ls_outtab_step>-execution_status =  icon_led_red.
      gv_log_rcode = 1.
    ENDIF.
  ENDIF.

  "Fill field
  READ TABLE is_step_data-document_id INTO <ls_outtab_step>-document_id INDEX 1.

  "Set icon
  DESCRIBE TABLE is_step_data-document_id LINES DATA(lv_length).
  IF lv_length > 1.
    <ls_outtab_step>-document_id_more = icon_list.
  ENDIF.

  "Fill actual messages
  <ls_outtab_step>-act_messages = is_step_data-act_messages.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form refresh_output
*&---------------------------------------------------------------------*
FORM refresh_outtab_result_fields CHANGING ch_outtab_step TYPE cl_ptf_util=>ty_outtab_tab.
  LOOP AT ch_outtab_step ASSIGNING FIELD-SYMBOL(<ls_outtab_step>).
    IF <ls_outtab_step>-is_manual EQ abap_false.
      <ls_outtab_step>-document_id      = space.
    ENDIF.
    <ls_outtab_step>-document_id_more = space.
    <ls_outtab_step>-check_status     = space.
    <ls_outtab_step>-execution_status = space.
  ENDLOOP.
ENDFORM.

FORM clear_transnt_step_data_fields CHANGING ct_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.
  LOOP AT ct_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data>).
    IF <ls_step_data>-is_manual EQ abap_false.
      CLEAR <ls_step_data>-document_id.
    ENDIF.
    CLEAR <ls_step_data>-execution_status.
    CLEAR <ls_step_data>-check_status.
    CLEAR <ls_step_data>-data_object_json.  "done only here!
    CLEAR <ls_step_data>-is_pid.
    CLEAR <ls_step_data>-log.
    CLEAR <ls_step_data>-act_messages.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form fill_check_flag
*&---------------------------------------------------------------------*
FORM fill_check_flag CHANGING ct_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.

  LOOP AT ct_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data>).
    IF <ls_step_data>-bus_obj IS NOT INITIAL.
      SELECT SINGLE ptf_check_action FROM ptfboa INTO <ls_step_data>-check_flag WHERE ptf_act = <ls_step_data>-action  AND  ptf_bo = <ls_step_data>-bus_obj.
      IF sy-subrc IS NOT INITIAL.
        DATA(lo_ptf_rap_metadata) = NEW cl_ptf_rap_metadata( ).
        <ls_step_data>-check_flag = lo_ptf_rap_metadata->check_rap_bo_check_action( iv_bus_obj = <ls_step_data>-bus_obj  iv_action = <ls_step_data>-action ).
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFORM.
