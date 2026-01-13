CLASS tcl_ptf_step_in_au DEFINITION
  PUBLIC
  CREATE PUBLIC
  FOR TESTING
  DURATION LONG
  RISK LEVEL DANGEROUS .

  PUBLIC SECTION.

    CLASS-DATA environment TYPE REF TO if_osql_test_environment .
    CLASS-DATA gv_tdc TYPE etobj_name .

*  constants GC_CHANGE type PTF_ACT value 'CHANGE' ##NO_TEXT.
*  constants GC_CHECK type PTF_ACT value 'CHECK' ##NO_TEXT.
*  constants GC_CREATE type PTF_ACT value 'CREATE' ##NO_TEXT.
*  constants GC_DELETE type PTF_ACT value 'DELETE' ##NO_TEXT.
*  constants GC_EXECUTE type PTF_ACT value 'EXECUTE_ACTION' ##NO_TEXT.
*  constants GC_EXECUTE_CHECK type PTF_ACT value 'EXECUTE_CHECK' ##NO_TEXT.
    CLASS-METHODS class_constructor .
  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS execute_ptf_step
        FOR TESTING .
    METHODS setup .
    METHODS teardown .
    CLASS-METHODS class_setup .
    CLASS-METHODS class_teardown .
ENDCLASS.



CLASS TCL_PTF_STEP_IN_AU IMPLEMENTATION.


  METHOD class_constructor.
  ENDMETHOD.


  METHOD class_setup.

  ENDMETHOD.


  METHOD class_teardown.
    IF environment IS BOUND.
*      environment->destroy( ).
    ENDIF.
  ENDMETHOD.


  METHOD execute_ptf_step.

    DATA: ls_step_data     TYPE cl_ptf_util=>gt_ptf_step,
          lt_step_data     TYPE cl_ptf_util=>gt_ptf_step_tab,
          lv_run_uuid	     TYPE sysuuid_c26,
          lo_bo            TYPE REF TO object,
          lv_tdc           TYPE etobj_name,
          lv_tdcv          TYPE etvar_id,
          lv_tdc_old       TYPE etobj_name,
          lv_tdcv_old      TYPE etvar_id,
          lv_tdc_done      TYPE abap_bool,
          lt_step_log      TYPE cl_ptf_util=>gt_ptf_return_tab,
          lv_method_name   TYPE ptf_act,
          document_id      TYPE cl_ptf_util=>ty_vbeln_tab,
          execution_status TYPE abap_bool,
          check_status     TYPE abap_bool,
          lv_class_name    TYPE string,
          lv_end_the_run   TYPE abap_boolean.

    DATA ptf_test_landscape TYPE ptf_test_landscape.

    IMPORT s_step_data  = ls_step_data
           run_uuid     = lv_run_uuid
           ptf_test_landscape = ptf_test_landscape
           FROM MEMORY ID 'CG__PTF_STEP'.
    FREE MEMORY ID 'CG__PTF_STEP'.

    IF ls_step_data IS INITIAL. " Central AU run, not triggered by CL_PTF_RUN
      RETURN.
    ENDIF.
    ASSERT ls_step_data-step_number IS NOT INITIAL.

    IMPORT t_step_data  = lt_step_data
           FROM MEMORY ID 'CG__PTF_STEP_ALL'.

    FREE MEMORY ID 'CG__PTF_STEP_ALL'.

    cl_ptf_step_attr=>sv_au_session = abap_true.



