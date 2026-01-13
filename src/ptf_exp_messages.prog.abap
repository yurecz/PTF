*&---------------------------------------------------------------------*
*& Include          PTF_EXP_MESSAGES
*&---------------------------------------------------------------------*
CLASS lcl_event_receiver_exp_msg DEFINITION FINAL.
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

CLASS lcl_event_receiver_exp_msg IMPLEMENTATION.
  METHOD on_button_click.
*   handles insertion/deletion of lines in the popup for ReferenceSteps
    DATA: lv_row_number     TYPE i,
          ls_outtab_exp_msg TYPE ty_outtab_exp_msg.

    lv_row_number = 0.

    g_grid_exp_msg->get_selected_rows(
      IMPORTING
        et_row_no     =  DATA(lt_row_no) ).

    READ TABLE lt_row_no INTO DATA(ls_row_no) INDEX 1.
    lv_row_number = ls_row_no-row_id.

    CASE e_ucomm.
      WHEN 'DELETE_ROW'.
        IF lt_row_no IS NOT INITIAL.
          SORT lt_row_no BY row_id DESCENDING.

          LOOP AT lt_row_no ASSIGNING FIELD-SYMBOL(<fs_row_no>).
            DELETE gt_outtab_exp_msg INDEX <fs_row_no>-row_id.

          ENDLOOP.

        ENDIF.

      WHEN 'INSERT_ROW'.
        IF lv_row_number IS INITIAL.
          lv_row_number = 1.

        ENDIF.

        ls_outtab_exp_msg-opt            = 'CONTAIN'.
        ls_outtab_exp_msg-operator       = 'AND'.

        ls_outtab_exp_msg-handle_style   = VALUE #( ( fieldname = 'OPERATOR' style = cl_gui_alv_grid=>mc_style_disabled style2 = cl_gui_alv_grid=>mc_style_disabled ) ).

        INSERT ls_outtab_exp_msg INTO gt_outtab_exp_msg INDEX lv_row_number.

      WHEN 'APPEND_ROW'.
        LOOP AT gt_outtab_exp_msg ASSIGNING FIELD-SYMBOL(<fs_outtab_exp_msg>).
          IF <fs_outtab_exp_msg>-operator IS INITIAL.
            <fs_outtab_exp_msg>-operator       = 'AND'.

          ENDIF.

        ENDLOOP.

        ls_outtab_exp_msg-opt            = 'CONTAIN'.

        ls_outtab_exp_msg-handle_style   = VALUE #( ( fieldname = 'OPERATOR' style = cl_gui_alv_grid=>mc_style_disabled style2 = cl_gui_alv_grid=>mc_style_disabled ) ).

        APPEND ls_outtab_exp_msg TO gt_outtab_exp_msg.

    ENDCASE.

    PERFORM refresh_exp_msg.

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
    DATA: ls_t100  TYPE t100        ##NEEDED,
          lv_msgid TYPE syst_msgid,
          lv_msgty TYPE syst_msgty.
          "lv_msgno TYPE syst_msgno.

    FIELD-SYMBOLS: <fs_outtab_exp_msg> TYPE ty_outtab_exp_msg.

**   Skip row insertion
*    IF e_ucomm = 'INSERT_ROW'.
*      RETURN.
*
*    ENDIF.

