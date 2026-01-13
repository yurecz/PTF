CLASS cl_ptf_bo_perf DEFINITION
  PUBLIC
  INHERITING FROM cl_ptf_bo
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_gs_create_n_sales_orders,
        number       TYPE i,
        variant_name TYPE string,
      END OF ty_gs_create_n_sales_orders,

      BEGIN OF ty_gs_i_ptf_dmr_cr_n_pos_td,
        document_type        TYPE auart,
        sales_organization   TYPE vkorg,
        distribution_channel TYPE vtweg,
        division             TYPE spart,
        customer_id          TYPE kunnr,
        order_reason         TYPE augru,
        billing_block        TYPE faksk,
        item_list            TYPE cl_ptf_sd_util=>ty_gt_item_list_td,
        number_of_positions  TYPE i,
        condition            TYPE cl_ptf_sd_util=>lty_sales_conditions_in,
        order_partners       TYPE cl_ptf_sd_util=>ty_order_partners,
        ext_fields_item      TYPE cl_ptf_sd_util=>ty_gt_ext_field_td,
      END OF ty_gs_i_ptf_dmr_cr_n_pos_td .

    METHODS create REDEFINITION .
    METHODS change REDEFINITION .
    METHODS delete REDEFINITION .
    METHODS check REDEFINITION .
    METHODS execute_action REDEFINITION .
    METHODS execute_check REDEFINITION .
    METHODS check_existence REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS: c_create_n_invoicable_dmr TYPE string VALUE 'CREATE_N_INVOICABLE_DMR'.
    CONSTANTS: c_cr_dmr_with_n_pos TYPE string VALUE 'CR_DMR_WITH_N_POS'.

    METHODS check_existence_dmr
      IMPORTING
        !iv_id           TYPE ptfkey
      RETURNING
        VALUE(rv_exists) TYPE abap_bool.

    METHODS prep_testdata_n_pos
      IMPORTING
        !ls_testdata        TYPE ty_gs_i_ptf_dmr_cr_n_pos_td
      EXPORTING
        !ls_order_header_in TYPE bapisdhd1
        !lt_order_partners  TYPE cl_ptf_bo_dmr=>ty_gt_order_partners
        !lt_order_items     TYPE cl_ptf_bo_dmr=>ty_gt_order_items
        !lt_schedules       TYPE cl_ptf_bo_dmr=>ty_gt_schedules
        !lt_condition       TYPE cl_ptf_sd_util=>lty_sales_conditions_in
        !lt_sales_text      TYPE cl_ptf_bo_dmr=>ty_bapisdtext .

    METHODS prepare_testdata_create
      IMPORTING
        !ls_testdata        TYPE cl_ptf_bo_dmr=>ty_gs_i_ptf_dmr_cr_td
      EXPORTING
        !ls_order_header_in TYPE bapisdhd1
        !lt_order_partners  TYPE cl_ptf_bo_dmr=>ty_gt_order_partners
        !lt_order_items     TYPE cl_ptf_bo_dmr=>ty_gt_order_items
        !lt_schedules       TYPE cl_ptf_bo_dmr=>ty_gt_schedules
        !lt_condition       TYPE cl_ptf_sd_util=>lty_sales_conditions_in
        !lt_sales_text      TYPE cl_ptf_bo_dmr=>ty_bapisdtext .
    METHODS remove_billing_block
      IMPORTING
        !iv_order_number       TYPE ptfkey
      RETURNING
        VALUE(ev_test_success) TYPE abap_bool .
    METHODS create_n_invoicable_dmr
      IMPORTING
        !step_data           TYPE cl_ptf_util=>gt_ptf_step                                            "Parameter for better performance
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .
    METHODS cr_dmr_with_n_pos
      IMPORTING
        !step_data           TYPE cl_ptf_util=>gt_ptf_step                                            "Parameter for better performance
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .
    METHODS create_one_dmr
      IMPORTING
        !step_data           TYPE cl_ptf_util=>gt_ptf_step                                            "Parameter for better performance
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .
ENDCLASS.



