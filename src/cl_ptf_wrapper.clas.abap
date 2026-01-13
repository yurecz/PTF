class CL_PTF_WRAPPER definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ty_ptf_run_metadata,
        ach_component TYPE string,
        test_variant  TYPE string,
        system        TYPE string,
        client        TYPE string,
      END OF ty_ptf_run_metadata .
  types:
*****************************************************************************************************
    BEGIN OF ts_report_log,
        index TYPE int4,  "force eCATT log to show full record content one level earlier (needs more than one component)
        line  TYPE string,
      END OF ts_report_log .
  types:
    tt_report_log TYPE STANDARD TABLE OF ts_report_log WITH EMPTY KEY .
  types:
*****************************************************************************************************
    BEGIN OF ty_ptf_log,
        row TYPE string,
      END OF ty_ptf_log .
  types:
    tt_ptf_log TYPE STANDARD TABLE OF ty_ptf_log WITH EMPTY KEY .
  types:
*****************************************************************************************************
    BEGIN OF ts_test_log,
        prog     TYPE c length 40, "char40,
        clas     TYPE char30,
        meth     TYPE seomtdname, "char61
        severity TYPE ptf_char1,
        kind     TYPE ptf_char1,
        msgtxt   TYPE string,
      END OF ts_test_log .
  types:
    tt_test_log TYPE STANDARD TABLE OF ts_test_log WITH DEFAULT KEY .

*****************************************************************************************************
  constants GC_MEMORY_ID type CHAR20 value 'PTF_TEST_RESULT' ##NO_TEXT.
  class-data GB_UNIT_TEST_ON type ABAP_BOOL value ABAP_FALSE ##NO_TEXT.

  class-methods EXECUTE_VIA_UNIT_TEST
    importing
      !IV_SELECTION_VARIANT type PTF_VARNAME optional
    exporting
      !EV_RCODE type SYSUBRC
      !EV_LOG_TEXT type STRING
      !ET_REPORT_OUTPUT type TT_REPORT_LOG
      !EV_FAILED_BO type PTF_BO
      !EV_FAILED_BO_ACTION type PTF_ACT .
  class-methods GET_VARIANT
    exporting
      !EV_VARIANT type PTF_SELECTION-VARNAME .
  class-methods SET_RESULT
    importing
      !IV_RCODE type SYSUBRC
      !IV_LOG_COMMENT type STRING
      !IV_FAILED_BO type PTF_BO
      !IV_FAILED_BO_ACTION type PTF_ACT
      !IT_PTF_LOG type TT_PTF_LOG
      !IT_PTF_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP_TAB .
  class-methods EXECUTE_REPORT
    importing
      !IV_SELECTION_VARIANT type PTF_VARNAME optional
    exporting
      !EV_RCODE type SYSUBRC
      !EV_LOG_TEXT type STRING
      !ET_REPORT_OUTPUT type TT_REPORT_LOG
      !EV_FAILED_BO type PTF_BO
      !EV_FAILED_BO_ACTION type PTF_ACT
      !ET_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP_TAB
      !EV_LAST_CREATED_DOC type PTFKEY
      !EV_LAST_CREATED_VBELN type PTFKEY .
  class-methods EXECUTE_AUNIT_TEST
    importing
      !IV_CLASS_PROGNAME type PROGNAME optional
      !IV_PROGRAM_PROGNAME type PROGNAME optional
      !IB_TREAT_TOLERABE_AS_FAILED type ABAP_BOOL default ABAP_TRUE
    exporting
      !EV_RCODE type SYSUBRC
      !EV_LOG_TEXT type STRING
      !ET_PROCESSED type TT_TEST_LOG
      !ET_FAILED type TT_TEST_LOG .
  class-methods SET_VARIANT
    importing
      !IV_VARIANT type PTF_SELECTION-VARNAME .
  class-methods EXECUTE_PTF_AS_AUNIT
    importing
      !IV_VARIANT type PTF_VARNAME
      !IB_TREAT_TOLERABE_AS_FAILED type ABAP_BOOL default ABAP_FALSE
    exporting
      !EV_RCODE type SYSUBRC
      !EV_LOG_TEXT type STRING
      !ET_PROCESSED type TT_TEST_LOG
      !ET_FAILED type TT_TEST_LOG
      !ET_REPORT_OUTPUT type TT_REPORT_LOG
      !EV_FAILED_BO type PTF_BO
      !EV_FAILED_BO_ACTION type PTF_ACT .
  PROTECTED SECTION.
