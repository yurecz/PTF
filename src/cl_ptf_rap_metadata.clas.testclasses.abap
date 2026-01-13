*"* use this source file for your ABAP unit test classes

CLASS ltc_get_key_fields DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    METHODS setup.
    METHODS teardown.

    METHODS get_key_fields IMPORTING iv_virtual           TYPE abap_bool
                           RETURNING VALUE(et_key_fields) TYPE abap_component_tab.

    METHODS get_key_fields_w_pid FOR TESTING.
    METHODS get_key_fields_wo_pid FOR TESTING.

ENDCLASS.

CLASS ltc_get_key_fields IMPLEMENTATION.
  METHOD class_setup.

  ENDMETHOD.

  METHOD setup.

  ENDMETHOD.

  METHOD teardown.

  ENDMETHOD.

  METHOD class_teardown.

  ENDMETHOD.

  METHOD get_key_fields.
    DATA lo_cut             TYPE REF TO cl_ptf_rap_metadata.

    CLEAR et_key_fields.

    "given
    lo_cut = NEW #( ).

    "when
    et_key_fields = lo_cut->get_key_fields( EXPORTING iv_name = 'R_BILLINGDOCUMENTTP' iv_virtual = iv_virtual ).


  ENDMETHOD.

  METHOD get_key_fields_w_pid.
    DATA lv_line_exists     TYPE abap_bool.

    DATA(lt_key_components) = me->get_key_fields(
                                EXPORTING
                                  iv_virtual = abap_on ).

    IF line_exists( lt_key_components[ name = '%PID' ] ).
      lv_line_exists = abap_on.

    ENDIF.

    "then
    cl_abap_unit_assert=>assert_true( act = lv_line_exists ).

  ENDMETHOD.

  METHOD get_key_fields_wo_pid.
    DATA lv_line_exists     TYPE abap_bool.

    DATA(lt_key_components) = me->get_key_fields(
                                EXPORTING
                                  iv_virtual = abap_off ).

    IF line_exists( lt_key_components[ name = '%PID' ] ).
      lv_line_exists = abap_on.

    ENDIF.

    "then
    cl_abap_unit_assert=>assert_false( act = lv_line_exists ).

  ENDMETHOD.

ENDCLASS.
