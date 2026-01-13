CLASS cl_ptf_bo_cmr DEFINITION
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
      BEGIN OF ty_order_reason,
        order_reason TYPE augru,
      END OF ty_order_reason.

    TYPES:
** Structure for CMR create
      BEGIN OF ty_gs_i_ptf_cmr_cr_td,
        document_type        TYPE auart,
        sales_organization   TYPE vkorg,
        distribution_channel TYPE vtweg,
        division             TYPE spart,
        customer_id          TYPE kunnr,
        order_reason         TYPE augru,
        billing_block        TYPE faksk,
        item_list            TYPE cl_ptf_util=>ty_gt_item_list_td,
        condition            TYPE cl_ptf_util=>lty_sales_conditions_in,
        order_partners       TYPE cl_ptf_util=>ty_order_partners,
        ext_fields_item      TYPE cl_ptf_util=>ty_gt_ext_field_td,
      END OF ty_gs_i_ptf_cmr_cr_td .
    TYPES:
** Structure for CMR create with reference
      BEGIN OF ty_gs_i_ptf_cmr_cr_with_ref_td,
        document_type      TYPE auart,
        delta_billing_date TYPE int2,
      END OF ty_gs_i_ptf_cmr_cr_with_ref_td .
    TYPES:
** Structure for CMR change
      BEGIN OF ty_gs_i_ptf_cmr_ch_td,
        document_type        TYPE auart,
        sales_organization   TYPE vkorg,
        distribution_channel TYPE vtweg,
        division             TYPE spart,
        customer_id          TYPE kunnr,
        order_reason         TYPE augru,
        billing_block        TYPE faksk,
        item_list            TYPE cl_ptf_util=>ty_gt_item_list_td,
      END OF ty_gs_i_ptf_cmr_ch_td .
  PROTECTED SECTION.

    TYPES:
      ty_gt_cmr_partners TYPE STANDARD TABLE OF bapiparnr .
    TYPES:
      ty_gt_cmr_items    TYPE STANDARD TABLE OF bapisditm .
    TYPES:
      ty_gt_schedules      TYPE STANDARD TABLE OF bapischdl .

private section.

  constants C_CREATE_WITH_REF type STRING value 'CREATE_WITH_REFERENCE' ##NO_TEXT.
  constants C_CHECK_EXT_FIELDS type STRING value 'CHECK_EXT_FIELDS' ##NO_TEXT.
  constants C_SET_ORDER_REASON type STRING value 'SET_ORDER_REASON' ##NO_TEXT.
  constants C_REMOVE_BILLING_BLOCK type STRING value 'REMOVE_BILLING_BLOCK' ##NO_TEXT.

  methods PREPARE_TESTDATA_CREATE
    importing
      !LS_TESTDATA type TY_GS_I_PTF_CMR_CR_TD
    exporting
      !LS_ORDER_HEADER_IN type BAPISDHD1
      !LT_ORDER_PARTNERS type TY_GT_CMR_PARTNERS
      !LT_ORDER_ITEMS type TY_GT_CMR_ITEMS
      !LT_SCHEDULES type TY_GT_SCHEDULES .
  methods REMOVE_BILLING_BLOCK
    importing
      !IV_ORDER_NUMBER type PTFKEY
    returning
      value(EV_TEST_SUCCESS) type ABAP_BOOL .
  methods SET_ORDER_REASON
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_WITH_REFERENCE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                    "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ADD_BILLING_BLOCK
    importing
      !IV_ORDER_NUMBER type PTFKEY
      !IV_CHANCE_TDC type TY_GS_I_PTF_CMR_CH_TD
    exporting
      !ET_RETURN type CL_PTF_UTIL=>GT_PTF_RETURN_TAB
    returning
      value(EV_TEST_SUCCESS) type ABAP_BOOL .
  methods CHECK_EXT_FIELDS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                    "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHANGE_ITEM_LIST
    importing
      !IV_ORDER_NUMBER type PTFKEY
      !IV_CHANCE_TDC type TY_GS_I_PTF_CMR_CH_TD
    exporting
      !EV_TEST_SUCCESS type ABAP_BOOL
      !ET_RETURN type CL_PTF_UTIL=>GT_PTF_RETURN_TAB .
ENDCLASS.



