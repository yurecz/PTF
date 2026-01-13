CLASS cl_ptf_bo_invoicelist DEFINITION
  PUBLIC
  INHERITING FROM cl_ptf_bo
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS change
        REDEFINITION .
    METHODS check
        REDEFINITION .
    METHODS check_existence
        REDEFINITION .
    METHODS create
        REDEFINITION .
    METHODS delete
        REDEFINITION .
    METHODS execute_action
        REDEFINITION .
    METHODS execute_check
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS: c_odata_get_invoice_lst        TYPE string VALUE 'ODATA_GET_INVOICE_LIST'.
    CONSTANTS: c_odata_get_cancel_invoice_lst TYPE string VALUE 'ODATA_POST_CANCEL_INVOICE_LIST'.
    CONSTANTS c_clear_fi TYPE string VALUE 'CLEAR_FI' ##NO_TEXT.

    METHODS odata_get_invoice_lst
      IMPORTING
        !step_data           TYPE        cl_ptf_util=>gt_ptf_step "Parameter for better performance
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .
    METHODS odata_get_cancel_invoice_lst
      IMPORTING
        !step_data           TYPE        cl_ptf_util=>gt_ptf_step "Parameter for better performance
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .
    METHODS clear_fi
      IMPORTING
        !ls_step_data        TYPE cl_ptf_util=>gt_ptf_step
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .


ENDCLASS.



CLASS CL_PTF_BO_INVOICELIST IMPLEMENTATION.


  METHOD change.
  ENDMETHOD.


  METHOD check.
    DATA: ls_testdata      TYPE cl_ptf_bo_invoice=>ty_gs_ptf_bd_check_td,
          lv_prestepnumber TYPE LINE OF cl_ptf_util=>gt_ptf_step-reference_step,
          ls_ref_step_data TYPE cl_ptf_util=>gt_ptf_step,
          lv_vbeln         TYPE vbeln,
          ls_return        TYPE bapiret2.
***********************************************************************************************
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).
***********************************************************************************************
    ev_check_status = abap_true.
    ev_execution_status = abap_false.

    CLEAR: lv_prestepnumber, ls_ref_step_data.
    IF ls_testdata-vbrk_check IS NOT INITIAL OR ls_testdata-vbrp_check IS NOT INITIAL.

**  Check if reference step number for checking object is filled and reference document exists
      LOOP AT ls_step_data-reference_step INTO lv_prestepnumber.
        ls_ref_step_data = me->mo_run_environment->get_step_data( iv_step_number = lv_prestepnumber ).
        IF ls_ref_step_data-document_id IS INITIAL.
          ev_execution_status = abap_false.
          ev_check_status = abap_false.
          CLEAR ls_return.
          ls_return-message = 'No reference documents exist for ref step:' && lv_prestepnumber.
          me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).

        ELSE.
          DATA(lb_refdoc_found) = abap_true.
          IF ls_testdata-vbrk_check IS NOT INITIAL.
            cl_ptf_compare_bd_tdc=>compare_vbrk_data(
              EXPORTING
                is_testdata        = ls_testdata
                is_check_step_data = ls_ref_step_data
                iv_run_environment = me->mo_run_environment
              RECEIVING
                rv_is_equal        = ev_check_status
            ).
          ENDIF.
          IF ls_testdata-vbrp_check IS NOT INITIAL.
            cl_ptf_compare_bd_tdc=>compare_vbrp_data(
              EXPORTING
                is_testdata        = ls_testdata
                is_check_step_data = ls_ref_step_data
                iv_run_environment = me->mo_run_environment
              RECEIVING
                rv_is_equal        = ev_check_status
            ).
          ENDIF.
        ENDIF.
      ENDLOOP.

    ENDIF.

    CHECK lb_refdoc_found EQ abap_true.

    ev_execution_status = abap_true.

*** Output in case of success
    IF ev_check_status EQ abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |The values of the checked documents are correct.| ).
    ENDIF.

  ENDMETHOD.


  METHOD check_existence.
    DATA: lv_vbeln TYPE vbeln.
    MOVE iv_id TO lv_vbeln.

    SELECT SINGLE * FROM vbrk WHERE vbeln = @lv_vbeln INTO @DATA(ls_bd).
    IF sy-subrc <> 0.
      me->mo_run_environment->append_log( iv_log_statement = |BD { lv_vbeln } does not exist.| ).
      rv_exists = abap_false.
    ELSE.
      rv_exists = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD clear_fi.

    CONSTANTS: blart_to_clear              TYPE String VALUE 'RV',
               invoice_list_condition_dfad TYPE string VALUE 'DFAD',
               invoice_list_condition_tfad TYPE string VALUE 'TFAD'.

    DATA: clearing_header       TYPE cl_fdc_clearing_document_inf=>ty_clearing_header,
          apar_items_to_be_clrd TYPE cl_fdc_clearing_document_inf=>tty_apar_item_to_be_clrd,
          apar_item_to_be_clrd  TYPE cl_fdc_clearing_document_inf=>ty_apar_item_to_be_clrd,
          gl_items_to_be_clrd   TYPE cl_fdc_clearing_document_inf=>tty_gl_item_to_be_clrd,
