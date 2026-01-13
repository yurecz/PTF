*"* use this source file for your ABAP unit test classes

CLASS ltc_execute DEFINITION FOR TESTING
  RISK LEVEL CRITICAL  "not isolated, PTF might execute given steps including db access
  DURATION SHORT.

  PRIVATE SECTION.

    DATA mo_cut TYPE REF TO cl_ptf_run.

*    CLASS-METHODS class_setup.
*    CLASS-METHODS class_teardown.
    METHODS setup.
    METHODS teardown.

    METHODS failing_check_step FOR TESTING.

ENDCLASS.

CLASS ltc_execute IMPLEMENTATION.

  METHOD setup.
    FREE MEMORY ID 'PTF_RUNS'.
  ENDMETHOD.
  METHOD teardown.
    FREE MEMORY ID 'PTF_RUNS'.
  ENDMETHOD.

  METHOD failing_check_step.

    CONSTANTS lc_run_failed TYPE sysubrc VALUE '1'.

    DATA lt_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA ls_run_head  TYPE cl_ptf_util=>ty_run_head.

    DATA(lo_mem) = NEW cl_ptf_abap_memory( ).
    ls_run_head-run_uuid   = 'AUNIT_ISOLATED'.
    ls_run_head-start_date = sy-datum.
    ls_run_head-start_time = sy-uzeit.
    ls_run_head-user       = sy-uname.
    lo_mem->insert_run_head( ls_run_head ).

    lt_step_data = VALUE #(
                             ( step_number = 1 bus_obj = 'EBDR'    action = 'CREATE' )                                                       "without TDCV, step 1 will fail
                             ( step_number = 2 bus_obj = 'EBDR'    action = 'CHECK'   reference_step = VALUE #( ( 1 ) )   check_flag = 'X' ) "as there is no docID from step 1, check-step 2 will fail and end the run
                             ( step_number = 3 bus_obj = 'OR'      action = 'CREATE' )
                             "( step_number = 4 bus_obj = 'INVOICE' action = 'CREATE'  reference_step = VALUE #( ( 1 ) )     )
                          ).

    mo_cut = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    mo_cut->execute(
      EXPORTING
        iv_run_uuid   = 'AUNIT_ISOLATED'
      IMPORTING
        ev_step_index = DATA(index)
        ev_log_status = DATA(status)
    ).

    cl_abap_unit_assert=>assert_equals( exp = lc_run_failed  act = status ).

  ENDMETHOD.

ENDCLASS.


CLASS lth_get_result_key_data_tc2 DEFINITION FINAL FOR TESTING.

  PUBLIC SECTION.

    TYPES: ty_i_tab TYPE STANDARD TABLE OF i.
    DATA mo_cut TYPE REF TO cl_ptf_run.

    CLASS-METHODS:

      call_and_validte_single_result
        IMPORTING
          step_number_table TYPE ty_i_tab
          bus_obj           TYPE ptf_bo
          action            TYPE ptf_act OPTIONAL "not used, only for semantic context
          document_id_table TYPE cl_ptf_util=>ty_vbeln_tab
          first_key_value_1 TYPE string OPTIONAL
          first_key_value_2 TYPE string OPTIONAL,

      call_and_validte_multi_result
        IMPORTING
          step_number_table TYPE ty_i_tab
          bus_obj           TYPE ptf_bo
          action            TYPE ptf_act OPTIONAL, "not used, only for semantic context
