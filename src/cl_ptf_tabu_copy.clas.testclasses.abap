CLASS ltc_message DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:

      test_main  FOR TESTING.

ENDCLASS.

CLASS ltc_message IMPLEMENTATION.

  METHOD test_main.

    RETURN.

    DATA(lo_cut) = NEW cl_ptf_tabu_copy( ).
    DATA lo_out TYPE REF TO if_oo_adt_classrun_out.
    lo_cut->if_oo_adt_classrun~main( lo_out ).

  ENDMETHOD.

ENDCLASS.
