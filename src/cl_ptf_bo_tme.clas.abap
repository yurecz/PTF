class CL_PTF_BO_TME definition
  public
  inheriting from CL_PTF_BO
  final
  create public .

public section.

  types:
    BEGIN OF ty_gs_ptf_tme_cr_td ,
        tme_employee     TYPE bu_id_number,
        tme_catshours_in    TYPE catshours,
      END OF ty_gs_ptf_tme_cr_td .

  class-methods GET_PERNR
    importing
      !IV_EMPLOYEE type BU_ID_NUMBER
    exporting
      !EV_PERNR type PERNR_D .

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

  methods TRANSFER_TO_CO
    importing
      !IV_PERNR type PERNR_D .
  methods TRANSFER_TO_SES
    importing
      !IT_TIMEENTRY type HCM_CATS_V1_T_TIMEENTRY .
ENDCLASS.



CLASS CL_PTF_BO_TME IMPLEMENTATION.


  METHOD change.
    DATA :
      lv_istme            TYPE boole_d,
      lv_pernr            TYPE pernr_d,
      lv_counter          TYPE catscounte,
      lv_release_data     TYPE boole_d,
      lv_dataentryprofile TYPE catsvarian,

      ls_testdata         TYPE ty_gs_ptf_tme_cr_td,
      ls_cats_ext         TYPE cats_ext,

      lt_cats_ext         TYPE cats_ext_itab,
      lt_catsdb_ext       TYPE catsdb_ext_itab,
      lt_check_messages   TYPE TABLE OF mesg,
      lt_longtext_ext     TYPE longtext_ext_itab,
      lt_vbeln_tme        TYPE cl_ptf_util=>ty_vbeln_tab.




    DATA(ls_current_step) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).

*    cl_ptf_util=>get_testdata(
*      EXPORTING
*        is_step_data = ls_current_step
*      IMPORTING
*        es_testdata  = ls_testdata ).

*Check Predecessor Status
    LOOP AT ls_current_step-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      DATA(ls_reference_step) = me->mo_run_environment->get_step_data( iv_step_number =  <lv_ref_step> ).
      IF ls_reference_step-bus_obj = 'TME'.
        lv_istme = abap_true.
        APPEND LINES OF lt_ptf_keys TO lt_vbeln_tme.
      ENDIF.

    ENDLOOP.
*
*    me->get_pernr(
*      EXPORTING
*        iv_employee = ls_testdata-tme_employee
*      IMPORTING
*        ev_pernr    = lv_pernr
*    ).

    IF lv_istme = abap_true.
      LOOP AT lt_vbeln_tme ASSIGNING FIELD-SYMBOL(<fs_tme_keys>).
        lv_counter = <fs_tme_keys>-vbeln.
        me->mo_run_environment->append_log( iv_log_statement = | Reference data from previous step : { <fs_tme_keys>-vbeln } .|  ).
      ENDLOOP.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = | For Update the reference  Step BO should be TME .| ).
    ENDIF.


    SELECT SINGLE * FROM catsdb INTO @DATA(ls_catsdb) WHERE counter = @lv_counter.

    ls_catsdb-catshours = 3.
    ls_catsdb-ltxa1 = 'Update Note ' && sy-datum.
    lv_pernr = ls_catsdb-pernr.
    MOVE-CORRESPONDING ls_catsdb TO  ls_cats_ext.

    APPEND ls_cats_ext TO lt_cats_ext.

*    *Get Default DATA ENTRY PROFILE
    CALL FUNCTION 'CATS_GET_DEFAULT_DEP'
      EXPORTING
        iv_pernr   = lv_pernr
      IMPORTING
**       es_profile  = ls_profile
**        et_messages = lt_messages
        ev_profile = lv_dataentryprofile.

* calling the actual function to create the timesheet
    CALL FUNCTION 'CATS_EXTERNAL_INTERFACE' ##FM_SUBRC_OK
      EXPORTING
        profile           = lv_dataentryprofile
        testrun           = ''
        release_data      = abap_true "lv_release_data
        cats_text_format  = 'ITF'
        commit_work       = space
