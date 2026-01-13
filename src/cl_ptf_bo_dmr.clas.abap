CLASS cl_ptf_bo_dmr DEFINITION
  PUBLIC
  INHERITING FROM cl_ptf_bo
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      ty_gt_order_partners TYPE STANDARD TABLE OF bapiparnr .
    TYPES:
      ty_gt_order_items    TYPE STANDARD TABLE OF bapisditm .
    TYPES:
      ty_gt_schedules      TYPE STANDARD TABLE OF bapischdl .
    TYPES:
      ty_bapisdtext TYPE STANDARD TABLE OF bapisdtext .
    TYPES:
      BEGIN OF ty_order_reason,
        order_reason TYPE augru,
      END OF ty_order_reason.
    TYPES:
** Structure for DMR create
      BEGIN OF ty_gs_i_ptf_dmr_cr_td,
        document_type        TYPE auart,
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
        cust_ref             TYPE bstkd,
        currency             TYPE waerk,
        item_list            TYPE cl_ptf_sd_util=>ty_gt_item_list_td,
        condition            TYPE cl_ptf_sd_util=>lty_sales_conditions_in,
        order_partners       TYPE cl_ptf_sd_util=>ty_order_partners,
        ext_fields_item      TYPE cl_ptf_sd_util=>ty_gt_ext_field_td, "for header and item
        sales_text           TYPE cl_ptf_sd_util=>ty_bapisdtext,
      END OF ty_gs_i_ptf_dmr_cr_td .
    TYPES:
** Structure for DMR create with reference
      BEGIN OF ty_gs_i_ptf_dmr_cr_with_ref_td,
        document_type TYPE auart,
      END OF ty_gs_i_ptf_dmr_cr_with_ref_td .
    TYPES:
** Structure for DMR change
      BEGIN OF ty_gs_i_ptf_dmr_ch_td,
        document_type        TYPE auart,
        sales_organization   TYPE vkorg,
        distribution_channel TYPE vtweg,
        division             TYPE spart,
        customer_id          TYPE kunnr,
        order_reason         TYPE augru,
        billing_block        TYPE faksk,
        item_list            TYPE cl_ptf_sd_util=>ty_gt_item_list_td,
      END OF ty_gs_i_ptf_dmr_ch_td .
    TYPES:
* Structure for DMR Add Billing Block
      BEGIN OF ty_gs_i_ptf_dmr_adbb_td,
        document_type        TYPE auart,
        sales_organization   TYPE vkorg,
        distribution_channel TYPE vtweg,
        division             TYPE spart,
        customer_id          TYPE kunnr,
        order_reason         TYPE augru,
        billing_block        TYPE faksk,
        item_list            TYPE cl_ptf_sd_util=>ty_gt_item_list_td,
      END OF ty_gs_i_ptf_dmr_adbb_td .
    TYPES:
* Structure for DMR Add Billing Block
      BEGIN OF ty_gs_i_ptf_dmr_rebb_td,
        document_type        TYPE auart,
        sales_organization   TYPE vkorg,
        distribution_channel TYPE vtweg,
        division             TYPE spart,
        customer_id          TYPE kunnr,
        order_reason         TYPE augru,
        billing_block        TYPE faksk,
        item_list            TYPE cl_ptf_sd_util=>ty_gt_item_list_td,
      END OF ty_gs_i_ptf_dmr_rebb_td .
    TYPES:
** Structure for DMR create from PS
      BEGIN OF ty_gs_i_ptf_dmr_cr_from_ps,
        sales_document TYPE vpkhead-vbeln,
        billing_date   LIKE sy-datum,
      END OF ty_gs_i_ptf_dmr_cr_from_ps .

    CLASS-METHODS keeping_lock_task
      IMPORTING
        !p_task TYPE char32 .

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

  PRIVATE SECTION.

    CONSTANTS c_add_billing_block TYPE string VALUE 'ADD_BILLING_BLOCK' ##NO_TEXT.
    CONSTANTS c_remove_billing_block TYPE string VALUE 'REMOVE_BILLING_BLOCK' ##NO_TEXT.
    CONSTANTS c_createfromproject TYPE string VALUE 'CREATEFROMPROJECT' ##NO_TEXT.
    CONSTANTS c_set_order_reason TYPE string value 'SET_ORDER_REASON'.

    CONSTANTS c_cfp TYPE string VALUE 'CFP'.

    CONSTANTS c_create_with_reference TYPE string VALUE 'CREATE_WITH_REFERENCE' ##NO_TEXT.
    CONSTANTS c_check_compare_dmr TYPE string VALUE 'CHECK_COMPARE_DMR' ##NO_TEXT.
    CONSTANTS c_create_from_ps TYPE string VALUE 'CREATE_FROM_PS' ##NO_TEXT.
    CONSTANTS c_action_unlock TYPE string VALUE 'UNLOCK' ##NO_TEXT.
    CONSTANTS c_action_lock TYPE string VALUE 'LOCK' ##NO_TEXT.
    CLASS-DATA mv_unlocked_async TYPE char1 .
    CLASS-DATA mv_locked_async TYPE char1 .

    METHODS cfp
      IMPORTING
        !step_data           TYPE cl_ptf_util=>gt_ptf_step                    "Parameter for better performance
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .
    METHODS set_order_reason
      IMPORTING
        !step_data           TYPE cl_ptf_util=>gt_ptf_step                    "Parameter for better performance
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .
    METHODS create_from_ps
      IMPORTING
        !step_data           TYPE cl_ptf_util=>gt_ptf_step
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .
    METHODS change_item_list
      IMPORTING
        !iv_order_number TYPE ptfkey
        !iv_chance_tdc   TYPE ty_gs_i_ptf_dmr_ch_td
      EXPORTING
        !ev_test_success TYPE abap_bool
        !ev_result       TYPE ty_gs_i_ptf_dmr_ch_td   ##NEEDED
        !et_return       TYPE cl_ptf_util=>gt_ptf_return_tab .
    METHODS create_with_reference
      IMPORTING
        !step_data           TYPE cl_ptf_util=>gt_ptf_step                    "Parameter for better performance
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .
    METHODS check_compare_dmr
      IMPORTING
        !step_data           TYPE cl_ptf_util=>gt_ptf_step                    "Parameter for better performance
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .
    METHODS prepare_testdata_create
      IMPORTING
        !ls_testdata        TYPE ty_gs_i_ptf_dmr_cr_td
      EXPORTING
        !ls_order_header_in TYPE bapisdhd1
        !lt_order_partners  TYPE ty_gt_order_partners
        !lt_order_items     TYPE ty_gt_order_items
        !lt_schedules       TYPE ty_gt_schedules
        !lt_condition       TYPE cl_ptf_sd_util=>lty_sales_conditions_in
        !lt_sales_text      TYPE ty_bapisdtext .
    METHODS add_billing_block
      IMPORTING
        !iv_order_number       TYPE ptfkey
        !iv_chance_tdc         TYPE ty_gs_i_ptf_dmr_ch_td
      RETURNING
        VALUE(ev_test_success) TYPE abap_bool .
    METHODS remove_billing_block
      IMPORTING
        !iv_order_number       TYPE ptfkey
      RETURNING
        VALUE(ev_test_success) TYPE abap_bool .
    METHODS createfromproject
      IMPORTING
        !step_data           TYPE cl_ptf_util=>gt_ptf_step                    "Parameter for better performance
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .
    METHODS unlock
      IMPORTING
        !is_d_step           TYPE cl_ptf_util=>gt_ptf_step
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .
    METHODS lock
      IMPORTING
        !is_d_step           TYPE cl_ptf_util=>gt_ptf_step
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .
ENDCLASS.



CLASS CL_PTF_BO_DMR IMPLEMENTATION.


  METHOD add_billing_block.

    DATA: ls_header_inx TYPE bapisdh1x,
          ls_header_in  TYPE bapisdh1,
          ls_return     TYPE bapiret2,
          lt_return     TYPE cl_ptf_util=>gt_ptf_return_tab.

    DATA: lv_vbeln TYPE vbeln.
    MOVE iv_order_number TO lv_vbeln.

    ev_test_success = abap_false.

    IF lv_vbeln IS INITIAL.
      me->mo_run_environment->append_log( |Initial VBELN was given.| ).
      RETURN.
    ENDIF.

    ls_header_inx-updateflag = 'U'.
    ls_header_inx-bill_block = 'X'.
    ls_header_in-bill_block  = iv_chance_tdc-billing_block.

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
    IF lv_billing_block <> space AND lv_billing_block EQ iv_chance_tdc-billing_block.
      ev_test_success = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD cfp.
    ASSERT 1 = 2.
