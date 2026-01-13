class CL_PTF_BO_SD_MASS_CHANGE definition
  public
  inheriting from CL_PTF_BO
  final
  create public .

public section.

  types:
    BEGIN OF ty_gs_stage_data,
        include TYPE tds_sd_mcc_slsdocreq .
    TYPES:
      to_masschangecntrlparam       TYPE tds_sd_mcc_cctrlprm,
      to_masschangereadrequest      TYPE tds_sd_mcc_readreq,
      to_salesdocumentchgfieldlist  TYPE STANDARD TABLE OF tds_sd_mcc_chgflist WITH EMPTY KEY,
      to_salesdocumentselectionlist TYPE STANDARD TABLE OF tds_sd_mcc_cchgkey  WITH EMPTY KEY,
      END   OF ty_gs_stage_data .

  constants C_STAGE_AND_EXECUTE type STRING value 'STAGE_AND_EXECUTE' ##NO_TEXT.
  constants C_CHECK_JOB_COMPLETION type STRING value 'CHECK_JOB_COMPLETION' ##NO_TEXT.
  constants C_COMPARE_DOCUMENTS type STRING value 'COMPARE_DOCUMENTS' ##NO_TEXT.
  constants C_CHECK_PARTNER type STRING value 'CHECK_PARTNER' ##NO_TEXT.
  constants C_CHECK_PRICE type STRING value 'CHECK_PRICE' ##NO_TEXT.
  constants C_BUFFER_PRICE type STRING value 'BUFFER_PRICE' ##NO_TEXT.
  constants C_ADD_PARTNER_ZM type STRING value 'ADD_PARTNER_ZM' ##NO_TEXT.
  constants C_CHECK_ZM_REMOVED_HD type STRING value 'CHECK_ZM_REMOVED_HD' ##NO_TEXT.
  constants C_CHECK_ZM_REMOVED_ITEM type STRING value 'CHECK_ZM_REMOVED_ITEM' ##NO_TEXT.

  methods CHANGE
    redefinition .
  methods CHECK
    redefinition .
  methods CHECK_EXISTENCE
    redefinition .
  methods CREATE
    redefinition .
  methods DELETE
    redefinition .
  methods EXECUTE_ACTION
    redefinition .
  methods EXECUTE_CHECK
    redefinition .
protected section.
private section.

  methods GET_ITEMS
    importing
      !IT_SALES_DOCUMENT type TAB_VBAP
    exporting
      !ET_DOCUMENT_ITEMS type TAB_VBAP .
  methods STAGE_AND_EXECUTE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_JOB_COMPLETION
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods COMPARE_DOCUMENTS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_PARTNER
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods BUFFER_PRICE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_PRICE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ADD_PARTNER_ZM
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ZM_REMOVED_HD
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ZM_REMOVED_ITEM
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
ENDCLASS.



CLASS CL_PTF_BO_SD_MASS_CHANGE IMPLEMENTATION.


  METHOD add_partner_zm.


    DATA:"lt_sales_doc TYPE tab_vbak,
      lt_docid    TYPE  cl_ptf_util=>ty_vbeln_tab,
      ls_testdata TYPE cl_ptf_bo_or=>ty_gs_ptf_sd_check_partner_td,
      lt_msg      TYPE bapiret2_t,
      lv_vbeln    TYPE  vbeln,
      ls_par      TYPE  bapisdh1x,
      lv_tabix    TYPE sytabix.
    DATA: lt_partner   TYPE   wiso_t_parnrc,
          lv_zm        TYPE parvw,
          ls_partner   TYPE bapiparnrc,
          lt_sales_doc TYPE tab_vbap,
          lv_partner   TYPE kunde_d,
          lt_pt_item   TYPE   tab_vbpa,
          ls_sales_doc TYPE vbap.
    "  ls_sales_doc TYPE vbak.


    WAIT UP TO 5 SECONDS.
*   Get the document number
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<prestep_numbr>).
      lv_tabix = sy-tabix.
      DATA(ls_step_precessor) = me->mo_run_environment->get_step_data( iv_step_number = <prestep_numbr> ).
      APPEND LINES OF ls_step_precessor-document_id TO lt_docid.
      DATA(lv_doc_no) = lt_docid[ lv_tabix ].
      MOVE lv_doc_no TO ls_sales_doc-vbeln.
      APPEND ls_sales_doc TO lt_sales_doc.
    ENDLOOP.


