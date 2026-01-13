class CL_PTF_BO_EBDR definition
  public
  inheriting from CL_PTF_BO
  final
  create public .

public section.

  types:
    BEGIN OF ty_gs_ebdr_cr_trit_tdt_double,
        ebdr_request_in       TYPE sdbil_ebdr_request_t,
        ebdr_requ_cond_in     TYPE sdbil_ebdr_request_cond_t,
        ebdr_requ_text_in     TYPE bapiebdrrequesttext_t,
        is_trit_active        TYPE abap_bool,
        tax_country           TYPE land1,
        registered_countries  TYPE cl_ptf_bo_invoice=>tt_countries,
        is_tdt_active         TYPE abap_bool,
        start_date            TYPE sy-datum,
        period_length_in_days TYPE i,
      END OF ty_gs_ebdr_cr_trit_tdt_double .
  types:
    BEGIN OF ty_gs_i_ptf_ebdr_cr_excel_td,
        excel TYPE xstring,
      END OF ty_gs_i_ptf_ebdr_cr_excel_td .
  types:
* Structure for External Billing Document Request Create
    BEGIN OF ty_gs_i_ptf_ebdr_cr_td,
        ebdr_request_in   TYPE sdbil_ebdr_request_t,
        ebdr_requ_cond_in TYPE sdbil_ebdr_request_cond_t,
        ebdr_requ_text_in TYPE bapiebdrrequesttext_t,
      END OF ty_gs_i_ptf_ebdr_cr_td .
  types:
    ty_ebdr_requests    TYPE STANDARD TABLE OF ty_gs_i_ptf_ebdr_cr_td WITH DEFAULT KEY .
  types:
    BEGIN OF ty_gs_i_ptf_ebdr_cr_mult_td,
        ebdr_requests TYPE ty_ebdr_requests,
      END OF ty_gs_i_ptf_ebdr_cr_mult_td .
  types:
* Structure for External Billing Document Request Create for negative testing
    BEGIN OF ty_gs_i_ptf_ebdr_cr_neg_td,
        senderlogicalsystem         TYPE string,
        determine_precedingdocument TYPE abap_bool,
        ebdr_request_in             TYPE bapiebdrrequest_t,
        ebdr_requ_cond_in           TYPE bapiebdrrequestcond_t,
        ebdr_requ_text_in           TYPE bapiebdrrequesttext_t,
      END OF ty_gs_i_ptf_ebdr_cr_neg_td .
  types:
* Structure for External Billing Document Request Create (SOA/ESR/Proxy)
    BEGIN OF ty_gs_i_ptf_ebdr_cr_ws_td,
        bdr_request_msg      TYPE sdbil_esr_bdr_request_msg,
        bdr_confirmation_msg TYPE sdbil_esr_bdr_confirmation_msg,
        ext_fields           TYPE cl_ptf_sd_util=>ty_gt_ext_field_td,
      END OF ty_gs_i_ptf_ebdr_cr_ws_td .
  types:
* Structure for External Billing Document Create (SOA/ESR/Proxy)
    BEGIN OF ty_gs_i_ptf_bd_cr_ws_td,
        bd_request_msg TYPE sdbil_esr_bd_request_msg,
      END OF ty_gs_i_ptf_bd_cr_ws_td .
  types:
* Structure Billing Document Create
    BEGIN OF ty_gs_i_ptf_bd_cr_td,
        invoice_type            TYPE fkart,
        invoice_date            TYPE fkdat,
        i_no_collective_billing TYPE abap_bool,
        with_posting            TYPE string,
      END OF ty_gs_i_ptf_bd_cr_td .
  types:
* Control structure: create BDR with reference
    BEGIN OF ty_gs_i_ptf_ebdr_cr_ref_td,
        with_cond_table TYPE abap_bool,
        with_knumv      TYPE abap_bool,
      END OF ty_gs_i_ptf_ebdr_cr_ref_td .
  types:
** Structure for EBDR event
    BEGIN OF ty_gs_i_ptf_ebdr_event_td,
        event TYPE sibfevent,
      END OF ty_gs_i_ptf_ebdr_event_td .
  types:
** Structure for execute by soap api
    BEGIN OF ty_gs_execute_by_soap_td,
        user_name           TYPE string,
        password            TYPE string,
        payload             TYPE string,
        max_wait_time       TYPE num10,   "maximum waiting time
        lock_reference_doc  TYPE abap_boolean,
        appl_error_expected TYPE abap_boolean,  "indicates that SOAP request results in application error with no confirmation message created
        action_code         TYPE string,  "action-code for BO in SOAP payload: SPACE, '1' or '01' for create; '2' or '02' for change
      END OF ty_gs_execute_by_soap_td .
  types:
** Structure for execute by soap api
    BEGIN OF ty_gs_execute_by_odata_td,
        json_payload TYPE string,
        url          TYPE string,
        wait_time    TYPE string,
      END OF ty_gs_execute_by_odata_td .
  types:
      "TDCP Of A2A Call API action
    BEGIN OF ty_gs_ptf_call_by_soap_td,
        username    TYPE string,
        password    TYPE string,
        host        TYPE string,
        request_uri TYPE string,
        payload     TYPE string,
      END OF ty_gs_ptf_call_by_soap_td .
  types:
* Structure for price element in item
    BEGIN OF ty_gs_price_element_td,
        item_number        TYPE posnr,
        condition_type     TYPE kschl,
        condition_amount   TYPE kbetr,
        condition_value    TYPE kwert,
        condition_currency TYPE waerk,
      END OF ty_gs_price_element_td .
  types:
    ty_gt_price_element_td TYPE STANDARD TABLE OF ty_gs_price_element_td WITH DEFAULT KEY .
  types:
      BEGIN OF ty_field_name,
        field_name TYPE string,
      END OF ty_field_name .
  types:
      tt_field_names TYPE STANDARD TABLE OF ty_field_name WITH DEFAULT KEY .
  types:
      BEGIN OF ty_gs_compare_irrelevant,
        irrelevant_head_fields TYPE tt_field_names,
        irrelevant_pos_fields  TYPE tt_field_names,
      END OF ty_gs_compare_irrelevant .
*** Structure for confirmation message and log from SOAP Confirmation Receiver
*    TYPES:
*      BEGIN OF ty_gs_confirmation_message,
*        reference_id TYPE string,
*        confirmation TYPE string,
*        log          TYPE string,
*      END OF ty_gs_confirmation_message .
*    TYPES:
*** Table for confirmation messages and logs from SOAP Confirmation Receiver
*      ty_gt_confirmation_message TYPE STANDARD TABLE OF ty_gs_confirmation_message WITH NON-UNIQUE KEY reference_id .
*    TYPES:
*** Structure for storing logs while comparing in compare method
*      tty_comparison_log TYPE TABLE OF string .
*    TYPES:
*** Structure for external names in confirmation message retrieved from SOAP Confirmation Receiver
*      BEGIN OF ty_gs_conf_message_ext_names,
*        ext_name_single_request TYPE string,
*        ext_name_bulk_request   TYPE string,
*        ext_name_notification   TYPE string,
*      END OF ty_gs_conf_message_ext_names .
  types:
    BEGIN OF ty_gs_item_pprctr,
      item_number           TYPE posnr,
      partner_profit_center TYPE pprctr,
    END OF ty_gs_item_pprctr,
    item_pprctr_tab TYPE STANDARD TABLE OF ty_gs_item_pprctr WITH DEFAULT KEY,
    BEGIN OF ty_gs_bd_item_pprctr_check,
      item_pprctr_check     TYPE item_pprctr_tab,
    END OF ty_gs_bd_item_pprctr_check.
  class-methods KEEPING_LOCK_TASK
    importing
      !P_TASK type CHAR32 .

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

  types TY_GS_PTF_PAYMENTCARD_CHECK_TD type SDBIL_ESR_BDR_PAYMENT_CARD_TAB .

  constants _MC_FUNCTION_DELETE type STRING value 'DeleteBillingDocumentRequest' ##NO_TEXT.
  constants _MC_FUNCTION_REJECT type STRING value 'RejectBillingDocumentRequest' ##NO_TEXT.
  constants C_CHECK_AGAINST_REFERENCE type STRING value 'CHECK_AGAINST_REFERENCE' ##NO_TEXT.
  constants C_CHECK_NEGATIVE type STRING value 'CHECK_NEGATIVE' ##NO_TEXT.
  constants C_CHECK_REFERENCE_TAX type STRING value 'CHECK_REFERENCE_TAX' ##NO_TEXT.
  constants C_CHECK_EVENT type STRING value 'CHECK_EVENT' ##NO_TEXT.
  constants C_CHECK_WITH_ODATA type STRING value 'CHECK_WITH_ODATA' ##NO_TEXT.
  constants C_API_ODATA_DEL_FI_DEL_NEG type STRING value 'API_DELETE_BDR_NEG' ##NO_TEXT.
  constants C_API_ODATA_REJ_FI_NEG type STRING value 'ODATA_BDR_FI_REJECT_NEG' ##NO_TEXT.
  constants C_CREATE_MULTIPLE type STRING value 'CREATE_MULTIPLE' ##NO_TEXT.
  constants C_ODATA_GET_BD type STRING value 'ODATA_GET_BD' ##NO_TEXT.
  constants C_ODATA_POST_CANCEL_BD type STRING value 'ODATA_POST_CANCEL_BD' ##NO_TEXT.
  constants C_CREATE_NEGATIVE type STRING value 'CREATE_NEGATIVE' ##NO_TEXT.
  constants C_CREATE_SAME_PRECEDING type STRING value 'CREATE_SAME_PRECEDING' ##NO_TEXT.
  constants C_CREATE_WITH_REFERENCE type STRING value 'CREATE_WITH_REFERENCE' ##NO_TEXT.
  constants C_CREATE_WITH_WEB_SERVICE type STRING value 'CREATE_WITH_WEB_SERVICE' ##NO_TEXT.
  constants C_REJECT_WITH_ODATA type STRING value 'REJECT_WITH_ODATA' ##NO_TEXT.
  constants C_DELETE_WITH_ODATA type STRING value 'DELETE_WITH_ODATA' ##NO_TEXT.
  constants C_ODATA_F2337_GET type STRING value 'ODATA_F2337_GET' ##NO_TEXT.
  constants C_ODATA_BDR_GET type STRING value 'ODATA_BDR_GET' ##NO_TEXT.
  constants C_API_ODATA_DELETE_FI_DELETE type STRING value 'API_DELETE_BDR' ##NO_TEXT.
  constants C_ODATA_BDR_FI_REJECT type STRING value 'ODATA_BDR_FI_REJECT' ##NO_TEXT.
  constants C_CHECK_PAYPAL_DATA type STRING value 'CHECK_PAYPAL_DATA' ##NO_TEXT.
  constants C_ACTION_UNLOCK type STRING value 'UNLOCK' ##NO_TEXT.
  constants C_ACTION_LOCK type STRING value 'LOCK' ##NO_TEXT.
  constants C_CREATE_VIA_EXCEL type STRING value 'CREATE_VIA_EXCEL' ##NO_TEXT.
  constants C_CHECK_DELETION type STRING value 'CHECK_DELETION' ##NO_TEXT.
  constants C_CREATE_PBDR_W_REF type STRING value 'CREATE_PBDR_W_REF' ##NO_TEXT.
  class-data MV_UNLOCKED_ASYNC type CHAR1 .
  class-data MV_LOCKED_ASYNC type CHAR1 .
  class-data MV_EVENT_LINKAGES_CREATED type CHAR1 .
  constants C_REJECT type STRING value 'REJECT' ##NO_TEXT.
  constants C_CREATE_PDPR_W_REF type STRING value 'CREATE_PDPR_W_REF' ##NO_TEXT.
  constants C_CHECK_NEW_PROJECT_BILLING type STRING value 'CHECK_NEW_PROJECT_BILLING' ##NO_TEXT.
  constants C_WAIT type STRING value 'WAIT' ##NO_TEXT.
  constants C_CHECK_EXPECTED_DOC_QUANTITY type STRING value 'CHECK_EXPECTED_DOC_QUANTITY' ##NO_TEXT.
  constants C_CREATE_SBDR type STRING value 'CREATE_SBDR_WITH_ODATA' ##NO_TEXT.
  constants C_CHECK_TEXT_EXISTED type STRING value 'CHECK_TEXT_EXISTED' ##NO_TEXT.
  constants C_CHECK_TEXT_NONEXIST type STRING value 'CHECK_TEXT_NONEXIST' ##NO_TEXT.
  constants C_CHECK_CONDITIONS_EXIST type STRING value 'CHECK_CONDITIONS_EXIST' ##NO_TEXT.
  constants C_CHECK_COMPARE_BDR_DB type STRING value 'CHECK_COMPARE_BDR_DB' ##NO_TEXT.
  constants C_CREATE_EBDR_ICO type STRING value 'CREATE_EBDR_ICO' ##NO_TEXT.

  methods CREATE_VIA_EXCEL
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods API_ODATA_POST_FI_REJECT
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods REJECT
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods API_ODATA_DELETE_FI_DELETE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods API_ODATA_GET_BDR
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_F2337_GET
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods DELETE_WITH_ODATA
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_FUNCTION_IMPORT
    importing
      !IV_FUNCTION_NAME type STRING
      !CS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !ET_FUNCTION_RETURN type SDBIL_EBDR_REQUEST_MSG_T
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods REJECT_WITH_ODATA
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_WITH_WEB_SERVICE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods MAP_ORDER_DATA
    importing
      !IT_ORDER_NUMBER type CL_PTF_UTIL=>TY_VBELN_TAB
      !IV_WITH_KNUMV type ABAP_BOOL default ABAP_FALSE
    exporting
      !ET_EBDR_REQUEST type SDBIL_EBDR_REQUEST_T
      !ET_EBDR_REQUEST_COND type SDBIL_EBDR_REQUEST_COND_T .
  methods GET_ORDER_NUMBER
    importing
      !CS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !ET_ORDER_NUMBER type CL_PTF_UTIL=>TY_VBELN_TAB .
  methods CALL_EBDR_FACADE
    importing
      !IT_EBDR_REQUEST type SDBIL_EBDR_REQUEST_T
      !IT_EBDR_REQUEST_COND type SDBIL_EBDR_REQUEST_COND_T optional
    exporting
      !ET_BDR_NUMBER type CL_PTF_UTIL=>TY_VBELN_TAB .
  methods CREATE_FROM_ORDER
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_SAME_PRECEDING
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_FOR_NEGATIVE_TESTING
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods API_POST_FI_CANCEL_BD
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_AGAINST_REFERENCE            "check_against_order
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_NEGATIVE            "check_no_doc_was_created
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_REFERENCE_TAX            "check_order_tax
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_EVENT
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_WITH_ODATA
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods API_ODATA_DELETE_FI_DELETE_NEG
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods API_ODATA_POST_FI_REJECT_NEG
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_MULTIPLE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods API_ODATA_GET_FI_BD
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_PAYPAL_DATA
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods UNLOCK
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I optional
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods LOCK
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I optional
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_DELETION
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_PBDR_W_REF
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_PDPR_W_REF
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_NEW_PROJECT_BILLING
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods WAIT
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_EXPECTED_DOC_QUANTITY
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_SBDR_WITH_ODATA
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_TEXT_EXISTED
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_TEXT_NONEXIST
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_CONDITIONS_EXIST
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_COMPARE_BDR_DB
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods RESERVE_ACTION_1
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods RESERVE_ACTION_2
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods RESERVE_ACTION_3
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_PROFITABI_SEGMENT_VALUES
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_EBDR_ITEM_PPRCTR
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_EBDR_ICO
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
ENDCLASS.



CLASS CL_PTF_BO_EBDR IMPLEMENTATION.


  METHOD api_odata_delete_fi_delete.
    DATA: lv_status_text     TYPE string,
          lv_status_code     TYPE integer,
          lv_step_success    TYPE abap_bool,
          lv_status_code_txt TYPE string,
          lv_msg             TYPE string,
          ls_return          TYPE bapiret2,
          lv_service_uri     TYPE string VALUE '/sap/opu/odata/sap/API_BILLING_DOCUMENT_REQUEST_SRV/',
          lt_parameters      TYPE /iwfnd/sutil_property_t.

    TYPES: BEGIN OF ty_functionimportresult,
             billingdocumentrequest     TYPE vbeln_va,
             billingdocumentrequestitem TYPE posnr,
             type                       TYPE string,
             title                      TYPE string,
           END OF ty_functionimportresult.

    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              results TYPE TABLE OF ty_functionimportresult,
            END OF d,
          END OF ls_response_function.

    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    LOOP AT step_data-reference_step INTO DATA(lv_prestepnumber).
      DATA(ls_check_step_data) = me->mo_run_environment->get_step_data( iv_step_number = lv_prestepnumber ).

      LOOP AT ls_check_step_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).
        lt_parameters = VALUE #( ( name = 'BillingDocumentRequest' value =  <ls_docid> ) ).

        lo_odata_caller->call_service(
          EXPORTING
            iv_method           = 'DELETE'
            iv_action_or_entity = 'A_BillingDocumentRequest'
            it_parameters       = lt_parameters                   " Name/Value Pair - Table
          IMPORTING
            ev_status_code      = lv_status_code                  " Whole Number with +/- Sign (-2.147.483.648 .. 2.147.483.647)
            ev_status_text      = lv_status_text
            es_json_response    = ls_response_function
        ).

        lv_status_code_txt = lv_status_code.
        CONCATENATE 'Executed API Call A_BillingDocumentRequest with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
        me->mo_run_environment->append_log( iv_log_statement = lv_msg ).

        IF lv_status_code = 204.
          lv_step_success = abap_true.
        ELSE.
          me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
          lv_step_success = abap_false.
          EXIT.
        ENDIF.

      ENDLOOP.

    ENDLOOP.

** Output in case of success
    IF lv_step_success EQ abap_true.
      ev_execution_status = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |The Values of the checked document are correct. Processstep is: { step_data-step_number }| ).
    ELSE.
      ev_execution_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |The Values of the checked document are not correct. Processstep is: { step_data-step_number }| ).
    ENDIF.

  ENDMETHOD.


  METHOD api_odata_delete_fi_delete_neg.
    DATA: lv_status_text     TYPE string,
          lv_status_code     TYPE integer,
          lv_step_success    TYPE abap_bool,
          lv_status_code_txt TYPE string,
          lv_msg             TYPE string,
          ls_return          TYPE bapiret2,
          lv_service_uri     TYPE string VALUE '/sap/opu/odata/sap/API_BILLING_DOCUMENT_REQUEST_SRV/',
          lt_parameters      TYPE /iwfnd/sutil_property_t.

    TYPES: BEGIN OF ty_functionimportresult,
             billingdocumentrequest     TYPE vbeln_va,
             billingdocumentrequestitem TYPE posnr,
             type                       TYPE string,
             title                      TYPE string,
           END OF ty_functionimportresult.

    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              results TYPE TABLE OF ty_functionimportresult,
            END OF d,
          END OF ls_response_function.

    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    LOOP AT step_data-reference_step INTO DATA(lv_prestepnumber).


      DATA(ls_check_step_data) = me->mo_run_environment->get_step_data( iv_step_number = lv_prestepnumber ).


      LOOP AT ls_check_step_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).
        lt_parameters = VALUE #( ( name = 'BillingDocumentRequest' value =  <ls_docid> ) ).

        lo_odata_caller->call_service(
          EXPORTING
            iv_method           = 'DELETE'
            iv_action_or_entity = 'A_BillingDocumentRequest'
            it_parameters       = lt_parameters                   " Name/Value Pair - Table
          IMPORTING
            ev_status_code      = lv_status_code                  " Whole Number with +/- Sign (-2.147.483.648 .. 2.147.483.647)
            ev_status_text      = lv_status_text
            es_json_response    = ls_response_function
        ).

        lv_status_code_txt = lv_status_code.
        me->mo_run_environment->append_log( iv_log_statement = |Executed API Call A_BillingDocumentRequest with status code { lv_status_code_txt } and status text { lv_status_text }| ).

        IF lv_status_code = 204.
          lv_step_success = abap_false.
          EXIT.
        ELSE.
          me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
          lv_step_success = abap_true.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

** Output in case of success
    IF lv_step_success EQ abap_true.
      ev_execution_status = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |The Values of the checked document are correct. Processstep is: { step_data-step_number }| ).
    ELSE.
      ev_execution_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |The Values of the checked document are not correct. Processstep is: { step_data-step_number }| ).
    ENDIF.

  ENDMETHOD.


  METHOD api_odata_get_bdr.
    DATA: ls_testdata        TYPE cl_ptf_bo_invoice=>ty_gs_ptf_bd_check_td,
          ls_testdata_vbrk   TYPE vbrk,
          lt_fieldinfo       TYPE extdfiest,
          lv_step_success    TYPE abap_bool,
          lv_status_text     TYPE string,
          lv_status_code_txt TYPE string,
          lv_status_code     TYPE integer,
          lv_msg             TYPE string,
          ls_return          TYPE bapiret2,
          lv_body            TYPE xstring.

    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/SAP/API_BILLING_DOCUMENT_REQUEST_SRV/'.
    DATA: lv_uri TYPE string.
    DATA: lt_parameters TYPE /iwfnd/sutil_property_t.

    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    FIELD-SYMBOLS: <ls_odata_field> TYPE any.

    lv_step_success = abap_true.
    LOOP AT step_data-reference_step INTO DATA(lv_prestepnumber).
      DATA(ls_check_step_data) = me->mo_run_environment->get_step_data( iv_step_number = lv_prestepnumber ).
      IF ls_check_step_data-document_id IS INITIAL.
        ev_execution_status = abap_false.
        me->mo_run_environment->append_log( iv_log_statement = |No reference document exists!| ).
        RETURN.
      ENDIF.
      LOOP AT ls_check_step_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).
        DATA(lv_index) = sy-tabix.
        lt_parameters = VALUE #( ( name = 'BillingDocumentRequest'     value =  <ls_docid> ) ).

        lo_odata_caller->call_service(
          EXPORTING
            iv_action_or_entity = 'A_BillingDocumentRequest'
            it_parameters       = lt_parameters                   " Name/Value Pair - Table
          IMPORTING
            ev_status_code      = lv_status_code                  " Whole Number with +/- Sign (-2.147.483.648 .. 2.147.483.647)
            ev_status_text      = lv_status_text
            ev_body             = lv_body
        ).

        lv_status_code_txt = lv_status_code.
        CONCATENATE 'Executed API Call' 'A_BillingDocumentRequest' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
        me->mo_run_environment->append_log( iv_log_statement = lv_msg ).

        IF lv_status_code = 200.
          lv_step_success = abap_true.
        ELSE. "lv_status = 200
          me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
          lv_step_success = abap_false.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

** Output in case of success
    IF lv_step_success EQ abap_true.
      ev_execution_status = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |The Values of the checked document are correct. Processstep is: { step_data-step_number }| ).
    ELSE.
      ev_execution_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |The Values of the checked document are not correct. Processstep is: { step_data-step_number }| ).
    ENDIF.

  ENDMETHOD.


  METHOD api_odata_get_fi_bd.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/SAP/API_BILLING_DOCUMENT_SRV/'.
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
              billingdocument                TYPE string,
              sddocumentcategory             TYPE string,
              billingdocumentcategory        TYPE string,
              billingdocumenttype            TYPE string,
              creationdate                   TYPE string,
              creationtime                   TYPE string,
              lastchangedate                 TYPE string,
              lastchangedatetime             TYPE string,
              logicalsystem                  TYPE string,
              salesorganization              TYPE string,
              distributionchannel            TYPE string,
              division                       TYPE string,
              billingdocumentdate            TYPE string,
              billingdocumentiscancelled     TYPE string,
              cancelledbillingdocument       TYPE string,
              foreigntrade                   TYPE string,
              isexportdelivery               TYPE string,
              billingdoccombinationcriteria  TYPE string,
              manualinvoicemaintisrelevant   TYPE string,
              isintrastatreportingrelevant   TYPE string,
              isintrastatreportingexcluded   TYPE string,
              totalnetamount                 TYPE string,
              transactioncurrency            TYPE string,
              statisticscurrency             TYPE string,
              taxamount                      TYPE string,
              totalgrossamount               TYPE string,
              customerpricegroup             TYPE string,
              pricelisttype                  TYPE string,
              taxdeparturecountry            TYPE string,
              vatregistration                TYPE string,
              vatregistrationorigin          TYPE string,
              vatregistrationcountry         TYPE string,
              hierarchytypepricing           TYPE string,
              customertaxclassification1     TYPE string,
              customertaxclassification2     TYPE string,
              customertaxclassification3     TYPE string,
              customertaxclassification4     TYPE string,
              customertaxclassification5     TYPE string,
              customertaxclassification6     TYPE string,
              customertaxclassification7     TYPE string,
              customertaxclassification8     TYPE string,
              customertaxclassification9     TYPE string,
              iseutriangulardeal             TYPE string,
              sdpricingprocedure             TYPE string,
              shippingcondition              TYPE string,
              incotermsversion               TYPE string,
              incotermsclassification        TYPE string,
              incotermstransferlocation      TYPE string,
              incotermslocation1             TYPE string,
              incotermslocation2             TYPE string,
              payerparty                     TYPE string,
              contractaccount                TYPE string,
              customerpaymentterms           TYPE string,
              paymentmethod                  TYPE string,
              paymentreference               TYPE string,
              fixedvaluedate                 TYPE string,
              additionalvaluedays            TYPE string,
              sepamandate                    TYPE string,
              companycode                    TYPE string,
              fiscalyear                     TYPE string,
              accountingdocument             TYPE string,
              customeraccountassignmentgroup TYPE string,
              accountingexchangerateisset    TYPE string,
              absltaccountingexchangerate    TYPE string,
              acctgexchangerateisindrctqtan  TYPE string,
              exchangeratedate               TYPE string,
              exchangeratetype               TYPE string,
              documentreferenceid            TYPE string,
              assignmentreference            TYPE string,
              dunningarea                    TYPE string,
              dunningblockingreason          TYPE string,
              dunningkey                     TYPE string,
              internalfinancialdocument      TYPE string,
              isrelevantforaccrual           TYPE string,
              soldtoparty                    TYPE string,
              partnercompany                 TYPE string,
              purchaseorderbycustomer        TYPE string,
              customergroup                  TYPE string,
              country                        TYPE string,
              citycode                       TYPE string,
              salesdistrict                  TYPE string,
              region                         TYPE string,
              county                         TYPE string,
              creditcontrolarea              TYPE string,
              customerrebateagreement        TYPE string,
              salesdocumentcondition         TYPE string,
              overallsdprocessstatus         TYPE string,
              overallbillingstatus           TYPE string,
              accountingpostingstatus        TYPE string,
              accountingtransferstatus       TYPE string,
              billingissuetype               TYPE string,
              invoiceliststatus              TYPE string,
              ovrlitmgeneralincompletionsts  TYPE string,
              billingdocumentlisttype        TYPE string,
              billingdocumentlistdate        TYPE string,
            END OF d,
          END OF ls_response_function.


    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
      DATA(ls_refstep_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
      LOOP AT ls_refstep_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).
        lt_parameters = VALUE #(
          ( name = 'BillingDocument' value =  <ls_docid> )
        ).
        lo_odata_caller->call_service(
          EXPORTING
            iv_action_or_entity = 'A_BillingDocument'
            it_parameters       = lt_parameters
          IMPORTING
            ev_status_code      = lv_status_code
            ev_status_text      = lv_status_text
            es_json_response    = ls_response_function
        ).
        lv_status_code_txt = lv_status_code.
        CONCATENATE 'Executed API Call' 'A_BillingDocument' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
        me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
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
      IF ev_check_status = abap_false.
        EXIT.
      ENDIF.
    ENDLOOP.
    IF lv_msg IS INITIAL.
      CONCATENATE 'Did not execute API Call' 'A_BillingDocument' INTO lv_msg SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
    ENDIF.
  ENDMETHOD.


  METHOD api_odata_post_fi_reject.
    DATA: lv_status_text     TYPE string,
          lv_status_code     TYPE integer,
          lv_step_success    TYPE abap_bool,
          lc_function_name   TYPE string VALUE 'Reject',
          lv_status_code_txt TYPE string,
          lv_msg             TYPE string,
          ls_return          TYPE bapiret2,
          lv_service_uri     TYPE string VALUE '/sap/opu/odata/sap/API_BILLING_DOCUMENT_REQUEST_SRV/',
          lt_parameters      TYPE /iwfnd/sutil_property_t.

    TYPES: BEGIN OF ty_functionimportresult,
             billingdocumentrequest     TYPE vbeln_va,
             billingdocumentrequestitem TYPE posnr,
             type                       TYPE string,
             title                      TYPE string,
           END OF ty_functionimportresult.

    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              results TYPE TABLE OF ty_functionimportresult,
            END OF d,
          END OF ls_response_function.

    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    LOOP AT step_data-reference_step INTO DATA(lv_prestepnumber).
      DATA(ls_check_step_data) = me->mo_run_environment->get_step_data( iv_step_number = lv_prestepnumber ).
      LOOP AT ls_check_step_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).
        lt_parameters = VALUE #( ( name = 'BillingDocumentRequest' value =  <ls_docid> ) ).
        lo_odata_caller->call_service(
          EXPORTING
            iv_method           = 'POST'
            iv_action_or_entity = lc_function_name
            it_parameters       = lt_parameters                   " Name/Value Pair - Table
          IMPORTING
            ev_status_code      = lv_status_code                  " Whole Number with +/- Sign (-2.147.483.648 .. 2.147.483.647)
            ev_status_text      = lv_status_text
            es_json_response    = ls_response_function
        ).

        lv_status_code_txt = lv_status_code.
        CONCATENATE 'Executed API Call Reject with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
        me->mo_run_environment->append_log( iv_log_statement = lv_msg ).

        IF lv_status_code = 200.
          lv_step_success = abap_true.
        ELSE.
          me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
          lv_step_success = abap_false.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

