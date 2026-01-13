*"* use this source file for your ABAP unit test classes
* Local Test Class for method dynamic_check
CLASS ltc_dynamic_check DEFINITION DEFERRED.
CLASS cl_ptf_rap_validate_tdo DEFINITION LOCAL FRIENDS ltc_dynamic_check.

CLASS ltc_dynamic_check DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    METHODS setup.
    METHODS teardown.

    METHODS one_exp_one_act_eq_op FOR TESTING.
    METHODS one_exp_two_act_eq_op FOR TESTING.
    METHODS one_exp_two_act_diff_op FOR TESTING.
    METHODS two_exp_one_act_gt_op FOR TESTING.
    METHODS two_exp_two_act_ge_op FOR TESTING.
    METHODS one_exp_two_act_lt_op FOR TESTING.
    METHODS one_exp_one_act_le_op FOR TESTING.

    DATA mo_cut TYPE REF TO cl_ptf_rap_validate_tdo.

ENDCLASS.

CLASS ltc_dynamic_check IMPLEMENTATION.
  METHOD class_setup.

  ENDMETHOD.

  METHOD setup.
    DATA lt_step_data             TYPE cl_ptf_util=>gt_ptf_step_tab.

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW #( lo_ptf_run ).

  ENDMETHOD.

  METHOD teardown.

  ENDMETHOD.

  METHOD class_teardown.

  ENDMETHOD.

  METHOD one_exp_one_act_eq_op.
    "when
    DATA(lv_result) = mo_cut->dynamic_check( iv_expected = 1 iv_actual = 1 iv_operator = '=' ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_result ).

  ENDMETHOD.

  METHOD one_exp_two_act_eq_op.
    "when
    DATA(lv_result) = mo_cut->dynamic_check( iv_expected = 1 iv_actual = 2 iv_operator = '=' ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_result ).

  ENDMETHOD.

  METHOD one_exp_two_act_diff_op.
    "when
    DATA(lv_result) = mo_cut->dynamic_check( iv_expected = 'one' iv_actual = 'two' iv_operator = '<>' ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_result ).

  ENDMETHOD.

  METHOD two_exp_one_act_gt_op.
    "when
    DATA(lv_result) = mo_cut->dynamic_check( iv_expected = 2 iv_actual = 1 iv_operator = '>' ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_result ).

  ENDMETHOD.

  METHOD two_exp_two_act_ge_op.
    "when
    DATA(lv_result) = mo_cut->dynamic_check( iv_expected = 2 iv_actual = 2 iv_operator = '>=' ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_result ).

  ENDMETHOD.

  METHOD one_exp_two_act_lt_op.
    "when
    DATA(lv_result) = mo_cut->dynamic_check( iv_expected = 1 iv_actual = 2 iv_operator = '<' ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_result ).

  ENDMETHOD.

  METHOD one_exp_one_act_le_op.
    "when
    DATA(lv_result) = mo_cut->dynamic_check( iv_expected = 1 iv_actual = 1 iv_operator = '<=' ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_result ).

  ENDMETHOD.

ENDCLASS.

* Local Test Class for method set_control_flag
CLASS ltc_control_flag DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    METHODS setup.
    METHODS teardown.

    METHODS cr_mandatory_initial FOR TESTING.
    METHODS cr_mandatory_not_initial FOR TESTING.
    METHODS ch_value_w_initial FOR TESTING.
    METHODS ch_value_wo_initial FOR TESTING.
    METHODS ch_value_initial_w_initial FOR TESTING.
    METHODS ch_value_initial_wo_initial FOR TESTING.
    METHODS read_retrieve_value FOR TESTING.
    METHODS read_check_value FOR TESTING.

    TYPES: BEGIN OF ts_test_data,
             field1 TYPE char10,
           END OF ts_test_data.

    DATA mo_cut       TYPE REF TO if_ptf_rap_validate_tdo.
    DATA ms_test_data TYPE ts_test_data.

ENDCLASS.