*      IMPORTING
*       error_occurred    = lv_error_occured
      TABLES
        ext_interface     = lt_cats_ext
        check_messages    = lt_check_messages
        ext_interface_out = lt_catsdb_ext
        ext_longtext      = lt_longtext_ext
      EXCEPTIONS
        error_occurred    = 1
        OTHERS            = 2.

*        READ TABLE lt_check_messages WITH KEY msgty CA 'EAX' TR.
    LOOP AT lt_check_messages ASSIGNING FIELD-SYMBOL(<fs_check_message>) WHERE msgty CA 'EAX'.
      DATA(lv_error) = abap_true.
      EXIT.
    ENDLOOP.

    IF lv_error = abap_true.
      LOOP AT lt_check_messages ASSIGNING <fs_check_message>.
        me->mo_run_environment->append_log( iv_log_statement = | { <fs_check_message>-msgty }    { <fs_check_message>-text } . | ).
      ENDLOOP.
    ELSEIF lt_cats_ext IS NOT INITIAL.
      COMMIT WORK.

      READ TABLE lt_catsdb_ext INTO DATA(ls_catsdbt) INDEX 1.
      ev_execution_status = check_existence( iv_id = CONV #( ls_catsdbt-counter ) ).

*    returns the counter created is present in the catsdb
      IF ev_execution_status EQ abap_true.
        APPEND ls_catsdbt-counter TO ev_document_id.
      ENDIF.
    ENDIF.

**** trigger CATS Posting to CO
*    READ TABLE lt_catsls_timedata INDEX 1.    "#EC CI_NOORDER

    CALL METHOD me->transfer_to_co
      EXPORTING
        iv_pernr = lv_pernr.






  ENDMETHOD.


  method CHECK.
  endmethod.


  METHOD check_existence.

    DATA: lv_counter TYPE  catscounte.
    MOVE iv_id TO lv_counter.

    SELECT SINGLE counter FROM catsdb WHERE counter = @lv_counter INTO @DATA(lv_db_counter).
    IF sy-subrc = 0 and lv_db_counter IS NOT INITIAL.
      rv_exists = abap_true.
*       me->mo_run_environment->append_log( iv_log_statement =  TEXT-002  ).
*      ELSE.
*       me->mo_run_environment->append_log( iv_log_statement =   TEXT-001 ).
    ENDIF.

  ENDMETHOD.


  METHOD create.
    DATA:

      lv_pernr            TYPE pernr_d,
      lv_workpackage_mpid TYPE /cpd/eng_mp_id,
      lv_release_data     TYPE boole_d,
      lv_dataentryprofile TYPE catsvarian,
      lv_iscpm            TYPE boole_d,
      lv_ispo             TYPE boole_d,
      lv_sebeln           TYPE sebeln,
      lv_sebelp           TYPE sebelp,

**      ls_data             TYPE c_persnwrkagrmtdetfortmesht,
**      ls_employment_details TYPE /shcm/s_employment_information,
      ls_cats_ext         TYPE cats_ext,
**      ls_profile            TYPE tcats,
      ls_testdata         TYPE ty_gs_ptf_tme_cr_td,
      ls_ekpo             TYPE ekpo,

      lt_cats_ext         TYPE cats_ext_itab,
      lt_check_messages   TYPE TABLE OF mesg,
      lt_catsdb_ext       TYPE catsdb_ext_itab,
      lt_vbeln_po         TYPE cl_ptf_util=>ty_vbeln_tab,
      lt_vbeln_cpm        TYPE cl_ptf_util=>ty_vbeln_tab,
      lt_longtext_ext     TYPE longtext_ext_itab.
**      lt_messages           TYPE bapirettab.


    CLEAR : ev_check_status,ev_document_id,ev_execution_status.

    DATA(ls_current_step) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_current_step
      IMPORTING
        es_testdata  = ls_testdata ).