CLASS CL_PTF_BO_PERF IMPLEMENTATION.


  METHOD change.
  ENDMETHOD.


  METHOD check.
  ENDMETHOD.


  METHOD check_existence.
    me->mo_run_environment->append_log( iv_log_statement = |Do not use the general check_existence Method for this BO.| ).
  ENDMETHOD.


  METHOD check_existence_dmr.
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


  METHOD create.
  ENDMETHOD.


  METHOD create_n_invoicable_dmr.

    DATA: ls_testdata    TYPE ty_gs_create_n_sales_orders,
          fake_step_data TYPE cl_ptf_util=>gt_ptf_step.


    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

    fake_step_data-bus_obj = 'DMR'.
    fake_step_data-action = 'CREATE'.
    fake_step_data-step_number = step_data-step_number.
    fake_step_data-variant = ls_testdata-variant_name.

    DO ls_testdata-number TIMES.
      me->create_one_dmr(
        EXPORTING
          step_data           = fake_step_data
          iv_step_number      = step_data-step_number
        IMPORTING
          ev_document_id      = ev_document_id
          ev_execution_status = ev_execution_status
          ev_check_status     = ev_check_status
      ).
    ENDDO.

  ENDMETHOD.


  METHOD create_one_dmr.
    DATA: ls_testdata            TYPE cl_ptf_bo_dmr=>ty_gs_i_ptf_dmr_cr_td,
          ls_order_header_in     TYPE bapisdhd1,
          lt_order_partners      TYPE TABLE OF bapiparnr,
          lt_order_items         TYPE TABLE OF bapisditm,
          lt_schedules           TYPE TABLE OF bapischdl,
          ls_return              TYPE bapiret2,
          lt_return              TYPE TABLE OF bapiret2,
          lv_vbeln               TYPE vbeln,
          lt_sales_conditions_in TYPE TABLE OF bapicond.

    DATA: ls_order_header_in_x           TYPE bapisdhd1x,
          lt_extensionex                 TYPE TABLE OF bapiparex,
          ls_extensibility_fields_header TYPE REF TO bape_sdsalesdoc,
          lt_order_items_x               TYPE TABLE OF bapisditmx,
          ls_order_item_x                TYPE bapisditmx,
          lo_bapi_mapping                TYPE REF TO if_cfd_bapi_mapping,
          lt_extensibility_fields_item   TYPE TABLE OF bape_sdsalesdocitem,
          ls_extensibility_fields_item   TYPE bape_sdsalesdocitem,
          lt_bapiparex                   TYPE bapiparextab,
          ls_i_salesitemproposalitemtp   TYPE i_salesitemproposalitemtp,
          ls_prpsl_item                  TYPE bapisditm,
          lv_next_itm_number             TYPE i,
          ls_ext_field                   TYPE string,
          ls_tvak                        TYPE tvak,
          lv_key                         TYPE i,
          lv_key_as_string               TYPE string,
          lv_key_add                     TYPE i,
          lr_header_bapi_ext             TYPE REF TO bape_sdsalesdoc,
          lr_item_bapi_ext               TYPE REF TO bape_sdsalesdoc,
          lt_sales_text                  TYPE TABLE OF bapisdtext.

    FIELD-SYMBOLS: <gfs_field>          TYPE any,
                   <ex_field_structure> TYPE any.

