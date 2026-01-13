*----------------------------------------------------------------------*
***INCLUDE PROCESS_TEST_FRAMEWORK_FILLF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form FILL_CHECK_FLAG
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fill_check_flag .
  LOOP AT lt_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data>).
    IF <ls_step_data>-bus_obj IS NOT INITIAL.
      SELECT SINGLE ptf_check_action FROM ptfboa INTO <ls_step_data>-check_flag WHERE ptf_act = <ls_step_data>-action AND ptf_bo = <ls_step_data>-bus_obj.
    ENDIF.
  ENDLOOP.
ENDFORM.