CLASS ltc_control_flag IMPLEMENTATION.
  METHOD class_setup.

  ENDMETHOD.

  METHOD setup.
    DATA lt_step_data             TYPE cl_ptf_util=>gt_ptf_step_tab.

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW cl_ptf_rap_validate_tdo( lo_ptf_run ).

  ENDMETHOD.

  METHOD teardown.

  ENDMETHOD.

  METHOD class_teardown.

  ENDMETHOD.

  METHOD cr_mandatory_initial.
    "when
    mo_cut->set_control_flag(
      EXPORTING
        iv_op                   = if_abap_behv=>op-m-create
        iv_name                 = 'FIELD1'
        iv_action               = 'CREATE'
        iv_field                = space
        iv_field_control        = if_abap_behv=>fc-f-mandatory
        iv_initial              = abap_off
        is_test_data            = ms_test_data
      IMPORTING
        es_flag_control_issues  = DATA(ls_flag_control_issues)
        ev_flag_control         = DATA(lv_flag_control)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lv_flag_control exp = cl_abap_behv=>flag_null ).
    cl_abap_unit_assert=>assert_not_initial( act = ls_flag_control_issues-e_is_mandatory ).

  ENDMETHOD.

  METHOD cr_mandatory_not_initial.
    "when
    mo_cut->set_control_flag(
      EXPORTING
        iv_op                   = if_abap_behv=>op-m-create
        iv_name                 = 'FIELD1'
        iv_action               = 'CREATE'
        iv_field                = 'VALUE1'
        iv_field_control        = if_abap_behv=>fc-f-mandatory
        iv_initial              = abap_off
        is_test_data            = ms_test_data
      IMPORTING
        es_flag_control_issues  = DATA(ls_flag_control_issues)
        ev_flag_control         = DATA(lv_flag_control)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lv_flag_control exp = cl_abap_behv=>flag_changed ).
    cl_abap_unit_assert=>assert_initial( act = ls_flag_control_issues ).

  ENDMETHOD.

  METHOD ch_value_w_initial.
    "when
    mo_cut->set_control_flag(
      EXPORTING
        iv_op                   = if_abap_behv=>op-m-update
        iv_name                 = 'FIELD1'
        iv_action               = 'CREATE'
        iv_field                = 'VALUE1'
        iv_field_control        = if_abap_behv=>fc-f-unrestricted
        iv_initial              = abap_on
        is_test_data            = ms_test_data
      IMPORTING
        es_flag_control_issues  = DATA(ls_flag_control_issues)
        ev_flag_control         = DATA(lv_flag_control)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lv_flag_control exp = cl_abap_behv=>flag_null ).
    cl_abap_unit_assert=>assert_not_initial( act = ls_flag_control_issues-e_value_w_initial ).

  ENDMETHOD.

  METHOD ch_value_wo_initial.
    "when
    mo_cut->set_control_flag(
      EXPORTING
        iv_op                   = if_abap_behv=>op-m-update
        iv_name                 = 'FIELD1'
        iv_action               = 'CREATE'
        iv_field                = 'VALUE1'
        iv_field_control        = if_abap_behv=>fc-f-unrestricted
        iv_initial              = abap_off
        is_test_data            = ms_test_data
      IMPORTING
        es_flag_control_issues  = DATA(ls_flag_control_issues)
        ev_flag_control         = DATA(lv_flag_control)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lv_flag_control exp = cl_abap_behv=>flag_changed ).
    cl_abap_unit_assert=>assert_initial( act = ls_flag_control_issues ).

  ENDMETHOD.

  METHOD ch_value_initial_w_initial.
    "when
    mo_cut->set_control_flag(
      EXPORTING
        iv_op                   = if_abap_behv=>op-m-update
        iv_name                 = 'FIELD1'
        iv_action               = 'CREATE'
        iv_field                = space
        iv_field_control        = if_abap_behv=>fc-f-unrestricted
        iv_initial              = abap_on
        is_test_data            = ms_test_data
      IMPORTING
        es_flag_control_issues  = DATA(ls_flag_control_issues)
        ev_flag_control         = DATA(lv_flag_control)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lv_flag_control exp = cl_abap_behv=>flag_changed ).
    cl_abap_unit_assert=>assert_initial( act = ls_flag_control_issues ).

  ENDMETHOD.

  METHOD ch_value_initial_wo_initial.
    "when
    mo_cut->set_control_flag(
      EXPORTING
        iv_op                   = if_abap_behv=>op-m-update
        iv_name                 = 'FIELD1'
        iv_action               = 'CREATE'
        iv_field                = space
        iv_field_control        = if_abap_behv=>fc-f-unrestricted
        iv_initial              = abap_off
        is_test_data            = ms_test_data
      IMPORTING
        es_flag_control_issues  = DATA(ls_flag_control_issues)
        ev_flag_control         = DATA(lv_flag_control)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lv_flag_control exp = cl_abap_behv=>flag_null ).
    cl_abap_unit_assert=>assert_true( act = ls_flag_control_issues-w_use_initial ).

  ENDMETHOD.

  METHOD read_retrieve_value.
    "when
    mo_cut->set_control_flag(
      EXPORTING
        iv_op                   = if_abap_behv=>op-r-read
        iv_name                 = 'FIELD1'
        iv_action               = 'RETRIEVE'
        iv_field                = 'VALUE1'
        "iv_field_control        = if_abap_behv=>fc-f-unrestricted
        "iv_initial              = abap_off
        is_test_data            = ms_test_data
      IMPORTING
        es_flag_control_issues  = DATA(ls_flag_control_issues)
        ev_flag_control         = DATA(lv_flag_control)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lv_flag_control exp = cl_abap_behv=>flag_changed ).
    cl_abap_unit_assert=>assert_initial( act = ls_flag_control_issues ).

  ENDMETHOD.

  METHOD read_check_value.
    "when
    mo_cut->set_control_flag(
      EXPORTING
        iv_op                   = if_abap_behv=>op-r-read
        iv_name                 = 'FIELD1'
        iv_action               = 'CHECK'
        iv_field                = 'VALUE1'
        "iv_field_control        = if_abap_behv=>fc-f-unrestricted
        "iv_initial              = abap_off
        is_test_data            = ms_test_data
      IMPORTING
        es_flag_control_issues  = DATA(ls_flag_control_issues)
        ev_flag_control         = DATA(lv_flag_control)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lv_flag_control exp = cl_abap_behv=>flag_changed ).
    cl_abap_unit_assert=>assert_initial( act = ls_flag_control_issues ).

  ENDMETHOD.

