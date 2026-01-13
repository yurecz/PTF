* use this source file for your ABAP unit test classes

* Local Test Class for method check data
*CLASS ltc_check_data DEFINITION DEFERRED.
*CLASS cl_ptf_bo_rap_generic DEFINITION LOCAL FRIENDS ltc_check_data.

CLASS ltc_check_data DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    CLASS-DATA mo_td TYPE REF TO if_cds_test_environment.

    METHODS setup.
    METHODS teardown.

    METHODS prodsa_check_data_pos FOR TESTING.
    METHODS prodsa_check_data_pos_ignore_1 FOR TESTING.
    METHODS prodsa_check_data_pos_ignore_2 FOR TESTING.
    METHODS prodsa_check_data_pos_ign_extr FOR TESTING.
    METHODS prodsa_check_data_neg FOR TESTING.
    METHODS prodsa_check_data_neg_extr FOR TESTING.
    METHODS prodsa_chk_no_ops FOR TESTING.
    METHODS prodsa_check_data_empty FOR TESTING.

    DATA mt_pvbe                 TYPE STANDARD TABLE OF pvbe.
    DATA mt_pvkt                 TYPE STANDARD TABLE OF pvkt.

ENDCLASS.

CLASS ltc_check_data IMPLEMENTATION.
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

  METHOD prodsa_check_data_pos.
    DATA lo_cut         TYPE REF TO cl_ptf_bo_rap_generic.
    DATA lt_step_data   TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lv_json_file   TYPE string.

    "Prepare and insert test data
    mt_pvbe = VALUE #( ( werks = '0001' prvbe = 'TEST_ARE01' lgort = '0001' ) ).
    mo_td->insert_test_data( i_data = mt_pvbe ).

    mt_pvkt = VALUE #( ( werks = '0001' prvbe = 'TEST_ARE01' spras = 'E' pvbtx = 'Test Area EN Changed with key in parent' )
      ( werks = '0001' prvbe = 'TEST_ARE01' spras = 'D' pvbtx = 'Test Area DE Changed with key in parent' ) ).
    mo_td->insert_test_data( i_data = mt_pvkt ).

    lv_json_file = '{"_comment":"JSON Check Example for RAP BO R_PRODUCTIONSUPPLYAREATP with key in parent"'
      && ',"ignore":"false","fields":[{"name":"ProductionSupplyArea","value":"TEST_ARE01","operator":"="}'
      && ',{"name":"Plant","value":"0001","operator":"="},{"name":"StorageLocation","value":"0001","operator":"="}]'
      && ',"associations":[{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"false"'
      && ',"fields":[{"name":"Language","value":"EN","operator":"="}'
      && ',{"name":"ProductionSupplyAreaName","value":"Test Area EN Changed with key in parent","operator":"="}]}'
      && ',{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"false"'
      && ',"fields":[{"name":"Language","value":"DE","operator":"="}'
      && ',{"name":"ProductionSupplyAreaName","value":"Test Area DE Changed with key in parent","operator":"="}]}]}'.

    lt_step_data = VALUE #( ( bus_obj = 'R_PRODUCTIONSUPPLYAREATP' action = 'CHECK' step_number = 1 json_file = lv_json_file ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->check(
      EXPORTING
        iv_step_number      = 1
      IMPORTING
        ev_document_id      = DATA(lt_document_id)
        ev_execution_status = DATA(lv_execution_status)
        ev_check_status     = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lt_document_id[ 1 ] exp = |TEST_ARE01{ cl_ptf_util=>gc_key_field_delimiter }0001| ).
    cl_abap_unit_assert=>assert_true( act = lv_execution_status ).
    cl_abap_unit_assert=>assert_true( act = lv_check_status ).

  ENDMETHOD.

  METHOD prodsa_check_data_pos_ignore_1.
    DATA lo_cut         TYPE REF TO cl_ptf_bo_rap_generic.
    DATA lt_step_data   TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lv_json_file   TYPE string.

    "Prepare and insert test data
    mt_pvbe = VALUE #( ( werks = '0001' prvbe = 'TEST_ARE01' lgort = '0001' ) ).
    mo_td->insert_test_data( i_data = mt_pvbe ).

    mt_pvkt = VALUE #( ( werks = '0001' prvbe = 'TEST_ARE01' spras = 'E' pvbtx = 'Test Area EN Changed with key in parent' ) ).
    mo_td->insert_test_data( i_data = mt_pvkt ).

    lv_json_file = '{"_comment":"JSON Check Example for RAP BO R_PRODUCTIONSUPPLYAREATP with key in parent"'
      && ',"ignore":"false","fields":[{"name":"ProductionSupplyArea","value":"TEST_ARE01","operator":"="}'
      && ',{"name":"Plant","value":"0001","operator":"="},{"name":"StorageLocation","value":"0001","operator":"="}]'
      && ',"associations":[{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"false"'
      && ',"fields":[{"name":"Language","value":"EN","operator":"="}'
      && ',{"name":"ProductionSupplyAreaName","value":"Test Area EN Changed with key in parent","operator":"="}]}'
      && ',{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"true"'
      && ',"fields":[{"name":"Language","value":"DE","operator":"="}'
      && ',{"name":"ProductionSupplyAreaName","value":"Test Area DE Changed with key in parent","operator":"="}]}]}'.

    lt_step_data = VALUE #( ( bus_obj = 'R_PRODUCTIONSUPPLYAREATP' action = 'CHECK' step_number = 1 json_file = lv_json_file ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->check(
      EXPORTING
        iv_step_number      = 1
      IMPORTING
        ev_document_id      = DATA(lt_document_id)
        ev_execution_status = DATA(lv_execution_status)
        ev_check_status     = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lt_document_id[ 1 ] exp = |TEST_ARE01{ cl_ptf_util=>gc_key_field_delimiter }0001| ).
    cl_abap_unit_assert=>assert_true( act = lv_execution_status ).
    cl_abap_unit_assert=>assert_true( act = lv_check_status ).

  ENDMETHOD.

  METHOD prodsa_check_data_pos_ignore_2.
    DATA lo_cut         TYPE REF TO cl_ptf_bo_rap_generic.
    DATA lt_step_data   TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lv_json_file   TYPE string.

    "Prepare and insert test data
    mt_pvbe = VALUE #( ( werks = '0001' prvbe = 'TEST_ARE01' lgort = '0001' ) ).
    mo_td->insert_test_data( i_data = mt_pvbe ).

    mt_pvkt = VALUE #( ( werks = '0001' prvbe = 'TEST_ARE01' spras = 'D' pvbtx = 'Test Area DE Changed with key in parent' ) ).
    mo_td->insert_test_data( i_data = mt_pvkt ).

    lv_json_file = '{"_comment":"JSON Check Example for RAP BO R_PRODUCTIONSUPPLYAREATP with key in parent"'
      && ',"ignore":"false","fields":[{"name":"ProductionSupplyArea","value":"TEST_ARE01","operator":"="}'
      && ',{"name":"Plant","value":"0001","operator":"="},{"name":"StorageLocation","value":"0001","operator":"="}]'
      && ',"associations":[{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"true"'
      && ',"fields":[{"name":"Language","value":"EN","operator":"="}'
      && ',{"name":"ProductionSupplyAreaName","value":"Test Area EN Changed with key in parent","operator":"="}]}'
      && ',{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"false"'
      && ',"fields":[{"name":"Language","value":"DE","operator":"="}'
      && ',{"name":"ProductionSupplyAreaName","value":"Test Area DE Changed with key in parent","operator":"="}]}]}'.

    lt_step_data = VALUE #( ( bus_obj = 'R_PRODUCTIONSUPPLYAREATP' action = 'CHECK' step_number = 1 json_file = lv_json_file ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->check(
      EXPORTING
        iv_step_number      = 1
      IMPORTING
        ev_document_id      = DATA(lt_document_id)
        ev_execution_status = DATA(lv_execution_status)
        ev_check_status     = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lt_document_id[ 1 ] exp = |TEST_ARE01{ cl_ptf_util=>gc_key_field_delimiter }0001| ).
    cl_abap_unit_assert=>assert_true( act = lv_execution_status ).
    cl_abap_unit_assert=>assert_true( act = lv_check_status ).

  ENDMETHOD.

  METHOD prodsa_check_data_pos_ign_extr.
    DATA lo_cut         TYPE REF TO cl_ptf_bo_rap_generic.
    DATA lt_step_data   TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lv_json_file   TYPE string.

    "Prepare and insert test data
    mt_pvbe = VALUE #( ( werks = '0001' prvbe = 'TEST_ARE01' lgort = '0001' ) ).
    mo_td->insert_test_data( i_data = mt_pvbe ).

    mt_pvkt = VALUE #( ( werks = '0001' prvbe = 'TEST_ARE01' spras = 'E' pvbtx = 'Test Area EN Changed with key in parent' )
      ( werks = '0001' prvbe = 'TEST_ARE01' spras = 'D' pvbtx = 'Test Area DE Changed with key in parent' ) ).
    mo_td->insert_test_data( i_data = mt_pvkt ).

    lv_json_file = '{"_comment":"JSON Check Example for RAP BO R_PRODUCTIONSUPPLYAREATP with key in parent"'
      && ',"ignore":"false","fields":[{"name":"ProductionSupplyArea","value":"TEST_ARE01","operator":"="}'
      && ',{"name":"Plant","value":"0001","operator":"="},{"name":"StorageLocation","value":"0001","operator":"="}]'
      && ',"associations":[{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"false"'
      && ',"fields":[{"name":"Language","value":"EN","operator":"="}'
      && ',{"name":"ProductionSupplyAreaName","value":"Test Area EN Changed with key in parent","operator":"="}]}'
      && ',{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"true"'
      && ',"fields":[{"name":"Language","value":"FR","operator":"="}'
      && ',{"name":"ProductionSupplyAreaName","value":"Test Area FR Changed with key in parent","operator":"="}]}'
      && ',{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"false"'
      && ',"fields":[{"name":"Language","value":"DE","operator":"="}'
      && ',{"name":"ProductionSupplyAreaName","value":"Test Area DE Changed with key in parent","operator":"="}]}]}'.

    lt_step_data = VALUE #( ( bus_obj = 'R_PRODUCTIONSUPPLYAREATP' action = 'CHECK' step_number = 1 json_file = lv_json_file ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->check(
      EXPORTING
        iv_step_number      = 1
      IMPORTING
        ev_document_id      = DATA(lt_document_id)
        ev_execution_status = DATA(lv_execution_status)
        ev_check_status     = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lt_document_id[ 1 ] exp = |TEST_ARE01{ cl_ptf_util=>gc_key_field_delimiter }0001| ).
    cl_abap_unit_assert=>assert_true( act = lv_execution_status ).
    cl_abap_unit_assert=>assert_true( act = lv_check_status ).

  ENDMETHOD.

  METHOD prodsa_check_data_neg.
    DATA lo_cut         TYPE REF TO cl_ptf_bo_rap_generic.
    DATA lt_step_data   TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lv_json_file   TYPE string.

    "Prepare and insert test data
    mt_pvbe = VALUE #( ( werks = '0001' prvbe = 'TEST_ARE01' lgort = '0001' ) ).
    mo_td->insert_test_data( i_data = mt_pvbe ).

    mt_pvkt = VALUE #( ( werks = '0001' prvbe = 'TEST_ARE01' spras = 'E' pvbtx = 'Test Area EN Changed with key in parent' )
      ( werks = '0001' prvbe = 'TEST_ARE01' spras = 'D' pvbtx = 'Test Area DE Changed with key in parent' ) ).
    mo_td->insert_test_data( i_data = mt_pvkt ).

    lv_json_file = '{"_comment":"JSON Check Example for RAP BO R_PRODUCTIONSUPPLYAREATP with key in parent"'
      && ',"ignore":"false","fields":[{"name":"ProductionSupplyArea","value":"TEST_ARE01","operator":"="}'
      && ',{"name":"Plant","value":"0001","operator":"="},{"name":"StorageLocation","value":"0001","operator":"="}]'
      && ',"associations":[{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"false"'
      && ',"fields":[{"name":"Language","value":"EN","operator":"="}'
      && ',{"name":"ProductionSupplyAreaName","value":"Test Area EN Changed with key in parent","operator":"="}]}'
      && ',{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"false"'
      && ',"fields":[{"name":"Language","value":"DE","operator":"="}'
      && ',{"name":"ProductionSupplyAreaName","value":"Test Area DE Changed with key in child","operator":"="}]}]}'.

    lt_step_data = VALUE #( ( bus_obj = 'R_PRODUCTIONSUPPLYAREATP' action = 'CHECK' step_number = 1 json_file = lv_json_file ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->check(
      EXPORTING
        iv_step_number      = 1
      IMPORTING
        ev_document_id      = DATA(lt_document_id)
        ev_execution_status = DATA(lv_execution_status)
        ev_check_status     = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lt_document_id[ 1 ] exp = |TEST_ARE01{ cl_ptf_util=>gc_key_field_delimiter }0001| ).
    cl_abap_unit_assert=>assert_false( act = lv_execution_status ).
    cl_abap_unit_assert=>assert_false( act = lv_check_status ).

  ENDMETHOD.

  METHOD prodsa_check_data_neg_extr.
    DATA lo_cut         TYPE REF TO cl_ptf_bo_rap_generic.
    DATA lt_step_data   TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lv_json_file   TYPE string.

    "Prepare and insert test data
    mt_pvbe = VALUE #( ( werks = '0001' prvbe = 'TEST_ARE01' lgort = '0001' ) ).
    mo_td->insert_test_data( i_data = mt_pvbe ).

    mt_pvkt = VALUE #( ( werks = '0001' prvbe = 'TEST_ARE01' spras = 'E' pvbtx = 'Test Area EN Changed with key in parent' )
      ( werks = '0001' prvbe = 'TEST_ARE01' spras = 'D' pvbtx = 'Test Area DE Changed with key in parent' ) ).
    mo_td->insert_test_data( i_data = mt_pvkt ).

    lv_json_file = '{"_comment":"JSON Check Example for RAP BO R_PRODUCTIONSUPPLYAREATP with key in parent"'
      && ',"ignore":"false","fields":[{"name":"ProductionSupplyArea","value":"TEST_ARE01","operator":"="}'
      && ',{"name":"Plant","value":"0001","operator":"="},{"name":"StorageLocation","value":"0001","operator":"="}]'
      && ',"associations":[{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"false"'
      && ',"fields":[{"name":"Language","value":"EN","operator":"="}'
      && ',{"name":"ProductionSupplyAreaName","value":"Test Area EN Changed with key in parent","operator":"="}]}'
      && ',{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"false"'
      && ',"fields":[{"name":"Language","value":"FR","operator":"="}'
      && ',{"name":"ProductionSupplyAreaName","value":"Test Area FR Changed with key in parent","operator":"="}]}'
      && ',{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"false"'
      && ',"fields":[{"name":"Language","value":"DE","operator":"="}'
      && ',{"name":"ProductionSupplyAreaName","value":"Test Area DE Changed with key in parent","operator":"="}]}]}'.

    lt_step_data = VALUE #( ( bus_obj = 'R_PRODUCTIONSUPPLYAREATP' action = 'CHECK' step_number = 1 json_file = lv_json_file ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->check(
      EXPORTING
        iv_step_number      = 1
      IMPORTING
        ev_document_id      = DATA(lt_document_id)
        ev_execution_status = DATA(lv_execution_status)
        ev_check_status     = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lt_document_id[ 1 ] exp = |TEST_ARE01{ cl_ptf_util=>gc_key_field_delimiter }0001| ).
    cl_abap_unit_assert=>assert_false( act = lv_execution_status ).
    cl_abap_unit_assert=>assert_false( act = lv_check_status ).

  ENDMETHOD.

  METHOD prodsa_chk_no_ops.
    DATA lo_cut TYPE REF TO cl_ptf_bo_rap_generic.
    DATA lt_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lv_json_file TYPE string.

    "Prepare and insert test data
    mt_pvbe = VALUE #( ( werks = '0001' prvbe = 'TEST_ARECK' lgort = '0001' ) ).
    mo_td->insert_test_data( i_data = mt_pvbe ).

    mt_pvkt = VALUE #( ( werks = '0001' prvbe = 'TEST_ARECK' spras = 'E' pvbtx = 'Test Area EN Changed with key in parent' )
      ( werks = '0001' prvbe = 'TEST_ARECK' spras = 'D' pvbtx = 'Test Area DE Changed with key in parent' ) ).
    mo_td->insert_test_data( i_data = mt_pvkt ).

    lv_json_file = '{"_comment":"JSON Check Example for RAP BO R_PRODUCTIONSUPPLYAREATP with key in parent"'
      && ',"ignore":"false","fields":[{"name":"ProductionSupplyArea","value":"TEST_ARECK"}'
      && ',{"name":"Plant","value":"0001"},{"name":"StorageLocation","value":"0001"}]'
      && ',"associations":[{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"false"'
      && ',"fields":[{"name":"Language","value":"EN"}'
      && ',{"name":"ProductionSupplyAreaName","value":"Test Area EN Changed with key in parent"}]}'
      && ',{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"false"'
      && ',"fields":[{"name":"Language","value":"DE"}'
      && ',{"name":"ProductionSupplyAreaName","value":"Test Area DE Changed with key in parent"}]}]}'.

    lt_step_data = VALUE #( ( bus_obj = 'R_PRODUCTIONSUPPLYAREATP' action = 'CHECK' step_number = 1 json_file = lv_json_file ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->check(
      EXPORTING
        iv_step_number      = 1
      IMPORTING
        ev_document_id      = DATA(lt_document_id)
        ev_execution_status = DATA(lv_execution_status)
        ev_check_status     = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lt_document_id[ 1 ] exp = |TEST_ARECK{ cl_ptf_util=>gc_key_field_delimiter }0001| ).
    cl_abap_unit_assert=>assert_true( act = lv_execution_status ).
    cl_abap_unit_assert=>assert_true( act = lv_check_status ).

  ENDMETHOD.

  METHOD prodsa_check_data_empty.
    DATA lo_cut         TYPE REF TO cl_ptf_bo_rap_generic.
    DATA lt_step_data   TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lv_json_file   TYPE string.

    lv_json_file = '{"_comment":"JSON Check Example for RAP BO R_PRODUCTIONSUPPLYAREATP with key in parent"'
      && ',"ignore":"false","fields":[{"name":"ProductionSupplyArea","value":"TEST_ARE01","operator":"="}'
      && ',{"name":"Plant","value":"0001","operator":"="},{"name":"StorageLocation","value":"0001","operator":"="}]'
      && ',"associations":[{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"false"'
      && ',"fields":[{"name":"Language","value":"EN","operator":"="}'
      && ',{"name":"ProductionSupplyAreaName","value":"Test Area EN Changed with key in parent","operator":"="}]}'
      && ',{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"false"'
      && ',"fields":[{"name":"Language","value":"DE","operator":"="}'
      && ',{"name":"ProductionSupplyAreaName","value":"Test Area DE Changed with key in parent","operator":"="}]}]}'.

    lt_step_data = VALUE #( ( bus_obj = 'R_PRODUCTIONSUPPLYAREATP' action = 'CHECK' step_number = 1 json_file = lv_json_file ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->check(
      EXPORTING
        iv_step_number      = 1
      IMPORTING
        "ev_document_id      = DATA(lt_document_id)
        ev_execution_status = DATA(lv_execution_status)
        ev_check_status     = DATA(lv_check_status)
    ).

    "then
