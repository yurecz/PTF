FUNCTION CONVERSION_EXIT_PTFRA_OUTPUT.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(INPUT) TYPE  CLIKE
*"  EXPORTING
*"     REFERENCE(OUTPUT) TYPE  CLIKE
*"----------------------------------------------------------------------

  output = input.

  check g_ptf_bo is not initial.

  DATA rap_metadata TYPE REF TO cl_ptf_rap_metadata.

  rap_metadata = NEW #( ).

  IF rap_metadata->check_rap_bo( g_ptf_bo ) = abap_on.

    DATA entity_name TYPE abp_entity_name.

    entity_name = g_ptf_bo.

    cl_abap_behv_load=>get_load(
      EXPORTING
        entity                     = entity_name                 " Entity Name for ABAP Behavior
        check_syntax               = abap_true
      IMPORTING
        actions                    = DATA(actions)
    ).

    READ TABLE actions WITH KEY owner_entity = entity_name name = input INTO DATA(action).
    IF sy-subrc = 0.
      output = action-ext_name.
    ENDIF.
  ENDIF.

ENDFUNCTION.
