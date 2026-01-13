"! @testing CL_PTF_RUN
CLASS tcl_ptf_ddci_c50_1 DEFINITION  "test relation is irrelevant, defined to avoid warning
  PUBLIC
  INHERITING FROM tcl_ptf_test_class_super
  FINAL
  CREATE PUBLIC
  FOR TESTING
  DURATION LONG
  RISK LEVEL DANGEROUS .

  PUBLIC SECTION.
  PROTECTED SECTION.
private section.

  methods A_VALIDATE_PACKAGES
  for testing .
  methods A_VALIDATE_PTF_TABUS
  for testing .
  methods CALL_9_MIXED_SCRIPTS
  for testing .
  methods CALL_ONE_SCRIPT
  for testing .
  methods CALL_CRM_SCRIPTS
  for testing .
  methods CALL_MSCENARIOS
  for testing .
  methods CALL_SOME_SCOMP_SCRIPTS
  for testing .
  methods CALL_SOME_RAP_SCRIPTS
  for testing .
  methods CALL_Y_50_SDBIL_SCRIPTS . "for testing .
  methods CALL_BEST_PRACTC_ONLY_SCRIPTS1
  for testing .
  methods XCALL_ONE_SCRIPT_WITH_FULL_LOG
  for testing .
  methods CALL_BEST_PRACTC_ONLY_SCRIPTS2
  for testing .
  methods CALL_RAP_RETRIEVE_SCRIPT1
  for testing .
  methods CALL_RAP_RETRIEVE_SCRIPT2
  for testing .
  methods CALL_TAP_RETRIEVE_SCRIPT1
  for testing .
ENDCLASS.



CLASS TCL_PTF_DDCI_C50_1 IMPLEMENTATION.


  METHOD a_validate_packages.

    SELECT SINGLE * FROM tadir INTO @DATA(ls_tadir_1) WHERE
      object = 'DEVC' AND obj_name = 'CRMS4_PTF_HOME' .
    cl_abap_unit_assert=>assert_initial(
      act = sy-subrc
        msg   = 'Package CRMS4_PTF_HOME missing'
        quit  = if_abap_unit_constant=>quit-no
    ).


    SELECT SINGLE * FROM tadir INTO @DATA(ls_tadir_2) WHERE
      object = 'DEVC' AND obj_name = 'LE_HOME_PTF' .
    cl_abap_unit_assert=>assert_initial(
      act = sy-subrc
        msg   = 'Package LE_HOME_PTF missing'
        quit  = if_abap_unit_constant=>quit-no
    ).

    SELECT SINGLE * FROM tadir INTO @DATA(ls_tadir_3) WHERE
      object = 'DEVC' AND obj_name = 'ERP_SD_HOME_RETURNS' .
    cl_abap_unit_assert=>assert_initial(
      act = sy-subrc
        msg   = 'Package ERP_SD_HOME_RETURNS missing'
        quit  = if_abap_unit_constant=>quit-no
    ).

  ENDMETHOD.


  METHOD a_validate_ptf_tabus.

    SELECT SINGLE * FROM ptf_varid INTO @DATA(ls_dummy).
    cl_abap_unit_assert=>assert_initial(
      act = sy-subrc
      msg   = 'There are no PTF scripts in this client.'
*        quit  = if_abap_unit_constant=>quit-no
    ).

    SELECT varname, step_number, input_string FROM ptf_varcon INTO TABLE @DATA(lt_varcon).
    LOOP AT lt_varcon ASSIGNING FIELD-SYMBOL(<varcon>).
      IF <varcon>-input_string IS NOT INITIAL.
        DATA(lv_found_json_data) = abap_true.
        EXIT.
      ENDIF.
    ENDLOOP.
    cl_abap_unit_assert=>assert_not_initial(
      act = lv_found_json_data
      msg   = 'PTF JSON data not found, it seems it has not been copied.'
    ).

  ENDMETHOD.


  METHOD call_9_mixed_scripts.

    IF sy-sysid NE 'C50'.
      RETURN.
    ENDIF.

    _call_named_scripts( VALUE #(
     ( 'SFS_STD' )
     ( 'SALES_ORDER_ANA_FIELDS' )
     ( 'CR_CRED_DEB_BDR' )
     ( 'BD_EVENT_CANCELED' )
     ( 'REVERSE_GOODS_MOVEMENT' )  "added
     ( 'SDBIL_BD_VAT_DET_BLANK_C3' )
     ( 'CANCEL_BIL_DOC_ODATA' )
     ( 'INV_GET_PDF' )
     ( 'DEMO_RAP_CREATE' )
     ( 'MAKEBANKTRANSFERS' )
    ) ).

  ENDMETHOD.


  METHOD CALL_BEST_PRACTC_ONLY_SCRIPTS1.

    IF sy-sysid NE 'C50'.
      RETURN.
    ENDIF.
