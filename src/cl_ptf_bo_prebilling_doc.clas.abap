class CL_PTF_BO_PREBILLING_DOC definition
  public
  inheriting from CL_PTF_BO
  final
  create public .

public section.

  types:
* Structure for changing texts in PBDF
    ty_thead_tab  TYPE STANDARD TABLE OF thead WITH DEFAULT KEY .
  types:
    ty_lines_tab TYPE STANDARD TABLE OF tline WITH DEFAULT KEY .
  types:
** Preliminary Billing Document Add manual Item
    ty_komfk_pbd_manual_tab TYPE STANDARD TABLE OF komfk_pbd_manual .
  types:
    BEGIN OF ty_gs_i_ptf_pbd_chtxt_td,
        lt_thead      TYPE ty_thead_tab,
        lt_lines_head TYPE ty_lines_tab,
        lt_lines_item TYPE ty_lines_tab,
      END OF ty_gs_i_ptf_pbd_chtxt_td .
  types:
    BEGIN OF ty_gs_i_ptf_pbd_appr_action_id,
        action TYPE if_sd_apm_approval=>tcd_approval_action,
      END OF ty_gs_i_ptf_pbd_appr_action_id .
  types:
* Structure Preliminary Billing Documents Activate
    BEGIN OF ty_gs_i_ptf_pbd_ac_dte,
        invoice_date                 TYPE fkdat,
      END OF ty_gs_i_ptf_pbd_ac_dte .
  types:
    BEGIN OF ty_gs_item_pprctr,
      item_number           TYPE posnr,
      partner_profit_center TYPE pprctr,
    END OF ty_gs_item_pprctr,
    item_pprctr_tab TYPE STANDARD TABLE OF ty_gs_item_pprctr WITH DEFAULT KEY,
    BEGIN OF ty_gs_bd_item_pprctr_check,
      item_pprctr_check     TYPE item_pprctr_tab,
    END OF ty_gs_bd_item_pprctr_check.

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
  PROTECTED SECTION.
private section.

  constants C_FUNCTION_NAME_SET_PROGRESS type STRING value 'SetToInProgress' ##NO_TEXT.
  constants C_FUNCTION_NAME_REJECT_PBD type STRING value 'RejectPreliminaryBillingDocument' ##NO_TEXT.
  constants C_FUNCTION_NAME_FINALIZE type STRING value 'Finalize' ##NO_TEXT.
  constants C_FUNCTION_NAME_COPY_PRE_BIL type STRING value 'CopyPreliminaryBillingDocument' ##NO_TEXT.
  constants C_ODATA_GET_OBJECT_PAGE_DATA type STRING value 'ODATA_GET_OBJECT_PAGE_DATA' ##NO_TEXT.
  constants C_ODATA_POST_COMPARE_PRE_BIL type STRING value 'ODATA_POST_COMPARE_PRE_BIL' ##NO_TEXT.
  constants C_ODATA_POST_CREATE_PRE_BIL type STRING value 'ODATA_POST_CREATE_PRE_BILLING' ##NO_TEXT.
  constants C_ODATA_POST_SET_IN_PROGRESS type STRING value 'ODATA_POST_SET_TO_IN_PROGRESS' ##NO_TEXT.
  constants C_ODATA_POST_REJECT_PBD type STRING value 'ODATA_POST_REJECT_PRE_BIL_DOC' ##NO_TEXT.
  constants C_ODATA_POST_FINALIZE type STRING value 'ODATA_POST_FINALIZE' ##NO_TEXT.
  constants C_ODATA_POST_CREATE_BIL type STRING value 'ODATA_POST_CREATE_BIL' ##NO_TEXT.
  constants C_ODATA_POST_COPY_PRE_BIL type STRING value 'ODATA_POST_COPY_PRE_BIL' ##NO_TEXT.
  constants C_ODATA_GET_WORK_LIST type STRING value 'ODATA_GET_PRE_BIL_WORK_LIST' ##NO_TEXT.
  constants C_CHECK_EXPECTED_DOC_QUANTITY type STRING value 'CHECK_EXPECTED_DOC_QUANTITY' ##NO_TEXT.
  constants C_CHECK_VKDFS type STRING value 'CHECK_VKDFS' ##NO_TEXT.
  constants C_ACTIVATE type STRING value 'ACTIVATE' ##NO_TEXT.
  constants C_ADD_ITEMS type STRING value 'ADD_ITEMS' ##NO_TEXT.
  constants C_ADD_MANUAL_ITEM type STRING value 'ADD_MANUAL_ITEM' ##NO_TEXT.
  constants C_ADD_TEXT type STRING value 'ADD_TEXT' ##NO_TEXT.
  constants C_COPY type STRING value 'COPY' ##NO_TEXT.
  constants C_FINALIZE type STRING value 'FINALIZE' ##NO_TEXT.
  constants C_REJECT type STRING value 'REJECT' ##NO_TEXT.
  constants C_SETINPROGRESS type STRING value 'SETINPROGRESS' ##NO_TEXT.
  constants C_RAISE_APPROVAL_ACTION type STRING value 'RAISE_APPROVAL_ACTION' ##NO_TEXT.
  constants C_WITHDRAW_FROM_APPROVAL type STRING value 'WITHDRAW_FROM_APPROVAL' ##NO_TEXT.
  constants C_RELEASE type STRING value 'RELEASE' ##NO_TEXT.
  constants C_CREATE_VIA_ODATA type STRING value 'CREATE_VIA_ODATA' ##NO_TEXT.
  constants C_SCHEDULE_PBD_CREATION type STRING value 'SCHEDULE_PBD_CREATION' ##NO_TEXT.
  constants C_LOG_STATUS type STRING value 'LOG_STATUS' ##NO_TEXT.
  constants C_CHECK_PBD_ITEM_PPRCTR type STRING value 'CHECK_PBD_ITEM_PPRCTR' ##NO_TEXT.

  methods SCHEDULE_PBD_CREATION
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_VIA_ODATA
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods GET_MESSAGE_TEXT
    importing
      !IT_MESSAGE type IF_SD_BIL_TYPE_DEF=>TT_MESSAGE .
  methods ACTIVATE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ADD_ITEMS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ADD_MANUAL_ITEM
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ADD_TEXT
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods COPY
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods FINALIZE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods REJECT
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods SETINPROGRESS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_EXPECTED_DOC_QUANTITY
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_VKDFS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_GET_OBJECT_PAGE_DATA
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_POST_COMPARE_PRE_BIL
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_POST_CREATE_PRE_BILLING
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_POST_SET_TO_IN_PROGRESS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_POST_REJECT_PRE_BIL_DOC
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_POST_FINALIZE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_POST_CREATE_BIL
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_POST_COPY_PRE_BIL
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_GET_PRE_BIL_WORK_LIST
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_F2875_FI_POST
    importing
      !IV_FUNCTION_NAME type STRING
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods RAISE_APPROVAL_ACTION
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods WITHDRAW_FROM_APPROVAL
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods RELEASE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods LOG_STATUS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_PBD_ITEM_PPRCTR
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
ENDCLASS.



CLASS CL_PTF_BO_PREBILLING_DOC IMPLEMENTATION.


  METHOD activate.
    TYPES:
      BEGIN OF ty_billing_instruction,
        id                     TYPE vbeln,
        item_id                TYPE posnr,
        billing_doc_type       TYPE fkart,
        sd_document_category   TYPE vbtypl,
        billing_requested_date TYPE fkdat_bis,
      END OF ty_billing_instruction ,
      BEGIN OF ty_draft_vbeln,
        vbeln TYPE ptfkey,
      END OF ty_draft_vbeln ,
      tt_draft_vbeln TYPE STANDARD TABLE OF ty_draft_vbeln WITH DEFAULT KEY.

    DATA:
      ls_return            TYPE bapiret2,
      lt_return            TYPE TABLE OF bapiret2,
      lt_prebilling_number TYPE tt_draft_vbeln,
      ls_prebilling_number TYPE ty_draft_vbeln,
      lv_vbeln             TYPE vbeln,
      lt_message           TYPE if_sd_bil_type_def=>tt_message,
      lt_billing_doc       TYPE if_sd_bil_type_def=>tt_billing_document,
      ls_testdata          TYPE ty_gs_i_ptf_pbd_ac_dte.

*****************************************************************************
* 1 Step: Prepare data for BAPI call

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    IF ls_step_data-variant IS NOT INITIAL.
      cl_ptf_util=>get_testdata(
        EXPORTING
          is_step_data = ls_step_data
        IMPORTING
          es_testdata  = ls_testdata
      ).
    ENDIF.

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_prebilling_number.
    ENDLOOP.

    IF lt_prebilling_number IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No PBDs given to activate.| ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.

*    #########################################################################################################################
*Workarround to refresh sales doc.. This function call has to be done in RV_INVOICE_REFRESG
    CALL FUNCTION 'SD_BUFFER_TABLES_REFRESH'.
*    #########################################################################################################################

*****************************************************************************
* 2 Step: Reject and commit Prebilling Doc

    TYPES:
      BEGIN OF ty_vbeln_orig,
        vbeln TYPE vbeln,
      END OF ty_vbeln_orig.
    DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.
    MOVE lt_prebilling_number TO lt_vbeln_key.

    cl_sd_bil_prebilling_facade=>if_sd_bil_prebilling_action~activate(
      EXPORTING
        it_draft_document    = lt_vbeln_key   " TableType Of A Draft Billing Document
        iv_invoice_date      = ls_testdata-invoice_date
        iv_release_requested = abap_true
        iv_posting           = 'D'
      IMPORTING
        et_billing_document  = lt_billing_doc " Table Type Of A Billing Document
        et_message           = lt_message  ).

    LOOP AT lt_prebilling_number INTO ls_prebilling_number.
      TYPES:
        BEGIN OF ty_billing_document,
          vbeln TYPE vbeln,
        END OF ty_billing_document .
      DATA: lv_vbeln_key TYPE ty_billing_document.
      MOVE ls_prebilling_number-vbeln TO lv_vbeln_key-vbeln.
      DELETE TABLE lt_billing_doc FROM lv_vbeln_key.
    ENDLOOP.

    me->get_message_text( it_message = lt_message ).

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

******************************************************************************
* 3 Step: Check if EBDR exists
    CLEAR lv_vbeln.
    LOOP AT lt_billing_doc INTO lv_vbeln.
      DATA: lv_ptf_key TYPE ptfkey.
      MOVE lv_vbeln TO lv_ptf_key.
      ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).
      IF ev_execution_status = abap_false.
        RETURN.
      ELSE.
        APPEND lv_ptf_key TO ev_document_id.
      ENDIF.
    ENDLOOP.

    IF ev_document_id IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No documents were created.| ).
      IF lt_message IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |No log was created.| ).
      ENDIF.
      me->mo_run_environment->append_log( iv_log_statement = |sy-subrc = { sy-subrc }| ).
      me->mo_run_environment->append_log( iv_log_statement = |sy-msgid = { sy-msgid }| ).
      me->mo_run_environment->append_log( iv_log_statement = |sy-msgno = { sy-msgno }| ).
      me->mo_run_environment->append_log( iv_log_statement = |sy-msgty  = { sy-msgty }| ).
      me->mo_run_environment->append_log( iv_log_statement = |sy-msgv1 = { sy-msgv1 }| ).
      me->mo_run_environment->append_log( iv_log_statement = |sy-msgv2 = { sy-msgv2 }| ).
      me->mo_run_environment->append_log( iv_log_statement = |sy-msgv3 = { sy-msgv3 }| ).
      me->mo_run_environment->append_log( iv_log_statement = |sy-msgv4 = { sy-msgv4 }| ).
    ENDIF.

  ENDMETHOD.


  METHOD add_items.
    DATA:
      ls_return            TYPE bapiret2,
      lt_return            TYPE TABLE OF bapiret2,
      lt_document_id       TYPE tt_vbeln,
      ls_document_id       TYPE vbeln,
      lt_prebilling_number TYPE tt_vbeln_vf,
      lv_prebilling_number TYPE vbeln_vf,
      lv_vbeln             TYPE vbeln,
      lt_message           TYPE if_sd_bil_type_def=>tt_message,
      lt_billing_doc       TYPE if_sd_bil_type_def=>tt_billing_document.

*****************************************************************************
* 1 Step: Prepare data for API call
*    CALL METHOD cl_ptf_template=>get_predecessor_vbeln " cannot be used, BO needed


    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      DATA(ref_step_data) = me->mo_run_environment->get_step_data( iv_step_number = <lv_ref_step> ).
      IF ref_step_data-bus_obj = 'PREBILLING_DOC'.
        APPEND LINES OF lt_ptf_keys TO lt_prebilling_number.
      ELSE.
        APPEND LINES OF lt_ptf_keys TO lt_document_id.
      ENDIF.
    ENDLOOP.

