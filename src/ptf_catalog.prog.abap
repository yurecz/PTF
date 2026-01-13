*&---------------------------------------------------------------------*
*& Include          PTF_CATALOG
*&---------------------------------------------------------------------*

TYPES: BEGIN OF gty_ptf_catalog.
         INCLUDE STRUCTURE ptf_catalog.
TYPES:   step_number TYPE n LENGTH 3. "numc3.
TYPES:   cellcolor TYPE lvc_t_scol.
TYPES: END OF gty_ptf_catalog.

DATA it_excluding TYPE slis_t_extab.
DATA gs_ptf_varcat TYPE gty_ptf_catalog.

************************************************************************
*  F O R M S   (Catalog)
************************************************************************

FORM get_catalog.

  DATA gd_layout TYPE slis_layout_alv.

  DATA gt_ptf_varcat TYPE STANDARD TABLE OF gty_ptf_catalog WITH KEY varname.
  DATA gt_ptf_varcat_res TYPE STANDARD TABLE OF gty_ptf_catalog.
  DATA gt_ptf_varcat_tmp TYPE STANDARD TABLE OF gty_ptf_catalog.
  DATA gt_ptf_output TYPE STANDARD TABLE OF gty_ptf_catalog.
  DATA gs_res TYPE gty_ptf_catalog.
  DATA wa_cellcolor TYPE lvc_s_scol.

  wa_cellcolor-color-col = '7' . "color code 1-7, if outside rage defaults to 7
  wa_cellcolor-color-int = '0'.  "1 = Intensified on, 0 = Intensified off
  wa_cellcolor-color-inv = '0'.  "1

  gd_layout-coltab_fieldname = 'cellcolor'.

  SELECT varname vtext FROM ptf_varid_t INTO CORRESPONDING FIELDS OF TABLE gt_ptf_varcat. "#EC CI_NOWHERE.
  SELECT varname text step_number FROM ptf_varcat INTO CORRESPONDING FIELDS OF TABLE gt_ptf_varcat_tmp. "#EC CI_NOWHERE.

  SORT gt_ptf_varcat_tmp BY varname step_number ASCENDING.
  SORT gt_ptf_varcat BY varname  ASCENDING.
  LOOP AT gt_ptf_varcat ASSIGNING FIELD-SYMBOL(<ls_variantcat>).
    gs_ptf_varcat = <ls_variantcat>.
    IF line_exists( gt_ptf_varcat_tmp[ varname = <ls_variantcat>-varname ] ).
      TRY.
          LOOP AT gt_ptf_varcat_tmp ASSIGNING FIELD-SYMBOL(<ls_varcat_tmp>).
            IF <ls_varcat_tmp>-varname = <ls_variantcat>-varname.
              IF <ls_varcat_tmp>-step_number = 001.
                gs_ptf_varcat-text = <ls_varcat_tmp>-text.
                PERFORM translation.
                APPEND gs_ptf_varcat TO gt_ptf_varcat_res.
              ELSE.
                gd_layout-no_hline = 'X'.
                CLEAR gs_ptf_varcat.
                gs_ptf_varcat-text = <ls_varcat_tmp>-text.
                PERFORM translation.
                APPEND gs_ptf_varcat TO gt_ptf_varcat_res.
              ENDIF.
            ENDIF.
          ENDLOOP.
          APPEND wa_cellcolor TO gs_res-cellcolor.
          APPEND gs_res TO gt_ptf_varcat_res.
        CATCH cx_root.
      ENDTRY.
    ELSE.
      APPEND gs_ptf_varcat TO gt_ptf_varcat_res.
      APPEND wa_cellcolor TO gs_res-cellcolor.
      APPEND gs_res TO gt_ptf_varcat_res.
    ENDIF.
  ENDLOOP.


  MOVE-CORRESPONDING gt_ptf_varcat_res TO gt_ptf_output.
  PERFORM exclude_icons.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program    = 'sy-repid'
      i_structure_name      = 'PTF_CATALOG'
      i_grid_title          = 'Variant Catalog'
      is_layout             = gd_layout
      it_excluding          = it_excluding
      i_screen_start_column = 5
      i_screen_start_line   = 5
      i_screen_end_column   = 130
      i_screen_end_line     = 70
    TABLES
      t_outtab              = gt_ptf_output.

ENDFORM.

FORM translation.
  TRANSLATE  gs_ptf_varcat-text    TO LOWER CASE.
  TRANSLATE  gs_ptf_varcat-varname TO UPPER CASE.
  TRANSLATE  gs_ptf_varcat-vtext   TO LOWER CASE.
ENDFORM.

FORM exclude_icons.
  APPEND '&ODN' TO it_excluding.   "Ascending
  APPEND '&OUP' TO it_excluding.   "Decending
  APPEND '&RNT' TO it_excluding.   "Print menu
ENDFORM.