*Check Predecessor Status
    LOOP AT ls_current_step-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      DATA(ls_reference_step) = me->mo_run_environment->get_step_data( iv_step_number =  <lv_ref_step> ).
      IF ls_reference_step-bus_obj = 'CUSTOMER_PROJECT'.
        lv_iscpm = abap_true.
        APPEND LINES OF lt_ptf_keys TO lt_vbeln_cpm.
      ELSEIF ls_reference_step-bus_obj = 'PO'.
        lv_ispo = abap_true.
        APPEND LINES OF lt_ptf_keys TO lt_vbeln_po.
      ENDIF.
    ENDLOOP.





*-----------------------------------------------------------------------
*             pre requisite data creation
*-----------------------------------------------------------------------
*   get pernr from the workperson

    me->get_pernr(
      EXPORTING
        iv_employee =  ls_testdata-tme_employee
      IMPORTING
        ev_pernr    =   lv_pernr               " Personnel Number
    ).

* check external employee
    cl_hcm_cats_man_v1_utility=>check_external_employee(
      EXPORTING
        iv_pernr             = lv_pernr
      IMPORTING
        ev_external_employee =  DATA(lv_external_employee) ).

*     extract employee costcentre using the pernr
    SELECT SINGLE  costcenter FROM c_persnwrkagrmtdetfortmesht  ##WARN_OK
      WHERE personworkagreement = @lv_pernr INTO @DATA(lv_emp_costcentre).


    ls_cats_ext-pernr     = lv_pernr.
    ls_cats_ext-workdate  = sy-datum.
    ls_cats_ext-catshours = ls_testdata-tme_catshours_in.
    ls_cats_ext-ltxa1        = 'Simple Note' && sy-datum.
*   -------------------------------------------------------------
*   when cpm details are sent
*   --------------------------------------------------------------
    IF lv_iscpm = abap_true.
      LOOP AT lt_vbeln_cpm ASSIGNING FIELD-SYMBOL(<fs_cpm_keys>).
        lv_workpackage_mpid = <fs_cpm_keys>-vbeln.
        me->mo_run_environment->append_log( iv_log_statement = | Reference data from previous step : { <fs_cpm_keys>-vbeln } .|  ).
      ENDLOOP.

*       derive workpackege from MP ID which is passed from CPM
      SELECT SINGLE \_engagementprojfinancialplan\_workpackage-workpackage FROM i_engagementproject ##ASSOC_TO_N_OK[_WORKPACKAGE]  ##WARN_OK
            WHERE engagementproject = @lv_workpackage_mpid INTO @DATA(lv_wrkpackage).
*   extract rproj from the workpackage
      SELECT SINGLE wbselementinternalid  FROM i_wbselementbasicdata WHERE  ##WARN_OK
         wbselement = @lv_wrkpackage INTO @DATA(lv_rproj).

      ls_cats_ext-skostl       = lv_emp_costcentre."'P0T00004'"
      ls_cats_ext-rproj        = lv_rproj.                  "00017786"
      ls_cats_ext-lstar        = 'T001'.
      ls_cats_ext-work_item_id = 'M001'.

    ENDIF.
* -----------------------------------------------------------
*   when po details are sent
* -----------------------------------------------------------
    IF lv_ispo = abap_true  AND lv_external_employee IS NOT INITIAL .

      LOOP AT lt_vbeln_po ASSIGNING FIELD-SYMBOL(<fs_po_keys>).
        lv_sebeln = <fs_po_keys>-vbeln.
        me->mo_run_environment->append_log( iv_log_statement = | Reference data from previous step : { <fs_po_keys>-vbeln } .|  ).
      ENDLOOP.
*  get the poitem using po
      SELECT SINGLE \_purchaseorderitem-purchaseorderitem FROM i_purchaseorder  ##ASSOC_TO_N_OK[_PURCHASEORDERITEM]
                     WHERE purchaseorder = @lv_sebeln INTO @DATA(lv_poitem).
      IF sy-subrc = 0.
        ls_cats_ext-sebeln = lv_sebeln.
        ls_cats_ext-sebelp = lv_poitem.
      ENDIF.



