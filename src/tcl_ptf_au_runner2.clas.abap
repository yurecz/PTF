class TCL_PTF_AU_RUNNER2 definition
  public
  create public
  for testing
  duration long
  risk level dangerous .

public section.

  class-data ENVIRONMENT type ref to IF_OSQL_TEST_ENVIRONMENT .
  class-data:
    gt_tvcpf    TYPE STANDARD TABLE OF tvcpf .
  PROTECTED SECTION.
private section.

  methods EXECUTE_PTF_VARIANT
  for testing .
  methods SETUP .
  methods TEARDOWN .
  class-methods CLASS_SETUP .
  class-methods CLASS_TEARDOWN .
ENDCLASS.



CLASS TCL_PTF_AU_RUNNER2 IMPLEMENTATION.


  method CLASS_SETUP.

    environment = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'TVCPF' )  ) ).

    gt_tvcpf = VALUE #(
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

    "insert test data into the double
    environment->insert_test_data( gt_tvcpf ).


*    DATA gb_unit_test_on TYPE abap_bool VALUE IS INITIAL.
**    IMPORT gb_unit_test_on =  gb_unit_test_on FROM MEMORY ID 'PTF_TEST'.
*
*    IF gb_unit_test_on  EQ abap_true.
**      PERFORM ('GET_VARIANTS') IN PROGRAM ('PROCESS_TEST_FRAMEWORK_ALV') IF FOUND.
**      PERFORM ('MOVE_DATA_TO_ALV') IN PROGRAM ('PROCESS_TEST_FRAMEWORK_ALV') IF FOUND.
**      PERFORM ('PTF_RUN') IN PROGRAM ('PROCESS_TEST_FRAMEWORK_ALV') IF FOUND.
*    ENDIF.

  ENDMETHOD.


  METHOD CLASS_TEARDOWN.

    environment->destroy( ).

  ENDMETHOD.


  METHOD EXECUTE_PTF_VARIANT.

*    DATA lt_tvcpf_read TYPE STANDARD TABLE OF tvcpf.
*    SELECT * FROM tvcpf INTO TABLE lt_tvcpf_read.

    RETURN. "avoid execution in ATC test systems

    PERFORM ('GET_VARIANTS')     IN PROGRAM ('PROCESS_TEST_FRAMEWORK_ALV') IF FOUND.
    PERFORM ('MOVE_DATA_TO_ALV') IN PROGRAM ('PROCESS_TEST_FRAMEWORK_ALV') IF FOUND.
    PERFORM ('PTF_RUN')          IN PROGRAM ('PROCESS_TEST_FRAMEWORK_ALV') IF FOUND.

*    SUBMIT ('PTF_ECATT_EXECUTE') AND RETURN.

    cl_aunit_assert=>assert_initial(
     EXPORTING
     msg                  = 'PERFORM failed'
     act                  = sy-subrc ).

  ENDMETHOD.


  METHOD SETUP.

  ENDMETHOD.


  METHOD TEARDOWN.

  ENDMETHOD.
ENDCLASS.
