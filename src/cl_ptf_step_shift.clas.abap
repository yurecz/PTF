class CL_PTF_STEP_SHIFT definition
  public
  final
  create public .

public section.

  interfaces IF_PTF_STEP_SHIFT .
protected section.
private section.

  methods SHIFT_STEP_IDS_IN_STRING
    importing
      !IV_ROW_NUMBER type INT4
      !IV_STEP_NUMBER type INT4
      !IV_OPERATION type IF_PTF_STEP_SHIFT=>TE_OPERATION
    changing
      !CV_JSON_FILE type STRING
      !CV_REFERENCE_SHIFTED type ABAP_BOOL .
ENDCLASS.



CLASS CL_PTF_STEP_SHIFT IMPLEMENTATION.


  METHOD if_ptf_step_shift~shift_step_ids_in_script.
    DATA: lv_row_number           TYPE i.

    CLEAR ev_reference_shifted.

    CASE iv_operation.
      WHEN if_ptf_step_shift=>insert.
        lv_row_number = iv_row_number.

      WHEN if_ptf_step_shift=>delete.
        lv_row_number = iv_row_number + 1.

    ENDCASE.

    LOOP AT ct_outtab_step ASSIGNING FIELD-SYMBOL(<fs_outtab_step>) FROM lv_row_number.
      me->shift_step_ids_in_string(
        EXPORTING
          iv_row_number         = iv_row_number
          iv_step_number        = <fs_outtab_step>-step_number
          iv_operation          = iv_operation
        CHANGING
          cv_json_file          = <fs_outtab_step>-json_file
          cv_reference_shifted  = ev_reference_shifted
      ).

    ENDLOOP.

  ENDMETHOD.


  METHOD if_ptf_step_shift~shift_step_ids_in_table.

    DATA: ls_outtab_step  TYPE cl_ptf_util=>ty_outtab,
          ls_handle_style TYPE lvc_s_styl,
          lv_tabix        TYPE i.


    IF iv_e_ucomm EQ 'DELETE_ROW'.

      DELETE ct_outtab_step INDEX iv_row_number.
      DELETE ct_step_data INDEX iv_row_number.

    ELSEIF iv_e_ucomm EQ 'INSERT_ROW'.
*    **toDo: extract following lines to a reuse object to be called from here and from Form refresh_stepdata.
*       ls_outtab_step-reference_document_id_more = icon_enter_more.
      ls_outtab_step-reference_step_more = icon_enter_more.
      ls_outtab_step-json_file_more      = icon_text_ina.

      CLEAR ls_handle_style.
      ls_handle_style-fieldname = 'VARIANT'.
      ls_handle_style-style     = cl_gui_alv_grid=>mc_style_enabled.
      INSERT ls_handle_style INTO TABLE ls_outtab_step-handle_style.

      CLEAR ls_handle_style.
      ls_handle_style-fieldname = 'TEST_DATA_CONTAINER'.
      ls_handle_style-style     = cl_gui_alv_grid=>mc_style_enabled.
      INSERT ls_handle_style INTO TABLE ls_outtab_step-handle_style.

      CLEAR ls_handle_style.
      ls_handle_style-fieldname = 'JSON_FILE_MORE'.
*         ls_handle_style-style     = cl_gui_alv_grid=>mc_style_button.
      ls_handle_style-style2    = cl_gui_alv_grid=>mc_style_disabled.
      INSERT ls_handle_style INTO TABLE ls_outtab_step-handle_style.

      INSERT ls_outtab_step INTO ct_outtab_step INDEX iv_row_number.
      INSERT INITIAL LINE INTO ct_step_data INDEX iv_row_number.
    ENDIF.


    IF iv_e_ucomm EQ 'DELETE_ROW' OR iv_e_ucomm EQ 'INSERT_ROW'.
      lv_tabix = 1.
      "GT_STEP_DATA: update step_number and the ITAB reference_step
      LOOP AT ct_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data>).
        <ls_step_data>-step_number = lv_tabix.
        lv_tabix = lv_tabix + 1.
        IF lv_tabix GT iv_row_number.
          "current line (which is lv_tabix minus 1) is one that has been moved
          LOOP AT <ls_step_data>-reference_step ASSIGNING FIELD-SYMBOL(<ls_reference_step>).
            DATA(lv_ref_step_tabix) = sy-tabix.
            IF <ls_reference_step> GE iv_row_number.
              IF iv_e_ucomm EQ 'INSERT_ROW'.
                <ls_reference_step> = <ls_reference_step> + 1.
              ELSEIF iv_e_ucomm EQ 'DELETE_ROW'.
                IF iv_row_number EQ <ls_reference_step>.