*** Read the account assignment category for PO
      CALL FUNCTION 'ME_EKPO_SINGLE_READ' ##FM_SUBRC_OK
        EXPORTING
          pi_ebeln         = lv_sebeln
          pi_ebelp         = lv_sebelp
        IMPORTING
          po_ekpo          = ls_ekpo
        EXCEPTIONS
          no_records_found = 1
          OTHERS           = 2.

****  Get Cost Center from the PO
      IF ls_ekpo-knttp = 'K'.
        SELECT SINGLE kostl FROM ekkn INTO ls_cats_ext-skostl ##WARN_OK
                            WHERE ebeln = lv_sebeln
                            AND   ebelp = lv_sebelp.
        ls_cats_ext-lstar        = 'T001'.
      ENDIF.

    ENDIF.

    IF lv_iscpm IS INITIAL AND lv_ispo IS INITIAL AND lv_external_employee IS INITIAL .
      ls_cats_ext-rkostl       = lv_emp_costcentre."'P0T00004'"
      ls_cats_ext-tasktype      = 'ADMI'.
      ls_cats_ext-taskcomponent = 'WORK'.
      ls_cats_ext-tasklevel     = 'NONE'.
    ENDIF.







* check pernar Validity
**    SELECT SINGLE  * FROM c_persnwrkagrmtdetfortmesht( p_todaydate = @sy-datum ) WITH PRIVILEGED ACCESS
**                           WHERE personworkagreement = @lv_pernr INTO @ls_data.
**    IF sy-subrc = 0.
**      ls_employment_details-employee_id  = ls_data-personworkagreement.
**      ls_employment_details-start_date   = ls_data-startdate.
**      ls_employment_details-end_date     = ls_data-enddate.
**      ls_employment_details-status       = ls_data-workagreementstatus.
**    ENDIF.

*    fill teh cats structure with the values defined


*    IF lv_iscpm = abap_true.
*      ls_cats_ext-skostl       = lv_emp_costcentre."'P0T00004'"
*      ls_cats_ext-rproj        = lv_rproj.                  "00017786"
*      ls_cats_ext-lstar        = 'T001'.
*      ls_cats_ext-work_item_id = 'M001'.
*    ELSE.
*      ls_cats_ext-rkostl       = lv_emp_costcentre."'P0T00004'"
*      ls_cats_ext-tasktype      = 'ADMI'.
*      ls_cats_ext-taskcomponent = 'WORK'.
*      ls_cats_ext-tasklevel     = 'NONE'.
*    ENDIF.


    APPEND ls_cats_ext TO lt_cats_ext.
    me->mo_run_environment->append_log( iv_log_statement = | lv_pernr : { lv_pernr } , employee cost Centre :  { ls_cats_ext-skostl }.|  ).

*Get Default DATA ENTRY PROFILE
    CALL FUNCTION 'CATS_GET_DEFAULT_DEP'
      EXPORTING
        iv_pernr   = lv_pernr
      IMPORTING
**       es_profile  = ls_profile
**        et_messages = lt_messages
        ev_profile = lv_dataentryprofile.

* calling the actual function to create the timesheet
    CALL FUNCTION 'CATS_EXTERNAL_INTERFACE' ##FM_SUBRC_OK
      EXPORTING
        profile           = lv_dataentryprofile
        testrun           = ''
        release_data      = abap_true "lv_release_data
        cats_text_format  = 'ITF'
        commit_work       = space
*      IMPORTING
*       error_occurred    = lv_error_occured
      TABLES
        ext_interface     = lt_cats_ext
        check_messages    = lt_check_messages
        ext_interface_out = lt_catsdb_ext
        ext_longtext      = lt_longtext_ext
      EXCEPTIONS
        error_occurred    = 1
        OTHERS            = 2.