ENDCLASS.

* Local Test Class for method set_control_flag
CLASS ltc_recursive_check_params DEFINITION DEFERRED.
CLASS cl_ptf_rap_validate_tdo DEFINITION LOCAL FRIENDS ltc_recursive_check_params.

CLASS ltc_recursive_check_params DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    METHODS setup.
    METHODS teardown.

    METHODS check_complex_params_true FOR TESTING.
    METHODS check_complex_params_false_1 FOR TESTING.
    METHODS check_complex_params_false_2 FOR TESTING.
    METHODS check_complex_params_false_3 FOR TESTING.
    METHODS check_complex_params_false_4 FOR TESTING.

    TYPES: BEGIN OF ts_simple_struct_1,
             a TYPE c LENGTH 1,
             b TYPE c LENGTH 1,
             c TYPE c LENGTH 1,
           END OF ts_simple_struct_1,
           BEGIN OF ts_simple_struct_2,
             a TYPE c LENGTH 1,
             b TYPE c LENGTH 1,
           END OF ts_simple_struct_2.

    TYPES: tt_simple_itab_1 TYPE STANDARD TABLE OF ts_simple_struct_1 WITH DEFAULT KEY,
           tt_simple_itab_2 TYPE STANDARD TABLE OF ts_simple_struct_2 WITH DEFAULT KEY.

    TYPES: BEGIN OF ts_complex_struct_1,
             a TYPE ts_simple_struct_1,
             b TYPE c LENGTH 1,
             c TYPE tt_simple_itab_1,
           END OF ts_complex_struct_1,
           BEGIN OF ts_complex_struct_2,
             a TYPE ts_simple_struct_2,
             c TYPE tt_simple_itab_2,
           END OF ts_complex_struct_2.

    TYPES: tt_complex_itab_1 TYPE STANDARD TABLE OF ts_complex_struct_1 WITH DEFAULT KEY,
           tt_complex_itab_2 TYPE STANDARD TABLE OF ts_complex_struct_2 WITH DEFAULT KEY.

    TYPES: BEGIN OF ts_data_1,
             a TYPE c LENGTH 1,
             b TYPE ts_simple_struct_1,
             c TYPE tt_complex_itab_1,
             d TYPE ts_complex_struct_1,
           END OF ts_data_1.

    TYPES: BEGIN OF ts_data_2,
             a TYPE c LENGTH 1,
             b TYPE ts_simple_struct_1,
             c TYPE tt_complex_itab_1,
           END OF ts_data_2.

    TYPES: BEGIN OF ts_data_3,
             a TYPE c LENGTH 1,
             b TYPE ts_simple_struct_2,
             c TYPE tt_complex_itab_1,
             d TYPE ts_complex_struct_1,
           END OF ts_data_3.

    TYPES: BEGIN OF ts_data_4,
             a TYPE c LENGTH 1,
             b TYPE ts_simple_struct_1,
             c TYPE tt_complex_itab_2,
             d TYPE ts_complex_struct_1,
           END OF ts_data_4.

    TYPES: BEGIN OF ts_data_5,
             a TYPE c LENGTH 1,
             b TYPE ts_simple_struct_1,
             c TYPE tt_complex_itab_1,
             d TYPE ts_complex_struct_2,
           END OF ts_data_5.

    DATA mo_cut       TYPE REF TO cl_ptf_rap_validate_tdo.