*          gl_item_to_be_clrd    TYPE cl_fdc_clearing_document_inf=>ty_gl_item_to_be_clrd,
          apar_items_on_account TYPE cl_fdc_clearing_document_inf=>tty_apar_item_on_account,
          apar_item_on_account  TYPE cl_fdc_clearing_document_inf=>ty_apar_item_on_account,
          lt_vbeln              TYPE cl_ptf_util=>ty_vbeln_tab,
          awref                 TYPE acchd-awref,
          fi_documents          TYPE STANDARD TABLE OF bkpf WITH DEFAULT KEY,
          bseg_entries          TYPE STANDARD TABLE OF bseg WITH DEFAULT KEY,
          posted_document       TYPE fdc_s_accdoc_hdr_key_odata,
          messages              TYPE bapirettab,
          error_occured         TYPE abap_bool,
          test_data             TYPE cl_ptf_bo_invoice=>ty_gs_post_dpy,
          gross_amount          TYPE fdc_cdamtdc,
          all_prec_bd_paid      TYPE abap_bool.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = test_data
    ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.
    IF lt_vbeln IS INITIAL.
      me->mo_run_environment->append_log( 'There are no documentIDs to use!' ).
      RETURN.
    ENDIF.

    ev_execution_status = abap_true.

    LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<invoice_list>).
      gross_amount = 0.
      SELECT vbeln_vf FROM vbrl WHERE vbeln = @<invoice_list>-vbeln INTO TABLE @DATA(billing_documents).
      SELECT SINGLE knumv FROM vbrk WHERE vbeln = @<invoice_list>-vbeln INTO @DATA(pricing_reference).

      all_prec_bd_paid = abap_true.
      "Check that all billing documents are paid
      LOOP AT billing_documents ASSIGNING FIELD-SYMBOL(<bd>).
        SELECT SINGLE clrst FROM vbrk WHERE vbeln = @<bd>-vbeln_vf INTO @DATA(clrst).
        IF clrst NE 'C'.
          me->mo_run_environment->append_log( iv_log_statement = |Please clear the billing document { <bd>-vbeln_vf } first.| ).
          all_prec_bd_paid = abap_false.
        ENDIF.
      ENDLOOP.

      IF all_prec_bd_paid EQ abap_false.
        ev_execution_status = abap_false.
        RETURN.
      ENDIF.

      SELECT SUM( kwert ) FROM prcd_elements WHERE knumv = @pricing_reference AND ( kschl = @invoice_list_condition_dfad OR kschl = @invoice_list_condition_tfad ) INTO @gross_amount.

      gross_amount = abs( gross_amount ).

      awref = <invoice_list>-vbeln.

      CALL FUNCTION 'FI_DOCUMENT_READ'
        EXPORTING
          i_awtyp = 'VBRK'
          i_awref = awref
        TABLES
          t_bseg  = bseg_entries
          t_bkpf  = fi_documents.

      LOOP AT fi_documents ASSIGNING FIELD-SYMBOL(<fi_document>) WHERE blart = blart_to_clear.
        clearing_header-bukrs = <fi_document>-bukrs.
        clearing_header-blart = <fi_document>-blart.
        clearing_header-budat = sy-datum.
        clearing_header-bldat = sy-datum.
        clearing_header-waers = <fi_document>-waers.
        clearing_header-kursf = <fi_document>-kursf.

        LOOP AT bseg_entries ASSIGNING FIELD-SYMBOL(<bseg_entry>) WHERE belnr = <fi_document>-belnr.

          CASE <bseg_entry>-koart.
            WHEN 'D'.
              apar_item_to_be_clrd-bukrs = <bseg_entry>-bukrs.
              apar_item_to_be_clrd-koart = <bseg_entry>-koart.
              apar_item_to_be_clrd-konko = test_data-konko.
              apar_item_to_be_clrd-gjahr = <bseg_entry>-gjahr.
              apar_item_to_be_clrd-belnr = <bseg_entry>-belnr.
              apar_item_to_be_clrd-buzei = <bseg_entry>-buzei.
              APPEND apar_item_to_be_clrd TO apar_items_to_be_clrd.

              apar_item_on_account-koart = <bseg_entry>-koart.
              apar_item_on_account-konko = test_data-konko.
              apar_item_on_account-shkzg = <bseg_entry>-shkzg.
              apar_item_on_account-wrbtr = gross_amount.
              APPEND apar_item_on_account TO apar_items_on_account.
            WHEN OTHERS.
              "Not sure what to do here
          ENDCASE.
        ENDLOOP.

        NEW cl_fdc_clearing_Document_inf( )->post(
        EXPORTING
          is_clearing_header      =    clearing_header
          it_apar_item_to_be_clrd =    apar_items_to_be_clrd
          it_gl_item_to_be_clrd   =    gl_items_to_be_clrd
          it_apar_item_on_account =    apar_items_on_account
          iv_test_run             =    abap_false
        IMPORTING
          es_posted_document      =    posted_document
          et_message              =    messages
        RECEIVING
          rv_error_occured        =    error_occured
        ).

        IF error_occured EQ abap_true.
          ev_execution_status = abap_false.
          ROLLBACK WORK.
        ELSE.
          COMMIT WORK AND WAIT.
        ENDIF.

        me->mo_run_environment->append_log( iv_log_statement = |Tried to clear document { <fi_document>-belnr }. Error occured: { error_occured }| ).
        LOOP AT messages ASSIGNING FIELD-SYMBOL(<message>).
          me->mo_run_environment->append_log_structure( is_log =  <message> ).
        ENDLOOP.

      ENDLOOP. "fi_documents

    ENDLOOP.

  ENDMETHOD.


  METHOD create.
    DATA: lt_xkomfk   TYPE TABLE OF komfk,
          ls_xkomfk   TYPE komfk,
          lt_xkomv    TYPE TABLE OF   komv,
          lt_xthead   TYPE TABLE OF    theadvb,
          lt_xvbfs    TYPE TABLE OF    vbfs,
          lt_xvbpa    TYPE TABLE OF  vbpavb,
          lt_xvbrk    TYPE TABLE OF   vbrkvb,
          lt_xvbrl    TYPE TABLE OF   vbrlvb,
          lt_xvbss    TYPE TABLE OF   vbss,
          ls_vbsk     TYPE vbsk,
          lv_bad_data TYPE abap_bool,
          ls_return   TYPE bapiret2,
          lt_return   TYPE TABLE OF bapiret2,
          lt_vbeln    TYPE cl_ptf_util=>ty_vbeln_tab.

