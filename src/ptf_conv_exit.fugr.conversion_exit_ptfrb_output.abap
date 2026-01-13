FUNCTION conversion_exit_ptfrb_output.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(INPUT) TYPE  CLIKE
*"  EXPORTING
*"     REFERENCE(OUTPUT) TYPE  CLIKE
*"----------------------------------------------------------------------

  output = input.

  g_ptf_bo = input.

  DATA rap_metadata TYPE REF TO cl_ptf_rap_metadata.

  rap_metadata = NEW #( ).

  IF rap_metadata->check_rap_bo( CONV #( input ) ) = abap_on.

    DATA entity_name TYPE abp_entity_name.

    entity_name = CONV #( input ).

    cl_abap_behv_load=>get_load(
      EXPORTING
        entity                      = CONV #( input )                 " Entity Name for ABAP Behavior
        check_syntax                = abap_true
      IMPORTING
        entities                    = DATA(entities)
    ).

    READ TABLE entities WITH KEY name = entity_name  INTO DATA(entity).
    IF sy-subrc = 0.
      output = entity-ext_name.
    ENDIF.
  ENDIF.

ENDFUNCTION.
