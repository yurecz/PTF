*&---------------------------------------------------------------------*
*& Include          PTF_SCREENS
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form Apllicatoin Log
*&---------------------------------------------------------------------*
FORM ap_log.

  DATA: variant_display TYPE REF TO cl_ptf_alv_elements.
  variant_display = NEW cl_ptf_alv_elements( ).
  TRY.
      variant_display->show_list_of_log_statements(
    CHANGING
      statements = gt_full_log
  ).
    CATCH cx_salv_msg. " ALV: General Error Class with Message
  ENDTRY.

ENDFORM.
