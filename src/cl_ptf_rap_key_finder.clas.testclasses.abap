*"* use this source file for your ABAP unit test classes
* Local Test Class for method query_bo
CLASS ltc_query_bo DEFINITION DEFERRED.
CLASS cl_ptf_rap_key_finder DEFINITION LOCAL FRIENDS ltc_query_bo.
CLASS ltc_query_bo DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    CLASS-DATA mo_td_cds  TYPE REF TO if_cds_test_environment.

    METHODS setup.
    METHODS teardown.

    METHODS query_bo_single FOR TESTING.
    METHODS query_bo_w_child FOR TESTING.

    DATA mt_pvbe                 TYPE STANDARD TABLE OF pvbe.
    DATA mt_pvkt                 TYPE STANDARD TABLE OF pvkt.
    DATA mt_t001w                TYPE STANDARD TABLE OF t001w.
    DATA mt_t001l                TYPE STANDARD TABLE OF t001l.

ENDCLASS.

CLASS ltc_query_bo IMPLEMENTATION.
  METHOD class_setup.
    mo_td_cds = cl_cds_test_environment=>create( i_for_entity               = 'R_ProductionSupplyAreaTP'
                                                 i_select_base_dependencies = abap_on
                                                 test_associations          = abap_on ).

    "Test double would be created for the CDS R_ProductionSupplyAreaTP. Executes once per test class.

  ENDMETHOD.

  METHOD setup.
    mo_td_cds->clear_doubles( ).
    "Ensures fresh data for each test method. Executes once before each test method execution

  ENDMETHOD.

  METHOD teardown.

  ENDMETHOD.

  METHOD class_teardown.
    mo_td_cds->destroy( ).
    "Destroys test environment & test doubles created as part of the test. Executes once per test class.

  ENDMETHOD.

  METHOD query_bo_single.
    DATA lo_cut         TYPE REF TO cl_ptf_rap_key_finder.
    DATA lo_tabledescr  TYPE REF TO cl_abap_tabledescr.
    DATA lo_structdescr TYPE REF TO cl_abap_structdescr.
    DATA lo_refdescr    TYPE REF TO cl_abap_refdescr.
    DATA lr_struct      TYPE REF TO data.
    DATA lt_step_data   TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lt_sel_data    TYPE cl_ptf_rap_key_finder=>tt_sel_data.
    DATA ls_sel_data    TYPE cl_ptf_rap_key_finder=>ts_sel_data.
    DATA lv_json_file   TYPE string.

    FIELD-SYMBOLS <fs_data_table> TYPE STANDARD TABLE.

*    "Prepare and insert test data
    mt_pvbe = VALUE #( ( werks = '0002' prvbe = 'TEST_ARE01' lgort = '0001' )
    ( werks = '0002' prvbe = 'TEST_ARE02' lgort = '0002' )
    ( werks = '0002' prvbe = 'TEST_ARE03' lgort = '0002' )
    ( werks = '0002' prvbe = 'TEST_ARE04' lgort = '0002' )
    ( werks = '0002' prvbe = 'TEST_ARE05' lgort = '0003' ) ).
    mo_td_cds->insert_test_data( i_data = mt_pvbe ).

    mt_pvkt = VALUE #( ( werks = '0002' prvbe = 'TEST_ARE01' spras = 'E' pvbtx = 'Test Area 01 EN' )
      ( werks = '0002' prvbe = 'TEST_ARE01' spras = 'D' pvbtx = 'Test Area 01 DE' )
      ( werks = '0002' prvbe = 'TEST_ARE02' spras = 'E' pvbtx = 'Test Area 02 EN' )
      ( werks = '0002' prvbe = 'TEST_ARE02' spras = 'D' pvbtx = 'Test Area 02 DE' )
      ( werks = '0002' prvbe = 'TEST_ARE03' spras = 'E' pvbtx = 'Test Area 03 EN' )
      ( werks = '0002' prvbe = 'TEST_ARE03' spras = 'D' pvbtx = 'Test Area 03 DE' )
      ( werks = '0002' prvbe = 'TEST_ARE04' spras = 'E' pvbtx = 'Test Area 04 EN' )
      ( werks = '0002' prvbe = 'TEST_ARE04' spras = 'D' pvbtx = 'Test Area 04 DE' )
      ( werks = '0002' prvbe = 'TEST_ARE05' spras = 'E' pvbtx = 'Test Area 05 EN' )
      ( werks = '0002' prvbe = 'TEST_ARE05' spras = 'D' pvbtx = 'Test Area 05 DE' ) ).
    mo_td_cds->insert_test_data( i_data = mt_pvkt ).

    mt_t001w = VALUE #( ( werks = '0002' ) ).
    mo_td_cds->insert_test_data( i_data = mt_t001w ).

    mt_t001l = VALUE #( ( werks = '0002' lgort = '0001' )
    ( werks = '0002' lgort = '0002' )
    ( werks = '0002' lgort = '0003' ) ).
    mo_td_cds->insert_test_data( i_data = mt_t001l ).

    lv_json_file = '{"_comment":"JSON Retrieve All Example for RAP BO R_ProductionSupplyAreaTP"'
      && ',"ignore":"false","fields":[{"name":"StorageLocation","value":"0002"}]}'.

    TRY.
      cl_ptf_json=>deserialize(
        EXPORTING
          iv_entity = 'R_PRODUCTIONSUPPLYAREATP'
          iv_action = 'RETRIEVE_ALL'
          iv_json   = lv_json_file
        IMPORTING
          er_data   = DATA(lr_data)
      ).

      CATCH cx_ptf_json ##NO_HANDLER.
    ENDTRY.

    ASSIGN lr_data->* TO FIELD-SYMBOL(<fs_data>).