*****************************************************************************
* 2 Step: Add reference documents (from billing index) to Prebilling Doc
    LOOP AT lt_prebilling_number INTO lv_prebilling_number.
      CALL METHOD cl_sd_bil_prebilling_facade=>if_sd_bil_prebilling_action~add
        EXPORTING
          it_document_id      = lt_document_id
          iv_billing_document = lv_prebilling_number
          iv_posting          = 'D'
        IMPORTING
          et_message          = lt_message.
    ENDLOOP.

*****************************************************************************
* 3 Step: Commit and fill et_return
    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

    me->get_message_text( it_message = lt_message ).

******************************************************************************
* 4 Step: Check if PBD exists
    CLEAR lv_vbeln.
    LOOP AT lt_prebilling_number INTO lv_vbeln.
      DATA: lv_ptf_key TYPE ptfkey.
      MOVE lv_vbeln TO lv_ptf_key.
      ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).
      IF ev_execution_status = abap_false.
        RETURN.
      ELSE.
        APPEND lv_ptf_key TO ev_document_id.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD add_manual_item.
    DATA:
      ls_return           TYPE bapiret2,
      lt_return           TYPE TABLE OF bapiret2,
      lt_document_id      TYPE cl_ptf_util=>ty_vbeln_tab,
      lv_document_id      TYPE vbeln,
      lt_message          TYPE if_sd_bil_type_def=>tt_message,
      lt_billing_doc      TYPE if_sd_bil_type_def=>tt_billing_document,
      lt_komfk_pbd_manual TYPE ty_komfk_pbd_manual_tab,
      ls_komfk_pbd_manual TYPE LINE OF ty_komfk_pbd_manual_tab,
      lv_wbs_external_id  TYPE prps-posid.
*****************************************************************************
* 1 Step:
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_document_id.
    ENDLOOP.
*****************************************************************************
* 2 Step:
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = lt_komfk_pbd_manual
    ).
*****************************************************************************
* 3 Step:
    LOOP AT lt_document_id INTO lv_document_id.
      LOOP AT lt_komfk_pbd_manual INTO ls_komfk_pbd_manual.

        SELECT SINGLE fkart, vkorg, vtweg, waerk FROM vbrk INTO @DATA(ls_pbd_data)
                     WHERE vbeln = @lv_document_id .

        "Replace entered WBS with any one in VBRP because WBS is generated in time.
        IF lv_wbs_external_id IS INITIAL.
          SELECT SINGLE wbs~wbselementexternalid
            FROM vbrp INNER JOIN i_wbselementbasicdata WITH PRIVILEGED ACCESS AS wbs ON vbrp~ps_psp_pnr = wbs~wbselementinternalid
            WHERE vbrp~vbeln = @lv_document_id AND vbrp~ps_psp_pnr IS NOT INITIAL
            INTO @lv_wbs_external_id.
        ENDIF.
        ls_komfk_pbd_manual-ps_posid = lv_wbs_external_id.

        ls_komfk_pbd_manual-fkart = ls_pbd_data-fkart.
        ls_komfk_pbd_manual-vkorg = ls_pbd_data-vkorg.
        ls_komfk_pbd_manual-vtweg = ls_pbd_data-vtweg.
        ls_komfk_pbd_manual-waers = ls_pbd_data-waerk.

        CALL METHOD cl_sd_bil_prebilling_facade=>if_sd_bil_prebilling_action~man_add
          EXPORTING
            iv_document_id      = lv_document_id   " Billing Document
            is_komfk_pbd_manual = ls_komfk_pbd_manual                " PBD: Add manual item input fields
            iv_posting          = 'B'              " Posting
          IMPORTING
            et_message          = lt_message.                   " Table Type Of Error Messages

        COMMIT WORK AND WAIT.
        "Wait 5 seconds due to instable system
        WAIT UP TO 5 SECONDS.

      ENDLOOP.
    ENDLOOP.
*****************************************************************************
* 4 Step:
    me->get_message_text( it_message = lt_message ).

    ev_execution_status = abap_true.
    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ls_message>).
      IF <ls_message>-type = 'E'.
        ev_execution_status = abap_false.
      ENDIF.
      me->mo_run_environment->append_log( iv_log_statement = |{ <ls_message>-message }| ).
    ENDLOOP.
    APPEND LINES OF lt_document_id TO ev_document_id.
  ENDMETHOD.


  METHOD add_text.
    TYPES:
      BEGIN OF ty_draft_vbeln,
        vbeln TYPE ptfkey,
      END OF ty_draft_vbeln ,
      tt_draft_vbeln TYPE STANDARD TABLE OF ty_draft_vbeln WITH DEFAULT KEY.

    DATA:
      lt_prebilling_number TYPE tt_draft_vbeln,
      lt_message           TYPE if_sd_bil_type_def=>tt_message,
      lv_tdname            TYPE tdobname,
      ls_thead             TYPE thead,
      ls_text_testdata     TYPE ty_gs_i_ptf_pbd_chtxt_td,
      lt_lines             TYPE TABLE OF tline,
      ls_lines             TYPE tline,
      lv_tab_index         TYPE i VALUE 0,
      lv_status            TYPE abap_bool.

*****************************************************************************
* 1 Step: Prepare data for BAPI call
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = ls_text_testdata
    ).
    SORT ls_text_testdata-lt_thead BY tdobject tdid.
*****************************************************************************
* 2 Step: Reject and commit Prebilling Doc
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_prebilling_number.
    ENDLOOP.

    lv_status = abap_true.
*****************************************************************************
    LOOP AT lt_prebilling_number ASSIGNING FIELD-SYMBOL(<ls_prebilling_number>).
      LOOP AT ls_text_testdata-lt_thead ASSIGNING FIELD-SYMBOL(<ls_head>).

        CLEAR ls_thead.
        ls_thead-tdobject =   <ls_head>-tdobject.
        ls_thead-tdid       = <ls_head>-tdid.
        ls_thead-tdspras    = <ls_head>-tdspras.
        ls_thead-tdform	    = <ls_head>-tdform.
        ls_thead-tdlinesize = <ls_head>-tdlinesize.
        ls_thead-mandt      = sy-mandt.
        IF <ls_head>-tdobject EQ 'VBBK'.
          ls_thead-tdname = <ls_prebilling_number>-vbeln.
          MOVE-CORRESPONDING ls_text_testdata-lt_lines_head TO lt_lines.
        ELSEIF <ls_head>-tdobject EQ 'VBBP'.
          IF <ls_head>-tdid = '0001'.
            lv_tab_index = lv_tab_index + 1.
          ENDIF.
          SELECT posnr FROM vbrp INTO TABLE @DATA(lt_posnr) WHERE vbeln = @<ls_prebilling_number>-vbeln.
          SORT lt_posnr BY posnr.
          READ TABLE lt_posnr INTO DATA(posnr) INDEX 1.
          CONCATENATE <ls_prebilling_number>-vbeln posnr INTO ls_thead-tdname.
          MOVE-CORRESPONDING ls_text_testdata-lt_lines_item TO lt_lines.
          ls_lines-tdformat = '*'.
          ls_lines-tdline = posnr.
          APPEND ls_lines TO lt_lines.
        ENDIF.

        CALL FUNCTION 'SAVE_TEXT'
          EXPORTING
            header          = ls_thead
            insert          = 'I'
            savemode_direct = 'X'
          IMPORTING
            newheader       = ls_thead
          TABLES
            lines           = lt_lines
          EXCEPTIONS
            id              = 1
            language        = 2
            name            = 3
            object          = 4
            OTHERS          = 5.
        IF sy-subrc NE 0.
          lv_status = abap_false.
        ENDIF.
      ENDLOOP.
      APPEND <ls_prebilling_number>-vbeln TO ev_document_id.
    ENDLOOP.
    ev_execution_status = lv_status.

  ENDMETHOD.


  METHOD change.
  ENDMETHOD.


  METHOD check.
    DATA: ls_testdata        TYPE cl_ptf_bo_invoice=>ty_gs_ptf_bd_check_td,
          lv_prestepnumber   TYPE LINE OF cl_ptf_util=>gt_ptf_step-reference_step,
          ls_check_step_data TYPE cl_ptf_util=>gt_ptf_step,
          lv_vbeln           TYPE vbeln,
          error_message      TYPE bapi_msg,
          ls_return          TYPE bapiret2,
          lv_error_occured   TYPE abap_bool,
          var_step           TYPE string.
**********************************************************************************************
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO ev_document_id.

      DATA(ls_step_check) = me->mo_run_environment->get_step_data( iv_step_number = <lv_ref_step> ).

      lv_error_occured = abap_false.
      CLEAR: lv_prestepnumber, ls_check_step_data.
      IF ls_testdata-vbrk_check IS NOT INITIAL OR ls_testdata-vbrp_check IS NOT INITIAL.
        IF ls_testdata-vbrk_check IS NOT INITIAL.
          cl_ptf_compare_bd_tdc=>compare_vbrk_data(
            EXPORTING
              is_testdata        = ls_testdata
              is_check_step_data = ls_step_check
              iv_run_environment = me->mo_run_environment
            RECEIVING
              rv_is_equal        = ev_check_status
          ).
          IF ev_check_status EQ abap_false.
            lv_error_occured = abap_true.
          ENDIF.
        ENDIF.
        IF ls_testdata-vbrp_check IS NOT INITIAL.
          cl_ptf_compare_bd_tdc=>compare_vbrp_data(
            EXPORTING
              is_testdata        = ls_testdata
              is_check_step_data = ls_step_check
              iv_run_environment = me->mo_run_environment
            RECEIVING
              rv_is_equal        = ev_check_status
          ).
          IF ev_check_status EQ abap_false.
            lv_error_occured = abap_true.
          ENDIF.
        ENDIF.
      ENDIF.

    ENDLOOP.
**********************************************************************************************
*    cs_step_data-step_success = abap_true.


    ev_execution_status = abap_true.
    IF lv_error_occured EQ abap_false.
      ev_check_status = abap_true.
      var_step = ls_step_data-step_number.
      CONCATENATE 'General check was successful. Process step is:' var_step   INTO error_message SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = |{ error_message }| ).
    ELSE.
      ev_check_status = abap_false.
      var_step = ls_step_data-step_number.
      CONCATENATE 'General check failed. Process step is:' var_step   INTO error_message SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = |{ error_message }| ).
    ENDIF.

  ENDMETHOD.


  METHOD check_existence.
    DATA: lv_vbeln TYPE vbeln.
    MOVE iv_id TO lv_vbeln.

    SELECT SINGLE * FROM vbrk WHERE vbeln = @lv_vbeln INTO @DATA(ls_bd).
    IF sy-subrc <> 0.
      me->mo_run_environment->append_log( iv_log_statement = |PBD { lv_vbeln } does not exist.| ).
      rv_exists = abap_false.
    ELSE.
      rv_exists = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD check_expected_doc_quantity.
    DATA: lt_vbeln         TYPE TABLE OF cl_ptf_util=>ty_vbeln,
          ls_vbeln         TYPE cl_ptf_util=>ty_vbeln,
          lt_vbeln_on_db   TYPE TABLE OF cl_ptf_util=>ty_vbeln,
          ls_quantity      TYPE cl_ptf_sd_util=>ty_check_expected_quantity,
          lv_quantity      TYPE i,
          lv_quantity_exp  TYPE string,
          lv_quantity_crea TYPE string,
          lv_message       TYPE bapi_msg,
          ls_return        TYPE bapiret2,
          lv_success       TYPE abap_bool.
*****************************************************************************
* 1 Step: Get TDCV
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_quantity
    ).
