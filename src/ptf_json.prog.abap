*&---------------------------------------------------------------------*
*& Class          lcl_event_receiver_editor
*&---------------------------------------------------------------------*
CLASS lcl_event_receiver_editor DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS: handler_dblclick
      FOR EVENT dblclick OF cl_gui_textedit
      IMPORTING sender.
ENDCLASS.

CLASS lcl_event_receiver_editor IMPLEMENTATION.
*-----------------------------------------------------------------------
* METHOD  handler_dblclick
*-----------------------------------------------------------------------
  METHOD handler_dblclick.
    DATA: lv_position   TYPE i,
          lv_from_index TYPE i,
          lv_to_index   TYPE i.

*   get the text
    sender->get_textstream( IMPORTING text = gv_json_file ).
    cl_gui_cfw=>flush( ). "needed

*   Replace cr_lf with newline otherwise text select gets messed up because PCRE doesn't parse well cr_lf
    gv_json_file = replace( val = gv_json_file sub = cl_abap_char_utilities=>cr_lf with = cl_abap_char_utilities=>newline occ = 0 ).

*   get position of the the double click
    CALL METHOD sender->get_selection_indexes
      IMPORTING
        from_index = lv_position.

*   find the starting position
    lv_from_index = find( val = gv_json_file+0(lv_position) pcre = '(")(?![\s\S]*\1)' ) + 1.
    lv_to_index = lv_position + find( val = gv_json_file+lv_position pcre = '("*)"' occ = 1 ). "(["]*)

*   set position of the the double click
    CALL METHOD sender->set_selection_indexes
      EXPORTING
        from_index = lv_from_index
        to_index   = lv_to_index.

  ENDMETHOD.                    "handler_dblclick

ENDCLASS.

CLASS lcl_toolbar_handler DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS: on_function_selected
             FOR EVENT function_selected OF cl_gui_toolbar
             IMPORTING fcode.
ENDCLASS.

CLASS lcl_toolbar_handler IMPLEMENTATION.
  METHOD on_function_selected.
    FIELD-SYMBOLS: <fs_outtab_step> TYPE cl_ptf_util=>ty_outtab.

    CASE fcode.
      WHEN 'LOAD_REPO' OR 'SAVE_REPO'.
        READ TABLE gt_outtab_step ASSIGNING <fs_outtab_step> INDEX gv_row_number-row_id.
        IF sy-subrc = 0.
*         Set the value of the toolbar button that has been clicked
          gv_toolbar_button = fcode.

*         Reset screen fields in case of load repository
          IF fcode = 'LOAD_REPO'.
*            CLEAR: p_jsid, p_jsdscr, p_bo, p_act. "Clear input fields
            CLEAR: p_jsid, p_jsdscr.

          ENDIF.

          CALL SCREEN 8003 STARTING AT 60 10.

          cl_gui_cfw=>set_new_ok_code( '/00' ). "reload PBO to refresh subscreen with INPUT ID, BO etc.
*          cl_gui_cfw=>flush( ). "needed

        ENDIF.

      WHEN 'SEARCH_REPO'.
        READ TABLE gt_outtab_step ASSIGNING <fs_outtab_step> INDEX gv_row_number-row_id.
        IF sy-subrc = 0.
          DATA lt_shlp         TYPE shlp_descr.
          DATA lt_return_value TYPE STANDARD TABLE OF ddshretval.

          CALL FUNCTION 'F4IF_GET_SHLP_DESCR'
            EXPORTING
              shlpname = 'SHPTF_INPUT_REPO'
            IMPORTING
              shlp     = lt_shlp.

          LOOP AT lt_shlp-interface ASSIGNING FIELD-SYMBOL(<fs_shlp_inface>).
            CASE <fs_shlp_inface>-shlpfield.
              WHEN 'INPUT_ID'.