*   Prepare the data for dynamic select
    lo_structdescr ?= cl_abap_structdescr=>describe_by_name( 'R_PRODUCTIONSUPPLYAREATP' ).
    CREATE DATA lr_struct TYPE HANDLE lo_structdescr.
    ASSIGN lr_struct->* TO FIELD-SYMBOL(<fs_struct>).

    MOVE-CORRESPONDING <fs_data> TO <fs_struct>.

    ls_sel_data-name      = 'R_PRODUCTIONSUPPLYAREATP'.

*   Create references table
    lo_refdescr ?= cl_abap_refdescr=>describe_by_data( lr_struct ).
    lo_tabledescr = cl_abap_tabledescr=>get( EXPORTING p_line_type = lo_refdescr ).

    CREATE DATA ls_sel_data-data TYPE HANDLE lo_tabledescr.

    ASSIGN ls_sel_data-data->* TO <fs_data_table>.

    APPEND lr_struct TO <fs_data_table>.

    APPEND ls_sel_data TO lt_sel_data.

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->query_bo(
      EXPORTING
        iv_name     = 'R_PRODUCTIONSUPPLYAREATP'
        iv_action   = 'RETRIEVE_ALL'
        it_sel_data = lt_sel_data
      IMPORTING
        er_keys     = DATA(lr_keys)
        ev_error    = DATA(lv_error)
    ).

    ASSIGN lr_keys->* TO FIELD-SYMBOL(<fs_keys>).

    "then
    cl_abap_unit_assert=>assert_equals( act = lines( <fs_keys> ) exp = 3 ).
    cl_abap_unit_assert=>assert_false( act = lv_error ).

  ENDMETHOD.

  METHOD query_bo_w_child.
    DATA lo_cut         TYPE REF TO cl_ptf_rap_key_finder.
    DATA lo_tabledescr  TYPE REF TO cl_abap_tabledescr.
    DATA lo_structdescr TYPE REF TO cl_abap_structdescr.
    DATA lo_refdescr    TYPE REF TO cl_abap_refdescr.
    DATA lr_struct      TYPE REF TO data.
    DATA lt_step_data   TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA lt_sel_data    TYPE cl_ptf_rap_key_finder=>tt_sel_data.
    DATA ls_sel_data    TYPE cl_ptf_rap_key_finder=>ts_sel_data.
    DATA lv_json_file   TYPE string.

    FIELD-SYMBOLS <fs_data_table> TYPE STANDARD TABLE.
    FIELD-SYMBOLS <fs_struct>     TYPE any.

