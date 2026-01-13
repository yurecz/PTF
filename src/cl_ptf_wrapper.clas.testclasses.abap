*"* use this source file for your ABAP unit test classes
CLASS ltc_ptf_wrapper DEFINITION
  FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PUBLIC SECTION.
    METHODS:
      unit_test FOR TESTING.
  PROTECTED SECTION.

  PRIVATE SECTION.
    CLASS-DATA : environment   TYPE REF TO if_osql_test_environment,
                 lt_tvcpf      TYPE STANDARD TABLE OF tvcpf,
                 lt_tvcpf_read TYPE STANDARD TABLE OF tvcpf.

ENDCLASS.

CLASS ltc_ptf_wrapper IMPLEMENTATION.

  METHOD unit_test.

    DATA lv_do_mock TYPE c.
*    lv_do_mock = 'X'.

    IF lv_do_mock EQ 'X'.
      environment = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'TVCPF' )  ) ).

      lt_tvcpf = VALUE #(
  "header
      (
      fkarn	= 'BDR1'
      auarv	= 'EO01'
      pstyv	= space
      posvo	= 'X'
      ordnr_fi = space
      xblnr_fi = 'A' )
      (
      fkarn = 'CBD1'
      auarv = space
      fkarv = 'BDR1'
      pstyv	= space
      grbed	= '039'
      posvo	= 'X'
      ordnr_fi  = 'B'   "'E' ist db stand im ER9
      xblnr_fi  = 'A' )
  "item
      (
  fkarn	= 'BDR1'
  auarv	= 'EO01'
  pstyv	= 'ED01'
  grbed	= '022'
  grurp	= '039'
  knprs	= 'C'
  plmin	= '+'
  fkmgk	= 'A' )
      (
  fkarn	= 'BDR1'
  auarv	= 'EO01'
  pstyv	= 'EC01'
  grbed	= '022'
  grurp	= '039'
  knprs	= 'C'
  plmin	= '+'
  fkmgk	= 'A' )
      (
  fkarn	= 'CBD1'
  auarv	= space
  fkarv	= 'BDR1'
  pstyv	= 'EC01'
  grbed	= '041'
  knprs	= 'G'
  plmin	= '+'
  fkmgk	= 'A' )
      (
  fkarn	= 'CBD1'
  auarv	= space
  fkarv	= 'BDR1'
  pstyv	= 'ED01'
  grbed	= '041'
  knprs	= 'G'
  plmin	= '+'
  fkmgk	= 'C'
  sdbil_grurp_routine_no = '3000000' )
    ).

      "insert test data to the double
      environment->insert_test_data( lt_tvcpf ).
    ENDIF.

*    SELECT * FROM tvcpf INTO TABLE lt_tvcpf_read.
*    DATA lt_bdlitems TYPE STANDARD TABLE OF vkdfs.
*    SELECT * FROM vkdfs INTO TABLE @lt_bdlitems.

    DATA gb_unit_test_on TYPE abap_bool VALUE IS INITIAL.
    IMPORT gb_unit_test_on =  gb_unit_test_on FROM MEMORY ID 'PTF_TEST'.

    IF gb_unit_test_on  EQ abap_true.
*      PERFORM ('GET_VARIANTS') IN PROGRAM ('PROCESS_TEST_FRAMEWORK_ALV') IF FOUND.
*      PERFORM ('MOVE_DATA_TO_ALV') IN PROGRAM ('PROCESS_TEST_FRAMEWORK_ALV') IF FOUND.
*      PERFORM ('PTF_RUN') IN PROGRAM ('PROCESS_TEST_FRAMEWORK_ALV') IF FOUND.
    ENDIF.

    IF lv_do_mock EQ 'X'.
      environment->destroy( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
