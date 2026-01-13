*&---------------------------------------------------------------------*
*& Include          PTF_STEP_ALV_EVENT
*&---------------------------------------------------------------------*

CLASS lcl_event_receiver DEFINITION.

  PUBLIC SECTION.
    METHODS:
      on_f4 FOR EVENT onf4 OF cl_gui_alv_grid
        IMPORTING sender
                  e_fieldname
                  e_fieldvalue
                  es_row_no
                  er_event_data
                  et_bad_cells
                  e_display,

      docid_edit
        IMPORTING es_row_no TYPE lvc_s_roid
        CHANGING  e_column  TYPE lvc_s_col,


      go_to
        IMPORTING es_row_no TYPE lvc_s_roid
        CHANGING  e_column  TYPE lvc_s_col,


      show_usage_of
        IMPORTING es_row_no TYPE lvc_s_roid
        CHANGING  e_column  TYPE lvc_s_col,

      show_config_of
        IMPORTING es_row_no TYPE lvc_s_roid
        CHANGING  e_column  TYPE lvc_s_col,

      on_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING e_onf4
                  e_onf4_before
                  e_onf4_after
                  er_data_changed
                  e_ucomm
                  sender,

      on_data_changed_finished FOR EVENT data_changed_finished OF cl_gui_alv_grid
        IMPORTING e_modified
                  et_good_cells,

      on_button_click FOR EVENT before_user_command OF cl_gui_alv_grid
        IMPORTING sender
                  e_ucomm,

      on_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_interactive
                  e_object
                  sender,

      on_double_click FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING sender
                  e_column
                  e_row
                  es_row_no,

      on_context_menu FOR EVENT context_menu_request OF cl_gui_alv_grid
        IMPORTING e_object,

      handle_context_enhancement FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING
          e_ucomm,

      handle_delayed_changed_sel_cb FOR EVENT delayed_changed_sel_callback OF cl_gui_alv_grid,

      button_click FOR EVENT button_click OF cl_gui_alv_grid
        IMPORTING es_col_id
                  es_row_no,

      refresh_buttons CHANGING cs_outtab_step TYPE cl_ptf_util=>ty_outtab.

  PRIVATE SECTION.
    DATA: ms_row_no TYPE lvc_s_roid,
          me_column TYPE lvc_s_col.
ENDCLASS.
*****************************************************************************************
CLASS lcl_event_receiver IMPLEMENTATION.

  METHOD on_context_menu.

    DATA: lv_value             TYPE char40,
          functions            TYPE ui_funcattr,
          functions_to_disable TYPE ui_functions.

    g_grid_step->get_current_cell(
      IMPORTING
        es_col_id = me_column                 " Column ID
        es_row_no = ms_row_no                 " Numeric Row ID
    ).

    e_object->clear( ).
    IF me_column EQ 'BUS_OBJ' OR me_column EQ 'ACTION'.
      e_object->add_function(
      EXPORTING
        fcode             =    'CONFIG'
        text              =    'Show Configuration'
      ).
    ENDIF.

    e_object->add_separator( ).
    IF me_column EQ 'BUS_OBJ' OR me_column EQ 'ACTION' OR me_column EQ 'VARIANT' OR me_column EQ 'TEST_DATA_CONTAINER'.
      IF me_column EQ 'VARIANT' OR me_column EQ 'TEST_DATA_CONTAINER'.
        e_object->add_function(
        EXPORTING
          fcode             =    'GOTO'
          text              =    'Navigate to TDC'
        ).
      ELSE.
        e_object->add_function(
        EXPORTING
          fcode             =    'GOTO'
          text              =    'Navigate to Source'
        ).
      ENDIF.
      e_object->add_separator( ).
      e_object->add_function(
        EXPORTING
          fcode             =  'USAGE'                " Function code
          text              =  'Where-Used List'                " Function text
      ).

    ENDIF.

    IF me_column EQ 'DOCUMENT_ID' AND gt_outtab_step[ ms_row_no-row_id ]-bus_obj IS NOT INITIAL AND
                                      gt_outtab_step[ ms_row_no-row_id ]-action IS NOT INITIAL.
      e_object->add_function(
        EXPORTING
          fcode             =  'DOCID_EDIT'                " Function code
          text              =  'Make editable'                " Function text
      ).
    ENDIF.

  ENDMETHOD.

  METHOD handle_context_enhancement.
*    DATA: selected_cells   TYPE lvc_t_cell,
*          selected_columns TYPE lvc_t_col,
*          catalog          TYPE lvc_t_fcat.

    CASE e_ucomm.
      WHEN 'GOTO'.
        me->go_to(
          EXPORTING
            es_row_no = me->ms_row_no
          CHANGING
            e_column  = me->me_column
        ).
      WHEN 'USAGE'.
        me->show_usage_of(
          EXPORTING
            es_row_no = me->ms_row_no
          CHANGING
            e_column  = me->me_column
        ).
      WHEN 'CONFIG'.
        me->show_config_of(
          EXPORTING
            es_row_no = me->ms_row_no
          CHANGING
            e_column  = me->me_column
        ).
      WHEN 'DOCID_EDIT'.
        me->docid_edit(
          EXPORTING
            es_row_no = me->ms_row_no
          CHANGING
            e_column  = me->me_column
        ).
      WHEN OTHERS.
        RETURN.
    ENDCASE.

    CLEAR me->ms_row_no.
    CLEAR me->me_column.

  ENDMETHOD.

  METHOD handle_delayed_changed_sel_cb.
    CLEAR gv_row_number.

    g_grid_step->get_selected_rows(
      IMPORTING
        et_row_no = DATA(lt_row_number) ).

    READ TABLE lt_row_number INTO DATA(ls_row_number) INDEX 1.
    IF sy-subrc = 0.
      gv_row_number = ls_row_number.

    ENDIF.

    g_grid_step->set_toolbar_interactive( ).

  ENDMETHOD.

  METHOD on_f4.

    DATA:
      lt_return_value TYPE TABLE OF ddshretval,
      ls_return       TYPE ddshretval,
      shlp            TYPE shlp_descr_t,
      ls_shlp_inface  TYPE ddshiface.
*          ls_tdcv_mock    TYPE ptf_f4help_tdcv_mock,
*          lt_f4                  TYPE TABLE OF ddshretval,

    FIELD-SYMBOLS: <ls_outtab_step> TYPE cl_ptf_util=>ty_outtab,
                   <ls_ectd_data>   TYPE ectd_data.

    READ TABLE gt_outtab_step ASSIGNING <ls_outtab_step> INDEX es_row_no-row_id.

*   Check if object is RAP BO
    DATA(lo_ptf_rap_metadata) = NEW cl_ptf_rap_metadata( ).
    DATA(lv_is_rap_bo) = lo_ptf_rap_metadata->check_rap_bo( iv_bus_obj = <ls_outtab_step>-bus_obj ).
*   Check if action is RAP BO Action
    DATA(lv_is_rap_bo_action) = lo_ptf_rap_metadata->check_rap_bo_action(
                                          EXPORTING
                                            iv_bus_obj = <ls_outtab_step>-bus_obj
                                            iv_action  = <ls_outtab_step>-action ).

    " irgendwann sollte auf Texttabellen zugegriffen werden
    CASE e_fieldname.

      WHEN 'TEST_DATA_CONTAINER'.
        DATA: selected_tdc   TYPE cl_ptf_alv_elements=>ty_test_data_container_result,
              index          TYPE i,
              available_tdcs TYPE cl_ptf_alv_elements=>ty_test_data_container_results.

        "ToDo:
*        IF <ls_outtab_step>-bus_obj EQ cl_ptf_util=>gc_bo_ptfrun AND <ls_outtab_step>-action EQ cl_ptf_util=>gc_action_mock_db.
*          special logic...
*        ENDIF.

        SELECT SINGLE ptf_tdcp FROM ptfboa
          WHERE ptf_bo = @<ls_outtab_step>-bus_obj
          AND ptf_act = @<ls_outtab_step>-action
          INTO @DATA(parameter).
        IF parameter IS INITIAL.
          EXIT.
        ENDIF.
        "A lot of users dont use naming conventions
        SELECT DISTINCT name, MAX( version ) AS version FROM ectd_par
          WHERE "( name LIKE 'TDC_PTF_%' OR name LIKE 'ZTDC_PTF_%' ) AND
          pname = @parameter
          GROUP BY name
          INTO TABLE @DATA(found_tdcs).

        LOOP AT found_tdcs ASSIGNING FIELD-SYMBOL(<found_tdc>).
          SELECT SINGLE title FROM ecatt_text_n
            WHERE obj_type = 'ECTD'
            AND name = @<found_tdc>-name
            AND version = @<found_tdc>-version
            INTO @DATA(tdc_title).

          APPEND VALUE #(
            tdc_name = <found_tdc>-name
            tdc_title = tdc_title
          ) TO available_tdcs.
        ENDLOOP.

        TRY.
            NEW cl_ptf_alv_elements( )->show_list_of_tdcs(
              IMPORTING
                selected_index = index
              CHANGING
                tdcs           = available_tdcs
              RECEIVING
                selection      = selected_tdc
            ).
          CATCH cx_salv_msg. " ALV: General Error Class with Message
            EXIT.
        ENDTRY.

        IF selected_tdc IS NOT INITIAL.
          <ls_outtab_step>-test_data_container = selected_tdc.
        ENDIF.

        "me->refresh_buttons( CHANGING cs_outtab_step = <ls_outtab_step> ).  temp december


      WHEN 'BUS_OBJ'. """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        DATA lt_bus_obj TYPE TABLE OF ptf_f4help_bo.  "ptfbo
*          lv_ptf_bot      TYPE ptfbot,
*          lv_ptf_bo_upper_search TYPE string,

*          CASE sy-uname.
*            WHEN 'GRIESEC' OR 'BURNAR' OR '_SAPD049099' OR '_SAPI550454'.
*             Get the description for the search help
*        DATA lv_eligible TYPE abap_bool.
*        PERFORM check_user CHANGING lv_eligible.
*        IF lv_eligible = abap_on.
        CALL FUNCTION 'F4IF_GET_SHLP_DESCR'
          EXPORTING
            shlpname = 'SHPTF_BUS_OBJ'
          IMPORTING
            shlp     = shlp.

        LOOP AT shlp-interface INTO ls_shlp_inface.
          CASE ls_shlp_inface-shlpfield.
            WHEN 'PTF_BO'.
              ls_shlp_inface-value    = <ls_outtab_step>-bus_obj.
              ls_shlp_inface-valfield = 'X'.
              MODIFY shlp-interface FROM ls_shlp_inface TRANSPORTING value valfield.

          ENDCASE.
        ENDLOOP.

        CALL FUNCTION 'F4IF_START_VALUE_REQUEST'
          EXPORTING
            shlp          = shlp
          TABLES
            return_values = lt_return_value.

        IF lt_return_value IS NOT INITIAL.
          READ TABLE lt_return_value INTO ls_return INDEX 1.
          <ls_outtab_step>-bus_obj = ls_return-fieldval.

        ENDIF.

*        ELSE.
**            WHEN OTHERS.
*          SELECT * FROM ptfbo INNER JOIN ptfbot ON ptfbo~ptf_bo = ptfbot~ptf_bo INTO CORRESPONDING FIELDS OF TABLE lt_bus_obj WHERE spras = 'E'.
*          SORT lt_bus_obj BY ptf_bo.
*          CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*            EXPORTING
*              ddic_structure  = 'PTF_F4HELP_BO'  "'PTFBO'
*              retfield        = 'PTF_BO'
*              dynpprog        = sy-cprog
*              dynpnr          = sy-dynnr
*              window_title    = 'Business Object'
*              value_org       = 'S'
*            TABLES
*              value_tab       = lt_bus_obj
*              return_tab      = lt_return_value
*            EXCEPTIONS
*              parameter_error = 1
*              no_values_found = 2
*              OTHERS          = 3.
*          IF lt_return_value IS NOT INITIAL.
*            READ TABLE lt_return_value INTO ls_return INDEX 1.
*            <ls_outtab_step>-bus_obj = ls_return-fieldval.
**            CONDENSE <ls_outtab_step>-bus_obj NO-GAPS. "Temporarily until I understood why the value help returns leading spaces
*          ENDIF.
*
*        ENDIF.

        me->refresh_buttons( CHANGING cs_outtab_step = <ls_outtab_step> ).
*
*        ENDCASE.


      WHEN 'ACTION'. """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

        "Do nothing if there is a BO that is neither PTF BO nor RAP BO
        IF <ls_outtab_step>-bus_obj IS NOT INITIAL.
          SELECT SINGLE * FROM ptfbo INTO @DATA(ls_ptfbo) WHERE ptf_bo = @<ls_outtab_step>-bus_obj.
          IF sy-subrc IS NOT INITIAL.
            "Cancel
            CHECK lv_is_rap_bo EQ abap_on.
          ENDIF.
        ENDIF.


*       Get the description for the search help
        CALL FUNCTION 'F4IF_GET_SHLP_DESCR'
          EXPORTING
            shlpname = 'SHPTF_ACTION'
          IMPORTING
            shlp     = shlp.

        LOOP AT shlp-interface INTO ls_shlp_inface.
          CASE ls_shlp_inface-shlpfield.
            WHEN 'PTF_BO'.
              ls_shlp_inface-value = <ls_outtab_step>-bus_obj.
              MODIFY shlp-interface FROM ls_shlp_inface TRANSPORTING value.
            WHEN 'PTF_ACT'.
              ls_shlp_inface-valfield = 'X'.
              MODIFY shlp-interface FROM ls_shlp_inface TRANSPORTING valfield.
            WHEN 'PTF_API_ACTION'.
              ls_shlp_inface-valfield = 'X'.
              MODIFY shlp-interface FROM ls_shlp_inface TRANSPORTING valfield.
          ENDCASE.
        ENDLOOP.

        CALL FUNCTION 'F4IF_START_VALUE_REQUEST'
          EXPORTING
            shlp          = shlp
          TABLES
            return_values = lt_return_value.



