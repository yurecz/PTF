*&---------------------------------------------------------------------*
*& Include          PTF_VARIANT
*&---------------------------------------------------------------------*

FORM on_save_button.

  DATA(lo_client) = NEW cl_ptf_client( ).

  PERFORM update_step_data CHANGING gt_step_data.

  DATA(lo_error) = go_variant->check_syntax( gt_step_data ).
  IF lo_error IS BOUND.
    lo_error->raise_message( display_type = 'E' ).
    PERFORM set_focus_oo USING lo_error.
    RETURN.
  ENDIF.

  "Block save if there are filled lines after an empty line
  LOOP AT gt_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data>).
    IF <ls_step_data>-bus_obj IS INITIAL.
      DATA(lv_empty_line_occurred) = abap_true.
    ELSE.
      IF lv_empty_line_occurred EQ abap_true.
        MESSAGE ID 'PTF' TYPE 'S' NUMBER 069 DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.
    ENDIF.

  ENDLOOP.


  IF NOT ( gs_varhead-just_loaded_from_file EQ abap_true AND gs_varhead-name_exists_on_db EQ abap_false )
    AND
     gs_varhead IS NOT INITIAL.

    "Variant ID is already persisted


    " Warn if current system is not the Original system. Don't exit.
    IF NOT lo_client->is_variant_from_this_system( gs_varhead-varname ). "future logic: when this method raises cx_ptf_variant_not_found, then do not try to handle this, but dump, must never occur
      MESSAGE ID 'TR' TYPE 'I' NUMBER 850   ##MG_MISSING.
    ENDIF.

    " offer 'Save or Change'
    DATA lv_answer TYPE string.
    CONCATENATE 'Do you want to change Script' gs_varhead-varname 'or to create a new Script?' INTO DATA(lv_message) SEPARATED BY space.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        text_question         = lv_message
        display_cancel_button = 'X'
        start_column          = '10'
        text_button_1         = 'Change'
        text_button_2         = 'Create new'
      IMPORTING
        answer                = lv_answer.   "1/2/A (A for Cancel)

    IF lv_answer = '1'.

      "Change

      IF NOT go_variant->is_maintnce_here_allowed_for( gs_varhead-varname ).
        BREAK griesec.
        "Update of scripts (non Z) is only allowed in Home dev clients
        MESSAGE ID 'PTF' TYPE 'S' NUMBER 067 DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

      "Block modification in certain cases
      DATA(lv_msgno) = lo_client->does_system_block_modification( gs_varhead-varname ).
      IF lv_msgno IS NOT INITIAL.
        MESSAGE ID 'PTF' TYPE 'S' NUMBER lv_msgno DISPLAY LIKE 'E'.
        RETURN. "!
      ENDIF.

      "Change it
      PERFORM update.

    ELSEIF lv_answer = '2'.
      PERFORM save.
    ENDIF.

  ELSE.
    "Variant was not loaded from DB, and also not saved to DB before     (but variant might just have been loaded from file)
    PERFORM save.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form save
*&---------------------------------------------------------------------*
FORM save.

