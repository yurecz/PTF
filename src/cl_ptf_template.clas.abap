CLASS cl_ptf_template DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS is_new_version
      RETURNING VALUE(rv_is_new_version) TYPE abap_bool.

*    METHODS create
*      EXPORTING
*        VALUE(et_return) TYPE cl_ptf_util=>gt_ptf_return_tab
*      CHANGING
*        !cs_step_data    TYPE cl_ptf_util=>gt_ptf_step
*        !ct_step_data    TYPE cl_ptf_util=>gt_ptf_step_tab .
*
*    METHODS change
*      EXPORTING
*        !et_return    TYPE cl_ptf_util=>gt_ptf_return_tab
*      CHANGING
*        !ct_step_data TYPE cl_ptf_util=>gt_ptf_step_tab
*        !cs_step_data TYPE cl_ptf_util=>gt_ptf_step .
protected section.

  class-methods PRESTEP_POSNR
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    changing
      !IS_DATA type CL_PTF_BO_DMR=>TY_GS_I_PTF_DMR_CR_TD
      !CT_RETURN type CL_PTF_UTIL=>GT_PTF_RETURN_TAB .
  class-methods GET_TESTDATA
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !ES_TESTDATA type ANY .
  class-methods CHECK_EXISTENCE
    importing
      !IV_VBELN type PTFKEY
    changing
      !CS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !CT_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP_TAB
      value(CT_RETURN) type CL_PTF_UTIL=>GT_PTF_RETURN_TAB .
  class-methods GET_PREDECESSOR_VBELN
    importing
      !CS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !CT_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP_TAB
    exporting
      !ET_VBELN type CL_PTF_UTIL=>TY_VBELN_TAB .
  class-methods DO_COMMITMENT
    importing
      !IT_RETURN type CL_PTF_UTIL=>GT_PTF_RETURN_TAB
      !IS_RETURN type BAPIRET2
    changing
      !CT_RETURN type CL_PTF_UTIL=>GT_PTF_RETURN_TAB .
  class-methods COMPARE_VBRK_DATA
    importing
      !IS_TESTDATA type CL_PTF_BO_INVOICE=>TY_GS_PTF_BD_CHECK_TD
      !IS_CHECK_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    changing
      !CS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !ET_RETURN type CL_PTF_UTIL=>GT_PTF_RETURN_TAB .
  class-methods COMPARE_VBRP_DATA
    importing
      !IS_TESTDATA type CL_PTF_BO_INVOICE=>TY_GS_PTF_BD_CHECK_TD
      !IS_CHECK_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    changing
      !CS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !ET_RETURN type CL_PTF_UTIL=>GT_PTF_RETURN_TAB .
  class-methods COMPARE_VBAK_DATA
    importing
      !IS_TESTDATA type CL_PTF_BO_OR=>TY_GS_PTF_SD_CHECK_TD
      !IS_CHECK_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    changing
      !CS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !ET_RETURN type CL_PTF_UTIL=>GT_PTF_RETURN_TAB .
  class-methods COMPARE_VBAP_DATA
    importing
      !IS_TESTDATA type CL_PTF_BO_OR=>TY_GS_PTF_SD_CHECK_TD
      !IS_CHECK_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    changing
      !CS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !ET_RETURN type CL_PTF_UTIL=>GT_PTF_RETURN_TAB .
  class-methods COMPARE_LIKP_DATA
    importing
      !IS_TESTDATA type CL_PTF_BO_OUTB_DELIVERY=>TY_GS_PTF_DL_CHECK_TD
      !IS_CHECK_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    changing
      !CS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !ET_RETURN type CL_PTF_UTIL=>GT_PTF_RETURN_TAB .
  class-methods COMPARE_LIPS_DATA
    importing
      !IS_TESTDATA type CL_PTF_BO_OUTB_DELIVERY=>TY_GS_PTF_DL_CHECK_TD
      !IS_CHECK_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    changing
      !CS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !ET_RETURN type CL_PTF_UTIL=>GT_PTF_RETURN_TAB .
  PRIVATE SECTION.
ENDCLASS.



