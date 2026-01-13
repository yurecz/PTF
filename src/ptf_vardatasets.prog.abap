*&---------------------------------------------------------------------*
*& Include          PTF_VARDATASETS
*&---------------------------------------------------------------------*
CLASS lcl_event_receiver_vardatasets DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS:
      on_button_click FOR EVENT before_user_command OF cl_gui_alv_grid
        IMPORTING sender
                  e_ucomm,

      on_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_interactive
                  e_object
                  sender,

      on_user_command FOR EVENT user_command
        OF cl_gui_alv_grid
        IMPORTING e_ucomm sender,

      on_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING e_onf4
                  e_onf4_before     ##NEEDED
                  e_onf4_after      ##NEEDED
                  er_data_changed
                  e_ucomm
                  sender            ##NEEDED.

ENDCLASS.

CLASS lcl_event_receiver_vardatasets IMPLEMENTATION.
  METHOD on_button_click.
    DATA: lv_row_number         TYPE i,
          ls_outtab_vardatasets TYPE ptf_vardataset.

    lv_row_number = 0.

    g_grid_vardataset->get_selected_rows(
      IMPORTING
        et_row_no     =  DATA(lt_row_no) ).

    READ TABLE lt_row_no INTO DATA(ls_row_no) INDEX 1.
    lv_row_number = ls_row_no-row_id.

    CASE e_ucomm.
      WHEN 'DELETE_ROW'.
        IF lt_row_no IS NOT INITIAL.
          SORT lt_row_no BY row_id DESCENDING.

          LOOP AT lt_row_no ASSIGNING FIELD-SYMBOL(<fs_row_no>).
            DELETE gt_outtab_vardataset INDEX <fs_row_no>-row_id.

          ENDLOOP.

        ENDIF.

      WHEN 'INSERT_ROW'.
        IF lv_row_number IS INITIAL.
          lv_row_number = 1.

        ENDIF.

*        ls_outtab_vardatasets-varname            = 'CONTAIN'.

        INSERT ls_outtab_vardatasets INTO gt_outtab_vardataset INDEX lv_row_number.

      WHEN 'APPEND_ROW'.

*        ls_outtab_vardatasets-varname            = 'CONTAIN'.

        APPEND ls_outtab_vardatasets TO gt_outtab_vardataset.

    ENDCASE.

    PERFORM refresh_vardatasets.

  ENDMETHOD.                    "on_button_click

  METHOD on_toolbar.
    DATA: ls_toolbar  TYPE stb_button.
    CLEAR e_object->mt_toolbar.
    CLEAR ls_toolbar.
    ls_toolbar-butn_type = 3.
    APPEND ls_toolbar TO e_object->mt_toolbar.

    CLEAR ls_toolbar.
    ls_toolbar-function   = 'APPEND_ROW'.
    ls_toolbar-icon       = icon_create.
    ls_toolbar-quickinfo  = 'Append Row'.
    APPEND ls_toolbar TO e_object->mt_toolbar.

    CLEAR ls_toolbar.
    ls_toolbar-function   = 'INSERT_ROW'.
    ls_toolbar-icon       = icon_insert_row.
    ls_toolbar-quickinfo  = 'Insert Row'.
    APPEND ls_toolbar TO e_object->mt_toolbar.

    CLEAR ls_toolbar.
    ls_toolbar-function   = 'DELETE_ROW'.
    ls_toolbar-icon       = icon_delete_row.
    ls_toolbar-quickinfo  = 'Delete Row'.
    APPEND ls_toolbar TO e_object->mt_toolbar.

  ENDMETHOD.                    "on_toolbar

  METHOD on_data_changed.
    DATA: lv_dataset_id       TYPE ptf_vardataset-dataset_id,
          lv_variable_name    TYPE ptf_vardataset-variable_name,
          lv_duplicate_entry  TYPE abap_bool,
          lv_key_modified     TYPE abap_bool.

    LOOP AT er_data_changed->mt_mod_cells ASSIGNING FIELD-SYMBOL(<fs_mod_cells>).
