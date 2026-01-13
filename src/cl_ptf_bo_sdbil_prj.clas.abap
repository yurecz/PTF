CLASS cl_ptf_bo_sdbil_prj DEFINITION
  PUBLIC
  INHERITING FROM cl_ptf_bo
  FINAL
  CREATE PUBLIC .



  PUBLIC SECTION.

    CONSTANTS:
      c_CREATE_DMR        TYPE string VALUE 'CREATE_DMR',
      c_CREATE_PRJ_AND_SO TYPE string VALUE 'CREATE_PRJ_AND_SO'.

    TYPES:
      BEGIN OF ty_prj_so_creation,
        s_proj         TYPE cl_sdbil_testdata=>ty_gs_pbs_pro,
        t_wp           TYPE cl_sdbil_testdata=>ty_gt_pbs_pro_wp,
        s_so_header    TYPE cl_sdbil_testdata=>ty_gs_pbs_so_header,
        t_so_item      TYPE cl_sdbil_testdata=>ty_gt_pbs_so_item,
        t_biplan_item  TYPE cl_sdbil_testdata=>ty_gt_pbs_biplan_item,
        project_prefix TYPE c LENGTH 4,
      END OF ty_prj_so_creation,

      ty_conditions TYPE STANDARD TABLE OF konv WITH DEFAULT KEY,

      BEGIN OF ty_dmr_input, "for DMR
        s_header   TYPE sdsm_header,
        t_dyn_item TYPE vb_sdsm_dli_t,
        conditions TYPE ty_conditions,
      END OF ty_dmr_input.

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

    METHODS create_prj_and_so
      IMPORTING
        !step_data           TYPE cl_ptf_util=>gt_ptf_step
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .

    METHODS create_dmr
      IMPORTING
        !step_data           TYPE cl_ptf_util=>gt_ptf_step
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS CL_PTF_BO_SDBIL_PRJ IMPLEMENTATION.


  METHOD change.
  ENDMETHOD.


  METHOD check.
  ENDMETHOD.


  METHOD check_existence.
  ENDMETHOD.


  METHOD create.
  ENDMETHOD.


  METHOD create_dmr.
* Create DMR ***********************************************************************

    DATA: ls_data_tdc TYPE ty_dmr_input. "ty_gs_input_pbs_prj_so_bp_td.

    DATA: ls_tdc_ci_scen TYPE cl_sdbil_testdata=>ty_gs_tdc_ci_scen,
          ls_data_prj    TYPE cl_sdbil_testdata=>ty_gs_input_pbs_prj_so_bp_td,
          lb_commit      TYPE abap_bool,
          lb_testrun     TYPE abap_bool,
          lv_sdate       TYPE sy-datum,
          lv_edate       TYPE sy-datum,
          ls_so_header   TYPE                     /cpd/s_ss_so_header_mig,  "not filled currently
          lt_bill_plan   TYPE                     /cpd/t_ss_sd_bplan_itm_mig,
          "ls_bill_plan  type /cpd/s_ss_sd_bplan_itm_mig,
          lt_so_item     TYPE                     /cpd/t_ss_so_item_mig,
          ls_so_item     TYPE /cpd/s_ss_so_item_mig,
          lv_so_id       TYPE                     vbeln_va,
**Declarations for project
          lv_mpid        TYPE  /cpd/mp_id,
          ls_proj        TYPE                     /cpd/s_ss_engmnt_project_mig,
**Declaretion for work package
          ls_wpa         TYPE                     /cpd/s_ss__workpackage_mig,
          lt_wpa         TYPE STANDARD TABLE OF   /cpd/s_ss__workpackage_mig,
**Declaration for workitem
          ls_witem       TYPE                     /cpd/s_ss_workitem_mig,
          lt_witem       TYPE STANDARD TABLE OF   /cpd/s_ss_workitem_mig,