*   Skip row deletion
    IF e_ucomm = 'DELETE_ROW'.
      g_grid_exp_msg->get_selected_rows(
        IMPORTING
          et_row_no     =  DATA(lt_row_no) ).

      READ TABLE lt_row_no ASSIGNING FIELD-SYMBOL(<fs_row_no>) INDEX 1.
      IF sy-subrc = 0.
        DELETE er_data_changed->mt_mod_cells WHERE row_id = <fs_row_no>-row_id.

      ENDIF.

      RETURN.

    ENDIF.

    LOOP AT er_data_changed->mt_mod_cells ASSIGNING FIELD-SYMBOL(<fs_mod_cells>).
      CASE <fs_mod_cells>-fieldname.
        WHEN 'OPT'.
          IF <fs_mod_cells>-value IS INITIAL.
            er_data_changed->add_protocol_entry(
              EXPORTING
                i_msgid     = 'PTF'
                i_msgno     = '070'
                i_msgty     = 'E'
                i_msgv1     = 'Message Option is mandatory'
                i_fieldname = <fs_mod_cells>-fieldname
                i_row_id    = <fs_mod_cells>-row_id ).

          ENDIF.

        WHEN 'MSGID'.
          IF <fs_mod_cells>-value IS INITIAL. "Check if message id is valid
            CLEAR lv_msgty.

            IF line_exists( er_data_changed->mt_mod_cells[ row_id = <fs_mod_cells>-row_id fieldname = 'MSGTY' ] ).
              lv_msgty = er_data_changed->mt_mod_cells[ row_id = <fs_mod_cells>-row_id fieldname = 'MSGTY' ]-value.

            ENDIF.

            IF lv_msgty IS INITIAL
              AND gt_outtab_exp_msg[ <fs_mod_cells>-row_id ]-msgty IS INITIAL.
              er_data_changed->add_protocol_entry(
                EXPORTING
                  i_msgid     = 'PTF'
                  i_msgno     = '070'
                  i_msgty     = 'E'
                  i_msgv1     = 'Please fill message ID or message type'
                  i_fieldname = <fs_mod_cells>-fieldname
                  i_row_id    = <fs_mod_cells>-row_id ).

            ENDIF.

          ELSE.
            lv_msgid = to_upper( <fs_mod_cells>-value ).

            SELECT SINGLE t100~arbgb
              INTO CORRESPONDING FIELDS OF ls_t100
              FROM t100
             WHERE t100~arbgb = lv_msgid ##WARN_OK.
            IF sy-subrc <> 0.
              er_data_changed->add_protocol_entry(
                EXPORTING
                  i_msgid     = 'PTF'
                  i_msgno     = '070'
                  i_msgty     = 'E'
                  i_msgv1     = 'Message ID is invalid'
                  i_fieldname = <fs_mod_cells>-fieldname
                  i_row_id    = <fs_mod_cells>-row_id ).

            ENDIF.

          ENDIF.

        WHEN 'MSGTY'. "Check if message ID is filled  "validity is checked elsewhere
          IF <fs_mod_cells>-value IS INITIAL.
            CLEAR lv_msgid.

            IF line_exists( er_data_changed->mt_mod_cells[ row_id = <fs_mod_cells>-row_id fieldname = 'MSGID' ] ).
              lv_msgid = er_data_changed->mt_mod_cells[ row_id = <fs_mod_cells>-row_id fieldname = 'MSGID' ]-value.

            ENDIF.

            IF lv_msgid IS INITIAL
              AND gt_outtab_exp_msg[ <fs_mod_cells>-row_id ]-msgid IS INITIAL.
              er_data_changed->add_protocol_entry(
                EXPORTING
                  i_msgid     = 'PTF'
                  i_msgno     = '070'
                  i_msgty     = 'E'
                  i_msgv1     = 'Please fill message type or message ID'
                  i_fieldname = <fs_mod_cells>-fieldname
                  i_row_id    = <fs_mod_cells>-row_id ).

            ENDIF.

          ENDIF.

        WHEN 'MSGNO_LOW'.
          IF <fs_mod_cells>-value IS NOT INITIAL. "Check that Message No Low is numerical
            ASSIGN gt_outtab_exp_msg[ <fs_mod_cells>-row_id ] TO <fs_outtab_exp_msg>.
            IF sy-subrc = 0.
              IF <fs_mod_cells>-value CN ' 0123456789'
                OR <fs_mod_cells>-value(1) EQ space.
                er_data_changed->add_protocol_entry(
                  EXPORTING
                    i_msgid     = 'PTF'
                    i_msgno     = '070'
                    i_msgty     = 'E'
                    i_msgv1     = 'Message Number Low is invalid'
                    i_fieldname = <fs_mod_cells>-fieldname
                    i_row_id    = <fs_mod_cells>-row_id ).
              ENDIF.
            ENDIF.
          ENDIF.

        WHEN 'MSGNO_HIGH'.
          IF <fs_mod_cells>-value IS NOT INITIAL. "Check that Message No High is numerical
            ASSIGN gt_outtab_exp_msg[ <fs_mod_cells>-row_id ] TO <fs_outtab_exp_msg>.
            IF sy-subrc = 0.
              IF <fs_mod_cells>-value CN ' 0123456789'
                OR <fs_mod_cells>-value(1) EQ space.
                er_data_changed->add_protocol_entry(
                  EXPORTING
                    i_msgid     = 'PTF'
                    i_msgno     = '070'
                    i_msgty     = 'E'
                    i_msgv1     = 'Message Number High is invalid'
                    i_fieldname = <fs_mod_cells>-fieldname
                    i_row_id    = <fs_mod_cells>-row_id ).
              ENDIF.
            ENDIF.
          ENDIF.

