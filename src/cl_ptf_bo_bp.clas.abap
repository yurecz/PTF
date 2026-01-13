CLASS cl_ptf_bo_bp DEFINITION
  PUBLIC
  INHERITING FROM cl_ptf_bo
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_fplt_check,
        mandt        TYPE abap_bool,
        fplnr	       TYPE abap_bool,
        fpltr	       TYPE abap_bool,
        fpttp	       TYPE abap_bool,
        tetxt	       TYPE abap_bool,
        fkdat	       TYPE abap_bool,
        fpfix	       TYPE abap_bool,
        fareg	       TYPE abap_bool,
        fproz	       TYPE abap_bool,
        waers	       TYPE abap_bool,
        kurfp	       TYPE abap_bool,
        fakwr	       TYPE abap_bool,
        faksp	       TYPE abap_bool,
        fkarv	       TYPE abap_bool,
        fksaf	       TYPE abap_bool,
        perio	       TYPE abap_bool,
        fplae	       TYPE abap_bool,
        mlstn	       TYPE abap_bool,
        mlbez	       TYPE abap_bool,
        zterm	       TYPE abap_bool,
        kunrg	       TYPE abap_bool,
        taxk1	       TYPE abap_bool,
        taxk2	       TYPE abap_bool,
        taxk3	       TYPE abap_bool,
        taxk4	       TYPE abap_bool,
        taxk5	       TYPE abap_bool,
        taxk6	       TYPE abap_bool,
        taxk7	       TYPE abap_bool,
        taxk8	       TYPE abap_bool,
        taxk9	       TYPE abap_bool,
        valtg	       TYPE abap_bool,
        valdt	       TYPE abap_bool,
        nfdat	       TYPE abap_bool,
        teman	       TYPE abap_bool,
        fakca	       TYPE abap_bool,
        afdat	       TYPE abap_bool,
        netwr	       TYPE abap_bool,
        netpr	       TYPE abap_bool,
        wavwr	       TYPE abap_bool,
        kzwi1	       TYPE abap_bool,
        kzwi2	       TYPE abap_bool,
        kzwi3	       TYPE abap_bool,
        kzwi4	       TYPE abap_bool,
        kzwi5	       TYPE abap_bool,
        kzwi6	       TYPE abap_bool,
        cmpre	       TYPE abap_bool,
        skfbp	       TYPE abap_bool,
        bonba	       TYPE abap_bool,
        prsok	       TYPE abap_bool,
        typzm	       TYPE abap_bool,
        cmpre_flt	   TYPE abap_bool,
        uelnr	       TYPE abap_bool,
        ueltr	       TYPE abap_bool,
        kurrf	       TYPE abap_bool,
        ccact	       TYPE abap_bool,
        korte	       TYPE abap_bool,
        ofkdat       TYPE abap_bool,
        descr	       TYPE abap_bool,
        postpr       TYPE abap_bool,
        refdoc       TYPE abap_bool,
        set_by_final TYPE abap_bool,
        item_usage   TYPE abap_bool,
        db_key       TYPE abap_bool,
        parent_key   TYPE abap_bool,
        _dataaging   TYPE abap_bool,
*.APPEND  type abap_bool,
        ad04fareg    TYPE abap_bool,
*    .APPEND  type abap_bool,
        perop_beg    TYPE abap_bool,
        perop_end    TYPE abap_bool,
      END OF ty_fplt_check,

      BEGIN OF ty_fpla_check,
        fplnr	           TYPE abap_bool,
        fptyp	           TYPE abap_bool,
        bpcat	           TYPE abap_bool,
        fpart	           TYPE abap_bool,
        sortl	           TYPE abap_bool,
        bedat	           TYPE abap_bool,
        endat	           TYPE abap_bool,
        horiz	           TYPE abap_bool,
        vbeln	           TYPE abap_bool,
        bedar	           TYPE abap_bool,
        endar	           TYPE abap_bool,
        perio	           TYPE abap_bool,
        fplae	           TYPE abap_bool,
        rfpln	           TYPE abap_bool,
        lodat	           TYPE abap_bool,
        autte	           TYPE abap_bool,
        lodar	           TYPE abap_bool,
        peraf	           TYPE abap_bool,
        fakca	           TYPE abap_bool,
        tndat	           TYPE abap_bool,
        aufpl	           TYPE abap_bool,
        aplzl	           TYPE abap_bool,
        rsnum	           TYPE abap_bool,
        rspos	           TYPE abap_bool,
        ebeln	           TYPE abap_bool,
        fpltu	           TYPE abap_bool,
        aust1	           TYPE abap_bool,
        aust2	           TYPE abap_bool,
        aust3	           TYPE abap_bool,
        aust4	           TYPE abap_bool,
        aust5	           TYPE abap_bool,
        basiswrt         TYPE abap_bool,
        waers	           TYPE abap_bool,
        pspnr	           TYPE abap_bool,
        autkor           TYPE abap_bool,
        status           TYPE abap_bool,
        final	           TYPE abap_bool,
        db_key           TYPE abap_bool,
        _dataaging       TYPE abap_bool,
        ifrs15_relevance TYPE abap_bool,
      END OF ty_fpla_check.

    TYPES:
* Structure for check of billing plans
      fplt_tab       TYPE STANDARD TABLE OF fplt WITH DEFAULT KEY,
      fpla_tab       TYPE STANDARD TABLE OF fplt WITH DEFAULT KEY,
      fplt_check_tab TYPE STANDARD TABLE OF ty_fplt_check WITH DEFAULT KEY,
      fpla_check_tab TYPE STANDARD TABLE OF ty_fpla_check WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_gs_ptf_bp_check_td,
        fplt       TYPE fplt_tab,
        fpla       TYPE fpla_tab,
        fplt_check TYPE fplt_check_tab,
        fpla_check TYPE fpla_check_tab,
      END OF ty_gs_ptf_bp_check_td.

    CLASS-METHODS compare_fplt_data
      IMPORTING
                !is_testdata        TYPE ty_gs_ptf_bp_check_td
                !is_check_step_data TYPE cl_ptf_util=>gt_ptf_step
                !iv_run_environment TYPE REF TO cl_ptf_run
      RETURNING VALUE(rv_equals)    TYPE abap_bool.


    METHODS: create REDEFINITION,
      change REDEFINITION,
      delete REDEFINITION,
      check REDEFINITION,
      execute_action REDEFINITION,
      execute_check REDEFINITION,
      check_existence REDEFINITION,
      check_status_after_pbd_rej
        IMPORTING
          !step_data           TYPE cl_ptf_util=>gt_ptf_step
          !iv_step_number      TYPE i
        EXPORTING
          !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
          !ev_execution_status TYPE abap_bool
          !ev_check_status     TYPE abap_bool .

  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS c_check_status_after_pbd_rej TYPE String VALUE 'CHECK_STATUS_PBD_REJ'.
ENDCLASS.



CLASS CL_PTF_BO_BP IMPLEMENTATION.


  METHOD change.
  ENDMETHOD.


  METHOD check.

    DATA: ls_check_step_data TYPE cl_ptf_util=>gt_ptf_step,
          lv_step_success    TYPE abap_bool,
          ls_testdata        TYPE ty_gs_ptf_bp_check_td,
          ls_return          TYPE bapiret2,
          error_message      TYPE bapi_msg,
          var_step           TYPE string.

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata     "might be empty...
    ).

    lv_step_success = abap_true.
    CLEAR: ls_check_step_data.
    IF ls_testdata-fplt_check IS NOT INITIAL OR ls_testdata-fplt_check IS NOT INITIAL.
*  Check if reference step number for checking object is filled and reference object exists
      LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_prestepnumber>).
        ls_check_step_data = me->mo_run_environment->get_step_data( iv_step_number = <lv_prestepnumber> ).
        IF ls_check_step_data-document_id IS INITIAL.
          lv_step_success = abap_false.
          CLEAR ls_return.
          ls_return-message = 'No reference document exists!'.
          me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
        ELSE.

          IF ls_testdata-fplt_check IS NOT INITIAL.
            me->compare_fplt_data(
              EXPORTING
                is_testdata        = ls_testdata
                is_check_step_data = ls_check_step_data
                iv_run_environment = me->mo_run_environment
              RECEIVING
                rv_equals       = ev_check_status
            ).
            IF ev_check_status EQ abap_false.
              lv_step_success = abap_false.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.

    ev_check_status = lv_step_success.
** Output in case of success
    IF ev_check_status EQ abap_true.
      ev_execution_status = abap_true.
      var_step = ls_step_data-step_number.
      CONCATENATE 'The values of the checked document are correct. Process step is:' var_step   INTO error_message SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = |{ error_message }| ).
    ELSE.
      ev_execution_status = abap_true.
      var_step = ls_step_data-step_number.
      CONCATENATE 'The values of the checked document are NOT correct. Process step is:' var_step   INTO error_message SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = |{ error_message }| ).
    ENDIF.


  ENDMETHOD.


  METHOD check_existence.
  ENDMETHOD.


  METHOD check_status_after_pbd_rej.
*    Checks the billing status of billing plan items after FAZ and PBD + PBD rejection
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    DATA: lt_vbeln TYPE cl_ptf_util=>ty_vbeln_tab,
          lt_fplt  TYPE TABLE OF fplt,
          lv_fplt  TYPE fplt.

    ev_check_status = abap_false.
    ev_execution_status = abap_false.

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.


    IF lt_vbeln IS NOT INITIAL.
      LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<lv_vbel>).
        SELECT  fplnr, fksaf FROM fplt WHERE fplnr = @<lv_vbel>-vbeln INTO CORRESPONDING FIELDS OF TABLE @lt_fplt.
        IF sy-subrc <> 0.
          "Document not found
          me->mo_run_environment->append_log( iv_log_statement = |Could not find billing plan { <lv_vbel>-vbeln }.| ).
        ELSE.
          LOOP AT lt_fplt ASSIGNING FIELD-SYMBOL(<lv_fplt>).