**Declaration for plandata
          "ls_plan      TYPE                     /cpd/s_ss_plandata_mig,
          lt_plan        TYPE STANDARD TABLE OF   /cpd/s_ss_plandata_mig,  "not filled currently
          lt_fm_ret_msg  TYPE TABLE OF            bapiret2,
          mo_data_access TYPE REF TO cl_sdbil_testdata.

    CLEAR   ls_tdc_ci_scen.

    "FM input data
    DATA:
      lv_existing_dmr          TYPE vbeln,
      ls_sdsm_main_item        TYPE sdsm_main_item,
      lb_simulation            TYPE char1,
      lb_xkonv_determine       TYPE  boole_d VALUE abap_true,
      lb_no_dialog             TYPE char1,
      lb_no_save_on_incomplete TYPE xfeld,
      ls_i_sdsm_header         TYPE sdsm_header.

    "FM return data
    DATA:
      lv_e_dmr            TYPE vbeln,
      ls_e_sdsm_main_item TYPE sdsm_main_item,
      ls_e_komk           TYPE komk.

    "FM TABLES
    DATA:
      fvbpakom        TYPE STANDARD TABLE OF vbpakom,
      ls_fsdsm_dli    TYPE sdsm_dli,
      lt_fsdsm_dli    TYPE STANDARD TABLE OF sdsm_dli,
      fxkonv          TYPE STANDARD TABLE OF  konv,
      fkomk           TYPE STANDARD TABLE OF  komk,
      fkomp           TYPE STANDARD TABLE OF  komp,
      fsdsm_main_item TYPE STANDARD TABLE OF sdsm_main_item,
      fsales_text     TYPE STANDARD TABLE OF bapisdtext.

    DATA: lv_fbuda TYPE datum,
          ls_prps  TYPE prps,
          lt_prps  TYPE STANDARD TABLE OF prps.
    DATA wp_cnt TYPE i.
    DATA: lv_order_id TYPE vbeln.
    lv_order_id = lv_so_id.

    DATA: lv_so_item1 TYPE posnr VALUE '000010',
          lv_so_item2 TYPE posnr VALUE '000020',
          lv_so_item3 TYPE posnr VALUE '000030'.

    DATA: ls_vbkd TYPE vbkd.

    "prepare data

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = ls_data_tdc
    ).

    IF lines( step_data-reference_step ) > 1 OR lines( step_data-reference_step ) EQ 0.
      ev_execution_status = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |One reference step is required and only one is allowed| ).
      RETURN.
    ENDIF.

    DATA(ref_doc_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = step_data-reference_step[ 1 ] ).

    lv_so_id = ref_doc_keys[ 1 ].
    lv_order_id = ref_doc_keys[ 1 ].
    lv_mpid = ref_doc_keys[ 2 ].

    SELECT posnr,netwr FROM vbap WHERE vbeln = @lv_so_id INTO TABLE @DATA(netvalues).

    "ls_data_tdc = ls_tdc_ci_scen-input_pbs_dmr.

    lv_fbuda = sy-datum.

** Fill Header structure
    ls_i_sdsm_header-auart = ls_data_tdc-s_header-auart. " 'DMR1'.
    ls_i_sdsm_header-ad01basdoc = lv_order_id.

** Fill item table
*   fields I do not change between the ls_fsdsm_dli records
    ASSERT ls_data_tdc-t_dyn_item IS NOT INITIAL.

*   fill line specific fields and append them to the itab
    DATA lv_proj_pspnrb TYPE ps_intnr.
    SELECT SINGLE pspnr FROM proj INTO @lv_proj_pspnrb WHERE pspid = @lv_mpid.
    SELECT * FROM prps INTO TABLE lt_prps WHERE psphi = lv_proj_pspnrb.
    ASSERT lt_prps IS NOT INITIAL.

    SORT lt_prps BY posid.
    LOOP AT lt_prps INTO ls_prps WHERE stufe EQ 2." AND          "ignore stufe 3
      "posid NE IV_PROJ_ID. "ignore overview task
      CLEAR: ls_vbkd.
      IF ls_prps-abgsl EQ 'SPTM'.
        " Time and Expenses
        READ TABLE ls_data_tdc-t_dyn_item WITH KEY sd_matnr = 'T001' INTO ls_fsdsm_dli.
      ELSE.
        " Fix Price
        READ TABLE ls_data_tdc-t_dyn_item WITH KEY sd_matnr = 'P001' INTO ls_fsdsm_dli.
      ENDIF.
      ASSERT sy-subrc = 0.
      ls_fsdsm_dli-prsdt = lv_fbuda. "sdate.
      ls_fsdsm_dli-poper = sy-datum(4) && '0' && sy-datum+4(2).  " e.g. '2016006'. "Posting period   numc(7)
      ls_fsdsm_dli-fbuda = lv_fbuda.

      ls_fsdsm_dli-objnr = ls_prps-objnr.            "c22
      ls_fsdsm_dli-wbs_workpackage = ls_prps-pspnr.  "numc 8
      ls_fsdsm_dli-fpltr = '000001'.                 "Item for billing plan/invoice plan/payment cards
      ls_fsdsm_dli-dpbp_ref_fpltr = '000001'.

      ADD 1 TO wp_cnt.
      IF wp_cnt > lines( netvalues ).
        CONTINUE.
      ELSE.

        ls_fsdsm_dli-posnr_v = netvalues[ wp_cnt ]-posnr.            "item number of the SO01 order
        ls_fsdsm_dli-kbetr1 = netvalues[ wp_cnt ]-netwr .                     "AN AMOUNT

        ls_fsdsm_dli-fplnr = ls_vbkd-fplnr.
        ls_fsdsm_dli-dpbp_ref_fplnr = ls_vbkd-fplnr.

      ENDIF.




      APPEND ls_fsdsm_dli TO lt_fsdsm_dli.

    ENDLOOP.

    MOVE ls_data_tdc-conditions TO fxkonv.

    CALL FUNCTION 'SD_SALES_DOCUMENT_FROM_SM'
      EXPORTING
        i_vbeln_v                      = lv_order_id "sales order ID
        i_vbeln                        = lv_existing_dmr "initial   "if existing DMR document is to be enhanced - optional
        i_sdsm_header                  = ls_i_sdsm_header
        i_sdsm_main_item               = ls_sdsm_main_item  "initial
        i_simulation                   = lb_simulation      "initial
        i_xkonv_determine              = lb_xkonv_determine  "X
        i_no_dialog                    = lb_no_dialog       "initial
        i_no_save_on_incomplete        = lb_no_save_on_incomplete "initial
      IMPORTING
        e_vbeln                        = lv_e_dmr
        e_sdsm_main_item               = ls_e_sdsm_main_item
        e_komk                         = ls_e_komk
      TABLES
        fvbpakom                       = fvbpakom
        fsdsm_dli                      = lt_fsdsm_dli "with input
        fxkonv                         = fxkonv
        fkomk                          = fkomk
        fkomp                          = fkomp
        fsdsm_main_item                = fsdsm_main_item
        fsales_text                    = fsales_text
      EXCEPTIONS
        inconsistent_import_parameters = 1
        error_occurred                 = 2
        OTHERS                         = 3.

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

    IF lv_e_dmr IS NOT INITIAL.
      DATA: lv_ptf_key TYPE ptfkey.
      MOVE lv_e_dmr TO lv_ptf_key.
      APPEND lv_ptf_key TO ev_document_id.
      ev_execution_status = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD create_prj_and_so.