ENDCLASS.

CLASS ltc_recursive_check_params IMPLEMENTATION.
  METHOD class_setup.

  ENDMETHOD.

  METHOD setup.
    DATA lt_step_data             TYPE cl_ptf_util=>gt_ptf_step_tab.

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW cl_ptf_rap_validate_tdo( lo_ptf_run ).

  ENDMETHOD.

  METHOD teardown.

  ENDMETHOD.

  METHOD class_teardown.

  ENDMETHOD.

  METHOD check_complex_params_true.
    DATA: ls_data   TYPE ts_data_1,
          ls_params TYPE ts_data_1.

    "when
    mo_cut->recursive_check_params(
      EXPORTING
        iv_name       = 'TEST_BO'
        iv_p_sub_name = 'TEST_ACTION'
        is_data       = ls_data
        is_params     = ls_params
      IMPORTING
        ev_error      = DATA(lv_error)
      ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_error ).

  ENDMETHOD.

  METHOD check_complex_params_false_1.
    DATA: ls_data   TYPE ts_data_1,
          ls_params TYPE ts_data_2.

    "when
    mo_cut->recursive_check_params(
      EXPORTING
        iv_name       = 'TEST_BO'
        iv_p_sub_name = 'TEST_ACTION'
        is_data       = ls_data
        is_params     = ls_params
      IMPORTING
        ev_error      = DATA(lv_error)
      ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_error ).

  ENDMETHOD.

  METHOD check_complex_params_false_2.
    DATA: ls_data   TYPE ts_data_1,
          ls_params TYPE ts_data_3.

    "when
    mo_cut->recursive_check_params(
      EXPORTING
        iv_name       = 'TEST_BO'
        iv_p_sub_name = 'TEST_ACTION'
        is_data       = ls_data
        is_params     = ls_params
      IMPORTING
        ev_error      = DATA(lv_error)
      ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_error ).

  ENDMETHOD.

  METHOD check_complex_params_false_3.
    DATA: ls_data   TYPE ts_data_1,
          ls_params TYPE ts_data_4.

    "when
    mo_cut->recursive_check_params(
      EXPORTING
        iv_name       = 'TEST_BO'
        iv_p_sub_name = 'TEST_ACTION'
        is_data       = ls_data
        is_params     = ls_params
      IMPORTING
        ev_error      = DATA(lv_error)
      ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_error ).

  ENDMETHOD.

  METHOD check_complex_params_false_4.
    DATA: ls_data   TYPE ts_data_1,
          ls_params TYPE ts_data_5.

    "when
    mo_cut->recursive_check_params(
      EXPORTING
        iv_name       = 'TEST_BO'
        iv_p_sub_name = 'TEST_ACTION'
        is_data       = ls_data
        is_params     = ls_params
      IMPORTING
        ev_error      = DATA(lv_error)
      ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_error ).

  ENDMETHOD.

ENDCLASS.

CLASS ltc_check_key_empty DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    METHODS setup.
    METHODS teardown.

    METHODS check_key_empty_is_empty FOR TESTING.
    METHODS check_key_empty_is_partial FOR TESTING.

    DATA mo_cut TYPE REF TO cl_ptf_rap_validate_tdo.

ENDCLASS.

