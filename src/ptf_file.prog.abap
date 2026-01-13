*----------------------------------------------------------------------*
***INCLUDE PTF_FILE.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form download_script
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM download_script .

  DATA ls_attributes TYPE if_ptf_file=>ts_attributes.

  PERFORM update_step_data CHANGING gt_step_data.

  DATA(lo_error) = go_variant->check_syntax( gt_step_data ).
  IF lo_error IS BOUND.
    lo_error->raise_message( display_type = 'E' ).
    PERFORM set_focus_oo USING lo_error.
    RETURN.
  ENDIF.

*  DATA(lo_variant) = NEW cl_ptf_variant( ).
*  IF ( lo_variant->is_empty( it_step_data = gt_step_data ) EQ abap_true ).      Already checked (with generic message) in check_syntax( )
*    MESSAGE ID 'PTF' TYPE 'E' NUMBER 074.
*    RETURN.
*  ENDIF.


* Get data

  PERFORM prepare_variant_tab.   "build gt_variant_tab

  DATA(lt_tag_table) = cl_ptf_variant_tag_manager=>get_tags_for_variant_and_user(
                          EXPORTING
                            user    = sy-uname
                            variant = gs_varhead-varname
                          ).

  IF gs_varhead-varname IS NOT INITIAL
   AND gs_varhead-just_loaded_from_file EQ abap_false.
    SELECT SINGLE * FROM ptf_varid INTO @DATA(ls_varid) WHERE varname = @gs_varhead-varname.
    IF sy-subrc IS INITIAL.
      ls_attributes-script_language_version = ls_varid-script_language_version.
      ls_attributes-script_version          = ls_varid-script_version.
      ls_attributes-src_system              = ls_varid-src_system.
      ls_attributes-modif_system            = ls_varid-modif_system.
    ELSE.
      BREAK griesec.
    ENDIF.
  ENDIF.

  ls_attributes-varname          = gs_varhead-varname.
  ls_attributes-vardescr         = gs_varhead-vardescr.
  ls_attributes-erdat            = gs_varhead-erdat.
  ls_attributes-ernam            = gs_varhead-ernam.
  ls_attributes-user_specific    = gs_varhead-user_specific.
  ls_attributes-scope_item       = gs_varhead-scope_item.
  ls_attributes-last_change_date = gs_varhead-last_change_date.
  ls_attributes-last_change_user = gs_varhead-last_change_user.

  PERFORM was_script_changed CHANGING ls_attributes-transient_change.


* Download

  DATA(lo_ptf_file) = NEW cl_ptf_file( ).

  lo_ptf_file->if_ptf_file~download(
    is_attributes   = ls_attributes
    it_text_table   = gt_text_table
    it_tag_table    = lt_tag_table
    it_variant_data = gt_variant_tab
  ).

ENDFORM.

*&---------------------------------------------------------------------*
*& Form upload_script
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM upload_script .

  DATA(lo_ptf_file) = NEW cl_ptf_file( ).

  lo_ptf_file->if_ptf_file~upload(
    IMPORTING
      es_attributes   = DATA(ls_attributes)
      et_text_table   = DATA(lt_text_table)
      et_tag_table    = DATA(lt_ptf_var_tags)
      et_variant_tab  = DATA(lt_variant_tab)
      ev_error        = DATA(lv_error)  "if there is an error, does gs_varhead still have the old values?
      ev_error_text   = DATA(lv_error_text)
  ).

  IF lv_error IS INITIAL.
    CLEAR gt_variant_tab.
    CLEAR gs_varhead.
    CLEAR gt_text_table.
    CLEAR gv_script_was_changed.

    "Fill script attributes
    MOVE-CORRESPONDING ls_attributes TO gs_varhead.
    gt_variant_tab  = lt_variant_tab.
    gt_text_table   = lt_text_table.
    gt_ptf_var_tags = lt_ptf_var_tags.


    DATA(lo_variant) = NEW cl_ptf_variant( ).

    "Warn if the ID exists on DB
    IF gs_varhead-varname IS NOT INITIAL.
      IF lo_variant->check_existence( gs_varhead-varname ) EQ abap_true.
        gs_varhead-name_exists_on_db = abap_true.
        MESSAGE ID 'PTF' TYPE 'S' NUMBER 075 DISPLAY LIKE 'W'.
      ENDIF.
    ENDIF.

    PERFORM move_data_to_alv.
    CALL METHOD g_grid_step->refresh_table_display( ).

    gs_varhead-just_loaded_from_file = abap_true.

  ELSEIF lv_error IS NOT INITIAL AND lv_error_text IS NOT INITIAL.
    MESSAGE lv_error_text TYPE 'E'.
  ENDIF.

ENDFORM.