*****************************************************************************
* 1 Step: get tdcv
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).
*****************************************************************************
* 2 Step: check wether the Item-number if filled;

    cl_ptf_util=>ensure_posnr_filled(
      EXPORTING
        iv_variant         = step_data-variant
        iv_run_environment = me->mo_run_environment
      CHANGING
        is_data            = ls_testdata
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
        lt_condition       = lt_sales_conditions_in
        lt_sales_text      = lt_sales_text  ).

    "ls_order_header_in_x-updateflag  = 'I'.
    ls_order_header_in_x-doc_type    = 'X'.
    ls_order_header_in_x-sales_org   = 'X'.
    ls_order_header_in_x-distr_chan  = 'X'.
    ls_order_header_in_x-division    = 'X'.
    ls_order_header_in_x-pp_search   = 'X'.
    ls_order_header_in_x-ct_valid_f  = 'X'.
    ls_order_header_in_x-ct_valid_t  = 'X'.

    CLEAR ls_order_item_x.
    "ls_order_item_x-updateflag = 'I'.
    ls_order_item_x-material   = 'X'.
    ls_order_item_x-target_qty = 'X'.
    ls_order_item_x-target_qu  = 'X'.

    SELECT SINGLE * FROM tvak INTO @ls_tvak
        WHERE auart = @ls_order_header_in-doc_type.

    IF ls_tvak IS NOT INITIAL.
      lv_key_add = ls_tvak-incpo.
    ELSE.
      lv_key_add = 10.
    ENDIF.
    lv_key = lv_key_add.

    "Fill Ext fields for items
    LOOP AT lt_order_items ASSIGNING FIELD-SYMBOL(<ls_order_item>).
      ls_order_item_x-itm_number = <ls_order_item>-itm_number.
      APPEND ls_order_item_x TO lt_order_items_x.

      CLEAR ls_extensibility_fields_item.
      lv_key_as_string = lv_key.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_key_as_string
        IMPORTING
          output = ls_extensibility_fields_item-key.
      IF ls_testdata-ext_fields_item IS NOT INITIAL.
        LOOP AT ls_testdata-ext_fields_item ASSIGNING FIELD-SYMBOL(<ls_ext_field>).
          IF <ls_ext_field>-type EQ 'P'.
            ls_ext_field = |ls_extensibility_fields_item-data-{ <ls_ext_field>-name }|.
            ASSIGN (ls_ext_field) TO <ex_field_structure>.
            IF <ex_field_structure> IS ASSIGNED.
              <ex_field_structure> = <ls_ext_field>-expected_input.
            ENDIF.

            ls_ext_field = |ls_extensibility_fields_item-datax-{ <ls_ext_field>-name }|.
            ASSIGN (ls_ext_field) TO <ex_field_structure>.
            IF <ex_field_structure> IS ASSIGNED.
              <ex_field_structure> = 'X'.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.

      APPEND ls_extensibility_fields_item TO lt_extensibility_fields_item.
      lv_key = lv_key + lv_key_add.
    ENDLOOP.

*   map the Extensibility fields into a suitable EXTENSIONIN format
    lo_bapi_mapping = cl_cfd_bapi_mapping=>get_instance( ).
    GET REFERENCE OF lt_extensibility_fields_item INTO DATA(lr_ci_item_bapi_tab).
    TRY.
        lo_bapi_mapping->map_to_bapiparex_multi(
         EXPORTING
          ir_source_table = lr_ci_item_bapi_tab
           CHANGING
             ct_bapiparex = lt_bapiparex ).
      CATCH cx_root.
    ENDTRY.

    CREATE DATA ls_extensibility_fields_header.
    LOOP AT ls_testdata-ext_fields_item ASSIGNING FIELD-SYMBOL(<ls_ext_field_header>).
      IF <ls_ext_field_header>-type = 'H'.
        ls_extensibility_fields_header->key = '0000000000000000'.
        ls_ext_field = |ls_extensibility_fields_header->data-{ <ls_ext_field_header>-name }|.
        ASSIGN (ls_ext_field) TO <ex_field_structure>.
        <ex_field_structure> = <ls_ext_field_header>-expected_input.

        ls_ext_field = |ls_extensibility_fields_header->datax-{ <ls_ext_field_header>-name }|.
        ASSIGN (ls_ext_field) TO <ex_field_structure>.
        <ex_field_structure> = 'X'.
      ENDIF.
    ENDLOOP.

    lo_bapi_mapping = cl_cfd_bapi_mapping=>get_instance( ).
    TRY.
        lo_bapi_mapping->map_to_bapiparex_single(
           EXPORTING
             ir_source_structure = ls_extensibility_fields_header
             CHANGING
               ct_bapiparex = lt_bapiparex ).
      CATCH cx_root.
    ENDTRY.

*****************************************************************************
* 4 Step: Create and commit Sales Order
    CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
      EXPORTING
        sales_header_in     = ls_order_header_in
        sales_header_inx    = ls_order_header_in_x
      IMPORTING
        salesdocument_ex    = lv_vbeln
      TABLES
        return              = lt_return
        extensionin         = lt_bapiparex
        extensionex         = lt_extensionex
        sales_items_in      = lt_order_items
        sales_items_inx     = lt_order_items_x
        sales_partners      = lt_order_partners
        sales_schedules_in  = lt_schedules
        sales_conditions_in = lt_sales_conditions_in
        sales_text          = lt_sales_text.

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ls_ret_mes>).
      me->mo_run_environment->append_log( iv_log_statement = |{ <ls_ret_mes>-message }| ).
    ENDLOOP.

