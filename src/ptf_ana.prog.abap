*&---------------------------------------------------------------------*
*& Manage your PTF Variants
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ptf_ana.

TYPES: BEGIN OF ty_variant_display,
         varname     TYPE ptf_varname,
         description TYPE rvart_vtxt,
       END OF ty_variant_display,
       tt_variant_display TYPE STANDARD TABLE OF ty_variant_display WITH DEFAULT KEY,
       BEGIN OF ENUM tag_mode STRUCTURE tag_mode,
         add,
         delete,
       END OF ENUM tag_mode STRUCTURE tag_mode,
       BEGIN OF ty_ptf_tag,
         tag   TYPE ptf_variant_tag,
         vtext TYPE ptf_var_tagt-text,
       END OF ty_ptf_tag.

CONSTANTS: c_remove_tag TYPE string  VALUE 'REMOVE_TAG',
           c_add_tag    TYPE string VALUE 'ADD_TAG'.

DATA: ok_code             LIKE sy-ucomm,
      variants_to_display TYPE tt_variant_display,
      variants_to_tag     TYPE tt_variant_display,
      mode                TYPE tag_mode,
      tags                TYPE STANDARD TABLE OF ty_ptf_tag WITH DEFAULT KEY.

"Screen Elements
DATA: variants_to_display_t  TYPE REF TO cl_salv_table,
      variants_to_display_cc TYPE REF TO cl_gui_custom_container,

      variants_dc            TYPE REF TO cl_gui_docking_container,
      variants_to_tag_t      TYPE REF TO cl_salv_table,
      tags_dc                TYPE REF TO cl_gui_docking_container,
      tags_t                 TYPE REF TO cl_salv_table.

TYPES: lty_cond     TYPE c LENGTH 800,
       lty_cond_tab TYPE STANDARD TABLE OF lty_cond.

START-OF-SELECTION.

  SET PF-STATUS 'PTFANA'.
  SET TITLEBAR 'SEL_SCREEN'.

  PARAMETERS: variant    TYPE string.

  DATA: scope_item   TYPE ptf_scope_item,
        tag          TYPE ptf_variant_tag,
        conditions   TYPE lty_cond_tab,
        where_clause TYPE string.

  SELECT-OPTIONS: s_si FOR scope_item NO INTERVALS,
                  s_tag FOR tag MATCHCODE OBJECT shptf_ptf_var_tag NO INTERVALS.


  IF variant IS NOT INITIAL.
    IF variant CA '*' OR variant CA '%*'.   "why * ??
      APPEND |ptf_varid~varname like { cl_abap_dyn_prg=>quote( variant ) }| TO conditions.

    ELSE.
      APPEND |ptf_varid~varname = { cl_abap_dyn_prg=>quote( variant ) }| TO conditions.
    ENDIF.
  ENDIF.

  IF s_si IS NOT INITIAL.
    APPEND |ptf_varid~scope_item IN @s_si| TO conditions.
  ENDIF.

  IF s_tag IS NOT INITIAL.
    APPEND |ptf_var_tag_map~tag IN @s_tag| TO conditions.
  ENDIF.

  IF conditions IS NOT INITIAL.

    CONCATENATE LINES OF conditions  INTO where_clause SEPARATED BY ' AND '.

    SELECT DISTINCT ptf_varid~varname AS varname, ptf_varid_t~vtext AS description  FROM ptf_varid
      LEFT OUTER JOIN ptf_var_tag_map
      ON ptf_varid~varname = ptf_var_tag_map~varname
      LEFT OUTER JOIN ptf_varid_t
      ON ptf_varid~varname = ptf_varid_t~varname AND ptf_varid_t~langu = @sy-langu
      INTO CORRESPONDING FIELDS OF TABLE @variants_to_display
      WHERE (where_clause).

  ELSE.

    SELECT DISTINCT ptf_varid~varname, ptf_varid_t~vtext AS description  FROM ptf_varid
      LEFT OUTER JOIN ptf_var_tag_map
      ON ptf_varid~varname = ptf_var_tag_map~varname
      LEFT OUTER JOIN ptf_varid_t
      ON ptf_varid~varname = ptf_varid_t~varname AND ptf_varid_t~langu = @sy-langu
      INTO CORRESPONDING FIELDS OF TABLE @variants_to_display.

  ENDIF.

  CALL SCREEN 0001.


CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.

    CLASS-METHODS : on_toolbar_click_main FOR EVENT added_function OF cl_salv_events_table
      IMPORTING
        e_salv_function
        sender,
      on_toolbar_click_sub FOR EVENT added_function OF cl_salv_events_table
        IMPORTING
          e_salv_function
          sender.
ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.

  METHOD on_toolbar_click_main.

    DATA(selections) = variants_to_display_t->get_selections( )->get_selected_rows( ).
    CLEAR ok_code.
    CLEAR variants_to_tag.
    LOOP AT selections ASSIGNING FIELD-SYMBOL(<selection>).
      TRY.
          APPEND variants_to_display[ <selection> ] TO variants_to_tag.
        CATCH cx_root.
      ENDTRY.
    ENDLOOP.

    IF variants_to_tag IS INITIAL.
      APPEND LINES OF variants_to_display TO variants_to_tag.
    ENDIF.

    CASE e_salv_function.
      WHEN c_add_tag.
        mode = tag_mode-add.
        SET TITLEBAR 'ADD'.
      WHEN c_remove_tag.
        SET TITLEBAR 'REMOVE'.
        mode = tag_mode-delete.
    ENDCASE.

    CALL SCREEN 0002.

    SET TITLEBAR 'RESULT'.

  ENDMETHOD.

  METHOD on_toolbar_click_sub.
    DATA: rows_to_delete TYPE STANDARD TABLE OF ptf_variant_tag_input WITH DEFAULT KEY.

    CASE e_salv_function.
      WHEN 'ADD_ROW'.
        DATA(ptf_tag) = NEW cl_ptf_alv_elements( )->show_list_of_ptf_tags( ).
        TRY.
            DATA(entry) = tags[ table_line = ptf_tag-tag ].
          CATCH cx_root.
            APPEND VALUE #( tag = ptf_tag-tag vtext = ptf_tag-text ) TO tags.
        ENDTRY.
      WHEN 'DELETE_ROW'.

        DATA(selected_rows) = tags_t->get_selections( )->get_selected_rows( ).

        LOOP AT selected_rows ASSIGNING FIELD-SYMBOL(<selected_row>).
          TRY.
              APPEND tags[ <selected_row> ] TO rows_to_delete.
            CATCH cx_root.
          ENDTRY.
        ENDLOOP.

        LOOP AT rows_to_delete ASSIGNING FIELD-SYMBOL(<row_to_delete>).
          DELETE tags WHERE table_line = <row_to_delete>-tag.
        ENDLOOP.

    ENDCASE.

    tags_t->refresh( ).

  ENDMETHOD.

ENDCLASS.