***********
    "Temp: INVOICE forwarding logic to RAP BO
    DATA(lo_ptf_run_temp) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).
    IF ls_step_data-bus_obj EQ 'INVOICE' AND ls_step_data-action EQ 'CREATE'.
      IF ls_step_data-variant IS INITIAL AND ls_step_data-test_data_container IS INITIAL.

        DATA forward_invoice TYPE c.
        CONSTANTS lc_param_inv_forward TYPE c LENGTH 20 VALUE 'FORWARD_INVOICE'. " Parameter value 'X' means forward invoice CREATE to RAP BO action
        SELECT SINGLE * FROM ptf_ctrl_prmtr INTO @DATA(ls_ctrl_inv) WHERE parameter_name = @lc_param_inv_forward.
        IF sy-subrc IS INITIAL AND ls_ctrl_inv-value EQ 'X'.

          DATA(lt_resultids_of_refstep) = lo_ptf_run_temp->get_result_key_data( it_step_number = ls_step_data-reference_step ).
          LOOP AT lt_resultids_of_refstep ASSIGNING FIELD-SYMBOL(<vbeln_b>).
            SELECT SINGLE * FROM vbrk INTO @DATA(ls_vbrk) WHERE vbeln = @<vbeln_b>-document_id_char70-vbeln.
            IF sy-subrc IS INITIAL AND ls_vbrk-bdr_ref_vbtyp EQ 'PBRQ'.
              DATA(lv_proj_billing_involved) = abap_true.
            ENDIF.
          ENDLOOP.
          IF lt_resultids_of_refstep IS NOT INITIAL
            AND lv_proj_billing_involved EQ abap_false. "not if at least one proj billing BDR is in the list
            DATA string TYPE string.
            string = '{"_comment":"Generated JSON Action, tcl_step_step_in_au","action":"CreateFromSDDocument","fields":[],"params":[{"name":"_REFERENCE","value":['.
            LOOP AT lt_resultids_of_refstep ASSIGNING FIELD-SYMBOL(<vbeln>).
              IF sy-tabix GT 1.
                string = string && ','.
              ENDIF.
              string = string && '[{"name":"SDDOCUMENT","value":"' && <vbeln>-document_id_char70-vbeln && '"}]'.
            ENDLOOP.
            string = string && ']}]}'.

            ls_step_data-json_file = string.
*          CLEAR ls_step_data-reference_step."itab
            forward_invoice = abap_true.
          ENDIF.

        ENDIF.

        IF forward_invoice EQ abap_true.
          ls_step_data-bus_obj = 'R_BILLINGDOCUMENTTP'.
          ls_step_data-action  = 'CREATEFROMSDDOCUMENT'.
          READ TABLE lt_step_data ASSIGNING FIELD-SYMBOL(<ls>) WITH KEY step_number = ls_step_data-step_number.
          <ls>-bus_obj = 'R_BILLINGDOCUMENTTP'.
          <ls>-action  = 'CREATEFROMSDDOCUMENT'.  "needed before cl_ptf_run is instantiated with these steps!
          <ls>-json_file = ls_step_data-json_file.
*        CLEAR <ls>-reference_step."itab
        ENDIF.

      ENDIF.
    ENDIF.
***********
    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).
*   Set variant name into lo_ptf_run
    DATA(lo_ptf_abap_memory) = NEW cl_ptf_abap_memory( ).
    DATA(ls_result) = lo_ptf_abap_memory->get_run_head( EXPORTING iv_run_uuid = lv_run_uuid ).
    lo_ptf_run->set_variant_name( ls_result-variant ).
***********begin
    IF forward_invoice EQ abap_true.
      lo_ptf_run->append_log( iv_log_statement = |INVOICE CREATE forwarded to RAP BO R_BILLINGDOCUMENTTP.Contact: D028100 or D049099.| ).
    ENDIF.
***********end

    "Display progress if started from UI
    IF sy-batch IS INITIAL.
      LOOP AT lt_step_data ASSIGNING FIELD-SYMBOL(<ls_step>).
        IF <ls_step>-bus_obj IS INITIAL.
          ASSERT sy-tabix GT 1.
          DATA(lv_count_all_steps) = sy-tabix - 1.
          EXIT.
        ENDIF.
      ENDLOOP.
      IF lv_count_all_steps > 0.
        CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
          EXPORTING
            percentage = CONV i( 100 * ls_step_data-step_number / lv_count_all_steps )
            text       = |Started Step { ls_step_data-step_number } of { lv_count_all_steps }|.
      ENDIF.
    ENDIF.

    CLEAR document_id.
    CLEAR execution_status.
    CLEAR check_status.

    IF ls_step_data-is_manual EQ abap_true.
      "then do nothing
      lo_ptf_run->append_log( iv_log_statement = |Step execution skipped, as ResultID was set to manual in UI.| ).
    ELSEIF ls_step_data-bus_obj EQ cl_ptf_util=>gc_bo_ptfrun  AND ls_step_data-action NE cl_ptf_util=>gc_check_messages.  "action check_messages is implemented in BO class PTF_RUN, called like normal actions
