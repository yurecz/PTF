CLASS cl_ptf_bo_ptf DEFINITION
  PUBLIC
  INHERITING FROM cl_ptf_bo
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF gty_bo,
        bo TYPE ptf_bo,
      END OF gty_bo .
    TYPES:
      gty_bo_tab TYPE TABLE OF gty_bo WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_check_bos,
        expected_bd_types TYPE gty_bo_tab,
      END OF ty_check_bos.


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

    CONSTANTS: c_check_existing_bos TYPE string VALUE 'CHECK_EXISTING_BOS'.


    METHODS check_existing_bos
      IMPORTING
        !step_data           TYPE        cl_ptf_util=>gt_ptf_step "Parameter for better performance
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .
ENDCLASS.



CLASS CL_PTF_BO_PTF IMPLEMENTATION.


  METHOD change.

  ENDMETHOD.


  METHOD check.

  ENDMETHOD.


  METHOD check_existence.
  ENDMETHOD.


  METHOD check_existing_bos.
    DATA: registered_bos TYPE HASHED TABLE OF ptf_bo WITH UNIQUE KEY table_line,
          test_data      TYPE ty_check_bos.

    ev_check_status = abap_true.
    ev_execution_status = abap_false.
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
       es_testdata  = test_data ).

    SELECT ptf_bo FROM ptfbo INTO TABLE @registered_bos.

    LOOP AT registered_bos ASSIGNING FIELD-SYMBOL(<registered_bo>).
      READ TABLE test_data-expected_bd_types WITH TABLE KEY bo = <registered_bo> TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        me->mo_run_environment->append_log( iv_log_statement = |The BO { <registered_bo> } is registered on DB but isn't expected. Please check wheather duplicate or new.| ).
      ENDIF.
    ENDLOOP.
    ev_execution_status = abap_true.
  ENDMETHOD.


  METHOD create.
  ENDMETHOD.


  METHOD delete.

  ENDMETHOD.


  METHOD execute_action.

  ENDMETHOD.


  METHOD execute_check.
    DATA(lv_step_data) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).

    CASE lv_step_data-action.
      WHEN c_check_existing_bos.
        me->check_existing_bos(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN OTHERS.
        me->mo_run_environment->append_log( iv_log_statement =  |Could not find method { lv_step_data-action } for the BO { lv_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
