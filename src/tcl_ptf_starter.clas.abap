class TCL_PTF_STARTER definition
  public
  final
  create public
  for testing
  duration long
  risk level dangerous .

public section.

  types:
    ty_t_varname TYPE cl_ptf_util=>ty_t_varname. "STANDARD TABLE OF ptf_varname with default key.

  constants GC_SUBRC_TEST_DUMPED type SYST_SUBRC value 8 ##NO_TEXT.

  class-methods CALL_SCRIPT
    importing
      !IV_PTF_SCRIPT type PTF_VARNAME
      !IV_ADD_LAST_MESSAGE type ABAP_BOOL optional
      !IV_ADD_FULL_LOG type ABAP_BOOL optional
    returning
      value(RV_SUBRC) type SYSUBRC .
  class-methods PTF_MASS_CALL
    importing
      !IT_VARNAME type cl_ptf_util=>TY_T_VARNAME
      !IV_GROUP_ID type CSEQUENCE optional
      !IV_ADD_FULL_LOG type ABAP_BOOL optional .
  class-methods PTF_SINGLE_CALL
    importing
      !IV_VARNAME type PTF_VARNAME .
  class-methods EXECUTE_ALL__DO_NOT_USE .
ENDCLASS.



CLASS TCL_PTF_STARTER IMPLEMENTATION.


  METHOD call_script.

    DATA:
      lt_step_data  TYPE TABLE OF cl_ptf_util=>gt_ptf_step,
      lt_return     TYPE cl_ptf_util=>gt_ptf_return_tab,
      lv_step_index TYPE i,
      lv_log_status TYPE sysubrc,
      ptf_runner    TYPE REF TO cl_ptf_run.

****
    IF iv_ptf_script IS INITIAL.
      EXIT.
    ENDIF.

    DATA gt_variant TYPE cl_ptf_variant=>gty_step_data_tab.

    DATA lo_variant TYPE REF TO cl_ptf_variant.
    IF lo_variant IS NOT BOUND.
      lo_variant = NEW cl_ptf_variant( ).
    ENDIF.

    lo_variant->read(
      EXPORTING
        iv_varname     = iv_ptf_script
      IMPORTING
        et_variant_tab = gt_variant
         ).
    IF gt_variant IS INITIAL.
      EXIT.
    ENDIF.

    MOVE-CORRESPONDING gt_variant TO lt_step_data.
    LOOP AT lt_step_data ASSIGNING FIELD-SYMBOL(<fs>).
      <fs>-step_number = sy-tabix.
      <fs>-json_file = gt_variant[ sy-tabix ]-input_string. " Tx PTF does this in FORM move_data_to_alv.
    ENDLOOP.

    LOOP AT lt_step_data ASSIGNING FIELD-SYMBOL(<ls_step_dta>).
      IF <ls_step_dta>-bus_obj IS NOT INITIAL.
        SELECT SINGLE ptf_check_action FROM ptfboa INTO <ls_step_dta>-check_flag WHERE ptf_act = <ls_step_dta>-action AND ptf_bo = <ls_step_dta>-bus_obj.
        "RAP BOs might not have an PTFBOA record
        IF sy-subrc IS NOT INITIAL.
          DATA(lo_ptf_rap_metadata) = NEW cl_ptf_rap_metadata( ).
          <ls_step_dta>-check_flag = lo_ptf_rap_metadata->check_rap_bo_check_action( iv_bus_obj = <ls_step_dta>-bus_obj  iv_action = <ls_step_dta>-action ).
        ENDIF.
      ENDIF.
    ENDLOOP.