*                <fs_shlp_inface>-value    = lt_dynpfields[ fieldname = 'P_JSID' ]-fieldvalue. "Don't pass value from screen
                <fs_shlp_inface>-valfield = 'X'.
              WHEN 'BUS_OBJ'.
                <fs_shlp_inface>-value    = p_bo.
                <fs_shlp_inface>-valfield = 'X'.

              WHEN 'ACTION'.
                <fs_shlp_inface>-value    = p_act.
                <fs_shlp_inface>-valfield = 'X'.

              WHEN 'DESCR'.
                <fs_shlp_inface>-valfield = 'X'.

            ENDCASE.

          ENDLOOP.

          CALL FUNCTION 'F4IF_START_VALUE_REQUEST'
            EXPORTING
              shlp          = lt_shlp
            TABLES
              return_values = lt_return_value.

          IF line_exists( lt_return_value[ fieldname = 'INPUT_ID' ] ).
            p_jsid = lt_return_value[ fieldname = 'INPUT_ID' ]-fieldval.

          ENDIF.

          IF line_exists( lt_return_value[ fieldname = 'BUS_OBJ' ] ).
            p_bo = lt_return_value[ fieldname = 'BUS_OBJ' ]-fieldval.

          ENDIF.

          IF line_exists( lt_return_value[ fieldname = 'ACTION' ] ).
            p_act = lt_return_value[ fieldname = 'ACTION' ]-fieldval.

          ENDIF.

          IF line_exists( lt_return_value[ fieldname = 'DESCR' ] ).
            p_jsdscr = lt_return_value[ fieldname = 'DESCR' ]-fieldval.

          ENDIF.

          DATA(lo_json_repository) = NEW cl_ptf_json_repository( ).

          TRY.
            DATA(ls_ptf_input_repo) = lo_json_repository->load( p_jsid ).

          CATCH cx_ptf_json_repository INTO DATA(lx_json_repository).
            MESSAGE s208(00) WITH lx_json_repository->get_text( ) DISPLAY LIKE 'E'.
            RETURN.

          ENDTRY.

*         Set back the new file
          gv_json_file = ls_ptf_input_repo-input_string.
          g_editor->set_textstream( gv_json_file ).

          gv_rep_input_source = 'FIELD'.

          MESSAGE s083(ptf).

          cl_gui_cfw=>set_new_ok_code( '/00' ). "reload PBO to refresh subscreen with INPUT ID, BO etc.

        ENDIF.

      WHEN 'DEL_REPO'.
        PERFORM delete_json_repository.

      WHEN 'COPY_LOCAL'.
        READ TABLE gt_outtab_step ASSIGNING <fs_outtab_step> INDEX gv_row_number-row_id.
        IF sy-subrc = 0.
          gv_rep_input_source = 'LOCAL'.

          MESSAGE s084(ptf).

          cl_gui_cfw=>set_new_ok_code( '/00' ). "reload PBO to refresh subscreen with INPUT ID, BO etc.

        ENDIF.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.

*&---------------------------------------------------------------------*
*& Include          PTF_JSON
*&---------------------------------------------------------------------*
MODULE pbo_8001 OUTPUT.
  PERFORM pbo_8001.

ENDMODULE.

MODULE pai_8001 INPUT.
  PERFORM pai_8001.

ENDMODULE.

FORM pbo_8001.
  DATA lt_fcode_excl      TYPE STANDARD TABLE OF syst-ucomm.
  DATA lv_step_id         TYPE c LENGTH 2.
  DATA lv_string          TYPE string.
  DATA lv_json_repository TYPE abap_bool.

  DATA lt_toolbar_events TYPE cntl_simple_events.

  FIELD-SYMBOLS: <fs_outtab_step> TYPE cl_ptf_util=>ty_outtab.

  READ TABLE gt_outtab_step ASSIGNING <fs_outtab_step> INDEX gv_row_number-row_id.
  IF sy-subrc = 0.
    IF gv_json_file IS NOT INITIAL.
      CASE <fs_outtab_step>-action.
        WHEN 'CREATE' OR 'CHANGE' OR 'CHECK'.
*         Set text for 3rd JSON buttons
          gs_json_w_mkf-text  = 'Template: Mandatory and Key Fields'.
          gs_json_w_af-text   = 'Template: All Fields'.

          lt_fcode_excl = VALUE #( ( 'JSON_W_KF' ) ).

        WHEN 'RETRIEVE_ALL' OR 'CHECK_IF_EXISTS'.
          gs_json_w_mkf-text  = 'Template: Root Key Fields'.
          gs_json_w_kf-text   = 'Template: Key Fields'.
          gs_json_w_af-text   = 'Template: All Fields'.

          lt_fcode_excl = VALUE #( ( 'JSON_WO_F' ) ).

        WHEN OTHERS.
*         Set text for 3rd JSON buttons
          gs_json_w_af-text = 'Get JSON Template'.