*****************************************************************************
* 2 Step: Get Presteps
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.
*****************************************************************************
* 3 Step: Check
    lv_success = abap_true.
    DESCRIBE TABLE lt_vbeln LINES lv_quantity.

    IF lv_quantity NE ls_quantity-quantity.
      lv_success = abap_false.
      lv_quantity_exp =  ls_quantity-quantity.
      lv_quantity_crea =  lv_quantity.
      CONCATENATE 'The expected document quantity is:' lv_quantity_exp 'The created quantity is:' lv_quantity_crea INTO lv_message SEPARATED BY space.
      CLEAR ls_return.
      ls_return-message = lv_message.
      me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
    ELSEIF lv_quantity EQ 0 AND ls_quantity-quantity EQ 0.
      ev_check_status = abap_true.
      lv_message = 'The expected document quantity and the created quantity are equal'.
      CLEAR ls_return.
      ls_return-message = lv_message.
      me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).

    ELSEIF lv_quantity EQ ls_quantity-quantity.
      LOOP AT lt_vbeln INTO ls_vbeln.
        SELECT SINGLE * FROM vbrk INTO @DATA(ls_vbrk) WHERE vbeln = @ls_vbeln-vbeln.
        IF sy-subrc EQ 0.
          CONCATENATE 'Database entry with vbeln:' ls_vbeln-vbeln 'exists' INTO lv_message SEPARATED BY space.
          CLEAR ls_return.
          ls_return-message = lv_message.
          me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
          APPEND ls_vbeln TO  lt_vbeln_on_db.
        ELSE.
          CONCATENATE 'Database entry with vbeln:' ls_vbeln-vbeln 'does not exists.' INTO lv_message SEPARATED BY space.
          CLEAR ls_return.
          ls_return-message = lv_message.
          me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
          lv_success = abap_false.
        ENDIF.
      ENDLOOP.
    ENDIF.

    ev_check_status = lv_success.
    ev_execution_status = abap_true.

  ENDMETHOD.


  method CHECK_PBD_ITEM_PPRCTR.
    DATA: lt_vbeln                      TYPE cl_ptf_util=>ty_vbeln_tab,
          lv_vbeln                      TYPE vbeln,
          test_data                     TYPE ty_gs_bd_item_pprctr_check,
          lt_item_partner_profit_center TYPE item_pprctr_tab.

*   1. Step: Get Presteps
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      IF lines( lt_ptf_keys ) EQ 0.
        me->mo_run_environment->append_log( iv_log_statement = |No documents found for step { <lv_ref_step> }| ).
      ENDIF.
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    IF lines( lt_vbeln ) EQ 0 OR lines( lt_vbeln ) > 1.
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |Nothing to check / More than one invoice was referenced.| ).
      RETURN.
    ENDIF.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = test_data
     ).

    READ TABLE lt_vbeln INDEX 1 INTO lv_vbeln.

    ev_check_status = abap_false.
    ev_execution_status = abap_false.

    SELECT posnr  AS item_number
           pprctr AS partner_profit_center
      FROM vbrp
      INTO TABLE lt_item_partner_profit_center
     WHERE vbeln = lv_vbeln.

    IF lt_item_partner_profit_center IS INITIAL.
      ev_check_status = abap_false.
      me->mo_run_environment->append_log(
        iv_log_statement = |None of item have been read from VBRP. | ).
    ELSE.
      me->mo_run_environment->append_log(
        iv_log_statement = |Reading from VBRP is enabled. | ).

      SORT lt_item_partner_profit_center BY item_number.

      LOOP AT test_data-item_pprctr_check ASSIGNING FIELD-SYMBOL(<ls_item_partnerprofitcenter>).
        IF line_exists( lt_item_partner_profit_center[ item_number           = <ls_item_partnerprofitcenter>-item_number
                                                       partner_profit_center = <ls_item_partnerprofitcenter>-partner_profit_center ] ).
          ev_check_status = abap_true.

          me->mo_run_environment->append_log(
              iv_log_statement = |For billing document { lv_vbeln } the Partner Profit Center is correctly read for the Item { <ls_item_partnerprofitcenter>-item_number } |  ).
        ELSE.
          me->mo_run_environment->append_log(
              iv_log_statement = |For billing document { lv_vbeln } the Partner Profit Center is not correct for the Item { <ls_item_partnerprofitcenter>-item_number } |  ).
        ENDIF.
      ENDLOOP.
    ENDIF.
  endmethod.


  METHOD check_vkdfs.
    DATA: lt_vbeln_pre_step  TYPE TABLE OF cl_ptf_util=>ty_vbeln,
          ls_vbeln_pre_step  TYPE cl_ptf_util=>ty_vbeln,
          ls_vbrp            TYPE vbrp,
          ls_vkdfs_checkdata TYPE cl_ptf_bo_invoice=>ty_check_vkdfs,
          ls_vkdfs_db        TYPE vkdfs,
          lv_message         TYPE bapi_msg,
          ls_return          TYPE bapiret2,
          lv_success         TYPE abap_bool,
          lt_fieldinfo       TYPE extdfiest,
          ls_fieldinfo       TYPE LINE OF extdfiest,
          error_message      TYPE bapi_msg,
          msg_str1           TYPE string,
          msg_str2           TYPE string.

    FIELD-SYMBOLS: <lv_vkdfs_exp>   TYPE any,
                   <lv_vkdfs_check> TYPE any,
                   <lv_vkdfs_db>    TYPE any.
*****************************************************************************
* 1 Step: Get TDCV
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_vkdfs_checkdata
    ).

*****************************************************************************
* 2 Step: Get Presteps
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln_pre_step.
    ENDLOOP.
*****************************************************************************
* 3 Step: get fieldinfo of´vkdfs
    CLEAR lt_fieldinfo.
    CALL FUNCTION 'DD_INT_TABLINFO_GET'
      EXPORTING
        typename       = 'VKDFS'
      TABLES
        extdfies_tab   = lt_fieldinfo
      EXCEPTIONS
        not_found      = 1
        internal_error = 2
        OTHERS         = 3.
*****************************************************************************
* 4 Step: compare TDCV and DB
    lv_success = abap_true.

    LOOP AT lt_vbeln_pre_step INTO ls_vbeln_pre_step.

      SELECT SINGLE * FROM vbrp INTO ls_vbrp WHERE vbeln = ls_vbeln_pre_step-vbeln.
      IF ls_vbrp IS NOT INITIAL.
        SELECT SINGLE * FROM vkdfs INTO ls_vkdfs_db WHERE vbeln = ls_vbrp-vgbel.
        IF ls_vkdfs_db IS NOT INITIAL.
          LOOP AT lt_fieldinfo INTO ls_fieldinfo.
*
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vkdfs_checkdata-vkdfs_check TO <lv_vkdfs_check>.
            IF <lv_vkdfs_check> EQ abap_true.
              ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vkdfs_checkdata-vkdfs TO <lv_vkdfs_exp>.
              ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vkdfs_db TO <lv_vkdfs_db>.

              IF ls_fieldinfo-fieldname  NE 'DBD_REF' AND <lv_vkdfs_exp> NE <lv_vkdfs_db>.
                lv_success = abap_false.
                msg_str1 = <lv_vkdfs_exp>.
                msg_str2 = <lv_vkdfs_db>.
                CONCATENATE 'The Value of the vkdfs field ' ls_fieldinfo-fieldname 'is not as expected. The expected value is:' msg_str1
                '. The stored value is:' msg_str2 INTO error_message SEPARATED BY space.
                CLEAR ls_return.
                ls_return-message = error_message.
                me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
              ELSEIF ls_fieldinfo-fieldname EQ 'DBD_REF' AND ls_vbrp-vbeln NE <lv_vkdfs_db>.
                lv_success = abap_false.
                msg_str1 = <lv_vkdfs_exp>.
                msg_str2 = <lv_vkdfs_db>.
                CONCATENATE 'The Value of the vkdfs field ' ls_fieldinfo-fieldname 'is not as expected. The expected value is:' msg_str1
                '. The stored value is:' msg_str2 INTO error_message SEPARATED BY space.
                CLEAR ls_return.
                ls_return-message = error_message.
                me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
              ENDIF.
            ENDIF.

          ENDLOOP.

        ELSE.
          lv_success = abap_false.
          CONCATENATE 'No database entry in VKDFS was found with vbeln:' ls_vbeln_pre_step-vbeln INTO error_message SEPARATED BY space.
          CLEAR ls_return.
          ls_return-message = error_message.
          me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
        ENDIF.

      ELSE.
        lv_success = abap_false.
        CONCATENATE 'No database entry in VBRP was found with vbeln:' ls_vbeln_pre_step-vbeln INTO error_message SEPARATED BY space.
        CLEAR ls_return.
        ls_return-message = error_message.
        me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
      ENDIF.
    ENDLOOP.

    ev_check_status = lv_success.
    ev_execution_status = abap_true.

  ENDMETHOD.


  METHOD copy.
    TYPES:
      BEGIN OF ty_billing_instruction,
        id                     TYPE vbeln,
        item_id                TYPE posnr,
        billing_doc_type       TYPE fkart,
        sd_document_category   TYPE vbtypl,
        billing_requested_date TYPE fkdat_bis,
      END OF ty_billing_instruction ,
      BEGIN OF ty_draft_vbeln,
        vbeln TYPE ptfkey,
      END OF ty_draft_vbeln ,
      tt_draft_vbeln TYPE STANDARD TABLE OF ty_draft_vbeln WITH DEFAULT KEY.

    DATA:
      ls_return             TYPE bapiret2,
      lt_return             TYPE TABLE OF bapiret2,
      lt_prebilling_number  TYPE tt_draft_vbeln,
      ls_prebilling_number  TYPE ty_draft_vbeln,
      lv_vbeln              TYPE vbeln,
      lt_message            TYPE if_sd_bil_type_def=>tt_message,
      lt_new_prebilling_doc TYPE if_sd_bil_type_def=>tt_billing_document.

