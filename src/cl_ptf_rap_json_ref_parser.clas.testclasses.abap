*"* use this source file for your ABAP unit test classes

* Local Test Class for method parse_references
CLASS ltc_parse_references DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    METHODS setup.
    METHODS teardown.

    METHODS params_resultid FOR TESTING.

    DATA mo_cut TYPE REF TO cl_ptf_rap_json_ref_parser.

ENDCLASS.

CLASS ltc_parse_references IMPLEMENTATION.
  METHOD class_setup.

  ENDMETHOD.

  METHOD setup.

  ENDMETHOD.

  METHOD teardown.

  ENDMETHOD.

  METHOD class_teardown.

  ENDMETHOD.

  METHOD params_resultid.
    TYPES: BEGIN OF ts_params,
            param1 TYPE string,
           END OF ts_params,
           BEGIN OF ts_test_data,
            _params TYPE ts_params,
           END OF ts_test_data.

    DATA lt_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA ls_test_data TYPE ts_test_data.
    DATA lv_value     TYPE string VALUE '/Step[1]/%ResultId[1]'.

    ls_test_data-_params-param1 = lv_value.

    APPEND VALUE #( bus_obj = 'ENTITY' step_number = 1 document_id = VALUE #( ( CONV #( |KEY1| ) ) ) ) TO lt_step_data.

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW #( lo_ptf_run ).

    "when
    mo_cut->parse_references(
        EXPORTING
          iv_entity_name    = 'ENTITY'
          iv_step_number    = 2
        IMPORTING
          ev_error          = DATA(lv_error)
        CHANGING
          cs_test_data      = ls_test_data ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_error ).
    cl_abap_unit_assert=>assert_equals( act = ls_test_data-_params-param1 exp = 'KEY1' ).

  ENDMETHOD.

ENDCLASS.

* Local Test Class for method parse_reference
CLASS ltc_parse_reference DEFINITION DEFERRED.
CLASS cl_ptf_rap_json_ref_parser DEFINITION LOCAL FRIENDS ltc_parse_reference.

CLASS ltc_parse_reference DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    METHODS setup.
    METHODS teardown.

    METHODS supply_json_td RETURNING VALUE(rv_json_data) TYPE string.
    METHODS resultid EXPORTING ev_error TYPE abap_bool
                     CHANGING cv_value TYPE string.
    METHODS field_w_line EXPORTING ev_error TYPE abap_bool
                         CHANGING cv_value TYPE string.
    METHODS resultid_pos FOR TESTING.
    METHODS resultid_neg FOR TESTING.
    METHODS field_w_line_index_pos FOR TESTING.
    METHODS field_w_line_index_neg FOR TESTING.
    METHODS field_w_line_free_pos FOR TESTING.
    METHODS field_w_line_free_neg FOR TESTING.
    METHODS field_w_m_line_index_pos FOR TESTING.
    METHODS field_w_m_line_index_neg FOR TESTING.
    METHODS field_w_m_line_free FOR TESTING.
    METHODS field_w_m_line_free_and FOR TESTING.
    METHODS field_w_m_line_free_or FOR TESTING.
    METHODS field_w_neg_step FOR TESTING.

    DATA mo_cut TYPE REF TO cl_ptf_rap_json_ref_parser.

ENDCLASS.