CLASS CL_PTF_BO_CMR IMPLEMENTATION.


  METHOD add_billing_block.
    DATA: ls_header_inx TYPE bapisdh1x,
          ls_header_in  TYPE bapisdh1,
          ls_return     TYPE bapiret2,
          lt_return     TYPE cl_ptf_util=>gt_ptf_return_tab.

    ls_header_inx-updateflag  = 'U'.
    ls_header_inx-bill_block = 'X'.
    ls_header_in-bill_block  = iv_chance_tdc-billing_block.

    DATA: lv_vbeln TYPE vbeln.
    MOVE iv_order_number TO lv_vbeln.

    CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
      EXPORTING
        salesdocument    = lv_vbeln   " Order Number
        order_header_in  = ls_header_in
        order_header_inx = ls_header_inx  " Sales Order Check List
      TABLES
        return           = lt_return.  " Return Code

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

* Check wether the billingblock is clear.
    SELECT SINGLE faksk FROM vbak INTO @DATA(lv_billing_block) WHERE vbeln = @iv_order_number.
    IF lv_billing_block <> space.
      ev_test_success = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD change.

    DATA: ls_chance_tdc TYPE ty_gs_i_ptf_cmr_ch_td,
          bool_rembb    TYPE abap_bool,
          lt_return     TYPE cl_ptf_util=>gt_ptf_return_tab,
          lv_ptf_tdc    TYPE etobj_name,
          ls_return     TYPE bapiret2,
*          lt_vbeln      TYPE TABLE OF vbeln,
          lt_vbeln_in   TYPE cl_ptf_util=>ty_vbeln_tab.

*****************************************************************************
* First Step: get tdcv

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_chance_tdc
    ).
*****************************************************************************
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln_in.
    ENDLOOP.

    LOOP AT lt_vbeln_in ASSIGNING FIELD-SYMBOL(<vbeln>).
*****************************************************************************
* Check if the billing block has to removed.

      IF ls_chance_tdc-billing_block = '00'.
        me->remove_billing_block( iv_order_number = <vbeln>-vbeln ).

        ev_execution_status = abap_false.
        cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

      ELSEIF ls_chance_tdc-billing_block IS NOT INITIAL.
        me->add_billing_block(
          EXPORTING
            iv_order_number = <vbeln>-vbeln
            iv_chance_tdc   = ls_chance_tdc
          RECEIVING
            ev_test_success = ev_execution_status
        ).

        cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

      ENDIF.
*****************************************************************************
* check if and where the item list hat to change

      LOOP AT ls_chance_tdc-item_list ASSIGNING FIELD-SYMBOL(<ls_item_list>).
        IF <ls_item_list>-material_id IS NOT INITIAL
        OR <ls_item_list>-posnr IS NOT INITIAL
        OR <ls_item_list>-quantity IS NOT INITIAL.
          DATA(b_change_itemlist) = abap_true.
          EXIT.
        ENDIF.
      ENDLOOP.

      IF b_change_itemlist = abap_true.
        DATA lv_ptf_key TYPE ptfkey.
        MOVE <vbeln>-vbeln TO lv_ptf_key.

        change_item_list(
          EXPORTING
            iv_order_number = lv_ptf_key
            iv_chance_tdc   = ls_chance_tdc
          IMPORTING
            ev_test_success = bool_rembb
            et_return       = lt_return ).
        cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
        ev_execution_status = bool_rembb.
      ENDIF.

    ENDLOOP.
*****************************************************************************
    CLEAR ev_document_id.
    MOVE lt_vbeln_in TO ev_document_id.

  ENDMETHOD.


  METHOD change_item_list.

    DATA: ls_order_item_inx TYPE bapisditmx,
          lt_order_item_inx TYPE TABLE OF bapisditmx,
          ls_header_inx     TYPE bapisdh1x,
          ls_header_in      TYPE bapisdh1,
          ls_order_items    TYPE bapisditm,
          lt_order_items    TYPE TABLE OF bapisditm,
          lt_return	        TYPE cl_ptf_util=>gt_ptf_return_tab,
          ls_return         TYPE bapiret2.

    CLEAR et_return.
    CLEAR ev_test_success.

    CLEAR lt_order_items.
    ls_header_inx-updateflag  = 'U'.

