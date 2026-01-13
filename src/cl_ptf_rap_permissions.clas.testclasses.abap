*"* use this source file for your ABAP unit test classes
* Local Test Class for method build_permissions
CLASS ltc_build_permissions DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    CLASS-DATA mo_td TYPE REF TO if_osql_test_environment.

    METHODS setup.
    METHODS teardown.

    METHODS prodsa_cr_perm_data FOR TESTING.

    DATA mt_t001w                TYPE STANDARD TABLE OF t001w.
    DATA mt_t001l                TYPE STANDARD TABLE OF t001l.

ENDCLASS.

CLASS ltc_build_permissions IMPLEMENTATION.
  METHOD class_setup.
    mo_td = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'PVBE' )
                                                                           ( 'PVKT' )
                                                                           ( 'T001W' )
                                                                           ( 'T001L' ) ) ).
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

  METHOD prodsa_cr_perm_data.
    DATA lo_cut         TYPE REF TO cl_ptf_rap_permissions.
    DATA lr_test_data   TYPE REF TO data.
    DATA lt_permissions TYPE abp_behv_permissions_tab.
    DATA lt_step_data   TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA ls_step_data   TYPE cl_ptf_util=>gt_ptf_step.
    DATA lv_json_file   TYPE string.

    FIELD-SYMBOLS <fs_test_data> TYPE any.

    "Prepare and insert test data
    mt_t001w = VALUE #( ( werks = '0002' ) ).
    mo_td->insert_test_data( i_data = mt_t001w ).

    mt_t001l = VALUE #( ( werks = '0002' lgort = '0003' ) ).
    mo_td->insert_test_data( i_data = mt_t001l ).

    lv_json_file = '{"_comment":"JSON Create Example for RAP BO R_PRODUCTIONSUPPLYAREATP"'
      && ',"ignore":"false","fields":[{"name":"ProductionSupplyArea","value":"TEST_ARECR"}' "If TEST_ARECR exists in DB then shortdump CX_CSP_ACT_INTERNAL is issued
      && ',{"name":"Plant","value":"0002"},{"name":"StorageLocation","value":"0003"}]'
      && ',"associations":[{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"false"'
      && ',"fields":[{"name":"Language","value":"EN"},{"name":"ProductionSupplyAreaName","value":"Test Area EN"}]}'
      && ',{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"false"'
      && ',"fields":[{"name":"Language","value":"DE"},{"name":"ProductionSupplyAreaName","value":"Test Area DE"}]}]}'.

    ls_step_data = VALUE #( bus_obj = 'R_PRODUCTIONSUPPLYAREATP' action = 'CREATE' step_number = 1 json_file = lv_json_file ).
    APPEND ls_step_data TO lt_step_data.

    TRY.
        cl_ptf_json=>deserialize(
          EXPORTING
            iv_entity = ls_step_data-bus_obj
            iv_action = ls_step_data-action
            iv_json   = ls_step_data-json_file
          IMPORTING
            er_data   = lr_test_data ).
      CATCH cx_ptf_json ##NO_HANDLER.
    ENDTRY.

    ASSIGN lr_test_data->* TO <fs_test_data>.

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->build_permissions(
      EXPORTING
        iv_op               = if_abap_behv=>op-m-create
        is_step_data        = ls_step_data
        is_test_data        = <fs_test_data>
      IMPORTING
        ev_error            = DATA(lv_error)
      CHANGING
        ct_permissions      = lt_permissions
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_error ).
    cl_abap_unit_assert=>assert_not_initial( act = lt_permissions[ entity_name = 'R_PRODUCTIONSUPPLYAREATP' ]-request->* ).
    cl_abap_unit_assert=>assert_not_initial( act = lt_permissions[ entity_name = 'R_PRODUCTIONSUPPLYAREATEXTTP' ]-request->* ).

  ENDMETHOD.

ENDCLASS.

* Local Test Class for method handle_permissions
CLASS ltc_handle_permissions DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    METHODS setup.
    METHODS teardown.

    METHODS handle_permissions_error FOR TESTING.

ENDCLASS.

CLASS ltc_handle_permissions IMPLEMENTATION.
  METHOD class_setup.
    "Test double would be created for the CDS R_ProductionSupplyAreaTP. Executes once per test class.

  ENDMETHOD.

  METHOD setup.
    "Ensures fresh data for each test method. Executes once before each test method execution

  ENDMETHOD.

  METHOD teardown.
    "Destroys test environment & test doubles created as part of the test. Executes once per test class.

  ENDMETHOD.

  METHOD class_teardown.
    "Destroys test environment & test doubles created as part of the test. Executes once per test class.

  ENDMETHOD.

  METHOD handle_permissions_error.
    DATA lo_cut         TYPE REF TO cl_ptf_rap_permissions.
    DATA lt_step_data   TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lt_components  TYPE abap_component_tab.
    DATA lt_failed      TYPE abp_behv_response_tab.

    FIELD-SYMBOLS <fs_entries> TYPE STANDARD TABLE.

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    APPEND INITIAL LINE TO lt_failed ASSIGNING FIELD-SYMBOL(<fs_failed>).

    DATA(lr_entries) = cl_abap_behvdescr=>create_data(
                          p_name  = 'R_PRODUCTIONSUPPLYAREATP'
                          p_op    = cl_abap_behvdescr=>op_failed
                          "p_kind = if_abap_behv=>typekind-request
                          "p_structure = abap_on
                       ).

    <fs_failed>-entries = lr_entries.

    ASSIGN <fs_failed>-entries->* TO <fs_entries>.
    APPEND INITIAL LINE TO <fs_entries>.

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->handle_permissions_error(
      EXPORTING
        it_failed           = lt_failed
        it_components       = lt_components
      IMPORTING
        ev_error            = DATA(lv_error)
    ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_error ).

  ENDMETHOD.

ENDCLASS.
