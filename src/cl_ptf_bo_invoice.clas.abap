class CL_PTF_BO_INVOICE definition
  public
  inheriting from CL_PTF_BO
  final
  create public .

public section.

  types:
    begin of ty_field_name,
        field_name type string,
      end of ty_field_name .
  types:
    tt_field_names type standard table of ty_field_name with default key .
  types:
    begin of ty_gs_compare_irrelevant,
        irrelevant_head_fields type tt_field_names,
        irrelevant_pos_fields  type tt_field_names,
      end of ty_gs_compare_irrelevant .
  types:
    begin of ty_gs_bd_up_zuonr_xblnr,
        bd_upd_sbi_req_mes type sdbil_esr_bd_upd_sbi_req_mes,
      end of ty_gs_bd_up_zuonr_xblnr .
  types:
    begin of ty_gs_bd_sm_pricing,
        bd_simulate_pricing_reques1 type sdbilbdsimulate_pricing_reque1,
      end of ty_gs_bd_sm_pricing .
  types:
    begin of ty_gs_bd_up_zuonr_xblnr_2,
        bd_upd_sbi_req_mes_2 type sdbil_esrbdupdate_self_bil_tab,
      end of ty_gs_bd_up_zuonr_xblnr_2 .
  types:
    begin of ty_gs_post_dpy,
        konko               type konko,
        delta_document_date type int2,
        delta_posting_date  type int2,
      end of ty_gs_post_dpy .
  types:
    begin of ty_gs_partial_payment,
        konko      type konko,
        percentage type percent,
      end of ty_gs_partial_payment .
  types:
    begin of ty_set_nriv,
        num_range_number    type nrnr,
        num_range_object    type nrobj,
        num_range_subobject type nrsobj,
        num_range_to_year   type nryear,
      end of ty_set_nriv .
  types:
    begin of ty_check_a_billingdocument,
        fieldname  type string,
        fieldvalue type string,
      end of ty_check_a_billingdocument .
  types:
    tt_check_a_billingdocument type standard table of ty_check_a_billingdocument with default key .
  types:
    begin of ty_check_fi_data_flow,
        field_type        type c length 1, "H:=Head; I:Item
        bd_field_name     type string,
        acdoca_field_name type string,
        bseg_field_name   type string,
*             acdoca_name_empty_field TYPE string,
*             bseg_name_empty_field   TYPE string,
      end of ty_check_fi_data_flow .
  types:
    tt_fi_data_flow type standard table of ty_check_fi_data_flow with default key .
  types TY_GS_PTF_PAYMENTCARD_CHECK_TD type SDBIL_ESR_BDR_PAYMENT_CARD_TAB .
  types:
* Structure for Check of Billing Documents
    vbrp_tab       type standard table of vbrp with default key .
  types:
    vbrp_check_tab type standard table of sdbil_tst_vbrp_check with default key .
  types:
    vbrk_tab       type standard table of vbrk with default key .
  types:
    vbrk_check_tab type standard table of sdbil_tst_vbrk_check with default key .
  types:
    begin of ty_gs_check_number_of_pos,
        expected_number type i,
      end of ty_gs_check_number_of_pos .
  types:
    begin of ty_gs_check_prefix,
        expected_prefix type sd_nrrange_prefix,
      end of ty_gs_check_prefix .
  types:
    begin of ty_gs_ptf_bd_test_add_td,
        expected_count       type i,
        expected_count_check type abap_bool,
        vdkfs_read           type abap_bool,
        check_text           type abap_bool,
        pricing_check        type abap_bool,
      end of ty_gs_ptf_bd_test_add_td .
  types:
    begin of ty_gs_ptf_bd_post_dp,
        amount_percentage type p decimals 2 length 6,
      end of ty_gs_ptf_bd_post_dp .
  types:
    begin of ty_check_vkdfs,
        vkdfs       type vkdfs,
        vkdfs_check type sdbil_tst_vkdfs_check,
      end of ty_check_vkdfs .
  types:
    begin of ty_check_bseg_tax_country,
        tax_country type fot_tax_country,
      end of ty_check_bseg_tax_country .
  types:
    begin of ty_prcd_elements_check,
        knumv                 type abap_bool,
        kposn                 type abap_bool,
        stunr                 type abap_bool,
        zaehk                 type abap_bool,
        kappl                 type abap_bool,
        kschl                 type abap_bool,
        kdatu                 type abap_bool,
        krech                 type abap_bool,
        kawrt                 type abap_bool,
        kbetr                 type abap_bool,
        waers                 type abap_bool,
        kkurs                 type abap_bool,
        kpein                 type abap_bool,
        kmein                 type abap_bool,
        kumza                 type abap_bool,
        kumne                 type abap_bool,
        kntyp                 type abap_bool,
        kstat                 type abap_bool,
        knprs                 type abap_bool,
        kruek                 type abap_bool,
        kreli                 type abap_bool,
        kherk                 type abap_bool,
        kgrpe                 type abap_bool,
        kolnr                 type abap_bool,
        knumh                 type abap_bool,
        kopos                 type abap_bool,
        kvsl1                 type abap_bool,
        sakn1                 type abap_bool,
        mwsk1                 type abap_bool,
        kvsl2                 type abap_bool,
        sakn2                 type abap_bool,
        mwsk2                 type abap_bool,
        lifnr                 type abap_bool,
        kdiff                 type abap_bool,
        kwert                 type abap_bool,
        waerk                 type abap_bool,
        ksteu                 type abap_bool,
        kinak                 type abap_bool,
        koaid                 type abap_bool,
        zaeko                 type abap_bool,
        kfaktor               type abap_bool,
        kdupl                 type abap_bool,
        kfaktor1              type abap_bool,
        kzbzg                 type abap_bool,
        kstbs                 type abap_bool,
        konms                 type abap_bool,
        konws                 type abap_bool,
        kwaeh                 type abap_bool,
        kwert_k               type abap_bool,
        kfkiv                 type abap_bool,
        kmprs                 type abap_bool,
        prsqu                 type abap_bool,
        txjlv                 type abap_bool,
        kbflag                type abap_bool,
        koupd                 type abap_bool,
        kmxaw                 type abap_bool,
        kmxwr                 type abap_bool,
        kawrt_k               type abap_bool,
        kunnr                 type abap_bool,
        kvarc                 type abap_bool,
        varcond               type abap_bool,
        ktrel                 type abap_bool,
        mdflg                 type abap_bool,
        _dataaging            type abap_bool,
        cpf_guid              type abap_bool,
        kaqty                 type abap_bool,
        val_zero              type abap_bool,
        is_acct_detn_relevant type abap_bool,
      end of ty_prcd_elements_check .
  types:
    prcd_elements_tab type standard table of prcd_elements with default key .
  types:
    prcd_elements_check_tab type standard table of ty_prcd_elements_check with default key .
  types:
    begin of ty_gs_bd_condition_check,
        prcd       type prcd_elements_tab,
        prcd_check type prcd_elements_check_tab,
      end of ty_gs_bd_condition_check .
  types:
    begin of ty_gs_create_for_country,
        country type lland,
      end of ty_gs_create_for_country .
  types:
    countries type standard table of ty_gs_create_for_country with default key .
  types:
    begin of ty_gs_create_for_countries,
        countries type countries,
      end of ty_gs_create_for_countries .
  types:
*    Billing Documents created with GN_INVOICE_CREATE
    begin of ty_gs_create_for_item,
        invoice_type            type fkart,
        invoice_date            type fkdat,
        i_no_collective_billing type abap_bool,
        no_fin_doc              type string,
        item_number             type posnr,
      end of ty_gs_create_for_item .
  types:
    begin of ty_gs_ptf_bd_check_td,
        vbrk       type vbrk_tab,
        vbrp       type vbrp_tab,
        vbrk_check type vbrk_check_tab,
        vbrp_check type vbrp_check_tab,
*      add_check  TYPE ty_gs_ptf_bd_test_add_td,
      end of ty_gs_ptf_bd_check_td .
  types:
    begin of ty_gs_ptf_bd_multiple_check_td,
        idx        type i,
        check_data type  ty_gs_ptf_bd_check_td,
      end of ty_gs_ptf_bd_multiple_check_td .
  types:
    multiple_bd_check type standard table of ty_gs_ptf_bd_multiple_check_td with default key .
  types:
    begin of ty_gs_ptf_multiple_checks_td,
        checks type  multiple_bd_check,
      end of ty_gs_ptf_multiple_checks_td .
  types:
*    Billing Documents created with GN_INVOICE_CREATE
    begin of ty_gs_import_gn_invce_create,
        delivery_date           type vbrp-fbuda,
        invoice_date            type vbrk-fkdat,
        invoice_type            type vbrk-fkart,
        pricing_date            type vbrp-prsdt,
        vbsk_i                  type vbsk,
        with_posting(1)         type c,
        caller_type(1)          type c,
        i_without_refresh(1)    type c,
        id_no_enqueue(4)        type c,
        id_kvorg                type komk-kvorg,
        id_no_dialog            type xflag,
        id_new_cancellation(4)  type c,
        id_analyze_mode         type char1,
        id_no_fi_doc            type char1,
        is_fi_add_input         type sdfi_s_add_input,
        id_sim_without_price    type char1,
        io_external_buffer      type ref to if_inv_external_buffer,
        i_no_collective_billing type boolean,
      end of ty_gs_import_gn_invce_create .
  types:
* Structure Billing Document Create
    begin of ty_gs_i_ptf_bd_cr_td,
        invoice_type            type fkart,
        invoice_date            type fkdat,
        msico_vkorg             type msico_sales_organization,
        i_no_collective_billing type abap_bool,
        no_fin_doc              type string,
        hard_coded_reference    type vbeln,
        delta_invoice_date      type int2,
      end of ty_gs_i_ptf_bd_cr_td .
  types:
    tt_countries type standard table of land1 with default key .
  types:
    begin of ty_gs_bd_cr_trit_tdt_double,
        invoice_type            type fkart,
        invoice_date            type fkdat,
        i_no_collective_billing type abap_bool,
        no_fin_doc              type string,
        is_trit_active          type abap_bool,
        tax_country             type land1,
        registered_countries    type tt_countries,
        is_tdt_active           type abap_bool,
        start_date              type sy-datum,
        period_length_in_days   type i,
      end of ty_gs_bd_cr_trit_tdt_double .
  types:
    begin of ty_gs_i_ptf_vkdfs_check_td,
        expected_entries type i,
      end of ty_gs_i_ptf_vkdfs_check_td .
  types:
* Structure for External Billing Document Create (SOA/ESR/Proxy)
    begin of ty_gs_i_ptf_bd_cr_ws_td,
        bd_request_msg type sdbil_esr_bd_request_msg,
      end of ty_gs_i_ptf_bd_cr_ws_td .
  types:
    begin of ty_gs_i_ptf_partner_addr,
        parvw      type parvw,
        city1      type ad_city1,
        post_code1 type ad_pstcd1,
        street     type ad_street,
        house_num1 type ad_hsnm1,
      end of ty_gs_i_ptf_partner_addr .
  types:
    begin of ty_gs_i_ptf_partner_addr_check,
        parvw      type abap_bool,
        city1      type abap_bool,
        post_code1 type abap_bool,
        street     type abap_bool,
        house_num1 type abap_bool,
      end of ty_gs_i_ptf_partner_addr_check .
  types:
    partner_addr_tab type standard table of ty_gs_i_ptf_partner_addr with default key .
  types:
    partner_addr_check_tab type standard table of ty_gs_i_ptf_partner_addr_check with default key .
  types:
    begin of ty_gs_partner_addr_check,
        partner_addr       type partner_addr_tab,
        partner_addr_check type partner_addr_check_tab,
      end of ty_gs_partner_addr_check .
  types:
      "TDCP Of A2A Call API action
    begin of ty_gs_ptf_call_by_soap_td,
        username    type string,
        password    type string,
        host        type string,
        request_uri type string,
        payload     type string,
      end of ty_gs_ptf_call_by_soap_td .
  types:
* Structure Billing Document Cancel
    begin of ty_gs_ptf_bd_cancel_td,
        delta_invoice_date type int2,
        invoice_date       type fkdat,
      end of ty_gs_ptf_bd_cancel_td .
  types:
    begin of ty_gs_wait_td,
        wait_time type string,
      end of ty_gs_wait_td .
  types:
    begin of ty_gs_invoice_header_change_td,
        billing_date            type vbrk-fkdat,
        vat_registration_number type vbrk-stceg,
        vat_country             type vbrk-stceg_l,
      end of ty_gs_invoice_header_change_td .
  types:
*    Billing Documents created with GN_INVOICE_CREATE
    begin of ty_gs_bd_cr_with_pprctr,
        invoice_type            type fkart,
        invoice_date            type fkdat,
        i_no_collective_billing type abap_bool,
        no_fin_doc              type string,
        hard_coded_reference    type vbeln,
        delta_invoice_date      type int2,
        partner_profit_center   type pprctr,
      end of ty_gs_bd_cr_with_pprctr .
  types:
    begin of ty_gs_item_pprctr,
        item_number           type posnr,
        partner_profit_center type pprctr,
      end of ty_gs_item_pprctr .
  types:
    item_pprctr_tab type standard table of ty_gs_item_pprctr with default key .
  types:
    begin of ty_gs_bd_cr_for_item_pprctr,
        invoice_type            type fkart,
        invoice_date            type fkdat,
        i_no_collective_billing type abap_bool,
        no_fin_doc              type string,
        item_pprctr             type item_pprctr_tab,
      end of ty_gs_bd_cr_for_item_pprctr .
  types:
    begin of ty_gs_bd_item_pprctr_check,
        item_pprctr_check type item_pprctr_tab,
      end of ty_gs_bd_item_pprctr_check .

  class-data GV_STATIC_TXT_FLD type TEXT10 .

  methods CREATE_WITH_VKORG
    importing
      !IV_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .

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

  types:
    begin of ty_def_functionimportresult,
      billingdocument     type string,
      billingdocumentitem type string,
      messageid           type string,
      messagetype         type string,
      message             type string,
    end of ty_def_functionimportresult .

  constants C_CHECK_MULTI_CDM type STRING value 'CHECK_MULTI_CDM' ##NO_TEXT.
  constants C_MANIPULATE_NRIV type STRING value 'MANIPULATE_NRIV' ##NO_TEXT.
  constants C_CHECK_MULTIPLE type STRING value 'CHECK_MULTIPLE' ##NO_TEXT.
  constants C_CHECK_NUMBER_OF_POSITIONS type STRING value 'CHECK_NUMBER_OF_POSITIONS' ##NO_TEXT.
  constants C_ODATA_POST_CR_FOR_COUNTRIES type STRING value 'ODATA_POST_CR_FOR_COUNTRIES' ##NO_TEXT.
  constants C_POST_CREATE_FOR_COUNTRY type STRING value 'ODATA_POST_CREATE_FOR_COUNTRY' ##NO_TEXT.
  constants C_CHECK_COMPARE_BILLING_DOC type STRING value 'CHECK_COMPARE_BILLING_DOC' ##NO_TEXT.
  constants C_CHECK_COMPARE_VBFA type STRING value 'CHECK_COMPARE_VBFA' ##NO_TEXT.
  constants C_CHECK_CONDITION_EXISTS type STRING value 'CHECK_CONDITION_EXISTS' ##NO_TEXT.
  constants C_CHECK_EXPECTED_DOC_QUANTITY type STRING value 'CHECK_EXPECTED_DOC_QUANTITY' ##NO_TEXT.
  constants C_CHECK_EXT_FIELDS type STRING value 'CHECK_EXT_FIELDS' ##NO_TEXT.
  constants C_CHECK_OUTPUT type STRING value 'CHECK_OUTPUT' ##NO_TEXT.
  constants C_CHECK_PRICE_GREATER_ZERO type STRING value 'CHECK_PRICE_GREATER_ZERO' ##NO_TEXT.
  constants C_CHECK_TEXT type STRING value 'CHECK_TEXT' ##NO_TEXT.
  constants C_CHECK_XBLNR_PREDEC type STRING value 'CHECK_XBLNR_PREDEC' ##NO_TEXT.
  constants C_CHECK_ZUONR_PREDEC type STRING value 'CHECK_ZUONR_PREDEC' ##NO_TEXT.
  constants C_CHECK_TEXT_PBD type STRING value 'CHECK_TEXT_PBD' ##NO_TEXT.
  constants C_API_POST_FI_CANCEL_BD_NEG type STRING value 'API_POST_FI_CANCEL_BD_NEG' ##NO_TEXT.
  constants C_API_POST_FI_CANCEL_BD type STRING value 'API_POST_FI_CANCEL_BD' ##NO_TEXT.
  constants C_ODATA_POST_COMPARE_BD type STRING value 'ODATA_POST_COMPARE_BD' ##NO_TEXT.
  constants C_ODATA_GET_PDF_BD type STRING value 'ODATA_GET_PDF' ##NO_TEXT.
  constants C_ODATA_GET_PDF_NEG_NE type STRING value 'ODATA_GET_PDF_NEG_NE' ##NO_TEXT.
  constants C_ODATA_GET_BD_LIST_ITEM type STRING value 'ODATA_GET_BD_LIST_ITEM' ##NO_TEXT.
  constants C_ODATA_POST_CREATE_BDS type STRING value 'ODATA_POST_CREATE_BDS' ##NO_TEXT.
  constants C_ODATA_POST_GET_BD_TYPES type STRING value 'ODATA_POST_GET_BD_TYPES' ##NO_TEXT.
  constants C_ODATA_GET_BD_ITEM type STRING value 'ODATA_GET_BD_ITEM' ##NO_TEXT.
  constants C_ODATA_GET_BD type STRING value 'ODATA_GET_BD' ##NO_TEXT.
  constants C_ODATA_POST_POST_BD_TO_ACC type STRING value 'ODATA_POST_BD_TO_ACC' ##NO_TEXT.
  constants C_ODATA_POST_DELETE_SNAPSHOT type STRING value 'ODATA_POST_DELETE_SNAPSHOT' ##NO_TEXT.
  constants C_ODATA_POST_CANCEL_BD type STRING value 'ODATA_POST_CANCEL_BD' ##NO_TEXT.
  constants C_ODATA_POST_ACTIVATE_SNAPSHOT type STRING value 'ODATA_POST_ACTIVATE_SNAPSHOT' ##NO_TEXT.
  constants C_ODATA_GET_SUBS_BD_SBI type STRING value 'ODATA_GET_SUBS_BD_SBI' ##NO_TEXT.
  constants C_CREATE_SNAPSHOT type STRING value 'CREATE_SNAPSHOT' ##NO_TEXT.
  constants C_ACTIVATE_SNAPSHOT type STRING value 'ACTIVATE_SNAPSHOT' ##NO_TEXT.
  constants C_CREATE_SNAPSHOT_LOCK_CHECK type STRING value 'CREATE_SNAPSHOT_LOCK_CHECK' ##NO_TEXT.
  constants C_CANCEL type STRING value 'CANCEL' ##NO_TEXT.
  constants C_RELEASE_TO_ACCOUNTING type STRING value 'RELEASE_TO_ACCOUNTING' ##NO_TEXT.
  constants C_CANCEL_ITEM type STRING value 'CANCEL_ITEM' ##NO_TEXT.
  constants C_CREATE_WITH_WEB_SERVICE type STRING value 'CREATE_WITH_WEB_SERVICE' ##NO_TEXT.
  constants C_FILL_EXT_FIELD type STRING value 'FILL_EXT_FIELD' ##NO_TEXT.
  constants C_CHECK_VKDFS type STRING value 'CHECK_VKDFS' ##NO_TEXT.
  constants C_CHECK_NUMBER_VKDFS_ENTRIES type STRING value 'CHECK_NUMBER_VKDFS_ENTRIES' ##NO_TEXT.
  constants C_CREATE_FOR_ITEM type STRING value 'CREATE_FOR_ITEM' ##NO_TEXT.
  constants C_CHECK_PAYPAL_DATA type STRING value 'CHECK_PAYPAL_DATA' ##NO_TEXT.
  constants C_CHECK_SEPA_MANDATE type STRING value 'CHECK_SEPA_MANDATE' ##NO_TEXT.
  constants C_CHECK_DYN_OUTPUT type STRING value 'CHECK_DYN_OUTPUT' ##NO_TEXT.
  constants C_CHECK_PRICING_CONDITIONS type STRING value 'CHECK_PRICING_CONDITIONS' ##NO_TEXT.
  constants C_CHECK_ANA_FIELDS type STRING value 'CHECK_ANA_FIELDS' ##NO_TEXT.
  constants C_INTERNAL_UPDATE type STRING value 'INTERNAL_UPDATE' ##NO_TEXT.
  constants C_CHECK_PREFIX type STRING value 'CHECK_PREFIX' ##NO_TEXT.
  constants C_CHECK_PRECEDING type STRING value 'CHECK_PRECEDING' ##NO_TEXT.
  constants C_CHECK_AUBEL_REF type STRING value 'CHECK_AUBEL_REF' ##NO_TEXT.
  constants C_CHECK_FI_KIDNO type STRING value 'CHECK_FI_KIDNO' ##NO_TEXT.
  constants C_CHECK_FI_ALLOCATION type STRING value 'CHECK_FI_ALLOCATION' ##NO_TEXT.
  constants C_READ_FI_DOCUMENTS type STRING value 'READ_FI_DOCUMENTS' ##NO_TEXT.
  constants C_CLEAR_FI type STRING value 'CLEAR_FI' ##NO_TEXT.
  constants C_CHECK_DP_SETTLMENT type STRING value 'CHECK_DP_SETTLMENT' ##NO_TEXT.
  constants C_CHECK_ZUONR_CURRNT type STRING value 'CHECK_ZUONR_CURRNT' ##NO_TEXT.
  constants C_CREATE_CDM_WITH_WEB_SERVICE type STRING value 'CREATE_CDM_WITH_WEB_SERVICE' ##NO_TEXT.
  constants C_RELEASE_DUP_TO_ACCOUNTING type STRING value 'RELEASE_DUP_TO_ACCOUNTING' ##NO_TEXT.
  constants C_CHECK_A_BILLINGDOCUMENT type STRING value 'CHECK_A_BILLINGDOCUMENT' ##NO_TEXT.
  constants C_PARTIAL_PAYMENT type STRING value 'PARTIAL_PAYMENT' ##NO_TEXT.
  constants C_CLEAR_PARTIAL_PAYMENT type STRING value 'CLEAR_PARTIAL_PAYMENT' ##NO_TEXT.
  constants C_CHECK_BDR_SO_BP_AMOUNT type STRING value 'CHECK_BDR_SO_BP_AMOUNT' ##NO_TEXT.
  constants C_UPDATE_BD_ZUONR_XBLNR type STRING value 'UPDATE_BD_ZUONR_XBLNR' ##NO_TEXT.
  constants C_CHECK_BD_ZUONR_XBLNR type STRING value 'CHECK_BD_ZUONR_XBLNR' ##NO_TEXT.
  constants C_CHECK_VBFA_PROCESSFLOW type STRING value 'CHECK_VBFA_PROCESSFLOW' ##NO_TEXT.
  constants C_CHECK_BD_SIMUL_WO_PC type STRING value 'CHECK_BD_SIMUL_WO_PC' ##NO_TEXT.
  constants C_CHECK_BD_SIMUL_WO_EXTT type STRING value 'CHECK_BD_SIMUL_WO_EXTT' ##NO_TEXT.
  constants C_CHECK_FI_TAX_COUNTRY type STRING value 'CHECK_FI_TAX_COUNTRY' ##NO_TEXT.
  constants C_LOG_STATUS type STRING value 'LOG_STATUS' ##NO_TEXT.
  constants C_CREATE_SOAP_API_BD_W_REF type STRING value 'CREATE_SOAP_API_BD_W_REF' ##NO_TEXT.
  constants C_CHECK_EDI_SPLIT_ARIBA type STRING value 'CHECK_EDI_SPLIT_ARIBA' ##NO_TEXT.
  constants C_CHECK_EDI_OUTPUT type STRING value 'CHECK_EDI_OUTPUT' ##NO_TEXT.
  constants C_CHECK_EDI_OUTPUT_HEADER type STRING value 'CHECK_EDI_OUTPUT_HEADER' ##NO_TEXT.
  constants C_CHECK_EDI_OUTPUT_PARTY type STRING value 'CHECK_EDI_OUTPUT_PARTY' ##NO_TEXT.
  constants C_CHECK_EDI_OUTPUT_PRIC_ELEM type STRING value 'CHECK_EDI_OUTPUT_PRICING_ELEM' ##NO_TEXT.
  constants C_CHECK_EDI_OUTPUT_ITEM type STRING value 'CHECK_EDI_OUTPUT_ITEM' ##NO_TEXT.
  constants C_CHECK_EVENT type STRING value 'CHECK_EVENT' ##NO_TEXT.
  constants C_CHECK_FI_EXT_FLOW type STRING value 'CHECK_FI_EXT_FLOW' ##NO_TEXT.
  constants C_CHECK_ACCOUNT_ASSIGN_SERVICE type STRING value 'CHECK_ACCOUNT_ASSIGN_SERVICE' ##NO_TEXT.
  constants C_CHECK_ASSIGNED_BP type STRING value 'CHECK_ASSIGNED_BP' ##NO_TEXT.
  constants C_SIMULATE_PRICING_WEB_SERVICE type STRING value 'SIMULATE_PRICING_WEB_SERVICE' ##NO_TEXT.
  constants C_CHECK_ADDRESS_NUMBER type STRING value 'CHECK_ADDRESS_NUMBER' ##NO_TEXT.
  constants C_CREATE_PARTIALLY type STRING value 'CREATE_PARTIALLY' ##NO_TEXT.
  constants C_CREATE_SBI_INVOICE_BY_SOAP type STRING value 'CREATE_SBI_INVOICE_BY_SOAP' ##NO_TEXT.
  constants C_CHECK_NEW_PROJECT_BILLING type STRING value 'CHECK_NEW_PROJECT_BILLING' ##NO_TEXT.
  constants C_CHECK_NEW_PROJBILL_W_DOWNPAY type STRING value 'CHECK_NEW_PROJBILL_W_DOWNPAY' ##NO_TEXT.
  constants C_CHECK_NEW_PROJBILL_DP_SETTL type STRING value 'CHECK_NEW_PROJBILL_DP_SETTL' ##NO_TEXT.
  constants C_CHECK_NEW_PB_NO_DP_SETTL type STRING value 'CHECK_NEW_PROJBILL_NO_DP_SETTL' ##NO_TEXT.
  constants C_CHECK_BD_PRICES type STRING value 'CHECK_BD_PRICES' ##NO_TEXT.
  constants C_CHECK_LINE_ITEMS type STRING value 'CHECK_LINE_ITEMS' ##NO_TEXT.
  constants C_COMPLETE_PROFORMA type STRING value 'COMPLETE_PROFORMA' ##NO_TEXT.
  constants C_CHANGE_INVOICE_HEADER type STRING value 'CHANGE_INVOICE_HEADER' ##NO_TEXT.
  constants C_CHECK_COMPLETE_PROFORMA type STRING value 'CHECK_COMPLETE_PROFORMA' ##NO_TEXT.
  constants C_CHECK_HXF type STRING value 'CHECK_HXF' ##NO_TEXT.
  constants C_CHECK_EDI_OUTPUT_EXT_ASSOC type STRING value 'CHECK_EDI_OUTPUT_EXT_ASSC' ##NO_TEXT.
  constants C_CHECK_VCM type STRING value 'CHECK_VCM' ##NO_TEXT.
  constants C_CHECK_MSICO_VCM type STRING value 'CHECK_MSICO_VCM' ##NO_TEXT.
  constants C_WAIT type STRING value 'WAIT' ##NO_TEXT.
  constants C_CHECK_WAVWR_ADV_ICO type STRING value 'CHECK_WAVWR_ADV_ICO' ##NO_TEXT.
  constants C_CHECK_WAVWR_MS_ICO type STRING value 'CHECK_WAVWR_MS_ICO' ##NO_TEXT.
  constants C_CHECK_PROF_SEGEMENT type STRING value 'CHECK_PROFITABI_SEGMENT' ##NO_TEXT.
  constants C_CHECK_EDI_OUTPUT_HILVLITM_BT type STRING value 'CHECK_EDI_OUTPUT_HILVLITM_BTCH' ##NO_TEXT.
  constants C_CHECK_NET_VALUE_VKDFS_ADVICO type STRING value 'CHECK_NET_VALUE_VKDFS_ADVICO' ##NO_TEXT.
  constants C_CHECK_FLEX_BBI_CM_DM type STRING value 'CHECK_FLEX_BBI_CM_DM' ##NO_TEXT.
  constants C_CHECK_BATCH_SPLIT type STRING value 'CHECK_BATCH_SPLIT' ##NO_TEXT.
  constants C_CHECK_FAZ_TAX_VBRP_BSEG type STRING value 'CHECK_FAZ_TAX_VBRP_BSEG' ##NO_TEXT.
  constants C_CREATE_WITH_PPRCTR type STRING value 'CREATE_WITH_PPRCTR' ##NO_TEXT.
  constants C_CREATE_FOR_ITEM_WITH_PPRCTR type STRING value 'CREATE_FOR_ITEM_WITH_PPRCTR' ##NO_TEXT.
  constants C_CHECK_ITEM_PPRCTR type STRING value 'CHECK_BD_ITEM_PPRCTR' ##NO_TEXT.
  constants C_CREATE_WITH_VKORG type STRING value 'CREATE_WITH_VKORG' ##NO_TEXT.
  constants C_CHECK_VBRP_LAND_REGION type STRING value 'CHECK_VBRP_LAND_REGION' ##NO_TEXT.
  constants C_CHECK_VBRP_WITH_TVAP type STRING value 'CHECK_VBRP_WITH_TVAP' ##NO_TEXT.
  constants C_CHECK_ICO_SCENARIO_SPLIT_INV type STRING value 'CHECK_ICO_SCENARIO_SPLIT_INV' ##NO_TEXT.

  methods DERIVE_STEP_TYPE
    importing
      !IV_VBTYP type VBRK-VBTYP
      !IV_VCM_CHAIN_CATEGORY type VCM_CHAIN_CATEGORY
      !IV_VCM_CHAIN_ELEMENT_ID type VCM_CHAIN_ELEMENT_ID
    returning
      value(RV_STEP_TYPE) type VCM_STEP_TYPE_ID
    raising
      CX_SD_BILLING .
  methods CHECK_MULTI_CDM
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_FI_EXT_FLOW
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_FI_KIDNO
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_FI_TAX_COUNTRY
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CLEAR_PARTIAL_PAYMENT
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods PARTIAL_PAYMENT
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_A_BILLINGDOCUMENT
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_CDM_WITH_WEB_SERVICE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CLEAR_FI
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods READ_FI_DOCUMENTS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_FI_ALLOCATION
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_PRECEDING
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_AUBEL_REF
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_AUBEL_REF_BDR
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
      !BDR type VBELN
      !BIL_DOC_TO_CHECK type VBELN
      !BIL_DOC_POS_TO_CHECK type POSNR
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_PREFIX
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods INTERNAL_CHECK
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
      !LS_TESTDATA type TY_GS_PTF_BD_CHECK_TD
      !LT_VBELN type CL_PTF_UTIL=>TY_VBELN_TAB
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods INTERNAL_CHECK_V2
    importing
      !IV_STEP_NUMBER type I
      !LS_TESTDATA type TY_GS_PTF_BD_CHECK_TD
      !LT_VBELN type CL_PTF_UTIL=>TY_VBELN_TAB
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_MULTIPLE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_SEPA_MANDATE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_NUMBER_OF_POSITIONS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_POST_CREATE_FOR_COUNTRY
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_POST_CR_FOR_COUNTRIES
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_FOR_ITEM
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods API_POST_FI_CANCEL_BD_NEG
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods API_POST_FI_CANCEL_BD
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_POST_COMPARE_BD
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_GET_PDF
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_GET_PDF_NEG_NE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_GET_BD_LIST_ITEM
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_POST_CREATE_BDS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_POST_GET_BD_TYPES
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_GET_BD_ITEM
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_GET_BD
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_POST_BD_TO_ACC
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_POST_DELETE_SNAPSHOT
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_POST_CANCEL_BD
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_POST_ACTIVATE_SNAPSHOT
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_SNAPSHOT
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ACTIVATE_SNAPSHOT
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_SNAPSHOT_LOCK_CHECK
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods FILL_EXT_FIELD
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CANCEL
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods RELEASE_DUP_TO_ACCOUNTING
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods RELEASE_TO_ACCOUNTING
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CANCEL_ITEM
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_WITH_WEB_SERVICE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods INTERNAL_UPDATE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_COMPARE_BILLING_DOC
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_COMPARE_VBFA
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_CONDITION_EXISTS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
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
  methods CHECK_EXT_FIELDS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_OUTPUT
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_DYN_OUTPUT
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_PRICE_GREATER_ZERO
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_TEXT
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_TEXT_PBD
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_VBRP_WITH_TVAP
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_VBRP_LAND_REGION
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_VKDFS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_NUMBER_VKDFS_ENTRIES
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
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
  methods CHECK_PRICING_CONDITIONS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ANA_FIELDS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_XBLNR_PREDEC
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ZUONR_PREDEC
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_DP_SETTLMENT
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_BDR_SO_BP_AMOUNT
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ICO_SCENARIO_SPLIT_INV
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ZUONR_CURRNT
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods UPDATE_BD_ZUONR_XBLNR
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_BD_ZUONR_XBLNR
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ODATA_GET_SUBSQNT_BILLDOC
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_VBFA_PROCESSFLOW
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_BD_SIMUL_WO_PC
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_BD_SIMUL_WO_EXTT
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
  methods CREATE_SOAP_API_BD_W_REF
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_EDI_OUTPUT
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_EDI_OUTPUT_PARTY
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_EVENT
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_EDI_SPLIT_ARIBA
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ACCOUNT_ASSIGN_SERVICE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ASSIGNED_BP
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods SIMULATE_PRICING_WEB_SERVICE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ADDRESS_NUMBER
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_PARTIALLY
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_SBI_INVOICE_BY_SOAP
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
  methods CHECK_NEW_PROJBILL_W_DOWNPAY
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_NEW_PROJBILL_DP_SETTL
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_NEW_PROJBILL_NO_DP_SETTL
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_BD_PRICES
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_LINE_ITEMS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods COMPLETE_PROFORMA
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_COMPLETE_PROFORMA
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_HXF
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods GET_EDI_OUTPUT_INVOICE
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    returning
      value(RS_INVOICE) type EDI_CUSTOMER_INVOICE .
  methods CHECK_EDI_OUTPUT_EXT_ASSC
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_VCM
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_MSICO_VCM
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
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
      !EV_EXECUTION_STATUS type ABAP_BOOL .
  methods CHECK_WAVWR_ADV_ICO
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_WAVWR_MS_ICO
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_PROFITAB_SEGMENT
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_EDI_OUTPUT_HILVLITM_BTCH
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods SUBMIT_TEST
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods SUBMIT_AND_RETURN_TEST
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods UPDATE_TASK_TEST
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_EDI_OUTPUT_HEADER
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_EDI_OUTPUT_PRICING_ELEM
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_EDI_OUTPUT_ITEM
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHANGE_INVOICE_HEADER
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_NET_VALUE_VKDFS_ADVICO
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_BUPLA__DO_NOT_USE
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_FLEX_BBI_CM_DM
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_BATCH_SPLIT
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_SHIPTO_PARTY_AGAINST_SO
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
  methods CHECK_FAZ_TAX_VBRP_BSEG
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_WITH_PPRCTR
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_FOR_ITEM_WITH_PPRCTR
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_BD_ITEM_PPRCTR
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_SOLDTO_ADDR_OPERATION
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
ENDCLASS.



CLASS CL_PTF_BO_INVOICE IMPLEMENTATION.


  METHOD activate_snapshot.
    DATA: ls_return               TYPE bapiret2.
    DATA: ls_draft_document       TYPE  if_sd_bil_type_def=>ty_draft_document.
    DATA: lt_draft_document       TYPE  if_sd_bil_type_def=>tt_draft_document.
    DATA: ls_billing_document    TYPE if_sd_bil_type_def=>ty_billing_document,
          lt_vbeln               TYPE cl_ptf_util=>ty_vbeln_tab,
          release_to_acc_trigger TYPE cl_ptf_util=>ty_true_false_td.


    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    IF step_data-variant IS INITIAL."If no variant is given the default should be release to accounting
      release_to_acc_trigger-trigger = abap_true.
    ELSE.
      cl_ptf_util=>get_testdata(
        EXPORTING
          is_step_data = step_data
        IMPORTING
          es_testdata  = release_to_acc_trigger
      ).
    ENDIF.

    IF lt_vbeln IS NOT INITIAL.
      DATA: ls_vbeln_data TYPE vbeln.
      LOOP AT lt_vbeln INTO DATA(ls_vbeln).
        CLEAR ls_billing_document.
        DATA ls_vbuk TYPE vbuk.
        MOVE ls_vbeln-vbeln TO ls_vbeln_data.
        CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
          EXPORTING
            i_vbeln             = ls_vbeln_data
          IMPORTING
            es_vbuk             = ls_vbuk
          EXCEPTIONS
            vbeln_not_found     = 1
            vbtyp_not_supported = 2
            vbobj_not_supported = 3
            OTHERS              = 4.
        IF sy-subrc <> 0.
          RETURN.
        ELSE.
          ls_draft_document-vbeln = ls_vbeln-vbeln.
          APPEND ls_draft_document TO lt_draft_document.
        ENDIF.
      ENDLOOP.
    ELSE.
*        MESSAGE ID 'PTF'
    ENDIF.

*************************************************************************
    CALL METHOD cl_sd_bil_snapshot_facade=>if_sd_bil_dradoc_action~activate
      EXPORTING
        it_draft_document    = lt_draft_document
        iv_release_requested = release_to_acc_trigger-trigger
      IMPORTING
        et_billing_document  = DATA(lt_billing_document)
        et_message           = DATA(lt_message).

    COMMIT WORK AND WAIT.

*************************************************************************
*Check whether Billing Documents exists and create output
    DATA lv_msg_number TYPE symsgno.
    DATA lv_predec_msgno TYPE symsgno.
    DATA lv_predec_msgtype TYPE bapi_mtype.
* Write Message text in the et_return table (for Application Log.)
    LOOP AT lt_message ASSIGNING FIELD-SYMBOL(<ls_message>).
      lv_msg_number = <ls_message>-msgno.
      IF lv_predec_msgno NE <ls_message>-msgno
      AND lv_predec_msgtype NE <ls_message>-msgty.
        CALL FUNCTION 'BALW_BAPIRETURN_GET2'
          EXPORTING
            type   = <ls_message>-msgty
            cl     = <ls_message>-msgid " Message Class (Message ID)
            number = lv_msg_number " Message Number
          IMPORTING
            return = ls_return.  " BAPI Return Parameter

        me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
        LOOP AT lt_draft_document INTO ls_draft_document.
          CONCATENATE 'Document ID:' ' ' ls_draft_document-vbeln ' ' INTO ls_return-message SEPARATED BY space.
          me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
        ENDLOOP.
        lv_predec_msgno = <ls_message>-msgno.
      ENDIF.
    ENDLOOP.

    READ TABLE lt_billing_document INTO ls_billing_document INDEX 1.
    IF NOT sy-subrc IS INITIAL.
      RETURN.
    ELSE.
      LOOP AT lt_billing_document INTO ls_billing_document.
        APPEND ls_billing_document-vbeln TO ev_document_id.
      ENDLOOP.
      ev_execution_status = abap_true.
      SORT ev_document_id.
      DELETE ADJACENT DUPLICATES FROM ev_document_id COMPARING vbeln.
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
      DATA(ls_refstep_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
      IF ls_refstep_data IS NOT INITIAL.
        LOOP AT ls_refstep_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).

          lt_parameters = VALUE #(
            ( name = 'BillingDocument' value =  <ls_docid> )
          ).
*          Execute a get call to get etag; Http status is irrelevant
          lo_odata_caller->call_service(
            EXPORTING
              iv_action_or_entity = 'A_BillingDocument'
              it_parameters       = lt_parameters
            IMPORTING
              ev_status_code      = lv_status_code
              ev_status_text      = lv_status_text
              es_json_response    = ls_response_function_get
          ).

          lo_odata_caller->call_service(
            EXPORTING
              iv_method = 'POST'
              iv_action_or_entity = 'Cancel'
              it_parameters       = lt_parameters
              iv_function_import = abap_true
              iv_etag             = ls_response_function_get-d-__metadata-etag
            IMPORTING
              ev_status_code      = lv_status_code
              ev_status_text      = lv_status_text
              es_json_response    = ls_response_function
          ).

          lv_status_code_txt = lv_status_code.
          CONCATENATE 'Executed API Call Cancel with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
          me->mo_run_environment->append_log( iv_log_statement = |{ lv_msg }| ).
          IF lv_status_code = 200.
            ev_check_status = abap_true.
            ev_execution_status = abap_true.

            LOOP AT ls_response_function-d-results ASSIGNING FIELD-SYMBOL(<result>).
              IF <result>-cancellationbillingdocument IS NOT INITIAL.
                APPEND <result>-cancellationbillingdocument TO ev_document_id.
              ENDIF.
            ENDLOOP.

            SORT ev_document_id BY table_line.

            DELETE ADJACENT DUPLICATES FROM ev_document_id.

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
      CONCATENATE 'Did not execute API Call ' 'Cancel' INTO lv_msg SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
    ENDIF.
  ENDMETHOD.


  METHOD api_post_fi_cancel_bd_neg.    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/SAP/API_BILLING_DOCUMENT_SRV/'.
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

  SELECT SINGLE vbeln FROM vbrk INTO @DATA(lv_vbeln) WHERE fkart = 'F2' AND vbeln LIKE '009%'.

  lt_parameters = VALUE #(
         ( name = 'BillingDocument' value =  lv_vbeln )
       ).
*          Execute a get call to get etag; Http status is irrelevant
  lo_odata_caller->call_service(
    EXPORTING
      iv_action_or_entity = 'A_BillingDocument'
      it_parameters       = lt_parameters
    IMPORTING
      ev_status_code      = lv_status_code
      ev_status_text      = lv_status_text
      es_json_response    = ls_response_function_get
  ).

  lt_parameters = VALUE #(
         ( name = 'BillingDocument' value =  '0000000000' )
       ).

  lo_odata_caller->call_service(
    EXPORTING
      iv_method = 'POST'
      iv_action_or_entity = 'Cancel'
      it_parameters       = lt_parameters
      iv_function_import = abap_true
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
    ev_check_status = abap_false.
    ev_execution_status = abap_false.
  ELSE.
    me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
    ev_check_status = abap_true.
    ev_execution_status = abap_true.
  ENDIF.
ENDMETHOD.


METHOD cancel.

  DATA:
*    ls_return                  TYPE bapireturn1,
*    ls_message                 TYPE string,
    lt_return                  TYPE STANDARD TABLE OF bapireturn1,
*    lt_return2                 TYPE STANDARD TABLE OF bapiret2,
    lt_success                 TYPE STANDARD TABLE OF bapivbrksuccess,
    lv_vbeln_cancelled         TYPE vbeln_vf,
*    ls_vbrk_invoice            TYPE vbrk,
*    ls_vbrk_inv_cancellation   TYPE vbrk,
    iv_billing_document_number TYPE vbeln,
    lv_billing_date            TYPE dats,
    ls_testdata                TYPE ty_gs_ptf_bd_cancel_td.

  DATA:
    lt_xkomv  TYPE TABLE OF komv,
    lt_xvbfs  TYPE TABLE OF vbfs,
    lt_xvbpa  TYPE TABLE OF vbpavb,
    lt_xvbss  TYPE TABLE OF vbss,
    lt_xkomfk TYPE TABLE OF komfk,
    lt_xthead TYPE TABLE OF theadvb,
    lt_xvbrk  TYPE TABLE OF vbrkvb,
    lt_xvbrp  TYPE TABLE OF vbrpvb,
    lt_vbeln  TYPE cl_ptf_util=>ty_vbeln_tab.

*************************************************************************
  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.

  IF lt_vbeln IS INITIAL.
    me->mo_run_environment->append_log( iv_log_statement = |No referenced documents exist.| ).
    RETURN.
  ENDIF.

  IF step_data-variant IS NOT INITIAL.
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).
  ENDIF.
*************************************************************************
  IF ls_testdata-delta_invoice_date IS NOT INITIAL.
    lv_billing_date = sy-datum + ls_testdata-delta_invoice_date.
  ELSEIF ls_testdata-invoice_date IS NOT INITIAL.
    lv_billing_date = ls_testdata-invoice_date.
  ENDIF.
*************************************************************************
  LOOP AT lt_vbeln INTO iv_billing_document_number.
    CALL FUNCTION 'BAPI_BILLINGDOC_CANCEL1'
      EXPORTING
        billingdocument = iv_billing_document_number
        no_commit       = 'X'
        billingdate     = lv_billing_date
      TABLES
        return          = lt_return
        success         = lt_success.

    CALL FUNCTION 'RV_INVOICE_REFRESH'
      EXPORTING
        with_posting = 'D'
      TABLES
        xkomfk       = lt_xkomfk
        xkomv        = lt_xkomv
        xthead       = lt_xthead
        xvbfs        = lt_xvbfs
        xvbpa        = lt_xvbpa
        xvbrk        = lt_xvbrk
        xvbrp        = lt_xvbrp
        xvbss        = lt_xvbss.
*************************************************************************
*    MOVE-CORRESPONDING lt_return TO lt_return2.

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

    LOOP AT lt_success INTO DATA(ls_success).
      ASSERT ls_success-ref_doc	EQ iv_billing_document_number.
      lv_vbeln_cancelled = ls_success-bill_doc.
    ENDLOOP.

    IF lv_vbeln_cancelled IS NOT INITIAL.
      ev_execution_status = abap_true.
      APPEND lv_vbeln_cancelled TO ev_document_id.
    ELSE.
      ev_execution_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |Could not cancel document { iv_billing_document_number } | ).
    ENDIF.
  ENDLOOP.

ENDMETHOD.


METHOD cancel_item.
  DATA:
    ls_message                 TYPE string,
    lv_vbeln_cancelled         TYPE vbeln_vf,
    iv_billing_document_number TYPE vbeln,
    lt_vbrp                    TYPE TABLE OF vbrpvb,
    ls_vbrp                    TYPE vbrpvb,
    ls_xkomfk                  TYPE komfk,
    vbsk                       TYPE vbsk,
    xkomfk                     TYPE TABLE OF komfk,
    xkomv                      TYPE TABLE OF komv,
    xthead                     TYPE TABLE OF theadvb,
    xvbfs                      TYPE TABLE OF vbfs,
    xvbpa                      TYPE TABLE OF vbpavb,
    xvbrk                      TYPE TABLE OF vbrkvb,
    xvbrp                      TYPE TABLE OF vbrpvb,
    xvbss                      TYPE TABLE OF vbss,
    ls_return                  TYPE bapiret2,
    lt_vbeln                   TYPE cl_ptf_util=>ty_vbeln_tab.
*************************************************************************
  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.
*************************************************************************
  LOOP AT lt_vbeln INTO iv_billing_document_number.

    SELECT * FROM vbrp INTO TABLE lt_vbrp WHERE vbeln = iv_billing_document_number.

    READ TABLE lt_vbrp INTO ls_vbrp INDEX 1.
    CLEAR: ls_xkomfk, xkomfk.
    ls_xkomfk-vbeln = ls_vbrp-vbeln.
    ls_xkomfk-posnr = ls_vbrp-posnr.
    APPEND ls_xkomfk TO xkomfk.

    CALL FUNCTION 'RV_INVOICE_CREATE'
      EXPORTING
*       invoice_type  = ' '
*       invoice_date  = ' '
*       pricing_date  = ' '
*       delivery_date = ' '
*       select_date   = ' '
        vbsk_i = vbsk
      IMPORTING
        vbsk_e = vbsk
      TABLES
        xkomfk = xkomfk
        xthead = xthead
        xvbfs  = xvbfs
        xvbss  = xvbss
        xvbrk  = xvbrk
        xvbrp  = xvbrp
        xvbpa  = xvbpa
        xkomv  = xkomv.

    CALL FUNCTION 'RV_INVOICE_DOCUMENT_ADD'
      EXPORTING
        without_refresh = 'X'
        vbsk_i          = vbsk
      IMPORTING
        vbsk_e          = vbsk
      TABLES
        xkomfk          = xkomfk
        xkomv           = xkomv
        xthead          = xthead
        xvbfs           = xvbfs
        xvbpa           = xvbpa
        xvbrk           = xvbrk
        xvbrp           = xvbrp
        xvbss           = xvbss.

    LOOP AT xvbfs INTO DATA(ls_xvbfs).
      ls_return-id = ls_xvbfs-msgid.
      ls_return-type = ls_xvbfs-msgty.
      ls_return-number = ls_xvbfs-msgno.
      ls_return-message_v1 = ls_xvbfs-msgv1.
      ls_return-message_v2 = ls_xvbfs-msgv2.
      ls_return-message_v3 = ls_xvbfs-msgv3.
      ls_return-message_v4 = ls_xvbfs-msgv4.
    ENDLOOP.

    LOOP AT xvbrk INTO DATA(ls_vbrk).
      IF ls_vbrk-vbeln NE iv_billing_document_number.
        lv_vbeln_cancelled = ls_vbrk-vbeln.
      ENDIF.
    ENDLOOP.

    CALL FUNCTION 'RV_INVOICE_REFRESH'
*  EXPORTING
*    with_posting = ' '              " G/L account number
*    i_no_nast    = ' '              " DE-EN-LANG-SWITCH-NO-TRANSLATION
      TABLES
        xkomfk = xkomfk
        xkomv  = xkomv
        xthead = xthead
        xvbfs  = xvbfs
        xvbpa  = xvbpa
        xvbrk  = xvbrk
        xvbrp  = xvbrp
        xvbss  = xvbss.
*************************************************************************
    DATA: lv_ptf_key TYPE ptfkey.
    MOVE lv_vbeln_cancelled TO lv_ptf_key.

    ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).
    IF ev_execution_status = abap_false.
      RETURN.
    ENDIF.
  ENDLOOP.

ENDMETHOD.


METHOD change.
ENDMETHOD.


METHOD change_invoice_header.

  DATA: ls_test_data TYPE ty_gs_invoice_header_change_td,
        lt_vbeln     TYPE cl_ptf_util=>ty_vbeln_tab.
  DATA:
    ls_vbrk     TYPE vbrk,
    ls_vbsk     TYPE vbsk,
    lt_xvbrk    TYPE STANDARD TABLE OF vbrkvb,
    lt_xkomv    TYPE STANDARD TABLE OF komv,
    lt_xvbpa    TYPE STANDARD TABLE OF vbpavb,
    lt_xvbrp    TYPE STANDARD TABLE OF vbrpvb,
    lt_xvbfs    TYPE STANDARD TABLE OF vbfs,
    lt_xvbss    TYPE STANDARD TABLE OF vbss,
    lt_xtheadvb TYPE STANDARD TABLE OF theadvb,
    lt_xkomfk   TYPE STANDARD TABLE OF komfk.

  ev_execution_status = abap_false.

  cl_ptf_util=>get_testdata( EXPORTING is_step_data = step_data
                             IMPORTING es_testdata  = ls_test_data ).

  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.

  LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<ls_vbeln>).

    ls_vbrk-vbeln = <ls_vbeln>-vbeln.

    CALL FUNCTION 'RV_INVOICE_DOCUMENT_READ'
      EXPORTING
        vbrk_i = ls_vbrk
      TABLES
        xkomv  = lt_xkomv
        xvbpa  = lt_xvbpa
        xvbrk  = lt_xvbrk
        xvbrp  = lt_xvbrp.
    IF lt_xvbrk IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Read invoice { ls_vbrk-vbeln } failed| ).
      RETURN.
    ENDIF.

    READ TABLE lt_xvbrk INTO ls_vbrk INDEX 1.

    IF ls_test_data-billing_date IS NOT INITIAL.
      ls_vbrk-fkdat = ls_test_data-billing_date.
    ENDIF.
    IF ls_test_data-vat_registration_number IS NOT INITIAL.
      ls_vbrk-stceg = ls_test_data-vat_registration_number.
    ENDIF.
    IF ls_test_data-vat_country IS NOT INITIAL.
      ls_vbrk-stceg_l = ls_test_data-vat_country.
    ENDIF.

    CALL FUNCTION 'RV_INVOICE_HEAD_MAINTAIN'
      EXPORTING
        vbrk_i = ls_vbrk
      TABLES
        xkomfk = lt_xkomfk
        xthead = lt_xtheadvb
        xvbfs  = lt_xvbfs
        xvbss  = lt_xvbss
        xvbrk  = lt_xvbrk
        xvbrp  = lt_xvbrp
        xvbpa  = lt_xvbpa
        xkomv  = lt_xkomv.

    CALL FUNCTION 'RV_INVOICE_DOCUMENT_ADD'
      EXPORTING
        vbsk_i = ls_vbsk
      TABLES
        xkomfk = lt_xkomfk
        xkomv  = lt_xkomv
        xthead = lt_xtheadvb
        xvbfs  = lt_xvbfs
        xvbpa  = lt_xvbpa
        xvbrk  = lt_xvbrk
        xvbrp  = lt_xvbrp
        xvbss  = lt_xvbss.

    ev_execution_status = abap_true.
    APPEND VALUE #( vbeln = ls_vbrk-vbeln ) TO ev_document_id.
    me->mo_run_environment->append_log( iv_log_statement = |Change invoice { ls_vbrk-vbeln } successfully| ).

    CALL FUNCTION 'RV_INVOICE_REFRESH'
      EXPORTING
        with_posting = 'D'
      TABLES
        xkomfk       = lt_xkomfk
        xkomv        = lt_xkomv
        xthead       = lt_xtheadvb
        xvbfs        = lt_xvbfs
        xvbpa        = lt_xvbpa
        xvbrk        = lt_xvbrk
        xvbrp        = lt_xvbrp
        xvbss        = lt_xvbss.

  ENDLOOP.

ENDMETHOD.


METHOD check.

  DATA: ls_testdata        TYPE ty_gs_ptf_bd_check_td,
        lv_prestepnumber   TYPE LINE OF cl_ptf_util=>gt_ptf_step-reference_step,
        ls_check_step_data TYPE cl_ptf_util=>gt_ptf_step,
        lv_vbeln           TYPE vbeln,
        error_message      TYPE bapi_msg,
        ls_return          TYPE bapiret2,
        lv_error_occured   TYPE abap_bool VALUE abap_false,
        lt_vbeln           TYPE cl_ptf_util=>ty_vbeln_tab,
        ls_vbeln           TYPE LINE OF cl_ptf_util=>ty_vbeln_tab,
        var_step           TYPE string.

  DATA: ls_vbrk_i TYPE vbrk,
        ls_vbrk_e TYPE vbrk,
        lt_xvbrk  TYPE TABLE OF vbrkvb,
        lt_xvbrp  TYPE TABLE OF vbrpvb,
        lt_xkomv  TYPE TABLE OF komv,
        lt_xvbpa  TYPE TABLE OF vbpavb.

  DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

  ev_check_status = abap_false.

  "This check method works with and without Test Data Container Variant
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
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.
  IF lt_vbeln IS INITIAL.
    me->mo_run_environment->append_log( 'There are no documentIDs to check!' ).
    RETURN.
  ENDIF.

  SELECT COUNT( * ) FROM vbrk INTO @DATA(lv_count) FOR ALL ENTRIES IN @lt_vbeln WHERE vbeln = @lt_vbeln-vbeln(10).
  IF lv_count IS INITIAL.
    me->mo_run_environment->append_log( iv_log_statement = 'No document found in VBRK for the given number(s).' ).
    ev_execution_status = abap_false.
    RETURN.
  ELSEIF lv_count < lines( lt_vbeln ).
    me->mo_run_environment->append_log( iv_log_statement = 'WARNING: Not all IDs given in refSteps are found in VBRK.' ).
  ENDIF.


  me->internal_check(
    EXPORTING
      step_data           = ls_step_data
      iv_step_number      = iv_step_number
      ls_testdata         = ls_testdata
      lt_vbeln            = lt_vbeln
    IMPORTING
      ev_document_id      = ev_document_id
      ev_execution_status = ev_execution_status
      ev_check_status     = ev_check_status
  ).

ENDMETHOD.


METHOD check_account_assign_service.
  DATA: lt_vbeln            TYPE cl_ptf_util=>ty_vbeln_tab,
        lt_item             TYPE STANDARD TABLE OF vbrp,
        lv_service_doc      TYPE crmt_object_id_db,
        lv_service_item     TYPE crms4_number_int,
        lv_service_doc_type TYPE crmt_process_type_db,
        lv_header_guid      TYPE crmt_object_guid,
        lv_item_guid        TYPE crmt_object_guid,
        lv_srv_ord_guid     TYPE crmt_object_guid,
        lv_objkey_a         TYPE crmt_doc_flow_id,
        lv_objkey_b         TYPE crmt_doc_flow_id.

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

  ev_check_status = abap_true.
  LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<document>).

    SELECT vbeln posnr vgbel vgpos vgtyp service_doc_type service_doc_id service_doc_item_id
           INTO CORRESPONDING FIELDS OF TABLE lt_item
           FROM vbrp
           WHERE vbeln = <document>.

    LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<ls_item>).
* Determine Service Order item
      DATA(lv_vgbel) = <ls_item>-vgbel.
      DATA(lv_vgpos) = <ls_item>-vgpos.
      DATA(lv_vgtyp) = <ls_item>-vgtyp.
      CLEAR: lv_service_doc, lv_service_item, lv_service_doc_type.
      DO 4 TIMES.
        CASE lv_vgtyp.
          WHEN 'K'. "Credit Memo Request.
            SELECT SINGLE vgbel vgpos vgtyp INTO ( lv_vgbel, lv_vgpos, lv_vgtyp )
                                            FROM vbap
                                            WHERE vbeln = lv_vgbel
                                            AND   posnr = lv_vgpos.
          WHEN 'M' OR 'EBDR'. "Invoice or BDR
            SELECT SINGLE vgbel vgpos vgtyp INTO ( lv_vgbel, lv_vgpos, lv_vgtyp )
                                            FROM vbrp
                                            WHERE vbeln = lv_vgbel
                                            AND   posnr = lv_vgpos.
          WHEN 'CSVO'. "Service Order
            SELECT SINGLE item_guid INTO lv_item_guid FROM crms4d_serv_i
                                    WHERE objtype_h  = 'BUS2000116'
                                    AND   object_id  = lv_vgbel
                                    AND   number_int = lv_vgpos.
            " also check for service hierarchy and price items
            cl_crms4_srv_bundle_util=>get_instance( )->if_crms4_srv_bundle_util~get_item_for_accounting(
                              EXPORTING iv_item_guid           = lv_item_guid
                              IMPORTING ev_service_doc_item_id = lv_service_item
                                        ev_service_doc_id      = lv_service_doc
                                        ev_service_doc_type    = lv_service_doc_type
                              EXCEPTIONS OTHERS = 0 ).

*            lv_service_doc = lv_vgbel.
*            lv_service_item = lv_vgpos.
*            SELECT SINGLE process_type INTO lv_service_doc_type
*                                       FROM crms4d_serv_h
*                                       WHERE objtype_h = 'BUS2000116'
*                                       AND   object_id = lv_service_doc.
            EXIT.
          WHEN 'CSCO'. "Service Confirmation
            SELECT SINGLE header_guid INTO lv_header_guid FROM crms4d_serv_h
                                      WHERE objtype_h = 'BUS2000117'
                                      AND   object_id = lv_vgbel.

            SELECT SINGLE item_guid INTO lv_item_guid FROM crms4d_serv_i
                                    WHERE objtype_h  = 'BUS2000117'
                                    AND   object_id  = lv_vgbel
                                    AND   number_int = lv_vgpos.

            SELECT SINGLE h~objguid_a_sel i~objkey_a
                          INTO (lv_srv_ord_guid, lv_objkey_a)
                          FROM crmd_brelvonae AS h
                          INNER JOIN crmd_brelvonai AS i
                          ON h~relationid = i~relationid
                          WHERE h~objguid_b_sel = lv_header_guid
                          AND   h~objtype_a_sel = 'BUS2000116'
                          AND   i~objkey_b = lv_item_guid.

            SELECT SINGLE object_id INTO lv_service_doc FROM crms4d_serv_h
                                    WHERE objtype_h = 'BUS2000116'
                                    AND   header_guid = lv_srv_ord_guid.

            lv_item_guid = lv_objkey_a.
            " also check for service hierarchy and price items
            cl_crms4_srv_bundle_util=>get_instance( )->if_crms4_srv_bundle_util~get_item_for_accounting(
                              EXPORTING iv_item_guid           = lv_item_guid
                              IMPORTING ev_service_doc_item_id = lv_service_item
                                        ev_service_doc_id      = lv_service_doc
                                        ev_service_doc_type    = lv_service_doc_type
                              EXCEPTIONS OTHERS = 0 ).

*            SELECT SINGLE number_int INTO lv_service_item FROM crms4d_serv_i
*                                     WHERE objtype_h   = 'BUS2000116'
*                                     AND   header_guid = lv_srv_ord_guid
*                                     AND   item_guid   = lv_item_guid.
*
*            SELECT SINGLE process_type INTO lv_service_doc_type
*                                       FROM crms4d_serv_h
*                                       WHERE objtype_h = 'BUS2000116'
*                                       AND   object_id = lv_service_doc.
            EXIT.

          WHEN OTHERS.
            me->mo_run_environment->append_log( iv_log_statement = |Unknown Predecessor for document { <ls_item>-vbeln } Item { <ls_item>-posnr }.| ).
            ev_check_status = abap_false.
            EXIT.
        ENDCASE.
      ENDDO.

      IF lv_service_doc <> <ls_item>-service_doc_id OR
         lv_service_item <> <ls_item>-service_doc_item_id OR
         lv_service_doc_type <> <ls_item>-service_doc_type.
        me->mo_run_environment->append_log( iv_log_statement = |Account Assignment incorrect for document { <ls_item>-vbeln } Item { <ls_item>-posnr } .| ).
        ev_check_status = abap_false.
      ENDIF.

    ENDLOOP.

  ENDLOOP.

  ev_execution_status = abap_true.

ENDMETHOD.


METHOD check_address_number.
  TYPES:
    BEGIN OF ty_vbeln,
      vbeln TYPE vbeln,
    END OF ty_vbeln,
    ty_vbeln_tab TYPE STANDARD TABLE OF ty_vbeln WITH NON-UNIQUE KEY vbeln,
    BEGIN OF ty_result,
      vbeln TYPE vbeln,
      parvw TYPE parvw,
      adrnr TYPE adrnr,
    END OF ty_result.

  DATA: lt_vbeln          TYPE cl_ptf_util=>ty_vbeln_tab,
        lv_vbeln          TYPE vbeln,
        lt_vbeln_cast     TYPE ty_vbeln_tab,
        test_data         TYPE ty_gs_partner_addr_check,
        lv_vbpa           TYPE TABLE OF vbpa,
        lv_vbrk           TYPE TABLE OF vbrk,
        lv_vbrp           TYPE TABLE OF vbrp,
        lt_result         TYPE TABLE OF ty_result,
        index             TYPE i,
        lv_adrc           TYPE ty_gs_i_ptf_partner_addr,
        wa_curr_test_data LIKE LINE OF test_data-partner_addr.



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


  lt_vbeln_cast = lt_vbeln.
  READ TABLE lt_vbeln INDEX 1 INTO lv_vbeln.

*   2. Step: No business partner fields should be initial
  ev_check_status = abap_true.
  ev_execution_status = abap_true.

  DATA(lv_actual_switch_state) = cl_bupa_multiple_addresses=>if_bupa_multiple_addresses~is_o2c_multiple_addr_active( ).
*  DATA(lv_feature_on) = cl_feature_toggle=>is_active( iv_toggle_id = if_bupa_multiple_addresses=>feature_toggle-o2c_multi_bp_addr ).

  IF lv_actual_switch_state EQ abap_true.

    SELECT vbeln, parvw, adrnr
     FROM vbpa
     INNER JOIN but020 ON vbpa~kunnr = but020~partner AND vbpa~adrnr = but020~addrnumber
     FOR ALL ENTRIES IN @lt_vbeln_cast
     WHERE vbeln = @lt_vbeln_cast-vbeln
     INTO TABLE @lt_result.

    IF lt_result IS INITIAL.
      ev_check_status = abap_false.
      me->mo_run_environment->append_log(
        iv_log_statement = |None of your documents Addresses have been read from BUT020. | ).
    ELSEIF lt_result IS NOT INITIAL.
      me->mo_run_environment->append_log(
        iv_log_statement = |Reading from BUT020 is enabled. | ).
      ev_check_status = abap_true.


      LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<fs_result>).
        LOOP AT test_data-partner_addr INTO wa_curr_test_data WHERE parvw = <fs_result>-parvw.

          SELECT SINGLE city1, post_code1, street, house_num1 FROM adrc WHERE addrnumber = @<fs_result>-adrnr INTO CORRESPONDING FIELDS OF @lv_adrc.
          IF wa_curr_test_data-city1 NE lv_adrc-city1 OR wa_curr_test_data-post_code1 NE lv_adrc-post_code1 OR wa_curr_test_data-street NE lv_adrc-street OR wa_curr_test_data-house_num1 NE lv_adrc-house_num1.
            ev_check_status = abap_false.
            me->mo_run_environment->append_log(
                iv_log_statement = |For billing document { <fs_result>-vbeln } the address data is not correct for the partner function { <fs_result>-parvw } |  ).
          ELSE.
            me->mo_run_environment->append_log(
                iv_log_statement = |For billing document { <fs_result>-vbeln } the address data is correctly read for the partner function { <fs_result>-parvw } |  ).
          ENDIF.

        ENDLOOP.

      ENDLOOP.




    ENDIF.

  ELSE.
    ev_check_status = abap_false.
    ev_execution_status = abap_false.
    me->mo_run_environment->append_log(
      iv_log_statement = |Switch for multiple BP addresses is not active. | ).
  ENDIF.






ENDMETHOD.


METHOD check_ana_fields.

  DATA: documents_to_check TYPE TABLE OF vbeln.
  DATA(current_step) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

  LOOP AT current_step-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
    DATA(documents) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
    LOOP AT documents ASSIGNING FIELD-SYMBOL(<document>).
      APPEND <document> TO documents_to_check.
    ENDLOOP.
  ENDLOOP.

  "Documents_to_check beinhaltet alle BD
  ev_check_status = abap_true.
  LOOP AT documents_to_check ASSIGNING FIELD-SYMBOL(<vbeln>).

    SELECT SINGLE mandt     ,
                  vbeln     ,
                  vbtyp     ,
                  fkart     ,
                  vkorg     ,
                  vtweg     ,
                  konda     ,
                  kdgrp     ,
                  land1     ,
                  regio     ,
                  cityc     ,
                  bzirk     ,
                  gbstk     ,
                  vf_status ,
                  kunag     ,
                  kunrg     ,
                  fkdat     ,
                  bukrs     ,
                  counc     ,
                  knuma     ,
                  fktyp     ,
                  kunwe     ,
                  knumv     ,
                  sfakn
                  FROM vbrk WHERE vbeln = @<vbeln> INTO @DATA(bd_header).

    SELECT        pospa         ,
                  vbtyp_ana     ,
                  fkart_ana     ,
                  vkorg_ana     ,
                  vtweg_ana     ,
                  konda_ana     ,
                  kdgrp_ana     ,
                  land1_ana     ,
                  regio_ana     ,
                  cityc_ana     ,
                  bzirk_ana     ,
                  gbstk_ana     ,
                  vf_status_ana ,
                  kunag_ana     ,
                  kunrg_ana     ,
                  fkdat_ana     ,
                  bukrs_ana     ,
                  counc_ana     ,
                  knuma_ana     ,
                  fktyp_ana     ,
                  kunwe_ana     ,
                  kunre_ana     ,
                  perve_ana     ,
                  perzm_ana     ,
                  knumv_ana     ,
                  sfakn_ana
                  FROM vbrp WHERE vbeln = @<vbeln> INTO TABLE @DATA(bd_positions).

    SELECT pernr, kunnr, parvw, posnr FROM vbpa WHERE vbeln = @<vbeln> INTO TABLE @DATA(partner_data).
    SORT partner_data BY parvw posnr.
    LOOP AT bd_positions ASSIGNING FIELD-SYMBOL(<bd_pos>).
      READ TABLE partner_data WITH KEY parvw = 'WE' posnr = <bd_pos>-pospa INTO DATA(we_partner) BINARY SEARCH.
      IF sy-subrc <> 0.
        READ TABLE partner_data WITH KEY parvw = 'WE' posnr = '000000' INTO we_partner BINARY SEARCH.
      ENDIF.
      READ TABLE partner_data WITH KEY parvw = 'RE' posnr = <bd_pos>-pospa INTO DATA(re_partner) BINARY SEARCH.
      IF sy-subrc <> 0.
        READ TABLE partner_data WITH KEY parvw = 'RE' posnr = '000000' INTO re_partner BINARY SEARCH.
      ENDIF.
      READ TABLE partner_data WITH KEY parvw = 'VE' posnr = <bd_pos>-pospa INTO DATA(ve_partner) BINARY SEARCH.
      IF sy-subrc <> 0.
        READ TABLE partner_data WITH KEY parvw = 'VE' posnr = '000000' INTO ve_partner BINARY SEARCH.
      ENDIF.
      READ TABLE partner_data WITH KEY parvw = 'ZM' posnr = <bd_pos>-pospa INTO DATA(zm_partner) BINARY SEARCH.
      IF sy-subrc <> 0.
        READ TABLE partner_data WITH KEY parvw = 'ZM' posnr = '000000' INTO zm_partner BINARY SEARCH.
      ENDIF.

      IF   <bd_pos>-vbtyp_ana     NE bd_header-vbtyp
        OR <bd_pos>-fkart_ana     NE bd_header-fkart
        OR <bd_pos>-vkorg_ana     NE bd_header-vkorg
        OR <bd_pos>-vtweg_ana     NE bd_header-vtweg
        OR <bd_pos>-konda_ana     NE bd_header-konda
        OR <bd_pos>-kdgrp_ana     NE bd_header-kdgrp
        OR <bd_pos>-land1_ana     NE bd_header-land1
        OR <bd_pos>-regio_ana     NE bd_header-regio
        OR <bd_pos>-cityc_ana     NE bd_header-cityc
        OR <bd_pos>-bzirk_ana     NE bd_header-bzirk
        OR <bd_pos>-gbstk_ana     NE bd_header-gbstk
        OR <bd_pos>-vf_status_ana NE bd_header-vf_status
        OR <bd_pos>-kunag_ana     NE bd_header-kunag
        OR <bd_pos>-kunrg_ana     NE bd_header-kunrg
        OR <bd_pos>-fkdat_ana     NE bd_header-fkdat
        OR <bd_pos>-bukrs_ana     NE bd_header-bukrs
        OR <bd_pos>-counc_ana     NE bd_header-counc
        OR <bd_pos>-knuma_ana     NE bd_header-knuma
        OR <bd_pos>-fktyp_ana     NE bd_header-fktyp
        OR <bd_pos>-knumv_ana     NE bd_header-knumv
        OR <bd_pos>-sfakn_ana     NE bd_header-sfakn
        OR <bd_pos>-kunwe_ana     NE we_partner-kunnr
        OR <bd_pos>-kunre_ana     NE re_partner-kunnr
        OR <bd_pos>-perve_ana     NE ve_partner-pernr
        OR <bd_pos>-perzm_ana     NE zm_partner-pernr.
        ev_check_status = abap_false.
        me->mo_run_environment->append_log( iv_log_statement = |Ana FIELD duplication failed for document { <vbeln> }| ).
      ENDIF.

    ENDLOOP.
  ENDLOOP.
  ev_execution_status = abap_true.
ENDMETHOD.


METHOD check_assigned_bp.
  TYPES:
    BEGIN OF ty_vbeln,
      vbeln TYPE vbeln,
    END OF ty_vbeln,
    ty_vbeln_tab TYPE STANDARD TABLE OF ty_vbeln WITH NON-UNIQUE KEY vbeln.

  DATA: lt_vbeln      TYPE cl_ptf_util=>ty_vbeln_tab,
        lt_vbeln_cast TYPE ty_vbeln_tab.

*   1. Step: Get Presteps
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

  lt_vbeln_cast = lt_vbeln.

*   2. Step: No business partner fields should be initial
  ev_check_status = abap_true.
  SELECT vbeln, posnr, parvw
    FROM vbpa
    FOR ALL ENTRIES IN @lt_vbeln_cast
    WHERE vbeln = @lt_vbeln_cast-vbeln
      AND ( assigned_bp = ' '
        OR addr_operation = ' '
        OR addr_type = ' ' )
    INTO TABLE @DATA(lt_result).


*     3. Step: Display Error Log
  IF lt_result IS NOT INITIAL.
    me->mo_run_environment->append_log(
      iv_log_statement = |A business partner field is initial. | ).
    ev_check_status = abap_false.
  ENDIF.

*      LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<ls_result>).
*        me->mo_run_environment->append_log(
*           iv_log_statement = |A business partner field is empty for SD Document { <ls_result>-vbeln }, Item { <ls_result>-posnr }, Partner Function { <ls_result>-parvw } | ).
*        ev_check_status = abap_false.
*      ENDLOOP.

  ev_execution_status = abap_true.

ENDMETHOD.


METHOD check_aubel_ref.

  DATA: lt_vbeln TYPE cl_ptf_util=>ty_vbeln_tab.

  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.

  ev_check_status = abap_true.

  LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<billing_doc>).

    SELECT vbeln, posnr, autyp, aubel, aupos FROM vbrp WHERE vbeln = @<billing_doc>-vbeln ORDER BY posnr INTO TABLE @DATA(bil_doc_positions).

    LOOP AT bil_doc_positions ASSIGNING FIELD-SYMBOL(<bil_doc_pos>).

      SELECT SINGLE vbelv, posnv, vbtyp_v FROM vbfa WHERE vbeln = @<bil_doc_pos>-vbeln AND posnn = @<bil_doc_pos>-posnr INTO @DATA(vbfa_data).

      CASE vbfa_data-vbtyp_v.
        WHEN 'EBDR'.
          me->check_aubel_ref_bdr(
            EXPORTING
              step_data             = step_data
              iv_step_number        = iv_step_number
              bdr                   = vbfa_data-vbelv
              bil_doc_to_check      = <bil_doc_pos>-vbeln
              bil_doc_pos_to_check  = <bil_doc_pos>-posnr
            IMPORTING
              ev_document_id      = ev_document_id
              ev_execution_status = ev_execution_status
              ev_check_status     = ev_check_status
          ).
        WHEN OTHERS.
          me->mo_run_environment->append_log( iv_log_statement = |A check for the correct aubel behavior for the preceding doc type { vbfa_data-vbtyp_v } is not yet implemented.| ).
          ev_check_status = abap_false.
      ENDCASE.

    ENDLOOP.

  ENDLOOP.

  ev_execution_status = abap_true.

ENDMETHOD.


METHOD check_aubel_ref_bdr.

  SELECT SINGLE fkart FROM vbrk WHERE vbeln = @bdr INTO @DATA(billing_type).

  CASE billing_type.
    WHEN 'BDR1'.

      SELECT SINGLE posnv FROM vbfa WHERE vbeln = @bil_doc_to_check AND posnn = @bil_doc_pos_to_check INTO @DATA(bdr_pos).

      SELECT SINGLE autyp, aubel, aupos FROM vbrp
        WHERE vbeln = @bdr AND posnr = @bdr_pos AND ( aubel IS NOT INITIAL OR aupos IS NOT INITIAL )
        INTO @DATA(bdr_aubel_aupos).

      SELECT SINGLE autyp, aubel, aupos FROM vbrp WHERE vbeln = @bil_doc_to_check AND posnr = @bil_doc_pos_to_check INTO @DATA(bd_aubel_aupos).

      IF bdr_aubel_aupos IS NOT INITIAL.


        IF bdr_aubel_aupos-aubel NE bd_aubel_aupos-aubel.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |Value of { bil_doc_to_check }-AUBEL is not as expected.| ).
          me->mo_run_environment->append_log( iv_log_statement = |Expected: { bdr_aubel_aupos-aubel }| ).
          me->mo_run_environment->append_log( iv_log_statement = |Actual: { bd_aubel_aupos-aubel }| ).
        ENDIF.

        IF bdr_aubel_aupos NE bd_aubel_aupos-aupos.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |Value of { bil_doc_to_check }-AUPOS is not as expected.| ).
          me->mo_run_environment->append_log( iv_log_statement = |Expected: { bdr_aubel_aupos-aupos }| ).
          me->mo_run_environment->append_log( iv_log_statement = |Actual: { bd_aubel_aupos-aupos }| ).
        ENDIF.

        IF bdr_aubel_aupos NE bd_aubel_aupos-autyp.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |Value of { bil_doc_to_check }-AUTYP is not as expected.| ).
          me->mo_run_environment->append_log( iv_log_statement = |Expected: { bdr_aubel_aupos-autyp }| ).
          me->mo_run_environment->append_log( iv_log_statement = |Actual: { bd_aubel_aupos-autyp }| ).

        ENDIF.

      ELSE.

        SELECT SINGLE vbelv, posnv, vbtyp_v FROM vbfa WHERE vbeln = @bil_doc_to_check AND posnn = @bil_doc_pos_to_check INTO @DATA(vbfa_data).

        IF vbfa_data-vbelv NE bd_aubel_aupos-aubel.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |Value of { bil_doc_to_check }-AUBEL is not as expected.| ).
          me->mo_run_environment->append_log( iv_log_statement = |Expected: { vbfa_data-vbelv }| ).
          me->mo_run_environment->append_log( iv_log_statement = |Actual: { bd_aubel_aupos-aubel }| ).
        ENDIF.

        IF vbfa_data-posnv NE bd_aubel_aupos-aupos.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |Value of { bil_doc_to_check }-AUPOS is not as expected.| ).
          me->mo_run_environment->append_log( iv_log_statement = |Expected: { vbfa_data-posnv }| ).
          me->mo_run_environment->append_log( iv_log_statement = |Actual: { bd_aubel_aupos-aupos }| ).
        ENDIF.

        IF vbfa_data-vbtyp_v NE bd_aubel_aupos-autyp.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |Value of { bil_doc_to_check }-AUTYP is not as expected.| ).
          me->mo_run_environment->append_log( iv_log_statement = |Expected: { vbfa_data-vbtyp_v }| ).
          me->mo_run_environment->append_log( iv_log_statement = |Actual: { bd_aubel_aupos-autyp }| ).

        ENDIF.

      ENDIF.

    WHEN OTHERS.

      me->mo_run_environment->append_log( iv_log_statement = |Aubel Check for BDR of type { billing_type } not yet implemented.| ).
      ev_check_status = abap_false.

  ENDCASE.

ENDMETHOD.


METHOD check_a_billingdocument.
  DATA lv_service_uri TYPE string VALUE '/sap/opu/odata/SAP/API_BILLING_DOCUMENT_SRV/'.
  DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
  DATA lt_parameters TYPE /iwfnd/sutil_property_t.
  DATA: lv_status_text TYPE string,
        lv_status_code TYPE integer.
  DATA: ls_return     TYPE bapiret2.
  DATA: lv_msg             TYPE string,
        lv_status_code_txt TYPE string,
        test_data          TYPE tt_check_a_billingdocument.
  TYPES: BEGIN OF ty_functionimportresult,
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
           overallpricingincompletionsts  TYPE string,
           invoiceclearingstatus          TYPE string,
           billingdocumentlisttype        TYPE string,
           billingdocumentlistdate        TYPE string,
         END OF ty_functionimportresult.

  DATA: BEGIN OF ls_response_function,
          d TYPE ty_functionimportresult,
        END OF ls_response_function.

  FIELD-SYMBOLS: <field_value> TYPE any.

  cl_ptf_util=>get_testdata(
    EXPORTING
      is_step_data = step_data
    IMPORTING
      es_testdata  = test_data
  ).

  IF test_data IS INITIAL.
    me->mo_run_environment->append_log( iv_log_statement = |Nothing to check.| ).
    ev_check_status = abap_false.
    ev_execution_status = abap_true.
    RETURN.
  ENDIF.

  ev_check_status = abap_true.
  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
    DATA(ls_refstep_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
    IF ls_refstep_data IS NOT INITIAL.
      LOOP AT ls_refstep_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).

        lt_parameters = VALUE #(
          ( name = 'BillingDocument' value =  <ls_docid> )
        ).
*          Execute a get call to get etag; Http status is irrelevant
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
        CONCATENATE 'Executed API Call GET A_BillingDocument with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
        me->mo_run_environment->append_log( iv_log_statement = |{ lv_msg }| ).
        IF lv_status_code NE 200.
          me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
          ev_check_status = abap_false.
          RETURN.
        ENDIF.

        LOOP AT test_data ASSIGNING FIELD-SYMBOL(<field_to_check>).
          ASSIGN COMPONENT <field_to_check>-fieldname OF STRUCTURE ls_response_function-d TO <field_value>.
          IF <field_value> NE <field_to_check>-fieldvalue.
            ev_check_status = abap_false.
            me->mo_run_environment->append_log( iv_log_statement = |Field: { <field_to_check>-fieldname } Expected: { <field_to_check>-fieldvalue } Actual: { <field_value> }| ).
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDIF.
  ENDLOOP.
  ev_execution_status = abap_true.
ENDMETHOD.


METHOD check_batch_split.
  DATA: lt_vbeln TYPE if_sd_bil_type_def=>tt_billing_document.

* Step 1: Get referenced documents
  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    IF lines( lt_ptf_keys ) EQ 0.
      me->mo_run_environment->append_log( iv_log_statement = |No documents found for step { <lv_ref_step> }| ).
    ENDIF.
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.

  IF lines( lt_vbeln ) EQ 0.
    me->mo_run_environment->append_log( iv_log_statement = |Nothing to check.| ).
    RETURN.
  ENDIF.

  SELECT vbeln, posnr, fkimg, charg, wavwr, uecha, batch_billing_variant
    FROM vbrp
    FOR ALL ENTRIES IN @lt_vbeln
    WHERE vbeln = @lt_vbeln-vbeln
    INTO TABLE @DATA(lt_bd_items).

* Step 2: Perform checks
  LOOP AT lt_bd_items ASSIGNING FIELD-SYMBOL(<ls_bd_item>).
    "batch main item
    IF <ls_bd_item>-posnr EQ <ls_bd_item>-uecha.
      IF <ls_bd_item>-wavwr IS NOT INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |Batch split is expected. Costs must be zero on batch main item.| ).
        RETURN.
      ENDIF.
      IF <ls_bd_item>-charg IS NOT INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |Batch split is expected. Batch number must not be on batch main item.| ).
        RETURN.
      ENDIF.
      IF <ls_bd_item>-batch_billing_variant EQ 'B'.
        IF <ls_bd_item>-fkimg NE 0.
          me->mo_run_environment->append_log( iv_log_statement = |Billing quantity of batch main item having batch_billing_variant B is expected to be zero.| ).
          RETURN.
        ENDIF.
      ELSE.
        IF <ls_bd_item>-fkimg EQ 0.
          me->mo_run_environment->append_log( iv_log_statement = |Billing quantity of batch subitem having batch_billing_variant A or no variant is expected to be greater than zero.| ).
          RETURN.
        ENDIF.
      ENDIF.
      "batch subitem
    ELSEIF <ls_bd_item>-uecha IS NOT INITIAL AND <ls_bd_item>-uecha NE <ls_bd_item>-posnr.
      IF <ls_bd_item>-wavwr IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |Batch split is expected. Costs must be on batch subitem.| ).
        RETURN.
      ENDIF.
      IF <ls_bd_item>-charg IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |Batch split is expected. Batch Number must be on batch subitem.| ).
        RETURN.
      ENDIF.
      IF <ls_bd_item>-batch_billing_variant EQ 'B'.
        IF <ls_bd_item>-fkimg EQ 0.
          me->mo_run_environment->append_log( iv_log_statement = |Billing quantity of batch subitem having batch_billing_variant B is expected to be greater than zero.| ).
          RETURN.
        ENDIF.
      ELSE.
        IF <ls_bd_item>-fkimg NE 0.
          me->mo_run_environment->append_log( iv_log_statement = |Billing quantity of batch subitem having batch_billing_variant A or no variant is expected to be zero.| ).
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.

* Step 3: Set success message and status
  ev_check_status = abap_true.
  me->mo_run_environment->append_log( iv_log_statement = |Check was successful.| ).
ENDMETHOD.


METHOD check_bdr_so_bp_amount.

  TYPES:
    BEGIN OF tyv_vbeln,
      vbeln TYPE vbeln,
    END OF tyv_vbeln .
  TYPES:
    tyt_vbeln_tab      TYPE STANDARD TABLE OF tyv_vbeln WITH NON-UNIQUE KEY vbeln .

  DATA: lv_vbeln_vf   TYPE vbeln,
        lt_vbeln_vf   TYPE cl_ptf_util=>ty_vbeln_tab,
        lt_vbeln      TYPE tyt_vbeln_tab,
        lt_vbrk       TYPE STANDARD TABLE OF vbrk,
        ls_vbrk       TYPE vbrk,
        lt_vbrp       TYPE STANDARD TABLE OF vbrp,
        ls_vbrp       TYPE vbrp,
        lv_anz_amount TYPE netwr_fp,
        lv_bdr_amount TYPE netwr_fp.


  DATA(ls_step_data_this_check) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

  ev_check_status = abap_false.

  LOOP AT ls_step_data_this_check-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln_vf.
  ENDLOOP.
  IF lt_vbeln_vf IS INITIAL.
    me->mo_run_environment->append_log( 'There are no documentIDs to check!' ).
    RETURN.
  ENDIF.
*  READ TABLE lt_vbeln_vf INDEX 1 INTO lv_vbeln_vf.
*  CHECK lv_vbeln_vf IS NOT INITIAL.
*  SELECT SINGLE * FROM vbrk INTO ls_vbrk WHERE vbeln = lv_vbeln_vf.

  " select vbrk
  LOOP AT lt_vbeln_vf REFERENCE INTO DATA(lr_vbeln_vf).
    lv_vbeln_vf = lr_vbeln_vf->vbeln.
    APPEND lv_vbeln_vf TO lt_vbeln.
  ENDLOOP.
  CHECK lt_vbeln IS NOT INITIAL.
  SELECT * FROM vbrk INTO TABLE @lt_vbrk FOR ALL ENTRIES IN @lt_vbeln WHERE vbeln = @lt_vbeln-vbeln.
  IF sy-subrc IS NOT INITIAL.
    me->mo_run_environment->append_log( |BillingDoc { lv_vbeln_vf } not found. | ).
    RETURN.
  ENDIF.

  " select vbrp
  CLEAR: lt_vbeln.
  LOOP AT lt_vbrk REFERENCE INTO DATA(lr_vbrk).
    IF lr_vbrk->fktyp NE 'P'.
      lv_vbeln_vf = lr_vbrk->vbeln.
      APPEND lv_vbeln_vf TO lt_vbeln.
    ENDIF.
  ENDLOOP.
  CHECK lt_vbeln IS NOT INITIAL.
  SELECT * FROM vbrp INTO TABLE @lt_vbrp FOR ALL ENTRIES IN @lt_vbeln WHERE vbeln = @lt_vbeln-vbeln.
  LOOP AT lt_vbrp INTO ls_vbrp.
    IF ls_vbrp-kowrr EQ 'Y'.
      lv_anz_amount = ls_vbrp-netwr.
    ENDIF.
    IF ls_vbrp-vgtyp EQ 'EBDR'.
      lv_bdr_amount = ls_vbrp-netwr.
    ENDIF.
  ENDLOOP.

  IF lv_anz_amount IS INITIAL.
    me->mo_run_environment->append_log( |Amount of down payment settlememt is initial | ).
    RETURN.
  ENDIF.
  IF lv_bdr_amount IS INITIAL.
    me->mo_run_environment->append_log( |Amount of billing document request is initial | ).
    RETURN.
  ENDIF.
  IF lv_anz_amount EQ lv_bdr_amount.
    me->mo_run_environment->append_log( |Amount of DP settlement and amount of BDR are equal | ).
    RETURN.
  ENDIF.

  me->mo_run_environment->append_log( |Check OK: Amount of DP settlement and amount of BDR are not equal.| ).
  ev_check_status = abap_true.
  ev_execution_status = abap_true.

ENDMETHOD.


  METHOD check_bd_item_pprctr.
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
  ENDMETHOD.


METHOD check_bd_prices.
*No Checks are planned in this method for now. All relevant data will be checked in Execute_Action.
*Checks might be implemented for ODATA Calls
  ev_check_status = abap_true.

  IF ev_check_status = abap_true.
    me->mo_run_environment->append_log( |'Check method successfully finished.'| ).
    ev_execution_status = abap_true.
  ENDIF.
ENDMETHOD.


METHOD check_bd_simul_wo_extt.


  DATA:
    lv_vbeln              TYPE vbeln,
    lt_vbeln              TYPE cl_ptf_util=>ty_vbeln_tab,
    lv_ref_step           TYPE cl_ptf_util=>gty_ref_step,
    lt_ref_step           TYPE cl_ptf_util=>gty_reference_tab,
    lv_vbtyp              TYPE vbtypl,
    lv_vbrk_bd_ex         TYPE abap_bool,
    go_pricing_parameters TYPE REF TO cl_pricing_parameters.

  DATA:
    ls_vbsk         TYPE vbsk,
    ls_xkomfk       TYPE komfk,
    lt_xkomfk       TYPE STANDARD TABLE OF komfk,
    lt_excl_func    TYPE tt_ocb_fncltyname,
    lt_bill_message TYPE STANDARD TABLE OF vbfs,
    lt_xvbpa        TYPE STANDARD TABLE OF vbpavb,
    lt_xvbss        TYPE STANDARD TABLE OF vbss,
    lt_xthead       TYPE STANDARD TABLE OF theadvb,
    lt_xvbrk        TYPE vbrkvb_t,
    lt_xkomv        TYPE komv_t,
    lt_xvbrp        TYPE vbrpvb_t.

  CONSTANTS:
    lc_billing_document_request TYPE ptf_bo VALUE 'EBDR',
    lc_sales_order              TYPE ptf_bo VALUE 'OR',
    lc_outbound_delivery        TYPE ptf_bo VALUE 'OUTB_DELIVERY',
    lc_with_posting_h           TYPE c      VALUE 'H'.


  DATA(ls_step_data_this_check) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

  ev_check_status = abap_false.

  LOOP AT ls_step_data_this_check-reference_step INTO lv_ref_step. " assigning field-symbol(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  lv_ref_step ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    APPEND lv_ref_step TO lt_ref_step.
  ENDLOOP.
  IF lt_vbeln IS INITIAL.
    me->mo_run_environment->append_log( 'There are no documentIDs to check!' ).
    RETURN.
  ENDIF.

  " Check input data
  READ TABLE lt_vbeln INDEX 1 INTO lv_vbeln.
  CHECK lv_vbeln IS NOT INITIAL.

  " Get preceding object
  READ TABLE lt_ref_step INDEX 1 INTO lv_ref_step.
  CHECK lv_ref_step IS NOT INITIAL.
  DATA(ls_step_data_prev_act) = me->mo_run_environment->get_step_data( iv_step_number = lv_ref_step ).

  CASE ls_step_data_prev_act-bus_obj.
    WHEN lc_billing_document_request.
      lv_vbtyp = if_sd_doc_category=>ext_billing_doc_request.
    WHEN lc_sales_order.
      lv_vbtyp = if_sd_doc_category=>order.
    WHEN lc_outbound_delivery.
      lv_vbtyp = if_sd_doc_category=>delivery.
    WHEN OTHERS.
      me->mo_run_environment->append_log( 'The documet category for documentID not defined!' ).
      RETURN.
  ENDCASE.


* Create entry for calling billing simulation
  CLEAR ls_xkomfk.
  ls_xkomfk-vbeln = lv_vbeln. " lrs_delivery_data_single->awkey-awref.
  ls_xkomfk-vbtyp = lv_vbtyp.  " if_fins_pred_vbtyp_c=>gc_delivery.
  APPEND ls_xkomfk TO lt_xkomfk.

  " simulation witout payment card
  APPEND if_ocb_constants=>sc_excl_func_in_sim-external_tax TO lt_excl_func.

  " call in simulation mode
  CALL FUNCTION 'RV_INVOICE_CREATE'
    EXPORTING
      vbsk_i                   = ls_vbsk
      invoice_date             = sy-datlo
      with_posting             = lc_with_posting_h
      i_analyze_mode           = abap_true
      iv_preview_simulation    = abap_false
      i_no_nast                = abap_true
      it_excl_func_in_sim_mode = lt_excl_func
    TABLES
      xkomfk                   = lt_xkomfk
      xkomv                    = lt_xkomv
      xthead                   = lt_xthead
      xvbfs                    = lt_bill_message
      xvbpa                    = lt_xvbpa
      xvbrk                    = lt_xvbrk
      xvbrp                    = lt_xvbrp
      xvbss                    = lt_xvbss
    EXCEPTIONS
      error_message            = 1.

  IF sy-subrc NE 0.
    me->mo_run_environment->append_log( | The simulation for documentID { lv_vbeln } fails | ).
    RETURN.
  ENDIF.

  lv_vbrk_bd_ex = abap_false.
  LOOP AT lt_xvbrk REFERENCE INTO DATA(lr_xvbrk).
    IF lr_xvbrk->vbtyp EQ if_sd_doc_category=>invoice AND
       lr_xvbrk->vbeln(1) EQ '$'.
      lv_vbrk_bd_ex = abap_true.
      EXIT.
    ENDIF.
  ENDLOOP.
  IF lv_vbrk_bd_ex EQ abap_false.
    me->mo_run_environment->append_log( 'The simulation has no result ' ).
    RETURN.
  ENDIF.

  IF NOT go_pricing_parameters IS BOUND.
    go_pricing_parameters = cl_pricing_parameters=>go_instance.
  ENDIF.
  IF go_pricing_parameters->if_pricing_parameters~is_tax_not_required( ) EQ abap_false.
    me->mo_run_environment->append_log( | The simulation has aktivated external tax calculation) | ).
    RETURN.
  ENDIF.

  ev_execution_status = abap_true.
  ev_check_status = abap_true.

ENDMETHOD.


METHOD check_bd_simul_wo_pc.

  DATA:
    lv_vbeln         TYPE vbeln,
    lt_vbeln         TYPE cl_ptf_util=>ty_vbeln_tab,
    lv_ref_step      TYPE cl_ptf_util=>gty_ref_step,
    lt_ref_step      TYPE cl_ptf_util=>gty_reference_tab,
    lv_vbtyp         TYPE vbtypl,
    lv_vbrp_rplnr_ex TYPE abap_bool,
    lv_vbrk_rplnr_ex TYPE abap_bool.

  DATA:
    ls_vbsk         TYPE vbsk,
    ls_xkomfk       TYPE komfk,
    lt_xkomfk       TYPE STANDARD TABLE OF komfk,
    lt_excl_func    TYPE tt_ocb_fncltyname,
    lt_bill_message TYPE STANDARD TABLE OF vbfs,
    lt_xvbpa        TYPE STANDARD TABLE OF vbpavb,
    lt_xvbss        TYPE STANDARD TABLE OF vbss,
    lt_xthead       TYPE STANDARD TABLE OF theadvb,
    lt_xvbrk        TYPE vbrkvb_t,
    lt_xkomv        TYPE komv_t,
    lt_xvbrp        TYPE vbrpvb_t.

  CONSTANTS:
    lc_billing_document_request TYPE ptf_bo VALUE 'EBDR',
    lc_sales_order              TYPE ptf_bo VALUE 'OR',
    lc_outbound_delivery        TYPE ptf_bo VALUE 'OUTB_DELIVERY',
    lc_with_posting_h           TYPE c      VALUE 'H'.


  DATA(ls_step_data_this_check) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

  ev_check_status = abap_false.

  LOOP AT ls_step_data_this_check-reference_step INTO lv_ref_step. " assigning field-symbol(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  lv_ref_step ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    APPEND lv_ref_step TO lt_ref_step.
  ENDLOOP.
  IF lt_vbeln IS INITIAL.
    me->mo_run_environment->append_log( 'There are no documentIDs to check!' ).
    RETURN.
  ENDIF.

  " Check input data
  READ TABLE lt_vbeln INDEX 1 INTO lv_vbeln.
  CHECK lv_vbeln IS NOT INITIAL.

  " Get preceding object
  READ TABLE lt_ref_step INDEX 1 INTO lv_ref_step.
  CHECK lv_ref_step IS NOT INITIAL.
  DATA(ls_step_data_prev_act) = me->mo_run_environment->get_step_data( iv_step_number = lv_ref_step ).

  CASE ls_step_data_prev_act-bus_obj.
    WHEN lc_billing_document_request.
      lv_vbtyp = if_sd_doc_category=>ext_billing_doc_request.
    WHEN lc_sales_order.
      lv_vbtyp = if_sd_doc_category=>order.
    WHEN lc_outbound_delivery.
      lv_vbtyp = if_sd_doc_category=>delivery.
    WHEN OTHERS.
      me->mo_run_environment->append_log( 'The documet category for documentID not defined!' ).
      RETURN.
  ENDCASE.


* Create entry for calling billing simulation
  CLEAR ls_xkomfk.
  ls_xkomfk-vbeln = lv_vbeln. " lrs_delivery_data_single->awkey-awref.
  ls_xkomfk-vbtyp = lv_vbtyp.  " if_fins_pred_vbtyp_c=>gc_delivery.
  APPEND ls_xkomfk TO lt_xkomfk.

  " simulation witout payment card
  APPEND if_ocb_constants=>sc_excl_func_in_sim-payment_card TO lt_excl_func.

  " call in simulation mode
  CALL FUNCTION 'RV_INVOICE_CREATE'
    EXPORTING
      vbsk_i                   = ls_vbsk
      invoice_date             = sy-datlo
      with_posting             = lc_with_posting_h
      i_analyze_mode           = abap_true
      iv_preview_simulation    = abap_false
      i_no_nast                = abap_true
      it_excl_func_in_sim_mode = lt_excl_func
    TABLES
      xkomfk                   = lt_xkomfk
      xkomv                    = lt_xkomv
      xthead                   = lt_xthead
      xvbfs                    = lt_bill_message
      xvbpa                    = lt_xvbpa
      xvbrk                    = lt_xvbrk
      xvbrp                    = lt_xvbrp
      xvbss                    = lt_xvbss
    EXCEPTIONS
      error_message            = 1.

  IF sy-subrc NE 0.
    me->mo_run_environment->append_log( | The simulation for documentID { lv_vbeln } fails | ).
    RETURN.
  ENDIF.

  lv_vbrp_rplnr_ex = abap_false.
  LOOP AT lt_xvbrp REFERENCE INTO DATA(lr_xvbrp).
    IF lr_xvbrp->rplnr IS NOT INITIAL.
      lv_vbrp_rplnr_ex = abap_true.
    ENDIF.
  ENDLOOP.

  IF lv_vbrp_rplnr_ex EQ abap_false.
    me->mo_run_environment->append_log( | The documentID { lv_vbeln } do not contain payment card(s) | ).
    RETURN.
  ENDIF.

  lv_vbrk_rplnr_ex = abap_false.
  LOOP AT lt_xvbrk REFERENCE INTO DATA(lr_xvbrk).
    IF lr_xvbrk->vbtyp EQ if_sd_doc_category=>invoice AND
       lr_xvbrk->rplnr IS NOT INITIAL.
      lv_vbrk_rplnr_ex = abap_true.
    ENDIF.
  ENDLOOP.

  IF lv_vbrk_rplnr_ex EQ abap_true.
    me->mo_run_environment->append_log( | The simulation has taken over payment card(s) | ).
    RETURN.
  ENDIF.

  ev_execution_status = abap_true.
  ev_check_status = abap_true.

ENDMETHOD.


METHOD check_bd_zuonr_xblnr.

  DATA:
    ls_testdata              TYPE cl_ptf_bo_invoice=>ty_gs_bd_up_zuonr_xblnr,
    lt_vbeln                 TYPE cl_ptf_util=>ty_vbeln_tab,
    ls_vbeln                 TYPE LINE OF cl_ptf_util=>ty_vbeln_tab,
    ls_vbrk_i                TYPE vbrk,
    ls_vbrk_e                TYPE vbrk,
    lt_xvbrk                 TYPE TABLE OF vbrkvb,
    lt_xvbrp                 TYPE TABLE OF vbrpvb,
    lt_xkomv                 TYPE TABLE OF komv,
    lt_xvbpa                 TYPE TABLE OF vbpavb,
    lt_reference_billing_doc TYPE STANDARD TABLE OF vbeln.

  DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

  IF ls_step_data-variant IS NOT INITIAL.
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).
  ENDIF.

  SORT ls_step_data-reference_step ASCENDING.

  LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    IF lt_ptf_keys IS NOT INITIAL.
      APPEND LINES OF lt_ptf_keys TO lt_reference_billing_doc.
    ENDIF.
  ENDLOOP.
  IF lt_vbeln IS INITIAL.
    me->mo_run_environment->append_log( 'There are no documentIDs to check!' ).
    RETURN.
  ENDIF.

  ev_check_status = abap_true.

* update ls_testdata with reference billing document
  LOOP AT ls_testdata-bd_upd_sbi_req_mes-document INTO DATA(ls_reference_document).
    ls_testdata-bd_upd_sbi_req_mes-document[ sy-tabix ]-billing_document = lt_reference_billing_doc[ sy-tabix ].
  ENDLOOP.

  LOOP AT lt_vbeln INTO ls_vbeln.
    ls_vbrk_i-vbeln = ls_vbeln-vbeln.

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

    READ TABLE lt_xvbrk INTO DATA(ls_vbrk) INDEX 1.


    READ TABLE ls_testdata-bd_upd_sbi_req_mes-document WITH KEY billing_document = ls_vbrk-vbeln INTO DATA(ls_document).

    IF ls_vbrk-xblnr EQ ls_document-document_reference_id.
    ELSE.
      ev_check_status = abap_false.
      me->mo_run_environment->append_log( 'xblnr has not been updated correctly!' ).
    ENDIF.

    IF ls_vbrk-zuonr EQ ls_document-assignment_reference.
    ELSE.
      ev_check_status = abap_false.
      me->mo_run_environment->append_log( 'zuonr has not been updated correctly!' ).
    ENDIF.


  ENDLOOP.

  IF ev_check_status = abap_true.
    ev_execution_status = abap_true.
  ENDIF.


ENDMETHOD.


METHOD check_bupla__do_not_use.

  "Method has no real function, it is meant to temporarily be called as an example for a method called by method name from PTFBO-ABAP_METHOD

  DATA:
*            lv_vbeln_vf   TYPE vbeln,
    lt_vbeln_vf   TYPE cl_ptf_util=>ty_vbeln_tab.

  DATA(ls_step_data_this_check) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

  ev_check_status = abap_false.

  LOOP AT ls_step_data_this_check-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln_vf.
  ENDLOOP.
  IF lt_vbeln_vf IS INITIAL.
    me->mo_run_environment->append_log( 'There are no documentIDs to check!' ).
    RETURN.
  ENDIF.

  ev_check_status = abap_true.
  ev_execution_status = abap_true.

ENDMETHOD.


METHOD check_compare_billing_doc.
  TYPES:
    BEGIN OF ty_vbeln,
      vbeln TYPE ptfkey,
    END OF ty_vbeln.

  DATA: lt_vbeln      TYPE TABLE OF ty_vbeln,
        ls_vbeln      TYPE ty_vbeln,
        lv_message    TYPE bapi_msg,
        ls_return     TYPE bapiret2,
        lv_success    TYPE abap_bool,
        lt_vbrk       TYPE TABLE OF vbrk,
        lt_vbrp_1     TYPE TABLE OF vbrp,
        lt_vbrp_2     TYPE TABLE OF vbrp,
        ls_vbrp_1     TYPE vbrp,
        ls_vbrp_2     TYPE vbrp,
        lv_length     TYPE i,
        lt_fieldinfo  TYPE extdfiest,
        ls_fieldinfo  TYPE LINE OF extdfiest,
        msg_str1      TYPE string,
        msg_str2      TYPE string,
        lv_loop_count TYPE i,
        test_data     TYPE ty_gs_compare_irrelevant.

  FIELD-SYMBOLS: <lv_vbrk_1>    TYPE any,
                 <lv_vbrk_2>    TYPE any,
                 <lv_fieldinfo> TYPE any,
                 <lv_vbrp_1>    TYPE any,
                 <lv_vbrp_2>    TYPE any.
*****************************************************************************
  IF step_data-variant IS NOT INITIAL.
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = test_data
    ).
  ENDIF.

* 1 Step: Get Presteps
  DATA: lv_vbeln_loop TYPE vbeln.
  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    LOOP AT lt_ptf_keys ASSIGNING FIELD-SYMBOL(<lv_ptf_key>).
      MOVE <lv_ptf_key>-vbeln TO lv_vbeln_loop.
      APPEND lv_vbeln_loop TO lt_vbeln.
    ENDLOOP.
  ENDLOOP.
  MOVE-CORRESPONDING lt_vbeln TO ev_document_id.
  DESCRIBE TABLE lt_vbeln LINES lv_length.
  IF lv_length NE 2.
    me->mo_run_environment->append_log( iv_log_statement = 'This test is only allowed with 2 Billing Docuemnts.' ).
    ev_execution_status = abap_false.
    RETURN.
  ENDIF.
*****************************************************************************
* 2 VBRK
  TYPES:
    BEGIN OF ty_vbeln_orig,
      vbeln TYPE vbeln,
    END OF ty_vbeln_orig.
  DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.
  MOVE lt_vbeln TO lt_vbeln_key.


  SELECT * FROM vbrk INTO TABLE lt_vbrk FOR ALL ENTRIES IN lt_vbeln_key WHERE vbeln = lt_vbeln_key-vbeln.
  DESCRIBE TABLE lt_vbeln LINES lv_length.
  IF lv_length NE 2.
    me->mo_run_environment->append_log( iv_log_statement = 'Document not found at DB.' ).
    ev_execution_status = abap_false.
    RETURN.
  ENDIF.
*****************************************************************************
* 3 get fieldinfo
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
* 4 Step: Check
  lv_success = abap_true.
  READ TABLE lt_vbrk INTO DATA(ls_vbrk_1) INDEX 1.
  READ TABLE lt_vbrk INTO DATA(ls_vbrk_2) INDEX lv_length.
  LOOP AT lt_fieldinfo INTO ls_fieldinfo.
    IF ls_fieldinfo-fieldname NE 'VBELN' AND ls_fieldinfo-fieldname NE 'KNUMV' AND ls_fieldinfo-fieldname NE 'FKDAT' AND
       ls_fieldinfo-fieldname NE 'BELNR' AND ls_fieldinfo-fieldname NE 'ERZET' AND
       ls_fieldinfo-fieldname NE 'KIDNO' AND ls_fieldinfo-fieldname NE 'CHANGED_ON' AND ls_fieldinfo-fieldname NE 'XBLNR'
       AND ls_fieldinfo-fieldname NE 'PBD_STATUS' AND ls_fieldinfo-fieldname NE 'ZUONR' AND ls_fieldinfo-fieldname NE 'ZUKRI'
       AND NOT line_exists( test_data-irrelevant_head_fields[ field_name = ls_fieldinfo-fieldname ] ).
      ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbrk_1 TO <lv_vbrk_1>.
      ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbrk_2 TO <lv_vbrk_2>.
      IF  <lv_vbrk_1> NE  <lv_vbrk_2>.
        lv_success = abap_false.
        msg_str1 = <lv_vbrk_1>.
        msg_str2 = <lv_vbrk_2>.

        ls_return-message = |VBRK field { ls_fieldinfo-fieldname } is different. Doc { ls_vbrk_1-vbeln } : { msg_str1 }. Doc { ls_vbrk_2-vbeln } : { msg_str2 }.|.

        me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
      ENDIF.
    ENDIF.
  ENDLOOP.
*****************************************************************************
* 5 Step: VBRP
  CLEAR ls_vbeln.
  READ TABLE lt_vbeln INTO ls_vbeln INDEX 1.
  SELECT * FROM vbrp INTO TABLE lt_vbrp_1 WHERE vbeln = ls_vbeln-vbeln ORDER BY PRIMARY KEY.
  CLEAR ls_vbeln.
  READ TABLE lt_vbeln INTO ls_vbeln INDEX 2.
  SELECT * FROM vbrp INTO TABLE lt_vbrp_2 WHERE vbeln = ls_vbeln-vbeln ORDER BY PRIMARY KEY.
  DESCRIBE TABLE lt_vbrp_1 LINES DATA(lv_vbrp_l1).
  DESCRIBE TABLE lt_vbrp_2 LINES DATA(lv_vbrp_l2).
  IF lv_vbrp_l1 NE lv_vbrp_l2.
    me->mo_run_environment->append_log( iv_log_statement = 'Quantity of Item are not equal.' ).
    ev_execution_status = abap_false.
    RETURN.
  ENDIF.
*****************************************************************************
* 6 get fieldinfo
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
* 7 Step: Check
  lv_loop_count = 0.
  LOOP AT lt_vbrp_1 INTO ls_vbrp_1.
    lv_loop_count = lv_loop_count + 1.
    READ TABLE lt_vbrp_2 INTO ls_vbrp_2 INDEX lv_loop_count.
    LOOP AT lt_fieldinfo INTO ls_fieldinfo.
      IF ls_fieldinfo-fieldname NE 'VBELN' AND ls_fieldinfo-fieldname NE 'VGBEL' AND ls_fieldinfo-fieldname NE 'AUBEL' AND
         ls_fieldinfo-fieldname NE 'ERNAM' AND ls_fieldinfo-fieldname NE 'ERZET' AND ls_fieldinfo-fieldname NE 'PAOBJNR' AND
         ls_fieldinfo-fieldname NE 'VGTYP' AND ls_fieldinfo-fieldname NE 'VGPOS' AND ls_fieldinfo-fieldname NE 'PBD_ID' AND
         ls_fieldinfo-fieldname NE 'PBD_ITEM_ID' AND ls_fieldinfo-fieldname NE 'KNUMV_ANA' AND ls_fieldinfo-fieldname NE 'PS_PSP_PNR'
         AND NOT line_exists( test_data-irrelevant_pos_fields[ field_name = ls_fieldinfo-fieldname ] ).
        ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbrp_1 TO <lv_vbrp_1>.
        ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbrp_2 TO <lv_vbrp_2>.
        IF <lv_vbrp_1> NE  <lv_vbrp_2>.
          lv_success  = abap_false.
          CLEAR ls_return.
          msg_str1 = <lv_vbrp_1>.
          msg_str2 = <lv_vbrp_2>.
          ls_return-message = |VBRP field { ls_fieldinfo-fieldname } is different. Doc { ls_vbrk_1-vbeln } : { msg_str1 }. Doc { ls_vbrk_2-vbeln } : { msg_str2 }.|.
          me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDLOOP.
*****************************************************************************
  ev_execution_status = abap_true.
  ev_check_status = lv_success.
  IF lv_success EQ abap_true.
    ls_return-message = 'Check was succesful. Both document are similar.'.
    me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
  ENDIF.
ENDMETHOD.


METHOD check_compare_vbfa.
  DATA: lt_vbeln          TYPE TABLE OF cl_ptf_util=>ty_vbeln,
        ls_vbeln          TYPE cl_ptf_util=>ty_vbeln,
        lv_message        TYPE bapi_msg,
        ls_return         TYPE bapiret2,
        lv_error_occurred TYPE abap_bool VALUE abap_false,
        lt_vbfa_1         TYPE TABLE OF vbfa,
        lt_vbfa_2         TYPE TABLE OF vbfa,
        ls_vbfa_1         TYPE vbfa,
        ls_vbfa_2         TYPE vbfa,
        lv_length         TYPE i,
        lv_length_2       TYPE i,
        lt_fieldinfo      TYPE extdfiest,
        ls_fieldinfo      TYPE LINE OF extdfiest,
        msg_str1          TYPE string,
        msg_str2          TYPE string,
        lv_loop_count     TYPE i.

  FIELD-SYMBOLS: <lv_vbrk_1>    TYPE any,
                 <lv_vbrk_2>    TYPE any,
                 <lv_fieldinfo> TYPE any,
                 <lv_vbfa_1>    TYPE any,
                 <lv_vbfa_2>    TYPE any.
*****************************************************************************
* 1 Step: Get Presteps
  DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

  LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.

  MOVE-CORRESPONDING lt_vbeln TO ev_document_id.
  DESCRIBE TABLE lt_vbeln LINES lv_length.
  IF lv_length NE 2.
    me->mo_run_environment->append_log( iv_log_statement = 'This test is only allowed with 2 Billing Docuemnts.' ).
    ev_execution_status = abap_false.
    RETURN.
  ENDIF.
*****************************************************************************
* 5 Step: vbfa
  CLEAR ls_vbeln.
  READ TABLE lt_vbeln INTO ls_vbeln INDEX 1.
  SELECT * FROM vbfa INTO TABLE lt_vbfa_1 WHERE vbeln = ls_vbeln-vbeln ORDER BY vbelv.
  CLEAR ls_vbeln.
  READ TABLE lt_vbeln INTO ls_vbeln INDEX 2.
  SELECT * FROM vbfa INTO TABLE lt_vbfa_2 WHERE vbeln = ls_vbeln-vbeln ORDER BY vbelv.
  DELETE lt_vbfa_1 WHERE vbtyp_v = 'PBD'.
  DELETE lt_vbfa_2 WHERE vbtyp_v = 'PBD'.

  DESCRIBE TABLE lt_vbfa_1 LINES lv_length.
  DESCRIBE TABLE lt_vbfa_2 LINES lv_length_2.

  IF lv_length NE lv_length_2.
    me->mo_run_environment->append_log( iv_log_statement = |Quantity of VFBA entries are not equal.| ).
    ev_execution_status = abap_false.
    RETURN.
  ENDIF.
*****************************************************************************
* 6 get fieldinfo
  CLEAR lt_fieldinfo.
  CALL FUNCTION 'DD_INT_TABLINFO_GET'
    EXPORTING
      typename       = 'VBFA'
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
* 7 Step: Check
  lv_loop_count = 0.
  LOOP AT lt_vbfa_1 INTO ls_vbfa_1.
    lv_loop_count = lv_loop_count + 1.
    READ TABLE lt_vbfa_2 INTO ls_vbfa_2 INDEX lv_loop_count.
    LOOP AT lt_fieldinfo INTO ls_fieldinfo.
      IF ls_fieldinfo-fieldname NE 'RUUID' AND ls_fieldinfo-fieldname NE 'VBELV' AND ls_fieldinfo-fieldname NE 'VBELN' AND
         ls_fieldinfo-fieldname NE 'AEDAT' AND ls_fieldinfo-fieldname NE 'FPLNR' AND ls_fieldinfo-fieldname NE 'ERZET'.
        ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbfa_1 TO <lv_vbfa_1>.
        ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbfa_2 TO <lv_vbfa_2>.
        IF <lv_vbfa_1> NE  <lv_vbfa_2>.
          lv_error_occurred = abap_true.
          CLEAR ls_return.
          msg_str1 = <lv_vbfa_1>.
          msg_str2 = <lv_vbfa_2>.
          CONCATENATE 'The value of the vbfa field ' ls_fieldinfo-fieldname 'is not as expected. The expected value is:' msg_str1
                      '. The stored value is:' msg_str2  INTO ls_return-message SEPARATED BY space.
          me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDLOOP.
*****************************************************************************
  ev_execution_status = abap_true.

  IF lv_error_occurred EQ abap_false.
    ev_check_status = abap_true.
    me->mo_run_environment->append_log( iv_log_statement = 'Check was successful.' ).
  ELSEIF lv_error_occurred EQ abap_true.
    ev_check_status = abap_false.
    me->mo_run_environment->append_log( iv_log_statement = 'Check failed.' ).
  ENDIF.

ENDMETHOD.


METHOD check_complete_proforma.

  DATA:
    ls_testdata  TYPE cl_ptf_bo_invoice=>ty_gs_bd_up_zuonr_xblnr,
    lt_vbeln     TYPE cl_ptf_util=>ty_vbeln_tab,
    ls_vbeln     TYPE LINE OF cl_ptf_util=>ty_vbeln_tab,
    ls_vbrk_i    TYPE vbrk,
    ls_vbrk_e    TYPE vbrk,
    lt_xvbrk     TYPE TABLE OF vbrkvb,
    lt_xvbrp     TYPE TABLE OF vbrpvb,
    lt_xkomv     TYPE TABLE OF komv,
    lt_xvbpa     TYPE TABLE OF vbpavb,
    lt_documents TYPE tt_vbeln_vf.

  DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

  ev_check_status = abap_true.

  IF ls_step_data-variant IS NOT INITIAL.
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).
  ENDIF.

  SORT ls_step_data-reference_step ASCENDING.

  LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    IF lt_ptf_keys IS NOT INITIAL.
      APPEND LINES OF lt_ptf_keys TO lt_documents.
    ENDIF.
  ENDLOOP.
  IF lt_vbeln IS INITIAL.
    me->mo_run_environment->append_log( 'There are no documentIDs to check!' ).
    ev_check_status = abap_false.
    RETURN.
  ENDIF.

  IF lt_documents IS NOT INITIAL.
    SELECT vbeln, rfbsk FROM vbrk FOR ALL ENTRIES IN @lt_documents WHERE vbeln = @lt_documents-table_line INTO TABLE @DATA(lt_result).
  ELSE.
    me->mo_run_environment->append_log( 'There are no documentIDs to check!' ).
    ev_check_status = abap_false.
    RETURN.
  ENDIF.

  LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<ls_result>).
    IF <ls_result>-rfbsk NE 'E'.
      ev_check_status = abap_false.
      me->mo_run_environment->append_log( 'Proforma invoice is not completed (VBRK-RFBSK not E)' ).
    ENDIF.
  ENDLOOP.

  IF ev_check_status = abap_true.
    ev_execution_status = abap_true.
  ENDIF.

ENDMETHOD.


METHOD check_condition_exists.
  DATA: lt_vbeln                  TYPE cl_ptf_util=>ty_vbeln_tab,
        ls_vbeln                  TYPE LINE OF cl_ptf_util=>ty_vbeln_tab,
        ls_vbrk                   TYPE  vbrk,
        ls_return                 TYPE bapiret2,
        lv_pricing_elements_count TYPE i.
  DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
  LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.

  ev_check_status = abap_true.

  IF lt_vbeln IS NOT INITIAL.

    LOOP AT lt_vbeln INTO ls_vbeln.
      SELECT SINGLE * FROM vbrk INTO ls_vbrk WHERE vbeln = ls_vbeln-vbeln.
      IF ls_vbrk IS NOT INITIAL.
        SELECT COUNT(*) INTO lv_pricing_elements_count FROM prcd_elements WHERE knumv = ls_vbrk-knumv.
        IF lv_pricing_elements_count EQ 0.
          ev_check_status = abap_false.
          CONCATENATE 'No pricing elements exist for billing document:' ls_vbrk-vbeln INTO ls_return-message SEPARATED BY space.
          me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
        ELSE.
          CONCATENATE 'At least one price condition exists for document:' ls_vbrk-vbeln INTO ls_return-message SEPARATED BY space.
          me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
        ENDIF.
      ELSE.
        ev_check_status = abap_false.
        CONCATENATE 'No Billing Documents found with vbeln:' ls_vbeln-vbeln INTO ls_return-message.
        me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
      ENDIF.
    ENDLOOP.

  ELSE.
    ev_check_status = abap_false.
    ls_return-message = 'No predecessor documents found.'.
    me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
  ENDIF.

  ev_execution_status = abap_true.

ENDMETHOD.


METHOD check_dp_settlment.

  DATA: lv_vbeln_vf          TYPE                   vbeln,
        lt_vbeln_vf          TYPE                   cl_ptf_util=>ty_vbeln_tab,
        ls_vbrk              TYPE                   vbrk,
        lt_vbrp              TYPE STANDARD TABLE OF vbrp,
        ls_vbrp_dp           TYPE                   vbrp,
        ls_vbrp_no_dp        TYPE                   vbrp,
        ls_vbrp_anz_dp       TYPE                   vbrpvb,
        ls_vbrp_anz_no_dp    TYPE                   vbrpvb,
        lt_vbrp_anz_dp       TYPE STANDARD TABLE OF vbrpvb,
        lt_vbrp_anz_no_dp    TYPE STANDARD TABLE OF vbrpvb,
        lt_refdoc_dp         TYPE STANDARD TABLE OF vgbel,
        lt_refdoc_no_dp      TYPE STANDARD TABLE OF vgbel WITH NON-UNIQUE SORTED KEY k1 COMPONENTS table_line,
        lv_refdoc_dp         TYPE                   vgbel,
        lv_refdoc_no_dp      TYPE                   vgbel,
        lv_netvalue_dp       TYPE                   netwr,
        lt_difftab           TYPE STANDARD TABLE OF vgbel,
        lt_netvalue_dp       TYPE STANDARD TABLE OF netwr,
        lt_vbrp_anz_dp_ad    TYPE STANDARD TABLE OF vbrpvb,
        lt_vbrp_anz_no_dp_ad TYPE STANDARD TABLE OF vbrpvb,
        ls_dp_ad             TYPE                   vbrpvb,
        ls_no_dp_ad          TYPE                   vbrpvb,
        lv_sum_dp            TYPE                   p DECIMALS 2.

  DATA(ls_step_data_this_check) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

  ev_check_status = abap_false.

  LOOP AT ls_step_data_this_check-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln_vf.
  ENDLOOP.
  IF lt_vbeln_vf IS INITIAL.
    me->mo_run_environment->append_log( 'There are no documentIDs to check!' ).
    RETURN.
  ENDIF.
  READ TABLE lt_vbeln_vf INDEX 1 INTO lv_vbeln_vf.
  CHECK lv_vbeln_vf IS NOT INITIAL.

  " Select VBRK
  SELECT SINGLE * FROM vbrk INTO ls_vbrk WHERE vbeln = lv_vbeln_vf.
  IF sy-subrc IS NOT INITIAL.
    me->mo_run_environment->append_log( |BillingDoc { lv_vbeln_vf } not found. | ).
    RETURN.
  ENDIF.

  " Select VBRP
  SELECT * FROM vbrp INTO TABLE lt_vbrp WHERE vbeln = lv_vbeln_vf.
  " Filter for Downpayment Items
  LOOP AT lt_vbrp INTO ls_vbrp_dp WHERE kowrr = 'Y'.
    MOVE-CORRESPONDING ls_vbrp_dp TO ls_vbrp_anz_dp.
    IF ls_vbrp_anz_dp-contr_dp_settl EQ 'x'.
      " ...
    ENDIF.
    APPEND ls_vbrp_anz_dp TO lt_vbrp_anz_dp.
    " Selecting ReferenceDocuments of Downpayment Items
    APPEND ls_vbrp_anz_dp-vgbel TO lt_refdoc_dp.
    " Selecting Netvalue of Downpayment Items
    APPEND ls_vbrp_anz_dp-netwr TO lt_netvalue_dp.

    " Adding up Netvalue for each RefDoc of all Downpayment Items in iTab lt_vbrp_anz_dp_ad
    READ TABLE lt_vbrp_anz_dp_ad ASSIGNING FIELD-SYMBOL(<fs_1>) WITH KEY vgbel = ls_vbrp_anz_dp-vgbel.
    IF sy-subrc NE 0.
      APPEND ls_vbrp_anz_dp TO lt_vbrp_anz_dp_ad.
    ELSE.
      <fs_1>-netwr = <fs_1>-netwr + ls_vbrp_anz_dp-netwr.
    ENDIF.
  ENDLOOP.

  " Adding up Netvalue of all Downpayment Items in lv_sum_dp
  LOOP AT lt_netvalue_dp INTO lv_netvalue_dp.
    lv_sum_dp = lv_sum_dp + lv_netvalue_dp.
  ENDLOOP.

  " Checking for Downpayment Items
  IF lt_vbrp_anz_dp IS INITIAL.
    me->mo_run_environment->append_log( | Billing Document { ls_vbrk-vbeln } no down payment settlement items(s) found | ).
    RETURN.
  ENDIF.

  " loop at all items
  " get dp requested
  " contr_dp_settl eq true -> select contract
  "                eq false -> select sales order
  " call fb SD_DOWNPAYMENT_READ for billing document
  " check dp used

  " Selecting ReferenceDocuments of Non-Downpayment Items
  LOOP AT lt_vbrp INTO ls_vbrp_no_dp WHERE kowrr = ''.
    MOVE-CORRESPONDING ls_vbrp_no_dp TO ls_vbrp_anz_no_dp.
    APPEND ls_vbrp_anz_no_dp-vgbel TO lt_refdoc_no_dp.

    " Adding up Netvalue for each RefDoc of all Non-Downpayment Items in lt_vbrp_anz_no_dp_ad
    READ TABLE lt_vbrp_anz_no_dp_ad ASSIGNING FIELD-SYMBOL(<fs_2>) WITH KEY vgbel = ls_vbrp_anz_no_dp-vgbel.
    IF sy-subrc NE 0.
      APPEND ls_vbrp_anz_no_dp TO lt_vbrp_anz_no_dp_ad.
    ELSE.
      <fs_2>-netwr = <fs_2>-netwr + ls_vbrp_anz_no_dp-netwr.
    ENDIF.
  ENDLOOP.

  " Check that Downpayment Amount is <= Netvalue of corresponding Item
  LOOP AT lt_vbrp_anz_dp_ad INTO ls_dp_ad.
    READ TABLE lt_vbrp_anz_no_dp_ad INTO ls_no_dp_ad WITH KEY vgbel = ls_dp_ad-vgbel.
    IF ls_dp_ad-netwr > ls_no_dp_ad-netwr.
      me->mo_run_environment->append_log( |XVBRK-VBELN { ls_vbrk-vbeln } contains items for down payment settlement, but incorrect Down-Payment amount in relation to its corresponding item.| ).
      RETURN.
    ENDIF.
  ENDLOOP.

  " Check ReferenceDocuments of Downpayment Items
  LOOP AT lt_refdoc_dp INTO lv_refdoc_dp.
    READ TABLE lt_refdoc_no_dp INTO lv_refdoc_no_dp WITH KEY k1 COMPONENTS table_line = lv_refdoc_dp.
    IF sy-subrc NE 0.
      APPEND lv_refdoc_dp TO lt_difftab.
    ELSEIF lv_refdoc_dp <> lv_refdoc_no_dp.
      APPEND lv_refdoc_dp TO lt_difftab.
    ENDIF.
  ENDLOOP.

  IF lt_difftab IS INITIAL.
    IF lv_sum_dp <= ls_vbrk-netwr.
      me->mo_run_environment->append_log( |XVBRK-VBELN { ls_vbrk-vbeln } contains items for down payment settlement with correct reference(s) and correct Down-Payment amount.| ).
      ev_check_status = abap_true.
    ELSE.
      me->mo_run_environment->append_log( |XVBRK-VBELN { ls_vbrk-vbeln } contains items for down payment settlement with correct reference(s), but incorrect Down-Payment amount.| ).
    ENDIF.
  ELSE.
    me->mo_run_environment->append_log( |XVBRK-VBELN { ls_vbrk-vbeln } contains items for down payment settlement with incorrect reference(s).| ).
  ENDIF.

  ev_execution_status = abap_true.

*  loop at ls_step_data_this_check-reference_step assigning <lv_ref_step>. "Predecessors of the check are the invoices
*    data(ls_step_data_bd) = me->mo_run_environment->get_step_data( iv_step_number = <lv_ref_step> ).
*    loop at ls_step_data_bd-reference_step assigning field-symbol(<lv_ref_step_prec>). "Predecessors of the invoices
*      data(lt_ptf_keys_prec) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step_prec> ).
*      append lines of lt_ptf_keys_prec to lt_vbeln_prec.
*    endloop.
*    if lines( lt_vbeln_prec ) ne 1.
*      me->mo_run_environment->append_log( |This check supports only exactly 1 invoiced document. | ).
*      return.
*    endif.
*    lv_vbeln_prec = lt_vbeln_prec[ 1 ].
*    if ls_vbrk-xblnr eq lv_vbeln_prec.
*      me->mo_run_environment->append_log( |XVBRK-XBLNR { ls_vbrk-xblnr } equals the prec. doc. id. Check passed.| ).
*      ev_check_status = abap_true.
*      ev_execution_status = abap_true.
*    else.
*      me->mo_run_environment->append_log( |XVBRK-XBLNR { ls_vbrk-xblnr } deviates from prec. doc. id { lv_vbeln_prec } .| ).
*    endif.
*  endloop.

ENDMETHOD.


METHOD check_dyn_output.
  DATA: lt_vbeln        TYPE TABLE OF cl_ptf_util=>ty_vbeln,
        ls_vbeln        TYPE cl_ptf_util=>ty_vbeln,
        lv_vbeln        TYPE string,
        ls_tdcv_content TYPE ptf_s_output_invocation,
        et_return       TYPE cl_ptf_util=>gt_ptf_return_tab.

  ev_check_status = abap_false.
*****************************************************************************
* 1 Step: Get TDCV
  cl_ptf_util=>get_testdata(
EXPORTING
  is_step_data = step_data
IMPORTING
  es_testdata  = ls_tdcv_content
).

  "Replace pattern
  READ TABLE step_data-reference_step INDEX 1 INTO DATA(invoice_step).
  DATA(invoice_vbeln) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  invoice_step ).
  LOOP AT invoice_vbeln ASSIGNING FIELD-SYMBOL(<vbel>).
    APPEND <vbel> TO lt_vbeln.
  ENDLOOP.


  READ TABLE step_data-reference_step INDEX 2 INTO DATA(dyn_values_steps).
  DATA(dyn_values) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  dyn_values_steps ).

  LOOP AT ls_tdcv_content-output ASSIGNING FIELD-SYMBOL(<output_string>).
    LOOP AT dyn_values ASSIGNING FIELD-SYMBOL(<dyn_value>).
      REPLACE ALL OCCURRENCES OF |[&{ sy-tabix }]| IN <output_string> WITH <dyn_value>.
    ENDLOOP.
  ENDLOOP.


*****************************************************************************
* 3 Step: Check output data
  LOOP AT lt_vbeln INTO ls_vbeln.
    lv_vbeln = ls_vbeln-vbeln.
    cl_ptf_output_compare=>execute(
      EXPORTING
        is_tdcv            = ls_tdcv_content
        iv_document_number = lv_vbeln ).
  ENDLOOP.
*****************************************************************************
* 4 Step: Map test result to PTF data
  cl_ptf_output_compare=>get_test_result(
    IMPORTING
      eb_test_status = ev_check_status
      et_log         = et_return ).
  ev_execution_status = abap_true.
  APPEND LINES OF lt_vbeln TO ev_document_id.
  LOOP AT et_return ASSIGNING FIELD-SYMBOL(<ls_msg>).
    me->mo_run_environment->append_log_structure( is_log = <ls_msg> ).
    "me->mo_run_environment->append_log( iv_log_statement = |{ <ls_msg>-message }| ).
  ENDLOOP.

ENDMETHOD.


METHOD check_edi_output.
  DATA: ls_message    TYPE edi_customer_invoice_message,
        lt_return_tab TYPE STANDARD TABLE OF bapiret2,
        lt_finf       TYPE /aif/t_finf.

  ev_check_status = abap_true.
  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
    DATA(ls_refstep_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
    IF ls_refstep_data-document_id IS NOT INITIAL.
      LOOP AT ls_refstep_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).
        ls_message-invoice-supplier_invoice_id = <ls_docid>-vbeln.

        "Call FM EDI_SD_INVC_PRE_PROCESSING which is called from AIF for EDI Invoice Message processing
        CALL FUNCTION 'EDI_SD_INVC_PRE_PROCESSING'
          EXPORTING
            finf       = lt_finf
          TABLES
            return_tab = lt_return_tab
          CHANGING
            raw_struct = ls_message
          EXCEPTIONS
            cancel     = 1
            OTHERS     = 2.
        IF sy-subrc <> 0.
          me->mo_run_environment->append_log( iv_log_statement = |Error during FM processing| ).
          ev_check_status = abap_false.
          RETURN.
        ENDIF.

        "Check important nodes if they are filled

        "Partners
        IF ls_message-invoice-party IS INITIAL.
          me->mo_run_environment->append_log( iv_log_statement = |Partner node is initial| ).
          ev_check_status = abap_false.
          RETURN.
        ENDIF.

        "Header Pricing Element
*          Not always given...
*          if ls_message-invoice-pricing_element is initial.
*            me->mo_run_environment->append_log( iv_log_statement = |Pricing Element node is initial| ).
*            ev_check_status = abap_false.
*            return.
*          endif.

        "Header Texts
        IF ls_message-invoice-document_header_text IS INITIAL.
          me->mo_run_environment->append_log( iv_log_statement = |Header Text node is initial| ).
          ev_check_status = abap_false.
          RETURN.
        ENDIF.

        "Net Amount/Gross Amount
        IF ls_message-invoice-net_amount IS INITIAL AND ls_message-invoice-gross_amount IS INITIAL AND ls_message-invoice-tax_amount IS INITIAL.
          me->mo_run_environment->append_log( iv_log_statement = |Gross Amount/Net Amount/Tax Amount node is initial| ).
          ev_check_status = abap_false.
          RETURN.
        ENDIF.

        "Document Date
        IF ls_message-invoice-document_date IS INITIAL.
          me->mo_run_environment->append_log( iv_log_statement = |Document Date node is initial| ).
          ev_check_status = abap_false.
          RETURN.
        ENDIF.

        "Document Reference ID
        IF ls_message-invoice-document_reference_id IS INITIAL.
          me->mo_run_environment->append_log( iv_log_statement = |Document Reference ID node is initial| ).
          ev_check_status = abap_false.
          RETURN.
        ENDIF.

        "Incoterms
        IF ls_message-invoice-incoterms IS INITIAL.
          me->mo_run_environment->append_log( iv_log_statement = |Incoterms node is initial| ).
          ev_check_status = abap_false.
          RETURN.
        ENDIF.

        "Header Tax
        IF ls_message-invoice-header_tax IS INITIAL.
          me->mo_run_environment->append_log( iv_log_statement = |Header Tax node is initial| ).
          ev_check_status = abap_false.
          RETURN.
        ENDIF.

        "Header Texts
        IF ls_message-invoice-payment_terms IS INITIAL.
          me->mo_run_environment->append_log( iv_log_statement = |Payment Term node is initial| ).
          ev_check_status = abap_false.
          RETURN.
        ENDIF.

        "Items
        IF ls_message-invoice-item IS INITIAL.
          me->mo_run_environment->append_log( iv_log_statement = |Item node is initial| ).
          ev_check_status = abap_false.
          RETURN.
        ENDIF.

        "Loop over items
        LOOP AT ls_message-invoice-item ASSIGNING FIELD-SYMBOL(<ls_item>).

          "Item Text
          IF <ls_item>-document_item_text IS INITIAL.
            me->mo_run_environment->append_log( iv_log_statement = |Item Text node is initial| ).
            ev_check_status = abap_false.
            RETURN.
          ENDIF.

          "Gross Amount/Net Amoung/Tax Amount
          IF <ls_item>-gross_amount IS INITIAL AND <ls_item>-net_amount IS INITIAL AND <ls_item>-tax_amount IS INITIAL.
            me->mo_run_environment->append_log( iv_log_statement = |Item Gross Amount/Net Amount/Tax Amount node is initial| ).
            ev_check_status = abap_false.
            RETURN.
          ENDIF.

          "Product
          IF <ls_item>-product IS INITIAL.
            me->mo_run_environment->append_log( iv_log_statement = |Product node is initial| ).
            ev_check_status = abap_false.
            RETURN.
          ENDIF.

          "Item Tax
          IF <ls_item>-item_tax IS INITIAL.
            me->mo_run_environment->append_log( iv_log_statement = |Item Tax node is initial| ).
            ev_check_status = abap_false.
            RETURN.
          ENDIF.

          "Item Pricing Element
          IF <ls_item>-pricing_element IS INITIAL.
            me->mo_run_environment->append_log( iv_log_statement = |Item Pricing Element node is initial| ).
            ev_check_status = abap_false.
            RETURN.
          ENDIF.

          "Invoiced Quantity
          IF <ls_item>-invoiced_quantity IS INITIAL.
            me->mo_run_environment->append_log( iv_log_statement = |Invoiced Qunatity node is initial| ).
            ev_check_status = abap_false.
            RETURN.
          ENDIF.

        ENDLOOP.
      ENDLOOP.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |No Reference Document ID available!| ).
      ev_check_status = abap_false.
      RETURN.
    ENDIF.
  ENDLOOP.

ENDMETHOD.


METHOD check_edi_output_ext_assc.

  DATA: ls_message    TYPE edi_customer_invoice_message,
        lt_return_tab TYPE STANDARD TABLE OF bapiret2,
        lt_finf       TYPE /aif/t_finf.

  ev_check_status = abap_true.
  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).

    DATA(ls_refstep_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
    IF ls_refstep_data-document_id IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No Reference Document ID available from ref step { <ls_ref_step> }. | ).
      ev_check_status = abap_false.
      RETURN.
    ENDIF.

    LOOP AT ls_refstep_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).
      ls_message-invoice-supplier_invoice_id = <ls_docid>-vbeln.

      "Call FM EDI_SD_INVC_PRE_PROCESSING which is called from AIF for EDI Invoice Message processing
      CALL FUNCTION 'EDI_SD_INVC_PRE_PROCESSING'
        EXPORTING
          finf       = lt_finf
        TABLES
          return_tab = lt_return_tab
        CHANGING
          raw_struct = ls_message
        EXCEPTIONS
          cancel     = 1
          OTHERS     = 2.
      IF sy-subrc <> 0.
        me->mo_run_environment->append_log( iv_log_statement = |Error { sy-subrc } during FM processing| ).
        ev_check_status = abap_false.
        RETURN.
      ENDIF.

      "Check that important nodes are filled

      "Document Date
      IF ls_message-invoice-document_date IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |Error: Document Date node is initial| ).
        ev_check_status = abap_false.
      ENDIF.

      "Extension field
      ASSIGN COMPONENT 'YY1_CONTCT_HDR__ID_BDH' OF STRUCTURE ls_message-invoice TO FIELD-SYMBOL(<lv_hd_id>).
      IF sy-subrc IS NOT INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |Error: Field YY1_CONTCT_HDR__ID_BDH not found in EDI_CUSTOMER_INVOICE_MESSAGE| ).
        ev_check_status = abap_false.
        RETURN.
      ENDIF.
      IF <lv_hd_id> IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |Error: YY1_CONTCT_HDR__ID_BDH is initial in the message| ).
        ev_check_status = abap_false.
      ELSEIF <lv_hd_id> NE 'PERSONID49'.
        me->mo_run_environment->append_log( iv_log_statement = |Error: YY1_CONTCT_HDR__ID_BDH has unexpected value '{ <lv_hd_id> }'| ).
      ELSE.
        me->mo_run_environment->append_log( iv_log_statement = |YY1_CONTCT_HDR__ID_BDH has expected value| ).
      ENDIF.


      "Items
      IF ls_message-invoice-item IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |Error: Item node is initial| ).
        ev_check_status = abap_false.
        RETURN.
      ENDIF.

      "Loop over items
      LOOP AT ls_message-invoice-item ASSIGNING FIELD-SYMBOL(<ls_item>).

        me->mo_run_environment->append_log( iv_log_statement = |Checking now item { <ls_item>-supplier_invoice_item_id }:| ).

        "Product
        IF <ls_item>-product IS INITIAL.
          me->mo_run_environment->append_log( iv_log_statement = |Error: Product node is initial| ).
          ev_check_status = abap_false.
        ENDIF.

        "Extension field
        ASSIGN COMPONENT 'YY1_CONTCT_ITM__ID_BDI' OF STRUCTURE <ls_item> TO FIELD-SYMBOL(<lv_itm_id>).
        IF sy-subrc IS NOT INITIAL.
          me->mo_run_environment->append_log( iv_log_statement = |Error: Field YY1_CONTCT_HDR__ID_BDH not found in EDI_CUSTOMER_INVOICE_MESSAGE| ).
          ev_check_status = abap_false.
          RETURN.
        ENDIF.
        IF <lv_itm_id> IS INITIAL.
          me->mo_run_environment->append_log( iv_log_statement = |Error: YY1_CONTCT_ITM__ID_BDI is initial in the message| ).
          ev_check_status = abap_false.
          RETURN.
        ELSEIF <lv_itm_id> NE '50'.
          me->mo_run_environment->append_log( iv_log_statement = |Error: YY1_CONTCT_HDR__ID_BDH has unexpected value '{ <lv_itm_id> }'| ).
        ELSE.
          me->mo_run_environment->append_log( iv_log_statement = |YY1_CONTCT_ITM__ID_BDI has expected value| ).
        ENDIF.

      ENDLOOP. "items

    ENDLOOP. "document ids
  ENDLOOP. "ref steps

  ev_execution_status = abap_true.

ENDMETHOD.


METHOD check_edi_output_header.
  DATA: ls_checkdata TYPE edi_customer_invoice.

  DATA(ls_invoice) = get_edi_output_invoice( is_step_data   = is_step_data iv_step_number = iv_step_number ).
  IF ls_invoice IS INITIAL.
    ev_check_status = abap_false.
    RETURN.
  ENDIF.

  cl_ptf_util=>get_testdata( EXPORTING is_step_data = is_step_data
                             IMPORTING es_testdata  = ls_checkdata ).

  ev_check_status = abap_true.

  IF ls_checkdata-sales_organization NE ls_invoice-sales_organization.
    ev_check_status = abap_false.
    me->mo_run_environment->append_log( iv_log_statement = |The expected sales organization is different from actual one. | ).
  ENDIF.

  IF ls_checkdata-distribution_channel NE ls_invoice-distribution_channel.
    ev_check_status = abap_false.
    me->mo_run_environment->append_log( iv_log_statement = |The expected distribution channel is different from actual one. | ).
  ENDIF.

  IF ls_checkdata-organization_division NE ls_invoice-organization_division.
    ev_check_status = abap_false.
    me->mo_run_environment->append_log( iv_log_statement = |The expected organization division is different from actual one. | ).
  ENDIF.

  IF ls_checkdata-company_code NE ls_invoice-company_code.
    ev_check_status = abap_false.
    me->mo_run_environment->append_log( iv_log_statement = |The expected company code is different from actual one. | ).
  ENDIF.

  IF ls_checkdata-tax_destination_country NE ls_invoice-tax_destination_country.
    ev_check_status = abap_false.
    me->mo_run_environment->append_log( iv_log_statement = |The expected tax destination country is different from actual one. | ).
  ENDIF.


ENDMETHOD.


METHOD check_edi_output_hilvlitm_btch.
  DATA: ls_message      TYPE edi_customer_invoice_message,
        lv_main_item_no TYPE edi_bus_trans_doc_item_id,
        lt_return_tab   TYPE STANDARD TABLE OF bapiret2,
        lt_finf         TYPE /aif/t_finf.

  ev_check_status = abap_true.
  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).

    DATA(ls_refstep_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
    IF ls_refstep_data-document_id IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No Reference Document ID available from ref step { <ls_ref_step> }. | ).
      ev_check_status = abap_false.
      RETURN.
    ENDIF.

    LOOP AT ls_refstep_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).
      ls_message-invoice-supplier_invoice_id = <ls_docid>-vbeln.

      "Call FM EDI_SD_INVC_PRE_PROCESSING which is called from AIF for EDI Invoice Message processing
      CALL FUNCTION 'EDI_SD_INVC_PRE_PROCESSING'
        EXPORTING
          finf       = lt_finf
        TABLES
          return_tab = lt_return_tab
        CHANGING
          raw_struct = ls_message
        EXCEPTIONS
          cancel     = 1
          OTHERS     = 2.
      IF sy-subrc <> 0.
        me->mo_run_environment->append_log( iv_log_statement = |Error { sy-subrc } during FM processing| ).
        ev_check_status = abap_false.
        RETURN.
      ENDIF.

      "Check that important nodes are filled

      "Items
      IF ls_message-invoice-item IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |Error: Item node is initial| ).
        ev_check_status = abap_false.
        RETURN.
      ENDIF.

      "Loop over items
      LOOP AT ls_message-invoice-item ASSIGNING FIELD-SYMBOL(<ls_item>).

        me->mo_run_environment->append_log( iv_log_statement = |Checking now item { <ls_item>-supplier_invoice_item_id }:| ).

        "main item no
        IF sy-tabix = 1.
          lv_main_item_no = <ls_item>-supplier_invoice_item_id.
        ENDIF.

        "Higher Level Item of Batch Split Item
        IF <ls_item>-higher_level_item_of_batch_spl IS INITIAL.
          me->mo_run_environment->append_log( iv_log_statement = |Error: Higher Level Item of Batch Split Item is missing| ).
          ev_check_status = abap_false.
          RETURN.
        ELSE.
          IF <ls_item>-higher_level_item_of_batch_spl NE lv_main_item_no.
            me->mo_run_environment->append_log( iv_log_statement = |Error: Higher Level Item of Batch Split Item is wrong| ).
            ev_check_status = abap_false.
            RETURN.
          ENDIF.
        ENDIF.

      ENDLOOP. "items

    ENDLOOP. "document ids
  ENDLOOP. "ref steps

ENDMETHOD.


METHOD check_edi_output_item.
  DATA: ls_checkdata TYPE edi_customer_invoice.

  DATA(ls_invoice) = get_edi_output_invoice( is_step_data   = is_step_data iv_step_number = iv_step_number ).
  IF ls_invoice IS INITIAL.
    ev_check_status = abap_false.
    RETURN.
  ENDIF.

  cl_ptf_util=>get_testdata( EXPORTING is_step_data = is_step_data
                             IMPORTING es_testdata  = ls_checkdata ).

  "Check item description in item level
  IF lines( ls_checkdata-item ) <> lines( ls_invoice-item ).
    ev_check_status = abap_false.
    me->mo_run_environment->append_log( iv_log_statement = |The expected item rows is different from actual rows.|
          && | Expected: { lines( ls_checkdata-item ) }, Actual: { lines( ls_invoice-item ) }. | ).
    RETURN.
  ENDIF.

  LOOP AT ls_checkdata-item INTO DATA(ls_item).
    DATA(lt_actual_billg_doc_item_text) = VALUE #( ls_invoice-item[ supplier_invoice_item_id = ls_item-supplier_invoice_item_id ]-billing_document_item_text OPTIONAL ).

    IF ls_item-billing_document_item_text  NE lt_actual_billg_doc_item_text.
      ev_check_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |The expected item description is different from actual one.| ).
      RETURN.
    ENDIF.
  ENDLOOP.

  ev_check_status = abap_true.

ENDMETHOD.


METHOD check_edi_output_party.
  DATA: ls_checkdata TYPE edi_customer_invoice.

  DATA(ls_invoice) = get_edi_output_invoice( is_step_data   = is_step_data iv_step_number = iv_step_number ).
  IF ls_invoice IS INITIAL.
    ev_check_status = abap_false.
    RETURN.
  ENDIF.

  cl_ptf_util=>get_testdata( EXPORTING is_step_data = is_step_data
                             IMPORTING es_testdata  = ls_checkdata ).

  IF lines( ls_checkdata-party ) <> lines( ls_invoice-party ).
    ev_check_status = abap_false.
    me->mo_run_environment->append_log( iv_log_statement = |The expected party rows is different from actual rows.|
          && | Expected: { lines( ls_checkdata-party ) }, Actual: { lines( ls_invoice-party ) }. | ).
    RETURN.
  ENDIF.

  LOOP AT ls_checkdata-party ASSIGNING FIELD-SYMBOL(<ls_expected_party>).

    IF NOT line_exists( ls_invoice-party[ global_location_number = <ls_expected_party>-global_location_number
                                          buyer_party_id         = <ls_expected_party>-buyer_party_id
                                          supplier_party_id      = <ls_expected_party>-supplier_party_id
                                          party_type             = <ls_expected_party>-party_type ] ).
      ev_check_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |The expected party is different from actual one. | ).
      RETURN.
    ENDIF.

  ENDLOOP.

  ev_check_status = abap_true.

ENDMETHOD.


METHOD check_edi_output_pricing_elem.
  DATA: ls_checkdata TYPE edi_customer_invoice.

  DATA(ls_invoice) = get_edi_output_invoice( is_step_data   = is_step_data iv_step_number = iv_step_number ).
  IF ls_invoice IS INITIAL.
    ev_check_status = abap_false.
    RETURN.
  ENDIF.

  cl_ptf_util=>get_testdata( EXPORTING is_step_data = is_step_data
                             IMPORTING es_testdata  = ls_checkdata ).

  IF lines( ls_checkdata-pricing_element ) <> lines( ls_invoice-pricing_element ).
    ev_check_status = abap_false.
    me->mo_run_environment->append_log( iv_log_statement = |The expected pricing element rows in header is different from actual rows.|
          && | Expected: { lines( ls_checkdata-pricing_element ) }, Actual: { lines( ls_invoice-pricing_element ) }. | ).
    RETURN.
  ENDIF.

  LOOP AT ls_checkdata-pricing_element INTO DATA(ls_header_pric_elm).
    IF NOT line_exists( ls_invoice-pricing_element[ supplier_condition_type      = ls_header_pric_elm-supplier_condition_type
                                                    supplier_condition_type_name = ls_header_pric_elm-supplier_condition_type_name
                                                    condition_rate_value         = ls_header_pric_elm-condition_rate_value
                                                    condition_quantity           = ls_header_pric_elm-condition_quantity
                                                    condition_amount             = ls_header_pric_elm-condition_amount
                                                    condition_base_value         = ls_header_pric_elm-condition_base_value ] ).
      ev_check_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |The expected pricing element in header is different from actual one.| ).
      RETURN.
    ENDIF.
  ENDLOOP.

  "Check pricing element in item level
  IF lines( ls_checkdata-item ) <> lines( ls_invoice-item ).
    ev_check_status = abap_false.
    me->mo_run_environment->append_log( iv_log_statement = |The expected item rows is different from actual rows.|
          && | Expected: { lines( ls_checkdata-item ) }, Actual: { lines( ls_invoice-item ) }. | ).
    RETURN.
  ENDIF.

  LOOP AT ls_checkdata-item INTO DATA(ls_item).
    DATA(lt_actual_item_pric_elm) = VALUE #( ls_invoice-item[ supplier_invoice_item_id = ls_item-supplier_invoice_item_id ]-pricing_element OPTIONAL ).

    IF lines( ls_item-pricing_element ) <> lines( lt_actual_item_pric_elm ).
      ev_check_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |The expected pricing element rows in item is different from actual rows.|
            && | Expected: { lines( ls_item-pricing_element ) }, Actual: { lines( lt_actual_item_pric_elm ) }. | ).
      RETURN.
    ENDIF.

    LOOP AT ls_item-pricing_element INTO DATA(ls_item_pric_elm).
      IF NOT line_exists( lt_actual_item_pric_elm[ supplier_condition_type      = ls_item_pric_elm-supplier_condition_type
                                                   supplier_condition_type_name = ls_item_pric_elm-supplier_condition_type_name
                                                   condition_rate_value         = ls_item_pric_elm-condition_rate_value
                                                   condition_quantity           = ls_item_pric_elm-condition_quantity
                                                   condition_amount             = ls_item_pric_elm-condition_amount
                                                   condition_base_value         = ls_item_pric_elm-condition_base_value ] ).
        ev_check_status = abap_false.
        me->mo_run_environment->append_log( iv_log_statement = |The expected pricing element in item is different from actual one.| ).
        RETURN.
      ENDIF.
    ENDLOOP.
  ENDLOOP.

  ev_check_status = abap_true.

ENDMETHOD.


METHOD check_edi_split_ariba.
  DATA: doc_number TYPE i.

  ev_check_status = abap_true.
  IF lines( step_data-reference_step ) > 1.
    me->mo_run_environment->append_log( iv_log_statement = |Only one reference step make sense!| ).
    ev_check_status = abap_false.
    RETURN.
  ELSE.
    DATA(ls_refstep_data) = me->mo_run_environment->get_step_data( iv_step_number = step_data-reference_step[ 1 ] ).  " Only 1 reference step make sense
    IF ls_refstep_data IS NOT INITIAL.
      doc_number = lines( ls_refstep_data-document_id ).
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |No reference documents exists!| ).
      ev_check_status = abap_false.
      RETURN.
    ENDIF.
  ENDIF.

  " Check if split criteria 'SRCEDOC_EXT_COMM_SYS_TYPE' leads to split into two invocies
  IF doc_number < 2.
    ev_check_status = abap_false.
  ENDIF.

ENDMETHOD.


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
        WHERE objtype = 'CL_SD_BIL_BD_EVENT' AND
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
*****************************************************************************
* 1 Step: Get TDCV
  cl_ptf_util=>get_testdata(
    EXPORTING
      is_step_data = step_data
    IMPORTING
      es_testdata  = ls_quantity
  ).
*****************************************************************************
* 2 Step: Get Presteps

  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
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


METHOD check_ext_fields.

  DATA: ls_testdata TYPE cl_ptf_sd_util=>ty_gs_i_ptf_ext_field_check_td,
        lt_items    TYPE TABLE OF vbrp,
        lt_vbeln    TYPE cl_ptf_util=>ty_vbeln_tab.
  FIELD-SYMBOLS: <ls_ext_field_db> TYPE any.

  cl_ptf_util=>get_testdata(
    EXPORTING
      is_step_data = step_data
    IMPORTING
      es_testdata  = ls_testdata
  ).

  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.


  ev_execution_status = abap_false.
  ev_check_status = abap_true.

  LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<ls_vbel>).
    SELECT SINGLE * FROM vbrk INTO @DATA(ls_vbrk) WHERE vbeln = @<ls_vbel>-vbeln.
    "Create itab lt_items with the items of the specifique vbeln
    CLEAR lt_items.
    SELECT * FROM vbrp INTO @DATA(ls_vbrp) WHERE vbeln = @<ls_vbel>-vbeln.
      APPEND ls_vbrp TO lt_items.
    ENDSELECT.

    LOOP AT ls_testdata-ext_fields ASSIGNING FIELD-SYMBOL(<ls_ext_field>).
      IF <ls_ext_field>-type EQ 'H'.
        "check header ebene
        ASSIGN COMPONENT <ls_ext_field>-name OF STRUCTURE ls_vbrk TO <ls_ext_field_db>.
        IF <ls_ext_field_db> IS NOT ASSIGNED.
          me->mo_run_environment->append_log( iv_log_statement = |Unknown ext field { <ls_ext_field>-name } for doc { <ls_vbel>-vbeln }.| ).
          ev_check_status = abap_false.
        ELSE.
          IF <ls_ext_field_db> EQ <ls_ext_field>-expected_input.
            me->mo_run_environment->append_log( iv_log_statement = |Expected Input '{ <ls_ext_field>-expected_input }' for { <ls_ext_field>-name } matches input '{ <ls_ext_field_db> }', doc { <ls_vbel>-vbeln }.| ).
          ELSE.
            ev_check_status = abap_false.
            me->mo_run_environment->append_log( iv_log_statement = |Expected Input '{ <ls_ext_field>-expected_input }' for { <ls_ext_field>-name } DOESN'T match input '{ <ls_ext_field_db> }', doc { <ls_vbel>-vbeln }.| ).
          ENDIF.
        ENDIF.
      ELSEIF <ls_ext_field>-type EQ 'P'.
        LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<ls_item>).
          "check positions ebene
          ASSIGN COMPONENT <ls_ext_field>-name OF STRUCTURE <ls_item> TO <ls_ext_field_db>.
          IF <ls_ext_field_db> IS NOT ASSIGNED.
            ev_check_status = abap_false.
            me->mo_run_environment->append_log( iv_log_statement = |Unknown ext field { <ls_ext_field>-name } for doc { <ls_vbel>-vbeln } and posnr { <ls_item>-posnr }.| ).
          ELSE.
            IF <ls_ext_field_db> EQ <ls_ext_field>-expected_input.
              me->mo_run_environment->append_log( iv_log_statement = |Expected Input '{ <ls_ext_field>-expected_input }' for { <ls_ext_field>-name } matches input '{ <ls_ext_field_db> }' for doc { <ls_vbel>-vbeln } posnr {
<ls_item>-posnr }.| ).
            ELSE.
              ev_check_status = abap_false.
              me->mo_run_environment->append_log( iv_log_statement =
|Expected Input '{ <ls_ext_field>-expected_input }' for { <ls_ext_field>-name } doesn't match input '{ <ls_ext_field_db> }' for doc { <ls_vbel>-vbeln } posnr { <ls_item>-posnr }.|
).
            ENDIF.
          ENDIF.
        ENDLOOP.
      ELSEIF <ls_ext_field>-type <> 'H' AND <ls_ext_field>-type <> 'P'.
        ev_check_status = abap_false.
        me->mo_run_environment->append_log( iv_log_statement = |Unknown type { <ls_ext_field>-type } for ext field { <ls_ext_field>-name } and doc { <ls_vbel>-vbeln }.| ).
      ENDIF.
    ENDLOOP."LOOP AT ls_testdata-ext_fields ASSIGNING FIELD-SYMBOL(<ls_ext_field>).
  ENDLOOP. "LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<ls_vbel>).
  ev_execution_status = abap_true.

ENDMETHOD.


  METHOD check_faz_tax_vbrp_bseg.
    TYPES:
      BEGIN OF ty_vbeln,
        vbeln TYPE vbeln,
      END OF ty_vbeln,
      ty_vbeln_tab TYPE STANDARD TABLE OF ty_vbeln WITH NON-UNIQUE KEY vbeln,

      BEGIN OF ty_vbrp_tax,
        vbeln TYPE vbeln_vf,
        posnr TYPE posnr_vf,
        bukrs TYPE bukrs,
        belnr TYPE belnr_d,
        gjahr TYPE gjahr,
        mwsbp TYPE mwsbp,
      END OF ty_vbrp_tax,
      ty_vbrp_tax_tab TYPE STANDARD TABLE OF ty_vbrp_tax,

      BEGIN OF ty_bseg_tax,
        bukrs TYPE bukrs,
        belnr TYPE belnr_d,
        gjahr TYPE gjahr,
        wmwst TYPE wmwst,
        buzei TYPE buzei,
      END OF ty_bseg_tax,
      ty_bseg_tax_tab TYPE STANDARD TABLE OF ty_bseg_tax.

    DATA: lt_vbeln      TYPE cl_ptf_util=>ty_vbeln_tab,
          lt_vbeln_cast TYPE ty_vbeln_tab,
          lt_vbrp_taxes TYPE ty_vbrp_tax_tab,
          lt_bseg_taxes TYPE ty_bseg_tax_tab.


************************************************************************************************************************
*   1. Step: Get Presteps
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      IF lines( lt_ptf_keys ) EQ 0.
        me->mo_run_environment->append_log( iv_log_statement = 'No documents found for step ' && <lv_ref_step> ).
      ENDIF.
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    IF lines( lt_vbeln ) EQ 0.
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = 'There are no billing documents to check!' ).
      RETURN.
    ENDIF.

* Convert ptf keys of lt_vbeln to type vbeln
    lt_vbeln_cast = lt_vbeln.

************************************************************************************************************************
*   2. Step: Tax amounts should be equal between vbrp and bseg

    SELECT vbeln, posnr, mwsbp
      FROM vbrp
      FOR ALL ENTRIES IN @lt_vbeln_cast
      WHERE vbeln = @lt_vbeln_cast-vbeln
      INTO CORRESPONDING FIELDS OF TABLE @lt_vbrp_taxes.

    IF sy-subrc NE 0.
      me->mo_run_environment->append_log( iv_log_statement = 'No billing documents found in VBRP.' ).
      EXIT.
    ENDIF.

    SELECT vbeln, bukrs, belnr, gjahr
      FROM vbrk
      FOR ALL ENTRIES IN @lt_vbeln_cast
      WHERE vbeln = @lt_vbeln_cast-vbeln
      INTO TABLE @DATA(lt_vbrk_taxes). "take care of new table

    IF sy-subrc NE 0.
      me->mo_run_environment->append_log( iv_log_statement = 'No billing documents found in VBRK.' ).
      EXIT.
    ENDIF.

    SELECT bukrs, belnr, gjahr, wmwst, buzei
      FROM bseg
      FOR ALL ENTRIES IN @lt_vbrk_taxes
      WHERE bukrs = @lt_vbrk_taxes-bukrs AND
            belnr = @lt_vbrk_taxes-belnr AND
            gjahr = @lt_vbrk_taxes-gjahr
      INTO CORRESPONDING FIELDS OF TABLE @lt_bseg_taxes.

    IF sy-subrc NE 0.
      me->mo_run_environment->append_log( iv_log_statement = 'No corresponding accounting documents found in BSEG.' ).
    ENDIF.

    LOOP AT lt_vbrp_taxes ASSIGNING FIELD-SYMBOL(<ls_vbrp_taxes>).

      DATA(ls_vbrk_taxes) = lt_vbrk_taxes[ vbeln = <ls_vbrp_taxes>-vbeln ].

      <ls_vbrp_taxes>-bukrs = ls_vbrk_taxes-bukrs.
      <ls_vbrp_taxes>-belnr = ls_vbrk_taxes-belnr.
      <ls_vbrp_taxes>-gjahr = ls_vbrk_taxes-gjahr.

    ENDLOOP.

    LOOP AT lt_vbrp_taxes INTO DATA(ls_vbrp_taxes).

      IF ls_vbrp_taxes-belnr IS INITIAL. "not released to accounting => no entry in BSEG!
        CONTINUE.
      ENDIF.

      DATA(ls_bseg_taxes) = lt_bseg_taxes[ belnr = ls_vbrp_taxes-belnr ].

      IF ls_vbrp_taxes-mwsbp NE ls_bseg_taxes-wmwst OR
         ls_vbrp_taxes-posnr NE ls_bseg_taxes-buzei.

        ev_check_status = abap_false.

        me->mo_run_environment->append_log( iv_log_statement = |For Billing Document { ls_vbrp_taxes-vbeln } Item { ls_vbrp_taxes-posnr } deviating tax values exists in corresponding BSEG entries. | ).

      ELSE.

        me->mo_run_environment->append_log( iv_log_statement = |Check successfully executed for Billing Document { ls_vbrp_taxes-vbeln } Item { ls_vbrp_taxes-posnr }: VBRP tax: { ls_vbrp_taxes-mwsbp } / BSEG tax: { ls_bseg_taxes-wmwst }. | ).

      ENDIF.

    ENDLOOP.

    ev_check_status = abap_true.

  ENDMETHOD.


METHOD check_fi_allocation.

  DATA: lt_vbeln TYPE STANDARD TABLE OF vbrk-vbeln.
  DATA: reversing TYPE abap_bool,
        reversed  TYPE abap_bool.

  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.

  IF lt_vbeln IS INITIAL.
    mo_run_environment->append_log( iv_log_statement = |There is no Billing Document to check.| ).
    RETURN.
  ENDIF.

  ev_check_status = abap_true.

  SELECT vbeln, vbtyp, fksto FROM vbrk INTO TABLE @DATA(lt_vbeln_vbtyp) FOR ALL ENTRIES IN @lt_vbeln WHERE vbeln = @lt_vbeln-table_line ORDER BY PRIMARY KEY.

  LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<vbeln>).
    READ TABLE lt_vbeln_vbtyp WITH KEY vbeln = <vbeln> ASSIGNING FIELD-SYMBOL(<vbeln_vbtyp>) BINARY SEARCH.
    IF <vbeln_vbtyp> IS ASSIGNED.
      reversed = <vbeln_vbtyp>-fksto.
      reversing = cl_sd_doc_category_util=>is_invoice_or_credit_memo_canc( <vbeln_vbtyp>-vbtyp ). "Cancellation document
      SELECT DISTINCT awref, gjahr, xreversing, xreversed, rldnr, docln, COUNT(*) AS numberofdocs
            FROM acdoca
            WHERE awref = @<vbeln> AND xreversing = @reversing AND xreversed = @reversed AND rldnr = '0L' AND docln = '000001'
            GROUP BY rldnr, rbukrs, gjahr, docln, blart, wsl, awref, xreversing, xreversed
              INTO TABLE @DATA(lt_fi_document).
      IF lt_fi_document IS INITIAL.
        ev_check_status = abap_false.
        me->mo_run_environment->append_log( iv_log_statement = |Could not find any FI document for vbeln { <vbeln> }| ).
      ELSE.
        "Single records after grouping means success
        LOOP AT lt_fi_document ASSIGNING FIELD-SYMBOL(<ls_doc_ok>) WHERE numberofdocs EQ 1.
          me->mo_run_environment->append_log( iv_log_statement = |Expected records found in ACDOCA. AWREF: { <ls_doc_ok>-awref } Year: { <ls_doc_ok>-gjahr }| ).
        ENDLOOP.
        "Fail for duplicate entries
        LOOP AT lt_fi_document ASSIGNING FIELD-SYMBOL(<ls_doc>) WHERE numberofdocs > 1.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |For vbeln { <vbeln> } a duplicate FI document was created: | ).
          SELECT DISTINCT rbukrs, gjahr, belnr FROM acdoca FOR ALL ENTRIES IN @lt_fi_document
            WHERE gjahr = @lt_fi_document-gjahr
            AND   awref = @lt_fi_document-awref
            AND   xreversing = @lt_fi_document-xreversing
            AND   xreversed = @lt_fi_document-xreversed
            AND   rldnr = @lt_fi_document-rldnr
            AND   docln = @lt_fi_document-docln
            AND   belnr NOT IN ( SELECT belnr FROM vbrk WHERE vbeln = @<vbeln> )
            INTO TABLE @DATA(bad_fi_documents).
          LOOP AT bad_fi_documents ASSIGNING FIELD-SYMBOL(<bad_fi_documents>).
            me->mo_run_environment->append_log( iv_log_statement = |Company code: { <bad_fi_documents>-rbukrs } Year: { <bad_fi_documents>-gjahr  } FIN Document number: { <bad_fi_documents>-belnr }| ).
          ENDLOOP.
        ENDLOOP.
      ENDIF.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |Billing document not found ({ <vbeln> })| ).
    ENDIF.
  ENDLOOP.
  ev_execution_status = abap_true.

ENDMETHOD.


METHOD check_fi_ext_flow.

****
* Info:
*  1) In the past, BAdI implementations of EnhSpot FIN_ACDOC_SUBSTITUTION (especially for BAdI FIN_ACDOC_SUBSTITUTION ) in the extensibility test system have interfered with this test.
*  2) In theory, changes to aggregation customizing in Tx OCBY (for Reference Transact. 'VBRK') might affect this test.
*      Normal content there is the following:
*       BSEG  MATNR
*       BSEG  MEINS
*       BSEG  MENGE
*       BSEG  PAOBJNR
*       BSEG  POSN2
*       BSEG  VBEL2
*       BSEG  WERKS
****

  DATA: ref_docs        TYPE STANDARD TABLE OF vbeln WITH DEFAULT KEY,
        fields_to_check TYPE tt_fi_data_flow.

  FIELD-SYMBOLS: <acdoca_entry>   TYPE any,
                 <bseg_entry>     TYPE any,
                 <expected_value> TYPE any.

  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
    DATA(ref_docs_single_step) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
    APPEND LINES OF ref_docs_single_step TO ref_docs.
  ENDLOOP.

  IF ref_docs IS INITIAL.
    me->mo_run_environment->append_log( iv_log_statement = | 'No predecessor documents found.' | ).
    RETURN.
  ENDIF.

  cl_ptf_util=>get_testdata(
    EXPORTING
      is_step_data = step_data
    IMPORTING
      es_testdata  = fields_to_check
  ).

  ev_check_status = abap_true.

  LOOP AT ref_docs ASSIGNING FIELD-SYMBOL(<ref_doc>).

    SELECT SINGLE * FROM vbrk WHERE vbeln = @<ref_doc> INTO @DATA(billing_doc).
    IF billing_doc IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = | 'Problem with VBRK select for { <ref_doc> }.' | ).
      ev_check_status = abap_false.
      RETURN.
    ENDIF.

    IF billing_doc-rfbsk NE 'C'.
      me->mo_run_environment->append_log( iv_log_statement = | { <ref_doc> } ': Billing Document is not posted to FIN!! RFBSK is { billing_doc-rfbsk }' | ).
      me->mo_run_environment->append_log( iv_log_statement = | '------------------' | ).
      ev_check_status = abap_false.
      CONTINUE.
    ENDIF.

    SELECT * FROM vbrp WHERE vbeln = @<ref_doc> INTO TABLE @DATA(billing_doc_pos).
    IF billing_doc_pos IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = | 'Problem with VBRP select for { <ref_doc> }.' | ).
      ev_check_status = abap_false.
      RETURN.
    ENDIF.

    SELECT * FROM bseg WHERE
      koart = 'S' AND
      awtyp = 'VBRK' AND
      awkey = @<ref_doc> AND
      gjahr = @sy-datum(4)
      INTO TABLE @DATA(bseg_entries).
    IF bseg_entries IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = | 'No relevant BSEG entries found !!!' | ).
    ENDIF.

    SELECT * FROM acdoca WHERE awtyp = 'VBRK' AND awref = @<ref_doc> INTO TABLE @DATA(acdoca_entries).
    IF acdoca_entries IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = | 'No relevant ACDOCA entries found !!!' | ).
    ENDIF.



    "Check header fields first
    LOOP AT fields_to_check ASSIGNING FIELD-SYMBOL(<field_to_check>) WHERE field_type = 'H'.

      ASSIGN COMPONENT <field_to_check>-bd_field_name OF STRUCTURE billing_doc TO <expected_value>.


      "BSEG
      IF <field_to_check>-bseg_field_name IS NOT INITIAL.
        LOOP AT bseg_entries ASSIGNING FIELD-SYMBOL(<bseg>).
          ASSIGN COMPONENT <field_to_check>-bseg_field_name OF STRUCTURE <bseg> TO <bseg_entry>.

          IF <bseg_entry> NE <expected_value>.
            ev_check_status = abap_false.
            me->mo_run_environment->append_log( iv_log_statement = |BSEG entry for { <field_to_check>-bseg_field_name } is not as expected| ).
            me->mo_run_environment->append_log( iv_log_statement = |Expected: { <expected_value> }| ).
            me->mo_run_environment->append_log( iv_log_statement = |Actual: { <bseg_entry> }| ).
            me->mo_run_environment->append_log( iv_log_statement = |----------| ).
          ENDIF.

        ENDLOOP.

      ENDIF.

      "ACDOCA
      IF <field_to_check>-acdoca_field_name IS NOT INITIAL.

        LOOP AT acdoca_entries ASSIGNING FIELD-SYMBOL(<acdoca>) WHERE awitem IS INITIAL.

          ASSIGN COMPONENT <field_to_check>-acdoca_field_name OF STRUCTURE <acdoca> TO <acdoca_entry>.

          IF <acdoca_entry> NE <expected_value>.
            ev_check_status = abap_false.
            me->mo_run_environment->append_log( iv_log_statement = |ACDOCA entry for { <field_to_check>-acdoca_field_name } is not as expected| ).
            me->mo_run_environment->append_log( iv_log_statement = |Expected: { <expected_value> }| ).
            me->mo_run_environment->append_log( iv_log_statement = |Actual: { <acdoca_entry> }| ).
            me->mo_run_environment->append_log( iv_log_statement = |----------| ).
          ENDIF.

        ENDLOOP.

      ENDIF.

    ENDLOOP.


    "Check item fields
    LOOP AT fields_to_check ASSIGNING <field_to_check> WHERE field_type = 'I'.

      LOOP AT billing_doc_pos ASSIGNING FIELD-SYMBOL(<billing_pos>).

        me->mo_run_environment->append_log( iv_log_statement = |Checking item { <billing_pos>-posnr } of BilDoc { <ref_doc> }: | ).

        ASSIGN COMPONENT <field_to_check>-bd_field_name OF STRUCTURE <billing_pos> TO <expected_value>.
        IF sy-subrc IS NOT INITIAL.
          me->mo_run_environment->append_log( iv_log_statement = |Field { <field_to_check>-bd_field_name } does not exist in type VBRP| ).
          ev_check_status = abap_false.
          CONTINUE.
        ENDIF.


        "BSEG
        IF <field_to_check>-bseg_field_name IS NOT INITIAL.

          DATA lb_match_for_bd_item_found TYPE abap_bool.
          CLEAR lb_match_for_bd_item_found.

          me->mo_run_environment->append_log( iv_log_statement = |Validating field BSEG-{ <field_to_check>-bseg_field_name }| ).

          LOOP AT bseg_entries ASSIGNING <bseg>.

            ASSIGN COMPONENT <field_to_check>-bseg_field_name OF STRUCTURE <bseg> TO <bseg_entry>.
            IF sy-subrc IS NOT INITIAL.
              me->mo_run_environment->append_log( iv_log_statement = |Field { <field_to_check>-bseg_field_name } does not exist in type BSEG| ).
              ev_check_status = abap_false.
              CONTINUE.
            ENDIF.

            IF <bseg_entry> EQ <expected_value>.
              lb_match_for_bd_item_found = abap_true.
            ENDIF.

          ENDLOOP. "all selected BSEG records - they are compared against the expected field value

          IF lb_match_for_bd_item_found IS INITIAL.
            ev_check_status = abap_false.
            me->mo_run_environment->append_log( iv_log_statement = |Found no BSEG entry that has { <field_to_check>-bseg_field_name } with expected value { <expected_value> }| ).
          ENDIF.

        ENDIF.


        "ACDOCA - check via BD item id
        IF <field_to_check>-acdoca_field_name IS NOT INITIAL.

          me->mo_run_environment->append_log( iv_log_statement = |Validating field ACDOCA-{ <field_to_check>-acdoca_field_name }| ).

          LOOP AT acdoca_entries ASSIGNING <acdoca> WHERE awitem = <billing_pos>-posnr.

            ASSIGN COMPONENT <field_to_check>-acdoca_field_name OF STRUCTURE <acdoca> TO <acdoca_entry>.
            IF sy-subrc IS NOT INITIAL.
              me->mo_run_environment->append_log( iv_log_statement = |Field { <field_to_check>-acdoca_field_name } does not exist in type ACDOCA| ).
              ev_check_status = abap_false.
              CONTINUE.
            ENDIF.

            IF <acdoca_entry> NE <expected_value>.
              ev_check_status = abap_false.
              me->mo_run_environment->append_log( iv_log_statement = |ACDOCA entry for { <field_to_check>-acdoca_field_name } is not as expected| ).
              me->mo_run_environment->append_log( iv_log_statement = |Expected: { <expected_value> }| ).
              me->mo_run_environment->append_log( iv_log_statement = |Actual: { <acdoca_entry> }| ).
              me->mo_run_environment->append_log( iv_log_statement = |----------| ).
            ENDIF.

          ENDLOOP.

        ENDIF.


      ENDLOOP.   "bd items

    ENDLOOP.  "fields_to_check WHERE field_type = 'I'

  ENDLOOP.  "ref_docs


ENDMETHOD.


METHOD check_fi_kidno.
  DATA: test_data    TYPE ty_check_bseg_tax_country,
        lt_vbeln     TYPE cl_ptf_util=>ty_vbeln_tab,
        awref        TYPE acchd-awref,
        fi_documents TYPE STANDARD TABLE OF bkpf WITH DEFAULT KEY,
        bseg_entries TYPE STANDARD TABLE OF bseg WITH DEFAULT KEY.

  DATA(current_step) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

  LOOP AT current_step-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.
  ev_check_status = abap_true.
  ev_execution_status = abap_false.
  LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<billing_doc>).
    CLEAR fi_documents.
    awref = <billing_doc>-vbeln.
    CALL FUNCTION 'FI_DOCUMENT_READ'
      EXPORTING
        i_awtyp = 'VBRK'
        i_awref = awref
      TABLES
        t_bkpf  = fi_documents.

    LOOP AT fi_documents ASSIGNING FIELD-SYMBOL(<fi_doc>).
      CLEAR bseg_entries.
      SELECT * FROM bseg WHERE bukrs = @<fi_doc>-bukrs AND belnr = @<fi_doc>-belnr AND gjahr = @<fi_doc>-gjahr INTO TABLE @bseg_entries.

      IF bseg_entries IS NOT INITIAL.
        LOOP AT bseg_entries ASSIGNING FIELD-SYMBOL(<bseg_entry>).

          SELECT * FROM vbrk WHERE vbeln = @awref INTO TABLE @DATA(lt_vbrk).
          READ TABLE lt_vbrk INDEX 1 INTO DATA(ls_vbrk).

          IF ls_vbrk-sfakn IS NOT INITIAL.
*             case 1: cancellation document -> KIDNO should be filled with number of cancelled billing document
            IF <bseg_entry>-kidno NE ls_vbrk-sfakn.
              ev_check_status = abap_false.
              me->mo_run_environment->append_log( iv_log_statement = |Payment reference (KIDNO) in bseg is not correct| ).
              me->mo_run_environment->append_log( iv_log_statement = |Payment reference (KIDNO){ ls_vbrk-sfakn }| ).
            ENDIF.

          ELSEIF ls_vbrk-vbtyp EQ if_sd_doc_category=>credit_memo.
*             case 2: credit memo ?????????????
          ELSE.
*             case 3: no cancellation document and no credit memo KIDNO should be filled billing document number
            IF <bseg_entry>-kidno NE ls_vbrk-vbeln.
              ev_check_status = abap_false.
              me->mo_run_environment->append_log( iv_log_statement = |Payment reference (KIDNO) in bseg is not correct| ).
              me->mo_run_environment->append_log( iv_log_statement = |Payment reference (KIDNO){ ls_vbrk-vbeln }| ).
            ENDIF.

          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP.

  ENDLOOP.

  ev_execution_status = abap_true.
ENDMETHOD.


METHOD check_fi_tax_country.
  DATA: test_data    TYPE ty_check_bseg_tax_country,
        lt_vbeln     TYPE cl_ptf_util=>ty_vbeln_tab,
        awref        TYPE acchd-awref,
        fi_documents TYPE STANDARD TABLE OF bkpf WITH DEFAULT KEY,
        bseg_entries TYPE STANDARD TABLE OF bseg WITH DEFAULT KEY.

  DATA(current_step) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

  cl_ptf_util=>get_testdata(
    EXPORTING
      is_step_data = current_step
    IMPORTING
      es_testdata  = test_data
  ).

  LOOP AT current_step-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.
  IF lt_vbeln IS INITIAL.
    me->mo_run_environment->append_log( 'There are no documentIDs to check!' ).
    RETURN.
  ENDIF.

  ev_check_status = abap_true.
  ev_execution_status = abap_false.

  LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<billing_doc>).
    CLEAR fi_documents.
    awref = <billing_doc>-vbeln.
    CALL FUNCTION 'FI_DOCUMENT_READ'
      EXPORTING
        i_awtyp = 'VBRK'
        i_awref = awref
      TABLES
        t_bkpf  = fi_documents.

    LOOP AT fi_documents ASSIGNING FIELD-SYMBOL(<fi_doc>).
      CLEAR bseg_entries.
      SELECT * FROM bseg WHERE bukrs = @<fi_doc>-bukrs AND belnr = @<fi_doc>-belnr AND gjahr = @<fi_doc>-gjahr INTO TABLE @bseg_entries.

      IF bseg_entries IS NOT INITIAL.
        LOOP AT bseg_entries ASSIGNING FIELD-SYMBOL(<bseg_entry>).
          me->mo_run_environment->append_log( 'Comparing BSEG entry.' ).
          IF <bseg_entry>-tax_country NE test_data-tax_country.
            ev_check_status = abap_false.  "corrected June 1, 2021
            me->mo_run_environment->append_log( iv_log_statement = |Tax country in bseg is not correct| ).
            me->mo_run_environment->append_log( iv_log_statement = |bseg-bukrs = { <bseg_entry>-bukrs } bseg-belnr = { <bseg_entry>-belnr } bseg-gjahr = { <bseg_entry>-gjahr } bseg-buzei = { <bseg_entry>-buzei } | ).
            me->mo_run_environment->append_log( iv_log_statement = |Expected tax country: { test_data-tax_country }| ).
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP.

  ENDLOOP.

  IF ev_check_status EQ abap_true.
    me->mo_run_environment->append_log( iv_log_statement = |No problem found.| ).
  ENDIF.

  ev_execution_status = abap_true.

ENDMETHOD.


METHOD check_flex_bbi_cm_dm.
  DATA: lt_vbeln TYPE if_sd_bil_type_def=>tt_billing_document.

* Step 1: Get referenced documents
  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    IF lines( lt_ptf_keys ) EQ 0.
      me->mo_run_environment->append_log( iv_log_statement = |No documents found for step { <lv_ref_step> }| ).
    ENDIF.
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.

  IF lines( lt_vbeln ) EQ 0.
    me->mo_run_environment->append_log( iv_log_statement = |Nothing to check.| ).
    RETURN.
  ENDIF.

  SELECT vbrp~vbeln, vbrp~posnr, vbrp~fkimg, vbrp~uecha, vbrp~batch_billing_variant, vbrp~vgbel, vbrp~vgpos, preceding~batch_billing_variant AS vg_variant
    FROM vbrp AS vbrp
    LEFT JOIN vbrp AS preceding
    ON vbrp~vgbel = preceding~vbeln AND vbrp~vgpos = preceding~posnr
    FOR ALL ENTRIES IN @lt_vbeln
    WHERE vbrp~vbeln = @lt_vbeln-vbeln
    INTO TABLE @DATA(lt_bd_items).

* Step 2: Perform checks
  LOOP AT lt_bd_items ASSIGNING FIELD-SYMBOL(<ls_bd_item>).
    "Check quantity is greater than zero
    IF <ls_bd_item>-fkimg LE 0.
      me->mo_run_environment->append_log( iv_log_statement = |All items should have billing quantity greater than zero.| ).
      RETURN.
    ENDIF.

    "Higher-level batch item should be initial if preceding item has batch_billing_variant.
    IF <ls_bd_item>-vg_variant IS NOT INITIAL AND <ls_bd_item>-uecha IS NOT INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Field UECHA must be initial if preceding item has batch_billing_variant.| ).
      RETURN.
    ENDIF.

    "Batch Item Billing Variant should be initial.
    IF <ls_bd_item>-batch_billing_variant IS NOT INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Field BATCH_BILLING_VARIANT must be initial.| ).
      RETURN.
    ENDIF.
  ENDLOOP.

* Step 3: Set success message and status
  ev_check_status = abap_true.
  me->mo_run_environment->append_log( iv_log_statement = |Check was successful.| ).
ENDMETHOD.


METHOD check_hxf.


  TYPES: BEGIN OF ENUM lty_factor_source,
           fin,
           preceding,
           no_source,
         END OF ENUM lty_factor_source.
  TYPES: BEGIN OF ENUM lty_factor_reason,
           rfbsk,
           fareg,
           rita_active,
           rita_cntry,
           hxf_scope_bukrs,
           hxf_scope_landtx,
           rita_hxf,
           init,
         END OF ENUM lty_factor_reason.
  TYPES:
    BEGIN OF lty_vbrp_helper,
      vbeln            TYPE vbrp-vbeln,
      posnr            TYPE vbrp-posnr,
      ccode_factor_exp TYPE abap_bool,
      cntry_factor_exp TYPE abap_bool,
      factor_reason    TYPE lty_factor_reason,
    END OF lty_vbrp_helper .
  TYPES:
    ltty_vbrp_helper TYPE HASHED TABLE OF lty_vbrp_helper WITH UNIQUE KEY vbeln posnr .


  DATA: lt_vbeln TYPE STANDARD TABLE OF vbrk-vbeln,
        lt_awkey TYPE if_fot_hxf_migration_helper=>tt_object_key,
        lv_awkey TYPE awkey.
  DATA: hxf_helper TYPE REF TO if_fot_hxf_migration_helper.
  DATA: lt_exp_result TYPE ltty_vbrp_helper .
  DATA: lt_vbrk_dflow TYPE if_sdbil_dflow_orig_bd_access=>ty_t_vbrk.

  DATA lv_factor_source TYPE lty_factor_source VALUE no_source.

  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    LOOP AT lt_ptf_keys ASSIGNING FIELD-SYMBOL(<ls_ptf_keys>).
      lv_awkey = <ls_ptf_keys>-vbeln.
      INSERT lv_awkey INTO TABLE lt_awkey.
    ENDLOOP.
  ENDLOOP.
  IF lt_vbeln IS NOT INITIAL.
    SELECT p~vbeln, p~posnr, p~fareg, p~t2ccode_crcy_conv_factor, p~t2cntry_crcy_conv_factor, p~vgbel, p~vgpos, p~vgtyp,
       h~bukrs, h~landtx, h~rfbsk, h~vbtyp FROM vbrp AS p
      INNER JOIN vbrk AS h ON h~vbeln = p~vbeln INTO TABLE @DATA(lt_billing_data) FOR ALL ENTRIES IN @lt_vbeln WHERE p~vbeln = @lt_vbeln-table_line.
    SORT lt_billing_data BY vbeln posnr.
*     Get original document
    DATA(lo_dflow_access) = cl_sdbil_external_factory=>get( )->create_bil_docflow_access( ).
    LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<lv_vbeln>).
      READ TABLE lt_billing_data WITH KEY vbeln = <lv_vbeln> BINARY SEARCH ASSIGNING FIELD-SYMBOL(<ls_billing_data>).
      IF sy-subrc = 0.
        APPEND CORRESPONDING #( <ls_billing_data> ) TO lt_vbrk_dflow.
      ENDIF.
    ENDLOOP.
    lo_dflow_access->if_sdbil_dflow_orig_bd_access~fetch_invoice_flow_mass(
      it_vbrk = lt_vbrk_dflow
      it_vbrp = CORRESPONDING #( lt_billing_data )
    ).
*     Get original document factors
    DATA(lo_bil_vbrp_access) = cl_sdbil_core_factory=>get( )->get_vbrp_access( VALUE #( ( 'T2CCODE_CRCY_CONV_FACTOR' ) ( 'T2CNTRY_CRCY_CONV_FACTOR' ) ) ).
    lo_bil_vbrp_access->get_vbrp_mass(
      CORRESPONDING #( lo_dflow_access->if_sdbil_dflow_orig_bd_access~mt_invoice_flow MAPPING
          vbeln = reference_invoice
          posnr = reference_invc_item ) ).
  ELSE.
    me->mo_run_environment->append_log( iv_log_statement = |W: No documents to check!| ).
    RETURN.
  ENDIF.
  IF lt_awkey IS NOT INITIAL.
*      hxf_helper = cf_fot_hxf_migration=>create_helper( ).
*      TRY.
*          hxf_helper->calc_curr_conv_fact_4_obj_keys(
*            EXPORTING
*              i_object_type                  = 'VBRK'
*              i_object_keys                  = lt_awkey
*            IMPORTING
*              e_curr_conv_fact_4_object_keys = DATA(lt_fin_factors)
*              e_messages                     = DATA(lt_errors)
*          ).
*        CATCH cx_fot_migration INTO DATA(lx_mig_exc).
*          ev_check_status = abap_false.
*          me->mo_run_environment->append_log( iv_log_statement = lx_mig_exc->get_text( ) ).
*      ENDTRY.
    SELECT DISTINCT awkey, t~mwskz, t~tax_country, t~txjcd FROM bset AS t INNER JOIN bkpf AS h ON h~bukrs = t~bukrs AND h~belnr = t~belnr AND h~gjahr = t~gjahr
      INTO TABLE @DATA(lt_bset_data) FOR ALL ENTRIES IN @lt_awkey WHERE h~awtyp = 'VBRK' AND h~awkey = @lt_awkey-table_line.
  ENDIF.
  ev_check_status = abap_true.

  SORT lt_bset_data BY awkey mwskz tax_country txjcd.
  LOOP AT lt_billing_data ASSIGNING <ls_billing_data>.
    INSERT VALUE #( vbeln = <ls_billing_data>-vbeln posnr = <ls_billing_data>-posnr
                    ccode_factor_exp = abap_true cntry_factor_exp = abap_true
                    factor_reason = init )
           INTO TABLE lt_exp_result ASSIGNING FIELD-SYMBOL(<ls_exp_result>).
    IF <ls_billing_data>-rfbsk <> 'C'.
      <ls_exp_result>-factor_reason = rfbsk.
      <ls_exp_result>-ccode_factor_exp = abap_false.
      <ls_exp_result>-cntry_factor_exp = abap_false.
      CONTINUE.
    ENDIF.
    IF <ls_billing_data>-fareg CA '45'.
      <ls_exp_result>-factor_reason = fareg.
      <ls_exp_result>-ccode_factor_exp = abap_false.
      <ls_exp_result>-cntry_factor_exp = abap_false.
      CONTINUE.
    ENDIF.
    DATA(lv_rita_active) = cl_fot_txa_utilities=>agent->is_tax_abroad_active( <ls_billing_data>-bukrs ).
    IF lv_rita_active = abap_false.
      <ls_exp_result>-factor_reason = rita_active.
      <ls_exp_result>-cntry_factor_exp = abap_false.
    ELSE.
      DATA(lv_hxf_in_scope_landtx) =  cf_fot_hxf=>get_utility( )->is_hxf_scoped_for_country( i_country = <ls_billing_data>-landtx ).
      IF lv_hxf_in_scope_landtx = abap_false.
        <ls_exp_result>-factor_reason = hxf_scope_landtx.
        <ls_exp_result>-cntry_factor_exp = abap_false.
      ENDIF.
    ENDIF.
    DATA(lv_bukrs_country) = cl_fot_common_dao=>agent->get_company_data( <ls_billing_data>-bukrs )-land1.
    DATA(lv_hxf_in_scope_bukrs) =  cf_fot_hxf=>get_utility( )->is_hxf_scoped_for_country( i_country = lv_bukrs_country ).
    IF lv_hxf_in_scope_bukrs = abap_false.
      <ls_exp_result>-factor_reason = COND #( WHEN lv_rita_active = abap_true THEN hxf_scope_bukrs ELSE rita_hxf ).
      <ls_exp_result>-ccode_factor_exp = abap_false.
    ENDIF.
  ENDLOOP.
**  Log errors:
  LOOP AT lt_billing_data ASSIGNING <ls_billing_data>.
    DATA(ls_exp_result) = lt_exp_result[ vbeln = <ls_billing_data>-vbeln posnr = <ls_billing_data>-posnr ].
    me->mo_run_environment->append_log( iv_log_statement = |Billing document { <ls_billing_data>-vbeln }-{ <ls_billing_data>-posnr }| ).
    CASE ls_exp_result-factor_reason.
      WHEN rfbsk.
        me->mo_run_environment->append_log( iv_log_statement = |Not posted to FI| ).
      WHEN fareg.
        me->mo_run_environment->append_log( iv_log_statement = |Down payment (settlement)| ).
      WHEN rita_active.
        me->mo_run_environment->append_log( iv_log_statement = |RITA not active.| ).
      WHEN rita_cntry.
        me->mo_run_environment->append_log( iv_log_statement = |RITA not enabled for the tax country { <ls_billing_data>-landtx }.| ).
      WHEN hxf_scope_bukrs.
        me->mo_run_environment->append_log( iv_log_statement = |HXF not in scope for the company code country{ <ls_billing_data>-bukrs }.| ).
      WHEN hxf_scope_landtx.
        me->mo_run_environment->append_log( iv_log_statement = |HXF not in scope for the tax country{ <ls_billing_data>-landtx }.| ).
      WHEN OTHERS.
    ENDCASE.

    IF ls_exp_result-ccode_factor_exp = abap_true AND <ls_billing_data>-t2ccode_crcy_conv_factor IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |E: Company code factor expected.| ).
      ev_check_status = abap_false.
    ELSEIF ls_exp_result-ccode_factor_exp = abap_false AND <ls_billing_data>-t2ccode_crcy_conv_factor IS NOT INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |E: No company code factor expected. { <ls_billing_data>-t2ccode_crcy_conv_factor NUMBER = USER }| ).
      ev_check_status = abap_false.
    ELSEIF ls_exp_result-cntry_factor_exp = abap_true AND <ls_billing_data>-t2cntry_crcy_conv_factor IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |E: Country factor expected.| ).
      ev_check_status = abap_false.
    ELSEIF ls_exp_result-cntry_factor_exp = abap_false AND <ls_billing_data>-t2cntry_crcy_conv_factor IS NOT INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |E: No country factor expected. { <ls_billing_data>-t2cntry_crcy_conv_factor NUMBER = USER }| ).
      ev_check_status = abap_false.
    ELSE.
      DATA(ls_origdoc) = lo_dflow_access->if_sdbil_dflow_orig_bd_access~get_reference_invoice( iv_billing_document = <ls_billing_data>-vbeln iv_billing_document_item = <ls_billing_data>-posnr ).
      DATA(ls_orig_factors) = COND #(
              WHEN ls_origdoc-reference_invoice IS INITIAL THEN
                VALUE vbrp(  )
              ELSE
                lo_bil_vbrp_access->get_vbrp( VALUE #( vbeln = ls_origdoc-reference_invoice
                                                       posnr = ls_origdoc-reference_invc_item ) ) ).
      IF ls_orig_factors IS NOT INITIAL.
        lv_factor_source = preceding.
        IF ls_exp_result-ccode_factor_exp = abap_true AND ls_orig_factors-t2ccode_crcy_conv_factor <> <ls_billing_data>-t2ccode_crcy_conv_factor.
          me->mo_run_environment->append_log( iv_log_statement = |E: Company code factor not the same as original document factor.| ).
        ELSEIF ls_exp_result-cntry_factor_exp = abap_true AND ls_orig_factors-t2cntry_crcy_conv_factor <> <ls_billing_data>-t2cntry_crcy_conv_factor.
          me->mo_run_environment->append_log( iv_log_statement = |E: Country factor not the same as original document factor.| ).
        ELSE.
          me->mo_run_environment->append_log( iv_log_statement = |Factors same as orifinal document factors.| ).
        ENDIF.
      ELSE.
        me->mo_run_environment->append_log( iv_log_statement = |Factors filled as expected.| ).
      ENDIF.
    ENDIF.

  ENDLOOP.



  ev_execution_status = abap_true.
ENDMETHOD.


METHOD check_line_items.

  DATA: ls_testdata        TYPE sdbil_esr_cdm_request_msg,
        lv_prestepnumber   TYPE LINE OF cl_ptf_util=>gt_ptf_step-reference_step,
        ls_check_step_data TYPE cl_ptf_util=>gt_ptf_step,
        lv_vbeln           TYPE vbeln,
        error_message      TYPE bapi_msg,
        ls_return          TYPE bapiret2,
        lv_error_occured   TYPE abap_bool VALUE abap_false,
        lt_vbeln           TYPE cl_ptf_util=>ty_vbeln_tab,
        ls_vbeln           TYPE LINE OF cl_ptf_util=>ty_vbeln_tab,
        var_step           TYPE string.

  TYPES: BEGIN OF lty_amount,
           amount TYPE ukm_credit_limit,
           objkey TYPE swo_typeid,
         END OF lty_amount.

  DATA: lt_result TYPE TABLE OF lty_amount,
        srch_str  TYPE c LENGTH 80.

  ev_check_status = abap_true.

  DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

  ev_check_status = abap_true.

*  IF ls_step_data-variant IS NOT INITIAL.
*    cl_ptf_util=>get_testdata(
*      EXPORTING
*        is_step_data = ls_step_data
*      IMPORTING
*        es_testdata  = ls_testdata
*    ).
*  ELSE.
*    ev_check_status = abap_false.
*    EXIT.
*  ENDIF.

  LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.
  IF lt_vbeln IS INITIAL.
    me->mo_run_environment->append_log( |'There are no documentIDs to check!'| ).
    ev_check_status = abap_false.
    RETURN.
  ENDIF.

  LOOP AT lt_vbeln INTO DATA(lt_vbeln_single).
    CLEAR srch_str.
    srch_str = '%' && lt_vbeln_single-vbeln && '%'.
    SELECT FROM v_ukm_item FIELDS * WHERE objkey LIKE @srch_str INTO CORRESPONDING FIELDS OF TABLE @lt_result.
    LOOP AT lt_result INTO DATA(ls_result).
      IF ls_result-amount <= 0.
        ev_check_status = abap_false.
        me->mo_run_environment->append_log( |'Credit Management Line Items Commitment Field is less than zero. '| ).
      ENDIF.
    ENDLOOP.
  ENDLOOP.

  IF ev_check_status = abap_true.
    me->mo_run_environment->append_log( |'Check method successfully finished.'| ).
    ev_execution_status = abap_true.
  ENDIF.
ENDMETHOD.


METHOD check_multiple.
  "Use this method in case one step creates multiple invoices
  DATA: testdata_ext       TYPE ty_gs_ptf_multiple_checks_td,
        testdata           TYPE multiple_bd_check,
        entries            TYPE multiple_bd_check,
        check_stat_per_doc TYPE abap_bool,
        lt_vbeln           TYPE cl_ptf_util=>ty_vbeln_tab,
        docs_to_check      TYPE cl_ptf_util=>ty_vbeln_tab.

  IF step_data-variant IS NOT INITIAL.
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = testdata_ext
    ).
  ENDIF.

  testdata = testdata_ext-checks.
  SORT testdata BY idx.

  LOOP AT testdata ASSIGNING FIELD-SYMBOL(<tst_check>).
    LOOP AT testdata ASSIGNING FIELD-SYMBOL(<tst>).
      IF <tst>-idx EQ <tst_check>-idx.
        APPEND <tst> TO entries.
      ENDIF.
    ENDLOOP.
    IF lines( entries ) NE 1.
      me->mo_run_environment->append_log( iv_log_statement = |Wrong configuration of testdata. Index { <tst_check>-idx } occurs multiple times.| ).
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.
    CLEAR entries.
  ENDLOOP.

  ev_check_status = abap_true.

  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.


    IF lines( testdata ) NE lines( lt_vbeln ).
      me->mo_run_environment->append_log( iv_log_statement = |Number of generated documents ( { lines( lt_vbeln ) } ) of step { <lv_ref_step> } does not match number of documents to be checked ( { lines( testdata ) } ).| ).
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.

    LOOP AT testdata ASSIGNING FIELD-SYMBOL(<test_set>).
      READ TABLE lt_vbeln ASSIGNING FIELD-SYMBOL(<doc_to_check>) INDEX <test_set>-idx.

      IF <doc_to_check> IS NOT ASSIGNED.
        me->mo_run_environment->append_log( iv_log_statement = |There is no document behind index: { <test_set>-idx } for step { <lv_ref_step> }.| ).
        ev_check_status  = abap_false.
        ev_execution_status = abap_false.
        RETURN.
      ENDIF.

      APPEND <doc_to_check> TO docs_to_check.

      me->internal_check_v2(
        EXPORTING
          iv_step_number      = iv_step_number
          ls_testdata         = <test_set>-check_data
          lt_vbeln            = docs_to_check
        IMPORTING
          ev_document_id      = ev_document_id
          ev_execution_status = ev_execution_status
          ev_check_status     = check_stat_per_doc
      ).

      IF check_stat_per_doc EQ abap_false.
        ev_check_status = abap_false.
        me->mo_run_environment->append_log( iv_log_statement = |The document { <doc_to_check>-vbeln } does not match check data with index { <test_set>-idx } for step { <lv_ref_step> }.| ).
      ENDIF.

      CLEAR docs_to_check.

    ENDLOOP.

    CLEAR lt_vbeln.

  ENDLOOP.

  ev_execution_status = abap_true.

ENDMETHOD.


METHOD check_multi_cdm.
  DATA: ls_testdata                TYPE sdbil_esr_cdm_request_msg,
        lv_prestepnumber           TYPE LINE OF cl_ptf_util=>gt_ptf_step-reference_step,
        ls_check_step_data         TYPE cl_ptf_util=>gt_ptf_step,
        lv_vbeln                   TYPE vbeln,
        error_message              TYPE bapi_msg,
        ls_return                  TYPE bapiret2,
        lv_error_occured           TYPE abap_bool VALUE abap_false,
        lt_vbeln                   TYPE cl_ptf_util=>ty_vbeln_tab,
        ls_vbeln                   TYPE LINE OF cl_ptf_util=>ty_vbeln_tab,
        var_step                   TYPE string,
        lt_komfkgn                 TYPE komfkgn_tab,
        ls_reference_document      TYPE cdmr_cdmr_document,
        ls_reference_document_item TYPE cdmr_cdmr_document_item,
        ls_pricing_elements        TYPE sdbil_esr_sbi_bd_prcg_element,
        ls_xkomv                   TYPE komv,
        ls_buffer                  TYPE komv.

  DATA: ls_vbrk_i TYPE vbrk,
        ls_vbrk_e TYPE vbrk,
        lt_xvbrk  TYPE TABLE OF vbrkvb,
        lt_xvbrp  TYPE TABLE OF vbrpvb,
        lt_xkomv  TYPE TABLE OF komv,
        lt_xvbpa  TYPE TABLE OF vbpavb.

  DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

  ev_check_status = abap_true.

  IF ls_step_data-variant IS NOT INITIAL.
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).
  ELSE.
    ev_check_status = abap_false.
    EXIT.
  ENDIF.

  LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.
  IF lt_vbeln IS INITIAL.
    me->mo_run_environment->append_log( |'There are no documentIDs to check!'| ).
    ev_check_status = abap_false.
    RETURN.
  ENDIF.

  LOOP AT lt_vbeln INTO ls_vbeln.
    ls_vbrk_i-vbeln = ls_vbeln-vbeln.

    CLEAR lt_xvbrk.
    CLEAR lt_xkomv.

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

    READ TABLE lt_xvbrk INTO DATA(ls_vbrk) INDEX 1.

    READ TABLE ls_testdata-reference_document WITH KEY document_reference_id = ls_vbrk-xblnr INTO ls_reference_document.

    IF ls_reference_document-billing_document_type IS NOT INITIAL.
      IF ls_vbrk-fkart EQ ls_reference_document-billing_document_type.
      ELSE.
        ev_check_status = abap_false.
        me->mo_run_environment->append_log( |'Fkart and Target_Billing_Document_Type do not match!'| ).
      ENDIF.
    ENDIF.

    IF ls_vbrk-fkdat IS NOT INITIAL.
      IF ls_vbrk-fkdat EQ sy-datum.
      ELSE.
        ev_check_status = abap_false.
        me->mo_run_environment->append_log( |'Fkdat and Sy-Datum do not match!'| ).
      ENDIF.
    ENDIF.

    IF ls_vbrk-rfbsk EQ 'C' AND ls_testdata-action_control-autom_posting_to_acctg_is_disa = ' '.
      me->mo_run_environment->append_log( |'Transfer to accounting successful' { ls_vbrk-vbeln }| ).
    ELSEIF ls_vbrk-rfbsk EQ ' ' AND ls_testdata-action_control-autom_posting_to_acctg_is_disa = 'X'.
      me->mo_run_environment->append_log( |'No transfer to accounting' { ls_vbrk-vbeln  } | ).
    ELSE.
      me->mo_run_environment->append_log( |'Test data container field Billing_Document_is_not_posted and field vbrk-rfbsk do not match!' { ls_vbrk-vbeln  } | ).
      ev_check_status = abap_false.
    ENDIF.

    IF ls_reference_document-assignment_reference IS NOT INITIAL.
      IF ls_vbrk-zuonr EQ ls_reference_document-assignment_reference.
      ELSE.
        ev_check_status = abap_false.
        me->mo_run_environment->append_log( |'Zuonr and Assignment_Reference do not match!'| ).
      ENDIF.
    ENDIF.

    IF ls_reference_document-reference_document_item IS NOT INITIAL.

      LOOP AT ls_reference_document-reference_document_item  INTO ls_reference_document_item.

        READ TABLE lt_xvbrp WITH KEY vgpos = ls_reference_document_item-reference_billing_document_ite INTO DATA(ls_vbrp_1).

        IF ls_reference_document_item-sddocument_reason IS NOT INITIAL.
          IF ls_vbrp_1-augru_auft EQ ls_reference_document_item-sddocument_reason.
          ELSE.
            ev_check_status = abap_false.
            me->mo_run_environment->append_log( |'Augru_auft and SDDocument_Reason do not match!'| ).
          ENDIF.
        ENDIF.

        IF ls_reference_document_item-quantity-content IS NOT INITIAL.
          IF ls_vbrp_1-fkimg EQ ls_reference_document_item-quantity-content.
          ELSE.
            ev_check_status = abap_false.
            me->mo_run_environment->append_log( |'Fkimg and Quantity-Content do not match!'| ).
          ENDIF.
        ENDIF.

        IF ls_reference_document_item-pricing_elements IS NOT INITIAL.

          LOOP AT ls_reference_document_item-pricing_elements INTO ls_pricing_elements.

            READ TABLE lt_xkomv WITH KEY kschl = ls_pricing_elements-condition_type INTO ls_xkomv.

            IF sy-subrc <> 0.
              ev_check_status = abap_false.
              me->mo_run_environment->append_log( |'Kschl and Condition Type do not match!'| ).
            ELSE.

              IF ls_xkomv-waers EQ ls_pricing_elements-condition_currency.
              ELSE.
                ev_check_status = abap_false.
                me->mo_run_environment->append_log( |'Waers and Condition Currency do not match!'| ).
              ENDIF.
              IF ls_xkomv-kbetr EQ ls_pricing_elements-condition_rate_value.
              ELSE.
                ev_check_status = abap_false.
                me->mo_run_environment->append_log( |'Kbetr and Condition Rate Value do not match!'| ).
              ENDIF.
              IF ls_xkomv-kpein EQ ls_pricing_elements-condition_quantity-content.
              ELSE.
                ev_check_status = abap_false.
                me->mo_run_environment->append_log( |'Kpein and Condition Quantity Content do not match!'| ).
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDIF.

      ENDLOOP.
    ENDIF.

  ENDLOOP.

  IF ev_check_status = abap_true.
    me->mo_run_environment->append_log( |'Check method successfully finished.'| ).
    ev_execution_status = abap_true.
  ENDIF.

ENDMETHOD.


METHOD check_net_value_vkdfs_advico.
  DATA: error_occured TYPE abap_bool VALUE abap_false.
  DATA doc_ids TYPE TABLE OF vbeln.
  DATA lo_enrich_billduelist TYPE REF TO if_sdbil_enrich_billduelist.
  DATA lv_net_value TYPE netwr.
  DATA lv_currency TYPE waerk.
  DATA lt_delivery_items TYPE tab_lipsvb.
  DATA ls_delivery_item TYPE lipsvb.

  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
    DATA(ref_doc_ids) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
    LOOP AT ref_doc_ids ASSIGNING FIELD-SYMBOL(<ref_doc_id>).
      APPEND <ref_doc_id> TO doc_ids.
    ENDLOOP.
  ENDLOOP.

  lo_enrich_billduelist = cl_sdbil_external_factory=>get( )->create_enrich_billduelist( ).

  IF doc_ids IS INITIAL.
    me->mo_run_environment->append_log( iv_log_statement = |No reference documents exist.| ).
    ev_check_status = abap_false.
    ev_execution_status = abap_false.
  ELSE.
    SELECT vbeln, netwr, waerk, fkart FROM vkdfs FOR ALL ENTRIES IN @doc_ids WHERE vbeln = @doc_ids-table_line INTO TABLE @DATA(found_entries) .
    LOOP AT doc_ids ASSIGNING FIELD-SYMBOL(<doc_id>).
      READ TABLE found_entries WITH KEY vbeln = <doc_id> INTO DATA(ls_vkdfs_data).
      IF sy-subrc <> 0.
        me->mo_run_environment->append_log( iv_log_statement = |Document { <doc_id> } does not exist in VKDFS.| ).
        error_occured = abap_true.
        CONTINUE.
      ENDIF.
      IF NOT ls_vkdfs_data-fkart EQ 'IV2'.
        me->mo_run_environment->append_log( iv_log_statement = |Reference document is not invoiced with IV2 document category.| ).
        error_occured = abap_true.
        CONTINUE.
      ENDIF.
      SELECT * FROM lips INTO TABLE @lt_delivery_items WHERE vbeln = @<doc_id>.

      IF lt_delivery_items IS NOT INITIAL.
        LOOP AT lt_delivery_items INTO ls_delivery_item.
          DATA(ls_result) = lo_enrich_billduelist->calc_net_value_for_adv_ico_iv( is_delivery_item = ls_delivery_item ).               " Delivery Item Upwardly Compatible
          ADD ls_result-netwr TO lv_net_value.
        ENDLOOP.
        lv_currency = ls_result-waerk.
      ELSE.
        me->mo_run_environment->append_log( iv_log_statement = |Delivery Items not found.| ).
        error_occured = abap_true.
        CONTINUE.
      ENDIF.
      IF lv_net_value NE ls_vkdfs_data-netwr.
        me->mo_run_environment->append_log( iv_log_statement = |Net Value not as expected.| ).
        error_occured = abap_true.
      ENDIF.
      IF lv_currency NE ls_vkdfs_data-waerk.
        me->mo_run_environment->append_log( iv_log_statement = |Currency not as expected.| ).
        error_occured = abap_true.
      ENDIF.

      CLEAR lv_net_value.
      CLEAR lv_currency.
    ENDLOOP.

    IF error_occured <> abap_true.
      ev_check_status = abap_true.
    ELSE.
      ev_check_status = abap_false.
    ENDIF.

    ev_execution_status = abap_true.
  ENDIF.

ENDMETHOD.


METHOD check_new_projbill_dp_settl.

  DATA:
    lt_vbeln          TYPE if_sd_bil_type_def=>tt_billing_document,
    lv_netwr_faz      TYPE netwr_fp,
    lv_netwr_dp_settl TYPE netwr_fp.

  CONSTANTS:
    lc_billtype_ci01     TYPE fkart VALUE 'CI01',
    lc_status_completed  TYPE vf_status VALUE 'A',
    lc_status_tobeposted TYPE vf_status VALUE 'B'.

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
    me->mo_run_environment->append_log( iv_log_statement = |Nothing to check.| ).
    RETURN.
  ELSEIF lines( lt_vbeln ) NE 1.
    me->mo_run_environment->append_log( iv_log_statement = |Check can only be executed for one down payment request.| ).
    RETURN.
  ENDIF.


******************************************************************************
* Step 2: Get items of down payment request (faz)
  SELECT vbeln, posnr, fplnr, fpltr, netwr
    FROM vbrp
    FOR ALL ENTRIES IN @lt_vbeln
    WHERE vbeln = @lt_vbeln-vbeln
    INTO TABLE @DATA(lt_items_faz).


******************************************************************************
* Step 3: Get invoice items which are downpayment settlements
  IF lt_items_faz IS NOT INITIAL.
    SELECT vbeln, posnr, netwr
    FROM vbrp
    FOR ALL ENTRIES IN @lt_items_faz
    WHERE fplnr = @lt_items_faz-fplnr
      AND fpltr = @lt_items_faz-fpltr
      AND fkart_ana = @lc_billtype_ci01
      AND ( vf_status_ana = @lc_status_completed OR vf_status_ana = @lc_status_tobeposted )
    INTO TABLE @DATA(lt_dp_settlement).
  ENDIF.


******************************************************************************
* Step 4: Compare sum netvalue of down payment request and downpayment settlements
  LOOP AT lt_items_faz ASSIGNING FIELD-SYMBOL(<ls_item_faz>).
    lv_netwr_faz = lv_netwr_faz + <ls_item_faz>-netwr.
  ENDLOOP.

  LOOP AT lt_dp_settlement ASSIGNING FIELD-SYMBOL(<ls_dp_settlement>).
    lv_netwr_dp_settl = lv_netwr_dp_settl + <ls_dp_settlement>-netwr.
  ENDLOOP.

  IF lv_netwr_dp_settl LE lv_netwr_faz.
    ev_check_status = abap_true.
    me->mo_run_environment->append_log( iv_log_statement = |Downpayment settlements are lower or equal to down payment request.| ).
  ELSE.
    me->mo_run_environment->append_log( iv_log_statement = |Downpayment settlements must be equal of lower than down payment request.| ).
  ENDIF.


ENDMETHOD.


METHOD check_new_projbill_no_dp_settl.

  DATA:
   lt_vbeln TYPE if_sd_bil_type_def=>tt_billing_document.

* Step 1: Get referenced documents
  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    IF lines( lt_ptf_keys ) EQ 0.
      me->mo_run_environment->append_log( iv_log_statement = |No documents found for step { <lv_ref_step> }| ).
    ENDIF.
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.

  IF lines( lt_vbeln ) EQ 0.
    me->mo_run_environment->append_log( iv_log_statement = |Nothing to check.| ).
    RETURN.
  ENDIF.

* Step 2: Check credit memo has no downpayment settlements
  SELECT vbeln, posnr
    FROM vbrp
    FOR ALL ENTRIES IN @lt_vbeln
    WHERE vbeln = @lt_vbeln-vbeln
      AND fareg = @if_sd_doc_down_payment=>co_billing_rule-dp_mb_val
    INTO TABLE @DATA(lt_dp_settlements).

  IF lt_dp_settlements IS INITIAL.
    ev_check_status = abap_true.
    me->mo_run_environment->append_log( iv_log_statement = |Credit memo does not have down payment settlements.| ).
  ELSE.
    me->mo_run_environment->append_log( iv_log_statement = |Credit memo has down payment settlements.| ).
  ENDIF.

ENDMETHOD.


METHOD check_new_projbill_w_downpay.

  DATA:
    lt_vbeln TYPE if_sd_bil_type_def=>tt_billing_document.

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


******************************************************************************
* Step 2: Get items of invoice that are downpayment settlements
  SELECT vbeln, posnr, fbuda, fplnr, fpltr
    FROM vbrp
    FOR ALL ENTRIES IN @lt_vbeln
    WHERE vbeln = @lt_vbeln-vbeln
      AND fareg = '5'
    INTO TABLE @DATA(lt_items).


******************************************************************************
* Step 3: Check billing plan information
  LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<ls_items>).
    IF <ls_items>-fplnr IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Billing Plan Number is initial.| ).
      RETURN.
    ENDIF.

    IF <ls_items>-fpltr IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Billing Plan Item is initial.| ).
      RETURN.
    ENDIF.
  ENDLOOP.

  "Billing Plan Date in vbrp and fplt should be the same
  SELECT vbrp~vbeln, vbrp~posnr, vbrp~fbuda, fplt~afdat
    FROM vbrp JOIN fplt ON vbrp~fplnr = fplt~fplnr AND vbrp~fpltr = fplt~fpltr
    FOR ALL ENTRIES IN @lt_items
    WHERE vbrp~vbeln = @lt_items-vbeln AND
          vbrp~posnr = @lt_items-posnr
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


METHOD check_new_project_billing.

  DATA:
    lt_vbeln        TYPE if_sd_bil_type_def=>tt_billing_document.


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

  SELECT vbeln, posnr, prsdt, srcdoc_process_type, fbuda, vgbel, vgpos, fareg
    FROM vbrp
    FOR ALL ENTRIES IN @lt_vbeln
    WHERE vbeln = @lt_vbeln-vbeln
    ORDER BY PRIMARY KEY
    INTO TABLE @DATA(lt_items).

******************************************************************************
* Step 2: Check specific fields of invoice in new project billing process
  LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<ls_items>).
    "Check source document type
    IF <ls_items>-srcdoc_process_type <> 'PB'.
      me->mo_run_environment->append_log( iv_log_statement = |Special Source Document Type is not equal to PB.| ).
      RETURN.
    ENDIF.
  ENDLOOP.


  "WBS Elements in vbrp and vbap should be the same
  SELECT vbrp~vbeln, vbrp~posnr, vbrp~ps_psp_pnr, vbap~ps_psp_pnr AS ps_psp_pnr_vbap
    FROM vbrp JOIN vbap ON vbrp~aubel = vbap~vbeln AND vbrp~aupos = vbap~posnr
    FOR ALL ENTRIES IN @lt_items
    WHERE vbrp~vbeln = @lt_items-vbeln AND
          vbrp~posnr = @lt_items-posnr
    INTO TABLE @DATA(lt_wbselements).

  LOOP AT lt_wbselements ASSIGNING FIELD-SYMBOL(<ls_wbselements>).
    IF <ls_wbselements>-ps_psp_pnr <> <ls_wbselements>-ps_psp_pnr_vbap.
      me->mo_run_environment->append_log( iv_log_statement = |WBS Element different in vbrp and vbap.| ).
      RETURN.
    ENDIF.
  ENDLOOP.


  "Billing Plan Date in vbrp and fplt should be the same
  "Get Billing Plan via reference document
  SELECT vbrp~vbeln AS vgbel, vbrp~posnr AS vgpos, fplt~afdat
    FROM vbrp JOIN fplt ON vbrp~fplnr = fplt~fplnr AND vbrp~fpltr = fplt~fpltr
    FOR ALL ENTRIES IN @lt_items
    WHERE vbrp~vbeln = @lt_items-vgbel AND
          vbrp~posnr = @lt_items-vgpos
    INTO TABLE @DATA(lt_fbuda).

  LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<ls_item>) WHERE fareg <> '5'.
    LOOP AT lt_fbuda ASSIGNING FIELD-SYMBOL(<ls_fbuda>) WHERE vgbel = <ls_item>-vgbel AND vgpos = <ls_item>-vgpos.
      IF <ls_item>-fbuda <> <ls_fbuda>-afdat.
        me->mo_run_environment->append_log( iv_log_statement = |Billing Plan Date different in VBRP and FPLT.| ).
        RETURN.
      ENDIF.
    ENDLOOP.
  ENDLOOP.

  "Set success message and status
  ev_check_status = abap_true.
  me->mo_run_environment->append_log( iv_log_statement = |Check fields of new project billing process was successful.| ).

ENDMETHOD.


METHOD check_number_of_positions.
  DATA: testdata TYPE ty_gs_check_number_of_pos.

  cl_ptf_util=>get_testdata(
    EXPORTING
      is_step_data = step_data
    IMPORTING
      es_testdata  = testdata
  ).

  ev_check_status = abap_true.
  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
    DATA(doc_ids) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
    LOOP AT doc_ids INTO DATA(doc_id).
      SELECT * FROM vbrp INTO TABLE @DATA(table) WHERE vbeln = @doc_id-vbeln.
      IF lines( table ) <> testdata-expected_number.
        ev_check_status = abap_false.
        me->mo_run_environment->append_log( iv_log_statement = |The number of positions for BD { doc_id-vbeln } is { lines( table ) } but expected was { testdata-expected_number }| ).
      ENDIF.
    ENDLOOP.
  ENDLOOP.
  ev_execution_status = abap_true.
ENDMETHOD.


METHOD check_number_vkdfs_entries.
  DATA: error_occured TYPE abap_bool VALUE abap_false.
  DATA: ls_test_data TYPE ty_gs_i_ptf_vkdfs_check_td.
  DATA found_entries TYPE HASHED TABLE OF vbeln WITH UNIQUE KEY table_line.
  DATA doc_ids TYPE TABLE OF vbeln.
  DATA: num_of_found_entries TYPE i.

  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
    DATA(ref_doc_ids) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
    LOOP AT ref_doc_ids ASSIGNING FIELD-SYMBOL(<ref_doc_id>).
      APPEND <ref_doc_id> TO doc_ids.
    ENDLOOP.
  ENDLOOP.

  cl_ptf_util=>get_testdata(
    EXPORTING
      is_step_data = step_data
    IMPORTING
      es_testdata  = ls_test_data
  ).

  IF doc_ids IS INITIAL.
    me->mo_run_environment->append_log( iv_log_statement = |No reference documents exist.| ).
    ev_check_status = abap_false.
    ev_execution_status = abap_false.
  ELSE.
    ev_check_status = abap_true.
    LOOP AT doc_ids ASSIGNING FIELD-SYMBOL(<ls_doc>).
      SELECT COUNT( * ) FROM vkdfs WHERE vbeln = @<ls_doc> INTO @num_of_found_entries.
      IF num_of_found_entries <> ls_test_data-expected_entries.
        me->mo_run_environment->append_log( iv_log_statement = |Found { num_of_found_entries } for vbeln { <ls_doc> } in vkdfs but expected { ls_test_data-expected_entries }| ).
        ev_check_status = abap_false.
      ENDIF.
    ENDLOOP.
    ev_execution_status = abap_true.
  ENDIF.
ENDMETHOD.


METHOD check_output.
  DATA: lt_vbeln        TYPE TABLE OF cl_ptf_util=>ty_vbeln,
        ls_vbeln        TYPE cl_ptf_util=>ty_vbeln,
        lv_vbeln        TYPE string,
        ls_tdcv_content TYPE ptf_s_output_invocation,
        et_return       TYPE cl_ptf_util=>gt_ptf_return_tab.

  ev_check_status = abap_false.
*****************************************************************************
* 1 Step: Get TDCV
  cl_ptf_util=>get_testdata(
EXPORTING
  is_step_data = step_data
IMPORTING
  es_testdata  = ls_tdcv_content
).

  IF ls_tdcv_content-relevant_components IS NOT INITIAL AND ls_tdcv_content-irrelevant_components IS NOT INITIAL.
    me->mo_run_environment->append_log( iv_log_statement = |Please define relevant components XOR irrelevant components in your TDC.| ).
    ev_execution_status = abap_false.
    ev_check_status = abap_false.
    RETURN.
  ENDIF.
*****************************************************************************
* 2 Step: Get predecessors
  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.

*****************************************************************************
* 3 Step: Check output data
  LOOP AT lt_vbeln INTO ls_vbeln.
    lv_vbeln = ls_vbeln-vbeln.
    cl_ptf_output_compare=>execute(
      EXPORTING
        is_tdcv            = ls_tdcv_content
        iv_document_number = lv_vbeln ).
  ENDLOOP.
*****************************************************************************
* 4 Step: Map test result to PTF data
  cl_ptf_output_compare=>get_test_result(
    IMPORTING
      eb_test_status = ev_check_status
      et_log         = et_return ).
  ev_execution_status = abap_true.
  APPEND LINES OF lt_vbeln TO ev_document_id.
  LOOP AT et_return ASSIGNING FIELD-SYMBOL(<ls_msg>).
    me->mo_run_environment->append_log_structure( is_log = <ls_msg> ).
    "me->mo_run_environment->append_log( iv_log_statement = |{ <ls_msg>-message }| ).
  ENDLOOP.


ENDMETHOD.


METHOD check_paypal_data.

  DATA: lv_rplnr                 TYPE rplnr,
        lv_error_occured         TYPE abap_bool VALUE abap_false,
        ls_return                TYPE bapiret2,
        lt_check_data            TYPE ty_gs_ptf_paymentcard_check_td,
        lt_vbeln                 TYPE cl_ptf_util=>ty_vbeln_tab,
        lv_amount_w_4_dec_places TYPE sdbil_esr_amount_content.
**********************************************************************
*Get Predecessors and testdata
  ev_check_status = abap_false.

  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.
  IF lt_vbeln IS INITIAL.
    mo_run_environment->append_log( iv_log_statement = |There is no preceding document to check.| ).
    RETURN.
  ENDIF.

  cl_ptf_util=>get_testdata(
    EXPORTING
      is_step_data = step_data
    IMPORTING
      es_testdata  = lt_check_data
  ).

**********************************************************************
  LOOP AT lt_vbeln REFERENCE INTO DATA(ls_vbeln).

    SELECT SINGLE rplnr FROM vbrk INTO @lv_rplnr
                          WHERE vbeln = @ls_vbeln->vbeln.

    SELECT SINGLE ccins, autwr, ccwae, aunum, audat, autim, dp_psp, dp_psp_transid FROM fpltc INTO @DATA(ls_paypal)
      WHERE fplnr = @lv_rplnr.

  ENDLOOP.

  LOOP AT lt_check_data INTO DATA(ls_check_data).

    CONVERT TIME STAMP ls_check_data-authorization_date_time TIME ZONE sy-zonlo
    INTO DATE DATA(dat) TIME DATA(tim).

    "Faulty validation:
    IF NOT  ls_paypal-ccins          = ls_check_data-payment_card_type
        AND ls_paypal-autwr          = ls_check_data-authorized_amount_in_authzn_cr-content
        AND ls_paypal-ccwae          = ls_check_data-authorized_amount_in_authzn_cr-currency_code
        AND ls_paypal-dp_psp         = ls_check_data-payment_service_provider
        AND ls_paypal-dp_psp_transid = ls_check_data-transaction_by_payt_srvc_prvdr
        AND ls_paypal-audat          = dat
        AND ls_paypal-autim          = tim.
      lv_error_occured = abap_true.
      EXIT.
    ENDIF.

*    "Correct validation:
*    lv_amount_w_4_dec_places = ls_paypal-autwr.
*
*    IF NOT
*       (    ls_paypal-ccins          = ls_check_data-payment_card_type
*        AND lv_amount_w_4_dec_places = ls_check_data-authorized_amount_in_authzn_cr-content
*        AND ls_paypal-ccwae          = ls_check_data-authorized_amount_in_authzn_cr-currency_code
*        AND ls_paypal-dp_psp         = ls_check_data-payment_service_provider
*        AND ls_paypal-dp_psp_transid = ls_check_data-transaction_by_payt_srvc_prvdr
*        AND ls_paypal-audat          = dat
*        AND ls_paypal-autim          = tim
*       ).
*      lv_error_occured = abap_true.
*      EXIT.
*    ENDIF.

  ENDLOOP.

  IF lv_error_occured EQ abap_false.
    ls_return-message = |No deviations were found. This method checks only one record!|.
    me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
    ev_check_status = abap_true.
  ELSE.
    ls_return-message = 'There is at least one deviation.'.
    me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
  ENDIF.

  APPEND LINES OF lt_vbeln TO ev_document_id.
  ev_execution_status = abap_true.

ENDMETHOD.


METHOD check_preceding.

  DATA lv_ref_bo TYPE ptf_bo.
  DATA lt_vbeln TYPE cl_ptf_util=>ty_vbeln_tab.

  DATA(lt_ref_vbeln) = me->mo_run_environment->get_result_key_data( it_step_number = step_data-reference_step ).

  IF lines( lt_ref_vbeln ) NE 2.
    me->mo_run_environment->append_log( iv_log_statement = |Please reference exactly one BillingDocument and one preceding document.| ).
    ev_check_status = abap_false.
    ev_execution_status = abap_true.
    RETURN.
  ENDIF.
  lv_ref_bo = lt_ref_vbeln[ 1 ]-bus_obj.
  IF lv_ref_bo NE 'INVOICE' AND lv_ref_bo NE 'CREDIT_MEMO_REQUEST' AND lv_ref_bo NE 'DMR'.
    me->mo_run_environment->append_log( iv_log_statement = |The first referenced document is not a BillingDocument.| ).
    ev_check_status = abap_false.
    ev_execution_status = abap_true.
    RETURN.
  ENDIF.

  DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
  IF ls_step_data-variant IS NOT INITIAL.
    me->mo_run_environment->append_log( iv_log_statement = |This check does not support TDC variants, { ls_step_data-variant } is ignored.| ).
  ENDIF.

  "<<old
  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.
  "old>>

  DATA(billing_doc) = lt_vbeln[ 1 ].
  DATA(expected_preceding_document) = lt_vbeln[ 2 ].

  SELECT SINGLE xblnr FROM vbrk WHERE vbeln = @billing_doc-vbeln INTO @DATA(actual_preceding_document).

  IF actual_preceding_document NE expected_preceding_document.
    ev_check_status = abap_false.
    me->mo_run_environment->append_log( iv_log_statement = |Preceding document was not allocated correctly. Expected: { expected_preceding_document-vbeln } Actual: { actual_preceding_document }| ).
  ELSE.
    ev_check_status = abap_true.
  ENDIF.


  ev_execution_status = abap_true.

ENDMETHOD.


METHOD check_prefix.
  DATA: test_data           TYPE ty_gs_check_prefix,
        prefix              TYPE string,
        doc_id              TYPE string,
        doc_checks_executed TYPE abap_bool.

  cl_ptf_util=>get_testdata(
    EXPORTING
      is_step_data = step_data
    IMPORTING
      es_testdata  = test_data
  ).

  ev_check_status = abap_true.
  doc_checks_executed = abap_false.
  prefix = test_data-expected_prefix.

  DATA(regex) = |^[{ prefix }].*|.

  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
    DATA(ref_doc_ids) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).

    LOOP AT ref_doc_ids ASSIGNING FIELD-SYMBOL(<doc_id>).
      doc_checks_executed = abap_true.
      doc_id = <doc_id>.
      IF NOT matches( val = doc_id regex = regex ).
        ev_check_status = abap_false.
        me->mo_run_environment->append_log( iv_log_statement = |The document { doc_id } of step { <ref_step> } does not match regex { regex }.| ).
      ENDIF.
    ENDLOOP.
  ENDLOOP.

  IF doc_checks_executed = abap_false.
    ev_check_status = abap_false.
    me->mo_run_environment->append_log( iv_log_statement = |No reference documents exist.| ).
  ENDIF.

  ev_execution_status = abap_true.
ENDMETHOD.


METHOD check_price_greater_zero.
  DATA: lt_vbeln   TYPE cl_ptf_util=>ty_vbeln_tab,
        lt_vbrp    TYPE TABLE OF vbrp,
        lv_success TYPE abap_bool,
        ls_return  TYPE bapiret2,
        lv_message TYPE bapi_msg.

  FIELD-SYMBOLS: <ls_vbrp> TYPE vbrp.


  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.

  lv_success = abap_true.

  IF lt_vbeln IS NOT INITIAL.
    TYPES:
      BEGIN OF ty_vbeln_orig,
        vbeln TYPE vbeln,
      END OF ty_vbeln_orig.
    DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.
    MOVE lt_vbeln TO lt_vbeln_key.

    SELECT * FROM vbrp INTO TABLE lt_vbrp FOR ALL ENTRIES IN lt_vbeln_key WHERE vbeln = lt_vbeln_key-vbeln.

    LOOP AT lt_vbrp ASSIGNING <ls_vbrp>.
      IF <ls_vbrp>-netwr EQ 0.
        lv_success = abap_false.
        CLEAR ls_return.
        CONCATENATE 'Price of Position' <ls_vbrp>-posnr ' in Invoice' <ls_vbrp>-vbeln  'is 0.' INTO lv_message SEPARATED BY space.
        me->mo_run_environment->append_log( iv_log_statement = |{ lv_message }| ).
      ENDIF.
    ENDLOOP.
  ELSE.
    lv_success = abap_false.
    CLEAR ls_return.
    lv_message = 'No Predeccessors were found.' .
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_message }| ).
  ENDIF.

  ev_execution_status = abap_true.
  ev_check_status = lv_success.

ENDMETHOD.


METHOD check_pricing_conditions.
  DATA: testdata             TYPE ty_gs_bd_condition_check,
        billing_documents    TYPE STANDARD TABLE OF vbeln WITH DEFAULT KEY,
        conditions_for_bd    TYPE prcd_elements_tab,
        prcd_elements_fields TYPE extdfiest,
        index                TYPE i.

  CALL FUNCTION 'DD_INT_TABLINFO_GET'
    EXPORTING
      typename       = 'prcd_elements'
    TABLES
      extdfies_tab   = prcd_elements_fields
    EXCEPTIONS
      not_found      = 1
      internal_error = 2
      OTHERS         = 3.
  IF sy-subrc <> 0.
    ev_check_status = abap_false.
    me->mo_run_environment->append_log( iv_log_statement = |Error while retrieving fields for structure prcd_elements | ).
    RETURN.
  ENDIF.

  cl_ptf_util=>get_testdata(
    EXPORTING
      is_step_data = step_data
    IMPORTING
      es_testdata  = testdata
   ).

  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
    DATA(ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
    APPEND LINES OF ptf_keys TO billing_documents.
  ENDLOOP.

  ev_check_status = abap_true.
  LOOP AT billing_documents ASSIGNING FIELD-SYMBOL(<billing_document>).

    CLEAR conditions_for_bd.
    SELECT SINGLE  knumv FROM vbrk WHERE vbeln = @<billing_document> INTO @DATA(knumv).
    SELECT * FROM prcd_elements WHERE knumv = @knumv INTO TABLE @conditions_for_bd.

    IF lines( conditions_for_bd ) NE lines( testdata-prcd ).
      ev_check_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |# of expected and # of actual condition tpyes for bd { <billing_document> } is different. Expected: { lines( testdata-prcd ) } Actual: { lines( conditions_for_bd ) }| ).
    ELSE.
      index = 0.
      LOOP AT conditions_for_bd ASSIGNING FIELD-SYMBOL(<pricing_cond_actual>).
        index = index + 1.

        READ TABLE testdata-prcd_check INDEX index INTO DATA(pricing_cond_check).
        READ TABLE testdata-prcd INDEX index INTO DATA(pricing_cond_expected).

        LOOP AT prcd_elements_fields ASSIGNING FIELD-SYMBOL(<field>).

          ASSIGN COMPONENT <field>-fieldname OF STRUCTURE pricing_cond_check TO FIELD-SYMBOL(<check_required>).

          IF <check_required> EQ abap_true.
            ASSIGN COMPONENT <field>-fieldname OF STRUCTURE pricing_cond_expected TO FIELD-SYMBOL(<expected_value>).
            ASSIGN COMPONENT <field>-fieldname OF STRUCTURE <pricing_cond_actual> TO FIELD-SYMBOL(<actual_value>).

            IF <expected_value> NE <actual_value>.
              ev_check_status = abap_false.
              me->mo_run_environment->append_log( iv_log_statement = |The value of field { <field>-fieldname } is not as expected. Expected { <expected_value> } Actual: { <actual_value> }| ).
            ENDIF.

          ENDIF.

        ENDLOOP.

      ENDLOOP.

    ENDIF.

  ENDLOOP.

  ev_execution_status = abap_true.

ENDMETHOD.


METHOD check_profitab_segment.

  TYPES:
    BEGIN OF ty_vcm_object_id,
      vbeln   TYPE vbeln,
      vb_year TYPE gjahr,
    END OF ty_vcm_object_id.

  DATA:
    ls_testdata TYPE ty_gs_ptf_bd_check_td,
    lt_vbeln    TYPE cl_ptf_util=>ty_vbeln_tab.
*      lv_vbeln       TYPE vbeln_va,
*      ls_vbeln       TYPE cl_ptf_util=>ty_vbeln,
*      lt_billing_key TYPE TABLE OF sales_key,
*      lt_vbfa        TYPE TABLE OF vbfa.

  DATA lo_db_access TYPE REF TO cl_sd_bill_db_access.

  ev_check_status = abap_true.
  ev_execution_status = abap_false.

* ----------------------------------------------- get test data -----
  DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
  cl_ptf_util=>get_testdata(
    EXPORTING
      is_step_data = ls_step_data
    IMPORTING
      es_testdata  = ls_testdata ).

* --------------- get billing document number from reference step -----
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

  DATA lt_billing_documents TYPE t_vbeln.

  MOVE-CORRESPONDING lt_vbeln TO lt_billing_documents.

  lo_db_access = NEW cl_sd_bill_db_access( ).
  lo_db_access->select_vbrp_for_vbeln_tab(
    EXPORTING
      it_vbeln =       lt_billing_documents
    IMPORTING
      et_vbrp  =       DATA(lt_vbrp)
  ).
  ASSERT lt_vbrp IS NOT INITIAL.

  "Prof Segment (PAOBJNR) in vbrp and vbap should be the same
  SELECT vbrp~vbeln, vbrp~posnr, vbrp~paobjnr AS paobjnr_vbrp, vbap~paobjnr AS paobjnr_vbap
    FROM vbrp JOIN vbap ON vbrp~aubel = vbap~vbeln AND vbrp~aupos = vbap~posnr
    FOR ALL ENTRIES IN @lt_vbrp
    WHERE vbrp~vbeln = @lt_vbrp-vbeln AND
          vbrp~posnr = @lt_vbrp-posnr
    INTO TABLE @DATA(lt_prof_segment).

  LOOP AT lt_prof_segment ASSIGNING FIELD-SYMBOL(<ls_prof_segment>).
    ASSERT <ls_prof_segment>-posnr IS NOT INITIAL.
    IF <ls_prof_segment>-paobjnr_vbrp <> <ls_prof_segment>-paobjnr_vbap.
      me->mo_run_environment->append_log( iv_log_statement = |Profitability segment is different in vbrp and vbap.| ).
      ev_check_status = abap_false.
      RETURN. "stops at the first error
    ENDIF.
  ENDLOOP.

  ev_execution_status = abap_true.
  me->mo_run_environment->append_log( iv_log_statement = |Checked { lines( lt_prof_segment ) } items, found no problem.| ).

ENDMETHOD.


METHOD check_sepa_mandate.
  DATA: lt_vbeln        TYPE cl_ptf_util=>ty_vbeln_tab,
        ls_sel_criteria TYPE sepa_get_criteria_mandate,
        lt_mandates     TYPE sepa_tab_data_mandate_data.

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

  ls_sel_criteria-mvers = '0000'.
  ls_sel_criteria-anwnd = 'F'.
  ls_sel_criteria-snd_type = 'BUS3007'.   "Debitor

  ev_check_status = abap_true.
  LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<document>).
    SELECT SINGLE kunrg, mndid FROM vbrk INTO @DATA(customer) WHERE vbeln = @<document>-vbeln.
    ls_sel_criteria-mndid = customer-mndid.
    ls_sel_criteria-snd_id = customer-kunrg.

    CALL FUNCTION 'SEPA_MANDATES_API_GET'
      EXPORTING
        i_sel_criteria = ls_sel_criteria
      IMPORTING
        et_mandates    = lt_mandates.

    IF lt_mandates IS INITIAL.
      ev_check_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |SEPA data for customer { customer-kunrg } and mandate { customer-mndid } not mantained.| ).
    ENDIF.

  ENDLOOP.

  ev_execution_status = abap_true.
ENDMETHOD.


METHOD check_shipto_party_against_so.

  DATA:
    lt_vbeln     TYPE if_sd_bil_type_def=>tt_billing_document,
    ls_aubel_sel TYPE vbeln,
    ls_vbpa_ord  TYPE vbpa.


* Step 1: Get referenced documents
  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    IF lines( lt_ptf_keys ) EQ 0.
      me->mo_run_environment->append_log( iv_log_statement = |No documents found for step { <lv_ref_step> }| ).
    ENDIF.
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.

  IF lines( lt_vbeln ) EQ 0.
    me->mo_run_environment->append_log( iv_log_statement = |Nothing to check.| ).
    RETURN.
  ENDIF.

  SELECT vbeln, posnr, aubel, aupos, pospa, autyp
    FROM vbrp
    FOR ALL ENTRIES IN @lt_vbeln
    WHERE vbeln = @lt_vbeln-vbeln
    INTO TABLE @DATA(lt_bd_items).

* Step 2: Perform checks
  SELECT * FROM vbpa FOR ALL ENTRIES IN @lt_vbeln WHERE vbeln = @lt_vbeln-vbeln INTO TABLE @DATA(lt_vbpa_inv).
  IF sy-subrc NE 0.
    me->mo_run_environment->append_log( iv_log_statement = |Nothing to check.| ).
    RETURN.
  ENDIF.

  LOOP AT lt_bd_items ASSIGNING FIELD-SYMBOL(<ls_bd_item>).

    IF ls_aubel_sel IS INITIAL OR
       ls_aubel_sel NE <ls_bd_item>-aubel.
      SELECT * FROM vbpa WHERE vbeln = @<ls_bd_item>-aubel INTO TABLE @DATA(lt_vbpa_ord).
      ls_aubel_sel = <ls_bd_item>-aubel.
    ENDIF.

    DATA(lv_pospa_inv) = COND #( WHEN <ls_bd_item>-pospa IS NOT INITIAL THEN <ls_bd_item>-pospa ELSE <ls_bd_item>-posnr ).
    DATA(ls_vbpa_inv) = lt_vbpa_inv[ parvw = if_sd_partner=>co_partner_function_code-ship_to_party posnr = lv_pospa_inv ].

    "get ship-to party (either on item level or on header level)
    TRY.
        ls_vbpa_ord = lt_vbpa_ord[ parvw = if_sd_partner=>co_partner_function_code-ship_to_party posnr = <ls_bd_item>-aupos ].
      CATCH cx_sy_itab_line_not_found INTO DATA(lx_line_nf).
        ls_vbpa_ord = lt_vbpa_ord[ parvw = if_sd_partner=>co_partner_function_code-ship_to_party posnr = '000000' ].
    ENDTRY.

    IF ls_vbpa_inv IS INITIAL OR
       ls_vbpa_ord IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Nothing to check.| ).
      RETURN.
    ENDIF.

    "compare
    IF ls_vbpa_inv-kunnr NE ls_vbpa_ord-kunnr OR
       ls_vbpa_inv-adrnr NE ls_vbpa_ord-adrnr.
      me->mo_run_environment->append_log( iv_log_statement = |Ship-To Party not the same in Billing and underlying Order.| ).
      RETURN.
    ENDIF.

  ENDLOOP.

* Step 3: Set success message and status
  ev_check_status = abap_true.
  me->mo_run_environment->append_log( iv_log_statement = |Check was successful.| ).

ENDMETHOD.


  METHOD check_soldto_addr_operation.
  TYPES:
    BEGIN OF ty_vbeln,
      vbeln TYPE vbeln,
    END OF ty_vbeln,
    ty_vbeln_tab TYPE STANDARD TABLE OF ty_vbeln WITH NON-UNIQUE KEY vbeln,
    BEGIN OF ty_result,
      vbeln TYPE vbeln,
      parvw TYPE parvw,
      addr_operation TYPE sd_addr_operation,
    END OF ty_result.

  DATA: lt_vbeln          TYPE cl_ptf_util=>ty_vbeln_tab,
        lv_vbeln          TYPE vbeln,
        lt_vbeln_cast     TYPE ty_vbeln_tab,
        lv_vbpa           TYPE TABLE OF vbpa,
        lv_vbrk           TYPE TABLE OF vbrk,
        lv_vbrp           TYPE TABLE OF vbrp,
        lt_result         TYPE TABLE OF ty_result,
        index             TYPE i.

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


  lt_vbeln_cast = lt_vbeln.

*   2. Step: No business partner fields should be initial
  ev_check_status = abap_true.
  ev_execution_status = abap_true.

  DATA(lv_actual_switch_state) = cl_bupa_multiple_addresses=>if_bupa_multiple_addresses~is_o2c_multiple_addr_active( ).

  IF lv_actual_switch_state EQ abap_true.

     SELECT vbeln, parvw, addr_operation
     FROM vbpa
     FOR ALL ENTRIES IN @lt_vbeln_cast
     WHERE vbeln = @lt_vbeln_cast-vbeln
     INTO TABLE @lt_result.

     SELECT SINGLE *
     FROM tpar
     WHERE parvw = @if_sd_partner=>co_partner_function_code-sold_to_party
     INTO @DATA(ls_result_tpar).

    IF lt_result IS INITIAL.
      ev_check_status = abap_false.
      me->mo_run_environment->append_log(
        iv_log_statement = |No data from table VBPA available | ).
    ELSEIF lt_result IS NOT INITIAL.
      me->mo_run_environment->append_log(
        iv_log_statement = |Reading from VBPA was succesful. | ).
      ev_check_status = abap_true.

      LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<fs_result>).
        IF <fs_result>-parvw = if_sd_partner=>co_partner_function_code-sold_to_party AND <fs_result>-addr_operation = ls_result_tpar-addr_operation.
            me->mo_run_environment->append_log(
                iv_log_statement = |For billing document { <fs_result>-vbeln } addr_operation is correct for the partner function { <fs_result>-parvw } |  ).
       ELSEIF <fs_result>-parvw = if_sd_partner=>co_partner_function_code-sold_to_party AND <fs_result>-addr_operation = ls_result_tpar-addr_operation.
            me->mo_run_environment->append_log(
                iv_log_statement = |For billing document { <fs_result>-vbeln } addr_operation is not correct for the partner function { <fs_result>-parvw } |  ).
            ev_check_status = abap_false.
       ENDIF.
      ENDLOOP.
    ENDIF.

  ELSE.
    ev_check_status = abap_false.
    ev_execution_status = abap_false.
    me->mo_run_environment->append_log(
      iv_log_statement = |Switch for multiple BP addresses is not active. | ).
  ENDIF.
ENDMETHOD.


METHOD check_text.
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
    ls_return-message = 'Text comparison was successful.'.
    me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
  ENDIF.
  APPEND LINES OF lt_vbeln TO ev_document_id.
  ev_execution_status = abap_true.

ENDMETHOD.


METHOD check_text_pbd.
  DATA: lv_tdname    TYPE thead-tdname,
        lt_tdobject  TYPE STANDARD TABLE OF stxdrobj,
        lt_thead_inv TYPE TABLE OF theadvb,
        lt_thead_pbd TYPE TABLE OF theadvb,
        lt_lines_inv TYPE TABLE OF tline,
        lt_lines_pbd TYPE TABLE OF tline,
        ls_lines_inv TYPE tline,
        ls_lines_pbd TYPE tline,
        lv_vbeln     TYPE vbeln,
        index_tab    TYPE i,
        ls_return    TYPE bapiret2,
        lt_vbeln     TYPE cl_ptf_util=>ty_vbeln_tab.

  ev_check_status = abap_true.

  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.

  LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<ls_vbeln>).

    SELECT SINGLE pbd_id FROM vbrp INTO lv_vbeln WHERE vbeln = <ls_vbeln>-vbeln.

    READ TABLE lt_tdobject INTO DATA(ls_tdobject) INDEX 1.
    IF sy-subrc <> 0.
      CLEAR: lt_tdobject.
      ls_tdobject-option = 'EQ'.
      ls_tdobject-sign = 'I'.
      ls_tdobject-low = 'VBBK'.
      APPEND ls_tdobject TO lt_tdobject.
      ls_tdobject-low = 'VBBP'.
      APPEND ls_tdobject TO lt_tdobject.
    ENDIF.

    CLEAR lv_tdname.
    CONCATENATE <ls_vbeln> '*' INTO lv_tdname.

    CALL FUNCTION 'SELECT_TEXT'
      EXPORTING
        name       = lv_tdname
        id         = '*'
        language   = '*'
      TABLES
        selections = lt_thead_inv
        t_object   = lt_tdobject.

    CLEAR lv_tdname.
    CONCATENATE lv_vbeln  '*' INTO lv_tdname.

    CALL FUNCTION 'SELECT_TEXT'
      EXPORTING
        name       = lv_tdname
        id         = '*'
        language   = '*'
      TABLES
        selections = lt_thead_pbd
        t_object   = lt_tdobject.

    SORT lt_thead_inv BY tdobject tdid.
    SORT lt_thead_pbd BY tdobject tdid.
    index_tab = 0.
    LOOP AT lt_thead_inv ASSIGNING FIELD-SYMBOL(<ls_head_inv>).
      index_tab = index_tab + 1.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client   = sy-mandt
          id       = <ls_head_inv>-tdid
          language = <ls_head_inv>-tdspras
          name     = <ls_head_inv>-tdname
          object   = <ls_head_inv>-tdobject
        TABLES
          lines    = lt_lines_inv.

      READ TABLE lt_thead_pbd ASSIGNING FIELD-SYMBOL(<ls_head_pbd>) INDEX index_tab.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client   = sy-mandt
          id       = <ls_head_pbd>-tdid
          language = <ls_head_pbd>-tdspras
          name     = <ls_head_pbd>-tdname
          object   = <ls_head_pbd>-tdobject
        TABLES
          lines    = lt_lines_pbd.

      LOOP AT lt_lines_inv INTO ls_lines_inv.
        READ TABLE lt_lines_pbd INTO ls_lines_pbd INDEX sy-tabix.
        IF ls_lines_pbd NE ls_lines_inv.
          ev_check_status = abap_false.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
    APPEND <ls_vbeln>-vbeln TO ev_document_id.
  ENDLOOP.

  IF ev_check_status EQ abap_true.
    me->mo_run_environment->append_log( iv_log_statement = 'Text of both documents are equal.' ).
  ELSE.
    me->mo_run_environment->append_log( iv_log_statement = 'Text of both documents are not equal.' ).
  ENDIF.

  ev_execution_status = abap_true.

ENDMETHOD.


METHOD check_vbfa_processflow.
  DATA: lt_vbeln_input TYPE STANDARD TABLE OF vbrk-vbeln WITH EMPTY KEY,
        ls_vbrk        TYPE vbrk,
        lv_error       TYPE c.

  DATA(ls_step_data_this_check) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
  ev_execution_status = abap_false.
  ev_check_status = abap_true.

  LOOP AT ls_step_data_this_check-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln_input.
  ENDLOOP.

  SELECT vbeln, fkart, vbtyp FROM vbrk INTO TABLE @DATA(lt_vbelns) FOR ALL ENTRIES IN @lt_vbeln_input WHERE vbeln = @lt_vbeln_input-table_line.
  IF lt_vbelns IS INITIAL.
    me->mo_run_environment->append_log( 'There are no Billing Documents to check!' ).
    RETURN.
  ENDIF.
  LOOP AT lt_vbelns ASSIGNING FIELD-SYMBOL(<lv_vbeln>).
    SELECT * FROM c_billingdocprocflow WHERE billingdocument = @<lv_vbeln>-vbeln
       AND subsequentdocumentcategory <> '+' "accounting
       AND subsequentdocument <> ''
       AND precedingdocumentcategory <> '2' " external
      INTO TABLE @DATA(lt_procflow).
    IF lt_procflow IS NOT INITIAL.
      SELECT * FROM i_sddocumentmultilevelprocflow WITH PRIVILEGED ACCESS WHERE subsequentdocument = @<lv_vbeln>-vbeln OR precedingdocument = @<lv_vbeln>-vbeln
          ORDER BY precedingdocument, precedingdocumentcategory, subsequentdocument, subsequentdocumentcategory INTO TABLE @DATA(lt_vbfa).


      LOOP AT lt_procflow ASSIGNING FIELD-SYMBOL(<ls_processflow>).
        READ TABLE lt_vbfa WITH KEY precedingdocument = <ls_processflow>-precedingdocument
                                         precedingdocumentcategory = <ls_processflow>-precedingdocumentcategory
                                         subsequentdocument = <ls_processflow>-subsequentdocument
     subsequentdocumentcategory = <ls_processflow>-subsequentdocumentcategory BINARY SEARCH TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          me->mo_run_environment->append_log( | Billing Document {  <lv_vbeln>-vbeln }: missing entry { <ls_processflow>-precedingdocument }:{ <ls_processflow>-precedingdocumentcategory }| &&
                                              | -> { <ls_processflow>-subsequentdocument }:{ <ls_processflow>-subsequentdocumentcategory }| ).
          ev_check_status = abap_false.
        ENDIF.
      ENDLOOP.
    ELSE.
      IF cl_sd_doc_category_util=>is_invoice_or_credit_memo_canc( <lv_vbeln>-vbtyp ) = abap_true.
        me->mo_run_environment->append_log( | Cancellation document {  <lv_vbeln>-vbeln } is not supported | ).
      ELSE.
        me->mo_run_environment->append_log( | Billing Document {  <lv_vbeln>-vbeln }: missing processflow entry| ).
        ev_check_status = abap_false.
      ENDIF.
    ENDIF.
  ENDLOOP.
  ev_execution_status = abap_true.
ENDMETHOD.


METHOD check_vcm.

  TYPES:
    BEGIN OF ty_vcm_object_id,
      vbeln   TYPE vbeln,
      vb_year TYPE gjahr,
    END OF ty_vcm_object_id.

  DATA:
    ls_testdata           TYPE ty_gs_ptf_bd_check_td,
    lt_vbeln              TYPE cl_ptf_util=>ty_vbeln_tab,
    lv_vcm_guid           TYPE vcm_uuid,
    lv_vcm_bo_object_id   TYPE vcm_business_object_id,
    lv_vcm_bo_obj_item_id TYPE vcm_business_object_item_id,
    lv_vcm_vbeln          TYPE vbeln,
    lv_vcm_posnr          TYPE posnr,
    lv_step_type          TYPE vcm_step_type_id,
    lv_document_type      TYPE vbrk-vbtyp,
    lv_check_status       TYPE abap_bool.


  CONSTANTS mc_stepype_invoice TYPE vcm_step_type_id VALUE 'CISC'.
  CONSTANTS mc_stepype_intercompany TYPE vcm_step_type_id VALUE 'CIIC'.

  DATA: lo_db_access TYPE REF TO cl_sd_bill_db_access.

  CLEAR lv_check_status.

  ev_check_status = abap_true.
  ev_execution_status = abap_false.

* ----------------------------------------------- get test data -----
  DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
  cl_ptf_util=>get_testdata(
    EXPORTING
      is_step_data = ls_step_data
    IMPORTING
      es_testdata  = ls_testdata ).

* --------------- get billing document number from reference step -----
  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
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

  DATA: lt_billing_documents TYPE t_vbeln.

  MOVE-CORRESPONDING lt_vbeln TO lt_billing_documents.

  lo_db_access = NEW cl_sd_bill_db_access( ).

  lo_db_access->select_vbrp_for_vbeln_tab(
    EXPORTING
      it_vbeln = lt_billing_documents    " Table of billing documents
    IMPORTING
      et_vbrp  = DATA(lt_vbrp)           " Table Type for Billing Items
  ).

  SORT lt_vbrp ASCENDING BY vcm_chain_uuid.
  DELETE ADJACENT DUPLICATES FROM lt_vbrp COMPARING vcm_chain_uuid.


  LOOP AT lt_vbrp ASSIGNING FIELD-SYMBOL(<ls_vbrp>).

    IF <ls_vbrp>-vcm_chain_uuid IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No VCM document exist for billing document { <ls_vbrp>-vbeln }  and item  { <ls_vbrp>-posnr } | ).
      lv_check_status = abap_false.
      EXIT.
    ENDIF.

    lo_db_access->select_vbrk(
      EXPORTING
        iv_vbeln = <ls_vbrp>-vbeln                 " Billing Document
      IMPORTING
        es_vbrk  = DATA(ls_vbrk)              " Billing Document: Header Data
    ).

    TRY .
        lv_vcm_guid = <ls_vbrp>-vcm_chain_uuid.
        DATA(lv_value_chain_type) = cl_vcm_app_query=>get_instance( )->get_value_chain_type( lv_vcm_guid ).

        lv_vcm_bo_object_id   = <ls_vbrp>-vbeln.
        lv_vcm_bo_obj_item_id = <ls_vbrp>-posnr.

        lv_document_type = ls_vbrk-vbtyp.

        lv_step_type = SWITCH #( lv_document_type
                              WHEN if_sd_doc_category=>invoice OR if_sd_doc_category=>invoice_cancel THEN mc_stepype_invoice
                              WHEN if_sd_doc_category=>intercompany_invoice OR if_sd_doc_category=>intercompany_credit_memo THEN mc_stepype_intercompany ).


        DATA(lo_chain_item) = cl_vcm_app_query=>get_instance( )->get_value_chain_item( value_chain_type        = lv_value_chain_type
                                                                                       step_type               = lv_step_type
                                                                                       business_object_id      = lv_vcm_bo_object_id
                                                                                       business_object_item_id = lv_vcm_bo_obj_item_id ).

      CATCH cx_vcm_md_not_exists cx_vcm_rt_not_exists INTO DATA(lx_vcm_chain_item).
        " Error handling
    ENDTRY.

    TRY .
        DATA(lt_bo_item) = lo_chain_item->get_business_object_items( ).

      CATCH cx_vcm_rt_not_exists INTO lx_vcm_chain_item.
        " Error handling
    ENDTRY.

    LOOP AT lt_bo_item REFERENCE INTO DATA(lr_bo_item) WHERE item-step_type = lv_step_type AND item-cancelled IS INITIAL AND item-deleted IS INITIAL.
      lv_vcm_vbeln = lr_bo_item->item-object_id.
      lv_vcm_posnr = lr_bo_item->item-item_id.
    ENDLOOP.
*      ENDIF.

    IF lv_vcm_vbeln IS INITIAL .
      me->mo_run_environment->append_log( iv_log_statement = |No VCM entry exist for billing document { <ls_vbrp>-vbeln } and item { <ls_vbrp>-posnr } | ).
      lv_check_status = abap_false.
      EXIT.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |VCM entry of step type { lv_step_type } found for document { lv_vcm_vbeln } and item { lv_vcm_posnr } | ).
    ENDIF.
  ENDLOOP.

  IF lv_check_status IS NOT INITIAL.
    ev_check_status = abap_false.
  ENDIF.

  ev_execution_status = abap_true.

ENDMETHOD.


METHOD check_vkdfs.
  DATA: error_occured TYPE abap_bool VALUE abap_false.
  DATA found_entries TYPE HASHED TABLE OF vbeln WITH UNIQUE KEY table_line.
  DATA doc_ids TYPE TABLE OF vbeln.

  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
    DATA(ref_doc_ids) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
    LOOP AT ref_doc_ids ASSIGNING FIELD-SYMBOL(<ref_doc_id>).
      APPEND <ref_doc_id> TO doc_ids.
    ENDLOOP.
  ENDLOOP.

  IF doc_ids IS INITIAL.
    me->mo_run_environment->append_log( iv_log_statement = |No reference documents exist.| ).
    ev_check_status = abap_false.
    ev_execution_status = abap_false.
  ELSE.
    SELECT vbeln FROM vkdfs FOR ALL ENTRIES IN @doc_ids WHERE vbeln = @doc_ids-table_line INTO TABLE @found_entries.
    LOOP AT doc_ids ASSIGNING FIELD-SYMBOL(<doc_id>).
      READ TABLE found_entries WITH TABLE KEY table_line = <doc_id> TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        me->mo_run_environment->append_log( iv_log_statement = |Document { <doc_id> } does not exist in VKDFS.| ).
        error_occured = abap_true.
      ELSE.
        me->mo_run_environment->append_log( iv_log_statement = |Document { <doc_id> } does exist in VKDFS.| ).
      ENDIF.
    ENDLOOP.

    IF error_occured <> abap_true.
      ev_check_status = abap_true.
    ELSE.
      ev_check_status = abap_false.
    ENDIF.

    ev_execution_status = abap_true.
  ENDIF.
ENDMETHOD.


METHOD check_wavwr_adv_ico.
  TYPES:
    BEGIN OF ty_vcm_object_id,
      vbeln   TYPE vbeln,
      vb_year TYPE gjahr,
    END OF ty_vcm_object_id.

  DATA:
    ls_testdata           TYPE ty_gs_ptf_bd_check_td,
    lt_vbeln              TYPE cl_ptf_util=>ty_vbeln_tab,
    lv_vbeln              TYPE vbeln_va,
    ls_vbeln              TYPE cl_ptf_util=>ty_vbeln,
    lt_billing_key        TYPE TABLE OF sales_key,
    lt_vbfa               TYPE TABLE OF vbfa,
    lv_vcm_guid           TYPE vcm_uuid,
    lv_vcm_bo_object_id   TYPE vcm_business_object_id,
    lv_vcm_bo_obj_item_id TYPE vcm_business_object_item_id,
    lv_gitc_vbeln         TYPE ty_vcm_object_id,
    lv_gitc_posnr         TYPE posnr,
    lt_docflow            TYPE SORTED TABLE OF vbfa WITH NON-UNIQUE KEY vbeln posnn vbtyp_v erdat erzet,
    lv_qty_in_meins       TYPE fklmg,
    lv_wavwr              TYPE wavwr.

  DATA: lo_db_access TYPE REF TO cl_sd_bill_db_access.

  ev_check_status = abap_true.
  ev_execution_status = abap_false.

* ----------------------------------------------- get test data -----
  DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
  cl_ptf_util=>get_testdata(
    EXPORTING
      is_step_data = ls_step_data
    IMPORTING
      es_testdata  = ls_testdata ).

* --------------- get billing document number from reference step -----
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

  DATA: lt_billing_documents TYPE t_vbeln.

  MOVE-CORRESPONDING lt_vbeln TO lt_billing_documents.

  lo_db_access = NEW cl_sd_bill_db_access( ).

  lo_db_access->select_vbrp_for_vbeln_tab(
    EXPORTING
      it_vbeln =        lt_billing_documents         " Table of billing documents
    IMPORTING
      et_vbrp  =       DATA(lt_vbrp)           " Table Type for Billing Items
  ).


  SELECT * FROM vbfa FOR ALL ENTRIES IN @lt_vbrp
      WHERE vbelv   = @lt_vbrp-vgbel AND
            posnv   = @lt_vbrp-vgpos AND
            vbtyp_v = @if_sd_doc_category=>delivery
      INTO TABLE @lt_docflow.

  LOOP AT lt_vbrp INTO DATA(ls_vbrp).

    IF ls_vbrp-vcm_chain_uuid IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No VCM documents found for step { <lv_ref_step> }| ).
      ev_check_status = abap_false.
      EXIT.
    ENDIF.

    TRY .
        lv_vcm_guid = ls_vbrp-vcm_chain_uuid.
        DATA(lv_value_chain_type) = cl_vcm_app_query=>get_instance( )->get_value_chain_type( lv_vcm_guid ).

        lv_vcm_bo_object_id   = ls_vbrp-vgbel.
        lv_vcm_bo_obj_item_id = ls_vbrp-vgpos.
        DATA(lo_chain_item) = cl_vcm_app_query=>get_instance( )->get_value_chain_item( value_chain_type        = lv_value_chain_type
                                                                                       step_type               = 'ODDC'
                                                                                       business_object_id      = lv_vcm_bo_object_id
                                                                                       business_object_item_id = lv_vcm_bo_obj_item_id ).

        DATA(lt_gitc_item) = lo_chain_item->get_bus_obj_items_for_item( step_type        = 'ODDC'
                                                                        object_id        = lv_vcm_bo_object_id
                                                                        item_id          = lv_vcm_bo_obj_item_id
                                                                        target_step_type = 'GITC' ).

      CATCH cx_vcm_md_not_exists cx_vcm_rt_not_exists INTO DATA(lx_vcm_chain_item).
        " Error handling
    ENDTRY.

    LOOP AT lt_gitc_item REFERENCE INTO DATA(lr_gitc_item) WHERE cancelled IS INITIAL AND deleted IS INITIAL.
      lv_gitc_vbeln = lr_gitc_item->object_id.
      lv_gitc_posnr = lr_gitc_item->item_id.
    ENDLOOP.
    IF lv_gitc_vbeln IS INITIAL.
      TRY .
          DATA(lt_bo_item) = lo_chain_item->get_business_object_items( ).

        CATCH cx_vcm_rt_not_exists INTO lx_vcm_chain_item.
          " Error handling
      ENDTRY.

      LOOP AT lt_bo_item REFERENCE INTO DATA(lr_bo_item) WHERE item-step_type = 'GITC' AND item-cancelled IS INITIAL AND item-deleted IS INITIAL.
        lv_gitc_vbeln = lr_bo_item->item-object_id.
        lv_gitc_posnr = lr_bo_item->item-item_id.
      ENDLOOP.
    ENDIF.

    IF lv_gitc_vbeln IS INITIAL .
      me->mo_run_environment->append_log( iv_log_statement = |No material documents found in VCM for step{ <lv_ref_step> }| ).
      ev_check_status = abap_false.
      EXIT.
    ENDIF.

    READ TABLE lt_docflow WITH KEY vbelv = ls_vbrp-vgbel posnv = ls_vbrp-vgpos vbeln = lv_gitc_vbeln-vbeln posnn = lv_gitc_posnr REFERENCE INTO DATA(lr_xvbfa).

    IF sy-subrc IS NOT INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Material document not found in VCM for step{ <lv_ref_step> }| ).
      ev_check_status = abap_false.
      EXIT.
    ENDIF.

    lv_qty_in_meins = ls_vbrp-fkimg * ls_vbrp-umvkz / ls_vbrp-umvkn.
    IF lr_xvbfa->rfmng EQ lv_qty_in_meins.
      lv_wavwr = lr_xvbfa->rfwrt.
    ELSEIF lr_xvbfa->rfmng IS NOT INITIAL.
      lv_wavwr = lr_xvbfa->rfwrt / lr_xvbfa->rfmng * lv_qty_in_meins.
    ENDIF.

    IF lv_wavwr EQ ls_vbrp-wavwr.
      me->mo_run_environment->append_log( iv_log_statement = |Field WAVWR is correctly filled { <lv_ref_step> }| ).
      ev_check_status = abap_true.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |Field WAVWR is not equal{ <lv_ref_step> }| ).
      ev_check_status = abap_false.
      EXIT.
    ENDIF.
  ENDLOOP.

  ev_execution_status = abap_true.

ENDMETHOD.


METHOD check_xblnr_predec.

  DATA: lv_vbeln_vf   TYPE vbeln,
        lt_vbeln_vf   TYPE cl_ptf_util=>ty_vbeln_tab,
        ls_vbrk       TYPE vbrk,
        lv_vbeln_prec TYPE vbeln,
        lt_vbeln_prec TYPE cl_ptf_util=>ty_vbeln_tab.

  DATA(ls_step_data_this_check) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

  ev_check_status = abap_false.

  LOOP AT ls_step_data_this_check-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln_vf.
  ENDLOOP.
  IF lt_vbeln_vf IS INITIAL.
    me->mo_run_environment->append_log( 'There are no documentIDs to check!' ).
    RETURN.
  ENDIF.
  READ TABLE lt_vbeln_vf INDEX 1 INTO lv_vbeln_vf.
  CHECK lv_vbeln_vf IS NOT INITIAL.
  SELECT SINGLE * FROM vbrk INTO ls_vbrk WHERE vbeln = lv_vbeln_vf.
  IF sy-subrc IS NOT INITIAL.
    me->mo_run_environment->append_log( |BillingDoc { lv_vbeln_vf } not found. | ).
    RETURN.
  ENDIF.

  LOOP AT ls_step_data_this_check-reference_step ASSIGNING <lv_ref_step>. "Predecessors of the check are the invoices
    DATA(ls_step_data_bd) = me->mo_run_environment->get_step_data( iv_step_number = <lv_ref_step> ).
    LOOP AT ls_step_data_bd-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step_prec>). "Predecessors of the invoices
      DATA(lt_ptf_keys_prec) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step_prec> ).
      APPEND LINES OF lt_ptf_keys_prec TO lt_vbeln_prec.
    ENDLOOP.
    IF lines( lt_vbeln_prec ) NE 1.
      me->mo_run_environment->append_log( |This check supports only exactly 1 invoiced document. | ).
      RETURN.
    ENDIF.
    lv_vbeln_prec = lt_vbeln_prec[ 1 ].
    IF ls_vbrk-xblnr EQ lv_vbeln_prec.
      me->mo_run_environment->append_log( |XVBRK-XBLNR { ls_vbrk-xblnr } equals the prec. doc. id. Check passed.| ).
      ev_check_status = abap_true.
      ev_execution_status = abap_true.
    ELSE.
      me->mo_run_environment->append_log( |XVBRK-XBLNR { ls_vbrk-xblnr } deviates from prec. doc. id { lv_vbeln_prec } .| ).
    ENDIF.
  ENDLOOP.

ENDMETHOD.


METHOD check_zuonr_currnt.

  DATA: lv_vbeln_vf TYPE vbeln,
        lt_vbeln_vf TYPE cl_ptf_util=>ty_vbeln_tab,
        ls_vbrk     TYPE vbrk,
        lv_error    TYPE c.

  DATA(ls_step_data_this_check) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

  ev_check_status = abap_false.

  LOOP AT ls_step_data_this_check-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln_vf.
  ENDLOOP.
  IF lt_vbeln_vf IS INITIAL.
    me->mo_run_environment->append_log( 'There are no BillDocIDs to check!' ).
    RETURN.
  ENDIF.

  LOOP AT lt_vbeln_vf INTO lv_vbeln_vf.
    IF lv_vbeln_vf IS INITIAL.
      me->mo_run_environment->append_log( 'Initial VBELN!' ).
      lv_error = abap_true.
      CONTINUE.
    ENDIF.
    SELECT SINGLE * FROM vbrk INTO ls_vbrk WHERE vbeln = lv_vbeln_vf.
    IF sy-subrc IS NOT INITIAL.
      me->mo_run_environment->append_log( |BillingDoc { lv_vbeln_vf } not found. | ).
      lv_error = abap_true.
      CONTINUE.
    ENDIF.

    IF ls_vbrk-zuonr EQ lv_vbeln_vf.
      me->mo_run_environment->append_log( |XVBRK-ZUONR { ls_vbrk-zuonr } equals the ID of the BillDoc. Check passed.| ).
    ELSE.
      me->mo_run_environment->append_log( |XVBRK-ZUONR { ls_vbrk-zuonr } deviates from the ID of the BillDoc { lv_vbeln_vf } .| ).
      lv_error = abap_true.
    ENDIF.
  ENDLOOP.

  IF lv_error NE abap_true.
    ev_check_status     = abap_true.
    ev_execution_status = abap_true.
  ENDIF.

ENDMETHOD.


  METHOD check_zuonr_predec.

    DATA: lv_vbeln_vf   TYPE vbeln,
          lt_vbeln_vf   TYPE cl_ptf_util=>ty_vbeln_tab,
          ls_vbrk       TYPE vbrk,
          lv_vbeln_prec TYPE vbeln,
          lt_vbeln_prec TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA(ls_step_data_this_check) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    ev_check_status = abap_false.

    LOOP AT ls_step_data_this_check-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln_vf.
    ENDLOOP.
    IF lt_vbeln_vf IS INITIAL.
      me->mo_run_environment->append_log( 'There are no documentIDs to check!' ).
      RETURN.
    ENDIF.
    READ TABLE lt_vbeln_vf INDEX 1 INTO lv_vbeln_vf.
    CHECK lv_vbeln_vf IS NOT INITIAL.
    SELECT SINGLE * FROM vbrk INTO ls_vbrk WHERE vbeln = lv_vbeln_vf.
    IF sy-subrc IS NOT INITIAL.
      me->mo_run_environment->append_log( |BillingDoc { lv_vbeln_vf } not found. | ).
      RETURN.
    ENDIF.

    LOOP AT ls_step_data_this_check-reference_step ASSIGNING <lv_ref_step>. "Predecessors of the check are the invoices
      DATA(ls_step_data_bd) = me->mo_run_environment->get_step_data( iv_step_number = <lv_ref_step> ).
      LOOP AT ls_step_data_bd-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step_prec>). "Predecessors of the invoices
        DATA(lt_ptf_keys_prec) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step_prec> ).
        APPEND LINES OF lt_ptf_keys_prec TO lt_vbeln_prec.
      ENDLOOP.
      IF lines( lt_vbeln_prec ) NE 1.
        me->mo_run_environment->append_log( |This check supports only exactly 1 invoiced document. | ).
        RETURN.
      ENDIF.
      lv_vbeln_prec = lt_vbeln_prec[ 1 ].
      IF ls_vbrk-zuonr EQ lv_vbeln_prec.
        me->mo_run_environment->append_log( |XVBRK-ZUONR { ls_vbrk-zuonr } equals the prec. doc. id. Check passed.| ).
        ev_check_status = abap_true.
        ev_execution_status = abap_true.
      ELSE.
        me->mo_run_environment->append_log( |XVBRK-ZUONR { ls_vbrk-zuonr } deviates from prec. doc. id { lv_vbeln_prec } .| ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD clear_fi.

    CONSTANTS: co_blart_to_clear TYPE string VALUE 'RV'.

    DATA: clearing_header       TYPE cl_fdc_clearing_document_inf=>ty_clearing_header,
          apar_items_to_be_clrd TYPE cl_fdc_clearing_document_inf=>tty_apar_item_to_be_clrd,
          apar_item_to_be_clrd  TYPE cl_fdc_clearing_document_inf=>ty_apar_item_to_be_clrd,
          gl_items_to_be_clrd   TYPE cl_fdc_clearing_document_inf=>tty_gl_item_to_be_clrd,
*          gl_item_to_be_clrd    TYPE cl_fdc_clearing_document_inf=>ty_gl_item_to_be_clrd,
          apar_items_on_account TYPE cl_fdc_clearing_document_inf=>tty_apar_item_on_account,
          apar_item_on_account  TYPE cl_fdc_clearing_document_inf=>ty_apar_item_on_account,
          lt_vbeln              TYPE cl_ptf_util=>ty_vbeln_tab,
          awref                 TYPE acchd-awref,
          fi_documents          TYPE STANDARD TABLE OF bkpf WITH DEFAULT KEY,
          bseg_entries          TYPE STANDARD TABLE OF bseg WITH DEFAULT KEY,
          posted_document       TYPE fdc_s_accdoc_hdr_key_odata,
          messages              TYPE bapirettab,
          error_occured         TYPE abap_bool,
          test_data             TYPE ty_gs_post_dpy,
          gross_amount          TYPE fdc_cdamtdc,
          document_date         TYPE bldat,
          posting_date          TYPE budat.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = test_data
    ).

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    IF lt_vbeln IS INITIAL.
      mo_run_environment->append_log( iv_log_statement = |There is no Billing Document.| ).
      RETURN.
    ENDIF.

    ev_execution_status = abap_true.

    IF test_data-delta_document_date IS INITIAL.
      document_date = sy-datum.
    ELSE.
      document_date = sy-datum + test_data-delta_document_date.
    ENDIF.

    IF test_data-delta_posting_date IS INITIAL.
      posting_date = sy-datum.
    ELSE.
      posting_date = sy-datum + test_data-delta_posting_date.
    ENDIF.

    LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<billing_doc>).

      SELECT SINGLE mwsbk, netwr FROM vbrk WHERE vbeln = @<billing_doc>-vbeln INTO @DATA(amounts).
      gross_amount = amounts-mwsbk + amounts-netwr.

      awref = <billing_doc>-vbeln.

      CALL FUNCTION 'FI_DOCUMENT_READ'
        EXPORTING
          i_awtyp     = 'VBRK'
          i_awref     = awref
        TABLES
          t_bseg      = bseg_entries
          t_bkpf      = fi_documents
        EXCEPTIONS
          wrong_input = 1
          not_found   = 2
          OTHERS      = 3.
      IF sy-subrc EQ 2.
        me->mo_run_environment->append_log( iv_log_statement = |BSEG/BKPF access failed for BillingDoc { awref }, nothing found.| ).
        ev_execution_status = abap_false.
        RETURN.
      ELSEIF sy-subrc NE 0.
        me->mo_run_environment->append_log( iv_log_statement = |BSEG/BKPF access failed for BillingDoc { awref }. Exception code: { sy-subrc }| ).
        ev_execution_status = abap_false.
        RETURN.
      ENDIF.

      LOOP AT fi_documents ASSIGNING FIELD-SYMBOL(<fi_document>) WHERE blart = co_blart_to_clear.
        clearing_header-bukrs = <fi_document>-bukrs.
        clearing_header-blart = <fi_document>-blart.
        clearing_header-budat = posting_date.
        clearing_header-bldat = document_date.
        clearing_header-waers = <fi_document>-waers.
        clearing_header-kursf = <fi_document>-kursf.

        LOOP AT bseg_entries ASSIGNING FIELD-SYMBOL(<bseg_entry>) WHERE belnr = <fi_document>-belnr.

          CASE <bseg_entry>-koart.
            WHEN 'D'.
              apar_item_to_be_clrd-bukrs = <bseg_entry>-bukrs.
              apar_item_to_be_clrd-koart = <bseg_entry>-koart.
              apar_item_to_be_clrd-konko = test_data-konko.
              apar_item_to_be_clrd-gjahr = <bseg_entry>-gjahr.
              apar_item_to_be_clrd-belnr = <bseg_entry>-belnr.
              apar_item_to_be_clrd-buzei = <bseg_entry>-buzei.
              APPEND apar_item_to_be_clrd TO apar_items_to_be_clrd.

              apar_item_on_account-koart = <bseg_entry>-koart.
              apar_item_on_account-konko = test_data-konko.
              apar_item_on_account-shkzg = <bseg_entry>-shkzg.
              apar_item_on_account-wrbtr = <bseg_entry>-wrbtr.
              APPEND apar_item_on_account TO apar_items_on_account.
            WHEN OTHERS.
              "Not sure what to do here
              me->mo_run_environment->append_log( iv_log_statement = |Ignored BSEG entry with KOART { <bseg_entry>-koart }.| ).
          ENDCASE.
        ENDLOOP.

        NEW cl_fdc_clearing_document_inf( )->post(
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

        IF error_occured IS INITIAL.
          me->mo_run_environment->append_log( iv_log_statement = |Cleared document { <fi_document>-belnr }.| ).
        ELSE.
          me->mo_run_environment->append_log( iv_log_statement = |During clearing of document { <fi_document>-belnr }, an error occured. Messages:| ).
        ENDIF.
        LOOP AT messages ASSIGNING FIELD-SYMBOL(<message>).
          me->mo_run_environment->append_log_structure( is_log = <message> ).
        ENDLOOP.

        CLEAR clearing_header.
        CLEAR apar_items_to_be_clrd.
        CLEAR gl_items_to_be_clrd.
        CLEAR apar_items_on_account.
        CLEAR posted_document.
        CLEAR messages.

      ENDLOOP. "BKPF record

    ENDLOOP. "BilDoc

  ENDMETHOD.


  METHOD clear_partial_payment.
    CONSTANTS: blart_to_clear TYPE string VALUE 'RV'.
    DATA: clearing_header       TYPE cl_fdc_clearing_document_inf=>ty_clearing_header,
          apar_items_to_be_clrd TYPE cl_fdc_clearing_document_inf=>tty_apar_item_to_be_clrd,
          apar_item_to_be_clrd  TYPE cl_fdc_clearing_document_inf=>ty_apar_item_to_be_clrd,
          gl_items_to_be_clrd   TYPE cl_fdc_clearing_document_inf=>tty_gl_item_to_be_clrd,
          gl_item_to_be_clrd    TYPE cl_fdc_clearing_document_inf=>ty_gl_item_to_be_clrd,
          apar_items_on_account TYPE cl_fdc_clearing_document_inf=>tty_apar_item_on_account,
          apar_item_on_account  TYPE cl_fdc_clearing_document_inf=>ty_apar_item_on_account,
          lt_vbeln              TYPE cl_ptf_util=>ty_vbeln_tab,
          awref                 TYPE acchd-awref,
          fi_documents          TYPE STANDARD TABLE OF bkpf WITH DEFAULT KEY,
          bseg_entries          TYPE STANDARD TABLE OF bseg WITH DEFAULT KEY,
          posted_document       TYPE fdc_s_accdoc_hdr_key_odata,
          messages              TYPE bapirettab,
          error_occured         TYPE abap_bool,
          test_data             TYPE ty_gs_post_dpy,
          gross_amount          TYPE fdc_cdamtdc.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = test_data
    ).

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    ev_execution_status = abap_true.

    LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<billing_doc>).

      SELECT * FROM bseg WHERE vbeln = @<billing_doc>-vbeln INTO TABLE @bseg_entries.

      LOOP AT bseg_entries ASSIGNING FIELD-SYMBOL(<bseg_entry>).
        apar_item_to_be_clrd-bukrs = <bseg_entry>-bukrs.
        apar_item_to_be_clrd-koart = <bseg_entry>-koart.
        apar_item_to_be_clrd-konko = test_data-konko.
        apar_item_to_be_clrd-gjahr = <bseg_entry>-gjahr.
        apar_item_to_be_clrd-belnr = <bseg_entry>-belnr.
        apar_item_to_be_clrd-buzei = <bseg_entry>-buzei.
        APPEND apar_item_to_be_clrd TO apar_items_to_be_clrd.

        apar_item_on_account-koart = <bseg_entry>-koart.
        apar_item_on_account-konko = test_data-konko.
        apar_item_on_account-shkzg = <bseg_entry>-shkzg.
        "Hier Betrag +/- anhand SHKZG?
        apar_item_on_account-wrbtr = <bseg_entry>-wrbtr.
        APPEND apar_item_on_account TO apar_items_on_account.
      ENDLOOP.
      awref = <billing_doc>-vbeln.
      CALL FUNCTION 'FI_DOCUMENT_READ'
        EXPORTING
          i_awtyp = 'VBRK'
          i_awref = awref
        TABLES
          t_bkpf  = fi_documents.

      DATA(header_data) = fi_documents[ blart = blart_to_clear ].

      clearing_header-bukrs = header_data-bukrs.
      clearing_header-blart = header_data-blart.
      clearing_header-budat = sy-datum.
      clearing_header-bldat = sy-datum.
      clearing_header-waers = header_data-waers.
      clearing_header-kursf = header_data-kursf.






*    LOOP AT fi_documents ASSIGNING FIELD-SYMBOL(<fi_document>) WHERE blart = blart_to_clear.
*      clearing_header-bukrs = <fi_document>-bukrs.
*      clearing_header-blart = <fi_document>-blart.
*      clearing_header-budat = sy-datum.
*      clearing_header-bldat = sy-datum.
*      clearing_header-waers = <fi_document>-waers.
*      clearing_header-kursf = <fi_document>-kursf.
*
*      LOOP AT bseg_entries ASSIGNING FIELD-SYMBOL(<bseg_entry>) WHERE belnr = <fi_document>-belnr.
*
*        CASE <bseg_entry>-koart.
*          WHEN 'D'.
*            apar_item_to_be_clrd-bukrs = <bseg_entry>-bukrs.
*            apar_item_to_be_clrd-koart = <bseg_entry>-koart.
*            apar_item_to_be_clrd-konko = test_data-konko.
*            apar_item_to_be_clrd-gjahr = <bseg_entry>-gjahr.
*            apar_item_to_be_clrd-belnr = <bseg_entry>-belnr.
*            apar_item_to_be_clrd-buzei = <bseg_entry>-buzei.
*            APPEND apar_item_to_be_clrd TO apar_items_to_be_clrd.
*
*            apar_item_on_account-koart = <bseg_entry>-koart.
*            apar_item_on_account-konko = test_data-konko.
*            apar_item_on_account-shkzg = <bseg_entry>-shkzg.
*            apar_item_on_account-wrbtr = gross_amount.
*            APPEND apar_item_on_account TO apar_items_on_account.
*          WHEN OTHERS.
*            "Not sure what to do here
*        ENDCASE.
*      ENDLOOP.

      NEW cl_fdc_clearing_document_inf( )->post(
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

*    me->mo_run_environment->append_log( iv_log_statement = |Tried to clear document { <fi_document>-belnr }. Error occured: { error_occured }| ).
*    LOOP AT messages ASSIGNING FIELD-SYMBOL(<message>).
*      me->mo_run_environment->append_log_structure( is_log =  <message> ).
*    ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


METHOD complete_proforma.

  DATA:
    ls_step_data   TYPE cl_ptf_util=>gt_ptf_step,
    ls_testdata    TYPE cl_ptf_bo_invoice=>ty_gs_bd_up_zuonr_xblnr,
    lt_vbeln       TYPE cl_ptf_util=>ty_vbeln_tab,
    ls_vbeln       TYPE LINE OF cl_ptf_util=>ty_vbeln_tab,
    lt_documents   TYPE tt_vbeln_vf,
    lt_return      TYPE bapiret2_t,
    message_string TYPE string.

  ls_step_data = step_data.
  ev_execution_status = abap_true.

  IF ls_step_data-variant IS NOT INITIAL.
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).
  ENDIF.

  SORT ls_step_data-reference_step ASCENDING.

  LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    LOOP AT lt_vbeln INTO ls_vbeln.
      APPEND ls_vbeln TO lt_documents.
    ENDLOOP.
  ENDLOOP.
  IF lt_vbeln IS INITIAL.
    me->mo_run_environment->append_log( 'There are no reference documentIDs!' ).
    ev_execution_status = abap_false.
    RETURN.
  ENDIF.

  DATA(lo_profroma_hdlr) = cl_sdbil_external_factory=>get( )->get_proforma_hdlr( ).
  lo_profroma_hdlr->complete(
    EXPORTING
      it_documents   = lt_documents                " Table of billing document id's
      iv_with_commit = 'X'
    IMPORTING
      et_return      = lt_return                 " Return Parameter
  ).


  LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ls_return>).
    IF <ls_return>-type EQ 'S'.
      message_string = <ls_return>-message.
      me->mo_run_environment->append_log( message_string ).
    ELSE.
      ev_execution_status = abap_false.
      message_string = <ls_return>-message.
      me->mo_run_environment->append_log( message_string ).
    ENDIF.
  ENDLOOP.

ENDMETHOD.


  METHOD create.
    DATA:
      lt_vbfs               TYPE shp_vbfs_t,
      ls_vbfs               TYPE vbfs,
      lt_vbrkvb             TYPE TABLE OF vbrkvb,
      ls_vbrkvb             TYPE vbrkvb,
      lt_vbrpvb             TYPE TABLE OF vbrpvb,
      ls_vbski              TYPE vbsk,
      lt_komfk              TYPE TABLE OF komfk,
      lt_komfkko            TYPE TABLE OF komv,
      lt_thead              TYPE TABLE OF theadvb,
      lt_vbss               TYPE TABLE OF vbss,
      lt_komv               TYPE komv_tab,
      lt_vbpavb             TYPE vbpa_tab,

      ls_para_gn_inv_create TYPE ty_gs_import_gn_invce_create,
      lt_komfkgn            TYPE TABLE OF komfkgn,
      ls_komfkgn            TYPE  komfkgn,
      lv_vbtyp              TYPE vbtypl,
      lv_posnr              TYPE posnr,
      lv_no_fin_doc         TYPE char1,
      lv_billing_doc_number TYPE vbeln,
      ls_return             TYPE bapiret2,
      lt_return             TYPE TABLE OF bapiret2,
      ls_testdata           TYPE ty_gs_i_ptf_bd_cr_td,
      lt_vbeln              TYPE cl_ptf_util=>ty_vbeln_tab,
      lv_is_successful      TYPE abap_bool VALUE abap_false,
      billing_doc_numbers   TYPE STANDARD TABLE OF vbeln WITH DEFAULT KEY,
      lv_invoice_date       TYPE dats.

*************************************************************************

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    IF ls_step_data-variant IS NOT INITIAL.
      cl_ptf_util=>get_testdata(
        EXPORTING
          is_step_data = ls_step_data
        IMPORTING
          es_testdata  = ls_testdata
      ).
    ENDIF.

    "Determine invoice date
    IF ls_testdata-invoice_date IS INITIAL AND ls_testdata-delta_invoice_date IS NOT INITIAL.
      lv_invoice_date = sy-datlo + ls_testdata-delta_invoice_date.
    ELSE.
      lv_invoice_date = ls_testdata-invoice_date.
    ENDIF.




*************************************************************************
*Get Data of the predecessor

    DATA(lt_result_new) = me->mo_run_environment->get_result_key_data( it_step_number = ls_step_data-reference_step )."not used yet

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.


    "Add tdc reference
    IF ls_testdata-hard_coded_reference IS NOT INITIAL.
      APPEND ls_testdata-hard_coded_reference TO lt_vbeln.
    ENDIF.


    LOOP AT lt_vbeln INTO DATA(ls_vbeln).
      CHECK ls_vbeln-vbeln IS NOT INITIAL.

*Order-like
      CLEAR lv_vbtyp.
      SELECT SINGLE vbtyp FROM vbak INTO lv_vbtyp WHERE vbeln = ls_vbeln-vbeln.
      IF sy-subrc EQ 0.
        CLEAR ls_komfkgn.
        ls_komfkgn-mandt = sy-mandt.
        ls_komfkgn-fkdat = sy-datlo.
        ls_komfkgn-vgbel = ls_vbeln-vbeln.
        ls_komfkgn-vkorg = ls_testdata-msico_vkorg.
        "ls_komfkgn-vgpos = lv_posnr.
        ls_komfkgn-vgtyp = lv_vbtyp.
        APPEND ls_komfkgn TO lt_komfkgn.
*      SELECT posnr FROM vbap INTO lv_posnr WHERE vbeln = ls_vbeln-vbeln.
*        ls_komfkgn-mandt = sy-mandt.
*        ls_komfkgn-fkdat = sy-datlo.
*        ls_komfkgn-vgbel = ls_vbeln-vbeln.
*        ls_komfkgn-vgpos = lv_posnr.
*        ls_komfkgn-vgtyp = lv_vbtyp.
*        APPEND ls_komfkgn TO lt_komfkgn.
*        CLEAR lv_posnr.
*      ENDSELECT.
      ENDIF.
*Delivery
      CLEAR lv_vbtyp.
      SELECT SINGLE vbtyp FROM likp INTO lv_vbtyp WHERE vbeln = ls_vbeln-vbeln.
      IF sy-subrc EQ 0.
        CLEAR ls_komfkgn.
        ls_komfkgn-mandt = sy-mandt.
        ls_komfkgn-fkdat = sy-datlo.
        ls_komfkgn-vgbel = ls_vbeln-vbeln.
        "ls_komfkgn-vgpos = lv_posnr.
        ls_komfkgn-vgtyp = lv_vbtyp.
        APPEND ls_komfkgn TO lt_komfkgn.
*      SELECT posnr FROM lips INTO lv_posnr WHERE vbeln = ls_vbeln-vbeln.
*        ls_komfkgn-mandt = sy-mandt.
*        ls_komfkgn-fkdat = sy-datlo.
*        ls_komfkgn-vgbel = ls_vbeln-vbeln.
*        ls_komfkgn-vgpos = lv_posnr.
*        ls_komfkgn-vgtyp = lv_vbtyp.
*        APPEND ls_komfkgn TO lt_komfkgn.
*        CLEAR lv_posnr.
*      ENDSELECT.
      ENDIF.
*Billing Document or BDR
      CLEAR lv_vbtyp.
      SELECT SINGLE vbtyp FROM vbrk INTO lv_vbtyp WHERE vbeln = ls_vbeln-vbeln.
      IF sy-subrc EQ 0.
        CLEAR ls_komfkgn.
        ls_komfkgn-mandt = sy-mandt.
        ls_komfkgn-fkdat = sy-datlo.
        ls_komfkgn-vgbel = ls_vbeln-vbeln.
        "ls_komfkgn-vgpos = lv_posnr.
        ls_komfkgn-vgtyp = lv_vbtyp.
        APPEND ls_komfkgn TO lt_komfkgn.
*      SELECT posnr FROM vbrp INTO lv_posnr WHERE vbeln = ls_vbeln-vbeln.
*        ls_komfkgn-mandt = sy-mandt.
*        ls_komfkgn-fkdat = sy-datlo.
*        ls_komfkgn-vgbel = ls_vbeln-vbeln.
*        ls_komfkgn-vgpos = lv_posnr.
*        ls_komfkgn-vgtyp = lv_vbtyp.
*        APPEND ls_komfkgn TO lt_komfkgn.
*        CLEAR lv_posnr.
*      ENDSELECT.
      ENDIF.
    ENDLOOP.

*    IF lv_read_prec_step_bo EQ abap_true.
*      LOOP AT lt_prec_doc INTO ls_prec_doc.
*        CLEAR ls_komfkgn.
*        ls_komfkgn-mandt = sy-mandt.
*        ls_komfkgn-fkdat = sy-datlo.
*        ls_komfkgn-vgbel = ls_prec_doc-vbeln.
*        ls_komfkgn-vgtyp = ls_prec_doc-vbtyp.
*        APPEND ls_komfkgn TO lt_komfkgn.
*      ENDLOOP.
*    ENDIF.

    me->mo_run_environment->append_log( iv_log_statement = |INVOICE CREATE is executed by class CL_PTF_BO_INVOICE.| ).
    IF lt_komfkgn IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |There is no preceding document to be invoiced.| ).
      RETURN.
    ENDIF.
*************************************************************************
    lv_no_fin_doc = ls_testdata-no_fin_doc.
    CALL FUNCTION 'GN_INVOICE_CREATE'
      EXPORTING
        vbsk_i                  = ls_para_gn_inv_create-vbsk_i
        with_posting            = 'D'  " ls_para_gn_inv_create-with_posting,  synchronous commit with error log
        delivery_date           = ls_para_gn_inv_create-delivery_date
        invoice_date            = lv_invoice_date
        invoice_type            = ls_testdata-invoice_type
        pricing_date            = ls_para_gn_inv_create-pricing_date
        caller_type             = ls_para_gn_inv_create-caller_type
        i_without_refresh       = ls_para_gn_inv_create-i_without_refresh
        id_no_enqueue           = ls_para_gn_inv_create-id_no_enqueue
        id_kvorg                = ls_para_gn_inv_create-id_kvorg
        id_no_dialog            = 'X' "ls_para_gn_inv_create-id_no_dialog
        id_new_cancellation     = ls_para_gn_inv_create-id_new_cancellation
        id_analyze_mode         = ls_para_gn_inv_create-id_analyze_mode
        id_no_fi_doc            = lv_no_fin_doc
        is_fi_add_input         = ls_para_gn_inv_create-is_fi_add_input
        id_sim_without_price    = ls_para_gn_inv_create-id_sim_without_price
        io_external_buffer      = ls_para_gn_inv_create-io_external_buffer
        i_no_collective_billing = ls_testdata-i_no_collective_billing
      TABLES
        xkomfk                  = lt_komfk
        xkomfkgn                = lt_komfkgn
        xkomfkko                = lt_komfkko
        xkomv                   = lt_komv
        xthead                  = lt_thead
        xvbfs                   = lt_vbfs
        xvbpa                   = lt_vbpavb
        xvbrk                   = lt_vbrkvb
        xvbrp                   = lt_vbrpvb
        xvbss                   = lt_vbss
      EXCEPTIONS
        error_message           = 1.

    COMMIT WORK AND WAIT.

    CLEAR ls_return.
    LOOP AT lt_vbfs INTO ls_vbfs.
      MESSAGE ID ls_vbfs-msgid TYPE ls_vbfs-msgty NUMBER ls_vbfs-msgno INTO ls_return-message WITH ls_vbfs-msgv1 ls_vbfs-msgv2 ls_vbfs-msgv3 ls_vbfs-msgv4.
      ls_return-id =  ls_vbfs-msgid.
      "ls_return-message = ls_vbfs-msgno.
      ls_return-message_v1 = ls_vbfs-msgv1.
      ls_return-message_v2 = ls_vbfs-msgv2.
      ls_return-message_v3 = ls_vbfs-msgv3.
      ls_return-message_v4 = ls_vbfs-msgv4.
      ls_return-type = ls_vbfs-msgty.
      IF ls_vbfs-msgty EQ 'S' OR (
          ls_vbfs-msgty EQ 'W' AND ls_vbfs-vbeln NE '' "For test invoicing with no fin doc --> Only one message with msgtype w and text Document XX created (no fin doc)
        ).
        lv_is_successful = abap_true.
      ENDIF.
      IF ls_vbfs-msgty EQ 'E'.
*        me->mo_run_environment->append_log( iv_log_statement = |(with MSGTY = ERROR:)| ).
      ENDIF.
      me->mo_run_environment->append_log( iv_log_statement = |{ '(' && ls_vbfs-msgty && ')' && ls_return-message }| ).
*********************
      DATA ls_t100 TYPE ptf_t100_message.
      DATA lt_t100 TYPE ptf_t100_message_t.
      ls_t100-type       = ls_vbfs-msgty.
      ls_t100-id         = ls_vbfs-msgid.
      ls_t100-number     = ls_vbfs-msgno.
      ls_t100-message_v1 = ls_vbfs-msgv1.
      ls_t100-message_v2 = ls_vbfs-msgv2.
      ls_t100-message_v3 = ls_vbfs-msgv3.
      ls_t100-message_v4 = ls_vbfs-msgv4.
      APPEND ls_t100 TO lt_t100.
*********************
    ENDLOOP.
    cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~add_actual_messages( lt_t100 ).

*    #########################################################################################################################
*Workaround to refresh sales doc. This function call has to be done in RV_INVOICE_REFRESH
    CALL FUNCTION 'SD_BUFFER_TABLES_REFRESH'.
    CALL FUNCTION 'LE_DELIVERY_REFRESH_BUFFER'.
*    #########################################################################################################################
    IF lv_is_successful EQ abap_false.
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.
    LOOP AT lt_vbeln INTO ls_vbeln.
      IF ls_testdata-invoice_type IS INITIAL.
        SELECT DISTINCT vbeln INTO TABLE @billing_doc_numbers FROM vbrp WHERE vgbel = @ls_vbeln-vbeln
          AND ( vbeln NOT LIKE 'PBD%' AND vbeln NOT LIKE '$%' AND vbeln NOT LIKE 'S%' AND vbeln NOT LIKE 'TMP%' ).
      ELSE.
        SELECT DISTINCT vbeln INTO TABLE @billing_doc_numbers FROM vbrp WHERE vgbel = @ls_vbeln-vbeln AND fkart_ana = @ls_testdata-invoice_type
          AND ( vbeln NOT LIKE 'PBD%' AND vbeln NOT LIKE '$%' AND vbeln NOT LIKE 'S%' AND vbeln NOT LIKE 'TMP%' ).
      ENDIF.

      IF sy-subrc EQ 0.
        LOOP AT billing_doc_numbers INTO lv_billing_doc_number.
          "ev_document_id should only contain billing documents created in this method call
          IF line_exists( lt_vbss[ vbeln = lv_billing_doc_number ] ).
            TRY.
                DATA(already_exists) = ev_document_id[ vbeln = lv_billing_doc_number ].
              CATCH  cx_sy_itab_line_not_found INTO DATA(exp_cn).
                APPEND lv_billing_doc_number TO ev_document_id.
            ENDTRY.
          ENDIF.
        ENDLOOP.
        me->mo_run_environment->append_log( iv_log_statement = |Billing Document { lv_billing_doc_number } was created successfully for Document { ls_vbeln-vbeln }| ).
        ev_execution_status = abap_true.
      ELSE.
        me->mo_run_environment->append_log( iv_log_statement = |No Billing Document was created for Document { ls_vbeln-vbeln }| ).
        ev_execution_status = abap_false.
      ENDIF.
    ENDLOOP.
    "  DELETE ADJACENT DUPLICATES FROM ev_document_id COMPARING vbeln.

    CALL FUNCTION 'RV_INVOICE_REFRESH'
      EXPORTING
        with_posting = 'D'
      TABLES
        xkomfk       = lt_komfk
        xkomv        = lt_komv
        xthead       = lt_thead
        xvbfs        = lt_vbfs
        xvbpa        = lt_vbpavb
        xvbrk        = lt_vbrkvb
        xvbrp        = lt_vbrpvb
        xvbss        = lt_vbss.

  ENDMETHOD.


  METHOD create_cdm_with_web_service.
    DATA: ls_testdata              TYPE sdbil_esr_cdm_request_msg,
          lt_message               TYPE bapiret2_t,
          lx_success               TYPE /aif/successflag,
          lt_reference_billing_doc TYPE STANDARD TABLE OF vbeln,
          lt_vbeln                 TYPE TABLE OF vbeln_vf,
          wa_vbeln                 TYPE vbeln_vf,
          lt_buffer                TYPE STANDARD TABLE OF vbrp.

    ev_execution_status = abap_false.

    IF step_data-variant IS NOT INITIAL.
      cl_ptf_util=>get_testdata(
        EXPORTING
          is_step_data = step_data
        IMPORTING
          es_testdata  = ls_testdata
      ).
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |There is no Variant in Test Data Container.| ).
      EXIT.
    ENDIF.

*Get Data of the predecessor
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      IF lt_ptf_keys IS NOT INITIAL.
        APPEND LINES OF lt_ptf_keys TO lt_reference_billing_doc.
      ELSE.
        me->mo_run_environment->append_log( iv_log_statement = |No reference data available for creating the CDM. Previous step failed.| ).
        EXIT.
      ENDIF.
    ENDLOOP.

    IF lines( ls_testdata-reference_document ) = lines( lt_reference_billing_doc ).
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |Reference document IDs do not fit to number of Test Data entries.| ).
      EXIT.
    ENDIF.


    LOOP AT ls_testdata-reference_document INTO DATA(ls_reference_document).
      ls_testdata-reference_document[ sy-tabix ]-reference_billing_document = lt_reference_billing_doc[ sy-tabix ].
    ENDLOOP.

    NEW cl_cdm_inb_process( )->process(
      EXPORTING
        im_input   = ls_testdata
      CHANGING
        ch_message = lt_message ).

    lx_success = 'Y'.
    LOOP AT lt_message TRANSPORTING NO FIELDS WHERE type EQ 'E' OR type EQ 'A' .
      lx_success = 'N'.
    ENDLOOP.

    IF lx_success EQ 'Y'.
      ev_execution_status = abap_true.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |Error in process class.| ).
      EXIT.
    ENDIF.

    LOOP AT ls_testdata-reference_document INTO DATA(ls_reference_buffer).
      SELECT * FROM vbrp WHERE vgbel = @ls_reference_buffer-reference_billing_document INTO TABLE @lt_buffer.

      IF sy-subrc = 0.
        LOOP AT lt_buffer INTO DATA(ls_buffer).
          APPEND ls_buffer-vbeln TO lt_vbeln.
          me->mo_run_environment->append_log( iv_log_statement = |Billing Document { ls_buffer-vbeln } was created from billing document { ls_reference_buffer-reference_billing_document }| ).
        ENDLOOP.
      ENDIF.
    ENDLOOP.

    SORT lt_vbeln.
    DELETE ADJACENT DUPLICATES FROM lt_vbeln.

    ev_document_id = lt_vbeln.

  ENDMETHOD.


  METHOD create_for_item.
    DATA:
      lt_vbfs               TYPE shp_vbfs_t,
      ls_vbfs               TYPE vbfs,
      lt_vbrkvb             TYPE TABLE OF vbrkvb,
      ls_vbrkvb             TYPE vbrkvb,
      lt_vbrpvb             TYPE TABLE OF vbrpvb,
      ls_vbski              TYPE vbsk,
      lt_komfk              TYPE TABLE OF komfk,
      lt_komfkko            TYPE TABLE OF komv,
      lt_thead              TYPE TABLE OF theadvb,
      lt_vbss               TYPE TABLE OF vbss,
      lt_komv               TYPE  komv_tab,
      lt_vbpavb             TYPE  vbpa_tab,

      ls_para_gn_inv_create TYPE ty_gs_import_gn_invce_create,
      lt_komfkgn            TYPE TABLE OF komfkgn,
      ls_komfkgn            TYPE  komfkgn,
      lv_vbtyp              TYPE vbtypl,
      lv_posnr              TYPE posnr,
      lv_no_fin_doc         TYPE char1,
      lv_billing_doc_number TYPE vbeln,
      ls_return             TYPE bapiret2,
      lt_return             TYPE TABLE OF bapiret2,
      ls_testdata           TYPE ty_gs_create_for_item,
      lt_vbeln              TYPE cl_ptf_util=>ty_vbeln_tab,
      lv_is_successful      TYPE abap_bool VALUE abap_false.

*************************************************************************
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    IF ls_step_data-variant IS NOT INITIAL.
      cl_ptf_util=>get_testdata(
        EXPORTING
          is_step_data = ls_step_data
        IMPORTING
          es_testdata  = ls_testdata
      ).
    ENDIF.
*************************************************************************
*Get Data of the predecessor
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    LOOP AT lt_vbeln INTO DATA(ls_vbeln).
*Order-like
      CLEAR lv_vbtyp.
      SELECT SINGLE vbtyp FROM vbak INTO lv_vbtyp WHERE vbeln = ls_vbeln-vbeln.
      IF sy-subrc EQ 0.
        SELECT posnr FROM vbap INTO @lv_posnr WHERE vbeln = @ls_vbeln-vbeln AND posnr = @ls_testdata-item_number.
          ls_komfkgn-mandt = sy-mandt.
          ls_komfkgn-fkdat = sy-datlo.
          ls_komfkgn-vgbel = ls_vbeln-vbeln.
          ls_komfkgn-vgpos = lv_posnr.
          ls_komfkgn-vgtyp = lv_vbtyp.
          APPEND ls_komfkgn TO lt_komfkgn.
          CLEAR lv_posnr.
        ENDSELECT.
      ENDIF.
*Delivery
      CLEAR lv_vbtyp.
      SELECT SINGLE vbtyp FROM likp INTO lv_vbtyp WHERE vbeln = ls_vbeln-vbeln.
      IF sy-subrc EQ 0.
        SELECT posnr FROM lips INTO @lv_posnr WHERE vbeln = @ls_vbeln-vbeln AND posnr = @ls_testdata-item_number.
          ls_komfkgn-mandt = sy-mandt.
          ls_komfkgn-fkdat = sy-datlo.
          ls_komfkgn-vgbel = ls_vbeln-vbeln.
          ls_komfkgn-vgpos = lv_posnr.
          ls_komfkgn-vgtyp = lv_vbtyp.
          APPEND ls_komfkgn TO lt_komfkgn.
          CLEAR lv_posnr.
        ENDSELECT.
      ENDIF.
*Billing Document or BDR
      CLEAR lv_vbtyp.
      SELECT SINGLE vbtyp FROM vbrk INTO @lv_vbtyp WHERE vbeln = @ls_vbeln-vbeln.
      IF sy-subrc EQ 0.
        SELECT posnr FROM vbrp INTO @lv_posnr WHERE vbeln = @ls_vbeln-vbeln AND posnr = @ls_testdata-item_number.
          ls_komfkgn-mandt = sy-mandt.
          ls_komfkgn-fkdat = sy-datlo.
          ls_komfkgn-vgbel = ls_vbeln-vbeln.
          ls_komfkgn-vgpos = lv_posnr.
          ls_komfkgn-vgtyp = lv_vbtyp.
          APPEND ls_komfkgn TO lt_komfkgn.
          CLEAR lv_posnr.
        ENDSELECT.
      ENDIF.
    ENDLOOP.
*************************************************************************
    lv_no_fin_doc = ls_testdata-no_fin_doc.
    CALL FUNCTION 'GN_INVOICE_CREATE'
      EXPORTING
        vbsk_i                  = ls_para_gn_inv_create-vbsk_i
        with_posting            = 'D'  " ls_para_gn_inv_create-with_posting,  synchronous commit with error log
        delivery_date           = ls_para_gn_inv_create-delivery_date
        invoice_date            = ls_testdata-invoice_date
        invoice_type            = ls_testdata-invoice_type
        pricing_date            = ls_para_gn_inv_create-pricing_date
        caller_type             = ls_para_gn_inv_create-caller_type
        i_without_refresh       = ls_para_gn_inv_create-i_without_refresh
        id_no_enqueue           = ls_para_gn_inv_create-id_no_enqueue
        id_kvorg                = ls_para_gn_inv_create-id_kvorg
        id_no_dialog            = 'X' "ls_para_gn_inv_create-id_no_dialog
        id_new_cancellation     = ls_para_gn_inv_create-id_new_cancellation
        id_analyze_mode         = ls_para_gn_inv_create-id_analyze_mode
        id_no_fi_doc            = lv_no_fin_doc
        is_fi_add_input         = ls_para_gn_inv_create-is_fi_add_input
        id_sim_without_price    = ls_para_gn_inv_create-id_sim_without_price
        io_external_buffer      = ls_para_gn_inv_create-io_external_buffer
        i_no_collective_billing = ls_testdata-i_no_collective_billing
      TABLES
        xkomfk                  = lt_komfk
        xkomfkgn                = lt_komfkgn
        xkomfkko                = lt_komfkko
        xkomv                   = lt_komv
        xthead                  = lt_thead
        xvbfs                   = lt_vbfs
        xvbpa                   = lt_vbpavb
        xvbrk                   = lt_vbrkvb
        xvbrp                   = lt_vbrpvb
        xvbss                   = lt_vbss
      EXCEPTIONS
        error_message           = 1.

    CLEAR ls_return.
    LOOP AT lt_vbfs INTO ls_vbfs.
      MESSAGE ID ls_vbfs-msgid TYPE ls_vbfs-msgty NUMBER ls_vbfs-msgno INTO ls_return-message WITH ls_vbfs-msgv1 ls_vbfs-msgv2 ls_vbfs-msgv3 ls_vbfs-msgv4.
      ls_return-id =  ls_vbfs-msgid.
      "ls_return-message = ls_vbfs-msgno.
      ls_return-message_v1 = ls_vbfs-msgv1.
      ls_return-message_v2 = ls_vbfs-msgv2.
      ls_return-message_v3 = ls_vbfs-msgv3.
      ls_return-message_v4 = ls_vbfs-msgv4.
      ls_return-type = ls_vbfs-msgty.
      IF ls_vbfs-msgty EQ 'S' OR (
          ls_vbfs-msgty EQ 'W' AND ls_vbfs-vbeln NE '' "For test invoicing with no fin doc --> Only one message with msgtype w and text Document XX created (no fin doc)
        ).
        lv_is_successful = abap_true.
      ENDIF.
      me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
    ENDLOOP.

*    #########################################################################################################################
*Workarround to refresh sales doc.. This function call has to be done in RV_INVOICE_REFRESG
    CALL FUNCTION 'SD_BUFFER_TABLES_REFRESH'.
    CALL FUNCTION 'LE_DELIVERY_REFRESH_BUFFER'.
*    #########################################################################################################################
    IF lv_is_successful EQ abap_false.
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.
    LOOP AT lt_vbeln INTO ls_vbeln.
      SELECT SINGLE vbeln INTO lv_billing_doc_number FROM vbrp WHERE vgbel = ls_vbeln-vbeln.
      IF sy-subrc EQ 0.
        APPEND lv_billing_doc_number TO ev_document_id.
        me->mo_run_environment->append_log( iv_log_statement = |Billing Document { lv_billing_doc_number } was created successfully for Document { ls_vbeln-vbeln } and posnr { ls_testdata-item_number }| ).
        ev_execution_status = abap_true.
      ELSE.
        me->mo_run_environment->append_log( iv_log_statement = |No Billing Document was created for Document { ls_vbeln-vbeln } and posnr { ls_testdata-item_number }| ).
        ev_execution_status = abap_false.
      ENDIF.
    ENDLOOP.
    DELETE ADJACENT DUPLICATES FROM ev_document_id COMPARING vbeln.
  ENDMETHOD.


  METHOD create_for_item_with_pprctr.
    DATA:
      lt_vbfs               TYPE shp_vbfs_t,
      ls_vbfs               TYPE vbfs,
      lt_vbrkvb             TYPE TABLE OF vbrkvb,
      ls_vbrkvb             TYPE vbrkvb,
      lt_vbrpvb             TYPE TABLE OF vbrpvb,
      ls_vbski              TYPE vbsk,
      lt_komfk              TYPE TABLE OF komfk,
      lt_komfkko            TYPE TABLE OF komv,
      lt_thead              TYPE TABLE OF theadvb,
      lt_vbss               TYPE TABLE OF vbss,
      lt_komv               TYPE  komv_tab,
      lt_vbpavb             TYPE  vbpa_tab,

      ls_para_gn_inv_create TYPE ty_gs_import_gn_invce_create,
      lt_komfkgn            TYPE TABLE OF komfkgn,
      ls_komfkgn            TYPE  komfkgn,
      lv_vbtyp              TYPE vbtypl,
      lv_posnr              TYPE posnr,
      lv_no_fin_doc         TYPE char1,
      lv_billing_doc_number TYPE vbeln,
      ls_return             TYPE bapiret2,
      lt_return             TYPE TABLE OF bapiret2,
      ls_testdata           TYPE ty_gs_bd_cr_for_item_pprctr,
      lt_vbeln              TYPE cl_ptf_util=>ty_vbeln_tab,
      lv_is_successful      TYPE abap_bool VALUE abap_false.

*************************************************************************
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    IF ls_step_data-variant IS NOT INITIAL.
      cl_ptf_util=>get_testdata(
        EXPORTING
          is_step_data = ls_step_data
        IMPORTING
          es_testdata  = ls_testdata
      ).
    ENDIF.

*************************************************************************
*Get Data of the predecessor
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    LOOP AT lt_vbeln INTO DATA(ls_vbeln).
      LOOP AT ls_testdata-item_pprctr INTO DATA(ls_item_partner_profit_center).

*Order-like
        CLEAR lv_vbtyp.
        SELECT SINGLE vbtyp FROM vbak INTO lv_vbtyp WHERE vbeln = ls_vbeln-vbeln.
        IF sy-subrc EQ 0.
          SELECT SINGLE posnr FROM vbap INTO @lv_posnr WHERE vbeln = @ls_vbeln-vbeln AND posnr = @ls_item_partner_profit_center-item_number.
          IF sy-subrc EQ 0.
            ls_komfkgn-mandt  = sy-mandt.
            ls_komfkgn-fkdat  = sy-datlo.
            ls_komfkgn-vgbel  = ls_vbeln-vbeln.
            ls_komfkgn-vgpos  = lv_posnr.
            ls_komfkgn-vgtyp  = lv_vbtyp.
            ls_komfkgn-pprctr = ls_item_partner_profit_center-partner_profit_center.
            APPEND ls_komfkgn TO lt_komfkgn.
            CLEAR lv_posnr.
          ENDIF.
        ENDIF.
*Delivery
        CLEAR lv_vbtyp.
        SELECT SINGLE vbtyp FROM likp INTO lv_vbtyp WHERE vbeln = ls_vbeln-vbeln.
        IF sy-subrc EQ 0.
          SELECT SINGLE posnr FROM lips INTO @lv_posnr WHERE vbeln = @ls_vbeln-vbeln AND posnr = @ls_item_partner_profit_center-item_number.
          IF sy-subrc EQ 0.
            ls_komfkgn-mandt  = sy-mandt.
            ls_komfkgn-fkdat  = sy-datlo.
            ls_komfkgn-vgbel  = ls_vbeln-vbeln.
            ls_komfkgn-vgpos  = lv_posnr.
            ls_komfkgn-vgtyp  = lv_vbtyp.
            ls_komfkgn-pprctr = ls_item_partner_profit_center-partner_profit_center.
            APPEND ls_komfkgn TO lt_komfkgn.
            CLEAR lv_posnr.
          ENDIF.
        ENDIF.
*Billing Document or BDR
        CLEAR lv_vbtyp.
        SELECT SINGLE vbtyp FROM vbrk INTO @lv_vbtyp WHERE vbeln = @ls_vbeln-vbeln.
        IF sy-subrc EQ 0.
          SELECT SINGLE posnr FROM vbrp INTO @lv_posnr WHERE vbeln = @ls_vbeln-vbeln AND posnr = @ls_item_partner_profit_center-item_number.
          IF sy-subrc EQ 0.
            ls_komfkgn-mandt  = sy-mandt.
            ls_komfkgn-fkdat  = sy-datlo.
            ls_komfkgn-vgbel  = ls_vbeln-vbeln.
            ls_komfkgn-vgpos  = lv_posnr.
            ls_komfkgn-vgtyp  = lv_vbtyp.
            ls_komfkgn-pprctr = ls_item_partner_profit_center-partner_profit_center.
            APPEND ls_komfkgn TO lt_komfkgn.
            CLEAR lv_posnr.
          ENDIF.
        ENDIF.

      ENDLOOP.
    ENDLOOP.
*************************************************************************
    lv_no_fin_doc = ls_testdata-no_fin_doc.
    CALL FUNCTION 'GN_INVOICE_CREATE'
      EXPORTING
        vbsk_i                  = ls_para_gn_inv_create-vbsk_i
        with_posting            = 'D'  " ls_para_gn_inv_create-with_posting,  synchronous commit with error log
        delivery_date           = ls_para_gn_inv_create-delivery_date
        invoice_date            = ls_testdata-invoice_date
        invoice_type            = ls_testdata-invoice_type
        pricing_date            = ls_para_gn_inv_create-pricing_date
        caller_type             = ls_para_gn_inv_create-caller_type
        i_without_refresh       = ls_para_gn_inv_create-i_without_refresh
        id_no_enqueue           = ls_para_gn_inv_create-id_no_enqueue
        id_kvorg                = ls_para_gn_inv_create-id_kvorg
        id_no_dialog            = 'X' "ls_para_gn_inv_create-id_no_dialog
        id_new_cancellation     = ls_para_gn_inv_create-id_new_cancellation
        id_analyze_mode         = ls_para_gn_inv_create-id_analyze_mode
        id_no_fi_doc            = lv_no_fin_doc
        is_fi_add_input         = ls_para_gn_inv_create-is_fi_add_input
        id_sim_without_price    = ls_para_gn_inv_create-id_sim_without_price
        io_external_buffer      = ls_para_gn_inv_create-io_external_buffer
        i_no_collective_billing = ls_testdata-i_no_collective_billing
      TABLES
        xkomfk                  = lt_komfk
        xkomfkgn                = lt_komfkgn
        xkomfkko                = lt_komfkko
        xkomv                   = lt_komv
        xthead                  = lt_thead
        xvbfs                   = lt_vbfs
        xvbpa                   = lt_vbpavb
        xvbrk                   = lt_vbrkvb
        xvbrp                   = lt_vbrpvb
        xvbss                   = lt_vbss
      EXCEPTIONS
        error_message           = 1.

    CLEAR ls_return.
    LOOP AT lt_vbfs INTO ls_vbfs.
      MESSAGE ID ls_vbfs-msgid TYPE ls_vbfs-msgty NUMBER ls_vbfs-msgno INTO ls_return-message WITH ls_vbfs-msgv1 ls_vbfs-msgv2 ls_vbfs-msgv3 ls_vbfs-msgv4.
      ls_return-id =  ls_vbfs-msgid.
      "ls_return-message = ls_vbfs-msgno.
      ls_return-message_v1 = ls_vbfs-msgv1.
      ls_return-message_v2 = ls_vbfs-msgv2.
      ls_return-message_v3 = ls_vbfs-msgv3.
      ls_return-message_v4 = ls_vbfs-msgv4.
      ls_return-type = ls_vbfs-msgty.
      IF ls_vbfs-msgty EQ 'S' OR (
          ls_vbfs-msgty EQ 'W' AND ls_vbfs-vbeln NE '' "For test invoicing with no fin doc --> Only one message with msgtype w and text Document XX created (no fin doc)
        ).
        lv_is_successful = abap_true.
      ENDIF.
      me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
    ENDLOOP.

*    #########################################################################################################################
*Workarround to refresh sales doc.. This function call has to be done in RV_INVOICE_REFRESG
    CALL FUNCTION 'SD_BUFFER_TABLES_REFRESH'.
    CALL FUNCTION 'LE_DELIVERY_REFRESH_BUFFER'.
*    #########################################################################################################################
    IF lv_is_successful EQ abap_false.
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.
    LOOP AT lt_vbeln INTO ls_vbeln.
      LOOP AT ls_testdata-item_pprctr INTO ls_item_partner_profit_center.
        SELECT SINGLE vbeln INTO lv_billing_doc_number FROM vbrp WHERE vgbel = ls_vbeln-vbeln AND vgpos = ls_item_partner_profit_center-item_number.
        IF sy-subrc EQ 0.
          APPEND lv_billing_doc_number TO ev_document_id.
          me->mo_run_environment->append_log( iv_log_statement = |Billing Document { lv_billing_doc_number } was created successfully for Document { ls_vbeln-vbeln } and posnr { ls_item_partner_profit_center-item_number }| ).
          ev_execution_status = abap_true.
        ELSE.
          me->mo_run_environment->append_log( iv_log_statement = |No Billing Document was created for Document { ls_vbeln-vbeln } and posnr { ls_item_partner_profit_center-item_number }| ).
          ev_execution_status = abap_false.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
    DELETE ADJACENT DUPLICATES FROM ev_document_id COMPARING vbeln.
  ENDMETHOD.


METHOD create_partially.
  DATA:
    lt_vbfs               TYPE shp_vbfs_t,
    ls_vbfs               TYPE vbfs,
    lt_vbrkvb             TYPE TABLE OF vbrkvb,
    ls_vbrkvb             TYPE vbrkvb,
    lt_vbrpvb             TYPE TABLE OF vbrpvb,
    ls_vbski              TYPE vbsk,
    lt_komfk              TYPE TABLE OF komfk,
    lt_komfkko            TYPE TABLE OF komv,
    lt_thead              TYPE TABLE OF theadvb,
    lt_vbss               TYPE TABLE OF vbss,
    lt_komv               TYPE  komv_tab,
    lt_vbpavb             TYPE  vbpa_tab,

    ls_para_gn_inv_create TYPE ty_gs_import_gn_invce_create,
    lt_komfkgn            TYPE TABLE OF komfkgn,
    ls_komfkgn            TYPE  komfkgn,
    lv_vbtyp              TYPE vbtypl,
    lv_posnr              TYPE posnr,
    lv_no_fin_doc         TYPE char1,
    lv_billing_doc_number TYPE vbeln,
    ls_return             TYPE bapiret2,
    lt_return             TYPE TABLE OF bapiret2,
    ls_testdata           TYPE ty_gs_create_for_item,   "TODO: create table type with item number and qty to be billed
    lt_vbeln              TYPE cl_ptf_util=>ty_vbeln_tab,
    lv_is_successful      TYPE abap_bool VALUE abap_false.

*************************************************************************
  DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
  IF ls_step_data-variant IS NOT INITIAL.
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).
  ENDIF.
*************************************************************************
*Get Data of the predecessor
  LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    APPEND LINES OF lt_ptf_keys TO lt_vbeln.
  ENDLOOP.

  LOOP AT lt_vbeln INTO DATA(ls_vbeln).
*Delivery
    CLEAR lv_vbtyp.
    SELECT SINGLE vbtyp FROM likp INTO lv_vbtyp WHERE vbeln = ls_vbeln-vbeln.
    IF sy-subrc EQ 0.
      SELECT posnr FROM lips INTO @lv_posnr WHERE vbeln = @ls_vbeln-vbeln.
        ls_komfkgn-mandt = sy-mandt.
        ls_komfkgn-fkdat = sy-datlo.
        ls_komfkgn-vgbel = ls_vbeln-vbeln.
        ls_komfkgn-vgpos = lv_posnr.
        ls_komfkgn-vgtyp = lv_vbtyp.
        "LOOP AT ls_testdata-partial_billing assigning field symbol(<ls_partial_billing>) where posnr = lv_posnr.
        "ls_komfkgn-kwmeng = <ls_partial_billing>-qty_to_be_billed.

        APPEND ls_komfkgn TO lt_komfkgn.
        CLEAR lv_posnr.
      ENDSELECT.
    ENDIF.
  ENDLOOP.
  IF lt_komfkgn IS INITIAL.
    me->mo_run_environment->append_log( iv_log_statement = |There is no preceding document to be invoiced.| ).
    RETURN.
  ENDIF.
ENDMETHOD.


METHOD create_sbi_invoice_by_soap.
  DATA:
    lt_return_msg      TYPE bapiret2_t,
    ls_testdata        TYPE ty_gs_ptf_call_by_soap_td,
    ls_data            TYPE sdbil_esr_sbi_bd_create_mes,
    lv_succ            TYPE /aif/successflag,
    lv_msg             TYPE string,
    lv_status_code_txt TYPE string,
    lv_step_success    TYPE abap_bool,
    lv_xml_xstring     TYPE xstring,
    lv_length          TYPE i,
    lv_offset          TYPE i,
    lv_offset_next     TYPE i,
    lv_field           TYPE string,
    lv_id              TYPE string,
    lv_timestamp       TYPE string,
    lv_document_id     TYPE vbeln.

*--> 1 Step: Get data from tdc
  cl_ptf_util=>get_testdata(
    EXPORTING
      is_step_data = step_data
    IMPORTING
      es_testdata  = ls_testdata ).

  IF ls_testdata IS INITIAL.
    ev_execution_status = abap_false.
    me->mo_run_environment->append_log( iv_log_statement = |PTF: Please enter TDCV for this action!| ).
    EXIT.
  ENDIF.

*   Get Data of the predecessor
  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    IF lt_ptf_keys IS NOT INITIAL.
      lv_document_id = lt_ptf_keys[ 1 ].
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |No reference data available. Previous step failed.| ).
      EXIT.
    ENDIF.
  ENDLOOP.

*--> 2 Step: Replace gloabl parameters in Payload
  "Replace UUID
  TRY.
      lv_id = cl_system_uuid=>if_system_uuid_rfc4122_static~create_uuid_c36_by_version( version = 4 ).
    CATCH cx_uuid_error.
  ENDTRY.
  REPLACE ALL OCCURRENCES OF '{GUID}' IN ls_testdata-request_uri WITH lv_id.

  "Replace MSG ID
  REPLACE ALL OCCURRENCES OF '-' IN lv_id WITH ''.
  TRANSLATE lv_id TO UPPER CASE.
  REPLACE ALL OCCURRENCES OF '{MSG_ID}' IN ls_testdata-payload WITH lv_id.

  "Creation Date Time && External Doc Last Change Date Time
  lv_timestamp = utclong_current( ) .
  lv_timestamp = |{ lv_timestamp(10) }| && |T| && |{ lv_timestamp+11(8) }| && |Z|.
  REPLACE ALL OCCURRENCES OF '{CREATE_DATE_TIME}' IN ls_testdata-payload WITH lv_timestamp.

  "BillingDocumentType
*    REPLACE ALL OCCURRENCES OF '{BILLING_DOCUMENT_TYPE}' IN ls_testdata-payload WITH 'CIXS'.

  "BillingDocumentDate
  REPLACE ALL OCCURRENCES OF '{BILLING_DOCUMENT_DATE}' IN ls_testdata-payload WITH lv_timestamp(10).

  "ServicesRenderedDate
  REPLACE ALL OCCURRENCES OF '{SERVICES_RENDERED_DATE}' IN ls_testdata-payload WITH lv_timestamp(10).

  "ReferenceDocument
  REPLACE ALL OCCURRENCES OF '{REFERENCE_DOCUMENT}' IN ls_testdata-payload WITH lv_document_id.


*--> 3 Step: Call SOAP Service base on tdc
  "Call via HTTP client
  IF ls_testdata-host IS NOT INITIAL AND ls_testdata-request_uri IS NOT INITIAL.
    cl_ptf_http_call=>call_http_client(
    EXPORTING
        iv_host        = ls_testdata-host
        iv_request_uri = ls_testdata-request_uri
        iv_username    = ls_testdata-username
        iv_password    = ls_testdata-password
        iv_soapaction  = '"http://sap.com/xi/SD-BIL/BDCreateSelfBillingRequest_In/BDCreateSelfBillingRequest_InRequest"'
        iv_payload     = ls_testdata-payload
      IMPORTING
        ev_status_code = DATA(lv_status_code)
        ev_status_text = DATA(lv_status_text)
        ev_body        = DATA(lv_body)
    ).

    lv_status_code_txt = lv_status_code.
    lv_msg = |API: Executed SOAP API Call Create Service Contract with status code { lv_status_code_txt } and status text { lv_status_text }|.
    me->mo_run_environment->append_log( iv_log_statement = lv_msg ).

    IF lv_status_code = 200 OR lv_status_code = 201 OR lv_status_code = 202.
      lv_step_success = abap_true.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |API: Error calling API Service: { lv_status_code } : { lv_status_text }.| ).
      lv_step_success = abap_false.
    ENDIF.
  ELSE.
*      ##### This coding could be used as fault back but currently the convertion from xml to ABAP is not working properly #####
*      "Transform xstring to abap structuer
*      call function 'SCMS_STRING_TO_XSTRING'
*        exporting
*          text   = ls_testdata-payload
*        importing
*          buffer = lv_xml_xstring
*        exceptions
*          failed = 1
*          others = 2.
*      if sy-subrc eq 0.
*        data(lo_sxml_reader) = cl_sxml_string_reader=>create( input = lv_xml_xstring ).
*        try.
*            cl_proxy_xml_transform=>xml_to_abap( exporting
*                                                   ddic_type  = 'SDBIL_ESR_SBI_BD_CREATE_MES'
*                                                   xml_reader = lo_sxml_reader
*                                                 importing
*                                                   abap_data  = ls_data ).
*
*            data(lo_process) = cl_sdbil_sbi_bd_create_factory=>get_process( ).
*            lo_process->process(
*              exporting
*                im_input   =  ls_data                " Proxy Structure (generated)
*              changing
*                ch_message =  lt_return_msg        " Return parameter table
*            ).
*            loop at lt_return_msg into data(ls_return_msg).
*              if ls_return_msg-type = 'E'.
*                lv_step_success = abap_false.
*              else.
*                lv_step_success = abap_true.
*              endif.
*            endloop.
*
*          catch cx_proxy_fault into data(lx_fault).
*            lv_msg = lx_fault->get_longtext( ).
*            me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
*            lv_step_success = abap_false.
*        endtry.
*      else.
*        message s196(cms) into lv_msg.
*        me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
*        lv_step_success = abap_false.
*      endif.
*
*
**--> 3 Step: Output in case of success
*      "Copy messages to et_return
*      loop at lt_return_msg assigning field-symbol(<ls_return_msg>).
*        clear lv_msg.
*        if <ls_return_msg>-message is initial     and
*           <ls_return_msg>-id      is not initial and
*           <ls_return_msg>-number  is not initial.
*          data(lo_message) = new cl_t100_message( the_msg_class  = <ls_return_msg>-id
*                                                  the_msg_number = <ls_return_msg>-number ).
*          data(lt_msgv) = value name2value_table(
*           ( name = cl_t100_message=>msgv1_name value = <ls_return_msg>-message_v1 )
*           ( name = cl_t100_message=>msgv2_name value = <ls_return_msg>-message_v2 )
*           ( name = cl_t100_message=>msgv3_name value = <ls_return_msg>-message_v3 )
*           ( name = cl_t100_message=>msgv4_name value = <ls_return_msg>-message_v4 ) ).
*
*          lo_message->set_substitution_table( lt_msgv ) .
*          lv_msg = lo_message->if_message~get_text( ).
*        else.
*          if <ls_return_msg>-message is not initial.
*            lv_msg = <ls_return_msg>-message .
*          endif.
*        endif.
*        if lv_msg is not initial.
*          lv_msg = |API: { lv_msg }|.
*          me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
*        endif.
*      endloop.

  ENDIF.

  IF lv_step_success EQ abap_true.
    WAIT UP TO 5 SECONDS.

    SELECT SINGLE vbeln FROM vbrp INTO @DATA(lv_vbeln) WHERE vgbel = @lv_document_id AND vgpos = '000010'.
    IF sy-subrc = 0.
      APPEND lv_vbeln TO ev_document_id.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |No document was created.| ).
      lv_step_success = abap_false.
    ENDIF.
  ENDIF.

  IF lv_step_success EQ abap_true.
    ev_execution_status = abap_true.
  ELSE.
    ev_execution_status = abap_false.
  ENDIF.

ENDMETHOD.


  METHOD create_snapshot.
    DATA: ls_billing_header TYPE bapivbrk.
    DATA: lt_billing_header TYPE STANDARD TABLE OF bapivbrk.
    DATA: ls_success        TYPE bapivbrksuccess.
    DATA: lt_success        TYPE STANDARD TABLE OF bapivbrksuccess.
    DATA: lt_return         TYPE cl_ptf_util=>gt_ptf_return_tab.
    DATA: lo_snapshot_facade TYPE REF TO cl_sd_bil_snapshot_facade.
    DATA: lt_billing_instruction TYPE if_sd_bil_type_def=>tt_billing_instruction.
    DATA: ls_billing_instruction TYPE if_sd_bil_type_def=>ty_billing_instruction.
    DATA: ls_return TYPE bapiret2.
    DATA: ls_draft_document TYPE  if_sd_bil_type_def=>ty_draft_document,
          lt_vbeln          TYPE cl_ptf_util=>ty_vbeln_tab.
    CREATE OBJECT lo_snapshot_facade.

*========================================================
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.
    DATA ls_vbeln_data TYPE vbeln.
    IF lt_vbeln IS NOT INITIAL.
      LOOP AT lt_vbeln INTO DATA(ls_vbeln).
        CLEAR ls_billing_instruction.
        DATA ls_vbuk TYPE vbuk.
        MOVE ls_vbeln-vbeln TO ls_vbeln_data.
        CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
          EXPORTING
            i_vbeln             = ls_vbeln_data
          IMPORTING
            es_vbuk             = ls_vbuk
          EXCEPTIONS
            vbeln_not_found     = 1
            vbtyp_not_supported = 2
            vbobj_not_supported = 3
            OTHERS              = 4.
        IF sy-subrc <> 0.
          RETURN.
        ELSE.
          ls_billing_instruction-id = ls_vbeln-vbeln.

          SELECT SINGLE vbtyp FROM vkdfs WHERE vbeln = @ls_vbeln-vbeln INTO @DATA(vbtyp).
          IF vbtyp IS INITIAL.
            me->mo_run_environment->append_log( iv_log_statement = |Could not determine vbtyp for document { ls_vbeln-vbeln }| ).
            ev_execution_status = abap_false.
            RETURN.
          ELSE.
            ls_billing_instruction-sd_document_category = vbtyp.
          ENDIF.
          APPEND ls_billing_instruction TO lt_billing_instruction.
        ENDIF.
      ENDLOOP.
    ELSE.
*        MESSAGE ID 'PTF'
    ENDIF.

*************************************************************************
    CALL METHOD cl_sd_bil_snapshot_facade=>if_sd_bil_dradoc_action~create
      EXPORTING
*       is_default_data        =
        it_billing_instruction = lt_billing_instruction
**       iv_no_collective_billing = SPACE
      IMPORTING
        et_draft_document      = DATA(lt_draft_document)
        et_message             = DATA(lt_message).
*    #########################################################################################################################
*Workarround to refresh sales doc.. This function call has to be done in RV_INVOICE_REFRESG
    CALL FUNCTION 'SD_BUFFER_TABLES_REFRESH'.
*    #########################################################################################################################
*************************************************************************
* As create doesn't trigger a COMMIT we need to trigger explicitly.
    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

*************************************************************************
*Check whether Billing Documents exists and create output
    DATA lv_msg_number TYPE symsgno.
    DATA lv_predec_msgno TYPE symsgno.
    DATA lv_predec_msgtype TYPE bapi_mtype.
* Write Message text in the et_return table (for Application Log.)
    LOOP AT lt_message ASSIGNING FIELD-SYMBOL(<ls_message>).
      lv_msg_number = <ls_message>-msgno.
      IF lv_predec_msgno NE <ls_message>-msgno
      AND lv_predec_msgtype NE <ls_message>-msgty.
        CALL FUNCTION 'BALW_BAPIRETURN_GET2'
          EXPORTING
            type   = <ls_message>-msgty
            cl     = <ls_message>-msgid " Message Class (Message ID)
            number = lv_msg_number " Message Number
          IMPORTING
            return = ls_return.  " BAPI Return Parameter
        me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
        LOOP AT lt_draft_document INTO ls_draft_document.
          CONCATENATE 'Document ID:' ' ' ls_draft_document-vbeln ' ' INTO ls_return-message SEPARATED BY space.
          me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
          CLEAR ls_return.
        ENDLOOP.
        lv_predec_msgno = <ls_message>-msgno.
      ENDIF.
    ENDLOOP.


    READ TABLE lt_draft_document INTO ls_draft_document INDEX 1.
    IF NOT sy-subrc IS INITIAL.
      RETURN.
    ELSE.
      LOOP AT lt_draft_document INTO ls_draft_document.
        APPEND ls_draft_document-vbeln TO ev_document_id.
      ENDLOOP.
      ev_execution_status = abap_true.
      SORT ev_document_id.
      DELETE ADJACENT DUPLICATES FROM ev_document_id COMPARING vbeln.
    ENDIF.

  ENDMETHOD.


  METHOD create_snapshot_lock_check.
    DATA: ls_billing_header TYPE bapivbrk.
    DATA: lt_billing_header TYPE STANDARD TABLE OF bapivbrk.
    DATA: ls_success        TYPE bapivbrksuccess.
    DATA: lt_success        TYPE STANDARD TABLE OF bapivbrksuccess.
    DATA: lt_return         TYPE cl_ptf_util=>gt_ptf_return_tab.
    DATA: lo_snapshot_facade TYPE REF TO cl_sd_bil_snapshot_facade.
    DATA: lt_billing_instruction TYPE if_sd_bil_type_def=>tt_billing_instruction.
    DATA: ls_billing_instruction TYPE if_sd_bil_type_def=>ty_billing_instruction.
    DATA: ls_return TYPE bapiret2.
    DATA: ls_draft_document TYPE  if_sd_bil_type_def=>ty_draft_document,
          lt_vbeln          TYPE cl_ptf_util=>ty_vbeln_tab.
    CREATE OBJECT lo_snapshot_facade.

*========================================================
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.
    DATA: ls_vbeln_data TYPE vbeln.

    IF lt_vbeln IS NOT INITIAL.
      LOOP AT lt_vbeln INTO DATA(ls_vbeln).
        CLEAR ls_billing_instruction.
        DATA ls_vbuk TYPE vbuk.
        MOVE ls_vbeln-vbeln TO ls_vbeln_data.
        CALL FUNCTION 'SD_VBUK_READ_FROM_DOC'
          EXPORTING
            i_vbeln             = ls_vbeln_data
          IMPORTING
            es_vbuk             = ls_vbuk
          EXCEPTIONS
            vbeln_not_found     = 1
            vbtyp_not_supported = 2
            vbobj_not_supported = 3
            OTHERS              = 4.
        IF sy-subrc <> 0.
          RETURN.
        ELSE.
          ls_billing_instruction-id = ls_vbeln-vbeln.
          APPEND ls_billing_instruction TO lt_billing_instruction.
        ENDIF.
      ENDLOOP.
    ELSE.
*        MESSAGE ID 'PTF'
    ENDIF.

*************************************************************************
    CONSTANTS    : lc_posting_with_messages TYPE string VALUE 'U'.
    CONSTANTS    : lc_draft TYPE abap_bool VALUE abap_true.
    CONSTANTS    : lc_posting_on TYPE char1 VALUE 'F'.
    CONSTANTS    : lc_posting_off TYPE char1 VALUE space.
    FIELD-SYMBOLS: <reference_document> TYPE if_sd_bil_type_def=>ty_billing_instruction.
    DATA         : ls_xkomfk TYPE komfk.
    DATA         : lt_xkomfk TYPE TABLE OF komfk.
    DATA         : lt_xkomv  TYPE TABLE OF komv.
    DATA         : lt_xthead TYPE TABLE OF theadvb.
    DATA         : lt_xvbfs  TYPE TABLE OF vbfs.
    DATA         : lt_xvbpa  TYPE TABLE OF vbpavb.
    DATA         : lt_xvbrk  TYPE vbrkvb_t.
    DATA         : lt_xvbrp  TYPE vbrpvb_t.
    DATA         : lt_xvbss  TYPE vbss_t.
    DATA         : ls_vbsk   TYPE vbsk.
    DATA         : ls_vbrk   TYPE vbrk.
    DATA         : lt_reference_document TYPE if_sd_bil_type_def=>tt_billing_instruction.
    DATA         : lt_draft_document TYPE if_sd_bil_type_def=>tt_draft_document.
    DATA         : lt_message TYPE if_sd_bil_type_def=>tt_message.
    DATA lv_check_lock TYPE abap_bool.
    DATA   billing_date     TYPE fkdat.

    lv_check_lock  = abap_false.

    MOVE-CORRESPONDING  lt_billing_instruction TO  lt_reference_document.
    IF NOT lt_reference_document IS INITIAL.
      LOOP AT lt_reference_document ASSIGNING <reference_document>.
        CLEAR ls_xkomfk.
        ls_xkomfk-vbeln  = <reference_document>-id.
        ls_xkomfk-fkart = <reference_document>-billing_doc_type.
        ls_xkomfk-vbtyp  = <reference_document>-sd_document_category.
        ls_xkomfk-seldat = <reference_document>-billing_requested_date.
        APPEND ls_xkomfk TO lt_xkomfk.
      ENDLOOP.


      CALL FUNCTION 'RV_INVOICE_CREATE'
        EXPORTING
          vbsk_i                  = ls_vbsk
          invoice_type            = space
          invoice_date            = billing_date
          with_posting            = lc_posting_off
          i_no_collective_billing = space
          iv_draft_mode           = if_sd_bil_draft_mode=>snapshot
        TABLES
          xkomfk                  = lt_xkomfk
          xkomv                   = lt_xkomv
          xthead                  = lt_xthead
          xvbfs                   = lt_xvbfs
          xvbpa                   = lt_xvbpa
          xvbrk                   = lt_xvbrk
          xvbrp                   = lt_xvbrp
          xvbss                   = lt_xvbss.


*      LOOP AT lt_billing_instruction INTO ls_billing_instruction.
*
**        CALL FUNCTION 'ENQUEUE_EVVBAKE'
**          EXPORTING
**            vbeln          = ls_billing_instruction-id
**          EXCEPTIONS
**            foreign_lock   = 2
**            system_failure = 3.
**        CASE sy-subrc.
**          WHEN 2.
**            lv_check_lock  = abap_true.
**          WHEN 3.
*        ENDCASE.
*ENDLOOP.
      DATA: sysubrc   TYPE   sy-subrc.

      PERFORM ('LOCK_BILLING_PLAN') IN PROGRAM ('SAPLV60A') USING sysubrc IF FOUND.
      IF sysubrc = 2.
        lv_check_lock  = abap_true.
      ENDIF.



      CALL FUNCTION 'RV_INVOICE_DOCUMENT_ADD'
        EXPORTING
          vbsk_i          = ls_vbsk
          with_posting    = lc_posting_on
          without_refresh = 'X'
        TABLES
          xkomfk          = lt_xkomfk
          xkomv           = lt_xkomv
          xthead          = lt_xthead
          xvbfs           = lt_xvbfs
          xvbpa           = lt_xvbpa
          xvbrk           = lt_xvbrk
          xvbrp           = lt_xvbrp
          xvbss           = lt_xvbss.
      LOOP AT lt_xvbrk INTO ls_vbrk WHERE draft = if_sd_bil_draft_mode=>snapshot.
        APPEND ls_vbrk-vbeln TO lt_draft_document.
      ENDLOOP.
      APPEND LINES OF lt_xvbfs TO lt_message.
      CALL FUNCTION 'RV_INVOICE_REFRESH'
        EXPORTING
          with_posting = lc_posting_with_messages
        TABLES
          xkomfk       = lt_xkomfk
          xkomv        = lt_xkomv
          xthead       = lt_xthead
          xvbfs        = lt_xvbfs
          xvbpa        = lt_xvbpa
          xvbrk        = lt_xvbrk
          xvbrp        = lt_xvbrp
          xvbss        = lt_xvbss.
    ENDIF.
*************************************************************************
*Check whether Billing Documents exists and create output
    DATA lv_msg_number TYPE symsgno.
    DATA lv_predec_msgno TYPE symsgno.
    DATA lv_predec_msgtype TYPE bapi_mtype.
* Write Message text in the et_return table (for Application Log.)
    LOOP AT lt_message ASSIGNING FIELD-SYMBOL(<ls_message>).
      lv_msg_number = <ls_message>-msgno.
      IF lv_predec_msgno NE <ls_message>-msgno
      AND lv_predec_msgtype NE <ls_message>-msgty.
        CALL FUNCTION 'BALW_BAPIRETURN_GET2'
          EXPORTING
            type   = <ls_message>-msgty
            cl     = <ls_message>-msgid " Message Class (Message ID)
            number = lv_msg_number " Message Number
          IMPORTING
            return = ls_return.  " BAPI Return Parameter
        me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
        LOOP AT lt_draft_document INTO ls_draft_document.
          CONCATENATE 'Document ID:' ' ' ls_draft_document-vbeln ' ' INTO ls_return-message SEPARATED BY space.
          me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
          CLEAR ls_return.
        ENDLOOP.
        lv_predec_msgno = <ls_message>-msgno.
      ENDIF.
    ENDLOOP.


    READ TABLE lt_draft_document INTO ls_draft_document INDEX 1.
    IF NOT sy-subrc IS INITIAL.
      RETURN.
    ELSE.
      LOOP AT lt_draft_document INTO ls_draft_document.
        APPEND ls_draft_document-vbeln TO ev_document_id.
      ENDLOOP.
*      cs_step_data-execution_status = abap_true.
      ev_execution_status = lv_check_lock.
      ev_check_status = lv_check_lock.
      SORT ev_document_id.
      DELETE ADJACENT DUPLICATES FROM ev_document_id COMPARING vbeln.
    ENDIF.
  ENDMETHOD.


METHOD create_soap_api_bd_w_ref.
  DATA: ls_testdata            TYPE sdbil_esr_bd_ref_request_msg,
        lt_message             TYPE bapiret2_t,
        lx_success             TYPE /aif/successflag,
        lt_reference_documents TYPE STANDARD TABLE OF vbeln,
        lt_vbeln               TYPE TABLE OF vbeln_vf,
        wa_vbeln               TYPE vbeln_vf,
        lt_buffer              TYPE STANDARD TABLE OF vbrp.

  ev_execution_status = abap_false.

*    IF step_data-variant IS NOT INITIAL.
*      cl_ptf_util=>get_testdata(
*        EXPORTING
*          is_step_data = step_data
*        IMPORTING
*          es_testdata  = ls_testdata
*      ).
*    ELSE.
*      me->mo_run_environment->append_log( iv_log_statement = |There is no Variant in Test Data Container.| ).
*      EXIT.
*    ENDIF.

*Get Data of the predecessor
  LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    IF lt_ptf_keys IS NOT INITIAL.
      APPEND LINES OF lt_ptf_keys TO lt_reference_documents.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |No reference data available for creating Billing Documents. Previous step failed.| ).
      EXIT.
    ENDIF.
  ENDLOOP.

*    IF lines( ls_testdata-reference_document ) = lines( lt_reference_billing_doc ).
*    ELSE.
*      me->mo_run_environment->append_log( iv_log_statement = |Reference document IDs do not fit to number of Test Data entries.| ).
*      EXIT.
*    ENDIF.
*
*
*    LOOP AT ls_testdata-reference_document INTO DATA(ls_reference_document).
*      ls_testdata-reference_document[ sy-tabix ]-reference_billing_document = lt_reference_billing_doc[ sy-tabix ].
*    ENDLOOP.
  LOOP AT lt_reference_documents ASSIGNING FIELD-SYMBOL(<ls_reference_document>).
    APPEND INITIAL LINE TO ls_testdata-reference_document REFERENCE INTO DATA(lr_testdata).
    lr_testdata->reference_document_id = <ls_reference_document>.
  ENDLOOP.

  NEW cl_sdbil_soa_bdref_process( )->process(
    EXPORTING
      im_input   = ls_testdata
    IMPORTING
      ex_success = lx_success
    CHANGING
      ch_message = lt_message ).

  IF lx_success EQ 'Y'.
    ev_execution_status = abap_true.
  ELSE.
    me->mo_run_environment->append_log( iv_log_statement = |No success in process class.| ).
    EXIT.
  ENDIF.

  LOOP AT ls_testdata-reference_document INTO DATA(ls_reference_buffer).
    SELECT * FROM vbrp WHERE vgbel = @ls_reference_buffer-reference_document_id INTO TABLE @lt_buffer.

    IF sy-subrc = 0.
      LOOP AT lt_buffer INTO DATA(ls_buffer).
        APPEND ls_buffer-vbeln TO lt_vbeln.
        me->mo_run_environment->append_log( iv_log_statement = |Billing Document { ls_buffer-vbeln } was created from billing document { ls_reference_buffer-reference_document_id }| ).
      ENDLOOP.
    ENDIF.
  ENDLOOP.

  SORT lt_vbeln.
  DELETE ADJACENT DUPLICATES FROM lt_vbeln.

  ev_document_id = lt_vbeln.
ENDMETHOD.


  METHOD create_with_pprctr.
    DATA:
      lt_vbfs               TYPE shp_vbfs_t,
      ls_vbfs               TYPE vbfs,
      lt_vbrkvb             TYPE TABLE OF vbrkvb,
      ls_vbrkvb             TYPE vbrkvb,
      lt_vbrpvb             TYPE TABLE OF vbrpvb,
      ls_vbski              TYPE vbsk,
      lt_komfk              TYPE TABLE OF komfk,
      lt_komfkko            TYPE TABLE OF komv,
      lt_thead              TYPE TABLE OF theadvb,
      lt_vbss               TYPE TABLE OF vbss,
      lt_komv               TYPE  komv_tab,
      lt_vbpavb             TYPE  vbpa_tab,

      ls_para_gn_inv_create TYPE ty_gs_import_gn_invce_create,
      lt_komfkgn            TYPE TABLE OF komfkgn,
      ls_komfkgn            TYPE  komfkgn,
      lv_invoice_date       TYPE dats,
      lv_vbtyp              TYPE vbtypl,
      lv_posnr              TYPE posnr,
      lv_no_fin_doc         TYPE char1,
      lv_billing_doc_number TYPE vbeln,
      ls_return             TYPE bapiret2,
      lt_return             TYPE TABLE OF bapiret2,
      ls_testdata           TYPE ty_gs_bd_cr_with_pprctr,
      lt_vbeln              TYPE cl_ptf_util=>ty_vbeln_tab,
      lv_is_successful      TYPE abap_bool VALUE abap_false.

*************************************************************************
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    IF ls_step_data-variant IS NOT INITIAL.
      cl_ptf_util=>get_testdata(
        EXPORTING
          is_step_data = ls_step_data
        IMPORTING
          es_testdata  = ls_testdata
      ).
    ENDIF.

    "Determine invoice date
    IF ls_testdata-invoice_date IS INITIAL AND ls_testdata-delta_invoice_date IS NOT INITIAL.
      lv_invoice_date = sy-datlo + ls_testdata-delta_invoice_date.
    ELSE.
      lv_invoice_date = ls_testdata-invoice_date.
    ENDIF.

*************************************************************************
*Get Data of the predecessor
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    "Add tdc reference
    IF ls_testdata-hard_coded_reference IS NOT INITIAL.
      APPEND ls_testdata-hard_coded_reference TO lt_vbeln.
    ENDIF.

    LOOP AT lt_vbeln INTO DATA(ls_vbeln).
*Order-like
      CLEAR lv_vbtyp.
      SELECT SINGLE vbtyp FROM vbak INTO lv_vbtyp WHERE vbeln = ls_vbeln-vbeln.
      IF sy-subrc EQ 0.
        CLEAR ls_komfkgn.
        ls_komfkgn-mandt  = sy-mandt.
        ls_komfkgn-fkdat  = sy-datlo.
        ls_komfkgn-vgbel  = ls_vbeln-vbeln.
        ls_komfkgn-vgtyp  = lv_vbtyp.
        ls_komfkgn-pprctr = ls_testdata-partner_profit_center.
        APPEND ls_komfkgn TO lt_komfkgn.
      ENDIF.
*Delivery
      CLEAR lv_vbtyp.
      SELECT SINGLE vbtyp FROM likp INTO lv_vbtyp WHERE vbeln = ls_vbeln-vbeln.
      IF sy-subrc EQ 0.
        CLEAR ls_komfkgn.
        ls_komfkgn-mandt  = sy-mandt.
        ls_komfkgn-fkdat  = sy-datlo.
        ls_komfkgn-vgbel  = ls_vbeln-vbeln.
        ls_komfkgn-vgtyp  = lv_vbtyp.
        ls_komfkgn-pprctr = ls_testdata-partner_profit_center.
        APPEND ls_komfkgn TO lt_komfkgn.
      ENDIF.
*Billing Document or BDR
      CLEAR lv_vbtyp.
      SELECT SINGLE vbtyp FROM vbrk INTO @lv_vbtyp WHERE vbeln = @ls_vbeln-vbeln.
      IF sy-subrc EQ 0.
        CLEAR ls_komfkgn.
        ls_komfkgn-mandt  = sy-mandt.
        ls_komfkgn-fkdat  = sy-datlo.
        ls_komfkgn-vgbel  = ls_vbeln-vbeln.
        ls_komfkgn-vgtyp  = lv_vbtyp.
        ls_komfkgn-pprctr = ls_testdata-partner_profit_center.
        APPEND ls_komfkgn TO lt_komfkgn.
      ENDIF.
    ENDLOOP.
*************************************************************************
    lv_no_fin_doc = ls_testdata-no_fin_doc.
    CALL FUNCTION 'GN_INVOICE_CREATE'
      EXPORTING
        vbsk_i                  = ls_para_gn_inv_create-vbsk_i
        with_posting            = 'D'  " ls_para_gn_inv_create-with_posting,  synchronous commit with error log
        delivery_date           = ls_para_gn_inv_create-delivery_date
        invoice_date            = ls_testdata-invoice_date
        invoice_type            = ls_testdata-invoice_type
        pricing_date            = ls_para_gn_inv_create-pricing_date
        caller_type             = ls_para_gn_inv_create-caller_type
        i_without_refresh       = ls_para_gn_inv_create-i_without_refresh
        id_no_enqueue           = ls_para_gn_inv_create-id_no_enqueue
        id_kvorg                = ls_para_gn_inv_create-id_kvorg
        id_no_dialog            = 'X' "ls_para_gn_inv_create-id_no_dialog
        id_new_cancellation     = ls_para_gn_inv_create-id_new_cancellation
        id_analyze_mode         = ls_para_gn_inv_create-id_analyze_mode
        id_no_fi_doc            = lv_no_fin_doc
        is_fi_add_input         = ls_para_gn_inv_create-is_fi_add_input
        id_sim_without_price    = ls_para_gn_inv_create-id_sim_without_price
        io_external_buffer      = ls_para_gn_inv_create-io_external_buffer
        i_no_collective_billing = ls_testdata-i_no_collective_billing
      TABLES
        xkomfk                  = lt_komfk
        xkomfkgn                = lt_komfkgn
        xkomfkko                = lt_komfkko
        xkomv                   = lt_komv
        xthead                  = lt_thead
        xvbfs                   = lt_vbfs
        xvbpa                   = lt_vbpavb
        xvbrk                   = lt_vbrkvb
        xvbrp                   = lt_vbrpvb
        xvbss                   = lt_vbss
      EXCEPTIONS
        error_message           = 1.

    CLEAR ls_return.
    LOOP AT lt_vbfs INTO ls_vbfs.
      MESSAGE ID ls_vbfs-msgid TYPE ls_vbfs-msgty NUMBER ls_vbfs-msgno INTO ls_return-message WITH ls_vbfs-msgv1 ls_vbfs-msgv2 ls_vbfs-msgv3 ls_vbfs-msgv4.
      ls_return-id =  ls_vbfs-msgid.
      "ls_return-message = ls_vbfs-msgno.
      ls_return-message_v1 = ls_vbfs-msgv1.
      ls_return-message_v2 = ls_vbfs-msgv2.
      ls_return-message_v3 = ls_vbfs-msgv3.
      ls_return-message_v4 = ls_vbfs-msgv4.
      ls_return-type = ls_vbfs-msgty.
      IF ls_vbfs-msgty EQ 'S' OR (
          ls_vbfs-msgty EQ 'W' AND ls_vbfs-vbeln NE '' "For test invoicing with no fin doc --> Only one message with msgtype w and text Document XX created (no fin doc)
        ).
        lv_is_successful = abap_true.
      ENDIF.
      me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
    ENDLOOP.

*    #########################################################################################################################
*Workarround to refresh sales doc.. This function call has to be done in RV_INVOICE_REFRESG
    CALL FUNCTION 'SD_BUFFER_TABLES_REFRESH'.
    CALL FUNCTION 'LE_DELIVERY_REFRESH_BUFFER'.
*    #########################################################################################################################
    IF lv_is_successful EQ abap_false.
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.
    LOOP AT lt_vbeln INTO ls_vbeln.
      SELECT SINGLE vbeln INTO lv_billing_doc_number FROM vbrp WHERE vgbel = ls_vbeln-vbeln.
      IF sy-subrc EQ 0.
        APPEND lv_billing_doc_number TO ev_document_id.
        me->mo_run_environment->append_log( iv_log_statement = |Billing Document { lv_billing_doc_number } was created successfully for Document { ls_vbeln-vbeln }| ).
        ev_execution_status = abap_true.
      ELSE.
        me->mo_run_environment->append_log( iv_log_statement = |No Billing Document was created for Document { ls_vbeln-vbeln }| ).
        ev_execution_status = abap_false.
      ENDIF.
    ENDLOOP.
    DELETE ADJACENT DUPLICATES FROM ev_document_id COMPARING vbeln.

    CALL FUNCTION 'RV_INVOICE_REFRESH'
      EXPORTING
        with_posting = 'D'
      TABLES
        xkomfk       = lt_komfk
        xkomv        = lt_komv
        xthead       = lt_thead
        xvbfs        = lt_vbfs
        xvbpa        = lt_vbpavb
        xvbrk        = lt_vbrkvb
        xvbrp        = lt_vbrpvb
        xvbss        = lt_vbss.

  ENDMETHOD.


  METHOD create_with_web_service.
    DATA:
      lv_out             TYPE boolean,
      wa_vbeln           TYPE vbeln_vf,
      lt_vbeln           TYPE TABLE OF vbeln_vf,
      ls_bd_request_msg  TYPE sdbil_esr_bd_request_msg,
*      lt_bdr_request_result TYPE sdbil_ebdr_request_result_t,
*      ls_bdr_request_result TYPE sdbil_ebdr_request_result,
*      lt_bdr_request_failed TYPE sdbil_ebdr_request_failed_t,
*      lt_bd_request_msg  TYPE sdbil_bd_request_msg_t,
      ls_bd_billable_doc TYPE sdbil_esr_bd_billable_doc,
      ls_bd_bllbl_doc_it TYPE sdbil_esr_bd_billable_doc_item,
      ls_bd_pricing_elem TYPE sdbil_esr_bd_pricing_element,
      ls_bd_text         TYPE sdbil_esr_bdr_text,
      ls_bd_pmt_card     TYPE sdbil_esr_bd_payment_card,
      ls_testdata        TYPE ty_gs_i_ptf_bd_cr_ws_td,
      lv_counter         TYPE string VALUE 0,
      lv_found           TYPE abap_bool VALUE abap_true,
      lv_success         TYPE /aif/successflag,
      lt_message         TYPE bapiret2_t.

    ev_execution_status = abap_false. " assume test fails

    CONSTANTS:
          lc_aif_success TYPE /aif/successflag VALUE 'Y'.

******************************************************************************
* 1. Step: Get test data for BD creation
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

    IF ls_testdata-bd_request_msg-billable_document IS INITIAL.
      mo_run_environment->append_log( |There is no preceding document to be invoiced.| ).
      RETURN.
    ENDIF.

******************************************************************************
* 2. Step: BD Request In - Message Mapping
******************************************************************************
    ls_bd_request_msg-global_parameters-reference_document_logical_sys = 'PTF_BDRIN'.

    LOOP AT ls_testdata-bd_request_msg-billable_document REFERENCE INTO DATA(lr_bd_request_in).
      lv_found = abap_true.
* Field PrecedingDocument will be filled dynmically
      WHILE lv_found = abap_true.
        ADD 1 TO lv_counter.
        CONCATENATE 'PTF' sy-datlo+2(4) lv_counter INTO ls_bd_billable_doc-reference_document.
        SELECT SINGLE vgbel FROM vbrp
           WHERE vgbel = @ls_bd_billable_doc-reference_document
           INTO @DATA(wa).
        IF sy-subrc IS INITIAL.
          lv_found = abap_true.
        ELSE.
          lv_found = abap_false.
        ENDIF.
      ENDWHILE.

      lr_bd_request_in->reference_document = ls_bd_billable_doc-reference_document.

      LOOP AT lr_bd_request_in->billable_document_item REFERENCE INTO DATA(lr_bd_request_it_in).
        ls_bd_bllbl_doc_it-reference_document_item        = lr_bd_request_it_in->reference_document_item.
        ls_bd_bllbl_doc_it-billing_document_type          = lr_bd_request_it_in->billing_document_type.
        ls_bd_bllbl_doc_it-billing_document_item_text     = lr_bd_request_it_in->billing_document_item_text.
        ls_bd_bllbl_doc_it-sales_document_type            = lr_bd_request_it_in->sales_document_type.
        ls_bd_bllbl_doc_it-sales_document_item_category   = lr_bd_request_it_in->sales_document_item_category.
        ls_bd_bllbl_doc_it-sales_organization             = lr_bd_request_it_in->sales_organization.
        ls_bd_bllbl_doc_it-distribution_channel           = lr_bd_request_it_in->distribution_channel.
        ls_bd_bllbl_doc_it-division                       = lr_bd_request_it_in->division.
        ls_bd_bllbl_doc_it-billing_document_date          = sy-datum.  "lr_ebdr_request_in->billingdate.
        ls_bd_bllbl_doc_it-sold_to_party                  = lr_bd_request_it_in->sold_to_party.
        ls_bd_bllbl_doc_it-transaction_currency           = lr_bd_request_it_in->transaction_currency.
        ls_bd_bllbl_doc_it-tax_departure_country          = lr_bd_request_it_in->tax_departure_country.
        ls_bd_bllbl_doc_it-product_tax_classification1    = lr_bd_request_it_in->product_tax_classification1.
        ls_bd_bllbl_doc_it-product_tax_classification2    = lr_bd_request_it_in->product_tax_classification2.
        ls_bd_bllbl_doc_it-product_tax_classification3    = lr_bd_request_it_in->product_tax_classification3.
        ls_bd_bllbl_doc_it-product_tax_classification4    = lr_bd_request_it_in->product_tax_classification4.
        ls_bd_bllbl_doc_it-product_tax_classification5    = lr_bd_request_it_in->product_tax_classification5.
        ls_bd_bllbl_doc_it-customer_tax_classification1   = lr_bd_request_it_in->customer_tax_classification1.
        ls_bd_bllbl_doc_it-customer_tax_classification2   = lr_bd_request_it_in->customer_tax_classification2.
        ls_bd_bllbl_doc_it-customer_tax_classification3   = lr_bd_request_it_in->customer_tax_classification3.
        ls_bd_bllbl_doc_it-customer_tax_classification4   = lr_bd_request_it_in->customer_tax_classification4.
        ls_bd_bllbl_doc_it-customer_tax_classification5   = lr_bd_request_it_in->customer_tax_classification5.
        ls_bd_bllbl_doc_it-material                       = lr_bd_request_it_in->material.
        ls_bd_bllbl_doc_it-requested_quantity-content     = lr_bd_request_it_in->requested_quantity-content.
        ls_bd_bllbl_doc_it-requested_quantity-unit_code   = lr_bd_request_it_in->requested_quantity-unit_code.
        ls_bd_bllbl_doc_it-plant                          = lr_bd_request_it_in->plant.
        ls_bd_bllbl_doc_it-departure_country              = lr_bd_request_it_in->departure_country.
        ls_bd_bllbl_doc_it-matl_account_assignment_group  = lr_bd_request_it_in->matl_account_assignment_group.
        ls_bd_bllbl_doc_it-customer_account_assignment_gr = lr_bd_request_it_in->customer_account_assignment_gr.

        LOOP AT lr_bd_request_it_in->pricing_element REFERENCE INTO DATA(lr_bd_requ_it_cond_in).
          ls_bd_pricing_elem-condition_type                = lr_bd_requ_it_cond_in->condition_type.
          ls_bd_pricing_elem-condition_rate_value          = lr_bd_requ_it_cond_in->condition_rate_value.
          ls_bd_pricing_elem-condition_currency            = lr_bd_requ_it_cond_in->condition_currency.
          ls_bd_pricing_elem-condition_quantity-content    = lr_bd_requ_it_cond_in->condition_quantity-content.
          ls_bd_pricing_elem-condition_quantity-unit_code  = lr_bd_requ_it_cond_in->condition_quantity-unit_code.
          "Pricing Element to Item
          APPEND ls_bd_pricing_elem TO ls_bd_bllbl_doc_it-pricing_element.
        ENDLOOP.

        LOOP AT lr_bd_request_it_in->text REFERENCE INTO DATA(lr_bd_requ_it_text_in).
          ls_bd_text-text_element       = lr_bd_requ_it_text_in->text_element.
          ls_bd_text-language           = lr_bd_requ_it_text_in->language.
          ls_bd_text-text_element_text  = lr_bd_requ_it_text_in->text_element_text.
          "Text Element to Item
          APPEND ls_bd_text TO ls_bd_bllbl_doc_it-text.
          CLEAR ls_bd_text.
        ENDLOOP.

        "Item to Document
        APPEND ls_bd_bllbl_doc_it TO ls_bd_billable_doc-billable_document_item.
      ENDLOOP.

      LOOP AT lr_bd_request_in->text REFERENCE INTO DATA(lr_bd_requ_text_in).
        ls_bd_text-text_element_text  = lr_bd_requ_text_in->text_element. " lr_ebdr_requ_text_in->language.
        ls_bd_text-language           = lr_bd_requ_text_in->language.
        ls_bd_text-text_element_text  = lr_bd_requ_text_in->text_element_text.
        "Text to Document
        APPEND ls_bd_text TO ls_bd_billable_doc-text.
        CLEAR ls_bd_text.
      ENDLOOP.

      LOOP AT lr_bd_request_in->payment_card REFERENCE INTO DATA(lr_bd_request_pc_in).
        ls_bd_pmt_card-payment_card_type = lr_bd_request_pc_in->payment_card_type.
        ls_bd_pmt_card-payt_card_by_digital_payment_s = lr_bd_request_pc_in->payt_card_by_digital_payment_s.
        ls_bd_pmt_card-payment_card_masked_number = lr_bd_request_pc_in->payment_card_masked_number.
        ls_bd_pmt_card-payment_card_validity_end_date = lr_bd_request_pc_in->payment_card_validity_end_date.
        ls_bd_pmt_card-payment_card_holder_name = lr_bd_request_pc_in->payment_card_holder_name.
        ls_bd_pmt_card-authorized_amount_in_authzn_cr-currency_code = lr_bd_request_pc_in->authorized_amount_in_authzn_cr-currency_code.
        ls_bd_pmt_card-authorized_amount_in_authzn_cr-content = lr_bd_request_pc_in->authorized_amount_in_authzn_cr-content.
        ls_bd_pmt_card-authorization_date_time = lr_bd_request_pc_in->authorization_date_time.
        ls_bd_pmt_card-authorization_by_digital_payt = lr_bd_request_pc_in->authorization_by_digital_payt.
        ls_bd_pmt_card-authorization_by_acquirer = lr_bd_request_pc_in->authorization_by_acquirer.
        ls_bd_pmt_card-preauthorization_is_requested = lr_bd_request_pc_in->preauthorization_is_requested.
        ls_bd_pmt_card-payment_service_provider       = lr_bd_request_pc_in->payment_service_provider.
        ls_bd_pmt_card-payment_by_payment_service_prv = lr_bd_request_pc_in->payment_by_payment_service_prv.
        ls_bd_pmt_card-transaction_by_payt_srvc_prvdr = lr_bd_request_pc_in->transaction_by_payt_srvc_prvdr.
        ls_bd_pmt_card-payment_card_validity_start_da = lr_bd_request_pc_in->payment_card_validity_start_da.

        "Payment Card to Document
        APPEND ls_bd_pmt_card TO ls_bd_billable_doc-payment_card.
        CLEAR ls_bd_pmt_card.
      ENDLOOP.

      "Document to Message
      APPEND ls_bd_billable_doc TO ls_bd_request_msg-billable_document.

      "CLEAR all work areas per billable item
      CLEAR ls_bd_billable_doc.
      CLEAR ls_bd_bllbl_doc_it-pricing_element.
      CLEAR ls_bd_bllbl_doc_it-text.
      CLEAR ls_bd_billable_doc-billable_document_item.
      CLEAR ls_bd_billable_doc-text.
    ENDLOOP.

******************************************************************************
* 3. Step: BD Request In - Message Processing
******************************************************************************
    NEW cl_sdbil_soa_bd_processing( )->process(
      EXPORTING
        ir_message = REF #( ls_bd_request_msg )
      IMPORTING
        ev_success = lv_success
      CHANGING
        ct_message = lt_message
    ).

    LOOP AT lt_message ASSIGNING FIELD-SYMBOL(<msg>).
      me->mo_run_environment->append_log_structure( is_log = <msg> ).
    ENDLOOP.



******************************************************************************
* 5. Step: Check result and set success flag
******************************************************************************

* Find created billing documents


*    LOOP AT lt_bdr_request_result REFERENCE INTO DATA(lr_bdr_request_result).
*      APPEND lr_bdr_request_result->extbillingdocrequest TO cs_step_data-document_id.
*      MODIFY ct_step_data FROM cs_step_data INDEX cs_step_data-step_number .
*    ENDLOOP.

    LOOP AT ls_testdata-bd_request_msg-billable_document REFERENCE INTO lr_bd_request_in.
      SELECT SINGLE vbeln FROM vbrp WHERE vgbel = @lr_bd_request_in->reference_document
                               AND vgpos = @lr_bd_request_it_in->reference_document_item INTO @wa_vbeln.
      IF sy-subrc = 0.
        LOOP AT lt_vbeln INTO DATA(wa_vbeln2).
          IF wa_vbeln2 = wa_vbeln.
            lv_out = abap_true.
          ENDIF.
        ENDLOOP.
        IF lv_out = abap_true.
          EXIT.
        ENDIF.
        APPEND wa_vbeln TO ev_document_id.
        APPEND wa_vbeln TO lt_vbeln.
        CLEAR lv_out.
      ENDIF.

    ENDLOOP.



    IF lv_success = lc_aif_success.
      ev_execution_status = abap_true.
    ENDIF.

*    IF lt_bdr_request_result IS NOT INITIAL AND
*     lt_bdr_request_failed IS INITIAL.
*      cs_step_data-execution_status = abap_true.
*    ENDIF.

  ENDMETHOD.


  METHOD delete.
  ENDMETHOD.


  method execute_action.
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    case ls_step_data-action.
      when c_simulate_pricing_web_service.
        me->simulate_pricing_web_service(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_clear_partial_payment.
        me->clear_partial_payment(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_create_with_vkorg.
        me->create_with_vkorg(
          exporting
            iv_step_data        = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_partial_payment.
        me->partial_payment(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_create_cdm_with_web_service.
        me->create_cdm_with_web_service(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_create_soap_api_bd_w_ref.
        me->create_soap_api_bd_w_ref(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_clear_fi.
        me->clear_fi(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_read_fi_documents.
        me->read_fi_documents(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_odata_post_cr_for_countries.
        me->odata_post_cr_for_countries(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_post_create_for_country.
        me->odata_post_create_for_country(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_create_for_item.
        me->create_for_item(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_check_vkdfs.
        me->check_vkdfs(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_api_post_fi_cancel_bd_neg.
        me->api_post_fi_cancel_bd_neg(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_api_post_fi_cancel_bd.
        me->api_post_fi_cancel_bd(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_odata_post_compare_bd.
        me->odata_post_compare_bd(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_odata_get_pdf_bd.
        me->odata_get_pdf(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_odata_get_pdf_neg_ne.
        me->odata_get_pdf_neg_ne(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_odata_get_bd_list_item.
        me->odata_get_bd_list_item(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_odata_post_create_bds.
        me->odata_post_create_bds(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_odata_post_get_bd_types.
        me->odata_post_get_bd_types(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_odata_get_bd_item.
        me->odata_get_bd_item(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_odata_get_bd.
        me->odata_get_bd(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_odata_post_post_bd_to_acc.
        me->odata_post_bd_to_acc(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_odata_post_delete_snapshot.
        me->odata_post_delete_snapshot(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_odata_post_cancel_bd.
        me->odata_post_cancel_bd(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_odata_post_activate_snapshot.
        me->odata_post_activate_snapshot(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_odata_get_subs_bd_sbi.
        me->odata_get_subsqnt_billdoc(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_create_snapshot.
        me->create_snapshot(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_activate_snapshot.
        me->activate_snapshot(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_create_snapshot_lock_check.
        me->create_snapshot_lock_check(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_cancel.
        me->cancel(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_release_to_accounting                      or 'RELEASE_TO_ACC_TRIT_TDT'."for CL_PTF_BO_INVOICE_MOCK
        me->release_to_accounting(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_cancel_item.
        me->cancel_item(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_create_with_web_service.
        me->create_with_web_service(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_fill_ext_field.
        me->fill_ext_field(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_internal_update.
        me->internal_update(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_release_dup_to_accounting.
        me->release_dup_to_accounting(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_update_bd_zuonr_xblnr.
        me->update_bd_zuonr_xblnr(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_log_status.
        me->log_status(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_event.
        me->log_status(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_create_partially.
        me->create_partially(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_create_sbi_invoice_by_soap.
        me->create_sbi_invoice_by_soap(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when 'SUBMIT_TEST'.
        me->submit_test(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when 'SUBMIT_AND_RETURN_TEST'.
        me->submit_and_return_test(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when 'UPDATE_TASK_TEST'.
        me->update_task_test(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_complete_proforma.
        me->complete_proforma(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_change_invoice_header.
        me->change_invoice_header(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_wait.
        me->wait(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
        ).
        return.
      when c_create_with_pprctr.
        me->create_with_pprctr(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_create_for_item_with_pprctr.
        me->create_for_item_with_pprctr(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).

      when others.
        me->mo_run_environment->append_log( iv_log_statement = |Could not find method { ls_step_data-action } for the BO { ls_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        return.
    endcase.

  endmethod.


  method execute_check.

    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    "Use PTFBOA-ABAP_METHOD if filled
    select single * from ptfboa into @data(ls_ptfboa) where ptf_bo = @ls_step_data-bus_obj and ptf_act = @ls_step_data-action.
    if ls_ptfboa-abap_method is not initial.

      try.
          call method me->(ls_ptfboa-abap_method)
            exporting
              step_data           = ls_step_data
              iv_step_number      = iv_step_number
            importing
              ev_document_id      = ev_document_id
              ev_execution_status = ev_execution_status
              ev_check_status     = ev_check_status.
        catch cx_sy_dyn_call_illegal_method into data(lx_methodcall).
          me->mo_run_environment->append_log( iv_log_statement = |Couldn't find the method { ls_ptfboa-abap_method } from PTFBOA for BO { ls_step_data-bus_obj }| ).
          ev_execution_status = abap_false.
          ev_check_status = abap_false.
      endtry.

      return.

    endif.


** No need to add new actions here anymore: Just name your Method like the Action, and it will be called automatically by the generic call below (at the end of this method). **

    "Use the calls implemented, as PTFBOA-ABAP_METHOD is empty. Not all deleted in this method as the private methods have deviating names for parameter step_data

    case ls_step_data-action.
*      WHEN c_check_fi_ext_flow.  "constant value EQ method name           "commented out some of the methods that have parameter name step_data. for such actions, the call works generically.
*        me->check_fi_ext_flow(
*          EXPORTING
*            step_data           = ls_step_data
*            iv_step_number      = iv_step_number
*          IMPORTING
*            ev_document_id      = ev_document_id
*            ev_execution_status = ev_execution_status
*            ev_check_status     = ev_check_status
*        ).
*        RETURN.
*      WHEN c_check_fi_tax_country.  "constant value EQ method name
*        me->check_fi_tax_country(
*          EXPORTING
*            step_data           = ls_step_data
*            iv_step_number      = iv_step_number
*          IMPORTING
*            ev_document_id      = ev_document_id
*            ev_execution_status = ev_execution_status
*            ev_check_status     = ev_check_status
*        ).
*        RETURN.
*      WHEN c_check_a_billingdocument.  "constant value EQ method name
*        me->check_a_billingdocument(
*          EXPORTING
*            step_data           = ls_step_data
*            iv_step_number      = iv_step_number
*          IMPORTING
*            ev_document_id      = ev_document_id
*            ev_execution_status = ev_execution_status
*            ev_check_status     = ev_check_status
*        ).
*        RETURN.
*      WHEN c_check_bdr_so_bp_amount.  "constant value EQ method name
*        me->check_bdr_so_bp_amount(
*          EXPORTING
*            step_data           = ls_step_data
*            iv_step_number      = iv_step_number
*          IMPORTING
*            ev_document_id      = ev_document_id
*            ev_execution_status = ev_execution_status
*            ev_check_status     = ev_check_status
*        ).
*        RETURN.
      when c_check_dp_settlment. "constant value EQ method name
        me->check_dp_settlment(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_fi_allocation. "constant value EQ method name
        me->check_fi_allocation(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_preceding. "constant value EQ method name
        me->check_preceding(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_aubel_ref. "constant value EQ method name
        me->check_aubel_ref(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_prefix.
        me->check_prefix(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_pricing_conditions.
        me->check_pricing_conditions(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_dyn_output.
        me->check_dyn_output(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_multiple.
        me->check_multiple(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_sepa_mandate.
        me->check_sepa_mandate(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_number_of_positions.
        me->check_number_of_positions(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_number_vkdfs_entries.
        me->check_number_vkdfs_entries(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_vkdfs.
        me->check_vkdfs(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_compare_billing_doc.
        me->check_compare_billing_doc(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_compare_vbfa.
        me->check_compare_vbfa(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_condition_exists.
        me->check_condition_exists(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_expected_doc_quantity.
        me->check_expected_doc_quantity(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_ext_fields.
        me->check_ext_fields(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_output.
        me->check_output(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_price_greater_zero.
        me->check_price_greater_zero(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_text.
        me->check_text(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_text_pbd.
        me->check_text_pbd(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_xblnr_predec.
        me->check_xblnr_predec(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_zuonr_predec.
        me->check_zuonr_predec(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_zuonr_currnt.
        me->check_zuonr_currnt(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_paypal_data.
        me->check_paypal_data(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_ana_fields.
        me->check_ana_fields(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_bd_zuonr_xblnr.
        me->check_bd_zuonr_xblnr(
          exporting
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_multi_cdm.
        me->check_multi_cdm(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_vbfa_processflow.
        me->check_vbfa_processflow(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_bd_simul_wo_pc.
        me->check_bd_simul_wo_pc(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_bd_simul_wo_extt.
        me->check_bd_simul_wo_extt(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_edi_output.
        me->check_edi_output(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_edi_output_ext_assoc.
        me->check_edi_output_ext_assc(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_edi_split_ariba.
        me->check_edi_split_ariba(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_edi_output_party.
        me->check_edi_output_party(
          exporting
            is_step_data        = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_edi_output_header.
        me->check_edi_output_header(
          exporting
            is_step_data        = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_edi_output_pric_elem. "constant value 'CHECK_EDI_OUTPUT_PRICING_ELEM' DEVIATING from method name
        me->check_edi_output_pricing_elem(
          exporting
            is_step_data        = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_edi_output_item.
        me->check_edi_output_item(
          exporting
            is_step_data        = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_event.
        me->check_event(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_fi_kidno.
        me->check_fi_kidno(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_account_assign_service.
        me->check_account_assign_service(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_assigned_bp.
        me->check_assigned_bp(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_address_number.
        me->check_address_number(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_new_project_billing.
        me->check_new_project_billing(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_new_projbill_w_downpay.
        me->check_new_projbill_w_downpay(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_new_projbill_dp_settl.
        me->check_new_projbill_dp_settl(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_new_pb_no_dp_settl.
        me->check_new_projbill_no_dp_settl(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_bd_prices.
        me->check_bd_prices(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_line_items.
        me->check_line_items(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_complete_proforma.
        me->check_complete_proforma(                   "there is no parameter for step_data at this method
          exporting
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_hxf.
        me->check_hxf(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_vcm.
        me->check_vcm(
          exporting
            iv_step_number      = iv_step_number
            step_data           = ls_step_data
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_msico_vcm.
        me->check_msico_vcm(
          exporting
            iv_step_number      = iv_step_number
            step_data           = ls_step_data
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_wavwr_adv_ico.
        me->check_wavwr_adv_ico(
          exporting
            iv_step_number      = iv_step_number
            step_data           = ls_step_data
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
     when c_check_wavwr_ms_ico.
        me->check_wavwr_ms_ico(
          exporting
            iv_step_number      = iv_step_number
            step_data           = ls_step_data
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
*      WHEN c_check_prof_segement.    "constant value DEVIATES from method name         "call not needed anymore, method name for this action is maintained in PTFBOA
*        me->check_profitab_segment(
*          EXPORTING
*            iv_step_number      = iv_step_number
*            step_data           = ls_step_data
*          IMPORTING
*            ev_document_id      = ev_document_id
*            ev_execution_status = ev_execution_status
*            ev_check_status     = ev_check_status
*        ).
*        RETURN.
      when c_check_edi_output_hilvlitm_bt.  "constant value DEVIATES from method name
        me->check_edi_output_hilvlitm_btch(
          exporting
            iv_step_number      = iv_step_number
            step_data           = ls_step_data
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_net_value_vkdfs_advico.
        me->check_net_value_vkdfs_advico(
          exporting
            iv_step_number      = iv_step_number
            step_data           = ls_step_data
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_faz_tax_vbrp_bseg.
        me->check_faz_tax_vbrp_bseg(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.

      when c_check_vbrp_land_region.
        me->check_vbrp_land_region(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_check_vbrp_with_tvap.
        me->check_vbrp_with_tvap(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.

      when c_check_ico_scenario_split_inv.
        me->check_ico_scenario_split_inv(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.

*      WHEN c_check_flex_bbi_cm_dm.  "constant value EQ method name
*        me->check_flex_bbi_cm_dm(
*          EXPORTING
*            iv_step_number      = iv_step_number
*            step_data           = ls_step_data
*          IMPORTING
*            ev_document_id      = ev_document_id
*            ev_execution_status = ev_execution_status
*            ev_check_status     = ev_check_status
*        ).
*        RETURN.
*      WHEN c_check_batch_split.  "constant value EQ method name
*        me->check_batch_split(
*          EXPORTING
*            iv_step_number      = iv_step_number
*            step_data           = ls_step_data
*          IMPORTING
*            ev_document_id      = ev_document_id
*            ev_execution_status = ev_execution_status
*            ev_check_status     = ev_check_status
*        ).
*        RETURN.

** No need to add new actions here anymore: Just name your Method like the Action, and it will be called automatically by the generic call below. **
**  Note: Make sure that the signature of your method is the same as in the call below (especially parameter name step_data).

      when others.

        "Generic call: If there is a method with the same name as the action, call it
        data(lo_description) = cast cl_abap_classdescr( cl_abap_typedescr=>describe_by_object_ref( me ) ).
        read table lo_description->methods with table key primary_key components name = ls_step_data-action into data(ls).
        if sy-subrc is initial.

          try.
              call method me->(ls_step_data-action)
                exporting
                  step_data           = ls_step_data
                  iv_step_number      = iv_step_number
                importing
                  ev_document_id      = ev_document_id
                  ev_execution_status = ev_execution_status
                  ev_check_status     = ev_check_status.
            catch cx_sy_dyn_call_illegal_method into lx_methodcall.
              data lt_callstack type abap_callstack.
              call function 'SYSTEM_CALLSTACK'
                exporting
                  max_level = 1
                importing
                  callstack = lt_callstack.
              data(lv_method) = lt_callstack[ 1 ]-blockname.
*              me->mo_run_environment->append_log( iv_log_statement = |Couldn't find the method { ls_step_data-action } for BO { ls_step_data-bus_obj }| ).
              me->mo_run_environment->append_log( iv_log_statement = |Dynamic call out of { lv_method }, based on action name { ls_step_data-action }, failed. { cl_abap_classdescr=>get_class_name( me ) }| ).
              ev_execution_status = abap_false.
              ev_check_status = abap_false.
          endtry.

        else.

          me->mo_run_environment->append_log( iv_log_statement = |Could not find a method for { ls_step_data-action } of BO { ls_step_data-bus_obj }.| ). "changed text
          ev_execution_status = abap_false.
          ev_check_status = abap_false.
        endif.

    endcase.


  endmethod.


  METHOD fill_ext_field.
    DATA: ls_testdata      TYPE cl_ptf_sd_util=>ty_gs_i_ptf_ext_field_check_td,
          lr_ext_fields    TYPE REF TO cl_ptf_sd_util=>ty_gs_ext_field_td,
          lv_error_occured TYPE abap_bool,
          lv_bil_doc_nr    TYPE vbeln,
          lr_vbrk          TYPE REF TO vbrkvb,
          lr_vbrp          TYPE REF TO vbrpvb.

    DATA: ls_vbrk_i TYPE vbrk,
          lt_xkomv  TYPE TABLE OF komv,
          lt_xvbfs  TYPE TABLE OF vbfs,
          lt_xvbpa  TYPE TABLE OF vbpavb,
          lt_xvbss  TYPE TABLE OF vbss,
          lt_xkomfk TYPE TABLE OF komfk,
          lt_xthead TYPE TABLE OF theadvb,
          lt_xvbrk  TYPE TABLE OF vbrkvb,
          lt_xvbrp  TYPE TABLE OF vbrpvb,
          lt_vbeln  TYPE cl_ptf_util=>ty_vbeln_tab,
          lt_xvbuk  TYPE TABLE OF vbukvb,
          lt_xvbup  TYPE TABLE OF vbupvb,
          lt_xsadr  TYPE TABLE OF sadrvb,
          lt_xvbfa  TYPE TABLE OF vbfavb,
          lt_yvbpa  TYPE TABLE OF vbpavb,
          lt_yvbrk  TYPE TABLE OF vbrkvb,
          lt_yvbrp  TYPE TABLE OF vbrpvb,
          ls_vbsk_i TYPE vbsk.
    FIELD-SYMBOLS <ext_fields> TYPE any.

*************************************************************************
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata ).
*************************************************************************
*Check Predecessor Status
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.
*************************************************************************
    LOOP AT lt_vbeln INTO lv_bil_doc_nr.
      ls_vbrk_i-vbeln = lv_bil_doc_nr.
      CALL FUNCTION 'RV_INVOICE_DOCUMENT_READ'
        EXPORTING
          vbrk_i       = ls_vbrk_i
        TABLES
          xkomv        = lt_xkomv
          xvbpa        = lt_xvbpa
          xvbrk        = lt_xvbrk
          xvbrp        = lt_xvbrp
        EXCEPTIONS
          no_authority = 1
          OTHERS       = 2.
      IF sy-subrc IS NOT INITIAL.
        mo_run_environment->append_log( iv_log_statement = |RV_INVOICE_DOCUMENT_READ has sy-subrc { sy-subrc } | ).
        RETURN.
      ENDIF.
*     Head
      READ TABLE lt_xvbrk REFERENCE INTO lr_vbrk INDEX 1.
      lr_vbrk->updkz = 'U'.
      LOOP AT ls_testdata-ext_fields REFERENCE INTO lr_ext_fields.
        ASSIGN COMPONENT lr_ext_fields->name OF STRUCTURE lr_vbrk->* TO <ext_fields>.
        IF <ext_fields> IS ASSIGNED.
          <ext_fields> = lr_ext_fields->expected_input.
        ELSE.

        ENDIF.
        UNASSIGN <ext_fields>.
      ENDLOOP.
*     Item
      LOOP AT lt_xvbrp REFERENCE INTO lr_vbrp.
        lr_vbrp->updkz = 'U'.
        LOOP AT ls_testdata-ext_fields REFERENCE INTO lr_ext_fields.
          ASSIGN COMPONENT lr_ext_fields->name OF STRUCTURE lr_vbrp->* TO <ext_fields>.
          IF <ext_fields> IS ASSIGNED.
            <ext_fields> = lr_ext_fields->expected_input.
          ELSE.

          ENDIF.
          UNASSIGN <ext_fields>.
        ENDLOOP.
      ENDLOOP.
      CALL FUNCTION 'RV_INVOICE_POST'
        EXPORTING
          no_konv = 'X'
          vbsk_i  = ls_vbsk_i
        TABLES
          xkomv   = lt_xkomv
          xsadr   = lt_xsadr
          xvbfa   = lt_xvbfa
          xvbfs   = lt_xvbfs
          xvbpa   = lt_xvbpa
          xvbrk   = lt_xvbrk
          xvbrp   = lt_xvbrp
          xvbss   = lt_xvbss
          xvbuk   = lt_xvbuk
          xvbup   = lt_xvbup
          yvbpa   = lt_yvbpa
          yvbrk   = lt_yvbrk
          yvbrp   = lt_yvbrp
          yvbuk   = lt_xvbuk
          yvbup   = lt_xvbup.

      CALL FUNCTION 'RV_INVOICE_REFRESH'
        EXPORTING
          with_posting = 'D'
          i_no_nast    = 'X'
        TABLES
          xkomfk       = lt_xkomfk
          xkomv        = lt_xkomv
          xthead       = lt_xthead
          xvbfs        = lt_xvbfs
          xvbpa        = lt_xvbpa
          xvbrk        = lt_xvbrk
          xvbrp        = lt_xvbrp
          xvbss        = lt_xvbss.
************************************************************************
      cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
      ev_execution_status = abap_true.
      mo_run_environment->append_log( iv_log_statement = |Done.| ).
    ENDLOOP.

  ENDMETHOD.


METHOD get_edi_output_invoice.
  DATA: ls_message    TYPE edi_customer_invoice_message,
        lt_return_tab TYPE STANDARD TABLE OF bapiret2,
        lt_finf       TYPE /aif/t_finf.

  IF lines( is_step_data-reference_step ) > 1.
    me->mo_run_environment->append_log( iv_log_statement = |Only one reference step allowed!| ).
    RETURN.
  ENDIF.

  READ TABLE is_step_data-reference_step INTO DATA(ls_ref_step) INDEX 1.
  DATA(ls_refstep_data) = me->mo_run_environment->get_step_data( iv_step_number = ls_ref_step ).
  IF ls_refstep_data-document_id IS INITIAL.
    me->mo_run_environment->append_log( iv_log_statement = |No Reference Document ID available!| ).
    RETURN.
  ENDIF.

  ls_message-invoice-supplier_invoice_id = ls_refstep_data-document_id[ 1 ]-vbeln.

  "Call FM EDI_SD_INVC_PRE_PROCESSING which is called from AIF for EDI Invoice Message processing
  CALL FUNCTION 'EDI_SD_INVC_PRE_PROCESSING'
    EXPORTING
      finf       = lt_finf
    TABLES
      return_tab = lt_return_tab
    CHANGING
      raw_struct = ls_message
    EXCEPTIONS
      cancel     = 1
      OTHERS     = 2.
  IF sy-subrc <> 0.
    me->mo_run_environment->append_log( iv_log_statement = |Error during FM processing| ).
    RETURN.
  ELSE.
    rs_invoice = ls_message-invoice.
  ENDIF.

ENDMETHOD.


  METHOD internal_check.

    DATA: lv_prestepnumber   TYPE LINE OF cl_ptf_util=>gt_ptf_step-reference_step,
          ls_check_step_data TYPE cl_ptf_util=>gt_ptf_step,
          lv_vbeln           TYPE vbeln,
          error_message      TYPE bapi_msg,
          ls_return          TYPE bapiret2,
          lv_error_occured   TYPE abap_bool VALUE abap_false,
          ls_vbeln           TYPE LINE OF cl_ptf_util=>ty_vbeln_tab,
          var_step           TYPE string.

    DATA: ls_vbrk_i TYPE vbrk,
          ls_vbrk_e TYPE vbrk,
          lt_xvbrk  TYPE TABLE OF vbrkvb,
          lt_xvbrp  TYPE TABLE OF vbrpvb,
          lt_xkomv  TYPE TABLE OF komv,
          lt_xvbpa  TYPE TABLE OF vbpavb.

    CLEAR: lv_prestepnumber, ls_check_step_data.

    ev_check_status = abap_false.
    var_step = iv_step_number.

    IF ls_testdata-vbrk_check IS INITIAL AND ls_testdata-vbrp_check IS INITIAL.
      me->mo_run_environment->append_log( |No checks defined in TDC variant. Only generic checks are performed.| ).
    ELSE.

*     Check if reference step number for checking object is filled and reference object exists
      LOOP AT step_data-reference_step INTO lv_prestepnumber.
        ls_check_step_data = me->mo_run_environment->get_step_data( iv_step_number = lv_prestepnumber ).
        IF ls_check_step_data-document_id IS INITIAL.
          lv_error_occured = abap_true.
          me->mo_run_environment->append_log( iv_log_statement = 'No reference document exists!' ).
        ELSE.

          IF ls_testdata-vbrk_check IS NOT INITIAL.
            cl_ptf_compare_bd_tdc=>compare_vbrk_data(
              EXPORTING
                is_testdata        = ls_testdata
                is_check_step_data = ls_check_step_data
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
                is_check_step_data = ls_check_step_data
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

      IF lt_vbeln IS NOT INITIAL.
        IF lv_error_occured EQ abap_false.
          me->mo_run_environment->append_log( |Checks from TDCV { step_data-variant } were successful.| ).
        ELSE.
          me->mo_run_environment->append_log( |Not all checks from TDCV { step_data-variant } were passed.| ).
        ENDIF.
      ENDIF.

    ENDIF.



*   General check - always performed, whether there were TDC based checks before or not
*   L O O P

    LOOP AT lt_vbeln INTO ls_vbeln.
      ls_vbrk_i-vbeln = ls_vbeln-vbeln.

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
          error_message        = 2
          OTHERS               = 3.
      IF sy-subrc EQ 2.
        lv_error_occured = abap_true.
        me->mo_run_environment->append_log( iv_log_statement = |VBELN { ls_vbrk_i-vbeln } : Error occured in FM RV_INVOICE_DOCUMENT_READ| ).
        CONTINUE.
      ENDIF.

      READ TABLE lt_xvbrk INTO DATA(ls_vbrk) INDEX 1.
      READ TABLE lt_xvbrp INTO DATA(ls_vbrp_1) INDEX 1.


      IF ls_vbrk-rfbsk = 'C'.
        IF ls_vbrk-belnr IS INITIAL.
          CLEAR ls_return.
          CONCATENATE 'Bil. Doc.'  ls_vbeln-vbeln  'transferred to FIN but FI DocumentNumber is initial in VBRK.'
          INTO ls_return-message SEPARATED BY space.
          me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
          ev_check_status = abap_false.
        ENDIF.
      ENDIF.
*     Check Output
      SELECT SINGLE * FROM apoc_d_or_root INTO @DATA(ls_root) WHERE appl_object_id = @ls_vbeln-vbeln.
      IF sy-subrc NE 0.
        CLEAR ls_return.
        CONCATENATE 'No output entry in apoc_d_or_root for Bil. Doc.:'
       ls_vbeln-vbeln 'was found' INTO ls_return-message SEPARATED BY space.
        me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
        lv_error_occured = abap_true.
      ENDIF.
      SELECT * FROM apoc_d_or_item INTO TABLE @DATA(lt_apoc_or_item) WHERE appl_object_id = @ls_vbeln-vbeln.
      IF sy-subrc NE 0.
        CLEAR ls_return.
        CONCATENATE 'No output entry in apoc_d_or_item for Bil. Doc.'
        ls_vbeln-vbeln 'was found' INTO ls_return-message SEPARATED BY space.
        me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
        lv_error_occured = abap_true.
      ENDIF.
      IF ls_vbrk-rfbsk = 'C'.
        LOOP AT lt_apoc_or_item INTO DATA(ls_apoc_or_item).
          IF ls_apoc_or_item-status EQ 1.
            CLEAR ls_return.
            CONCATENATE 'Output Item is in status "In Preparation" for Bil.Doc.:'
            ls_vbeln-vbeln INTO ls_return-message SEPARATED BY space.
            me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
            lv_error_occured = abap_true.
          ENDIF.
        ENDLOOP.
      ENDIF.

*     Check copy condition
      SELECT SINGLE auart FROM vbak INTO @DATA(lv_auart) WHERE vbeln = @ls_vbrp_1-aubel.

      SELECT SINGLE ordnr_fi, xblnr_fi FROM tvcpf INTO @DATA(ls_tvcpf)
              WHERE auarv = @lv_auart AND fkarn = @ls_vbrk-fkart AND pstyv = @space.
      IF sy-subrc EQ 0.
        CASE ls_tvcpf-ordnr_fi.
          WHEN space.
            IF ls_vbrk-zuonr IS NOT INITIAL.
              "Read VGBEL from items, but only if there is the same VGBEL in all item
              LOOP AT lt_xvbrp INTO DATA(ls_item).
                DATA lv_vgbel TYPE vbeln.
                DATA lv_vgtyp TYPE vbtypl.
                IF ls_item-vgbel IS NOT INITIAL.
                  IF ls_item-vgbel NE lv_vgbel.
                    IF lv_vgbel IS INITIAL.
                      lv_vgbel = ls_item-vgbel.
                      lv_vgtyp = ls_item-vgtyp.
                    ELSE.
                      CLEAR lv_vgbel.
                      me->mo_run_environment->append_log( |Multiple preceding documents for { ls_vbeln-vbeln }, stopping ZUONR check.| ).
                      EXIT.
                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDLOOP.
              IF lv_vgbel IS NOT INITIAL.
                ASSERT lv_vgtyp IS NOT INITIAL.
                IF cl_sd_doc_category_util=>is_any_invoice( lv_vgtyp ) OR cl_sd_doc_category_util=>is_any_billing_doc_request( lv_vgtyp ) OR cl_sd_doc_category_util=>is_any_sales( lv_vgtyp ).
                  IF cl_sd_doc_category_util=>is_any_invoice( lv_vgtyp ) OR cl_sd_doc_category_util=>is_any_billing_doc_request( lv_vgtyp ).
                    SELECT SINGLE zuonr FROM vbrk INTO @DATA(lv_zuonr_of_preceding_doc) WHERE vbeln = @lv_vgbel.
                    ASSERT sy-subrc IS INITIAL.
                  ELSEIF  cl_sd_doc_category_util=>is_any_sales( lv_vgtyp ).
                    SELECT SINGLE zuonr FROM vbak INTO @lv_zuonr_of_preceding_doc WHERE vbeln = @lv_vgbel.
                    ASSERT sy-subrc IS INITIAL.
                  ENDIF.

                  IF lv_zuonr_of_preceding_doc EQ ls_vbrk-zuonr.
                    "ok, ZUONR was taken over from preceding document, which is std behavior (actually not only for tvcpf-ordnr_fi EQ space but always)
                    CHECK 1 = 1.
                  ELSEIF lv_zuonr_of_preceding_doc IS INITIAL.
*                    me->mo_run_environment->append_log( | BD { ls_vbeln-vbeln }: Value of ZUONR { ls_vbrk-zuonr } is unexpected. Ex. is space (as ZUONR of prec. doc is also space).| ).
                    CLEAR ls_return.
                    CONCATENATE ' BD:' ls_vbeln-vbeln
                    'Value of ZUONR' ls_vbrk-zuonr 'is unexpected. Exp. is space (as ZUONR of prec. doc is also space).'
                     INTO ls_return-message SEPARATED BY space.
                    me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
                    lv_error_occured = abap_true.
                  ELSEIF lv_zuonr_of_preceding_doc NE ls_vbrk-zuonr.
                    me->mo_run_environment->append_log( | BD { ls_vbeln-vbeln }: Value of ZUONR { ls_vbrk-zuonr } is unexpected. Exp. is: { lv_zuonr_of_preceding_doc } from prec. doc { lv_vgbel }.| ).
                    lv_error_occured = abap_true.
                  ENDIF.
                ENDIF. "only check currently when VGTYP is a sales doc or a vbrk doc
              ELSE.
                "could not find exactly one vgbel, for this here no check has been implemented
              ENDIF.
            ENDIF. "ZUONR filled but tvcpf-ordnr_fi EQ space

          WHEN 'E'.   " 'Actual Billing Document Number'
            IF ls_vbrk-zuonr NE ls_vbeln-vbeln.
              CLEAR ls_return.
              CONCATENATE ' Billing Document:' ls_vbeln-vbeln
              'Value of ZUONR (ORDNR_FI = E)' ls_vbrk-zuonr 'is unexpected. Expected is' ls_vbeln-vbeln
               INTO ls_return-message SEPARATED BY space.
              me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
              lv_error_occured = abap_true.
            ENDIF.
        ENDCASE.

        CASE ls_tvcpf-xblnr_fi.
          WHEN space.
            IF ls_vbrk-sfakn IS INITIAL.
              IF ls_vbrk-xblnr NE ls_vbeln-vbeln.

                DATA: lv_xblnr_error TYPE abap_bool.
                lv_xblnr_error = abap_false.
                CASE ls_vbrk-fktyp.
                  WHEN 'A'. "Order related so look up reference document in the referenced document
                    SELECT SINGLE * FROM vbak WHERE vbeln = @ls_vbrp_1-aubel INTO @DATA(ls_vbak).
                    IF ls_vbak-vgbel <> ls_vbrk-xblnr.
                      lv_xblnr_error = abap_true.
                    ENDIF.
                  WHEN OTHERS.     "?sufficient to consider only 'A'?
                    lv_xblnr_error = abap_true.
                ENDCASE.

                IF lv_xblnr_error EQ abap_true.
                  CLEAR ls_return.
                  CONCATENATE ' Billing Document:' ls_vbeln-vbeln
                  'Value of XBLNR' ls_vbrk-xblnr 'is unexpected. Expected is' ls_vbeln-vbeln
                   INTO ls_return-message SEPARATED BY space.
                  me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
                  lv_error_occured = abap_true.
                ENDIF.

              ENDIF.
            ELSE.
              IF ls_vbrk-xblnr NE ls_vbrk-sfakn.
                CLEAR ls_return.
                CONCATENATE ' BilDoc:' ls_vbeln-vbeln
                'Value of XBLNR' ls_vbrk-xblnr 'is unexpected. Expected is' ls_vbrk-sfakn
                 INTO ls_return-message SEPARATED BY space.
                me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
                lv_error_occured = abap_true.
              ENDIF.
            ENDIF.
          WHEN 'A'.  " 'Customer Reference'
            IF ls_vbrk-bstnk_vf EQ space AND ls_vbrk-xblnr NE ls_vbeln-vbeln.
              CLEAR ls_return.
              CONCATENATE ' Billing Document:' ls_vbeln-vbeln
              'Value of XBLNR' ls_vbrk-xblnr 'is unexpected. Expected is' ls_vbeln-vbeln
               INTO ls_return-message SEPARATED BY space.
              me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
              lv_error_occured = abap_true.
            ELSEIF ls_vbrk-bstnk_vf NE space AND ls_vbrk-xblnr NE ls_vbrk-bstnk_vf(16). "BSTNK_VF is char35,  XBLNR is char16
              CLEAR ls_return.
              CONCATENATE ' Billing Document:' ls_vbeln-vbeln
              'Value of BSTNK_VF' ls_vbrk-bstnk_vf 'is unexpected. Expected is' ls_vbrk-xblnr
               INTO ls_return-message SEPARATED BY space.
              me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
              lv_error_occured = abap_true.
            ENDIF.
        ENDCASE.
      ENDIF.

      "General KIDNO Checks: In default this field should be null; Other cases are country dependent
      IF ls_vbrk-vbtyp EQ if_sd_doc_category=>invoice_cancel.
        SELECT SINGLE kidno FROM vbrk WHERE vbeln = @ls_vbrk-sfakn INTO @DATA(kidno_bd).

        IF ls_vbrk-kidno NE kidno_bd.
          me->mo_run_environment->append_log( iv_log_statement = |KIDNO not as expected.| ).
          me->mo_run_environment->append_log( iv_log_statement = |Expected: { kidno_bd }| ).
          me->mo_run_environment->append_log( iv_log_statement = |Actual: { ls_vbrk-kidno }| ).
          lv_error_occured = abap_false.
        ENDIF.

      ENDIF.

*     Check pricing exists
      IF lt_xkomv IS INITIAL.
        CLEAR ls_return.
        CONCATENATE ' Billing Document:' ls_vbeln-vbeln 'xkomv is initial' INTO ls_return-message SEPARATED BY space.
        me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
        lv_error_occured = abap_true.
      ENDIF.
      IF lt_xvbpa IS INITIAL.
        CLEAR ls_return.
        CONCATENATE ' Billing Document:' ls_vbeln-vbeln 'xvbpa is initial' INTO ls_return-message SEPARATED BY space.
        me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
        lv_error_occured = abap_true.
      ENDIF.

      APPEND ls_vbeln TO ev_document_id.

      CLEAR: lt_xkomv, lt_xvbpa, lt_xvbrk, lt_xvbrp, ls_tvcpf, lv_auart, ls_vbrp_1, ls_vbrk, ls_vbrk_i, ls_vbrk_e.

    ENDLOOP.


    ev_execution_status = abap_true.

    IF lv_error_occured EQ abap_false AND lt_vbeln IS NOT INITIAL.
*     Output in case of success
      ev_check_status = abap_true.
      CONCATENATE 'General check was successful. Process step:' var_step INTO error_message SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = |{ error_message }| ).
    ELSE.
      ev_check_status = abap_false.
      CONCATENATE 'General check failed. Process step:' var_step INTO error_message SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = |{ error_message }| ).
    ENDIF.

  ENDMETHOD.


  METHOD internal_check_v2.
    DATA: lv_prestepnumber   TYPE LINE OF cl_ptf_util=>gt_ptf_step-reference_step,
          ls_check_step_data TYPE cl_ptf_util=>gt_ptf_step,
          lv_vbeln           TYPE vbeln,
          error_message      TYPE bapi_msg,
          ls_return          TYPE bapiret2,
          lv_error_occured   TYPE abap_bool VALUE abap_false,
          ls_vbeln           TYPE LINE OF cl_ptf_util=>ty_vbeln_tab,
          var_step           TYPE string.

    DATA: ls_vbrk_i TYPE vbrk,
          ls_vbrk_e TYPE vbrk,
          lt_xvbrk  TYPE TABLE OF vbrkvb,
          lt_xvbrp  TYPE TABLE OF vbrpvb,
          lt_xkomv  TYPE TABLE OF komv,
          lt_xvbpa  TYPE TABLE OF vbpavb.

    ev_check_status = abap_false.

*  CLEAR: lv_prestepnumber, ls_check_step_data.
*  IF ls_testdata-vbrk_check IS NOT INITIAL OR ls_testdata-vbrp_check IS NOT INITIAL.
**  Check if reference step number for checking object is filled and reference object exists
*    LOOP AT ls_step_data-reference_step INTO lv_prestepnumber.
*      ls_check_step_data = me->mo_run_environment->get_step_data( iv_step_number = lv_prestepnumber ).
*      IF ls_check_step_data-document_id IS INITIAL.
*        lv_error_occured = abap_true.
*        me->mo_run_environment->append_log( iv_log_statement = 'No reference document exists!' ).
*      ELSE.
*
*      ENDIF.
*    ENDLOOP.
*  ENDIF.

    LOOP AT lt_vbeln INTO ls_vbeln.
      APPEND ls_vbeln TO ls_check_step_data-document_id.
      IF ls_testdata-vbrk_check IS NOT INITIAL.
        cl_ptf_compare_bd_tdc=>compare_vbrk_data(
          EXPORTING
            is_testdata        = ls_testdata
            is_check_step_data = ls_check_step_data
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
            is_check_step_data = ls_check_step_data
            iv_run_environment = me->mo_run_environment
          RECEIVING
            rv_is_equal        = ev_check_status
        ).
        IF ev_check_status EQ abap_false.
          lv_error_occured = abap_true.
        ENDIF.
      ENDIF.

      ls_vbrk_i-vbeln = ls_vbeln-vbeln.

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

      READ TABLE lt_xvbrk INTO DATA(ls_vbrk) INDEX 1.
      READ TABLE lt_xvbrp INTO DATA(ls_vbrp_1) INDEX 1.

* Check Output
      IF ls_vbrk-rfbsk = 'C'.
        IF ls_vbrk-belnr IS INITIAL.
          CLEAR ls_return.
          CONCATENATE 'Bil. Doc.'  ls_vbeln-vbeln  'transferred to FIN but FI DocumentNumber is initial in VBRK.'
          INTO ls_return-message SEPARATED BY space.
          me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
          ev_check_status = abap_false.
        ENDIF.
      ENDIF.
      SELECT SINGLE * FROM apoc_d_or_root INTO @DATA(ls_root) WHERE appl_object_id = @ls_vbeln-vbeln.
      IF sy-subrc NE 0.
        CLEAR ls_return.
        CONCATENATE 'No output entry in apoc_d_or_root for Bil. Doc.:'
       ls_vbeln-vbeln 'was found' INTO ls_return-message SEPARATED BY space.
        me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
        lv_error_occured = abap_true.
      ENDIF.
      SELECT * FROM apoc_d_or_item INTO TABLE @DATA(lt_item) WHERE appl_object_id = @ls_vbeln-vbeln.
      IF sy-subrc NE 0.
        CLEAR ls_return.
        CONCATENATE 'No output entry in apoc_d_or_item for Bil. Doc.'
        ls_vbeln-vbeln 'was found' INTO ls_return-message SEPARATED BY space.
        me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
        lv_error_occured = abap_true.
      ENDIF.
      IF ls_vbrk-rfbsk = 'C'.
        LOOP AT lt_item INTO DATA(ls_item).
          IF ls_item-status EQ 1.
            CLEAR ls_return.
            CONCATENATE 'No output entry in apoc_d_or_item for Bil. Doc.:'
            ls_vbeln-vbeln 'was found' INTO ls_return-message SEPARATED BY space.
            me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
            lv_error_occured = abap_true.
          ENDIF.
        ENDLOOP.
      ENDIF.

*    check copy condition
      SELECT SINGLE auart FROM vbak INTO @DATA(lv_auart) WHERE vbeln = @ls_vbrp_1-aubel.

      SELECT SINGLE ordnr_fi, xblnr_fi FROM tvcpf INTO @DATA(ls_tvcpf)
              WHERE auarv = @lv_auart AND fkarn = @ls_vbrk-fkart AND pstyv = @space.
      IF sy-subrc EQ 0.
        CASE ls_tvcpf-ordnr_fi.
          WHEN space.
            IF ls_vbrk-zuonr IS NOT INITIAL.
              CLEAR ls_return.
              CONCATENATE ' Billing Document:' ls_vbeln-vbeln
              'Value of ZUONR'  ls_vbrk-zuonr 'is unexpected. Expected is space.'
               INTO ls_return-message SEPARATED BY space.
              me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
              lv_error_occured = abap_true.
            ENDIF.
          WHEN 'E'.
            IF ls_vbrk-zuonr NE ls_vbeln-vbeln.
              CLEAR ls_return.
              CONCATENATE ' Billing Document:' ls_vbeln-vbeln
              'Value of ZUONR'  ls_vbrk-zuonr 'is unexpected. Expected is' ls_vbeln-vbeln
               INTO ls_return-message SEPARATED BY space.
              me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
              lv_error_occured = abap_true.
            ENDIF.
        ENDCASE.

        CASE ls_tvcpf-xblnr_fi.
          WHEN space.
            IF ls_vbrk-sfakn IS INITIAL.
              IF ls_vbrk-xblnr NE ls_vbeln-vbeln.

                DATA: lv_xblnr_error TYPE abap_bool.
                lv_xblnr_error = abap_false.
                CASE ls_vbrk-fktyp.
                  WHEN 'A'. "Order related so look up reference document in the referenced document
                    SELECT SINGLE * FROM vbak WHERE vbeln = @ls_vbrp_1-aubel INTO @DATA(ls_vbak).
                    IF ls_vbak-vgbel <> ls_vbrk-xblnr.
                      lv_xblnr_error = abap_true.
                    ENDIF.
                  WHEN OTHERS.
                    lv_xblnr_error = abap_true.
                ENDCASE.

                IF lv_xblnr_error EQ abap_true.
                  CLEAR ls_return.
                  CONCATENATE ' Billing Document:' ls_vbeln-vbeln
                  'Value of XBLNR' ls_vbrk-xblnr 'is unexpected. Expected is' ls_vbeln-vbeln
                   INTO ls_return-message SEPARATED BY space.
                  me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
                  lv_error_occured = abap_true.
                ENDIF.

              ENDIF.
            ELSE.
              IF ls_vbrk-xblnr NE ls_vbrk-sfakn.
                CLEAR ls_return.
                CONCATENATE ' Billing Document:' ls_vbeln-vbeln
                'Value of XBLNR' ls_vbrk-xblnr 'is unexpected. Expected is' ls_vbrk-sfakn
                 INTO ls_return-message SEPARATED BY space.
                me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
                lv_error_occured = abap_true.
              ENDIF.
            ENDIF.
          WHEN 'A'.
            IF ls_vbrk-bstnk_vf EQ space AND ls_vbrk-xblnr NE ls_vbeln-vbeln.
              CLEAR ls_return.
              CONCATENATE ' Billing Document:' ls_vbeln-vbeln
              'Value of XBLNR' ls_vbeln-vbeln 'is unexpected. Expected is' ls_vbrk-xblnr
               INTO ls_return-message SEPARATED BY space.
              me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
              lv_error_occured = abap_true.
            ELSEIF ls_vbrk-bstnk_vf NE space AND ls_vbrk-xblnr NE ls_vbrk-bstnk_vf.
              CLEAR ls_return.
              CONCATENATE ' Billing Document:' ls_vbeln-vbeln
              'Value of XBLNR' ls_vbrk-bstnk_vf 'is unexpected. Expected is' ls_vbrk-xblnr
               INTO ls_return-message SEPARATED BY space.
              me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
              lv_error_occured = abap_true.
            ENDIF.
        ENDCASE.
        IF ls_vbrk-vbtyp  EQ if_sd_doc_category=>credit_memo OR ls_vbrk-vbtyp  EQ if_sd_doc_category=>pre_billing_document.
          IF  ls_vbrk-kidno NE space.
            CLEAR ls_return.
            CONCATENATE ' Billing Document:' ls_vbeln-vbeln
            'Value of KIDNO' ls_vbrk-kidno 'is unexpected. Expected is SPACE'
             INTO ls_return-message SEPARATED BY space.
            me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
            lv_error_occured = abap_true.
          ENDIF.
        ELSE.
          IF ls_vbrk-vbtyp <> if_sd_doc_category=>invoice_cancel. "Only check if its not an invoice cancel document
            IF ls_vbrk-kidno NE ls_vbeln-vbeln.
              CLEAR ls_return.
              CONCATENATE ' Billing Document:' ls_vbeln-vbeln
              'Value of KIDNO' ls_vbrk-kidno 'is unexpected. Expected is' ls_vbeln-vbeln
               INTO ls_return-message SEPARATED BY space.
              me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
              lv_error_occured = abap_true.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
* check pricing exists
      IF lt_xkomv IS INITIAL.
        CLEAR ls_return.
        CONCATENATE ' Billing Document:' ls_vbeln-vbeln 'xkomv is initial' INTO ls_return-message SEPARATED BY space.
        me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
        lv_error_occured = abap_true.
      ENDIF.
      IF lt_xvbpa IS INITIAL.
        CLEAR ls_return.
        CONCATENATE ' Billing Document:' ls_vbeln-vbeln 'xvbpa is initial' INTO ls_return-message SEPARATED BY space.
        me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
        lv_error_occured = abap_true.
      ENDIF.

      APPEND ls_vbeln TO ev_document_id.

      CLEAR: lt_xkomv, lt_xvbpa, lt_xvbrk, lt_xvbrp, ls_tvcpf, lv_auart, ls_vbrp_1, ls_vbrk, ls_vbrk_i, ls_vbrk_e.

    ENDLOOP.

    ev_execution_status = abap_true.
** Output in case of success
    IF lv_error_occured EQ abap_false AND lt_vbeln IS NOT INITIAL.
      ev_check_status = abap_true.
      CONCATENATE 'General check was successful. Process step:' var_step INTO error_message SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = |{ error_message }| ).
    ELSE.
      ev_check_status = abap_false.
      CONCATENATE 'General check failed. Process step:' var_step INTO error_message SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = |{ error_message }| ).
    ENDIF.

  ENDMETHOD.


  METHOD internal_update.

    DATA lc_vbeln TYPE vbeln VALUE '0090000040'.
    DATA lv_after TYPE vsbed.

    SELECT SINGLE vsbed FROM vbrk INTO @DATA(lv_before) WHERE vbeln = @lc_vbeln.
    IF sy-subrc IS INITIAL.
      IF lv_before EQ '04'.
        lv_after = '03'.
      ELSE.
        lv_after = '04'.
      ENDIF.
      UPDATE vbrk SET vsbed = lv_after WHERE vbeln = lc_vbeln.
    ENDIF.

    COMMIT WORK AND WAIT.

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
      SELECT SINGLE vbeln, gbstk, fksak, rfbsk, clrst, buchk FROM vbrk WHERE vbeln = @<lv_vbel>-vbeln INTO CORRESPONDING FIELDS OF @lv_vbrk.
      IF sy-subrc <> 0.
        "Document not found
        me->mo_run_environment->append_log( iv_log_statement = |Could not find document { <lv_vbel>-vbeln }.| ).
        ev_execution_status = abap_false.
      ELSE.
        me->mo_run_environment->append_log( iv_log_statement = |INVOICE-Number: { <lv_vbel>-vbeln }  /  GBSTK: { lv_vbrk-gbstk } | ).
        me->mo_run_environment->append_log( iv_log_statement = |INVOICE-Number: { <lv_vbel>-vbeln }  /  FKSAK: { lv_vbrk-fksak } | ).
        me->mo_run_environment->append_log( iv_log_statement = |INVOICE-Number: { <lv_vbel>-vbeln }  /  RFBSK: { lv_vbrk-rfbsk } | ).
        me->mo_run_environment->append_log( iv_log_statement = |INVOICE-Number: { <lv_vbel>-vbeln }  /  CLRST: { lv_vbrk-clrst } | ).
        me->mo_run_environment->append_log( iv_log_statement = |INVOICE-Number: { <lv_vbel>-vbeln }  /  BUCHK: { lv_vbrk-buchk } | ).
        ev_check_status = abap_true.
      ENDIF.
      CLEAR lv_vbrk.
      SELECT vbeln, posnr, gbstk_ana, fksaa FROM vbrp WHERE vbeln = @<lv_vbel>-vbeln INTO CORRESPONDING FIELDS OF TABLE @lt_vbrp.
      IF sy-subrc <> 0.
        "No items
        me->mo_run_environment->append_log( iv_log_statement = |Could not find items for document { <lv_vbel>-vbeln }.| ).
      ELSE.
        LOOP AT lt_vbrp ASSIGNING FIELD-SYMBOL(<lv_vbrp>).
          me->mo_run_environment->append_log( iv_log_statement = |INVOICE-Number: { <lv_vbrp>-vbeln }  / Item-Number: { <lv_vbrp>-posnr } / fksaa: { <lv_vbrp>-fksaa } | ).
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


  METHOD odata_get_bd.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/SAP/SD_CUSTOMER_INVOICES_MANAGE/'.
    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    DATA: lv_status_text TYPE string,
          lv_status_code TYPE integer.
    DATA: lt_messages TYPE sdbil_ebdr_request_msg_t.
    DATA lt_parameters TYPE /iwfnd/sutil_property_t.

    DATA: ls_return     TYPE bapiret2.
    DATA: lv_msg             TYPE string,
          lv_status_code_txt TYPE string.
    TYPES: BEGIN OF ty_result,
             billingdocument              TYPE string,
             billingdocumentitem          TYPE string,
             material                     TYPE string,
             billingdocumentitemtext      TYPE string,
             billingquantity              TYPE string,
             billingquantityunit          TYPE string,
             itemnetamountofbillingdoc    TYPE string,
             itemgrossamountofbillingdoc  TYPE string,
             transactioncurrency          TYPE string,
             referencesddocumentcategory  TYPE string,
             referencesddocument          TYPE string,
             referencesddocumentitem      TYPE string,
             salesdocumentitemcategory    TYPE string,
             salesdocument                TYPE string,
             salesdocumentitem            TYPE string,
             plant                        TYPE string,
             division                     TYPE string,
             storagelocation              TYPE string,
             productconfiguration         TYPE string,
             pricingdate                  TYPE string,
             statisticalvaluecontrol      TYPE string,
             materialgroup                TYPE string,
             materialgroup_text           TYPE string,
             servicesrendereddate         TYPE string,
             businessarea                 TYPE string,
             businessarea_text            TYPE string,
             wbselement                   TYPE string,
             wbselementlangbsddescription TYPE string,
             matlaccountassignmentgroup   TYPE string,
             departurecountry             TYPE string,
             taxjurisdiction              TYPE string,
             producttaxclassification1    TYPE string,
             producttaxclassification2    TYPE string,
             producttaxclassification3    TYPE string,
             producttaxclassification4    TYPE string,
             producttaxclassification5    TYPE string,
             producttaxclassification6    TYPE string,
             producttaxclassification7    TYPE string,
             producttaxclassification8    TYPE string,
             producttaxclassification9    TYPE string,
             billtopartycountry           TYPE string,
             billtopartyregion            TYPE string,
             organizationdivision         TYPE string,
           END OF ty_result.

    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              results TYPE STANDARD TABLE OF ty_result,
            END OF d,
          END OF ls_response_function.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
      DATA(ls_ref_step) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
      IF ls_ref_step IS NOT INITIAL.
        LOOP AT ls_ref_step-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).
          lt_parameters = VALUE #(
            ( name = 'BillingDocument'          value =  <ls_docid> )
            "( name = 'BillingDocumentItem'      value =  ''         )
          ).
          lo_odata_caller->call_service(
            EXPORTING
              iv_action_or_entity = 'C_BillingDocument_F0797'
              iv_association      = 'to_Item'
              it_parameters       = lt_parameters
            IMPORTING
              ev_status_code      = lv_status_code
              ev_status_text      = lv_status_text
              es_json_response    = ls_response_function
          ).
          lv_status_code_txt = lv_status_code.
          CONCATENATE 'Executed API Call' 'C_BillingDocumentItem_F0797' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
          me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
          IF lv_status_code = 200.
            ev_execution_status = abap_true.
            ev_check_status = abap_true.
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
      CONCATENATE 'Did not execute API Call' 'C_BillingDocumentItem_F0797' INTO lv_msg SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD odata_get_bd_item.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/SAP/SD_CUSTOMER_INVOICES_MANAGE/'.
    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    DATA: lv_status_text TYPE string,
          lv_status_code TYPE integer.
    DATA: lt_messages TYPE sdbil_ebdr_request_msg_t.
    DATA lt_parameters TYPE /iwfnd/sutil_property_t.

    DATA: ls_return     TYPE bapiret2.
    DATA: lv_msg             TYPE string,
          lv_status_code_txt TYPE string.
    TYPES: BEGIN OF ty_result,
             billingdocument              TYPE string,
             billingdocumentitem          TYPE string,
             material                     TYPE string,
             billingdocumentitemtext      TYPE string,
             billingquantity              TYPE string,
             billingquantityunit          TYPE string,
             itemnetamountofbillingdoc    TYPE string,
             itemgrossamountofbillingdoc  TYPE string,
             transactioncurrency          TYPE string,
             referencesddocumentcategory  TYPE string,
             referencesddocument          TYPE string,
             referencesddocumentitem      TYPE string,
             salesdocumentitemcategory    TYPE string,
             salesdocument                TYPE string,
             salesdocumentitem            TYPE string,
             plant                        TYPE string,
             division                     TYPE string,
             storagelocation              TYPE string,
             productconfiguration         TYPE string,
             pricingdate                  TYPE string,
             statisticalvaluecontrol      TYPE string,
             materialgroup                TYPE string,
             materialgroup_text           TYPE string,
             servicesrendereddate         TYPE string,
             businessarea                 TYPE string,
             businessarea_text            TYPE string,
             wbselement                   TYPE string,
             wbselementlangbsddescription TYPE string,
             matlaccountassignmentgroup   TYPE string,
             departurecountry             TYPE string,
             taxjurisdiction              TYPE string,
             producttaxclassification1    TYPE string,
             producttaxclassification2    TYPE string,
             producttaxclassification3    TYPE string,
             producttaxclassification4    TYPE string,
             producttaxclassification5    TYPE string,
             producttaxclassification6    TYPE string,
             producttaxclassification7    TYPE string,
             producttaxclassification8    TYPE string,
             producttaxclassification9    TYPE string,
             billtopartycountry           TYPE string,
             billtopartyregion            TYPE string,
             organizationdivision         TYPE string,
           END OF ty_result.

    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              results TYPE STANDARD TABLE OF ty_result,
            END OF d,
          END OF ls_response_function.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
      DATA(ls_ref_step) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
      IF ls_ref_step IS NOT INITIAL.
        LOOP AT ls_ref_step-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).
          lt_parameters = VALUE #(
            ( name = 'BillingDocument'          value =  <ls_docid> )
            "( name = 'BillingDocumentItem'      value =  ''         )
          ).
          lo_odata_caller->call_service(
            EXPORTING
              iv_action_or_entity = 'C_BillingDocument_F0797'
              iv_association      = 'to_Item'
              it_parameters       = lt_parameters
            IMPORTING
              ev_status_code      = lv_status_code
              ev_status_text      = lv_status_text
              es_json_response    = ls_response_function
          ).
          lv_status_code_txt = lv_status_code.
          CONCATENATE 'Executed API Call' 'C_BillingDocumentItem_F0797' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
          me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
          IF lv_status_code = 200.
            ev_execution_status = abap_true.
            ev_check_status = abap_true.
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
      CONCATENATE 'Did not execute API Call' 'C_BillingDocumentItem_F0797' INTO lv_msg SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD odata_get_bd_list_item.
    TYPES:BEGIN OF ty_result,
            billingdocumentcategory      TYPE string,
            billingdocumenttype          TYPE string,
            billingdocumentdate          TYPE string,
            salesorganization            TYPE string,
            soldtoparty                  TYPE string,
            destinationcountry           TYPE string,
            referencesddocument          TYPE string,
            referencesddocumentcategory  TYPE string,
            headerbillingblockreason     TYPE string,
            distributionchannel          TYPE string,
            division                     TYPE string,
            shippingpoint                TYPE string,
            shippingpoint_text           TYPE string,
            overallproofofdeliverystatus TYPE string,
            netamount                    TYPE string,
            transactioncurrency          TYPE string,
            soldtopartyaddressid         TYPE string,
            soldtopartycityname          TYPE string,
            soldtopartyname              TYPE string,
            soldtopartyadditionalname    TYPE string,
            customerproject              TYPE string,
            haserror                     TYPE string,
            systemmessageidentification  TYPE string,
            systemmessagenumber          TYPE string,
            systemmessagetype            TYPE string,
            systemmessagevariable1       TYPE string,
            systemmessagevariable2       TYPE string,
            systemmessagevariable3       TYPE string,
            systemmessagevariable4       TYPE string,
            systemmessagetext            TYPE string,
            billgdocreqreflgclsyst       TYPE string,
            billingdocrequestreference   TYPE string,
            referencesddocumenttype      TYPE string,
          END OF ty_result.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/SAP/SD_CUSTOMER_INVOICES_CREATE/'.
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
              results TYPE STANDARD TABLE OF ty_result,
            END OF d,
          END OF ls_response_function.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
      DATA(ls_refstep_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
      IF ls_refstep_data IS NOT INITIAL.
        ev_execution_status = abap_true.
        ev_check_status = abap_true.
        LOOP AT ls_refstep_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).

          lt_parameters = VALUE #(
            ( name = 'ReferenceSDDocument ' value =  <ls_docid>-vbeln )
          ).

          lo_odata_caller->call_service(
            EXPORTING
              iv_action_or_entity = 'C_BillingDueListItem_F0798'
              it_parameters = lt_parameters
              iv_filter_only = abap_true
            IMPORTING
              ev_status_code      = lv_status_code
              ev_status_text      = lv_status_text
              es_json_response    = ls_response_function
          ).
          lv_status_code_txt = lv_status_code.
          lv_msg = |Executed API Call C_BillingDueListItem_F0798 with ref doc { <ls_docid>-vbeln } and status code { lv_status_code }|.
          me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
          IF lv_status_code NE 200.
            me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
            ev_check_status = abap_false.
            ev_execution_status = abap_false.
          ENDIF.
          IF lines( ls_response_function-d-results ) EQ 0.
            me->mo_run_environment->append_log( iv_log_statement = |Could not find any billing due list item for { <ls_docid>-vbeln }.| ).
            ev_check_status = abap_false.
            ev_execution_status = abap_false.
          ENDIF.
        ENDLOOP.
      ELSE.
        me->mo_run_environment->append_log( iv_log_statement = |No documents created in reference step.| ).
        ev_check_status = abap_false.
        ev_execution_status = abap_false.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD odata_get_pdf.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/sap/API_BILLING_DOCUMENT_SRV/'.
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
              billingdocumentbinary TYPE string,
            END OF d,
          END OF ls_response_function.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
      DATA(ls_refstep_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
      IF ls_refstep_data IS NOT INITIAL.
        LOOP AT ls_refstep_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).
          lt_parameters = VALUE #(
            ( name = 'BillingDocument' value =  <ls_docid> )
          ).

          lo_odata_caller->call_service(
            EXPORTING
              iv_action_or_entity = 'GetPDF'
              it_parameters       = lt_parameters
              iv_function_import  = abap_true
            IMPORTING
              ev_status_code      = lv_status_code
              ev_status_text      = lv_status_text
              es_json_response    = ls_response_function
          ).
          lv_status_code_txt = lv_status_code.
          CONCATENATE 'Executed API Call' 'GetPDF' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
          me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
          IF lv_status_code = 200.
            ev_execution_status = abap_true.
            ev_check_status = abap_true.
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
      CONCATENATE 'Did not execute API Call' 'GetPDF' INTO lv_msg SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
      ev_execution_status = abap_false.
      ev_check_status = abap_false.
    ENDIF.
  ENDMETHOD.


  METHOD odata_get_pdf_neg_ne.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/sap/API_BILLING_DOCUMENT_SRV/'.
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
              billingdocumentbinary TYPE string,
            END OF d,
          END OF ls_response_function.

    lt_parameters = VALUE #(
    ( name = 'BillingDocument' value =  '00000000' )"This document # will never exist
  ).

    lo_odata_caller->call_service(
      EXPORTING
        iv_action_or_entity = 'GetPDF'
        it_parameters       = lt_parameters
        iv_function_import  = abap_true
      IMPORTING
        ev_status_code      = lv_status_code
        ev_status_text      = lv_status_text
        es_json_response    = ls_response_function
    ).
    lv_status_code_txt = lv_status_code.
    CONCATENATE 'Executed API Call' 'GetPDF' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
    me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
    IF lv_status_code = /iwbep/cx_mgw_busi_exception=>gcs_http_status_codes-not_found.
      ev_execution_status = abap_true.
      ev_check_status = abap_true.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |Calling GetPDF ODATA Service with BillingDocument 00000000: { lv_status_code } : { lv_status_text }.| ).
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
      EXIT.
    ENDIF.
  ENDMETHOD.


  METHOD odata_get_subsqnt_billdoc.
    TYPES:BEGIN OF ty_result,
            "subset of result fields
            billingdocument            TYPE string,
            billingdocumentitem        TYPE string,
            sddocumentcategory         TYPE string,
            subsequentdocument         TYPE string,
            subsequentdocumentcategory TYPE string,
            subsequentdocumentitem     TYPE string,
            netamount                  TYPE string,
            statisticscurrency         TYPE string,
          END OF ty_result.

    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/SAP/API_SUBSQNT_BILLG_DOC_SBI_SRV/'.
    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    DATA: lv_status_text TYPE string,
          lv_status_code TYPE integer.
    DATA: lt_messages TYPE sdbil_ebdr_request_msg_t.
    DATA: lt_parameters TYPE /iwfnd/sutil_property_t.
    DATA: ls_return     TYPE bapiret2.
    DATA: lv_msg             TYPE string,
          lv_status_code_txt TYPE string.


    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              results TYPE STANDARD TABLE OF ty_result,
            END OF d,
          END OF ls_response_function.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
      DATA(ls_refstep_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
      IF ls_refstep_data IS NOT INITIAL.
        ev_execution_status = abap_true.
        ev_check_status = abap_true.
        LOOP AT ls_refstep_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).
          lt_parameters = VALUE #(
            ( name = 'BillingDocument ' value =  <ls_docid>-vbeln )     "'0090010126' )
          ).

          lo_odata_caller->call_service(
            EXPORTING
              iv_action_or_entity = 'A_SubsqntBillgDocForSelfBillg'
              it_parameters  = lt_parameters
              iv_filter_only = abap_true
            IMPORTING
              ev_status_code      = lv_status_code
              ev_status_text      = lv_status_text
              es_json_response    = ls_response_function
          ).
          lv_status_code_txt = lv_status_code.
          lv_msg = |Executed API Call A_SubsqntBillgDocForSelfBillg for bil doc { <ls_docid>-vbeln } and status code { lv_status_code }|.
          me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
          IF lv_status_code NE 200.
            me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
            ev_check_status = abap_false.
            ev_execution_status = abap_false.
          ENDIF.
          IF lines( ls_response_function-d-results ) EQ 0.
            me->mo_run_environment->append_log( iv_log_statement = |Could not find any subsequent BillingDoc-like docs for { <ls_docid>-vbeln }.| ).
            ev_check_status = abap_false.
            ev_execution_status = abap_false.
          ENDIF.
          "Check each result record
          LOOP AT ls_response_function-d-results ASSIGNING FIELD-SYMBOL(<ls_vbfa>).
            me->mo_run_environment->append_log( iv_log_statement = |Checking result record, source: { <ls_vbfa>-billingdocument } { <ls_vbfa>-billingdocumentitem }  target:  { <ls_vbfa>-subsequentdocument } { <ls_vbfa>-subsequentdocumentitem }.| ).
            DATA lv_vbfa_bildoc_id_char10 TYPE vbeln_vf.
            lv_vbfa_bildoc_id_char10 = <ls_vbfa>-billingdocument.
            IF lv_vbfa_bildoc_id_char10 NE <ls_docid>-vbeln.
              me->mo_run_environment->append_log( iv_log_statement = |Unexpected BilDoc (VBELV) { <ls_vbfa>-billingdocument }.| ).
              ev_check_status = abap_false.
              ev_execution_status = abap_false.
            ENDIF.
          ENDLOOP.
        ENDLOOP. "one loop per one touched doc of one reference step

      ELSE.
        me->mo_run_environment->append_log( iv_log_statement = |No documents created in reference step.| ).
        ev_check_status = abap_false.
        ev_execution_status = abap_false.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD odata_post_activate_snapshot.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/SAP/SD_CUSTOMER_INVOICES_MANAGE/'.
    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    DATA lt_parameters TYPE /iwfnd/sutil_property_t.
    DATA: lv_status_text TYPE string,
          lv_status_code TYPE integer.
    DATA: ls_return     TYPE bapiret2.
    DATA: lv_msg             TYPE string,
          lv_status_code_txt TYPE string.

    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              results TYPE TABLE OF ty_def_functionimportresult,
            END OF d,
          END OF ls_response_function.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
      DATA(ls_refstep_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
      IF ls_refstep_data IS NOT INITIAL.
        LOOP AT ls_refstep_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).

          lt_parameters = VALUE #(
                      ( name = 'BillingDocument' value =  <ls_docid> )
                      ( name = 'BillingDocumentReleaseRequested' value =  '' )
                  ).
          lo_odata_caller->call_service(
            EXPORTING
              iv_method           = 'POST'
              iv_action_or_entity = 'ActivateSnapshot'
              it_parameters       = lt_parameters
            IMPORTING
              ev_status_code      = lv_status_code
              ev_status_text      = lv_status_text
              es_json_response    = ls_response_function
          ).
          lv_status_code_txt = lv_status_code.
          CONCATENATE 'Executed API Call' 'ActivateSnapshot' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
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
      CONCATENATE 'Did not execute API Call' 'ActivateSnapshot' INTO lv_msg SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD odata_post_bd_to_acc.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/SAP/SD_CUSTOMER_INVOICES_MANAGE/'.
    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    DATA lt_parameters TYPE /iwfnd/sutil_property_t.
    DATA: lv_status_text TYPE string,
          lv_status_code TYPE integer.
    DATA: ls_return     TYPE bapiret2.
    DATA: lv_msg             TYPE string,
          lv_status_code_txt TYPE string.
    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              results TYPE TABLE OF ty_def_functionimportresult,
            END OF d,
          END OF ls_response_function.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
      DATA(ls_refstep_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
      IF ls_refstep_data IS NOT INITIAL.
        LOOP AT ls_refstep_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).

          lt_parameters = VALUE #(
                      ( name = 'BillingDocument'    value =  <ls_docid> )
                      ( name = 'SDDocumentCategory' value =  '' )
                  ).
          lo_odata_caller->call_service(
            EXPORTING
              iv_method           = 'POST'
              iv_action_or_entity = 'PostBillingDocumentToAccounting'
              it_parameters       = lt_parameters
            IMPORTING
              ev_status_code      = lv_status_code
              ev_status_text      = lv_status_text
              es_json_response    = ls_response_function
          ).
          lv_status_code_txt = lv_status_code.
          CONCATENATE 'Executed API Call' 'PostBillingDocumentToAccounting' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
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
      CONCATENATE 'Did not execute API Call' 'PostBillingDocumentToAccounting' INTO lv_msg SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
    ENDIF.
  ENDMETHOD.


  METHOD odata_post_cancel_bd.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/sap/SD_CUSTOMER_INVOICES_MANAGE/'.
    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    DATA lt_parameters TYPE /iwfnd/sutil_property_t.
    DATA: lv_status_text TYPE string,
          lv_status_code TYPE integer.

    DATA: ls_return     TYPE bapiret2.
    DATA: lv_msg             TYPE string,
          lv_status_code_txt TYPE string.

    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              results TYPE TABLE OF ty_def_functionimportresult,
            END OF d,
          END OF ls_response_function.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
      DATA(ls_refstep_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
      IF ls_refstep_data IS NOT INITIAL.
        LOOP AT ls_refstep_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).
          SELECT SINGLE vbtyp FROM vbrk WHERE vbeln = @<ls_docid>-vbeln INTO @DATA(vbtyp).
          lt_parameters = VALUE #(
                      ( name = 'BillingDocument' value =  <ls_docid> )
                      ( name = 'SDDocumentCategory' value =  vbtyp )
                  ).
          lo_odata_caller->call_service(
            EXPORTING
              iv_method           = 'POST'
              iv_action_or_entity = 'CancelBillingDocument'
              it_parameters       = lt_parameters
            IMPORTING
              ev_status_code      = lv_status_code
              ev_status_text      = lv_status_text
              es_json_response    = ls_response_function
          ).
          lv_status_code_txt = lv_status_code.
          CONCATENATE 'Executed API Call' 'CancelBillingDocument' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
          me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
          IF lv_status_code = 200.
            ev_check_status = abap_true.
            ev_execution_status = abap_true.

            LOOP AT ls_response_function-d-results ASSIGNING FIELD-SYMBOL(<result>).
              DATA(like_argument) = |%{ <result>-billingdocument }|.
              SELECT SINGLE vbeln, fksto FROM vbrk WHERE vbeln LIKE @like_argument INTO @DATA(result).
              IF result IS NOT INITIAL.
                IF result-fksto EQ abap_false.
                  APPEND result-vbeln TO ev_document_id.
                ENDIF.
              ENDIF.
            ENDLOOP.
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
      CONCATENATE 'Did not execute API Call' 'CancelBillingDocument' INTO lv_msg SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
    ENDIF.
  ENDMETHOD.


  METHOD odata_post_compare_bd.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/SAP/SD_CUSTOMER_INVOICES_MANAGE/'.
    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    DATA lt_parameters TYPE /iwfnd/sutil_property_t.
    DATA: lv_status_text TYPE string,
          lv_status_code TYPE integer.
    DATA: ls_return     TYPE bapiret2.
    DATA: lv_msg             TYPE string,
          lv_status_code_txt TYPE string.
    TYPES: BEGIN OF ty_functionimportresult,
             billingdocumententity      TYPE string,
             billingdocument1           TYPE string,
             billingdocument2           TYPE string,
             splitfieldtext             TYPE string,
             billingdocument1fieldvalue TYPE string,
             billingdocument2fieldvalue TYPE string,
           END OF ty_functionimportresult.

    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              results TYPE TABLE OF ty_functionimportresult,
            END OF d,
          END OF ls_response_function.

    DATA: billing_doc_1 TYPE string,
          billing_doc_2 TYPE string.

*     cs_step_data-reference_step should contain exactly two reference steps, cause i need to compare two bil objects
*     Each reference_step contains exactly one document_id




    READ TABLE step_data-reference_step INDEX 1 ASSIGNING FIELD-SYMBOL(<ls_step_data_1>).
    READ TABLE step_data-reference_step INDEX 2 ASSIGNING FIELD-SYMBOL(<ls_step_data_2>).

    IF sy-subrc = 0.
      IF <ls_step_data_1> IS ASSIGNED AND <ls_step_data_1> IS ASSIGNED.
        DATA(ls_step_data_1) = me->mo_run_environment->get_step_data( iv_step_number = <ls_step_data_1> ).
        DATA(ls_step_data_2) = me->mo_run_environment->get_step_data( iv_step_number = <ls_step_data_2> ).
        LOOP AT ls_step_data_1-document_id ASSIGNING FIELD-SYMBOL(<ls_vbel_1>).
*         Should only run once
          billing_doc_1 = <ls_vbel_1>.
        ENDLOOP.

        LOOP AT ls_step_data_2-document_id ASSIGNING FIELD-SYMBOL(<ls_vbel_2>).
*         Should only run once
          billing_doc_2 = <ls_vbel_2>.
        ENDLOOP.

        lt_parameters = VALUE #(
              ( name = 'BillingDocument1' value =   billing_doc_1 )
              ( name = 'BillingDocument2' value =   billing_doc_2 )
            ).
        lo_odata_caller->call_service(
          EXPORTING
            iv_method           = 'POST'
            iv_action_or_entity = 'CompareBillingDocument'
            it_parameters       = lt_parameters
          IMPORTING
            ev_status_code      = lv_status_code
            ev_status_text      = lv_status_text
            es_json_response    = ls_response_function
        ).
        lv_status_code_txt = lv_status_code.
        CONCATENATE 'Executed API Call' 'CompareBillingDocument' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
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
      ENDIF.
    ENDIF.
    IF lv_msg IS INITIAL.
      CONCATENATE 'Did not execute API Call' 'CompareBillingDocument' INTO lv_msg SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD odata_post_create_bds.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/sap/SD_CUSTOMER_INVOICES_CREATE/'.
    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    DATA lt_parameters TYPE /iwfnd/sutil_property_t.
    DATA: lv_status_text TYPE string,
          lv_status_code TYPE integer.
    TYPES: BEGIN OF ty_functionimportresult,
             billingdocument     TYPE string,
             billingdocumentitem TYPE string,
             messageid           TYPE string,
             messagetype         TYPE string,
             message             TYPE string,
           END OF ty_functionimportresult.

    DATA: ls_return     TYPE bapiret2.
    DATA: lv_msg             TYPE string,
          lv_status_code_txt TYPE string.
    DATA: lv_vbeln      TYPE vbeln_vf.

    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              results TYPE TABLE OF ty_functionimportresult,
            END OF d,
          END OF ls_response_function.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
      DATA(ls_refstep_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
      IF ls_refstep_data IS NOT INITIAL.
        CHECK ls_refstep_data-document_id IS NOT INITIAL.

        TYPES:
          BEGIN OF ty_vbeln_orig,
            vbeln TYPE vbeln,
          END OF ty_vbeln_orig.
        DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.
        MOVE ls_refstep_data-document_id TO lt_vbeln_key.


        SELECT referencesddocument, referencesddocumenttype, billingdocumentdate, billingdocumenttype, destinationcountry, salesorganization FROM c_billingduelistitem_f0798 INTO TABLE @DATA(lt_billingduelistitem)
          FOR ALL ENTRIES IN @lt_vbeln_key
          WHERE referencesddocument = @lt_vbeln_key-vbeln ##DB_FEATURE_MODE[VIEWS_WITH_PARAMETERS].

        LOOP AT lt_billingduelistitem ASSIGNING FIELD-SYMBOL(<ls_billingduelistitem>).
          lt_parameters = VALUE #(
            ( name = 'SnapshotRequested' value = 'false' )
            ( name = 'BillingDocumentType' value = <ls_billingduelistitem>-billingdocumenttype )
            ( name = 'SeparateBilllingDocumentsRequested' value = 'false' )
            ( name = 'RequestedBillingDocumentDate' value = '' )
            ( name = 'BillingDocumentReleaseRequested' value = 'true' )
            ( name = 'BillingDocumentDate' value =  <ls_billingduelistitem>-billingdocumentdate )
            ( name = 'ReferenceSDDocumentCategory' value = <ls_billingduelistitem>-referencesddocumenttype )
            ( name = 'ReferenceSDDocument' value = <ls_billingduelistitem>-referencesddocument )
            ( name = 'RequestedBillingDocumentType' value = '' )
            ( name = 'DestinationCountry' value = <ls_billingduelistitem>-destinationcountry )
            ( name = 'SalesOrganization' value = <ls_billingduelistitem>-salesorganization )
            ( name = 'ReferenceSDDocumentItem' value = ''  )
            ( name = 'ToBeBilledQuantity' value = '' )
            ( name = 'NewBillToPartyAddressId' value = '' )
            ( name = 'OldBillToPartyAddressId' value = '' )
            ( name = 'RefSDDocWithInvalidPartner' value = '' )
          ).
          lo_odata_caller->call_service(
            EXPORTING
              iv_method           = 'POST'
              iv_action_or_entity = 'CreateBillingDocuments'
              it_parameters       = lt_parameters
            IMPORTING
              ev_status_code      = lv_status_code
              ev_status_text      = lv_status_text
              es_json_response    = ls_response_function
          ).

          lv_status_code_txt = lv_status_code.
          CONCATENATE 'Executed API Call' 'C_InvoiceListObjPg' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
          me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
          IF lv_status_code = 200.

            COMMIT WORK AND WAIT.

            LOOP AT ls_response_function-d-results REFERENCE INTO DATA(lr_result).
              me->mo_run_environment->append_log( iv_log_statement = |{ lr_result->message }| ).
              IF lr_result->messageid = '311' OR lr_result->messageid = '050'.

                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = lr_result->billingdocument
                  IMPORTING
                    output = lv_vbeln.

                APPEND lv_vbeln TO ev_document_id.
              ENDIF.
              SORT ev_document_id.
              DELETE ADJACENT DUPLICATES FROM ev_document_id COMPARING vbeln.
            ENDLOOP.
            IF ev_document_id IS NOT INITIAL.
              ev_execution_status = abap_true.
            ELSE.
              ev_execution_status = abap_false.
            ENDIF.
          ELSE.
            me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
            ev_execution_status = abap_false.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
    IF lv_msg IS INITIAL.
      CONCATENATE 'Did not execute API Call' 'CreateBillingDocuments' INTO lv_msg SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
      ev_execution_status = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD odata_post_create_for_country.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/sap/SD_CUSTOMER_INVOICES_CREATE/'.
    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    DATA lt_parameters TYPE /iwfnd/sutil_property_t.
    DATA: lv_status_text TYPE string,
          lv_status_code TYPE integer,
          ls_testdata    TYPE ty_gs_create_for_country.
    TYPES: BEGIN OF ty_functionimportresult,
             billingdocument     TYPE string,
             billingdocumentitem TYPE string,
             messageid           TYPE string,
             messagetype         TYPE string,
             message             TYPE string,
           END OF ty_functionimportresult.

    DATA: ls_return     TYPE bapiret2.
    DATA: lv_msg             TYPE string,
          lv_status_code_txt TYPE string.
    DATA: lv_vbeln      TYPE vbeln_vf.

    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              results TYPE TABLE OF ty_functionimportresult,
            END OF d,
          END OF ls_response_function.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

    IF ls_testdata-country EQ ''.
      me->mo_run_environment->append_log( iv_log_statement = |Please define a country.| ).
      ev_execution_status = abap_false.
    ENDIF.
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
      DATA(ls_refstep_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
      IF ls_refstep_data IS NOT INITIAL.
        CHECK ls_refstep_data-document_id IS NOT INITIAL.

        TYPES:
          BEGIN OF ty_vbeln_orig,
            vbeln TYPE vbeln,
          END OF ty_vbeln_orig.
        DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.
        MOVE ls_refstep_data-document_id TO lt_vbeln_key.


        SELECT referencesddocument, referencesddocumenttype, billingdocumentdate, billingdocumenttype, destinationcountry, salesorganization FROM c_billingduelistitem_f0798 INTO TABLE @DATA(lt_billingduelistitem)
          FOR ALL ENTRIES IN @lt_vbeln_key
          WHERE referencesddocument = @lt_vbeln_key-vbeln AND destinationcountry = @ls_testdata-country ##DB_FEATURE_MODE[VIEWS_WITH_PARAMETERS].

        LOOP AT lt_billingduelistitem ASSIGNING FIELD-SYMBOL(<ls_billingduelistitem>).
          lt_parameters = VALUE #(
            ( name = 'SnapshotRequested' value = 'false' )
            ( name = 'BillingDocumentType' value = <ls_billingduelistitem>-billingdocumenttype )
            ( name = 'SeparateBilllingDocumentsRequested' value = 'false' )
            ( name = 'RequestedBillingDocumentDate' value = '' )
            ( name = 'BillingDocumentReleaseRequested' value = 'true' )
            ( name = 'BillingDocumentDate' value =  <ls_billingduelistitem>-billingdocumentdate )
            ( name = 'ReferenceSDDocumentCategory' value = <ls_billingduelistitem>-referencesddocumenttype )
            ( name = 'ReferenceSDDocument' value = <ls_billingduelistitem>-referencesddocument )
            ( name = 'RequestedBillingDocumentType' value = '' )
            ( name = 'DestinationCountry' value = <ls_billingduelistitem>-destinationcountry )
            ( name = 'SalesOrganization' value = <ls_billingduelistitem>-salesorganization )
            ( name = 'ReferenceSDDocumentItem' value = ''  )
            ( name = 'ToBeBilledQuantity' value = '' )
            ( name = 'NewBillToPartyAddressId' value = '' )
            ( name = 'OldBillToPartyAddressId' value = '' )
            ( name = 'RefSDDocWithInvalidPartner' value = '' )
          ).
          lo_odata_caller->call_service(
            EXPORTING
              iv_method           = 'POST'
              iv_action_or_entity = 'CreateBillingDocuments'
              it_parameters       = lt_parameters
            IMPORTING
              ev_status_code      = lv_status_code
              ev_status_text      = lv_status_text
              es_json_response    = ls_response_function
          ).

          lv_status_code_txt = lv_status_code.
          CONCATENATE 'Executed API Call' 'C_InvoiceListObjPg' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
          me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
          IF lv_status_code = 200.

            COMMIT WORK AND WAIT.

            LOOP AT ls_response_function-d-results REFERENCE INTO DATA(lr_result).
              me->mo_run_environment->append_log( iv_log_statement = |{ lr_result->message }| ).
              IF lr_result->messageid = '311' OR lr_result->messageid = '050'.

                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                  EXPORTING
                    input  = lr_result->billingdocument
                  IMPORTING
                    output = lv_vbeln.

                APPEND lv_vbeln TO ev_document_id.
              ENDIF.
              SORT ev_document_id.
              DELETE ADJACENT DUPLICATES FROM ev_document_id COMPARING vbeln.
            ENDLOOP.
            IF ev_document_id IS NOT INITIAL.
              ev_execution_status = abap_true.
            ELSE.
              ev_execution_status = abap_false.
            ENDIF.
          ELSE.
            me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
            ev_execution_status = abap_false.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
    IF lv_msg IS INITIAL.
      CONCATENATE 'Did not execute API Call' 'CreateBillingDocuments' INTO lv_msg SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
      ev_execution_status = abap_false.
    ENDIF.
  ENDMETHOD.


  METHOD odata_post_cr_for_countries.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/sap/SD_CUSTOMER_INVOICES_CREATE/'.
    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    DATA lt_parameters TYPE /iwfnd/sutil_property_t.
    DATA: lv_status_text TYPE string,
          lv_status_code TYPE integer,
          ls_testdata    TYPE ty_gs_create_for_countries.
    TYPES: BEGIN OF ty_functionimportresult,
             billingdocument     TYPE string,
             billingdocumentitem TYPE string,
             messageid           TYPE string,
             messagetype         TYPE string,
             message             TYPE string,
           END OF ty_functionimportresult.

    DATA: ls_return     TYPE bapiret2.
    DATA: lv_msg             TYPE string,
          lv_status_code_txt TYPE string.
    DATA: lv_vbeln      TYPE vbeln_vf.

    DATA: list_of_ref_doc            TYPE TABLE OF string,
          list_of_dest_country       TYPE TABLE OF string,
          list_of_bd_date            TYPE TABLE OF string,
          list_of_bd_types           TYPE TABLE OF string,
          list_of_ref_doc_type       TYPE TABLE OF string,
          list_of_sales_organization TYPE TABLE OF string.

    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              results TYPE TABLE OF ty_functionimportresult,
            END OF d,
          END OF ls_response_function.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

    IF ls_testdata-countries IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Please define at least one country.| ).
      ev_execution_status = abap_false.
    ENDIF.
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
      DATA(ls_refstep_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
      IF ls_refstep_data IS NOT INITIAL.
        CHECK ls_refstep_data-document_id IS NOT INITIAL.

        TYPES:
          BEGIN OF ty_vbeln_orig,
            vbeln TYPE vbeln,
          END OF ty_vbeln_orig.
        DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.
        MOVE ls_refstep_data-document_id TO lt_vbeln_key.


        LOOP AT ls_testdata-countries ASSIGNING FIELD-SYMBOL(<country>).
          "Retrieve all billingduelistitems to retrieve

          SELECT referencesddocument, referencesddocumenttype, billingdocumentdate, billingdocumenttype, destinationcountry, salesorganization FROM c_billingduelistitem_f0798 INTO TABLE @DATA(lt_billingduelistitem)
            FOR ALL ENTRIES IN @lt_vbeln_key
            WHERE referencesddocument = @lt_vbeln_key-vbeln AND destinationcountry = @<country>-country ##DB_FEATURE_MODE[VIEWS_WITH_PARAMETERS]. "#EC CI_NOORDER
          LOOP AT lt_billingduelistitem ASSIGNING FIELD-SYMBOL(<ls_billingduelistitem>).
            APPEND <ls_billingduelistitem>-referencesddocument TO list_of_ref_doc .
            APPEND <ls_billingduelistitem>-destinationcountry TO list_of_dest_country .
            APPEND <ls_billingduelistitem>-billingdocumentdate TO list_of_bd_date.
            APPEND <ls_billingduelistitem>-referencesddocumenttype TO list_of_ref_doc_type.
            APPEND <ls_billingduelistitem>-billingdocumenttype TO list_of_bd_types.
            APPEND <ls_billingduelistitem>-salesorganization TO list_of_sales_organization.
          ENDLOOP.


        ENDLOOP.

        CONCATENATE LINES OF list_of_ref_doc INTO DATA(bd_refs) SEPARATED BY ','. "#EC CI_NOORDER
        CONCATENATE LINES OF list_of_dest_country INTO DATA(bd_countries) SEPARATED BY ','. "#EC CI_NOORDER
        CONCATENATE LINES OF list_of_bd_date INTO DATA(bd_dates) SEPARATED BY ','. "#EC CI_NOORDER
        CONCATENATE LINES OF list_of_ref_doc_type INTO DATA(bd_ref_types) SEPARATED BY ','. "#EC CI_NOORDER
        CONCATENATE LINES OF list_of_bd_types INTO DATA(bd_types) SEPARATED BY ','. "#EC CI_NOORDER
        CONCATENATE LINES OF list_of_sales_organization INTO DATA(bd_sales_organization) SEPARATED BY ','. "#EC CI_NOORDER

        lt_parameters = VALUE #(
          ( name = 'SnapshotRequested' value = 'false' )
          ( name = 'BillingDocumentType' value = bd_types )
          ( name = 'SeparateBilllingDocumentsRequested' value = 'false' )
          ( name = 'RequestedBillingDocumentDate' value = '' )
          ( name = 'BillingDocumentReleaseRequested' value = 'true' )
          ( name = 'BillingDocumentDate' value =  bd_dates )
          ( name = 'ReferenceSDDocumentCategory' value = bd_ref_types )
          ( name = 'ReferenceSDDocument' value = bd_refs )
          ( name = 'RequestedBillingDocumentType' value = '' )
          ( name = 'DestinationCountry' value = bd_countries )
          ( name = 'SalesOrganization' value = bd_sales_organization )
          ( name = 'ReferenceSDDocumentItem' value = ''  )
          ( name = 'ToBeBilledQuantity' value = '' )
          ( name = 'NewBillToPartyAddressId' value = '' )
          ( name = 'OldBillToPartyAddressId' value = '' )
          ( name = 'RefSDDocWithInvalidPartner' value = '' )
        ).
        lo_odata_caller->call_service(
          EXPORTING
            iv_method           = 'POST'
            iv_action_or_entity = 'CreateBillingDocuments'
            it_parameters       = lt_parameters
          IMPORTING
            ev_status_code      = lv_status_code
            ev_status_text      = lv_status_text
            es_json_response    = ls_response_function
        ).

        lv_status_code_txt = lv_status_code.
        CONCATENATE 'Executed API Call' 'C_InvoiceListObjPg' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
        me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
        IF lv_status_code = 200.

          COMMIT WORK AND WAIT.

          LOOP AT ls_response_function-d-results REFERENCE INTO DATA(lr_result).
            me->mo_run_environment->append_log( iv_log_statement = |{ lr_result->message }| ).
            IF lr_result->messageid = '311' OR lr_result->messageid = '050'.

              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                EXPORTING
                  input  = lr_result->billingdocument
                IMPORTING
                  output = lv_vbeln.

              APPEND lv_vbeln TO ev_document_id.
            ENDIF.
            SORT ev_document_id.
            DELETE ADJACENT DUPLICATES FROM ev_document_id COMPARING vbeln.
          ENDLOOP.
          IF ev_document_id IS NOT INITIAL.
            ev_execution_status = abap_true.
          ELSE.
            ev_execution_status = abap_false.
          ENDIF.
        ELSE.
          me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
          ev_execution_status = abap_false.
          EXIT.
        ENDIF.
      ENDIF.
    ENDLOOP.
    IF lv_msg IS INITIAL.
      CONCATENATE 'Did not execute API Call' 'CreateBillingDocuments' INTO lv_msg SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
      ev_execution_status = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD odata_post_delete_snapshot.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/SAP/SD_CUSTOMER_INVOICES_MANAGE/'.
    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    DATA lt_parameters TYPE /iwfnd/sutil_property_t.
    DATA: lv_status_text TYPE string,
          lv_status_code TYPE integer.
    DATA: ls_return     TYPE bapiret2.
    DATA: lv_msg             TYPE string,
          lv_status_code_txt TYPE string.
    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              results TYPE TABLE OF ty_def_functionimportresult,
            END OF d,
          END OF ls_response_function.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
      DATA(ls_refstep_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
      IF ls_refstep_data IS NOT INITIAL.
        LOOP AT ls_refstep_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).

          lt_parameters = VALUE #(
                      ( name = 'BillingDocument' value =  <ls_docid> )
                  ).
          lo_odata_caller->call_service(
            EXPORTING
              iv_method           = 'POST'
              iv_action_or_entity = 'DeleteSnapshot'
              it_parameters       = lt_parameters
            IMPORTING
              ev_status_code      = lv_status_code
              ev_status_text      = lv_status_text
              es_json_response    = ls_response_function
          ).
          lv_status_code_txt = lv_status_code.
          CONCATENATE 'Executed API Call' 'DeleteSnapshot' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
          me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
          IF lv_status_code = 200.
            ev_execution_status = abap_true.
            ev_check_status = abap_true.
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
      CONCATENATE 'Did not execute API Call' 'DeleteSnapshot' INTO lv_msg SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
    ENDIF.
  ENDMETHOD.


  METHOD odata_post_get_bd_types.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/sap/SD_CUSTOMER_INVOICES_CREATE/'.
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
            ( name = 'ReferenceSDDocument' value =  <ls_docid> )
          ).
          lo_odata_caller->call_service(
            EXPORTING
              iv_method           = 'POST'
              iv_action_or_entity = 'GetBillingDocumentTypes'
              it_parameters       = lt_parameters
            IMPORTING
              ev_status_code      = lv_status_code
              ev_status_text      = lv_status_text
              es_json_response    = ls_response_function
          ).
          lv_status_code_txt = lv_status_code.
          CONCATENATE 'Executed API Call' 'GetBillingDocumentTypes' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
          me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
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
      CONCATENATE 'Did not execute API Call' 'GetBillingDocumentTypes' INTO lv_msg SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = lv_msg )..
      ev_execution_status = abap_false.
      ev_check_status = abap_false.
    ENDIF.
  ENDMETHOD.


  METHOD partial_payment.
    CONSTANTS: blart_to_clear TYPE string VALUE 'RV'.
    DATA: clearing_header       TYPE cl_fdc_clearing_document_inf=>ty_clearing_header,
          apar_items_to_be_clrd TYPE cl_fdc_clearing_document_inf=>tty_apar_item_to_be_clrd,
          apar_item_to_be_clrd  TYPE cl_fdc_clearing_document_inf=>ty_apar_item_to_be_clrd,
          gl_items_to_be_clrd   TYPE cl_fdc_clearing_document_inf=>tty_gl_item_to_be_clrd,
          gl_item_to_be_clrd    TYPE cl_fdc_clearing_document_inf=>ty_gl_item_to_be_clrd,
          apar_items_on_account TYPE cl_fdc_clearing_document_inf=>tty_apar_item_on_account,
          apar_item_on_account  TYPE cl_fdc_clearing_document_inf=>ty_apar_item_on_account,
          lt_vbeln              TYPE cl_ptf_util=>ty_vbeln_tab,
          awref                 TYPE acchd-awref,
          fi_documents          TYPE STANDARD TABLE OF bkpf WITH DEFAULT KEY,
          bseg_entries          TYPE STANDARD TABLE OF bseg WITH DEFAULT KEY,
          posted_document       TYPE fdc_s_accdoc_hdr_key_odata,
          messages              TYPE bapirettab,
          error_occured         TYPE abap_bool,
          test_data             TYPE ty_gs_partial_payment,
          amount_to_be_posted   TYPE fdc_cdamtdc.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = test_data
    ).

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    ev_execution_status = abap_true.

    LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<billing_doc>).

      "SELECT SINGLE mwsbk, netwr FROM vbrk WHERE vbeln = @<billing_doc>-vbeln INTO @DATA(amounts).
      "gross_amount = amounts-mwsbk + amounts-netwr.



      awref = <billing_doc>-vbeln.

      CALL FUNCTION 'FI_DOCUMENT_READ'
        EXPORTING
          i_awtyp = 'VBRK'
          i_awref = awref
        TABLES
          t_bseg  = bseg_entries
          t_bkpf  = fi_documents.

      LOOP AT fi_documents ASSIGNING FIELD-SYMBOL(<fi_document>) WHERE blart = blart_to_clear.
        clearing_header-bukrs = <fi_document>-bukrs.
        clearing_header-blart = <fi_document>-blart.
        clearing_header-budat = sy-datum.
        clearing_header-bldat = sy-datum.
        clearing_header-waers = <fi_document>-waers.
        clearing_header-kursf = <fi_document>-kursf.

        LOOP AT bseg_entries ASSIGNING FIELD-SYMBOL(<bseg_entry>) WHERE belnr = <fi_document>-belnr.

          CASE <bseg_entry>-koart.
            WHEN 'D'.
              amount_to_be_posted = <bseg_entry>-wrbtr * test_data-percentage / 100.

              apar_item_to_be_clrd-bukrs = <bseg_entry>-bukrs.
              apar_item_to_be_clrd-koart = <bseg_entry>-koart.
              apar_item_to_be_clrd-konko = test_data-konko.
              apar_item_to_be_clrd-gjahr = <bseg_entry>-gjahr.
              apar_item_to_be_clrd-belnr = <bseg_entry>-belnr.
              apar_item_to_be_clrd-buzei = <bseg_entry>-buzei.
              apar_item_to_be_clrd-ppamtdc = amount_to_be_posted.
              APPEND apar_item_to_be_clrd TO apar_items_to_be_clrd.

              apar_item_on_account-koart = <bseg_entry>-koart.
              apar_item_on_account-konko = test_data-konko.
              apar_item_on_account-shkzg = <bseg_entry>-shkzg.
              apar_item_on_account-wrbtr = amount_to_be_posted.
              APPEND apar_item_on_account TO apar_items_on_account.
            WHEN OTHERS.
              "Not sure what to do here
          ENDCASE.
        ENDLOOP.

        NEW cl_fdc_clearing_document_inf( )->post(
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

        me->mo_run_environment->append_log( iv_log_statement = |Tried to clear document { <fi_document>-belnr }. Error occured: { error_occured }| ).
        LOOP AT messages ASSIGNING FIELD-SYMBOL(<message>).
          me->mo_run_environment->append_log_structure( is_log =  <message> ).
        ENDLOOP.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


  METHOD read_fi_documents.
    DATA: lt_vbeln     TYPE cl_ptf_util=>ty_vbeln_tab,
          fi_documents TYPE STANDARD TABLE OF bkpf WITH DEFAULT KEY,
          awref        TYPE acchd-awref.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    ev_execution_status = abap_true.
    LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<billing_doc>).
      CLEAR fi_documents.
      awref = <billing_doc>-vbeln.
      CALL FUNCTION 'FI_DOCUMENT_READ'
        EXPORTING
          i_awtyp = 'VBRK'
          i_awref = awref
        TABLES
          t_bkpf  = fi_documents.

      IF lines( fi_documents ) IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |Could not find any FI document for { <billing_doc>-vbeln }| ).
        ev_execution_status = abap_false.
      ELSE.
        LOOP AT fi_documents ASSIGNING FIELD-SYMBOL(<fi_doc>).
          APPEND <fi_doc>-belnr TO ev_document_id.
        ENDLOOP.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD release_dup_to_accounting.
    DATA: lt_vbrk             TYPE TABLE OF vbrk,
          ls_vbrk             TYPE vbrk,
          lt_xkomfk           TYPE TABLE OF   komfk,
          lt_xkomv            TYPE TABLE OF   komv,
          lt_xthead           TYPE TABLE OF   theadvb,
          lt_xvbfs            TYPE TABLE OF  vbfs,
          lt_xvbpa            TYPE TABLE OF  vbpavb,
          lt_xvbrk            TYPE TABLE OF   vbrkvb,
          lt_xvbrp            TYPE TABLE OF   vbrpvb,
          lt_xvbrl            TYPE TABLE OF  vbrlvb,
          lt_xvbss            TYPE TABLE OF  vbss,
          lv_rfbsk            TYPE rfbsk,
          ls_return           TYPE bapiret2,
          lt_return           TYPE TABLE OF bapiret2,
          lv_execution_status TYPE abap_bool,
          lt_vbeln            TYPE cl_ptf_util=>ty_vbeln_tab,
          lv_posting          TYPE c,
          lv_message          TYPE string.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    LOOP AT lt_vbeln INTO DATA(ls_vbeln).
      ls_vbrk-vbeln = ls_vbeln-vbeln.
      APPEND ls_vbrk TO lt_vbrk.
      APPEND ls_vbrk TO lt_vbrk.
    ENDLOOP.

    lv_posting = 'U'. "simulate Fiori UI - no commit
    CALL FUNCTION 'SD_INVOICE_RELEASE_TO_ACCOUNT'
      EXPORTING
        with_posting = lv_posting
*       vbsk_i       =     " Collective Processing for a Sales Document Header
*       is_fi_add_input =
      TABLES
        it_vbrk      = lt_vbrk    " Billing Document: Header Data
        xkomfk       = lt_xkomfk  " Billing Communications Table
        xkomv        = lt_xkomv   " Pricing: Communications Condition Record
        xthead       = lt_xthead  " Reference Structure for XTHEAD
        xvbfs        = lt_xvbfs   " Error Log for Collective Processing
        xvbpa        = lt_xvbpa   " Reference structure for XVBPA/YVBPA
        xvbrk        = lt_xvbrk   " Reference Structure for XVBRK/YVBRP
        xvbrp        = lt_xvbrp   " Reference Structure for XVBRP/YVBRP
        xvbrl        = lt_xvbrl   " Reference Structure for XVBRL/YVBRL
        xvbss        = lt_xvbss.  " Collective Processing: Sales Documents

    lv_execution_status = abap_true.
    LOOP AT lt_xvbfs ASSIGNING FIELD-SYMBOL(<ls_vbfs>).
      MOVE-CORRESPONDING <ls_vbfs> TO ls_return.
      MESSAGE ID <ls_vbfs>-msgid TYPE <ls_vbfs>-msgty NUMBER <ls_vbfs>-msgno WITH <ls_vbfs>-msgv1 <ls_vbfs>-msgv2 <ls_vbfs>-msgv3 <ls_vbfs>-msgv4 INTO ls_return-message.
      me->mo_run_environment->append_log_structure( ls_return ).
      IF <ls_vbfs>-msgty CA 'EAX'.
        lv_execution_status = abap_false.
      ENDIF.
    ENDLOOP.

    IF lv_execution_status = abap_true.
      CLEAR ls_return.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait   = abap_true
        IMPORTING
          return = ls_return.
      IF ls_return IS NOT INITIAL.
        me->mo_run_environment->append_log_structure( ls_return ).
        lv_execution_status = abap_false.
      ENDIF.

      LOOP AT lt_vbrk ASSIGNING FIELD-SYMBOL(<ls_vbrk>).
        SELECT SINGLE rfbsk FROM vbrk INTO lv_rfbsk WHERE vbeln = <ls_vbrk>-vbeln.
        IF lv_rfbsk NE 'C'.
          lv_message = |Release of Billing Document: { <ls_vbrk>-vbeln } failed. Status of Billing Document is: { lv_rfbsk }|.
          me->mo_run_environment->append_log( lv_message  ).
          lv_execution_status = abap_false.
        ENDIF.
      ENDLOOP.

    ENDIF.
    ev_execution_status = lv_execution_status.
  ENDMETHOD.


  METHOD release_to_accounting.

    DATA: lt_vbrk             TYPE TABLE OF vbrk,
          ls_vbrk             TYPE vbrk,
          lt_xkomfk           TYPE TABLE OF komfk,
          lt_xkomv            TYPE TABLE OF komv,
          lt_xthead           TYPE TABLE OF theadvb,
          lt_xvbfs            TYPE TABLE OF vbfs,
          lt_xvbpa            TYPE TABLE OF vbpavb,
          lt_xvbrk            TYPE TABLE OF vbrkvb,
          lt_xvbrp            TYPE TABLE OF vbrpvb,
          lt_xvbrl            TYPE TABLE OF vbrlvb,
          lt_xvbss            TYPE TABLE OF vbss,
          lv_rfbsk            TYPE rfbsk,
          ls_return           TYPE bapiret2,
          lt_return           TYPE TABLE OF bapiret2,
          lv_execution_status TYPE abap_bool,
          lt_vbeln            TYPE cl_ptf_util=>ty_vbeln_tab,
          lv_posting          TYPE c,
          lv_message          TYPE string.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.
    IF lt_vbeln IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No referenced documents exist.| ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.

    LOOP AT lt_vbeln INTO DATA(ls_vbeln).
      SELECT SINGLE rfbsk FROM vbrk INTO lv_rfbsk WHERE vbeln = ls_vbeln-vbeln.
      IF sy-subrc IS NOT INITIAL.
        me->mo_run_environment->append_log( |Failed to find Billing Document { ls_vbeln-vbeln } | ).
        lv_execution_status = abap_false.
      ELSE.
        me->mo_run_environment->append_log( |Billing Document { ls_vbeln-vbeln } has RFBSK "{ lv_rfbsk }" before this Action.| ).
      ENDIF.

      ls_vbrk-vbeln = ls_vbeln-vbeln.
      APPEND ls_vbrk TO lt_vbrk.
    ENDLOOP.

    lv_posting = 'U'. "simulate Fiori UI - no commit
    CALL FUNCTION 'SD_INVOICE_RELEASE_TO_ACCOUNT'
      EXPORTING
        with_posting = lv_posting
*       vbsk_i       =     " Collective Processing for a Sales Document Header
*       is_fi_add_input =
      TABLES
        it_vbrk      = lt_vbrk    " Billing Document: Header Data
        xkomfk       = lt_xkomfk  " Billing Communications Table
        xkomv        = lt_xkomv   " Pricing: Communications Condition Record
        xthead       = lt_xthead  " Reference Structure for XTHEAD
        xvbfs        = lt_xvbfs   " Error Log for Collective Processing
        xvbpa        = lt_xvbpa   " Reference structure for XVBPA/YVBPA
        xvbrk        = lt_xvbrk   " Reference Structure for XVBRK/YVBRP
        xvbrp        = lt_xvbrp   " Reference Structure for XVBRP/YVBRP
        xvbrl        = lt_xvbrl   " Reference Structure for XVBRL/YVBRL
        xvbss        = lt_xvbss.  " Collective Processing: Sales Documents

    lv_execution_status = abap_true.
    LOOP AT lt_xvbfs ASSIGNING FIELD-SYMBOL(<ls_vbfs>).
      MOVE-CORRESPONDING <ls_vbfs> TO ls_return.
      MESSAGE ID <ls_vbfs>-msgid TYPE <ls_vbfs>-msgty NUMBER <ls_vbfs>-msgno WITH <ls_vbfs>-msgv1 <ls_vbfs>-msgv2 <ls_vbfs>-msgv3 <ls_vbfs>-msgv4 INTO ls_return-message.
      me->mo_run_environment->append_log_structure( ls_return ).
      IF <ls_vbfs>-msgty CA 'EAX'.
        lv_execution_status = abap_false.
      ENDIF.
    ENDLOOP.

    IF lv_execution_status = abap_true.
      CLEAR ls_return.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait   = abap_true
        IMPORTING
          return = ls_return.
      IF ls_return IS NOT INITIAL.
        me->mo_run_environment->append_log_structure( ls_return ).
        lv_execution_status = abap_false.
      ENDIF.

      LOOP AT lt_vbrk ASSIGNING FIELD-SYMBOL(<ls_vbrk>).
        CLEAR lv_rfbsk.
        SELECT SINGLE rfbsk FROM vbrk INTO lv_rfbsk WHERE vbeln = <ls_vbrk>-vbeln.
        IF sy-subrc IS NOT INITIAL.
          me->mo_run_environment->append_log( |Did not find Billing Document { <ls_vbrk>-vbeln } | ).
          lv_execution_status = abap_false.
        ELSEIF lv_rfbsk EQ 'C'.
          me->mo_run_environment->append_log( |Released Billing Document { <ls_vbrk>-vbeln } to Accounting.| ).
        ELSE.
          lv_message = |Release of Billing Document { <ls_vbrk>-vbeln } failed. Status of Billing Document is: { lv_rfbsk }|.
          me->mo_run_environment->append_log( lv_message  ).
          lv_execution_status = abap_false.
        ENDIF.
      ENDLOOP.

    ENDIF.
    ev_execution_status = lv_execution_status.

  ENDMETHOD.


METHOD reserve_action_1.


ENDMETHOD.


METHOD reserve_action_2.


ENDMETHOD.


METHOD reserve_action_3.


ENDMETHOD.


METHOD simulate_pricing_web_service.

  DATA: ls_testdata              TYPE cl_ptf_bo_invoice=>ty_gs_bd_sm_pricing,
        ls_document              TYPE sdbilbdsimulate_pricing_reques,
        lt_message               TYPE bapiret2_t,
        lx_success               TYPE /aif/successflag,
        lt_reference_billing_doc TYPE STANDARD TABLE OF vbeln,
        lt_vbeln                 TYPE TABLE OF vbeln_vf,
        wa_vbeln                 TYPE vbeln_vf,
        lt_buffer                TYPE STANDARD TABLE OF vbrp,
        ls_step_data_copy        TYPE cl_ptf_util=>gt_ptf_step.

  ev_execution_status = abap_false.

  IF step_data-variant IS NOT INITIAL.
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).
  ELSE.
    me->mo_run_environment->append_log( iv_log_statement = |There is no Variant in Test Data Container.| ).
    EXIT.
  ENDIF.

  ls_step_data_copy = step_data.

  SORT ls_step_data_copy-reference_step ASCENDING.

*Get Data of the predecessor
  LOOP AT ls_step_data_copy-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
    IF lt_ptf_keys IS NOT INITIAL.
      APPEND LINES OF lt_ptf_keys TO lt_reference_billing_doc.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |No reference data available to start simulation for pricing. Previous step failed.| ).
      EXIT.
    ENDIF.
  ENDLOOP.

  IF lines( ls_testdata-bd_simulate_pricing_reques1-document ) = lines( lt_reference_billing_doc ).
  ELSE.
    me->mo_run_environment->append_log( iv_log_statement = |Reference document IDs do not fit to number of Test Data entries.| ).
    EXIT.
  ENDIF.


  LOOP AT ls_testdata-bd_simulate_pricing_reques1-document INTO DATA(ls_reference_document).
    ls_testdata-bd_simulate_pricing_reques1-document[ sy-tabix ]-billing_document = lt_reference_billing_doc[ sy-tabix ].
  ENDLOOP.

  NEW cl_sdbil_sbi_bd_price_process( )->process(
    EXPORTING
      im_input    =  ls_testdata-bd_simulate_pricing_reques1
    IMPORTING
      ex_success  =  lx_success
    CHANGING
      ct_messages =  lt_message
      ).

  IF lx_success EQ 'Y'.
    ev_execution_status = abap_true.
  ELSE.
    me->mo_run_environment->append_log( iv_log_statement = |No success in process class.| ).
    EXIT.
  ENDIF.

  SORT lt_reference_billing_doc.

  ev_document_id = lt_reference_billing_doc.

ENDMETHOD.


METHOD submit_and_return_test.

*    FREE MEMORY ID 'PTF_XY_COUNT'.

  SUBMIT ptf_dummy_report AND RETURN.

  me->mo_run_environment->append_log( iv_log_statement = |sy-subrc = { sy-subrc }| ).
  me->mo_run_environment->append_log( iv_log_statement = |The method continued after the SUBMIT ... AND RETURN statement.| ).
  ev_execution_status = abap_true.

  DATA lv_count TYPE i.
  IMPORT v_count   = lv_count FROM MEMORY ID 'PTF_XY_COUNT'.

ENDMETHOD.


METHOD submit_test.

*    FREE MEMORY ID 'PTF_XY_COUNT'.

*    call transaction 'VF03'  WITHOUT AUTHORITY-CHECK  .
  SUBMIT ptf_dummy_report  ##STMNT_EXIT.

  me->mo_run_environment->append_log( iv_log_statement = |sy-subrc = { sy-subrc }| ).
  me->mo_run_environment->append_log( iv_log_statement = |The method continued after the SUBMIT statement.| ). "should never happen
  ev_execution_status = abap_true.

  DATA lv_count TYPE i.
  IMPORT v_count   = lv_count FROM MEMORY ID 'PTF_XY_COUNT'.

ENDMETHOD.


  METHOD update_bd_zuonr_xblnr.

    DATA: ls_testdata              TYPE cl_ptf_bo_invoice=>ty_gs_bd_up_zuonr_xblnr,
          ls_document              TYPE sdbil_esrbdupdate_self_billing,
          lt_message               TYPE bapiret2_t,
          lx_success               TYPE /aif/successflag,
          lt_reference_billing_doc TYPE STANDARD TABLE OF vbeln,
          lt_vbeln                 TYPE TABLE OF vbeln_vf,
          wa_vbeln                 TYPE vbeln_vf,
          lt_buffer                TYPE STANDARD TABLE OF vbrp,
          ls_step_data_copy        TYPE cl_ptf_util=>gt_ptf_step.

    ev_execution_status = abap_false.

    IF step_data-variant IS NOT INITIAL.
      cl_ptf_util=>get_testdata(
        EXPORTING
          is_step_data = step_data
        IMPORTING
          es_testdata  = ls_testdata
      ).
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |There is no Variant in Test Data Container.| ).
      EXIT.
    ENDIF.

    ls_step_data_copy = step_data.

    SORT ls_step_data_copy-reference_step ASCENDING.

*Get Data of the predecessor
    LOOP AT ls_step_data_copy-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      IF lt_ptf_keys IS NOT INITIAL.
        APPEND LINES OF lt_ptf_keys TO lt_reference_billing_doc.
      ENDIF.
    ENDLOOP.

    IF lines( ls_testdata-bd_upd_sbi_req_mes-document ) = lines( lt_reference_billing_doc ).
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |Reference document IDs do not fit to number of Test Data entries.| ).
      EXIT.
    ENDIF.


    LOOP AT ls_testdata-bd_upd_sbi_req_mes-document INTO DATA(ls_reference_document).
      ls_testdata-bd_upd_sbi_req_mes-document[ sy-tabix ]-billing_document = lt_reference_billing_doc[ sy-tabix ].
    ENDLOOP.

    NEW cl_sdbil_sbi_bd_update_process( )->process(
      EXPORTING
        im_input    =  ls_testdata-bd_upd_sbi_req_mes
      IMPORTING
        ex_success  =  lx_success
      CHANGING
        ct_messages =  lt_message
        ).

    IF lx_success EQ 'Y'.
      ev_execution_status = abap_true.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |No success in process class.| ).
      EXIT.
    ENDIF.

    SORT lt_reference_billing_doc.

    ev_document_id = lt_reference_billing_doc.

  ENDMETHOD.


METHOD update_task_test.

*    FREE MEMORY ID 'PTF_XY_COUNT'.

  DATA: ls_vbrk_i TYPE vbrk,
        lt_xkomv  TYPE TABLE OF komv,
        lt_xvbfs  TYPE TABLE OF vbfs,
        lt_xvbpa  TYPE TABLE OF vbpavb,
        lt_xvbss  TYPE TABLE OF vbss,
        lt_xkomfk TYPE TABLE OF komfk,
        lt_xthead TYPE TABLE OF theadvb,
        lt_xvbrk  TYPE TABLE OF vbrkvb,
        lt_xvbrp  TYPE TABLE OF vbrpvb,
        lt_vbeln  TYPE cl_ptf_util=>ty_vbeln_tab,
        lt_xvbuk  TYPE TABLE OF vbukvb,
        lt_xvbup  TYPE TABLE OF vbupvb,
        lt_xsadr  TYPE TABLE OF sadrvb,
        lt_xvbfa  TYPE TABLE OF vbfavb,
        lt_yvbpa  TYPE TABLE OF vbpavb,
        lt_yvbrk  TYPE TABLE OF vbrkvb,
        lt_yvbrp  TYPE TABLE OF vbrpvb,
        ls_vbsk_i TYPE vbsk.

  CALL FUNCTION 'RV_INVOICE_POST' IN UPDATE TASK
    EXPORTING
      no_konv = 'X'
      vbsk_i  = ls_vbsk_i
    TABLES
      xkomv   = lt_xkomv
      xsadr   = lt_xsadr
      xvbfa   = lt_xvbfa
      xvbfs   = lt_xvbfs
      xvbpa   = lt_xvbpa
      xvbrk   = lt_xvbrk
      xvbrp   = lt_xvbrp
      xvbss   = lt_xvbss
      xvbuk   = lt_xvbuk
      xvbup   = lt_xvbup
      yvbpa   = lt_yvbpa
      yvbrk   = lt_yvbrk
      yvbrp   = lt_yvbrp
      yvbuk   = lt_xvbuk
      yvbup   = lt_xvbup.

  CHECK 1 = 1.

  COMMIT WORK AND WAIT.

  me->mo_run_environment->append_log( iv_log_statement = |sy-subrc = { sy-subrc }| ).
  me->mo_run_environment->append_log( iv_log_statement = |The method continued after the CALL FUNCTION ... IN UPDATE TASK statement.| ).
  ev_execution_status = abap_true.

  DATA lv_count TYPE i.
  IMPORT v_count   = lv_count FROM MEMORY ID 'PTF_XY_COUNT'.

ENDMETHOD.


METHOD wait.

  DATA:
    ls_testdata     TYPE ty_gs_wait_td,
    lv_wait_seconds TYPE string,  " Idle Seconds Before Start
    lv_statement    TYPE bapi_msg,
    lv_number(5)    TYPE c.

*   ------------------------------------------ get test parameter -----

  cl_ptf_util=>get_testdata( EXPORTING is_step_data = step_data
                             IMPORTING es_testdata  = ls_testdata ).

  lv_wait_seconds  = ls_testdata-wait_time.  "  Number of Idle Seconds Before Start

  IF lv_wait_seconds IS INITIAL.
    me->mo_run_environment->append_log( iv_log_statement = |Not waiting, no TDC variant given.| ).
  ELSE.
* write parameter values into log
    lv_statement = 'Parameter: Wait number of seconds: &1'.
    lv_number = lv_wait_seconds.
    REPLACE '&1' IN lv_statement WITH lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

*   -------------------------------------------------------- wait -----
    WAIT UP TO lv_wait_seconds SECONDS.
    ev_execution_status = abap_true.
  ENDIF.

ENDMETHOD.


method check_msico_vcm.

  types:
    begin of ty_vcm_object_id,
      vbeln   type vbeln,
      vb_year type gjahr,
    end of ty_vcm_object_id.

  data:
    ls_testdata           type ty_gs_ptf_bd_check_td,
    lt_vbeln              type cl_ptf_util=>ty_vbeln_tab,
    lv_vcm_guid           type vcm_uuid,
    lv_vcm_bo_object_id   type vcm_business_object_id,
    lv_vcm_bo_obj_item_id type vcm_business_object_item_id,
    lv_vcm_vbeln          type vbeln,
    lv_vcm_posnr          type posnr,
    lv_step_type          type vcm_step_type_id,
    lv_document_type      type vbrk-vbtyp,
    lv_check_status       type abap_bool.


  data: lo_db_access type ref to cl_sd_bill_db_access.

  clear lv_check_status.

  ev_check_status = abap_true.
  ev_execution_status = abap_false.

* ----------------------------------------------- get test data -----
  data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
  cl_ptf_util=>get_testdata(
    exporting
      is_step_data = ls_step_data
    importing
      es_testdata  = ls_testdata ).

* --------------- get billing document number from reference step -----
  loop at step_data-reference_step assigning field-symbol(<lv_ref_step>).
    data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
    if lines( lt_ptf_keys ) eq 0.
      me->mo_run_environment->append_log( iv_log_statement = |No documents found for step { <lv_ref_step> }| ).
    endif.
    append lines of lt_ptf_keys to lt_vbeln.
  endloop.


  if lines( lt_vbeln ) eq 0.
    ev_check_status = abap_false.
    ev_execution_status = abap_false.
    me->mo_run_environment->append_log( iv_log_statement = |Nothing to check.| ).
    return.
  endif.

  data: lt_billing_documents type t_vbeln.

  move-corresponding lt_vbeln to lt_billing_documents.

  lo_db_access = new cl_sd_bill_db_access( ).

  lo_db_access->select_vbrp_for_vbeln_tab(
    exporting
      it_vbeln = lt_billing_documents    " Table of billing documents
    importing
      et_vbrp  = data(lt_vbrp)           " Table Type for Billing Items
  ).

  sort lt_vbrp ascending by vcm_chain_uuid.
  delete adjacent duplicates from lt_vbrp comparing vcm_chain_uuid.


  loop at lt_vbrp assigning field-symbol(<ls_vbrp>).

    if <ls_vbrp>-vcm_chain_uuid is initial.
      me->mo_run_environment->append_log( iv_log_statement = |No VCM document exist for billing document { <ls_vbrp>-vbeln }  and item  { <ls_vbrp>-posnr } | ).
      lv_check_status = abap_false.
      exit.
    endif.

    lo_db_access->select_vbrk(
      exporting
        iv_vbeln = <ls_vbrp>-vbeln                 " Billing Document
      importing
        es_vbrk  = data(ls_vbrk)              " Billing Document: Header Data
    ).

    try .
        lv_vcm_guid = <ls_vbrp>-vcm_chain_uuid.
        data(lv_value_chain_type) = cl_vcm_app_query=>get_instance( )->get_value_chain_type( lv_vcm_guid ).

        lv_vcm_bo_object_id   = <ls_vbrp>-vbeln.
        lv_vcm_bo_obj_item_id = <ls_vbrp>-posnr.

        lv_document_type = ls_vbrk-vbtyp.

        lv_step_type = derive_step_type( iv_vbtyp                = ls_vbrk-vbtyp
                                         iv_vcm_chain_category   = <ls_vbrp>-vcm_chain_category
                                         iv_vcm_chain_element_id = <ls_vbrp>-vcm_chain_element_id ).


        data(lo_chain_item) = cl_vcm_app_query=>get_instance( )->get_value_chain_item(
                                                                value_chain_type        =  lv_value_chain_type
                                                                step_type               =  lv_step_type
                                                                business_object_id      =     lv_vcm_bo_object_id
                                                                business_object_item_id =   lv_vcm_bo_obj_item_id
                                                                chain_element_id        = <ls_vbrp>-vcm_chain_element_id
                                                                financial_chain_id      =    <ls_vbrp>-financial_chain_id ).


      catch cx_vcm_md_not_exists cx_vcm_rt_not_exists into data(lx_vcm_chain_item).
      catch cx_sd_billing into data(lx_sd_billing).
    endtry.

    try .
        data(lt_bo_item) = lo_chain_item->get_business_object_items( ).

      catch cx_vcm_rt_not_exists into lx_vcm_chain_item.
        " Error handling
    endtry.

    loop at lt_bo_item reference into data(lr_bo_item) where item-step_type = lv_step_type and item-cancelled is initial and item-deleted is initial.
      lv_vcm_vbeln = lr_bo_item->item-object_id.
      lv_vcm_posnr = lr_bo_item->item-item_id.
    endloop.
*      ENDIF.

    if lv_vcm_vbeln is initial .
      me->mo_run_environment->append_log( iv_log_statement = |No VCM entry exist for billing document { <ls_vbrp>-vbeln } and item { <ls_vbrp>-posnr } | ).
      lv_check_status = abap_false.
      exit.
    else.
      me->mo_run_environment->append_log( iv_log_statement = |VCM entry of step type { lv_step_type } found for document { lv_vcm_vbeln } and item { lv_vcm_posnr } | ).
    endif.
  endloop.

  if lv_check_status is not initial.
    ev_check_status = abap_false.
  endif.

  ev_execution_status = abap_true.

endmethod.


method check_vbrp_land_region.
  data: error_occured type abap_bool value abap_false.
  data lt_vbrp type hashed table of vbrp with unique key table_line.
  data doc_ids type table of vbeln.
  data lt_vbpa type table of vbpa.
  data: lvs_vbadr type vbadr.
  data ls_vbpa type vbpa.

  loop at step_data-reference_step assigning field-symbol(<ref_step>).
    data(ref_doc_ids) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
    loop at ref_doc_ids assigning field-symbol(<ref_doc_id>).
      append <ref_doc_id> to doc_ids.
    endloop.
  endloop.

  if doc_ids is initial.
    me->mo_run_environment->append_log( iv_log_statement = |No reference documents exist.| ).
    ev_check_status = abap_false.
    ev_execution_status = abap_false.
  else.

    select * from vbrp for all entries in @doc_ids where vbeln = @doc_ids-table_line into table @lt_vbrp.
    select * from vbpa for all entries in @doc_ids where vbeln = @doc_ids-table_line into table @lt_vbpa.

    loop at lt_vbrp assigning field-symbol(<ls_vbrp>).

      read table lt_vbpa assigning field-symbol(<ls_item_vbpa>) with key vbeln = <ls_vbrp>-vbeln
                                                                    posnr = <ls_vbrp>-posnr
                                                                    parvw = 'WL'.
      if <ls_item_vbpa> is assigned.
        ls_vbpa = <ls_item_vbpa>.
      else.
        read table lt_vbpa assigning field-symbol(<ls_header_vbpa>) with key vbeln = <ls_vbrp>-vbeln
                                                                      posnr = '000000'
                                                                      parvw = 'WL'.
        if <ls_header_vbpa> is assigned.
          ls_vbpa = <ls_header_vbpa>.
        endif.
      endif.

      call function 'SD_ADDRESS_GET'
        exporting
          fif_address_number      = ls_vbpa-adrnr
          fif_personal_number     = ls_vbpa-adrnp
          fif_address_type        = ls_vbpa-addr_type
        importing
          fes_address             = lvs_vbadr
        exceptions
          address_not_found       = 1
          address_type_not_exists = 2
          no_person_number        = 3.
      if sy-subrc <> 0.
        me->mo_run_environment->append_log( iv_log_statement = |Goods supplier { ls_vbpa-adrnr } address not found.| ).
        error_occured = abap_true.
        exit.
      endif.

      if lvs_vbadr-land1 = <ls_vbrp>-aland.
        me->mo_run_environment->append_log( iv_log_statement = | Land { <ls_vbrp>-aland } is same as goods supplier.| ).
        error_occured = abap_false.
      else.
        error_occured = abap_true.
        exit.
      endif.
      if lvs_vbadr-regio = <ls_vbrp>-wkreg.
        me->mo_run_environment->append_log( iv_log_statement = | Region { <ls_vbrp>-aland } is same as goods supplier.| ).
        error_occured = abap_false.
      else.
        error_occured = abap_true.
        exit.
      endif.
    endloop.

    if error_occured <> abap_true.
      ev_check_status = abap_true.
    else.
      ev_check_status = abap_false.
    endif.

    ev_execution_status = abap_true.
  endif.
endmethod.


  method create_with_vkorg.
    data:
      lt_vbfs               type shp_vbfs_t,
      ls_vbfs               type vbfs,
      lt_vbrkvb             type table of vbrkvb,
      ls_vbrkvb             type vbrkvb,
      lt_vbrpvb             type table of vbrpvb,
      ls_vbski              type vbsk,
      lt_komfk              type table of komfk,
      lt_komfkko            type table of komv,
      lt_thead              type table of theadvb,
      lt_vbss               type table of vbss,
      lt_komv               type komv_tab,
      lt_vbpavb             type vbpa_tab,

      ls_para_gn_inv_create type ty_gs_import_gn_invce_create,
      lt_komfkgn            type table of komfkgn,
      ls_komfkgn            type  komfkgn,
      lv_vbtyp              type vbtypl,
      lv_posnr              type posnr,
      lv_no_fin_doc         type char1,
      lv_billing_doc_number type vbeln,
      ls_return             type bapiret2,
      lt_return             type table of bapiret2,
      ls_testdata           type ty_gs_i_ptf_bd_cr_td,
      lt_vbeln              type cl_ptf_util=>ty_vbeln_tab,
      lv_is_successful      type abap_bool value abap_false,
      billing_doc_numbers   type standard table of vbeln with default key,
      lv_invoice_date       type dats.
*      ls_inv_msico_vkorg    type ty_msico_vkorg.


*************************************************************************

    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    if ls_step_data-variant is not initial.
      cl_ptf_util=>get_testdata(
        exporting
          is_step_data = ls_step_data
        importing
          es_testdata  = ls_testdata
      ).
    endif.

    "Determine invoice date
    if ls_testdata-invoice_date is initial and ls_testdata-delta_invoice_date is not initial.
      lv_invoice_date = sy-datlo + ls_testdata-delta_invoice_date.
    else.
      lv_invoice_date = ls_testdata-invoice_date.
    endif.




*************************************************************************
*Get Data of the predecessor

    data(lt_result_new) = me->mo_run_environment->get_result_key_data( it_step_number = ls_step_data-reference_step )."not used yet

    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_vbeln.
    endloop.


    "Add tdc reference
    if ls_testdata-hard_coded_reference is not initial.
      append ls_testdata-hard_coded_reference to lt_vbeln.
    endif.

    loop at lt_vbeln into data(ls_vbeln).
      check ls_vbeln-vbeln is not initial.

*Order-like
      clear lv_vbtyp.
      select single vbtyp from vbak into lv_vbtyp where vbeln = ls_vbeln-vbeln.
      if sy-subrc eq 0.
        clear ls_komfkgn.
        ls_komfkgn-mandt = sy-mandt.
        ls_komfkgn-fkdat = sy-datlo.
        ls_komfkgn-vgbel = ls_vbeln-vbeln.
        "ls_komfkgn-vgpos = lv_posnr.
        ls_komfkgn-vgtyp = lv_vbtyp.
        append ls_komfkgn to lt_komfkgn.
*      SELECT posnr FROM vbap INTO lv_posnr WHERE vbeln = ls_vbeln-vbeln.
*        ls_komfkgn-mandt = sy-mandt.
*        ls_komfkgn-fkdat = sy-datlo.
*        ls_komfkgn-vgbel = ls_vbeln-vbeln.
*        ls_komfkgn-vgpos = lv_posnr.
*        ls_komfkgn-vgtyp = lv_vbtyp.
*        APPEND ls_komfkgn TO lt_komfkgn.
*        CLEAR lv_posnr.
*      ENDSELECT.
      endif.
*Delivery
      clear lv_vbtyp.
      select single vbtyp from likp into lv_vbtyp where vbeln = ls_vbeln-vbeln.
      if sy-subrc eq 0.
        clear ls_komfkgn.
        ls_komfkgn-mandt = sy-mandt.
        ls_komfkgn-fkdat = sy-datlo.
        ls_komfkgn-vgbel = ls_vbeln-vbeln.
        "ls_komfkgn-vgpos = lv_posnr.
        ls_komfkgn-vgtyp = lv_vbtyp.
        ls_komfkgn-vkorg = ls_testdata-msico_vkorg.
        append ls_komfkgn to lt_komfkgn.
*      SELECT posnr FROM lips INTO lv_posnr WHERE vbeln = ls_vbeln-vbeln.
*        ls_komfkgn-mandt = sy-mandt.
*        ls_komfkgn-fkdat = sy-datlo.
*        ls_komfkgn-vgbel = ls_vbeln-vbeln.
*        ls_komfkgn-vgpos = lv_posnr.
*        ls_komfkgn-vgtyp = lv_vbtyp.
*        APPEND ls_komfkgn TO lt_komfkgn.
*        CLEAR lv_posnr.
*      ENDSELECT.
      endif.
*Billing Document or BDR
      clear lv_vbtyp.
      select single vbtyp from vbrk into lv_vbtyp where vbeln = ls_vbeln-vbeln.
      if sy-subrc eq 0.
        clear ls_komfkgn.
        ls_komfkgn-mandt = sy-mandt.
        ls_komfkgn-fkdat = sy-datlo.
        ls_komfkgn-vgbel = ls_vbeln-vbeln.
        "ls_komfkgn-vgpos = lv_posnr.
        ls_komfkgn-vgtyp = lv_vbtyp.
        append ls_komfkgn to lt_komfkgn.
*      SELECT posnr FROM vbrp INTO lv_posnr WHERE vbeln = ls_vbeln-vbeln.
*        ls_komfkgn-mandt = sy-mandt.
*        ls_komfkgn-fkdat = sy-datlo.
*        ls_komfkgn-vgbel = ls_vbeln-vbeln.
*        ls_komfkgn-vgpos = lv_posnr.
*        ls_komfkgn-vgtyp = lv_vbtyp.
*        APPEND ls_komfkgn TO lt_komfkgn.
*        CLEAR lv_posnr.
*      ENDSELECT.
      endif.
    endloop.

*    IF lv_read_prec_step_bo EQ abap_true.
*      LOOP AT lt_prec_doc INTO ls_prec_doc.
*        CLEAR ls_komfkgn.
*        ls_komfkgn-mandt = sy-mandt.
*        ls_komfkgn-fkdat = sy-datlo.
*        ls_komfkgn-vgbel = ls_prec_doc-vbeln.
*        ls_komfkgn-vgtyp = ls_prec_doc-vbtyp.
*        APPEND ls_komfkgn TO lt_komfkgn.
*      ENDLOOP.
*    ENDIF.

    me->mo_run_environment->append_log( iv_log_statement = |INVOICE CREATE is executed by class CL_PTF_BO_INVOICE.| ).
    if lt_komfkgn is initial.
      me->mo_run_environment->append_log( iv_log_statement = |There is no preceding document to be invoiced.| ).
      return.
    endif.
****************************************************************

    lv_no_fin_doc = ls_testdata-no_fin_doc.
    call function 'GN_INVOICE_CREATE'
      exporting
        vbsk_i                  = ls_para_gn_inv_create-vbsk_i
        with_posting            = 'D'  " ls_para_gn_inv_create-with_posting,  synchronous commit with error log
        delivery_date           = ls_para_gn_inv_create-delivery_date
        invoice_date            = lv_invoice_date
        invoice_type            = ls_testdata-invoice_type
        pricing_date            = ls_para_gn_inv_create-pricing_date
        caller_type             = ls_para_gn_inv_create-caller_type
        i_without_refresh       = ls_para_gn_inv_create-i_without_refresh
        id_no_enqueue           = ls_para_gn_inv_create-id_no_enqueue
        id_kvorg                = ls_para_gn_inv_create-id_kvorg
        id_no_dialog            = 'X' "ls_para_gn_inv_create-id_no_dialog
        id_new_cancellation     = ls_para_gn_inv_create-id_new_cancellation
        id_analyze_mode         = ls_para_gn_inv_create-id_analyze_mode
        id_no_fi_doc            = lv_no_fin_doc
        is_fi_add_input         = ls_para_gn_inv_create-is_fi_add_input
        id_sim_without_price    = ls_para_gn_inv_create-id_sim_without_price
        io_external_buffer      = ls_para_gn_inv_create-io_external_buffer
        i_no_collective_billing = ls_testdata-i_no_collective_billing
      tables
        xkomfk                  = lt_komfk
        xkomfkgn                = lt_komfkgn
        xkomfkko                = lt_komfkko
        xkomv                   = lt_komv
        xthead                  = lt_thead
        xvbfs                   = lt_vbfs
        xvbpa                   = lt_vbpavb
        xvbrk                   = lt_vbrkvb
        xvbrp                   = lt_vbrpvb
        xvbss                   = lt_vbss
      exceptions
        error_message           = 1.

    commit work and wait.

    clear ls_return.
    loop at lt_vbfs into ls_vbfs.
      message id ls_vbfs-msgid type ls_vbfs-msgty number ls_vbfs-msgno into ls_return-message with ls_vbfs-msgv1 ls_vbfs-msgv2 ls_vbfs-msgv3 ls_vbfs-msgv4.
      ls_return-id =  ls_vbfs-msgid.
      "ls_return-message = ls_vbfs-msgno.
      ls_return-message_v1 = ls_vbfs-msgv1.
      ls_return-message_v2 = ls_vbfs-msgv2.
      ls_return-message_v3 = ls_vbfs-msgv3.
      ls_return-message_v4 = ls_vbfs-msgv4.
      ls_return-type = ls_vbfs-msgty.
      if ls_vbfs-msgty eq 'S' or (
          ls_vbfs-msgty eq 'W' and ls_vbfs-vbeln ne '' "For test invoicing with no fin doc --> Only one message with msgtype w and text Document XX created (no fin doc)
        ).
        lv_is_successful = abap_true.
      endif.
      if ls_vbfs-msgty eq 'E'.
*        me->mo_run_environment->append_log( iv_log_statement = |(with MSGTY = ERROR:)| ).
      endif.
      me->mo_run_environment->append_log( iv_log_statement = |{ '(' && ls_vbfs-msgty && ')' && ls_return-message }| ).
*********************
      data ls_t100 type ptf_t100_message.
      data lt_t100 type ptf_t100_message_t.
      ls_t100-type       = ls_vbfs-msgty.
      ls_t100-id         = ls_vbfs-msgid.
      ls_t100-number     = ls_vbfs-msgno.
      ls_t100-message_v1 = ls_vbfs-msgv1.
      ls_t100-message_v2 = ls_vbfs-msgv2.
      ls_t100-message_v3 = ls_vbfs-msgv3.
      ls_t100-message_v4 = ls_vbfs-msgv4.
      append ls_t100 to lt_t100.
*********************
    endloop.
    cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~add_actual_messages( lt_t100 ).

*    #########################################################################################################################
*Workaround to refresh sales doc. This function call has to be done in RV_INVOICE_REFRESH
    call function 'SD_BUFFER_TABLES_REFRESH'.
    call function 'LE_DELIVERY_REFRESH_BUFFER'.
*    #########################################################################################################################
    if lv_is_successful eq abap_false.
      ev_execution_status = abap_false.
      return.
    endif.
    loop at lt_vbeln into ls_vbeln.
      if ls_testdata-invoice_type is initial.
        select distinct vbeln into table @billing_doc_numbers from vbrp where vgbel = @ls_vbeln-vbeln
          and ( vbeln not like 'PBD%' and vbeln not like '$%' and vbeln not like 'S%' and vbeln not like 'TMP%' ).
      else.
        select distinct vbeln into table @billing_doc_numbers from vbrp where vgbel = @ls_vbeln-vbeln and fkart_ana = @ls_testdata-invoice_type
          and ( vbeln not like 'PBD%' and vbeln not like '$%' and vbeln not like 'S%' and vbeln not like 'TMP%' ).
      endif.

      if sy-subrc eq 0.
        loop at billing_doc_numbers into lv_billing_doc_number.
          "ev_document_id should only contain billing documents created in this method call
          if line_exists( lt_vbss[ vbeln = lv_billing_doc_number ] ).
            try.
                data(already_exists) = ev_document_id[ vbeln = lv_billing_doc_number ].
              catch  cx_sy_itab_line_not_found into data(exp_cn).
                append lv_billing_doc_number to ev_document_id.
            endtry.
          endif.
        endloop.
        me->mo_run_environment->append_log( iv_log_statement = |Billing Document { lv_billing_doc_number } was created successfully for Document { ls_vbeln-vbeln }| ).
        ev_execution_status = abap_true.
      else.
        me->mo_run_environment->append_log( iv_log_statement = |No Billing Document was created for Document { ls_vbeln-vbeln }| ).
        ev_execution_status = abap_false.
      endif.
    endloop.
    "  DELETE ADJACENT DUPLICATES FROM ev_document_id COMPARING vbeln.

    call function 'RV_INVOICE_REFRESH'
      exporting
        with_posting = 'D'
      tables
        xkomfk       = lt_komfk
        xkomv        = lt_komv
        xthead       = lt_thead
        xvbfs        = lt_vbfs
        xvbpa        = lt_vbpavb
        xvbrk        = lt_vbrkvb
        xvbrp        = lt_vbrpvb
        xvbss        = lt_vbss.
  endmethod.


  method derive_step_type.

    constants mc_stepype_customer_invoice       type vcm_step_type_id value 'CISC'.
    constants mc_stepype_msic_invoice           type vcm_step_type_id value 'DC_CI'.
    constants mc_steptype_msic_intmd_invoice    type vcm_step_type_id value 'IC_CI'.
    constants mc_steptype_mscust_invoice        type vcm_step_type_id value 'SC_CI'.
    constants mc_chain_cat_advico               type vcm_chain_category value 'ICSL'.
    constants mc_chain_cat_advstocktransfer     type vcm_chain_category value 'ICST'.
    constants mc_chain_cat_advprocuretostock     type vcm_chain_category value 'P2SV'.
    constants mc_chain_cat_msico                type vcm_chain_category value 'MISL'.
    constants mc_chain_cat_msico_stock                type vcm_chain_category value 'MIST'.
    constants mc_chain_cat_advsellfromstock     type vcm_chain_category value 'SFSV'.
    constants mc_chain_cat_icsubcontracting     type vcm_chain_category value 'ICSC'.
    constants mc_stepype_intercomany_invoice    type vcm_step_type_id value 'CIIC'.
    constants mc_msgid_billing                  type sy-msgid value 'VF'.
    constants mc_msgno_vcm_error                type sy-msgno value '475'.
    constants mc_msgno_invalid_doctype          type sy-msgno value '452'.
    constants mc_one                            type vcm_chain_element_id value '1'.
    constants mc_msgno_technical_error          type sy-msgno value '899'.

    if iv_vcm_chain_category = mc_chain_cat_advico or
     iv_vcm_chain_category = mc_chain_cat_advstocktransfer or
     iv_vcm_chain_category = mc_chain_cat_advprocuretostock or
     iv_vcm_chain_category = mc_chain_cat_advsellfromstock or
     iv_vcm_chain_category = mc_chain_cat_icsubcontracting.
      rv_step_type = switch #( iv_vbtyp
                                 when if_sd_doc_category=>invoice or if_sd_doc_category=>invoice_cancel then mc_stepype_customer_invoice
                                 when if_sd_doc_category=>intercompany_invoice or if_sd_doc_category=>intercompany_credit_memo then mc_stepype_intercomany_invoice
                                 else throw cx_sd_billing( textid = value #( msgid = mc_msgid_billing msgno = mc_msgno_invalid_doctype attr1 = iv_vbtyp ) ) ).
    elseif iv_vcm_chain_category = mc_chain_cat_msico or
          iv_vcm_chain_category =  mc_chain_cat_msico_stock.
      rv_step_type = cond #(   when  iv_vbtyp = if_sd_doc_category=>invoice or iv_vbtyp = if_sd_doc_category=>invoice_cancel then mc_steptype_mscust_invoice
                               when ( iv_vbtyp = if_sd_doc_category=>intercompany_invoice or iv_vbtyp = if_sd_doc_category=>intercompany_credit_memo )
                                    and iv_vcm_chain_element_id = mc_one then mc_stepype_msic_invoice
                               when ( iv_vbtyp = if_sd_doc_category=>intercompany_invoice or iv_vbtyp = if_sd_doc_category=>intercompany_credit_memo )
                                     and iv_vcm_chain_element_id > mc_one then mc_steptype_msic_intmd_invoice
                               else throw cx_sd_billing( textid = value #( msgid = mc_msgid_billing msgno = mc_msgno_invalid_doctype attr1 = iv_vbtyp ) ) ).
    endif.
  endmethod.


method check_vbrp_with_tvap.
  data: error_occured type abap_bool value abap_false.
  data lt_vbrp type hashed table of vbrp with unique key table_line.
  data lt_vbrk type table of vbrk.
  data doc_ids type table of vbeln.
  data lt_tvap type tdtb_tvap.
  data lt_vbap type tab_vbap.

  field-symbols <ls_tvap> type tvap.
  field-symbols <ls_vbap> type vbap.
  field-symbols <ls_batch_mainitem_vbrp> type vbrp.


  loop at step_data-reference_step assigning field-symbol(<ref_step>).
    data(ref_doc_ids) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
    loop at ref_doc_ids assigning field-symbol(<ref_doc_id>).
      append <ref_doc_id> to doc_ids.
    endloop.
  endloop.

  if doc_ids is initial.
    me->mo_run_environment->append_log( iv_log_statement = |No reference documents exist.| ).
    ev_check_status = abap_false.
    ev_execution_status = abap_false.
  else.
    select * from vbrk for all entries in @doc_ids where vbeln = @doc_ids-table_line into table @lt_vbrk.
    read table lt_vbrk assigning field-symbol(<ls_vbrk>) index 1.
    if ( <ls_vbrk> is assigned ) and ( not cl_sd_doc_category_util=>is_any_intercompany( iv_vbtyp = <ls_vbrk>-vbtyp ) ).
      ev_check_status = abap_true.
      ev_execution_status = abap_true.
      return.
    endif.

    select * from vbrp for all entries in @doc_ids where vbeln = @doc_ids-table_line into table @lt_vbrp.
    check sy-subrc = 0.
    select * from vbap for all entries in @lt_vbrp where vbeln = @lt_vbrp-aubel and
                                                         posnr = @lt_vbrp-aupos  into table @lt_vbap. "#EC CI_FAE_LINES_ENSURED or "#EC CI_FAE_NO_LINES_OK
    check sy-subrc = 0.
    select * from tvap for all entries in @lt_vbap where pstyv = @lt_vbap-pstyv  into table @lt_tvap. "#EC CI_FAE_LINES_ENSURED or "#EC CI_FAE_NO_LINES_OK´

    loop at lt_vbrp assigning field-symbol(<ls_vbrp>).

      if <ls_vbrp>-uecha is not initial and <ls_vbrp>-uecha <> <ls_vbrp>-posnr.
* For batch items
        read table lt_vbrp assigning <ls_batch_mainitem_vbrp> with key posnr = <ls_vbrp>-uecha.
        if <ls_batch_mainitem_vbrp> is assigned.
          read table lt_vbap assigning <ls_vbap> with key vbeln = <ls_batch_mainitem_vbrp>-aubel
                                                          posnr = <ls_batch_mainitem_vbrp>-aupos.
          read table lt_tvap assigning <ls_tvap> with key pstyv = <ls_vbap>-pstyv.
          check <ls_tvap> is assigned.
        endif.
      else.
* For Non-batch items
        read table lt_vbap assigning <ls_vbap> with key vbeln = <ls_vbrp>-aubel
                                                        posnr = <ls_vbrp>-aupos.
        read table lt_tvap assigning <ls_tvap> with key pstyv = <ls_vbap>-pstyv.
        check <ls_tvap> is assigned.
      endif.

      if <ls_tvap>-prsfd = <ls_vbrp>-prsfd.
        me->mo_run_environment->append_log( iv_log_statement = | Pricing relevance { <ls_vbrp>-pstyv } is matched.| ).
        error_occured = abap_false.
      else.
        error_occured = abap_true.
        exit.
      endif.
      if <ls_tvap>-kowrr = <ls_vbrp>-kowrr.
        me->mo_run_environment->append_log( iv_log_statement = | Statistical value { <ls_vbrp>-kowrr } is matched.| ).
        error_occured = abap_false.
      else.
        error_occured = abap_true.
        exit.
      endif.
      if <ls_tvap>-posar = <ls_vbrp>-posar.
        me->mo_run_environment->append_log( iv_log_statement = | Item type { <ls_vbrp>-posar } is matched.| ).
        error_occured = abap_false.
      else.
        error_occured = abap_true.
        exit.
      endif.
    endloop.

    if error_occured <> abap_true.
      ev_check_status = abap_true.
    else.
      ev_check_status = abap_false.
    endif.

    ev_execution_status = abap_true.
  endif.
endmethod.


method check_ico_scenario_split_inv.

  data: lv_vbeln_vf       type vbeln,
        lt_vbeln_vf       type cl_ptf_util=>ty_vbeln_tab,
        ls_vbrk           type vbrk,
        lv_error          type c,
        lt_vbrp           type tab_vbrp,
        lv_scenario_check type boolean value abap_false.

  field-symbols <ls_vbrp> type vbrp.


  data(ls_step_data_this_check) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

  ev_check_status = abap_false.

  loop at ls_step_data_this_check-reference_step assigning field-symbol(<lv_ref_step>).
    data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
    append lines of lt_ptf_keys to lt_vbeln_vf.
  endloop.
  if lt_vbeln_vf is initial.
    me->mo_run_environment->append_log( 'There are no BillDocIDs to check!' ).
    return.
  endif.

  loop at lt_vbeln_vf into lv_vbeln_vf.
    if lv_vbeln_vf is initial.
      me->mo_run_environment->append_log( 'Initial VBELN!' ).
      lv_error = abap_true.
      continue.
    endif.
    select single * from vbrk into ls_vbrk where vbeln = lv_vbeln_vf.
    if sy-subrc is not initial.
      me->mo_run_environment->append_log( |BillingDoc { lv_vbeln_vf } not found. | ).
      lv_error = abap_true.
      continue.
    endif.
    select * from vbrp into table lt_vbrp where vbeln =  lv_vbeln_vf.
    if ls_vbrk-vbtyp = '5' or ls_vbrk-vbtyp = '6'.
      read table lt_vbrp assigning <ls_vbrp> index 1.

      if <ls_vbrp> is assigned.
        case <ls_vbrp>-vcm_chain_category.
          when 'MISL' or 'MIST'.
            if ls_vbrk-ico_scenario = 'M'.
              lv_scenario_check = abap_true.
            endif.
          when 'ICSL' or 'ICST'.
            if ls_vbrk-ico_scenario = 'A'.
              lv_scenario_check = abap_true.
            endif.
          when ''.
            if ls_vbrk-ico_scenario = 'C'.
              lv_scenario_check = abap_true.
            endif.
          when others.
            exit.
        endcase.
      endif.
    else.
      if ls_vbrk-ico_scenario = ''.
        lv_scenario_check = abap_true.
      endif.
    endif.


    if lv_scenario_check = abap_true.
      me->mo_run_environment->append_log( |XVBRK-ico_scenario { ls_vbrk-ico_scenario } Intercompany Scenario is correct.| ).
    else.
      me->mo_run_environment->append_log( |XVBRK-ico_scenario { ls_vbrk-ico_scenario } deviates from the expected results { lv_vbeln_vf } .| ).
      lv_error = abap_true.
    endif.
  endloop.

  if lv_error ne abap_true.
    ev_check_status     = abap_true.
    ev_execution_status = abap_true.
  endif.

endmethod.


method check_wavwr_ms_ico.
  types:
    begin of ty_vcm_object_id,
      vbeln   type vbeln,
      vb_year type gjahr,
    end of ty_vcm_object_id.

  data:
    ls_testdata           type ty_gs_ptf_bd_check_td,
    lt_vbeln              type cl_ptf_util=>ty_vbeln_tab,
    lv_vbeln              type vbeln_va,
    ls_vbeln              type cl_ptf_util=>ty_vbeln,
    lt_billing_key        type table of sales_key,
    lt_vbfa               type table of vbfa,
    lv_vcm_guid           type vcm_uuid,
    lv_vcm_bo_object_id   type vcm_business_object_id,
    lv_vcm_bo_obj_item_id type vcm_business_object_item_id,
    lv_gitc_vbeln         type ty_vcm_object_id,
    lv_gitc_posnr         type posnr,
    lt_docflow            type sorted table of vbfa with non-unique key vbeln posnn vbtyp_v erdat erzet,
    lv_qty_in_meins       type fklmg,
    lv_wavwr              type wavwr.


  types:
    begin of ty_bo_item,
      step_type        type vcm_step_type_id,
      object_id        type vcm_business_object_id,
      item_id          type vcm_business_object_item_id,
      chain_element_id type vcm_chain_element_id,
      object_type      type vcm_business_object,
      deleted          type vcm_boolean,
      cancelled        type vcm_boolean,
    end of ty_bo_item .
  types:
    tt_bo_item type standard table of ty_bo_item with default key .
  types:
    begin of ty_item_tuple,
      item        type ty_bo_item,
      predecessor type ty_bo_item,
    end of ty_item_tuple .
  types:
    tt_item_tuple type standard table of ty_item_tuple with default key .

  data: ls_vbrk                type vbrk,
        lv_vcm_bo_obj_category type vcm_business_object_cat,
        lt_steps               type tt_vcm_rt_ms_steptp,
        lv_step_type           type vcm_step_type_id,
        lv_value_chain_type    type vcm_value_chain_type,
        lo_chain_item          type ref to if_vcm_value_chain_item_read,
        lt_gitc_item           type tt_bo_item,
        lt_bo_item             type tt_item_tuple,
        lv_target_step_type    type vcm_step_type_id.

  field-symbols: <ls_steps> type vcm_rt_ms_steptp.
  constants: lc_material_document type vcm_business_object value   'MATERIAL_DOCUMENT',
             lc_ms_step_type      type vcm_step_type_id value      'DC_OD'.


  data: lo_db_access type ref to cl_sd_bill_db_access.

  ev_check_status = abap_true.
  ev_execution_status = abap_false.

* ----------------------------------------------- get test data -----
  data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
  cl_ptf_util=>get_testdata(
    exporting
      is_step_data = ls_step_data
    importing
      es_testdata  = ls_testdata ).

* --------------- get billing document number from reference step -----
  loop at step_data-reference_step assigning field-symbol(<lv_ref_step>).
    data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
    if lines( lt_ptf_keys ) eq 0.
      me->mo_run_environment->append_log( iv_log_statement = |No documents found for step { <lv_ref_step> }| ).
    endif.
    append lines of lt_ptf_keys to lt_vbeln.
  endloop.


  if lines( lt_vbeln ) eq 0.
    ev_check_status = abap_false.
    ev_execution_status = abap_false.
    me->mo_run_environment->append_log( iv_log_statement = |Nothing to check.| ).
    return.
  endif.

  data: lt_billing_documents type t_vbeln.

  move-corresponding lt_vbeln to lt_billing_documents.

  lo_db_access = new cl_sd_bill_db_access( ).

  lo_db_access->select_vbrp_for_vbeln_tab(
    exporting
      it_vbeln = lt_billing_documents         " Table of billing documents
    importing
      et_vbrp  = data(lt_vbrp)           " Table Type for Billing Items
  ).


  select * from vbfa for all entries in @lt_vbrp
      where vbelv   = @lt_vbrp-vgbel and
            posnv   = @lt_vbrp-vgpos and
            vbtyp_v = @if_sd_doc_category=>delivery
      into table @lt_docflow.

  data(lo_sdbil_core_factory) = cl_sdbil_core_factory=>get( )->get_sdbil_vcm_util( ).

  loop at lt_vbrp into data(ls_vbrp).

    select single * from vbrk into ls_vbrk where vbeln = ls_vbrp-vbeln .

    if ls_vbrp-vcm_chain_uuid is initial.
      me->mo_run_environment->append_log( iv_log_statement = |No VCM documents found for step { <lv_ref_step> }| ).
      ev_check_status = abap_false.
      exit.
    endif.

    lv_vcm_guid = ls_vbrp-vcm_chain_uuid.
    lv_vcm_bo_obj_category = lo_sdbil_core_factory->detmn_bo_cat_for_matl_doc( iv_vbtyp = ls_vbrk-vbtyp ).
    check lv_vcm_bo_obj_category is not initial.
    lt_steps =  cl_vcm_app_query=>get_instance( )->get_steps_by_bo_and_block( value_chain_guid    =   lv_vcm_guid
                                                                                    business_object     =  lc_material_document
                                                                                    business_object_cat =   lv_vcm_bo_obj_category
                                                                                    chain_element_id    =  ls_vbrp-vcm_chain_element_id ).
    read table lt_steps assigning <ls_steps> with key business_object = lc_material_document
                                                                 business_object_cat = lv_vcm_bo_obj_category
                                                                 chain_element_id = ls_vbrp-vcm_chain_element_id.
    if  <ls_steps> is assigned and sy-subrc = 0.
      lv_step_type = lc_ms_step_type.
      lv_target_step_type  = <ls_steps>-step_type.
    endif.

    try .

        lv_value_chain_type = cl_vcm_app_query=>get_instance( )->get_value_chain_type( lv_vcm_guid ).

        lv_vcm_bo_object_id   = ls_vbrp-vgbel.
        lv_vcm_bo_obj_item_id = ls_vbrp-vgpos.
        lo_chain_item = cl_vcm_app_query=>get_instance( )->get_value_chain_item( value_chain_type        = lv_value_chain_type
                                                                                       step_type               = lv_step_type
                                                                                       business_object_id      = lv_vcm_bo_object_id
                                                                                       business_object_item_id = lv_vcm_bo_obj_item_id ).

        lt_gitc_item = lo_chain_item->get_bus_obj_items_for_item( step_type        = lv_step_type
                                                                  object_id        = lv_vcm_bo_object_id
                                                                  item_id          = lv_vcm_bo_obj_item_id
                                                                  target_step_type = lv_target_step_type ).

      catch cx_vcm_md_not_exists cx_vcm_rt_not_exists into data(lx_vcm_chain_item).
        " Error handling
    endtry.

    loop at lt_gitc_item reference into data(lr_gitc_item) where cancelled is initial     and
                                                                 deleted is initial       and
                                                                 chain_element_id = ls_vbrp-vcm_chain_element_id..
      lv_gitc_vbeln = lr_gitc_item->object_id.
      lv_gitc_posnr = lr_gitc_item->item_id.
    endloop.
    if lv_gitc_vbeln is initial.
      try .
          lt_bo_item = lo_chain_item->get_business_object_items( ).

        catch cx_vcm_rt_not_exists into lx_vcm_chain_item.
          " Error handling
      endtry.

      loop at lt_bo_item reference into data(lr_bo_item) where item-step_type = lv_target_step_type and
                                                               item-cancelled is initial            and
                                                               item-deleted is initial              and
                                                               item-chain_element_id = ls_vbrp-vcm_chain_element_id..
        lv_gitc_vbeln = lr_bo_item->item-object_id.
        lv_gitc_posnr = lr_bo_item->item-item_id.
      endloop.
    endif.

    if lv_gitc_vbeln is initial .
      me->mo_run_environment->append_log( iv_log_statement = |No material documents found in VCM for step{ <lv_ref_step> }| ).
      ev_check_status = abap_false.
      exit.
    endif.

    read table lt_docflow with key vbelv = ls_vbrp-vgbel posnv = ls_vbrp-vgpos vbeln = lv_gitc_vbeln-vbeln posnn = lv_gitc_posnr reference into data(lr_xvbfa).

    if sy-subrc is not initial.
      me->mo_run_environment->append_log( iv_log_statement = |Material document not found in VCM for step{ <lv_ref_step> }| ).
      ev_check_status = abap_false.
      exit.
    endif.

    lv_qty_in_meins = ls_vbrp-fkimg * ls_vbrp-umvkz / ls_vbrp-umvkn.
    if lr_xvbfa->rfmng eq lv_qty_in_meins.
      lv_wavwr = lr_xvbfa->rfwrt.
    elseif lr_xvbfa->rfmng is not initial.
      lv_wavwr = lr_xvbfa->rfwrt / lr_xvbfa->rfmng * lv_qty_in_meins.
    endif.

    if lv_wavwr eq ls_vbrp-wavwr.
      me->mo_run_environment->append_log( iv_log_statement = |Field WAVWR is correctly filled { <lv_ref_step> }| ).
      ev_check_status = abap_true.
    else.
      me->mo_run_environment->append_log( iv_log_statement = |Field WAVWR is not equal{ <lv_ref_step> }| ).
      ev_check_status = abap_false.
      exit.
    endif.
  endloop.

  ev_execution_status = abap_true.

endmethod.
ENDCLASS.