*    READ TABLE lt_check_messages WITH KEY msgty CA 'EAX' TR.
    LOOP AT lt_check_messages ASSIGNING FIELD-SYMBOL(<fs_check_message>) WHERE msgty CA 'EAX'.
      DATA(lv_error) = abap_true.
      EXIT.
    ENDLOOP.

    IF lv_error = abap_true.
      LOOP AT lt_check_messages ASSIGNING <fs_check_message>.
        me->mo_run_environment->append_log( iv_log_statement = | { <fs_check_message>-msgty }    { <fs_check_message>-text } . | ).
      ENDLOOP.
    ELSEIF lt_cats_ext IS NOT INITIAL.
      COMMIT WORK.

      READ TABLE lt_catsdb_ext INTO DATA(ls_catsdb) INDEX 1.
      ev_execution_status = check_existence( iv_id = CONV #( ls_catsdb-counter ) ).

*    returns the counter created is present in the catsdb
      IF ev_execution_status EQ abap_true.
        APPEND ls_catsdb-counter TO ev_document_id.
      ENDIF.
    ENDIF.

*** trigger CATS Posting to SES (only for contingent workers).
*    IF lv_external_employee = abap_true.
*      CALL METHOD me->transfer_to_ses
*        EXPORTING
*          it_timeentry = lt_catsdb_ext.
*    ENDIF.
*
**** trigger CATS Posting to CO
*    READ TABLE lt_catsls_timedata INDEX 1.    "#EC CI_NOORDER

    CALL METHOD me->transfer_to_co
      EXPORTING
        iv_pernr = lv_pernr.

  ENDMETHOD.


  METHOD delete.

    DATA :
      lv_istme            TYPE boole_d,
      lv_pernr            TYPE pernr_d,
      lv_counter          TYPE catscounte,
      lv_release_data     TYPE boole_d,
      lv_dataentryprofile TYPE catsvarian,

      ls_testdata         TYPE ty_gs_ptf_tme_cr_td,
      ls_cats_ext         TYPE cats_ext,

      lt_cats_ext         TYPE cats_ext_itab,
      lt_catsdb_ext       TYPE catsdb_ext_itab,
      lt_check_messages   TYPE TABLE OF mesg,
      lt_longtext_ext     TYPE longtext_ext_itab,
      lt_vbeln_tme        TYPE cl_ptf_util=>ty_vbeln_tab.





    DATA(ls_current_step) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).

*    cl_ptf_util=>get_testdata(
*      EXPORTING
*        is_step_data = ls_current_step
*      IMPORTING
*        es_testdata  = ls_testdata ).

*Check Predecessor Status
    LOOP AT ls_current_step-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      DATA(ls_reference_step) = me->mo_run_environment->get_step_data( iv_step_number =  <lv_ref_step> ).
      IF ls_reference_step-bus_obj = 'TME'.
        lv_istme = abap_true.
        APPEND LINES OF lt_ptf_keys TO lt_vbeln_tme.
      ENDIF.

    ENDLOOP.

*    me->get_pernr(
*      EXPORTING
*        iv_employee = ls_testdata-tme_employee
*      IMPORTING
*        ev_pernr    = lv_pernr
*    ).

    IF lv_istme = abap_true.
      LOOP AT lt_vbeln_tme ASSIGNING FIELD-SYMBOL(<fs_tme_keys>).
        lv_counter = <fs_tme_keys>-vbeln.
        me->mo_run_environment->append_log( iv_log_statement = | Reference data from previous step : { <fs_tme_keys>-vbeln } .|  ).
      ENDLOOP.
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = | For Update the reference  Step BO should be TME .| ).
    ENDIF.

    SELECT SINGLE * FROM catsdb INTO @DATA(ls_catsdb) WHERE counter = @lv_counter.

    ls_catsdb-catshours = 0.
    ls_catsdb-ltxa1 = 'Delete Note ' && sy-datum.
    lv_pernr = ls_catsdb-pernr.
    MOVE-CORRESPONDING ls_catsdb TO  ls_cats_ext.

    APPEND ls_cats_ext TO lt_cats_ext.

*    Get Default DATA ENTRY PROFILE
    CALL FUNCTION 'CATS_GET_DEFAULT_DEP'
      EXPORTING
        iv_pernr   = lv_pernr
      IMPORTING