* Check where the changes have to be made.
    LOOP AT iv_chance_tdc-item_list ASSIGNING FIELD-SYMBOL(<ls_item_list>).
      IF <ls_item_list>-posnr IS NOT INITIAL.
        ls_order_items-itm_number = <ls_item_list>-posnr.
      ENDIF.

      IF <ls_item_list>-material_id IS NOT INITIAL.
        ls_order_items-material = <ls_item_list>-material_id.
        ls_order_item_inx-material = 'X'.
        ls_order_item_inx-updateflag = 'U'.
      ENDIF.

      IF <ls_item_list>-quantity IS NOT INITIAL.
        ls_order_items-target_qty = <ls_item_list>-quantity.
        ls_order_item_inx-target_qty = 'X'.
        ls_order_item_inx-updateflag = 'U'.
      ENDIF.

      APPEND ls_order_items TO lt_order_items.
      APPEND ls_order_item_inx TO lt_order_item_inx.

    ENDLOOP.

*    IF sy-subrc = 0.
*      ls_order_item_inx-material = 'X'.   "Updateflag
*      ls_order_item_inx-updateflag = 'U'.
*    ENDIF.
*    APPEND ls_order_item_inx TO lt_order_item_inx.
    CLEAR et_return.

* execute the changes
    DATA lv_vbeln TYPE vbeln.
    MOVE iv_order_number TO lv_vbeln.

    CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
      EXPORTING
        salesdocument    = lv_vbeln   " Order Number
        order_header_in  = ls_header_in
        order_header_inx = ls_header_inx  " Sales Order Check List
      TABLES
        return           = lt_return " Return Code
        order_item_in    = lt_order_items  " Order Items
        order_item_inx   = lt_order_item_inx.  " Sales Order Items Check Table

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

* check if the process ended without errors.
    LOOP AT et_return ASSIGNING FIELD-SYMBOL(<ls_return>).
      IF <ls_return>-type = 'S'.  " S for Success
        ev_test_success = abap_true.
      ELSE.
        ev_test_success = abap_false.
        RETURN.
      ENDIF.
    ENDLOOP.
    IF et_return IS INITIAL.
      ev_test_success = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD check.
  ENDMETHOD.


  METHOD check_existence.
    DATA: lv_vbeln TYPE vbeln.
    MOVE iv_id TO lv_vbeln.

    SELECT SINGLE * FROM vbak WHERE vbeln = @lv_vbeln INTO @DATA(ls_order).
    IF sy-subrc <> 0.
      me->mo_run_environment->append_log( iv_log_statement = |Order { lv_vbeln } does not exist.| ).
      rv_exists = abap_false.
    ELSE.
      rv_exists = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD check_ext_fields.
    DATA: ls_testdata TYPE cl_ptf_sd_util=>ty_gs_i_ptf_ext_field_check_td,
          lt_items    TYPE TABLE OF vbap,
          lt_vbeln    TYPE cl_ptf_util=>ty_vbeln_tab.
    FIELD-SYMBOLS: <ls_ext_field_db> TYPE any.

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    ev_execution_status = abap_false.
    ev_check_status = abap_true.

    LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<ls_vbel>).
      SELECT SINGLE * FROM vbak INTO @DATA(ls_vbak) WHERE vbeln = @<ls_vbel>-vbeln.
      "Create table with the items of the specifique vbeln
      CLEAR lt_items.
      SELECT * FROM vbap INTO @DATA(ls_vbap) WHERE vbeln = @<ls_vbel>-vbeln.
        APPEND ls_vbap TO lt_items.
      ENDSELECT.

      LOOP AT ls_testdata-ext_fields ASSIGNING FIELD-SYMBOL(<ls_ext_field>).
        IF <ls_ext_field>-type EQ 'H'.
          "check header ebene
          ASSIGN COMPONENT <ls_ext_field>-name OF STRUCTURE ls_vbak TO <ls_ext_field_db>.
          IF <ls_ext_field_db> IS NOT ASSIGNED.
            me->mo_run_environment->append_log( iv_log_statement = |Unknown ext field { <ls_ext_field>-name } for document { <ls_vbel>-vbeln }.| ).
            ev_check_status = abap_false.
          ELSE.
            IF <ls_ext_field_db> EQ <ls_ext_field>-expected_input.
              me->mo_run_environment->append_log( iv_log_statement = |Expected Input '{ <ls_ext_field>-expected_input }' for ext field { <ls_ext_field>-name } matches input '{ <ls_ext_field_db> }' for document { <ls_vbel>-vbeln }.| ).
            ELSE.
              ev_check_status = abap_false.
              me->mo_run_environment->append_log( iv_log_statement = |Expected Input '{ <ls_ext_field>-expected_input }' for ext field { <ls_ext_field>-name } doesn't match input '{ <ls_ext_field_db> }' for document { <ls_vbel>-vbeln }.| ).
            ENDIF.
          ENDIF.
        ELSEIF <ls_ext_field>-type EQ 'P'.
          LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<ls_item>).
            "check positions ebene
            ASSIGN COMPONENT <ls_ext_field>-name OF STRUCTURE <ls_item> TO <ls_ext_field_db>.
            IF <ls_ext_field_db> IS NOT ASSIGNED.
              ev_check_status = abap_false.
              me->mo_run_environment->append_log( iv_log_statement = |Unknown ext field { <ls_ext_field>-name } for document { <ls_vbel>-vbeln } and item-posnr { <ls_item>-posnr }.| ).
            ELSE.
              IF <ls_ext_field_db> EQ <ls_ext_field>-expected_input.
                me->mo_run_environment->append_log( iv_log_statement = |Expected Input '{ <ls_ext_field>-expected_input }' for ext field { <ls_ext_field>-name } matches input '{ <ls_ext_field_db> }' for document { <ls_vbel>-vbeln } and item-posnr {
<ls_item>-posnr }.| ).
              ELSE.
                ev_check_status = abap_false.
                me->mo_run_environment->append_log( iv_log_statement =
                    |Expected Input '{ <ls_ext_field>-expected_input }' for ext field { <ls_ext_field>-name } doesn't match input '{ <ls_ext_field_db> }' for document { <ls_vbel>-vbeln } and item-posnr { <ls_item>-posnr }.|
                ).
              ENDIF.
            ENDIF.
          ENDLOOP.
        ELSEIF <ls_ext_field>-type <> 'H' AND <ls_ext_field>-type <> 'P'.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |Unknown type of ext field { <ls_ext_field>-type } for field { <ls_ext_field>-name } and for document { <ls_vbel>-vbeln }.| ).
        ENDIF.
      ENDLOOP."LOOP AT ls_testdata-ext_fields ASSIGNING FIELD-SYMBOL(<ls_ext_field>).
    ENDLOOP. "LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<ls_vbel>).
    ev_execution_status = abap_true.
  ENDMETHOD.


  METHOD create.
    DATA: ls_testdata        TYPE ty_gs_i_ptf_cmr_cr_td,
          ls_order_header_in TYPE bapisdhd1,
          lt_order_partners  TYPE TABLE OF bapiparnr,
          lt_order_items     TYPE TABLE OF bapisditm,
          lt_schedules       TYPE TABLE OF bapischdl,
          lt_return          TYPE TABLE OF bapiret2,
          lv_vbeln           TYPE vbeln.