*****************************************************************************
* 1 Step: Prepare data for BAPI call
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_prebilling_number. """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    ENDLOOP.

*****************************************************************************
* 2 Step: Reject
    TYPES:
      BEGIN OF ty_vbeln_orig,
        vbeln TYPE vbeln,
      END OF ty_vbeln_orig.
    DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.
    MOVE lt_prebilling_number TO lt_vbeln_key.

    cl_sd_bil_prebilling_facade=>if_sd_bil_prebilling_action~copy(
      EXPORTING
        it_draft_document =   lt_vbeln_key
      IMPORTING
        et_draft_document =   lt_new_prebilling_doc
        et_message        =  lt_message    ).

    LOOP AT lt_prebilling_number INTO ls_prebilling_number.
      TYPES:
        BEGIN OF ty_billing_document,
          vbeln TYPE vbeln,
        END OF ty_billing_document .
      DATA: lv_vbeln_key TYPE ty_billing_document.
      MOVE ls_prebilling_number-vbeln TO lv_vbeln_key-vbeln.

      DELETE TABLE lt_new_prebilling_doc FROM lv_vbeln_key.
    ENDLOOP.

*****************************************************************************
* 3 Step: Commit and fill et_Return
    me->get_message_text( it_message = lt_message ).

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
******************************************************************************
* 4 Step: Check if EBDR exists
    CLEAR lv_vbeln.
    LOOP AT lt_new_prebilling_doc INTO lv_vbeln.
      DATA: lv_ptf_key TYPE ptfkey.
      MOVE lv_vbeln TO lv_ptf_key.
      ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).
      IF ev_execution_status EQ abap_false.
        RETURN.
      ELSE.
        APPEND lv_ptf_key TO ev_document_id.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD create.
    TYPES:
      BEGIN OF ty_draft_vbeln,
        vbeln TYPE vbeln,
      END OF ty_draft_vbeln ,
      tt_draft_vbeln TYPE STANDARD TABLE OF ty_draft_vbeln WITH DEFAULT KEY.

    DATA:
      ls_return              TYPE bapiret2,
      lt_return              TYPE TABLE OF bapiret2,
      lv_vbeln               TYPE vbeln,
      lt_billing_instruction TYPE if_sd_bil_type_def=>tt_billing_instruction,
      ls_billing_instruction TYPE if_sd_bil_type_def=>ty_billing_instruction,
      lt_prebilling_number   TYPE tt_draft_vbeln,
      lt_message             TYPE if_sd_bil_type_def=>tt_message,
      ls_testdata            TYPE cl_ptf_bo_invoice=>ty_gs_i_ptf_bd_cr_td,
      lt_vbeln               TYPE cl_ptf_util=>ty_vbeln_tab,
      ls_msg_final           TYPE string.

*****************************************************************************
*Prepare data for BAPI call
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    IF ls_step_data-variant IS NOT INITIAL.
      cl_ptf_util=>get_testdata(
        EXPORTING
          is_step_data = ls_step_data
        IMPORTING
          es_testdata  = ls_testdata
      ).
    ENDIF.

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      IF lt_ptf_keys IS NOT INITIAL.
        IF NOT ( lines( lt_ptf_keys ) EQ 1 AND lt_ptf_keys[ 1 ] IS INITIAL ).
          APPEND LINES OF lt_ptf_keys TO lt_vbeln.
        ENDIF.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<ls_vbeln>).

      SELECT SINGLE vbtyp, fkdat, lland, fkart INTO @DATA(vkdfs_data)
        FROM vkdfs WHERE vbeln = @<ls_vbeln>-vbeln.

      IF vkdfs_data IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |Document { <ls_vbeln>-vbeln } could not be found.| ).
        ev_execution_status = abap_false.
      ELSE.
        me->mo_run_environment->append_log( iv_log_statement = |VKDFS data found:| ).
        me->mo_run_environment->append_log( iv_log_statement = |VKDFS-vbtyp: { vkdfs_data-vbtyp }| ).
        me->mo_run_environment->append_log( iv_log_statement = |VKDFS-fkdat: { vkdfs_data-fkdat }| ).
        me->mo_run_environment->append_log( iv_log_statement = |VKDFS-lland: { vkdfs_data-lland }| ).
        me->mo_run_environment->append_log( iv_log_statement = |VKDFS-fkart: { vkdfs_data-fkart }| ).
      ENDIF.


      ls_billing_instruction-id = <ls_vbeln>-vbeln.

      IF ls_testdata-invoice_date IS INITIAL.
        ls_billing_instruction-billing_requested_date = vkdfs_data-fkdat.
      ELSE.
        ls_billing_instruction-billing_requested_date = ls_testdata-invoice_date.
      ENDIF.

      IF ls_testdata-invoice_type IS NOT INITIAL.
        ls_billing_instruction-billing_doc_type = ls_testdata-invoice_type.
      ELSE.
        ls_billing_instruction-billing_doc_type = vkdfs_data-fkart.
      ENDIF.

      ls_billing_instruction-destination_country = vkdfs_data-lland.

      ls_billing_instruction-sd_document_category = vkdfs_data-vbtyp.

      APPEND ls_billing_instruction TO lt_billing_instruction .
    ENDLOOP.

*****************************************************************************
* Create
    cl_sd_bil_prebilling_facade=>if_sd_bil_prebilling_action~create(
      EXPORTING
        it_billing_instruction   =  lt_billing_instruction
        iv_posting               =  'D'
      IMPORTING
        et_draft_document        =   lt_prebilling_number
        et_message               =   lt_message ).

*    #########################################################################################################################
*Workarround to refresh sales doc.. This function call has to be done in RV_INVOICE_REFRESG
    CALL FUNCTION 'SD_BUFFER_TABLES_REFRESH'.
    CALL FUNCTION 'LE_DELIVERY_REFRESH_BUFFER'.

*    #########################################################################################################################
*****************************************************************************
*Commit and fill et_Return
    LOOP AT lt_message ASSIGNING FIELD-SYMBOL(<ls_msg>).

      CALL FUNCTION 'MESSAGE_TEXT_BUILD'
        EXPORTING
          msgid               = <ls_msg>-msgid
          msgnr               = <ls_msg>-msgno
          msgv1               = <ls_msg>-msgv1
          msgv2               = <ls_msg>-msgv2
          msgv3               = <ls_msg>-msgv3
          msgv4               = <ls_msg>-msgv4
        IMPORTING
          message_text_output = ls_msg_final.
      me->mo_run_environment->append_log( iv_log_statement = |{ ls_msg_final }| ).
    ENDLOOP.
    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

******************************************************************************
* Check if PBD exists
    LOOP AT lt_vbeln ASSIGNING <ls_vbeln>.
      READ TABLE lt_prebilling_number WITH TABLE KEY vbeln = <ls_vbeln>-vbeln TRANSPORTING NO FIELDS.
      IF sy-subrc EQ 0.
        DELETE lt_prebilling_number WHERE vbeln = <ls_vbeln>-vbeln.
      ENDIF.
    ENDLOOP.

    CLEAR lv_vbeln.
    DATA: lv_exists TYPE abap_bool.
    LOOP AT lt_prebilling_number INTO lv_vbeln.
      DATA: lv_ptf_key TYPE ptfkey.
      MOVE lv_vbeln TO lv_ptf_key.
      ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).
      IF ev_execution_status EQ abap_false.
        RETURN.
      ELSE.
        APPEND lv_ptf_key TO ev_document_id.
      ENDIF.
    ENDLOOP.

    IF ev_document_id IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No documents were created.| ).
      IF lt_message IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |No log was created.| ).
      ENDIF.
      me->mo_run_environment->append_log( iv_log_statement = |sy-subrc = { sy-subrc }| ).
      me->mo_run_environment->append_log( iv_log_statement = |sy-msgid = { sy-msgid }| ).
      me->mo_run_environment->append_log( iv_log_statement = |sy-msgno = { sy-msgno }| ).
      me->mo_run_environment->append_log( iv_log_statement = |sy-msgty  = { sy-msgty }| ).
      me->mo_run_environment->append_log( iv_log_statement = |sy-msgv1 = { sy-msgv1 }| ).
      me->mo_run_environment->append_log( iv_log_statement = |sy-msgv2 = { sy-msgv2 }| ).
      me->mo_run_environment->append_log( iv_log_statement = |sy-msgv3 = { sy-msgv3 }| ).
      me->mo_run_environment->append_log( iv_log_statement = |sy-msgv4 = { sy-msgv4 }| ).
      CONCATENATE LINES OF lt_vbeln INTO DATA(documents) SEPARATED BY ', '.
      me->mo_run_environment->append_log( iv_log_statement = |Tried to create a PBD for the documents: { documents }| ).
      me->mo_run_environment->append_log( iv_log_statement = |Therefore { lines( lt_billing_instruction ) } billing instructions were created.| ).
      me->mo_run_environment->append_log( iv_log_statement = |Billing Instructions:| ).
      LOOP AT lt_billing_instruction ASSIGNING FIELD-SYMBOL(<billing_instruction>).
        me->mo_run_environment->append_log( iv_log_statement = |Billing instruction #{ sy-tabix }: id = { <billing_instruction>-id }| ).
        me->mo_run_environment->append_log( iv_log_statement = |Billing instruction #{ sy-tabix }: item_id = { <billing_instruction>-item_id }| ).
        me->mo_run_environment->append_log( iv_log_statement = |Billing instruction #{ sy-tabix }: billing_doc_type = { <billing_instruction>-billing_doc_type }| ).
        me->mo_run_environment->append_log( iv_log_statement = |Billing instruction #{ sy-tabix }: destination_country  = { <billing_instruction>-destination_country }| ).
        me->mo_run_environment->append_log( iv_log_statement = |Billing instruction #{ sy-tabix }: sd_document_category  = { <billing_instruction>-sd_document_category }| ).
        me->mo_run_environment->append_log( iv_log_statement = |Billing instruction #{ sy-tabix }: billing_requested_date  = { <billing_instruction>-billing_requested_date }| ).
      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD create_via_odata.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/SAP/SD_PRE_BIL_DUE_LIST_ITEM_SRV/'.
    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    DATA lt_parameters TYPE /iwfnd/sutil_property_t.
    DATA: lv_status_text TYPE string,
          lv_status_code TYPE integer.
    DATA: ls_return     TYPE bapiret2.
    DATA: lv_msg             TYPE string,
          lv_status_code_txt TYPE string.
    DATA: documents TYPE STANDARD TABLE OF vbeln WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_functionimportresult,
             BillingDocument     TYPE string,
             BillingDocumentItem TYPE string,
             MessageId           TYPE string,
             MessageType         TYPE string,
             Message             TYPE string,
           END OF ty_functionimportresult.
    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              results TYPE TABLE OF ty_functionimportresult, "TODO
            END OF d,
          END OF ls_response_function.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(document_ids) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      APPEND LINES OF document_ids TO documents.
    ENDLOOP.

    IF documents IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No documents available for PBD creation.| ).
      ev_execution_status = abap_false.
      ev_check_status = abap_false.
      RETURN.
    ENDIF.

    ev_execution_status = abap_true.

    LOOP AT documents ASSIGNING FIELD-SYMBOL(<document>).
      SELECT * FROM vkdfs WHERE vbeln = @<document> INTO TABLE @DATA(vkdfs_entries).
      IF vkdfs_entries IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |Could not find vkdfs entries for document { <document> }| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
      ENDIF.
      LOOP AT vkdfs_entries ASSIGNING FIELD-SYMBOL(<vkdfs_entry>).
        lt_parameters = VALUE #(
          ( name = 'ReferenceSDDocument' value =   <document> )
          ( name = 'ReferenceSDDocumentCategory' value =   <vkdfs_entry>-vbtyp )
          ( name = 'BillingDocumentDate' value =   <vkdfs_entry>-fkdat )
          ( name = 'BillingDocumentType' value =   <vkdfs_entry>-fkart )
          ( name = 'DestinationCountry' value =   <vkdfs_entry>-lland )
          ( name = 'RequestedBillingDocumentDate' value =   '0000-00-00' )
          ( name = 'RequestedBillingDocumentType' value =   '' )
          ( name = 'SeparateBilllingDocumentsRequested' value =   '' )
          ( name = 'SendApprovalRequest' value =   '' )
          ( name = 'RefSDDocWithInvalidPartner' value =   '' )
          ( name = 'OldBillToPartyAddressId' value =   '' )
          ( name = 'NewBillToPartyAddressId' value =   '' )
        ).
        lo_odata_caller->call_service(
          EXPORTING
            iv_method           = 'POST'
            iv_action_or_entity = 'CreatePreliminaryBillingDocument'
            it_parameters       = lt_parameters
          IMPORTING
            ev_status_code      = lv_status_code
            ev_status_text      = lv_status_text
            es_json_response    = ls_response_function
        ).

        IF lv_status_code NE 200.
          me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA service: { lv_status_code } : { lv_status_text }.| ).
          ev_check_status = abap_false.
          ev_execution_status = abap_false.
        ELSE.
          me->mo_run_environment->append_log( iv_log_statement = |Successfully called ODATA service for document { <document> }.| ).

          LOOP AT ls_response_function-d-results ASSIGNING FIELD-SYMBOL(<result>).
            IF <result>-messageid EQ 'CRE'.
              APPEND <result>-billingdocument TO ev_document_id.
            ELSE.
              me->mo_run_environment->append_log( iv_log_statement = <result>-message ).
            ENDIF.
          ENDLOOP.

        ENDIF.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.


  METHOD delete.
  ENDMETHOD.


  METHOD execute_action.
    DATA(lv_step_data) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).
    CASE lv_step_data-action.
      WHEN c_schedule_pbd_creation.
        me->schedule_pbd_creation(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_create_via_odata.
        me->create_via_odata(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_setinprogress.
        me->setinprogress(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_reject.
        me->reject(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_finalize.
        me->finalize(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_copy.
        me->copy(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_add_text.
        me->add_text(
            EXPORTING
              step_data           = lv_step_data
              iv_step_number      = iv_step_number
            IMPORTING
              ev_document_id      = ev_document_id
              ev_execution_status = ev_execution_status
              ev_check_status     = ev_check_status
          ).
        RETURN.
      WHEN c_add_manual_item.
        me->add_manual_item(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_add_items.
        me->add_items(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_activate.
        me->activate(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_odata_get_object_page_data.
        me->odata_get_object_page_data(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_odata_post_create_pre_bil.
        me->odata_post_create_bil(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_odata_post_compare_pre_bil.
        me->odata_post_compare_pre_bil(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_odata_post_set_in_progress.
        me->odata_post_set_to_in_progress(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_odata_post_reject_pbd.
        me->odata_post_reject_pre_bil_doc(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_odata_post_finalize.
        me->odata_post_finalize(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_odata_post_create_bil.
        me->odata_post_create_bil(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_odata_post_copy_pre_bil.
        me->odata_post_copy_pre_bil(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_odata_get_work_list.
        me->odata_get_pre_bil_work_list(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.

      WHEN c_raise_approval_action.
        raise_approval_action(
        EXPORTING
          step_data           = lv_step_data
          iv_step_number      = iv_step_number
        IMPORTING
          ev_document_id      = ev_document_id
          ev_execution_status = ev_execution_status
          ev_check_status     = ev_check_status
          ).
        RETURN.

      WHEN c_withdraw_from_approval.
        me->withdraw_from_approval(
        EXPORTING
          step_data           = lv_step_data
          iv_step_number      = iv_step_number
        IMPORTING
          ev_document_id      = ev_document_id
          ev_execution_status = ev_execution_status
          ev_check_status     = ev_check_status
          ).
        RETURN.

      WHEN c_release.
        me->release(
        EXPORTING
          step_data           = lv_step_data
          iv_step_number      = iv_step_number
        IMPORTING
          ev_document_id      = ev_document_id
          ev_execution_status = ev_execution_status
          ev_check_status     = ev_check_status
          ).
        RETURN.

        WHEN c_log_status.
        me->log_status(
          EXPORTING
            step_data           = lv_step_data
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
      WHEN c_check_expected_doc_quantity.
        me->check_expected_doc_quantity(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_check_vkdfs.
        me->check_vkdfs(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN C_CHECK_PBD_ITEM_PPRCTR.
        me->check_pbd_item_pprctr(
          EXPORTING
            step_data           = lv_step_data
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


  METHOD finalize.
    TYPES:
      BEGIN OF ty_billing_instruction,
        id                     TYPE vbeln,
        item_id                TYPE posnr,
        billing_doc_type       TYPE fkart,
        sd_document_category   TYPE vbtypl,
        billing_requested_date TYPE fkdat_bis,
      END OF ty_billing_instruction ,
      BEGIN OF ty_draft_vbeln,
        vbeln TYPE ptfkey,
      END OF ty_draft_vbeln ,
      tt_draft_vbeln TYPE STANDARD TABLE OF ty_draft_vbeln WITH DEFAULT KEY.

    DATA:
      ls_return            TYPE bapiret2,
      lt_return            TYPE TABLE OF bapiret2,
      lt_prebilling_number TYPE tt_draft_vbeln,
      ls_prebilling_number TYPE ty_draft_vbeln,
      lv_vbeln             TYPE vbeln,
      lt_message           TYPE if_sd_bil_type_def=>tt_message.

*****************************************************************************
* 1 Step: Prepare data for BAPI call
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_prebilling_number. """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    ENDLOOP.