** Output in case of success
    IF lv_step_success EQ abap_true.
      ev_execution_status = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |The Values of the checked document are correct. Processstep is: { step_data-step_number }| ).
    ELSE.
      ev_execution_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |The Values of the checked document are not correct. Processstep is: { step_data-step_number }| ).
    ENDIF.

  ENDMETHOD.


  METHOD api_odata_post_fi_reject_neg.
    DATA: lv_status_text     TYPE string,
          lv_status_code     TYPE integer,
          lv_step_success    TYPE abap_bool,
          lc_function_name   TYPE string VALUE 'Reject',
          lv_status_code_txt TYPE string,
          lv_msg             TYPE string,
          ls_return          TYPE bapiret2,
          lv_service_uri     TYPE string VALUE '/sap/opu/odata/sap/API_BILLING_DOCUMENT_REQUEST_SRV/',
          lt_parameters      TYPE /iwfnd/sutil_property_t.

    TYPES: BEGIN OF ty_functionimportresult,
             billingdocumentrequest     TYPE vbeln_va,
             billingdocumentrequestitem TYPE posnr,
             type                       TYPE string,
             title                      TYPE string,
           END OF ty_functionimportresult.

    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              results TYPE TABLE OF ty_functionimportresult,
            END OF d,
          END OF ls_response_function.

    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    LOOP AT step_data-reference_step INTO DATA(lv_prestepnumber).
      DATA(ls_check_step_data) = me->mo_run_environment->get_step_data( iv_step_number = lv_prestepnumber ).
      LOOP AT ls_check_step_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).
        lt_parameters = VALUE #( ( name = 'BillingDocumentRequest' value =  <ls_docid> ) ).
        lo_odata_caller->call_service(
          EXPORTING
            iv_method           = 'POST'
            iv_action_or_entity = lc_function_name
            it_parameters       = lt_parameters                   " Name/Value Pair - Table
          IMPORTING
            ev_status_code      = lv_status_code                  " Whole Number with +/- Sign (-2.147.483.648 .. 2.147.483.647)
            ev_status_text      = lv_status_text
            es_json_response    = ls_response_function
        ).

        lv_status_code_txt = lv_status_code.
        CONCATENATE 'Executed API Call Reject with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
        me->mo_run_environment->append_log( iv_log_statement = lv_msg ).

        IF lv_status_code = 200.
          lv_step_success = abap_false.
          EXIT.
        ELSE.
          me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
          lv_step_success = abap_true.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

** Output in case of success
    IF lv_step_success EQ abap_true.
      ev_execution_status = abap_true.
      me->mo_run_environment->append_log( iv_log_statement =  |The Values of the checked document are correct. Processstep is: { iv_step_number }| ).
    ELSE.
      ev_execution_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |The Values of the checked document are not correct. Processstep is: { iv_step_number }| ).
    ENDIF.

  ENDMETHOD.


  METHOD api_post_fi_cancel_bd.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/SAP/API_BILLING_DOCUMENT_SRV/'.
    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    DATA lt_parameters TYPE /iwfnd/sutil_property_t.
    DATA: lv_status_text TYPE string,
          lv_status_code TYPE integer.
    DATA: ls_return     TYPE bapiret2.
    DATA: lv_msg             TYPE string,
          lv_status_code_txt TYPE string.
*          Its only use is to get etag
    DATA: BEGIN OF ls_response_function_get,
            BEGIN OF d,
              BEGIN OF __metadata,
                etag TYPE string,
              END OF __metadata,
            END OF d,
          END OF ls_response_function_get.
    TYPES: BEGIN OF ty_functionimportresult,
             billingdocument             TYPE string,
             cancellationbillingdocument TYPE string,
             systemmessagetype           TYPE string,
             systemmessageidentification TYPE string,
             systemmessagenumber         TYPE string,
             systemmessagetext           TYPE string,
             systemmessagevariable1      TYPE string,
             systemmessagevariable2      TYPE string,
             systemmessagevariable3      TYPE string,
             systemmessagevariable4      TYPE string,
           END OF ty_functionimportresult.

    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              results TYPE TABLE OF ty_functionimportresult,
            END OF d,
          END OF ls_response_function.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
      DATA(ls_ref_step_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
      IF ls_ref_step_data IS NOT INITIAL.
        LOOP AT ls_ref_step_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).
          lt_parameters = VALUE #( ).
*          Execute a get call to get etag; Http status is irrelevant
          lo_odata_caller->call_service(
            EXPORTING
              iv_action_or_entity = 'Cancel'
              it_parameters       = lt_parameters
            IMPORTING
              ev_status_code      = lv_status_code
              ev_status_text      = lv_status_text
              es_json_response    = ls_response_function_get
          ).

          lt_parameters = VALUE #(
            ( name = 'BillingDocument' value =  <ls_docid> )
          ).
          lo_odata_caller->call_service(
            EXPORTING
              iv_method           = 'POST'
              iv_action_or_entity = 'Cancel'
              it_parameters       = lt_parameters
              iv_etag             = ls_response_function_get-d-__metadata-etag
            IMPORTING
              ev_status_code      = lv_status_code
              ev_status_text      = lv_status_text
              es_json_response    = ls_response_function
          ).

          lv_status_code_txt = lv_status_code.
          CONCATENATE 'Executed API Call Cancel with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
          me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
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
      CONCATENATE 'Did not execute API Call Cancel' 'Cancel' INTO lv_msg SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD call_ebdr_facade.
    DATA: ls_admin               TYPE sdbil_ebdr_request_admin,
          ls_ctrl                TYPE sdbil_ebdr_request_ctrl,
          lt_ebdr_request_result TYPE sdbil_ebdr_request_result_t,
          lt_ebdr_request_msg    TYPE sdbil_ebdr_request_msg_t,
          lt_failed_id           TYPE sdbil_ebdr_request_failed_t.

*   Create EBDR with reference
    ls_ctrl-commit_mode = '2'. "synchronously, to have a reliable behaviour for immediate checks
    SELECT SINGLE logsys FROM t000 INTO ls_admin-senderlogicalsystem WHERE mandt = sy-mandt.
    me->mo_run_environment->append_log( iv_log_statement = 'Calling BDR create from data' ).
    CALL METHOD cl_sd_bil_ebdr_facade_ext=>if_sd_bil_ebdr_action_ext~create_from_data
      EXPORTING
        is_ebdr_request_ctrl   = ls_ctrl
        is_ebdr_admin          = ls_admin
        it_ebdr_request        = it_ebdr_request
        it_ebdr_request_cond   = it_ebdr_request_cond
      IMPORTING
        et_ebdr_request_result = lt_ebdr_request_result
        et_ebdr_request_failed = lt_failed_id
        et_ebdr_request_msg    = lt_ebdr_request_msg.
*   Get EBDR ids from result / failed
    LOOP AT lt_ebdr_request_result ASSIGNING FIELD-SYMBOL(<ls_ebdr_request_result>).
      READ TABLE lt_failed_id WITH KEY precedingdocument = <ls_ebdr_request_result>-precedingdocument TRANSPORTING NO FIELDS.
      IF sy-subrc  <> 0.
        READ TABLE et_bdr_number WITH TABLE KEY vbeln = <ls_ebdr_request_result>-extbillingdocrequest TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          INSERT VALUE #( vbeln = <ls_ebdr_request_result>-extbillingdocrequest ) INTO TABLE et_bdr_number.
        ENDIF.
      ENDIF.
    ENDLOOP.
    LOOP AT lt_ebdr_request_msg ASSIGNING FIELD-SYMBOL(<ls_message>).
      me->mo_run_environment->append_log( iv_log_statement = |{ <ls_message>-systemmessagetext }| ).
    ENDLOOP.
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
          lv_step_success    TYPE abap_bool,
          var_step           TYPE string.

    DATA(ls_current_step) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_current_step
      IMPORTING
        es_testdata  = ls_testdata
    ).

    lv_step_success = abap_true.
    CLEAR: lv_prestepnumber, ls_check_step_data.
    IF ls_testdata-vbrk_check IS NOT INITIAL OR ls_testdata-vbrp_check IS NOT INITIAL.

      ev_check_status = abap_true.

      LOOP AT ls_current_step-reference_step INTO lv_prestepnumber.
        ls_check_step_data = me->mo_run_environment->get_step_data( iv_step_number = lv_prestepnumber ).
        DATA(lt_doc_ids) = ls_check_step_data-document_id.

        IF lt_doc_ids IS INITIAL.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |No reference document exists!| ).
        ELSE.

          IF ls_testdata-vbrk_check IS NOT INITIAL.
            cl_ptf_compare_bd_tdc=>compare_vbrk_data(
              EXPORTING
                is_testdata        = ls_testdata
                is_check_step_data = ls_check_step_data
                iv_run_environment = me->mo_run_environment
              RECEIVING
                rv_is_equal        = lv_step_success
            ).

            IF lv_step_success EQ abap_false.
              ev_check_status = abap_false.
            ENDIF.

          ENDIF.

          IF ls_testdata-vbrp_check IS NOT INITIAL.
            cl_ptf_compare_bd_tdc=>compare_vbrp_data(
              EXPORTING
                is_testdata        = ls_testdata
                is_check_step_data = ls_check_step_data
                iv_run_environment = me->mo_run_environment
              RECEIVING
                rv_is_equal        = lv_step_success
            ).

            IF lv_step_success EQ abap_false.
              ev_check_status = abap_false.
            ENDIF.

          ENDIF.
        ENDIF.
      ENDLOOP.

    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |Invalid Check Step configuration.| ).
      ev_check_status = abap_false.
    ENDIF.

** Output in case of success
    IF ev_check_status EQ abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |General check was successful. Process step is: { ls_current_step-step_number }| ).
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |General check failed. Process step is: { ls_current_step-step_number }| ).
    ENDIF.

    ev_execution_status = abap_true.

  ENDMETHOD.


  METHOD check_against_reference."check_against_order

    DATA: lt_vbrk         TYPE TABLE OF vbrk,
          lt_vbak         TYPE TABLE OF vbak,
          lt_vbak_vbelns  TYPE cl_ptf_util=>ty_vbeln_tab,
          lt_vbrk_vbelns  TYPE cl_ptf_util=>ty_vbeln_tab,
          lv_netwr_vbrk   TYPE vbrk-netwr,
          lv_check_status TYPE abap_bool,
          lv_message      TYPE string.

    ev_check_status = abap_false.
    ev_execution_status = abap_false.
*** Check if BDR was created by reference



    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_reference_step_bdr_create>).
      DATA(ls_reference_bdr_create) = me->mo_run_environment->get_step_data( iv_step_number = <lv_reference_step_bdr_create> ).
      IF ls_reference_bdr_create-bus_obj = 'EBDR' AND ls_reference_bdr_create-action(6) = 'CREATE'.
        APPEND LINES OF ls_reference_bdr_create-document_id TO lt_vbrk_vbelns.
        LOOP AT ls_reference_bdr_create-reference_step ASSIGNING FIELD-SYMBOL(<lv_reference_step_or_create>).
          DATA(ls_reference_step_or_create) = me->mo_run_environment->get_step_data( iv_step_number = <lv_reference_step_or_create> ).
          IF ls_reference_step_or_create-bus_obj <> 'EBDR' AND ls_reference_step_or_create-action(6) = 'CREATE'.
            APPEND LINES OF ls_reference_step_or_create-document_id TO lt_vbak_vbelns.
          ELSE.
            CONTINUE.
          ENDIF.
        ENDLOOP.
      ELSE.
        CONTINUE. "Not a BDR create step.
      ENDIF.
    ENDLOOP.

    IF lt_vbak_vbelns IS NOT INITIAL AND lt_vbrk_vbelns IS NOT INITIAL.
      SORT lt_vbak_vbelns.
      DELETE ADJACENT DUPLICATES FROM lt_vbak_vbelns.
      SORT lt_vbrk_vbelns.
      DELETE ADJACENT DUPLICATES FROM lt_vbrk_vbelns.

      TYPES:
        BEGIN OF ty_vbeln_orig,
          vbeln TYPE vbeln,
        END OF ty_vbeln_orig.
      DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.
      MOVE lt_vbrk_vbelns TO lt_vbeln_key.

      SELECT * FROM vbrk INTO TABLE @lt_vbrk FOR ALL ENTRIES IN @lt_vbeln_key WHERE vbeln = @lt_vbeln_key-vbeln.

      CLEAR lt_vbeln_key.
      MOVE lt_vbak_vbelns TO lt_vbeln_key.
      SELECT * FROM vbak INTO TABLE @lt_vbak FOR ALL ENTRIES IN @lt_vbeln_key WHERE vbeln = @lt_vbeln_key-vbeln.

      IF lt_vbrk IS INITIAL OR lt_vbak IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |Reference document number was empty| ).
      ELSE.
        lv_check_status = abap_true.
        LOOP AT lt_vbak ASSIGNING FIELD-SYMBOL(<ls_vbak>).
          CLEAR lv_netwr_vbrk.
          lv_message = |Price in reference document { <ls_vbak>-vbeln } reference documents |.
          LOOP AT lt_vbrk ASSIGNING FIELD-SYMBOL(<ls_vbrk>) WHERE bdr_ref = <ls_vbak>-vbeln.
            lv_netwr_vbrk = lv_netwr_vbrk + <ls_vbrk>-netwr.
            lv_message = lv_message && |{ <ls_vbrk>-vbeln }|.
          ENDLOOP.
          IF sy-subrc <> 0.
            me->mo_run_environment->append_log( iv_log_statement = |Reference document number was empty| ).
            EXIT.                                       "#EC CI_NOORDER
          ENDIF.
          IF lv_netwr_vbrk <> <ls_vbak>-netwr.
            lv_check_status = abap_false.
            me->mo_run_environment->append_log( iv_log_statement = | { lv_message } do not match { <ls_vbak>-netwr NUMBER = USER CURRENCY = <ls_vbak>-waerk } <> { lv_netwr_vbrk NUMBER = USER CURRENCY = <ls_vbrk>-waerk } | ).
            EXIT.                                       "#EC CI_NOORDER
          ENDIF.
        ENDLOOP.
        ev_check_status = lv_check_status.
      ENDIF.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |Reference document number was empty| ).
    ENDIF.
    ev_execution_status = abap_true.

    IF ev_check_status EQ abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |Check was successful.| ).
    ENDIF.

  ENDMETHOD.


  METHOD check_compare_bdr_db.

    TYPES:
      BEGIN OF ty_vbeln,
        vbeln TYPE ptfkey,
      END OF ty_vbeln.

    DATA: lt_vbeln           TYPE TABLE OF ty_vbeln,
          lt_vbeln_1         LIKE lt_vbeln,
          lt_vbeln_2         LIKE lt_vbeln,
          ls_vbeln           TYPE ty_vbeln,
          lv_message         TYPE bapi_msg,
          ls_return          TYPE bapiret2,
          lv_success         TYPE abap_bool,
          lt_vbrk            TYPE TABLE OF vbrk,
          lt_vbrp_1          TYPE TABLE OF vbrp,
          lt_vbrp_2          TYPE TABLE OF vbrp,
          ls_vbrp_1          TYPE vbrp,
          ls_vbrp_2          TYPE vbrp,

          lt_vbpa_1          TYPE TABLE OF vbpa,
          lt_vbpa_2          TYPE TABLE OF vbpa,
          ls_vbpa_1          TYPE vbpa,
          ls_vbpa_2          TYPE vbpa,

          lt_prcd_elements_1 TYPE TABLE OF prcd_elements,
          lt_prcd_elements_2 TYPE TABLE OF prcd_elements,
          ls_prcd_elements_1 TYPE prcd_elements,
          ls_prcd_elements_2 TYPE prcd_elements,

          lt_fpla_1          TYPE TABLE OF fpla,
          lt_fpla_2          TYPE TABLE OF fpla,
          ls_fpla_1          TYPE fpla,
          ls_fpla_2          TYPE fpla,

          lt_fplt_1          TYPE TABLE OF fplt,
          lt_fplt_2          TYPE TABLE OF fplt,
          ls_fplt_1          TYPE fplt,
          ls_fplt_2          TYPE fplt,

          lt_fpltc_1         TYPE TABLE OF fpltc,
          lt_fpltc_2         TYPE TABLE OF fpltc,
          ls_fpltc_1         TYPE fpltc,
          ls_fpltc_2         TYPE fpltc,

          lt_stxh_1          TYPE TABLE OF stxh,
          lt_stxh_2          TYPE TABLE OF stxh,
          ls_stxh_1          TYPE stxh,
          ls_stxh_2          TYPE stxh,

          lt_stxl_1          TYPE TABLE OF stxl,
          lt_stxl_2          TYPE TABLE OF stxl,
          ls_stxl_1          TYPE stxl,
          ls_stxl_2          TYPE stxl,

          lt_fieldinfo       TYPE extdfiest,
          ls_fieldinfo       TYPE LINE OF extdfiest,
          msg_str1           TYPE string,
          msg_str2           TYPE string,
          lv_loop_count      TYPE i,
          test_data          TYPE ty_gs_compare_irrelevant.

    FIELD-SYMBOLS: <lv_vbrk_1>          TYPE any,
                   <lv_vbrk_2>          TYPE any,
                   <lv_fieldinfo>       TYPE any,
                   <lv_vbrp_1>          TYPE any,
                   <lv_vbrp_2>          TYPE any,

                   <lv_vbpa_1>          TYPE any,
                   <lv_vbpa_2>          TYPE any,

                   <lv_prcd_elements_1> TYPE any,
                   <lv_prcd_elements_2> TYPE any,

                   <lv_fpla_1>          TYPE any,
                   <lv_fpla_2>          TYPE any,

                   <lv_fplt_1>          TYPE any,
                   <lv_fplt_2>          TYPE any,

                   <lv_fpltc_1>         TYPE any,
                   <lv_fpltc_2>         TYPE any,

                   <lv_stxh_1>          TYPE any,
                   <lv_stxh_2>          TYPE any,

                   <lv_stxl_1>          TYPE any,
                   <lv_stxl_2>          TYPE any.

*****************************************************************************
    IF step_data-variant IS NOT INITIAL.
      cl_ptf_util=>get_testdata(
        EXPORTING
          is_step_data = step_data
        IMPORTING
          es_testdata  = test_data
      ).
    ENDIF.

* Get preceding documents
    DATA lv_vbeln_loop TYPE vbeln.
    ev_execution_status = abap_true.
    IF lines( step_data-reference_step ) NE 2.
      me->mo_run_environment->append_log( iv_log_statement = 'This check needs 2 reference steps.' ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.
    "Info: there is an alternative to the old get_keys_of_touch_doc_of_step( ), giving details as itab. per document ID you get refStepNumber, referenced BO, and key as chat 70 but also as typed structure:
    DATA(lt_result_info) = me->mo_run_environment->get_result_key_data( it_step_number = step_data-reference_step ).
    IF lines( lt_result_info ) LT 2.
      me->mo_run_environment->append_log( iv_log_statement = |Referenced BDRs:{ lines( lt_result_info ) }. At least 2 are needed.| ).
    ENDIF.
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lv_tabix) = sy-tabix.
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      IF lt_ptf_keys IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |ReferenceStep { <lv_ref_step> } did not provide a document.| ).
        ev_execution_status = abap_false.
      ENDIF.
      IF lv_tabix = 2 AND ev_execution_status EQ abap_false.   "do not exit for the first referenceStep, to list both errors if existing
        EXIT.
      ENDIF.
      LOOP AT lt_ptf_keys ASSIGNING FIELD-SYMBOL(<lv_ptf_key>).
        MOVE <lv_ptf_key>-vbeln TO lv_vbeln_loop.
        APPEND lv_vbeln_loop TO lt_vbeln.
        IF lv_tabix = 1.
          APPEND lv_vbeln_loop TO lt_vbeln_1.
        ELSEIF lv_tabix = 2.
          APPEND lv_vbeln_loop TO lt_vbeln_2.
        ELSE.
          me->mo_run_environment->append_log( iv_log_statement = 'This check is only allowed with 2 referenceSteps, not more.' ).
          ev_execution_status = abap_false.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
    IF ev_execution_status = abap_false.
      EXIT.
    ENDIF.

    MOVE-CORRESPONDING lt_vbeln TO ev_document_id.

*****************************************************************************
* VBRK
    TYPES:
      BEGIN OF ty_vbeln_orig,
        vbeln TYPE vbeln,
      END OF ty_vbeln_orig.
    DATA lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.
    MOVE lt_vbeln TO lt_vbeln_key.

    SELECT * FROM vbrk INTO TABLE lt_vbrk FOR ALL ENTRIES IN lt_vbeln_key WHERE vbeln = lt_vbeln_key-vbeln.

* get fieldinfo
    CLEAR lt_fieldinfo.
    CALL FUNCTION 'DD_INT_TABLINFO_GET'
      EXPORTING
        typename       = 'VBRK'
      TABLES
        extdfies_tab   = lt_fieldinfo
      EXCEPTIONS
        not_found      = 1
        internal_error = 2
        OTHERS         = 3.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
*****************************************************************************
* VBRK Check
    lv_success = abap_true.

    LOOP AT lt_vbeln_1 ASSIGNING FIELD-SYMBOL(<lv_vbeln_1>).
      READ TABLE lt_vbrk WITH KEY vbeln = <lv_vbeln_1> ASSIGNING FIELD-SYMBOL(<ls_vbrk_1>).
      READ TABLE lt_vbeln_2 ASSIGNING FIELD-SYMBOL(<lv_vbeln_2>) INDEX sy-tabix.
      IF sy-subrc NE 0.
        me->mo_run_environment->append_log( iv_log_statement = 'The 2 steps have different number of Billing Documents.' ).
        ev_execution_status = abap_false.
        EXIT.
      ENDIF.
      READ TABLE lt_vbrk WITH KEY vbeln = <lv_vbeln_2> ASSIGNING FIELD-SYMBOL(<ls_vbrk_2>).
      me->mo_run_environment->append_log( iv_log_statement = |Comparing { <lv_vbeln_1>-vbeln } and { <lv_vbeln_2>-vbeln }| ).

      LOOP AT lt_fieldinfo INTO ls_fieldinfo.
        IF ls_fieldinfo-fieldname NE 'VBELN'   AND ls_fieldinfo-fieldname NE 'KNUMV'      AND ls_fieldinfo-fieldname NE 'FKDAT' AND
           ls_fieldinfo-fieldname NE 'BELNR'   AND ls_fieldinfo-fieldname NE 'ERZET'      AND
           ls_fieldinfo-fieldname NE 'KIDNO'   AND ls_fieldinfo-fieldname NE 'CHANGED_ON' AND ls_fieldinfo-fieldname NE 'XBLNR' AND
           ls_fieldinfo-fieldname NE 'BDR_REF' AND ls_fieldinfo-fieldname NE 'ZUONR'      AND ls_fieldinfo-fieldname NE 'ZUKRI' AND
           ls_fieldinfo-fieldname NE 'RPLNR'   AND ls_fieldinfo-fieldname NE 'PSPSD'      AND ls_fieldinfo-fieldname NE 'BSTNK_VF'
           AND NOT line_exists( test_data-irrelevant_head_fields[ field_name = ls_fieldinfo-fieldname ] ).
          ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE <ls_vbrk_1> TO <lv_vbrk_1>.
          ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE <ls_vbrk_2> TO <lv_vbrk_2>.
          IF  <lv_vbrk_1> NE  <lv_vbrk_2>.
            lv_success = abap_false.
            msg_str1 = <lv_vbrk_1>.
            msg_str2 = <lv_vbrk_2>.
            ls_return-message = |VBRK field { ls_fieldinfo-fieldname } is different. Doc { <ls_vbrk_1>-vbeln } : { msg_str1 }. Doc { <ls_vbrk_2>-vbeln } : { msg_str2 }.|.
            me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
          ENDIF.
        ENDIF.
      ENDLOOP.

*****************************************************************************
* VBRP
      REFRESH: lt_vbrp_1, lt_vbrp_2.
      SELECT * FROM vbrp INTO TABLE lt_vbrp_1 WHERE vbeln = <lv_vbeln_1>-vbeln ORDER BY PRIMARY KEY.
      SELECT * FROM vbrp INTO TABLE lt_vbrp_2 WHERE vbeln = <lv_vbeln_2>-vbeln ORDER BY PRIMARY KEY.
      DESCRIBE TABLE lt_vbrp_1 LINES DATA(lv_vbrp_l1).
      DESCRIBE TABLE lt_vbrp_2 LINES DATA(lv_vbrp_l2).
      IF lv_vbrp_l1 NE lv_vbrp_l2.
        me->mo_run_environment->append_log( iv_log_statement = 'Number of items not equal.' ).
        ev_execution_status = abap_false.
        RETURN.
      ENDIF.

* get fieldinfo
      CLEAR lt_fieldinfo.
      CALL FUNCTION 'DD_INT_TABLINFO_GET'
        EXPORTING
          typename       = 'VBRP'
        TABLES
          extdfies_tab   = lt_fieldinfo
        EXCEPTIONS
          not_found      = 1
          internal_error = 2
          OTHERS         = 3.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

*****************************************************************************
* VBRP Check
      lv_loop_count = 0.
      LOOP AT lt_vbrp_1 INTO ls_vbrp_1.
        lv_loop_count = lv_loop_count + 1.
        READ TABLE lt_vbrp_2 INTO ls_vbrp_2 INDEX lv_loop_count.
        LOOP AT lt_fieldinfo INTO ls_fieldinfo.
          IF ls_fieldinfo-fieldname NE 'VBELN' AND ls_fieldinfo-fieldname NE 'VGBEL' AND ls_fieldinfo-fieldname NE 'AUBEL' AND
             ls_fieldinfo-fieldname NE 'ERNAM' AND ls_fieldinfo-fieldname NE 'ERZET' AND ls_fieldinfo-fieldname NE 'PAOBJNR' AND
             ls_fieldinfo-fieldname NE 'VGTYP' AND ls_fieldinfo-fieldname NE 'VGPOS' AND ls_fieldinfo-fieldname NE 'PBD_ID' AND
             ls_fieldinfo-fieldname NE 'PBD_ITEM_ID' AND ls_fieldinfo-fieldname NE 'KNUMV_ANA' AND ls_fieldinfo-fieldname NE 'PS_PSP_PNR' AND
             ls_fieldinfo-fieldname NE 'FPLNR' AND ls_fieldinfo-fieldname NE 'SERVICE_DOC_ID'
             AND NOT line_exists( test_data-irrelevant_pos_fields[ field_name = ls_fieldinfo-fieldname ] ).
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbrp_1 TO <lv_vbrp_1>.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbrp_2 TO <lv_vbrp_2>.
            IF <lv_vbrp_1> NE  <lv_vbrp_2>.
              lv_success  = abap_false.
              CLEAR ls_return.
              msg_str1 = <lv_vbrp_1>.
              msg_str2 = <lv_vbrp_2>.
              ls_return-message = |VBRP field { ls_fieldinfo-fieldname } is different. Doc { <ls_vbrk_1>-vbeln } : { msg_str1 }. Doc { <ls_vbrk_2>-vbeln } : { msg_str2 }.|.
              me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDLOOP.

