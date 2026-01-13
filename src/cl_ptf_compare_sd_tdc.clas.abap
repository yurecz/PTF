class cl_ptf_compare_sd_tdc definition
  public
  final
  create public .

  public section.

    class-methods compare_vbak_data
      importing
        !is_testdata        type cl_ptf_bo_or=>ty_gs_ptf_sd_check_td
        !is_check_step_data type cl_ptf_util=>gt_ptf_step
        !iv_run_environment type ref to cl_ptf_run
      returning
        value(rv_is_equal)  type abap_bool .
    class-methods compare_vbap_data
      importing
        !is_testdata        type cl_ptf_bo_or=>ty_gs_ptf_sd_check_td
        !is_check_step_data type cl_ptf_util=>gt_ptf_step
        !iv_run_environment type ref to cl_ptf_run
      returning
        value(rv_is_equal)  type abap_bool .
    class-methods compare_vbep_data
      importing
        !is_testdata        type cl_ptf_bo_or=>ty_gs_ptf_sd_check_td_ext
        !is_check_step_data type cl_ptf_util=>gt_ptf_step
        !iv_run_environment type ref to cl_ptf_run
      returning
        value(rv_is_equal)  type abap_bool .
  protected section.
  private section.
ENDCLASS.



CLASS CL_PTF_COMPARE_SD_TDC IMPLEMENTATION.


  method compare_vbak_data.

    data: ls_testdata        type cl_ptf_bo_or=>ty_gs_ptf_sd_check_td,
          ls_vbak_check      type sdbil_tst_vbak_check,
          lv_prestepnumber   type line of cl_ptf_util=>gt_ptf_step-reference_step,
          ls_check_step_data type cl_ptf_util=>gt_ptf_step,
          lt_vbak            type table of vbak,
          ls_vbak            type vbak,
          ls_testdata_vbak   type vbak,
          lv_vbeln           type vbeln,
          lt_fieldinfo       type extdfiest,
          ls_fieldinfo       type line of extdfiest,
          lv_fieldname       type fieldname,
          lv_index           type i,
          error_message      type bapi_msg,
          ls_return          type bapiret2,
          lv_input           type string,
          msg_str1           type string,
          msg_str2           type string.


    field-symbols: <lv_testdata_value> type any,
                   <lv_document_value> type any,
                   <lv_fieldvalue>     type any.


    ls_testdata = is_testdata.
    ls_check_step_data = is_check_step_data.
    rv_is_equal =  abap_true.
*  retrieve reference BOs from DB
    types:
      begin of ty_vbeln_orig,
        vbeln type vbeln,
      end of ty_vbeln_orig.
    data: lt_vbeln_key type table of ty_vbeln_orig.
    move ls_check_step_data-document_id to lt_vbeln_key.
    select * from vbak into table lt_vbak for all entries in lt_vbeln_key where vbeln = lt_vbeln_key-vbeln.
    if sy-subrc ne 0.
      rv_is_equal =  abap_false.
*  Check which vbeln was not found
      sort ls_check_step_data-document_id by vbeln.
      clear lv_vbeln.
      loop at ls_check_step_data-document_id into lv_vbeln.
        read table lt_vbak transporting no fields with key vbeln = lv_vbeln.
        if sy-subrc ne 0.
          rv_is_equal =  abap_false.
          iv_run_environment->append_log( iv_log_statement = |No database entry was found with vbeln: { lv_vbeln } | ).
        endif.
      endloop.
    else.
*   get fieldinfo to check which fields of vbak structure have to be checked
      clear lt_fieldinfo.
      call function 'DD_INT_TABLINFO_GET'
        exporting
          typename       = 'VBAK'
        tables
          extdfies_tab   = lt_fieldinfo
        exceptions
          not_found      = 1
          internal_error = 2
          others         = 3.
      if sy-subrc <> 0.
        return.
      endif.

      lv_index = 0.
      loop at ls_testdata-vbak_check into ls_vbak_check.
        lv_index = lv_index + 1.
        clear ls_vbak.
        read table lt_vbak into ls_vbak index lv_index.
        read table ls_testdata-vbak into ls_testdata_vbak index lv_index.
        clear ls_fieldinfo.
        loop at lt_fieldinfo into ls_fieldinfo.
          assign component ls_fieldinfo-fieldname of structure ls_vbak_check to <lv_fieldvalue>.
          if sy-subrc = 0.
            if sy-subrc EQ 0 and <lv_fieldvalue> eq 'X'.
              assign component ls_fieldinfo-fieldname of structure ls_vbak to <lv_document_value>.
              if sy-subrc <> 0.
                continue.
              endif.
              assign component ls_fieldinfo-fieldname of structure ls_testdata_vbak to <lv_testdata_value>.
              if sy-subrc <> 0.
                continue.
              endif.

