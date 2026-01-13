*"* use this source file for your ABAP unit test classes
* Local Test Class for method build_operations
CLASS ltc_shift_step_ids_in_string DEFINITION DEFERRED.
CLASS cl_ptf_step_shift DEFINITION LOCAL FRIENDS ltc_shift_step_ids_in_string.

CLASS ltc_shift_step_ids_in_string DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    METHODS shift_step IMPORTING iv_row_number        TYPE i
                                 iv_step_number       TYPE i
                                 iv_operation         TYPE if_ptf_step_shift=>te_operation
                       EXPORTING er_assert_1          TYPE REF TO data
                                 er_assert_2          TYPE REF TO data
                                 er_assert_3          TYPE REF TO data
                                 er_assert_4          TYPE REF TO data
                                 er_assert_5          TYPE REF TO data
                                 ev_reference_shifted TYPE abap_bool.

    METHODS setup.
    METHODS teardown.

    METHODS shift_step_up_1_c_step_3 FOR TESTING.
    METHODS shift_step_down_1_c_step_3 FOR TESTING.
    METHODS shift_step_up_2_c_step_3 FOR TESTING.
    METHODS shift_step_down_2_c_step_3 FOR TESTING.
    METHODS shift_step_up_3_c_step_3 FOR TESTING.

ENDCLASS.