*****************************************************************************
* 1 Step: get tdcv
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

*****************************************************************************
* 3 Step: Prepare Testdata for 'SD_SALESDOCUMENT_CREATE'

    me->prepare_testdata_create(
      EXPORTING
        ls_testdata        = ls_testdata
      IMPORTING
        ls_order_header_in = ls_order_header_in
        lt_order_partners  = lt_order_partners
        lt_order_items     = lt_order_items
        lt_schedules       = lt_schedules
    ).

    ls_order_header_in-ord_reason = '105'.
*****************************************************************************
* 4 Step: Create and commit Sales Order
    CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
      EXPORTING
        sales_header_in    = ls_order_header_in
      IMPORTING
        salesdocument_ex   = lv_vbeln
      TABLES
        return             = lt_return
        sales_items_in     = lt_order_items
        sales_partners     = lt_order_partners
        sales_schedules_in = lt_schedules.

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ls_ret_mes>).
      me->mo_run_environment->append_log( iv_log_statement = |{ <ls_ret_mes>-message }| ).
    ENDLOOP.

    DATA: lv_ptf_key TYPE ptfkey.
    MOVE lv_vbeln TO lv_ptf_key.

    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ls_msg>).
      me->mo_run_environment->append_log( iv_log_statement = |{ <ls_msg>-message }| ).
    ENDLOOP.
*****************************************************************************
* 5 Step: Check Billing Block and Remove it
    IF ls_testdata-billing_block IS INITIAL.
      DATA(lv_suc) = me->remove_billing_block( iv_order_number = lv_ptf_key ).
      IF lv_suc <> abap_true.
        ev_execution_status = abap_false.
        RETURN.
      ENDIF.


    ENDIF.