*    cl_abap_unit_assert=>assert_initial( act = lt_document_id ).
    cl_abap_unit_assert=>assert_false( act = lv_execution_status ).
    cl_abap_unit_assert=>assert_false( act = lv_check_status ).

  ENDMETHOD.

ENDCLASS.

* Local Test Class for method check if exists
*CLASS ltc_check_if_exists_data DEFINITION DEFERRED.
*CLASS cl_ptf_bo_rap_generic DEFINITION LOCAL FRIENDS ltc_check_if_exists_data.

CLASS ltc_check_if_exists_data DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    CLASS-DATA mo_td TYPE REF TO if_cds_test_environment.

    METHODS setup.
    METHODS teardown.

    METHODS prodsa_check_exists_data FOR TESTING.
    METHODS prodsa_invalid_pos FOR TESTING.
    METHODS prodsa_invalid_neg FOR TESTING.
    METHODS prodsa_check_exists_empty FOR TESTING.

    DATA mt_pvbe                 TYPE STANDARD TABLE OF pvbe.
    DATA mt_pvkt                 TYPE STANDARD TABLE OF pvkt.

ENDCLASS.

CLASS ltc_check_if_exists_data IMPLEMENTATION.
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

  METHOD prodsa_check_exists_data.
    DATA lo_cut TYPE REF TO cl_ptf_bo_rap_generic.
    DATA lt_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lv_json_file TYPE string.

    "Prepare and insert test data
    mt_pvbe = VALUE #( ( werks = '0001' prvbe = 'TEST_ARECE' lgort = '0001' ) ).
    mo_td->insert_test_data( i_data = mt_pvbe ).

    mt_pvkt = VALUE #( ( werks = '0001' prvbe = 'TEST_ARECE' spras = 'E' pvbtx = 'Test Area EN Changed with key in parent' )
      ( werks = '0001' prvbe = 'TEST_ARECE' spras = 'D' pvbtx = 'Test Area DE Changed with key in parent' ) ).
    mo_td->insert_test_data( i_data = mt_pvkt ).

    lv_json_file = '{"_comment":"JSON Check if Exists Example for RAP BO R_PRODUCTIONSUPPLYAREATP with key in parent"'
      && ',"ignore":"false","fields":[{"name":"ProductionSupplyArea","value":"TEST_ARECE"},{"name":"Plant","value":"0001"}]'
      && ',"associations":[{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"false"'
      && ',"fields":[{"name":"Language","value":"EN"}]},'
      && '{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"false"'
      && ',"fields":[{"name":"Language","value":"DE"}]}]}'.

    lt_step_data = VALUE #( ( bus_obj = 'R_PRODUCTIONSUPPLYAREATP' action = 'CHECK_IF_EXISTS' step_number = 1 json_file = lv_json_file ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->check_if_exists(
      EXPORTING
        iv_step_number      = 1
      IMPORTING
        ev_document_id      = DATA(lt_document_id)
        ev_execution_status = DATA(lv_execution_status)
        ev_check_status     = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lt_document_id[ 1 ] exp = |TEST_ARECE{ cl_ptf_util=>gc_key_field_delimiter }0001| ).
    cl_abap_unit_assert=>assert_true( act = lv_execution_status ).
    cl_abap_unit_assert=>assert_true( act = lv_check_status ).

  ENDMETHOD.

  METHOD prodsa_invalid_pos.
    DATA lo_cut TYPE REF TO cl_ptf_bo_rap_generic.
    DATA lt_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lv_json_file TYPE string.

    "Prepare and insert test data
    mt_pvbe = VALUE #( ( werks = '0001' prvbe = 'TEST_ARECE' lgort = '0001' ) ).
    mo_td->insert_test_data( i_data = mt_pvbe ).

    mt_pvkt = VALUE #( ( werks = '0001' prvbe = 'TEST_ARECE' spras = 'E' pvbtx = 'Test Area EN Changed with key in parent' )
      ( werks = '0001' prvbe = 'TEST_ARECE' spras = 'D' pvbtx = 'Test Area DE Changed with key in parent' ) ).
    mo_td->insert_test_data( i_data = mt_pvkt ).

    lv_json_file = '{"_comment":"JSON Check if Exists Example for RAP BO R_PRODUCTIONSUPPLYAREATP with key in parent"'
      && ',"ignore":"false","fields":[{"name":"ProductionSupplyArea","value":"TEST_ARECE"},{"name":"Plant","value":"0001"}]'
      && ',"associations":[{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"false"'
      && ',"fields":[{"name":"Language","value":"EN"}]},'
      && '{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"false","isExisting":false'
      && ',"fields":[{"name":"Language","value":"FR"}]}]}'.

    lt_step_data = VALUE #( ( bus_obj = 'R_PRODUCTIONSUPPLYAREATP' action = 'CHECK_IF_EXISTS' step_number = 1 json_file = lv_json_file ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->check_if_exists(
      EXPORTING
        iv_step_number      = 1
      IMPORTING
        ev_document_id      = DATA(lt_document_id)
        ev_execution_status = DATA(lv_execution_status)
        ev_check_status     = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lt_document_id[ 1 ] exp = |TEST_ARECE{ cl_ptf_util=>gc_key_field_delimiter }0001| ).
    cl_abap_unit_assert=>assert_true( act = lv_execution_status ).
    cl_abap_unit_assert=>assert_true( act = lv_check_status ).

  ENDMETHOD.

  METHOD prodsa_invalid_neg.
    DATA lo_cut TYPE REF TO cl_ptf_bo_rap_generic.
    DATA lt_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lv_json_file TYPE string.

    "Prepare and insert test data
    mt_pvbe = VALUE #( ( werks = '0001' prvbe = 'TEST_ARECE' lgort = '0001' ) ).
    mo_td->insert_test_data( i_data = mt_pvbe ).

    mt_pvkt = VALUE #( ( werks = '0001' prvbe = 'TEST_ARECE' spras = 'E' pvbtx = 'Test Area EN Changed with key in parent' )
      ( werks = '0001' prvbe = 'TEST_ARECE' spras = 'D' pvbtx = 'Test Area DE Changed with key in parent' ) ).
    mo_td->insert_test_data( i_data = mt_pvkt ).

    lv_json_file = '{"_comment":"JSON Check if Exists Example for RAP BO R_PRODUCTIONSUPPLYAREATP with key in parent"'
      && ',"ignore":"false","fields":[{"name":"ProductionSupplyArea","value":"TEST_ARECE"},{"name":"Plant","value":"0001"}]'
      && ',"associations":[{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"false"'
      && ',"fields":[{"name":"Language","value":"EN"}]},'
      && '{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"false","isExisting":true'
      && ',"fields":[{"name":"Language","value":"FR"}]}]}'.

    lt_step_data = VALUE #( ( bus_obj = 'R_PRODUCTIONSUPPLYAREATP' action = 'CHECK_IF_EXISTS' step_number = 1 json_file = lv_json_file ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->check_if_exists(
      EXPORTING
        iv_step_number      = 1
      IMPORTING
        ev_document_id      = DATA(lt_document_id)
        ev_execution_status = DATA(lv_execution_status)
        ev_check_status     = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lt_document_id[ 1 ] exp = |TEST_ARECE{ cl_ptf_util=>gc_key_field_delimiter }0001| ).
    cl_abap_unit_assert=>assert_false( act = lv_execution_status ).
    cl_abap_unit_assert=>assert_false( act = lv_check_status ).

  ENDMETHOD.

  METHOD prodsa_check_exists_empty.
    DATA lo_cut TYPE REF TO cl_ptf_bo_rap_generic.
    DATA lt_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lv_json_file TYPE string.

    lv_json_file = '{"_comment":"JSON Check if Exists Example for RAP BO R_PRODUCTIONSUPPLYAREATP with key in parent"'
      && ',"ignore":"false","fields":[{"name":"ProductionSupplyArea","value":"TEST_ARECE"},{"name":"Plant","value":"0001"}]'
      && ',"associations":[{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"false"'
      && ',"fields":[{"name":"Language","value":"EN"}]},'
      && '{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT","ignore":"false"'
      && ',"fields":[{"name":"Language","value":"DE"}]}]}'.

    lt_step_data = VALUE #( ( bus_obj = 'R_PRODUCTIONSUPPLYAREATP' action = 'CHECK_IF_EXISTS' step_number = 1 json_file = lv_json_file ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->check_if_exists(
      EXPORTING
        iv_step_number      = 1
      IMPORTING
        "ev_document_id      = DATA(lt_document_id)
        ev_execution_status = DATA(lv_execution_status)
        ev_check_status     = DATA(lv_check_status)
    ).

    "then