*****************************************************************************
* VBPA
      REFRESH: lt_vbpa_1, lt_vbpa_2.
      SELECT * FROM vbpa INTO TABLE lt_vbpa_1 WHERE vbeln = ls_vbeln-vbeln ORDER BY PRIMARY KEY.
      SELECT * FROM vbpa INTO TABLE lt_vbpa_2 WHERE vbeln = ls_vbeln-vbeln ORDER BY PRIMARY KEY.
      DESCRIBE TABLE lt_vbpa_1 LINES DATA(lv_vbpa_l1).
      DESCRIBE TABLE lt_vbpa_2 LINES DATA(lv_vbpa_l2).
      IF lv_vbpa_l1 NE lv_vbpa_l2.
        me->mo_run_environment->append_log( iv_log_statement = 'Number of entries in VBPA are not equal.' ).
        ev_execution_status = abap_false.
        RETURN.
      ENDIF.

* 9 get fieldinfo
      CLEAR lt_fieldinfo.
      CALL FUNCTION 'DD_INT_TABLINFO_GET'
        EXPORTING
          typename       = 'VBPA'
        TABLES
          extdfies_tab   = lt_fieldinfo
        EXCEPTIONS
          not_found      = 1
          internal_error = 2
          OTHERS         = 3.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

*****************************************************************************
* VBPA Check
      lv_loop_count = 0.
      LOOP AT lt_vbpa_1 INTO ls_vbpa_1.
        lv_loop_count = lv_loop_count + 1.
        READ TABLE lt_vbpa_2 INTO ls_vbpa_2 INDEX lv_loop_count.
        LOOP AT lt_fieldinfo INTO ls_fieldinfo.
          IF ls_fieldinfo-fieldname NE 'VBELN'.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbpa_1 TO <lv_vbpa_1>.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbpa_2 TO <lv_vbpa_2>.
            IF <lv_vbpa_1> NE  <lv_vbpa_2>.
              lv_success  = abap_false.
              CLEAR ls_return.
              msg_str1 = <lv_vbpa_1>.
              msg_str2 = <lv_vbpa_2>.
              ls_return-message = |VBPA field { ls_fieldinfo-fieldname } is different. Doc { <ls_vbrk_1>-vbeln } : { msg_str1 }. Doc { <ls_vbrk_2>-vbeln } : { msg_str2 }.|.
              me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDLOOP.

*****************************************************************************
* PRCD_ELEMENTS
      REFRESH: lt_prcd_elements_1,lt_prcd_elements_2.
      SELECT * FROM prcd_elements INTO TABLE lt_prcd_elements_1 WHERE knumv = <ls_vbrk_1>-knumv ORDER BY PRIMARY KEY.
      SELECT * FROM prcd_elements INTO TABLE lt_prcd_elements_2 WHERE knumv = <ls_vbrk_2>-knumv ORDER BY PRIMARY KEY.
      DESCRIBE TABLE lt_prcd_elements_1 LINES DATA(lv_prcd_elements_l1).
      DESCRIBE TABLE lt_prcd_elements_2 LINES DATA(lv_prcd_elements_l2).
      IF lv_prcd_elements_l1 NE lv_prcd_elements_l2.
        me->mo_run_environment->append_log( iv_log_statement = 'Number of entries in PRCD_ELEMENTS is not equal.' ).
        ev_execution_status = abap_false.
        RETURN.
      ENDIF.

* get fieldinfo
      CLEAR lt_fieldinfo.
      CALL FUNCTION 'DD_INT_TABLINFO_GET'
        EXPORTING
          typename       = 'prcd_elements'
        TABLES
          extdfies_tab   = lt_fieldinfo
        EXCEPTIONS
          not_found      = 1
          internal_error = 2
          OTHERS         = 3.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

*****************************************************************************
* PRCD_ELEMENTS Check
      lv_loop_count = 0.
      LOOP AT lt_prcd_elements_1 INTO ls_prcd_elements_1.
        lv_loop_count = lv_loop_count + 1.
        READ TABLE lt_prcd_elements_2 INTO ls_prcd_elements_2 INDEX lv_loop_count.
        LOOP AT lt_fieldinfo INTO ls_fieldinfo.
          IF ls_fieldinfo-fieldname NE 'KNUMV'.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_prcd_elements_1 TO <lv_prcd_elements_1>.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_prcd_elements_2 TO <lv_prcd_elements_2>.
            IF <lv_prcd_elements_1> NE  <lv_prcd_elements_2>.
              lv_success  = abap_false.
              CLEAR ls_return.
              msg_str1 = <lv_prcd_elements_1>.
              msg_str2 = <lv_prcd_elements_2>.
              ls_return-message = |PRCD_ELEMENTS field { ls_fieldinfo-fieldname } is different. Doc { <ls_vbrk_1>-vbeln } : { msg_str1 }. Doc { <ls_vbrk_2>-vbeln } : { msg_str2 }.|.
              me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDLOOP.

*****************************************************************************
* FPLA
      REFRESH: lt_fpla_1, lt_fpla_2.
      SELECT * FROM fpla INTO TABLE lt_fpla_1 WHERE fplnr = <ls_vbrk_1>-rplnr ORDER BY PRIMARY KEY.
      SELECT * FROM fpla INTO TABLE lt_fpla_2 WHERE fplnr = <ls_vbrk_2>-rplnr ORDER BY PRIMARY KEY.
      DESCRIBE TABLE lt_fpla_1 LINES DATA(lv_fpla_l1).
      DESCRIBE TABLE lt_fpla_2 LINES DATA(lv_fpla_l2).
      IF lv_fpla_l1 NE lv_fpla_l2.
        me->mo_run_environment->append_log( iv_log_statement = 'Number of entries in fpla is not equal.' ).
        ev_execution_status = abap_false.
        RETURN.
      ENDIF.

* 14 get fieldinfo
      CLEAR lt_fieldinfo.
      CALL FUNCTION 'DD_INT_TABLINFO_GET'
        EXPORTING
          typename       = 'FPLA'
        TABLES
          extdfies_tab   = lt_fieldinfo
        EXCEPTIONS
          not_found      = 1
          internal_error = 2
          OTHERS         = 3.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

*****************************************************************************
* FPLA Check
      lv_loop_count = 0.
      LOOP AT lt_fpla_1 INTO ls_fpla_1.
        lv_loop_count = lv_loop_count + 1.
        READ TABLE lt_fpla_2 INTO ls_fpla_2 INDEX lv_loop_count.
        LOOP AT lt_fieldinfo INTO ls_fieldinfo.
          IF ls_fieldinfo-fieldname NE 'FPLNR' AND
             ls_fieldinfo-fieldname NE 'VBELN'.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_fpla_1 TO <lv_fpla_1>.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_fpla_2 TO <lv_fpla_2>.
            IF <lv_fpla_1> NE  <lv_fpla_2>.
              lv_success  = abap_false.
              CLEAR ls_return.
              msg_str1 = <lv_fpla_1>.
              msg_str2 = <lv_fpla_2>.
              ls_return-message = |fpla field { ls_fieldinfo-fieldname } is different. Doc { <ls_vbrk_1>-vbeln } : { msg_str1 }. Doc { <ls_vbrk_2>-vbeln } : { msg_str2 }.|.
              me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDLOOP.

*****************************************************************************
* FPLT
      REFRESH: lt_fplt_1, lt_fplt_2.
      SELECT * FROM fplt INTO TABLE lt_fplt_1 WHERE fplnr = <ls_vbrk_1>-rplnr ORDER BY PRIMARY KEY.
      SELECT * FROM fplt INTO TABLE lt_fplt_2 WHERE fplnr = <ls_vbrk_2>-rplnr ORDER BY PRIMARY KEY.
      DESCRIBE TABLE lt_fplt_1 LINES DATA(lv_fplt_l1).
      DESCRIBE TABLE lt_fplt_2 LINES DATA(lv_fplt_l2).
      IF lv_fplt_l1 NE lv_fplt_l2.
        me->mo_run_environment->append_log( iv_log_statement = 'Number of entries in fplt is not equal.' ).
        ev_execution_status = abap_false.
        RETURN.
      ENDIF.

* get fieldinfo
      CLEAR lt_fieldinfo.
      CALL FUNCTION 'DD_INT_TABLINFO_GET'
        EXPORTING
          typename       = 'FPLT'
        TABLES
          extdfies_tab   = lt_fieldinfo
        EXCEPTIONS
          not_found      = 1
          internal_error = 2
          OTHERS         = 3.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

*****************************************************************************
* FPLT Check
      lv_loop_count = 0.
      LOOP AT lt_fplt_1 INTO ls_fplt_1.
        lv_loop_count = lv_loop_count + 1.
        READ TABLE lt_fplt_2 INTO ls_fplt_2 INDEX lv_loop_count.
        LOOP AT lt_fieldinfo INTO ls_fieldinfo.
          IF ls_fieldinfo-fieldname NE 'FPLNR'.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_fplt_1 TO <lv_fplt_1>.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_fplt_2 TO <lv_fplt_2>.
            IF <lv_fplt_1> NE  <lv_fplt_2>.
              lv_success  = abap_false.
              CLEAR ls_return.
              msg_str1 = <lv_fplt_1>.
              msg_str2 = <lv_fplt_2>.
              ls_return-message = |fplt field { ls_fieldinfo-fieldname } is different. Doc { <ls_vbrk_1>-vbeln } : { msg_str1 }. Doc { <ls_vbrk_2>-vbeln } : { msg_str2 }.|.
              me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDLOOP.

*****************************************************************************
* FPLTC
      REFRESH: lt_fpltc_1, lt_fpltc_2.
      SELECT * FROM fpltc INTO TABLE lt_fpltc_1 WHERE fplnr = <ls_vbrk_1>-rplnr ORDER BY PRIMARY KEY.
      SELECT * FROM fpltc INTO TABLE lt_fpltc_2 WHERE fplnr = <ls_vbrk_2>-rplnr ORDER BY PRIMARY KEY.
      DESCRIBE TABLE lt_fpltc_1 LINES DATA(lv_fpltc_l1).
      DESCRIBE TABLE lt_fpltc_2 LINES DATA(lv_fpltc_l2).
      IF lv_fpltc_l1 NE lv_fpltc_l2.
        me->mo_run_environment->append_log( iv_log_statement = 'Number of entries in fpla is not equal.' ).
        ev_execution_status = abap_false.
        RETURN.
      ENDIF.

* get fieldinfo
      CLEAR lt_fieldinfo.
      CALL FUNCTION 'DD_INT_TABLINFO_GET'
        EXPORTING
          typename       = 'FPLTC'
        TABLES
          extdfies_tab   = lt_fieldinfo
        EXCEPTIONS
          not_found      = 1
          internal_error = 2
          OTHERS         = 3.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

*****************************************************************************
* FPLTC Check
      lv_loop_count = 0.
      LOOP AT lt_fpltc_1 INTO ls_fpltc_1.
        lv_loop_count = lv_loop_count + 1.
        READ TABLE lt_fpltc_2 INTO ls_fpltc_2 INDEX lv_loop_count.
        LOOP AT lt_fieldinfo INTO ls_fieldinfo.
          IF ls_fieldinfo-fieldname NE 'FPLNR' AND ls_fieldinfo-fieldname NE 'AUTIM' .
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_fpltc_1 TO <lv_fpltc_1>.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_fpltc_2 TO <lv_fpltc_2>.
            IF <lv_fpltc_1> NE  <lv_fpltc_2>.
              lv_success  = abap_false.
              CLEAR ls_return.
              msg_str1 = <lv_fpltc_1>.
              msg_str2 = <lv_fpltc_2>.
              ls_return-message = |fpltc field { ls_fieldinfo-fieldname } is different. Doc { <ls_vbrk_1>-vbeln } : { msg_str1 }. Doc { <ls_vbrk_2>-vbeln } : { msg_str2 }.|.
              me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDLOOP.

*****************************************************************************
* STXH
      REFRESH: lt_stxh_1, lt_stxh_2.
      SELECT * FROM stxh INTO TABLE lt_stxh_1 WHERE tdname = <lv_vbeln_1>-vbeln ORDER BY PRIMARY KEY.
      SELECT * FROM stxh INTO TABLE lt_stxh_2 WHERE tdname = <lv_vbeln_2>-vbeln ORDER BY PRIMARY KEY.
      DESCRIBE TABLE lt_stxh_1 LINES DATA(lv_stxh_l1).
      DESCRIBE TABLE lt_stxh_2 LINES DATA(lv_stxh_l2).
      IF lv_stxh_l1 NE lv_stxh_l2.
        me->mo_run_environment->append_log( iv_log_statement = 'Number of entries in STXH is not equal.' ).
        ev_execution_status = abap_false.
        RETURN.
      ENDIF.

* get fieldinfo
      CLEAR lt_fieldinfo.
      CALL FUNCTION 'DD_INT_TABLINFO_GET'
        EXPORTING
          typename       = 'STXH'
        TABLES
          extdfies_tab   = lt_fieldinfo
        EXCEPTIONS
          not_found      = 1
          internal_error = 2
          OTHERS         = 3.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

*****************************************************************************
* STXH check
      lv_loop_count = 0.
      LOOP AT lt_stxh_1 INTO ls_stxh_1.
        lv_loop_count = lv_loop_count + 1.
        READ TABLE lt_stxh_2 INTO ls_stxh_2 INDEX lv_loop_count.
        LOOP AT lt_fieldinfo INTO ls_fieldinfo.
          IF ls_fieldinfo-fieldname NE 'TDNAME' AND ls_fieldinfo-fieldname NE 'TDFTIME' AND ls_fieldinfo-fieldname NE 'TDLTIME'.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_stxh_1 TO <lv_stxh_1>.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_stxh_2 TO <lv_stxh_2>.
            IF <lv_stxh_1> NE  <lv_stxh_2>.
              lv_success  = abap_false.
              CLEAR ls_return.
              msg_str1 = <lv_stxh_1>.
              msg_str2 = <lv_stxh_2>.
              ls_return-message = |STXH field { ls_fieldinfo-fieldname } is different. Doc { <ls_vbrk_1>-vbeln } : { msg_str1 }. Doc { <ls_vbrk_2>-vbeln } : { msg_str2 }.|.
              me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDLOOP.

*****************************************************************************
* STXL
      REFRESH: lt_stxl_1, lt_stxl_2.
      DATA lv_tdname TYPE tdname.
      lv_tdname = <lv_vbeln_1>-vbeln && '%'.
      SELECT * FROM stxl INTO TABLE lt_stxl_1 WHERE tdname LIKE lv_tdname ORDER BY PRIMARY KEY.
      lv_tdname = <lv_vbeln_2>-vbeln && '%'.
      SELECT * FROM stxl INTO TABLE lt_stxl_2 WHERE tdname LIKE lv_tdname ORDER BY PRIMARY KEY.
      DESCRIBE TABLE lt_stxl_1 LINES DATA(lv_stxl_l1).
      DESCRIBE TABLE lt_stxl_2 LINES DATA(lv_stxl_l2).
      IF lv_stxl_l1 NE lv_stxl_l2.
        me->mo_run_environment->append_log( iv_log_statement = 'Number of entries in STXL is not equal.' ).
        ev_execution_status = abap_false.
        RETURN.
      ENDIF.

* get fieldinfo
      CLEAR lt_fieldinfo.
      CALL FUNCTION 'DD_INT_TABLINFO_GET'
        EXPORTING
          typename       = 'STXL'
        TABLES
          extdfies_tab   = lt_fieldinfo
        EXCEPTIONS
          not_found      = 1
          internal_error = 2
          OTHERS         = 3.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

*****************************************************************************
* STXL Check
      lv_loop_count = 0.
      LOOP AT lt_stxl_1 INTO ls_stxl_1.
        lv_loop_count = lv_loop_count + 1.
        READ TABLE lt_stxl_2 INTO ls_stxl_2 INDEX lv_loop_count.
        "Compare STXL field
        LOOP AT lt_fieldinfo INTO ls_fieldinfo.
          IF ls_fieldinfo-fieldname NE 'TDNAME' AND ls_fieldinfo-fieldname NE 'TDFTIME' AND ls_fieldinfo-fieldname NE 'TDLTIME' AND ls_fieldinfo-fieldname NE 'CLUSTD'.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_stxl_1 TO <lv_stxl_1>.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_stxl_2 TO <lv_stxl_2>.
            IF <lv_stxl_1> NE  <lv_stxl_2>.
              lv_success  = abap_false.
              me->mo_run_environment->append_log( |TDNAME: { ls_stxl_1-tdname }, TDID: { ls_stxl_1-tdid }, TDSPRAS: { ls_stxl_1-tdspras }| ).
              msg_str1 = <lv_stxl_1>.
              msg_str2 = <lv_stxl_2>.
              CLEAR ls_return.
              ls_return-message = |STXL field { ls_fieldinfo-fieldname } is different. Doc { <ls_vbrk_1>-vbeln } : { msg_str1 }. Doc { <ls_vbrk_2>-vbeln } : { msg_str2 }.|.
              me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
            ENDIF.
          ENDIF.
        ENDLOOP.
        "Compare Text
        DATA lt_tline_1      TYPE STANDARD TABLE OF tline.
        DATA lt_tline_2      TYPE STANDARD TABLE OF tline.
        CLEAR lt_tline_1.
        CLEAR lt_tline_2.

        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            name                    = ls_stxl_1-tdname
            object                  = ls_stxl_1-tdobject
            id                      = ls_stxl_1-tdid
            language                = ls_stxl_1-tdspras
          TABLES
            lines                   = lt_tline_1
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.

        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            name                    = ls_stxl_2-tdname
            object                  = ls_stxl_2-tdobject
            id                      = ls_stxl_2-tdid
            language                = ls_stxl_2-tdspras
          TABLES
            lines                   = lt_tline_2
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.

        IF lt_tline_1 NE lt_tline_2.
          lv_success = abap_false.
          me->mo_run_environment->append_log( |TDNAME: { ls_stxl_1-tdname }, TDID: { ls_stxl_1-tdid }, TDSPRAS: { ls_stxl_1-tdspras }| ).
          CLEAR ls_return.
          ls_return-message = |Text from FM READ_TEXT is different. Doc { <ls_vbrk_1>-vbeln } deviates from doc { <ls_vbrk_2>-vbeln }.|.
          me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
        ENDIF.

      ENDLOOP.  "lt_STXL_1



    ENDLOOP. "lt_vbeln_1

*****************************************************************************
    ev_execution_status = abap_true.
    ev_check_status = lv_success.
    IF lv_success EQ abap_true.
      ls_return-message = 'Check was successful. Both documents are similar.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
    ENDIF.

  ENDMETHOD.


  METHOD check_conditions_exist.
    DATA: lt_check_data TYPE cl_ptf_bo_ebdr=>ty_gt_price_element_td,
          lt_vbeln      TYPE cl_ptf_util=>ty_vbeln_tab.


    ev_check_status = abap_false.
    ev_execution_status = abap_false.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    IF lt_vbeln IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |There is no Billing Document Request to check.| ).
      RETURN.
    ENDIF.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = lt_check_data
    ).

**********************************************************************
    LOOP AT lt_vbeln INTO DATA(ls_vbeln).
      SELECT SINGLE knumv FROM vbrk INTO @DATA(lv_condition_number) WHERE vbeln = @ls_vbeln-vbeln.
      IF lv_condition_number IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |There is no condition in { ls_vbeln-vbeln } to check.| ).
        RETURN.
      ENDIF.

      SELECT * INTO TABLE @DATA(lt_price_elements) FROM prcd_elements WHERE knumv = @lv_condition_number.
      LOOP AT lt_check_data INTO DATA(ls_check_data).
        "Here use billing item(POSNR) = condition item(KPOSN) as filter, not quick sure if it's right
        IF NOT line_exists( lt_price_elements[ kposn = ls_check_data-item_number
                                               kschl = ls_check_data-condition_type
                                               kbetr = ls_check_data-condition_amount
                                               kwert = ls_check_data-condition_value
                                               waerk = ls_check_data-condition_currency ] ).
          me->mo_run_environment->append_log( iv_log_statement =
            |Condition type { ls_check_data-condition_type } is not exist in the item { ls_check_data-item_number }|
            && |of Billing Document: { ls_vbeln-vbeln }| ).
          RETURN.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    ev_check_status = abap_true.
    ev_execution_status = abap_true.
    me->mo_run_environment->append_log( iv_log_statement = |Conditiions checked successfully.| ).

  ENDMETHOD.


  METHOD check_deletion.
    DATA: lt_vbeln             TYPE cl_ptf_util=>ty_vbeln_tab,
          lv_vbeln             TYPE vbeln,
          lv_nr_docs_to_delete TYPE i,
          lv_nr_deleted_docs   TYPE i.

    ev_check_status = abap_false.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.


    lv_nr_deleted_docs = 0.
    LOOP AT lt_vbeln REFERENCE INTO DATA(ls_vbeln).

      SELECT SINGLE vbeln FROM vbrk INTO @lv_vbeln
                            WHERE vbeln = @ls_vbeln->vbeln.
      IF sy-subrc <> 0.
        lv_nr_deleted_docs = lv_nr_deleted_docs + 1.
      ELSE.
        me->mo_run_environment->append_log( iv_log_statement = | Document { ls_vbeln->vbeln } is not deleted.| ).
      ENDIF.
    ENDLOOP.

    lv_nr_docs_to_delete = lines( lt_vbeln ).
    IF lv_nr_docs_to_delete = lv_nr_deleted_docs.
      ev_check_status = abap_true.
    ENDIF.

  ENDMETHOD.


  method CHECK_EBDR_ITEM_PPRCTR.
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


  METHOD check_event.
    DATA:
      ls_testdata            TYPE cl_ptf_bo_ebdr=>ty_gs_i_ptf_ebdr_event_td,
      lv_event               TYPE sibfevent,
      lt_vbeln               TYPE cl_ptf_util=>ty_vbeln_tab,
      lv_vbeln_vf            TYPE vbeln_vf,
      lt_sdbil_test_event    TYPE TABLE OF sdbil_test_event,
      lt_reference_documents TYPE TABLE OF vbeln.

    ev_execution_status = abap_false. " assume test fails
    ev_check_status = abap_false.
******************************************************************************
* 1 Step: Get test data for controlling creation
    IF step_data-variant IS NOT INITIAL.
      cl_ptf_util=>get_testdata(
        EXPORTING
          is_step_data = step_data
        IMPORTING
          es_testdata  = ls_testdata
      ).
      lv_event = ls_testdata-event.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |Cannot get test data!| ).
      EXIT.
    ENDIF.

* 2 Step: Get Data of the predecessor
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      IF lt_ptf_keys IS NOT INITIAL.
        APPEND LINES OF lt_ptf_keys TO lt_reference_documents.
      ELSE.
        me->mo_run_environment->append_log( iv_log_statement = |No reference data available. Previous step failed.| ).
        RETURN.
      ENDIF.
    ENDLOOP.

* 3 Step: Check event log table
    IF lv_event IS NOT INITIAL.
      LOOP AT lt_reference_documents ASSIGNING FIELD-SYMBOL(<lv_vbeln>).
        SELECT * FROM swfrevtlog
          WHERE objtype = 'CL_SD_BIL_EBDR_WF_EVENT' AND
          event = @lv_event AND
          objkey = @<lv_vbeln> AND
          objid = @sy-uname
          INTO TABLE @DATA(event_table_data).
        IF sy-subrc <> 0.
          me->mo_run_environment->append_log( iv_log_statement = |No event was logged for | && <lv_vbeln> && |!| ).
          RETURN.
        ENDIF.
      ENDLOOP.

    ENDIF.

    ev_execution_status = abap_true.
    ev_check_status = abap_true.
  ENDMETHOD.


  METHOD check_existence.
    DATA: lv_vbeln TYPE vbeln.
    MOVE iv_id TO lv_vbeln.

    SELECT SINGLE * FROM vbrk WHERE vbeln = @lv_vbeln INTO @DATA(ls_bd).
    IF sy-subrc <> 0.
      me->mo_run_environment->append_log( iv_log_statement = |BD { lv_vbeln } does not exist.| ).
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
*  ****************************************************************************
*   1 Step: Get TDCV
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = ls_quantity
    ).
*  ****************************************************************************
*   2 Step: Get Presteps

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.
    IF lines( lt_vbeln ) EQ 0.
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |Nothing to check.| ).
      RETURN.
    ENDIF.
*  ****************************************************************************
*   3 Step: Check
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
      lv_success = abap_true.
      lv_message = 'The expected document quantity and the created quantity are equal'.
      CLEAR ls_return.
      ls_return-message = lv_message.
      me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).

    ELSEIF lv_quantity EQ ls_quantity-quantity.
      LOOP AT lt_vbeln INTO ls_vbeln.
        SELECT SINGLE * FROM vbrk INTO @DATA(ls_vbrk) WHERE vbeln = @ls_vbeln-vbeln.
        IF sy-subrc EQ 0.
          CONCATENATE 'Database entry with vbeln:' ls_vbeln-vbeln 'exists' INTO lv_message SEPARATED BY space.
          me->mo_run_environment->append_log( iv_log_statement = |{ lv_message }| ).
          APPEND ls_vbeln TO  lt_vbeln_on_db.
        ELSE.
          CONCATENATE 'Database entry with vbeln:' ls_vbeln-vbeln 'does not exists.' INTO lv_message SEPARATED BY space.
          me->mo_run_environment->append_log( iv_log_statement = |{ lv_message }| ).
          lv_success = abap_false.
        ENDIF.
      ENDLOOP.
    ENDIF.

    ev_execution_status = abap_true.
    ev_check_status = lv_success.
  ENDMETHOD.


  METHOD check_negative."check_no_doc_was_created
    ev_check_status = abap_true.
    ev_execution_status = abap_false.
*** Check if BDR create was not creating any document
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_reference_step_bdr_create>).

      DATA(ls_reference_bdr_create) = me->mo_run_environment->get_step_data( iv_step_number = <lv_reference_step_bdr_create> ).

      IF ls_reference_bdr_create-bus_obj = 'EBDR' AND ls_reference_bdr_create-action(6) = 'CREATE'.
        IF ls_reference_bdr_create-document_id IS NOT INITIAL. "negative test, if any document was created, it should be red
          ev_check_status = abap_false.
        ENDIF.
      ELSE.
        CONTINUE. "Not a BDR create step.
      ENDIF.
    ENDLOOP.
    ev_execution_status = abap_true.
  ENDMETHOD.


  METHOD check_new_project_billing.

    DATA:
      lt_vbeln       TYPE if_sd_bil_type_def=>tt_ebdr,
      lt_ebdr_vbelns TYPE if_sd_bil_type_def=>tt_ebdr.

******************************************************************************
* Step 1: Get referenced documents
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      IF lines( lt_ptf_keys ) EQ 0.
        me->mo_run_environment->append_log( iv_log_statement = |No documents found for step { <lv_ref_step> }| ).
      ENDIF.
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    IF lines( lt_vbeln ) EQ 0.
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |Nothing to check.| ).
      RETURN.
    ENDIF.

    SELECT vbeln, posnr, aubel, aupos, vgtyp, prsdt, ps_psp_pnr, fplnr, fpltr, fbuda
      FROM vbrp
      FOR ALL ENTRIES IN @lt_vbeln
      WHERE vbeln = @lt_vbeln-vbeln
      INTO TABLE @DATA(lt_ebdr_items).