*   Get the data from Test data container
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = ls_testdata ).

    lv_vbeln = lv_doc_no.

    READ TABLE ls_testdata-partner INTO DATA(ls_pnr) INDEX 1.
    IF sy-subrc = 0.
      lv_partner = ls_pnr-customer."'00000907'.
    ENDIF.                                                  ""50001902
    IF lv_vbeln IS INITIAL.
      ev_execution_status = abap_false.
      ev_check_status     = abap_false.
      RETURN.
    ENDIF.
    ls_par-updateflag = 'U'.

*   Check if the employee responsible is already updated in db if no proceed further to create it
    SELECT SINGLE parvw INTO lv_zm  FROM vbpa WHERE vbeln         =   lv_vbeln
                                                       AND parvw  = 'ZM'.

    IF sy-subrc NE 0.
      ls_partner-document = lv_vbeln.
      ls_partner-updateflag = 'I'.
      ls_partner-partn_role = 'ZM'. "ship-to
*    ls_partner-p_numb_old = '00000907'. "original number
      ls_partner-p_numb_new = lv_partner. "new number    "50001902
      APPEND ls_partner TO lt_partner.
    ENDIF.

    CALL METHOD me->get_items
      EXPORTING
        it_sales_document = lt_sales_doc
      IMPORTING
        et_document_items = DATA(lt_doc_items).

    IF lt_doc_items IS NOT INITIAL.
*   Check if the employee responsible is already updated in db if no proceed further to create it
      SELECT vbeln parvw INTO CORRESPONDING FIELDS OF TABLE lt_pt_item FROM vbpa FOR ALL ENTRIES IN lt_doc_items
                                                         WHERE vbeln =   lt_doc_items-vbeln
                                                         AND   posnr =   lt_doc_items-posnr
                                                         AND   parvw  = 'ZM'.



    IF sy-subrc NE 0.
      ls_partner-document = lv_vbeln.
      ls_partner-updateflag = 'I'.
      ls_partner-partn_role = 'ZM'. "ship-to
*    ls_partner-p_numb_old = '00000907'. "original number
      ls_partner-p_numb_new = lv_partner. "new number
      LOOP AT lt_doc_items INTO DATA(ls_item).
        ls_partner-itm_number = ls_item-posnr.
        APPEND ls_partner TO lt_partner.
      ENDLOOP.

    ENDIF.

    ENDIF.

    IF lt_partner IS NOT INITIAL.
      CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
        EXPORTING
          salesdocument    = lv_vbeln
          order_header_inx = ls_par
        TABLES
          return           = lt_msg
          partnerchanges   = lt_partner.

      READ TABLE lt_msg TRANSPORTING NO FIELDS WITH KEY type  = 'E'.
      IF sy-subrc = 0.
        ev_execution_status = abap_false.
        ev_check_status     = abap_false.
        me->mo_run_environment->append_log( iv_log_statement = |{ 'Error in update of order with employee responsible' }| ).
      ELSE.
*   Once the process is sucesful do a explicit commit
        cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
*   Set the execution status and check status as true once the job is executed sucessfully.
        ev_execution_status = abap_true.
        ev_check_status     = abap_true.
      ENDIF.

    ELSE.
*   Set the execution status and check status as true once the job is executed sucessfully.
      ev_execution_status = abap_true.
      ev_check_status     = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD buffer_price.

    DATA:lt_sales_doc TYPE tab_vbak,
         lt_vbak      TYPE tab_vbak,
         lt_docid     TYPE  cl_ptf_util=>ty_vbeln_tab,
         lv_tabix     TYPE sytabix,
         ls_sales_doc TYPE vbak.


     WAIT UP TO 5 SECONDS.
*   Get the document number
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<prestep_numbr>).
      lv_tabix = sy-tabix.
      DATA(ls_step_precessor) = me->mo_run_environment->get_step_data( iv_step_number = <prestep_numbr> ).
      APPEND LINES OF ls_step_precessor-document_id TO lt_docid.
      DATA(lv_doc_no) = lt_docid[ lv_tabix ].
      MOVE lv_doc_no TO ls_sales_doc-vbeln.
      APPEND ls_sales_doc TO lt_sales_doc.
      CLEAR ls_sales_doc.
    ENDLOOP.
