CLASS cl_ptf_bo_inquiry DEFINITION
  PUBLIC
  INHERITING FROM cl_ptf_bo
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS create REDEFINITION .
    METHODS change REDEFINITION .
    METHODS delete REDEFINITION .
    METHODS check REDEFINITION .
    METHODS execute_action REDEFINITION .
    METHODS execute_check REDEFINITION .
    METHODS check_existence REDEFINITION.

    TYPES:
    BEGIN OF ty_gs_item_list_td,
        material_id TYPE matnr,
        quantity    TYPE dzmeng,
        posnr       TYPE posnr_va,
        fkdat       TYPE fkdat,
        werks       TYPE werks_d,
        parvw       TYPE parvw,
        pernr       TYPE pernr_d,
    END OF ty_gs_item_list_td.

    TYPES:
        ty_gt_item_list_td   TYPE STANDARD TABLE OF ty_gs_item_list_td WITH NON-UNIQUE KEY posnr.

    TYPES:
* Structure for Inquiry create
      BEGIN OF ty_gs_i_ptf_inquiry_cr_td,
        document_type        TYPE auart,
        sales_organization   TYPE vkorg,
        distribution_channel TYPE vtweg,
        division             TYPE spart,
        customer_id          TYPE kunnr,
        inq_reason           TYPE augru,
        billing_block        TYPE faksk,
        valid_to_date        TYPE bnddt,
        purch_number         TYPE bstkd,
        customer_name        TYPE name1_gp,
        contact_person       TYPE parnr,
        item_list            TYPE ty_gt_item_list_td,
        q2c_multiple_address_switch TYPE char1,
*        item_list            TYPE cl_ptf_util=>ty_gt_item_list_td,
      END OF ty_gs_i_ptf_inquiry_cr_td .

     TYPES:
* Structure for check inquiry partner address
      BEGIN OF ty_gs_ptf_sd_partner_td,
        item_number TYPE posnr,
        role        TYPE parvw,
        customer    TYPE kunnr,
        adrnr       TYPE ad_addrnum,
        adrda       TYPE adrda,
        addr_type   TYPE ad_adrtype,
      END OF ty_gs_ptf_sd_partner_td .

    TYPES:
        partner_tab TYPE STANDARD TABLE OF ty_gs_ptf_sd_partner_td WITH DEFAULT KEY .

    TYPES:
      BEGIN OF ty_gs_ptf_sd_check_partner_td,
        partner TYPE partner_tab,
      END OF ty_gs_ptf_sd_check_partner_td .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
  ty_gt_inq_partners TYPE STANDARD TABLE OF bapiparnr .
    TYPES:
      ty_gt_inq_items    TYPE STANDARD TABLE OF bapisditm .
    TYPES:
      ty_gt_schedules      TYPE STANDARD TABLE OF bapischdl .

    METHODS prepare_testdata_create
      IMPORTING
        !ls_testdata        TYPE ty_gs_i_ptf_inquiry_cr_td
      EXPORTING
        !ls_inq_header_in TYPE bapisdhd1
        !lt_inq_partners  TYPE ty_gt_inq_partners
        !lt_inq_items     TYPE ty_gt_inq_items
        !lt_schedules       TYPE ty_gt_schedules .

ENDCLASS.



CLASS CL_PTF_BO_INQUIRY IMPLEMENTATION.


  METHOD change.
  ENDMETHOD.


  METHOD check.

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    DATA: test_data TYPE ty_gs_ptf_sd_check_partner_td.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = test_data
    ).

    ev_check_status = abap_true.

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(doc_ids)  = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).

      LOOP AT doc_ids ASSIGNING FIELD-SYMBOL(<doc>).
        LOOP AT test_data-partner ASSIGNING FIELD-SYMBOL(<partner>).
          IF <partner>-item_number IS NOT INITIAL.
            SELECT SINGLE vbeln, posnr, parvw FROM vbpa  INTO @DATA(entry_pos) WHERE vbeln = @<doc>-vbeln AND posnr = @<partner>-item_number AND kunnr = @<partner>-customer AND parvw = @<partner>-role
                          AND adrda = @<partner>-adrda AND addr_type = @<partner>-addr_type.
          ELSE.
            SELECT SINGLE vbeln, posnr, parvw FROM vbpa INTO @DATA(entry) WHERE vbeln = @<doc>-vbeln AND kunnr = @<partner>-customer AND parvw = @<partner>-role
                          AND adrda = @<partner>-adrda AND addr_type = @<partner>-addr_type.
          ENDIF.
          IF sy-subrc <> 0.
            ev_check_status = abap_false.
            IF <partner>-item_number IS NOT INITIAL.
              me->mo_run_environment->append_log( iv_log_statement = |Partner { <partner>-role } { <partner>-customer } contains inconsistant data in SD { <doc>-vbeln } for position { <partner>-item_number }| ).
            ELSE.
              me->mo_run_environment->append_log( iv_log_statement = |Partner { <partner>-role } { <partner>-customer } contains inconsistant data in SD { <doc>-vbeln }| ).
            ENDIF.
          ENDIF."IF sy-subrc <> 0.
        ENDLOOP."LOOP AT test_data-partner ASSIGNING FIELD-SYMBOL(<partner>).
      ENDLOOP."LOOP AT doc_ids ASSIGNING FIELD-SYMBOL(<doc>).
    ENDLOOP."LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
    ev_execution_status = abap_true.


  ENDMETHOD.


  METHOD check_existence.
  DATA: lv_vbeln TYPE vbeln.
    MOVE iv_id TO lv_vbeln.

    SELECT SINGLE * FROM vbak WHERE vbeln = @lv_vbeln INTO @DATA(ls_inquiry).
    IF sy-subrc <> 0.
      me->mo_run_environment->append_log( iv_log_statement = |Inquiry { lv_vbeln } does not exist.| ).
      rv_exists = abap_false.
    ELSE.
      rv_exists = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD create.
    DATA: ls_testdata      TYPE ty_gs_i_ptf_inquiry_cr_td,
          ls_inq_header_in TYPE bapisdhd1,
          lt_inq_partners  TYPE TABLE OF bapiparnr,
          lt_inq_items     TYPE TABLE OF bapisditm,
          lt_schedules     TYPE TABLE OF bapischdl,
          ls_return        TYPE bapiret2,
          lt_return        TYPE TABLE OF bapiret2,
          lv_vbeln         TYPE vbeln.