*    cl_abap_unit_assert=>assert_initial( act = lt_document_id ).
    cl_abap_unit_assert=>assert_false( act = lv_execution_status ).
    cl_abap_unit_assert=>assert_false( act = lv_check_status ).

  ENDMETHOD.

ENDCLASS.

* Local Test Class for method check if exists pid
CLASS ltc_check_if_exists_pid DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    METHODS setup.
    METHODS teardown.

    METHODS configure_eml_td IMPORTING iv_pid TYPE sysuuid_x16.

    METHODS billing_doc FOR TESTING.

    CLASS-DATA mo_environment TYPE REF TO if_botd_mockemlapi_bo_test_env.

ENDCLASS.

CLASS ltc_check_if_exists_pid IMPLEMENTATION.
  METHOD class_setup.
    "Create Environment configuration for creating test doubles with API support for mocking EML
    DATA(lo_env_config) = cl_botd_mockemlapi_bo_test_env=>prepare_environment_config(
                                                 )->set_bdef_dependencies( bdef_dependencies = VALUE #( ( 'R_BILLINGDOCUMENTTP' ) ) ).

    "Create the environment with test doubles for the mentioned BDEFs in the list
    mo_environment = cl_botd_mockemlapi_bo_test_env=>create( environment_config = lo_env_config ). "Returns an environment instance which holds the doubles for the BDEFs in the list

  ENDMETHOD.

  METHOD setup.
    "Clears the configurations done via API for all EML statements for all the doubles
    mo_environment->clear_doubles(  ).

  ENDMETHOD.

  METHOD teardown.

  ENDMETHOD.

  METHOD class_teardown.
    "Destroy all the created doubles at the end of the test execution
    mo_environment->destroy(  ).

  ENDMETHOD.

  METHOD configure_eml_td.
    "Test Goal: Isolate the read EML with read operation in CUT (Code under Test) and configure responses via API.
    "CUT has Read operation which should pass. Hence configure result.

    "Step 1: Setup test data instances for all operations on all entities in Read EML (Here only read ).
    "Step 2: Define and set up the response structures to be returned for READ EML in CUT
    "Step 3: Create input and output configurations for the READ EML.
    "Step 4: Configure the READ EML via configure_call API on the double.

    "Step 1: Setup test data instances for read operation in READ EML.
    "For read on travel
    DATA lt_bill_header_instances TYPE TABLE FOR READ IMPORT r_billingdocumenttp.
    lt_bill_header_instances = VALUE #( ( %pid = iv_pid ) ).

    DATA lt_bill_item_instances TYPE TABLE FOR READ IMPORT r_billingdocumenttp\_item.
    lt_bill_item_instances = VALUE #( ( %pid = iv_pid ) ).

    "Step 2: Define and set up the response structures to be returned for READ EML in CUT
    "Create the result structure.
    DATA lt_bill_header_result TYPE TABLE FOR READ RESULT r_billingdocumenttp.
    lt_bill_header_result = VALUE #( ( %pid = iv_pid ) ).

    DATA lt_bill_item_result TYPE TABLE FOR READ RESULT r_billingdocumenttp\_item.
    lt_bill_item_result = VALUE #( ( %pid = iv_pid billingdocumentitem = '000020' ) ).

    "Step 3: Build input and output configurations for the READ EML.
    "a. Get input/output configuration builders for READ EML
    DATA(lo_in_config_builder_4_read) = cl_botd_mockemlapi_bldrfactory=>get_input_config_builder( )->for_read(  ).
    DATA(lo_out_config_builder_4_read) = cl_botd_mockemlapi_bldrfactory=>get_output_config_builder( )->for_read( ).

    "b. Create input for all entity parts
    "For billing header entityty
    DATA(lo_eml_bil_input) = lo_in_config_builder_4_read->build_entity_part( 'R_BillingDocumentTP'   "can accept the entity name/alias name
                                                       )->set_instances_for_read( lt_bill_header_instances
                                                       )->set_instances_for_read_ba( lt_bill_item_instances ).

    "c. Input configuration for EML
    DATA(lo_input) = lo_in_config_builder_4_read->build_input_for_eml(  )->add_entity_part( lo_eml_bil_input ).

    "d. Output configuration for EML
    DATA(lo_output) = lo_out_config_builder_4_read->build_output_for_eml( )->set_result_for_read( lt_bill_header_result
                                                                          )->set_result_for_read_ba( source_entity_name = 'R_BillingDocumentTP' assoc_name = '_ITEM' result = lt_bill_item_result ).

    "Step 4: Configure the Read EML via configure_call API on the double.
    DATA(lo_double) =  mo_environment->get_test_double( 'R_BillingDocumentTP' ).
    lo_double->configure_call(  )->for_read(  )->when_input( lo_input )->then_set_output( lo_output ).

  ENDMETHOD.

  METHOD billing_doc.
    DATA lo_cut       TYPE REF TO cl_ptf_bo_rap_generic.
    DATA lt_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lv_json_file TYPE string.

    "Create %pid.
    DATA(lo_system_uuid) = cl_uuid_factory=>create_system_uuid( ).
    TRY.
        DATA(lv_uuid_x16) = lo_system_uuid->create_uuid_x16( ).

      CATCH cx_uuid_error ##NO_HANDLER.
    ENDTRY.

    me->configure_eml_td(
      EXPORTING
        iv_pid = lv_uuid_x16
    ).

    lv_json_file = '{"_comment":"JSON Check if Exists Example for RAP BO R_BillingDocumentTP"'
                   && ',"associations":['
                   && '{"childEntityName":"R_BillingDocumentItemTP","assocName":"_ITEM","isExisting":"true"'
                   && ',"fields":['
                   && '{"name":"BILLINGDOCUMENTITEM","value":"000020"}'
                   && ']}'
                   && ']}'.

    lt_step_data = VALUE #( ( bus_obj = 'R_BILLINGDOCUMENTTP' action = 'CREATE' step_number = 1 document_id = VALUE #( ( CONV #( lv_uuid_x16 ) ) ) is_pid = abap_on )
      ( bus_obj = 'R_BILLINGDOCUMENTTP' action = 'CHECK_IF_EXISTS' step_number = 2 json_file = lv_json_file reference_step = VALUE #( ( 1 ) ) ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->check_if_exists(
      EXPORTING
        iv_step_number      = 2
      IMPORTING
        "ev_document_id      = DATA(lt_document_id)
        ev_execution_status = DATA(lv_execution_status)
        ev_check_status     = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_execution_status ).
    cl_abap_unit_assert=>assert_true( act = lv_check_status ).

  ENDMETHOD.

ENDCLASS.

* Local Test Class for method create
*CLASS ltc_create_data DEFINITION DEFERRED.

CLASS ltc_create_data DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    CLASS-DATA mo_td TYPE REF TO if_osql_test_environment.

    METHODS setup.
    METHODS teardown.

    METHODS prodsa_cr_data FOR TESTING.

    DATA mt_t001w                TYPE STANDARD TABLE OF t001w.
    DATA mt_t001l                TYPE STANDARD TABLE OF t001l.

ENDCLASS.

CLASS ltc_create_data IMPLEMENTATION.
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

  METHOD prodsa_cr_data.
    DATA lo_cut TYPE REF TO cl_ptf_bo_rap_generic.
    DATA lt_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lv_json_file TYPE string.

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

    lt_step_data = VALUE #( ( bus_obj = 'R_PRODUCTIONSUPPLYAREATP' action = 'CREATE' step_number = 1 json_file = lv_json_file ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->create(
      EXPORTING
        iv_step_number = 1
      IMPORTING
        ev_document_id      = DATA(lt_document_id)
        ev_execution_status = DATA(lv_execution_status)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lt_document_id[ 1 ] exp = |TEST_ARECR{ cl_ptf_util=>gc_key_field_delimiter }0002| ).
    cl_abap_unit_assert=>assert_true( act = lv_execution_status ).

  ENDMETHOD.

