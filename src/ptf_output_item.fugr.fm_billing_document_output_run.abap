FUNCTION FM_BILLING_DOCUMENT_OUTPUT_RUN.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(OUT_CHANNEL) TYPE  SFORM_S_CHANNEL-CHANNEL
*"     REFERENCE(VBELN) TYPE  VBRK-VBELN
*"  EXPORTING
*"     REFERENCE(SUBRC) TYPE  SY-SUBRC
*"----------------------------------------------------------------------
  SUBMIT billing_document_output_run
    WITH so_oc EQ out_channel
    WITH so_vbeln EQ vbeln
    AND RETURN.

  subrc = sy-subrc.

ENDFUNCTION.
