*&---------------------------------------------------------------------*
*& Include          PTF_SAVE
*&---------------------------------------------------------------------*

DATA:
* reference to wrapper class of control based on OO Framework
  g_editor                    TYPE REF TO cl_gui_textedit,
  excluded_functions_tag_grid TYPE ui_functions,
  gs_tags_layout              TYPE lvc_s_layo,
* reference to custom container: necessary to bind TextEdit Control
  g_editor_container          TYPE REF TO cl_gui_custom_container,
  g_tags_container            TYPE REF TO cl_gui_custom_container,
  g_tags                      TYPE REF TO cl_gui_alv_grid,
* other variables
  g_repid                     LIKE sy-repid.
DATA gb_property_display_only TYPE abap_bool.

CONSTANTS gc_wordrap_position TYPE i VALUE 130.

* necessary to flush the automation queue
CLASS cl_gui_cfw DEFINITION LOAD.



************************************************************************
*   P B O  6001
************************************************************************
MODULE pbo_6001 OUTPUT.  "6001 is the SAVE dialog screen

  CLEAR more_ok.
  SET PF-STATUS 'SAVE_STATUS'.
  SET TITLEBAR 'MAIN100'.

  LOOP AT SCREEN INTO DATA(ls_element).
    IF ls_element-name EQ 'P_VANAME'.
      ls_element-required = '1'.
      MODIFY SCREEN FROM ls_element.
    ENDIF.
  ENDLOOP.

  PERFORM create_text_control. "consumes gt_text_table

  " Tag handling:

  g_tags_container = NEW cl_gui_custom_container( container_name = 'TAGS' ).
  g_tags = NEW cl_gui_alv_grid( i_parent = g_tags_container ).

  gs_tags_layout-edit = 'X'.

  PERFORM get_excluded_functions__tag.

  g_tags->set_table_for_first_display(
    EXPORTING
      it_toolbar_excluding = excluded_functions_tag_grid
      i_structure_name     = 'PTF_VARIANT_TAG_INPUT'
      is_layout            = gs_tags_layout
    CHANGING
      it_outtab            = gt_ptf_var_tags
  ).

  g_tags->set_ready_for_input( 1 ).

* remember: there is an automatic flush at the end of PBO!

ENDMODULE.                             " PBO


************************************************************************
*   P A I  6001
************************************************************************
MODULE pai_6001 INPUT.

  DATA l_text_table_6 TYPE TABLE OF ptf_text.
*  CLEAR gt_text_table.


  CASE more_ok.

    WHEN 'SICH'.

      g_tags->check_changed_data( ).  "changes GT_PTF_VAR_TAGS   "ToDo: duplicate Tags are not detected before DB INSERT, a check for this is missing

*     retrieve table from control
      CALL METHOD g_editor->get_text_as_r3table
        IMPORTING
          table  = l_text_table_6
        EXCEPTIONS
          OTHERS = 1.
      IF sy-subrc = 0.
        gt_text_table = l_text_table_6.
        CLEAR l_text_table_6.
      ENDIF.

      PERFORM exit_the_popup.


*    WHEN 'CANC'.
*      gv_cancel = abap_true.
*      PERFORM exit_the_popup.

  ENDCASE.

ENDMODULE.                             " PAI

MODULE cancel INPUT. "6001
  CASE more_ok.

    WHEN 'CANC'.
      gv_cancel = abap_true.
      PERFORM exit_the_popup.

  ENDCASE.

ENDMODULE.


************************************************************************
*   P B O  7001  The Update dialog screen, also DisplayProperties screen
************************************************************************
MODULE pbo_7001 OUTPUT.

  CLEAR more_ok.

  "7001 is also used for Display Properties
  IF gb_property_display_only EQ abap_true.
    PERFORM tmp_form_for_displ_properties.
    RETURN.
  ENDIF.

  SET PF-STATUS 'SAVE_STATUS'.
  SET TITLEBAR 'MAIN100'.

*  LOOP AT SCREEN INTO DATA(ls_element2).
*    IF ls_element2-input EQ '1' AND sy-uname EQ 'GRIESEC'. "on
*      ls_element2-input = '0'.
*      MODIFY SCREEN FROM ls_element2.
*    ENDIF.
*  ENDLOOP.

  PERFORM create_text_control. "consumes gt_text_table

  " Tag handling:
  PERFORM handle_tag_table USING abap_true. "true=changeable

* remember: there is an automatic flush at the end of PBO!

ENDMODULE.