ENDCLASS.

* Local Test Class for method Change
*CLASS ltc_change_data DEFINITION DEFERRED.

CLASS ltc_change_data DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    CLASS-DATA mo_td_cds  TYPE REF TO if_cds_test_environment.
*    CLASS-DATA mo_td_osql TYPE REF TO if_osql_test_environment.

    METHODS setup.
    METHODS teardown.

    METHODS prodsa_chng_data FOR TESTING.

    DATA mt_pvbe                 TYPE STANDARD TABLE OF pvbe.
    DATA mt_pvkt                 TYPE STANDARD TABLE OF pvkt.
    DATA mt_t001w                TYPE STANDARD TABLE OF t001w.
    DATA mt_t001l                TYPE STANDARD TABLE OF t001l.

ENDCLASS.

CLASS ltc_change_data IMPLEMENTATION.
  METHOD class_setup.
    mo_td_cds = cl_cds_test_environment=>create( i_for_entity               = 'R_ProductionSupplyAreaTP'
                                                 i_select_base_dependencies = abap_on
                                                 test_associations          = abap_on ).

*    mo_td_osql = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'T001W' )
*                                                                                ( 'T001L' ) ) ).
    "Test double would be created for the CDS R_ProductionSupplyAreaTP. Executes once per test class.

  ENDMETHOD.

  METHOD setup.
    mo_td_cds->clear_doubles( ).
*    mo_td_osql->clear_doubles( ).
    "Ensures fresh data for each test method. Executes once before each test method execution

  ENDMETHOD.

  METHOD teardown.

  ENDMETHOD.

  METHOD class_teardown.
    mo_td_cds->destroy( ).
*    mo_td_osql->destroy( ).
    "Destroys test environment & test doubles created as part of the test. Executes once per test class.

  ENDMETHOD.

  METHOD prodsa_chng_data.
    DATA lo_cut TYPE REF TO cl_ptf_bo_rap_generic.
    DATA lt_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lv_json_file TYPE string.

*    "Prepare and insert test data
    mt_pvbe = VALUE #( ( werks = '0002' prvbe = 'TEST_ARECH' lgort = '0003' ) ).
    mo_td_cds->insert_test_data( i_data = mt_pvbe ).

    mt_pvkt = VALUE #( ( werks = '0002' prvbe = 'TEST_ARECH' spras = 'E' pvbtx = 'Test Area EN' )
      ( werks = '0002' prvbe = 'TEST_ARECH' spras = 'D' pvbtx = 'Test Area DE' ) ).
    mo_td_cds->insert_test_data( i_data = mt_pvkt ).

    mt_t001w = VALUE #( ( werks = '0002' ) ).
*    mo_td_osql->insert_test_data( i_data = mt_t001w ).
    mo_td_cds->insert_test_data( i_data = mt_t001w ).

    mt_t001l = VALUE #( ( werks = '0002' lgort = '0003' ) ).
*    mo_td_osql->insert_test_data( i_data = mt_t001l ).
    mo_td_cds->insert_test_data( i_data = mt_t001l ).

    lv_json_file = '{"_comment":"JSON Change Example for RAP BO R_PRODUCTIONSUPPLYAREATP with key in parent"'
      && ',"ignore":"false","fields":[{"name":"ProductionSupplyArea","value":"TEST_ARECH"}'
      && ',{"name":"Plant","value":"0002"},{"name":"StorageLocation","value":"0003"}]'
      && ',"associations":[{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT"'
      && ',"ignore":"false","fields":[{"name":"Language","value":"EN"}'
      && ',{"name":"ProductionSupplyAreaName","value":"Test Area EN Changed with key in parent"}]}'
      && ',{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT"'
      && ',"ignore":"false","fields":[{"name":"Language","value":"DE"},{"name":"ProductionSupplyAreaName","value":"Test Area DE Changed with key in parent"}]}]}'.

    lt_step_data = VALUE #( ( bus_obj = 'R_PRODUCTIONSUPPLYAREATP' action = 'CHANGE' step_number = 1 json_file = lv_json_file ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->change(
      EXPORTING
        iv_step_number = 1
      IMPORTING
        ev_document_id      = DATA(lt_document_id)
        ev_execution_status = DATA(lv_execution_status)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lt_document_id[ 1 ] exp = |TEST_ARECH{ cl_ptf_util=>gc_key_field_delimiter }0002| ).
    cl_abap_unit_assert=>assert_true( act = lv_execution_status ).

  ENDMETHOD.