*    "Prepare and insert test data
    mt_pvbe = VALUE #( ( werks = '0002' prvbe = 'TEST_ARE01' lgort = '0001' )
    ( werks = '0002' prvbe = 'TEST_ARE02' lgort = '0002' )
    ( werks = '0002' prvbe = 'TEST_ARE03' lgort = '0002' )
    ( werks = '0002' prvbe = 'TEST_ARE04' lgort = '0002' )
    ( werks = '0002' prvbe = 'TEST_ARE05' lgort = '0003' ) ).
    mo_td_cds->insert_test_data( i_data = mt_pvbe ).

    mt_pvkt = VALUE #( ( werks = '0002' prvbe = 'TEST_ARE01' spras = 'E' pvbtx = 'Test Area 01 EN' )
      ( werks = '0002' prvbe = 'TEST_ARE01' spras = 'D' pvbtx = 'Test Area 01 DE' )
      ( werks = '0002' prvbe = 'TEST_ARE02' spras = 'E' pvbtx = 'Test Area 02 EN' )
      ( werks = '0002' prvbe = 'TEST_ARE02' spras = 'D' pvbtx = 'Test Area 02 DE' )
      ( werks = '0002' prvbe = 'TEST_ARE03' spras = 'E' pvbtx = 'Test Area 03 EN' )
      ( werks = '0002' prvbe = 'TEST_ARE03' spras = 'D' pvbtx = 'Test Area 03 DE' )
      ( werks = '0002' prvbe = 'TEST_ARE03' spras = 'F' pvbtx = 'Test Area 03 FR' )
      ( werks = '0002' prvbe = 'TEST_ARE04' spras = 'E' pvbtx = 'Test Area 04 EN' )
      ( werks = '0002' prvbe = 'TEST_ARE04' spras = 'D' pvbtx = 'Test Area 04 DE' )
      ( werks = '0002' prvbe = 'TEST_ARE04' spras = 'F' pvbtx = 'Test Area 03 FR' )
      ( werks = '0002' prvbe = 'TEST_ARE05' spras = 'E' pvbtx = 'Test Area 05 EN' )
      ( werks = '0002' prvbe = 'TEST_ARE05' spras = 'D' pvbtx = 'Test Area 05 DE' ) ).
    mo_td_cds->insert_test_data( i_data = mt_pvkt ).

    mt_t001w = VALUE #( ( werks = '0002' ) ).
    mo_td_cds->insert_test_data( i_data = mt_t001w ).

    mt_t001l = VALUE #( ( werks = '0002' lgort = '0001' )
    ( werks = '0002' lgort = '0002' )
    ( werks = '0002' lgort = '0003' ) ).
    mo_td_cds->insert_test_data( i_data = mt_t001l ).

    lv_json_file = '{"_comment":"JSON Retrieve All Example for RAP BO R_ProductionSupplyAreaTP"'
      && ',"ignore":"false","fields":[{"name":"StorageLocation","value":"0002"}]'
      && ',"associations":[{"childEntityName":"R_ProductionSupplyAreaTextTP","assocName":"_PRODUCTIONSUPPLYAREATEXT"'
      && ',"fields":[{"name":"LANGUAGE","value":"FR"}]}]}'.

    TRY.
      cl_ptf_json=>deserialize(
        EXPORTING
          iv_entity = 'R_PRODUCTIONSUPPLYAREATP'
          iv_action = 'RETRIEVE_ALL'
          iv_json   = lv_json_file
        IMPORTING
          er_data   = DATA(lr_data)
      ).

      CATCH cx_ptf_json ##NO_HANDLER.
    ENDTRY.

    ASSIGN lr_data->* TO FIELD-SYMBOL(<fs_data>).

*   Prepare the data for dynamic select
    lo_structdescr ?= cl_abap_structdescr=>describe_by_name( 'R_PRODUCTIONSUPPLYAREATP' ).
    CREATE DATA lr_struct TYPE HANDLE lo_structdescr.
    ASSIGN lr_struct->* TO <fs_struct>.

    MOVE-CORRESPONDING <fs_data> TO <fs_struct>.

    ls_sel_data-name      = 'R_PRODUCTIONSUPPLYAREATP'.

*   Create references table
    lo_refdescr ?= cl_abap_refdescr=>describe_by_data( lr_struct ).
    lo_tabledescr = cl_abap_tabledescr=>get( EXPORTING p_line_type = lo_refdescr ).

    CREATE DATA ls_sel_data-data TYPE HANDLE lo_tabledescr.

    ASSIGN ls_sel_data-data->* TO <fs_data_table>.

    APPEND lr_struct TO <fs_data_table>.

    APPEND ls_sel_data TO lt_sel_data.

*   Add child node
    lo_structdescr ?= cl_abap_structdescr=>describe_by_name( 'R_PRODUCTIONSUPPLYAREATEXTTP' ).
    CREATE DATA lr_struct TYPE HANDLE lo_structdescr.
    ASSIGN lr_struct->* TO <fs_struct>.

    ASSIGN COMPONENT 'R_PRODUCTIONSUPPLYAREATEXTTP' OF STRUCTURE <fs_data> TO <fs_data_table>.
    READ TABLE <fs_data_table> ASSIGNING <fs_data> INDEX 1.

    MOVE-CORRESPONDING <fs_data> TO <fs_struct>.

    ls_sel_data-name      = 'R_PRODUCTIONSUPPLYAREATEXTTP'.

*   Create references table
    lo_refdescr ?= cl_abap_refdescr=>describe_by_data( lr_struct ).
    lo_tabledescr = cl_abap_tabledescr=>get( EXPORTING p_line_type = lo_refdescr ).

    CREATE DATA ls_sel_data-data TYPE HANDLE lo_tabledescr.

    ASSIGN ls_sel_data-data->* TO <fs_data_table>.

    APPEND lr_struct TO <fs_data_table>.

    APPEND ls_sel_data TO lt_sel_data.

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    lo_cut = NEW #( lo_ptf_run ).

    "when
    lo_cut->query_bo(
      EXPORTING
        iv_name     = 'R_PRODUCTIONSUPPLYAREATP'
        iv_action   = 'RETRIEVE_ALL'
        it_sel_data = lt_sel_data
      IMPORTING
        er_keys     = DATA(lr_keys)
        ev_error    = DATA(lv_error)
    ).

    ASSIGN lr_keys->* TO FIELD-SYMBOL(<fs_keys>).

    "then
    cl_abap_unit_assert=>assert_equals( act = lines( <fs_keys> ) exp = 2 ).
    cl_abap_unit_assert=>assert_false( act = lv_error ).

  ENDMETHOD.

ENDCLASS.