*Removed the check for MSGNO_LOW and MSGNO_HI against T100 to decouple test and message. Allows to create PTF scripts before the feature to be tested has been build.
*          IF <fs_mod_cells>-value IS NOT INITIAL. "Check if message no low is valid
*            ASSIGN gt_outtab_exp_msg[ <fs_mod_cells>-tabix ] TO <fs_outtab_exp_msg>.    "<fs_mod_cells>-tabix is not the correct field
*            IF sy-subrc = 0.
*              IF <fs_outtab_exp_msg>-msgid IS NOT INITIAL.
*                lv_msgno = <fs_mod_cells>-value.
*
*                SELECT SINGLE t100~arbgb
*                  INTO CORRESPONDING FIELDS OF ls_t100
*                  FROM t100
*                 WHERE t100~arbgb = <fs_outtab_exp_msg>-msgid
*                   AND t100~msgnr = lv_msgno ##WARN_OK.
*                IF sy-subrc <> 0.
*                  er_data_changed->add_protocol_entry(
*                    EXPORTING
*                      i_msgid     = 'PTF'
*                      i_msgno     = '070'
*                      i_msgty     = 'E'
*                      i_msgv1     = 'Message Number Low is invalid'
*                      i_fieldname = <fs_mod_cells>-fieldname
*                      i_row_id    = <fs_mod_cells>-row_id ).
*
*                ENDIF.
*
*              ELSE.
*                IF line_exists( er_data_changed->mt_mod_cells[ row_id = <fs_mod_cells>-row_id fieldname = 'MSGID' ] ).
*                  lv_msgid = er_data_changed->mt_mod_cells[ row_id = <fs_mod_cells>-row_id fieldname = 'MSGID' ]-value.
*                  lv_msgno = <fs_mod_cells>-value.
*
*                  SELECT SINGLE t100~arbgb
*                    INTO CORRESPONDING FIELDS OF ls_t100
*                    FROM t100
*                   WHERE t100~arbgb = lv_msgid
*                     AND t100~msgnr = lv_msgno ##WARN_OK.
*                  IF sy-subrc <> 0.
*                    er_data_changed->add_protocol_entry(
*                      EXPORTING
*                        i_msgid     = 'PTF'
*                        i_msgno     = '070'
*                        i_msgty     = 'E'
*                        i_msgv1     = 'Message Number Low is invalid'
*                        i_fieldname = <fs_mod_cells>-fieldname
*                        i_row_id    = <fs_mod_cells>-row_id ).
*
*                  ENDIF.
*                ENDIF.
*              ENDIF.
*            ENDIF.
*          ENDIF.
*
*        WHEN 'MSGNO_HIGH'. "!
*          IF <fs_mod_cells>-value IS NOT INITIAL.
*            ASSIGN gt_outtab_exp_msg[ <fs_mod_cells>-tabix ] TO <fs_outtab_exp_msg>.
*            IF sy-subrc = 0.
*              IF <fs_outtab_exp_msg>-msgid IS NOT INITIAL.
*                lv_msgno = <fs_mod_cells>-value.
*
*                SELECT SINGLE t100~arbgb
*                  INTO CORRESPONDING FIELDS OF ls_t100
*                  FROM t100
*                 WHERE t100~arbgb = <fs_outtab_exp_msg>-msgid
*                   AND t100~msgnr = lv_msgno ##WARN_OK.
*                IF sy-subrc <> 0.
*                  er_data_changed->add_protocol_entry(
*                    EXPORTING
*                      i_msgid     = 'PTF'
*                      i_msgno     = '070'
*                      i_msgty     = 'E'
*                      i_msgv1     = 'Message Number High is invalid'
*                      i_fieldname = <fs_mod_cells>-fieldname
*                      i_row_id    = <fs_mod_cells>-row_id ).
*
*                ENDIF.
*
*              ELSE.
*                IF line_exists( er_data_changed->mt_mod_cells[ row_id = <fs_mod_cells>-row_id fieldname = 'MSGID' ] ).
*                  lv_msgid = er_data_changed->mt_mod_cells[ row_id = <fs_mod_cells>-row_id fieldname = 'MSGID' ]-value.
*                  lv_msgno = <fs_mod_cells>-value.
*
*                  SELECT SINGLE t100~arbgb
*                    INTO CORRESPONDING FIELDS OF ls_t100
*                    FROM t100
*                   WHERE t100~arbgb = lv_msgid
*                     AND t100~msgnr = lv_msgno ##WARN_OK.
*                  IF sy-subrc <> 0.
*                    er_data_changed->add_protocol_entry(
*                      EXPORTING
*                        i_msgid     = 'PTF'
*                        i_msgno     = '070'
*                        i_msgty     = 'E'
*                        i_msgv1     = 'Message Number Low is invalid'
*                        i_fieldname = <fs_mod_cells>-fieldname
*                        i_row_id    = <fs_mod_cells>-row_id ).
*
*                  ENDIF.
*                ENDIF.
*              ENDIF.
*            ENDIF.
*          ENDIF.

      ENDCASE.

    ENDLOOP.

  ENDMETHOD.                    "on_data_changed

  METHOD on_user_command.
    CASE e_ucomm.
      WHEN 'INSERT_ROW' OR 'APPEND_ROW'.
        DATA: lt_delta_cells TYPE lvc_t_modi,
              ls_delta_cells TYPE lvc_s_modi.

        LOOP AT gt_outtab_exp_msg ASSIGNING FIELD-SYMBOL(<fs_outtab_exp_msg>).
          DATA(lv_tabix) = sy-tabix.

          IF <fs_outtab_exp_msg>-msgid IS INITIAL.
            ls_delta_cells-row_id    = lv_tabix.
            ls_delta_cells-fieldname = 'MSGID'.
            APPEND ls_delta_cells TO lt_delta_cells.

          ENDIF.

          IF lv_tabix < lines( gt_outtab_exp_msg ) AND <fs_outtab_exp_msg>-operator IS INITIAL.
            ls_delta_cells-row_id    = lv_tabix.
            ls_delta_cells-fieldname = 'OPERATOR'.
            APPEND ls_delta_cells TO lt_delta_cells.

          ENDIF.

        ENDLOOP.

        IF lt_delta_cells IS NOT INITIAL.
          g_grid_exp_msg->set_delta_cells(
            EXPORTING
              it_delta_cells = lt_delta_cells
              i_modified     = abap_on
          ).

        ENDIF.

    ENDCASE.

  ENDMETHOD.                    "on_data_changed_finished

