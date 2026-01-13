*&---------------------------------------------------------------------*
*& Report PTF_FLUENT_EXECUTION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT PTF_FLUENT_EXECUTION.
START-OF-SELECTION.

  DATA: step_data        TYPE cl_ptf_util=>gt_ptf_step,
        ptf_step_manager TYPE REF TO cl_ptf_step_execution.


  DATA(result) = NEW cl_ptf_step_execution( )->set_ptf_step(
      bus_obj             = 'EBDR'
      action              = 'CREATE'
      variant             = 'EBDR_CR_STANDARD'
  )->execute_ptf_step( )->set_ptf_step(
      bus_obj             = 'INVOICE'
      action              = 'CREATE'
      reference_step      = VALUE #( ( 1 ) )
  )->execute_ptf_step( )->get_ptf_execution_results( ).

  LOOP AT result ASSIGNING FIELD-SYMBOL(<ptf_step>).
    LOOP AT <ptf_step>-document_id ASSIGNING FIELD-SYMBOL(<document>).
      WRITE: / |Step { <ptf_step>-step_number } created { <document>-vbeln }|.
    ENDLOOP.
    LOOP AT <ptf_step>-log ASSIGNING FIELD-SYMBOL(<log>).
      WRITE: / |{ <log>-message }|.
    ENDLOOP.
  ENDLOOP.
