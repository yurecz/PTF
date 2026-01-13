CLASS cl_ptf_bo_or DEFINITION
  PUBLIC
  INHERITING FROM cl_ptf_bo
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_gs_relative_bilplan_date,
        billingplan     TYPE fplnr,
        billingplanitem TYPE fpltr,
        days_delta      TYPE int2,
      END OF ty_gs_relative_bilplan_date .
    TYPES:
      ty_gt_relative_bilplan_date TYPE STANDARD TABLE OF ty_gs_relative_bilplan_date WITH DEFAULT KEY .
    TYPES:
      fpltvb_t TYPE STANDARD TABLE OF fpltvb WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_billing_plan,
        billing_plan_art       TYPE fpart,
        fpla                   TYPE fplavb,
        fplt                   TYPE fpltvb_t,
        billing_plan_item_date TYPE ty_gt_relative_bilplan_date,
      END OF ty_billing_plan .
    TYPES:
      BEGIN OF ty_remove_bp_block,
        position_to_unblock TYPE fpltr,
      END OF ty_remove_bp_block .
    TYPES:
* Structure for check of orderlike Documents
      vbap_tab       TYPE STANDARD TABLE OF vbap WITH DEFAULT KEY .
    TYPES:
* Intercompany: Transit Plant
      BEGIN OF ty_s_or_check_ic_transit_plant,
        posnr         TYPE posnr,
        transit_plant TYPE transit_plant,
      END OF ty_s_or_check_ic_transit_plant .
    TYPES:
      ty_t_or_check_ic_transit_plant TYPE STANDARD TABLE OF ty_s_or_check_ic_transit_plant WITH DEFAULT KEY .
    TYPES:
* Intercompany: VCM Catgeory
      BEGIN OF ty_s_or_check_ml_vcm_category,
        posnr        TYPE posnr,
        vcm_category TYPE vcm_chain_category,
      END OF ty_s_or_check_ml_vcm_category .
    TYPES:
      ty_t_or_check_ml_vcm_category TYPE STANDARD TABLE OF ty_s_or_check_ml_vcm_category WITH DEFAULT KEY .
* Intercompany Batch Check
    TYPES: BEGIN OF ty_s_or_check_ml_batch,
             posnr TYPE posnr,
             charg TYPE charg_d,
           END OF ty_s_or_check_ml_batch.
    TYPES:
      ty_t_or_check_ml_batch TYPE STANDARD TABLE OF ty_s_or_check_ml_batch WITH DEFAULT KEY .

    TYPES:
      BEGIN OF ty_ebeln,
        ebeln TYPE ptfkey,
      END OF ty_ebeln .
    TYPES:
      ty_ebeln_tab      TYPE STANDARD TABLE OF ty_ebeln WITH NON-UNIQUE KEY ebeln .
    TYPES:
*Return Table for Application Log, it is inlucded in every Interface of all methods of the PTF
      gt_ptf_return_tab TYPE TABLE OF bapiret2 WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_s_or_check_ml_fin_chain,
        posnr                TYPE posnr,
        financial_chain_id   TYPE fch_financial_chain_id,
        vcm_chain_element_id TYPE vcm_chain_element_id,
      END OF ty_s_or_check_ml_fin_chain .
    TYPES:
      ty_t_or_check_ml_fin_chain TYPE STANDARD TABLE OF ty_s_or_check_ml_fin_chain WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_s_or_ml_fin_chain,
        posnr              TYPE posnr,
        financial_chain_id TYPE fch_financial_chain_id,
      END OF ty_s_or_ml_fin_chain .
    TYPES:
      ty_t_or_ml_fin_chain TYPE STANDARD TABLE OF ty_s_or_ml_fin_chain WITH DEFAULT KEY .
    TYPES:
* Intercompany: Movement Type
      BEGIN OF ty_gs_ptf_or_check_ic_bwart_td,
        posnr TYPE posnr,
        etenr TYPE etenr,
        bwart TYPE bwart,
      END OF ty_gs_ptf_or_check_ic_bwart_td .
    TYPES:
      ty_gt_ptf_or_check_ic_bwart_td TYPE STANDARD TABLE OF ty_gs_ptf_or_check_ic_bwart_td WITH DEFAULT KEY .
    TYPES:
* Intercompany: Assign SalesDoc Type to Value Chain
      BEGIN OF ty_gs_ptf_sdsls_doc_vcm.
        INCLUDE TYPE sdsls_doc_vcm.
    TYPES: END OF ty_gs_ptf_sdsls_doc_vcm .
    TYPES:
      ty_gt_ptf_sdsls_doc_vcm TYPE STANDARD TABLE OF ty_gs_ptf_sdsls_doc_vcm WITH EMPTY KEY .
    TYPES:
* Intercompany: Repeats
      BEGIN OF ty_gs_ptf_or_check_ic_rpts_td,
        idle_seconds        TYPE i,  " Idle Seconds Before Start
        max_repeats         TYPE i,  " Maximum Number of Repeats
        break_seconds       TYPE i,  " Break Seconds Between Repeats
        vcm_business_object TYPE vcm_business_object,
        number_of_objects   type i,
        partner_function    type parvw,
      END OF ty_gs_ptf_or_check_ic_rpts_td .
    TYPES:
      " Intercompany: currency,quantity and quantity unit in doc flow
      BEGIN OF ty_s_or_check_ic_doc_flow,
        item_no        TYPE posnr,
        base_qty_unit  TYPE meins,
        local_currency TYPE waers,
        quantity       TYPE meng15,
        no_po          TYPE char1,
      END OF ty_s_or_check_ic_doc_flow .
    TYPES:
      ty_t_or_check_ic_doc_flow TYPE STANDARD TABLE OF ty_s_or_check_ic_doc_flow .
    TYPES:
* Intercompany: Check SO Content
*   Schedule Lines
      BEGIN OF ty_s_vbep_check,
        mandt                          TYPE char1,
        vbeln                          TYPE char1,
        posnr                          TYPE char1,
        etenr                          TYPE char1,
        ettyp                          TYPE char1,
        lfrel                          TYPE char1,
        edatu                          TYPE char1,
        ezeit                          TYPE char1,
        wmeng                          TYPE char1,
        bmeng                          TYPE char1,
        vrkme                          TYPE char1,
        lmeng                          TYPE char1,
        meins                          TYPE char1,
        bddat                          TYPE char1,
        bdart                          TYPE char1,
        plart                          TYPE char1,
        vbele                          TYPE char1,
        posne                          TYPE char1,
        etene                          TYPE char1,
        rsdat                          TYPE char1,
        idnnr                          TYPE char1,
        banfn                          TYPE char1,
        bsart                          TYPE char1,
        bstyp                          TYPE char1,
        wepos                          TYPE char1,
        repos                          TYPE char1,
        lrgdt                          TYPE char1,
        prgrs                          TYPE char1,
        tddat                          TYPE char1,
        mbdat                          TYPE char1,
        lddat                          TYPE char1,
        wadat                          TYPE char1,
        cmeng                          TYPE char1,
        lifsp                          TYPE char1,
        grstr                          TYPE char1,
        abart                          TYPE char1,
        abruf                          TYPE char1,
        roms1                          TYPE char1,
        roms2                          TYPE char1,
        roms3                          TYPE char1,
        romei                          TYPE char1,
        rform                          TYPE char1,
        umvkz                          TYPE char1,
        umvkn                          TYPE char1,
        verfp                          TYPE char1,
        bwart                          TYPE char1,
        bnfpo                          TYPE char1,
        etart                          TYPE char1,
        aufnr                          TYPE char1,
        plnum                          TYPE char1,
        sernr                          TYPE char1,
        aeskd                          TYPE char1,
        abges                          TYPE char1,
        mbuhr                          TYPE char1,
        tduhr                          TYPE char1,
        lduhr                          TYPE char1,
        wauhr                          TYPE char1,
        aulwe                          TYPE char1,
        handoverdate                   TYPE char1,
        handovertime                   TYPE char1,
        delivery_date_type_rule        TYPE char1,
        dlvqty_bu                      TYPE char1,
        dlvqty_su                      TYPE char1,
        ocdqty_bu                      TYPE char1,
        ocdqty_su                      TYPE char1,
        ordqty_bu                      TYPE char1,
        ordqty_su                      TYPE char1,
        crea_dlvdate                   TYPE char1,
        req_dlvdate                    TYPE char1,
        bedar                          TYPE char1,
        _dataaging                     TYPE char1,
        waerk                          TYPE char1,
        odn_amount                     TYPE char1,
        handle                         TYPE char1,
        lccst                          TYPE char1,
        rrqqty_bu                      TYPE char1,
        crqqty_bu                      TYPE char1,
        dummy_slsdocschedl_incl_eew_ps TYPE char1,
        fsh_ralloc_qty                 TYPE char1,
        fsh_os_id                      TYPE char1,
        fsh_pqr_rc                     TYPE char1,
        mbdat_drs                      TYPE char1,
      END OF ty_s_vbep_check .
    TYPES:
      vbep_check_tab TYPE STANDARD TABLE OF ty_s_vbep_check WITH DEFAULT KEY .
    TYPES:
      vbep_tab       TYPE STANDARD TABLE OF vbep WITH DEFAULT KEY .
    TYPES:
      vbap_check_tab TYPE STANDARD TABLE OF sdbil_tst_vbap_check WITH DEFAULT KEY .
    TYPES:
      vbak_tab       TYPE STANDARD TABLE OF vbak WITH DEFAULT KEY .
    TYPES:
      vbak_check_tab TYPE STANDARD TABLE OF sdbil_tst_vbak_check WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_ptf_sd_partner_td,
        item_number TYPE posnr,
        role        TYPE parvw,
        customer    TYPE kunnr,
      END OF ty_gs_ptf_sd_partner_td .
    TYPES:
      partner_tab TYPE STANDARD TABLE OF ty_gs_ptf_sd_partner_td WITH DEFAULT KEY .
    TYPES:
      adress_tab  TYPE STANDARD TABLE OF bapiaddr1 WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_ptf_sd_check_partner_td,
        partner TYPE partner_tab,
      END OF ty_gs_ptf_sd_check_partner_td .
    TYPES:
      BEGIN OF ty_gs_ptf_sd_check_td,
        vbak       TYPE vbak_tab,
        vbap       TYPE vbap_tab,
        vbak_check TYPE vbak_check_tab,
        vbap_check TYPE vbap_check_tab,
      END OF ty_gs_ptf_sd_check_td .
    TYPES:
*  types:
*    BEGIN OF ty_gs_ptf_sd_check_td_ext,
*        vbep       TYPE vbep_tab,
*        vbep_check TYPE vbep_check_tab.
*        INCLUDE TYPE ty_gs_ptf_sd_check_td AS vbak_vbap_data.
*    TYPES: END OF ty_gs_ptf_sd_check_td_ext .
      BEGIN OF ty_gs_ptf_sd_check_td_ext.
        INCLUDE TYPE ty_gs_ptf_sd_check_td AS vbak_vbap_data.
    TYPES:
        vbep       TYPE vbep_tab,
        vbep_check TYPE vbep_check_tab.
    TYPES: END OF ty_gs_ptf_sd_check_td_ext .
    TYPES:
      ty_gt_configuration_ref TYPE STANDARD TABLE OF bapicucfg WITH DEFAULT KEY .
    TYPES:
      ty_gt_configuration_inst TYPE STANDARD TABLE OF bapicuins WITH DEFAULT KEY .
    TYPES:
      ty_gt_configuration_value TYPE STANDARD TABLE OF bapicuval WITH DEFAULT KEY .
    TYPES:
      ty_gt_configuration_vk TYPE STANDARD TABLE OF bapicuvk WITH DEFAULT KEY .
    TYPES:
* Structure for Standard Order (TA/OR) create
      BEGIN OF ty_gs_i_ptf_or_cr_td,
        document_type        TYPE auart,
        payment_terms        TYPE dzterm,
        payment_method       TYPE dzlsch,
        sales_organization   TYPE vkorg,
        distribution_channel TYPE vtweg,
        division             TYPE spart,
        customer_id          TYPE kunnr,
        order_reason         TYPE augru,
        billing_block        TYPE faksk,
        tax_dest_country     TYPE land1tx,
        tax_dept_country     TYPE landtx,
        tax_classification   TYPE taxk1_ak,
        service_render_date  TYPE fbuda,
        purch_number         TYPE bstkd,
        currency             TYPE waerk,
        billing_date         TYPE  fkdat,
        item_list            TYPE cl_ptf_sd_util=>ty_gt_item_list_td,
        order_partners       TYPE cl_ptf_sd_util=>ty_order_partners,
        condition            TYPE cl_ptf_sd_util=>lty_sales_conditions_in,
        ext_fields_item      TYPE cl_ptf_sd_util=>ty_gt_ext_field_td,
        sales_text           TYPE cl_ptf_sd_util=>ty_bapisdtext,
        adress_data          TYPE adress_tab,
        configuration_ref    TYPE ty_gt_configuration_ref,
        configuration_inst   TYPE ty_gt_configuration_inst,
        configuration_value  TYPE ty_gt_configuration_value,
        configuration_vk     TYPE ty_gt_configuration_vk,
      END OF ty_gs_i_ptf_or_cr_td .
    TYPES:
      BEGIN OF ty_gs_biplan_relative_date,
        customerproject TYPE /cpd/mp_id,
        salesorderitem  TYPE sales_order_item,
        billingplanitem TYPE fpltr,
        days_delta      TYPE int2,
      END OF ty_gs_biplan_relative_date .
    TYPES:
      ty_gt_biplan_relative_date TYPE STANDARD TABLE OF ty_gs_biplan_relative_date WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_i_ptf_so_cr_so01_td,
        customerproject                TYPE /cpd/mp_id,
        purchaseorderbycustomer        TYPE bstkd,
        to_custprojslsorditem          TYPE /cpd/cl_sc_proj_engmt__dpc_ext=>tct_deep_slsorditem,
        to_custprojsoibillgplnitm_date TYPE ty_gt_biplan_relative_date,
        to_custprojslsordtext          TYPE /cpd/cl_sc_proj_engmt__dpc_ext=>tct_custprojslsordtext,
      END OF ty_gs_i_ptf_so_cr_so01_td .
    TYPES:
** Structure for Standard Order create with reference
      BEGIN OF ty_gs_i_ptf_or_cr_with_ref_td,
        document_type TYPE auart,
      END OF ty_gs_i_ptf_or_cr_with_ref_td .
    TYPES:
* Structure for Standard Order (TA/OR) change
      BEGIN OF ty_gs_i_ptf_or_ch_td,
        document_type        TYPE auart,
        sales_organization   TYPE vkorg,
        distribution_channel TYPE vtweg,
        division             TYPE spart,
        customer_id          TYPE kunnr,
        order_reason         TYPE augru,
        billing_block        TYPE faksk,
        item_list            TYPE cl_ptf_sd_util=>ty_gt_item_list_td,
        schedule_lines       TYPE cl_ptf_sd_util=>ty_gt_sched_list_td,
      END OF ty_gs_i_ptf_or_ch_td .
    TYPES:
      BEGIN OF ty_gs_check_prefix,
        expected_prefix TYPE sd_nrrange_prefix,
      END OF ty_gs_check_prefix .
    TYPES:
      BEGIN OF ty_s_poheader,
        bukrs TYPE bukrs,
        bsart TYPE esart,
        loekz TYPE eloek,
        statu TYPE estak,
        lifnr TYPE elifn,
      END   OF ty_s_poheader .
    TYPES:
      BEGIN OF ty_s_poitem,
        ebelp TYPE ebelp,
        loekz TYPE eloek,
        matnr TYPE matnr,
        werks TYPE ewerk,
        menge TYPE bstmg,
      END OF ty_s_poitem .
    TYPES:
      ty_t_poitem TYPE STANDARD TABLE OF ty_s_poitem WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_s_poheader_check,
        bukrs TYPE char1,
        bsart TYPE char1,
        loekz TYPE char1,
        statu TYPE char1,
        lifnr TYPE char1,
      END   OF ty_s_poheader_check .
    TYPES:
      BEGIN OF ty_s_poitem_check,
        ebelp TYPE char1,
        loekz TYPE char1,
        matnr TYPE char1,
        werks TYPE char1,
        menge TYPE char1,
      END OF ty_s_poitem_check .
    TYPES:
      ty_t_poitem_check TYPE STANDARD TABLE OF ty_s_poitem_check WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_s_po_schedule_line,
        ebelp TYPE  ebelp,
        etenr TYPE  etenr,
        mng02 TYPE  mng06,
      END OF ty_s_po_schedule_line .
    TYPES:
      ty_t_po_schedule_line TYPE STANDARD TABLE OF ty_s_po_schedule_line WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_s_po_schedule_line_check,
        ebelp TYPE  ebelp,
        etenr TYPE  etenr,
        mng02 TYPE  char1,
      END OF   ty_s_po_schedule_line_check .
    TYPES:
      ty_t_po_schedule_line_check TYPE STANDARD TABLE OF ty_s_po_schedule_line_check WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_ptf_or_check_po_td,
        po_header              TYPE ty_s_poheader,
        po_item                TYPE ty_t_poitem,
        po_schedule_line       TYPE ty_t_po_schedule_line,
        po_header_check        TYPE ty_s_poheader_check,
        po_item_check          TYPE ty_t_poitem_check,
        po_schedule_line_check TYPE ty_t_po_schedule_line_check,
      END OF ty_gs_ptf_or_check_po_td .
    TYPES:
      ty_gt_ptf_or_check_po_td TYPE STANDARD TABLE OF ty_gs_ptf_or_check_po_td WITH DEFAULT KEY .

    TYPES:
      BEGIN OF tcs_value_type,
        object_id            TYPE vcm_business_object_id,
        item_id              TYPE vcm_business_object_item_id,
        source_step_type     TYPE vcm_step_type_id,
        value_chain_type     TYPE vcm_value_chain_type,
        target_step_type     TYPE vcm_step_type_id,
        value_chain_category TYPE vcm_chain_category,
        chain_element_id     TYPE vcm_chain_element_id,
        financial_chain_id   TYPE fch_financial_chain_id,
      END OF tcs_value_type .
    TYPES:
      tct_value_type TYPE STANDARD TABLE OF tcs_value_type WITH DEFAULT KEY .

    CONSTANTS c_check_created_so TYPE string VALUE 'CHECK_CREATED_SO' ##NO_TEXT.
    CONSTANTS c_double_price TYPE string VALUE 'DOUBLE_PRICE' ##NO_TEXT.
    CONSTANTS c_create_with_reference TYPE string VALUE 'CREATE_WITH_REFERENCE' ##NO_TEXT.
    CONSTANTS c_create_for_material TYPE string VALUE 'CREATE_FOR_MATERIAL' ##NO_TEXT.
    CONSTANTS c_check_partner TYPE string VALUE 'CHECK_PARTNER' ##NO_TEXT.
    CONSTANTS c_create_so01 TYPE string VALUE 'CREATE_SO01' ##NO_TEXT.
    CONSTANTS c_credit_release TYPE string VALUE 'CREDIT_RELEASE' ##NO_TEXT.
    CONSTANTS c_call_order_request_in TYPE string VALUE 'CALL_ORDER_REQUEST_IN' ##NO_TEXT.
    CONSTANTS c_check_sold_to_party TYPE string VALUE 'CHECK_SOLD_TO_PARTY' ##NO_TEXT.
    CONSTANTS c_check_blocked TYPE string VALUE 'CHECK_SO_DELIVERY_BLOCKED' ##NO_TEXT.
    CONSTANTS c_check_preceding TYPE string VALUE 'CHECK_PRECEDING' ##NO_TEXT.
    CONSTANTS c_add_billing_plan TYPE string VALUE 'ADD_BILLING_PLAN' ##NO_TEXT.
    CONSTANTS c_remove_bp_block TYPE string VALUE 'REMOVE_BP_BLOCK' ##NO_TEXT.
    CONSTANTS c_check_analytical_fields TYPE string VALUE 'CHECK_ANA_FIELDS' ##NO_TEXT.
    CONSTANTS c_log_status TYPE string VALUE 'LOG_STATUS' ##NO_TEXT.
    CONSTANTS c_create_ic TYPE string VALUE 'CREATE_IC' ##NO_TEXT.
    CONSTANTS c_check_po TYPE string VALUE 'CHECK_PO' ##NO_TEXT.
    CONSTANTS c_bus_obj_material TYPE ptf_bo VALUE 'MATERIAL' ##NO_TEXT.
    CONSTANTS c_set_sdsls_doc_vcm TYPE string VALUE 'SET_SDSLS_DOC_VCM' ##NO_TEXT.

    METHODS change_ic_so2
      IMPORTING
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .
    METHODS create_ic
      IMPORTING
        !iv_step_number      TYPE i
        !step_data           TYPE cl_ptf_util=>gt_ptf_step
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .

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
private section.

  types:
    ty_gt_order_partners TYPE STANDARD TABLE OF bapiparnr .
  types:
    ty_gt_order_items    TYPE STANDARD TABLE OF bapisditm .
  types:
    ty_gt_schedules      TYPE STANDARD TABLE OF bapischdl .
  types:
    ty_bapisdtext TYPE STANDARD TABLE OF bapisdtext .
  types:
    BEGIN OF ty_s_so_po_item_key,
        vbeln TYPE vbeln_va,
        posnr TYPE posnr_va,
        ebeln TYPE ebeln,
        ebelp TYPE ebelp,
      END OF ty_s_so_po_item_key .
  types:
    ty_t_so_po_item_key TYPE STANDARD TABLE OF ty_s_so_po_item_key .
  types:
    BEGIN OF ty_vcm_item,
        itema TYPE vcm_rt_bo_item,
        itemb TYPE vcm_rt_bo_item,
        step  TYPE vcm_rt_step_ins,
        chain TYPE vcm_rt_chain_ins,
      END OF ty_vcm_item .
  types:
    ty_vcm_item_tab TYPE STANDARD TABLE OF ty_vcm_item WITH EMPTY KEY .

  constants C_CHECK_UNBLOCK type STRING value 'CHECK_SO_DELIVERY_UNBLOCK' ##NO_TEXT.
  constants C_PAYMENT_TERM type STRING value 'SO_PAYMENT_TERMS' ##NO_TEXT.
  constants C_CHECK_PAYMENT_TERM type STRING value 'CHECK_SO_PAYMENT_TERMS' ##NO_TEXT.
  constants C_CREATE_WITH_REFERENCE_TO_BD type STRING value 'CREATE_WITH_REFERENCE_TO_BD' ##NO_TEXT.
  constants C_CREATE_WITH_REFERENCE_TO_LK type STRING value 'CREATE_WITH_REFERENCE_LK' ##NO_TEXT.
  constants C_CREATE_RETURN_REF type STRING value 'CREATE_RETURN_REF' ##NO_TEXT.
  constants C_DOC_CHECK_AFTER_OBD type STRING VALUE 'DOC_CHECK_AFTER_OBD' ##NO_TEXT.
  constants C_CHECK_IC_SO4 type STRING value 'CHECK_IC_SO4' ##NO_TEXT.
  constants C_CHECK_IC_TRANSIT_PLANT type STRING value 'CHECK_IC_TRANSIT_PLANT' ##NO_TEXT.
  constants C_CHECK_ML_VCM_FIN_CHAIN type STRING value 'CHECK_ML_VCM_FINANCIAL_CHAIN' ##NO_TEXT.
  constants C_CHECK_ML_VCM_CATEGORY type STRING value 'CHECK_ML_VCM_CATEGORY' ##NO_TEXT.
  constants C_CHECK_IC_MOVEMENT_TYPE type STRING value 'CHECK_IC_MOVEMENT_TYPE' ##NO_TEXT.
  constants C_CHECK_IC_WAIT_FOR_PO3 type STRING value 'CHECK_IC_WAIT_FOR_PO3' ##NO_TEXT.
  constants C_CHECK_IC_WAIT_FOR_SO4 type STRING value 'CHECK_IC_WAIT_FOR_SO4' ##NO_TEXT.
  constants C_ACTION_IC_ADD_ITEM type STRING value 'ACTION_IC_ADD_ITEM' ##NO_TEXT.
  constants C_CHECK_IC_DOC_FLOW type STRING value 'CHECK_IC_DOC_FLOW' ##NO_TEXT.
  constants C_CHECK_IC_VCM_NOT_TRIGGERED type STRING value 'CHECK_IC_VCM_NOT_TRIGGERED' ##NO_TEXT.
  constants C_ACTION_CHANGE_IC_SO2 type STRING value 'CHANGE_IC_SO2' ##NO_TEXT.
  constants C_ACTION_ADD_ITEM_BPL_GOAL type STRING value 'ADD_ITEM_BPL_GOAL' ##NO_TEXT.
  constants C_ACTION_ADD_HEAD_BPL_GOAL type STRING value 'ADD_HEAD_BPL_GOAL' ##NO_TEXT.
  constants C_CHECK_ITEM_BPL_CREATED_GOAL type STRING value 'CHECK_ITEM_BPL_CREATED_GOAL' ##NO_TEXT.
  constants C_CHECK_HEAD_BPL_CREATED_GOAL type STRING value 'CHECK_HEAD_BPL_CREATED_GOAL' ##NO_TEXT.
  constants C_CHECK_BPL_COPIED type STRING value 'CHECK_BPL_COPIED' ##NO_TEXT.
  constants C_ACTION_ADD_ITEM_BOM_GOAL type STRING value 'ADD_ITEM_BOM_GOAL' ##NO_TEXT.
  constants C_ACTION_DELETE_ITEM_BPL_GOAL type STRING value 'DELETE_ITEM_BPL_GOAL' ##NO_TEXT.
  constants C_ACTION_DELETE_HEAD_BPL_GOAL type STRING value 'DELETE_HEAD_BPL_GOAL' ##NO_TEXT.
  constants C_CHECK_ITEM_BPL_UPDATED_GOAL type STRING value 'CHECK_ITEM_BPL_UPDATED_GOAL' ##NO_TEXT.
  constants C_CHECK_HEAD_BPL_UPDATED_GOAL type STRING value 'CHECK_HEAD_BPL_UPDATED_GOAL' ##NO_TEXT.
  constants C_CHECK_ITEM_BPL_DELETED_GOAL type STRING value 'CHECK_ITEM_BPL_DELETED_GOAL' ##NO_TEXT.
  constants C_CHECK_HEAD_BPL_DELETED_GOAL type STRING value 'CHECK_HEAD_BPL_DELETED_GOAL' ##NO_TEXT.
  constants C_ACTION_UPDATE_ITEM_BPL_GOAL type STRING value 'UPDATE_ITEM_BPL_GOAL' ##NO_TEXT.
  constants C_ACTION_UPDATE_HEAD_BPL_GOAL type STRING value 'UPDATE_HEAD_BPL_GOAL' ##NO_TEXT.
  constants C_CHECK_DELIVERY_BLOCK_SLINE type STRING value 'CHECK_DELIVERY_BLOCK_SLINE' ##NO_TEXT.
  constants C_CHECK_PREFIX type STRING value 'CHECK_PREFIX' ##NO_TEXT.
  constants C_WAIT_LOCK type STRING value 'WAIT_UNTIL_LOCKED' ##NO_TEXT.
  constants C_CREATE_FOR_PROJECT type STRING value 'CREATE_FOR_PROJECT' ##NO_TEXT.
  constants C_ADD_ITEM_BILLING_PLAN type STRING value 'ADD_ITEM_BILLING_PLAN' ##NO_TEXT.
  constants C_CHECK_IC_SO4_BAPI_CREATE type STRING value 'CHECK_IC_SO4_BAPI_CREATE' ##NO_TEXT.
  constants C_CHECK_IC_SO4_BAPI_CHANGE type STRING value 'CHECK_IC_SO4_BAPI_CHANGE' ##NO_TEXT.
  constants C_CHECK_HEAD_BP_EXIST type STRING value 'CHECK_HEAD_BP_EXIST' ##NO_TEXT.
  constants C_CHECK_HEAD_BP_NOT_EXIST type STRING value 'CHECK_HEAD_BP_NOT_EXIST' ##NO_TEXT.
  constants C_CHECK_ITEM_BP_EXIST type STRING value 'CHECK_ITEM_BP_EXIST' ##NO_TEXT.
  constants C_CHECK_ITEM_BP_NOT_EXIST type STRING value 'CHECK_ITEM_BP_NOT_EXIST' ##NO_TEXT.
  constants C_ACTION_ADD_F_ITEM_BP_GOAL type STRING value 'ADD_F_ITEM_BP_GOAL' ##NO_TEXT.
  constants C_CHECK_F_IT_BP_S_NBP type STRING value 'CHECK_F_IT_BP_S_NBP' ##NO_TEXT.
  constants C_ADD_ITEM_BLP_BOM type STRING value 'ADD_ITEM_BILLING_PLAN_BOM' ##NO_TEXT.
  constants C_CHECK_DELIVERY_BLOCK_BOM type STRING value 'CHECK_DELIVERY_BLOCK_BOM' ##NO_TEXT.
  constants C_ADD_HIGHER_LEVEL_ITEM type STRING value 'ADD_HIGHER_LEVEL_ITEM' ##NO_TEXT.
  constants C_GET_PURCH_REQUISITION type STRING value 'GET_PURCH_REQUISITION' ##NO_TEXT.
  constants C_COMPARE_AGAINST_DB_DOC type STRING value 'COMPARE_AGAINST_DB_DOC' ##NO_TEXT.
  constants C_CHECK_ML_IC_WAIT_FOR_PO3 type STRING value 'CHECK_ML_IC_WAIT_FOR_PO3' ##NO_TEXT.
  constants C_CHECK_ML_DC_SO_CREATED type STRING value 'CHECK_ML_DC_SO_CREATED' ##NO_TEXT.
  constants C_CHECK_ML_IC_WAIT_SC_PO type STRING value 'CHECK_ML_IC_WAIT_FOR_SC_PO' ##NO_TEXT.
  constants C_CHECK_ML_IC_WAIT_IC_SO type STRING value 'CHECK_ML_IC_WAIT_FOR_IC_SO' ##NO_TEXT.
  constants C_CHECK_ML_IC_WAIT_DC_SO type STRING value 'CHECK_ML_IC_WAIT_FOR_DC_SO' ##NO_TEXT.
  constants C_CHECK_ML_IC_WAIT_IC_PO type STRING value 'CHECK_ML_IC_WAIT_FOR_IC_PO' ##NO_TEXT.
    """""""MULLAPULLI
    """"""" VCM related checks
  constants C_ML_VCM_CHK_FIN_CHAIN_ID type STRING value 'ML_VCM_CHK_FIN_CHAIN_ID' ##NO_TEXT.
  constants C_ML_VCM_CHK_CAT_MICL_ICSL type STRING value 'ML_VCM_CHK_CAT_MICL_ICSL' ##NO_TEXT.
  constants C_ML_VCM_CHK_TRANSIT_PLNT_SCSO type STRING value 'ML_VCM_CHK_TRANSIT_PLNT_SCSO' ##NO_TEXT.
  constants C_ML_VCM_CHK_TRANSIT_PLNT_ICSO type STRING value 'ML_VCM_CHK_TRANSIT_PLNT_ICSO' ##NO_TEXT.
  constants C_ML_VCM_CHK_NO_TRST_PLNT_DCSO type STRING value 'ML_VCM_CHK_NO_TRST_PLNT_DCSO' ##NO_TEXT.
    """"""" VCM DOC related checks
  constants C_ML_DOC_CHK_ALL_SO_CREATED type STRING value 'ML_DOC_CHK_ALL_SO_CREATED' ##NO_TEXT.
  constants C_ML_DOC_CHK_SCSO_CREATED type STRING value 'ML_DOC_CHK_SCSO_CREATED' ##NO_TEXT.
  constants C_ML_DOC_CHK_DCSO_CREATED type STRING value 'ML_DOC_CHK_DCSO_CREATED' ##NO_TEXT.
  constants C_ML_DOC_CHK_ICSO_CREATED type STRING value 'ML_DOC_CHK_ICSO_CREATED' ##NO_TEXT.
  constants C_ML_DOC_GM_CHECK_OUTDELIVERY type STRING value 'ML_DOC_GM_CHECK_OUTDELIVERY' ##NO_TEXT.
  constants C_ML_CHK_PLANT_CHANGE_SC_PO type STRING value 'ML_CHK_PLANT_CHANGE_SC_PO' ##NO_TEXT.
  constants C_ML_CHK_PLANT_CHANGE_IC_SO type STRING value 'ML_CHK_PLANT_CHANGE_IC_SO' ##NO_TEXT.
  constants C_ML_CHK_PLANT_CHANGE_IC_PO type STRING value 'ML_CHK_PLANT_CHANGE_IC_PO' ##NO_TEXT.
  constants C_ML_CHK_PLANT_CHANGE_DC_SO type STRING value 'ML_CHK_PLANT_CHANGE_DC_SO' ##NO_TEXT.
  constants C_ML_CHK_PLANT_CHG_AFTER_OBD type STRING value 'ML_CHK_PLANT_CHG_AFTER_OBD' ##NO_TEXT.
  constants C_ML_CHK_MATERIAL_CHANGE_SC_PO type STRING value 'ML_CHK_MATERIAL_CHANGE_SC_PO' ##NO_TEXT.
  constants C_ML_CHK_MATERIAL_CHANGE_IC_SO type STRING value 'ML_CHK_MATERIAL_CHANGE_IC_SO' ##NO_TEXT.
  constants C_ML_CHK_MATERIAL_CHANGE_IC_PO type STRING value 'ML_CHK_MATERIAL_CHANGE_IC_PO' ##NO_TEXT.
  constants C_ML_CHK_MATERIAL_CHANGE_DC_SO type STRING value 'ML_CHK_MATERIAL_CHANGE_DC_SO' ##NO_TEXT.
  constants C_ML_SUCCESSOR_DOC_DELETION type STRING value 'ML_SUCCESSOR_DOC_DELETION' ##NO_TEXT.
  constants C_CLEAR_TRANSIT_PLANT type STRING value 'CLEAR_TRANSIT_PLANT' ##NO_TEXT.
  constants C_CHECK_ML_OBD type STRING value 'CHECK_ML_OBD' ##NO_TEXT.
  constants C_ML_CHK_SHIP_TO_CHANGE type STRING value 'ML_CHK_SHIP_TO_CHANGE' ##NO_TEXT.
  constants C_ML_SUBITEM_CREATE_OBD type STRING value 'ML_SUBITEM_CREATE_OBD' ##NO_TEXT.
  constants C_ML_CHECK_SC_PO_BATCH type STRING value 'CHECK_ML_SC_PO_BATCH' ##NO_TEXT.
  constants C_ML_CHECK_IC_SO_BATCH type STRING value 'CHECK_ML_IC_SO_BATCH' ##NO_TEXT.
  constants C_ML_CHECK_IC_PO_BATCH type STRING value 'CHECK_ML_IC_PO_BATCH' ##NO_TEXT.
  constants C_ML_CHECK_DC_SO_BATCH type STRING value 'CHECK_ML_DC_SO_BATCH' ##NO_TEXT.

    """""""MULLAPULLI
  methods _CREATE
    importing
      !IV_STEP_NUMBER type I
      !IV_USE_REF_MATERIAL type ABAP_BOOL optional
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
    "! Create sales order using referenced materials.
  methods CREATE_FOR_MATERIAL
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
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
  methods CHECK_ANA_FIELDS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ADD_BILLING_PLAN
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods REMOVE_BP_BLOCK
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_SOLD_TO_PARTY
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_SO_PAYMENT_TERMS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods SO_PAYMENT_TERMS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods REMOVE_BILLING_BLOCK
    importing
      !IV_ORDER_NUMBER type PTFKEY
    returning
      value(EV_TEST_SUCCESS) type ABAP_BOOL .
  methods PREPARE_TESTDATA_CREATE
    importing
      !LS_TESTDATA type TY_GS_I_PTF_OR_CR_TD
      !IV_VBELN type VBELN optional
    exporting
      !LS_ORDER_HEADER_IN type BAPISDHD1
      !LT_ORDER_PARTNERS type TY_GT_ORDER_PARTNERS
      !LT_ORDER_ITEMS type TY_GT_ORDER_ITEMS
      !LT_SCHEDULES type TY_GT_SCHEDULES
      !LT_SALES_TEXT type TY_BAPISDTEXT .
  methods ADD_BILLING_BLOCK
    importing
      !IV_ORDER_NUMBER type PTFKEY
      !IV_CHANCE_TDC type TY_GS_I_PTF_OR_CH_TD
    exporting
      !ET_RETURN type CL_PTF_UTIL=>GT_PTF_RETURN_TAB
    returning
      value(EV_TEST_SUCCESS) type ABAP_BOOL .
  methods CHANGE_ITEM_LIST
    importing
      !IV_ORDER_NUMBER type PTFKEY
      !IV_CHANCE_TDC type TY_GS_I_PTF_OR_CH_TD
    exporting
      !EV_TEST_SUCCESS type ABAP_BOOL
      !EV_RESULT type TY_GS_I_PTF_OR_CH_TD   ##NEEDED
      !ET_RETURN type CL_PTF_UTIL=>GT_PTF_RETURN_TAB .
  methods CREATE_WITH_REFERENCE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods DOUBLE_PRICE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_PARTNER
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                                                                                                                                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_SO01
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ACTION_IC_ADD_ITEM
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREDIT_RELEASE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CALL_ORDER_REQUEST_IN
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_SO_API
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_SO_DELIVERY_BLOCKED
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_CHECK_STATUS type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL .
  methods CHECK_SO_DELIVERY_UNBLOCK
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_CHECK_STATUS type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL .
  methods CREATE_WITH_REFERENCE_TO_BD
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_WITH_REFERENCE_LK
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
  methods CREATE_RETURN_REF
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB .
  methods CHECK_IC_SO4
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_CHECK_STATUS type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL .
  methods CHECK_PO
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_CHECK_STATUS type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL .
  methods CHECK_IC_TRANSIT_PLANT
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !ET_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_IC_MOVEMENT_TYPE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_CHECK_STATUS type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL .
  methods CHECK_IC_WAIT_FOR_PO3
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !ET_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_IC_WAIT_FOR_SO4
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ML_IC_WAIT_FOR_DC_SO
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_IC_DOC_FLOW
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !ET_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_IC_VCM_NOT_TRIGGERED
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !ET_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ADD_ITEM_BPL_GOAL
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ADD_HEAD_BPL_GOAL
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ITEM_BPL_CREATED_GOAL
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_HEAD_BPL_CREATED_GOAL
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_BPL_COPIED
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ADD_ITEM_BOM_GOAL
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods DELETE_ITEM_BPL_GOAL
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods DELETE_HEAD_BPL_GOAL
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods UPDATE_ITEM_BPL_GOAL
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods UPDATE_HEAD_BPL_GOAL
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ITEM_BPL_DELETED_GOAL
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_HEAD_BPL_DELETED_GOAL
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ITEM_BPL_UPDATED_GOAL
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_HEAD_BPL_UPDATED_GOAL
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_DELIVERY_BLOCK_SLINE
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods IC_PREPARE_TESTDATA_CREATE
    importing
      !LS_TESTDATA type TY_GS_I_PTF_OR_CR_TD
      !IV_VBELN type VBELN optional
    exporting
      !LS_ORDER_HEADER_IN type BAPISDHD1
      !LT_ORDER_PARTNERS type TY_GT_ORDER_PARTNERS
      !LT_ORDER_ITEMS type TY_GT_ORDER_ITEMS
      !LT_SCHEDULES type TY_GT_SCHEDULES
      !LT_SALES_TEXT type TY_BAPISDTEXT .
  methods CHECK_PREFIX
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods WAIT_LOCK
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_FOR_PROJECT
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods COMPARE_STRUCTURE
    importing
      !IO_RUN_ENVIRONMENT type ref to CL_PTF_RUN
      !IS_CHECK_PARAMETER type ANY
      !IS_EXPECTED type ANY
      !IS_ACTUAL type ANY
    returning
      value(RV_RESULT) type ABAP_BOOL .
  methods ADD_ITEM_BILLING_PLAN
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_IC_SO4_BAPI_CREATE
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_CHECK_STATUS type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL .
  methods CHECK_IC_SO4_BAPI_CHANGE
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_CHECK_STATUS type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL .
  methods CHECK_HEAD_BP_EXIST
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_HEAD_BP_NOT_EXIST
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ITEM_BP_EXIST
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ITEM_BP_NOT_EXIST
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_CHECK_STATUS type ABAP_BOOL
      !EV_EXECUTION_STATUS type ABAP_BOOL .
  methods ADD_F_ITEM_BP_GOAL
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_CHECK_STATUS type ABAP_BOOL
      !EV_EXECUTION_STATUS type ABAP_BOOL .
  methods CHECK_F_IT_BP_S_NBP
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ADD_ITEM_BILLING_PLAN_BOM
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_DELIVERY_BLOCK_BOM
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ADD_HIGHER_LEVEL_ITEM
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods GET_PURCH_REQUISITION
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods COMPARE_AGAINST_DB_DOC
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_CHECK_STATUS type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL .
  methods COMPARE_AGAINST_DB_DOC_PREPARE
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_ERROR type ABAP_BOOL
      !ET_VBELN type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_VBELN_EXP type PTFKEY .
  methods RESERVE_ACTION_1
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_CHECK_STATUS type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL .
  methods RESERVE_ACTION_2
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_CHECK_STATUS type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL .
  methods RESERVE_ACTION_3
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_CHECK_STATUS type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL .
  methods SET_SDSLS_DOC_VCM
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_CHECK_STATUS type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL .
  methods CHECK_ML_VCM_CATEGORY
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ML_VCM_FINANCIAL_CHAIN
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ML_IC_DC_SO_CREATED
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ML_IC_WAIT_FOR_SC_PO
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ML_IC_WAIT_FOR_IC_SO
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ML_OBD
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ML_IC_WAIT_FOR_IC_PO
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ML_IC_WAIT_FOR_PO3
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
    """"""" Mullapulli
    """"""" VCM related checks
  methods ML_VCM_CHK_FIN_CHAIN_ID
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ML_VCM_CHK_CAT_MICL_ICSL
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ML_VCM_CHK_TRANSIT_PLNT_SCSO
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !ET_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ML_VCM_CHK_TRANSIT_PLNT_ICSO
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !ET_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ML_VCM_CHK_NO_TRST_PLNT_DCSO
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !ET_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CLEAR_TRANSIT_PLANT
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_EXEC_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods POLL_FOR_VCM_ITEM
    importing
      !IV_STEP_TYPE type C
      !IV_BREAK_SECONDS type I default 5
      !IV_MAX_ATTEMPTS type I default 10
    changing
      !CT_VCM_ITEM type TY_VCM_ITEM_TAB
      !CV_FOUND type ABAP_BOOL
      !CV_WAITING_TIME type S_MEC_CPUTEST_BREAK_SECONDS
      !CV_ATTEMPTS_ACT type TB_ATTEMPTS .
    """"""" VCM DOC related checks
    """"""" Mullapulli
  methods ML_DOC_CHK_SCSO_CREATED
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ML_DOC_CHK_DCSO_CREATED
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ML_DOC_CHK_ICSO_CREATED
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ML_DOC_CHK_ALL_SO_CREATED
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ML_ICO_TO_BE_DELETED .
  methods DOC_CHECK_AFTER_OBD
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ML_DOC_GM_CHECK_OUTDELIVERY
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ML_SUCCESSOR_DOC_DELETION
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_EXEC_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ML_CHK_SHIP_TO_CHANGE
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_EXEC_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ML_CHK_PLANT_CHANGE_SC_PO
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOC_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXEC_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ML_CHK_PLANT_CHANGE_IC_SO
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOC_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXEC_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ML_CHK_PLANT_CHANGE_IC_PO
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOC_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXEC_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ML_CHK_PLANT_CHANGE_DC_SO
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOC_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXEC_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ML_CHK_PLANT_CHG_AFTER_OBD
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_EXEC_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ML_CHK_MATERIAL_CHANGE_SC_PO
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOC_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXEC_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ML_CHK_MATERIAL_CHANGE_IC_SO
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOC_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXEC_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ML_CHK_MATERIAL_CHANGE_IC_PO
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOC_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXEC_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ML_CHK_MATERIAL_CHANGE_DC_SO
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOC_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXEC_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ML_CHECK_DOC_FLOW
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP optional
    exporting
      !EV_EXEC_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ML_SUBITEM_CREATE_OBD
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ML_VCM_SC_PO_BATCH_ID
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ML_VCM_IC_SO_BATCH_ID
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ML_VCM_IC_PO_BATCH_ID
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ML_VCM_DC_SO_BATCH_ID
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
ENDCLASS.



CLASS CL_PTF_BO_OR IMPLEMENTATION.


  METHOD action_ic_add_item.
    DATA: lt_doc_ids  TYPE TABLE OF vbeln.
    DATA: ls_testdata TYPE ty_gs_i_ptf_or_cr_td.
    DATA: ls_order_item_inx  TYPE bapisditmx,
          lt_order_item_inx  TYPE TABLE OF bapisditmx,
          ls_header_inx      TYPE bapisdh1x,
          ls_header_in       TYPE bapisdh1,
          ls_order_items     TYPE bapisditm,
          lt_order_items     TYPE TABLE OF bapisditm,
          lt_return	         TYPE cl_ptf_util=>gt_ptf_return_tab,
          ls_return          TYPE  bapiret2,
          ls_sched_line      TYPE bapischdl,
          ls_sched_line_inx  TYPE bapischdlx,
          lt_sched_lines     TYPE TABLE OF bapischdl,
          lt_sched_lines_inx TYPE TABLE OF bapischdlx.

    " get step data
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(ref_doc_ids) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      LOOP AT ref_doc_ids ASSIGNING FIELD-SYMBOL(<lv_ref_doc_id>).
        APPEND <lv_ref_doc_id> TO lt_doc_ids.
      ENDLOOP.
    ENDLOOP.

*****************************************************************************
* 1 Step: get tdcv
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

*****************************************************************************
* 2 Step: prepare update SO2

    CLEAR lt_order_items.
    ls_header_inx-updateflag  = 'U'.

* Check where the changes have to be made.
    LOOP AT ls_testdata-item_list ASSIGNING FIELD-SYMBOL(<ls_item_list>).

      IF <ls_item_list>-posnr IS NOT INITIAL.
        ls_order_items-itm_number = <ls_item_list>-posnr.
      ENDIF.

      ls_order_item_inx-updateflag = 'I'.

      IF <ls_item_list>-material_id IS NOT INITIAL.
        ls_order_items-material = <ls_item_list>-material_id.
        ls_order_item_inx-material = 'X'.
      ENDIF.

      IF <ls_item_list>-werks IS NOT INITIAL.
        ls_order_items-plant = <ls_item_list>-werks.
        ls_order_item_inx-plant = 'X'.
      ENDIF.

      IF <ls_item_list>-quantity IS NOT INITIAL.
        ls_order_items-target_qty = <ls_item_list>-quantity.
        ls_order_item_inx-target_qty = 'X'.
        ls_sched_line-itm_number = <ls_item_list>-posnr.
        ls_sched_line-sched_line = '0001'.
        ls_sched_line-req_qty = <ls_item_list>-quantity.
        APPEND ls_sched_line TO lt_sched_lines.
        ls_sched_line_inx-itm_number = <ls_item_list>-posnr.
        ls_sched_line_inx-sched_line = 'X'.
        ls_sched_line_inx-req_qty = 'X'.
        ls_sched_line_inx-updateflag = 'I'.
        APPEND ls_sched_line_inx TO lt_sched_lines_inx.
      ENDIF.

      APPEND ls_order_items TO lt_order_items.
      APPEND ls_order_item_inx TO lt_order_item_inx.

    ENDLOOP.

*****************************************************************************
* 3 Step: update SO2

    LOOP AT lt_doc_ids ASSIGNING FIELD-SYMBOL(<lv_doc>).
      " change SO2
      CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
        EXPORTING
          salesdocument    = <lv_doc>
          order_header_in  = ls_header_in
          order_header_inx = ls_header_inx  " Sales Order Check List
        TABLES
          return           = lt_return " Return Code
          order_item_in    = lt_order_items  " Order Items
          order_item_inx   = lt_order_item_inx  " Sales Order Items Check Table
          schedule_lines   = lt_sched_lines
          schedule_linesx  = lt_sched_lines_inx.

      cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
    ENDLOOP.

* check if the process ended without errors.
    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ls_return>).
      IF <ls_return>-type = 'S' OR <ls_return>-type = 'W'.  " S for Success or W for warning is also OK
        ev_execution_status = abap_true.
      ELSE.
        ev_execution_status = abap_false.
        RETURN.
      ENDIF.
    ENDLOOP.

    " return info to PTF
    IF ev_execution_status = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = 'success: item(s) added to sales document(s)' ).
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = 'error: could not add item(s) to sales document(s)' ).
    ENDIF.

  ENDMETHOD.


  METHOD add_billing_block.
    DATA: ls_header_inx TYPE bapisdh1x,
          ls_header_in  TYPE bapisdh1,
          ls_return     TYPE bapiret2,
          lt_return     TYPE cl_ptf_util=>gt_ptf_return_tab.

    ls_header_inx-updateflag  = 'U'.
    ls_header_inx-bill_block = 'X'.
    ls_header_in-bill_block  = iv_chance_tdc-billing_block.

    DATA: lv_vbeln TYPE vbeln.
    MOVE iv_order_number TO lv_vbeln.

    CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
      EXPORTING
        salesdocument    = lv_vbeln   " Order Number
        order_header_in  = ls_header_in
        order_header_inx = ls_header_inx  " Sales Order Check List
      TABLES
        return           = lt_return.  " Return Code

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

* Check wether the billingblock is clear.
    SELECT SINGLE faksk FROM vbak INTO @DATA(lv_billing_block) WHERE vbeln = @iv_order_number.
    IF lv_billing_block <> space.
      ev_test_success = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD add_billing_plan.

    CONSTANTS: c_updkz_old      TYPE string VALUE ' ',     "Keine Veraenderung
               c_updkz_new      TYPE string VALUE 'I',     "Neue Position
               c_updkz_update   TYPE string VALUE 'U',     "Geaenderte Position
               c_updkz_mark_del TYPE string VALUE 'd',     "SPE marked for deletion
               c_updkz_delete   TYPE string VALUE 'D'.     "Löschen

    DATA: billing_plan_data     TYPE ty_billing_plan,
          sales_orders          TYPE STANDARD TABLE OF vbeln WITH DEFAULT KEY,
          fpla_new              TYPE STANDARD TABLE OF fplavb WITH DEFAULT KEY,
          fpla_old              TYPE STANDARD TABLE OF fplavb WITH DEFAULT KEY,
          fplt_new              TYPE STANDARD TABLE OF fpltvb WITH DEFAULT KEY,
          fplt_old              TYPE STANDARD TABLE OF fpltvb WITH DEFAULT KEY,
          fpla_entry            TYPE fplavb,
          fplt_entry            TYPE fpltvb,
          created_billing_plan  TYPE fpla-fplnr,
          sales_order_reference TYPE vedavb,
          sales_order_updates   TYPE vbapkom.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = billing_plan_data
    ).

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      APPEND LINES OF ptf_keys TO sales_orders.
    ENDLOOP.

    LOOP AT sales_orders ASSIGNING FIELD-SYMBOL(<sales_order>).

      SELECT SINGLE netwr, waerk FROM vbak WHERE vbeln = @<sales_order> INTO @DATA(sales_doc_data).

      SELECT fplnr FROM fpla WHERE vbeln = @<sales_order> INTO TABLE @DATA(bps_to_update_header).

      CLEAR fpla_new.
      CLEAR fpla_old.
      CLEAR fplt_new.
      CLEAR fplt_old.

      IF bps_to_update_header IS INITIAL.

        SELECT posnr FROM vbap WHERE vbeln = @<sales_order> INTO TABLE @DATA(posnrs).

        LOOP AT posnrs ASSIGNING FIELD-SYMBOL(<posnr>).


          sales_order_reference-vbeln = <sales_order>.
          sales_order_reference-vposn = <posnr>.

          CALL FUNCTION 'BILLING_SCHEDULE_GENERATE'
            EXPORTING
              i_fkdat     = sy-datum
              i_fpart     = billing_plan_data-fpla-fpart
              i_veda      = sales_order_reference
              i_upd_fpla  = abap_true
              i_fpla_only = abap_true
            TABLES
              fpla_new    = fpla_new
              fpla_old    = fpla_old
              fplt_new    = fplt_new
              fplt_old    = fplt_old.

          IF fpla_new IS INITIAL.
            ev_execution_status = abap_false.
            me->mo_run_environment->append_log( iv_log_statement = |Something went wrong while requesting billing plan generation.| ).
            RETURN.
          ENDIF.

          fpla_new[ 1 ]-updkz = c_updkz_new.
          fpla_new[ 1 ]-vbeln = <sales_order>.
          fpla_new[ 1 ]-netwrp = sales_doc_data-netwr.
          fpla_new[ 1 ]-waers = sales_doc_data-waerk.
          fpla_new[ 1 ]-bpcat = billing_plan_data-fpla-bpcat.


          CALL FUNCTION 'BILLING_SCHEDULE_GET_NUMBER'
            EXPORTING
              i_fplnr  = fpla_new[ 1 ]-fplnr
            TABLES
              fpla_new = fpla_new
              fplt_new = fplt_new.

          "fpla_new[ 1 ]-bpcat = billing_plan_data-fpla-bpcat.
          CLEAR fpla_new[ 1 ]-bpcat.
          fpla_new[ 1 ]-updkz = c_updkz_new.
          fpla_new[ 1 ]-vbeln = <sales_order>.
          fpla_new[ 1 ]-netwrp = sales_doc_data-netwr.
          fpla_new[ 1 ]-waers = sales_doc_data-waerk.

          CALL FUNCTION 'BILLING_SCHEDULE_SAVE'
            TABLES
              fpla_new = fpla_new
              fpla_old = fpla_old
              fplt_new = fplt_new
              fplt_old = fplt_old.

          COMMIT WORK AND WAIT.

        ENDLOOP.

      ELSE.
        LOOP AT bps_to_update_header ASSIGNING FIELD-SYMBOL(<bp_to_update_header>).

          MOVE-CORRESPONDING billing_plan_data-fpla TO fpla_entry.
          fpla_entry-updkz = c_updkz_update.
          fpla_entry-vbeln = <sales_order>.
          fpla_entry-fplnr = <bp_to_update_header>-fplnr.
          fpla_entry-netwrp = sales_doc_data-netwr.
          fpla_entry-waers = sales_doc_data-waerk.
          APPEND fpla_entry TO fpla_new.

        ENDLOOP.

        CALL FUNCTION 'BILLING_SCHEDULE_SAVE'
          TABLES
            fpla_new = fpla_new
            fpla_old = fpla_old
            fplt_new = fplt_new
            fplt_old = fplt_old.

        COMMIT WORK AND WAIT.

      ENDIF.

      SELECT fplnr FROM fpla WHERE vbeln = @<sales_order> INTO TABLE @DATA(bps_to_update_pos).

      IF bps_to_update_pos IS INITIAL.
        me->mo_run_environment->append_log( |There is no billing plan for sales order { <sales_order> }. Probably you have chosen the wrong variant.| ).
        ev_execution_status = abap_false.
        RETURN.
      ENDIF.

      LOOP AT posnrs ASSIGNING FIELD-SYMBOL(<pos_to_update>).
        LOOP AT bps_to_update_pos ASSIGNING FIELD-SYMBOL(<bp_to_update_pos>).

          CLEAR fpla_new.
          CLEAR fpla_old.
          CLEAR fplt_new.
          CLEAR fplt_old.

          LOOP AT billing_plan_data-fplt ASSIGNING FIELD-SYMBOL(<fplt_entry>).
            <fplt_entry>-mandt = sy-mandt.
            <fplt_entry>-updkz = c_updkz_new.
            <fplt_entry>-fplnr = <bp_to_update_pos>-fplnr.

            IF <fplt_entry>-fkdat IS INITIAL.
              LOOP AT billing_plan_data-billing_plan_item_date ASSIGNING FIELD-SYMBOL(<billgplnitmdate>) WHERE billingplanitem = <fplt_entry>-fpltr.
                IF <billgplnitmdate>-days_delta IS NOT INITIAL.
                  <fplt_entry>-fkdat = sy-datum + <billgplnitmdate>-days_delta.
                ELSE.
                  <fplt_entry>-fkdat = sy-datum.
                ENDIF.
              ENDLOOP.
              IF sy-subrc = 4.
                <fplt_entry>-fkdat = sy-datum.
              ENDIF.
            ENDIF.

            IF <fplt_entry>-tetxt EQ 'Y008'. "Closing Invoice
              SELECT SINGLE netwr FROM vbak WHERE vbeln = @<sales_order> INTO @DATA(fakwr).
              <fplt_entry>-fakwr = fakwr.
            ENDIF.

            APPEND <fplt_entry> TO fplt_new.
          ENDLOOP.

          CALL FUNCTION 'BILLING_SCHEDULE_SAVE'
            TABLES
              fpla_new = fpla_new
              fpla_old = fpla_old
              fplt_new = fplt_new
              fplt_old = fplt_old.

          COMMIT WORK AND WAIT.

          APPEND <bp_to_update_pos> TO ev_document_id.

          me->mo_run_environment->append_log( iv_log_statement = |Created or updated billing plan { <bp_to_update_pos>-fplnr } for: { <sales_order> }| ).

          "Update sales order data
          SELECT SINGLE * FROM vbkd WHERE vbeln = @<sales_order> AND posnr = '' INTO @DATA(vbkd_entry).

          vbkd_entry-posnr = <pos_to_update>-posnr.
          vbkd_entry-fplnr = <bp_to_update_pos>-fplnr.
          INSERT vbkd FROM vbkd_entry.

          COMMIT WORK AND WAIT.

          SELECT *  FROM vbkd WHERE vbeln = @<sales_order> INTO TABLE @DATA(vbkd_entries).


          "UPDATE vbkd SET fplnr = @<bp_to_update_pos>-fplnr WHERE vbeln = @<sales_order> AND posnr = @<pos_to_update>-posnr.

*          DATA: vbak     TYPE vbak,
*                vbkd     TYPE vbkd,
*                vbakkom  TYPE vbakkom,
*                kuagv    TYPE  kuagv,
*                vbap     TYPE vbap,
*                bapisdls TYPE bapisdls.
*
*          CALL FUNCTION 'SD_SALES_DOCUMENT_READ'
*            EXPORTING
*              document_number = <sales_order>
*            IMPORTING
*              evbak           = vbak
*              evbkd           = vbkd
*              evbakkom        = vbakkom
*              ekuagv          = kuagv.
*
*          CALL FUNCTION 'SD_SALES_ITEM_READ'
*            EXPORTING
*              item_number   = <pos_to_update>-posnr
*            IMPORTING
*              evbapkom      = sales_order_updates
*              evbap         = vbap
*              evbkd         = vbkd
*            EXCEPTIONS
*              error_message = 1
*              OTHERS        = 2.
*          IF sy-subrc <> 0.
*            me->mo_run_environment->append_log( iv_log_statement = |Something went wrong.| ).
*            ev_execution_status = abap_false.
*            RETURN.
*          ENDIF.
*
*          sales_order_updates-fplnr = <bp_to_update_pos>.
*          vbkd-fplnr = <bp_to_update_pos>.
*          vbkd-posnr = <pos_to_update>-posnr.
*
*          CALL FUNCTION 'SD_SALES_ITEM_MAINTAIN'
*            EXPORTING
*              fvbapkom      = sales_order_updates
*              logic_switch  = bapisdls
*            IMPORTING
*              evbap         = vbap
*              evbkd         = vbkd
*            EXCEPTIONS
*              error_message = 1.
*
*          IF sy-subrc <> 0.
*            me->mo_run_environment->append_log( iv_log_statement = |Something went wrong.| ).
*            ev_execution_status = abap_false.
*            RETURN.
*          ENDIF.
*
*          CALL FUNCTION 'SD_SALES_DOCUMENT_SAVE'
*            EXPORTING
*              synchron      = abap_true
*            IMPORTING
*              evbak         = vbak
*            EXCEPTIONS
*              error_message = 1.
*
*          IF sy-subrc <> 0.
*            me->mo_run_environment->append_log( iv_log_statement = |Something went wrong.| ).
*            ev_execution_status = abap_false.
*            RETURN.
*          ENDIF.

        ENDLOOP.
      ENDLOOP.
    ENDLOOP.

    ev_execution_status = abap_true.

  ENDMETHOD.


  METHOD add_f_item_bp_goal.

    DATA: lt_doc_ids TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings,
          lo_access           TYPE REF TO if_goal_access,
          ls_error            TYPE if_goal_types=>tcs_error,
          lx_goal_exc         TYPE REF TO cx_goal_exc,
          lv_text_exc         TYPE string,
          lv_field            TYPE fieldname,
          ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
          lt_changed_field    TYPE if_goal_types=>tct_changed_field.

    DATA: lv_bo_key         TYPE if_goal_types=>tcd_bo_key,
          lt_item_data      TYPE STANDARD TABLE OF tds_goal_so_item,
          ls_head_data      TYPE tds_goal_so_head,
          ls_i_bplh_data    TYPE tds_goal_sdoc_bplh,
          ls_i_bpli_data    TYPE tds_goal_sdoc_bpli,
          lt_i_bpli_data    TYPE STANDARD TABLE OF tds_goal_sdoc_bpli,
          billing_plan_data TYPE ty_billing_plan,
          lv_statement      TYPE bapi_msg.

    ev_execution_status = abap_false.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = billing_plan_data ).

* 1 Step: get previously step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_doc_ids.
    ENDLOOP.

    READ TABLE lt_doc_ids INTO DATA(ls_doc_id) INDEX 1.
    IF sy-subrc = 0.
      lv_bo_key = ls_doc_id-vbeln.
    ENDIF.

    IF lv_bo_key IS INITIAL.
      lv_statement = 'Error: No sales order is found!'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      EXIT.
    ENDIF.

* 2 Step: Access sales order via GOAL
* ===================================================
* open the document in change mode
* ===================================================
    TRY.
        CALL METHOD cl_goal_api=>so_instance->open
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_bo_key
            iv_read_only        = abap_false
            is_control_settings = ls_control_settings
          RECEIVING
            ro_access           = lo_access.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read header data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id   = if_goal_sdoc_head=>co_entity_id
          IMPORTING
            es_entity_data = ls_head_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read item data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id   = if_goal_sdoc_item=>co_entity_id
          IMPORTING
            et_entity_data = lt_item_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* Add billing plan for first item
* ===================================================
    READ TABLE lt_item_data INTO DATA(ls_item_data) INDEX 1.
    IF sy-subrc <> 0.
      lv_statement = 'Success: Sales order has not an item!'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      EXIT.
    ENDIF.
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bplh
            iv_handle_parent = ls_item_data-handle
          IMPORTING
            es_entity_data   = ls_i_bplh_data.

        IF NOT ls_i_bplh_data IS INITIAL.
          DO 1 TIMES.
            CHECK NOT ls_i_bplh_data-head_assignment_ind IS INITIAL.

            CLEAR: ls_changed_field.
            lv_field = 'HEAD_ASSIGNMENT_IND'.
            INSERT lv_field INTO TABLE ls_changed_field-field.
            CLEAR: ls_i_bplh_data-head_assignment_ind.
            ls_changed_field-handle = ls_i_bplh_data-handle.

            CALL METHOD lo_access->set_entity
              EXPORTING
                iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bplh
                iv_handle_parent = ls_item_data-handle
                is_entity_data   = ls_i_bplh_data
                is_changed_field = ls_changed_field.
          ENDDO.
        ENDIF.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* add item billing plan items
* ===================================================
    LOOP AT billing_plan_data-fplt ASSIGNING FIELD-SYMBOL(<fplt_entry>).
      CLEAR: ls_changed_field, ls_i_bpli_data.

      lv_field = 'BILLING_DATE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_i_bpli_data-billing_date = sy-datum.

      lv_field = 'DATE_CATEGORY_CODE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_i_bpli_data-date_category_code = <fplt_entry>-fpttp.

      lv_field = 'DATE_DESCR_CODE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_i_bpli_data-date_descr_code = <fplt_entry>-tetxt.

      lv_field = 'BPLAN_RULE_CODE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_i_bpli_data-bplan_rule_code = <fplt_entry>-fareg.

      lv_field = 'AMOUNT'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_i_bpli_data-amount = <fplt_entry>-fakwr.

      lv_field = 'BILLING_BLOCK_CODE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_i_bpli_data-billing_block_code = <fplt_entry>-faksp.

      lv_field = 'PROP_BILLING_TYPE_CODE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_i_bpli_data-prop_billing_type_code = <fplt_entry>-fkarv.

      ls_changed_field-handle = cl_goal_util=>so_instance->create_guid( ).
      ls_i_bpli_data-handle = ls_changed_field-handle.

      APPEND ls_changed_field TO lt_changed_field.
      APPEND ls_i_bpli_data TO lt_i_bpli_data.
    ENDLOOP.

    TRY.
        CALL METHOD lo_access->set_entity_set
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bpli
            iv_handle_parent = ls_i_bplh_data-handle
            it_entity_data   = lt_i_bpli_data
            it_changed_field = lt_changed_field.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
*----------------------
*   save
*----------------------
    lo_access->save( ).
    lo_access->get_messages( IMPORTING et_message = DATA(lt_message)
                                       es_error   = ls_error ).
    IF NOT ls_error IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = ls_error-msgtx ).
      lo_access->close( ).
      EXIT.
    ELSE.
      lo_access->close( ).
    ENDIF.

    lv_statement = 'Success: add first item level billing plan dates done!'.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ev_execution_status = abap_true.
  ENDMETHOD.


  METHOD add_head_bpl_goal.
    DATA: lt_doc_ids TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings,
          lo_access           TYPE REF TO if_goal_access,
          ls_error            TYPE if_goal_types=>tcs_error,
          lx_goal_exc         TYPE REF TO cx_goal_exc,
          lv_text_exc         TYPE string,
          lv_field            TYPE fieldname,
          ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
          lt_changed_field    TYPE if_goal_types=>tct_changed_field.

    DATA: lv_bo_key         TYPE if_goal_types=>tcd_bo_key,
          lt_item_data      TYPE STANDARD TABLE OF tds_goal_so_item,
          ls_head_data      TYPE tds_goal_so_head,
          ls_h_bplh_data    TYPE tds_goal_sdoc_bplh,
          ls_h_bpli_data    TYPE tds_goal_sdoc_bpli,
          lt_h_bpli_data    TYPE STANDARD TABLE OF tds_goal_sdoc_bpli,
          billing_plan_data TYPE ty_billing_plan,
          lv_statement      TYPE bapi_msg.

    ev_execution_status = abap_false.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = billing_plan_data ).

* 1 Step: get previously step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_doc_ids.
    ENDLOOP.

    READ TABLE lt_doc_ids INTO DATA(ls_doc_id) INDEX 1.
    IF sy-subrc = 0.
      lv_bo_key = ls_doc_id-vbeln.
    ENDIF.

    IF lv_bo_key IS INITIAL.
      lv_statement = 'Error: No sales order is found!'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      EXIT.
    ENDIF.

* 2 Step: Access sales order via GOAL
* ===================================================
* open the document in change mode
* ===================================================
    TRY.
        CALL METHOD cl_goal_api=>so_instance->open
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_bo_key
            iv_read_only        = abap_false
            is_control_settings = ls_control_settings
          RECEIVING
            ro_access           = lo_access.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read header data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id   = if_goal_sdoc_head=>co_entity_id
          IMPORTING
            es_entity_data = ls_head_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read head billing plan header
* ===================================================
    CHECK NOT ls_head_data IS INITIAL.
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-head_bplh
            iv_handle_parent = ls_head_data-handle
          IMPORTING
            es_entity_data   = ls_h_bplh_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* add head billing plan item
* ===================================================
    LOOP AT billing_plan_data-fplt ASSIGNING FIELD-SYMBOL(<fplt_entry>).
      CLEAR: ls_changed_field, ls_h_bpli_data.

      lv_field = 'BILLING_DATE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_h_bpli_data-billing_date = sy-datum.

      lv_field = 'DATE_CATEGORY_CODE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_h_bpli_data-date_category_code = <fplt_entry>-fpttp.

      lv_field = 'DATE_DESCR_CODE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_h_bpli_data-date_descr_code = <fplt_entry>-tetxt.

      lv_field = 'BPLAN_RULE_CODE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_h_bpli_data-bplan_rule_code = <fplt_entry>-fareg.

      lv_field = 'AMOUNT'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_h_bpli_data-amount = <fplt_entry>-fakwr.

      lv_field = 'BILLING_BLOCK_CODE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_h_bpli_data-billing_block_code = <fplt_entry>-faksp.

      lv_field = 'PROP_BILLING_TYPE_CODE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_h_bpli_data-prop_billing_type_code = <fplt_entry>-fkarv.

      ls_changed_field-handle = cl_goal_util=>so_instance->create_guid( ).
      ls_h_bpli_data-handle = ls_changed_field-handle.

      APPEND ls_changed_field TO lt_changed_field.
      APPEND ls_h_bpli_data TO lt_h_bpli_data.
    ENDLOOP.

    TRY.
        CALL METHOD lo_access->set_entity_set
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-head_bpli
            iv_handle_parent = ls_h_bplh_data-handle
            it_entity_data   = lt_h_bpli_data
            it_changed_field = lt_changed_field.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.

    lo_access->save( ).
    lo_access->get_messages( IMPORTING et_message = DATA(lt_message)
                                       es_error   = ls_error ).
    IF NOT ls_error IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = ls_error-msgtx ).
      lo_access->close( ).
      EXIT.
    ELSE.
      lo_access->close( ).
    ENDIF.

    lv_statement = 'Success: Add header level billing plan dates was done!'.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ev_execution_status = abap_true.
  ENDMETHOD.


  METHOD add_higher_level_item.
    DATA: lt_doc_ids TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings,
          lo_access           TYPE REF TO if_goal_access,
          ls_error            TYPE if_goal_types=>tcs_error,
          lx_goal_exc         TYPE REF TO cx_goal_exc,
          lv_text_exc         TYPE string,
          lv_field            TYPE fieldname,
          ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
          lt_changed_field    TYPE if_goal_types=>tct_changed_field.

    DATA: lv_bo_key     TYPE if_goal_types=>tcd_bo_key,
          ls_item_data  TYPE tds_goal_so_item,
          lt_item_data  TYPE STANDARD TABLE OF tds_goal_so_item,
          ls_head_data  TYPE tds_goal_so_head,
          ls_sline_data TYPE tds_goal_so_sline,
          lt_sline_data TYPE STANDARD TABLE OF tds_goal_so_sline,
          lv_statement  TYPE bapi_msg.

    DATA: lv_error TYPE abap_bool VALUE abap_false.

    ev_execution_status = abap_false.

* 1 Step: get previously step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_doc_ids.
    ENDLOOP.

    READ TABLE lt_doc_ids INTO DATA(ls_doc_id) INDEX 1.
    IF sy-subrc = 0.
      lv_bo_key = ls_doc_id-vbeln.
    ENDIF.

    IF lv_bo_key IS INITIAL.
      lv_statement = 'Error: No sales order is found!'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      EXIT.
    ENDIF.

* 2 Step: Access sales order via GOAL
* ===================================================
* open the document in change mode
* ===================================================
    TRY.
        CALL METHOD cl_goal_api=>so_instance->open
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_bo_key
            iv_read_only        = abap_false
            is_control_settings = ls_control_settings
          RECEIVING
            ro_access           = lo_access.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read header data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id   = if_goal_sdoc_head=>co_entity_id
          IMPORTING
            es_entity_data = ls_head_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* create item
* ===================================================
    CLEAR ls_item_data.
    ls_item_data-handle = cl_goal_util=>so_instance->create_guid( ).
    ls_item_data-material_id = 'TG11'.
    ls_item_data-category_code = 'CBAO'.
    ls_item_data-higher_level_item_id = 10.
    "ls_item_data-ITEM_ID = 40.
    ls_item_data-order_qty = 1.
    APPEND ls_item_data TO lt_item_data.

    CLEAR ls_changed_field.
    ls_changed_field-handle = ls_item_data-handle.
    lv_field = 'MATERIAL_ID'.
    INSERT lv_field INTO TABLE ls_changed_field-field.
    lv_field = 'ORDER_QTY'.
    INSERT lv_field INTO TABLE ls_changed_field-field.
    lv_field = 'CATEGORY_CODE'.
    INSERT lv_field INTO TABLE ls_changed_field-field.
    lv_field = 'HIGHER_LEVEL_ITEM_ID'.
    INSERT lv_field INTO TABLE ls_changed_field-field.
    "lv_field = 'ITEM_ID'.
    "INSERT lv_field INTO TABLE ls_changed_field-field.

    APPEND ls_changed_field TO lt_changed_field.

    TRY.
        lo_access->set_entity_set( iv_entity_id     = if_goal_sdoc_item=>co_entity_id
                                   it_entity_data   = lt_item_data
                                   it_changed_field = lt_changed_field ).
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.

    lo_access->save( ).
    lo_access->get_messages( IMPORTING et_message = DATA(lt_message)
                                       es_error   = ls_error ).
    IF NOT ls_error IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = ls_error-msgtx ).
      lo_access->close( ).
      EXIT.
    ELSE.
      lo_access->close( ).
    ENDIF.

    lv_statement = 'Success: Add sales order higher level item was done!'.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ev_execution_status = abap_true.
  ENDMETHOD.


  METHOD add_item_billing_plan.
    DATA: lt_sales_orders TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings,
          lo_access           TYPE REF TO if_goal_access,
          ls_error            TYPE if_goal_types=>tcs_error,
          lx_goal_exc         TYPE REF TO cx_goal_exc,
          lv_text_exc         TYPE string,
          lv_field            TYPE fieldname,
          ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
          lt_changed_field    TYPE if_goal_types=>tct_changed_field.

    DATA: lv_bo_key         TYPE if_goal_types=>tcd_bo_key,
          lt_item_data      TYPE STANDARD TABLE OF tds_goal_so_item,
          ls_head_data      TYPE tds_goal_so_head,
          ls_i_bplh_data    TYPE tds_goal_sdoc_bplh,
          ls_i_bpli_data    TYPE tds_goal_sdoc_bpli,
          lt_i_bpli_data    TYPE STANDARD TABLE OF tds_goal_sdoc_bpli,
          billing_plan_data TYPE ty_billing_plan,
          lv_statement      TYPE bapi_msg.

    ev_execution_status = abap_false.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = billing_plan_data ).

* 1 Step: get previously step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_sales_orders.
    ENDLOOP.

    READ TABLE lt_sales_orders INTO DATA(ls_sales_order) INDEX 1.
    IF sy-subrc = 0.
      lv_bo_key = ls_sales_order-vbeln.
    ENDIF.

    IF lv_bo_key IS INITIAL.
      lv_statement = 'Error: No sales order is found!'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      EXIT.
    ENDIF.

* 2 Step: Access sales order via GOAL
* ===================================================
* Open the document in change mode
* ===================================================
    TRY.
        CALL METHOD cl_goal_api=>so_instance->open
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_bo_key
            iv_read_only        = abap_false
            is_control_settings = ls_control_settings
          RECEIVING
            ro_access           = lo_access.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* Read item data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id   = if_goal_sdoc_item=>co_entity_id
          IMPORTING
            et_entity_data = lt_item_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* Add billing plan for all items
* ===================================================
    IF lt_item_data IS INITIAL.
      lv_statement = 'Sales order does not have items!'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      EXIT.
    ENDIF.
    LOOP AT lt_item_data INTO DATA(ls_item_data).
      TRY.
          "Get header of item billing plan
          CALL METHOD lo_access->get_entity
            EXPORTING
              iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bplh
              iv_handle_parent = ls_item_data-handle
            IMPORTING
              es_entity_data   = ls_i_bplh_data.

          "Delete assignment to header billing plan
          IF ls_i_bplh_data IS NOT INITIAL AND ls_i_bplh_data-head_assignment_ind IS NOT INITIAL.
            CLEAR: ls_changed_field.
            lv_field = 'HEAD_ASSIGNMENT_IND'.
            INSERT lv_field INTO TABLE ls_changed_field-field.
            CLEAR: ls_i_bplh_data-head_assignment_ind.
            ls_changed_field-handle = ls_i_bplh_data-handle.

            CALL METHOD lo_access->set_entity
              EXPORTING
                iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bplh
                iv_handle_parent = ls_item_data-handle
                is_entity_data   = ls_i_bplh_data
                is_changed_field = ls_changed_field.
          ENDIF.
        CATCH cx_goal_exc INTO lx_goal_exc.
          lv_text_exc = lx_goal_exc->get_text( ).
          me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
          EXIT.
      ENDTRY.

      "Add item billing plan items
      LOOP AT billing_plan_data-fplt ASSIGNING FIELD-SYMBOL(<fplt_entry>).
        CLEAR: ls_changed_field, ls_i_bpli_data.

        "Determine billing plan item date
        IF <fplt_entry>-fkdat IS INITIAL.
          <fplt_entry>-fkdat = sy-datum.
          LOOP AT billing_plan_data-billing_plan_item_date ASSIGNING FIELD-SYMBOL(<billgplnitmdate>) WHERE billingplanitem = <fplt_entry>-fpltr.
            IF <billgplnitmdate>-days_delta IS NOT INITIAL.
              <fplt_entry>-fkdat = sy-datum + <billgplnitmdate>-days_delta.
            ENDIF.
          ENDLOOP.
        ENDIF.

        lv_field = 'BILLING_DATE'.
        INSERT lv_field INTO TABLE ls_changed_field-field.
        ls_i_bpli_data-billing_date = <fplt_entry>-fkdat.

        lv_field = 'DATE_CATEGORY_CODE'.
        INSERT lv_field INTO TABLE ls_changed_field-field.
        ls_i_bpli_data-date_category_code = <fplt_entry>-fpttp.

        lv_field = 'DATE_DESCR_CODE'.
        INSERT lv_field INTO TABLE ls_changed_field-field.
        ls_i_bpli_data-date_descr_code = <fplt_entry>-tetxt.

        lv_field = 'BPLAN_RULE_CODE'.
        INSERT lv_field INTO TABLE ls_changed_field-field.
        ls_i_bpli_data-bplan_rule_code = <fplt_entry>-fareg.

        lv_field = 'AMOUNT'.
        INSERT lv_field INTO TABLE ls_changed_field-field.
        ls_i_bpli_data-amount = <fplt_entry>-fakwr.

        lv_field = 'BILLING_BLOCK_CODE'.
        INSERT lv_field INTO TABLE ls_changed_field-field.
        ls_i_bpli_data-billing_block_code = <fplt_entry>-faksp.

        lv_field = 'PROP_BILLING_TYPE_CODE'.
        INSERT lv_field INTO TABLE ls_changed_field-field.
        ls_i_bpli_data-prop_billing_type_code = <fplt_entry>-fkarv.

        ls_changed_field-handle = cl_goal_util=>so_instance->create_guid( ).
        ls_i_bpli_data-handle = ls_changed_field-handle.

        APPEND ls_changed_field TO lt_changed_field.
        APPEND ls_i_bpli_data TO lt_i_bpli_data.
      ENDLOOP.

      TRY.
          CALL METHOD lo_access->set_entity_set
            EXPORTING
              iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bpli
              iv_handle_parent = ls_i_bplh_data-handle
              it_entity_data   = lt_i_bpli_data
              it_changed_field = lt_changed_field.
        CATCH cx_goal_exc INTO lx_goal_exc.
          lv_text_exc = lx_goal_exc->get_text( ).
          me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
          EXIT.
      ENDTRY.
    ENDLOOP.

* 3 Step: Save
    lo_access->save( ).
    lo_access->get_messages( IMPORTING et_message = DATA(lt_message)
                                       es_error   = ls_error ).
    IF ls_error IS NOT INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = ls_error-msgtx ).
      lo_access->close( ).
      EXIT.
    ELSE.
      lo_access->close( ).
    ENDIF.

    "Get item billing plan number
    SELECT SINGLE fplnr_ana FROM vbap WHERE vbeln = @lv_bo_key INTO @DATA(lv_fplnr).
    IF lv_fplnr IS INITIAL.
      lv_statement = 'Sales Order does not have an item billing plan'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      EXIT.
    ENDIF.

    APPEND lv_fplnr TO ev_document_id.
    me->mo_run_environment->append_log( iv_log_statement = |Created billing plan { lv_fplnr } for sales order { lv_bo_key }| ).
    ev_execution_status = abap_true.

  ENDMETHOD.


  METHOD add_item_billing_plan_bom.


    DATA: lt_sales_orders TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings,
          lo_access           TYPE REF TO if_goal_access,
          ls_error            TYPE if_goal_types=>tcs_error,
          lx_goal_exc         TYPE REF TO cx_goal_exc,
          lv_text_exc         TYPE string,
          lv_field            TYPE fieldname,
          ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
          lt_changed_field    TYPE if_goal_types=>tct_changed_field.

    DATA: lv_bo_key         TYPE if_goal_types=>tcd_bo_key,
          lt_item_data      TYPE STANDARD TABLE OF tds_goal_so_item,
          ls_head_data      TYPE tds_goal_so_head,
          ls_i_bplh_data    TYPE tds_goal_sdoc_bplh,
          ls_i_bpli_data    TYPE tds_goal_sdoc_bpli,
          lt_i_bpli_data    TYPE STANDARD TABLE OF tds_goal_sdoc_bpli,
          billing_plan_data TYPE ty_billing_plan,
          lv_statement      TYPE bapi_msg.

    ev_execution_status = abap_false.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = billing_plan_data ).

* 1 Step: get previously step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_sales_orders.
    ENDLOOP.

    READ TABLE lt_sales_orders INTO DATA(ls_sales_order) INDEX 1.
    IF sy-subrc = 0.
      lv_bo_key = ls_sales_order-vbeln.
    ENDIF.

    IF lv_bo_key IS INITIAL.
      lv_statement = 'Error: No sales order is found!'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      EXIT.
    ENDIF.

* 2 Step: Access sales order via GOAL
* ===================================================
* Open the document in change mode
* ===================================================
    TRY.
        CALL METHOD cl_goal_api=>so_instance->open
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_bo_key
            iv_read_only        = abap_false
            is_control_settings = ls_control_settings
          RECEIVING
            ro_access           = lo_access.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* Read item data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id   = if_goal_sdoc_item=>co_entity_id
          IMPORTING
            et_entity_data = lt_item_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* Add billing plan for all items
* ===================================================
    IF lt_item_data IS INITIAL.
      lv_statement = 'Sales order does not have items!'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      EXIT.
    ENDIF.

    READ TABLE lt_item_data INTO DATA(ls_item_data) INDEX 1.
    TRY.
        "Get header of item billing plan
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bplh
            iv_handle_parent = ls_item_data-handle
          IMPORTING
            es_entity_data   = ls_i_bplh_data.

      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.

    "Add item billing plan items
    LOOP AT billing_plan_data-fplt ASSIGNING FIELD-SYMBOL(<fplt_entry>).
      CLEAR: ls_changed_field, ls_i_bpli_data.

      "Determine billing plan item date
      IF <fplt_entry>-fkdat IS INITIAL.
        <fplt_entry>-fkdat = sy-datum.
        LOOP AT billing_plan_data-billing_plan_item_date ASSIGNING FIELD-SYMBOL(<billgplnitmdate>) WHERE billingplanitem = <fplt_entry>-fpltr.
          IF <billgplnitmdate>-days_delta IS NOT INITIAL.
            <fplt_entry>-fkdat = sy-datum + <billgplnitmdate>-days_delta.
          ENDIF.
        ENDLOOP.
      ENDIF.

      lv_field = 'BILLING_DATE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_i_bpli_data-billing_date = <fplt_entry>-fkdat.

      lv_field = 'DATE_CATEGORY_CODE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_i_bpli_data-date_category_code = <fplt_entry>-fpttp.

      lv_field = 'DATE_DESCR_CODE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_i_bpli_data-date_descr_code = <fplt_entry>-tetxt.

      lv_field = 'BPLAN_RULE_CODE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_i_bpli_data-bplan_rule_code = <fplt_entry>-fareg.

      lv_field = 'AMOUNT'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_i_bpli_data-amount = <fplt_entry>-fakwr.

      lv_field = 'BILLING_BLOCK_CODE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_i_bpli_data-billing_block_code = <fplt_entry>-faksp.

      lv_field = 'PROP_BILLING_TYPE_CODE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_i_bpli_data-prop_billing_type_code = <fplt_entry>-fkarv.

      ls_changed_field-handle = cl_goal_util=>so_instance->create_guid( ).
      ls_i_bpli_data-handle = ls_changed_field-handle.

      APPEND ls_changed_field TO lt_changed_field.
      APPEND ls_i_bpli_data TO lt_i_bpli_data.
    ENDLOOP.

    TRY.
        CALL METHOD lo_access->set_entity_set
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bpli
            iv_handle_parent = ls_i_bplh_data-handle
            it_entity_data   = lt_i_bpli_data
            it_changed_field = lt_changed_field.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.

* 3 Step: Save
    lo_access->save( ).
    lo_access->get_messages( IMPORTING et_message = DATA(lt_message)
                                       es_error   = ls_error ).
    IF ls_error IS NOT INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = ls_error-msgtx ).
      lo_access->close( ).
      EXIT.
    ELSE.
      lo_access->close( ).
    ENDIF.

    "Get item billing plan number
    "SELECT SINGLE fplnr_ana FROM vbap WHERE vbeln = @lv_bo_key INTO @DATA(lv_fplnr).
    "IF lv_fplnr IS INITIAL.
    "lv_statement = 'Sales Order does not have an item billing plan'.
    "me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    "EXIT.
    "ENDIF.

    "APPEND lv_fplnr TO ev_document_id.
    "me->mo_run_environment->append_log( iv_log_statement = |Created billing plan { lv_fplnr } for sales order { lv_bo_key }| ).
    ev_execution_status = abap_true.

  ENDMETHOD.


  METHOD add_item_bom_goal.
    DATA: lt_doc_ids TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings,
          lo_access           TYPE REF TO if_goal_access,
          ls_error            TYPE if_goal_types=>tcs_error,
          lx_goal_exc         TYPE REF TO cx_goal_exc,
          lv_text_exc         TYPE string,
          lv_field            TYPE fieldname,
          ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
          lt_changed_field    TYPE if_goal_types=>tct_changed_field.

    DATA: lv_bo_key     TYPE if_goal_types=>tcd_bo_key,
          ls_item_data  TYPE tds_goal_so_item,
          lt_item_data  TYPE STANDARD TABLE OF tds_goal_so_item,
          ls_head_data  TYPE tds_goal_so_head,
          ls_sline_data TYPE tds_goal_so_sline,
          lt_sline_data TYPE STANDARD TABLE OF tds_goal_so_sline,
          lv_statement  TYPE bapi_msg.

    DATA: lv_error TYPE abap_bool VALUE abap_false.

    ev_execution_status = abap_false.

* 1 Step: get previously step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_doc_ids.
    ENDLOOP.

    READ TABLE lt_doc_ids INTO DATA(ls_doc_id) INDEX 1.
    IF sy-subrc = 0.
      lv_bo_key = ls_doc_id-vbeln.
    ENDIF.

    IF lv_bo_key IS INITIAL.
      lv_statement = 'Error: No sales order is found!'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      EXIT.
    ENDIF.

* 2 Step: Access sales order via GOAL
* ===================================================
* open the document in change mode
* ===================================================
    TRY.
        CALL METHOD cl_goal_api=>so_instance->open
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_bo_key
            iv_read_only        = abap_false
            is_control_settings = ls_control_settings
          RECEIVING
            ro_access           = lo_access.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read header data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id   = if_goal_sdoc_head=>co_entity_id
          IMPORTING
            es_entity_data = ls_head_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* create item
* ===================================================
    CLEAR ls_item_data.
    ls_item_data-handle = cl_goal_util=>so_instance->create_guid( ).
    ls_item_data-material_id = 'SDBOMLUMFHD'.
    ls_item_data-category_code = 'CBTP'.
    ls_item_data-order_qty = 1.
    APPEND ls_item_data TO lt_item_data.

    CLEAR ls_changed_field.
    ls_changed_field-handle = ls_item_data-handle.
    lv_field = 'MATERIAL_ID'.
    INSERT lv_field INTO TABLE ls_changed_field-field.
    lv_field = 'ORDER_QTY'.
    INSERT lv_field INTO TABLE ls_changed_field-field.
    lv_field = 'CATEGORY_CODE'.
    INSERT lv_field INTO TABLE ls_changed_field-field.
    APPEND ls_changed_field TO lt_changed_field.

    CLEAR ls_item_data.
    ls_item_data-handle = cl_goal_util=>so_instance->create_guid( ).
    ls_item_data-material_id = 'SDBOMERLAHD'.
    ls_item_data-category_code = 'CBTQ'.
    ls_item_data-order_qty = 1.
    APPEND ls_item_data TO lt_item_data.

    CLEAR ls_changed_field.
    ls_changed_field-handle = ls_item_data-handle.
    lv_field = 'MATERIAL_ID'.
    INSERT lv_field INTO TABLE ls_changed_field-field.
    lv_field = 'ORDER_QTY'.
    INSERT lv_field INTO TABLE ls_changed_field-field.
    lv_field = 'CATEGORY_CODE'.
    INSERT lv_field INTO TABLE ls_changed_field-field.
    APPEND ls_changed_field TO lt_changed_field.

    TRY.
        lo_access->set_entity_set( iv_entity_id     = if_goal_sdoc_item=>co_entity_id
                                   it_entity_data   = lt_item_data
                                   it_changed_field = lt_changed_field ).
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.

    lo_access->save( ).
    lo_access->get_messages( IMPORTING et_message = DATA(lt_message)
                                       es_error   = ls_error ).
    IF NOT ls_error IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = ls_error-msgtx ).
      lo_access->close( ).
      EXIT.
    ELSE.
      lo_access->close( ).
    ENDIF.

    lv_statement = 'Success: Add sales order item with BoM was done!'.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ev_execution_status = abap_true.
  ENDMETHOD.


  METHOD add_item_bpl_goal.
    DATA: lt_doc_ids TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings,
          lo_access           TYPE REF TO if_goal_access,
          ls_error            TYPE if_goal_types=>tcs_error,
          lx_goal_exc         TYPE REF TO cx_goal_exc,
          lv_text_exc         TYPE string,
          lv_field            TYPE fieldname,
          ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
          lt_changed_field    TYPE if_goal_types=>tct_changed_field.

    DATA: lv_bo_key         TYPE if_goal_types=>tcd_bo_key,
          lt_item_data      TYPE STANDARD TABLE OF tds_goal_so_item,
          ls_head_data      TYPE tds_goal_so_head,
          ls_i_bplh_data    TYPE tds_goal_sdoc_bplh,
          ls_i_bpli_data    TYPE tds_goal_sdoc_bpli,
          lt_i_bpli_data    TYPE STANDARD TABLE OF tds_goal_sdoc_bpli,
          billing_plan_data TYPE ty_billing_plan,
          lv_statement      TYPE bapi_msg.

    ev_execution_status = abap_false.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = billing_plan_data ).

* 1 Step: get previously step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_doc_ids.
    ENDLOOP.

    READ TABLE lt_doc_ids INTO DATA(ls_doc_id) INDEX 1.
    IF sy-subrc = 0.
      lv_bo_key = ls_doc_id-vbeln.
    ENDIF.

    IF lv_bo_key IS INITIAL.
      lv_statement = 'Error: No sales order is found!'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      EXIT.
    ENDIF.

* 2 Step: Access sales order via GOAL
* ===================================================
* open the document in change mode
* ===================================================
    TRY.
        CALL METHOD cl_goal_api=>so_instance->open
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_bo_key
            iv_read_only        = abap_false
            is_control_settings = ls_control_settings
          RECEIVING
            ro_access           = lo_access.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read header data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id   = if_goal_sdoc_head=>co_entity_id
          IMPORTING
            es_entity_data = ls_head_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read item data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id   = if_goal_sdoc_item=>co_entity_id
          IMPORTING
            et_entity_data = lt_item_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* Add billing plan for first item
* ===================================================
    READ TABLE lt_item_data INTO DATA(ls_item_data) INDEX 1.
    IF sy-subrc <> 0.
      lv_statement = 'Success: Sales order has not an item!'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      EXIT.
    ENDIF.
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bplh
            iv_handle_parent = ls_item_data-handle
          IMPORTING
            es_entity_data   = ls_i_bplh_data.

        IF NOT ls_i_bplh_data IS INITIAL.
          DO 1 TIMES.
            CHECK NOT ls_i_bplh_data-head_assignment_ind IS INITIAL.

            CLEAR: ls_changed_field.
            lv_field = 'HEAD_ASSIGNMENT_IND'.
            INSERT lv_field INTO TABLE ls_changed_field-field.
            CLEAR: ls_i_bplh_data-head_assignment_ind.
            ls_changed_field-handle = ls_i_bplh_data-handle.

            CALL METHOD lo_access->set_entity
              EXPORTING
                iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bplh
                iv_handle_parent = ls_item_data-handle
                is_entity_data   = ls_i_bplh_data
                is_changed_field = ls_changed_field.
          ENDDO.
        ENDIF.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* add item billing plan items
* ===================================================
    LOOP AT billing_plan_data-fplt ASSIGNING FIELD-SYMBOL(<fplt_entry>).
      CLEAR: ls_changed_field, ls_i_bpli_data.

      lv_field = 'BILLING_DATE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_i_bpli_data-billing_date = sy-datum.

      lv_field = 'DATE_CATEGORY_CODE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_i_bpli_data-date_category_code = <fplt_entry>-fpttp.

      lv_field = 'DATE_DESCR_CODE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_i_bpli_data-date_descr_code = <fplt_entry>-tetxt.

      lv_field = 'BPLAN_RULE_CODE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_i_bpli_data-bplan_rule_code = <fplt_entry>-fareg.

      lv_field = 'AMOUNT'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_i_bpli_data-amount = <fplt_entry>-fakwr.

      lv_field = 'BILLING_BLOCK_CODE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_i_bpli_data-billing_block_code = <fplt_entry>-faksp.

      lv_field = 'PROP_BILLING_TYPE_CODE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_i_bpli_data-prop_billing_type_code = <fplt_entry>-fkarv.

      ls_changed_field-handle = cl_goal_util=>so_instance->create_guid( ).
      ls_i_bpli_data-handle = ls_changed_field-handle.

      APPEND ls_changed_field TO lt_changed_field.
      APPEND ls_i_bpli_data TO lt_i_bpli_data.
    ENDLOOP.

    TRY.
        CALL METHOD lo_access->set_entity_set
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bpli
            iv_handle_parent = ls_i_bplh_data-handle
            it_entity_data   = lt_i_bpli_data
            it_changed_field = lt_changed_field.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* Add billing plan for LUMF
* ===================================================
    CLEAR: ls_item_data, ls_i_bplh_data, lt_i_bpli_data[], lt_changed_field[].
    READ TABLE lt_item_data INTO DATA(ls_item_lumf) WITH KEY category_code = 'CBTP'.
    CHECK NOT ls_item_lumf IS INITIAL.
    READ TABLE lt_item_data INTO ls_item_data WITH KEY higher_level_item_id = ls_item_lumf-item_id.
    IF sy-subrc = 0.
      TRY.
          CALL METHOD lo_access->get_entity
            EXPORTING
              iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bplh
              iv_handle_parent = ls_item_data-handle
            IMPORTING
              es_entity_data   = ls_i_bplh_data.

          IF NOT ls_i_bplh_data IS INITIAL.
            DO 1 TIMES.
              CHECK NOT ls_i_bplh_data-head_assignment_ind IS INITIAL.

              CLEAR: ls_changed_field.
              lv_field = 'HEAD_ASSIGNMENT_IND'.
              INSERT lv_field INTO TABLE ls_changed_field-field.
              CLEAR: ls_i_bplh_data-head_assignment_ind.
              ls_changed_field-handle = ls_i_bplh_data-handle.

              CALL METHOD lo_access->set_entity
                EXPORTING
                  iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bplh
                  iv_handle_parent = ls_item_data-handle
                  is_entity_data   = ls_i_bplh_data
                  is_changed_field = ls_changed_field.
            ENDDO.
          ENDIF.
        CATCH cx_goal_exc INTO lx_goal_exc.
          lv_text_exc = lx_goal_exc->get_text( ).
          me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
          EXIT.
      ENDTRY.

      LOOP AT billing_plan_data-fplt ASSIGNING <fplt_entry>.
        CLEAR: ls_changed_field, ls_i_bpli_data.

        lv_field = 'BILLING_DATE'.
        INSERT lv_field INTO TABLE ls_changed_field-field.
        ls_i_bpli_data-billing_date = sy-datum.

        lv_field = 'DATE_CATEGORY_CODE'.
        INSERT lv_field INTO TABLE ls_changed_field-field.
        ls_i_bpli_data-date_category_code = <fplt_entry>-fpttp.

        lv_field = 'DATE_DESCR_CODE'.
        INSERT lv_field INTO TABLE ls_changed_field-field.
        ls_i_bpli_data-date_descr_code = <fplt_entry>-tetxt.

        lv_field = 'BPLAN_RULE_CODE'.
        INSERT lv_field INTO TABLE ls_changed_field-field.
        ls_i_bpli_data-bplan_rule_code = <fplt_entry>-fareg.

        lv_field = 'AMOUNT'.
        INSERT lv_field INTO TABLE ls_changed_field-field.
        ls_i_bpli_data-amount = <fplt_entry>-fakwr.

        lv_field = 'BILLING_BLOCK_CODE'.
        INSERT lv_field INTO TABLE ls_changed_field-field.
        ls_i_bpli_data-billing_block_code = <fplt_entry>-faksp.

        lv_field = 'PROP_BILLING_TYPE_CODE'.
        INSERT lv_field INTO TABLE ls_changed_field-field.
        ls_i_bpli_data-prop_billing_type_code = <fplt_entry>-fkarv.

        ls_changed_field-handle = cl_goal_util=>so_instance->create_guid( ).
        ls_i_bpli_data-handle = ls_changed_field-handle.

        APPEND ls_changed_field TO lt_changed_field.
        APPEND ls_i_bpli_data TO lt_i_bpli_data.
      ENDLOOP.

      TRY.
          CALL METHOD lo_access->set_entity_set
            EXPORTING
              iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bpli
              iv_handle_parent = ls_i_bplh_data-handle
              it_entity_data   = lt_i_bpli_data
              it_changed_field = lt_changed_field.
        CATCH cx_goal_exc INTO lx_goal_exc.
          lv_text_exc = lx_goal_exc->get_text( ).
          me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
          EXIT.
      ENDTRY.

    ENDIF.
* ===================================================
* Add billing plan for ERLA
* ===================================================
    CLEAR: ls_item_data, ls_i_bplh_data, lt_i_bpli_data[], lt_changed_field[].
    READ TABLE lt_item_data INTO ls_item_data WITH KEY category_code = 'CBTQ'.
    IF sy-subrc = 0.
      TRY.
          CALL METHOD lo_access->get_entity
            EXPORTING
              iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bplh
              iv_handle_parent = ls_item_data-handle
            IMPORTING
              es_entity_data   = ls_i_bplh_data.

          IF NOT ls_i_bplh_data IS INITIAL.
            DO 1 TIMES.
              CHECK NOT ls_i_bplh_data-head_assignment_ind IS INITIAL.

              CLEAR: ls_changed_field.
              lv_field = 'HEAD_ASSIGNMENT_IND'.
              INSERT lv_field INTO TABLE ls_changed_field-field.
              CLEAR: ls_i_bplh_data-head_assignment_ind.
              ls_changed_field-handle = ls_i_bplh_data-handle.

              CALL METHOD lo_access->set_entity
                EXPORTING
                  iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bplh
                  iv_handle_parent = ls_item_data-handle
                  is_entity_data   = ls_i_bplh_data
                  is_changed_field = ls_changed_field.
            ENDDO.
          ENDIF.
        CATCH cx_goal_exc INTO lx_goal_exc.
          lv_text_exc = lx_goal_exc->get_text( ).
          me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
          EXIT.
      ENDTRY.

      LOOP AT billing_plan_data-fplt ASSIGNING <fplt_entry>.
        CLEAR: ls_changed_field, ls_i_bpli_data.

        lv_field = 'BILLING_DATE'.
        INSERT lv_field INTO TABLE ls_changed_field-field.
        ls_i_bpli_data-billing_date = sy-datum.

        lv_field = 'DATE_CATEGORY_CODE'.
        INSERT lv_field INTO TABLE ls_changed_field-field.
        ls_i_bpli_data-date_category_code = <fplt_entry>-fpttp.

        lv_field = 'DATE_DESCR_CODE'.
        INSERT lv_field INTO TABLE ls_changed_field-field.
        ls_i_bpli_data-date_descr_code = <fplt_entry>-tetxt.

        lv_field = 'BPLAN_RULE_CODE'.
        INSERT lv_field INTO TABLE ls_changed_field-field.
        ls_i_bpli_data-bplan_rule_code = <fplt_entry>-fareg.

        lv_field = 'AMOUNT'.
        INSERT lv_field INTO TABLE ls_changed_field-field.
        ls_i_bpli_data-amount = <fplt_entry>-fakwr.

        lv_field = 'BILLING_BLOCK_CODE'.
        INSERT lv_field INTO TABLE ls_changed_field-field.
        ls_i_bpli_data-billing_block_code = <fplt_entry>-faksp.

        lv_field = 'PROP_BILLING_TYPE_CODE'.
        INSERT lv_field INTO TABLE ls_changed_field-field.
        ls_i_bpli_data-prop_billing_type_code = <fplt_entry>-fkarv.

        ls_changed_field-handle = cl_goal_util=>so_instance->create_guid( ).
        ls_i_bpli_data-handle = ls_changed_field-handle.

        APPEND ls_changed_field TO lt_changed_field.
        APPEND ls_i_bpli_data TO lt_i_bpli_data.
      ENDLOOP.

      TRY.
          CALL METHOD lo_access->set_entity_set
            EXPORTING
              iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bpli
              iv_handle_parent = ls_i_bplh_data-handle
              it_entity_data   = lt_i_bpli_data
              it_changed_field = lt_changed_field.
        CATCH cx_goal_exc INTO lx_goal_exc.
          lv_text_exc = lx_goal_exc->get_text( ).
          me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
          EXIT.
      ENDTRY.

    ENDIF.
* 3 Step: Save
    lo_access->save( ).
    lo_access->get_messages( IMPORTING et_message = DATA(lt_message)
                                       es_error   = ls_error ).
    IF NOT ls_error IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = ls_error-msgtx ).
      lo_access->close( ).
      EXIT.
    ELSE.
      lo_access->close( ).
    ENDIF.

    lv_statement = 'Success: Add item level billing plan dates done!'.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ev_execution_status = abap_true.
  ENDMETHOD.


  METHOD call_order_request_in.

    DATA: ls_testdata    TYPE string,
          lv_xml_xstring TYPE xstring,
          lv_log_message TYPE string,
          lv_vbeln       TYPE vbeln.

    DATA: ls_curr_line  TYPE edi_sales_order_message,
          ls_data       TYPE edi_sales_order_message,
          lt_old_msg    TYPE /aif/bal_t_msg,
          lt_return_msg TYPE bapiret2_t,
          lv_succ       TYPE /aif/successflag.

*--> 1 Step: Get data from tdc
    DATA(ls_current_step) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_current_step
      IMPORTING
        es_testdata  = ls_testdata ).

    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
      EXPORTING
        text   = ls_testdata
      IMPORTING
        buffer = lv_xml_xstring
      EXCEPTIONS
        failed = 1
        OTHERS = 2.

    "transform xstring to abap structuer
    DATA(lo_sxml_reader) = cl_sxml_string_reader=>create( input = lv_xml_xstring ).
    TRY.
        cl_proxy_xml_transform=>xml_to_abap( EXPORTING ddic_type  = 'EDI_SALES_ORDER_MESSAGE'
                                                       xml_reader = lo_sxml_reader
                                             IMPORTING abap_data  = ls_data ).
      CATCH cx_proxy_fault INTO DATA(lx_fault).
    ENDTRY.

    "Add timestamp as purchase order ID to create multiple times for variant "OR_INBOUND_ARIBA"
    IF ls_current_step-variant = 'OR_INBOUND_ARIBA'.
      GET TIME STAMP FIELD DATA(ts).
      ls_data-order-purchase_order_id = ts.
      SHIFT ls_data-order-purchase_order_id LEFT DELETING LEADING space.
    ENDIF.

*--> 2 Step: Call inbound processing
    TRY.
        NEW cl_edi_sd_ordr_processing( )->process(
          CHANGING
            data         = ls_data
            curr_line    = ls_curr_line
            success      = lv_succ
            old_messages = lt_old_msg
            return_tab   = lt_return_msg
        ).
      CATCH BEFORE UNWIND cx_edi_sd_exc INTO DATA(lx_edi_exc).
        APPEND LINES OF lx_edi_exc->convert_chain_to_bapiret2_t( ) TO lt_return_msg.
    ENDTRY.

*--> 3 Step:  Copy messages to et_return
    LOOP AT lt_return_msg ASSIGNING FIELD-SYMBOL(<ls_return_msg>).
      IF <ls_return_msg>-message IS INITIAL     AND
         <ls_return_msg>-id      IS NOT INITIAL AND
         <ls_return_msg>-number  IS NOT INITIAL.
        DATA(lo_message) = NEW cl_t100_message( the_msg_class  = <ls_return_msg>-id
                                                the_msg_number = <ls_return_msg>-number ).

        DATA(lt_msgv) = VALUE name2value_table(
         ( name = cl_t100_message=>msgv1_name value = <ls_return_msg>-message_v1 )
         ( name = cl_t100_message=>msgv2_name value = <ls_return_msg>-message_v2 )
         ( name = cl_t100_message=>msgv3_name value = <ls_return_msg>-message_v3 )
         ( name = cl_t100_message=>msgv4_name value = <ls_return_msg>-message_v4 ) ).

        lo_message->set_substitution_table( lt_msgv ) .
        lv_log_message = lo_message->if_message~get_text( ).
      ELSE.
        IF <ls_return_msg>-message IS NOT INITIAL.
          lv_log_message = <ls_return_msg>-message .
        ENDIF.
      ENDIF.
      lv_log_message = |EDI: { lv_log_message }|.
      me->mo_run_environment->append_log( iv_log_statement = lv_log_message ).
    ENDLOOP.

*--> 4 Step: Check result and set success flag
    IF line_exists( lt_return_msg[ type = 'E' ]  ).
      ev_execution_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |SEF: The Order Request Processing failed. | ).
    ELSE.
      READ TABLE lt_return_msg INTO DATA(ls_return_msg) WITH KEY type   = 'S'
                                                                 id     = 'V1'
                                                                 number = 311.
      IF sy-subrc = 0.
        lv_vbeln = ls_return_msg-message_v2.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_vbeln
          IMPORTING
            output = lv_vbeln.
        APPEND lv_vbeln TO ev_document_id.
      ENDIF.
      ev_execution_status = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |SEF: The Order Request { lv_vbeln } Processing successful. | ).
    ENDIF.

  ENDMETHOD.


  METHOD change.
    DATA: ls_chance_tdc TYPE ty_gs_i_ptf_or_ch_td,
          bool_rembb    TYPE abap_bool,
          lt_return     TYPE cl_ptf_util=>gt_ptf_return_tab,
          lv_ptf_tdc    TYPE etobj_name,
          ls_return     TYPE bapiret2.

*****************************************************************************
* First Step: get tdcv

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_chance_tdc
    ).

*****************************************************************************
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<prestep_numbr>).
      DATA(ls_step_precessor) = me->mo_run_environment->get_step_data( iv_step_number = <prestep_numbr> ).
      MOVE ls_step_precessor-document_id TO ev_document_id.
      LOOP AT ev_document_id  ASSIGNING FIELD-SYMBOL(<vbeln>).
*****************************************************************************
* Check if the billing block has to removed.
        DATA: lv_ptf_key TYPE ptfkey.
        MOVE <vbeln>-vbeln TO lv_ptf_key.

        IF ls_chance_tdc-billing_block = '00'.

          me->remove_billing_block( iv_order_number = lv_ptf_key ).

          ev_execution_status = abap_false.
          cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

        ELSEIF ls_chance_tdc-billing_block IS NOT INITIAL.
          me->add_billing_block(
            EXPORTING
              iv_order_number = lv_ptf_key
              iv_chance_tdc   = ls_chance_tdc
            RECEIVING
              ev_test_success = ev_execution_status
          ).

          cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
        ENDIF.
*****************************************************************************
* check if and where the item list hat to change

        LOOP AT ls_chance_tdc-item_list ASSIGNING FIELD-SYMBOL(<ls_item_list>).
          IF <ls_item_list>-material_id IS NOT INITIAL
          OR <ls_item_list>-posnr IS NOT INITIAL
          OR <ls_item_list>-quantity IS NOT INITIAL.
            DATA(b_change_itemlist) = abap_true.
            EXIT.
          ENDIF.
        ENDLOOP.

        IF b_change_itemlist = abap_true.

          CLEAR lv_ptf_key.
          MOVE <vbeln>-vbeln TO lv_ptf_key.
          me->change_item_list(
            EXPORTING
              iv_order_number = lv_ptf_key
              iv_chance_tdc   = ls_chance_tdc
            IMPORTING
              ev_test_success = ev_execution_status
              et_return       = lt_return
          ).
          cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

        ENDIF.

      ENDLOOP.
*****************************************************************************
    ENDLOOP.

  ENDMETHOD.


  METHOD change_ic_so2.
    DATA:
      ls_chance_tdc       TYPE ty_gs_i_ptf_or_ch_td,
      lo_goal_access      TYPE REF TO if_goal_access,
      ls_load_parameter   TYPE tds_goal_so_load,
      lv_vbeln            TYPE vbeln_va,
      ls_control_settings TYPE if_goal_access=>tcs_control_settings,
      lt_so_item          TYPE STANDARD TABLE OF tds_goal_so_item,
      ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
      lv_quantity(10)     TYPE c,
      lv_statement        TYPE bapi_msg,
      lv_error_occured    TYPE abap_bool
      .

* initialize variables and output parameters
    lv_error_occured = abap_false.
    ev_check_status = abap_false.
    ev_execution_status = abap_false.

* First Step: get tdcv
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_chance_tdc
    ).

    ls_control_settings = VALUE #( no_conversion       = abap_true
                                   no_status_buff_init = abap_true ).
    ls_load_parameter = VALUE #(  ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<prestep_numbr>).
      DATA(ls_step_precessor) = me->mo_run_environment->get_step_data( iv_step_number = <prestep_numbr> ).
      MOVE ls_step_precessor-document_id TO ev_document_id.

      LOOP AT ev_document_id  ASSIGNING FIELD-SYMBOL(<vbeln>).

        lv_vbeln = <vbeln>.

* write into log
        lv_statement = 'SO2 Order: VBELN &1'.
        REPLACE '&1' IN lv_statement WITH lv_vbeln.
        me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

        lo_goal_access = cl_goal_api=>so_instance->open(
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_vbeln && ''
            iv_read_only        = abap_false
            is_load_parameter   = ls_load_parameter
            is_control_settings = ls_control_settings
        ).

        lo_goal_access->get_entity_set(
          EXPORTING
            iv_entity_id   = if_goal_sdoc_item=>co_entity_id
          IMPORTING
            et_entity_data = lt_so_item ).

        LOOP AT lt_so_item ASSIGNING FIELD-SYMBOL(<ls_so_item>).
          CLEAR ls_changed_field.
          ls_changed_field-handle = <ls_so_item>-handle.

          IF line_exists( ls_chance_tdc-item_list[ posnr = <ls_so_item>-item_id ] ).
            DATA(ls_input_item) = ls_chance_tdc-item_list[ posnr = <ls_so_item>-item_id ].
            IF ls_input_item-quantity IS NOT INITIAL.
              <ls_so_item>-order_qty = ls_input_item-quantity.
              INSERT CONV #( 'order_qty' ) INTO TABLE ls_changed_field-field.
* write into log
              lv_statement = 'Change Quantity: POSNR &1 , QUANTITY &2'.
              REPLACE '&1' IN lv_statement WITH <ls_so_item>-item_id.
              lv_quantity = <ls_so_item>-order_qty.
              REPLACE '&2' IN lv_statement WITH lv_quantity.
              me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
            ENDIF.

            lo_goal_access->set_entity(
              EXPORTING
                iv_entity_id     = if_goal_sdoc_item=>co_entity_id
                is_entity_data   = <ls_so_item>
                is_changed_field = ls_changed_field
            ).
          ENDIF.

        ENDLOOP.  " AT lt_so_item

        lo_goal_access->save( ).

        lo_goal_access->get_messages(
          IMPORTING
            et_message = DATA(lt_messages)
            es_error   = DATA(ls_error) ).
* output messages
        LOOP AT lt_messages ASSIGNING FIELD-SYMBOL(<ls_message>).
          CONCATENATE <ls_message>-msgty ':' <ls_message>-msgtx INTO lv_statement SEPARATED BY space.
          me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
        ENDLOOP.  " AT lt_messages
* output error
        IF NOT ls_error IS INITIAL.
          lv_error_occured = abap_true.
          CONCATENATE 'ERROR: ' ls_error-msgtx INTO lv_statement SEPARATED BY space.
          me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
        ENDIF.

      ENDLOOP.  " AT ev_document_id

    ENDLOOP.  " AT ls_step_data-reference_step

    ev_execution_status = abap_true.
    IF lv_error_occured EQ abap_true.
      ev_check_status = abap_false.
    ELSE.
      ev_check_status = abap_true.
* write into log
      lv_statement = 'Success: The SO2 order has been changed.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ENDIF.


  ENDMETHOD.


  METHOD change_item_list.
    DATA: ls_order_item_inx TYPE bapisditmx,
          lt_order_item_inx TYPE TABLE OF bapisditmx,
          ls_header_inx     TYPE bapisdh1x,
          ls_header_in      TYPE bapisdh1,
          ls_order_items    TYPE bapisditm,
          ls_schd_lines     TYPE bapischdl,
          ls_schd_lines_inx TYPE bapischdlx,
          lt_order_items    TYPE TABLE OF bapisditm,
          lt_schd_lines     TYPE TABLE OF bapischdl,
          lt_schd_lines_inx TYPE TABLE OF bapischdlx,
          lt_return	        TYPE cl_ptf_util=>gt_ptf_return_tab,
          ls_return         TYPE  bapiret2.


    CLEAR lt_order_items.
    ls_header_inx-updateflag  = 'U'.

* Check where the changes have to be made.
    LOOP AT iv_chance_tdc-item_list ASSIGNING FIELD-SYMBOL(<ls_item_list>).
      IF <ls_item_list>-posnr IS NOT INITIAL.
        ls_order_items-itm_number    = <ls_item_list>-posnr.
        ls_order_item_inx-itm_number = <ls_item_list>-posnr.
        ls_schd_lines-itm_number = <ls_item_list>-posnr.
        ls_schd_lines_inx-itm_number = <ls_item_list>-posnr.
      ENDIF.

      IF <ls_item_list>-material_id IS NOT INITIAL.
        ls_order_items-material      = <ls_item_list>-material_id.
        ls_order_item_inx-material   = 'X'.
        ls_order_item_inx-updateflag = 'U'.
      ENDIF.

      IF <ls_item_list>-quantity IS NOT INITIAL.
        ls_order_items-target_qty    = <ls_item_list>-quantity.
        ls_order_item_inx-target_qty = 'X'.
        ls_order_item_inx-updateflag = 'U'.
      ENDIF.

       IF <ls_item_list>-batch IS NOT INITIAL.
        ls_order_items-batch    = <ls_item_list>-batch .
        ls_order_item_inx-batch  = 'X'.
        ls_order_item_inx-updateflag = 'U'.
      ENDIF.

      IF <ls_item_list>-werks IS NOT INITIAL.
        ls_order_items-plant         = <ls_item_list>-werks.
        ls_order_item_inx-plant      = 'X'.
        ls_order_item_inx-updateflag = 'U'.
      ENDIF.

      IF <ls_item_list>-fkk_conacct IS NOT INITIAL.
        ls_order_items-fkk_conacct    = <ls_item_list>-fkk_conacct.
        ls_order_item_inx-fkk_conacct = 'X'.
        ls_order_item_inx-updateflag  = 'U'.
      ENDIF.

      IF <ls_item_list>-unddlv_tol IS NOT INITIAL.
        ls_order_items-unddlv_tol    = <ls_item_list>-unddlv_tol.
        ls_order_item_inx-unddlv_tol = 'X'.
        ls_order_item_inx-updateflag = 'U'.
      ENDIF.

      IF <ls_item_list>-item_category  IS NOT INITIAL.
        ls_order_items-item_categ     = <ls_item_list>-item_category .
        ls_order_item_inx-item_categ  = 'X'.
        ls_order_item_inx-updateflag = 'U'.
      ENDIF.

      APPEND ls_order_items TO lt_order_items.
      APPEND ls_order_item_inx TO lt_order_item_inx.

    ENDLOOP.

    LOOP AT iv_chance_tdc-schedule_lines ASSIGNING FIELD-SYMBOL(<ls_sched_lines>).

      IF <ls_sched_lines>-posnr IS NOT INITIAL.
        ls_schd_lines-itm_number     = <ls_sched_lines>-posnr.
        ls_schd_lines_inx-itm_number = <ls_sched_lines>-posnr.
      ENDIF.

      IF <ls_sched_lines>-etenr  IS NOT INITIAL.
        ls_schd_lines-sched_line = <ls_sched_lines>-etenr.
        ls_schd_lines_inx-sched_line  = <ls_sched_lines>-etenr.
        ls_schd_lines_inx-updateflag = 'U'.
      ENDIF.

      IF <ls_sched_lines>-edatu  IS NOT INITIAL.
        ls_schd_lines-req_date = <ls_sched_lines>-edatu.
        ls_schd_lines_inx-req_date  = 'X'.
        ls_schd_lines_inx-updateflag = 'U'.
      ENDIF.

      APPEND ls_schd_lines TO lt_schd_lines.
      APPEND ls_schd_lines_inx TO lt_schd_lines_inx.

    ENDLOOP.
*    IF sy-subrc = 0.
*      ls_order_item_inx-material = 'X'.   "Updateflag
*      ls_order_item_inx-updateflag = 'U'.
*    ENDIF.
*    APPEND ls_order_item_inx TO lt_order_item_inx.
    CLEAR et_return.
* execute the chnages
    DATA: lv_vbeln TYPE vbeln.
    MOVE iv_order_number TO lv_vbeln.

    CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
      EXPORTING
        salesdocument    = lv_vbeln   " Order Number
        order_header_in  = ls_header_in
        order_header_inx = ls_header_inx  " Sales Order Check List
      TABLES
        return           = et_return " Return Code
        order_item_in    = lt_order_items  " Order Items
        order_item_inx   = lt_order_item_inx  " Sales Order Items Check Table
        schedule_lines   = lt_schd_lines      "Schedule lines
        schedule_linesx  = lt_schd_lines_inx.  "Schedule lines check table

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

* check if the process ended without errors.
    LOOP AT et_return ASSIGNING FIELD-SYMBOL(<ls_return>).
      IF <ls_return>-type = 'S'.  " S for Success
        ev_test_success = abap_true.
      ELSE.
        ev_test_success = abap_false.
        RETURN.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD check.

    DATA: ls_testdata      TYPE ty_gs_ptf_sd_check_td_ext,
          lt_vbeln         TYPE cl_ptf_util=>ty_vbeln_tab,
          ls_ref_step_data TYPE cl_ptf_util=>gt_ptf_step,
          lv_vbeln         TYPE vbeln,
          lv_check_success TYPE abap_bool.

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

*   Check if reference step number for object to be checked is filled and reference object exists
    IF ls_step_data-reference_step IS INITIAL  OR  ls_step_data-reference_step[ 1 ] IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No reference step maintained. Check the script.| ).
      RETURN.
    ENDIF.
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.
    IF lt_vbeln IS INITIAL.
      me->mo_run_environment->append_log( 'There are no documentIDs to check!' ).
      RETURN.
    ENDIF.

    IF ls_step_data-variant IS INITIAL. "TDC Variant is mandatory for OR-CHECK
      me->mo_run_environment->append_log( 'Doing nothing, as there is no TDC Variant with check data. Check the script.' ).
      RETURN.
    ENDIF.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

    lv_check_success = abap_true.
    CLEAR ls_ref_step_data.
    IF ls_testdata-vbak_check IS INITIAL AND ls_testdata-vbap_check IS INITIAL AND ls_testdata-vbep_check IS INITIAL.
      me->mo_run_environment->append_log( 'No checks defined in TDC variant { ls_step_data-variant }. Doing nothing.' ).
      RETURN.
    ENDIF.

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_prestepnumber>).
      ls_ref_step_data = me->mo_run_environment->get_step_data( iv_step_number = <lv_prestepnumber> ).
      IF ls_ref_step_data-document_id IS INITIAL.
*        lv_step_success = abap_false.
        me->mo_run_environment->append_log( iv_log_statement = |No reference document exists at step { <lv_prestepnumber> } !| ).
      ELSE.

        IF ls_testdata-vbak_check IS NOT INITIAL.
          cl_ptf_compare_sd_tdc=>compare_vbak_data(
            EXPORTING
              is_testdata        = ls_testdata-vbak_vbap_data
              is_check_step_data = ls_ref_step_data
              iv_run_environment = me->mo_run_environment
            RECEIVING
              rv_is_equal        = ev_check_status
          ).
          IF ev_check_status EQ abap_false.
            lv_check_success = abap_false.
          ENDIF.
        ENDIF.

        IF ls_testdata-vbap_check IS NOT INITIAL.
          cl_ptf_compare_sd_tdc=>compare_vbap_data(
            EXPORTING
              is_testdata        = ls_testdata-vbak_vbap_data
              is_check_step_data = ls_ref_step_data
              iv_run_environment = me->mo_run_environment
            RECEIVING
              rv_is_equal        = ev_check_status
          ).
          IF ev_check_status EQ abap_false.
            lv_check_success = abap_false.
          ENDIF.
        ENDIF.

*         check schedule lines
        IF NOT ls_testdata-vbep_check IS INITIAL.
          cl_ptf_compare_sd_tdc=>compare_vbep_data(
            EXPORTING
              is_testdata        = ls_testdata
              is_check_step_data = ls_ref_step_data
              iv_run_environment = me->mo_run_environment
            RECEIVING
              rv_is_equal        = ev_check_status
          ).
          IF ev_check_status EQ abap_false.
            lv_check_success = abap_false.
          ENDIF.
        ENDIF.  " IF NOT ls_testdata-vbep_check IS INITIAL

      ENDIF.
    ENDLOOP.


    ev_check_status = lv_check_success.
    ev_execution_status = abap_true.

    IF ev_check_status EQ abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |The values of the checked document(s) are correct.| ).
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |The values of the checked document(s) are NOT correct.| ).
    ENDIF.

  ENDMETHOD.


  METHOD check_ana_fields.
    DATA: documents TYPE TABLE OF vbeln.


    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(created_documents) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      APPEND LINES OF created_documents TO documents.
    ENDLOOP.

    ev_check_status = abap_true.

    LOOP AT documents ASSIGNING FIELD-SYMBOL(<doc_to_check>).

      SELECT SINGLE * FROM vbak WHERE vbeln = @<doc_to_check> INTO @DATA(header_data).
      SELECT * FROM vbkd WHERE vbeln = @<doc_to_check> INTO TABLE @DATA(vbkd_data).
      SELECT * FROM vbpa WHERE vbeln = @<doc_to_check> INTO TABLE @DATA(vbpa_data).

      READ TABLE vbpa_data WITH KEY parvw = 'WE' INTO DATA(we_partner).
      READ TABLE vbpa_data WITH KEY parvw = 'RE' INTO DATA(re_partner).
      READ TABLE vbpa_data WITH KEY parvw = 'VE' INTO DATA(ve_partner).
      READ TABLE vbpa_data WITH KEY parvw = 'ZM' INTO DATA(zm_partner).
      READ TABLE vbpa_data WITH KEY parvw = 'RG' INTO DATA(rg_partner).


      SELECT vbeln, posnr, vbkd_posnr, vbtyp_ana, auart_ana, vkorg_ana, vtweg_ana, spart_ana, vkbur_ana, vkgrp_ana, augru_ana, audat_ana, kvgr1_ana,
             kvgr2_ana, kvgr3_ana, kvgr4_ana, kvgr5_ana, vdatu_ana, vsbed_ana, kunnr_ana, knumv_ana, bzirk_ana, bstkd_ana,
             kdgrp_ana, vsart_ana, fkdat_ana, fplnr_ana, kunwe_ana, kunre_ana, perve_ana, perzm_ana, kunrg_ana
        FROM vbap WHERE vbeln = @<doc_to_check> INTO TABLE @DATA(item_data).


      LOOP AT item_data ASSIGNING FIELD-SYMBOL(<item_to_check>).
***  check fields coming from vbak
        IF <item_to_check>-vbtyp_ana NE header_data-vbtyp.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |vbtyp differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
        ENDIF.

        IF <item_to_check>-auart_ana NE header_data-auart.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |auart differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
        ENDIF.

        IF <item_to_check>-vkorg_ana NE header_data-vkorg.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |vkorg differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
        ENDIF.

        IF <item_to_check>-vtweg_ana NE header_data-vtweg.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |vtweg differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
        ENDIF.

        IF <item_to_check>-spart_ana NE header_data-spart.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |spart differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
        ENDIF.

        IF <item_to_check>-vkbur_ana NE header_data-vkbur.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |vkbur differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
        ENDIF.

        IF <item_to_check>-vkgrp_ana NE header_data-vkgrp.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |vkgrb differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
        ENDIF.

        IF <item_to_check>-augru_ana NE header_data-augru.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |augru differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
        ENDIF.

        IF <item_to_check>-audat_ana NE header_data-audat.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |audat differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
        ENDIF.

        IF <item_to_check>-kvgr1_ana NE header_data-kvgr1.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |kvgr1 differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
        ENDIF.

        IF <item_to_check>-kvgr2_ana NE header_data-kvgr2.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |kvgr2 differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
        ENDIF.

        IF <item_to_check>-kvgr3_ana NE header_data-kvgr3.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |kvgr3 differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
        ENDIF.

        IF <item_to_check>-kvgr4_ana NE header_data-kvgr4.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |kvgr4 differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
        ENDIF.

        IF <item_to_check>-kvgr5_ana NE header_data-kvgr5.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |kvgr5 differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
        ENDIF.

        IF <item_to_check>-vdatu_ana NE header_data-vdatu.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |vdatu differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
        ENDIF.

        IF <item_to_check>-vsbed_ana NE header_data-vsbed.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |vsbed differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
        ENDIF.

        IF <item_to_check>-kunnr_ana NE header_data-kunnr.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |kunnr differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
        ENDIF.

        IF <item_to_check>-knumv_ana NE header_data-knumv.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |knumv differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
        ENDIF.
***  check fields coming from vbpa
*        loop at vbpa_data assigning field-symbol(<vbpa_data>) where vbeln = <item_to_check>-vbeln.
        IF <item_to_check>-kunwe_ana NE we_partner-kunnr.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |kunnr differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
        ENDIF.

        IF <item_to_check>-kunre_ana NE re_partner-kunnr.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |KUNNR differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
        ENDIF.

        IF <item_to_check>-perve_ana NE ve_partner-pernr.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |PERNR differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
        ENDIF.

        IF <item_to_check>-perzm_ana NE zm_partner-pernr.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |PERNR differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
        ENDIF.

        IF <item_to_check>-kunrg_ana NE rg_partner-kunnr.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |KUNNR differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
        ENDIF.

*        endloop.

***  check fields coming from vbkd
        LOOP AT vbkd_data ASSIGNING FIELD-SYMBOL(<vbkd_data>) WHERE vbeln = <item_to_check>-vbeln AND
                                                                    posnr = <item_to_check>-vbkd_posnr.
          IF <item_to_check>-bzirk_ana NE <vbkd_data>-bzirk.
            ev_check_status = abap_false.
            me->mo_run_environment->append_log( iv_log_statement = |bzirk differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
          ENDIF.

          IF <item_to_check>-bstkd_ana NE <vbkd_data>-bstkd.
            ev_check_status = abap_false.
            me->mo_run_environment->append_log( iv_log_statement = |bstkd differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
          ENDIF.

          IF <item_to_check>-kdgrp_ana NE <vbkd_data>-kdgrp.
            ev_check_status = abap_false.
            me->mo_run_environment->append_log( iv_log_statement = |kdgrp differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
          ENDIF.

          IF <item_to_check>-vsart_ana NE <vbkd_data>-vsart.
            ev_check_status = abap_false.
            me->mo_run_environment->append_log( iv_log_statement = |vsart differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
          ENDIF.

          IF <item_to_check>-fkdat_ana NE <vbkd_data>-fkdat.
            ev_check_status = abap_false.
            me->mo_run_environment->append_log( iv_log_statement = |fkdat differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
          ENDIF.

          IF <item_to_check>-fplnr_ana NE <vbkd_data>-fplnr.
            ev_check_status = abap_false.
            me->mo_run_environment->append_log( iv_log_statement = |fplnr differs for doc { <item_to_check>-vbeln } pos { <item_to_check>-posnr }| ).
          ENDIF.

        ENDLOOP.


      ENDLOOP.

    ENDLOOP.

    ev_execution_status = abap_true.

  ENDMETHOD.


  METHOD check_bpl_copied.
    DATA: lt_doc_ids TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings,
          lo_access           TYPE REF TO if_goal_access,
          ls_error            TYPE if_goal_types=>tcs_error,
          lx_goal_exc         TYPE REF TO cx_goal_exc,
          lv_text_exc         TYPE string,
          lv_field            TYPE fieldname,
          ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
          lt_changed_field    TYPE if_goal_types=>tct_changed_field.

    DATA: lv_bo_key      TYPE if_goal_types=>tcd_bo_key,
          lt_item_data   TYPE STANDARD TABLE OF tds_goal_so_item,
          ls_head_data   TYPE tds_goal_so_head,
          ls_i_bplh_data TYPE tds_goal_sdoc_bplh,
          ls_i_bpli_data TYPE tds_goal_sdoc_bpli,
          lt_i_bpli_data TYPE STANDARD TABLE OF tds_goal_sdoc_bpli,
          lv_statement   TYPE bapi_msg.

    ev_check_status = abap_false.

* 1 Step: get previously step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_doc_ids.
    ENDLOOP.

    READ TABLE lt_doc_ids INTO DATA(ls_doc_id) INDEX 1.
    IF sy-subrc = 0.
      lv_bo_key = ls_doc_id-vbeln.
    ENDIF.

    CHECK NOT lv_bo_key IS INITIAL.

* 2 Step: Access sales order via GOAL
* ===================================================
* open the document in change mode
* ===================================================
    TRY.
        CALL METHOD cl_goal_api=>so_instance->open
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_bo_key
            iv_read_only        = abap_true
            is_control_settings = ls_control_settings
          RECEIVING
            ro_access           = lo_access.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read header data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id   = if_goal_sdoc_head=>co_entity_id
          IMPORTING
            es_entity_data = ls_head_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read item data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id   = if_goal_sdoc_item=>co_entity_id
          IMPORTING
            et_entity_data = lt_item_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read item billing plan header
* ===================================================
    READ TABLE lt_item_data INTO DATA(ls_item_data) INDEX 1.
    CHECK sy-subrc = 0.
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bplh
            iv_handle_parent = ls_item_data-handle
          IMPORTING
            es_entity_data   = ls_i_bplh_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* get item billing plan items
* ===================================================
    CHECK NOT ls_i_bplh_data IS INITIAL.

    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bpli
            iv_handle_parent = ls_i_bplh_data-handle
          IMPORTING
            et_entity_data   = lt_i_bpli_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.

    lo_access->get_messages( IMPORTING et_message = DATA(lt_message)
                                       es_error   = ls_error ).
    IF NOT ls_error IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = ls_error-msgtx ).
      lo_access->close( ).
      EXIT.
    ELSE.
      lo_access->close( ).
    ENDIF.

    " Check item billing plan
    IF lines( lt_i_bpli_data[] ) > 0.
      EXIT.
    ENDIF.

    lv_statement = 'Success: Copy billing plan to item level successfully!'.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ev_check_status = abap_true.
  ENDMETHOD.


  METHOD check_delivery_block_bom.
    DATA: lt_doc_ids TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings,
          lo_access           TYPE REF TO if_goal_access,
          ls_error            TYPE if_goal_types=>tcs_error,
          lx_goal_exc         TYPE REF TO cx_goal_exc,
          lv_text_exc         TYPE string,
          lv_field            TYPE fieldname,
          ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
          lt_changed_field    TYPE if_goal_types=>tct_changed_field,
          lv_statement        TYPE bapi_msg.

    DATA: lv_bo_key         TYPE if_goal_types=>tcd_bo_key,
          lt_item_data      TYPE STANDARD TABLE OF tds_goal_so_item,
          ls_head_data      TYPE tds_goal_so_head,
          ls_sline_data     TYPE tds_goal_so_sline,
          lt_sline_data     TYPE STANDARD TABLE OF tds_goal_so_sline,
          billing_plan_data TYPE ty_billing_plan,
          lt_fplt           TYPE fpltvb_t.

    DATA: lv_error TYPE abap_bool VALUE abap_false,
          lv_lifsp TYPE lifsp.

    ev_check_status = abap_false.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = billing_plan_data ).

    lt_fplt = billing_plan_data-fplt[].
    SORT lt_fplt BY fkdat fksaf DESCENDING teman korte fplnr fpltr.
    LOOP AT lt_fplt ASSIGNING FIELD-SYMBOL(<fplt>).
      SELECT SINGLE lifsp INTO @lv_lifsp FROM tfplt WHERE fpart = '90' AND fpttp = @<fplt>-fpttp.
      IF NOT lv_lifsp IS INITIAL.
        EXIT.
      ENDIF.
    ENDLOOP.

* 1 Step: get previously step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_doc_ids.
    ENDLOOP.

    READ TABLE lt_doc_ids INTO DATA(ls_doc_id) INDEX 1.
    IF sy-subrc = 0.
      lv_bo_key = ls_doc_id-vbeln.
    ENDIF.

    CHECK NOT lv_bo_key IS INITIAL.

* 2 Step: Access sales order via GOAL
* ===================================================
* open the document in change mode
* ===================================================
    TRY.
        CALL METHOD cl_goal_api=>so_instance->open
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_bo_key
            iv_read_only        = abap_true
            is_control_settings = ls_control_settings
          RECEIVING
            ro_access           = lo_access.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read header data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id   = if_goal_sdoc_head=>co_entity_id
          IMPORTING
            es_entity_data = ls_head_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* read item data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id   = if_goal_sdoc_item=>co_entity_id
          IMPORTING
            et_entity_data = lt_item_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* read schedule line
* ===================================================
    LOOP AT lt_item_data INTO DATA(ls_item_data).
      CLEAR: lt_sline_data.

      TRY.
          CALL METHOD lo_access->get_entity_set
            EXPORTING
              iv_entity_id     = if_goal_sdoc_sline=>co_entity_id
              iv_handle_parent = ls_item_data-handle
            IMPORTING
              et_entity_data   = lt_sline_data.
        CATCH cx_goal_exc INTO lx_goal_exc.
          lv_text_exc = lx_goal_exc->get_text( ).
          me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
          EXIT.
      ENDTRY.

      "check delivery block code for down payment
      LOOP AT lt_sline_data INTO ls_sline_data.
        IF ls_sline_data-delivery_block_code <> lv_lifsp.
          lv_statement = 'Error:Delivery block determination failed!'.
          me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
          lv_error = abap_true.
          EXIT.
        ENDIF.
        IF ls_sline_data-delivery_block_code = ''.
          lv_statement = 'Error:Delivery block determination failed!'.
          me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
          lv_error = abap_true.
          EXIT.
        ENDIF.
      ENDLOOP.

      IF lv_error = abap_true.
        EXIT.
      ENDIF.
    ENDLOOP.

    lo_access->get_messages( IMPORTING et_message = DATA(lt_message)
                                       es_error   = ls_error ).
    IF NOT ls_error IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = ls_error-msgtx ).
      lo_access->close( ).
      EXIT.
    ELSE.
      lo_access->close( ).
    ENDIF.

    CHECK lv_error = abap_false.

    lv_statement = 'Success: Delivery block determined successfully!'.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ev_check_status = abap_true.
  ENDMETHOD.


  METHOD check_delivery_block_sline.
    DATA: lt_doc_ids TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings,
          lo_access           TYPE REF TO if_goal_access,
          ls_error            TYPE if_goal_types=>tcs_error,
          lx_goal_exc         TYPE REF TO cx_goal_exc,
          lv_text_exc         TYPE string,
          lv_field            TYPE fieldname,
          ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
          lt_changed_field    TYPE if_goal_types=>tct_changed_field,
          lv_statement        TYPE bapi_msg.

    DATA: lv_bo_key         TYPE if_goal_types=>tcd_bo_key,
          lt_item_data      TYPE STANDARD TABLE OF tds_goal_so_item,
          ls_head_data      TYPE tds_goal_so_head,
          ls_sline_data     TYPE tds_goal_so_sline,
          lt_sline_data     TYPE STANDARD TABLE OF tds_goal_so_sline,
          billing_plan_data TYPE ty_billing_plan,
          lt_fplt           TYPE fpltvb_t.

    DATA: lv_error TYPE abap_bool VALUE abap_false,
          lv_lifsp TYPE lifsp.

    ev_check_status = abap_false.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = billing_plan_data ).

    lt_fplt = billing_plan_data-fplt[].
    SORT lt_fplt BY fkdat fksaf DESCENDING teman korte fplnr fpltr.
    LOOP AT lt_fplt ASSIGNING FIELD-SYMBOL(<fplt>).
      SELECT SINGLE lifsp INTO @lv_lifsp FROM tfplt WHERE fpart = '90' AND fpttp = @<fplt>-fpttp.
      IF NOT lv_lifsp IS INITIAL.
        EXIT.
      ENDIF.
    ENDLOOP.

* 1 Step: get previously step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_doc_ids.
    ENDLOOP.

    READ TABLE lt_doc_ids INTO DATA(ls_doc_id) INDEX 1.
    IF sy-subrc = 0.
      lv_bo_key = ls_doc_id-vbeln.
    ENDIF.

    CHECK NOT lv_bo_key IS INITIAL.

* 2 Step: Access sales order via GOAL
* ===================================================
* open the document in change mode
* ===================================================
    TRY.
        CALL METHOD cl_goal_api=>so_instance->open
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_bo_key
            iv_read_only        = abap_true
            is_control_settings = ls_control_settings
          RECEIVING
            ro_access           = lo_access.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read header data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id   = if_goal_sdoc_head=>co_entity_id
          IMPORTING
            es_entity_data = ls_head_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* read item data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id   = if_goal_sdoc_item=>co_entity_id
          IMPORTING
            et_entity_data = lt_item_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* read schedule line
* ===================================================
    LOOP AT lt_item_data INTO DATA(ls_item_data).
      CLEAR: lt_sline_data.

      TRY.
          CALL METHOD lo_access->get_entity_set
            EXPORTING
              iv_entity_id     = if_goal_sdoc_sline=>co_entity_id
              iv_handle_parent = ls_item_data-handle
            IMPORTING
              et_entity_data   = lt_sline_data.
        CATCH cx_goal_exc INTO lx_goal_exc.
          lv_text_exc = lx_goal_exc->get_text( ).
          me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
          EXIT.
      ENDTRY.

      "check delivery block code for down payment
      LOOP AT lt_sline_data INTO ls_sline_data.
        IF ls_sline_data-delivery_block_code <> lv_lifsp.
          lv_statement = 'Error:Delivery block determination failed!'.
          me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
          lv_error = abap_true.
          EXIT.
        ENDIF.
      ENDLOOP.

      IF lv_error = abap_true.
        EXIT.
      ENDIF.
    ENDLOOP.

    lo_access->get_messages( IMPORTING et_message = DATA(lt_message)
                                       es_error   = ls_error ).
    IF NOT ls_error IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = ls_error-msgtx ).
      lo_access->close( ).
      EXIT.
    ELSE.
      lo_access->close( ).
    ENDIF.

    CHECK lv_error = abap_false.

    lv_statement = 'Success: Delivery block determined successfully!'.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ev_check_status = abap_true.
  ENDMETHOD.


  METHOD check_existence.
    DATA: lv_vbeln TYPE vbeln.
    MOVE iv_id TO lv_vbeln.

    SELECT SINGLE * FROM vbak WHERE vbeln = @lv_vbeln INTO @DATA(ls_order).
    IF sy-subrc <> 0.
      me->mo_run_environment->append_log( iv_log_statement = |Order { lv_vbeln } does not exist.| ).
      rv_exists = abap_false.
    ELSE.
      rv_exists = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD check_f_it_bp_s_nbp.

    DATA: lt_doc_ids TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings,
          lo_access           TYPE REF TO if_goal_access,
          ls_error            TYPE if_goal_types=>tcs_error,
          lx_goal_exc         TYPE REF TO cx_goal_exc,
          lv_text_exc         TYPE string,
          lv_field            TYPE fieldname,
          ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
          lt_changed_field    TYPE if_goal_types=>tct_changed_field,
          lv_statement        TYPE bapi_msg.

    DATA: lv_bo_key         TYPE if_goal_types=>tcd_bo_key,
          lt_item_data      TYPE STANDARD TABLE OF tds_goal_so_item,
          ls_head_data      TYPE tds_goal_so_head,
          ls_i_bplh_data    TYPE tds_goal_sdoc_bplh,
          ls_i_bpli_data    TYPE tds_goal_sdoc_bpli,
          lt_i_bpli_data    TYPE STANDARD TABLE OF tds_goal_sdoc_bpli,
          billing_plan_data TYPE ty_billing_plan.

    ev_check_status = abap_false.


* 1 Step: get previously step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_doc_ids.
    ENDLOOP.

    READ TABLE lt_doc_ids INTO DATA(ls_doc_id) INDEX 1.
    IF sy-subrc = 0.
      lv_bo_key = ls_doc_id-vbeln.
    ENDIF.

    CHECK NOT lv_bo_key IS INITIAL.

* 2 Step: Access sales order via GOAL
* ===================================================
* open the document in change mode
* ===================================================
    TRY.
        CALL METHOD cl_goal_api=>so_instance->open
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_bo_key
            iv_read_only        = abap_true
            is_control_settings = ls_control_settings
          RECEIVING
            ro_access           = lo_access.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read header data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id   = if_goal_sdoc_head=>co_entity_id
          IMPORTING
            es_entity_data = ls_head_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read item data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id   = if_goal_sdoc_item=>co_entity_id
          IMPORTING
            et_entity_data = lt_item_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read item billing plan header
* ===================================================
    READ TABLE lt_item_data INTO DATA(ls_item_data) INDEX 1.
    CHECK sy-subrc = 0.
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bplh
            iv_handle_parent = ls_item_data-handle
          IMPORTING
            es_entity_data   = ls_i_bplh_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* get item billing plan items
* ===================================================
    CHECK NOT ls_i_bplh_data IS INITIAL.

    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bpli
            iv_handle_parent = ls_i_bplh_data-handle
          IMPORTING
            et_entity_data   = lt_i_bpli_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.


    IF lines( lt_i_bpli_data[] ) = 0 .
      lv_statement = 'Error:first item has no billing plan'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      EXIT.
    ENDIF.

    lv_statement = 'Success: first item has billing plan'.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

    CLEAR ls_i_bplh_data.

*---------get second item billing plan
*------------------------------------

    READ TABLE lt_item_data INTO DATA(ls_item_data_se) INDEX 2.
    CHECK sy-subrc = 0.
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bplh
            iv_handle_parent = ls_item_data_se-handle
          IMPORTING
            es_entity_data   = ls_i_bplh_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lv_statement = 'Success: second item has no billing plan'.
        me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
        ev_check_status = abap_true.
        EXIT.
    ENDTRY.

    IF ls_i_bplh_data IS INITIAL.
      lv_statement = 'Success: second item has no billing plan'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ELSE.
      lv_statement = 'error: second item has billing plan'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ENDIF.

    lo_access->get_messages( IMPORTING et_message = DATA(lt_message)
                                       es_error   = ls_error ).
    IF NOT ls_error IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = ls_error-msgtx ).
      lo_access->close( ).
      EXIT.
    ELSE.
      lo_access->close( ).
    ENDIF.

    ev_check_status = abap_true.
  ENDMETHOD.


  METHOD check_head_bpl_created_goal.
    DATA: lt_doc_ids TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings,
          lo_access           TYPE REF TO if_goal_access,
          ls_error            TYPE if_goal_types=>tcs_error,
          lx_goal_exc         TYPE REF TO cx_goal_exc,
          lv_text_exc         TYPE string,
          lv_field            TYPE fieldname,
          ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
          lt_changed_field    TYPE if_goal_types=>tct_changed_field,
          lv_statement        TYPE bapi_msg.

    DATA: lv_bo_key         TYPE if_goal_types=>tcd_bo_key,
          lt_item_data      TYPE STANDARD TABLE OF tds_goal_so_item,
          ls_head_data      TYPE tds_goal_so_head,
          ls_h_bplh_data    TYPE tds_goal_sdoc_bplh,
          ls_h_bpli_data    TYPE tds_goal_sdoc_bpli,
          lt_h_bpli_data    TYPE STANDARD TABLE OF tds_goal_sdoc_bpli,
          billing_plan_data TYPE ty_billing_plan.

    ev_check_status = abap_false.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = billing_plan_data ).

* 1 Step: get previously step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_doc_ids.
    ENDLOOP.

    READ TABLE lt_doc_ids INTO DATA(ls_doc_id) INDEX 1.
    IF sy-subrc = 0.
      lv_bo_key = ls_doc_id-vbeln.
    ENDIF.

    CHECK NOT lv_bo_key IS INITIAL.

* 2 Step: Access sales order via GOAL
* ===================================================
* open the document in change mode
* ===================================================
    TRY.
        CALL METHOD cl_goal_api=>so_instance->open
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_bo_key
            iv_read_only        = abap_true
            is_control_settings = ls_control_settings
          RECEIVING
            ro_access           = lo_access.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read header data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id   = if_goal_sdoc_head=>co_entity_id
          IMPORTING
            es_entity_data = ls_head_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read head billing plan header
* ===================================================
    CHECK NOT ls_head_data IS INITIAL.
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-head_bplh
            iv_handle_parent = ls_head_data-handle
          IMPORTING
            es_entity_data   = ls_h_bplh_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* get head billing plan item
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-head_bpli
            iv_handle_parent = ls_h_bplh_data-handle
          IMPORTING
            et_entity_data   = lt_h_bpli_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.

    lo_access->get_messages( IMPORTING et_message = DATA(lt_message)
                                       es_error   = ls_error ).
    IF NOT ls_error IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = ls_error-msgtx ).
      lo_access->close( ).
      EXIT.
    ELSE.
      lo_access->close( ).
    ENDIF.

    " Check billing plan items are same as TDC
    IF lines( lt_h_bpli_data[] ) <> lines( billing_plan_data-fplt[] ).
      lv_statement = 'Error:Create header level billing plan dates failed!'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      EXIT.
    ENDIF.

    lv_statement = 'Success: Create header level billing plan dates successfully!'.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ev_check_status = abap_true.
  ENDMETHOD.


  METHOD check_head_bpl_deleted_goal.
    DATA: lt_doc_ids TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings,
          lo_access           TYPE REF TO if_goal_access,
          ls_error            TYPE if_goal_types=>tcs_error,
          lx_goal_exc         TYPE REF TO cx_goal_exc,
          lv_text_exc         TYPE string,
          lv_field            TYPE fieldname,
          ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
          lt_changed_field    TYPE if_goal_types=>tct_changed_field,
          lv_statement        TYPE bapi_msg.

    DATA: lv_bo_key      TYPE if_goal_types=>tcd_bo_key,
          lt_item_data   TYPE STANDARD TABLE OF tds_goal_so_item,
          ls_head_data   TYPE tds_goal_so_head,
          ls_h_bplh_data TYPE tds_goal_sdoc_bplh,
          ls_h_bpli_data TYPE tds_goal_sdoc_bpli,
          lt_h_bpli_data TYPE STANDARD TABLE OF tds_goal_sdoc_bpli.

    ev_check_status = abap_false.

* 1 Step: get previously step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_doc_ids.
    ENDLOOP.

    READ TABLE lt_doc_ids INTO DATA(ls_doc_id) INDEX 1.
    IF sy-subrc = 0.
      lv_bo_key = ls_doc_id-vbeln.
    ENDIF.

    CHECK NOT lv_bo_key IS INITIAL.

* 2 Step: Access sales order via GOAL
* ===================================================
* open the document in change mode
* ===================================================
    TRY.
        CALL METHOD cl_goal_api=>so_instance->open
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_bo_key
            iv_read_only        = abap_true
            is_control_settings = ls_control_settings
          RECEIVING
            ro_access           = lo_access.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read header data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id   = if_goal_sdoc_head=>co_entity_id
          IMPORTING
            es_entity_data = ls_head_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* read head billing plan header
* ===================================================
    CHECK NOT ls_head_data IS INITIAL.
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-head_bplh
            iv_handle_parent = ls_head_data-handle
          IMPORTING
            es_entity_data   = ls_h_bplh_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* get head billing plan item
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-head_bpli
            iv_handle_parent = ls_h_bplh_data-handle
          IMPORTING
            et_entity_data   = lt_h_bpli_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.

    lo_access->get_messages( IMPORTING et_message = DATA(lt_message)
                                       es_error   = ls_error ).
    IF NOT ls_error IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = ls_error-msgtx ).
      lo_access->close( ).
      EXIT.
    ELSE.
      lo_access->close( ).
    ENDIF.

    IF lines( lt_h_bpli_data[] ) > 0.
      lv_statement = 'Error:Delete billing plan dates failed!'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      EXIT.
    ENDIF.

    lv_statement = 'Success: Header level billing plan dates deleted successfully!'.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ev_check_status = abap_true.
  ENDMETHOD.


  METHOD check_head_bpl_updated_goal.
    DATA: lt_doc_ids TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings,
          lo_access           TYPE REF TO if_goal_access,
          ls_error            TYPE if_goal_types=>tcs_error,
          lx_goal_exc         TYPE REF TO cx_goal_exc,
          lv_text_exc         TYPE string,
          lv_field            TYPE fieldname,
          ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
          lt_changed_field    TYPE if_goal_types=>tct_changed_field,
          lv_statement        TYPE bapi_msg.

    DATA: lv_bo_key      TYPE if_goal_types=>tcd_bo_key,
          lt_item_data   TYPE STANDARD TABLE OF tds_goal_so_item,
          ls_head_data   TYPE tds_goal_so_head,
          ls_h_bplh_data TYPE tds_goal_sdoc_bplh,
          ls_h_bpli_data TYPE tds_goal_sdoc_bpli,
          lt_h_bpli_data TYPE STANDARD TABLE OF tds_goal_sdoc_bpli.

    DATA: lv_date  TYPE fkdat,
          lv_error TYPE abap_bool.

    lv_date = sy-datum + 1.
    ev_check_status = abap_false.

* 1 Step: get previously step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_doc_ids.
    ENDLOOP.

    READ TABLE lt_doc_ids INTO DATA(ls_doc_id) INDEX 1.
    IF sy-subrc = 0.
      lv_bo_key = ls_doc_id-vbeln.
    ENDIF.

    CHECK NOT lv_bo_key IS INITIAL.

* 2 Step: Access sales order via GOAL
* ===================================================
* open the document in change mode
* ===================================================
    TRY.
        CALL METHOD cl_goal_api=>so_instance->open
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_bo_key
            iv_read_only        = abap_true
            is_control_settings = ls_control_settings
          RECEIVING
            ro_access           = lo_access.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read header data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id   = if_goal_sdoc_head=>co_entity_id
          IMPORTING
            es_entity_data = ls_head_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* read head billing plan header
* ===================================================
    CHECK NOT ls_head_data IS INITIAL.
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-head_bplh
            iv_handle_parent = ls_head_data-handle
          IMPORTING
            es_entity_data   = ls_h_bplh_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* get head billing plan item
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-head_bpli
            iv_handle_parent = ls_h_bplh_data-handle
          IMPORTING
            et_entity_data   = lt_h_bpli_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* check billing plan was updated
* ===================================================
    LOOP AT lt_h_bpli_data INTO ls_h_bpli_data.
      IF ls_h_bpli_data-billing_date <> lv_date.
        lv_statement = 'Error:Update billing plan dates failed!'.
        me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
        lv_error = abap_true.
        EXIT.
      ENDIF.
    ENDLOOP.

    lo_access->get_messages( IMPORTING et_message = DATA(lt_message)
                                       es_error   = ls_error ).
    IF NOT ls_error IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = ls_error-msgtx ).
      lo_access->close( ).
      EXIT.
    ELSE.
      lo_access->close( ).
    ENDIF.

    CHECK lv_error = abap_false.

    lv_statement = 'Success: Header level billing plan dates updated successfully!'.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ev_check_status = abap_true.
  ENDMETHOD.


  METHOD check_head_bp_exist.
    DATA: lt_doc_ids TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings,
          lo_access           TYPE REF TO if_goal_access,
          ls_error            TYPE if_goal_types=>tcs_error,
          lx_goal_exc         TYPE REF TO cx_goal_exc,
          lv_text_exc         TYPE string,
          lv_field            TYPE fieldname,
          ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
          lt_changed_field    TYPE if_goal_types=>tct_changed_field,
          lv_statement        TYPE bapi_msg.

    DATA: lv_bo_key      TYPE if_goal_types=>tcd_bo_key,
          lt_item_data   TYPE STANDARD TABLE OF tds_goal_so_item,
          ls_head_data   TYPE tds_goal_so_head,
          ls_h_bplh_data TYPE tds_goal_sdoc_bplh,
          ls_h_bpli_data TYPE tds_goal_sdoc_bpli,
          lt_h_bpli_data TYPE STANDARD TABLE OF tds_goal_sdoc_bpli.

    ev_check_status = abap_false.


* 1 Step: get previously step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_doc_ids.
    ENDLOOP.

    READ TABLE lt_doc_ids INTO DATA(ls_doc_id) INDEX 1.
    IF sy-subrc = 0.
      lv_bo_key = ls_doc_id-vbeln.
    ENDIF.

    CHECK NOT lv_bo_key IS INITIAL.

* 2 Step: Access sales order via GOAL
* ===================================================
* open the document in change mode
* ===================================================
    TRY.
        CALL METHOD cl_goal_api=>so_instance->open
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_bo_key
            iv_read_only        = abap_true
            is_control_settings = ls_control_settings
          RECEIVING
            ro_access           = lo_access.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read header data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id   = if_goal_sdoc_head=>co_entity_id
          IMPORTING
            es_entity_data = ls_head_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read head billing plan header
* ===================================================
    CHECK NOT ls_head_data IS INITIAL.
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-head_bplh
            iv_handle_parent = ls_head_data-handle
          IMPORTING
            es_entity_data   = ls_h_bplh_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* get head billing plan item
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-head_bpli
            iv_handle_parent = ls_h_bplh_data-handle
          IMPORTING
            et_entity_data   = lt_h_bpli_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.

    lo_access->get_messages( IMPORTING et_message = DATA(lt_message)
                                       es_error   = ls_error ).
    IF NOT ls_error IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = ls_error-msgtx ).
      lo_access->close( ).
      EXIT.
    ELSE.
      lo_access->close( ).
    ENDIF.

    " Check billing plan items are same as TDC
    IF lines( lt_h_bpli_data[] ) EQ 0.
      lv_statement = 'Error:header billing plan not exist!'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      EXIT.
    ENDIF.

    lv_statement = 'Success: header billing plan exist'.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ev_check_status = abap_true.
  ENDMETHOD.


  METHOD check_head_bp_not_exist.
    DATA: lt_doc_ids TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings,
          lo_access           TYPE REF TO if_goal_access,
          ls_error            TYPE if_goal_types=>tcs_error,
          lx_goal_exc         TYPE REF TO cx_goal_exc,
          lv_text_exc         TYPE string,
          lv_field            TYPE fieldname,
          ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
          lt_changed_field    TYPE if_goal_types=>tct_changed_field,
          lv_statement        TYPE bapi_msg.

    DATA: lv_bo_key      TYPE if_goal_types=>tcd_bo_key,
          lt_item_data   TYPE STANDARD TABLE OF tds_goal_so_item,
          ls_head_data   TYPE tds_goal_so_head,
          ls_h_bplh_data TYPE tds_goal_sdoc_bplh,
          ls_h_bpli_data TYPE tds_goal_sdoc_bpli,
          lt_h_bpli_data TYPE STANDARD TABLE OF tds_goal_sdoc_bpli.

    ev_check_status = abap_false.

* 1 Step: get previously step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_doc_ids.
    ENDLOOP.

    READ TABLE lt_doc_ids INTO DATA(ls_doc_id) INDEX 1.
    IF sy-subrc = 0.
      lv_bo_key = ls_doc_id-vbeln.
    ENDIF.

    CHECK NOT lv_bo_key IS INITIAL.

* 2 Step: Access sales order via GOAL
* ===================================================
* open the document in change mode
* ===================================================
    TRY.
        CALL METHOD cl_goal_api=>so_instance->open
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_bo_key
            iv_read_only        = abap_true
            is_control_settings = ls_control_settings
          RECEIVING
            ro_access           = lo_access.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read header data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id   = if_goal_sdoc_head=>co_entity_id
          IMPORTING
            es_entity_data = ls_head_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read head billing plan header
* ===================================================
    CHECK NOT ls_head_data IS INITIAL.
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-head_bplh
            iv_handle_parent = ls_head_data-handle
          IMPORTING
            es_entity_data   = ls_h_bplh_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lv_statement = 'Success:  header level billing plan dates not exist !'.
        me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
        ev_check_status = abap_true.
        EXIT.
    ENDTRY.
* ===================================================
* get head billing plan item
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-head_bpli
            iv_handle_parent = ls_h_bplh_data-handle
          IMPORTING
            et_entity_data   = lt_h_bpli_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lv_statement = 'Success:  header level billing plan dates not exist !'.
        me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
        ev_check_status = abap_true.
        EXIT.
    ENDTRY.

    lo_access->get_messages( IMPORTING et_message = DATA(lt_message)
                                       es_error   = ls_error ).
    IF NOT ls_error IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = ls_error-msgtx ).
      lo_access->close( ).
      EXIT.
    ELSE.
      lo_access->close( ).
    ENDIF.

    " Check billing plan items are same as TDC
    IF NOT lines( lt_h_bpli_data[] ) EQ 0.
      lv_statement = 'Error: header level billing plan exist!'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      EXIT.
    ENDIF.

    lv_statement = 'Success:  header level billing plan dates not exist !'.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ev_check_status = abap_true.
  ENDMETHOD.


  METHOD check_ic_doc_flow.

    TYPES:
      BEGIN OF ty_s_po_data,
        ebeln     TYPE ebeln,
        po_header	TYPE mepoheader,
        po_items  TYPE mmpur_t_mepoitem,
      END OF ty_s_po_data.

    TYPES: ty_t_po_data TYPE STANDARD TABLE OF ty_s_po_data.

    DATA lt_testdata        TYPE ty_t_or_check_ic_doc_flow.
    DATA lt_vbeln           TYPE cl_ptf_util=>ty_vbeln_tab.
    DATA ls_so_po_item_key  TYPE ty_s_so_po_item_key.
    DATA lt_so_po_item_key  TYPE ty_t_so_po_item_key.
    DATA ls_sales_item_key  TYPE sales_item_key.
    DATA lt_sales_item_key  TYPE STANDARD TABLE OF sales_item_key.
    DATA lt_vbapvb          TYPE va_vbapvb_t.
    DATA lt_vbfa            TYPE vbfa_t.
    DATA lv_ebeln           TYPE ebeln.
    DATA lt_ebeln           TYPE STANDARD TABLE OF ebeln.
    DATA lv_vbeln_c         TYPE string.
    DATA lv_posnr_c         TYPE string.
    DATA lv_ebeln_c         TYPE string.
    DATA lv_ebelp_c         TYPE string.
    DATA ls_po_data         TYPE ty_s_po_data.
    DATA lt_po_data         TYPE ty_t_po_data.
    DATA lv_error_occurred  TYPE abap_bool.
    DATA lv_rfmng           TYPE rfmng.
    DATA lv_rfmng_flo       TYPE rfmng_flo.

    FIELD-SYMBOLS <ls_sales_key> TYPE sales_key.
    FIELD-SYMBOLS <ls_vbap>      TYPE vbap.
    FIELD-SYMBOLS <ls_testdata>  TYPE ty_s_or_check_ic_doc_flow.
    FIELD-SYMBOLS <ls_po_data>   TYPE ty_s_po_data.
    FIELD-SYMBOLS <ls_po_item>   TYPE mepoitem.


    ev_check_status       = abap_false.
    ev_execution_status   = abap_false.

    " get variant parameters from the testdata container data
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = is_step_data
      IMPORTING
        es_testdata  = lt_testdata
    ).

    LOOP AT lt_testdata ASSIGNING <ls_testdata>.

      lv_posnr_c = <ls_testdata>-item_no.
      SHIFT lv_posnr_c LEFT DELETING LEADING '0'.

      " write parameter values into log
      me->mo_run_environment->append_log( iv_log_statement = |Parameter: Item { lv_posnr_c }. | &&
                                                             |Expected quantity, quantity unit/currency { <ls_testdata>-quantity }/{ <ls_testdata>-base_qty_unit }/{ <ls_testdata>-local_currency } | ).
    ENDLOOP.

    " the reference data contains the SO(2) / PO(3) item links from VCM
    LOOP AT is_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).

      LOOP AT lt_ptf_keys ASSIGNING FIELD-SYMBOL(<ls_ptf_key>).
        ls_so_po_item_key = <ls_ptf_key>.

        INSERT ls_so_po_item_key INTO TABLE lt_so_po_item_key.

        ls_sales_item_key-vbeln = ls_so_po_item_key-vbeln.
        ls_sales_item_key-posnr = ls_so_po_item_key-posnr.
        INSERT ls_sales_item_key INTO TABLE lt_sales_item_key.

        lv_ebeln = ls_so_po_item_key-ebeln.
        IF lv_ebeln IS NOT INITIAL.
*          INSERT lv_ebeln INTO TABLE lt_ebeln.
          COLLECT lv_ebeln INTO lt_ebeln.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    IF ls_sales_item_key-vbeln IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Error: Reference data contains no SO(2) data | ).
      RETURN.
    ENDIF.

    IF lt_ebeln IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Error: Reference data contains no PO(3) data | ).
      RETURN.
    ENDIF.

    lv_vbeln_c = ls_sales_item_key-vbeln.
    SHIFT lv_vbeln_c LEFT DELETING LEADING '0'.

    CALL FUNCTION 'SD_VBAP_ARRAY_READ'
* EXPORTING
*   I_BYPASSING_BUFFER          = ' '
*   I_REFRESH_BUFFER            =
      TABLES
        it_vbap_key           = lt_sales_item_key
        et_vbapvb             = lt_vbapvb
      EXCEPTIONS
        records_not_found     = 1
        records_not_requested = 2
        OTHERS                = 3.
    IF sy-subrc <> 0.
      me->mo_run_environment->append_log( iv_log_statement = |Error reading item data for SO(2) { lv_vbeln_c }| ).
      RETURN.
    ENDIF.

    CALL FUNCTION 'SD_VBFA_READ_WITH_VBELV'
      EXPORTING
        i_vbelv          = ls_sales_item_key-vbeln
      TABLES
        et_vbfa          = lt_vbfa
      EXCEPTIONS
        record_not_found = 1
        OTHERS           = 2.
    IF sy-subrc <> 0.
      me->mo_run_environment->append_log( iv_log_statement = |Error reading document flow data for SO(2) { lv_vbeln_c }| ).
      " return.
    ENDIF.

    LOOP AT lt_ebeln ASSIGNING FIELD-SYMBOL(<lv_ebeln>).
      CLEAR ls_po_data.
      ls_po_data-ebeln = <lv_ebeln>.

*    " refresh all internal buffers
*    cl_mm_po_handler_api=>close_po( ).

      cl_mm_po_handler_api=>if_mm_pur_po_convenience_api~get_po_by_id(
        EXPORTING
          iv_docno     = <lv_ebeln>
        IMPORTING
          es_po_header = ls_po_data-po_header
          et_po_items  = ls_po_data-po_items
      ).

      lv_ebeln_c = <lv_ebeln>.
      SHIFT lv_ebeln_c LEFT DELETING LEADING '0'.

      IF ls_po_data-po_header IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |Error: No PO(3) data found for PO { lv_ebeln_c } | ).
      ELSEIF ls_po_data-po_items IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |Error: No PO(3) item data found for PO { lv_ebeln_c } | ).
      ELSE.
        INSERT ls_po_data INTO TABLE lt_po_data.
      ENDIF.
    ENDLOOP.

    lv_error_occurred = abap_false.
    LOOP AT lt_so_po_item_key ASSIGNING FIELD-SYMBOL(<ls_so_po_item_key>).
      " each entry in the table needs a corresponding doc flow entry

      lv_vbeln_c = <ls_so_po_item_key>-vbeln.
      SHIFT lv_vbeln_c LEFT DELETING LEADING '0'.
      lv_posnr_c = <ls_so_po_item_key>-posnr.
      SHIFT lv_posnr_c LEFT DELETING LEADING '0'.
      lv_ebeln_c = <ls_so_po_item_key>-ebeln.
      SHIFT lv_ebeln_c LEFT DELETING LEADING '0'.
      lv_ebelp_c = <ls_so_po_item_key>-ebelp.
      SHIFT lv_ebelp_c LEFT DELETING LEADING '0'.

      "read expected testdata
      READ TABLE lt_testdata ASSIGNING <ls_testdata>
        WITH KEY
          item_no = <ls_so_po_item_key>-posnr.
      IF sy-subrc <> 0.
        me->mo_run_environment->append_log( iv_log_statement = |Error: Testdata not found for Item | &&
                                                               |{ lv_posnr_c }| ).
        lv_error_occurred = abap_true.
        CONTINUE.
      ENDIF.

      " for the case PO deleted and should not exist in docflow
      IF <ls_testdata>-no_po IS NOT INITIAL.
        IF line_exists( lt_vbfa[ vbelv = <ls_so_po_item_key>-vbeln
                                 posnv = <ls_so_po_item_key>-posnr
                                 vbeln = <ls_so_po_item_key>-ebeln
                                 posnn = <ls_so_po_item_key>-ebelp ] ).
          me->mo_run_environment->append_log( iv_log_statement = |Error: PO { lv_ebeln_c }/{ lv_ebelp_c } | &&
                                                                 |should not exist in document flow { lv_vbeln_c }/{ lv_posnr_c } | ).
          lv_error_occurred = abap_true.
          CONTINUE.
        ELSE.
          me->mo_run_environment->append_log( iv_log_statement = |Success: PO { lv_ebeln_c }/{ lv_ebelp_c } | &&
                                                                 |not exist in document flow { lv_vbeln_c }/{ lv_posnr_c } | ).
          CONTINUE.
        ENDIF.
      ENDIF.

      READ TABLE lt_vbfa ASSIGNING FIELD-SYMBOL(<ls_vbfa>)
        WITH KEY
          vbelv = <ls_so_po_item_key>-vbeln
          posnv = <ls_so_po_item_key>-posnr
          vbeln = <ls_so_po_item_key>-ebeln
          posnn = <ls_so_po_item_key>-ebelp.

      IF sy-subrc <> 0.
        me->mo_run_environment->append_log( iv_log_statement = |Error: No document flow data found for predecessor | &&
                                                               |{ lv_vbeln_c }/{ lv_posnr_c } | &&
                                                               |and successor { lv_ebeln_c }/{ lv_ebelp_c } | ).
        lv_error_occurred = abap_true.
        CONTINUE.
      ENDIF.

      me->mo_run_environment->append_log( iv_log_statement = |Processing entry for predecessor { lv_vbeln_c }/{ lv_posnr_c } | &&
                                                             |and successor { lv_ebeln_c }/{ lv_ebelp_c } | ).

      " check content of document flow
      IF <ls_vbfa>-vbtyp_v <> if_sd_doc_category=>order.
        me->mo_run_environment->append_log( iv_log_statement = |Error: Document category of predecessor wrong. Expected: { if_sd_doc_category=>order }, actual: | &&
                                                               |{ <ls_vbfa>-vbtyp_v } | ).
        lv_error_occurred = abap_true.

        " severe error, don't check the remaining fields
        CONTINUE.
      ENDIF.

      IF <ls_vbfa>-vbtyp_n <> if_sd_doc_category=>purchase_order.
        me->mo_run_environment->append_log( iv_log_statement = |Error: Document category of successor wrong. Expected: { if_sd_doc_category=>purchase_order }, actual: | &&
                                                               |{ <ls_vbfa>-vbtyp_n } | ).
        lv_error_occurred = abap_true.
        " severe error, don't check the remaining fields
        CONTINUE.
      ENDIF.

      IF <ls_vbfa>-meins <> <ls_testdata>-base_qty_unit.
        me->mo_run_environment->append_log( iv_log_statement = |Error: Base quantity unit wrong. Expected: { <ls_testdata>-base_qty_unit }, actual | &&
                                                               |{ <ls_vbfa>-meins } | ).
        lv_error_occurred = abap_true.
        " severe error, don't check the remaining fields
        CONTINUE.
      ENDIF.

      IF <ls_vbfa>-rfmng <> <ls_testdata>-quantity.
        me->mo_run_environment->append_log( iv_log_statement = |Error: Quantity wrong. Expected: { <ls_testdata>-quantity }, actual | &&
                                                               |{ <ls_vbfa>-rfmng } | ).
        lv_error_occurred = abap_true.
        " severe error, don't check the remaining fields
        CONTINUE.
      ENDIF.

      IF <ls_vbfa>-waers <> <ls_testdata>-local_currency.
        me->mo_run_environment->append_log( iv_log_statement = |Error: Local currency wrong. Expected: { <ls_testdata>-local_currency }, actual | &&
                                                               |{ <ls_vbfa>-waers } | ).
        lv_error_occurred = abap_true.
        " severe error, don't check the remaining fields
        CONTINUE.
      ENDIF.

      IF <ls_po_data> IS NOT ASSIGNED OR
        <ls_po_data>-ebeln <> <ls_so_po_item_key>-ebeln.

        READ TABLE lt_po_data ASSIGNING <ls_po_data>
          WITH KEY ebeln = <ls_so_po_item_key>-ebeln.

        IF <ls_po_data> IS NOT ASSIGNED.
          me->mo_run_environment->append_log( iv_log_statement = |Error: PO not found | ).
          lv_error_occurred = abap_true.
          " severe error, don't check the remaining fields
          CONTINUE.
        ENDIF.
      ENDIF.

      UNASSIGN <ls_po_item>.

      READ TABLE <ls_po_data>-po_items ASSIGNING <ls_po_item>
        WITH KEY
          ebeln = <ls_so_po_item_key>-ebeln
          ebelp = <ls_so_po_item_key>-ebelp.

      IF <ls_po_item> IS NOT ASSIGNED.
        me->mo_run_environment->append_log( iv_log_statement = |Error: PO item not found | ).
        lv_error_occurred = abap_true.
        " severe error, don't check the remaining fields
        CONTINUE.
      ENDIF.

      " VBFA base quantity unit <> EKPO order unit -> convert quantity
      IF <ls_vbfa>-meins <> <ls_po_item>-meins.
        lv_rfmng     = <ls_po_item>-menge * <ls_po_item>-umrez / <ls_po_item>-umren.
      ELSE.
        lv_rfmng     = <ls_po_item>-menge.
      ENDIF.

      IF <ls_vbfa>-rfmng <> lv_rfmng.
        me->mo_run_environment->append_log( iv_log_statement = |Error: Quantity in base qty unit wrong. Expected { lv_rfmng }, actual { <ls_vbfa>-rfmng } | ).
        lv_error_occurred = abap_true.
      ENDIF.

      " VBFA base quantity unit = EKPO base quantity unit?
      IF <ls_vbfa>-meins <> <ls_po_item>-lmein.
        me->mo_run_environment->append_log( iv_log_statement = |Error: Base quantity unit wrong. Expected { <ls_po_item>-lmein }, actual { <ls_vbfa>-meins } | ).
        lv_error_occurred = abap_true.
      ENDIF.

      " VBFA sales quantity unit = EKPO order quantity unit?
      IF <ls_vbfa>-vrkme <> <ls_po_item>-meins.
        me->mo_run_environment->append_log( iv_log_statement = |Error: Sales quantity unit wrong. Expected { <ls_po_item>-meins }, actual { <ls_vbfa>-vrkme } | ).
        lv_error_occurred = abap_true.
      ENDIF.

      lv_rfmng_flo = <ls_po_item>-menge / 1000.
      IF <ls_vbfa>-rfmng_flo <> lv_rfmng_flo.
        me->mo_run_environment->append_log( iv_log_statement = |Error: Quantity in sales qty unit wrong. Expected { lv_rfmng_flo }, actual { <ls_vbfa>-rfmng_flo } | ).
        lv_error_occurred = abap_true.
      ENDIF.

      IF <ls_vbfa>-waers = <ls_po_data>-po_header-waers.
        IF <ls_po_item>-effwr <> 0.
          IF <ls_vbfa>-rfwrt <> <ls_po_item>-effwr.
            me->mo_run_environment->append_log( iv_log_statement = |Error: Value wrong. Expected { <ls_po_item>-effwr }, actual { <ls_vbfa>-rfwrt } | ).
            lv_error_occurred = abap_true.
          ENDIF.
        ELSEIF <ls_vbfa>-rfwrt <> <ls_po_item>-netwr.
          me->mo_run_environment->append_log( iv_log_statement = |Error: Value wrong. Expected { <ls_po_item>-netwr }, actual { <ls_vbfa>-rfwrt } | ).
          lv_error_occurred = abap_true.
        ENDIF.
      ELSE.
        " we will not code the currency conversion here. Let's just expect that the converted value is not exactly the same value
        IF <ls_vbfa>-rfwrt = <ls_po_item>-netwr.
          me->mo_run_environment->append_log( iv_log_statement = |Error: Item value { <ls_vbfa>-rfwrt } was not converted to local currency.| ).
          lv_error_occurred = abap_true.
        ENDIF.
      ENDIF.

      UNASSIGN <ls_vbfa>.
    ENDLOOP.


    IF lv_error_occurred = abap_true.
      " at least one entry has an error
      me->mo_run_environment->append_log( iv_log_statement = |Error occurred. Details see in log above| ).
    ELSE.
      " success
      me->mo_run_environment->append_log( iv_log_statement = |Success: Document flow correct for all ICO relevant items| ).
      ev_check_status = abap_true.
      ev_execution_status = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD check_ic_movement_type.


*---------------------------------------------------------------------------------------
* Movement Type 687 = 'GMDel to Iss Val SiT'
*---------------------------------------------------------------------------------------

    DATA:
      lt_testdata    TYPE ty_gt_ptf_or_check_ic_bwart_td,
      lt_vbeln       TYPE cl_ptf_util=>ty_vbeln_tab,
      lv_vbeln       TYPE ptfkey,
      lt_sales_key   TYPE STANDARD TABLE OF sales_key,
      lt_vbap        TYPE STANDARD TABLE OF vbap,
      lt_vbep        TYPE STANDARD TABLE OF vbep,
      lv_ic_relevant TYPE boole_d,
      lv_success     TYPE boole_d,
      lv_bwart       TYPE bwart,  " Goods Movement Type (Inventory Management)
      lv_statement   TYPE bapi_msg
      .
    FIELD-SYMBOLS:
      <ls_testdata> TYPE ty_gs_ptf_or_check_ic_bwart_td,
      <ls_vbap>     TYPE vbap,
      <ls_vbep>     TYPE vbep
      .

    DATA(lo_sd_sls_ic_utility) = cl_sd_sls_ic_factory=>so_instance->get_instance_util( ).

* initialize output parameters
    ev_check_status     = abap_false.
    ev_execution_status = abap_false.
* initialization
    CLEAR:
      lt_vbeln
      .
    lv_success = abap_false.


* get testdata container data
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = lt_testdata
    ).

* get SO2 sales order
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
      APPEND LINES OF lt_ptf_keys TO lt_sales_key.
    ENDLOOP.
    CLEAR lv_vbeln.
    READ TABLE lt_vbeln INTO lv_vbeln INDEX 1.
    IF lv_vbeln IS INITIAL.
      CLEAR lv_statement.
      lv_statement = 'Error: No SO2 order found.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      RETURN. " check fails
    ENDIF.



* get items of SO2
    CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
      TABLES
        it_vbak_key           = lt_sales_key
        et_vbap               = lt_vbap
      EXCEPTIONS
        records_not_found     = 1
        records_not_requested = 2
        OTHERS                = 3.
    IF sy-subrc NE 0.
* error when reading SO2 items
      CLEAR lv_statement.
      lv_statement = 'Error: No items found in SO2 order &1'.
      REPLACE '&1' IN lv_statement WITH lv_vbeln.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      RETURN. " check fails
    ELSE.

      SORT lt_vbap BY vbeln posnr.

* if items (VBAP) have been found, get schedule lines (VBEP) of SO2
      CALL FUNCTION 'SD_VBEP_ARRAY_READ_VBELN'
        TABLES
          it_vbak_key           = lt_sales_key
          et_vbep               = lt_vbep
        EXCEPTIONS
          records_not_found     = 1
          records_not_requested = 2
          OTHERS                = 3.
      IF sy-subrc EQ 0.

        SORT lt_vbep BY vbeln posnr etenr.

      ELSE.
* error: no schedule lines found in SO2
        CLEAR lv_statement.
        lv_statement = 'Error: No schedule lines found in SO2 order &1.'.
        REPLACE '&1' IN lv_statement WITH lv_vbeln.
        me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
        RETURN. " check fails

      ENDIF.


    ENDIF.  " VBAP - IF sy-subrc NE 0.

* run the checks:
* - the SO2 item must be IC-relevant
* - the SO2 schedule line must have the correct movement type
    lv_success = abap_true.

    LOOP AT lt_testdata ASSIGNING <ls_testdata>.

      CLEAR lv_statement.
      lv_statement = 'Checking movement type in S02 order &1 , item &2 , schedule line &3. '.
      REPLACE '&1' IN lv_statement WITH lv_vbeln.
      REPLACE '&2' IN lv_statement WITH <ls_testdata>-posnr.
      REPLACE '&3' IN lv_statement WITH <ls_testdata>-etenr.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

      CLEAR lv_statement.
      lv_statement = 'Required movement type: &1'.
      REPLACE '&1' IN lv_statement WITH <ls_testdata>-bwart.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).


      DO 1 TIMES.

        READ TABLE lt_vbap ASSIGNING <ls_vbap>
          WITH KEY
            vbeln = lv_vbeln
            posnr = <ls_testdata>-posnr
            .
        IF sy-subrc NE 0.
          CLEAR lv_statement.
          lv_statement = 'Error: item &1 not found in SO2 order &2.'.
          REPLACE '&1' IN lv_statement WITH <ls_testdata>-posnr.
          REPLACE '&2' IN lv_statement WITH lv_vbeln.
          me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
          lv_success = abap_false.
          EXIT.
        ENDIF.

* check if the current item is IC-relevant
        CLEAR lv_ic_relevant.
        TRY.
            lo_sd_sls_ic_utility->is_item_ic_relevant(
              EXPORTING
                iv_vbeln             = <ls_vbap>-vbeln
                iv_posnr             = <ls_vbap>-posnr
              RECEIVING
                rv_ic_relevance_item = lv_ic_relevant
            ).
          CATCH cx_sd_doc_not_found. " SD document cannot be found
            CLEAR lv_statement.
            lv_statement = 'Error: SD document not found when determining IC relevance.'.
            me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
            lv_success = abap_false.
        ENDTRY.
        IF lv_ic_relevant EQ abap_false.
          CLEAR lv_statement.
          lv_statement = 'Error: The item &1 is not IC-relevant.'.
          REPLACE '&1' IN lv_statement WITH <ls_testdata>-posnr.
          me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
          lv_success = abap_false.
        ENDIF.


* schedule lines of the current item
        READ TABLE lt_vbep ASSIGNING <ls_vbep>
          WITH KEY
            vbeln = lv_vbeln
            posnr = <ls_testdata>-posnr
            etenr = <ls_testdata>-etenr
          BINARY SEARCH
          .
        IF sy-subrc NE 0.
          CLEAR lv_statement.
          lv_statement = 'Error: Schedule line not found: order &1 , item &2 , schedule line &3.'.
          REPLACE '&1' IN lv_statement WITH lv_vbeln.
          REPLACE '&2' IN lv_statement WITH <ls_testdata>-posnr.
          REPLACE '&3' IN lv_statement WITH <ls_testdata>-etenr.
          me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
          lv_success = abap_false.
          EXIT.
        ENDIF.

        IF <ls_vbep>-bwart EQ <ls_testdata>-bwart.
* success: schedule line of IC-relevant item does contain the required movement type
          lv_success = abap_true.
          CLEAR lv_statement.
          lv_statement = 'Success: The IC-relevant item &1 has a schedule line &2 with the required movement type &3'.
          REPLACE '&1' IN lv_statement WITH <ls_testdata>-posnr.
          REPLACE '&2' IN lv_statement WITH <ls_testdata>-etenr.
          REPLACE '&3' IN lv_statement WITH <ls_testdata>-bwart.
          me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

        ELSE.
* error: schedule line of IC-relevant item does not contain the required movement type
          lv_success = abap_false.
          CLEAR lv_statement.
          lv_statement = 'Failure: IC-relevant item &1 , schedule line &2 does not have the required movement type &3'.
          REPLACE '&1' IN lv_statement WITH <ls_testdata>-posnr.
          REPLACE '&2' IN lv_statement WITH <ls_testdata>-etenr.
          REPLACE '&3' IN lv_statement WITH <ls_testdata>-bwart.
          me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
        ENDIF.

      ENDDO.

    ENDLOOP.  " AT lt_testdata ASSIGNING <ls_testdata>

* success?
    IF lv_success EQ abap_true.
      ev_check_status = abap_true.
      ev_execution_status = abap_true.
    ELSE.
      ev_check_status = abap_false.
      ev_execution_status = abap_true.
    ENDIF.


  ENDMETHOD.


  METHOD check_ic_so4.

    DATA:iv_vbeln TYPE vbeln_va,
         lt_vbeln TYPE cl_ptf_util=>ty_vbeln_tab.
    CLEAR:lt_vbeln.
    DATA:iv_lifsp TYPE lifsp_ep,
         lv_msg   TYPE string.
    DATA: lv_ebeln TYPE ekko-ebeln.
    DATA: lv_vbeln TYPE vbeln_va.
    DATA: lt_docflow TYPE tdt_docflow.
    DATA: lv_sales_key TYPE sales_key.
    DATA: lt_sales_key TYPE TABLE OF sales_key.
    DATA: lt_so2_item_key TYPE if_vcm_value_chain_item_read=>tt_bo_item.
    DATA: ls_so2_item_key LIKE LINE OF lt_so2_item_key.
    DATA: lt_vbap TYPE TABLE OF vbap.
    DATA: lv_ic_relevant TYPE boole_d.
    DATA: lv_ic_item_found TYPE boole_d.
    FIELD-SYMBOLS: <ls_vbap> TYPE vbap.
    DATA lt_vcm_link TYPE TABLE OF cl_ptf_bo_or=>tcs_value_type.
    " get SO2
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
      APPEND LINES OF lt_ptf_keys TO lt_sales_key.
    ENDLOOP.


    " wait so PO3 + SO4 are created. (normal system conditions)
    WAIT UP TO 10 SECONDS.

    DATA(lo_sd_sls_ic_utility) = cl_sd_sls_ic_factory=>so_instance->get_instance_util( ).
    DATA(lo_sd_sls_vcm_integration) = cl_sd_sls_vcm_factory=>so_instance->get_instance_vcm_integration( ).

    " get link to PO/SO
    CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
* EXPORTING
*   I_BYPASSING_BUFFER          = ' '
*   I_REFRESH_BUFFER            =
      TABLES
        it_vbak_key           = lt_sales_key
*       ET_VBAPVB             =
        et_vbap               = lt_vbap
      EXCEPTIONS
        records_not_found     = 1
        records_not_requested = 2
        OTHERS                = 3.
    IF sy-subrc <> 0.
      me->mo_run_environment->append_log( iv_log_statement = 'error to read SO2 items' ).
      RETURN. " check fails
    ENDIF.

    LOOP AT lt_vbap ASSIGNING <ls_vbap>.
      ls_so2_item_key-object_id = <ls_vbap>-vbeln.
      ls_so2_item_key-item_id   = <ls_vbap>-posnr.
      ls_so2_item_key-step_type = 'SOSC'.
      APPEND ls_so2_item_key TO lt_so2_item_key.
    ENDLOOP.

    lt_vcm_link = VALUE #( ( object_id     = <ls_vbap>-vbeln
                           item_id       = <ls_vbap>-posnr
                           source_step_type =  'SOSC'
                           value_chain_type = 'IC_SALES'
                           target_step_type =  'SOIC'
                           value_chain_category =   'ICSL' ) ).

    lo_sd_sls_vcm_integration->get_vcm_item_link(
      EXPORTING
        it_predecessor_item        = lt_so2_item_key
"        iv_target_vcm_step_type_id = 'SOIC'
        it_value_chain = lt_vcm_link
      IMPORTING
        et_item_link               = DATA(lt_item_link)
    ).
    IF lt_item_link IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = 'error: no SO4 was created' ).
      RETURN.
    ENDIF.

    " set PTF method result
    " we assume that at least 1 SO2 item must be IC-relevant
    " for each IC-relevant item in SO2, a corresponding link to SO4 must exist!
    LOOP AT lt_vbap   ASSIGNING <ls_vbap>.

      TRY.
          lo_sd_sls_ic_utility->is_item_ic_relevant(
            EXPORTING
              iv_vbeln             = <ls_vbap>-vbeln
              iv_posnr             = <ls_vbap>-posnr
            RECEIVING
              rv_ic_relevance_item = lv_ic_relevant
          ).
        CATCH cx_sd_doc_not_found. " SD document cannot be found
          me->mo_run_environment->append_log( iv_log_statement = 'error to determine IC relevance' ).
          RETURN. " failure!
      ENDTRY.
      IF lv_ic_relevant = abap_true.
        READ TABLE lt_item_link ASSIGNING FIELD-SYMBOL(<ls_item_link>)
          WITH KEY
            predecessor-object_id = <ls_vbap>-vbeln
            predecessor-item_id   = <ls_vbap>-posnr.
        IF sy-subrc <> 0.
          me->mo_run_environment->append_log( iv_log_statement = 'error to read SO2 items' ).
          RETURN. " failure!
        ENDIF.
        IF <ls_item_link>-item-object_id IS INITIAL OR
           <ls_item_link>-item-item_id   IS INITIAL.
          me->mo_run_environment->append_log( iv_log_statement = 'error: initial SO4 item number' ).
          RETURN. " failure!
        ENDIF.
        " success: at least 1 IC item found!
        lv_ic_item_found = abap_true.
      ENDIF.
    ENDLOOP.

    " success?
    IF lv_ic_item_found = abap_true.
      me->mo_run_environment->append_log( iv_log_statement =
                                                             'success: 1) at least 1 IC relevant item processed. 2) all IC relevant items have assigned SO4 item' ).
      ev_check_status = abap_true.
      ev_execution_status = abap_true.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement =
                                                             'error: no IC relevant item found, or some IC relevant item does not have SO4 counterpart' ).
    ENDIF.

  ENDMETHOD.


  METHOD check_ic_so4_bapi_change.

    CONSTANTS: lc_msgid_ic          TYPE sy-msgid VALUE 'SD_SLS_INTERCOMPANY',
               lc_msgno_not_allowed TYPE sy-msgno VALUE '100'.

    DATA lv_error_occurred  TYPE abap_bool.
    DATA: lt_sales_key  TYPE TABLE OF sales_key,
          lv_vbeln      TYPE vbeln_va,
          lv_auart      TYPE auart,
          ls_header_inx TYPE bapisdh1x,
          lt_return     TYPE TABLE OF bapiret2.

    ev_check_status       = abap_false.
    ev_execution_status   = abap_false.

    " the reference data contains the SO4
    LOOP AT is_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_sales_key.
    ENDLOOP.

    IF lt_sales_key[] IS INITIAL.
      me->mo_run_environment->append_log( |No sales order found from reference step| ).
      RETURN.
    ENDIF.

    lv_error_occurred = abap_false.

    LOOP AT lt_sales_key INTO lv_vbeln.

      CLEAR: lv_auart.
      " check if it is SO4 to be checked
      SELECT SINGLE auart FROM vbak INTO lv_auart WHERE vbeln = lv_vbeln.
      DATA(lo_ic_util) = cl_sd_sls_ic_factory=>so_instance->get_instance_util( ).
      DATA(lv_dco) = lo_ic_util->is_so_of_delivering_company( lv_auart ).
      IF lv_dco = abap_false.
        me->mo_run_environment->append_log( | { lv_auart } is not document type for SO4 and would not be checked| ).
        CONTINUE.
      ENDIF.

      " -------------------------- start to check BAPI change SO4 -----
      ls_header_inx-updateflag = 'U'.
      CLEAR: lt_return[].
      CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
        EXPORTING
          salesdocument    = lv_vbeln
          order_header_inx = ls_header_inx
        TABLES
          return           = lt_return.

      IF lt_return[] IS INITIAL.
        me->mo_run_environment->append_log( |Error: SO4 { lv_vbeln } could be changed via BAPI | ).
        lv_error_occurred = abap_true.
        CONTINUE.

      ELSE.
        ASSIGN lt_return[ id = lc_msgid_ic number = lc_msgno_not_allowed ] TO FIELD-SYMBOL(<fs_msg>).
        IF sy-subrc = 0.
          me->mo_run_environment->append_log( | { <fs_msg>-message } | ).
          lv_error_occurred = abap_false.

        ELSE.
          me->mo_run_environment->append_log( |Error: IC relevant message not found for SO4 BAPI check | ).
          lv_error_occurred = abap_true.
        ENDIF.
      ENDIF.

    ENDLOOP.

    IF lv_error_occurred = abap_true.
      " at least one entry has an error
      me->mo_run_environment->append_log( iv_log_statement = |Error occurred. Details see in log above| ).
    ELSE.
      " success
      me->mo_run_environment->append_log( iv_log_statement = |Success: SO4 successfully checked| ).
      ev_check_status = abap_true.
      ev_execution_status = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD check_ic_so4_bapi_create.

    CONSTANTS: lc_msgid_ic          TYPE sy-msgid VALUE 'SD_SLS_INTERCOMPANY',
               lc_msgno_not_allowed TYPE sy-msgno VALUE '723'.

    DATA: ls_testdata TYPE ty_gs_i_ptf_or_cr_td.
    DATA: lv_error_occurred  TYPE abap_bool.

    ev_check_status       = abap_false.
    ev_execution_status   = abap_false.

    " get variant parameters from the testdata container data
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = is_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

    IF ls_testdata IS INITIAL.
      me->mo_run_environment->append_log( |No check data configured| ).
      RETURN.
    ENDIF.

    " prepare test data for BAPI
    DATA: ls_header_inx TYPE bapisdhd1x,
          lt_return     TYPE STANDARD TABLE OF bapiret2,
          lv_vbeln      TYPE vbeln_va.
    ic_prepare_testdata_create(
      EXPORTING
        ls_testdata        = ls_testdata
      IMPORTING
        ls_order_header_in = DATA(ls_header_in)
        lt_order_partners  = DATA(lt_partners) ).
    IF ls_header_in-doc_type   IS INITIAL OR
       ls_header_in-sales_org  IS INITIAL OR
       ls_header_in-distr_chan IS INITIAL OR
       ls_header_in-division   IS INITIAL.
      me->mo_run_environment->append_log( |Check data configuration incomplete| ).
      RETURN.
    ENDIF.

    IF NOT line_exists( lt_partners[ partn_role = 'AG' ] ) .
      me->mo_run_environment->append_log( |Check data configuration sold-to partner missing| ).
      RETURN.
    ENDIF.

    " check if document type is SO4 relevant
    IF ls_header_in-doc_type IS NOT INITIAL.
      DATA(lo_ic_util) = cl_sd_sls_ic_factory=>so_instance->get_instance_util( ).
      DATA(lv_dco) = lo_ic_util->is_so_of_delivering_company( ls_header_in-doc_type ).
      IF lv_dco = abap_false.
        me->mo_run_environment->append_log( |{ ls_header_in-doc_type } is not SO4 relevant, BAPI create could not be checked | ).
        RETURN.
      ENDIF.
    ENDIF.

    ls_header_inx-doc_type   = 'X'.
    ls_header_inx-sales_org  = 'X'.
    ls_header_inx-distr_chan = 'X'.
    ls_header_inx-division   = 'X'.

    me->mo_run_environment->append_log( |Start to create SO for order type { ls_header_in-doc_type } | ).

    " call BAPI create for SO4
    CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
      EXPORTING
        order_header_in  = ls_header_in
        order_header_inx = ls_header_inx
      IMPORTING
        salesdocument    = lv_vbeln
      TABLES
        return           = lt_return
        order_partners   = lt_partners.

    IF lv_vbeln IS NOT INITIAL.
      me->mo_run_environment->append_log( |Error: SO { lv_vbeln } could be created for order type { ls_header_in-doc_type } | ).
      lv_error_occurred = abap_true.

    ELSEIF lt_return[] IS INITIAL.
      me->mo_run_environment->append_log( |Error: Please check if { ls_header_in-doc_type } is the order type for SO4 | ).
      lv_error_occurred = abap_true.

    ELSE.
      ASSIGN lt_return[ id = lc_msgid_ic number = lc_msgno_not_allowed ] TO FIELD-SYMBOL(<fs_msg>).
      IF sy-subrc = 0.
        me->mo_run_environment->append_log( | { <fs_msg>-message } | ).
        lv_error_occurred = abap_false.

      ELSE.
        me->mo_run_environment->append_log( |Error: Please check if { ls_header_in-doc_type } is the order type for SO4 | ).
        lv_error_occurred = abap_true.
      ENDIF.

    ENDIF.


    IF lv_error_occurred = abap_true.
      " at least one entry has an error
      me->mo_run_environment->append_log( iv_log_statement = |Error occurred. Details see in log above| ).
    ELSE.
      " success
      me->mo_run_environment->append_log( iv_log_statement = |Success: SO4 successfully checked| ).
      ev_check_status = abap_true.
      ev_execution_status = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD check_ic_transit_plant.

    DATA lt_testdata        TYPE ty_t_or_check_ic_transit_plant.
    DATA lt_vbeln           TYPE cl_ptf_util=>ty_vbeln_tab.
    DATA lt_sales_key       TYPE STANDARD TABLE OF sales_key.
    DATA lt_vbap            TYPE vbap_tab.
    DATA lv_error_occurred  TYPE abap_bool.
    DATA lv_vbeln_c         TYPE string.
    DATA lv_posnr_c         TYPE string.

    FIELD-SYMBOLS <ls_sales_key> TYPE sales_key.
    FIELD-SYMBOLS <ls_vbap>      TYPE vbap.
    FIELD-SYMBOLS <ls_testdata>  TYPE ty_s_or_check_ic_transit_plant.


    " meaning of test data content: if no line exists for the item or if the transit plant is initial,
    " then the item transit plant is expected to be empty


    ev_check_status       = abap_false.
    ev_execution_status   = abap_false.

    " get variant parameters from the testdata container data
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = is_step_data
      IMPORTING
        es_testdata  = lt_testdata
    ).

    " write parameter values into log
    LOOP AT lt_testdata ASSIGNING <ls_testdata>.
      me->mo_run_environment->append_log( iv_log_statement = |Parameter: Item { <ls_testdata>-posnr }, expected transit plant: { <ls_testdata>-transit_plant } | ).
    ENDLOOP.

    " get SO(2)
    LOOP AT is_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      lt_vbeln = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_vbeln TO lt_sales_key.
    ENDLOOP.

    READ TABLE lt_vbeln ASSIGNING FIELD-SYMBOL(<ls_vbeln>) INDEX 1.
    IF <ls_vbeln> IS NOT ASSIGNED.
      me->mo_run_environment->append_log( iv_log_statement = |Error: SO(2) not found in reference step| ).
      RETURN.
    ENDIF.

    CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
      TABLES
        it_vbak_key           = lt_sales_key
        et_vbap               = lt_vbap
      EXCEPTIONS
        records_not_found     = 1
        records_not_requested = 2
        OTHERS                = 3.
    IF sy-subrc <> 0.
      me->mo_run_environment->append_log( iv_log_statement = |Error: No items found in SO(2) { <ls_vbeln>-vbeln }| ).
      RETURN.
    ENDIF.


    LOOP AT lt_vbap ASSIGNING <ls_vbap>.
      lv_vbeln_c = <ls_vbap>-vbeln.
      SHIFT lv_vbeln_c LEFT DELETING LEADING '0'.
      lv_posnr_c = <ls_vbap>-posnr.
      SHIFT lv_posnr_c LEFT DELETING LEADING '0'.

      me->mo_run_environment->append_log( iv_log_statement = |Processing document { lv_vbeln_c } item { lv_posnr_c }| ).

      UNASSIGN <ls_testdata>.

      READ TABLE lt_testdata ASSIGNING <ls_testdata>
        WITH KEY
          posnr = <ls_vbap>-posnr.

      IF sy-subrc = 0.
        " transit plant was provided -  this could be an empty value as well
        IF <ls_vbap>-transit_plant <> <ls_testdata>-transit_plant.
          lv_error_occurred = abap_true.
          me->mo_run_environment->append_log( iv_log_statement = |Error: Transit Plant wrong. Expected: { <ls_testdata>-transit_plant }, actual: | &&
                                                                 |{ <ls_vbap>-transit_plant } | ).
        ENDIF.

      ELSEIF <ls_vbap>-transit_plant IS NOT INITIAL.
        " item not provided -> transit plant was supposed to be empty
        lv_error_occurred = abap_true.
        me->mo_run_environment->append_log( iv_log_statement = |Error: Transit Plant wrong. Expected: initial value, actual: | &&
                                                               |{ <ls_vbap>-transit_plant } | ).
      ENDIF.

    ENDLOOP.

    IF lv_error_occurred = abap_true.
      " at least one item has an error
      me->mo_run_environment->append_log( iv_log_statement = |Error occurred. Details see in log above| ).

    ELSE.
      " success
      me->mo_run_environment->append_log( iv_log_statement = |Success: Transit plant is as expected for all items| ).
      ev_check_status = abap_true.
      ev_execution_status = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD check_ic_vcm_not_triggered.

    DATA lt_vbeln           TYPE cl_ptf_util=>ty_vbeln_tab.
    DATA lt_sales_key       TYPE STANDARD TABLE OF sales_key.
    DATA lt_vbap            TYPE vbap_tab.
    DATA lv_vbeln_c         TYPE string.
    DATA lv_posnr_c         TYPE string.
    DATA lv_error_occurred  TYPE abap_bool.

    FIELD-SYMBOLS <ls_vbap> TYPE vbap.


    ev_check_status       = abap_false.
    ev_execution_status   = abap_false.

    " get SO(2)
    LOOP AT is_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      lt_vbeln = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_vbeln TO lt_sales_key.
    ENDLOOP.

    READ TABLE lt_vbeln ASSIGNING FIELD-SYMBOL(<ls_vbeln>) INDEX 1.
    IF <ls_vbeln> IS NOT ASSIGNED.
      me->mo_run_environment->append_log( iv_log_statement = |Error: SO(2) not found in reference step| ).
      RETURN.
    ENDIF.

    DATA(lo_sd_sls_ic_utility) = cl_sd_sls_ic_factory=>so_instance->get_instance_util( ).

    " get link to PO(3) for every ICO relevant item
    CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
      TABLES
        it_vbak_key           = lt_sales_key
        et_vbap               = lt_vbap
      EXCEPTIONS
        records_not_found     = 1
        records_not_requested = 2
        OTHERS                = 3.
    IF sy-subrc <> 0.
      lv_vbeln_c = <ls_vbeln>-vbeln.
      SHIFT lv_vbeln_c LEFT DELETING LEADING '0'.
      me->mo_run_environment->append_log( iv_log_statement = |Error: No items found in SO(2) { lv_vbeln_c }| ).
      RETURN.
    ENDIF.

    LOOP AT lt_vbap ASSIGNING <ls_vbap>.

      lv_vbeln_c = <ls_vbap>-vbeln.
      SHIFT lv_vbeln_c LEFT DELETING LEADING '0'.
      lv_posnr_c = <ls_vbap>-posnr.
      SHIFT lv_posnr_c LEFT DELETING LEADING '0'.

      me->mo_run_environment->append_log( iv_log_statement = |Processing document { lv_vbeln_c } item { lv_posnr_c }| ).

      IF <ls_vbap>-vcm_chain_uuid IS NOT INITIAL OR
          <ls_vbap>-vcm_chain_category IS NOT INITIAL.

        me->mo_run_environment->append_log( iv_log_statement = |Error: VCM data not empty. Value chain category { <ls_vbap>-vcm_chain_category } or UUID filled| ).
        lv_error_occurred = abap_true.
        CONTINUE.
      ENDIF.
    ENDLOOP.

    IF lv_error_occurred = abap_true.
      " at least one item has an error
      me->mo_run_environment->append_log( iv_log_statement = |Error occurred. Details see in log above| ).

    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |Success: VCM was not triggered for any item| ).
      ev_check_status = abap_true.
      ev_execution_status = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD check_ic_wait_for_po3.

    DATA ls_testdata        TYPE ty_gs_ptf_or_check_ic_rpts_td.
    DATA lv_idle_seconds    TYPE i.
    DATA lv_max_repeats     TYPE i.
    DATA lv_break_seconds   TYPE i.
    DATA lv_attempts_max    TYPE i.
    DATA lv_attempts_act    TYPE i.
    DATA lv_waiting_time    TYPE i.
    DATA lt_vbeln           TYPE cl_ptf_util=>ty_vbeln_tab.
    DATA lt_sales_key       TYPE STANDARD TABLE OF sales_key.
    DATA lo_vcm_app_query   TYPE REF TO cl_vcm_app_query.
    DATA lo_vcm_integration TYPE REF TO cl_sd_sls_vcm_integration.
    DATA lo_vcm_item        TYPE REF TO if_vcm_value_chain_item_read.
    DATA lt_vbap            TYPE vbap_tab.
    DATA lv_vbeln           TYPE vbeln.
    DATA ls_vbak            TYPE vbak.
    DATA lv_vbeln_c         TYPE string.
    DATA lv_posnr_c         TYPE string.
    DATA lv_first_ic_item   TYPE abap_bool.
    DATA lv_error_occurred  TYPE abap_bool.
    DATA lv_ic_relevant     TYPE abap_bool.
    DATA ls_sdsls_doc_vcm   TYPE if_sd_dbsel_cust=>tcs_sdsls_doc_vcm.
    DATA lv_vcm_bo_id       TYPE vcm_business_object_id.
    DATA lv_vcm_bo_item_id  TYPE vcm_business_object_item_id.
    DATA lt_vcm_item        TYPE if_vcm_value_chain_item_read=>tt_item_tuple.
    DATA ls_so_po_item_key  TYPE ty_s_so_po_item_key.
    DATA ls_document_id     TYPE cl_ptf_util=>ty_vbeln.

    FIELD-SYMBOLS <ls_vbap> TYPE vbap.


    ev_check_status       = abap_false.
    ev_execution_status   = abap_false.

    " get variant parameters from the testdata container data
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = is_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).
    lv_idle_seconds  = ls_testdata-idle_seconds.  " Number of Idle Seconds Before Start
    lv_max_repeats   = ls_testdata-max_repeats.   " Maximum Number of Repeats
    lv_break_seconds = ls_testdata-break_seconds. " Number of Seconds Between Repeats

    lv_attempts_max  = 1 + lv_max_repeats.  " Maximum Number of Attempts = (first try) + (repeats)

    " write parameter values into log
    me->mo_run_environment->append_log( iv_log_statement = |Parameter: Idle seconds before start: { lv_idle_seconds }| ).
    me->mo_run_environment->append_log( iv_log_statement = |Parameter: Maximum number of repeats: { lv_max_repeats }| ).
    me->mo_run_environment->append_log( iv_log_statement = |Parameter: Number of seconds between repeats: { lv_break_seconds }| ).

    " get SO(2)
    LOOP AT is_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      lt_vbeln = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_vbeln TO lt_sales_key.
    ENDLOOP.

    READ TABLE lt_vbeln ASSIGNING FIELD-SYMBOL(<ls_vbeln>) INDEX 1.
    IF <ls_vbeln> IS NOT ASSIGNED.
      me->mo_run_environment->append_log( iv_log_statement = |Error: SO(2) not found in reference step| ).
      RETURN.
    ENDIF.

    DATA(lo_sd_sls_ic_utility) = cl_sd_sls_ic_factory=>so_instance->get_instance_util( ).
    lo_vcm_app_query ?= cl_vcm_app_query=>get_instance( ).
    lo_vcm_integration ?= cl_sd_sls_vcm_factory=>so_instance->get_instance_vcm_integration( ).

    " get link to PO(3) for every ICO relevant item
    CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
      TABLES
        it_vbak_key           = lt_sales_key
        et_vbap               = lt_vbap
      EXCEPTIONS
        records_not_found     = 1
        records_not_requested = 2
        OTHERS                = 3.
    IF sy-subrc <> 0.
      lv_vbeln_c = <ls_vbeln>-vbeln.
      SHIFT lv_vbeln_c LEFT DELETING LEADING '0'.
      me->mo_run_environment->append_log( iv_log_statement = |Error: No items found in SO(2) { lv_vbeln_c }| ).
      RETURN.
    ENDIF.

    lv_vbeln = <ls_vbeln>-vbeln.
    CALL FUNCTION 'SD_VBAK_SINGLE_READ'
      EXPORTING
        i_vbeln          = lv_vbeln
      IMPORTING
        e_vbak           = ls_vbak
      EXCEPTIONS
        record_not_found = 1
        OTHERS           = 2.

    IF sy-subrc <> 0.
      lv_vbeln_c = <ls_vbeln>-vbeln.
      SHIFT lv_vbeln_c LEFT DELETING LEADING '0'.
      me->mo_run_environment->append_log( iv_log_statement = |Error: SO(2) not found { lv_vbeln_c }| ).
      RETURN.
    ENDIF.

    lv_first_ic_item = abap_undefined.
    lv_error_occurred = abap_false.

    LOOP AT lt_vbap ASSIGNING <ls_vbap>.

      " previous ICO relevant item was the first
      IF lv_first_ic_item = abap_true.
        lv_first_ic_item = abap_false.
      ENDIF.

      lv_vbeln_c = <ls_vbap>-vbeln.
      SHIFT lv_vbeln_c LEFT DELETING LEADING '0'.
      lv_posnr_c = <ls_vbap>-posnr.
      SHIFT lv_posnr_c LEFT DELETING LEADING '0'.

      me->mo_run_environment->append_log( iv_log_statement = |Processing document { lv_vbeln_c } item { lv_posnr_c }| ).
      TRY.
          lv_ic_relevant = lo_sd_sls_ic_utility->is_item_ic_relevant(
            EXPORTING
              iv_vbeln = <ls_vbap>-vbeln
              iv_posnr = <ls_vbap>-posnr
          ).
        CATCH cx_sd_doc_not_found. " SD document cannot be found
          me->mo_run_environment->append_log( iv_log_statement = |Error: ICO relevance cannot be determined| ).
          lv_error_occurred = abap_true.
          CONTINUE.
      ENDTRY.

      IF lv_ic_relevant = abap_true.

        IF lv_first_ic_item = abap_undefined.
          lv_first_ic_item = abap_true.

          " before processing the first ICO relevant item, wait for PO(3) to be created
          WAIT UP TO lv_idle_seconds SECONDS.
          lv_waiting_time = lv_waiting_time + lv_idle_seconds.
        ENDIF.

        " get value chain from configuration data
        lo_vcm_integration->if_sd_sls_vcm_integration~get_doc_vcm_for_category(
          EXPORTING
            iv_auart         = ls_vbak-auart
            iv_pstyv         = <ls_vbap>-pstyv
            iv_vcm_category  = if_sd_sls_vcm_integration_c=>co_vcm_cat_ic_sales
          IMPORTING
            es_sdsls_doc_vcm = ls_sdsls_doc_vcm
        ).

        IF ls_sdsls_doc_vcm IS INITIAL.
          " ICO relevant item but no configuration
          me->mo_run_environment->append_log( iv_log_statement = |Error: configuration data for document type { ls_vbak-auart } and item category { <ls_vbap>-pstyv } does not exist| ).
          lv_error_occurred = abap_true.
          CONTINUE.
        ELSE.

          IF lv_first_ic_item = abap_undefined.
            lv_first_ic_item = abap_true.

            " before processing the first ICO relevant item, wait for PO(3) to be created
            WAIT UP TO lv_idle_seconds SECONDS.
            lv_waiting_time = lv_idle_seconds.
          ENDIF.

          lv_attempts_act = 0.

          DO lv_attempts_max TIMES.

            lv_attempts_act = lv_attempts_act + 1.

            " get the item data from VCM
            lv_vcm_bo_id = <ls_vbap>-vbeln.
            lv_vcm_bo_item_id = <ls_vbap>-posnr.
            TRY.
                lo_vcm_item = lo_vcm_app_query->if_vcm_app_query~get_value_chain_item(
                  value_chain_type        = ls_sdsls_doc_vcm-value_chain_type
                  step_type               = 'SOSC'
                  business_object_id      = lv_vcm_bo_id
                  business_object_item_id = lv_vcm_bo_item_id
                ).

                lt_vcm_item = lo_vcm_item->get_business_object_items( ).

                READ TABLE lt_vcm_item ASSIGNING FIELD-SYMBOL(<ls_po_data>)
                  WITH KEY item-step_type = 'POIC'
                           item-cancelled = abap_false
                           item-deleted   = abap_false.

              CATCH cx_vcm_rt_not_exists.
                " don't try to re-read any data
                lv_first_ic_item = abap_false.
                me->mo_run_environment->append_log( iv_log_statement = |Error reading VCM data| ).
                lv_error_occurred = abap_true.
                EXIT.
            ENDTRY.


            IF lt_vcm_item IS INITIAL OR <ls_po_data> IS NOT ASSIGNED.

              IF lv_first_ic_item = abap_true.
                me->mo_run_environment->append_log( iv_log_statement = |PO(3) not yet created. Seconds elapsed: { lv_waiting_time }| ).

                " wait and repeat reading
                WAIT UP TO lv_break_seconds SECONDS.
                lv_waiting_time = lv_waiting_time + lv_break_seconds.

              ELSE.
                me->mo_run_environment->append_log( iv_log_statement = |Error: no VCM data for item { lv_posnr_c } with item category { <ls_vbap>-pstyv }| ).

                " wait and repeat only for first item - afterwards, the other items should exist
                lv_error_occurred = abap_true.
                EXIT.
              ENDIF.
            ELSE.
              " PO data found
              ls_so_po_item_key-vbeln = <ls_po_data>-predecessor-object_id.
              ls_so_po_item_key-posnr = <ls_po_data>-predecessor-item_id.
              ls_so_po_item_key-ebeln = <ls_po_data>-item-object_id.
              ls_so_po_item_key-ebelp = <ls_po_data>-item-item_id.
              ls_document_id-vbeln = ls_so_po_item_key.
              INSERT ls_document_id INTO TABLE et_document_id.
              EXIT.
            ENDIF.

            UNASSIGN <ls_po_data>.
          ENDDO.

          IF lv_first_ic_item = abap_true.
            me->mo_run_environment->append_log( iv_log_statement = |Actual number of attempts to read the VCM data: { lv_attempts_act }| ).
            me->mo_run_environment->append_log( iv_log_statement = |Total waiting time in seconds: { lv_waiting_time }| ).
          ENDIF.

        ENDIF. " read configuration data
      ENDIF. " ICO relevant item
    ENDLOOP. "items

    IF lv_error_occurred = abap_true.
      " at least one item has an error
      me->mo_run_environment->append_log( iv_log_statement = |Error occurred. Details see in log above| ).

    ELSEIF lv_first_ic_item = abap_undefined.
      " SO(2) does not contain any ICO relevant items
      me->mo_run_environment->append_log( iv_log_statement = |Error: no ICO relevant item in SO(2)| ).

    ELSE.
      " success
      me->mo_run_environment->append_log( iv_log_statement = |Success: PO exists for all ICO relevant items| ).
      ev_check_status = abap_true.
      ev_execution_status = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD check_ic_wait_for_so4.

    DATA:
      ls_testdata      TYPE ty_gs_ptf_or_check_ic_rpts_td,
      lv_attempts_max  TYPE tb_attempts,  " maximumnumber of attempts
      lv_attempts_act  TYPE tb_attempts,  " actual attempts
      lv_waiting_time  TYPE s_mec_cputest_break_seconds,
      lv_idle_seconds  TYPE s_mec_cputest_break_seconds,  " Idle Seconds Before Start
      lv_max_repeats   TYPE /aif/repeat_counter,  " Maximum Number of Repeats
      lv_break_seconds TYPE s_mec_cputest_break_seconds,  " Break Seconds Between Repeats
      lt_vbeln         TYPE cl_ptf_util=>ty_vbeln_tab,
      lv_vbeln         TYPE vbeln_va,
      lt_sales_key     TYPE TABLE OF sales_key,
      lt_so2_item_key  TYPE if_vcm_value_chain_item_read=>tt_bo_item,
      ls_so2_item_key  LIKE LINE OF lt_so2_item_key,
      lt_vbap          TYPE TABLE OF vbap,
      lv_ic_relevant   TYPE boole_d,
      lv_ic_item_found TYPE boole_d,
      lv_no_so4        TYPE boole_d,
      lv_number(5)     TYPE c,
      lv_statement     TYPE bapi_msg
      .
    FIELD-SYMBOLS:
      <ls_vbap> TYPE vbap
      .

* get variant parameters from the testdata container data
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).
    lv_idle_seconds = ls_testdata-idle_seconds.  "  Number of Idle Seconds Before Start
    lv_max_repeats   = ls_testdata-max_repeats.  " Maximum Number of Repeats
    lv_break_seconds = ls_testdata-break_seconds.  " Number of Seconds Between Repeats

    lv_attempts_max  = 1 + lv_max_repeats.  " Maximum Number of Attempts = (first try) + (repeats)

* write parameter values into log
    lv_statement = 'Parameter: Idle Seconds Before Start: &1'.
    lv_number = lv_idle_seconds.
    REPLACE '&1' IN lv_statement WITH lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

    lv_statement = 'Parameter: Maximum number of repeats: &1'.
    lv_number = lv_max_repeats.
    REPLACE '&1' IN lv_statement WITH lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

    lv_statement = 'Parameter: Number of seconds between repeats: &1'.
    lv_number = lv_break_seconds.
    REPLACE '&1' IN lv_statement WITH lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

* get SO2
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
      APPEND LINES OF lt_ptf_keys TO lt_sales_key.
    ENDLOOP.
    CLEAR lv_vbeln.
    READ TABLE lt_vbeln INTO lv_vbeln INDEX 1.
    IF lv_vbeln IS INITIAL.
      lv_statement = 'Error: No SO2 order found.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      RETURN. " check fails
    ENDIF.


* Idle Seconds Before Start: wait for PO3 + SO4 to be created
    WAIT UP TO lv_idle_seconds SECONDS.


    DATA(lo_sd_sls_ic_utility) = cl_sd_sls_ic_factory=>so_instance->get_instance_util( ).

    " get link to PO/SO
    CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
      TABLES
        it_vbak_key           = lt_sales_key
*       ET_VBAPVB             =
        et_vbap               = lt_vbap
      EXCEPTIONS
        records_not_found     = 1
        records_not_requested = 2
        OTHERS                = 3.
    IF sy-subrc <> 0.
      lv_statement = 'Error: No items found in SO2 order &1'.
      REPLACE '&1' IN lv_statement WITH lv_vbeln.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      RETURN. " check fails
    ENDIF.

    LOOP AT lt_vbap ASSIGNING <ls_vbap>.
      ls_so2_item_key-object_id = <ls_vbap>-vbeln.
      ls_so2_item_key-item_id   = <ls_vbap>-posnr.
      ls_so2_item_key-step_type = 'SOSC'.
      APPEND ls_so2_item_key TO lt_so2_item_key.
    ENDLOOP.

    CLEAR lv_attempts_act.

    DO lv_attempts_max TIMES.
      ADD 1 TO lv_attempts_act.

      SELECT *
        FROM vcm_rt_bo_item AS itema
        INNER JOIN vcm_rt_bo_item AS itemb ON itema~value_chain_ins_guid = itemb~value_chain_ins_guid AND
                                              itema~value_chain_item_guid = itemb~value_chain_item_guid " [SG+]
        LEFT OUTER JOIN vcm_rt_step_ins AS step ON itemb~step_ins_guid = step~guid
        LEFT OUTER JOIN vcm_rt_chain_ins AS chain ON itemb~value_chain_ins_guid = chain~guid
        INTO TABLE @DATA(lt_vcm_item)
        WHERE itema~business_object_id = @lv_vbeln
         AND itema~business_object = 'SALES_ORDER'
         AND itema~deleted   = @space                                                                   " [SG+]
         AND itema~cancelled = @space                                                                   " [SG+]
         AND itemb~deleted   = @space                                                                   " [SG+]
         AND itemb~cancelled = @space                                                                   " [SG+]
         AND step~step_type = 'SOIC'
         AND ( chain~status = 'C' OR chain~status = 'E' OR chain~status = 'O' OR chain~status = 'PD' ).

      IF lt_vcm_item IS INITIAL.
        ADD lv_break_seconds TO lv_waiting_time.
        WAIT UP TO lv_break_seconds SECONDS.
      ELSE.
        lv_no_so4 = abap_false.
        LOOP AT lt_vcm_item ASSIGNING FIELD-SYMBOL(<ls_item_link>).
          IF <ls_item_link>-itemb IS INITIAL.
            lv_no_so4 = abap_true.
          ENDIF.
        ENDLOOP.  " at lt_vcm_item assigning field-symbol(<ls_item_link>)
***
        IF lv_no_so4 EQ abap_true.
          ADD lv_break_seconds TO lv_waiting_time.
          WAIT UP TO lv_break_seconds SECONDS.
        ELSE.
*          lv_statement = 'Actual number of attempts to read the VCM item link: &1'.
*          lv_number = sy-index.
*          REPLACE '&1' IN lv_statement WITH lv_number.
*          me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
*
*          lv_statement = 'Total waiting time: &1'.
*          lv_number = lv_waiting_time.
*          REPLACE '&1' IN lv_statement WITH lv_number.
*          me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

          EXIT.
        ENDIF.   " IF lv_no_so4 NE abap_true
      ENDIF.
    ENDDO.

    lv_statement = 'Actual number of attempts to read the VCM item link: &1'.
    lv_number = lv_attempts_act.
    REPLACE '&1' IN lv_statement WITH lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

    lv_statement = 'Total waiting time: &1 seconds'.
    lv_number = lv_waiting_time.
    REPLACE '&1' IN lv_statement WITH lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).


    IF lv_no_so4 EQ abap_false.
* write the created SO4 into the output log
      LOOP AT lt_vcm_item ASSIGNING <ls_item_link>.

        lv_statement = 'SO4 order: OBJECT &1 , ITEM &2'.
        REPLACE '&1' IN lv_statement WITH <ls_item_link>-itemb-business_object_id.
        REPLACE '&2' IN lv_statement WITH <ls_item_link>-itemb-business_object_item_id.
        me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

      ENDLOOP.
    ENDIF.


    IF lt_vcm_item IS INITIAL  OR
       lv_no_so4    EQ abap_true.
      lv_statement = 'Error: No SO4 was found'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      RETURN.
    ENDIF.

* set PTF method result
* we assume that at least 1 SO2 item must be IC-relevant
* for each IC-relevant item in SO2, a corresponding link to SO4 must exist!
    LOOP AT lt_vbap   ASSIGNING <ls_vbap>.

      TRY.
          lo_sd_sls_ic_utility->is_item_ic_relevant(
            EXPORTING
              iv_vbeln             = <ls_vbap>-vbeln
              iv_posnr             = <ls_vbap>-posnr
            RECEIVING
              rv_ic_relevance_item = lv_ic_relevant
          ).
        CATCH cx_sd_doc_not_found. " SD document cannot be found
          me->mo_run_environment->append_log( iv_log_statement = 'Error to determine IC relevance' ).
          RETURN. " failure!
      ENDTRY.
      IF lv_ic_relevant = abap_true.
        READ TABLE lt_vcm_item ASSIGNING <ls_item_link>
          WITH KEY
            itema-business_object_id = <ls_vbap>-vbeln
            itema-business_object_item_id   = <ls_vbap>-posnr.
        IF sy-subrc <> 0.
          me->mo_run_environment->append_log( iv_log_statement = 'Error to read SO2 items' ).
          RETURN. " failure!
        ENDIF.
        IF <ls_item_link>-itemb-business_object_id IS INITIAL OR
           <ls_item_link>-itemb-business_object_item_id   IS INITIAL.
          me->mo_run_environment->append_log( iv_log_statement = 'Error: No SO4 item number found' ).
          RETURN. " failure!
        ENDIF.
        " success: at least 1 IC item found!
        lv_ic_item_found = abap_true.
      ENDIF.
    ENDLOOP.

    " success?
    IF lv_ic_item_found = abap_true.
      me->mo_run_environment->append_log( iv_log_statement =
                                                             'Success: 1) At least 1 IC relevant item processed. 2) All IC relevant items have assigned SO4 item' ).
      ev_check_status = abap_true.
      ev_execution_status = abap_true.
      IF line_exists( lt_vcm_item[ 1 ] ).
        APPEND lt_vcm_item[ 1 ]-itemb-business_object_id TO ev_document_id.
      ENDIF.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement =
                                                             'Error: No IC relevant item found, or some IC relevant item does not have SO4 counterpart' ).
    ENDIF.



  ENDMETHOD.


  METHOD check_item_bpl_created_goal.
    DATA: lt_doc_ids TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings,
          lo_access           TYPE REF TO if_goal_access,
          ls_error            TYPE if_goal_types=>tcs_error,
          lx_goal_exc         TYPE REF TO cx_goal_exc,
          lv_text_exc         TYPE string,
          lv_field            TYPE fieldname,
          ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
          lt_changed_field    TYPE if_goal_types=>tct_changed_field,
          lv_statement        TYPE bapi_msg.

    DATA: lv_bo_key         TYPE if_goal_types=>tcd_bo_key,
          lt_item_data      TYPE STANDARD TABLE OF tds_goal_so_item,
          ls_head_data      TYPE tds_goal_so_head,
          ls_i_bplh_data    TYPE tds_goal_sdoc_bplh,
          ls_i_bpli_data    TYPE tds_goal_sdoc_bpli,
          lt_i_bpli_data    TYPE STANDARD TABLE OF tds_goal_sdoc_bpli,
          billing_plan_data TYPE ty_billing_plan.

    ev_check_status = abap_false.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = billing_plan_data ).

* 1 Step: get previously step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_doc_ids.
    ENDLOOP.

    READ TABLE lt_doc_ids INTO DATA(ls_doc_id) INDEX 1.
    IF sy-subrc = 0.
      lv_bo_key = ls_doc_id-vbeln.
    ENDIF.

    CHECK NOT lv_bo_key IS INITIAL.

* 2 Step: Access sales order via GOAL
* ===================================================
* open the document in change mode
* ===================================================
    TRY.
        CALL METHOD cl_goal_api=>so_instance->open
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_bo_key
            iv_read_only        = abap_true
            is_control_settings = ls_control_settings
          RECEIVING
            ro_access           = lo_access.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read header data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id   = if_goal_sdoc_head=>co_entity_id
          IMPORTING
            es_entity_data = ls_head_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read item data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id   = if_goal_sdoc_item=>co_entity_id
          IMPORTING
            et_entity_data = lt_item_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read item billing plan header
* ===================================================
    READ TABLE lt_item_data INTO DATA(ls_item_data) INDEX 1.
    CHECK sy-subrc = 0.
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bplh
            iv_handle_parent = ls_item_data-handle
          IMPORTING
            es_entity_data   = ls_i_bplh_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* get item billing plan items
* ===================================================
    CHECK NOT ls_i_bplh_data IS INITIAL.

    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bpli
            iv_handle_parent = ls_i_bplh_data-handle
          IMPORTING
            et_entity_data   = lt_i_bpli_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.

    lo_access->get_messages( IMPORTING et_message = DATA(lt_message)
                                       es_error   = ls_error ).
    IF NOT ls_error IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = ls_error-msgtx ).
      lo_access->close( ).
      EXIT.
    ELSE.
      lo_access->close( ).
    ENDIF.

    " Check billing plan items are same as TDC
    IF lines( lt_i_bpli_data[] ) <> lines( billing_plan_data-fplt[] ).
      lv_statement = 'Error:Create item level billing plan dates failed!'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      EXIT.
    ENDIF.

    lv_statement = 'Success: Create item level billing plan dates successfully!'.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ev_check_status = abap_true.
  ENDMETHOD.


  METHOD check_item_bpl_deleted_goal.
    DATA: lt_doc_ids TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings,
          lo_access           TYPE REF TO if_goal_access,
          ls_error            TYPE if_goal_types=>tcs_error,
          lx_goal_exc         TYPE REF TO cx_goal_exc,
          lv_text_exc         TYPE string,
          lv_field            TYPE fieldname,
          ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
          lt_changed_field    TYPE if_goal_types=>tct_changed_field,
          lv_statement        TYPE bapi_msg.

    DATA: lv_bo_key      TYPE if_goal_types=>tcd_bo_key,
          lt_item_data   TYPE STANDARD TABLE OF tds_goal_so_item,
          ls_head_data   TYPE tds_goal_so_head,
          ls_i_bplh_data TYPE tds_goal_sdoc_bplh,
          ls_i_bpli_data TYPE tds_goal_sdoc_bpli,
          lt_i_bpli_data TYPE STANDARD TABLE OF tds_goal_sdoc_bpli.

    ev_check_status = abap_false.

* 1 Step: get previously step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_doc_ids.
    ENDLOOP.

    READ TABLE lt_doc_ids INTO DATA(ls_doc_id) INDEX 1.
    IF sy-subrc = 0.
      lv_bo_key = ls_doc_id-vbeln.
    ENDIF.

    CHECK NOT lv_bo_key IS INITIAL.

* 2 Step: Access sales order via GOAL
* ===================================================
* open the document in change mode
* ===================================================
    TRY.
        CALL METHOD cl_goal_api=>so_instance->open
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_bo_key
            iv_read_only        = abap_true
            is_control_settings = ls_control_settings
          RECEIVING
            ro_access           = lo_access.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read header data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id   = if_goal_sdoc_head=>co_entity_id
          IMPORTING
            es_entity_data = ls_head_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* read item data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id   = if_goal_sdoc_item=>co_entity_id
          IMPORTING
            et_entity_data = lt_item_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* read item billing plan header
* ===================================================
    READ TABLE lt_item_data INTO DATA(ls_item_data) INDEX 1.
    CHECK sy-subrc = 0.
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bplh
            iv_handle_parent = ls_item_data-handle
          IMPORTING
            es_entity_data   = ls_i_bplh_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* get item billing plan items
* ===================================================
    CHECK NOT ls_i_bplh_data IS INITIAL.

    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bpli
            iv_handle_parent = ls_i_bplh_data-handle
          IMPORTING
            et_entity_data   = lt_i_bpli_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* check billing plan is header referenced, or deleted
* ===================================================
    IF ls_i_bplh_data-head_assignment_ind IS INITIAL AND lines( lt_i_bpli_data ) > 0.
      lo_access->close( ).
      lv_statement = 'Error:Delete billing plan dates failed!'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      EXIT.
    ENDIF.

    lo_access->get_messages( IMPORTING et_message = DATA(lt_message)
                                       es_error   = ls_error ).
    IF NOT ls_error IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = ls_error-msgtx ).
      lo_access->close( ).
      EXIT.
    ELSE.
      lo_access->close( ).
    ENDIF.

    lv_statement = 'Success: Item level billing plan dates deleted successfully!'.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ev_check_status = abap_true.
  ENDMETHOD.


  METHOD check_item_bpl_updated_goal.
    DATA: lt_doc_ids TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings,
          lo_access           TYPE REF TO if_goal_access,
          ls_error            TYPE if_goal_types=>tcs_error,
          lx_goal_exc         TYPE REF TO cx_goal_exc,
          lv_text_exc         TYPE string,
          lv_field            TYPE fieldname,
          ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
          lt_changed_field    TYPE if_goal_types=>tct_changed_field,
          lv_statement        TYPE bapi_msg.

    DATA: lv_bo_key      TYPE if_goal_types=>tcd_bo_key,
          lt_item_data   TYPE STANDARD TABLE OF tds_goal_so_item,
          ls_head_data   TYPE tds_goal_so_head,
          ls_i_bplh_data TYPE tds_goal_sdoc_bplh,
          ls_i_bpli_data TYPE tds_goal_sdoc_bpli,
          lt_i_bpli_data TYPE STANDARD TABLE OF tds_goal_sdoc_bpli.

    DATA: lv_date  TYPE fkdat,
          lv_error TYPE abap_bool.

    lv_date = sy-datum + 1.
    ev_check_status = abap_false.

* 1 Step: get previously step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_doc_ids.
    ENDLOOP.

    READ TABLE lt_doc_ids INTO DATA(ls_doc_id) INDEX 1.
    IF sy-subrc = 0.
      lv_bo_key = ls_doc_id-vbeln.
    ENDIF.

    CHECK NOT lv_bo_key IS INITIAL.

* 2 Step: Access sales order via GOAL
* ===================================================
* open the document in change mode
* ===================================================
    TRY.
        CALL METHOD cl_goal_api=>so_instance->open
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_bo_key
            iv_read_only        = abap_true
            is_control_settings = ls_control_settings
          RECEIVING
            ro_access           = lo_access.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read header data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id   = if_goal_sdoc_head=>co_entity_id
          IMPORTING
            es_entity_data = ls_head_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* read item data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id   = if_goal_sdoc_item=>co_entity_id
          IMPORTING
            et_entity_data = lt_item_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* read item billing plan header
* ===================================================
    READ TABLE lt_item_data INTO DATA(ls_item_data) INDEX 1.
    CHECK sy-subrc = 0.
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bplh
            iv_handle_parent = ls_item_data-handle
          IMPORTING
            es_entity_data   = ls_i_bplh_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* get item billing plan items
* ===================================================
    CHECK NOT ls_i_bplh_data IS INITIAL.

    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bpli
            iv_handle_parent = ls_i_bplh_data-handle
          IMPORTING
            et_entity_data   = lt_i_bpli_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* check billing plan was updated
* ===================================================
    LOOP AT lt_i_bpli_data INTO ls_i_bpli_data.
      IF ls_i_bpli_data-billing_date <> lv_date.
        lv_statement = 'Error:Update billing plan dates failed!'.
        me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
        lv_error = abap_true.
        EXIT.
      ENDIF.
    ENDLOOP.

    lo_access->get_messages( IMPORTING et_message = DATA(lt_message)
                                       es_error   = ls_error ).
    IF NOT ls_error IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = ls_error-msgtx ).
      lo_access->close( ).
      EXIT.
    ELSE.
      lo_access->close( ).
    ENDIF.

    CHECK lv_error = abap_false.

    lv_statement = 'Success: Item level billing plan dates updated successfully!'.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ev_check_status = abap_true.
  ENDMETHOD.


  METHOD check_item_bp_exist.
    DATA: lt_doc_ids TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings,
          lo_access           TYPE REF TO if_goal_access,
          ls_error            TYPE if_goal_types=>tcs_error,
          lx_goal_exc         TYPE REF TO cx_goal_exc,
          lv_text_exc         TYPE string,
          lv_field            TYPE fieldname,
          ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
          lt_changed_field    TYPE if_goal_types=>tct_changed_field,
          lv_statement        TYPE bapi_msg.

    DATA: lv_bo_key      TYPE if_goal_types=>tcd_bo_key,
          lt_item_data   TYPE STANDARD TABLE OF tds_goal_so_item,
          ls_head_data   TYPE tds_goal_so_head,
          ls_i_bplh_data TYPE tds_goal_sdoc_bplh,
          ls_i_bpli_data TYPE tds_goal_sdoc_bpli,
          lt_i_bpli_data TYPE STANDARD TABLE OF tds_goal_sdoc_bpli.

    ev_check_status = abap_false.



* 1 Step: get previously step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_doc_ids.
    ENDLOOP.

    READ TABLE lt_doc_ids INTO DATA(ls_doc_id) INDEX 1.
    IF sy-subrc = 0.
      lv_bo_key = ls_doc_id-vbeln.
    ENDIF.

    CHECK NOT lv_bo_key IS INITIAL.

* 2 Step: Access sales order via GOAL
* ===================================================
* open the document in change mode
* ===================================================
    TRY.
        CALL METHOD cl_goal_api=>so_instance->open
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_bo_key
            iv_read_only        = abap_true
            is_control_settings = ls_control_settings
          RECEIVING
            ro_access           = lo_access.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read header data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id   = if_goal_sdoc_head=>co_entity_id
          IMPORTING
            es_entity_data = ls_head_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read item data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id   = if_goal_sdoc_item=>co_entity_id
          IMPORTING
            et_entity_data = lt_item_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read item billing plan header
* ===================================================
    READ TABLE lt_item_data INTO DATA(ls_item_data) INDEX 1.
    CHECK sy-subrc = 0.
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bplh
            iv_handle_parent = ls_item_data-handle
          IMPORTING
            es_entity_data   = ls_i_bplh_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* get item billing plan items
* ===================================================
    CHECK NOT ls_i_bplh_data IS INITIAL.

    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bpli
            iv_handle_parent = ls_i_bplh_data-handle
          IMPORTING
            et_entity_data   = lt_i_bpli_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.

    lo_access->get_messages( IMPORTING et_message = DATA(lt_message)
                                       es_error   = ls_error ).
    IF NOT ls_error IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = ls_error-msgtx ).
      lo_access->close( ).
      EXIT.
    ELSE.
      lo_access->close( ).
    ENDIF.

    " Check billing plan items are same as TDC
    IF lines( lt_i_bpli_data[] ) EQ 0.
      lv_statement = 'Error: item level billing plan not exist!'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      EXIT.
    ENDIF.

    lv_statement = 'Success: item level billing plan dates exist'.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ev_check_status = abap_true.
  ENDMETHOD.


  METHOD check_item_bp_not_exist.
    DATA: lt_doc_ids TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings,
          lo_access           TYPE REF TO if_goal_access,
          ls_error            TYPE if_goal_types=>tcs_error,
          lx_goal_exc         TYPE REF TO cx_goal_exc,
          lv_text_exc         TYPE string,
          lv_field            TYPE fieldname,
          ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
          lt_changed_field    TYPE if_goal_types=>tct_changed_field,
          lv_statement        TYPE bapi_msg.

    DATA: lv_bo_key      TYPE if_goal_types=>tcd_bo_key,
          lt_item_data   TYPE STANDARD TABLE OF tds_goal_so_item,
          ls_head_data   TYPE tds_goal_so_head,
          ls_i_bplh_data TYPE tds_goal_sdoc_bplh,
          ls_i_bpli_data TYPE tds_goal_sdoc_bpli,
          lt_i_bpli_data TYPE STANDARD TABLE OF tds_goal_sdoc_bpli.

    ev_check_status = abap_false.



* 1 Step: get previously step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_doc_ids.
    ENDLOOP.

    READ TABLE lt_doc_ids INTO DATA(ls_doc_id) INDEX 1.
    IF sy-subrc = 0.
      lv_bo_key = ls_doc_id-vbeln.
    ENDIF.

    CHECK NOT lv_bo_key IS INITIAL.

* 2 Step: Access sales order via GOAL
* ===================================================
* open the document in change mode
* ===================================================
    TRY.
        CALL METHOD cl_goal_api=>so_instance->open
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_bo_key
            iv_read_only        = abap_true
            is_control_settings = ls_control_settings
          RECEIVING
            ro_access           = lo_access.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read header data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id   = if_goal_sdoc_head=>co_entity_id
          IMPORTING
            es_entity_data = ls_head_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read item data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id   = if_goal_sdoc_item=>co_entity_id
          IMPORTING
            et_entity_data = lt_item_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read item billing plan header
* ===================================================
    READ TABLE lt_item_data INTO DATA(ls_item_data) INDEX 1.
    CHECK sy-subrc = 0.
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bplh
            iv_handle_parent = ls_item_data-handle
          IMPORTING
            es_entity_data   = ls_i_bplh_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lv_statement = 'Success: item level billing plan not exist!'.
        me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
        ev_check_status = abap_true.
        EXIT.
    ENDTRY.
* ===================================================
* get item billing plan items
* ===================================================


    " Check billing plan items are same as TDC
    IF NOT ls_i_bplh_data IS INITIAL.
      lv_statement = 'Error: item level billing plan dates exist'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      EXIT.
    ENDIF.

    lv_statement = 'Success: item level billing plan not exist!'.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ev_check_status = abap_true.
  ENDMETHOD.


  METHOD check_partner.
    DATA: test_data TYPE ty_gs_ptf_sd_check_partner_td.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = test_data
    ).

    ev_check_status = abap_true.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(doc_ids)  = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).

      LOOP AT doc_ids ASSIGNING FIELD-SYMBOL(<doc>).
        LOOP AT test_data-partner ASSIGNING FIELD-SYMBOL(<partner>).
          IF <partner>-item_number IS NOT INITIAL.
            SELECT SINGLE vbeln, posnr, parvw FROM vbpa  INTO @DATA(entry_pos) WHERE vbeln = @<doc>-vbeln AND posnr = @<partner>-item_number AND kunnr = @<partner>-customer AND parvw = @<partner>-role.
          ELSE.
            SELECT SINGLE vbeln, posnr, parvw FROM vbpa INTO @DATA(entry) WHERE vbeln = @<doc>-vbeln AND kunnr = @<partner>-customer AND parvw = @<partner>-role.
          ENDIF.
          IF sy-subrc <> 0.
            ev_check_status = abap_false.
            IF <partner>-item_number IS NOT INITIAL.
              me->mo_run_environment->append_log( iv_log_statement = |Partner { <partner>-role } { <partner>-customer } not found for SD { <doc>-vbeln } for position { <partner>-item_number }| ).
            ELSE.
              me->mo_run_environment->append_log( iv_log_statement = |Partner { <partner>-role } { <partner>-customer } not found for SD { <doc>-vbeln }| ).
            ENDIF.
          ENDIF."IF sy-subrc <> 0.
        ENDLOOP."LOOP AT test_data-partner ASSIGNING FIELD-SYMBOL(<partner>).
      ENDLOOP."LOOP AT doc_ids ASSIGNING FIELD-SYMBOL(<doc>).
    ENDLOOP."LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
    ev_execution_status = abap_true.
  ENDMETHOD.


  METHOD check_po.

    TYPES:
      BEGIN OF ty_s_po_data,
        ebeln             TYPE ebeln,
        po_header         TYPE mepoheader,
        po_items          TYPE mmpur_t_mepoitem,
        po_schedule_lines TYPE mmpur_t_po_schedules,
      END OF ty_s_po_data.

    TYPES: ty_t_po_data TYPE STANDARD TABLE OF ty_s_po_data.

    DATA lt_testdata        TYPE ty_gt_ptf_or_check_po_td.
    DATA ls_testdata        TYPE ty_gs_ptf_or_check_po_td.

    DATA ls_so_po_item_key  TYPE ty_s_so_po_item_key.
    " data lt_so_po_item_key  type ty_t_so_po_item_key.
    DATA lv_ebeln           TYPE ebeln.
    DATA lt_ebeln           TYPE STANDARD TABLE OF ebeln.
    DATA lv_ebeln_c         TYPE string.
    DATA lv_ebelp_c         TYPE string.
    DATA ls_po_data         TYPE ty_s_po_data.
    DATA lt_po_data         TYPE ty_t_po_data.
    DATA lv_error_occurred  TYPE abap_bool.

    ev_check_status       = abap_false.
    ev_execution_status   = abap_false.

    " get variant parameters from the testdata container data
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = is_step_data
      IMPORTING
        es_testdata  = lt_testdata
    ).
    DELETE lt_testdata WHERE po_header_check IS INITIAL AND po_item_check IS INITIAL.
    IF lt_testdata IS INITIAL.
      me->mo_run_environment->append_log( |No check data configured| ).
      RETURN.
    ENDIF.

    " the reference data contains the SO(2) / PO(3) item links from VCM
    LOOP AT is_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).

      LOOP AT lt_ptf_keys ASSIGNING FIELD-SYMBOL(<ls_ptf_key>).
        ls_so_po_item_key = <ls_ptf_key>.
        " insert ls_so_po_item_key into table lt_so_po_item_key.
        lv_ebeln = ls_so_po_item_key-ebeln.
        IF lv_ebeln IS NOT INITIAL.
          COLLECT lv_ebeln INTO lt_ebeln.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    IF lt_ebeln IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Error: Reference data contains no PO(3) data | ).
      RETURN.
    ENDIF.

    " get PO data
    LOOP AT lt_ebeln ASSIGNING FIELD-SYMBOL(<lv_ebeln>).
      CLEAR ls_po_data.
      ls_po_data-ebeln = <lv_ebeln>.

*    " refresh all internal buffers
*    cl_mm_po_handler_api=>close_po( ).

      cl_mm_po_handler_api=>if_mm_pur_po_convenience_api~get_po_by_id(
        EXPORTING
          iv_docno             = <lv_ebeln>
        IMPORTING
          es_po_header         = ls_po_data-po_header
          et_po_items          = ls_po_data-po_items
          et_po_schedule_lines = ls_po_data-po_schedule_lines
      ).

      lv_ebeln_c = <lv_ebeln>.
      SHIFT lv_ebeln_c LEFT DELETING LEADING '0'.

      IF ls_po_data-po_header IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |Error: No PO(3) data found for PO { lv_ebeln_c } | ).
        RETURN.
      ELSEIF ls_po_data-po_items IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |Error: No PO(3) item data found for PO { lv_ebeln_c } | ).
        RETURN.
      ELSE.
        INSERT ls_po_data INTO TABLE lt_po_data.
        APPEND <lv_ebeln> TO ev_document_id.
      ENDIF.
    ENDLOOP.

    " --------------------------------------- start to check PO -----
    lv_error_occurred = abap_false.

    DATA: lv_index_hd TYPE i,
          lv_index_it TYPE i,
          lv_index_sl TYPE i,
          lv_result   TYPE abap_bool.

    LOOP AT lt_testdata INTO ls_testdata.

      lv_index_hd = lv_index_hd + 1.

      " get corresponding PO data
      ASSIGN lt_po_data[ lv_index_hd ] TO FIELD-SYMBOL(<fs_po_data>).
      IF sy-subrc <> 0.
        EXIT.     " no more PO to be checked
      ENDIF.

      lv_ebeln_c = <fs_po_data>-po_header-ebeln.
      SHIFT lv_ebeln_c LEFT DELETING LEADING '0'.

      " --------------------------------------- check PO header -----
      IF ls_testdata-po_header_check IS NOT INITIAL.
        lv_result = compare_structure(
          io_run_environment = mo_run_environment
          is_check_parameter = ls_testdata-po_header_check
          is_expected        = ls_testdata-po_header
          is_actual          = <fs_po_data>-po_header
        ).

        IF lv_result = abap_true.
          me->mo_run_environment->append_log( |PO { lv_ebeln_c } header checked successfully| ).
        ELSE.
          me->mo_run_environment->append_log( |Error: PO { lv_ebeln_c } header checked with error| ).
          lv_error_occurred = abap_true.
          CONTINUE.
        ENDIF.

      ENDIF.


      " ----------------------------------------- check PO item -----
      CLEAR: lv_index_it.
      LOOP AT ls_testdata-po_item_check ASSIGNING FIELD-SYMBOL(<fs_po_item_check>).
        lv_index_it = lv_index_it + 1.
        IF <fs_po_item_check> IS INITIAL. " nothing configured to check this item
          CONTINUE.
        ENDIF.
        ASSIGN ls_testdata-po_item[ lv_index_it ] TO FIELD-SYMBOL(<fs_po_item_expected>).
        IF sy-subrc <> 0.
          CONTINUE.     " no more PO items in test data for this PO
        ENDIF.
        IF <fs_po_item_expected>-ebelp IS INITIAL.
          CONTINUE.
        ENDIF.
        lv_ebelp_c = <fs_po_item_expected>-ebelp.
        SHIFT lv_ebelp_c LEFT DELETING LEADING '0'.
        ASSIGN <fs_po_data>-po_items[ ebelp = <fs_po_item_expected>-ebelp ] TO FIELD-SYMBOL(<fs_po_item_actual>).
        IF sy-subrc <> 0.
          CONTINUE.     " no PO item exists for configured item number
        ENDIF.
        lv_result = compare_structure(
          io_run_environment = mo_run_environment
          is_check_parameter = <fs_po_item_check>
          is_expected        = <fs_po_item_expected>
          is_actual          = <fs_po_item_actual>
        ).
        IF lv_result = abap_true.
          me->mo_run_environment->append_log( |PO { lv_ebeln_c } item { lv_ebelp_c } | && |checked successfully| ).
        ELSE.
          me->mo_run_environment->append_log( |Error: PO item { lv_ebeln_c } { lv_ebelp_c } | && |checked with error| ).
          lv_error_occurred = abap_true.
          CONTINUE.
        ENDIF.
      ENDLOOP..

      CLEAR: lv_index_sl.
      LOOP AT ls_testdata-po_schedule_line_check ASSIGNING FIELD-SYMBOL(<fs_po_schedule_line_check>).
        IF <fs_po_schedule_line_check> IS INITIAL.
          CONTINUE.
        ENDIF.
        ASSIGN ls_testdata-po_schedule_line[ ebelp = <fs_po_schedule_line_check>-ebelp
                                             etenr = <fs_po_schedule_line_check>-etenr ]
               TO FIELD-SYMBOL(<fs_po_schedule_line_expected>).
        IF sy-subrc <> 0.
          CONTINUE.  " to be checked line not maintained in test data
        ENDIF.
        ASSIGN <fs_po_data>-po_schedule_lines[ ebelp = <fs_po_schedule_line_expected>-ebelp
                                               etenr = <fs_po_schedule_line_expected>-etenr ]
               TO FIELD-SYMBOL(<fs_po_schedule_line_actual>).
        IF sy-subrc <> 0.
          CONTINUE. " schedule line not exist
        ENDIF.
        lv_result = compare_structure(
          io_run_environment = mo_run_environment
          is_check_parameter = <fs_po_schedule_line_check>
          is_expected        = <fs_po_schedule_line_expected>
          is_actual          = <fs_po_schedule_line_actual>
        ).
        IF lv_result = abap_true.
          me->mo_run_environment->append_log( |PO { lv_ebeln_c } item { lv_ebelp_c } line { <fs_po_schedule_line_expected>-etenr } | && |checked successfully| ).
        ELSE.
          me->mo_run_environment->append_log( |Error: PO item { lv_ebeln_c } { lv_ebelp_c } line { <fs_po_schedule_line_expected>-etenr } | && |checked with error| ).
          lv_error_occurred = abap_true.
          CONTINUE.
        ENDIF.
      ENDLOOP.

    ENDLOOP.


    IF lv_error_occurred = abap_true.
      " at least one entry has an error
      me->mo_run_environment->append_log( iv_log_statement = |Error occurred. Details see in log above| ).
    ELSE.
      " success
      me->mo_run_environment->append_log( iv_log_statement = |Success: PO successfully checked| ).
      ev_check_status = abap_true.
      ev_execution_status = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD check_preceding.
    DATA: lt_vbeln TYPE cl_ptf_util=>ty_vbeln_tab.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    IF lines( lt_vbeln ) NE 2.
      me->mo_run_environment->append_log( iv_log_statement = |Please reference exactly one sales order and one preceding document.| ).
      ev_check_status = abap_false.
      ev_execution_status = abap_true.
      RETURN.
    ENDIF.

    DATA(sales_order) = lt_vbeln[ 1 ].
    DATA(expected_preceding_document) = lt_vbeln[ 2 ].

    SELECT SINGLE vgbel FROM vbak WHERE vbeln = @sales_order-vbeln INTO @DATA(actual_preceding_document).

    IF actual_preceding_document NE expected_preceding_document.
      ev_check_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |Preceding document was not allocated corretly. Expected: { expected_preceding_document-vbeln } Actual: { actual_preceding_document }| ).
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


  METHOD check_sold_to_party.

    DATA: ls_testdata    TYPE string,
          lv_xml_xstring TYPE xstring,
          lv_log_message TYPE string,
          lv_vbeln       TYPE vbeln.

    DATA: ls_curr_line  TYPE edi_sales_order_message,
          ls_data       TYPE edi_sales_order_message,
          lt_old_msg    TYPE /aif/bal_t_msg,
          lt_return_msg TYPE bapiret2_t,
          lv_succ       TYPE /aif/successflag,
          lv_ts         TYPE string.

*--> 1 Step: Get data from tdc
    DATA(ls_current_step) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_current_step
      IMPORTING
        es_testdata  = ls_testdata ).

*Replace the parameter in Payload
    lv_ts = utclong_current( ) .
    lv_ts = |{ lv_ts(10) }| && |T00:00:00|.
    REPLACE ALL OCCURRENCES OF '{CreationDateTime}' IN ls_testdata WITH lv_ts.

    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
      EXPORTING
        text   = ls_testdata
      IMPORTING
        buffer = lv_xml_xstring
      EXCEPTIONS
        failed = 1
        OTHERS = 2.

    "transform xstring to abap structuer
    DATA(lo_sxml_reader) = cl_sxml_string_reader=>create( input = lv_xml_xstring ).
    TRY.
        cl_proxy_xml_transform=>xml_to_abap( EXPORTING ddic_type  = 'EDI_SALES_ORDER_MESSAGE'
                                                       xml_reader = lo_sxml_reader
                                             IMPORTING abap_data  = ls_data ).
      CATCH cx_proxy_fault INTO DATA(lx_fault).
    ENDTRY.

*--> 2 Step: Call inbound processing
    TRY.
        NEW cl_edi_sd_ordr_processing( )->process(
          CHANGING
            data         = ls_data
            curr_line    = ls_curr_line
            success      = lv_succ
            old_messages = lt_old_msg
            return_tab   = lt_return_msg
        ).
      CATCH BEFORE UNWIND cx_edi_sd_exc INTO DATA(lx_edi_exc).
        APPEND LINES OF lx_edi_exc->convert_chain_to_bapiret2_t( ) TO lt_return_msg.
    ENDTRY.

*--> 3 Step:  Copy messages to et_return
    LOOP AT lt_return_msg ASSIGNING FIELD-SYMBOL(<ls_return_msg>).
      IF <ls_return_msg>-message IS INITIAL     AND
         <ls_return_msg>-id      IS NOT INITIAL AND
         <ls_return_msg>-number  IS NOT INITIAL.
        DATA(lo_message) = NEW cl_t100_message( the_msg_class  = <ls_return_msg>-id
                                                the_msg_number = <ls_return_msg>-number ).

        DATA(lt_msgv) = VALUE name2value_table(
         ( name = cl_t100_message=>msgv1_name value = <ls_return_msg>-message_v1 )
         ( name = cl_t100_message=>msgv2_name value = <ls_return_msg>-message_v2 )
         ( name = cl_t100_message=>msgv3_name value = <ls_return_msg>-message_v3 )
         ( name = cl_t100_message=>msgv4_name value = <ls_return_msg>-message_v4 ) ).

        lo_message->set_substitution_table( lt_msgv ) .
        lv_log_message = lo_message->if_message~get_text( ).
      ELSE.
        IF <ls_return_msg>-message IS NOT INITIAL.
          lv_log_message = <ls_return_msg>-message .
        ENDIF.
      ENDIF.
      lv_log_message = |EDI: { lv_log_message }|.
      me->mo_run_environment->append_log( iv_log_statement = lv_log_message ).
    ENDLOOP.

*--> 4 Step: Check result and set success flag
    IF line_exists( lt_return_msg[ type = 'E' ]  ).

      READ TABLE lt_return_msg INTO DATA(ls_return_msg) WITH KEY type   = 'E'
                                                                 id     = 'EDI_SD'
                                                                 number = 010.
      IF sy-subrc = 0.
        lv_vbeln = ls_return_msg-message_v2.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_vbeln
          IMPORTING
            output = lv_vbeln.
        APPEND lv_vbeln TO ev_document_id.
        ev_execution_status = abap_true.
        ev_check_status = abap_true.
        me->mo_run_environment->append_log( iv_log_statement = |SEF: Process faild with error  EDI_SD 010| ).
      ENDIF.

      READ TABLE lt_return_msg INTO DATA(ls_return_msg1) WITH KEY type   = 'E'
                                                                 id     = 'EDI_SD'
                                                                 number = 003.
      IF sy-subrc = 0.
        lv_vbeln = ls_return_msg1-message_v2.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_vbeln
          IMPORTING
            output = lv_vbeln.
        APPEND lv_vbeln TO ev_document_id.
        ev_check_status = abap_true.
        ev_execution_status = abap_true.
        me->mo_run_environment->append_log( iv_log_statement = |SEF: Process faild with error  EDI_SD 003| ).
      ENDIF.
    ELSE.
      ev_execution_status = abap_false.
      ev_check_status = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD check_so_delivery_blocked.

    DATA:iv_vbeln TYPE vbeln_va,
         lt_vbeln TYPE cl_ptf_util=>ty_vbeln_tab.
    CLEAR:lt_vbeln.
    DATA:iv_lifsp TYPE lifsp_ep,
         lv_msg   TYPE string.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    IF lt_vbeln IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = 'No document to check.' ).
      RETURN.
    ENDIF.

    LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<lv_vbel>).
      iv_vbeln = <lv_vbel>-vbeln.
      SELECT SINGLE lifsp INTO @iv_lifsp FROM vbep
                              WHERE vbeln EQ @iv_vbeln AND lifsp NE ''.
      IF sy-subrc EQ 0.
        ev_check_status = abap_true.
        ev_execution_status = abap_true.
        lv_msg =  |Sales Order : { iv_vbeln } Schedule Line Are Blocked For Delivery Status { iv_lifsp } |.
        me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
      ELSE.
        lv_msg =  |Sales Order : { iv_vbeln } Schedule Line Are Blocked For Delivery Status Is { iv_lifsp } In { iv_step_number } |.
        me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
        ev_check_status = abap_false.
        ev_execution_status = abap_false.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.


  METHOD check_so_delivery_unblock.
    DATA:iv_vbeln TYPE vbeln_va,
         lt_vbeln TYPE cl_ptf_util=>ty_vbeln_tab.
    CLEAR:lt_vbeln.
    DATA:it_lifsp TYPE TABLE OF lifsp_ep,
         lv_msg   TYPE string.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<lv_vbel>).
      iv_vbeln = <lv_vbel>-vbeln.
      SELECT lifsp INTO TABLE @it_lifsp FROM vbep
                              WHERE vbeln EQ @iv_vbeln AND lifsp EQ ''.
      IF it_lifsp IS NOT INITIAL.
        ev_check_status = abap_true.
        ev_execution_status = abap_true.
        lv_msg =  |Sales Order : { iv_vbeln } Schedule Line Are Blocked For Delivery Status Is Null |.
        me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
      ELSE.
        lv_msg =  |Sales Order : { iv_vbeln } Schedule Line Are Blocked For Delivery Status Is Block|.
        me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
        ev_check_status = abap_false.
        ev_execution_status = abap_false.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.


  METHOD check_so_payment_terms.

    DATA: ls_testdata    TYPE string,
          lv_xml_xstring TYPE xstring,
          lv_log_message TYPE string,
          lv_vbeln       TYPE vbeln.

    DATA: ls_curr_line  TYPE edi_sales_order_message,
          ls_data       TYPE edi_sales_order_message,
          lt_old_msg    TYPE /aif/bal_t_msg,
          lt_return_msg TYPE bapiret2_t,
          lv_succ       TYPE /aif/successflag,
          lv_ts         TYPE string.

*--> 1 Step: Get data from tdc
    DATA(ls_current_step) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_current_step
      IMPORTING
        es_testdata  = ls_testdata ).

*Replace the parameter in Payload
    lv_ts = utclong_current( ) .
*    lv_ts = |{ lv_ts(10) }| && |T00:00:00|.
    lv_ts = |{ lv_ts(10) }| && |T| && sy-uzeit(2) && |:| && sy-uzeit+2(2) && |:| && sy-uzeit+4(2) && |Z|.
    REPLACE ALL OCCURRENCES OF '{CreationDateTime}' IN ls_testdata WITH lv_ts.

    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
      EXPORTING
        text   = ls_testdata
      IMPORTING
        buffer = lv_xml_xstring
      EXCEPTIONS
        failed = 1
        OTHERS = 2.

    "transform xstring to abap structuer
    DATA(lo_sxml_reader) = cl_sxml_string_reader=>create( input = lv_xml_xstring ).
    TRY.
        cl_proxy_xml_transform=>xml_to_abap( EXPORTING ddic_type  = 'EDI_SALES_ORDER_MESSAGE'
                                                       xml_reader = lo_sxml_reader
                                             IMPORTING abap_data  = ls_data ).
      CATCH cx_proxy_fault INTO DATA(lx_fault).
    ENDTRY.

*--> 2 Step: Call inbound processing
    TRY.
        NEW cl_edi_sd_ordr_processing( )->process(
          CHANGING
            data         = ls_data
            curr_line    = ls_curr_line
            success      = lv_succ
            old_messages = lt_old_msg
            return_tab   = lt_return_msg
        ).
      CATCH BEFORE UNWIND cx_edi_sd_exc INTO DATA(lx_edi_exc).
        APPEND LINES OF lx_edi_exc->convert_chain_to_bapiret2_t( ) TO lt_return_msg.
    ENDTRY.

*--> 3 Step:  Copy messages to et_return
    LOOP AT lt_return_msg ASSIGNING FIELD-SYMBOL(<ls_return_msg>).
      IF <ls_return_msg>-message IS INITIAL     AND
         <ls_return_msg>-id      IS NOT INITIAL AND
         <ls_return_msg>-number  IS NOT INITIAL.
        DATA(lo_message) = NEW cl_t100_message( the_msg_class  = <ls_return_msg>-id
                                                the_msg_number = <ls_return_msg>-number ).

        DATA(lt_msgv) = VALUE name2value_table(
         ( name = cl_t100_message=>msgv1_name value = <ls_return_msg>-message_v1 )
         ( name = cl_t100_message=>msgv2_name value = <ls_return_msg>-message_v2 )
         ( name = cl_t100_message=>msgv3_name value = <ls_return_msg>-message_v3 )
         ( name = cl_t100_message=>msgv4_name value = <ls_return_msg>-message_v4 ) ).

        lo_message->set_substitution_table( lt_msgv ) .
        lv_log_message = lo_message->if_message~get_text( ).
      ELSE.
        IF <ls_return_msg>-message IS NOT INITIAL.
          lv_log_message = <ls_return_msg>-message .
        ENDIF.
      ENDIF.
      lv_log_message = |EDI: { lv_log_message }|.
      me->mo_run_environment->append_log( iv_log_statement = lv_log_message ).
    ENDLOOP.

*--> 4 Step: Check result and set success flag
    IF line_exists( lt_return_msg[ type = 'E' ]  ).

      READ TABLE lt_return_msg INTO DATA(ls_return_msg) WITH KEY type   = 'E'
                                                                 id     = 'EDI_SD'
                                                                 number = 042.
      IF sy-subrc = 0.
        lv_vbeln = ls_return_msg-message_v2.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_vbeln
          IMPORTING
            output = lv_vbeln.
        APPEND lv_vbeln TO ev_document_id.
        ev_execution_status = abap_true.
        ev_check_status = abap_true.
        me->mo_run_environment->append_log( iv_log_statement = |SEF: Process faild with error  EDI_SD 042| ).
      ENDIF.

      READ TABLE lt_return_msg INTO DATA(ls_return_msg1) WITH KEY type   = 'E'
                                                                 id     = 'EDI_SD'
                                                                 number = 043.
      IF sy-subrc = 0.
        lv_vbeln = ls_return_msg1-message_v2.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_vbeln
          IMPORTING
            output = lv_vbeln.
        APPEND lv_vbeln TO ev_document_id.
        ev_check_status = abap_true.
        ev_execution_status = abap_true.
        me->mo_run_environment->append_log( iv_log_statement = |SEF: Process faild with error  EDI_SD 0043| ).
      ENDIF.

      READ TABLE lt_return_msg INTO DATA(ls_return_msg2) WITH KEY type   = 'E'
                                                                  id     = 'EDI_SD'
                                                                  number = 044.
      IF sy-subrc = 0.
        lv_vbeln = ls_return_msg1-message_v2.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_vbeln
          IMPORTING
            output = lv_vbeln.
        APPEND lv_vbeln TO ev_document_id.
        ev_check_status = abap_true.
        ev_execution_status = abap_true.
        me->mo_run_environment->append_log( iv_log_statement = |SEF: Process faild with error  EDI_SD 0044| ).
      ENDIF.

    ELSE.
      ev_execution_status = abap_false.
      ev_check_status = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD compare_against_db_doc.

    DATA lt_vbeln     TYPE cl_ptf_util=>ty_vbeln_tab.
    DATA lv_vbeln_act TYPE vbeln_va.
    DATA lv_vbeln_exp__char70 TYPE ptfkey.
    DATA lv_vbeln_exp TYPE vbeln_va.

    "Get ID of ideal document and docs from refStep
    compare_against_db_doc_prepare(
      EXPORTING
        is_step_data   = is_step_data
        iv_step_number = iv_step_number
      IMPORTING
        ev_error       = DATA(lv_error)
        et_vbeln       = lt_vbeln
        ev_vbeln_exp   = lv_vbeln_exp__char70
    ).
    IF lv_error IS NOT INITIAL.
      RETURN.
    ENDIF.

    "convert from generic ptf key type char70 to SD specific key length char10
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_vbeln_exp__char70
      IMPORTING
        output = lv_vbeln_exp.


    ev_check_status       = abap_true.
    ev_execution_status   = abap_true.

    DATA(lo_comp) = NEW cl_ptf_compare_docs_generic( ).


    "VBAK
    LOOP AT lt_vbeln INTO lv_vbeln_act.

      SELECT * FROM vbak WHERE vbeln = @lv_vbeln_act    INTO TABLE @DATA(lt_vbak_act).
      IF sy-subrc IS NOT INITIAL. me->mo_run_environment->append_log( iv_log_statement = |Actual document { lv_vbeln_act } not found.| ). CONTINUE. ENDIF.
      SELECT * FROM vbak WHERE vbeln = @lv_vbeln_exp    INTO TABLE @DATA(lt_vbak_exp).
      IF sy-subrc IS NOT INITIAL. me->mo_run_environment->append_log( iv_log_statement = |Ideal document { lv_vbeln_exp } not found.| ).  EXIT.     ENDIF.

      DATA lt_ignore TYPE STANDARD TABLE OF fieldname.
      lt_ignore = VALUE #(
       ( 'VBELN' )
       ( 'ERDAT' )
       ( 'ERZET' )
       ( 'AUDAT' )
       ( 'KNUMV' )
       ( 'ERNAM' )
       ( 'VDATU' )
       ( 'HANDLE' )
       ( 'UPD_TMSTMP' )
       ( 'FMBDAT' )
       ( 'CMNGV' )
       ( 'CROSSITEM_PRC_DATE')
       ( 'LAST_CHANGED_BY_USER')
       ( 'CM_LAST_CHECK')
       ( 'TOTAL_LCCST' )
      ).

      lo_comp->compare_records(
        EXPORTING
          ir_act_tab          = REF #( lt_vbak_act )
          ir_exp_tab          = REF #( lt_vbak_exp )
          it_fields_to_ignore = lt_ignore
        IMPORTING
          et_finding          = DATA(lt_finding_root)
          es_info             = DATA(ls_count)
      ).

      IF lt_finding_root IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |For document { lv_vbeln_act } and table VBAK, no differences were found.| ).
      ELSE.
        ev_check_status = abap_false.
        me->mo_run_environment->append_log( iv_log_statement = |Differences for document { lv_vbeln_act } and table VBAK:| ).
        LOOP AT lt_finding_root ASSIGNING FIELD-SYMBOL(<finding>).
          me->mo_run_environment->append_log( CONV #( <finding> ) ).
        ENDLOOP.
      ENDIF.

      me->mo_run_environment->append_log( iv_log_statement = |Compared { ls_count-compared } fields, of which { ls_count-compared_not_empty } were not empty.| ).
      me->mo_run_environment->append_log( iv_log_statement = |Records: { ls_count-records }.| ).
      me->mo_run_environment->append_log( iv_log_statement = |---------------| ).

    ENDLOOP.


    "VBAP
    LOOP AT lt_vbeln INTO lv_vbeln_act.

      SELECT * FROM vbap WHERE vbeln = @lv_vbeln_act ORDER BY posnr INTO TABLE @DATA(lt_vbap_act).
*      IF sy-subrc IS NOT INITIAL. me->mo_run_environment->append_log( iv_log_statement = |Actual document { lv_vbeln_act } not found.| ). CONTINUE. ENDIF.
      SELECT * FROM vbap WHERE vbeln = @lv_vbeln_exp ORDER BY posnr INTO TABLE @DATA(lt_vbap_exp).
*      IF sy-subrc IS NOT INITIAL. me->mo_run_environment->append_log( iv_log_statement = |Ideal document { lv_vbeln_exp } not found.| ).  EXIT.     ENDIF.

      lt_ignore = VALUE #(
       ( 'VBELN' )
       ( 'ERDAT' )
       ( 'ERZET' )
       ( 'SESSION_CREATION_DATE' )
       ( 'SESSION_CREATION_TIME' )
       ( 'HANDLE' )
       ( 'ERNAM' )
       ( 'CPD_UPDAT' )
       ( 'CMNGV' )
       ( 'CROSSITEM_PRC_DATE')
       ( 'PAOBJNR')
       ( 'CMTD_DELIV_DATE')
       ( 'CMTD_DELIV_CREADATE')
       ( 'WAVWR')
       ( 'CMKUA')
       "REDUNDANT HEADER FIELDS, COMPARE WITH HEADER?
       ( 'AUDAT_ANA' )
       ( 'VDATU_ANA' )
       ( 'KNUMV_ANA' )
       ( 'FKDAT_ANA' )
       ( 'TOTAL_LCCST' )
      ).

      lo_comp->compare_records(
        EXPORTING
          ir_act_tab          = REF #( lt_vbap_act )
          ir_exp_tab          = REF #( lt_vbap_exp )
          it_fields_to_ignore = lt_ignore
        IMPORTING
          et_finding          = DATA(lt_finding_item)
          es_info             = ls_count
      ).

      IF lt_finding_item IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |For document { lv_vbeln_act } and table VBAP, no differences were found.| ).
      ELSE.
        ev_check_status = abap_false.
        me->mo_run_environment->append_log( iv_log_statement = |Differences for document { lv_vbeln_act } and table VBAP:| ).
        LOOP AT lt_finding_item ASSIGNING <finding>.
          me->mo_run_environment->append_log( CONV #( <finding> ) ).
        ENDLOOP.
      ENDIF.

      me->mo_run_environment->append_log( iv_log_statement = |Compared { ls_count-compared } fields, of which { ls_count-compared_not_empty } were not empty.| ).
      me->mo_run_environment->append_log( iv_log_statement = |Records: { ls_count-records }.| ).
      me->mo_run_environment->append_log( iv_log_statement = |---------------| ).

    ENDLOOP.


    "VBKD
    LOOP AT lt_vbeln INTO lv_vbeln_act.

      SELECT * FROM vbkd WHERE vbeln = @lv_vbeln_act ORDER BY posnr INTO TABLE @DATA(lt_vbkd_act).
*      IF sy-subrc IS NOT INITIAL. me->mo_run_environment->append_log( iv_log_statement = |Actual document { lv_vbeln_act } not found.| ). CONTINUE. ENDIF.
      SELECT * FROM vbkd WHERE vbeln = @lv_vbeln_exp ORDER BY posnr INTO TABLE @DATA(lt_vbkd_exp).
*      IF sy-subrc IS NOT INITIAL. me->mo_run_environment->append_log( iv_log_statement = |Ideal document { lv_vbeln_exp } not found.| ).  EXIT.     ENDIF.

      lt_ignore = VALUE #(
         ( 'VBELN' )
         ( 'PRSDT' )
         ( 'FKDAT' )
         ( 'FBUDA' )
         ( 'GJAHR' )
         ( 'POPER' )
         ( 'STCUR' )
         ( 'FPLNR' )
         ( 'LCNUM' )
         ( 'KURSK_DAT' )
         ( 'KURRF_DAT' )
      ).

      lo_comp->compare_records(
        EXPORTING
          ir_act_tab          = REF #( lt_vbkd_act )
          ir_exp_tab          = REF #( lt_vbkd_exp )
          it_fields_to_ignore = lt_ignore
        IMPORTING
          et_finding          = DATA(lt_finding_vbkd)
          es_info             = ls_count
      ).

      IF lt_finding_vbkd IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |For document { lv_vbeln_act } and table VBKD, no differences were found.| ).
      ELSE.
        ev_check_status = abap_false.
        me->mo_run_environment->append_log( iv_log_statement = |Differences for document { lv_vbeln_act } and table VBKD:| ).
        LOOP AT lt_finding_item ASSIGNING <finding>.
          me->mo_run_environment->append_log( CONV #( <finding> ) ).
        ENDLOOP.
      ENDIF.

      me->mo_run_environment->append_log( iv_log_statement = |Compared { ls_count-compared } fields, of which { ls_count-compared_not_empty } were not empty.| ).
      me->mo_run_environment->append_log( iv_log_statement = |Records: { ls_count-records }.| ).
      me->mo_run_environment->append_log( iv_log_statement = |---------------| ).

    ENDLOOP.


    "VBPA    Partner
    LOOP AT lt_vbeln INTO lv_vbeln_act.

      SELECT * FROM vbpa WHERE vbeln = @lv_vbeln_act ORDER BY posnr, parvw INTO TABLE @DATA(lt_vbpa_act).
*      IF sy-subrc IS NOT INITIAL. me->mo_run_environment->append_log( iv_log_statement = |Actual document { lv_vbeln_act } not found.| ). CONTINUE. ENDIF.
      SELECT * FROM vbpa WHERE vbeln = @lv_vbeln_exp ORDER BY posnr, parvw INTO TABLE @DATA(lt_vbpa_exp).
*      IF sy-subrc IS NOT INITIAL. me->mo_run_environment->append_log( iv_log_statement = |Ideal document { lv_vbeln_exp } not found.| ).  EXIT.     ENDIF.

      lt_ignore = VALUE #(
         ( 'VBELN' )
      ).

      lo_comp->compare_records(
        EXPORTING
          ir_act_tab          = REF #( lt_vbpa_act )
          ir_exp_tab          = REF #( lt_vbpa_exp )
          it_fields_to_ignore = lt_ignore
        IMPORTING
          et_finding          = DATA(lt_finding_vbpa)
          es_info             = ls_count
      ).

      IF lt_finding_vbpa IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |For document { lv_vbeln_act } and table VBPA, no differences were found.| ).
      ELSE.
        ev_check_status = abap_false.
        me->mo_run_environment->append_log( iv_log_statement = |Differences for document { lv_vbeln_act } and table VBPA:| ).
        LOOP AT lt_finding_item ASSIGNING <finding>.
          me->mo_run_environment->append_log( CONV #( <finding> ) ).
        ENDLOOP.
      ENDIF.

      me->mo_run_environment->append_log( iv_log_statement = |Compared { ls_count-compared } fields, of which { ls_count-compared_not_empty } were not empty.| ).
      me->mo_run_environment->append_log( iv_log_statement = |Records: { ls_count-records }.| ).
      me->mo_run_environment->append_log( iv_log_statement = |---------------| ).

    ENDLOOP.



    IF ev_check_status EQ abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |Overall result for this step, for all checked tables: No problem found.| ).
    ENDIF.

    ev_document_id = lt_vbeln.

    "TEMP - set always to successful, to get more data from different checks in one run
    ev_check_status = abap_true.


  ENDMETHOD.


  METHOD compare_against_db_doc_prepare.

    CLEAR: ev_error, et_vbeln, ev_vbeln_exp.

    "First check the static prerequisite, the ID of the ideal document
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = is_step_data-variant
      IMPORTING
        output = ev_vbeln_exp.
    IF ev_vbeln_exp IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Error: In column VARIANT, maintain the fix VBELN the current docs shall be compared to.| ).
      ev_error = abap_true.
*      RETURN.       check the refDocs anyway
    ENDIF.

    "Referenced current documents
    LOOP AT is_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      IF lines( lt_ptf_keys ) EQ 0.
        me->mo_run_environment->append_log( iv_log_statement = |No documents found for reference step { <lv_ref_step> }| ).
      ENDIF.
      APPEND LINES OF lt_ptf_keys TO et_vbeln.
    ENDLOOP.
    IF et_vbeln IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Nothing to check.| ).
      ev_error = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD compare_structure.
    DATA:
      msg_str1     TYPE string,
      msg_str2     TYPE string,
      lv_statement TYPE string.

    FIELD-SYMBOLS:
      <lv_expected>        TYPE any,
      <lv_actual>          TYPE any,
      <lv_check_parameter> TYPE any.

    rv_result = abap_true.

    " get fields to be checked
    TRY.
        DATA(lt_fields) =  CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_data( is_check_parameter ) )->get_components( ).
      CATCH cx_sy_move_cast_error.
        lv_statement = 'Error: method call not correct'.
        io_run_environment->append_log( |{ lv_statement }| ).
        rv_result = abap_false.
        RETURN.
    ENDTRY.

    IF lt_fields IS INITIAL.
      RETURN.
    ENDIF.

    " check single field
    LOOP AT lt_fields ASSIGNING FIELD-SYMBOL(<fs_field>).

      ASSIGN COMPONENT <fs_field>-name OF STRUCTURE is_check_parameter TO <lv_check_parameter>.
      IF sy-subrc <> 0.
        lv_statement = 'Error: field &1 not defined in test data structure'.
        REPLACE '&1' IN lv_statement WITH <fs_field>-name.
        io_run_environment->append_log( |{ lv_statement }| ).
        rv_result = abap_false.
        RETURN.
      ENDIF.
      IF <lv_check_parameter> = space.
        CONTINUE.
      ENDIF.

      ASSIGN COMPONENT <fs_field>-name OF STRUCTURE is_actual TO <lv_actual>.
      IF sy-subrc <> 0.
        lv_statement = 'Error: field &1 not defined in test data structure'.
        REPLACE '&1' IN lv_statement WITH <fs_field>-name.
        io_run_environment->append_log( |{ lv_statement }| ).
        rv_result = abap_false.
        RETURN.
      ENDIF.
      ASSIGN COMPONENT <fs_field>-name OF STRUCTURE is_expected TO <lv_expected>.
      IF sy-subrc <> 0.
        lv_statement = 'Error: field &1 not defined in test data structure'.
        REPLACE '&1' IN lv_statement WITH <fs_field>-name.
        io_run_environment->append_log( |{ lv_statement }| ).
        rv_result = abap_false.
        RETURN.
      ENDIF.

      " check current value and expected value
      IF <lv_expected> <> <lv_actual>.
        rv_result = abap_false.
        msg_str1 = <lv_expected>.
        msg_str2 = <lv_actual>.
        lv_statement = 'Error: field &1 is not as expected. The expected value is: &2. The stored value is: &3'.
        REPLACE '&1' IN lv_statement WITH <fs_field>-name.
        REPLACE '&2' IN lv_statement WITH msg_str1.
        REPLACE '&3' IN lv_statement WITH msg_str2.
        io_run_environment->append_log( |{ lv_statement }| ).
        RETURN.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.


  METHOD create.
    _create( EXPORTING iv_step_number      = iv_step_number
                       iv_use_ref_material = abap_false
             IMPORTING ev_check_status     = ev_check_status
                       ev_document_id      = ev_document_id
                       ev_execution_status = ev_execution_status ).
  ENDMETHOD.


  METHOD create_for_material.
    _create( EXPORTING iv_step_number      = step_data-step_number
                       iv_use_ref_material = abap_true
             IMPORTING ev_check_status     = ev_check_status
                       ev_document_id      = ev_document_id
                       ev_execution_status = ev_execution_status ).
  ENDMETHOD.


  METHOD create_for_project.

    DATA already_shifted TYPE i.
    DATA insertion1 TYPE i.
    DATA insertion2 TYPE i.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/CPD/SC_PROJ_ENGMT_CREATE_UPD_SRV/'.
    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    "data lt_parameters type /iwfnd/sutil_property_t.
    DATA ls_response TYPE REF TO data.

    DATA:
      lt_customerproject   TYPE cl_ptf_util=>ty_vbeln_tab,
      lv_customerprojectid TYPE /cpd/mp_id,
      lv_salesorder        TYPE vbeln.

    DATA:
      ls_tdc     TYPE ty_gs_i_ptf_so_cr_so01_td,
      ls_so      TYPE ty_gs_i_ptf_so_cr_so01_td,
      ls_so_item TYPE /cpd/cl_sc_proj_engmt__dpc_ext=>tcs_deep_slsorditem,
      lt_so_item TYPE /cpd/cl_sc_proj_engmt__dpc_ext=>tct_deep_slsorditem,
      lt_wp      TYPE STANDARD TABLE OF /cpd/cl_sc_proj_engmt__mpc=>ts_a_custprojslsorditemworkpck WITH EMPTY KEY,
      ls_wp      TYPE /cpd/cl_sc_proj_engmt__mpc=>ts_a_custprojslsorditemworkpck,
      lt_bp      TYPE STANDARD TABLE OF /cpd/cl_sc_proj_engmt__mpc=>ts_a_custprojslsorditmbillgpln WITH EMPTY KEY,
      ls_bp      TYPE /cpd/cl_sc_proj_engmt__mpc=>ts_a_custprojslsorditmbillgpln,
      lv_tabix   TYPE char1.

*   Get test data container variant
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_tdc
    ).

*   Get Project ID
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_customerproject.
    ENDLOOP.
    IF lines( lt_customerproject ) <> 1.
      me->mo_run_environment->append_log( iv_log_statement = |Number of customer projects must be one.| ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.
    lv_customerprojectid = lt_customerproject[ 1 ].

*   Enrich testdata
    LOOP AT ls_tdc-to_custprojslsorditem ASSIGNING FIELD-SYMBOL(<slsorditem>).
      "Create and assign Workpackage per SalesOrderItem
      CLEAR lt_wp.
      lv_tabix = sy-tabix.
      CONCATENATE lv_customerprojectid '.1.' lv_tabix INTO ls_wp-workpackage.
      CONCATENATE 'WP' lv_tabix INTO ls_wp-workpackagename.
      APPEND ls_wp TO lt_wp.
      <slsorditem>-to_custprojslsorditemworkpckg = lt_wp.

      "Add billing plan date
      LOOP AT <slsorditem>-to_custprojsoibillgplnitm ASSIGNING FIELD-SYMBOL(<billgplnitm>).
        IF <billgplnitm>-billingplanbillingdate IS INITIAL.
          LOOP AT ls_tdc-to_custprojsoibillgplnitm_date ASSIGNING FIELD-SYMBOL(<billgplnitmdate>)
            WHERE salesorderitem = <slsorditem>-salesorderitem AND billingplanitem = <billgplnitm>-billingplanitem.
            IF <billgplnitmdate>-days_delta IS NOT INITIAL.
              <billgplnitm>-billingplanbillingdate = sy-datum + <billgplnitmdate>-days_delta.
            ELSE.
              <billgplnitm>-billingplanbillingdate = sy-datum.
            ENDIF.
          ENDLOOP.
          IF sy-subrc = 4.
            <billgplnitm>-billingplanbillingdate = sy-datum.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

*   Add enriched testdata to ls_so
    ls_so-customerproject = lv_customerprojectid.
    ls_so-purchaseorderbycustomer = ls_tdc-purchaseorderbycustomer.
    ls_so-to_custprojslsorditem = ls_tdc-to_custprojslsorditem.

*   Add header texts to ls_so
    ls_so-to_custprojslsordtext = ls_tdc-to_custprojslsordtext.

    DATA(lv_payload) = /ui2/cl_json=>serialize(
                EXPORTING
                    data            = ls_so
                    pretty_name     = /ui2/cl_json=>pretty_mode-user_low_case
                    name_mappings   = VALUE /ui2/cl_json=>name_mappings(
        ( abap = 'CUSTOMERPROJECT' json = 'CustomerProject' )
        ( abap = 'PURCHASEORDERBYCUSTOMER' json = 'PurchaseOrderByCustomer' )
        ( abap = 'CUSTOMERPURCHASEORDERDATE' json = 'CustomerPurchaseOrderDate' )
        ( abap = 'TRANSACTIONCURRENCY' json = 'TransactionCurrency' )
        ( abap = 'SALESORDERITEM' json = 'SalesOrderItem' )
        ( abap = 'TO_CUSTPROJSLSORDITEM' json = 'to_CustProjSlsOrdItem' )
          ( abap = 'SALESORDERITEMCATEGORY' json = 'SalesOrderItemCategory' )
          ( abap = 'MATERIAL' json = 'Material' )
          ( abap = 'EXPECTEDNETAMOUNT' json = 'ExpectedNetAmount' )
        ( abap = 'TO_CUSTPROJSOIBILLGPLNITM' json = 'to_CustProjSOIBillgPlnItm' )
          ( abap = 'BILLINGPLANITEM' json = 'BillingPlanItem' )
          ( abap = 'BILLINGPLANBILLINGDATE' json = 'BillingPlanBillingDate' )
          ( abap = 'BILLINGPLANAMOUNT' json = 'BillingPlanAmount' )
          ( abap = 'BILLINGPLANITEMDESCRIPTION' json = 'BillingPlanItemDescription' )
          ( abap = 'BILLINGPLANITEMUSAGE' json = 'BillingPlanItemUsage' )
          ( abap = 'BILLINGPLANSERVICESTARTDATE' json = 'BillingPlanServiceStartDate' )
          ( abap = 'BILLINGPLANSERVICEENDDATE' json = 'BillingPlanServiceEndDate' )
        ( abap = 'TO_CUSTPROJSLSORDITEMWORKPCKG' json = 'to_CustProjSlsOrdItemWorkPckg' )
          ( abap = 'WORKPACKAGE' json = 'WorkPackage' )
          ( abap = 'WORKPACKAGENAME' json = 'WorkPackageName' )
        ( abap = 'TO_CUSTPROJSLSORDITEMPARTNER' json = 'to_CustProjSlsOrdItemPartner' )
          ( abap = 'PARTNERFUNCTION' json = 'PartnerFunction' )
          ( abap = 'BUSINESSPARTNER' json = 'BusinessPartner' )
        ( abap = 'TO_CUSTPROJSLSORDTEXT' json = 'to_CustProjSlsOrdText' )
          ( abap = 'LANGUAGE' json = 'Language' )
          ( abap = 'LONGTEXTID' json = 'LongTextID' )
          ( abap = 'LONGTEXT' json = 'LongText' )
        )
                    compress        = abap_true
              ).
    DATA(lv_payload_temp) = lv_payload.

    LOOP AT ls_tdc-to_custprojslsorditem ASSIGNING FIELD-SYMBOL(<custprojslsorditem>).

      CASE <custprojslsorditem>-salesorderitemcategory.

        WHEN 'PS01' OR 'PS02'. "Fixed Price or Time and Expenses
*          FixedPrice
*          CONCATENATE lv_payload_temp(118)'"'         lv_payload_temp+118 INTO lv_payload_temp.
*          CONCATENATE lv_payload_temp(121)'"'         lv_payload_temp+121 INTO lv_payload_temp.
*          CONCATENATE lv_payload_temp(193)'"'         lv_payload_temp+193 INTO lv_payload_temp.
*          CONCATENATE lv_payload_temp(197)'"'         lv_payload_temp+200 INTO lv_payload_temp.
*          CONCATENATE lv_payload_temp(366)'T00:00:00' lv_payload_temp+366 INTO lv_payload_temp.
*          CONCATENATE lv_payload_temp(397)'"'         lv_payload_temp+397 INTO lv_payload_temp.
*          CONCATENATE lv_payload_temp(401)'"'         lv_payload_temp+404 INTO lv_payload_temp.
*          T&E
*          concatenate lv_payload_temp(118)'"'         lv_payload_temp+118 into lv_payload_temp.
*          concatenate lv_payload_temp(121)'"'         lv_payload_temp+121 into lv_payload_temp.
*          concatenate lv_payload_temp(193)'"'         lv_payload_temp+193 into lv_payload_temp.
*          concatenate lv_payload_temp(197)'"'         lv_payload_temp+200 into lv_payload_temp.
*          concatenate lv_payload_temp(366)'T00:00:00' lv_payload_temp+366 into lv_payload_temp.

          DATA done TYPE c.
          CHECK done EQ space.
          done = 'X'.

          FIND ALL OCCURRENCES OF '"SalesOrderItem":' IN lv_payload_temp RESULTS DATA(lt_result).
          CLEAR already_shifted.
          LOOP AT lt_result INTO DATA(ls_result).
            insertion1 = ls_result-offset + already_shifted + 17.
            insertion2 = ls_result-offset + already_shifted + 17    + 1.
            lv_payload_temp = lv_payload_temp(insertion1) && '"' && lv_payload_temp+insertion1(1) && '"' && lv_payload_temp+insertion2.
            ADD 2 TO already_shifted.
          ENDLOOP.

          FIND ALL OCCURRENCES OF '"BillingPlanItem":' IN lv_payload_temp RESULTS lt_result.
          CLEAR already_shifted.
          LOOP AT lt_result INTO ls_result.
            insertion1 = ls_result-offset + already_shifted + 18.
            insertion2 = ls_result-offset + already_shifted + 18 + 1.
            lv_payload_temp = lv_payload_temp(insertion1) && '"' && lv_payload_temp+insertion1(1) && '"' && lv_payload_temp+insertion2.
            ADD 2 TO already_shifted.
          ENDLOOP.

          FIND ALL OCCURRENCES OF '"BillingPlanAmount":' IN lv_payload_temp RESULTS lt_result.
          CLEAR already_shifted.
          LOOP AT lt_result INTO ls_result.
            insertion1 = ls_result-offset + already_shifted + 20.      "end of search term
            DATA(temp) = lv_payload_temp(insertion1) && '"' && lv_payload_temp+insertion1.
            FIND FIRST OCCURRENCE OF ',' IN temp+insertion1 RESULTS DATA(ls_result_2).
            IF sy-subrc IS NOT INITIAL.
              CHECK 1 = 1.
            ENDIF.
            insertion2 = insertion1 + ls_result_2-offset.
            lv_payload_temp = temp(insertion2) && '"' && temp+insertion2.
            ADD 2 TO already_shifted.
          ENDLOOP.

          FIND ALL OCCURRENCES OF '"ExpectedNetAmount":' IN lv_payload_temp RESULTS lt_result.
          CLEAR already_shifted.
          LOOP AT lt_result INTO ls_result.
            insertion1 = ls_result-offset + already_shifted + 20.      "end of search term
            temp = lv_payload_temp(insertion1) && '"' && lv_payload_temp+insertion1.
            FIND FIRST OCCURRENCE OF ',' IN temp+insertion1 RESULTS ls_result_2.
            IF sy-subrc IS NOT INITIAL.
              CHECK 1 = 1.
            ENDIF.
            insertion2 = insertion1 + ls_result_2-offset.
            lv_payload_temp = temp(insertion2) && '"' && temp+insertion2.
            ADD 2 TO already_shifted.
          ENDLOOP.

          FIND ALL OCCURRENCES OF '"BillingPlanBillingDate":"' IN lv_payload_temp RESULTS lt_result.
          CLEAR already_shifted.
          LOOP AT lt_result INTO ls_result.
            DATA(insertion) = ls_result-offset + already_shifted + ls_result-length + 10.
            lv_payload_temp = lv_payload_temp(insertion) && 'T00:00:00' && lv_payload_temp+insertion.
            ADD 9 TO already_shifted.
          ENDLOOP.

        WHEN 'PS06'. "Periodic Service
          CONCATENATE lv_payload_temp(118)'"'         lv_payload_temp+118 INTO lv_payload_temp.
          CONCATENATE lv_payload_temp(121)'"'         lv_payload_temp+121 INTO lv_payload_temp.
          CONCATENATE lv_payload_temp(193)'"'         lv_payload_temp+193 INTO lv_payload_temp.
          CONCATENATE lv_payload_temp(197)'"'         lv_payload_temp+200 INTO lv_payload_temp.
          CONCATENATE lv_payload_temp(366)'T00:00:00' lv_payload_temp+366 INTO lv_payload_temp.
          CONCATENATE lv_payload_temp(397)'"'         lv_payload_temp+397 INTO lv_payload_temp.
          CONCATENATE lv_payload_temp(401)'"'         lv_payload_temp+404 INTO lv_payload_temp.
          CONCATENATE lv_payload_temp(472)'T00:00:00' lv_payload_temp+472 INTO lv_payload_temp.
          CONCATENATE lv_payload_temp(522)'T00:00:00' lv_payload_temp+522 INTO lv_payload_temp.
        WHEN OTHERS.

      ENDCASE.
    ENDLOOP.


    lv_payload = lv_payload_temp.

    lo_odata_caller->call_service(
      EXPORTING
        iv_method           = 'POST'
        iv_action_or_entity = 'A_CustProjSlsOrd'
        iv_payload          = lv_payload
      IMPORTING
        ev_status_code      = DATA(lv_status_code)
        ev_status_text      = DATA(lv_status_text)
        es_json_response    = ls_response
    ).

    IF lv_status_text = 'Created'.
      SELECT SINGLE salesorder FROM i_custprojslsord INTO @lv_salesorder WHERE customerproject = @ls_so-customerproject.
      APPEND lv_salesorder TO ev_document_id.
      ev_execution_status = abap_true.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |Could not create sales order.| ).
      ev_execution_status = abap_false.
    ENDIF.
  ENDMETHOD.


  METHOD create_ic.
    DATA: ls_testdata                    TYPE ty_gs_i_ptf_or_cr_td,
          ls_order_header_in_x           TYPE bapisdhd1x,
          ls_order_header_in             TYPE bapisdhd1,
          lt_extensionex                 TYPE TABLE OF bapiparex,
          ls_extensibility_fields_header TYPE REF TO bape_sdsalesdoc,
          lt_order_partners              TYPE TABLE OF bapiparnr,
          lt_order_items                 TYPE TABLE OF bapisditm,
          lt_order_items_x               TYPE TABLE OF bapisditmx,
          ls_order_item_x                TYPE bapisditmx,
          lt_schedules                   TYPE TABLE OF bapischdl,
          ls_return                      TYPE bapiret2,
          lt_return                      TYPE TABLE OF bapiret2,
          lv_vbeln                       TYPE vbeln,
          lo_bapi_mapping                TYPE REF TO if_cfd_bapi_mapping,
          lt_extensibility_fields_item   TYPE TABLE OF bape_sdsalesdocitem,
          ls_extensibility_fields_item   TYPE bape_sdsalesdocitem,
          lt_bapiparex                   TYPE bapiparextab,
          ls_i_salesitemproposalitemtp   TYPE i_salesitemproposalitemtp,
          ls_prpsl_item                  TYPE bapisditm,
          lv_next_itm_number             TYPE i,
          ls_ext_field                   TYPE string,
          ls_tvak                        TYPE tvak,
          lv_key                         TYPE i,
          lv_key_as_string               TYPE string,
          lv_key_add                     TYPE i,
          lr_header_bapi_ext             TYPE REF TO bape_sdsalesdoc,
          lr_item_bapi_ext               TYPE REF TO bape_sdsalesdoc,
          lt_sales_text                  TYPE ty_bapisdtext.

    FIELD-SYMBOLS: <gfs_field>          TYPE any,
                   <ex_field_structure> TYPE any.

*****************************************************************************
* 1 Step: get tdcv
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

*****************************************************************************
* 3 Step: Prepare Testdata for 'SD_SALESDOCUMENT_CREATE'
    CALL METHOD ic_prepare_testdata_create
      EXPORTING
        ls_testdata        = ls_testdata
      IMPORTING
        ls_order_header_in = ls_order_header_in
        lt_order_partners  = lt_order_partners
        lt_order_items     = lt_order_items
        lt_schedules       = lt_schedules
        lt_sales_text      = lt_sales_text.
*****************************************************************************
    "ls_order_header_in_x-updateflag  = 'I'.
    ls_order_header_in_x-doc_type    = 'X'.
    ls_order_header_in_x-sales_org   = 'X'.
    ls_order_header_in_x-distr_chan  = 'X'.
    ls_order_header_in_x-division    = 'X'.
    ls_order_header_in_x-pp_search   = 'X'.
    ls_order_header_in_x-ct_valid_f  = 'X'.
    ls_order_header_in_x-ct_valid_t  = 'X'.

    CLEAR ls_order_item_x.
    "ls_order_item_x-updateflag = 'I'.
    ls_order_item_x-material   = 'X'.
    ls_order_item_x-target_qty = 'X'.
    ls_order_item_x-target_qu  = 'X'.

    SELECT SINGLE * FROM tvak INTO @ls_tvak
        WHERE auart = @ls_order_header_in-doc_type.

    IF ls_tvak IS NOT INITIAL.
      lv_key_add = ls_tvak-incpo.
    ELSE.
      lv_key_add = 10.
    ENDIF.
    lv_key = lv_key_add.

    "Fill Ext fields for items
    LOOP AT lt_order_items ASSIGNING FIELD-SYMBOL(<ls_order_item>).
      ls_order_item_x-itm_number = <ls_order_item>-itm_number.
      IF <ls_order_item>-unddlv_tol IS NOT INITIAL.
        ls_order_item_x-unddlv_tol = 'X'.
      ENDIF.
      APPEND ls_order_item_x TO lt_order_items_x.

      CLEAR ls_extensibility_fields_item.
      lv_key_as_string = lv_key.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_key_as_string
        IMPORTING
          output = ls_extensibility_fields_item-key.
      IF ls_testdata-ext_fields_item IS NOT INITIAL.
        LOOP AT ls_testdata-ext_fields_item ASSIGNING FIELD-SYMBOL(<ls_ext_field>).
          IF <ls_ext_field>-type EQ 'P'.
            ls_ext_field = |ls_extensibility_fields_item-data-{ <ls_ext_field>-name }|.
            ASSIGN (ls_ext_field) TO <ex_field_structure>.
            IF <ex_field_structure> IS ASSIGNED.
              <ex_field_structure> = <ls_ext_field>-expected_input.
            ENDIF.


            ls_ext_field = |ls_extensibility_fields_item-datax-{ <ls_ext_field>-name }|.
            ASSIGN (ls_ext_field) TO <ex_field_structure>.
            IF <ex_field_structure> IS ASSIGNED.
              <ex_field_structure> = 'X'.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.

      APPEND ls_extensibility_fields_item TO lt_extensibility_fields_item.
      lv_key = lv_key + lv_key_add.
    ENDLOOP.

*   map the Extensibility fields into a suitable EXTENSIONIN format
    lo_bapi_mapping = cl_cfd_bapi_mapping=>get_instance( ).
    GET REFERENCE OF lt_extensibility_fields_item INTO DATA(lr_ci_item_bapi_tab).
    TRY.
        lo_bapi_mapping->map_to_bapiparex_multi(
          EXPORTING
            ir_source_table = lr_ci_item_bapi_tab
          CHANGING
            ct_bapiparex    = lt_bapiparex ).
      CATCH cx_root.
    ENDTRY.

    CREATE DATA ls_extensibility_fields_header.
    LOOP AT ls_testdata-ext_fields_item ASSIGNING FIELD-SYMBOL(<ls_ext_field_header>).
      IF <ls_ext_field_header>-type = 'H'.
        ls_extensibility_fields_header->key = '0000000000000000'.
        ls_ext_field = |ls_extensibility_fields_header->data-{ <ls_ext_field_header>-name }|.
        ASSIGN (ls_ext_field) TO <ex_field_structure>.
        <ex_field_structure> = <ls_ext_field_header>-expected_input.

        ls_ext_field = |ls_extensibility_fields_header->datax-{ <ls_ext_field_header>-name }|.
        ASSIGN (ls_ext_field) TO <ex_field_structure>.
        <ex_field_structure> = 'X'.
      ENDIF.
    ENDLOOP.

    lo_bapi_mapping = cl_cfd_bapi_mapping=>get_instance( ).
    TRY.
        lo_bapi_mapping->map_to_bapiparex_single(
          EXPORTING
            ir_source_structure = ls_extensibility_fields_header
          CHANGING
            ct_bapiparex        = lt_bapiparex ).
      CATCH cx_root.
    ENDTRY.

    IF ls_testdata-purch_number IS INITIAL.
      ls_order_header_in-purch_no_c = 'CustRefPTF'.
    ELSE.
      ls_order_header_in-purch_no_c = ls_testdata-purch_number.
    ENDIF.


*****************************************************************************
* 4 Step: Create and commit Sales Order
    CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
      EXPORTING
        sales_header_in     = ls_order_header_in
        sales_header_inx    = ls_order_header_in_x
      IMPORTING
        salesdocument_ex    = lv_vbeln
      TABLES
        return              = lt_return
        extensionin         = lt_bapiparex
        extensionex         = lt_extensionex
        sales_items_in      = lt_order_items
        sales_items_inx     = lt_order_items_x
        sales_partners      = lt_order_partners
        sales_schedules_in  = lt_schedules
        sales_conditions_in = ls_testdata-condition
        partneraddresses    = ls_testdata-adress_data
        sales_text          = lt_sales_text.

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ls_ret_mes>).
      me->mo_run_environment->append_log( iv_log_statement = |{ <ls_ret_mes>-message }| ).
    ENDLOOP.
*****************************************************************************
* 5 Step: Check Billing Block and Remove it
*    if ls_testdata-billing_block is initial.
    DATA: lv_ptf_key TYPE ptfkey.
*      move lv_vbeln to lv_ptf_key.
*      me->remove_billing_block( iv_order_number = lv_ptf_key ).
*    endif.
*****************************************************************************

* 6 Step: Check whether Sales Order exists
    CLEAR lv_ptf_key.
    MOVE lv_vbeln TO lv_ptf_key.
    IF lv_vbeln IS NOT INITIAL.
      ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).
    ENDIF.
    IF ev_execution_status EQ abap_true.
      APPEND lv_ptf_key TO ev_document_id.
    ENDIF.
  ENDMETHOD.


  METHOD create_return_ref.

    DATA: ls_testdata                    TYPE ty_gs_i_ptf_or_cr_td,
          ls_order_header_in_x           TYPE bapisdhd1x,
          ls_order_header_in             TYPE bapisdhd1,
          lt_extensionex                 TYPE TABLE OF bapiparex,
          ls_extensibility_fields_header TYPE REF TO bape_sdsalesdoc,
          lt_order_partners              TYPE TABLE OF bapiparnr,
          lt_order_items                 TYPE TABLE OF bapisditm,
          lt_order_items_x               TYPE TABLE OF bapisditmx,
          ls_order_item_x                TYPE bapisditmx,
          lt_schedules                   TYPE TABLE OF bapischdl,
          ls_return                      TYPE bapiret2,
          lt_return                      TYPE TABLE OF bapiret2,
          lv_vbeln                       TYPE vbeln,
          lo_bapi_mapping                TYPE REF TO if_cfd_bapi_mapping,
          lt_extensibility_fields_item   TYPE TABLE OF bape_sdsalesdocitem,
          ls_extensibility_fields_item   TYPE bape_sdsalesdocitem,
          lt_bapiparex                   TYPE bapiparextab,
          ls_i_salesitemproposalitemtp   TYPE i_salesitemproposalitemtp,
          ls_prpsl_item                  TYPE bapisditm,
          lv_next_itm_number             TYPE i,
          lt_sales_conditions_in         TYPE TABLE OF bapicond,
          ls_ext_field                   TYPE string,
          ls_tvak                        TYPE tvak,
          lv_key                         TYPE i,
          lv_key_as_string               TYPE string,
          lv_key_add                     TYPE i,
          lr_header_bapi_ext             TYPE REF TO bape_sdsalesdoc,
          lr_item_bapi_ext               TYPE REF TO bape_sdsalesdoc,
          lt_sales_text                  TYPE ty_bapisdtext.

    FIELD-SYMBOLS: <gfs_field>          TYPE any,
                   <ex_field_structure> TYPE any.

*****************************************************************************
* 1 Step: get tdcv
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_prestepnumbr>).
      DATA(ls_predecessor) = me->mo_run_environment->get_step_data( iv_step_number = <lv_prestepnumbr> ).
      IF ls_predecessor-document_id  IS NOT INITIAL.
        LOOP AT ls_predecessor-document_id INTO DATA(ls_vbeln).
          ls_order_header_in-ref_doc = ls_vbeln.
        ENDLOOP.
      ENDIF.
    ENDLOOP.

*****************************************************************************
* 3 Step: Prepare Testdata for 'SD_SALESDOCUMENT_CREATE'
    CALL METHOD prepare_testdata_create
      EXPORTING
        iv_vbeln           = ls_order_header_in-ref_doc
        ls_testdata        = ls_testdata
      IMPORTING
        ls_order_header_in = ls_order_header_in
        lt_order_partners  = lt_order_partners
        lt_order_items     = lt_order_items
        lt_schedules       = lt_schedules
        lt_sales_text      = lt_sales_text.

*****************************************************************************
    ls_order_header_in-refdoctype  = 'LK'.
*    ls_order_header_in-ref_doc     = 'LK'.
    ls_order_header_in-ref_doc_l   = '00010'.
    ls_order_header_in-refdoc_cat  = 'F'.

    "ls_order_header_in_x-updateflag  = 'I'.
    ls_order_header_in_x-doc_type    = 'X'.
    ls_order_header_in_x-sales_org   = 'X'.
    ls_order_header_in_x-distr_chan  = 'X'.
    ls_order_header_in_x-division    = 'X'.
    ls_order_header_in_x-pp_search   = 'X'.
    ls_order_header_in_x-ct_valid_f  = 'X'.
    ls_order_header_in_x-ct_valid_t  = 'X'.

    ls_order_header_in_x-ref_doc     = 'X'.
    ls_order_header_in_x-ref_doc_l   = 'X'.
    ls_order_header_in_x-refdoc_cat  = 'X'.

    CLEAR ls_order_item_x.
    "ls_order_item_x-updateflag = 'I'.
    ls_order_item_x-material   = 'X'.
    ls_order_item_x-target_qty = 'X'.
    ls_order_item_x-target_qu  = 'X'.

    SELECT SINGLE * FROM tvak INTO @ls_tvak
        WHERE auart = @ls_order_header_in-doc_type.

    IF ls_tvak IS NOT INITIAL.
      lv_key_add = ls_tvak-incpo.
    ELSE.
      lv_key_add = 10.
    ENDIF.
    lv_key = lv_key_add.


    "Fill Ext fields for items
    LOOP AT lt_order_items ASSIGNING FIELD-SYMBOL(<ls_order_item>).

      <ls_order_item>-ref_doc     = ls_order_header_in-ref_doc.
      <ls_order_item>-ref_doc_it  = '00010'.
      <ls_order_item>-ref_doc_ca = 'F'.

      ls_order_item_x-itm_number = <ls_order_item>-itm_number.
      ls_order_item_x-ref_doc    = 'X'.
      ls_order_item_x-ref_doc_it = 'X'.
      ls_order_item_x-ref_doc_ca = 'X'.
      APPEND ls_order_item_x TO lt_order_items_x.

      CLEAR ls_extensibility_fields_item.
      lv_key_as_string = lv_key.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_key_as_string
        IMPORTING
          output = ls_extensibility_fields_item-key.
      IF ls_testdata-ext_fields_item IS NOT INITIAL.
        LOOP AT ls_testdata-ext_fields_item ASSIGNING FIELD-SYMBOL(<ls_ext_field>).
          IF <ls_ext_field>-type EQ 'P'.
            ls_ext_field = |ls_extensibility_fields_item-data-{ <ls_ext_field>-name }|.
            ASSIGN (ls_ext_field) TO <ex_field_structure>.
            IF <ex_field_structure> IS ASSIGNED.
              <ex_field_structure> = <ls_ext_field>-expected_input.
            ENDIF.


            ls_ext_field = |ls_extensibility_fields_item-datax-{ <ls_ext_field>-name }|.
            ASSIGN (ls_ext_field) TO <ex_field_structure>.
            IF <ex_field_structure> IS ASSIGNED.
              <ex_field_structure> = 'X'.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.

      APPEND ls_extensibility_fields_item TO lt_extensibility_fields_item.
      lv_key = lv_key + lv_key_add.
    ENDLOOP.

*   map the Extensibility fields into a suitable EXTENSIONIN format
    lo_bapi_mapping = cl_cfd_bapi_mapping=>get_instance( ).
    GET REFERENCE OF lt_extensibility_fields_item INTO DATA(lr_ci_item_bapi_tab).
    TRY.
        lo_bapi_mapping->map_to_bapiparex_multi(
          EXPORTING
            ir_source_table = lr_ci_item_bapi_tab
          CHANGING
            ct_bapiparex    = lt_bapiparex ).
      CATCH cx_root.
    ENDTRY.

    CREATE DATA ls_extensibility_fields_header.
    LOOP AT ls_testdata-ext_fields_item ASSIGNING FIELD-SYMBOL(<ls_ext_field_header>).
      IF <ls_ext_field_header>-type = 'H'.
        ls_extensibility_fields_header->key = '0000000000000000'.
        ls_ext_field = |ls_extensibility_fields_header->data-{ <ls_ext_field_header>-name }|.
        ASSIGN (ls_ext_field) TO <ex_field_structure>.
        <ex_field_structure> = <ls_ext_field_header>-expected_input.

        ls_ext_field = |ls_extensibility_fields_header->datax-{ <ls_ext_field_header>-name }|.
        ASSIGN (ls_ext_field) TO <ex_field_structure>.
        <ex_field_structure> = 'X'.
      ENDIF.
    ENDLOOP.

    lo_bapi_mapping = cl_cfd_bapi_mapping=>get_instance( ).
    TRY.
        lo_bapi_mapping->map_to_bapiparex_single(
          EXPORTING
            ir_source_structure = ls_extensibility_fields_header
          CHANGING
            ct_bapiparex        = lt_bapiparex ).
      CATCH cx_root.
    ENDTRY.

    IF ls_testdata-purch_number IS INITIAL.
      ls_order_header_in-purch_no_c = 'CustRefPTF'.
    ELSE.
      ls_order_header_in-purch_no_c = ls_testdata-purch_number.
    ENDIF.


*****************************************************************************
* 4 Step: Create and commit Sales Order
    CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
      EXPORTING
        sales_header_in     = ls_order_header_in
        sales_header_inx    = ls_order_header_in_x
      IMPORTING
        salesdocument_ex    = lv_vbeln
      TABLES
        return              = lt_return
        extensionin         = lt_bapiparex
        extensionex         = lt_extensionex
        sales_items_in      = lt_order_items
        sales_items_inx     = lt_order_items_x
        sales_partners      = lt_order_partners
        sales_schedules_in  = lt_schedules
        sales_conditions_in = lt_sales_conditions_in
        partneraddresses    = ls_testdata-adress_data
        sales_text          = lt_sales_text.

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ls_ret_mes>).
      me->mo_run_environment->append_log( iv_log_statement = |{ <ls_ret_mes>-message }| ).
    ENDLOOP.
*****************************************************************************
* 5 Step: Check Billing Block and Remove it
    IF ls_testdata-billing_block IS INITIAL.
      DATA: lv_ptf_key TYPE ptfkey.
      MOVE lv_vbeln TO lv_ptf_key.
      me->remove_billing_block( iv_order_number = lv_ptf_key ).
    ENDIF.
*****************************************************************************
* 6 Step: Check whether Sales Order exists
    CLEAR lv_ptf_key.
    MOVE lv_vbeln TO lv_ptf_key.
    ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).
    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ls_return>) WHERE message_v3 IS NOT INITIAL AND type = 'S'.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <ls_return>-message_v3
        IMPORTING
          output = lv_vbeln.
      lv_ptf_key = lv_vbeln.
    ENDLOOP.
    IF ev_execution_status EQ abap_true.
      APPEND lv_ptf_key TO ev_document_id.
    ENDIF.
    DO 15 TIMES.
      SELECT SINGLE vbeln FROM likp INTO @DATA(ls_vbeln1) WHERE vbeln =  @lv_vbeln.
      IF sy-subrc NE 0.
        WAIT UP TO 1 SECONDS.
      ELSE.
        EXIT.
      ENDIF.
    ENDDO.

  ENDMETHOD.


  METHOD create_so01.

    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/CPD/SC_PROJ_ENGMT_CREATE_UPD_SRV/'.
    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    DATA lt_parameters TYPE /iwfnd/sutil_property_t.
    DATA ls_response TYPE REF TO data.
    DATA lt_customerproject TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA:
      ls_tdc     TYPE ty_gs_i_ptf_so_cr_so01_td,
      ls_so      TYPE ty_gs_i_ptf_so_cr_so01_td,
      ls_so_item TYPE /cpd/cl_sc_proj_engmt__dpc_ext=>tcs_deep_slsorditem,
      lt_so_item TYPE /cpd/cl_sc_proj_engmt__dpc_ext=>tct_deep_slsorditem,
      lt_wp      TYPE STANDARD TABLE OF /cpd/cl_sc_proj_engmt__mpc=>ts_a_custprojslsorditemworkpck WITH EMPTY KEY,
      ls_wp      TYPE /cpd/cl_sc_proj_engmt__mpc=>ts_a_custprojslsorditemworkpck,
      lt_bp      TYPE STANDARD TABLE OF /cpd/cl_sc_proj_engmt__mpc=>ts_a_custprojslsorditmbillgpln WITH EMPTY KEY,
      ls_bp      TYPE /cpd/cl_sc_proj_engmt__mpc=>ts_a_custprojslsorditmbillgpln.

    DATA lv_salesorder TYPE vbeln.

*   Get test data container variant
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_tdc
    ).

*   Get Project ID
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_customerproject.
    ENDLOOP.

    IF lt_customerproject IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No project available from referenced step.| ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.

    ls_so-customerproject = lt_customerproject[ 1 ].

*   Assign defaultet WP from Project
    CONCATENATE ls_so-customerproject'.1.1' INTO ls_wp-workpackage.
    APPEND ls_wp TO lt_wp.

*   Add billing plan data
*    ls_bp-billingplanbillingdate = ls_tdc-TO_CUSTPROJSLSORDITEM[ 1 ]-to_custprojsoibillgplnitm[ 1 ]-billingplanbillingdate.
    ls_bp-billingplanbillingdate = sy-datum.
*    ls_bp-billingplanamount = ls_tdc-TO_CUSTPROJSLSORDITEM[ 1 ]-to_custprojsoibillgplnitm[ 1 ]-billingplanamount.

    IF ls_step_data-variant = 'SO01_CR_FP_1'.
      ls_bp-billingplanamount = '100'.
      ls_bp-transactioncurrency = ls_tdc-to_custprojslsorditem[ 1 ]-to_custprojsoibillgplnitm[ 1 ]-transactioncurrency.
      ls_bp-billingplanitemdescription = ls_tdc-to_custprojslsorditem[ 1 ]-to_custprojsoibillgplnitm[ 1 ]-billingplanitemdescription.
    ENDIF.

    IF ls_step_data-variant = 'SO01_CR_TE_1'.
      ls_bp-billingplanitemusage = ' '.
    ENDIF.

    IF ls_step_data-variant = 'SO01_CR_PS_1'.
      ls_bp-billingplanitemusage = ' '.
      ls_bp-billingplanamount = '100'.
      ls_bp-billingplanservicestartdate = sy-datum.
      ls_bp-billingplanserviceenddate = sy-datum.
      ls_bp-transactioncurrency = 'EUR'.
    ENDIF.

    APPEND ls_bp TO lt_bp.

*   Add Sales Order for Services Data
    ls_so-purchaseorderbycustomer = ls_tdc-purchaseorderbycustomer.

    ls_so_item-salesorderitem = ls_tdc-to_custprojslsorditem[ 1 ]-salesorderitem.
    ls_so_item-salesorderitemcategory = ls_tdc-to_custprojslsorditem[ 1 ]-salesorderitemcategory.
    ls_so_item-material = ls_tdc-to_custprojslsorditem[ 1 ]-material.
*    ls_so_item-expectednetamount = ls_tdc-TO_CUSTPROJSLSORDITEM[ 1 ]-expectednetamount.
    ls_so_item-expectednetamount = '100'.
    ls_so_item-transactioncurrency = ls_tdc-to_custprojslsorditem[ 1 ]-transactioncurrency.
    APPEND ls_so_item TO lt_so_item.

    ls_so-to_custprojslsorditem = lt_so_item.
    ls_so-to_custprojslsorditem[ 1 ]-to_custprojslsorditemworkpckg = lt_wp.
    ls_so-to_custprojslsorditem[ 1 ]-to_custprojsoibillgplnitm = lt_bp.


    DATA(lv_payload) = /ui2/cl_json=>serialize(
                EXPORTING
                    data            = ls_so
                    pretty_name     = /ui2/cl_json=>pretty_mode-user_low_case
                    name_mappings   = VALUE /ui2/cl_json=>name_mappings(
        ( abap = 'CUSTOMERPROJECT' json = 'CustomerProject' )
        ( abap = 'PURCHASEORDERBYCUSTOMER' json = 'PurchaseOrderByCustomer' )
        ( abap = 'CUSTOMERPURCHASEORDERDATE' json = 'CustomerPurchaseOrderDate' )
        ( abap = 'TRANSACTIONCURRENCY' json = 'TransactionCurrency' )
        ( abap = 'SALESORDERITEM' json = 'SalesOrderItem' )
        ( abap = 'TO_CUSTPROJSLSORDITEM' json = 'to_CustProjSlsOrdItem' )
          ( abap = 'SALESORDERITEMCATEGORY' json = 'SalesOrderItemCategory' )
          ( abap = 'MATERIAL' json = 'Material' )
          ( abap = 'EXPECTEDNETAMOUNT' json = 'ExpectedNetAmount' )
        ( abap = 'TO_CUSTPROJSOIBILLGPLNITM' json = 'to_CustProjSOIBillgPlnItm' )
          ( abap = 'BILLINGPLANBILLINGDATE' json = 'BillingPlanBillingDate' )
          ( abap = 'BILLINGPLANAMOUNT' json = 'BillingPlanAmount' )
          ( abap = 'BILLINGPLANITEMDESCRIPTION' json = 'BillingPlanItemDescription' )
          ( abap = 'BILLINGPLANITEMUSAGE' json = 'BillingPlanItemUsage' )
          ( abap = 'BILLINGPLANSERVICESTARTDATE' json = 'BillingPlanServiceStartDate' )
          ( abap = 'BILLINGPLANSERVICEENDDATE' json = 'BillingPlanServiceEndDate' )
        ( abap = 'TO_CUSTPROJSLSORDITEMWORKPCKG' json = 'to_CustProjSlsOrdItemWorkPckg' )
          ( abap = 'WORKPACKAGE' json = 'WorkPackage' )
        )
                    compress        = abap_true
              ).
    DATA(lv_payload_temp) = lv_payload.

    CASE ls_step_data-variant.

      WHEN 'SO01_CR_FP_1'.
        CONCATENATE lv_payload_temp(118)'"'         lv_payload_temp+118 INTO lv_payload_temp.
        CONCATENATE lv_payload_temp(121)'"'         lv_payload_temp+121 INTO lv_payload_temp.
        CONCATENATE lv_payload_temp(193)'"'         lv_payload_temp+193 INTO lv_payload_temp.
        CONCATENATE lv_payload_temp(197)'"'         lv_payload_temp+200 INTO lv_payload_temp.
        CONCATENATE lv_payload_temp(366)'T00:00:00' lv_payload_temp+366 INTO lv_payload_temp.
        CONCATENATE lv_payload_temp(397)'"'         lv_payload_temp+397 INTO lv_payload_temp.
        CONCATENATE lv_payload_temp(401)'"'         lv_payload_temp+404 INTO lv_payload_temp.
      WHEN 'SO01_CR_TE_1'.
        CONCATENATE lv_payload_temp(118)'"'         lv_payload_temp+118 INTO lv_payload_temp.
        CONCATENATE lv_payload_temp(121)'"'         lv_payload_temp+121 INTO lv_payload_temp.
        CONCATENATE lv_payload_temp(193)'"'         lv_payload_temp+193 INTO lv_payload_temp.
        CONCATENATE lv_payload_temp(197)'"'         lv_payload_temp+200 INTO lv_payload_temp.
        CONCATENATE lv_payload_temp(366)'T00:00:00' lv_payload_temp+366 INTO lv_payload_temp.
      WHEN 'SO01_CR_PS_1'.
        CONCATENATE lv_payload_temp(118)'"'         lv_payload_temp+118 INTO lv_payload_temp.
        CONCATENATE lv_payload_temp(121)'"'         lv_payload_temp+121 INTO lv_payload_temp.
        CONCATENATE lv_payload_temp(193)'"'         lv_payload_temp+193 INTO lv_payload_temp.
        CONCATENATE lv_payload_temp(197)'"'         lv_payload_temp+200 INTO lv_payload_temp.
        CONCATENATE lv_payload_temp(366)'T00:00:00' lv_payload_temp+366 INTO lv_payload_temp.
        CONCATENATE lv_payload_temp(397)'"'         lv_payload_temp+397 INTO lv_payload_temp.
        CONCATENATE lv_payload_temp(401)'"'         lv_payload_temp+404 INTO lv_payload_temp.
        CONCATENATE lv_payload_temp(472)'T00:00:00' lv_payload_temp+472 INTO lv_payload_temp.
        CONCATENATE lv_payload_temp(522)'T00:00:00' lv_payload_temp+522 INTO lv_payload_temp.
      WHEN OTHERS.

    ENDCASE.


    lv_payload = lv_payload_temp.

    lo_odata_caller->call_service(
      EXPORTING
        iv_method           = 'POST'
        iv_action_or_entity = 'A_CustProjSlsOrd'
        iv_payload          = lv_payload
      IMPORTING
        ev_status_code      = DATA(lv_status_code)
        ev_status_text      = DATA(lv_status_text)
        es_json_response    = ls_response
    ).

    IF lv_status_text = 'Created'.
      SELECT SINGLE salesorder FROM i_custprojslsord INTO @lv_salesorder WHERE customerproject = @ls_so-customerproject.
      APPEND lv_salesorder TO ev_document_id.
      ev_execution_status = abap_true.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |Could not create sales order.| ).
      ev_execution_status = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD create_so_api.

    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/sap/API_SALES_ORDER_SRV/'.
    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    DATA lt_parameters TYPE /iwfnd/sutil_property_t.
    DATA ls_response TYPE REF TO data.
    DATA lt_salesorder TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA:
      ls_tdc     TYPE ty_gs_i_ptf_or_cr_td,
      ls_so      TYPE ty_gs_i_ptf_or_cr_td,
      ls_so_item TYPE cl_sd_api_sales_order_dpc_ext=>tcs_deep_item,
      lt_so_item TYPE cl_sd_api_sales_order_dpc_ext=>tct_deep_item,
      lt_bp      TYPE STANDARD TABLE OF /cpd/cl_sc_proj_engmt__mpc=>ts_a_custprojslsorditmbillgpln WITH EMPTY KEY,
      ls_bp      TYPE /cpd/cl_sc_proj_engmt__mpc=>ts_a_custprojslsorditmbillgpln.

    DATA lv_salesorder TYPE vbeln.

*   Get test data container variant
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_tdc
    ).

*   Get Sales order ID
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_salesorder.
    ENDLOOP.

    APPEND ls_bp TO lt_bp.
    APPEND ls_so_item TO lt_so_item.

    DATA(lv_payload) = /ui2/cl_json=>serialize(
                EXPORTING
                    data            = ls_so
                    pretty_name     = /ui2/cl_json=>pretty_mode-user_low_case
                    name_mappings   = VALUE /ui2/cl_json=>name_mappings(
        ( abap = 'CUSTOMERPROJECT' json = 'CustomerProject' )
        ( abap = 'PURCHASEORDERBYCUSTOMER' json = 'PurchaseOrderByCustomer' )
        ( abap = 'CUSTOMERPURCHASEORDERDATE' json = 'CustomerPurchaseOrderDate' )
        ( abap = 'TRANSACTIONCURRENCY' json = 'TransactionCurrency' )
        ( abap = 'SALESORDERITEM' json = 'SalesOrderItem' )
        ( abap = 'TO_CUSTPROJSLSORDITEM' json = 'to_CustProjSlsOrdItem' )
          ( abap = 'SALESORDERITEMCATEGORY' json = 'SalesOrderItemCategory' )
          ( abap = 'MATERIAL' json = 'Material' )
          ( abap = 'EXPECTEDNETAMOUNT' json = 'ExpectedNetAmount' )
        ( abap = 'TO_CUSTPROJSOIBILLGPLNITM' json = 'to_CustProjSOIBillgPlnItm' )
          ( abap = 'BILLINGPLANBILLINGDATE' json = 'BillingPlanBillingDate' )
          ( abap = 'BILLINGPLANAMOUNT' json = 'BillingPlanAmount' )
          ( abap = 'BILLINGPLANITEMDESCRIPTION' json = 'BillingPlanItemDescription' )
          ( abap = 'BILLINGPLANITEMUSAGE' json = 'BillingPlanItemUsage' )
          ( abap = 'BILLINGPLANSERVICESTARTDATE' json = 'BillingPlanServiceStartDate' )
          ( abap = 'BILLINGPLANSERVICEENDDATE' json = 'BillingPlanServiceEndDate' )
        ( abap = 'TO_CUSTPROJSLSORDITEMWORKPCKG' json = 'to_CustProjSlsOrdItemWorkPckg' )
          ( abap = 'WORKPACKAGE' json = 'WorkPackage' )
        )
                    compress        = abap_true
              ).
    DATA(lv_payload_temp) = lv_payload.

    lo_odata_caller->call_service(
      EXPORTING
        iv_method           = 'POST'
        iv_action_or_entity = 'A_SalesOrder'
        iv_payload          = lv_payload
      IMPORTING
        ev_status_code      = DATA(lv_status_code)
        ev_status_text      = DATA(lv_status_text)
        es_json_response    = ls_response
    ).

    IF lv_status_text = 'Created'.
      SELECT SINGLE salesorder FROM i_salesorder INTO @lv_salesorder WHERE salesorder = @ls_so-customer_id.
      APPEND lv_salesorder TO ev_document_id.
      ev_execution_status = abap_true.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |Could not create sales order.| ).
      ev_execution_status = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD create_with_reference.
    DATA:
      ls_testdata TYPE ty_gs_i_ptf_or_cr_td,
      lv_vbak     TYPE vbak.
*      lv_vbap     type vbap.

    DATA: ls_load_parameter TYPE tds_goal_so_load.
    DATA: ls_head_data TYPE tds_goal_so_head.
    DATA: lt_item_data TYPE STANDARD TABLE OF tds_goal_so_item.
    DATA: lo_access TYPE REF TO if_goal_access.
    DATA: ls_error TYPE if_goal_types=>tcs_error.
    DATA: lv_bo_key TYPE if_goal_types=>tcd_bo_key.
    DATA: lx_goal_exc TYPE REF TO cx_goal_exc.
    DATA: lv_text_exc TYPE string.
    DATA: ls_field_property TYPE if_goal_types=>tcs_object_property.
    DATA: lt_field_property TYPE if_goal_types=>tct_object_property.
*    data: ls_control_settings type if_goal_access=>tcs_control_settings.
*    data: ls_changed_field type if_goal_types=>tcs_changed_field.
*    data: lt_changed_field type if_goal_types=>tct_changed_field.
*    data: lv_field type fieldname.
*    data: lt_handle_reuse type if_goal_types=>tct_handle_reuse.
*    data: lv_handle_head type if_goal_types=>tcd_handle.
*    data: ls_action type if_goal_types=>tcs_action.
*    data: ls_reference type tds_goal_sdoc_ref.
    DATA: lt_message TYPE if_goal_types=>tct_message.
    DATA: iv_vbeln TYPE vbeln_va,
          lt_vbeln TYPE cl_ptf_util=>ty_vbeln_tab.

*****************************************************************************
* get tdcv
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

    IF ls_testdata IS INITIAL. "Cannot merge both conditions, because ls_testdata could be null
      me->mo_run_environment->append_log( iv_log_statement = |Cannot delcare document type to be created .| ).
      ev_execution_status = abap_false.
      RETURN.
    ELSEIF ls_testdata-document_type IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Cannot delcare document type to be created .| ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.

*************************************************************************
*Check Predecessor Status
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    IF lt_vbeln IS NOT INITIAL.
      LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<lv_vbel>).
        SELECT SINGLE * FROM vbak WHERE vbeln = @<lv_vbel>-vbeln INTO @lv_vbak.
        IF lv_vbak IS INITIAL.
          "Document not found
          me->mo_run_environment->append_log( iv_log_statement = |Could not find Quotation { <lv_vbel>-vbeln }.| ).
          ev_execution_status = abap_false.
          RETURN.
        ELSE.
          ls_load_parameter-type_code = ls_testdata-document_type.
          ls_load_parameter-ref_document_id = lv_vbak-vbeln.

          TRY.
              CALL METHOD cl_goal_api=>so_instance->create
                EXPORTING
                  iv_bo_id          = if_goal_sdoc=>co_bo_id-salesorder
                  is_load_parameter = ls_load_parameter
                RECEIVING
                  ro_access         = lo_access.
            CATCH cx_goal_exc INTO lx_goal_exc.
              me->mo_run_environment->append_log( iv_log_statement = lx_goal_exc->get_text( ) ).
              ev_execution_status = abap_false.
              "lv_text_exc = lx_goal_exc->get_text( ).
              "MESSAGE lv_text_exc TYPE 'I'.
              EXIT.
          ENDTRY.

***************************************************************************
* read header data
          CALL METHOD lo_access->get_entity
            EXPORTING
              iv_entity_id   = if_goal_sdoc_head=>co_entity_id
            IMPORTING
              es_entity_data = ls_head_data.
* read item data
          CALL METHOD lo_access->get_entity_set
            EXPORTING
              iv_entity_id      = if_goal_sdoc_item=>co_entity_id
              iv_handle_parent  = ls_head_data-handle
            IMPORTING
              et_entity_data    = lt_item_data
              et_field_property = lt_field_property.
***************************************************************************
          lo_access->save( IMPORTING ev_bo_key = iv_vbeln ).

          IF iv_vbeln IS NOT INITIAL.
            me->mo_run_environment->append_log( iv_log_statement = |Created sales order with ID: { iv_vbeln }.| ).
            APPEND iv_vbeln TO ev_document_id.
            ev_execution_status = abap_true.
          ELSE.
            me->mo_run_environment->append_log( iv_log_statement = |Could not create sales order.| ).
            ev_execution_status = abap_false.
            RETURN.
          ENDIF.

        ENDIF.

      ENDLOOP.


      DATA: lv_ptf_key TYPE ptfkey.
      MOVE iv_vbeln TO lv_ptf_key.
      cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
    ENDIF.

  ENDMETHOD.


  METHOD create_with_reference_lk.

    DATA:
      ls_testdata TYPE ty_gs_i_ptf_or_cr_td,
      lv_vbak     TYPE vbak.
*      lv_vbap     type vbap.

    DATA: ls_load_parameter TYPE tds_goal_so_load.
    DATA: ls_head_data TYPE tds_goal_so_head.
    DATA: lt_item_data TYPE STANDARD TABLE OF tds_goal_so_item.
    DATA: lo_access TYPE REF TO if_goal_access.
    DATA: ls_error TYPE if_goal_types=>tcs_error.
    DATA: lv_bo_key TYPE if_goal_types=>tcd_bo_key.
    DATA: lx_goal_exc TYPE REF TO cx_goal_exc.

    DATA: lv_text_exc TYPE string.
    DATA: ls_field_property TYPE if_goal_types=>tcs_object_property.
    DATA: lt_field_property TYPE if_goal_types=>tct_object_property.

    DATA: lt_message TYPE if_goal_types=>tct_message.
    DATA: iv_vbeln    TYPE vbeln_va,
          ls_item_ref TYPE tds_goal_sdoc_item_ref,
          lt_bapiret  TYPE bapiret2_t,
          lt_vbeln    TYPE cl_ptf_util=>ty_vbeln_tab.

*****************************************************************************
* get tdcv
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

    IF ls_testdata IS INITIAL. "Cannot merge both conditions, because ls_testdata could be null
      me->mo_run_environment->append_log( iv_log_statement = |Cannot delcare document type to be created .| ).
      ev_execution_status = abap_false.
      RETURN.
    ELSEIF ls_testdata-document_type IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Cannot delcare document type to be created .| ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.

*************************************************************************
*Check Predecessor Status
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    IF lt_vbeln IS NOT INITIAL.
      LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<lv_vbel>).
        SELECT SINGLE * FROM vbak WHERE vbeln = @<lv_vbel>-vbeln INTO @lv_vbak.
        IF lv_vbak IS INITIAL.
          "Document not found
          me->mo_run_environment->append_log( iv_log_statement = |Could not find Quotation { <lv_vbel>-vbeln }.| ).
          ev_execution_status = abap_false.
          RETURN.
        ELSE.
          ls_load_parameter-type_code = ls_testdata-document_type.
          ls_load_parameter-ref_document_id = lv_vbak-vbeln.
*          ADD ITEM DATA
          IF ls_testdata-item_list IS NOT INITIAL.
            LOOP AT  ls_testdata-item_list INTO DATA(ls_item).
              IF ls_item-item_category IS NOT INITIAL.
                ls_load_parameter-category_code = ls_item-item_category.
              ENDIF.
              ls_item_ref-item_id         = ls_item-posnr.
              ls_item_ref-quantity        = ls_item-quantity.
*              ls_item_ref-sales_uom       = ls_item-sales_measure_unit_code.
              APPEND ls_item_ref TO ls_load_parameter-ref_item_list.
            ENDLOOP.
          ENDIF.
          TRY.
              CALL METHOD cl_goal_api=>so_instance->create
                EXPORTING
                  iv_bo_id          = if_goal_sdoc=>co_bo_id-salesorder
                  is_load_parameter = ls_load_parameter
                RECEIVING
                  ro_access         = lo_access.
            CATCH cx_goal_exc INTO lx_goal_exc.
              me->mo_run_environment->append_log( iv_log_statement = lx_goal_exc->get_text( ) ).
              ev_execution_status = abap_false.
              "lv_text_exc = lx_goal_exc->get_text( ).
              "MESSAGE lv_text_exc TYPE 'I'.
              EXIT.
          ENDTRY.

*
          lo_access->save( IMPORTING ev_bo_key = iv_vbeln ).

          CALL METHOD lo_access->get_messages
            IMPORTING
              et_message = lt_message
              es_error   = ls_error.

          CALL METHOD lo_access->close( ).
          IF ls_error IS NOT INITIAL.
            APPEND VALUE #( type        = ls_error-msgty
                            number      = ls_error-msgno
                            id          = ls_error-msgid
                            message_v1  = ls_error-msgv1
                            message_v2  = ls_error-msgv2
                            message_v3  = ls_error-msgv3
                            message_v4  = ls_error-msgv4
                            message     = ls_error-msgtx
               ) TO lt_bapiret.
          ENDIF.

          LOOP AT lt_message ASSIGNING FIELD-SYMBOL(<goal_msg>) WHERE msgid = 'V1' AND msgno = '260'.
            APPEND VALUE #( type        = <goal_msg>-msgty
                            number      = <goal_msg>-msgno
                            id          = <goal_msg>-msgid
                            message_v1  = <goal_msg>-msgv1
                            message_v2  = <goal_msg>-msgv2
                            message_v3  = <goal_msg>-msgv3
                            message_v4  = <goal_msg>-msgv4
                            message     = <goal_msg>-msgtx
               ) TO lt_bapiret.

            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = <goal_msg>-msgv3
              IMPORTING
                output = iv_vbeln.

          ENDLOOP.

          IF iv_vbeln IS NOT INITIAL.
            me->mo_run_environment->append_log( iv_log_statement = |Created sales order with ID: { iv_vbeln }.| ).
            APPEND iv_vbeln TO ev_document_id.
            ev_execution_status = abap_true.
          ELSE.
            me->mo_run_environment->append_log( iv_log_statement = |Could not create sales order.| ).
            ev_execution_status = abap_false.
            RETURN.
          ENDIF.

        ENDIF.

      ENDLOOP.


      DATA: lv_ptf_key TYPE ptfkey.
      MOVE iv_vbeln TO lv_ptf_key.
      cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
    ENDIF.
  ENDMETHOD.


  METHOD create_with_reference_to_bd.
    DATA:
      ls_testdata TYPE ty_gs_i_ptf_or_cr_td,
      lv_vbrk     TYPE vbrk.
*      lv_vbap     type vbap.

    DATA: ls_load_parameter TYPE tds_goal_so_load.
    DATA: ls_head_data TYPE tds_goal_so_head.
    DATA: lt_item_data TYPE STANDARD TABLE OF tds_goal_so_item.
    DATA: lo_access TYPE REF TO if_goal_access.
    DATA: ls_error TYPE if_goal_types=>tcs_error.
    DATA: lv_bo_key TYPE if_goal_types=>tcd_bo_key.
    DATA: lx_goal_exc TYPE REF TO cx_goal_exc.
    DATA: lv_text_exc TYPE string.
    DATA: ls_field_property TYPE if_goal_types=>tcs_object_property.
    DATA: lt_field_property TYPE if_goal_types=>tct_object_property.
*    data: ls_control_settings type if_goal_access=>tcs_control_settings.
*    data: ls_changed_field type if_goal_types=>tcs_changed_field.
*    data: lt_changed_field type if_goal_types=>tct_changed_field.
*    data: lv_field type fieldname.
*    data: lt_handle_reuse type if_goal_types=>tct_handle_reuse.
*    data: lv_handle_head type if_goal_types=>tcd_handle.
*    data: ls_action type if_goal_types=>tcs_action.
*    data: ls_reference type tds_goal_sdoc_ref.
    DATA: lt_message TYPE if_goal_types=>tct_message.
    DATA: iv_vbeln TYPE vbeln_va,
          lt_vbeln TYPE cl_ptf_util=>ty_vbeln_tab.

*****************************************************************************
* get tdcv
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

    IF ls_testdata IS INITIAL. "Cannot merge both conditions, because ls_testdata could be null
      me->mo_run_environment->append_log( iv_log_statement = |Cannot delcare document type to be created .| ).
      ev_execution_status = abap_false.
      RETURN.
    ELSEIF ls_testdata-document_type IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Cannot delcare document type to be created .| ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.

*************************************************************************
*Check Predecessor Status
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    IF lt_vbeln IS NOT INITIAL.
      LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<lv_vbel>).
        SELECT SINGLE * FROM vbrk WHERE vbeln = @<lv_vbel>-vbeln INTO @lv_vbrk.
        IF lv_vbrk IS INITIAL.
          "Document not found
          me->mo_run_environment->append_log( iv_log_statement = |Could not find billing document{ <lv_vbel>-vbeln }.| ).
          ev_execution_status = abap_false.
          RETURN.
        ELSE.
          ls_load_parameter-type_code = ls_testdata-document_type.
          ls_load_parameter-ref_document_id = lv_vbrk-vbeln.
          TRY.
              CALL METHOD cl_goal_api=>so_instance->create
                EXPORTING
                  iv_bo_id          = if_goal_sdoc=>co_bo_id-salesorder
                  is_load_parameter = ls_load_parameter
                RECEIVING
                  ro_access         = lo_access.
            CATCH cx_goal_exc INTO lx_goal_exc.
              me->mo_run_environment->append_log( iv_log_statement = lx_goal_exc->get_text( ) ).
              ev_execution_status = abap_false.
              "lv_text_exc = lx_goal_exc->get_text( ).
              "MESSAGE lv_text_exc TYPE 'I'.
              EXIT.
          ENDTRY.

***************************************************************************
* read header data
          CALL METHOD lo_access->get_entity
            EXPORTING
              iv_entity_id   = if_goal_sdoc_head=>co_entity_id
            IMPORTING
              es_entity_data = ls_head_data.
* read item data
          CALL METHOD lo_access->get_entity_set
            EXPORTING
              iv_entity_id      = if_goal_sdoc_item=>co_entity_id
              iv_handle_parent  = ls_head_data-handle
            IMPORTING
              et_entity_data    = lt_item_data
              et_field_property = lt_field_property.
***************************************************************************
          lo_access->save( IMPORTING ev_bo_key = iv_vbeln ).

          IF iv_vbeln IS NOT INITIAL.
            me->mo_run_environment->append_log( iv_log_statement = |Created sales order with ID: { iv_vbeln }.| ).
            APPEND iv_vbeln TO ev_document_id.
            ev_execution_status = abap_true.
          ELSE.
            me->mo_run_environment->append_log( iv_log_statement = |Could not create sales order.| ).
            ev_execution_status = abap_false.
            RETURN.
          ENDIF.

        ENDIF.

      ENDLOOP.


      DATA: lv_ptf_key TYPE ptfkey.
      MOVE iv_vbeln TO lv_ptf_key.
      cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
    ENDIF.

  ENDMETHOD.


  METHOD credit_release.
    DATA: doc_ids              TYPE TABLE OF vbeln.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(ref_doc_ids) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      LOOP AT ref_doc_ids ASSIGNING FIELD-SYMBOL(<ref_doc_id>).
        APPEND <ref_doc_id> TO doc_ids.
      ENDLOOP.
    ENDLOOP.

    LOOP AT doc_ids ASSIGNING FIELD-SYMBOL(<doc>).
      CALL FUNCTION 'SD_ORDER_CREDIT_RELEASE'
        EXPORTING
          vbeln       = <doc>
          if_synchron = 'X'.
      APPEND <doc> TO ev_document_id.

    ENDLOOP.

    ev_execution_status = abap_true.

  ENDMETHOD.


  METHOD delete.
    DATA: ls_header_inx TYPE bapisdh1x,
          ls_header_in  TYPE bapisdh1,
          ls_return     TYPE bapiret2,
          lt_return     TYPE cl_ptf_util=>gt_ptf_return_tab.

    ev_execution_status = abap_true.

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    ls_header_inx-updateflag  = 'D'.
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_prestepnumbr>).
      DATA(ls_predecessor) = me->mo_run_environment->get_step_data( iv_step_number = <ls_prestepnumbr> ).

      LOOP AT ls_predecessor-document_id ASSIGNING FIELD-SYMBOL(<ls_vbeln>).

        IF <ls_vbeln>-vbeln IS NOT INITIAL.

          DATA(lv_there_is_a_vbeln) = abap_true.

          CLEAR: lt_return.

          DATA: lv_vbeln TYPE vbeln.
          MOVE <ls_vbeln>-vbeln TO lv_vbeln.

          CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
            EXPORTING
              salesdocument    = lv_vbeln  " Order Number
              order_header_in  = ls_header_in
              order_header_inx = ls_header_inx  " Sales Order Check List
            TABLES
              return           = lt_return.  " Return Code

          LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ls_ret_mes>).
            me->mo_run_environment->append_log( iv_log_statement = |{ <ls_ret_mes>-message }| ).
            IF <ls_ret_mes>-type CA 'AEX'.
              ev_execution_status = abap_false.
              EXIT.
            ENDIF.
          ENDLOOP.

          IF ev_execution_status = abap_false.
            EXIT.
          ENDIF.

          cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

        ENDIF.

      ENDLOOP.

      IF ev_execution_status EQ abap_false.
        EXIT.
      ENDIF.
    ENDLOOP.

    IF lv_there_is_a_vbeln IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |There are no reference documents.| ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD delete_head_bpl_goal.
    DATA: lt_doc_ids TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings,
          lo_access           TYPE REF TO if_goal_access,
          ls_error            TYPE if_goal_types=>tcs_error,
          lx_goal_exc         TYPE REF TO cx_goal_exc,
          lv_text_exc         TYPE string,
          lv_field            TYPE fieldname,
          lv_deleted          TYPE abap_bool,
          ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
          lt_changed_field    TYPE if_goal_types=>tct_changed_field.

    DATA: lv_bo_key      TYPE if_goal_types=>tcd_bo_key,
          lt_item_data   TYPE STANDARD TABLE OF tds_goal_so_item,
          ls_head_data   TYPE tds_goal_so_head,
          ls_h_bplh_data TYPE tds_goal_sdoc_bplh,
          ls_h_bpli_data TYPE tds_goal_sdoc_bpli,
          lt_h_bpli_data TYPE STANDARD TABLE OF tds_goal_sdoc_bpli,
          lv_statement   TYPE bapi_msg.

    ev_execution_status = abap_false.

* 1 Step: get previously step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_doc_ids.
    ENDLOOP.

    READ TABLE lt_doc_ids INTO DATA(ls_doc_id) INDEX 1.
    IF sy-subrc = 0.
      lv_bo_key = ls_doc_id-vbeln.
    ENDIF.

    CHECK NOT lv_bo_key IS INITIAL.

* 2 Step: Access sales order via GOAL
* ===================================================
* open the document in change mode
* ===================================================
    TRY.
        CALL METHOD cl_goal_api=>so_instance->open
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_bo_key
            iv_read_only        = abap_false
            is_control_settings = ls_control_settings
          RECEIVING
            ro_access           = lo_access.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read header data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id   = if_goal_sdoc_head=>co_entity_id
          IMPORTING
            es_entity_data = ls_head_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read head billing plan header
* ===================================================
    CHECK NOT ls_head_data IS INITIAL.
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-head_bplh
            iv_handle_parent = ls_head_data-handle
          IMPORTING
            es_entity_data   = ls_h_bplh_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* get head billing plan item
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-head_bpli
            iv_handle_parent = ls_h_bplh_data-handle
          IMPORTING
            et_entity_data   = lt_h_bpli_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* delete head billing plan item
* ===================================================
    LOOP AT lt_h_bpli_data INTO ls_h_bpli_data.
      TRY.
          CALL METHOD lo_access->del_entity
            EXPORTING
              iv_handle  = ls_h_bpli_data-handle
            IMPORTING
              ev_deleted = lv_deleted.
        CATCH cx_goal_exc INTO lx_goal_exc.
          lv_text_exc = lx_goal_exc->get_text( ).
          me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
          EXIT.
      ENDTRY.
    ENDLOOP.

    lo_access->save( ).
    lo_access->get_messages( IMPORTING et_message = DATA(lt_message)
                                       es_error   = ls_error ).
    IF NOT ls_error IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = ls_error-msgtx ).
      lo_access->close( ).
      EXIT.
    ELSE.
      lo_access->close( ).
    ENDIF.

    lv_statement = 'Success: Delete header level billing plan dates was done!'.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ev_execution_status = abap_true.

    WAIT UP TO 7 SECONDS.
  ENDMETHOD.


  METHOD delete_item_bpl_goal.
    DATA: lt_doc_ids TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings,
          lo_access           TYPE REF TO if_goal_access,
          ls_error            TYPE if_goal_types=>tcs_error,
          lx_goal_exc         TYPE REF TO cx_goal_exc,
          lv_text_exc         TYPE string,
          lv_field            TYPE fieldname,
          lv_deleted          TYPE abap_bool,
          ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
          lt_changed_field    TYPE if_goal_types=>tct_changed_field.

    DATA: lv_bo_key      TYPE if_goal_types=>tcd_bo_key,
          lt_item_data   TYPE STANDARD TABLE OF tds_goal_so_item,
          ls_head_data   TYPE tds_goal_so_head,
          ls_i_bplh_data TYPE tds_goal_sdoc_bplh,
          ls_i_bpli_data TYPE tds_goal_sdoc_bpli,
          lt_i_bpli_data TYPE STANDARD TABLE OF tds_goal_sdoc_bpli,
          lv_statement   TYPE bapi_msg.

    ev_execution_status = abap_false.

* 1 Step: get previously step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_doc_ids.
    ENDLOOP.

    READ TABLE lt_doc_ids INTO DATA(ls_doc_id) INDEX 1.
    IF sy-subrc = 0.
      lv_bo_key = ls_doc_id-vbeln.
    ENDIF.

    CHECK NOT lv_bo_key IS INITIAL.

* 2 Step: Access sales order via GOAL
* ===================================================
* open the document in change mode
* ===================================================
    TRY.
        CALL METHOD cl_goal_api=>so_instance->open
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_bo_key
            iv_read_only        = abap_false
            is_control_settings = ls_control_settings
          RECEIVING
            ro_access           = lo_access.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read header data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id   = if_goal_sdoc_head=>co_entity_id
          IMPORTING
            es_entity_data = ls_head_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* read item data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id   = if_goal_sdoc_item=>co_entity_id
          IMPORTING
            et_entity_data = lt_item_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* read item billing plan header
* ===================================================
    READ TABLE lt_item_data INTO DATA(ls_item_data) INDEX 1.
    CHECK sy-subrc = 0.
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bplh
            iv_handle_parent = ls_item_data-handle
          IMPORTING
            es_entity_data   = ls_i_bplh_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* get item billing plan items
* ===================================================
    CHECK NOT ls_i_bplh_data IS INITIAL.

    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bpli
            iv_handle_parent = ls_i_bplh_data-handle
          IMPORTING
            et_entity_data   = lt_i_bpli_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* delete item billing plan items
* ===================================================
    LOOP AT lt_i_bpli_data INTO ls_i_bpli_data.
      TRY.
          CALL METHOD lo_access->del_entity
            EXPORTING
              iv_handle  = ls_i_bpli_data-handle
            IMPORTING
              ev_deleted = lv_deleted.

        CATCH cx_goal_exc INTO lx_goal_exc.
          lv_text_exc = lx_goal_exc->get_text( ).
          me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
          EXIT.
      ENDTRY.
    ENDLOOP.

    lo_access->save( ).

    lo_access->get_messages( IMPORTING et_message = DATA(lt_message)
                                       es_error   = ls_error ).
    IF NOT ls_error IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = ls_error-msgtx ).
      lo_access->close( ).
      EXIT.
    ELSE.
      lo_access->close( ).
    ENDIF.

    lv_statement = 'Success: Delete item level billing plan dates was done!'.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ev_execution_status = abap_true.

    WAIT UP TO 7 SECONDS.
  ENDMETHOD.


  METHOD double_price.
    DATA: lt_vbeln          TYPE cl_ptf_util=>ty_vbeln_tab,
          lv_vbeln          TYPE vbak-vbeln,
          ls_vbak           TYPE vbak,
          ls_komk           TYPE komk,
          lt_komv           TYPE STANDARD TABLE OF komv,
          lv_sdoc           TYPE bapivbeln-vbeln,
          ls_headerinx      TYPE bapisdh1x,
          lt_return         TYPE bapiret2_t,
          ls_return         TYPE bapiret2,
          lt_conditions_in  TYPE TABLE OF bapicond,
          lt_conditions_inx TYPE TABLE OF bapicondx.


    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
*** Step 1: get document number from reference step
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    READ TABLE lt_vbeln INTO lv_vbeln INDEX 1. "assume there was only 1 document created in the reference step

    SELECT SINGLE vbeln, knumv FROM vbak INTO CORRESPONDING FIELDS OF @ls_vbak WHERE vbeln = @lv_vbeln.

*** Step 2: get condition table for the document
    CLEAR ls_komk.
    ls_komk-mandt = sy-mandt.
    ls_komk-belnr = ls_vbak-vbeln.
    ls_komk-knumv = ls_vbak-knumv.

    CALL FUNCTION 'RV_KONV_SELECT'
      EXPORTING
        comm_head_i = ls_komk
      TABLES
        tkomv       = lt_komv.

*** Step3: Map condition table to BAPI structure, double the price
    LOOP AT lt_komv ASSIGNING FIELD-SYMBOL(<ls_komv>) WHERE kstat = space AND koaid = 'B'. "only prices
      READ TABLE lt_conditions_in ASSIGNING FIELD-SYMBOL(<ls_conditions_in>) WITH KEY itm_number = <ls_komv>-kposn cond_type = <ls_komv>-kschl.
      IF sy-subrc <> 0.
        APPEND INITIAL LINE TO lt_conditions_in ASSIGNING <ls_conditions_in>.
      ENDIF.
      <ls_conditions_in>-itm_number = <ls_komv>-kposn.
      <ls_conditions_in>-cond_type = <ls_komv>-kschl.

      <ls_conditions_in>-currenckey = <ls_komv>-konws.
      <ls_conditions_in>-currency = <ls_komv>-waers.

      IF <ls_komv>-waers IS NOT INITIAL.
        CALL FUNCTION 'CURRENCY_CODE_SAP_TO_ISO'
          EXPORTING
            sap_code  = <ls_komv>-waers
          IMPORTING
            iso_code  = <ls_conditions_in>-curreniso
          EXCEPTIONS
            not_found = 1
            OTHERS    = 2.
        IF sy-subrc <> 0.
          CLEAR <ls_conditions_in>-curreniso.
        ENDIF.
      ELSE.
        CLEAR <ls_conditions_in>-curreniso.
      ENDIF.

*   Convert the amount to external value
      CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_EXTERN_9'
        EXPORTING
          currency        = <ls_komv>-waers
          amount_internal = <ls_komv>-kbetr
        IMPORTING
          amount_external = <ls_conditions_in>-cond_value.


      <ls_conditions_in>-cond_value = <ls_conditions_in>-cond_value * 2. "double the price

    ENDLOOP.

    LOOP AT lt_conditions_in ASSIGNING <ls_conditions_in>.
      APPEND INITIAL LINE TO lt_conditions_inx ASSIGNING FIELD-SYMBOL(<ls_conditions_inx>).
      <ls_conditions_inx>-itm_number = <ls_conditions_in>-itm_number.
      <ls_conditions_inx>-cond_value = 'X'.
      <ls_conditions_inx>-updateflag = 'U'.
    ENDLOOP.
*** Step 4: call BAPI to change salesorder

    lv_sdoc = lv_vbeln.
    ls_headerinx-updateflag = 'U'.
    CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
      EXPORTING
        salesdocument    = lv_sdoc
*       ORDER_HEADER_IN  =
        order_header_inx = ls_headerinx
*       SIMULATION       =
*       BEHAVE_WHEN_ERROR           = ' '
*       INT_NUMBER_ASSIGNMENT       = ' '
*       LOGIC_SWITCH     =
*       NO_STATUS_BUF_INIT          = ' '
      TABLES
        return           = lt_return
*       ORDER_ITEM_IN    =
*       ORDER_ITEM_INX   =
*       PARTNERS         =
*       PARTNERCHANGES   =
*       PARTNERADDRESSES =
*       ORDER_CFGS_REF   =
*       ORDER_CFGS_INST  =
*       ORDER_CFGS_PART_OF          =
*       ORDER_CFGS_VALUE =
*       ORDER_CFGS_BLOB  =
*       ORDER_CFGS_VK    =
*       ORDER_CFGS_REFINST          =
*       SCHEDULE_LINES   =
*       SCHEDULE_LINESX  =
*       ORDER_TEXT       =
*       ORDER_KEYS       =
        conditions_in    = lt_conditions_in
        conditions_inx   = lt_conditions_inx
*       EXTENSIONIN      =
*       EXTENSIONEX      =
*       NFMETALLITMS     =
      .

*** Step 5: Commit
    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

    DATA: lv_ptf_key TYPE ptfkey.
    MOVE lv_sdoc TO lv_ptf_key.

    ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).

  ENDMETHOD.


  method execute_action.

    data(lv_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    case lv_step_data-action.
      when c_ml_subitem_create_obd.
        me->ml_subitem_create_obd(
          exporting
*            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.

      when c_remove_bp_block.
        me->remove_bp_block(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_add_billing_plan.
        me->add_billing_plan(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_credit_release.
        me->credit_release(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_double_price.
        me->double_price(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_create_with_reference.
        me->create_with_reference(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_create_with_reference_to_lk.
        me->create_with_reference_lk(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_create_ic.
        me->create_ic(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.

      when c_set_sdsls_doc_vcm.
        me->set_sdsls_doc_vcm(
          exporting
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.

      when c_create_so01.
        me->create_so01(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.

      when c_call_order_request_in.
        me->call_order_request_in(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.

      when c_payment_term.
        me->so_payment_terms(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_create_with_reference_to_bd.
        me->create_with_reference_to_bd(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_create_return_ref.
        me->create_return_ref(
          exporting
*           step_data           = lv_step_data
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
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_action_ic_add_item.
        me->action_ic_add_item(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_action_change_ic_so2.
        me->change_ic_so2(
          exporting
*           step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_action_add_item_bpl_goal.
        me->add_item_bpl_goal(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_action_add_head_bpl_goal.
        me->add_head_bpl_goal(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_action_update_item_bpl_goal.
        me->update_item_bpl_goal(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_action_update_head_bpl_goal.
        me->update_head_bpl_goal(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_action_delete_item_bpl_goal.
        me->delete_item_bpl_goal(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_action_delete_head_bpl_goal.
        me->delete_head_bpl_goal(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_action_add_item_bom_goal.
        me->add_item_bom_goal(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_wait_lock.
        me->wait_lock(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_create_for_project.
        me->create_for_project(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_create_for_material.
        me->create_for_material(
          exporting
            step_data           = lv_step_data
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_add_item_billing_plan.
        me->add_item_billing_plan(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_action_add_f_item_bp_goal.
        me->add_f_item_bp_goal(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_add_item_blp_bom. "GET_PURCH_REQUISITION
        me->add_item_billing_plan_bom(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_get_purch_requisition.
        me->get_purch_requisition(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_add_higher_level_item.
        me->add_higher_level_item(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).


      when others.
        me->mo_run_environment->append_log( iv_log_statement = |Could not find method { lv_step_data-action } for the BO { lv_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        return.
    endcase.
  endmethod.


  METHOD execute_check.

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    CASE ls_step_data-action.
      WHEN c_check_analytical_fields.
        me->check_ana_fields(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_check_preceding.
        me->check_preceding(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_check_partner.
        me->check_partner(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_check_sold_to_party.
        me->check_sold_to_party(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_check_blocked.
        me->check_so_delivery_blocked(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_check_unblock.
        me->check_so_delivery_unblock(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_check_payment_term.
        me->check_so_payment_terms(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_check_ic_so4.
        me->check_ic_so4(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).


       WHEN c_DOC_CHECK_AFTER_OBD.
        me->DOC_CHECK_AFTER_OBD(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).

      WHEN c_ml_check_sc_po_batch.
        me->check_ml_vcm_SC_PO_batch_id(
          EXPORTING
             is_step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).

      WHEN c_ml_check_ic_so_batch.
        me->check_ml_vcm_IC_SO_batch_id(
          EXPORTING
             is_step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).

      WHEN c_ml_check_ic_po_batch.
        me->check_ml_vcm_iC_PO_batch_id(
          EXPORTING
             is_step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).

      WHEN c_ml_check_dc_so_batch.
        me->check_ml_vcm_dC_SO_batch_id(
          EXPORTING
             is_step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).

      WHEN c_check_ic_so4_bapi_create.
        me->check_ic_so4_bapi_create(
          EXPORTING
            is_step_data        = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_check_ic_so4_bapi_change.
        me->check_ic_so4_bapi_change(
          EXPORTING
            is_step_data        = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_check_ic_transit_plant.
        me->check_ic_transit_plant(
          EXPORTING
            is_step_data        = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            et_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).

      WHEN c_check_ml_vcm_fin_chain.
        me->check_ml_vcm_financial_chain(
         EXPORTING
           is_step_data        = ls_step_data
           iv_step_number      = iv_step_number
         IMPORTING
           ev_execution_status = ev_execution_status
           ev_check_status     = ev_check_status
   ).

      WHEN c_check_ml_vcm_category.
        me->check_ml_vcm_category(
         EXPORTING
           is_step_data        = ls_step_data
           iv_step_number      = iv_step_number
         IMPORTING
           ev_execution_status = ev_execution_status
           ev_check_status     = ev_check_status
   ).

      WHEN c_check_ml_OBD.
        me->check_ml_OBD(
         EXPORTING
           step_data        = ls_step_data
           iv_step_number      = iv_step_number
         IMPORTING
           ev_execution_status = ev_execution_status
           ev_check_status     = ev_check_status
   ).

      WHEN c_check_ic_movement_type.
        me->check_ic_movement_type(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_check_ic_wait_for_po3.
        me->check_ic_wait_for_po3(
          EXPORTING
            is_step_data        = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            et_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_check_ic_wait_for_so4.
        me->check_ic_wait_for_so4(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).



      WHEN c_check_ml_ic_wait_SC_PO.
        me->check_ml_ic_wait_for_SC_PO(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).

      WHEN c_check_ml_ic_wait_for_po3.
        me->check_ml_ic_wait_for_po3(
          EXPORTING
            step_data          = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).

      WHEN c_check_ml_dc_so_created.
        me->check_ml_ic_dc_so_created(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).

      WHEN c_check_ic_doc_flow.
        me->check_ic_doc_flow(
          EXPORTING
            is_step_data        = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            et_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_check_po.
        me->check_po(
          EXPORTING
            is_step_data        = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_check_ic_vcm_not_triggered.
        me->check_ic_vcm_not_triggered(
          EXPORTING
            is_step_data        = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            et_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_check_item_bpl_created_goal.
        me->check_item_bpl_created_goal(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_check_head_bpl_created_goal.
        me->check_head_bpl_created_goal(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_check_bpl_copied.
        me->check_bpl_copied(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_check_delivery_block_sline.
        me->check_delivery_block_sline(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_check_item_bpl_updated_goal.
        me->check_item_bpl_updated_goal(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_check_head_bpl_updated_goal.
        me->check_head_bpl_updated_goal(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_check_item_bpl_deleted_goal.
        me->check_item_bpl_deleted_goal(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_check_head_bpl_deleted_goal.
        me->check_head_bpl_deleted_goal(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_check_prefix.
        me->check_prefix(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_check_head_bp_exist.
        me->check_head_bp_exist(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_check_head_bp_not_exist.
        me->check_head_bp_not_exist(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_check_item_bp_exist.
        me->check_item_bp_exist(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_check_item_bp_not_exist.
        me->check_item_bp_not_exist(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_check_f_it_bp_s_nbp.
        me->check_f_it_bp_s_nbp(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_check_delivery_block_bom.
        me->check_delivery_block_bom(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_compare_against_db_doc.
        me->compare_against_db_doc(
          EXPORTING
            is_step_data        = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).

      WHEN c_CHECK_ML_IC_WAIT_IC_SO.
        me->check_ml_ic_wait_for_ic_so(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).

      WHEN c_CHECK_ML_IC_WAIT_IC_po.
        me->check_ml_ic_wait_for_ic_po(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).

      WHEN c_CHECK_ML_IC_WAIT_DC_SO.
        me->check_ml_ic_wait_for_Dc_so(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_ML_DOC_GM_CHECK_OUTDELIVERY.
        me->ml_doc_gm_check_outdelivery(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        """""""MULLAPULLI
        """"""" VCM related checks
      WHEN c_ml_vcm_chk_fin_chain_id.
        me->ml_vcm_chk_fin_chain_id(
         EXPORTING
           is_step_data        = ls_step_data
           iv_step_number      = iv_step_number
         IMPORTING
           ev_execution_status = ev_execution_status
           ev_check_status     = ev_check_status
   ).
      WHEN c_ml_vcm_chk_cat_micl_icsl.
        me->ml_vcm_chk_cat_micl_icsl(
         EXPORTING
           is_step_data        = ls_step_data
           iv_step_number      = iv_step_number
         IMPORTING
           ev_execution_status = ev_execution_status
           ev_check_status     = ev_check_status
   ).
      WHEN c_ml_vcm_chk_transit_plnt_scso.
        me->ml_vcm_chk_transit_plnt_scso(
          EXPORTING
            is_step_data        = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            et_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_ml_vcm_chk_transit_plnt_icso.
        me->ml_vcm_chk_transit_plnt_icso(
          EXPORTING
            is_step_data        = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            et_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_ml_vcm_chk_no_trst_plnt_dcso.
        me->ml_vcm_chk_no_trst_plnt_dcso(
          EXPORTING
            is_step_data        = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            et_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        """"""" VCM DOC related checks
      WHEN c_ml_doc_chk_all_so_created.
        me->ml_doc_chk_all_so_created(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_ml_doc_chk_scso_created.
        me->ml_doc_chk_scso_created(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_ml_doc_chk_icso_created.
        me->ml_doc_chk_icso_created(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_ml_doc_chk_dcso_created.
        me->ml_doc_chk_dcso_created(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        """""""MULLAPULLI
      WHEN c_ml_chk_plant_change_sc_po.
        me->ml_chk_plant_change_sc_po(
        EXPORTING
          step_data       = ls_step_data
          iv_step_number  = iv_step_number
        IMPORTING
          ev_doc_id       = ev_document_id
          ev_exec_status  = ev_execution_status
          ev_check_status = ev_check_status
          ).
      WHEN c_ml_chk_plant_change_ic_so.
        me->ml_chk_plant_change_ic_so(
        EXPORTING
          step_data       = ls_step_data
          iv_step_number  = iv_step_number
        IMPORTING
          ev_doc_id       = ev_document_id
          ev_exec_status  = ev_execution_status
          ev_check_status = ev_check_status
          ).
      WHEN c_ml_chk_plant_change_ic_po.
        me->ml_chk_plant_change_ic_po(
        EXPORTING
          step_data       = ls_step_data
          iv_step_number  = iv_step_number
        IMPORTING
          ev_doc_id       = ev_document_id
          ev_exec_status  = ev_execution_status
          ev_check_status = ev_check_status
          ).
      WHEN c_ml_chk_plant_change_dc_so.
        me->ml_chk_plant_change_dc_so(
        EXPORTING
          step_data       = ls_step_data
          iv_step_number  = iv_step_number
        IMPORTING
          ev_doc_id       = ev_document_id
          ev_exec_status  = ev_execution_status
          ev_check_status = ev_check_status
          ).
      WHEN c_ml_chk_ship_to_change.
        me->ml_chk_ship_to_change(
          EXPORTING
            is_step_data    = ls_step_data
          IMPORTING
            ev_exec_status  = ev_execution_status
            ev_check_status = ev_check_status
        ).
      WHEN c_clear_transit_plant.
        me->clear_transit_plant(
          EXPORTING
            is_step_data    = ls_step_data
            iv_step_number  = iv_step_number
          IMPORTING
            ev_exec_status  = ev_execution_status
            ev_check_status = ev_check_status
        ).
      WHEN c_ml_chk_plant_chg_after_obd.
        me->ml_chk_plant_chg_after_obd(
          EXPORTING
            iv_step_number  = iv_step_number
          IMPORTING
            ev_exec_status  = ev_execution_status
            ev_check_status = ev_check_status
        ).
      WHEN c_ml_successor_doc_deletion.
        me->ml_successor_doc_deletion(
          EXPORTING
            step_data       =  ls_step_data
            iv_step_number  = iv_step_number
          IMPORTING
            ev_exec_status  = ev_execution_status
            ev_check_status = ev_check_status
        ).
        " Action for Material Change - Start
      WHEN c_ml_chk_material_change_sc_po.
        me->ml_chk_material_change_sc_po(
        EXPORTING
          step_data       = ls_step_data
          iv_step_number  = iv_step_number
        IMPORTING
          ev_doc_id       = ev_document_id
          ev_exec_status  = ev_execution_status
          ev_check_status = ev_check_status
          ).
      WHEN c_ml_chk_material_change_ic_so.
        me->ml_chk_material_change_ic_so(
        EXPORTING
          step_data       = ls_step_data
          iv_step_number  = iv_step_number
        IMPORTING
          ev_doc_id       = ev_document_id
          ev_exec_status  = ev_execution_status
          ev_check_status = ev_check_status
          ).
      WHEN c_ml_chk_material_change_ic_po.
        me->ml_chk_material_change_ic_po(
        EXPORTING
          step_data       = ls_step_data
          iv_step_number  = iv_step_number
        IMPORTING
          ev_doc_id       = ev_document_id
          ev_exec_status  = ev_execution_status
          ev_check_status = ev_check_status
          ).
      WHEN c_ml_chk_material_change_dc_so.
        me->ml_chk_material_change_dc_so(
        EXPORTING
          step_data       = ls_step_data
          iv_step_number  = iv_step_number
        IMPORTING
          ev_doc_id       = ev_document_id
          ev_exec_status  = ev_execution_status
          ev_check_status = ev_check_status
          ).
        " Action for Material Change - End
      WHEN OTHERS.
        me->mo_run_environment->append_log( iv_log_statement = |Could not find method { ls_step_data-action } for BO { ls_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.
    ENDCASE.
  ENDMETHOD.


  METHOD get_purch_requisition.

    ev_execution_status = abap_false.

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    DATA lt_vbeln           TYPE cl_ptf_util=>ty_vbeln_tab.
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(ref_doc_ids) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      LOOP AT ref_doc_ids ASSIGNING FIELD-SYMBOL(<ref_doc_id>).
        APPEND <ref_doc_id> TO lt_vbeln.
      ENDLOOP.
    ENDLOOP.

    IF lt_vbeln IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No reference document exists !| ).
      RETURN.
    ENDIF.


    SELECT * FROM vbep INTO TABLE @DATA(lt_vbep) FOR ALL ENTRIES IN @lt_vbeln WHERE vbeln = @lt_vbeln-vbeln(10).

    LOOP AT lt_vbep INTO DATA(ls_vbep).
      IF ls_vbep-banfn IS INITIAL.
        CHECK 1 = 1.
      ELSE.
        APPEND ls_vbep-banfn TO ev_document_id.
        me->mo_run_environment->append_log( iv_log_statement = |SO { ls_vbep-vbeln }, Item { ls_vbep-posnr }, schedline { ls_vbep-etenr } has PurchReq { ls_vbep-banfn }.| ).
      ENDIF.
    ENDLOOP.

    IF ev_document_id IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |There is no reference to a Purchase Requisition at the Schedule lines.| ).
      RETURN.
    ENDIF.

    ev_execution_status = abap_true.
    SORT ev_document_id.
    DELETE ADJACENT DUPLICATES FROM ev_document_id.

  ENDMETHOD.


  METHOD ic_prepare_testdata_create.


    DATA: ls_order_partners TYPE bapiparnr,
          ls_order_items    TYPE bapisditm,
          ls_schedules      TYPE bapischdl.

    ls_order_header_in-doc_type = ls_testdata-document_type.
    ls_order_header_in-sales_org = ls_testdata-sales_organization.
    ls_order_header_in-distr_chan = ls_testdata-distribution_channel.
    ls_order_header_in-division = ls_testdata-division.
    ls_order_header_in-ord_reason = ls_testdata-order_reason.
    ls_order_header_in-bill_block = ls_testdata-billing_block.
    ls_order_header_in-serv_date = ls_testdata-service_render_date.
    ls_order_header_in-alttax_cls = ls_testdata-tax_classification.
    ls_order_header_in-taxdep_cty = ls_testdata-tax_dept_country.
    ls_order_header_in-taxdst_cty = ls_testdata-tax_dest_country.
    ls_order_header_in-pmnttrms = ls_testdata-payment_terms.
    ls_order_header_in-pymt_meth = ls_testdata-payment_method.
    ls_order_header_in-currency = ls_testdata-currency.
    ls_order_header_in-bill_date = ls_testdata-billing_date.

    IF ls_testdata-customer_id IS INITIAL.
      LOOP AT ls_testdata-order_partners ASSIGNING FIELD-SYMBOL(<ls_partner>).

        MOVE-CORRESPONDING <ls_partner> TO ls_order_partners.

        "ls_order_partners-partn_role = <ls_partner>-partn_role.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = <ls_partner>-partn_numb
          IMPORTING
            output = ls_order_partners-partn_numb.

        "IF <ls_partner>-itm_number IS NOT INITIAL.
        "  ls_order_partners-itm_number = <ls_partner>-itm_number.
        "ENDIF.

        APPEND  ls_order_partners TO  lt_order_partners.
      ENDLOOP.
    ELSE.
      ls_order_partners-partn_role = 'AG'.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = ls_testdata-customer_id " C field
        IMPORTING
          output = ls_order_partners-partn_numb.

      APPEND ls_order_partners TO  lt_order_partners.
    ENDIF.

    LOOP AT ls_testdata-item_list ASSIGNING FIELD-SYMBOL(<ls_order_item_list>).
      ls_order_items-itm_number = <ls_order_item_list>-posnr.
      ls_order_items-material =  <ls_order_item_list>-material_id.
      ls_order_items-target_qty = <ls_order_item_list>-quantity.
      ls_order_items-bill_date  = <ls_order_item_list>-fkdat.
      ls_order_items-plant =  <ls_order_item_list>-werks.
      ls_order_items-store_loc =  <ls_order_item_list>-store_loc.
      ls_order_items-pymt_meth = <ls_order_item_list>-payment_method.
      ls_order_items-item_categ = <ls_order_item_list>-item_category.
      ls_order_items-pmnttrms = <ls_order_item_list>-payment_terms.
      ls_order_items-pymt_meth = <ls_order_item_list>-payment_method.
      ls_order_items-profit_ctr = <ls_order_item_list>-profit_center.
      ls_order_items-sales_unit = <ls_order_item_list>-sales_unit.
      ls_order_items-unddlv_tol = <ls_order_item_list>-unddlv_tol.

      APPEND ls_order_items TO lt_order_items.
      IF <ls_order_item_list>-schedule_lines IS NOT INITIAL.
        LOOP AT <ls_order_item_list>-schedule_lines ASSIGNING FIELD-SYMBOL(<ls_schdl>).

          ls_schedules-itm_number = <ls_order_item_list>-posnr.
          ls_schedules-sched_line = <ls_schdl>-etenr.
          ls_schedules-req_qty    = <ls_schdl>-wmeng.
          ls_schedules-sched_type = <ls_schdl>-ettyp.
          ls_schedules-req_date   = sy-datum + <ls_schdl>-delivery_days.

          APPEND ls_schedules TO lt_schedules.

        ENDLOOP.
      ELSE.

        ls_schedules-itm_number = <ls_order_item_list>-posnr.
        ls_schedules-req_qty    = <ls_order_item_list>-quantity.
        ls_schedules-sched_type = <ls_order_item_list>-schedule_line_category.
        ls_schedules-req_date    = sy-datum.
        APPEND ls_schedules TO lt_schedules.

      ENDIF.

    ENDLOOP.


    MOVE ls_testdata-sales_text TO lt_sales_text.

  ENDMETHOD.


  METHOD log_status.
*     Reads status GBSTK of Sales Order and logs it
    DATA: lt_vbeln TYPE cl_ptf_util=>ty_vbeln_tab,
          lv_vbak  TYPE vbak,
          lt_vbap  TYPE TABLE OF vbap.

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    ev_check_status = abap_false.

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    IF lt_vbeln IS NOT INITIAL.
      LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<lv_vbel>).
        SELECT SINGLE vbeln, gbstk, fksak, fsstk, cmgst, costa, dcstk, fmstk, lfgsk,manek, rfgsk, rfstk, spstg, trsta, wbstk,total_emcst, total_slcst, total_lccst,
                      total_pcsta, total_dgsta,total_sdssta, dp_clear_sta_hdr, b2b_msg_processing_status, uvfak, uvfas
           FROM vbak WHERE vbeln = @<lv_vbel>-vbeln INTO CORRESPONDING FIELDS OF @lv_vbak.
        IF sy-subrc <> 0.
          "Document not found
          me->mo_run_environment->append_log( iv_log_statement = |Could not find document { <lv_vbel>-vbeln }.| ).
          ev_execution_status = abap_false.
        ELSE.
          me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbel>-vbeln }  /  GBSTK: { lv_vbak-gbstk } | ).
          me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbel>-vbeln }  /  FKSAK: { lv_vbak-fksak } | ).
          me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbel>-vbeln }  /  FSSTK: { lv_vbak-fsstk } | ).
          me->mo_run_environment->append_log( iv_log_statement = |------------------------------------------------------------------------------------------------------- | ).
          me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbel>-vbeln }  /  CMGST: { lv_vbak-cmgst } | ).
          me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbel>-vbeln }  /  COSTA: { lv_vbak-costa } | ).
          me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbel>-vbeln }  /  DCSTK: { lv_vbak-dcstk } | ).
          me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbel>-vbeln }  /  FMSTK: { lv_vbak-fmstk } | ).
          me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbel>-vbeln }  /  LFGSK: { lv_vbak-lfgsk } | ).
          me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbel>-vbeln }  /  LFSTK: { lv_vbak-lfstk } | ).
          me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbel>-vbeln }  /  MANEK: { lv_vbak-manek } | ).
          me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbel>-vbeln }  /  RFGSK: { lv_vbak-rfgsk } | ).
          me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbel>-vbeln }  /  RFSTK: { lv_vbak-rfstk } | ).
          me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbel>-vbeln }  /  SPSTG: { lv_vbak-spstg } | ).
          me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbel>-vbeln }  /  TRSTA: { lv_vbak-trsta } | ).
          me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbel>-vbeln }  /  WBSTK: { lv_vbak-wbstk } | ).
          me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbel>-vbeln }  /  TOTAL_EMCST: { lv_vbak-total_emcst } | ).
          me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbel>-vbeln }  /  TOTAL_SLCST: { lv_vbak-total_slcst } | ).
          me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbel>-vbeln }  /  TOTAL_LCCST: { lv_vbak-total_lccst } | ).
          me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbel>-vbeln }  /  TOTAL_PCSTA: { lv_vbak-total_pcsta } | ).
          me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbel>-vbeln }  /  TOTAL_DGSTA: { lv_vbak-total_dgsta } | ).
          me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbel>-vbeln }  /  TOTAL_SDSSTA: { lv_vbak-total_sdssta } | ).
          me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbel>-vbeln }  /  DP_CLEAR_STA_HDR: { lv_vbak-dp_clear_sta_hdr } | ).
          me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbel>-vbeln }  /  B2B_MSG_PROCESSING_STATUS: { lv_vbak-b2b_msg_processing_status } | ).
          me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbel>-vbeln }  /  UVFAK: { lv_vbak-uvfak } | ).
          me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbel>-vbeln }  /  UVFAS: { lv_vbak-uvfas } | ).





          ev_check_status = abap_true.
        ENDIF.
        CLEAR lv_vbak.
        SELECT vbeln, posnr, gbsta, fksaa, fssta, absta, besta, cmppi, cmppj, costa, dcsta, lfgsa,lfsta,lssta,
                rfgsa, rfsta, wbsta, emcst, slcst, total_lccst, pcsta, dgsta, sdssta, dp_clear_sta_itm, uvfak
           FROM vbap WHERE vbeln = @<lv_vbel>-vbeln INTO CORRESPONDING FIELDS OF TABLE @lt_vbap.
        IF sy-subrc <> 0.
          "No items
          me->mo_run_environment->append_log( iv_log_statement = |Could not find items for document { <lv_vbel>-vbeln }.| ).
        ELSE.
          LOOP AT lt_vbap ASSIGNING FIELD-SYMBOL(<lv_vbap>).
            me->mo_run_environment->append_log( iv_log_statement = |------------------------------------------------ITEMS------------------------------------------- | ).
            me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbap>-vbeln }  / Item-Number: { <lv_vbap>-posnr } / gbsta: { <lv_vbap>-gbsta } | ).
            me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbap>-vbeln }  / Item-Number: { <lv_vbap>-posnr } / fksaa: { <lv_vbap>-fksaa } | ).
            me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbap>-vbeln }  / Item-Number: { <lv_vbap>-posnr } / fssta: { <lv_vbap>-fssta } | ).
            me->mo_run_environment->append_log( iv_log_statement = |------------------------------------------------------------------------------------------------------- | ).
            me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbap>-vbeln }  / Item-Number: { <lv_vbap>-posnr } / ABSTA: { <lv_vbap>-absta } | ).
            me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbap>-vbeln }  / Item-Number: { <lv_vbap>-posnr } / BESTA: { <lv_vbap>-besta } | ).
            me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbap>-vbeln }  / Item-Number: { <lv_vbap>-posnr } / CMPPI: { <lv_vbap>-cmppi } | ).
            me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbap>-vbeln }  / Item-Number: { <lv_vbap>-posnr } / CMPPJ: { <lv_vbap>-cmppj } | ).
            me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbap>-vbeln }  / Item-Number: { <lv_vbap>-posnr } / COSTA: { <lv_vbap>-costa } | ).
            me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbap>-vbeln }  / Item-Number: { <lv_vbap>-posnr } / DCSTA: { <lv_vbap>-dcsta } | ).
            me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbap>-vbeln }  / Item-Number: { <lv_vbap>-posnr } / LFGSA: { <lv_vbap>-lfgsa } | ).
            me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbap>-vbeln }  / Item-Number: { <lv_vbap>-posnr } / LFSTA: { <lv_vbap>-lfsta } | ).
            me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbap>-vbeln }  / Item-Number: { <lv_vbap>-posnr } / LSSTA: { <lv_vbap>-lssta } | ).
            me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbap>-vbeln }  / Item-Number: { <lv_vbap>-posnr } / RFGSA: { <lv_vbap>-rfgsa } | ).
            me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbap>-vbeln }  / Item-Number: { <lv_vbap>-posnr } / RFSTA: { <lv_vbap>-rfsta } | ).
            me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbap>-vbeln }  / Item-Number: { <lv_vbap>-posnr } / WBSTA: { <lv_vbap>-wbsta } | ).
            me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbap>-vbeln }  / Item-Number: { <lv_vbap>-posnr } / EMCST: { <lv_vbap>-emcst } | ).
            me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbap>-vbeln }  / Item-Number: { <lv_vbap>-posnr } / SLCST: { <lv_vbap>-slcst } | ).
            me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbap>-vbeln }  / Item-Number: { <lv_vbap>-posnr } / TOTAL_LCCST: { <lv_vbap>-total_lccst } | ).
            me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbap>-vbeln }  / Item-Number: { <lv_vbap>-posnr } / PCSTA: { <lv_vbap>-pcsta } | ).
            me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbap>-vbeln }  / Item-Number: { <lv_vbap>-posnr } / DGSTA: { <lv_vbap>-dgsta } | ).
            me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbap>-vbeln }  / Item-Number: { <lv_vbap>-posnr } / SDSSTA: { <lv_vbap>-sdssta } | ).
            me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbap>-vbeln }  / Item-Number: { <lv_vbap>-posnr } / DP_CLEAR_STA_ITM: { <lv_vbap>-dp_clear_sta_itm } | ).
            me->mo_run_environment->append_log( iv_log_statement = |SalesOrder-Number: { <lv_vbap>-vbeln }  / Item-Number: { <lv_vbap>-posnr } / UVFAK: { <lv_vbap>-uvfak } | ).

          ENDLOOP.
        ENDIF.
      ENDLOOP.
      CLEAR lt_vbap.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |No documents found.| ).
      RETURN.
    ENDIF.

    ev_execution_status = abap_true.

  ENDMETHOD.


  METHOD prepare_testdata_create.


    DATA: ls_order_partners TYPE bapiparnr,
          ls_order_items    TYPE bapisditm,
          ls_schedules      TYPE bapischdl.

    ls_order_header_in-doc_type = ls_testdata-document_type.
    ls_order_header_in-sales_org = ls_testdata-sales_organization.
    ls_order_header_in-distr_chan = ls_testdata-distribution_channel.
    ls_order_header_in-division = ls_testdata-division.
    ls_order_header_in-ord_reason = ls_testdata-order_reason.
    ls_order_header_in-bill_block = ls_testdata-billing_block.
    ls_order_header_in-serv_date = ls_testdata-service_render_date.
    ls_order_header_in-alttax_cls = ls_testdata-tax_classification.
    ls_order_header_in-taxdep_cty = ls_testdata-tax_dept_country.
    ls_order_header_in-taxdst_cty = ls_testdata-tax_dest_country.
    ls_order_header_in-pmnttrms = ls_testdata-payment_terms.
    ls_order_header_in-pymt_meth = ls_testdata-payment_method.
    ls_order_header_in-currency = ls_testdata-currency.
    ls_order_header_in-bill_date = ls_testdata-billing_date.

    IF ls_testdata-customer_id IS NOT INITIAL.
      ls_order_partners-partn_role = 'AG'.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = ls_testdata-customer_id " C field
        IMPORTING
          output = ls_order_partners-partn_numb.

      APPEND ls_order_partners TO  lt_order_partners.
    ENDIF.

    LOOP AT ls_testdata-order_partners ASSIGNING FIELD-SYMBOL(<ls_partner>).
      IF ls_testdata-customer_id IS NOT INITIAL AND <ls_partner>-partn_role = 'AG'.
        CONTINUE.
      ENDIF.

      MOVE-CORRESPONDING <ls_partner> TO ls_order_partners.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <ls_partner>-partn_numb
        IMPORTING
          output = ls_order_partners-partn_numb.

      APPEND  ls_order_partners TO  lt_order_partners.
    ENDLOOP.

    LOOP AT ls_testdata-item_list ASSIGNING FIELD-SYMBOL(<ls_order_item_list>).
      ls_order_items-itm_number = <ls_order_item_list>-posnr.
      ls_order_items-material =  <ls_order_item_list>-material_id.
      ls_order_items-target_qty = <ls_order_item_list>-quantity.
      ls_order_items-bill_date  = <ls_order_item_list>-fkdat.
      ls_order_items-plant =  <ls_order_item_list>-werks.
      ls_order_items-store_loc =  <ls_order_item_list>-store_loc.
      ls_order_items-pymt_meth = <ls_order_item_list>-payment_method.
      ls_order_items-item_categ = <ls_order_item_list>-item_category.
      ls_order_items-pmnttrms = <ls_order_item_list>-payment_terms.
      ls_order_items-pymt_meth = <ls_order_item_list>-payment_method.
      ls_order_items-profit_ctr = <ls_order_item_list>-profit_center.
      ls_order_items-sales_unit = <ls_order_item_list>-sales_unit.
      ls_order_items-unddlv_tol = <ls_order_item_list>-unddlv_tol.
      ls_order_items-po_itm_no = <ls_order_item_list>-po_itm_no.
      APPEND ls_order_items TO lt_order_items.

      ls_schedules-itm_number = <ls_order_item_list>-posnr.
      ls_schedules-req_qty    = <ls_order_item_list>-quantity.
      ls_schedules-sched_type = <ls_order_item_list>-schedule_line_category.
      ls_schedules-req_date    = sy-datum.
      APPEND ls_schedules TO lt_schedules.
    ENDLOOP.


    MOVE ls_testdata-sales_text TO lt_sales_text.

  ENDMETHOD.


  METHOD remove_billing_block. "does not remove item billing block

    DATA: ls_header_inx TYPE bapisdh1x,
          ls_header_in  TYPE bapisdh1,
          lt_return	    TYPE cl_ptf_util=>gt_ptf_return_tab,
          lv_vbeln      TYPE vbeln.

    MOVE iv_order_number TO lv_vbeln.

    ls_header_inx-updateflag = 'U'.
    ls_header_inx-bill_block = 'X'.
    ls_header_in-bill_block  = ' '.

    CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
      EXPORTING
        salesdocument    = lv_vbeln
        order_header_in  = ls_header_in
        order_header_inx = ls_header_inx  " Sales Order Check List
      TABLES
        return           = lt_return.

    me->mo_run_environment->append_log( iv_log_statement = |BAPI_SALESORDER_CHANGE:| ).
    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ls_return>).
      me->mo_run_environment->append_log( iv_log_statement = |{ <ls_return>-message }| ).
    ENDLOOP.


    COMMIT WORK AND WAIT.
    "WAIT UP TO 5 SECONDS.

    ev_test_success = abap_true.

  ENDMETHOD.


  METHOD remove_bp_block.
    CONSTANTS: c_updkz_old      TYPE string VALUE ' ',     "Keine Veraenderung
               c_updkz_new      TYPE string VALUE 'I',     "Neue Position
               c_updkz_update   TYPE string VALUE 'U',     "Geaenderte Position
               c_updkz_mark_del TYPE string VALUE 'd',     "SPE marked for deletion
               c_updkz_delete   TYPE string VALUE 'D'.     "Löschen

    DATA: billing_plan_pos TYPE ty_remove_bp_block,
          billing_plans    TYPE STANDARD TABLE OF fplnr WITH DEFAULT KEY,
          fpla_new         TYPE STANDARD TABLE OF fplavb WITH DEFAULT KEY,
          fpla_old         TYPE STANDARD TABLE OF fplavb WITH DEFAULT KEY,
          fplt_new         TYPE STANDARD TABLE OF fpltvb WITH DEFAULT KEY,
          fplt_old         TYPE STANDARD TABLE OF fpltvb WITH DEFAULT KEY,
          fpla_entry       TYPE fplavb,
          fplt_entry       TYPE fpltvb.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = billing_plan_pos
    ).

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      APPEND LINES OF ptf_keys TO billing_plans.
    ENDLOOP.

    LOOP AT billing_plans ASSIGNING FIELD-SYMBOL(<billing_plan>).
      SELECT SINGLE * FROM fplt WHERE fplnr = @<billing_plan> AND fpltr = @billing_plan_pos-position_to_unblock INTO @DATA(bp_item).

      MOVE-CORRESPONDING bp_item TO fplt_entry.
      fplt_entry-faksp = ''.

      fplt_entry-updkz = c_updkz_update.

      APPEND fplt_entry TO fplt_new.

      CALL FUNCTION 'BILLING_SCHEDULE_SAVE'
        TABLES
          fpla_new = fpla_new
          fpla_old = fpla_old
          fplt_new = fplt_new
          fplt_old = fplt_old.

      COMMIT WORK AND WAIT.

      me->mo_run_environment->append_log( iv_log_statement = |Removed billing block for billing plan { <billing_plan> } and position { billing_plan_pos-position_to_unblock }| ).

    ENDLOOP.

    ev_execution_status = abap_true.

  ENDMETHOD.


  METHOD reserve_action_1.

  ENDMETHOD.


  METHOD reserve_action_2.

  ENDMETHOD.


  METHOD reserve_action_3.

  ENDMETHOD.


  METHOD set_sdsls_doc_vcm.

    DATA: ls_testdata TYPE ty_gt_ptf_sdsls_doc_vcm.

    ev_execution_status = abap_false.
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

    IF ls_testdata IS INITIAL.
      RETURN.
    ENDIF.

    MODIFY sdsls_doc_vcm FROM TABLE ls_testdata.
    IF sy-subrc <> 0.
      me->mo_run_environment->append_log( |Changes to SDSLS_DOC_VCM failed.| ).
    ELSE.
      COMMIT WORK AND WAIT.
      me->mo_run_environment->append_log( |SDSLS_DOC_VCM changed successfully.| ).
      ev_execution_status = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD so_payment_terms.

    DATA: ls_testdata    TYPE string,
          lv_xml_xstring TYPE xstring,
          lv_log_message TYPE string,
          lv_vbeln       TYPE vbeln.

    DATA: ls_curr_line  TYPE edi_sales_order_message,
          ls_data       TYPE edi_sales_order_message,
          lt_old_msg    TYPE /aif/bal_t_msg,
          lt_return_msg TYPE bapiret2_t,
          lv_succ       TYPE /aif/successflag,
          lv_ts         TYPE string.

*--> 1 Step: Get data from tdc
    DATA(ls_current_step) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_current_step
      IMPORTING
        es_testdata  = ls_testdata ).

*Replace the parameter in Payload
    lv_ts = utclong_current( ) .
    lv_ts = |{ lv_ts(10) }| && |T| && sy-uzeit(2) && |:| && sy-uzeit+2(2) && |:| && sy-uzeit+4(2) && |Z|.
    REPLACE ALL OCCURRENCES OF '{CreationDateTime}' IN ls_testdata WITH lv_ts.

    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
      EXPORTING
        text   = ls_testdata
      IMPORTING
        buffer = lv_xml_xstring
      EXCEPTIONS
        failed = 1
        OTHERS = 2.

    "transform xstring to abap structuer
    DATA(lo_sxml_reader) = cl_sxml_string_reader=>create( input = lv_xml_xstring ).
    TRY.
        cl_proxy_xml_transform=>xml_to_abap( EXPORTING ddic_type  = 'EDI_SALES_ORDER_MESSAGE'
                                                       xml_reader = lo_sxml_reader
                                             IMPORTING abap_data  = ls_data ).
      CATCH cx_proxy_fault INTO DATA(lx_fault).
    ENDTRY.

*--> 2 Step: Call inbound processing
    TRY.
        NEW cl_edi_sd_ordr_processing( )->process(
          CHANGING
            data         = ls_data
            curr_line    = ls_curr_line
            success      = lv_succ
            old_messages = lt_old_msg
            return_tab   = lt_return_msg
        ).
      CATCH BEFORE UNWIND cx_edi_sd_exc INTO DATA(lx_edi_exc).
        APPEND LINES OF lx_edi_exc->convert_chain_to_bapiret2_t( ) TO lt_return_msg.
    ENDTRY.

*--> 3 Step:  Copy messages to et_return
    LOOP AT lt_return_msg ASSIGNING FIELD-SYMBOL(<ls_return_msg>).
      IF <ls_return_msg>-message IS INITIAL     AND
         <ls_return_msg>-id      IS NOT INITIAL AND
         <ls_return_msg>-number  IS NOT INITIAL.
        DATA(lo_message) = NEW cl_t100_message( the_msg_class  = <ls_return_msg>-id
                                                the_msg_number = <ls_return_msg>-number ).

        DATA(lt_msgv) = VALUE name2value_table(
         ( name = cl_t100_message=>msgv1_name value = <ls_return_msg>-message_v1 )
         ( name = cl_t100_message=>msgv2_name value = <ls_return_msg>-message_v2 )
         ( name = cl_t100_message=>msgv3_name value = <ls_return_msg>-message_v3 )
         ( name = cl_t100_message=>msgv4_name value = <ls_return_msg>-message_v4 ) ).

        lo_message->set_substitution_table( lt_msgv ) .
        lv_log_message = lo_message->if_message~get_text( ).
      ELSE.
        IF <ls_return_msg>-message IS NOT INITIAL.
          lv_log_message = <ls_return_msg>-message .
        ENDIF.
      ENDIF.
      lv_log_message = |EDI: { lv_log_message }|.
      me->mo_run_environment->append_log( iv_log_statement = lv_log_message ).
    ENDLOOP.

*--> 4 Step: Check result and set success flag
    IF line_exists( lt_return_msg[ type = 'E' ]  ).
      ev_execution_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |SEF: The Order Request Processing failed. | ).
    ELSE.
      READ TABLE lt_return_msg INTO DATA(ls_return_msg) WITH KEY type   = 'S'
                                                                 id     = 'V1'
                                                                 number = 311.
      IF sy-subrc = 0.
        lv_vbeln = ls_return_msg-message_v2.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = lv_vbeln
          IMPORTING
            output = lv_vbeln.
        APPEND lv_vbeln TO ev_document_id.
      ENDIF.
      ev_execution_status = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |SEF: The Order Request { lv_vbeln } Processing successful. | ).
    ENDIF.

  ENDMETHOD.


  METHOD update_head_bpl_goal.
    DATA: lt_doc_ids TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings,
          lo_access           TYPE REF TO if_goal_access,
          ls_error            TYPE if_goal_types=>tcs_error,
          lx_goal_exc         TYPE REF TO cx_goal_exc,
          lv_text_exc         TYPE string,
          lv_field            TYPE fieldname,
          lv_deleted          TYPE abap_bool,
          ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
          lt_changed_field    TYPE if_goal_types=>tct_changed_field.

    DATA: lv_bo_key      TYPE if_goal_types=>tcd_bo_key,
          lt_item_data   TYPE STANDARD TABLE OF tds_goal_so_item,
          ls_head_data   TYPE tds_goal_so_head,
          ls_h_bplh_data TYPE tds_goal_sdoc_bplh,
          ls_h_bpli_data TYPE tds_goal_sdoc_bpli,
          lt_h_bpli_data TYPE STANDARD TABLE OF tds_goal_sdoc_bpli,
          lv_statement   TYPE bapi_msg.

    DATA: lv_date TYPE fkdat.

    lv_date = sy-datum + 1.
    ev_execution_status = abap_false.

* 1 Step: get previously step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_doc_ids.
    ENDLOOP.

    READ TABLE lt_doc_ids INTO DATA(ls_doc_id) INDEX 1.
    IF sy-subrc = 0.
      lv_bo_key = ls_doc_id-vbeln.
    ENDIF.

    CHECK NOT lv_bo_key IS INITIAL.

* 2 Step: Access sales order via GOAL
* ===================================================
* open the document in change mode
* ===================================================
    TRY.
        CALL METHOD cl_goal_api=>so_instance->open
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_bo_key
            iv_read_only        = abap_false
            is_control_settings = ls_control_settings
          RECEIVING
            ro_access           = lo_access.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read header data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id   = if_goal_sdoc_head=>co_entity_id
          IMPORTING
            es_entity_data = ls_head_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read head billing plan header
* ===================================================
    CHECK NOT ls_head_data IS INITIAL.
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-head_bplh
            iv_handle_parent = ls_head_data-handle
          IMPORTING
            es_entity_data   = ls_h_bplh_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* get head billing plan item
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-head_bpli
            iv_handle_parent = ls_h_bplh_data-handle
          IMPORTING
            et_entity_data   = lt_h_bpli_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* change head billing plan item
* ===================================================
    LOOP AT lt_h_bpli_data ASSIGNING FIELD-SYMBOL(<head_bpli>).
      <head_bpli>-billing_date = lv_date.

      CLEAR: ls_changed_field.
      lv_field = 'BILLING_DATE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_changed_field-handle = <head_bpli>-handle.
      APPEND ls_changed_field TO lt_changed_field.
    ENDLOOP.

    TRY.
        CALL METHOD lo_access->set_entity_set
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-head_bpli
            iv_handle_parent = ls_h_bplh_data-handle
            it_entity_data   = lt_h_bpli_data
            it_changed_field = lt_changed_field.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.

    lo_access->save( ).
    lo_access->get_messages( IMPORTING et_message = DATA(lt_message)
                                       es_error   = ls_error ).
    IF NOT ls_error IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = ls_error-msgtx ).
      lo_access->close( ).
      EXIT.
    ELSE.
      lo_access->close( ).
    ENDIF.

    lv_statement = 'Success: Update header level billing plan dates was done!'.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ev_execution_status = abap_true.

    WAIT UP TO 7 SECONDS.
  ENDMETHOD.


  METHOD update_item_bpl_goal.
    DATA: lt_doc_ids TYPE cl_ptf_util=>ty_vbeln_tab.

    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings,
          lo_access           TYPE REF TO if_goal_access,
          ls_error            TYPE if_goal_types=>tcs_error,
          lx_goal_exc         TYPE REF TO cx_goal_exc,
          lv_text_exc         TYPE string,
          lv_field            TYPE fieldname,
          lv_deleted          TYPE abap_bool,
          ls_changed_field    TYPE if_goal_types=>tcs_changed_field,
          lt_changed_field    TYPE if_goal_types=>tct_changed_field.

    DATA: lv_bo_key      TYPE if_goal_types=>tcd_bo_key,
          lt_item_data   TYPE STANDARD TABLE OF tds_goal_so_item,
          ls_head_data   TYPE tds_goal_so_head,
          ls_i_bplh_data TYPE tds_goal_sdoc_bplh,
          ls_i_bpli_data TYPE tds_goal_sdoc_bpli,
          lt_i_bpli_data TYPE STANDARD TABLE OF tds_goal_sdoc_bpli,
          lv_statement   TYPE bapi_msg.

    DATA: lv_date TYPE fkdat.

    lv_date = sy-datum + 1.
    ev_execution_status = abap_false.

* 1 Step: get previously step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_doc_ids.
    ENDLOOP.

    READ TABLE lt_doc_ids INTO DATA(ls_doc_id) INDEX 1.
    IF sy-subrc = 0.
      lv_bo_key = ls_doc_id-vbeln.
    ENDIF.

    CHECK NOT lv_bo_key IS INITIAL.

* 2 Step: Access sales order via GOAL
* ===================================================
* open the document in change mode
* ===================================================
    TRY.
        CALL METHOD cl_goal_api=>so_instance->open
          EXPORTING
            iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
            iv_bo_key           = lv_bo_key
            iv_read_only        = abap_false
            is_control_settings = ls_control_settings
          RECEIVING
            ro_access           = lo_access.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.
* ===================================================
* read header data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id   = if_goal_sdoc_head=>co_entity_id
          IMPORTING
            es_entity_data = ls_head_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* read item data
* ===================================================
    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id   = if_goal_sdoc_item=>co_entity_id
          IMPORTING
            et_entity_data = lt_item_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* read item billing plan header
* ===================================================
    READ TABLE lt_item_data INTO DATA(ls_item_data) INDEX 1.
    CHECK sy-subrc = 0.
    TRY.
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bplh
            iv_handle_parent = ls_item_data-handle
          IMPORTING
            es_entity_data   = ls_i_bplh_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* get item billing plan items
* ===================================================
    CHECK NOT ls_i_bplh_data IS INITIAL.

    TRY.
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bpli
            iv_handle_parent = ls_i_bplh_data-handle
          IMPORTING
            et_entity_data   = lt_i_bpli_data.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        lo_access->close( ).
        EXIT.
    ENDTRY.
* ===================================================
* update item billing plan items
* ===================================================
    LOOP AT lt_i_bpli_data ASSIGNING FIELD-SYMBOL(<item_bpli>).
      <item_bpli>-billing_date = lv_date.

      CLEAR: ls_changed_field.
      lv_field = 'BILLING_DATE'.
      INSERT lv_field INTO TABLE ls_changed_field-field.
      ls_changed_field-handle = <item_bpli>-handle.
      APPEND ls_changed_field TO lt_changed_field.
    ENDLOOP.

    TRY.
        CALL METHOD lo_access->set_entity_set
          EXPORTING
            iv_entity_id     = if_goal_sdoc_bpl=>co_entity_id-item_bpli
            iv_handle_parent = ls_i_bplh_data-handle
            it_entity_data   = lt_i_bpli_data
            it_changed_field = lt_changed_field.
      CATCH cx_goal_exc INTO lx_goal_exc.
        lv_text_exc = lx_goal_exc->get_text( ).
        me->mo_run_environment->append_log( iv_log_statement = lv_text_exc ).
        EXIT.
    ENDTRY.

    lo_access->save( ).

    lo_access->get_messages( IMPORTING et_message = DATA(lt_message)
                                       es_error   = ls_error ).
    IF NOT ls_error IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = ls_error-msgtx ).
      lo_access->close( ).
      EXIT.
    ELSE.
      lo_access->close( ).
    ENDIF.

    lv_statement = 'Success: Update item level billing plan dates was done!'.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ev_execution_status = abap_true.

    WAIT UP TO 7 SECONDS.
  ENDMETHOD.


  METHOD wait_lock.
    DATA: lt_locks TYPE STANDARD TABLE OF seqg3.
    DATA: l_garg TYPE seqg3-garg.
    DATA: l_locked TYPE abap_bool.
    DATA: l_second TYPE i.
    ev_execution_status = abap_false.
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(l_vbelns) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      LOOP AT l_vbelns REFERENCE INTO DATA(l_vbeln).
        l_garg = |{ sy-mandt }{ l_vbeln->vbeln }|.
        l_second = 1.
        DO 7 TIMES.
          CALL FUNCTION 'ENQUEUE_READ'
            EXPORTING
              gclient = sy-mandt
              gname   = 'VBAK'
              garg    = l_garg
              guname  = ''
            TABLES
              enq     = lt_locks
            EXCEPTIONS
              OTHERS  = 1.
          IF lt_locks IS INITIAL.
            me->mo_run_environment->append_log( iv_log_statement = |Order { l_vbeln->vbeln } is not locked.| ).
            l_locked = abap_false.
            EXIT.
          ELSE.
            me->mo_run_environment->append_log( iv_log_statement = |Order { l_vbeln->vbeln } is still locked, waiting.| ).
            l_locked = abap_true.
            WAIT UP TO l_second SECONDS.
            l_second += 2.
          ENDIF.
        ENDDO.
        IF l_locked = abap_true.
          me->mo_run_environment->append_log( iv_log_statement = |Order { l_vbeln->vbeln } is still locked, error.| ).
          ev_check_status = abap_false.
          RETURN.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
    ev_execution_status = abap_true.
  ENDMETHOD.


  METHOD _create.

    DATA: ls_testdata                    TYPE ty_gs_i_ptf_or_cr_td,
          ls_order_header_in_x           TYPE bapisdhd1x,
          ls_order_header_in             TYPE bapisdhd1,
          lt_extensionex                 TYPE TABLE OF bapiparex,
          ls_extensibility_fields_header TYPE REF TO bape_sdsalesdoc,
          lt_order_partners              TYPE TABLE OF bapiparnr,
          lt_order_items                 TYPE TABLE OF bapisditm,
          lt_order_items_x               TYPE TABLE OF bapisditmx,
          ls_order_item_x                TYPE bapisditmx,
          lt_schedules                   TYPE TABLE OF bapischdl,
          lt_return                      TYPE TABLE OF bapiret2,
          lv_vbeln                       TYPE vbeln,
          lo_bapi_mapping                TYPE REF TO if_cfd_bapi_mapping,
          lt_extensibility_fields_item   TYPE TABLE OF bape_sdsalesdocitem,
          ls_extensibility_fields_item   TYPE bape_sdsalesdocitem,
          lt_bapiparex                   TYPE bapiparextab,
*          ls_i_salesitemproposalitemtp   TYPE i_salesitemproposalitemtp,
*          ls_prpsl_item                  TYPE bapisditm,
          ls_ext_field                   TYPE string,
          ls_tvak                        TYPE tvak,
          lv_key                         TYPE i,
          lv_key_as_string               TYPE string,
          lv_key_add                     TYPE i,
          lt_sales_text                  TYPE ty_bapisdtext,
          lt_matnr18                     TYPE STANDARD TABLE OF matnr18,
          lv_extensibility_error         TYPE abap_bool.

    FIELD-SYMBOLS: <gfs_field>          TYPE any,
                   <ex_field_structure> TYPE any.

*****************************************************************************
* 1 Step: get stepdata
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
*****************************************************************************
* 2 Step: get tdcv
    IF ls_step_data-variant IS NOT INITIAL.
      cl_ptf_util=>get_testdata(
        EXPORTING
          is_step_data = ls_step_data
        IMPORTING
          es_testdata  = ls_testdata
      ).
    ENDIF.
*****************************************************************************
* 3 Step: Prepare Testdata for 'SD_SALESDOCUMENT_CREATE'
    CALL METHOD prepare_testdata_create
      EXPORTING
        ls_testdata        = ls_testdata
      IMPORTING
        ls_order_header_in = ls_order_header_in
        lt_order_partners  = lt_order_partners
        lt_order_items     = lt_order_items
        lt_schedules       = lt_schedules
        lt_sales_text      = lt_sales_text.
*****************************************************************************
    "ls_order_header_in_x-updateflag  = 'I'.
    ls_order_header_in_x-doc_type    = 'X'.
    ls_order_header_in_x-sales_org   = 'X'.
    ls_order_header_in_x-distr_chan  = 'X'.
    ls_order_header_in_x-division    = 'X'.
    ls_order_header_in_x-pp_search   = 'X'.
    ls_order_header_in_x-ct_valid_f  = 'X'.
    ls_order_header_in_x-ct_valid_t  = 'X'.

    SELECT SINGLE * FROM tvak INTO @ls_tvak
        WHERE auart = @ls_order_header_in-doc_type.

    IF ls_tvak IS NOT INITIAL.
      lv_key_add = ls_tvak-incpo.
    ELSE.
      lv_key_add = 10.
    ENDIF.
    lv_key = lv_key_add.

    LOOP AT lt_order_items ASSIGNING FIELD-SYMBOL(<ls_order_item>).
      CLEAR ls_order_item_x.
      ls_order_item_x-itm_number = <ls_order_item>-itm_number.

      "ls_order_item_x-updateflag = 'I'.
      ls_order_item_x-material   = 'X'.
      ls_order_item_x-target_qty = 'X'.
      ls_order_item_x-target_qu  = 'X'.

      IF <ls_order_item>-sales_unit IS NOT INITIAL.
        ls_order_item_x-sales_unit = 'X'.
      ENDIF.
      IF <ls_order_item>-unddlv_tol IS NOT INITIAL.
        ls_order_item_x-unddlv_tol = 'X'.
      ENDIF.
      APPEND ls_order_item_x TO lt_order_items_x.

      "Fill Ext fields for items
      CLEAR ls_extensibility_fields_item.
      lv_key_as_string = lv_key.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_key_as_string
        IMPORTING
          output = ls_extensibility_fields_item-key.
      IF ls_testdata-ext_fields_item IS NOT INITIAL.
        LOOP AT ls_testdata-ext_fields_item ASSIGNING FIELD-SYMBOL(<ls_ext_field_item>).
          IF <ls_ext_field_item>-type EQ 'P'.
            ls_ext_field = |ls_extensibility_fields_item-data-{ <ls_ext_field_item>-name }|.
            ASSIGN (ls_ext_field) TO <ex_field_structure>.
            IF sy-subrc IS INITIAL.
              <ex_field_structure> = <ls_ext_field_item>-expected_input.
            ELSE.
              me->mo_run_environment->append_log( iv_log_statement = |Field  data-{ <ls_ext_field_item>-name } does not exist in bape_sdsalesdocitem .| ).
              lv_extensibility_error = abap_true.
            ENDIF.

            ls_ext_field = |ls_extensibility_fields_item-datax-{ <ls_ext_field_item>-name }|.
            ASSIGN (ls_ext_field) TO <ex_field_structure>.
            IF sy-subrc IS INITIAL.
              <ex_field_structure> = 'X'.
            ELSE.
              me->mo_run_environment->append_log( iv_log_statement = |Field datax-{ <ls_ext_field_item>-name } does not exist in bape_sdsalesdocitem .| ).
              lv_extensibility_error = abap_true.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.

      APPEND ls_extensibility_fields_item TO lt_extensibility_fields_item.
      lv_key = lv_key + lv_key_add.
    ENDLOOP.

*   map the Extensibility fields into a suitable EXTENSIONIN format
    lo_bapi_mapping = cl_cfd_bapi_mapping=>get_instance( ).
    GET REFERENCE OF lt_extensibility_fields_item INTO DATA(lr_ci_item_bapi_tab).
    TRY.
        lo_bapi_mapping->map_to_bapiparex_multi(
          EXPORTING
            ir_source_table = lr_ci_item_bapi_tab
          CHANGING
            ct_bapiparex    = lt_bapiparex ).
      CATCH cx_root.
    ENDTRY.

    "Fill Ext fields for Header
    CREATE DATA ls_extensibility_fields_header.
    LOOP AT ls_testdata-ext_fields_item ASSIGNING FIELD-SYMBOL(<ls_ext_field_header>).
      IF <ls_ext_field_header>-type = 'H'.
        ls_extensibility_fields_header->key = '0000000000000000'.
        ls_ext_field = |ls_extensibility_fields_header->data-{ <ls_ext_field_header>-name }|.
        ASSIGN (ls_ext_field) TO <ex_field_structure>.
        IF sy-subrc IS INITIAL.
          <ex_field_structure> = <ls_ext_field_header>-expected_input.
        ELSE.
          me->mo_run_environment->append_log( iv_log_statement = |Field  data-{ <ls_ext_field_header>-name } does not exist in bape_sdsalesdoc .| ).
          lv_extensibility_error = abap_true.
        ENDIF.

        ls_ext_field = |ls_extensibility_fields_header->datax-{ <ls_ext_field_header>-name }|.
        ASSIGN (ls_ext_field) TO <ex_field_structure>.
        IF sy-subrc IS INITIAL.
          <ex_field_structure> = 'X'.
        ELSE.
          me->mo_run_environment->append_log( iv_log_statement = |Field datax-{ <ls_ext_field_header>-name } does not exist in bape_sdsalesdoc .| ).
          lv_extensibility_error = abap_true.
        ENDIF.
      ENDIF.
    ENDLOOP.

    lo_bapi_mapping = cl_cfd_bapi_mapping=>get_instance( ).
    TRY.
        lo_bapi_mapping->map_to_bapiparex_single(
          EXPORTING
            ir_source_structure = ls_extensibility_fields_header
          CHANGING
            ct_bapiparex        = lt_bapiparex ).
      CATCH cx_root.
    ENDTRY.

    IF ls_testdata-purch_number IS INITIAL.
      ls_order_header_in-purch_no_c = 'CustRefPTF'.
    ELSE.
      ls_order_header_in-purch_no_c = ls_testdata-purch_number.
    ENDIF.

    IF iv_use_ref_material = abap_true.
      " Get referenced materials and use them in the sales order items.
      LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
        DATA(ls_ref_step_data) = me->mo_run_environment->get_step_data( iv_step_number = <lv_ref_step> ).
        IF ls_ref_step_data-bus_obj = c_bus_obj_material.
          LOOP AT ls_ref_step_data-document_id INTO DATA(ls_ptf_key).
            APPEND CONV #( ls_ptf_key-vbeln ) TO lt_matnr18.
          ENDLOOP.
        ENDIF.
      ENDLOOP.
      IF lt_matnr18 IS NOT INITIAL.
        LOOP AT lt_order_items ASSIGNING <ls_order_item>.
          READ TABLE lt_matnr18 INTO DATA(lv_matnr18) INDEX sy-tabix.
          IF sy-subrc IS INITIAL.
            <ls_order_item>-material = lv_matnr18.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

    IF lv_extensibility_error EQ abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |Action cancelled as there are problems with extensibility fields.| ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.

*****************************************************************************
* 4 Step: Create and commit Sales Order
    CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
      EXPORTING
        sales_header_in     = ls_order_header_in
        sales_header_inx    = ls_order_header_in_x
      IMPORTING
        salesdocument_ex    = lv_vbeln
      TABLES
        return              = lt_return
        extensionin         = lt_bapiparex
        extensionex         = lt_extensionex
        sales_items_in      = lt_order_items
        sales_items_inx     = lt_order_items_x
        sales_partners      = lt_order_partners
        sales_schedules_in  = lt_schedules
        sales_conditions_in = ls_testdata-condition
        partneraddresses    = ls_testdata-adress_data
        sales_text          = lt_sales_text
        sales_cfgs_ref      = ls_testdata-configuration_ref
        sales_cfgs_inst     = ls_testdata-configuration_inst
        sales_cfgs_value    = ls_testdata-configuration_value
        sales_cfgs_vk       = ls_testdata-configuration_vk.

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ls_ret_mes>).
      me->mo_run_environment->append_log( iv_log_statement = |{ <ls_ret_mes>-message }| ).
    ENDLOOP.
*****************************************************************************
* 5 Step: Check whether Sales Order exists
    DATA lv_ptf_key TYPE ptfkey.
    MOVE lv_vbeln TO lv_ptf_key.
    IF lv_vbeln IS NOT INITIAL.
      ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).
    ENDIF.
    CHECK ev_execution_status EQ abap_true. "!
*****************************************************************************
    SELECT SINGLE * FROM vbak INTO @DATA(ls_vbak) WHERE vbeln = @lv_vbeln.
    SELECT * FROM vbap INTO TABLE  @DATA(lt_vbap) WHERE vbeln = @lv_vbeln.
*****************************************************************************
* 6 Step: Check Billing Block and Remove it if set
    LOOP AT lt_vbap REFERENCE INTO DATA(lr_vbap_blocked) WHERE faksp <> space.
      me->mo_run_environment->append_log( iv_log_statement = |Billing block { lr_vbap_blocked->faksp } is set at item { lr_vbap_blocked->posnr }.| ).
    ENDLOOP.
    IF sy-subrc IS INITIAL OR ls_vbak-faksk NE space.
      IF ls_testdata-billing_block IS INITIAL.
        me->remove_billing_block( iv_order_number = lv_ptf_key ). "this removes only a header block. (Item block to be added)
      ENDIF.
    ENDIF.
*****************************************************************************
    APPEND lv_ptf_key TO ev_document_id.
*****************************************************************************
    "Log customer used
    me->mo_run_environment->append_log( iv_log_statement = |Sold-To is: { ls_vbak-kunnr }| ).
*****************************************************************************
    "Warn if quantities deviate
    LOOP AT lt_vbap REFERENCE INTO DATA(lr_vbap).
      IF lr_vbap->kbmeng LT lr_vbap->kwmeng.
        me->mo_run_environment->append_log( iv_log_statement = |Item { lr_vbap->posnr } , { lr_vbap->matnr }: Confirmed Qty { lr_vbap->kbmeng } is less than requested Qty { lr_vbap->kwmeng }| ).
      ENDIF.
    ENDLOOP.
*****************************************************************************
    "Log warning if blocked by credit check
    IF ls_vbak-cmgst EQ 'B' OR ls_vbak-cmgst EQ 'C'.
      me->mo_run_environment->append_log( iv_log_statement = |VBAK-CMGST: Credit check was started, it failed or set a block. Customer is { ls_vbak-kunnr }| ).
    ENDIF.

  ENDMETHOD.


  METHOD check_ml_vcm_category.
* this methods is used to check whether the VCM category iS ML ICo or not
* Will take Test data from test data container
    DATA lt_testdata        TYPE ty_t_or_check_ml_vcm_category.
    DATA lt_vbeln           TYPE cl_ptf_util=>ty_vbeln_tab.
    DATA lt_sales_key       TYPE STANDARD TABLE OF sales_key.
    DATA lt_vbap            TYPE vbap_tab.
    DATA lv_error_occurred  TYPE abap_bool.
    DATA lv_vbeln_c         TYPE string.
    DATA lv_posnr_c         TYPE string.

    FIELD-SYMBOLS <ls_sales_key> TYPE sales_key.
    FIELD-SYMBOLS <ls_vbap>      TYPE vbap.
    FIELD-SYMBOLS <ls_testdata>  TYPE ty_s_or_check_ml_vcm_category.


    ev_check_status       = abap_false.
    ev_execution_status   = abap_false.

    " get variant parameters from the testdata container data
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = is_step_data
      IMPORTING
        es_testdata  = lt_testdata
    ).

    " write parameter values into log
    LOOP AT lt_testdata ASSIGNING <ls_testdata>.
      me->mo_run_environment->append_log( iv_log_statement = |Parameter: Item { <ls_testdata>-posnr }, expected VCM Category: { <ls_testdata>-vcm_category } | ).
    ENDLOOP.

    " get SO(2)
    LOOP AT is_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      lt_vbeln = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_vbeln TO lt_sales_key.
    ENDLOOP.

    READ TABLE lt_vbeln ASSIGNING FIELD-SYMBOL(<ls_vbeln>) INDEX 1.
    IF <ls_vbeln> IS NOT ASSIGNED.
      me->mo_run_environment->append_log( iv_log_statement = |Error: SO(2) not found in reference step| ).
      RETURN.
    ENDIF.

    CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
      TABLES
        it_vbak_key           = lt_sales_key
        et_vbap               = lt_vbap
      EXCEPTIONS
        records_not_found     = 1
        records_not_requested = 2
        OTHERS                = 3.
    IF sy-subrc <> 0.
      me->mo_run_environment->append_log( iv_log_statement = |Error: No items found in SO(2) { <ls_vbeln>-vbeln }| ).
      RETURN.
    ENDIF.


    LOOP AT lt_vbap ASSIGNING <ls_vbap>.
      lv_vbeln_c = <ls_vbap>-vbeln.
      SHIFT lv_vbeln_c LEFT DELETING LEADING '0'.
      lv_posnr_c = <ls_vbap>-posnr.
      SHIFT lv_posnr_c LEFT DELETING LEADING '0'.

      me->mo_run_environment->append_log( iv_log_statement = |Processing document { lv_vbeln_c } item { lv_posnr_c }| ).

      UNASSIGN <ls_testdata>.

      READ TABLE lt_testdata ASSIGNING <ls_testdata>
        WITH KEY
          posnr = <ls_vbap>-posnr.

      IF sy-subrc = 0.
        " transit plant was provided -  this could be an empty value as well
        IF <ls_vbap>-vcm_chain_category <> <ls_testdata>-vcm_category.
          lv_error_occurred = abap_true.
          me->mo_run_environment->append_log( iv_log_statement = |Error: VCM Category wrong. Expected: { <ls_testdata>-vcm_category }, actual: | &&
                                                                 |{ <ls_vbap>-vcm_chain_category } | ).
        ENDIF.
      ENDIF.
    ENDLOOP.

    IF lv_error_occurred = abap_true.
      " at least one item has an error
      me->mo_run_environment->append_log( iv_log_statement = |Error occurred. Details see in log above| ).

    ELSE.
      " success
      me->mo_run_environment->append_log( iv_log_statement = |Success: VCM Category is as expected for all items| ).
      ev_check_status = abap_true.
      ev_execution_status = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD check_ml_vcm_financial_chain.

* this methods is used to check the Financial Chain ID iS returned for  ML ICo or not
* Will take Test data from test data container
    DATA lt_testdata        TYPE ty_t_or_check_ml_fin_chain.
    DATA lt_vbeln           TYPE cl_ptf_util=>ty_vbeln_tab.
    DATA lt_sales_key       TYPE STANDARD TABLE OF sales_key.
    DATA lt_vbap            TYPE vbap_tab.
    DATA lv_error_occurred  TYPE abap_bool.
    DATA lv_vbeln_c         TYPE string.
    DATA lv_posnr_c         TYPE string.

    FIELD-SYMBOLS <ls_sales_key> TYPE sales_key.
    FIELD-SYMBOLS <ls_vbap>      TYPE vbap.
    FIELD-SYMBOLS <ls_testdata>  TYPE ty_s_or_check_ml_fin_chain.

    ev_check_status       = abap_false.
    ev_execution_status   = abap_false.

    " get variant parameters from the testdata container data
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = is_step_data
      IMPORTING
        es_testdata  = lt_testdata
    ).

    " write parameter values into log
    LOOP AT lt_testdata ASSIGNING <ls_testdata>.
      me->mo_run_environment->append_log( iv_log_statement = |Parameter: Item { <ls_testdata>-posnr }, expected financial chain ID: { <ls_testdata>-financial_chain_id } | ).
      me->mo_run_environment->append_log( iv_log_statement = |Parameter: Item { <ls_testdata>-posnr }, expected VCM chain element ID: { <ls_testdata>-vcm_chain_element_id } | ).
    ENDLOOP.

    " get SO(2)
    LOOP AT is_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      lt_vbeln = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_vbeln TO lt_sales_key.
    ENDLOOP.

    READ TABLE lt_vbeln ASSIGNING FIELD-SYMBOL(<ls_vbeln>) INDEX 1.
    IF <ls_vbeln> IS NOT ASSIGNED.
      me->mo_run_environment->append_log( iv_log_statement = |Error: SO(2) not found in reference step| ).
      RETURN.
    ENDIF.

    CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
      TABLES
        it_vbak_key           = lt_sales_key
        et_vbap               = lt_vbap
      EXCEPTIONS
        records_not_found     = 1
        records_not_requested = 2
        OTHERS                = 3.
    IF sy-subrc <> 0.
      me->mo_run_environment->append_log( iv_log_statement = |Error: No items found in SO(2) { <ls_vbeln>-vbeln }| ).
      RETURN.
    ENDIF.


    LOOP AT lt_vbap ASSIGNING <ls_vbap>.
      lv_vbeln_c = <ls_vbap>-vbeln.
      SHIFT lv_vbeln_c LEFT DELETING LEADING '0'.
      lv_posnr_c = <ls_vbap>-posnr.
      SHIFT lv_posnr_c LEFT DELETING LEADING '0'.

      me->mo_run_environment->append_log( iv_log_statement = |Processing document { lv_vbeln_c } item { lv_posnr_c }| ).

      UNASSIGN <ls_testdata>.

      READ TABLE lt_testdata ASSIGNING <ls_testdata>
        WITH KEY
          posnr = <ls_vbap>-posnr.

      IF sy-subrc = 0.

        IF ( <ls_vbap>-vcm_chain_element_id <> <ls_testdata>-vcm_chain_element_id ) OR ( <ls_vbap>-financial_chain_id <> <ls_testdata>-financial_chain_id ).
          lv_error_occurred = abap_true.
          me->mo_run_environment->append_log( iv_log_statement = |Error: VCM Fin Chain wrong. Expected: { <ls_testdata>-financial_chain_id }, actual: | &&
                                                                 |{ <ls_vbap>-financial_chain_id } | ).
          me->mo_run_environment->append_log( iv_log_statement = |Error: VCM Chain Element Id wrong. Expected: { <ls_testdata>-vcm_chain_element_id }, actual: | &&
                                                                 |{ <ls_vbap>-vcm_chain_element_id } | ).
        ENDIF.
      ENDIF.

    ENDLOOP.

    IF lv_error_occurred = abap_true.
      " at least one item has an error
      me->mo_run_environment->append_log( iv_log_statement = |Error occurred. Details see in log above| ).

    ELSE.
      " success
      me->mo_run_environment->append_log( iv_log_statement = |Success: VCM Fin Chain and Chain Element ID is as expected for all items| ).
      ev_check_status = abap_true.
      ev_execution_status = abap_true.
    ENDIF.

  ENDMETHOD.


method check_ml_ic_wait_for_dc_so.
  data:
    lt_sales_key      type table of sales_key,
    lt_vbep           type table of bapisdhedu,  " BAPI schedule lines
    lt_vbap           type table of bapisditbos,
    lv_vbeln          type bapivbeln-vbeln,
    lv_so_tax_country type land1.

  " Get test parameters
  data(ls_testdata) = value ty_gs_ptf_or_check_ic_rpts_td( ).
  cl_ptf_util=>get_testdata(
    exporting is_step_data = step_data
    importing es_testdata  = ls_testdata ).

  " Initialize parameters
  data(lv_idle_seconds) = ls_testdata-idle_seconds + 15. " Buffer
  data(lv_max_repeats) = ls_testdata-max_repeats.
  data(lv_break_seconds) = ls_testdata-break_seconds.
  data(lv_attempts_max) = 1 + lv_max_repeats.

  " Log parameters
  me->mo_run_environment->append_log( |Parameter: Idle Seconds Before Start: { lv_idle_seconds }| ).
  me->mo_run_environment->append_log( |Parameter: Maximum repeats: { lv_max_repeats }| ).
  me->mo_run_environment->append_log( |Parameter: Seconds between repeats: { lv_break_seconds }| ).

  " Get sales orders from reference steps
  data(lt_vbeln) = value cl_ptf_util=>ty_vbeln_tab(
    for <lv_ref_step> in step_data-reference_step
    ( lines of me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ) ) ).

  if lt_vbeln is initial.
    me->mo_run_environment->append_log( 'Error: No Selling Company SO order found.' ).
    return.
  endif.

  lv_vbeln = lt_vbeln[ 1 ].
  append lines of lt_vbeln to lt_sales_key.

  " Initial wait
  wait up to lv_idle_seconds seconds.

  " Get SC_SO data using BAPI
  data(ls_vbak) = value bapisdhd( ).
  data(ls_dc_so_header) = value bapisdhd( ).
  call function 'BAPI_SALESORDER_GETDETAILBOS'
    exporting
      salesdocument      = lv_vbeln
    importing
      orderheader        = ls_vbak
    tables
      orderitems         = lt_vbap
      orderschedulelines = lt_vbep.

  if lt_vbep[] is initial.
    me->mo_run_environment->append_log( |Error: No items found in Selling Company SO order| ).
    return.
  endif.

  sort lt_vbep by doc_number itm_number confir_qty.
  delete lt_vbep where confir_qty is initial.

  " Find DC_SO links with retry logic
  data(lv_waiting_time) = 0.
  data(lv_attempts_act) = 0.
  data(lt_vcm_item)     = value ty_vcm_item_tab( ).
  data(lv_no_dc_so)     = abap_true.

  do lv_attempts_max times.
    lv_attempts_act += 1.

    select *
      from vcm_rt_bo_item as itema
      inner join vcm_rt_bo_item as itemb
        on itema~value_chain_ins_guid = itemb~value_chain_ins_guid
       and itema~value_chain_item_guid = itemb~value_chain_item_guid
      left outer join vcm_rt_step_ins as step
        on itemb~step_ins_guid = step~guid
      left outer join vcm_rt_chain_ins as chain
        on itemb~value_chain_ins_guid = chain~guid
      into table @lt_vcm_item
      where itema~business_object_id = @lv_vbeln
        and itema~business_object = 'SALES_ORDER'
        and itema~deleted = @space
        and itema~cancelled = @space
        and itemb~deleted = @space
        and itemb~cancelled = @space
        and step~step_type = 'DC_SO'
        and chain~status in ('C', 'E', 'O', 'PD').

    if lt_vcm_item is initial.
      lv_waiting_time += lv_break_seconds.
      wait up to lv_break_seconds seconds.
    else.
      lv_no_dc_so = abap_false.
      loop at lt_vcm_item assigning field-symbol(<ls_item_link>).
        if <ls_item_link>-itemb is initial.
          lv_no_dc_so = abap_true.
          exit.
        endif.
      endloop.

      if lv_no_dc_so = abap_false.
        exit. " Found valid DC_SO links
      else.
        lv_waiting_time += lv_break_seconds.
        wait up to lv_break_seconds seconds.
      endif.
    endif.
  enddo.

  me->mo_run_environment->append_log( |Attempts to read VCM item link: { lv_attempts_act }| ).
  me->mo_run_environment->append_log( |Total waiting time: { lv_waiting_time } seconds| ).

  if lv_no_dc_so = abap_false and lt_vcm_item is not initial.
    " First declare the type
    types: ty_vbeln_tab type standard table of vbeln with empty key .

    data(lt_dc_so_numbers) = value ty_vbeln_tab(
      for <fs_item> in lt_vcm_item
      ( conv vbeln( <fs_item>-itemb-business_object_id ) ) ).

    " Fetch DC_SO schedule lines
    if lt_dc_so_numbers is not initial.
      select vbeln, posnr, edatu, bmeng
        from vbep
        into table @data(lt_vbep_dc_std)
        for all entries in @lt_dc_so_numbers
        where vbeln = @lt_dc_so_numbers-table_line
          and bmeng > 0.
     DATA: lt_vbeln_range TYPE RANGE OF vbeln.

LOOP AT lt_dc_so_numbers INTO DATA(lv_vbeln1).
  APPEND VALUE #( sign = 'I' option = 'EQ' low = lv_vbeln1 ) TO lt_vbeln_range.
ENDLOOP.

SELECT vbap~vbeln,
       vbap~posnr,
       vbap~prctr,
       vbap~matnr,
       vbap~gsber,
       marc~werks,
       marc~prctr AS profit_centre
  INTO TABLE @DATA(lt_vbap_dc_std)
  FROM vbap
  INNER JOIN marc
    ON vbap~matnr = marc~matnr
  and vbap~gsber = marc~werks
 WHERE vbap~vbeln IN @lt_vbeln_range.
    endif.

    " Fetch DC_SO Partner function
    if lt_dc_so_numbers is not initial.
      select *
        from vbpa
        into table @data(lt_vbpa_dc_partner_function)
        for all entries in @lt_dc_so_numbers
        where vbeln = @lt_dc_so_numbers-table_line
        and parvw = @ls_testdata-partner_function.
    endif.

    loop at lt_vcm_item assigning <ls_item_link>.
      case ls_testdata-vcm_business_object.
        when 'EDATU'.
          read table lt_vbep assigning field-symbol(<ls_vbep>)
            with key doc_number = <ls_item_link>-itema-business_object_id
                     itm_number = <ls_item_link>-itema-business_object_item_id.
          check <ls_vbep>-req_date is not initial.

          read table lt_vbep_dc_std assigning field-symbol(<ls_vbep_dc>)
            with key vbeln = <ls_item_link>-itemb-business_object_id
                     posnr = <ls_item_link>-itemb-business_object_item_id.

          if <ls_vbep> is not initial and <ls_vbep_dc> is not initial.
            data(lv_edatu) = |{ <ls_vbep>-req_date+6(2) }.{ <ls_vbep>-req_date+4(2) }.{ <ls_vbep>-req_date(4) }|.
            data(lv_dc_date) = |{ <ls_vbep_dc>-edatu+6(2) }.{ <ls_vbep_dc>-edatu+4(2) }.{ <ls_vbep_dc>-edatu(4) }|.

            me->mo_run_environment->append_log( |**Checking First Date for SO { <ls_item_link>-itema-business_object_id }| ).
            me->mo_run_environment->append_log( |SO Date: { lv_edatu } | & |DC_SO Date: { lv_dc_date }| ).

            if <ls_vbep>-req_date = <ls_vbep_dc>-edatu.
              me->mo_run_environment->append_log( |Success: Dates match for DC_SO { <ls_item_link>-itemb-business_object_id }| ).
            else.
              me->mo_run_environment->append_log( |Failure: Date mismatch for DC_SO { <ls_item_link>-itemb-business_object_id }| ).
            endif.
          endif.

        when 'BMENG'.
          read table lt_vbep assigning <ls_vbep>
            with key doc_number = <ls_item_link>-itema-business_object_id
                     itm_number = <ls_item_link>-itema-business_object_item_id.
          check <ls_vbep>-confir_qty is not initial.

          read table lt_vbep_dc_std assigning <ls_vbep_dc>
            with key vbeln = <ls_item_link>-itemb-business_object_id
                     posnr = <ls_item_link>-itemb-business_object_item_id.

          if <ls_vbep> is not initial and <ls_vbep_dc> is not initial.
            me->mo_run_environment->append_log( |SO Qty: { <ls_vbep>-confir_qty } | & |DC_SO Qty: { <ls_vbep_dc>-bmeng }| ).

            if <ls_vbep>-confir_qty = <ls_vbep_dc>-bmeng.
              me->mo_run_environment->append_log( |Success: Qty match for DC_SO { <ls_item_link>-itemb-business_object_id }| ).
            else.
              me->mo_run_environment->append_log( |Failure: Qty mismatch for DC_SO { <ls_item_link>-itemb-business_object_id }| ).
            endif.
          endif.

        when 'TAXDEPT'.
          " Get DC_SO header data
          lv_vbeln = <ls_item_link>-itemb-business_object_id.
          call function 'BAPI_SALESORDER_GETDETAILBOS'
            exporting
              salesdocument = lv_vbeln " <ls_item_link>-itemb-business_object_id
            importing
              orderheader   = ls_dc_so_header
              tables
                orderitems  = lt_vbap.

          " Determine tax country from original SO
          if ls_dc_so_header-tax_depart is not initial.
            lv_so_tax_country = ls_dc_so_header-tax_depart.
          else.
            " Fallback to plant country if tax department not set in header
            read table lt_vbap assigning field-symbol(<ls_vbap>)
              with key doc_number = <ls_item_link>-itemb-business_object_id
                       itm_number = <ls_item_link>-itemb-business_object_item_id.
            if sy-subrc = 0 and <ls_vbap>-plant is not initial.
              select single land1 from t001w
                into lv_so_tax_country
                where werks = <ls_vbap>-plant.
            endif.
          endif.
          clear : lv_vbeln.
          " Compare tax countries
          if lv_so_tax_country is not initial.
             me->mo_run_environment->append_log( |**Checking Tax Departure country for SO { <ls_item_link>-itema-business_object_id }/{ <ls_item_link>-itema-business_object_item_id }| ).
            me->mo_run_environment->append_log( |**DC_SO: { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
            me->mo_run_environment->append_log( |SO Tax Country: '{ ls_vbak-tax_depart }' && | &
                                              |DC_SO Tax Destination Country: '{ ls_dc_so_header-tax_dest_ct }'|  ).
            me->mo_run_environment->append_log( |Expected Tax Destination Country: '{ lv_so_tax_country }' | ).

            if lv_so_tax_country = ls_dc_so_header-tax_dest_ct." <> ls_dc_so_header-tax_depart or ls_dc_so_header-tax_depart = ls_vbak-tax_depart.
              me->mo_run_environment->append_log( |Success: Tax country match for DC_SO { <ls_item_link>-itemb-business_object_id }| ).
            else.
              me->mo_run_environment->append_log( |Error: Tax country mismatch for DC_SO { <ls_item_link>-itemb-business_object_id }| ).
            endif.
          else.
            me->mo_run_environment->append_log( |Warning: Could not determine tax country for original SO| ).
          endif.
          clear : lv_so_tax_country.
         when 'PRCTR'.
           read table lt_vbap assigning <ls_vbap>
            with key doc_number = <ls_item_link>-itema-business_object_id
                     itm_number = <ls_item_link>-itema-business_object_item_id.
          check <ls_vbap>-PROFIT_CTR is not initial.

          read table lt_vbap_dc_std assigning field-symbol(<ls_vbap_dc>)
            with key vbeln = <ls_item_link>-itemb-business_object_id
                     posnr = <ls_item_link>-itemb-business_object_item_id.

          if <ls_vbap> is not initial and <ls_vbap_dc> is not initial.
            me->mo_run_environment->append_log( |**Checking Profit Centre for SO { <ls_item_link>-itema-business_object_id }| ).
            me->mo_run_environment->append_log( |SO Profit Centre: { <ls_vbap>-PROFIT_CTR } | & |DC_SO Date: { <ls_vbap_dc>-prctr }| ).
            me->mo_run_environment->append_log( |Expected Profit Centre: { <ls_vbap_dc>-profit_centre }| ).

            if <ls_vbap_dc>-prctr = <ls_vbap_dc>-profit_centre.
              me->mo_run_environment->append_log( |Success: Dates match for DC_SO { <ls_item_link>-itemb-business_object_id }| ).
            else.
              me->mo_run_environment->append_log( |Failure: Date mismatch for DC_SO { <ls_item_link>-itemb-business_object_id }| ).
            endif.
          endif.
        when 'SPLIT'.
          IF ( LINES( lt_dc_so_numbers ) = ls_testdata-number_of_objects ).
          mo_run_environment->append_log( |Success: Delivering company SO is split to { LINES( lt_dc_so_numbers ) }| ).
          ELSE.
          mo_run_environment->append_log( |Error: Delivering company SO is not splited as expected. Actual: '{ LINES( lt_dc_so_numbers ) }' && | &
                                          |Expected: '{ ls_testdata-number_of_objects }' | ).
          ENDIF.
        when 'PARTNER_FUNCTION_WE'.
          IF ( LINES( lt_vbpa_dc_partner_function ) > 0 ).
          mo_run_environment->append_log( |Success: Inter company SO is having the partner function: '{ ls_testdata-partner_function }' && | & | { lt_vbpa_dc_partner_function[ 1 ]-KUNNR } as expected | ).
          ELSE.
          mo_run_environment->append_log( |Error: Expected partner function  '{ ls_testdata-partner_function }' is not found| ).
          ENDIF.
        when others.
          me->mo_run_environment->append_log( |DC_SO found: { <ls_item_link>-itemb-business_object_id }| ).
      endcase.

      append <ls_item_link>-itemb-business_object_id(10) to ev_document_id.
    endloop.

    delete adjacent duplicates from ev_document_id.
    ev_check_status = abap_true.
    ev_execution_status = abap_true.
  else.
    me->mo_run_environment->append_log( 'Error: No DC_SO found within given attempts.' ).
    ev_check_status = abap_false.
  endif.
endmethod.


method check_ml_ic_wait_for_ic_po.

  data:
    ls_testdata       type ty_gs_ptf_or_check_ic_rpts_td,
    lt_sales_key      type table of sales_key,
    lv_so_tax_country type werks_d,
    lt_vbap           type table of bapisditbos,
    ls_vbak           type bapisdhd,
    ls_vbak1           type bapisdhd,
    lv_vbeln          type bapivbeln-vbeln,
    lt_vbep           type table of bapisdhedu.

  types:
    begin of ty_po_numbers,
      ebeln type ebeln,
      ebelp type ebelp,
    end of ty_po_numbers,
    ty_po_numbers_tab type standard table of ty_po_numbers with empty key.

  cl_ptf_util=>get_testdata(
    exporting is_step_data = step_data
    importing es_testdata  = ls_testdata ).

  data(lv_idle_seconds) = ls_testdata-idle_seconds.
  data(lv_max_repeats) = ls_testdata-max_repeats.
  data(lv_break_seconds) = ls_testdata-break_seconds.
  data(lv_attempts_max) = 1 + lv_max_repeats.

  me->mo_run_environment->append_log( |Parameter: Idle Seconds Before Start: { lv_idle_seconds }| ).
  me->mo_run_environment->append_log( |Parameter: Maximum repeats: { lv_max_repeats }| ).
  me->mo_run_environment->append_log( |Parameter: Seconds between repeats: { lv_break_seconds }| ).

  data(lt_vbeln) = value cl_ptf_util=>ty_vbeln_tab(
    for <lv_ref_step> in step_data-reference_step
    ( lines of me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ) ) ).

  if lt_vbeln is initial.
    me->mo_run_environment->append_log( 'Error: No SO2 order found.' ).
    return.
  endif.

  lv_vbeln = lt_vbeln[ 1 ].
  append lines of lt_vbeln to lt_sales_key.

  wait up to lv_idle_seconds seconds.

  call function 'BAPI_SALESORDER_GETDETAILBOS'
    exporting
      salesdocument      = lv_vbeln
    importing
      orderheader        = ls_vbak
    tables
      orderitems         = lt_vbap
      orderschedulelines = lt_vbep.

  if lt_vbep[] is not initial.
    sort lt_vbep by doc_number itm_number confir_qty.
    delete lt_vbep where confir_qty is initial.
  endif.

  data(lv_waiting_time) = 0.
  data(lv_attempts_act) = 0.
  data(lt_vcm_item) = value ty_vcm_item_tab( ).
  data(lv_no_ic_po) = abap_true.

  do lv_attempts_max times.
    lv_attempts_act += 1.

    select *
      from vcm_rt_bo_item as itema
      inner join vcm_rt_bo_item as itemb
        on  itema~value_chain_ins_guid = itemb~value_chain_ins_guid
        and itema~value_chain_item_guid = itemb~value_chain_item_guid
      left outer join vcm_rt_step_ins as step
        on itemb~step_ins_guid = step~guid
      left outer join vcm_rt_chain_ins as chain
        on itemb~value_chain_ins_guid = chain~guid
      into table @lt_vcm_item
      where itema~business_object_id = @lv_vbeln
        and itema~business_object = 'SALES_ORDER'
        and itema~deleted = @space
        and itema~cancelled = @space
        and itemb~deleted = @space
        and itemb~cancelled = @space
        and step~step_type = 'IC_PO'
        and chain~status in ('C', 'E', 'O', 'PD').

    if lt_vcm_item is initial.
      lv_waiting_time += lv_break_seconds.
      wait up to lv_break_seconds seconds.
    else.
      lv_no_ic_po = abap_false.
      loop at lt_vcm_item assigning field-symbol(<ls_item_link>).
        if <ls_item_link>-itemb is initial.
          lv_no_ic_po = abap_true.
          exit.
        endif.
      endloop.

      if lv_no_ic_po = abap_false.
        exit.
      else.
        lv_waiting_time += lv_break_seconds.
        wait up to lv_break_seconds seconds.
      endif.
    endif.
  enddo.

  me->mo_run_environment->append_log( |Attempts to read VCM item link: { lv_attempts_act }| ).
  me->mo_run_environment->append_log( |Total waiting time: { lv_waiting_time } seconds| ).

  if lt_vcm_item is initial or lv_no_ic_po = abap_true.
    me->mo_run_environment->append_log( 'Error: No Intercompany PO was found' ).
    return.
  endif.

  if lv_no_ic_po = abap_false and lt_vcm_item is not initial.
    data(lt_po_numbers) = value ty_po_numbers_tab(
      for <fs_item> in lt_vcm_item
      ( ebeln = <fs_item>-itemb-business_object_id
        ebelp = <fs_item>-itemb-business_object_item_id ) ).

    if lt_po_numbers is not initial.
   SELECT vbfa~vbelv ,
       vbfa~posnv ,
       eket~ebeln ,
       eket~ebelp ,
       eket~eindt ,
       ekpo~menge ,
       ekko~stceg_l
  FROM vbfa
  left outer JOIN eket ON eket~ebeln = vbfa~vbeln    " Join via VBELN (PO number)
  INNER JOIN ekpo ON eket~ebeln = ekpo~ebeln
                  AND eket~ebelp = ekpo~ebelp
  INNER JOIN ekko ON eket~ebeln = ekko~ebeln
  INTO TABLE @DATA(lt_po_sales_link)
  FOR ALL ENTRIES IN @lt_po_numbers
  WHERE vbfa~vbeln = @lt_po_numbers-ebeln.
    endif.

    loop at lt_vcm_item assigning <ls_item_link>.
      case ls_testdata-vcm_business_object.
        when 'EDATU'.
          read table lt_vbep assigning field-symbol(<ls_vbep>)
            with key doc_number = <ls_item_link>-itema-business_object_id
                    itm_number = <ls_item_link>-itema-business_object_item_id.
          check <ls_vbep>-req_date is not initial.

          read table lt_po_sales_link assigning field-symbol(<ls_eket>)
            with key ebeln = <ls_item_link>-itemb-business_object_id
                    ebelp = <ls_item_link>-itemb-business_object_item_id.

          if <ls_vbep> is not initial and <ls_eket> is not initial.
            data(lv_edatu) = |{ <ls_vbep>-req_date+6(2) }.{ <ls_vbep>-req_date+4(2) }.{ <ls_vbep>-req_date(4) }|.
            data(lv_eindt) = |{ <ls_eket>-eindt+6(2) }.{ <ls_eket>-eindt+4(2) }.{ <ls_eket>-eindt(4) }|.

            me->mo_run_environment->append_log( |**Checking First Date for SO { <ls_item_link>-itema-business_object_id }/{ <ls_item_link>-itema-business_object_item_id }| ).
            me->mo_run_environment->append_log( |**IC_PO: { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
            me->mo_run_environment->append_log( |SO Date: '{ lv_edatu }' && | & |PO Date: '{ lv_eindt }' | ).

            if <ls_vbep>-req_date = <ls_eket>-eindt.
              me->mo_run_environment->append_log( |Success: Dates match for IC_PO { <ls_item_link>-itemb-business_object_id }| ).
            else.
              me->mo_run_environment->append_log( |Failure: Date mismatch for IC_PO { <ls_item_link>-itemb-business_object_id }| ).
            endif.
          endif.
        when 'BMENG'.
          read table lt_vbep assigning <ls_vbep>
            with key doc_number = <ls_item_link>-itema-business_object_id
                    itm_number = <ls_item_link>-itema-business_object_item_id.
          check <ls_vbep>-confir_qty is not initial.

          read table lt_po_sales_link assigning <ls_eket>
            with key ebeln = <ls_item_link>-itemb-business_object_id
                    ebelp = <ls_item_link>-itemb-business_object_item_id.

          if <ls_vbep> is not initial and <ls_eket> is not initial.
            me->mo_run_environment->append_log( |**Checking Quantity for SO { <ls_item_link>-itema-business_object_id }/{ <ls_item_link>-itema-business_object_item_id }| ).
            me->mo_run_environment->append_log( |**IC_PO: { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
            me->mo_run_environment->append_log( |SO qty: '{ <ls_vbep>-confir_qty }' && | & |PO Qty: '{ <ls_eket>-menge }' | ).

            if <ls_vbep>-confir_qty = <ls_eket>-menge.
              me->mo_run_environment->append_log( |Success: Qty match for IC_PO { <ls_item_link>-itemb-business_object_id }| ).
            else.
              me->mo_run_environment->append_log( |Failure: Qty mismatch for IC_PO { <ls_item_link>-itemb-business_object_id }| ).
            endif.
          endif.

        when 'TAXDEPT'.
          read table lt_po_sales_link assigning <ls_eket>
      with key ebeln = <ls_item_link>-itemb-business_object_id
           ebelp = <ls_item_link>-itemb-business_object_item_id.

          call function 'BAPI_SALESORDER_GETDETAILBOS'
            exporting
              salesdocument = <ls_eket>-vbelv
            importing
              orderheader   = ls_vbak1
            tables
              orderitems    = lt_vbap.
          if sy-subrc = 0 .
            if ls_vbak1-tax_depart is not initial.
              lv_so_tax_country = ls_vbak1-tax_depart.
            else.
              read table lt_vbap assigning field-symbol(<ls_vbap>)
                with key doc_number = <ls_eket>-vbelv
                        itm_number = <ls_eket>-posnv.
              if sy-subrc = 0.
                select single land1 from t001w
                  into lv_so_tax_country
                  where werks = <ls_vbap>-plant.
              endif.
            endif.
          endif.
          clear lv_vbeln.

          if <ls_eket> is not initial.
            me->mo_run_environment->append_log( |**Checking Tax Departure for SO { <ls_item_link>-itema-business_object_id }/{ <ls_item_link>-itema-business_object_item_id }| ).
            me->mo_run_environment->append_log( |**IC_PO: { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
            me->mo_run_environment->append_log( |SO Tax Departure: '{ ls_vbak-tax_depart }' && | & |PO Tax Departure: '{ <ls_eket>-stceg_l }' | ).
            me->mo_run_environment->append_log( |Expected Tax Country: '{ lv_so_tax_country }' | ).
            if lv_so_tax_country = <ls_eket>-stceg_l.
              me->mo_run_environment->append_log( |Success: Tax Departure match for IC_PO { <ls_item_link>-itemb-business_object_id }| ).
            else.
              me->mo_run_environment->append_log( |Failure: Tax Departure mismatch for IC_PO { <ls_item_link>-itemb-business_object_id }| ).
            endif.
          endif.
          clear : lv_so_tax_country.
        when 'SPLIT'.
          IF ( LINES( lt_po_numbers ) = ls_testdata-number_of_objects ).
          mo_run_environment->append_log( |Success: Inter company PO is split to { LINES( lt_po_numbers ) }| ).
          ELSE.
          mo_run_environment->append_log( |Error: Inter company PO is not splited as expected. Actual: '{ LINES( lt_po_numbers ) }' && | &
                                          |Expected: '{ ls_testdata-number_of_objects }' | ).
          ENDIF.
        when others.
          me->mo_run_environment->append_log( |IC_PO order: { <ls_item_link>-itemb-business_object_id }  / item { <ls_item_link>-itemb-business_object_item_id }| ).
      endcase.
      append <ls_item_link>-itemb-business_object_id(10) to ev_document_id. "Take first 10 characters
    endloop.

    delete adjacent duplicates from ev_document_id.
    ev_check_status = abap_true.
    ev_execution_status = abap_true.
  else.
    me->mo_run_environment->append_log( 'Error: No IC_PO was found' ).
  endif.
endmethod.


method check_ml_ic_wait_for_ic_so.
  data:
    lt_sales_key      type table of sales_key,
    lt_vbep           type table of bapisdhedu,  " BAPI schedule lines
    lt_vbap           type table of bapisditbos,
    lv_vbeln          type bapivbeln-vbeln,
    lv_so_tax_country type land1.

  " Get test parameters
  data(ls_testdata) = value ty_gs_ptf_or_check_ic_rpts_td( ).
  cl_ptf_util=>get_testdata(
    exporting is_step_data = step_data
    importing es_testdata  = ls_testdata ).

  " Initialize parameters
  data(lv_idle_seconds) = ls_testdata-idle_seconds + 15. " Buffer
  data(lv_max_repeats) = ls_testdata-max_repeats.
  data(lv_break_seconds) = ls_testdata-break_seconds.
  data(lv_attempts_max) = 1 + lv_max_repeats.

  " Log parameters
  me->mo_run_environment->append_log( |Parameter: Idle Seconds Before Start: { lv_idle_seconds }| ).
  me->mo_run_environment->append_log( |Parameter: Maximum repeats: { lv_max_repeats }| ).
  me->mo_run_environment->append_log( |Parameter: Seconds between repeats: { lv_break_seconds }| ).

  " Get sales orders from reference steps
  data(lt_vbeln) = value cl_ptf_util=>ty_vbeln_tab(
    for <lv_ref_step> in step_data-reference_step
    ( lines of me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ) ) ).

  if lt_vbeln is initial.
    me->mo_run_environment->append_log( 'Error: No Selling Company SO order found.' ).
    return.
  endif.

  lv_vbeln = lt_vbeln[ 1 ].
  append lines of lt_vbeln to lt_sales_key.

  " Initial wait
  wait up to lv_idle_seconds seconds.

  " Get SO data using BAPI
  data(ls_vbak) = value bapisdhd( ).
  data(ls_ic_so_header) = value bapisdhd( ).
  call function 'BAPI_SALESORDER_GETDETAILBOS'
    exporting
      salesdocument      = lv_vbeln
    importing
      orderheader        = ls_vbak
    tables
      orderitems         = lt_vbap
      orderschedulelines = lt_vbep.

  if lt_vbep[] is initial.
    me->mo_run_environment->append_log( |Error: No items found in Selling Company SO order| ).
    return.
  endif.

  sort lt_vbep by doc_number itm_number confir_qty.
  delete lt_vbep where confir_qty is initial.

  " Find IC_SO links with retry logic
  data(lv_waiting_time) = 0.
  data(lv_attempts_act) = 0.
  data(lt_vcm_item)     = value ty_vcm_item_tab( ).
  data(lv_no_ic_so)     = abap_true.

  do lv_attempts_max times.
    lv_attempts_act += 1.

    select *
      from vcm_rt_bo_item as itema
      inner join vcm_rt_bo_item as itemb
        on itema~value_chain_ins_guid = itemb~value_chain_ins_guid
       and itema~value_chain_item_guid = itemb~value_chain_item_guid
      left outer join vcm_rt_step_ins as step
        on itemb~step_ins_guid = step~guid
      left outer join vcm_rt_chain_ins as chain
        on itemb~value_chain_ins_guid = chain~guid
      into table @lt_vcm_item
      where itema~business_object_id = @lv_vbeln
        and itema~business_object = 'SALES_ORDER'
        and itema~deleted = @space
        and itema~cancelled = @space
        and itemb~deleted = @space
        and itemb~cancelled = @space
        and step~step_type = 'IC_SO'
        and chain~status in ('C', 'E', 'O', 'PD').

    if lt_vcm_item is initial.
      lv_waiting_time += lv_break_seconds.
      wait up to lv_break_seconds seconds.
    else.
      lv_no_ic_so = abap_false.
      loop at lt_vcm_item assigning field-symbol(<ls_item_link>).
        if <ls_item_link>-itemb is initial.
          lv_no_ic_so = abap_true.
          exit.
        endif.
      endloop.

      if lv_no_ic_so = abap_false.
        exit. " Found valid IC_SO links
      else.
        lv_waiting_time += lv_break_seconds.
        wait up to lv_break_seconds seconds.
      endif.
    endif.
  enddo.

  me->mo_run_environment->append_log( |Attempts to read VCM item link: { lv_attempts_act }| ).
  me->mo_run_environment->append_log( |Total waiting time: { lv_waiting_time } seconds| ).

  if lv_no_ic_so = abap_false and lt_vcm_item is not initial.

    " First declare the type
    types: ty_vbeln_tab type standard table of vbeln with empty key.

    data(lt_ic_so_numbers) = value ty_vbeln_tab(
        for <fs_item> in lt_vcm_item
        ( conv vbeln( <fs_item>-itemb-business_object_id ) ) ).

    " Fetch IC_SO schedule lines
    if lt_ic_so_numbers is not initial.
      select vbeln, posnr, edatu, bmeng
        from vbep
        into table @data(lt_vbep_ic_std)
        for all entries in @lt_ic_so_numbers
        where vbeln = @lt_ic_so_numbers-table_line
          and bmeng > 0.
    endif.

    " Fetch IC_SO Partner function
    if lt_ic_so_numbers is not initial.
      select *
        from vbpa
        into table @data(lt_vbpa_ic_partner_function)
        for all entries in @lt_ic_so_numbers
        where vbeln = @lt_ic_so_numbers-table_line
        and parvw = @ls_testdata-partner_function.
    endif.

    loop at lt_vcm_item assigning <ls_item_link>.
      case ls_testdata-vcm_business_object.
        when 'EDATU'.
          read table lt_vbep assigning field-symbol(<ls_vbep>)
            with key doc_number = <ls_item_link>-itema-business_object_id
                     itm_number = <ls_item_link>-itema-business_object_item_id.
          check <ls_vbep>-req_date is not initial.

          read table lt_vbep_ic_std assigning field-symbol(<ls_vbep_ic>)
            with key vbeln = <ls_item_link>-itemb-business_object_id
                     posnr = <ls_item_link>-itemb-business_object_item_id.

          if <ls_vbep> is not initial and <ls_vbep_ic> is not initial.
            data(lv_edatu) = |{ <ls_vbep>-req_date+6(2) }.{ <ls_vbep>-req_date+4(2) }.{ <ls_vbep>-req_date(4) }|.
            data(lv_ic_date) = |{ <ls_vbep_ic>-edatu+6(2) }.{ <ls_vbep_ic>-edatu+4(2) }.{ <ls_vbep_ic>-edatu(4) }|.

            me->mo_run_environment->append_log( |**Checking First Date for SO { <ls_item_link>-itema-business_object_id }/{ <ls_item_link>-itema-business_object_item_id }| ).
            me->mo_run_environment->append_log( |**IC_SO: { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
            me->mo_run_environment->append_log( |SO Date: '{ lv_edatu }' && | & |IC_SO Date: { lv_ic_date }| ).

            if <ls_vbep>-req_date = <ls_vbep_ic>-edatu.
              me->mo_run_environment->append_log( |Success: Dates match for IC_SO { <ls_item_link>-itemb-business_object_id }| ).
            else.
              me->mo_run_environment->append_log( |Failure: Date mismatch for IC_SO { <ls_item_link>-itemb-business_object_id }| ).
            endif.
          endif.

        when 'BMENG'.
          read table lt_vbep assigning <ls_vbep>
            with key doc_number = <ls_item_link>-itema-business_object_id
                     itm_number = <ls_item_link>-itema-business_object_item_id.
          check <ls_vbep>-confir_qty is not initial.

          read table lt_vbep_ic_std assigning <ls_vbep_ic>
            with key vbeln = <ls_item_link>-itemb-business_object_id
                     posnr = <ls_item_link>-itemb-business_object_item_id.

          if <ls_vbep> is not initial and <ls_vbep_ic> is not initial.
            me->mo_run_environment->append_log( |**Checking quantity for SO { <ls_item_link>-itema-business_object_id }/{ <ls_item_link>-itema-business_object_item_id }| ).
            me->mo_run_environment->append_log( |**IC_SO: { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).

            me->mo_run_environment->append_log( |SO Qty: '{ <ls_vbep>-confir_qty }' && | & |IC_SO Qty: '{ <ls_vbep_ic>-bmeng }' | ).

            if <ls_vbep>-confir_qty = <ls_vbep_ic>-bmeng.
              me->mo_run_environment->append_log( |Success: Qty match for IC_SO { <ls_item_link>-itemb-business_object_id }| ).
            else.
              me->mo_run_environment->append_log( |Failure: Qty mismatch for IC_SO { <ls_item_link>-itemb-business_object_id }| ).
            endif.
          endif.

        when 'TAXDEPT'.
          lv_vbeln = <ls_item_link>-itemb-business_object_id.
          call function 'BAPI_SALESORDER_GETDETAILBOS'
            exporting
              salesdocument = lv_vbeln "<ls_item_link>-itemb-business_object_id
            importing
              orderheader   = ls_ic_so_header
            tables
              orderitems    = lt_vbap.

          if ls_ic_so_header-tax_depart is not initial.
            lv_so_tax_country = ls_ic_so_header-tax_depart.
          else.
            read table lt_vbap assigning field-symbol(<ls_vbap>)
              with key doc_number = <ls_item_link>-itemb-business_object_id
                      itm_number = <ls_item_link>-itemb-business_object_item_id.
            if sy-subrc = 0.
              select single land1 from t001w
                into lv_so_tax_country
                where werks = <ls_vbap>-plant.
            endif.
          endif.
          clear : lv_vbeln.

          if lv_so_tax_country is not initial.
            me->mo_run_environment->append_log( |**Checking Tax Departure for SO { <ls_item_link>-itema-business_object_id }/{ <ls_item_link>-itema-business_object_item_id }| ).
            me->mo_run_environment->append_log( |**IC_SO: { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
            me->mo_run_environment->append_log( |SO Tax Dept Country: '{ ls_vbak-tax_depart }'  && | & |IC_SO Destination Country: '{ ls_ic_so_header-tax_dest_ct }' | ).
            me->mo_run_environment->append_log( |Expected Tax Destination Country: '{ lv_so_tax_country }' | ).
            if lv_so_tax_country = ls_ic_so_header-tax_dest_ct." <> ls_ic_so_header-tax_depart or ls_ic_so_header-tax_depart = ls_vbak-tax_depart.
              me->mo_run_environment->append_log( |Success: Tax country match for IC_SO { <ls_item_link>-itemb-business_object_id }| ).
            else.
              me->mo_run_environment->append_log( |Error: Tax country mismatch for IC_SO { <ls_item_link>-itemb-business_object_id }| ).
            endif.
          endif.
          clear : lv_so_tax_country.
        when 'SPLIT'.
          IF ( LINES( lt_ic_so_numbers ) = ls_testdata-number_of_objects ).
          mo_run_environment->append_log( |Success: Inter company SO is split to { LINES( lt_ic_so_numbers ) }| ).
          ELSE.
          mo_run_environment->append_log( |Error: Inter company SO is not splited as expected. Actual: '{ LINES( lt_ic_so_numbers ) }' && | &
                                          |Expected: '{ ls_testdata-number_of_objects }' | ).
          ENDIF.
        when 'PARTNER_FUNCTION_WE'.
          IF ( LINES( lt_vbpa_ic_partner_function ) > 0 ).
          mo_run_environment->append_log( |Success: Inter company SO is having the partner function: '{ ls_testdata-partner_function }' && | & | { lt_vbpa_ic_partner_function[ 1 ]-KUNNR } as expected | ).
          ELSE.
          mo_run_environment->append_log( |Error: Expected partner function  '{ ls_testdata-partner_function }' is not found| ).
          ENDIF.
        when others.
          me->mo_run_environment->append_log( |IC_SO found: { <ls_item_link>-itemb-business_object_id }| ).
      endcase.

      append <ls_item_link>-itemb-business_object_id(10) to ev_document_id.
    endloop.

    delete adjacent duplicates from ev_document_id.
    ev_check_status = abap_true.

  else.
    me->mo_run_environment->append_log( 'Error: No IC_SO found within given attempts.' ).
    ev_check_status = abap_false.
  endif.

endmethod.


  METHOD check_ml_ic_wait_for_po3.
    " This will take the reference Object(Sales orer number) from the first step and check for the  Po3 step completion.
    DATA:
      ls_testdata      TYPE ty_gs_ptf_or_check_ic_rpts_td,
      lv_attempts_max  TYPE tb_attempts,  " maximumnumber of attempts
      lv_attempts_act  TYPE tb_attempts,  " actual attempts
      lv_waiting_time  TYPE s_mec_cputest_break_seconds,
      lv_idle_seconds  TYPE s_mec_cputest_break_seconds,  " Idle Seconds Before Start
      lv_max_repeats   TYPE /aif/repeat_counter,  " Maximum Number of Repeats
      lv_break_seconds TYPE s_mec_cputest_break_seconds,  " Break Seconds Between Repeats
      lt_vbeln         TYPE cl_ptf_util=>ty_vbeln_tab,
      lv_vbeln         TYPE vbeln_va,
      lt_sales_key     TYPE TABLE OF sales_key,
      lt_so2_item_key  TYPE if_vcm_value_chain_item_read=>tt_bo_item,
      ls_so2_item_key  LIKE LINE OF lt_so2_item_key,
      lt_vbap          TYPE TABLE OF vbap,
      lv_ic_relevant   TYPE boole_d,
      lv_ic_item_found TYPE boole_d,
      lv_no_po3        TYPE boole_d,
      lv_number(5)     TYPE c,
      lv_statement     TYPE bapi_msg
      .
    FIELD-SYMBOLS:
      <ls_vbap> TYPE vbap
      .

* get variant parameters from the testdata container data
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).
    lv_idle_seconds = ls_testdata-idle_seconds.  "  Number of Idle Seconds Before Start
    lv_max_repeats   = ls_testdata-max_repeats.  " Maximum Number of Repeats
    lv_break_seconds = ls_testdata-break_seconds.  " Number of Seconds Between Repeats

    lv_attempts_max  = 1 + lv_max_repeats.  " Maximum Number of Attempts = (first try) + (repeats)

* write parameter values into log
    lv_statement = 'Parameter: Idle Seconds Before Start: &1'.
    lv_number = lv_idle_seconds.
    REPLACE '&1' IN lv_statement WITH lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

    lv_statement = 'Parameter: Maximum number of repeats: &1'.
    lv_number = lv_max_repeats.
    REPLACE '&1' IN lv_statement WITH lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

    lv_statement = 'Parameter: Number of seconds between repeats: &1'.
    lv_number = lv_break_seconds.
    REPLACE '&1' IN lv_statement WITH lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

* get SO2
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
      APPEND LINES OF lt_ptf_keys TO lt_sales_key.
    ENDLOOP.
    CLEAR lv_vbeln.
    READ TABLE lt_vbeln INTO lv_vbeln INDEX 1.
    IF lv_vbeln IS INITIAL.
      lv_statement = 'Error: No SO2 order found.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      RETURN. " check fails
    ENDIF.


* Idle Seconds Before Start: wait for PO3 + SO4 to be created
    WAIT UP TO lv_idle_seconds SECONDS.


    DATA(lo_sd_sls_ic_utility) = cl_sd_sls_ic_factory=>so_instance->get_instance_util( ).

    " get link to PO/SO
    CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
      TABLES
        it_vbak_key           = lt_sales_key
*       ET_VBAPVB             =
        et_vbap               = lt_vbap
      EXCEPTIONS
        records_not_found     = 1
        records_not_requested = 2
        OTHERS                = 3.
    IF sy-subrc <> 0.
      lv_statement = 'Error: No items found in SO2 order &1'.
      REPLACE '&1' IN lv_statement WITH lv_vbeln.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      RETURN. " check fails
    ENDIF.

    LOOP AT lt_vbap ASSIGNING <ls_vbap>.
      ls_so2_item_key-object_id = <ls_vbap>-vbeln.
      ls_so2_item_key-item_id   = <ls_vbap>-posnr.
      ls_so2_item_key-step_type = 'SC_SO'.       "For ML Ico the Initiating step is Selling company Sales Order SC_SO
      APPEND ls_so2_item_key TO lt_so2_item_key.
    ENDLOOP.

    CLEAR lv_attempts_act.

    DO lv_attempts_max TIMES.
      ADD 1 TO lv_attempts_act.

      SELECT *
        FROM vcm_rt_bo_item AS itema
        INNER JOIN vcm_rt_bo_item AS itemb ON itema~value_chain_ins_guid = itemb~value_chain_ins_guid AND
                                              itema~value_chain_item_guid = itemb~value_chain_item_guid " [SG+]
        LEFT OUTER JOIN vcm_rt_step_ins AS step ON itemb~step_ins_guid = step~guid
        LEFT OUTER JOIN vcm_rt_chain_ins AS chain ON itemb~value_chain_ins_guid = chain~guid
        INTO TABLE @DATA(lt_vcm_item)
        WHERE itema~business_object_id = @lv_vbeln
         AND itema~business_object = 'SALES_ORDER'
         AND itema~deleted   = @space                                                                   " [SG+]
         AND itema~cancelled = @space                                                                   " [SG+]
         AND itemb~deleted   = @space                                                                   " [SG+]
         AND itemb~cancelled = @space                                                                   " [SG+]
         AND step~step_type = 'SC_PO'
         AND ( chain~status = 'C' OR chain~status = 'E' OR chain~status = 'O' OR chain~status = 'PD' ).

      IF lt_vcm_item IS INITIAL.
        ADD lv_break_seconds TO lv_waiting_time.
        WAIT UP TO lv_break_seconds SECONDS.
      ELSE.
        lv_no_po3 = abap_false.
        LOOP AT lt_vcm_item ASSIGNING FIELD-SYMBOL(<ls_item_link>).
          IF <ls_item_link>-itemb IS INITIAL.
            lv_no_po3 = abap_true.
          ENDIF.
        ENDLOOP.  " at lt_vcm_item assigning field-symbol(<ls_item_link>)
***
        IF lv_no_po3 EQ abap_true.
          ADD lv_break_seconds TO lv_waiting_time.
          WAIT UP TO lv_break_seconds SECONDS.
        ELSE.
*          lv_statement = 'Actual number of attempts to read the VCM item link: &1'.
*          lv_number = sy-index.
*          REPLACE '&1' IN lv_statement WITH lv_number.
*          me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
*
*          lv_statement = 'Total waiting time: &1'.
*          lv_number = lv_waiting_time.
*          REPLACE '&1' IN lv_statement WITH lv_number.
*          me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

          EXIT.
        ENDIF.   " IF lv_no_po3 NE abap_true
      ENDIF.
    ENDDO.

    lv_statement = 'Actual number of attempts to read the VCM item link: &1'.
    lv_number = lv_attempts_act.
    REPLACE '&1' IN lv_statement WITH lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

    lv_statement = 'Total waiting time: &1 seconds'.
    lv_number = lv_waiting_time.
    REPLACE '&1' IN lv_statement WITH lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).


    IF lv_no_po3 EQ abap_false.
* write the created SO4 into the output log
      LOOP AT lt_vcm_item ASSIGNING <ls_item_link>.

        lv_statement = 'PO3 order: OBJECT &1 , ITEM &2'.
        REPLACE '&1' IN lv_statement WITH <ls_item_link>-itemb-business_object_id.
        REPLACE '&2' IN lv_statement WITH <ls_item_link>-itemb-business_object_item_id.
        me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

      ENDLOOP.
    ENDIF.


    IF lt_vcm_item IS INITIAL  OR
       lv_no_po3    EQ abap_true.
      lv_statement = 'Error: No PO3( Selling Company was found'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      RETURN.
    ENDIF.

* set PTF method result
* we assume that at least 1 SO2 item must be IC-relevant
* for each IC-relevant item in SO2, a corresponding link to SO4 must exist!
    LOOP AT lt_vbap   ASSIGNING <ls_vbap>.

      TRY.
          lo_sd_sls_ic_utility->is_item_ic_relevant(
            EXPORTING
              iv_vbeln             = <ls_vbap>-vbeln
              iv_posnr             = <ls_vbap>-posnr
            RECEIVING
              rv_ic_relevance_item = lv_ic_relevant
          ).
        CATCH cx_sd_doc_not_found. " SD document cannot be found
          me->mo_run_environment->append_log( iv_log_statement = 'Error to determine IC relevance' ).
          RETURN. " failure!
      ENDTRY.
      IF lv_ic_relevant = abap_true.
        READ TABLE lt_vcm_item ASSIGNING <ls_item_link>
          WITH KEY
            itema-business_object_id = <ls_vbap>-vbeln
            itema-business_object_item_id   = <ls_vbap>-posnr.
        IF sy-subrc <> 0.
          me->mo_run_environment->append_log( iv_log_statement = 'Error to read SO2 items' ).
          RETURN. " failure!
        ENDIF.
        IF <ls_item_link>-itemb-business_object_id IS INITIAL OR
           <ls_item_link>-itemb-business_object_item_id   IS INITIAL.
          me->mo_run_environment->append_log( iv_log_statement = 'Error: No PO3 item number found' ).
          RETURN. " failure!
        ENDIF.
        " success: at least 1 IC item found!
        lv_ic_item_found = abap_true.
      ENDIF.
    ENDLOOP.

    " success?
    IF lv_ic_item_found = abap_true.
      me->mo_run_environment->append_log( iv_log_statement =
                                                             'Success: 1) At least 1 IC relevant item processed. 2) All IC relevant items have assigned PO3 item' ).
      ev_check_status = abap_true.
      ev_execution_status = abap_true.
      LOOP AT lt_vcm_item ASSIGNING <ls_item_link>.
        DATA(n) =  sy-tabix.
        IF line_exists( lt_vcm_item[ n ] ).
          APPEND lt_vcm_item[ n ]-itemb-business_object_id TO ev_document_id.
        ENDIF.
      ENDLOOP.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement =
                                                             'Error: No IC relevant item found, or some IC relevant item does not have PO3 counterpart' ).
    ENDIF.
    DELETE ADJACENT DUPLICATES FROM ev_document_id.
  ENDMETHOD.


method check_ml_ic_wait_for_sc_po.
  data:
    ls_testdata       type ty_gs_ptf_or_check_ic_rpts_td,
    lt_sales_key      type table of sales_key,
    lv_so_tax_country type werks_d,
    lt_vbap           type table of bapisditbos , "standard table of vbap,
    ls_vbak           type bapisdhd,
    lv_vbeln          TYPE BAPIVBELN-VBELN,
    lt_vbep           type table of bapisdhedu . "standard table of vbep.
  types:
    begin of ty_po_numbers,
      ebeln type ebeln,
      ebelp type ebelp,
    end of ty_po_numbers,
    ty_po_numbers_tab type standard table of ty_po_numbers with empty key.

  " Get test parameters
  cl_ptf_util=>get_testdata(
    exporting is_step_data = step_data
    importing es_testdata  = ls_testdata
  ).

  " Initialize parameters
  data(lv_idle_seconds) = ls_testdata-idle_seconds.
  data(lv_max_repeats) = ls_testdata-max_repeats.
  data(lv_break_seconds) = ls_testdata-break_seconds.
  data(lv_attempts_max) = 1 + lv_max_repeats.

  " Log parameters
  me->mo_run_environment->append_log( |Parameter: Idle Seconds Before Start: { lv_idle_seconds }| ).
  me->mo_run_environment->append_log( |Parameter: Maximum repeats: { lv_max_repeats }| ).
  me->mo_run_environment->append_log( |Parameter: Seconds between repeats: { lv_break_seconds }| ).

  " Get sales orders from reference steps
  data(lt_vbeln) = value cl_ptf_util=>ty_vbeln_tab(
    for <lv_ref_step> in step_data-reference_step
    ( lines of me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ) ) ).

  if lt_vbeln is initial.
    me->mo_run_environment->append_log( 'Error: No SO2 order found.' ).
    return.
  endif.

    lv_vbeln = lt_vbeln[ 1 ].
  append lines of lt_vbeln to lt_sales_key.

  " Initial wait
  wait up to lv_idle_seconds seconds.

  call function 'BAPI_SALESORDER_GETDETAILBOS'
    exporting
      salesdocument      = lv_vbeln
    importing
      orderheader        = ls_vbak
    tables
      orderitems         = lt_vbap
      orderschedulelines = lt_vbep
**     ORDERCONDITIONS          =
**     ORDERCONDHEAD            =
**     ORDERCONDITEM            =
    .
  If lt_vbep[] is NOT INITIAL.
    sort lt_vbep by doc_number itm_number confir_qty.
    Delete lt_vbep WHERE confir_qty is INITIAL.
    endif.
  " Find SC_PO links with retry logic
  data(lv_waiting_time) = 0.
  data(lv_attempts_act) = 0.
  data(lt_vcm_item) = value ty_vcm_item_tab( ).
  data(lv_no_sc_po) = abap_true.

  do lv_attempts_max times.
    lv_attempts_act += 1.

    select *
      from vcm_rt_bo_item as itema
      inner join vcm_rt_bo_item as itemb
        on  itema~value_chain_ins_guid = itemb~value_chain_ins_guid
        and itema~value_chain_item_guid = itemb~value_chain_item_guid
      left outer join vcm_rt_step_ins as step
        on itemb~step_ins_guid = step~guid
      left outer join vcm_rt_chain_ins as chain
        on itemb~value_chain_ins_guid = chain~guid
      into table @lt_vcm_item
      where itema~business_object_id = @lv_vbeln
        and itema~business_object = 'SALES_ORDER'
        and itema~deleted = @space
        and itema~cancelled = @space
        and itemb~deleted = @space
        and itemb~cancelled = @space
        and step~step_type = 'SC_PO'
        and chain~status in ('C', 'E', 'O', 'PD').

    if lt_vcm_item is initial.
      lv_waiting_time += lv_break_seconds.
      wait up to lv_break_seconds seconds.
    else.
      lv_no_sc_po = abap_false.
      loop at lt_vcm_item assigning field-symbol(<ls_item_link>).
        if <ls_item_link>-itemb is initial.
          lv_no_sc_po = abap_true.
          exit.
        endif.
      endloop.

      if lv_no_sc_po = abap_false.
        exit. " Found valid SC_PO links
      else.
        lv_waiting_time += lv_break_seconds.
        wait up to lv_break_seconds seconds.
      endif.
    endif.
  enddo.

  " Log attempts and waiting time
  me->mo_run_environment->append_log( |Attempts to read VCM item link: { lv_attempts_act }| ).
  me->mo_run_environment->append_log( |Total waiting time: { lv_waiting_time } seconds| ).

  " Check if SC_PO was found
  if lt_vcm_item is initial or lv_no_sc_po = abap_true.
    me->mo_run_environment->append_log( 'Error: No Selling company PO was found' ).
    return.
  endif.
  if lv_no_sc_po = abap_false and lt_vcm_item is not initial.
    " Create PO numbers table from VCM items
    data(lt_po_numbers) = value ty_po_numbers_tab(
      for <fs_item> in lt_vcm_item
      ( ebeln = <fs_item>-itemb-business_object_id
        ebelp = <fs_item>-itemb-business_object_item_id ) ).

    " Get PO schedule lines
    if lt_po_numbers is not initial.
      select eket~ebeln, eket~ebelp, eket~eindt, ekpo~menge, ekko~stceg_l
        from eket
        inner join ekpo on eket~ebeln = ekpo~ebeln
                       and eket~ebelp = ekpo~ebelp
        inner join ekko on eket~ebeln = ekko~ebeln
        into table @data(lt_eket)
        for all entries in @lt_po_numbers
        where eket~ebeln = @lt_po_numbers-ebeln
          and eket~ebelp = @lt_po_numbers-ebelp.
    endif.

    " Process date checks
    loop at lt_vcm_item assigning <ls_item_link>.
      case ls_testdata-vcm_business_object.
        when 'EDATU'.
          " Get corresponding SO schedule line
          read table lt_vbep assigning field-symbol(<ls_vbep>)
            with key doc_number = <ls_item_link>-itema-business_object_id
                    itm_number = <ls_item_link>-itema-business_object_item_id.

          check <ls_vbep>-req_date is not initial.

          " Get PO schedule line
          read table lt_eket assigning field-symbol(<ls_eket>)
            with key ebeln = <ls_item_link>-itemb-business_object_id
                    ebelp = <ls_item_link>-itemb-business_object_item_id.

          " Format dates
          if <ls_vbep> is not initial and <ls_eket> is not initial.
            data(lv_edatu) = |{ <ls_vbep>-req_date+6(2) }.{ <ls_vbep>-req_date+4(2) }.{ <ls_vbep>-req_date(4) }|.
            data(lv_eindt) = |{ <ls_eket>-eindt+6(2) }.{ <ls_eket>-eindt+4(2) }.{ <ls_eket>-eindt(4) }|.

            " Log comparison
            me->mo_run_environment->append_log( |**Checking First Date for SO { <ls_item_link>-itema-business_object_id }/{ <ls_item_link>-itema-business_object_item_id }| ).
            me->mo_run_environment->append_log( |**SC_PO: { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
            me->mo_run_environment->append_log( |SO Date: '{ lv_edatu }' && | & |PO Date: '{ lv_eindt }' | ).

            if <ls_vbep>-req_date = <ls_eket>-eindt.
              me->mo_run_environment->append_log( |Success: Dates match for SC_PO { <ls_item_link>-itemb-business_object_id }| ).
            else.
              me->mo_run_environment->append_log( |Failure: Date mismatch for SC_PO { <ls_item_link>-itemb-business_object_id }| ).
            endif.
          endif.
        when 'MENGE'.
          " Get corresponding SO schedule line
          read table lt_vbep assigning <ls_vbep>
            with key doc_number = <ls_item_link>-itema-business_object_id
                    itm_number = <ls_item_link>-itema-business_object_item_id.

          check <ls_vbep>-confir_qty is not initial.

          " Get PO schedule line
          read table lt_eket assigning <ls_eket>
            with key ebeln = <ls_item_link>-itemb-business_object_id
                    ebelp = <ls_item_link>-itemb-business_object_item_id.

          " Log comparison
          if <ls_vbep> is not initial and <ls_eket> is not initial.
            me->mo_run_environment->append_log( |**Checking Quantity for SO { <ls_item_link>-itema-business_object_id }/{ <ls_item_link>-itema-business_object_item_id }| ).
            me->mo_run_environment->append_log( |**SC_PO: { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
            me->mo_run_environment->append_log( |SO qty: '{ <ls_vbep>-confir_qty }' && | & |PO Qty: { <ls_eket>-menge }| ).

            if <ls_vbep>-confir_qty = <ls_eket>-menge.
              me->mo_run_environment->append_log( |Success: Qty match for SC_PO { <ls_item_link>-itemb-business_object_id }| ).
            else.
              me->mo_run_environment->append_log( |Failure: Qty mismatch for SC_PO { <ls_item_link>-itemb-business_object_id }| ).
            endif.
          endif.
        when 'TAXDEPT'.
          " Get PO schedule line
          assign lt_eket[ ebeln = <ls_item_link>-itemb-business_object_id
                          ebelp = <ls_item_link>-itemb-business_object_item_id ] to <ls_eket>.

          " Determine tax departure country
          lv_so_tax_country = cond #( when ls_vbak-tax_depart is not initial
                                            then ls_vbak-tax_depart
                                            else value #( lt_vbap[ doc_number = <ls_item_link>-itema-business_object_id
                                                                  itm_number = <ls_item_link>-itema-business_object_item_id ]-plant optional )
                                            ).

          if lv_so_tax_country is not initial and ls_vbak-tax_depart is initial.
            cl_sd_dbsel_cust=>so_instance->get_t001w_single(
              exporting
                iv_werks = lv_so_tax_country
              importing
                es_t001w = data(ls_t001w) ).
            lv_so_tax_country = ls_t001w-land1.
          endif.

          " Log comparison
          mo_run_environment->append_log( |**Tax Departure Check for SO { <ls_item_link>-itema-business_object_id }| ).
          mo_run_environment->append_log( |**SC_PO: { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
          mo_run_environment->append_log( |SO Country: '{ ls_vbak-tax_depart }' && | &
                                        |PO Country: '{ <ls_eket>-stceg_l }' | ).
          mo_run_environment->append_log( |Expected Tax Country: '{ lv_so_tax_country }' | ).

          " Validate tax countries
          if lv_so_tax_country = <ls_eket>-stceg_l.
            mo_run_environment->append_log( |Success: Tax country match for PO { <ls_item_link>-itemb-business_object_id }| ).
          else.
            mo_run_environment->append_log( |Error: Tax country mismatch for PO { <ls_item_link>-itemb-business_object_id }| ).
          endif.
          clear : lv_so_tax_country.
        when 'SPLIT'.
          IF ( LINES( lt_po_numbers ) = ls_testdata-number_of_objects ).
          mo_run_environment->append_log( |Success: Selling company PO is split to { LINES( lt_po_numbers ) }| ).
          ELSE.
          mo_run_environment->append_log( |Error: Selling company PO is not splited as expected. Actual: '{ LINES( lt_po_numbers ) }' && | &
                                          |Expected: '{ ls_testdata-number_of_objects }' | ).
          ENDIF.
        when others.
          mo_run_environment->append_log( |**SC_PO: { <ls_item_link>-itemb-business_object_id }| ).
      endcase.
      append <ls_item_link>-itemb-business_object_id(10) to ev_document_id. "Take first 10 characters
    endloop.
    " Set final status
    ev_check_status = abap_true.
    ev_execution_status = abap_true.
    delete adjacent duplicates from ev_document_id.
  else.
    me->mo_run_environment->append_log( 'Error: No SC_PO was found' ).
  endif.

endmethod.


  METHOD check_ml_ic_dc_so_created.

    DATA:
      ls_testdata      TYPE ty_gs_ptf_or_check_ic_rpts_td,
      lv_attempts_max  TYPE tb_attempts,  " maximumnumber of attempts
      lv_attempts_act  TYPE tb_attempts,  " actual attempts
      lv_waiting_time  TYPE s_mec_cputest_break_seconds,
      lv_idle_seconds  TYPE s_mec_cputest_break_seconds,  " Idle Seconds Before Start
      lv_max_repeats   TYPE /aif/repeat_counter,  " Maximum Number of Repeats
      lv_break_seconds TYPE s_mec_cputest_break_seconds,  " Break Seconds Between Repeats
      lt_vbeln         TYPE cl_ptf_util=>ty_vbeln_tab,
      lv_vbeln         TYPE vbeln_va,
      lt_sales_key     TYPE TABLE OF sales_key,
      lt_so2_item_key  TYPE if_vcm_value_chain_item_read=>tt_bo_item,
      ls_so2_item_key  LIKE LINE OF lt_so2_item_key,
      lt_vbap          TYPE TABLE OF vbap,
      lv_ic_relevant   TYPE boole_d,
      lv_ic_item_found TYPE boole_d,
      lv_no_so4        TYPE boole_d,
      lv_number(5)     TYPE c,
      lv_statement     TYPE bapi_msg
      .
    FIELD-SYMBOLS:
      <ls_vbap> TYPE vbap
      .

* get variant parameters from the testdata container data
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).
    lv_idle_seconds = ls_testdata-idle_seconds.  "  Number of Idle Seconds Before Start
    lv_max_repeats   = ls_testdata-max_repeats.  " Maximum Number of Repeats
    lv_break_seconds = ls_testdata-break_seconds.  " Number of Seconds Between Repeats

    lv_attempts_max  = 1 + lv_max_repeats.  " Maximum Number of Attempts = (first try) + (repeats)

* write parameter values into log
    lv_statement = 'Parameter: Idle Seconds Before Start: &1'.
    lv_number = lv_idle_seconds.
    REPLACE '&1' IN lv_statement WITH lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

    lv_statement = 'Parameter: Maximum number of repeats: &1'.
    lv_number = lv_max_repeats.
    REPLACE '&1' IN lv_statement WITH lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

    lv_statement = 'Parameter: Number of seconds between repeats: &1'.
    lv_number = lv_break_seconds.
    REPLACE '&1' IN lv_statement WITH lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

* get SO2
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
      APPEND LINES OF lt_ptf_keys TO lt_sales_key.
    ENDLOOP.
    CLEAR lv_vbeln.
    READ TABLE lt_vbeln INTO lv_vbeln INDEX 1.
    IF lv_vbeln IS INITIAL.
      lv_statement = 'Error: No SO2 order found.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      RETURN. " check fails
    ENDIF.


* Idle Seconds Before Start: wait for PO3 + SO4 to be created
    WAIT UP TO lv_idle_seconds SECONDS.


    DATA(lo_sd_sls_ic_utility) = cl_sd_sls_ic_factory=>so_instance->get_instance_util( ).

    " get link to PO/SO
    CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
      TABLES
        it_vbak_key           = lt_sales_key
*       ET_VBAPVB             =
        et_vbap               = lt_vbap
      EXCEPTIONS
        records_not_found     = 1
        records_not_requested = 2
        OTHERS                = 3.
    IF sy-subrc <> 0.
      lv_statement = 'Error: No items found in SO2 order &1'.
      REPLACE '&1' IN lv_statement WITH lv_vbeln.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      RETURN. " check fails
    ENDIF.

    LOOP AT lt_vbap ASSIGNING <ls_vbap>.
      ls_so2_item_key-object_id = <ls_vbap>-vbeln.
      ls_so2_item_key-item_id   = <ls_vbap>-posnr.
      ls_so2_item_key-step_type = 'SC_SO'."For ML Ico the Initiating step is Selling company Sales Order SC_SO
      APPEND ls_so2_item_key TO lt_so2_item_key.
    ENDLOOP.

    CLEAR lv_attempts_act.

    DO lv_attempts_max TIMES.
      ADD 1 TO lv_attempts_act.

      SELECT *
        FROM vcm_rt_bo_item AS itema
        INNER JOIN vcm_rt_bo_item AS itemb ON itema~value_chain_ins_guid = itemb~value_chain_ins_guid AND
                                              itema~value_chain_item_guid = itemb~value_chain_item_guid " [SG+]
        LEFT OUTER JOIN vcm_rt_step_ins AS step ON itemb~step_ins_guid = step~guid
        LEFT OUTER JOIN vcm_rt_chain_ins AS chain ON itemb~value_chain_ins_guid = chain~guid
        INTO TABLE @DATA(lt_vcm_item)
        WHERE itema~business_object_id = @lv_vbeln
         AND itema~business_object = 'SALES_ORDER'
         AND itema~deleted   = @space                                                                   " [SG+]
         AND itema~cancelled = @space                                                                   " [SG+]
         AND itemb~deleted   = @space                                                                   " [SG+]
         AND itemb~cancelled = @space                                                                   " [SG+]
         AND step~step_type = 'DC_SO'
         AND ( chain~status = 'C' OR chain~status = 'E' OR chain~status = 'O' OR chain~status = 'PD' ).

      IF lt_vcm_item IS INITIAL.
        ADD lv_break_seconds TO lv_waiting_time.
        WAIT UP TO lv_break_seconds SECONDS.
      ELSE.
        lv_no_so4 = abap_false.
        LOOP AT lt_vcm_item ASSIGNING FIELD-SYMBOL(<ls_item_link>).
          IF <ls_item_link>-itemb IS INITIAL.
            lv_no_so4 = abap_true.
          ENDIF.
        ENDLOOP.  " at lt_vcm_item assigning field-symbol(<ls_item_link>)
***
        IF lv_no_so4 EQ abap_true.
          ADD lv_break_seconds TO lv_waiting_time.
          WAIT UP TO lv_break_seconds SECONDS.
        ELSE.
*          lv_statement = 'Actual number of attempts to read the VCM item link: &1'.
*          lv_number = sy-index.
*          REPLACE '&1' IN lv_statement WITH lv_number.
*          me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
*
*          lv_statement = 'Total waiting time: &1'.
*          lv_number = lv_waiting_time.
*          REPLACE '&1' IN lv_statement WITH lv_number.
*          me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

          EXIT.
        ENDIF.   " IF lv_no_so4 NE abap_true
      ENDIF.
    ENDDO.

    lv_statement = 'Actual number of attempts to read the VCM item link: &1'.
    lv_number = lv_attempts_act.
    REPLACE '&1' IN lv_statement WITH lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

    lv_statement = 'Total waiting time: &1 seconds'.
    lv_number = lv_waiting_time.
    REPLACE '&1' IN lv_statement WITH lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).


    IF lv_no_so4 EQ abap_false.
* write the created SO4 into the output log
      LOOP AT lt_vcm_item ASSIGNING <ls_item_link>.

        lv_statement = 'SO4 order: OBJECT &1 , ITEM &2'.
        REPLACE '&1' IN lv_statement WITH <ls_item_link>-itemb-business_object_id.
        REPLACE '&2' IN lv_statement WITH <ls_item_link>-itemb-business_object_item_id.
        me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

      ENDLOOP.
    ENDIF.


    IF lt_vcm_item IS INITIAL  OR
       lv_no_so4    EQ abap_true.
      lv_statement = 'Error: No SO4 was found'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      RETURN.
    ENDIF.

* set PTF method result
* we assume that at least 1 SO2 item must be IC-relevant
* for each IC-relevant item in SO2, a corresponding link to SO4 must exist!
    LOOP AT lt_vbap   ASSIGNING <ls_vbap>.

      TRY.
          lo_sd_sls_ic_utility->is_item_ic_relevant(
            EXPORTING
              iv_vbeln             = <ls_vbap>-vbeln
              iv_posnr             = <ls_vbap>-posnr
            RECEIVING
              rv_ic_relevance_item = lv_ic_relevant
          ).
        CATCH cx_sd_doc_not_found. " SD document cannot be found
          me->mo_run_environment->append_log( iv_log_statement = 'Error to determine IC relevance' ).
          RETURN. " failure!
      ENDTRY.
      IF lv_ic_relevant = abap_true.
        READ TABLE lt_vcm_item ASSIGNING <ls_item_link>
          WITH KEY
            itema-business_object_id = <ls_vbap>-vbeln
            itema-business_object_item_id   = <ls_vbap>-posnr.
        IF sy-subrc <> 0.
          me->mo_run_environment->append_log( iv_log_statement = 'Error to read SO2 items' ).
          RETURN. " failure!
        ENDIF.
        IF <ls_item_link>-itemb-business_object_id IS INITIAL OR
           <ls_item_link>-itemb-business_object_item_id   IS INITIAL.
          me->mo_run_environment->append_log( iv_log_statement = 'Error: No SO4 item number found' ).
          RETURN. " failure!
        ENDIF.
        " success: at least 1 IC item found!
        lv_ic_item_found = abap_true.
      ENDIF.
    ENDLOOP.

    " success?
    IF lv_ic_item_found = abap_true.
      me->mo_run_environment->append_log( iv_log_statement =
                                                             'Success: 1) At least 1 IC relevant item processed. 2) All IC relevant items have assigned SO4 item' ).
      ev_check_status = abap_true.
      ev_execution_status = abap_true.
      IF line_exists( lt_vcm_item[ 1 ] ).
        APPEND lt_vcm_item[ 1 ]-itemb-business_object_id TO ev_document_id.
      ENDIF.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement =
                                                             'Error: No IC relevant item found, or some IC relevant item does not have SO4 counterpart' ).
    ENDIF.



  ENDMETHOD.


  METHOD ml_vcm_chk_cat_micl_icsl."MULLAPULLI

    " Initialization
    DATA: lt_testdata       TYPE ty_t_or_check_ml_vcm_category,
          lt_vbeln          TYPE cl_ptf_util=>ty_vbeln_tab,
          lt_sales_key      TYPE STANDARD TABLE OF sales_key,
          lt_vbap           TYPE vbap_tab,
          lv_error_occurred TYPE abap_bool VALUE abap_false,
          lv_vbeln_c        TYPE string,
          lv_posnr_c        TYPE string.

    FIELD-SYMBOLS: <ls_sales_key> TYPE sales_key,
                   <ls_vbap>      TYPE vbap,
                   <ls_testdata>  TYPE ty_s_or_check_ml_vcm_category,
                   <lv_ref_step>  TYPE i,
                   <ls_vbeln>     TYPE cl_ptf_util=>ty_vbeln.

    ev_check_status       = abap_false.
    ev_execution_status   = abap_false.

    " 1. Load test data from test container
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = is_step_data
      IMPORTING
        es_testdata  = lt_testdata
    ).

    LOOP AT lt_testdata ASSIGNING <ls_testdata>.
      me->mo_run_environment->append_log(
        iv_log_statement = |Test Param: Item { <ls_testdata>-posnr }, expected VCM Category: { <ls_testdata>-vcm_category }| ).
    ENDLOOP.

    " 2. Get SO2 (SCSO) from reference step(s)
    LOOP AT is_step_data-reference_step ASSIGNING <lv_ref_step>.
      lt_vbeln = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_vbeln TO lt_sales_key.
    ENDLOOP.

    READ TABLE lt_sales_key ASSIGNING <ls_sales_key> INDEX 1.
    IF <ls_sales_key> IS NOT ASSIGNED.
      me->mo_run_environment->append_log( iv_log_statement = 'Error: SO2 (SCSO) not found in reference step.' ).
      RETURN.
    ENDIF.

    " 3. Read items from SO2(SCSO)
    CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
      TABLES
        it_vbak_key           = lt_sales_key
        et_vbap               = lt_vbap
      EXCEPTIONS
        records_not_found     = 1
        records_not_requested = 2
        OTHERS                = 3.
    IF sy-subrc <> 0.
      me->mo_run_environment->append_log(
        iv_log_statement = |Error: No items found in SO2(SCSO) { <ls_sales_key>-vbeln }| ).
      RETURN.
    ENDIF.

    " 4. Compare each item with expected category
    LOOP AT lt_vbap ASSIGNING <ls_vbap>.

      lv_vbeln_c = <ls_vbap>-vbeln.
      SHIFT lv_vbeln_c LEFT DELETING LEADING '0'.
      lv_posnr_c = <ls_vbap>-posnr.
      SHIFT lv_posnr_c LEFT DELETING LEADING '0'.

      me->mo_run_environment->append_log(
        iv_log_statement = |Processing SCSO Item { lv_vbeln_c } / { lv_posnr_c }| ).

      READ TABLE lt_testdata ASSIGNING <ls_testdata>
        WITH KEY posnr = <ls_vbap>-posnr.

      IF sy-subrc = 0.
        IF <ls_vbap>-vcm_chain_category <> <ls_testdata>-vcm_category.
          lv_error_occurred = abap_true.
          me->mo_run_environment->append_log(
            iv_log_statement = |Mismatch: Expected VCM Category { <ls_testdata>-vcm_category }, Found { <ls_vbap>-vcm_chain_category } for Item { lv_posnr_c }| ).
        ELSE.
          me->mo_run_environment->append_log(
            iv_log_statement = |VCM Category match for Item { lv_posnr_c } – { <ls_testdata>-vcm_category }| ).
        ENDIF.
      ELSE.
        me->mo_run_environment->append_log(
          iv_log_statement = |No testdata found for Item { lv_posnr_c }, skipping VCM Category check| ).
      ENDIF.

    ENDLOOP.

    " 5. Final result
    IF lv_error_occurred = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = 'At least one VCM Category mismatch found. Check above logs.' ).
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = 'All VCM Categories match expected values.' ).
      ev_check_status = abap_true.
      ev_execution_status = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD ml_vcm_chk_fin_chain_id. "mullapulli
* This method validates that the financial chain ID and VCM chain element ID
* are consistent across the Selling Company Sales Order (SO2 / SCSO),
* the Delivering Company Sales Order (DCSO), and Intercompany Sales Order(s) (IC_SO).

    DATA: lt_testdata        TYPE ty_t_or_check_ml_fin_chain,
          lt_vbeln           TYPE cl_ptf_util=>ty_vbeln_tab,
          lt_sales_key       TYPE STANDARD TABLE OF sales_key,
          lt_vbap_all        TYPE vbap_tab,
          lt_vcm_item_all_so TYPE ty_vcm_item_tab,
          lv_error_occurred  TYPE abap_bool,
          lv_vbeln_conv      TYPE vcm_business_object_id,
          lv_posnr_conv      TYPE vcm_business_object_item_id,
          lv_ref_vbeln       TYPE vbeln_va,
          lv_statement       TYPE string,
          lt_doc_keys        TYPE cl_ptf_util=>ty_vbeln_tab.

    FIELD-SYMBOLS: <ls_testdata> TYPE ty_s_or_check_ml_fin_chain,
                   <ls_vbap>     TYPE vbap,
                   <lv_ref_step> TYPE i,
                   <ls_vcm_item> TYPE ty_vcm_item.

    ev_check_status = abap_false.
    ev_execution_status = abap_false.

    cl_ptf_util=>get_testdata(
      EXPORTING is_step_data = is_step_data
      IMPORTING es_testdata  = lt_testdata ).

    LOOP AT lt_testdata ASSIGNING <ls_testdata>.
      me->mo_run_environment->append_log( iv_log_statement = |Parameter: Item { <ls_testdata>-posnr }, expected financial chain ID: { <ls_testdata>-financial_chain_id } | ).
*      me->mo_run_environment->append_log( iv_log_statement = |Parameter: Item { <ls_testdata>-posnr }, expected VCM chain element ID: { <ls_testdata>-vcm_chain_element_id } | ).
    ENDLOOP.

    " Gather SCSO sales orders
    LOOP AT is_step_data-reference_step ASSIGNING <lv_ref_step>.
      lt_vbeln = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_vbeln TO lt_sales_key.
      APPEND LINES OF lt_vbeln TO lt_doc_keys.
    ENDLOOP.

    READ TABLE lt_vbeln INTO lv_ref_vbeln INDEX 1.
    IF lv_ref_vbeln IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = 'Error: SCSO (SO2) not found in reference step.' ).
      RETURN.
    ENDIF.

    " Read VBAP data for SCSO
    CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
      TABLES
        it_vbak_key = lt_sales_key
        et_vbap     = lt_vbap_all.

    " Read DCSO and IC_SO document links from VCM
    SELECT *
      FROM vcm_rt_bo_item AS itema
      INNER JOIN vcm_rt_bo_item AS itemb ON itema~value_chain_ins_guid = itemb~value_chain_ins_guid
                                        AND itema~value_chain_item_guid = itemb~value_chain_item_guid
      LEFT OUTER JOIN vcm_rt_step_ins AS step ON itemb~step_ins_guid = step~guid
      INTO TABLE @lt_vcm_item_all_so
      WHERE itema~business_object_id = @lv_ref_vbeln
        AND itema~business_object = 'SALES_ORDER'
        AND itema~deleted = @space
        AND itema~cancelled = @space
        AND itemb~deleted = @space
        AND itemb~cancelled = @space
        AND step~step_type IN ('DC_SO', 'IC_SO').

    " Add DCSO and IC_SO document numbers to list
    LOOP AT lt_vcm_item_all_so ASSIGNING <ls_vcm_item>.
      APPEND <ls_vcm_item>-itemb-business_object_id TO lt_doc_keys.
    ENDLOOP.
    DELETE ADJACENT DUPLICATES FROM lt_doc_keys.

    " Read VBAP data for DCSO and IC_SO documents
    CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
      TABLES
        it_vbak_key = lt_doc_keys
        et_vbap     = lt_vbap_all.

    LOOP AT lt_vbap_all ASSIGNING <ls_vbap>.
      lv_vbeln_conv = CONV vcm_business_object_id( <ls_vbap>-vbeln ).
      lv_posnr_conv = CONV vcm_business_object_item_id( <ls_vbap>-posnr ).

      " Determine document type prefix
      DATA(lv_prefix) = ||.
      READ TABLE lt_vbeln WITH KEY table_line = <ls_vbap>-vbeln TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
        lv_prefix = 'SCSO'.
      ELSE.
        READ TABLE lt_vcm_item_all_so ASSIGNING <ls_vcm_item>
          WITH KEY itemb-business_object_id = <ls_vbap>-vbeln.
        IF sy-subrc = 0.
          CASE <ls_vcm_item>-step-step_type.
            WHEN 'DC_SO'. lv_prefix = 'DCSO'.
            WHEN 'IC_SO'. lv_prefix = 'ICSO'.
          ENDCASE.
        ENDIF.
      ENDIF.

      me->mo_run_environment->append_log(
        iv_log_statement = |Checking { lv_prefix } { <ls_vbap>-vbeln }/{ <ls_vbap>-posnr }| ).

      READ TABLE lt_testdata ASSIGNING <ls_testdata> WITH KEY posnr = <ls_vbap>-posnr.
      IF sy-subrc = 0.
        IF
*        <ls_vbap>-vcm_chain_element_id <> <ls_testdata>-vcm_chain_element_id OR
           <ls_vbap>-financial_chain_id    <> <ls_testdata>-financial_chain_id.

          lv_error_occurred = abap_true.
          me->mo_run_environment->append_log(
            iv_log_statement = |Mismatch in { lv_prefix } { <ls_vbap>-vbeln }/{ <ls_vbap>-posnr }| ).
*          me->mo_run_environment->append_log(
*            iv_log_statement = |Expected Chain ID: { <ls_testdata>-vcm_chain_element_id }, Actual: { <ls_vbap>-vcm_chain_element_id }| ).
          me->mo_run_environment->append_log(
            iv_log_statement = |Expected Fin Chain: { <ls_testdata>-financial_chain_id }, Actual: { <ls_vbap>-financial_chain_id }| ).
        ENDIF.
      ENDIF.
    ENDLOOP.

    IF lv_error_occurred = abap_true.
*      me->mo_run_environment->append_log( iv_log_statement = 'One or more financial chain or VCM chain ID mismatches detected.' ).
      me->mo_run_environment->append_log( iv_log_statement = 'One or more financial chain ID mismatches detected.' ).
    ELSE.
*      me->mo_run_environment->append_log( iv_log_statement = 'All financial chain IDs and chain element IDs match expected values.' ).
      me->mo_run_environment->append_log( iv_log_statement = 'All financial chain IDs match expected values.' ).
      ev_check_status     = abap_true.
      ev_execution_status = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD ml_vcm_chk_no_trst_plnt_dcso. "mullapulli
* This method checks that the transit plant is NOT filled for DC_SO items linked to an SCSO document.

    DATA: lt_vbeln_scso  TYPE cl_ptf_util=>ty_vbeln_tab,
          lt_sales_key   TYPE STANDARD TABLE OF sales_key,
          lt_vbap_dcso   TYPE vbap_tab,
          lt_vcm_items   TYPE ty_vcm_item_tab,
          lv_vbeln_scso  TYPE vbeln_va,
          lv_error_found TYPE abap_bool,
          lv_vbeln       TYPE string,
          lv_posnr       TYPE string,
          lv_prefix      TYPE string VALUE 'DCSO'.

    FIELD-SYMBOLS: <ls_vbap>     TYPE vbap,
                   <ls_vcm_item> TYPE ty_vcm_item,
                   <lv_ref_step> TYPE i.

    ev_check_status     = abap_false.
    ev_execution_status = abap_false.

    " Get SCSO document numbers from reference steps
    LOOP AT is_step_data-reference_step ASSIGNING <lv_ref_step>.
      DATA(lt_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_keys TO lt_vbeln_scso.
      APPEND LINES OF lt_keys TO lt_sales_key.
    ENDLOOP.

    READ TABLE lt_vbeln_scso INTO lv_vbeln_scso INDEX 1.
    IF lv_vbeln_scso IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = 'Error: No SCSO document found in reference step.' ).
      RETURN.
    ENDIF.

    " Use SCSO VBELN directly to get VCM entries for DCSO
    SELECT *
      FROM vcm_rt_bo_item AS itema
      INNER JOIN vcm_rt_bo_item AS itemb ON itema~value_chain_ins_guid = itemb~value_chain_ins_guid
                                        AND itema~value_chain_item_guid = itemb~value_chain_item_guid
      LEFT OUTER JOIN vcm_rt_step_ins AS step ON itemb~step_ins_guid = step~guid
      INTO TABLE @lt_vcm_items
      WHERE itema~business_object_id = @lv_vbeln_scso
        AND itema~business_object = 'SALES_ORDER'
        AND itema~deleted = @space
        AND itema~cancelled = @space
        AND itemb~deleted = @space
        AND itemb~cancelled = @space
        AND step~step_type = 'DC_SO'.

    IF lt_vcm_items IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = 'No DCSO items found linked to the SCSO document.' ).
      RETURN.
    ENDIF.

    " Collect DCSO VBELNs
    DATA(lt_vbeln_dcso) = VALUE cl_ptf_util=>ty_vbeln_tab( ).
    LOOP AT lt_vcm_items ASSIGNING <ls_vcm_item>.
      APPEND <ls_vcm_item>-itemb-business_object_id TO lt_vbeln_dcso.
    ENDLOOP.
    DELETE ADJACENT DUPLICATES FROM lt_vbeln_dcso.

    CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
      TABLES
        it_vbak_key = lt_vbeln_dcso
        et_vbap     = lt_vbap_dcso.

    LOOP AT lt_vbap_dcso ASSIGNING <ls_vbap>.
      lv_vbeln = <ls_vbap>-vbeln.
      SHIFT lv_vbeln LEFT DELETING LEADING '0'.
      lv_posnr = <ls_vbap>-posnr.
      SHIFT lv_posnr LEFT DELETING LEADING '0'.

      me->mo_run_environment->append_log(
        iv_log_statement = |Checking { lv_prefix } { lv_vbeln }/{ lv_posnr } for empty transit plant| ).

      IF <ls_vbap>-transit_plant IS NOT INITIAL.
        lv_error_found = abap_true.
        me->mo_run_environment->append_log(
          iv_log_statement = |Unexpected transit plant { <ls_vbap>-transit_plant } found in { lv_prefix } { lv_vbeln }/{ lv_posnr }| ).
      ELSE.
        me->mo_run_environment->append_log(
          iv_log_statement = |Transit plant is correctly empty in { lv_prefix } { lv_vbeln }/{ lv_posnr }| ).
      ENDIF.
    ENDLOOP.

    IF lv_error_found = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = 'One or more DCSO items have an unexpected transit plant filled.' ).
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = 'All DCSO items have empty transit plant as expected.' ).
      ev_check_status     = abap_true.
      ev_execution_status = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD ml_vcm_chk_transit_plnt_icso. "mullapulli
* This method checks that the transit plant is filled correctly for IC_SO items using provided test data.

    DATA: lt_testdata    TYPE ty_t_or_check_ic_transit_plant,
          lt_vbeln_scso  TYPE cl_ptf_util=>ty_vbeln_tab,
          lt_sales_key   TYPE STANDARD TABLE OF sales_key,
          lt_vbap_icso   TYPE vbap_tab,
          lt_vcm_items   TYPE ty_vcm_item_tab,
          lv_vbeln_scso  TYPE vbeln_va,
          lv_error_found TYPE abap_bool,
          lv_statement   TYPE string,
          lv_vbeln       TYPE string,
          lv_posnr       TYPE string,
          lv_prefix      TYPE string VALUE 'ICSO'.

    FIELD-SYMBOLS: <ls_testdata> TYPE ty_s_or_check_ic_transit_plant,
                   <ls_vbap>     TYPE vbap,
                   <ls_vcm_item> TYPE ty_vcm_item,
                   <lv_ref_step> TYPE i.

    ev_check_status     = abap_false.
    ev_execution_status = abap_false.

    " Load test data
    cl_ptf_util=>get_testdata(
      EXPORTING is_step_data = is_step_data
      IMPORTING es_testdata  = lt_testdata ).

    LOOP AT lt_testdata ASSIGNING <ls_testdata>.
      me->mo_run_environment->append_log(
        iv_log_statement = |Parameter: Item { <ls_testdata>-posnr }, expected transit plant: { <ls_testdata>-transit_plant }| ).
    ENDLOOP.

    " Get SCSO document numbers from reference steps
    LOOP AT is_step_data-reference_step ASSIGNING <lv_ref_step>.
      DATA(lt_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_keys TO lt_vbeln_scso.
      APPEND LINES OF lt_keys TO lt_sales_key.
    ENDLOOP.

    READ TABLE lt_vbeln_scso INTO lv_vbeln_scso INDEX 1.
    IF lv_vbeln_scso IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = 'Error: No SCSO document found in reference step.' ).
      RETURN.
    ENDIF.

    " Use SCSO VBELN directly to get VCM entries for ICSO
    SELECT *
      FROM vcm_rt_bo_item AS itema
      INNER JOIN vcm_rt_bo_item AS itemb ON itema~value_chain_ins_guid = itemb~value_chain_ins_guid
                                        AND itema~value_chain_item_guid = itemb~value_chain_item_guid
      LEFT OUTER JOIN vcm_rt_step_ins AS step ON itemb~step_ins_guid = step~guid
      INTO TABLE @lt_vcm_items
      WHERE itema~business_object_id = @lv_vbeln_scso
        AND itema~business_object = 'SALES_ORDER'
        AND itema~deleted = @space
        AND itema~cancelled = @space
        AND itemb~deleted = @space
        AND itemb~cancelled = @space
        AND step~step_type = 'IC_SO'.

    IF lt_vcm_items IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = 'No ICSO items found linked to the SCSO document.' ).
      RETURN.
    ENDIF.

    " Collect ICSO VBELNs
    DATA(lt_vbeln_icso) = VALUE cl_ptf_util=>ty_vbeln_tab( ).
    LOOP AT lt_vcm_items ASSIGNING <ls_vcm_item>.
      APPEND <ls_vcm_item>-itemb-business_object_id TO lt_vbeln_icso.
    ENDLOOP.
    DELETE ADJACENT DUPLICATES FROM lt_vbeln_icso.

    CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
      TABLES
        it_vbak_key = lt_vbeln_icso
        et_vbap     = lt_vbap_icso.

    LOOP AT lt_vbap_icso ASSIGNING <ls_vbap>.
      lv_vbeln = <ls_vbap>-vbeln.
      SHIFT lv_vbeln LEFT DELETING LEADING '0'.
      lv_posnr = <ls_vbap>-posnr.
      SHIFT lv_posnr LEFT DELETING LEADING '0'.

      me->mo_run_environment->append_log(
        iv_log_statement = |Checking { lv_prefix } { lv_vbeln }/{ lv_posnr } for transit plant| ).

      READ TABLE lt_testdata ASSIGNING <ls_testdata> WITH KEY posnr = <ls_vbap>-posnr.
      IF sy-subrc = 0.
        IF <ls_vbap>-transit_plant IS INITIAL.
          lv_error_found = abap_true.
          me->mo_run_environment->append_log(
            iv_log_statement = |Missing transit plant in { lv_prefix } { lv_vbeln }/{ lv_posnr }| ).
        ELSEIF <ls_vbap>-transit_plant <> <ls_testdata>-transit_plant.
          lv_error_found = abap_true.
          me->mo_run_environment->append_log(
            iv_log_statement = |Mismatch: Expected transit plant { <ls_testdata>-transit_plant }, found { <ls_vbap>-transit_plant } for item { lv_posnr }| ).
        ELSE.
          me->mo_run_environment->append_log(
            iv_log_statement = |Transit plant { <ls_vbap>-transit_plant } is correct for { lv_prefix } { lv_vbeln }/{ lv_posnr }| ).
        ENDIF.
      ELSE.
        me->mo_run_environment->append_log(
          iv_log_statement = |No test data found for item { lv_vbeln }/{ lv_posnr }, skipping check.| ).
      ENDIF.
    ENDLOOP.

    IF lv_error_found = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = 'One or more ICSO items have incorrect or missing transit plant.' ).
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = 'All ICSO items have correct transit plants.' ).
      ev_check_status     = abap_true.
      ev_execution_status = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD ml_vcm_chk_transit_plnt_scso. "mullapulli
* This method checks that the transit plant is filled correctly for SCSO items only.

    DATA: lt_testdata    TYPE ty_t_or_check_ic_transit_plant,
          lt_vbeln       TYPE cl_ptf_util=>ty_vbeln_tab,
          lt_sales_key   TYPE STANDARD TABLE OF sales_key,
          lt_vbap_scso   TYPE vbap_tab,
          lv_error_found TYPE abap_bool,
          lv_statement   TYPE string,
          lv_vbeln       TYPE string,
          lv_posnr       TYPE string,
          lv_prefix      TYPE string VALUE 'SCSO'.

    FIELD-SYMBOLS: <lv_ref_step> TYPE i,
                   <ls_vbap>     TYPE vbap,
                   <ls_testdata> LIKE LINE OF lt_testdata.

    ev_check_status     = abap_false.
    ev_execution_status = abap_false.

    " Load test data
    cl_ptf_util=>get_testdata(
      EXPORTING is_step_data = is_step_data
      IMPORTING es_testdata  = lt_testdata ).

    LOOP AT lt_testdata ASSIGNING <ls_testdata>.
      me->mo_run_environment->append_log(
        iv_log_statement = |Parameter: Item { <ls_testdata>-posnr }, expected transit plant: { <ls_testdata>-transit_plant }| ).
    ENDLOOP.

    " Get SCSO documents from reference steps
    LOOP AT is_step_data-reference_step ASSIGNING <lv_ref_step>.
      DATA(lt_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_keys TO lt_vbeln.
      APPEND LINES OF lt_keys TO lt_sales_key.
    ENDLOOP.

    IF lt_vbeln IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = 'Error: No SCSO (SO2) document found in reference step.' ).
      RETURN.
    ENDIF.

    CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
      TABLES
        it_vbak_key = lt_sales_key
        et_vbap     = lt_vbap_scso.

    IF lt_vbap_scso IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = 'Error: No VBAP items found for SCSO.' ).
      RETURN.
    ENDIF.

    LOOP AT lt_vbap_scso ASSIGNING <ls_vbap>.
      lv_vbeln = <ls_vbap>-vbeln.
      SHIFT lv_vbeln LEFT DELETING LEADING '0'.
      lv_posnr = <ls_vbap>-posnr.
      SHIFT lv_posnr LEFT DELETING LEADING '0'.

      me->mo_run_environment->append_log(
        iv_log_statement = |Checking { lv_prefix } { lv_vbeln }/{ lv_posnr } for transit plant| ).

      READ TABLE lt_testdata ASSIGNING <ls_testdata> WITH KEY posnr = <ls_vbap>-posnr.
      IF sy-subrc = 0.
        IF <ls_vbap>-transit_plant IS INITIAL.
          lv_error_found = abap_true.
          me->mo_run_environment->append_log(
            iv_log_statement = |Missing transit plant in { lv_prefix } { lv_vbeln }/{ lv_posnr }| ).
        ELSEIF <ls_vbap>-transit_plant <> <ls_testdata>-transit_plant.
          lv_error_found = abap_true.
          me->mo_run_environment->append_log(
            iv_log_statement = |Mismatch: Expected transit plant { <ls_testdata>-transit_plant }, found { <ls_vbap>-transit_plant } for item { lv_posnr }| ).
        ELSE.
          me->mo_run_environment->append_log(
            iv_log_statement = |Transit plant { <ls_vbap>-transit_plant } is correct for { lv_prefix } { lv_vbeln }/{ lv_posnr }| ).
        ENDIF.
      ELSE.
        me->mo_run_environment->append_log(
          iv_log_statement = |No test data found for item { lv_vbeln }/{ lv_posnr }, skipping check.| ).
      ENDIF.
    ENDLOOP.

    IF lv_error_found = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = 'One or more SCSO items have incorrect or missing transit plant.' ).
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = 'All SCSO items have correct transit plants.' ).
      ev_check_status     = abap_true.
      ev_execution_status = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD ml_doc_chk_dcso_created. "mullapulli
* This method checks that at least one DCSO (Delivering Company Sales Order) was created
* and is registered in the VCM layer as a step of type 'DC_SO'.

    DATA: ls_testdata      TYPE ty_gs_ptf_or_check_ic_rpts_td,
          lt_vbeln_scso    TYPE cl_ptf_util=>ty_vbeln_tab,
          lt_sales_key     TYPE STANDARD TABLE OF sales_key,
          lt_vbap          TYPE vbap_tab,
          lt_scso_item_key TYPE if_vcm_value_chain_item_read=>tt_bo_item,
          ls_scso_item_key TYPE if_vcm_value_chain_item_read=>ty_bo_item,
          lv_found_dcso    TYPE abap_bool VALUE abap_false,
          lv_vbeln         TYPE vbeln_va,
          lv_statement     TYPE string,
          lv_prefix        TYPE string VALUE 'DCSO'.

    FIELD-SYMBOLS: <lv_vbeln> TYPE vbeln_va,
                   <ls_vbap>  TYPE vbap.

    ev_check_status     = abap_false.
    ev_execution_status = abap_false.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
      DATA(lt_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ls_ref_step> ).
      APPEND LINES OF lt_keys TO lt_vbeln_scso.
      APPEND LINES OF lt_keys TO lt_sales_key.
    ENDLOOP.

    DELETE ADJACENT DUPLICATES FROM lt_vbeln_scso.

    IF lt_vbeln_scso IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = 'No SCSO document found from reference step(s).' ).
      RETURN.
    ENDIF.

    CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
      TABLES
        it_vbak_key = lt_sales_key
        et_vbap     = lt_vbap.

    IF lt_vbap IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = 'No items found in SCSO documents.' ).
      RETURN.
    ENDIF.

    LOOP AT lt_vbap ASSIGNING <ls_vbap>.
      ls_scso_item_key-object_id         = <ls_vbap>-vbeln.
      ls_scso_item_key-item_id           = <ls_vbap>-posnr.
      ls_scso_item_key-chain_element_id  = <ls_vbap>-vcm_chain_element_id.
      ls_scso_item_key-step_type         = 'SC_SO'.
      APPEND ls_scso_item_key TO lt_scso_item_key.
    ENDLOOP.

    LOOP AT lt_vbeln_scso ASSIGNING FIELD-SYMBOL(<lv_vbeln_struct>).
      lv_vbeln = <lv_vbeln_struct>-vbeln.
      SELECT *
        FROM vcm_rt_bo_item AS itema
        INNER JOIN vcm_rt_bo_item AS itemb ON itema~value_chain_ins_guid = itemb~value_chain_ins_guid
                                          AND itema~value_chain_item_guid = itemb~value_chain_item_guid
        LEFT OUTER JOIN vcm_rt_step_ins AS step ON itemb~step_ins_guid = step~guid
        INTO TABLE @DATA(lt_vcm_check)
        WHERE itema~business_object_id = @lv_vbeln
          AND itema~business_object    = 'SALES_ORDER'
          AND itema~deleted            = @space
          AND itema~cancelled          = @space
          AND itemb~deleted            = @space
          AND itemb~cancelled          = @space
          AND step~step_type           = 'DC_SO'.

      IF lt_vcm_check IS INITIAL.
        me->mo_run_environment->append_log(
          iv_log_statement = |{ lv_prefix } step not found for SCSO { lv_vbeln } in VCM.| ).
      ELSE.
        lv_found_dcso = abap_true.
        LOOP AT lt_vcm_check ASSIGNING FIELD-SYMBOL(<ls_vcm>).
          lv_statement = |{ lv_prefix } created: OBJECT { <ls_vcm>-itemb-business_object_id }, ITEM { <ls_vcm>-itemb-business_object_item_id }|.
          me->mo_run_environment->append_log( iv_log_statement = lv_statement ).
        ENDLOOP.
      ENDIF.
    ENDLOOP.

    IF lv_found_dcso = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = 'DCSO creation verified in VCM.' ).
      ev_check_status     = abap_true.
      ev_execution_status = abap_true.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = 'No DCSO step found in VCM for any SCSO.' ).
    ENDIF.

  ENDMETHOD.


  METHOD ml_doc_chk_icso_created. "mullapulli
* This method checks that at least one ICSO (Intercompany Sales Order) was created
* and is registered in the VCM layer as a step of type 'IC_SO'.

    DATA: ls_testdata      TYPE ty_gs_ptf_or_check_ic_rpts_td,
          lt_vbeln_scso    TYPE cl_ptf_util=>ty_vbeln_tab,
          lt_sales_key     TYPE STANDARD TABLE OF sales_key,
          lt_vbap          TYPE vbap_tab,
          lt_scso_item_key TYPE if_vcm_value_chain_item_read=>tt_bo_item,
          ls_scso_item_key TYPE if_vcm_value_chain_item_read=>ty_bo_item,
          lv_found_icso    TYPE abap_bool VALUE abap_false,
          lv_vbeln         TYPE vbeln_va,
          lv_statement     TYPE string,
          lv_prefix        TYPE string VALUE 'ICSO'.

    FIELD-SYMBOLS: <lv_vbeln> TYPE vbeln_va,
                   <ls_vbap>  TYPE vbap.

    ev_check_status     = abap_false.
    ev_execution_status = abap_false.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
      DATA(lt_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ls_ref_step> ).
      APPEND LINES OF lt_keys TO lt_vbeln_scso.
      APPEND LINES OF lt_keys TO lt_sales_key.
    ENDLOOP.

    DELETE ADJACENT DUPLICATES FROM lt_vbeln_scso.

    IF lt_vbeln_scso IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = 'No SCSO document found from reference step(s).' ).
      RETURN.
    ENDIF.

    CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
      TABLES
        it_vbak_key = lt_sales_key
        et_vbap     = lt_vbap.

    IF lt_vbap IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = 'No items found in SCSO documents.' ).
      RETURN.
    ENDIF.

    LOOP AT lt_vbap ASSIGNING <ls_vbap>.
      ls_scso_item_key-object_id         = <ls_vbap>-vbeln.
      ls_scso_item_key-item_id           = <ls_vbap>-posnr.
      ls_scso_item_key-chain_element_id  = <ls_vbap>-vcm_chain_element_id.
      ls_scso_item_key-step_type         = 'SC_SO'.
      APPEND ls_scso_item_key TO lt_scso_item_key.
    ENDLOOP.

    LOOP AT lt_vbeln_scso ASSIGNING FIELD-SYMBOL(<lv_vbeln_struct>).
      lv_vbeln = <lv_vbeln_struct>-vbeln.
      SELECT *
        FROM vcm_rt_bo_item AS itema
        INNER JOIN vcm_rt_bo_item AS itemb ON itema~value_chain_ins_guid = itemb~value_chain_ins_guid
                                          AND itema~value_chain_item_guid = itemb~value_chain_item_guid
        LEFT OUTER JOIN vcm_rt_step_ins AS step ON itemb~step_ins_guid = step~guid
        INTO TABLE @DATA(lt_vcm_check)
        WHERE itema~business_object_id = @lv_vbeln
          AND itema~business_object    = 'SALES_ORDER'
          AND itema~deleted            = @space
          AND itema~cancelled          = @space
          AND itemb~deleted            = @space
          AND itemb~cancelled          = @space
          AND step~step_type           = 'IC_SO'.

      IF lt_vcm_check IS INITIAL.
        me->mo_run_environment->append_log(
          iv_log_statement = |{ lv_prefix } step not found for SCSO { lv_vbeln } in VCM.| ).
      ELSE.
        lv_found_icso = abap_true.
        LOOP AT lt_vcm_check ASSIGNING FIELD-SYMBOL(<ls_vcm>).
          lv_statement = |{ lv_prefix } created: OBJECT { <ls_vcm>-itemb-business_object_id }, ITEM { <ls_vcm>-itemb-business_object_item_id }|.
          me->mo_run_environment->append_log( iv_log_statement = lv_statement ).
        ENDLOOP.
      ENDIF.
    ENDLOOP.

    IF lv_found_icso = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = 'ICSO creation verified in VCM.' ).
      ev_check_status     = abap_true.
      ev_execution_status = abap_true.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = 'No ICSO step found in VCM for any SCSO.' ).
    ENDIF.

  ENDMETHOD.


  METHOD ml_doc_chk_scso_created. "mullapulli
* This method checks that at least one SCSO (Selling Company Sales Order) was created
* and also verifies that the SCSO is registered in the VCM layer (vcm_rt_bo_item).

    DATA: ls_testdata      TYPE ty_gs_ptf_or_check_ic_rpts_td,
          lt_vbeln_scso    TYPE cl_ptf_util=>ty_vbeln_tab,
          lt_sales_key     TYPE STANDARD TABLE OF sales_key,
          lt_vbap          TYPE vbap_tab,
          lt_scso_item_key TYPE if_vcm_value_chain_item_read=>tt_bo_item,
          ls_scso_item_key TYPE  if_vcm_value_chain_item_read=>ty_bo_item,
          lt_vcm_check     TYPE STANDARD TABLE OF vcm_rt_bo_item,
          lv_found_scso    TYPE abap_bool VALUE abap_false,
          lv_vbeln         TYPE vbeln_va,
          lv_statement     TYPE string,
          lv_prefix        TYPE string VALUE 'SCSO'.

    FIELD-SYMBOLS: <ls_vbap> TYPE vbap,
                   <ls_vcm>  TYPE vcm_rt_bo_item.

    ev_check_status     = abap_false.
    ev_execution_status = abap_false.

    " Load test data from container (optional use for future validations)
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

    " Collect SCSO VBELNs from reference steps
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_keys TO lt_vbeln_scso.
      APPEND LINES OF lt_keys TO lt_sales_key.
    ENDLOOP.

    DELETE ADJACENT DUPLICATES FROM lt_vbeln_scso.

    IF lt_vbeln_scso IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = 'No SCSO document found from reference step(s).' ).
      RETURN.
    ENDIF.

    " Read SCSO items from VBAP
    CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
      TABLES
        it_vbak_key = lt_sales_key
        et_vbap     = lt_vbap.

    IF lt_vbap IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = 'No items found in SCSO documents.' ).
      RETURN.
    ENDIF.

    LOOP AT lt_vbap ASSIGNING <ls_vbap>.
      ls_scso_item_key-object_id         = <ls_vbap>-vbeln.
      ls_scso_item_key-item_id           = <ls_vbap>-posnr.
      ls_scso_item_key-chain_element_id  = <ls_vbap>-vcm_chain_element_id.
      ls_scso_item_key-step_type         = 'SC_SO'.
      APPEND ls_scso_item_key TO lt_scso_item_key.
    ENDLOOP.

    LOOP AT lt_vbeln_scso ASSIGNING FIELD-SYMBOL(<lv_vbeln>).
      SELECT *
        FROM vcm_rt_bo_item
        INTO TABLE @lt_vcm_check
        WHERE business_object_id = @<lv_vbeln>-vbeln
          AND business_object    = 'SALES_ORDER'
          AND deleted            = @space
          AND cancelled          = @space.

      IF lt_vcm_check IS INITIAL.
        me->mo_run_environment->append_log(
          iv_log_statement = |{ lv_prefix } document { <lv_vbeln>-vbeln } is not known in VCM (vcm_rt_bo_item).| ).
      ELSE.
        lv_found_scso = abap_true.
        me->mo_run_environment->append_log(
          iv_log_statement = |{ lv_prefix } document { <lv_vbeln>-vbeln } is known in VCM.| ).
      ENDIF.
    ENDLOOP.

    IF lv_found_scso = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = 'SCSO document creation verified and registered in VCM.' ).
      ev_check_status     = abap_true.
      ev_execution_status = abap_true.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = 'No valid SCSO found in VCM.' ).
    ENDIF.

  ENDMETHOD.


  METHOD ml_doc_chk_all_so_created.
*This method is used to check the sales order documents are created for all the blocks
    DATA:
      ls_testdata        TYPE ty_gs_ptf_or_check_ic_rpts_td,
      lv_attempts_max    TYPE tb_attempts,  " maximumnumber of attempts
      lv_attempts_act    TYPE tb_attempts,  " actual attempts
      lv_waiting_time    TYPE s_mec_cputest_break_seconds,
      lv_idle_seconds    TYPE s_mec_cputest_break_seconds,  " Idle Seconds Before Start
      lv_max_repeats     TYPE /aif/repeat_counter,  " Maximum Number of Repeats
      lv_break_seconds   TYPE s_mec_cputest_break_seconds,  " Break Seconds Between Repeats
      lt_vbeln           TYPE cl_ptf_util=>ty_vbeln_tab,
      lv_vbeln           TYPE vbeln_va,
      lt_sales_key       TYPE TABLE OF sales_key,
      lt_scso_item_key   TYPE if_vcm_value_chain_item_read=>tt_bo_item,
      ls_scso_item_key   LIKE LINE OF lt_scso_item_key,
      lt_vbap            TYPE TABLE OF vbap,
      lv_mlic_relevant   TYPE boole_d,
      lv_mlic_item_found TYPE boole_d,
      lv_no_scso         TYPE boole_d,
      lv_number(5)       TYPE c,
      lv_statement       TYPE bapi_msg
      .
    FIELD-SYMBOLS:
      <ls_vbap> TYPE vbap
      .

* get variant parameters from the testdata container data
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).
    lv_idle_seconds = ls_testdata-idle_seconds.    "  Number of Idle Seconds Before Start
    lv_max_repeats   = ls_testdata-max_repeats.    " Maximum Number of Repeats
    lv_break_seconds = ls_testdata-break_seconds.  " Number of Seconds Between Repeats

    lv_attempts_max  = 1 + lv_max_repeats.         " Maximum Number of Attempts = (first try) + (repeats)

* write parameter values into log
    lv_statement = 'Parameter: Idle Seconds Before Start: &1'.
    lv_number = lv_idle_seconds.
    REPLACE '&1' IN lv_statement WITH lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

    lv_statement = 'Parameter: Maximum number of repeats: &1'.
    lv_number = lv_max_repeats.
    REPLACE '&1' IN lv_statement WITH lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

    lv_statement = 'Parameter: Number of seconds between repeats: &1'.
    lv_number = lv_break_seconds.
    REPLACE '&1' IN lv_statement WITH lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

* get SCSO
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
      APPEND LINES OF lt_ptf_keys TO lt_sales_key.
    ENDLOOP.
    CLEAR lv_vbeln.
    READ TABLE lt_vbeln INTO lv_vbeln INDEX 1.
    IF lv_vbeln IS INITIAL.
      lv_statement = 'Error: No SCSO order found.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      RETURN. " check fails
    ENDIF.


* Idle Seconds Before Start: wait for ml ico process to be finished
    WAIT UP TO lv_idle_seconds SECONDS.

    DATA(lo_sd_sls_ic_utility) = cl_sd_sls_ic_factory=>so_instance->get_instance_util( ).

    " get link to PO/SO
    CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
      TABLES
        it_vbak_key           = lt_sales_key
*       ET_VBAPVB             =
        et_vbap               = lt_vbap
      EXCEPTIONS
        records_not_found     = 1
        records_not_requested = 2
        OTHERS                = 3.
    IF sy-subrc <> 0.
      lv_statement = 'Error: No items found in SCSO order &1'.
      REPLACE '&1' IN lv_statement WITH lv_vbeln.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      RETURN. " check fails
    ENDIF.

    LOOP AT lt_vbap ASSIGNING <ls_vbap>.
      ls_scso_item_key-object_id = <ls_vbap>-vbeln.
      ls_scso_item_key-item_id   = <ls_vbap>-posnr.
      ls_scso_item_key-chain_element_id   = <ls_vbap>-vcm_chain_element_id.
      ls_scso_item_key-step_type = 'SC_SO'.
      APPEND ls_scso_item_key TO lt_scso_item_key.
    ENDLOOP.

    CLEAR lv_attempts_act.

    DO lv_attempts_max TIMES.
      ADD 1 TO lv_attempts_act.

      SELECT *
        FROM vcm_rt_bo_item AS itema
        INNER JOIN vcm_rt_bo_item AS itemb ON itema~value_chain_ins_guid = itemb~value_chain_ins_guid AND
                                              itema~value_chain_item_guid = itemb~value_chain_item_guid " [SG+]
        LEFT OUTER JOIN vcm_rt_step_ins AS step ON itemb~step_ins_guid = step~guid
        LEFT OUTER JOIN vcm_rt_chain_ins AS chain ON itemb~value_chain_ins_guid = chain~guid
        INTO TABLE @DATA(lt_vcm_item_sc_so)
        WHERE itema~business_object_id = @lv_vbeln
         AND itema~business_object = 'SALES_ORDER'
         AND itema~deleted   = @space                                                                   " [SG+]
         AND itema~cancelled = @space                                                                   " [SG+]
         AND itemb~deleted   = @space                                                                   " [SG+]
         AND itemb~cancelled = @space                                                                   " [SG+]
         AND step~step_type = 'SC_SO'
         AND ( chain~status = 'C' OR chain~status = 'E' OR chain~status = 'O' OR chain~status = 'PD' ).

      SELECT *
        FROM vcm_rt_bo_item AS itema
        INNER JOIN vcm_rt_bo_item AS itemb ON itema~value_chain_ins_guid = itemb~value_chain_ins_guid AND
                                              itema~value_chain_item_guid = itemb~value_chain_item_guid " [SG+]
        LEFT OUTER JOIN vcm_rt_step_ins AS step ON itemb~step_ins_guid = step~guid
        LEFT OUTER JOIN vcm_rt_chain_ins AS chain ON itemb~value_chain_ins_guid = chain~guid
        INTO TABLE @DATA(lt_vcm_item_dc_so)
        WHERE itema~business_object_id = @lv_vbeln
         AND itema~business_object = 'SALES_ORDER'
         AND itema~deleted   = @space                                                                   " [SG+]
         AND itema~cancelled = @space                                                                   " [SG+]
         AND itemb~deleted   = @space                                                                   " [SG+]
         AND itemb~cancelled = @space                                                                   " [SG+]
         AND step~step_type = 'DC_SO'
         AND ( chain~status = 'C' OR chain~status = 'E' OR chain~status = 'O' OR chain~status = 'PD' ).

      SELECT *
        FROM vcm_rt_bo_item AS itema
        INNER JOIN vcm_rt_bo_item AS itemb ON itema~value_chain_ins_guid = itemb~value_chain_ins_guid AND
                                              itema~value_chain_item_guid = itemb~value_chain_item_guid " [SG+]
        LEFT OUTER JOIN vcm_rt_step_ins AS step ON itemb~step_ins_guid = step~guid
        LEFT OUTER JOIN vcm_rt_chain_ins AS chain ON itemb~value_chain_ins_guid = chain~guid
        INTO TABLE @DATA(lt_vcm_item_ic_so)
        WHERE itema~business_object_id = @lv_vbeln
         AND itema~business_object = 'SALES_ORDER'
         AND itema~deleted   = @space                                                                   " [SG+]
         AND itema~cancelled = @space                                                                   " [SG+]
         AND itemb~deleted   = @space                                                                   " [SG+]
         AND itemb~cancelled = @space                                                                   " [SG+]
         AND ( step~step_type = 'IC_SO' )
         AND ( chain~status = 'C' OR chain~status = 'E' OR chain~status = 'O' OR chain~status = 'PD' ).

      SELECT *
        FROM vcm_rt_bo_item AS itema
        INNER JOIN vcm_rt_bo_item AS itemb
          ON itema~value_chain_ins_guid = itemb~value_chain_ins_guid
         AND itema~value_chain_item_guid = itemb~value_chain_item_guid
        LEFT OUTER JOIN vcm_rt_step_ins AS step
          ON itemb~step_ins_guid = step~guid
        LEFT OUTER JOIN vcm_rt_chain_ins AS chain
          ON itemb~value_chain_ins_guid = chain~guid
        INTO TABLE @DATA(lt_vcm_item_all_so)
        WHERE itema~business_object_id = @lv_vbeln
          AND itema~business_object = 'SALES_ORDER'
          AND itema~deleted   = @space
          AND itema~cancelled = @space
          AND itemb~deleted   = @space
          AND itemb~cancelled = @space
          AND step~step_type IN ('SC_SO', 'DC_SO', 'IC_SO' , 'IC_PO' , 'SC_PO')
          AND chain~status IN ('C', 'E', 'O', 'PD').

*DATA(lt_vcm_item_sc_so_new) = FILTER #( lt_vcm_item_all_so
*                                    WHERE step-step_type = CONV vcm_rt_step_ins-step_type( 'SC_SO' ) ).
*DATA(lt_vcm_item_dc_so_new) = FILTER #( lt_vcm_item_all_so USING KEY primary_key WHERE step-step_type = 'DC_SO' ).
*DATA(lt_vcm_item_ic_so_new) = FILTER #( lt_vcm_item_all_so USING KEY primary_key WHERE step-step_type = 'IC_SO' ).

      DATA: lv_found_scso TYPE abap_bool,
            lv_found_dcso TYPE abap_bool,
            lv_found_icso TYPE abap_bool.

      me->poll_for_vcm_item(
        EXPORTING
          iv_step_type     = 'SC_SO'
        CHANGING
          ct_vcm_item      = lt_vcm_item_sc_so
          cv_found         = lv_found_scso
          cv_waiting_time  = lv_waiting_time
          cv_attempts_act  = lv_attempts_act ).


      me->poll_for_vcm_item(
        EXPORTING
          iv_step_type     = 'DC_SO'
        CHANGING
          ct_vcm_item      = lt_vcm_item_dc_so
          cv_found         = lv_found_dcso
          cv_waiting_time  = lv_waiting_time
          cv_attempts_act  = lv_attempts_act ).

      me->poll_for_vcm_item(
        EXPORTING
          iv_step_type     = 'IC_SO'
        CHANGING
          ct_vcm_item      = lt_vcm_item_ic_so
          cv_found         = lv_found_icso
          cv_waiting_time  = lv_waiting_time
          cv_attempts_act  = lv_attempts_act ).

      " Check if all found → exit successfully
      IF lv_found_scso = abap_true AND lv_found_dcso = abap_true AND lv_found_icso = abap_true.
        EXIT.
      ENDIF.

    ENDDO.

    IF lv_found_scso = abap_false OR lv_found_dcso = abap_false OR lv_found_icso = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = 'Error: Missing one or more VCM order types (SC_SO / DC_SO / IC_SO).' ).
      RETURN.
    ENDIF.

    me->mo_run_environment->append_log( iv_log_statement = |All VCM items(atleast one IC_SO) found in { lv_attempts_act } attempts. Total wait time: { lv_waiting_time } seconds.| ).


    IF lv_found_scso EQ abap_true.
* write the created SCSO into the output log
      LOOP AT lt_vcm_item_sc_so ASSIGNING FIELD-SYMBOL(<ls_vcm_item_sc_so>).
        lv_statement = 'SCSO order: OBJECT &1 , ITEM &2'.
        REPLACE '&1' IN lv_statement WITH <ls_vcm_item_sc_so>-itemb-business_object_id.
        REPLACE '&2' IN lv_statement WITH <ls_vcm_item_sc_so>-itemb-business_object_item_id.
        me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      ENDLOOP.
    ELSEIF lv_found_scso    EQ abap_false.
      lv_statement = 'Error: No SCSO( Selling Company Order was found'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      RETURN.
    ENDIF.

    IF lv_found_icso EQ abap_true.
* write the created ICSO into the output log
      LOOP AT lt_vcm_item_ic_so ASSIGNING FIELD-SYMBOL(<ls_vcm_item_ic_so>).
        lv_statement = 'ICSO order: OBJECT &1 , ITEM &2'.
        REPLACE '&1' IN lv_statement WITH <ls_vcm_item_ic_so>-itemb-business_object_id.
        REPLACE '&2' IN lv_statement WITH <ls_vcm_item_ic_so>-itemb-business_object_item_id.
        me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      ENDLOOP.
    ELSEIF lv_found_icso EQ abap_false.
      lv_statement = 'Error: No ICSO( Inter Company Order was found'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ENDIF.

    IF lv_found_dcso EQ abap_true.
* write the created DCSO into the output log
      LOOP AT lt_vcm_item_dc_so ASSIGNING FIELD-SYMBOL(<ls_vcm_item_dc_so>).
        lv_statement = 'DCSO order: OBJECT &1 , ITEM &2'.
        REPLACE '&1' IN lv_statement WITH <ls_vcm_item_dc_so>-itemb-business_object_id.
        REPLACE '&2' IN lv_statement WITH <ls_vcm_item_dc_so>-itemb-business_object_item_id.
        me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      ENDLOOP.
    ELSEIF lv_found_dcso    EQ abap_false.
      lv_statement = 'Error: No DCSO( Delivering Company Order was found'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    ENDIF.


* we assume that at least 1 SCSO item must be MLIC-relevant
* for each IC-relevant item in SCSO, a corresponding link to ICSO/DCSO must exist!
    DATA: lv_string TYPE  fch_financial_chain_id.
    DATA: lt_expected_steps TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA: lv_num_blocks TYPE i.
    DATA: lv_num_ic_so TYPE i.
    DATA: lv_vbeln_conv TYPE vcm_business_object_id,
          lv_posnr_conv TYPE vcm_business_object_item_id.
    DATA: lt_missing_steps TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    FIELD-SYMBOLS:
      <ls_vcm_item>  TYPE ty_vcm_item,
      <lv_step_type> TYPE vcm_step_type_id.

    LOOP AT lt_vbap   ASSIGNING <ls_vbap>.

      lv_vbeln_conv = CONV vcm_business_object_id( <ls_vbap>-vbeln ).
      lv_posnr_conv = CONV vcm_business_object_item_id( <ls_vbap>-posnr ).

      " 1. Get chain blocks for this item
      lv_string = <ls_vbap>-vcm_chain_element_id.
      DATA(lt_chain_elements) = lo_sd_sls_ic_utility->determine_fin_chain_elements(
        EXPORTING
          iv_chain_id       = lv_string ).
      lv_num_blocks = lines( lt_chain_elements ).

      "#TODO: Can be a input parameter the expected number of blocks/documents
      " 2. Build expected steps
      " Always expect SC_PO and DC_SO
      lt_expected_steps = VALUE string_table(
        ( CONV string( 'SC_PO' ) )
        ( CONV string( 'DC_SO' ) )
        ( CONV string( 'SC_SO' ) )
      ).
      " Add IC_SO , IC_PO dynamically based on number of blocks
      lv_num_ic_so = lv_num_blocks - 2.
      DO lv_num_ic_so TIMES.
        APPEND CONV string( 'IC_SO' ) TO lt_expected_steps.
        APPEND CONV string( 'IC_PO' ) TO lt_expected_steps.
      ENDDO.


      " 3. Check existence and count
      LOOP AT lt_expected_steps ASSIGNING FIELD-SYMBOL(<lv_expected_step>).

        DATA(lv_actual_count) = 0.

        LOOP AT lt_vcm_item_all_so ASSIGNING <ls_vcm_item>
              WHERE itema-business_object_id      = lv_vbeln_conv
                AND itema-business_object_item_id = lv_posnr_conv
                AND step-step_type                = <lv_expected_step>.

          ADD 1 TO lv_actual_count.
        ENDLOOP.

        " Count how many times this step is expected
        DATA(lv_expected_count) = 0.

        LOOP AT lt_expected_steps ASSIGNING FIELD-SYMBOL(<lv_temp_step>).
          IF <lv_temp_step> = <lv_expected_step>.
            ADD 1 TO lv_expected_count.
          ENDIF.
        ENDLOOP.
        IF lv_actual_count < lv_expected_count.
          APPEND |{ lv_vbeln_conv }/{ lv_posnr_conv } - Step { <lv_step_type> }: Expected { lv_expected_count }, Found { lv_actual_count }|
            TO lt_missing_steps.
        ENDIF.

      ENDLOOP.
    ENDLOOP.
    " Step 4: Final reporting
    IF lt_missing_steps IS NOT INITIAL.
      LOOP AT lt_missing_steps ASSIGNING FIELD-SYMBOL(<lv_log>).
        me->mo_run_environment->append_log( iv_log_statement = <lv_log> ).
      ENDLOOP.
      RETURN.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = 'All expected VCM steps found for all items.' ).
    ENDIF.

  ENDMETHOD.


  METHOD poll_for_vcm_item.

    DATA: lv_attempts  TYPE i VALUE 0,
          lv_no_valid  TYPE abap_bool,
          lv_attempted TYPE abap_bool.

    FIELD-SYMBOLS: <ls_item> TYPE ty_vcm_item.

    DO iv_max_attempts TIMES.
      ADD 1 TO lv_attempts.
      lv_no_valid = abap_false.

      IF ct_vcm_item IS INITIAL.
        ADD iv_break_seconds TO cv_waiting_time.
        WAIT UP TO iv_break_seconds SECONDS.
      ELSE.
        LOOP AT ct_vcm_item ASSIGNING <ls_item>.
          IF <ls_item>-itemb IS INITIAL.
            lv_no_valid = abap_true.
            EXIT.
          ENDIF.
        ENDLOOP.

        IF lv_no_valid = abap_true.
          ADD iv_break_seconds TO cv_waiting_time.
          WAIT UP TO iv_break_seconds SECONDS.
        ELSE.
          cv_found = abap_true.
          EXIT.
        ENDIF.
      ENDIF.
    ENDDO.

    cv_attempts_act = lv_attempts.

  ENDMETHOD.


  METHOD ml_ico_to_be_deleted.
**************ML VCM-Related Checks*************
    "ml_vcm_chk_cat_micl_icsl - done

    "ml_vcm_chk_fin_chain_id - to implement

    "ml_vcm_chk_transit_plant_scso

    "ml_vcm_chk_transit_plant_icso

    "ml_vcm_chk_no_trnst_plnt_dcso

************Document Creation Checks*************

    "ml_doc_chk_scso_created

    "ml_doc_chk_dcso_created

    "ml_doc_chk_icso_created

    "ml_doc_chk_all_so_created - done

  ENDMETHOD.


  method ml_doc_gm_check_outdelivery.
*This method is used to check the sales order documents are created for all the blocks
    data:
      ls_testdata        type ty_gs_ptf_or_check_ic_rpts_td,
      lv_attempts_max    type tb_attempts,  " maximumnumber of attempts
      lv_attempts_act    type tb_attempts,  " actual attempts
      lv_waiting_time    type s_mec_cputest_break_seconds,
      lv_idle_seconds    type s_mec_cputest_break_seconds,  " Idle Seconds Before Start
      lv_max_repeats     type /aif/repeat_counter,  " Maximum Number of Repeats
      lv_break_seconds   type s_mec_cputest_break_seconds,  " Break Seconds Between Repeats
      lt_vbeln           type cl_ptf_util=>ty_vbeln_tab,
      lv_vbeln           type vbeln_va,
      lv_ettyp           type ettyp,
      lt_sales_key       type table of sales_key,
      lt_vbep            type table of vbep,
      lv_number(5)       type c,
      lv_statement       type bapi_msg.
    field-symbols: <ls_vbap> type vbap.

* get variant parameters from the testdata container data
    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = step_data
      importing
        es_testdata  = ls_testdata
    ).
    lv_idle_seconds = ls_testdata-idle_seconds.    "  Number of Idle Seconds Before Start
    lv_max_repeats   = ls_testdata-max_repeats.    " Maximum Number of Repeats
    lv_break_seconds = ls_testdata-break_seconds.  " Number of Seconds Between Repeats

    lv_attempts_max  = 1 + lv_max_repeats.         " Maximum Number of Attempts = (first try) + (repeats)

* write parameter values into log
    lv_statement = 'Parameter: Idle Seconds Before Start: &1'.
    lv_number = lv_idle_seconds.
    add 25 to lv_idle_seconds.
    replace '&1' in lv_statement with lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

    lv_statement = 'Parameter: Maximum number of repeats: &1'.
    lv_number = lv_max_repeats.
    replace '&1' in lv_statement with lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

    lv_statement = 'Parameter: Number of seconds between repeats: &1'.
    lv_number = lv_break_seconds.
    replace '&1' in lv_statement with lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

* get SCSO
    loop at step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_vbeln.
      append lines of lt_ptf_keys to lt_sales_key.
    endloop.
    clear lv_vbeln.
    read table lt_vbeln into lv_vbeln index 1.
    if lv_vbeln is initial.
      lv_statement = 'Error: No SCSO order found.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      return. " check fails
    endif.


* Idle Seconds Before Start: wait for ml ico process to be finished
    wait up to lv_idle_seconds seconds.

    data(lo_sd_sls_ic_utility) = cl_sd_sls_ic_factory=>so_instance->get_instance_util( ).

    " get link to PO/SO
    call function 'SD_VBEP_ARRAY_READ_VBELN'
      tables
        it_vbak_key           = lt_sales_key
        et_vbep               = lt_vbep
      exceptions
        records_not_found     = 1
        records_not_requested = 2
        others                = 3.
    if sy-subrc <> 0.
      lv_statement = 'Error: No items found in SCSO order &1'.
      replace '&1' in lv_statement with lv_vbeln.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      return. " check fails
    endif.

    check not lt_vbep[] is initial.
    lv_ettyp = lt_vbep[ 1 ]-ettyp.

    check lv_ettyp is not initial.
    select * from sdsls_gmtyp_det into table @data(lt_gmtyp) where ettyp = @lv_ettyp and value_chain_type = 'MS_IC_SALES'.

    clear lv_attempts_act.

    do lv_attempts_max times.
      add 1 to lv_attempts_act.
      select *
     from vcm_rt_bo_item as itema
     inner join vcm_rt_bo_item as itemb
       on itema~value_chain_ins_guid = itemb~value_chain_ins_guid
      and itema~value_chain_item_guid = itemb~value_chain_item_guid
     left outer join vcm_rt_step_ins as step
       on itemb~step_ins_guid = step~guid
     left outer join vcm_rt_chain_ins as chain
       on itemb~value_chain_ins_guid = chain~guid
     into table @data(lt_vcm_item_all)
     where itema~business_object_id = @lv_vbeln
       and itema~business_object = 'SALES_ORDER'
       and itema~deleted   = @space
       and itema~cancelled = @space
       and itemb~deleted   = @space
       and itemb~cancelled = @space
       and step~step_type in ('SC_GR', 'DC_GT', 'IC_GR' , 'DC_GI' , 'SC_GI' , 'IC_GI' )
       and chain~status in ('C', 'E', 'O', 'PD').

    enddo.


    if lt_vcm_item_all[] is not initial.
      data : lt_md_key   type wb2_material_key_stab,
             l_md_key    type wb2_material_key,
             lt_wb2_mseg type wb2_mseg_stab.

      loop at lt_vcm_item_all assigning field-symbol(<ls_item>).
        move: <ls_item>-itemb-business_object_id+0(10) to l_md_key-mblnr,
             <ls_item>-itemb-business_object_id+10(4) to l_md_key-mjahr.
        insert l_md_key into table lt_md_key.
      endloop.

      if lt_md_key[] is not initial .
        call function 'WB2_MSEG_ARRAY_READ'
          exporting
            it_key  = lt_md_key
          importing
            et_data = lt_wb2_mseg.
        if sy-subrc <> 0.
          lv_statement = 'Error: No items found in  order &1'.
          replace '&1' in lv_statement with lv_vbeln.
          me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
          return. " check fails
        endif.
      endif.
    endif.

* write the step  into the output log
    if lt_vcm_item_all[] is not initial.
      loop at lt_gmtyp assigning field-symbol(<ls_gm>).
        read table lt_vcm_item_all assigning field-symbol(<ls_vcm_item>) with key step-step_type = <ls_gm>-value_chain_step.
        check <ls_vcm_item> is not initial.
        read table lt_wb2_mseg assigning field-symbol(<l_mseg>) with key mblnr = <ls_vcm_item>-itemb-business_object_id+0(10)
                                                                         mjahr = <ls_vcm_item>-itemb-business_object_id+10(4).

        if <ls_gm>-bwart eq <l_mseg>-bwart.
          lv_statement = '&1 Document: OBJECT &2 determined with correct movement type &3'.
          replace '&1' in lv_statement with <ls_gm>-value_chain_step.
          replace '&2' in lv_statement with <ls_vcm_item>-itemb-business_object_id+0(10).
          replace '&3' in lv_statement with <ls_gm>-bwart.
          me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
          data(lv_status) = abap_true.
        else.
          lv_statement = 'Error: Determination of Goods Movement is incorrect'.
          me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
          return.
        endif.
      endloop.

      if lv_status eq abap_true.
        ev_check_status = abap_true.
        ev_execution_status = abap_true.
        loop at lt_vcm_item_all assigning field-symbol(<ls_item_link>).
          data(n) =  sy-tabix.
          if line_exists( lt_vcm_item_all[ n ] ).
            append lt_vcm_item_all[ n ]-itemb-business_object_id+0(10) to ev_document_id.
          endif.
        endloop.
      else.
        me->mo_run_environment->append_log( iv_log_statement = 'Error: No item found' ).
      endif.
      delete adjacent duplicates from ev_document_id.
    endif.
  endmethod.


  method CHECK_ML_OBD.

    DATA:lt_deliveries TYPE TABLE OF vbeln_vl.

      " Get test parameters
  data(ls_testdata) = value ty_gs_ptf_or_check_ic_rpts_td( ).
  cl_ptf_util=>get_testdata(
    exporting is_step_data = step_data
    importing es_testdata  = ls_testdata ).
   " Initialize parameters
  data(lv_idle_seconds) = ls_testdata-idle_seconds + 15. " Buffer
  data(lv_max_repeats) = ls_testdata-max_repeats.
  data(lv_break_seconds) = ls_testdata-break_seconds.
  data(lv_attempts_max) = 1 + lv_max_repeats.

  " Log parameters
  me->mo_run_environment->append_log( |Parameter: Idle Seconds Before Start: { lv_idle_seconds }| ).
  me->mo_run_environment->append_log( |Parameter: Maximum repeats: { lv_max_repeats }| ).
  me->mo_run_environment->append_log( |Parameter: Seconds between repeats: { lv_break_seconds }| ).
   " Get Deliveries from reference steps
  data(lt_vbeln) = value cl_ptf_util=>ty_vbeln_tab(
    for <lv_ref_step> in step_data-reference_step
    ( lines of me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ) ) ).

  if lt_vbeln is initial.
    me->mo_run_environment->append_log( 'Error: No OBD found.' ).
    return.
  endif.

lt_deliveries = lt_vbeln.

    " 2. Select relevant LIPS data
  SELECT vbeln,
         posnr ,
         matnr ,
         lfimg ,
         vrkme
    INTO TABLE @DATA(lt_lips)
    FROM lips
    FOR ALL ENTRIES IN @lt_deliveries
    WHERE vbeln = @lt_deliveries-table_line.

    LOOP AT lt_lips INTO DATA(ls_lips).
      case ls_testdata-vcm_business_object.
        when 'BMENG'.
      me->mo_run_environment->append_log( |Delivery: { ls_lips-vbeln } - Item: { ls_lips-posnr } - Material: { ls_lips-matnr } - Qty: { ls_lips-lfimg } { ls_lips-vrkme }| ).
      clear ls_lips.
      ev_check_status = abap_true.
    ev_execution_status = abap_true.
      ENDCASE.
      ENDLOOP.

  endmethod.


  METHOD check_ml_vcm_dc_so_batch_id.
*     this methods is used to check whether the BATCH is Passed Successfully from SC_PO to IC_SO
* Will take Test data from test data container
    DATA lt_testdata        TYPE ty_t_or_check_ml_batch.
    DATA lv_error_occurred  TYPE abap_bool.
    DATA lv_ebeln TYPE ebeln.

    TYPES:
      BEGIN OF ty_so_numbers,
        vbeln TYPE vbeln,
        posnr TYPE posnr,
      END OF ty_so_numbers.
    DATA: lt_so_numbers TYPE STANDARD TABLE OF ty_so_numbers.

    FIELD-SYMBOLS <ls_sales_key> TYPE sales_key.
    FIELD-SYMBOLS <ls_testdata>  TYPE ty_s_or_check_ml_batch.


    ev_check_status       = abap_false.
    ev_execution_status   = abap_false.

    " get variant parameters from the testdata container data
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = is_step_data
      IMPORTING
        es_testdata  = lt_testdata
    ).

    " write parameter values into log
    LOOP AT lt_testdata ASSIGNING <ls_testdata>.
      me->mo_run_environment->append_log( iv_log_statement = |Parameter: Item { <ls_testdata>-posnr }, expected Batch ID: { <ls_testdata>-charg } | ).
    ENDLOOP.

    LOOP AT is_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_vbeln) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
    ENDLOOP.

    READ TABLE lt_vbeln ASSIGNING FIELD-SYMBOL(<ls_vbeln>) INDEX 1.
    IF <ls_vbeln> IS NOT ASSIGNED.
      me->mo_run_environment->append_log( iv_log_statement = |Error: IC_SO(3) not found in reference step| ).
      RETURN.
    ENDIF.

    DATA(lv_vbeln) = <ls_vbeln>-vbeln.
    APPEND VALUE #(   vbeln = <ls_vbeln>-vbeln
                      posnr = '00010' ) TO lt_so_numbers.

    IF lt_so_numbers IS NOT INITIAL.
      SELECT vbeln, posnr,charg
         FROM vbap
         INTO TABLE @DATA(lt_vbap)
         FOR ALL ENTRIES IN @lt_so_numbers
         WHERE vbeln = @lt_so_numbers-vbeln
           AND posnr = @lt_so_numbers-posnr.
    ENDIF.

    IF lt_vbap IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Error: IC_SO not found in reference step| ).
    ENDIF.

    LOOP AT lt_vbap ASSIGNING FIELD-SYMBOL(<ls_vbap>).

      IF <ls_vbap>-charg <> <ls_testdata>-charg.
        lv_error_occurred = abap_true.
        me->mo_run_environment->append_log( iv_log_statement = |Error: Batch is Wrongly Determined in PO. Expected: { <ls_testdata>-charg }, actual: | &&
                                                               |{ <ls_vbap>-charg } | ).
      ENDIF.
    ENDLOOP.

    IF lv_error_occurred = abap_true.
      " at least one item has an error
      me->mo_run_environment->append_log( iv_log_statement = |Error occurred. Details see in log above| ).

    ELSE.
      " success
      me->mo_run_environment->append_log( iv_log_statement = |Success: Batch Determined is as expected for all items| ).
      ev_check_status = abap_true.
      ev_execution_status = abap_true.
    ENDIF.
  ENDMETHOD.


  method CHECK_ML_VCM_IC_PO_BATCH_ID.

* this methods is used to check whether the BATCH is Passed Successfully from IC_SO to IC_PO
* Will take Test data from test data container
    DATA lt_testdata        TYPE ty_t_or_check_ml_batch.
    DATA lv_error_occurred  TYPE abap_bool.
    DATA lv_ebeln TYPE ebeln.

    TYPES:
      BEGIN OF ty_po_numbers,
        ebeln TYPE ebeln,
        ebelp TYPE ebelp,
      END OF ty_po_numbers.
    DATA: lt_po_numbers TYPE STANDARD TABLE OF ty_po_numbers.

    FIELD-SYMBOLS <ls_sales_key> TYPE sales_key.
    FIELD-SYMBOLS <ls_vbap>      TYPE vbap.
    FIELD-SYMBOLS <ls_testdata>  TYPE ty_s_or_check_ml_batch.


    ev_check_status       = abap_false.
    ev_execution_status   = abap_false.

    " get variant parameters from the testdata container data
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = is_step_data
      IMPORTING
        es_testdata  = lt_testdata
    ).

    " write parameter values into log
    LOOP AT lt_testdata ASSIGNING <ls_testdata>.
      me->mo_run_environment->append_log( iv_log_statement = |Parameter: Item { <ls_testdata>-posnr }, expected Batch ID: { <ls_testdata>-charg } | ).
    ENDLOOP.

    LOOP AT is_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ebeln) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
    ENDLOOP.

    READ TABLE lt_ebeln ASSIGNING FIELD-SYMBOL(<ls_ebeln>) INDEX 1.
    IF <ls_ebeln> IS NOT ASSIGNED.
      me->mo_run_environment->append_log( iv_log_statement = |Error: IC_PO not found in reference step| ).
      RETURN.
    ENDIF.

    lv_ebeln = <ls_ebeln>-vbeln.
    APPEND VALUE #(   ebeln = <ls_ebeln>-vbeln
                      ebelp = '00010' ) TO lt_po_numbers.

    IF lt_po_numbers IS NOT INITIAL.
      SELECT eket~ebeln, eket~ebelp, eket~charg
         FROM eket
         INTO TABLE @DATA(lt_eket)
         FOR ALL ENTRIES IN @lt_po_numbers
         WHERE eket~ebeln = @lt_po_numbers-ebeln
               AND eket~ebelp = @lt_po_numbers-ebelp.
    ENDIF.

    IF lt_eket IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Error: IC_PO not found in reference step| ).
    ENDIF.

    LOOP AT lt_eket ASSIGNING FIELD-SYMBOL(<ls_eket>).

      IF <ls_eket>-charg <> <ls_testdata>-charg.
        lv_error_occurred = abap_true.
        me->mo_run_environment->append_log( iv_log_statement = |Error: Batch is Wrongly Determined in PO. Expected: { <ls_testdata>-charg }, actual: | &&
                                                               |{ <ls_eket>-charg } | ).
      ENDIF.
    ENDLOOP.

    IF lv_error_occurred = abap_true.
      " at least one item has an error
      me->mo_run_environment->append_log( iv_log_statement = |Error occurred. Details see in log above| ).

    ELSE.
      " success
      me->mo_run_environment->append_log( iv_log_statement = |Success: Batch Determined is as expected for all items| ).
      ev_check_status = abap_true.
      ev_execution_status = abap_true.
    ENDIF.
  endmethod.


  METHOD CHECK_ML_VCM_IC_SO_BATCH_ID.

* this methods is used to check whether the BATCH is Passed Successfully from SC_PO to IC_SO
* Will take Test data from test data container
    DATA lt_testdata        TYPE ty_t_or_check_ml_batch.
    DATA lv_error_occurred  TYPE abap_bool.
    DATA lv_ebeln TYPE ebeln.

    TYPES:
      BEGIN OF ty_so_numbers,
        vbeln TYPE vbeln,
        posnr TYPE posnr,
      END OF ty_so_numbers.
    DATA: lt_so_numbers TYPE STANDARD TABLE OF ty_so_numbers.

    FIELD-SYMBOLS <ls_sales_key> TYPE sales_key.
    FIELD-SYMBOLS <ls_testdata>  TYPE ty_s_or_check_ml_batch.


    ev_check_status       = abap_false.
    ev_execution_status   = abap_false.

    " get variant parameters from the testdata container data
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = is_step_data
      IMPORTING
        es_testdata  = lt_testdata
    ).

    " write parameter values into log
    LOOP AT lt_testdata ASSIGNING <ls_testdata>.
      me->mo_run_environment->append_log( iv_log_statement = |Parameter: Item { <ls_testdata>-posnr }, expected Batch ID: { <ls_testdata>-charg } | ).
    ENDLOOP.

    LOOP AT is_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_vbeln) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
    ENDLOOP.

    READ TABLE lt_vbeln ASSIGNING FIELD-SYMBOL(<ls_vbeln>) INDEX 1.
    IF <ls_vbeln> IS NOT ASSIGNED.
      me->mo_run_environment->append_log( iv_log_statement = |Error: IC_SO(3) not found in reference step| ).
      RETURN.
    ENDIF.

    DATA(lv_vbeln) = <ls_vbeln>-vbeln.
    APPEND VALUE #(   vbeln = <ls_vbeln>-vbeln
                      posnr = '00010' ) TO lt_so_numbers.

    IF lt_so_numbers IS NOT INITIAL.
     select vbeln, posnr,charg
        from vbap
        into table @data(lt_vbap)
        for all entries in @lt_so_numbers
        where vbeln = @lt_so_numbers-vbeln
          and posnr = @lt_so_numbers-posnr.
    ENDIF.

    IF lt_vbap IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Error: IC_SO not found in reference step| ).
    ENDIF.

    LOOP AT lt_vbap ASSIGNING FIELD-SYMBOL(<ls_vbap>).

      IF <ls_vbap>-charg <> <ls_testdata>-charg.
        lv_error_occurred = abap_true.
        me->mo_run_environment->append_log( iv_log_statement = |Error: Batch is Wrongly Determined in PO. Expected: { <ls_testdata>-charg }, actual: | &&
                                                               |{ <ls_vbap>-charg } | ).
      ENDIF.
    ENDLOOP.

    IF lv_error_occurred = abap_true.
      " at least one item has an error
      me->mo_run_environment->append_log( iv_log_statement = |Error occurred. Details see in log above| ).

    ELSE.
      " success
      me->mo_run_environment->append_log( iv_log_statement = |Success: Batch Determined is as expected for all items| ).
      ev_check_status = abap_true.
      ev_execution_status = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD CHECK_ML_VCM_SC_PO_BATCH_ID.

* this methods is used to check whether the BATCH is Passed Successfully from SC_SO to SC_PO
* Will take Test data from test data container
    DATA lt_testdata        TYPE ty_t_or_check_ml_batch.
    DATA lv_error_occurred  TYPE abap_bool.
    DATA lv_ebeln TYPE ebeln.

    TYPES:
      BEGIN OF ty_po_numbers,
        ebeln TYPE ebeln,
        ebelp TYPE ebelp,
      END OF ty_po_numbers.
    DATA: lt_po_numbers TYPE STANDARD TABLE OF ty_po_numbers.

    FIELD-SYMBOLS <ls_sales_key> TYPE sales_key.
    FIELD-SYMBOLS <ls_vbap>      TYPE vbap.
    FIELD-SYMBOLS <ls_testdata>  TYPE ty_s_or_check_ml_batch.


    ev_check_status       = abap_false.
    ev_execution_status   = abap_false.

    " get variant parameters from the testdata container data
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = is_step_data
      IMPORTING
        es_testdata  = lt_testdata
    ).

    " write parameter values into log
    LOOP AT lt_testdata ASSIGNING <ls_testdata>.
      me->mo_run_environment->append_log( iv_log_statement = |Parameter: Item { <ls_testdata>-posnr }, expected Batch ID: { <ls_testdata>-charg } | ).
    ENDLOOP.

    LOOP AT is_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ebeln) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
    ENDLOOP.

    READ TABLE lt_ebeln ASSIGNING FIELD-SYMBOL(<ls_ebeln>) INDEX 1.
    IF <ls_ebeln> IS NOT ASSIGNED.
      me->mo_run_environment->append_log( iv_log_statement = |Error: PO(3) not found in reference step| ).
      RETURN.
    ENDIF.

    lv_ebeln = <ls_ebeln>-vbeln.
    APPEND VALUE #(   ebeln = <ls_ebeln>-vbeln
                      ebelp = '00010' ) TO lt_po_numbers.

    IF lt_po_numbers IS NOT INITIAL.
      SELECT eket~ebeln, eket~ebelp, eket~charg
         FROM eket
         INTO TABLE @DATA(lt_eket)
         FOR ALL ENTRIES IN @lt_po_numbers
         WHERE eket~ebeln = @lt_po_numbers-ebeln
               AND eket~ebelp = @lt_po_numbers-ebelp.
    ENDIF.

    IF lt_eket IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Error: PO(3) not found in reference step| ).
    ENDIF.

    LOOP AT lt_eket ASSIGNING FIELD-SYMBOL(<ls_eket>).

      IF <ls_eket>-charg <> <ls_testdata>-charg.
        lv_error_occurred = abap_true.
        me->mo_run_environment->append_log( iv_log_statement = |Error: Batch is Wrongly Determined in PO. Expected: { <ls_testdata>-charg }, actual: | &&
                                                               |{ <ls_eket>-charg } | ).
      ENDIF.
    ENDLOOP.

    IF lv_error_occurred = abap_true.
      " at least one item has an error
      me->mo_run_environment->append_log( iv_log_statement = |Error occurred. Details see in log above| ).

    ELSE.
      " success
      me->mo_run_environment->append_log( iv_log_statement = |Success: Batch Determined is as expected for all items| ).
      ev_check_status = abap_true.
      ev_execution_status = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD clear_transit_plant.
    DATA:
      lt_vbeln     TYPE cl_ptf_util=>ty_vbeln_tab,
      lt_sales_key TYPE STANDARD TABLE OF sales_key,
      lt_vbap_scso TYPE vbap_tab,
      lv_vbeln     TYPE string,
      lv_posnr     TYPE string,
      lv_prefix    TYPE string VALUE 'SCSO'.

    " Get SCSO documents from reference steps
    LOOP AT is_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_keys TO lt_vbeln.
      APPEND LINES OF lt_keys TO lt_sales_key.
    ENDLOOP.

    IF lt_vbeln IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = 'Error: No SCSO (SO2) document found in reference step.' ).
      RETURN.
    ENDIF.

    CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
      TABLES
        it_vbak_key = lt_sales_key
        et_vbap     = lt_vbap_scso.

    IF lt_vbap_scso IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = 'Error: No VBAP items found for SCSO.' ).
      RETURN.
    ENDIF.

    LOOP AT lt_vbap_scso ASSIGNING FIELD-SYMBOL(<ls_vbap>).
      lv_vbeln = <ls_vbap>-vbeln.
      SHIFT lv_vbeln LEFT DELETING LEADING '0'.
      lv_posnr = <ls_vbap>-posnr.
      SHIFT lv_posnr LEFT DELETING LEADING '0'.

      me->mo_run_environment->append_log(
        iv_log_statement = |Checking { lv_prefix } { lv_vbeln }/{ lv_posnr } for transit plant| ).
      CHECK <ls_vbap>-vcm_chain_category IS INITIAL OR  <ls_vbap>-vcm_chain_category = 'SFSV'.
      IF <ls_vbap>-transit_plant IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = 'Success! Transit plant is empty.' ).
        ev_check_status     = abap_true.
        ev_exec_status = abap_true.
      ELSE.
        me->mo_run_environment->append_log( iv_log_statement = 'Error! Transit plant is filled unexpectedly.' ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  method doc_check_after_obd.
*This method is used to check the sales order documents are created for all the blocks
    data:
      ls_testdata      type ty_gs_ptf_or_check_ic_rpts_td,
      lv_attempts_max  type tb_attempts,  " maximumnumber of attempts
      lv_attempts_act  type tb_attempts,  " actual attempts
      lv_waiting_time  type s_mec_cputest_break_seconds,
      lv_idle_seconds  type s_mec_cputest_break_seconds,  " Idle Seconds Before Start
      lv_max_repeats   type /aif/repeat_counter,  " Maximum Number of Repeats
      lv_break_seconds type s_mec_cputest_break_seconds,  " Break Seconds Between Repeats
      lt_vbeln         type cl_ptf_util=>ty_vbeln_tab,
      lv_vbeln         type vbeln_va,
      lv_ettyp         type ettyp,
      lt_sales_key     type table of sales_key,
      lt_vbep          type table of vbep,
      lv_number(5)     type c,
      lv_statement     type bapi_msg.
    field-symbols: <ls_vbap> type vbap.

* get variant parameters from the testdata container data
    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = step_data
      importing
        es_testdata  = ls_testdata
    ).
    lv_idle_seconds = ls_testdata-idle_seconds.    "  Number of Idle Seconds Before Start
    lv_max_repeats   = ls_testdata-max_repeats.    " Maximum Number of Repeats
    lv_break_seconds = ls_testdata-break_seconds.  " Number of Seconds Between Repeats

    lv_attempts_max  = 1 + lv_max_repeats.         " Maximum Number of Attempts = (first try) + (repeats)

* write parameter values into log
    lv_statement = 'Parameter: Idle Seconds Before Start: &1'.
    lv_number = lv_idle_seconds.
    add 25 to lv_idle_seconds.
    replace '&1' in lv_statement with lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

    lv_statement = 'Parameter: Maximum number of repeats: &1'.
    lv_number = lv_max_repeats.
    replace '&1' in lv_statement with lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

    lv_statement = 'Parameter: Number of seconds between repeats: &1'.
    lv_number = lv_break_seconds.
    replace '&1' in lv_statement with lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

* get SCSO
    loop at step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_vbeln.
      append lines of lt_ptf_keys to lt_sales_key.
    endloop.
    clear lv_vbeln.
    read table lt_vbeln into lv_vbeln index 1.
    if lv_vbeln is initial.
      lv_statement = 'Error: No SOSC order found.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      return. " check fails
    endif.


* Idle Seconds Before Start: wait for ml ico process to be finished
    wait up to lv_idle_seconds seconds.

    data(lo_sd_sls_ic_utility) = cl_sd_sls_ic_factory=>so_instance->get_instance_util( ).

    " get link to PO/SO
    call function 'SD_VBEP_ARRAY_READ_VBELN'
      tables
        it_vbak_key           = lt_sales_key
        et_vbep               = lt_vbep
      exceptions
        records_not_found     = 1
        records_not_requested = 2
        others                = 3.
    if sy-subrc <> 0.
      lv_statement = 'Error: No items found in SCSO order &1'.
      replace '&1' in lv_statement with lv_vbeln.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      return. " check fails
    endif.

    check not lt_vbep[] is initial.
    lv_ettyp = lt_vbep[ 3 ]-ettyp.

    check lv_ettyp is not initial.
    select * from sdsls_gmtyp_det into table @data(lt_gmtyp)
      where ettyp = @lv_ettyp and value_chain_type = @ls_testdata-vcm_business_object.

    clear lv_attempts_act.

    do lv_attempts_max times.
      add 1 to lv_attempts_act.
      select *
     from vcm_rt_bo_item as itema
     inner join vcm_rt_bo_item as itemb
       on itema~value_chain_ins_guid = itemb~value_chain_ins_guid
      and itema~value_chain_item_guid = itemb~value_chain_item_guid
     left outer join vcm_rt_step_ins as step
       on itemb~step_ins_guid = step~guid
     left outer join vcm_rt_chain_ins as chain
       on itemb~value_chain_ins_guid = chain~guid
     into table @data(lt_vcm_item_all)
     where itema~business_object_id = @lv_vbeln
       and itema~business_object = 'SALES_ORDER'
       and itema~deleted   = @space
       and itema~cancelled = @space
       and itemb~deleted   = @space
       and itemb~cancelled = @space
       and step~step_type in ( SELECT step_type
           FROM vcm_step_type
          WHERE business_object = 'MATERIAL_DOCUMENT'
            AND value_chain_type = @ls_testdata-vcm_business_object
       )
       and chain~status in ('C', 'E', 'O', 'PD').
    enddo.
    if lt_vcm_item_all[] is not initial.
      data : lt_md_key   type wb2_material_key_stab,
             l_md_key    type wb2_material_key,
             lt_wb2_mseg type wb2_mseg_stab.

      loop at lt_vcm_item_all assigning field-symbol(<ls_item>).
        move: <ls_item>-itemb-business_object_id+0(10) to l_md_key-mblnr,
             <ls_item>-itemb-business_object_id+10(4) to l_md_key-mjahr.
        insert l_md_key into table lt_md_key.
      endloop.

      if lt_md_key[] is not initial .
        call function 'WB2_MSEG_ARRAY_READ'
          exporting
            it_key  = lt_md_key
          importing
            et_data = lt_wb2_mseg.
        if sy-subrc <> 0.
          lv_statement = 'Error: No items found in  order &1'.
          replace '&1' in lv_statement with lv_vbeln.
          me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
          return. " check fails
        endif.
      endif.
    endif.

* write the step  into the output log
    if lt_vcm_item_all[] is not initial.
      loop at lt_gmtyp assigning field-symbol(<ls_gm>).
        read table lt_vcm_item_all assigning field-symbol(<ls_vcm_item>) with key step-step_type = <ls_gm>-value_chain_step.
        check <ls_vcm_item> is not initial.
        read table lt_wb2_mseg assigning field-symbol(<l_mseg>) with key mblnr = <ls_vcm_item>-itemb-business_object_id+0(10)
                                                                         mjahr = <ls_vcm_item>-itemb-business_object_id+10(4).

        if <ls_gm>-bwart eq <l_mseg>-bwart.
          lv_statement = '&1 Document: OBJECT &2 determined with correct movement type &3'.
          replace '&1' in lv_statement with <ls_gm>-value_chain_step.
          replace '&2' in lv_statement with <ls_vcm_item>-itemb-business_object_id+0(10).
          replace '&3' in lv_statement with <ls_gm>-bwart.
          me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
          data(lv_status) = abap_true.
        else.
          lv_statement = 'Error: Determination of Goods Movement is incorrect'.
          me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
          return.
        endif.
      endloop.

      if lv_status eq abap_true.
        ev_check_status = abap_true.
        ev_execution_status = abap_true.
        loop at lt_vcm_item_all assigning field-symbol(<ls_item_link>).
          data(n) =  sy-tabix.
          if line_exists( lt_vcm_item_all[ n ] ).
            append lt_vcm_item_all[ n ]-itemb-business_object_id+0(10) to ev_document_id.
          endif.
        endloop.
      else.
        me->mo_run_environment->append_log( iv_log_statement = 'Error: No item found' ).
      endif.
      delete adjacent duplicates from ev_document_id.
    endif.
  endmethod.


  METHOD ml_check_doc_flow.

    TYPES: BEGIN OF ty_sales_key,
             vbeln                TYPE vbeln_va,
             posnr                TYPE posnr_va,
             value_chain_ins_guid TYPE vcm_uuid,
           END OF ty_sales_key,

           BEGIN OF ty_business_obj,
             vbeln TYPE vcm_business_object_id,
             posnr TYPE vcm_business_object_item_id,
           END OF ty_business_obj,

           BEGIN OF ty_po_key,
             ebeln                TYPE ebeln,
             ebelp                TYPE ebelp,
             value_chain_ins_guid TYPE vcm_uuid,
           END OF ty_po_key.

    DATA: lv_busobj        TYPE vcm_business_object_id,
          lt_bus_obj       TYPE STANDARD TABLE OF ty_business_obj,
          lt_scpo          TYPE SORTED TABLE OF ty_po_key WITH NON-UNIQUE KEY value_chain_ins_guid,
          lt_icpo          TYPE SORTED TABLE OF ty_po_key WITH NON-UNIQUE KEY value_chain_ins_guid,
          lt_icso          TYPE SORTED TABLE OF ty_sales_key WITH NON-UNIQUE KEY value_chain_ins_guid,
          lt_dcso          TYPE SORTED TABLE OF ty_sales_key WITH NON-UNIQUE KEY value_chain_ins_guid,
          lv_val_chain_x16 TYPE sysuuid_x16,
          lv_vbeln         TYPE vbeln_va,
          lv_busobj_item   TYPE vcm_business_object_item_id.

    DATA(lt_vbeln) = VALUE cl_ptf_util=>ty_vbeln_tab(
         FOR <lv_ref_step> IN is_step_data-reference_step
         ( LINES OF me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ) ) ).

    IF lt_vbeln IS INITIAL.
      me->mo_run_environment->append_log( 'Error: No Selling company sales order(SC_SO) found.' ).
      RETURN.
    ELSE.
      lv_vbeln = lt_vbeln[ 1 ].
      SELECT vbeln, posnr, vcm_chain_uuid, financial_chain_id
             FROM vbap INTO TABLE @DATA(lt_vbap)
             WHERE vbeln = @lv_vbeln.
      IF sy-subrc = 0.
        lt_bus_obj = VALUE #( FOR ls_vbap IN lt_vbap
                               ( vbeln = ls_vbap-vbeln
                                 posnr = ls_vbap-posnr ) ).
      ENDIF.
    ENDIF.
    " select
    SELECT  business_object_id, business_object_item_id,
            item~value_chain_ins_guid, scenario_id, financial_chain_id,
            step_type FROM vcm_rt_chain_ins AS chain
            INNER JOIN vcm_rt_bo_item AS item
            ON chain~guid = item~value_chain_ins_guid
            INNER JOIN vcm_rt_step_ins AS step
            ON step~guid = item~step_ins_guid
            INTO TABLE @DATA(lt_vcm_item)
            FOR ALL ENTRIES IN @lt_bus_obj
            WHERE chain~triggering_object_id = @lt_bus_obj-vbeln
            AND chain~status IN ('C', 'E', 'O', 'PD')
            AND step~step_type IN ('SC_SO','SC_PO', 'IC_SO','IC_PO', 'DC_SO' ).
    IF sy-subrc = 0.
      lt_scpo = VALUE #( FOR ls_vcm_itm IN lt_vcm_item
                                   WHERE ( step_type = 'SC_PO')
                               ( ebeln = ls_vcm_itm-business_object_id
                                 ebelp = ls_vcm_itm-business_object_item_id
                                 value_chain_ins_guid  = ls_vcm_itm-value_chain_ins_guid ) ).
      lt_icpo = VALUE #( FOR ls_vcm_itm IN lt_vcm_item
                                   WHERE ( step_type = 'IC_PO')
                               ( ebeln = ls_vcm_itm-business_object_id
                                 ebelp = ls_vcm_itm-business_object_item_id
                                 value_chain_ins_guid  = ls_vcm_itm-value_chain_ins_guid ) ).
      lt_icso = VALUE #( FOR ls_vcm_itm IN lt_vcm_item
                                   WHERE ( step_type = 'IC_SO')
                               ( vbeln = ls_vcm_itm-business_object_id
                                 posnr = ls_vcm_itm-business_object_item_id
                                 value_chain_ins_guid  = ls_vcm_itm-value_chain_ins_guid ) ).
      lt_dcso = VALUE #( FOR ls_vcm_itm IN lt_vcm_item
                                               WHERE ( step_type = 'DC_SO')
                               ( vbeln = ls_vcm_itm-business_object_id
                                 posnr = ls_vcm_itm-business_object_item_id
                                 value_chain_ins_guid  = ls_vcm_itm-value_chain_ins_guid )  ).
    ENDIF.
    LOOP AT lt_vbap ASSIGNING FIELD-SYMBOL(<ls_vbap>).
      CLEAR: lv_busobj, lv_busobj_item.
      lv_busobj = <ls_vbap>-vbeln.
      lv_busobj_item = <ls_vbap>-posnr.
      TRY.
          cl_system_uuid=>convert_uuid_c32_static(
            EXPORTING
              uuid     = <ls_vbap>-vcm_chain_uuid
            IMPORTING
              uuid_x16 = lv_val_chain_x16
          ).
        CATCH cx_uuid_error.
      ENDTRY.
      DATA(ls_vcm_item) = VALUE #( lt_vcm_item[ business_object_id = lv_busobj
                                                business_object_item_id = lv_busobj_item ] OPTIONAL ).
      IF ls_vcm_item-scenario_id IS NOT INITIAL.
        SPLIT ls_vcm_item-scenario_id AT '-' INTO DATA(lv_selc) DATA(lv_intc) DATA(lv_delc).
      ENDIF.

      DATA(lt_scpo1) = FILTER #( lt_scpo WHERE value_chain_ins_guid = lv_val_chain_x16 ) .
      IF lt_scpo1 IS NOT INITIAL.
        me->mo_run_environment->append_log( |**SC_PO document creation verified and registered in VCM for the item { <ls_vbap>-vbeln }/ { <ls_vbap>-posnr }| ).
      ELSE.
        me->mo_run_environment->append_log( | **No valid SC_PO found in VCM.| ).
      ENDIF.

      DATA(lt_icpo1) = FILTER #( lt_icpo WHERE value_chain_ins_guid = lv_val_chain_x16 ) .
      DATA(lv_lines) = lines( lt_icpo1 ).
      IF lt_icpo1 IS INITIAL.
        me->mo_run_environment->append_log( | **No valid IC_PO found in VCM.| ).
      ELSE.
        me->mo_run_environment->append_log( |**Intermediate company count: { lv_intc }| ).
        IF lv_lines = lv_intc.
          me->mo_run_environment->append_log( |**IC_PO document creation verified and registered in VCM for the item { <ls_vbap>-vbeln } / { <ls_vbap>-posnr }| ).
          me->mo_run_environment->append_log( |** Success!! Number of IC_PO documents matches with the count of intermediate company| ).
        ELSE.
          me->mo_run_environment->append_log( |** Error!! Number of IC_PO documents differs with the count of intermediate company| ).
        ENDIF.
      ENDIF.

      DATA(lt_icso1) = FILTER #( lt_icso WHERE value_chain_ins_guid = lv_val_chain_x16 ) .
      DATA(lv_totlines) = lines( lt_icso1 ).
      IF lt_icpo1 IS INITIAL.
        me->mo_run_environment->append_log( | **No valid IC_SO found in VCM.| ).
      ELSE.
        me->mo_run_environment->append_log( |**Intermediate company count: { lv_intc }| ).
        IF lv_totlines = lv_intc.
          me->mo_run_environment->append_log( |**IC_SO document creation verified and registered in VCM for the item { <ls_vbap>-vbeln }/ { <ls_vbap>-posnr }| ).
          me->mo_run_environment->append_log( |** Success!! Number of IC_SO documents matches with the count of intermediate company| ).
        ELSE.
          me->mo_run_environment->append_log( |** Error!! Number of IC_SO documents differs with the count of intermediate company| ).
        ENDIF.
      ENDIF.

      DATA(lt_dcso1) = FILTER #( lt_dcso WHERE value_chain_ins_guid = lv_val_chain_x16 ) .
      IF lt_dcso1 IS NOT INITIAL.
        me->mo_run_environment->append_log( |**DC_SO document creation verified and registered in VCM for the item { <ls_vbap>-vbeln }/ { <ls_vbap>-posnr }| ).
      ELSE.
        me->mo_run_environment->append_log( | **No valid DC_SO found in VCM.| ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD ml_chk_material_change_dc_so.
* This method checks that the transit plant is NOT filled for DC_SO items linked to an SCSO document.

    DATA: lt_vbeln_scso  TYPE cl_ptf_util=>ty_vbeln_tab,
          lt_sales_key   TYPE STANDARD TABLE OF sales_key,
          lt_vbap_dcso   TYPE vbap_tab,
          lt_vcm_items   TYPE ty_vcm_item_tab,
          lv_vbeln_scso  TYPE vbeln_va,
          lv_error_found TYPE abap_bool,
          lv_vbeln       TYPE string,
          lv_posnr       TYPE string,
           lt_vbap       TYPE TABLE OF vbap,
          ls_testdata   TYPE ty_gs_ptf_or_check_ic_rpts_td,
          lv_prefix      TYPE string VALUE 'DCSO'.

    FIELD-SYMBOLS: <ls_vbap>     TYPE vbap,
                   <ls_vcm_item> TYPE ty_vcm_item,
                   <lv_ref_step> TYPE i.

    ev_check_status     = abap_false.
    ev_exec_status = abap_false.

    " Get test parameters
    cl_ptf_util=>get_testdata(
              EXPORTING is_step_data = step_data
              IMPORTING es_testdata  = ls_testdata ).

    " Get SCSO document numbers from reference steps
    LOOP AT step_data-reference_step ASSIGNING <lv_ref_step>.
      DATA(lt_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_keys TO lt_vbeln_scso.
      APPEND LINES OF lt_keys TO lt_sales_key.
    ENDLOOP.

      IF lt_sales_key IS NOT INITIAL.
      SELECT vbeln, vkorg FROM vbak
      INTO TABLE @DATA(lt_vbak)
            FOR ALL ENTRIES IN @lt_sales_key
            WHERE vbeln = @lt_sales_key-vbeln.

      CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
        TABLES
          it_vbak_key           = lt_sales_key
          et_vbap               = lt_vbap
        EXCEPTIONS
          records_not_found     = 1
          records_not_requested = 2
          OTHERS                = 3.
      IF sy-subrc = 0.

      ENDIF.
    ENDIF.

    READ TABLE lt_vbeln_scso INTO lv_vbeln_scso INDEX 1.
    IF lv_vbeln_scso IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = 'Error: No SCSO document found in reference step.' ).
      RETURN.
    ENDIF.

    " Use SCSO VBELN directly to get VCM entries for DCSO
    SELECT *
      FROM vcm_rt_bo_item AS itema
      INNER JOIN vcm_rt_bo_item AS itemb ON itema~value_chain_ins_guid = itemb~value_chain_ins_guid
                                        AND itema~value_chain_item_guid = itemb~value_chain_item_guid
      LEFT OUTER JOIN vcm_rt_step_ins AS step ON itemb~step_ins_guid = step~guid
      INTO TABLE @lt_vcm_items
      WHERE itema~business_object_id = @lv_vbeln_scso
        AND itema~business_object = 'SALES_ORDER'
        AND itema~deleted = @space
        AND itema~cancelled = @space
        AND itemb~deleted = @space
        AND itemb~cancelled = @space
        AND step~step_type = 'DC_SO'.

    IF lt_vcm_items IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = 'No DCSO items found linked to the SCSO document.' ).
      RETURN.
    ENDIF.

    " Collect DCSO VBELNs
    DATA(lt_vbeln_dcso) = VALUE cl_ptf_util=>ty_vbeln_tab( ).
    LOOP AT lt_vcm_items ASSIGNING <ls_vcm_item>.
      APPEND <ls_vcm_item>-itemb-business_object_id TO lt_vbeln_dcso.
    ENDLOOP.
    DELETE ADJACENT DUPLICATES FROM lt_vbeln_dcso.

    CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
      TABLES
        it_vbak_key = lt_vbeln_dcso
        et_vbap     = lt_vbap_dcso.

    IF lt_vcm_items IS NOT INITIAL.
          LOOP AT lt_vcm_items ASSIGNING FIELD-SYMBOL(<ls_item_link>).
        "For Plant
        IF ls_testdata-vcm_business_object = 'MATNR'.
          READ TABLE lt_vbap ASSIGNING <ls_vbap>
          WITH KEY vbeln = <ls_item_link>-itema-business_object_id
          posnr = <ls_item_link>-itema-business_object_item_id.
          IF sy-subrc = 0.
          ENDIF.

          READ TABLE lt_vbap_dcso ASSIGNING FIELD-SYMBOL(<ls_vbap_dcso>)
          WITH KEY vbeln = <ls_item_link>-itemb-business_object_id
          posnr = <ls_item_link>-itemb-business_object_item_id.
          IF sy-subrc = 0.
          ENDIF.

            " Log comparison
            me->mo_run_environment->append_log( |**Checking the material FOR PO { <ls_item_link>-itema-business_object_id }/{ <ls_item_link>-itema-business_object_item_id }| ).
            me->mo_run_environment->append_log( |**IC_PO: { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
            me->mo_run_environment->append_log( |Material: { <ls_vbap>-matnr } |
            & |Identified Material FOR IC_PO: { <ls_vbap_dcso>-matnr }| ).
            "Check the material
            IF <ls_vbap>-matnr  = <ls_vbap_dcso>-matnr.
              me->mo_run_environment->append_log( |Success: Material match FOR IC_PO { <ls_item_link>-itemb-business_object_id }| ).
              DATA(lv_success) = abap_true.
            ELSE.
              me->mo_run_environment->append_log( |Failure: Material mismatch FOR IC_PO { <ls_item_link>-itemb-business_object_id }| ).
            ENDIF.
          ENDIF.

      ENDLOOP.

 APPEND <ls_item_link>-itemb-business_object_id(10) TO ev_doc_id. "Take first 10 characters
      " Set final status
      ev_check_status = lv_success.
      ev_exec_status = abap_true.
      DELETE ADJACENT DUPLICATES FROM ev_doc_id.
    ELSE.
      me->mo_run_environment->append_log( 'Error: No Intermediate company PO was found(IC_PO) was found' ).
    ENDIF.

  ENDMETHOD.


  METHOD ML_CHK_MATERIAL_CHANGE_IC_PO.
        TYPES: BEGIN OF ty_fin_chain,
             fin_chain_id  TYPE fch_financial_chain_id,
             block_id      TYPE vcm_chain_element_id,
             prec_plant_id TYPE fch_sequence_no,
           END OF ty_fin_chain,

           BEGIN OF ty_po_numbers,
             ebeln TYPE ebeln,
             ebelp TYPE ebelp,
           END OF ty_po_numbers,

           ty_po_numbers_tab TYPE STANDARD TABLE OF ty_po_numbers WITH EMPTY KEY.


    DATA:
      ls_testdata   TYPE ty_gs_ptf_or_check_ic_rpts_td,
      ls_plant_data TYPE t001w,
      ls_tvko       TYPE tvko,
      lt_sales_key  TYPE TABLE OF sales_key,
      lt_vbap       TYPE TABLE OF vbap,
      lt_fin_chain  TYPE STANDARD TABLE OF ty_fin_chain,
      lv_statement  TYPE bapi_msg.

    " Get test parameters
    cl_ptf_util=>get_testdata(
              EXPORTING is_step_data = step_data
              IMPORTING es_testdata  = ls_testdata ).

    " Initialize parameters
    DATA(lv_idle_seconds) = ls_testdata-idle_seconds.
    DATA(lv_max_repeats) = ls_testdata-max_repeats.
    DATA(lv_break_seconds) = ls_testdata-break_seconds.
    DATA(lv_attempts_max) = 1 + lv_max_repeats.

    " Log parameters
    me->mo_run_environment->append_log( |PARAMETER: Idle Seconds Before Start: { lv_idle_seconds }| ).
    me->mo_run_environment->append_log( |PARAMETER: Maximum repeats: { lv_max_repeats }| ).
    me->mo_run_environment->append_log( |PARAMETER: Seconds BETWEEN repeats: { lv_break_seconds }| ).

    " Get sales orders from reference steps
    DATA(lt_vbeln) = VALUE cl_ptf_util=>ty_vbeln_tab(
          FOR <lv_ref_step> IN step_data-reference_step
          ( LINES OF me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ) ) ).

    IF lt_vbeln IS INITIAL.
      me->mo_run_environment->append_log( 'Error: Intermediate company SO(IC_SO) not found.' ).
      RETURN.
    ENDIF.

    DATA(lv_vbeln) = lt_vbeln[ 1 ].
    APPEND LINES OF lt_vbeln TO lt_sales_key.
    WAIT UP TO lv_idle_seconds SECONDS.
    " get link to PO/SO

    IF lt_sales_key IS NOT INITIAL.
      SELECT vbeln, vkorg FROM vbak
      INTO TABLE @DATA(lt_vbak)
            FOR ALL ENTRIES IN @lt_sales_key
            WHERE vbeln = @lt_sales_key-vbeln.

      CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
        TABLES
          it_vbak_key           = lt_sales_key
          et_vbap               = lt_vbap
        EXCEPTIONS
          records_not_found     = 1
          records_not_requested = 2
          OTHERS                = 3.
      IF sy-subrc = 0.

      ENDIF.
    ENDIF.

    DATA(lv_waiting_time) = 0.
    DATA(lv_attempts_act) = 0.
    DATA(lt_vcm_item) = VALUE ty_vcm_item_tab( ).
    DATA(lv_no_ic_po) = abap_true.

    DO lv_attempts_max TIMES.
      lv_attempts_act += 1.

      SELECT * FROM vcm_rt_bo_item AS itema
      INNER JOIN vcm_rt_bo_item AS itemb
      ON  itema~value_chain_ins_guid = itemb~value_chain_ins_guid
      AND itema~value_chain_item_guid = itemb~value_chain_item_guid
      LEFT OUTER JOIN vcm_rt_step_ins AS step
      ON itemb~step_ins_guid = step~guid
      LEFT OUTER JOIN vcm_rt_chain_ins AS chain
      ON itemb~value_chain_ins_guid = chain~guid
      INTO TABLE @lt_vcm_item
      WHERE itema~business_object_id = @lv_vbeln
      AND itema~business_object = 'SALES_ORDER'
      AND itema~deleted = @space
      AND itema~cancelled = @space
      AND itemb~deleted = @space
      AND itemb~cancelled = @space
      AND step~step_type = 'IC_PO'
      AND chain~status IN ('C', 'E', 'O', 'PD').

      IF lt_vcm_item IS INITIAL.
        lv_waiting_time += lv_break_seconds.
        WAIT UP TO lv_break_seconds SECONDS.
      ELSE.
        lv_no_ic_po = abap_false.
        LOOP AT lt_vcm_item ASSIGNING FIELD-SYMBOL(<ls_item_link>).
          IF <ls_item_link>-itemb IS INITIAL.
            lv_no_ic_po = abap_true.
            EXIT.
          ENDIF.
        ENDLOOP.

        IF lv_no_ic_po = abap_false.
          EXIT. " Found valid SC_PO links
        ELSE.
          lv_waiting_time += lv_break_seconds.
          WAIT UP TO lv_break_seconds SECONDS.
        ENDIF.
      ENDIF.
    ENDDO.

    " Log attempts and waiting time
    me->mo_run_environment->append_log( |Attempts TO READ VCM item link: { lv_attempts_act }| ).
    me->mo_run_environment->append_log( |Total waiting TIME: { lv_waiting_time } seconds| ).

    IF lv_no_ic_po = abap_false AND lt_vcm_item IS NOT INITIAL.
      " Create PO numbers table from VCM items
      DATA(lt_po_numbers) = VALUE ty_po_numbers_tab( FOR <fs_item> IN lt_vcm_item
            ( ebeln = <fs_item>-itemb-business_object_id
              ebelp = <fs_item>-itemb-business_object_item_id ) ).
      IF lt_po_numbers IS NOT INITIAL.
        SELECT ekko~ebeln, ekko~lifnr, ekko~ekorg, ekko~ekgrp, ekpo~ebelp, ekpo~matnr
        FROM ekko
        INNER JOIN ekpo on ekko~ebeln = ekpo~ebeln INTO TABLE @DATA(lt_ekko)
              FOR ALL ENTRIES IN @lt_po_numbers
              WHERE ekko~ebeln = @lt_po_numbers-ebeln.
      ENDIF.
*
      LOOP AT lt_vcm_item ASSIGNING <ls_item_link>.
        "For Plant
        IF ls_testdata-vcm_business_object = 'MATNR'.
          READ TABLE lt_vbap ASSIGNING FIELD-SYMBOL(<ls_vbap>)
          WITH KEY vbeln = <ls_item_link>-itema-business_object_id
          posnr = <ls_item_link>-itema-business_object_item_id.
          IF sy-subrc = 0.
            ENDIF.

            READ TABLE lt_ekko ASSIGNING FIELD-SYMBOL(<ls_ekko>)
            WITH KEY ebeln = <ls_item_link>-itemb-business_object_id.
            " Log comparison
            me->mo_run_environment->append_log( |**Checking the material FOR PO { <ls_item_link>-itema-business_object_id }/{ <ls_item_link>-itema-business_object_item_id }| ).
            me->mo_run_environment->append_log( |**IC_PO: { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
            me->mo_run_environment->append_log( |Material: { <ls_vbap>-matnr } |
            & |Identified Material FOR IC_PO: { <ls_ekko>-matnr }| ).
            "Check the material
            IF <ls_vbap>-matnr  = <ls_ekko>-matnr.
              me->mo_run_environment->append_log( |Success: Material match FOR IC_PO { <ls_item_link>-itemb-business_object_id }| ).
              DATA(lv_success) = abap_true.
            ELSE.
              me->mo_run_environment->append_log( |Failure: Material mismatch FOR IC_PO { <ls_item_link>-itemb-business_object_id }| ).
            ENDIF.
          ENDIF.

      ENDLOOP.
      APPEND <ls_item_link>-itemb-business_object_id(10) TO ev_doc_id. "Take first 10 characters
      " Set final status
      ev_check_status = lv_success.
      ev_exec_status = abap_true.
      DELETE ADJACENT DUPLICATES FROM ev_doc_id.
    ELSE.
      me->mo_run_environment->append_log( 'Error: No Intermediate company PO was found(IC_PO) was found' ).
    ENDIF.

  ENDMETHOD.


  METHOD ml_chk_material_change_ic_so.

      data:
    lt_sales_key      type table of sales_key,
    lt_vbep           type table of bapisdhedu,  " BAPI schedule lines
    lt_vbap           type table of bapisditbos,
    lv_vbeln          type bapivbeln-vbeln,
    lv_so_tax_country type land1.

  " Get test parameters
  data(ls_testdata) = value ty_gs_ptf_or_check_ic_rpts_td( ).
  cl_ptf_util=>get_testdata(
    exporting is_step_data = step_data
    importing es_testdata  = ls_testdata ).

  " Initialize parameters
  data(lv_idle_seconds) = ls_testdata-idle_seconds + 15. " Buffer
  data(lv_max_repeats) = ls_testdata-max_repeats.
  data(lv_break_seconds) = ls_testdata-break_seconds.
  data(lv_attempts_max) = 1 + lv_max_repeats.

  " Log parameters
  me->mo_run_environment->append_log( |Parameter: Idle Seconds Before Start: { lv_idle_seconds }| ).
  me->mo_run_environment->append_log( |Parameter: Maximum repeats: { lv_max_repeats }| ).
  me->mo_run_environment->append_log( |Parameter: Seconds between repeats: { lv_break_seconds }| ).

  " Get sales orders from reference steps
  data(lt_vbeln) = value cl_ptf_util=>ty_vbeln_tab(
    for <lv_ref_step> in step_data-reference_step
    ( lines of me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ) ) ).

  if lt_vbeln is initial.
    me->mo_run_environment->append_log( 'Error: No Selling Company SO order found.' ).
    return.
  endif.

  lv_vbeln = lt_vbeln[ 1 ].
  append lines of lt_vbeln to lt_sales_key.

  " Initial wait
  wait up to lv_idle_seconds seconds.

  " Get SO data using BAPI
  data(ls_vbak) = value bapisdhd( ).
  data(ls_ic_so_header) = value bapisdhd( ).
  call function 'BAPI_SALESORDER_GETDETAILBOS'
    exporting
      salesdocument      = lv_vbeln
    importing
      orderheader        = ls_vbak
    tables
      orderitems         = lt_vbap.

  if lt_vbap[] is initial.
    me->mo_run_environment->append_log( |Error: No items found in Selling Company SO order| ).
    return.
  endif.


  " Find IC_SO links with retry logic
  data(lv_waiting_time) = 0.
  data(lv_attempts_act) = 0.
  data(lt_vcm_item)     = value ty_vcm_item_tab( ).
  data(lv_no_ic_so)     = abap_true.

  do lv_attempts_max times.
    lv_attempts_act += 1.

    select *
      from vcm_rt_bo_item as itema
      inner join vcm_rt_bo_item as itemb
        on itema~value_chain_ins_guid = itemb~value_chain_ins_guid
       and itema~value_chain_item_guid = itemb~value_chain_item_guid
      left outer join vcm_rt_step_ins as step
        on itemb~step_ins_guid = step~guid
      left outer join vcm_rt_chain_ins as chain
        on itemb~value_chain_ins_guid = chain~guid
      into table @lt_vcm_item
      where itema~business_object_id = @lv_vbeln
        and itema~business_object = 'SALES_ORDER'
        and itema~deleted = @space
        and itema~cancelled = @space
        and itemb~deleted = @space
        and itemb~cancelled = @space
        and step~step_type = 'IC_SO'
        and chain~status in ('C', 'E', 'O', 'PD').

    if lt_vcm_item is initial.
      lv_waiting_time += lv_break_seconds.
      wait up to lv_break_seconds seconds.
    else.
      lv_no_ic_so = abap_false.
      loop at lt_vcm_item assigning field-symbol(<ls_item_link>).
        if <ls_item_link>-itemb is initial.
          lv_no_ic_so = abap_true.
          exit.
        endif.
      endloop.

      if lv_no_ic_so = abap_false.
        exit. " Found valid IC_SO links
      else.
        lv_waiting_time += lv_break_seconds.
        wait up to lv_break_seconds seconds.
      endif.
    endif.
  enddo.

  me->mo_run_environment->append_log( |Attempts to read VCM item link: { lv_attempts_act }| ).
  me->mo_run_environment->append_log( |Total waiting time: { lv_waiting_time } seconds| ).

  if lv_no_ic_so = abap_false and lt_vcm_item is not initial.

    " First declare the type
    types: ty_vbeln_tab type standard table of vbeln with empty key.

    data(lt_ic_so_numbers) = value ty_vbeln_tab(
        for <fs_item> in lt_vcm_item
        ( conv vbeln( <fs_item>-itemb-business_object_id ) ) ).

    " Fetch IC_SO items
    if lt_ic_so_numbers is not initial.
      select vbeln, posnr, matnr
        from vbap
        into table @data(lt_vbap_ic)
        for all entries in @lt_ic_so_numbers
        where vbeln = @lt_ic_so_numbers-table_line.
    endif.

    loop at lt_vcm_item assigning <ls_item_link>.
      case ls_testdata-vcm_business_object.
        when 'MATNR'.
          read table lt_vbap assigning field-symbol(<ls_vbap>)
            with key doc_number = <ls_item_link>-itema-business_object_id
                     itm_number = <ls_item_link>-itema-business_object_item_id.
          check <ls_vbap>-MATERIAL is not initial.

          read table lt_vbap_ic assigning field-symbol(<ls_vbap_ic>)
            with key vbeln = <ls_item_link>-itemb-business_object_id
                     posnr = <ls_item_link>-itemb-business_object_item_id.

          if <ls_vbap> is not initial and <ls_vbap_ic> is not initial.

            me->mo_run_environment->append_log( |**Checking Material for SO { <ls_item_link>-itema-business_object_id }/{ <ls_item_link>-itema-business_object_item_id }| ).
            me->mo_run_environment->append_log( |**IC_SO: { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
            me->mo_run_environment->append_log( |Material: '{ <ls_vbap>-MATERIAL }' && | & |IC_SO Date: { <ls_vbap_ic>-matnr }| ).

            if <ls_vbap>-MATERIAL = <ls_vbap_ic>-matnr.
              me->mo_run_environment->append_log( |Success: Material match for IC_SO { <ls_item_link>-itemb-business_object_id }| ).
            else.
              me->mo_run_environment->append_log( |Failure: Material mismatch for IC_SO { <ls_item_link>-itemb-business_object_id }| ).
            endif.
          endif.


        when others.
          me->mo_run_environment->append_log( |IC_SO found: { <ls_item_link>-itemb-business_object_id }| ).
      endcase.

      append <ls_item_link>-itemb-business_object_id(10) to ev_doc_id.
    endloop.

    delete adjacent duplicates from ev_doc_id.
    ev_check_status = abap_true.

  else.
    me->mo_run_environment->append_log( 'Error: No IC_SO found within given attempts.' ).
    ev_check_status = abap_false.
  endif.

  ENDMETHOD.


METHOD ML_CHK_MATERIAL_CHANGE_SC_PO.

  TYPES: BEGIN OF ty_fin_chain,
    fin_chain_id    TYPE fch_financial_chain_id,
    block_id        TYPE vcm_chain_element_id,
    prec_plant_id   TYPE fch_sequence_no,
  END OF ty_fin_chain,

  BEGIN OF ty_po_numbers,
    ebeln TYPE ebeln,
    ebelp TYPE ebelp,
  END OF ty_po_numbers,

  ty_po_numbers_tab TYPE STANDARD TABLE OF ty_po_numbers WITH empty KEY.


  DATA:
        ls_testdata  TYPE ty_gs_ptf_or_check_ic_rpts_td,
        ls_plant_data TYPE t001w,
        ls_tvko       TYPE tvko,
        lt_sales_key TYPE TABLE OF sales_key,
        lt_vbap      TYPE TABLE OF vbap,
        lv_statement TYPE bapi_msg.

  " Get test parameters
  cl_ptf_util=>get_testdata(
            EXPORTING is_step_data = step_data
            IMPORTING es_testdata  = ls_testdata ).

  " Initialize parameters
  DATA(lv_idle_seconds) = ls_testdata-idle_seconds.
  DATA(lv_max_repeats) = ls_testdata-max_repeats.
  DATA(lv_break_seconds) = ls_testdata-break_seconds.
  DATA(lv_attempts_max) = 1 + lv_max_repeats.

  " Log parameters
  me->mo_run_environment->append_log( |PARAMETER: Idle Seconds Before Start: { lv_idle_seconds }| ).
  me->mo_run_environment->append_log( |PARAMETER: Maximum repeats: { lv_max_repeats }| ).
  me->mo_run_environment->append_log( |PARAMETER: Seconds BETWEEN repeats: { lv_break_seconds }| ).

  " Get sales orders from reference steps
  DATA(lt_vbeln) = VALUE cl_ptf_util=>ty_vbeln_tab(
        FOR <lv_ref_step> IN step_data-reference_step
        ( LINES OF me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ) ) ).

  IF lt_vbeln IS INITIAL.
    me->mo_run_environment->append_log( 'Error: No SO2 order found.' ).
    RETURN.
  ENDIF.

  DATA(lv_vbeln) = lt_vbeln[ 1 ].
  APPEND LINES OF lt_vbeln TO lt_sales_key.

  WAIT UP TO lv_idle_seconds seconds.
  " get link to PO/SO

  IF lt_sales_key IS NOT INITIAL.
    SELECT vbeln, vkorg FROM vbak
    INTO TABLE @DATA(lt_vbak)
          FOR ALL ENTRIES IN @lt_sales_key
          WHERE vbeln = @lt_sales_key-vbeln.

    CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
    TABLES
      it_vbak_key           = lt_sales_key
      et_vbap               = lt_vbap
    EXCEPTIONS
      records_not_found     = 1
      records_not_requested = 2
      OTHERS                = 3.
    IF sy-subrc = 0.
    ENDIF.
  ENDIF.

  DATA(lv_waiting_time) = 0.
  DATA(lv_attempts_act) = 0.
  DATA(lt_vcm_item) = VALUE ty_vcm_item_tab( ).
  DATA(lv_no_sc_po) = abap_true.

  DO lv_attempts_max TIMES.
    lv_attempts_act += 1.

    SELECT * FROM vcm_rt_bo_item AS itema
    INNER JOIN vcm_rt_bo_item AS itemb
    ON  itema~value_chain_ins_guid = itemb~value_chain_ins_guid
    AND itema~value_chain_item_guid = itemb~value_chain_item_guid
    LEFT outer JOIN vcm_rt_step_ins AS step
    ON itemb~step_ins_guid = step~guid
    LEFT outer JOIN vcm_rt_chain_ins AS chain
    ON itemb~value_chain_ins_guid = chain~guid
    INTO TABLE @lt_vcm_item
    WHERE itema~business_object_id = @lv_vbeln
    AND itema~business_object = 'SALES_ORDER'
    AND itema~deleted = @space
    AND itema~cancelled = @space
    AND itemb~deleted = @space
    AND itemb~cancelled = @space
    AND step~step_type = 'SC_PO'
    AND chain~status IN ('C', 'E', 'O', 'PD').

    IF lt_vcm_item IS INITIAL.
      lv_waiting_time += lv_break_seconds.
      WAIT UP TO lv_break_seconds seconds.
    ELSE.
      lv_no_sc_po = abap_false.
      LOOP AT lt_vcm_item ASSIGNING FIELD-SYMBOL(<ls_item_link>).
        IF <ls_item_link>-itemb IS INITIAL.
          lv_no_sc_po = abap_true.
          EXIT.
        ENDIF.
      ENDLOOP.

      IF lv_no_sc_po = abap_false.
        EXIT. " Found valid SC_PO links
      ELSE.
        lv_waiting_time += lv_break_seconds.
        WAIT UP TO lv_break_seconds seconds.
      ENDIF.
    ENDIF.
  ENDDO.

  " Log attempts and waiting time
  me->mo_run_environment->append_log( |Attempts TO READ VCM item link: { lv_attempts_act }| ).
  me->mo_run_environment->append_log( |Total waiting TIME: { lv_waiting_time } seconds| ).

  IF lv_no_sc_po = abap_false AND lt_vcm_item IS NOT INITIAL.
    " Create PO numbers table from VCM items
    DATA(lt_po_numbers) = VALUE ty_po_numbers_tab( FOR <fs_item> IN lt_vcm_item
          ( ebeln = <fs_item>-itemb-business_object_id
          ebelp = <fs_item>-itemb-business_object_item_id ) ).
    IF lt_po_numbers IS NOT INITIAL.
      SELECT ekko~ebeln, ekko~lifnr, ekko~ekorg, ekko~ekgrp, ekpo~ebelp, ekpo~matnr
      FROM ekko
      inner join ekpo on ekko~ebeln = ekpo~ebeln
        INTO TABLE @DATA(lt_ekko)
            FOR ALL ENTRIES IN @lt_po_numbers
            WHERE ekko~ebeln = @lt_po_numbers-ebeln.
    ENDIF.
*
    LOOP AT lt_vcm_item ASSIGNING <ls_item_link>.
      "For Material
      IF ls_testdata-vcm_business_object = 'MATNR'.
        READ TABLE lt_vbap ASSIGNING FIELD-SYMBOL(<ls_vbap>)
        WITH KEY vbeln = <ls_item_link>-itema-business_object_id
        posnr = <ls_item_link>-itema-business_object_item_id.
        IF sy-subrc = 0.
          READ TABLE lt_ekko ASSIGNING FIELD-SYMBOL(<ls_ekko>)
          WITH KEY ebeln = <ls_item_link>-itemb-business_object_id.
          " Log comparison
          me->mo_run_environment->append_log( |**Checking the Material FOR PO { <ls_item_link>-itema-business_object_id }/{ <ls_item_link>-itema-business_object_item_id }| ).
          me->mo_run_environment->append_log( |**SC_PO: { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
          me->mo_run_environment->append_log( |Material at SC_SO: { <ls_vbap>-matnr } |
          & |Identified Material FOR SC_PO: { <ls_ekko>-matnr }| ).

      ENDIF.
     ENDIF.
    ENDLOOP.
    APPEND <ls_item_link>-itemb-business_object_id(10) TO ev_doc_id. "Take first 10 characters
    " Set final status
    ev_check_status = abap_true.
    ev_exec_status = abap_true.
    DELETE ADJACENT DUPLICATES FROM ev_doc_id.
  ELSE.
    me->mo_run_environment->append_log( 'Error: No Selling company PO was found(SC_PO) was found' ).
  ENDIF.
ENDMETHOD.


  METHOD ml_chk_plant_change_dc_so.

    TYPES: BEGIN OF ty_fin_chain,
             fin_chain_id TYPE fch_financial_chain_id,
             block_id     TYPE vcm_chain_element_id,
           END OF ty_fin_chain,

           BEGIN OF ty_po_numbers,
             ebeln TYPE ebeln,
             ebelp TYPE ebelp,
           END OF ty_po_numbers,

           ty_po_numbers_tab TYPE STANDARD TABLE OF ty_po_numbers WITH EMPTY KEY.


    DATA:
      ls_testdata   TYPE ty_gs_ptf_or_check_ic_rpts_td,
      ls_plant_data TYPE t001w,
      ls_tvko       TYPE tvko,
      lt_sales_key  TYPE TABLE OF sales_key,
      lt_vbap       TYPE TABLE OF vbap,
      lt_fin_chain  TYPE STANDARD TABLE OF ty_fin_chain,
      lt_stepno     TYPE cl_ptf_util=>gty_reference_tab,
      lt_prec_doc   TYPE cl_ptf_util=>ty_result_key_data_tab,
      lv_statement  TYPE bapi_msg.

    " Get test parameters
    cl_ptf_util=>get_testdata(
              EXPORTING is_step_data = step_data
              IMPORTING es_testdata  = ls_testdata ).

    " Initialize parameters
    DATA(lv_idle_seconds) = ls_testdata-idle_seconds + 15.
    DATA(lv_max_repeats) = ls_testdata-max_repeats.
    DATA(lv_break_seconds) = ls_testdata-break_seconds.
    DATA(lv_attempts_max) = 1 + lv_max_repeats.

    " Log parameters
    me->mo_run_environment->append_log( |PARAMETER: Idle Seconds Before Start: { lv_idle_seconds }| ).
    me->mo_run_environment->append_log( |PARAMETER: Maximum repeats: { lv_max_repeats }| ).
    me->mo_run_environment->append_log( |PARAMETER: Seconds between repeats: { lv_break_seconds }| ).

    " Get sales orders from reference steps
    DATA(lt_vbeln) = VALUE cl_ptf_util=>ty_vbeln_tab(
          FOR <lv_ref_step> IN step_data-reference_step
          ( LINES OF me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ) ) ).

    IF lt_vbeln IS INITIAL.
      me->mo_run_environment->append_log( 'Error: No Selling Company SO found.' ).
      RETURN.
    ELSE.
      DATA(lv_vbeln) = lt_vbeln[ 1 ].
      APPEND LINES OF lt_vbeln TO lt_sales_key.
    ENDIF.

    lt_stepno = VALUE #( ( iv_step_number - 1 ) ).
    lt_prec_doc = me->mo_run_environment->get_result_key_data( it_step_number = lt_stepno ).


    IF lt_prec_doc IS NOT INITIAL.
      DATA(lt_po_key) = VALUE ty_po_numbers_tab( FOR <fs_prec_doc> IN lt_prec_doc
                                            ( ebeln = <fs_prec_doc>-document_id_char70 ) ).

      SELECT COUNT(*) FROM ekko FOR ALL ENTRIES IN @lt_po_key
                    WHERE ebeln = @lt_po_key-ebeln.
      IF sy-subrc <> 0.
        me->mo_run_environment->append_log( 'Error: No Intermediate Company PO (IC_PO) found.' ).
        RETURN.
      ENDIF.
    ENDIF.


    WAIT UP TO lv_idle_seconds SECONDS.
    DATA(lv_waiting_time) = 0.
    DATA(lv_attempts_act) = 0.
    DATA(lt_vcm_item) = VALUE ty_vcm_item_tab( ).
    DATA(lv_no_dc_so) = abap_true.

    DO lv_attempts_max TIMES.
      lv_attempts_act += 1.

      SELECT * FROM vcm_rt_bo_item AS itema
      INNER JOIN vcm_rt_bo_item AS itemb
      ON  itema~value_chain_ins_guid = itemb~value_chain_ins_guid
      AND itema~value_chain_item_guid = itemb~value_chain_item_guid
      LEFT OUTER JOIN vcm_rt_step_ins AS step
      ON itemb~step_ins_guid = step~guid
      LEFT OUTER JOIN vcm_rt_chain_ins AS chain
      ON itemb~value_chain_ins_guid = chain~guid
      INTO TABLE @lt_vcm_item
      WHERE itema~business_object_id = @lv_vbeln
      AND itema~business_object = 'SALES_ORDER'
      AND itema~deleted = @space
      AND itema~cancelled = @space
      AND itemb~deleted = @space
      AND itemb~cancelled = @space
      AND step~step_type = 'DC_SO'
      AND chain~status IN ('C', 'E', 'O', 'PD').

      IF lt_vcm_item IS INITIAL.
        lv_waiting_time += lv_break_seconds.
        WAIT UP TO lv_break_seconds SECONDS.
      ELSE.
        lv_no_dc_so = abap_false.
        LOOP AT lt_vcm_item ASSIGNING FIELD-SYMBOL(<ls_item_link>).
          IF <ls_item_link>-itemb IS INITIAL.
            lv_no_dc_so = abap_true.
            EXIT.
          ELSE.
            APPEND VALUE #( vbeln = <ls_item_link>-itemb-business_object_id ) TO lt_sales_key.
          ENDIF.
        ENDLOOP.

        IF lv_no_dc_so = abap_false.
          EXIT. " Found valid IC_SO links
        ELSE.
          lv_waiting_time += lv_break_seconds.
          WAIT UP TO lv_break_seconds SECONDS.
        ENDIF.
      ENDIF.
    ENDDO.
    " get link to PO/SO

    IF lt_sales_key IS NOT INITIAL.
      SELECT vbeln, vkorg, vtweg, spart
      FROM vbak INTO TABLE @DATA(lt_vbak)
            FOR ALL ENTRIES IN @lt_sales_key
            WHERE vbeln = @lt_sales_key-vbeln.

      CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
        TABLES
          it_vbak_key           = lt_sales_key
          et_vbap               = lt_vbap
        EXCEPTIONS
          records_not_found     = 1
          records_not_requested = 2
          OTHERS                = 3.
      IF sy-subrc = 0.
        lt_fin_chain = VALUE #( FOR ls_vbap IN lt_vbap
                  ( fin_chain_id = ls_vbap-financial_chain_id
                    block_id = ls_vbap-vcm_chain_element_id ) ).
      ENDIF.
    ENDIF.
    IF lt_fin_chain IS NOT INITIAL.
      SORT lt_fin_chain BY fin_chain_id block_id.
      DELETE ADJACENT DUPLICATES FROM lt_fin_chain COMPARING fin_chain_id block_id.

      SELECT chain_id, sequence_no, plant FROM fcht_chainstep
             FOR ALL ENTRIES IN @lt_fin_chain
             WHERE chain_id = @lt_fin_chain-fin_chain_id
             INTO TABLE @DATA(lt_prec_plants).
    ENDIF.

    " Log attempts and waiting time
    me->mo_run_environment->append_log( |Attempts TO READ VCM item link: { lv_attempts_act }| ).
    me->mo_run_environment->append_log( |Total waiting TIME: { lv_waiting_time } seconds| ).

    IF lv_no_dc_so = abap_false AND lt_vcm_item IS NOT INITIAL.
      LOOP AT lt_vcm_item ASSIGNING <ls_item_link>.
        "For Plant
        IF ls_testdata-vcm_business_object = 'VKORG'.
          READ TABLE lt_vbap ASSIGNING FIELD-SYMBOL(<ls_vbap>)
          WITH KEY vbeln = <ls_item_link>-itemb-business_object_id
          posnr = <ls_item_link>-itemb-business_object_item_id.
          IF sy-subrc = 0.
            DATA(ls_vbak) = VALUE #( lt_vbak[ vbeln = <ls_vbap>-vbeln ] OPTIONAL ).
            "Sequence no will be always '001' for delivering company
            DATA(ls_prec_plant) = VALUE #( lt_prec_plants[ chain_id = <ls_vbap>-financial_chain_id
                                                 sequence_no = '001'  ] OPTIONAL ).
            "Get sales organization for preceding plant
            IF ls_prec_plant-plant IS NOT INITIAL.
              CALL FUNCTION 'T001W_SINGLE_READ'
                EXPORTING
                  t001w_werks   = ls_prec_plant-plant
                IMPORTING
                  wt001w        = ls_plant_data
                EXCEPTIONS
                  not_found     = 1
                  error_message = 2
                  OTHERS        = 3.
            ENDIF.
            " Log comparison
            me->mo_run_environment->append_log( |**Checking the Sales are for DC_SO { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
            me->mo_run_environment->append_log( |Delivering Plant: { ls_prec_plant-plant } |
            & |Identified sales area FOR DC_SO: { ls_vbak-vkorg }/{ ls_vbak-vtweg }/{ ls_vbak-spart } | ).
            "Check the Sales area
            IF ls_plant_data-vkorg = ls_vbak-vkorg AND ls_plant_data-vtweg = ls_vbak-vtweg
              AND ls_plant_data-spart = ls_vbak-spart.
              me->mo_run_environment->append_log( |Success: Sales area match FOR DC_SO { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
              DATA(lv_success) = abap_true.
            ELSE.
              me->mo_run_environment->append_log( |Failure: Sales area mismatch FOR DC_SO { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
            ENDIF.
          ENDIF.
        ELSE.
          me->mo_run_environment->append_log( |**DC_SO: { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
        ENDIF.
        APPEND <ls_item_link>-itemb-business_object_id(10) TO ev_doc_id. "Take first 10 characters
      ENDLOOP.
      " Set final status
      ev_check_status = lv_success.
      ev_exec_status = abap_true.
      DELETE ADJACENT DUPLICATES FROM ev_doc_id.
    ELSE.
      me->mo_run_environment->append_log( 'Error: No delivering company SO(DC_SO) was found' ).
    ENDIF.
  ENDMETHOD.


  METHOD ml_chk_plant_change_ic_po.
    TYPES: BEGIN OF ty_fin_chain,
             fin_chain_id  TYPE fch_financial_chain_id,
             block_id      TYPE vcm_chain_element_id,
             prec_plant_id TYPE fch_sequence_no,
           END OF ty_fin_chain,

           BEGIN OF ty_po_numbers,
             ebeln TYPE ebeln,
             ebelp TYPE ebelp,
           END OF ty_po_numbers,

           ty_po_numbers_tab TYPE STANDARD TABLE OF ty_po_numbers WITH EMPTY KEY.


    DATA:
      ls_testdata   TYPE ty_gs_ptf_or_check_ic_rpts_td,
      ls_plant_data TYPE t001w,
      ls_tvko       TYPE tvko,
      lt_sales_key  TYPE TABLE OF sales_key,
      lt_vbap       TYPE TABLE OF vbap,
      lt_fin_chain  TYPE STANDARD TABLE OF ty_fin_chain,
      lv_statement  TYPE bapi_msg.

    " Get test parameters
    cl_ptf_util=>get_testdata(
              EXPORTING is_step_data = step_data
              IMPORTING es_testdata  = ls_testdata ).

    " Initialize parameters
    DATA(lv_idle_seconds) = ls_testdata-idle_seconds.
    DATA(lv_max_repeats) = ls_testdata-max_repeats.
    DATA(lv_break_seconds) = ls_testdata-break_seconds.
    DATA(lv_attempts_max) = 1 + lv_max_repeats.

    " Log parameters
    me->mo_run_environment->append_log( |PARAMETER: Idle Seconds Before Start: { lv_idle_seconds }| ).
    me->mo_run_environment->append_log( |PARAMETER: Maximum repeats: { lv_max_repeats }| ).
    me->mo_run_environment->append_log( |PARAMETER: Seconds BETWEEN repeats: { lv_break_seconds }| ).

    " Get sales orders from reference steps
    DATA(lt_vbeln) = VALUE cl_ptf_util=>ty_vbeln_tab(
          FOR <lv_ref_step> IN step_data-reference_step
          ( LINES OF me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ) ) ).

    IF lt_vbeln IS INITIAL.
      me->mo_run_environment->append_log( 'Error: Intermediate company SO(IC_SO) not found.' ).
      RETURN.
    ENDIF.

    DATA(lv_vbeln) = lt_vbeln[ 1 ].
    APPEND LINES OF lt_vbeln TO lt_sales_key.
    WAIT UP TO lv_idle_seconds SECONDS.
    " get link to PO/SO

    IF lt_sales_key IS NOT INITIAL.
      SELECT vbeln, vkorg FROM vbak
      INTO TABLE @DATA(lt_vbak)
            FOR ALL ENTRIES IN @lt_sales_key
            WHERE vbeln = @lt_sales_key-vbeln.

      CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
        TABLES
          it_vbak_key           = lt_sales_key
          et_vbap               = lt_vbap
        EXCEPTIONS
          records_not_found     = 1
          records_not_requested = 2
          OTHERS                = 3.
      IF sy-subrc = 0.
        lt_fin_chain = VALUE #( FOR ls_vbap IN lt_vbap
                  ( fin_chain_id = ls_vbap-financial_chain_id
                    block_id = ls_vbap-vcm_chain_element_id
                    prec_plant_id = ls_vbap-vcm_chain_element_id - 1 ) ).
      ENDIF.
    ENDIF.
    IF lt_fin_chain IS NOT INITIAL.
      SORT lt_fin_chain BY fin_chain_id.
      DELETE ADJACENT DUPLICATES FROM lt_fin_chain COMPARING fin_chain_id.

      SELECT chain_id, plant FROM fcht_chainstep
             FOR ALL ENTRIES IN @lt_fin_chain
             WHERE chain_id = @lt_fin_chain-fin_chain_id
             AND sequence_no = @lt_fin_chain-prec_plant_id
             INTO TABLE @DATA(lt_prec_plants).
    ENDIF.
    DATA(lv_waiting_time) = 0.
    DATA(lv_attempts_act) = 0.
    DATA(lt_vcm_item) = VALUE ty_vcm_item_tab( ).
    DATA(lv_no_ic_po) = abap_true.

    DO lv_attempts_max TIMES.
      lv_attempts_act += 1.

      SELECT * FROM vcm_rt_bo_item AS itema
      INNER JOIN vcm_rt_bo_item AS itemb
      ON  itema~value_chain_ins_guid = itemb~value_chain_ins_guid
      AND itema~value_chain_item_guid = itemb~value_chain_item_guid
      LEFT OUTER JOIN vcm_rt_step_ins AS step
      ON itemb~step_ins_guid = step~guid
      LEFT OUTER JOIN vcm_rt_chain_ins AS chain
      ON itemb~value_chain_ins_guid = chain~guid
      INTO TABLE @lt_vcm_item
      WHERE itema~business_object_id = @lv_vbeln
      AND itema~business_object = 'SALES_ORDER'
      AND itema~deleted = @space
      AND itema~cancelled = @space
      AND itemb~deleted = @space
      AND itemb~cancelled = @space
      AND step~step_type = 'IC_PO'
      AND chain~status IN ('C', 'E', 'O', 'PD').

      IF lt_vcm_item IS INITIAL.
        lv_waiting_time += lv_break_seconds.
        WAIT UP TO lv_break_seconds SECONDS.
      ELSE.
        lv_no_ic_po = abap_false.
        LOOP AT lt_vcm_item ASSIGNING FIELD-SYMBOL(<ls_item_link>).
          IF <ls_item_link>-itemb IS INITIAL.
            lv_no_ic_po = abap_true.
            EXIT.
          ENDIF.
        ENDLOOP.

        IF lv_no_ic_po = abap_false.
          EXIT. " Found valid SC_PO links
        ELSE.
          lv_waiting_time += lv_break_seconds.
          WAIT UP TO lv_break_seconds SECONDS.
        ENDIF.
      ENDIF.
    ENDDO.

    " Log attempts and waiting time
    me->mo_run_environment->append_log( |Attempts TO READ VCM item link: { lv_attempts_act }| ).
    me->mo_run_environment->append_log( |Total waiting TIME: { lv_waiting_time } seconds| ).

    IF lv_no_ic_po = abap_false AND lt_vcm_item IS NOT INITIAL.
      " Create PO numbers table from VCM items
      DATA(lt_po_numbers) = VALUE ty_po_numbers_tab( FOR <fs_item> IN lt_vcm_item
            ( ebeln = <fs_item>-itemb-business_object_id
              ebelp = <fs_item>-itemb-business_object_item_id ) ).
      IF lt_po_numbers IS NOT INITIAL.
        SELECT ekko~ebeln, ekko~lifnr, ekko~ekorg, ekko~ekgrp
        FROM ekko INTO TABLE @DATA(lt_ekko)
              FOR ALL ENTRIES IN @lt_po_numbers
              WHERE ekko~ebeln = @lt_po_numbers-ebeln.
      ENDIF.
*
      LOOP AT lt_vcm_item ASSIGNING <ls_item_link>.
        "For Plant
        IF ls_testdata-vcm_business_object = 'WERKS'.
          READ TABLE lt_vbap ASSIGNING FIELD-SYMBOL(<ls_vbap>)
          WITH KEY vbeln = <ls_item_link>-itema-business_object_id
          posnr = <ls_item_link>-itema-business_object_item_id.
          IF sy-subrc = 0.
            DATA(ls_prec_plant) = VALUE #( lt_prec_plants[ chain_id = <ls_vbap>-financial_chain_id  ] OPTIONAL ).
            "Get sales organization for preceding plant
            IF ls_prec_plant-plant IS NOT INITIAL.
              CALL FUNCTION 'T001W_SINGLE_READ'
                EXPORTING
                  t001w_werks   = ls_prec_plant-plant
                IMPORTING
                  wt001w        = ls_plant_data
                EXCEPTIONS
                  not_found     = 1
                  error_message = 2
                  OTHERS        = 3.
              "Get supplier for preceding plant
              IF ls_plant_data-vkorg IS NOT INITIAL.
                cl_sd_dbsel_cust=>so_instance->get_tvko_single(
                EXPORTING
                  iv_vkorg = ls_plant_data-vkorg
                IMPORTING
                  es_tvko  = ls_tvko ).
              ENDIF.
            ENDIF.

            READ TABLE lt_ekko ASSIGNING FIELD-SYMBOL(<ls_ekko>)
            WITH KEY ebeln = <ls_item_link>-itemb-business_object_id.
            " Log comparison
            me->mo_run_environment->append_log( |**Checking the Supplier FOR PO { <ls_item_link>-itema-business_object_id }/{ <ls_item_link>-itema-business_object_item_id }| ).
            me->mo_run_environment->append_log( |**IC_PO: { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
            me->mo_run_environment->append_log( |Delivering Plant: { ls_prec_plant-plant } |
            & |Identified Supplier FOR IC_PO: { <ls_ekko>-lifnr }| ).
            "Check the supplier
            IF ls_tvko-lifnr = <ls_ekko>-lifnr.
              me->mo_run_environment->append_log( |Success: Supplier match FOR IC_PO { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
              DATA(lv_success) = abap_true.
            ELSE.
              me->mo_run_environment->append_log( |Failure: Supplier mismatch FOR IC_PO { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
            ENDIF.
          ENDIF.
          "For Purchasing organization and Purchasing group
          DATA(lv_vkorg) = VALUE #( lt_vbak[ vbeln = <ls_vbap>-vbeln ]-vkorg OPTIONAL ).
          IF lv_vkorg IS NOT INITIAL.
            CLEAR ls_tvko.
            cl_sd_dbsel_cust=>so_instance->get_tvko_single(
            EXPORTING
              iv_vkorg = lv_vkorg
            IMPORTING
              es_tvko  = ls_tvko ).
          ENDIF.
          " Log comparison
          me->mo_run_environment->append_log( |**Checking the purchasing org. FOR PO { <ls_item_link>-itema-business_object_id }/{ <ls_item_link>-itema-business_object_item_id }| ).
          me->mo_run_environment->append_log( |**IC_PO: { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
          me->mo_run_environment->append_log( |Delivering plant: { <ls_vbap>-transit_plant } |
          & |Identified purchase org. FOR IC_PO: { <ls_ekko>-ekorg }| ).
          "check for purchasing organization
          IF ls_tvko-ekorg = <ls_ekko>-ekorg.
            me->mo_run_environment->append_log( |Success: Purchasing org. match FOR IC_PO { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
            lv_success = abap_true.
          ELSE.
            me->mo_run_environment->append_log( |Failure: Purchasing org. mismatch FOR IC_PO { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
          ENDIF.
          "check for purchasing group
          IF ls_tvko-ekgrp = <ls_ekko>-ekgrp.
            me->mo_run_environment->append_log( |Success: Purchasing Group match FOR IC_PO { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
            lv_success = abap_true.
          ELSE.
            me->mo_run_environment->append_log( |Failure: Purchasing Group FOR IC_PO { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
          ENDIF.
        ELSE.
          me->mo_run_environment->append_log( |**IC_PO: { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
        ENDIF.
        APPEND <ls_item_link>-itemb-business_object_id(10) TO ev_doc_id. "Take first 10 characters
      ENDLOOP.
      " Set final status
      ev_check_status = lv_success.
      ev_exec_status = abap_true.
      DELETE ADJACENT DUPLICATES FROM ev_doc_id.
    ELSE.
      me->mo_run_environment->append_log( 'Error: No Intermediate company PO was found(IC_PO) was found' ).
    ENDIF.
  ENDMETHOD.


  METHOD ml_chk_plant_change_ic_so.
    TYPES: BEGIN OF ty_fin_chain,
             vbeln         TYPE vbeln,
             fin_chain_id  TYPE fch_financial_chain_id,
             block_id      TYPE vcm_chain_element_id,
             prec_plant_id TYPE fch_sequence_no,
           END OF ty_fin_chain,

           BEGIN OF ty_po_numbers,
             ebeln TYPE ebeln,
             ebelp TYPE ebelp,
           END OF ty_po_numbers,

           ty_po_numbers_tab TYPE STANDARD TABLE OF ty_po_numbers WITH EMPTY KEY.


    DATA:
      ls_testdata   TYPE ty_gs_ptf_or_check_ic_rpts_td,
      ls_plant_data TYPE t001w,
      ls_tvko       TYPE tvko,
      lt_sales_key  TYPE TABLE OF sales_key,
      lt_vbap       TYPE TABLE OF vbap,
      lt_fin_chain  TYPE STANDARD TABLE OF ty_fin_chain,
      lv_statement  TYPE bapi_msg.

    " Get test parameters
    cl_ptf_util=>get_testdata(
              EXPORTING is_step_data = step_data
              IMPORTING es_testdata  = ls_testdata ).

    " Initialize parameters
    DATA(lv_idle_seconds) = ls_testdata-idle_seconds + 15.
    DATA(lv_max_repeats) = ls_testdata-max_repeats.
    DATA(lv_break_seconds) = ls_testdata-break_seconds.
    DATA(lv_attempts_max) = 1 + lv_max_repeats.

    " Log parameters
    me->mo_run_environment->append_log( |PARAMETER: Idle Seconds Before Start: { lv_idle_seconds }| ).
    me->mo_run_environment->append_log( |PARAMETER: Maximum repeats: { lv_max_repeats }| ).
    me->mo_run_environment->append_log( |PARAMETER: Seconds between repeats: { lv_break_seconds }| ).

    " Get sales orders from reference steps
    DATA(lt_vbeln) = VALUE cl_ptf_util=>ty_vbeln_tab(
          FOR <lv_ref_step> IN step_data-reference_step
          ( LINES OF me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ) ) ).

    IF lt_vbeln IS INITIAL.
      me->mo_run_environment->append_log( 'Error: No Selling Company SO found.' ).
      RETURN.
    ELSE.
      DATA(lv_vbeln) = lt_vbeln[ 1 ].
      APPEND LINES OF lt_vbeln TO lt_sales_key.
    ENDIF.

    SELECT COUNT(*) FROM vbfa FOR ALL ENTRIES IN @lt_sales_key
                    WHERE vbelv = @lt_sales_key-vbeln
                    AND vbtyp_n = 'V'.
    IF sy-subrc <> 0.
      me->mo_run_environment->append_log( 'Error: No Selling Company PO found.' ).
      RETURN.
    ENDIF.

    WAIT UP TO lv_idle_seconds SECONDS.
    DATA(lv_waiting_time) = 0.
    DATA(lv_attempts_act) = 0.
    DATA(lt_vcm_item) = VALUE ty_vcm_item_tab( ).
    DATA(lv_no_ic_so) = abap_true.

    DO lv_attempts_max TIMES.
      lv_attempts_act += 1.

      SELECT * FROM vcm_rt_bo_item AS itema
      INNER JOIN vcm_rt_bo_item AS itemb
      ON  itema~value_chain_ins_guid = itemb~value_chain_ins_guid
      AND itema~value_chain_item_guid = itemb~value_chain_item_guid
      LEFT OUTER JOIN vcm_rt_step_ins AS step
      ON itemb~step_ins_guid = step~guid
      LEFT OUTER JOIN vcm_rt_chain_ins AS chain
      ON itemb~value_chain_ins_guid = chain~guid
      INTO TABLE @lt_vcm_item
      WHERE itema~business_object_id = @lv_vbeln
      AND itema~business_object = 'SALES_ORDER'
      AND itema~deleted = @space
      AND itema~cancelled = @space
      AND itemb~deleted = @space
      AND itemb~cancelled = @space
      AND step~step_type = 'IC_SO'
      AND chain~status IN ('C', 'E', 'O', 'PD').

      IF lt_vcm_item IS INITIAL.
        lv_waiting_time += lv_break_seconds.
        WAIT UP TO lv_break_seconds SECONDS.
      ELSE.
        lv_no_ic_so = abap_false.
        LOOP AT lt_vcm_item ASSIGNING FIELD-SYMBOL(<ls_item_link>).
          IF <ls_item_link>-itemb IS INITIAL.
            lv_no_ic_so = abap_true.
            EXIT.
          ELSE.
            APPEND VALUE #( vbeln = <ls_item_link>-itemb-business_object_id ) TO lt_sales_key.
          ENDIF.
        ENDLOOP.

        IF lv_no_ic_so = abap_false.
          EXIT. " Found valid IC_SO links
        ELSE.
          lv_waiting_time += lv_break_seconds.
          WAIT UP TO lv_break_seconds SECONDS.
        ENDIF.
      ENDIF.
    ENDDO.
    " get link to PO/SO

    IF lt_sales_key IS NOT INITIAL.
      SELECT vbeln, vkorg, vtweg, spart
      FROM vbak INTO TABLE @DATA(lt_vbak)
            FOR ALL ENTRIES IN @lt_sales_key
            WHERE vbeln = @lt_sales_key-vbeln.

      CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
        TABLES
          it_vbak_key           = lt_sales_key
          et_vbap               = lt_vbap
        EXCEPTIONS
          records_not_found     = 1
          records_not_requested = 2
          OTHERS                = 3.
      IF sy-subrc = 0.
        lt_fin_chain = VALUE #( FOR ls_vbap IN lt_vbap
                  ( vbeln =  ls_vbap-vbeln
                    fin_chain_id = ls_vbap-financial_chain_id
                    block_id = ls_vbap-vcm_chain_element_id
                    prec_plant_id = ls_vbap-vcm_chain_element_id - 1 ) ).
      ENDIF.
    ENDIF.
    IF lt_fin_chain IS NOT INITIAL.
      SORT lt_fin_chain BY vbeln fin_chain_id block_id.
      DELETE ADJACENT DUPLICATES FROM lt_fin_chain COMPARING vbeln fin_chain_id block_id.

      SELECT chain_id, sequence_no, plant
             FROM fcht_chainstep
             FOR ALL ENTRIES IN @lt_fin_chain
             WHERE chain_id = @lt_fin_chain-fin_chain_id
             AND sequence_no = @lt_fin_chain-prec_plant_id
             INTO TABLE @DATA(lt_prec_plants).
    ENDIF.

    READ TABLE lt_fin_chain INTO DATA(ls_sc_so) INDEX 1.
    IF sy-subrc = 0.
      DATA(ls_prec_plant) = VALUE #( lt_prec_plants[ chain_id = ls_sc_so-fin_chain_id
                                           sequence_no = ls_sc_so-prec_plant_id  ] OPTIONAL ).
      "Get sales organization for preceding plant
      IF ls_prec_plant-plant IS NOT INITIAL.
        CALL FUNCTION 'T001W_SINGLE_READ'
          EXPORTING
            t001w_werks   = ls_prec_plant-plant
          IMPORTING
            wt001w        = ls_plant_data
          EXCEPTIONS
            not_found     = 1
            error_message = 2
            OTHERS        = 3.
      ENDIF.
    ENDIF.

    " Log attempts and waiting time
    me->mo_run_environment->append_log( |Attempts TO READ VCM item link: { lv_attempts_act }| ).
    me->mo_run_environment->append_log( |Total waiting TIME: { lv_waiting_time } seconds| ).

    IF lv_no_ic_so = abap_false AND lt_vcm_item IS NOT INITIAL.
      LOOP AT lt_vcm_item ASSIGNING <ls_item_link>.
        "For Plant
        IF ls_testdata-vcm_business_object = 'VKORG'.
          READ TABLE lt_vbap ASSIGNING FIELD-SYMBOL(<ls_vbap>)
          WITH KEY vbeln = <ls_item_link>-itemb-business_object_id
          posnr = <ls_item_link>-itemb-business_object_item_id.
          IF sy-subrc = 0.
            DATA(ls_vbak) = VALUE #( lt_vbak[ vbeln = <ls_vbap>-vbeln ] OPTIONAL ).
            " Log comparison
            me->mo_run_environment->append_log( |**Checking the Sales are for IC_SO { <ls_item_link>-itema-business_object_id }/{ <ls_item_link>-itema-business_object_item_id }| ).
            me->mo_run_environment->append_log( |Intermediate Plant: { ls_prec_plant-plant } |
            & |Identified sales area FOR IC_SO: { ls_vbak-vkorg }/{ ls_vbak-vtweg }/{ ls_vbak-spart } | ).
            "Check the Sales area
            IF ls_plant_data-vkorg = ls_vbak-vkorg AND ls_plant_data-vtweg = ls_vbak-vtweg
              AND ls_plant_data-spart = ls_vbak-spart.
              me->mo_run_environment->append_log( |Success: Sales area match FOR IC_SO { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
              DATA(lv_success) = abap_true.
            ELSE.
              me->mo_run_environment->append_log( |Failure: Sales area mismatch FOR IC_SO { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
            ENDIF.
          ENDIF.
        ELSE.
          me->mo_run_environment->append_log( |**IC_SO: { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
        ENDIF.
        APPEND <ls_item_link>-itemb-business_object_id(10) TO ev_doc_id. "Take first 10 characters
      ENDLOOP.
      " Set final status
      ev_check_status = lv_success.
      ev_exec_status = abap_true.
      DELETE ADJACENT DUPLICATES FROM ev_doc_id.
    ELSE.
      me->mo_run_environment->append_log( 'Error: No intermediate company SO(IC_SO) was found' ).
    ENDIF.
  ENDMETHOD.


METHOD ml_chk_plant_change_sc_po.

  TYPES: BEGIN OF ty_fin_chain,
           fin_chain_id  TYPE fch_financial_chain_id,
           block_id      TYPE vcm_chain_element_id,
           prec_plant_id TYPE fch_sequence_no,
         END OF ty_fin_chain,

         BEGIN OF ty_po_numbers,
           ebeln TYPE ebeln,
           ebelp TYPE ebelp,
         END OF ty_po_numbers,

         ty_po_numbers_tab TYPE STANDARD TABLE OF ty_po_numbers WITH EMPTY KEY.


  DATA:
    ls_testdata   TYPE ty_gs_ptf_or_check_ic_rpts_td,
    ls_plant_data TYPE t001w,
    ls_tvko       TYPE tvko,
    lt_sales_key  TYPE TABLE OF sales_key,
    lt_vbap       TYPE TABLE OF vbap,
    lt_fin_chain  TYPE STANDARD TABLE OF ty_fin_chain,
    lv_statement  TYPE bapi_msg.

  " Get test parameters
  cl_ptf_util=>get_testdata(
            EXPORTING is_step_data = step_data
            IMPORTING es_testdata  = ls_testdata ).

  " Initialize parameters
  DATA(lv_idle_seconds) = ls_testdata-idle_seconds.
  DATA(lv_max_repeats) = ls_testdata-max_repeats.
  DATA(lv_break_seconds) = ls_testdata-break_seconds.
  DATA(lv_attempts_max) = 1 + lv_max_repeats.

  " Log parameters
  me->mo_run_environment->append_log( |PARAMETER: Idle Seconds Before Start: { lv_idle_seconds }| ).
  me->mo_run_environment->append_log( |PARAMETER: Maximum repeats: { lv_max_repeats }| ).
  me->mo_run_environment->append_log( |PARAMETER: Seconds BETWEEN repeats: { lv_break_seconds }| ).

  " Get sales orders from reference steps
  DATA(lt_vbeln) = VALUE cl_ptf_util=>ty_vbeln_tab(
        FOR <lv_ref_step> IN step_data-reference_step
        ( LINES OF me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ) ) ).

  IF lt_vbeln IS INITIAL.
    me->mo_run_environment->append_log( 'Error: No Selling company salesorder(SC_SO) found.' ).
    RETURN.
  ENDIF.

  DATA(lv_vbeln) = lt_vbeln[ 1 ].
  APPEND LINES OF lt_vbeln TO lt_sales_key.

  WAIT UP TO lv_idle_seconds SECONDS.
  " get link to PO/SO

  IF lt_sales_key IS NOT INITIAL.
    SELECT vbeln, vkorg FROM vbak
    INTO TABLE @DATA(lt_vbak)
          FOR ALL ENTRIES IN @lt_sales_key
          WHERE vbeln = @lt_sales_key-vbeln.

    CALL FUNCTION 'SD_VBAP_ARRAY_READ_VBELN'
      TABLES
        it_vbak_key           = lt_sales_key
        et_vbap               = lt_vbap
      EXCEPTIONS
        records_not_found     = 1
        records_not_requested = 2
        OTHERS                = 3.
    IF sy-subrc = 0.
      lt_fin_chain = VALUE #( FOR ls_vbap IN lt_vbap
                ( fin_chain_id = ls_vbap-financial_chain_id
                  block_id = ls_vbap-vcm_chain_element_id
                  prec_plant_id = ls_vbap-vcm_chain_element_id - 1 ) ).
    ENDIF.
  ENDIF.
  IF lt_fin_chain IS NOT INITIAL.
    SORT lt_fin_chain BY fin_chain_id.
    DELETE ADJACENT DUPLICATES FROM lt_fin_chain COMPARING fin_chain_id.

    SELECT chain_id, plant FROM fcht_chainstep
           FOR ALL ENTRIES IN @lt_fin_chain
           WHERE chain_id = @lt_fin_chain-fin_chain_id
           AND sequence_no = @lt_fin_chain-prec_plant_id
           INTO TABLE @DATA(lt_prec_plants).
  ENDIF.


  DATA(lv_waiting_time) = 0.
  DATA(lv_attempts_act) = 0.
  DATA(lt_vcm_item) = VALUE ty_vcm_item_tab( ).
  DATA(lv_no_sc_po) = abap_true.

  DO lv_attempts_max TIMES.
    lv_attempts_act += 1.

    SELECT * FROM vcm_rt_bo_item AS itema
    INNER JOIN vcm_rt_bo_item AS itemb
    ON  itema~value_chain_ins_guid = itemb~value_chain_ins_guid
    AND itema~value_chain_item_guid = itemb~value_chain_item_guid
    LEFT OUTER JOIN vcm_rt_step_ins AS step
    ON itemb~step_ins_guid = step~guid
    LEFT OUTER JOIN vcm_rt_chain_ins AS chain
    ON itemb~value_chain_ins_guid = chain~guid
    INTO TABLE @lt_vcm_item
    WHERE itema~business_object_id = @lv_vbeln
    AND itema~business_object = 'SALES_ORDER'
    AND itema~deleted = @space
    AND itema~cancelled = @space
    AND itemb~deleted = @space
    AND itemb~cancelled = @space
    AND step~step_type = 'SC_PO'
    AND chain~status IN ('C', 'E', 'O', 'PD').

    IF lt_vcm_item IS INITIAL.
      lv_waiting_time += lv_break_seconds.
      WAIT UP TO lv_break_seconds SECONDS.
    ELSE.
      lv_no_sc_po = abap_false.
      LOOP AT lt_vcm_item ASSIGNING FIELD-SYMBOL(<ls_item_link>).
        IF <ls_item_link>-itemb IS INITIAL.
          lv_no_sc_po = abap_true.
          EXIT.
        ENDIF.
      ENDLOOP.

      IF lv_no_sc_po = abap_false.
        EXIT. " Found valid SC_PO links
      ELSE.
        lv_waiting_time += lv_break_seconds.
        WAIT UP TO lv_break_seconds SECONDS.
      ENDIF.
    ENDIF.
  ENDDO.

  " Log attempts and waiting time
  me->mo_run_environment->append_log( |Attempts TO READ VCM item link: { lv_attempts_act }| ).
  me->mo_run_environment->append_log( |Total waiting TIME: { lv_waiting_time } seconds| ).

  IF lv_no_sc_po = abap_false AND lt_vcm_item IS NOT INITIAL.
    " Create PO numbers table from VCM items
    DATA(lt_po_numbers) = VALUE ty_po_numbers_tab( FOR <fs_item> IN lt_vcm_item
          ( ebeln = <fs_item>-itemb-business_object_id
          ebelp = <fs_item>-itemb-business_object_item_id ) ).
    IF lt_po_numbers IS NOT INITIAL.
      SELECT ekko~ebeln, ekko~lifnr, ekko~ekorg, ekko~ekgrp
      FROM ekko INTO TABLE @DATA(lt_ekko)
            FOR ALL ENTRIES IN @lt_po_numbers
            WHERE ekko~ebeln = @lt_po_numbers-ebeln.
    ENDIF.
*
    LOOP AT lt_vcm_item ASSIGNING <ls_item_link>.
      "For Plant
      IF ls_testdata-vcm_business_object = 'WERKS'.
        READ TABLE lt_vbap ASSIGNING FIELD-SYMBOL(<ls_vbap>)
        WITH KEY vbeln = <ls_item_link>-itema-business_object_id
        posnr = <ls_item_link>-itema-business_object_item_id.
        IF sy-subrc = 0.
          DATA(ls_prec_plant) = VALUE #( lt_prec_plants[ chain_id = <ls_vbap>-financial_chain_id  ] OPTIONAL ).
          "Get sales organization for preceding plant
          IF ls_prec_plant-plant IS NOT INITIAL.
            CALL FUNCTION 'T001W_SINGLE_READ'
              EXPORTING
                t001w_werks   = ls_prec_plant-plant
              IMPORTING
                wt001w        = ls_plant_data
              EXCEPTIONS
                not_found     = 1
                error_message = 2
                OTHERS        = 3.
            "Get supplier for preceding plant
            IF ls_plant_data-vkorg IS NOT INITIAL.
              cl_sd_dbsel_cust=>so_instance->get_tvko_single(
              EXPORTING
                iv_vkorg = ls_plant_data-vkorg
              IMPORTING
                es_tvko  = ls_tvko ).
            ENDIF.
          ENDIF.

          READ TABLE lt_ekko ASSIGNING FIELD-SYMBOL(<ls_ekko>)
          WITH KEY ebeln = <ls_item_link>-itemb-business_object_id.
          " Log comparison
          me->mo_run_environment->append_log( |**Checking the Supplier for SC_PO { <ls_item_link>-itema-business_object_id }/{ <ls_item_link>-itema-business_object_item_id }| ).
          me->mo_run_environment->append_log( |**SC_PO: { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
          me->mo_run_environment->append_log( |Intermediate Plant: { ls_prec_plant-plant } |
          & |Identified Supplier FOR SC_PO: { <ls_ekko>-lifnr }| ).
          "Check the supplier
          IF ls_tvko-lifnr = <ls_ekko>-lifnr.
            me->mo_run_environment->append_log( |Success: Supplier match FOR SC_PO { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
            DATA(lv_success) = abap_true.
          ELSE.
            me->mo_run_environment->append_log( |Failure: Supplier mismatch FOR SC_PO { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
          ENDIF.
        ENDIF.

        "For Purchasing organization and Purchasing group
        DATA(lv_vkorg) = VALUE #( lt_vbak[ vbeln = <ls_vbap>-vbeln ]-vkorg OPTIONAL ).
        IF lv_vkorg IS NOT INITIAL.
          CLEAR ls_tvko.
          cl_sd_dbsel_cust=>so_instance->get_tvko_single(
          EXPORTING
            iv_vkorg = lv_vkorg
          IMPORTING
            es_tvko  = ls_tvko ).
        ENDIF.
        " Log comparison
        me->mo_run_environment->append_log( |**Checking the purchasing org. FOR PO { <ls_item_link>-itema-business_object_id }/{ <ls_item_link>-itema-business_object_item_id }| ).
        me->mo_run_environment->append_log( |**SC_PO: { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
        me->mo_run_environment->append_log( |Selling company plant/Transit plant: { <ls_vbap>-transit_plant } |
        & |Identified purchase org. FOR SC_PO: { <ls_ekko>-ekorg }| ).
        "check for purchasing organization
        IF ls_tvko-ekorg = <ls_ekko>-ekorg.
          me->mo_run_environment->append_log( |Success: Purchasing org. match FOR SC_PO { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
          lv_success = abap_true.
        ELSE.
          me->mo_run_environment->append_log( |Failure: Purchasing org. mismatch FOR SC_PO { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
        ENDIF..
        "check for purchasing group
        IF ls_tvko-ekgrp = <ls_ekko>-ekgrp.
          me->mo_run_environment->append_log( |Success: Purchasing Group match FOR SC_PO { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
          lv_success = abap_true.
        ELSE.
          me->mo_run_environment->append_log( |Failure: Purchasing Group FOR SC_PO { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
        ENDIF.
      ELSE.
        me->mo_run_environment->append_log( |**SC_PO: { <ls_item_link>-itemb-business_object_id }/{ <ls_item_link>-itemb-business_object_item_id }| ).
      ENDIF.
      APPEND <ls_item_link>-itemb-business_object_id(10) TO ev_doc_id. "Take first 10 characters
    ENDLOOP.
    " Set final status
    ev_check_status = lv_success.
    ev_exec_status = abap_true.
    DELETE ADJACENT DUPLICATES FROM ev_doc_id.
  ELSE.
    me->mo_run_environment->append_log( 'Error: No Selling company PO was found(SC_PO) was found' ).
  ENDIF.
ENDMETHOD.


  METHOD ml_chk_plant_chg_after_obd.
    DATA: ls_chance_tdc TYPE ty_gs_i_ptf_or_ch_td,
          bool_rembb     TYPE abap_bool,
          lt_return      TYPE cl_ptf_util=>gt_ptf_return_tab,
          lt_vbeln       TYPE cl_ptf_util=>ty_vbeln_tab,
          lv_ptf_tdc     TYPE etobj_name,
          ls_return      TYPE bapiret2.
    CONSTANTS c_e TYPE char1 VALUE 'E'.

*****************************************************************************
* First Step: get tdcv

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_chance_tdc
    ).

*****************************************************************************
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<prestep_numbr>).
      DATA(ls_step_precessor) = me->mo_run_environment->get_step_data( iv_step_number = <prestep_numbr> ).
      MOVE ls_step_precessor-document_id TO lt_vbeln.
      LOOP AT lt_vbeln  ASSIGNING FIELD-SYMBOL(<vbeln>).
*****************************************************************************
* Check if the billing block has to removed.
        DATA: lv_ptf_key TYPE ptfkey.
        MOVE <vbeln>-vbeln TO lv_ptf_key.

        IF ls_chance_tdc-billing_block = '00'.

          me->remove_billing_block( iv_order_number = lv_ptf_key ).

          ev_exec_status = abap_false.
          cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

        ELSEIF ls_chance_tdc-billing_block IS NOT INITIAL.
          me->add_billing_block(
            EXPORTING
              iv_order_number = lv_ptf_key
              iv_chance_tdc   = ls_chance_tdc
            RECEIVING
              ev_test_success = ev_exec_status
          ).

          cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
        ENDIF.
*****************************************************************************
* check if and where the item list had to change

        LOOP AT ls_chance_tdc-item_list ASSIGNING FIELD-SYMBOL(<ls_item_list>).
          IF <ls_item_list>-material_id IS NOT INITIAL
          OR <ls_item_list>-posnr IS NOT INITIAL
          OR <ls_item_list>-quantity IS NOT INITIAL OR
            <ls_item_list>-werks IS NOT INITIAL.
            DATA(b_change_itemlist) = abap_true.
            EXIT.
          ENDIF.
        ENDLOOP.

        IF b_change_itemlist = abap_true.

          CLEAR lv_ptf_key.
          MOVE <vbeln>-vbeln TO lv_ptf_key.
          me->change_item_list(
            EXPORTING
              iv_order_number = lv_ptf_key
              iv_chance_tdc   = ls_chance_tdc
            IMPORTING
              ev_test_success = ev_exec_status
              et_return       = lt_return
          ).
          cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
        ENDIF.
        ls_return = VALUE #( lt_return[ type = c_e ] OPTIONAL ).
        IF sy-subrc = 0.
          ev_check_status = abap_true.
          ev_exec_status = abap_true.
        ENDIF.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


  METHOD ml_chk_ship_to_change.
    TYPES: BEGIN OF ty_sales_key,
             vbeln TYPE vbeln_va,
             posnr TYPE posnr_va,
             step  TYPE char10,
           END OF ty_sales_key,

           BEGIN OF ty_so,
             vbeln TYPE vbeln_va,
             posnr TYPE posnr_va,
             matnr TYPE matnr,
             kunnr TYPE kunnr,
             step  TYPE char10,
           END OF ty_so,

           BEGIN OF ty_business_obj,
             vbeln TYPE vcm_business_object_id,
             posnr TYPE vcm_business_object_item_id,
           END OF ty_business_obj,

           BEGIN OF ty_po_key,
             ebeln TYPE ebeln,
             ebelp TYPE ebelp,
             step  TYPE char10,
           END OF ty_po_key,

           BEGIN OF ty_po,
             ebeln TYPE ebeln,
             ebelp TYPE ebelp,
             matnr TYPE matnr,
             kunnr TYPE kunnr,
             step  TYPE char10,
           END OF ty_po.

    TYPES: tt_sales_key TYPE STANDARD TABLE OF ty_sales_key,
           tt_po_key    TYPE STANDARD TABLE OF ty_po_key.

    DATA:ls_testdata  TYPE ty_gs_ptf_or_check_ic_rpts_td,
         lt_bus_obj   TYPE STANDARD TABLE OF ty_business_obj,
         lt_sales_key TYPE STANDARD TABLE OF ty_sales_key,
         lt_po_key    TYPE STANDARD TABLE OF ty_po_key,
         lt_so        TYPE STANDARD TABLE OF ty_so,
         lt_po        TYPE STANDARD TABLE OF ty_po,
         lv_vbeln     TYPE vbeln_va.
    CONSTANTS: c_scpo TYPE char10 VALUE 'SC_PO',
               C_icpo TYPE char10 VALUE 'IC_PO',
               c_icso TYPE char10 VALUE 'IC_SO',
               c_dcso TYPE char10 VALUE 'DC_SO'.
    " Get sales orders from reference steps
    DATA(lt_vbeln) = VALUE cl_ptf_util=>ty_vbeln_tab(
          FOR <lv_ref_step> IN is_step_data-reference_step
          ( LINES OF me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ) ) ).

    IF lt_vbeln IS INITIAL.
      me->mo_run_environment->append_log( 'Error: No Selling company sales order(SC_SO) found.' ).
      RETURN.
    ELSE.
      lv_vbeln = lt_vbeln[ 1 ].
      SELECT vbeln, posnr, vcm_chain_uuid, financial_chain_id
             FROM vbap INTO TABLE @DATA(lt_vbap)
             WHERE vbeln = @lv_vbeln.
      IF sy-subrc = 0.
        lt_bus_obj = VALUE #( FOR ls_vbap IN lt_vbap
                               ( vbeln = ls_vbap-vbeln
                                 posnr = ls_vbap-posnr ) ).
      ENDIF.
    ENDIF.
    " select
    SELECT  business_object_id, business_object_item_id,
            value_chain_type, financial_chain_id,step_type
            FROM vcm_rt_chain_ins AS chain
            INNER JOIN vcm_rt_bo_item AS item
            ON chain~guid = item~value_chain_ins_guid
            INNER JOIN vcm_rt_step_ins AS step
            ON step~guid = item~step_ins_guid
            INTO TABLE @DATA(lt_vcm_item)
            FOR ALL ENTRIES IN @lt_bus_obj
            WHERE chain~triggering_object_id = @lt_bus_obj-vbeln
            AND step~step_type IN ('SC_SO','SC_PO', 'IC_SO','IC_PO', 'DC_SO' ).
    IF sy-subrc = 0.
      lt_sales_key = VALUE #( FOR ls_vcm_item IN lt_vcm_item
                                   WHERE ( step_type = 'IC_SO' OR
                                           step_type = 'DC_SO' )
                               ( vbeln = ls_vcm_item-business_object_id
                                 posnr = ls_vcm_item-business_object_item_id
                                 step = ls_vcm_item-step_type ) ).
      lt_po_key  = VALUE #( FOR ls_vcm_item IN lt_vcm_item
                                   WHERE ( step_type = 'IC_PO' OR
                                           step_type = 'SC_PO' )
                               ( ebeln = ls_vcm_item-business_object_id
                                 ebelp = ls_vcm_item-business_object_item_id
                                 step = ls_vcm_item-step_type ) ).

    ENDIF.

    IF lt_sales_key IS NOT INITIAL.
      SELECT p~vbeln, p~posnr, p~kunnr, i~matnr
             FROM vbpa AS p INNER JOIN vbap AS i
             ON p~vbeln = i~vbeln
             AND p~posnr = i~posnr
             INTO TABLE @DATA(lt_partner)
             FOR ALL ENTRIES IN @lt_sales_key
             WHERE p~vbeln = @lt_sales_key-vbeln
             AND p~posnr = @lt_sales_key-posnr
             AND parvw = 'WE'.
      IF sy-subrc = 0.
        lt_so = CORRESPONDING #( lt_partner ).
      ENDIF.
    ENDIF.
    IF lt_po_key IS NOT INITIAL.
      SELECT ebeln, ebelp, matnr, kunnr FROM ekpo
             INTO TABLE @DATA(lt_shipto)
             FOR ALL ENTRIES IN @lt_po_key
             WHERE ebeln = @lt_po_key-ebeln
             AND   ebelp = @lt_po_key-ebelp.
      IF sy-subrc = 0.
        lt_po = CORRESPONDING #( lt_shipto ).
      ENDIF.
    ENDIF.
    LOOP AT lt_so ASSIGNING FIELD-SYMBOL(<ls_so>).
      DATA(ls_sales_key) = VALUE #( lt_sales_key[ vbeln = <ls_so>-vbeln posnr = <ls_so>-posnr ] OPTIONAL ).
      IF ls_sales_key-step IS NOT INITIAL.
        <ls_so>-step = ls_sales_key-step.
      ENDIF.
    ENDLOOP.
    LOOP AT lt_po ASSIGNING FIELD-SYMBOL(<ls_po>).
      DATA(ls_po_key) = VALUE #( lt_po_key[ ebeln = <ls_po>-ebeln ebelp = <ls_po>-ebelp ] OPTIONAL ).
      IF ls_po_key-step IS NOT INITIAL.
        <ls_po>-step = ls_po_key-step.
      ENDIF.
    ENDLOOP.
    me->mo_run_environment->append_log( |**Checking Ship-to-party update**| ).

    LOOP AT lt_vbap ASSIGNING FIELD-SYMBOL(<ls_vbap>).

      DATA(ls_partner) = VALUE #( lt_partner[ vbeln =  <ls_vbap>-vbeln  posnr = <ls_vbap>-posnr ] OPTIONAL ).
      IF ls_partner-kunnr IS NOT INITIAL.
        me->mo_run_environment->append_log( |Ship-to-party for SO { <ls_vbap>-vbeln }/{ <ls_vbap>-posnr } is { ls_partner-kunnr }| ).
      ENDIF.
      "Check SC_PO
      DATA(ls_scpo) = VALUE #( lt_po[ matnr = ls_partner-matnr step = c_scpo ] OPTIONAL ).
      IF ls_scpo-kunnr = ls_partner-kunnr.
        me->mo_run_environment->append_log( |Success: Ship-to/Customer match FOR SC_PO { ls_scpo-ebeln }/{ ls_scpo-ebelp } | ).
        DATA(lv_success) = abap_true.
      ELSE.
        me->mo_run_environment->append_log( |Failure: Ship-to/Customer mismatch FOR SC_PO { ls_scpo-ebeln }/{ ls_scpo-ebelp } | ).
      ENDIF.
      "Check IC_SO
      DATA(ls_icso) = VALUE #( lt_so[ matnr = ls_partner-matnr step = c_icso ] OPTIONAL ).
      IF ls_icso-kunnr = ls_partner-kunnr.
        me->mo_run_environment->append_log( |Success: Ship-to/Customer match FOR IC_SO { ls_icso-vbeln }/{ ls_icso-posnr } | ).
        lv_success = abap_true.
      ELSE.
        me->mo_run_environment->append_log( |Failure: Ship-to/Customer mismatch FOR IC_SO { ls_icso-vbeln }/{ ls_icso-posnr } | ).
      ENDIF.
      "Check IC_PO
      DATA(ls_icpo) = VALUE #( lt_po[ matnr = ls_partner-matnr step = c_icpo ] OPTIONAL ).
      IF ls_icpo-kunnr = ls_partner-kunnr.
        me->mo_run_environment->append_log( |Success: Ship-to/Customer match FOR IC_PO { ls_icpo-ebeln }/{ ls_icpo-ebelp } | ).
        lv_success = abap_true.
      ELSE.
        me->mo_run_environment->append_log( |Failure: Ship-to/Customer mismatch FOR IC_PO { ls_icpo-ebeln }/{ ls_icpo-ebelp } | ).
      ENDIF.
      "Check DC_SO
      DATA(ls_dcso) = VALUE #( lt_so[ matnr = ls_partner-matnr step = c_dcso ] OPTIONAL ).
      IF ls_dcso-kunnr = ls_partner-kunnr.
        me->mo_run_environment->append_log( |Success: Ship-to/Customer match FOR DC_SO { ls_dcso-vbeln }/{ ls_dcso-posnr } | ).
        lv_success = abap_true.
      ELSE.
        me->mo_run_environment->append_log( |Failure: Ship-to/Customer mismatch FOR DC_SO { ls_dcso-vbeln }/{ ls_dcso-posnr } | ).
      ENDIF.
    ENDLOOP.
    ev_check_status = lv_success.
    ev_exec_status =  abap_true.
  ENDMETHOD.


  method ml_subitem_create_obd.
    data: ls_sales_order   type bapidlvreftosalesorder,
          lt_sales_orders  type table of bapidlvreftosalesorder,
          lt_vbap          type table of bapisditbos , "standard table of vbap,
          lt_created_items type standard table of bapidlvitemcreated with default key.

    data: lt_return          type table of bapiret2,
          lv_delivery_number type vbeln.
*****************************************************************************
*Step: Create Outbound Delivery and commit
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_step>).
  DATA(ls_pred) = me->mo_run_environment->get_step_data(
                    iv_step_number = <ls_step> ).
  LOOP AT ls_pred-document_id INTO DATA(ls_vbeln).
     DATA(lv_vbeln) = conv VBELN_VA( ls_vbeln ).
    CALL FUNCTION 'BAPI_SALESORDER_GETDETAILBOS'
      EXPORTING
        salesdocument = lv_vbeln
      TABLES
        orderitems    = lt_vbap.

    "Pick only subitems (hg_lv_item not initial) and build sales order refs
    lt_sales_orders = VALUE #( BASE lt_sales_orders
                               FOR ls_vbap IN lt_vbap
                               WHERE ( hg_lv_item IS NOT INITIAL )
                               ( ref_doc  = lv_vbeln
                                 ref_item = ls_vbap-itm_number ) ).
  ENDLOOP.
ENDLOOP.

    call function 'BAPI_OUTB_DELIVERY_CREATE_SLS'
      importing
        delivery          = lv_delivery_number
      tables
        sales_order_items = lt_sales_orders
        created_items     = lt_created_items
        return            = lt_return.

    loop at lt_return assigning field-symbol(<ls_msg>).
      me->mo_run_environment->append_log( iv_log_statement = |{ <ls_msg>-message }| ).
    endloop.

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
*****************************************************************************
* Check whether Delivery exists
    data: lv_ptf_key type ptfkey.
    move lv_delivery_number to lv_ptf_key.
    If lv_ptf_key is NOT INITIAL .
    ev_execution_status = abap_true.
    append lv_ptf_key to ev_document_id.
    endif.

  endmethod.


  METHOD ml_successor_doc_deletion.
    TYPES: BEGIN OF ty_sales_key,
             vbeln TYPE vbeln_va,
             posnr TYPE posnr_va,
           END OF ty_sales_key,

           BEGIN OF ty_business_obj,
             vbeln TYPE vcm_business_object_id,
             posnr TYPE vcm_business_object_item_id,
           END OF ty_business_obj,

           BEGIN OF ty_po_key,
             ebeln TYPE ebeln,
             ebelp TYPE ebelp,
           END OF ty_po_key.

    TYPES: tt_sales_key TYPE STANDARD TABLE OF ty_sales_key,
           tt_po_key    TYPE STANDARD TABLE OF ty_po_key.

    DATA:ls_testdata  TYPE ty_gs_ptf_or_check_ic_rpts_td,
         lt_bus_obj   TYPE STANDARD TABLE OF ty_business_obj,
         lt_sales_key TYPE STANDARD TABLE OF ty_sales_key,
         lt_po_key    TYPE STANDARD TABLE OF ty_po_key,
         lv_vbeln     TYPE vbeln_va,
         lv_fin_chain TYPE fch_financial_chain_id,
         lv_guid      TYPE sysuuid_x16.
    " Get test parameters
    cl_ptf_util=>get_testdata(
              EXPORTING is_step_data = step_data
              IMPORTING es_testdata  = ls_testdata ).

    " Get sales orders from reference steps
    DATA(lt_vbeln) = VALUE cl_ptf_util=>ty_vbeln_tab(
          FOR <lv_ref_step> IN step_data-reference_step
          ( LINES OF me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ) ) ).

    IF lt_vbeln IS INITIAL.
      me->mo_run_environment->append_log( 'Error: No Selling company sales order(SC_SO) found.' ).
      RETURN.
    ELSE.
      lv_vbeln = lt_vbeln[ 1 ].
      SELECT vbeln, posnr, vcm_chain_uuid, financial_chain_id
             FROM vbap INTO TABLE @DATA(lt_vbap)
             WHERE vbeln = @lv_vbeln.
      IF sy-subrc = 0.
        lt_bus_obj = VALUE #( FOR ls_vbap IN lt_vbap
                               ( vbeln = ls_vbap-vbeln
                                 posnr = ls_vbap-posnr ) ).
      ENDIF.
    ENDIF.
    " select
    SELECT  chain~guid,business_object_id, business_object_item_id,
            value_chain_type, financial_chain_id,step_type
            FROM vcm_rt_chain_ins AS chain
            INNER JOIN vcm_rt_bo_item AS item
            ON chain~guid = item~value_chain_ins_guid
            INNER JOIN vcm_rt_step_ins AS step
            ON step~guid = item~step_ins_guid
            INTO TABLE @DATA(lt_vcm_item)
            FOR ALL ENTRIES IN @lt_bus_obj
            WHERE chain~triggering_object_id = @lt_bus_obj-vbeln
            AND chain~status = 'C'
            AND step~step_type IN ('SC_SO','SC_PO', 'IC_SO','IC_PO', 'DC_SO' ).
    IF sy-subrc = 0.
      SORT lt_vcm_item BY guid.

      lt_sales_key = VALUE #( FOR ls_vcm_item IN lt_vcm_item
                                   WHERE ( step_type = 'IC_SO' OR
                                           step_type = 'DC_SO' )
                               ( vbeln = ls_vcm_item-business_object_id
                                 posnr = ls_vcm_item-business_object_item_id ) ).
      lt_po_key  = VALUE #( FOR ls_vcm_item IN lt_vcm_item
                                   WHERE ( step_type = 'IC_PO' OR
                                           step_type = 'SC_PO' )
                               ( ebeln = ls_vcm_item-business_object_id
                                 ebelp = ls_vcm_item-business_object_item_id ) ).

    ENDIF.

    IF lt_sales_key IS NOT INITIAL.
      SELECT vbeln, posnr, abgru FROM vbap
             INTO TABLE @DATA(lt_rej_so)
             FOR ALL ENTRIES IN @lt_sales_key
             WHERE vbeln = @lt_sales_key-vbeln
             AND posnr = @lt_sales_key-posnr.
    ENDIF.
    IF lt_po_key IS NOT INITIAL.
      SELECT ebeln, ebelp, loekz FROM ekpo
             INTO TABLE @DATA(lt_rej_po)
             FOR ALL ENTRIES IN @lt_po_key
             WHERE ebeln = @lt_po_key-ebeln
             AND   ebelp = @lt_po_key-ebelp.
    ENDIF.

    LOOP AT lt_vcm_item ASSIGNING FIELD-SYMBOL(<ls_vcm_item>).
      IF <ls_vcm_item>-financial_chain_id <> lv_fin_chain.
        me->mo_run_environment->append_log( |**Previous value chain type for { <ls_vcm_item>-business_object_id }/{ <ls_vcm_item>-business_object_item_id }| &&
                                 | is { <ls_vcm_item>-value_chain_type } | && | ** Financial chain id { <ls_vcm_item>-financial_chain_id ALPHA = OUT }| ).
      ENDIF.

      CASE <ls_vcm_item>-step_type.
        WHEN 'SC_SO'.
          DATA(ls_so) = VALUE #( lt_vbap[ vbeln = <ls_vcm_item>-business_object_id
                                          posnr = <ls_vcm_item>-business_object_item_id ] OPTIONAL ).
          me->mo_run_environment->append_log( |**Current Financial chain id { <ls_vcm_item>-financial_chain_id ALPHA = OUT }| ).
        WHEN 'SC_PO'.
          me->mo_run_environment->append_log( |**Checking the selling company PO { <ls_vcm_item>-business_object_id }/{ <ls_vcm_item>-business_object_item_id }| ).
          DATA(ls_rej_po) = VALUE #( lt_rej_po[ ebeln =  <ls_vcm_item>-business_object_id
                                       ebelp = <ls_vcm_item>-business_object_item_id ] OPTIONAL ).
          IF ls_rej_po-loekz IS NOT INITIAL.
            me->mo_run_environment->append_log( |**Success! Deletion indicator is set| ).
            DATA(lv_success) =  abap_true.
          ENDIF.
        WHEN 'IC_SO'.
          me->mo_run_environment->append_log( |**Checking the intermediate company SO { <ls_vcm_item>-business_object_id  }/{ <ls_vcm_item>-business_object_item_id }| ).
          DATA(ls_rej_so) = VALUE #( lt_rej_so[ vbeln =  <ls_vcm_item>-business_object_id
                                       posnr = <ls_vcm_item>-business_object_item_id ] OPTIONAL ).
          IF ls_rej_so-abgru IS NOT INITIAL.
            me->mo_run_environment->append_log( |**Success! Reason for rejection is set| ).
            lv_success = abap_true.
          ENDIF.
        WHEN 'IC_PO'.
          me->mo_run_environment->append_log( |**Checking the intermediate company PO { <ls_vcm_item>-business_object_id }/{ <ls_vcm_item>-business_object_item_id }| ).
          ls_rej_po = VALUE #( lt_rej_po[ ebeln =  <ls_vcm_item>-business_object_id
                                         ebelp = <ls_vcm_item>-business_object_item_id ] OPTIONAL ).
          IF ls_rej_po-loekz IS NOT INITIAL.
            me->mo_run_environment->append_log( |**Success! Deletion indicator is set| ).
            lv_success = abap_true.
          ENDIF.
        WHEN 'DC_SO'.
          me->mo_run_environment->append_log( |**Checking the delivering company SO { <ls_vcm_item>-business_object_id }/{ <ls_vcm_item>-business_object_item_id }| ).
          ls_rej_so = VALUE #( lt_rej_so[ vbeln =  <ls_vcm_item>-business_object_id
                                       posnr = <ls_vcm_item>-business_object_item_id ] OPTIONAL ).
          IF ls_rej_so-abgru IS NOT INITIAL.
            me->mo_run_environment->append_log( |**Success! Reason for rejection is set| ).
            lv_success =  abap_true.
          ENDIF.
        WHEN OTHERS.
      ENDCASE.
      lv_fin_chain =  <ls_vcm_item>-financial_chain_id.
    ENDLOOP.
    ev_check_status = lv_success.
    ev_exec_status =  abap_true.
  ENDMETHOD.
ENDCLASS.