*****************************************************************************
* 6 Step: Check whether Sales Order exists
    DATA(lv_does_exists) = me->check_existence( iv_id = lv_ptf_key ).

    IF lv_does_exists EQ abap_true.
      ev_execution_status = abap_true.
      APPEND lv_ptf_key TO ev_document_id.
    ELSE.
      ev_execution_status = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD create_with_reference.
    DATA:
      ls_testdata       TYPE ty_gs_i_ptf_cmr_cr_with_ref_td,
      lt_vbeln          TYPE cl_ptf_util=>ty_vbeln_tab,
      lv_error_occured  TYPE abap_bool VALUE abap_false,
      ls_load_parameter TYPE tds_goal_so_load,
      ls_head_data      TYPE tds_goal_so_head,
      lt_item_data      TYPE STANDARD TABLE OF tds_goal_so_item,
      lo_access         TYPE REF TO if_goal_access,
      ls_error          TYPE if_goal_types=>tcs_error,
      lv_bo_key         TYPE if_goal_types=>tcd_bo_key,
      lx_goal_exc       TYPE REF TO cx_goal_exc,
      lv_text_exc       TYPE string,
      ls_field_property TYPE if_goal_types=>tcs_object_property,
      lt_field_property TYPE if_goal_types=>tct_object_property,
      lt_message        TYPE if_goal_types=>tct_message,
      lv_cmr_vbeln      TYPE vbeln_va,
      lv_ptf_key        TYPE ptfkey,
      ls_itemlist       TYPE tdt_goal_sdoc_item_ref,
      lt_vbap           TYPE TABLE OF vbap,
      item              TYPE tds_goal_sdoc_item_ref,
      lt_vbrp           TYPE TABLE OF vbrp.
*****************************************************************************
* get tdcv
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata ).

    IF ls_testdata IS INITIAL. "Cannot merge both conditions, because ls_testdata could be null
      me->mo_run_environment->append_log( iv_log_statement = |Cannot delcare document type to be created .| ).
      ev_execution_status = abap_false.
      RETURN.
    ELSEIF ls_testdata-document_type IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Cannot delcare document type to be created .| ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.
*************************************************************************
*Check Predecessor Status
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    IF lt_vbeln IS NOT INITIAL.
      LOOP AT lt_vbeln REFERENCE INTO DATA(ls_vbeln).
        SELECT * FROM vbap WHERE vbeln = @ls_vbeln->vbeln INTO TABLE @lt_vbap.
        IF lt_vbap IS INITIAL.
          SELECT * FROM vbrp WHERE vbeln = @ls_vbeln->vbeln INTO TABLE @lt_vbrp.
          IF lt_vbrp IS INITIAL.
            me->mo_run_environment->append_log( iv_log_statement = |Could not find any document { ls_vbeln->vbeln }.| ).
            ev_execution_status = abap_false.
            CONTINUE.
          ENDIF.
        ENDIF.

        LOOP AT lt_vbap REFERENCE INTO DATA(lr_vbap).
          APPEND VALUE #( item_id = lr_vbap->posnr quantity = lr_vbap->kwmeng ) TO ls_load_parameter-ref_item_list.
        ENDLOOP.

        LOOP AT lt_vbrp REFERENCE INTO DATA(lr_vbrp).
          APPEND VALUE #( item_id = lr_vbrp->posnr  ) TO ls_load_parameter-ref_item_list.
        ENDLOOP.

        ls_load_parameter-type_code = ls_testdata-document_type.
        ls_load_parameter-ref_document_id = ls_vbeln->vbeln.

        TRY.
            CALL METHOD cl_goal_api=>so_instance->create
              EXPORTING
                iv_bo_id          = if_goal_sdoc=>co_bo_id-creditmemorequest
                is_load_parameter = ls_load_parameter
              RECEIVING
                ro_access         = lo_access.
          CATCH cx_goal_exc INTO lx_goal_exc.
            me->mo_run_environment->append_log( iv_log_statement = lx_goal_exc->get_text( ) ).
            ev_execution_status = abap_false.
            lv_error_occured = abap_true.
            "lv_text_exc = lx_goal_exc->get_text( ).
            "MESSAGE lv_text_exc TYPE 'I'.
            EXIT.
        ENDTRY.

