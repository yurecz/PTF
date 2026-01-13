CLASS cl_ptf_unit_testing DEFINITION
  PUBLIC
  INHERITING FROM cl_ptf_bo
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS: c_do_something_exec    TYPE string VALUE 'DO_STH_EXEC',
               c_do_something_check   TYPE string VALUE 'DO_STH_CHECK',
               c_process_prev_doc_ids TYPE string VALUE 'PROC_PRE_DOC_IDS',
               c_exp                  TYPE String VALUE 'EXCEPTION'.

    TYPES: BEGIN OF ty_ptf_process_result,
             doc_ids      TYPE cl_ptf_util=>ty_vbeln_tab,
             exec_status  TYPE abap_bool,
             check_status TYPE abap_bool,
             log          TYPE cl_ptf_util=>gt_ptf_return_tab,
           END OF ty_ptf_process_result.

    METHODS change
        REDEFINITION .
    METHODS check
        REDEFINITION .
    METHODS check_existence
        REDEFINITION .
    METHODS create
        REDEFINITION .
    METHODS delete
        REDEFINITION .
    METHODS execute_action
        REDEFINITION .
    METHODS execute_check
        REDEFINITION .

  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS do_something_exec
      IMPORTING
        !ls_step_data        TYPE cl_ptf_util=>gt_ptf_step
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .
    METHODS exp
      IMPORTING
        !ls_step_data        TYPE cl_ptf_util=>gt_ptf_step
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .
    METHODS process_prev_doc_ids
      IMPORTING
        !ls_step_data        TYPE cl_ptf_util=>gt_ptf_step
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .
    METHODS do_something_check
      IMPORTING
        !ls_step_data        TYPE cl_ptf_util=>gt_ptf_step
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .

ENDCLASS.



CLASS CL_PTF_UNIT_TESTING IMPLEMENTATION.


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


  METHOD do_something_check.
    DATA: what_to_return TYPE ty_ptf_process_result.
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = what_to_return
    ).

    ev_execution_status = what_to_return-exec_status.
    ev_check_status = what_to_return-check_status.
    ev_document_id = what_to_return-doc_ids.

    LOOP AT what_to_return-log ASSIGNING FIELD-SYMBOL(<log>).
      me->mo_run_environment->append_log( iv_log_statement = |{ <log>-message }| ).
    ENDLOOP.
  ENDMETHOD.


  METHOD do_something_exec.
    DATA: what_to_return TYPE ty_ptf_process_result.
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = what_to_return
    ).

    ev_execution_status = what_to_return-exec_status.
    ev_check_status = what_to_return-check_status.
    ev_document_id = what_to_return-doc_ids.

    LOOP AT what_to_return-log ASSIGNING FIELD-SYMBOL(<log>).
      me->mo_run_environment->append_log( iv_log_statement = |{ <log>-message }| ).
    ENDLOOP.

  ENDMETHOD.


  METHOD execute_action.
    DATA(lv_step_data) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).
    CASE lv_step_data-action.
      WHEN c_do_something_exec.
        me->do_something_exec(
          EXPORTING
            ls_step_data        = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_process_prev_doc_ids.
        me->process_prev_doc_ids(
          EXPORTING
            ls_step_data        = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_exp.
        me->exp(
          EXPORTING
            ls_step_data        = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN OTHERS.
        me->mo_run_environment->append_log( iv_log_statement =  |Could not find method { lv_step_data-action } for the BO { lv_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.
    ENDCASE.
  ENDMETHOD.


  METHOD execute_check.
    DATA(lv_step_data) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).
    CASE lv_step_data-action.
      WHEN c_do_something_check.
        me->do_something_check(
          EXPORTING
            ls_step_data        = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN OTHERS.
        me->mo_run_environment->append_log( iv_log_statement =  |Could not find method { lv_step_data-action } for the BO { lv_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.
    ENDCASE.
  ENDMETHOD.


  METHOD exp.
    me->do_something_exec(
      EXPORTING
        ls_step_data        = ls_step_data
        iv_step_number      = iv_step_number
      IMPORTING
        ev_document_id      = ev_document_id
        ev_execution_status = ev_execution_status
        ev_check_status     = ev_check_status
    ).

    RAISE EXCEPTION TYPE cx_ble_runtime_error.
  ENDMETHOD.


  METHOD process_prev_doc_ids.
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(doc_ids) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      APPEND LINES OF doc_ids TO ev_document_id.
    ENDLOOP.


    DATA: what_to_return TYPE ty_ptf_process_result.
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = what_to_return
    ).

    ev_execution_status = what_to_return-exec_status.
    ev_check_status = what_to_return-check_status.

    LOOP AT what_to_return-log ASSIGNING FIELD-SYMBOL(<log>).
      me->mo_run_environment->append_log( iv_log_statement = |{ <log>-message }| ).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
