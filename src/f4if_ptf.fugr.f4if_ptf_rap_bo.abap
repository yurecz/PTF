FUNCTION f4if_ptf_rap_bo.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  TABLES
*"      SHLP_TAB TYPE  SHLP_DESCT
*"      RECORD_TAB STRUCTURE  SEAHLPRES
*"  CHANGING
*"     VALUE(SHLP) TYPE  SHLP_DESCR
*"     VALUE(CALLCONTROL) LIKE  DDSHF4CTRL STRUCTURE  DDSHF4CTRL
*"----------------------------------------------------------------------

  DATA: lt_obj_name_r TYPE RANGE OF tadir-obj_name,
        lv_string     TYPE seahlpres-string,
        lv_offset     TYPE i.

* EXIT immediately, if you do not want to handle this step
  IF callcontrol-step <> 'SELONE' AND
     callcontrol-step <> 'SELECT' AND
     " AND SO ON
     callcontrol-step <> 'DISP'.

    IF callcontrol-step ='RETURN'.
      READ TABLE record_tab INDEX 1 ASSIGNING FIELD-SYMBOL(<record>).
      IF sy-subrc = 0.

        TRANSLATE <record>-string TO UPPER CASE.

      ENDIF.
    ENDIF.

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
  IF callcontrol-step = 'SELONE'.
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
  IF callcontrol-step = 'PRESEL'.
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
  IF callcontrol-step = 'SELECT'.
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
  IF callcontrol-step = 'DISP'.
*   PERFORM AUTHORITY_CHECK TABLES RECORD_TAB SHLP_TAB
*                           CHANGING SHLP CALLCONTROL.

    LOOP AT shlp-selopt ASSIGNING FIELD-SYMBOL(<fs_selopt>) WHERE shlpfield = 'PTF_BO'.
      APPEND VALUE #( sign = <fs_selopt>-sign option = <fs_selopt>-option low = <fs_selopt>-low high = <fs_selopt>-high )
        TO lt_obj_name_r.

    ENDLOOP.

    SELECT tadir~obj_name
      INTO TABLE @DATA(lt_tadir)
      FROM tadir
        UP TO @callcontrol-maxrecords ROWS
     WHERE tadir~pgmid = 'R3TR'
       AND tadir~object = 'BDEF'
       AND tadir~obj_name IN @lt_obj_name_r
     ORDER BY tadir~obj_name.             "#EC CI_BYPASS #EC CI_GENBUFF
    IF sy-subrc = 0.
      LOOP AT lt_tadir ASSIGNING FIELD-SYMBOL(<fs_tadir>).
        CLEAR: lv_string, lv_offset.

        LOOP AT shlp-fielddescr ASSIGNING FIELD-SYMBOL(<fs_fielddescr>).
          CASE <fs_fielddescr>-fieldname.
            WHEN 'PTF_BO'.
              lv_string+lv_offset(<fs_fielddescr>-leng) = <fs_tadir>-obj_name.

            WHEN 'TEXT'.
              DATA(lv_name) = cl_bdef_name_service=>get_bd_include( <fs_tadir>-obj_name ).

              SELECT sprsl, text
                INTO TABLE @DATA(lt_trdirt)
                FROM trdirt
               WHERE name = @lv_name.                   "#EC CI_GENBUFF
              IF sy-subrc = 0.
                TRY.
                    DATA(ls_trdirt) = lt_trdirt[ sprsl = sy-langu ].

                  CATCH cx_sy_itab_line_not_found.
                    CLEAR: ls_trdirt.

                    TRY.
                        ls_trdirt = lt_trdirt[ sprsl = 'E' ].

                      CATCH cx_sy_itab_line_not_found.
                        CLEAR: ls_trdirt.

                        TRY.
                            ls_trdirt = lt_trdirt[ 1 ].

                          CATCH cx_sy_itab_line_not_found.
                            CLEAR: ls_trdirt.

                        ENDTRY.

                    ENDTRY.

                ENDTRY.

              ENDIF.

              lv_string+lv_offset(<fs_fielddescr>-leng) = ls_trdirt-text.

          ENDCASE.

          ADD <fs_fielddescr>-leng TO lv_offset. "offset is calculated based on internal length, not output length

        ENDLOOP.

        APPEND VALUE #( string = lv_string ) TO record_tab.

      ENDLOOP.

    ENDIF.

    EXIT.
  ENDIF.
ENDFUNCTION.