*     Check if there is another identical line with the same data set ID and variable name
      CLEAR lv_duplicate_entry.

      CLEAR lv_dataset_id.

      IF line_exists( er_data_changed->mt_mod_cells[ row_id = <fs_mod_cells>-row_id fieldname = 'DATASET_ID' ] ).
        lv_dataset_id = er_data_changed->mt_mod_cells[ row_id = <fs_mod_cells>-row_id fieldname = 'DATASET_ID' ]-value.
        lv_key_modified = abap_on.

      ELSEIF line_exists( gt_outtab_vardataset[ <fs_mod_cells>-row_id ] ).
        lv_dataset_id = gt_outtab_vardataset[ <fs_mod_cells>-row_id ]-dataset_id.

      ENDIF.

      CLEAR lv_variable_name.

      IF line_exists( er_data_changed->mt_mod_cells[ row_id = <fs_mod_cells>-row_id fieldname = 'VARIABLE_NAME' ] ).
        lv_variable_name = er_data_changed->mt_mod_cells[ row_id = <fs_mod_cells>-row_id fieldname = 'VARIABLE_NAME' ]-value.
        lv_key_modified = abap_on.

      ELSEIF line_exists( gt_outtab_vardataset[ <fs_mod_cells>-row_id ] ).
        lv_variable_name = gt_outtab_vardataset[ <fs_mod_cells>-row_id ]-variable_name.

      ENDIF.

      IF lv_dataset_id IS NOT INITIAL AND lv_variable_name IS NOT INITIAL AND lv_key_modified = abap_on.
        LOOP AT gt_outtab_vardataset ASSIGNING FIELD-SYMBOL(<fs_outtab_vardataset>)
          WHERE dataset_id = lv_dataset_id AND variable_name = lv_variable_name.
          DATA(lv_tabix) = sy-tabix.
          IF lv_tabix <> <fs_mod_cells>-row_id.
            lv_duplicate_entry = abap_on.

          ENDIF.

        ENDLOOP.

      ENDIF.

      CASE <fs_mod_cells>-fieldname.
        WHEN 'DATASET_ID'.
          IF <fs_mod_cells>-value IS INITIAL.
            er_data_changed->add_protocol_entry(
              EXPORTING
                i_msgid     = 'PTF'
                i_msgno     = '070'
                i_msgty     = 'E'
                i_msgv1     = 'Test Data Set ID is mandatory'
                i_fieldname = <fs_mod_cells>-fieldname
                i_row_id    = <fs_mod_cells>-row_id ).

          ELSEIF lv_duplicate_entry = abap_on.
            er_data_changed->add_protocol_entry(
              EXPORTING
                i_msgid     = 'PTF'
                i_msgno     = '070'
                i_msgty     = 'E'
                i_msgv1     = 'There is a duplicate entry with the same key'
                i_fieldname = <fs_mod_cells>-fieldname
                i_row_id    = <fs_mod_cells>-row_id ).

          ENDIF.

        WHEN 'VARIABLE_NAME'.
          IF <fs_mod_cells>-value IS INITIAL.
            er_data_changed->add_protocol_entry(
              EXPORTING
                i_msgid     = 'PTF'
                i_msgno     = '070'
                i_msgty     = 'E'
                i_msgv1     = 'Variable Name is mandatory'
                i_fieldname = <fs_mod_cells>-fieldname
                i_row_id    = <fs_mod_cells>-row_id ).

          ELSEIF <fs_mod_cells>-value+0(1) <> '&'.
            er_data_changed->add_protocol_entry(
              EXPORTING
                i_msgid     = 'PTF'
                i_msgno     = '070'
                i_msgty     = 'E'
                i_msgv1     = 'Variable Name has to begin with &'
                i_fieldname = <fs_mod_cells>-fieldname
                i_row_id    = <fs_mod_cells>-row_id ).

          ELSEIF lv_duplicate_entry = abap_on.
            er_data_changed->add_protocol_entry(
              EXPORTING
                i_msgid     = 'PTF'
                i_msgno     = '070'
                i_msgty     = 'E'
                i_msgv1     = 'There is a duplicate entry with the same key'
                i_fieldname = <fs_mod_cells>-fieldname
                i_row_id    = <fs_mod_cells>-row_id ).

          ENDIF.

      ENDCASE.

    ENDLOOP.

  ENDMETHOD.                    "on_data_changed

  METHOD on_user_command.
    CASE e_ucomm.
      WHEN 'INSERT_ROW' OR 'APPEND_ROW'.
        DATA: lt_delta_cells TYPE lvc_t_modi,
              ls_delta_cells TYPE lvc_s_modi.

        LOOP AT gt_outtab_vardataset ASSIGNING FIELD-SYMBOL(<fs_outtab_vardataset>).
          DATA(lv_tabix) = sy-tabix.

          IF <fs_outtab_vardataset>-dataset_id IS INITIAL.
            ls_delta_cells-row_id    = lv_tabix.
            ls_delta_cells-fieldname = 'DATASET_ID'.
            APPEND ls_delta_cells TO lt_delta_cells.

          ENDIF.

          IF <fs_outtab_vardataset>-variable_name IS INITIAL.
            ls_delta_cells-row_id    = lv_tabix.
            ls_delta_cells-fieldname = 'VARIABLE_NAME'.
            APPEND ls_delta_cells TO lt_delta_cells.

          ENDIF.

          IF <fs_outtab_vardataset>-variable_value IS INITIAL.
            ls_delta_cells-row_id    = lv_tabix.
            ls_delta_cells-fieldname = 'VARIABLE_VALUE'.
            APPEND ls_delta_cells TO lt_delta_cells.

          ENDIF.

        ENDLOOP.

        IF lt_delta_cells IS NOT INITIAL.
          g_grid_vardataset->set_delta_cells(
            EXPORTING
              it_delta_cells = lt_delta_cells
              i_modified     = abap_on
          ).

        ENDIF.

    ENDCASE.

  ENDMETHOD.                    "on_data_changed_finished