ENDCLASS.


MODULE pbo_3101 OUTPUT.
  PERFORM pbo_3101.

ENDMODULE.

MODULE pai_3101 INPUT.
  PERFORM pai_3101.

ENDMODULE.


FORM pbo_3101.
  DATA: ls_layout  TYPE lvc_s_layo,
        lv_step_id TYPE c LENGTH 2.

  SET PF-STATUS 'EXP_MSG_STATUS'.

  lv_step_id = gv_row_number-row_id.

  SET TITLEBAR 'EXPECTED_MESSAGES' WITH lv_step_id.

  IF g_grid_exp_msg IS NOT BOUND.
    PERFORM build_exp_msg_fieldcatalog.

    CREATE OBJECT g_custom_container_ref_step
      EXPORTING
        container_name = 'TABLE'.

    CREATE OBJECT g_grid_exp_msg
      EXPORTING
        i_parent = g_custom_container_ref_step.

    g_grid_exp_msg->set_ready_for_input(
      EXPORTING
        i_ready_for_input = 1 ).

    g_grid_exp_msg->register_edit_event(
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified ).

    CREATE OBJECT go_ptf_exp_msg_event.
    SET HANDLER go_ptf_exp_msg_event->on_toolbar FOR g_grid_exp_msg.
    SET HANDLER go_ptf_exp_msg_event->on_button_click FOR g_grid_exp_msg.
    SET HANDLER go_ptf_exp_msg_event->on_data_changed FOR g_grid_exp_msg.
    SET HANDLER go_ptf_exp_msg_event->on_user_command FOR g_grid_exp_msg.