CLASS ltc_parse_reference IMPLEMENTATION.
  METHOD class_setup.

  ENDMETHOD.

  METHOD setup.

  ENDMETHOD.

  METHOD teardown.

  ENDMETHOD.

  METHOD class_teardown.

  ENDMETHOD.

  METHOD supply_json_td.
    rv_json_data = '[{"R_PRODUCTIONSUPPLYAREATEXTTP":[{"_PRODUCTIONSUPPLYAREATEXT":"","LANGUAGE":"EN",'
      && '"PRODUCTIONSUPPLYAREANAME":"Test Area EN Changed with key in parent","PRODUCTIONSUPPLYAREA":"","PLANT":"",'
      && '"_IGNORE":"","_IS_EXISTING":"X","_OPERATORS":{"LANGUAGE":"=","PRODUCTIONSUPPLYAREANAME":"="},'
      && '"_INITIALS":{"LANGUAGE":"","PRODUCTIONSUPPLYAREANAME":""}},'
      && '{"_PRODUCTIONSUPPLYAREATEXT":"","LANGUAGE":"DE",'
      && '"PRODUCTIONSUPPLYAREANAME":"Test Area DE Changed with key in parent","PRODUCTIONSUPPLYAREA":"","PLANT":"",'
      && '"_IGNORE":"","_IS_EXISTING":"X","_OPERATORS":{"LANGUAGE":"=","PRODUCTIONSUPPLYAREANAME":"="},"_INITIALS":{"LANGUAGE":"",'
      && '"PRODUCTIONSUPPLYAREANAME":""}}],"PRODUCTIONSUPPLYAREA":"TEST_ARE01","PLANT":"0001","STORAGELOCATION":"0002",'
      && '"_OPERATORS":{"PRODUCTIONSUPPLYAREA":"=","PLANT":"=","STORAGELOCATION":"="},"_INITIALS":{"PRODUCTIONSUPPLYAREA":"",'
      && '"PLANT":"","STORAGELOCATION":""}},'
      && '{"R_PRODUCTIONSUPPLYAREATEXTTP":[{"_PRODUCTIONSUPPLYAREATEXT":"","LANGUAGE":"EN",'
      && '"PRODUCTIONSUPPLYAREANAME":"Test Area EN Changed with key in parent","PRODUCTIONSUPPLYAREA":"","PLANT":"",'
      && '"_IGNORE":"","_IS_EXISTING":"X","_OPERATORS":{"LANGUAGE":"=","PRODUCTIONSUPPLYAREANAME":"="},'
      && '"_INITIALS":{"LANGUAGE":"","PRODUCTIONSUPPLYAREANAME":""}},'
      && '{"_PRODUCTIONSUPPLYAREATEXT":"","LANGUAGE":"DE",'
      && '"PRODUCTIONSUPPLYAREANAME":"Test Area DE Changed with key in parent","PRODUCTIONSUPPLYAREA":"","PLANT":"",'
      && '"_IGNORE":"","_IS_EXISTING":"X","_OPERATORS":{"LANGUAGE":"=","PRODUCTIONSUPPLYAREANAME":"="},"_INITIALS":{"LANGUAGE":"",'
      && '"PRODUCTIONSUPPLYAREANAME":""}}],"PRODUCTIONSUPPLYAREA":"TEST_ARE02","PLANT":"0002","STORAGELOCATION":"0002",'
      && '"_OPERATORS":{"PRODUCTIONSUPPLYAREA":"=","PLANT":"=","STORAGELOCATION":"="},"_INITIALS":{"PRODUCTIONSUPPLYAREA":"",'
      && '"PLANT":"","STORAGELOCATION":""}},'
      && '{"R_PRODUCTIONSUPPLYAREATEXTTP":[{"_PRODUCTIONSUPPLYAREATEXT":"","LANGUAGE":"EN",'
      && '"PRODUCTIONSUPPLYAREANAME":"Test Area EN Changed with key in parent","PRODUCTIONSUPPLYAREA":"","PLANT":"",'
      && '"_IGNORE":"","_IS_EXISTING":"X","_OPERATORS":{"LANGUAGE":"=","PRODUCTIONSUPPLYAREANAME":"="},'
      && '"_INITIALS":{"LANGUAGE":"","PRODUCTIONSUPPLYAREANAME":""}},'
      && '{"_PRODUCTIONSUPPLYAREATEXT":"","LANGUAGE":"DE",'
      && '"PRODUCTIONSUPPLYAREANAME":"Test Area DE Changed with key in parent","PRODUCTIONSUPPLYAREA":"","PLANT":"",'
      && '"_IGNORE":"","_IS_EXISTING":"X","_OPERATORS":{"LANGUAGE":"=","PRODUCTIONSUPPLYAREANAME":"="},"_INITIALS":{"LANGUAGE":"",'
      && '"PRODUCTIONSUPPLYAREANAME":""}}],"PRODUCTIONSUPPLYAREA":"TEST_ARE03","PLANT":"0004","STORAGELOCATION":"0003",'
      && '"_OPERATORS":{"PRODUCTIONSUPPLYAREA":"=","PLANT":"=","STORAGELOCATION":"="},"_INITIALS":{"PRODUCTIONSUPPLYAREA":"",'
      && '"PLANT":"","STORAGELOCATION":""}}]'.

  ENDMETHOD.

  METHOD resultid.
    DATA lt_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.

    CLEAR ev_error.

    APPEND VALUE #( bus_obj = 'R_PRODUCTIONSUPPLYAREATP' step_number = 1 document_id = VALUE #( ( CONV #( |TEST_ARE01{ cl_ptf_util=>gc_key_field_delimiter }0001| ) ) ) ) TO lt_step_data.

    APPEND VALUE #( bus_obj = 'R_PRODUCTIONSUPPLYAREATP' step_number = 2
                    document_id = VALUE #(
                       ( CONV #( |TEST_ARE02{ cl_ptf_util=>gc_key_field_delimiter }0001| ) )
                       ( CONV #( |TEST_ARE03{ cl_ptf_util=>gc_key_field_delimiter }0001| ) )
                       ( CONV #( |TEST_ARE04{ cl_ptf_util=>gc_key_field_delimiter }0001| ) )
                    ) ) TO lt_step_data.

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW #( lo_ptf_run ).

    "when
    mo_cut->parse_reference(
      EXPORTING
        iv_entity_name    = 'R_PRODUCTIONSUPPLYAREATP'
        iv_name           = 'PRODUCTIONSUPPLYAREA'
        iv_step_number    = 3
      IMPORTING
        ev_error          = ev_error
      CHANGING
        cv_value          = cv_value ).

  ENDMETHOD.

  METHOD resultid_pos.
    DATA lv_value     TYPE string VALUE '/Step[2]/%ResultId[3]+0(10)'.

    me->resultid(
      IMPORTING
        ev_error = DATA(lv_error)
      CHANGING
        cv_value = lv_value
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_error ).
    cl_abap_unit_assert=>assert_equals( act = lv_value exp = 'TEST_ARE04' ).

  ENDMETHOD.

  METHOD resultid_neg.
    DATA lv_value     TYPE string VALUE '/Step[2]/%ResultId[4]+0(10)'.

    me->resultid(
      IMPORTING
        ev_error = DATA(lv_error)
      CHANGING
        cv_value = lv_value
    ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_error ).

  ENDMETHOD.

  METHOD field_w_line.
    DATA lt_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.

    CLEAR ev_error.

    APPEND VALUE #( bus_obj = 'R_PRODUCTIONSUPPLYAREATP' ) TO lt_step_data.

    APPEND VALUE #( bus_obj = 'R_PRODUCTIONSUPPLYAREATP'
      data_object_json = me->supply_json_td( ) ) TO lt_step_data.

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW #( lo_ptf_run ).

    "when
    mo_cut->parse_reference(
      EXPORTING
        iv_entity_name    = 'R_PRODUCTIONSUPPLYAREATP'
        iv_name           = 'PRODUCTIONSUPPLYAREA'
        iv_step_number    = 3
      IMPORTING
        ev_error          = ev_error
      CHANGING
        cv_value          = cv_value ).

  ENDMETHOD.

  METHOD field_w_line_index_pos.
    DATA lv_value     TYPE string VALUE '/Step[2]/R_PRODUCTIONSUPPLYAREATP[1]/R_PRODUCTIONSUPPLYAREATEXTTP[2]/Language'.

    me->field_w_line(
      IMPORTING
        ev_error = DATA(lv_error)
      CHANGING
        cv_value = lv_value
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_error ).
    cl_abap_unit_assert=>assert_equals( act = lv_value exp = 'DE' ).

  ENDMETHOD.

  METHOD field_w_line_index_neg.
    DATA lv_value     TYPE string VALUE '/Step[2]/R_PRODUCTIONSUPPLYAREATP[1]/R_PRODUCTIONSUPPLYAREATEXTTP[3]/Language'.

    me->field_w_line(
      IMPORTING
        ev_error = DATA(lv_error)
      CHANGING
        cv_value = lv_value
    ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_error ).

  ENDMETHOD.

  METHOD field_w_line_free_pos.
    DATA lv_value     TYPE string VALUE `/Step[2]/R_PRODUCTIONSUPPLYAREATP[1]/R_PRODUCTIONSUPPLYAREATEXTTP[language = 'DE']/Language`.

    me->field_w_line(
      IMPORTING
        ev_error = DATA(lv_error)
      CHANGING
        cv_value = lv_value
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_error ).
    cl_abap_unit_assert=>assert_equals( act = lv_value exp = 'DE' ).

  ENDMETHOD.

  METHOD field_w_line_free_neg.
    DATA lv_value     TYPE string VALUE `/Step[2]/R_PRODUCTIONSUPPLYAREATP[1]/R_PRODUCTIONSUPPLYAREATEXTTP[language = 'FR']/Language`.

    me->field_w_line(
      IMPORTING
        ev_error = DATA(lv_error)
      CHANGING
        cv_value = lv_value
    ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_error ).

  ENDMETHOD.

  METHOD field_w_m_line_index_pos.
    DATA lv_value     TYPE string VALUE '/Step[2]/R_PRODUCTIONSUPPLYAREATP[2]/R_PRODUCTIONSUPPLYAREATEXTTP[1]/Language'.

    me->field_w_line(
      IMPORTING
        ev_error = DATA(lv_error)
      CHANGING
        cv_value = lv_value
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_error ).
    cl_abap_unit_assert=>assert_equals( act = lv_value exp = 'EN' ).

  ENDMETHOD.

  METHOD field_w_m_line_index_neg.
    DATA lv_value     TYPE string VALUE '/Step[2]/R_PRODUCTIONSUPPLYAREATP[2]/R_PRODUCTIONSUPPLYAREATEXTTP[3]/Language'.

    me->field_w_line(
      IMPORTING
        ev_error = DATA(lv_error)
      CHANGING
        cv_value = lv_value
    ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_error ).

  ENDMETHOD.

  METHOD field_w_m_line_free.
    DATA lv_value     TYPE string VALUE `/Step[2]/R_PRODUCTIONSUPPLYAREATP[ProductionSupplyArea = 'TEST_ARE02']/R_PRODUCTIONSUPPLYAREATEXTTP[language = 'DE']/Language`.

    me->field_w_line(
      IMPORTING
        ev_error = DATA(lv_error)
      CHANGING
        cv_value = lv_value
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_error ).
    cl_abap_unit_assert=>assert_equals( act = lv_value exp = 'DE' ).

  ENDMETHOD.

  METHOD field_w_m_line_free_and.
    DATA lv_value     TYPE string VALUE `/Step[2]/R_PRODUCTIONSUPPLYAREATP[Plant = '0002' AND StorageLocation = '0002']/ProductionSupplyArea`.

    me->field_w_line(
      IMPORTING
        ev_error = DATA(lv_error)
      CHANGING
        cv_value = lv_value
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_error ).
    cl_abap_unit_assert=>assert_equals( act = lv_value exp = 'TEST_ARE02' ).

  ENDMETHOD.

  METHOD field_w_m_line_free_or.
    DATA lv_value     TYPE string VALUE `/Step[2]/R_PRODUCTIONSUPPLYAREATP[Plant = '0004' OR StorageLocation = '0003']/ProductionSupplyArea`.

    me->field_w_line(
      IMPORTING
        ev_error = DATA(lv_error)
      CHANGING
        cv_value = lv_value
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_error ).
    cl_abap_unit_assert=>assert_equals( act = lv_value exp = 'TEST_ARE03' ).

  ENDMETHOD.

  METHOD field_w_neg_step.
    DATA lv_value     TYPE string VALUE `/Step[-1]/R_PRODUCTIONSUPPLYAREATP[ProductionSupplyArea = 'TEST_ARE02']/R_PRODUCTIONSUPPLYAREATEXTTP[language = 'DE']/Language`.

    me->field_w_line(
      IMPORTING
        ev_error = DATA(lv_error)
      CHANGING
        cv_value = lv_value
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_error ).
    cl_abap_unit_assert=>assert_equals( act = lv_value exp = 'DE' ).

  ENDMETHOD.