*****************************************************************************
* 2 Step: FINALIZE
    TYPES:
      BEGIN OF ty_vbeln_orig,
        vbeln TYPE vbeln,
      END OF ty_vbeln_orig.
    DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.
    MOVE lt_prebilling_number TO lt_vbeln_key.


    cl_sd_bil_prebilling_facade=>if_sd_bil_prebilling_action~finalize(
      EXPORTING
        it_prebilling                  = lt_vbeln_key
        iv_posting                     = 'D'
      IMPORTING
        et_message                     = lt_message
        et_prebilling_finalized_failed = DATA(lt_prebilling_finalized_failed) ).
*****************************************************************************
* 3 Step: Commit and fill et_Return
    me->get_message_text( it_message = lt_message ). "writes into log

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
******************************************************************************
* 4 Step: Check if EBDR exists
    CLEAR lv_vbeln.
    LOOP AT lt_prebilling_number INTO lv_vbeln.
      DATA: lv_ptf_key TYPE ptfkey.
      MOVE lv_vbeln TO lv_ptf_key.
      ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).
      IF ev_execution_status EQ abap_false.
        RETURN.
      ELSE.
        APPEND lv_ptf_key TO ev_document_id.
      ENDIF.
    ENDLOOP.
    IF lt_prebilling_finalized_failed is not initial.
      ev_execution_status = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD get_message_text.
    DATA: lt_message    TYPE if_sd_bil_type_def=>tt_message,
          lt_return	    TYPE bapiret2_t,
          ls_return	    TYPE bapiret2,
          ls_message    TYPE REF TO vbfs,
          lv_msg_string TYPE string.

    lt_message = it_message.

    LOOP AT lt_message REFERENCE INTO ls_message.

      ls_return-id = ls_message->msgid.
      ls_return-number = ls_message->msgno.
      ls_return-type = ls_message->msgty.
      ls_return-message_v1 = ls_message->msgv1.
      ls_return-message_v2 = ls_message->msgv2.
      ls_return-message_v3 = ls_message->msgv3.
      ls_return-message_v4 = ls_message->msgv4.

      CALL FUNCTION 'MESSAGE_TEXT_BUILD'
        EXPORTING
          msgid               = ls_message->msgid
          msgnr               = ls_message->msgno
          msgv1               = ls_return-message_v1
          msgv2               = ls_return-message_v2
          msgv3               = ls_return-message_v3
          msgv4               = ls_return-message_v4
        IMPORTING
          message_text_output = ls_return-message.
      me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
    ENDLOOP.
  ENDMETHOD.


  METHOD log_status.
*     Reads status values of Invoice and logs them
  DATA: lt_vbeln TYPE cl_ptf_util=>ty_vbeln_tab,
        lv_vbrk  TYPE vbrk,
        lt_vbrp  TYPE TABLE OF vbrp.

  DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

  ev_check_status = abap_false.

  LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.

  IF lt_vbeln IS NOT INITIAL.
    LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<lv_vbel>).
      SELECT SINGLE vbeln, gbstk, fksak, rfbsk, clrst FROM vbrk WHERE vbeln = @<lv_vbel>-vbeln INTO CORRESPONDING FIELDS OF @lv_vbrk.
      IF sy-subrc <> 0.
        "Document not found
        me->mo_run_environment->append_log( iv_log_statement = |Could not find document { <lv_vbel>-vbeln }.| ).
        ev_execution_status = abap_false.
      ELSE.
        me->mo_run_environment->append_log( iv_log_statement = |PBD-Number: { <lv_vbel>-vbeln }  /  GBSTK: { lv_vbrk-gbstk } | ).
        me->mo_run_environment->append_log( iv_log_statement = |PBD-Number: { <lv_vbel>-vbeln }  /  FKSAK: { lv_vbrk-fksak } | ).
        me->mo_run_environment->append_log( iv_log_statement = |PBD-Number: { <lv_vbel>-vbeln }  /  RFBSK: { lv_vbrk-rfbsk } | ).
        me->mo_run_environment->append_log( iv_log_statement = |PBD-Number: { <lv_vbel>-vbeln }  /  CLRST: { lv_vbrk-clrst } | ).
        me->mo_run_environment->append_log( iv_log_statement = |PBD-Number: { <lv_vbel>-vbeln }  /  BUCHK: { lv_vbrk-buchk } | ).
        ev_check_status = abap_true.
      ENDIF.
      CLEAR lv_vbrk.
      SELECT vbeln, posnr, gbstk_ana, fksaa FROM vbrp WHERE vbeln = @<lv_vbel>-vbeln INTO CORRESPONDING FIELDS OF TABLE @lt_vbrp.
      IF sy-subrc <> 0.
        "No items
        me->mo_run_environment->append_log( iv_log_statement = |Could not find items for document { <lv_vbel>-vbeln }.| ).
      ELSE.
        LOOP AT lt_vbrp ASSIGNING FIELD-SYMBOL(<lv_vbrp>).
          me->mo_run_environment->append_log( iv_log_statement = |PBD-Number: { <lv_vbrp>-vbeln }  / Item-Number: { <lv_vbrp>-posnr } / fksaa: { <lv_vbrp>-fksaa } | ).
        ENDLOOP.
      ENDIF.
    ENDLOOP.
    CLEAR lt_vbrp.
  ELSE.
    me->mo_run_environment->append_log( iv_log_statement = |No documents found.| ).
    RETURN.
  ENDIF.

  ev_execution_status = abap_true.

ENDMETHOD.


  METHOD odata_f2875_fi_post.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/SAP/SD_PRE_BIL_DOC_MANAGE/'.
    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    DATA lt_parameters TYPE /iwfnd/sutil_property_t.
    DATA: lv_status_text TYPE string,
          lv_status_code TYPE integer.
    DATA: ls_return     TYPE bapiret2.
    DATA: lv_msg             TYPE string,
          lv_status_code_txt TYPE string.
    TYPES: BEGIN OF ty_functionimportresult,
             billingdocument     TYPE string,
             billingdocumentitem TYPE string,
             messageid           TYPE string,
             messagetype         TYPE string,
             message             TYPE string,
           END OF ty_functionimportresult.

    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              results TYPE TABLE OF ty_functionimportresult,
            END OF d,
          END OF ls_response_function.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
      DATA(ls_refstep_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
      IF ls_refstep_data IS NOT INITIAL.
        LOOP AT ls_refstep_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).
          lt_parameters = VALUE #(
            ( name = 'PreliminaryBillingDocuments' value =  <ls_docid> )
          ).
          lo_odata_caller->call_service(
            EXPORTING
              iv_method           = 'POST'
              iv_action_or_entity = iv_function_name
              it_parameters       = lt_parameters
            IMPORTING
              ev_status_code      = lv_status_code
              ev_status_text      = lv_status_text
              es_json_response    = ls_response_function
          ).

          lv_status_code_txt = lv_status_code.
          CONCATENATE 'Executed API Call' iv_function_name 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
          me->mo_run_environment->append_log( iv_log_statement = |{ lv_msg } | ).

          IF lv_status_code = 200.
            ev_check_status = abap_true.
            ev_execution_status = abap_true.
            APPEND <ls_docid>-vbeln TO ev_document_id.
          ELSE.
            me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
            ev_check_status = abap_false.
            ev_execution_status = abap_false.
            EXIT.
          ENDIF.
          LOOP AT ls_response_function-d-results ASSIGNING FIELD-SYMBOL(<message>).
            me->mo_run_environment->append_log( iv_log_statement = |Billingdocument { <message>-billingdocument } position { <message>-billingdocumentitem }: { <message>-message }| ).
          ENDLOOP.
        ENDLOOP.
      ENDIF.
      IF ev_check_status = abap_false.
        EXIT.
      ENDIF.
    ENDLOOP.
    IF lv_msg IS INITIAL.
      CONCATENATE 'Did not execute API Call' iv_function_name INTO lv_msg SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_msg } | ).
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
    ENDIF.
  ENDMETHOD.


  METHOD odata_get_object_page_data.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/sap/SD_PRE_BIL_DOC_OP_SRV/'.
    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    DATA: lv_status_text TYPE string,
          lv_status_code TYPE integer.
    DATA: lt_messages TYPE sdbil_ebdr_request_msg_t.
    DATA lt_parameters TYPE /iwfnd/sutil_property_t.
    DATA: ls_return     TYPE bapiret2.
    DATA: lv_msg             TYPE string,
          lv_status_code_txt TYPE string.

    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              billingdocumentdate         TYPE string,
              billingdocumenttype         TYPE string,
              billingissuetype            TYPE string,
              billtoparty                 TYPE string,
              companycode                 TYPE string,
              customerpaymentterms        TYPE string,
              documentreferenceid         TYPE string,
              incotermsclassification     TYPE string,
              incotermslocation1          TYPE string,
              incotermslocation2          TYPE string,
              payerparty                  TYPE string,
              prelimbillingdocument       TYPE string,
              prelimbillingdocumentstatus TYPE string,
              salesorganization           TYPE string,
              sddocumentcategoryname      TYPE string,
              soldtoparty                 TYPE string,
              taxamount                   TYPE string,
              totalgrossamount            TYPE string,
              totalnetamount              TYPE string,
              transactioncurrency         TYPE string,
            END OF d,
          END OF ls_response_function.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
      DATA(ls_refstep_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
      IF ls_refstep_data IS NOT INITIAL.
        LOOP AT ls_refstep_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).
          lt_parameters = VALUE #( ( name = 'C_PrelimBillgDocObjPg' value =  <ls_docid> ) ).
          lo_odata_caller->call_service(
            EXPORTING
              iv_action_or_entity = 'C_PrelimBillgDocObjPg'
              it_parameters       = lt_parameters
            IMPORTING
              ev_status_code      = lv_status_code
              ev_status_text      = lv_status_text
              es_json_response    = ls_response_function
          ).
          lv_status_code_txt = lv_status_code.
          CONCATENATE 'Executed API Call' 'C_PrelimBillgDocObjPg' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
          ls_return-message = lv_msg.
          me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
          IF lv_status_code = 200.
            ev_check_status = abap_true.
            ev_execution_status = abap_true.
          ELSE.
            me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
            ev_check_status = abap_false.
            ev_execution_status = abap_false.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.
      IF ev_check_status = abap_false.
        EXIT.
      ENDIF.
    ENDLOOP.
    IF lv_msg IS INITIAL.
      CONCATENATE 'Did not execute API Call' 'C_PrelimBillgDocObjPg' INTO lv_msg SEPARATED BY space.
      ls_return-message = lv_msg.
      me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD odata_get_pre_bil_work_list.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/SAP/SD_PRE_BIL_DOC_MANAGE/'.
    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    DATA: lv_status_text TYPE string,
          lv_status_code TYPE integer.
    DATA: lt_messages TYPE sdbil_ebdr_request_msg_t.
    DATA lt_parameters TYPE /iwfnd/sutil_property_t.
    DATA: ls_return     TYPE bapiret2.
    DATA: lv_msg             TYPE string,
          lv_status_code_txt TYPE string.

    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              prelimbillingdocument       TYPE string,
              billingdocumenttype         TYPE string,
              soldtoparty                 TYPE string,
              prelimbillingdocumentstatus TYPE string,
              billingdocumentdate         TYPE string,
              totalnetamount              TYPE string,
              creationdate                TYPE string,
              createdbyuser               TYPE string,
              lastchangedate              TYPE string,
              payerparty                  TYPE string,
              taxamount                   TYPE string,
              totalgrossamount            TYPE string,
              transactioncurrency         TYPE string,
              companycode                 TYPE string,
              salesorganization           TYPE string,
              documentreferenceid         TYPE string,
              purchaseorderbycustomer     TYPE string,
              soldtopartyname             TYPE string,
              soldtopartyadditionalname   TYPE string,
              payerpartyname              TYPE string,
              payerpartyadditionalname    TYPE string,
              billingissuetype            TYPE string,
            END OF d,
          END OF ls_response_function.


    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
      DATA(ls_refstep_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
      IF ls_refstep_data IS NOT INITIAL.
        LOOP AT ls_refstep_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).
          lt_parameters = VALUE #(
            ( name = 'PrelimBillingDocument' value =  <ls_docid> )
          ).
          lt_parameters = VALUE #(  ).
          lo_odata_caller->call_service(
            EXPORTING
              iv_action_or_entity = 'C_PrelimBillgDocWorklist'
              it_parameters       = lt_parameters
            IMPORTING
              ev_status_code      = lv_status_code
              ev_status_text      = lv_status_text
              es_json_response    = ls_response_function
          ).
          lv_status_code_txt = lv_status_code.
          CONCATENATE 'Executed API Call' 'C_PrelimBillgDocWorklist' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
          ls_return-message = lv_msg.
          me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
          IF lv_status_code = 200.
            ev_execution_status = abap_true.
            ev_check_status = abap_true.
          ELSE.
            me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
            ev_execution_status = abap_false.
            ev_check_status = abap_false.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.
      IF ev_check_status = abap_false.
        EXIT.
      ENDIF.
    ENDLOOP.
    IF lv_msg IS INITIAL.
      CONCATENATE 'Did not execute API Call' 'C_PrelimBillgDocWorklist' INTO lv_msg SEPARATED BY space.
      ls_return-message = lv_msg.
      me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
      ev_execution_status = abap_false.
      ev_check_status = abap_false.
    ENDIF.
  ENDMETHOD.


  METHOD odata_post_compare_pre_bil.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/SAP/SD_PRE_BIL_DOC_MANAGE/'.
    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    DATA lt_parameters TYPE /iwfnd/sutil_property_t.
    DATA: lv_status_text TYPE string,
          lv_status_code TYPE integer.
    TYPES: BEGIN OF ty_functionimportresult,
             PrelimBillingDocumentEntity TYPE string,
             PrelimBillingDocument1      TYPE string,
             PrelimBillingDocument2      TYPE string,
             SplitFieldText              TYPE string,
             "PrelimBillingDocument1FieldValue TYPE string, "sadly currently not possible
             "PrelimBillingDocument2FieldValue TYPE string, "sadly currently not possible
           END OF ty_functionimportresult.

    DATA: ls_return     TYPE bapiret2.
    DATA: lv_msg             TYPE string,
          lv_status_code_txt TYPE string.

    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              results TYPE TABLE OF ty_functionimportresult,
            END OF d,
          END OF ls_response_function.

    DATA: prelim_billing_doc_1 TYPE string,
          prelim_billing_doc_2 TYPE string.

