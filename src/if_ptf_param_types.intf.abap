INTERFACE if_ptf_param_types
  PUBLIC .


*  types TY_GS_PTF_PAYMENTCARD_CHECK_TD type SDBIL_ESR_BDR_PAYMENT_CARD_TAB .
***********************************************************
** Types for Method parameters
*  types GT_PTF_RETURN_TAB type CL_PTF_UTIL=>GT_PTF_RETURN_TAB .
*  types GT_PTF_STEP type CL_PTF_UTIL=>GT_PTF_STEP .
*  types:
*    gt_ptf_step_tab TYPE TABLE OF cl_ptf_util=>gt_ptf_step .
*  types:
*******************************************************
*** Structure for Item List
*    BEGIN OF ty_gs_item_list_td,
*      material_id TYPE matnr,
*      quantity    TYPE dzmeng,
*      posnr       TYPE posnr_va,
*      fkdat       TYPE fkdat,
*      werks       TYPE werks_d,
*    END OF ty_gs_item_list_td .
*  types:
*** Structure for extensibility field
*    BEGIN OF ty_gs_ext_field_td,
*      name           TYPE string,
*      type           TYPE string,
*      data_type      TYPE string,
*      expected_input TYPE string,
*    END OF ty_gs_ext_field_td .
*  types:
*** Table for extensibility field
*    ty_gt_ext_field_td      TYPE STANDARD TABLE OF ty_gs_ext_field_td WITH NON-UNIQUE KEY name .
*  types:
*** Table for Item List
*    lty_sales_conditions_in TYPE STANDARD TABLE OF bapicond  WITH DEFAULT KEY .
*  types:
*    ty_gt_item_list_td      TYPE STANDARD TABLE OF ty_gs_item_list_td WITH NON-UNIQUE KEY posnr .
*  types:
*    ty_order_partners       TYPE STANDARD TABLE OF bapiparnr WITH DEFAULT KEY .
*  types:
*    BEGIN OF ty_gs_i_ptf_ext_field_check_td,
*      ext_fields TYPE ty_gt_ext_field_td,
*    END OF ty_gs_i_ptf_ext_field_check_td .
*  types:
*    ty_bapisdtext TYPE STANDARD TABLE OF bapisdtext WITH DEFAULT KEY .
*  types:
*** Structure for DMR create
*    BEGIN OF ty_gs_i_ptf_dmr_cr_td,
*      document_type        TYPE auart,
*      sales_organization   TYPE vkorg,
*      distribution_channel TYPE vtweg,
*      division             TYPE spart,
*      customer_id          TYPE kunnr,
*      order_reason         TYPE augru,
*      billing_block        TYPE faksk,
*      item_list            TYPE ty_gt_item_list_td,
*      condition            TYPE lty_sales_conditions_in,
*      order_partners       TYPE ty_order_partners,
*      ext_fields_item      TYPE ty_gt_ext_field_td,
*      sales_text           TYPE ty_bapisdtext,
*    END OF ty_gs_i_ptf_dmr_cr_td .
*  types:
*** Structure for DMR create with reference
*    BEGIN OF ty_gs_i_ptf_dmr_cr_with_ref_td,
*      document_type TYPE auart,
*    END OF ty_gs_i_ptf_dmr_cr_with_ref_td .
*  types:
*** Structure for CMR create
*    BEGIN OF ty_gs_i_ptf_cmr_cr_td,
*      document_type        TYPE auart,
*      sales_organization   TYPE vkorg,
*      distribution_channel TYPE vtweg,
*      division             TYPE spart,
*      customer_id          TYPE kunnr,
*      order_reason         TYPE augru,
*      billing_block        TYPE faksk,
*      item_list            TYPE ty_gt_item_list_td,
*      condition            TYPE lty_sales_conditions_in,
*      order_partners       TYPE ty_order_partners,
*      ext_fields_item      TYPE ty_gt_ext_field_td,
*    END OF ty_gs_i_ptf_cmr_cr_td .
*  types:
*** Structure for CMR create with reference
*    BEGIN OF ty_gs_i_ptf_cmr_cr_with_ref_td,
*      document_type TYPE auart,
*    END OF ty_gs_i_ptf_cmr_cr_with_ref_td .
*  types:
*** Structure for DMR change
*    BEGIN OF ty_gs_i_ptf_dmr_ch_td,
*      document_type        TYPE auart,
*      sales_organization   TYPE vkorg,
*      distribution_channel TYPE vtweg,
*      division             TYPE spart,
*      customer_id          TYPE kunnr,
*      order_reason         TYPE augru,
*      billing_block        TYPE faksk,
*      item_list            TYPE ty_gt_item_list_td,
*    END OF ty_gs_i_ptf_dmr_ch_td .
*  types:
*** Structure for CMR change
*    BEGIN OF ty_gs_i_ptf_cmr_ch_td,
*      document_type        TYPE auart,
*      sales_organization   TYPE vkorg,
*      distribution_channel TYPE vtweg,
*      division             TYPE spart,
*      customer_id          TYPE kunnr,
*      order_reason         TYPE augru,
*      billing_block        TYPE faksk,
*      item_list            TYPE ty_gt_item_list_td,
*    END OF ty_gs_i_ptf_cmr_ch_td .
*  types:
** Structure for DMR Add Billing Block
*    BEGIN OF ty_gs_i_ptf_dmr_adbb_td,
*      document_type        TYPE auart,
*      sales_organization   TYPE vkorg,
*      distribution_channel TYPE vtweg,
*      division             TYPE spart,
*      customer_id          TYPE kunnr,
*      order_reason         TYPE augru,
*      billing_block        TYPE faksk,
*      item_list            TYPE ty_gt_item_list_td,
*    END OF ty_gs_i_ptf_dmr_adbb_td .
*  types:
** Structure for DMR Add Billing Block
*    BEGIN OF ty_gs_i_ptf_dmr_rebb_td,
*      document_type        TYPE auart,
*      sales_organization   TYPE vkorg,
*      distribution_channel TYPE vtweg,
*      division             TYPE spart,
*      customer_id          TYPE kunnr,
*      order_reason         TYPE augru,
*      billing_block        TYPE faksk,
*      item_list            TYPE ty_gt_item_list_td,
*    END OF ty_gs_i_ptf_dmr_rebb_td .
*  types:
** Structure for Inquiry create
*    BEGIN OF ty_gs_i_ptf_inquiry_cr_td,
*      document_type        TYPE auart,
*      sales_organization   TYPE vkorg,
*      distribution_channel TYPE vtweg,
*      division             TYPE spart,
*      customer_id          TYPE kunnr,
*      order_reason         TYPE augru,
*      billing_block        TYPE faksk,
*      item_list            TYPE ty_gt_item_list_td,
*    END OF ty_gs_i_ptf_inquiry_cr_td .
*  types:
** Structure for Quote create
*    BEGIN OF ty_gs_i_ptf_quote_cr_td,
*      document_type        TYPE auart,
*      sales_organization   TYPE vkorg,
*      distribution_channel TYPE vtweg,
*      division             TYPE spart,
*      customer_id          TYPE kunnr,
*      order_reason         TYPE augru,
*      billing_block        TYPE faksk,
*      valid_to_date        TYPE bnddt,
*      item_list            TYPE ty_gt_item_list_td,
*    END OF ty_gs_i_ptf_quote_cr_td .
*  types:
** Structure for Quote change
*    BEGIN OF ty_gs_i_ptf_quote_ch_td,
*      document_type        TYPE auart,
*      sales_organization   TYPE vkorg,
*      distribution_channel TYPE vtweg,
*      division             TYPE spart,
*      customer_id          TYPE kunnr,
*      order_reason         TYPE augru,
*      billing_block        TYPE faksk,
*      valid_to_date        TYPE bnddt,
*      item_list            TYPE ty_gt_item_list_td,
*    END OF ty_gs_i_ptf_quote_ch_td .
*  types:
** Structure for Standard Order (TA/OR) create
*    BEGIN OF ty_gs_i_ptf_or_cr_td,
*      document_type        TYPE auart,
*      sales_organization   TYPE vkorg,
*      distribution_channel TYPE vtweg,
*      division             TYPE spart,
*      customer_id          TYPE kunnr,
*      order_reason         TYPE augru,
*      billing_block        TYPE faksk,
*      item_list            TYPE ty_gt_item_list_td,
*      order_partners       TYPE ty_order_partners,
*      condition            TYPE lty_sales_conditions_in,
*      ext_fields_item      TYPE ty_gt_ext_field_td,
*      sales_text           TYPE ty_bapisdtext,
*    END OF ty_gs_i_ptf_or_cr_td .
*  types:
*** Structure for Standard Order create with reference
*    BEGIN OF ty_gs_i_ptf_or_cr_with_ref_td,
*      document_type TYPE auart,
*    END OF ty_gs_i_ptf_or_cr_with_ref_td .
*  types:
** Structure for Standard Order (TA/OR) change
*    BEGIN OF ty_gs_i_ptf_or_ch_td,
*      document_type        TYPE auart,
*      sales_organization   TYPE vkorg,
*      distribution_channel TYPE vtweg,
*      division             TYPE spart,
*      customer_id          TYPE kunnr,
*      order_reason         TYPE augru,
*      billing_block        TYPE faksk,
*      item_list            TYPE ty_gt_item_list_td,
*    END OF ty_gs_i_ptf_or_ch_td .
*  types:
** Structure for External Billing Document Request Create
*    BEGIN OF ty_gs_i_ptf_ebdr_cr_td,
*      ebdr_request_in   TYPE bapiebdrrequest_t,
*      ebdr_requ_cond_in TYPE bapiebdrrequestcond_t,
*      ebdr_requ_text_in TYPE bapiebdrrequesttext_t,
*    END OF ty_gs_i_ptf_ebdr_cr_td .
*  types:
*    ty_ebdr_requests    TYPE STANDARD TABLE OF ty_gs_i_ptf_ebdr_cr_td WITH DEFAULT KEY .
*  types:
*    BEGIN OF ty_gs_i_ptf_ebdr_cr_mult_td,
*      ebdr_requests TYPE ty_ebdr_requests,
*    END OF ty_gs_i_ptf_ebdr_cr_mult_td .
*  types:
** Structure for External Billing Document Request Create for negative testing
*    BEGIN OF ty_gs_i_ptf_ebdr_cr_neg_td,
*      senderlogicalsystem         TYPE string,
*      determine_precedingdocument TYPE abap_bool,
*      ebdr_request_in             TYPE bapiebdrrequest_t,
*      ebdr_requ_cond_in           TYPE bapiebdrrequestcond_t,
*      ebdr_requ_text_in           TYPE bapiebdrrequesttext_t,
*    END OF ty_gs_i_ptf_ebdr_cr_neg_td .
*  types:
** Structure for External Billing Document Request Create (SOA/ESR/Proxy)
*    BEGIN OF ty_gs_i_ptf_ebdr_cr_ws_td,
*      bdr_request_msg      TYPE sdbil_esr_bdr_request_msg,
*      bdr_confirmation_msg TYPE sdbil_esr_bdr_confirmation_msg,
*    END OF ty_gs_i_ptf_ebdr_cr_ws_td .
*  types:
** Structure for External Billing Document Create (SOA/ESR/Proxy)
*    BEGIN OF ty_gs_i_ptf_bd_cr_ws_td,
*      bd_request_msg TYPE sdbil_esr_bd_request_msg,
*    END OF ty_gs_i_ptf_bd_cr_ws_td .
*  types:
** Structure Billing Document Create
*    BEGIN OF ty_gs_i_ptf_bd_cr_td,
*      invoice_type            TYPE fkart,
*      invoice_date            TYPE fkdat,
*      i_no_collective_billing TYPE abap_bool,
*      no_fin_doc            TYPE string,
*    END OF ty_gs_i_ptf_bd_cr_td .
*  types:
** Control structure: create BDR with reference
*    BEGIN OF ty_gs_i_ptf_ebdr_cr_ref_td,
*      with_cond_table TYPE abap_bool,
*      with_knumv      TYPE abap_bool,
*    END OF ty_gs_i_ptf_ebdr_cr_ref_td .
*  types:
*** Structure for EBDR event
*    BEGIN OF ty_gs_i_ptf_ebdr_event_td,
*      event TYPE sibfevent,
*    END OF ty_gs_i_ptf_ebdr_event_td .
*  types:
** Structure for changing texts in PBD
*    ty_thead_tab  TYPE STANDARD TABLE OF thead WITH DEFAULT KEY .
*  types:
*    ty_lines_tab TYPE STANDARD TABLE OF tline WITH DEFAULT KEY .
*  types:
*    BEGIN OF ty_gs_i_ptf_pbd_chtxt_td,
*      lt_thead      TYPE ty_thead_tab,
*      lt_lines_head TYPE ty_lines_tab,
*      lt_lines_item TYPE ty_lines_tab,
*    END OF ty_gs_i_ptf_pbd_chtxt_td .
*  types:
** Structure for check of orderlike Documents
*    vbap_tab       TYPE STANDARD TABLE OF vbap WITH DEFAULT KEY .
*  types:
*    vbap_check_tab TYPE STANDARD TABLE OF sdbil_tst_vbap_check WITH DEFAULT KEY .
*  types:
*    vbak_tab       TYPE STANDARD TABLE OF vbak WITH DEFAULT KEY .
*  types:
*    vbak_check_tab TYPE STANDARD TABLE OF sdbil_tst_vbak_check WITH DEFAULT KEY .
*  types:
*    BEGIN OF ty_gs_ptf_sd_check_td,
*      vbak       TYPE vbak_tab,
*      vbap       TYPE vbap_tab,
*      vbak_check TYPE vbak_check_tab,
*      vbap_check TYPE vbap_check_tab,
*    END OF ty_gs_ptf_sd_check_td .
*  types:
** Structure for Check of Deliverys
*    lips_tab       TYPE STANDARD TABLE OF lips WITH DEFAULT KEY .
*  types:
*    lips_check_tab TYPE STANDARD TABLE OF sdbil_tst_lips_check WITH DEFAULT KEY .
*  types:
*    likp_tab       TYPE STANDARD TABLE OF likp WITH DEFAULT KEY .
*  types:
*    likp_check_tab TYPE STANDARD TABLE OF sdbil_tst_likp_check WITH DEFAULT KEY .
*  types:
*    BEGIN OF ty_gs_ptf_dl_check_td,
*      likp       TYPE likp_tab,
*      lips       TYPE lips_tab,
*      likp_check TYPE likp_check_tab,
*      lips_check TYPE lips_check_tab,
*    END OF ty_gs_ptf_dl_check_td .
*  types:
** Structure for Check of Billing Documents
*    vbrp_tab       TYPE STANDARD TABLE OF vbrp WITH DEFAULT KEY .
*  types:
*    vbrp_check_tab TYPE STANDARD TABLE OF sdbil_tst_vbrp_check WITH DEFAULT KEY .
*  types:
*    vbrk_tab       TYPE STANDARD TABLE OF vbrk WITH DEFAULT KEY .
*  types:
*    vbrk_check_tab TYPE STANDARD TABLE OF sdbil_tst_vbrk_check WITH DEFAULT KEY .
*  types:
*    BEGIN OF ty_gs_ptf_bd_test_add_td,
*      expected_count       TYPE i,
*      expected_count_check TYPE abap_bool,
*      vdkfs_read           TYPE abap_bool,
*      check_text           TYPE abap_bool,
*      pricing_check        TYPE abap_bool,
*    END OF ty_gs_ptf_bd_test_add_td .
*  types:
*    BEGIN OF ty_gs_ptf_bd_check_td,
*      vbrk       TYPE vbrk_tab,
*      vbrp       TYPE vbrp_tab,
*      vbrk_check TYPE vbrk_check_tab,
*      vbrp_check TYPE vbrp_check_tab,
**      add_check  TYPE ty_gs_ptf_bd_test_add_td,
*    END OF ty_gs_ptf_bd_check_td .
*  types:
** Structure for check of Quotes / Requests for Quotes
*    BEGIN OF ty_gs_ptf_rq_check_td,
*      vbak       TYPE vbak_tab,
*      vbap       TYPE vbap_tab,
*      vbak_check TYPE vbak_check_tab,
*      vbap_check TYPE vbap_check_tab,
*    END OF ty_gs_ptf_rq_check_td .
*  types:
*    BEGIN OF ty_check_expected_quantity,
*      quantity TYPE i,
*    END OF ty_check_expected_quantity .
*  types:
*    BEGIN OF ty_check_vkdfs,
*      vkdfs       TYPE vkdfs,
*      vkdfs_check TYPE sdbil_tst_vkdfs_check,
*    END OF ty_check_vkdfs .
*  types:
**    Billing Documents created with GN_INVOICE_CREATE
*    BEGIN OF ty_gs_import_gn_invce_create,
*      delivery_date           TYPE vbrp-fbuda,
*      invoice_date            TYPE vbrk-fkdat,
*      invoice_type            TYPE vbrk-fkart,
*      pricing_date            TYPE vbrp-prsdt,
*      vbsk_i                  TYPE vbsk,
*      with_posting(1)         TYPE c,
*      caller_type(1)          TYPE c,
*      i_without_refresh(1)    TYPE c,
*      id_no_enqueue(4)        TYPE c,
*      id_kvorg                TYPE komk-kvorg,
*      id_no_dialog            TYPE xflag,
*      id_new_cancellation(4)  TYPE c,
*      id_analyze_mode         TYPE char1,
*      id_no_fi_doc            TYPE char1,
*      is_fi_add_input         TYPE sdfi_s_add_input,
*      id_sim_without_price    TYPE char1,
*      io_external_buffer      TYPE REF TO if_inv_external_buffer,
*      i_no_collective_billing TYPE boolean,
*    END OF ty_gs_import_gn_invce_create .
*  types:
*** Structure for Attachment Upload
*    BEGIN OF ty_gs_i_ptf_attch_upload_td,
*      mime_type     TYPE string,
*      value_xstring TYPE xstring,
*      value_cstring TYPE cstring,
*      filename      TYPE filep,
*    END OF ty_gs_i_ptf_attch_upload_td .
*  types:
*** Preliminary Billing Document Add manual Item
*    ty_komfk_pbd_manual_tab TYPE STANDARD TABLE OF komfk_pbd_manual .
  TYPES:
** Structure for Create Customer Project
    BEGIN OF ty_gs_i_ptf_cust_proj_cr_td,
      proj_manager_comp_code    TYPE bukrs,
      proj_accountant_comp_code TYPE bukrs,
      mp_id                     TYPE /cpd/mp_id,
      mp_type                   TYPE /cpd/pws_ws_mp_type,
      proj_controller_comp_code TYPE bukrs,
      proj_partner_comp_code    TYPE bukrs,
      mp_stage                  TYPE /cpd/pws_ws_mp_stg,
      mp_title                  TYPE /cpd/short_text,
      proj_manager_id           TYPE char38,
      customer                  TYPE kunnr,
      cost_center               TYPE /cpd/pws_ws_org_unit_key,
      profit_center             TYPE /cpd/pws_ws_profit_center,
      projecttype               TYPE /cpd/ss_proj_type,
      currency                  TYPE /cpd/pws_currency,
      org_id                    TYPE /cpd/pws_ws_org_unit_id,
      confidential              TYPE /cpd/pws_ws_confidential_flag,
      start_date                TYPE /cpd/mp_start_date,
      end_date                  TYPE /cpd/mp_end_date,
    END OF ty_gs_i_ptf_cust_proj_cr_td .
  TYPES:
**Structure for WorkPackage Create
    BEGIN OF ptf_wp,
      mp_id          TYPE /cpd/mp_id,
      plan_item_id   TYPE /cpd/plan_item_id,
      plan_item_name TYPE /cpd/plan_item_name,
      start_date     TYPE /cpd/pfp_start_date,
      end_date       TYPE /cpd/pfp_end_date,
    END OF  ptf_wp .
  TYPES:
    BEGIN OF ptf_demand,
      billgctrlcatid  TYPE billgctrlcat,
      mp_id           TYPE /cpd/mp_id,
      uom             TYPE co_meinh,
      skilltag_desc   TYPE string,
      plan_item_id    TYPE /cpd/plan_item_id,
      plannedcost     TYPE /cpd/pfp_curr,
      plan_item_name  TYPE /cpd/plan_item_name,
      plannedrevenue  TYPE /cpd/pfp_curr,
      res_type        TYPE /cpd/pfp_res_type_id,
      resource_id     TYPE /cpd/pfp_resource_id,
      confirmed       TYPE /cpd/sc_conf,
      employee        TYPE hrobjid,
      workitem_id     TYPE /cpd/pfp_workitem_id,
      effort          TYPE megxxx,
      delvry_serv_org TYPE /cpd/pws_ws_org_unit_id,
    END OF  ptf_demand .
  TYPES:
    "Deep entitiy for workpackage
    BEGIN OF ty_gs_i_ptf_wp_cr_td.
      INCLUDE TYPE ptf_wp.
      TYPES:workitemset TYPE TABLE OF /cpd/cl_sc_proj_engmt__mpc=>ts_workitem WITH DEFAULT KEY.
  TYPES:demandset TYPE TABLE OF ptf_demand WITH DEFAULT KEY,
        END OF ty_gs_i_ptf_wp_cr_td .
ENDINTERFACE.