*****************************************************************************
* 5 Step: Check Billing Block and Remove it
    IF ls_testdata-billing_block IS NOT INITIAL.
      DATA: lv_ptf_key TYPE ptfkey.
      MOVE lv_vbeln TO lv_ptf_key.
      me->remove_billing_block( iv_order_number = lv_ptf_key ).
    ENDIF.
*****************************************************************************
* 6 Step: Check whether Sales Order exists
    CLEAR lv_ptf_key.
    MOVE lv_vbeln TO lv_ptf_key.
    ev_execution_status = me->check_existence_dmr( iv_id = lv_ptf_key ).

    IF ev_execution_status EQ abap_true.
      APPEND lv_ptf_key TO ev_document_id.
    ENDIF.

  ENDMETHOD.


  METHOD cr_dmr_with_n_pos.
    DATA: ls_testdata            TYPE ty_gs_i_ptf_dmr_cr_n_pos_td,
          ls_order_header_in     TYPE bapisdhd1,
          lt_order_partners      TYPE TABLE OF bapiparnr,
          lt_order_items         TYPE TABLE OF bapisditm,
          lt_schedules           TYPE TABLE OF bapischdl,
          ls_return              TYPE bapiret2,
          lt_return              TYPE TABLE OF bapiret2,
          lv_vbeln               TYPE vbeln,
          lt_sales_conditions_in TYPE TABLE OF bapicond.

    DATA: ls_order_header_in_x           TYPE bapisdhd1x,
          lt_extensionex                 TYPE TABLE OF bapiparex,
          ls_extensibility_fields_header TYPE REF TO bape_sdsalesdoc,
          lt_order_items_x               TYPE TABLE OF bapisditmx,
          ls_order_item_x                TYPE bapisditmx,
          lo_bapi_mapping                TYPE REF TO if_cfd_bapi_mapping,
          lt_extensibility_fields_item   TYPE TABLE OF bape_sdsalesdocitem,
          ls_extensibility_fields_item   TYPE bape_sdsalesdocitem,
          lt_bapiparex                   TYPE bapiparextab,
          ls_i_salesitemproposalitemtp   TYPE i_salesitemproposalitemtp,
          ls_prpsl_item                  TYPE bapisditm,
          lv_next_itm_number             TYPE i,
          ls_ext_field                   TYPE string,
          ls_tvak                        TYPE tvak,
          lv_key                         TYPE i,
          lv_key_as_string               TYPE string,
          lv_key_add                     TYPE i,
          lr_header_bapi_ext             TYPE REF TO bape_sdsalesdoc,
          lr_item_bapi_ext               TYPE REF TO bape_sdsalesdoc,
          lt_sales_text                  TYPE TABLE OF bapisdtext.

    FIELD-SYMBOLS: <gfs_field>          TYPE any,
                   <ex_field_structure> TYPE any.

*****************************************************************************
* 1 Step: get tdcv
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