private section.

  class-data GV_VARIANT type PTF_SELECTION-VARNAME .

  class-methods GET_RESULT
    exporting
      !EV_FAILED_BO type PTF_BO
      !EV_FAILED_BO_ACTION type PTF_ACT
      !EV_RCODE type SYSUBRC
      !EV_LOG_COMMENT type STRING
      !ET_PTF_LOG type TT_PTF_LOG
      !ET_PTF_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP_TAB .
ENDCLASS.



CLASS CL_PTF_WRAPPER IMPLEMENTATION.


  METHOD execute_aunit_test.
*************************************************************************
*  Static method which enables an eCatt to execute the unit tests for   *
*  a report or a global class in a gegeneric way.                       *
*  (Mostly copied from class CL_TOOL_TEST_READINESS in system QCH.)     *
*                                                                       *
*  The method could be extended to include unit tests for function      *
*  modules in a straightforward way.                                    *
*  In addition, it could also be restricted to dedicated test methods;  *
*  see class CL_FOP_TEST_ECATTAUNIT_WRAPPER in system QCH for a possible*
*  implementation.                                                      *
*************************************************************************

    DATA lo_factory  TYPE REF TO cl_aunit_factory.
    DATA lo_task     TYPE REF TO if_aunit_task.
    DATA lo_listener TYPE REF TO lcl_aunit_listener.


    CLEAR ev_rcode.
    CLEAR ev_log_text.
    CLEAR et_processed.
    CLEAR et_failed.

    CREATE OBJECT lo_listener
      EXPORTING
        ib_treat_tolerabe_as_failed = ib_treat_tolerabe_as_failed.
    CREATE OBJECT lo_factory.
    lo_task = lo_factory->create_task( listener = lo_listener ).

    IF iv_class_progname IS NOT INITIAL.
      lo_task->add_class_pool( iv_class_progname ).
    ELSEIF iv_program_progname IS NOT INITIAL.
      lo_task->add_program( iv_program_progname ).
    ELSE.
      ev_rcode    = 8.
      ev_log_text = 'No class or program specified'(003).
    ENDIF.

    IF ev_rcode = 0.
      lo_task->run( ).

      et_processed = lo_listener->mt_processed.
      et_failed    = lo_listener->mt_failed.

      IF et_failed IS NOT INITIAL.
        ev_rcode    = 8.
        ev_log_text = 'At least one unit test failed'(004).
      ELSE.
        ev_log_text = 'All unit tests ran successfully'(005).
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD execute_ptf_as_aunit.
*************************************************************************
*  Static method that calls a global test class                         *
*  and hands over one PTF variant                                       *
*************************************************************************
    DATA lv_variant	TYPE ptf_varname.
    DATA lo_factory  TYPE REF TO cl_aunit_factory.
    DATA lo_task     TYPE REF TO if_aunit_task.
    DATA lo_listener TYPE REF TO lcl_aunit_listener.
    DATA lc_class    TYPE progname VALUE 'TCL_PTF_AU_RUNNER'.
    DATA lt_ptf_log  TYPE tt_ptf_log.
    DATA lv_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.

    CLEAR ev_rcode.
    CLEAR ev_log_text.
    CLEAR et_processed.
    CLEAR et_failed.
    CLEAR et_report_output.
    CLEAR ev_failed_bo.
    CLEAR ev_failed_bo_action.


    lv_variant = iv_variant.
    IF lv_variant IS INITIAL.
      ev_rcode    = 8.
      ev_log_text = 'Specify a PTF variant'(003).
      RETURN.
    ENDIF.

    cl_ptf_wrapper=>set_variant( iv_variant = lv_variant ).

    CREATE OBJECT lo_listener
      EXPORTING
        ib_treat_tolerabe_as_failed = ib_treat_tolerabe_as_failed.
    CREATE OBJECT lo_factory.
    lo_task = lo_factory->create_task( listener = lo_listener ).