*     cs_step_data-reference_step should contain exactly two reference steps, cause i need to compare two pre_bil objects
*     Each reference_step contains exactly one document_id

    READ TABLE step_data-reference_step INDEX 1 ASSIGNING FIELD-SYMBOL(<ls_step_data_1>).
    READ TABLE step_data-reference_step INDEX 2 ASSIGNING FIELD-SYMBOL(<ls_step_data_2>).

    IF sy-subrc = 0.
      IF <ls_step_data_1> IS ASSIGNED AND <ls_step_data_1> IS ASSIGNED.
        DATA(ls_step_data_1_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_step_data_1> ).
        DATA(ls_step_data_2_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_step_data_2> ).
        LOOP AT ls_step_data_1_data-document_id ASSIGNING FIELD-SYMBOL(<ls_vbel_1>).
*         Should only run once
          prelim_billing_doc_1 = <ls_vbel_1>.
        ENDLOOP.

        LOOP AT ls_step_data_2_data-document_id ASSIGNING FIELD-SYMBOL(<ls_vbel_2>).
*         Should only run once
          prelim_billing_doc_2 = <ls_vbel_2>.
        ENDLOOP.

        lt_parameters = VALUE #(
              ( name = 'PrelimBillingDocument1' value =   prelim_billing_doc_1 )
              ( name = 'PrelimBillingDocument2' value =   prelim_billing_doc_2 )
            ).
        lo_odata_caller->call_service(
          EXPORTING
            iv_method           = 'POST'
            iv_action_or_entity = 'ComparePreliminaryBillingDocument'
            it_parameters       = lt_parameters
          IMPORTING
            ev_status_code      = lv_status_code
            ev_status_text      = lv_status_text
            es_json_response    = ls_response_function
        ).
        lv_status_code_txt = lv_status_code.
        CONCATENATE 'Executed API Call' 'ComparePreliminaryBillingDocument' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
        ls_return-message = lv_msg.
        me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
        IF lv_status_code = 200.
          ev_check_status = abap_true.
          ev_execution_status = abap_true.

          IF ls_response_function-d-results IS INITIAL.
            me->mo_run_environment->append_log( iv_log_statement = |No differences betweend { prelim_billing_doc_1 } and { prelim_billing_doc_2 }| ).
          ELSE.
            me->mo_run_environment->append_log( iv_log_statement = |Differences:| ).
            LOOP AT ls_response_function-d-results ASSIGNING FIELD-SYMBOL(<difference>).
              me->mo_run_environment->append_log( iv_log_statement = |PrelimBillingDocumentEntity { <difference>-prelimbillingdocumententity }| ).
              me->mo_run_environment->append_log( iv_log_statement = |PrelimBillingDocument1 { <difference>-prelimbillingdocument1 }| ).
              me->mo_run_environment->append_log( iv_log_statement = |PrelimBillingDocument2 { <difference>-prelimbillingdocument2 }| ).
              me->mo_run_environment->append_log( iv_log_statement = |SplitFieldText  { <difference>-splitfieldtext }| ).
              "me->mo_run_environment->append_log( iv_log_statement = |PrelimBillingDocument1FieldValue  { <difference>-PrelimBillingDocument1FieldValue }| ).
              "me->mo_run_environment->append_log( iv_log_statement = |PrelimBillingDocument2FieldValue  { <difference>-PrelimBillingDocument2FieldValue }| ).
              me->mo_run_environment->append_log( iv_log_statement = |---------------------------| ).
            ENDLOOP.
          ENDIF.


        ELSE.
          me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
          ev_check_status = abap_false.
          ev_execution_status = abap_false.
          EXIT.
        ENDIF.
      ENDIF.
    ENDIF.
    IF lv_msg IS INITIAL.
      CONCATENATE 'Did not execute API Call' 'ComparePreliminaryBillingDocument' INTO lv_msg SEPARATED BY space.
      ls_return-message = lv_msg.
      me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
    ENDIF.
  ENDMETHOD.


  METHOD odata_post_copy_pre_bil.
    me->odata_f2875_fi_post(
      EXPORTING
        iv_function_name    = c_function_name_copy_pre_bil
        step_data           = step_data
        iv_step_number      = iv_step_number
      IMPORTING
        ev_document_id      = ev_document_id
        ev_execution_status = ev_execution_status
        ev_check_status     = ev_check_status
    ).
  ENDMETHOD.


  METHOD odata_post_create_bil.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/SAP/SD_PRE_BIL_DOC_MANAGE/'.
    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    DATA lt_parameters TYPE /iwfnd/sutil_property_t.
    DATA: lv_status_text TYPE string,
          lv_status_code TYPE integer.
    DATA: ls_return     TYPE bapiret2.
    DATA: lv_msg             TYPE string,
          lv_status_code_txt TYPE string.
    TYPES: BEGIN OF ty_functionimportresult,
             billingdocument     TYPE string,
             billingdocumentitem TYPE string,
             messageid           TYPE string,
             messagetype         TYPE string,
             message             TYPE string,
           END OF ty_functionimportresult.

    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              results TYPE TABLE OF ty_functionimportresult,
            END OF d,
          END OF ls_response_function.
    ev_execution_status = abap_true.
    ev_check_status = abap_true.
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
      DATA(ls_refstep_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
      IF ls_refstep_data IS NOT INITIAL.
        LOOP AT ls_refstep_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).
          lt_parameters = VALUE #(
            ( name = 'PreliminaryBillingDocuments' value =  <ls_docid> )
            ( name = 'BillingDocumentDate' value =  '' )
            ( name = 'AutomaticallyPost' value =  '' )
          ).
          lo_odata_caller->call_service(
            EXPORTING
              iv_method           = 'POST'
              iv_action_or_entity = 'CreateBillingDocument'
              it_parameters       = lt_parameters
            IMPORTING
              ev_status_code      = lv_status_code
              ev_status_text      = lv_status_text
              es_json_response    = ls_response_function
          ).
          IF lv_status_code NE 200.
            me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA service: { lv_status_code } : { lv_status_text }.| ).
            ev_check_status = abap_false.
            ev_execution_status = abap_false.
          ELSE.
            me->mo_run_environment->append_log( iv_log_statement = |Successfully called ODATA service for document { <ls_docid>-vbeln }.| ).

            LOOP AT ls_response_function-d-results ASSIGNING FIELD-SYMBOL(<result>).
              IF <result>-messageid EQ 'CRE'.
                APPEND <result>-billingdocument TO ev_document_id.
              ELSE.
                me->mo_run_environment->append_log( iv_log_statement = <result>-message ).
              ENDIF.
            ENDLOOP.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP.


  ENDMETHOD.


  METHOD odata_post_create_pre_billing.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/SAP/SD_PRE_BIL_DOC_MANAGE/'.
    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    DATA lt_parameters TYPE /iwfnd/sutil_property_t.
    DATA: lv_status_text TYPE string,
          lv_status_code TYPE integer.
    DATA: ls_return     TYPE bapiret2.
    DATA: lv_msg             TYPE string,
          lv_status_code_txt TYPE string.
    TYPES: BEGIN OF ty_functionimportresult,
             billingdocument     TYPE string,
             billingdocumentitem TYPE string,
             messageid           TYPE string,
             messagetype         TYPE string,
             message             TYPE string,
           END OF ty_functionimportresult.

    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              results TYPE TABLE OF ty_functionimportresult,
            END OF d,
          END OF ls_response_function.
    ev_execution_status = abap_true.
    ev_check_status = abap_true.
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
      DATA(ls_refstep_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
      IF ls_refstep_data IS NOT INITIAL.
        LOOP AT ls_refstep_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).
          lt_parameters = VALUE #(
            ( name = 'PreliminaryBillingDocuments' value =  <ls_docid> )
            ( name = 'BillingDocumentDate' value =  '' )
            ( name = 'AutomaticallyPost' value =  '' )
          ).
          lo_odata_caller->call_service(
            EXPORTING
              iv_method           = 'POST'
              iv_action_or_entity = 'CreateBillingDocument'
              it_parameters       = lt_parameters
            IMPORTING
              ev_status_code      = lv_status_code
              ev_status_text      = lv_status_text
              es_json_response    = ls_response_function
          ).
          IF lv_status_code NE 200.
            me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA service: { lv_status_code } : { lv_status_text }.| ).
            ev_check_status = abap_false.
            ev_execution_status = abap_false.
          ELSE.
            me->mo_run_environment->append_log( iv_log_statement = |Successfully called ODATA service for document { <ls_docid>-vbeln }.| ).

            LOOP AT ls_response_function-d-results ASSIGNING FIELD-SYMBOL(<result>).
              IF <result>-messageid EQ 'CRE'.
                APPEND <result>-billingdocument TO ev_document_id.
              ELSE.
                me->mo_run_environment->append_log( iv_log_statement = <result>-message ).
              ENDIF.
            ENDLOOP.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP.


  ENDMETHOD.


  METHOD odata_post_finalize.
    me->odata_f2875_fi_post(
      EXPORTING
        iv_function_name    = c_function_name_finalize
        step_data           = step_data
        iv_step_number      = iv_step_number
      IMPORTING
        ev_document_id      = ev_document_id
        ev_execution_status = ev_execution_status
        ev_check_status     = ev_check_status
    ).
  ENDMETHOD.


  METHOD odata_post_reject_pre_bil_doc.
    me->odata_f2875_fi_post(
  EXPORTING
    iv_function_name    = c_function_name_reject_pbd
    step_data           = step_data
    iv_step_number      = iv_step_number
  IMPORTING
    ev_document_id      = ev_document_id
    ev_execution_status = ev_execution_status
    ev_check_status     = ev_check_status
).
  ENDMETHOD.


  METHOD odata_post_set_to_in_progress.
    me->odata_f2875_fi_post(
EXPORTING
iv_function_name    = c_function_name_set_progress
step_data           = step_data
iv_step_number      = iv_step_number
IMPORTING
ev_document_id      = ev_document_id
ev_execution_status = ev_execution_status
ev_check_status     = ev_check_status
).
  ENDMETHOD.


  METHOD raise_approval_action.

    DATA:
      ls_testdata          TYPE ty_gs_i_ptf_pbd_appr_action_id,
      lv_ptf_key           TYPE ptfkey,
      lt_prebilling_number TYPE cl_ptf_util=>ty_vbeln_tab,
      lv_swf_event         TYPE seocpdname,
      lt_workflow          TYPE STANDARD TABLE OF swr_wihdr,
      lt_task_filter       TYPE STANDARD TABLE OF swr_task,
      lv_subrc             LIKE sy-subrc,
      lt_msg               TYPE STANDARD TABLE OF swr_messag,
      lv_decision_key      TYPE swr_decikey,
      ls_vbrk              TYPE vbrkvb,
      lt_message           TYPE vbfs_t.


    ev_execution_status = abap_true.

    " check if the System is Extensibility Test System
    DATA(lv_is_ext_sys) = cl_ato_service_factory=>get_ato_service( )->is_extensibility_dev_system( ).

    " workflow is triggered asyn in ext. dev system
    IF lv_is_ext_sys EQ abap_true.
      WAIT UP TO 120 SECONDS.
    ENDIF.

    IF step_data-variant IS NOT INITIAL.
      cl_ptf_util=>get_testdata(
        EXPORTING
          is_step_data = step_data
        IMPORTING
          es_testdata  = ls_testdata ).
    ENDIF.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_prebilling_number.
    ENDLOOP.
    IF lt_prebilling_number IS INITIAL.
      me->mo_run_environment->append_log( 'There are no reference documentIDs!' ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.

    LOOP AT lt_prebilling_number ASSIGNING FIELD-SYMBOL(<vbeln>).

      CLEAR: lt_task_filter, lt_workflow.

      lv_decision_key = COND #( WHEN ls_testdata-action EQ if_sd_apm_approval=>co_approval_action-release       THEN '0001'
                                WHEN ls_testdata-action EQ if_sd_apm_approval=>co_approval_action-set_to_rework THEN '0003'
                                WHEN ls_testdata-action EQ if_sd_apm_approval=>co_approval_action-reject        THEN '0002' ).

      " extensibility system -> workflow and BAdI has to be configured
      IF lv_is_ext_sys EQ abap_true.
        " check and update existing workflow
        " workflow will be completed and billing header approval data will be set
        CALL FUNCTION 'SAP_WAPI_WORKITEMS_TO_OBJECT'
          EXPORTING
            object_por               = VALUE sibflporb( catid  = swfco_objtype_cl
                                                       typeid = 'CL_SD_BIL_PBD_WORKFLOW'
                                                       instid = <vbeln> )
            selection_status_variant = 0001   " all active workflows
            text                     = space
            top_level_items          = space
          TABLES
            task_filter              = lt_task_filter
            worklist                 = lt_workflow.

        LOOP AT lt_workflow ASSIGNING FIELD-SYMBOL(<ls_workflow>) WHERE wi_type = 'W'.
          CLEAR lv_subrc.
          CALL FUNCTION 'SAP_WAPI_DECISION_COMPLETE'
            EXPORTING
              workitem_id   = <ls_workflow>-wi_id
              decision_key  = lv_decision_key
              do_commit     = 'X'
            IMPORTING
              return_code   = lv_subrc
            TABLES
              message_lines = lt_msg.
          IF lv_subrc NE 0.
            ev_execution_status = abap_false.
          ELSE.
            LOOP AT lt_msg ASSIGNING FIELD-SYMBOL(<ls_msg>).
              me->mo_run_environment->append_log( iv_log_statement = |{ <ls_msg>-line }| ).
            ENDLOOP.
          ENDIF.
        ENDLOOP.
        IF sy-subrc NE 0.
          ev_execution_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |{ 'No Workflow Found' }| ).
        ENDIF.

        IF ev_execution_status EQ abap_true.
          MOVE <vbeln> TO lv_ptf_key.
          APPEND lv_ptf_key TO ev_document_id.
        ENDIF.

        " No extensibility system -> no workflow exists
      ELSE.
        " update header table with approval status data to simulate workflow