**** << 5 Mock actions

      IF ls_step_data-action EQ cl_ptf_util=>gc_action_mock_db. "'START_DATA_MOCKING'.

        IF ls_step_data-variant CS ','.
          SPLIT ls_step_data-variant AT ',' INTO lv_tdc lv_tdcv.
        ELSE.
          lv_tdc = ls_step_data-test_data_container.
          lv_tdcv = ls_step_data-variant.
        ENDIF.

        IF lv_tdc IS INITIAL OR lv_tdcv IS INITIAL.
          lo_ptf_run->append_log( iv_log_statement = |Wrong configuration. Please fill TDC and TDCV.| ).
          execution_status = abap_false.
          RETURN.
        ENDIF.

        IMPORT v_mock_tdc   = lv_tdc_old
               v_mock_tdcv  = lv_tdcv_old
               "tdc_done     = lv_tdc_done
               FROM MEMORY ID 'CG__PTF_MOCK_TD'.
        IF lv_tdc_old IS NOT INITIAL AND lv_tdcv_old IS NOT INITIAL.
          IF lv_tdc NE lv_tdc_old OR lv_tdcv NE lv_tdcv_old.
            "mocking from another tdc/tdcv is already active. gets lost.
            lo_ptf_run->append_log( iv_log_statement = |Old mocking is ended by this new mock action.| ).
          ENDIF.
        ENDIF.

        "ok, we will use the given TDC+TDCV, store them
        EXPORT v_mock_tdc   = lv_tdc
               v_mock_tdcv  = lv_tdcv
               tdc_done     = abap_false
        TO MEMORY ID 'CG__PTF_MOCK_TD'.

        lo_ptf_run->append_log( iv_log_statement = |DB mocking is now active.| ).
        execution_status = abap_true.

      ELSEIF ls_step_data-action EQ cl_ptf_util=>gc_action_end_mock_db. "'END_DATA_MOCKING'.
        FREE MEMORY ID 'CG__PTF_MOCK_TD'.
        IF environment IS BOUND.
          environment->destroy( ).
        ENDIF.
        lo_ptf_run->append_log( iv_log_statement = |DB mocking DEactivated.| ).
        execution_status = abap_true.


      ELSEIF ls_step_data-action EQ cl_ptf_util=>gc_action_start_ftmock_active. "'START_MOCK_FT_IS_ACTIVE'
        IF ls_step_data-variant IS NOT INITIAL.
          EXPORT v_feat_toggle_id   = ls_step_data-variant
                 b_active           = abap_true
          TO MEMORY ID 'CG__PTF_FT_TOG_MOCK'.
          lo_ptf_run->append_log( iv_log_statement = |Starting to mock: Feature toggle is simulated ON.| ).
          execution_status = abap_true.
        ENDIF.
      ELSEIF ls_step_data-action EQ cl_ptf_util=>gc_action_start_ftmock_inactv. "'START_MOCK_FT_IS_INACTIVE'
        IF ls_step_data-variant IS NOT INITIAL.
          EXPORT v_feat_toggle_id   = ls_step_data-variant
                 b_active           = abap_false
          TO MEMORY ID 'CG__PTF_FT_TOG_MOCK'.
          lo_ptf_run->append_log( iv_log_statement = |Starting to mock: Feature toggle is simulated OFF.| ).
          execution_status = abap_true.
        ENDIF.
      ELSEIF ls_step_data-action EQ cl_ptf_util=>gc_action_end_ftmock.          "'END_FT_MOCKING'
        FREE MEMORY ID  'CG__PTF_FT_TOG_MOCK'.
        lo_ptf_run->append_log( iv_log_statement = |Feature toggle mocking has been stopped.| ).
        execution_status = abap_true.
      ELSE.
        ASSERT 1 = 2.
      ENDIF.
**** end 5 Mock actions>>

    ELSE. "BO not PTF_RUN

