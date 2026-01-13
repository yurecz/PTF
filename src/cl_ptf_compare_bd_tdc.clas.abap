CLASS cl_ptf_compare_bd_tdc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    CLASS-METHODS compare_vbrk_data
      IMPORTING
        !is_testdata        TYPE cl_ptf_bo_invoice=>ty_gs_ptf_bd_check_td
        !is_check_step_data TYPE cl_ptf_util=>gt_ptf_step
        !iv_run_environment TYPE REF TO cl_ptf_run
      RETURNING
        VALUE(rv_is_equal)  TYPE abap_bool .
    CLASS-METHODS compare_vbrp_data
      IMPORTING
        !is_testdata        TYPE cl_ptf_bo_invoice=>ty_gs_ptf_bd_check_td
        !is_check_step_data TYPE cl_ptf_util=>gt_ptf_step
        !iv_run_environment TYPE REF TO cl_ptf_run
      RETURNING
        VALUE(rv_is_equal)  TYPE abap_bool .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS CL_PTF_COMPARE_BD_TDC IMPLEMENTATION.


  METHOD compare_vbrk_data.
    DATA: ls_testdata        TYPE cl_ptf_bo_invoice=>ty_gs_ptf_bd_check_td,
          ls_vbrk_check      TYPE sdbil_tst_vbrk_check,
          lv_prestepnumber   TYPE LINE OF cl_ptf_util=>gt_ptf_step-reference_step,
          ls_check_step_data TYPE cl_ptf_util=>gt_ptf_step,
          lt_vbrk            TYPE TABLE OF vbrk,
          ls_vbrk            TYPE vbrk,
          ls_testdata_vbrk   TYPE vbrk,
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
    rv_is_equal = abap_true.
*  retrieve reference BOs from DB
    TYPES:
      BEGIN OF ty_vbeln_orig,
        vbeln TYPE vbeln,
      END OF ty_vbeln_orig.
    DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.
    MOVE ls_check_step_data-document_id TO lt_vbeln_key.
    SELECT * FROM vbrk INTO TABLE lt_vbrk FOR ALL ENTRIES IN lt_vbeln_key WHERE vbeln = lt_vbeln_key-vbeln.
    IF sy-subrc NE 0.
      rv_is_equal = abap_false.
*  Check which vbeln was not found
      SORT ls_check_step_data-document_id BY vbeln.
      CLEAR lv_vbeln.
      LOOP AT ls_check_step_data-document_id INTO lv_vbeln.
        READ TABLE lt_vbrk TRANSPORTING NO FIELDS WITH KEY vbeln = lv_vbeln.
        IF sy-subrc NE 0.
          iv_run_environment->append_log( iv_log_statement = |No database entry was found with vbeln: { lv_vbeln }| ).
          rv_is_equal = abap_false.
        ENDIF.
      ENDLOOP.
    ELSE.
