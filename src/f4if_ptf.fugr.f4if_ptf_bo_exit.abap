FUNCTION F4IF_PTF_BO_EXIT.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  TABLES
*"      SHLP_TAB TYPE  SHLP_DESCT
*"      RECORD_TAB STRUCTURE  SEAHLPRES
*"  CHANGING
*"     VALUE(SHLP) TYPE  SHLP_DESCR
*"     VALUE(CALLCONTROL) LIKE  DDSHF4CTRL STRUCTURE  DDSHF4CTRL
*"----------------------------------------------------------------------

* EXIT immediately, if you do not want to handle this step
  IF CALLCONTROL-STEP <> 'SELONE' AND
     CALLCONTROL-STEP <> 'SELECT' AND
     " AND SO ON
     CALLCONTROL-STEP <> 'DISP'.
     EXIT.
  ENDIF.

*"----------------------------------------------------------------------
* STEP SELONE  (Select one of the elementary searchhelps)
*"----------------------------------------------------------------------
* This step is only called for collective searchhelps. It may be used
* to reduce the amount of elementary searchhelps given in SHLP_TAB.
* The compound searchhelp is given in SHLP.
* If you do not change CALLCONTROL-STEP, the next step is the
* dialog, to select one of the elementary searchhelps.
* If you want to skip this dialog, you have to return the selected
* elementary searchhelp in SHLP and to change CALLCONTROL-STEP to
* either to 'PRESEL' or to 'SELECT'.
  IF CALLCONTROL-STEP = 'SELONE'.
*   PERFORM SELONE .........
    EXIT.
  ENDIF.

*"----------------------------------------------------------------------
* STEP PRESEL  (Enter selection conditions)
*"----------------------------------------------------------------------
* This step allows you, to influence the selection conditions either
* before they are displayed or in order to skip the dialog completely.
* If you want to skip the dialog, you should change CALLCONTROL-STEP
* to 'SELECT'.
* Normaly only SHLP-SELOPT should be changed in this step.
  IF CALLCONTROL-STEP = 'PRESEL'.
*   PERFORM PRESEL ..........
    EXIT.
  ENDIF.
*"----------------------------------------------------------------------
* STEP SELECT    (Select values)
*"----------------------------------------------------------------------
* This step may be used to overtake the data selection completely.
* To skip the standard seletion, you should return 'DISP' as following
* step in CALLCONTROL-STEP.
* Normally RECORD_TAB should be filled after this step.
* Standard function module F4UT_RESULTS_MAP may be very helpfull in this
* step.
  IF CALLCONTROL-STEP = 'SELECT'.
*   PERFORM STEP_SELECT TABLES RECORD_TAB SHLP_TAB
*                       CHANGING SHLP CALLCONTROL RC.
*   IF RC = 0.
*     CALLCONTROL-STEP = 'DISP'.
*   ELSE.
*     CALLCONTROL-STEP = 'EXIT'.
*   ENDIF.
    EXIT. "Don't process STEP DISP additionally in this call.
  ENDIF.
*"----------------------------------------------------------------------
* STEP DISP     (Display values)
*"----------------------------------------------------------------------
* This step is called, before the selected data is displayed.
* You can e.g. modify or reduce the data in RECORD_TAB
* according to the users authority.
* If you want to get the standard display dialog afterwards, you
* should not change CALLCONTROL-STEP.
* If you want to overtake the dialog on you own, you must return
* the following values in CALLCONTROL-STEP:
* - "RETURN" if one line was selected. The selected line must be
*   the only record left in RECORD_TAB. The corresponding fields of
*   this line are entered into the screen.
* - "EXIT" if the values request should be aborted
* - "PRESEL" if you want to return to the selection dialog
* Standard function modules F4UT_PARAMETER_VALUE_GET and
* F4UT_PARAMETER_RESULTS_PUT may be very helpfull in this step.
  TYPES: BEGIN OF ts_ptf_bo,
          ptf_bo    TYPE ptf_bo,
         END OF ts_ptf_bo,
         BEGIN OF ts_vtext,
          vtext     TYPE ptf_text60_cs,
         END OF ts_vtext,
         ts_ptfbo   TYPE ptfbo.

  TYPES: tt_ptf_bo  TYPE STANDARD TABLE OF ts_ptf_bo,
         tt_vtext   TYPE STANDARD TABLE OF ts_vtext,
         tt_ptfbo   TYPE STANDARD TABLE OF ts_ptfbo.

  DATA: lt_ptf_bo   TYPE tt_ptf_bo,
        lt_vtext    TYPE tt_vtext,
        lt_ptfbo    TYPE tt_ptfbo.

  CONSTANTS: lc_ptf_bo  TYPE shlpfield VALUE 'PTF_BO',
             lc_vtext   TYPE shlpfield VALUE 'VTEXT'.

  IF CALLCONTROL-STEP = 'DISP'.
*   PERFORM AUTHORITY_CHECK TABLES RECORD_TAB SHLP_TAB
*                           CHANGING SHLP CALLCONTROL.
*   enhance results with english results
    IF NOT record_tab[] IS INITIAL.
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

      LOOP AT lt_ptf_bo ASSIGNING FIELD-SYMBOL(<fs_ptf_bo>).
        APPEND VALUE ts_ptfbo( ptf_bo = <fs_ptf_bo> ) TO lt_ptfbo.

      ENDLOOP.

      IF lt_ptfbo IS NOT INITIAL.
        SELECT *
          FROM ptfbot
          INTO TABLE @DATA(lt_ptfbot)
           FOR ALL ENTRIES IN @lt_ptfbo
         WHERE ptfbot~ptf_bo = @lt_ptfbo-ptf_bo
           AND ptfbot~spras = 'E'.
        IF sy-subrc = 0.
          LOOP AT lt_ptfbo ASSIGNING FIELD-SYMBOL(<fs_ptfbo>).
            IF line_exists( lt_ptfbot[ ptf_bo = <fs_ptfbo>-ptf_bo ] ).
              APPEND VALUE #( vtext = lt_ptfbot[ ptf_bo = <fs_ptfbo>-ptf_bo ]-vtext ) TO lt_vtext.

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

      SORT record_tab.

    ENDIF.

  ENDIF.

ENDFUNCTION.