**         Exclude Get JSON Template button if RAP BO and action are not valid
*          DATA(lo_ptf_rap_metadata) = NEW cl_ptf_rap_metadata( ).
*          DATA(lv_is_rap_bo_action) = lo_ptf_rap_metadata->check_rap_bo_action(
*                iv_bus_obj          = <fs_outtab_step>-bus_obj
*                iv_action           = <fs_outtab_step>-action
*          ).
*
*          IF lv_is_rap_bo_action = abap_on.
*            lt_fcode_excl = VALUE #( ( 'JSON_WO_F' ) ( 'JSON_W_MKF' ) ( 'JSON_W_KF' ) ).
*
*          ELSE.
*            lt_fcode_excl = VALUE #( ( 'JSON_WO_F' ) ( 'JSON_W_MKF' ) ( 'JSON_W_AF' ) ( 'JSON_W_KF' ) ).
*
*          ENDIF.

          lt_fcode_excl = VALUE #( ( 'JSON_WO_F' ) ( 'JSON_W_MKF' ) ( 'JSON_W_KF' ) ).

      ENDCASE.

    ENDIF.

    IF gv_retrieved_data IS NOT INITIAL.
      lt_fcode_excl = VALUE #( ( 'CONTI' ) ( 'PRETTY_PRI' ) ( 'CLEAR' ) ( 'JSON_WO_F' ) ( 'JSON_W_MKF' ) ( 'JSON_W_AF' ) ( 'JSON_W_KF' ) ).

    ENDIF.

    lv_step_id = gv_row_number-row_id.

*   JSON is editable
    IF gv_json_file IS NOT INITIAL.
      lv_string = <fs_outtab_step>-bus_obj && '-' && <fs_outtab_step>-action.
      SET TITLEBAR 'JSON_EDITOR' WITH lv_step_id lv_string.

    ENDIF.

*   JSON is retrieved
    IF gv_retrieved_data IS NOT INITIAL.
      DATA(lv_instances) = cl_ptf_json=>count_instances( iv_json = gv_retrieved_data ).
      lv_string = lv_instances.
      SET TITLEBAR 'JSON_RETRIEVE' WITH lv_step_id lv_string.

    ENDIF.

  ENDIF.

  SET PF-STATUS 'JSON_STATUS' EXCLUDING lt_fcode_excl.

  IF NOT g_editor_container IS BOUND.
*   create control container
    CREATE OBJECT g_editor_container
      EXPORTING
        container_name              = 'EDITOR'
      EXCEPTIONS
        OTHERS                      = 1 ##SUBRC_OK.

    IF NOT g_editor IS BOUND.
*     Create a TextEdit Control
      CREATE OBJECT g_editor
        EXPORTING
          parent                     = g_editor_container
          wordwrap_mode              = cl_gui_textedit=>wordwrap_at_windowborder "cl_gui_textedit=>wordwrap_at_fixed_position "
          "wordwrap_position          = 170
          wordwrap_to_linebreak_mode = cl_gui_textedit=>false
        EXCEPTIONS
          OTHERS                     = 1 ##SUBRC_OK.

    ENDIF.

    CREATE OBJECT go_editor_event_receiver.

*   register editor1 for event dblclick
    CALL METHOD g_editor->register_event_dblclick
      EXPORTING
        appl_event = 'X'.

    SET HANDLER go_editor_event_receiver->handler_dblclick FOR g_editor.

  ENDIF.

  IF gv_json_file IS NOT INITIAL.
    CALL METHOD g_editor->set_readonly_mode( 0 ).

    READ TABLE gt_outtab_step ASSIGNING <fs_outtab_step> INDEX gv_row_number-row_id.
    IF sy-subrc = 0.
      IF gv_json_editor_open = abap_off. "First PBO after pop-up is opened