*   get fieldinfo to check which fields of vbrk structure have to be checked
      CLEAR lt_fieldinfo.
      CALL FUNCTION 'DD_INT_TABLINFO_GET'
        EXPORTING
          typename       = 'VBRK'
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
      LOOP AT ls_testdata-vbrk_check INTO ls_vbrk_check.
        lv_index = lv_index + 1.
        CLEAR ls_vbrk.
        READ TABLE lt_vbrk INTO ls_vbrk INDEX lv_index.
        READ TABLE ls_testdata-vbrk INTO ls_testdata_vbrk INDEX lv_index.
        CLEAR ls_fieldinfo.
        LOOP AT lt_fieldinfo INTO ls_fieldinfo.
          ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbrk_check TO <lv_fieldvalue>.
          IF sy-subrc EQ 0 AND ( <lv_fieldvalue> EQ 'X' OR <lv_fieldvalue> EQ 'N' ).
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbrk TO <lv_document_value>.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_testdata_vbrk TO <lv_testdata_value>.

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

            msg_str1 = <lv_testdata_value>.
            msg_str2 = <lv_document_value>.

            IF <lv_fieldvalue> EQ 'X'.   "check for equality to TDC value
              IF <lv_document_value> NE <lv_testdata_value>.
                rv_is_equal = abap_false.
                iv_run_environment->append_log( iv_log_statement = |The Value of the VBRK field { ls_fieldinfo-fieldname } is not as expected.| ).
                iv_run_environment->append_log( iv_log_statement = |The expected value is: { msg_str1 }.| ).
                iv_run_environment->append_log( iv_log_statement = |The stored value is: { msg_str2 }| ).
              ENDIF.
            ELSEIF <lv_fieldvalue> EQ 'N'.   ""check for NOT EQUAL to TDC value
              IF <lv_document_value> EQ <lv_testdata_value>.
                rv_is_equal = abap_false.
                iv_run_environment->append_log( iv_log_statement = |VBRK field { ls_fieldinfo-fieldname } has the value it shall NOT be equal to (N was set as check flag.)| ).
                iv_run_environment->append_log( iv_log_statement = |The value is: { msg_str1 }| ).
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP. "fields
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD compare_vbrp_data.

    TYPES:
      BEGIN OF ty_vbeln_orig,
        vbeln TYPE vbeln,
      END OF ty_vbeln_orig.
    DATA lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.

    DATA: ls_testdata        TYPE cl_ptf_bo_invoice=>ty_gs_ptf_bd_check_td,
          ls_vbrp_check      TYPE sdbil_tst_vbrp_check,
          lv_prestepnumber   TYPE LINE OF cl_ptf_util=>gt_ptf_step-reference_step,
          ls_check_step_data TYPE cl_ptf_util=>gt_ptf_step,
          lt_vbrp_db         TYPE TABLE OF vbrp,
          ls_vbrp_db         TYPE vbrp,
          ls_testdata_vbrp   TYPE vbrp,
          lv_vbeln           TYPE vbeln,
          lt_fieldinfo       TYPE extdfiest,
          ls_fieldinfo       TYPE LINE OF extdfiest,
          lv_fieldname       TYPE fieldname,
          lv_index           TYPE i,
          lv_input           TYPE string,
          lv_fields_compared TYPE i,
          msg_str1           TYPE string,
          msg_str2           TYPE string.

    FIELD-SYMBOLS: <lv_testdata_value> TYPE any,
                   <lv_document_value> TYPE any,
                   <lv_fieldvalue>     TYPE any.

    ls_testdata = is_testdata.
    SORT ls_testdata-vbrp BY posnr.
    ls_check_step_data = is_check_step_data.
    rv_is_equal = abap_true.

*  retrieve reference BOs from DB
    MOVE ls_check_step_data-document_id TO lt_vbeln_key.
    SELECT * FROM vbrp INTO TABLE lt_vbrp_db FOR ALL ENTRIES IN lt_vbeln_key
      WHERE vbeln = lt_vbeln_key-vbeln ORDER BY PRIMARY KEY.

    IF sy-subrc NE 0.
      "Error, end execution
      rv_is_equal  = abap_false.
*     Check which vbeln was not found
      SORT ls_check_step_data-document_id BY vbeln.
      CLEAR lv_vbeln.
      LOOP AT ls_check_step_data-document_id INTO lv_vbeln.
        READ TABLE lt_vbrp_db TRANSPORTING NO FIELDS WITH KEY vbeln = lv_vbeln.
        IF sy-subrc NE 0.
          rv_is_equal  = abap_false.
          iv_run_environment->append_log( iv_log_statement = |No database entry was found with vbeln: { lv_vbeln }| ).
        ENDIF.
      ENDLOOP.

      RETURN.
    ENDIF.
*    ELSE.

