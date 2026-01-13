*&---------------------------------------------------------------------*
*& Include          PTF_REPOSITORY
*&---------------------------------------------------------------------*
MODULE pbo_8003 OUTPUT.
  PERFORM pbo_8003.

ENDMODULE.

MODULE pai_8003 INPUT.
  PERFORM pai_8003.

ENDMODULE.

FORM pbo_8003.
  DATA lt_fcode_excl TYPE STANDARD TABLE OF syst-ucomm.
  DATA lv_step_id    TYPE c LENGTH 2.
  DATA lv_string     TYPE string.

* Reset OKCODE
  CLEAR repo_ok.

  READ TABLE gt_outtab_step ASSIGNING FIELD-SYMBOL(<fs_outtab_step>) INDEX gv_row_number-row_id.
  IF sy-subrc = 0.
    lv_step_id = gv_row_number-row_id.
    lv_string = <fs_outtab_step>-bus_obj && '-' && <fs_outtab_step>-action.

  ENDIF.

  CASE gv_toolbar_button.
    WHEN 'LOAD_REPO'.
      SET TITLEBAR 'JSON_LOAD_REPO' WITH lv_step_id lv_string.

    WHEN 'SAVE_REPO'.
      SET TITLEBAR 'JSON_SAVE_REPO' WITH lv_step_id lv_string.

    WHEN OTHERS.
      SET TITLEBAR 'JSON_REPOSITORY' WITH lv_step_id lv_string.

  ENDCASE.

  SET PF-STATUS 'REPOSITORY_STATUS' EXCLUDING lt_fcode_excl.

ENDFORM.

FORM pai_8003.
  DATA: lv_result TYPE abap_bool.

  CASE repo_ok.
    WHEN 'CONTI'.
      CASE gv_toolbar_button.
        WHEN 'LOAD_REPO'.
          PERFORM load_json_repository CHANGING lv_result.

        WHEN 'SAVE_REPO'.
          PERFORM save_json_repository CHANGING lv_result.

      ENDCASE.

      IF lv_result = abap_on.
*       Clear the value of the toolbar button that has been clicked
        CLEAR gv_toolbar_button.
        LEAVE TO SCREEN 0.

      ENDIF.

    WHEN 'CANC'.
*     Restore the original values
      p_jsid    = gs_ptf_input_repo-input_id.
      p_bo      = gs_ptf_input_repo-bus_obj.
      p_act     = gs_ptf_input_repo-action.
      p_jsdscr  = gs_ptf_input_repo-descr.

*     Clear the value of the toolbar button that has been clicked
      CLEAR gv_toolbar_button.
      LEAVE TO SCREEN 0.

  ENDCASE.

ENDFORM.

FORM f4_p_jsid.
  DATA lt_shlp         TYPE shlp_descr.
  DATA lt_dynpfields   TYPE STANDARD TABLE OF dynpread.
  DATA lt_return_value TYPE STANDARD TABLE OF ddshretval.

** Read value of p_jsid and p_bo because it is not available directly
*  APPEND VALUE #( fieldname = 'P_JSID' ) TO lt_dynpfields.
  APPEND VALUE #( fieldname = 'P_BO' ) TO lt_dynpfields.
  APPEND VALUE #( fieldname = 'P_ACT' ) TO lt_dynpfields.

  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname     = sy-repid
      dynumb     = '8002'
    TABLES
      dynpfields = lt_dynpfields.

  CALL FUNCTION 'F4IF_GET_SHLP_DESCR'
    EXPORTING
      shlpname = 'SHPTF_INPUT_REPO'
    IMPORTING
      shlp     = lt_shlp.

  LOOP AT lt_shlp-interface ASSIGNING FIELD-SYMBOL(<fs_shlp_inface>).
    CASE <fs_shlp_inface>-shlpfield.
      WHEN 'INPUT_ID'.
