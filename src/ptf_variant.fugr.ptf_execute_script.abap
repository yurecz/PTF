FUNCTION ptf_execute_script.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_NAME) TYPE  PTF_VARNAME
*"  EXPORTING
*"     VALUE(ET_LOG) TYPE  PTF_STRING_TAB
*"     VALUE(EV_RCODE) TYPE  SYSUBRC
*"----------------------------------------------------------------------

  DATA(lv_name) = iv_name.

  SELECT SINGLE varname FROM ptf_varid WHERE varname = @iv_name INTO @DATA(found_variant).

  cl_ptf_wrapper=>execute_report(
    EXPORTING
      iv_selection_variant = lv_name
    IMPORTING
      ev_rcode         = ev_rcode
      et_report_output = DATA(lt_log)
  ).

  LOOP AT lt_log INTO DATA(ls_log).
    APPEND ls_log-line TO et_log.
  ENDLOOP.

ENDFUNCTION.