** Create Project ***********************************************************************
*    DATA: ls_tdc_ci_scen TYPE cl_sdbil_testdata=>ty_gs_tdc_ci_scen,
*          ls_data_prj    TYPE cl_sdbil_testdata=>ty_gs_input_pbs_prj_so_bp_td,
*          lb_commit      TYPE abap_bool,
*          lb_testrun     TYPE abap_bool,
*          lv_sdate       TYPE sy-datum,
*          lv_edate       TYPE sy-datum,
*          ls_so_header   TYPE                     /cpd/s_ss_so_header_mig,  "not filled currently
*          lt_bill_plan   TYPE                     /cpd/t_ss_sd_bplan_itm_mig,
*          "ls_bill_plan  type /cpd/s_ss_sd_bplan_itm_mig,
*          lt_so_item     TYPE                     /cpd/t_ss_so_item_mig,
*          ls_so_item     TYPE /cpd/s_ss_so_item_mig,
*          lv_so_id       TYPE                     vbeln_va,
***Declarations for project
*          lv_mpid        TYPE  /cpd/mp_id,
*          ls_proj        TYPE                     /cpd/s_ss_engmnt_project_mig,
***Declaretion for work package
*          ls_wpa         TYPE                     /cpd/s_ss__workpackage_mig,
*          lt_wpa         TYPE STANDARD TABLE OF   /cpd/s_ss__workpackage_mig,
***Declaration for workitem
*          ls_witem       TYPE                     /cpd/s_ss_workitem_mig,
*          lt_witem       TYPE STANDARD TABLE OF   /cpd/s_ss_workitem_mig,
***Declaration for plandata
*          "ls_plan      TYPE                     /cpd/s_ss_plandata_mig,
*          lt_plan        TYPE STANDARD TABLE OF   /cpd/s_ss_plandata_mig,  "not filled currently
*          lt_fm_ret_msg  TYPE TABLE OF            bapiret2,
*          mo_data_access TYPE REF TO cl_sdbil_testdata,
*          variant        TYPE etvar_id.
*
*    CREATE OBJECT mo_data_access.
*
*    variant = step_data-variant.
*
*    "prepare data
*    mo_data_access->get_test_data(
*      EXPORTING
*        iv_tdc_variant = variant
*      IMPORTING
*        es_data        = ls_tdc_ci_scen ).
*
*    ls_data_prj = ls_tdc_ci_scen-input_pbs_prj_so.
*
*    lv_sdate = sy-datum.
*    lv_edate = lv_sdate + 10.
*
*    lv_mpid = 'SDBIL' && sy-datum+4 && 'U' && sy-uzeit.  " Note: >16 chars means dump   Characters in /cpd/cl_sc_cpm_constants=>gc_symbols are forbidden
*
*    "Ensure that project ID is free
*    DATA lv_projid TYPE /cpd/mp_id.
*    SELECT SINGLE pspid FROM proj INTO lv_projid WHERE pspid = lv_mpid.
*
*    "get an employment id
*    SELECT SINGLE i_employstatdet~employmentinternalid INTO @DATA(lv_pernr) FROM i_employstatdet
*             WHERE i_employstatdet~startdate <= @sy-datum AND
*                   i_employstatdet~enddate >= @sy-datum.
*
*** Fill project data - with tdc data and with dynamic values
*    ls_proj-mp_id                 =  lv_mpid.
*    ls_proj-customer              =  ls_data_prj-s_proj-cust_id.
*    ls_proj-mp_title              =  ls_data_prj-s_proj-mp_title.
*    ls_proj-proj_manager_id       =  lv_pernr.
*    "ls_proj-proj_controller_id    =  "can be filled with same employee as manager field
*    ls_proj-mpstage               =  /cpd/cl_sc_cpm_constants=>project_stages-in_execution.
*    ls_proj-start_date            =  lv_sdate.
*    ls_proj-end_date              =  lv_edate. .
*    ls_proj-currency              =  ls_data_prj-s_proj-cur.
*    ls_proj-org_id                =  ls_data_prj-s_proj-serv_org.
*    ls_proj-cost_center           =  ls_data_prj-s_proj-cost_center.
*    ls_proj-profit_center         =  ls_data_prj-s_proj-profit_center.
*
***Fill Work package - with tdc data and with dynamic values
*    LOOP AT ls_data_prj-t_wp INTO DATA(ls_wp).
*      ls_wpa-workpackagename         = ls_wp-wp_name.
*      ls_wpa-wpdescription           = ls_wp-wp_description.
*      ls_wpa-wpstartdate             = lv_sdate.
*      ls_wpa-wpenddate               = lv_edate.
*      ls_wpa-mp_id                   = lv_mpid. "master project id
*      ls_wpa-item_id                 = ls_wp-so_item_id.
*      APPEND ls_wpa TO lt_wpa.
*    ENDLOOP.
*
***Fill ORDER ITEM
*    lt_so_item = ls_data_prj-t_so_item.
*
***Fill BILLING PLAN - enrich tdc data with dynamic value (date)
*    lt_bill_plan = ls_data_prj-t_biplan_item.
*    LOOP AT lt_bill_plan REFERENCE INTO DATA(lr_bill_plan).
*      lr_bill_plan->billing_due_date = lv_sdate.
*      IF sy-tabix = 2.
*        lr_bill_plan->billing_due_date = lv_sdate + 2.  "hard coded deviation for 2nd billing plan item...
*      ENDIF.
*    ENDLOOP.
*
*    ls_proj-projecttype = /cpd/cl_sc_cpm_constants=>gc_customer_proj.
*    lb_commit = abap_true.
*    ls_proj-restrict_time_posting = 'N'.
*
*    CALL FUNCTION '/CPD/ENGMTPROJECT_MIGRATION'
*      EXPORTING
*        iv_commit      = lb_commit  "controls commit of project, not of sales order
*        iv_testrun     = lb_testrun
*        is_engmnt_proj = ls_proj
*        it_workpackage = lt_wpa
*        it_workitem    = lt_witem
*        it_plandata    = lt_plan
*        is_so_header   = ls_so_header
*        it_so_item     = lt_so_item
*        it_billingplan = lt_bill_plan
*      IMPORTING
*        ev_document_id = lv_so_id
*      TABLES
*        et_return      = lt_fm_ret_msg.
*
*    "BOPF transaction state is now = GC_STATE_DO_SAVE, but V60A expects a full cycle executed for the existing bopf objects when it starts
*    DATA: lo_trans_mgr TYPE REF TO /bobf/if_tra_slave_trans_mgr,
*          lr_message   TYPE REF TO /bobf/if_frw_message.
*
*    lo_trans_mgr = /bobf/cl_tra_trans_mgr_factory=>get_slave_transaction_manager( ).
*    lo_trans_mgr->after_successful_save( IMPORTING eo_message = lr_message ). " switches to GC_STATE_AFTER_SUCCESSFUL_SAVE and then to GC_STATE_INTERACTION
*    lo_trans_mgr->do_cleanup( iv_execute_rollback_work = abap_false ). "allowed only from GC_STATE_INTERACTION
*
** Create DMR ***********************************************************************
*
*    DATA: ls_data_tdc TYPE cl_sdbil_testdata=>ty_gs_input_pbs_dyn_item_td. "ty_gs_input_pbs_prj_so_bp_td.
*
*    CLEAR   ls_tdc_ci_scen.
*
*    "FM input data
*    DATA:
*      lv_existing_dmr          TYPE vbeln,
*      ls_sdsm_main_item        TYPE sdsm_main_item,
*      lb_simulation            TYPE char1,
*      lb_xkonv_determine       TYPE  boole_d VALUE abap_true,
*      lb_no_dialog             TYPE char1,
*      lb_no_save_on_incomplete TYPE xfeld,
*      ls_i_sdsm_header         TYPE sdsm_header.
*
*    "FM return data
*    DATA:
*      lv_e_dmr            TYPE vbeln,
*      ls_e_sdsm_main_item TYPE sdsm_main_item,
*      ls_e_komk           TYPE komk.
*
*    "FM TABLES
*    DATA:
*      fvbpakom        TYPE STANDARD TABLE OF vbpakom,
*      ls_fsdsm_dli    TYPE sdsm_dli,
*      lt_fsdsm_dli    TYPE STANDARD TABLE OF sdsm_dli,
*      fxkonv          TYPE STANDARD TABLE OF  konv,
*      fkomk           TYPE STANDARD TABLE OF  komk,
*      fkomp           TYPE STANDARD TABLE OF  komp,
*      fsdsm_main_item TYPE STANDARD TABLE OF sdsm_main_item,
*      fsales_text     TYPE STANDARD TABLE OF bapisdtext.
*
*    DATA: lv_fbuda TYPE datum,
*          ls_prps  TYPE prps,
*          lt_prps  TYPE STANDARD TABLE OF prps.
*    DATA wp_cnt TYPE i.
*    DATA: lv_order_id TYPE vbeln.
*    lv_order_id = lv_so_id.
*
*    DATA: lv_so_item1 TYPE posnr VALUE '000010',
*          lv_so_item2 TYPE posnr VALUE '000020',
*          lv_so_item3 TYPE posnr VALUE '000030'.
*
*    DATA: ls_vbkd TYPE vbkd.
*
*    "prepare data
*
*    mo_data_access->get_test_data(
*      EXPORTING
*        iv_tdc_variant = variant
*      IMPORTING
*        es_data        = ls_tdc_ci_scen ).
*
*    ls_data_tdc = ls_tdc_ci_scen-input_pbs_dmr.
*
*    lv_fbuda = sy-datum.
*
*** Fill Header structure
*    ls_i_sdsm_header-auart = ls_data_tdc-s_header-auart. " 'DMR1'.
*    ls_i_sdsm_header-ad01basdoc = lv_order_id.
*
*** Fill item table
**   fields I do not change between the ls_fsdsm_dli records
*    ASSERT ls_data_tdc-t_dyn_item IS NOT INITIAL.
*
**   fill line specific fields and append them to the itab
*    DATA lv_proj_pspnrb TYPE ps_intnr.
*    SELECT SINGLE pspnr FROM proj INTO lv_proj_pspnrb WHERE pspid = ls_proj-mp_id.
*    SELECT * FROM prps INTO TABLE lt_prps WHERE psphi = lv_proj_pspnrb.
*    ASSERT lt_prps IS NOT INITIAL.
*
*    SORT lt_prps BY posid.
*    LOOP AT lt_prps INTO ls_prps WHERE stufe EQ 2." AND          "ignore stufe 3
*      "posid NE IV_PROJ_ID. "ignore overview task
*      CLEAR: ls_vbkd.
*      IF ls_prps-abgsl EQ 'SPTM'.
*        " Time and Expenses
*        READ TABLE ls_data_tdc-t_dyn_item WITH KEY sd_matnr = 'T001' INTO ls_fsdsm_dli.
*      ELSE.
*        " Fix Price
*        READ TABLE ls_data_tdc-t_dyn_item WITH KEY sd_matnr = 'P001' INTO ls_fsdsm_dli.
*      ENDIF.
*      ASSERT sy-subrc = 0.
*      ls_fsdsm_dli-prsdt = lv_fbuda. "sdate.
*      ls_fsdsm_dli-poper = sy-datum(4) && '0' && sy-datum+4(2).  " e.g. '2016006'. "Posting period   numc(7)
*      ls_fsdsm_dli-fbuda = lv_fbuda.
*
*      ls_fsdsm_dli-objnr = ls_prps-objnr.            "c22
*      ls_fsdsm_dli-wbs_workpackage = ls_prps-pspnr.  "numc 8
*      ls_fsdsm_dli-fpltr = '000001'.                 "Item for billing plan/invoice plan/payment cards
*      ls_fsdsm_dli-dpbp_ref_fpltr = '000001'.
*
*      ADD 1 TO wp_cnt.
*      IF wp_cnt EQ 1.
****item 1
*
*        ls_fsdsm_dli-posnr_v = lv_so_item1.            "item number of the SO01 order
*        ls_fsdsm_dli-kbetr1 = 75 .                     "AN AMOUNT
*
*        SELECT SINGLE * FROM vbkd INTO ls_vbkd WHERE vbeln = lv_order_id AND posnr = lv_so_item1.
*        ASSERT sy-subrc IS INITIAL.
*
*        ls_fsdsm_dli-fplnr = ls_vbkd-fplnr.
*        ls_fsdsm_dli-dpbp_ref_fplnr = ls_vbkd-fplnr.
*
*      ELSEIF wp_cnt EQ 2.
****item2
*        ls_fsdsm_dli-posnr_v = lv_so_item2. "item number of the SO01 order
*        ls_fsdsm_dli-kbetr1 = 150 .   "AN AMOUNT
*
*        CLEAR: ls_vbkd.
*        SELECT SINGLE * FROM vbkd INTO ls_vbkd WHERE vbeln = lv_order_id AND posnr = lv_so_item2.
*        ASSERT sy-subrc IS INITIAL.
*
*        ls_fsdsm_dli-fplnr = ls_vbkd-fplnr.
*        ls_fsdsm_dli-dpbp_ref_fplnr = ls_vbkd-fplnr.
*
*      ELSEIF wp_cnt EQ 3.
****item2
*        ls_fsdsm_dli-posnr_v = lv_so_item3. "item number of the SO01 order
*        ls_fsdsm_dli-kbetr1 = 111 .   "AN AMOUNT
*
*        SELECT SINGLE * FROM vbkd INTO ls_vbkd WHERE vbeln = lv_order_id AND posnr = lv_so_item2.
*        ASSERT sy-subrc IS INITIAL.
*
*        ls_fsdsm_dli-fplnr = ls_vbkd-fplnr.
*        ls_fsdsm_dli-dpbp_ref_fplnr = ls_vbkd-fplnr.
*
*      ELSE.
*        CONTINUE.
*      ENDIF.
*
*      APPEND ls_fsdsm_dli TO lt_fsdsm_dli.
*
*    ENDLOOP.
*
*    CALL FUNCTION 'SD_SALES_DOCUMENT_FROM_SM'
*      EXPORTING
*        i_vbeln_v                      = lv_order_id "sales order ID
*        i_vbeln                        = lv_existing_dmr "initial   "if existing DMR document is to be enhanced - optional
*        i_sdsm_header                  = ls_i_sdsm_header
*        i_sdsm_main_item               = ls_sdsm_main_item  "initial
*        i_simulation                   = lb_simulation      "initial
*        i_xkonv_determine              = lb_xkonv_determine  "X
*        i_no_dialog                    = lb_no_dialog       "initial
*        i_no_save_on_incomplete        = lb_no_save_on_incomplete "initial
*      IMPORTING
*        e_vbeln                        = lv_e_dmr
*        e_sdsm_main_item               = ls_e_sdsm_main_item
*        e_komk                         = ls_e_komk
*      TABLES
*        fvbpakom                       = fvbpakom
*        fsdsm_dli                      = lt_fsdsm_dli "with input
*        fxkonv                         = fxkonv
*        fkomk                          = fkomk
*        fkomp                          = fkomp
*        fsdsm_main_item                = fsdsm_main_item
*        fsales_text                    = fsales_text
*      EXCEPTIONS
*        inconsistent_import_parameters = 1
*        error_occurred                 = 2
*        OTHERS                         = 3.
*
*    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
*
*    DATA: lv_ptf_key TYPE ptfkey.
*    MOVE lv_e_dmr TO lv_ptf_key.
*
*    ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).
*
*    IF ev_execution_status EQ abap_true.
*      APPEND lv_ptf_key TO ev_document_id.
*    ENDIF.
  ENDMETHOD.


  METHOD change.
    DATA: ls_chance_tdc TYPE ty_gs_i_ptf_dmr_ch_td,
          bool_rembb    TYPE abap_bool,
          lt_return     TYPE cl_ptf_util=>gt_ptf_return_tab,
          lv_ptf_tdc    TYPE etobj_name,
          ls_return     TYPE bapiret2,
