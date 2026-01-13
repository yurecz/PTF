class TCL_PTF_AU_RUNNER3 definition
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

  methods EXECUTE_PTF_VARIANT_3
  for testing .
  methods SETUP .
  methods TEARDOWN .
  class-methods CLASS_SETUP .
  class-methods CLASS_TEARDOWN .
ENDCLASS.



CLASS TCL_PTF_AU_RUNNER3 IMPLEMENTATION.


  METHOD class_setup.

    environment = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'VBRK' )  ) ).

    "environment = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'TVCPF' )  ) ).

    TRY.
        cl_osql_replace=>set_survive_submit( ).
      CATCH cx_osql_replace .
        ASSERT 1 = 2.
    ENDTRY.

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
    "environment->insert_test_data( gt_tvcpf ).


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


  METHOD execute_ptf_variant_3.
*    "called below form PTF_RUN
*
*    DATA lt_tvcpf_read TYPE STANDARD TABLE OF tvcpf.
*    SELECT * FROM tvcpf INTO TABLE lt_tvcpf_read.
*    DATA lt_vbrk TYPE STANDARD TABLE OF vbrk.
*    SELECT * FROM vbrk INTO TABLE lt_vbrk.
*
*    DATA: lau_step_data      TYPE TABLE OF cl_ptf_util=>gt_ptf_step.
*    DATA: lv_variant         TYPE ptf_selection-varname,
*          lv_timestamp_start TYPE timestampl,
*          lv_timestamp_end   TYPE timestampl,
**          lo_ptf_run         TYPE REF TO cl_ptf_run, "zcl_ptf_run_session
*          lo_ptf_run         TYPE REF TO zcl_ptf_run_session,
*          v1 type i.
*    DATA: gv_step_index TYPE i,
*          gv_log_status TYPE sysubrc,
*          gt_return     TYPE cl_ptf_util=>gt_ptf_return_tab,
*          gv_check_alv_status         TYPE abap_bool.
*
*
*
*  cl_ptf_wrapper=>get_variant(
*  IMPORTING
*    ev_variant =   lv_variant ).
*
**<<<<<<
**if lv_variant is initial.
**  break-POINT.
**endif.
*
*    DATA: dummy_1      TYPE TABLE OF cl_ptf_util=>gt_ptf_step,
*          dummy_2     TYPE cl_ptf_util=>gt_ptf_return_tab.
*    "clear: dummy_1, dummy_2.
*    IMPORT t_stepdata_in = lau_step_data
*           t_stepdata    = dummy_1
*           t_PTF_RUN_LOG = dummy_2
*           FROM MEMORY ID 'CG__PTF_TEST_RESULT'.
*
*    FREE MEMORY ID 'CG__PTF_TEST_RESULT'.
**>>>>>>
**  IF lv_variant IS INITIAL.
**    PERFORM alv_value_check USING gt_step_data.
**  ELSE.
*    gv_check_alv_status = abap_true.
**    gv_log_status = 0.
**  ENDIF.
*
**  PERFORM fill_check_flag.    komplett reingeschrieben:
*  LOOP AT lau_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data>).
*    IF <ls_step_data>-bus_obj IS NOT INITIAL.
*      SELECT SINGLE ptf_check_action FROM ptfboa INTO <ls_step_data>-check_flag WHERE ptf_act = <ls_step_data>-action AND ptf_bo = <ls_step_data>-bus_obj.
*    ENDIF.
*  ENDLOOP.
*
**  lo_ptf_run = NEW cl_ptf_run(
**    it_ptf_steps   = lau_step_data
**  ).
*  lo_ptf_run = NEW zcl_ptf_run_session( it_ptf_steps   = lau_step_data ).
*
**  IF gv_check_alv_status EQ abap_true.
*
*    GET TIME STAMP FIELD lv_timestamp_start.
*
*    "Execute the run
*    lo_ptf_run->execute(
*      CHANGING
*        gv_step_index = gv_step_index
*        gv_log_status = gv_log_status
*    ).
*
*    GET TIME STAMP FIELD lv_timestamp_end.
*    DATA(lv_run_time) = cl_abap_tstmp=>subtract( EXPORTING tstmp1 = lv_timestamp_end tstmp2 = lv_timestamp_start ).
*
*    lau_step_data = lo_ptf_run->get_all_steps( ).
*    gt_return = lo_ptf_run->get_log( ).
*
*
*    APPEND VALUE #( message = '************************************' ) TO gt_return.
*    IF lv_variant NE ''.
*      APPEND VALUE #( message = |PTF RUN TOOK { lv_run_time } SECONDS FOR VARIANT { lv_variant }| ) TO gt_return.
*    ELSE.
*      APPEND VALUE #( message = |PTF RUN TOOK { lv_run_time } SECONDS| ) TO gt_return.
*    ENDIF.
*
*    APPEND VALUE #( message = '******************STABLE VERSION OF PTF******************' ) TO gt_return.
*
*
*
*
*    EXPORT t_stepdata_in = lau_step_data "egal
*           t_stepdata = lau_step_data
*           t_PTF_RUN_LOG = gt_return
*           TO MEMORY ID 'CG__PTF_TEST_RESULT'.
*
*
*
  ENDMETHOD.


  METHOD setup.

    CHECK 1 = 1.

  ENDMETHOD.


  METHOD TEARDOWN.

  ENDMETHOD.
ENDCLASS.