*             This method converts strings to corresponding system fields
              lv_input = ( <lv_testdata_value> ).
              try.
                  cl_ptf_util=>get_syst_field(
                    exporting
                      iv_field_name  = lv_input
                    importing
                      ev_field_value = <lv_testdata_value>
                  ).
                catch cx_sy_dyn_call_illegal_type.
              endtry.

              if <lv_document_value> ne <lv_testdata_value>.
                rv_is_equal =  abap_false.
                msg_str1 = <lv_testdata_value>.
                msg_str2 = <lv_document_value>.
                iv_run_environment->append_log( iv_log_statement = |The value of the VBAK field { ls_fieldinfo-fieldname } is not as expected.| ).
                iv_run_environment->append_log( iv_log_statement = | Expected value is: { msg_str1 }. Stored value is: { msg_str2 }| ).
              endif.

              unassign: <lv_document_value>,
                        <lv_testdata_value>.
            endif.
            unassign <lv_fieldvalue>.
          endif.
        endloop.
      endloop.
    endif.
  endmethod.


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
          lv_input           TYPE string,
          msg_str1           TYPE string,
          msg_str2           TYPE string.

    TYPES:
      BEGIN OF ty_vbeln_orig,
        vbeln TYPE vbeln,
      END OF ty_vbeln_orig.
    DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.


    FIELD-SYMBOLS: <lv_testdata_value> TYPE any,
                   <lv_document_value> TYPE any,
                   <lv_fieldvalue>     TYPE any.

    ls_testdata = is_testdata.
    ls_check_step_data = is_check_step_data.
    rv_is_equal  = abap_true.

*  retrieve reference BOs from DB
    MOVE ls_check_step_data-document_id TO lt_vbeln_key.
    SELECT * FROM vbap INTO TABLE lt_vbap FOR ALL ENTRIES IN lt_vbeln_key
      WHERE vbeln = lt_vbeln_key-vbeln ORDER BY PRIMARY KEY.
    IF sy-subrc NE 0.
      rv_is_equal  = abap_false.
*  Check which vbeln was not found
      SORT ls_check_step_data-document_id BY vbeln.
      CLEAR lv_vbeln.
      LOOP AT ls_check_step_data-document_id INTO lv_vbeln.
        READ TABLE lt_vbap TRANSPORTING NO FIELDS WITH KEY vbeln = lv_vbeln.
        IF sy-subrc NE 0.
          rv_is_equal = abap_false.
          iv_run_environment->append_log( iv_log_statement = |No database entry was found with VBELN: { lv_vbeln }| ).
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

      DATA(lv_lines_with_flags) =    lines( ls_testdata-vbap_check ).
      "DATA(lv_lines_w_expctd_data) = lines( ls_testdata-vbap ).
      DATA(lv_lines_in_doc) =        lines( lt_vbap ).
      "if lv_lines_with_flags GT lv_lines_w_expctd_data.
      IF lv_lines_with_flags GT lv_lines_in_doc.
        rv_is_equal = abap_false.
        iv_run_environment->append_log( iv_log_statement = |The document has less items than expected. Items in VBAP: { lv_lines_in_doc }| ).
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
          IF sy-subrc EQ 0 AND <lv_fieldvalue> EQ 'X'.
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
              rv_is_equal = abap_false.
              msg_str1 = <lv_testdata_value>.
              msg_str2 = <lv_document_value>.
              iv_run_environment->append_log( iv_log_statement = |The value of the VBAP field { ls_fieldinfo-fieldname } is not as expected.| ).
              iv_run_environment->append_log( iv_log_statement = | Expected value is: { msg_str1 }. Stored value is: { msg_str2 }| ).
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  method compare_vbep_data.

    data: ls_testdata        type cl_ptf_bo_or=>ty_gs_ptf_sd_check_td_ext,
