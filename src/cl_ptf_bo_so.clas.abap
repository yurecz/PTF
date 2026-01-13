class CL_PTF_BO_SO definition
  public
  inheriting from CL_PTF_BO
  final
  create public .

public section.

  types:
    ty_gt_code_line type standard table of string with default key .
  types:
    begin of ty_gs_dynamic_code,
        code        type string,
        description type string,
      end of ty_gs_dynamic_code .
  types:
    ty_gt_dynamic_code type standard table of ty_gs_dynamic_code with default key .
  types:
    begin of ty_gs_component_cmpif,
        component_id   type if_sd_sls_comp_types=>tcd_comp_id,
        adapter_class  type seoclsname,
        impl_interface type seoclsname,
        impl_class     type seoclsname,
      end of ty_gs_component_cmpif .
  types:
    ty_gt_component_cmpif type standard table of ty_gs_component_cmpif with default key .
  types:
    vbak_tab       type standard table of vbak with default key .
  types:
    vbak_check_tab type standard table of sdbil_tst_vbak_check with default key .
  types:
    begin of ty_gs_relative_date,
        date_field_name type string,
        offset_in_days  type i,
      end of ty_gs_relative_date .
  types:
    ty_gt_relative_date type standard table of ty_gs_relative_date with default key .
  types:
    begin of ty_gs_field,
        name type string,
      end of ty_gs_field .
  types:
    ty_gt_field type standard table of ty_gs_field with default key .
  types:
    begin of ty_gs_sline,
        unconditional_take_over_fields type ty_gt_field,
        relative_dates                 type ty_gt_relative_date,
        delete_entry                   type abap_bool.
        include type tds_goal_so_sline as goal_data.
    types:
      end of ty_gs_sline .
  types:
    ty_gt_sline type standard table of ty_gs_sline with default key .
  types:
    begin of ty_gs_party,
        unconditional_take_over_fields type ty_gt_field.
        include type tds_goal_basic_party as goal_data.
    types:
      end of ty_gs_party .
  types:
    ty_gt_party type standard table of ty_gs_party with default key .
  types:
    begin of ty_gs_text,
        unconditional_take_over_fields type ty_gt_field.
        include type tds_goal_basic_text as goal_data.
    types:
      end of ty_gs_text .
  types:
    ty_gt_text type standard table of ty_gs_text with default key .
  types:
    begin of ty_gs_pricecondition,
        unconditional_take_over_fields type ty_gt_field.
        include type tds_goal_basic_cond as goal_data.
    types:
      end of ty_gs_pricecondition .
  types:
    ty_gt_pricecondition type standard table of ty_gs_pricecondition with default key .
  types:
    begin of ty_gs_epay,
        unconditional_take_over_fields type ty_gt_field.
        include type tds_goal_sdoc_epay as goal_data.
    types:
      end of ty_gs_epay .
  types:
    ty_gt_epay type standard table of ty_gs_epay with default key .
  types:
    begin of ty_gs_item_itr,
        emcst       type /sapsll/emcst,
        slcst       type /sapsll/slcst,
        total_lccst type tdd_total_lccst.
        include type tds_goal_so_item as goal_data.
    types:
      end of ty_gs_item_itr .
  types:
    ty_gt_item_itr type standard table of ty_gs_item_itr with default key .
  types:
    begin of ty_gs_data_container_item.
        include type if_goal_sdoc_data_cont=>tcs_item.
    types:
      end of ty_gs_data_container_item .
  types:
    begin of ty_gs_item,
        unconditional_take_over_fields type ty_gt_field,
        relative_dates                 type ty_gt_relative_date,
        delete_entry                   type abap_bool,
        sline_list                     type ty_gt_sline,
        party_list                     type ty_gt_party,
        text_list                      type ty_gt_text,
        pricecondition_list            type ty_gt_pricecondition,
        wbs_relative_number            type int2.
        include type tds_goal_so_item as goal_data.
    types:
        data_container_item            type ty_gs_data_container_item.
    types:
    end of ty_gs_item .
  types:
    ty_gt_item type standard table of ty_gs_item with default key .
  types:
    begin of ty_gs_item_with_ref_conf,
        ref_item_for_ref_config type posnr,
        ref_config_ctrl         type char1.
        include type ty_gs_item .
    types:
      end of ty_gs_item_with_ref_conf .
  types:
    ty_gt_item_with_ref_conf type standard table of ty_gs_item_with_ref_conf with default key .
  types:
    begin of ty_gs_head,
        unconditional_take_over_fields type ty_gt_field,
        relative_dates                 type ty_gt_relative_date,
        party_list                     type ty_gt_party,
        text_list                      type ty_gt_text,
        pricecondition_list            type ty_gt_pricecondition,
        epay_list                      type ty_gt_epay.
        include type tds_goal_so_head as goal_data.
    types:
      end of ty_gs_head .
  types:
    begin of ty_gs_i_ptf_so_cr_td,
        goal_bo_id               type tabname,
        vcm_run_sync             type abap_bool,
        head                     type ty_gs_head,
        item_list                type ty_gt_item,
        dynamic_testdata_changes type ty_gt_dynamic_code,
        goal_scenario_ids        type tdt_scenario_id,
        components_cmpif         type ty_gt_component_cmpif,
      end of ty_gs_i_ptf_so_cr_td .
  types:
    begin of ty_gs_i_ptf_so_cr_td_ext_stat,
        apm_status type char40,
      end of ty_gs_i_ptf_so_cr_td_ext_stat .
  types:
    begin of   ty_gs_i_ptf_so_cr_ref_conf_td,
        goal_bo_id   type tabname,
        vcm_run_sync type abap_bool,
        head         type ty_gs_head,
        item_list    type ty_gt_item_with_ref_conf,
      end of ty_gs_i_ptf_so_cr_ref_conf_td .
  types:
    begin of ty_gs_i_ptf_so_appr_action_id,
        action type if_sd_apm_approval=>tcd_approval_action,
      end of ty_gs_i_ptf_so_appr_action_id .
  types:
    begin of ty_gs_ptf_sd_check_apm,
        vbak       type vbak_tab,
        vbak_check type vbak_check_tab,
      end of ty_gs_ptf_sd_check_apm .
  types:
    begin of ty_gs_i_ptf_so_sdapmaprr_td,
        dbtable   type tabname16,
        mock_mode type c length 1,
        content   type standard table of sdapmaprr with default key,
      end of ty_gs_i_ptf_so_sdapmaprr_td .
  types:
    ty_gt_i_ptf_so_sdapmaprr_td type standard table of ty_gs_i_ptf_so_sdapmaprr_td with default key .
  types:
    begin of ty_gs_i_ptf_so_sdapmaprrcat_td,
        dbtable   type tabname16,
        mock_mode type c length 1,
        content   type standard table of sdapmaprrcat with default key,
      end of ty_gs_i_ptf_so_sdapmaprrcat_td .
  types:
    ty_gt_i_ptf_so_sdapmaprrcat_td type standard table of ty_gs_i_ptf_so_sdapmaprrcat_td with default key .
  types:
    begin of ty_gs_ptf_so_check_rpts_td,
        idle_seconds        type i,  " Idle Seconds Before Start
        max_repeats         type i,  " Maximum Number of Repeats
        break_seconds       type i,  " Break Seconds Between Repeats
        vcm_business_object type vcm_business_object,
        number_of_objects   type i,
        partner_function    type parvw,
      end of ty_gs_ptf_so_check_rpts_td .
  types:
    begin of ty_s_vbep_check,
        mandt                          type char1,
        vbeln                          type char1,
        posnr                          type char1,
        etenr                          type char1,
        ettyp                          type char1,
        lfrel                          type char1,
        edatu                          type char1,
        ezeit                          type char1,
        wmeng                          type char1,
        bmeng                          type char1,
        vrkme                          type char1,
        lmeng                          type char1,
        meins                          type char1,
        bddat                          type char1,
        bdart                          type char1,
        plart                          type char1,
        vbele                          type char1,
        posne                          type char1,
        etene                          type char1,
        rsdat                          type char1,
        idnnr                          type char1,
        banfn                          type char1,
        bsart                          type char1,
        bstyp                          type char1,
        wepos                          type char1,
        repos                          type char1,
        lrgdt                          type char1,
        prgrs                          type char1,
        tddat                          type char1,
        mbdat                          type char1,
        lddat                          type char1,
        wadat                          type char1,
        cmeng                          type char1,
        lifsp                          type char1,
        grstr                          type char1,
        abart                          type char1,
        abruf                          type char1,
        roms1                          type char1,
        roms2                          type char1,
        roms3                          type char1,
        romei                          type char1,
        rform                          type char1,
        umvkz                          type char1,
        umvkn                          type char1,
        verfp                          type char1,
        bwart                          type char1,
        bnfpo                          type char1,
        etart                          type char1,
        aufnr                          type char1,
        plnum                          type char1,
        sernr                          type char1,
        aeskd                          type char1,
        abges                          type char1,
        mbuhr                          type char1,
        tduhr                          type char1,
        lduhr                          type char1,
        wauhr                          type char1,
        aulwe                          type char1,
        handoverdate                   type char1,
        handovertime                   type char1,
        delivery_date_type_rule        type char1,
        dlvqty_bu                      type char1,
        dlvqty_su                      type char1,
        ocdqty_bu                      type char1,
        ocdqty_su                      type char1,
        ordqty_bu                      type char1,
        ordqty_su                      type char1,
        crea_dlvdate                   type char1,
        req_dlvdate                    type char1,
        bedar                          type char1,
        _dataaging                     type char1,
        waerk                          type char1,
        odn_amount                     type char1,
        handle                         type char1,
        lccst                          type char1,
        rrqqty_bu                      type char1,
        crqqty_bu                      type char1,
        dummy_slsdocschedl_incl_eew_ps type char1,
        fsh_ralloc_qty                 type char1,
        fsh_os_id                      type char1,
        fsh_pqr_rc                     type char1,
        mbdat_drs                      type char1,
      end of ty_s_vbep_check .
  types:
    begin of ty_s_vbap_vcm,
        ic_relevant      type xfeld,
        sfsvsit_relevant type xfeld.
        include          type vbap.
    types:
      end of ty_s_vbap_vcm .
  types:
    begin of ty_s_vcm_vbap_check,
        vcm_chain_uuid     type xfeld,
        vcm_chain_category type xfeld.
        include            type sdbil_tst_vbap_check.
    types:
      end of ty_s_vcm_vbap_check .
  types:
    begin of ty_gs_ptf_so_check_vcm_td,
        vbak       type vbak_tab,
        vbak_check type vbak_check_tab,
        vbap       type standard table of ty_s_vbap_vcm with default key,
        vbap_check type standard table of ty_s_vcm_vbap_check with default key,
        vbep       type standard table of vbep with default key,
        vbep_check type standard table of ty_s_vbep_check with default key,
      end of ty_gs_ptf_so_check_vcm_td .
  types:
    begin of ty_gs_ptf_so_select_td,
        werks type vbap-werks,
      end   of ty_gs_ptf_so_select_td .
  types:
    begin of ty_s_vcmhm_chain,
        triggering_object_id         type vcm_business_object_id,
        value_chain_type             type vcm_value_chain_type,
        step_type                    type vcm_step_type_id,
        valuechainstepinstancestatus type vcm_value_chain_step_status,
        business_object_item_id      type vcm_business_object_item_id,
        deleted                      type vcm_boolean,
        cancelled                    type vcm_boolean,
        predecessor_item_id          type vcm_business_object_item_id,
      end of ty_s_vcmhm_chain .
  types:
    begin of ty_s_vcmhm_chain_check,
        value_chain_type             type char1,
        step_type                    type char1,
        valuechainstepinstancestatus type char1,
        business_object_item_id      type char1,
        deleted                      type char1,
        cancelled                    type char1,
        predecessor_item_id          type char1,
      end of ty_s_vcmhm_chain_check .
  types:
    begin of ty_gs_ptf_so_check_vcmchain_td,
        check_not_exists    type char1,
        only_active_entries type char1,
        vcmhm_chain         type standard table of ty_s_vcmhm_chain with default key,
        vcmhm_chain_check   type standard table of ty_s_vcmhm_chain_check with default key,
      end of ty_gs_ptf_so_check_vcmchain_td .
  types:
    ltty_vcmhm_chain type standard table of ty_s_vcmhm_chain .
  types:
    ltty_vcm_object_id type standard table of vcm_business_object_id .
  types:
    begin of ty_gs_so_text_check_data,
        text_id        type tdid,
        language       type sylangu,
        text_reference type string,
        check_no_entry type abap_bool,
      end of ty_gs_so_text_check_data .
  types:
    ty_gt_so_text_check_data type standard table of ty_gs_so_text_check_data with default key .
  types:
    begin of ty_gs_condition,
        field_name type string,
        operator   type c length 2,
        value      type string,
      end of ty_gs_condition .
  types:
    ty_gt_condition type standard table of ty_gs_condition with default key .
  types:
    begin of ty_gs_so_sline_check_data,
        sline_id              type etenr,
        dynamic_selection_key type ty_gt_condition,
        check_conditions      type ty_gt_condition,
        dynamic_dates         type ty_gt_relative_date,
        description           type c length 30,
      end of ty_gs_so_sline_check_data .
  types:
    ty_gt_so_sline_check_data type standard table of ty_gs_so_sline_check_data with default key .
  types:
    begin of ty_gs_so_partner_check_data,
        partner_function         type parvw,
        check_conditions         type ty_gt_condition,
        check_address_conditions type ty_gt_condition,
      end of ty_gs_so_partner_check_data .
  types:
    ty_gt_so_partner_check_data type standard table of ty_gs_so_partner_check_data with default key .
  types:
    begin of ty_gs_so_price_check_data,
        kschl                type kscha,
        check_conditions     type ty_gt_condition,
        entry_must_not_exist type abap_bool,
      end of ty_gs_so_price_check_data .
  types:
    ty_gt_so_price_check_data type standard table of ty_gs_so_price_check_data with default key .
  types:
    begin of ty_gs_so_item_check_data,
        item_id                        type posnr,
        dynamic_selection_key          type ty_gt_condition,
        check_conditions               type ty_gt_condition,
        dynamic_dates                  type ty_gt_relative_date,
        sline_check_data               type ty_gt_so_sline_check_data,
        partner_check_data             type ty_gt_so_partner_check_data,
        business_data_check_conditions type ty_gt_condition,
        text_check_data                type ty_gt_so_text_check_data,
        price_check_data               type ty_gt_so_price_check_data,
        price_check_suppl_data         type ty_gt_so_price_check_data,
        description                    type c length 30,
      end of ty_gs_so_item_check_data .
  types:
    ty_gt_so_item_check_data type standard table of ty_gs_so_item_check_data with default key .
  types:
    begin of ty_gs_so_check_data,
        head_check_conditions          type ty_gt_condition,
        dynamic_dates                  type ty_gt_relative_date,
        item_check_data                type ty_gt_so_item_check_data,
        partner_check_data             type ty_gt_so_partner_check_data,
        business_data_check_conditions type ty_gt_condition,
        text_check_data                type ty_gt_so_text_check_data,
        dynamic_custom_checks          type ty_gt_dynamic_code,
      end of ty_gs_so_check_data .
  types:
    begin of ty_gs_item_check_data,
        item_id          type posnr,
        check_conditions type ty_gt_condition,
        description      type c length 30,
      end of ty_gs_item_check_data .
  types:
    ty_gt_item_check_data type standard table of ty_gs_item_check_data with default key .
  types:
    begin of ty_gs_profseg_check_data,
        document_category     type vbtypl,
        head_check_conditions type ty_gt_condition,
        item_check_data       type ty_gt_item_check_data,
      end of ty_gs_profseg_check_data .
  types:
    begin of ty_s_profitsegment_key,
        bukrs   type t001-bukrs,
        paobjnr type cest1-paobjnr,
      end of ty_s_profitsegment_key .
  types:
    begin of ty_gs_ptf_so_check_epay,
        fpltr            type fpltr,
        check_conditions type ty_gt_condition,
      end of ty_gs_ptf_so_check_epay .
  types:
    ty_gt_ptf_so_check_epay type standard table of ty_gs_ptf_so_check_epay .
  types:
    begin of ty_gs_so_3rd_party_item_data,
        item_id               type posnr,
        dynamic_selection_key type ty_gt_condition,
        check_address_number  type xfeld,
        sline_check_data      type ty_gt_so_sline_check_data,
      end of ty_gs_so_3rd_party_item_data .
  types:
    ty_gt_so_3rd_party_item_data type standard table of ty_gs_so_3rd_party_item_data with empty key .
  types:
    begin of ty_gs_so_3rd_party_check_data,
        description     type c length 30,
        item_check_data type ty_gt_so_3rd_party_item_data,
      end of ty_gs_so_3rd_party_check_data .
  types:
    begin of ty_gs_mock_sdsls_doc_vcm_td,
        dbtable   type tabname16,     "allows for different tables with same type to use the same parameter
        mock_mode type ptf_mock_mode,
        content   type standard table of sdsls_doc_vcm with default key,
      end of ty_gs_mock_sdsls_doc_vcm_td .
  types:
    ty_gt_mock_sdsls_doc_vcm_td type standard table of ty_gs_mock_sdsls_doc_vcm_td with default key .
  types:
    begin of ty_gs_mock_sdsls_mlan_td,
        dbtable   type tabname16,     "allows for different tables with same type to use the same parameter
        mock_mode type ptf_mock_mode,
        content   type standard table of mlan with default key,
      end of ty_gs_mock_sdsls_mlan_td .
  types:
    ty_gt_mock_sdsls_mlan_td type standard table of ty_gs_mock_sdsls_mlan_td with default key .
  types:
    begin of ty_gs_mock_sdsls_sfsvsitdet_td,
        dbtable   type tabname16,     "allows for different tables with same type to use the same parameter
        mock_mode type ptf_mock_mode,
        content   type standard table of sdsls_sfsvsitdet with default key,
      end of ty_gs_mock_sdsls_sfsvsitdet_td .
  types:
    ty_gt_mock_sdsls_sfsvsitdet_td type standard table of ty_gs_mock_sdsls_sfsvsitdet_td with default key .
  types:
    begin of ty_gs_mock_sdsls_sw_ovrrde_td,
        dbtable   type tabname16,     "allows for different tables with same type to use the same parameter
        mock_mode type ptf_mock_mode,
        content   type standard table of sdsls_sw_ovrrde with default key,
      end of ty_gs_mock_sdsls_sw_ovrrde_td .
  types:
    ty_gt_mock_sdsls_sw_ovrrde_td type standard table of ty_gs_mock_sdsls_sw_ovrrde_td with default key .
  types:
    begin of ty_gs_mock_fins_trr_drakey_td,
        dbtable   type tabname16,     "allows for different tables with same type to use the same parameter
        mock_mode type ptf_mock_mode,
        content   type standard table of fins_trr_drakey with default key,
      end of ty_gs_mock_fins_trr_drakey_td .
  types:
    ty_gt_mock_fins_trr_drakey_td type standard table of ty_gs_mock_fins_trr_drakey_td with default key .
  types:
    begin of ty_gs_mock_fins_trr_drk_sfs_td,
        dbtable   type tabname16,     "allows for different tables with same type to use the same parameter
        mock_mode type ptf_mock_mode,
        content   type standard table of fins_trr_drk_sfs with default key,
      end of ty_gs_mock_fins_trr_drk_sfs_td .
  types:
    ty_gt_mock_fins_trr_drk_sfs_td type standard table of ty_gs_mock_fins_trr_drk_sfs_td with default key .
  types:
    begin of ty_gd_so_config_item_data,
        rel_step_no            type i,
        item_id                type posnr,
        is_fixed               type abap_bool,
        compare_to_rel_step_no type i,
        compare_to_item_id     type posnr,
        config_values_operator type c length 2,
        config_id_operator     type c length 2,
        variant_condition      type varcond,
      end of ty_gd_so_config_item_data .
  types:
    ty_gt_so_config_item_data type standard table of ty_gd_so_config_item_data with default key .
  types:
    begin of ty_gs_so_config_check_data,
        item_check_data type ty_gt_so_config_item_data,
      end of ty_gs_so_config_check_data .
  types:
    begin of ty_gs_component_id,
        component_id type if_sd_sls_comp_types=>tcd_comp_id,
      end of ty_gs_component_id .
  types:
    begin of ty_gs_set_status_external_cdra,
        status_cdra type c length 10,
      end of ty_gs_set_status_external_cdra .

  constants C_CHECK_DOC_APM_STATUS type STRING value 'CHECK_DOC_APM_STATUS' ##NO_TEXT.
  constants C_RAISE_APPROVAL_ACTION type STRING value 'RAISE_APPROVAL_ACTION' ##NO_TEXT.
  constants C_WITHDRAW_FROM_APPROVAL type STRING value 'WITHDRAW_FROM_APPROVAL' ##NO_TEXT.
  constants C_CHECK_VCM type STRING value 'CHECK_VCM' ##NO_TEXT.
  constants C_CHECK_VCMHM_CHAIN type STRING value 'CHECK_VCMHM_CHAIN' ##NO_TEXT.
  constants C_WAIT_IC_FOR_SO4 type STRING value 'WAIT_IC_FOR_SO4' ##NO_TEXT.
  constants C_WAIT type STRING value 'WAIT' ##NO_TEXT.
  constants C_WAIT_VCM_EVENT type STRING value 'WAIT_VCM_EVENT' ##NO_TEXT.
  constants C_CHECK_VCM_AUTOMATICALLY type STRING value 'CHECK_VCM_AUTOMATICALLY' ##NO_TEXT.
  constants C_SELECT_IC_SO type STRING value 'SELECT_IC_SO' ##NO_TEXT.
  constants C_CREATE_WITH_REFERENCE type STRING value 'CREATE_WITH_REFERENCE' ##NO_TEXT.
  constants C_CREATE_WITH_WBS type STRING value 'CREATE_WITH_WBS' ##NO_TEXT.
  constants C_CHECK_IC_SO4_GOAL_CHANGE type STRING value 'CHECK_IC_SO4_GOAL_CHANGE' ##NO_TEXT.
  constants C_CHECK_PROFITABILITY_SEGMENT type STRING value 'CHECK_PROFITABILITY_SEGMENT' ##NO_TEXT.
  constants C_FAR_DP_MOCK_ACTIVE type STRING value 'FAR_DP_MOCK_ACTIVE' ##NO_TEXT.
  constants C_FAR_DP_MOCK_INACTIVE type STRING value 'FAR_DP_MOCK_INACTIVE' ##NO_TEXT.
  constants C_CHECK_EPAY type STRING value 'CHECK_EPAY' ##NO_TEXT.
  constants C_CREATE_WITH_BP_MULTIADDR type STRING value 'CREATE_WITH_BP_MULTIADDR' ##NO_TEXT.
  constants C_CHANGE_WITH_WBS type STRING value 'CHANGE_WITH_WBS' ##NO_TEXT.
  constants C_CHECK_VBELN_NOT_EXISTANT type STRING value 'CHECK_VBELN_NOT_EXISTANT' ##NO_TEXT.
  constants C_CHECK_THIRDPARTY type STRING value 'CHECK_THIRDPARTY' ##NO_TEXT.
  constants C_CREATE_WITH_REF_CONFIG type STRING value 'CREATE_WITH_REF_CONFIG' ##NO_TEXT.
  constants C_CHECK_CONFIGURATION type STRING value 'CHECK_CONFIGURATION' ##NO_TEXT.
  constants C_CHECK_IFRS15 type STRING value 'CHECK_IFRS15_BUNDLE' ##NO_TEXT.
  constants C_ADD_COMPONENT_CMPIF type STRING value 'ADD_COMPONENT_CMPIF' ##NO_TEXT.
  constants C_DELETE_COMPONENT_CMPIF type STRING value 'DELETE_COMPONENT_CMPIF' ##NO_TEXT.
  constants C_CHANGE_FIRSDATE type STRING value 'CHANGE_FIRSDATE' ##NO_TEXT.
  constants C_CHANGE_GOODS_DATE type STRING value 'CHANGE_GOODS_DATE' ##NO_TEXT.

  methods LOG_GOAL_MESSAGES
    exporting
      !IO_GOAL_ACCESS type ref to IF_GOAL_ACCESS
    returning
      value(RV_ERROR_OCCURED) type ABAP_BOOL .
  methods CHANGE_FIRSDATE
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHANGE_GOODS_DATE
    importing
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
    begin of lty_vcm_linked_item,
        itema type vcm_rt_bo_item,
        itemb type vcm_rt_bo_item,
        step  type vcm_rt_step_ins,
        chain type vcm_rt_chain_ins,
      end of lty_vcm_linked_item .
  types:
    ltty_vcm_linked_item type table of lty_vcm_linked_item with empty key .
  types:
        " Digital Payment
    tct_response      type standard table of cl_far_dp_proxy_factory=>ty_response with non-unique key table_line .
  types:
    ty_lt_vbap_sample type standard table of vbap with default key .
  types:
    begin of lty_suppl_data,
        kposn           type kposn,
        kschl           type kscha,
        konv_suppl_data type konv_suppl_data,
      end of lty_suppl_data .
  types:
    ltty_suppl_data type sorted table of lty_suppl_data with non-unique key kposn kschl .

  methods CHECK_ITEM_SPM
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods MERGE_REF_CONFIG_INTO_ITEM
    importing
      !IV_REF_DOC type VBELN
      !IS_SALESORDER_TESTDATA type TY_GS_I_PTF_SO_CR_REF_CONF_TD
    exporting
      !EV_ERROR type ABAP_BOOL
      !ES_SALESORDER_TESTDATA type TY_GS_I_PTF_SO_CR_TD .
  methods MERGE_WBS_INTO_ITEM
    importing
      !IT_WBS type CL_PTF_UTIL=>TY_VBELN_TAB
    exporting
      !EV_ERROR type ABAP_BOOL
    changing
      !CS_SALESORDER_TESTDATA type TY_GS_I_PTF_SO_CR_TD optional
      !CS_SALESORDER_CHECKDATA type TY_GS_SO_CHECK_DATA optional .
  methods CHECK_VCM_FOR_IC
    importing
      !IT_VCM_ITEM type LTTY_VCM_LINKED_ITEM
      !IS_VBAP type VBAP
    exporting
      !EV_RELEVANT type ABAP_BOOL
      !EV_ERROR type ABAP_BOOL .
  methods ITEM_CHECK_VCM_SFSVSIT
    importing
      !IO_RUN_ENVIRONMENT type ref to CL_PTF_RUN
      !IS_VBAP type VBAP
      !IT_VCM_ITEM type CL_PTF_BO_SO=>LTTY_VCM_LINKED_ITEM
    returning
      value(RV_RESULT) type ABAP_BOOL .
  methods ITEM_CHECK_VCM_IC
    importing
      !IO_RUN_ENVIRONMENT type ref to CL_PTF_RUN
      !IS_VBAP type VBAP
      !IT_VCM_ITEM type CL_PTF_BO_SO=>LTTY_VCM_LINKED_ITEM
    returning
      value(RV_RESULT) type ABAP_BOOL .
  methods MERGE_GOAL_ENTITY_TEST_DATA
    importing
      !IS_ENTITY_TEST_DATA type DATA
      !IT_UNCNDNL_TAKE_OVER_FIELDS type TY_GT_FIELD
    exporting
      !ES_CHANGED_FIELD type IF_GOAL_TYPES=>TCS_CHANGED_FIELD
    changing
      !CS_ENTITY_DATA type DATA .
  methods MERGE_GOAL_SALESORDER
    importing
      !IO_GOAL_ACCESS type ref to IF_GOAL_ACCESS
    changing
      !CS_SALESORDER_TEST_DATA type TY_GS_I_PTF_SO_CR_TD .
  methods SET_RELATIVE_DATES
    importing
      !IT_RELATIVE_DATES type TY_GT_RELATIVE_DATE
    changing
      !CS_ENTITY_TEST_DATA type DATA .
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
  methods CHECK_DOC_APM_STATUS
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_VCM
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_VCMHM_CHAIN
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_VCM_FOR_SFSVSIT
    importing
      !IS_VBAK type VBAK
      !IS_VBAP type VBAP
      !IT_VBKD type TDT_VBKD
    exporting
      !EV_RELEVANT type ABAP_BOOL
      !EV_ERROR type ABAP_BOOL .
  methods CHECK_VCM_FOR_NORMAL_ITEM
    importing
      !IS_VBAP type VBAP
    exporting
      !EV_ERROR type ABAP_BOOL .
    " !iv_vbeln          type vbeln_va optional
  methods READ_VCM_LINKED_ITEM
    importing
      !IT_SALES_KEY type SHP_SALES_KEY_T optional
    returning
      value(RT_VCM_ITEM) type LTTY_VCM_LINKED_ITEM .
  methods WAIT_IC_FOR_SO4
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods WAIT
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_VCM_AUTOMATICALLY
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods COMPARE_VCM_VBAP_DATA
    importing
      !IT_SALES_KEY type SHP_SALES_KEY_T
      !IS_TESTDATA type TY_GS_PTF_SO_CHECK_VCM_TD
      !IS_CHECK_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IO_RUN_ENVIRONMENT type ref to CL_PTF_RUN
    exporting
      value(RV_IS_EQUAL) type ABAP_BOOL
      !ET_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB .
  methods ITEM_CHECK_ALL_FIELDS
    importing
      !IO_RUN_ENVIRONMENT type ref to CL_PTF_RUN
      !IT_FIELDINFO type EXTDFIEST
      !IS_VBAP_CHECK type TY_S_VCM_VBAP_CHECK
      !IS_VBAP_ACTUAL type VBAP
      !IS_VBAP_EXP type VBAP
    returning
      value(RV_RESULT) type ABAP_BOOL .
  methods SELECT_IC_SO
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_WITH_REFERENCE
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_SALES_ORDER_EXISTS
    importing
      !IT_SALES_KEY type SHP_SALES_KEY_T
      !IO_RUN_ENVIRONMENT type ref to CL_PTF_RUN optional
    returning
      value(RV_RESULT) type ABAP_BOOL .
  methods EVALUATE_CHECK_CONDITION
    importing
      !IS_DATA type DATA
      !IS_CONDITION type TY_GS_CONDITION
      !IV_VERBOSE_MODE type ABAP_BOOL default ABAP_TRUE
    returning
      value(RV_CONDITION_RESULT) type ABAP_BOOL .
  methods READ_VCMHM_CHAIN
    importing
      !IT_OBJECT_ID type LTTY_VCM_OBJECT_ID
    exporting
      !ET_VCMHM_CHAIN type LTTY_VCMHM_CHAIN .
  methods COMPARE_STRUCTURE
    importing
      !IO_RUN_ENVIRONMENT type ref to CL_PTF_RUN
      !IS_CHECK_PARAMETER type ANY
      !IS_EXPECTED type ANY
      !IS_ACTUAL type ANY
    returning
      value(RV_RESULT) type ABAP_BOOL .
  methods CHECK_IC_SO4_GOAL_CHANGE
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_CHECK_STATUS type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL .
  methods CHECK_PROFITABILITY_SEGMENT
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_CHECK_STATUS type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL .
  methods GET_PROFITSEGMENT_KEY
    importing
      !IV_VBELN type VBELN
      !IV_POSNR type POSNR
      !IV_VBTYP type VBTYPL
    returning
      value(RS_KEY) type TY_S_PROFITSEGMENT_KEY .
  methods EVALUATE_COPA_DATA
    importing
      !IT_COPA type COPADATA_TAB
      !IT_CHECK_CONDITIONS type TY_GT_CONDITION
    returning
      value(RV_RESULT) type ABAP_BOOL .
  methods FAR_DP_MOCK_INACTIVE .
  methods FAR_DP_MOCK_ACTIVE .
  methods CHECK_EPAY
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods DP_GET_RESPONSE
    returning
      value(RT_RESPONSE) type TCT_RESPONSE .
  methods DP_POST_RESPONSE
    returning
      value(RT_RESPONSE) type TCT_RESPONSE .
  methods CREATE_WITH_WBS
    importing
      !IV_STEP_NUMBER type I
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_WITH_REF_CONFIG
    importing
      !IV_STEP_NUMBER type I
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_WITH_BP_MULTIADDR
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHANGE_WITH_WBS
    importing
      !IV_STEP_NUMBER type I
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_VBELN_NOT_EXISTANT
    importing
      !IV_STEP_NUMBER type I
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_CONFIGURATION
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_CHECK_STATUS type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL .
  methods CHECK_THIRDPARTY
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_CHECK_STATUS type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL .
  methods PR_CHECK_3RD_PARTY_ADRNR
    importing
      !IV_ADRNR type VBPA-ADRNR
      !IS_VBAP type VBAP
      !IT_VBEP type VBEP_TAB
      !IT_EBAN type MEREQ_T_EBAN
    returning
      value(R_RESULT) type ABAP_BOOL .
  methods PR_EXTRACT_TO_SAMPLE_VBAP
    importing
      !IT_VBAP type TAB_VBAP
      !IR_ITEM_CHECK_DATA type ref to CL_PTF_BO_SO=>TY_GS_SO_3RD_PARTY_ITEM_DATA
    returning
      value(RT_VBAP_SAMPLE) type TY_LT_VBAP_SAMPLE .
  methods PR_EXTRACT_TO_SAMPLE_VBEP
    importing
      !IV_POSNR type POSNR_VA
      !IT_VBEP type VBEP_TAB
      !IR_SLINE_CHECK_DATA type ref to CL_PTF_BO_SO=>TY_GS_SO_SLINE_CHECK_DATA
    returning
      value(RT_VBEP_SAMPLE) type VBEP_TAB .
  methods PR_CHECK_3RD_PARTY_EBAN
    importing
      !IT_VBEP_SAMPLE type VBEP_TAB
      !IT_EBAN type MEREQ_T_EBAN
      !IR_SLINE_CHECK_DATA type ref to CL_PTF_BO_SO=>TY_GS_SO_SLINE_CHECK_DATA
    returning
      value(RV_RESULT) type ABAP_BOOL .
  methods PR_GET_VBAP_SAMPLE
    importing
      !IT_VBAP type TAB_VBAP
      !IR_ITEM_CHECK_DATA type ref to CL_PTF_BO_SO=>TY_GS_SO_3RD_PARTY_ITEM_DATA
    returning
      value(RT_VBAP_SAMPLE) type TAB_VBAP .
  methods PR_GET_VBEP_SAMPLE
    importing
      !IV_POSNR type POSNR_VA
      !IT_VBEP type VBEP_TAB
      !IR_SLINE_CHECK_DATA type ref to CL_PTF_BO_SO=>TY_GS_SO_SLINE_CHECK_DATA
    returning
      value(RT_VBEP_SAMPLE) type VBEP_TAB .
  methods PR_GET_SHIPTO
    importing
      !IV_POSNR type POSNR_VA
      !IT_VBPA type TAB_VBPA
    returning
      value(RS_VBPA) type VBPA .
  methods SET_DATA_CONTAINER_ITEM
    importing
      !IS_ITEM_DATA type TDS_GOAL_SO_ITEM
      !IS_DATA_CONTAINER type IF_GOAL_SDOC_DATA_CONT=>TCS_ITEM .
  methods GET_CUOBJ
    importing
      !IV_STEP_NUMBER type I
      !IV_ITEM_ID type POSNR
      !IV_LOG_ERROR type ABAP_BOOL default 'X'
    exporting
      !EV_CUOBJ type CUOBJ
      !EV_DOCUMENT_ID type VBELN
      !EV_SUCCESS type ABAP_BOOL .
  methods RUN_DYNAMIC_TEST_DATA_CHANGES
    importing
      !IV_STEP_NUMBER type I
      !IT_DYNAMIC_CODE type TY_GT_DYNAMIC_CODE
    exporting
      !EV_IMMEDIATE_EXIT type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
    changing
      !CS_SALESORDER_TEST_DATA type TY_GS_I_PTF_SO_CR_TD optional
    returning
      value(RV_EXECUTION_STATUS) type ABAP_BOOL .
  methods RUN_CUSTOM_DYNAMIC_CHECKS
    importing
      !IV_STEP_NUMBER type I
      !IT_DYNAMIC_CODE type TY_GT_DYNAMIC_CODE
    exporting
      !EV_IMMEDIATE_EXIT type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
    changing
      !CS_SALESORDER_TEST_DATA type TY_GS_SO_CHECK_DATA optional
    returning
      value(RV_CHECK_STATUS) type ABAP_BOOL .
  methods CHECK_IFRS15_BUNDLE
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_CHECK_STATUS type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL .
  methods WAIT_VCM_EVENT
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods SET_STATUS_EXTERNAL_CDRA
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
ENDCLASS.