*   Read main current Input of main alv
    READ TABLE gt_outtab_step ASSIGNING FIELD-SYMBOL(<fs_outtab_step>) INDEX gv_row_number-row_id.
    IF sy-subrc = 0.
      gt_outtab_exp_msg = CORRESPONDING #( <fs_outtab_step>-exp_messages ).

*  *     Read old input of reference step
*      READ TABLE gt_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data>) INDEX gv_row_number-row_id.
*      IF sy-subrc = 0.
*        gt_outtab_messages = <ls_step_data>-messages.
*
*      ENDIF.

    ENDIF.

*    ls_layout-cwidth_opt = abap_on.
*    ls_layout-no_toolbar = abap_on.
    ls_layout-stylefname = 'HANDLE_STYLE'. "Change editablity of columns

    g_grid_exp_msg->set_table_for_first_display(
      EXPORTING
        is_layout       = ls_layout
      CHANGING
        it_outtab       = gt_outtab_exp_msg
        it_fieldcatalog = gt_fieldcatalog_exp_msg ).

    PERFORM refresh_exp_msg.

  ENDIF.

ENDFORM.

FORM pai_3101.
  CASE more_ok.
    WHEN 'CONTI'.
      g_grid_exp_msg->check_changed_data( IMPORTING e_valid = DATA(lv_valid) ).
      IF lv_valid = abap_on.
        READ TABLE gt_outtab_step ASSIGNING FIELD-SYMBOL(<fs_outtab_step>) INDEX gv_row_number-row_id.
        IF sy-subrc = 0.
          <fs_outtab_step>-exp_messages = CORRESPONDING #( gt_outtab_exp_msg ).

        ENDIF.

        g_grid_exp_msg->free( ).
        g_custom_container_ref_step->free( ).
        CLEAR: g_grid_exp_msg, g_custom_container_ref_step.
        CLEAR: gt_outtab_exp_msg, gt_fieldcatalog_exp_msg.

        CLEAR gv_row_number.

        LEAVE TO SCREEN 0.

      ENDIF.

    WHEN OTHERS.
      g_grid_exp_msg->free( ).
      g_custom_container_ref_step->free( ).
      CLEAR: g_grid_exp_msg, g_custom_container_ref_step.
      CLEAR: gt_outtab_exp_msg, gt_fieldcatalog_exp_msg.

      CLEAR gv_row_number.

      LEAVE TO SCREEN 0.

  ENDCASE.

ENDFORM.

FORM build_exp_msg_fieldcatalog.
  DATA: ls_fieldcatalog     TYPE lvc_s_fcat.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'OPT'.
  ls_fieldcatalog-ref_table = 'PTF_EXP_MESSAGE'.
  ls_fieldcatalog-edit      = 'X'.
  ls_fieldcatalog-outputlen = 10.
  APPEND ls_fieldcatalog TO gt_fieldcatalog_exp_msg.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'MSGID'.
  ls_fieldcatalog-ref_table = 'PTF_EXP_MESSAGE'.
  ls_fieldcatalog-edit      = 'X'.
  ls_fieldcatalog-outputlen = 10.
  APPEND ls_fieldcatalog TO gt_fieldcatalog_exp_msg.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'MSGTY'.
  ls_fieldcatalog-ref_table = 'PTF_EXP_MESSAGE'.
  ls_fieldcatalog-edit      = 'X'.
  ls_fieldcatalog-outputlen = 10.
  APPEND ls_fieldcatalog TO gt_fieldcatalog_exp_msg.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'MSGNO_LOW'.
  ls_fieldcatalog-ref_table = 'PTF_EXP_MESSAGE'.