*    IF iv_variant IS NOT INITIAL.
    lo_task->add_class_pool( lc_class ).
*    ELSE.
*      ev_rcode    = 8.
*      ev_log_text = 'Specify a PTF variant'(003).
*    ENDIF.

    IF ev_rcode = 0.
      lo_task->run( ).

      et_processed = lo_listener->mt_processed.
      et_failed    = lo_listener->mt_failed.

      IF et_failed IS NOT INITIAL.
        ev_rcode    = 8.
        ev_log_text = 'At least one unit test failed'(004).
      ELSE.
        ev_log_text = 'All unit tests ran successfully'(005).
      ENDIF.


      cl_ptf_wrapper=>get_result(
        IMPORTING
          ev_failed_bo   = ev_failed_bo
          ev_failed_bo_action = ev_failed_bo_action
          ev_rcode       = ev_rcode
          ev_log_comment = ev_log_text
          et_ptf_log     = lt_ptf_log
          et_ptf_step_data = lv_step_data
          ).
      IF lt_ptf_log IS NOT INITIAL.
        LOOP AT lt_ptf_log INTO DATA(ls_ptf_log).
          APPEND VALUE #( index = sy-tabix line = ls_ptf_log-row ) TO et_report_output.
        ENDLOOP.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD execute_report.

    DATA:
      "lt_params            TYPE rsparams_tt,
      "ls_params            TYPE rsparams,
          lv_selection_variant TYPE ptf_varname,
          lt_ptf_log           TYPE tt_ptf_log,
          lv_ptf_run_meta      TYPE ty_ptf_run_metadata.

    CLEAR ev_rcode.
    CLEAR ev_log_text.
    CLEAR et_report_output.
    CLEAR ev_last_created_doc.
    FREE MEMORY ID 'PTF_LAST_CREATED_DOC'.

    lv_selection_variant = iv_selection_variant.

    IF lv_selection_variant IS INITIAL.
      ev_rcode = 4.
      ev_log_text = 'Please specify a variant.'(002).
      RETURN.
    ENDIF.

    DATA(lo_variant) = NEW cl_ptf_variant( ).
    IF lo_variant->check_existence( lv_selection_variant ) IS INITIAL.
      ev_rcode = 5.
      CONCATENATE 'Variant' lv_selection_variant 'does not exist.' INTO ev_log_text SEPARATED BY space.
      RETURN.
    ENDIF.


    ev_rcode = 1.
    ev_log_text = 'Test failed.'.

    "clear ABAP memory
    cl_ptf_wrapper=>set_result(
      EXPORTING
        iv_rcode            = ev_rcode
        iv_log_comment      = ev_log_text
        iv_failed_bo        = ev_failed_bo
        iv_failed_bo_action = ev_failed_bo_action
        it_ptf_log          = lt_ptf_log
        it_ptf_step_data    = et_step_data
    ).


    set_variant( iv_variant = lv_selection_variant  ).

    PERFORM get_variants IN PROGRAM process_test_framework_alv IF FOUND.
    PERFORM move_data_to_alv IN PROGRAM process_test_framework_alv IF FOUND.
    PERFORM ptf_run IN PROGRAM process_test_framework_alv IF FOUND.

    cl_ptf_wrapper=>get_result(
      IMPORTING
        ev_failed_bo     = ev_failed_bo
        ev_failed_bo_action = ev_failed_bo_action
        ev_rcode         = ev_rcode
        ev_log_comment   = ev_log_text
        et_ptf_log       = lt_ptf_log
        et_ptf_step_data = et_step_data
        ).
    "ET_STEP_DATA
    LOOP AT et_step_data REFERENCE INTO DATA(lr_step_data).