ENDCLASS.

* Local Test Class for method retrieve
*CLASS ltc_retrieve_data DEFINITION DEFERRED.

CLASS ltc_retrieve_data DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    CLASS-DATA mo_td_cds  TYPE REF TO if_cds_test_environment.
*    CLASS-DATA mo_td_osql TYPE REF TO if_osql_test_environment.

    METHODS setup.
    METHODS teardown.

    METHODS prodsa_retr_data FOR TESTING.

    DATA mt_pvbe                 TYPE STANDARD TABLE OF pvbe.
    DATA mt_pvkt                 TYPE STANDARD TABLE OF pvkt.
    DATA mt_t001w                TYPE STANDARD TABLE OF t001w.
    DATA mt_t001l                TYPE STANDARD TABLE OF t001l.

ENDCLASS.

CLASS ltc_retrieve_data IMPLEMENTATION.
  METHOD class_setup.
    mo_td_cds = cl_cds_test_environment=>create( i_for_entity               = 'R_ProductionSupplyAreaTP'
                                                 i_select_base_dependencies = abap_on
                                                 test_associations          = abap_on ).

*    mo_td_osql = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'T001W' )
*                                                                                ( 'T001L' ) ) ).
    "Test double would be created for the CDS R_ProductionSupplyAreaTP. Executes once per test class.

  ENDMETHOD.

  METHOD setup.
    mo_td_cds->clear_doubles( ).
*    mo_td_osql->clear_doubles( ).
    "Ensures fresh data for each test method. Executes once before each test method execution

  ENDMETHOD.

  METHOD teardown.

  ENDMETHOD.

  METHOD class_teardown.
    mo_td_cds->destroy( ).
*    mo_td_osql->destroy( ).
    "Destroys test environment & test doubles created as part of the test. Executes once per test class.

  ENDMETHOD.

  METHOD prodsa_retr_data.
    DATA lo_cut       TYPE REF TO cl_ptf_bo_rap_generic.
    DATA lr_data      TYPE REF TO data.
    DATA lt_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lv_json_file TYPE string.

    FIELD-SYMBOLS <fs_table> TYPE STANDARD TABLE.
    FIELD-SYMBOLS <fs_data> TYPE any.

*    "Prepare and insert test data
    mt_pvbe = VALUE #( ( werks = '0001' prvbe = 'TEST_ARERT' lgort = '0001' ) ).
    mo_td_cds->insert_test_data( i_data = mt_pvbe ).

    mt_pvkt = VALUE #( ( werks = '0001' prvbe = 'TEST_ARERT' spras = 'E' pvbtx = 'Test Area EN' )
      ( werks = '0001' prvbe = 'TEST_ARECH' spras = 'D' pvbtx = 'Test Area DE' ) ).
    mo_td_cds->insert_test_data( i_data = mt_pvkt ).

    mt_t001w = VALUE #( ( werks = '0001' ) ).
*    mo_td_osql->insert_test_data( i_data = mt_t001w ).
    mo_td_cds->insert_test_data( i_data = mt_t001w ).

    mt_t001l = VALUE #( ( werks = '0001' lgort = '0001' ) ).
*    mo_td_osql->insert_test_data( i_data = mt_t001l ).
    mo_td_cds->insert_test_data( i_data = mt_t001l ).

    lv_json_file = '{"_comment":"JSON Retrieve Example for RAP BO R_PRODUCTIONSUPPLYAREATP with key in parent"'
      && ',"ignore":"false","fields":[{"name":"ProductionSupplyArea","value":"TEST_ARERT"}'
      && ',{"name":"Plant","value":"0001"},{"name":"StorageLocation","value":"0001"}]'
      && ',"associations":[{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT"'
      && ',"ignore":"false","fields":[{"name":"Language","value":"E"}]}'
      && ',{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT"'
      && ',"ignore":"false","fields":[{"name":"Language","value":"D"}]}]}'.

    lt_step_data = VALUE #( ( bus_obj = 'R_PRODUCTIONSUPPLYAREATP' action = 'RETRIEVE' step_number = 1 json_file = lv_json_file ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->retrieve(
      EXPORTING
        iv_step_number = 1
      IMPORTING
        ev_document_id      = DATA(lt_document_id)
        ev_execution_status = DATA(lv_execution_status)
    ).

    DATA(ls_step_data) = lo_cut->mo_run_environment->get_step_data( EXPORTING iv_step_number = 1 ).

    /ui2/cl_json=>deserialize(
        EXPORTING
          json          = ls_step_data-data_object_json
          assoc_arrays  = abap_on
        CHANGING
          data          = lr_data ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lt_document_id[ 1 ] exp = |TEST_ARERT{ cl_ptf_util=>gc_key_field_delimiter }0001| ).
    cl_abap_unit_assert=>assert_true( act = lv_execution_status ).

*   Check if we have an item with language E
    ASSIGN lr_data->* TO <fs_table>.

    READ TABLE <fs_table> ASSIGNING <fs_data> INDEX 1.

    ASSIGN COMPONENT 'R_PRODUCTIONSUPPLYAREATEXTTP' OF STRUCTURE <fs_data>->* TO FIELD-SYMBOL(<fs_prodsupareatext>).

    ASSIGN <fs_prodsupareatext>->* TO <fs_table>.

    READ TABLE <fs_table> ASSIGNING <fs_data> INDEX 1.

    ASSIGN COMPONENT 'LANGUAGE' OF STRUCTURE <fs_data>->* TO FIELD-SYMBOL(<fs_language>).

    cl_abap_unit_assert=>assert_equals( act = 'E' exp = <fs_language>->* ).

  ENDMETHOD.

ENDCLASS.

* Local Test Class for method retrieve_all
*CLASS ltc_retrieve_all_data DEFINITION DEFERRED.

CLASS ltc_retrieve_all_data DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    CLASS-DATA mo_td_cds  TYPE REF TO if_cds_test_environment.
*    CLASS-DATA mo_td_osql TYPE REF TO if_osql_test_environment.

    METHODS setup.
    METHODS teardown.

    METHODS prodsa_retr_all_data_free_srch FOR TESTING.

    DATA mt_pvbe                 TYPE STANDARD TABLE OF pvbe.
    DATA mt_pvkt                 TYPE STANDARD TABLE OF pvkt.
    DATA mt_t001w                TYPE STANDARD TABLE OF t001w.
    DATA mt_t001l                TYPE STANDARD TABLE OF t001l.

ENDCLASS.

CLASS ltc_retrieve_all_data IMPLEMENTATION.
  METHOD class_setup.
    mo_td_cds = cl_cds_test_environment=>create( i_for_entity               = 'R_ProductionSupplyAreaTP'
                                                 i_select_base_dependencies = abap_on
                                                 test_associations          = abap_on ).

*    mo_td_osql = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'T001W' )
*                                                                                ( 'T001L' ) ) ).
    "Test double would be created for the CDS R_ProductionSupplyAreaTP. Executes once per test class.

  ENDMETHOD.

  METHOD setup.
    mo_td_cds->clear_doubles( ).
*    mo_td_osql->clear_doubles( ).
    "Ensures fresh data for each test method. Executes once before each test method execution

  ENDMETHOD.

  METHOD teardown.

  ENDMETHOD.

  METHOD class_teardown.
    mo_td_cds->destroy( ).
*    mo_td_osql->destroy( ).
    "Destroys test environment & test doubles created as part of the test. Executes once per test class.

  ENDMETHOD.

  METHOD prodsa_retr_all_data_free_srch.
    DATA lo_cut       TYPE REF TO cl_ptf_bo_rap_generic.
    DATA lr_data      TYPE REF TO data.
    DATA lt_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lv_json_file TYPE string.

    FIELD-SYMBOLS <fs_table> TYPE STANDARD TABLE.
    FIELD-SYMBOLS <fs_data> TYPE any.

*    "Prepare and insert test data
    mt_pvbe = VALUE #( ( werks = '0001' prvbe = 'TEST_ARERA' lgort = '0001' ) ).
    mo_td_cds->insert_test_data( i_data = mt_pvbe ).

    mt_pvkt = VALUE #( ( werks = '0001' prvbe = 'TEST_ARERA' spras = 'E' pvbtx = 'Test Area EN' )
      ( werks = '0001' prvbe = 'TEST_ARERA' spras = 'D' pvbtx = 'Test Area DE' ) ).
    mo_td_cds->insert_test_data( i_data = mt_pvkt ).

    mt_t001w = VALUE #( ( werks = '0001' ) ).
*    mo_td_osql->insert_test_data( i_data = mt_t001w ).
    mo_td_cds->insert_test_data( i_data = mt_t001w ).

    mt_t001l = VALUE #( ( werks = '0001' lgort = '0001' ) ).
*    mo_td_osql->insert_test_data( i_data = mt_t001l ).
    mo_td_cds->insert_test_data( i_data = mt_t001l ).

    lv_json_file = '{"_comment":"JSON Retrieve Example for RAP BO R_PRODUCTIONSUPPLYAREATP with key in parent"'
      && ',"ignore":"false","fields":[{"name":"StorageLocation","value":"0001"}]'
      && ',"associations":[{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP","assocName":"_PRODUCTIONSUPPLYAREATEXT"'
      && ',"ignore":"false","fields":[{"name":"Language","value":"D"}]}]}'.

    lt_step_data = VALUE #( ( bus_obj = 'R_PRODUCTIONSUPPLYAREATP' action = 'RETRIEVE_ALL' step_number = 1 json_file = lv_json_file ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->retrieve_all(
      EXPORTING
        iv_step_number = 1
      IMPORTING
        ev_document_id      = DATA(lt_document_id)
        ev_execution_status = DATA(lv_execution_status)
    ).

    DATA(ls_step_data) = lo_cut->mo_run_environment->get_step_data( EXPORTING iv_step_number = 1 ).

    /ui2/cl_json=>deserialize(
        EXPORTING
          json          = ls_step_data-data_object_json
          assoc_arrays  = abap_on
        CHANGING
          data          = lr_data ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lt_document_id[ 1 ] exp = |TEST_ARERA{ cl_ptf_util=>gc_key_field_delimiter }0001| ).
    cl_abap_unit_assert=>assert_true( act = lv_execution_status ).