***

    DATA(lo_error) = lo_variant->check_syntax( lt_step_data ).
    IF lo_error IS BOUND.
      rv_subrc = 6.  "Syntax error
      cl_abap_unit_assert=>fail(
        EXPORTING
          msg      = 'Script (' && iv_ptf_script && ') has a syntax error:'
          quit     = if_abap_unit_constant=>quit-no
      ).
      DATA(text) = lo_error->get_text( ).
      cl_abap_unit_assert=>fail(
        msg    = text
        quit     = if_abap_unit_constant=>quit-no
        detail = 'Script:' && iv_ptf_script
      ).
      RETURN.
    ENDIF.


    DATA ls_run_head        TYPE cl_ptf_util=>ty_run_head.
    DATA lt_run_head        TYPE cl_ptf_util=>ty_gt_run_head.
    DATA lv_timestamp_start TYPE timestampl.

    TRY.
        DATA(uuid) = NEW cl_system_uuid( )->if_system_uuid~create_uuid_c26( ).
      CATCH cx_uuid_error.
        cl_abap_unit_assert=>fail( ).
    ENDTRY.

    GET TIME STAMP FIELD lv_timestamp_start.

    ls_run_head-run_uuid         = uuid.
    ls_run_head-variant          = iv_ptf_script.
    ls_run_head-start_timestamp  = cl_abap_tstmp=>move_to_short( lv_timestamp_start ).
    ls_run_head-start_date       = sy-datum.
    ls_run_head-start_time       = sy-uzeit.
    ls_run_head-user             = sy-uname.
    ls_run_head-is_batch         = 'U'.  "means SUT

    APPEND ls_run_head TO lt_run_head.

    EXPORT t_run_head = lt_run_head TO MEMORY ID 'PTF_RUNS'.


    ptf_runner = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    ptf_runner->execute(
      EXPORTING
        iv_run_uuid = uuid
      IMPORTING
        ev_step_index = lv_step_index
        ev_log_status = lv_log_status
    ).

    COMMIT WORK. "persist record in PTF_EXEC_LOG     might also COMMIT what the script has done even if no COMMIT wanted there, in rare mode <<Mode 'NO AUnit'.does also not open a new session>>

    IF lv_log_status EQ 1.
      rv_subrc = 1.
    ENDIF.

    lt_step_data = ptf_runner->get_all_steps( ).
    lt_return = ptf_runner->get_log( ).

    LOOP AT lt_return INTO DATA(ls_return).
*      FIND 'Unplanned end of this AU step' IN ls_return-message.
*      IF sy-subrc IS INITIAL.
      IF ls_return-message EQ '!! Unplanned end of this AU step !!'.
        "DATA(dumped) = abap_true.
        rv_subrc = gc_subrc_test_dumped. "8.
        EXIT.
      ENDIF.
    ENDLOOP.


    "note better readable logic in include PTF_RUN, FORM overall_status
    IF rv_subrc EQ 0 AND lv_step_index GT 0. "Ensure that at least one step was executed with gv_step_index GT 0
      READ TABLE lt_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data>) INDEX lv_step_index.
      IF <ls_step_data> IS ASSIGNED.
        IF <ls_step_data>-check_flag EQ abap_true AND <ls_step_data>-check_status EQ abap_true.
          rv_subrc = 0.
        ELSEIF <ls_step_data>-check_flag EQ abap_false.
          LOOP AT lt_step_data ASSIGNING <ls_step_data>.
            IF <ls_step_data>-execution_status EQ abap_false  AND <ls_step_data>-check_status EQ abap_false. "not all check actions fill the execution status, so check also the check status
              rv_subrc = 1.
*            gv_failed_bo = <ls_step_data>-bus_obj.
*            gv_failed_bo_action = <ls_step_data>-action.

*              cl_abap_unit_assert=>fail(
*                EXPORTING
*                  msg      = 'Failed because of failed action.'
*                  level    = if_abap_unit_constant=>severity-low
*                  quit     = if_abap_unit_constant=>quit-no       ).

              EXIT.
            ENDIF.
            lv_step_index = lv_step_index - 1.
            IF lv_step_index EQ 0.
              rv_subrc = 0.
              EXIT.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDIF.


    IF rv_subrc NE 0.   "IV_ADD_... are only evaluated for failed tests

      DATA(line) = lines( lt_return ).
      SUBTRACT 2 FROM line.
      READ TABLE lt_return INDEX line INTO DATA(textline).

      "IV_ADD_LAST_MESSAGE
      IF iv_add_last_message IS NOT INITIAL.
        cl_abap_unit_assert=>fail(
          EXPORTING
            msg      = 'Failed, last log line was:' && textline-message
            level    = if_abap_unit_constant=>severity-low
            quit     = if_abap_unit_constant=>quit-no
             ).