*      "Remove repetitive logs (non-linear) if there are many steps
*      IF sy-tabix GT 5. "10.
*        CLEAR lr_step_data->log.
*      ENDIF.
      "Remove empty lines from ET_STEP_DATA
      IF lr_step_data->bus_obj IS INITIAL.
        DELETE et_step_data INDEX sy-tabix.
      ENDIF.
    ENDLOOP.
    "Build ET_REPORT_OUTPUT
    IF lt_ptf_log IS NOT INITIAL.
      LOOP AT lt_ptf_log INTO DATA(ls_ptf_log).
        APPEND VALUE #( index = sy-tabix line = ls_ptf_log-row ) TO et_report_output.
      ENDLOOP.
    ENDIF.
    "Fill EV_LAST_CREATED_DOC
    IMPORT created_doc = ev_last_created_doc FROM MEMORY ID 'PTF_LAST_CREATED_DOC'.
    FREE MEMORY ID 'PTF_LAST_CREATED_DOC'.


    IF ev_rcode NE 0.
      "Error occurred so log additional meta data for creation of bcp incident
      DATA: ach_component TYPE ptf_ach_comp.

      SELECT SINGLE ach_component FROM ptfboa WHERE ptf_bo = @ev_failed_bo AND ptf_act = @ev_failed_bo_action INTO @DATA(action_comp).
      IF action_comp EQ ''.
        SELECT SINGLE ach_component FROM ptfbo WHERE ptf_bo = @ev_failed_bo INTO @DATA(bo_comp).
        ach_component = bo_comp.
      ELSE.
        ach_component = ach_component.
      ENDIF.

      "Temporarily  as default
      IF ach_component EQ ''.
        ach_component = 'SD-PTF'.
      ENDIF.

      lv_ptf_run_meta-ach_component = ach_component.
      lv_ptf_run_meta-client = sy-mandt.
      lv_ptf_run_meta-system = sy-sysid.
      lv_ptf_run_meta-test_variant = lv_selection_variant.

      DATA(meta_data_ptf_as_json) = /ui2/cl_json=>serialize( EXPORTING data = lv_ptf_run_meta ).

      APPEND VALUE #( line = meta_data_ptf_as_json ) TO et_report_output.
    ENDIF.

  ENDMETHOD.


  METHOD execute_via_unit_test.
    DATA: lo_factory     TYPE REF TO cl_aunit_factory,
          lo_task        TYPE REF TO if_aunit_task,
          lt_handles     TYPE if_aunit_test_class_handle=>ty_t_testclass_handles,
          lo_testclass   TYPE REF TO if_aunit_test_class_handle,
          lo_au_listener TYPE REF TO cl_ecatt_aunit_run_listener,
          lo_listener    TYPE REF TO if_aunit_listener,
          lv_step_data   TYPE cl_ptf_util=>gt_ptf_step_tab.


    CREATE OBJECT lo_au_listener.

    lo_listener ?= lo_listener.

    CREATE OBJECT lo_factory.

    lt_handles = lo_factory->get_test_class_handles(
                obj_type = 'CLAS'
                obj_name = 'CL_PTF_WRAPPER').


    lo_task = lo_factory->create_task( listener = lo_listener ).

*    lo_task->add_class_pool( 'LTC_PTF_WRAPPER' ).

    LOOP AT lt_handles INTO lo_testclass.
      lo_task->add_test_class_handle( lo_testclass  ).
    ENDLOOP.