CLASS ltc_check_key_empty IMPLEMENTATION.
  METHOD class_setup.

  ENDMETHOD.

  METHOD setup.
    DATA lt_step_data             TYPE cl_ptf_util=>gt_ptf_step_tab.

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW cl_ptf_rap_validate_tdo( lo_ptf_run ).

  ENDMETHOD.

  METHOD teardown.

  ENDMETHOD.

  METHOD class_teardown.

  ENDMETHOD.

  METHOD check_key_empty_is_empty.
    DATA ls_data TYPE STRUCTURE FOR KEY OF r_productionsupplyareatp.

    "when
    DATA(lv_key_empty) = mo_cut->check_key_empty(
      EXPORTING
        iv_name = 'R_PRODUCTIONSUPPLYAREATP'
        is_data = ls_data
    ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_key_empty ).

  ENDMETHOD.

  METHOD check_key_empty_is_partial.
    DATA ls_data TYPE STRUCTURE FOR KEY OF r_productionsupplyareatp.

    ls_data-plant = '0001'.

    "when
    DATA(lv_key_empty) = mo_cut->check_key_empty(
      EXPORTING
        iv_name = 'R_PRODUCTIONSUPPLYAREATP'
        is_data = ls_data
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_key_empty ).

  ENDMETHOD.

ENDCLASS.

CLASS ltc_check_key_fully_filled DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    METHODS setup.
    METHODS teardown.

    METHODS chk_key_fully_filled_is_empty FOR TESTING.
    METHODS chk_key_fully_filled_is_part FOR TESTING.
    METHODS chk_key_fully_filled_is_filled FOR TESTING.
    METHODS chk_key_fully_filled_is_pid FOR TESTING.
    METHODS chk_key_pkey_filled_pid_not FOR TESTING.

    DATA mo_cut TYPE REF TO cl_ptf_rap_validate_tdo.

ENDCLASS.

CLASS ltc_check_key_fully_filled IMPLEMENTATION.
  METHOD class_setup.

  ENDMETHOD.

  METHOD setup.
    DATA lt_step_data             TYPE cl_ptf_util=>gt_ptf_step_tab.

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW cl_ptf_rap_validate_tdo( lo_ptf_run ).

  ENDMETHOD.

  METHOD teardown.

  ENDMETHOD.

  METHOD class_teardown.

  ENDMETHOD.

  METHOD chk_key_fully_filled_is_empty.
    DATA ls_data TYPE STRUCTURE FOR KEY OF r_productionsupplyareatp.

    "when
    DATA(lv_key_fully_filled) = mo_cut->check_key_fully_filled(
      EXPORTING
        iv_name = 'R_PRODUCTIONSUPPLYAREATP'
        is_data = ls_data
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_key_fully_filled ).

  ENDMETHOD.

  METHOD chk_key_fully_filled_is_part.
    DATA ls_data TYPE STRUCTURE FOR KEY OF r_productionsupplyareatp.

    ls_data-plant = '0001'.

    "when
    DATA(lv_key_fully_filled) = mo_cut->check_key_fully_filled(
      EXPORTING
        iv_name = 'R_PRODUCTIONSUPPLYAREATP'
        is_data = ls_data
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_key_fully_filled ).

  ENDMETHOD.

  METHOD chk_key_fully_filled_is_filled.
    DATA ls_data TYPE STRUCTURE FOR KEY OF r_productionsupplyareatp.

    ls_data-productionsupplyarea = 'SUPPLY_ARE01'.
    ls_data-plant                = '0001'.

    "when
    DATA(lv_key_fully_filled) = mo_cut->check_key_fully_filled(
      EXPORTING
        iv_name = 'R_PRODUCTIONSUPPLYAREATP'
        is_data = ls_data
    ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_key_fully_filled ).

  ENDMETHOD.

  METHOD chk_key_fully_filled_is_pid.
    DATA ls_data TYPE STRUCTURE FOR READ RESULT r_salesordertp.

    "Create %pid.
    DATA(lo_system_uuid) = cl_uuid_factory=>create_system_uuid( ).
    TRY.
      DATA(lv_uuid_x16) = lo_system_uuid->create_uuid_x16( ).

    CATCH cx_uuid_error ##NO_HANDLER.
    ENDTRY.

    ls_data = VALUE #( %pid = lv_uuid_x16 ).

    "when
    DATA(lv_key_fully_filled) = mo_cut->check_key_fully_filled(
      EXPORTING
        iv_name = 'R_SALESORDERTP'
        is_data = ls_data
    ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_key_fully_filled ).

  ENDMETHOD.

  METHOD chk_key_pkey_filled_pid_not.
    DATA ls_data TYPE STRUCTURE FOR READ RESULT r_salesordertp.

    ls_data = VALUE #( salesorder = 'SALES_ORD' ).

    "when
    DATA(lv_key_fully_filled) = mo_cut->check_key_fully_filled(
      EXPORTING
        iv_name = 'R_SALESORDERTP'
        is_data = ls_data
    ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_key_fully_filled ).


  ENDMETHOD.