*   Check if we have an item with language D
    ASSIGN lr_data->* TO <fs_table>.

    READ TABLE <fs_table> ASSIGNING <fs_data> INDEX 1.

    ASSIGN COMPONENT 'R_PRODUCTIONSUPPLYAREATEXTTP' OF STRUCTURE <fs_data>->* TO FIELD-SYMBOL(<fs_prodsupareatext>).

    ASSIGN <fs_prodsupareatext>->* TO <fs_table>.

    READ TABLE <fs_table> ASSIGNING <fs_data> INDEX 1.

    ASSIGN COMPONENT 'LANGUAGE' OF STRUCTURE <fs_data>->* TO FIELD-SYMBOL(<fs_language>).

    cl_abap_unit_assert=>assert_equals( act = 'D' exp = <fs_language>->* ).

  ENDMETHOD.

ENDCLASS.

* Local Test Class for method delete
*CLASS ltc_delete_data DEFINITION DEFERRED.

CLASS ltc_delete_data DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    CLASS-DATA mo_td TYPE REF TO if_cds_test_environment.

    METHODS setup.
    METHODS teardown.

    METHODS prodsa_del_data FOR TESTING.

    DATA mt_pvbe                 TYPE STANDARD TABLE OF pvbe.
    DATA mt_pvkt                 TYPE STANDARD TABLE OF pvkt.

ENDCLASS.

CLASS ltc_delete_data IMPLEMENTATION.
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

  METHOD prodsa_del_data.
    DATA lo_cut TYPE REF TO cl_ptf_bo_rap_generic.
    DATA lt_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lv_json_file TYPE string.

    "Prepare and insert test data
    mt_pvbe = VALUE #( ( werks = '0001' prvbe = 'TEST_AREDL' lgort = '0001' ) ).
    mo_td->insert_test_data( i_data = mt_pvbe ).

    mt_pvkt = VALUE #( ( werks = '0001' prvbe = 'TEST_AREDL' spras = 'E' pvbtx = 'Test Area EN' )
      ( werks = '0001' prvbe = 'TEST_AREDL' spras = 'D' pvbtx = 'Test Area DE' ) ).
    mo_td->insert_test_data( i_data = mt_pvkt ).

    lv_json_file = '{"_comment":"JSON Delete Example for RAP BO R_PRODUCTIONSUPPLYAREATP"'
      && ',"ignore":"false","fields":[{"name":"ProductionSupplyArea","value":"TEST_AREDL"}'
      && ',{"name":"Plant","value":"0001"},{"name":"StorageLocation","value":"0001"}]}'.

    lt_step_data = VALUE #( ( bus_obj = 'R_PRODUCTIONSUPPLYAREATP' action = 'DELETE' step_number = 1 json_file = lv_json_file ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->delete(
      EXPORTING
        iv_step_number = 1
      IMPORTING
        ev_document_id      = DATA(lt_document_id)
        ev_execution_status = DATA(lv_execution_status)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lt_document_id[ 1 ] exp = |TEST_AREDL{ cl_ptf_util=>gc_key_field_delimiter }0001| ).
    cl_abap_unit_assert=>assert_true( act = lv_execution_status ).

  ENDMETHOD.

ENDCLASS.

* Local Test Class for method action
CLASS ltc_action_data DEFINITION DEFERRED.
CLASS cl_ptf_bo_rap_generic DEFINITION LOCAL FRIENDS ltc_action_data.

CLASS ltc_action_data DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    CLASS-DATA mo_td TYPE REF TO if_ptf_bo_rap_generic_eml.

    METHODS setup.
    METHODS teardown.

    METHODS slsord_set_bilblock_data FOR TESTING.

ENDCLASS.

CLASS ltc_action_data IMPLEMENTATION.
  METHOD class_setup.
    mo_td ?= cl_abap_testdouble=>create( 'IF_PTF_BO_RAP_GENERIC_EML' ).
    "Test double would be created for EML access. Executes once per test class.

  ENDMETHOD.

  METHOD setup.
*    mo_td->clear_doubles( ).
    "Ensures fresh data for each test method. Executes once before each test method execution

  ENDMETHOD.

  METHOD teardown.

  ENDMETHOD.

  METHOD class_teardown.
*    mo_td->destroy( ).
    "Destroys test environment & test doubles created as part of the test. Executes once per test class.

  ENDMETHOD.

  METHOD slsord_set_bilblock_data.
    DATA lo_cut       TYPE REF TO cl_ptf_bo_rap_generic.
    DATA lt_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lv_json_file TYPE string.

    "Prepare and insert test data
    "Configure double for get_permissions - needed to ignore CT_OPERATIONS mainly
    DATA lt_failed_perm     TYPE abp_behv_response_tab.
    DATA lt_reported_perm   TYPE abp_behv_response_tab.
    DATA lt_operations_perm TYPE abp_behv_permissions_tab.

*    lt_failed_perm = VALUE #( ( entity_name = 'R_SALESORDERTP' ) ). "it is doubled - need to fill also entries
*    lt_reported_perm = VALUE #( ( entity_name = 'R_SALESORDERTP' ) ). "it is doubled - need to fill also entries
*    lt_operations_perm = VALUE #( ( entity_name = 'R_SALESORDERTP' ) ). "doesn't do anything

*    cl_abap_testdouble=>configure_call( mo_td )->ignore_parameter(
*      'CT_OPERATIONS' )->and_expect( )->is_called_once( ). "can work only with this

    cl_abap_testdouble=>configure_call( mo_td )->set_parameter(
      name  = 'ET_FAILED'
      value = lt_failed_perm )->set_parameter(
      name  = 'ET_REPORTED'
      value = lt_reported_perm  )->ignore_parameter(
      'CT_OPERATIONS' )->and_expect( )->is_called_once( ).

    mo_td->get_permissions(
      CHANGING
        ct_operations = lt_operations_perm
    ).

*   "Configure double for modify_entities - not mandatory to do it
    DATA lt_operations TYPE abp_behv_changes_tab.
    "DATA lt_failed     TYPE abp_behv_response_tab.
    "DATA lt_mapped     TYPE abp_behv_response_tab.
    "DATA lt_reported   TYPE abp_behv_response_tab.

*    cl_abap_testdouble=>configure_call( mo_td )->set_parameter(
*      name  = 'ET_FAILED'
*      value = lt_failed_perm )->set_parameter(
*      name  = 'ET_MAPPED'
*      value = lt_reported_perm  )->set_parameter(
*      name  = 'ET_REPORTED'
*      value = lt_failed_perm )->ignore_parameter(
*      'IT_OPERATIONS' )->and_expect( )->is_called_once( ).

    mo_td->modify_entities(
      CHANGING
        ct_operations = lt_operations ).

*   "Configure double for commit_entities - not mandatory to do it
    DATA lv_simulation      TYPE abap_bool.
    "DATA lt_root_entities   TYPE abp_entity_name_tab.
    DATA lt_failed_commit   TYPE abp_behv_response_tab.
    "DATA lt_reported_commit TYPE abp_behv_response_tab.

    cl_abap_testdouble=>configure_call( mo_td )->ignore_parameter( 'IT_ROOT_ENTITIES' )->ignore_parameter( 'CT_PID_MAPPED' )->set_parameter(
      name  = 'ET_FAILED'
      value = lt_failed_commit )->set_parameter(
      name  = 'ET_REPORTED'
      value = lt_failed_commit )->and_expect( )->is_called_once( ).

    mo_td->commit_entities(
      EXPORTING
        iv_simulation     = lv_simulation ).
    "it_root_entities  = lt_root_entities ).

    lv_json_file = '{"_comment":"JSON Action Example for RAP BO R_SALESORDERTP"'
      && ',"ignore":"false","fields":[{"name":"SalesOrder","value":"SO_ACT_BIL"}],"params":[{"name":"HeaderBillingBlockReason","value":"XY"}]}'.

    lt_step_data = VALUE #( ( bus_obj = 'R_SALESORDERTP' action = 'SETBILLINGBLOCK' step_number = 1 json_file = lv_json_file ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).
    lo_cut->mo_ptf_bo_rap_generic_eml = mo_td.

    "when
    lo_cut->execute_action(
      EXPORTING
        iv_step_number = 1
      IMPORTING
        ev_execution_status = DATA(lv_execution_status)
    ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_execution_status ).

    cl_abap_testdouble=>verify_expectations( mo_td ).

  ENDMETHOD.

ENDCLASS.