*   Get the net value for the sales document
    SELECT vbeln netwr FROM vbak INTO CORRESPONDING FIELDS OF TABLE
        lt_vbak FOR ALL ENTRIES IN
        lt_sales_doc WHERE vbeln =  lt_sales_doc-vbeln.
    IF sy-subrc = 0.
      ev_execution_status = abap_true.
      ev_check_status     = abap_true.
*     buffer price to the reference document
      LOOP AT lt_vbak INTO DATA(ls_vbak).
        lv_doc_no  = ls_vbak-netwr.
        CONDENSE lv_doc_no.
        APPEND lv_doc_no TO ev_document_id.
      ENDLOOP.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |{ 'Error in the buffer of prices for the sales document' }| ).
      ev_execution_status = abap_false.
      ev_check_status     = abap_false.
    ENDIF.
  ENDMETHOD.


  METHOD CHANGE.


  ENDMETHOD.


  METHOD CHECK.


  ENDMETHOD.


  METHOD CHECK_EXISTENCE.

  ENDMETHOD.


  METHOD check_job_completion.


    DATA:lv_jobid TYPE sd_mcc_job_uuid,
         lv_index TYPE sy-tabix.


*   Set the exeution status as false
    ev_execution_status = abap_false.
    ev_check_status     = abap_false.


    DATA(change_request_data_access) = cl_sd_mcc_sdoc_mass_chg_req_da=>get_instance( ).


*   Get the Job id
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<prestep_numbr>).
      DATA(ls_step_precessor) = me->mo_run_environment->get_step_data( iv_step_number = <prestep_numbr> ).
      READ TABLE ls_step_precessor-document_id INTO DATA(lv_vbeln) INDEX 1.
      IF sy-subrc = 0.
        lv_jobid = lv_vbeln.
        DELETE ls_step_precessor-document_id INDEX 1.
        APPEND LINES OF ls_step_precessor-document_id TO ev_document_id.
      ENDIF.
      EXIT.
    ENDLOOP.



    IF lv_jobid IS NOT INITIAL AND change_request_data_access IS BOUND .
      DO 7 TIMES.
        lv_index = sy-tabix.
        CALL METHOD change_request_data_access->get_job_req
          EXPORTING
            iv_job_id = lv_jobid
          RECEIVING
            return    = DATA(ls_jobreq).
        IF ls_jobreq-slsdocmasschangereqstatus = 'C'.
          ev_execution_status = abap_true.
          ev_check_status     = abap_true.
          me->mo_run_environment->append_log( iv_log_statement = |{ 'Job for mass change for sales documents is successful' }| ).
          EXIT.

        ELSEIF ls_jobreq-slsdocmasschangereqstatus = 'D'.
          ev_execution_status = abap_false.
          ev_check_status     = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |{ 'Job ended in error because of invalid data' }| ).
          EXIT.
        ELSE.
          IF lv_index = '7'.
            me->mo_run_environment->append_log( iv_log_statement = |{ 'Job took longer time ' }| ).
            ev_check_status     = abap_false.
            EXIT.
          ENDIF.
          WAIT UP TO 10 SECONDS.

        ENDIF.
      ENDDO.
    ENDIF.

  ENDMETHOD.


  METHOD check_partner.

    DATA(lo_comp) = NEW cl_ptf_bo_or( me->mo_run_environment ).
    CALL METHOD lo_comp->execute_check
      EXPORTING
        iv_step_number      = iv_step_number
      IMPORTING
        ev_document_id      = ev_document_id
        ev_execution_status = ev_execution_status
        ev_check_status     = ev_check_status.


  ENDMETHOD.


  METHOD check_price.



    DATA:lt_sales_doc TYPE tab_vbak,
         lt_vbak      TYPE tab_vbak,
         lt_docid     TYPE  cl_ptf_util=>ty_vbeln_tab,

         lt_doc_id    TYPE cl_ptf_util=>ty_vbeln_tab,
         lv_tabix     TYPE sytabix,
         ls_sales_doc TYPE vbak.



    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<prestep_numbr>).
      lv_tabix = sy-tabix.
      DATA(ls_step_precessor) = me->mo_run_environment->get_step_data( iv_step_number = <prestep_numbr> ).
      APPEND LINES OF ls_step_precessor-document_id TO lt_docid.
      DATA(lv_doc_no) = lt_docid[ lv_tabix ].
      APPEND lv_doc_no TO lt_doc_id.
      MOVE lv_doc_no TO ls_sales_doc-vbeln.
      APPEND ls_sales_doc TO lt_sales_doc.
    ENDLOOP.

    DELETE lt_sales_doc WHERE vbeln IS INITIAL.
    IF lt_sales_doc IS INITIAL.
      ev_execution_status = abap_false.
      ev_check_status     = abap_false.
      RETURN.
    ENDIF.
    SELECT vbeln netwr FROM vbak INTO CORRESPONDING FIELDS OF TABLE
        lt_vbak FOR ALL ENTRIES IN
        lt_sales_doc WHERE vbeln =  lt_sales_doc-vbeln.
    IF sy-subrc = 0.

      LOOP AT lt_vbak INTO DATA(ls_vbak).
         lv_tabix  = sy-tabix * 2.
