**&---------------------------------------------------------------------*
**& Include          PTF_AU_HANDLER
**&---------------------------------------------------------------------*
*
*CLASS lcl_aunit_listener DEFINITION FINAL CREATE PUBLIC.
*
*  PUBLIC SECTION.
*
*    INTERFACES if_aunit_listener.
*
*    TYPES ts_alert TYPE cl_fins_test_wrapper=>ts_test_log.
*    TYPES tt_alert TYPE cl_fins_test_wrapper=>tt_test_log.
*
**    CONSTANTS gc_kind_assertion_failed TYPE cl_fins_test_wrapper=>ts_test_log-kind VALUE 'A'.
**    CONSTANTS gc_kind_exception_raised TYPE cl_fins_test_wrapper=>ts_test_log-kind VALUE 'X'.
**    CONSTANTS gc_kind_runtime_error    TYPE cl_fins_test_wrapper=>ts_test_log-kind VALUE 'R'.
**    CONSTANTS gc_kind_warning          TYPE cl_fins_test_wrapper=>ts_test_log-kind VALUE 'W'.
*
*    DATA mt_failed    TYPE tt_alert READ-ONLY.
*    DATA mt_processed TYPE tt_alert READ-ONLY.
*
*    METHODS constructor
*      IMPORTING
*        ib_treat_tolerabe_as_failed TYPE abap_bool.
*
*
*  PRIVATE SECTION.
*
*    DATA ms_context  TYPE ts_alert.                         "context of current test method
*    DATA mo_text_api TYPE REF TO if_aunit_text_description. "access to ABAP Unit text repository for title texts
*    DATA mb_treat_tolerable_as_failed TYPE abap_bool.
*
*ENDCLASS. "lcl_aunit_listener DEFINITION
*
*CLASS lcl_aunit_listener IMPLEMENTATION.
*
** ====================================
*  METHOD if_aunit_listener~task_start.
**   not intererested for now in task details so just skip
*    RETURN.
*  ENDMETHOD.                    "if_Aunit_Listener~task_start
*
*
** ==================================
*  METHOD if_aunit_listener~task_end.
**   not intererested for now in task details so just skip
*    RETURN.
*  ENDMETHOD.                    "if_Aunit_Listener~task_end
*
*
** ======================================
*  METHOD if_aunit_listener~program_start.
*
**    ms_context-prog = info->name.
*
*  ENDMETHOD.                    "if_Aunit_Listener~program_start
*
** =====================================
*  METHOD if_aunit_listener~program_end.
*
**    CLEAR ms_context-prog.
*
*  ENDMETHOD.                    "if_Aunit_Listener~program_end
*
*
** =====================================
*  METHOD if_aunit_listener~class_start.
*
**    ms_context-clas = info->name.
*
*  ENDMETHOD.                    "if_Aunit_Listener~class_start
*
*
** ===================================
*  METHOD if_aunit_listener~class_end.
*
**    CLEAR ms_context-clas.
*
*  ENDMETHOD.                    "if_Aunit_Listener~class_end
*
*
** =====================================
*  METHOD if_aunit_listener~method_start.
*
**    ms_context-meth = info->name.
*
*  ENDMETHOD.                    "if_Aunit_Listener~method_start
*
*
*  METHOD if_aunit_listener~method_end.
** ===================================
*
**    ms_context-msgtxt = mo_text_api->get_string( info->get_description( ) ).
**    APPEND ms_context TO mt_processed.
**
**    CLEAR ms_context-meth.
*
*  ENDMETHOD.                    "if_Aunit_Listener~method_end
*
*
** =======================================
*  METHOD if_aunit_listener~assert_failure.
*
**    DATA ls_alert  TYPE ts_alert.
**
**    ls_alert = ms_context.
**    ls_alert-kind     = gc_kind_assertion_failed.
**    ls_alert-severity = failure->get_level( ).
**    ls_alert-msgtxt   = mo_text_api->get_string( failure->get_header_description( ) ).
**
***   Default for respective parameter in eCATT test script SFIN_UNITTEST_WRAPPER amounts to abap_true.
***   Changing this default is not entirely intuitive, comparing with abap_true helps:
***   Use parameter values ' ', SPACE or anything except X and '' in eCATT test configuration to mean abap_false.
**    IF mb_treat_tolerable_as_failed <> abap_true AND ls_alert-severity = if_aunit_constants=>tolerable.
**      INSERT ls_alert INTO TABLE mt_processed.
**    ELSE.
**      INSERT ls_alert INTO TABLE mt_failed.
**    ENDIF.
*
*  ENDMETHOD.                    "if_Aunit_Listener~assert_failure
*
*
** ====================================
*  METHOD if_aunit_listener~cx_failure.
*
**    DATA ls_alert  TYPE ts_alert.
**
**    ls_alert = ms_context.
**    ls_alert-kind     = gc_kind_exception_raised.
**    ls_alert-severity = failure->get_level( ).
**    ls_alert-msgtxt   = mo_text_api->get_string( failure->get_header_description( ) ).
**
**    IF mb_treat_tolerable_as_failed <> abap_true AND ls_alert-severity = if_aunit_constants=>tolerable.
**      INSERT ls_alert INTO TABLE mt_processed.
**    ELSE.
**      INSERT ls_alert INTO TABLE mt_failed.
**    ENDIF.
*
*  ENDMETHOD.                    "if_Aunit_Listener~cx_failure
*
*
** ====================================
*  METHOD if_aunit_listener~rt_failure.
*
**    DATA ls_alert  TYPE ts_alert.
**
**    ls_alert = ms_context.
**    ls_alert-kind     = gc_kind_runtime_error.
**    ls_alert-severity = failure->get_level( ).
**    ls_alert-msgtxt   = mo_text_api->get_string( failure->get_header_description( ) ).
**
**    IF mb_treat_tolerable_as_failed <> abap_true AND ls_alert-severity = if_aunit_constants=>tolerable.
**      INSERT ls_alert INTO TABLE mt_processed.
**    ELSE.
**      INSERT ls_alert INTO TABLE mt_failed.
**    ENDIF.
*
*  ENDMETHOD.                    "if_Aunit_Listener~rt_failure
*
*
** =================================
*  METHOD if_aunit_listener~warning.
*
**    DATA ls_alert  TYPE ts_alert.
**
**    ls_alert = ms_context.
**    ls_alert-kind     = gc_kind_warning.
**    ls_alert-severity = warning->get_level( ).
**    ls_alert-msgtxt   = mo_text_api->get_string( warning->get_header_description( ) ).
**
***   Method is called for messages regarding the tests themselves;
***   for these, we always treat tolerable warnings as __not__ failed
**    IF ls_alert-severity = if_aunit_constants=>tolerable.
**      INSERT ls_alert INTO TABLE mt_processed.
**    ELSE.
**      INSERT ls_alert INTO TABLE mt_failed.
**    ENDIF.
**
*  ENDMETHOD.                    "if_Aunit_listener~warning
*
*
** =========================================
*    METHOD if_aunit_listener~execution_event.
**   execution events are more an ABAP Unit internal game - for
**   example if a program has been skipped due to a lack of tests;
**   also, there is no contract what gets reported or not;
**   this information is not required in most cases
*      RETURN.
*
*    ENDMETHOD.                    "if_Aunit_Listener~execution_event
*
*
** ===================
*    METHOD constructor.
*
**    DATA lo_factory TYPE REF TO cl_aunit_factory.
**
**    CREATE OBJECT lo_factory.
**    mo_text_api = lo_factory->get_text_converter( ).
**
**    mb_treat_tolerable_as_failed = ib_treat_tolerabe_as_failed.
*
*    ENDMETHOD.                    "constructor
*
*ENDCLASS. "lcl_aunit_listener IMPLEMENTATION
*
*FORM ptf_au_handler.
*
*"global fields gv_varname, GT_STEP_DATA  sind bekannt
*
*  DATA lv_variant  TYPE ptf_varname.
*  DATA lo_factory  TYPE REF TO cl_aunit_factory.
*  DATA lo_task     TYPE REF TO if_aunit_task.
*  DATA lo_listener TYPE REF TO lcl_aunit_listener.
*  DATA lc_class    TYPE progname VALUE 'TCL_PTF_AU_RUNNER3'.
*  "DATA lt_ptf_log  TYPE tt_ptf_log. " aus cl_ptf_wrapper
*
*  DATA ev_rcode TYPE sysubrc.
*  CLEAR ev_rcode.
**  CLEAR ev_log_text.
**  CLEAR et_processed.
**  CLEAR et_failed.
**  CLEAR et_report_output.
**  CLEAR ev_failed_bo.
**  CLEAR ev_failed_bo_action.
*
*
**  lv_variant = iv_variant.
*  DATA lv_c31 TYPE ptf_varname.
*  lv_c31 = gv_varname.
*  cl_ptf_wrapper=>set_variant( iv_variant = lv_c31 ). "lv_variant  ).
*
*    DATA: dummy_step      TYPE TABLE OF cl_ptf_util=>gt_ptf_step,
*          dummy_log     TYPE cl_ptf_util=>gt_ptf_return_tab.
*    clear: dummy_step, dummy_log.
*    EXPORT t_stepdata_in = gt_step_data
*           t_stepdata    = dummy_step
*           t_PTF_RUN_LOG = dummy_log
*           TO MEMORY ID 'CG__PTF_TEST_RESULT'.
*
*  CREATE OBJECT lo_listener
*    EXPORTING
*      ib_treat_tolerabe_as_failed = abap_false. "ib_treat_tolerabe_as_failed.
*  CREATE OBJECT lo_factory.
*  lo_task = lo_factory->create_task( listener = lo_listener ).
*
**  IF iv_variant IS NOT INITIAL.
*  lo_task->add_class_pool( lc_class ).
**  ELSE.
**    ev_rcode    = 8.
**    ev_log_text = 'Specify a PTF variant'(003).
**  ENDIF.
*
*  IF ev_rcode = 0.
*    lo_task->run( ).
*
**    et_processed = lo_listener->mt_processed.
**    et_failed    = lo_listener->mt_failed.
**
**    IF et_failed IS NOT INITIAL.
**      ev_rcode    = 8.
**      ev_log_text = 'At least one unit test failed'(004).
**    ELSE.
**      ev_log_text = 'All unit tests ran successfully'(005).
**    ENDIF.
*
*  ENDIF.
*
*  CHECK sy-subrc NE 42.
*
*ENDFORM.