**       es_profile  = ls_profile
**        et_messages = lt_messages
        ev_profile = lv_dataentryprofile.


* calling the actual function to create the timesheet
    CALL FUNCTION 'CATS_EXTERNAL_INTERFACE' ##FM_SUBRC_OK
      EXPORTING
        profile           = lv_dataentryprofile
        testrun           = ''
        release_data      = abap_true "lv_release_data
        cats_text_format  = 'ITF'
        commit_work       = space
*      IMPORTING
*       error_occurred    = lv_error_occured
      TABLES
        ext_interface     = lt_cats_ext
        check_messages    = lt_check_messages
        ext_interface_out = lt_catsdb_ext
        ext_longtext      = lt_longtext_ext
      EXCEPTIONS
        error_occurred    = 1
        OTHERS            = 2.

*        READ TABLE lt_check_messages WITH KEY msgty CA 'EAX' TR.
    LOOP AT lt_check_messages ASSIGNING FIELD-SYMBOL(<fs_check_message>) WHERE msgty CA 'EAX'.
      DATA(lv_error) = abap_true.
      EXIT.
    ENDLOOP.

    IF lv_error = abap_true.
      LOOP AT lt_check_messages ASSIGNING <fs_check_message>.
        me->mo_run_environment->append_log( iv_log_statement = | { <fs_check_message>-msgty }    { <fs_check_message>-text } . | ).
      ENDLOOP.
    ELSEIF lt_cats_ext IS NOT INITIAL.
      COMMIT WORK.


      READ TABLE lt_catsdb_ext INTO DATA(ls_catsdbt) INDEX 1.
      IF sy-subrc = 0.
        IF NOT ( ls_catsdbt-status EQ 10 OR ls_catsdbt-status EQ 20 ).
          ev_execution_status = check_existence( iv_id = CONV #( ls_catsdbt-counter ) ).
        ELSE.
          ev_execution_status = abap_true.
        ENDIF.
      ENDIF.
*    returns the counter created is present in the catsdb
      IF ev_execution_status EQ abap_true.
        APPEND ls_catsdbt-counter TO ev_document_id.
      ENDIF.
    ENDIF.
**** trigger CATS Posting to CO
*    READ TABLE lt_catsls_timedata INDEX 1.    "#EC CI_NOORDER

    CALL METHOD me->transfer_to_co
      EXPORTING
        iv_pernr = lv_pernr.




  ENDMETHOD.


  METHOD execute_action.
    DATA:
      lv_pernr         TYPE        pernr_d,
      lv_counter       TYPE        catscounte,
      ls_records       TYPE        cats_approval_in,
      lt_records       TYPE        cats_approval_in_tab,
      lt_vbeln         TYPE        cl_ptf_util=>ty_vbeln_tab,
      lt_rec_processed TYPE        cats_approval_out_tab,
      lo_msg_handle    TYPE REF TO cl_message_handler_catsxt.


    DATA(ls_current_step) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).