*****************************************************************************
* 3 Step: Prepare Testdata for 'SD_SALESDOCUMENT_CREATE'
    me->prep_testdata_n_pos(
      EXPORTING
        ls_testdata        = ls_testdata
      IMPORTING
        ls_order_header_in = ls_order_header_in
        lt_order_partners  = lt_order_partners
        lt_order_items     = lt_order_items
        lt_schedules       = lt_schedules
        lt_condition       = lt_sales_conditions_in
        lt_sales_text      = lt_sales_text  ).

    "ls_order_header_in_x-updateflag  = 'I'.
    ls_order_header_in_x-doc_type    = 'X'.
    ls_order_header_in_x-sales_org   = 'X'.
    ls_order_header_in_x-distr_chan  = 'X'.
    ls_order_header_in_x-division    = 'X'.
    ls_order_header_in_x-pp_search   = 'X'.
    ls_order_header_in_x-ct_valid_f  = 'X'.
    ls_order_header_in_x-ct_valid_t  = 'X'.

    CLEAR ls_order_item_x.
    "ls_order_item_x-updateflag = 'I'.
    ls_order_item_x-material   = 'X'.
    ls_order_item_x-target_qty = 'X'.
    ls_order_item_x-target_qu  = 'X'.

    SELECT SINGLE * FROM tvak INTO @ls_tvak
        WHERE auart = @ls_order_header_in-doc_type.

    IF ls_tvak IS NOT INITIAL.
      lv_key_add = ls_tvak-incpo.
    ELSE.
      lv_key_add = 10.
    ENDIF.
    lv_key = lv_key_add.

    "Fill Ext fields for items
    LOOP AT lt_order_items ASSIGNING FIELD-SYMBOL(<ls_order_item>).
      ls_order_item_x-itm_number = <ls_order_item>-itm_number.
      APPEND ls_order_item_x TO lt_order_items_x.

      CLEAR ls_extensibility_fields_item.
      lv_key_as_string = lv_key.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_key_as_string
        IMPORTING
          output = ls_extensibility_fields_item-key.
      IF ls_testdata-ext_fields_item IS NOT INITIAL.
        LOOP AT ls_testdata-ext_fields_item ASSIGNING FIELD-SYMBOL(<ls_ext_field>).
          IF <ls_ext_field>-type EQ 'P'.
            ls_ext_field = |ls_extensibility_fields_item-data-{ <ls_ext_field>-name }|.
            ASSIGN (ls_ext_field) TO <ex_field_structure>.
            IF <ex_field_structure> IS ASSIGNED.
              <ex_field_structure> = <ls_ext_field>-expected_input.
            ENDIF.

            ls_ext_field = |ls_extensibility_fields_item-datax-{ <ls_ext_field>-name }|.
            ASSIGN (ls_ext_field) TO <ex_field_structure>.
            IF <ex_field_structure> IS ASSIGNED.
              <ex_field_structure> = 'X'.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.

      APPEND ls_extensibility_fields_item TO lt_extensibility_fields_item.
      lv_key = lv_key + lv_key_add.
    ENDLOOP.

*   map the Extensibility fields into a suitable EXTENSIONIN format
    lo_bapi_mapping = cl_cfd_bapi_mapping=>get_instance( ).
    GET REFERENCE OF lt_extensibility_fields_item INTO DATA(lr_ci_item_bapi_tab).
    TRY.
        lo_bapi_mapping->map_to_bapiparex_multi(
         EXPORTING
          ir_source_table = lr_ci_item_bapi_tab
           CHANGING
             ct_bapiparex = lt_bapiparex ).
      CATCH cx_root.
    ENDTRY.

    CREATE DATA ls_extensibility_fields_header.
    LOOP AT ls_testdata-ext_fields_item ASSIGNING FIELD-SYMBOL(<ls_ext_field_header>).
      IF <ls_ext_field_header>-type = 'H'.
        ls_extensibility_fields_header->key = '0000000000000000'.
        ls_ext_field = |ls_extensibility_fields_header->data-{ <ls_ext_field_header>-name }|.
        ASSIGN (ls_ext_field) TO <ex_field_structure>.
        <ex_field_structure> = <ls_ext_field_header>-expected_input.

        ls_ext_field = |ls_extensibility_fields_header->datax-{ <ls_ext_field_header>-name }|.
        ASSIGN (ls_ext_field) TO <ex_field_structure>.
        <ex_field_structure> = 'X'.
      ENDIF.
    ENDLOOP.

    lo_bapi_mapping = cl_cfd_bapi_mapping=>get_instance( ).
    TRY.
        lo_bapi_mapping->map_to_bapiparex_single(
           EXPORTING
             ir_source_structure = ls_extensibility_fields_header
             CHANGING
               ct_bapiparex = lt_bapiparex ).
      CATCH cx_root.
    ENDTRY.

*****************************************************************************
* 4 Step: Create and commit Sales Order
    CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
      EXPORTING
        sales_header_in     = ls_order_header_in
        sales_header_inx    = ls_order_header_in_x
      IMPORTING
        salesdocument_ex    = lv_vbeln
      TABLES
        return              = lt_return
        extensionin         = lt_bapiparex
        extensionex         = lt_extensionex
        sales_items_in      = lt_order_items
        sales_items_inx     = lt_order_items_x
        sales_partners      = lt_order_partners
        sales_schedules_in  = lt_schedules
        sales_conditions_in = lt_sales_conditions_in
        sales_text          = lt_sales_text.

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<ls_ret_mes>).
      me->mo_run_environment->append_log( iv_log_statement = |{ <ls_ret_mes>-message }| ).
    ENDLOOP.