ENDCLASS.

MODULE pbo_3103 OUTPUT.
  PERFORM pbo_3103.

ENDMODULE.

MODULE pai_3103 INPUT.
  PERFORM pai_3103.

ENDMODULE.

FORM pbo_3103.
  SET PF-STATUS 'VARDATASETS_STATUS'.

  SET TITLEBAR 'VARDATASETS'.

  IF g_grid_vardataset IS NOT BOUND.
    PERFORM build_vardatasets_fieldcat.

    CREATE OBJECT g_custom_container_ref_step
      EXPORTING
        container_name = 'TABLE'.

    CREATE OBJECT g_grid_vardataset
      EXPORTING
        i_parent = g_custom_container_ref_step.

    g_grid_vardataset->set_ready_for_input(
      EXPORTING
        i_ready_for_input = 1 ).

*    g_grid_vardatasets->register_edit_event(
*      EXPORTING
*        i_event_id = cl_gui_alv_grid=>mc_evt_modified ).

    CREATE OBJECT go_ptf_vardataset_event.
    SET HANDLER go_ptf_vardataset_event->on_toolbar FOR g_grid_vardataset.
    SET HANDLER go_ptf_vardataset_event->on_button_click FOR g_grid_vardataset.
    SET HANDLER go_ptf_vardataset_event->on_data_changed FOR g_grid_vardataset.
    SET HANDLER go_ptf_vardataset_event->on_user_command FOR g_grid_vardataset.

    g_grid_vardataset->set_table_for_first_display(
      CHANGING
        it_outtab       = gt_outtab_vardataset
        it_fieldcatalog = gt_fieldcat_vardataset ).

*    PERFORM refresh_vardatasets.

  ENDIF.

ENDFORM.

FORM pai_3103.
  CASE more_ok.
    WHEN 'CONTI'.
      g_grid_vardataset->check_changed_data( IMPORTING e_valid = DATA(lv_valid) ).
      IF lv_valid = abap_on.
        g_grid_vardataset->free( ).
        g_custom_container_ref_step->free( ).
        CLEAR: g_grid_vardataset, g_custom_container_ref_step.
*        CLEAR: gt_outtab_vardataset.
        CLEAR: gt_fieldcat_vardataset.

        LEAVE TO SCREEN 0.

      ENDIF.

    WHEN OTHERS.
      g_grid_vardataset->free( ).
      g_custom_container_ref_step->free( ).
      CLEAR: g_grid_vardataset, g_custom_container_ref_step.
*      CLEAR: gt_outtab_vardataset.
      CLEAR: gt_fieldcat_vardataset.

      LEAVE TO SCREEN 0.

  ENDCASE.

ENDFORM.

FORM open_vardatasets.
  CALL SCREEN 3103 STARTING AT 50 1.

ENDFORM.

FORM build_vardatasets_fieldcat.
  DATA: ls_fieldcatalog     TYPE lvc_s_fcat.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'DATASET_ID'.
  ls_fieldcatalog-ref_table = 'PTF_VARDATASET'.
  ls_fieldcatalog-edit      = 'X'.
  ls_fieldcatalog-outputlen = 30.
  APPEND ls_fieldcatalog TO gt_fieldcat_vardataset.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'VARIABLE_NAME'.
  ls_fieldcatalog-ref_table = 'PTF_VARDATASET'.
  ls_fieldcatalog-edit      = 'X'.
  ls_fieldcatalog-outputlen = 30.
  APPEND ls_fieldcatalog TO gt_fieldcat_vardataset.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'VARIABLE_VALUE'.
  ls_fieldcatalog-ref_table = 'PTF_VARDATASET'.
  ls_fieldcatalog-edit      = 'X'.
  ls_fieldcatalog-outputlen = 30.
  APPEND ls_fieldcatalog TO gt_fieldcat_vardataset.

ENDFORM.

FORM refresh_vardatasets.
  g_grid_vardataset->refresh_table_display( ).

ENDFORM.