*  IF gv_check_alv_status EQ abap_false.                     "redundant, as long as this Form is only called by Form on_save_button.
*    MESSAGE ID 'PTF' TYPE 'S' NUMBER 020 WITH p_vaname.
*    RETURN.
*  ENDIF.

  IF gs_varhead-just_loaded_from_file EQ abap_false.
    "std logic
    CLEAR gt_ptf_var_tags. "decision: do not take over tags for Save-CreateNew  "was filled if  loaded for/entered at  other screen before
    "gt_text_table is kept, not cleared, as this is probable to be kept in script copies.
  ELSE.
    "db save of uploaded script
    p_vaname = gs_varhead-varname.
    p_descr  = gs_varhead-vardescr.
    p_user_s = gs_varhead-user_specific.
    p_scpitm = gs_varhead-scope_item.
  ENDIF.

  PERFORM create_the_create_popup_6001.   "save dialog (to enter name, description, detail text, etc.)   fills p_descr, p_vaname, p_user_s, p_scpitm, gt_text_table, gt_ptf_var_tags

  IF gv_cancel = abap_true.
    CLEAR gv_cancel.
    RETURN.    "The CLEAR of p_* fields at form end is not executed, the values are kept
  ENDIF.

  IF gt_ptf_var_tags IS NOT INITIAL.
    LOOP AT gt_ptf_var_tags ASSIGNING FIELD-SYMBOL(<entered_tag>).
      SELECT SINGLE tag FROM ptf_var_tag WHERE tag = @<entered_tag>-tag INTO @DATA(tag_dummy).
      IF sy-subrc IS NOT INITIAL.
        MESSAGE s058(ptf) WITH <entered_tag>-tag  DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.
    ENDLOOP.
  ENDIF.

  IF p_vaname IS INITIAL.
    "Reusing "Variant &1 already exists."  "ToDO: create a suitable message here!
    MESSAGE ID 'PTF' TYPE 'S' NUMBER 030 WITH p_vaname DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  DATA(lo_client) = NEW cl_ptf_client( ).
  IF NOT go_variant->is_maintnce_here_allowed_for( p_vaname ).
    "Script maintenance is only allowed in Home dev clients. But you can create and change Z scripts.
    MESSAGE ID 'PTF' TYPE 'S' NUMBER 066 DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  SELECT SINGLE * FROM ptf_varid INTO @DATA(ls_ptf_varid_dummy) WHERE varname = @p_vaname.
  IF sy-subrc IS INITIAL.
    "Variant &1 already exists.
    MESSAGE ID 'PTF' TYPE 'S' NUMBER 030 WITH p_vaname DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  IF NOT matches( val = p_vaname regex = cl_ptf_variant=>gc_variant_regex ) ##REGEX_POSIX.
    MESSAGE ID 'PTF' TYPE 'E' NUMBER 045.  "ends processing
  ENDIF.

  IF p_vaname EQ cl_ptf_file=>gc_no_script_name.  "default name for script download shall not be used for DB save
    "Reusing "Variant &1 already exists."  "ToDO: create a suitable message here!
    MESSAGE ID 'PTF' TYPE 'S' NUMBER 030 WITH p_vaname DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  CHECK gt_outtab_step IS NOT INITIAL.
  PERFORM prepare_variant_tab.   "build gt_variant_tab

  go_variant->save(
   EXPORTING
     it_variant_tab   = gt_variant_tab
     iv_varname       = p_vaname
     iv_vardescr      = p_descr
     iv_user_specific = p_user_s
     iv_scope_item    = p_scpitm
     it_vartext       = gt_text_table
     it_tags          = gt_ptf_var_tags
     it_vardataset    = gt_outtab_vardataset ).

  "Fill script attributes
  CLEAR gv_script_was_changed.
  CLEAR gs_varhead.  "clears also gs_varhead-just_loaded_from_file
  gs_varhead-varname       = p_vaname.
  gs_varhead-vardescr      = p_descr.
  gs_varhead-user_specific = p_user_s.
  gs_varhead-ernam         = sy-uname.  "read if Form Update is called later
  gs_varhead-erdat         = go_variant->get_date( ).  "might never be evaluated
  gs_varhead-scope_item    = p_scpitm.

  PERFORM get_transport USING p_vaname 'S'.    "note that this Form does also COMMIT WORK AND WAIT

  CLEAR: p_vaname, p_descr, p_user_s, p_scpitm.  "these parameters are only used for SAVE. they are cleared here and not BEFORE the popup is called to keep them in case of cancel, for future SAVE

  cl_gui_cfw=>set_new_ok_code( new_code = 'REFR' ).

ENDFORM.