* Create Project ***********************************************************************
    DATA: ls_tdc_ci_scen TYPE ty_prj_so_creation,
          ls_data_prj    TYPE ty_prj_so_creation,
          lb_commit      TYPE abap_bool,
          lb_testrun     TYPE abap_bool,
          lv_sdate       TYPE sy-datum,
          lv_edate       TYPE sy-datum,
          ls_so_header   TYPE                     /cpd/s_ss_so_header_mig,
          lt_bill_plan   TYPE                     /cpd/t_ss_sd_bplan_itm_mig,
          "ls_bill_plan  type /cpd/s_ss_sd_bplan_itm_mig,
          lt_so_item     TYPE                     /cpd/t_ss_so_item_mig,
          ls_so_item     TYPE /cpd/s_ss_so_item_mig,
          lv_so_id       TYPE                     vbeln_va,
**Declarations for project
          lv_mpid        TYPE  /cpd/mp_id,
          ls_proj        TYPE                     /cpd/s_ss_engmnt_project_mig,
**Declaretion for work package
          ls_wpa         TYPE                     /cpd/s_ss__workpackage_mig,
          lt_wpa         TYPE STANDARD TABLE OF   /cpd/s_ss__workpackage_mig,
**Declaration for workitem
          ls_witem       TYPE                     /cpd/s_ss_workitem_mig,
          lt_witem       TYPE STANDARD TABLE OF   /cpd/s_ss_workitem_mig,
**Declaration for plandata
          "ls_plan      TYPE                     /cpd/s_ss_plandata_mig,
          lt_plan        TYPE STANDARD TABLE OF   /cpd/s_ss_plandata_mig,  "not filled currently
          lt_fm_ret_msg  TYPE TABLE OF            bapiret2,
          mo_data_access TYPE REF TO cl_sdbil_testdata.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = ls_data_prj
    ).

    "ls_data_prj = ls_tdc_ci_scen-input_pbs_prj_so.

    lv_sdate = sy-datum.
    lv_edate = lv_sdate + 10.

    lv_mpid = ls_data_prj-project_prefix && sy-datum+4 && 'U' && sy-uzeit.  " Note: >16 chars means dump   Characters in /cpd/cl_sc_cpm_constants=>gc_symbols are forbidden

    "Ensure that project ID is free
    DATA lv_projid TYPE /cpd/mp_id.
    SELECT SINGLE pspid FROM proj INTO lv_projid WHERE pspid = lv_mpid.

    "get an employment id
    SELECT SINGLE i_employstatdet~employmentinternalid INTO @DATA(lv_pernr) FROM i_employstatdet
             INNER JOIN i_persnwrkagreementdet ON i_persnwrkagreementdet~personworkagreement = i_employstatdet~employmentinternalid
             WHERE i_employstatdet~startdate <= @sy-datum AND
                   i_employstatdet~enddate >= @sy-datum.