*************************************************************************************
    DATA: lt_params            TYPE rsparams_tt,
          ls_params            TYPE rsparams,
          lv_selection_variant TYPE ptf_varname,
          lt_ptf_log           TYPE cl_ptf_wrapper=>tt_ptf_log.

    CLEAR ev_rcode.
    CLEAR ev_log_text.
    CLEAR et_report_output.

    lv_selection_variant = iv_selection_variant.

    IF lv_selection_variant IS INITIAL.
      ev_rcode = 4.
      ev_log_text = 'Please specify a variant.'(002).
      RETURN.
    ELSE.

      CLEAR sy-subrc.

      ev_rcode = 1.
      ev_log_text = 'Test failed.'.

      cl_ptf_wrapper=>set_result(
        EXPORTING
          iv_failed_bo = ev_failed_bo
          iv_failed_bo_action = ev_failed_bo_action
          iv_rcode       = ev_rcode
          iv_log_comment = ev_log_text
          it_ptf_log     = lt_ptf_log
          it_ptf_step_data = lv_step_data
          ).


      gb_unit_test_on = abap_true.
      EXPORT gb_unit_test_on =  gb_unit_test_on  TO MEMORY ID 'PTF_TEST'.

      set_variant( iv_variant = lv_selection_variant  ).

      lo_task->run( ).

      IF sy-subrc <> 0.
        ev_rcode = 4.
        ev_log_text = 'Could not submit report'(001).
      ELSE.
        cl_ptf_wrapper=>get_result(
          IMPORTING
            ev_rcode       = ev_rcode
            ev_log_comment = ev_log_text
            et_ptf_log     = lt_ptf_log
            et_ptf_step_data = lv_step_data
            ).
        IF lt_ptf_log IS NOT INITIAL.
          LOOP AT lt_ptf_log INTO DATA(ls_ptf_log).
            APPEND VALUE #( index = sy-tabix line = ls_ptf_log-row ) TO et_report_output.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDIF.


*    lo_au_listener->


**********************************************************************************

  ENDMETHOD.


  METHOD get_result.
************************************************************************
*  This static method imports the return code of the submitted report  *
*  out of the abap memory, and deallocates the memory afterwards       *
************************************************************************

    IMPORT rfailedboaction = ev_failed_bo_action
           rfailedbo = ev_failed_bo
           rcode = ev_rcode
           rcomment = ev_log_comment
           rptfstepdata = et_ptf_step_data
           rptflog =  et_ptf_log FROM MEMORY ID cl_ptf_wrapper=>gc_memory_id.

    FREE MEMORY ID cl_ptf_wrapper=>gc_memory_id.

  ENDMETHOD.


  METHOD get_variant.
    ev_variant = gv_variant.
    IF ev_variant IS INITIAL.
      IMPORT variant = ev_variant FROM MEMORY ID  'GC_PTF_WRAPPER_UNIT_TEST'.
    ENDIF.


  ENDMETHOD.


  METHOD set_result.
************************************************************************
*  This static methods exports the return code of report to the abap   *
*  memory, because the report is executes with the appendix and return.*
*  This means, that the internal mode of the report will be deleted,   *
*  including the variables of the static classes!                      *                                                                     *
************************************************************************

    EXPORT rfailedboaction = iv_failed_bo_action
           rfailedbo = iv_failed_bo
           rcode = iv_rcode
           rcomment = iv_log_comment
           rptfstepdata = it_ptf_step_data
           rptflog = it_ptf_log TO MEMORY ID cl_ptf_wrapper=>gc_memory_id.

  ENDMETHOD.


  METHOD set_variant.

    DATA: lv_variant   TYPE ptf_selection-varname.
    CLEAR gv_variant.
    lv_variant = iv_variant.
    TRANSLATE lv_variant TO UPPER CASE.
    gv_variant = lv_variant.
    EXPORT variant = lv_variant TO MEMORY ID 'GC_PTF_WRAPPER_UNIT_TEST'.

  ENDMETHOD.
ENDCLASS.