*       We need json_editor_open because g_editor needs first to be bound and then set the textstream
*       Also double click event retriggers the PBO and without the flag the text selection wouldn't work
*       Other actions with the same effect: Pretty Printer, Clear
        gv_json_editor_open = abap_on.

        g_editor->set_textstream( gv_json_file ). "<fs_outtab_step>-json_file

      ENDIF.

    ENDIF.

  ENDIF.

  IF gv_retrieved_data IS NOT INITIAL.
    CALL METHOD g_editor->set_readonly_mode( 1 ).

    g_editor->set_textstream( gv_retrieved_data ). "<fs_outtab_step>-json_file

  ENDIF.

  DATA(lo_json_repository) = NEW cl_ptf_json_repository( ).

  CASE gv_rep_input_source.
    WHEN 'ALV'.
      lv_json_repository = lo_json_repository->check( <fs_outtab_step>-variant ).

    WHEN 'FIELD'.
      lv_json_repository = lo_json_repository->check( CONV #( p_jsid ) ).

  ENDCASE.

  DATA lv_eligible TYPE abap_bool.
  PERFORM check_user CHANGING lv_eligible.

  IF go_json_toolbar IS NOT BOUND.
    go_json_buttons_container = NEW #( container_name = 'BUTTONS' ).
    go_json_toolbar = NEW #( parent = go_json_buttons_container display_mode = cl_gui_toolbar=>m_mode_vertical ).

    IF lv_eligible = abap_on.
      go_json_toolbar->add_button(
        EXPORTING
          fcode       = 'LOAD_REPO'
          icon        = icon_cloud_download
          is_disabled = COND #( WHEN gv_retrieved_data IS NOT INITIAL THEN abap_on ELSE abap_off ) "Disable if JSON is from RETRIEVE/RETRIEVE_ALL
          butn_type   = cntb_btype_button
          text        = 'Load from Repository by ID'
      ).

      go_json_toolbar->add_button(
        EXPORTING
          fcode       = 'SEARCH_REPO'
          icon        = icon_search
          is_disabled = COND #( WHEN gv_retrieved_data IS NOT INITIAL THEN abap_on ELSE abap_off ) "Disable if JSON is from RETRIEVE/RETRIEVE_ALL
          butn_type   = cntb_btype_button
          text        = 'Search in Repository'
      ).

      go_json_toolbar->add_button(
        EXPORTING
          fcode       = 'SAVE_REPO'
          icon        = icon_system_save
          is_disabled = COND #( WHEN gv_retrieved_data IS NOT INITIAL THEN abap_on ELSE abap_off ) "Disable if JSON is from RETRIEVE/RETRIEVE_ALL
          butn_type   = cntb_btype_button
          text        = 'Save into Repository'
      ).

      go_json_toolbar->add_button(
        EXPORTING
          fcode       = 'DEL_REPO'
          icon        = icon_delete
          is_disabled = SWITCH #( lv_json_repository WHEN abap_on THEN abap_off ELSE abap_on )
          butn_type   = cntb_btype_button
          text        = 'Delete from Repository'
      ).

      go_json_toolbar->add_button(
        EXPORTING
          fcode       = 'COPY_LOCAL'
          icon        = icon_copy_object
          is_disabled = COND #( WHEN gv_rep_input_source = 'LOCAL' THEN abap_on
                                WHEN ( gv_rep_input_source = 'FIELD' OR gv_rep_input_source = 'ALV' ) AND lv_json_repository = abap_off THEN abap_on
                                ELSE abap_off )
          butn_type   = cntb_btype_button
          text        = 'Copy to local JSON'
      ).

    ENDIF.

*   Register events
    lt_toolbar_events = VALUE #( ( eventid = cl_gui_toolbar=>m_id_function_selected ) ).

    go_json_toolbar->set_registered_events( lt_toolbar_events ).

    DATA(lo_toolbar_handler) = NEW lcl_toolbar_handler( ).
    SET HANDLER lo_toolbar_handler->on_function_selected FOR go_json_toolbar.

  ELSE.
    IF lv_eligible = abap_on.
      go_json_toolbar->set_button_state(
        EXPORTING
          enabled     = COND #( WHEN gv_retrieved_data IS NOT INITIAL THEN abap_off ELSE abap_on ) "Disable if JSON is from RETRIEVE/RETRIEVE_ALL
          fcode       = 'LOAD_REPO'
      ).

      go_json_toolbar->set_button_state(
        EXPORTING
          enabled     = COND #( WHEN gv_retrieved_data IS NOT INITIAL THEN abap_off ELSE abap_on ) "Disable if JSON is from RETRIEVE/RETRIEVE_ALL
          fcode       = 'SEARCH_REPO'
      ).

      go_json_toolbar->set_button_state(
        EXPORTING
          enabled     = COND #( WHEN gv_retrieved_data IS NOT INITIAL THEN abap_off ELSE abap_on ) "Disable if JSON is from RETRIEVE/RETRIEVE_ALL
          fcode       = 'SAVE_REPO'
      ).

      go_json_toolbar->set_button_state(
        EXPORTING
          enabled     = lv_json_repository
          fcode       = 'DEL_REPO'
      ).

      go_json_toolbar->set_button_state(
        EXPORTING
          enabled     = COND #( WHEN gv_rep_input_source = 'LOCAL' THEN abap_off
                                WHEN ( gv_rep_input_source = 'FIELD' OR gv_rep_input_source = 'ALV' ) AND lv_json_repository = abap_off THEN abap_off
                                ELSE abap_on )
          fcode       = 'COPY_LOCAL'
      ).

    ENDIF.

  ENDIF.