*       Check if the netvalue of the document is same after carryout new pricing in mass change
        READ TABLE lt_doc_id INTO DATA(ls_docid) INDEX lv_tabix.
        IF sy-subrc = 0 AND ls_docid-vbeln = ls_vbak-netwr.
          ev_execution_status = abap_true.
          ev_check_status     = abap_true.
        ELSE.
          ev_execution_status = abap_false.
          ev_check_status     = abap_false.
        ENDIF.
      ENDLOOP.

    ELSE.
      ev_execution_status = abap_false.
      ev_check_status     = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD check_zm_removed_hd.

    DATA:"lt_sales_doc TYPE tab_vbak,
      lt_docid TYPE  cl_ptf_util=>ty_vbeln_tab,
      lt_msg   TYPE bapiret2_t,
      lv_vbeln TYPE  vbeln,
      ls_par   TYPE  bapisdh1x,
      lv_tabix TYPE sytabix.
    DATA: lt_partner TYPE   wiso_t_parnrc,
          lv_zm      TYPE parvw,
          lt_pt_item TYPE tab_vbpa,
          ls_partner TYPE bapiparnrc.
    "  ls_sales_doc TYPE vbak.

    DATA:lt_sales_doc TYPE tab_vbak,
         lt_doc_id    TYPE cl_ptf_util=>ty_vbeln_tab,
         ls_sales_doc TYPE vbak.


    WAIT UP TO 5 SECONDS.
*   Get the document number
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<prestep_numbr>).
      lv_tabix = sy-tabix.
      DATA(ls_step_precessor) = me->mo_run_environment->get_step_data( iv_step_number = <prestep_numbr> ).
      APPEND LINES OF ls_step_precessor-document_id TO lt_docid.
      DATA(lv_doc_no) = lt_docid[ lv_tabix ].
      APPEND lv_doc_no TO lt_doc_id.
      MOVE lv_doc_no TO ls_sales_doc-vbeln.
      APPEND ls_sales_doc TO lt_sales_doc.
    ENDLOOP.




*   Check if the employee responsible is already updated in db if no proceed further to create it
    SELECT vbeln parvw INTO CORRESPONDING FIELDS OF TABLE
          lt_pt_item FROM vbpa FOR ALL ENTRIES IN lt_sales_doc
                                                       WHERE vbeln =   lt_sales_doc-vbeln
                                                       AND   posnr = ''
                                                       AND   parvw  = 'ZM'.

    IF sy-subrc NE 0.
      ev_execution_status  =  abap_true.
      ev_check_status      = abap_true.

    ELSE.
      ev_execution_status  =  abap_false.
      ev_check_status      = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |{ 'Partner function employee responsible not removed' }| ).
    ENDIF.

  ENDMETHOD.


  METHOD check_zm_removed_item.

    DATA:"lt_sales_doc TYPE tab_vbak,
      lt_docid TYPE  cl_ptf_util=>ty_vbeln_tab,
      lt_msg   TYPE bapiret2_t,
      lv_vbeln TYPE  vbeln,
      ls_par   TYPE  bapisdh1x,
      lv_tabix TYPE sytabix.
    DATA: lt_partner TYPE   wiso_t_parnrc,
          lv_zm      TYPE parvw,
          lt_pt_item TYPE tab_vbpa,
          ls_partner TYPE bapiparnrc.
    "  ls_sales_doc TYPE vbak.

    DATA:lt_sales_doc TYPE tab_vbap,
         lt_doc_id    TYPE cl_ptf_util=>ty_vbeln_tab,
         ls_sales_doc TYPE vbap.


    WAIT UP TO 5 SECONDS.

