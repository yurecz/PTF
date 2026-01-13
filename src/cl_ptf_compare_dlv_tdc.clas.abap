class CL_PTF_COMPARE_DLV_TDC definition
  public
  final
  create public .

public section.

  class-methods COMPARE_LIKP_DATA
    importing
      !IS_TESTDATA type cl_ptf_bo_outb_delivery=>TY_GS_PTF_DL_CHECK_TD
      !IS_CHECK_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_RUN_ENVIRONMENT type ref to CL_PTF_RUN
    returning
      value(RV_IS_EQUAL) type ABAP_BOOL .
  class-methods COMPARE_LIPS_DATA
    importing
      !IS_TESTDATA type cl_ptf_bo_outb_delivery=>TY_GS_PTF_DL_CHECK_TD
      !IS_CHECK_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_RUN_ENVIRONMENT type ref to CL_PTF_RUN
    returning
      value(RV_IS_EQUAL) type ABAP_BOOL .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS CL_PTF_COMPARE_DLV_TDC IMPLEMENTATION.


  METHOD compare_likp_data.
    DATA: ls_testdata        TYPE cl_ptf_bo_outb_delivery=>ty_gs_ptf_dl_check_td,
          ls_likp_check      TYPE sdbil_tst_likp_check,
          lv_prestepnumber   TYPE LINE OF cl_ptf_util=>gt_ptf_step-reference_step,
          ls_check_step_data TYPE cl_ptf_util=>gt_ptf_step,
          lt_likp            TYPE TABLE OF likp,
          ls_likp            TYPE likp,
          ls_testdata_likp   TYPE likp,
          lv_vbeln           TYPE vbeln,
          lt_fieldinfo       TYPE extdfiest,
          ls_fieldinfo       TYPE LINE OF extdfiest,
          lv_fieldname       TYPE fieldname,
          lv_index           TYPE i,
          error_message      TYPE bapi_msg,
          ls_return          TYPE bapiret2,
          lv_input           TYPE string,
          msg_str1           TYPE string,
          msg_str2           TYPE string.



    FIELD-SYMBOLS: <lv_testdata_value> TYPE any,
                   <lv_document_value> TYPE any,
                   <lv_fieldvalue>     TYPE any.


    ls_testdata = is_testdata.
    ls_check_step_data = is_check_step_data.
    rv_is_equal  = abap_true.
*  retrieve reference BOs from DB
    TYPES:
      BEGIN OF ty_vbeln_orig,
        vbeln TYPE vbeln,
      END OF ty_vbeln_orig.
    DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.
    MOVE ls_check_step_data-document_id TO lt_vbeln_key.
    SELECT * FROM likp INTO TABLE lt_likp FOR ALL ENTRIES IN lt_vbeln_key WHERE vbeln = lt_vbeln_key-vbeln.
    IF sy-subrc NE 0.
      rv_is_equal  = abap_false.
*  Check which vbeln was not found
      SORT ls_check_step_data-document_id BY vbeln.
      CLEAR lv_vbeln.
      LOOP AT ls_check_step_data-document_id INTO lv_vbeln.
        READ TABLE lt_likp TRANSPORTING NO FIELDS WITH KEY vbeln = lv_vbeln.
        IF sy-subrc NE 0.
          rv_is_equal  = abap_false.
          CONCATENATE 'No db entry was found in LIKP for VBELN:' lv_vbeln INTO error_message SEPARATED BY space.
          iv_run_environment->append_log( iv_log_statement = |{ error_message }| ).
        ENDIF.
      ENDLOOP.
    ELSE.
*   get fieldinfo to check which fields of likp structure have to be checked
      CLEAR lt_fieldinfo.
      CALL FUNCTION 'DD_INT_TABLINFO_GET'
        EXPORTING
          typename       = 'LIKP'
        TABLES
          extdfies_tab   = lt_fieldinfo
        EXCEPTIONS
          not_found      = 1
          internal_error = 2
          OTHERS         = 3.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

      lv_index = 0.
      LOOP AT ls_testdata-likp_check INTO ls_likp_check.
        lv_index = lv_index + 1.
        CLEAR ls_likp.
        READ TABLE lt_likp INTO ls_likp INDEX lv_index.
        READ TABLE ls_testdata-likp INTO ls_testdata_likp INDEX lv_index.
        CLEAR ls_fieldinfo.
        LOOP AT lt_fieldinfo INTO ls_fieldinfo.
          ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_likp_check TO <lv_fieldvalue>.
          IF sy-subrc EQ 0 AND <lv_fieldvalue> EQ 'X'.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_likp TO <lv_document_value>.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_testdata_likp TO <lv_testdata_value>.