* Begin 'Start ongoing mocking for this session'
      "Has db mocking been activated?
      IMPORT v_mock_tdc   = lv_tdc
             v_mock_tdcv  = lv_tdcv
             tdc_done     = lv_tdc_done
             FROM MEMORY ID 'CG__PTF_MOCK_TD'.
      IF lv_tdc IS NOT INITIAL AND lv_tdcv IS NOT INITIAL.
        lo_ptf_run->append_log( iv_log_statement = |DB mocking is still active.| ).
        IF lv_tdc_done IS INITIAL.
          "call mock util class method startmock with tdc name and TDCV name
          tcl_ptf_db_mock_util=>mv_tdc  = lv_tdc.  "besser set-methode anbieten
          tcl_ptf_db_mock_util=>mv_tdcv = lv_tdcv.
          tcl_ptf_db_mock_util=>startmock( ).
          EXPORT
           v_mock_tdc   = lv_tdc
           v_mock_tdcv  = lv_tdcv
           tdc_done     = abap_true
           TO MEMORY ID 'CG__PTF_MOCK_TD'.
        ELSE.
          "call mock util class method remock
          tcl_ptf_db_mock_util=>remock( ).
        ENDIF.
        DATA(lt_log_mocking) = tcl_ptf_db_mock_util=>get_log( ).
        LOOP AT lt_log_mocking REFERENCE INTO DATA(lr_log).
          lo_ptf_run->append_log_structure( is_log = lr_log->* ).
        ENDLOOP.
      ENDIF.

      "Has BuPa multi address switch mocking been activated?
      IF ls_step_data-bus_obj NE |BUPA_MULTI_ADDR_SWITCH_MOCK|. "if this session+step is about changes to mocking, mocking isn't needed in THIS session. avoid log output, do nothing here. this method then calls the BUPA_MULTI_ADDR_SWITCH_MOCK BO action
        DATA lv_switch TYPE sftgl_ft_id.
        DATA lb_switch_active TYPE abap_bool.
        IMPORT v_bp_switch   = lv_switch
               b_active      = lb_switch_active
               FROM MEMORY ID 'CG__PTF_BP_SWITCH'.
        IF sy-subrc IS INITIAL AND lv_switch IS NOT INITIAL.
          DATA(lo_switch_handler) = NEW cl_bupa_multi_addr_4_test( ).
          lo_switch_handler->define_switch_status( iv_switch_id = CONV string( lv_switch )
                                                   iv_active    = lb_switch_active ).
          IF lb_switch_active EQ abap_true.
            lo_ptf_run->append_log( iv_log_statement = |Using switch mocking. Switch:| && lv_switch && |, mocked state: ON.| ).
          ELSE.
            lo_ptf_run->append_log( iv_log_statement = |Using switch mocking. Switch:| && lv_switch && |, mocked state: OFF.| ).
          ENDIF.
        ENDIF.
      ENDIF.

      "Has feature toggle mocking been activated?
      DATA lv_feat_tog_id LIKE lv_tdcv.
      DATA lb_active TYPE abap_bool.
      IMPORT v_feat_toggle_id   = lv_feat_tog_id
             b_active           = lb_active
             FROM MEMORY ID 'CG__PTF_FT_TOG_MOCK'.
      IF lv_feat_tog_id IS NOT INITIAL.
        DATA(lv_safe) = cl_feature_toggle_4_test=>define_test_toggle(
          iv_toggle_id = CONV #( lv_feat_tog_id )  "limitation: only 30 of 40 chars supported
          iv_active    = lb_active ).
        IF lv_safe EQ abap_true.   "does not fail even if the ID is unknown
          lo_ptf_run->append_log( iv_log_statement = |FT mocking used. FT ID:| && lv_feat_tog_id && |, state:<| && lb_active && |>.| ).
        ELSE.
          lo_ptf_run->append_log( iv_log_statement = |FT mocking FAILED. FT ID:| && lv_feat_tog_id && |.| ).
        ENDIF.
      ENDIF.
* End 'Start ongoing mocking for this session'