***          ls_vbap_check      TYPE sdbil_tst_vbap_check,
          ls_vbep_check      type cl_ptf_bo_or=>ty_s_vbep_check,
          lv_prestepnumber   type line of cl_ptf_util=>gt_ptf_step-reference_step,
          ls_check_step_data type cl_ptf_util=>gt_ptf_step,
          lt_vbep            type table of vbep,
          ls_vbep            type vbep,
          ls_testdata_vbep   type vbep,
          lv_vbeln           type vbeln,
          lt_fieldinfo       type extdfiest,
          ls_fieldinfo       type line of extdfiest,
          lv_fieldname       type fieldname,
          lv_index           type i,
          error_message      type bapi_msg,
          ls_return          type bapiret2,
          lv_input           type string,
          msg_str1           type string,
          msg_str2           type string.

    types:
      begin of ty_vbeln_orig,
        vbeln type vbeln,
      end of ty_vbeln_orig.
    data: lt_vbeln_key type table of ty_vbeln_orig.


    field-symbols: <lv_testdata_value> type any,
                   <lv_document_value> type any,
                   <lv_fieldvalue>     type any.

    ls_testdata = is_testdata.
    ls_check_step_data = is_check_step_data.
    rv_is_equal  = abap_true.

*  retrieve reference BOs from DB
    move ls_check_step_data-document_id to lt_vbeln_key.
    select * from vbep into table lt_vbep for all entries in lt_vbeln_key
      where vbeln = lt_vbeln_key-vbeln order by primary key.
    if sy-subrc ne 0.
      rv_is_equal  = abap_false.
*  Check which vbeln was not found
      sort ls_check_step_data-document_id by vbeln.
      clear lv_vbeln.
      loop at ls_check_step_data-document_id into lv_vbeln.
        read table lt_vbep transporting no fields with key vbeln = lv_vbeln.
        if sy-subrc ne 0.
          rv_is_equal = abap_false.
          iv_run_environment->append_log( iv_log_statement = |No database entry was found with VBELN: { lv_vbeln }| ).
        endif.
      endloop.
    else.
*   get fieldinfo to check which fields of vbap structure have to be checked
      clear lt_fieldinfo.
      call function 'DD_INT_TABLINFO_GET'
        exporting
          typename       = 'VBEP'
        tables
          extdfies_tab   = lt_fieldinfo
        exceptions
          not_found      = 1
          internal_error = 2
          others         = 3.
      if sy-subrc <> 0.
        return.
      endif.

      data(lv_lines_with_flags) =    lines( ls_testdata-vbep_check ).
      "DATA(lv_lines_w_expctd_data) = lines( ls_testdata-vbep ).
      data(lv_lines_in_doc) =        lines( lt_vbep ).
      "if lv_lines_with_flags GT lv_lines_w_expctd_data.
      if lv_lines_with_flags gt lv_lines_in_doc.
        rv_is_equal = abap_false.
        iv_run_environment->append_log( iv_log_statement = |The document has less schedule lines than expected. Items in VBEP: { lv_lines_in_doc }| ).
      endif.

      lv_index = 0.
      loop at ls_testdata-vbep_check into ls_vbep_check.
        lv_index = lv_index + 1.
        clear ls_vbep.
        read table lt_vbep into ls_vbep index lv_index.
        read table ls_testdata-vbep into ls_testdata_vbep index lv_index.
        clear ls_fieldinfo.
        loop at lt_fieldinfo into ls_fieldinfo.
          assign component ls_fieldinfo-fieldname of structure ls_vbep_check to <lv_fieldvalue>.
          if sy-subrc EQ 0 and <lv_fieldvalue> eq 'X'.
            assign component ls_fieldinfo-fieldname of structure ls_vbep to <lv_document_value>.
            assign component ls_fieldinfo-fieldname of structure ls_testdata_vbep to <lv_testdata_value>.

* This method converts strings to corresponding system fields
            lv_input = ( <lv_testdata_value> ).
            try.
                cl_ptf_util=>get_syst_field(
                  exporting
                    iv_field_name  = lv_input
                  importing
                    ev_field_value = <lv_testdata_value>
                ).
              catch cx_sy_dyn_call_illegal_type.
            endtry.
            if <lv_document_value> ne <lv_testdata_value>.
              rv_is_equal = abap_false.
              msg_str1 = <lv_testdata_value>.
              msg_str2 = <lv_document_value>.
              iv_run_environment->append_log( iv_log_statement = |The value of the VBEP field { ls_fieldinfo-fieldname } is not as expected. The expected value is: { msg_str1 }. The stored value is: { msg_str2 }| ).
            endif.
          endif.
        endloop.
      endloop.
    endif.

  endmethod.
ENDCLASS.