*   get fieldinfo to check which fields of vbrp structure have to be checked
      CLEAR lt_fieldinfo.
      CALL FUNCTION 'DD_INT_TABLINFO_GET'
        EXPORTING
          typename       = 'VBRP'
        TABLES
          extdfies_tab   = lt_fieldinfo
        EXCEPTIONS
          not_found      = 1
          internal_error = 2
          OTHERS         = 3.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

      DESCRIBE TABLE ls_testdata-vbrp_check LINES DATA(len_check).
      DESCRIBE TABLE lt_vbrp_db LINES DATA(len_vbrp_db).

      IF len_check EQ len_vbrp_db.
        lv_index = 0.
        LOOP AT ls_testdata-vbrp_check INTO ls_vbrp_check.   "Leading is itab vbrp_check (the one with the flags)
          lv_index = lv_index + 1.
          CLEAR: ls_vbrp_db, ls_testdata_vbrp, ls_fieldinfo, lv_fields_compared.

          READ TABLE lt_vbrp_db       INTO ls_vbrp_db       INDEX lv_index.
          IF sy-subrc IS NOT INITIAL.
            "should never happen as 'len_check EQ len_vbrp_db' is checked above
            iv_run_environment->append_log( iv_log_statement = |Number of entries in db table VBRP do not match TDCV entries of VBRP_CHECK! Index:{ lv_index }| ).
            CONTINUE.
          ENDIF.
          READ TABLE ls_testdata-vbrp INTO ls_testdata_vbrp INDEX lv_index.
          IF sy-subrc IS NOT INITIAL.
            "inconsistent data in TDC variant
            iv_run_environment->append_log( iv_log_statement = |TDC Variant: Number of entries of VBRP do not match entries of VBRP_CHECK! Index:{ lv_index }| ).
            CONTINUE.
          ENDIF.

          DATA(posnr_db__for_debugging) = ls_vbrp_db-posnr.
          DATA(posnr_tdc_for_debugging) = ls_testdata_vbrp-posnr.

          LOOP AT lt_fieldinfo INTO ls_fieldinfo.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbrp_check TO <lv_fieldvalue>.
            IF sy-subrc EQ 0 AND ( <lv_fieldvalue> EQ 'X' OR <lv_fieldvalue> EQ 'N' ).
              ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbrp_db       TO <lv_document_value>.
              ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_testdata_vbrp TO <lv_testdata_value>.

              "This method converts strings to corresponding system fields
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

              msg_str1 = <lv_testdata_value>.
              msg_str2 = <lv_document_value>.

              IF <lv_fieldvalue> EQ 'X'.   "check for equality to TDC value
                ADD 1 TO lv_fields_compared.
                IF <lv_document_value> NE <lv_testdata_value>.
                  rv_is_equal = abap_false.
                  iv_run_environment->append_log( iv_log_statement = |The Value of the VBRP field { ls_fieldinfo-fieldname } is not as expected.| ).
                  iv_run_environment->append_log( iv_log_statement = |The expected value is: { msg_str1 }.| ).
                  iv_run_environment->append_log( iv_log_statement = |The stored value is: {   msg_str2 }.| ).
                ENDIF.
              ELSEIF <lv_fieldvalue> EQ 'N'.   "check for NOT EQUAL to TDC value
                ADD 1 TO lv_fields_compared.
                IF <lv_document_value> EQ <lv_testdata_value>.
                  rv_is_equal = abap_false.
                  iv_run_environment->append_log( iv_log_statement = |VBRP field { ls_fieldinfo-fieldname } has the value it shall NOT be equal to (N was set as check flag.)| ).
                  iv_run_environment->append_log( iv_log_statement = |The value is: { msg_str1 }.| ).
                ENDIF.
              ENDIF.
            ENDIF.
          ENDLOOP. "fields
          iv_run_environment->append_log( iv_log_statement = |Item { ls_vbrp_db-posnr }: { lv_fields_compared } fields were compared.| ).

        ENDLOOP. "itab vbrp_check

      ELSE.
        rv_is_equal = abap_false.
        msg_str1 = len_check.
        msg_str2 = len_vbrp_db.
        iv_run_environment->append_log( iv_log_statement = |There are { msg_str1 } item records in VBRP_CHECK in the TDC, but { msg_str2 } items in the doc on DB. | ).
      ENDIF.

*    ENDIF.

  ENDMETHOD.
ENDCLASS.