*   Get the document number
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<prestep_numbr>).
      lv_tabix = sy-tabix.
      DATA(ls_step_precessor) = me->mo_run_environment->get_step_data( iv_step_number = <prestep_numbr> ).
      APPEND LINES OF ls_step_precessor-document_id TO lt_docid.
      DATA(lv_doc_no) = lt_docid[ lv_tabix ].
      APPEND lv_doc_no TO lt_doc_id.
      MOVE lv_doc_no TO ls_sales_doc-vbeln.
      APPEND ls_sales_doc TO lt_sales_doc.
    ENDLOOP.

    CALL METHOD me->get_items
      EXPORTING
        it_sales_document = lt_sales_doc
      IMPORTING
        et_document_items = DATA(lt_doc_items).

    IF lt_doc_items IS  INITIAL.
      ev_execution_status  =  abap_false.
      ev_check_status      = abap_false.
      RETURN.
    ENDIF.

*   Check if the employee responsible is already updated in db if no proceed further to create it
    SELECT vbeln parvw INTO CORRESPONDING FIELDS OF TABLE
          lt_pt_item FROM vbpa FOR ALL ENTRIES IN lt_doc_items
                                                       WHERE vbeln =   lt_doc_items-vbeln
                                                       AND   posnr =   lt_doc_items-posnr
                                                       AND   parvw  = 'ZM'.

    IF sy-subrc NE 0.
      ev_execution_status  =  abap_true.
      ev_check_status      =  abap_true.
    ELSE.
      ev_execution_status  =  abap_false.
      ev_check_status      =  abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |{ 'Partner function employee responsible not removed' }| ).
    ENDIF.
  ENDMETHOD.


  METHOD compare_documents.
    DATA(lo_comp) = NEW cl_ptf_bo_or( me->mo_run_environment ).
    CALL METHOD lo_comp->check
      EXPORTING
        iv_step_number      = iv_step_number
      IMPORTING
        ev_document_id      = ev_document_id
        ev_execution_status = ev_execution_status
        ev_check_status     = ev_check_status.

  ENDMETHOD.


  method CREATE.
  endmethod.


  method DELETE.
  endmethod.


  method EXECUTE_ACTION.
  endmethod.


  METHOD execute_check.
