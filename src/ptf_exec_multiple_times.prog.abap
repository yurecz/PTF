*&---------------------------------------------------------------------*
*& Report PTF_EXEC_MULTIPLE_TIMES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ptf_exec_multiple_times.

"*********************************************************************
" Selection Screen
"*********************************************************************
SELECTION-SCREEN BEGIN OF BLOCK descr WITH FRAME TITLE TEXT-001.
  SELECTION-SCREEN COMMENT /1(79) TEXT-003.
SELECTION-SCREEN END OF BLOCK descr.

SELECTION-SCREEN BEGIN OF BLOCK  param WITH FRAME TITLE TEXT-002.
  PARAMETERS      p_name  TYPE ptf_varname OBLIGATORY.
  PARAMETERS      p_runs  TYPE i DEFAULT 2 OBLIGATORY.
  PARAMETERS      p_smart TYPE abap_boolean DEFAULT abap_true.
  PARAMETERS      p_log   TYPE abap_boolean DEFAULT abap_true.
SELECTION-SCREEN END OF BLOCK param.

***********************************************************************
* Initialization
***********************************************************************
INITIALIZATION.


***********************************************************************
* Start of selection
***********************************************************************
START-OF-SELECTION.

  WRITE: 'Client:', sy-sysid, sy-mandt, /.

  SELECT SINGLE * FROM ptf_varid WHERE varname = @p_name INTO @DATA(ls_dummy).
  IF sy-subrc IS NOT INITIAL.
    WRITE: / |Script { p_name } does not exist in this client.|.
    RETURN.
  ENDIF.

  DO p_runs TIMES.
    DATA(lv_index) = sy-index.
    WRITE: /, / |Execution # { lv_index }:|.

    cl_ptf_wrapper=>execute_report(
      EXPORTING
        iv_selection_variant  = p_name
      IMPORTING
        ev_rcode              = DATA(lv_rcode)
        ev_log_text           = DATA(lv_log_text)
        et_report_output      = DATA(lt_report_output)
        ev_last_created_doc   = DATA(lv_last_doc)
    ).

    WRITE: / ' Result:',lv_log_text.

    IF p_log EQ abap_true.
      WRITE: / ' Log:'.
      LOOP AT lt_report_output REFERENCE INTO DATA(lr_s_report_output).
        WRITE: / lr_s_report_output->index, lr_s_report_output->line.
      ENDLOOP.
    ENDIF.

    IF lv_rcode IS NOT INITIAL.
      IF p_smart EQ abap_true.
        WRITE: /, / |Report STOPPED, as execution no. { lv_index } failed.|.
        RETURN.
      ENDIF.
    ENDIF.

  ENDDO.