******************************************************************************
** 1 Step: Prepare data

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.
    IF lt_vbeln IS INITIAL.
      me->mo_run_environment->append_log( 'There are no documentIDs to use!' ).
      RETURN.
    ENDIF.

    LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<ls_vbeln>).
      ls_xkomfk-vbeln =  <ls_vbeln>-vbeln.
      APPEND ls_xkomfk TO lt_xkomfk.
    ENDLOOP.

******************************************************************************
* 2 Step: Create
    CALL FUNCTION 'RV_INVOICE_LIST_CREATE'
      EXPORTING
*       delivery_date  = 0    " Delivery date number
*       invoice_date = 0    " Billing document date number
*       invoice_type = '    '    " Billing document type number
*       pricing_date = 0    " Price date number
        vbsk_i       = ls_vbsk  " SD collective processing header import
        with_posting = 'D'    " Create billing document immediately
*       i_no_vblog   = ' '
*       id_no_enqueue  = ' '    " DE-EN-LANG-SWITCH-NO-TRANSLATION
*       iv_opt_enabled = ABAP_FALSE    " DE-EN-LANG-SWITCH-NO-TRANSLATION
*       iv_rfbfk     = SPACE    " Block for Transfer to Accounting
      IMPORTING
        vbsk_e       = ls_vbsk    " SD collective processing header export
        od_bad_data  = lv_bad_data   " Checkbox
      TABLES
        xkomfk       = lt_xkomfk   " Billing Communications Table
        xkomv        = lt_xkomv    " Pricing: Communications Condition Record
        xthead       = lt_xthead    " SAPscript: text header
        xvbfs        = lt_xvbfs   " Error Log for Collective Processing
        xvbpa        = lt_xvbpa   " Sales Document: Partner
        xvbrk        = lt_xvbrk    " Billing Document: Header Data
        xvbrl        = lt_xvbrl
        xvbss        = lt_xvbss  " Collective Processing: Sales Documents
