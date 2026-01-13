*&---------------------------------------------------------------------*
*& Include          PTF_TABLES_EVENT
*&---------------------------------------------------------------------*

CLASS lcl_event_receiver_tables DEFINITION.

  PUBLIC SECTION.
    METHODS:

      on_button_click FOR EVENT before_user_command OF cl_gui_alv_grid
        IMPORTING sender
                    e_ucomm,

      on_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_interactive
                    e_object
                    sender,

      on_data_changed_ref_step FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING e_onf4
                    e_onf4_before
                    e_onf4_after
                    er_data_changed
                    e_ucomm
                    sender,

      on_data_ch_finished_ref_step FOR EVENT data_changed_finished OF cl_gui_alv_grid  "method is empty
        IMPORTING sender,

      on_data_ch_ref_doc_id FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING e_onf4
                    e_onf4_before
                    e_onf4_after
                    er_data_changed
                    e_ucomm
                    sender,

      on_data_ch_finished_ref_doc_id FOR EVENT data_changed_finished OF cl_gui_alv_grid
        IMPORTING sender.

  PRIVATE SECTION.

ENDCLASS.
*****************************************************************************************
CLASS lcl_event_receiver_tables IMPLEMENTATION.


  METHOD on_toolbar.
    DATA: ls_toolbar  TYPE stb_button.
    CLEAR e_object->mt_toolbar.
    CLEAR ls_toolbar.
    MOVE 3 TO ls_toolbar-butn_type.
    APPEND ls_toolbar TO e_object->mt_toolbar.

    CLEAR ls_toolbar.
    MOVE 'INSERT_ROW' TO ls_toolbar-function.
    MOVE icon_insert_row TO ls_toolbar-icon.
    MOVE 'Insert Row'(111) TO ls_toolbar-quickinfo.
    MOVE ''(112) TO ls_toolbar-text.
    MOVE ' ' TO ls_toolbar-disabled.
    APPEND ls_toolbar TO e_object->mt_toolbar.


    CLEAR ls_toolbar.
    MOVE 'DELETE_ROW' TO ls_toolbar-function.
    MOVE icon_delete_row TO ls_toolbar-icon.
    MOVE 'Delete Row'(111) TO ls_toolbar-quickinfo.
    MOVE ''(112) TO ls_toolbar-text.
    MOVE ' ' TO ls_toolbar-disabled.
    APPEND ls_toolbar TO e_object->mt_toolbar.

  ENDMETHOD.
**********************************************************************************************************
  METHOD on_button_click.

* handles insertion/deletion of lines in the popup for ReferenceSteps

    DATA: lt_row_no          TYPE        lvc_t_roid,
          ls_row_no          TYPE  LINE OF      lvc_t_roid,
          lt_cells           TYPE        lvc_t_ceno,
          ls_cells           TYPE LINE OF       lvc_t_ceno,
          lv_row_number      TYPE        i,
          ls_outtab_ref_step TYPE ty_outtab_ref_step,
          ls_outtab_doc_id   TYPE ty_doc_id.   "replace with INITIAL LINE

    lv_row_number = 0.

    g_grid_more->get_selected_rows(
      IMPORTING
        et_row_no     =  lt_row_no ).
    READ TABLE lt_row_no INTO ls_row_no INDEX 1.
    lv_row_number = ls_row_no-row_id.

    IF lv_row_number EQ 0.
      g_grid_more->get_selected_cells_id(
    IMPORTING
      et_cells =   lt_cells ).
      READ TABLE lt_cells INTO ls_cells INDEX 1.
      lv_row_number = ls_cells-row_id.
    ENDIF.

    IF lv_row_number NE 0.
      CASE   e_ucomm.
        WHEN 'DELETE_ROW'.
          IF gv_col_id EQ 'REFERENCE_STEP_MORE'.
            DELETE gt_outtab_ref_step INDEX  lv_row_number.
          ELSEIF gv_col_id EQ 'DOCUMENT_ID_MORE'.
            DELETE gt_outtab_doc_id INDEX  lv_row_number.
          ENDIF.
        WHEN 'INSERT_ROW'.
          IF gv_col_id EQ 'REFERENCE_STEP_MORE'.
            INSERT ls_outtab_ref_step INTO gt_outtab_ref_step INDEX lv_row_number.
          ELSEIF gv_col_id EQ 'DOCUMENT_ID_MORE'.
            INSERT ls_outtab_doc_id INTO gt_outtab_doc_id INDEX lv_row_number.
          ENDIF.
      ENDCASE.
    ENDIF.

    g_grid_more->refresh_table_display( ).

  ENDMETHOD.                    "on_button_click