ENDFORM.

FORM pai_8001.
  FIELD-SYMBOLS: <fs_outtab_step>  TYPE cl_ptf_util=>ty_outtab,
                 <fs_handle_style> TYPE lvc_s_styl.

  CASE more_ok.
    WHEN 'CANC'.
      READ TABLE gt_outtab_step ASSIGNING <fs_outtab_step> INDEX gv_row_number-row_id.
      IF sy-subrc = 0.
        gv_json_editor_open = abap_off.
        PERFORM reset_repository_load.

      ENDIF.

      LEAVE TO SCREEN 0.

    WHEN 'CONTI'.
      READ TABLE gt_outtab_step ASSIGNING <fs_outtab_step> INDEX gv_row_number-row_id.
      IF sy-subrc = 0.
        g_editor->get_textstream( IMPORTING text = gv_json_file ). "<fs_outtab_step>-json_file
        cl_gui_cfw=>flush( ). "needed

*       Check if JSON is local or not
        IF gv_rep_input_source <> 'LOCAL'.
*         Check if JSON in editor is changed
          DATA(lo_json_repository) = NEW cl_ptf_json_repository( ).

          TRY.
            DATA(ls_ptf_input_repo) = lo_json_repository->load( p_jsid ).

            IF ls_ptf_input_repo-input_string <> gv_json_file. "JSON was changed in the editor
              CALL FUNCTION 'POPUP_TO_INFORM'
                EXPORTING
                  titel         = 'JSON in editor was changed'
                  txt1          = CONV sta_text( 'You have manually edited the JSON originated from JSON Repository' )
                  txt2          = CONV sta_text( 'Please save JSON string in JSON Repository or copy to local or cancel' ).

               RETURN.

            ENDIF.

          CATCH cx_ptf_json_repository ##NO_HANDLER.
          ENDTRY.

        ENDIF.

*       Set Variant with the new value
        <fs_outtab_step>-variant   = p_jsid.

        gv_json_editor_open = abap_off.

*       If JSON is local then save it at step level
        IF gv_rep_input_source = 'LOCAL'.
          <fs_outtab_step>-json_file = gv_json_file.

*       Otherwise clear the value at step level
        ELSE.
          CLEAR <fs_outtab_step>-json_file.

        ENDIF.

        IF NOT <fs_outtab_step>-json_file IS INITIAL     AND  NOT ( <fs_outtab_step>-bus_obj EQ 'MATDOC' AND <fs_outtab_step>-action EQ 'CHECK' ).
          "Clear TDCV and TDC from ALV
          CLEAR: <fs_outtab_step>-variant, <fs_outtab_step>-test_data_container.

          <fs_outtab_step>-json_file_more = icon_text_act.

        ELSE.
          <fs_outtab_step>-json_file_more = icon_text_ina.

        ENDIF.

        LOOP AT <fs_outtab_step>-handle_style ASSIGNING <fs_handle_style>.
          CASE <fs_handle_style>-fieldname.
            WHEN 'VARIANT' OR 'TEST_DATA_CONTAINER'. "Disable if JSON is local
              IF NOT <fs_outtab_step>-json_file IS INITIAL      AND  NOT ( <fs_outtab_step>-bus_obj EQ 'MATDOC' AND <fs_outtab_step>-action EQ 'CHECK' ).
                <fs_handle_style>-style = cl_gui_alv_grid=>mc_style_disabled.

              ELSE.
                <fs_handle_style>-style = cl_gui_alv_grid=>mc_style_enabled.

              ENDIF.

          ENDCASE.

        ENDLOOP.

*       Validate JSON
        IF gv_json_file IS NOT INITIAL.