** Fill project data - with tdc data and with dynamic values
    ls_proj-mp_id                 =  lv_mpid.
    ls_proj-customer              =  ls_data_prj-s_proj-cust_id.
    ls_proj-mp_title              =  ls_data_prj-s_proj-mp_title.
    ls_proj-proj_manager_id       =  lv_pernr.
    "ls_proj-proj_controller_id    =  "can be filled with same employee as manager field
    ls_proj-mpstage               =  /cpd/cl_sc_cpm_constants=>project_stages-in_execution.
    ls_proj-start_date            =  lv_sdate.
    ls_proj-end_date              =  lv_edate. .
    ls_proj-currency              =  ls_data_prj-s_proj-cur.
    ls_proj-org_id                =  ls_data_prj-s_proj-serv_org.
    ls_proj-cost_center           =  ls_data_prj-s_proj-cost_center.
    ls_proj-profit_center         =  ls_data_prj-s_proj-profit_center.
    ls_proj-confidential          = 'N'.

**Fill Work package - with tdc data and with dynamic values
    LOOP AT ls_data_prj-t_wp INTO DATA(ls_wp).
      ls_wpa-workpackagename         = ls_wp-wp_name.
      ls_wpa-wpdescription           = ls_wp-wp_description.
      ls_wpa-wpstartdate             = lv_sdate.
      ls_wpa-wpenddate               = lv_edate.
      ls_wpa-mp_id                   = lv_mpid. "master project id
      ls_wpa-item_id                 = ls_wp-so_item_id.
      APPEND ls_wpa TO lt_wpa.
    ENDLOOP.

**Fill ORDER HEADER
    ls_so_header = ls_data_prj-s_so_header.

**Fill ORDER ITEM
    lt_so_item = ls_data_prj-t_so_item.

**Fill BILLING PLAN - enrich tdc data with dynamic value (date)
    lt_bill_plan = ls_data_prj-t_biplan_item.
    LOOP AT lt_bill_plan REFERENCE INTO DATA(lr_bill_plan).
      lr_bill_plan->billing_due_date = lv_sdate.
      IF sy-tabix = 2.
        lr_bill_plan->billing_due_date = lv_sdate + 2.  "hard coded deviation for 2nd billing plan item...
      ENDIF.
    ENDLOOP.

    ls_proj-projecttype = /cpd/cl_sc_cpm_constants=>gc_customer_proj.
    lb_commit = abap_true.
    ls_proj-restrict_time_posting = 'N'.

    CALL FUNCTION '/CPD/ENGMTPROJECT_MIGRATION'
      EXPORTING
        iv_commit      = lb_commit  "controls commit of project, not of sales order
        iv_testrun     = lb_testrun
        is_engmnt_proj = ls_proj
        it_workpackage = lt_wpa
        it_workitem    = lt_witem
        it_plandata    = lt_plan
        is_so_header   = ls_so_header
        it_so_item     = lt_so_item
        it_billingplan = lt_bill_plan
      IMPORTING
        ev_document_id = lv_so_id
      TABLES
        et_return      = lt_fm_ret_msg.

    "BOPF transaction state is now = GC_STATE_DO_SAVE, but V60A expects a full cycle executed for the existing bopf objects when it starts
    DATA: lo_trans_mgr TYPE REF TO /bobf/if_tra_slave_trans_mgr,
          lr_message   TYPE REF TO /bobf/if_frw_message.

    lo_trans_mgr = /bobf/cl_tra_trans_mgr_factory=>get_slave_transaction_manager( ).
    lo_trans_mgr->after_successful_save( IMPORTING eo_message = lr_message ). " switches to GC_STATE_AFTER_SUCCESSFUL_SAVE and then to GC_STATE_INTERACTION
    lo_trans_mgr->do_cleanup( iv_execute_rollback_work = abap_false ). "allowed only from GC_STATE_INTERACTION

    LOOP AT lt_fm_ret_msg ASSIGNING FIELD-SYMBOL(<ret_msg>).
      me->mo_run_environment->append_log_structure( is_log = <ret_msg> ).
    ENDLOOP.

    IF lv_so_id IS NOT INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Created sales order { lv_so_id } for mpid { lv_mpid }.| ).
      ev_execution_status = abap_true.
      APPEND lv_so_id TO ev_document_id.
      APPEND lv_mpid TO ev_document_id.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |Sales order & Project were not created.| ).
      ev_execution_status = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD delete.
  ENDMETHOD.


  METHOD execute_action.
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).

    CASE ls_step_data-action.
      WHEN c_create_dmr.
        me->create_dmr(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_create_prj_and_so.
        me->create_prj_and_so(
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
  ENDMETHOD.
ENDCLASS.