ENDCLASS.

CLASS ltc_parse_system_variable DEFINITION DEFERRED.
CLASS cl_ptf_rap_json_ref_parser DEFINITION LOCAL FRIENDS ltc_parse_system_variable.

CLASS ltc_parse_system_variable DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    METHODS setup.
    METHODS teardown.

    METHODS parse_system_variable EXPORTING ev_error TYPE abap_bool
                                  CHANGING cv_value TYPE string.

    METHODS sy_uname FOR TESTING.
    METHODS sy_datum FOR TESTING.
    METHODS sy_uname_offset_length FOR TESTING.
    METHODS sy_datum_addition FOR TESTING.
    METHODS sy_datum_subtraction FOR TESTING.
    METHODS sy_dummy FOR TESTING.

    DATA mo_cut TYPE REF TO cl_ptf_rap_json_ref_parser.
ENDCLASS.

CLASS ltc_parse_system_variable IMPLEMENTATION.
  METHOD class_setup.

  ENDMETHOD.

  METHOD setup.

  ENDMETHOD.

  METHOD teardown.

  ENDMETHOD.

  METHOD class_teardown.

  ENDMETHOD.

  METHOD parse_system_variable.
    DATA lt_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.

    CLEAR ev_error.

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW #( lo_ptf_run ).

    "when
    mo_cut->parse_system_variable(
      EXPORTING
        iv_entity_name    = 'ENTITY'
        iv_name           = 'FIELD'
      IMPORTING
        ev_error          = ev_error
      CHANGING
        cv_value          = cv_value ).

  ENDMETHOD.

  METHOD sy_uname.
    DATA lv_value     TYPE string VALUE '%sy-uname'.

    me->parse_system_variable(
      IMPORTING
        ev_error = DATA(lv_error)
      CHANGING
        cv_value = lv_value
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_error ).
    cl_abap_unit_assert=>assert_equals( act = lv_value exp = sy-uname ).

  ENDMETHOD.

  METHOD sy_datum.
    DATA lv_value     TYPE string VALUE '%sy-datum'.

    me->parse_system_variable(
      IMPORTING
        ev_error = DATA(lv_error)
      CHANGING
        cv_value = lv_value
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_error ).
    cl_abap_unit_assert=>assert_equals( act = lv_value exp = sy-datum ).

  ENDMETHOD.

  METHOD sy_uname_offset_length.
    DATA lv_value     TYPE string VALUE '%sy-uname+1(2)'.

    me->parse_system_variable(
      IMPORTING
        ev_error = DATA(lv_error)
      CHANGING
        cv_value = lv_value
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_error ).
    cl_abap_unit_assert=>assert_equals( act = lv_value exp = sy-uname+1(2) ).

  ENDMETHOD.

  METHOD sy_datum_addition.
    DATA lv_value     TYPE string VALUE '%sy-datum  + 14'.
    DATA lv_datum     TYPE d.
    DATA lv_exp       TYPE string.

    lv_datum = sy-datum + 14.
    lv_exp   = lv_datum.

    me->parse_system_variable(
      IMPORTING
        ev_error = DATA(lv_error)
      CHANGING
        cv_value = lv_value
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_error ).
    cl_abap_unit_assert=>assert_equals( act = lv_value exp = lv_exp ).

  ENDMETHOD.

  METHOD sy_datum_subtraction.
    DATA lv_value     TYPE string VALUE '%sy-datum  - 5'.
    DATA lv_datum     TYPE d.
    DATA lv_exp       TYPE string.

    lv_datum = sy-datum - 5.
    lv_exp   = lv_datum.

    me->parse_system_variable(
      IMPORTING
        ev_error = DATA(lv_error)
      CHANGING
        cv_value = lv_value
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_error ).
    cl_abap_unit_assert=>assert_equals( act = lv_value exp = lv_exp ).

  ENDMETHOD.

  METHOD sy_dummy.
    DATA lv_value     TYPE string VALUE '%sy-dummy'.

    me->parse_system_variable(
      IMPORTING
        ev_error = DATA(lv_error)
      CHANGING
        cv_value = lv_value
    ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_error ).

  ENDMETHOD.

