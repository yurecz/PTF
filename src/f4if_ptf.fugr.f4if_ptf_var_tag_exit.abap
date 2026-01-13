FUNCTION f4if_ptf_var_tag_exit.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  TABLES
*"      SHLP_TAB TYPE  SHLP_DESCT
*"      RECORD_TAB STRUCTURE  SEAHLPRES
*"  CHANGING
*"     REFERENCE(SHLP) TYPE  SHLP_DESCR
*"     REFERENCE(CALLCONTROL) TYPE  DDSHF4CTRL
*"----------------------------------------------------------------------
  TYPES: BEGIN OF ty_searchhelp_data,
           tag  TYPE ptf_variant_tag,
           text TYPE    ptf_variant_tag_text,
         END OF ty_searchhelp_data.

  DATA: results_tab        TYPE TABLE OF ty_searchhelp_data.

  IF callcontrol-step EQ 'DISP'.

    DATA(vtags) = cl_ptf_variant_tag_manager=>get_editable_tags_for_user(
      EXPORTING
        user     = sy-uname
        language = sy-langu
    ).

    MOVE-CORRESPONDING vtags to results_tab.
*
*    LOOP AT vtags ASSIGNING FIELD-SYMBOL(<vtag>).
*      APPEND <vtag>-tag TO results_tab.
*    ENDLOOP.

    CALL FUNCTION 'F4UT_PARAMETER_RESULTS_PUT'
      EXPORTING
        parameter         = 'TAG'
      TABLES
        shlp_tab          = shlp_tab
        record_tab        = record_tab
        source_tab        = results_tab
      CHANGING
        shlp              = shlp
        callcontrol       = callcontrol
      EXCEPTIONS
        parameter_unknown = 1
        OTHERS            = 2 ##FM_SUBRC_OK.

  ENDIF.

ENDFUNCTION.