CLASS CL_PTF_TEMPLATE IMPLEMENTATION.


  METHOD check_existence.

    DATA: error_message TYPE bapi_msg,
          ls_return     TYPE bapiret2.

    SELECT SINGLE * FROM vbak INTO @DATA(ls_vbak) WHERE vbeln = @iv_vbeln.
    IF sy-subrc NE 0.
      SELECT SINGLE * FROM vbrk INTO @DATA(ls_vbrk) WHERE vbeln = @iv_vbeln.
      IF sy-subrc NE 0.
        SELECT SINGLE * FROM likp INTO @DATA(ls_likp) WHERE vbeln = @iv_vbeln.
        IF sy-subrc NE 0.
          cs_step_data-execution_status = abap_false.
          MODIFY ct_step_data FROM cs_step_data INDEX cs_step_data-step_number.
          CONCATENATE 'No database entry was found with vbeln:' iv_vbeln INTO error_message SEPARATED BY space.
          CLEAR ls_return.
          ls_return-message = error_message.
          APPEND ls_return TO ct_return.
        ELSE.
          cs_step_data-execution_status = abap_true.
          APPEND iv_vbeln TO cs_step_data-document_id.
          MODIFY ct_step_data FROM cs_step_data INDEX cs_step_data-step_number .
          CONCATENATE 'Database entry with vbeln:' iv_vbeln 'exists' INTO error_message SEPARATED BY space.
          CLEAR ls_return.
          ls_return-message = error_message.
          APPEND ls_return TO ct_return.
        ENDIF.
      ELSE.
        cs_step_data-execution_status = abap_true.
        APPEND iv_vbeln TO cs_step_data-document_id.
        MODIFY ct_step_data FROM cs_step_data INDEX cs_step_data-step_number .
        CONCATENATE 'Database entry with vbeln:' iv_vbeln 'exists' INTO error_message SEPARATED BY space.
        CLEAR ls_return.
        ls_return-message = error_message.
        APPEND ls_return TO ct_return.
      ENDIF.
    ELSE.
      cs_step_data-execution_status = abap_true.
      APPEND iv_vbeln TO cs_step_data-document_id.
      MODIFY ct_step_data FROM cs_step_data INDEX cs_step_data-step_number .
      CONCATENATE 'Database entry with vbeln:' iv_vbeln 'exists' INTO error_message SEPARATED BY space.
      CLEAR ls_return.
      ls_return-message = error_message.
      APPEND ls_return TO ct_return.
    ENDIF.

  ENDMETHOD.


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
    cs_step_data-check_status  = abap_true.
*  retrieve reference BOs from DB
    TYPES:
      BEGIN OF ty_vbeln_orig,
        vbeln TYPE vbeln,
      END OF ty_vbeln_orig.
    DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.
    MOVE ls_check_step_data-document_id TO lt_vbeln_key.
    SELECT * FROM likp INTO TABLE lt_likp FOR ALL ENTRIES IN lt_vbeln_key WHERE vbeln = lt_vbeln_key-vbeln.
    IF sy-subrc NE 0.
      cs_step_data-check_status  = abap_false.
*  Check which vbeln was not found
      SORT ls_check_step_data-document_id BY vbeln.
      CLEAR lv_vbeln.
      LOOP AT ls_check_step_data-document_id INTO lv_vbeln.
        READ TABLE lt_likp TRANSPORTING NO FIELDS WITH KEY vbeln = lv_vbeln.
        IF sy-subrc NE 0.
          cs_step_data-check_status  = abap_false.
          CONCATENATE 'No database entry was found with vbeln:' lv_vbeln INTO error_message SEPARATED BY space.
          CLEAR ls_return.
          ls_return-message = error_message.
          APPEND ls_return TO et_return.
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
          IF <lv_fieldvalue> EQ 'X'.
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
              cs_step_data-check_status = abap_false.
              msg_str1 = <lv_testdata_value>.
              msg_str2 = <lv_document_value>.
              CONCATENATE 'The Value of the LIKP field ' ls_fieldinfo-fieldname 'is not as expected. The expected value is:' msg_str1
                          '. The stored value is:' msg_str2 INTO error_message SEPARATED BY space.
              CLEAR ls_return.
              ls_return-message = error_message.
              APPEND ls_return TO et_return.
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
    cs_step_data-check_status = abap_true.
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
      cs_step_data-check_status = abap_false.