*       xvbrp        =     " Billing Document: Item Data
      .
*   CALL FUNCTION 'RV_INVOICE_LIST_DOCUMENT_ADD'
*     EXPORTING
*       vbsk_i          = ls_vbsk
*       with_posting    = 'D'
**       without_refresh = ' '
**       i_no_vblog      = ' '
**       i_no_nast       = ' '
**     IMPORTING
**       vbsk_e          =
*     TABLES
*       xkomfk          = lt_xkomfk
*       xkomv           = lt_xkomv
*       xthead          = lt_xthead
*       xvbfs           = lt_xvbfs
*       xvbpa           = lt_xvbpa
*       xvbrk           = lt_xvbrk
*       xvbrl           = lt_xvbrl
*       xvbss           = lt_xvbss .
******************************************************************************
* 3 Step: Commit and fill et_Return
    ev_execution_status = abap_true.
    LOOP AT lt_xvbfs ASSIGNING FIELD-SYMBOL(<ls_xvbfs>).
      ls_return-id = <ls_xvbfs>-msgid.
      ls_return-message = <ls_xvbfs>-msgv1.
      ls_return-number = <ls_xvbfs>-msgno.
      ls_return-type = <ls_xvbfs>-msgty.
      me->mo_run_environment->append_log_structure( is_log = ls_return ).
      IF <ls_xvbfs>-msgty = 'E'.
        ev_execution_status = abap_false.
      ENDIF.
    ENDLOOP.

    IF ev_execution_status EQ abap_false.
      RETURN.
    ENDIF.

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
*******************************************************************************
* 4 Step: Check if PBD exists
    LOOP AT lt_xvbfs INTO <ls_xvbfs>.
      DATA: lv_ptf_key TYPE ptfkey.
      MOVE <ls_xvbfs>-vbeln TO lv_ptf_key.
      APPEND lv_ptf_key TO ev_document_id.
      ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).
      IF ev_execution_status EQ abap_false.
        RETURN.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD delete.
  ENDMETHOD.


  METHOD execute_action.
    DATA(lv_step_data) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).

    CASE lv_step_data-action.
      WHEN c_odata_get_cancel_invoice_lst.
        me->odata_get_cancel_invoice_lst(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_clear_fi.
        me->clear_fi(
            EXPORTING
              ls_step_data           = lv_step_data
              iv_step_number      = iv_step_number
            IMPORTING
              ev_document_id      = ev_document_id
              ev_execution_status = ev_execution_status
              ev_check_status     = ev_check_status
          ).
        RETURN.
      WHEN c_odata_get_invoice_lst.
        me->odata_get_invoice_lst(
            EXPORTING
              step_data           = lv_step_data
              iv_step_number      = iv_step_number
            IMPORTING
              ev_document_id      = ev_document_id
              ev_execution_status = ev_execution_status
              ev_check_status     = ev_check_status
          ).
        RETURN.
      WHEN OTHERS.
        me->mo_run_environment->append_log( iv_log_statement =  |Could not find method { lv_step_data-action } for the BO { lv_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.
    ENDCASE.



  ENDMETHOD.


  METHOD execute_check.
    "No Check actions yet

    DATA(lv_step_data) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).
    me->mo_run_environment->append_log( iv_log_statement =  |Could not find method { lv_step_data-action } for the BO { lv_step_data-bus_obj }.| ).
    ev_execution_status = abap_false.
    ev_check_status = abap_false.
    RETURN.


    "    CASE lv_step_data-action.
    "      WHEN ''.

    "        RETURN.
    "      WHEN OTHERS.
    "        me->mo_run_environment->append_log( iv_log_statement =  |Could not find method { lv_step_data-action } for the BO { lv_step_data-bus_obj }.| ).
    "        ev_execution_status = abap_false.
    "        ev_check_status = abap_false.
    "        RETURN.
    "    ENDCASE.
  ENDMETHOD.


  METHOD odata_get_cancel_invoice_lst.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/SAP/SD_BIL_DOC_LIST_MANAGE_SRV/'.
    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    DATA lt_parameters TYPE /iwfnd/sutil_property_t.
    DATA: lv_status_text TYPE string,
          lv_status_code TYPE integer.
    TYPES: BEGIN OF ty_functionimportresult,
             dummy_key TYPE string,
           END OF ty_functionimportresult.

    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              results TYPE TABLE OF ty_functionimportresult,
            END OF d,
          END OF ls_response_function.

    DATA: ls_return     TYPE bapiret2.
    DATA: lv_msg             TYPE string,
          lv_status_code_txt TYPE string.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
      DATA(ls_refstep_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
      IF ls_refstep_data IS NOT INITIAL.
        LOOP AT ls_refstep_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).

          lt_parameters = VALUE #( ( name = 'InvoiceList' value =  <ls_docid> ) ).
          lo_odata_caller->call_service(
            EXPORTING
              iv_method           = 'POST'
              iv_action_or_entity = 'Cancel'
              it_parameters       = lt_parameters
            IMPORTING
              ev_status_code      = lv_status_code
              ev_status_text      = lv_status_text
              es_json_response    = ls_response_function
          ).
          lv_status_code_txt = lv_status_code.
          CONCATENATE 'Executed API Call' 'Cancel' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
          me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
          IF lv_status_code = 200.
            ev_execution_status = abap_true.
            ev_check_status = abap_true.
          ELSE.
            me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
            ev_execution_status = abap_false.
            ev_check_status = abap_false.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.
      IF ev_check_status = abap_false.
        EXIT.
      ENDIF.
    ENDLOOP.
    IF lv_msg IS INITIAL.
      CONCATENATE 'Did not execute API Call' 'Cancel' INTO lv_msg SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
      ev_execution_status = abap_false.
      ev_check_status = abap_false.
    ENDIF.
  ENDMETHOD.


  METHOD odata_get_invoice_lst.
    DATA: lv_service_uri TYPE string VALUE '/sap/opu/odata/sap/SD_BIL_DOC_LIST_OBJPG_SRV/'.
    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( lv_service_uri ).
    DATA: lv_status_text TYPE string,
          lv_status_code TYPE integer.
    DATA: lt_messages TYPE sdbil_ebdr_request_msg_t.
    DATA lt_parameters TYPE /iwfnd/sutil_property_t.
    DATA: ls_return     TYPE bapiret2.
    DATA: lv_msg             TYPE string,
          lv_status_code_txt TYPE string.

    DATA: BEGIN OF ls_response_function,
            BEGIN OF d,
              invoicelist                TYPE string,
              payerparty                 TYPE string,
              billingdocumentdate        TYPE string,
              totalnetamount             TYPE string,
              totaltaxamount             TYPE string,
              transactioncurrency        TYPE string,
              companycode                TYPE string,
              salesorganization          TYPE string,
              documentreferenceid        TYPE string,
              customerpaymentterms       TYPE string,
              accountingtransferstatus   TYPE string,
              billingdocumenttype        TYPE string,
              billingdocumenttypename    TYPE string,
              totalremunerationnetamount TYPE string,
              totalremunerationtaxamount TYPE string,
              totalgrossamount           TYPE string,
            END OF d,
          END OF ls_response_function.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
      DATA(ls_refstep_data) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> ).
      IF ls_refstep_data IS NOT INITIAL.
        LOOP AT ls_refstep_data-document_id ASSIGNING FIELD-SYMBOL(<ls_docid>).
          lt_parameters = VALUE #(
            ( name = 'InvoiceList ' value =  <ls_docid> )
            ( name = 'InvoiceListItem ' value =  '' )
          ).
          lt_parameters = VALUE #(  ).
          lo_odata_caller->call_service(
            EXPORTING
              iv_action_or_entity = 'C_InvoiceListObjPg'
              it_parameters       = lt_parameters
            IMPORTING
              ev_status_code      = lv_status_code
              ev_status_text      = lv_status_text
              es_json_response    = ls_response_function
          ).
          lv_status_code_txt = lv_status_code.
          CONCATENATE 'Executed API Call' 'C_InvoiceListObjPg' 'with status code' lv_status_code_txt 'and status text' lv_status_text INTO lv_msg SEPARATED BY space.
          me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
          IF lv_status_code = 200.
            ev_execution_status = abap_true.
            ev_check_status = abap_true.
          ELSE.
            me->mo_run_environment->append_log( iv_log_statement = |Error calling ODATA Service: { lv_status_code } : { lv_status_text }.| ).
            ev_execution_status = abap_false.
            ev_check_status = abap_false.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.
      IF ev_check_status = abap_false.
        EXIT.
      ENDIF.
    ENDLOOP.
    IF lv_msg IS INITIAL.
      CONCATENATE 'Did not execute API Call' 'C_InvoiceListObjPg' INTO lv_msg SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
      ev_execution_status = abap_false.
      ev_check_status = abap_false.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
