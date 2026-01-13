CLASS ltd_id_handler DEFINITION FOR TESTING
  INHERITING FROM cl_ptf_id_handler.
*  interfaces if_ptf_id_handler.
  PUBLIC SECTION.
    CONSTANTS sc_number_5_digits TYPE ptf_id_n12 VALUE '000000015555'.
    CONSTANTS sc_number_8_digits TYPE ptf_id_n12 VALUE '000080888128'.
    METHODS if_ptf_id_handler~get_next_number REDEFINITION.

ENDCLASS.

CLASS ltd_id_handler IMPLEMENTATION.
  METHOD if_ptf_id_handler~get_next_number.

    CLEAR rv_number.

    CHECK iv_no_of_max_filled_digits NE 0.
    CHECK iv_no_of_max_filled_digits LE 12.

    "rv_number is numc 12, i.e. always 12 digits with leading zeroes

    CASE iv_no_of_max_filled_digits.
      WHEN 1.
        rv_number = 5.
      WHEN 2.
        rv_number = 15.
      WHEN 3.
        rv_number = 125.
      WHEN 4.
        rv_number = 1445.
      WHEN 5.
        rv_number = sc_number_5_digits. "15555
      WHEN 6.
        rv_number = 106006.
      WHEN 7.
        rv_number = 6000123.
      WHEN 8.
        rv_number = sc_number_8_digits. "80888128.
      WHEN 9.
      WHEN 10.
      WHEN 11.
      WHEN 12.
    ENDCASE.

  ENDMETHOD.
ENDCLASS.


CLASS ltc_get_next_id DEFINITION FOR TESTING
RISK LEVEL HARMLESS
DURATION SHORT.

  PRIVATE SECTION.
    CLASS-DATA digit TYPE c LENGTH 1 VALUE '#'.
    DATA mo_cut TYPE REF TO cl_ptf_bo_ptf_id_generator.
    METHODS:
      setup,
      prefix_and_5_digits FOR TESTING,
      prefix_and_8_digits FOR TESTING.

ENDCLASS.

CLASS ltc_get_next_id IMPLEMENTATION.

  METHOD setup.
  ENDMETHOD.

  METHOD prefix_and_5_digits.

    DATA(lt_step_data) = VALUE cl_ptf_util=>gt_ptf_step_tab(
      ( bus_obj = 'PTF_ID_GENERATOR' action = 'GET_NEXT_ID' variant = 'PTF#####'   step_number = 1 )
     ).
    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    mo_cut = NEW #( iv_run_environment = lo_ptf_run
                    io_id_handler      = NEW ltd_id_handler( ) ).

    mo_cut->execute_action(
      EXPORTING
        iv_step_number      = 1
      IMPORTING
        ev_document_id      = DATA(lt_id)
        ev_execution_status = DATA(lv_exec_status)
    ).
    cl_abap_unit_assert=>assert_not_initial( lv_exec_status ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_id ) exp = 1 ).
    DATA(lv_id) = lt_id[ 1 ]-vbeln.
    cl_abap_unit_assert=>assert_not_initial( lv_id+7 ).
    cl_abap_unit_assert=>assert_initial( lv_id+8 ).
    cl_abap_unit_assert=>assert_equals( act = lv_id(3) exp = 'PTF' ).
    cl_abap_unit_assert=>assert_equals( act = lv_id+3  exp = CONV ptfkey( ltd_id_handler=>sc_number_5_digits+7 ) ). " 12-5 = 7
  ENDMETHOD.

  METHOD prefix_and_8_digits.

    DATA(lt_step_data) = VALUE cl_ptf_util=>gt_ptf_step_tab(
      ( bus_obj = 'PTF_ID_GENERATOR' action = 'GET_NEXT_ID' variant = 'PTF########'   step_number = 1 )
     ).
    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    mo_cut = NEW #( iv_run_environment = lo_ptf_run
                    io_id_handler      = NEW ltd_id_handler( ) ).

    mo_cut->execute_action(
      EXPORTING
        iv_step_number      = 1
      IMPORTING
        ev_document_id      = DATA(lt_id)
        ev_execution_status = DATA(lv_exec_status)
    ).
    cl_abap_unit_assert=>assert_not_initial( lv_exec_status ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_id ) exp = 1 ).
    DATA(lv_id) = lt_id[ 1 ]-vbeln.
    cl_abap_unit_assert=>assert_not_initial( lv_id+10 ).
    cl_abap_unit_assert=>assert_initial( lv_id+11 ).
    cl_abap_unit_assert=>assert_equals( act = lv_id(3) exp = 'PTF' ).
    cl_abap_unit_assert=>assert_equals( act = lv_id+3  exp = CONV ptfkey( ltd_id_handler=>sc_number_8_digits+4 ) ).  "12-8 = 4
  ENDMETHOD.

ENDCLASS.
