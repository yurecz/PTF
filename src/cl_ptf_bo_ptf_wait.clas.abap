class CL_PTF_BO_PTF_WAIT definition
  public
  inheriting from CL_PTF_BO
  final
  create public .

public section.

  methods CHANGE
    redefinition .
  methods CHECK
    redefinition .
  methods CHECK_EXISTENCE
    redefinition .
  methods CREATE
    redefinition .
  methods DELETE
    redefinition .
  methods EXECUTE_ACTION
    redefinition .
  methods EXECUTE_CHECK
    redefinition .
protected section.
private section.

  methods WAIT_UNTIL_LOCK_ENDED
    importing
      !IV_STEP_NUMBER type I
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !ET_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods WAIT_FOR_BO_CREATION_ON_DB
    importing
      !IV_STEP_NUMBER type I
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !ET_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
ENDCLASS.



CLASS CL_PTF_BO_PTF_WAIT IMPLEMENTATION.


  METHOD change.

  ENDMETHOD.


  METHOD check.

  ENDMETHOD.


  METHOD check_existence.

  ENDMETHOD.


  METHOD create.

  ENDMETHOD.


  METHOD delete.

  ENDMETHOD.


  METHOD execute_action.
    "currently there are no (non-check) actions

    CLEAR: ev_document_id, ev_execution_status, ev_check_status.

    "Error
    me->mo_run_environment->append_log( iv_log_statement =  |There are no Actions, only Check Actions, in this BO.| ).
    ev_execution_status = abap_false.

  ENDMETHOD.


  METHOD execute_check.

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).

    SELECT SINGLE * FROM ptfboa INTO @DATA(ls_ptfboa) WHERE ptf_bo = @ls_step_data-bus_obj AND ptf_act = @ls_step_data-action.
    IF ls_ptfboa-abap_method IS NOT INITIAL.

      "1. Use PTFBOA-ABAP_METHOD if filled
      TRY.
          CALL METHOD me->(ls_ptfboa-abap_method)
            EXPORTING
              step_data           = ls_step_data
              iv_step_number      = iv_step_number
            IMPORTING
              ev_document_id      = ev_document_id
              ev_execution_status = ev_execution_status
              ev_check_status     = ev_check_status.
        CATCH cx_sy_dyn_call_illegal_method INTO DATA(lx_methodcall).
          me->mo_run_environment->append_log( iv_log_statement = |Couldn't find the method { ls_ptfboa-abap_method } from PTFBOA for BO { ls_step_data-bus_obj }| ).
          ev_execution_status = abap_false.
          ev_check_status = abap_false.
      ENDTRY.

      RETURN.

    ENDIF.


    "2. If there is a method with the same name as the action, call it
    DATA(lo_description) = CAST cl_abap_classdescr( cl_abap_typedescr=>describe_by_object_ref( me ) ).
    READ TABLE lo_description->methods WITH TABLE KEY primary_key COMPONENTS name = ls_step_data-action INTO DATA(ls).
    IF sy-subrc IS INITIAL.
      TRY.
          CALL METHOD me->(ls_step_data-action)
            EXPORTING
              is_step_data        = ls_step_data
              iv_step_number      = iv_step_number
            IMPORTING
              et_document_id      = ev_document_id
              ev_execution_status = ev_execution_status
              ev_check_status     = ev_check_status.
        CATCH cx_sy_dyn_call_illegal_method INTO lx_methodcall.
          DATA lt_callstack TYPE abap_callstack.
          CALL FUNCTION 'SYSTEM_CALLSTACK'
            EXPORTING
              max_level = 1
            IMPORTING
              callstack = lt_callstack.
          DATA(lv_method) = lt_callstack[ 1 ]-blockname.
          me->mo_run_environment->append_log( iv_log_statement = |Dynamic call out of { lv_method }, based on action name { ls_step_data-action }, failed. { cl_abap_classdescr=>get_class_name( me ) }| ).
          ev_execution_status = abap_false.
          ev_check_status = abap_false.
      ENDTRY.

      RETURN.

    ENDIF.



    "Error
    me->mo_run_environment->append_log( iv_log_statement =  |Could not find a method for { ls_step_data-action } of BO { ls_step_data-bus_obj }.| ).
    ev_execution_status = abap_false.
    ev_check_status = abap_false.
    RETURN.


  ENDMETHOD.


  METHOD wait_for_bo_creation_on_db.

    DATA lt_ptf_keys TYPE cl_ptf_util=>ty_vbeln_tab.

    CLEAR et_document_id.
    ev_check_status = abap_false.
    ev_execution_status = abap_false.

    "get document number(s) from reference step(s)
    LOOP AT is_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys_one_step) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      IF lt_ptf_keys_one_step IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |No documents found for reference step { <lv_ref_step> }| ).
      ENDIF.
      APPEND LINES OF lt_ptf_keys_one_step TO lt_ptf_keys.
    ENDLOOP.
    IF lt_ptf_keys IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Nothing to check.| ).
      RETURN.
    ENDIF.


  ENDMETHOD.


  METHOD wait_until_lock_ended.

    DATA lt_ptf_keys TYPE cl_ptf_util=>ty_vbeln_tab.

    CLEAR et_document_id.
    ev_check_status = abap_false.
    ev_execution_status = abap_false.

    "get document number(s) from reference step(s)
    LOOP AT is_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys_one_step) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      IF lt_ptf_keys_one_step IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |No documents found for reference step { <lv_ref_step> }| ).
      ENDIF.
      APPEND LINES OF lt_ptf_keys_one_step TO lt_ptf_keys.
    ENDLOOP.
    IF lt_ptf_keys IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Nothing to check.| ).
      RETURN.
    ENDIF.


  ENDMETHOD.
ENDCLASS.