*   Get the Step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    CASE ls_step_data-action.
      WHEN c_stage_and_execute.
        me->stage_and_execute(
                  EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_check_job_completion.
        me->check_job_completion(
                  EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_compare_documents.
        me->compare_documents(
                  EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.

      WHEN c_check_partner.
        me->check_partner(
                  EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.

      WHEN c_buffer_price.

        me->buffer_price(
                  EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.

      WHEN c_check_price.

        me->check_price(
                  EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.

      WHEN c_add_partner_zm.

        me->add_partner_zm(
                  EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.

      WHEN c_check_zm_removed_hd.

        me->check_zm_removed_hd(
                  EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.

      WHEN c_check_zm_removed_item.

        me->check_zm_removed_item(
                  EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.


    ENDCASE.
  ENDMETHOD.


  METHOD GET_ITEMS.
    IF it_sales_document IS NOT INITIAL.
      SELECT vbeln posnr FROM vbap INTO CORRESPONDING FIELDS OF TABLE et_document_items FOR ALL ENTRIES IN it_sales_document WHERE vbeln = it_sales_document-vbeln.
      IF sy-subrc = 0.
        SORT   et_document_items BY vbeln.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD stage_and_execute.

*   Local data declarations
    DATA: ls_testdata          TYPE ty_gs_stage_data,
          ls_doc               TYPE tds_sd_mcc_cchgkey,
          lv_jobid             TYPE ptfkey,
          lo_request_processor TYPE REF TO if_sd_mcc_req_processor,
          lv_docno             TYPE vbeln,
          lt_docid             TYPE  cl_ptf_util=>ty_vbeln_tab,
          lt_sales_doc         TYPE tab_vbap,
          lv_tabix             TYPE sytabix,
          ls_sales_doc         TYPE vbap,
          lt_doc_id            TYPE cl_ptf_util=>ty_vbeln_tab,
          ls_doc_req           TYPE cl_sd_mcc_req_processor=>if_sd_mcc_req_processor~ts_mcc_sls_doc_request.

*   Set the exeution status as false
    ev_execution_status = abap_false.

*   Get the data from Test data container
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = ls_testdata ).


    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<prestep_numbr>).
      lv_tabix = sy-tabix.
      DATA(ls_step_precessor) = me->mo_run_environment->get_step_data( iv_step_number = <prestep_numbr> ).
      APPEND LINES OF ls_step_precessor-document_id TO lt_docid.
      DATA(lv_doc_no) = lt_docid[ lv_tabix ].
      APPEND lv_doc_no TO lt_doc_id.
      MOVE lv_doc_no TO ls_sales_doc-vbeln.
      APPEND ls_sales_doc TO lt_sales_doc.
    ENDLOOP.

    CALL METHOD me->get_items
      EXPORTING
        it_sales_document = lt_sales_doc
      IMPORTING
        et_document_items = DATA(lt_doc_items).

*   Move the data to the staging api format
    MOVE-CORRESPONDING ls_testdata-include                       TO ls_doc_req .
    MOVE-CORRESPONDING ls_testdata-to_masschangecntrlparam       TO ls_doc_req-to_masschangecntrlparam .
    MOVE-CORRESPONDING ls_testdata-to_masschangereadrequest      TO ls_doc_req-to_masschangereadrequest .
    MOVE-CORRESPONDING ls_testdata-to_salesdocumentchgfieldlist  TO ls_doc_req-to_salesdocumentchgfieldlist .
    ls_doc_req-to_masschangecntrlparam-slsdocmasschangejobname =  | Job created by PTF on date { sy-datum } time { sy-uzeit } |.

*   Prepare the seelction list
    LOOP AT lt_docid  ASSIGNING FIELD-SYMBOL(<fv_vbeln>).
      ls_doc-salesdocument = <fv_vbeln>.
      READ TABLE ls_testdata-to_salesdocumentchgfieldlist ASSIGNING FIELD-SYMBOL(<fs_doc>) INDEX 1.
      IF sy-subrc = 0 AND <fs_doc>-slsdocmasschgentitytype EQ 'I'.
      ELSE.
        APPEND ls_doc TO ls_doc_req-to_salesdocumentselectionlist.
        CONTINUE.
      ENDIF.
      LOOP AT lt_doc_items INTO DATA(ls_item) WHERE vbeln = <fv_vbeln>.
        ls_doc-salesdocumentitem = ls_item-posnr.
        APPEND ls_doc TO ls_doc_req-to_salesdocumentselectionlist.
      ENDLOOP.
    ENDLOOP.


*   Get the instance of the processor class
    lo_request_processor = cl_sd_mcc_req_processor=>get_instance(  ).

*   Call the backend logic to stage the keys and call the GOAL framework
    TRY.
        CALL METHOD lo_request_processor->handle_request
          CHANGING
            cs_mcc_sls_doc_req        = ls_doc_req
          RECEIVING
            rv_final_entity_not_found = DATA(lv_not_found).

      CATCH cx_sd_mcc_sdoc_mass_change INTO DATA(lx_exc).
        cl_message_helper=>set_msg_vars_for_if_t100_msg( lx_exc ).
*       Incase of error append the error to the log
        me->mo_run_environment->append_log( iv_log_statement = |{ lx_exc->get_text( ) }| ).
        EXIT.
    ENDTRY.


*   Once the process is sucesful do a explicit commit
    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
*   Set the execution status and check status as true once the job is executed sucessfully.
    ev_execution_status = abap_true.
    ev_check_status     = abap_true.

    lv_jobid = ls_doc_req-slsdocmasschangerequestuuid.
    APPEND lv_jobid TO ev_document_id.
    APPEND LINES OF lt_doc_id TO ev_document_id.


  ENDMETHOD.
ENDCLASS.