*****************************************************************************
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
* 1 Step: get tdcv
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).
*****************************************************************************
* 2 Step: check wether the Item-number if filled;
***    call method cl_ptf_bo_inquiry=>prestep_posnr
***      exporting
***        is_step_data = cs_step_data
***      changing
***        is_data      = ls_testdata
***        ct_return    = lt_return.
*****************************************************************************
* 3 Step: Prepare Testdata for 'SD_SALESDOCUMENT_CREATE'
    CALL METHOD prepare_testdata_create
      EXPORTING
        ls_testdata      = ls_testdata
      IMPORTING
        ls_inq_header_in = ls_inq_header_in
        lt_inq_partners  = lt_inq_partners
        lt_inq_items     = lt_inq_items
        lt_schedules     = lt_schedules.

*****************************************************************************
*Mock multiple address switch (usefuless)
 DATA lv_usr_q2c_multi_param TYPE CHAR1.
 lv_usr_q2c_multi_param = ls_testdata-q2c_multiple_address_switch.
 SET PARAMETER ID: 'Q2C_MULTIPLE_ADDRESS' FIELD lv_usr_q2c_multi_param.
*****************************************************************************
* 4 Step: Create and commit Inquiry
    CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
      EXPORTING
        sales_header_in    = ls_inq_header_in
      IMPORTING
        salesdocument_ex   = lv_vbeln
      TABLES
        return             = lt_return
        sales_items_in     = lt_inq_items
        sales_partners     = lt_inq_partners
        sales_schedules_in = lt_schedules.

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

*****************************************************************************
* 6 Step: Check whether Inquiry exists
    DATA: lv_ptf_key TYPE ptfkey.
    MOVE lv_vbeln TO lv_ptf_key.

    APPEND lv_vbeln TO ev_document_id.
    ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).


  ENDMETHOD.


  METHOD delete.
  ENDMETHOD.


  METHOD execute_action.
  ENDMETHOD.


  METHOD execute_check.
  ENDMETHOD.


  METHOD prepare_testdata_create.
    DATA: ls_inq_partners TYPE bapiparnr,
          ls_inq_items    TYPE bapisditm,
          ls_schedules    TYPE bapischdl.

    ls_inq_header_in-doc_type = ls_testdata-document_type.
    ls_inq_header_in-sales_org = ls_testdata-sales_organization.
    ls_inq_header_in-distr_chan = ls_testdata-distribution_channel.
    ls_inq_header_in-division = ls_testdata-division.
    ls_inq_header_in-ord_reason = ls_testdata-inq_reason.
    ls_inq_header_in-qt_valid_t = ls_testdata-valid_to_date.
    ls_inq_header_in-purch_no_c = ls_testdata-purch_number.

* Header Partner: Sold-to Party
    ls_inq_partners-partn_role = 'AG'.
    IF ls_testdata-customer_name IS NOT INITIAL.
      ls_inq_partners-name = ls_testdata-customer_name.
    ENDIF.
*    ls_inq_partners-partn_numb = ls_data_inq-customer_id.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ls_testdata-customer_id " C field
      IMPORTING
        output = ls_inq_partners-partn_numb.
    APPEND  ls_inq_partners TO  lt_inq_partners.
    CLEAR ls_inq_partners.

* Header Partner: Contact Person
    IF ls_testdata-contact_person IS NOT INITIAL.
      ls_inq_partners-partn_role = 'AP'.
      ls_inq_partners-partn_numb = ls_testdata-contact_person.
      APPEND  ls_inq_partners TO  lt_inq_partners.
    ENDIF.

    LOOP AT ls_testdata-item_list ASSIGNING FIELD-SYMBOL(<ls_inq_item_list>).
      ls_inq_items-itm_number = <ls_inq_item_list>-posnr.
      ls_inq_items-material =  <ls_inq_item_list>-material_id.
      ls_inq_items-target_qty = <ls_inq_item_list>-quantity.
      ls_inq_items-plant = <ls_inq_item_list>-werks.
*      ls_inq_items-item_categ = <ls_inq_item_list>-item_category.
      APPEND ls_inq_items TO lt_inq_items.

      ls_schedules-itm_number = <ls_inq_item_list>-posnr.
      ls_schedules-req_qty    = <ls_inq_item_list>-quantity.
      ls_schedules-req_date    = sy-datum.
      APPEND ls_schedules TO lt_schedules.

      ls_inq_partners-itm_number = <ls_inq_item_list>-posnr.
      ls_inq_partners-partn_role = <ls_inq_item_list>-parvw.
      ls_inq_partners-partn_numb = <ls_inq_item_list>-pernr.
      APPEND  ls_inq_partners TO  lt_inq_partners.

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