*          document_id_table TYPE cl_ptf_util=>ty_vbeln_tab

      call_and_validte_w_o_ref
        IMPORTING
          step_number_table TYPE ty_i_tab
          bus_obj           TYPE ptf_bo
          action            TYPE ptf_act OPTIONAL"not used, only for semantic context
          document_id_table TYPE cl_ptf_util=>ty_vbeln_tab,


      validate_fields
        IMPORTING
          step_number_table TYPE ty_i_tab
          bus_obj           TYPE ptf_bo
          document_id_table TYPE cl_ptf_util=>ty_vbeln_tab
          it_result         TYPE cl_ptf_util=>ty_result_key_data_tab,

      validate_data_ref
        IMPORTING
          step_index        TYPE i
          document_id_table TYPE cl_ptf_util=>ty_vbeln_tab OPTIONAL
          bus_obj           TYPE ptf_bo
          first_key_value_1 TYPE string OPTIONAL
          first_key_value_2 TYPE string OPTIONAL
          it_result         TYPE cl_ptf_util=>ty_result_key_data_tab,

      validate_for_example_bos
        IMPORTING
          step_number_table TYPE ty_i_tab
          bus_obj           TYPE ptf_bo
          document_id_table TYPE cl_ptf_util=>ty_vbeln_tab
          it_result         TYPE cl_ptf_util=>ty_result_key_data_tab.

ENDCLASS.


CLASS lth_get_result_key_data_tc2 IMPLEMENTATION.
  METHOD call_and_validte_single_result.

    "GIVEN
    ASSERT step_number_table IS NOT INITIAL.
    DATA(lo_cut) = NEW cl_ptf_run( VALUE cl_ptf_util=>gt_ptf_step_tab( ( step_number = step_number_table[ 1 ] bus_obj = bus_obj action = action document_id = document_id_table ) ) ).

    "WHEN
    DATA(lt_result) = lo_cut->get_result_key_data( step_number_table ). "VALUE #( ( step_number ) ) ).

    "THEN


    "validate components bus_obj, step_number, document_id_char70
    validate_fields(
     EXPORTING
      step_number_table = step_number_table
      bus_obj           = bus_obj
      document_id_table = document_id_table
      it_result         = lt_result
     ).

    "validate component document_id_key_type
    validate_data_ref(
    EXPORTING
          step_index        = 1
          bus_obj           = bus_obj
          document_id_table = document_id_table
          first_key_value_1 = first_key_value_1
          first_key_value_2 = first_key_value_2
          it_result         = lt_result
    ).

    validate_for_example_bos(
      EXPORTING
        step_number_table = step_number_table
        bus_obj           = bus_obj
        document_id_table = document_id_table
        it_result         = lt_result
    ).

  ENDMETHOD.

  METHOD call_and_validte_multi_result.

    "GIVEN
    ASSERT lines( step_number_table ) GT 1.