CLASS CL_PTF_BO_SO IMPLEMENTATION.


  method change.
    data: ls_testdata       type ty_gs_i_ptf_so_cr_td,
          lv_immediate_exit type abap_bool.

    ev_execution_status = abap_false.
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = ls_step_data
      importing
        es_testdata  = ls_testdata ).

    " Run dynamic testdata changes
    if ls_testdata-dynamic_testdata_changes is not initial.
      ev_execution_status = me->run_dynamic_test_data_changes(
        exporting
          iv_step_number          = iv_step_number
          it_dynamic_code         = ls_testdata-dynamic_testdata_changes
        importing
          ev_immediate_exit       = lv_immediate_exit
          ev_document_id          = ev_document_id
        changing
          cs_salesorder_test_data = ls_testdata
      ).
      check lv_immediate_exit = abap_false.
    endif.

    "Add CMPIF Implemetations
    loop at ls_testdata-components_cmpif into data(ls_component_cmpif).
      if ls_component_cmpif-component_id is not initial.
        cl_sd_sls_comp_factory=>so_instance->add_component( ls_component_cmpif ).
      endif.
    endloop.

    " Enable VCM synchronous processing
    data(vcm_test_utility) = cl_vcmhm_test_utility=>get_instance( ).
    if ls_testdata-vcm_run_sync = abap_true.
      cl_sd_sls_ic_vcm_step_init_so=>sv_ptf_vcm_sync_mode = abap_true.
      vcm_test_utility->enable_sync_processing( ).
    endif.

    if ls_testdata-goal_bo_id is initial.
      ls_testdata-goal_bo_id = if_goal_sdoc=>co_bo_id-salesorder.
    endif.

    loop at ls_step_data-reference_step assigning field-symbol(<prestep_numbr>).
      data(ls_step_precessor) = me->mo_run_environment->get_step_data( iv_step_number = <prestep_numbr> ).
      move ls_step_precessor-document_id to ev_document_id.
      loop at ev_document_id  assigning field-symbol(<vbeln>).
        try.
            data(lo_goal_access) = cl_goal_api=>so_instance->open(
              exporting
                iv_bo_id            = ls_testdata-goal_bo_id
                iv_bo_key           = <vbeln>-vbeln && ''
                iv_read_only        = abap_false
                is_control_settings = value if_goal_access=>tcs_control_settings( no_conversion = abap_true )
                it_scenario_id      = ls_testdata-goal_scenario_ids ).
            merge_goal_salesorder(
              exporting
                io_goal_access          = lo_goal_access
              changing
                cs_salesorder_test_data = ls_testdata ).
            lo_goal_access->save( exporting iv_synchron = abap_true ).
            data(lv_error_occured) = log_goal_messages(
              importing
                io_goal_access = lo_goal_access ).
            lo_goal_access->close( ).
            if lv_error_occured = abap_true.
              exit.
            endif.

            " Workaround to run VCM synchronously -- not working for change!
            if ls_testdata-vcm_run_sync = abap_true.
              select * from vbap into table @data(lt_vbap) where vbeln = @<vbeln>-vbeln.
              data: lv_vcm_chain_uuid type vcm_uuid.
              loop at lt_vbap reference into data(lr_vbap) group by lr_vbap->vcm_chain_uuid.
                lv_vcm_chain_uuid = lr_vbap->vcm_chain_uuid.
                vcm_test_utility->resume_value_chain( lv_vcm_chain_uuid ).
              endloop.
            endif.

          catch cx_goal_exc into data(lx_goal_exc).
            cl_message_helper=>set_msg_vars_for_if_t100_msg( lx_goal_exc ).
            me->mo_run_environment->append_log( iv_log_statement = |{ lx_goal_exc->get_text( ) }| ).
            exit.
        endtry.
      endloop.
    endloop.

    "delete CMPIF Implemetations
    loop at ls_testdata-components_cmpif into ls_component_cmpif.
      if ls_component_cmpif-component_id is not initial.
        cl_sd_sls_comp_factory=>so_instance->del_component( iv_comp_id = ls_component_cmpif-component_id ).
      endif.
    endloop.

    ev_execution_status = abap_true.

  endmethod.


  method change_with_wbs.

    data: ls_testdata   type ty_gs_i_ptf_so_cr_td,
          ls_result_key type cl_ptf_util=>ty_result_key_data,
          lv_vbeln      type vbeln.

    ev_execution_status = abap_true.
    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = is_step_data
      importing
        es_testdata  = ls_testdata ).

    data(lt_result_key_data) =  me->mo_run_environment->get_result_key_data( it_step_number =  is_step_data-reference_step ) .

    loop at is_step_data-reference_step assigning field-symbol(<ref_step>).
      read table lt_result_key_data with key step_number = <ref_step> into ls_result_key.
      case ls_result_key-bus_obj.
        when 'ENTERPRISE_PROJECT'.
          data(lt_wbs) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
        when 'SO'.
          data(lt_vbeln) =  me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
          if lt_vbeln is not initial .
            lv_vbeln = lt_vbeln[ 1 ].
          endif.
      endcase.
    endloop.
    if not lt_wbs is initial .
      merge_wbs_into_item(
        exporting
          it_wbs                 = lt_wbs
        importing
          ev_error               = data(lv_error)
        changing
          cs_salesorder_testdata = ls_testdata ).
      if lv_error = abap_true.