*  Check which vbeln was not found
      SORT ls_check_step_data-document_id BY vbeln.
      CLEAR lv_vbeln.
      LOOP AT ls_check_step_data-document_id INTO lv_vbeln.
        READ TABLE lt_lips TRANSPORTING NO FIELDS WITH KEY vbeln = lv_vbeln.
        IF sy-subrc NE 0.
          cs_step_data-check_status = abap_false.
          CONCATENATE 'No database entry was found with vbeln:' lv_vbeln INTO error_message SEPARATED BY space.
          CLEAR ls_return.
          ls_return-message = error_message.
          APPEND ls_return TO et_return.
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
          IF <lv_fieldvalue> EQ 'X'.
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
              cs_step_data-check_status = abap_false.
              msg_str1 = <lv_testdata_value>.
              msg_str2 = <lv_document_value>.
              CONCATENATE 'The Value of the LIPS field ' ls_fieldinfo-fieldname 'is not as expected. The expected value is:' msg_str1
                          '. The stored value is:' msg_str2 INTO error_message SEPARATED BY space.
              CLEAR ls_return.
              ls_return-message = error_message.
              APPEND ls_return TO et_return.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD compare_vbak_data.

    DATA: ls_testdata        TYPE cl_ptf_bo_or=>ty_gs_ptf_sd_check_td,
          ls_vbak_check      TYPE sdbil_tst_vbak_check,
          lv_prestepnumber   TYPE LINE OF cl_ptf_util=>gt_ptf_step-reference_step,
          ls_check_step_data TYPE cl_ptf_util=>gt_ptf_step,
          lt_vbak            TYPE TABLE OF vbak,
          ls_vbak            TYPE vbak,
          ls_testdata_vbak   TYPE vbak,
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
    cs_step_data-check_status =  abap_true.
*  retrieve reference BOs from DB
    TYPES:
      BEGIN OF ty_vbeln_orig,
        vbeln TYPE vbeln,
      END OF ty_vbeln_orig.
    DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.
    MOVE ls_check_step_data-document_id TO lt_vbeln_key.
    SELECT * FROM vbak INTO TABLE lt_vbak FOR ALL ENTRIES IN lt_vbeln_key WHERE vbeln = lt_vbeln_key-vbeln.
    IF sy-subrc NE 0.
      cs_step_data-check_status =  abap_false.
*  Check which vbeln was not found
      SORT ls_check_step_data-document_id BY vbeln.
      CLEAR lv_vbeln.
      LOOP AT ls_check_step_data-document_id INTO lv_vbeln.
        READ TABLE lt_vbak TRANSPORTING NO FIELDS WITH KEY vbeln = lv_vbeln.
        IF sy-subrc NE 0.
          cs_step_data-check_status =  abap_false.
          CONCATENATE 'No database entry was found with vbeln:' lv_vbeln INTO error_message SEPARATED BY space.
          CLEAR ls_return.
          ls_return-message = error_message.
          APPEND ls_return TO et_return.
        ENDIF.
      ENDLOOP.
    ELSE.
*   get fieldinfo to check which fields of vbak structure have to be checked
      CLEAR lt_fieldinfo.
      CALL FUNCTION 'DD_INT_TABLINFO_GET'
        EXPORTING
          typename       = 'VBAK'
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
      LOOP AT ls_testdata-vbak_check INTO ls_vbak_check.
        lv_index = lv_index + 1.
        CLEAR ls_vbak.
        READ TABLE lt_vbak INTO ls_vbak INDEX lv_index.
        READ TABLE ls_testdata-vbak INTO ls_testdata_vbak INDEX lv_index.
        CLEAR ls_fieldinfo.
        LOOP AT lt_fieldinfo INTO ls_fieldinfo.
          ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbak_check TO <lv_fieldvalue>.
          IF <lv_fieldvalue> EQ 'X'.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbak TO <lv_document_value>.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_testdata_vbak TO <lv_testdata_value>.

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
              cs_step_data-check_status =  abap_false.
              msg_str1 = <lv_testdata_value>.
              msg_str2 = <lv_document_value>.
              CONCATENATE 'The Value of the VBAK field ' ls_fieldinfo-fieldname 'is not as expected. The expected value is:' msg_str1
                          '. The stored value is:' msg_str2 INTO error_message SEPARATED BY space.
              CLEAR ls_return.
              ls_return-message = error_message.
              APPEND ls_return TO et_return.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD compare_vbap_data.

    DATA: ls_testdata        TYPE cl_ptf_bo_or=>ty_gs_ptf_sd_check_td,
          ls_vbap_check      TYPE sdbil_tst_vbap_check,
          lv_prestepnumber   TYPE LINE OF cl_ptf_util=>gt_ptf_step-reference_step,
          ls_check_step_data TYPE cl_ptf_util=>gt_ptf_step,
          lt_vbap            TYPE TABLE OF vbap,
          ls_vbap            TYPE vbap,
          ls_testdata_vbap   TYPE vbap,
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
    cs_step_data-check_status  = abap_true.