*    DATA(lo_cut) = NEW cl_ptf_run(
*     VALUE cl_ptf_util=>gt_ptf_step_tab( FOR refstep IN step_number_table (
*      VALUE #( step_number = sy-tabix bus_obj = bus_obj action = action
*             document_id = VALUE #( ( vbeln = refstep && '00' ) )
*              )  ) )
*     ).
    DATA(lo_cut) = NEW cl_ptf_run(
      VALUE cl_ptf_util=>gt_ptf_step_tab(
        FOR i = 1 THEN i + 1 WHILE i LE lines( step_number_table )
          ( step_number = i
            bus_obj = bus_obj
            action = action
            document_id = VALUE #( ( vbeln = i && '00' ) )
           )
      )
    ).

    "WHEN
    DATA(lt_result) = lo_cut->get_result_key_data( step_number_table ).

    "THEN

    cl_abap_unit_assert=>assert_equals( act = lines( lt_result ) exp = lines( step_number_table ) ).

    LOOP AT lt_result REFERENCE INTO DATA(lr_result).
      DATA(l_tabix) = sy-tabix.

      "validate components bus_obj, step_number, document_id_char70
      cl_abap_unit_assert=>assert_equals( act = lr_result->bus_obj  exp = bus_obj  ).
      cl_abap_unit_assert=>assert_equals( act = lr_result->step_number exp = step_number_table[ l_tabix ] ). "compares order of result step numbers with order of given step numbers
      cl_abap_unit_assert=>assert_equals( act = lr_result->document_id_char70 exp = lr_result->step_number && '00' ).

      "validate component document_id_key_type
      validate_data_ref(
      EXPORTING
            step_index        = l_tabix
            bus_obj           = bus_obj
*            document_id_table = document_id_table
            it_result         = lt_result
      ).
    ENDLOOP.


  ENDMETHOD.

  METHOD call_and_validte_w_o_ref.

    "GIVEN
    DATA(lo_cut) = NEW cl_ptf_run( VALUE cl_ptf_util=>gt_ptf_step_tab( ( step_number = step_number_table[ 1 ] bus_obj = bus_obj action = action document_id = document_id_table ) ) ).
    "WHEN
    DATA(lt_result) = lo_cut->get_result_key_data( step_number_table ).

    "THEN

    "validate components bus_obj, step_number, document_id_char70
    validate_fields(
     EXPORTING
      step_number_table = step_number_table
      bus_obj           = bus_obj
      document_id_table = document_id_table
      it_result         = lt_result ).

    cl_abap_unit_assert=>assert_not_bound( lt_result[ 1 ]-document_id_key_type ).

  ENDMETHOD.


  METHOD validate_fields.
    cl_abap_unit_assert=>assert_equals( act = lines( it_result ) exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = it_result[ 1 ]-bus_obj  exp = bus_obj  ).
    cl_abap_unit_assert=>assert_equals( act = it_result[ 1 ]-step_number exp = step_number_table[ 1 ] ).
    cl_abap_unit_assert=>assert_equals( act = it_result[ 1 ]-document_id_char70 exp = document_id_table[ 1 ] ).
  ENDMETHOD.

  METHOD validate_data_ref.

    DATA one_string TYPE string.
    DATA lo_structdescr TYPE REF TO cl_abap_structdescr.

    DATA(lr_key_structure) = it_result[ step_index ]-document_id_key_type.
    cl_abap_unit_assert=>assert_bound( lr_key_structure ).

    "Validate that there is at least one key field and that all key fields are filled
    lo_structdescr ?= cl_abap_structdescr=>describe_by_data_ref( lr_key_structure ).
    DATA(lt_field) = lo_structdescr->get_components( ).
    cl_abap_unit_assert=>assert_not_initial( lt_field ).
    LOOP AT lt_field INTO DATA(ls_field).
      ASSIGN COMPONENT sy-tabix OF STRUCTURE lr_key_structure->* TO FIELD-SYMBOL(<component>).
      cl_abap_unit_assert=>assert_not_initial( <component> ).
      one_string = one_string && <component>.
    ENDLOOP.
    "Validate full key concatenated out of key field values
    cl_abap_unit_assert=>assert_equals( act = lr_key_structure->* exp = one_string ).

    "Validate full key without delimiters
    IF document_id_table IS SUPPLIED.
      DATA id TYPE cl_ptf_util=>ty_vbeln.
      id = document_id_table[ step_index ]-vbeln.
      REPLACE ALL OCCURRENCES OF '|' IN id WITH ''
       REPLACEMENT COUNT DATA(cnt_delimiters) .
      cl_abap_unit_assert=>assert_equals( act = lines( lt_field ) - 1  exp = cnt_delimiters ).
      cl_abap_unit_assert=>assert_equals( act = lr_key_structure->* exp = id ).
    ENDIF.

    "Validate values for 2 field keys
    CHECK first_key_value_1 IS SUPPLIED.
    IF lines( lt_field ) = 2.
      "Validate key field values
      ASSIGN COMPONENT 1 OF STRUCTURE lr_key_structure->* TO <component>.
      cl_abap_unit_assert=>assert_equals( act = <component> exp = first_key_value_1 ).
      ASSIGN COMPONENT 2 OF STRUCTURE lr_key_structure->* TO <component>.
      cl_abap_unit_assert=>assert_equals( act = <component> exp = first_key_value_2 ).
    ENDIF.

  ENDMETHOD.

  METHOD validate_for_example_bos.

    DATA lo_structdescr TYPE REF TO cl_abap_structdescr.

    DATA(lr_key_structure) = it_result[ 1 ]-document_id_key_type.

    ASSIGN COMPONENT 1 OF STRUCTURE lr_key_structure->* TO FIELD-SYMBOL(<component>).
    cl_abap_unit_assert=>assert_not_initial( <component> ).

    lo_structdescr ?= cl_abap_structdescr=>describe_by_data_ref( lr_key_structure ).
    DATA(lt_field) = lo_structdescr->get_components( ).

    IF bus_obj EQ 'OR' OR bus_obj EQ 'SO' OR
      bus_obj EQ 'INVOICE' OR bus_obj EQ 'EBDR' OR bus_obj EQ 'PREBILLING_DOC'.
      cl_abap_unit_assert=>assert_equals( act = lines( lt_field ) exp = 1 ).
      cl_abap_unit_assert=>assert_equals( act = lt_field[ 1 ]-name exp = 'VBELN' ).
      cl_abap_unit_assert=>assert_equals( act = it_result[ 1 ]-step_number exp = step_number_table[ 1 ] ).
      cl_abap_unit_assert=>assert_equals( act = <component> exp = document_id_table[ 1 ] ).
    ENDIF.

    IF bus_obj EQ 'GOODS_RECEIPT'.
      cl_abap_unit_assert=>assert_equals( act = lines( lt_field ) exp = 2 ).
      cl_abap_unit_assert=>assert_equals( act = it_result[ 1 ]-step_number exp = step_number_table[ 1 ] ).
      "Validate key field names
      cl_abap_unit_assert=>assert_equals( act = lt_field[ 2 ]-name exp = 'MJAHR' ).
      cl_abap_unit_assert=>assert_equals( act = lt_field[ 1 ]-name exp = 'MBLNR' ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.



CLASS ltc_log_step_start DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO cl_ptf_run.
    DATA mt_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.

    METHODS:
      setup,
      a_short FOR TESTING,
      b_longer_than_100 FOR TESTING.
ENDCLASS.

CLASS ltc_log_step_start IMPLEMENTATION.

  METHOD setup.
    mt_step_data = VALUE #(
                             ( step_number = 6 bus_obj = 'EBDR' action = 'CREATE' variant = 'BD_CR_TRIT_ACT_TDT_INACT'
                               reference_step = VALUE #( ( 2 ) ( 3 ) ( 4 ) )
                               test_data_container = 'TDC_PTF_BD' json_file = '<xxxx>' )
                          ).
    mo_cut = NEW cl_ptf_run( it_ptf_steps = mt_step_data ).
  ENDMETHOD.

  METHOD a_short.
    mo_cut->log_step_start( mt_step_data[ 1 ] ).
    DATA(lt_log) = mo_cut->get_log( ).
    cl_abap_unit_assert=>assert_not_initial( act = lt_log ).
  ENDMETHOD.

  METHOD b_longer_than_100.
    DATA ls_step_data TYPE cl_ptf_util=>gt_ptf_step.
    ls_step_data = VALUE #( step_number = 6 bus_obj = 'MAINTENANCE_SERVICE_ORDER' action = 'CREATELONGLONGLONG' variant = 'LONGBD_CR_TRIT_ACT_TDT_INACT'
                               reference_step = VALUE #( ( 2 ) ( 3 ) ( 4 ) )
                               test_data_container = 'TDC_PTF_MOCK_Z_PTF_SELFTEST' json_file = '<xxxx>' ).
    mo_cut->log_step_start( ls_step_data ).
    DATA(lt_log) = mo_cut->get_log( ).
    cl_abap_unit_assert=>assert_not_initial( act = lt_log ).
  ENDMETHOD.

