FUNCTION ptf_invoke_action.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     VALUE(EV_RUN_TIME) TYPE  TZNTSTMPL
*"     VALUE(ET_STEP_LOG) TYPE  BAPIRET2_TAB
*"     VALUE(EV_END_THE_RUN) TYPE  ABAP_BOOLEAN
*"  CHANGING
*"     VALUE(CS_STEP_DATA) TYPE  PTF_STEP
*"     VALUE(CT_STEP_DATA) TYPE  PTF_STEP_T
*"     VALUE(DOCUMENT_ID) TYPE  PTFKEY_VBELN_T
*"     VALUE(EXECUTION_STATUS) TYPE  ABAP_BOOLEAN
*"     VALUE(CHECK_STATUS) TYPE  ABAP_BOOLEAN
*"     VALUE(PTF_RUN_HEAD) TYPE  PTF_RUN_HEAD
*"----------------------------------------------------------------------
  DATA lo_bo                    TYPE REF TO object.
  DATA lv_method_name           TYPE ptf_act.

  DATA(lo_ptf_abap_memory) = NEW cl_ptf_abap_memory( ).
  lo_ptf_abap_memory->insert_run_head( ptf_run_head ).

  DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = ct_step_data ).
  lo_ptf_run->set_variant_name( ptf_run_head-variant ).

  DATA(lo_ptf_rap_metadata) = NEW cl_ptf_rap_metadata( ).
  DATA(lv_is_rap_bo) = lo_ptf_rap_metadata->check_rap_bo( cs_step_data-bus_obj ).

  SELECT SINGLE * FROM ptfbo INTO @DATA(ls_bo_db) WHERE ptf_bo = @cs_step_data-bus_obj.
  IF sy-subrc IS NOT INITIAL.
    IF lv_is_rap_bo = abap_off.
      lo_ptf_run->append_log( |BO not found in db table PTFBO. ERROR.| ).
      et_step_log = lo_ptf_run->get_log( ).
      RETURN. "!
    ENDIF.
  ENDIF.

  IF ls_bo_db-bo_class IS NOT INITIAL.
    DATA(lv_class_name) = |{ ls_bo_db-bo_class }|.
  ELSE.
    IF lv_is_rap_bo = abap_off.
      lv_class_name = |CL_PTF_BO_{ ls_bo_db-ptf_bo }|.
    ELSE.
      "RAP BO without PTFBO entry
      lv_class_name = |CL_PTF_BO_RAP_GENERIC|.
    ENDIF.
  ENDIF.

  DATA:
    ls_parameter_constructor TYPE abap_parmbind,
    lt_parameter_constructor TYPE abap_parmbind_tab.
  CLEAR: ls_parameter_constructor, lt_parameter_constructor.
  ls_parameter_constructor-kind = cl_abap_objectdescr=>exporting.
  ls_parameter_constructor-name =  'IV_RUN_ENVIRONMENT'.
  GET REFERENCE OF lo_ptf_run INTO ls_parameter_constructor-value.
  INSERT ls_parameter_constructor INTO TABLE lt_parameter_constructor.

  TRY.
      CREATE OBJECT lo_bo TYPE (lv_class_name) PARAMETER-TABLE lt_parameter_constructor.

    CATCH cx_sy_create_object_error INTO DATA(lx).
      lo_ptf_run->append_log( iv_log_statement = |Couldn't find the class { lv_class_name } for BO { ls_bo_db-ptf_bo }| ).
      et_step_log = lo_ptf_run->get_log( ).
      RETURN.
  ENDTRY.

  lo_ptf_run->prepare_action_call(
    IMPORTING
      ev_method_name   = lv_method_name
    CHANGING
      document_id      = document_id
      execution_status = execution_status
      check_status     = check_status
      is_step_data     = cs_step_data
    RECEIVING
      rt_parameter     = DATA(lt_parameter)
  ).

  DATA: lv_step_timestamp_start TYPE timestampl,
        lv_step_timestamp_end   TYPE timestampl.
  GET TIME STAMP FIELD lv_step_timestamp_start.

  DATA(info_for_debugging) = cs_step_data-step_number.

********************** Call the Action **************
  CALL METHOD lo_bo->(lv_method_name)
    PARAMETER-TABLE
    lt_parameter.
*****************************************************

  GET TIME STAMP FIELD lv_step_timestamp_end.
  ev_run_time = cl_abap_tstmp=>subtract( EXPORTING tstmp1 = lv_step_timestamp_end tstmp2 = lv_step_timestamp_start ).

  "Handle TDC error that occured 'below' the executed action
  IF cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~has_tdc_error( ) IS NOT INITIAL.
    lo_ptf_run->append_log( |TDC does not exist. ERROR.| ). "maybe put these two messages at the beginning of the step's log?
    CLEAR: check_status, execution_status.
    "cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~set_stop_run_after_step( abap_true ).
    ev_end_the_run = abap_true.
  ENDIF.

  IF cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~get_substituted_tdc_name( ) IS NOT INITIAL.
    lo_ptf_run->append_log( |!! Z-TDC { cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~get_substituted_tdc_name( ) } found, used this one !! | ).
  ENDIF.


  "Step data: Take over 2 status values, from action signature parameters
  IF cs_step_data-check_flag EQ abap_true.   "now using ls_step_data-check_flag which at runtime also considers RAP BOs
    cs_step_data-check_status     = check_status.
    cs_step_data-execution_status = execution_status.
  ELSE.
    cs_step_data-execution_status = execution_status.
    IF cs_step_data-action(5) EQ 'CHECK'.
      lo_ptf_run->append_log( |Action { cs_step_data-action } has name CHECK* but is not configured as Check action.| ).
    ENDIF.
  ENDIF.

  "Step data: Take over itab document_id from action signature parameters
  IF cs_step_data-is_manual EQ abap_false.
    "normal takeover of document IDs
    cs_step_data-document_id = document_id.
  ELSE.
    "manual entry feature is active for this step: do not overwrite ls_step_data-DOCUMENT_ID, keep the manually entered docID(s)
    cs_step_data-execution_status = abap_true.
    IF cs_step_data-check_flag EQ abap_true.
      cs_step_data-check_status = abap_true.  "check status successful is required, else the run would stop
    ENDIF.
    ASSERT document_id IS INITIAL.
  ENDIF.

  "Step data: Take over fields that are not in action signature
  DATA(act_messages) = cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~get_actual_messages( ).
  IF act_messages IS NOT INITIAL.
    MOVE-CORRESPONDING act_messages TO cs_step_data-act_messages.
  ELSE.
    cs_step_data-act_messages     = lo_ptf_run->get_step_data( iv_step_number = cs_step_data-step_number )-act_messages.
  ENDIF.
  DATA(data_object_json) = cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~get_tdo( ).
  IF data_object_json IS NOT INITIAL.
    cs_step_data-data_object_json = data_object_json.
  ELSE.
    cs_step_data-data_object_json = lo_ptf_run->get_step_data( iv_step_number = cs_step_data-step_number )-data_object_json.
  ENDIF.
  cs_step_data-is_pid           = lo_ptf_run->get_step_data( iv_step_number = cs_step_data-step_number )-is_pid.

  et_step_log = lo_ptf_run->get_log( ).

ENDFUNCTION.
