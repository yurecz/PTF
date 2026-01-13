*CLASS ltcl_dmr DEFINITION FOR TESTING
*  INHERITING FROM cl_ptf_template
*  DURATION SHORT
*  RISK LEVEL HARMLESS.
*  PUBLIC SECTION.
*
*  PRIVATE SECTION.
*    METHODS create_and_add_bb FOR TESTING..
*
*ENDCLASS.
*
*CLASS ltcl_dmr IMPLEMENTATION.
*
*  METHOD create_and_add_bb.
*    DATA(f_cut) = NEW cl_ptf_bo_dmr( ).
*    DATA: cs_step_data TYPE if_ptf_param_types=>gt_ptf_step,
*          ct_step_data TYPE if_ptf_param_types=>gt_ptf_step_tab.
*
*    cs_step_data-bus_obj = 'DMR'.
*    cs_step_data-action = 'CREATE'.
*    cs_step_data-tdcv = 'DMR_CR_I1_Q1'.
*    cs_step_data-var_step = 1.
*
*    APPEND cs_step_data TO ct_step_data.
*
*    f_cut->if_ptf_bo~create(
*      IMPORTING
*        et_return    = DATA(lt_return)
*      CHANGING
*        cs_step_data = cs_step_data
*        ct_step_data = ct_step_data
*    ).
*
*    cs_step_data-bus_obj = 'DMR'.
*    cs_step_data-action = 'ADD_BILLING_BLOCK'.
*    cs_step_data-tdcv = 'ADD_BILLING_BLOCK_09'.
*    cs_step_data-var_step = 2.
*
*    APPEND cs_step_data TO ct_step_data.
*
*    f_cut->if_ptf_bo~execute_action(
*      IMPORTING
*        et_return    = lt_return
*      CHANGING
*        cs_step_data = cs_step_data
*        ct_step_data = ct_step_data
*    ).
*  ENDMETHOD.
*ENDCLASS.