************************************************************************
*   P A I  7001  Update dialog screen, also DisplayProperties screen
************************************************************************
MODULE pai_7001 INPUT.

  DATA l_text_table_7 TYPE TABLE OF ptf_text.

  CASE more_ok.

    WHEN 'SICH'.

      g_tags->check_changed_data( ).  "changes GT_PTF_VAR_TAGS!   "ToDo: duplicate Tags are not detected before DB INSERT, a check for this is missing

*     retrieve table from control
      CALL METHOD g_editor->get_text_as_r3table
        IMPORTING
          table  = l_text_table_7
        EXCEPTIONS
          OTHERS = 1.
      IF sy-subrc = 0.
        gt_text_table = l_text_table_7.
        CLEAR l_text_table_7.
      ENDIF.

      PERFORM exit_the_popup.


    WHEN 'CANC'.
      gv_cancel = abap_true.
      PERFORM exit_the_popup.

    WHEN 'CONTI'.            "only used for property popup, status 'MORE3001'
      PERFORM exit_the_popup.


*   no flush here:
*   the automatic flush at the end of PBO does the job

  ENDCASE.

ENDMODULE.                             " PAI


************************************************************************
*  F O R M S  (Save, Update DisplayProperties
************************************************************************

*&---------------------------------------------------------------------*
*&      Form  EXIT_PROGRAM
*&---------------------------------------------------------------------*
FORM exit_the_popup.

  g_tags->check_changed_data( )."needed? or do only if not cancelled, action specific, above? Doing this also after Cancel is no problem, as GT_PTF_VAR_TAGS is read newly anyway

* destroy controls

  IF NOT g_tags IS INITIAL.
    CALL METHOD g_tags->free
      EXCEPTIONS
        OTHERS = 1.
*   free ABAP object also
    FREE g_tags.
  ENDIF.

  IF NOT g_editor IS INITIAL.
    CALL METHOD g_editor->free
      EXCEPTIONS
        OTHERS = 1.
*   free ABAP object also
    FREE g_editor.
  ENDIF.

* destroy containers

  IF NOT g_editor_container IS INITIAL.
    CALL METHOD g_editor_container->free
      EXCEPTIONS
        OTHERS = 1.
    IF sy-subrc <> 0.
*      MESSAGE E002 WITH F_RETURN.
    ENDIF.
*   free ABAP object also
    FREE g_editor_container.
  ENDIF.

  IF NOT g_tags_container IS INITIAL.
    CALL METHOD g_tags_container->free
      EXCEPTIONS
        OTHERS = 1.
    IF sy-subrc <> 0.
*      MESSAGE E002 WITH F_RETURN.
    ENDIF.
*   free ABAP object also
    FREE g_tags_container.
  ENDIF.


* finally flush
  CALL METHOD cl_gui_cfw=>flush
    EXCEPTIONS
      OTHERS = 1.
*  IF sy-subrc NE 0.
*  ENDIF.

  LEAVE TO SCREEN 0.

ENDFORM.


FORM get_excluded_functions__tag.

  CHECK excluded_functions_tag_grid IS INITIAL.

  APPEND cl_gui_alv_grid=>mc_mb_export TO excluded_functions_tag_grid.
  APPEND cl_gui_alv_grid=>mc_mb_view TO excluded_functions_tag_grid.
  APPEND cl_gui_alv_grid=>mc_fc_print TO excluded_functions_tag_grid.
  APPEND cl_gui_alv_grid=>mc_fc_graph TO excluded_functions_tag_grid.
  APPEND cl_gui_alv_grid=>mc_fc_info TO excluded_functions_tag_grid.
  APPEND cl_gui_alv_grid=>mc_fc_detail TO excluded_functions_tag_grid.
  APPEND cl_gui_alv_grid=>mc_fc_check TO excluded_functions_tag_grid.
  APPEND cl_gui_alv_grid=>mc_fc_refresh TO excluded_functions_tag_grid.
  APPEND cl_gui_alv_grid=>mc_fc_loc_cut TO excluded_functions_tag_grid.
  APPEND cl_gui_alv_grid=>mc_fc_loc_copy TO excluded_functions_tag_grid.
  APPEND cl_gui_alv_grid=>mc_mb_paste TO excluded_functions_tag_grid.
  APPEND cl_gui_alv_grid=>mc_fc_loc_undo TO excluded_functions_tag_grid.
  APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row TO excluded_functions_tag_grid.
  APPEND cl_gui_alv_grid=>mc_fc_sort_asc TO excluded_functions_tag_grid.
  APPEND cl_gui_alv_grid=>mc_fc_sort_dsc TO excluded_functions_tag_grid.
  APPEND cl_gui_alv_grid=>mc_fc_find TO excluded_functions_tag_grid.
  APPEND cl_gui_alv_grid=>mc_fc_find_more TO excluded_functions_tag_grid.
  APPEND cl_gui_alv_grid=>mc_fc_filter TO excluded_functions_tag_grid.
  APPEND cl_gui_alv_grid=>mc_mb_variant TO excluded_functions_tag_grid.
  APPEND cl_gui_alv_grid=>mc_mb_sum TO excluded_functions_tag_grid.

ENDFORM.

FORM create_text_control.

  IF g_editor IS INITIAL.
*   initialize local variable with sy-repid, since sy-repid doesn't work as parameter directly.
    g_repid = sy-repid.

*   create control container
    CREATE OBJECT g_editor_container
      EXPORTING
        container_name              = 'EDITOR'
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5.
    IF sy-subrc NE 0.
*      add your handling
    ENDIF.

*   The constructor initializes, creates and links a TextEdit Control
    CREATE OBJECT g_editor
      EXPORTING
        parent                     = g_editor_container
        wordwrap_position          = gc_wordrap_position
        wordwrap_mode              = cl_gui_textedit=>wordwrap_at_fixed_position
        wordwrap_to_linebreak_mode = cl_gui_textedit=>false
      EXCEPTIONS
        OTHERS                     = 1.
*    IF sy-subrc NE 0.
*    ENDIF.

    g_editor->set_toolbar_mode( cl_gui_textedit=>false ).
    g_editor->set_statusbar_mode( statusbar_mode = cl_gui_textedit=>false ).
  ENDIF.

  CALL METHOD g_editor->set_text_as_r3table
    EXPORTING
      table  = gt_text_table
    EXCEPTIONS
      OTHERS = 1.

  "Set Readonly to false (Always set it new, to overwrite the previous setting)
  g_editor->set_readonly_mode(
    EXPORTING
      readonly_mode          = 0 "off           " read-only mode; eq 0: OFF ; ne 0: ON
    EXCEPTIONS
      error_cntl_call_method = 1                " Error while setting read-only mode!
      invalid_parameter      = 2                " INVALID_PARAMETER
      OTHERS                 = 3
  ).
  IF sy-subrc <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*       WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.

FORM handle_tag_table USING ub_changeable TYPE abap_bool.

  " Tag handling:

  g_tags_container = NEW cl_gui_custom_container( container_name = 'TAGS' ).
  g_tags = NEW cl_gui_alv_grid( i_parent = g_tags_container ).

  IF ub_changeable EQ abap_true.
    gs_tags_layout-edit = 'X'.
  ELSE.
    CLEAR gs_tags_layout-edit.
  ENDIF.

  PERFORM get_excluded_functions__tag.

  g_tags->set_table_for_first_display(
    EXPORTING
      it_toolbar_excluding = excluded_functions_tag_grid
      i_structure_name     = 'PTF_VARIANT_TAG_INPUT'
      is_layout            = gs_tags_layout
    CHANGING
      it_outtab            = gt_ptf_var_tags
  ).

  IF ub_changeable EQ abap_true.
    g_tags->set_ready_for_input( 1 ).
  ELSE.
    g_tags->set_ready_for_input( 0 ).
  ENDIF.

ENDFORM.


FORM tmp_form_for_displ_properties.

  SET PF-STATUS 'MORE3001'.
  SET TITLEBAR 'MAIN100'.

  LOOP AT SCREEN INTO DATA(ls_element2).
    IF ls_element2-input EQ '1'. "on
      ls_element2-input = '0'.
      MODIFY SCREEN FROM ls_element2.
    ENDIF.
  ENDLOOP.

  PERFORM create_text_control. "consumes gt_text_table

  g_editor->set_readonly_mode(
    EXPORTING
      readonly_mode          = 1 "on            " read-only mode; eq 0: OFF ; ne 0: ON
    EXCEPTIONS
      error_cntl_call_method = 1                " Error while setting read-only mode!
      invalid_parameter      = 2                " INVALID_PARAMETER
      OTHERS                 = 3
  ).
  IF sy-subrc <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*       WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  " Tag handling:
  PERFORM handle_tag_table USING abap_false. "ub_changeable = false

ENDFORM.
