*&---------------------------------------------------------------------*
*& Include          PTF_CHECK_ALV_INPUT
*&---------------------------------------------------------------------*
*FORM alv_value_check USING    it_step_data        TYPE cl_ptf_util=>gt_ptf_step_tab
*                     CHANGING ev_check_alv_status TYPE abap_bool.
*
*  ASSERT 1 = 2. "Form is OBSOLETE. replaced with Syntax check class.
*
*ENDFORM.

*FORM set_focus USING iv_col_fname TYPE lvc_fname
*                     iv_row_index TYPE int4.
*
*  DATA:
*    lt_cells TYPE lvc_t_cell,
*    ls_cell  TYPE lvc_s_cell.
*
*  ls_cell-col_id-fieldname = iv_col_fname.
*  ls_cell-row_id-index     = iv_row_index.
*  APPEND ls_cell TO lt_cells.
*  g_grid_step->set_selected_cells( it_cells = lt_cells ).
*
*ENDFORM.

FORM set_focus_oo USING io_error TYPE REF TO cl_ptf_static_syntax_error.

  g_grid_step->set_selected_cells_for( io_error = io_error ).

ENDFORM.

FORM check_last_step USING it_step_data TYPE cl_ptf_util=>gt_ptf_step_tab
                           iv_is_batch  TYPE abap_bool.

  DATA lv_data_proof_length TYPE i.
  DATA lb_empty_line_passed TYPE abap_bool.

  CHECK iv_is_batch IS INITIAL.

  lv_data_proof_length = 0.
  LOOP AT it_step_data ASSIGNING FIELD-SYMBOL(<ls_data_proof>).

    "Empty lines should be ignored.
    IF <ls_data_proof>-action IS NOT INITIAL
     OR <ls_data_proof>-bus_obj IS NOT INITIAL
     OR <ls_data_proof>-reference_step  IS NOT INITIAL
     OR <ls_data_proof>-variant IS NOT INITIAL.

      lv_data_proof_length = lv_data_proof_length + 1.
      IF lb_empty_line_passed EQ abap_true.
        RETURN. "End the form - Do not do thr check below if there are filled lines after empty line(s)
      ENDIF.

    ELSE.
      lb_empty_line_passed = abap_true.
    ENDIF.
  ENDLOOP.

  READ TABLE it_step_data ASSIGNING <ls_data_proof> INDEX lv_data_proof_length.
  IF <ls_data_proof> IS ASSIGNED.
    SELECT SINGLE ptf_check_action FROM ptfboa INTO <ls_data_proof>-check_flag WHERE ptf_act = <ls_data_proof>-action AND ptf_bo = <ls_data_proof>-bus_obj.
    IF sy-subrc IS INITIAL AND <ls_data_proof>-check_flag EQ abap_false.
      MESSAGE ID 'PTF' TYPE 'S' NUMBER 043 DISPLAY LIKE 'W'.
    ENDIF.
  ENDIF.

ENDFORM.