*&---------------------------------------------------------------------*
*& Form update
*&---------------------------------------------------------------------*
FORM update.

  CLEAR gt_variant_tab.

  IF gs_varhead IS INITIAL.
    MESSAGE ID 'PTF' TYPE 'S' NUMBER 027 DISPLAY LIKE 'W'. "Open the variant that you would like to change.
    RETURN.
  ENDIF.

  IF gs_varhead-ernam NE sy-uname AND gs_varhead-user_specific = abap_true.
    MESSAGE ID 'PTF' TYPE 'S' NUMBER 024  DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.


  "Prepare data for Update popup
  p_vname2  = gs_varhead-varname.
  p_descr2  = gs_varhead-vardescr.
  p_user    = gs_varhead-user_specific.
  p_scpitm2 = gs_varhead-scope_item.
  "Texts are in gt_text_table
  "Read Tags from DB
  CLEAR gt_ptf_var_tags.
  gt_ptf_var_tags = cl_ptf_variant_tag_manager=>get_tags_for_variant_and_user(
    EXPORTING
      user    = sy-uname
      variant = gs_varhead-varname
  ).

  PERFORM create_the_update_popup_7001.   "can change p_vname2, p_descr2, p_user, p_scpitm2, gt_text_table, gt_ptf_var_tags

  IF gv_cancel = abap_false.

    "We don't want that the varname is changed in the popup when in 'Save,Change' mode. For this there is the 'Save,CreateNew' mode. Tag logic does even support this explicitly, but we stop it here.
    "It is too dangerous that the old script is deleted unintendedly when the user changes the VARNAME after choosing 'Save,Change' before.
    IF gs_varhead-varname NE p_vname2.
      MESSAGE ID 'PTF' TYPE 'E' NUMBER 025 WITH p_vname2.  "ends processing  "Unable to change variant &1.
    ENDIF.

    IF NOT matches( val = p_vname2 regex = cl_ptf_variant=>gc_variant_regex ) ##REGEX_POSIX.    "better call this from PAI?
      MESSAGE ID 'PTF' TYPE 'E' NUMBER 045.  "ends processing
    ENDIF.

    IF p_user NE gs_varhead-user_specific AND gs_varhead-ernam NE sy-uname.
      MESSAGE ID 'PTF' TYPE 'S' NUMBER 024  DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.

    IF gt_ptf_var_tags IS NOT INITIAL.
      LOOP AT gt_ptf_var_tags ASSIGNING FIELD-SYMBOL(<entered_tag>).
        SELECT SINGLE tag FROM ptf_var_tag WHERE tag = @<entered_tag>-tag INTO @DATA(tag_dummy).
        IF sy-subrc IS NOT INITIAL.
          MESSAGE s058(ptf) WITH <entered_tag>-tag  DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.
      ENDLOOP.
    ENDIF.

    PERFORM prepare_variant_tab.   "build gt_variant_tab

    go_variant->update(
      EXPORTING
        iv_varname       = gs_varhead-varname
        iv_varname_new   = p_vname2
        iv_vardescr_new  = p_descr2
        it_variant_tab   = gt_variant_tab
        iv_user_specific = p_user
        iv_scope_item    = p_scpitm2
        it_vartext       = gt_text_table
        it_tags          = gt_ptf_var_tags
        it_vardataset    = gt_outtab_vardataset
    ).

    PERFORM get_transport USING p_vname2 'U'.

    "Fill script attributes  "here in form update we do not clear the structure. but could be done for symmetry
    gs_varhead-vardescr      = p_descr2.
    gs_varhead-varname       = p_vname2.
    gs_varhead-user_specific = p_user.
    gs_varhead-scope_item    = p_scpitm2.
    CLEAR gs_varhead-just_loaded_from_file.
    CLEAR gv_script_was_changed.

  ENDIF.

  CLEAR gv_cancel.
  cl_gui_cfw=>set_new_ok_code( new_code = 'REFR' ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_variants
*&---------------------------------------------------------------------*
FORM get_variants.

  DATA lv_external_variant TYPE ptf_varname.
  DATA lv_selection_index  TYPE syst_tabix.
  DATA ls_selection        TYPE ptf_selection.
  DATA l_text_table        TYPE TABLE OF ptf_text.

  CLEAR gt_selection.
  "do not clear gs_varhead before the popup as the selection might be cancelled

  CLEAR gt_variant_tab.

*  IF go_variant IS BOUND.
*    IF go_variant->go_transport IS  BOUND.
*      go_variant->go_transport->delete_transport_entries( ). "not needed as we now clear this in each PBO.
*    ENDIF.
*  ENDIF.


  cl_ptf_wrapper=>get_variant( IMPORTING ev_variant = lv_external_variant ).  "currently only set by CL_PTF_WRAPPER-EXECUTE_REPORT
  IF lv_external_variant IS INITIAL. "normal in dialog

    PERFORM popup_for_selection CHANGING lv_selection_index.   "Popup with variant selection parameters, and then list of matching variants     "sets global gt_selection

  ENDIF.

*  CHECK g_exit NE 'X'. "is never set         instead gv_cancel is set in screen 2001, AT SELECTION-SCREEN

  IF go_variant IS BOUND AND lv_selection_index IS NOT INITIAL.
    "user selected a line
    CLEAR ls_selection.
    CLEAR gs_varhead.   "clears also gs_varhead-just_loaded_from_file
    CLEAR gv_script_was_changed.
    READ TABLE gt_selection INTO ls_selection INDEX lv_selection_index. "includes desc, ERDAT, ERNAM, userSpec., scopeItem, but never Tag
    ASSERT sy-subrc EQ 0.
    go_variant->read(    "does not read PTF_VARID!
      EXPORTING
        iv_varname     = ls_selection-varname
      IMPORTING
        et_variant_tab = gt_variant_tab
        et_varcat      = l_text_table
        et_vardataset  = gt_outtab_vardataset ).
    gt_text_table = l_text_table.
    PERFORM move_data_to_alv.
    CALL METHOD g_grid_step->refresh_table_display( ).
    "Fill script attributes
    MOVE-CORRESPONDING ls_selection TO gs_varhead.
    cl_gui_cfw=>set_new_ok_code( new_code = 'REFR' ).

  ELSEIF lv_external_variant IS NOT INITIAL.
    "variant name provided externally
    CLEAR ls_selection.
    CLEAR gs_varhead.
    DATA(lo_variant) = NEW cl_ptf_variant( ).
    CHECK lo_variant->check_existence( lv_external_variant ) EQ abap_true.
    lo_variant->read(
      EXPORTING
        iv_varname     = lv_external_variant
      IMPORTING
        et_variant_tab = gt_variant_tab
        et_varcat      = l_text_table
        et_vardataset  = gt_outtab_vardataset ).
    gs_varhead-varname = lv_external_variant.
    "no text handling
    "no ALV handling
    "no script properties
    "gs_varhead-just_loaded_from_file is irrelevant in batch
    cl_gui_cfw=>set_new_ok_code( new_code = 'REFR' ). "needed?
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form move_data_to_alv
*&---------------------------------------------------------------------*
FORM move_data_to_alv.
* called when a variant has been loaded (even in batch)
* builds newly  gt_outtab_step and gt_step_data, reading gt_variant_tab.

*details for gt_step_data:
* -it is cleared, and gets at least 40 empty lines
* -column reference_step (is an itab) is filled from gt_variant_tab-reference_step (is an itab)
* -PERFORM update_step_data

  DATA: ls_outtab_step           TYPE cl_ptf_util=>ty_outtab,
        ls_step_data             TYPE cl_ptf_util=>gt_ptf_step,
        lv_length                TYPE i,
        ls_outtab_reference_step TYPE ty_outtab_ref_step,
        lt_outtab_ref_step       TYPE TABLE OF ty_outtab_ref_step,
        ls_handle_style          TYPE lvc_s_styl.

  CLEAR gt_outtab_step.
  CLEAR gt_step_data.

  CLEAR gs_varhead-just_loaded_from_file.  "might be redundant

  DESCRIBE TABLE gt_variant_tab LINES lv_length.   "gt_variant_tab has the real records from the DB table PTF_VARCON (or the filled records filtered from gt_outtab_step in FORM prepare_variant_tab), it is not filled up with empty lines
  IF lv_length < 40.
    lv_length = 40.
  ENDIF.
  ls_outtab_step-reference_step_more = icon_enter_more.
*  ls_outtab_step-reference_document_id_more = icon_enter_more.
  ls_outtab_step-json_file_more      = icon_text_ina.
  "Create new gt_outtab_step and gt_step_data
  DO lv_length TIMES.
    ls_outtab_step-step_number = ls_outtab_step-step_number + 1.
    APPEND ls_outtab_step TO gt_outtab_step.
*    ls_step_data-step_number = ls_outtab_step-step_number.    "was redundant, done again in FORM update_step_data based on gt_outtab_step, also for lines later added
    APPEND ls_step_data TO gt_step_data.
  ENDDO.


  IF gt_variant_tab IS NOT INITIAL.
    "Fill newly ls_outtab_step, then overwrite GT_OUTTAB_STEP (only the filled steps are updated here, not all 40)
    LOOP AT gt_variant_tab ASSIGNING FIELD-SYMBOL(<ls_variant>).
      CLEAR ls_outtab_step.
      DATA(lv_row) = sy-tabix.

      ls_outtab_step-bus_obj             = <ls_variant>-bus_obj.
      ls_outtab_step-action              = <ls_variant>-action.
      ls_outtab_step-variant             = <ls_variant>-variant.
      ls_outtab_step-test_data_container = <ls_variant>-test_data_container.
      ls_outtab_step-json_file           = <ls_variant>-input_string.
      MOVE-CORRESPONDING <ls_variant>-exp_messages TO ls_outtab_step-exp_messages.  "itab

      "Show whether additionalRefStep list is filled
      DESCRIBE TABLE <ls_variant>-reference_step LINES DATA(lv_length_refs).
      IF lv_length_refs > 1.
        ls_outtab_step-reference_step_more = icon_display_more.
      ELSE.
        ls_outtab_step-reference_step_more = icon_enter_more.
      ENDIF.

      "Show whether JSON is filled
      IF ls_outtab_step-json_file IS INITIAL.
        ls_outtab_step-json_file_more = icon_text_ina.
      ELSE.
        ls_outtab_step-json_file_more = icon_text_act.
      ENDIF.

      "For the current step, fill gt_step_data-reference_step (itab) and ls_outtab_step-reference_step (field)
      CLEAR lt_outtab_ref_step.
      LOOP AT <ls_variant>-reference_step ASSIGNING FIELD-SYMBOL(<ls_reference>).
        "Fill field of ls_outtab_step with first value
        IF sy-tabix = 1.
          ls_outtab_step-reference_step = <ls_reference>.
        ENDIF.
        "Add all references to lt_outtab_ref_step, preparation for gt_step_data
        IF lines( <ls_variant>-reference_step ) GT 1.
          DATA ls_ref_step TYPE ty_outtab_ref_step.
          ls_ref_step = CONV #( <ls_reference> ).
          CLEAR ls_outtab_reference_step.
          ls_outtab_reference_step-ref_step_number = ls_ref_step.
          APPEND ls_outtab_reference_step TO lt_outtab_ref_step.
        ENDIF.
      ENDLOOP.
      "Fill gt_step_data-reference_step (itab)
      gt_step_data[ lv_row ]-reference_step = lt_outtab_ref_step.


      MODIFY gt_outtab_step FROM ls_outtab_step INDEX lv_row.  "overwrites gt_outtab_step-step_number with initial value
    ENDLOOP.

    "Modify GT_OUTTAB_STEP
    LOOP AT gt_outtab_step ASSIGNING FIELD-SYMBOL(<ls_outtab_step>).

      "Set step_number
      <ls_outtab_step>-step_number = sy-tabix.    "was already done in the beginning of the form but overwritten in MODIFY


      "Field VARIANT
      CLEAR ls_handle_style.
      ls_handle_style-fieldname = 'VARIANT'.
      IF <ls_outtab_step>-json_file IS INITIAL   OR ( <ls_outtab_step>-bus_obj EQ 'MATDOC' AND <ls_outtab_step>-action EQ 'CHECK' ).
        ls_handle_style-style     = cl_gui_alv_grid=>mc_style_enabled.
      ELSE.
        ls_handle_style-style     = cl_gui_alv_grid=>mc_style_disabled.
      ENDIF.

      INSERT ls_handle_style INTO TABLE <ls_outtab_step>-handle_style.

      "Field TEST_DATA_CONTAINER
      CLEAR ls_handle_style.
      ls_handle_style-fieldname = 'TEST_DATA_CONTAINER'.
      IF <ls_outtab_step>-json_file IS INITIAL   OR ( <ls_outtab_step>-bus_obj EQ 'MATDOC' AND <ls_outtab_step>-action EQ 'CHECK' ).
        ls_handle_style-style     = cl_gui_alv_grid=>mc_style_enabled.
      ELSE.
        ls_handle_style-style     = cl_gui_alv_grid=>mc_style_disabled.
      ENDIF.
      INSERT ls_handle_style INTO TABLE <ls_outtab_step>-handle_style.
*      "temp Dec 2022 - Column TEST_DATA_CONTAINER always enabled
*      CLEAR ls_handle_style.
*      ls_handle_style-fieldname = 'TEST_DATA_CONTAINER'.
*      ls_handle_style-style     = cl_gui_alv_grid=>mc_style_enabled.
*      INSERT ls_handle_style INTO TABLE <ls_outtab_step>-handle_style.

      "Field JSON_FILE_MORE
      CLEAR ls_handle_style.
      ls_handle_style-fieldname = 'JSON_FILE_MORE'.

      DATA(lo_ptf_rap_metadata) = NEW cl_ptf_rap_metadata( ).
      DATA(lv_is_rap_bo) = lo_ptf_rap_metadata->check_rap_bo( iv_bus_obj = <ls_outtab_step>-bus_obj ).
      IF lv_is_rap_bo = abap_off     AND  NOT ( <ls_outtab_step>-bus_obj EQ 'MATDOC' AND <ls_outtab_step>-action EQ 'CHECK' ).
*        ls_handle_style-style2 = cl_gui_alv_grid=>mc_style_disabled.
      ELSE.
        ls_handle_style-style     = cl_gui_alv_grid=>mc_style_button.
      ENDIF.
      INSERT ls_handle_style INTO TABLE <ls_outtab_step>-handle_style.

    ENDLOOP.

  ENDIF.

  PERFORM update_step_data CHANGING gt_step_data.  "does not use gt_variant_tab

ENDFORM.

FORM delete_variant.

  DATA(lo_client) = NEW cl_ptf_client( ).

  IF NOT go_variant->is_maintnce_here_allowed_for( gs_varhead-varname ).
    "Deletion of scripts (non Z) is only allowed in Home dev clients
    MESSAGE ID 'PTF' TYPE 'S' NUMBER 068 DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  IF gs_varhead IS INITIAL.
    MESSAGE ID 'PTF' TYPE 'S' NUMBER 039 DISPLAY LIKE 'W'.
    RETURN.
  ENDIF.
  IF gs_varhead-ernam NE sy-uname AND gs_varhead-user_specific = abap_true.
    MESSAGE ID 'PTF' TYPE 'S' NUMBER 021 DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  "Veto if not in source system
  IF NOT lo_client->is_variant_from_this_system( gs_varhead-varname ).
    SELECT SINGLE src_system FROM ptf_varid INTO @DATA(lv_src_system) WHERE varname = @gs_varhead-varname.
    "You can only delete this variant in Original System &1.
    MESSAGE ID 'PTF' TYPE 'S' NUMBER 061 WITH lv_src_system DISPLAY LIKE 'E'.    "TYPE 'E' NUMBER 061 would end the processing - without calling PBO
    RETURN.
  ENDIF.

  DATA lv_answer TYPE string.
  CONCATENATE 'Do you really want to delete' gs_varhead-varname '?' INTO DATA(lv_message) SEPARATED BY space.
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      text_question         = lv_message
      text_button_1         = 'Yes'
      text_button_2         = 'No'
      default_button        = '1'
      display_cancel_button = ''
    IMPORTING
      answer                = lv_answer.

  IF lv_answer = 1.     "Yes
    "Delete the variant
    FREE go_variant.
    CREATE OBJECT go_variant.
    go_variant->delete( iv_varname = gs_varhead-varname ).
    PERFORM get_transport USING gs_varhead-varname 'D'.  "also does the COMMIT

    PERFORM refresh_stepdata.
    CLEAR gt_text_table.
    CLEAR gs_varhead. "clears also just_loaded_from_file
    CLEAR gv_script_was_changed.
    cl_gui_cfw=>set_new_ok_code( new_code = 'REFR' ).
  ENDIF.

ENDFORM.

FORM create_the_create_popup_6001.

  DATA lt_exclude TYPE TABLE OF rsexfcode.
  CALL FUNCTION 'RS_SET_SELSCREEN_STATUS'
    EXPORTING
      p_status  = 'SAVE_STATUS'
      p_program = sy-repid
    TABLES
      p_exclude = lt_exclude.

  "save dialog (to enter name, description, etc.)
  "fills p_vaname, p_descr, p_user_s, p_scpitm, gt_ptf_var_tags
  "gt_text_table might actually be filled before as we intentionally not clear it, and can be changed in the popup
  CALL SCREEN 6001 STARTING AT 10 10.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form CREATE_UPDATE_POPUP
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_the_update_popup_7001.

  DATA lt_exclude TYPE TABLE OF rsexfcode.
  CALL FUNCTION 'RS_SET_SELSCREEN_STATUS'
    EXPORTING
      p_status  = 'SAVE_STATUS'
      p_program = sy-repid
    TABLES
      p_exclude = lt_exclude.

  CALL SCREEN 7001 STARTING AT 10 10.      "can change P_VNAME2, P_DESCR2, P_USER, P_SCPITM2, gt_text_table, gt_ptf_var_tags
*  CALL SELECTION-SCREEN '4001' STARTING AT 10 10.

ENDFORM.

FORM create_displ_properties_popup.
  "get_data_for_screen_7001.
  "Prepare data for Properties Popup

  p_vname2  = gs_varhead-varname.
  p_descr2  = gs_varhead-vardescr.
  p_user    = gs_varhead-user_specific.
  p_scpitm2 = gs_varhead-scope_item.

  "tags: read from DB
  IF gs_varhead-just_loaded_from_file EQ abap_false.
    CLEAR gt_ptf_var_tags.
    gt_ptf_var_tags = cl_ptf_variant_tag_manager=>get_tags_for_variant_and_user(
      EXPORTING
        user    = sy-uname
        variant = gs_varhead-varname
    ).
  ENDIF.

  "texts
  "gt_text_table is already up to date

  CALL SCREEN 7001 STARTING AT 10 10.

ENDFORM.

FORM prepare_variant_tab.
* view to model
* called before a variant shall be persisted
* builds gt_variant_tab, reads from gt_outtab_step and gt_step_data-reference_step(itab)
* also updates gt_step_data-reference_step (itab) if empty, from Field refStep. (needed?)

  FIELD-SYMBOLS <ls_step_data>  TYPE cl_ptf_util=>gt_ptf_step.

  DATA ls_variant TYPE cl_ptf_variant=>gty_step_data.

  CLEAR gt_variant_tab.

  LOOP AT gt_outtab_step ASSIGNING FIELD-SYMBOL(<ls_outtab>).
    CHECK <ls_outtab>-bus_obj IS NOT INITIAL AND <ls_outtab>-action IS NOT INITIAL. "if SAVE of scripts with an initial step before a filled steps were allowed, this CHECK, ignorign empty lines, would mess up the reference step numbers
    CLEAR ls_variant.

* Main
    ls_variant-bus_obj             = <ls_outtab>-bus_obj.
    ls_variant-action              = <ls_outtab>-action.
    ls_variant-variant             = <ls_outtab>-variant.
    ls_variant-test_data_container = <ls_outtab>-test_data_container.
    ls_variant-input_string        = <ls_outtab>-json_file.
    ls_variant-exp_messages        = <ls_outtab>-exp_messages. "itab

* Fill component for Reference Steps
    "component reference_step (itab) is not available in gt_outtab_step, take it from gt_step_data. Consider also the field reference_step in gt_outtab_step
    READ TABLE gt_step_data ASSIGNING <ls_step_data> INDEX sy-tabix.
    IF <ls_step_data>-reference_step IS INITIAL.
*      IF NOT line_exists( ls_variant-reference_step[ <ls_outtab>-reference_step ] ).
      APPEND <ls_outtab>-reference_step TO <ls_step_data>-reference_step. "field to itab => itab always has a record after that
    ENDIF.
    ls_variant-reference_step = <ls_step_data>-reference_step. "itab


    APPEND ls_variant TO gt_variant_tab.
*    DELETE ADJACENT DUPLICATES FROM  ls_variant-reference_step COMPARING table_line.
  ENDLOOP.

ENDFORM.

FORM update_step_data CHANGING it_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.   "updates gt_step_data, reading gt_outtab_step (and gt_step_data itself, especially gt_step_data-reference_step (itab) is read)

* gt_step_data:
* fills the components known before execution:
*  bus_obj, action, variant, step_number, test_data_container (from gt_outtab_step)
*  and component itab 'reference_step': if not already filled, take the single reference from field gt_outtab_step-reference_step if filled

  DATA ls_step_data TYPE cl_ptf_util=>gt_ptf_step.
*  FIELD-SYMBOLS <ls_step_data>  TYPE cl_ptf_util=>gt_ptf_step.  "could make the form simpler

  DATA(lv_lines_step_data) = lines( gt_step_data ).
  DATA(lv_lines_outtab)    = lines( gt_outtab_step ).
  IF lv_lines_step_data GE lv_lines_outtab.
    DO lv_lines_step_data - lv_lines_outtab TIMES.
      DELETE gt_step_data INDEX lv_lines_step_data.
      lv_lines_step_data = lv_lines_step_data - 1.
    ENDDO.
  ELSE.
    "fill gt_step_data with empty lines up to the length of gt_outtab_step
    DO lv_lines_outtab - lv_lines_step_data TIMES.
      APPEND INITIAL LINE TO gt_step_data.
    ENDDO.
  ENDIF.

  "not taken over (and therefor cleared in gt_step_data) are:
  " execution_status
  " check_status
  " act_messages
  " check_flag     "rethink this. ok if filled again before every run
  " is_pid         "ok as only set and read during a run
  " document_id  except if set manually
  " log

  LOOP AT gt_outtab_step ASSIGNING FIELD-SYMBOL(<ls_outtab>).
    CLEAR ls_step_data.
    "persisted fields
    ls_step_data-bus_obj              = <ls_outtab>-bus_obj.
    ls_step_data-action               = <ls_outtab>-action.
    ls_step_data-variant              = <ls_outtab>-variant.
    ls_step_data-step_number          = <ls_outtab>-step_number.
    ls_step_data-test_data_container  = <ls_outtab>-test_data_container.
    ls_step_data-json_file            = <ls_outtab>-json_file.
    ls_step_data-exp_messages         = <ls_outtab>-exp_messages.
    "transient fields
    ls_step_data-data_object_json     = gt_step_data[ <ls_outtab>-step_number ]-data_object_json.  "preserve TDO filled by RETRIEVE and RETRIEVE_ALL
    ls_step_data-is_manual            = <ls_outtab>-is_manual.
    IF <ls_outtab>-is_manual EQ abap_true.
      ls_step_data-document_id          = gt_step_data[ <ls_outtab>-step_number ]-document_id. "preserve document ids if set manually
    ENDIF.

    "Fill itab ls_step_data-reference_step
    IF  ls_step_data-bus_obj IS INITIAL
    AND ls_step_data-action  IS INITIAL
    AND ls_step_data-variant IS INITIAL.
      CLEAR ls_step_data-reference_step.
    ELSE.
      IF gt_step_data[ <ls_outtab>-step_number ]-reference_step IS NOT INITIAL.
        "keep the itab
        ls_step_data-reference_step = gt_step_data[ <ls_outtab>-step_number ]-reference_step.
      ELSEIF <ls_outtab>-reference_step IS NOT INITIAL.
        "gt_step_data-reference_step has no records. And there is a value <> 000 in field <ls_outtab>-reference_step, take this.
        INSERT <ls_outtab>-reference_step INTO ls_step_data-reference_step INDEX 1.  "insert field into itab, before first line  [itab is empty here anyway]
      ENDIF.
    ENDIF.

    TRY.
        MODIFY gt_step_data FROM ls_step_data INDEX sy-tabix.
      CATCH cx_root.
    ENDTRY.
  ENDLOOP.

ENDFORM.


FORM was_script_changed CHANGING cv_return TYPE abap_bool.

  "this form might buffer the result.
  "script is seen as changed forever in this session, if it has been found changed once. reason: performance.
  "a comparison is only done if the script has never been found changed.

  CLEAR cv_return.

  IF gv_script_was_changed EQ abap_true.
    cv_return = abap_true.
  ELSE.
    PERFORM was_script_changed__analyze CHANGING gv_script_was_changed.
    IF gv_script_was_changed EQ abap_true.
      cv_return = abap_true.
    ENDIF.
  ENDIF.

ENDFORM.

FORM was_script_changed__analyze CHANGING cv_return TYPE abap_bool.

  "evaluate whether script was changed - if in doubt, answer true ("changed"), as this controls whether an AreYouSure popup comes

  CLEAR cv_return.

  IF gs_varhead-varname IS INITIAL.
    "not saved yet => handle as 'changed'
    cv_return = abap_true.
    RETURN.
  ENDIF.

  SELECT SINGLE * FROM ptf_varid INTO @DATA(ls_varid_dummy) WHERE varname = @gs_varhead-varname.
  IF sy-subrc IS NOT INITIAL.
    "transient. not yet saved under this name.   "but varname is filled, might happen after file upload
    cv_return = abap_true.
    RETURN.
  ENDIF.

  "update gt_variant_tab
  PERFORM prepare_variant_tab.

  DATA(lo_variant_temp) = NEW cl_ptf_variant( ).  "instance attributes are changed by method READ, so do not use the common instance of cl_ptf_variant !
  lo_variant_temp->read(
    EXPORTING
      iv_varname     = gs_varhead-varname
    IMPORTING
      et_variant_tab = DATA(db_variant_tab)
      et_varcat      = DATA(db_text_table)
      et_vardataset  = DATA(db_vardataset)
  ).
  LOOP AT db_variant_tab ASSIGNING FIELD-SYMBOL(<ls_db_step>).
    IF <ls_db_step>-reference_step IS INITIAL.
      APPEND 0 TO <ls_db_step>-reference_step.
    ENDIF.
  ENDLOOP.

  IF   gt_variant_tab  <> db_variant_tab
    OR gt_text_table <> db_text_table
    OR gt_outtab_vardataset <> db_vardataset.
    "yes, there is a difference
    cv_return = abap_true.
  ENDIF.

ENDFORM.


FORM get_transport
  USING uv_varname TYPE ptf_varname
        uv_action  TYPE char1.

  DATA: lt_ko200  TYPE TABLE OF ko200,
        ls_ko200  TYPE ko200,
        lt_e071k  TYPE TABLE OF e071k,
        ls_e071k  TYPE e071k,
        gv_trkorr TYPE trkorr.

  DATA(lo_client) = NEW cl_ptf_client( ).

  IF NOT go_variant->is_maintnce_here_allowed_for( uv_varname ).   "temp check
    CHECK 1 = 1. "should never happen
  ENDIF.

  IF go_variant->is_in_customer_namespace( iv_varname = uv_varname )          "if this form is called, not z-script AND not homedevclient should never occur.
    OR lo_client->is_blocklisted_against_tr( ).
    "Varname in customer namespace: Do not transport
    COMMIT WORK AND WAIT.
    PERFORM success_message USING uv_varname uv_action.
    RETURN.
  ENDIF.

  "Varname in SAP namespace -> CR
  go_variant->go_transport->get_transport_entries(
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
        wi_order                = gv_trkorr
      IMPORTING
        we_order                = gv_trkorr
      TABLES
        wt_ko200                = lt_ko200
        wt_e071k                = lt_e071k
      EXCEPTIONS
        cancel_edit_other_error = 1
        show_only_other_error   = 2
        OTHERS                  = 3.
    IF sy-subrc EQ 0.
      COMMIT WORK AND WAIT.
      PERFORM success_message USING uv_varname uv_action.
    ELSE.
      ROLLBACK WORK.
      CLEAR gs_varhead.
      MESSAGE ID 'PTF' TYPE 'S' NUMBER 034 DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.

  go_variant->go_transport->delete_transport_entries( ).

ENDFORM.


FORM success_message
  USING uv_varname TYPE ptf_varname
        uv_action  TYPE char1.

  CASE uv_action.
    WHEN 'S'.
      MESSAGE ID 'PTF' TYPE 'S' NUMBER 019 WITH uv_varname.
    WHEN 'U'.
      MESSAGE ID 'PTF' TYPE 'S' NUMBER 026 WITH uv_varname.
    WHEN 'D'.
      MESSAGE ID 'PTF' TYPE 'S' NUMBER 022 WITH uv_varname.
  ENDCASE.

ENDFORM.