*          lt_vbeln      TYPE TABLE OF vbeln,
          lt_vbeln_in   TYPE cl_ptf_util=>ty_vbeln_tab.

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
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln_in.
    ENDLOOP.

    LOOP AT lt_vbeln_in ASSIGNING FIELD-SYMBOL(<vbeln>).
*****************************************************************************
* Check if the billing block has to removed.

      IF ls_chance_tdc-billing_block = '00'.
        me->remove_billing_block( iv_order_number = <vbeln>-vbeln ).

        ev_execution_status = abap_false.
        cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

      ELSEIF ls_chance_tdc-billing_block IS NOT INITIAL.
        me->add_billing_block(
          EXPORTING
            iv_order_number = <vbeln>-vbeln
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
        DATA lv_ptf_key TYPE ptfkey.
        MOVE <vbeln>-vbeln TO lv_ptf_key.

        change_item_list(
          EXPORTING
            iv_order_number = lv_ptf_key
            iv_chance_tdc   = ls_chance_tdc
          IMPORTING
            ev_test_success = bool_rembb
            et_return       = lt_return ).
        cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
        ev_execution_status = bool_rembb.
      ENDIF.

    ENDLOOP.
*****************************************************************************
    CLEAR ev_document_id.
    MOVE lt_vbeln_in TO ev_document_id.

  ENDMETHOD.


  METHOD change_item_list.

    DATA: ls_order_item_inx TYPE bapisditmx,
          lt_order_item_inx TYPE TABLE OF bapisditmx,
          ls_header_inx     TYPE bapisdh1x,
          ls_header_in      TYPE bapisdh1,
          ls_order_items    TYPE bapisditm,
          lt_order_items    TYPE TABLE OF bapisditm.

    CLEAR et_return.
    CLEAR ev_test_success.
    "ev_result seems obsolete

    CLEAR lt_order_items.
    ls_header_inx-updateflag  = 'U'.

* Check where the changes have to be made.
    LOOP AT iv_chance_tdc-item_list ASSIGNING FIELD-SYMBOL(<ls_item_list>).
      IF <ls_item_list>-posnr IS NOT INITIAL.
        ls_order_items-itm_number = <ls_item_list>-posnr.
      ENDIF.

      IF <ls_item_list>-material_id IS NOT INITIAL.
        ls_order_items-material = <ls_item_list>-material_id.
        ls_order_item_inx-material = 'X'.
        ls_order_item_inx-updateflag = 'U'.
      ENDIF.

      IF <ls_item_list>-quantity IS NOT INITIAL.
        ls_order_items-target_qty = <ls_item_list>-quantity.
        ls_order_item_inx-target_qty = 'X'.
        ls_order_item_inx-updateflag = 'U'.
      ENDIF.

      APPEND ls_order_items TO lt_order_items.
      APPEND ls_order_item_inx TO lt_order_item_inx.

    ENDLOOP.

*    IF sy-subrc = 0.
*      ls_order_item_inx-material = 'X'.   "Updateflag
*      ls_order_item_inx-updateflag = 'U'.
*    ENDIF.
*    APPEND ls_order_item_inx TO lt_order_item_inx.

* execute the chnages
    DATA lv_vbeln TYPE vbeln.
    MOVE iv_order_number TO lv_vbeln.

    CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
      EXPORTING
        salesdocument    = lv_vbeln   " Order Number
        order_header_in  = ls_header_in
        order_header_inx = ls_header_inx  " Sales Order Check List
      TABLES
        return           = et_return " Return Code
        order_item_in    = lt_order_items  " Order Items
        order_item_inx   = lt_order_item_inx.  " Sales Order Items Check Table

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
    IF et_return IS INITIAL.
      ev_test_success = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD check.
    DATA: ls_testdata        TYPE cl_ptf_bo_or=>ty_gs_ptf_sd_check_td,
          lv_prestepnumber   TYPE LINE OF cl_ptf_util=>gt_ptf_step-reference_step,
          ls_check_step_data TYPE cl_ptf_util=>gt_ptf_step,
          lv_vbeln           TYPE vbeln,
          error_message      TYPE bapi_msg,
          ls_return          TYPE bapiret2,
          lv_step_success    TYPE abap_bool,
          var_step           TYPE string.

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

    lv_step_success  = abap_true.
    CLEAR: lv_prestepnumber, ls_check_step_data.
    IF ls_testdata-vbak_check IS NOT INITIAL OR ls_testdata-vbap_check IS NOT INITIAL.
*  Check if reference step number for checking object is filled and reference object exists
      LOOP AT ls_step_data-reference_step INTO lv_prestepnumber.
        DATA(lt_ref_doc_id) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = lv_prestepnumber ).

        IF lt_ref_doc_id  IS INITIAL.
          lv_step_success  = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |No reference document exists!| ).
        ELSE.
          IF ls_testdata-vbak_check IS NOT INITIAL.
            cl_ptf_compare_sd_tdc=>compare_vbak_data(
              EXPORTING
                is_testdata        = ls_testdata
                is_check_step_data = ls_check_step_data
                iv_run_environment = me->mo_run_environment
              RECEIVING
                rv_is_equal        = ev_check_status
            ).
            IF ev_check_status EQ abap_false.
              lv_step_success = abap_false.
            ENDIF.
          ENDIF.
          IF ls_testdata-vbap_check IS NOT INITIAL.
            cl_ptf_compare_sd_tdc=>compare_vbap_data(
              EXPORTING
                is_testdata        = ls_testdata
                is_check_step_data = ls_check_step_data
                iv_run_environment = me->mo_run_environment
              RECEIVING
                rv_is_equal        = ev_check_status
            ).
            IF ev_check_status EQ abap_false.
              lv_step_success = abap_false.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
    ev_check_status  = lv_step_success. "If Header fails and Item success --> Check needs to be abap_false