** Local Test Class for method commit_entities
*CLASS ltc_commit_data DEFINITION DEFERRED.
*
*CLASS ltc_commit_data DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
*  PRIVATE SECTION.
*    CLASS-METHODS class_setup.
*    CLASS-METHODS class_teardown.
*
*    CLASS-DATA mo_td TYPE REF TO if_cds_test_environment.
*
*    METHODS setup.
*    METHODS teardown.
*
*    METHODS commit_data FOR TESTING.
*
*    DATA mt_agency                 TYPE STANDARD TABLE OF /dmo/agency.
*    DATA mt_customer               TYPE STANDARD TABLE OF /dmo/customer.
*
*ENDCLASS.
*
*CLASS ltc_commit_data IMPLEMENTATION.
*  METHOD class_setup.
*    mo_td = cl_cds_test_environment=>create( i_for_entity               = '/DMO/I_Travel_M'
*                                             i_select_base_dependencies = abap_on
*                                             test_associations          = abap_on ).
*    "Test double would be created for the CDS R_ProductionSupplyAreaTP. Executes once per test class.
*
*  ENDMETHOD.
*
*  METHOD setup.
*    mo_td->clear_doubles( ).
*    "Ensures fresh data for each test method. Executes once before each test method execution
*
*  ENDMETHOD.
*
*  METHOD teardown.
*
*  ENDMETHOD.
*
*  METHOD class_teardown.
*    mo_td->destroy( ).
*    "Destroys test environment & test doubles created as part of the test. Executes once per test class.
*
*  ENDMETHOD.
*
*  METHOD commit_data.
*    DATA lo_cut           TYPE REF TO cl_ptf_bo_rap_generic.
*    DATA ls_travel        TYPE /dmo/travel_m.
*    DATA ls_travel_commit TYPE /dmo/travel_m.
*    DATA lt_step_data     TYPE cl_ptf_util=>gt_ptf_step_tab.
*    DATA ls_step_data     TYPE cl_ptf_util=>gt_ptf_step.
*    DATA lv_travel_id     TYPE /dmo/travel_id.
*    DATA lv_json_file     TYPE string.
*
*    "Prepare and insert test data
*    mt_agency  = VALUE #( ( agency_id = '070002' ) ).
*    mo_td->insert_test_data( i_data = mt_agency ).
*
*    mt_customer = VALUE #( ( customer_id = '000599' ) ).
*    mo_td->insert_test_data( i_data = mt_customer ).
*
*    lv_json_file = '{"_comment":"JSON Create Example for RAP BO /DMO/I_Travel_M"'
*      && ',"commit":"false","fields":[{"name":"AGENCY_ID","value":"070002"},{"name":"CUSTOMER_ID","value":"000599"}'
*      && |,\{"name":"BEGIN_DATE","value":"{ sy-datum + 1 }"\},\{"name":"END_DATE","value":"{ sy-datum + 1 }"\},\{"name":"BOOKING_FEE","value":"20"\}|
*      && ',{"name":"CURRENCY_CODE","value":"EUR"},{"name":"OVERALL_STATUS","value":"O"},{"name":"DESCRIPTION","value":"First Travel"}]}'.
*
*    APPEND VALUE #( bus_obj = '/DMO/I_TRAVEL_M' action = 'CREATE' step_number = 1 json_file = lv_json_file ) TO lt_step_data.
*
*    APPEND VALUE #( bus_obj = '/DMO/I_TRAVEL_M' action = 'COMMIT' step_number = 2 ) TO lt_step_data.
*
*    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).
*
*    "given
*    lo_cut = NEW #( lo_ptf_run ).
*
*    "when
*    lo_cut->create(
*      EXPORTING
*        iv_step_number = 1
*      IMPORTING
*        ev_document_id      = DATA(lt_document_id_1)
*        ev_execution_status = DATA(lv_execution_status_1)
*    ).
*
**temp:----
*    cl_abap_unit_assert=>assert_true( act = lv_execution_status_1 level = 0 ).
**---------
*
*    "then
*    cl_abap_unit_assert=>assert_true( act = lv_execution_status_1 ).
*
*    ls_step_data = lo_ptf_run->get_step_data( 1 ).
*    ls_step_data-document_id = lt_document_id_1.
*    lo_ptf_run->set_step_data( EXPORTING iv_step_number = 1                      "needed?
*                                         step_data      = ls_step_data ).
*
**   Retrieve always returns the object even if it's not commited
**   So a better way to check the persistence is to query the table itself
*    lv_travel_id = lt_document_id_1[ 1 ].
*
*    SELECT SINGLE *
*      INTO CORRESPONDING FIELDS OF ls_travel
*      FROM /dmo/travel_m
*      WHERE travel_id = lv_travel_id.
*
*    "when
*    lo_cut->commit(
*      EXPORTING
*        iv_step_number = 2
*      IMPORTING
*        "ev_document_id      = DATA(lt_document_id_2)
*        ev_execution_status = DATA(lv_execution_status_2)
*    ).
*
*    SELECT SINGLE *
*      INTO CORRESPONDING FIELDS OF ls_travel_commit
*      FROM /dmo/travel_m
*      WHERE travel_id = lv_travel_id.
*
*    "then
*    cl_abap_unit_assert=>assert_true( act = lv_execution_status_2 ).
*    cl_abap_unit_assert=>assert_initial( act = ls_travel ).
*    cl_abap_unit_assert=>assert_not_initial( act = ls_travel_commit ).
*
*  ENDMETHOD.
*
*ENDCLASS.

* Local Test Class for method check_if_commit
CLASS ltc_check_if_commit DEFINITION DEFERRED.
CLASS cl_ptf_bo_rap_generic DEFINITION LOCAL FRIENDS ltc_check_if_commit.

CLASS ltc_check_if_commit DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    METHODS setup.
    METHODS teardown.

    METHODS check_if_commit_1_pos FOR TESTING.
    METHODS check_if_commit_1_neg FOR TESTING.

ENDCLASS.

CLASS ltc_check_if_commit IMPLEMENTATION.
  METHOD class_setup.
  ENDMETHOD.

  METHOD setup.
  ENDMETHOD.

  METHOD teardown.
  ENDMETHOD.

  METHOD class_teardown.
  ENDMETHOD.

  METHOD check_if_commit_1_pos.
    DATA lo_cut       TYPE REF TO cl_ptf_bo_rap_generic.
    DATA lt_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lv_json_file TYPE string.

    lv_json_file = '{"commit":"true"}'.

    "Prepare test data
    TRY.
        cl_ptf_json=>deserialize(
          EXPORTING
            iv_entity = 'R_PRODUCTIONSUPPLYAREATP'
            iv_action = 'CREATE'
            iv_json   = lv_json_file
          IMPORTING
            er_data   = DATA(er_test_data) ).

      CATCH cx_ptf_json ##NO_HANDLER.
    ENDTRY.

    ASSIGN er_test_data->* TO FIELD-SYMBOL(<fs_test_data>).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->check_if_commit(
      EXPORTING
        is_test_data = <fs_test_data>
      RECEIVING
        rv_commit    = DATA(lv_commit)
    ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_commit ).

  ENDMETHOD.

  METHOD check_if_commit_1_neg.
    DATA lo_cut       TYPE REF TO cl_ptf_bo_rap_generic.
    DATA lt_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lv_json_file TYPE string.

    lv_json_file = '{"commit":"false"}'.

    "Prepare test data
    TRY.
        cl_ptf_json=>deserialize(
          EXPORTING
            iv_entity = 'R_PRODUCTIONSUPPLYAREATP'
            iv_action = 'CREATE'
            iv_json   = lv_json_file
          IMPORTING
            er_data   = DATA(er_test_data) ).

      CATCH cx_ptf_json ##NO_HANDLER.
    ENDTRY.

    ASSIGN er_test_data->* TO FIELD-SYMBOL(<fs_test_data>).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->check_if_commit(
      EXPORTING
        is_test_data = <fs_test_data>
      RECEIVING
        rv_commit    = DATA(lv_commit)
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_commit ).

  ENDMETHOD.

ENDCLASS.

* Local Test Class for method check_if_simulation
CLASS ltc_check_if_simulation DEFINITION DEFERRED.
CLASS cl_ptf_bo_rap_generic DEFINITION LOCAL FRIENDS ltc_check_if_simulation.

CLASS ltc_check_if_simulation DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    METHODS setup.
    METHODS teardown.

    METHODS check_if_simulation_1_pos FOR TESTING.
    METHODS check_if_simulation_1_neg FOR TESTING.

ENDCLASS.

CLASS ltc_check_if_simulation IMPLEMENTATION.
  METHOD class_setup.
  ENDMETHOD.

  METHOD setup.
  ENDMETHOD.

  METHOD teardown.
  ENDMETHOD.

  METHOD class_teardown.
  ENDMETHOD.

  METHOD check_if_simulation_1_pos.
    DATA lo_cut       TYPE REF TO cl_ptf_bo_rap_generic.
    DATA lt_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lv_json_file TYPE string.

    lv_json_file = '{"simulation":"true"}'.

    "Prepare test data
    TRY.
        cl_ptf_json=>deserialize(
          EXPORTING
            iv_entity = 'R_PRODUCTIONSUPPLYAREATP'
            iv_action = 'CREATE'
            iv_json   = lv_json_file
          IMPORTING
            er_data   = DATA(er_test_data) ).

      CATCH cx_ptf_json ##NO_HANDLER.
    ENDTRY.

    ASSIGN er_test_data->* TO FIELD-SYMBOL(<fs_test_data>).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->check_if_simulation(
      EXPORTING
        is_test_data  = <fs_test_data>
      RECEIVING
        rv_simulation = DATA(lv_simulation)
    ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_simulation ).

  ENDMETHOD.

  METHOD check_if_simulation_1_neg.
    DATA lo_cut       TYPE REF TO cl_ptf_bo_rap_generic.
    DATA lt_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lv_json_file TYPE string.

    lv_json_file = '{"simulation":"false"}'.

    "Prepare test data
    TRY.
        cl_ptf_json=>deserialize(
          EXPORTING
            iv_entity = 'R_PRODUCTIONSUPPLYAREATP'
            iv_action = 'CREATE'
            iv_json   = lv_json_file
          IMPORTING
            er_data   = DATA(er_test_data) ).

      CATCH cx_ptf_json ##NO_HANDLER.
    ENDTRY.

    ASSIGN er_test_data->* TO FIELD-SYMBOL(<fs_test_data>).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->check_if_simulation(
      EXPORTING
        is_test_data  = <fs_test_data>
      RECEIVING
        rv_simulation = DATA(lv_simulation)
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_simulation ).

  ENDMETHOD.

ENDCLASS.

* Local Test Class for method get_childentityname
CLASS ltc_get_childentityname DEFINITION DEFERRED.
CLASS cl_ptf_bo_rap_generic DEFINITION LOCAL FRIENDS ltc_get_childentityname.

CLASS ltc_get_childentityname DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    METHODS setup.
    METHODS teardown.

    METHODS get_childentityname_1 FOR TESTING.

ENDCLASS.