*  ls_fieldcatalog-lzero     = abap_on.
  ls_fieldcatalog-edit      = 'X'.
  ls_fieldcatalog-outputlen = 10.
  APPEND ls_fieldcatalog TO gt_fieldcatalog_exp_msg.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'MSGNO_HIGH'.
  ls_fieldcatalog-ref_table = 'PTF_EXP_MESSAGE'.
*  ls_fieldcatalog-lzero     = abap_on.
  ls_fieldcatalog-edit      = 'X'.
  ls_fieldcatalog-outputlen = 10.
  APPEND ls_fieldcatalog TO gt_fieldcatalog_exp_msg.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'MSGV1'.
  ls_fieldcatalog-ref_table = 'PTF_EXP_MESSAGE'.
  ls_fieldcatalog-edit      = 'X'.
  ls_fieldcatalog-outputlen = 10.
  APPEND ls_fieldcatalog TO gt_fieldcatalog_exp_msg.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'MSGV2'.
  ls_fieldcatalog-ref_table = 'PTF_EXP_MESSAGE'.
  ls_fieldcatalog-edit      = 'X'.
  ls_fieldcatalog-outputlen = 10.
  APPEND ls_fieldcatalog TO gt_fieldcatalog_exp_msg.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'MSGV3'.
  ls_fieldcatalog-ref_table = 'PTF_EXP_MESSAGE'.
  ls_fieldcatalog-edit      = 'X'.
  ls_fieldcatalog-outputlen = 10.
  APPEND ls_fieldcatalog TO gt_fieldcatalog_exp_msg.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'MSGV4'.
  ls_fieldcatalog-ref_table = 'PTF_EXP_MESSAGE'.
  ls_fieldcatalog-edit      = 'X'.
  ls_fieldcatalog-outputlen = 10.
  APPEND ls_fieldcatalog TO gt_fieldcatalog_exp_msg.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'OPERATOR'.
  ls_fieldcatalog-ref_table = 'PTF_EXP_MESSAGE'.
*  ls_fieldcatalog-edit      = 'X'.
  ls_fieldcatalog-outputlen = 10.
  APPEND ls_fieldcatalog TO gt_fieldcatalog_exp_msg.

ENDFORM.

FORM refresh_exp_msg.
  LOOP AT gt_outtab_exp_msg ASSIGNING FIELD-SYMBOL(<fs_outtab_exp_msg>).
    DATA(lv_tabix) = sy-tabix.

    IF <fs_outtab_exp_msg>-handle_style IS INITIAL.
      <fs_outtab_exp_msg>-handle_style   = VALUE #( ( fieldname = 'OPERATOR' style = cl_gui_alv_grid=>mc_style_disabled style2 = cl_gui_alv_grid=>mc_style_disabled ) ).

    ENDIF.

    LOOP AT <fs_outtab_exp_msg>-handle_style ASSIGNING FIELD-SYMBOL(<fs_handle_style>).
      CASE <fs_handle_style>-fieldname.
        WHEN 'OPERATOR'.
          IF lv_tabix < lines( gt_outtab_exp_msg ).
            <fs_handle_style>-style = cl_gui_alv_grid=>mc_style_enabled.

          ELSE.
            <fs_handle_style>-style = cl_gui_alv_grid=>mc_style_disabled.
            CLEAR <fs_outtab_exp_msg>-operator.

          ENDIF.

      ENDCASE.

    ENDLOOP.

  ENDLOOP.

  g_grid_exp_msg->refresh_table_display( ).

ENDFORM.