*  retrieve reference BOs from DB
    TYPES:
      BEGIN OF ty_vbeln_orig,
        vbeln TYPE vbeln,
      END OF ty_vbeln_orig.
    DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.
    MOVE ls_check_step_data-document_id TO lt_vbeln_key.
    SELECT * FROM vbap INTO TABLE lt_vbap FOR ALL ENTRIES IN lt_vbeln_key
      WHERE vbeln = lt_vbeln_key-vbeln ORDER BY PRIMARY KEY.
    IF sy-subrc NE 0.
      cs_step_data-check_status  = abap_false.
*  Check which vbeln was not found
      SORT ls_check_step_data-document_id BY vbeln.
      CLEAR lv_vbeln.
      LOOP AT ls_check_step_data-document_id INTO lv_vbeln.
        READ TABLE lt_vbap TRANSPORTING NO FIELDS WITH KEY vbeln = lv_vbeln.
        IF sy-subrc NE 0.
          cs_step_data-check_status = abap_false.
          CONCATENATE 'No database entry was found with vbeln:' lv_vbeln INTO error_message SEPARATED BY space.
          CLEAR ls_return.
          ls_return-message = error_message.
          APPEND ls_return TO et_return.
        ENDIF.
      ENDLOOP.
    ELSE.
*   get fieldinfo to check which fields of vbap structure have to be checked
      CLEAR lt_fieldinfo.
      CALL FUNCTION 'DD_INT_TABLINFO_GET'
        EXPORTING
          typename       = 'VBAP'
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
      LOOP AT ls_testdata-vbap_check INTO ls_vbap_check.
        lv_index = lv_index + 1.
        CLEAR ls_vbap.
        READ TABLE lt_vbap INTO ls_vbap INDEX lv_index.
        READ TABLE ls_testdata-vbap INTO ls_testdata_vbap INDEX lv_index.
        CLEAR ls_fieldinfo.
        LOOP AT lt_fieldinfo INTO ls_fieldinfo.
          ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbap_check TO <lv_fieldvalue>.
          IF <lv_fieldvalue> EQ 'X'.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbap TO <lv_document_value>.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_testdata_vbap TO <lv_testdata_value>.

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
              cs_step_data-check_status = abap_false.
              msg_str1 = <lv_testdata_value>.
              msg_str2 = <lv_document_value>.
              CONCATENATE 'The Value of the VBAP field ' ls_fieldinfo-fieldname 'is not as expected. The expected value is:' msg_str1
                          '. The stored value is:' msg_str2 INTO error_message SEPARATED BY space.
              CLEAR ls_return.
              ls_return-message = error_message.
              APPEND ls_return TO et_return.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


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
    cs_step_data-check_status = abap_true.
*  retrieve reference BOs from DB
    TYPES:
      BEGIN OF ty_vbeln_orig,
        vbeln TYPE vbeln,
      END OF ty_vbeln_orig.
    DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.
    MOVE ls_check_step_data-document_id TO lt_vbeln_key.
    SELECT * FROM vbrk INTO TABLE lt_vbrk FOR ALL ENTRIES IN lt_vbeln_key WHERE vbeln = lt_vbeln_key-vbeln.
    IF sy-subrc NE 0.
      cs_step_data-check_status = abap_false.