** Output in case of success
    IF ev_check_status  EQ abap_true.
      ev_execution_status = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |The values of the checked document are correct. Process step is: { ls_step_data-step_number } | ).
    ELSE.
      ev_execution_status = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |The values of the checked document are not correct. Process step is: { ls_step_data-step_number } | ).
    ENDIF.

  ENDMETHOD.


  METHOD check_compare_dmr.
    TYPES:
      BEGIN OF ty_vbeln,
        vbeln TYPE ptfkey,
      END OF ty_vbeln.

    DATA: lt_vbeln      TYPE TABLE OF ty_vbeln,
          ls_vbeln      TYPE ty_vbeln,
          lv_success    TYPE abap_bool,
          lt_vbak       TYPE TABLE OF vbak,
          lt_vbap_1     TYPE TABLE OF vbap,
          lt_vbap_2     TYPE TABLE OF vbap,
          ls_vbap_1     TYPE vbap,
          ls_vbap_2     TYPE vbap,
          lv_length     TYPE i,
          lt_fieldinfo  TYPE extdfiest,
          ls_fieldinfo  TYPE LINE OF extdfiest,
          msg_str1      TYPE string,
          msg_str2      TYPE string,
          lv_loop_count TYPE i.

    FIELD-SYMBOLS: <lv_vbak_1>    TYPE any,
                   <lv_vbak_2>    TYPE any,
                   <lv_fieldinfo> TYPE any,
                   <lv_vbap_1>    TYPE any,
                   <lv_vbap_2>    TYPE any.
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
      me->mo_run_environment->append_log( iv_log_statement =  |This test is only allowed with 2 docuemnts.| ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.
*****************************************************************************
* 2 VBAK
    " Create valid OpenSQL type
    TYPES:
      BEGIN OF ty_vbeln_orig,
        vbeln TYPE vbeln,
      END OF ty_vbeln_orig.
    DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.
    MOVE lt_vbeln TO lt_vbeln_key.
    SELECT * FROM vbak INTO TABLE lt_vbak FOR ALL ENTRIES IN lt_vbeln_key WHERE vbeln = lt_vbeln_key-vbeln.
    DESCRIBE TABLE lt_vbeln LINES lv_length.
    IF lv_length NE 2.
      me->mo_run_environment->append_log( iv_log_statement =  |Documents not found at DB.| ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.
*****************************************************************************
* 3 get fieldinfo
    CLEAR lt_fieldinfo.
    CALL FUNCTION 'DD_INT_TABLINFO_GET'
      EXPORTING
        typename       = 'VBAK'
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
    READ TABLE lt_vbak INTO DATA(ls_vbak_1) INDEX 1.
    READ TABLE lt_vbak INTO DATA(ls_vbak_2) INDEX lv_length.
    LOOP AT lt_fieldinfo INTO ls_fieldinfo.
      IF ls_fieldinfo-fieldname NE 'VBELN' AND ls_fieldinfo-fieldname NE 'KNUMV' AND
         ls_fieldinfo-fieldname NE 'ERZET' AND ls_fieldinfo-fieldname NE 'HANDLE' AND
         ls_fieldinfo-fieldname NE 'UPD_TMSTMP' AND ls_fieldinfo-fieldname NE 'CM_LAST_CHECK'.
        ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbak_1 TO <lv_vbak_1>.
        ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbak_2 TO <lv_vbak_2>.
        IF  <lv_vbak_1> NE  <lv_vbak_2>.
          lv_success = abap_false.
          msg_str1 = <lv_vbak_1>.
          msg_str2 = <lv_vbak_2>.
          me->mo_run_environment->append_log( iv_log_statement =  |The Value of the VBAK field { ls_fieldinfo-fieldname } is not as expected. The expected value is: { msg_str1 }. The stored value is: { msg_str2 }.| ).
        ENDIF.
      ENDIF.
    ENDLOOP.
*****************************************************************************
* 5 Step: VBAP
    CLEAR ls_vbeln.
    READ TABLE lt_vbeln INTO ls_vbeln INDEX 1.
    SELECT * FROM vbap INTO TABLE lt_vbap_1 WHERE vbeln = ls_vbeln-vbeln ORDER BY PRIMARY KEY.
    CLEAR ls_vbeln.
    READ TABLE lt_vbeln INTO ls_vbeln INDEX 2.
    SELECT * FROM vbap INTO TABLE lt_vbap_2 WHERE vbeln = ls_vbeln-vbeln ORDER BY PRIMARY KEY.
    DESCRIBE TABLE lt_vbap_1 LINES DATA(lv_vbap_l1).
    DESCRIBE TABLE lt_vbap_2 LINES DATA(lv_vbap_l2).
    IF lv_vbap_l1 NE lv_vbap_l2.
      me->mo_run_environment->append_log( iv_log_statement =  |Quantity of Item are not equal.| ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.
*****************************************************************************
* 6 get fieldinfo
    CLEAR lt_fieldinfo.
    CALL FUNCTION 'DD_INT_TABLINFO_GET'
      EXPORTING
        typename       = 'VBAP'
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
    LOOP AT lt_vbap_1 INTO ls_vbap_1.
      lv_loop_count = lv_loop_count + 1.
      READ TABLE lt_vbap_2 INTO ls_vbap_2 INDEX lv_loop_count.
      LOOP AT lt_fieldinfo INTO ls_fieldinfo.
        IF ls_fieldinfo-fieldname NE 'VBELN' AND ls_fieldinfo-fieldname NE 'PAOBJNR' AND
           ls_fieldinfo-fieldname NE 'ERNAM' AND ls_fieldinfo-fieldname NE 'HANDLE' AND
          ls_fieldinfo-fieldname NE 'CPD_UPDAT' AND ls_fieldinfo-fieldname NE 'ERZET' AND
          ls_fieldinfo-fieldname NE  'SESSION_CREATION_TIME' AND NOT matches( val = ls_fieldinfo-fieldname regex = |.*_ANA| ).
          ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbap_1 TO <lv_vbap_1>.
          ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbap_2 TO <lv_vbap_2>.
          IF <lv_vbap_1> NE  <lv_vbap_2>.
            lv_success  = abap_false.
            msg_str1 = <lv_vbap_1>.
            msg_str2 = <lv_vbap_2>.
            me->mo_run_environment->append_log( iv_log_statement = |The Value of the VBAP field { ls_fieldinfo-fieldname } is not as expected. The expected value is: { msg_str1 }. The stored value is: { msg_str2 }.| ).
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
*****************************************************************************
    ev_execution_status = abap_true.
    ev_check_status = lv_success.
    IF lv_success EQ abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |Check was succesful. Both document are similar.| ).
    ENDIF.
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


  METHOD create.

    DATA: ls_testdata            TYPE ty_gs_i_ptf_dmr_cr_td,
          ls_order_header_in     TYPE bapisdhd1,
          lt_order_partners      TYPE TABLE OF bapiparnr,
          lt_order_items         TYPE TABLE OF bapisditm,
          lt_schedules           TYPE TABLE OF bapischdl,
*          ls_return              TYPE bapiret2,
          lt_return              TYPE TABLE OF bapiret2,
          lv_vbeln               TYPE vbeln,
          lt_sales_conditions_in TYPE TABLE OF bapicond.

    DATA: ls_order_header_in_x           TYPE bapisdhd1x,
          lt_extensionex                 TYPE TABLE OF bapiparex,
          ls_extensibility_fields_header TYPE REF TO bape_sdsalesdoc,
          lt_order_items_x               TYPE TABLE OF bapisditmx,
          ls_order_item_x                TYPE bapisditmx,
          lo_bapi_mapping                TYPE REF TO if_cfd_bapi_mapping,
          lt_extensibility_fields_item   TYPE TABLE OF bape_sdsalesdocitem,
          ls_extensibility_fields_item   TYPE bape_sdsalesdocitem,
          lt_bapiparex                   TYPE bapiparextab,
          lv_extensibility_error         TYPE abap_bool,
*          ls_i_salesitemproposalitemtp   TYPE i_salesitemproposalitemtp,
*          ls_prpsl_item                  TYPE bapisditm,
*          lv_next_itm_number             TYPE i,
          ls_ext_field                   TYPE string,
          ls_tvak                        TYPE tvak,
          lv_key                         TYPE i,
          lv_key_as_string               TYPE string,
          lv_key_add                     TYPE i,
*          lr_header_bapi_ext             TYPE REF TO bape_sdsalesdoc,
*          lr_item_bapi_ext               TYPE REF TO bape_sdsalesdoc,
          lt_sales_text                  TYPE TABLE OF bapisdtext.

    FIELD-SYMBOLS: <gfs_field>          TYPE any,
                   <ex_field_structure> TYPE any.  "used for a field in the structure

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
* 2 Step: check wether the Item-number if filled;

    cl_ptf_util=>ensure_posnr_filled(
      EXPORTING
        iv_variant         = ls_step_data-variant
        iv_run_environment = me->mo_run_environment
      CHANGING
        is_data            = ls_testdata
    ).

*****************************************************************************
* 3 Step: Prepare Testdata for 'SD_SALESDOCUMENT_CREATE'
    me->prepare_testdata_create(
      EXPORTING
        ls_testdata        = ls_testdata
      IMPORTING
        ls_order_header_in = ls_order_header_in
        lt_order_partners  = lt_order_partners
        lt_order_items     = lt_order_items
        lt_schedules       = lt_schedules
        lt_condition       = lt_sales_conditions_in
        lt_sales_text      = lt_sales_text  ).

    "ls_order_header_in_x-updateflag  = 'I'.
    ls_order_header_in_x-doc_type    = 'X'.
    ls_order_header_in_x-sales_org   = 'X'.
    ls_order_header_in_x-distr_chan  = 'X'.
    ls_order_header_in_x-division    = 'X'.
    ls_order_header_in_x-pp_search   = 'X'.
    ls_order_header_in_x-ct_valid_f  = 'X'.
    ls_order_header_in_x-ct_valid_t  = 'X'.
    IF ls_order_header_in-currency IS NOT INITIAL.
      ls_order_header_in_x-currency = abap_true.
    ENDIF.
    IF ls_order_header_in-purch_no_c IS NOT INITIAL.
      ls_order_header_in_x-purch_no_c  = 'X'.
    ENDIF.

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
      APPEND ls_order_item_x TO lt_order_items_x.

      CLEAR ls_extensibility_fields_item.
      lv_key_as_string = lv_key.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_key_as_string
        IMPORTING
          output = ls_extensibility_fields_item-key.
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
             ct_bapiparex = lt_bapiparex ).
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

*   map the Extensibility fields into a suitable EXTENSIONIN format
    lo_bapi_mapping = cl_cfd_bapi_mapping=>get_instance( ).
    TRY.
        lo_bapi_mapping->map_to_bapiparex_single(
           EXPORTING
             ir_source_structure = ls_extensibility_fields_header
             CHANGING
               ct_bapiparex = lt_bapiparex ).
      CATCH cx_root.
    ENDTRY.

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
        sales_conditions_in = lt_sales_conditions_in
        sales_text          = lt_sales_text.

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
*****************************************************************************
* 6 Step: Check Billing Block and Remove it if set
    IF ls_vbak-faksk NE space.
      IF ls_testdata-billing_block IS NOT INITIAL.
        MOVE lv_vbeln TO lv_ptf_key.
        me->remove_billing_block( iv_order_number = lv_ptf_key ). "this removes only a header block. (Item block to be added)
      ENDIF.
    ENDIF.
*****************************************************************************
    APPEND lv_ptf_key TO ev_document_id.
*****************************************************************************
    "Log customer used
    me->mo_run_environment->append_log( iv_log_statement = |Sold-To is: { ls_vbak-kunnr }| ).
*****************************************************************************
    "Log warning if blocked by credit check
    IF ls_vbak-cmgst EQ 'B' OR ls_vbak-cmgst EQ 'C'.
      me->mo_run_environment->append_log( iv_log_statement = |VBAK-CMGST: Credit check was started, it failed or set a block. Customer is { ls_vbak-kunnr }| ).
    ENDIF.

  ENDMETHOD.


  METHOD createfromproject.
    ASSERT 1 = 2.
** Create Project ***********************************************************************
*    DATA: ls_tdc_ci_scen TYPE cl_sdbil_testdata=>ty_gs_tdc_ci_scen,
*          ls_data_prj    TYPE cl_sdbil_testdata=>ty_gs_input_pbs_prj_so_bp_td,
*          lb_commit      TYPE abap_bool,
*          lb_testrun     TYPE abap_bool,
*          lv_sdate       TYPE sy-datum,
*          lv_edate       TYPE sy-datum,
*          ls_so_header   TYPE                     /cpd/s_ss_so_header_mig,  "not filled currently
*          lt_bill_plan   TYPE                     /cpd/t_ss_sd_bplan_itm_mig,
*          "ls_bill_plan  type /cpd/s_ss_sd_bplan_itm_mig,
*          lt_so_item     TYPE                     /cpd/t_ss_so_item_mig,
*          ls_so_item     TYPE /cpd/s_ss_so_item_mig,
*          lv_so_id       TYPE                     vbeln_va,
***Declarations for project
*          lv_mpid        TYPE  /cpd/mp_id,
*          ls_proj        TYPE                     /cpd/s_ss_engmnt_project_mig,
***Declaretion for work package
*          ls_wpa         TYPE                     /cpd/s_ss__workpackage_mig,
*          lt_wpa         TYPE STANDARD TABLE OF   /cpd/s_ss__workpackage_mig,
***Declaration for workitem
*          ls_witem       TYPE                     /cpd/s_ss_workitem_mig,
*          lt_witem       TYPE STANDARD TABLE OF   /cpd/s_ss_workitem_mig,
***Declaration for plandata
*          "ls_plan      TYPE                     /cpd/s_ss_plandata_mig,
*          lt_plan        TYPE STANDARD TABLE OF   /cpd/s_ss_plandata_mig,  "not filled currently
*          lt_fm_ret_msg  TYPE TABLE OF            bapiret2,
*          mo_data_access TYPE REF TO cl_sdbil_testdata.
*
*    CREATE OBJECT mo_data_access.
*
*    "prepare data
*    mo_data_access->get_test_data(
*      EXPORTING
*        iv_tdc_variant = 'PS_OUTPUT_TEST'
*      IMPORTING
*        es_data        = ls_tdc_ci_scen ).
*
*    ls_data_prj = ls_tdc_ci_scen-input_pbs_prj_so.
*
*    lv_sdate = sy-datum.
*    lv_edate = lv_sdate + 10.
*
*    lv_mpid = 'SDBIL' && sy-datum+4 && 'U' && sy-uzeit.  " Note: >16 chars means dump   Characters in /cpd/cl_sc_cpm_constants=>gc_symbols are forbidden
*
*    "Ensure that project ID is free
*    DATA lv_projid TYPE /cpd/mp_id.
*    SELECT SINGLE pspid FROM proj INTO lv_projid WHERE pspid = lv_mpid.
*
*    "get an employment id
*    SELECT SINGLE i_employstatdet~employmentinternalid
*      INTO @DATA(lv_pernr)
*      FROM
*        I_EmployStatDet
*      LEFT OUTER JOIN i_persnwrkagreementdet
*        ON i_employstatdet~employmentinternalid = i_persnwrkagreementdet~personworkagreement
*      WHERE i_employstatdet~startdate <= @sy-datum AND i_employstatdet~enddate >= @sy-datum
*        AND i_persnwrkagreementdet~person NE ''.
*
*
**    SELECT SINGLE i_employstatdet~employmentinternalid INTO @DATA(lv_pernr) FROM i_employstatdet
**             WHERE i_employstatdet~startdate <= @sy-datum AND
**                   i_employstatdet~enddate >= @sy-datum.
*
*** Fill project data - with tdc data and with dynamic values
*    ls_proj-mp_id                 =  lv_mpid.
*    ls_proj-customer              =  ls_data_prj-s_proj-cust_id.
*    ls_proj-mp_title              =  ls_data_prj-s_proj-mp_title.
*    ls_proj-proj_manager_id       =  lv_pernr.
*    "ls_proj-proj_controller_id    =  "can be filled with same employee as manager field
*    ls_proj-mpstage               =  /cpd/cl_sc_cpm_constants=>gc_stage_exec.
*    ls_proj-start_date            =  lv_sdate.
*    ls_proj-end_date              =  lv_edate. .
*    ls_proj-currency              =  ls_data_prj-s_proj-cur.
*    ls_proj-org_id                =  ls_data_prj-s_proj-serv_org.
*    ls_proj-cost_center           =  ls_data_prj-s_proj-cost_center.
*    ls_proj-profit_center         =  ls_data_prj-s_proj-profit_center.
*    ls_proj-confidential          = 'N'.
*
***Fill Work package - with tdc data and with dynamic values
*    LOOP AT ls_data_prj-t_wp INTO DATA(ls_wp).
*      ls_wpa-workpackagename         = ls_wp-wp_name.
*      ls_wpa-wpdescription           = ls_wp-wp_description.
*      ls_wpa-wpstartdate             = lv_sdate.
*      ls_wpa-wpenddate               = lv_edate.
*      ls_wpa-mp_id                   = lv_mpid. "master project id
*      ls_wpa-item_id                 = ls_wp-so_item_id.
*      APPEND ls_wpa TO lt_wpa.
*    ENDLOOP.
*
***Fill ORDER ITEM
*    lt_so_item = ls_data_prj-t_so_item.
*
***Fill BILLING PLAN - enrich tdc data with dynamic value (date)
*    lt_bill_plan = ls_data_prj-t_biplan_item.
*    LOOP AT lt_bill_plan REFERENCE INTO DATA(lr_bill_plan).
*      lr_bill_plan->billing_due_date = lv_sdate.
*      IF sy-tabix = 2.
*        lr_bill_plan->billing_due_date = lv_sdate + 2.  "hard coded deviation for 2nd billing plan item...
*      ENDIF.
*    ENDLOOP.
*
*    ls_proj-projecttype = /cpd/cl_sc_cpm_constants=>gc_customer_proj.
*    lb_commit = abap_true.
*    ls_proj-restrict_time_posting = 'N'.
*
*    CALL FUNCTION '/CPD/ENGMTPROJECT_MIGRATION'
*      EXPORTING
*        iv_commit      = lb_commit  "controls commit of project, not of sales order
*        iv_testrun     = lb_testrun
*        is_engmnt_proj = ls_proj
*        it_workpackage = lt_wpa
*        it_workitem    = lt_witem
*        it_plandata    = lt_plan
*        is_so_header   = ls_so_header
*        it_so_item     = lt_so_item
*        it_billingplan = lt_bill_plan
*      IMPORTING
*        ev_document_id = lv_so_id
*      TABLES
*        et_return      = lt_fm_ret_msg.
*
*    "BOPF transaction state is now = GC_STATE_DO_SAVE, but V60A expects a full cycle executed for the existing bopf objects when it starts
*    DATA: lo_trans_mgr TYPE REF TO /bobf/if_tra_slave_trans_mgr,
*          lr_message   TYPE REF TO /bobf/if_frw_message.
*
*    lo_trans_mgr = /bobf/cl_tra_trans_mgr_factory=>get_slave_transaction_manager( ).
*    lo_trans_mgr->after_successful_save( IMPORTING eo_message = lr_message ). " switches to GC_STATE_AFTER_SUCCESSFUL_SAVE and then to GC_STATE_INTERACTION
*    lo_trans_mgr->do_cleanup( iv_execute_rollback_work = abap_false ). "allowed only from GC_STATE_INTERACTION
*
** Create DMR ***********************************************************************
*
*    DATA: ls_data_tdc TYPE cl_sdbil_testdata=>ty_gs_input_pbs_dyn_item_td. "ty_gs_input_pbs_prj_so_bp_td.
*
*    CLEAR   ls_tdc_ci_scen.
*
*    "FM input data
*    DATA:
*      lv_existing_dmr          TYPE vbeln,
*      ls_sdsm_main_item        TYPE sdsm_main_item,
*      lb_simulation            TYPE char1,
*      lb_xkonv_determine       TYPE  boole_d VALUE abap_true,
*      lb_no_dialog             TYPE char1,
*      lb_no_save_on_incomplete TYPE xfeld,
*      ls_i_sdsm_header         TYPE sdsm_header.
*
*    "FM return data
*    DATA:
*      lv_e_dmr            TYPE vbeln,
*      ls_e_sdsm_main_item TYPE sdsm_main_item,
*      ls_e_komk           TYPE komk.
*
*    "FM TABLES
*    DATA:
*      fvbpakom        TYPE STANDARD TABLE OF vbpakom,
*      ls_fsdsm_dli    TYPE sdsm_dli,
*      lt_fsdsm_dli    TYPE STANDARD TABLE OF sdsm_dli,
*      fxkonv          TYPE STANDARD TABLE OF  konv,
*      fkomk           TYPE STANDARD TABLE OF  komk,
*      fkomp           TYPE STANDARD TABLE OF  komp,
*      fsdsm_main_item TYPE STANDARD TABLE OF sdsm_main_item,
*      fsales_text     TYPE STANDARD TABLE OF bapisdtext.
*
*    DATA: lv_fbuda TYPE datum,
*          ls_prps  TYPE prps,
*          lt_prps  TYPE STANDARD TABLE OF prps.
*    DATA wp_cnt TYPE i.
*    DATA: lv_order_id TYPE vbeln.
*    lv_order_id = lv_so_id.
*
*    DATA: lv_so_item1 TYPE posnr VALUE '000010',
*          lv_so_item2 TYPE posnr VALUE '000020',
*          lv_so_item3 TYPE posnr VALUE '000030'.
*
*    DATA: ls_vbkd TYPE vbkd.
*
*    "prepare data
*
*    mo_data_access->get_test_data(
*      EXPORTING
*        iv_tdc_variant = 'PBS_DMR_1'
*      IMPORTING
*        es_data        = ls_tdc_ci_scen ).
*
*    ls_data_tdc = ls_tdc_ci_scen-input_pbs_dmr.
*
*    lv_fbuda = sy-datum.
*
*** Fill Header structure
*    ls_i_sdsm_header-auart = ls_data_tdc-s_header-auart. " 'DMR1'.
*    ls_i_sdsm_header-ad01basdoc = lv_order_id.
*
*** Fill item table
**   fields I do not change between the ls_fsdsm_dli records
*    ASSERT ls_data_tdc-t_dyn_item IS NOT INITIAL.
*
**   fill line specific fields and append them to the itab
*    DATA lv_proj_pspnrb TYPE ps_intnr.
*    SELECT SINGLE pspnr FROM proj INTO lv_proj_pspnrb WHERE pspid = ls_proj-mp_id.
*    SELECT * FROM prps INTO TABLE lt_prps WHERE psphi = lv_proj_pspnrb.
*    ASSERT lt_prps IS NOT INITIAL.
*
*    SORT lt_prps BY posid.
*    LOOP AT lt_prps INTO ls_prps WHERE stufe EQ 2." AND          "ignore stufe 3
*      "posid NE IV_PROJ_ID. "ignore overview task
*      CLEAR: ls_vbkd.
*      IF ls_prps-abgsl EQ 'SPTM'.
*        " Time and Expenses
*        READ TABLE ls_data_tdc-t_dyn_item WITH KEY sd_matnr = 'T001' INTO ls_fsdsm_dli.
*      ELSE.
*        " Fix Price
*        READ TABLE ls_data_tdc-t_dyn_item WITH KEY sd_matnr = 'P001' INTO ls_fsdsm_dli.
*      ENDIF.
*      ASSERT sy-subrc = 0.
*      ls_fsdsm_dli-prsdt = lv_fbuda. "sdate.
*      ls_fsdsm_dli-poper = sy-datum(4) && '0' && sy-datum+4(2).  " e.g. '2016006'. "Posting period   numc(7)
*      ls_fsdsm_dli-fbuda = lv_fbuda.
*
*      ls_fsdsm_dli-objnr = ls_prps-objnr.            "c22
*      ls_fsdsm_dli-wbs_workpackage = ls_prps-pspnr.  "numc 8
*      ls_fsdsm_dli-fpltr = '000001'.                 "Item for billing plan/invoice plan/payment cards
*      ls_fsdsm_dli-dpbp_ref_fpltr = '000001'.
*
*      ADD 1 TO wp_cnt.
*      IF wp_cnt EQ 1.
****item 1
*
*        ls_fsdsm_dli-posnr_v = lv_so_item1.            "item number of the SO01 order
*        ls_fsdsm_dli-kbetr1 = 75 .                     "AN AMOUNT
*
*        SELECT SINGLE * FROM vbkd INTO ls_vbkd WHERE vbeln = lv_order_id AND posnr = lv_so_item1.
*        ASSERT sy-subrc IS INITIAL.
*
*        ls_fsdsm_dli-fplnr = ls_vbkd-fplnr.
*        ls_fsdsm_dli-dpbp_ref_fplnr = ls_vbkd-fplnr.
*
*      ELSEIF wp_cnt EQ 2.
****item2
*        ls_fsdsm_dli-posnr_v = lv_so_item2. "item number of the SO01 order
*        ls_fsdsm_dli-kbetr1 = 150 .   "AN AMOUNT
*
*        CLEAR: ls_vbkd.
*        SELECT SINGLE * FROM vbkd INTO ls_vbkd WHERE vbeln = lv_order_id AND posnr = lv_so_item2.
*        ASSERT sy-subrc IS INITIAL.
*
*        ls_fsdsm_dli-fplnr = ls_vbkd-fplnr.
*        ls_fsdsm_dli-dpbp_ref_fplnr = ls_vbkd-fplnr.
*
*      ELSEIF wp_cnt EQ 3.
****item2
*        ls_fsdsm_dli-posnr_v = lv_so_item3. "item number of the SO01 order
*        ls_fsdsm_dli-kbetr1 = 111 .   "AN AMOUNT
*
*        SELECT SINGLE * FROM vbkd INTO ls_vbkd WHERE vbeln = lv_order_id AND posnr = lv_so_item2.
*        ASSERT sy-subrc IS INITIAL.
*
*        ls_fsdsm_dli-fplnr = ls_vbkd-fplnr.
*        ls_fsdsm_dli-dpbp_ref_fplnr = ls_vbkd-fplnr.
*
*      ELSE.
*        CONTINUE.
*      ENDIF.
*
*      APPEND ls_fsdsm_dli TO lt_fsdsm_dli.
*
*    ENDLOOP.
*
*    CALL FUNCTION 'SD_SALES_DOCUMENT_FROM_SM'
*      EXPORTING
*        i_vbeln_v                      = lv_order_id "sales order ID
*        i_vbeln                        = lv_existing_dmr "initial   "if existing DMR document is to be enhanced - optional
*        i_sdsm_header                  = ls_i_sdsm_header
*        i_sdsm_main_item               = ls_sdsm_main_item  "initial
*        i_simulation                   = lb_simulation      "initial
*        i_xkonv_determine              = lb_xkonv_determine  "X
*        i_no_dialog                    = lb_no_dialog       "initial
*        i_no_save_on_incomplete        = lb_no_save_on_incomplete "initial
*      IMPORTING
*        e_vbeln                        = lv_e_dmr
*        e_sdsm_main_item               = ls_e_sdsm_main_item
*        e_komk                         = ls_e_komk
*      TABLES
*        fvbpakom                       = fvbpakom
*        fsdsm_dli                      = lt_fsdsm_dli "with input
*        fxkonv                         = fxkonv
*        fkomk                          = fkomk
*        fkomp                          = fkomp
*        fsdsm_main_item                = fsdsm_main_item
*        fsales_text                    = fsales_text
*      EXCEPTIONS
*        inconsistent_import_parameters = 1
*        error_occurred                 = 2
*        OTHERS                         = 3.
*
*    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
*
*    DATA: lv_ptf_key TYPE ptfkey.
*    MOVE lv_e_dmr TO lv_ptf_key.
*
*    ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).
*
*    IF ev_execution_status EQ abap_true.
*      APPEND lv_ptf_key TO ev_document_id.
*    ENDIF.

  ENDMETHOD.


  METHOD create_from_ps.

    DATA: ls_testdata    TYPE ty_gs_i_ptf_dmr_cr_from_ps,
          i_vbeln_c      TYPE vbeln,
          e_dmr          TYPE vbeln,
          lv_ptf_key     TYPE ptfkey,
          lv_date        LIKE sy-datum,
          lt_sales_order TYPE cl_ptf_util=>ty_vbeln_tab.

