CLASS cl_ptf_bo_bil_pay DEFINITION
  PUBLIC
  INHERITING FROM cl_ptf_bo
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

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

    TYPES: BEGIN OF ty_inc_pay_for_cust,
             bukrs TYPE bukrs,
             blart TYPE blart,
             waers TYPE waers,
             kursf TYPE kursf,
             koart TYPE koart,
             konko TYPE konko,
             shkzg TYPE shkzg,
             wrbtr TYPE wrbtr,
           END OF ty_inc_pay_for_cust.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS: c_inc_pay_for_cust TYPE String VALUE 'INC_PAY_FOR_CUST'.

    METHODS inc_pay_for_cust
      IMPORTING
        !ls_step_data        TYPE cl_ptf_util=>gt_ptf_step
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .

ENDCLASS.



CLASS CL_PTF_BO_BIL_PAY IMPLEMENTATION.


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
    DATA(lv_step_data) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).
    CASE lv_step_data-action.
      WHEN c_inc_pay_for_cust.
        me->inc_pay_for_cust(
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
  ENDMETHOD.


  METHOD inc_pay_for_cust.
    DATA: clearing_header       TYPE cl_fdc_clearing_document_inf=>ty_clearing_header,
          apar_items_to_be_clrd TYPE cl_fdc_clearing_document_inf=>tty_apar_item_to_be_clrd,
          apar_item_to_be_clrd  TYPE cl_fdc_clearing_document_inf=>ty_apar_item_to_be_clrd,
          gl_items_to_be_clrd   TYPE cl_fdc_clearing_document_inf=>tty_gl_item_to_be_clrd,
          gl_item_to_be_clrd    TYPE cl_fdc_clearing_document_inf=>ty_gl_item_to_be_clrd,
          apar_items_on_account TYPE cl_fdc_clearing_document_inf=>tty_apar_item_on_account,
          apar_item_on_account  TYPE cl_fdc_clearing_document_inf=>ty_apar_item_on_account,
          posted_document       TYPE fdc_s_accdoc_hdr_key_odata,
          messages              TYPE bapirettab,
          error_occured         TYPE abap_bool,
          test_data             TYPE ty_inc_pay_for_cust.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = test_data
    ).

    clearing_header-bukrs = test_data-bukrs.
    clearing_header-blart = test_data-blart.
    clearing_header-budat = sy-datum.
    clearing_header-bldat = sy-datum.
    clearing_header-waers = test_data-waers.
    clearing_header-kursf = test_data-kursf.

    apar_item_to_be_clrd-bukrs = test_data-bukrs.
    apar_item_to_be_clrd-koart = test_data-koart.
    apar_item_to_be_clrd-konko = test_data-konko.
    apar_item_to_be_clrd-gjahr = sy-datum(4).
    APPEND apar_item_to_be_clrd TO apar_items_to_be_clrd.

    apar_item_on_account-koart = test_data-koart.
    apar_item_on_account-konko = test_data-konko.
    apar_item_on_account-shkzg = test_data-shkzg.
    apar_item_on_account-wrbtr = test_data-wrbtr.
    APPEND apar_item_on_account TO apar_items_on_account.

    NEW cl_fdc_clearing_Document_inf( )->post(
    EXPORTING
      is_clearing_header      =    clearing_header
      it_apar_item_to_be_clrd =    apar_items_to_be_clrd
      it_gl_item_to_be_clrd   =    gl_items_to_be_clrd
      it_apar_item_on_account =    apar_items_on_account
      iv_test_run             =    abap_false
    IMPORTING
      es_posted_document      =    posted_document
      et_message              =    messages
    RECEIVING
      rv_error_occured        =    error_occured
    ).

    IF error_occured EQ abap_true.
      ev_execution_status = abap_false.
      ROLLBACK WORK.
    ELSE.
      COMMIT WORK AND WAIT.
    ENDIF.

    me->mo_run_environment->append_log( iv_log_statement = |Tried to create incoming payment for customer { test_data-konko }. Error occured: { error_occured }| ).
    LOOP AT messages ASSIGNING FIELD-SYMBOL(<message>).
      me->mo_run_environment->append_log_structure( is_log =  <message> ).
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