***
**temp, add some messages to count max limit in sapgui - seems to be 75 messages per test method
*    cl_abap_unit_assert=>fail(
*        msg    =  'Temp message to count message limit(1)'
*        level  = if_abap_unit_constant=>severity-low
*        quit   = if_abap_unit_constant=>quit-no
*    ).
*    cl_abap_unit_assert=>fail(
*        msg    =  'Temp message to count message limit(2)'
*        level  = if_abap_unit_constant=>severity-low
*        quit   = if_abap_unit_constant=>quit-no
*    ).
***

    _call_named_scripts( VALUE #(
     ( 'BD_ATTACHMENT' )
     ( 'BD_CHECK_PAYPAL_DATA' )
     ( 'BD_CHECK_TEXT_DMR4' )
     ( 'BD_CR_WITH_WS' )
*     ( 'BD_EVENT_CANCELED' ) BDR_EVENT* use sComp customer
*     ( 'BD_EVENT_CHANGED' )
*     ( 'BD_EVENT_CREATE' )
     ( 'BD_FROM_PBD_DMR4' )
*     ( 'BD_FROM_PBD_OR' )     sComp material TG-D11
     ( 'BD_FROM_PBD_OR_DE' )
     ( 'BD_FROM_PBD_OR_US' )
     ( 'CANCEL_BIL_DOC_ODATA' )
     ( 'CHECK_EDI_INVOICE_SPLIT_ARIBA' )
     ( 'CR_CM01_REF_CI01' )
     ( 'DMR_CHECK_AFTER_PBD_REJECT' )    "very stable
     ( 'INTERCOMDMR' )
     ( 'INTERCOMORDER' )
     ( 'INTERCOMP_DE_BE' )
     ( 'INVOICE_CANCEL_INVOICE_LIST' )
     ( 'INVOICE_CUSTOMER_INV_CREATE' )
     ( 'INVOICE_DOC_MANAGE' )
     ( 'INVOICE_WITH_FIN_DOC' )
     ( 'INVOICELIST' )
     ( 'ODATA_GET_INVOICE_LIST' )
     ( 'OUTPUT_BD_DMR4' )
     ( 'OUTPUT_BD_SFS' )
     ( 'OUTPUT_FROM_PS' )
     ( 'PBD_ACTIVATE' )
     ( 'PBD_ADD_ITEM_BASIC' )
     ( 'PBD_CANCEL_ITEM' )
     ( 'PBD_COMP_INV' )
     ( 'PBD_COMPARE_INVOICE_PS' )
     ( 'PBD_DMR_CREATE_COMPARE' )
     ( 'PBD_DOUBLE' )
     ( 'PBD_DOUBLE_INV' )
     ( 'PBD_REJECT_CHECK' )
*     ( 'PBD_REJECT_WITH_LOCKED_PRED' )
     ( 'PBD_SET_FINAL_N_CHECK' )
     ( 'PBD_TEXT' )
     ( 'PRE_BIL_CREATE_PRE_BIL_DOC' )
     ( 'PRE_BIL_GET_OBJECT_PAGE_DATA' )
     ( 'REVERSE_GOODS_MOVEMENT' )
     ( 'SD_BIL_OUTPUT_SCHEDULING_P_E' )
     ( 'SD_BIL_OUTPUT_SCHEDULING_PRINT' )
     ( 'SD_BIL_PBD_NO_COLL_IN_ACT' )
     ( 'SDBIL_1000011882' )
*     ( 'SDBIL_ADVC_ICO_DE_US_DLV_START' )  requires more content
     ( 'SDBIL_BD_1H0_CLEARING_STATUS' )
*     ( 'SDBIL_BD_ADVC_ICO_CHECK_VCM' )  requires more content
*     ( 'SDBIL_BD_ADVC_ICO_CHECK_WAVWR' )
*     ( 'SDBIL_BD_ADVC_ICO_PROF_SEGM' )
*     ( 'SDBIL_BD_ADVC_ICO_W_CANCEL' )
*     ( 'SDBIL_BD_ADVC_ICO_W_CMR_G2' )
*     ( 'SDBIL_BD_ADVC_ICO_W_G2' )
*     ( 'SDBIL_BD_ADVC_INTERCOMP_US_DE' )
     ( 'SDBIL_BD_CLRST_DPY' )
     ( 'SDBIL_BD_CLRST_PART_PAY' )
     ( 'SDBIL_BD_CONSI_PROCESSES' )
     ( 'SDBIL_BD_DMR_CLEARING_STATUS' )
     ( 'SDBIL_BD_DMR_SNAPSHOT_LOCK' )
     ( 'SDBIL_BD_DPY_CONTR_CHECK_SETTL' )
     ( 'SDBIL_BD_DPY_CONTR_CHKS_2DP' )
     ( 'SDBIL_BD_DPY_CONTR_CHKS_2IT' )
     ( 'SDBIL_BD_DPY_CONTR_CHKS_BATCH' )
     ( 'SDBIL_BD_DPY_CONTR_CHKS_PPR' )
     ( 'SDBIL_BD_DPY_CONTR_CONVERGENCE' )
     ( 'SDBIL_BD_DPY_CONTR_LESS_AMOUNT' )
     ( 'SDBIL_BD_EXT_CLEARING_STATUS' )
     ( 'SDBIL_BD_G2_CLEARING_STATUS' )
     ( 'SDBIL_BD_ICO_W_ACC_RET_BTC' )  "no. 70

    ) ).

  ENDMETHOD.


  METHOD CALL_BEST_PRACTC_ONLY_SCRIPTS2.

    IF sy-sysid NE 'C50'.
      RETURN.
    ENDIF.




    _call_named_scripts( VALUE #(
     ( 'SDBIL_BD_INTERCOMP_DE_US' )   "no. 1
     ( 'SDBIL_BD_KIDNO_BSEG' )
     ( 'SDBIL_BD_ODATA_CLEARING_STATUS' )
     ( 'SDBIL_BD_PAY_PAL_CLRST' )
     ( 'SDBIL_BD_PBD_CLEARING_STATUS' )
     ( 'SDBIL_BD_SFS_CLEARING_STATUS' )
     ( 'SDBIL_BD_SFS_CPF_ADDR' )
     ( 'SDBIL_BD_SFS_CPF_CMR' )
     ( 'SDBIL_BD_SFS_CPF_DEFAULT' )
     ( 'SDBIL_BD_SFS_CPF_DMR' )
     ( 'SDBIL_BD_SFS_CPF_PBD' )
     ( 'SDBIL_BD_SFS_CPF_SNAPSHOT' )
     ( 'SDBIL_BD_SFS_CPF_TXT' )
     ( 'SDBIL_BD_SFS_EMPTY_CLRST' )
     ( 'SDBIL_BD_VAT_DET_A' )
     ( 'SDBIL_BD_VAT_DET_B' )
     ( 'SDBIL_BD_VAT_DET_BLANK_C1' )
     ( 'SDBIL_BD_VAT_DET_BLANK_C2' )
     ( 'SDBIL_BD_VAT_DET_BLANK_C3' )
     ( 'SDBIL_BD_VAT_DET_C_C1' )
     ( 'SDBIL_BD_VAT_DET_C_C2' )
     ( 'SDBIL_BD_VAT_DET_C_C3' )
     ( 'SDBIL_BD_VAT_DET_D' )
     ( 'SDBIL_FLEX_BBI_A' )
     ( 'SDBIL_FLEX_BBI_B' )
     ( 'SDBIL_FLEX_BBI_STD' )
     ( 'SDBIL_IL_CLEARING_STATUS' )
     ( 'SDBIL_INTERCOMPANY_US_DE_DMR' )
     ( 'SDBIL_INTERORDER_DMR' )
     ( 'SDBIL_INVLST_BD_CANCEL' )
     ( 'SDBIL_OC_2EQ_SOS' )
     ( 'SDBIL_OC_AGGREGATION_KDGRP' )
     ( 'SDBIL_OC_BKZ_DEBIT' )
     ( 'SDBIL_OC_INV_LIST' )
     ( 'SDBIL_OC_PROF_SERV' )
     ( 'SDBIL_OC_STANDARD' )
     ( 'SDBIL_PBD_BP_STATUS' )
     ( 'SDBIL_PBD_DMR_DIF_CUR_COMP' )
     ( 'SDBIL_SFS_DE_FR_TDT' )
     ( 'SDBIL_SFS_DE_FR_TRIT' )
     ( 'SDBIL_SFS_FOREIGN_TRADE' )
     ( 'SDBIL_SFS_FT_WITH_PBD' )
     ( 'SDBIL_SFS_FT_WITH_SNAPSHOT' )
     ( 'SDBIL_SFS_TRIT_TDT' )
     ( 'SDBIL_SFS_TRIT_TDT_INAC' )
     ( 'SDBIL_SOAP_CREATE_CDM_WITH_REF' )
     ( 'SDBIL_SOAP_SIMULATE_PRICING' )
     ( 'SFS_CLR_CNCL_I1' )
     ( 'SFS_CNCL_I1' )
     ( 'SFS_I3' )
     ( 'SFS_PBD_BD_CNCL_I1' )
     ( 'SFS_PBD_REJ_BD_CNCL_I1' )
     ( 'SFS_PBD_REJ_I1' )
     ( 'SFS_SPLIT_DIFF_WE_COUNTRIES' )
     ( 'SFS_STD' )  "no. 55

    ) ).

  ENDMETHOD.


  METHOD call_crm_scripts.

    IF sy-sysid NE 'C50'.
      RETURN.
    ENDIF.

    _call_named_scripts( VALUE #(
     ( 'CTU2_PTF_DEMO_2' )
     "( 'IHR_RPO1_CR_RO_SET_STATUS' )  "implemented ABAP EML call, no error handling
     "( 'IHR_RPO1_SET_RO_COMPL' )      master data problem, fails with BuPa error in COMMIT
     ( 'SERVICEORDER_RAP_PTF1' )
*     ( 'S4CCE1905_SRV_FT_CTR_H_CANCEL2' )  SRV CONTRACT: unkwnown why BDR creation fails in C50 but not in DDCI
    ) ).

  ENDMETHOD.


  METHOD call_mscenarios.

    IF sy-sysid NE 'C50'.
      RETURN.
    ENDIF.

    _call_named_scripts( VALUE #(
     ( 'MS_1EZ_BD9_DE' )
     ( 'MS_1EZ_BD9_US' )
     ( 'MS_1EZ_US' )  "not in testplan
     ( 'MS_2EQ_DE' )
     ( 'MS_2EQ_US' )
     ( 'MS_2ET_DE' )
     ( 'MS_2ET_US' )
     ( 'MS_BD3_DE' )
     ( 'MS_BD3_US' )
     ( 'MS_BD9_MIX1_DE' )
     ( 'MS_BD9_MIX1_US' )
     ( 'MS_BD9_MIX2_DE' )
     ( 'MS_BD9_MIX2_US' )
     ( 'MS_BDA_DE')
     ( 'MS_BDA_US' )
     ( 'QUOTE_BDG_01_US' )
     ( 'QUOTE_BDG_02_US' )
     ( 'BD9_BEST_PRACTICE' )
     ( 'BD9_BEST_PRACTICE_US' )
     ( 'BD9_WITH_TEXT_BEST_PRACTICE_DE' )
     ( 'BD9_WITH_TEXT_BEST_PRACTICE_US' )
    ) ).

  ENDMETHOD.


  METHOD call_one_script.

    IF sy-sysid NE 'C50'.
      RETURN.
    ENDIF.

    _call_named_scripts( VALUE #( ( 'AUNIT02' ) )
    ).

  ENDMETHOD.


  METHOD CALL_RAP_RETRIEVE_SCRIPT1.

    IF sy-sysid NE 'C50'.
      RETURN.
    ENDIF.

    _call_named_scripts(
      it_varname      = VALUE #( ( 'DEMO_RAP_RETRIEVE' ) )
      iv_add_full_log = 'X'
    ).

  ENDMETHOD.


  METHOD CALL_RAP_RETRIEVE_SCRIPT2.

    IF sy-sysid NE 'C50'.
      RETURN.
    ENDIF.

    _call_named_scripts(
      it_varname      = VALUE #( ( 'DEMO_RAP_RETRIEVE' ) )
      iv_add_full_log = 'X'
    ).

  ENDMETHOD.


  METHOD call_some_rap_scripts.

    IF sy-sysid NE 'C50'.
      RETURN.
    ENDIF.

    _call_named_scripts( VALUE #(
     ( 'DEMO_RAP_CHECK_IF_EXISTS' )
     ( 'DEMO_RAP_DELETE' )
     ( 'PRODSA_PRD_SUPPLY_AREA_CREATE' )
     ( 'DEMO_RAP_RETRIEVE' )
*     ( 'CUSTOMER_RETURN_TC22' )    (E)Product valuation suspension not activated for returns order type "CBAR"(Key: 000010 )
*     ( 'ARM_FICO_PSG_LV_LR_LUMF' )    BEHV dump
*     ( 'CTU2_PTF_MNTF_E2E_1_1' )   EML Error: NOT_FOUND    Error Key Fields: PLANT: 1110 NOTIFICATIONTYPE: Y1 MAINTEVTPRIORITIZATIONPROFILE: YB-PM00001 MAINTEVENTCONSEQUENCEGROUP: YEAM01
*     ( 'EAM_PTF_4HI_E2E_NSM' )     Task list A 476 1 does not exist         (is a hard coded reference in JSON)
    ) ).

  ENDMETHOD.


  METHOD call_some_scomp_scripts.

    IF sy-sysid NE 'C50'.
      RETURN.
    ENDIF.

    _call_named_scripts( VALUE #(
     ( 'CR_BDR_G2N' )
     ( 'SDBIL_BD_BDR_CPYCTL_REF_MOCKD' )
     ( 'BDR_CR_WITH_WS' )
    ) ).

  ENDMETHOD.


  METHOD CALL_TAP_RETRIEVE_SCRIPT1.

    IF sy-sysid NE 'C50'.
      RETURN.
    ENDIF.

    _call_named_scripts(
      it_varname      = VALUE #( ( 'DEMO_RAP_RETRIEVE' ) )
      iv_add_full_log = 'X'
    ).

  ENDMETHOD.


  METHOD call_y_50_sdbil_scripts.

    IF sy-sysid NE 'C50'.
      RETURN.
    ENDIF.

    _call_named_scripts( VALUE #(
*     ( 'RAP_SFS_I3_Q10_PARTIAL' )   "excluded scripts presumably failing bec of missing sComp data
*     ( 'RAP_SFS_I3_NO_FIN_2CNCL' )
*     ( 'RAP_SFS_I3_2CNCL' )
     ( 'SDBIL_BD_RAP_CANCEL' )
     ( 'SDBIL_OUTPUT_RAP' )
     ( 'SDBIL_BD_RAP_PARTIAL_BILLING' )
*     ( 'SFS_I50_DIFF_QANTITY' )
*     ( 'SFS_I3' )
     ( 'SDBIL_SFS_FT_WITH_SNAPSHOT' )
     ( 'SDBIL_SFS_FT_WITH_PBD' )
*     ( 'SDBIL_SFS_FOREIGN_TRADE' )
*     ( 'SFS_PBD_REJ_BD_CNCL_I1' )
*     ( 'SFS_PBD_BD_CNCL_I1' )
*     ( 'SFS_PBD_REJ_I1' )
     ( 'SFS_CLR_CNCL_I1' )
*     ( 'SFS_CNCL_I1' )
     ( 'REVERSE_GOODS_MOVEMENT' )
     ( 'INVOICE_CUSTOMER_INV_CREATE' )
     ( 'SNAPSHOT_NEG_TEST' )
     ( 'SFS_STD' )
     ( 'SFS_CANCEL_BD' )
     ( 'SFS_WITH_TEXT' )
*     ( 'SFS_SPLIT_DIFF_WE_COUNTRIES' )
     ( 'SDBIL_STD_CREATE_MESSAGES' )
     ( 'SD_BIL_HF14596' )
     ( 'SD_BIL_HF16793' )
     ( 'SNAPSHOT_CHECK' )
     ( 'SDBIL_SOAP_SIMULATE_PRICING' )
     ( 'CHECK_EDI_INVOICE_SPLIT_ARIBA' )
     ( 'BD_EVENT_CHANGED' )
     ( 'BD_EVENT_CANCELED' )
     ( 'BD_EVENT_CREATE' )
     ( 'SDBIL_BDCANC_KIDNO_BSEG' )
     ( 'SDBIL_BD_KIDNO_BSEG' )
*     ( 'SDBIL_1000011882' )
     ( 'SNAP_COMP_INV' )
     ( 'SD_BIL_HF8131' )
     ( 'SD_BIL_HF4500000036' )
     ( 'SDBIL_BD_DMR_SNAPSHOT_LOCK' )
*     ( 'SDBIL_TST_SC_CNV_DLV_DMR_BDR' )
*     ( 'BDR_CHECK_BD_SIMUL_WO_PPD' )
*     ( 'SDBIL_BD_CONSI_PROCESSES' )
     ( 'SDBIL_SOAP_CREATE_CDM_WITH_REF' )
     ( 'INVOICE_WITH_FIN_DOC' )
     ( 'CHECK_BD_FROM_DMR4' )
     ( 'CHECK_BD_FROM_OR' )
*     ( 'CHECK_BD_FROM_BDR' )   sComp customer S10100197
     ( 'BD_ATTACHMENT' )
*     ( 'CR_CMR' )
*     ( 'CR_CMR_REF_BD' )

    ) ).

  ENDMETHOD.


  METHOD XCALL_ONE_SCRIPT_WITH_FULL_LOG.

    IF sy-sysid NE 'C50'.
      RETURN.
    ENDIF.

    _call_named_scripts(
      it_varname      = VALUE #( ( 'SFS_STD' ) )
      iv_add_full_log = 'X'
    ).

  ENDMETHOD.
ENDCLASS.
