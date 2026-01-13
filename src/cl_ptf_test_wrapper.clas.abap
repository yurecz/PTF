class CL_PTF_TEST_WRAPPER definition
  public
  final
  create public .

public section.

  types:
*****************************************************************************************************
    BEGIN OF ts_report_log,
        index    TYPE int4,  "force eCATT log to show full record content one level earlier (needs more than one component)
        line     TYPE string,
    END OF ts_report_log .
  types:
    tt_report_log TYPE STANDARD TABLE OF ts_report_log WITH EMPTY KEY .
  types:
*****************************************************************************************************
    BEGIN OF ty_PTF_log,
        row     TYPE string,
    END OF ty_ptf_log .
  types:
    tt_ptf_log TYPE STANDARD TABLE OF ty_ptf_log WITH EMPTY KEY .
  types:
*****************************************************************************************************
    BEGIN OF ts_test_log,
        prog     TYPE char40,
        clas     TYPE char30,
        meth     TYPE seomtdname, "char61
        severity TYPE char1,
        kind     TYPE char1,
        msgtxt   TYPE string,
      END OF ts_test_log .
  types:
    tt_test_log TYPE STANDARD TABLE OF ts_test_log WITH DEFAULT KEY .

*****************************************************************************************************
  constants GC_MEMORY_ID type CHAR20 value 'PTF_TEST_RESULT' ##NO_TEXT.

  class-methods SET_RESULT
    importing
      !IV_RCODE type SYSUBRC
      !IV_LOG_COMMENT type STRING
      !IT_PTF_LOG type TT_PTF_LOG .
  class-methods EXECUTE_REPORT
    importing
      !IT_PARAMS type RSPARAMS_TT optional
      !IV_REPORT_NAME type PROGRAMM
      !IV_SELECTION_VARIANT type SELSET optional
    exporting
      !EV_RCODE type SYSUBRC
      !EV_LOG_TEXT type STRING
      !ET_REPORT_OUTPUT type TT_REPORT_LOG .
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
protected section.
private section.

  class-methods GET_RESULT
    exporting
      !EV_RCODE type SYSUBRC
      !EV_LOG_COMMENT type STRING
      !ET_PTF_LOG type TT_PTF_LOG .
ENDCLASS.



CLASS CL_PTF_TEST_WRAPPER IMPLEMENTATION.


METHOD EXECUTE_AUNIT_TEST.
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


METHOD execute_report.
*************************************************************************
*  Static method which enables an eCatt to execute a report in a        *
*  gegeneric way.                                                       *
*  (Mostly copied from class CL_TOOL_TEST_READINESS in system QCH.)     *
*                                                                       *
*  Import: 1. IV_REPORT_NAME   Name of the report to execute            *
*          2. IV_PARAMS        Selection Table of the report            *
*          3. iv_selection_variant variant for the report
*  Export: 1. EV_RCODE         0 for successful excution,error all other*
*          2. EV_LOG_TEXT      Text to log, paraphrase of the outcome   *
*          3. ET_REPORT_OUTPUT Entire output of the report              *
*                                                                       *
*  Comment: EV_RCODE and EV_LOG_TEXT get their values from a memory ID  *
*           which has to be filled in the report via                    *
*       CALL METHOD cl_tool_test_readiness=>set_result                  *
*        EXPORTING                                                      *
*          iv_rcode    = 0         "SYSUBRC                             *
*          iv_log_text = lv_text.  "STRING                              *
*                                                                       *
*       EV_LOG_TEXT shoul be a clearly understandable statement like:   *
*         attachment service is not available/ is available             *
*         business partner are available /not available                 *
*         COPY from CL_SFIN_TEST_WRAPPER                                *
*************************************************************************

  DATA: lv_report_name       TYPE programm,
        lt_params            TYPE rsparams_tt,
        ls_params            TYPE rsparams,
        lv_selection_variant TYPE selset,
        lt_ptf_log           TYPE tt_ptf_log.

  CLEAR ev_rcode.
  CLEAR ev_log_text.
  CLEAR et_report_output.

  lv_selection_variant = iv_selection_variant.

  IF lv_selection_variant IS INITIAL.
    ev_rcode = 4.
    ev_log_text = 'Please specify a variant'(002).
    RETURN.
  ELSE.
**********************************************************************************
    lv_report_name = iv_report_name.
    TRANSLATE lv_report_name TO UPPER CASE.
    LOOP AT it_params INTO ls_params.
      TRANSLATE ls_params-selname TO UPPER CASE.
      APPEND ls_params TO lt_params.
    ENDLOOP.

    CLEAR sy-subrc.
    lv_selection_variant = iv_selection_variant.
    TRANSLATE lv_selection_variant TO UPPER CASE.
    SUBMIT ('PROCESS_TEST_FRAMEWORK') USING SELECTION-SET lv_selection_variant AND RETURN.
**********************************************************************************
    IF sy-subrc <> 0.
      ev_rcode = 4.
      ev_log_text = 'Could not submit report'(001).
    ELSE.
      cl_ptf_test_wrapper=>get_result(
        IMPORTING
          ev_rcode       = ev_rcode
          ev_log_comment = ev_log_text
          et_ptf_log     = lt_ptf_log ).
      IF lt_ptf_log IS NOT INITIAL.
        LOOP AT lt_ptf_log INTO DATA(ls_ptf_log).
          APPEND VALUE #( index = sy-tabix line = ls_ptf_log-row ) TO et_report_output.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.

ENDMETHOD.


METHOD get_result.
************************************************************************
*  This static method imports the return code of the submitted report  *
*  out of the abap memory, and deallocates the memory afterwards       *
************************************************************************

  IMPORT rcode = ev_rcode
         rcomment = ev_log_comment
         rptflog =  et_ptf_log FROM MEMORY ID cl_ptf_test_wrapper=>gc_memory_id.

  FREE MEMORY ID cl_ptf_test_wrapper=>gc_memory_id.

ENDMETHOD.


METHOD set_result.
************************************************************************
*  This static methods exports the return code of report to the abap   *
*  memory, because the report is executes with the appendix and return.*
*  This means, that the internal mode of the report will be deleted,   *
*  including the variables of the static classes!                      *                                                                     *
************************************************************************

  EXPORT rcode = iv_rcode
         rcomment = iv_log_comment
         rptflog = it_ptf_log TO MEMORY ID cl_ptf_test_wrapper=>gc_memory_id.

ENDMETHOD.
ENDCLASS.