******************************************************************************
* Step 2: Check specific fields of EBDR in new project billing process
    "AUBEL in vbrp of EBDR should be the same as sales order created in previous ptf step
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step_bdr_create>).
      DATA(ls_step_bdr_create) = me->mo_run_environment->get_step_data( iv_step_number = <lv_ref_step_bdr_create> ).
      IF ls_step_bdr_create-bus_obj = 'EBDR' AND ls_step_bdr_create-action(6) = 'CREATE'.
        lt_ebdr_vbelns = ls_step_bdr_create-document_id.
        IF lines( ls_step_bdr_create-reference_step ) <> 1.
          RETURN.
        ENDIF.
        DATA(ls_reference_step_or_create) = me->mo_run_environment->get_step_data( iv_step_number = ls_step_bdr_create-reference_step[ 1 ] ).
        IF ls_reference_step_or_create-bus_obj <> 'OR' OR ls_reference_step_or_create-action(6) <> 'CREATE'
          OR lines( ls_reference_step_or_create-document_id ) NE 1.
          me->mo_run_environment->append_log( iv_log_statement = |Unexpected Values in Order Create Step.| ).
          RETURN.
        ENDIF.
        "Compare AUBEL of EBDR with step of order creation
        DATA(lv_so_vbeln) = ls_reference_step_or_create-document_id[ 1 ]-vbeln.
        LOOP AT lt_ebdr_vbelns ASSIGNING FIELD-SYMBOL(<ebdr>).
          LOOP AT lt_ebdr_items ASSIGNING FIELD-SYMBOL(<ebdr_item>) WHERE vbeln = <ebdr>.
            IF <ebdr_item>-aubel NE lv_so_vbeln.
              me->mo_run_environment->append_log( iv_log_statement = |AUBEL of EBDR Item is not equal to created Sales Order Number.| ).
              RETURN.
            ENDIF.
          ENDLOOP.
        ENDLOOP.
      ENDIF.
    ENDLOOP.


    "Check values in lt_ebdr_items
    LOOP AT lt_ebdr_items ASSIGNING FIELD-SYMBOL(<ls_ebdr>).
      IF <ls_ebdr>-aupos IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |AUPOS is not initial.| ).
        RETURN.
      ENDIF.

      IF <ls_ebdr>-vgtyp <> 'PBRQ'.
        me->mo_run_environment->append_log( iv_log_statement = |VGTYP is not equal to PBRQ.| ).
        RETURN.
      ENDIF.

      IF <ls_ebdr>-fpltr IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |Billing Plan Item is initial.| ).
        RETURN.
      ENDIF.
    ENDLOOP.


    "WBS Elements in vbrp and vbap should be the same
    SELECT vbrp~vbeln, vbrp~posnr, vbrp~ps_psp_pnr, vbap~ps_psp_pnr AS ps_psp_pnr_vbap
      FROM vbrp JOIN vbap ON vbrp~aubel = vbap~vbeln AND vbrp~aupos = vbap~posnr
      FOR ALL ENTRIES IN @lt_ebdr_items
      WHERE vbrp~vbeln = @lt_ebdr_items-vbeln AND
            vbrp~posnr = @lt_ebdr_items-posnr
      INTO TABLE @DATA(lt_wbselements).

    LOOP AT lt_wbselements ASSIGNING FIELD-SYMBOL(<ls_wbselements>).
      IF <ls_wbselements>-ps_psp_pnr <> <ls_wbselements>-ps_psp_pnr_vbap.
        me->mo_run_environment->append_log( iv_log_statement = |WBS Element different in vbrp and vbap.| ).
        RETURN.
      ENDIF.
    ENDLOOP.

    "Billing Plan Number in vbrp and vbkd should be the same
    SELECT vbrp~vbeln, vbrp~posnr, vbrp~fplnr, vbkd~fplnr AS fplnr_vbkd
      FROM vbrp JOIN vbkd ON vbrp~aubel = vbkd~vbeln AND vbrp~aupos = vbkd~posnr
      FOR ALL ENTRIES IN @lt_ebdr_items
      WHERE vbrp~vbeln = @lt_ebdr_items-vbeln AND
            vbrp~posnr = @lt_ebdr_items-posnr
      INTO TABLE @DATA(lt_fplnr).

    LOOP AT lt_fplnr ASSIGNING FIELD-SYMBOL(<ls_fplnr>).
      IF <ls_fplnr>-fplnr <> <ls_fplnr>-fplnr_vbkd.
        me->mo_run_environment->append_log( iv_log_statement = |Billing Plan Number different in vbrp and vbkd.| ).
        RETURN.
      ENDIF.
    ENDLOOP.


    "Billing Plan Date in vbrp and fplt should be the same
    SELECT vbrp~vbeln, vbrp~posnr, vbrp~fbuda, fplt~afdat
      FROM vbrp JOIN fplt ON vbrp~fplnr = fplt~fplnr AND vbrp~fpltr = fplt~fpltr
      FOR ALL ENTRIES IN @lt_ebdr_items
      WHERE vbrp~vbeln = @lt_ebdr_items-vbeln AND
            vbrp~posnr = @lt_ebdr_items-posnr
      INTO TABLE @DATA(lt_fbuda).

    LOOP AT lt_fbuda ASSIGNING FIELD-SYMBOL(<ls_fbuda>).
      IF <ls_fbuda>-fbuda <> <ls_fbuda>-afdat.
        me->mo_run_environment->append_log( iv_log_statement = |Billing Plan Date different in vbrp and fplt.| ).
        RETURN.
      ENDIF.
    ENDLOOP.


    "Set success message and status
    ev_check_status = abap_true.
    me->mo_run_environment->append_log( iv_log_statement = |Check fields of new project billing process was successful.| ).

  ENDMETHOD.


  METHOD check_paypal_data.

    DATA: lv_rplnr                 TYPE rplnr,
          lv_error_occured         TYPE abap_bool VALUE abap_false,
          ls_return                TYPE bapiret2,
          lt_check_data            TYPE ty_gs_ptf_paymentcard_check_td,
          lt_vbeln                 TYPE cl_ptf_util=>ty_vbeln_tab,
          cnt_compare              TYPE i,
          lv_amount_w_4_dec_places TYPE sdbil_esr_amount_content.
**********************************************************************
*Get Predecessors and testdata
    ev_check_status = abap_false.
    ev_execution_status = abap_false.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    IF lt_vbeln IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |There is no BDR to check.| ).
      RETURN.
    ENDIF.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = lt_check_data
    ).

**********************************************************************
*    LOOP AT lt_vbeln REFERENCE INTO DATA(ls_vbeln).
*
*      SELECT SINGLE rplnr FROM vbrk INTO @lv_rplnr
*                            WHERE vbeln = @ls_vbeln->vbeln.
*
*      SELECT SINGLE ccins, autwr, ccwae, aunum, audat, autim, dp_psp, dp_psp_transid FROM fpltc INTO @DATA(ls_paypal)
*        WHERE fplnr = @lv_rplnr.
*
*    ENDLOOP.
    SELECT  vbrk~vbeln, vbrk~rplnr,  c~fplnr,   ccins, autwr, ccwae, aunum, audat, autim, dp_psp, dp_psp_transid
      FROM vbrk
      INNER JOIN fpltc AS c ON vbrk~rplnr = c~fplnr
      INTO TABLE @DATA(lt_paypal)
      FOR ALL ENTRIES IN @lt_vbeln WHERE vbeln = @lt_vbeln-vbeln(10).

    IF lt_paypal IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No FPLTC record found.| ).
      RETURN.
    ENDIF.

    IF lines( lt_paypal ) NE lines( lt_check_data ).
      me->mo_run_environment->append_log( iv_log_statement = |The number of check records deviates from the actual number of records.| ).
      RETURN.
    ENDIF.

    SORT lt_check_data BY authorized_amount_in_authzn_cr-currency_code.
    SORT lt_paypal     BY ccwae.  "as the order of the select result is not defined

    LOOP AT lt_check_data INTO DATA(ls_check_data).

      READ TABLE lt_paypal INDEX sy-tabix INTO DATA(ls_paypal).

      ADD 1 TO cnt_compare.

      CONVERT TIME STAMP ls_check_data-authorization_date_time TIME ZONE sy-zonlo
      INTO DATE DATA(dat) TIME DATA(tim).

      lv_amount_w_4_dec_places = ls_paypal-autwr.

      IF NOT
          (
              ls_paypal-ccins          = ls_check_data-payment_card_type
          AND lv_amount_w_4_dec_places = ls_check_data-authorized_amount_in_authzn_cr-content
          AND ls_paypal-ccwae          = ls_check_data-authorized_amount_in_authzn_cr-currency_code
          AND ls_paypal-dp_psp         = ls_check_data-payment_service_provider
          AND ls_paypal-dp_psp_transid = ls_check_data-transaction_by_payt_srvc_prvdr
          AND ls_paypal-audat          = dat
          AND ls_paypal-autim          = tim
          ).
        lv_error_occured = abap_true.
        EXIT.
      ENDIF.

    ENDLOOP.

    IF lv_error_occured EQ abap_false.
      ls_return-message = |{ cnt_compare } FPLTC records compared. No deviations were found.|.
      me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
      ev_check_status = abap_true.
    ELSE.
      ls_return-message = 'There is at least one deviation.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
    ENDIF.
    APPEND LINES OF lt_vbeln TO ev_document_id.
    ev_execution_status = abap_true.

  ENDMETHOD.


  method check_profitabi_segment_values.
    data:
      ls_testdata type cl_ptf_sd_util=>ty_gs_i_ptf_ext_field_check_td,
      lt_vbeln    type cl_ptf_util=>ty_vbeln_tab.

    data lo_db_access type ref to cl_sd_bill_db_access.

    field-symbols: <ls_ext_field_db> type any.

    ev_check_status = abap_false.
    ev_execution_status = abap_false.

    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
* ----------------------------------------------- get test data -----
    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = ls_step_data
      importing
        es_testdata  = ls_testdata ).
* --------------- get billing document number from reference step -----
    loop at step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      if lines( lt_ptf_keys ) eq 0.
        me->mo_run_environment->append_log( iv_log_statement = |No documents found for step { <lv_ref_step> }| ).
      endif.
      append lines of lt_ptf_keys to lt_vbeln.
    endloop.
    if lines( lt_vbeln ) eq 0.
      me->mo_run_environment->append_log( iv_log_statement = |Nothing to check.| ).
      return.
    endif.

    data lt_billing_documents type t_vbeln.

    move-corresponding lt_vbeln to lt_billing_documents.

    lo_db_access = new cl_sd_bill_db_access( ).
    lo_db_access->select_vbrp_for_vbeln_tab(
      exporting
        it_vbeln =       lt_billing_documents
      importing
        et_vbrp  =       data(lt_vbrp)
    ).
    assert lt_vbrp is not initial.

*  "Prof Segment (PAOBJNR) in vbrp
*  SELECT vbrp~vbeln, vbrp~posnr, vbrp~paobjnr AS paobjnr_vbrp
*    FROM vbrp
*    FOR ALL ENTRIES IN @lt_vbrp
*    WHERE vbrp~vbeln = @lt_vbrp-vbeln AND
*          vbrp~posnr = @lt_vbrp-posnr
*    INTO TABLE @DATA(lt_prof_segment).

    "Prof Segment Array from CE4A000_ACCT
    select * from ce4a000_acct
      for all entries in @lt_vbrp
      where ce4a000_acct~paobjnr = @lt_vbrp-paobjnr
      into table @data(lt_prof_segment_array). "test once that this works for multiple items with same PAOBJNR


    loop at lt_vbrp assigning field-symbol(<ls_vbrp>).
      me->mo_run_environment->append_log( iv_log_statement = |Checking VBELN: { <ls_vbrp>-vbeln } item { <ls_vbrp>-posnr }, VBRP-PAOBJNR: { <ls_vbrp>-paobjnr }.| ).

      read table lt_prof_segment_array with key paobjnr = <ls_vbrp>-paobjnr into data(ls_prof_segment_array).
      if sy-subrc <> 0.
        me->mo_run_environment->append_log( iv_log_statement = |Profitability segment not persisted in CE4A000_ACCT.| ).
        return. "stops at the first error
      endif.

*   Compare fields
      loop at ls_testdata-ext_fields assigning field-symbol(<ls_ext_field>) where type = 'P'.

        assign component <ls_ext_field>-name of structure <ls_vbrp> to field-symbol(<lv_vbrp_field>).
        if sy-subrc <> 0.
          me->mo_run_environment->append_log( iv_log_statement = |VBRP does not contain custom field { <ls_ext_field>-name }.| ).
          return.
        endif.

*       Replace context suffix from Billing Document Item to Market Segmement
        replace 'BDI' with 'MSE' into <ls_ext_field>-name.

        assign component <ls_ext_field>-name of structure ls_prof_segment_array to field-symbol(<lv_prof_segm_field>).
        if sy-subrc <> 0.
          me->mo_run_environment->append_log( iv_log_statement = |Profitability segment does not contain custom field { <ls_ext_field>-name }.| ).
          return.
        endif.

        if <lv_prof_segm_field> <> <lv_vbrp_field>.
          me->mo_run_environment->append_log( iv_log_statement = |Field { <ls_ext_field>-name }: ProfSegm has value { <lv_prof_segm_field> }, VBRP has value { <lv_vbrp_field> }.| ).
          return. "stops at the first error
        endif.
      endloop.
    endloop. "VBRP

    ev_execution_status = abap_true.
    ev_check_status = abap_true.
    me->mo_run_environment->append_log( iv_log_statement = |Checked { lines( lt_vbrp ) } items, found no problem.| ).
  endmethod.


  METHOD check_reference_tax."check_order_tax
    DATA: lt_vbrk         TYPE TABLE OF vbrk,
          lt_vbak         TYPE TABLE OF vbak,
          lt_vbak_vbelns  TYPE cl_ptf_util=>ty_vbeln_tab,
          lt_vbrk_vbelns  TYPE cl_ptf_util=>ty_vbeln_tab,
          ls_komk         TYPE komk,
          lt_komv         TYPE STANDARD TABLE OF komv,
          lv_tax_vbrk     TYPE komv-kwert,
          lv_tax_vbak     TYPE komv-kwert,
          lv_currency     TYPE komv-waers,
          lv_check_status TYPE abap_bool,
          lv_message      TYPE string.

    ev_check_status = abap_false.
    ev_execution_status = abap_false.

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

*** Check if BDR was created by reference
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_reference_step_bdr_create>).
      DATA(ls_reference_bdr_create) = me->mo_run_environment->get_step_data( iv_step_number = <lv_reference_step_bdr_create> ).
      IF ls_reference_bdr_create-bus_obj = 'EBDR' AND ls_reference_bdr_create-action(6) = 'CREATE'.
        APPEND LINES OF ls_reference_bdr_create-document_id TO lt_vbrk_vbelns.
        LOOP AT ls_reference_bdr_create-reference_step ASSIGNING FIELD-SYMBOL(<lv_reference_step_or_create>).
          DATA(ls_reference_or_create) = me->mo_run_environment->get_step_data( iv_step_number = <lv_reference_step_or_create> ).
          IF ls_reference_or_create-bus_obj <> 'EBDR' AND ls_reference_or_create-action(6) = 'CREATE'.
            APPEND LINES OF ls_reference_or_create-document_id TO lt_vbak_vbelns.
          ELSE.
            CONTINUE.
          ENDIF.
        ENDLOOP.
      ELSE.
        CONTINUE. "Not a BDR create step.
      ENDIF.
    ENDLOOP.

    IF lt_vbak_vbelns IS NOT INITIAL AND lt_vbrk_vbelns IS NOT INITIAL.
      SORT lt_vbak_vbelns.
      DELETE ADJACENT DUPLICATES FROM lt_vbak_vbelns.
      SORT lt_vbrk_vbelns.
      DELETE ADJACENT DUPLICATES FROM lt_vbrk_vbelns.

      TYPES:
        BEGIN OF ty_vbeln_orig,
          vbeln TYPE vbeln,
        END OF ty_vbeln_orig.
      DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.
      MOVE lt_vbrk_vbelns TO lt_vbeln_key.


      SELECT * FROM vbrk INTO TABLE @lt_vbrk FOR ALL ENTRIES IN @lt_vbeln_key WHERE vbeln = @lt_vbeln_key-vbeln.

      CLEAR lt_vbeln_key.
      MOVE lt_vbak_vbelns TO lt_vbeln_key.
      SELECT * FROM vbak INTO TABLE @lt_vbak FOR ALL ENTRIES IN @lt_vbeln_key WHERE vbeln = @lt_vbeln_key-vbeln.

      IF lt_vbrk IS INITIAL OR lt_vbak IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |Reference document number was empty| ).
      ELSE.

        lv_check_status = abap_true.
        LOOP AT lt_vbak ASSIGNING FIELD-SYMBOL(<ls_vbak>).
          lv_message = 'Tax amount in reference document ' && |{ <ls_vbak>-vbeln }| && 'reference documents '.
          CLEAR: ls_komk, lt_komv.
          ls_komk-mandt = sy-mandt.
          ls_komk-belnr = <ls_vbak>-vbeln.
          ls_komk-knumv = <ls_vbak>-knumv.
          CLEAR: lv_currency.
          CLEAR: lv_tax_vbak, lv_tax_vbrk.
          CALL FUNCTION 'RV_KONV_SELECT'
            EXPORTING
              comm_head_i = ls_komk
            TABLES
              tkomv       = lt_komv.
          LOOP AT lt_komv ASSIGNING FIELD-SYMBOL(<ls_komv>) WHERE kstat = space AND koaid = 'D'. "only taxes
            IF lv_currency IS INITIAL.
              lv_currency = <ls_komv>-waers.
            ELSE.
              IF lv_currency <> <ls_komv>-waers.
                me->mo_run_environment->append_log( iv_log_statement = |Mismatch in condition currencies| ).
                RETURN.
              ENDIF.
            ENDIF.
            lv_tax_vbak = lv_tax_vbak + <ls_komv>-kwert.
          ENDLOOP.
          LOOP AT lt_vbrk ASSIGNING FIELD-SYMBOL(<ls_vbrk>) WHERE bdr_ref = <ls_vbak>-vbeln.
            CLEAR: ls_komk, lt_komv.
            ls_komk-mandt = sy-mandt.
            ls_komk-belnr = <ls_vbrk>-vbeln.
            ls_komk-knumv = <ls_vbrk>-knumv.
            CALL FUNCTION 'RV_KONV_SELECT'
              EXPORTING
                comm_head_i = ls_komk
              TABLES
                tkomv       = lt_komv.
            LOOP AT lt_komv ASSIGNING <ls_komv> WHERE kstat = space AND koaid = 'D'. "only taxes
              IF lv_currency <> <ls_komv>-waers.
                me->mo_run_environment->append_log( iv_log_statement = |Mismatch in condition currencies| ).
                EXIT.
              ENDIF.
              lv_tax_vbrk = lv_tax_vbrk + <ls_komv>-kwert.
            ENDLOOP.
            lv_message = lv_message && |{ <ls_vbrk>-vbeln }|.
          ENDLOOP.
          IF sy-subrc <> 0.
            me->mo_run_environment->append_log( iv_log_statement = |Reference document number was empty| ).
            EXIT.                                       "#EC CI_NOORDER
          ENDIF.
          IF lv_tax_vbak <> lv_tax_vbrk.
            lv_check_status = abap_false.
            lv_message = lv_message && ' do not match (' && |{ lv_tax_vbak }| && '<>' && |{ lv_tax_vbrk }| && ').'.
            me->mo_run_environment->append_log( iv_log_statement = lv_message ).
            EXIT.                                       "#EC CI_NOORDER
          ENDIF.
        ENDLOOP.
        ev_check_status = lv_check_status.
      ENDIF.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |Reference document number was empty| ).
    ENDIF.

    ev_execution_status = abap_true.
  ENDMETHOD.


  method CHECK_TEXT_EXISTED.
  DATA: lv_tdname        TYPE thead-tdname,
        lv_object        TYPE thead-tdobject,
        lv_error_occured TYPE abap_bool VALUE abap_false,
        lt_lines         TYPE TABLE OF tline,
        ls_lines         TYPE tline,
        ls_return        TYPE bapiret2,
        lt_check_data    TYPE cl_ptf_sd_util=>ty_bapisdtext,
        lt_vbeln         TYPE cl_ptf_util=>ty_vbeln_tab.
**********************************************************************
*Get Predecessors and testdata
  ev_check_status = abap_false.

  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.

  IF lt_vbeln IS INITIAL.
    me->mo_run_environment->append_log( iv_log_statement = |No referenced documents exist.| ).
    ev_check_status     = abap_false.
    "ev_execution_status = abap_true.
    RETURN.
  ENDIF.

  cl_ptf_util=>get_testdata(
    EXPORTING
      is_step_data = step_data
    IMPORTING
      es_testdata  = lt_check_data
  ).

**********************************************************************
*check
  LOOP AT lt_vbeln REFERENCE INTO DATA(ls_vbeln).
    LOOP AT lt_check_data REFERENCE INTO DATA(ls_check_data).

      IF ls_check_data->itm_number IS NOT INITIAL.
        lv_tdname = ls_vbeln->vbeln && ls_check_data->itm_number.
        lv_object = 'VBBP'.
      ELSE.
        lv_tdname = ls_vbeln->vbeln.
        lv_object = 'VBBK'.
      ENDIF.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = ls_check_data->text_id
          language                = ls_check_data->langu
          name                    = lv_tdname
          object                  = lv_object
        TABLES
          lines                   = lt_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7.

      IF sy-subrc <> 0.
        me->mo_run_environment->append_log( iv_log_statement = |Error while retrieving texts via FM READ_TEXT: { sy-subrc }| ).
        ev_check_status = abap_false.
        ev_execution_status = abap_true.
        RETURN.
      ENDIF.

*only check for first line
      READ TABLE lt_lines INTO ls_lines INDEX 1.

      IF ls_lines-tdline NE ls_check_data->text_line.
        ls_return-message = 'Text of billing documents ' && ls_vbeln->vbeln &&' are not correct.'.
        me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
        lv_error_occured = abap_true.
        EXIT.
      ENDIF.
    ENDLOOP.
  ENDLOOP.
**********************************************************************
*map data for PTF
  IF lv_error_occured EQ abap_false.
    ev_check_status = abap_true.
    ls_return-message = 'Text comparison of copied texts was successful.'.
    me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
  ENDIF.
  APPEND LINES OF lt_vbeln TO ev_document_id.
  ev_execution_status = abap_true.

  endmethod.


  method CHECK_TEXT_NONEXIST.
  DATA: lv_tdname        TYPE thead-tdname,
        lv_object        TYPE thead-tdobject,
        lv_error_occured TYPE abap_bool VALUE abap_false,
        lt_lines         TYPE TABLE OF tline,
        ls_lines         TYPE tline,
        ls_return        TYPE bapiret2,
        lt_check_data    TYPE cl_ptf_sd_util=>ty_bapisdtext,
        lt_vbeln         TYPE cl_ptf_util=>ty_vbeln_tab.
**********************************************************************
*Get Predecessors and testdata
  ev_check_status = abap_false.

  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.

  IF lt_vbeln IS INITIAL.
    me->mo_run_environment->append_log( iv_log_statement = |No referenced documents exist.| ).
    ev_check_status     = abap_false.
    "ev_execution_status = abap_true.
    RETURN.
  ENDIF.

  cl_ptf_util=>get_testdata(
    EXPORTING
      is_step_data = step_data
    IMPORTING
      es_testdata  = lt_check_data
  ).

**********************************************************************
*check
  LOOP AT lt_vbeln REFERENCE INTO DATA(ls_vbeln).
    LOOP AT lt_check_data REFERENCE INTO DATA(ls_check_data).

      IF ls_check_data->itm_number IS NOT INITIAL.
        lv_tdname = ls_vbeln->vbeln && ls_check_data->itm_number.
        lv_object = 'VBBP'.
      ELSE.
        lv_tdname = ls_vbeln->vbeln.
        lv_object = 'VBBK'.
      ENDIF.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = ls_check_data->text_id
          language                = ls_check_data->langu
          name                    = lv_tdname
          object                  = lv_object
        TABLES
          lines                   = lt_lines
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7.

      IF sy-subrc = 0.
        ls_return-message = 'Text of billing documents ' && ls_vbeln->vbeln &&' are not correct.'.
        me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
        lv_error_occured = abap_true.
        EXIT.
      ENDIF.

    ENDLOOP.
  ENDLOOP.
**********************************************************************
*map data for PTF
  IF lv_error_occured EQ abap_false.
    ev_check_status = abap_true.
    ls_return-message = 'Text comparison of uncopied texts was successful.'.
    me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
  ENDIF.
  APPEND LINES OF lt_vbeln TO ev_document_id.
  ev_execution_status = abap_true.

  endmethod.


  METHOD check_with_odata.
    DATA: ls_testdata      TYPE cl_ptf_bo_invoice=>ty_gs_ptf_bd_check_td,
          ls_testdata_vbrk TYPE vbrk,
          lt_fieldinfo     TYPE extdfiest,
          lv_step_success  TYPE abap_bool.
    DATA: lv_status_text TYPE string,
          lv_status_code TYPE integer.
    DATA: BEGIN OF ls_response_bdr,
            BEGIN OF d,
              BEGIN OF __metadata,
                id   TYPE string,
                uri  TYPE string,
                type TYPE string,
              END OF __metadata,
              billingdocumentrequest      TYPE vbeln_va,
              referencesddocument         TYPE vbeln_va,
              billingdocumentrequesttype  TYPE vbtypl,
              billingdocumenttypename     TYPE string,
              soldtoparty                 TYPE kna1-kunnr,
              soldtopartyname             TYPE string,
              soldtopartyadditionalname   TYPE string,
              salesdocumentcondition      TYPE prcd_elements-knumv,
              overallbillingdocreqstatus  TYPE bdr_status,
              payerparty                  TYPE kna1-kunnr,
              payerpartyname              TYPE string,
              payerpartyadditionalname    TYPE string,
              companycode                 TYPE bukrs,
              salesorganization           TYPE vkorg,
              billingdocumentdate         TYPE string, "date,
              creationdate                TYPE string, "date,
              billingissuetype            TYPE string,
              billgdocreqreflgclsyst      TYPE logsys,
              billingdocrequestreference  TYPE vgbel,
              billgdocreqrefsddoccategory TYPE vbrp-vgtyp,
              proposedbillingdocumenttype TYPE vbtyp,
              totaltaxamount              TYPE netwr,
              totalgrossamount            TYPE netwr, "f,
              totalnetamount              TYPE netwr, "f,
              transactioncurrency         TYPE waerk,
              sddocumentcategory          TYPE vbtyp,
              customerpaymentterms        TYPE vbrk-zterm,
              incotermsversion            TYPE string,
              incotermsclassification     TYPE string,
              incotermslocation1          TYPE string,
            END OF d,
          END OF ls_response_bdr.

    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/sap/SD_EBDR_MANAGE_SRV/'.
    DATA: lv_uri TYPE string.
    DATA lt_parameters TYPE /iwfnd/sutil_property_t.

    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    FIELD-SYMBOLS: <ls_odata_field> TYPE any.

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

    CLEAR lt_fieldinfo.
    CALL FUNCTION 'DD_INT_TABLINFO_GET'
      EXPORTING
        typename       = 'VBRK'
      TABLES
        extdfies_tab   = lt_fieldinfo
      EXCEPTIONS
        not_found      = 1
        internal_error = 2
        OTHERS         = 3.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    lv_step_success = abap_true.
    LOOP AT ls_step_data-reference_step INTO DATA(lv_prestepnumber).
      DATA(ls_check_step_data) = me->mo_run_environment->get_step_data( iv_step_number = lv_prestepnumber ).

      IF ls_check_step_data-document_id IS INITIAL.
        ev_execution_status = abap_false.
        me->mo_run_environment->append_log( iv_log_statement = |No reference document exists!| ).
        RETURN.
      ENDIF.
      LOOP AT ls_check_step_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).
        DATA(lv_index) = sy-tabix.
        lt_parameters = VALUE #( ( name = 'BillingDocumentRequest' value =  <ls_docid> ) ).

        lo_odata_caller->call_service(
          EXPORTING
            iv_action_or_entity = 'C_BillgDocReqWorklist'
            it_parameters       = lt_parameters                   " Name/Value Pair - Table
          IMPORTING
            ev_status_code      = lv_status_code                  " Whole Number with +/- Sign (-2.147.483.648 .. 2.147.483.647)
            ev_status_text      = lv_status_text
            es_json_response    = ls_response_bdr
        ).
        ev_check_status = abap_true.

        IF lv_status_code = 200.
