CLASS cl_ptf_sd_util DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
******************************************************
** Structure for Schedule List
      BEGIN OF ty_gs_sched_list_td,
*vbeln type vbeln_va,
        posnr         TYPE posnr_va,
        etenr         TYPE etenr,
        ettyp         TYPE ettyp,
        edatu         TYPE edatu,
        delivery_days TYPE i,
        wmeng         TYPE wmeng,
      END OF ty_gs_sched_list_td .
    TYPES:
      ty_gt_sched_list_td TYPE STANDARD TABLE OF ty_gs_sched_list_td WITH KEY etenr .
    TYPES:
** Structure for Item List
      BEGIN OF ty_gs_item_list_td,
        material_id            TYPE matnr,
        quantity               TYPE dzmeng,
        posnr                  TYPE posnr_va,
        fkdat                  TYPE fkdat,
        werks                  TYPE werks_d,
        store_loc              TYPE lgort_d,
        item_category          TYPE pstyv,
        payment_terms          TYPE dzterm,
        payment_method         TYPE dzlsch,
        schedule_line_category TYPE ettyp,
        profit_center          TYPE prctr,
        fkk_conacct            TYPE corr_vkont_kk,
        sales_unit             TYPE vrkme,
        unddlv_tol             TYPE untto,
        po_itm_no              TYPE posex,
        schedule_lines         TYPE ty_gt_sched_list_td,
        batch                  type charg_d,
      END OF ty_gs_item_list_td .
    TYPES:
** Structure for extensibility field
      BEGIN OF ty_gs_ext_field_td,
        name           TYPE string,
        type           TYPE string,
        data_type      TYPE string,
        expected_input TYPE string,
      END OF ty_gs_ext_field_td .
    TYPES:
** Table for extensibility field
      ty_gt_ext_field_td      TYPE STANDARD TABLE OF ty_gs_ext_field_td WITH NON-UNIQUE KEY name .
    TYPES:
** Table for Item List
      lty_sales_conditions_in TYPE STANDARD TABLE OF bapicond  WITH DEFAULT KEY .
    TYPES:
      ty_gt_item_list_td      TYPE STANDARD TABLE OF ty_gs_item_list_td WITH NON-UNIQUE KEY posnr .
    TYPES:
      ty_order_partners       TYPE STANDARD TABLE OF bapiparnr WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_i_ptf_ext_field_check_td,
        ext_fields TYPE ty_gt_ext_field_td,
      END OF ty_gs_i_ptf_ext_field_check_td .
    TYPES:
      ty_bapisdtext TYPE STANDARD TABLE OF bapisdtext WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_check_expected_quantity,
        quantity TYPE i,
      END OF ty_check_expected_quantity .
    TYPES:
** (SD specific) types for PTF mocking
* * Types for mocking modes F,I,D - table TVFK
      BEGIN OF ty_gs_mock_tvfk_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,     "allows for different tables with same type to use the same parameter
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF tvfk WITH DEFAULT KEY,
      END OF ty_gs_mock_tvfk_td .
    TYPES:
          "typing tdc parameter
      ty_gt_mock_tvfk_td TYPE STANDARD TABLE OF ty_gs_mock_tvfk_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_msku_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,     "allows for different tables with same type to use the same parameter
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF msku WITH DEFAULT KEY,
      END OF ty_gs_mock_msku_td .
    TYPES:
      "typing tdc parameter
      ty_gt_mock_msku_td TYPE STANDARD TABLE OF ty_gs_mock_msku_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_fot_txa_t030k_td,
        dbtable   TYPE tabname16,     "allows for different tables with same type to use the same parameter
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF fot_txa_t030k WITH DEFAULT KEY,
      END OF ty_gs_fot_txa_t030k_td .
    TYPES:
      ty_gt_fot_txa_t030k_td TYPE STANDARD TABLE OF ty_gs_fot_txa_t030k_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_tvap_td,
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF tvap WITH DEFAULT KEY,
      END OF ty_gs_mock_tvap_td .
    TYPES:
      ty_gt_mock_tvap_td TYPE STANDARD TABLE OF ty_gs_mock_tvap_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_tvcpf_td,
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF tvcpf WITH DEFAULT KEY,
      END OF ty_gs_mock_tvcpf_td .
    TYPES:
      ty_gt_mock_tvcpf_td TYPE STANDARD TABLE OF ty_gs_mock_tvcpf_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_swelcfg_td,
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF swelcfg WITH DEFAULT KEY,
      END OF ty_gs_mock_swelcfg_td .
    TYPES:
      ty_gt_mock_swelcfg_td TYPE STANDARD TABLE OF ty_gs_mock_swelcfg_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_swelcf_td,
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF swelcf WITH DEFAULT KEY,
      END OF ty_gs_mock_swelcf_td .
    TYPES:
      ty_gt_mock_swelcf_td TYPE STANDARD TABLE OF ty_gs_mock_swelcf_td WITH DEFAULT KEY .
    TYPES:
*     Types for other mocking modes (TVFKT, 3 modes)
      BEGIN OF ty_gs_mock_tvfkt_td,   "  OBSOLETE
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF tvfkt WITH DEFAULT KEY,
      END OF ty_gs_mock_tvfkt_td .
    TYPES:
          "typing tdc parameter
      ty_gt_mock_tvfkt_td TYPE STANDARD TABLE OF ty_gs_mock_tvfkt_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_vbrk_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF t683s WITH DEFAULT KEY,
      END OF ty_gs_mock_vbrk_td .
    TYPES:
      ty_gt_mock_vbrk_td TYPE STANDARD TABLE OF ty_gs_mock_vbrk_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_t683s_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF t683s WITH DEFAULT KEY,
      END OF ty_gs_mock_t683s_td .
    TYPES:
      ty_gt_mock_t683s_td TYPE STANDARD TABLE OF ty_gs_mock_t683s_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_t683_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF t683 WITH DEFAULT KEY,
      END OF ty_gs_mock_t683_td .
    TYPES:
      ty_gt_mock_t683_td TYPE STANDARD TABLE OF ty_gs_mock_t683_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_sdnrrangeprefixt_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF sdnrrangeprefixt WITH DEFAULT KEY,
      END OF ty_gs_mock_sdnrrangeprefixt_td .
    TYPES:
      BEGIN OF ty_gs_mock_sdnrrangeprefix_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF sdnrrangeprefix WITH DEFAULT KEY,
      END OF ty_gs_mock_sdnrrangeprefix_td .
    TYPES:
      BEGIN OF ty_gs_mock_kna1_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF kna1 WITH DEFAULT KEY,
      END OF ty_gs_mock_kna1_td .
    TYPES:
      BEGIN OF ty_gs_mock_knas_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF knas WITH DEFAULT KEY,
      END OF ty_gs_mock_knas_td .
    TYPES:
      ty_gt_mock_knas_td             TYPE STANDARD TABLE OF ty_gs_mock_knas_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_sls_mrg_field_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF sls_mrg_field WITH DEFAULT KEY,
      END OF ty_gs_mock_sls_mrg_field_td .
    TYPES:
      ty_gt_mock_sls_mrg_field_td     TYPE STANDARD TABLE OF ty_gs_mock_sls_mrg_field_td WITH DEFAULT KEY.
    TYPES:
      "Customer Master Tax Indicator
      BEGIN OF ty_gs_mock_knvi_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF knvi WITH DEFAULT KEY,
      END OF ty_gs_mock_knvi_td .
    TYPES:
      ty_gt_mock_knvi_td             TYPE STANDARD TABLE OF ty_gs_mock_knvi_td WITH DEFAULT KEY .
    TYPES:
      ty_gt_mock_sdnrrangeprefix_td  TYPE STANDARD TABLE OF ty_gs_mock_sdnrrangeprefix_td WITH DEFAULT KEY .
    TYPES:
      ty_gt_mock_sdnrrangeprefixt_td TYPE STANDARD TABLE OF ty_gs_mock_sdnrrangeprefixt_td WITH DEFAULT KEY .
    TYPES:
      ty_gt_mock_kna1_td             TYPE STANDARD TABLE OF ty_gs_mock_kna1_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_tvko_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF tvko WITH DEFAULT KEY,
      END OF ty_gs_mock_tvko_td .
    TYPES:
      ty_gt_mock_tvko_td     TYPE STANDARD TABLE OF ty_gs_mock_tvko_td WITH DEFAULT KEY.
    TYPES:
* Configurable Parameters and Formulas (CPF)
      BEGIN OF ty_gs_mock_cpf_paramcat_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF cpfc_paramcat WITH DEFAULT KEY,
      END OF ty_gs_mock_cpf_paramcat_td .
    TYPES:
      ty_gt_mock_cpf_paramcat_td TYPE STANDARD TABLE OF ty_gs_mock_cpf_paramcat_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_cpf_formula_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF cpfc_formula WITH DEFAULT KEY,
      END OF ty_gs_mock_cpf_formula_td .
    TYPES:
      ty_gt_mock_cpf_formula_td TYPE STANDARD TABLE OF ty_gs_mock_cpf_formula_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_cpf_formulapar_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF cpfc_formulapar WITH DEFAULT KEY,
      END OF ty_gs_mock_cpf_formulapar_td .
    TYPES:
      ty_gt_mock_cpf_formulapar_td TYPE STANDARD TABLE OF ty_gs_mock_cpf_formulapar_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_cpf_formulatask_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF cpfc_formulatask WITH DEFAULT KEY,
      END OF ty_gs_mock_cpf_formulatask_td .
    TYPES:
      ty_gt_mock_cpf_formulatask_td TYPE STANDARD TABLE OF ty_gs_mock_cpf_formulatask_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_cpf_dect_rows_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF cpfc_dect_rows WITH DEFAULT KEY,
      END OF ty_gs_mock_cpf_dect_rows_td .
    TYPES:
      ty_gt_mock_cpf_dect_rows_td TYPE STANDARD TABLE OF ty_gs_mock_cpf_dect_rows_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_cpf_dect_setup_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF cpfc_dect_setup WITH DEFAULT KEY,
      END OF ty_gs_mock_cpf_dect_setup_td .
    TYPES:
      ty_gt_mock_cpf_dect_setup_td TYPE STANDARD TABLE OF ty_gs_mock_cpf_dect_setup_td WITH DEFAULT KEY .
    TYPES:
* VOFM
      BEGIN OF ty_gs_mock_vofm_rtn_nmbr_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF vofmc_rtn_nmbr WITH DEFAULT KEY,
      END OF ty_gs_mock_vofm_rtn_nmbr_td .
    TYPES:
      ty_gt_mock_vofm_rtn_nmbr_td TYPE STANDARD TABLE OF ty_gs_mock_vofm_rtn_nmbr_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_vofm_rtn_assg_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF vofmc_rtn_assg WITH DEFAULT KEY,
      END OF ty_gs_mock_vofm_rtn_assg_td .
    TYPES:
      ty_gt_mock_vofm_rtn_assg_td TYPE STANDARD TABLE OF ty_gs_mock_vofm_rtn_assg_td WITH DEFAULT KEY .
    TYPES:
* Number ranges
      BEGIN OF ty_gs_mock_nriv_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF nriv WITH DEFAULT KEY,
      END OF ty_gs_mock_nriv_td .
    TYPES:
      ty_gt_mock_nriv_td TYPE STANDARD TABLE OF ty_gs_mock_nriv_td WITH DEFAULT KEY .
    TYPES:
      " PBD approvals
      BEGIN OF ty_gs_mock_sdapmaprr_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF sdapmaprr WITH DEFAULT KEY,
      END OF ty_gs_mock_sdapmaprr_td .
    TYPES:
      ty_gt_mock_sdapmaprr_td TYPE STANDARD TABLE OF ty_gs_mock_sdapmaprr_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_sdapmaprrcat_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF sdapmaprrcat WITH DEFAULT KEY,
      END OF ty_gs_mock_sdapmaprrcat_td .
    TYPES:
      ty_gt_mock_sdapmaprrcat_td TYPE STANDARD TABLE OF ty_gs_mock_sdapmaprrcat_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_tvkwz_td,
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF tvkwz WITH DEFAULT KEY,
      END OF ty_gs_mock_tvkwz_td .
    TYPES:
      ty_gt_mock_tvkwz_td TYPE STANDARD TABLE OF ty_gs_mock_tvkwz_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_mmpur_c_bus_sys_td,
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF mmpur_c_bus_sys WITH DEFAULT KEY,
      END OF ty_gs_mock_mmpur_c_bus_sys_td .
    TYPES:
      ty_gt_mock_mmpur_c_bus_sys_td TYPE STANDARD TABLE OF ty_gs_mock_mmpur_c_bus_sys_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_tpaer,
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF tpaer WITH DEFAULT KEY,
      END OF ty_gs_mock_tpaer .
    TYPES:
      ty_gt_mock_tpaer TYPE STANDARD TABLE OF ty_gs_mock_tpaer WITH DEFAULT KEY .
    TYPES:
      "t691f mock
      BEGIN OF ty_gs_mock_t691f_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF t691f WITH DEFAULT KEY,
      END OF ty_gs_mock_t691f_td .
    TYPES:
      ty_gt_mock_t691f_td TYPE STANDARD TABLE OF ty_gs_mock_t691f_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_bilocc_aggrule_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF bilocc_aggrule WITH DEFAULT KEY,
      END OF ty_gs_mock_bilocc_aggrule_td .
    TYPES:
      ty_gt_mock_bilocc_aggrule_td TYPE STANDARD TABLE OF ty_gs_mock_bilocc_aggrule_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_hero_active,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF fot_hxf_act WITH DEFAULT KEY,
      END OF ty_gs_mock_hero_active.
    TYPES:
      ty_gt_mock_hero_active TYPE STANDARD TABLE OF ty_gs_mock_hero_active WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_a4cc_td,
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF a4cc WITH DEFAULT KEY,
      END OF ty_gs_mock_a4cc_td.
    TYPES:
      ty_gt_mock_a4cc_td TYPE STANDARD TABLE OF ty_gs_mock_a4cc_td WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_gs_mock_flxint_td,
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF glo_bilfi_flxint WITH DEFAULT KEY,
      END OF ty_gs_mock_flxint_td.
    TYPES:
      ty_gt_mock_flxint_td TYPE STANDARD TABLE OF ty_gs_mock_flxint_td WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_gs_mock_vofmc_rtn_nmbr_td,
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF vofmc_rtn_nmbr WITH DEFAULT KEY,
      END OF ty_gs_mock_vofmc_rtn_nmbr_td.
    TYPES:
      ty_gt_mock_vofmc_rtn_nmbr_td TYPE STANDARD TABLE OF ty_gs_mock_vofmc_rtn_nmbr_td WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_gs_mock_vofmc_rtn_assg_td,
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF vofmc_rtn_assg WITH DEFAULT KEY,
      END OF ty_gs_mock_vofmc_rtn_assg_td.
    TYPES:
      ty_gt_mock_vofmc_rtn_assg_td TYPE STANDARD TABLE OF ty_gs_mock_vofmc_rtn_assg_td WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_gs_mock_ukm_is_active_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,     "allows for different tables with same type to use the same parameter
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF ukm_is_active WITH DEFAULT KEY,
      END OF ty_gs_mock_ukm_is_active_td .
    TYPES:
          "typing tdc parameter
      ty_gt_mock_ukm_is_active_td TYPE STANDARD TABLE OF ty_gs_mock_ukm_is_active_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_TMS_C_SLS_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF TMS_C_SLS WITH DEFAULT KEY,
      END OF ty_gs_mock_TMS_C_SLS_td .
    TYPES:
      ty_gt_mock_TMS_C_SLS_td     TYPE STANDARD TABLE OF ty_gs_mock_TMS_C_SLS_td WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_gs_mock_TMS_C_PUR_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF TMS_C_PUR WITH DEFAULT KEY,
      END OF ty_gs_mock_TMS_C_PUR_td .
    TYPES:
      ty_gt_mock_TMS_C_PUR_td     TYPE STANDARD TABLE OF ty_gs_mock_TMS_C_PUR_td WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_gs_mock_tcurr_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF tcurr WITH DEFAULT KEY,
      END OF ty_gs_mock_tcurr_td .
    TYPES:
      ty_gt_mock_tcurr_td TYPE STANDARD TABLE OF ty_gs_mock_tcurr_td WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_gs_mock_sapslltccact_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF /sapsll/tccact WITH DEFAULT KEY,
      END OF ty_gs_mock_sapslltccact_td .
    TYPES:
      ty_gt_mock_sapslltccact_td     TYPE STANDARD TABLE OF ty_gs_mock_sapslltccact_td WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_gs_mock_sapsllt606g_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF /sapsll/t606g WITH DEFAULT KEY,
      END OF ty_gs_mock_sapsllt606g_td .
    TYPES:
      ty_gt_mock_sapsllt606g_td     TYPE STANDARD TABLE OF ty_gs_mock_sapsllt606g_td WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_gs_mock_sapsllalrg01_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF /sapsll/alrg01 WITH DEFAULT KEY,
      END OF ty_gs_mock_sapsllalrg01_td .
    TYPES:
      ty_gt_mock_sapsllalrg01_td     TYPE STANDARD TABLE OF ty_gs_mock_sapsllalrg01_td WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_gs_mock_sapsllmaritc_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF /sapsll/maritc WITH DEFAULT KEY,
      END OF ty_gs_mock_sapsllmaritc_td .
    TYPES:
      ty_gt_mock_sapsllmaritc_td     TYPE STANDARD TABLE OF ty_gs_mock_sapsllmaritc_td WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_gs_mock_sapsllmarlrg_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF /sapsll/marlrg WITH DEFAULT KEY,
      END OF ty_gs_mock_sapsllmarlrg_td .
    TYPES:
      ty_gt_mock_sapsllmarlrg_td     TYPE STANDARD TABLE OF ty_gs_mock_sapsllmarlrg_td WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_gs_mock_sapsllccctry_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF /sapsll/ccctry WITH DEFAULT KEY,
      END OF ty_gs_mock_sapsllccctry_td .
    TYPES:
      ty_gt_mock_sapsllccctry_td     TYPE STANDARD TABLE OF ty_gs_mock_sapsllccctry_td WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_gs_mock_sapslltccsls_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF /sapsll/tccsls WITH DEFAULT KEY,
      END OF ty_gs_mock_sapslltccsls_td .
    TYPES:
      ty_gt_mock_sapslltccsls_td     TYPE STANDARD TABLE OF ty_gs_mock_sapslltccsls_td WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_gs_mock_sapslltpagr_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF /sapsll/tpagr WITH DEFAULT KEY,
      END OF ty_gs_mock_sapslltpagr_td .
    TYPES:
      ty_gt_mock_sapslltpagr_td     TYPE STANDARD TABLE OF ty_gs_mock_sapslltpagr_td WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_gs_mock_tvak_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF tvak WITH DEFAULT KEY,
      END OF ty_gs_mock_tvak_td .
    TYPES:
      ty_gt_mock_tvak_td     TYPE STANDARD TABLE OF ty_gs_mock_tvak_td WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_gs_mock_knvv_td,  "structure not to be used directly in TDC parameters
        dbtable   TYPE tabname16,
        mock_mode TYPE c LENGTH 1,
        content   TYPE STANDARD TABLE OF knvv WITH DEFAULT KEY,
      END OF ty_gs_mock_knvv_td .
    TYPES:
      ty_gt_mock_knvv_td     TYPE STANDARD TABLE OF ty_gs_mock_knvv_td WITH DEFAULT KEY.

    CONSTANTS c_num_range_object_sd TYPE string VALUE 'RV_BELEG' ##NO_TEXT.
    CONSTANTS c_num_range_interval_bd TYPE i VALUE 19 ##NO_TEXT.

    CLASS-METHODS is_a_billing_doc
      IMPORTING
        !document_number        TYPE vbeln
      RETURNING
        VALUE(is_a_billing_doc) TYPE abap_bool .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS CL_PTF_SD_UTIL IMPLEMENTATION.


  METHOD is_a_billing_doc.
    SELECT SINGLE vbtyp FROM vbrk WHERE vbeln = @document_number INTO @DATA(check).

    IF sy-subrc IS NOT INITIAL.
      is_a_billing_doc = abap_false.
      RETURN.
    ENDIF.

    is_a_billing_doc = cl_sd_doc_category_util=>is_any_billing_document( iv_vbtyp = check ).

  ENDMETHOD.
ENDCLASS.