*  Check which vbeln was not found
      SORT ls_check_step_data-document_id BY vbeln.
      CLEAR lv_vbeln.
      LOOP AT ls_check_step_data-document_id INTO lv_vbeln.
        READ TABLE lt_vbrk TRANSPORTING NO FIELDS WITH KEY vbeln = lv_vbeln.
        IF sy-subrc NE 0.
          cs_step_data-check_status = abap_false.
          CONCATENATE 'No database entry was found with vbeln:' lv_vbeln INTO error_message SEPARATED BY space.
          CLEAR ls_return.
          ls_return-message = error_message.
          APPEND ls_return TO et_return.
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
          ASSERT sy-subrc is initial.
          IF <lv_fieldvalue> EQ 'X'.
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

            IF <lv_document_value> NE <lv_testdata_value>.
              cs_step_data-check_status = abap_false.
              msg_str1 = <lv_testdata_value>.
              msg_str2 = <lv_document_value>.
              CONCATENATE 'The Value of the VBRK field ' ls_fieldinfo-fieldname 'is not as expected. The expected value is:' msg_str1
                          '. The stored value is:' msg_str2  INTO error_message SEPARATED BY space.
              CLEAR ls_return.
              ls_return-message = error_message.
              APPEND ls_return TO et_return.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD compare_vbrp_data.

    DATA: ls_testdata        TYPE cl_ptf_bo_invoice=>ty_gs_ptf_bd_check_td,
          ls_vbrp_check      TYPE sdbil_tst_vbrp_check,
          lv_prestepnumber   TYPE LINE OF cl_ptf_util=>gt_ptf_step-reference_step,
          ls_check_step_data TYPE cl_ptf_util=>gt_ptf_step,
          lt_vbrp            TYPE TABLE OF vbrp,
          ls_vbrp            TYPE vbrp,
          ls_testdata_vbrp   TYPE vbrp,
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
    cs_step_data-check_status  = abap_true.
*  retrieve reference BOs from DB
    TYPES:
      BEGIN OF ty_vbeln_orig,
        vbeln TYPE vbeln,
      END OF ty_vbeln_orig.
    DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.
    MOVE ls_check_step_data-document_id TO lt_vbeln_key.
    SELECT * FROM vbrp INTO TABLE lt_vbrp FOR ALL ENTRIES IN lt_vbeln_key
      WHERE vbeln = lt_vbeln_key-vbeln ORDER BY PRIMARY KEY.
    IF sy-subrc NE 0.
      cs_step_data-check_status  = abap_false.