**********************************************************************************************************
  METHOD on_data_changed_ref_step.

    "Immediately update gt_outtab_ref_step with the change (one field)

    DATA: ls_changed TYPE lvc_s_modi.
    FIELD-SYMBOLS: <ls_outtab_ref_step> TYPE ty_outtab_ref_step.

    IF gv_col_id EQ 'REFERENCE_STEP_MORE'.
      LOOP AT er_data_changed->mt_good_cells INTO ls_changed.
        READ TABLE gt_outtab_ref_step  ASSIGNING <ls_outtab_ref_step> INDEX ls_changed-row_id.
          IF sy-subrc = 0.
            <ls_outtab_ref_step>-ref_step_number = ls_changed-value.
          ENDIF.
      ENDLOOP.
    ELSEIF gv_col_id EQ 'DOCUMENT_ID_MORE'.
      LOOP AT er_data_changed->mt_good_cells INTO ls_changed.
        READ TABLE gt_outtab_doc_id  ASSIGNING FIELD-SYMBOL(<ls_outtab_doc_id>) INDEX ls_changed-row_id.
          IF sy-subrc = 0.
            <ls_outtab_doc_id>-vbeln = ls_changed-value.
          ENDIF.
      ENDLOOP.
    ENDIF.


  ENDMETHOD.                    "on_data_changed
**********************************************************************************************************
  METHOD on_data_ch_finished_ref_step.
*    DATA:
*      ls_row_no    TYPE lvc_s_roid,
*      ls_col_id    TYPE lvc_s_col,
*      lv_value(10) TYPE c,
*      feldname_ref TYPE REF TO data.
*
*    FIELD-SYMBOLS: <ls_outtab_ref_step> TYPE ty_outtab_ref_step.
*
*    g_grid_more->get_current_cell(
*       IMPORTING
*         e_value   =  lv_value
*         es_col_id = ls_col_id
*         es_row_no =     ls_row_no  ).
*
*    READ TABLE gt_outtab_ref_step  ASSIGNING <ls_outtab_ref_step> INDEX ls_row_no-row_id.
*    <ls_outtab_ref_step>-ref_step_number = lv_value.
  ENDMETHOD.
**********************************************************************************************************
  METHOD on_data_ch_ref_doc_id.

*    DATA:
*      ls_row_no    TYPE lvc_s_roid,
*      ls_col_id    TYPE lvc_s_col,
*      lv_value(10) TYPE c,
*      feldname_ref TYPE REF TO data.
*
*    FIELD-SYMBOLS: <ls_outtab_ref_doc_id> TYPE ty_doc_id.
*
*    g_grid_more->get_current_cell(
*       IMPORTING
*         e_value   =  lv_value
*         es_col_id = ls_col_id
*         es_row_no =     ls_row_no  ).
*
*    READ TABLE gt_outtab_ref_doc_id  ASSIGNING <ls_outtab_ref_doc_id> INDEX ls_row_no-row_id.
*    <ls_outtab_ref_doc_id>-vbeln = lv_value.

  ENDMETHOD.                    "on_data_changed

  METHOD on_data_ch_finished_ref_doc_id.

*    DATA:
*      ls_row_no    TYPE lvc_s_roid,
*      ls_col_id    TYPE lvc_s_col,
*      lv_value(10) TYPE c,
*      feldname_ref TYPE REF TO data.
*
*    FIELD-SYMBOLS: <ls_outtab_ref_doc_id> TYPE ty_doc_id.
*
*    g_grid_more->get_current_cell(
*       IMPORTING
*         e_value   =  lv_value
*         es_col_id = ls_col_id
*         es_row_no =     ls_row_no  ).
*
*    READ TABLE gt_outtab_ref_doc_id  ASSIGNING <ls_outtab_ref_doc_id> INDEX ls_row_no-row_id.
*    <ls_outtab_ref_doc_id>-vbeln = lv_value.

  ENDMETHOD.

ENDCLASS.
