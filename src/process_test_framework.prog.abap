*&---------------------------------------------------------------------*
*& Report PTF_INPUT_UI
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT process_test_framework.

*INCLUDE process_test_framework_sel_scr.   " Input Screen building
*DATA ls_cursor TYPE cl_ptf_util=>gty_sel_screen.
*DATA lv_error TYPE abap_bool VALUE abap_false.
*DATA ls_cursor_delete TYPE cl_ptf_util=>gty_sel_screen.
************************************************************************************************************
*AT SELECTION-SCREEN OUTPUT.
*
*  APPEND INITIAL LINE TO lt_exclude ASSIGNING FIELD-SYMBOL(<ls_exclude>).
*  CALL FUNCTION 'RS_SET_SELSCREEN_STATUS'
*    EXPORTING
*      p_status  = 'PTF_STATUS'  " Status To Be Set
*      p_program = space    " Program to which the status belongs
*    TABLES
*      p_exclude = lt_exclude.  " Table of OK codes to be excluded
*
** Mark the fields for storing
*  CLEAR: field_value, dynpro_values.
**  field_value-fieldname = lc_bofield.
**  APPEND field_value TO dynpro_values.
**  field_value-fieldname = lc_actfield.
**  APPEND field_value TO dynpro_values.
**  field_value-fieldname =   lc_testfield.
**  APPEND field_value TO dynpro_values.
*  DO 10 TIMES.
*    lv_suffix = sy-index.
*    CONCATENATE lc_bofield lv_suffix INTO field_value-fieldname.
*    CONDENSE field_value-fieldname.
*    APPEND field_value TO dynpro_values.
*    CONCATENATE lc_actfield lv_suffix INTO field_value-fieldname.
*    CONDENSE field_value-fieldname.
*    APPEND field_value TO dynpro_values.
*    CONCATENATE lc_testfield lv_suffix INTO field_value-fieldname.
*    CONDENSE field_value-fieldname.
*    APPEND field_value TO dynpro_values.
*  ENDDO.
*
*  IMPORT s1 = lt_step_data  FROM MEMORY ID 'ptf_lt_step_data'.
*  CLEAR lt_data_delete.
*  EXPORT s1 = lt_data_delete TO MEMORY ID 'ptf_lt_step_data'.
*
*  PERFORM set_output.
*  IMPORT s1 = lv_error  FROM MEMORY ID 'ptf_lv_error'.
*  EXPORT s1 = abap_false TO MEMORY ID 'ptf_lv_error'.
*
*  IMPORT s1 = ls_cursor FROM MEMORY ID 'ptf_ls_cursor'.
*  CLEAR ls_cursor_delete.
*  EXPORT s1 = ls_cursor_delete TO MEMORY ID 'ptf_ls_cursor'.
*  IF lv_error = abap_true.
*    DATA(lv_cursor) = cl_ptf_util=>set_cursor( ls_cursor ).
*    SET CURSOR FIELD lv_cursor.
*  ENDIF.
*
*
************************************************************************************************************
*AT SELECTION-SCREEN.
*  PERFORM read_ptf_input_data.                 " Check wether the input data is valid
*  PERFORM input_value_check USING lt_step_data.
*  CLEAR lt_step_data.
*
*  IF sy-ucomm = 'AP_LOG'.
*    PERFORM ap_log.
*  ENDIF.
*
*
************************************************************************************************************
*START-OF-SELECTION.
*
*  CLEAR lt_return.
*  EXPORT s1 = lt_return TO MEMORY ID 'ptf_lt_return'.
*  DATA lv_step TYPE string.
*  PERFORM read_ptf_input_data.
*  PERFORM input_value_check USING lt_step_data.
*  PERFORM fill_check_flag.
*
*  lv_log_rcode = 0.
*  LOOP AT lt_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data>).
*    IF <ls_step_data>-action   IS NOT INITIAL
*    AND <ls_step_data>-bus_obj IS NOT INITIAL.
**    AND <ls_step_data>-variant   IS NOT INITIAL
**    OR  <ls_step_data>-reference_step  IS NOT INITIAL.
*      DATA lr_bo TYPE REF TO object.
*      cl_ptf_util=>do_preperation(
*          CHANGING
*           is_step_data = <ls_step_data>
*           it_step_data = lt_step_data
*           it_return    = lt_return
*         RECEIVING
*           rt_parameter = DATA(lt_parameter) ).
*      lv_step = <ls_step_data>-step_number.
*      CONCATENATE 'Step ' lv_step ':' INTO DATA(lv_step_number).
*      APPEND VALUE #( id = lv_step_number message = '************************************' ) TO lt_return.
*      CONCATENATE  lc_prefix_class <ls_step_data>-bus_obj INTO DATA(lv_object).
*      CREATE OBJECT lr_bo TYPE (lv_object).
*
*      IF <ls_step_data>-action EQ lc_create OR <ls_step_data>-action EQ lc_change OR <ls_step_data>-action EQ lc_delete OR
*         <ls_step_data>-action EQ lc_check.
*        CONCATENATE lc_prefix_method <ls_step_data>-action INTO lv_action.
*      ELSE.
*        IF <ls_step_data>-check_flag IS NOT INITIAL.
*          CONCATENATE lc_prefix_method 'EXECUTE_CHECK' INTO lv_action.
*        ELSE.
*          CONCATENATE lc_prefix_method 'EXECUTE_ACTION' INTO lv_action.
*        ENDIF.
*      ENDIF.
*      CALL METHOD lr_bo->(lv_action)
*        PARAMETER-TABLE
*        lt_parameter.
*
*      CLEAR: lt_parameter.
*      IF <ls_step_data>-execution_status EQ abap_false AND <ls_step_data>-action EQ lc_check.
*        lv_log_rcode = 1.
*        EXIT.
*      ENDIF.
*    ENDIF.
*  ENDLOOP.
*
*  EXPORT s1 = lt_step_data TO MEMORY ID  'ptf_lt_step_data'.
*  EXPORT s1 = lt_return    TO MEMORY ID  'ptf_lt_return'.
*  EXPORT s1 = lv_error TO MEMORY ID 'ptf_lv_error'.
*  EXPORT s1 = ls_cursor TO MEMORY ID 'ptf_ls_cursor'.
*
*
*  IF lv_log_rcode EQ 0.
*    lv_ecatt_comment = 'Test ended successful.'.
*  ELSE.
*    lv_ecatt_comment = 'Test failed.'.
*  ENDIF.
*
*  LOOP AT lt_return INTO ls_return.
*    CONCATENATE ls_return-type ls_return-id ls_return-number ls_return-message
*    INTO ls_ecatt_log-row SEPARATED BY space.
*    APPEND ls_ecatt_log TO lt_ecatt_log.
*  ENDLOOP.
*
*  cl_ptf_test_wrapper=>set_result(
*    EXPORTING
*      iv_rcode       = lv_log_rcode
*      iv_log_comment = lv_ecatt_comment
*      it_ptf_log     = lt_ecatt_log ).
*
*
*
************************************************************************************************************
** F4 help and validation of the input data.
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_act1.
*  PERFORM f4_help_test USING '1' 'A'.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_act2.
*  PERFORM f4_help_test USING '2' 'A'.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_act3.
*  PERFORM f4_help_test USING '3' 'A'.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_act4.
*  PERFORM f4_help_test USING '4' 'A'.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_act5.
*  PERFORM f4_help_test USING '5' 'A'.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_act6.
*  PERFORM f4_help_test USING '6' 'A'.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_act7.
*  PERFORM f4_help_test USING '7' 'A'.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_act8.
*  PERFORM f4_help_test USING '8' 'A'.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_act9.
*  PERFORM f4_help_test USING '9' 'A'.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_act10.
*  PERFORM f4_help_test USING '10' 'A'.
***************************************************************
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_test1.
*  PERFORM f4_help_test USING '1' 'V'.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_test2.
*  PERFORM f4_help_test USING '2' 'V'.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_test3.
*  PERFORM f4_help_test USING '3' 'V'.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_test4.
*  PERFORM f4_help_test USING '4' 'V'.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_test5.
*  PERFORM f4_help_test USING '5' 'V'.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_test6.
*  PERFORM f4_help_test USING '6' 'V'.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_test7.
*  PERFORM f4_help_test USING '7' 'V'.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_test8.
*  PERFORM f4_help_test USING '8' 'V'.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_test9.
*  PERFORM f4_help_test USING '9' 'V'.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_test10.
*  PERFORM f4_help_test USING '10' 'V'.
*
*
************************************************************************************************************
*FORM f4_help_test USING lv_suffix_help lv_fieldhelp.
*
*  DATA: lv_fieldname TYPE dynfnam.
*
*  CALL FUNCTION 'DYNP_VALUES_READ'
*    EXPORTING
*      dyname             = sy-cprog
*      dynumb             = sy-dynnr
*      translate_to_upper = 'X'
*    TABLES
*      dynpfields         = dynpro_values.
*
** Read BO with suffix
*  CONCATENATE lc_bofield lv_suffix_help INTO lv_fieldname.
*  CONDENSE lv_fieldname.
*
*  READ TABLE dynpro_values INTO field_value WITH KEY fieldname = lv_fieldname.
*  IF sy-subrc = 0.
*    ls_f4help-bo = field_value-fieldvalue.
*  ENDIF.
** Read action with suffix
*  CONCATENATE lc_actfield lv_suffix_help INTO lv_fieldname.
*  CONDENSE lv_fieldname.
*
*  READ TABLE dynpro_values INTO field_value WITH KEY fieldname = lv_fieldname.
*  IF sy-subrc = 0.
*    ls_f4help-act = field_value-fieldvalue.
*  ENDIF.
*
** Read TDCV with suffix
*  CONCATENATE lc_testfield lv_suffix_help INTO lv_fieldname.
*  CONDENSE lv_fieldname.
*
*  READ TABLE dynpro_values INTO field_value WITH KEY fieldname = lv_fieldname.
*  IF sy-subrc = 0.
*    ls_f4help-varid = field_value-fieldvalue.
*  ENDIF.
*
*  DATA lo_cl_ptf_util_f4 TYPE REF TO cl_ptf_util.
*
*  IF ls_f4help-bo IS NOT INITIAL AND ls_f4help-act IS NOT INITIAL AND lv_fieldhelp EQ 'V'.
*    CLEAR: lv_ptf_tdcp,lt_f4help, lt_ectd_data.
**    SELECT SINGLE ptf_tdcp FROM ptfboa INTO lv_ptf_tdcp WHERE ptf_bo = ls_f4help-bo AND ptf_act = ls_f4help-act.
*    SELECT SINGLE ptf_tdc FROM ptfboa INTO lv_ptf_tdc WHERE ptf_bo = ls_f4help-bo AND ptf_act = ls_f4help-act.
*
*    IF lv_ptf_tdc IS NOT INITIAL.
*      CREATE OBJECT lo_cl_ptf_util_f4
*        EXPORTING
*          iv_bo     = ls_f4help-bo " Business Object for Process Test Framework
*          iv_action = ls_f4help-act.    " Process Test Framework Action
*      DATA(lv_tdcp_name) = lo_cl_ptf_util_f4->get_tdcp_name( ).
*      DATA(lv_tdc_name) = lo_cl_ptf_util_f4->get_tdc_name( ).
*** Check which TDC Variants fill the given Paramters
*      SELECT * FROM ectd_data INTO TABLE lt_ectd_data WHERE name = lv_tdc_name AND pname = lv_tdcp_name .
*      LOOP AT lt_ectd_data ASSIGNING <ls_ectd_data>.
*        IF <ls_ectd_data>-varid NE lc_ecattdefault_varid.
*          ls_f4help-varid = <ls_ectd_data>-varid.
**        read the description and add it to the f4-help.
*          SELECT * FROM ectd_text_n INTO ls_ectd_text_n WHERE pname = <ls_ectd_data>-varid.
*          ENDSELECT.
*          IF NOT ls_ectd_text_n IS INITIAL.
*            ls_f4help-desc = ls_ectd_text_n-pdesc.
*          ENDIF.
*          APPEND ls_f4help TO lt_f4help.
*        ENDIF.
*      ENDLOOP.
*      CLEAR ls_f4help.
*    ENDIF.
**   Set fieldname to test with suffix
*    CONCATENATE lc_testfield lv_suffix_help INTO lv_fieldname.
*    CONDENSE lv_fieldname.
*    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*      EXPORTING
*        retfield        = 'VARID'
*        dynpprog        = sy-cprog
*        dynpnr          = sy-dynnr
*        dynprofield     = lv_fieldname
*        value_org       = 'S'
*      TABLES
*        value_tab       = lt_f4help
*      EXCEPTIONS
*        parameter_error = 1
*        no_values_found = 2
*        OTHERS          = 3.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.
*
*  ELSEIF ls_f4help-bo IS NOT INITIAL AND lv_fieldhelp = 'A'.
*    CLEAR: lt_ptfboa,lt_f4help.
*    SELECT * FROM ptfboa INTO TABLE lt_ptfboa WHERE ptf_bo = ls_f4help-bo.
*** Check which Actions exist for the BO
*    LOOP AT lt_ptfboa ASSIGNING <ls_ptfboa>.
*      ls_f4help-act = <ls_ptfboa>-ptf_act.
*      APPEND ls_f4help TO lt_f4help.
*    ENDLOOP.
*    CLEAR ls_f4help.
**   Set fieldname to test with suffix
*    CONCATENATE lc_actfield lv_suffix_help INTO lv_fieldname.
*    CONDENSE lv_fieldname.
*    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*      EXPORTING
*        retfield        = 'ACT'
*        dynpprog        = sy-cprog
*        dynpnr          = sy-dynnr
*        dynprofield     = lv_fieldname
*        value_org       = 'S'
*      TABLES
*        value_tab       = lt_f4help
*      EXCEPTIONS
*        parameter_error = 1
*        no_values_found = 2
*        OTHERS          = 3.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.
*  ENDIF.
*ENDFORM.
*
*
************************************************************************************************************
*FORM input_value_check USING it_step_data TYPE cl_ptf_util=>gt_ptf_step_tab.
*  DATA: lv_bo         TYPE ptfboa-ptf_bo,
*        lv_act        TYPE ptfboa-ptf_act,
*        lv_test       TYPE string,
*        lv_tdcp       TYPE pname,
*        lv_step       TYPE c LENGTH 1,
*        lt_data_proof TYPE TABLE OF cl_ptf_util=>gt_ptf_step.
*
*  MOVE it_step_data TO lt_data_proof.
*
*
*  LOOP AT lt_data_proof ASSIGNING FIELD-SYMBOL(<ls_data_proof>).
** Empty lines should be ignored.
*    IF <ls_data_proof>-action IS NOT INITIAL
*     OR <ls_data_proof>-bus_obj IS NOT INITIAL
*     OR <ls_data_proof>-reference_step  IS NOT INITIAL
*     OR <ls_data_proof>-variant IS NOT INITIAL.
*
*      IF <ls_data_proof>-bus_obj IS INITIAL.
*        ls_cursor-ptf_bo = 'X'.
*        ls_cursor-ptf_var_step = <ls_data_proof>-step_number .
*        lv_error = abap_true.
*        MESSAGE ID 'PTF' TYPE 'S' NUMBER 011 WITH <ls_data_proof>-step_number  DISPLAY LIKE 'E'.
*        CLEAR lt_step_data.
*        RETURN.
*      ENDIF.
*
** Check that an action to a business object is given
*      IF <ls_data_proof>-bus_obj IS NOT INITIAL.
*        IF <ls_data_proof>-action IS INITIAL.
*          ls_cursor-ptf_bo = 'X'.
*          ls_cursor-ptf_var_step = <ls_data_proof>-step_number.
*          lv_error = abap_true.
*          MESSAGE ID 'PTF' TYPE 'S' NUMBER 010 WITH <ls_data_proof>-bus_obj <ls_data_proof>-step_number DISPLAY LIKE 'E'.
*          RETURN.
*        ENDIF.
*      ENDIF.
*
** Get name and category for the test data container.
*      cl_ptf_util=>get_name_tdc(
*        EXPORTING
*          iv_bo       =    <ls_data_proof>-bus_obj
*          iv_action   =    <ls_data_proof>-action
*        IMPORTING
*          eo_name_tdc =     DATA(lo_name_tdc)
*      ).
*
*      DATA(lv_category) = cl_ptf_util=>get_tdc_category( iv_tdc_name = lo_name_tdc ).
*      CASE lv_category.
*        WHEN 'OL' OR 'RG' OR 'CHECK'.
*          IF <ls_data_proof>-action NE 'DELETE'
*         AND <ls_data_proof>-action NE 'EXECUTE_ACTION'
*         AND <ls_data_proof>-variant IS INITIAL.
*            ls_cursor-ptf_tdcv = 'X'.
*            ls_cursor-ptf_var_step = <ls_data_proof>-step_number .
*            lv_error = abap_true.
*            MESSAGE ID 'PTF' TYPE 'S' NUMBER 007 WITH <ls_data_proof>-step_number  DISPLAY LIKE 'E'.
*            CLEAR lt_step_data.
*            RETURN.
*          ENDIF.
**       'BD' taken out of check, because EBDR does not need a reference step --> to be checked how to be refined
*        WHEN 'DL' OR 'AC' OR 'CHECK'  ##WHEN_DOUBLE_OK..
*          IF <ls_data_proof>-reference_step IS INITIAL.
*            ls_cursor-ptf_ref_step = 'X'.
*            ls_cursor-ptf_var_step = <ls_data_proof>-step_number .
*            lv_error = abap_true.
*            MESSAGE ID 'PTF' TYPE 'S' NUMBER 006 WITH <ls_data_proof>-step_number  DISPLAY LIKE 'E'.
*            CLEAR lt_step_data.
*            RETURN.
*          ENDIF.
*      ENDCASE.
**** check if the reference step is valid ********
*      IF <ls_data_proof>-reference_step IS NOT INITIAL.
*        IF <ls_data_proof>-reference_step[ 1 ] = 0.
*          ls_cursor-ptf_ref_step = 'X'.
*          ls_cursor-ptf_var_step = <ls_data_proof>-step_number .
*          lv_error = abap_true.
*          MESSAGE ID 'PTF' TYPE 'S' NUMBER 002 WITH <ls_data_proof>-step_number  DISPLAY LIKE 'E'.
*          SET CURSOR FIELD <ls_data_proof>-bus_obj OFFSET <ls_data_proof>-step_number.
*          CLEAR lt_step_data.
*          RETURN.
*        ENDIF.
*      ENDIF.
*
**** Check that Invoice is not the first step *******************************
*      IF <ls_data_proof>-step_number  = 1.
*        IF <ls_data_proof>-bus_obj = 'INVOICE'. "Hier muss man mal noch schauen
*          ls_cursor-ptf_ref_step = 'X'.
*          ls_cursor-ptf_var_step = <ls_data_proof>-step_number .
*          lv_error = abap_true.
*          MESSAGE ID 'PTF' TYPE 'S' NUMBER 003 WITH <ls_data_proof>-bus_obj DISPLAY LIKE 'E'.
*          CLEAR lt_step_data.
*          RETURN.
*        ENDIF.
*      ENDIF.
*
*      IF  <ls_data_proof>-action IS NOT INITIAL
*      AND <ls_data_proof>-action NE lc_create
*        AND <ls_data_proof>-action NE 'CREATEFROMPROJECT'
*      AND <ls_data_proof>-reference_step IS INITIAL.
*        ls_cursor-ptf_ref_step = 'X'.
*        ls_cursor-ptf_var_step = <ls_data_proof>-step_number.
*        lv_error = abap_true.
*        MESSAGE ID 'PTF' TYPE 'S' NUMBER 005 WITH <ls_data_proof>-bus_obj <ls_data_proof>-action <ls_data_proof>-step_number DISPLAY LIKE 'E'.
*        CLEAR lt_step_data.
*        RETURN.
*      ENDIF.
*** Check if business object is valid ***************
*      SELECT SINGLE ptf_bo FROM ptfbo INTO lv_bo WHERE ptf_bo = <ls_data_proof>-bus_obj.
*      IF sy-subrc <> 0.
*        ls_cursor-ptf_bo = 'X'.
*        ls_cursor-ptf_var_step = <ls_data_proof>-step_number.
*        lv_error = abap_true.
*        MESSAGE ID 'PTF' TYPE 'S' NUMBER 012 WITH <ls_data_proof>-step_number DISPLAY LIKE 'E'.
*        CLEAR lt_step_data.
*        RETURN.
*      ENDIF.
*** Check if the combination of BO and Action is valid *******************************************
*      SELECT SINGLE ptf_act FROM ptfboa INTO lv_act WHERE ptf_act = <ls_data_proof>-action  AND ptf_bo = <ls_data_proof>-bus_obj.
*      IF sy-subrc <> 0.
*        lv_step = <ls_data_proof>-step_number.
*        ls_cursor-ptf_act = 'X'.
*        ls_cursor-ptf_var_step = <ls_data_proof>-step_number.
*        lv_error = abap_true.
*        CONCATENATE 'Step:' lv_step 'Entered Action is incorrect, incomplete or does not correspond to the entered Business Object'  INTO DATA(msg_er_act) SEPARATED BY space.
*        MESSAGE msg_er_act TYPE 'S' DISPLAY LIKE 'E'.
*        CLEAR lt_step_data.
*        RETURN.
*      ENDIF.
*** Check wether the comination of Business object, action and tdcv is valid **********************
*      IF <ls_data_proof>-variant IS NOT INITIAL.
*        SELECT SINGLE ptf_tdcp FROM ptfboa INTO lv_tdcp WHERE ptf_act = <ls_data_proof>-action  AND ptf_bo = <ls_data_proof>-bus_obj.
*        SELECT SINGLE varid FROM ectd_data INTO lv_test WHERE varid = <ls_data_proof>-variant AND pname = lv_tdcp.
*        IF sy-subrc <> 0.
*          lv_step = <ls_data_proof>-step_number.
*          ls_cursor-ptf_tdcv = 'X'.
*          ls_cursor-ptf_var_step = <ls_data_proof>-step_number.
*          lv_error = abap_true.
*          CONCATENATE 'Step:' lv_step 'Entered Testdata Container V is incorrect, incomplete or does not correspond to the entered Business Object and Action'  INTO DATA(msg_er_test) SEPARATED BY space.
*          MESSAGE msg_er_test TYPE 'S' DISPLAY LIKE 'E'.
*          CLEAR lt_step_data.
*          RETURN.
*        ENDIF.
*      ENDIF.
*
*      IF <ls_data_proof>-variant IS INITIAL.
*        SELECT SINGLE ptf_tdcp FROM ptfboa INTO lv_tdcp WHERE ptf_act = <ls_data_proof>-action  AND ptf_bo = <ls_data_proof>-bus_obj.
*        IF lv_tdcp IS NOT INITIAL.
*          ls_cursor-ptf_tdcv = 'X'.
*          ls_cursor-ptf_var_step = <ls_data_proof>-step_number .
*          lv_error = abap_true.
*          MESSAGE ID 'PTF' TYPE 'S' NUMBER 007 WITH <ls_data_proof>-step_number  DISPLAY LIKE 'E'.
*          CLEAR lt_step_data.
*          RETURN.
*        ENDIF.
*      ENDIF.
*
**      IF <ls_data_proof>-variant IS INITIAL
**      AND <ls_data_proof>-reference_step IS INITIAL.
**        ls_cursor-ptf_ref_step = 'X'.
**        ls_cursor-ptf_var_step = <ls_data_proof>-step_number .
**        lv_error = abap_true.
**        MESSAGE ID 'PTF' TYPE 'S' NUMBER 013 WITH <ls_data_proof>-step_number DISPLAY LIKE 'E'.
**        CLEAR lt_step_data.
**        RETURN.
**
**      ENDIF.
*
*    ENDIF.
*  ENDLOOP.
*
*ENDFORM.
*
*
*
************************************************************************************************************
*FORM read_ptf_input_data.
**  IF lv_error NE abap_true.
*  gv_step = 1.
*  CLEAR lt_step_data.
*  CLEAR ls_step_data.
*
*  ls_step_data-bus_obj    = p_bo1.
*  ls_step_data-action     = p_act1.
*  ls_step_data-variant       = p_test1.
**  ls_step_data-vo_bo      = cl_ptf_util=>get_split( iv_step_to_split = p_vo_bo1 iv_table_index = gv_step ).
*  ls_step_data-step_number   = gv_step.
*  APPEND ls_step_data TO lt_step_data.
*
*
*  CLEAR ls_step_data.
*  ADD 1 TO gv_step.
*
*  ls_step_data-bus_obj    = p_bo2.
*  ls_step_data-action     = p_act2.
*  ls_step_data-variant      = p_test2.
*  ls_step_data-reference_step     = cl_ptf_util=>get_split( iv_step_to_split = p_vo_bo2 iv_table_index = gv_step ).
*  ls_step_data-step_number   = gv_step.
*  APPEND ls_step_data TO lt_step_data.
*
*
*  CLEAR ls_step_data.
*  ADD 1 TO gv_step.
*
*  ls_step_data-bus_obj    = p_bo3.
*  ls_step_data-action     = p_act3.
*  ls_step_data-variant       = p_test3.
*  ls_step_data-reference_step    = cl_ptf_util=>get_split( iv_step_to_split = p_vo_bo3 iv_table_index = gv_step ).
*  ls_step_data-step_number   = gv_step.
*  APPEND ls_step_data TO lt_step_data.
*
*
*  CLEAR ls_step_data.
*  ADD 1 TO gv_step.
*
*  ls_step_data-bus_obj    = p_bo4.
*  ls_step_data-action     = p_act4.
*  ls_step_data-variant      = p_test4.
*  ls_step_data-reference_step     = cl_ptf_util=>get_split( iv_step_to_split = p_vo_bo4 iv_table_index = gv_step  ).
*  ls_step_data-step_number   = gv_step.
*  APPEND ls_step_data TO lt_step_data.
*
*
*  CLEAR ls_step_data.
*  ADD 1 TO gv_step.
*
*  ls_step_data-bus_obj    = p_bo5.
*  ls_step_data-action     = p_act5.
*  ls_step_data-variant       = p_test5.
*  ls_step_data-reference_step     = cl_ptf_util=>get_split( iv_step_to_split = p_vo_bo5 iv_table_index = gv_step ).
*  ls_step_data-step_number  = gv_step.
*  APPEND ls_step_data TO lt_step_data.
*
*
*  CLEAR ls_step_data.
*  ADD 1 TO gv_step.
*
*  ls_step_data-bus_obj    = p_bo6.
*  ls_step_data-action     = p_act6.
*  ls_step_data-variant        = p_test6.
*  ls_step_data-reference_step     = cl_ptf_util=>get_split( iv_step_to_split = p_vo_bo6 iv_table_index = gv_step ).
*  ls_step_data-step_number   = gv_step.
*  APPEND ls_step_data TO lt_step_data.
*
*
*  CLEAR ls_step_data.
*  ADD 1 TO gv_step.
*
*  ls_step_data-bus_obj    = p_bo7.
*  ls_step_data-action     = p_act7.
*  ls_step_data-variant       = p_test7.
*  ls_step_data-reference_step     = cl_ptf_util=>get_split( iv_step_to_split = p_vo_bo7 iv_table_index = gv_step ).
*  ls_step_data-step_number   = gv_step.
*  APPEND ls_step_data TO lt_step_data.
*
*
*  CLEAR ls_step_data.
*  ADD 1 TO gv_step.
*
*  ls_step_data-bus_obj    = p_bo8.
*  ls_step_data-action     = p_act8.
*  ls_step_data-variant        = p_test8.
*  ls_step_data-reference_step     = cl_ptf_util=>get_split( iv_step_to_split = p_vo_bo8 iv_table_index = gv_step ).
*  ls_step_data-step_number   = gv_step.
*  APPEND ls_step_data TO lt_step_data.
*
*
*  CLEAR ls_step_data.
*  ADD 1 TO gv_step.
*
*  ls_step_data-bus_obj    = p_bo9.
*  ls_step_data-action     = p_act9.
*  ls_step_data-variant       = p_test9.
*  ls_step_data-reference_step     = cl_ptf_util=>get_split( iv_step_to_split = p_vo_bo9 iv_table_index = gv_step  ).
*  ls_step_data-step_number   = gv_step.
*  APPEND ls_step_data TO lt_step_data.
*
*  CLEAR ls_step_data.
*  ADD 1 TO gv_step.
*
*  ls_step_data-bus_obj    = p_bo10.
*  ls_step_data-action     = p_act10.
*  ls_step_data-variant      = p_test10.
*  ls_step_data-reference_step      = cl_ptf_util=>get_split( iv_step_to_split = p_v_bo10 iv_table_index = gv_step ).
*  ls_step_data-step_number   = gv_step.
*  APPEND ls_step_data TO lt_step_data.
*
*
*  CLEAR ls_step_data.
*
*
**  ENDIF.
*ENDFORM.
*
*
*
************************************************************************************************************
*FORM set_output.
*
*  CLEAR ls_step_data .
*  LOOP AT lt_step_data  INTO ls_step_data.
*
** Setting the light and the Ducoment-Id to the right position.
*    DATA: lv_vtab_lines TYPE i,
*          lv_vbeln      TYPE vbeln.
*
*    CASE ls_step_data-step_number.
**Step 1
*      WHEN 1.
*        DESCRIBE TABLE ls_step_data-document_id LINES lv_vtab_lines.
*        IF lv_vtab_lines > 1.
*          READ TABLE ls_step_data-document_id INTO lv_vbeln INDEX 1.
*          CONCATENATE lv_vbeln '+ more' INTO lv_ordn SEPARATED BY space.
*        ELSE.
*          READ TABLE ls_step_data-document_id INTO lv_ordn INDEX 1.
*        ENDIF.
*        IF ls_step_data-action EQ lc_check OR ls_step_data-check_flag IS NOT INITIAL .
*          CASE ls_step_data-execution_status.
*            WHEN abap_true.
*              WRITE icon_green_light AS ICON TO icon1.
*            WHEN abap_false.
*
*              WRITE icon_red_light AS ICON TO icon1.
*              RETURN.
*          ENDCASE.
*        ENDIF.
** Step 2
*      WHEN 2.
*        DESCRIBE TABLE ls_step_data-document_id LINES lv_vtab_lines.
*        IF lv_vtab_lines > 1.
*          READ TABLE ls_step_data-document_id INTO lv_vbeln INDEX 1.
*          CONCATENATE lv_vbeln '+ more' INTO lv_ordn1 SEPARATED BY space.
*        ELSE.
*          READ TABLE ls_step_data-document_id INTO lv_ordn1 INDEX 1.
*        ENDIF.
*        IF ls_step_data-action EQ lc_check OR ls_step_data-check_flag IS NOT INITIAL .
*          CASE ls_step_data-execution_status.
*            WHEN abap_true.
*              WRITE icon_green_light AS ICON TO icon2.
*            WHEN abap_false.
*              WRITE icon_red_light AS ICON TO icon2.
*              RETURN.
*          ENDCASE.
*        ENDIF.
** Step 3
*      WHEN 3.
*        DESCRIBE TABLE ls_step_data-document_id LINES lv_vtab_lines.
*        IF lv_vtab_lines > 1.
*          READ TABLE ls_step_data-document_id INTO lv_vbeln INDEX 1.
*          CONCATENATE lv_vbeln '+ more' INTO lv_ordn2 SEPARATED BY space.
*        ELSE.
*          READ TABLE ls_step_data-document_id INTO lv_ordn2 INDEX 1.
*        ENDIF.
*        .
*        IF ls_step_data-action EQ lc_check OR ls_step_data-check_flag IS NOT INITIAL .
*          CASE ls_step_data-execution_status.
*            WHEN abap_true.
*              WRITE icon_green_light AS ICON TO icon3.
*            WHEN abap_false.
*              WRITE icon_red_light AS ICON TO icon3.
*              RETURN.
*          ENDCASE.
*        ENDIF.
** Step 4
*      WHEN 4.
*        DESCRIBE TABLE ls_step_data-document_id LINES lv_vtab_lines.
*        IF lv_vtab_lines > 1.
*          READ TABLE ls_step_data-document_id INTO lv_vbeln INDEX 1.
*          CONCATENATE lv_vbeln '+ more' INTO lv_ordn3 SEPARATED BY space.
*        ELSE.
*          READ TABLE ls_step_data-document_id INTO lv_ordn3 INDEX 1.
*        ENDIF.
*        IF ls_step_data-action EQ lc_check OR ls_step_data-check_flag IS NOT INITIAL .
*          CASE ls_step_data-execution_status .
*            WHEN abap_true.
*              WRITE icon_green_light AS ICON TO icon4.
*            WHEN abap_false.
*              WRITE icon_red_light AS ICON TO icon4.
*              RETURN.
*          ENDCASE.
*        ENDIF.
** Step 5
*      WHEN 5.
*        DESCRIBE TABLE ls_step_data-document_id LINES lv_vtab_lines.
*        IF lv_vtab_lines > 1.
*          READ TABLE ls_step_data-document_id INTO lv_vbeln INDEX 1.
*          CONCATENATE lv_vbeln '+ more' INTO lv_ordn4 SEPARATED BY space.
*        ELSE.
*          READ TABLE ls_step_data-document_id INTO lv_ordn4 INDEX 1.
*        ENDIF.
*        IF ls_step_data-action EQ lc_check OR ls_step_data-check_flag IS NOT INITIAL .
*          CASE ls_step_data-execution_status.
*            WHEN abap_true.
*              WRITE icon_green_light AS ICON TO icon5.
*            WHEN abap_false.
*              WRITE icon_red_light AS ICON TO icon5.
*              RETURN.
*          ENDCASE.
*        ENDIF.
** Step 6
*      WHEN 6.
*        DESCRIBE TABLE ls_step_data-document_id LINES lv_vtab_lines.
*        IF lv_vtab_lines > 1.
*          READ TABLE ls_step_data-document_id INTO lv_vbeln INDEX 1.
*          CONCATENATE lv_vbeln '+ more' INTO lv_ordn5 SEPARATED BY space.
*        ELSE.
*          READ TABLE ls_step_data-document_id INTO lv_ordn5 INDEX 1.
*        ENDIF.
*        IF ls_step_data-action EQ lc_check OR ls_step_data-check_flag IS NOT INITIAL .
*          CASE ls_step_data-execution_status .
*            WHEN abap_true.
*              WRITE icon_green_light AS ICON TO icon6.
*            WHEN abap_false.
*              WRITE icon_red_light AS ICON TO icon6.
*              RETURN.
*          ENDCASE.
*        ENDIF.
** Step 7
*      WHEN 7.
*        DESCRIBE TABLE ls_step_data-document_id LINES lv_vtab_lines.
*        IF lv_vtab_lines > 1.
*          READ TABLE ls_step_data-document_id INTO lv_vbeln INDEX 1.
*          CONCATENATE lv_vbeln '+ more' INTO lv_ordn6 SEPARATED BY space.
*        ELSE.
*          READ TABLE ls_step_data-document_id INTO lv_ordn6 INDEX 1.
*        ENDIF.
*        IF ls_step_data-action EQ lc_check OR ls_step_data-check_flag IS NOT INITIAL .
*          CASE ls_step_data-execution_status.
*            WHEN abap_true.
*              WRITE icon_green_light AS ICON TO icon7.
*            WHEN abap_false.
*              WRITE icon_red_light AS ICON TO icon7.
*              RETURN.
*          ENDCASE.
*        ENDIF.
** Step 8
*      WHEN 8.
*        DESCRIBE TABLE ls_step_data-document_id LINES lv_vtab_lines.
*        IF lv_vtab_lines > 1.
*          READ TABLE ls_step_data-document_id INTO lv_vbeln INDEX 1.
*          CONCATENATE lv_vbeln '+ more' INTO lv_ordn7 SEPARATED BY space.
*        ELSE.
*          READ TABLE ls_step_data-document_id INTO lv_ordn7 INDEX 1.
*        ENDIF.
*        IF ls_step_data-action EQ lc_check OR ls_step_data-check_flag IS NOT INITIAL .
*          CASE ls_step_data-execution_status .
*            WHEN abap_true.
*              WRITE icon_green_light AS ICON TO icon8.
*            WHEN abap_false.
*              WRITE icon_red_light AS ICON TO icon8.
*              RETURN.
*          ENDCASE.
*        ENDIF.
** Step 9
*      WHEN 9.
*        DESCRIBE TABLE ls_step_data-document_id LINES lv_vtab_lines.
*        IF lv_vtab_lines > 1.
*          READ TABLE ls_step_data-document_id INTO lv_vbeln INDEX 1.
*          CONCATENATE lv_vbeln '+ more' INTO lv_ordn8 SEPARATED BY space.
*        ELSE.
*          READ TABLE ls_step_data-document_id INTO lv_ordn8 INDEX 1.
*        ENDIF.
*        IF ls_step_data-action EQ lc_check OR ls_step_data-check_flag IS NOT INITIAL .
*          CASE ls_step_data-execution_status.
*            WHEN abap_true.
*              WRITE icon_green_light AS ICON TO icon9.
*            WHEN abap_false.
*              WRITE icon_red_light AS ICON TO icon9.
*              RETURN.
*          ENDCASE.
*        ENDIF.
** Step 10
*      WHEN 10.
*        DESCRIBE TABLE ls_step_data-document_id LINES lv_vtab_lines.
*        IF lv_vtab_lines > 1.
*          READ TABLE ls_step_data-document_id INTO lv_vbeln INDEX 1.
*          CONCATENATE lv_vbeln '+ more' INTO lv_ordn9 SEPARATED BY space.
*        ELSE.
*          READ TABLE ls_step_data-document_id INTO lv_ordn9 INDEX 1.
*        ENDIF.
*        IF ls_step_data-action EQ lc_check OR ls_step_data-check_flag IS NOT INITIAL .
*          CASE ls_step_data-execution_status.
*            WHEN abap_true.
*              WRITE icon_green_light AS ICON TO icon10.
*            WHEN abap_false.
*              WRITE icon_red_light AS ICON TO icon10.
*              RETURN.
*          ENDCASE.
*        ENDIF.
*    ENDCASE.
*
*  ENDLOOP.
*
*  CLEAR lt_step_data.
*
*ENDFORM.
*
*
*
************************************************************************************************************
*FORM ap_log.
*  IMPORT s1 = lt_return  FROM MEMORY ID 'ptf_lt_return'.
*
*  DATA lt_fieldcat TYPE slis_t_fieldcat_alv.
*
*  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
*    EXPORTING
*      i_structure_name = 'BAPIRET2'
*    CHANGING
*      ct_fieldcat      = lt_fieldcat.
*
*  CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
*    EXPORTING
*      i_callback_program    = sy-repid
*      it_fieldcat           = lt_fieldcat
*      i_screen_start_column = 3
*      i_screen_start_line   = 3
*      i_screen_end_column   = 200
*      i_screen_end_line     = 20
*    TABLES
*      t_outtab              = lt_return.
*
**call FUNCTION 'BAL_LOG_CREATE'
**  EXPORTING
**    i_s_log                 =     " Log header data
***  IMPORTING
***    e_log_handle            =     " Log handle
***  EXCEPTIONS
***    log_header_inconsistent = 1
***    others                  = 2
**  .
**IF sy-subrc <> 0.
*** MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
***            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
**ENDIF.
**
**
**
**call FUNCTION 'BAL_LOG_MSG_ADD'
**  EXPORTING
***    i_log_handle        =     " Log handle
**    i_s_msg             =     " Notification data
***  IMPORTING
***    e_s_msg_handle      =     " Message handle
***    e_msg_was_logged    =     " Message collected
***    e_msg_was_displayed =     " Message output
***  EXCEPTIONS
***    log_not_found       = 1
***    msg_inconsistent    = 2
***    log_is_full         = 3
***    others              = 4
**  .
*
**  DATA: log_header TYPE  bal_s_log,
**  log_handle   TYPE balloghndl.
**  log_header-object = 'PTF'.
**  log_header-subobject = space.
**  log_header-extnumber = sy-cprog.
**  log_header-aldate    = sy-datum.
**  log_header-altime    = sy-uzeit.
**  log_header-aluser    = sy-uname.
**  log_header-alprog    = sy-repid.
**  log_header-altcode   = sy-tcode.
**
**  CALL FUNCTION 'BAL_LOG_CREATE'
**    EXPORTING
**      i_s_log = log_header    " Log header data
**  IMPORTING
**     e_log_handle            =   log_handle  " Log handle
**  EXCEPTIONS
**     log_header_inconsistent = 1
**     others  = 2
**    .
**  IF sy-subrc <> 0.
** MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
***            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
**  ENDIF.
*
*ENDFORM.
*
*INCLUDE process_test_framework_fillf01.