*         Cleanup JSON
          cl_ptf_json=>cleanup_json( CHANGING cv_json = gv_json_file ).

          TRY.
              cl_ptf_json=>validate_json( EXPORTING iv_json = gv_json_file ).

              MESSAGE s072(ptf).

            CATCH cx_ptf_json INTO DATA(lx_ptf_json).
              MESSAGE s073(ptf) WITH lx_ptf_json->get_text( ) lx_ptf_json->offset DISPLAY LIKE 'E'.

          ENDTRY.

        ENDIF.

      ENDIF.

      IF g_grid_step IS NOT INITIAL.
        g_grid_step->refresh_table_display( ).

      ENDIF.

      LEAVE TO SCREEN 0.

    WHEN 'PRETTY_PRI'.
      READ TABLE gt_outtab_step ASSIGNING <fs_outtab_step> INDEX gv_row_number-row_id.
      IF sy-subrc = 0.
        g_editor->get_textstream( IMPORTING text = gv_json_file ). "<fs_outtab_step>-json_file
        cl_gui_cfw=>flush( ). "needed

        cl_ptf_json=>pretty_printer( EXPORTING iv_entity = <fs_outtab_step>-bus_obj CHANGING cv_json = gv_json_file ).

        g_editor->set_textstream( gv_json_file ). "<fs_outtab_step>-json_file

      ENDIF.

    WHEN 'CLEAR'.
      g_editor->delete_text( ).

    WHEN 'JSON_WO_F'. "JSON Without fields
      READ TABLE gt_outtab_step ASSIGNING <fs_outtab_step> INDEX gv_row_number-row_id.
      IF sy-subrc = 0.
        gv_json_file = cl_ptf_json=>generate_sample_json( "<fs_outtab_step>-json_file
                                         EXPORTING
                                           iv_ptf_bo   = <fs_outtab_step>-bus_obj
                                           iv_ptf_act  = <fs_outtab_step>-action
                                           iv_ptf_json_opt = '1' ).
        g_editor->set_textstream( gv_json_file ). "<fs_outtab_step>-json_file

      ENDIF.

    WHEN 'JSON_W_MKF'. "JSON With Mandatory + Key Fields
      READ TABLE gt_outtab_step ASSIGNING <fs_outtab_step> INDEX gv_row_number-row_id.
      IF sy-subrc = 0.
        gv_json_file = cl_ptf_json=>generate_sample_json( "<fs_outtab_step>-json_file
                                         EXPORTING
                                           iv_ptf_bo   = <fs_outtab_step>-bus_obj
                                           iv_ptf_act  = <fs_outtab_step>-action
                                           iv_ptf_json_opt = '2' ).

        g_editor->set_textstream( gv_json_file ). "<fs_outtab_step>-json_file

      ENDIF.

    WHEN 'JSON_W_AF'. "JSON With All Fields / Get JSON Template
      READ TABLE gt_outtab_step ASSIGNING <fs_outtab_step> INDEX gv_row_number-row_id.
      IF sy-subrc = 0.
*       Stop execution if RAP BO and action are not valid
        DATA(lo_ptf_rap_metadata) = NEW cl_ptf_rap_metadata( ).
        DATA(lv_is_rap_bo_action) = lo_ptf_rap_metadata->check_rap_bo_action(
              iv_bus_obj          = <fs_outtab_step>-bus_obj
              iv_action           = <fs_outtab_step>-action
        ).
        IF lv_is_rap_bo_action = abap_off.
          MESSAGE ID 'PTF' TYPE 'S' NUMBER 086 DISPLAY LIKE 'E' WITH <fs_outtab_step>-action.
          RETURN.

        ENDIF.

        gv_json_file = cl_ptf_json=>generate_sample_json( "<fs_outtab_step>-json_file
                                         EXPORTING
                                           iv_ptf_bo   = <fs_outtab_step>-bus_obj
                                           iv_ptf_act  = <fs_outtab_step>-action
                                           iv_ptf_json_opt = '3' ).

        g_editor->set_textstream( gv_json_file ). "<fs_outtab_step>-json_file

      ENDIF.

    WHEN 'JSON_W_KF'. "JSON with Key Fields
      READ TABLE gt_outtab_step ASSIGNING <fs_outtab_step> INDEX gv_row_number-row_id.
      IF sy-subrc = 0.
        gv_json_file = cl_ptf_json=>generate_sample_json( "<fs_outtab_step>-json_file
                                         EXPORTING
                                           iv_ptf_bo   = <fs_outtab_step>-bus_obj
                                           iv_ptf_act  = <fs_outtab_step>-action
                                           iv_ptf_json_opt = '4' ).

        g_editor->set_textstream( gv_json_file ). "<fs_outtab_step>-json_file

      ENDIF.


  ENDCASE.

