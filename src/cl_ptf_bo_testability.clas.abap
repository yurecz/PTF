CLASS cl_ptf_bo_testability DEFINITION
  PUBLIC
  INHERITING FROM cl_ptf_bo
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
* Structure for External Billing Document Request Create
      BEGIN OF ty_gs_i_ptf_ebdr_cr_td,
        ebdr_request_in   TYPE bapiebdrrequest_t,
        ebdr_requ_cond_in TYPE bapiebdrrequestcond_t,
        ebdr_requ_text_in TYPE bapiebdrrequesttext_t,
      END OF ty_gs_i_ptf_ebdr_cr_td .


    METHODS constructor
      IMPORTING iv_run_environment TYPE REF TO cl_ptf_run.
    METHODS create REDEFINITION .
    METHODS change REDEFINITION .
    METHODS delete REDEFINITION .
    METHODS check REDEFINITION .
    METHODS execute_action REDEFINITION .
    METHODS execute_check REDEFINITION .
    METHODS check_existence REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA: bo_dao  TYPE REF TO lif_ptf_bo_api_dao,
          ptf_dao TYPE REF TO lif_ptf_default_actions_dao.

ENDCLASS.



CLASS CL_PTF_BO_TESTABILITY IMPLEMENTATION.


  METHOD change.
  ENDMETHOD.


  METHOD check.
  ENDMETHOD.


  METHOD check_existence.
  ENDMETHOD.


  METHOD constructor.
    super->constructor( iv_run_environment = iv_run_environment ).
    me->bo_dao = NEW lcl_ptf_bo_api_prod_dao_impl( ).
    me->ptf_dao = NEW lcl_ptf_def_act_prod_dao_impl( iv_run_environment = iv_run_environment ).
  ENDMETHOD.


  METHOD create.
    DATA:
      ls_testdata                  TYPE ty_gs_i_ptf_ebdr_cr_td,
      lt_ebdr_request_in           TYPE bapiebdrrequest_t, "sdbil_ebdr_request_t,
      lt_ebdr_request_condition_in TYPE bapiebdrrequestcond_t,
      lt_ebdr_ids                  TYPE bapiebdrrequestextbilldocreq_t,
      lv_vgbel                     TYPE vbeln,
      ls_administration_data       TYPE bapiebdrrequestadmin,
      ls_control_data              TYPE bapiebdrrequestctrl,
      lt_success_ebdrs             TYPE bapiebdrrequestresult_t,
      lt_failed_ebdrs              TYPE bapiebdrrequestfailed_t,
      lt_return                    TYPE TABLE OF bapiret2,
      lv_log_message               TYPE string.

******************************************************************************
* 1.  Get data from tdc
    DATA(ls_current_step) = me->ptf_dao->get_step_data( iv_step_number = iv_step_number ).
    me->ptf_dao->get_testdata(
      EXPORTING
        is_step_data = ls_current_step
      IMPORTING
        es_testdata  = ls_testdata
    ).

*****************************************************************************
* 2 Step: Prepare data for BAPI call
    CLEAR: lt_ebdr_request_in, ls_administration_data.
    MOVE ls_testdata-ebdr_request_in TO lt_ebdr_request_in.
    MOVE ls_testdata-ebdr_requ_cond_in TO lt_ebdr_request_condition_in.

*    fill senderlogicalsystem with name of test data container variable to identify EBDR document as created by PTF Framework
    ls_administration_data-senderlogicalsystem = ls_current_step-variant.

    CONCATENATE sy-datlo+4(4) sy-uzeit INTO lv_vgbel.

*    fill date and time into preceding_document_id to get a unique ID.
    LOOP AT lt_ebdr_request_in ASSIGNING FIELD-SYMBOL(<ls_ebdr_request_in>).
      <ls_ebdr_request_in>-precedingdocument = lv_vgbel.
      LOOP AT lt_ebdr_request_condition_in ASSIGNING FIELD-SYMBOL(<ls_ebdr_request_condition_in>).
        <ls_ebdr_request_condition_in>-precedingdocument = lv_vgbel.
      ENDLOOP.
    ENDLOOP.

*****************************************************************************
* 3 Step: Create EBDR and commit
    ls_control_data-commit_mode = '2'. "Synchronous COMMIT to ensure data is on DB at check

    me->bo_dao->bapi_ebdr_createmultiple(
      EXPORTING
*        testrun                    = ' '
        is_control_data            = ls_control_data   " External Billing Document Request - Request - Control
        is_administration_data     = ls_administration_data    " External Billing Document Request - Request - Admin
        it_data                    = lt_ebdr_request_in
        it_condition_data          = lt_ebdr_request_condition_in
*        it_text_data               =
*        it_payment_card_data       =
      IMPORTING
        et_ebdrcreateddoc          = lt_ebdr_ids " External Billing Document Request - Request - IDs
        et_ebdrcreateddocitem      = lt_success_ebdrs   " External Billing Document Request - Request - Admin
        et_ebdrcreatefaileddocitem = lt_failed_ebdrs    " External Billing Document Request - precedingdoc items
*       et_message                 =     " External Billing Document Request - Request - Message
        return                     = lt_return
    ).

******************************************************************************
* 4 Step:  Copy messages to et_return
    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<et_return>).
      MOVE <et_return>-message TO lv_log_message.
      me->ptf_dao->append_log( iv_log_statement = lv_log_message ).
    ENDLOOP.

******************************************************************************
* 5 Step: Check if EBDR exists
    IF lt_failed_ebdrs IS INITIAL.
      IF lines( lt_success_ebdrs ) = lines( lt_ebdr_request_in ).
        ev_execution_status = abap_true.
        APPEND LINES OF lt_ebdr_ids TO ev_document_id.
      ELSE.
        ev_execution_status = abap_false.
        me->ptf_dao->append_log( iv_log_statement = 'Number of input and created data do not match.' ).
      ENDIF.
    ELSE.
      ev_execution_status = abap_false.
      LOOP AT lt_failed_ebdrs ASSIGNING FIELD-SYMBOL(<ls_failed_ebdrs>).
        me->ptf_dao->append_log( iv_log_statement = |No BDR document was created for precedingdocument: { <ls_failed_ebdrs>-precedingdocument }.| ).
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD delete.
  ENDMETHOD.


  METHOD execute_action.
  ENDMETHOD.


  METHOD execute_check.
  ENDMETHOD.
ENDCLASS.