*        <fs_shlp_inface>-value    = lt_dynpfields[ fieldname = 'P_JSID' ]-fieldvalue. "Don't pass value from screen
        <fs_shlp_inface>-valfield = 'X'.
      WHEN 'BUS_OBJ'.
        <fs_shlp_inface>-value    = lt_dynpfields[ fieldname = 'P_BO' ]-fieldvalue.
        <fs_shlp_inface>-valfield = 'X'.

      WHEN 'ACTION'.
        <fs_shlp_inface>-value    = lt_dynpfields[ fieldname = 'P_ACT' ]-fieldvalue.
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

  CLEAR lt_dynpfields.

  IF line_exists( lt_return_value[ fieldname = 'INPUT_ID' ] ).
    p_jsid = lt_return_value[ fieldname = 'INPUT_ID' ]-fieldval.

    APPEND VALUE #( fieldname = 'P_JSID' fieldvalue = lt_return_value[ fieldname = 'INPUT_ID' ]-fieldval ) TO lt_dynpfields.

  ENDIF.

  IF line_exists( lt_return_value[ fieldname = 'BUS_OBJ' ] ).
    p_bo = lt_return_value[ fieldname = 'BUS_OBJ' ]-fieldval.

    APPEND VALUE #( fieldname = 'P_BO' fieldvalue = lt_return_value[ fieldname = 'BUS_OBJ' ]-fieldval ) TO lt_dynpfields.

  ENDIF.

  IF line_exists( lt_return_value[ fieldname = 'ACTION' ] ).
    p_act = lt_return_value[ fieldname = 'ACTION' ]-fieldval.

    APPEND VALUE #( fieldname = 'P_ACT' fieldvalue = lt_return_value[ fieldname = 'ACTION' ]-fieldval ) TO lt_dynpfields.

  ENDIF.

  IF line_exists( lt_return_value[ fieldname = 'DESCR' ] ).
    p_jsdscr = lt_return_value[ fieldname = 'DESCR' ]-fieldval.

    APPEND VALUE #( fieldname = 'P_JSDSCR' fieldvalue = lt_return_value[ fieldname = 'DESCR' ]-fieldval ) TO lt_dynpfields.

  ENDIF.

  CALL FUNCTION 'DYNP_VALUES_UPDATE'
    EXPORTING
      dyname     = sy-repid
      dynumb     = '8002'
    TABLES
      dynpfields = lt_dynpfields.

ENDFORM.

FORM f4_p_bo.
  DATA lt_shlp         TYPE shlp_descr.
  DATA lt_dynpfields   TYPE STANDARD TABLE OF dynpread.
  DATA lt_return_value TYPE STANDARD TABLE OF ddshretval.

* Read value of p_bo because it is not available directly
  APPEND VALUE #( fieldname = 'P_BO' ) TO lt_dynpfields.

  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname     = sy-repid
      dynumb     = '8002'
    TABLES
      dynpfields = lt_dynpfields.

  CALL FUNCTION 'F4IF_GET_SHLP_DESCR'
    EXPORTING
      shlpname = 'SHPTF_RAP_BO' "'SHPTF_BUS_OBJ'
    IMPORTING
      shlp     = lt_shlp.

  LOOP AT lt_shlp-interface ASSIGNING FIELD-SYMBOL(<fs_shlp_inface>).
    CASE <fs_shlp_inface>-shlpfield.
      WHEN 'PTF_BO'.
        <fs_shlp_inface>-value    = lt_dynpfields[ fieldname = 'P_BO' ]-fieldvalue.
        <fs_shlp_inface>-valfield = 'X'.

    ENDCASE.
  ENDLOOP.

  CALL FUNCTION 'F4IF_START_VALUE_REQUEST'
    EXPORTING
      shlp          = lt_shlp
    TABLES
      return_values = lt_return_value.

  IF line_exists( lt_return_value[ 1 ] ).
    p_bo = lt_return_value[ 1 ]-fieldval.

  ENDIF.

ENDFORM.

FORM f4_p_act.
  DATA lt_shlp         TYPE shlp_descr.
  DATA lt_return_value TYPE STANDARD TABLE OF ddshretval.

* Get the description for the search help
  CALL FUNCTION 'F4IF_GET_SHLP_DESCR'
    EXPORTING
      shlpname = 'SHPTF_RAP_ACT'
    IMPORTING
      shlp     = lt_shlp.

  LOOP AT lt_shlp-interface ASSIGNING FIELD-SYMBOL(<fs_shlp_inface>).
    CASE <fs_shlp_inface>-shlpfield.
      WHEN 'PTF_ACT'.
        <fs_shlp_inface>-valfield = 'X'.

    ENDCASE.
  ENDLOOP.

  CALL FUNCTION 'F4IF_START_VALUE_REQUEST'
    EXPORTING
      shlp          = lt_shlp
    TABLES
      return_values = lt_return_value.

  IF line_exists( lt_return_value[ 1 ] ).
    p_act = lt_return_value[ 1 ]-fieldval.

  ENDIF.

ENDFORM.

