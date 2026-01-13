FUNCTION F4IF_PTF_ACTION_EXIT.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  TABLES
*"      SHLP_TAB TYPE  SHLP_DESCT
*"      RECORD_TAB STRUCTURE  SEAHLPRES
*"  CHANGING
*"     REFERENCE(SHLP) TYPE  SHLP_DESCR
*"     REFERENCE(CALLCONTROL) TYPE  DDSHF4CTRL
*"----------------------------------------------------------------------
  CONSTANTS: c_api_param      TYPE char30 VALUE 'PTF_API_ACTION',
             c_api_desc_param TYPE char30 VALUE 'PTF_API_ACTION_DESC'.

  TYPES: BEGIN OF ty_lookup_table,
           domain_value TYPE ptf_api_action_desc,
         END OF ty_lookup_table.

  DATA: results_tab        TYPE TABLE OF ptf_api_action,
        domain_values      TYPE TABLE OF  dd07v,
        additional_columns TYPE STANDARD TABLE OF ty_lookup_table WITH DEFAULT KEY.

  CALL FUNCTION 'F4UT_PARAMETER_VALUE_GET'
    EXPORTING
      parameter         = c_api_param
    TABLES
      shlp_tab          = shlp_tab
      record_tab        = record_tab
      results_tab       = results_tab
    CHANGING
      shlp              = shlp
      callcontrol       = callcontrol
    EXCEPTIONS
      parameter_unknown = 1
      OTHERS            = 2 ##FM_SUBRC_OK.

  IF results_tab IS NOT INITIAL.
    CALL FUNCTION 'DD_DOMVALUES_GET'
      EXPORTING
        domname        = c_api_param
        text           = 'X'
      TABLES
        dd07v_tab      = domain_values
      EXCEPTIONS
        wrong_textflag = 1
        OTHERS         = 2 ##FM_SUBRC_OK.
  ENDIF.

  LOOP AT results_tab ASSIGNING FIELD-SYMBOL(<ptf_api_action>).
    READ TABLE domain_values WITH KEY domvalue_l = <ptf_api_action> INTO DATA(domain_value).
    APPEND VALUE ty_lookup_table( domain_value = |{ domain_value-ddtext }| ) TO additional_columns.
  ENDLOOP.

  IF additional_columns IS NOT INITIAL.

    CALL FUNCTION 'F4UT_PARAMETER_RESULTS_PUT'
      EXPORTING
        parameter         = c_api_desc_param
      TABLES
        shlp_tab          = shlp_tab
        record_tab        = record_tab
        source_tab        = additional_columns
      CHANGING
        shlp              = shlp
        callcontrol       = callcontrol
      EXCEPTIONS
        parameter_unknown = 1
        OTHERS            = 2 ##FM_SUBRC_OK.

  ENDIF.

  TYPES: BEGIN OF ts_ptf_bo,
          ptf_bo  TYPE ptf_bo,
         END OF ts_ptf_bo,
         BEGIN OF ts_ptf_act,
          ptf_act TYPE ptf_act,
         END OF ts_ptf_act,
         BEGIN OF ts_vtext,
          vtext TYPE ptf_text60_cs,
         END OF ts_vtext,
         ts_ptfboa TYPE ptfboa.

  TYPES: tt_ptf_bo  TYPE STANDARD TABLE OF ts_ptf_bo,
         tt_ptf_act TYPE STANDARD TABLE OF ts_ptf_act,
         tt_vtext   TYPE STANDARD TABLE OF ts_vtext,
         tt_ptfboa  TYPE STANDARD TABLE OF ts_ptfboa.

  DATA: lt_ptf_bo   TYPE tt_ptf_bo,
        lt_ptf_act  TYPE tt_ptf_act,
        lt_vtext    TYPE tt_vtext,
        lt_ptfboa   TYPE tt_ptfboa.

  CONSTANTS: lc_ptf_bo  TYPE shlpfield VALUE 'PTF_BO',
             lc_ptf_act TYPE shlpfield VALUE 'PTF_ACT',
             lc_vtext   TYPE shlpfield VALUE 'VTEXT'.

  IF callcontrol-step = 'DISP'.
    CALL FUNCTION 'F4UT_PARAMETER_VALUE_GET'
      EXPORTING
        parameter         = lc_ptf_bo
      TABLES
        shlp_tab          = shlp_tab
        record_tab        = record_tab
        results_tab       = lt_ptf_bo
      CHANGING
        shlp              = shlp
        callcontrol       = callcontrol
      EXCEPTIONS
        parameter_unknown = 1
        OTHERS            = 2 ##FM_SUBRC_OK.

    CALL FUNCTION 'F4UT_PARAMETER_VALUE_GET'
      EXPORTING
        parameter         = lc_ptf_act
      TABLES
        shlp_tab          = shlp_tab
        record_tab        = record_tab
        results_tab       = lt_ptf_act
      CHANGING
        shlp              = shlp
        callcontrol       = callcontrol
      EXCEPTIONS
        parameter_unknown = 1
        OTHERS            = 2 ##FM_SUBRC_OK.

    LOOP AT lt_ptf_bo ASSIGNING FIELD-SYMBOL(<fs_ptf_bo>).
      ASSIGN lt_ptf_act[ sy-tabix ] TO FIELD-SYMBOL(<fs_ptf_act>).
      IF sy-subrc = 0.
        APPEND VALUE ptfboa( ptf_bo = <fs_ptf_bo> ptf_act = <fs_ptf_act> ) TO lt_ptfboa.

      ENDIF.

    ENDLOOP.

    IF lt_ptfboa IS NOT INITIAL.
      SELECT *
        FROM ptfboat
        INTO TABLE @DATA(lt_ptfboat)
         FOR ALL ENTRIES IN @lt_ptfboa
       WHERE ptfboat~ptf_bo = @lt_ptfboa-ptf_bo
         AND ptfboat~ptf_act = @lt_ptfboa-ptf_act
         AND ptfboat~spras = 'E'.
      IF sy-subrc = 0.
        LOOP AT lt_ptfboa ASSIGNING FIELD-SYMBOL(<fs_ptfboa>).
          IF line_exists( lt_ptfboat[ ptf_bo = <fs_ptfboa>-ptf_bo ptf_act = <fs_ptfboa>-ptf_act ] ).
            APPEND VALUE #( vtext = lt_ptfboat[ ptf_bo = <fs_ptfboa>-ptf_bo ptf_act = <fs_ptfboa>-ptf_act ]-vtext ) TO lt_vtext.

          ELSE.
            APPEND VALUE #( vtext = space ) TO lt_vtext.

          ENDIF.

        ENDLOOP.

        CALL FUNCTION 'F4UT_PARAMETER_RESULTS_PUT'
          EXPORTING
            parameter         = lc_vtext
          TABLES
            shlp_tab          = shlp_tab
            record_tab        = record_tab
            source_tab        = lt_vtext
          CHANGING
            shlp              = shlp
            callcontrol       = callcontrol
          EXCEPTIONS
            parameter_unknown = 1
            OTHERS            = 2 ##FM_SUBRC_OK.

      ENDIF.

    ENDIF.

  ENDIF.

ENDFUNCTION.