MODULE pbo_0001 OUTPUT.

  SET PF-STATUS 'PTFANA'.

  SET TITLEBAR 'RESULT'.

  IF variants_to_display_cc IS NOT BOUND OR variants_to_display_t IS NOT BOUND.
    variants_to_display_cc = NEW cl_gui_custom_container(
      container_name          = 'RESULT'
      repid = sy-repid
      dynnr          = sy-dynnr
    ).

    cl_salv_table=>factory(
      EXPORTING
        r_container =  variants_to_display_cc
      IMPORTING
         r_salv_table = variants_to_display_t
      CHANGING
         t_table      = variants_to_display
         ).

    variants_to_display_t->get_functions( )->set_all( abap_true  ).

    variants_to_display_t->get_functions( )->remove_function( name = '&DETAIL' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&PRINT_BACK' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&FILTER' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&DELETE_FILTER' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&SORT_ASC' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&SORT_DSC' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&PRINT_BACK_PREVIEW' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&VGRID' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&VCRYSTAL' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&VEXCEL' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&VLOTUS' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&LOAD' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&SAVE' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&COL0' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&MAINTAIN' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&SUMC' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&MINIMUM' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&MAXIMUM' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&AVERAGE' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&COUNT' ).
    "result_table->get_functions( )->remove_function( name = '&XXL' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&PC' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&HTML' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&XINT' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&XML' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&ML' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&SEND' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&AQW' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&ABC' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&GRAPH' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&SUBTOT' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&AUF' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&FIND' ).
    variants_to_display_t->get_functions( )->remove_function( name = '&FIND_MORE' ).


    DATA(lo_client) = NEW cl_ptf_client( ).
    IF lo_client->am_i_in_main_homedevclient( ).
*    IF <mandt> = '815' AND <system> = 'ER9'.

      variants_to_display_t->get_functions( )->add_function(
      EXPORTING
        name     = 'ADD_TAG' "ABAP kann leider nicht string nach char konvertieren :-)
        text     = 'Add Tag(s)'
        tooltip  = 'Add Tag(s)'
        position = if_salv_c_function_position=>right_of_salv_functions                  " Positioning Function
      ).

      variants_to_display_t->get_functions( )->add_function(
      EXPORTING
        name     = 'REMOVE_TAG' "ABAP kann leider nicht string nach char konvertieren :-)
        text     = 'Remove Tag(s)'
        tooltip  = 'Remove Tag(s)'
        position = if_salv_c_function_position=>right_of_salv_functions
      ).

      SET HANDLER lcl_event_handler=>on_toolbar_click_main FOR variants_to_display_t->get_event( ).

    ENDIF.

    variants_to_display_t->get_selections( )->set_selection_mode(
      if_salv_c_selection_mode=>row_column
    ).

    variants_to_display_t->get_columns( )->set_optimize(
        value = abap_true
    ).

    variants_to_display_t->display( ).
  ELSE.
    variants_to_display_t->refresh( ).
    variants_to_display_t->display( ).
  ENDIF.

ENDMODULE.

MODULE pai_0001 INPUT.
  IF ok_code EQ 'BACK' OR ok_code EQ 'EXIT' OR ok_code EQ 'CANCEL'.
    LEAVE TO SCREEN 0.
  ENDIF.
ENDMODULE.

MODULE pbo_0002 OUTPUT.
  DATA: excluded_functions_tag_grid TYPE ui_functions,
        tags_layout                 TYPE lvc_s_layo,
        variants                    TYPE cl_ptf_variant_tag_manager=>variants,
        transformed_tags            TYPE cl_ptf_variant_tag_manager=>ptf_simple_tags.

  CLEAR excluded_functions_tag_grid.
  CLEAR tags_layout.
  CLEAR variants.
  CLEAR transformed_tags.

  CASE  ok_code.
    WHEN 'ENTER' OR 'SAVE'.

      LOOP AT variants_to_tag ASSIGNING FIELD-SYMBOL(<variant>).
        APPEND <variant> TO variants.
      ENDLOOP.

      LOOP AT tags ASSIGNING FIELD-SYMBOL(<tag>).
        APPEND <tag> TO transformed_tags.
      ENDLOOP.

      CASE mode.
        WHEN tag_mode-add.
          cl_ptf_variant_tag_manager=>add_tags_for_variants(
            EXPORTING
              variants = variants
              tags     = transformed_tags
          ).
          MESSAGE i055(ptf).
* Variant(s) successfully tagged.


        WHEN tag_mode-delete.
          cl_ptf_variant_tag_manager=>remove_tags_for_variants(
            EXPORTING
              variants = variants
              tags     = transformed_tags
          ).
          MESSAGE i056(ptf).
* Removed Tag(s) from variants.

      ENDCASE.

      LEAVE TO SCREEN 0.

    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE TO SCREEN 0.

    WHEN ''.

      IF variants_dc IS NOT BOUND OR variants_to_tag_t IS NOT BOUND.
        variants_dc = NEW cl_gui_docking_container(
          side = cl_gui_docking_container=>dock_at_top
        ).

*        variants_dc->set_height(
*          EXPORTING
*            height     =         300         " Current Height of Control
*        ).


        cl_salv_table=>factory(
          EXPORTING
            r_container =  variants_dc
          IMPORTING
             r_salv_table = variants_to_tag_t
          CHANGING
             t_table      = variants_to_tag
             ).

        variants_to_tag_t->get_functions( )->set_all( abap_false  ).

        variants_to_tag_t->get_selections( )->set_selection_mode(
          if_salv_c_selection_mode=>none
        ).

        variants_to_tag_t->get_columns( )->set_optimize(
            value = abap_true
        ).

        variants_to_tag_t->display( ).

      ELSE.
        variants_to_tag_t->refresh( ).
        variants_to_tag_t->display( ).
      ENDIF.

      IF tags_dc IS NOT BOUND OR tags_t IS NOT BOUND.
        tags_dc = NEW cl_gui_docking_container(
          side = cl_gui_docking_container=>dock_at_top
        ).

*        tags_dc->set_height(
*          EXPORTING
*            height     =         300         " Current Height of Control
*        ).

        cl_salv_table=>factory(
          EXPORTING
            r_container =  tags_dc
          IMPORTING
             r_salv_table = tags_t
          CHANGING
             t_table      = tags
             ).

        tags_t->get_functions( )->set_all( abap_true  ).

        tags_t->get_functions( )->remove_function( name = '&DETAIL' ).
        tags_t->get_functions( )->remove_function( name = '&PRINT_BACK' ).
        tags_t->get_functions( )->remove_function( name = '&FILTER' ).
        tags_t->get_functions( )->remove_function( name = '&DELETE_FILTER' ).
        tags_t->get_functions( )->remove_function( name = '&SORT_ASC' ).
        tags_t->get_functions( )->remove_function( name = '&SORT_DSC' ).
        tags_t->get_functions( )->remove_function( name = '&PRINT_BACK_PREVIEW' ).
        tags_t->get_functions( )->remove_function( name = '&VGRID' ).
        tags_t->get_functions( )->remove_function( name = '&VCRYSTAL' ).
        tags_t->get_functions( )->remove_function( name = '&VEXCEL' ).
        tags_t->get_functions( )->remove_function( name = '&VLOTUS' ).
        tags_t->get_functions( )->remove_function( name = '&LOAD' ).
        tags_t->get_functions( )->remove_function( name = '&SAVE' ).
        tags_t->get_functions( )->remove_function( name = '&COL0' ).
        tags_t->get_functions( )->remove_function( name = '&MAINTAIN' ).
        tags_t->get_functions( )->remove_function( name = '&SUMC' ).
        tags_t->get_functions( )->remove_function( name = '&MINIMUM' ).
        tags_t->get_functions( )->remove_function( name = '&MAXIMUM' ).
        tags_t->get_functions( )->remove_function( name = '&AVERAGE' ).
        tags_t->get_functions( )->remove_function( name = '&COUNT' ).
        tags_t->get_functions( )->remove_function( name = '&XXL' ).
        tags_t->get_functions( )->remove_function( name = '&PC' ).
        tags_t->get_functions( )->remove_function( name = '&HTML' ).
        tags_t->get_functions( )->remove_function( name = '&XINT' ).
        tags_t->get_functions( )->remove_function( name = '&XML' ).
        tags_t->get_functions( )->remove_function( name = '&ML' ).
        tags_t->get_functions( )->remove_function( name = '&SEND' ).
        tags_t->get_functions( )->remove_function( name = '&AQW' ).
        tags_t->get_functions( )->remove_function( name = '&ABC' ).
        tags_t->get_functions( )->remove_function( name = '&GRAPH' ).
        tags_t->get_functions( )->remove_function( name = '&SUBTOT' ).
        tags_t->get_functions( )->remove_function( name = '&AUF' ).
        tags_t->get_functions( )->remove_function( name = '&FIND' ).
        tags_t->get_functions( )->remove_function( name = '&FIND_MORE' ).


        tags_t->get_functions( )->add_function(
          EXPORTING
            name     = 'ADD_ROW' "ABAP kann leider nicht string nach char konvertieren :-)
            text     = ''
            icon = '@17@'
            tooltip  = 'Add row'
            position = if_salv_c_function_position=>right_of_salv_functions                  " Positioning Function
        ).

        tags_t->get_functions( )->add_function(
         EXPORTING
           name     = 'DELETE_ROW' "ABAP kann leider nicht string nach char konvertieren :-)
           text     = ''
           icon     = '@18@'
           tooltip  = 'Delete row'
           position = if_salv_c_function_position=>right_of_salv_functions
         ).

        SET HANDLER lcl_event_handler=>on_toolbar_click_sub FOR tags_t->get_event( ).

        tags_t->get_selections( )->set_selection_mode(
          if_salv_c_selection_mode=>multiple
        ).

        tags_t->get_columns( )->set_optimize(
            value = abap_true
        ).

        tags_t->display( ).
      ELSE.
        tags_t->refresh( ).
        tags_t->display( ).
      ENDIF.

    WHEN OTHERS.

  ENDCASE.

ENDMODULE.

MODULE pai_0002 INPUT.
  IF ok_code EQ 'BACK' OR ok_code EQ 'EXIT' OR ok_code EQ 'CANCEL'.
    SET TITLEBAR 'RESULT'.
    LEAVE TO SCREEN 0.
    CLEAR tags.
    CLEAR tags_dc.
    CLEAR tags_t.
  ENDIF.
ENDMODULE.