*  Check which vbeln was not found
      SORT ls_check_step_data-document_id BY vbeln.
      CLEAR lv_vbeln.
      LOOP AT ls_check_step_data-document_id INTO lv_vbeln.
        READ TABLE lt_vbrp TRANSPORTING NO FIELDS WITH KEY vbeln = lv_vbeln.
        IF sy-subrc NE 0.
          cs_step_data-check_status  = abap_false.
          CONCATENATE 'No database entry was found with vbeln:' lv_vbeln INTO error_message SEPARATED BY space.
          CLEAR ls_return.
          ls_return-message = error_message.
          APPEND ls_return TO et_return.
        ENDIF.
      ENDLOOP.
    ELSE.
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
      DESCRIBE TABLE lt_vbrp LINES DATA(len_vbrp).

      IF len_check EQ len_vbrp.
        lv_index = 0.
        LOOP AT ls_testdata-vbrp_check INTO ls_vbrp_check.
          lv_index = lv_index + 1.
          CLEAR ls_vbrp.
          READ TABLE lt_vbrp INTO ls_vbrp INDEX lv_index.
          READ TABLE ls_testdata-vbrp INTO ls_testdata_vbrp INDEX lv_index.
          CLEAR ls_fieldinfo.
          LOOP AT lt_fieldinfo INTO ls_fieldinfo.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbrp_check TO <lv_fieldvalue>.
            IF <lv_fieldvalue> EQ 'X'.
              ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbrp TO <lv_document_value>.
              ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_testdata_vbrp TO <lv_testdata_value>.

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
                cs_step_data-check_status = abap_false.
                msg_str1 = <lv_testdata_value>.
                msg_str2 = <lv_document_value>.
                CONCATENATE 'The Value of the VBRP field ' ls_fieldinfo-fieldname 'is not as expected. The expected value is:' msg_str1
                            '. The stored value is:' msg_str2 INTO error_message SEPARATED BY space.
                CLEAR ls_return.
                ls_return-message = error_message.
                APPEND ls_return TO et_return.
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDLOOP.
      ELSE.
        cs_step_data-check_status = abap_false.
        msg_str1 = len_check.
        msg_str2 = len_vbrp.
        CONCATENATE 'Quantity of expected position:' msg_str1
        'Quantity of actual position:' msg_str2 INTO error_message SEPARATED BY space.
        CLEAR ls_return.
        ls_return-message = error_message.
        APPEND ls_return TO et_return.

      ENDIF.

    ENDIF.
  ENDMETHOD.


  METHOD do_commitment.

    DATA ls_return TYPE bapiret2.

    ls_return = is_return.
    IF is_return IS NOT INITIAL.
      APPEND is_return TO ct_return.
    ENDIF.

    CLEAR ls_return.
    IF it_return IS NOT INITIAL.
      LOOP AT it_return  INTO ls_return.
        APPEND ls_return TO ct_return.
      ENDLOOP.
    ENDIF.

    CLEAR ls_return.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait   = abap_true  " Use of Command `COMMIT AND WAIT`
      IMPORTING
        return = ls_return.  " Return Messages
    APPEND ls_return TO ct_return.

  ENDMETHOD.


  METHOD get_predecessor_vbeln.

    LOOP AT cs_step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_vo_bo>).
      LOOP AT ct_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data>) WHERE step_number = <ls_vo_bo>.
        LOOP AT <ls_step_data>-document_id  ASSIGNING FIELD-SYMBOL(<ls_vbeln>).
          APPEND <ls_vbeln> TO et_vbeln.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_testdata.
    DATA lo_cl_ptf_util TYPE REF TO cl_ptf_util.
    DATA: go_struct          TYPE REF TO cl_abap_structdescr,
          go_tablestruct     TYPE REF TO cl_abap_structdescr,
          go_table           TYPE REF TO cl_abap_tabledescr,
          gt_components      TYPE abap_component_tab,
          gt_tablecomponents TYPE abap_component_tab,
          gs_components      TYPE abap_componentdescr,
          gs_tablecomponents TYPE abap_componentdescr,
          lr_datadescr       TYPE REF TO cl_abap_datadescr.

    DATA: lv_input TYPE string.
    FIELD-SYMBOLS <lv_value> TYPE any.
    FIELD-SYMBOLS <lv_system_value> TYPE any.
    FIELD-SYMBOLS <lv_table> TYPE ANY TABLE.




    TRY.

      CREATE OBJECT lo_cl_ptf_util
        EXPORTING
          iv_tdcv_name = is_step_data-variant
          iv_bo        = is_step_data-bus_obj   " Business Object for Process Test Framework
          iv_action    = is_step_data-action.   " Process Test Framework Action

        lo_cl_ptf_util->get_testdata_value(
          EXPORTING
            iv_var_name     =  is_step_data-variant
            iv_bo           =  is_step_data-bus_obj
            iv_act          =  is_step_data-action
          IMPORTING
            es_tdcv_content = es_testdata ).

      CATCH cx_ecatt_tdc_access  ##NO_HANDLER.
    ENDTRY.

*** change data to system fields if necessary ***
    TRY.
        go_struct ?= cl_abap_typedescr=>describe_by_data( es_testdata ).
        gt_components = go_struct->get_components( ).
      CATCH cx_sy_move_cast_error.
    ENDTRY.


    LOOP AT gt_components INTO gs_components.
      lr_datadescr = gs_components-type.
      DATA(lv_name) = gs_components-name.
      DATA(lv_kind) =  lr_datadescr->kind.
      CASE lv_kind.
        WHEN 'E'.
* Element
          ASSIGN COMPONENT gs_components-name OF STRUCTURE es_testdata TO <lv_value>.
          IF <lv_value> IS ASSIGNED.
            TRY.
                lv_input = ( <lv_value> ).
              CATCH cx_root.
                .
            ENDTRY.

            IF lv_input IS NOT INITIAL.
              cl_ptf_util=>get_syst_field(
                EXPORTING
                  iv_field_name  = lv_input
                IMPORTING
                  ev_field_value = <lv_value>
              ).
            ENDIF.
          ENDIF.

        WHEN 'T'.