*        UPDATE vbrk SET apm_approval_status = 'A' apm_approval_reason = 'PBD1' WHERE vbeln = <vbeln>.

*parameter for RV_INVOICE_DOCUMENT_READ
        DATA: ls_vbrk_i TYPE vbrk,
              ls_vbrk_e TYPE vbrk,
              lt_xvbrk  TYPE TABLE OF vbrkvb,
              lt_xvbrp  TYPE TABLE OF vbrpvb.

        DATA: ls_vbsk_i TYPE vbsk,
              lt_xkomv  TYPE TABLE OF komv,
              lt_xsadr  TYPE TABLE OF sadrvb,
              lt_xvbfa  TYPE TABLE OF vbfavb,
              lt_xvbfs  TYPE TABLE OF vbfs,
              lt_xvbpa  TYPE TABLE OF vbpavb,
              lt_xvbss  TYPE TABLE OF vbss,
              lt_yvbpa  TYPE TABLE OF vbpavb,
              lt_yvbrk  TYPE TABLE OF vbrkvb,
              lt_xvbuk  TYPE TABLE OF vbukvb,
              lt_xvbup  TYPE TABLE OF vbupvb,
              lt_xkomfk TYPE TABLE OF komfk,
              lt_xthead TYPE TABLE OF theadvb.
        ls_vbrk_i-vbeln = <vbeln>.
        CALL FUNCTION 'RV_INVOICE_DOCUMENT_READ'
          EXPORTING
            activity             = '02' "'Change'
            "konv_read            = 'X'
            no_nast              = abap_true
            vbrk_i               = ls_vbrk_i
            i_no_authority_check = abap_true
          IMPORTING
            vbrk_e               = ls_vbrk_e
          TABLES
            xkomv                = lt_xkomv
            xvbpa                = lt_xvbpa
            xvbrk                = lt_xvbrk
            xvbrp                = lt_xvbrp
            xvbss                = lt_xvbss
            xthead               = lt_xthead
            xkomfk               = lt_xkomfk
          EXCEPTIONS
            OTHERS               = 1.
        IF sy-subrc <> 0.
          mo_run_environment->append_log( iv_log_statement = |{ 'Preceding doc not found.' }| ).
          ev_execution_status = abap_false.
          EXIT.
        ENDIF.
        LOOP AT lt_xvbrk ASSIGNING FIELD-SYMBOL(<ls_vbrk>) WHERE vbeln = <vbeln>.
          <ls_vbrk>-apm_approval_status = 'A'.
          <ls_vbrk>-apm_approval_reason = 'PBD1'.
          <ls_vbrk>-updkz = 'U'.
        ENDLOOP.
        CALL FUNCTION 'RV_INVOICE_POST' "IN UPDATE TASK
          EXPORTING
            vbsk_i       = ls_vbsk_i
            vf02         = 'X'
            with_posting = 'D'
          TABLES
            xkomv        = lt_xkomv
            xsadr        = lt_xsadr
            xvbfa        = lt_xvbfa
            xvbfs        = lt_xvbfs
            xvbpa        = lt_xvbpa
            xvbrk        = lt_xvbrk
            xvbrp        = lt_xvbrp
            xvbss        = lt_xvbss
            xvbuk        = lt_xvbuk
            xvbup        = lt_xvbup
            yvbpa        = lt_yvbpa
            yvbrk        = lt_xvbrk
            yvbrp        = lt_xvbrp
            yvbuk        = lt_xvbuk
            yvbup        = lt_xvbup.

        " do the update of billing header approval data
        ls_vbrk-vbeln = <vbeln>.
        TRY.
            CALL FUNCTION 'RV_INVOICE_SET_APPROVAL_ACTION'
              EXPORTING
                is_xvbrk           = ls_vbrk
                iv_approval_action = ls_testdata-action
              IMPORTING
                et_vbfs            = lt_message.
*              EXCEPTIONS
*                OTHERS             = 1.
          CATCH cx_sd_billing INTO DATA(lx).
            mo_run_environment->append_log( iv_log_statement = |{ 'Error raised by productive logic.' }| ).
            ev_execution_status = abap_false.
            RETURN.
        ENDTRY.
        get_message_text( it_message = lt_message ).

      ENDIF.

      APPEND <vbeln>  TO ev_document_id.
    ENDLOOP.

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

  ENDMETHOD.


  METHOD reject.
    TYPES:
      BEGIN OF ty_billing_instruction,
        id                     TYPE vbeln,
        item_id                TYPE posnr,
        billing_doc_type       TYPE fkart,
        sd_document_category   TYPE vbtypl,
        billing_requested_date TYPE fkdat_bis,
      END OF ty_billing_instruction ,
      BEGIN OF ty_draft_vbeln,
        vbeln TYPE ptfkey,
      END OF ty_draft_vbeln ,
      tt_draft_vbeln TYPE STANDARD TABLE OF ty_draft_vbeln WITH DEFAULT KEY.

    DATA:
      ls_return            TYPE bapiret2,
      lt_return            TYPE TABLE OF bapiret2,
      lt_prebilling_number TYPE tt_draft_vbeln,
      ls_prebilling_number TYPE ty_draft_vbeln,
      lv_vbeln             TYPE vbeln,
      lt_message           TYPE if_sd_bil_type_def=>tt_message.

*****************************************************************************
* 1 Step: Prepare data for BAPI call
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_prebilling_number.
    ENDLOOP.
*****************************************************************************
* 2 Step: Reject
    TYPES:
      BEGIN OF ty_vbeln_orig,
        vbeln TYPE vbeln,
      END OF ty_vbeln_orig.
    DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.
    MOVE lt_prebilling_number TO lt_vbeln_key.


    cl_sd_bil_prebilling_facade=>if_sd_bil_prebilling_action~reject(
      EXPORTING
        iv_posting                    = 'D'
        it_prebilling                 = lt_vbeln_key
      IMPORTING
        et_message                    = lt_message ).