** Fetch sales order for test data container variant
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

    MOVE ls_testdata-sales_document TO i_vbeln_c.
    MOVE ls_testdata-billing_date TO lv_date.

    IF lv_date IS INITIAL OR lv_date = '00000000'.
      lv_date = sy-datum.
    ENDIF.

**  Get Sales Order ID from previous step
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_sales_order.
    ENDLOOP.

    IF lt_sales_order IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No sales order available from referenced step.| ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.

    ls_testdata-sales_document = lt_sales_order[ 1 ].

    cl_ps_billing_proposals=>set_rrb_pbs_flag( abap_true ).

** Create extracts for all the sales order items and creates DMR
    CALL FUNCTION 'VPKI_RRB_SM_COMPLETE'
      EXPORTING
        i_vbeln        = ls_testdata-sales_document
        i_date_to      = lv_date
*       i_save_pdoc    = 'X'
*     VALUE(I_PERIO_FROM) TYPE  VPKPERIODFROM OPTIONAL
*     VALUE(I_GJAHR_FROM) TYPE  VPKYEARFROM OPTIONAL
        i_create_dmr   = 'X'
      IMPORTING
        e_vbeln        = e_dmr
      EXCEPTIONS
        error_occurred = 1
        OTHERS         = 2.

** Check if the DMR is created
    MOVE e_dmr TO lv_ptf_key.
    ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).

    IF ev_execution_status = abap_true.
      APPEND lv_ptf_key TO ev_document_id.
    ENDIF.

  ENDMETHOD.


  METHOD create_with_reference.
    DATA:
      ls_testdata       TYPE ty_gs_i_ptf_dmr_cr_with_ref_td,
      lt_vbeln          TYPE cl_ptf_util=>ty_vbeln_tab,
      lv_error_occured  TYPE abap_bool VALUE abap_false,
      ls_load_parameter TYPE tds_goal_so_load,
      ls_head_data      TYPE tds_goal_so_head,
      lt_item_data      TYPE STANDARD TABLE OF tds_goal_so_item,
      lo_access         TYPE REF TO if_goal_access,
      ls_error          TYPE if_goal_types=>tcs_error,
      lv_bo_key         TYPE if_goal_types=>tcd_bo_key,
      lx_goal_exc       TYPE REF TO cx_goal_exc,
      lv_text_exc       TYPE string,
      ls_field_property TYPE if_goal_types=>tcs_object_property,
      lt_field_property TYPE if_goal_types=>tct_object_property,
      lt_message        TYPE if_goal_types=>tct_message,
      lv_cmr_vbeln      TYPE vbeln_va,
      lv_ptf_key        TYPE ptfkey,
      ls_itemlist       TYPE tdt_goal_sdoc_item_ref,
      lt_vbap           TYPE TABLE OF vbap,
      item              TYPE tds_goal_sdoc_item_ref,
      lt_vbrp           TYPE TABLE OF vbrp.