*         Only header can be checked with Worklist ODATA
          READ TABLE ls_testdata-vbrk_check INDEX lv_index ASSIGNING FIELD-SYMBOL(<ls_vbrk_check>).
          IF sy-subrc = 0.
            READ TABLE ls_testdata-vbrk INDEX lv_index INTO ls_testdata_vbrk.
            LOOP AT lt_fieldinfo ASSIGNING FIELD-SYMBOL(<ls_fieldinfo>).
              ASSIGN COMPONENT <ls_fieldinfo>-fieldname OF STRUCTURE <ls_vbrk_check> TO FIELD-SYMBOL(<ls_check_field>).
              IF <ls_check_field> IS ASSIGNED AND <ls_check_field> = 'X'.
                ASSIGN COMPONENT <ls_fieldinfo>-fieldname OF STRUCTURE ls_testdata_vbrk TO FIELD-SYMBOL(<ls_field>).
                IF <ls_field> IS ASSIGNED.
                  UNASSIGN <ls_odata_field>.
                  CASE <ls_fieldinfo>-fieldname.
                    WHEN 'VBTYP'.
                      ASSIGN ls_response_bdr-d-billingdocumentrequesttype TO <ls_odata_field>.
                    WHEN 'FKDAT'.
                      DATA(lv_billingdate) = lo_odata_caller->convert_json_date( ls_response_bdr-d-billingdocumentdate ).
                      ASSIGN lv_billingdate TO <ls_odata_field>.
                    WHEN 'KUNRG'.
                      ASSIGN ls_response_bdr-d-payerparty TO <ls_odata_field>.
                  ENDCASE.
                  IF <ls_odata_field> IS ASSIGNED.
                    IF <ls_field> = <ls_odata_field>.
                      lv_step_success = abap_true.
                    ELSE.
                      lv_step_success = abap_false.
                      me->mo_run_environment->append_log( iv_log_statement = |The Value of the { <ls_fieldinfo>-tabname } field { <ls_fieldinfo>-fieldname } is not as expected. The expected value is: { <ls_field> }| &&
                                |. The stored value is: { <ls_odata_field> } .| ).
                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDLOOP.
          ENDIF.

        ELSE. "lv_status = 200
          me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
          lv_step_success = abap_false.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
    ev_check_status = lv_step_success.
** Output in case of success
    IF lv_step_success EQ abap_true.
      ev_execution_status = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |The values of the checked document are correct. Process step is: { ls_step_data-step_number }| ).
    ELSE.
      ev_execution_status = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |The values of the checked document are not correct. Process step is: { ls_step_data-step_number }| ).
    ENDIF.
  ENDMETHOD.


  METHOD create.
    DATA:
      lv_reference_id              TYPE vbeln,
      ran_int                      TYPE qf00-ran_int,
      lv_vgbel                     TYPE vbeln,
      ls_testdata                  TYPE ty_gs_i_ptf_ebdr_cr_td,
      lt_ebdr_request_in           TYPE sdbil_ebdr_request_t,
      lt_ebdr_request_condition_in TYPE sdbil_ebdr_request_cond_t,
      lt_ebdr_request_text_in      TYPE sdbil_ebdr_request_text_t,
      ls_administration_data       TYPE sdbil_ebdr_request_admin,
      ls_control_data              TYPE sdbil_ebdr_request_ctrl,
      lv_log_message               TYPE string.

******************************************************************************
* 1.  Get data from tdc
    DATA(ls_current_step) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_current_step
      IMPORTING
        es_testdata  = ls_testdata ).

    IF ls_current_step-reference_step IS NOT INITIAL.
      DATA(ref_step) = ls_current_step-reference_step[ 1 ].
      DATA(doc_ids) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = ref_step ).
      IF doc_ids IS NOT INITIAL.
        lv_reference_id = doc_ids[ 1 ].
      ENDIF.
    ENDIF.

*****************************************************************************
* 2 Step: Prepare data for BAPI call
    CLEAR: lt_ebdr_request_in, ls_administration_data.
    MOVE ls_testdata-ebdr_request_in TO lt_ebdr_request_in.
    MOVE ls_testdata-ebdr_requ_cond_in TO lt_ebdr_request_condition_in.
    MOVE ls_testdata-ebdr_requ_text_in TO lt_ebdr_request_text_in.

*    fill senderlogicalsystem with name of test data container variable to identify EBDR document as created by PTF Framework
    ls_administration_data-senderlogicalsystem = ls_current_step-variant.

    IF lt_ebdr_request_in IS INITIAL.
      ev_execution_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement =  'No BDRs provided.' ).
      RETURN.
    ENDIF.
*   randomize preceding_document_id to get a unique ID.
    DATA(lv_actual_precedingdocument) = lt_ebdr_request_in[ 1 ]-precedingdocument.
    LOOP AT lt_ebdr_request_in ASSIGNING FIELD-SYMBOL(<ls_ebdr_request_in>).
      IF ( sy-tabix = 1 ) OR
        ( <ls_ebdr_request_in>-precedingdocument <> lv_actual_precedingdocument ).

        IF lv_reference_id IS INITIAL.
          DO 2 TIMES.
            CALL FUNCTION 'QF05_RANDOM_INTEGER'
              EXPORTING
                ran_int_max   = 9999
                ran_int_min   = 1000
              IMPORTING
                ran_int       = ran_int
              EXCEPTIONS
                invalid_input = 1
                OTHERS        = 2.
          ENDDO.

          lv_vgbel = |{ ran_int }{ sy-uzeit }|.
        ELSE.
          lv_vgbel = lv_reference_id.
        ENDIF.

        lv_actual_precedingdocument = <ls_ebdr_request_in>-precedingdocument.
      ENDIF.

      <ls_ebdr_request_in>-precedingdocument = lv_vgbel.
      LOOP AT lt_ebdr_request_condition_in ASSIGNING FIELD-SYMBOL(<ls_ebdr_request_condition_in>) WHERE precedingdocument = lv_actual_precedingdocument.
        <ls_ebdr_request_condition_in>-precedingdocument = lv_vgbel.
      ENDLOOP.
      LOOP AT lt_ebdr_request_text_in ASSIGNING FIELD-SYMBOL(<ls_ebdr_request_text_in>) WHERE precedingdocument = lv_actual_precedingdocument.
        <ls_ebdr_request_text_in>-precedingdocument = lv_vgbel.
      ENDLOOP.

    ENDLOOP.

*****************************************************************************
* 3 Step: Create EBDR and commit
    ls_control_data-commit_mode = '2'. "Synchronous COMMIT to ensure data is on DB at check
    ls_control_data-precedingdocumentcheck = abap_true.

    CALL METHOD cl_sd_bil_ebdr_facade_ext=>if_sd_bil_ebdr_action_ext~create_from_data
      EXPORTING
        is_ebdr_request_ctrl   = ls_control_data                " External Billing Document Request - Request - Control
        is_ebdr_admin          = ls_administration_data         " External Billing Document Request - Request - Administrative data
        it_ebdr_request        = lt_ebdr_request_in             " External Billing Document Request - Request
        it_ebdr_request_cond   = lt_ebdr_request_condition_in   " External Billing Document Request - Request - Condition
        it_ebdr_request_text   = lt_ebdr_request_text_in
      IMPORTING
        et_ebdr                = DATA(lt_ebdr_ids)
        et_ebdr_request_result = DATA(lt_success_ebdrs)          " External Billing Document Request - Request - Result
        et_ebdr_request_failed = DATA(lt_failed_ebdrs)
        et_ebdr_request_msg    = DATA(lt_ebdr_request_msg).     " External Billing Document Request - Request - Message


******************************************************************************
* 4 Step:  Copy messages to et_return
    LOOP AT lt_ebdr_request_msg ASSIGNING FIELD-SYMBOL(<ls_request_msg>).
      MOVE <ls_request_msg>-systemmessagetext TO lv_log_message.
      me->mo_run_environment->append_log( iv_log_statement =  lv_log_message ).
*********************
      DATA ls_t100 TYPE ptf_t100_message.
      DATA lt_t100 TYPE ptf_t100_message_t.
      ls_t100-type = <ls_request_msg>-systemmessagetype.
      ls_t100-id   = <ls_request_msg>-systemmessageidentification.
      ls_t100-number = <ls_request_msg>-systemmessagenumber.
      ls_t100-message_v1 = <ls_request_msg>-systemmessagevariable1.
      ls_t100-message_v2 = <ls_request_msg>-systemmessagevariable2.
      ls_t100-message_v3 = <ls_request_msg>-systemmessagevariable3.
      ls_t100-message_v4 = <ls_request_msg>-systemmessagevariable4.
      APPEND ls_t100 TO lt_t100.
*********************
    ENDLOOP.
    cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~add_actual_messages( lt_t100 ).

******************************************************************************
* 5 Step: Check if EBDR exists
    IF lt_failed_ebdrs IS INITIAL.
      IF lines( lt_success_ebdrs ) = lines( lt_ebdr_request_in ).
        ev_execution_status = abap_true.
        APPEND LINES OF lt_ebdr_ids TO ev_document_id.
      ELSE.
        ev_execution_status = abap_false.
        me->mo_run_environment->append_log( iv_log_statement =  'Number of input and created data do not match.' ).
      ENDIF.
    ELSE.
      ev_execution_status = abap_false.
      LOOP AT lt_failed_ebdrs ASSIGNING FIELD-SYMBOL(<ls_failed_ebdrs>).
        me->mo_run_environment->append_log( iv_log_statement =  |No BDR document was created for preceding document: { <ls_failed_ebdrs>-precedingdocument }.| ).
      ENDLOOP.
      APPEND LINES OF lt_ebdr_ids TO ev_document_id.
    ENDIF.

  ENDMETHOD.


  method CREATE_EBDR_ICO.
    " Step 1: Get number of Intercompany Sales Document and Customer Project.
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lv_tabix) = sy-tabix.
      DATA(lt_ptf_keys) = mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      IF lines( lt_ptf_keys ) = 0.
        mo_run_environment->append_log( iv_log_statement = |No documents found for step { <lv_ref_step> }| ).
      ENDIF.
      LOOP AT lt_ptf_keys ASSIGNING FIELD-SYMBOL(<lv_ptf_key>).
        IF lv_tabix = 1.
          DATA(lv_intercompany_sd) = <lv_ptf_key>-vbeln.
        ELSEIF lv_tabix = 2.
          DATA(lv_customer_project) = <lv_ptf_key>-vbeln.
        ELSE.
          mo_run_environment->append_log( iv_log_statement = 'Creation Intercompany BDR is only allowed with 2 referenceSteps, not more.' ).
          ev_execution_status = abap_false.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
    " -----------------------------------------------------------------------------
    " Step 2: Create Intercompany BDR
    DATA lt_parameters TYPE if_apj_dt_exec_object=>tt_templ_val.
    lt_parameters = VALUE #( kind   = 'S'
                             sign   = 'I'
                             option = 'EQ'
                             ( selname = 'DD_VBELN'   low = lv_intercompany_sd )
                             ( selname = 'SO_PROJ'    low = lv_customer_project ) ).

    SUBMIT rdpicbmass
           WITH SELECTION-TABLE lt_parameters.

    ev_execution_status = abap_false.
  endmethod.


  METHOD create_for_negative_testing.
    DATA:
      ls_testdata            TYPE ty_gs_i_ptf_ebdr_cr_neg_td,
      lt_ebdr_request_in     TYPE bapiebdrrequest_t, "sdbil_ebdr_request_t,
      lt_ebdr_ids            TYPE bapiebdrrequestextbilldocreq_t,
      lv_vgbel               TYPE vbeln,
      ls_administration_data TYPE bapiebdrrequestadmin,
      ls_control_data        TYPE bapiebdrrequestctrl,
      lt_success_ebdrs       TYPE bapiebdrrequestresult_t,
      lt_failed_ebdrs        TYPE bapiebdrrequestfailed_t,
      lt_text_test_data      TYPE TABLE OF bapiebdrrequesttext,
      ls_text_test_data      TYPE bapiebdrrequesttext,
*      ls_return              TYPE bapiret2,
      lt_return              TYPE TABLE OF bapiret2.

******************************************************************************
* 1.  Get data from tdcv
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

*****************************************************************************
* 2 Step: Prepare data for BAPI call
    CLEAR: lt_ebdr_request_in, ls_administration_data.
    MOVE ls_testdata-ebdr_request_in TO lt_ebdr_request_in.

*    fill senderlogicalsystem with name of test data container variable to identify EBDR document as created by PTF Framework
    ls_administration_data-senderlogicalsystem = ls_testdata-senderlogicalsystem.

    LOOP AT lt_ebdr_request_in ASSIGNING FIELD-SYMBOL(<ls_ebdr_request_in>).

      ls_text_test_data-language = 'E'.
      ls_text_test_data-precedingdocumentitem = <ls_ebdr_request_in>-precedingdocumentitem.
      ls_text_test_data-textline = 'PTF negative testing'.
      ls_text_test_data-textobjectcategory = 'TEXT'.
      ls_text_test_data-textobjecttype = '0001'.

*    fill date and time into preceding_document_id to get a unique ID.
      IF ls_testdata-determine_precedingdocument EQ abap_true.
        CONCATENATE sy-datlo+4(4) sy-uzeit INTO lv_vgbel.
        <ls_ebdr_request_in>-precedingdocument = lv_vgbel.
        ls_text_test_data-precedingdocument = lv_vgbel.
      ENDIF.

      APPEND ls_text_test_data TO lt_text_test_data.
    ENDLOOP.

*****************************************************************************
* 3 Step: Create EBDR and commit
    ls_control_data-commit_mode = '2'. "Synchronous COMMIT to ensure data is on DB at check
    CALL FUNCTION 'BAPI_EBDR_CREATEMULTIPLE'
      EXPORTING
*       testrun                    = ' '    " External Billing Document Request - Request - Testrun
        is_control_data            = ls_control_data   " External Billing Document Request - Request - Control
        is_administration_data     = ls_administration_data    " External Billing Document Request - Request - Admin
        it_data                    = lt_ebdr_request_in
*       it_condition_data          =     " External Billing Document Request - Request - Condition
        it_text_data               = lt_text_test_data    " External Billing Document Request - Request - Text
*       it_payment_card_data       =     " External Billing Document Request - Request -  Payment Card
      IMPORTING
        et_ebdrcreateddoc          = lt_ebdr_ids " External Billing Document Request - Request - IDs
        et_ebdrcreateddocitem      = lt_success_ebdrs   " External Billing Document Request - Request - Admin
        et_ebdrcreatefaileddocitem = lt_failed_ebdrs    " External Billing Document Request - precedingdoc items
*       et_message                 =     " External Billing Document Request - Request - Message
        return                     = lt_return.

******************************************************************************
* 4 Step:  Copy messages to et_return
    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ls_msg>).
      me->mo_run_environment->append_log( iv_log_statement = |{ <ls_msg>-message }| ).
    ENDLOOP.

******************************************************************************
* 5 Step: Check if EBDR doesn't exist

    IF lines( lt_success_ebdrs ) EQ 0.
      ev_execution_status = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |No BDR document was created.| ).
      RETURN.
    ELSE.
      ev_execution_status = abap_false.
      LOOP AT lt_success_ebdrs ASSIGNING FIELD-SYMBOL(<ls_suc_ebdrs>).
        me->mo_run_environment->append_log( iv_log_statement = |BDR document was created { <ls_suc_ebdrs>-extbillingdocrequest }.| ).
      ENDLOOP.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD create_from_order.
    DATA:

      lt_bdr_vbeln         TYPE cl_ptf_util=>ty_vbeln_tab,
      lt_reference_vbeln   TYPE cl_ptf_util=>ty_vbeln_tab,

      lv_with_conditions   TYPE abap_bool VALUE abap_true,
      lv_with_knumv        TYPE abap_bool VALUE abap_false,
      ls_testdata          TYPE ty_gs_i_ptf_ebdr_cr_ref_td,

      lt_ebdr_request      TYPE sdbil_ebdr_request_t,
      lt_ebdr_request_cond TYPE sdbil_ebdr_request_cond_t,

      ls_return            TYPE bapiret2.

    ev_execution_status = abap_false. " assume test fails
******************************************************************************
* 1 Step: Get SO reference
    me->get_order_number(
      EXPORTING
        cs_step_data    = step_data
      IMPORTING
        et_order_number = lt_reference_vbeln
    ).
    IF lt_reference_vbeln IS INITIAL.
      "ToDO: add error message
      me->mo_run_environment->append_log( iv_log_statement = |No reference document given.| ).
      RETURN.
    ENDIF.

******************************************************************************
* 2 Step: Get test data for BDR creation
    IF step_data-variant IS NOT INITIAL.
      cl_ptf_util=>get_testdata(
        EXPORTING
          is_step_data = step_data
        IMPORTING
          es_testdata  = ls_testdata
      ).
      lv_with_conditions = ls_testdata-with_cond_table.
      lv_with_knumv = ls_testdata-with_knumv.
    ENDIF.

******************************************************************************
* 3 Step: Map SO data to BDR data
    IF lv_with_conditions = abap_true.
      CALL METHOD me->map_order_data
        EXPORTING
          it_order_number      = lt_reference_vbeln
          iv_with_knumv        = lv_with_knumv
        IMPORTING
          et_ebdr_request      = lt_ebdr_request
          et_ebdr_request_cond = lt_ebdr_request_cond.
    ELSE.
      CALL METHOD me->map_order_data
        EXPORTING
          it_order_number = lt_reference_vbeln
          iv_with_knumv   = lv_with_knumv
        IMPORTING
          et_ebdr_request = lt_ebdr_request
*         et_ebdr_request_cond = lt_ebdr_request_cond "we don't want the conditions table
        .
    ENDIF.


******************************************************************************
* 4 Step: Create the BDR
    CALL METHOD me->call_ebdr_facade
      EXPORTING
        it_ebdr_request      = lt_ebdr_request
        it_ebdr_request_cond = lt_ebdr_request_cond
      IMPORTING
        et_bdr_number        = lt_bdr_vbeln.

******************************************************************************
* 5 Step: Check if EBDR exists and set success flag
    DATA: lv_exists TYPE abap_bool.
    DATA: lv_ptf_key TYPE ptfkey.
    IF lt_bdr_vbeln IS INITIAL.
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.
    LOOP AT lt_bdr_vbeln ASSIGNING FIELD-SYMBOL(<lv_bdr_vbeln>).
      lv_exists = me->check_existence( iv_id = <lv_bdr_vbeln>-vbeln ).
      IF lv_exists = abap_false.
        ev_execution_status = abap_false.
        RETURN.
      ELSE.
        MOVE <lv_bdr_vbeln>-vbeln TO lv_ptf_key.
        APPEND lv_ptf_key TO ev_document_id.
      ENDIF.
    ENDLOOP.
    ev_execution_status = abap_true.

  ENDMETHOD.


  METHOD create_multiple.
    DATA:
      ran_int                      TYPE qf00-ran_int,
      ls_testdata                  TYPE ty_gs_i_ptf_ebdr_cr_mult_td,
      lv_vgbel                     TYPE vbeln,
      lt_ebdr_request_in           TYPE sdbil_ebdr_request_t,
      lt_ebdr_request_condition_in TYPE sdbil_ebdr_request_cond_t,
      ls_administration_data       TYPE bapiebdrrequestadmin,
      ls_control_data              TYPE sdbil_ebdr_request_ctrl.

******************************************************************************
* 1.  Get data from tdcv
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

    LOOP AT ls_testdata-ebdr_requests ASSIGNING FIELD-SYMBOL(<ls_ebdr_request>).

*****************************************************************************
* 2 Step: Prepare data for BAPI call
      CLEAR: lt_ebdr_request_in, ls_administration_data.
      MOVE <ls_ebdr_request>-ebdr_request_in TO lt_ebdr_request_in.
      MOVE <ls_ebdr_request>-ebdr_requ_cond_in TO lt_ebdr_request_condition_in.

*    fill senderlogicalsystem with name of test data container variable to identify EBDR document as created by PTF Framework
      ls_administration_data-senderlogicalsystem = step_data-variant.

      DO 2 TIMES.
        CALL FUNCTION 'QF05_RANDOM_INTEGER'
          EXPORTING
            ran_int_max   = 9999
            ran_int_min   = 1000
          IMPORTING
            ran_int       = ran_int
          EXCEPTIONS
            invalid_input = 1
            OTHERS        = 2.
      ENDDO.

      lv_vgbel = |{ ran_int }{ sy-uzeit }|.

*    fill date and time into preceding_document_id to get a unique ID.
      LOOP AT lt_ebdr_request_in ASSIGNING FIELD-SYMBOL(<ls_ebdr_request_in>).
        <ls_ebdr_request_in>-precedingdocument = lv_vgbel.
      ENDLOOP.

*****************************************************************************
* 3 Step: Create EBDR and commit
      ls_control_data-commit_mode = '2'. "Synchronous COMMIT to ensure data is on DB at check


      CALL METHOD cl_sd_bil_ebdr_facade_ext=>if_sd_bil_ebdr_action_ext~create_from_data
        EXPORTING
          is_ebdr_request_ctrl   = ls_control_data                " External Billing Document Request - Request - Control
          is_ebdr_admin          = ls_administration_data         " External Billing Document Request - Request - Administrative data
          it_ebdr_request        = lt_ebdr_request_in             " External Billing Document Request - Request
          it_ebdr_request_cond   = lt_ebdr_request_condition_in   " External Billing Document Request - Request - Condition
        IMPORTING
          et_ebdr                = DATA(lt_ebdr_ids)
          et_ebdr_request_result = DATA(lt_success_ebdrs)          " External Billing Document Request - Request - Result
          et_ebdr_request_failed = DATA(lt_failed_ebdrs)
          et_ebdr_request_msg    = DATA(lt_ebdr_request_msg).     " External Billing Document Request - Request - Message

******************************************************************************
* 4 Step:  Copy messages to et_return
      LOOP AT lt_ebdr_request_msg ASSIGNING FIELD-SYMBOL(<ls_msg>).
        me->mo_run_environment->append_log( iv_log_statement = | { <ls_msg>-systemmessagetext } | ).
      ENDLOOP.

******************************************************************************
* 5 Step: Check if EBDR exists
      IF lt_failed_ebdrs IS INITIAL.
        IF lines( lt_success_ebdrs ) = lines( lt_ebdr_request_in ).
          ev_execution_status = abap_true.
          APPEND LINES OF lt_ebdr_ids TO ev_document_id.
        ELSE.
          ev_execution_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |Number of input and created data don't match.| ).
        ENDIF.
      ELSE.
        ev_execution_status = abap_false.
        LOOP AT lt_failed_ebdrs ASSIGNING FIELD-SYMBOL(<ls_failed_ebdrs>).
          me->mo_run_environment->append_log( iv_log_statement = |No BDR document was created for precedingdocument: { <ls_failed_ebdrs>-precedingdocument }.| ).
        ENDLOOP.
      ENDIF.

    ENDLOOP. "LOOP AT ls_testdata-ebdr_requests ASSIGNING FIELD-SYMBOL(<ls_ebdr_request>).

  ENDMETHOD.


  METHOD create_pbdr_w_ref.

    TYPES:
      BEGIN OF ty_vbeln,
        vbeln TYPE vbeln,
      END OF ty_vbeln,
      ty_vbeln_tab TYPE STANDARD TABLE OF ty_vbeln WITH NON-UNIQUE KEY vbeln,
      BEGIN OF ty_pbr_uuid,
        pbr_uuid TYPE pbr_uuid,
      END OF ty_pbr_uuid,
      ty_pbr_uuid_tab TYPE STANDARD TABLE OF ty_pbr_uuid WITH NON-UNIQUE KEY pbr_uuid.

    DATA:
      lt_vbeln         TYPE ty_vbeln_tab,

      it_prjblgelmlist TYPE TABLE FOR ACTION IMPORT r_projectbillingelementtp~createprojectbillingrequest,
      ls_prjblgelmlist LIKE LINE OF it_prjblgelmlist,

      it_pbr_uuid      TYPE TABLE FOR ACTION IMPORT r_projectbillingrequesttp~createbillingdocumentrequest,
      is_pbr_uuid      LIKE LINE OF it_pbr_uuid,

      lv_failed        TYPE abap_bool VALUE abap_false,
      lt_uuid_pbr      TYPE ty_pbr_uuid_tab,
      ls_uuid_pbr      LIKE LINE OF lt_uuid_pbr.

******************************************************************************
* Step 1: Get number of Sales Order Service
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      IF lines( lt_ptf_keys ) EQ 0.
        me->mo_run_environment->append_log( iv_log_statement = |No documents found for step { <lv_ref_step> }| ).
      ENDIF.
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    IF lines( lt_vbeln ) EQ 0.
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |Nothing to check.| ).
      RETURN.
    ENDIF.


******************************************************************************
* Step 2: Get Billing Elements UUID and WBS Internal ID
    SELECT pbe~projectbillingelementuuid, pbe~billingwbselementinternalid FROM projbillgelmnt AS pbe JOIN vbap
        ON pbe~billingwbselementinternalid = vbap~ps_psp_pnr
        FOR ALL ENTRIES IN @lt_vbeln
        WHERE vbap~vbeln = @lt_vbeln-vbeln
        INTO TABLE @DATA(lt_projbillingelements).


******************************************************************************
* Step 3: Create PBR from Billing Element
    LOOP AT lt_projbillingelements ASSIGNING FIELD-SYMBOL(<ls_projbillingelements>).
      ls_prjblgelmlist-projectbillingelementuuid = <ls_projbillingelements>-projectbillingelementuuid.
      ls_prjblgelmlist-%param-billingwbselementinternalid = <ls_projbillingelements>-billingwbselementinternalid.
      APPEND ls_prjblgelmlist TO it_prjblgelmlist.
    ENDLOOP.

    MODIFY ENTITY r_projectbillingelementtp
    EXECUTE createprojectbillingrequest
    FROM
    it_prjblgelmlist
    RESULT   DATA(et_pbr_result)
    FAILED   DATA(lt_failed_data)
    REPORTED DATA(lt_reported_data).

    IF et_pbr_result IS NOT INITIAL.
      COMMIT ENTITIES
       RESPONSES
        FAILED   DATA(lt_commit_failed_data_pbr).
      IF lt_commit_failed_data_pbr IS NOT INITIAL.
        ev_execution_status = abap_false.
        me->mo_run_environment->append_log( iv_log_statement = |Project billing requests could not be committed.| ).
        RETURN.
      ENDIF.
    ELSE.
      ev_execution_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |Project billing requests could not be created.| ).
      RETURN.
    ENDIF.


******************************************************************************
* Step 4: Create BDR from Project Billing Request
    LOOP AT et_pbr_result ASSIGNING FIELD-SYMBOL(<ls_pbr_result>).
      is_pbr_uuid-projectbillingrequestuuid = <ls_pbr_result>-%param-projectbillingrequestuuid.
      APPEND is_pbr_uuid TO it_pbr_uuid.
    ENDLOOP.

    MODIFY ENTITY r_projectbillingrequesttp
    EXECUTE createbillingdocumentrequest
    FROM
    it_pbr_uuid
    RESULT   DATA(et_bdr_result)
    FAILED   DATA(lt_failed_data_bdr).


******************************************************************************
* Step 5: Check if BDR creation was successful
    IF et_bdr_result IS NOT INITIAL.
      COMMIT ENTITIES
       RESPONSES
        FAILED   DATA(lt_commit_failed_data_bdr).
      IF lt_commit_failed_data_bdr IS NOT INITIAL.
        lv_failed = abap_true.
      ENDIF.
    ELSE.
      lv_failed = abap_true.
    ENDIF.

    IF lv_failed IS NOT INITIAL.
      ev_execution_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |Billing Document Request could not be created.| ).
    ELSE.
      LOOP AT et_pbr_result ASSIGNING FIELD-SYMBOL(<ls_result>).
        ls_uuid_pbr-pbr_uuid = <ls_result>-%param-projectbillingrequestuuid.
        APPEND ls_uuid_pbr TO lt_uuid_pbr.
      ENDLOOP.

      SELECT pbeeflw~billingdocument FROM projbillgreqitem AS pbri JOIN prjblgemtentrflw AS pbeeflw
              ON pbri~projbillgelmntentritmuuid = pbeeflw~projbillgelmntentritmuuid
              FOR ALL ENTRIES IN @lt_uuid_pbr
              WHERE pbri~projectbillingrequestuuid = @lt_uuid_pbr-pbr_uuid AND
                    pbeeflw~documentbillingstatus = 'A'
              INTO TABLE @DATA(lt_bdr).

      IF lines( lt_bdr ) < 1 .
        ev_execution_status = abap_false.
        me->mo_run_environment->append_log( iv_log_statement = |No Billing Document Request found.| ).
        RETURN.
      ENDIF.

      me->mo_run_environment->append_log( iv_log_statement = |Billing Document Request has been created.| ).
      ev_document_id = lt_bdr.
      ev_execution_status = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD create_pdpr_w_ref.

    TYPES:
      BEGIN OF ty_vbeln,
        vbeln TYPE vbeln,
      END OF ty_vbeln,
      ty_vbeln_tab TYPE STANDARD TABLE OF ty_vbeln WITH NON-UNIQUE KEY vbeln,
      BEGIN OF ty_pbeeflow_uuid,
        pbeeflowuuid TYPE pbee_flowuuid,
      END OF ty_pbeeflow_uuid,
      ty_pbeeflow_uuid_tab TYPE STANDARD TABLE OF ty_pbeeflow_uuid WITH NON-UNIQUE KEY pbeeflowuuid.

    DATA:
      lt_vbeln          TYPE ty_vbeln_tab,
      it_projblgelmuuid TYPE TABLE FOR ACTION IMPORT R_ProjectBillingElementTP~CrteBillgDocReqForDownPaytReq,
      ls_projblgelmuuid LIKE LINE OF it_projblgelmuuid,
      lv_failed         TYPE abap_bool VALUE abap_false,
      lt_pbeeflowuuid   TYPE ty_pbeeflow_uuid_tab,
      ls_pbeeflowuuid   LIKE LINE OF lt_pbeeflowuuid.