* Prepare action call

      REFRESH lt_step_log.
      DATA lv_run_time TYPE tzntstmpl.

      DATA(rfc_dest) = lo_ptf_run->get_rfc_destination(
        ptf_test_landscape = ptf_test_landscape
        ptf_bo = ls_step_data-bus_obj ).

      DATA msg TYPE c LENGTH 160.

      CALL FUNCTION 'PTF_INVOKE_ACTION'
        DESTINATION rfc_dest
        IMPORTING
          ev_run_time           = lv_run_time
          et_step_log           = lt_step_log
          ev_end_the_run        = lv_end_the_run
        CHANGING
          cs_step_data          = ls_step_data
          ct_step_data          = lt_step_data
          document_id           = document_id
          execution_status      = execution_status
          check_status          = check_status
          ptf_run_head          = ls_result
        EXCEPTIONS
          communication_failure = 1 MESSAGE msg
          system_failure        = 2 MESSAGE msg
          OTHERS                = 3.

      IF sy-subrc <> 0.
        IF sy-subrc = 3.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            INTO msg
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.
        lo_ptf_run->append_log( |RFC connection { rfc_dest } failed \n Error: { msg }| ).
        lv_end_the_run = abap_true.
      ENDIF.

      cl_ptf_step_attr=>delete_singleton(  ).

      lo_ptf_run->append_logs( lt_step_log  ).

      ls_step_data-check_flag = abap_true. "avoid double messages


    ENDIF.  "BO ptf_run vs. any PTF BO



    "Handle TDC error that occured 'below' the executed action
    IF cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~has_tdc_error( ) IS NOT INITIAL.
      lo_ptf_run->append_log( |TDC does not exist. ERROR.| ). "maybe put these two messages at the beginning of the step's log?
      CLEAR: check_status, execution_status.
      "cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~set_stop_run_after_step( abap_true ).
      lv_end_the_run = abap_true.
    ENDIF.

    IF cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~get_substituted_tdc_name( ) IS NOT INITIAL.
      lo_ptf_run->append_log( |!! Z-TDC { cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~get_substituted_tdc_name( ) } found, used this one !! | ).
    ENDIF.


    "Step data: Take over 2 status values, from action signature parameters
    IF ls_step_data-check_flag EQ abap_true.   "now using ls_step_data-check_flag which at runtime also considers RAP BOs
      ls_step_data-check_status     = check_status.
      ls_step_data-execution_status = execution_status.
    ELSE.
      ls_step_data-execution_status = execution_status.
      IF ls_step_data-action(5) EQ 'CHECK'.
        lo_ptf_run->append_log( |Action { ls_step_data-action } has name CHECK* but is not configured as Check action.| ).
      ENDIF.
    ENDIF.

    "Step data: Take over itab document_id from action signature parameters
    IF ls_step_data-is_manual EQ abap_false.
      "normal takeover of document IDs
      ls_step_data-document_id = document_id.
    ELSE.
      "manual entry feature is active for this step: do not overwrite ls_step_data-DOCUMENT_ID, keep the manually entered docID(s)
      ls_step_data-execution_status = abap_true.
      IF ls_step_data-check_flag EQ abap_true.
        ls_step_data-check_status = abap_true.  "check status successful is required, else the run would stop
      ENDIF.
      ASSERT document_id IS INITIAL.
    ENDIF.

    "Step data: Take over fields that are not in action signature
    DATA(act_messages) = cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~get_actual_messages( ).
    IF ls_step_data-act_messages IS INITIAL AND act_messages IS NOT INITIAL.
      MOVE-CORRESPONDING act_messages TO ls_step_data-act_messages.
    ELSEIF ls_step_data-act_messages IS INITIAL.
      ls_step_data-act_messages     = lo_ptf_run->get_step_data( iv_step_number = ls_step_data-step_number )-act_messages.
    ENDIF.
    DATA(data_object_json) = cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~get_tdo( ).
    IF ls_step_data-data_object_json IS INITIAL AND data_object_json IS NOT INITIAL.
      ls_step_data-data_object_json = data_object_json.
    ELSEIF ls_step_data-data_object_json IS INITIAL.
      ls_step_data-data_object_json = lo_ptf_run->get_step_data( iv_step_number = ls_step_data-step_number )-data_object_json.
    ENDIF.
    ls_step_data-is_pid           = lo_ptf_run->get_step_data( iv_step_number = ls_step_data-step_number )-is_pid.

    lo_ptf_run->log_step_end( ls_step_data ).

    "Export data of this step
    EXPORT s_step_data  = ls_step_data
      TO MEMORY ID 'CG__PTF_STEP'.

    "Export the log
    lt_step_log = lo_ptf_run->get_log( ).
    "lv_end_the_run = zcl_ptf_error=>get_stop_run_after_step( ).
    EXPORT t_log         = lt_step_log
           v_duration    = lv_run_time
           v_end_the_run = lv_end_the_run
      TO MEMORY ID 'CG__PTF_STEP_RESULT'.

    "Save the ID of the last touched doc to return it to external callers
    DATA lv_one_created_doc TYPE ptfkey.
    LOOP AT ls_step_data-document_id INTO lv_one_created_doc.
    ENDLOOP.
    EXPORT created_doc = lv_one_created_doc TO MEMORY ID 'PTF_LAST_CREATED_DOC'.

    cl_ptf_run=>set_not_running( lv_run_uuid ).

  ENDMETHOD.


  METHOD setup.

    CHECK 1 = 1.

  ENDMETHOD.


  METHOD teardown.

  ENDMETHOD.
ENDCLASS.