*        CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*          EXPORTING
*            ddic_structure  = 'PTF_F4HELP_ACTION'
*            retfield        = 'PTF_ACT'
*            dynpprog        = sy-cprog
*            dynpnr          = sy-dynnr
*            window_title    = 'Action'
*            value_org       = 'S'
*          TABLES
*            value_tab       = lt_action
*            return_tab      = lt_return_value
*          EXCEPTIONS
*            parameter_error = 1
*            no_values_found = 2
*            OTHERS          = 3.
        IF lt_return_value IS NOT INITIAL.
          READ TABLE lt_return_value INTO ls_return INDEX 1.
          <ls_outtab_step>-action = ls_return-fieldval.
        ENDIF.

        me->refresh_buttons( CHANGING cs_outtab_step = <ls_outtab_step> ).


      WHEN 'VARIANT'. """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        DATA:
          lv_ptf_tdc     TYPE etobj_name,
          lt_ectd_data   TYPE TABLE OF ectd_data,
          ls_ectd_text_n TYPE ectd_text_n.

        IF <ls_outtab_step>-bus_obj EQ cl_ptf_util=>gc_bo_ptfrun AND <ls_outtab_step>-action EQ cl_ptf_util=>gc_action_mock_db.
          "Provide mock specific F4
          DATA lt_mock_tdcv TYPE STANDARD TABLE OF ptf_f4help_tdcv_mock.
          DATA lt_tdcv_descr TYPE SORTED TABLE OF ectd_text_n WITH UNIQUE KEY obj_type name version pname text_type.  "it seems that tdc variant descriptions have no versions
          "select * from ECTD_VER into table @data(lt_tdc) where name like 'TDC_PTF_MOCK%'.
          SELECT name, varid
            FROM ectd_var INTO TABLE
            @lt_mock_tdcv
            WHERE name LIKE 'TDC_PTF_MOCK%' AND varid <> @gc_ecattdefault_varid
            GROUP BY name, varid.
          IF lt_mock_tdcv IS NOT INITIAL.
            SELECT * FROM ectd_text_n INTO TABLE @lt_tdcv_descr FOR ALL ENTRIES IN @lt_mock_tdcv WHERE obj_type = 'ECTD' AND name = @lt_mock_tdcv-tdc AND pname = @lt_mock_tdcv-varid(30) AND text_type = 'V'.
            LOOP AT lt_mock_tdcv ASSIGNING FIELD-SYMBOL(<ls_tdcv>).
              READ TABLE lt_tdcv_descr WITH KEY name = <ls_tdcv>-tdc pname = <ls_tdcv>-varid ASSIGNING FIELD-SYMBOL(<ls_desc>).
              IF sy-subrc IS INITIAL.
                <ls_tdcv>-descr = <ls_desc>-pdesc.
              ENDIF.
            ENDLOOP.
          ENDIF.

          CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
            EXPORTING
              ddic_structure  = 'PTF_F4HELP_TDCV_MOCK'
              retfield        = 'VARID'
              dynpprog        = sy-cprog
              dynpnr          = sy-dynnr
              window_title    = 'Mock Variant'
              value_org       = 'S'
            TABLES
              value_tab       = lt_mock_tdcv
              return_tab      = lt_return_value   "can return multiple lines - how return more than 1 field?
            EXCEPTIONS
              parameter_error = 1
              no_values_found = 2
              OTHERS          = 3.
          IF sy-subrc IS INITIAL AND lt_return_value IS NOT INITIAL.
            READ TABLE lt_return_value INTO ls_return INDEX 1.
            <ls_outtab_step>-variant = ls_return-fieldval.
            IF <ls_outtab_step>-variant IS NOT INITIAL.
              SELECT name, varid
              FROM ectd_var INTO TABLE
              @DATA(lt_tdcv_per_name)
              WHERE varid = @<ls_outtab_step>-variant
              GROUP BY name, varid.
              IF lines( lt_tdcv_per_name ) EQ 1.
                DATA ls_unique_tdcv LIKE LINE OF lt_tdcv_per_name.
                READ TABLE lt_tdcv_per_name INTO ls_unique_tdcv INDEX 1.
                CONCATENATE ls_unique_tdcv-name ls_unique_tdcv-varid INTO <ls_outtab_step>-variant SEPARATED BY ','.
              ELSE.
                "problem, needs improvement
*                CLEAR <ls_outtab_step>-variant.  instead of clearing the field, we return at least the variant. But not the TDC, neither in field VARIANT nor in field TDC
                CLEAR lt_return_value.
              ENDIF.
            ENDIF.
          ENDIF.
        ELSE. "(IF branch above is about a BO PTF_RUN mock action)

*         Don't show F4 if cell is disabled
          IF line_exists( <ls_outtab_step>-handle_style[ fieldname = 'VARIANT' ] ).
            IF <ls_outtab_step>-handle_style[ fieldname = 'VARIANT' ]-style = cl_gui_alv_grid=>mc_style_disabled.
              RETURN.

            ENDIF.

          ENDIF.

          "TDCV F4
          SELECT SINGLE ptf_tdc FROM ptfboa INTO lv_ptf_tdc WHERE ptf_bo = <ls_outtab_step>-bus_obj AND ptf_act = <ls_outtab_step>-action.
          IF <ls_outtab_step>-test_data_container IS NOT INITIAL.
            lv_ptf_tdc = <ls_outtab_step>-test_data_container.
          ENDIF.

          IF ( lv_is_rap_bo = abap_off AND lv_ptf_tdc IS NOT INITIAL ) OR <ls_outtab_step>-test_data_container IS NOT INITIAL.
            DATA lo_ptf_util_f4 TYPE REF TO cl_ptf_util.
            TRY.
                CREATE OBJECT lo_ptf_util_f4
                  EXPORTING
                    iv_ignore_local_substitute = abap_true  "F4 helps must never be influenced by TDC Z substitution logic, as productive TDCs shall be used and persisted
                    iv_bo                      = <ls_outtab_step>-bus_obj
                    iv_action                  = <ls_outtab_step>-action
                    iv_tdc                     = lv_ptf_tdc.
              CATCH cx_ecatt_tdc_access INTO DATA(lr_exc).
                DATA(txt) = lr_exc->get_text( ).
            ENDTRY.
            IF lo_ptf_util_f4 IS BOUND.
              DATA(lv_tdcp_name) = lo_ptf_util_f4->get_tdcp_name( ).
              DATA(lv_tdc_name) = lo_ptf_util_f4->get_tdc_name( ).
** Check which TDC Variants fill the given Paramters
              SELECT * FROM ectd_data INTO TABLE lt_ectd_data WHERE name = lv_tdc_name AND pname = lv_tdcp_name .
            ENDIF.
            DATA:
              lt_tdcv TYPE TABLE OF ptf_f4help_tdcv,
              ls_tdcv TYPE ptf_f4help_tdcv.
            LOOP AT lt_ectd_data ASSIGNING <ls_ectd_data>.
              CLEAR ls_tdcv.
              IF <ls_ectd_data>-varid NE gc_ecattdefault_varid.
                ls_tdcv-varid = <ls_ectd_data>-varid.
*               read the description and add it to the f4-help.
                CLEAR ls_ectd_text_n.
                SELECT * FROM ectd_text_n INTO ls_ectd_text_n WHERE obj_type = 'ECTD' AND pname = <ls_ectd_data>-varid AND text_type = 'V'.
                ENDSELECT.
                IF NOT ls_ectd_text_n IS INITIAL.
                  ls_tdcv-descr = ls_ectd_text_n-pdesc.
                ENDIF.
                APPEND ls_tdcv TO lt_tdcv.
              ENDIF.
            ENDLOOP.
*        ELSE.
*          MESSAGE ID 'PTF' TYPE 'S' NUMBER 038 WITH es_row_no-row_id  DISPLAY LIKE 'E'.
*          EXIT.
*          ENDIF.

            CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
              EXPORTING
                ddic_structure  = 'PTF_F4HELP_TDCV'
                retfield        = 'VARID'
                dynpprog        = sy-cprog
                dynpnr          = sy-dynnr
                window_title    = 'Variant'
                value_org       = 'S'
              TABLES
                value_tab       = lt_tdcv
                return_tab      = lt_return_value
              EXCEPTIONS
                parameter_error = 1
                no_values_found = 2
                OTHERS          = 3.

          ELSEIF lv_is_rap_bo_action = abap_on. "We have RAP BO Action
            CALL FUNCTION 'F4IF_GET_SHLP_DESCR'
              EXPORTING
                shlpname = 'SHPTF_INPUT_REPO'
              IMPORTING
                shlp     = shlp.

            LOOP AT shlp-interface INTO ls_shlp_inface.
              CASE ls_shlp_inface-shlpfield.
                WHEN 'INPUT_ID'.
*                  ls_shlp_inface-value    = <ls_outtab_step>-variant.
                  ls_shlp_inface-valfield = 'X'.
                  MODIFY shlp-interface FROM ls_shlp_inface TRANSPORTING value valfield.

                WHEN 'BUS_OBJ'.
                  ls_shlp_inface-value    = <ls_outtab_step>-bus_obj.
                  ls_shlp_inface-valfield = 'X'.
                  MODIFY shlp-interface FROM ls_shlp_inface TRANSPORTING value valfield.

                WHEN 'ACTION'.
                  ls_shlp_inface-value    = <ls_outtab_step>-action.
                  ls_shlp_inface-valfield = 'X'.
                  MODIFY shlp-interface FROM ls_shlp_inface TRANSPORTING value valfield.

              ENDCASE.

            ENDLOOP.

            CALL FUNCTION 'F4IF_START_VALUE_REQUEST'
              EXPORTING
                shlp          = shlp
              TABLES
                return_values = lt_return_value.

          ENDIF.

          IF lt_return_value IS NOT INITIAL.
            READ TABLE lt_return_value INTO ls_return INDEX 1.
            <ls_outtab_step>-variant = ls_return-fieldval.
            CONDENSE <ls_outtab_step>-variant NO-GAPS. "Temporarily until I understood why the value help returns leading spaces
          ENDIF.
        ENDIF.


    ENDCASE.
    g_grid_step->refresh_table_display( ).  "ToDo: is this refresh really needed? we loose the focus on the current cell. at least call always set_selected_cells

**    IF lt_return_value IS INITIAL   AND selected_tdc IS INITIAL. "selected_tdc for column TDC, lt_return_value for all others
*      DATA lt_cells TYPE lvc_t_cell.
*      DATA ls_cell  TYPE lvc_s_cell.
*      ls_cell-col_id = e_fieldname.
*      ls_cell-row_id = es_row_no-row_id.
*      APPEND ls_cell TO lt_cells.
*      g_grid_step->set_selected_cells( it_cells = lt_cells ).
**    ENDIF.

    DATA ls_column_id TYPE lvc_s_col.

    ls_column_id-fieldname = e_fieldname.

    g_grid_step->set_current_cell_via_id( is_column_id = ls_column_id
                                          is_row_no    = es_row_no   ).

  ENDMETHOD.            "lcl_event_receiver DEFINITION


  METHOD on_toolbar.

    DATA ls_toolbar  TYPE stb_button.

    FIELD-SYMBOLS: <ls_outtab_step> TYPE cl_ptf_util=>ty_outtab,
                   <ls_step_data>   TYPE cl_ptf_util=>gt_ptf_step.

    LOOP AT e_object->mt_toolbar ASSIGNING FIELD-SYMBOL(<ls_toolbar>).
      IF <ls_toolbar>-function NE '&MB_VARIANT'.
        DELETE e_object->mt_toolbar WHERE function = <ls_toolbar>-function.
      ENDIF.
    ENDLOOP.

*    CLEAR e_object->mt_toolbar.
*    CLEAR ls_toolbar.
    MOVE 3 TO ls_toolbar-butn_type.
    APPEND ls_toolbar TO e_object->mt_toolbar.

    CLEAR ls_toolbar.
    MOVE 'INSERT_ROW' TO ls_toolbar-function.
    MOVE icon_insert_row TO ls_toolbar-icon.
    MOVE 'Insert Row'(111) TO ls_toolbar-quickinfo.
    MOVE ''(112) TO ls_toolbar-text.
    MOVE ' ' TO ls_toolbar-disabled.
    APPEND ls_toolbar TO e_object->mt_toolbar.


    CLEAR ls_toolbar.
    MOVE 'DELETE_ROW' TO ls_toolbar-function.
    MOVE icon_delete_row TO ls_toolbar-icon.
    MOVE 'Delete Row'(111) TO ls_toolbar-quickinfo.
    MOVE ''(112) TO ls_toolbar-text.
    MOVE ' ' TO ls_toolbar-disabled.
    APPEND ls_toolbar TO e_object->mt_toolbar.

*    DATA lv_eligible TYPE abap_bool.
*    PERFORM check_user CHANGING lv_eligible.
*    IF lv_eligible = abap_on.
    CLEAR ls_toolbar.
    MOVE 3 TO ls_toolbar-butn_type.
    APPEND ls_toolbar TO e_object->mt_toolbar.

    CLEAR ls_toolbar.
    MOVE 'EXPECTED_MESSAGES' TO ls_toolbar-function.
    MOVE 'Maintain Expected Messages' TO ls_toolbar-text.
    MOVE abap_on TO ls_toolbar-disabled.

    READ TABLE gt_outtab_step ASSIGNING <ls_outtab_step> INDEX gv_row_number-row_id.
    IF sy-subrc = 0.
      IF <ls_outtab_step>-bus_obj = 'PTF_RUN' AND <ls_outtab_step>-action = 'CHECK_MESSAGES'.
        MOVE abap_off TO ls_toolbar-disabled.

      ENDIF.

    ENDIF.

    APPEND ls_toolbar TO e_object->mt_toolbar.

    CLEAR ls_toolbar.
    MOVE 'ACTUAL_MESSAGES' TO ls_toolbar-function.
    MOVE 'Show Messages of last Run' TO ls_toolbar-text.
    MOVE abap_on TO ls_toolbar-disabled.

    READ TABLE gt_outtab_step ASSIGNING <ls_outtab_step> INDEX gv_row_number-row_id.
    IF sy-subrc = 0.
      IF <ls_outtab_step>-act_messages IS NOT INITIAL. "at least one run
        MOVE abap_off TO ls_toolbar-disabled.

      ENDIF.

    ENDIF.

    APPEND ls_toolbar TO e_object->mt_toolbar.

    CLEAR ls_toolbar.
    MOVE 3 TO ls_toolbar-butn_type.
    APPEND ls_toolbar TO e_object->mt_toolbar.

    CLEAR ls_toolbar.
    MOVE 'RETRIEVED_DATA' TO ls_toolbar-function.
    MOVE 'Show Retrieved BO Data' TO ls_toolbar-text.
    MOVE abap_on TO ls_toolbar-disabled.

    READ TABLE gt_outtab_step ASSIGNING <ls_outtab_step> INDEX gv_row_number-row_id.
    IF sy-subrc = 0.
      IF <ls_outtab_step>-action = 'RETRIEVE_ALL' OR <ls_outtab_step>-action = 'RETRIEVE'.
        READ TABLE gt_step_data ASSIGNING <ls_step_data> INDEX gv_row_number-row_id.
        IF sy-subrc = 0.
          IF <ls_step_data>-data_object_json IS NOT INITIAL.
            MOVE abap_off TO ls_toolbar-disabled.

          ENDIF.

        ENDIF.

      ENDIF.

    ENDIF.

    APPEND ls_toolbar TO e_object->mt_toolbar.

*    ENDIF.

  ENDMETHOD.

  METHOD on_data_changed.

    DATA ls_changed TYPE lvc_s_modi.

    FIELD-SYMBOLS: <ls_outtab_step>  TYPE cl_ptf_util=>ty_outtab,
                   <ls_step_data>    TYPE cl_ptf_util=>gt_ptf_step,
                   <fs_field>        TYPE any,
                   <fs_handle_style> TYPE lvc_s_styl.

    LOOP AT er_data_changed->mt_good_cells INTO ls_changed.
      READ TABLE gt_outtab_step ASSIGNING <ls_outtab_step> INDEX ls_changed-row_id.
      ASSIGN COMPONENT ls_changed-fieldname OF STRUCTURE <ls_outtab_step> TO <fs_field>.
      IF <fs_field> IS ASSIGNED.
        <fs_field> = ls_changed-value.

        "If changed Field is REFERENCE_STEP, update additionally also the first field in itab reference_step in the current line of gt_step_data
        IF ls_changed-fieldname EQ 'REFERENCE_STEP'. "note that this is the field, not the itab
          "Update gt_step_data-reference_step (itab)
          READ TABLE gt_step_data ASSIGNING <ls_step_data> INDEX ls_changed-row_id.
*          IF ls_changed-value CN '0123456789'.
*            MESSAGE ID 'PTF' TYPE 'S' NUMBER 040 WITH ls_changed-value DISPLAY LIKE 'E'.
*            RETURN.
*          ENDIF.
          "Change or fill  the first record of itab
          IF <ls_step_data>-reference_step IS NOT INITIAL.
            MODIFY <ls_step_data>-reference_step FROM ls_changed-value INDEX 1.
          ELSE.
            INSERT ls_changed-value INTO <ls_step_data>-reference_step INDEX 1.
          ENDIF.
        ENDIF.

*       This logic is not needed, the status of button JSON_FILE_MORE is handled in method REFRESH_BUTTONS
*        "Status of button JSON_FILE_MORE
*        IF ls_changed-fieldname EQ 'BUS_OBJ'." OR ls_changed-fieldname EQ 'TEST_DATA_CONTAINER'.    "december: temporarily enhanced for field TEST_DATA_CONTAINER
*          READ TABLE gt_outtab_step ASSIGNING <ls_outtab_step> INDEX ls_changed-row_id.
*          IF sy-subrc = 0.
*            LOOP AT <ls_outtab_step>-handle_style ASSIGNING <fs_handle_style>.
*              CASE <fs_handle_style>-fieldname.
*                WHEN 'JSON_FILE_MORE'.
*                  DATA(lo_ptf_rap_metadata) = NEW cl_ptf_rap_metadata( ).
*                  DATA(lv_is_rap_bo) = lo_ptf_rap_metadata->check_rap_bo( iv_bus_obj = <fs_field> ).
*                  IF ( lv_is_rap_bo = abap_off
*                    OR <ls_outtab_step>-test_data_container IS NOT INITIAL )
*                    AND  NOT ( <ls_outtab_step>-bus_obj EQ 'MATDOC' AND <ls_outtab_step>-action EQ 'CHECK' ).
*                    <fs_handle_style>-style = cl_gui_alv_grid=>mc_style_disabled.       "so wurde vorher der button als nicht klickbar dargestellt
*
*                  ELSE.
*                    <fs_handle_style>-style = cl_gui_alv_grid=>mc_style_enabled.
*
*                  ENDIF.
*
**                  g_grid_step->refresh_table_display( EXPORTING is_stable = VALUE #( row = abap_on col = abap_on ) i_soft_refresh = abap_on ).
*
*              ENDCASE.
*
*            ENDLOOP.
*
*          ENDIF.
*
*        ENDIF.

        "If changed Field is DOCUMENT_ID, update additionally also the first field in itab DOCUMENT_ID in the current line of gt_step_data
        IF ls_changed-fieldname EQ 'DOCUMENT_ID'. "note that this is the field, not the itab
          "Update gt_step_data-DOCUMENT_ID (itab)
          READ TABLE gt_step_data ASSIGNING <ls_step_data> INDEX ls_changed-row_id.
          "Change or fill  the first record of itab
          IF <ls_step_data>-document_id IS NOT INITIAL.
            MODIFY <ls_step_data>-document_id FROM ls_changed-value INDEX 1.
          ELSE.
            INSERT ls_changed-value INTO <ls_step_data>-document_id INDEX 1.
          ENDIF.
        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.                    "on_data_changed

  METHOD on_data_changed_finished.
    LOOP AT et_good_cells ASSIGNING FIELD-SYMBOL(<fs_good_cells>).
      IF <fs_good_cells>-fieldname = 'BUS_OBJ' OR <fs_good_cells>-fieldname = 'ACTION'.             "OR <fs_good_cells>-fieldname = 'TEST_DATA_CONTAINER'.  temp december
        READ TABLE gt_outtab_step ASSIGNING FIELD-SYMBOL(<fs_outtab_step>) INDEX <fs_good_cells>-row_id.
        IF sy-subrc = 0.
          me->refresh_buttons( CHANGING cs_outtab_step = <fs_outtab_step> ).

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD on_button_click.

    DATA: lo_ptf_step_shift      TYPE REF TO if_ptf_step_shift,
          lt_row_no              TYPE        lvc_t_roid,
          ls_row_no              TYPE  LINE OF      lvc_t_roid,
          lt_cells               TYPE        lvc_t_ceno,
          ls_cells               TYPE LINE OF       lvc_t_ceno,
          lv_row_number          TYPE        i,
          ls_outtab_step         TYPE cl_ptf_util=>ty_outtab,
          ls_handle_style        TYPE lvc_s_styl,
          lv_tabix               TYPE i,
          lv_lines_removed       TYPE i,
          lb_adapted_alv_refstep TYPE abap_bool,
          lv_reference_shifted   TYPE abap_bool.

    FIELD-SYMBOLS: <ls_outtab_step> TYPE cl_ptf_util=>ty_outtab.
    FIELD-SYMBOLS: <ls_step_data> TYPE cl_ptf_util=>gt_ptf_step.
    FIELD-SYMBOLS: <lt_table> TYPE ANY TABLE.

    CHECK e_ucomm EQ 'DELETE_ROW' OR e_ucomm EQ 'INSERT_ROW' OR e_ucomm EQ 'EXPECTED_MESSAGES'
    OR e_ucomm EQ 'ACTUAL_MESSAGES' OR e_ucomm EQ 'RETRIEVED_DATA'.

    lb_adapted_alv_refstep = abap_false.

    g_grid_step->get_selected_rows( IMPORTING et_row_no = lt_row_no ).
    READ TABLE lt_row_no INTO ls_row_no INDEX 1.
    lv_row_number = ls_row_no-row_id.
    ASSIGN lt_row_no TO <lt_table>.

    IF lv_row_number EQ 0.
      g_grid_step->get_selected_cells_id( IMPORTING et_cells = lt_cells ).
      READ TABLE lt_cells INTO ls_cells INDEX 1.
      lv_row_number = ls_cells-row_id.
      ASSIGN lt_cells TO <lt_table>.
    ENDIF.

    lo_ptf_step_shift = NEW cl_ptf_step_shift( ).


    LOOP AT <lt_table> ASSIGNING FIELD-SYMBOL(<ls_line>).
      TRY.
          ASSIGN COMPONENT 'ROW_ID' OF STRUCTURE <ls_line> TO FIELD-SYMBOL(<lv_value>).
          lv_row_number = <lv_value> - lv_lines_removed.

          IF lv_row_number NE 0.
            CASE  e_ucomm.
              WHEN 'DELETE_ROW'.
                lo_ptf_step_shift->shift_step_ids_in_script(
                  EXPORTING
                    iv_row_number         = lv_row_number
                    iv_operation          = if_ptf_step_shift=>delete
                  IMPORTING
                    ev_reference_shifted  = lv_reference_shifted
                  CHANGING
                    ct_outtab_step        = gt_outtab_step
                ).

*              DELETE gt_outtab_step INDEX lv_row_number.
*              DELETE gt_step_data INDEX lv_row_number.
                lv_lines_removed += 1.

              WHEN 'INSERT_ROW'.
                lo_ptf_step_shift->shift_step_ids_in_script(
                  EXPORTING
                    iv_row_number         = lv_row_number
                    iv_operation          = if_ptf_step_shift=>insert
                  IMPORTING
                    ev_reference_shifted  = lv_reference_shifted
                  CHANGING
                    ct_outtab_step        = gt_outtab_step
                ).

**    **toDo: extract following lines to a reuse object to be called from here and from Form refresh_stepdata.
**              ls_outtab_step-reference_document_id_more = icon_enter_more.
*              ls_outtab_step-reference_step_more = icon_enter_more.
*              ls_outtab_step-json_file_more      = icon_text_ina.
*
*              CLEAR ls_handle_style.
*              ls_handle_style-fieldname = 'VARIANT'.
*              ls_handle_style-style     = cl_gui_alv_grid=>mc_style_enabled.
*              INSERT ls_handle_style INTO TABLE ls_outtab_step-handle_style.
*
*              CLEAR ls_handle_style.
*              ls_handle_style-fieldname = 'TEST_DATA_CONTAINER'.
*              ls_handle_style-style     = cl_gui_alv_grid=>mc_style_enabled.
*              INSERT ls_handle_style INTO TABLE ls_outtab_step-handle_style.
*
*              CLEAR ls_handle_style.
*              ls_handle_style-fieldname = 'JSON_FILE_MORE'.
**                ls_handle_style-style     = cl_gui_alv_grid=>mc_style_button.
*              ls_handle_style-style2    = cl_gui_alv_grid=>mc_style_disabled.
*              INSERT ls_handle_style INTO TABLE ls_outtab_step-handle_style.
*
*              INSERT ls_outtab_step INTO gt_outtab_step INDEX lv_row_number.
*              INSERT INITIAL LINE INTO gt_step_data INDEX lv_row_number.

              WHEN 'EXPECTED_MESSAGES'.
                READ TABLE gt_outtab_step ASSIGNING <ls_outtab_step> WITH KEY step_number = lv_row_number.
                IF <ls_outtab_step>-bus_obj = 'PTF_RUN' AND <ls_outtab_step>-action = 'CHECK_MESSAGES'.
                  CALL SCREEN 3101 STARTING AT 50 1. "Screens starting with 9* are reserved

                  g_grid_step->set_toolbar_interactive( ). "Trigger again the toolbar to reset the button

                  RETURN. "Calling update_step_data would impact the manual update of ResultIds in the main ALV

                ENDIF.

              WHEN 'ACTUAL_MESSAGES'.
                READ TABLE gt_outtab_step ASSIGNING <ls_outtab_step> WITH KEY step_number = lv_row_number.
                CALL SCREEN 3102 STARTING AT 50 1. "Screens starting with 9* are reserved

                g_grid_step->set_toolbar_interactive( ). "Trigger again the toolbar to reset the button

                RETURN. "Calling update_step_data would impact the manual update of ResultIds in the main ALV

              WHEN 'RETRIEVED_DATA'.
                CLEAR gv_json_file.

                READ TABLE gt_outtab_step ASSIGNING <ls_outtab_step> WITH KEY step_number = lv_row_number.
                IF <ls_outtab_step>-action = 'RETRIEVE' OR <ls_outtab_step>-action = 'RETRIEVE_ALL'.
                  READ TABLE gt_step_data ASSIGNING <ls_step_data> WITH KEY step_number = <ls_outtab_step>-step_number.
                  IF sy-subrc = 0.
                    IF <ls_step_data>-data_object_json IS NOT INITIAL.
                      gv_retrieved_data = <ls_step_data>-data_object_json.
                      gv_rep_input_source = 'LOCAL'.

                      CALL SCREEN 8001 STARTING AT 50 5.

                      g_grid_step->set_toolbar_interactive( ). "Trigger again the toolbar to reset the button

                    ENDIF.

                  ENDIF.

                ENDIF.

                RETURN. "Calling update_step_data would impact the manual update of ResultIds in the main ALV

            ENDCASE.


            lo_ptf_step_shift->shift_step_ids_in_table(
              EXPORTING
                iv_row_number          = lv_row_number                 " 4 Byte Signed Integer
                iv_e_ucomm             = e_ucomm                 " ABAP System Field: PAI-Triggering Function Code
              IMPORTING
                ev_adapted_alv_refstep = lb_adapted_alv_refstep
              CHANGING
                ct_outtab_step         = gt_outtab_step
                ct_step_data           = gt_step_data  ).

*        if e_ucomm EQ 'DELETE_ROW' or e_ucomm EQ 'INSERT_ROW'.
*
*          lv_tabix = 1.
*          "GT_STEP_DATA: update step_number and the ITAB reference_step
*          LOOP AT gt_step_data ASSIGNING <ls_step_data>.
*            <ls_step_data>-step_number = lv_tabix.
*            lv_tabix = lv_tabix + 1.
*            IF lv_tabix GT lv_row_number.
*              "current line (which is lv_tabix minus 1) is one that has been moved
*              LOOP AT <ls_step_data>-reference_step ASSIGNING FIELD-SYMBOL(<ls_reference_step>).
*                DATA(lv_ref_step_tabix) = sy-tabix.
*                IF <ls_reference_step> GE lv_row_number.
*                  IF e_ucomm EQ 'INSERT_ROW'.
*                    <ls_reference_step> = <ls_reference_step> + 1.
*                  ELSEIF e_ucomm EQ 'DELETE_ROW'.
*                    IF lv_row_number EQ <ls_reference_step>.
**                      CLEAR <ls_reference_step>.
*                      DELETE <ls_step_data>-reference_step INDEX lv_ref_step_tabix.
*                    ELSE.
*                      <ls_reference_step> = <ls_reference_step> - 1.
*                    ENDIF.
*                  ENDIF.
*                ENDIF.
*              ENDLOOP.
*            ENDIF.
*          ENDLOOP.
*
*
*          lv_tabix = 1.
*          "GT_OUTTAB_STEP: update step_number and the FIELD reference_step
*          LOOP AT gt_outtab_step ASSIGNING <ls_outtab_step>.
*            <ls_outtab_step>-step_number = lv_tabix.
*            lv_tabix = lv_tabix + 1.
*            IF <ls_outtab_step>-reference_step GE lv_row_number.
*              IF e_ucomm EQ 'INSERT_ROW'.
*                <ls_outtab_step>-reference_step = <ls_outtab_step>-reference_step + 1.
*              ELSEIF e_ucomm EQ 'DELETE_ROW'.
*                IF lv_row_number EQ <ls_outtab_step>-reference_step.
*                  READ TABLE gt_step_data ASSIGNING <ls_step_data> WITH KEY step_number = <ls_outtab_step>-step_number.
*                    IF sy-subrc = 0.
*                      IF <ls_step_data>-reference_step IS INITIAL.
*                        CLEAR <ls_outtab_step>-reference_step.
*                      ELSE.
*                        <ls_outtab_step>-reference_step = <ls_step_data>-reference_step[ 1 ].
*                      ENDIF.
*                    ENDIF.
*                ELSE.
*                  <ls_outtab_step>-reference_step = <ls_outtab_step>-reference_step - 1.
*                ENDIF.
*              ENDIF.
*              lb_adapted_alv_refstep = abap_true.
*            ENDIF.
*          ENDLOOP.
*
*        ENDIF.

          ENDIF.

        CATCH cx_root.

      ENDTRY.
    ENDLOOP.


    IF lb_adapted_alv_refstep EQ abap_true AND lv_reference_shifted EQ abap_false.
      MESSAGE ID 'PTF' TYPE 'S' NUMBER 029 DISPLAY LIKE 'W'.
    ELSEIF lb_adapted_alv_refstep EQ abap_false AND lv_reference_shifted EQ abap_true.
      MESSAGE ID 'PTF' TYPE 'S' NUMBER 076 DISPLAY LIKE 'W'.
    ELSEIF lb_adapted_alv_refstep EQ abap_true AND lv_reference_shifted EQ abap_true.
      MESSAGE ID 'PTF' TYPE 'S' NUMBER 077 DISPLAY LIKE 'W'.
    ENDIF.

    PERFORM update_step_data CHANGING gt_step_data.
    g_grid_step->refresh_table_display( ).

  ENDMETHOD.                    "on_button_click

  METHOD on_double_click.

    IF e_column EQ 'VARIANT' OR
      e_column EQ 'ACTION' OR
      e_column EQ 'BUS_OBJ' OR
      e_column EQ 'VARIANT' OR
      e_column EQ 'TEST_DATA_CONTAINER'.
      me->go_to(
        EXPORTING
          es_row_no = es_row_no
        CHANGING
          e_column  = e_column
      ).
    ENDIF.

    IF e_column EQ 'REFERENCE_STEP' OR
*       e_column EQ 'REFERENCE_DOCUMENT_ID' OR
       e_column EQ 'DOCUMENT_ID'.
      CONCATENATE e_column '_MORE' INTO e_column.
    ENDIF.

    IF e_column EQ 'REFERENCE_STEP_MORE' OR
*       e_column EQ 'REFERENCE_DOCUMENT_ID_MORE' OR
       e_column EQ 'DOCUMENT_ID_MORE'.

      CLEAR: gv_row_number, gv_col_id.
      gv_col_id = e_column.
      gv_row_number = es_row_no.
      CALL SCREEN 3001 STARTING AT 50 1.  "Open Multiple entry window fo the specific attribute
    ENDIF.

  ENDMETHOD.


  METHOD button_click.

    CLEAR: gv_row_number, gv_col_id.
    gv_col_id = es_col_id.
    gv_row_number = es_row_no.

    CASE gv_col_id.
      WHEN 'JSON_FILE_MORE'. "Call screen to edit JSON data container
        CLEAR gv_retrieved_data. "Clear JSON data coming from RETRIEVE/RETRIEVE_ALL

        READ TABLE gt_outtab_step ASSIGNING FIELD-SYMBOL(<fs_outtab_step>) INDEX gv_row_number-row_id.
        IF sy-subrc = 0.
          DATA(lo_ptf_rap_metadata) = NEW cl_ptf_rap_metadata( ).
          DATA(lv_is_rap_bo) = lo_ptf_rap_metadata->check_rap_bo( <fs_outtab_step>-bus_obj ).
          IF lv_is_rap_bo = abap_on OR ( <fs_outtab_step>-bus_obj EQ 'MATDOC' AND <fs_outtab_step>-action EQ 'CHECK' ).
            IF <fs_outtab_step>-json_file IS INITIAL.
              gv_json_file = cl_ptf_json=>generate_sample_json( "<fs_outtab_step>-json_file
                                            EXPORTING
                                              iv_ptf_bo   = <fs_outtab_step>-bus_obj
                                              iv_ptf_act  = <fs_outtab_step>-action ).

            ELSE.
              gv_json_file = <fs_outtab_step>-json_file.

            ENDIF.

*           If action is not valid, then issue message
            IF gv_json_file IS INITIAL AND lv_is_rap_bo = abap_on.
              DATA(lv_is_rap_bo_action) = lo_ptf_rap_metadata->check_rap_bo_action(
                iv_bus_obj          = <fs_outtab_step>-bus_obj
                iv_action           = <fs_outtab_step>-action
              ).
              IF lv_is_rap_bo_action = abap_off.
                MESSAGE ID 'PTF' TYPE 'S' NUMBER 086 DISPLAY LIKE 'E' WITH <fs_outtab_step>-action.
                RETURN.

              ENDIF.

            ENDIF.

*           Issue warning message if COMMIT
            IF <fs_outtab_step>-action = 'COMMIT'.
              MESSAGE ID 'PTF' TYPE 'S' NUMBER 090 DISPLAY LIKE 'W'.

            ENDIF.

*           Reset repository
            IF <fs_outtab_step>-variant IS NOT INITIAL.
              gv_rep_input_source = 'ALV'.

              DATA(lo_json_repository) = NEW cl_ptf_json_repository( ).

              TRY.
                  DATA(ls_ptf_input_repo) = lo_json_repository->load( CONV #( <fs_outtab_step>-variant ) ). "p_jsid

                  gv_json_file = ls_ptf_input_repo-input_string.

                CATCH cx_ptf_json_repository INTO DATA(lx_json_repository).
                  MESSAGE s208(00) WITH lx_json_repository->get_text( ) DISPLAY LIKE 'W'.

              ENDTRY.

            ELSE.
              gv_rep_input_source = 'LOCAL'.

            ENDIF.

            PERFORM reset_repository_load.

*           Replace cr_lf with newline otherwise text select gets messed up because PCRE doesn't parse well cr_lf
            gv_json_file = replace( val = gv_json_file sub = cl_abap_char_utilities=>cr_lf with = cl_abap_char_utilities=>newline occ = 0 ).

            CALL SCREEN 8001 STARTING AT 50 5.

          ELSE.
            MESSAGE ID 'PTF' TYPE 'S' NUMBER 064 DISPLAY LIKE 'E'.

          ENDIF.

        ENDIF.

      WHEN OTHERS.
        CALL SCREEN 3001 STARTING AT 50 1.   "Open Multiple entry window for the specific attribute (DOCUMENT_ID_MORE or REFERENCE_STEP_MORE)

    ENDCASE.

  ENDMETHOD.

  METHOD docid_edit.


    DATA: ls_style  TYPE lvc_s_styl,
          ls_stable TYPE lvc_s_stbl.

    ls_style-fieldname = 'DOCUMENT_ID'.
    ls_style-style = cl_gui_alv_grid=>mc_style_enabled.

    READ TABLE gt_outtab_step ASSIGNING FIELD-SYMBOL(<ls_outtab_step>) INDEX es_row_no-row_id.
    IF sy-subrc = 0.
      <ls_outtab_step>-is_manual = abap_true.
      INSERT ls_style INTO TABLE <ls_outtab_step>-handle_style.
      READ TABLE gt_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data>) WITH KEY step_number = <ls_outtab_step>-step_number.
      IF sy-subrc = 0.
        <ls_step_data>-is_manual = abap_true.
      ENDIF.
    ENDIF.

    g_grid_step->refresh_table_display( ).

  ENDMETHOD.

  METHOD go_to.

    DATA lv_changed TYPE abap_bool.
    DATA answer     TYPE string.
    DATA(lv_consider_z_tdc) = abap_false.

    DATA rap_metadata TYPE REF TO cl_ptf_rap_metadata.

    rap_metadata = NEW #( ).

    IF es_row_no-row_id EQ 0.
      RETURN.
    ENDIF.

    PERFORM was_script_changed CHANGING lv_changed.

    READ TABLE gt_outtab_step ASSIGNING FIELD-SYMBOL(<ls_outtab_step>) INDEX es_row_no-row_id.
    CASE e_column.

      WHEN 'VARIANT'.
        IF <ls_outtab_step>-bus_obj IS INITIAL OR <ls_outtab_step>-action IS INITIAL OR <ls_outtab_step>-variant IS INITIAL.
          RETURN.
        ENDIF.

        SELECT SINGLE ptf_tdc FROM ptfboa WHERE ptf_bo = @<ls_outtab_step>-bus_obj AND ptf_act = @<ls_outtab_step>-action INTO @DATA(lv_tdc).
        IF <ls_outtab_step>-test_data_container IS NOT INITIAL.
          "If filled, use this value instead of the default from PTFBOA
          lv_tdc = <ls_outtab_step>-test_data_container.
        ENDIF.

        IF lv_consider_z_tdc EQ abap_true.
          "overwrite lv_tdc with Z-Container if existing
          IF lv_tdc IS NOT INITIAL.
            DATA(lv_z_tdc) = |Z{ lv_tdc } |.
            SELECT SINGLE obj_name FROM tadir INTO @DATA(lv_ztdc_tadir) WHERE pgmid = 'R3TR' AND object = 'ECTD' AND obj_name = @lv_z_tdc .
            IF sy-subrc IS INITIAL AND lv_z_tdc IS NOT INITIAL.
              "but only if the requested TDC variant exists in the Z TDC

              SELECT SINGLE ptf_tdcp FROM ptfboa WHERE ptf_bo = @<ls_outtab_step>-bus_obj AND ptf_act = @<ls_outtab_step>-action INTO @DATA(lv_ztdc_pa).
              IF lv_ztdc_pa IS NOT INITIAL.
                TRY.
                    DATA dummy TYPE c LENGTH 1.  "mapping not possible against C1 field, but here we just want to know whether there is an exception raised, when variant is missing
*                    DATA(mo_access_tdc) TYPE REF TO cl_apl_ecatt_tdc_api.
                    DATA(mo_access_tdc) = cl_apl_ecatt_tdc_api=>get_instance( CONV etobj_name( lv_z_tdc ) ).
                    mo_access_tdc->get_value(
                      EXPORTING
                        i_param_name   = lv_ztdc_pa
                        i_variant_name = CONV #( <ls_outtab_step>-variant )
                      CHANGING
                        e_param_value = dummy
                         ).
                    "navigate to local Z TDC
                    "add new message: "There is a local Z TDC in XXX[ER9] that will be used"
*                    MESSAGE ID 'PTF' TYPE 'S' NUMBER ... DISPLAY LIKE 'W'.
                    lv_tdc = lv_z_tdc.
                  CATCH cx_ecatt_tdc_access INTO DATA(lx).
                    "ignore Z TDC, it does not have this variant
                    CHECK 1 = 1.
                ENDTRY.
              ENDIF.
              "lv_tdc is now filled
            ENDIF.
          ENDIF.
        ENDIF.

        IF lv_tdc IS NOT INITIAL.

          IF lv_changed EQ abap_true OR gs_varhead-just_loaded_from_file EQ abap_true.
            CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
              EXPORTING
                defaultoption  = 'Y'
                textline1      = |You are about to leave the Process Test Framework.|
                textline2      = |You have unsaved changes. Continue?|
                titel          = 'Show Variant'
                cancel_display = ' '
              IMPORTING
                answer         = answer.
          ELSE.
            answer = 'J'.
          ENDIF.

          IF answer EQ 'J'.
            "Get TDC Parameter Name   "NOT WORKING FOR Mock steps yet
            SELECT SINGLE ptf_tdcp FROM ptfboa WHERE ptf_bo = @<ls_outtab_step>-bus_obj AND ptf_act = @<ls_outtab_step>-action INTO @DATA(lv_tdcpa).
            CHECK lv_tdcpa IS NOT INITIAL.

            cl_ptf_navigator=>go_to_tdc_variant(
              EXPORTING
               iv_tdc  = lv_tdc
               iv_tdcp = lv_tdcpa
               iv_tdcv = <ls_outtab_step>-variant
            ).
          ENDIF.

        ENDIF.


      WHEN 'ACTION'.
        IF <ls_outtab_step>-bus_obj IS INITIAL OR <ls_outtab_step>-action IS INITIAL.
          RETURN.
        ENDIF.

        IF lv_changed EQ abap_true OR gs_varhead-just_loaded_from_file EQ abap_true.
          CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
            EXPORTING
              defaultoption  = 'Y'
              textline1      = |You are about to leave the Process Test Framework.|
              textline2      = |You have unsaved changes. Continue?|
              titel          = 'Show Business Object Action Implementation'
              cancel_display = ' '
            IMPORTING
              answer         = answer.
        ELSE.
          answer = 'J'.
        ENDIF.

        IF answer EQ 'J'.
          "Method
          DATA lv_method TYPE ptf_abap_method_name.
          SELECT SINGLE * FROM ptfboa WHERE ptf_bo = @<ls_outtab_step>-bus_obj AND ptf_act = @<ls_outtab_step>-action INTO @DATA(ls_ptfboa).
          IF sy-subrc IS INITIAL AND ls_ptfboa-abap_method IS NOT INITIAL.
            lv_method = ls_ptfboa-abap_method.
          ELSE.
            lv_method = <ls_outtab_step>-action.
          ENDIF.
          "Class
          SELECT SINGLE bo_class FROM ptfbo WHERE ptf_bo = @<ls_outtab_step>-bus_obj INTO @DATA(lv_class).

          IF rap_metadata->check_rap_bo_bdef_action( iv_bus_obj = <ls_outtab_step>-bus_obj iv_action = <ls_outtab_step>-action ) = abap_on.
            cl_ptf_navigator=>go_to_bdef(
              EXPORTING
                new_window = abap_false
                bdef   = <ls_outtab_step>-bus_obj
              ).
          ELSEIF rap_metadata->check_rap_bo( <ls_outtab_step>-bus_obj ) = abap_on.
            cl_ptf_navigator=>go_to_ressource(
              EXPORTING
                resource   = |CL_PTF_BO_RAP_GENERIC=>{ <ls_outtab_step>-action }|
                new_window = abap_false
                ptfboa     = ls_ptfboa
                  ).

          ELSEIF lv_class IS NOT INITIAL.
            cl_ptf_navigator=>go_to_ressource(
            EXPORTING
              resource   = |{ lv_class }=>{ lv_method }|
              new_window = abap_false
              ptfboa     = ls_ptfboa
              ).
          ELSE.
            cl_ptf_navigator=>go_to_ressource(
              EXPORTING
                resource   = |CL_PTF_BO_{ <ls_outtab_step>-bus_obj }=>{ lv_method }|
                new_window = abap_false
                ptfboa     = ls_ptfboa
            ).
          ENDIF.
        ENDIF.


      WHEN 'BUS_OBJ'.
        IF <ls_outtab_step>-bus_obj IS INITIAL.
          RETURN.
        ENDIF.

        IF lv_changed EQ abap_true OR gs_varhead-just_loaded_from_file EQ abap_true.
          CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
            EXPORTING
              defaultoption  = 'Y'
              textline1      = |You are about to leave the Process Test Framework.|
              textline2      = |You have unsaved changes. Continue?|
              titel          = 'Show Business Object Implementation'
              cancel_display = ' '
            IMPORTING
              answer         = answer.
        ELSE.
          answer = 'J'.
        ENDIF.

        IF answer EQ 'J'.
          SELECT SINGLE bo_class FROM ptfbo WHERE ptf_bo = @<ls_outtab_step>-bus_obj INTO @DATA(bo_class_name).

          IF rap_metadata->check_rap_bo( <ls_outtab_step>-bus_obj ) = abap_on.

            cl_ptf_navigator=>go_to_bdef(
              EXPORTING
                new_window = abap_false
                bdef   = <ls_outtab_step>-bus_obj
              ).

          ELSEIF bo_class_name IS NOT INITIAL.
            cl_ptf_navigator=>go_to_ressource(
            EXPORTING
              resource   = |{ bo_class_name }|
              new_window = abap_false
              ).
          ELSE.
            cl_ptf_navigator=>go_to_ressource(
              EXPORTING
                resource   = |CL_PTF_BO_{ <ls_outtab_step>-bus_obj }|
                new_window = abap_false
            ).
          ENDIF.
        ENDIF.


      WHEN 'TEST_DATA_CONTAINER'.
        IF <ls_outtab_step>-test_data_container IS INITIAL.
          RETURN.
        ENDIF.

        IF lv_changed EQ abap_true OR gs_varhead-just_loaded_from_file EQ abap_true.
          CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
            EXPORTING
              defaultoption  = 'Y'
              textline1      = |You are about to leave the Process Test Framework.|
              textline2      = |You have unsaved changes. Continue?|
              titel          = 'Show Testdata Container'
              cancel_display = ' '
            IMPORTING
              answer         = answer.
        ELSE.
          answer = 'J'.
        ENDIF.

        IF answer EQ 'J'.
          cl_ptf_navigator=>go_to_ressource(
          EXPORTING
            resource   = |{ <ls_outtab_step>-test_data_container }|
            new_window = abap_false
          ).
        ENDIF.


      WHEN OTHERS.
        RETURN.
    ENDCASE.

  ENDMETHOD.

  METHOD show_usage_of.

    DATA: lt_usage            TYPE TABLE OF ptf_selection WITH DEFAULT KEY,
          ls_selected_variant TYPE ptf_selection,
          lv_selected_line    TYPE i VALUE 0,
          answer              TYPE string,
          l_text_table        TYPE TABLE OF ptf_text.

    IF es_row_no-row_id EQ 0.
      RETURN.
    ENDIF.
    READ TABLE gt_outtab_step ASSIGNING FIELD-SYMBOL(<ls_outtab_step>) INDEX es_row_no-row_id.

    CASE e_column.
      WHEN 'VARIANT'.
        IF <ls_outtab_step>-bus_obj IS INITIAL OR <ls_outtab_step>-action IS INITIAL OR <ls_outtab_step>-variant IS INITIAL.
          RETURN.
        ENDIF.
        lt_usage = cl_ptf_usage=>get_usage_of_variant(
          EXPORTING
            bo         = |{ <ls_outtab_step>-bus_obj }|
            action     = |{ <ls_outtab_step>-action }|
            variant    = |{ <ls_outtab_step>-variant }|
        ).
      WHEN 'ACTION'.
        IF <ls_outtab_step>-bus_obj IS INITIAL OR <ls_outtab_step>-action IS INITIAL.
          RETURN.
        ENDIF.
        lt_usage = cl_ptf_usage=>get_usage_of_bo_action(
        EXPORTING
           bo         = |{ <ls_outtab_step>-bus_obj }|
           action     = |{ <ls_outtab_step>-action }|
         ).
      WHEN 'BUS_OBJ'.
        IF <ls_outtab_step>-bus_obj IS INITIAL.
          RETURN.
        ENDIF.
        lt_usage = cl_ptf_usage=>get_usage_of_bo(
        EXPORTING
           bo         = |{ <ls_outtab_step>-bus_obj }|
         ).
      WHEN 'TEST_DATA_CONTAINER'.
        IF <ls_outtab_step>-bus_obj IS INITIAL OR <ls_outtab_step>-action IS INITIAL OR <ls_outtab_step>-variant IS INITIAL.
          RETURN.
        ENDIF.
        lt_usage = cl_ptf_usage=>get_usage_of_tdc(
          EXPORTING
            bo         = |{ <ls_outtab_step>-bus_obj }|
            action     = |{ <ls_outtab_step>-action }|
            tdc        = |{ <ls_outtab_step>-test_data_container }|
        ).
      WHEN OTHERS.
        RETURN.
    ENDCASE.

    "Call popup with variants
    DATA variant_display TYPE REF TO cl_ptf_alv_elements.
    variant_display = NEW cl_ptf_alv_elements( ).
    TRY.
        variant_display->show_list_of_variants(
          CHANGING
            usages    = lt_usage
          RECEIVING
            selection = ls_selected_variant
        ).
      CATCH cx_salv_msg.
        MESSAGE ID 'PTF' TYPE 'S' NUMBER 044 DISPLAY LIKE 'E'.
    ENDTRY.

    CHECK ls_selected_variant IS NOT INITIAL.
    ASSERT ls_selected_variant-varname IS NOT INITIAL.

    CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
      EXPORTING
        defaultoption  = 'Y'
        textline1      = |You are about to load Script { ls_selected_variant-varname }.|
        textline2      = |Current changes will be lost. Continue?|
        titel          = 'Load Script'
        cancel_display = ' '
      IMPORTING
        answer         = answer.

    CHECK answer EQ 'J'.

    go_variant->read(
     EXPORTING
       iv_varname     = ls_selected_variant-varname
     IMPORTING
       et_variant_tab = gt_variant_tab
       et_varcat      = l_text_table
       et_vardataset  = gt_outtab_vardataset ).

    gt_text_table = l_text_table.
    PERFORM move_data_to_alv.
    CALL METHOD g_grid_step->refresh_table_display( ).
    CLEAR gv_script_was_changed.
    CLEAR gs_varhead.
    "Fill script attributes
    MOVE-CORRESPONDING ls_selected_variant TO gs_varhead.
    cl_gui_cfw=>set_new_ok_code( new_code = 'REFR' ).

  ENDMETHOD.

  METHOD show_config_of.

    DATA: filter   TYPE cl_ptf_navigator=>se16n_seltabs,
          criteria TYPE se16n_seltab,
          answer   TYPE string.

    IF es_row_no-row_id EQ 0.
      RETURN.
    ENDIF.

    READ TABLE gt_outtab_step ASSIGNING FIELD-SYMBOL(<ls_outtab_step>) INDEX es_row_no-row_id.
*    CHECK <ls_outtab_step>-bus_obj IS NOT INITIAL.
*    CHECK NOT NEW cl_ptf_rap_metadata( )->check_rap_bo( <ls_outtab_step>-bus_obj ). "stop for RAO BO - will mostly not have configuration. strange exit from transaction occured one roundtrip later if no record was found.

    CASE e_column.
      WHEN 'ACTION'.
        CLEAR criteria.
        CLEAR filter.
        criteria-field = 'PTF_BO'.
        criteria-sign = 'I'.
        criteria-option = 'EQ'.
        criteria-low = <ls_outtab_step>-bus_obj.
        APPEND criteria TO filter.
        CLEAR criteria.
        criteria-field = 'PTF_ACT'.
        criteria-sign = 'I'.
        criteria-option = 'EQ'.
        criteria-low = <ls_outtab_step>-action.
        APPEND criteria TO filter.
        CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
          EXPORTING
            defaultoption  = 'Y'
            textline1      = |You are about to leave the Process Test Framework.|
            textline2      = |Continue?|
            titel          = 'Show Business Object Action Configuration'
            cancel_display = ' '
          IMPORTING
            answer         = answer.

        IF answer EQ 'J'.
          cl_ptf_navigator=>go_to_config(
          EXPORTING
            config_table = 'PTFBOA'
            filter       = filter
          ).
        ENDIF.

      WHEN 'BUS_OBJ'.
        CLEAR criteria.
        CLEAR filter.
        criteria-field = 'PTF_BO'.
        criteria-sign = 'I'.
        criteria-option = 'EQ'.
        criteria-low = <ls_outtab_step>-bus_obj.
        APPEND criteria TO filter.
        CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
          EXPORTING
            defaultoption  = 'Y'
            textline1      = |You are about to leave the Process Test Framework.|
            textline2      = |Continue?|
            titel          = 'Show Business Object Configuration'
            cancel_display = ' '
          IMPORTING
            answer         = answer.

        IF answer EQ 'J'.
          cl_ptf_navigator=>go_to_config(
          EXPORTING
            config_table = 'PTFBO'
            filter       = filter
          ).
        ENDIF.

      WHEN OTHERS.
        RETURN.
    ENDCASE.

  ENDMETHOD.

  METHOD refresh_buttons. "also refreshes the style of 2 columns

    DATA ls_stable TYPE lvc_s_stbl.

    DATA(lo_ptf_rap_metadata) = NEW cl_ptf_rap_metadata( ).
    DATA(lv_is_rap_bo) = lo_ptf_rap_metadata->check_rap_bo( iv_bus_obj = cs_outtab_step-bus_obj ).

    LOOP AT cs_outtab_step-handle_style ASSIGNING FIELD-SYMBOL(<fs_handle_style>).

      CASE <fs_handle_style>-fieldname.

        WHEN 'JSON_FILE_MORE'.
          IF lv_is_rap_bo EQ abap_off  AND  NOT ( cs_outtab_step-bus_obj EQ 'MATDOC' AND cs_outtab_step-action EQ 'CHECK' ).
            "Non RAP BO

            "Raise message if BO is not known
            IF cs_outtab_step-bus_obj IS NOT INITIAL.
              "Check BO existence
              SELECT SINGLE * FROM ptfbo INTO @DATA(ls_ptfbo_dummy) WHERE ptf_bo = @cs_outtab_step-bus_obj.
              IF sy-subrc IS NOT INITIAL.
                MESSAGE ID 'PTF' TYPE 'S' NUMBER 012 WITH cs_outtab_step-step_number DISPLAY LIKE 'E'.
                CONSTANTS lc_column_bo TYPE lvc_fname VALUE 'BUS_OBJ'.
                DATA:
                  lt_cell_with_error TYPE lvc_t_cell,
                  ls_cell            TYPE lvc_s_cell.
                ls_cell-col_id-fieldname = lc_column_bo.
                ls_cell-row_id-index     = cs_outtab_step-step_number.
                APPEND ls_cell TO lt_cell_with_error.
              ENDIF.
            ENDIF.

            "Non RAP BO - Disable the button
            CLEAR <fs_handle_style>-style. "clearing seems to have the same effect like setting cl_gui_alv_grid=>mc_style_disabled
*              <fs_handle_style>-style2 = cl_gui_alv_grid=>mc_style_disabled.

            cs_outtab_step-json_file_more = icon_text_ina.

            CLEAR cs_outtab_step-json_file.  "toDO: safer to keep json_file content??

          ELSE.
            "RAP BO - Enable the button
            <fs_handle_style>-style = cl_gui_alv_grid=>mc_style_button.  "seems to have the same effect like  <fs_handle_style>-style = cl_gui_alv_grid=>mc_style_ENABLED formerly in on_data_changed

          ENDIF.

        WHEN 'VARIANT' OR 'TEST_DATA_CONTAINER'. "Disable columns VARIANT and TEST_DATA_CONTAINER if JSON is local
          IF ( NOT cs_outtab_step-json_file IS INITIAL      AND  NOT ( cs_outtab_step-bus_obj EQ 'MATDOC' AND cs_outtab_step-action EQ 'CHECK' ) )
            OR ( cs_outtab_step-bus_obj = 'PTF_RUN' AND cs_outtab_step-action = 'CHECK_MESSAGES' ).
            <fs_handle_style>-style = cl_gui_alv_grid=>mc_style_disabled.

          ELSE.
            <fs_handle_style>-style = cl_gui_alv_grid=>mc_style_enabled.

          ENDIF.

      ENDCASE.

    ENDLOOP.

*   Fix focus loss
    ls_stable-row = abap_on.
    ls_stable-col = abap_on.

    g_grid_step->refresh_table_display( EXPORTING is_stable = ls_stable ).

    IF lt_cell_with_error IS NOT INITIAL.
      g_grid_step->set_selected_cells( it_cells = lt_cell_with_error ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