FORM load_json_repository CHANGING cv_result TYPE abap_bool.
  DATA(lo_json_repository) = NEW cl_ptf_json_repository( ).

  TRY.
      DATA(ls_ptf_input_repo) = lo_json_repository->load( p_jsid ).

    CATCH cx_ptf_json_repository INTO DATA(lx_json_repository).
      MESSAGE s208(00) WITH lx_json_repository->get_text( ) DISPLAY LIKE 'E'.
      RETURN.

  ENDTRY.

  cv_result = abap_on.

* Set back the new file
  gv_json_file = ls_ptf_input_repo-input_string.
  g_editor->set_textstream( gv_json_file ).

  gv_rep_input_source = 'FIELD'.
  PERFORM reset_repository_load.

  MESSAGE s083(ptf).

ENDFORM.

FORM save_json_repository CHANGING cv_result TYPE abap_bool.
  DATA: lx_json_repository TYPE REF TO cx_ptf_json_repository,
        lv_answer          TYPE c LENGTH 1,
        lv_canceled        TYPE abap_bool.

  DATA(lo_json_repository) = NEW cl_ptf_json_repository( ).

* Refresh the JSON coming from the editor
  g_editor->get_textstream( IMPORTING text = gv_json_file ).
  cl_gui_cfw=>flush( ). "needed

* Check if saving is allowed
  IF p_jsid IS INITIAL.
    MESSAGE ID 'PTF' TYPE 'S' NUMBER 102 DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.
  DATA(lv_maintenance_allowed) = lo_json_repository->is_maintnce_here_allowed_for( p_jsid ).
  IF lv_maintenance_allowed = abap_off.
    "Update of JSON ID (non Z) is only allowed in Home dev clients
    MESSAGE ID 'PTF' TYPE 'S' NUMBER 087 DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

* Save only with alphanumerical chars
  IF NOT matches( val = p_jsid pcre = cl_ptf_json_repository=>gc_input_id_pcre ).
    MESSAGE ID 'PTF' TYPE 'S' NUMBER 089 DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  cv_result = abap_on.