"* use this source file for your ABAP unit test classes
*
*CLASS lth_tdc_variant DEFINITION CREATE PRIVATE FOR TESTING.   "Helper class for Unit tests
*
*  PUBLIC SECTION.
*    "Types
*    TYPES: typ_input_ptf_create TYPE cl_ptf_bo_dmr=>ty_gs_input_ptf_create_td.
*    TYPES: tt_variant           TYPE STANDARD TABLE OF REF TO lth_tdc_variant WITH DEFAULT KEY.
*    TYPES: typ_variant TYPE REF TO lth_tdc_variant.
*
*
*    CLASS-METHODS:
*      s_get_variant
*        IMPORTING
*          iv_tdc_name       TYPE etobj_name
*          iv_var_name       TYPE etvar_id
*        RETURNING
*          VALUE(rv_variant) TYPE typ_variant
*        RAISING
*          cx_ecatt_tdc_access.
*
*
*    CLASS-METHODS:
*      s_get_variants
*        IMPORTING
*          iv_tdc_name       TYPE etobj_name
*        RETURNING
*          VALUE(rt_variant) TYPE tt_variant
*        RAISING
*          cx_ecatt_tdc_access.
*
*
*    METHODS:
*      get_input_ptf_create
*        RETURNING
*          VALUE(rv_input_ptf_create) TYPE cl_ptf_bo_dmr=>ty_gs_input_ptf_create_td.
*
*
*    METHODS:
*      get_input_ptf_change
*        RETURNING
*          VALUE(rv_input_ptf_create) TYPE cl_ptf_bo_dmr=>ty_gs_input_ptf_create_td.
*
*  PRIVATE SECTION.
*    CLASS-DATA:
*      so_tdc_api TYPE REF TO cl_apl_ecatt_tdc_api.
*
*    DATA:
*      mv_name TYPE etvar_id.
*
*
*    METHODS:
*      init
*        IMPORTING
*          iv_name TYPE csequence.
*
*
*ENDCLASS.
*
*CLASS lth_tdc_variant IMPLEMENTATION.
*  METHOD s_get_variant.
*    DATA:
*      lt_variant TYPE etvar_name_tabtype,
*      lv_variant LIKE LINE OF lt_variant,
*      lo_variant TYPE REF TO lth_tdc_variant.
*
*    so_tdc_api = cl_apl_ecatt_tdc_api=>get_instance( iv_tdc_name ).
*    lt_variant = so_tdc_api->get_variant_list( ).
*
*    READ TABLE lt_variant INTO lv_variant
*         WITH KEY table_line = iv_var_name.
*    IF sy-subrc = 0.
*      CREATE OBJECT rv_variant.
*      rv_variant->init( iv_name = lv_variant ).
*    ENDIF.
*
*  ENDMETHOD.
*
*
*  METHOD s_get_variants.
*    DATA:
*      lt_variant TYPE etvar_name_tabtype,
*      lv_variant LIKE LINE OF lt_variant,
*      lo_variant TYPE REF TO lth_tdc_variant.
*
*    so_tdc_api = cl_apl_ecatt_tdc_api=>get_instance( iv_tdc_name ).
*    lt_variant = so_tdc_api->get_variant_list( ).
*
*    LOOP AT lt_variant INTO lv_variant WHERE table_line <> 'ECATTDEFAULT'.
*      CREATE OBJECT lo_variant.
*      lo_variant->init( iv_name = lv_variant ).
*      APPEND lo_variant TO rt_variant.
*    ENDLOOP.
*  ENDMETHOD.
*
*  METHOD init.
*    mv_name = iv_name.
*  ENDMETHOD.
*
*
*  METHOD get_input_ptf_create.
*    TRY.
*        so_tdc_api->get_value(
*          EXPORTING
*            i_param_name = 'I_PTF_DMR_CR'
*            i_variant_name = me->mv_name
*          CHANGING
*            e_param_value = rv_input_ptf_create ).
*
*      CATCH cx_ecatt_tdc_access.
*        cl_aunit_assert=>fail(
*          msg = 'Error reading test data for I_PTF_DMR_CR' ).
*
*    ENDTRY.
*  ENDMETHOD.
*
*  METHOD get_input_ptf_change.
*    TRY.
*        so_tdc_api->get_value(
*          EXPORTING
*            i_param_name = 'I_PTF_DMR_CH'
*            i_variant_name = me->mv_name
*          CHANGING
*            e_param_value = rv_input_ptf_create ).
*
*      CATCH cx_ecatt_tdc_access.
*        cl_aunit_assert=>fail(
*          msg = 'Error reading test data for I_PTF_DMR_CR' ).
*
*    ENDTRY.
*  ENDMETHOD.
*ENDCLASS.
*
*
*CLASS ltcl_ptf_bo_dmr DEFINITION FOR TESTING
*  DURATION SHORT
*  RISK LEVEL HARMLESS
*  FINAL.
*  PUBLIC SECTION.
*
*    METHODS create_dmr   FOR TESTING.
*    METHODS change       FOR TESTING.
*    METHODS bapitest     FOR TESTING.
*
*  PRIVATE SECTION.
*
*    CONSTANTS c_tdc_ptf        TYPE etobj_name  VALUE 'ZTDC_PTF'.
*    CONSTANTS c_var_ptf        TYPE etvar_id    VALUE 'DMR_CR_I2_Q1'.
*    CONSTANTS c_var_ptf_ch     TYPE etvar_id    VALUE 'DMR_CH_I2_Q5'.
*    CONSTANTS c_var_ptf_ch_res TYPE etvar_id    VALUE 'DMR_CR_I5_Q1'.
*
*ENDCLASS.
*
*
*
*CLASS ltcl_ptf_bo_dmr IMPLEMENTATION.
*
*
*  METHOD create_dmr.
*    DATA(lo_dmr) =       NEW cl_ptf_bo_dmr( ).
*    DATA bool_success    TYPE abap_bool.
*    DATA ptf_test_result TYPE cl_ptf_bo_dmr=>ty_gs_input_ptf_create_td.   "lth_tdc_variant=>typ_input_ptf_create.
*
*
*    TRY.
*        DATA(lo_variant) = lth_tdc_variant=>s_get_variant( EXPORTING iv_tdc_name = c_tdc_ptf                      " Variant that shall be created
*                                                                     iv_var_name = c_var_ptf ).
*      CATCH cx_ecatt_tdc_access.
*    ENDTRY.
*
*    IF lo_variant IS BOUND.
*      DATA(ls_ptf_create_dmr) = lo_variant->get_input_ptf_create( ).
*
*    ENDIF.
*
*    lo_dmr->create(
*      EXPORTING
*               is_testdata     = ls_ptf_create_dmr
*               iv_tdc_variant  = c_tdc_ptf
*     IMPORTING
*               ev_order_number = DATA(ev_order_number)
*               ev_test_success = bool_success
*               ev_result_data  = ptf_test_result
*                ).
*
*
*    cl_abap_unit_assert=>assert_not_initial(                                                                       " Assertion to verify that the process worked successfully
*                           act   = ev_order_number
*                           msg = 'Critical Assertion Error: Test data container:_' &&  c_tdc_ptf  && '_Variant: _' &&  c_var_ptf ).
*
*  ENDMETHOD.
*
*
*  METHOD change.
*    DATA(lo_dmr) =       NEW cl_ptf_bo_dmr( ).
*    DATA bool_success    TYPE abap_bool.
**    DATA ptf_test_result TYPE cl_ptf_bo_dmr=>ty_gs_input_ptf_create_td.
*
*
*    TRY.
*        DATA(lo_variant_ch) = lth_tdc_variant=>s_get_variant( EXPORTING  iv_tdc_name = c_tdc_ptf          " Variant which contains the data that shall be changed
*                                                                         iv_var_name = c_var_ptf_ch ).
*      CATCH cx_ecatt_tdc_access.
*    ENDTRY.
*
*    TRY.
*        DATA(lo_variant_act) = lth_tdc_variant=>s_get_variant( EXPORTING iv_tdc_name = c_tdc_ptf          " Variant which shall be changed
*                                                                          iv_var_name = c_var_ptf ).
*      CATCH cx_ecatt_tdc_access.
*    ENDTRY.
*
*
*    IF lo_variant_ch IS BOUND.
*      DATA(ls_ptf_create_dmr_ch) = lo_variant_ch->get_input_ptf_change( ). " type typ_input_ptf_create
*
*    ENDIF.
*
*    IF lo_variant_act IS BOUND.
*      DATA(ls_ptf_create_dmr_act) = lo_variant_act->get_input_ptf_create( ).
*
*    ENDIF.
*    DATA(ls_data_order) = ls_ptf_create_dmr_act.
*
*    lo_dmr->create(
*      EXPORTING
*        is_testdata     = ls_ptf_create_dmr_act
*        iv_tdc_variant  = c_tdc_ptf
*      IMPORTING
*        ev_order_number = DATA(iv_vbeln)
*        ev_test_success = bool_success
*    ).
*    DATA(iv_order_number) = iv_vbeln.
*
*    lo_dmr->change(
*      EXPORTING
*        iv_order_number = iv_order_number
*        iv_chance_tdc   = ls_ptf_create_dmr_ch
*      IMPORTING
*        ev_test_success = bool_success
*
*    ).
*
*
*      cl_abap_unit_assert=>assert_equals(
*        EXPORTING
*          act                  =    bool_success
*          exp                  =    abap_true
*          msg                  =     'Error in change Method for Test data container:_' &&  c_tdc_ptf  && '_Variant: _' &&  c_var_ptf_ch
*      ).
*
*
*
*
*
*
**
***    TRY.
***        DATA(lo_variant_res) = lth_tdc_variant=>s_get_variant(                                              " Variant (complete data) which contains the changed data.
***                               iv_tdc_name         = c_tdc_ptf                                              " Needed to verify that the process worked successfully.
***                               iv_var_name         = c_var_ptf_ch_res
***                           ).
***      CATCH cx_ecatt_tdc_access.
***    ENDTRY.
***
***    IF lo_variant_res IS BOUND.
***      DATA(ls_ptf_create_dmr_ch_res) = lo_variant_res->get_input_ptf_create( ).
***    ENDIF.
***
***    cl_abap_unit_assert=>assert_equals(                                                                 " Assertion
***                    act   = ls_data_result
***                    exp   = ls_ptf_create_dmr_ch_res
***                    msg   = 'Error in change Method for Test data container:_' &&  c_tdc_ptf  && '_Variant: _' &&  c_var_ptf_ch ).
*
*  ENDMETHOD.
*
*  METHOD bapitest.
*
***
***
***
*
*  ENDMETHOD.
*ENDCLASS.