CLASS ltc_shift_step_ids_in_string IMPLEMENTATION.
  METHOD class_setup.

  ENDMETHOD.

  METHOD setup.

  ENDMETHOD.

  METHOD teardown.

  ENDMETHOD.

  METHOD class_teardown.

  ENDMETHOD.

  METHOD shift_step.
    CLEAR: er_assert_1, er_assert_2, er_assert_3, er_assert_4, er_assert_5,
           ev_reference_shifted.

    DATA lo_cut               TYPE REF TO cl_ptf_step_shift.
    DATA lr_data              TYPE REF TO data.
    DATA lv_json_file         TYPE string.

    FIELD-SYMBOLS <fs_fields>       TYPE STANDARD TABLE.
    FIELD-SYMBOLS <fs_associations> TYPE STANDARD TABLE.
    FIELD-SYMBOLS <fs_fields_ref>   TYPE any.
    FIELD-SYMBOLS <fs_line_ref>     TYPE any.
    FIELD-SYMBOLS <fs_line>         TYPE any.
    FIELD-SYMBOLS <fs_value_ref>    TYPE any.

    lv_json_file = `{"_comment":"JSON Create Example for RAP BO R_ProductionSupplyAreaTP"`
                    && `,"isDraft":"false","fields":[{"name":"PRODUCTIONSUPPLYAREA","value":"/Step[1]/R_PRODUCTIONSUPPLYAREATP[3]/PRODUCTIONSUPPLYAREA"},`
                    && `{"name":"PLANT","value":"/Step[-1]/R_PRODUCTIONSUPPLYAREATP[PRODUCTIONSUPPLYAREA = 'TEST_AREAY']/PLANT"},`
                    && `{"name":"STORAGELOCATION","value":"/Step[2]/R_PRODUCTIONSUPPLYAREATP[1]/STORAGELOCATION"}],"associations":[`
                    && `{"childEntityName":"R_ProductionSupplyAreaTextTP","assocName":"_PRODUCTIONSUPPLYAREATEXT",`
                    && `"fields":[{"name":"LANGUAGE","value":"/Step[-2]/R_PRODUCTIONSUPPLYAREATP[1]/R_PRODUCTIONSUPPLYAREATEXTTP[1]/LANGUAGE"},`
                    && `{"name":"PRODUCTIONSUPPLYAREANAME","value":"/Step[2]/R_PRODUCTIONSUPPLYAREATP[1]/R_PRODUCTIONSUPPLYAREATEXTTP[1]/PRODUCTIONSUPPLYAREANAME"}]}`
                    && `]}`.

    "given
    lo_cut = NEW #( ).

    "when
    lo_cut->shift_step_ids_in_string(
      EXPORTING
        iv_row_number         = iv_row_number
        iv_step_number        = iv_step_number
        iv_operation          = iv_operation
      CHANGING
        cv_json_file          = lv_json_file
        cv_reference_shifted  = ev_reference_shifted
    ).

    /ui2/cl_json=>deserialize(
        EXPORTING
          json          = lv_json_file
          assoc_arrays  = abap_on
        CHANGING
          data          = lr_data ).

    ASSIGN lr_data->* TO FIELD-SYMBOL(<fs_data>).
    ASSIGN COMPONENT 'FIELDS' OF STRUCTURE <fs_data> TO <fs_fields_ref>.
    ASSIGN <fs_fields_ref>->* TO <fs_fields>.

    READ TABLE <fs_fields> ASSIGNING <fs_line_ref> INDEX 1.
    ASSIGN <fs_line_ref>->* TO <fs_line>.
    ASSIGN COMPONENT 'VALUE' OF STRUCTURE <fs_line> TO <fs_value_ref>.
    er_assert_1 = <fs_value_ref>.

    READ TABLE <fs_fields> ASSIGNING <fs_line_ref> INDEX 2.
    ASSIGN <fs_line_ref>->* TO <fs_line>.
    ASSIGN COMPONENT 'VALUE' OF STRUCTURE <fs_line> TO <fs_value_ref>.
    er_assert_2 = <fs_value_ref>.

    READ TABLE <fs_fields> ASSIGNING <fs_line_ref> INDEX 3.
    ASSIGN <fs_line_ref>->* TO <fs_line>.
    ASSIGN COMPONENT 'VALUE' OF STRUCTURE <fs_line> TO <fs_value_ref>.
    er_assert_3 = <fs_value_ref>.

    ASSIGN COMPONENT 'ASSOCIATIONS' OF STRUCTURE <fs_data> TO FIELD-SYMBOL(<fs_associations_ref>).
    ASSIGN <fs_associations_ref>->* TO <fs_associations>.

    READ TABLE <fs_associations> ASSIGNING FIELD-SYMBOL(<fs_association_ref>) INDEX 1.
    ASSIGN <fs_association_ref>->* TO FIELD-SYMBOL(<fs_association>).

    ASSIGN COMPONENT 'FIELDS' OF STRUCTURE <fs_association> TO <fs_fields_ref>.
    ASSIGN <fs_fields_ref>->* TO <fs_fields>.

    READ TABLE <fs_fields> ASSIGNING <fs_line_ref> INDEX 1.
    ASSIGN <fs_line_ref>->* TO <fs_line>.
    ASSIGN COMPONENT 'VALUE' OF STRUCTURE <fs_line> TO <fs_value_ref>.
    er_assert_4 = <fs_value_ref>.

    READ TABLE <fs_fields> ASSIGNING <fs_line_ref> INDEX 2.
    ASSIGN <fs_line_ref>->* TO <fs_line>.
    ASSIGN COMPONENT 'VALUE' OF STRUCTURE <fs_line> TO <fs_value_ref>.
    er_assert_5 = <fs_value_ref>.

  ENDMETHOD.

  METHOD shift_step_up_1_c_step_3.
    me->shift_step(
      EXPORTING
        iv_row_number        = 1
        iv_step_number       = 3
        iv_operation         = if_ptf_step_shift=>insert
      IMPORTING
        er_assert_1          = DATA(lr_assert_1)
        er_assert_2          = DATA(lr_assert_2)
        er_assert_3          = DATA(lr_assert_3)
        er_assert_4          = DATA(lr_assert_4)
        er_assert_5          = DATA(lr_assert_5)
        ev_reference_shifted = DATA(lv_reference_shifted)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lr_assert_1->* exp = `/Step[2]/R_PRODUCTIONSUPPLYAREATP[3]/PRODUCTIONSUPPLYAREA` ).
    cl_abap_unit_assert=>assert_equals( act = lr_assert_2->* exp = `/Step[-1]/R_PRODUCTIONSUPPLYAREATP[PRODUCTIONSUPPLYAREA = 'TEST_AREAY']/PLANT` ).
    cl_abap_unit_assert=>assert_equals( act = lr_assert_3->* exp = `/Step[3]/R_PRODUCTIONSUPPLYAREATP[1]/STORAGELOCATION` ).
    cl_abap_unit_assert=>assert_equals( act = lr_assert_4->* exp = `/Step[undefined]/R_PRODUCTIONSUPPLYAREATP[1]/R_PRODUCTIONSUPPLYAREATEXTTP[1]/LANGUAGE` ).
    cl_abap_unit_assert=>assert_equals( act = lr_assert_5->* exp = `/Step[3]/R_PRODUCTIONSUPPLYAREATP[1]/R_PRODUCTIONSUPPLYAREATEXTTP[1]/PRODUCTIONSUPPLYAREANAME` ).

    cl_abap_unit_assert=>assert_true( act = lv_reference_shifted ).

  ENDMETHOD.

  METHOD shift_step_down_1_c_step_3.
    me->shift_step(
      EXPORTING
        iv_row_number        = 1
        iv_step_number       = 3
        iv_operation         = if_ptf_step_shift=>delete
      IMPORTING
        er_assert_1          = DATA(lr_assert_1)
        er_assert_2          = DATA(lr_assert_2)
        er_assert_3          = DATA(lr_assert_3)
        er_assert_4          = DATA(lr_assert_4)
        er_assert_5          = DATA(lr_assert_5)
        ev_reference_shifted = DATA(lv_reference_shifted)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lr_assert_1->* exp = `/Step[undefined]/R_PRODUCTIONSUPPLYAREATP[3]/PRODUCTIONSUPPLYAREA` ).
    cl_abap_unit_assert=>assert_equals( act = lr_assert_2->* exp = `/Step[-1]/R_PRODUCTIONSUPPLYAREATP[PRODUCTIONSUPPLYAREA = 'TEST_AREAY']/PLANT` ).
    cl_abap_unit_assert=>assert_equals( act = lr_assert_3->* exp = `/Step[1]/R_PRODUCTIONSUPPLYAREATP[1]/STORAGELOCATION` ).
    cl_abap_unit_assert=>assert_equals( act = lr_assert_4->* exp = `/Step[undefined]/R_PRODUCTIONSUPPLYAREATP[1]/R_PRODUCTIONSUPPLYAREATEXTTP[1]/LANGUAGE` ).
    cl_abap_unit_assert=>assert_equals( act = lr_assert_5->* exp = `/Step[1]/R_PRODUCTIONSUPPLYAREATP[1]/R_PRODUCTIONSUPPLYAREATEXTTP[1]/PRODUCTIONSUPPLYAREANAME` ).

    cl_abap_unit_assert=>assert_true( act = lv_reference_shifted ).

  ENDMETHOD.

  METHOD shift_step_up_2_c_step_3.
    me->shift_step(
      EXPORTING
        iv_row_number        = 2
        iv_step_number       = 3
        iv_operation         = if_ptf_step_shift=>insert
      IMPORTING
        er_assert_1          = DATA(lr_assert_1)
        er_assert_2          = DATA(lr_assert_2)
        er_assert_3          = DATA(lr_assert_3)
        er_assert_4          = DATA(lr_assert_4)
        er_assert_5          = DATA(lr_assert_5)
        ev_reference_shifted = DATA(lv_reference_shifted)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lr_assert_1->* exp = `/Step[1]/R_PRODUCTIONSUPPLYAREATP[3]/PRODUCTIONSUPPLYAREA` ).
    cl_abap_unit_assert=>assert_equals( act = lr_assert_2->* exp = `/Step[undefined]/R_PRODUCTIONSUPPLYAREATP[PRODUCTIONSUPPLYAREA = 'TEST_AREAY']/PLANT` ).
    cl_abap_unit_assert=>assert_equals( act = lr_assert_3->* exp = `/Step[3]/R_PRODUCTIONSUPPLYAREATP[1]/STORAGELOCATION` ).
    cl_abap_unit_assert=>assert_equals( act = lr_assert_4->* exp = `/Step[-3]/R_PRODUCTIONSUPPLYAREATP[1]/R_PRODUCTIONSUPPLYAREATEXTTP[1]/LANGUAGE` ).
    cl_abap_unit_assert=>assert_equals( act = lr_assert_5->* exp = `/Step[3]/R_PRODUCTIONSUPPLYAREATP[1]/R_PRODUCTIONSUPPLYAREATEXTTP[1]/PRODUCTIONSUPPLYAREANAME` ).

    cl_abap_unit_assert=>assert_true( act = lv_reference_shifted ).

  ENDMETHOD.

  METHOD shift_step_down_2_c_step_3.
    me->shift_step(
      EXPORTING
        iv_row_number        = 2
        iv_step_number       = 3
        iv_operation         = if_ptf_step_shift=>delete
      IMPORTING
        er_assert_1          = DATA(lr_assert_1)
        er_assert_2          = DATA(lr_assert_2)
        er_assert_3          = DATA(lr_assert_3)
        er_assert_4          = DATA(lr_assert_4)
        er_assert_5          = DATA(lr_assert_5)
        ev_reference_shifted = DATA(lv_reference_shifted)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lr_assert_1->* exp = `/Step[1]/R_PRODUCTIONSUPPLYAREATP[3]/PRODUCTIONSUPPLYAREA` ).
    cl_abap_unit_assert=>assert_equals( act = lr_assert_2->* exp = `/Step[undefined]/R_PRODUCTIONSUPPLYAREATP[PRODUCTIONSUPPLYAREA = 'TEST_AREAY']/PLANT` ).
    cl_abap_unit_assert=>assert_equals( act = lr_assert_3->* exp = `/Step[1]/R_PRODUCTIONSUPPLYAREATP[1]/STORAGELOCATION` ).
    cl_abap_unit_assert=>assert_equals( act = lr_assert_4->* exp = `/Step[-1]/R_PRODUCTIONSUPPLYAREATP[1]/R_PRODUCTIONSUPPLYAREATEXTTP[1]/LANGUAGE` ).
    cl_abap_unit_assert=>assert_equals( act = lr_assert_5->* exp = `/Step[1]/R_PRODUCTIONSUPPLYAREATP[1]/R_PRODUCTIONSUPPLYAREATEXTTP[1]/PRODUCTIONSUPPLYAREANAME` ).

    cl_abap_unit_assert=>assert_true( act = lv_reference_shifted ).

  ENDMETHOD.

  METHOD shift_step_up_3_c_step_3.
    me->shift_step(
      EXPORTING
        iv_row_number        = 3
        iv_step_number       = 3
        iv_operation         = if_ptf_step_shift=>insert
      IMPORTING
        er_assert_1          = DATA(lr_assert_1)
        er_assert_2          = DATA(lr_assert_2)
        er_assert_3          = DATA(lr_assert_3)
        er_assert_4          = DATA(lr_assert_4)
        er_assert_5          = DATA(lr_assert_5)
        ev_reference_shifted = DATA(lv_reference_shifted)
    ).

    "then
    cl_abap_unit_assert=>assert_equals( act = lr_assert_1->* exp = `/Step[1]/R_PRODUCTIONSUPPLYAREATP[3]/PRODUCTIONSUPPLYAREA` ).
    cl_abap_unit_assert=>assert_equals( act = lr_assert_2->* exp = `/Step[-2]/R_PRODUCTIONSUPPLYAREATP[PRODUCTIONSUPPLYAREA = 'TEST_AREAY']/PLANT` ).
    cl_abap_unit_assert=>assert_equals( act = lr_assert_3->* exp = `/Step[2]/R_PRODUCTIONSUPPLYAREATP[1]/STORAGELOCATION` ).
    cl_abap_unit_assert=>assert_equals( act = lr_assert_4->* exp = `/Step[-3]/R_PRODUCTIONSUPPLYAREATP[1]/R_PRODUCTIONSUPPLYAREATEXTTP[1]/LANGUAGE` ).
    cl_abap_unit_assert=>assert_equals( act = lr_assert_5->* exp = `/Step[2]/R_PRODUCTIONSUPPLYAREATP[1]/R_PRODUCTIONSUPPLYAREATEXTTP[1]/PRODUCTIONSUPPLYAREANAME` ).

    cl_abap_unit_assert=>assert_true( act = lv_reference_shifted ).

  ENDMETHOD.

ENDCLASS.