ENDCLASS.


CLASS ltc_get_result_key_data DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CONSTANTS c_any_so_vbeln TYPE vbeln VALUE '0000123456'.
    DATA mo_cut TYPE REF TO cl_ptf_run.
    METHODS:
      setup,
      rap_bo__single_key_field FOR TESTING RAISING cx_static_check,
      std_bo__single_key_field FOR TESTING RAISING cx_static_check,
      std_bo__multi_key_field FOR TESTING,
      rap_bo__multi_key_field FOR TESTING,
      duplicate_ref_steps FOR TESTING,
      stable_order_ref_steps FOR TESTING,
      std_bo__table_unknown FOR TESTING.
ENDCLASS.


CLASS ltc_get_result_key_data IMPLEMENTATION.

  METHOD setup.
    CLEAR  mo_cut.
  ENDMETHOD.

  METHOD rap_bo__single_key_field.

    lth_get_result_key_data_tc2=>call_and_validte_single_result(
      step_number_table = VALUE #( ( 1 ) )
      bus_obj           = 'R_SALESORDERTP'
      action            = 'CREATE'
      document_id_table = VALUE #( ( vbeln = c_any_so_vbeln ) )
    ).

  ENDMETHOD.

  METHOD std_bo__single_key_field.

    lth_get_result_key_data_tc2=>call_and_validte_single_result(
      step_number_table = VALUE #( ( 1 ) )
      bus_obj           = 'OR'
      action            = 'CREATE'
      document_id_table = VALUE #( ( vbeln = c_any_so_vbeln ) )
    ).

  ENDMETHOD.

  METHOD std_bo__multi_key_field.

    CONSTANTS lc_matdoc_blnr TYPE mblnr VALUE '4900004125'.
    CONSTANTS lc_matdoc_jahr TYPE mjahr VALUE '2021'.

    DATA lv_key TYPE cl_ptf_util=>ty_vbeln.
    lv_key-vbeln = lc_matdoc_blnr && '|' && lc_matdoc_jahr.
    lth_get_result_key_data_tc2=>call_and_validte_single_result(
      step_number_table = VALUE #( ( 1 ) )
      bus_obj           = 'GOODS_RECEIPT'
      action            = 'CREATE'
      document_id_table = VALUE #( ( vbeln = lv_key ) )
      first_key_value_1 = CONV #( lc_matdoc_blnr )
      first_key_value_2 = CONV #( lc_matdoc_jahr )
    ).

  ENDMETHOD.

  METHOD rap_bo__multi_key_field.

    CONSTANTS lc_prodsa TYPE prvbe VALUE 'TEST_ARE02'. "table is PVBE
    CONSTANTS lc_plant TYPE werks VALUE '1010'.

    DATA lv_key TYPE cl_ptf_util=>ty_vbeln.
    lv_key-vbeln = lc_prodsa && '|' && CONV string( lc_plant ).
    lth_get_result_key_data_tc2=>call_and_validte_single_result(
      step_number_table = VALUE #( ( 1 ) )
      bus_obj           = 'R_PRODUCTIONSUPPLYAREATP'
      action            = 'CREATE'
      document_id_table = VALUE #( ( vbeln = lv_key ) )
      first_key_value_1 = CONV #( lc_prodsa )
      first_key_value_2 = CONV #( lc_plant )
    ).

  ENDMETHOD.

  METHOD duplicate_ref_steps.
    lth_get_result_key_data_tc2=>call_and_validte_single_result(
      step_number_table = VALUE #( ( 1 ) ( 1 ) )
      bus_obj           = 'R_SALESORDERTP'
      action            = 'CREATE'
      document_id_table = VALUE #( ( vbeln = c_any_so_vbeln ) )
    ).
  ENDMETHOD.

  METHOD stable_order_ref_steps.
    lth_get_result_key_data_tc2=>call_and_validte_multi_result(
      step_number_table = VALUE #( ( 5 ) ( 1 ) ( 4 ) ( 2 ) ( 3 ) )
      bus_obj           = 'I_SALESORDERTP'
      action            = 'CREATE'
*      document_id_table = VALUE #( ( vbeln = c_any_so_vbeln ) )
    ).
  ENDMETHOD.

  METHOD std_bo__table_unknown.

    lth_get_result_key_data_tc2=>call_and_validte_w_o_ref(
      step_number_table = VALUE #( ( 1 ) )
      bus_obj           = 'ENTERPRISE_PROJECT'
      action            = 'GET_BILLING_WBS'
      document_id_table = VALUE #( ( vbeln = '100005' ) )
    ).

  ENDMETHOD.

ENDCLASS.