*           TO DO!!: How to check which elements fksaf?:
            me->mo_run_environment->append_log( iv_log_statement = |BillingPlan-Number: { <lv_vbel>-vbeln }  /  fksaf: { <lv_fplt>-fksaf } | ).
          ENDLOOP.
          ev_execution_status = abap_true.
        ENDIF.
        CLEAR lv_fplt.
      ENDLOOP.
      CLEAR lt_fplt.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |No billing plans found.| ).
      RETURN.
    ENDIF.


  ENDMETHOD.


  METHOD compare_fplt_data.
    DATA: ls_testdata        TYPE ty_gs_ptf_bp_check_td,
          ls_check_step_data TYPE cl_ptf_util=>gt_ptf_step,
          lt_fplt            TYPE TABLE OF fplt,
          lt_fieldinfo       TYPE extdfiest,
          lv_index           TYPE i,
          ls_fplt_check      TYPE ty_fplt_check,
          ls_fplt            TYPE fplt,
          ls_testdata_fplt   TYPE fplt,
          lv_vbeln           TYPE vbeln,
          lv_input           TYPE string,
          ls_fieldinfo       TYPE LINE OF extdfiest,
          msg_str1           TYPE string,
          msg_str2           TYPE string.

    FIELD-SYMBOLS: <lv_testdata_value> TYPE any,
                   <lv_document_value> TYPE any,
                   <lv_fieldvalue>     TYPE any.


    ls_testdata = is_testdata.
    ls_check_step_data = is_check_step_data.
    rv_equals =  abap_true.

    TYPES:
      BEGIN OF ty_vbeln_orig,
        vbeln TYPE vbeln,
      END OF ty_vbeln_orig.
    DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.
    MOVE ls_check_step_data-document_id TO lt_vbeln_key.

    SELECT * FROM fplt INTO TABLE lt_fplt FOR ALL ENTRIES IN lt_vbeln_key WHERE fplnr = lt_vbeln_key-vbeln.

    IF sy-subrc NE 0.
      rv_equals =  abap_false.
*  Check which vbeln was not found
      SORT ls_check_step_data-document_id BY vbeln.
      CLEAR lv_vbeln.
      LOOP AT ls_check_step_data-document_id INTO lv_vbeln.
        READ TABLE lt_fplt TRANSPORTING NO FIELDS WITH KEY fplnr = lv_vbeln.
        IF sy-subrc NE 0.
          rv_equals =  abap_false.
          iv_run_environment->append_log( iv_log_statement = |No database entry was found with vbeln: { lv_vbeln } | ).
        ENDIF.
      ENDLOOP.
    ELSE.
*   get fieldinfo to check which fields of fplt structure have to be checked
      CLEAR lt_fieldinfo.
      CALL FUNCTION 'DD_INT_TABLINFO_GET'
        EXPORTING
          typename       = 'fplt'
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
      LOOP AT ls_testdata-fplt_check INTO ls_fplt_check.
        lv_index = lv_index + 1.
        CLEAR ls_fplt.
        READ TABLE lt_fplt INTO ls_fplt INDEX lv_index.
        READ TABLE ls_testdata-fplt INTO ls_testdata_fplt INDEX lv_index.
        CLEAR ls_fieldinfo.
        LOOP AT lt_fieldinfo INTO ls_fieldinfo.
          ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_fplt_check TO <lv_fieldvalue>.
          IF sy-subrc EQ 0 AND <lv_fieldvalue> EQ 'X'.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_fplt TO <lv_document_value>.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_testdata_fplt TO <lv_testdata_value>.

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
              rv_equals =  abap_false.
              msg_str1 = <lv_testdata_value>.
              msg_str2 = <lv_document_value>.
              iv_run_environment->append_log( iv_log_statement = |The Value of the FPLT field { ls_fieldinfo-fieldname } is not as expected. The expected value is: { msg_str1 }. The stored value is: { msg_str2 }| ).
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDLOOP.


    ENDIF.

  ENDMETHOD.


  METHOD create.
  ENDMETHOD.


  METHOD delete.
  ENDMETHOD.


  METHOD execute_action.
  ENDMETHOD.


  METHOD execute_check.
    DATA(lv_step_data) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).

    CASE lv_step_data-action.
      WHEN c_check_status_after_pbd_rej.
        me->check_status_after_pbd_rej(
                  EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
    ENDCASE.



  ENDMETHOD.
ENDCLASS.