***************************************************************************
* read header data
        CALL METHOD lo_access->get_entity
          EXPORTING
            iv_entity_id   = if_goal_sdoc_head=>co_entity_id
          IMPORTING
            es_entity_data = ls_head_data.
* read item data
        CALL METHOD lo_access->get_entity_set
          EXPORTING
            iv_entity_id      = if_goal_sdoc_item=>co_entity_id
            iv_handle_parent  = ls_head_data-handle
          IMPORTING
            et_entity_data    = lt_item_data
            et_field_property = lt_field_property.
***************************************************************************
        lo_access->save( IMPORTING ev_bo_key = lv_cmr_vbeln ).

        IF lv_cmr_vbeln IS NOT INITIAL.
          me->mo_run_environment->append_log( iv_log_statement = |Created CMR with ID: { lv_cmr_vbeln }.|  ).
          APPEND lv_cmr_vbeln TO ev_document_id.
          lv_error_occured = abap_false.
        ELSE.
          me->mo_run_environment->append_log( iv_log_statement = |Could not create CMR.| ).
          lv_error_occured = abap_true.
          RETURN.
        ENDIF.
      ENDLOOP.
      IF lv_error_occured EQ abap_true.
        ev_execution_status = abap_false.
      ELSE.
        ev_execution_status = abap_true.
      ENDIF.
      cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
    ENDIF.

    WAIT UP TO 10 SECONDS.

    COMMIT WORK AND WAIT.

    MOVE lv_cmr_vbeln TO lv_ptf_key.

    DATA: ls_header_inx   TYPE bapisdh1x,
          ls_header_in    TYPE bapisdh1,
          lv_billing_date TYPE fkdat,
          lt_return	      TYPE cl_ptf_util=>gt_ptf_return_tab.

    ls_header_inx-updateflag  = 'U'.
    ls_header_inx-bill_block = 'X'.
    ls_header_in-bill_block  = ' '.
    ls_header_inx-ord_reason = 'X'.
    ls_header_in-ord_reason = '105'.

    "Adapt billing date
    IF ls_testdata-delta_billing_date IS NOT INITIAL.
      lv_billing_date = sy-datum + ls_testdata-delta_billing_date.
      ls_header_inx-bill_date = 'X'.
      ls_header_in-bill_date = lv_billing_date.
    ENDIF.

    CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
      EXPORTING
        salesdocument    = lv_cmr_vbeln    " Order Number
        order_header_in  = ls_header_in
        order_header_inx = ls_header_inx  " Sales Order Check List
      TABLES
        return           = lt_return.  " Return Code

    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ls_return>).
      me->mo_run_environment->append_log( iv_log_statement = |{ <ls_return>-message }| ).
    ENDLOOP.

    WAIT UP TO 10 SECONDS.

    COMMIT WORK AND WAIT.

    ev_execution_status = abap_true.
  ENDMETHOD.


  METHOD delete.
  ENDMETHOD.


  METHOD execute_action.
    DATA(lv_step_data) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).

    CASE lv_step_data-action.
      WHEN c_remove_billing_block.
        LOOP AT lv_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step_v2>).
          DATA(lt_ptf_keys_v2) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step_v2> ).
          ev_execution_status = abap_true.
          LOOP AT lt_ptf_keys_v2 ASSIGNING FIELD-SYMBOL(<lv_ptf_key_v2>).
            DATA(lv_remove_suc) = me->remove_billing_block( iv_order_number = <lv_ptf_key_v2>-vbeln ).
            IF lv_remove_suc EQ abap_false.
              ev_execution_status = abap_false.
            ELSE.
              APPEND <lv_ptf_key_v2>-vbeln TO ev_document_id.
            ENDIF.
          ENDLOOP.
        ENDLOOP.
        RETURN.
      WHEN c_set_order_reason.
        me->set_order_reason(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_create_with_ref.
        me->create_with_reference(
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
    DATA(lv_step_data) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).

    CASE lv_step_data-action.
      WHEN c_check_ext_fields.
        me->check_ext_fields(
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


  METHOD prepare_testdata_create.
    DATA: ls_order_partners TYPE bapiparnr,
          ls_order_items    TYPE bapisditm,
          ls_schedules      TYPE bapischdl.

    ls_order_header_in-doc_type = ls_testdata-document_type.
    ls_order_header_in-sales_org = ls_testdata-sales_organization.
    ls_order_header_in-distr_chan = ls_testdata-distribution_channel.
    ls_order_header_in-division = ls_testdata-division.
    ls_order_header_in-ord_reason = ls_testdata-order_reason.
    ls_order_header_in-bill_block = ls_testdata-billing_block.

    IF ls_testdata-customer_id IS INITIAL.
      LOOP AT ls_testdata-order_partners ASSIGNING FIELD-SYMBOL(<ls_partner>).
        ls_order_partners-partn_role = <ls_partner>-partn_role.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = <ls_partner>-partn_numb
          IMPORTING
            output = ls_order_partners-partn_numb.

        APPEND  ls_order_partners TO  lt_order_partners.
      ENDLOOP.
    ELSE.
      ls_order_partners-partn_role = 'AG'.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = ls_testdata-customer_id " C field
        IMPORTING
          output = ls_order_partners-partn_numb.

      APPEND  ls_order_partners TO  lt_order_partners.
    ENDIF.

    LOOP AT ls_testdata-item_list ASSIGNING FIELD-SYMBOL(<ls_order_item_list>).
      ls_order_items-itm_number = <ls_order_item_list>-posnr.
      ls_order_items-material =  <ls_order_item_list>-material_id.
      ls_order_items-target_qty = <ls_order_item_list>-quantity.
      ls_order_items-bill_date  = <ls_order_item_list>-fkdat.
      ls_order_items-plant =  <ls_order_item_list>-werks.
      APPEND ls_order_items TO lt_order_items.

      ls_schedules-itm_number = <ls_order_item_list>-posnr.
      ls_schedules-req_qty    = <ls_order_item_list>-quantity.
      ls_schedules-req_date    = sy-datum.
      APPEND ls_schedules TO lt_schedules.
    ENDLOOP.
  ENDMETHOD.


  METHOD remove_billing_block.
    DATA: ls_header_inx TYPE bapisdh1x,
          ls_header_in  TYPE bapisdh1,
          lt_return	    TYPE cl_ptf_util=>gt_ptf_return_tab.

    ls_header_inx-updateflag  = 'U'.
    ls_header_inx-bill_block = 'X'.
    ls_header_in-bill_block  = ' '.

    DATA: lv_vbeln TYPE vbeln.
    MOVE iv_order_number TO lv_vbeln.

    CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
      EXPORTING
        salesdocument    = lv_vbeln    " Order Number
        order_header_in  = ls_header_in
        order_header_inx = ls_header_inx  " Sales Order Check List
      TABLES
        return           = lt_return.  " Return Code

    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ls_return>).
      me->mo_run_environment->append_log( iv_log_statement = |{ <ls_return>-message }| ).
    ENDLOOP.

    WAIT UP TO 5 SECONDS.

    COMMIT WORK AND WAIT.

    ev_test_success = abap_true.

  ENDMETHOD.


  METHOD set_order_reason.
    DATA: test_data        TYPE ty_order_reason,
          ls_header_inx    TYPE bapisdh1x,
          ls_header_in     TYPE bapisdh1,
          lt_return	       TYPE cl_ptf_util=>gt_ptf_return_tab,
          orders_to_update TYPE cl_ptf_util=>ty_vbeln_tab,
          vbeln            TYPE bapivbeln-vbeln.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = test_data
    ).

    IF test_data-order_reason IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Please define an order reason.| ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(orders) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      APPEND LINES OF orders TO orders_to_update.
    ENDLOOP.

    IF orders_to_update IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No orders to update.| ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.

    ls_header_inx-updateflag  = 'U'.
    ls_header_inx-ord_reason = 'X'.
    ls_header_in-ord_reason = test_data-order_reason.

    ev_execution_status = abap_true.
    LOOP AT orders_to_update ASSIGNING FIELD-SYMBOL(<order_to_update>).

      MOVE <order_to_update>-vbeln to vbeln.

      CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
        EXPORTING
          salesdocument    = vbeln    " Order Number
          order_header_in  = ls_header_in
          order_header_inx = ls_header_inx  " Sales Order Check List
        TABLES
          return           = lt_return.  " Return Code

      LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ls_return>).
        IF <ls_return>-type = 'E'.
          ev_execution_status = abap_false.
        ENDIF.
        me->mo_run_environment->append_log( iv_log_statement = |{ <ls_return>-message }| ).
      ENDLOOP.

      WAIT UP TO 5 SECONDS.
      COMMIT WORK AND WAIT.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