** Table
          ASSIGN COMPONENT gs_components-name OF STRUCTURE es_testdata TO <lv_table>.
          IF <lv_table> IS ASSIGNED.
            LOOP AT <lv_table> ASSIGNING FIELD-SYMBOL(<ls_table>).
              TRY.
                  go_tablestruct ?= cl_abap_typedescr=>describe_by_data( <ls_table> ).
                CATCH cx_sy_move_cast_error INTO DATA(lx_error_conv).
                  TRY.
                      lv_input = ( <ls_table> ).
                    CATCH cx_root.
                  ENDTRY.

                  IF lv_input IS NOT INITIAL.
                    TRY.
                        cl_ptf_util=>get_syst_field(
                          EXPORTING
                            iv_field_name  = lv_input
                          IMPORTING
                            ev_field_value = <lv_value>
                        ).
                      CATCH cx_sy_dyn_call_illegal_type.
                    ENDTRY.
                  ENDIF.
              ENDTRY.
              IF lx_error_conv IS INITIAL.
                gt_tablecomponents = go_tablestruct->get_components( ).
                LOOP AT gt_tablecomponents INTO gs_tablecomponents.

                  ASSIGN COMPONENT gs_tablecomponents-name OF STRUCTURE <ls_table> TO <lv_value>.
                  IF <lv_value> IS ASSIGNED.
                    TRY.
                        lv_input = ( <lv_value> ).
                      CATCH cx_root.
                    ENDTRY.

                    IF lv_input IS NOT INITIAL.
                      TRY.
                          cl_ptf_util=>get_syst_field(
                            EXPORTING
                              iv_field_name  = lv_input
                            IMPORTING
                              ev_field_value = <lv_value>
                          ).
                        CATCH cx_sy_dyn_call_illegal_type.
                      ENDTRY.
                    ENDIF.
                  ENDIF.
                ENDLOOP.
              ENDIF.
            ENDLOOP.

          ENDIF.

* Structure
        WHEN 'v'.
          ASSIGN COMPONENT gs_components-name OF STRUCTURE es_testdata TO <lv_table>.
          go_tablestruct ?= cl_abap_typedescr=>describe_by_data( <ls_table> ).
          gt_tablecomponents = go_tablestruct->get_components( ).
          LOOP AT gt_tablecomponents INTO gs_tablecomponents.
            ASSIGN COMPONENT gs_tablecomponents-name OF STRUCTURE <ls_table> TO <lv_value>.
            IF <lv_value> IS ASSIGNED.
              TRY.
                  lv_input = ( <lv_value> ).
                CATCH cx_root.
              ENDTRY.

              IF lv_input IS NOT INITIAL.
                TRY.
                    cl_ptf_util=>get_syst_field(
                      EXPORTING
                        iv_field_name  = lv_input
                      IMPORTING
                        ev_field_value = <lv_value>
                    ).
                  CATCH cx_sy_dyn_call_illegal_type.
                ENDTRY.
              ENDIF.
            ENDIF.
          ENDLOOP.

      ENDCASE.
    ENDLOOP.
  ENDMETHOD.


  METHOD is_new_version.
    rv_is_new_version = abap_false.
  ENDMETHOD.


  METHOD prestep_posnr.

    DATA: error_message TYPE bapi_msg,
          ls_return     TYPE bapiret2.

    DATA: lv_init_posnr TYPE i.
    LOOP AT is_data-item_list ASSIGNING FIELD-SYMBOL(<ls_item_list>).
      IF <ls_item_list>-posnr IS INITIAL.
        ADD 1 TO lv_init_posnr.
      ENDIF.
    ENDLOOP.

    IF lv_init_posnr = 0.
      "if Postionnumber is filled for every Item, check for Duplicates
      SORT is_data-item_list  BY posnr.
      DELETE ADJACENT DUPLICATES FROM is_data-item_list  COMPARING posnr.
      IF sy-subrc = 0.
        CONCATENATE   'Duplicates in column PostionNumber are not allowed!' 'The variant is:' is_step_data-variant INTO error_message.
        CLEAR ls_return.
        ls_return-message = error_message.
        APPEND ls_return TO ct_return.
      ENDIF.
    ELSEIF lv_init_posnr = lines( is_data-item_list ).
      "if Postionnumber is never filled, determine Postionnumber for every Item
      LOOP AT is_data-item_list  ASSIGNING  <ls_item_list>.
        <ls_item_list>-posnr = sy-tabix * 10.
      ENDLOOP.
    ELSEIF lv_init_posnr < lines( is_data-item_list ).
      CONCATENATE   'You have to fill every or no field in column PositionNumber!' 'Variant is:' is_step_data-variant INTO error_message.
      CLEAR ls_return.
      ls_return-message = error_message.
      APPEND ls_return TO ct_return.
    ELSE.
      CONCATENATE   'Error in the input data.' 'The variant is:' is_step_data-variant INTO error_message.
      CLEAR ls_return.
      ls_return-message = error_message.
      APPEND ls_return TO ct_return.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