*****************************************************************************
* get tdcv
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata ).

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
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    IF lt_vbeln IS NOT INITIAL.
      LOOP AT lt_vbeln REFERENCE INTO DATA(ls_vbeln).
        SELECT * FROM vbap WHERE vbeln = @ls_vbeln->vbeln INTO TABLE @lt_vbap.
        IF lt_vbap IS INITIAL.
          SELECT * FROM vbrp WHERE vbeln = @ls_vbeln->vbeln INTO TABLE @lt_vbrp.
          IF lt_vbrp IS INITIAL.
            me->mo_run_environment->append_log( iv_log_statement = |Could not find any document { ls_vbeln->vbeln }.| ).
            ev_execution_status = abap_false.
            CONTINUE.
          ENDIF.
        ENDIF.

        LOOP AT lt_vbap REFERENCE INTO DATA(lr_vbap).
          APPEND VALUE #( item_id = lr_vbap->posnr quantity = lr_vbap->kwmeng ) TO ls_load_parameter-ref_item_list.
        ENDLOOP.

        LOOP AT lt_vbrp REFERENCE INTO DATA(lr_vbrp).
          APPEND VALUE #( item_id = lr_vbrp->posnr  ) TO ls_load_parameter-ref_item_list.
        ENDLOOP.

        ls_load_parameter-type_code = ls_testdata-document_type.
        ls_load_parameter-ref_document_id = ls_vbeln->vbeln.

        TRY.
            CALL METHOD cl_goal_api=>so_instance->create
              EXPORTING
                iv_bo_id          = if_goal_sdoc=>co_bo_id-debitmemorequest
                is_load_parameter = ls_load_parameter
              RECEIVING
                ro_access         = lo_access.
          CATCH cx_goal_exc INTO lx_goal_exc.
            me->mo_run_environment->append_log( iv_log_statement = lx_goal_exc->get_text( ) ).
            ev_execution_status = abap_false.
            lv_error_occured = abap_true.
            "lv_text_exc = lx_goal_exc->get_text( ).
            "message lv_text_exc type 'I'.
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
        lo_access->save( IMPORTING ev_bo_key = lv_cmr_vbeln ).

        IF lv_cmr_vbeln IS NOT INITIAL.
          me->mo_run_environment->append_log( iv_log_statement = |Created DMR with ID: { lv_cmr_vbeln }.|  ).
          APPEND lv_cmr_vbeln TO ev_document_id.
          lv_error_occured = abap_false.
        ELSE.
          me->mo_run_environment->append_log( iv_log_statement = |Could not create DMR.| ).
          lv_error_occured = abap_true.
          RETURN.
        ENDIF.
      ENDLOOP.
      IF lv_error_occured EQ abap_true.
        ev_execution_status = abap_false.
      ELSE.
        ev_execution_status = abap_true.
      ENDIF.
      cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
    ENDIF.

  ENDMETHOD.


  METHOD delete.
  ENDMETHOD.


  METHOD execute_action.
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).

    CASE ls_step_data-action.
      WHEN c_set_order_reason.
        me->set_order_reason(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_cfp.
        me->cfp(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_add_billing_block.
        DATA: ls_testdata TYPE ty_gs_i_ptf_dmr_ch_td.
        cl_ptf_util=>get_testdata(
          EXPORTING
            is_step_data = ls_step_data
          IMPORTING
            es_testdata  = ls_testdata
        ).
        LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
          DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
          LOOP AT lt_ptf_keys ASSIGNING FIELD-SYMBOL(<lv_ptf_key>).
            me->add_billing_block(
            EXPORTING
              iv_order_number = <lv_ptf_key>-vbeln
              iv_chance_tdc   = ls_testdata
            RECEIVING
              ev_test_success = ev_execution_status
            ).
          ENDLOOP.
        ENDLOOP.
        RETURN.
      WHEN c_remove_billing_block.
        LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step_v2>).
          DATA(lt_ptf_keys_v2) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step_v2> ).
          IF lt_ptf_keys_v2 IS NOT INITIAL.
            ev_execution_status = abap_true.
          ENDIF.
          LOOP AT lt_ptf_keys_v2 ASSIGNING FIELD-SYMBOL(<lv_ptf_key_v2>).
            DATA(lv_remove_suc) = me->remove_billing_block( iv_order_number = <lv_ptf_key_v2>-vbeln ).
            IF lv_remove_suc EQ abap_false.
              ev_execution_status = abap_false.
            ELSE.
              APPEND <lv_ptf_key_v2>-vbeln TO ev_document_id.
            ENDIF.
          ENDLOOP.
        ENDLOOP.
        RETURN.
      WHEN c_create_with_reference.
        me->create_with_reference(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_createfromproject.
        me->createfromproject(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_create_from_ps.
        me->create_from_ps(
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
            is_d_step           = ls_step_data
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_action_unlock.
        unlock(
          EXPORTING
            is_d_step           = ls_step_data
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN OTHERS.
        me->mo_run_environment->append_log( iv_log_statement =  |Could not find method { ls_step_data-action } for the BO { ls_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.
    ENDCASE.

  ENDMETHOD.


  METHOD execute_check.
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).

    CASE ls_step_data-action.

      WHEN c_check_compare_dmr.
        me->check_compare_dmr(
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


  METHOD keeping_lock_task.

    CHECK p_task EQ 'PTF_DMR'.
    IF mv_locked_async EQ 'R'. " lock requested
      RECEIVE RESULTS FROM FUNCTION 'SD_DOC_LOCK' KEEPING TASK
                          IMPORTING
                            ev_executed           = mv_locked_async
                          EXCEPTIONS
                            system_failure        = 1
                            communication_failure = 2
                            resource_failure      = 3.
    ENDIF.
    IF mv_unlocked_async EQ 'R'. " unlock requested
      RECEIVE RESULTS FROM FUNCTION 'SD_DOC_UNLOCK' KEEPING TASK
                          IMPORTING
                            ev_executed           = mv_unlocked_async
                          EXCEPTIONS
                            system_failure        = 1
                            communication_failure = 2
                            resource_failure      = 3.
    ENDIF.

  ENDMETHOD.


  METHOD lock.
    DATA: lv_vbeln TYPE vbeln.

    CLEAR:
      ev_check_status,
      ev_execution_status,
      ev_document_id.

    mv_locked_async = 'R'. " Lock requested

    LOOP AT is_d_step-reference_step ASSIGNING FIELD-SYMBOL(<ls_d_step>).
      DATA(ls_d_step) = me->mo_run_environment->get_step_data( iv_step_number = <ls_d_step> ).
      LOOP AT ls_d_step-document_id ASSIGNING FIELD-SYMBOL(<lv_docid>).
        lv_vbeln = <lv_docid>.

        CALL FUNCTION 'SD_DOC_LOCK' STARTING NEW TASK 'PTF_DMR' CALLING cl_ptf_bo_dmr=>keeping_lock_task ON END OF TASK
          EXPORTING
            iv_vbtyp              = if_sd_doc_category=>debit_memo_req
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


  METHOD prepare_testdata_create.
    DATA: ls_order_partners TYPE bapiparnr,
          ls_order_items    TYPE bapisditm,
          ls_schedules      TYPE bapischdl,
          ls_condition      TYPE bapicond.

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
    ls_order_header_in-purch_no_c = ls_testdata-cust_ref.
    ls_order_header_in-currency = ls_testdata-currency.

    IF ls_testdata-customer_id IS INITIAL.
      LOOP AT ls_testdata-order_partners ASSIGNING FIELD-SYMBOL(<ls_partner>).
        ls_order_partners-partn_role = <ls_partner>-partn_role.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = <ls_partner>-partn_numb
          IMPORTING
            output = ls_order_partners-partn_numb.

        IF <ls_partner>-itm_number IS NOT INITIAL.
          ls_order_partners-itm_number = <ls_partner>-itm_number.
        ENDIF.

        APPEND  ls_order_partners TO  lt_order_partners.
      ENDLOOP.
    ELSE.
      ls_order_partners-partn_role = 'AG'.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = ls_testdata-customer_id " C field
        IMPORTING
          output = ls_order_partners-partn_numb.

      APPEND  ls_order_partners TO  lt_order_partners.
    ENDIF.

    LOOP AT ls_testdata-item_list ASSIGNING FIELD-SYMBOL(<ls_order_item_list>).
      ls_order_items-itm_number = <ls_order_item_list>-posnr.
      ls_order_items-material =  <ls_order_item_list>-material_id.
      ls_order_items-target_qty = <ls_order_item_list>-quantity.
      ls_order_items-bill_date  = <ls_order_item_list>-fkdat.
      APPEND ls_order_items TO lt_order_items.

      ls_schedules-itm_number = <ls_order_item_list>-posnr.
      ls_schedules-req_qty    = <ls_order_item_list>-quantity.
      ls_schedules-req_date    = sy-datum.
      APPEND ls_schedules TO lt_schedules.
    ENDLOOP.

    LOOP AT ls_testdata-condition ASSIGNING FIELD-SYMBOL(<ls_cond>).
      ls_condition-cond_type = <ls_cond>-cond_type .
      ls_condition-cond_value = <ls_cond>-cond_value.
      ls_condition-itm_number = <ls_cond>-itm_number.
      APPEND ls_condition TO lt_condition.
    ENDLOOP.

    MOVE ls_testdata-sales_text TO lt_sales_text.
  ENDMETHOD.


  METHOD remove_billing_block.   "handles header block only

    DATA: ls_header_inx TYPE bapisdh1x,
          ls_header_in  TYPE bapisdh1,
          lt_return	    TYPE cl_ptf_util=>gt_ptf_return_tab,
          lv_vbeln      TYPE vbeln.

    MOVE iv_order_number TO lv_vbeln.
    IF lv_vbeln IS INITIAL.
      me->mo_run_environment->append_log( |Initial VBELN was given.| ).
      ev_test_success = abap_false.
      RETURN.
    ENDIF.

    ev_test_success = abap_true.


    SELECT SINGLE faksk FROM vbak INTO @DATA(lv_billing_block) WHERE vbeln = @lv_vbeln.
    IF lv_billing_block EQ space.
      me->mo_run_environment->append_log( |VBELN { lv_vbeln } before had VBAK-CMGST = space| ).
    ELSE.
      me->mo_run_environment->append_log( |VBELN { lv_vbeln } before had VBAK-CMGST = { lv_billing_block }| ).
    ENDIF.
    SELECT * FROM vbap INTO TABLE  @DATA(lt_vbap) WHERE vbeln = @lv_vbeln.
    LOOP AT lt_vbap REFERENCE INTO DATA(lr_vbap) WHERE faksp <> space.
      me->mo_run_environment->append_log( iv_log_statement = |Billing block { lr_vbap->faksp } (before) was found at item { lr_vbap->posnr }.| ).
    ENDLOOP.

    ls_header_inx-updateflag = 'U'.
    ls_header_inx-bill_block = 'X'.
    ls_header_in-bill_block  = ' '.

    CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
      EXPORTING
        salesdocument    = lv_vbeln    " Order Number
        order_header_in  = ls_header_in
        order_header_inx = ls_header_inx  " Sales Order Check List
      TABLES
        return           = lt_return.  " Return Code

    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ls_return>).
      IF <ls_return>-type EQ 'E'.
        ev_test_success = abap_false.
      ENDIF.
      me->mo_run_environment->append_log( iv_log_statement = |({ <ls_return>-type }){ <ls_return>-message }| ).
    ENDLOOP.

    WAIT UP TO 5 SECONDS.

    COMMIT WORK AND WAIT.


    SELECT SINGLE faksk FROM vbak INTO @DATA(lv_billing_block_after) WHERE vbeln = @lv_vbeln.
    IF lv_billing_block_after EQ space.
      me->mo_run_environment->append_log( |VBELN { lv_vbeln } now has VBAK-CMGST = space| ).
    ELSE.
      me->mo_run_environment->append_log( |VBELN { lv_vbeln } now has VBAK-CMGST = { lv_billing_block_after }| ).
    ENDIF.
    SELECT * FROM vbap INTO TABLE  @DATA(lt_vbap2) WHERE vbeln = @lv_vbeln.
    LOOP AT lt_vbap2 REFERENCE INTO lr_vbap WHERE faksp <> space.
      me->mo_run_environment->append_log( iv_log_statement = |Billing block { lr_vbap->faksp } now found at item { lr_vbap->posnr }.| ).
    ENDLOOP.


  ENDMETHOD.


  METHOD set_order_reason.
    DATA: test_data        TYPE ty_order_reason,
          ls_header_inx    TYPE bapisdh1x,
          ls_header_in     TYPE bapisdh1,
          lt_return	       TYPE cl_ptf_util=>gt_ptf_return_tab,
          orders_to_update TYPE cl_ptf_util=>ty_vbeln_tab,
          vbeln            TYPE bapivbeln-vbeln.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = test_data
    ).

    IF test_data-order_reason IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Please define an order reason.| ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(orders) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      APPEND LINES OF orders TO orders_to_update.
    ENDLOOP.

    IF orders_to_update IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No orders to update.| ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.

    ls_header_inx-updateflag  = 'U'.
    ls_header_inx-ord_reason = 'X'.
    ls_header_in-ord_reason = test_data-order_reason.

    ev_execution_status = abap_true.
    LOOP AT orders_to_update ASSIGNING FIELD-SYMBOL(<order_to_update>).

      MOVE <order_to_update>-vbeln TO vbeln.

      CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
        EXPORTING
          salesdocument    = vbeln    " Order Number
          order_header_in  = ls_header_in
          order_header_inx = ls_header_inx  " Sales Order Check List
        TABLES
          return           = lt_return.  " Return Code

      LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ls_return>).
        IF <ls_return>-type = 'E'.
          ev_execution_status = abap_false.
        ENDIF.
        me->mo_run_environment->append_log( iv_log_statement = |{ <ls_return>-message }| ).
      ENDLOOP.

      WAIT UP TO 5 SECONDS.
      COMMIT WORK AND WAIT.

    ENDLOOP.

  ENDMETHOD.


  METHOD unlock.
    DATA: lv_vbeln TYPE vbeln.

    CLEAR:
      ev_check_status,
      ev_execution_status,
      ev_document_id.

    mv_unlocked_async = 'R'. " unlock requested

    LOOP AT is_d_step-reference_step ASSIGNING FIELD-SYMBOL(<ls_d_step>).
      DATA(ls_d_step) = me->mo_run_environment->get_step_data( iv_step_number = <ls_d_step> ).
      LOOP AT ls_d_step-document_id ASSIGNING FIELD-SYMBOL(<lv_docid>).
        lv_vbeln = <lv_docid>.

        CALL FUNCTION 'SD_DOC_UNLOCK' STARTING NEW TASK 'PTF_DMR' CALLING cl_ptf_bo_dmr=>keeping_lock_task ON END OF TASK
          EXPORTING
            iv_vbtyp              = if_sd_doc_category=>debit_memo_req
            iv_vbeln              = lv_vbeln
          EXCEPTIONS
            system_failure        = 1
            communication_failure = 2
            resource_failure      = 3.

        WAIT FOR ASYNCHRONOUS TASKS UNTIL mv_unlocked_async EQ abap_true " unlock set
                                    UP TO 10 SECONDS.
        IF mv_unlocked_async EQ abap_true.
          ev_execution_status = abap_true.
        ENDIF.
        INSERT <lv_docid> INTO TABLE ev_document_id.
      ENDLOOP.
    ENDLOOP.

    CLEAR: mv_unlocked_async.

  ENDMETHOD.
ENDCLASS.