*        exit.
      endif.
    endif.

    try.
        data(lo_goal_access) = cl_goal_api=>so_instance->open( exporting iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
                                                                         iv_bo_key           = lv_vbeln && ''
                                                                         iv_read_only        = abap_false
                                                                         is_control_settings = value if_goal_access=>tcs_control_settings( no_conversion = abap_true ) ).
        merge_goal_salesorder(
          exporting
            io_goal_access          = lo_goal_access
          changing
            cs_salesorder_test_data = ls_testdata ).
        lo_goal_access->save( ).
        data(lv_error_occured) = log_goal_messages(
          importing
            io_goal_access = lo_goal_access ).
        lo_goal_access->close( ).
        if lv_error_occured = abap_true.
          exit.
        endif.
      catch cx_goal_exc into data(lx_goal_exc).
        cl_message_helper=>set_msg_vars_for_if_t100_msg( lx_goal_exc ).
        me->mo_run_environment->append_log( iv_log_statement = |{ lx_goal_exc->get_text( ) }| ).
        "        exit.
    endtry.

  endmethod.


  method check.
    data: lv_vbeln          type vbeln,
          ls_testdata       type ty_gs_so_check_data,
          lt_vbap_sample    type table of vbap,
          lt_vbep_sample    type table of vbep,
          lc_posnr_initial  type posnr value '000000',
          lv_date           like sy-datum,
          ls_result_key     type cl_ptf_util=>ty_result_key_data,
          lt_lines          type standard table of tline,
          lt_inlines        type standard table of tline,
          ls_suppl_data     type lty_suppl_data,
          lt_suppl_data     type ltty_suppl_data,
          lv_immediate_exit type abap_bool.

    field-symbols:
      <fs_vbkd> type vbkd,
      <fs_vbpa> type vbpa,
      <fs_adrc> type adrc.

    ev_check_status = abap_true.

    " get sample vbeln
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    if lines( ls_step_data-reference_step ) = 1.
      data(ls_reference_step) = me->mo_run_environment->get_step_data( iv_step_number = ls_step_data-reference_step[ 1 ] ).
      if ls_reference_step-document_id is not initial.
        lv_vbeln = ls_reference_step-document_id[ 1 ].
      endif.
    else.
      data(lt_result_key_data) =  me->mo_run_environment->get_result_key_data( it_step_number =  ls_step_data-reference_step ) .
      loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
        read table lt_result_key_data with key step_number = <lv_ref_step> into ls_result_key.
        case ls_result_key-bus_obj .
          when 'SO'.
            data(lt_vbeln) =  me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
            if lt_vbeln is not initial .
              lv_vbeln = lt_vbeln[ 1 ].
            endif.
          when 'ENTERPRISE_PROJECT' .
            data(lt_wbs) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
        endcase.
      endloop.
    endif.
    if lv_vbeln is initial.
      me->mo_run_environment->append_log( iv_log_statement = 'Error: No document id provided by reference step' ).
      ev_check_status = abap_false.
      return.
    endif.

    " get check data
    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = ls_step_data
      importing
        es_testdata  = ls_testdata ).

    " run custom dynamic checks
    if ls_testdata-dynamic_custom_checks is not initial.
      ev_check_status = me->run_custom_dynamic_checks(
        exporting
          iv_step_number          = iv_step_number
          it_dynamic_code         = ls_testdata-dynamic_custom_checks
        importing
          ev_immediate_exit       = lv_immediate_exit
          ev_document_id          = ev_document_id
        changing
          cs_salesorder_test_data = ls_testdata
      ).
      check lv_immediate_exit = abap_false.
    endif.

    if not lt_wbs is initial .
      merge_wbs_into_item(
        exporting
          it_wbs                  = lt_wbs
        importing
          ev_error                = data(lv_error)
        changing
          cs_salesorder_checkdata = ls_testdata ).

      if lv_error = abap_true.
        exit.
      endif.
    endif.

    " read tables
    select single * from vbak into @data(ls_vbak) where vbeln = @lv_vbeln.
    if sy-subrc <> 0.
      me->mo_run_environment->append_log( iv_log_statement = 'Error: VBAK entry for vbeln = ' && lv_vbeln && ' does not exist.' ).
      ev_check_status = abap_false.
      return.
    endif.
    select * from vbap into table @data(lt_vbap) where vbeln = @lv_vbeln.
    select * from vbep into table @data(lt_vbep) where vbeln = @lv_vbeln.
    select * from vbpa into table @data(lt_vbpa) where vbeln = @lv_vbeln.
    select * from vbkd into table @data(lt_vbkd) where vbeln = @lv_vbeln.
    if lt_vbpa[] is not initial.
      select * from adrc into table @data(lt_adrc) for all entries in @lt_vbpa where addrnumber = @lt_vbpa-adrnr.
    endif.
    select * from prcd_elements into table @data(lt_prcd_elememts) where knumv = @ls_vbak-knumv.

    "Read condition supplement data
    loop at lt_prcd_elememts reference into data(lr_prcd_elememts)
         where common_suppl_data eq abap_true.
      clear ls_suppl_data.
      data(lv_suppl_data_guid) = cl_prc_suppl_data_factory=>factory->get_handler_by_knumv( ls_vbak-knumv )->get_db_guid(
                                                                                                              iv_knumv = lr_prcd_elememts->knumv
                                                                                                              iv_kposn = lr_prcd_elememts->kposn
                                                                                                              iv_kschl = lr_prcd_elememts->kschl
                                                                                                              iv_stunr = lr_prcd_elememts->stunr
                                                                                                              iv_zaehk = lr_prcd_elememts->zaehk ).
      check lv_suppl_data_guid is not initial.
      ls_suppl_data-konv_suppl_data = cl_prc_suppl_data_factory=>factory->get_handler_by_knumv( ls_vbak-knumv )->get_suppl_data( lv_suppl_data_guid ).
      check ls_suppl_data-konv_suppl_data is not initial.
      ls_suppl_data-kposn = lr_prcd_elememts->kposn.
      ls_suppl_data-kschl = lr_prcd_elememts->kschl.
      insert ls_suppl_data into table lt_suppl_data.
    endloop.

    " Prepare header data with dynamic dates
    loop at ls_testdata-dynamic_dates reference into data(lr_dynamic_date_head).
      check lr_dynamic_date_head->date_field_name is not initial.
      split lr_dynamic_date_head->date_field_name at '-' into data(lv_table_name) data(lv_field_name).
      if lv_field_name is initial.
        lv_field_name = lv_table_name.
        lv_table_name = ''.
      endif.
      check lv_field_name is not initial.

      case lv_table_name.
        when 'VBAK' or 'vbak' or ''.
          loop at ls_testdata-head_check_conditions reference into data(lr_head_check_condition) where field_name = lr_dynamic_date_head->date_field_name.
            lv_date = sy-datum + lr_dynamic_date_head->offset_in_days.
            lr_head_check_condition->value = lv_date.
          endloop.
        when 'VBKD' or 'vbkd'.
          loop at ls_testdata-business_data_check_conditions reference into data(lr_business_data_check_cond) where field_name = lr_dynamic_date_head->date_field_name.
            lv_date = sy-datum + lr_dynamic_date_head->offset_in_days.
            lr_business_data_check_cond->value = lv_date.
          endloop.
      endcase.

    endloop.

    " Check header data
    loop at ls_testdata-head_check_conditions assigning field-symbol(<fs_head_check_condition>).
      if evaluate_check_condition( is_data = ls_vbak is_condition = <fs_head_check_condition> ) = abap_false.
        ev_check_status = abap_false.
      endif.
    endloop.

    " Check business data on header level
    assign lt_vbkd[ posnr = lc_posnr_initial ] to <fs_vbkd>.
    loop at ls_testdata-business_data_check_conditions assigning field-symbol(<fs_head_bd_check_condition>).
      if evaluate_check_condition( is_data = <fs_vbkd> is_condition = <fs_head_bd_check_condition> ) = abap_false.
        ev_check_status = abap_false.
      endif.
    endloop.

    " Check partner data on header level
    loop at ls_testdata-partner_check_data reference into data(lr_partner_check_data_head).
      if line_exists( lt_vbpa[ posnr = lc_posnr_initial parvw = lr_partner_check_data_head->partner_function ] ).
        assign lt_vbpa[ posnr = lc_posnr_initial parvw = lr_partner_check_data_head->partner_function ] to <fs_vbpa>.
        loop at lr_partner_check_data_head->check_conditions assigning field-symbol(<fs_partner_check_condition_h>).
          if evaluate_check_condition( is_data = <fs_vbpa> is_condition = <fs_partner_check_condition_h> ) = abap_false.
            ev_check_status = abap_false.
          endif.
        endloop.
        unassign <fs_adrc>.
        assign lt_adrc[ addrnumber = <fs_vbpa>-adrnr ] to <fs_adrc>.
        if sy-subrc = 0.
          loop at lr_partner_check_data_head->check_address_conditions assigning field-symbol(<fs_address_check_condition_h>).
            if evaluate_check_condition( is_data = <fs_adrc> is_condition = <fs_address_check_condition_h> ) = abap_false.
              ev_check_status = abap_false.
            endif.
          endloop.
        else.
          me->mo_run_environment->append_log( |'Error: Address details not found for address number { <fs_vbpa>-adrnr } from VBPA| ).
          ev_check_status = abap_false.
        endif.
      else.
        me->mo_run_environment->append_log( iv_log_statement = 'Error: VBPA entry for partner function ''' && lr_partner_check_data_head->partner_function && ''' does not exist.' ).
        ev_check_status = abap_false.
      endif.
    endloop.

    " Check head texts
    if ls_testdata-text_check_data is not initial.
      me->mo_run_environment->append_log( 'Comparing header text with reference).' ).
      loop at ls_testdata-text_check_data reference into data(lr_head_text_check_data).
        call function 'READ_TEXT_INLINE'
          exporting
            id              = lr_head_text_check_data->text_id  "Text ID of text to be read
            inline_count    = 2                            " Number of lines for inline table
            language        = lr_head_text_check_data->language      " Language of text to be read
            name            = conv tdobname( lv_vbeln && '' )             " Name of text to be read
            object          = conv tdobject( 'VBBK' ) "Object of text to be read
          tables
            inlines         = lt_inlines[]     "
            lines           = lt_lines[]       " Lines of text read
          exceptions
            id              = 1                " Text ID invalid
            language        = 2                " Invalid language
            name            = 3                " Invalid text name
            not_found       = 4                " Text not found
            object          = 5                " Invalid text object
            reference_check = 6                " Reference chain cancelled
            others          = 7.
        if sy-subrc <> 0.
          if lr_head_text_check_data->check_no_entry = abap_false.
            ev_check_status = abap_false.
            me->mo_run_environment->append_log( 'Error: No head text entry found for (id = ' && lr_head_text_check_data->text_id && ', language = ' && lr_head_text_check_data->language && ').' ).
          endif.
        elseif lr_head_text_check_data->check_no_entry = abap_true.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( 'Error: An entry for (id = ' && lr_head_text_check_data->text_id && ', language = ' && lr_head_text_check_data->language && ') has been found but should not exist.' ).
          continue.
        endif.

        if not ( lr_head_text_check_data->text_reference is initial and lt_lines[] is initial     " in case text is empty and also no line was created in text
          or lines( lt_lines[] ) > 0 and lt_lines[ 1 ]-tdline = lr_head_text_check_data->text_reference ).
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( 'Error: Head text entry is not equal to reference (id = ' && lr_head_text_check_data->text_id && ', language = ' && lr_head_text_check_data->language && ').' ).
          me->mo_run_environment->append_log( 'Reference text: ' && lr_head_text_check_data->text_reference ).
          if lt_lines[] is initial.
            me->mo_run_environment->append_log( 'Actual text is empty.' ).
          else.
            me->mo_run_environment->append_log( 'Actual text:' && lt_lines[ 1 ]-tdline ).
          endif.
        endif.
      endloop.
    endif.

    " Check item data
    loop at ls_testdata-item_check_data reference into data(lr_item_check_data).
      clear lt_vbap_sample.
      me->mo_run_environment->append_log( iv_log_statement = sy-tabix && ' item check ( ' && lr_item_check_data->description && ' ).' ).

      " Prepare item data with dynamic dates
      loop at lr_item_check_data->dynamic_dates reference into data(lr_dynamic_date_item).
        check lr_dynamic_date_item->date_field_name is not initial.
        split lr_dynamic_date_item->date_field_name at '-' into lv_table_name lv_field_name.
        if lv_field_name is initial.
          lv_field_name = lv_table_name.
          lv_table_name = ''.
        endif.
        check lv_field_name is not initial.

        case lv_table_name.
          when 'VBAK' or 'vbak' or ''.
            loop at lr_item_check_data->check_conditions reference into data(lr_item_check_condition) where field_name = lv_field_name.
              lv_date = sy-datum + lr_dynamic_date_item->offset_in_days.
              lr_item_check_condition->value = lv_date.
            endloop.
          when 'VBKD' or 'vbkd'.
            loop at lr_item_check_data->business_data_check_conditions reference into lr_business_data_check_cond where field_name = lv_field_name.
              lv_date = sy-datum + lr_dynamic_date_head->offset_in_days.
              lr_business_data_check_cond->value = lv_date.
            endloop.
        endcase.
      endloop.

      " get vbap entries by item id or selection criteria
      if lr_item_check_data->item_id is initial.
        loop at lt_vbap assigning field-symbol(<fs_vbap>).
          data(lv_vbap_valid) = abap_true.
          loop at lr_item_check_data->dynamic_selection_key assigning field-symbol(<fs_item_dynamic_select_key>).
            if evaluate_check_condition( is_data = <fs_vbap> is_condition = <fs_item_dynamic_select_key> iv_verbose_mode = abap_false ) = abap_false.
              lv_vbap_valid = abap_false.
            endif.
          endloop.
          if lv_vbap_valid = abap_true.
            insert <fs_vbap> into table lt_vbap_sample.
          endif.
        endloop.
      else.
        if line_exists( lt_vbap[ posnr = lr_item_check_data->item_id ] ).
          insert lt_vbap[ posnr = lr_item_check_data->item_id ] into table lt_vbap_sample.
        endif.
      endif.

      " check if at least one vbap entry is found
      if lt_vbap_sample is initial.
        if lr_item_check_data->item_id is initial.
          me->mo_run_environment->append_log( iv_log_statement = 'Warning: No VBAP entry found for item_check_data selection criteria.' ).
        else.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = 'Error: No VBAP entry found for item_check_data selection criteria.' ).
        endif.
      endif.

      loop at lt_vbap_sample assigning field-symbol(<fs_vbap_sample>).
        me->mo_run_environment->append_log( iv_log_statement = 'Comparing to VBAP / VBKD / VBPA entry with posnr = ' && <fs_vbap_sample>-posnr && '.' ).
        loop at lr_item_check_data->check_conditions assigning field-symbol(<fs_item_check_condition>).
          if evaluate_check_condition( is_data = <fs_vbap_sample> is_condition = <fs_item_check_condition> ) = abap_false.
            ev_check_status = abap_false.
          endif.
        endloop.

        " Check business data on item level
        if lr_item_check_data->business_data_check_conditions is not initial.
          assign lt_vbkd[ posnr = lc_posnr_initial ] to <fs_vbkd>.
          if line_exists( lt_vbkd[ posnr = <fs_vbap_sample>-posnr ] ).
            assign lt_vbkd[ posnr = <fs_vbap_sample>-posnr ] to <fs_vbkd>.
          endif.
          loop at lr_item_check_data->business_data_check_conditions assigning field-symbol(<fs_item_bd_check_condition>).
            if evaluate_check_condition( is_data = <fs_vbkd> is_condition = <fs_item_bd_check_condition> ) = abap_false.
              ev_check_status = abap_false.
            endif.
          endloop.
        endif.

        " Check partner data on item level
        loop at lr_item_check_data->partner_check_data reference into data(lr_partner_check_data_item).
          unassign <fs_vbpa>.
          if line_exists( lt_vbpa[ posnr = <fs_vbap_sample>-posnr parvw = lr_partner_check_data_item->partner_function ] ).
            assign lt_vbpa[ posnr = <fs_vbap_sample>-posnr parvw = lr_partner_check_data_item->partner_function ] to <fs_vbpa>.
          elseif line_exists( lt_vbpa[ posnr = lc_posnr_initial parvw = lr_partner_check_data_item->partner_function ] ).
            assign lt_vbpa[ posnr = lc_posnr_initial parvw = lr_partner_check_data_item->partner_function ] to <fs_vbpa>.
          else.
            me->mo_run_environment->append_log( iv_log_statement = 'Error: VBPA entry for partner function ' && lr_partner_check_data_item->partner_function && ' does not exist.' ).
            ev_check_status = abap_false.
            continue.
          endif.
          loop at lr_partner_check_data_item->check_conditions assigning field-symbol(<fs_partner_check_condition_i>).
            if evaluate_check_condition( is_data = <fs_vbpa> is_condition = <fs_partner_check_condition_i> ) = abap_false.
              ev_check_status = abap_false.
            endif.
          endloop.
          unassign <fs_adrc>.
          assign lt_adrc[ addrnumber = <fs_vbpa>-adrnr ] to <fs_adrc>.
          if sy-subrc = 0.
            loop at lr_partner_check_data_item->check_address_conditions assigning field-symbol(<fs_address_check_condition_i>).
              if evaluate_check_condition( is_data = <fs_adrc> is_condition = <fs_address_check_condition_i> ) = abap_false.
                ev_check_status = abap_false.
              endif.
            endloop.
          else.
            me->mo_run_environment->append_log( |'Error: Address details not found for address number { <fs_vbpa>-adrnr } from VBPA| ).
            ev_check_status = abap_false.
          endif.
        endloop.

        " Check price condition on item level
        loop at lr_item_check_data->price_check_data reference into data(lr_price_check_data_item).
          if line_exists( lt_prcd_elememts[ kposn = <fs_vbap_sample>-posnr kschl = lr_price_check_data_item->kschl ] )
            and lr_price_check_data_item->entry_must_not_exist = abap_false.
            assign lt_prcd_elememts[ kposn = <fs_vbap_sample>-posnr kschl = lr_price_check_data_item->kschl ]
            to field-symbol(<fs_prcd_element>).
            loop at lr_price_check_data_item->check_conditions assigning field-symbol(<fs_price_check_condition_i>).
              if evaluate_check_condition( is_data = <fs_prcd_element> is_condition = <fs_price_check_condition_i> ) = abap_false.
                ev_check_status = abap_false.
              endif.
            endloop.
          elseif line_exists( lt_prcd_elememts[ kposn = <fs_vbap_sample>-posnr kschl = lr_price_check_data_item->kschl ] )
            and lr_price_check_data_item->entry_must_not_exist = abap_true.
            me->mo_run_environment->append_log( |'Error: Condition { <fs_vbap_sample>-posnr } { lr_price_check_data_item->kschl } exists but it shouldn''t| ).
            ev_check_status = abap_false.
          elseif lr_price_check_data_item->entry_must_not_exist = abap_false.
            me->mo_run_environment->append_log( |'Error: Condition { <fs_vbap_sample>-posnr } { lr_price_check_data_item->kschl } not found| ).
            ev_check_status = abap_false.
          endif.
        endloop.

        " Check price condition supplement data on item level
        loop at lr_item_check_data->price_check_suppl_data reference into data(lr_price_check_suppl_data_item).
          if line_exists( lt_suppl_data[ kposn = <fs_vbap_sample>-posnr kschl = lr_price_check_suppl_data_item->kschl ] )
            and lr_price_check_suppl_data_item->entry_must_not_exist = abap_false.
            assign lt_suppl_data[ kposn = <fs_vbap_sample>-posnr kschl = lr_price_check_suppl_data_item->kschl ]-konv_suppl_data
              to field-symbol(<fs_suppl_data>).
            loop at lr_price_check_suppl_data_item->check_conditions assigning field-symbol(<fs_suppl_check_condition_i>).
              if evaluate_check_condition( is_data = <fs_suppl_data> is_condition = <fs_suppl_check_condition_i> ) = abap_false.
                ev_check_status = abap_false.
              endif.
            endloop.
          elseif line_exists( lt_suppl_data[ kposn = <fs_vbap_sample>-posnr kschl = lr_price_check_suppl_data_item->kschl ] )
            and lr_price_check_suppl_data_item->entry_must_not_exist = abap_true.
            me->mo_run_environment->append_log( |'Error: Condition supplement { <fs_vbap_sample>-posnr } { lr_price_check_data_item->kschl } exists but it shouldn''t| ).
            ev_check_status = abap_false.
          elseif lr_price_check_suppl_data_item->entry_must_not_exist = abap_false.
            me->mo_run_environment->append_log( |'Error: Condition supplement { <fs_vbap_sample>-posnr } { lr_price_check_suppl_data_item->kschl } not found| ).
            ev_check_status = abap_false.
          endif.
        endloop.

        " Check item texts
        if lr_item_check_data->text_check_data is not initial.
          me->mo_run_environment->append_log( 'Comparing item text with reference).' ).
          loop at lr_item_check_data->text_check_data reference into data(lr_item_text_check_data).
            clear: lt_inlines[], lt_lines[].
            call function 'READ_TEXT_INLINE'
              exporting
                id              = lr_item_text_check_data->text_id  "Text ID of text to be read
                inline_count    = 2                            " Number of lines for inline table
                language        = lr_item_text_check_data->language      " Language of text to be read
                name            = conv tdobname( lv_vbeln && <fs_vbap_sample>-posnr && '' ) " Name of text to be read
                object          = conv tdobject( 'VBBP' ) "Object of text to be read
              tables
                inlines         = lt_inlines[]     "
                lines           = lt_lines[]       " Lines of text read
              exceptions
                id              = 1                " Text ID invalid
                language        = 2                " Invalid language
                name            = 3                " Invalid text name
                not_found       = 4                " Text not found
                object          = 5                " Invalid text object
                reference_check = 6                " Reference chain cancelled
                others          = 7.
            if sy-subrc <> 0.
              if lr_item_text_check_data->check_no_entry = abap_false.
                ev_check_status = abap_false.
                me->mo_run_environment->append_log( 'Error: No item text entry found for (id = ' && lr_item_text_check_data->text_id && ', language = ' && lr_item_text_check_data->language && ').' ).
              endif.
            elseif lr_item_text_check_data->check_no_entry = abap_true.
              ev_check_status = abap_false.
              me->mo_run_environment->append_log( 'Error: An entry for (id = ' && lr_item_text_check_data->text_id && ', language = ' && lr_item_text_check_data->language && ') has been found but should not exist.' ).
              continue.
            endif.

            if not ( lr_item_text_check_data->text_reference is initial and lt_lines[] is initial      " in case text is empty and also no line was created in text
              or lines( lt_lines[] ) > 0 and lt_lines[ 1 ]-tdline = lr_item_text_check_data->text_reference ).
              ev_check_status = abap_false.
              me->mo_run_environment->append_log( 'Error: Item text entry is not equal to reference (id = ' && lr_item_text_check_data->text_id && ', language = ' && lr_item_text_check_data->language && ').' ).
              me->mo_run_environment->append_log( 'Reference text: ' && lr_item_text_check_data->text_reference ).
              if lt_lines[] is initial.
                me->mo_run_environment->append_log( 'Actual text is empty.' ).
              else.
                me->mo_run_environment->append_log( 'Actual text:' && lt_lines[ 1 ]-tdline ).
              endif.
            endif.
          endloop.
        endif.

        " Check schedule line data.
        loop at lr_item_check_data->sline_check_data reference into data(lr_sline_check_data).
          clear lt_vbep_sample.
          me->mo_run_environment->append_log( iv_log_statement = sy-tabix && ' sline check ( ' && lr_sline_check_data->description && ' ).' ).

          " Prepare sline data with dynamic dates
          loop at lr_sline_check_data->dynamic_dates reference into data(lr_dynamic_date_sline).
            check lr_dynamic_date_sline->date_field_name is not initial.
            loop at lr_sline_check_data->check_conditions reference into data(lr_sline_check_condition) where field_name = lr_dynamic_date_sline->date_field_name.
              lv_date = sy-datum + lr_dynamic_date_sline->offset_in_days.
              lr_sline_check_condition->value = lv_date.
            endloop.
          endloop.

          " get vbep entries by sline id or selection criteria
          if lr_sline_check_data->sline_id is initial.
            loop at lt_vbep assigning field-symbol(<fs_vbep>) where posnr = <fs_vbap_sample>-posnr.
              data(lv_vbep_valid) = abap_true.
              loop at lr_sline_check_data->dynamic_selection_key assigning field-symbol(<fs_sline_dynamic_select_key>).
                if evaluate_check_condition( is_data = <fs_vbep> is_condition = <fs_sline_dynamic_select_key> iv_verbose_mode = abap_false ) = abap_false.
                  lv_vbep_valid = abap_false.
                endif.
                if lv_vbep_valid = abap_true.
                  insert <fs_vbep> into table lt_vbep_sample.
                endif.
              endloop.
            endloop.
          else.
            "if line_exists( lt_vbep[ posnr = lr_item_check_data->item_id etenr = lr_sline_check_data->sline_id ] ).
            if line_exists( lt_vbep[ posnr = <fs_vbap_sample>-posnr etenr = lr_sline_check_data->sline_id ] ).
              "insert lt_vbep[ posnr = lr_item_check_data->item_id etenr = lr_sline_check_data->sline_id ] into table lt_vbep_sample.
              insert lt_vbep[ posnr = <fs_vbap_sample>-posnr etenr = lr_sline_check_data->sline_id ] into table lt_vbep_sample.
            endif.
          endif.

          " check if at least one vbap entry is found
          if lt_vbep_sample is initial.
            if lr_sline_check_data->sline_id is initial.
              me->mo_run_environment->append_log( iv_log_statement = 'Warning: No VBEP entry found for sline_check_data selection criteria.' ).
            else.
              ev_check_status = abap_false.
              me->mo_run_environment->append_log( iv_log_statement = 'Error: No VBEP entry found for sline_check_data selection criteria.' ).
            endif.
          endif.

          loop at lt_vbep_sample assigning field-symbol(<fs_vbep_sample>).
            me->mo_run_environment->append_log( iv_log_statement = 'Comparing to VBEP entry with etenr = ' && <fs_vbep_sample>-etenr && '.' ).
            loop at lr_sline_check_data->check_conditions assigning field-symbol(<fs_sline_check_condition>).
              if evaluate_check_condition( is_data = <fs_vbep_sample> is_condition = <fs_sline_check_condition> ) = abap_false.
                ev_check_status = abap_false.
              endif.
            endloop.
          endloop.
        endloop.
      endloop.
    endloop.
  endmethod.


  method check_configuration.

    data: lv_vbeln                 type vbeln,
          ls_testdata              type ty_gs_so_config_check_data,
          ls_document_id           like line of ev_document_id,
          lt_sales_key             type table of sales_key,
          lv_cuobj                 type cuobj,
          lv_compare_to_cuobj      type cuobj,
          lv_statement             type string,
          lv_objnr                 type objnr,
          lv_is_fixed              type abap_bool,
          lv_inact                 type abap_bool,
          lt_configuration         type standard table of conf_out,
          lt_configuration_compare type standard table of conf_out,
          lv_step_no               type i.


    ev_check_status = abap_true.

    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = ls_step_data
      importing
        es_testdata  = ls_testdata ).

    loop at ls_testdata-item_check_data assigning field-symbol(<ls_item_check_data>).
      "read cuobj
      read table ls_step_data-reference_step into lv_step_no index <ls_item_check_data>-rel_step_no.
      if sy-subrc = 0.
        get_cuobj(
          exporting
            iv_step_number = lv_step_no
            iv_item_id     = <ls_item_check_data>-item_id
          importing
            ev_cuobj       = lv_cuobj
            ev_document_id = lv_vbeln
            ev_success     = ev_check_status ).
        if ev_check_status = abap_false.
          return.
        endif.
      else.
        lv_statement = 'Error: Corresponding relative step not maintained.'.
        me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
        ev_check_status = abap_false.
        return.
      endif.

      "Check if configuration is fixed
      if <ls_item_check_data>-is_fixed <> abap_undefined.
        clear: lv_objnr, lv_is_fixed.
        select single objnr from vbap where vbeln = @lv_vbeln and posnr = @<ls_item_check_data>-item_id into @lv_objnr.
        if lv_objnr is not initial.
          select single inact from jest where objnr = @lv_objnr and stat = 'I0444' into @lv_inact.
          if sy-subrc = 0 and lv_inact is initial.
            lv_is_fixed = abap_true.
          endif.
        endif.
        if lv_is_fixed <> <ls_item_check_data>-is_fixed.
          lv_statement = 'Error: Did not pass the check regarding the fixing of the configuration.'.
          me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
          ev_check_status = abap_false.
          return.
        endif.
      endif.

      "Check variant condition

      if <ls_item_check_data>-variant_condition is not initial.
        select single 1 from vbak inner join prcd_elements
          on vbak~knumv = prcd_elements~knumv
          where vbeln = @lv_vbeln and prcd_elements~kposn = @<ls_item_check_data>-item_id and
          prcd_elements~varcond = @<ls_item_check_data>-variant_condition into @data(lv_dummy).
        if sy-subrc <> 0.
          lv_statement = 'Error: Variant condition not maintained'.
          me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
          ev_check_status = abap_false.
          return.
        endif.
      endif.


      "Read second configuration for comparision and compare accordingly

      if <ls_item_check_data>-compare_to_rel_step_no is not initial and <ls_item_check_data>-compare_to_item_id is not initial.
        read table ls_step_data-reference_step into lv_step_no index <ls_item_check_data>-compare_to_rel_step_no.
        if sy-subrc = 0.
          get_cuobj(
            exporting
              iv_step_number = lv_step_no
              iv_item_id     = <ls_item_check_data>-compare_to_item_id
            importing
              ev_cuobj       = lv_compare_to_cuobj
              ev_success     = ev_check_status ).
          if ev_check_status = abap_false.
            return.
          endif.
        else.
          lv_statement = 'Error: Corresponding relative step not maintained.'.
          me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
          ev_check_status = abap_false.
          return.
        endif.

        "Compare cuobj
        if <ls_item_check_data>-config_id_operator is not initial.
          case <ls_item_check_data>-config_id_operator.
            when '='.
              if lv_cuobj <> lv_compare_to_cuobj.
                lv_statement = 'Error: Configuration IDs are not the same.'.
                me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
                ev_check_status = abap_false.
                return.
              endif.
            when '<>'.
              if lv_cuobj = lv_compare_to_cuobj.
                lv_statement = 'Error: Configuration IDs are the same.'.
                me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
                ev_check_status = abap_false.
                return.
              endif.
          endcase.
        endif.

        "Compare configuration
        if <ls_item_check_data>-config_values_operator is not initial.
          call function 'VC_I_GET_CONFIGURATION'
            exporting
              instance            = lv_cuobj
            tables
              configuration       = lt_configuration
            exceptions
              instance_not_found  = 1
              internal_error      = 2
              no_class_allocation = 3
              instance_not_valid  = 4
              others              = 5.
          if sy-subrc <> 0.
            lv_statement = 'Error: Could not read configuration.'.
            me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
            ev_check_status = abap_false.
            return.
          endif.
          sort lt_configuration by atnam.
          call function 'VC_I_GET_CONFIGURATION'
            exporting
              instance            = lv_compare_to_cuobj
            tables
              configuration       = lt_configuration_compare
            exceptions
              instance_not_found  = 1
              internal_error      = 2
              no_class_allocation = 3
              instance_not_valid  = 4
              others              = 5.
          if sy-subrc <> 0.
            lv_statement = 'Error: Could not read configuration.'.
            me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
            ev_check_status = abap_false.
            return.
          endif.
          sort lt_configuration_compare by atnam.

          case <ls_item_check_data>-config_values_operator.
            when '='.
              if lt_configuration <> lt_configuration_compare.
                lv_statement = 'Error: Configuration values are not the same.'.
                me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
                ev_check_status = abap_false.
                return.
              endif.
            when '<>'.
              if lt_configuration = lt_configuration_compare.
                lv_statement = 'Error: Configuration values are the same.'.
                me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
                ev_check_status = abap_false.
                return.
              endif.
          endcase.
        endif.
      endif.
    endloop.
  endmethod.


  method check_doc_apm_status.

    data: testdata               type ty_gs_ptf_sd_check_apm,
          error_message          type bapi_msg,
          sales_document_numbers type cl_ptf_util=>ty_vbeln_tab,
          var_step               type string.
    data(step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    ev_check_status = abap_false.

    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = step_data
      importing
        es_testdata  = testdata ).

    check testdata is not initial.

    loop at step_data-reference_step assigning field-symbol(<ref_step>).
      data(ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      append lines of ptf_keys to sales_document_numbers.
    endloop.

    read table testdata-vbak assigning field-symbol(<vbak>) index 1.

    loop at sales_document_numbers assigning field-symbol(<document>).
      select single * from vbak where vbeln = @<document>-vbeln into @data(doc_data).
      if doc_data-apm_approval_status = <vbak>-apm_approval_status.
        ev_check_status = abap_true.
      endif.
    endloop.

** Output in case of success
    if ev_check_status eq abap_true.
      ev_execution_status = abap_true.
      var_step = step_data-step_number.
      concatenate 'The values of the checked document are correct. Process step is:' var_step   into error_message separated by space.
      me->mo_run_environment->append_log( iv_log_statement = |{ error_message }| ).
    else.
      ev_execution_status = abap_true.
      var_step = step_data-step_number.
      concatenate 'The values of the checked document are NOT correct. Process step is:' var_step   into error_message separated by space.
      me->mo_run_environment->append_log( iv_log_statement = |{ error_message }| ).
    endif.
  endmethod.


  method check_epay.

    data:
      lt_testdata     type ty_gt_ptf_so_check_epay,
      lv_statement    type bapi_msg,
      lv_vbeln        type vbeln,
      ls_vbak         type vbak,
      lt_sales_key    type table of sales_key,
      lv_check_status type abap_bool,
      lv_step_success type abap_bool.

    field-symbols: <fs_testdata_epay> type ty_gs_ptf_so_check_epay,
                   <fs_fpltc>         type fpltc.

    ev_check_status = abap_true.

* ----------------------------------------------- get test data -----
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = ls_step_data
      importing
        es_testdata  = lt_testdata ).

* --------------- get sales document number from reference step -----
    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_sales_key.
    endloop.
    clear lv_vbeln.
    read table lt_sales_key into lv_vbeln index 1.
    if lv_vbeln is initial.
      lv_statement = 'Error: No sales order found.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      ev_check_status = abap_false.
      return. " check fails
    endif.
    ls_step_data-document_id = lt_sales_key.

    " read tables
    select single * from vbak into @ls_vbak where vbeln = @lv_vbeln.
    if sy-subrc <> 0.
      me->mo_run_environment->append_log( iv_log_statement = 'Error: VBAK entry for vbeln = ' && lv_vbeln && ' does not exist.' ).
      ev_check_status = abap_false.
      return.
    endif.

* ----------------------------------- check epay data -----
    lv_check_status = abap_true.

    select * from fpltc into table @data(lt_fpltc) where fplnr = @ls_vbak-rplnr.

    loop at lt_testdata assigning <fs_testdata_epay>.

      read table lt_fpltc with key fpltr = <fs_testdata_epay>-fpltr assigning <fs_fpltc>.
      if sy-subrc <> 0 .
        ev_check_status = abap_false.
        continue.
      endif .
      loop at <fs_testdata_epay>-check_conditions assigning field-symbol(<fs_epay_check_condition>).
        if evaluate_check_condition( is_data = <fs_fpltc> is_condition = <fs_epay_check_condition> ) = abap_false.
          ev_check_status = abap_false.
        endif.
      endloop.
    endloop.

* Output in case of success
    if ev_check_status = abap_true.
      lv_statement = 'Success: all fplt entries processed sucessfully.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      ev_execution_status = abap_true.
    else.
      lv_statement = 'Error: not all fplt entries processed successfully.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    endif.

  endmethod.


  method check_existence.
    data: lv_vbeln type vbeln.

    move iv_id to lv_vbeln.

    select single * from vbak where vbeln = @lv_vbeln into @data(ls_order).
    if sy-subrc <> 0.
      me->mo_run_environment->append_log( iv_log_statement = |Order { lv_vbeln } does not exist.| ).
      rv_exists = abap_false.
    else.
      rv_exists = abap_true.
    endif.

  endmethod.


  method check_ic_so4_goal_change.

    data: lv_vbeln type vbeln.
    data: lt_vbeln type tdt_vbeln.
    data: lv_auart type auart.
    data: lv_error type abap_bool.

    data: lo_access type ref to if_goal_access.
    data: lv_bo_key type if_goal_types=>tcd_bo_key.
    data: lx_goal_exc type ref to cx_goal_exc.
    data: lv_text_exc type string.

    data: ls_item_data type tds_goal_so_item.
    data: ls_item_prev type tds_goal_so_item.
    data: lt_item_data type standard table of tds_goal_so_item.
    data: lt_item_dflt type standard table of tds_goal_so_item.
    data: ls_field_property type if_goal_types=>tcs_object_property.
    data: lt_field_property type if_goal_types=>tct_object_property.
    data: ls_changed_field type if_goal_types=>tcs_changed_field.
    data: lv_create_enabled type abap_bool.


    ev_check_status       = abap_false.
    ev_execution_status   = abap_false.

    loop at is_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_vbeln.
    endloop.

    if lt_vbeln is initial.
      me->mo_run_environment->append_log( |No sales order found from reference step| ).
      return.
    endif.

    lv_error = abap_false.

    data(lo_ic_util) = cl_sd_sls_ic_factory=>so_instance->get_instance_util( ).

    loop at lt_vbeln into lv_vbeln.

      clear lv_auart.
      select single auart from vbak into lv_auart where vbeln = lv_vbeln.
      if lv_auart is not initial.
        data(lv_dco) = lo_ic_util->is_so_of_delivering_company( lv_auart ).
      endif.
      if lv_dco = abap_false.
        me->mo_run_environment->append_log( | { lv_auart } is not document type for SO4 and would not be checked| ).
        continue.
      endif.

      clear lo_access.

      do.
*     try to open the document in change mode
        try.
            lv_bo_key = lv_vbeln.
            call method cl_goal_api=>so_instance->open
              exporting
                iv_bo_id  = if_goal_sdoc=>co_bo_id-salesorder
                iv_bo_key = lv_bo_key
              receiving
                ro_access = lo_access.
          catch cx_goal_exc into lx_goal_exc.
            lv_text_exc = lx_goal_exc->get_text( ).
            me->mo_run_environment->append_log( `Document cannot be opened. No check possible` ).
            exit.
        endtry.

*     read the list of items and its properties
        call method lo_access->get_entity_set
          exporting
            iv_entity_id      = if_goal_sdoc_item=>co_entity_id
          importing
            et_entity_data    = lt_item_data
            et_entity_dflt    = lt_item_dflt
            et_field_property = lt_field_property.

*     check if create_enabled indicator is false
        if lt_item_dflt is initial.
          lv_create_enabled = abap_false.
        else.
          try.
              lv_create_enabled = lt_field_property[ handle = lt_item_dflt[ 1 ]-handle ]-update_enabled.
            catch cx_sy_itab_line_not_found.
              lv_create_enabled = abap_false.
          endtry.
        endif.
        if lv_create_enabled eq abap_true.
          me->mo_run_environment->append_log( `Error: Items of SO4 { lv_vbeln } are create-enabled` ).
          lv_error = abap_true.
          exit.
        endif.

        if lt_item_data is not initial.

*       try to create a new item
          clear ls_item_data.
          ls_item_data-handle = cl_goal_util=>so_instance->create_guid( ).
          ls_item_data-material_id = lt_item_data[ 1 ]-material_id.
          ls_item_data-order_qty = lt_item_data[ 1 ]-order_qty.
          clear ls_changed_field.
          ls_changed_field-handle = ls_item_data-handle.
          insert conv #( 'MATERIAL_ID' ) into table ls_changed_field-field.
          insert conv #( 'ORDER_QTY' ) into table ls_changed_field-field.

          call method lo_access->set_entity
            exporting
              iv_entity_id     = if_goal_sdoc_item=>co_entity_id
              is_entity_data   = ls_item_data
              is_changed_field = ls_changed_field.

          call method lo_access->get_entity
            exporting
              iv_handle      = ls_item_data-handle
            importing
              es_entity_data = ls_item_data.

          if ls_item_data is not initial.
            me->mo_run_environment->append_log( `Error: Items of SO4 { lv_vbeln } are create-enabled` ).
            lv_error = abap_true.
            exit.
          endif.

*       try to delete an item
          lo_access->del_entity(
            exporting
              iv_handle  = lt_item_data[ 1 ]-handle
            importing
              ev_deleted = data(lv_deleted) ).

          call method lo_access->get_entity
            exporting
              iv_handle      = lt_item_data[ 1 ]-handle
            importing
              es_entity_data = ls_item_data.

          if lv_deleted eq abap_true or ls_item_data is initial.
            me->mo_run_environment->append_log( `Error: Item of SO4 { lv_vbeln } is deletable ` ).
            lv_error = abap_true.
            exit.
          endif.

*       try to change quantity of item
          ls_item_prev = lt_item_data[ 1 ].
          clear ls_item_data.
          ls_item_data = ls_item_prev.
          ls_item_data-order_qty = ls_item_data-order_qty + 1.
          clear ls_changed_field.
          ls_changed_field-handle = ls_item_data-handle.
          insert conv #( 'ORDER_QTY' ) into table ls_changed_field-field.

          call method lo_access->set_entity
            exporting
              iv_entity_id     = if_goal_sdoc_item=>co_entity_id
              is_entity_data   = ls_item_data
              is_changed_field = ls_changed_field.

          call method lo_access->get_entity
            exporting
              iv_handle      = ls_item_data-handle
            importing
              es_entity_data = ls_item_data.

          if ls_item_data-order_qty ne ls_item_prev-order_qty.
            me->mo_run_environment->append_log( `Error: Order Quantity of SO4 { lv_vbeln } can be changed` ).
            lv_error = abap_true.
            exit.
          endif.

        endif.

*     try to delete complete document
        lo_access->delete( iv_synchron = abap_true ).
        select count(*) from vbak into @data(lv_count) where vbeln = @lv_vbeln.
        if lv_count = 0.
          me->mo_run_environment->append_log( `Error: SO4 { lv_vbeln } can be deleted` ).
          lv_error = abap_true.
          exit.
        endif.

        exit.

      enddo.

      if lo_access is not initial.
        lo_access->close( ).
      endif.

    endloop.

    if lv_error eq abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |Error occurred. Details see in log above| ).
    else.
      me->mo_run_environment->append_log( iv_log_statement = |Success: SO4 successfully checked| ).
      ev_check_status = abap_true.
      ev_execution_status = abap_true.
    endif.

  endmethod.


  method check_ifrs15_bundle.

    data: lv_vbeln     type vbeln.

    data:
      lt_sales_key      type table of sales_key,
      lv_cuobj          type cuobj,
      lv_statement      type string,
      lv_netwr          type vbap-netwr,
      lt_fins_trr_alloc type fins_trr_alloc_t.

    data(lv_ref_step_number) =  is_step_data-reference_step[ 1 ] .

    data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = lv_ref_step_number ).
    append lines of lt_ptf_keys to lt_sales_key.

    if lt_sales_key is initial.
      lv_statement = 'Error: Referenced sales document for configuration not found.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      return.
    endif.
    lv_vbeln = lt_sales_key[ 1 ]-vbeln.

    ev_check_status = abap_true.

    select * from fins_trr_alloc into table @lt_fins_trr_alloc where sales_order = @lv_vbeln and sales_order_item = '000010'.

    if lines( lt_fins_trr_alloc ) = 3.
      loop at lt_fins_trr_alloc assigning field-symbol(<fs_fins_trr_alloc>).
        if <fs_fins_trr_alloc>-trans_price < 0 .
          ev_check_status = abap_true.
        endif.
      endloop.
    else.
      ev_check_status = abap_false.
    endif.

  endmethod.


  method check_item_spm.
    data: lv_vbeln          type vbeln,
          ls_testdata       type ty_gs_so_check_data,
          lt_vbap_sample    type table of vbap,
          lt_vbep_sample    type table of vbep,
          lc_posnr_initial  type posnr value '000000',
          lv_date           like sy-datum,
          ls_result_key     type cl_ptf_util=>ty_result_key_data,
          lt_lines          type standard table of tline,
          lt_inlines        type standard table of tline,
          ls_suppl_data     type lty_suppl_data,
          lt_suppl_data     type ltty_suppl_data,
          lv_immediate_exit type abap_bool.

    field-symbols:
      <fs_vbkd> type vbkd,
      <fs_vbpa> type vbpa,
      <fs_adrc> type adrc.

    ev_check_status = abap_true.

    " get sample vbeln
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    if lines( ls_step_data-reference_step ) = 1.
      data(ls_reference_step) = me->mo_run_environment->get_step_data( iv_step_number = ls_step_data-reference_step[ 1 ] ).
      if ls_reference_step-document_id is not initial.
        lv_vbeln = ls_reference_step-document_id[ 1 ].
      endif.
    else.
      data(lt_result_key_data) =  me->mo_run_environment->get_result_key_data( it_step_number =  ls_step_data-reference_step ) .
      loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
        read table lt_result_key_data with key step_number = <lv_ref_step> into ls_result_key.
        case ls_result_key-bus_obj .
          when 'SO'.
            data(lt_vbeln) =  me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
            if lt_vbeln is not initial .
              lv_vbeln = lt_vbeln[ 1 ].
            endif.
          when 'ENTERPRISE_PROJECT' .
            data(lt_wbs) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
        endcase.
      endloop.
    endif.
    if lv_vbeln is initial.
      me->mo_run_environment->append_log( iv_log_statement = 'Error: No document id provided by reference step' ).
      ev_check_status = abap_false.
      return.
    endif.

    " get check data
    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = ls_step_data
      importing
        es_testdata  = ls_testdata ).

    " run custom dynamic checks
    if ls_testdata-dynamic_custom_checks is not initial.
      ev_check_status = me->run_custom_dynamic_checks(
        exporting
          iv_step_number          = iv_step_number
          it_dynamic_code         = ls_testdata-dynamic_custom_checks
        importing
          ev_immediate_exit       = lv_immediate_exit
        changing
          cs_salesorder_test_data = ls_testdata
      ).
      check lv_immediate_exit = abap_false.
    endif.

    if not lt_wbs is initial .
      merge_wbs_into_item(
        exporting
          it_wbs                  = lt_wbs
        importing
          ev_error                = data(lv_error)
        changing
          cs_salesorder_checkdata = ls_testdata ).

      if lv_error = abap_true.
        exit.
      endif.
    endif.

    " read tables
    select single * from vbak into @data(ls_vbak) where vbeln = @lv_vbeln.
    if sy-subrc <> 0.
      me->mo_run_environment->append_log( iv_log_statement = 'Error: VBAK entry for vbeln = ' && lv_vbeln && ' does not exist.' ).
      ev_check_status = abap_false.
      return.
    endif.
    select * from vbap into table @data(lt_vbap) where vbeln = @lv_vbeln.
    select * from vbep into table @data(lt_vbep) where vbeln = @lv_vbeln.
    select * from vbpa into table @data(lt_vbpa) where vbeln = @lv_vbeln.
    select * from vbkd into table @data(lt_vbkd) where vbeln = @lv_vbeln.
    if lt_vbpa[] is not initial.
      select * from adrc into table @data(lt_adrc) for all entries in @lt_vbpa where addrnumber = @lt_vbpa-adrnr.
    endif.
    select * from prcd_elements into table @data(lt_prcd_elememts) where knumv = @ls_vbak-knumv.

    "Read condition supplement data
    loop at lt_prcd_elememts reference into data(lr_prcd_elememts)
         where common_suppl_data eq abap_true.
      clear ls_suppl_data.
      data(lv_suppl_data_guid) = cl_prc_suppl_data_factory=>factory->get_handler_by_knumv( ls_vbak-knumv )->get_db_guid(
                                                                                                              iv_knumv = lr_prcd_elememts->knumv
                                                                                                              iv_kposn = lr_prcd_elememts->kposn
                                                                                                              iv_kschl = lr_prcd_elememts->kschl
                                                                                                              iv_stunr = lr_prcd_elememts->stunr
                                                                                                              iv_zaehk = lr_prcd_elememts->zaehk ).
      check lv_suppl_data_guid is not initial.
      ls_suppl_data-konv_suppl_data = cl_prc_suppl_data_factory=>factory->get_handler_by_knumv( ls_vbak-knumv )->get_suppl_data( lv_suppl_data_guid ).
      check ls_suppl_data-konv_suppl_data is not initial.
      ls_suppl_data-kposn = lr_prcd_elememts->kposn.
      ls_suppl_data-kschl = lr_prcd_elememts->kschl.
      insert ls_suppl_data into table lt_suppl_data.
    endloop.

    " Prepare header data with dynamic dates
    loop at ls_testdata-dynamic_dates reference into data(lr_dynamic_date_head).
      check lr_dynamic_date_head->date_field_name is not initial.
      split lr_dynamic_date_head->date_field_name at '-' into data(lv_table_name) data(lv_field_name).
      if lv_field_name is initial.
        lv_field_name = lv_table_name.
        lv_table_name = ''.
      endif.
      check lv_field_name is not initial.

      case lv_table_name.
        when 'VBAK' or 'vbak' or ''.
          loop at ls_testdata-head_check_conditions reference into data(lr_head_check_condition) where field_name = lr_dynamic_date_head->date_field_name.
            lv_date = sy-datum + lr_dynamic_date_head->offset_in_days.
            lr_head_check_condition->value = lv_date.
          endloop.
        when 'VBKD' or 'vbkd'.
          loop at ls_testdata-business_data_check_conditions reference into data(lr_business_data_check_cond) where field_name = lr_dynamic_date_head->date_field_name.
            lv_date = sy-datum + lr_dynamic_date_head->offset_in_days.
            lr_business_data_check_cond->value = lv_date.
          endloop.
      endcase.

    endloop.

    " Check header data
    loop at ls_testdata-head_check_conditions assigning field-symbol(<fs_head_check_condition>).
      if evaluate_check_condition( is_data = ls_vbak is_condition = <fs_head_check_condition> ) = abap_false.
        ev_check_status = abap_false.
      endif.
    endloop.

    " Check business data on header level
    assign lt_vbkd[ posnr = lc_posnr_initial ] to <fs_vbkd>.
    loop at ls_testdata-business_data_check_conditions assigning field-symbol(<fs_head_bd_check_condition>).
      if evaluate_check_condition( is_data = <fs_vbkd> is_condition = <fs_head_bd_check_condition> ) = abap_false.
        ev_check_status = abap_false.
      endif.
    endloop.

    " Check partner data on header level
    loop at ls_testdata-partner_check_data reference into data(lr_partner_check_data_head).
      if line_exists( lt_vbpa[ posnr = lc_posnr_initial parvw = lr_partner_check_data_head->partner_function ] ).
        assign lt_vbpa[ posnr = lc_posnr_initial parvw = lr_partner_check_data_head->partner_function ] to <fs_vbpa>.
        loop at lr_partner_check_data_head->check_conditions assigning field-symbol(<fs_partner_check_condition_h>).
          if evaluate_check_condition( is_data = <fs_vbpa> is_condition = <fs_partner_check_condition_h> ) = abap_false.
            ev_check_status = abap_false.
          endif.
        endloop.
        unassign <fs_adrc>.
        assign lt_adrc[ addrnumber = <fs_vbpa>-adrnr ] to <fs_adrc>.
        if sy-subrc = 0.
          loop at lr_partner_check_data_head->check_address_conditions assigning field-symbol(<fs_address_check_condition_h>).
            if evaluate_check_condition( is_data = <fs_adrc> is_condition = <fs_address_check_condition_h> ) = abap_false.
              ev_check_status = abap_false.
            endif.
          endloop.
        else.
          me->mo_run_environment->append_log( |'Error: Address details not found for address number { <fs_vbpa>-adrnr } from VBPA| ).
          ev_check_status = abap_false.
        endif.
      else.
        me->mo_run_environment->append_log( iv_log_statement = 'Error: VBPA entry for partner function ''' && lr_partner_check_data_head->partner_function && ''' does not exist.' ).
        ev_check_status = abap_false.
      endif.
    endloop.

    " Check head texts
    if ls_testdata-text_check_data is not initial.
      me->mo_run_environment->append_log( 'Comparing header text with reference).' ).
      loop at ls_testdata-text_check_data reference into data(lr_head_text_check_data).
        call function 'READ_TEXT_INLINE'
          exporting
            id              = lr_head_text_check_data->text_id  "Text ID of text to be read
            inline_count    = 2                            " Number of lines for inline table
            language        = lr_head_text_check_data->language      " Language of text to be read
            name            = conv tdobname( lv_vbeln && '' )             " Name of text to be read
            object          = conv tdobject( 'VBBK' ) "Object of text to be read
          tables
            inlines         = lt_inlines[]     "
            lines           = lt_lines[]       " Lines of text read
          exceptions
            id              = 1                " Text ID invalid
            language        = 2                " Invalid language
            name            = 3                " Invalid text name
            not_found       = 4                " Text not found
            object          = 5                " Invalid text object
            reference_check = 6                " Reference chain cancelled
            others          = 7.
        if sy-subrc <> 0.
          if lr_head_text_check_data->check_no_entry = abap_false.
            ev_check_status = abap_false.
            me->mo_run_environment->append_log( 'Error: No head text entry found for (id = ' && lr_head_text_check_data->text_id && ', language = ' && lr_head_text_check_data->language && ').' ).
          endif.
        elseif lr_head_text_check_data->check_no_entry = abap_true.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( 'Error: An entry for (id = ' && lr_head_text_check_data->text_id && ', language = ' && lr_head_text_check_data->language && ') has been found but should not exist.' ).
          continue.
        endif.

        if not ( lr_head_text_check_data->text_reference is initial and lt_lines[] is initial     " in case text is empty and also no line was created in text
          or lines( lt_lines[] ) > 0 and lt_lines[ 1 ]-tdline = lr_head_text_check_data->text_reference ).
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( 'Error: Head text entry is not equal to reference (id = ' && lr_head_text_check_data->text_id && ', language = ' && lr_head_text_check_data->language && ').' ).
          me->mo_run_environment->append_log( 'Reference text: ' && lr_head_text_check_data->text_reference ).
          if lt_lines[] is initial.
            me->mo_run_environment->append_log( 'Actual text is empty.' ).
          else.
            me->mo_run_environment->append_log( 'Actual text:' && lt_lines[ 1 ]-tdline ).
          endif.
        endif.
      endloop.
    endif.

    " Check item data
    loop at ls_testdata-item_check_data reference into data(lr_item_check_data).
      clear lt_vbap_sample.
      me->mo_run_environment->append_log( iv_log_statement = sy-tabix && ' item check ( ' && lr_item_check_data->description && ' ).' ).

      " Prepare item data with dynamic dates
      loop at lr_item_check_data->dynamic_dates reference into data(lr_dynamic_date_item).
        check lr_dynamic_date_item->date_field_name is not initial.
        split lr_dynamic_date_item->date_field_name at '-' into lv_table_name lv_field_name.
        if lv_field_name is initial.
          lv_field_name = lv_table_name.
          lv_table_name = ''.
        endif.
        check lv_field_name is not initial.

        case lv_table_name.
          when 'VBAK' or 'vbak' or ''.
            loop at lr_item_check_data->check_conditions reference into data(lr_item_check_condition) where field_name = lv_field_name.
              lv_date = sy-datum + lr_dynamic_date_item->offset_in_days.
              lr_item_check_condition->value = lv_date.
            endloop.
          when 'VBKD' or 'vbkd'.
            loop at lr_item_check_data->business_data_check_conditions reference into lr_business_data_check_cond where field_name = lv_field_name.
              lv_date = sy-datum + lr_dynamic_date_head->offset_in_days.
              lr_business_data_check_cond->value = lv_date.
            endloop.
        endcase.
      endloop.

      " get vbap entries by item id or selection criteria
      if lr_item_check_data->item_id is initial.
        loop at lt_vbap assigning field-symbol(<fs_vbap>).
          data(lv_vbap_valid) = abap_true.
          loop at lr_item_check_data->dynamic_selection_key assigning field-symbol(<fs_item_dynamic_select_key>).
            if evaluate_check_condition( is_data = <fs_vbap> is_condition = <fs_item_dynamic_select_key> iv_verbose_mode = abap_false ) = abap_false.
              lv_vbap_valid = abap_false.
            endif.
          endloop.
          if lv_vbap_valid = abap_true.
            insert <fs_vbap> into table lt_vbap_sample.
          endif.
        endloop.
      else.
        if line_exists( lt_vbap[ posnr = lr_item_check_data->item_id ] ).
          insert lt_vbap[ posnr = lr_item_check_data->item_id ] into table lt_vbap_sample.
        endif.
      endif.

      " check if at least one vbap entry is found
      if lt_vbap_sample is initial.
        if lr_item_check_data->item_id is initial.
          me->mo_run_environment->append_log( iv_log_statement = 'Warning: No VBAP entry found for item_check_data selection criteria.' ).
        else.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = 'Error: No VBAP entry found for item_check_data selection criteria.' ).
        endif.
      endif.

      loop at lt_vbap_sample assigning field-symbol(<fs_vbap_sample>).
        me->mo_run_environment->append_log( iv_log_statement = 'Comparing to VBAP / VBKD / VBPA entry with posnr = ' && <fs_vbap_sample>-posnr && '.' ).
        loop at lr_item_check_data->check_conditions assigning field-symbol(<fs_item_check_condition>).
          if evaluate_check_condition( is_data = <fs_vbap_sample> is_condition = <fs_item_check_condition> ) = abap_false.
            ev_check_status = abap_false.
          endif.
        endloop.

        " Check business data on item level
        if lr_item_check_data->business_data_check_conditions is not initial.
          assign lt_vbkd[ posnr = lc_posnr_initial ] to <fs_vbkd>.
          if line_exists( lt_vbkd[ posnr = <fs_vbap_sample>-posnr ] ).
            assign lt_vbkd[ posnr = <fs_vbap_sample>-posnr ] to <fs_vbkd>.
          endif.
          loop at lr_item_check_data->business_data_check_conditions assigning field-symbol(<fs_item_bd_check_condition>).
            if evaluate_check_condition( is_data = <fs_vbkd> is_condition = <fs_item_bd_check_condition> ) = abap_false.
              ev_check_status = abap_false.
            endif.
          endloop.
        endif.

        " Check partner data on item level
        loop at lr_item_check_data->partner_check_data reference into data(lr_partner_check_data_item).
          unassign <fs_vbpa>.
          if line_exists( lt_vbpa[ posnr = <fs_vbap_sample>-posnr parvw = lr_partner_check_data_item->partner_function ] ).
            assign lt_vbpa[ posnr = <fs_vbap_sample>-posnr parvw = lr_partner_check_data_item->partner_function ] to <fs_vbpa>.
          elseif line_exists( lt_vbpa[ posnr = lc_posnr_initial parvw = lr_partner_check_data_item->partner_function ] ).
            assign lt_vbpa[ posnr = lc_posnr_initial parvw = lr_partner_check_data_item->partner_function ] to <fs_vbpa>.
          else.
            me->mo_run_environment->append_log( iv_log_statement = 'Error: VBPA entry for partner function ' && lr_partner_check_data_item->partner_function && ' does not exist.' ).
            ev_check_status = abap_false.
            continue.
          endif.
          loop at lr_partner_check_data_item->check_conditions assigning field-symbol(<fs_partner_check_condition_i>).
            if evaluate_check_condition( is_data = <fs_vbpa> is_condition = <fs_partner_check_condition_i> ) = abap_false.
              ev_check_status = abap_false.
            endif.
          endloop.
          unassign <fs_adrc>.
          assign lt_adrc[ addrnumber = <fs_vbpa>-adrnr ] to <fs_adrc>.
          if sy-subrc = 0.
            loop at lr_partner_check_data_item->check_address_conditions assigning field-symbol(<fs_address_check_condition_i>).
              if evaluate_check_condition( is_data = <fs_adrc> is_condition = <fs_address_check_condition_i> ) = abap_false.
                ev_check_status = abap_false.
              endif.
            endloop.
          else.
            me->mo_run_environment->append_log( |'Error: Address details not found for address number { <fs_vbpa>-adrnr } from VBPA| ).
            ev_check_status = abap_false.
          endif.
        endloop.

        " Check price condition on item level
        loop at lr_item_check_data->price_check_data reference into data(lr_price_check_data_item).
          assign lt_prcd_elememts[ kposn = <fs_vbap_sample>-posnr kschl = lr_price_check_data_item->kschl ]
            to field-symbol(<fs_prcd_element>).
          if sy-subrc <> 0.
            me->mo_run_environment->append_log( |'Error: { <fs_vbap_sample>-posnr } { lr_price_check_data_item->kschl } not found| ).
            ev_check_status = abap_false.
            continue.
          endif.
          loop at lr_price_check_data_item->check_conditions assigning field-symbol(<fs_price_check_condition_i>).
            if evaluate_check_condition( is_data = <fs_prcd_element> is_condition = <fs_price_check_condition_i> ) = abap_false.
              ev_check_status = abap_false.
            endif.
          endloop.
        endloop.

        " Check price condition supplement data on item level
        loop at lr_item_check_data->price_check_suppl_data reference into data(lr_price_check_suppl_data_item).
          assign lt_suppl_data[ kposn = <fs_vbap_sample>-posnr kschl = lr_price_check_suppl_data_item->kschl ]-konv_suppl_data
            to field-symbol(<fs_suppl_data>).
          if sy-subrc <> 0.
            me->mo_run_environment->append_log( |'Error: { <fs_vbap_sample>-posnr } { lr_price_check_suppl_data_item->kschl } not found| ).
            ev_check_status = abap_false.
            continue.
          endif.
          loop at lr_price_check_suppl_data_item->check_conditions assigning field-symbol(<fs_suppl_check_condition_i>).
            if evaluate_check_condition( is_data = <fs_suppl_data> is_condition = <fs_suppl_check_condition_i> ) = abap_false.
              ev_check_status = abap_false.
            endif.
          endloop.
        endloop.

        " Check item texts
        if lr_item_check_data->text_check_data is not initial.
          me->mo_run_environment->append_log( 'Comparing item text with reference).' ).
          loop at lr_item_check_data->text_check_data reference into data(lr_item_text_check_data).
            clear: lt_inlines[], lt_lines[].
            call function 'READ_TEXT_INLINE'
              exporting
                id              = lr_item_text_check_data->text_id  "Text ID of text to be read
                inline_count    = 2                            " Number of lines for inline table
                language        = lr_item_text_check_data->language      " Language of text to be read
                name            = conv tdobname( lv_vbeln && <fs_vbap_sample>-posnr && '' ) " Name of text to be read
                object          = conv tdobject( 'VBBP' ) "Object of text to be read
              tables
                inlines         = lt_inlines[]     "
                lines           = lt_lines[]       " Lines of text read
              exceptions
                id              = 1                " Text ID invalid
                language        = 2                " Invalid language
                name            = 3                " Invalid text name
                not_found       = 4                " Text not found
                object          = 5                " Invalid text object
                reference_check = 6                " Reference chain cancelled
                others          = 7.
            if sy-subrc <> 0.
              if lr_item_text_check_data->check_no_entry = abap_false.
                ev_check_status = abap_false.
                me->mo_run_environment->append_log( 'Error: No item text entry found for (id = ' && lr_item_text_check_data->text_id && ', language = ' && lr_item_text_check_data->language && ').' ).
              endif.
            elseif lr_item_text_check_data->check_no_entry = abap_true.
              ev_check_status = abap_false.
              me->mo_run_environment->append_log( 'Error: An entry for (id = ' && lr_item_text_check_data->text_id && ', language = ' && lr_item_text_check_data->language && ') has been found but should not exist.' ).
              continue.
            endif.

            if not ( lr_item_text_check_data->text_reference is initial and lt_lines[] is initial      " in case text is empty and also no line was created in text
              or lines( lt_lines[] ) > 0 and lt_lines[ 1 ]-tdline = lr_item_text_check_data->text_reference ).
              ev_check_status = abap_false.
              me->mo_run_environment->append_log( 'Error: Item text entry is not equal to reference (id = ' && lr_item_text_check_data->text_id && ', language = ' && lr_item_text_check_data->language && ').' ).
              me->mo_run_environment->append_log( 'Reference text: ' && lr_item_text_check_data->text_reference ).
              if lt_lines[] is initial.
                me->mo_run_environment->append_log( 'Actual text is empty.' ).
              else.
                me->mo_run_environment->append_log( 'Actual text:' && lt_lines[ 1 ]-tdline ).
              endif.
            endif.
          endloop.
        endif.

        " Check schedule line data.
        loop at lr_item_check_data->sline_check_data reference into data(lr_sline_check_data).
          clear lt_vbep_sample.
          me->mo_run_environment->append_log( iv_log_statement = sy-tabix && ' sline check ( ' && lr_sline_check_data->description && ' ).' ).

          " Prepare sline data with dynamic dates
          loop at lr_sline_check_data->dynamic_dates reference into data(lr_dynamic_date_sline).
            check lr_dynamic_date_sline->date_field_name is not initial.
            loop at lr_sline_check_data->check_conditions reference into data(lr_sline_check_condition) where field_name = lr_dynamic_date_sline->date_field_name.
              lv_date = sy-datum + lr_dynamic_date_sline->offset_in_days.
              lr_sline_check_condition->value = lv_date.
            endloop.
          endloop.

          " get vbep entries by sline id or selection criteria
          if lr_sline_check_data->sline_id is initial.
            loop at lt_vbep assigning field-symbol(<fs_vbep>) where posnr = <fs_vbap_sample>-posnr.
              data(lv_vbep_valid) = abap_true.
              loop at lr_sline_check_data->dynamic_selection_key assigning field-symbol(<fs_sline_dynamic_select_key>).
                if evaluate_check_condition( is_data = <fs_vbep> is_condition = <fs_sline_dynamic_select_key> iv_verbose_mode = abap_false ) = abap_false.
                  lv_vbep_valid = abap_false.
                endif.
                if lv_vbep_valid = abap_true.
                  insert <fs_vbep> into table lt_vbep_sample.
                endif.
              endloop.
            endloop.
          else.
            "if line_exists( lt_vbep[ posnr = lr_item_check_data->item_id etenr = lr_sline_check_data->sline_id ] ).
            if line_exists( lt_vbep[ posnr = <fs_vbap_sample>-posnr etenr = lr_sline_check_data->sline_id ] ).
              "insert lt_vbep[ posnr = lr_item_check_data->item_id etenr = lr_sline_check_data->sline_id ] into table lt_vbep_sample.
              insert lt_vbep[ posnr = <fs_vbap_sample>-posnr etenr = lr_sline_check_data->sline_id ] into table lt_vbep_sample.
            endif.
          endif.

          " check if at least one vbap entry is found
          if lt_vbep_sample is initial.
            if lr_sline_check_data->sline_id is initial.
              me->mo_run_environment->append_log( iv_log_statement = 'Warning: No VBEP entry found for sline_check_data selection criteria.' ).
            else.
              ev_check_status = abap_false.
              me->mo_run_environment->append_log( iv_log_statement = 'Error: No VBEP entry found for sline_check_data selection criteria.' ).
            endif.
          endif.

          loop at lt_vbep_sample assigning field-symbol(<fs_vbep_sample>).
            me->mo_run_environment->append_log( iv_log_statement = 'Comparing to VBEP entry with etenr = ' && <fs_vbep_sample>-etenr && '.' ).
            loop at lr_sline_check_data->check_conditions assigning field-symbol(<fs_sline_check_condition>).
              if evaluate_check_condition( is_data = <fs_vbep_sample> is_condition = <fs_sline_check_condition> ) = abap_false.
                ev_check_status = abap_false.
              endif.
            endloop.
          endloop.
        endloop.
      endloop.
    endloop.
  endmethod.


  method check_profitability_segment.

    data: lv_vbeln    type vbeln,
          ls_testdata type ty_gs_profseg_check_data.

    ev_check_status = abap_true.

    " get sample vbeln
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    if lines( ls_step_data-reference_step ) = 1.
      data(ls_reference_step) = me->mo_run_environment->get_step_data( iv_step_number = ls_step_data-reference_step[ 1 ] ).
      if ls_reference_step-document_id is not initial.
        lv_vbeln = ls_reference_step-document_id[ 1 ].
      endif.
    endif.
    if lv_vbeln is initial.
      me->mo_run_environment->append_log( iv_log_statement = 'Error: No document id provided by reference step' ).
      ev_check_status = abap_false.
      return.
    endif.

    " get check data
    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = ls_step_data
      importing
        es_testdata  = ls_testdata ).

    if ls_testdata-document_category is initial.
      ls_testdata-document_category = if_sd_doc_category=>order.
    endif.

    data: lt_copadata type copadata_tab.
    data: lt_vbap_sample type table of vbap.
    data: ls_profitability_key type ty_s_profitsegment_key.
    data: lv_internal_values   type char1 value 'X'.
    data: lv_msg type string.
    " Check item data
    loop at ls_testdata-item_check_data reference into data(lr_item_check_data).
      clear: ls_profitability_key.
      me->mo_run_environment->append_log( iv_log_statement = sy-tabix && ' item check ( ' && lr_item_check_data->description && ' ).' ).
      " get key to read copa data
      ls_profitability_key = get_profitsegment_key( iv_vbeln = lv_vbeln
                                                    iv_posnr = lr_item_check_data->item_id
                                                    iv_vbtyp = ls_testdata-document_category
                                                    ).
      if ls_profitability_key-bukrs is initial or
      ( ls_profitability_key-paobjnr =  if_fco_copa_paobjnr=>c_init  or
        ls_profitability_key-paobjnr =  if_fco_copa_paobjnr=>c_zero ).

        me->mo_run_environment->append_log( |COPA key information incomplete. BUKRS = { ls_profitability_key-bukrs }, PAOBJNR = { ls_profitability_key-paobjnr }  | ).
        ev_check_status = abap_false.
        continue.
      endif.
      " get copa data
      call function 'RKE_CONVERT_PAOBJNR_COPADATA'
        exporting
          bukrs           = ls_profitability_key-bukrs
          paobjnr         = ls_profitability_key-paobjnr
          internal_values = lv_internal_values
        tables
          i_copadata      = lt_copadata
        exceptions
          no_erkrs_found  = 1
          paobjnr_wrong   = 2
          others          = 3.
      if sy-subrc <> 0.
        message id sy-msgid type sy-msgty number sy-msgno
          with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
          into lv_msg.
        me->mo_run_environment->append_log( lv_msg ).
        ev_check_status = abap_false.
        continue.
      endif.
      " check profitability segment for item
      if evaluate_copa_data( it_copa = lt_copadata it_check_conditions = lr_item_check_data->check_conditions ) = abap_false.
        ev_check_status = abap_false.
        continue.
      endif.
    endloop.

    if ev_check_status = abap_true.
      me->mo_run_environment->append_log( | Success: Profitability segment as expected | ).
    endif.

  endmethod.


  method check_sales_order_exists.

    data: lv_statement type string.

    rv_result = abap_true.

    if it_sales_key is initial.
      rv_result = abap_false.
      return.
    endif.

    data: lt_vbak      type table of vbak.
    call function 'SD_VBAK_ARRAY_READ'
      tables
        it_vbak_key           = it_sales_key
        et_vbak               = lt_vbak
      exceptions
        records_not_found     = 1
        records_not_requested = 2
        others                = 3.
    if sy-subrc <> 0.
      if io_run_environment is bound.
        lv_statement = 'Error: Sales order could not be read.'.
        io_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      endif.
      rv_result = abap_false.
      return.
    endif.

    " check all reference sales orders exist
    loop at it_sales_key assigning field-symbol(<fs_sales_key>).
      if not line_exists( lt_vbak[ vbeln = <fs_sales_key>-vbeln ] ) .
        if io_run_environment is bound.
          lv_statement = 'Error: Sales order &1 doesn''t exist'.
          replace '&1' in lv_statement with <fs_sales_key>-vbeln.
          io_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
        endif.
        rv_result = abap_false.
      endif.
    endloop.

  endmethod.


  method check_thirdparty.

    constants: lc_posnr_header type posnr_va value '000000'.
    data: lv_vbeln       type vbeln,
          ls_testdata    type ty_gs_so_3rd_party_check_data,
          ls_document_id like line of ev_document_id.

    ev_check_status = abap_true.

    " get sample vbeln
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    if lines( ls_step_data-reference_step ) = 1.
      data(ls_reference_step) = me->mo_run_environment->get_step_data( iv_step_number = ls_step_data-reference_step[ 1 ] ).
      if ls_reference_step-document_id is not initial.
        lv_vbeln = ls_reference_step-document_id[ 1 ].
      endif.
    endif.
    if lv_vbeln is initial.
      me->mo_run_environment->append_log( iv_log_statement = 'Error: No document id provided by reference step' ).
      ev_check_status = abap_false.
      return.
    endif.

    " get check data
    cl_ptf_util=>get_testdata( exporting is_step_data = ls_step_data
                               importing es_testdata  = ls_testdata ).

    " get document data
    data lt_vbpa type tab_vbpa.
    data lt_vbap type tab_vbap.
    data lt_vbap_sample type tab_vbap.
    data lt_vbep type vbep_tab.
    data lt_vbep_sample type vbep_tab.
    data lt_eban type mereq_t_eban.
    select * from vbap into table @lt_vbap where vbeln = @lv_vbeln.
    select * from vbpa into table @lt_vbpa where vbeln = @lv_vbeln.
    if not line_exists( lt_vbpa[ posnr = lc_posnr_header parvw = 'WE' ] ).
      me->mo_run_environment->append_log( |Error: Ship-to partner found| ).
      ev_check_status = abap_false.
      return.
    endif.
    select * from vbep into table @lt_vbep where vbeln = @lv_vbeln.
    delete lt_vbep where banfn is initial.
    if lt_vbep[] is initial.
      me->mo_run_environment->append_log( |Error: No purchase requisite found| ).
      ev_check_status = abap_false.
      return.
    endif.
    select * from eban into table @lt_eban for all entries in @lt_vbep where banfn = @lt_vbep-banfn and
                                                                             bnfpo = @lt_vbep-bnfpo.
    if lt_eban is initial.
      me->mo_run_environment->append_log( |Error: No purchase requisite found| ).
      ev_check_status = abap_false.
      return.
    endif.

    " Check on item level
    loop at ls_testdata-item_check_data reference into data(lr_item_check_data).
      clear lt_vbap_sample.
      " get vbap entries by item id or selection criteria
      lt_vbap_sample = pr_get_vbap_sample( it_vbap            = lt_vbap
                                           ir_item_check_data = lr_item_check_data ).

      " check if at least one vbap entry is found
      if lt_vbap_sample is initial.
        if lr_item_check_data->item_id is initial.
          me->mo_run_environment->append_log( iv_log_statement = 'Warning: No VBAP entry found for item_check_data selection criteria.' ).
        else.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = 'Error: No VBAP entry found for item_check_data selection criteria.' ).
        endif.
      endif.

      loop at lt_vbap_sample assigning field-symbol(<fs_vbap_sample>).
        " check address number if required
        if lr_item_check_data->check_address_number is not initial.

          if pr_check_3rd_party_adrnr( iv_adrnr = pr_get_shipto( iv_posnr = <fs_vbap_sample>-posnr it_vbpa = lt_vbpa )-adrnr
                                       is_vbap  = <fs_vbap_sample>
                                       it_vbep  = lt_vbep
                                       it_eban  = lt_eban ) = abap_false.
            ev_check_status = abap_false.
          endif.
        endif.

        "check 3rd party PR on schedule line
        loop at lr_item_check_data->sline_check_data reference into data(lr_sline_check_data).
          clear lt_vbep_sample.
          lt_vbep_sample = pr_get_vbep_sample( iv_posnr            = <fs_vbap_sample>-posnr
                                               it_vbep             = lt_vbep
                                               ir_sline_check_data = lr_sline_check_data ).

          if lt_vbep_sample is initial.
            if lr_sline_check_data->sline_id is initial.
              me->mo_run_environment->append_log( 'Warning: No SLINE found for sline_check_data selection criteria.' ).
            else.
              ev_check_status = abap_false.
              me->mo_run_environment->append_log( 'Error: No SLINE found for sline_check_data selection criteria.' ).
            endif.
          endif.

          if pr_check_3rd_party_eban( it_vbep_sample      = lt_vbep_sample
                                      it_eban             = lt_eban
                                      ir_sline_check_data = lr_sline_check_data ) = abap_true.
            loop at lt_vbep_sample assigning field-symbol(<fs_vbep>).
              clear: ls_document_id.
              ls_document_id-vbeln = |{ <fs_vbep>-banfn }{ <fs_vbep>-bnfpo }|.
              collect ls_document_id into ev_document_id.
            endloop.
          else.
            ev_check_status = abap_false.
          endif.
        endloop.

      endloop.

    endloop.

    if ev_check_status = abap_true.
      me->mo_run_environment->append_log( | Success: 3rd party data as expected | ).
    endif.

  endmethod.


  method check_vbeln_not_existant.

    data: ls_result_key type cl_ptf_util=>ty_result_key_data,
          lv_vbeln      type vbeln.

    ev_execution_status = abap_false.
    ev_check_status = abap_true.

    data(lt_result_key_data) =  me->mo_run_environment->get_result_key_data( it_step_number =  is_step_data-reference_step ) .

    loop at is_step_data-reference_step assigning field-symbol(<ref_step>).
      read table lt_result_key_data with key step_number = <ref_step> into ls_result_key.
      case ls_result_key-bus_obj.
        when 'SO'.
          data(lt_vbeln) =  me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
          if lt_vbeln is not initial .
            lv_vbeln = lt_vbeln[ 1 ].
          endif.
      endcase.
    endloop.

    if lv_vbeln is not initial .
      select single * from vbak where vbeln = @lv_vbeln into @data(ls_vbak) .
      if sy-subrc = 0.
        ev_check_status = abap_false.
      endif.
    endif.

  endmethod.


  method check_vcm.

    data:
      ls_testdata     type ty_gs_ptf_so_check_vcm_td,
      lv_statement    type bapi_msg,
      lv_vbeln        type vbeln_va,
      lt_sales_key    type table of sales_key,
      lv_step_success type abap_bool.

    ev_check_status = abap_true.

* ----------------------------------------------- get test data -----
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = ls_step_data
      importing
        es_testdata  = ls_testdata ).

* --------------- get sales document number from reference step -----
    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_sales_key.
    endloop.
    clear lv_vbeln.
    read table lt_sales_key into lv_vbeln index 1.
    if lv_vbeln is initial.
      lv_statement = 'Error: No sales order found.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      ev_check_status = abap_false.
      return. " check fails
    endif.
    ls_step_data-document_id = lt_sales_key.

* --------------------------------- check sales document header -----
    data: ls_or_testdata type cl_ptf_bo_or=>ty_gs_ptf_sd_check_td.
    if ls_testdata-vbak_check is not initial.
      ls_or_testdata-vbak = corresponding #( ls_testdata-vbak ).
      ls_or_testdata-vbak_check = corresponding #( ls_testdata-vbak_check ).
      cl_ptf_compare_sd_tdc=>compare_vbak_data(
        exporting
          is_testdata        = ls_or_testdata
          is_check_step_data = ls_step_data
          iv_run_environment = me->mo_run_environment
        receiving
          rv_is_equal        = lv_step_success
      ).
      if lv_step_success eq abap_false.
        ev_check_status = abap_false.
      endif.
    endif.

* ----------------------------------- check sales document item -----
    if ls_testdata-vbap_check is not initial.
      me->compare_vcm_vbap_data(
        exporting
          it_sales_key       = lt_sales_key
          is_testdata        = ls_testdata
          is_check_step_data = ls_step_data
          io_run_environment = me->mo_run_environment
        importing
          rv_is_equal        = lv_step_success
          et_document_id     = data(lt_document_id)
      ).
      if lv_step_success eq abap_false.
        ev_check_status = abap_false.
      else.
        append lines of lt_document_id to ev_document_id.
      endif.
    endif.

* ------------------------- check sales document schedule line -----
    data: ls_or_testdata_ext type cl_ptf_bo_or=>ty_gs_ptf_sd_check_td_ext.
    if not ls_testdata-vbep_check is initial.
      ls_or_testdata_ext-vbep = corresponding #( ls_testdata-vbep ).
      ls_or_testdata_ext-vbep_check = corresponding #( ls_testdata-vbep_check ).
      cl_ptf_compare_sd_tdc=>compare_vbep_data(
        exporting
          is_testdata        = ls_or_testdata_ext
          is_check_step_data = ls_step_data
          iv_run_environment = me->mo_run_environment
        receiving
          rv_is_equal        = lv_step_success
      ).
      if lv_step_success eq abap_false.
        ev_check_status = abap_false.
      endif.
    endif.


* Output in case of success
    if ev_check_status = abap_true.
      lv_statement = 'Success: all items processed.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      ev_execution_status = abap_true.
      " append lv_vbeln to ev_document_id.

    else.
      lv_statement = 'Error: not all items processed successfully.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

    endif.

  endmethod.


  method check_vcmhm_chain.

    data:
      ls_testdata     type ty_gs_ptf_so_check_vcmchain_td,
      lv_statement    type bapi_msg,
      lv_vbeln        type vbeln_va,
      lt_sales_key    type table of sales_key,
      lv_step_success type abap_bool.

    ev_check_status = abap_true.

* at the moment, only chain entries for 1 SO2 as reference document could be checked
* no check for multiple SO2 in one check step

* ----------------------------------------------- get test data -----
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = ls_step_data
      importing
        es_testdata  = ls_testdata ).
    if ls_testdata is initial.
      lv_statement = 'No check data configured'.
      me->mo_run_environment->append_log( |{ lv_statement }| ).
      return.
    endif.

* --------------- get sales document number from reference step -----
    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_sales_key.
    endloop.
    clear lv_vbeln.
    read table lt_sales_key into lv_vbeln index 1.
    if lv_vbeln is initial.
      lv_statement = 'Error: No sales order found.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      ev_check_status = abap_false.
      return. " check fails
    endif.

* ----------------------------------------------- get VCM chain -----
    read_vcmhm_chain(
      exporting
        it_object_id   = conv #( lt_sales_key )
      importing
        et_vcmhm_chain = data(lt_vcmhm_chain) ).

* --------------- check the case no chain expected in test data -----
    if ls_testdata-check_not_exists is not initial.
      if lt_vcmhm_chain is initial.
        me->mo_run_environment->append_log( |VCM Chain not exists for the sales order { lv_vbeln }| ).
        me->mo_run_environment->append_log( |Sucess: result as expeccted| ).
        return.
      else.
        if ls_testdata-vcmhm_chain is initial.
          " if no entries expected at all but vcm entries exist -> error
          me->mo_run_environment->append_log( |Error: VCM Chain exists for the sales order { lv_vbeln }| ).
          ev_check_status = abap_false.
          return. " check fails
        else.
          " check explicitly maintained entries from test data
          loop at ls_testdata-vcmhm_chain assigning field-symbol(<fs_test_no_exist>).
            if line_exists( lt_vcmhm_chain[ value_chain_type        = <fs_test_no_exist>-value_chain_type
                                            step_type               = <fs_test_no_exist>-step_type
                                            business_object_item_id = <fs_test_no_exist>-business_object_item_id  ] ).
              me->mo_run_environment->append_log( |Error: VCM Chain exists for { <fs_test_no_exist>-value_chain_type } { <fs_test_no_exist>-step_type } { <fs_test_no_exist>-business_object_item_id } | ).
              ev_check_status = abap_false.
              exit. " check fails
            endif.
          endloop.
          if ev_check_status = abap_false.
            return.
          else.
            me->mo_run_environment->append_log( |Sucess: VCM Chain as expeccted| ).
            return.
          endif.
        endif.
      endif.
    endif.

* --------------- check the case chain is expected in test data -----
    if lt_vcmhm_chain is initial.
      lv_statement = 'Error: No value chain found'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      ev_check_status = abap_false.
      return. " check fails
    endif.

    " for the case only active entries should be considered
    if ls_testdata-only_active_entries is not initial.
      delete lt_vcmhm_chain where deleted = 'X'.
    endif.

* ---------------------------------- start to check VCMHM Chain -----
    data: lv_index   type i,
          lv_index_c type string.
    field-symbols: <fs_vcmhm_actual> like line of lt_vcmhm_chain.
    loop at ls_testdata-vcmhm_chain_check assigning field-symbol(<fs_check_parameter>).

      " get expected data from test data configuration
      lv_index = lv_index + 1.
      assign ls_testdata-vcmhm_chain[ lv_index ] to field-symbol(<fs_vcmhm_expected>).
      if sy-subrc <> 0.
        lv_statement = 'Error: No test data configured for line &1'.
        lv_index_c = lv_index.
        replace '&1' in lv_statement with lv_index_c.
        me->mo_run_environment->append_log( |{ lv_statement }| ).
        ev_check_status = abap_false.
        return. " check fails
      endif.
      " get corresponding chain step data
      if <fs_vcmhm_expected>-business_object_item_id = space.
        assign lt_vcmhm_chain[ value_chain_type        = <fs_vcmhm_expected>-value_chain_type
                               step_type               = <fs_vcmhm_expected>-step_type ]
          to <fs_vcmhm_actual>.
      else.
        assign lt_vcmhm_chain[ value_chain_type        = <fs_vcmhm_expected>-value_chain_type
                               step_type               = <fs_vcmhm_expected>-step_type
                               business_object_item_id = <fs_vcmhm_expected>-business_object_item_id  ]
          to <fs_vcmhm_actual>.
      endif.
      if sy-subrc <> 0.
        lv_statement = 'Error: No value chain found for chain type &1 step type &2 &3'.
        replace '&1' in lv_statement with <fs_vcmhm_expected>-value_chain_type.
        replace '&2' in lv_statement with <fs_vcmhm_expected>-step_type.
        replace '&3' in lv_statement with <fs_vcmhm_expected>-business_object_item_id.
        me->mo_run_environment->append_log( |{ lv_statement }| ).
        ev_check_status = abap_false.
        return. " check fails
      endif.

      " do comparison according to check parameter
      lv_statement = 'Start to check VCMHM Chain for &1 &2 item &3......'.
      replace '&1' in lv_statement with <fs_vcmhm_expected>-value_chain_type.
      replace '&2' in lv_statement with <fs_vcmhm_expected>-step_type.
      replace '&3' in lv_statement with <fs_vcmhm_expected>-business_object_item_id.
      me->mo_run_environment->append_log( |{ lv_statement }| ).
      data(lv_result) = compare_structure( io_run_environment = mo_run_environment
                                           is_check_parameter = <fs_check_parameter>
                                           is_expected        = <fs_vcmhm_expected>
                                           is_actual          = <fs_vcmhm_actual> ).
      if lv_result = abap_true.
        lv_statement = 'VCMHM Chain for &1 &2 item &3 checked successfully'.
        replace '&1' in lv_statement with <fs_vcmhm_expected>-value_chain_type.
        replace '&2' in lv_statement with <fs_vcmhm_expected>-step_type.
        replace '&3' in lv_statement with <fs_vcmhm_expected>-business_object_item_id.
        me->mo_run_environment->append_log( |{ lv_statement }| ).
      else.
        lv_statement = 'VCMHM Chain for &1 &2 item &3 checked with error'.
        replace '&1' in lv_statement with <fs_vcmhm_expected>-value_chain_type.
        replace '&2' in lv_statement with <fs_vcmhm_expected>-step_type.
        replace '&3' in lv_statement with <fs_vcmhm_expected>-business_object_item_id.
        me->mo_run_environment->append_log( |{ lv_statement }| ).
        ev_check_status = abap_false.
        return.
      endif.
    endloop.

    if lv_result = abap_true.
      lv_statement = 'Success: VCMHM Chain as expected'.
      me->mo_run_environment->append_log( |{ lv_statement }| ).
      ev_check_status = abap_true.
    endif.

  endmethod.


  method check_vcm_automatically.

    data:
      ls_testdata      type ty_gs_ptf_so_check_rpts_td,
      lv_attempts_max  type tb_attempts,  " maximumnumber of attempts
      lv_attempts_act  type tb_attempts,  " actual attempts
      lv_waiting_time  type s_mec_cputest_break_seconds,
      lv_idle_seconds  type s_mec_cputest_break_seconds,  " Idle Seconds Before Start
      lv_max_repeats   type /aif/repeat_counter,  " Maximum Number of Repeats
      lv_break_seconds type s_mec_cputest_break_seconds,  " Break Seconds Between Repeats
      lv_number(5)     type c,
      lv_statement     type bapi_msg,
      lv_vbeln         type vbeln_va,
      lt_sales_key     type table of sales_key,
      lt_vbap          type table of vbap.

    ev_check_status = abap_false.

    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = ls_step_data
      importing
        es_testdata  = ls_testdata ).

    lv_idle_seconds  = ls_testdata-idle_seconds.  "  Number of Idle Seconds Before Start
    lv_max_repeats   = ls_testdata-max_repeats.  " Maximum Number of Repeats
    lv_break_seconds = ls_testdata-break_seconds.  " Number of Seconds Between Repeats

    lv_attempts_max  = 1 + lv_max_repeats.  " Maximum Number of Attempts = (first try) + (repeats)

* write parameter values into log
    lv_statement = 'Parameter: Idle Seconds Before Start: &1'.
    lv_number = lv_idle_seconds.
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

* ----------------------------------------------------- get SO2 -----
    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
*      append lines of lt_ptf_keys to lt_vbeln.
      append lines of lt_ptf_keys to lt_sales_key.
    endloop.
    clear lv_vbeln.
*    read table lt_vbeln into lv_vbeln index 1.
    read table lt_sales_key into lv_vbeln index 1.
    if lv_vbeln is initial.
      lv_statement = 'Error: No SO2 order found.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      return. " check fails
    endif.

* ---------------------------------------------------- WAIT SO4 -----
* Idle Seconds Before Start: wait for PO3 + SO4 to be created
    data: lv_no_so4 type boole_d.
    wait up to lv_idle_seconds seconds.
    clear lv_attempts_act.
    do lv_attempts_max times.
      add 1 to lv_attempts_act.

      read_vcm_linked_item( exporting it_sales_key = lt_sales_key
                            receiving rt_vcm_item  = data(lt_vcm_item) ).

      if lt_vcm_item is initial.
        add lv_break_seconds to lv_waiting_time.
        wait up to lv_break_seconds seconds.
      else.
        lv_no_so4 = abap_false.
        loop at lt_vcm_item assigning field-symbol(<ls_item_link>).
          if <ls_item_link>-itemb is initial.
            lv_no_so4 = abap_true.
          endif.
        endloop.  " at lt_vcm_item assigning field-symbol(<ls_item_link>)
***
        if lv_no_so4 eq abap_true.
          add lv_break_seconds to lv_waiting_time.
          wait up to lv_break_seconds seconds.
        else.
          " so4 found
          exit.
        endif.
      endif.
    enddo.

    lv_statement = 'Actual number of attempts to read the VCM item link: &1'.
    lv_number = lv_attempts_act.
    replace '&1' in lv_statement with lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

    lv_statement = 'Total waiting time: &1 seconds'.
    lv_number = lv_waiting_time.
    replace '&1' in lv_statement with lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

    if lv_no_so4 eq abap_false.
* write the created SO4 into the output log
      loop at lt_vcm_item assigning <ls_item_link>.
        lv_statement = 'SO4 order: OBJECT &1 , ITEM &2'.
        replace '&1' in lv_statement with <ls_item_link>-itemb-business_object_id.
        replace '&2' in lv_statement with <ls_item_link>-itemb-business_object_item_id.
        me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      endloop.
    endif.

* ----------------------------------------------- get SO2 order -----
    data: ls_vbak type vbak.
    call function 'SD_VBAK_SINGLE_READ'
      exporting
        i_vbeln          = lv_vbeln
      importing
        e_vbak           = ls_vbak
      exceptions
        record_not_found = 1
        others           = 2.
    if sy-subrc <> 0.
      lv_statement = 'Error: SO2 order &1 not found'.
      replace '&1' in lv_statement with lv_vbeln.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      return. " check fails
    endif.

    call function 'SD_VBAP_ARRAY_READ_VBELN'
      tables
        it_vbak_key           = lt_sales_key
        et_vbap               = lt_vbap
      exceptions
        records_not_found     = 1
        records_not_requested = 2
        others                = 3.
    if sy-subrc <> 0.
      lv_statement = 'Error: No items found in SO2 order &1'.
      replace '&1' in lv_statement with lv_vbeln.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      return. " check fails
    endif.

    data: lt_vbkd type table of vbkd.
    call function 'SD_VBKD_ARRAY_READ_VBELN'
      tables
        it_vbak_key           = lt_sales_key
*       ET_VBKDVB             =
        et_vbkd               = lt_vbkd
      exceptions
        records_not_found     = 1
        records_not_requested = 2
        others                = 3.
    if sy-subrc <> 0.
      lv_statement = 'Error: No sales data found in SO2 order &1'.
      replace '&1' in lv_statement with lv_vbeln.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      return. " check fails
    endif.


* --------------------------------- check each SO2 item for VCM -----
    data: lv_check_error type abap_bool,
          lv_relevant    type abap_bool.

    loop at lt_vbap assigning field-symbol(<fs_vbap>).

      lv_check_error = abap_false.

      " ------------------------------- check item VCM relevant -----
      lv_relevant    = abap_false.
      check_vcm_for_ic( exporting it_vcm_item = lt_vcm_item
                                  is_vbap     = <fs_vbap>
                        importing ev_relevant = lv_relevant
                                  ev_error    = lv_check_error ).
      if lv_relevant = abap_true.
        if lv_check_error = abap_true.
          exit.
        else.
          continue.
        endif.
      endif.

      " -------------------------- check item SFS VSIT relevant -----
      lv_relevant    = abap_false.
      check_vcm_for_sfsvsit( exporting is_vbak     = ls_vbak
                                       is_vbap     = <fs_vbap>
                                       it_vbkd     = lt_vbkd[]
                             importing ev_relevant = lv_relevant
                                       ev_error    = lv_check_error ).
      if lv_relevant = abap_true.
        if lv_check_error = abap_true.
          exit.
        else.
          continue.
        endif.
      endif.

      " ------------------------------------- check normal item -----
      check_vcm_for_normal_item( exporting is_vbap  = <fs_vbap>
                                 importing ev_error = lv_check_error ).
      if lv_check_error = abap_true.
        exit.
      else.
        continue.
      endif.

    endloop.

* Output in case of success
    if lv_check_error = abap_false.
      lv_statement = 'Success: all items processed.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      ev_check_status = abap_true.
      ev_execution_status = abap_true.
      append lv_vbeln to ev_document_id.

    else.
      lv_statement = 'Error: not all items processed successfully.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      ev_check_status = abap_false.
    endif.

  endmethod.


  method check_vcm_for_ic.

    data: lv_statement     type bapi_msg.
    data: lv_ic_relevant   type boole_d.

    ev_error = abap_true.
    ev_relevant = abap_true.

    data(lo_sd_sls_ic_utility) = cl_sd_sls_ic_factory=>so_instance->get_instance_util( ).
    try.
        lo_sd_sls_ic_utility->is_item_ic_relevant(
          exporting
            iv_vbeln             = is_vbap-vbeln
            iv_posnr             = is_vbap-posnr
          receiving
            rv_ic_relevance_item = lv_ic_relevant
        ).

      catch cx_sd_doc_not_found. " SD document cannot be found
        lv_statement = 'Error SO2 order &1 item &2 not found'.
        replace '&1' in lv_statement with is_vbap-vbeln.
        replace '&2' in lv_statement with is_vbap-posnr.
        me->mo_run_environment->append_log( |{ lv_statement }| ).
        return. " failure!
    endtry.
    if lv_ic_relevant = abap_true.
      read table it_vcm_item assigning field-symbol(<ls_item_link>)
        with key
          itema-business_object_id      = is_vbap-vbeln
          itema-business_object_item_id = is_vbap-posnr.
      if sy-subrc <> 0.
        lv_statement = 'Error to read SO2 item &1 &2 in linked items'.
        replace '&1' in lv_statement with is_vbap-vbeln.
        replace '&2' in lv_statement with is_vbap-posnr.
        me->mo_run_environment->append_log( |{ lv_statement }| ).
        return. " failure!
      endif.
      if <ls_item_link>-itemb-business_object_id      is initial or
         <ls_item_link>-itemb-business_object_item_id is initial.
        me->mo_run_environment->append_log( 'Error: No SO4 item number found').
        return. " failure!
      endif.

      " success: IC item found!
      lv_statement = 'Success: IC relevant item &1 processed.'.
      replace '&1' in lv_statement with is_vbap-posnr.
      me->mo_run_environment->append_log( |{ lv_statement }| ).

      ev_error = abap_false.

    else.
      ev_relevant = abap_false.
      ev_error = abap_false.
    endif.

  endmethod.


  method check_vcm_for_normal_item.

    data: lv_statement type bapi_msg.

    ev_error = abap_true.

    if is_vbap-vcm_chain_category is not initial or
       is_vbap-vcm_chain_uuid     is not initial.
      lv_statement = 'Error: Item &1 is not VCM relevant, but VCM field is filled'.
      replace '&1' in lv_statement with is_vbap-posnr.
      me->mo_run_environment->append_log( |{ lv_statement }| ).
      return. " failure!
    endif.

    " success: normal item found!
    lv_statement = 'Success: normal item &1 processed.'.
    replace '&1' in lv_statement with is_vbap-posnr.
    me->mo_run_environment->append_log( |{ lv_statement }| ).

    ev_error = abap_false.

  endmethod.


  method check_vcm_for_sfsvsit.

    data: lv_statement type bapi_msg.
    field-symbols: <fs_vbkd> type vbkd.

    ev_error = abap_true.
    ev_relevant = abap_true.

    assign it_vbkd[ vbeln = is_vbap-vbeln posnr = is_vbap-posnr ] to <fs_vbkd>.
    if sy-subrc <> 0.
      assign it_vbkd[ vbeln = is_vbap-vbeln posnr = '000000' ] to <fs_vbkd>.
    endif.
    if <fs_vbkd> is not assigned.
      lv_statement = 'Error to read business data for SO2 &1 &2'.
      replace '&1' in lv_statement with is_vbap-vbeln.
      replace '&2' in lv_statement with is_vbap-posnr.
      me->mo_run_environment->append_log( |{ lv_statement }| ).
      return. " failure!
    endif.

    cl_sd_dbsel_cust=>so_instance->get_sfs_vsit_rel_single(
      exporting
        iv_pstyv          = is_vbap-pstyv
        iv_vkorg          = is_vbak-vkorg
        iv_werks          = is_vbap-werks
        iv_inco1          = <fs_vbkd>-inco1
      importing
        ev_relev_sfs_vsit = data(lv_sfsvist_rel)
    ).
    if lv_sfsvist_rel = abap_true.
      if is_vbap-vcm_chain_category is initial or
         is_vbap-vcm_chain_uuid     is initial.
        lv_statement = 'Error: Item &1 is SFS VSIT relevant, but VCM field is blank'.
        replace '&1' in lv_statement with is_vbap-posnr.
        me->mo_run_environment->append_log( |{ lv_statement }| ).
        return. " failure!
      endif.

      " success: SFS VSIT item found!
      lv_statement = 'Success: SFS VSIT relevant item &1 processed.'.
      replace '&1' in lv_statement with is_vbap-posnr.
      me->mo_run_environment->append_log( |{ lv_statement }| ).

      ev_error = abap_false.

    else.
      ev_relevant = abap_false.
      ev_error = abap_false.
    endif.

  endmethod.


  method compare_structure.

    data:
      msg_str1     type string,
      msg_str2     type string,
      lv_statement type string.

    field-symbols:
      <lv_expected>        type any,
      <lv_actual>          type any,
      <lv_check_parameter> type any.

    rv_result = abap_true.

    " get fields to be checked
    try.
        data(lt_fields) =  cast cl_abap_structdescr( cl_abap_typedescr=>describe_by_data( is_check_parameter ) )->get_components( ).
      catch cx_sy_move_cast_error.
        lv_statement = 'Error: method call not correct'.
        io_run_environment->append_log( |{ lv_statement }| ).
        rv_result = abap_false.
        return.
    endtry.

    if lt_fields is initial.
      return.
    endif.

    " check single field
    loop at lt_fields assigning field-symbol(<fs_field>).

      assign component <fs_field>-name of structure is_check_parameter to <lv_check_parameter>.
      if sy-subrc <> 0.
        lv_statement = 'Error: field &1 not defined in test data structure'.
        replace '&1' in lv_statement with <fs_field>-name.
        io_run_environment->append_log( |{ lv_statement }| ).
        rv_result = abap_false.
        return.
      endif.
      if <lv_check_parameter> = space.
        continue.
      endif.

      assign component <fs_field>-name of structure is_actual to <lv_actual>.
      if sy-subrc <> 0.
        lv_statement = 'Error: field &1 not defined in test data structure'.
        replace '&1' in lv_statement with <fs_field>-name.
        io_run_environment->append_log( |{ lv_statement }| ).
        rv_result = abap_false.
        return.
      endif.
      assign component <fs_field>-name of structure is_expected to <lv_expected>.
      if sy-subrc <> 0.
        lv_statement = 'Error: field &1 not defined in test data structure'.
        replace '&1' in lv_statement with <fs_field>-name.
        io_run_environment->append_log( |{ lv_statement }| ).
        rv_result = abap_false.
        return.
      endif.

      " check current value and expected value
      if <lv_expected> <> <lv_actual>.
        rv_result = abap_false.
        msg_str1 = <lv_expected>.
        msg_str2 = <lv_actual>.
        lv_statement = 'Error: field &1 is not as expected. The expected value is: &2. The stored value is: &3'.
        replace '&1' in lv_statement with <fs_field>-name.
        replace '&2' in lv_statement with msg_str1.
        replace '&3' in lv_statement with msg_str2.
        io_run_environment->append_log( |{ lv_statement }| ).
        return.
      endif.

    endloop.


  endmethod.


  method compare_vcm_vbap_data.

    data:
      lt_vbap        type table of vbap,
      lt_vbap_actual type table of vbap,
      lv_statement   type bapi_msg.

    clear: et_document_id.

    rv_is_equal = abap_true.

    if it_sales_key is initial.
      return.
    endif.

* -------------------------------------------- get item details -----
    call function 'SD_VBAP_ARRAY_READ_VBELN'
      tables
        it_vbak_key           = it_sales_key
        et_vbap               = lt_vbap
      exceptions
        records_not_found     = 1
        records_not_requested = 2
        others                = 3.
    if sy-subrc <> 0.
      rv_is_equal  = abap_false.
      io_run_environment->append_log( iv_log_statement = |No item entry was found with VBELN: { it_sales_key[ 1 ]-vbeln }| ).
      return.
    endif.

    loop at it_sales_key assigning field-symbol(<fs_sales_key>).
      read table lt_vbap transporting no fields with key vbeln = <fs_sales_key>-vbeln.
      if sy-subrc <> 0.
        rv_is_equal = abap_false.
        io_run_environment->append_log( iv_log_statement = |No item entry was found with VBELN: { <fs_sales_key>-vbeln }| ).
      endif.
    endloop.
    if rv_is_equal = abap_false.
      return.
    endif.

* -------------------------------------------- number of checks -----
    data(lv_lines_with_flags) =    lines( is_testdata-vbap_check ).
    data(lv_lines_in_doc) =        lines( lt_vbap ).
    if lv_lines_with_flags gt lv_lines_in_doc.
      rv_is_equal = abap_false.
      io_run_environment->append_log( iv_log_statement = |The document has less items than expected. Items in VBAP: { lv_lines_in_doc }| ).
      return.
    endif.

* ----------------------------------------------------- get SO4 -----
* WAIT_IC_FOR_SO4!!! should be an extra step in PTF prior to this CHECK
    data: lt_vcm_item type ltty_vcm_linked_item.
    loop at is_testdata-vbap assigning field-symbol(<fs_test_vbap>).
      if <fs_test_vbap>-ic_relevant <> space.
        data(lv_ic_relevant) = 'X'.
      endif.
    endloop.
    if lv_ic_relevant = 'X'.
      " get SO2/SO4 with the same UUID
      read_vcm_linked_item( exporting it_sales_key = it_sales_key
                            receiving rt_vcm_item  = lt_vcm_item ).

* write the created SO4 into the output log
      loop at lt_vcm_item assigning field-symbol(<ls_item_link>).
        " lv_statement = 'SO4 order: OBJECT &1 , ITEM &2'.
        lv_statement = 'SO4 order &1 &2 created for SO2 order &3 &4'.
        replace '&1' in lv_statement with <ls_item_link>-itemb-business_object_id.
        replace '&2' in lv_statement with <ls_item_link>-itemb-business_object_item_id.
        replace '&3' in lv_statement with <ls_item_link>-itema-business_object_id.
        replace '&4' in lv_statement with <ls_item_link>-itema-business_object_item_id.
        io_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      endloop.
    endif.

* adjust UUID to match user test data
    field-symbols: <fs_vbap> type vbap.
    lt_vbap_actual = lt_vbap.
    loop at lt_vbap_actual assigning <fs_vbap> where vcm_chain_uuid is not initial.
      " to match the UUID maintained from user in test data
      " because user could not maintain the real UUID in test data
      <fs_vbap>-vcm_chain_uuid = 1.
      shift <fs_vbap>-vcm_chain_uuid left deleting leading space.
    endloop.

* ========================================== CHECK item content =====
    data: lt_fieldinfo type extdfiest.
*   get fieldinfo to check which fields of vbap structure have to be checked
    clear lt_fieldinfo.
    call function 'DD_INT_TABLINFO_GET'
      exporting
        typename       = 'VBAP'
      tables
        extdfies_tab   = lt_fieldinfo
      exceptions
        not_found      = 1
        internal_error = 2
        others         = 3.
    if sy-subrc <> 0.
      rv_is_equal = abap_false.
      return.
    endif.

    data: lv_index       type i,
          ls_vbap_actual type vbap,
          ls_vbap_test   like line of is_testdata-vbap,  " VBAP with VCM flag
          ls_vbap_exp    type vbap,                      " VBAP expected
          "ls_vbap_check  type sdbil_tst_vbap_check,      " VBAP check flag
          ls_vbap_check  like line of is_testdata-vbap_check,
          lv_result      type abap_bool.

    lv_index = 0.
    loop at is_testdata-vbap_check into ls_vbap_check.
      lv_index = lv_index + 1.
      clear: ls_vbap_actual,
             ls_vbap_test,
             ls_vbap_exp.
      " get vbap from document
      read table lt_vbap_actual into ls_vbap_actual index lv_index.
      " get vbap from configured test data
      read table is_testdata-vbap into ls_vbap_test index lv_index.
      move-corresponding ls_vbap_test to ls_vbap_exp.

      " at first, normal VBAP check (e.g. Plant, VCM_CATEGORY ... )
      me->item_check_all_fields( exporting io_run_environment = io_run_environment
                                           it_fieldinfo       = lt_fieldinfo
                                           is_vbap_check      = ls_vbap_check
                                           is_vbap_actual     = ls_vbap_actual
                                           is_vbap_exp        = ls_vbap_exp
                                 receiving rv_result          = lv_result ).
      if lv_result = abap_false.
        rv_is_equal = lv_result.
        continue.
      endif.

      " VCM additional check
      field-symbols: <fs_item_link> like line of lt_vcm_item.
      data: ls_document_id like line of et_document_id.
      case 'X'.
          " IC relevant check
        when ls_vbap_test-ic_relevant.
          me->item_check_vcm_ic( exporting io_run_environment = io_run_environment
                                           is_vbap            = ls_vbap_actual
                                           it_vcm_item        = lt_vcm_item
                                 receiving rv_result          = lv_result ).
          if lv_result = abap_false.
            rv_is_equal = lv_result.
            continue.

          else.
            " collect SO4
            assign lt_vcm_item[ itema-business_object_id = ls_vbap_actual-vbeln itema-business_object_item_id = ls_vbap_actual-posnr ]
                   to <fs_item_link>.
            if sy-subrc = 0.
              ls_document_id-vbeln = conv #( <fs_item_link>-itemb-business_object_id ).
              collect ls_document_id into et_document_id.
            endif.
          endif.

          " SFS VSIT relevant check
        when ls_vbap_test-sfsvsit_relevant.
          me->item_check_vcm_sfsvsit( exporting io_run_environment = io_run_environment
                                                is_vbap            = ls_vbap_actual
                                                it_vcm_item        = lt_vcm_item
                                      receiving rv_result          = lv_result ).
          if lv_result = abap_false.
            rv_is_equal = lv_result.
            continue.
          endif.

      endcase.

    endloop.


  endmethod.


  method create.

    data: lv_vbeln          type vbeln_va,
          ls_testdata       type ty_gs_i_ptf_so_cr_td,
          lv_immediate_exit type abap_bool.

    ev_execution_status = abap_false.
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = ls_step_data
      importing
        es_testdata  = ls_testdata
    ).

    " Run dynamic testdata changes
    if ls_testdata-dynamic_testdata_changes is not initial.
      ev_execution_status = me->run_dynamic_test_data_changes(
        exporting
          iv_step_number          = iv_step_number
          it_dynamic_code         = ls_testdata-dynamic_testdata_changes
        importing
          ev_immediate_exit       = lv_immediate_exit
          ev_document_id          = ev_document_id
        changing
          cs_salesorder_test_data = ls_testdata
      ).
      check lv_immediate_exit = abap_false.
    endif.

    "Add CMPIF Implemetations
    loop at ls_testdata-components_cmpif into data(ls_component_cmpif).
      if ls_component_cmpif-component_id is not initial.
        cl_sd_sls_comp_factory=>so_instance->add_component( ls_component_cmpif ).
      endif.
    endloop.

    " Enable VCM synchronous processing
    data(vcm_test_utility) = cl_vcmhm_test_utility=>get_instance( ).
    if ls_testdata-vcm_run_sync = abap_true.
      cl_sd_sls_ic_vcm_step_init_so=>sv_ptf_vcm_sync_mode = abap_true.
      vcm_test_utility->enable_sync_processing( ).
    endif.

    if ls_testdata-goal_bo_id is initial.
      ls_testdata-goal_bo_id = if_goal_sdoc=>co_bo_id-salesorder.
    endif.
    try.
        data(lo_access) = cl_goal_api=>so_instance->create(
          iv_bo_id            = ls_testdata-goal_bo_id
          is_control_settings = value if_goal_access=>tcs_control_settings( no_conversion = abap_true )
          is_load_parameter   = value cl_goal_salesorder=>tcs_load_parameter( type_code               = ls_testdata-head-type_code
                                                                              sales_organization_id   = ls_testdata-head-sales_organization_id
                                                                              distribution_channel_id = ls_testdata-head-distribution_channel_id
                                                                              division_id             = ls_testdata-head-division_id )
          it_scenario_id      = ls_testdata-goal_scenario_ids ).
      catch cx_goal_exc into data(lx_goal_exc).
        cl_message_helper=>set_msg_vars_for_if_t100_msg( lx_goal_exc ).
        me->mo_run_environment->append_log( iv_log_statement = |{ lx_goal_exc->get_text( ) }| ).
        exit.
    endtry.

    merge_goal_salesorder(
      exporting
        io_goal_access          = lo_access
      changing
        cs_salesorder_test_data = ls_testdata ).

    lo_access->save(
      exporting
        iv_synchron = abap_true
      importing
        ev_bo_key   = lv_vbeln ).


    if lv_vbeln is initial.
      me->mo_run_environment->append_log( iv_log_statement = |{ 'Document save failed.' }| ).
*        exit.
    endif.

    "delete CMPIF Implemetations
    loop at ls_testdata-components_cmpif into ls_component_cmpif.
      if ls_component_cmpif-component_id is not initial.
        cl_sd_sls_comp_factory=>so_instance->del_component( iv_comp_id = ls_component_cmpif-component_id ).
      endif.
    endloop.

    data(lv_error_occured) = log_goal_messages(
      importing
        io_goal_access = lo_access ).
    if lv_error_occured = abap_true.
      exit.
    endif.
    lo_access->close(  ).

    " Workaround to run VCM synchronously
    if ls_testdata-vcm_run_sync = abap_true.
      select * from vbap into table @data(lt_vbap) where vbeln = @lv_vbeln.
      data: lv_vcm_chain_uuid type vcm_uuid.
      loop at lt_vbap reference into data(lr_vbap) group by lr_vbap->vcm_chain_uuid.
        lv_vcm_chain_uuid = lr_vbap->vcm_chain_uuid.
        vcm_test_utility->resume_value_chain( lv_vcm_chain_uuid ).
      endloop.
    endif.

    if lv_vbeln is not initial.
      append value #( vbeln = lv_vbeln ) to ev_document_id.
    endif.
    ev_execution_status = abap_true.

  endmethod.


  method create_with_bp_multiaddr.

    data: lv_vbeln    type vbeln_va,
          ls_testdata type ty_gs_i_ptf_so_cr_td.

    ev_execution_status = abap_false.
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = ls_step_data
      importing
        es_testdata  = ls_testdata
    ).
    if ls_testdata-goal_bo_id is initial.
      ls_testdata-goal_bo_id = if_goal_sdoc=>co_bo_id-salesorder.
    endif.
    try.
        data(lo_access) = cl_goal_api=>so_instance->create(
          iv_bo_id            = ls_testdata-goal_bo_id
          is_control_settings = value if_goal_access=>tcs_control_settings( no_conversion = abap_true )
          is_load_parameter   = value cl_goal_salesorder=>tcs_load_parameter( type_code               = ls_testdata-head-type_code
                                                                              sales_organization_id   = ls_testdata-head-sales_organization_id
                                                                              distribution_channel_id = ls_testdata-head-distribution_channel_id
                                                                              division_id             = ls_testdata-head-division_id ) ).
      catch cx_goal_exc into data(lx_goal_exc).
        cl_message_helper=>set_msg_vars_for_if_t100_msg( lx_goal_exc ).
        me->mo_run_environment->append_log( iv_log_statement = |{ lx_goal_exc->get_text( ) }| ).
        exit.
    endtry.

    merge_goal_salesorder(
      exporting
        io_goal_access          = lo_access
      changing
        cs_salesorder_test_data = ls_testdata ).

    lo_access->save( importing ev_bo_key = lv_vbeln ).

    if lv_vbeln is initial.
      me->mo_run_environment->append_log( iv_log_statement = |{ 'Document save failed.' }| ).
*        exit.
    endif.

    data(lv_error_occured) = log_goal_messages(
      importing
        io_goal_access = lo_access ).
    if lv_error_occured = abap_true.
      exit.
    endif.

    lo_access->close(  ).

    append value #( vbeln = lv_vbeln ) to ev_document_id.
    ev_execution_status = abap_true.

  endmethod.


  method create_with_reference.

    data:
      ls_testdata  type ty_gs_i_ptf_so_cr_td,
      lv_statement type string,
      lt_sales_key type table of sales_key.

    clear: ev_document_id.
    ev_execution_status = abap_true.

* ------------------------------------------ get test parameter -----
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata( exporting is_step_data = ls_step_data
                               importing es_testdata  = ls_testdata ).
    " check test parameter
    if ls_testdata-head-type_code is initial.
      lv_statement = 'No document type configured in test data.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      ev_execution_status = abap_false.
      return.
    endif.
    if ls_testdata-goal_bo_id is initial.
      ls_testdata-goal_bo_id = if_goal_sdoc=>co_bo_id-salesorder.
    endif.
    set_relative_dates(
      exporting
        it_relative_dates   = ls_testdata-head-relative_dates
      changing
        cs_entity_test_data = ls_testdata-head
    ).

* -------------------------------- get data from reference step -----
    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_sales_key.
    endloop.
    if lt_sales_key is initial.
      lv_statement = 'Error: Sales document from reference step not found.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      ev_execution_status = abap_false.
      return.
    endif.

*    " check reference sales order exists
*    data(lv_result) = check_sales_order_exists( exporting it_sales_key       = lt_sales_key
*                                                          io_run_environment = mo_run_environment ).
*    if lv_result = abap_false.
*      ev_execution_status = abap_false.
*      return.
*    endif.


* ---------------------------------- start copying w. reference -----
    data: ls_load_parameter type tds_goal_so_load,
          lv_vbeln_new      type vbeln_va,
          ls_item_ref       type tds_goal_sdoc_item_ref.
    data: lo_access type ref to if_goal_access.
    data: lx_goal_exc type ref to cx_goal_exc.
    data: lt_message type if_goal_types=>tct_message.
    data: ls_error type if_goal_types=>tcs_error.
    field-symbols: <fs_sales_key> like line of lt_sales_key.

    loop at lt_sales_key assigning <fs_sales_key>.

      clear: lv_vbeln_new.

      clear: ls_load_parameter.
      ls_load_parameter-type_code = ls_testdata-head-type_code.
      ls_load_parameter-ref_document_id = <fs_sales_key>-vbeln.
      if ls_testdata-head-req_delivery_date is not initial.
        ls_load_parameter-req_delivery_date = ls_testdata-head-req_delivery_date.
      endif.
      if ls_testdata-item_list is not initial.
        loop at ls_testdata-item_list assigning field-symbol(<fs_item>).
          ls_item_ref-item_id  = <fs_item>-item_id.
          ls_item_ref-quantity = <fs_item>-order_qty.
          append ls_item_ref to ls_load_parameter-ref_item_list.
        endloop.
      endif.

      try.
          cl_goal_api=>so_instance->create(
            exporting
              iv_bo_id          = ls_testdata-goal_bo_id
              is_load_parameter = ls_load_parameter
            receiving
              ro_access         = lo_access
          ).
        catch cx_goal_exc into lx_goal_exc.
          me->mo_run_environment->append_log( iv_log_statement = lx_goal_exc->get_text( ) ).
          ev_execution_status = abap_false.
          exit.
      endtry.

      lo_access->save( importing ev_bo_key = lv_vbeln_new ).

      clear: lt_message,
             ls_error.
      lo_access->get_messages(
        importing
          et_message = lt_message
          es_error   = ls_error
      ).

      lo_access->close( ).

      if ls_error is not initial.
        me->mo_run_environment->append_log( iv_log_statement = |{ ls_error-msgtx }| ).
        ev_execution_status = abap_false.
        exit.
      endif.

      if lv_vbeln_new is initial.
        lv_statement = 'Could not create sales document with reference to &1'.
        replace '&1' in lv_statement with <fs_sales_key>-vbeln.
        ev_execution_status = abap_false.
        exit.

      else.
        lv_statement = 'Sales document &1 created with reference to &2'.
        replace '&1' in lv_statement with lv_vbeln_new.
        replace '&2' in lv_statement with <fs_sales_key>-vbeln.
        append lv_vbeln_new to ev_document_id.
      endif.

    endloop.


  endmethod.


  method create_with_ref_config.


    data: lv_vbeln      type vbeln_va,
          ls_testdata   type ty_gs_i_ptf_so_cr_ref_conf_td, ""
          ls_result_key type cl_ptf_util=>ty_result_key_data,
          lv_statement  type string,
          lt_sales_key  type table of sales_key.

    clear: ev_document_id.
    ev_execution_status = abap_true.

* Get test data
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = ls_step_data
      importing
        es_testdata  = ls_testdata ).

    if ls_testdata-goal_bo_id is initial.
      ls_testdata-goal_bo_id = if_goal_sdoc=>co_bo_id-salesorder.
    endif.

* Create data container
    data(lo_goal_sdoc_data_cont) = cl_goal_sdoc_data_cont=>get_instance( ).

* Create SO
    try.
        data(lo_access) = cl_goal_api=>so_instance->create(
          iv_bo_id            = ls_testdata-goal_bo_id
         " is_control_settings = VALUE if_goal_access=>tcs_control_settings( no_conversion = abap_true )
          is_load_parameter   = value cl_goal_salesorder=>tcs_load_parameter( type_code               = ls_testdata-head-type_code
                                                                              sales_organization_id   = ls_testdata-head-sales_organization_id
                                                                              distribution_channel_id = ls_testdata-head-distribution_channel_id
                                                                              division_id             = ls_testdata-head-division_id )
          io_data_container   = lo_goal_sdoc_data_cont ).
      catch cx_goal_exc into data(lx_goal_exc).
        cl_message_helper=>set_msg_vars_for_if_t100_msg( lx_goal_exc ).
        me->mo_run_environment->append_log( iv_log_statement = |{ lx_goal_exc->get_text( ) }| ).
        ev_execution_status = abap_false.
        exit.
    endtry.

*Get data from reference step
    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_sales_key.
    endloop.
    if lt_sales_key is initial.
      lv_statement = 'Error: Sales document from reference step not found.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      ev_execution_status = abap_false.
      return.
    endif.

*Take first document of reference document and determine the reference cuobjs based on it. These cuobj
*are then filled into the test data
    call method merge_ref_config_into_item
      exporting
        iv_ref_doc             = lt_sales_key[ 1 ]-vbeln
        is_salesorder_testdata = ls_testdata
      importing
        ev_error               = data(lv_error)
        es_salesorder_testdata = data(ls_testdata_standard).

    if lv_error = abap_true.
      ev_execution_status = abap_false.
      return.
    endif.

*Create the entities
    merge_goal_salesorder(
      exporting
        io_goal_access          = lo_access
      changing
        cs_salesorder_test_data = ls_testdata_standard ).

*Save
    lo_access->save(
      exporting
        iv_synchron = abap_true
      importing
        ev_bo_key   = lv_vbeln ).

    lo_access->get_messages(
      importing
        et_message = data(lt_message)
        es_error   = data(ls_error)
    ).

    lo_goal_sdoc_data_cont->if_goal_data_cont~init( ).

    lo_access->close( ).

    if ls_error is not initial.
      me->mo_run_environment->append_log( iv_log_statement = |{ ls_error-msgtx }| ).
      ev_execution_status = abap_false.
      exit.
    endif.

    if lv_vbeln is initial.
      lv_statement = 'Error: Could not create sales document'.
      ev_execution_status = abap_false.
      exit.

    else.
      lv_statement = 'Sales document &1 created'.
      replace '&1' in lv_statement with lv_vbeln.
      append lv_vbeln to ev_document_id.
    endif.

  endmethod.


  method create_with_wbs.

    data: lv_vbeln      type vbeln_va,
          ls_testdata   type ty_gs_i_ptf_so_cr_td,
          ls_result_key type cl_ptf_util=>ty_result_key_data.

    ev_execution_status = abap_true.
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = ls_step_data
      importing
        es_testdata  = ls_testdata
    ).
    if ls_testdata-goal_bo_id is initial.
      ls_testdata-goal_bo_id = if_goal_sdoc=>co_bo_id-salesorder.
    endif.
    try.
        data(lo_access) = cl_goal_api=>so_instance->create(
          iv_bo_id            = ls_testdata-goal_bo_id
          is_control_settings = value if_goal_access=>tcs_control_settings( no_conversion = abap_true )
          is_load_parameter   = value cl_goal_salesorder=>tcs_load_parameter( type_code               = ls_testdata-head-type_code
                                                                              sales_organization_id   = ls_testdata-head-sales_organization_id
                                                                              distribution_channel_id = ls_testdata-head-distribution_channel_id
                                                                              division_id             = ls_testdata-head-division_id ) ).
      catch cx_goal_exc into data(lx_goal_exc).
        cl_message_helper=>set_msg_vars_for_if_t100_msg( lx_goal_exc ).
        me->mo_run_environment->append_log( iv_log_statement = |{ lx_goal_exc->get_text( ) }| ).
        exit.
    endtry.

    data(lt_result_key_data) =  me->mo_run_environment->get_result_key_data( it_step_number =  is_step_data-reference_step ) .
    loop at is_step_data-reference_step assigning field-symbol(<ref_step>).
      read table lt_result_key_data with key step_number = <ref_step> into ls_result_key.
      if ls_result_key-bus_obj = 'ENTERPRISE_PROJECT'.
        data(lt_wbs) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      endif.
    endloop.

    if not lt_wbs is initial .
      merge_wbs_into_item(
        exporting
          it_wbs                 = lt_wbs
        importing
          ev_error               = data(lv_error)
        changing
          cs_salesorder_testdata = ls_testdata ).
      if lv_error = abap_true.
        exit.
      endif.
    endif.

    merge_goal_salesorder(
      exporting
        io_goal_access          = lo_access
      changing
        cs_salesorder_test_data = ls_testdata ).

    lo_access->save( importing ev_bo_key = lv_vbeln ).

    data(lv_error_occured) = log_goal_messages(
      importing
        io_goal_access = lo_access ).
    if lv_error_occured = abap_true.
      exit.
    endif.

    lo_access->close(  ).

    append value #( vbeln = lv_vbeln ) to ev_document_id.

  endmethod.


  method delete.
    data: ls_testdata       type ty_gs_i_ptf_so_cr_td,
          lv_immediate_exit type abap_bool.

    ev_execution_status = abap_false.
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = ls_step_data
      importing
        es_testdata  = ls_testdata ).

    " Run dynamic testdata changes
    if ls_testdata-dynamic_testdata_changes is not initial.
      ev_execution_status = me->run_dynamic_test_data_changes(
        exporting
          iv_step_number          = iv_step_number
          it_dynamic_code         = ls_testdata-dynamic_testdata_changes
        importing
          ev_immediate_exit       = lv_immediate_exit
          ev_document_id          = ev_document_id
        changing
          cs_salesorder_test_data = ls_testdata
      ).
      check lv_immediate_exit = abap_false.
    endif.

    if ls_testdata-goal_bo_id is initial.
      ls_testdata-goal_bo_id = if_goal_sdoc=>co_bo_id-salesorder.
    endif.

    loop at ls_step_data-reference_step assigning field-symbol(<prestep_numbr>).
      data(ls_step_precessor) = me->mo_run_environment->get_step_data( iv_step_number = <prestep_numbr> ).
      move ls_step_precessor-document_id to ev_document_id.
      loop at ev_document_id  assigning field-symbol(<vbeln>).
        try.
            data(lo_goal_access) = cl_goal_api=>so_instance->open(
              exporting
                iv_bo_id            = ls_testdata-goal_bo_id
                iv_bo_key           = <vbeln>-vbeln && ''
                iv_read_only        = abap_false
                is_control_settings = value if_goal_access=>tcs_control_settings( no_conversion = abap_true )
                it_scenario_id      = ls_testdata-goal_scenario_ids ).

            lo_goal_access->delete( ).

            lo_goal_access->close( ).

          catch cx_goal_exc into data(lx_goal_exc).
            cl_message_helper=>set_msg_vars_for_if_t100_msg( lx_goal_exc ).
            me->mo_run_environment->append_log( iv_log_statement = |{ lx_goal_exc->get_text( ) }| ).
            exit.
        endtry.
      endloop.
    endloop.

    ev_execution_status = abap_true.


  endmethod.


  method dp_get_response.

    data ls_response type cl_far_dp_proxy_factory=>ty_response.
    ls_response-response = '{"PaytCardByDigitalPaymentSrvc":"5TWRT6ZHCHLN7ODK65JLC6FJ",'.
    concatenate ls_response-response '"PaymentCardType":"DPVI","PaymentCardExpirationMonth":"01",' into ls_response-response.
    concatenate ls_response-response'"PaymentCardExpirationYear":"2024","PaymentCardMaskedNumber":' into ls_response-response.
    concatenate ls_response-response '"************1111","PaymentCardHoldName":"Hugo"}' into ls_response-response.
    insert ls_response into table rt_response.

  endmethod.


  method dp_post_response.
    data: lv_repsonse type far_dp_gen_auth_v2_status_t .

    data ls_response type cl_far_dp_proxy_factory=>ty_response.
    ls_response-response = '{ "Authorizations": [ { " DigitalPaymentTransaction": {'.
    concatenate ls_response-response '"DigitalPaymentTransaction": "16eeb0f9834cff064762fd54c2487151ebcd73be932",' into ls_response-response.
    concatenate ls_response-response '"DigitalPaymentDateTime": "2022-12-09T14:28:18.100Z",' into ls_response-response.
    concatenate ls_response-response '"DigitalPaytTransResult": "01",' into ls_response-response.
    concatenate ls_response-response '"DigitalPaytTransRsltDesc": "Successful" },' into ls_response-response.
    concatenate ls_response-response '"Authorization": {' into ls_response-response.
    concatenate ls_response-response '"AuthorizationByPaytSrvcPrvdr": "171091027",' into ls_response-response.
    concatenate ls_response-response '"AuthorizationByAcquirer": "191209082819520",' into ls_response-response.
    concatenate ls_response-response '"AuthorizationByDigitalPaytSrvc": "LKBVQCXBJA",' into ls_response-response.
    concatenate ls_response-response '"AuthorizedAmountInAuthznCrcy": "0",' into ls_response-response.
    concatenate ls_response-response '"AuthorizationCurrency": "EUR",' into ls_response-response.
    concatenate ls_response-response '"AuthorizationDateTime": "2019-12-09T14:28:19Z",' into ls_response-response.
    concatenate ls_response-response '"AuthorizationStatus": "02",' into ls_response-response.
    concatenate ls_response-response '"DetailedAuthorizationStatus": "299",' into ls_response-response.
    concatenate ls_response-response '"AuthorizationStatusName": "[XiPay Null] Declined" },' into ls_response-response.
    concatenate ls_response-response '     "Source": { "Card": { "PaytCardByDigitalPaymentSrvc": "5TWRT6ZHCHLN7ODK65JLC6FJ"}}}]}' into ls_response-response.
    insert ls_response into table rt_response.

  endmethod.


  method evaluate_check_condition.
    rv_condition_result = abap_true.
    assign component is_condition-field_name of structure is_data to field-symbol(<fs_l_value>).
    if sy-subrc <> 0.
      if iv_verbose_mode = abap_true.
        me->mo_run_environment->append_log( iv_log_statement = 'Error: Assignment failed for field name ''' && is_condition-field_name && '''.' ).
      endif.
      rv_condition_result = abap_false.
      return.
    endif.

    case is_condition-operator.
      when '' or '= ' or ' =' or 'eq'.
        if is_condition-value is initial and <fs_l_value> is not initial.
          rv_condition_result = abap_false.
        elseif not ( <fs_l_value> = is_condition-value ).
          rv_condition_result = abap_false.
        endif.
      when '>' or 'gt'.
        if not ( <fs_l_value> > is_condition-value ).
          rv_condition_result = abap_false.
        endif.
      when '<' or 'lt'.
        if not ( <fs_l_value> < is_condition-value ).
          rv_condition_result = abap_false.
        endif.
      when '>=' or 'ge'.
        if not ( <fs_l_value> >= is_condition-value ).
          rv_condition_result = abap_false.
        endif.
      when '<=' or 'le'.
        if not ( <fs_l_value> <= is_condition-value ).
          rv_condition_result = abap_false.
        endif.
      when '<>' or 'ne'.
        if is_condition-value is initial and <fs_l_value> is initial.
          rv_condition_result = abap_false.
        elseif not ( <fs_l_value> <> is_condition-value ).
          rv_condition_result = abap_false.
        endif.
      when others.
        if iv_verbose_mode = abap_true.
          me->mo_run_environment->append_log( iv_log_statement = 'Operator ''' && is_condition-operator && ''' is not defined for check.' ).
        endif.
        rv_condition_result = abap_false.
        return.
    endcase.
    if rv_condition_result = abap_false.
      if iv_verbose_mode = abap_true.
        me->mo_run_environment->append_log( iv_log_statement = 'Condition ''' && is_condition-field_name && ' ' && is_condition-operator && ' ' && is_condition-value && ''' failed ('
                                                               && is_condition-field_name && ' = ' && <fs_l_value> && ').' ).
      endif.
    endif.
  endmethod.


  method evaluate_copa_data.

    rv_result = abap_true.

    loop at it_check_conditions assigning field-symbol(<fs_check_condition>).
      case <fs_check_condition>-operator.
        when '' or '= ' or ' =' or 'eq'.
          assign it_copa[ fnam = <fs_check_condition>-field_name ] to field-symbol(<fs_copa>).
          if sy-subrc <> 0.
            me->mo_run_environment->append_log( |Segment data { <fs_check_condition>-field_name } not exist | ).
            rv_result = abap_false.
          elseif <fs_copa>-fval <> <fs_check_condition>-value.
            me->mo_run_environment->append_log( |Segment data { <fs_copa>-fnam } value { <fs_copa>-fval } not as expected { <fs_check_condition>-value } | ).
            rv_result = abap_false.
          else.
            me->mo_run_environment->append_log( |Segment data { <fs_copa>-fnam } value { <fs_copa>-fval } checked successfully| ).
            continue.
          endif.
        when others.
          me->mo_run_environment->append_log( |Operator { <fs_check_condition>-operator } not supported | ).
          rv_result = abap_false.
      endcase..

    endloop..

  endmethod.


  method execute_action.
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    case ls_step_data-action.
      when c_raise_approval_action.
        me->raise_approval_action(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status ).
      when c_withdraw_from_approval.
        me->withdraw_from_approval(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status ).
      when c_wait_ic_for_so4.
        me->wait_ic_for_so4(
          exporting
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status ).
      when c_wait.
        me->wait(
          exporting
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status ).
      when c_wait_vcm_event.
        me->wait_vcm_event(
          exporting
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status ).
       when c_change_firsdate.
        me->change_firsdate(
          exporting
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status ).
         when c_change_goods_date.
        me->change_goods_date(
          exporting
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status ).
      when c_select_ic_so.
        me->select_ic_so(
          exporting
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status ).
      when c_create_with_reference.
        me->create_with_reference(
          exporting
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status ).
      when c_create_with_bp_multiaddr.
        me->create_with_bp_multiaddr(
          exporting
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status ).
      when c_create_with_wbs.
        me->create_with_wbs(
          exporting
            iv_step_number      = iv_step_number
            is_step_data        = ls_step_data
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_change_with_wbs.
        me->change_with_wbs(
          exporting
            iv_step_number      = iv_step_number
            is_step_data        = ls_step_data
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_far_dp_mock_active.
        me->far_dp_mock_active( ).
        ev_execution_status = abap_true.
      when c_far_dp_mock_inactive.
        me->far_dp_mock_inactive( ).
        ev_execution_status = abap_true.
      when c_create_with_ref_config.
        me->create_with_ref_config(
          exporting
            iv_step_number      = iv_step_number
            is_step_data        = ls_step_data
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status ).
    endcase.
  endmethod.


  method execute_check.

    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    case ls_step_data-action.
      when c_check_doc_apm_status.
        me->check_doc_apm_status(
          exporting
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status ).
      when c_check_vcm_automatically.
        me->check_vcm_automatically(
          exporting
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status ).
      when c_check_vcm.
        me->check_vcm(
          exporting
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status ).
      when c_check_vcmhm_chain.
        me->check_vcmhm_chain(
          exporting
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status ).
      when c_check_ic_so4_goal_change.
        me->check_ic_so4_goal_change(
          exporting
            is_step_data        = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status ).
      when c_check_profitability_segment.
        me->check_profitability_segment(
          exporting
            is_step_data        = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status ).
      when c_check_thirdparty.
        me->check_thirdparty(
          exporting
            is_step_data        = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status ).

      when c_far_dp_mock_active.
        me->far_dp_mock_active( ).

      when c_far_dp_mock_inactive.
        me->far_dp_mock_inactive( ).

      when c_check_epay.
        me->check_epay(
          exporting
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status ).

      when c_check_vbeln_not_existant.
        me->check_vbeln_not_existant(
          exporting
            iv_step_number      = iv_step_number
            is_step_data        = ls_step_data
          importing
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_check_configuration.
        me->check_configuration(
          exporting
            iv_step_number      = iv_step_number
            is_step_data        = ls_step_data
          importing
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_check_ifrs15.
        me->check_ifrs15_bundle(
          exporting
            iv_step_number      = iv_step_number
            is_step_data        = ls_step_data
          importing
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
    endcase.

  endmethod.


  method far_dp_mock_active.

    cl_far_dp_proxy_factory=>set_mock_active(
      iv_mock_active    = abap_true
      it_responses_get  = me->dp_get_response( )
      it_responses_post = me->dp_post_response( ) ).

  endmethod.


  method far_dp_mock_inactive.

    cl_far_dp_proxy_factory=>set_mock_active( iv_mock_active = abap_false ).

  endmethod.


  method get_cuobj.

    data: lv_vbeln     type vbeln,
          ls_testdata  type ty_gs_so_config_check_data,
          lt_sales_key type table of sales_key,
          lv_cuobj     type cuobj,
          lv_statement type string.

    clear: ev_success, ev_cuobj, ev_document_id.
    data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = iv_step_number ).
    append lines of lt_ptf_keys to lt_sales_key.
    if lt_sales_key is initial.
      lv_statement = 'Error: Referenced sales document for configuration not found.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      return.
    endif.
    lv_vbeln = lt_sales_key[ 1 ]-vbeln.
    select single cuobj from vbap where vbeln = @( lt_sales_key[ 1 ]-vbeln ) and posnr = @iv_item_id into @lv_cuobj.
    if lv_cuobj is initial.
      lv_statement = 'Referenced item has no configuration or does not exist.'.
      if iv_log_error = abap_true.
        lv_statement = 'Error: ' && lv_statement.
      endif.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      return.
    endif.
    ev_success = abap_true.
    ev_cuobj = lv_cuobj.
    ev_document_id = lv_vbeln.
  endmethod.


  method get_profitsegment_key.

    data: lv_werks         type vbap-werks,
          lv_transit_plant type vbap-transit_plant,
          ls_t001k         type t001k.
    clear: rs_key.

    " get Profitability Segment Number and plant depending on document category
    if cl_sd_doc_category_util=>is_any_order( iv_vbtyp ) or
       cl_sd_doc_category_util=>is_credit_or_debit_memo_req( iv_vbtyp ).
      select single werks transit_plant paobjnr from vbap into (lv_werks, lv_transit_plant, rs_key-paobjnr) where vbeln = iv_vbeln and
                                                                                                                  posnr = iv_posnr.
      if sy-subrc = 0 and lv_transit_plant is not initial.
        lv_werks = lv_transit_plant.
      endif.

    elseif cl_sd_doc_category_util=>is_any_delivery( iv_vbtyp ).
      select single werks paobjnr from lips into (lv_werks, rs_key-paobjnr) where vbeln = iv_vbeln and
                                                                                  posnr = iv_posnr.
    endif.

    if ( rs_key-paobjnr =  if_fco_copa_paobjnr=>c_init  or  rs_key-paobjnr =  if_fco_copa_paobjnr=>c_zero ).
      return.
    endif.

    " get company code depending on plant
    if lv_werks is not initial.
      call function 'T001K_SINGLE_READ'
        exporting
          bwkey      = lv_werks
        importing
          wt001k     = ls_t001k
        exceptions
          not_found  = 1
          wrong_call = 2
          others     = 3.
      if sy-subrc = 0.
        rs_key-bukrs = ls_t001k-bukrs.
      endif.
    endif.

  endmethod.


  method item_check_all_fields.

    data:
      ls_fieldinfo like line of it_fieldinfo,
      lv_input     type string,
      msg_str1     type string,
      msg_str2     type string,
      lv_statement type string.
    field-symbols:
      <lv_testdata_value> type any,
      <lv_document_value> type any,
      <lv_fieldvalue>     type any.

    rv_result = abap_true.

    loop at it_fieldinfo into ls_fieldinfo.
      assign component ls_fieldinfo-fieldname of structure is_vbap_check to <lv_fieldvalue>.
      if sy-subrc eq 0 and <lv_fieldvalue> eq 'X'.
        assign component ls_fieldinfo-fieldname of structure is_vbap_actual to <lv_document_value>.
        assign component ls_fieldinfo-fieldname of structure is_vbap_exp to <lv_testdata_value>.

        " This method converts strings to corresponding system fields
        lv_input = ( <lv_testdata_value> ).
        try.
            cl_ptf_util=>get_syst_field(
              exporting
                iv_field_name  = lv_input
              importing
                ev_field_value = <lv_testdata_value>
            ).
          catch cx_sy_dyn_call_illegal_type.
        endtry.

        if <lv_document_value> ne <lv_testdata_value>.
          rv_result = abap_false.
          msg_str1 = <lv_testdata_value>.
          msg_str2 = <lv_document_value>.
          lv_statement = 'Error: order item &1 &2. The value of the VBAP field &3 is not as expected. The expected value is: &4. The stored value is: &5'.
          replace '&1' in lv_statement with is_vbap_actual-vbeln.
          replace '&2' in lv_statement with is_vbap_actual-posnr.
          replace '&3' in lv_statement with ls_fieldinfo-fieldname.
          replace '&4' in lv_statement with msg_str1.
          replace '&5' in lv_statement with msg_str2.
          io_run_environment->append_log( |{ lv_statement }| ).
          " io_run_environment->append_log( iv_log_statement = |The value of the VBAP field { ls_fieldinfo-fieldname } is not as expected. The expected value is: { msg_str1 }. The stored value is: { msg_str2 }| ).
        endif.

      endif.
    endloop.

    if rv_result = abap_true.
      lv_statement = 'Success: order item &1 &2 VBAP fields checked'.
      replace '&1' in lv_statement with is_vbap_actual-vbeln.
      replace '&2' in lv_statement with is_vbap_actual-posnr.
      io_run_environment->append_log( |{ lv_statement }| ).
    endif.

  endmethod.


  method item_check_vcm_ic.

    data: lv_statement type bapi_msg.

    rv_result = abap_true.

    if is_vbap-vcm_chain_uuid is initial.

      lv_statement = 'Error: SO2 item &1 &2 is IC relevant, but VCM_CHAIN_UUID is initial'.
      replace '&1' in lv_statement with is_vbap-vbeln.
      replace '&2' in lv_statement with is_vbap-posnr.
      io_run_environment->append_log( |{ lv_statement }| ).
      rv_result = abap_false.

    else.
      " check so2 uuid equals so4 uuid
      read table it_vcm_item assigning field-symbol(<fs_item_link>)
        with key
          itema-business_object_id      = is_vbap-vbeln
          itema-business_object_item_id = is_vbap-posnr.
      if sy-subrc <> 0.
        lv_statement = 'Error to read SO2 item &1 &2 in linked items'.
        replace '&1' in lv_statement with is_vbap-vbeln.
        replace '&2' in lv_statement with is_vbap-posnr.
        io_run_environment->append_log( |{ lv_statement }| ).
        rv_result = abap_false.

      elseif <fs_item_link>-itemb-business_object_id      is initial or
             <fs_item_link>-itemb-business_object_item_id is initial.
        lv_statement = 'Error: No SO4 found for SO2 item &1 &2 in linked items'.
        replace '&1' in lv_statement with is_vbap-vbeln.
        replace '&2' in lv_statement with is_vbap-posnr.
        io_run_environment->append_log( |{ lv_statement }| ).
        rv_result = abap_false.

      else.

        " success: IC item found!
        lv_statement = 'Success: IC relevant item &1 processed.'.
        replace '&1' in lv_statement with is_vbap-posnr.
        io_run_environment->append_log( |{ lv_statement }| ).

      endif.

    endif.

  endmethod.


  method item_check_vcm_sfsvsit.

    data: lv_statement type bapi_msg.

    rv_result = abap_true.

    if is_vbap-vcm_chain_uuid is initial.

      lv_statement = 'Error: SO2 item &1 &2 is SFS-VSIT relevant, but VCM_CHAIN_UUID is initial'.
      replace '&1' in lv_statement with is_vbap-vbeln.
      replace '&2' in lv_statement with is_vbap-posnr.
      io_run_environment->append_log( |{ lv_statement }| ).
      rv_result = abap_false.
      return.

    else.
      " check so2 uuid equals so4 uuid
      read table it_vcm_item assigning field-symbol(<fs_item_link>)
        with key
          itema-business_object_id      = is_vbap-vbeln
          itema-business_object_item_id = is_vbap-posnr.
      if sy-subrc = 0 and
         (  <fs_item_link>-itemb-business_object_id      is not initial or
            <fs_item_link>-itemb-business_object_item_id is not initial ).
        lv_statement = 'Error: SO2 item &1 &2 is SFS-VSIT relevant, but linked SO4 item &3 &4 is found'.
        replace '&1' in lv_statement with is_vbap-vbeln.
        replace '&2' in lv_statement with is_vbap-posnr.
        replace '&3' in lv_statement with <fs_item_link>-itemb-business_object_id.
        replace '&4' in lv_statement with <fs_item_link>-itemb-business_object_item_id.
        io_run_environment->append_log( |{ lv_statement }| ).
        rv_result = abap_false.
        return.
      endif.

      " success: SFS-VSIT item checked!
      lv_statement = 'Success: SFS-VSIT relevant item &1 &2 processed.'.
      replace '&1' in lv_statement with is_vbap-vbeln.
      replace '&2' in lv_statement with is_vbap-posnr.
      io_run_environment->append_log( |{ lv_statement }| ).

    endif.

  endmethod.


  method log_goal_messages.
    rv_error_occured = abap_false.
    io_goal_access->get_messages(
      importing
        et_message = data(lt_message_save)
        es_error   = data(ls_error) ).

    loop at lt_message_save reference into data(lr_message).
      cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~add_actual_messages( it_messages = value #( ( id         = lr_message->msgid
                                                                                                        number     = lr_message->msgno
                                                                                                        type       = lr_message->msgty
                                                                                                        message_v1 = lr_message->msgv1
                                                                                                        message_v2 = lr_message->msgv2
                                                                                                        message_v3 = lr_message->msgv3
                                                                                                        message_v4 = lr_message->msgv4 ) ) ).
      me->mo_run_environment->append_log( iv_log_statement = |{ lr_message->msgtx }| ).
    endloop.

    if not ls_error is initial.
      cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~add_actual_messages( it_messages = value #( ( id         = ls_error-msgid
                                                                                                        number     = ls_error-msgno
                                                                                                        type       = ls_error-msgty
                                                                                                        message_v1 = ls_error-msgv1
                                                                                                        message_v2 = ls_error-msgv2
                                                                                                        message_v3 = ls_error-msgv3
                                                                                                        message_v4 = ls_error-msgv4 ) ) ).
      me->mo_run_environment->append_log( iv_log_statement = |{ ls_error-msgtx }| ).
      rv_error_occured = abap_true.
    endif.
  endmethod.


  method merge_goal_entity_test_data.
    data:
      ls_entity_admin          type tds_goal_entity_admin.
    clear es_changed_field.

    " create a new handle if not yet provided
    assign component 'handle' of structure cs_entity_data to field-symbol(<fs_entity_data_handle>).
    check sy-subrc = 0.
    move-corresponding cs_entity_data to ls_entity_admin.
    if <fs_entity_data_handle> is initial.
      <fs_entity_data_handle> = cl_goal_util=>so_instance->create_guid( ).
    endif.
    es_changed_field-handle = <fs_entity_data_handle>.

    " read component list of input entity structure
    data(lt_entity_component) =  cast cl_abap_structdescr( cl_abap_typedescr=>describe_by_data( is_entity_test_data )
                                                           )->get_ddic_field_list( p_including_substructres = 'X' ).
    loop at lt_entity_component assigning field-symbol(<fs_entity_component>) where fieldname <> 'HANDLE'.
      assign component <fs_entity_component>-fieldname of structure is_entity_test_data to field-symbol(<fs_test_data>).
      check sy-subrc = 0.
      if <fs_test_data> is not initial or line_exists( it_uncndnl_take_over_fields[ name = <fs_entity_component>-fieldname ] ).
        assign component <fs_entity_component>-fieldname of structure cs_entity_data to field-symbol(<fs_entity_data>).
        check sy-subrc = 0.
        if <fs_entity_data> <> <fs_test_data> or line_exists( it_uncndnl_take_over_fields[ name = <fs_entity_component>-fieldname ] ).
          <fs_entity_data> = <fs_test_data>.
          insert conv #( <fs_entity_component>-fieldname ) into table es_changed_field-field.
        endif.
      endif.
    endloop.

  endmethod.


  method merge_goal_salesorder.
    data: ls_head_entity   type tds_goal_so_head,
          lt_item_entity   type standard table of tds_goal_so_item,
          lr_item_entity   type ref to tds_goal_so_item,
          lt_sline_entity  type standard table of tds_goal_so_sline,
          lr_sline_entity  type ref to tds_goal_so_sline,
          lt_party_entity  type standard table of tds_goal_basic_party,
          lr_party_entity  type ref to tds_goal_basic_party,
          lt_text_entity   type standard table of tds_goal_basic_text,
          lr_text_entity   type ref to tds_goal_basic_text,
          lt_cond_entity   type standard table of tds_goal_basic_cond,
          lr_cond_entity   type ref to tds_goal_basic_cond,
          lr_epay_entity   type ref to tds_goal_sdoc_epay,
          lt_epay_entity   type standard table of tds_goal_sdoc_epay,
          ls_changed_field type if_goal_types=>tcs_changed_field,
          lt_changed_field type if_goal_types=>tct_changed_field.

    " set header data
    io_goal_access->get_entity(
      exporting
        iv_entity_id   = if_goal_sdoc_head=>co_entity_id
      importing
        es_entity_data = ls_head_entity ).
    set_relative_dates(
      exporting
        it_relative_dates   = cs_salesorder_test_data-head-relative_dates
      changing
        cs_entity_test_data = cs_salesorder_test_data-head-goal_data ).
    merge_goal_entity_test_data(
      exporting
        is_entity_test_data         = cs_salesorder_test_data-head-goal_data
        it_uncndnl_take_over_fields = cs_salesorder_test_data-head-unconditional_take_over_fields
      importing
        es_changed_field            = ls_changed_field
      changing
        cs_entity_data              = ls_head_entity ).

    " readonly fields:
    if line_exists( ls_changed_field-field[ table_line = if_goal_sdoc_head=>co_field_name-type_code ] ).
      delete ls_changed_field-field where table_line = if_goal_sdoc_head=>co_field_name-type_code.
    endif.

    io_goal_access->set_entity(
      iv_entity_id     = if_goal_sdoc_head=>co_entity_id
      is_entity_data   = ls_head_entity
      is_changed_field = ls_changed_field ).


    " set head partner data
    clear lt_changed_field.
    io_goal_access->get_entity_set(
      exporting
        iv_entity_id     = if_goal_basic_party=>co_entity_id-head_party
        iv_handle_parent = ls_head_entity-handle
      importing
        et_entity_data   = lt_party_entity ).

    loop at cs_salesorder_test_data-head-party_list assigning field-symbol(<fs_head_party_test_data>).
      if line_exists( lt_party_entity[ function_code = <fs_head_party_test_data>-function_code ] ).
        lr_party_entity = ref #( lt_party_entity[ function_code = <fs_head_party_test_data>-function_code ] ).
      else.
        append value #( ) to lt_party_entity reference into lr_party_entity.
      endif.
      merge_goal_entity_test_data(
        exporting
          is_entity_test_data         = <fs_head_party_test_data>-goal_data
          it_uncndnl_take_over_fields = <fs_head_party_test_data>-unconditional_take_over_fields
        importing
          es_changed_field            = ls_changed_field
        changing
          cs_entity_data              = lr_party_entity->* ).
      append ls_changed_field to lt_changed_field.
    endloop.
    io_goal_access->set_entity_set(
      exporting
        iv_entity_id     = if_goal_basic_party=>co_entity_id-head_party
        iv_handle_parent = ls_head_entity-handle
        it_entity_data   = lt_party_entity
        it_changed_field = lt_changed_field ).

    " set header texts
    if cs_salesorder_test_data-head-text_list is not initial.
      clear lt_changed_field.
      try.
          io_goal_access->get_entity_set(
            exporting
              iv_entity_id     = if_goal_basic_text=>co_entity_id-head_text
              iv_handle_parent = ls_head_entity-handle
            importing
              et_entity_data   = lt_text_entity ).
        catch cx_goal_exc into data(lx_goal_exc).
          cl_message_helper=>set_msg_vars_for_if_t100_msg( lx_goal_exc ).
          me->mo_run_environment->append_log( iv_log_statement = |{ lx_goal_exc->get_text( ) }| ).
      endtry.

      loop at cs_salesorder_test_data-head-text_list assigning field-symbol(<fs_head_text_test_data>).
        if line_exists( lt_text_entity[ text_id = <fs_head_text_test_data>-text_id spras = <fs_head_text_test_data>-spras ] ).
          lr_text_entity = ref #( lt_text_entity[ text_id = <fs_head_text_test_data>-text_id spras = <fs_head_text_test_data>-spras ] ).
        else.
          append value #( ) to lt_text_entity reference into lr_text_entity.
        endif.
        merge_goal_entity_test_data(
          exporting
            is_entity_test_data         = <fs_head_text_test_data>-goal_data
            it_uncndnl_take_over_fields = <fs_head_text_test_data>-unconditional_take_over_fields
          importing
            es_changed_field            = ls_changed_field
          changing
            cs_entity_data              = lr_text_entity->*
        ).
        append ls_changed_field to lt_changed_field.
      endloop.
      io_goal_access->set_entity_set(
        exporting
          iv_entity_id     = if_goal_basic_text=>co_entity_id-head_text
          iv_handle_parent = ls_head_entity-handle
          it_entity_data   = lt_text_entity
          it_changed_field = lt_changed_field ).
    endif.

    " set header price condition
    clear lt_changed_field.
    io_goal_access->get_entity_set(
      exporting
        iv_entity_id     = if_goal_basic_cond=>co_entity_id-head_cond
        iv_handle_parent = ls_head_entity-handle
      importing
        et_entity_data   = lt_cond_entity ).
    loop at cs_salesorder_test_data-head-pricecondition_list assigning field-symbol(<fs_head_cond_test_data>).
      if line_exists( lt_cond_entity[ type_code = <fs_head_cond_test_data>-type_code ] ).
        lr_cond_entity = ref #( lt_cond_entity[ type_code = <fs_head_cond_test_data>-type_code ] ).
      else.
        append value #( ) to lt_cond_entity reference into lr_cond_entity.
      endif.
      merge_goal_entity_test_data(
        exporting
          is_entity_test_data         = <fs_head_cond_test_data>-goal_data
          it_uncndnl_take_over_fields = <fs_head_cond_test_data>-unconditional_take_over_fields
        importing
          es_changed_field            = ls_changed_field
        changing
          cs_entity_data              = lr_cond_entity->*
      ).
      append ls_changed_field to lt_changed_field.
    endloop.
    io_goal_access->set_entity_set(
      exporting
        iv_entity_id     = if_goal_basic_cond=>co_entity_id-head_cond
        iv_handle_parent = ls_head_entity-handle
        it_entity_data   = lt_cond_entity
        it_changed_field = lt_changed_field ).

    try.
        clear lt_changed_field.
        io_goal_access->get_entity_set(
          exporting
            iv_entity_id     = if_goal_sdoc_epay=>co_entity_id
            iv_handle_parent = ls_head_entity-handle
          importing
            et_entity_data   = lt_epay_entity ).
      catch cx_goal_exc . "raised when sales order is not setup for payment cards
    endtry.

    loop at cs_salesorder_test_data-head-epay_list assigning field-symbol(<fs_head_epay_test_data>).
      if line_exists( lt_epay_entity[ instance_id = <fs_head_epay_test_data>-instance_id fplnr = <fs_head_epay_test_data>-fplnr ] ).
        lr_epay_entity = ref #( lt_epay_entity[ instance_id = <fs_head_epay_test_data>-instance_id fplnr = <fs_head_epay_test_data>-fplnr ] ) .
      else.
        append value #( ) to lt_epay_entity reference into lr_epay_entity.
      endif.

      merge_goal_entity_test_data(
        exporting
          is_entity_test_data         = <fs_head_epay_test_data>-goal_data
          it_uncndnl_take_over_fields = <fs_head_epay_test_data>-unconditional_take_over_fields
        importing
          es_changed_field            = ls_changed_field
        changing
          cs_entity_data              = lr_epay_entity->* ).

      append ls_changed_field to lt_changed_field.

    endloop.

    io_goal_access->set_entity_set(
      exporting
        iv_entity_id     = if_goal_sdoc_epay=>co_entity_id
        iv_handle_parent = ls_head_entity-handle
        it_entity_data   = lt_epay_entity
        it_changed_field = lt_changed_field ).

    " set item data
    if cs_salesorder_test_data-goal_bo_id = if_goal_sdoc=>co_bo_id-salesorder
       or cs_salesorder_test_data-goal_bo_id is initial.
      io_goal_access->get_entity_set(
        exporting
          iv_entity_id   = if_goal_sdoc_item=>co_entity_id
        importing
          et_entity_data = lt_item_entity ).
    else.
      io_goal_access->get_entity_set(
        exporting
          iv_handle_parent = ls_head_entity-handle
          iv_entity_id     = if_goal_sdoc_item=>co_entity_id
        importing
          et_entity_data   = lt_item_entity ).
    endif.

    loop at cs_salesorder_test_data-item_list assigning field-symbol(<fs_item_test_data>).
      if line_exists( lt_item_entity[ item_id = <fs_item_test_data>-item_id ] ).
        lr_item_entity = ref #( lt_item_entity[ item_id = <fs_item_test_data>-item_id ] ).
      else.
        data(ls_new_item_entity) = value tds_goal_so_item(  ).
        lr_item_entity = ref #( ls_new_item_entity ).
      endif.

      if <fs_item_test_data>-delete_entry = abap_true.
        io_goal_access->del_entity(
          exporting
            iv_handle = lr_item_entity->handle ).
        continue.
      endif.
      set_relative_dates(
        exporting
          it_relative_dates   = <fs_item_test_data>-relative_dates
        changing
          cs_entity_test_data = <fs_item_test_data>-goal_data ).
      merge_goal_entity_test_data(
        exporting
          is_entity_test_data         = <fs_item_test_data>-goal_data
          it_uncndnl_take_over_fields = <fs_item_test_data>-unconditional_take_over_fields
        importing
          es_changed_field            = ls_changed_field
        changing
          cs_entity_data              = lr_item_entity->* ).

      set_data_container_item(
        is_item_data      = lr_item_entity->*
        is_data_container = <fs_item_test_data>-data_container_item ).

      io_goal_access->set_entity(
        exporting
          iv_entity_id     = if_goal_sdoc_item=>co_entity_id
          is_entity_data   = lr_item_entity->*
          is_changed_field = ls_changed_field ).

      " set sline data
      clear lt_changed_field.
      io_goal_access->get_entity_set(
        exporting
          iv_entity_id     = if_goal_sdoc_sline=>co_entity_id
          iv_handle_parent = lr_item_entity->handle
        importing
          et_entity_data   = lt_sline_entity ).
      loop at <fs_item_test_data>-sline_list assigning field-symbol(<fs_sline_test_data>).
        if line_exists( lt_sline_entity[ sline_id = <fs_sline_test_data>-sline_id ] ).
          lr_sline_entity = ref #( lt_sline_entity[ sline_id = <fs_sline_test_data>-sline_id ] ).
        else.
          append value #( ) to lt_sline_entity reference into lr_sline_entity.
        endif.
        if <fs_sline_test_data>-delete_entry = abap_true.
          io_goal_access->del_entity(
            exporting
              iv_handle = lr_sline_entity->handle
          ).
          continue.
        endif.
        set_relative_dates(
          exporting
            it_relative_dates   = <fs_sline_test_data>-relative_dates
          changing
            cs_entity_test_data = <fs_sline_test_data>-goal_data ).
        merge_goal_entity_test_data(
          exporting
            is_entity_test_data         = <fs_sline_test_data>-goal_data
            it_uncndnl_take_over_fields = <fs_sline_test_data>-unconditional_take_over_fields
          importing
            es_changed_field            = ls_changed_field
          changing
            cs_entity_data              = lr_sline_entity->* ).
        append ls_changed_field to lt_changed_field.
      endloop.
      io_goal_access->set_entity_set(
        exporting
          iv_entity_id     = if_goal_sdoc_sline=>co_entity_id
          iv_handle_parent = lr_item_entity->handle
          it_entity_data   = lt_sline_entity
          it_changed_field = lt_changed_field ).

      " set item partner data
      clear lt_changed_field.
      io_goal_access->get_entity_set(
        exporting
          iv_entity_id     = if_goal_basic_party=>co_entity_id-item_party
          iv_handle_parent = lr_item_entity->handle
        importing
          et_entity_data   = lt_party_entity ).
      loop at <fs_item_test_data>-party_list assigning field-symbol(<fs_item_party_test_data>).
        if line_exists( lt_party_entity[ function_code = <fs_item_party_test_data>-function_code ] ).
          lr_party_entity = ref #( lt_party_entity[ function_code = <fs_item_party_test_data>-function_code ] ).
        else.
          append value #( ) to lt_party_entity reference into lr_party_entity.
        endif.
        merge_goal_entity_test_data(
          exporting
            is_entity_test_data         = <fs_item_party_test_data>-goal_data
            it_uncndnl_take_over_fields = <fs_item_party_test_data>-unconditional_take_over_fields
          importing
            es_changed_field            = ls_changed_field
          changing
            cs_entity_data              = lr_party_entity->* ).
        append ls_changed_field to lt_changed_field.
      endloop.
      io_goal_access->set_entity_set(
        exporting
          iv_entity_id     = if_goal_basic_party=>co_entity_id-item_party
          iv_handle_parent = lr_item_entity->handle
          it_entity_data   = lt_party_entity
          it_changed_field = lt_changed_field ).

      " set item texts
      if <fs_item_test_data>-text_list is not initial.
        clear lt_changed_field.
        try.
            io_goal_access->get_entity_set(
              exporting
                iv_entity_id     = if_goal_basic_text=>co_entity_id-item_text
                iv_handle_parent = lr_item_entity->handle
              importing
                et_entity_data   = lt_text_entity ).
          catch cx_goal_exc into lx_goal_exc.
            cl_message_helper=>set_msg_vars_for_if_t100_msg( lx_goal_exc ).
            me->mo_run_environment->append_log( iv_log_statement = |{ lx_goal_exc->get_text( ) }| ).
        endtry.

        loop at <fs_item_test_data>-text_list assigning field-symbol(<fs_item_text_test_data>).
          if line_exists( lt_text_entity[ text_id = <fs_item_text_test_data>-text_id spras = <fs_item_text_test_data>-spras ] ).
            lr_text_entity = ref #( lt_text_entity[ text_id = <fs_item_text_test_data>-text_id spras = <fs_item_text_test_data>-spras ] ).
          else.
            append value #( ) to lt_text_entity reference into lr_text_entity.
          endif.
          merge_goal_entity_test_data(
            exporting
              is_entity_test_data         = <fs_item_text_test_data>-goal_data
              it_uncndnl_take_over_fields = <fs_item_text_test_data>-unconditional_take_over_fields
            importing
              es_changed_field            = ls_changed_field
            changing
              cs_entity_data              = lr_text_entity->*
          ).
          append ls_changed_field to lt_changed_field.
        endloop.
        io_goal_access->set_entity_set(
          exporting
            iv_entity_id     = if_goal_basic_text=>co_entity_id-item_text
            iv_handle_parent = lr_item_entity->handle
            it_entity_data   = lt_text_entity
            it_changed_field = lt_changed_field ).
      endif.

      " set item price condition
      clear lt_changed_field.
      io_goal_access->get_entity_set(
        exporting
          iv_entity_id     = if_goal_basic_cond=>co_entity_id-item_cond
          iv_handle_parent = lr_item_entity->handle
        importing
          et_entity_data   = lt_cond_entity ).

      loop at <fs_item_test_data>-pricecondition_list assigning field-symbol(<fs_item_cond_test_data>).
        if line_exists( lt_cond_entity[ type_code = <fs_item_cond_test_data>-type_code ] ).
          lr_cond_entity = ref #( lt_cond_entity[ type_code = <fs_item_cond_test_data>-type_code ] ).
        else.
          append value #( ) to lt_cond_entity reference into lr_cond_entity.
        endif.
        merge_goal_entity_test_data(
          exporting
            is_entity_test_data         = <fs_item_cond_test_data>-goal_data
            it_uncndnl_take_over_fields = <fs_item_cond_test_data>-unconditional_take_over_fields
          importing
            es_changed_field            = ls_changed_field
          changing
            cs_entity_data              = lr_cond_entity->*
        ).
        append ls_changed_field to lt_changed_field.
      endloop.
      io_goal_access->set_entity_set(
        exporting
          iv_entity_id     = if_goal_basic_cond=>co_entity_id-item_cond
          iv_handle_parent = lr_item_entity->handle
          it_entity_data   = lt_cond_entity
          it_changed_field = lt_changed_field ).

    endloop.

  endmethod.


  method merge_ref_config_into_item.
    data: lv_statement  type string,
          lv_ref_config type cuobj.

    clear: es_salesorder_testdata,
           ev_error .

    data(ls_salesorder_testdata) = is_salesorder_testdata.
    loop at ls_salesorder_testdata-item_list assigning field-symbol(<fs_item_test_data>)
                                             where ref_item_for_ref_config is not initial.
      clear lv_ref_config.
      select single cuobj from vbap into @lv_ref_config where vbeln = @iv_ref_doc and
                                                              posnr = @<fs_item_test_data>-ref_item_for_ref_config .
      if lv_ref_config is initial.
        lv_statement = 'Error: Reference configuration ID could not be determined.'.
        me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
        ev_error = abap_true.
        exit.
      endif.
      <fs_item_test_data>-data_container_item-ref_configuration_id = lv_ref_config.
      <fs_item_test_data>-data_container_item-ref_configuration_ctrl = <fs_item_test_data>-ref_config_ctrl.
    endloop.

    move-corresponding ls_salesorder_testdata to es_salesorder_testdata expanding nested tables.

  endmethod.


  method merge_wbs_into_item.
    data:  lv_wbs_relative_number type i .

    if not cs_salesorder_testdata is initial .
      loop at cs_salesorder_testdata-item_list assigning field-symbol(<fs_item_test_data>).
        lv_wbs_relative_number = <fs_item_test_data>-wbs_relative_number.
        if lv_wbs_relative_number > 0 .
          read table it_wbs assigning field-symbol(<fv_wbs_id>) index lv_wbs_relative_number .
          if sy-subrc = 0.
            <fs_item_test_data>-wbs_element_id = <fv_wbs_id> .
          else.
            ev_error = abap_true.
            exit.
          endif.
        else.
          <fs_item_test_data>-wbs_element_id = ''.
        endif.
      endloop.
    endif.
    if not cs_salesorder_checkdata is initial .
      loop at cs_salesorder_checkdata-item_check_data assigning field-symbol(<fs_item_check_data>).
        read table <fs_item_check_data>-check_conditions assigning field-symbol(<fs_check_condition>) with key field_name = 'WBS_RELATIVE_NUMBER'.
        if sy-subrc = 0.
          lv_wbs_relative_number = <fs_check_condition>-value.
          if lv_wbs_relative_number > 0 .
            read table it_wbs assigning <fv_wbs_id> index lv_wbs_relative_number .
            if sy-subrc = 0.
              <fs_check_condition>-field_name = 'PS_PSP_PNR' .
              <fs_check_condition>-value = <fv_wbs_id> .
            else.
              ev_error = abap_true.
              exit.
            endif.
          else.
            <fs_check_condition>-field_name = 'PS_PSP_PNR' .
            <fs_check_condition>-value = '' .
          endif.
        endif.
      endloop .
    endif.

  endmethod.


  method pr_check_3rd_party_adrnr.

    r_result = abap_true.
    loop at it_vbep assigning field-symbol(<fs_vbep>) where posnr = is_vbap-posnr and
                                                            banfn is not initial  and
                                                            bnfpo is not initial.
      assign it_eban[ banfn = <fs_vbep>-banfn bnfpo = <fs_vbep>-bnfpo ] to field-symbol(<fs_eban>).
      if sy-subrc <> 0.
        mo_run_environment->append_log( |Error: PR { <fs_vbep>-banfn } not found| ).
        r_result = abap_false.
        continue.
      endif.

      if iv_adrnr = <fs_eban>-adrn2.
        mo_run_environment->append_log( |PR address number { <fs_eban>-adrn2 } for item { is_vbap-posnr } checked correctly| ).
      else.
        mo_run_environment->append_log( |Error: PR address number { <fs_eban>-adrn2 } not equals to { iv_adrnr } for item { is_vbap-posnr }| ).
        r_result = abap_false.
      endif.
    endloop.

  endmethod.


  method pr_check_3rd_party_eban.

    rv_result = abap_true.
    loop at it_vbep_sample assigning field-symbol(<fs_vbep_sample>).
      mo_run_environment->append_log( |Check PR { <fs_vbep_sample>-banfn } { <fs_vbep_sample>-bnfpo } ...... | ).
      assign it_eban[ banfn = <fs_vbep_sample>-banfn bnfpo = <fs_vbep_sample>-bnfpo ] to field-symbol(<fs_eban>).
      if sy-subrc = 0.
        loop at ir_sline_check_data->check_conditions assigning field-symbol(<fs_sline_check_condition>).
          if evaluate_check_condition( is_data = <fs_eban> is_condition = <fs_sline_check_condition> ) = abap_false.
            rv_result = abap_false.
          endif.
        endloop.
        if rv_result = abap_true.
          mo_run_environment->append_log( |PR { <fs_vbep_sample>-banfn } { <fs_vbep_sample>-bnfpo } checked successfully| ).
        endif.
      else.
        mo_run_environment->append_log( |Error: PR { <fs_vbep_sample>-banfn } { <fs_vbep_sample>-bnfpo } not found| ).
        rv_result = abap_false.
      endif.
    endloop.

  endmethod.


  method pr_extract_to_sample_vbap.

    loop at it_vbap assigning field-symbol(<fs_vbap>).
      data(lv_vbap_valid) = abap_true.
      loop at ir_item_check_data->dynamic_selection_key assigning field-symbol(<fs_item_dynamic_select_key>).
        if evaluate_check_condition( is_data = <fs_vbap> is_condition = <fs_item_dynamic_select_key> iv_verbose_mode = abap_false ) = abap_false.
          lv_vbap_valid = abap_false.
        endif.
      endloop.
      if lv_vbap_valid = abap_true.
        insert <fs_vbap> into table rt_vbap_sample.
      endif.
    endloop.

  endmethod.


  method pr_extract_to_sample_vbep.
    loop at it_vbep assigning field-symbol(<fs_vbep>) where posnr = iv_posnr.
      data(lv_vbep_valid) = abap_true.
      loop at ir_sline_check_data->dynamic_selection_key assigning field-symbol(<fs_sline_dynamic_select_key>).
        if evaluate_check_condition( is_data = <fs_vbep> is_condition = <fs_sline_dynamic_select_key> iv_verbose_mode = abap_false ) = abap_false.
          lv_vbep_valid = abap_false.
        endif.
      endloop.
      if lv_vbep_valid = abap_true.
        insert <fs_vbep> into table rt_vbep_sample.
      endif.
    endloop.
  endmethod.


  method pr_get_shipto.
    constants:
      lc_posnr_header type posnr_va value '000000',
      lc_parvw_shipto type parvw value 'WE'.

    field-symbols: <fs_shipto> type vbpa.
    assign it_vbpa[ posnr = lc_posnr_header parvw = lc_parvw_shipto ] to <fs_shipto>.
    if sy-subrc <> 0.
      assign it_vbpa[ posnr = lc_posnr_header parvw = lc_parvw_shipto ] to <fs_shipto>.
    endif.
    if <fs_shipto> is assigned.
      rs_vbpa = <fs_shipto>.
    endif.

  endmethod.


  method pr_get_vbap_sample.

    if ir_item_check_data->item_id is initial.
      rt_vbap_sample = pr_extract_to_sample_vbap( it_vbap            = it_vbap[]
                                                  ir_item_check_data = ir_item_check_data ).
    else.
      if line_exists( it_vbap[ posnr = ir_item_check_data->item_id ] ).
        insert it_vbap[ posnr = ir_item_check_data->item_id ] into table rt_vbap_sample.
      endif.
    endif.

  endmethod.


  method pr_get_vbep_sample.

    if ir_sline_check_data->sline_id is initial.
      rt_vbep_sample = pr_extract_to_sample_vbep( iv_posnr            = iv_posnr
                                                  it_vbep             = it_vbep
                                                  ir_sline_check_data = ir_sline_check_data ).
    else.
      if line_exists( it_vbep[ posnr = iv_posnr etenr = ir_sline_check_data->sline_id ] ).
        insert it_vbep[ posnr = iv_posnr etenr = ir_sline_check_data->sline_id ] into table rt_vbep_sample.
      endif.
    endif.

  endmethod.


  method raise_approval_action.

    data:
      ls_test_data              type ty_gs_i_ptf_so_appr_action_id,
      lv_sales_doc_number       type vbeln,
      lt_sales_document_numbers type cl_ptf_util=>ty_vbeln_tab,
      lt_workflows              type standard table of swr_wihdr,
      lt_sdoc_messages          type tdt_sdoc_msg,
      lv_return_code            like sy-subrc,
      lt_workflow_messages      type standard table of swr_messag,
      lv_decision_key           type swr_decikey.

    ev_execution_status = abap_true.

    " check if the System is Extensibility Test System
    data(is_ext_sys) = cl_ato_service_factory=>get_ato_service( )->is_extensibility_dev_system( ).

    " workflow is triggered asyn in ext. dev system
    if is_ext_sys eq abap_true.
      wait up to 120 seconds.
    endif.
    if step_data-variant is not initial.
      cl_ptf_util=>get_testdata(
        exporting
          is_step_data = step_data
        importing
          es_testdata  = ls_test_data ).
    endif.

    loop at step_data-reference_step assigning field-symbol(<ref_step>).
      data(ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      append lines of ptf_keys to lt_sales_document_numbers.
    endloop.
    if lt_sales_document_numbers is initial.
      me->mo_run_environment->append_log( iv_log_statement = |There are no reference documentIDs!| ).
      ev_execution_status = abap_false.
      return.
    endif.

    loop at lt_sales_document_numbers assigning field-symbol(<vbeln>).
      clear: lt_workflows.
      lv_sales_doc_number = <vbeln>.
      select single apm_approval_status from vbak where vbeln = @lv_sales_doc_number into @data(approval_status).
      " extensibility system -> workflow and BAdI has to be configured
      if is_ext_sys eq abap_true.
        call function 'SAP_WAPI_WORKITEMS_TO_OBJECT'
          exporting
            object_por               = value sibflporb( catid  = swfco_objtype_cl
                                                       typeid = 'CL_SD_APM_WORKFLOW'
                                                       instid = <vbeln> )
            selection_status_variant = 0001   " all active workflows
            text                     = space
            top_level_items          = space
          tables
*           task_filter              = lt_task_filter
            worklist                 = lt_workflows.

        lv_decision_key = cond #( when ls_test_data-action eq if_sd_apm_approval=>co_approval_action-release       then '0001'
                                  when ls_test_data-action eq if_sd_apm_approval=>co_approval_action-set_to_rework then '0003'
                                  when ls_test_data-action eq if_sd_apm_approval=>co_approval_action-reject        then '0002' ).
        loop at lt_workflows assigning field-symbol(<workflow>) where wi_type = 'W'.
          clear lv_return_code.
          call function 'SAP_WAPI_DECISION_COMPLETE'
            exporting
              workitem_id   = <workflow>-wi_id
              decision_key  = lv_decision_key
              do_commit     = 'X'
            importing
              return_code   = lv_return_code
            tables
              message_lines = lt_workflow_messages.
          if lv_return_code ne 0.
            ev_execution_status = abap_false.
          else.
            loop at lt_workflow_messages assigning field-symbol(<msg>).
              me->mo_run_environment->append_log( iv_log_statement = |{ <msg>-line }| ).
            endloop.
          endif.
        endloop.
        if sy-subrc ne 0.
          ev_execution_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |{ 'No Workflow Found' }| ).
        endif.
        " No extensibility system -> no workflow exists
      else.
        if ls_test_data-action = if_sd_apm_approval=>co_approval_action-recalculate.
          "Check if status of the document is in rework
          if approval_status <> if_sd_apm_approval=>co_approval_status-to_be_reworked.
            me->mo_run_environment->append_log( iv_log_statement = |'The document: ' { lv_sales_doc_number } 'must be in status 'To be reworked' to execute action 'Rework not required'  |  ).
            ev_execution_status = abap_false.
            exit.
          endif.
        endif.
        if ls_test_data-action is initial or
           ls_test_data-action = if_sd_apm_approval=>co_approval_action-release or
           ls_test_data-action = if_sd_apm_approval=>co_approval_action-reject or
           ls_test_data-action = if_sd_apm_approval=>co_approval_action-set_to_rework.
          if approval_status <> if_sd_apm_approval=>co_approval_status-in_approval.
            " update header table with approval status data to simulate workflow
            select single apm_approval_reason from sdapmaprrcat where sd_document_category = @if_sd_doc_category=>order into @data(lv_approval_reason).
            if lv_approval_reason is not initial.
              update vbak set apm_approval_status = @if_sd_apm_approval=>co_approval_status-in_approval, apm_approval_reason = @lv_approval_reason where vbeln = @<vbeln>.
            else.
              update vbak set apm_approval_status = if_sd_apm_approval=>co_approval_status-in_approval apm_approval_reason = '1001'  where vbeln = <vbeln>.
            endif.
            if sy-subrc  = 0.
              commit work and wait.
            endif.
            if sy-subrc <> 0.
              ev_execution_status = abap_false.
            endif.
          endif.
        endif.
        if ls_test_data-action is not initial.
          call function 'SD_SLS_DOC_SET_APPROVAL_ACTION' destination 'NONE'
            exporting
              iv_vbeln           = lv_sales_doc_number
              iv_approval_action = ls_test_data-action
            importing
              et_message         = lt_sdoc_messages
            exceptions
              error_message      = 1.
          if sy-subrc <> 0 or lt_sdoc_messages is not initial.
            loop at lt_sdoc_messages assigning field-symbol(<sdoc_msg>).
              me->mo_run_environment->append_log( iv_log_statement = |{ <sdoc_msg>-msgtxt }| ).
            endloop.
            read table lt_sdoc_messages assigning <sdoc_msg> with key msgty = 'E'.
            if sy-subrc = 0.
              ev_execution_status = abap_false.
              exit.
            endif.
          endif.
        endif.
      endif.
      if ev_execution_status eq abap_true.
        append <vbeln> to ev_document_id.
      endif.
    endloop.

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

  endmethod.


  method read_vcmhm_chain.

    clear: et_vcmhm_chain.

    if it_object_id is initial.
      return.
    endif.

    select * from vcmhmi_rt_chain into corresponding fields of table @et_vcmhm_chain
      for all entries in @it_object_id
      where triggering_object_id = @it_object_id-table_line.

  endmethod.


  method read_vcm_linked_item.

    data: lt_bo_id type table of vcm_business_object_id,
          lv_bo_id type vcm_business_object_id.

    clear: rt_vcm_item.

    if it_sales_key is initial.
      return.
    endif.

    loop at it_sales_key into data(ls_key).
      lv_bo_id = ls_key-vbeln.
      collect lv_bo_id into lt_bo_id.
    endloop.

    select *
      from vcm_rt_bo_item as itema
      inner join vcm_rt_bo_item as itemb on itema~value_chain_ins_guid  = itemb~value_chain_ins_guid and
                                            itema~value_chain_item_guid = itemb~value_chain_item_guid "#EC CI_BUFFJOIN
      left outer join vcm_rt_step_ins as step on itemb~step_ins_guid = step~guid "#EC CI_BUFFJOIN
      left outer join vcm_rt_chain_ins as chain on itemb~value_chain_ins_guid = chain~guid "#EC CI_BUFFJOIN
      into table @rt_vcm_item
      for all entries in @lt_bo_id
*      where itema~business_object_id = @iv_vbeln
      where itema~business_object_id = @lt_bo_id-table_line
       and itema~business_object = 'SALES_ORDER'
       and itema~deleted   = @space
       and itema~cancelled = @space
       and itemb~deleted   = @space
       and itemb~cancelled = @space
       and step~step_type  = 'SOIC'
       and ( chain~status  = 'C' or chain~status = 'E' or chain~status = 'O' or chain~status = 'PD' ).

  endmethod.


  method run_custom_dynamic_checks.
    data:
      lv_class                  type string,
      lo_oref                   type ref to object,
      lo_ptf_bo_so_dynamic_code type ref to if_ptf_bo_so_dynamic_code,
      lt_dynamic_code           type ty_gt_code_line.
    clear ev_immediate_exit.
    rv_check_status = abap_true.

    me->mo_run_environment->append_log( iv_log_statement = 'Running Custom Dynamic Checks.' ).
    loop at it_dynamic_code reference into data(lr_dynamic_code).
      do 2 times.
        clear lt_dynamic_code.
        " some systems block the creation of dynamic code for testing
        " in this case the code is generated a second time without the for testing environment
        if sy-index = 1.
          append lines of value ty_gt_code_line(
            ( `program.` )
            ( `class dcl_ptf_bo_so_dynamic_code definition for testing.` ) " <--
            ( `  public section.` )
            ( `    interfaces if_ptf_bo_so_dynamic_code.` )
            ( `endclass.` )
            ( `class dcl_ptf_bo_so_dynamic_code implementation.` )
            ( `  method if_ptf_bo_so_dynamic_code~dynamic_test_data_change.` )
            ( `  endmethod.` )
            ( `  method if_ptf_bo_so_dynamic_code~custom_dynamic_check.` ) ) to lt_dynamic_code.
        else.
          append lines of value ty_gt_code_line(
            ( `program.` )
            ( `class dcl_ptf_bo_so_dynamic_code definition.` ) " <--
            ( `  public section.` )
            ( `    interfaces if_ptf_bo_so_dynamic_code.` )
            ( `endclass.` )
            ( `class dcl_ptf_bo_so_dynamic_code implementation.` )
            ( `  method if_ptf_bo_so_dynamic_code~dynamic_test_data_change.` )
            ( `  endmethod.` )
            ( `  method if_ptf_bo_so_dynamic_code~custom_dynamic_check.` ) ) to lt_dynamic_code.
        endif.
        split lr_dynamic_code->code at cl_abap_char_utilities=>cr_lf into table data(lt_code_lines).
        append lines of lt_code_lines to lt_dynamic_code.
        append lines of value ty_gt_code_line(
          ( `  endmethod.` )
          ( `endclass.` ) ) to lt_dynamic_code.

        generate subroutine pool lt_dynamic_code name data(lv_prog).
        if sy-subrc <> 0.
          me->mo_run_environment->append_log( iv_log_statement = 'Error when compiling dynamic code.' ).
          continue.
        endif.
        lv_class = `\PROGRAM=` && lv_prog && `\CLASS=DCL_PTF_BO_SO_DYNAMIC_CODE`.
        try.
            " when dynamic generated code for testing is not allowed the object instantiation fails.
            create object lo_oref type (lv_class).
            lo_ptf_bo_so_dynamic_code ?= lo_oref.
            if not lo_ptf_bo_so_dynamic_code->custom_dynamic_check(
                     exporting
                       iv_step_number          = iv_step_number
                       io_ptf_bo               = me
                     importing
                       ev_immediate_exit       = ev_immediate_exit
                       ev_document_id          = ev_document_id
                     changing
                       cs_salesorder_test_data = cs_salesorder_test_data
                   ).
              me->mo_run_environment->append_log( iv_log_statement = 'Error: Custom Dynamic Check failed.' ).
              rv_check_status = abap_false.
            endif.
            exit.
          catch cx_sy_create_object_error.
            me->mo_run_environment->append_log( iv_log_statement = 'For testing environment not allowed. Dynamic test mocking might not be possible. Retrying code generation without for testing.' ).
        endtry.
      enddo.
    endloop.
  endmethod.


  method run_dynamic_test_data_changes.
    data:
      lv_class                  type string,
      lo_oref                   type ref to object,
      lo_ptf_bo_so_dynamic_code type ref to if_ptf_bo_so_dynamic_code,
      lt_dynamic_code           type ty_gt_code_line.
    clear ev_immediate_exit.
    rv_execution_status = abap_true.

    me->mo_run_environment->append_log( iv_log_statement = 'Running Dynamic Testdata Changes.' ).
    loop at it_dynamic_code reference into data(lr_dynamic_code).
      do 2 times.
        clear lt_dynamic_code.
        " some systems block the creation of dynamic code for testing
        " in this case the code is generated a second time without the for testing environment
        if sy-index = 1.
          append lines of value ty_gt_code_line(
            ( `program.` )
            ( `class dcl_ptf_bo_so_dynamic_code definition for testing.` ) " <--
            ( `  public section.` )
            ( `    interfaces if_ptf_bo_so_dynamic_code.` )
            ( `endclass.` )
            ( `class dcl_ptf_bo_so_dynamic_code implementation.` )
            ( `  method if_ptf_bo_so_dynamic_code~dynamic_test_data_change.` ) ) to lt_dynamic_code.
        else.
          append lines of value ty_gt_code_line(
            ( `program.` )
            ( `class dcl_ptf_bo_so_dynamic_code definition.` ) " <--
            ( `  public section.` )
            ( `    interfaces if_ptf_bo_so_dynamic_code.` )
            ( `endclass.` )
            ( `class dcl_ptf_bo_so_dynamic_code implementation.` )
            ( `  method if_ptf_bo_so_dynamic_code~dynamic_test_data_change.` ) ) to lt_dynamic_code.
        endif.
        split lr_dynamic_code->code at cl_abap_char_utilities=>cr_lf into table data(lt_code_lines).
        append lines of lt_code_lines to lt_dynamic_code.
        append lines of value ty_gt_code_line(
          ( `  endmethod.` )
          ( `  method if_ptf_bo_so_dynamic_code~custom_dynamic_check.` )
          ( `  endmethod.` )
          ( `endclass.` ) ) to lt_dynamic_code.

        generate subroutine pool lt_dynamic_code name data(lv_prog).
        if sy-subrc <> 0.

          me->mo_run_environment->append_log( iv_log_statement = 'Error when compiling dynamic code.' ).
          continue.
        endif.
        lv_class = `\PROGRAM=` && lv_prog && `\CLASS=DCL_PTF_BO_SO_DYNAMIC_CODE`.

        try.
            " when dynamic generated code for testing is not allowed the object instantiation fails.
            create object lo_oref type (lv_class).
            lo_ptf_bo_so_dynamic_code ?= lo_oref.
            if not lo_ptf_bo_so_dynamic_code->dynamic_test_data_change(
                     exporting
                       iv_step_number          = iv_step_number
                       io_ptf_bo               = me
                     importing
                       ev_immediate_exit       = ev_immediate_exit
                       ev_document_id          = ev_document_id
                     changing
                       cs_salesorder_test_data = cs_salesorder_test_data
                   ).

              me->mo_run_environment->append_log( iv_log_statement = 'Error: Dynamic Testdata Change failed.' ).
              rv_execution_status = abap_false.
            endif.
            exit.
          catch cx_sy_create_object_error.
            me->mo_run_environment->append_log( iv_log_statement = 'For testing environment not allowed. Dynamic test mocking might not be possible. Retrying code generation without for testing.' ).
        endtry.
      enddo.
    endloop.
  endmethod.


  method select_ic_so.

    data:
      ls_testdata  type ty_gs_ptf_so_select_td,
      lv_statement type string,
      lv_vbeln     type vbeln_va,
      lt_sales_key type table of sales_key,
      lt_vbap      type table of vbap.

    clear: ev_document_id.
    ev_execution_status = abap_false.

* ------------------------------------------ get test parameter -----
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata( exporting is_step_data = ls_step_data
                               importing es_testdata  = ls_testdata ).
    " check test parameter
    if ls_testdata-werks is initial.
      lv_statement = 'No plant configured in test data.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      return.
    endif.

* --------------------------------- get SO4 from reference step -----
    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_sales_key.
    endloop.
    clear lv_vbeln.
    read table lt_sales_key into lv_vbeln index 1.
    if lv_vbeln is initial.
      lv_statement = 'Error: No SO4 order found.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      return. " execution fails
    endif.

* ----------------------------------- select SO4 match to plant -----
    call function 'SD_VBAP_ARRAY_READ_VBELN'
      tables
        it_vbak_key           = lt_sales_key
        et_vbap               = lt_vbap
      exceptions
        records_not_found     = 1
        records_not_requested = 2
        others                = 3.
    if sy-subrc <> 0.
      lv_statement = 'Error: No items found in SO4 order &1'.
      replace '&1' in lv_statement with lv_vbeln.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      return. " execution fails
    endif.

    delete lt_vbap where abgru <> space.
    delete lt_vbap where werks <> ls_testdata-werks.
    if lt_vbap[] is initial.
      lv_statement = 'Error: No SO4 orders found for plant &1'.
      replace '&1' in lv_statement with ls_testdata-werks.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      return.
    endif.

* set execution successful
    data: ls_document_id like line of ev_document_id.
    ev_execution_status = abap_true.
    loop at lt_vbap assigning field-symbol(<fs_vbap>).
      lv_statement = 'SO4 order &1 &2 selected for plant &3'.
      replace '&1' in lv_statement with <fs_vbap>-vbeln.
      replace '&2' in lv_statement with <fs_vbap>-posnr.
      replace '&3' in lv_statement with <fs_vbap>-werks.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      ls_document_id-vbeln = conv #( <fs_vbap>-vbeln ).
      collect ls_document_id into ev_document_id.
    endloop.


  endmethod.


  method set_data_container_item.

    data(ls_data_container) = is_data_container.
    if ls_data_container is not initial.
      ls_data_container-handle = is_item_data-handle.
      data(lo_goal_sdoc_data_cont) = cl_goal_sdoc_data_cont=>get_instance( ).
      lo_goal_sdoc_data_cont->add_item( is_item = ls_data_container ).
    endif.
  endmethod.


  method set_relative_dates.
    loop at it_relative_dates reference into data(lr_relative_date).
      assign component lr_relative_date->date_field_name of structure cs_entity_test_data to field-symbol(<fs_test_data>).
      check sy-subrc = 0.
      <fs_test_data> = sy-datum + lr_relative_date->offset_in_days.
    endloop.
  endmethod.


  METHOD set_status_external_cdra.

    DATA: ls_testdata TYPE ty_gs_i_ptf_so_cr_td_ext_stat.
    DATA: ls_result_key TYPE cl_ptf_util=>ty_result_key_data.
    DATA: lv_sales_doc_number TYPE vbeln.
    DATA: lt_sales_document_numbers TYPE cl_ptf_util=>ty_vbeln_tab.
    DATA: lt_messages TYPE tdt_sdoc_msg.
    DATA: lv_saved TYPE abap_bool.

    ev_execution_status = abap_false.

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_sales_document_numbers.
    ENDLOOP.

    LOOP AT lt_sales_document_numbers ASSIGNING FIELD-SYMBOL(<doc_number>).
      lv_sales_doc_number = <doc_number>.
      cl_sd_sls_comp_test_cdra=>set_status_external(
        EXPORTING
          iv_vbeln              = lv_sales_doc_number
          iv_status             = ls_testdata-apm_status
        IMPORTING
          et_messages           = lt_messages
          ev_saved              = lv_saved
        EXCEPTIONS
          exc_not_test_relevant = 1
          exc_no_data_input     = 2
          OTHERS                = 3
      ).
      IF sy-subrc <> 0.
*       MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ev_check_status     = abap_false.
        ev_execution_status = abap_false.
      ENDIF.

    ENDLOOP.

    ev_check_status     = abap_true.
    ev_execution_status = abap_true.

  ENDMETHOD.


  method wait.

    data:
      ls_testdata      type ty_gs_ptf_so_check_rpts_td,
      lv_attempts_max  type tb_attempts,  " maximumnumber of attempts
      lv_attempts_act  type tb_attempts,  " actual attempts
      lv_waiting_time  type s_mec_cputest_break_seconds,
      lv_idle_seconds  type s_mec_cputest_break_seconds,  " Idle Seconds Before Start
      lv_max_repeats   type /aif/repeat_counter,  " Maximum Number of Repeats
      lv_break_seconds type s_mec_cputest_break_seconds,  " Break Seconds Between Repeats
      lv_number(5)     type c,
      lv_statement     type bapi_msg,
      lv_vbeln         type vbeln_va,
      lt_sales_key     type table of sales_key,
      lt_vbap          type standard table of vbap.

    ev_execution_status = abap_true.
    ev_check_status     = abap_true.

* ------------------------------------------ get test parameter -----
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    cl_ptf_util=>get_testdata( exporting is_step_data = ls_step_data
                               importing es_testdata  = ls_testdata ).

    lv_idle_seconds  = ls_testdata-idle_seconds.  "  Number of Idle Seconds Before Start
    lv_max_repeats   = ls_testdata-max_repeats.  " Maximum Number of Repeats
    lv_break_seconds = ls_testdata-break_seconds.  " Number of Seconds Between Repeats
    lv_attempts_max  = 1 + lv_max_repeats.  " Maximum Number of Attempts = (first try) + (repeats)

* write parameter values into log
    lv_statement = 'Parameter: Idle Seconds Before Start: &1'.
    lv_number = lv_idle_seconds.
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

* -------------------------------------------------------- wait -----
    data: lv_no_so type boole_d.
    wait up to lv_idle_seconds seconds.

* ------------------------------- check and wait SO if required -----
    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_sales_key.
    endloop.
    " no check for SO required
    if lt_sales_key[] is initial.
      lv_statement = 'Error: No SO2 order found.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      return.
    endif.

* ----------------------------------------------------- WAIT SO -----
    clear lv_attempts_act.
    do lv_attempts_max times.
      add 1 to lv_attempts_act.
      clear: lt_vbap,
             lv_vbeln.
      call function 'SD_VBAP_ARRAY_READ_VBELN'
        tables
          it_vbak_key           = lt_sales_key
          et_vbap               = lt_vbap
        exceptions
          records_not_found     = 1
          records_not_requested = 2
          others                = 3.

      if sy-subrc <> 0.
        add lv_break_seconds to lv_waiting_time.
        wait up to lv_break_seconds seconds.

      else.
        lv_no_so = abap_false.
        loop at lt_sales_key into lv_vbeln.
          if not line_exists( lt_vbap[ vbeln = lv_vbeln ] ).
            lv_no_so = abap_true.
          endif.
        endloop.
***
        if lv_no_so eq abap_true.
          add lv_break_seconds to lv_waiting_time.
          wait up to lv_break_seconds seconds.
        else.
          " so found
          exit.
        endif.
      endif.
    enddo.

    lv_number = lv_attempts_act.
    me->mo_run_environment->append_log( |Actual number of attempts to read the VCM item link: { lv_number }| ).

    lv_number = lv_waiting_time.
    me->mo_run_environment->append_log( |Total waiting time: { lv_number } seconds| ).

    if lv_no_so eq abap_false.
      loop at lt_sales_key into lv_vbeln.
        me->mo_run_environment->append_log( |Sales order { lv_vbeln } found| ).
      endloop.
    else.
      me->mo_run_environment->append_log( |Sales order not found after waiting| ).
    endif.

  endmethod.


  method wait_ic_for_so4.

    data:
      ls_testdata      type ty_gs_ptf_so_check_rpts_td,
      lv_attempts_max  type tb_attempts,  " maximumnumber of attempts
      lv_attempts_act  type tb_attempts,  " actual attempts
      lv_waiting_time  type s_mec_cputest_break_seconds,
      lv_idle_seconds  type s_mec_cputest_break_seconds,  " Idle Seconds Before Start
      lv_max_repeats   type /aif/repeat_counter,  " Maximum Number of Repeats
      lv_break_seconds type s_mec_cputest_break_seconds,  " Break Seconds Between Repeats
      lv_number(5)     type c,
      lv_statement     type bapi_msg,
      lv_vbeln         type vbeln_va,
      lt_sales_key     type table of sales_key.

    ev_execution_status = abap_false.

* ------------------------------------------ get test parameter -----
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    cl_ptf_util=>get_testdata( exporting is_step_data = ls_step_data
                               importing es_testdata  = ls_testdata ).

    lv_idle_seconds  = ls_testdata-idle_seconds.  "  Number of Idle Seconds Before Start
    lv_max_repeats   = ls_testdata-max_repeats.  " Maximum Number of Repeats
    lv_break_seconds = ls_testdata-break_seconds.  " Number of Seconds Between Repeats
    lv_attempts_max  = 1 + lv_max_repeats.  " Maximum Number of Attempts = (first try) + (repeats)

* write parameter values into log
    lv_statement = 'Parameter: Idle Seconds Before Start: &1'.
    lv_number = lv_idle_seconds.
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

* ----------------------------------------------------- get SO2 -----
    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_sales_key.
    endloop.
    clear lv_vbeln.
    read table lt_sales_key into lv_vbeln index 1.
    if lv_vbeln is initial.
      lv_statement = 'Error: No SO2 order found.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      return. " execution fails
    endif.

    call function 'SD_VBAP_ARRAY_READ_VBELN'
      tables
        it_vbak_key           = lt_sales_key
*       ET_VBAPVB             =
*       et_vbap               = lt_vbap
      exceptions
        records_not_found     = 1
        records_not_requested = 2
        others                = 3.
    if sy-subrc <> 0.
      " wait for the case SO2 posting not finished yet
      wait up to lv_idle_seconds seconds.
      call function 'SD_VBAP_ARRAY_READ_VBELN'
        tables
          it_vbak_key           = lt_sales_key
        exceptions
          records_not_found     = 1
          records_not_requested = 2
          others                = 3.
      if sy-subrc <> 0.
        lv_statement = 'Error: No items found in SO2 order &1'.
        replace '&1' in lv_statement with lv_vbeln.
        me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
        return. " execution fails
      endif.
    endif.

* ---------------------------------------------------- WAIT SO4 -----
* Idle Seconds Before Start: wait for PO3 + SO4 to be created
    data: lv_no_so4 type boole_d.
    wait up to lv_idle_seconds seconds.
    clear lv_attempts_act.
    do lv_attempts_max times.
      add 1 to lv_attempts_act.

      read_vcm_linked_item( exporting it_sales_key = lt_sales_key
                            receiving rt_vcm_item  = data(lt_vcm_item) ).

      if lt_vcm_item is initial.
        add lv_break_seconds to lv_waiting_time.
        wait up to lv_break_seconds seconds.

      else.
        lv_no_so4 = abap_false.
        loop at lt_vcm_item assigning field-symbol(<ls_item_link>).
          if <ls_item_link>-itemb is initial.
            lv_no_so4 = abap_true.
          endif.
        endloop.
***
        if lv_no_so4 eq abap_true.
          add lv_break_seconds to lv_waiting_time.
          wait up to lv_break_seconds seconds.
        else.
          " so4 found
          exit.
        endif.
      endif.
    enddo.

    lv_statement = 'Actual number of attempts to read the VCM item link: &1'.
    lv_number = lv_attempts_act.
    replace '&1' in lv_statement with lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

    lv_statement = 'Total waiting time: &1 seconds'.
    lv_number = lv_waiting_time.
    replace '&1' in lv_statement with lv_number.
    me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).

* set execution successful after waiting
    ev_execution_status = abap_true.
    append lv_vbeln to ev_document_id.

    if lv_no_so4 eq abap_false.
* write the created SO4 into the output log
      loop at lt_vcm_item assigning <ls_item_link>.
        lv_statement = 'SO4 order: OBJECT &1 , ITEM &2'.
        replace '&1' in lv_statement with <ls_item_link>-itemb-business_object_id.
        replace '&2' in lv_statement with <ls_item_link>-itemb-business_object_item_id.
        me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      endloop.

    else.
      lv_statement = 'SO4 order not found after waiting'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
    endif.


  endmethod.


  method wait_vcm_event.

    data:
      ls_testdata      type ty_gs_ptf_so_check_rpts_td,
      lv_attempts_max  type tb_attempts,  " maximumnumber of attempts
      lv_attempts_act  type tb_attempts,  " actual attempts
      lv_waiting_time  type s_mec_cputest_break_seconds,
      lv_idle_seconds  type s_mec_cputest_break_seconds,  " Idle Seconds Before Start
      lv_max_repeats   type /aif/repeat_counter,  " Maximum Number of Repeats
      lv_break_seconds type s_mec_cputest_break_seconds,  " Break Seconds Between Repeats
      lv_number(5)     type c,
      lv_statement     type bapi_msg.

    ev_execution_status = abap_true.
    ev_check_status     = abap_true.

* ------------------------------------------ get test parameter -----
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    cl_ptf_util=>get_testdata( exporting is_step_data = ls_step_data
                               importing es_testdata  = ls_testdata ).

    lv_idle_seconds  = ls_testdata-idle_seconds.  "  Number of Idle Seconds Before Start
    lv_max_repeats   = ls_testdata-max_repeats.  " Maximum Number of Repeats
    lv_break_seconds = ls_testdata-break_seconds.  " Number of Seconds Between Repeats
    lv_attempts_max  = 1 + lv_max_repeats.  " Maximum Number of Attempts = (first try) + (repeats)

    data(lv_vcm_bo) = ls_testdata-vcm_business_object.
    if lv_vcm_bo is initial.
      lv_vcm_bo = 'SALES_ORDER'.
    endif.

    " write parameter values into log
    lv_statement = 'Parameter: Idle Seconds Before Start: &1'.
    lv_number = lv_idle_seconds.
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

    " wait at first
    wait up to lv_idle_seconds seconds.

    " get PTF keys from reference step
    data: lt_ptf_keys type  cl_ptf_util=>ty_vbeln_tab.
    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      append lines of mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> )
        to lt_ptf_keys.
    endloop.
    if lt_ptf_keys[] is initial.
      lv_statement = 'Error: No document number from reference step.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ lv_statement }| ).
      ev_execution_status = abap_false.
      ev_check_status     = abap_false.
      return.
    endif.

    " start to check and wait
    clear lv_attempts_act.
    do lv_attempts_max times.

      lv_attempts_act = lv_attempts_act + 1.

      data lv_business_object_id type vcm_business_object_id.
      loop at lt_ptf_keys assigning field-symbol(<fs_ptf_key>).
        lv_business_object_id = <fs_ptf_key>.

        try.
            " get VCM chain
            data(lt_chains) = cl_vcm_app_query=>get_instance( )->get_value_chain_by_bo( business_object_id   = lv_business_object_id
                                                                                        business_object_type = lv_vcm_bo ).
            loop at lt_chains assigning field-symbol(<fs_chain>).
              data(lv_queue_event_exists) = cl_vcm_app_query=>get_instance( )->is_event_queue_existing( <fs_chain>-guid ).
              if lv_queue_event_exists = abap_true.
                exit.
              endif.
            endloop.
            " one of the chain still in queue -> wait and try again
            if lv_queue_event_exists = abap_true.
              exit.
            endif.

          catch cx_vcm_rt_business.
        endtry.

      endloop.

      " one of the document still in queue -> wait and try again
      if lv_queue_event_exists = abap_true.
        add lv_break_seconds to lv_waiting_time.
        wait up to lv_break_seconds seconds.

        " nothing found in queue -> stop waiting
      else.
        exit.
      endif.

    enddo.

    " log the result
    lv_number = lv_attempts_act.
    mo_run_environment->append_log( |Actual number of attempts to check the queue: { lv_number }| ).
    lv_number = lv_waiting_time.
    mo_run_environment->append_log( |Total waiting time: { lv_number } seconds| ).

    if lv_queue_event_exists = abap_true.
      ev_execution_status = abap_false.
      ev_check_status     = abap_false.
      mo_run_environment->append_log( |VCM event queue still in process| ).
    else.
      mo_run_environment->append_log( |VCM event queue all processed| ).

    endif.

  endmethod.


  method withdraw_from_approval.

    data:
      lv_sales_doc_number       type vbeln,
      lv_ptf_key                type ptfkey,
      lt_sdoc_messages          type tdt_sdoc_msg,
      lt_sales_document_numbers type cl_ptf_util=>ty_vbeln_tab.

    ev_execution_status = abap_true.

    loop at step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_sales_document_numbers.
    endloop.

    loop at lt_sales_document_numbers assigning field-symbol(<doc_number>).
      lv_sales_doc_number = <doc_number>.
      select single apm_approval_status from vbak where vbeln = @lv_sales_doc_number into @data(approval_status).
      if approval_status <> if_sd_apm_approval=>co_approval_status-in_approval.
        me->mo_run_environment->append_log( iv_log_statement = |'The document: ' { lv_sales_doc_number } 'must be in status 'In approval' to execute action 'Withdraw'  |  ).
        ev_execution_status = abap_false.
        exit.
      endif.
      cl_sd_apm_workflow=>suspend_workflow( iv_vbtyp = if_sd_doc_category=>order
                                            iv_vbeln = lv_sales_doc_number ).
      call function 'SD_SLS_DOC_SET_APPROVAL_ACTION' destination 'NONE'
        exporting
          iv_vbeln           = lv_sales_doc_number
          iv_approval_action = if_sd_apm_approval=>co_approval_action-withdraw
        importing
          et_message         = lt_sdoc_messages
        exceptions
          error_message      = 1.
      if sy-subrc <> 0 or lt_sdoc_messages is not initial.
        loop at lt_sdoc_messages assigning field-symbol(<sdoc_msg>).
          me->mo_run_environment->append_log( iv_log_statement = |{ <sdoc_msg>-msgtxt }| ).
        endloop.
        read table lt_sdoc_messages assigning <sdoc_msg> with key msgty = 'E'.
        if sy-subrc = 0.
          ev_execution_status = abap_false.
          exit.
        endif.
      endif.
    endloop.

    if ev_execution_status eq abap_true.
      cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
      clear lv_sales_doc_number.
      loop at lt_sales_document_numbers into lv_sales_doc_number.
        move lv_sales_doc_number to lv_ptf_key.
        ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).
        if ev_execution_status eq abap_false.
          return.
        else.
          append lv_ptf_key to ev_document_id.
        endif.
      endloop.
    endif.

  endmethod.


  method CHANGE_FIRSDATE.
    data: ls_testdata       type ty_gs_i_ptf_so_cr_td,
          lv_immediate_exit type abap_bool.

    ev_execution_status = abap_false.
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = ls_step_data
      importing
        es_testdata  = ls_testdata ).

    " Run dynamic testdata changes
    if ls_testdata-dynamic_testdata_changes is not initial.
      ev_execution_status = me->run_dynamic_test_data_changes(
        exporting
          iv_step_number          = iv_step_number
          it_dynamic_code         = ls_testdata-dynamic_testdata_changes
        importing
          ev_immediate_exit       = lv_immediate_exit
          ev_document_id          = ev_document_id
        changing
          cs_salesorder_test_data = ls_testdata
      ).
      check lv_immediate_exit = abap_false.
    endif.

    "Add CMPIF Implemetations
    loop at ls_testdata-components_cmpif into data(ls_component_cmpif).
      if ls_component_cmpif-component_id is not initial.
        cl_sd_sls_comp_factory=>so_instance->add_component( ls_component_cmpif ).
      endif.
    endloop.

    Loop at ls_testdata-item_list INTO DATA(ls_item).
      data : ls_date type sy-datum.
      if ls_item-etdat is NOT INITIAL.
        call function 'CNV_MBT_ADD_DATE'
         EXPORTING
           IP_DAYS  = '5'
           IP_DATE  = sy-datum
         IMPORTING
           EP_DATE  = ls_date .
        if sy-subrc <> 0.
* Implement suitable error handling here
          else.
            ls_item-etdat = |{ ls_date+6(2) }.{ ls_date+4(2) }.{ ls_date+0(4) }|.
        endif.
      endif.
      MODIFY ls_testdata-item_list FROM ls_item.
      clear ls_item.
      ENDLOOP.

    " Enable VCM synchronous processing
    data(vcm_test_utility) = cl_vcmhm_test_utility=>get_instance( ).
    if ls_testdata-vcm_run_sync = abap_true.
      cl_sd_sls_ic_vcm_step_init_so=>sv_ptf_vcm_sync_mode = abap_true.
      vcm_test_utility->enable_sync_processing( ).
    endif.

    if ls_testdata-goal_bo_id is initial.
      ls_testdata-goal_bo_id = if_goal_sdoc=>co_bo_id-salesorder.
    endif.

    loop at ls_step_data-reference_step assigning field-symbol(<prestep_numbr>).
      data(ls_step_precessor) = me->mo_run_environment->get_step_data( iv_step_number = <prestep_numbr> ).
      move ls_step_precessor-document_id to ev_document_id.
      loop at ev_document_id  assigning field-symbol(<vbeln>).
        try.
            data(lo_goal_access) = cl_goal_api=>so_instance->open(
              exporting
                iv_bo_id            = ls_testdata-goal_bo_id
                iv_bo_key           = <vbeln>-vbeln && ''
                iv_read_only        = abap_false
                is_control_settings = value if_goal_access=>tcs_control_settings( no_conversion = abap_true )
                it_scenario_id      = ls_testdata-goal_scenario_ids ).
            merge_goal_salesorder(
              exporting
                io_goal_access          = lo_goal_access
              changing
                cs_salesorder_test_data = ls_testdata ).
            lo_goal_access->save( exporting iv_synchron = abap_true ).
            data(lv_error_occured) = log_goal_messages(
              importing
                io_goal_access = lo_goal_access ).
            lo_goal_access->close( ).
            if lv_error_occured = abap_true.
              exit.
            endif.

            " Workaround to run VCM synchronously -- not working for change!
            if ls_testdata-vcm_run_sync = abap_true.
              select * from vbap into table @data(lt_vbap) where vbeln = @<vbeln>-vbeln.
              data: lv_vcm_chain_uuid type vcm_uuid.
              loop at lt_vbap reference into data(lr_vbap) group by lr_vbap->vcm_chain_uuid.
                lv_vcm_chain_uuid = lr_vbap->vcm_chain_uuid.
                vcm_test_utility->resume_value_chain( lv_vcm_chain_uuid ).
              endloop.
            endif.

          catch cx_goal_exc into data(lx_goal_exc).
            cl_message_helper=>set_msg_vars_for_if_t100_msg( lx_goal_exc ).
            me->mo_run_environment->append_log( iv_log_statement = |{ lx_goal_exc->get_text( ) }| ).
            exit.
        endtry.
      endloop.
    endloop.

    "delete CMPIF Implemetations
    loop at ls_testdata-components_cmpif into ls_component_cmpif.
      if ls_component_cmpif-component_id is not initial.
        cl_sd_sls_comp_factory=>so_instance->del_component( iv_comp_id = ls_component_cmpif-component_id ).
      endif.
    endloop.

    ev_execution_status = abap_true.

  endmethod.


  method change_goods_date.
    data: ls_testdata       type ty_gs_i_ptf_so_cr_td,
          messages          type bapiret2_tab,
          posnr             type posnr_va,
          lt_schedule_in    type table of bapischdl,
          lt_schedule_inx   type table of bapischdlx,
          ls_schedule_in    type bapischdl,
          ls_schedule_inx   type bapischdlx,
          lv_immediate_exit type abap_bool,
          lv_date           type char10,

          lt_bdcdata        type table of bdcdata,
          lt_msgtab         type table of bdcmsgcoll.
    data(lv_mode) = 'N'.
    ev_execution_status = abap_false.
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = ls_step_data
      importing
        es_testdata  = ls_testdata ).


    lv_date = |{ sy-datum+6(2) }.{ sy-datum+4(2) }.{ sy-datum+0(4) }|.

    loop at ls_step_data-reference_step assigning field-symbol(<prestep_numbr>).
      data(ls_step_precessor) = me->mo_run_environment->get_step_data( iv_step_number = <prestep_numbr> ).
      move ls_step_precessor-document_id to ev_document_id.
      loop at ev_document_id  assigning field-symbol(<vbeln>).
        clear: lt_bdcdata.

        append value #( program = 'SAPMV45A' dynpro = '0102' dynbegin = 'X' ) to lt_bdcdata.
        append value #( fnam = 'BDC_CURSOR' fval = 'VBAK-VBELN' ) to lt_bdcdata.
        append value #( fnam = 'BDC_OKCODE' fval = '=ENT2' ) to lt_bdcdata.
        append value #( fnam = 'VBAK-VBELN' fval = <vbeln>-vbeln ) to lt_bdcdata.

        append value #( program = 'SAPMV45A' dynpro = '4001' dynbegin = 'X' ) to lt_bdcdata.
        append value #( fnam = 'BDC_OKCODE' fval = '=ITEM' ) to lt_bdcdata.

        append value #( program = 'SAPMV45A' dynpro = '4003' dynbegin = 'X' ) to lt_bdcdata.
        append value #( fnam = 'BDC_OKCODE' fval = '=T\07' ) to lt_bdcdata.
        append value #( fnam = 'BDC_CURSOR' fval = 'RV45A-KWMENG' ) to lt_bdcdata.

        append value #( program = 'SAPMV45A' dynpro = '4003' dynbegin = 'X' ) to lt_bdcdata.
        append value #( fnam = 'BDC_OKCODE' fval = '=SHLI' ) to lt_bdcdata.
        append value #( fnam = 'BDC_CURSOR' fval = 'RV45A-ETDAT(01)' ) to lt_bdcdata.



        IF lines( ls_testdata-item_list ) = 1.
          append value #( program = 'SAPMV45A' dynpro = '4004' dynbegin = 'X' ) to lt_bdcdata.
          append value #( fnam = 'BDC_OKCODE' fval = '=T\02' ) to lt_bdcdata.
          append value #( fnam = 'BDC_CURSOR' fval = 'RV45A-ETDAT' ) to lt_bdcdata.

          append value #( program = 'SAPMV45A' dynpro = '4004' dynbegin = 'X' ) to lt_bdcdata.
          append value #( fnam = 'BDC_OKCODE' fval = '=EIN+' ) to lt_bdcdata.
          append value #( fnam = 'VBEP-WADAT' fval = lv_date ) to lt_bdcdata.
          append value #( fnam = 'VBEP-LDDAT' fval = lv_date ) to lt_bdcdata.
          append value #( fnam = 'VBEP-TDDAT' fval = lv_date ) to lt_bdcdata.

          append value #( program = 'SAPMV45A' dynpro = '4004' dynbegin = 'X' ) to lt_bdcdata.
          append value #( fnam = 'BDC_OKCODE' fval = '/00' ) to lt_bdcdata.
          append value #( fnam = 'VBEP-WADAT' fval = lv_date ) to lt_bdcdata.
          append value #( fnam = 'VBEP-LDDAT' fval = lv_date ) to lt_bdcdata.
          append value #( fnam = 'VBEP-TDDAT' fval = lv_date ) to lt_bdcdata.

          append value #( program = 'SAPMV45A' dynpro = '4004' dynbegin = 'X' ) to lt_bdcdata.
          append value #( fnam = 'BDC_OKCODE' fval = '=SICH' ) to lt_bdcdata.

        elseIF lines( ls_testdata-item_list ) = 2.

          append value #( program = 'SAPMV45A' dynpro = '4004' dynbegin = 'X' ) to lt_bdcdata.
          append value #( fnam = 'BDC_OKCODE' fval = '=T\02' ) to lt_bdcdata.
          append value #( fnam = 'BDC_CURSOR' fval = 'RV45A-ETDAT' ) to lt_bdcdata.

          append value #( program = 'SAPMV45A' dynpro = '4004' dynbegin = 'X' ) to lt_bdcdata.
          append value #( fnam = 'BDC_OKCODE' fval = '/EBACK' ) to lt_bdcdata.
          append value #( fnam = 'BDC_CURSOR' fval = 'VBEP-TDDAT' ) to lt_bdcdata.
          append value #( fnam = 'VBEP-WADAT' fval = lv_date ) to lt_bdcdata.
          append value #( fnam = 'VBEP-LDDAT' fval = lv_date ) to lt_bdcdata.
          append value #( fnam = 'VBEP-MBDAT' fval = lv_date ) to lt_bdcdata.
          append value #( fnam = 'VBEP-TDDAT' fval = lv_date ) to lt_bdcdata.


          append value #( program = 'SAPMV45A' dynpro = '4003' dynbegin = 'X' ) to lt_bdcdata.
          append value #( fnam = 'BDC_OKCODE' fval = '=POS+' ) to lt_bdcdata.
          append value #( fnam = 'BDC_CURSOR' fval = 'RV45A-ETDAT(01)' ) to lt_bdcdata.

          append value #( program = 'SAPMV45A' dynpro = '4003' dynbegin = 'X' ) to lt_bdcdata.
          append value #( fnam = 'BDC_OKCODE' fval = '=SHLI' ) to lt_bdcdata.
          append value #( fnam = 'BDC_CURSOR' fval = 'RV45A-ETDAT(01)' ) to lt_bdcdata.

          append value #( program = 'SAPMV45A' dynpro = '4004' dynbegin = 'X' ) to lt_bdcdata.
          append value #( fnam = 'BDC_OKCODE' fval = '=SICH' ) to lt_bdcdata.
          append value #( fnam = 'BDC_CURSOR' fval = 'VBEP-TDDAT' ) to lt_bdcdata.
          append value #( fnam = 'VBEP-WADAT' fval = lv_date ) to lt_bdcdata.
          append value #( fnam = 'VBEP-LDDAT' fval = lv_date ) to lt_bdcdata.
          append value #( fnam = 'VBEP-MBDAT' fval = lv_date ) to lt_bdcdata.
          append value #( fnam = 'VBEP-TDDAT' fval = lv_date ) to lt_bdcdata.

        endif.

        " -- Call VA02 via BDC
        call transaction 'VA02' using lt_bdcdata
                                 mode lv_mode
                                 update 'S'
                                 messages into lt_msgtab.
      endloop.
    endloop.


    ev_execution_status = abap_true.

  endmethod.
ENDCLASS.