* Check if the JSON repository already exists
  DATA(lv_json_repository) = lo_json_repository->check( CONV #( p_jsid ) ).

  IF lv_json_repository = abap_on. "Repository exists

*   Show pop-up
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar      = 'JSON ID Overwrite confirmation'
        text_question = |Are you sure you want to overwrite { p_jsid } in the repository ?|
        text_button_1 = 'Yes'
        icon_button_1 = 'ICON_CHECKED'
        "text_button_2   = 'No'
        "icon_button_2   = 'ICON_CANCEL'
      IMPORTING
        answer        = lv_answer.

    CASE lv_answer.
      WHEN '1'. "Yes
        TRY.
            lo_json_repository->save(
              EXPORTING
                iv_input_id     = p_jsid
                iv_bus_obj      = p_bo
                iv_action       = p_act
                iv_descr        = p_jsdscr
                iv_input_string = gv_json_file
                iv_update       = abap_on
            ).
          CATCH cx_ptf_json_repository INTO lx_json_repository.
            MESSAGE s208(00) WITH lx_json_repository->get_text( ) DISPLAY LIKE 'E'.
        ENDTRY.

        PERFORM write_transport_repository USING    p_jsid
                                                    'S'
                                           CHANGING lv_canceled.

        IF lv_canceled = abap_off.
          gv_rep_input_source = 'FIELD'.
          PERFORM reset_repository_load.

        ENDIF.

    ENDCASE.

  ELSE.

    TRY.
        lo_json_repository->save(
          EXPORTING
            iv_input_id     = p_jsid
            iv_bus_obj      = p_bo
            iv_action       = p_act
            iv_descr        = p_jsdscr
            iv_input_string = gv_json_file
        ).

      CATCH cx_ptf_json_repository INTO lx_json_repository.
        MESSAGE s208(00) WITH lx_json_repository->get_text( ) DISPLAY LIKE 'E'.
    ENDTRY.

    PERFORM write_transport_repository USING    p_jsid
                                                'S'
                                       CHANGING lv_canceled.

    IF lv_canceled = abap_off.
      gv_rep_input_source = 'FIELD'.
      PERFORM reset_repository_load.
    ENDIF.

  ENDIF.

ENDFORM.

FORM delete_json_repository.
  DATA: lv_answer   TYPE c LENGTH 1,
        lv_canceled TYPE abap_bool.

  DATA(lo_json_repository) = NEW cl_ptf_json_repository( ).

* Check if saving is allowed
  DATA(lv_maintenance_allowed) = lo_json_repository->is_maintnce_here_allowed_for( p_jsid ).
  IF lv_maintenance_allowed = abap_off.
    "Deletion of JSON ID (non Z) is only allowed in Home dev clients
    MESSAGE ID 'PTF' TYPE 'S' NUMBER 088 DISPLAY LIKE 'E'.
    RETURN.

  ENDIF.

  READ TABLE gt_outtab_step ASSIGNING FIELD-SYMBOL(<fs_outtab_step>) INDEX gv_row_number-row_id.
  IF sy-subrc = 0.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = 'JSON ID Deletion confirmation'
        text_question         = |Are you sure you want to delete JSON ID { p_jsid } from the repository ?|
        text_button_1         = 'Yes'
        icon_button_1         = 'ICON_CHECKED'
        text_button_2         = 'No'
        icon_button_2         = 'ICON_CANCEL'
        display_cancel_button = abap_off
      IMPORTING
        answer                = lv_answer.

    CASE lv_answer.
      WHEN '1'. "Yes
        TRY.
            lo_json_repository->delete( p_jsid ).

            PERFORM write_transport_repository USING    p_jsid
                                                        'D'
                                               CHANGING lv_canceled.

            IF lv_canceled = abap_off.
              gv_rep_input_source = 'LOCAL'. "Because JSON ID has been deleted from repository so what's in the editor is LOCAL now

              CLEAR: p_jsid, p_jsdscr. "Clear INPUT ID and description from subscreen

              CLEAR <fs_outtab_step>-variant. "Clear Variant from ALV

              MESSAGE s085(ptf).

              cl_gui_cfw=>set_new_ok_code( '/00' ). "reload PBO to refresh subscreen with INPUT ID, BO etc.

*           Refresh ALV to show clear VARIANT
              g_grid_step->refresh_table_display( ).

            ENDIF.

          CATCH cx_ptf_json_repository INTO DATA(lx_json_repository).
            MESSAGE s208(00) WITH lx_json_repository->get_text( ) DISPLAY LIKE 'E'.

        ENDTRY.

    ENDCASE.

  ENDIF.

ENDFORM.

FORM write_transport_repository USING    uv_input_id    TYPE ptf_input_repo-input_id
                                         uv_action      TYPE char1
                                CHANGING cv_canceled    TYPE abap_bool.
  DATA: lt_ko200  TYPE TABLE OF ko200,
        lt_e071k  TYPE TABLE OF e071k,
        lv_trkorr TYPE trkorr.

  DATA(lo_client) = NEW cl_ptf_client( ).
  DATA(lo_json_repository) = NEW cl_ptf_json_repository( ).

  IF lo_json_repository->is_in_customer_ns( uv_input_id )          "if this form is called, not z-script AND not homedevclient should never occur.
    OR lo_client->is_blocklisted_against_tr( ).
    "JSON ID NOT in customer namespace: Do not transport
    CASE uv_action.
      WHEN 'S'.
        MESSAGE s082(ptf).

      WHEN 'D'.
        MESSAGE s085(ptf).

    ENDCASE.

    COMMIT WORK AND WAIT.
    RETURN.

  ENDIF.

* "JSON ID in SAP namespace -> CR
  lo_json_repository->go_transport->get_transport_entries(
    IMPORTING
      et_ko200 = lt_ko200
      et_e071k = lt_e071k ).

  CALL FUNCTION 'TR_OBJECTS_CHECK'
    TABLES
      wt_ko200                = lt_ko200
    EXCEPTIONS
      cancel_edit_other_error = 1
      show_only_other_error   = 2
      OTHERS                  = 3.
  IF sy-subrc EQ 0.
    CALL FUNCTION 'TR_OBJECTS_INSERT'
      EXPORTING
        wi_order                = lv_trkorr
      IMPORTING
        we_order                = lv_trkorr
      TABLES
        wt_ko200                = lt_ko200
        wt_e071k                = lt_e071k
      EXCEPTIONS
        cancel_edit_other_error = 1
        show_only_other_error   = 2
        OTHERS                  = 3.
    IF sy-subrc = 0.
      COMMIT WORK AND WAIT.

      CASE uv_action.
        WHEN 'S'.
          MESSAGE s082(ptf).

        WHEN 'D'.
          MESSAGE s085(ptf).

      ENDCASE.

    ELSE.
      ROLLBACK WORK.
      cv_canceled = abap_on.
      MESSAGE s034(ptf) DISPLAY LIKE 'E'.

    ENDIF.

  ENDIF.

  lo_json_repository->go_transport->delete_transport_entries( ).

ENDFORM.