*                  CLEAR <ls_reference_step>.
                  DELETE <ls_step_data>-reference_step INDEX lv_ref_step_tabix.
                ELSE.
                  <ls_reference_step> = <ls_reference_step> - 1.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDLOOP.


      lv_tabix = 1.
      "GT_OUTTAB_STEP: update step_number and the FIELD reference_step
      LOOP AT ct_outtab_step ASSIGNING FIELD-SYMBOL(<ls_outtab_step>).
        <ls_outtab_step>-step_number = lv_tabix.
        lv_tabix = lv_tabix + 1.
        IF <ls_outtab_step>-reference_step GE iv_row_number.
          IF iv_e_ucomm EQ 'INSERT_ROW'.
            <ls_outtab_step>-reference_step = <ls_outtab_step>-reference_step + 1.
          ELSEIF iv_e_ucomm EQ 'DELETE_ROW'.
            IF iv_row_number EQ <ls_outtab_step>-reference_step.
              READ TABLE ct_step_data ASSIGNING <ls_step_data> WITH KEY step_number = <ls_outtab_step>-step_number.
              IF sy-subrc = 0.
                IF <ls_step_data>-reference_step IS INITIAL.
                  CLEAR <ls_outtab_step>-reference_step.
                ELSE.
                  <ls_outtab_step>-reference_step = <ls_step_data>-reference_step[ 1 ].
                ENDIF.
              ENDIF.
              IF lines( <ls_step_data>-reference_step ) < 2.
                <ls_outtab_step>-reference_step_more = icon_enter_more.
              ENDIF.
            ELSE.
              <ls_outtab_step>-reference_step = <ls_outtab_step>-reference_step - 1.
            ENDIF.
          ENDIF.
          ev_adapted_alv_refstep = abap_true.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD shift_step_ids_in_string.
    DATA: lv_step_number        TYPE i,
          lv_step_number_abs    TYPE i,
          lv_step_number_string TYPE string,
          lv_substring          TYPE string.

    IF cv_json_file IS NOT INITIAL.
      DO.
        DATA(lv_index) = sy-index.
        lv_substring = cv_json_file+lv_index.

        CLEAR lv_step_number_abs.

*         Check if the string starts with /step
        IF contains( val = lv_substring pcre = '^\/step.*(?m)$' case = abap_false ). "matches doesn't work, contains works only with multiline flag (?m)
*         Get step number, (?<=step\[) = step starts with step[ , -? = optional negative sign, \d+ = step number to extract , (?=\]) = succeeded end ending with ]
          lv_step_number = match( val = lv_substring pcre = '(?<=step\[)-?\d+(?=\])' case = abap_false ).

          IF lv_step_number < 0. "found step number is negative ( relative )
            lv_step_number_abs = iv_step_number + lv_step_number. "step number absolute

          ENDIF.

          IF lv_step_number >= iv_row_number "found step number is greater than step number inserted / deleted
            OR ( lv_step_number < 0 AND lv_step_number_abs <= iv_row_number ). "found step number is negative ( relative )
            "and in absolute is less than step number inserted / deleted
            IF lv_step_number >= iv_row_number.
              CASE iv_operation.
                WHEN if_ptf_step_shift=>insert.
                  lv_step_number = lv_step_number + 1.

                WHEN if_ptf_step_shift=>delete.
                  lv_step_number = lv_step_number - 1.

              ENDCASE.

            ELSEIF lv_step_number_abs < iv_row_number.
              CASE iv_operation.
                WHEN if_ptf_step_shift=>insert.
                  lv_step_number = lv_step_number - 1.

                WHEN if_ptf_step_shift=>delete.
                  lv_step_number = lv_step_number + 1.

              ENDCASE.

            ENDIF.

            IF lv_step_number IS INITIAL
              OR ( lv_step_number_abs = iv_row_number ).
              lv_step_number_string = 'undefined'.

            ELSE.
*              lv_step_number_string = lv_step_number.
*
*              CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
*                CHANGING
*                  value = lv_step_number_string.

              lv_step_number_string = |{ lv_step_number SIGN = LEFT }|.

              lv_step_number_string = condense( lv_step_number_string ).

            ENDIF.

*           Set new step number
            lv_substring = replace( val = lv_substring pcre = '(?<=step\[)-?\d+(?=\])' with = |{ lv_step_number_string }| case = abap_false ).

            cv_json_file = |{ cv_json_file(lv_index) }{ lv_substring }|.

            cv_reference_shifted = abap_on.

          ENDIF.

        ENDIF.

        IF lv_index = strlen( cv_json_file ).
          EXIT.

        ENDIF.

      ENDDO.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