*****************************************************************************
* 3 Step: Commit and fill et_Return
    me->get_message_text( it_message = lt_message ).

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
******************************************************************************
* 4 Step: Check if EBDR exists
    CLEAR lv_vbeln.
    LOOP AT lt_prebilling_number INTO lv_vbeln.
      DATA: lt_ptf_key TYPE ptfkey.
      MOVE lv_vbeln TO lt_ptf_key.
      ev_execution_status = me->check_existence( iv_id = lt_ptf_key ).
      IF ev_execution_status EQ abap_false.
        RETURN.
      ELSE.
        APPEND lt_ptf_key TO ev_document_id.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD release.

    TYPES: BEGIN OF ty_draft_vbeln,
             vbeln TYPE ptfkey,
           END OF ty_draft_vbeln ,

           tt_draft_vbeln TYPE STANDARD TABLE OF ty_draft_vbeln WITH DEFAULT KEY.

    DATA: ls_testdata          TYPE            cl_ptf_bo_invoice=>ty_gs_ptf_bd_check_td,
          lt_message           TYPE            vbfs_t,
          ls_vbrk              TYPE            vbrkvb,
          iv_posting           TYPE            vf_posting,
          lv_vbeln             TYPE            vbeln,
          lt_prebilling_number TYPE            tt_draft_vbeln,
          ls_vbrk_i            TYPE            vbrk,
          ls_vbrk_e            TYPE            vbrk,
          ls_vbsk_i            TYPE            vbsk,
          lt_xkomv             TYPE TABLE OF   komv,
          lt_xvbpa             TYPE TABLE OF   vbpavb,
          lt_xvbrk             TYPE TABLE OF   vbrkvb,
          lt_xvbrp             TYPE TABLE OF   vbrpvb,
          lt_vbrk              TYPE TABLE OF   vbrkvb,
          lt_xsadr             TYPE TABLE OF   sadrvb,
          lt_xvbfa             TYPE TABLE OF   vbfavb,
          lt_xvbfs             TYPE TABLE OF   vbfs,
          lt_xvbss             TYPE TABLE OF   vbss,
          lt_xvbuk             TYPE TABLE OF   vbukvb,
          lt_xvbup             TYPE TABLE OF   vbupvb,
          lt_yvbpa             TYPE TABLE OF   vbpavb.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_prebilling_number.
    ENDLOOP.

    LOOP AT lt_prebilling_number ASSIGNING FIELD-SYMBOL(<vbeln>).
      ls_vbrk_i-vbeln = <vbeln>.
      CALL FUNCTION 'RV_INVOICE_DOCUMENT_READ'
        EXPORTING
          activity             = '03'
          konv_read            = 'X'
          no_nast              = abap_true
          vbrk_i               = ls_vbrk_i
          i_no_authority_check = abap_true
        IMPORTING
          vbrk_e               = ls_vbrk_e
        TABLES
          xkomv                = lt_xkomv
          xvbpa                = lt_xvbpa
          xvbrk                = lt_xvbrk
          xvbrp                = lt_xvbrp
        EXCEPTIONS
          no_authority         = 1
          OTHERS               = 2.

      MOVE-CORRESPONDING ls_vbrk_e TO ls_vbrk.
      ls_vbrk-apm_approval_reason = 'PBD1'.
      ls_vbrk-pbd_status = 'B'.

      TRY.
          cl_sd_bil_apm_helper=>get_approval_data(
          EXPORTING
            iv_mode    = cl_sd_bil_apm_helper=>mc_mode-no_check_evtraise
          CHANGING
            cs_d_vbrk  = ls_vbrk
            ct_message =  lt_message   " Error Log for Collective Processing
            ).
        CATCH cx_sd_billing.
      ENDTRY.
      ls_vbrk-apm_approval_status = 'B'.

      APPEND ls_vbrk TO lt_vbrk.

      iv_posting = 'D'.
      CALL FUNCTION 'RV_INVOICE_POST'
        EXPORTING
          vbsk_i       = ls_vbsk_i
          vf02         = 'X'
          with_posting = iv_posting
        TABLES
          xkomv        = lt_xkomv
          xsadr        = lt_xsadr
          xvbfa        = lt_xvbfa
          xvbfs        = lt_xvbfs
          xvbpa        = lt_xvbpa
          xvbrk        = lt_vbrk
          xvbrp        = lt_xvbrp
          xvbss        = lt_xvbss
          xvbuk        = lt_xvbuk
          xvbup        = lt_xvbup
          yvbpa        = lt_yvbpa
          yvbrk        = lt_xvbrk
          yvbrp        = lt_xvbrp
          yvbuk        = lt_xvbuk
          yvbup        = lt_xvbup.

    ENDLOOP.

    me->get_message_text( it_message = lt_message ).
    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

    CLEAR lv_vbeln.
    LOOP AT lt_prebilling_number INTO lv_vbeln.
      DATA: lv_ptf_key TYPE ptfkey.
      MOVE lv_vbeln TO lv_ptf_key.
      ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).
      IF ev_execution_status EQ abap_false.
        RETURN.
      ELSE.
        APPEND lv_ptf_key TO ev_document_id.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD schedule_pbd_creation.
    DATA: documents_to_process TYPE TABLE OF ptfkey,
          v60p_input_rv60a     TYPE  rv60a,
          lt_vbfs              TYPE TABLE OF vbfs,
          lt_vbss              TYPE TABLE OF vbss,
          gt_fvkdfi            TYPE TABLE OF vkdfif,
          log                  TYPE bapiret2.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(documents) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      APPEND LINES OF documents TO documents_to_process.
    ENDLOOP.

    IF lines( documents_to_process ) EQ 0.
      ev_execution_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |No reference documents to process| ).
      RETURN.
    ENDIF.

    LOOP AT documents_to_process ASSIGNING FIELD-SYMBOL(<ref_doc>).
      APPEND VALUE #( selkz = abap_true mandt = sy-mandt vbeln = <ref_doc>  ) TO gt_fvkdfi.
    ENDLOOP.

    CALL FUNCTION 'SD_COLLECTIVE_RUN_EXECUTE'
      EXPORTING
        v60p_input_rv60a     = v60p_input_rv60a
        id_utasy             = abap_true
        id_utswl             = abap_false
        id_utsnl             = abap_false
        iv_create_prebilling = abap_true
      TABLES
        v60p_input_vkdfif    = gt_fvkdfi
        v60p_output_vbfs     = lt_vbfs
        v60p_output_vbss     = lt_vbss
      EXCEPTIONS
        OTHERS               = 1.

    IF sy-subrc = 1.
      "Error occured
      ev_execution_status = abap_false.

    ELSE.
      "Everything is fine
      ev_execution_status = abap_true.
    ENDIF.

    LOOP AT lt_vbfs ASSIGNING FIELD-SYMBOL(<msg>).
      CLEAR log.
      log-message = <msg>-msgid.
      log-log_no = <msg>-msgno.
      log-message_v1 = <msg>-msgv1.
      log-message_v2 = <msg>-msgv2.
      log-message_v3 = <msg>-msgv3.
      log-message_v4 = <msg>-msgv4.
      log-type = <msg>-msgty.
      me->mo_run_environment->append_log_structure( is_log = log ).
      IF <msg>-msgty EQ 'E'.
        ev_execution_status = abap_false.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_vbss ASSIGNING FIELD-SYMBOL(<result>).
      APPEND <result>-vbeln TO ev_document_id.
      me->mo_run_environment->append_log( iv_log_statement = |PBD { <result>-vbeln } was created with job { <result>-sammg }| ).
    ENDLOOP.


  ENDMETHOD.


  METHOD setinprogress.
    TYPES:
      BEGIN OF ty_billing_instruction,
        id                     TYPE vbeln,
        item_id                TYPE posnr,
        billing_doc_type       TYPE fkart,
        sd_document_category   TYPE vbtypl,
        billing_requested_date TYPE fkdat_bis,
      END OF ty_billing_instruction ,
      BEGIN OF ty_draft_vbeln,
        vbeln TYPE ptfkey,
      END OF ty_draft_vbeln ,
      tt_draft_vbeln TYPE STANDARD TABLE OF ty_draft_vbeln WITH DEFAULT KEY.

    DATA:
      ls_return            TYPE bapiret2,
      lt_return            TYPE TABLE OF bapiret2,
      lt_prebilling_number TYPE tt_draft_vbeln,
      ls_prebilling_number TYPE ty_draft_vbeln,
      lv_vbeln             TYPE vbeln,
      lt_message           TYPE if_sd_bil_type_def=>tt_message.

*****************************************************************************
* 1 Step: Prepare data for BAPI call
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_prebilling_number. """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    ENDLOOP.

*****************************************************************************
* 2 Step: SetInProgress
    TYPES:
      BEGIN OF ty_vbeln_orig,
        vbeln TYPE vbeln,
      END OF ty_vbeln_orig.
    DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.
    MOVE lt_prebilling_number TO lt_vbeln_key.

    cl_sd_bil_prebilling_facade=>if_sd_bil_prebilling_action~setinprogress(
      EXPORTING
        it_prebilling                  =  lt_vbeln_key
        iv_posting                     = 'D'
      IMPORTING
        et_message                     =  lt_message   ).
*****************************************************************************
* 3 Step: Commit and fill et_Return
    me->get_message_text( it_message = lt_message ).

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
******************************************************************************
* 4 Step: Check if EBDR exists
    CLEAR lv_vbeln.
    LOOP AT lt_prebilling_number INTO lv_vbeln.
      DATA: lv_ptf_key TYPE ptfkey.
      MOVE lv_vbeln TO lv_ptf_key.
      ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).
      IF ev_execution_status EQ abap_false.
        RETURN.
      ELSE.
        APPEND lv_ptf_key TO ev_document_id.
      ENDIF.
    ENDLOOP.


  ENDMETHOD.


  METHOD withdraw_from_approval.

    DATA: ls_testdata          TYPE            cl_ptf_bo_invoice=>ty_gs_ptf_bd_check_td,
          lt_message           TYPE            vbfs_t,
          lv_vbeln             TYPE            vbeln,
          lt_prebilling_number TYPE            cl_ptf_util=>ty_vbeln_tab,
          ls_vbrk_i            TYPE            vbrk,
          ls_vbrk_e            TYPE            vbrk,
          ls_vbsk_i            TYPE            vbsk,
          lt_xkomv             TYPE TABLE OF   komv,
          lt_xkomfk            TYPE TABLE OF   komfk,
          lt_xvbss             TYPE TABLE OF   vbss,
          lt_xthead            TYPE TABLE OF   theadvb,
          lt_xvbpa             TYPE TABLE OF   vbpavb,
          lt_xvbrk             TYPE TABLE OF   vbrkvb,
          lt_xvbrp             TYPE TABLE OF   vbrpvb,
          lt_xsadr             TYPE TABLE OF   sadrvb,
          lt_xvbfa             TYPE TABLE OF   vbfavb,
          lt_xvbfs             TYPE TABLE OF   vbfs,
          lt_xvbuk             TYPE TABLE OF   vbukvb,
          lt_xvbup             TYPE TABLE OF   vbupvb,
          lt_yvbpa             TYPE TABLE OF   vbpavb.

    ev_execution_status = abap_true.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_prebilling_number.
    ENDLOOP.

    TRY.
        cl_sd_billing_control=>get_instance( )->set_pbd_doc_crtn_process( cl_sd_billing_control=>sc_pbd_crt_process-v_with_finalize ).
      CATCH cx_sd_billing. " Exception for Omnichannel Convergent Billing
    ENDTRY.

    LOOP AT lt_prebilling_number ASSIGNING FIELD-SYMBOL(<vbeln>).
      ls_vbrk_i-vbeln = <vbeln>.
      CLEAR: ls_vbrk_e.

      CALL FUNCTION 'RV_INVOICE_DOCUMENT_READ'
        EXPORTING
          activity             = '03'
          konv_read            = 'X'
          no_nast              = abap_true
          vbrk_i               = ls_vbrk_i
          i_no_authority_check = abap_true
        IMPORTING
          vbrk_e               = ls_vbrk_e
        TABLES
          xkomv                = lt_xkomv
          xvbpa                = lt_xvbpa
          xvbrk                = lt_xvbrk
          xvbrp                = lt_xvbrp
          xvbss                = lt_xvbss
          xthead               = lt_xthead
          xkomfk               = lt_xkomfk
        EXCEPTIONS
          OTHERS               = 1.

      DATA(ls_vbrkvb) = CORRESPONDING vbrkvb( ls_vbrk_e ).
      CLEAR: ls_vbrk_e.
      TRY.
          CALL FUNCTION 'RV_INVOICE_SET_APPROVAL_ACTION'
            EXPORTING
              is_xvbrk           = ls_vbrkvb
              iv_approval_action = if_sd_apm_approval=>co_approval_action-withdraw
              it_xkomv           = lt_xkomv
              it_xvbpa           = lt_xvbpa
              it_xvbrp           = lt_xvbrp
            IMPORTING
              et_vbfs            = lt_message
              es_vbrk            = ls_vbrk_e.
        CATCH cx_sd_billing INTO DATA(lx).
          mo_run_environment->append_log( iv_log_statement = |{ 'Error raised by productive logic.' }| ).
          ev_execution_status = abap_false.
          RETURN.
      ENDTRY.

      me->get_message_text( it_message = lt_message ).
      IF ls_vbrk_e IS INITIAL.
        ev_execution_status = abap_false.
      ENDIF.
    ENDLOOP.

    IF ev_execution_status EQ abap_true.
      cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
      CLEAR lv_vbeln.
      LOOP AT lt_prebilling_number INTO lv_vbeln.
        DATA: lv_ptf_key TYPE ptfkey.
        MOVE lv_vbeln TO lv_ptf_key.
        ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).
        IF ev_execution_status EQ abap_false.
          RETURN.
        ELSE.
          APPEND lv_ptf_key TO ev_document_id.
        ENDIF.
      ENDLOOP.
    ENDIF.

    TRY.
        cl_sd_billing_control=>get_instance( )->set_pbd_doc_crtn_process( cl_sd_billing_control=>sc_pbd_crt_process-v_standard ).
      CATCH cx_sd_billing. " Exception for Omnichannel Convergent Billing
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