******************************************************************************
* Step 1: Get number of Sales Order Service
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      IF lines( lt_ptf_keys ) EQ 0.
        me->mo_run_environment->append_log( iv_log_statement = |No documents found for step { <lv_ref_step> }| ).
      ENDIF.
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    IF lines( lt_vbeln ) EQ 0.
      ev_execution_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |Nothing to check.| ).
      RETURN.
    ENDIF.


******************************************************************************
* Step 2: Get UUID of Project Billing Elements
    SELECT pbe~projectbillingelementuuid FROM projbillgelmnt AS pbe JOIN vbap
      ON pbe~billingwbselementinternalid = vbap~ps_psp_pnr
      FOR ALL ENTRIES IN @lt_vbeln
      WHERE vbap~vbeln = @lt_vbeln-vbeln
      INTO TABLE @DATA(lt_pbeuuid).


******************************************************************************
* Step 3: Create ProjectDownPaymentRequest from Project Billing Element
    LOOP AT lt_pbeuuid ASSIGNING FIELD-SYMBOL(<ls_pbeuuid>).
      ls_projblgelmuuid-projectbillingelementuuid = <ls_pbeuuid>-projectbillingelementuuid.
      APPEND ls_projblgelmuuid TO it_projblgelmuuid.
    ENDLOOP.

    MODIFY ENTITY r_projectbillingelementtp
      EXECUTE crtebillgdocreqfordownpaytreq
      FROM
      it_projblgelmuuid
      RESULT   DATA(et_pdpr_result)
      FAILED   DATA(lt_failed_data)
      REPORTED DATA(lt_reported_data).


******************************************************************************
* Step 4: Check if PDPR creation was successful
    IF et_pdpr_result IS NOT INITIAL.
      COMMIT ENTITIES
       RESPONSES
        FAILED   DATA(lt_commit_failed_data).
      IF lt_commit_failed_data IS NOT INITIAL.
        lv_failed = abap_true.
      ENDIF.
    ELSE.
      lv_failed = abap_true.
    ENDIF.

    IF lv_failed IS NOT INITIAL.
      ev_execution_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |Project Down Payment Request could not be created.| ).
      RETURN.
    ELSE.
      LOOP AT et_pdpr_result ASSIGNING FIELD-SYMBOL(<ls_pdpr_result>).
        ls_pbeeflowuuid-pbeeflowuuid = <ls_pdpr_result>-%param-projbillgelmntentritmflowuuid.
        APPEND ls_pbeeflowuuid TO lt_pbeeflowuuid.
      ENDLOOP.

      SELECT billingdocument FROM prjblgemtentrflw
        FOR ALL ENTRIES IN @lt_pbeeflowuuid
        WHERE projbillgelmntentritmflowuuid = @lt_pbeeflowuuid-pbeeflowuuid
          AND documentbillingstatus = 'A'
        INTO TABLE @DATA(lt_pdpr).

      IF lines( lt_pdpr ) < 1.
        ev_execution_status = abap_false.
        me->mo_run_environment->append_log( iv_log_statement = |No Project Down Payment Request found.| ).
        RETURN.
      ENDIF.

      me->mo_run_environment->append_log( iv_log_statement = |Project Down Payment Request has been created.| ).
      ev_document_id = lt_pdpr.
      ev_execution_status = abap_true.

    ENDIF.

  ENDMETHOD.


  METHOD create_same_preceding.
    " Negative test; Try to create two EBDRs with the same preceding document
    DATA:
      ls_bdr_request_msg    TYPE sdbil_esr_bdr_request_msg,
      lt_bdr_request_result TYPE sdbil_ebdr_request_result_t,
      ls_bdr_request_result TYPE sdbil_ebdr_request_result,
      lt_bdr_request_failed TYPE sdbil_ebdr_request_failed_t,
      lt_bdr_request_msg    TYPE sdbil_ebdr_request_msg_t,
      ls_bdr_billable_doc   TYPE sdbil_esr_bdr_billable_doc,
      ls_bdr_bllbl_doc_it   TYPE sdbil_esr_bdr_billable_doc_itm,
      ls_bdr_pricing_elem   TYPE sdbil_esr_bdr_pricing_element,
      ls_bdr_text           TYPE sdbil_esr_bdr_text,
      ls_bdr_pmt_card       TYPE sdbil_esr_bdr_payment_card,
      ls_testdata           TYPE ty_gs_i_ptf_ebdr_cr_ws_td,
      lv_counter            TYPE string VALUE 0,
      lv_found              TYPE abap_bool VALUE abap_true.

    ev_execution_status = abap_false. " assume test fails

******************************************************************************
* 1. Step: Get test data for BDR creation
******************************************************************************

* Temporary reuse of variant EBDR_CR_STANDARD
* Should be replaced by a new "GDT" version variant (or even a new Test Data Container)!
    IF step_data-variant IS NOT INITIAL.
      cl_ptf_util=>get_testdata(
        EXPORTING
          is_step_data = step_data
        IMPORTING
          es_testdata  = ls_testdata
      ).
    ENDIF.

******************************************************************************
* 2. Step: BDR Request In - Message Mapping
******************************************************************************
    IF ls_testdata-bdr_request_msg-global_parameters-reference_document_logical_sys IS NOT INITIAL.
      ls_bdr_request_msg-global_parameters-reference_document_logical_sys = ls_testdata-bdr_request_msg-global_parameters-reference_document_logical_sys.
    ENDIF.


    LOOP AT ls_testdata-bdr_request_msg-billable_document REFERENCE INTO DATA(lr_ebdr_request_in).
      lv_found = abap_true.
* Field PrecedingDocument will be filled dynmically
      WHILE lv_found = abap_true.
        ADD 1 TO lv_counter.
        CONCATENATE 'PTF' sy-datlo+2(4) lv_counter INTO ls_bdr_billable_doc-reference_document.
        SELECT SINGLE bdr_ref FROM vbrk
           WHERE bdr_ref = @ls_bdr_billable_doc-reference_document
           INTO @DATA(wa).
        IF sy-subrc IS INITIAL.
          lv_found = abap_true.
        ELSE.
          lv_found = abap_false.
        ENDIF.
      ENDWHILE.

      LOOP AT lr_ebdr_request_in->billable_document_item REFERENCE INTO DATA(lr_ebdr_request_it_in).
        ls_bdr_bllbl_doc_it-reference_document_item       = lr_ebdr_request_it_in->reference_document_item.
        ls_bdr_bllbl_doc_it-sales_document_type           = lr_ebdr_request_it_in->sales_document_type.
        ls_bdr_bllbl_doc_it-sales_document_item_category  = lr_ebdr_request_it_in->sales_document_item_category.
        ls_bdr_bllbl_doc_it-reference_document_item_text  = lr_ebdr_request_it_in->reference_document_item_text.
        ls_bdr_bllbl_doc_it-billing_document_request_type = lr_ebdr_request_it_in->billing_document_request_type.
        ls_bdr_bllbl_doc_it-sales_organization            = lr_ebdr_request_it_in->sales_organization.
        ls_bdr_bllbl_doc_it-distribution_channel          = lr_ebdr_request_it_in->distribution_channel.
        ls_bdr_bllbl_doc_it-division                      = lr_ebdr_request_it_in->division.
        ls_bdr_bllbl_doc_it-billing_document_date         = sy-datum.  "lr_ebdr_request_in->billingdate.
        ls_bdr_bllbl_doc_it-sold_to_party                 = lr_ebdr_request_it_in->sold_to_party.
        ls_bdr_bllbl_doc_it-transaction_currency          = lr_ebdr_request_it_in->transaction_currency.
        ls_bdr_bllbl_doc_it-tax_departure_country         = lr_ebdr_request_it_in->tax_departure_country.
        ls_bdr_bllbl_doc_it-material                      = lr_ebdr_request_it_in->material.
        ls_bdr_bllbl_doc_it-quantity-content              = lr_ebdr_request_it_in->quantity-content.
        ls_bdr_bllbl_doc_it-quantity-unit_code            = lr_ebdr_request_it_in->quantity-unit_code.
        ls_bdr_bllbl_doc_it-plant                         = lr_ebdr_request_it_in->plant.
        ls_bdr_bllbl_doc_it-departure_country             = lr_ebdr_request_it_in->departure_country.

        LOOP AT lr_ebdr_request_it_in->pricing_element REFERENCE INTO DATA(lr_ebdr_requ_it_cond_in).
          ls_bdr_pricing_elem-condition_type                = lr_ebdr_requ_it_cond_in->condition_type.
          ls_bdr_pricing_elem-condition_rate_value          = lr_ebdr_requ_it_cond_in->condition_rate_value.
          ls_bdr_pricing_elem-condition_currency            = lr_ebdr_requ_it_cond_in->condition_currency.
          ls_bdr_pricing_elem-condition_quantity-content    = lr_ebdr_requ_it_cond_in->condition_quantity-content.
          ls_bdr_pricing_elem-condition_quantity-unit_code  = lr_ebdr_requ_it_cond_in->condition_quantity-unit_code.
          "Pricing Element to Item
          APPEND ls_bdr_pricing_elem TO ls_bdr_bllbl_doc_it-pricing_element.
        ENDLOOP.

        LOOP AT lr_ebdr_request_it_in->text REFERENCE INTO DATA(lr_ebdr_requ_it_text_in).
          ls_bdr_text-text_element       = lr_ebdr_requ_it_text_in->text_element.
          ls_bdr_text-language           = lr_ebdr_requ_it_text_in->language.
          ls_bdr_text-text_element_text  = lr_ebdr_requ_it_text_in->text_element_text.
          "Text Element to Item
          APPEND ls_bdr_text TO ls_bdr_bllbl_doc_it-text.
          CLEAR ls_bdr_text.
        ENDLOOP.

        "Item to Document
        APPEND ls_bdr_bllbl_doc_it TO ls_bdr_billable_doc-billable_document_item.
      ENDLOOP.

      LOOP AT lr_ebdr_request_in->text REFERENCE INTO DATA(lr_ebdr_requ_text_in).
        ls_bdr_text-text_element_text  = lr_ebdr_requ_text_in->text_element. " lr_ebdr_requ_text_in->language.
        ls_bdr_text-language           = lr_ebdr_requ_text_in->language.
        ls_bdr_text-text_element_text  = lr_ebdr_requ_text_in->text_element_text.
        "Text to Document
        APPEND ls_bdr_text TO ls_bdr_billable_doc-text.
        CLEAR ls_bdr_text.
      ENDLOOP.

      LOOP AT lr_ebdr_request_in->payment_card REFERENCE INTO DATA(lr_ebdr_request_pc_in).
        ls_bdr_pmt_card-payment_card_type = lr_ebdr_request_pc_in->payment_card_type.
        ls_bdr_pmt_card-payt_card_by_digital_payment_s = lr_ebdr_request_pc_in->payt_card_by_digital_payment_s.
        ls_bdr_pmt_card-payment_card_masked_number = lr_ebdr_request_pc_in->payment_card_masked_number.
        ls_bdr_pmt_card-payment_card_validity_end_date = lr_ebdr_request_pc_in->payment_card_validity_end_date.
        ls_bdr_pmt_card-payment_card_holder_name = lr_ebdr_request_pc_in->payment_card_holder_name.
        ls_bdr_pmt_card-authorized_amount_in_authzn_cr-currency_code = lr_ebdr_request_pc_in->authorized_amount_in_authzn_cr-currency_code.
        ls_bdr_pmt_card-authorized_amount_in_authzn_cr-content = lr_ebdr_request_pc_in->authorized_amount_in_authzn_cr-content.
        ls_bdr_pmt_card-authorization_date_time = lr_ebdr_request_pc_in->authorization_date_time.
        ls_bdr_pmt_card-authorization_by_digital_payt = lr_ebdr_request_pc_in->authorization_by_digital_payt.
        ls_bdr_pmt_card-authorization_by_acquirer = lr_ebdr_request_pc_in->authorization_by_acquirer.
        ls_bdr_pmt_card-preauthorization_is_requested = lr_ebdr_request_pc_in->preauthorization_is_requested.
        "Payment Card to Document
        APPEND ls_bdr_pmt_card TO ls_bdr_billable_doc-payment_card.
        CLEAR ls_bdr_pmt_card.
      ENDLOOP.

      "Document to Message
      APPEND ls_bdr_billable_doc TO ls_bdr_request_msg-billable_document.

      "CLEAR all work areas per billable item
      CLEAR ls_bdr_billable_doc.
      CLEAR ls_bdr_bllbl_doc_it-pricing_element.
      CLEAR ls_bdr_bllbl_doc_it-text.
      CLEAR ls_bdr_billable_doc-billable_document_item.
      CLEAR ls_bdr_billable_doc-text.
    ENDLOOP.

******************************************************************************
* 3. Step: BDR Request In - Message Processing
******************************************************************************
    NEW cl_sdbil_soa_bdr_request_in( )->process(
             EXPORTING
               is_data               = ls_bdr_request_msg        " Billing Document Request Request - Data
             IMPORTING
               et_bdr_request_result = lt_bdr_request_result     " Billing Document Request Request - Result
               et_bdr_request_failed = lt_bdr_request_failed     " Billing Document Request Request - Failed
               et_bdr_request_msg    = lt_bdr_request_msg        " Billing Document Request Request - Message
      ).

******************************************************************************
* 4. Step: BDR Request Out - Message Processing
******************************************************************************

    IF lt_bdr_request_result IS NOT INITIAL OR
       lt_bdr_request_failed IS NOT INITIAL.

      NEW cl_sdbil_soa_bdr_conf_out( )->process(
             EXPORTING
               iv_system_id          = ls_bdr_request_msg-message_header-sender_business_system_id
               it_bdr_request_result = lt_bdr_request_result    " Billing Document Request Request - Result
               it_bdr_request_failed = lt_bdr_request_failed    " Billing Document Request Request - Failed
               it_bdr_request_msg    = lt_bdr_request_msg       " Billing Document Request Request - Message
             IMPORTING
               es_outbound           = DATA(ls_outbound)
           ).
    ENDIF.

******************************************************************************
* 5. Step: Check result and set success flag
******************************************************************************

    LOOP AT lt_bdr_request_result REFERENCE INTO DATA(lr_bdr_request_result).
      APPEND lr_bdr_request_result->extbillingdocrequest TO ev_document_id.
    ENDLOOP.

    IF lt_bdr_request_result IS NOT INITIAL AND
     lt_bdr_request_failed IS INITIAL.
      ev_execution_status = abap_true.
    ENDIF.


******************************************************************************
* 6. Step: Check what would happen if we try to create same ebdr again
******************************************************************************
    NEW cl_sdbil_soa_bdr_request_in( )->process(
             EXPORTING
               is_data               = ls_bdr_request_msg        " Billing Document Request Request - Data
             IMPORTING
               et_bdr_request_result = lt_bdr_request_result     " Billing Document Request Request - Result
               et_bdr_request_failed = lt_bdr_request_failed     " Billing Document Request Request - Failed
               et_bdr_request_msg    = lt_bdr_request_msg        " Billing Document Request Request - Message
      ).

    IF lt_bdr_request_failed IS INITIAL.
      ev_execution_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |Negative test failed.| ).
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |Negative test successful.| ).
      ev_execution_status = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD create_sbdr_with_odata.

    DATA: ls_testdata         TYPE ty_gs_execute_by_soap_td,
          lv_uuid             TYPE string,
          lv_msg_id           TYPE string,
          lv_msg              TYPE string,
*          lv_step_success     TYPE abap_bool,
          lv_document_id      TYPE vbeln,
          lv_status_code      TYPE integer,
          lv_status_text      TYPE string,
          lv_body             TYPE string,
          lv_soap_request_uri TYPE string,
          lv_soap_action      TYPE string,
          lv_timestamp        TYPE string.


*--> 1 Step: Get data from tdc
    DATA(ls_current_step) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_current_step
      IMPORTING
        es_testdata  = ls_testdata ).

*--> 2 Step: Prepare Soap API payload
    TRY.
        lv_uuid = cl_system_uuid=>if_system_uuid_rfc4122_static~create_uuid_c36_by_version( version = 4 ).
      CATCH cx_uuid_error.
        me->mo_run_environment->append_log( |'SOAP API: Generate massage ID failed'| ).
    ENDTRY.

    lv_msg_id = lv_uuid.
    REPLACE ALL OCCURRENCES OF '-' IN lv_msg_id WITH ''.
    TRANSLATE lv_msg_id TO UPPER CASE.

    DATA(random_number) = cl_abap_random_int=>create( seed = CONV i( sy-uzeit )
                                      min  = 1
                                      max = 10000 ).
    lv_document_id = random_number->get_next( ).
    REPLACE ALL OCCURRENCES OF '{REFERENCE_DOCUMENT}' IN ls_testdata-payload WITH lv_document_id.

    "Creation Date Time && External Doc Last Change Date Time
    lv_timestamp = utclong_current( ) .
    lv_timestamp = |{ lv_timestamp(10) }| && |T| && |{ lv_timestamp+11(8) }| && |Z|.
    REPLACE ALL OCCURRENCES OF '{CREATE_DATE_TIME}' IN ls_testdata-payload WITH lv_timestamp.


    cl_ptf_http_call=>convert_dates_in_xml( CHANGING cv_payload = ls_testdata-payload ).
    cl_ptf_http_call=>convert_partner_in_xml( CHANGING cv_payload = ls_testdata-payload ).

*--> 3 Step: Call SOAP Service base on tdc
    TRY.
        CALL METHOD ('cl_ptf_service_util')=>('call_soap_service')  "decouple from CRM Package
*        cl_ptf_service_util=>call_soap_service(
          EXPORTING
            is_testdata    = ls_testdata
            iv_request_uri = | /sap/bc/srt/scs/sap/SubscriptionBDRRequest_In?MessageId={ lv_uuid } |
            iv_soap_action = '"http://sap.com/xi/SD-BIL/SubscriptionBDRRequest_In/SubscriptionBDRRequest_InRequest"'
          IMPORTING
            ev_status_code = lv_status_code
            ev_status_text = lv_status_text
            ev_body        = lv_body.
      CATCH cx_sy_dyn_call_error INTO DATA(lx_exc_dyncall).
        me->mo_run_environment->append_log( 'SOAP call failed. Dynamic call exception: ' && lx_exc_dyncall->get_text( ) ).
        RETURN.
    ENDTRY.

    lv_msg = |API: Executed SOAP API Call for service transaction with status code { lv_status_code } and status text { lv_status_text }|.
    me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
    ev_execution_status = abap_true.

*    IF lv_status_code = 200 OR lv_status_code = 201 OR lv_status_code = 202.
*
*      "Proceed in case of positive test (no errors are exprected and object shall being created successfully);
*      "If negative test with no object created, this is indicated by component APPL_ERROR_EXPECTED in TDC-structure
*      IF ls_testdata-appl_error_expected EQ space.
*
*        DATA(lo_timer) = cl_abap_runtime=>create_hr_timer( ).
*        DATA(lv_begin) = lo_timer->get_runtime( ).
*        DATA(lv_business_type) = get_business_type( ).
*
*        WHILE ( ls_service_transaction-object_id IS INITIAL ).
*          SELECT SINGLE object_id FROM crms4d_ext_ref INTO @lv_document_id WHERE reference_number = @lv_msg_id.
*          SELECT SINGLE * FROM crms4d_serv_h INTO @ls_service_transaction
*            WHERE objtype_h = @lv_business_type AND object_id = @lv_document_id.
*
*          IF sy-subrc = 0.
*            ev_execution_status = abap_true.
*            APPEND lv_document_id TO ev_document_id.
*            me->mo_run_environment->append_log( iv_log_statement = |SOAP API: The Service transaction { lv_document_id } created successful. | ).
*            EXIT.
*          ENDIF.
*
*          DATA(lv_end)   = lo_timer->get_runtime( ).
*          DATA(lv_dur) = ( lv_end - lv_begin ) / 1000000.
*          IF lv_dur >= ls_testdata-max_wait_time.
*            lv_msg = |Reached the maximum waiting time { ls_testdata-max_wait_time } seconds, please check messsage id { lv_msg_id } in T-code SRT_MONI |.
*            me->mo_run_environment->append_log( lv_msg ).
*            EXIT.
*          ENDIF.
*
*          WAIT UP TO 1 SECONDS.
*        ENDWHILE.
*
**       Wait extra 10 seconds to make sure generated document is unlock.
*        WAIT UP TO 10 SECONDS.
*
*      ELSE.
*
*        "Error(s) expected -> make sure no object has been created
*        WAIT UP TO ls_testdata-max_wait_time SECONDS.
*        SELECT SINGLE object_id FROM crms4d_ext_ref INTO @lv_document_id WHERE reference_number = @lv_msg_id.
*
*        IF sy-subrc NE 0.
*          ev_execution_status = abap_true.
*
**         Return the external reference Id as the PFT-key to make it available for subsequent check-action that processes the confirmation message(s)
*          APPEND lv_msg_id TO ev_document_id.
*        ELSE.
*          lv_msg = |SOAP API: Failure, Service Order with object ID { lv_document_id } has been created. |.
*        ENDIF.
*
*        IF lv_msg IS NOT INITIAL.
*          me->mo_run_environment->append_log( lv_msg ).
*        ENDIF.
*
*      ENDIF.
*
*    ELSE.
*
*      me->mo_run_environment->append_log( iv_log_statement = |API: Error calling SOAP Service: { lv_soap_request_uri } : { lv_status_code } : { lv_status_text }.| ).
*
*    ENDIF.

  ENDMETHOD.


  METHOD create_via_excel.
    TYPES: BEGIN OF string_string_map,
             c1 TYPE string,
             c2 TYPE string,
           END OF string_string_map.
    DATA: test_data                  TYPE cl_ptf_bo_ebdr=>ty_gs_i_ptf_ebdr_cr_excel_td,
          ls_ebdr_request_ctrl       TYPE sdbil_ebdr_request_ctrl,
          ls_ebdr_admin              TYPE sdbil_ebdr_request_admin,
          lt_ebdr_request            TYPE sdbil_ebdr_request_t,
          lt_ebdr_request_cond       TYPE sdbil_ebdr_request_cond_t,
          lt_ebdr_request_text       TYPE sdbil_ebdr_request_text_t,
          lt_payment_card            TYPE sdbil_payment_card_t,
          lv_log_message             TYPE string,
          lt_return                  TYPE bapiret2_t,
          map_excel_number_to_random TYPE STANDARD TABLE OF string_string_map WITH KEY primary_key COMPONENTS c1,
          ran_int                    TYPE qf00-ran_int.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata = test_data
    ).

    cl_sd_bil_ebdr_xlsx=>get_instance( )->get_data_from_xstring(
      EXPORTING
        iv_file_content = test_data-excel
        iv_collect_all_errors = abap_false       " Don't raise exception on error, just add to return table
      IMPORTING
        es_ebdr_admin         = ls_ebdr_admin                 " External Billing Document Request - Request - Admin
        et_ebdr_request       = lt_ebdr_request                 " External Billing Document Request - Request
        et_ebdr_request_cond  = lt_ebdr_request_cond                 " External Billing Document Request - Request - Condition
        et_ebdr_request_text  = lt_ebdr_request_text                 " External Billing Document Request - Request - Text
        et_payment_card       = lt_payment_card                 " Billing - Payment Card
        et_return             = lt_return                 " Return parameter table
      EXCEPTIONS
        internal_error        = 1
        conversion_error      = 2
        template_error        = 3
        OTHERS                = 4
    ).
    IF sy-subrc <> 0.
      ev_execution_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |Error occured. sy-subrc = { sy-subrc }| ).
      LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<msg>).
        me->mo_run_environment->append_log_structure( is_log = <msg> ).
      ENDLOOP.
    ENDIF.

    "set random preceding document numbers
    LOOP AT lt_ebdr_request_cond ASSIGNING FIELD-SYMBOL(<ebdr_cond>).
      TRY.
          DATA(random_number) = map_excel_number_to_random[ c1 = <ebdr_cond>-precedingdocument ]-c2.
        CATCH cx_root.
          DO 2 TIMES.
            CALL FUNCTION 'QF05_RANDOM_INTEGER'
              EXPORTING
                ran_int_max   = 9999
                ran_int_min   = 1000
              IMPORTING
                ran_int       = ran_int
              EXCEPTIONS
                invalid_input = 1
                OTHERS        = 2.
          ENDDO.

          random_number = |{ ran_int }{ sy-uzeit }|.
          APPEND VALUE #( c1 = <ebdr_cond>-precedingdocument c2 = random_number ) TO map_excel_number_to_random.

      ENDTRY.

      <ebdr_cond>-precedingdocument = random_number.
    ENDLOOP.

    LOOP AT lt_ebdr_request_text ASSIGNING FIELD-SYMBOL(<ebdr_text>).
      TRY.
          random_number = map_excel_number_to_random[ c1 = <ebdr_text>-precedingdocument ]-c2.
        CATCH cx_root.
          DO 2 TIMES.
            CALL FUNCTION 'QF05_RANDOM_INTEGER'
              EXPORTING
                ran_int_max   = 9999
                ran_int_min   = 1000
              IMPORTING
                ran_int       = ran_int
              EXCEPTIONS
                invalid_input = 1
                OTHERS        = 2.
          ENDDO.

          random_number = |{ ran_int }{ sy-uzeit }|.
          APPEND VALUE #( c1 = <ebdr_text>-precedingdocument c2 = random_number ) TO map_excel_number_to_random.

      ENDTRY.

      <ebdr_text>-precedingdocument = random_number.
    ENDLOOP.

    LOOP AT lt_payment_card ASSIGNING FIELD-SYMBOL(<ebdr_pay>).
      TRY.
          random_number = map_excel_number_to_random[ c1 = <ebdr_pay>-precedingdocument ]-c2.
        CATCH cx_root.
          DO 2 TIMES.
            CALL FUNCTION 'QF05_RANDOM_INTEGER'
              EXPORTING
                ran_int_max   = 9999
                ran_int_min   = 1000
              IMPORTING
                ran_int       = ran_int
              EXCEPTIONS
                invalid_input = 1
                OTHERS        = 2.
          ENDDO.

          random_number = |{ ran_int }{ sy-uzeit }|.
          APPEND VALUE #( c1 = <ebdr_pay>-precedingdocument c2 = random_number ) TO map_excel_number_to_random.

      ENDTRY.

      <ebdr_pay>-precedingdocument = random_number.
    ENDLOOP.

    LOOP AT lt_ebdr_request ASSIGNING FIELD-SYMBOL(<ebdr_request>).
      TRY.
          random_number = map_excel_number_to_random[ c1 = <ebdr_request>-precedingdocument ]-c2.
        CATCH cx_root.
          DO 2 TIMES.
            CALL FUNCTION 'QF05_RANDOM_INTEGER'
              EXPORTING
                ran_int_max   = 9999
                ran_int_min   = 1000
              IMPORTING
                ran_int       = ran_int
              EXCEPTIONS
                invalid_input = 1
                OTHERS        = 2.
          ENDDO.

          random_number = |{ ran_int }{ sy-uzeit }|.
          APPEND VALUE #( c1 = <ebdr_request>-precedingdocument c2 = random_number ) TO map_excel_number_to_random.

      ENDTRY.

      <ebdr_request>-precedingdocument = random_number.
    ENDLOOP.


    IF lt_ebdr_request IS NOT INITIAL.
      IF lt_return IS INITIAL.
        ls_ebdr_request_ctrl-commit_mode = '1'. " Asynchronous mode
        CALL METHOD cl_sd_bil_ebdr_facade_ext=>if_sd_bil_ebdr_action_ext~create_from_data
          EXPORTING
            is_ebdr_request_ctrl   = ls_ebdr_request_ctrl
            is_ebdr_admin          = ls_ebdr_admin
            it_ebdr_request        = lt_ebdr_request
            it_ebdr_request_cond   = lt_ebdr_request_cond
            it_ebdr_request_text   = lt_ebdr_request_text
            it_payment_card        = lt_payment_card
          IMPORTING
            et_ebdr                = DATA(lt_ebdr_ids)
            et_ebdr_request_result = DATA(lt_success_ebdrs)          " External Billing Document Request - Request - Result
            et_ebdr_request_failed = DATA(lt_failed_ebdrs)
            et_ebdr_request_msg    = DATA(lt_ebdr_request_msg).

        LOOP AT lt_ebdr_request_msg ASSIGNING FIELD-SYMBOL(<ls_request_msg>).
          MOVE <ls_request_msg>-systemmessagetext TO lv_log_message.
          me->mo_run_environment->append_log( iv_log_statement =  lv_log_message ).
        ENDLOOP.

        IF lt_failed_ebdrs IS INITIAL.
          IF lines( lt_success_ebdrs ) = lines( lt_ebdr_request ).
            ev_execution_status = abap_true.
            APPEND LINES OF lt_ebdr_ids TO ev_document_id.
          ELSE.
            ev_execution_status = abap_false.
            me->mo_run_environment->append_log( iv_log_statement =  'Number of input and created data do not match.' ).
          ENDIF.
        ELSE.
          ev_execution_status = abap_false.
          LOOP AT lt_failed_ebdrs ASSIGNING FIELD-SYMBOL(<ls_failed_ebdrs>).
            me->mo_run_environment->append_log( iv_log_statement =  |No BDR document was created for precedingdocument: { <ls_failed_ebdrs>-precedingdocument }.| ).
          ENDLOOP.
          APPEND LINES OF lt_ebdr_ids TO ev_document_id.
        ENDIF.

      ENDIF.
    ENDIF.


  ENDMETHOD.


  METHOD create_with_web_service.
    DATA:
      ls_bdr_request_msg    TYPE sdbil_esr_bdr_request_msg,
      lt_bdr_request_result TYPE sdbil_ebdr_request_result_t,
      ls_bdr_request_result TYPE sdbil_ebdr_request_result,
      lt_bdr_request_failed TYPE sdbil_ebdr_request_failed_t,
      lt_bdr_request_msg    TYPE sdbil_ebdr_request_msg_t,
      ls_bdr_billable_doc   TYPE sdbil_esr_bdr_billable_doc,
      ls_bdr_bllbl_doc_it   TYPE sdbil_esr_bdr_billable_doc_itm,
      ls_bdr_pricing_elem   TYPE sdbil_esr_bdr_pricing_element,
      ls_bdr_text           TYPE sdbil_esr_bdr_text,
      ls_bdr_pmt_card       TYPE sdbil_esr_bdr_payment_card,
      ls_testdata           TYPE ty_gs_i_ptf_ebdr_cr_ws_td,
      lv_counter            TYPE string VALUE 0,
      lv_found              TYPE abap_bool VALUE abap_true.

    FIELD-SYMBOLS: <field>          TYPE any.


    ev_execution_status = abap_false. " assume test fails