*      cl_abap_unit_assert=>fail(
*        EXPORTING
*          msg      = textline-message
*          level    = if_abap_unit_constant=>severity-low
*          quit     = if_abap_unit_constant=>quit-no       ).
      ENDIF.

      "IV_ADD_FULL_LOG
      IF iv_add_full_log IS NOT INITIAL.
        DATA log_string TYPE string VALUE 'FULL LOG:'.
        LOOP AT lt_return INTO DATA(ls_return2).
          log_string = log_string && ls_return2-message && cl_abap_char_utilities=>cr_lf . " '|'.
        ENDLOOP.

        cl_abap_unit_assert=>fail(
          EXPORTING
            msg      = 'Full log (see details of this message).'
            level    = if_abap_unit_constant=>severity-low
            quit     = if_abap_unit_constant=>quit-no
            detail = log_string
             ).
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD execute_all__do_not_use.

    DATA lt_varname	TYPE cl_ptf_util=>ty_t_varname.
    DATA overall_rc TYPE i.
    DATA no_failed TYPE i.
    DATA no_executed TYPE i.


    SELECT SINGLE * FROM ptf_ctrl_prmtr INTO @DATA(ls_ctrl_prmtr) WHERE parameter_name = 'ALLOW_RUN_ALL'.
    IF sy-subrc IS NOT INITIAL OR ls_ctrl_prmtr-value NE 'ALL'.
      cl_abap_unit_assert=>skip(
        EXPORTING
          msg    = 'ExecuteAll is not allowed in this client'
      ).
    ENDIF.

    DATA max_variants TYPE i.
    max_variants = 20.
    SELECT varname FROM ptf_varid INTO TABLE lt_varname
      UP TO  max_variants  ROWS
      WHERE
      varname NOT LIKE 'Z%'
      AND varname NOT LIKE 'S4%'
      AND varname NOT LIKE 'SD_DPC%'
      AND user_specific = space .

    SORT lt_varname.

    LOOP AT lt_varname ASSIGNING FIELD-SYMBOL(<varname>).
      DATA(rc) = call_script(
        iv_ptf_script       = <varname>
        iv_add_last_message = 'X'
        iv_add_full_log     = 'X'
      ).
      ADD 1 TO no_executed.
      IF rc IS NOT INITIAL.
        overall_rc = 1.
        ADD 1 TO no_failed.

        IF rc EQ gc_subrc_test_dumped.
          overall_rc = rc.
          cl_abap_unit_assert=>fail(
              msg    =  'Script:' && <varname> && ' failed (dumped?)'  " TODO: 'in step x'.
              quit   = if_abap_unit_constant=>quit-no
          ).
        ELSE.
          IF overall_rc IS INITIAL. "do not oberwrite overall_rc with 1, if it is already more severe (8)
            overall_rc = rc.
          ENDIF.
          cl_abap_unit_assert=>fail(
              msg    =  'Script:' && <varname> && ' failed'  " TODO: 'in step x'.
*            level  = if_abap_unit_constant=>severity-medium " Severity (TOLERABLE, >CRITICAL<, FATAL)
              quit   = if_abap_unit_constant=>quit-no
*            detail = 'I plan to add details from the log here.'
          ).
        ENDIF.

      ENDIF.
    ENDLOOP.


    cl_abap_unit_assert=>assert_initial(
      EXPORTING
        act              = overall_rc
        msg              = no_failed && ' of_' && no_executed && ' tests failed.'
    ).

  ENDMETHOD.


  METHOD ptf_mass_call.

    cl_abap_unit_assert=>assert_not_initial(
      EXPORTING
        act      =  it_varname
        msg      = 'Nothing to execute.'
        level    = if_abap_unit_constant=>severity-low
        quit     = if_abap_unit_constant=>quit-test
    ).

    DATA overall_rc  TYPE i.
    DATA no_failed   TYPE i.
    DATA no_executed TYPE i.

    LOOP AT it_varname ASSIGNING FIELD-SYMBOL(<varname>).
      DATA(rc) = call_script(
        iv_ptf_script   = <varname>
        iv_add_full_log = iv_add_full_log
      ).
      ADD 1 TO no_executed.
      IF rc IS INITIAL.
        "success
        CHECK 1 = 1.

      ELSE.

        "failed
        overall_rc = rc.
        ADD 1 TO no_failed.
        IF rc EQ gc_subrc_test_dumped. "8.
          cl_abap_unit_assert=>fail(
*            msg    =  `Script ` && <varname> && ` dumped`   "in UI space and _ can not be distinguished. I guess they underline everything to mark the text as link. We need another delimiter.
            msg    =  'Script (' && <varname> && ') dumped'
            quit   = if_abap_unit_constant=>quit-no
        ).
        ELSE.
          cl_abap_unit_assert=>fail(
              msg    =  'Script (' && <varname> && ') failed'  " TODO: 'in step x'.
*            level  = if_abap_unit_constant=>severity-medium " Severity (TOLERABLE, >CRITICAL<, FATAL)
              quit   = if_abap_unit_constant=>quit-no
          ).
        ENDIF.

      ENDIF. "rc

    ENDLOOP.


    cl_abap_unit_assert=>assert_initial(
      EXPORTING
        act              = overall_rc
        msg              = iv_group_id
                           && COND string( WHEN iv_group_id IS INITIAL  THEN '' ELSE ':' )
                           && no_failed && ` of ` && no_executed && ' tests failed.'
    ).

  ENDMETHOD.


  METHOD ptf_single_call.
    DATA(rc) = call_script(
      iv_ptf_script   = iv_varname
      iv_add_full_log = 'X'
    ).
    cl_abap_unit_assert=>assert_initial(
      EXPORTING
        act              = rc
        msg              = 'The test failed:' && iv_varname
    ).
  ENDMETHOD.
ENDCLASS.