*Check Predecessor Status
    LOOP AT ls_current_step-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      DATA(ls_reference_step) = me->mo_run_environment->get_step_data( iv_step_number =  <lv_ref_step> ).
      IF ls_reference_step-bus_obj = 'TME'.
        APPEND LINES OF lt_ptf_keys TO lt_vbeln.
      ENDIF.
    ENDLOOP.


    LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<fs_tme_keys>).
      lv_counter = <fs_tme_keys>-vbeln.
      me->mo_run_environment->append_log( iv_log_statement = | Reference data from previous step : { <fs_tme_keys>-vbeln } .|  ).
    ENDLOOP.


    SELECT SINGLE * FROM catsdb INTO @DATA(ls_catsdb) WHERE counter = @lv_counter.
    ls_records-counter       = lv_counter.
    ls_records-pernr         = ls_catsdb-pernr.

    IF ls_catsdb-status <> '20'.
      me->mo_run_environment->append_log( iv_log_statement = '| Time entry not ''sent for Approval''   .|' ).
      ev_execution_status = abap_false.
      ev_check_status = abap_false.
      RETURN.
    ENDIF.

    CREATE OBJECT lo_msg_handle
      EXPORTING
        im_cumulate_messages          = abap_true
        im_single_message_without_log = abap_false.



    CASE ls_current_step-action.
      WHEN 'APPROVE'.

        ls_records-target_status = '30'.

      WHEN 'REJECT'.

        ls_records-target_status = '40'.
        ls_records-reason = '0005'.

      WHEN OTHERS.
        me->mo_run_environment->append_log( iv_log_statement =  |Could not find method { ls_current_step-action } for the BO { ls_current_step-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.
    ENDCASE.

    APPEND   ls_records TO lt_records.

    CALL FUNCTION 'CATS_APPROVAL' ##FM_SUBRC_OK
      EXPORTING
        message_handler            = lo_msg_handle
        records                    = lt_records
        auth_check                 = abap_false
      IMPORTING
        processed_records          = lt_rec_processed
*       record_error               = lv_error
      EXCEPTIONS
        update_error               = 1
        number_range_error         = 2
        longtext_error             = 3
        message_handler_not_active = 4
        OTHERS                     = 5.

    SELECT SINGLE * FROM catsdb INTO @ls_catsdb WHERE counter = @lv_counter.
    IF ls_catsdb-status = '30' OR  ls_catsdb-status = '40'.
      ev_execution_status = abap_true.
      ev_check_status = abap_true.
      APPEND ls_catsdb-counter TO ev_document_id.

      CALL METHOD me->transfer_to_co
        EXPORTING
          iv_pernr = ls_catsdb-pernr.

      COMMIT WORK.

    ELSE.
      ev_execution_status = abap_false.
      ev_check_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = '| Status for APPROVAL/REJECT not updated   .|' ).
    ENDIF.


  ENDMETHOD.


  method EXECUTE_CHECK.
  endmethod.


  METHOD get_pernr.

    CLEAR: ev_pernr.

    SELECT SINGLE person FROM i_workforceperson INTO @DATA(lv_person)  ##WARN_OK
                      WHERE personexternalid = @iv_employee.
    IF sy-subrc = 0.
      SELECT SINGLE personworkagreement FROM i_personworkagreement_1   ##WARN_OK
                                        WHERE person = @lv_person INTO @ev_pernr.
    ENDIF.

  ENDMETHOD.


  METHOD TRANSFER_TO_CO.

    DATA : lt_pernr TYPE TABLE OF sel_pernr,
           ls_pernr TYPE sel_pernr.


    ls_pernr-sign   = 'I'.
    ls_pernr-option = 'EQ'.
    ls_pernr-low    = iv_pernr.

    APPEND ls_pernr TO lt_pernr.

***    call transfer to CO report (CAT7) in a background task
    CALL FUNCTION 'CATS_BATCH_TRANSFER_CO_BKG' IN BACKGROUND TASK
      EXPORTING
        warning       = abap_true
        write_slg_log = abap_true
      TABLES
        pernr         = lt_pernr.

  ENDMETHOD.


  METHOD TRANSFER_TO_SES.

    DATA lt_mm_counters TYPE cats_t_counter.
    DATA(lt_temp_timeentry) = it_timeentry[].

*** Delete all entries other than Purchase Order tasks and Where Status <> approved.
    DELETE lt_temp_timeentry WHERE status <> '30' OR data_fields-sebeln EQ ''.

    LOOP AT lt_temp_timeentry ASSIGNING FIELD-SYMBOL(<fs_temp_timeentry>).
      APPEND <fs_temp_timeentry>-counter TO lt_mm_counters.
      IF <fs_temp_timeentry>-refcounter IS NOT INITIAL.
        APPEND <fs_temp_timeentry>-refcounter TO lt_mm_counters. "Reversed Counters
      ENDIF.
    ENDLOOP.

    IF lt_mm_counters IS NOT INITIAL. " Call SES transfer
      CALL FUNCTION 'CATS_BATCH_TRANSFER_SES_BKG' IN BACKGROUND TASK
        EXPORTING
          it_counters = lt_mm_counters.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