******************************************************************************
* 1. Step: Get test data for BDR creation
******************************************************************************

* Temporary reuse of variant EBDR_CR_STANDARD
* Should be replaced by a new "GDT" version variant (or even a new Test Data Container)!
    IF step_data-variant IS NOT INITIAL.
      cl_ptf_util=>get_testdata(
        EXPORTING
          is_step_data = step_data
        IMPORTING
          es_testdata  = ls_testdata
      ).
    ENDIF.

******************************************************************************
* 2. Step: BDR Request In - Message Mapping
******************************************************************************
    IF ls_testdata-bdr_request_msg-global_parameters-reference_document_logical_sys IS NOT INITIAL.
      ls_bdr_request_msg-global_parameters-reference_document_logical_sys = ls_testdata-bdr_request_msg-global_parameters-reference_document_logical_sys.
    ENDIF.


    LOOP AT ls_testdata-bdr_request_msg-billable_document REFERENCE INTO DATA(lr_ebdr_request_in).
      lv_found = abap_true.
* Field PrecedingDocument will be filled dynmically
      WHILE lv_found = abap_true.
        ADD 1 TO lv_counter.
        CONCATENATE 'PTF' sy-datlo+2(4) lv_counter INTO ls_bdr_billable_doc-reference_document.
        SELECT SINGLE bdr_ref FROM vbrk
           WHERE bdr_ref = @ls_bdr_billable_doc-reference_document
           INTO @DATA(wa).
        IF sy-subrc IS INITIAL.
          lv_found = abap_true.
        ELSE.
          lv_found = abap_false.
        ENDIF.
      ENDWHILE.

      LOOP AT lr_ebdr_request_in->billable_document_item REFERENCE INTO DATA(lr_ebdr_request_it_in).
        ls_bdr_bllbl_doc_it-reference_document_item       = lr_ebdr_request_it_in->reference_document_item.
        ls_bdr_bllbl_doc_it-sales_document_type           = lr_ebdr_request_it_in->sales_document_type.
        ls_bdr_bllbl_doc_it-sales_document_item_category  = lr_ebdr_request_it_in->sales_document_item_category.
        ls_bdr_bllbl_doc_it-reference_document_item_text  = lr_ebdr_request_it_in->reference_document_item_text.
        ls_bdr_bllbl_doc_it-billing_document_request_type = lr_ebdr_request_it_in->billing_document_request_type.
        ls_bdr_bllbl_doc_it-sales_organization            = lr_ebdr_request_it_in->sales_organization.
        ls_bdr_bllbl_doc_it-distribution_channel          = lr_ebdr_request_it_in->distribution_channel.
        ls_bdr_bllbl_doc_it-division                      = lr_ebdr_request_it_in->division.
        ls_bdr_bllbl_doc_it-billing_document_date         = sy-datum.  "lr_ebdr_request_in->billingdate.
        ls_bdr_bllbl_doc_it-sold_to_party                 = lr_ebdr_request_it_in->sold_to_party.
        ls_bdr_bllbl_doc_it-transaction_currency          = lr_ebdr_request_it_in->transaction_currency.
        ls_bdr_bllbl_doc_it-tax_departure_country         = lr_ebdr_request_it_in->tax_departure_country.
        ls_bdr_bllbl_doc_it-material                      = lr_ebdr_request_it_in->material.
        ls_bdr_bllbl_doc_it-quantity-content              = lr_ebdr_request_it_in->quantity-content.
        ls_bdr_bllbl_doc_it-quantity-unit_code            = lr_ebdr_request_it_in->quantity-unit_code.
        ls_bdr_bllbl_doc_it-plant                         = lr_ebdr_request_it_in->plant.
        ls_bdr_bllbl_doc_it-departure_country             = lr_ebdr_request_it_in->departure_country.

        IF ls_testdata-ext_fields IS NOT INITIAL.
          LOOP AT ls_testdata-ext_fields ASSIGNING FIELD-SYMBOL(<ext_field>).
            ASSIGN COMPONENT <ext_field>-name OF STRUCTURE ls_bdr_bllbl_doc_it TO <field>.
            IF <field> IS ASSIGNED.
              <field> = <ext_field>-expected_input.
            ENDIF.
            UNASSIGN <field>.
          ENDLOOP.
        ENDIF.

        LOOP AT lr_ebdr_request_it_in->pricing_element REFERENCE INTO DATA(lr_ebdr_requ_it_cond_in).
          ls_bdr_pricing_elem-condition_type                = lr_ebdr_requ_it_cond_in->condition_type.
          ls_bdr_pricing_elem-condition_rate_value          = lr_ebdr_requ_it_cond_in->condition_rate_value.
          ls_bdr_pricing_elem-condition_currency            = lr_ebdr_requ_it_cond_in->condition_currency.
          ls_bdr_pricing_elem-condition_quantity-content    = lr_ebdr_requ_it_cond_in->condition_quantity-content.
          ls_bdr_pricing_elem-condition_quantity-unit_code  = lr_ebdr_requ_it_cond_in->condition_quantity-unit_code.
          "Pricing Element to Item
          APPEND ls_bdr_pricing_elem TO ls_bdr_bllbl_doc_it-pricing_element.
        ENDLOOP.

        LOOP AT lr_ebdr_request_it_in->text REFERENCE INTO DATA(lr_ebdr_requ_it_text_in).
          ls_bdr_text-text_element       = lr_ebdr_requ_it_text_in->text_element.
          ls_bdr_text-language           = lr_ebdr_requ_it_text_in->language.
          ls_bdr_text-text_element_text  = lr_ebdr_requ_it_text_in->text_element_text.
          "Text Element to Item
          APPEND ls_bdr_text TO ls_bdr_bllbl_doc_it-text.
          CLEAR ls_bdr_text.
        ENDLOOP.

        "Item to Document
        APPEND ls_bdr_bllbl_doc_it TO ls_bdr_billable_doc-billable_document_item.
      ENDLOOP.

      LOOP AT lr_ebdr_request_in->text REFERENCE INTO DATA(lr_ebdr_requ_text_in).
        ls_bdr_text-text_element_text  = lr_ebdr_requ_text_in->text_element. " lr_ebdr_requ_text_in->language.
        ls_bdr_text-language           = lr_ebdr_requ_text_in->language.
        ls_bdr_text-text_element_text  = lr_ebdr_requ_text_in->text_element_text.
        "Text to Document
        APPEND ls_bdr_text TO ls_bdr_billable_doc-text.
        CLEAR ls_bdr_text.
      ENDLOOP.

      LOOP AT lr_ebdr_request_in->payment_card REFERENCE INTO DATA(lr_ebdr_request_pc_in).
        ls_bdr_pmt_card-payment_card_type = lr_ebdr_request_pc_in->payment_card_type.
        ls_bdr_pmt_card-payt_card_by_digital_payment_s = lr_ebdr_request_pc_in->payt_card_by_digital_payment_s.
        ls_bdr_pmt_card-payment_card_masked_number = lr_ebdr_request_pc_in->payment_card_masked_number.
        ls_bdr_pmt_card-payment_card_validity_end_date = lr_ebdr_request_pc_in->payment_card_validity_end_date.
        ls_bdr_pmt_card-payment_card_holder_name = lr_ebdr_request_pc_in->payment_card_holder_name.
        ls_bdr_pmt_card-authorized_amount_in_authzn_cr-currency_code = lr_ebdr_request_pc_in->authorized_amount_in_authzn_cr-currency_code.
        ls_bdr_pmt_card-authorized_amount_in_authzn_cr-content = lr_ebdr_request_pc_in->authorized_amount_in_authzn_cr-content.
        ls_bdr_pmt_card-authorization_date_time = lr_ebdr_request_pc_in->authorization_date_time.
        ls_bdr_pmt_card-authorization_by_digital_payt = lr_ebdr_request_pc_in->authorization_by_digital_payt.
        ls_bdr_pmt_card-authorization_by_acquirer = lr_ebdr_request_pc_in->authorization_by_acquirer.
        ls_bdr_pmt_card-preauthorization_is_requested = lr_ebdr_request_pc_in->preauthorization_is_requested.
        ls_bdr_pmt_card-payment_by_payment_service_prv = lr_ebdr_request_pc_in->payment_by_payment_service_prv.
        ls_bdr_pmt_card-transaction_by_payt_srvc_prvdr = lr_ebdr_request_pc_in->transaction_by_payt_srvc_prvdr.
        ls_bdr_pmt_card-payment_card_validity_start_da = lr_ebdr_request_pc_in->payment_card_validity_start_da.
        ls_bdr_pmt_card-payment_service_provider       = lr_ebdr_request_pc_in->payment_service_provider.

        "Payment Card to Document
        APPEND ls_bdr_pmt_card TO ls_bdr_billable_doc-payment_card.
        CLEAR ls_bdr_pmt_card.
      ENDLOOP.

      "Document to Message
      APPEND ls_bdr_billable_doc TO ls_bdr_request_msg-billable_document.

      "CLEAR all work areas per billable item
      CLEAR ls_bdr_billable_doc.
      CLEAR ls_bdr_bllbl_doc_it-pricing_element.
      CLEAR ls_bdr_bllbl_doc_it-text.
      CLEAR ls_bdr_billable_doc-billable_document_item.
      CLEAR ls_bdr_billable_doc-text.
    ENDLOOP.