ENDCLASS.

CLASS ltc_check_data_instance DEFINITION DEFERRED.
CLASS cl_ptf_rap_validate_tdo DEFINITION LOCAL FRIENDS ltc_check_data_instance.

CLASS ltc_check_data_instance DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    TYPES ts_productionsupplyareatp     TYPE R_ProductionSupplyAreaTP.
    TYPES: BEGIN OF ts_initials,
            productionsupplyareaname    TYPE abap_bool,
           END OF ts_initials.
    TYPES ts_prodsupplyareatexttpfields TYPE R_ProductionSupplyAreaTextTp.
    TYPES: BEGIN OF ts_productionsupplyareatexttp.
            INCLUDE TYPE ts_prodsupplyareatexttpfields.
    TYPES:  _ProductionSupplyAreaText   TYPE abap_bool,
            _initials                   TYPE ts_initials,
           END OF ts_productionsupplyareatexttp.
    TYPES tt_productionsupplyareatexttp TYPE STANDARD TABLE OF ts_productionsupplyareatexttp WITH DEFAULT KEY. "KEY productionsupplyarea plant language.

    TYPES: BEGIN OF ts_test_data.
            INCLUDE TYPE ts_productionsupplyareatp.
    TYPES: r_productionsupplyareatexttp TYPE tt_productionsupplyareatexttp,
           _source  TYPE string.
    TYPES: END OF ts_test_data.

    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    CLASS-DATA mo_td TYPE REF TO if_cds_test_environment.

    METHODS setup.
    METHODS teardown.
    METHODS get_operations_read
      IMPORTING is_test_data       TYPE ts_test_data
      EXPORTING et_operations_read TYPE abp_behv_retrievals_tab.

    METHODS chck_tdc_no_initials_pos FOR TESTING.
    METHODS chck_tdc_no_initials_neg FOR TESTING.

    DATA mt_pvbe                 TYPE STANDARD TABLE OF pvbe.
    DATA mt_pvkt                 TYPE STANDARD TABLE OF pvkt.

ENDCLASS.