* This method converts strings to corresponding system fields
            lv_input = ( <lv_testdata_value> ).
            TRY.
                cl_ptf_util=>get_syst_field(
                  EXPORTING
                    iv_field_name  = lv_input
                  IMPORTING
                    ev_field_value = <lv_testdata_value>
                ).
              CATCH cx_sy_dyn_call_illegal_type.
            ENDTRY.

            IF <lv_document_value> NE <lv_testdata_value>.
              rv_is_equal = abap_false.
              msg_str1 = <lv_testdata_value>.
              msg_str2 = <lv_document_value>.
              CONCATENATE 'The Value of the LIKP field ' ls_fieldinfo-fieldname 'is not as expected. The expected value is:' msg_str1
                          '. The stored value is:' msg_str2 INTO error_message SEPARATED BY space.
              CLEAR ls_return.
              ls_return-message = error_message.
              iv_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD compare_lips_data.
    DATA: ls_testdata        TYPE cl_ptf_bo_outb_delivery=>ty_gs_ptf_dl_check_td,
          ls_lips_check      TYPE sdbil_tst_lips_check,
          lv_prestepnumber   TYPE LINE OF cl_ptf_util=>gt_ptf_step-reference_step,
          ls_check_step_data TYPE cl_ptf_util=>gt_ptf_step,
          lt_lips            TYPE TABLE OF lips,
          ls_lips            TYPE lips,
          ls_testdata_lips   TYPE lips,
          lv_vbeln           TYPE vbeln,
          lt_fieldinfo       TYPE extdfiest,
          ls_fieldinfo       TYPE LINE OF extdfiest,
          lv_fieldname       TYPE fieldname,
          lv_index           TYPE i,
          error_message      TYPE bapi_msg,
          ls_return          TYPE bapiret2,
          lv_input           TYPE string,
          msg_str1           TYPE string,
          msg_str2           TYPE string..


    FIELD-SYMBOLS: <lv_testdata_value> TYPE any,
                   <lv_document_value> TYPE any,
                   <lv_fieldvalue>     TYPE any.


    ls_testdata = is_testdata.
    ls_check_step_data = is_check_step_data.
    rv_is_equal = abap_true.
*  retrieve reference BOs from DB
    TYPES:
      BEGIN OF ty_vbeln_orig,
        vbeln TYPE vbeln,
      END OF ty_vbeln_orig.
    DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.
    MOVE ls_check_step_data-document_id TO lt_vbeln_key.
    SELECT * FROM lips INTO TABLE lt_lips FOR ALL ENTRIES IN lt_vbeln_key
      WHERE vbeln = lt_vbeln_key-vbeln ORDER BY PRIMARY KEY.
    IF sy-subrc NE 0.
      rv_is_equal = abap_false.
*  Check which vbeln was not found
      SORT ls_check_step_data-document_id BY vbeln.
      CLEAR lv_vbeln.
      LOOP AT ls_check_step_data-document_id INTO lv_vbeln.
        READ TABLE lt_lips TRANSPORTING NO FIELDS WITH KEY vbeln = lv_vbeln.
        IF sy-subrc NE 0.
          rv_is_equal = abap_false.
          CONCATENATE 'No database entry was found with vbeln:' lv_vbeln INTO error_message SEPARATED BY space.
          CLEAR ls_return.
          ls_return-message = error_message.
          iv_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
        ENDIF.
      ENDLOOP.
    ELSE.
*   get fieldinfo to check which fields of lips structure have to be checked
      CLEAR lt_fieldinfo.
      CALL FUNCTION 'DD_INT_TABLINFO_GET'
        EXPORTING
          typename       = 'LIPS'
        TABLES
          extdfies_tab   = lt_fieldinfo
        EXCEPTIONS
          not_found      = 1
          internal_error = 2
          OTHERS         = 3.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

      lv_index = 0.
      LOOP AT ls_testdata-lips_check INTO ls_lips_check.
        lv_index = lv_index + 1.
        CLEAR ls_lips.
        READ TABLE lt_lips INTO ls_lips INDEX lv_index.
        READ TABLE ls_testdata-lips INTO ls_testdata_lips INDEX lv_index.
        CLEAR ls_fieldinfo.
        LOOP AT lt_fieldinfo INTO ls_fieldinfo.
          ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_lips_check TO <lv_fieldvalue>.
          IF sy-subrc EQ 0 AND <lv_fieldvalue> EQ 'X'.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_lips TO <lv_document_value>.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_testdata_lips TO <lv_testdata_value>.
            IF <lv_document_value> NE <lv_testdata_value>.

* This method converts strings to corresponding system fields
              lv_input = ( <lv_testdata_value> ).
              TRY.
                  cl_ptf_util=>get_syst_field(
                    EXPORTING
                      iv_field_name  = lv_input
                    IMPORTING
                      ev_field_value = <lv_testdata_value>
                  ).
                CATCH cx_sy_dyn_call_illegal_type.
              ENDTRY.
              rv_is_equal = abap_false.
              msg_str1 = <lv_testdata_value>.
              msg_str2 = <lv_document_value>.
              CONCATENATE 'The Value of the LIPS field ' ls_fieldinfo-fieldname 'is not as expected. The expected value is:' msg_str1
                          '. The stored value is:' msg_str2 INTO error_message SEPARATED BY space.
              CLEAR ls_return.
              ls_return-message = error_message.
              iv_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