*****************************************************************************
* 5 Step: Check Billing Block and Remove it
    IF ls_testdata-billing_block IS NOT INITIAL.
      DATA: lv_ptf_key TYPE ptfkey.
      MOVE lv_vbeln TO lv_ptf_key.
      me->remove_billing_block( iv_order_number = lv_ptf_key ).
    ENDIF.
*****************************************************************************
* 6 Step: Check whether Sales Order exists
    CLEAR lv_ptf_key.
    MOVE lv_vbeln TO lv_ptf_key.
    ev_execution_status = me->check_existence_dmr( iv_id = lv_ptf_key ).

    IF ev_execution_status EQ abap_true.
      APPEND lv_ptf_key TO ev_document_id.
    ENDIF.
  ENDMETHOD.


  METHOD delete.
  ENDMETHOD.


  METHOD execute_action.
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).

    CASE ls_step_data-action.
      WHEN c_cr_dmr_with_n_pos.
        me->cr_dmr_with_n_pos(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_create_n_invoicable_dmr.
        me->create_n_invoicable_dmr(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN OTHERS.
        me->mo_run_environment->append_log( iv_log_statement =  |Could not find method { ls_step_data-action } for the BO { ls_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.
    ENDCASE.
  ENDMETHOD.


  METHOD execute_check.
  ENDMETHOD.


  METHOD prepare_testdata_create.
    DATA: ls_order_partners TYPE bapiparnr,
          ls_order_items    TYPE bapisditm,
          ls_schedules      TYPE bapischdl,
          ls_condition      TYPE bapicond.

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

        IF <ls_partner>-itm_number IS NOT INITIAL.
          ls_order_partners-itm_number = <ls_partner>-itm_number.
        ENDIF.

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
      APPEND ls_order_items TO lt_order_items.

      ls_schedules-itm_number = <ls_order_item_list>-posnr.
      ls_schedules-req_qty    = <ls_order_item_list>-quantity.
      ls_schedules-req_date    = sy-datum.
      APPEND ls_schedules TO lt_schedules.
    ENDLOOP.

    LOOP AT ls_testdata-condition ASSIGNING FIELD-SYMBOL(<ls_cond>).
      ls_condition-cond_type = <ls_cond>-cond_type .
      ls_condition-cond_value = <ls_cond>-cond_value.
      ls_condition-itm_number = <ls_cond>-itm_number.
      APPEND ls_condition TO lt_condition.
    ENDLOOP.

    MOVE ls_testdata-sales_text TO lt_sales_text.
  ENDMETHOD.


  METHOD prep_testdata_n_pos.
    DATA: ls_order_partners TYPE bapiparnr,
          ls_order_items    TYPE bapisditm,
          ls_schedules      TYPE bapischdl,
          ran_int           TYPE qf00-ran_int,
          ls_condition      TYPE bapicond,
          item_position     TYPE posnr_va.

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

        IF <ls_partner>-itm_number IS NOT INITIAL.
          ls_order_partners-itm_number = <ls_partner>-itm_number.
        ENDIF.

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

    DATA(number_of_defined_materials) = lines( ls_testdata-item_list ).

    item_position = 10.
    DO ls_testdata-number_of_positions TIMES.
      CALL FUNCTION 'QF05_RANDOM_INTEGER'
        EXPORTING
          ran_int_max   = 1
          ran_int_min   = number_of_defined_materials
        IMPORTING
          ran_int       = ran_int
        EXCEPTIONS
          invalid_input = 1
          OTHERS        = 2.


      READ TABLE ls_testdata-item_list INDEX ran_int INTO DATA(item).

      ls_order_items-itm_number = item_position.
      ls_order_items-material =  item-material_id.
      ls_order_items-target_qty = item-quantity.
      ls_order_items-bill_date  = item-fkdat.
      APPEND ls_order_items TO lt_order_items.

      ls_schedules-itm_number = item_position.
      ls_schedules-req_qty    = item-quantity.
      ls_schedules-req_date    = sy-datum.
      APPEND ls_schedules TO lt_schedules.

      IF ls_testdata-condition IS NOT INITIAL.
        READ TABLE ls_testdata-condition INDEX ran_int INTO DATA(condition).
        ls_condition-cond_type = condition-cond_type .
        ls_condition-cond_value = condition-cond_value.
        ls_condition-itm_number = item_position.
        APPEND ls_condition TO lt_condition.
      ENDIF.



      item_position = item_position + 10.
    ENDDO.

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
ENDCLASS.
