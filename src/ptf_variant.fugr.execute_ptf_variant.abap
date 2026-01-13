FUNCTION execute_ptf_variant.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(VARIANT) TYPE  PTF_VARNAME
*"  EXPORTING
*"     VALUE(EXECUTION_RESULT) TYPE  I_PTF_EXECUTION_RESULT
*"----------------------------------------------------------------------

  execution_result-variant_name = variant.

  SELECT SINGLE varname FROM ptf_varid WHERE varname = @variant INTO @DATA(found_variant).

  IF found_variant IS INITIAL.
    execution_result-error = 'NOT_FOUND'.
    execution_result-results = |<ptfExecutionResult></ptfExecutionResult>|.
    RETURN.
  ENDIF.

  DATA: step_data   TYPE cl_ptf_util=>gt_ptf_step_tab.


  cl_ptf_wrapper=>execute_report(
    EXPORTING
      iv_selection_variant =      variant            " Variant Name in PTF
    IMPORTING
      et_step_data = step_data
  ).

  DATA(execution_xml_result) = cl_ptf_xml_result=>get_xml_result( step_data = step_data ).

  execution_result-results = execution_xml_result.

ENDFUNCTION.