ENDCLASS.

CLASS ltc_get_other_reference DEFINITION DEFERRED.
CLASS cl_ptf_rap_json_ref_parser DEFINITION LOCAL FRIENDS ltc_get_other_reference.

CLASS ltc_get_other_reference DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    METHODS setup.
    METHODS teardown.

    METHODS one_instance_no_index FOR TESTING.
    METHODS m_instances_no_index FOR TESTING.

    DATA mo_cut TYPE REF TO cl_ptf_rap_json_ref_parser.

ENDCLASS.

CLASS ltc_get_other_reference IMPLEMENTATION.
  METHOD class_setup.

  ENDMETHOD.

  METHOD setup.

  ENDMETHOD.

  METHOD teardown.

  ENDMETHOD.

  METHOD class_teardown.

  ENDMETHOD.

  METHOD one_instance_no_index.
    DATA lr_data      TYPE REF TO data.
    DATA lt_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA ls_step_data TYPE cl_ptf_util=>gt_ptf_step.

    ls_step_data = VALUE #( bus_obj = 'R_PRODUCTIONSUPPLYAREATP' action = 'CREATE' step_number = 1
      data_object_json = '{"R_PRODUCTIONSUPPLYAREATEXTTP":[{"_PRODUCTIONSUPPLYAREATEXT":"","LANGUAGE":"EN",'
        && '"PRODUCTIONSUPPLYAREANAME":"Test Area EN","PRODUCTIONSUPPLYAREA":"","PLANT":"","_IGNORE":"","_IS_EXISTING":"X",'
        && '"_OPERATORS":{"LANGUAGE":"=","PRODUCTIONSUPPLYAREANAME":"="},"_INITIALS":{"LANGUAGE":"","PRODUCTIONSUPPLYAREANAME":""}},'
        && '{"_PRODUCTIONSUPPLYAREATEXT":"","LANGUAGE":"DE","PRODUCTIONSUPPLYAREANAME":"Test Area DE","PRODUCTIONSUPPLYAREA":"",'
        && '"PLANT":"","_IGNORE":"","_IS_EXISTING":"X","_OPERATORS":{"LANGUAGE":"=","PRODUCTIONSUPPLYAREANAME":"="},'
        && '"_INITIALS":{"LANGUAGE":"","PRODUCTIONSUPPLYAREANAME":""}}],"PRODUCTIONSUPPLYAREA":"TEST_ARE01","PLANT":"0001",'
        && '"STORAGELOCATION":"0001","_IGNORE":"","_IS_EXISTING":"X","%PID":"","_OPERATORS":{"PRODUCTIONSUPPLYAREA":"=",'
        && '"PLANT":"=","STORAGELOCATION":"="},"_INITIALS":{"PRODUCTIONSUPPLYAREA":"","PLANT":"","STORAGELOCATION":""}}' ).

    APPEND ls_step_data TO lt_step_data.

    ls_step_data = VALUE #( bus_obj = 'R_PRODUCTIONSUPPLYAREATP' action = 'RETRIEVE_ALL' step_number = 2
      json_file = '{"_comment":"JSON Retrieve All Example for RAP BO R_ProductionSupplyAreaTP"'
        && ',"ignore":"false","fields":[{"name":"PRODUCTIONSUPPLYAREA","value":"/Step[1]/R_PRODUCTIONSUPPLYAREA/PRODUCTIONSUPPLYAREA"}]}' ).

    APPEND ls_step_data TO lt_step_data.

    ls_step_data = lt_step_data[ 1 ].

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW #( lo_ptf_run ).

    mo_cut->get_other_reference(
      EXPORTING
        iv_entity_name    = 'R_PRODUCTIONSUPPLYAREATP'
        iv_name           = 'PRODUCTIONSUPPLYAREA'
        iv_component_name = 'R_PRODUCTIONSUPPLYAREATP'
        iv_line_index     = 0
        iv_free_key       = space
        iv_param          = space
        is_step_data      = ls_step_data
      IMPORTING
        er_data           = lr_data
        ev_error          = DATA(lv_error)
    ).

    ASSIGN lr_data->* TO FIELD-SYMBOL(<fs_data>).
    ASSIGN COMPONENT 'PRODUCTIONSUPPLYAREA' OF STRUCTURE <fs_data> TO FIELD-SYMBOL(<fs_productionsupplyarea>).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_error ).
    cl_abap_unit_assert=>assert_equals( act = <fs_productionsupplyarea>->* exp = 'TEST_ARE01' ).

  ENDMETHOD.

  METHOD m_instances_no_index.
    DATA lr_data      TYPE REF TO data.
    DATA lt_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA ls_step_data TYPE cl_ptf_util=>gt_ptf_step.

    ls_step_data = VALUE #( bus_obj = 'R_PRODUCTIONSUPPLYAREATP' action = 'CREATE' step_number = 1
      data_object_json = '[{"R_PRODUCTIONSUPPLYAREATEXTTP":[{"_PRODUCTIONSUPPLYAREATEXT":"","LANGUAGE":"EN",'
        && '"PRODUCTIONSUPPLYAREANAME":"Test Area EN","PRODUCTIONSUPPLYAREA":"","PLANT":"","_IGNORE":"","_IS_EXISTING":"X",'
        && '"_OPERATORS":{"LANGUAGE":"=","PRODUCTIONSUPPLYAREANAME":"="},"_INITIALS":{"LANGUAGE":"","PRODUCTIONSUPPLYAREANAME":""}},'
        && '{"_PRODUCTIONSUPPLYAREATEXT":"","LANGUAGE":"DE","PRODUCTIONSUPPLYAREANAME":"Test Area DE","PRODUCTIONSUPPLYAREA":"",'
        && '"PLANT":"","_IGNORE":"","_IS_EXISTING":"X","_OPERATORS":{"LANGUAGE":"=","PRODUCTIONSUPPLYAREANAME":"="},'
        && '"_INITIALS":{"LANGUAGE":"","PRODUCTIONSUPPLYAREANAME":""}}],"PRODUCTIONSUPPLYAREA":"TEST_ARE01","PLANT":"0001",'
        && '"STORAGELOCATION":"0001","_IGNORE":"","_IS_EXISTING":"X","%PID":"","_OPERATORS":{"PRODUCTIONSUPPLYAREA":"=",'
        && '"PLANT":"=","STORAGELOCATION":"="},"_INITIALS":{"PRODUCTIONSUPPLYAREA":"","PLANT":"","STORAGELOCATION":""}},'
        && '{"R_PRODUCTIONSUPPLYAREATEXTTP":[{"_PRODUCTIONSUPPLYAREATEXT":"","LANGUAGE":"EN",'
        && '"PRODUCTIONSUPPLYAREANAME":"Test Area EN","PRODUCTIONSUPPLYAREA":"","PLANT":"","_IGNORE":"","_IS_EXISTING":"X",'
        && '"_OPERATORS":{"LANGUAGE":"=","PRODUCTIONSUPPLYAREANAME":"="},"_INITIALS":{"LANGUAGE":"","PRODUCTIONSUPPLYAREANAME":""}},'
        && '{"_PRODUCTIONSUPPLYAREATEXT":"","LANGUAGE":"DE","PRODUCTIONSUPPLYAREANAME":"Test Area DE","PRODUCTIONSUPPLYAREA":"",'
        && '"PLANT":"","_IGNORE":"","_IS_EXISTING":"X","_OPERATORS":{"LANGUAGE":"=","PRODUCTIONSUPPLYAREANAME":"="},'
        && '"_INITIALS":{"LANGUAGE":"","PRODUCTIONSUPPLYAREANAME":""}}],"PRODUCTIONSUPPLYAREA":"TEST_ARE02","PLANT":"0001",'
        && '"STORAGELOCATION":"0001","_IGNORE":"","_IS_EXISTING":"X","%PID":"","_OPERATORS":{"PRODUCTIONSUPPLYAREA":"=",'
        && '"PLANT":"=","STORAGELOCATION":"="},"_INITIALS":{"PRODUCTIONSUPPLYAREA":"","PLANT":"","STORAGELOCATION":""}}]' ).

    APPEND ls_step_data TO lt_step_data.

    ls_step_data = VALUE #( bus_obj = 'R_PRODUCTIONSUPPLYAREATP' action = 'RETRIEVE_ALL' step_number = 2
      json_file = '{"_comment":"JSON Retrieve All Example for RAP BO R_ProductionSupplyAreaTP"'
        && ',"ignore":"false","fields":[{"name":"PRODUCTIONSUPPLYAREA","value":"/Step[1]/R_PRODUCTIONSUPPLYAREA/PRODUCTIONSUPPLYAREA"}]}' ).

    APPEND ls_step_data TO lt_step_data.

    ls_step_data = lt_step_data[ 1 ].

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW #( lo_ptf_run ).

    mo_cut->get_other_reference(
      EXPORTING
        iv_entity_name    = 'R_PRODUCTIONSUPPLYAREATP'
        iv_name           = 'PRODUCTIONSUPPLYAREA'
        iv_component_name = 'R_PRODUCTIONSUPPLYAREATP'
        iv_line_index     = 0
        iv_free_key       = space
        iv_param          = space
        is_step_data      = ls_step_data
      IMPORTING
        er_data           = lr_data
        ev_error          = DATA(lv_error)
    ).

    ASSIGN lr_data->* TO FIELD-SYMBOL(<fs_data>).
    ASSIGN COMPONENT 'PRODUCTIONSUPPLYAREA' OF STRUCTURE <fs_data> TO FIELD-SYMBOL(<fs_productionsupplyarea>).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_error ).
    cl_abap_unit_assert=>assert_equals( act = <fs_productionsupplyarea>->* exp = 'TEST_ARE01' ).

  ENDMETHOD.

ENDCLASS.