******************************************************************************
* 3. Step: BDR Request In - Message Processing
******************************************************************************

    NEW cl_sdbil_soa_bdr_request_in( )->process(
             EXPORTING
               is_data               = ls_bdr_request_msg        " Billing Document Request Request - Data
             IMPORTING
               et_bdr_request_result = lt_bdr_request_result     " Billing Document Request Request - Result
               et_bdr_request_failed = lt_bdr_request_failed     " Billing Document Request Request - Failed
               et_bdr_request_msg    = lt_bdr_request_msg        " Billing Document Request Request - Message
      ).
    IF lt_bdr_request_failed IS NOT INITIAL.
      mo_run_environment->append_log( |There are failed records.| ).
    ELSEIF lt_bdr_request_result IS INITIAL.
      mo_run_environment->append_log( |BDR Request In: Empty result.| ).
    ENDIF.
    IF lt_bdr_request_failed IS NOT INITIAL
      OR lt_bdr_request_result IS INITIAL.
      LOOP AT lt_bdr_request_msg INTO DATA(ls_msg).
        mo_run_environment->append_log( CONV #( ls_msg-systemmessagetext ) ).
      ENDLOOP.
    ENDIF.

******************************************************************************
* 4. Step: BDR Request Out - Message Processing
******************************************************************************

    IF lt_bdr_request_result IS NOT INITIAL OR
       lt_bdr_request_failed IS NOT INITIAL.

      NEW cl_sdbil_soa_bdr_conf_out( )->process(
             EXPORTING
               iv_system_id          = ls_bdr_request_msg-message_header-sender_business_system_id
               it_bdr_request_result = lt_bdr_request_result    " Billing Document Request Request - Result
               it_bdr_request_failed = lt_bdr_request_failed    " Billing Document Request Request - Failed
               it_bdr_request_msg    = lt_bdr_request_msg       " Billing Document Request Request - Message
             IMPORTING
               es_outbound           = DATA(ls_outbound)
           ).
    ENDIF.

******************************************************************************
* 5. Step: Check result and set success flag
******************************************************************************

    LOOP AT lt_bdr_request_result REFERENCE INTO DATA(lr_bdr_request_result).
      APPEND lr_bdr_request_result->extbillingdocrequest TO ev_document_id.
    ENDLOOP.

    IF lt_bdr_request_result IS NOT INITIAL AND
     lt_bdr_request_failed IS INITIAL.
      ev_execution_status = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD delete.

    DATA lt_ebdr_del           TYPE if_sd_bil_type_def_ext=>tt_extbillingdocrequest.
    DATA ls_ebdr_del           TYPE if_sd_bil_type_def_ext=>ty_extbillingdocrequest.
    DATA lt_ebdr_deleted      TYPE if_sd_bil_type_def_ext=>tt_extbillingdocrequest.
    DATA lt_ebdr_delete_failed TYPE if_sd_bil_type_def_ext=>tt_extbillingdocrequest.
    DATA lt_message_delete   TYPE sdbil_ebdr_request_msg_t.

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).

    LOOP AT ls_step_data-reference_step INTO DATA(lv_prestepnumber).
      DATA(ls_check_step_data) = me->mo_run_environment->get_step_data( iv_step_number = lv_prestepnumber ).
      IF ls_check_step_data-document_id IS INITIAL.
        ev_execution_status = abap_false.
        me->mo_run_environment->append_log( iv_log_statement = |SEF: NO REFERENCE document exists!| ).
        "me->mo_run_environment->append_log( iv_log_statement = |Test stopped.| ).
        "=>set_stop_run_after_step( abap_true ).
        RETURN.
      ELSE.

        LOOP AT ls_check_step_data-document_id INTO DATA(ls_document_id).
          ls_ebdr_del-extbillingdocrequest = ls_document_id-vbeln.
          APPEND ls_ebdr_del TO lt_ebdr_del.
          CLEAR ls_ebdr_del.
        ENDLOOP.
      ENDIF.
    ENDLOOP.


    cl_sd_bil_ebdr_facade_ext=>if_sd_bil_ebdr_access_ext~delete(
    EXPORTING
      it_ebdr                = lt_ebdr_del
      iv_commit_mode         = '2'
    IMPORTING
      et_ebdr_deleted       = lt_ebdr_deleted
      et_ebdr_delete_failed  = lt_ebdr_delete_failed
      et_message             = lt_message_delete ).

    IF lt_ebdr_delete_failed IS NOT INITIAL.

      ev_execution_status = abap_false.

      LOOP AT lt_ebdr_delete_failed INTO DATA(ls_ebdr_delete_failed).
        APPEND ls_ebdr_delete_failed-extbillingdocrequest  TO ev_document_id.
        me->mo_run_environment->append_log( iv_log_statement = |BDR: { ls_ebdr_delete_failed-extbillingdocrequest } Deletion failed.| ) .
      ENDLOOP.

    ELSE.

      ev_execution_status = abap_true.

      LOOP AT lt_ebdr_deleted INTO DATA(ls_ebdr_deleted).
        APPEND ls_ebdr_deleted-extbillingdocrequest  TO ev_document_id.
        me->mo_run_environment->append_log( iv_log_statement = |BDR: { ls_ebdr_deleted-extbillingdocrequest } Deletion successful.| ) .
      ENDLOOP.

    ENDIF.
  ENDMETHOD.


  METHOD delete_with_odata.
    DATA: lt_messages TYPE sdbil_ebdr_request_msg_t.
    me->odata_function_import(
      EXPORTING
        iv_function_name    = _mc_function_delete
        cs_step_data        = step_data
      IMPORTING
        et_function_return  = lt_messages
        ev_document_id      = ev_document_id
        ev_execution_status = ev_execution_status
        ev_check_status     = ev_check_status
    ).
    LOOP AT lt_messages ASSIGNING FIELD-SYMBOL(<ls_message>).
      me->mo_run_environment->append_log( iv_log_statement = |{ <ls_message>-systemmessagetext }| ).
    ENDLOOP.

  ENDMETHOD.


  METHOD execute_action.

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    CASE ls_step_data-action.
      WHEN c_create_via_excel.
        me->create_via_excel(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_api_odata_del_fi_del_neg.   "constant value DEVIATES from method name
        me->api_odata_delete_fi_delete_neg(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_api_odata_rej_fi_neg.   "constant value DEVIATES from method name
        me->api_odata_post_fi_reject_neg(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_create_multiple.
        me->create_multiple(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_odata_get_bd.   "constant value DEVIATES from method name       " Get BillDoc in EBDR? is this a copy error?
        me->api_odata_get_fi_bd(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_odata_post_cancel_bd.   "constant value DEVIATES from method name  "BilDoc cancel in EBDR? is this a copy error?
        me->api_post_fi_cancel_bd(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_create_negative.   "constant value DEVIATES from method name
        me->create_for_negative_testing(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_create_same_preceding.
        me->create_same_preceding(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_create_with_reference.
        me->create_from_order(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_create_with_web_service.
        me->create_with_web_service(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_reject_with_odata.
        me->reject_with_odata(
              EXPORTING
                step_data           = ls_step_data
                iv_step_number      = iv_step_number
              IMPORTING
                ev_document_id      = ev_document_id
                ev_execution_status = ev_execution_status
                ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_delete_with_odata.
        me->delete_with_odata(
              EXPORTING
                step_data           = ls_step_data
                iv_step_number      = iv_step_number
              IMPORTING
                ev_document_id      = ev_document_id
                ev_execution_status = ev_execution_status
                ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_odata_f2337_get.
        me->odata_f2337_get(
              EXPORTING
                step_data           = ls_step_data
                iv_step_number      = iv_step_number
              IMPORTING
                ev_document_id      = ev_document_id
                ev_execution_status = ev_execution_status
                ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_odata_bdr_get.  "constant value DEVIATES from method name
        me->api_odata_get_bdr(
              EXPORTING
                step_data           = ls_step_data
                iv_step_number      = iv_step_number
              IMPORTING
                ev_document_id      = ev_document_id
                ev_execution_status = ev_execution_status
                ev_check_status     = ev_check_status
            ).

        RETURN.
      WHEN c_api_odata_delete_fi_delete. "constant value DEVIATES from method name
        me->api_odata_delete_fi_delete(
              EXPORTING
                step_data           = ls_step_data
                iv_step_number      = iv_step_number
              IMPORTING
                ev_document_id      = ev_document_id
                ev_execution_status = ev_execution_status
                ev_check_status     = ev_check_status
            ).
        RETURN.
      WHEN 'ODATA_BDR_FI_REJECT'.  "value DEVIATES from method name
        me->api_odata_post_fi_reject(
              EXPORTING
                step_data           = ls_step_data
                iv_step_number      = iv_step_number
              IMPORTING
                ev_document_id      = ev_document_id
                ev_execution_status = ev_execution_status
                ev_check_status     = ev_check_status
            ).
        RETURN.
      WHEN c_create_pbdr_w_ref.
        me->create_pbdr_w_ref(
              EXPORTING
                step_data           = ls_step_data
                iv_step_number      = iv_step_number
              IMPORTING
                ev_document_id      = ev_document_id
                ev_execution_status = ev_execution_status
                ev_check_status     = ev_check_status
            ).
        RETURN.

      WHEN c_action_lock.
        lock(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number  "optional. not used. for symmetry.
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.

      WHEN c_action_unlock.
        unlock(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number  "optional. not used. for symmetry.
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.

      WHEN c_reject.
        reject(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.

      WHEN c_create_pdpr_w_ref.
        me->create_pdpr_w_ref(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.

      WHEN c_wait.
        me->wait(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.

      WHEN c_create_sbdr.
        me->create_sbdr_with_odata(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.

      WHEN C_CREATE_EBDR_ICO.
        me->create_ebdr_ico(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.

      WHEN OTHERS.
        me->mo_run_environment->append_log( iv_log_statement =  |Could not find method { ls_step_data-action } for the BO { ls_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.
    ENDCASE.

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

    ELSE.

      "2. If there is a method with the same name as the action, call it
      DATA(lo_description) = CAST cl_abap_classdescr( cl_abap_typedescr=>describe_by_object_ref( me ) ).
      READ TABLE lo_description->methods WITH TABLE KEY primary_key COMPONENTS name = ls_step_data-action INTO DATA(ls).
      IF sy-subrc IS INITIAL.
        TRY.
            CALL METHOD me->(ls_step_data-action)
              EXPORTING
                step_data           = ls_step_data
                iv_step_number      = iv_step_number
              IMPORTING
                ev_document_id      = ev_document_id
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
*          me->mo_run_environment->append_log( iv_log_statement = |Couldn't find the method { ls_step_data-action } for BO { ls_step_data-bus_obj }| ).
            me->mo_run_environment->append_log( iv_log_statement = |Dynamic call out of { lv_method }, based on action name { ls_step_data-action }, failed. { cl_abap_classdescr=>get_class_name( me ) }| ).
            ev_execution_status = abap_false.
            ev_check_status = abap_false.
        ENDTRY.

        RETURN.

      ENDIF.

    ENDIF.

    "3. Use implemented calls, as PTFBOA-ABAP_METHOD is empty and there is also no method with the same name as the action

** No need to add new actions here anymore: Just name your Method like the Action, and it will be called automatically by the generic call above. **

    CASE ls_step_data-action.

*      WHEN c_check_with_odata.                     "all action calls should works generically now, implemented calls are not needed, not reached
*        me->check_with_odata(
*          EXPORTING
*            step_data           = ls_step_data
*            iv_step_number      = iv_step_number
*          IMPORTING
*            ev_document_id      = ev_document_id
*            ev_execution_status = ev_execution_status
*            ev_check_status     = ev_check_status
*        ).
*        RETURN.

        "No need to check pricing result for accounting indicator adaptation at present.       "had always been commented, there is also no PTFBOA entry => method is never called
*      WHEN c_check_conditions_exist.
*        me->check_conditions_exist(
*          EXPORTING
*            step_data           = ls_step_data
*            iv_step_number      = iv_step_number
*          IMPORTING
*            ev_document_id      = ev_document_id
*            ev_execution_status = ev_execution_status
*            ev_check_status     = ev_check_status
*        ).
*        RETURN.

** No need to add new actions here anymore: Just name your Method like the Action, and it will be called automatically by the generic call above. **
**  Note: Make sure that the signature of your method is the same as in the generic call.

      WHEN OTHERS.
        me->mo_run_environment->append_log( iv_log_statement =  |Could not find a method for { ls_step_data-action } of BO { ls_step_data-bus_obj }.| ). "changed text
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.
    ENDCASE.

  ENDMETHOD.


  METHOD get_order_number.
    CLEAR et_order_number.
    IF cs_step_data-reference_step IS NOT INITIAL.
      LOOP AT cs_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
*        READ TABLE ct_step_data ASSIGNING FIELD-SYMBOL(<ls_ref_step_data>) WITH KEY var_step = <lv_ref_step>.
        DATA(ls_ref_step_data) = me->mo_run_environment->get_step_data( iv_step_number = <lv_ref_step> ).
        IF sy-subrc = 0.
*         There is at least a reference step
*         Check if it is a document create
          IF ls_ref_step_data-bus_obj <> 'EBDR' AND ls_ref_step_data-action(6) = 'CREATE'.
            APPEND LINES OF ls_ref_step_data-document_id TO et_order_number.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD keeping_lock_task.

    CHECK p_task EQ 'PTF_EBDR'.
    IF mv_locked_async EQ 'R'. " lock requested
      RECEIVE RESULTS FROM FUNCTION 'SD_DOC_LOCK' KEEPING TASK
                          IMPORTING
                            ev_executed = mv_locked_async
                          EXCEPTIONS
                              system_failure        = 1
                              communication_failure = 2
                              resource_failure      = 3.
    ENDIF.
    IF mv_unlocked_async EQ 'R'. " unlock requested
      RECEIVE RESULTS FROM FUNCTION 'SD_DOC_UNLOCK' KEEPING TASK
                          IMPORTING
                            ev_executed = mv_unlocked_async
                          EXCEPTIONS
                              system_failure        = 1
                              communication_failure = 2
                              resource_failure      = 3.
    ENDIF.

  ENDMETHOD.


  METHOD lock.

    DATA lv_vbeln TYPE vbeln.

    CLEAR:
      ev_check_status,
      ev_execution_status,
      ev_document_id.

    mv_locked_async = 'R'. " Lock requested

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_step>).
      DATA(ls_step) = me->mo_run_environment->get_step_data( iv_step_number = <ls_step> ).
      LOOP AT ls_step-document_id ASSIGNING FIELD-SYMBOL(<lv_docid>).
        lv_vbeln = <lv_docid>.

        CALL FUNCTION 'SD_DOC_LOCK' STARTING NEW TASK 'PTF_EBDR' CALLING cl_ptf_bo_ebdr=>keeping_lock_task ON END OF TASK
          EXPORTING
            iv_vbtyp              = if_sd_doc_category=>ext_billing_doc_request
            iv_vbeln              = lv_vbeln
          EXCEPTIONS
            system_failure        = 1
            communication_failure = 2
            resource_failure      = 3.

        WAIT FOR ASYNCHRONOUS TASKS UNTIL mv_locked_async EQ abap_true " lock is set
                                       UP TO 10 SECONDS.
        IF mv_locked_async EQ abap_true.
          ev_execution_status = abap_true.
        ENDIF.
        INSERT <lv_docid> INTO TABLE ev_document_id.
      ENDLOOP.
    ENDLOOP.

    CLEAR mv_locked_async.

  ENDMETHOD.


  METHOD map_order_data.
    DATA:
      lt_vbak              TYPE TABLE OF vbak,
      lt_vbap              TYPE TABLE OF vbap,
      lt_vbpa              TYPE SORTED TABLE OF vbpa WITH UNIQUE KEY vbeln parvw posnr,
      lt_vbkd              TYPE SORTED TABLE OF vbkd WITH UNIQUE KEY vbeln posnr,
      ls_prev_auart        TYPE vbak-auart,
      lt_fkart_bdr         TYPE TABLE OF tvfk-fkart,
      lt_tvcpf             TYPE SORTED TABLE OF tvcpf WITH UNIQUE KEY pstyv fkarn,
      ls_komk              TYPE komk,
      lt_komv              TYPE STANDARD TABLE OF komv,
      ls_ebdr_request      TYPE sdbil_ebdr_request,
      ls_ebdr_internal     TYPE komfkgn,
      ls_ebdr_request_cond TYPE sdbil_ebdr_request_cond,
      ls_return            TYPE bapiret2.
    IF it_order_number IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = 'Reference document number was empty' ).
      RETURN.
    ENDIF.

*   Read SO data (it_order_number)
    TYPES:
      BEGIN OF ty_vbeln_orig,
        vbeln TYPE vbeln,
      END OF ty_vbeln_orig.
    DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.
    MOVE it_order_number  TO lt_vbeln_key.


    SELECT * FROM vbak INTO TABLE @lt_vbak FOR ALL ENTRIES IN @lt_vbeln_key WHERE vbeln = @lt_vbeln_key-vbeln.
    SELECT * FROM vbap INTO TABLE @lt_vbap FOR ALL ENTRIES IN @lt_vbeln_key WHERE vbeln = @lt_vbeln_key-vbeln.
    SELECT * FROM vbpa INTO TABLE @lt_vbpa FOR ALL ENTRIES IN @lt_vbeln_key WHERE vbeln = @lt_vbeln_key-vbeln.
    SELECT * FROM vbkd INTO TABLE @lt_vbkd FOR ALL ENTRIES IN @lt_vbeln_key WHERE vbeln = @lt_vbeln_key-vbeln.
*   Get BDR fkarts
    SELECT fkart FROM tvfk INTO TABLE @lt_fkart_bdr WHERE vbtyp = @if_sd_doc_category=>ext_billing_doc_request OR vbtyp = @if_sd_doc_category=>ps_billing_doc_request.

    LOOP AT lt_vbap ASSIGNING FIELD-SYMBOL(<ls_vbap>).
      me->mo_run_environment->append_log( iv_log_statement = |Reading data from SO: { <ls_vbap>-vbeln }  position { <ls_vbap>-posnr }| ).
      CLEAR ls_ebdr_internal.
      CLEAR ls_ebdr_request.
      READ TABLE lt_vbak ASSIGNING FIELD-SYMBOL(<ls_vbak>) WITH KEY vbeln = <ls_vbap>-vbeln.
      MOVE-CORRESPONDING <ls_vbak> TO ls_ebdr_internal.
      MOVE-CORRESPONDING <ls_vbap> TO ls_ebdr_internal.

      IF lt_fkart_bdr IS NOT INITIAL AND <ls_vbak>-auart <> ls_prev_auart.
        SELECT * FROM tvcpf INTO TABLE @lt_tvcpf FOR ALL ENTRIES IN @lt_fkart_bdr WHERE auarv = @<ls_vbak>-auart AND fkarn = @lt_fkart_bdr-table_line.
        ls_prev_auart = <ls_vbak>-auart.
      ENDIF.

      IF iv_with_knumv = abap_true.
        ls_ebdr_request-pricingdocument = ls_ebdr_internal-knumv.
        ASSERT ls_ebdr_request-pricingdocument IS NOT INITIAL.
      ENDIF.
      READ TABLE lt_vbkd WITH TABLE KEY vbeln = <ls_vbap>-vbeln posnr = <ls_vbap>-posnr ASSIGNING FIELD-SYMBOL(<ls_vbkd>).
      IF sy-subrc <> 0.
        READ TABLE lt_vbkd WITH TABLE KEY vbeln = <ls_vbap>-vbeln posnr = '' ASSIGNING <ls_vbkd>.
      ENDIF.
      MOVE-CORRESPONDING <ls_vbkd> TO ls_ebdr_internal.
*       Map int2ext
      ls_ebdr_request-precedingdocumentcategory = if_sd_doc_category=>cm_service_order. "<ls_vbak>-vbtyp. "ls_ebdr_internal-vgtyp.
      ls_ebdr_request-precedingdocument = <ls_vbap>-vbeln. "ls_ebdr_internal-vgbel.
      ls_ebdr_request-precedingdocumentitem = <ls_vbap>-posnr. "ls_ebdr_internal-vgpos.
      ls_ebdr_request-precedingdocumenttype = ls_ebdr_internal-auart.
      ls_ebdr_request-precedingdocumentitemcategory = ls_ebdr_internal-pstyv.
      ls_ebdr_request-precedingdocumentitemdesc = ls_ebdr_internal-arktx.
      READ TABLE lt_tvcpf ASSIGNING FIELD-SYMBOL(<ls_tvcpf>) WITH KEY pstyv = <ls_vbap>-pstyv.
      IF sy-subrc = 0.
        ls_ebdr_request-extbillingdocrequesttype = <ls_tvcpf>-fkarn. "'BDR1'.
      ELSEIF lines( lt_fkart_bdr ) = 1. "will not work, copy control is missing
        READ TABLE lt_fkart_bdr ASSIGNING FIELD-SYMBOL(<lv_fkarn>) INDEX 1.
        ls_ebdr_request-extbillingdocrequesttype = <lv_fkarn>.
      ENDIF.
      ls_ebdr_request-salesorganization = ls_ebdr_internal-vkorg.
      ls_ebdr_request-distributionchannel = ls_ebdr_internal-vtweg.
      ls_ebdr_request-division = ls_ebdr_internal-spart.

      ls_ebdr_request-billingdate = ls_ebdr_internal-fkdat. "VBKD-FKDAT
      READ TABLE lt_vbpa WITH TABLE KEY vbeln = <ls_vbap>-vbeln posnr = <ls_vbap>-posnr parvw = 'AG' ASSIGNING FIELD-SYMBOL(<ls_vbpa>).
      IF sy-subrc = 0.
        ls_ebdr_request-soldtoparty = <ls_vbpa>-kunnr.
      ELSE. "try on header level
        READ TABLE lt_vbpa WITH TABLE KEY vbeln = <ls_vbap>-vbeln parvw = 'AG' posnr = '' ASSIGNING <ls_vbpa>.
        ls_ebdr_request-soldtoparty = <ls_vbpa>-kunnr.
      ENDIF.
      READ TABLE lt_vbpa WITH TABLE KEY vbeln = <ls_vbap>-vbeln posnr = <ls_vbap>-posnr parvw = 'RE' ASSIGNING <ls_vbpa>.
      IF sy-subrc = 0.
        ls_ebdr_request-billtoparty = <ls_vbpa>-kunnr.
      ELSE. "try on header level
        READ TABLE lt_vbpa WITH TABLE KEY vbeln = <ls_vbap>-vbeln parvw = 'RE' posnr = '' ASSIGNING <ls_vbpa>.
        ls_ebdr_request-billtoparty = <ls_vbpa>-kunnr.
      ENDIF.
      READ TABLE lt_vbpa WITH TABLE KEY vbeln = <ls_vbap>-vbeln posnr = <ls_vbap>-posnr parvw = 'RG' ASSIGNING <ls_vbpa>.
      IF sy-subrc = 0.
        ls_ebdr_request-payerparty = <ls_vbpa>-kunnr.
      ELSE. "try on header level
        READ TABLE lt_vbpa WITH TABLE KEY vbeln = <ls_vbap>-vbeln parvw = 'RG' posnr = '' ASSIGNING <ls_vbpa>.
        ls_ebdr_request-payerparty = <ls_vbpa>-kunnr.
      ENDIF.

      ls_ebdr_request-transactioncurrency = ls_ebdr_internal-waerk.
      ls_ebdr_request-taxdeparturecountry = ls_ebdr_internal-landtx.
      ls_ebdr_request-taxdestinationcountry = ls_ebdr_internal-stceg_l.
      ls_ebdr_request-customerreference = ls_ebdr_internal-bstnk_vf.
      ls_ebdr_request-customerpaymentterms = ls_ebdr_internal-zterm.
      ls_ebdr_request-paymentmethod = ls_ebdr_internal-zlsch.
      ls_ebdr_request-incotermsclassification = ls_ebdr_internal-inco1.
      ls_ebdr_request-incotermstransferlocation = ls_ebdr_internal-inco2.
      ls_ebdr_request-incotermsversion = ls_ebdr_internal-incov.
      ls_ebdr_request-incotermslocation1 = ls_ebdr_internal-inco2_l.
      ls_ebdr_request-incotermslocation2 = ls_ebdr_internal-inco3_l.

      CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
        EXPORTING
          input  = ls_ebdr_internal-matnr
        IMPORTING
          output = ls_ebdr_request-material.
      ls_ebdr_request-donotcheckmaterial = ls_ebdr_internal-no_mara.
      ls_ebdr_request-matlaccountassignmentgroup = ls_ebdr_internal-ktgrm.
      ls_ebdr_request-producthierarchy = ls_ebdr_internal-prodh.
      ls_ebdr_request-quantity = ls_ebdr_internal-kwmeng.
      ls_ebdr_request-quantityunit = ls_ebdr_internal-vrkme.

      ls_ebdr_request-servicesrendereddate = ls_ebdr_internal-fbuda.

      ls_ebdr_request-higherlevelitem = ls_ebdr_internal-vgueb.

      ls_ebdr_request-pricingdate = ls_ebdr_internal-prsdt.
      ls_ebdr_request-pricedetnexchangerate = ls_ebdr_internal-kursk.
      ls_ebdr_request-taxjurisdiction = ls_ebdr_internal-txjcd.
      ls_ebdr_request-producttaxclassification = ls_ebdr_internal-taxm1.

      ls_ebdr_request-plant = ls_ebdr_internal-werks.
      ls_ebdr_request-departurecountry = ls_ebdr_internal-land1.

      ls_ebdr_request-shiptoparty = ls_ebdr_internal-kunwe.
      ls_ebdr_request-profitcenter = ls_ebdr_internal-prctr.

      ls_ebdr_request-contractaccount = ls_ebdr_internal-vkont.
      ls_ebdr_request-profitabilitysegment = ls_ebdr_internal-paobjnr.
      ls_ebdr_request-costcenter = ls_ebdr_internal-kostl.
      ls_ebdr_request-wbselement = ls_ebdr_internal-ps_psp_pnr.

      ls_ebdr_request-businessarea = ls_ebdr_internal-gsber.
      ls_ebdr_request-internalorder = ls_ebdr_internal-aufnr.

      APPEND ls_ebdr_request TO et_ebdr_request.
    ENDLOOP.
    IF et_ebdr_request_cond IS REQUESTED.
      LOOP AT lt_vbak ASSIGNING <ls_vbak>.
        CLEAR et_ebdr_request_cond.
        CLEAR ls_komk.
        ls_komk-mandt = sy-mandt.
        ls_komk-belnr = <ls_vbak>-vbeln.
        ls_komk-knumv = <ls_vbak>-knumv.
*   Map conditions
        CALL FUNCTION 'RV_KONV_SELECT'
          EXPORTING
            comm_head_i = ls_komk
          TABLES
            tkomv       = lt_komv.

        LOOP AT lt_komv ASSIGNING FIELD-SYMBOL(<ls_komv>) WHERE kstat = space AND koaid = 'B'. "only prices
          ls_ebdr_request_cond-precedingdocument = <ls_vbak>-vbeln.
          ls_ebdr_request_cond-precedingdocumentitem = <ls_komv>-kposn.
          ls_ebdr_request_cond-conditiontype = <ls_komv>-kschl.
          ls_ebdr_request_cond-conditionratevalue = <ls_komv>-kbetr.
          ls_ebdr_request_cond-conditioncurrency = <ls_komv>-waers.
          ls_ebdr_request_cond-conditionquantity = <ls_komv>-kpein.
          ls_ebdr_request_cond-conditionquantityunit = <ls_komv>-kmein.
          APPEND ls_ebdr_request_cond TO et_ebdr_request_cond.
        ENDLOOP.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD odata_f2337_get.
    DATA: lv_step_success    TYPE abap_bool,
          lv_status_code_txt TYPE string,
          lv_msg             TYPE string,
          lv_status_text     TYPE string,
          lv_status_code     TYPE integer,
          ls_return          TYPE bapiret2,
          lv_body            TYPE xstring,
          ls_doc_it          TYPE posnr_vf.


    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/SAP/SD_F2337_EBDR_FS_SRV/',
          lv_uri         TYPE string,
          lt_parameters  TYPE /iwfnd/sutil_property_t.

    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).


    lv_step_success = abap_true.
    LOOP AT step_data-reference_step INTO DATA(lv_prestepnumber).
      DATA(ls_check_step_data) = me->mo_run_environment->get_step_data( iv_step_number = lv_prestepnumber ).
      IF ls_check_step_data-document_id IS INITIAL.
        ev_execution_status = abap_false.
        me->mo_run_environment->append_log( iv_log_statement = |No reference document exists!| ).
        RETURN.
      ENDIF.
      LOOP AT ls_check_step_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).
        DATA(lv_index) = sy-tabix.
        lt_parameters = VALUE #( ( name = 'BillingDocumentRequest'     value =  <ls_docid> ) ).

        lo_odata_caller->call_service(
          EXPORTING
            iv_action_or_entity = 'C_BillingDocRequestObjPg'
            it_parameters       = lt_parameters                   " Name/Value Pair - Table
          IMPORTING
            ev_status_code      = lv_status_code                  " Whole Number with +/- Sign (-2.147.483.648 .. 2.147.483.647)
            ev_status_text      = lv_status_text
            ev_body             = lv_body
        ).

        lv_status_code_txt = lv_status_code.
        CONCATENATE 'Executed API Call' 'C_BillingDocRequestObjPg' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
        me->mo_run_environment->append_log( iv_log_statement = lv_msg ).

        IF lv_status_code = 200.
          lv_step_success = abap_true.
        ELSE. "lv_status = 200
          me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
          lv_step_success = abap_false.
          EXIT.
        ENDIF.

        lo_odata_caller->call_service(
          EXPORTING
          iv_action_or_entity = 'C_BillingDocRequestObjPg'
          iv_association      = 'TextSet'
          it_parameters       = lt_parameters                   " Name/Value Pair - Table
          IMPORTING
          ev_status_code      = lv_status_code                  " Whole Number with +/- Sign (-2.147.483.648 .. 2.147.483.647)
          ev_status_text      = lv_status_text
          ev_body             = lv_body
          ).

        lv_status_code_txt = lv_status_code.
        CONCATENATE 'Executed API Call' 'C_BillingDocRequestObjPg''/''TextSet' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
        me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
        IF lv_status_code = 200.
          lv_step_success = abap_true.
        ELSE. "lv_status = 200
          me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
          lv_step_success = abap_false.
          EXIT.
        ENDIF.

        lo_odata_caller->call_service(
          EXPORTING
            iv_action_or_entity = 'C_BillingDocRequestObjPg'
            iv_association      = 'IssueSet'
            it_parameters       = lt_parameters                   " Name/Value Pair - Table
          IMPORTING
            ev_status_code      = lv_status_code                  " Whole Number with +/- Sign (-2.147.483.648 .. 2.147.483.647)
            ev_status_text      = lv_status_text
            ev_body             = lv_body
        ).

        lv_status_code_txt = lv_status_code.
        CONCATENATE 'Executed API Call' 'C_BillingDocRequestObjPg' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
        me->mo_run_environment->append_log( iv_log_statement = lv_msg ).


        IF lv_status_code = 200.
          lv_step_success = abap_true.
        ELSE. "lv_status = 200
          me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
          lv_step_success = abap_false.
          EXIT.
        ENDIF.

        SELECT SINGLE posnr FROM vbrp WHERE vbeln = @<ls_docid>-vbeln INTO @ls_doc_it.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = ls_doc_it
          IMPORTING
            output = ls_doc_it.

        APPEND VALUE #( name = 'BillingDocumentRequestItem' value = ls_doc_it ) TO lt_parameters.

        lo_odata_caller->call_service(
          EXPORTING
            iv_action_or_entity = 'C_BillingDocReqItemObjPg'
            it_parameters       = lt_parameters                   " Name/Value Pair - Table
          IMPORTING
            ev_status_code      = lv_status_code                  " Whole Number with +/- Sign (-2.147.483.648 .. 2.147.483.647)
            ev_status_text      = lv_status_text
            ev_body             = lv_body
        ).

        lv_status_code_txt = lv_status_code.
        CONCATENATE 'Executed API Call' 'C_BillingDocReqItemObjPg' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
        me->mo_run_environment->append_log( iv_log_statement = lv_msg ).

        IF lv_status_code = 200.
          lv_step_success = abap_true.
        ELSE. "lv_status = 200
          me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
          lv_step_success = abap_false.
          EXIT.
        ENDIF.

        lo_odata_caller->call_service(
          EXPORTING
            iv_action_or_entity = 'C_BillingDocReqItemObjPg'
            iv_association      = 'TextSet'
            it_parameters       = lt_parameters                   " Name/Value Pair - Table
          IMPORTING
            ev_status_code      = lv_status_code                  " Whole Number with +/- Sign (-2.147.483.648 .. 2.147.483.647)
            ev_status_text      = lv_status_text
            ev_body             = lv_body
        ).

        lv_status_code_txt = lv_status_code.

        CONCATENATE 'Executed API Call' 'C_BillingDocReqItemObjPg''/''TextSet' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
        me->mo_run_environment->append_log( iv_log_statement = lv_msg ).

        IF lv_status_code = 200.
          lv_step_success = abap_true.
        ELSE. "lv_status = 200
          me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
          lv_step_success = abap_false.
          EXIT.
        ENDIF.

        lo_odata_caller->call_service(
          EXPORTING
            iv_action_or_entity = 'C_BillingDocReqItemObjPg'
            iv_association      = 'IssueSet'
            it_parameters       = lt_parameters                   " Name/Value Pair - Table
          IMPORTING
            ev_status_code      = lv_status_code                  " Whole Number with +/- Sign (-2.147.483.648 .. 2.147.483.647)
            ev_status_text      = lv_status_text
            ev_body             = lv_body
        ).

        lv_status_code_txt = lv_status_code.
        CONCATENATE 'Executed API Call' 'C_BillingDocReqItemObjPg''/''IssueSet' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
        me->mo_run_environment->append_log( iv_log_statement = lv_msg ).

        IF lv_status_code = 200.
          lv_step_success = abap_true.
        ELSE. "lv_status = 200
          me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
          lv_step_success = abap_false.
          EXIT.
        ENDIF.

        lo_odata_caller->call_service(
          EXPORTING
            iv_action_or_entity = 'C_BillingDocReqItemObjPg'
            iv_association      = 'ValueHelpTextIdSet'
            it_parameters       = lt_parameters
          IMPORTING
            ev_status_code      = lv_status_code                  " Whole Number with +/- Sign (-2.147.483.648 .. 2.147.483.647)
            ev_status_text      = lv_status_text
            ev_body             = lv_body
        ).

        lv_status_code_txt = lv_status_code.

        CONCATENATE 'Executed API Call' 'C_BillingDocReqItemObjPg''/''ValueHelpTextIdSet' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
        me->mo_run_environment->append_log( iv_log_statement = lv_msg ).

        IF lv_status_code = 200.
          lv_step_success = abap_true.
        ELSE. "lv_status = 200
          me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
          lv_step_success = abap_false.
          EXIT.
        ENDIF.

        lo_odata_caller->call_service(
          EXPORTING
            iv_action_or_entity = 'C_BillingDocReqItemObjPg'
            iv_association      = 'ValueLanguageIdSet'
            it_parameters       = lt_parameters
          IMPORTING
            ev_status_code      = lv_status_code                  " Whole Number with +/- Sign (-2.147.483.648 .. 2.147.483.647)
            ev_status_text      = lv_status_text
            ev_body             = lv_body
        ).

        lv_status_code_txt = lv_status_code.
        CONCATENATE 'Executed API Call' 'C_BillingDocReqItemObjPg''/''ValueLanguageIdSet' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
        me->mo_run_environment->append_log( iv_log_statement = lv_msg ).

        IF lv_status_code = 200.
          lv_step_success = abap_true.
        ELSE. "lv_status = 200
          me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
          lv_step_success = abap_false.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

** Output in case of success
    IF lv_step_success EQ abap_true.
      ev_execution_status = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |The Values of the checked document are correct. Processstep is: { step_data-step_number }| ).
    ELSE.
      ev_execution_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |The Values of the checked document are not correct. Processstep is: { step_data-step_number }| ).
    ENDIF.
  ENDMETHOD.


  METHOD odata_function_import.
    DATA: lv_status_text     TYPE string,
          lv_status_code_txt TYPE string,
          lv_status_code     TYPE integer.
    TYPES: BEGIN OF ty_functionimportresult,
             billingdocumentrequest     TYPE vbeln_va,
             billingdocumentrequestitem TYPE posnr,
             type                       TYPE string,
             title                      TYPE string,
           END OF ty_functionimportresult.

    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              results TYPE TABLE OF ty_functionimportresult,
            END OF d,
          END OF ls_response_function.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/sap/SD_EBDR_MANAGE_SRV/'.
    DATA: lv_uri TYPE string.
    DATA lt_parameters TYPE /iwfnd/sutil_property_t.

    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    IF cs_step_data-reference_step IS INITIAL.
      ev_execution_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |No reference document exists!| ).
      RETURN.
    ENDIF.
    LOOP AT cs_step_data-reference_step INTO DATA(lv_prestepnumber).
      DATA(ls_check_step_data) = me->mo_run_environment->get_step_data( iv_step_number = lv_prestepnumber ).
      IF ls_check_step_data-document_id IS INITIAL.
        ev_execution_status = abap_false.
        me->mo_run_environment->append_log( iv_log_statement = |No reference document exists!| ).
        RETURN.
      ENDIF.
      LOOP AT ls_check_step_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).
        lt_parameters = VALUE #( ( name = 'BillingDocumentRequest' value =  <ls_docid> ) ).
      ENDLOOP.

      IF iv_function_name = _mc_function_delete OR
         iv_function_name = _mc_function_reject.

        lo_odata_caller->call_service(
          EXPORTING
            iv_method           = 'POST'
            iv_action_or_entity = iv_function_name
            it_parameters       = lt_parameters                   " Name/Value Pair - Table
          IMPORTING
            ev_status_code      = lv_status_code                  " Whole Number with +/- Sign (-2.147.483.648 .. 2.147.483.647)
            ev_status_text      = lv_status_text
            es_json_response    = ls_response_function
            ).

        lv_status_code_txt = lv_status_code.
        me->mo_run_environment->append_log( iv_log_statement = |Executed API Call { iv_function_name } with status code { lv_status_code_txt } and status text { lv_status_text }| ).
        IF lv_status_code = 200.
          ev_check_status = abap_true.
          ev_execution_status = abap_true.
        ELSE.
          me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
          ev_check_status = abap_false.
          ev_execution_status = abap_false.
          EXIT.
        ENDIF.

      ENDIF.
    ENDLOOP.
    LOOP AT ls_response_function-d-results ASSIGNING FIELD-SYMBOL(<ls_result>).
      APPEND VALUE #( extbillingdocrequest = <ls_result>-billingdocumentrequest
                      extbillingdocrequestitem = <ls_result>-billingdocumentrequestitem
                      systemmessagetype = <ls_result>-type
                      systemmessagetext = <ls_result>-title ) TO et_function_return.
    ENDLOOP.

  ENDMETHOD.


  METHOD reject.

    DATA lt_ebdr_rej           TYPE if_sd_bil_type_def_ext=>tt_extbillingdocrequest.
    DATA ls_ebdr_rej           TYPE if_sd_bil_type_def_ext=>ty_extbillingdocrequest.
    DATA lt_ebdr_rejected      TYPE if_sd_bil_type_def_ext=>tt_extbillingdocrequest.
    DATA lt_ebdr_reject_failed TYPE if_sd_bil_type_def_ext=>tt_extbillingdocrequest.
    DATA lt_message_rejected   TYPE sdbil_ebdr_request_msg_t..

*    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).

    LOOP AT step_data-reference_step INTO DATA(lv_prestepnumber).
      DATA(ls_check_step_data) = me->mo_run_environment->get_step_data( iv_step_number = lv_prestepnumber ).
      IF ls_check_step_data-document_id IS INITIAL.
        ev_execution_status = abap_false.
        me->mo_run_environment->append_log( iv_log_statement = |SEF: NO REFERENCE document exists!| ).
        RETURN.
      ELSE.

        LOOP AT ls_check_step_data-document_id INTO DATA(ls_document_id).
          ls_ebdr_rej-extbillingdocrequest = ls_document_id-vbeln.
          APPEND ls_ebdr_rej TO lt_ebdr_rej.
          CLEAR ls_ebdr_rej.

        ENDLOOP.
      ENDIF.
    ENDLOOP.

    cl_sd_bil_ebdr_facade_ext=>if_sd_bil_ebdr_action_ext~reject(
    EXPORTING
      it_ebdr                = lt_ebdr_rej
      iv_commit_mode         = '2'
    IMPORTING
      et_ebdr_rejected       = lt_ebdr_rejected
      et_ebdr_reject_failed  = lt_ebdr_reject_failed
      et_message             = lt_message_rejected ).

    IF lt_ebdr_reject_failed IS NOT INITIAL.

      ev_execution_status = abap_false.

      LOOP AT lt_ebdr_reject_failed INTO DATA(ls_ebdr_reject_failed).
        APPEND ls_ebdr_reject_failed-extbillingdocrequest  TO ev_document_id.
        me->mo_run_environment->append_log( iv_log_statement = |The BDR: { ls_ebdr_reject_failed-extbillingdocrequest } rejection failed.| ) .
      ENDLOOP.

    ELSE.

      LOOP AT lt_ebdr_rejected INTO DATA(ls_ebdr_rejected).
        APPEND ls_ebdr_rejected-extbillingdocrequest  TO ev_document_id.
      ENDLOOP.

      ev_execution_status = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |The BDR rejection successed.| ) .
    ENDIF.
  ENDMETHOD.


  METHOD reject_with_odata.
    DATA: lt_messages TYPE sdbil_ebdr_request_msg_t.
    me->odata_function_import(
    EXPORTING
      iv_function_name    = _mc_function_reject
      cs_step_data        = step_data
    IMPORTING
      et_function_return  = lt_messages
      ev_document_id      = ev_document_id
      ev_execution_status = ev_execution_status
      ev_check_status     = ev_check_status
    ).

    LOOP AT lt_messages ASSIGNING FIELD-SYMBOL(<ls_message>).
      me->mo_run_environment->append_log( iv_log_statement = |{ <ls_message>-systemmessagetext }| ).
    ENDLOOP.

  ENDMETHOD.


  METHOD RESERVE_ACTION_1.


  ENDMETHOD.


  METHOD RESERVE_ACTION_2.


  ENDMETHOD.


  METHOD RESERVE_ACTION_3.


  ENDMETHOD.


  METHOD unlock.

*    DATA lv_vbeln TYPE vbeln.
*
*    CLEAR:
*      ev_check_status,
*      ev_execution_status,
*      ev_document_id.
*
*    mv_unlocked_async = 'R'. " unlock requested
*
*    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_step>).
*      DATA(ls_step) = me->mo_run_environment->get_step_data( iv_step_number = <ls_step> ).
*      LOOP AT ls_step-document_id ASSIGNING FIELD-SYMBOL(<lv_docid>).
*        lv_vbeln = <lv_docid>.
*
*        CALL FUNCTION 'SD_DOC_UNLOCK' STARTING NEW TASK 'PTF_EBDR' CALLING cl_ptf_bo_ebdr=>keeping_lock_task ON END OF TASK
*          EXPORTING
*            iv_vbtyp              = if_sd_doc_category=>ext_billing_doc_request
*            iv_vbeln              = lv_vbeln
*          EXCEPTIONS
*            system_failure        = 1
*            communication_failure = 2
*            resource_failure      = 3.
*
*        WAIT FOR ASYNCHRONOUS TASKS UNTIL mv_unlocked_async EQ abap_true " unlock set
*                                    UP TO 10 SECONDS.
*        IF mv_unlocked_async EQ abap_true.
*          ev_execution_status = abap_true.
*        ENDIF.
*        INSERT <lv_docid> INTO TABLE ev_document_id.
*      ENDLOOP.
*    ENDLOOP.
*
*    CLEAR: mv_unlocked_async.

  ENDMETHOD.


  METHOD wait.

    DATA lc_second TYPE i VALUE 3.

    WAIT UP TO lc_second SECONDS.
    ev_execution_status = abap_true.

  ENDMETHOD.
ENDCLASS.