CLASS ltc_check_data_instance IMPLEMENTATION.
  METHOD class_setup.
    mo_td = cl_cds_test_environment=>create( i_for_entity               = 'R_ProductionSupplyAreaTP'
                                             i_select_base_dependencies = abap_on
                                             test_associations          = abap_on ).
    "Test double would be created for the CDS R_ProductionSupplyAreaTP. Executes once per test class.

  ENDMETHOD.

  METHOD setup.
    mo_td->clear_doubles( ).
    "Ensures fresh data for each test method. Executes once before each test method execution

  ENDMETHOD.

  METHOD teardown.

  ENDMETHOD.

  METHOD class_teardown.
    mo_td->destroy( ).
    "Destroys test environment & test doubles created as part of the test. Executes once per test class.

  ENDMETHOD.

  METHOD get_operations_read.
    DATA lr_instance                    TYPE REF TO data.
    DATA lo_ptf_rap_metadata            TYPE REF TO if_ptf_rap_metadata.
    DATA lo_structdescr                 TYPE REF TO cl_abap_structdescr.
    DATA lt_components                  TYPE abap_component_tab.
    DATA ls_operation_read              TYPE abp_behv_retrievals.

    FIELD-SYMBOLS <fs_productionsupplyareatext> TYPE ts_productionsupplyareatexttp.
    FIELD-SYMBOLS <fs_instances>    TYPE STANDARD TABLE.
    FIELD-SYMBOLS <fs_instance>     TYPE any.
    FIELD-SYMBOLS <fs_control>      TYPE any.
    FIELD-SYMBOLS <fs_flag_control> TYPE any.
    FIELD-SYMBOLS <fs_component>    TYPE abap_componentdescr.

    CLEAR et_operations_read.

    lo_ptf_rap_metadata = NEW cl_ptf_rap_metadata( ).

    CLEAR ls_operation_read.

    ls_operation_read-op = if_abap_behv=>op-r-read.

    ls_operation_read-entity_name = 'R_PRODUCTIONSUPPLYAREATP'.
    ls_operation_read-sub_name    = space.

    ls_operation_read-instances = cl_abap_behvdescr=>create_data(
                              p_name      = 'R_PRODUCTIONSUPPLYAREATP'
                              p_sub_name  = space
                              p_op        = if_abap_behv=>op-r-read
                              p_kind      = if_abap_behv=>typekind-import
                           ).

    ls_operation_read-full    = abap_on.

    ls_operation_read-results = cl_abap_behvdescr=>create_data(
                              p_name      = 'R_PRODUCTIONSUPPLYAREATP'
                              p_sub_name  = space
                              p_op        = if_abap_behv=>op-r-read
                              p_kind      = if_abap_behv=>typekind-result
                           ).

    ASSIGN ls_operation_read-instances->* TO <fs_instances>.
    CREATE DATA lr_instance LIKE LINE OF <fs_instances>.
    ASSIGN lr_instance->* TO <fs_instance>.

    <fs_instance> = CORRESPONDING #( is_test_data ).

    ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-control OF STRUCTURE <fs_instance> TO <fs_control>.
    IF sy-subrc = 0.
      lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_control> ).
      lt_components = lo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

      LOOP AT lt_components ASSIGNING <fs_component>.
        ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_control> TO <fs_flag_control>.
        IF sy-subrc = 0.
          <fs_flag_control> = cl_abap_behv=>flag_changed.

        ENDIF.

      ENDLOOP.

    ENDIF.

    APPEND <fs_instance> TO <fs_instances>.

    APPEND ls_operation_read TO et_operations_read.

    CLEAR ls_operation_read.

    ls_operation_read-op = if_abap_behv=>op-r-read_ba.

    ls_operation_read-entity_name = 'R_PRODUCTIONSUPPLYAREATP'.
    ls_operation_read-sub_name    = '_PRODUCTIONSUPPLYAREATEXT'.

    ls_operation_read-instances = cl_abap_behvdescr=>create_data(
                              p_name      = 'R_PRODUCTIONSUPPLYAREATP'
                              p_sub_name  = '_PRODUCTIONSUPPLYAREATEXT'
                              p_op        = if_abap_behv=>op-r-read_ba
                              p_kind      = if_abap_behv=>typekind-import
                           ).

    ls_operation_read-full    = abap_on.

    ls_operation_read-results = cl_abap_behvdescr=>create_data(
                              p_name      = 'R_PRODUCTIONSUPPLYAREATP'
                              p_sub_name  = '_PRODUCTIONSUPPLYAREATEXT'
                              p_op        = if_abap_behv=>op-r-read_ba
                              p_kind      = if_abap_behv=>typekind-result
                           ).

    ASSIGN ls_operation_read-instances->* TO <fs_instances>.
    CREATE DATA lr_instance LIKE LINE OF <fs_instances>.
    ASSIGN lr_instance->* TO <fs_instance>.

    READ TABLE is_test_data-r_productionsupplyareatexttp INDEX 1 ASSIGNING <fs_productionsupplyareatext>.
    IF sy-subrc = 0.
      <fs_instance> = CORRESPONDING #( <fs_productionsupplyareatext> ).

      ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-control OF STRUCTURE <fs_instance> TO <fs_control>.
      IF sy-subrc = 0.
        lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_control> ).
        lt_components = lo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

        LOOP AT lt_components ASSIGNING <fs_component>.
          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_control> TO <fs_flag_control>.
          IF sy-subrc = 0.
            <fs_flag_control> = cl_abap_behv=>flag_changed.

          ENDIF.

        ENDLOOP.

      ENDIF.

      APPEND <fs_instance> TO <fs_instances>.

    ENDIF.

    ASSIGN ls_operation_read-instances->* TO <fs_instances>.
    CREATE DATA lr_instance LIKE LINE OF <fs_instances>.
    ASSIGN lr_instance->* TO <fs_instance>.

    READ TABLE is_test_data-r_productionsupplyareatexttp INDEX 2 ASSIGNING <fs_productionsupplyareatext>.
    IF sy-subrc = 0.
      <fs_instance> = CORRESPONDING #( <fs_productionsupplyareatext> ).

      ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-control OF STRUCTURE <fs_instance> TO <fs_control>.
      IF sy-subrc = 0.
        lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_control> ).
        lt_components = lo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

        LOOP AT lt_components ASSIGNING <fs_component>.
          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_control> TO <fs_flag_control>.
          IF sy-subrc = 0.
            <fs_flag_control> = cl_abap_behv=>flag_changed.

          ENDIF.

        ENDLOOP.

      ENDIF.

      APPEND <fs_instance> TO <fs_instances>.

    ENDIF.

    APPEND ls_operation_read TO et_operations_read.

  ENDMETHOD.

  METHOD chck_tdc_no_initials_pos.
    DATA lo_cut             TYPE REF TO cl_ptf_rap_validate_tdo.
    DATA lt_operations_read TYPE abp_behv_retrievals_tab.
    DATA lt_step_data       TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA ls_test_data       TYPE ts_test_data.

    "Prepare and insert test data
    mt_pvbe = VALUE #( ( werks = '0001' prvbe = 'TEST_ARE01' lgort = '0001' ) ).
    mo_td->insert_test_data( i_data = mt_pvbe ).

    mt_pvkt = VALUE #( ( werks = '0001' prvbe = 'TEST_ARE01' spras = 'E' pvbtx = 'Test Area EN Changed with key in parent' )
      ( werks = '0001' prvbe = 'TEST_ARE01' spras = 'D' pvbtx = 'Test Area DE Changed with key in parent' ) ).
    mo_td->insert_test_data( i_data = mt_pvkt ).

    ls_test_data = VALUE #( productionsupplyarea = 'TEST_ARE01' storageLocation = '0001' plant = '0001'
      r_productionsupplyareatexttp = VALUE #( ( plant = '0001' productionSupplyArea = 'TEST_ARE01' language = 'D' productionsupplyareaname = 'Test Area DE Changed with key in parent' )
                                              ( plant = '0001' productionSupplyArea = 'TEST_ARE01' language = 'E' productionsupplyareaname = space ) )
      _source = 'TDC'
    ).

    me->get_operations_read(
      EXPORTING is_test_data       = ls_test_data
      IMPORTING et_operations_read = lt_operations_read ).

    READ ENTITIES
      OPERATIONS lt_operations_read
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->check_data_instance(
      EXPORTING
        is_test_data        = ls_test_data
        it_operations_read  = lt_operations_read
        iv_name             = 'R_PRODUCTIONSUPPLYAREATP'
        iv_entity_name      = 'R_PRODUCTIONSUPPLYAREATP'
      IMPORTING
        ev_error            = DATA(lv_error)
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_error ).

  ENDMETHOD.

  METHOD chck_tdc_no_initials_neg.
    DATA lo_cut             TYPE REF TO cl_ptf_rap_validate_tdo.
    DATA lt_operations_read TYPE abp_behv_retrievals_tab.
    DATA lt_step_data       TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA ls_test_data       TYPE ts_test_data.

    "Prepare and insert test data
    mt_pvbe = VALUE #( ( werks = '0001' prvbe = 'TEST_ARE01' lgort = '0001' ) ).
    mo_td->insert_test_data( i_data = mt_pvbe ).

    mt_pvkt = VALUE #( ( werks = '0001' prvbe = 'TEST_ARE01' spras = 'E' pvbtx = 'Test Area EN Changed with key in parent' )
      ( werks = '0001' prvbe = 'TEST_ARE01' spras = 'D' pvbtx = 'Test Area DE Changed with key in parent' ) ).
    mo_td->insert_test_data( i_data = mt_pvkt ).

    ls_test_data = VALUE #( productionsupplyarea = 'TEST_ARE01' storageLocation = '0001' plant = '0001'
      r_productionsupplyareatexttp = VALUE #( ( plant = '0001' productionSupplyArea = 'TEST_ARE01' language = 'D' productionsupplyareaname = 'Test Area DE Changed with key in parent' )
                                              ( plant = '0001' productionSupplyArea = 'TEST_ARE01' language = 'E' productionsupplyareaname = space _initials = VALUE #( productionsupplyareaname = abap_on ) ) )
      _source = 'TDC'
    ).

    me->get_operations_read(
      EXPORTING is_test_data       = ls_test_data
      IMPORTING et_operations_read = lt_operations_read ).

    READ ENTITIES
      OPERATIONS lt_operations_read
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->check_data_instance(
      EXPORTING
        is_test_data        = ls_test_data
        it_operations_read  = lt_operations_read
        iv_name             = 'R_PRODUCTIONSUPPLYAREATP'
        iv_entity_name      = 'R_PRODUCTIONSUPPLYAREATP'
      IMPORTING
        ev_error            = DATA(lv_error)
    ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_error ).

  ENDMETHOD.

ENDCLASS.