CLASS ltc_get_childentityname IMPLEMENTATION.
  METHOD class_setup.
  ENDMETHOD.

  METHOD setup.
  ENDMETHOD.

  METHOD teardown.
  ENDMETHOD.

  METHOD class_teardown.
  ENDMETHOD.

  METHOD get_childentityname_1.
    DATA lo_cut       TYPE REF TO cl_ptf_bo_rap_generic.
    DATA lt_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lv_json_file TYPE string.

    lv_json_file = '{"childEntityName":"R_PRODUCTIONSUPPLYAREATEXTTP"}'.

    "Prepare test data
    TRY.
        cl_ptf_json=>deserialize(
          EXPORTING
            iv_entity = 'R_PRODUCTIONSUPPLYAREATP'
            iv_action = 'ENTITY_ACTION'
            iv_json   = lv_json_file
          IMPORTING
            er_data   = DATA(er_test_data) ).

      CATCH cx_ptf_json ##NO_HANDLER.
    ENDTRY.

    ASSIGN er_test_data->* TO FIELD-SYMBOL(<fs_test_data>).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->get_childentityname(
      EXPORTING
        is_test_data  = <fs_test_data>
      IMPORTING
        ev_name       = DATA(lv_name)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lv_name exp = 'R_PRODUCTIONSUPPLYAREATEXTTP' ).

  ENDMETHOD.

ENDCLASS.

* Local Test Class for method check_reference_step
CLASS ltc_check_reference_step DEFINITION DEFERRED.
CLASS cl_ptf_bo_rap_generic DEFINITION LOCAL FRIENDS ltc_check_reference_step.

CLASS ltc_check_reference_step DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    METHODS setup.
    METHODS teardown.

    METHODS reference_step_with_pid FOR TESTING.

ENDCLASS.

CLASS ltc_check_reference_step IMPLEMENTATION.
  METHOD class_setup.
  ENDMETHOD.

  METHOD setup.
  ENDMETHOD.

  METHOD teardown.
  ENDMETHOD.

  METHOD class_teardown.
  ENDMETHOD.

  METHOD reference_step_with_pid.
    DATA lo_cut           TYPE REF TO cl_ptf_bo_rap_generic.
    DATA lt_step_data     TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA ls_step_data     TYPE cl_ptf_util=>gt_ptf_step.
    DATA lv_json_file     TYPE string.

    lv_json_file = '{"fields":[{"name":"BILLINGDOCUMENT","value":"KEY"}]}'.

    "Prepare test data
    TRY.
        cl_ptf_json=>deserialize(
          EXPORTING
            iv_entity = 'R_BILLINGDOCUMENTTP'
            iv_action = 'RETRIEVE'
            iv_json   = lv_json_file
          IMPORTING
            er_data   = DATA(er_test_data) ).

      CATCH cx_ptf_json ##NO_HANDLER.
    ENDTRY.

    ASSIGN er_test_data->* TO FIELD-SYMBOL(<fs_test_data>).

    "Create %pid.
    DATA(lo_system_uuid) = cl_uuid_factory=>create_system_uuid( ).
    TRY.
        DATA(lv_uuid_x16) = lo_system_uuid->create_uuid_x16( ).

      CATCH cx_uuid_error ##NO_HANDLER.
    ENDTRY.

    ls_step_data = VALUE #( bus_obj = 'R_BILLINGDOCUMENTTP' action = 'CREATEFROMSDDOCUMENT' step_number = 1 document_id = VALUE #( ( CONV #( lv_uuid_x16 ) ) ) is_pid = abap_on ).
    APPEND ls_step_data TO lt_step_data.

    ls_step_data = VALUE #( bus_obj = 'R_BILLINGDOCUMENTTP' action = 'RETRIEVE' step_number = 2 reference_step = VALUE #( ( 1 ) ) ).
    APPEND ls_step_data TO lt_step_data.

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->check_reference_step(
      EXPORTING
        iv_op        = if_abap_behv=>op-r-read
        is_step_data = ls_step_data
      CHANGING
        cs_test_data = <fs_test_data>
    ).

    ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-pid OF STRUCTURE <fs_test_data> TO FIELD-SYMBOL(<fs_pid>).
    ASSIGN COMPONENT 'BILLINGDOCUMENT' OF STRUCTURE <fs_test_data> TO FIELD-SYMBOL(<fs_billingdocument>).

    "then
    cl_abap_unit_assert=>assert_equals( act = <fs_pid> exp = lv_uuid_x16 ).
    cl_abap_unit_assert=>assert_initial( act = <fs_billingdocument> ).

  ENDMETHOD.

ENDCLASS.

CLASS ltc_build_resultid_from_struct DEFINITION DEFERRED.
CLASS cl_ptf_bo_rap_generic DEFINITION LOCAL FRIENDS ltc_build_resultid_from_struct.
CLASS ltc_build_resultid_from_struct DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.

    METHODS:
      setup,
      std FOR TESTING,
      not_all_fields_fit_in FOR TESTING.

    DATA mo_cut         TYPE REF TO cl_ptf_bo_rap_generic.

*based on structure EAM_S_PRIOZN_PRFL_CALCULATED
    DATA:
      BEGIN OF ty_param,
        maintpriority       TYPE  priok,
        maintprioritydesc   TYPE  priokx,
        required_start_date TYPE  strmn,
        required_start_time TYPE  strur,
        required_end_date   TYPE  ltrmn,
        required_end_time   TYPE  ltrur,
        lacd_date           TYPE  lacd_date,
        leading_values      TYPE  eam_t_priozn_prfl_leading,  "itab
        selected_values     TYPE  eam_t_priozn_prfl_selected, "itab
      END OF ty_param .

ENDCLASS.

CLASS ltc_build_resultid_from_struct IMPLEMENTATION.

  METHOD setup.
    DATA lt_step_data   TYPE cl_ptf_util=>gt_ptf_step_tab.
    "lt_step_data = VALUE #( ( bus_obj = 'R_SALESORDERTP' action = 'SETBILLINGBLOCK' step_number = 1 ) ).
    lt_step_data = VALUE #( ( bus_obj = 'DUMMYR_DUMMYBO' action = 'DUMMYACTION' step_number = 1 ) ).
    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).
    mo_cut = NEW #( lo_ptf_run ).

  ENDMETHOD.

  METHOD std.

    "given
    DATA lr_struct LIKE REF TO me->ty_param.
    CREATE DATA lr_struct.

    lr_struct->maintpriority       = '2'.
    lr_struct->maintprioritydesc   = 'High.'.
    lr_struct->required_start_date = '20230116'.
    lr_struct->required_start_time = '155601'.
    lr_struct->required_end_date   = '20230118'.
    lr_struct->required_end_time   = '155601'.
    lr_struct->lacd_date           = '20230118'.
    lr_struct->leading_values      = VALUE #( ( mainteventcnsqnccategorycode = 16  mainteventconsequencecode = 17 ) ).
    CLEAR lr_struct->selected_values.


    "when
    DATA(lt_result) = mo_cut->build_resultid_from_struct(
      EXPORTING
      iv_doc_length = 70
      is_struct     = lr_struct->*
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lt_result[ 1 ] exp = '2|High.               |20230116|155601|20230118|155601|20230118' ).  " '2High.               202301161556012023011815560120230118' ).

  ENDMETHOD.

  METHOD not_all_fields_fit_in.

    DATA:
      BEGIN OF lty_param,
        maintprioritydesc   TYPE c length 60,
        required_start_date TYPE  strmn,
        required_start_time TYPE  strur,
        required_end_date   TYPE  ltrmn,
      END OF lty_param.

    "given
    DATA lr_struct LIKE REF TO lty_param.
    CREATE DATA lr_struct.

    lr_struct->maintprioritydesc   = 'High.'.
    lr_struct->required_start_date = '20230116'.
    lr_struct->required_start_time = '155601'.
    lr_struct->required_end_date   = '20230118'.

    "when
    DATA(lt_result) = mo_cut->build_resultid_from_struct(
      EXPORTING
      iv_doc_length = 70
      is_struct     = lr_struct->*
    ).

    "then             69 chars
    cl_abap_unit_assert=>assert_equals( act = lt_result[ 1 ] exp = 'High.                                                       |20230116' ).


    DATA:
      BEGIN OF lty_param2,
        maintprioritydesc   TYPE c length 61,
        required_start_date TYPE  strmn,
        required_start_time TYPE  strur,
        required_end_date   TYPE  ltrmn,
      END OF lty_param2.


    "given
    DATA lr_struct2 LIKE REF TO lty_param2.
    CREATE DATA lr_struct2.

    lr_struct2->maintprioritydesc   = 'High.'.
    lr_struct2->required_start_date = '20230116'.
    lr_struct2->required_start_time = '155601'.
    lr_struct2->required_end_date   = '20230118'.

    "when
    data(lt_result2) = mo_cut->build_resultid_from_struct(
      EXPORTING
      iv_doc_length = 70
      is_struct     = lr_struct2->*
    ).

    "then      70 chars
    cl_abap_unit_assert=>assert_equals( act = lt_result2[ 1 ] exp = 'High.                                                        |20230116' ).


    DATA:
      BEGIN OF lty_param3,
        maintprioritydesc   TYPE c length 62,
        required_start_date TYPE strmn,
        required_start_time TYPE strur,
        required_end_date   TYPE ltrmn,
      END OF lty_param3.


    "given
    DATA lr_struct3 LIKE REF TO lty_param3.
    CREATE DATA lr_struct3.

    lr_struct3->maintprioritydesc   = 'High.'.
    lr_struct3->required_start_date = '20230116'.
    lr_struct3->required_start_time = '155601'.
    lr_struct3->required_end_date   = '20230118'.

    "when
    data(lt_result3) = mo_cut->build_resultid_from_struct(
      EXPORTING
      iv_doc_length = 70
      is_struct     = lr_struct3->*
    ).

    "then    second field does not fit in, only first field is considered
    cl_abap_unit_assert=>assert_equals( act = lt_result3[ 1 ] exp = 'High.' ).

  ENDMETHOD.

ENDCLASS.