ENDFORM.

FORM check_user CHANGING cv_eligible TYPE abap_bool.
  DATA lt_user_parameters TYPE ustyp_t_parameters.

  CALL FUNCTION 'SUSR_USER_PARAMETERS_GET'
    EXPORTING
      user_name           = sy-uname
*     WITH_TEXT           =
    TABLES
      user_parameters     = lt_user_parameters
    EXCEPTIONS
      user_name_not_exist = 1
      OTHERS              = 2.
  IF sy-subrc = 0.
    IF line_exists( lt_user_parameters[ parid = 'PTF_ENABLE_RAP' parva = CONV #( abap_on ) ] ).
      cv_eligible = abap_on.

    ENDIF.

  ENDIF.

ENDFORM.

FORM generate_data_8002 USING uv_source TYPE char10.
  DATA lv_json_repository TYPE abap_bool.

  IF gv_repository_loaded = abap_off. "Repository not yet initialized
    c_jsid    = 'JSON ID'.
    c_jsdscr  = 'JSON Description'.
    c_bo      = 'BO'.
    c_act     = 'OPERATION'.

    IF gv_retrieved_data IS INITIAL. "Editor is not displaying data from RETRIEVE/RETRIVE_ALL
      READ TABLE gt_outtab_step ASSIGNING FIELD-SYMBOL(<fs_outtab_step>) INDEX gv_row_number-row_id.
      IF sy-subrc = 0.
        DATA(lo_json_repository) = NEW cl_ptf_json_repository( ).

        CASE uv_source.
          WHEN 'ALV'.
            lv_json_repository = lo_json_repository->check( <fs_outtab_step>-variant ).
            p_jsid  = <fs_outtab_step>-variant.

          WHEN 'FIELD'.
            lv_json_repository = lo_json_repository->check( CONV #( p_jsid ) ).

        ENDCASE.

        IF lv_json_repository = abap_on. "Load from repository
          TRY.
            gs_ptf_input_repo = lo_json_repository->load( p_jsid ). "Store data in global object

          CATCH cx_ptf_json_repository ##NO_HANDLER.
          ENDTRY.

          p_jsdscr = gs_ptf_input_repo-descr.

          p_bo    = gs_ptf_input_repo-bus_obj.
          p_act   = gs_ptf_input_repo-action.

        ELSE.
          CLEAR gs_ptf_input_repo.
          CLEAR: p_jsid, p_jsdscr.

          p_bo    = <fs_outtab_step>-bus_obj.
          p_act   = <fs_outtab_step>-action.

*         Store data in global object
          gs_ptf_input_repo-input_id = <fs_outtab_step>-variant.
          gs_ptf_input_repo-bus_obj  = <fs_outtab_step>-bus_obj.
          gs_ptf_input_repo-action   = <fs_outtab_step>-action.

        ENDIF.

      ENDIF.

      gv_repository_loaded = abap_on.

    ELSE.
      CLEAR: p_jsid, p_jsdscr, p_bo, p_act. "Clear input fields

    ENDIF.

  ENDIF.

ENDFORM.

FORM screen_output_8002.
  LOOP AT screen.
    CASE screen-group1.
      WHEN 'LOD'.
        CASE gv_toolbar_button.
          WHEN 'LOAD_REPO' OR 'SAVE_REPO'.
            screen-input = 1.
            screen-value_help = 1.

          WHEN OTHERS.
            screen-input = 0.
            screen-value_help = 0.

        ENDCASE.

      WHEN 'SAV'.
        CASE gv_toolbar_button.
          WHEN 'SAVE_REPO'.
            screen-input = 1.
            screen-value_help = 1.

          WHEN OTHERS.
            screen-input = 0.
            screen-value_help = 0.

        ENDCASE.

    ENDCASE.

    MODIFY SCREEN.

  ENDLOOP.

ENDFORM.

FORM reset_repository_load.
  CLEAR: gs_ptf_input_repo.
  gv_repository_loaded = abap_off.

ENDFORM.
