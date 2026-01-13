class CL_PTF_BO_OUTB_DELIVERY definition
  public
  inheriting from CL_PTF_BO
  final
  create public .

public section.

  types:
    likp_check_tab type standard table of sdbil_tst_likp_check with default key .
  types:
    likp_tab       type standard table of likp with default key .
  types:
    lips_check_tab type standard table of sdbil_tst_lips_check with default key .
  types:
* Structure for Check of Deliverys
    lips_tab       type standard table of lips with default key .
  types:
    prot_tab  type standard table of prott with non-unique key vbeln posnr .
  types:
    begin of ty_gs_ptf_batch_split_itm_td,
        delivery_item          type posnr,
        higher_level_item      type posnr,
        batch                  type charg_d,
        delivery_quantity      type lfimg,
        delivery_quantity_unit type vrkme,
      end of   ty_gs_ptf_batch_split_itm_td .
  types:
* Structure for Creation/Update of Deliveries
    begin of ty_gs_ptf_del_create_td,
        no_pick_and_pgi type abap_bool,
      end of ty_gs_ptf_del_create_td .
  types:
    begin of ty_gs_ptf_del_item_update_td,
        delivery_item          type posnr,
        delivery_quantity      type lfimg,
        delivery_quantity_unit type vrkme,
      end of ty_gs_ptf_del_item_update_td .
  types:
    begin of ty_gs_ptf_dl_check_td,
        likp       type likp_tab,
        lips       type lips_tab,
        likp_check type likp_check_tab,
        lips_check type lips_check_tab,
      end of ty_gs_ptf_dl_check_td .
  types:
    begin of ty_gs_ptf_dl_cr_partitial_td,
        shipping_point         type vstel,
        item_to_be_delivered   type posnr,
        delivery_quantity      type lfimg,
        delivery_quantity_unit type vrkme,
      end of ty_gs_ptf_dl_cr_partitial_td .
  types:
    begin of ty_gs_ptf_dl_goods_issue_td,
        delta_act_gi_date type int2,
      end of ty_gs_ptf_dl_goods_issue_td .
  types:
    begin of ty_gs_ptf_foreign_trade_fields,
        spe_herkl type herkl,
        spe_herkr type herkr,
        itm_comco type /sapsll/comco,
      end of ty_gs_ptf_foreign_trade_fields .
  types:
    ty_gt_ptf_batch_split_itm_td type standard table of ty_gs_ptf_batch_split_itm_td with empty key .
  types:
    ty_gt_ptf_del_item_update_td type standard table of ty_gs_ptf_del_item_update_td with default key .
  types:
    ty_gt_ptf_dl_cr_partitial_td type standard table of ty_gs_ptf_dl_cr_partitial_td with default key .

  methods TASK_FINISHED
    importing
      !P_TASK type CLIKE .
  class-methods KEEPING_LOCK_TASK
    importing
      !P_TASK type CHAR32 .

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

  types:
    gty_created_items type standard table of bapidlvitemcreated with default key .

  data MV_NUMBEROFCALLS type I .
  constants C_SET_FOREIGN_TRADE_FIELDS type STRING value 'SET_FOREIGN_TRADE_FIELDS' ##NO_TEXT.
  constants C_CHECK_COMPARE_DLV type STRING value 'CHECK_COMPARE_DLV' ##NO_TEXT.
  constants C_CHECK_COMPARE_SALESDOC type STRING value 'CHECK_COMPARE_SALESDOC' ##NO_TEXT.
  constants C_CREATE_WITHOUT_PICKING type STRING value 'CREATE_WITHOUT_PICKING' ##NO_TEXT.
  constants C_CREATE_WITH_PARTITIAL_ITEMS type STRING value 'CREATE_WITH_PARTITIAL_ITEMS' ##NO_TEXT.
  constants C_CREATE_WITH_REF_ITEMS type STRING value 'CREATE_WITH_REF_ITEMS' ##NO_TEXT.
  constants C_REVERSE_GOODS_MOVEMENT type STRING value 'REVERSE_GOODS_MOVEMENT' ##NO_TEXT.
  constants C_ADD_SERIAL_NUMBERS type STRING value 'ADD_SERIAL_NUMBERS' ##NO_TEXT.
  constants C_CREATE_SIMPLE type STRING value 'CREATE_SIMPLE' ##NO_TEXT.
  constants C_CREATE_FROM_STO type STRING value 'CREATE_FROM_STO' ##NO_TEXT.
  constants C_PICK_AND_PGI type STRING value 'PICK_AND_PGI' ##NO_TEXT.
  constants C_CREATE_WITH_SERIAL_NUMBERS type STRING value 'CREATE_WITH_SERIAL_NUMBERS' ##NO_TEXT.
  constants C_CONFIRM_ALL_ITEMS type STRING value 'CONFIRM_ALL_ITEMS' ##NO_TEXT.
  constants C_PICK_ALL_ITEMS type STRING value 'PICK_ALL_ITEMS' ##NO_TEXT.
  constants C_PGI type STRING value 'PGI' ##NO_TEXT.
  constants C_LOG_STATUS type STRING value 'LOG_STATUS' ##NO_TEXT.
  class-data MV_UNLOCKED_ASYNC type CHAR1 .
  class-data MV_LOCKED_ASYNC type CHAR1 .
  constants C_PICK_AND_PGI_CS type STRING value 'PICK_AND_PGI_CS' ##NO_TEXT.
  constants C_UPDATE_ITEMS type STRING value 'UPDATE_ITEM' ##NO_TEXT.
  constants C_UPDATE_MULTIPLE_ITEMS type STRING value 'UPDATE_ITEMS' ##NO_TEXT.
  constants C_DELETE type STRING value 'DELETE' ##NO_TEXT.
  constants C_ADD_BATCH_SPLIT_ITEMS type STRING value 'ADD_BATCH_SPLIT_ITEMS' ##NO_TEXT.
  constants C_CHANGE_SHIPTO_PARTY_ADDRESS type STRING value 'CHANGE_SHIPTO_PARTY_ADDRESS' ##NO_TEXT.
  constants C_DELETE_BATCH_SPLIT_ITEMS type STRING value 'DELETE_BATCH_SPLIT_ITEMS' ##NO_TEXT.
  constants C_CREATE_BATCH_SPLIT_ITEMS type STRING value 'CREATE_BATCH_SPLIT_ITEMS' ##NO_TEXT.

  methods PGI
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods SET_FOREIGN_TRADE_FIELDS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods PICK_ALL_ITEMS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CONFIRM_ALL_ITEMS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_WITH_SERIAL_NUMBERS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_SIMPLE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods PICK_AND_PGI
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods PICK_AND_PGI_CS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods DLV
    importing
      !IV_WITH_PICKING type ABAP_BOOL
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods DLV_PARTITIAL
    importing
      !IV_TEST_DATA type TY_GS_PTF_DL_CR_PARTITIAL_TD
      !IV_WITH_PICKING type ABAP_BOOL
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods PGI_PICKING
    importing
      !IT_CREATED_ITEMS type GTY_CREATED_ITEMS
      !IV_WITH_PICKING type ABAP_BOOL
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL
    returning
      value(RT_DELIVERY_ITEMS) type TT_VBPOK .
  methods CHECK_COMPARE_DLV
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ADD_SERIAL_NUMBERS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods REVERSE_GOODS_MOVEMENT
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP                                                        "Parameter for better performance
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods UNLOCK
    importing
      !IS_D_STEP type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods LOCK
    importing
      !IS_D_STEP type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods LOG_STATUS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods DELETE_DELIVERY_DOCUMENT
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods UPDATE_DELIVERY_ITEM
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_WITH_REFERENCE_ITEMS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_FROM_STO
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods UPDATE_DELIVERY_ITEMS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ADD_BATCH_SPLIT_ITEMS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods DELETE_BATCH_SPLIT_ITEMS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CREATE_BATCH_SPLIT_ITEMS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods REMOVE_BATCH_SPLIT_ITEMS
    importing
      !IV_DELIVERY_NUMBER type VBELN
      !IT_TESTDATA type TY_GT_PTF_BATCH_SPLIT_ITM_TD
      !IT_LIPS type TAB_LIPSVB .
  methods HANDLE_TRANSFER_OF_CONTROL
    importing
      !IS_DELIVERY_HEADER type LIKP
    changing
      !CS_HEADER_DATA type VBKOK .
  methods RESERVE_ACTION_1
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods RESERVE_ACTION_2
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods RESERVE_ACTION_3
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHANGE_SHIPTO_PARTY_ADDRESS
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_COMPARE_SALESDOC
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods PRINT_ITEMS_VBAP_LIPS
    importing
      !IV_SLS_ID type VBELN
      !IV_DLV_ID type VBELN .
ENDCLASS.



CLASS CL_PTF_BO_OUTB_DELIVERY IMPLEMENTATION.


  method add_batch_split_items.

    data lt_testdata             type ty_gt_ptf_batch_split_itm_td.
    data lt_vbeln                type table of vbeln.
    data lv_delivery_number      type vbeln.
    data lv_higher_level_item_no type posnr.
    data ls_vbpok                type vbpok.
    data ls_vbkok                type vbkok.
    data ls_higher_level_vbpok   type vbpok.
    data lt_vbpok                type standard table of vbpok.
    data ls_quantities           type shp_set_of_quantity.
    data lv_any_error            type xfeld.
    data lt_messages             type standard table of prott.


    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = step_data
      importing
        es_testdata  = lt_testdata ).

    data(ls_step_data) = mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_vbeln.
    endloop.

    ev_execution_status = abap_true.

    loop at lt_vbeln into lv_delivery_number.
      clear lt_vbpok.

      cl_le_api_dlv_upd_transact=>get( )->read_delivery(
        exporting
          iv_vbeln = lv_delivery_number
        importing
          et_xlips = data(lt_xlips)
          et_xvbfa = data(lt_xvbfa) ).

      if lt_xlips is not initial.
        " make sure already existing batch-split items are deleted
        remove_batch_split_items(
          exporting
            iv_delivery_number = lv_delivery_number
            it_testdata        = lt_testdata
            it_lips            = lt_xlips ).

      endif.

      ls_higher_level_vbpok-vbeln_vl = lv_delivery_number.
      ls_higher_level_vbpok-lianp    = abap_false.
      ls_higher_level_vbpok-taqui    = abap_false.
      ls_higher_level_vbpok-lfimg    = 0.

      loop at lt_testdata into data(ls_testdata).
        clear ls_vbpok.

        " check whether higher-level item exists
        if line_exists( lt_xlips[ vbeln = lv_delivery_number posnr = ls_testdata-higher_level_item ] ).
          data(xlips) = lt_xlips[ vbeln = lv_delivery_number posnr = ls_testdata-higher_level_item ].
        else.
          mo_run_environment->append_log( iv_log_statement = |Higher-level item { ls_testdata-higher_level_item } is missing in deliver { lv_delivery_number }| ).
          ev_execution_status = abap_false.
          continue.
        endif.

        if ls_testdata-delivery_item <= 900000.
          mo_run_environment->append_log( iv_log_statement = |Batch-split item number must be higher than 900000| ).
          ev_execution_status = abap_false.
          continue.
        endif.

        if ls_testdata-batch is initial.
          mo_run_environment->append_log( iv_log_statement = |Batch is not specified for delivery item { ls_testdata-delivery_item }| ).
          ev_execution_status = abap_false.
          continue.
        endif.

        if ls_testdata-delivery_quantity_unit is not initial.
          ls_quantities-lfimg = ls_testdata-delivery_quantity.
          ls_quantities-akmng = 'A'.
          ls_quantities-vrkme = ls_testdata-delivery_quantity_unit.
          ls_quantities-meins = xlips-meins.

          call function 'SHP_QUANTITY_SET_WITH_UOM'
            exporting
              if_matnr                  = xlips-matnr
              if_charg                  = ls_testdata-batch
              if_werks                  = xlips-werks
            changing
              cs_soq                    = ls_quantities
            exceptions
              error_from_mat_conversion = 1
              conversion_overflow       = 2
              essential_data_missing    = 3
              error                     = 4
              others                    = 5.

          ls_vbpok-umvkz = ls_quantities-umvkz.
          ls_vbpok-umvkn = ls_quantities-umvkn.
          ls_vbpok-akmng = 'B'.
          ls_vbpok-lgmng = ls_quantities-lgmng.
          ls_vbpok-meins = ls_quantities-meins.
          ls_vbpok-lfimg = ls_quantities-lfimg.
          ls_vbpok-vrkme = ls_quantities-vrkme.

        else.
          mo_run_environment->append_log( iv_log_statement = |Delivery Quantity Unit is missing for item { ls_testdata-delivery_item }| ).
          ev_execution_status = abap_false.
        endif.

        ls_vbpok-vbeln_vl  = lv_delivery_number.
        ls_vbpok-posnr_vl  = ls_testdata-higher_level_item.
        ls_vbpok-lianp     = abap_true.
        ls_vbpok-taqui     = abap_false.
        ls_vbpok-wms_rfpos = ls_testdata-delivery_item.
        ls_vbpok-wms_rfbel = lv_delivery_number.
        ls_vbpok-charg     = ls_testdata-batch.

        if lv_higher_level_item_no <> ls_testdata-higher_level_item.
          " make sure higher-level item will not contain a batch
          ls_higher_level_vbpok-posnr_vl = ls_testdata-higher_level_item.
          insert ls_higher_level_vbpok into table lt_vbpok.
          lv_higher_level_item_no = ls_testdata-higher_level_item.
        endif.

        insert ls_vbpok into table lt_vbpok.
      endloop.  " lt_testdata


      if lt_vbpok is not initial.
        " update delivery using function module WS_DELIVERY_UPDATE_2
        ls_vbkok-vbeln_vl = lv_delivery_number.
        ls_vbkok-vbtyp_vl = if_sd_doc_category=>delivery.

        call function 'WS_DELIVERY_UPDATE_2'
          exporting
            vbkok_wa     = ls_vbkok
            delivery     = lv_delivery_number
          importing
            ef_error_any = lv_any_error
          tables
            vbpok_tab    = lt_vbpok
            prot         = lt_messages.

        if lv_any_error = abap_true.
          loop at lt_messages assigning field-symbol(<prot>).
            message id <prot>-msgid type <prot>-msgty number <prot>-msgno with <prot>-msgv1 <prot>-msgv2 <prot>-msgv3 <prot>-msgv4 into data(message).
            mo_run_environment->append_log(
            iv_log_statement = |The following error occured: msgid: { <prot>-msgid } msgno { <prot>-msgno } msgty { <prot>-msgty } msgv1 {
                                <prot>-msgv1 } msgv2 { <prot>-msgv2 } msgv3 { <prot>-msgv3 } msgv4 { <prot>-msgv4 }| ).
            mo_run_environment->append_log( iv_log_statement = |{ message }| ).
          endloop.

          ev_execution_status = abap_false.
        else.
          " commit changes
          cl_ptf_util=>do_commitment( io_run_environment = mo_run_environment ).
        endif.
      endif.  " lt_vbpok
    endloop.  " lt_vbeln

    if lv_delivery_number is not initial.
      append lv_delivery_number to ev_document_id.
    endif.

  endmethod.


  method add_serial_numbers.
    data: deliveries            type table of vbeln,
          serial_number_updates type shp_sernr_update_t,
          serial_number_update  type shp_sernr_update_s,
          header_data           type vbkok,
          serial_numbers        type table of risernr,
          numbers_of_ser_num    type i.
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    loop at ls_step_data-reference_step assigning field-symbol(<lv_prestepnumbr>).
      data(ls_predecessor) = me->mo_run_environment->get_step_data( iv_step_number = <lv_prestepnumbr> ).
      if ls_predecessor-document_id  is not initial.
        loop at ls_predecessor-document_id into data(ls_vbeln).
          append ls_vbeln-vbeln to deliveries.
        endloop.
      endif.
    endloop.

    loop at deliveries assigning field-symbol(<delivery>).
      select posnr, matnr, lfimg from lips where vbeln = @<delivery> into table @data(delivery_items).

      loop at delivery_items assigning field-symbol(<delivery_item>).
        select single * from mase where matnr = @<delivery_item>-matnr into @data(mase_entry).

        serial_number_update-rfbel = <delivery>.

        serial_number_update-rfpos = <delivery_item>-posnr.

        numbers_of_ser_num = <delivery_item>-lfimg.

        call function 'READ_MASE'
          exporting
            anzahl_neu  = numbers_of_ser_num
            material_nr = <delivery_item>-matnr
          tables
            isernr      = serial_numbers.

        if lines( serial_numbers ) ne <delivery_item>-lfimg.
          me->mo_run_environment->append_log(
            iv_log_statement = |Could not retrieve all serial numbers for { <delivery_item>-matnr }. Expected { <delivery_item>-lfimg } but got { lines( serial_numbers ) }.|
          ).
          ev_execution_status = abap_false.
          return.
        endif.

        loop at serial_numbers assigning field-symbol(<serial_number>).
          serial_number_update-sernr = <serial_number>-sernr.
          append serial_number_update to serial_number_updates.
          append <serial_number> to ev_document_id.
          me->mo_run_environment->append_log( iv_log_statement = |Added serial number { <serial_number>-sernr } to item { <delivery_item>-posnr } of delivery { <delivery> }.| ).
        endloop.

      endloop.

      header_data-vbeln_vl = <delivery>.
      header_data-vbtyp_vl = if_sd_doc_category=>delivery.

      call function 'WS_DELIVERY_UPDATE_2'
        exporting
          vbkok_wa             = header_data
          synchron             = 'X'
          no_messages_update_1 = ' '
          commit               = 'X'
          delivery             = <delivery>
          it_sernr_update      = serial_number_updates.

      commit work and wait.

    endloop.
    ev_execution_status = abap_true.
  endmethod.


  method change.
  endmethod.


  method change_shipto_party_address.

    data ls_header type bapiobdlvhdrchg.
    data ls_header_control type bapiobdlvhdrctrlchg.
    data ls_header_partner type bapidlvpartnerchg.
    data lt_header_partner type standard table of bapidlvpartnerchg.
    data ls_partner_addr type bapidlvpartnaddrchg.
    data lt_partner_addr type standard table of bapidlvpartnaddrchg.
    data lt_return type bapiret2_t.

    data lv_delivery_id type vbeln_vl.
    data: ls_testdata  type sdpartner_address." same type as TDC parameter I_PTF_DLV_SHIPTO_PARTY_ADDRESS

    data: lt_vbeln type cl_ptf_util=>ty_vbeln_tab.
    loop at step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_vbeln.
    endloop.


    if lt_vbeln is initial.
      me->mo_run_environment->append_log( iv_log_statement = |No referenced documents exist.| ).
      ev_execution_status = abap_false.
      return.
    else.
      ev_execution_status = abap_true.
    endif.

    if step_data-variant is not initial.
      cl_ptf_util=>get_testdata(
        exporting
          is_step_data = step_data
        importing
          es_testdata  = ls_testdata
      ).
    endif.


    loop at lt_vbeln into lv_delivery_id.

      clear :  lt_header_partner, lt_partner_addr, lt_return, ls_header, ls_header_control, ls_header_partner, ls_partner_addr.

*"ls_header
      ls_header-deliv_numb = lv_delivery_id.
      ls_header_control-deliv_numb = lv_delivery_id .

*"ls_header_partner
      ls_header_partner-upd_mode_partn = 'U'.
      ls_header_partner-deliv_numb = lv_delivery_id.
      ls_header_partner-partn_role = 'WE'. "ship to party

      ls_header_partner-manual_addr = 'X'.

      select single adrnr from vbpa into @ls_header_partner-address_no where vbeln = @lv_delivery_id and posnr = 0 and parvw = 'WE'.

      select single kunnr from vbpa into @ls_header_partner-partner_no where vbeln = @lv_delivery_id and posnr = 0 and parvw = 'WE'.

*"ls_partner_addr
      ls_partner_addr-upd_mode_adr = 'U'. " create or update
      " move corresponding to populate with test data.
      move-corresponding ls_testdata to ls_partner_addr.
      "resolve the fields whicha are not covered by move corresponding
      if ls_testdata-city1 is not initial.
        ls_partner_addr-city = ls_testdata-city1.
      endif.
      if ls_testdata-post_code1 is not initial.
        ls_partner_addr-postl_cod1 = ls_testdata-post_code1.
      endif.
      if ls_testdata-name1 is not initial.
        ls_partner_addr-name = ls_testdata-name1.
      endif.
      if ls_testdata-name_co is not initial.
        ls_partner_addr-c_o_name = ls_testdata-name_co.
      endif.
      if ls_testdata-city2 is not initial.
        ls_partner_addr-district = ls_testdata-city2.
      endif.
      if ls_testdata-city_code is not initial.
        ls_partner_addr-city_no = ls_testdata-city_code.
      endif.
      if ls_testdata-cityp_code is not initial.
        ls_partner_addr-distrct_no = ls_testdata-cityp_code.
      endif.
      if ls_testdata-cityh_code is not initial.
        ls_partner_addr-homecityno = ls_testdata-cityh_code.
      endif.
      if ls_testdata-post_code2 is not initial.
        ls_partner_addr-postl_cod2 = ls_testdata-post_code2.
      endif.
      if ls_testdata-post_code3 is not initial.
        ls_partner_addr-postl_cod3 = ls_testdata-post_code3.
      endif.
      if ls_testdata-po_box_num is not initial.
        ls_partner_addr-po_w_o_no = ls_testdata-po_box_num.
      endif.
      if ls_testdata-po_box_loc is not initial.
        ls_partner_addr-po_box_cit = ls_testdata-po_box_loc.
      endif.
      if ls_testdata-city_code2 is not initial.
        ls_partner_addr-pboxcit_no = ls_testdata-city_code2.
      endif.
      if ls_testdata-po_box_cty is not initial.
        ls_partner_addr-pobox_ctry = ls_testdata-po_box_cty.
      endif.
      if ls_testdata-postalarea is not initial.
        ls_partner_addr-deliv_dis = ls_testdata-postalarea .
      endif.
      if ls_testdata-streetcode is not initial.
        ls_partner_addr-street_no = ls_testdata-streetcode .
      endif.
      if ls_testdata-streetabbr is not initial.
        ls_partner_addr-str_abbr = ls_testdata-streetabbr .
      endif.
      if ls_testdata-house_num1 is not initial.
        ls_partner_addr-house_no = ls_testdata-house_num1.
      endif.
      if ls_testdata-house_num2 is not initial.
        ls_partner_addr-house_no2 = ls_testdata-house_num2.
      endif.
      if ls_testdata-roomnumber is not initial.
        ls_partner_addr-room_no = ls_testdata-roomnumber .
      endif.
*      IF ls_testdata-address_id IS NOT INITIAL.
*        ls_partner_addr-addr_no = ls_testdata-address_id .
*      ENDIF.
      if ls_testdata-remark is not initial.
        ls_partner_addr-adr_notes = ls_testdata-remark .
      endif.
      if ls_testdata-deflt_comm is not initial.
        ls_partner_addr-comm_type = ls_testdata-deflt_comm .
      endif.
      " a cupple of fields from structure SDPARTNER_ADDRESS do not have corresponding in structure BAPIDLVPARTNADDRCHG.
      "DATE_FROM, DATE_TO, TITLE, NAME_TXT, HOUSE_NUM3, BUILDING, SORT_PHN, ADDRORIGIN, EXTENSION1,EXTENSION2, LANGU_CREA, PO_BOX_LOBBY, DELI_SERV_TYPE, DELI_SERV_NUMBER, COUNTY_CODE, COUNTY, TOWNSHIP_CODE , TOWNSHIP



      ls_partner_addr-addr_no = ls_header_partner-address_no.



******************************************

      append ls_partner_addr to lt_partner_addr.

      append ls_header_partner to lt_header_partner.
*
*
*
*
      call function 'BAPI_OUTB_DELIVERY_CHANGE'
        exporting
          header_data         = ls_header
          header_control      = ls_header_control
          delivery            = ls_header-deliv_numb
*         TECHN_CONTROL       =
*         HEADER_DATA_SPL     =
*         HEADER_CONTROL_SPL  =
*         SENDER_SYSTEM       =
*         CHANGE_DECENTRAL    =
        tables
          header_partner      = lt_header_partner
          header_partner_addr = lt_partner_addr
*         HEADER_DEADLINES    =
*         ITEM_DATA           =
*         ITEM_CONTROL        =
*         ITEM_SERIAL_NO      =
*         SUPPLIER_CONS_DATA  =
*         EXTENSION1          =
*         EXTENSION2          =
          return              = lt_return.
*   TOKENREFERENCE                =
*   ITEM_DATA_SPL                 =
*   COLLECTIVE_CHANGE_ITEMS       =
*   NEW_ITEM_DATA                 =
*   NEW_ITEM_DATA_SPL             =
*   NEW_ITEM_ORG                  =
*   ITEM_DATA_DOCU_BATCH          =
*   CWM_ITEM_DATA                 =
*   ITEM_STATUS_SPL               =
*   TEXT_HEADER                   =
*   TEXT_LINES                    =
*   HANDLING_UNIT_HEADER          =
*   HANDLING_UNIT_ITEM            =
*   HANDLING_UNIT_SERNO           =
      .

**COMMIT WORK AND WAIT.



      if lt_return is not initial.
        "WRITE: / lt_return[ 1 ]-message.
        loop at lt_return assigning field-symbol(<ls_msg>).
          data: text1 type char220.
          call function 'BAL_DSP_TXT_MSG_READ'
            exporting
*             I_LANGU        = SY-LANGU
              i_msgid        = <ls_msg>-id
              i_msgno        = <ls_msg>-number
              i_msgv1        = <ls_msg>-message_v1
              i_msgv2        = <ls_msg>-message_v2
              i_msgv3        = <ls_msg>-message_v3
              i_msgv4        = <ls_msg>-message_v4
            importing
              e_message_text = text1.
          me->mo_run_environment->append_log( iv_log_statement = |{ | Delivery: | }{ lv_delivery_id }| ).
          me->mo_run_environment->append_log( iv_log_statement = |{ <ls_msg>-type }{ | Message class | }{ <ls_msg>-id }{ | Message number | }{ <ls_msg>-number }{ <ls_msg>-message }| ).
          me->mo_run_environment->append_log( iv_log_statement = |{ text1 }| ).
        endloop.
        ev_execution_status = abap_false.
        return.
      else.
        ev_execution_status = abap_true.

      endif.

      data:
      ld_return   type bapiret2 .
      data(ld_wait) = 'X'.
      call function 'BAPI_TRANSACTION_COMMIT'
        exporting
          wait   = ld_wait
        importing
          return = ld_return.
      if sy-subrc eq 0.
        "All OK
      endif.

      data lv_ptf_key type ptfkey.
      move lv_delivery_id to lv_ptf_key.
*      ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).
      if  ev_execution_status eq abap_true .
        append lv_ptf_key to ev_document_id.
      else.
        append lv_ptf_key to ev_document_id.
        me->mo_run_environment->append_log( iv_log_statement = |Changing of the address failed.| ).
        return.
      endif.


    endloop.

    ev_execution_status = abap_true.

  endmethod.


  method check.
    data: ls_testdata        type ty_gs_ptf_dl_check_td,
          lv_prestepnumber   type line of cl_ptf_util=>gt_ptf_step-reference_step,
          ls_check_step_data type cl_ptf_util=>gt_ptf_step,
          lv_step_success    type abap_bool.

    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    if ls_step_data-variant is initial.
      me->mo_run_environment->append_log( iv_log_statement = |No TDC Variant given, OutbDelivery CHECK action can not be executed, script stopped.| ).
      return.
    endif.

    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = ls_step_data
      importing
        es_testdata  = ls_testdata
    ).
    if ls_testdata-likp_check is initial and ls_testdata-lips_check is initial.
      me->mo_run_environment->append_log( iv_log_statement = |TDC Variant { ls_step_data-variant } contains no check data.| ).
      return.
    endif.


    lv_step_success = abap_true.

*   Check if reference step number for checking object is filled and reference object exists, then compare
    loop at ls_step_data-reference_step into lv_prestepnumber.
      ls_check_step_data = me->mo_run_environment->get_step_data( iv_step_number = lv_prestepnumber ).
      if ls_check_step_data-document_id is initial.
        lv_step_success = abap_false.
        if lv_prestepnumber ne 0.
          me->mo_run_environment->append_log( iv_log_statement = |No documentID given from reference step { lv_prestepnumber }.| ).
        endif.
      else.

        if lines( ls_check_step_data-document_id ) eq 1 and ls_check_step_data-document_id[ 1 ] is initial.
          me->mo_run_environment->append_log( iv_log_statement = |No documentIDs to check for this action, only initial value. Step failed.| ).
          return.
        endif.
        append lines of ls_check_step_data-document_id to ev_document_id.

        "LIKP
        if ls_testdata-likp_check is not initial.
          cl_ptf_compare_dlv_tdc=>compare_likp_data(
            exporting
              is_testdata        = ls_testdata
              is_check_step_data = ls_check_step_data
              iv_run_environment = me->mo_run_environment
            receiving
              rv_is_equal        = ev_check_status
          ).
          if ev_check_status  eq abap_false.
            lv_step_success = abap_false.
          endif.
        endif.

        "LIPS
        if ls_testdata-lips_check is not initial.
          cl_ptf_compare_dlv_tdc=>compare_lips_data(
            exporting
              is_testdata        = ls_testdata
              is_check_step_data = ls_check_step_data
              iv_run_environment = me->mo_run_environment
            receiving
              rv_is_equal        = ev_check_status
          ).
          if ev_check_status eq abap_false.
            lv_step_success = abap_false.
          endif.
        endif.

      endif.

    endloop.

    if ev_document_id is initial.
      me->mo_run_environment->append_log( iv_log_statement = |No documentIDs to check for this action. Step failed.| ).
      return.
    endif.


    ev_check_status = lv_step_success.

    if ev_check_status eq abap_true.
      ev_execution_status = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |The values of the checked document(s) are correct.| ).
    else.
      ev_execution_status = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |Document(s) checked. The values of the checked document(s) are NOT correct.| ).
    endif.

  endmethod.


  method check_compare_dlv.
    data: lt_vbeln      type table of cl_ptf_util=>ty_vbeln,
          ls_vbeln      type cl_ptf_util=>ty_vbeln,
          ls_return     type bapiret2,
          lv_success    type abap_bool,
          lt_likp       type table of likp,
          lt_lips_1     type table of lips,
          lt_lips_2     type table of lips,
          ls_lips_1     type lips,
          ls_lips_2     type lips,
          lv_length     type i,
          lt_fieldinfo  type extdfiest,
          ls_fieldinfo  type line of extdfiest,
          msg_str1      type string,
          msg_str2      type string,
          lv_loop_count type i.

    field-symbols: <lv_likp_1> type any,
                   <lv_likp_2> type any,
                   <lv_lips_1> type any,
                   <lv_lips_2> type any.
*****************************************************************************
* 1 Step: Get Presteps
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_vbeln.
    endloop.
    move-corresponding lt_vbeln to ev_document_id.
    describe table lt_vbeln lines lv_length.
    if lv_length ne 2.
      ls_return-message = 'This test is only allowed with 2 Billing Docuemnts.'.
      ev_execution_status = abap_false.
      return.
    endif.
*****************************************************************************
* 2 LIKP
    types:
      begin of ty_vbeln_orig,
        vbeln type vbeln,
      end of ty_vbeln_orig.
    data: lt_vbeln_key type table of ty_vbeln_orig.
    move lt_vbeln to lt_vbeln_key.


    select * from likp into table lt_likp for all entries in lt_vbeln_key where vbeln = lt_vbeln_key-vbeln.
    describe table lt_vbeln lines lv_length.
    if lv_length ne 2.
      ls_return-message = 'Document not found at DB.'.
      ev_execution_status = abap_false.
      return.
    endif.
*****************************************************************************
* 3 get fieldinfo
    clear lt_fieldinfo.
    call function 'DD_INT_TABLINFO_GET'
      exporting
        typename       = 'LIKP'
      tables
        extdfies_tab   = lt_fieldinfo
      exceptions
        not_found      = 1
        internal_error = 2
        others         = 3.
    if sy-subrc <> 0.
      return.
    endif.
*****************************************************************************
* 4 Step: Check
    lv_success = abap_true.
    read table lt_likp into data(ls_likp_1) index 1.
    read table lt_likp into data(ls_likp_2) index lv_length.
    loop at lt_fieldinfo into ls_fieldinfo.
      if ls_fieldinfo-fieldname ne 'VBELN' and ls_fieldinfo-fieldname ne 'ERZET' and
         ls_fieldinfo-fieldname ne 'KNUMV' and ls_fieldinfo-fieldname ne 'HANDLE' and
         ls_fieldinfo-fieldname ne 'WAUHR' and ls_fieldinfo-fieldname ne 'KNUMP'  and
         ls_fieldinfo-fieldname ne 'SPE_WAUHR_IST' and
         ls_fieldinfo-fieldname ne 'CREATION_TS' and ls_fieldinfo-fieldname ne 'CHANGED_TS'.
        assign component ls_fieldinfo-fieldname of structure ls_likp_1 to <lv_likp_1>.
        assign component ls_fieldinfo-fieldname of structure ls_likp_2 to <lv_likp_2>.
        if  <lv_likp_1> ne  <lv_likp_2>.
          lv_success = abap_false.
          clear ls_return.
          msg_str1 = <lv_likp_1>.
          msg_str2 = <lv_likp_2>.
          concatenate 'The Value of the LIKP field ' ls_fieldinfo-fieldname 'is not as expected. The expected value is:' msg_str1
                      '. The stored value is:' msg_str2  into ls_return-message separated by space.
          me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
        endif.
      endif.
    endloop.
*****************************************************************************
* 5 Step: lips
    clear ls_vbeln.
    read table lt_vbeln into ls_vbeln index 1.
    select * from lips into table lt_lips_1 where vbeln = ls_vbeln-vbeln order by primary key.
    clear ls_vbeln.
    read table lt_vbeln into ls_vbeln index 2.
    select * from lips into table lt_lips_2 where vbeln = ls_vbeln-vbeln order by primary key.
    describe table lt_lips_1 lines data(lv_lips_l1).
    describe table lt_lips_2 lines data(lv_lips_l2).
    if lv_lips_l1 ne lv_lips_l2.
      ls_return-message = 'Quantity of Item are not equal.'.
      ev_execution_status = abap_false.
      return.
    endif.
*****************************************************************************
* 6 get fieldinfo
    clear lt_fieldinfo.
    call function 'DD_INT_TABLINFO_GET'
      exporting
        typename       = 'LIPS'
      tables
        extdfies_tab   = lt_fieldinfo
      exceptions
        not_found      = 1
        internal_error = 2
        others         = 3.
    if sy-subrc <> 0.
      return.
    endif.
*****************************************************************************
* 7 Step: Check
    lv_loop_count = 0.
    loop at lt_lips_1 into ls_lips_1.
      lv_loop_count = lv_loop_count + 1.
      read table lt_lips_2 into ls_lips_2 index lv_loop_count.
      loop at lt_fieldinfo into ls_fieldinfo.
        if ls_fieldinfo-fieldname ne 'VBELN' and ls_fieldinfo-fieldname ne 'ERZET' and
           ls_fieldinfo-fieldname ne 'VGBEL' and ls_fieldinfo-fieldname ne 'PAOBJNR' and
           ls_fieldinfo-fieldname ne 'HANDLE' and ls_fieldinfo-fieldname ne 'KNUMP' and
           ls_fieldinfo-fieldname ne 'CREATION_TS' and ls_fieldinfo-fieldname ne 'CHANGED_TS'.
          assign component ls_fieldinfo-fieldname of structure ls_lips_1 to <lv_lips_1>.
          assign component ls_fieldinfo-fieldname of structure ls_lips_2 to <lv_lips_2>.
          if <lv_lips_1> ne  <lv_lips_2>.
            lv_success  = abap_false.
            clear ls_return.
            msg_str1 = <lv_lips_1>.
            msg_str2 = <lv_lips_2>.
            concatenate 'The Value of the LIPS field ' ls_fieldinfo-fieldname 'is not as expected. The expected value is:' msg_str1
                        '. The stored value is:' msg_str2  into ls_return-message separated by space.
            me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
          endif.
        endif.
      endloop.
    endloop.
*****************************************************************************
    ev_execution_status = abap_true.
    ev_check_status = lv_success.
    if lv_success eq abap_true.
      ls_return-message = 'Check was succesful. Both document are similar.'.
      me->mo_run_environment->append_log( iv_log_statement = |{ ls_return-message }| ).
    endif.

  endmethod.


  method check_compare_salesdoc.

    "Method compares number of items, materialID, quantity unit, quantity between OutboundDelivery and a VBAK document. Based on order of POSNR.

    data ls_vbap type vbap.
    data ls_lips type lips.
    data lv_issue_found type abap_bool.

    ev_check_status = abap_false.
    ev_execution_status = abap_false.

    data(lt_ref_vbeln) = me->mo_run_environment->get_result_key_data( it_step_number = step_data-reference_step ).

    if lt_ref_vbeln is initial.
      me->mo_run_environment->append_log( iv_log_statement = |This check needs 2 documents. None is referenced.| ).
      return.
    endif.

    move-corresponding lt_ref_vbeln to ev_document_id." !!!!!

    describe table lt_ref_vbeln lines data(lv_length).
    if lv_length ne 2.
      me->mo_run_environment->append_log( iv_log_statement = |This check needs exactly 2 documents. Check failed.| ).
      return.
    endif.

    loop at lt_ref_vbeln into data(ls_vbeln_sls) where sbo_bo_type = 'SalesOrder' or sbo_bo_type = 'SalesSchedulingAgreement' or sbo_bo_type = 'SalesContract'.
      data(slsdoc_found) = abap_true.
      data lv_sls_id type vbeln.
      lv_sls_id = ls_vbeln_sls-document_id_char70.
      exit.
    endloop.

    loop at lt_ref_vbeln into data(ls_vbeln_dlv) where sbo_bo_type = 'OutboundDelivery'.
      data(dlv_found) = abap_true.
      data lv_dlv_id type vbeln.
      lv_dlv_id = ls_vbeln_dlv-document_id_char70.
      exit.
    endloop.

    if slsdoc_found is initial.
      me->mo_run_environment->append_log( iv_log_statement = |Did not recognize a SalesDocument among the referenced docs.| ).
    endif.
    if dlv_found is initial.
      me->mo_run_environment->append_log( iv_log_statement = |Did not recognize an OutbDelivery among the referenced docs.| ).
    endif.
    if slsdoc_found is initial or dlv_found is initial.
      return.
    endif.

    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    if ls_step_data-variant is not initial.
      me->mo_run_environment->append_log( iv_log_statement = |This check does not support TDC variants, { ls_step_data-variant } is ignored.| ).
    endif.


*   Retrieve data and compare selected item fields


    select single * from vbak into @data(ls_vbak) where vbeln = @lv_sls_id.
    if sy-subrc is not initial.
      me->mo_run_environment->append_log( iv_log_statement = |Document { lv_sls_id } from step { ls_vbeln_sls-step_number } not found in db table VBAK.| ).
      return.
    endif.
    select * from vbap into table @data(lt_vbap) where vbeln = @lv_sls_id order by posnr .
    assert sy-subrc is initial.

    select single * from likp into @data(ls_likp) where vbeln = @ls_vbeln_dlv-document_id_char70(10). "lv_dlv_id.
    if sy-subrc is not initial.
      me->mo_run_environment->append_log( iv_log_statement = |Document { lv_dlv_id } from step { ls_vbeln_dlv-step_number } not found in db table LIKP.| ).
    endif.
    select * from lips into table @data(lt_lips) where vbeln = @lv_dlv_id order by posnr .
    assert sy-subrc is initial.

    if lines( lt_vbap ) ne lines( lt_lips ).
      me->mo_run_environment->append_log( iv_log_statement = |Item list NOT identical: SalesDoc { lv_sls_id } has { lines( lt_vbap ) } items, Delivery { lv_dlv_id } has { lines( lt_lips ) } items.| ).
*      IF lines( lt_vbap ) GT lines( lt_lips ).
      print_items_vbap_lips(
        iv_sls_id = lv_sls_id
        iv_dlv_id = lv_dlv_id
      ).
*      ENDIF.
      return.
    endif.

    ev_execution_status = abap_true.

    loop at lt_vbap into ls_vbap.
      read table lt_lips index sy-tabix into ls_lips.
      assert sy-subrc is initial.

      me->mo_run_environment->append_log( iv_log_statement = |Comparing VBAP item { ls_vbap-posnr } and LIPS item { ls_lips-posnr }| ).

      if ls_vbap-matnr ne ls_lips-matnr.
        me->mo_run_environment->append_log( iv_log_statement = |VBAP-MATNR: { ls_vbap-matnr }, LIPS-MATNR: { ls_lips-matnr }| ).
        lv_issue_found = abap_true.
      endif.

      if ls_vbap-vrkme ne ls_lips-vrkme.
        me->mo_run_environment->append_log( iv_log_statement = |VBAP-VRKME: { ls_vbap-vrkme }, LIPS-VRKME: { ls_lips-vrkme }| ).
        lv_issue_found = abap_true.
      endif.

      if ls_vbap-kwmeng ne ls_lips-lfimg.
        "VBAP-KWMENG Cumulative Order Quantity in Sales Units
        "LIPS-LFIMG  Actual quantity delivered (in sales units)
        "(LIPS-LGMNG  Actual quantity delivered in stockkeeping units)
        me->mo_run_environment->append_log( iv_log_statement = |VBAP-KWMENG: { ls_vbap-kwmeng }, LIPS-LFIMG: { ls_lips-lfimg }| ).
        lv_issue_found = abap_true.
      endif.

    endloop.

    if lv_issue_found eq abap_false.
      "fully identical
      ev_check_status = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |No differences in the compared fields of all items.| ).
    else.
      "deviating
      me->mo_run_environment->append_log( iv_log_statement = |Item list NOT identical.| ).
      print_items_vbap_lips(
        iv_sls_id = lv_sls_id
        iv_dlv_id = lv_dlv_id
      ).
    endif.


  endmethod.


  method check_existence.
    data lv_vbeln type vbeln.
    rv_exists = abap_false.
    move iv_id to lv_vbeln.
    check lv_vbeln is not initial.

    select single * from likp where vbeln = @lv_vbeln into @data(ls_del).
    if sy-subrc <> 0.
      me->mo_run_environment->append_log( iv_log_statement = |Delivery { lv_vbeln } does not exist.| ).
      rv_exists = abap_false.
    else.
      rv_exists = abap_true.
    endif.
  endmethod.


  method confirm_all_items.

    types:
      begin of ty_s_vbfs,
        etenr type vbfs-etenr,
        mandt type vbfs-mandt,
        msgid type vbfs-msgid,
        msgno type symsgno,
        msgty type vbfs-msgty,
        msgv1 type vbfs-msgv1,
        msgv2 type vbfs-msgv2,
        msgv3 type vbfs-msgv3,
        msgv4 type vbfs-msgv4,
        posnr type vbfs-posnr,
        sammg type vbfs-sammg,
        smart type vbfs-smart,
        vbeln type vbfs-vbeln,
        zaehl type vbfs-zaehl,
        subrc type sy-subrc,
      end of ty_s_vbfs .
    types:
        tt_protocol type table of prott .

    data: lt_vbeln              type table of vbeln,
          lt_item               type table of a_outbdeliveryitem_1,
          lv_delivery_number    type vbeln,
          lv_delivery_item      type posnr,
          lv_item_category      type pstyv,
          delivery_item_manager type ref to cl_od_api_item_process,
          error_log_item        type ty_s_vbfs,
          protocol_item         type tt_protocol,
          lv_ptf_key            type ptfkey.



    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_vbeln.
    endloop.
    if lt_vbeln is initial.
      me->mo_run_environment->append_log( |No reference document found.| ).
      return.
    endif.

    ev_execution_status = abap_true.

    loop at lt_vbeln into lv_delivery_number.
      delivery_item_manager = new cl_od_api_item_process( ).

      select
        from a_outbdeliveryitem_1
        fields a_outbdeliveryitem_1~*
        where deliverydocument = @lv_delivery_number
        into table @lt_item.

      loop at lt_item assigning field-symbol(<ls_item>).
        lv_delivery_item = <ls_item>-deliverydocumentitem.
        lv_item_category = <ls_item>-deliverydocumentitemcategory.
        if lv_item_category <> 'TAP'.
          delivery_item_manager->confirm_picking_one(
            exporting
              im_deliverydocument     = lv_delivery_number
              im_deliverydocumentitem = lv_delivery_item
            importing
              ex_error_log            = error_log_item
              ex_protocol             = protocol_item
          ).
        endif.

        if error_log_item is not initial.
          me->mo_run_environment->append_log(
    iv_log_statement = |The following error occured: msgid: { error_log_item-msgid } msgno { error_log_item-msgno } msgty { error_log_item-msgty } msgv1 { error_log_item-msgv1 } msgv2 { error_log_item-msgv2 } msgv3 { error_log_item-msgv3 } msgv4 {
    error_log_item-msgv4 }|
    ).
          ev_execution_status = abap_false.
        endif.

        if protocol_item is not initial.
          loop at protocol_item assigning field-symbol(<entry_item_conf>).
            me->mo_run_environment->append_log(
      iv_log_statement = |The following protocol entry exists: msgid: { <entry_item_conf>-msgid } msgno { <entry_item_conf>-msgno } msgty { <entry_item_conf>-msgty } msgv1 { <entry_item_conf>-msgv1 } msgv2 { <entry_item_conf>-msgv2 } msgv3 {
    <entry_item_conf>-msgv3
      } msgv4 { <entry_item_conf>-msgv4 }|
      ).
          endloop.
        endif.
      endloop.

      append lv_ptf_key to ev_document_id.

    endloop.

  endmethod.


  method create.

    me->dlv(
      exporting
        iv_with_picking     = abap_true           "reuse method for creation, this is the parameter to influence it
        iv_step_number      = iv_step_number
      importing
        ev_document_id      = ev_document_id
        ev_execution_status = ev_execution_status
        ev_check_status     = ev_check_status
    ).

  endmethod.


  method create_from_sto.
    data: lt_testdata      type ty_gt_ptf_dl_cr_partitial_td,
          ls_sto_items     type bapidlvreftosto,
          lt_sto_items     type table of bapidlvreftosto,
          lt_created_items type standard table of bapidlvitemcreated with default key.

    data: lt_return          type table of bapiret2,
          lv_delivery_number type vbeln.
*****************************************************************************
*Step: Create Outbound Delivery and commit
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = ls_step_data
      importing
        es_testdata  = lt_testdata ).

    loop at ls_step_data-reference_step assigning field-symbol(<lv_prestepnumbr>).
      data(ls_predecessor) = me->mo_run_environment->get_step_data( iv_step_number = <lv_prestepnumbr> ).
      if ls_predecessor-document_id  is not initial.
        loop at ls_predecessor-document_id into data(ls_vbeln).
          assert ls_vbeln is not initial.
          if lt_testdata is initial.
            ls_sto_items-ref_doc = ls_vbeln.
            append ls_sto_items to lt_sto_items.
          else.
            loop at lt_testdata into data(ls_testdata).
              clear ls_sto_items.
              ls_sto_items-ref_doc = ls_vbeln.
              ls_sto_items-ref_item = ls_testdata-item_to_be_delivered.
              ls_sto_items-dlv_qty = ls_testdata-delivery_quantity.
              ls_sto_items-sales_unit = ls_testdata-delivery_quantity_unit.
              append ls_sto_items to lt_sto_items.
            endloop.
          endif.
        endloop.
      endif.
    endloop.

    select single vstel from ekpv where ebeln eq @ls_sto_items-ref_doc into @data(vstel).

    call function 'BAPI_OUTB_DELIVERY_CREATE_STO'
      exporting
        ship_point        = vstel                 " Shipping Point
      importing
        delivery          = lv_delivery_number
      tables
        stock_trans_items = lt_sto_items
        created_items     = lt_created_items
        return            = lt_return.

    loop at lt_return assigning field-symbol(<ls_msg>).
      me->mo_run_environment->append_log( iv_log_statement = |{ <ls_msg>-message }| ).
    endloop.

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
*****************************************************************************
* Check whether Delivery exists
    data: lv_ptf_key type ptfkey.
    move lv_delivery_number to lv_ptf_key.
    append lv_ptf_key to ev_document_id.
    ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).

    call function 'BAPI_TRANSACTION_COMMIT'
      exporting
        wait = 'X'.
  endmethod.


  method create_simple.
    data: ls_sales_order   type bapidlvreftosalesorder,
          lt_sales_orders  type table of bapidlvreftosalesorder,
          lt_created_items type standard table of bapidlvitemcreated with default key.

    data: lt_return          type table of bapiret2,
          lv_delivery_number type vbeln.
*****************************************************************************
*Step: Create Outbound Delivery and commit
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    loop at ls_step_data-reference_step assigning field-symbol(<lv_prestepnumbr>).
      data(ls_predecessor) = me->mo_run_environment->get_step_data( iv_step_number = <lv_prestepnumbr> ).
      if ls_predecessor-document_id  is not initial.
        loop at ls_predecessor-document_id into data(ls_vbeln).
          ls_sales_order-ref_doc = ls_vbeln.
          append ls_sales_order to lt_sales_orders.
        endloop.
      endif.
    endloop.

    call function 'BAPI_OUTB_DELIVERY_CREATE_SLS'
      importing
        delivery          = lv_delivery_number
      tables
        sales_order_items = lt_sales_orders
        created_items     = lt_created_items
        return            = lt_return.

    loop at lt_return assigning field-symbol(<ls_msg>).
      me->mo_run_environment->append_log( iv_log_statement = |{ <ls_msg>-message }| ).
    endloop.

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
*****************************************************************************
* Check whether Delivery exists
    data: lv_ptf_key type ptfkey.
    move lv_delivery_number to lv_ptf_key.
    ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).
    append lv_ptf_key to ev_document_id.
  endmethod.


  method create_with_reference_items.
    types:
      begin of ty_s_vbfs,
        etenr type vbfs-etenr,
        mandt type vbfs-mandt,
        msgid type vbfs-msgid,
        msgno type symsgno,
        msgty type vbfs-msgty,
        msgv1 type vbfs-msgv1,
        msgv2 type vbfs-msgv2,
        msgv3 type vbfs-msgv3,
        msgv4 type vbfs-msgv4,
        posnr type vbfs-posnr,
        sammg type vbfs-sammg,
        smart type vbfs-smart,
        vbeln type vbfs-vbeln,
        zaehl type vbfs-zaehl,
        subrc type sy-subrc,
      end of ty_s_vbfs .
    data: ls_sales_order  type shp_sd_reference,
          lt_sales_orders type shp_sd_reference_tab.
    data lt_testdata type ty_gt_ptf_dl_cr_partitial_td.

*****************************************************************************
*Step: Create Outbound Delivery and commit
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = ls_step_data
      importing
        es_testdata  = lt_testdata
    ).

    loop at ls_step_data-reference_step assigning field-symbol(<lv_prestepnumbr>).
      data(ls_predecessor) = me->mo_run_environment->get_step_data( iv_step_number = <lv_prestepnumbr> ).
      if ls_predecessor-document_id  is not initial.
        loop at ls_predecessor-document_id into data(ls_vbeln).
          loop at lt_testdata into data(ls_testdata).
            ls_sales_order-rfbel = ls_vbeln.
            ls_sales_order-rfpos = ls_testdata-item_to_be_delivered.
            if ls_testdata-delivery_quantity is not initial and
               ls_testdata-delivery_quantity_unit is not initial.
              ls_sales_order-lfimg    = ls_testdata-delivery_quantity.
              ls_sales_order-vrkme = ls_testdata-delivery_quantity_unit.
            endif.
            append ls_sales_order to lt_sales_orders.
          endloop.
        endloop.
      endif.
    endloop.

    data vstel type bapidlvcreateheader-ship_point.
    clear vstel.
    if ls_testdata-shipping_point is not initial.
      vstel = ls_testdata-shipping_point.
    endif.
    cl_od_create_from_sd_doc=>create( )->from_sales_document(
      exporting
        shipping_point               = vstel
        sd_reference_data            = lt_sales_orders
      importing
        delivery_document_number     = data(delivery_document)
        delivery_document_items      = data(delivery_document_items)
        messages                     = data(messages)
    ).

    loop at messages assigning field-symbol(<ls_msg>).
      message id <ls_msg>-msgid type <ls_msg>-msgty
              number <ls_msg>-msgno
              with <ls_msg>-msgv1 <ls_msg>-msgv2 <ls_msg>-msgv3 <ls_msg>-msgv4
              into data(lv_message_str).

      me->mo_run_environment->append_log( iv_log_statement = |{ lv_message_str }| ).
    endloop.

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
*****************************************************************************
* Check whether Delivery exists
    data: lv_ptf_key type ptfkey.
    move delivery_document to lv_ptf_key.
    ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).

    if ev_execution_status eq abap_true.
      append lv_ptf_key to ev_document_id.
    else.
      me->mo_run_environment->append_log( iv_log_statement = |Delivery not created.| ).
    endif.

  endmethod.


  method create_with_serial_numbers.
    data: ls_sales_order             type bapidlvreftosalesorder,
          lt_sales_orders            type table of bapidlvreftosalesorder,
          lt_sales_orders_to_deliver type table of bapidlvreftosalesorder,
          lt_created_items           type standard table of bapidlvitemcreated with default key,
          serial_numbers             type shp_sernr_update_t,
          serial_number              type shp_sernr_update_s,
          serial_numbers_returned    type table of risernr,
          numbers_of_ser_num         type i.

    data: lt_return          type table of bapiret2,
          lv_delivery_number type vbeln.
*****************************************************************************
*Step: Create Outbound Delivery and commit
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    loop at ls_step_data-reference_step assigning field-symbol(<lv_prestepnumbr>).
      data(ls_predecessor) = me->mo_run_environment->get_step_data( iv_step_number = <lv_prestepnumbr> ).
      if ls_predecessor-document_id  is not initial.
        loop at ls_predecessor-document_id into data(ls_vbeln).
          ls_sales_order-ref_doc = ls_vbeln.
          append ls_sales_order to lt_sales_orders.
        endloop.
      endif.
    endloop.

    loop at lt_sales_orders assigning field-symbol(<sales_order>).

      append <sales_order> to lt_sales_orders_to_deliver.

      select posnr, matnr, lsmeng from vbap where vbeln = @<sales_order>-ref_doc into table @data(sales_order_items).

      loop at sales_order_items assigning field-symbol(<item>).

        numbers_of_ser_num = <item>-lsmeng.

        call function 'READ_MASE'
          exporting
            anzahl_neu  = numbers_of_ser_num
            material_nr = <item>-matnr
          tables
            isernr      = serial_numbers_returned.

        loop at serial_numbers_returned assigning field-symbol(<returned_snro>).
          serial_number-rfbel = <sales_order>-ref_doc.
          serial_number-rfpos = <item>-posnr.
          serial_number-sernr = <returned_snro>-sernr.
          append serial_number to serial_numbers.
        endloop.

      endloop.

      call function 'BAPI_OUTB_DELIVERY_CREATE_SLS'
        importing
          delivery          = lv_delivery_number
        tables
          sales_order_items = lt_sales_orders_to_deliver
          created_items     = lt_created_items
          return            = lt_return.

      loop at lt_return assigning field-symbol(<ls_msg>).
        me->mo_run_environment->append_log( iv_log_statement = |{ <ls_msg>-message }| ).
      endloop.

      cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
*****************************************************************************
* Check whether Delivery exists
      data: lv_ptf_key type ptfkey.
      move lv_delivery_number to lv_ptf_key.
      ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).
*****************************************************************************
*  PGI and PICKING
      if  ev_execution_status eq abap_true.
        data ls_header_data     type vbkok.
        data: ls_created_item    type bapidlvitemcreated.
        data ls_delivery_item   type vbpok.
        data: rt_delivery_items type tt_vbpok.
        data: ef_error_any_0              type  xfeld,
              ef_error_in_item_deletion_0 type  xfeld,
              ef_error_in_pod_update_0    type  xfeld,
              ef_error_in_interface_0     type  xfeld,
              ef_error_in_goods_issue_0   type  xfeld,
              ef_error_in_final_check_0   type  xfeld,
              ef_error_partner_update     type  xfeld,
              ef_error_sernr_update       type  xfeld.

*    DATA lt_delivery_items  TYPE TABLE OF vbpok.

*-Populate required fields to perform PGI

* Loop through all Items
        loop at lt_created_items into ls_created_item.
          ls_delivery_item-vbeln_vl = ls_created_item-deliv_numb. " Delivery No
          ls_delivery_item-posnr_vl = ls_created_item-deliv_item. " Delivery Item
          ls_delivery_item-vbeln    = ls_created_item-ref_doc.    " Sales order - Ref Doc
          ls_delivery_item-posnn    = ls_created_item-ref_item.   " SO Line item - Ref doc item
          ls_delivery_item-matnr    = ls_created_item-material.   " Material No
*      ls_delivery_item-werks    = 'ZZZ1'.                     " Plant
          ls_delivery_item-pikmg    = ls_created_item-dlv_qty.    " Delivery Qty
          ls_delivery_item-taqui    = 'X'.                        " Transfer order confirmed
          append ls_delivery_item to rt_delivery_items.
        endloop.

* Assign Header Data
        ls_header_data-vbeln_vl = ls_created_item-deliv_numb.   " Delivery Number
        ls_header_data-vbtyp_vl = if_sd_doc_category=>delivery. " Delivery Type
        ls_header_data-wabuc    = 'X'.                          " Post good issue automatically
        ls_header_data-komue    = 'X'.                          " Update delivery qty with picking qty


*-Do Picking and PGI
        "VALUE(IT_SERNR_UPDATE) TYPE  SHP_SERNR_UPDATE_T OPTIONAL
        call function 'WS_DELIVERY_UPDATE_2'
          exporting
            vbkok_wa                  = ls_header_data
            delivery                  = ls_created_item-deliv_numb
            update_picking            = abap_true
            if_database_update_1      = '1'
            if_error_messages_send    = 'X'
            it_sernr_update           = serial_numbers
          importing
            ef_error_any              = ef_error_any_0
            ef_error_in_item_deletion = ef_error_in_item_deletion_0
            ef_error_in_pod_update    = ef_error_in_pod_update_0
            ef_error_in_interface     = ef_error_in_interface_0
            ef_error_in_goods_issue   = ef_error_in_goods_issue_0
            ef_error_in_final_check   = ef_error_in_final_check_0
            ef_error_partner_update   = ef_error_partner_update
            ef_error_sernr_update     = ef_error_sernr_update
          tables
            vbpok_tab                 = rt_delivery_items.

        append lv_ptf_key to ev_document_id.
      endif.

    endloop.

  endmethod.


  method delete.
    data(lv_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    me->delete_delivery_document(
      exporting
        step_data           = lv_step_data
        iv_step_number      = iv_step_number
      importing
        ev_document_id      = ev_document_id
        ev_execution_status = ev_execution_status
        ev_check_status     = ev_check_status ).
  endmethod.


  method delete_delivery_document.
    data: lt_vbeln           type table of vbeln,
          lv_delivery_number type vbeln,
          protocol_item      type cl_od_api_header_process=>tt_protocol,
          error_log_header   type cl_od_api_header_process=>ty_s_vbfs,
          protocol_header    type cl_od_api_header_process=>tt_protocol,
          lv_ptf_key         type ptfkey.


    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_vbeln.
    endloop.

    ev_execution_status = abap_true.

    loop at lt_vbeln into lv_delivery_number.
      data(delivery_header_manager) = new cl_od_api_header_process( ).
      lv_ptf_key = lv_delivery_number.

      delivery_header_manager->delete_delivery(
        exporting
          im_deliverydocument = lv_delivery_number
        importing
          ex_error_log        = error_log_header
          ex_protocol         = protocol_header ).

      if error_log_header is not initial.
        me->mo_run_environment->append_log(
          iv_log_statement = |The following error occured: msgid: { error_log_header-msgid } msgno { error_log_header-msgno } msgty { error_log_header-msgty } msgv1 { error_log_header-msgv1 } msgv2 { error_log_header-msgv2 } msgv3 {
    error_log_header-msgv3 } msgv4 {
    error_log_header-msgv4 }|
        ).
        ev_execution_status = abap_false.
      endif.

      if protocol_item is not initial.
        loop at protocol_item assigning field-symbol(<entry_header>).
          me->mo_run_environment->append_log(
    iv_log_statement = |The following protocol entry exists: msgid: { <entry_header>-msgid } msgno { <entry_header>-msgno } msgty { <entry_header>-msgty } msgv1 { <entry_header>-msgv1 } msgv2 { <entry_header>-msgv2 } msgv3 { <entry_header>-msgv3
    } msgv4 { <entry_header>-msgv4 }|
    ).
        endloop.

        commit work and wait.
        wait up to 3 seconds.

      endif.

      append lv_ptf_key to ev_document_id.
    endloop.
  endmethod.


  method dlv.

    data: ls_testdata      type ty_gs_ptf_del_create_td,
          ls_sales_order   type bapidlvreftosalesorder,
          lt_sales_orders  type table of bapidlvreftosalesorder,
          lt_created_items type standard table of bapidlvitemcreated with default key.
    data: lt_return          type table of bapiret2,
          lv_delivery_number type vbeln.
*****************************************************************************
*Step: Create Outbound Delivery and commit
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = ls_step_data
      importing
        es_testdata  = ls_testdata ).

    loop at ls_step_data-reference_step assigning field-symbol(<lv_prestepnumbr>).
      data(ls_predecessor) = me->mo_run_environment->get_step_data( iv_step_number = <lv_prestepnumbr> ).
      if ls_predecessor-document_id is not initial.
        loop at ls_predecessor-document_id into data(ls_vbeln).
          assert ls_vbeln is not initial.
          ls_sales_order-ref_doc = ls_vbeln.
          append ls_sales_order to lt_sales_orders.
        endloop.
      endif.
    endloop.

    if lt_sales_orders is initial.
      mo_run_environment->append_log( iv_log_statement = |There is no preceding document.| ).
      return.
    endif.

    "Write schedule lines to the log
    select vbeln, posnr, matnr from vbap for all entries in @lt_sales_orders where vbeln = @lt_sales_orders-ref_doc into table @data(lt_item).
    loop at lt_sales_orders assigning field-symbol(<sales_order>).
      select vbeln, posnr, etenr, edatu, lifsp from vbep where vbeln = @<sales_order>-ref_doc into table @data(sched_lines).
      if sched_lines is not initial.
        loop at sched_lines assigning field-symbol(<schedule_line>).
          data ls_vbap like line of lt_item.
          if ls_vbap-posnr ne <schedule_line>-posnr or ls_vbap-vbeln ne <schedule_line>-vbeln.
            clear ls_vbap.
            read table lt_item with key posnr = <schedule_line>-posnr into ls_vbap.
          endif.
          mo_run_environment->append_log( iv_log_statement =
                                                             |SO schedule line ({ ls_vbap-matnr }): vbeln: { <schedule_line>-vbeln } | &&
                                                             |posnr: { <schedule_line>-posnr } etenr: { <schedule_line>-etenr } date: { <schedule_line>-edatu } | ).   "block = { <schedule_line>-lifsp }
        endloop.
      endif.
    endloop.

    call function 'BAPI_OUTB_DELIVERY_CREATE_SLS'
      importing
        delivery          = lv_delivery_number
      tables
        sales_order_items = lt_sales_orders
        created_items     = lt_created_items
        return            = lt_return.

    me->mo_run_environment->append_log( iv_log_statement = |Messages from BAPI_OUTB_DELIVERY_CREATE_SLS:| ).
    loop at lt_return assigning field-symbol(<ls_msg>).
      me->mo_run_environment->append_log( iv_log_statement = |({ <ls_msg>-type }){ <ls_msg>-message }| ).
    endloop.

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
*****************************************************************************
* Check whether Delivery exists
    data lv_ptf_key type ptfkey.
    move lv_delivery_number to lv_ptf_key.
    ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).
    if ev_execution_status eq abap_true.
      append lv_ptf_key to ev_document_id.
    else.
      me->mo_run_environment->append_log( iv_log_statement = |Creation of OutboundDelivery FAILED.| ).
    endif.

*****************************************************************************
*  PGI and PICKING
    if ls_testdata-no_pick_and_pgi eq abap_false.
      if ev_execution_status eq abap_true.

        me->mo_run_environment->append_log( iv_log_statement = |Starting PostGoodsIssue.| ).

        me->pgi_picking(
          exporting
            it_created_items    = lt_created_items
            iv_with_picking     = iv_with_picking
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        select single * from likp into @data(ls_likp) where vbeln = @lv_ptf_key .
        if ls_likp-wbstk eq 'C'.
          me->mo_run_environment->append_log( iv_log_statement = |GoodsIssue was successful.| ).
        else.
*         WBSTK:  Goods Movement Status (All Items)  "Indicates if, and to what extent, the delivery has left your premises.
*         The status tells you whether the delivery has already left your warehouse, is still being processed, or whether processing has not yet begun.
*          A Not yet started
*          C Completed
          me->mo_run_environment->append_log( iv_log_statement = |GoodsIssue failed, LIKP-WBSTK is not 'Completed' but: { ls_likp-wbstk }.| ).
          ev_execution_status = abap_false.
        endif.

      endif.
    endif.

  endmethod.


  method dlv_partitial.
    types:
      begin of ty_s_vbfs,
        etenr type vbfs-etenr,
        mandt type vbfs-mandt,
        msgid type vbfs-msgid,
        msgno type symsgno,
        msgty type vbfs-msgty,
        msgv1 type vbfs-msgv1,
        msgv2 type vbfs-msgv2,
        msgv3 type vbfs-msgv3,
        msgv4 type vbfs-msgv4,
        posnr type vbfs-posnr,
        sammg type vbfs-sammg,
        smart type vbfs-smart,
        vbeln type vbfs-vbeln,
        zaehl type vbfs-zaehl,
        subrc type sy-subrc,
      end of ty_s_vbfs .
    data: ls_sales_order  type shp_sd_reference,
          lt_sales_orders type shp_sd_reference_tab.

*****************************************************************************
*Step: Create Outbound Delivery and commit
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    loop at ls_step_data-reference_step assigning field-symbol(<lv_prestepnumbr>).
      data(ls_predecessor) = me->mo_run_environment->get_step_data( iv_step_number = <lv_prestepnumbr> ).
      if ls_predecessor-document_id  is not initial.
        loop at ls_predecessor-document_id into data(ls_vbeln).
          ls_sales_order-rfbel = ls_vbeln.
          ls_sales_order-rfpos = iv_test_data-item_to_be_delivered.
          if iv_test_data-delivery_quantity is not initial and
             iv_test_data-delivery_quantity_unit is not initial.
            ls_sales_order-lfimg    = iv_test_data-delivery_quantity.
            ls_sales_order-vrkme = iv_test_data-delivery_quantity_unit.
          endif.
          append ls_sales_order to lt_sales_orders.
        endloop.
      endif.
    endloop.

    data vstel type bapidlvcreateheader-ship_point.
    clear vstel.
    if iv_test_data-shipping_point is not initial.
      vstel = iv_test_data-shipping_point.
    endif.
    cl_od_create_from_sd_doc=>create( )->from_sales_document(
      exporting
        shipping_point               = vstel
        sd_reference_data            = lt_sales_orders
      importing
        delivery_document_number     = data(delivery_document)
        delivery_document_items      = data(delivery_document_items)
        messages                     = data(messages)
    ).

    loop at messages assigning field-symbol(<ls_msg>).
      message id <ls_msg>-msgid type <ls_msg>-msgty
              number <ls_msg>-msgno
              with <ls_msg>-msgv1 <ls_msg>-msgv2 <ls_msg>-msgv3 <ls_msg>-msgv4
              into data(lv_message_str).

      me->mo_run_environment->append_log( iv_log_statement = |{ lv_message_str }| ).
    endloop.

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
*****************************************************************************
* Check whether Delivery exists
    data: lv_ptf_key type ptfkey.
    move delivery_document to lv_ptf_key.
    ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).

    if ev_execution_status eq abap_true.
      append lv_ptf_key to ev_document_id.
    else.
      me->mo_run_environment->append_log( iv_log_statement = |Delivery not created.| ).
    endif.
*****************************************************************************
*  PGI and PICKING
*    IF  ev_execution_status EQ abap_true.
*      DATA: delivery_item_manager   TYPE REF TO cl_od_api_item_process,
*            delivery_header_manager TYPE REF TO cl_od_api_header_process,
*            error_log_item          TYPE ty_s_vbfs,
*            protocol_item           TYPE tt_protocol,
*            error_log_header        TYPE ty_s_vbfs,
*            protocol_header         TYPE tt_protocol.
*      delivery_item_manager = NEW cl_od_api_item_process( ).
*
*      delivery_item_manager->pick_all(
*        EXPORTING
*          im_deliverydocument = lv_delivery_number
*        IMPORTING
*          ex_error_log        = error_log_item
*          ex_protocol         = protocol_item
*      ).
*
*      IF error_log_item IS NOT INITIAL.
*        me->mo_run_environment->append_log(
*iv_log_statement = |The following error occured: msgid: { error_log_item-msgid } msgno { error_log_item-msgno } msgty { error_log_item-msgty } msgv1 { error_log_item-msgv1 } msgv2 { error_log_item-msgv2 } msgv3 { error_log_item-msgv3 } msgv4 {
*error_log_item-msgv4 }|
*).
*      ENDIF.
*
*      IF protocol_item IS NOT INITIAL.
*        LOOP AT protocol_item ASSIGNING FIELD-SYMBOL(<entry_item>).
*          me->mo_run_environment->append_log(
*  iv_log_statement = |The following protocol entry exists: msgid: { <entry_item>-msgid } msgno { <entry_item>-msgno } msgty { <entry_item>-msgty } msgv1 { <entry_item>-msgv1 } msgv2 { <entry_item>-msgv2 } msgv3 { <entry_item>-msgv3
*} msgv4 { <entry_item>-msgv4 }|
*).
*        ENDLOOP.
*      ENDIF.
*
*      COMMIT WORK AND WAIT.
*
*      delivery_header_manager = NEW cl_od_api_header_process( ).
*
*      delivery_header_manager->pgi(
*        EXPORTING
*          im_deliverydocument = lv_delivery_number
*        IMPORTING
*          ex_error_log        = error_log_header
*          ex_protocol         = protocol_header
*      ).
*
*      IF error_log_header IS NOT INITIAL.
*        me->mo_run_environment->append_log(
*          iv_log_statement = |The following error occured: msgid: { error_log_header-msgid } msgno { error_log_header-msgno } msgty { error_log_header-msgty } msgv1 { error_log_header-msgv1 } msgv2 { error_log_header-msgv2 } msgv3 {
*error_log_header-msgv3 } msgv4 {
*error_log_header-msgv4 }|
*        ).
*      ENDIF.
*
*      IF protocol_item IS NOT INITIAL.
*        LOOP AT protocol_item ASSIGNING FIELD-SYMBOL(<entry_header>).
*          me->mo_run_environment->append_log(
*  iv_log_statement = |The following protocol entry exists: msgid: { <entry_header>-msgid } msgno { <entry_header>-msgno } msgty { <entry_header>-msgty } msgv1 { <entry_header>-msgv1 } msgv2 { <entry_header>-msgv2 } msgv3 { <entry_header>-msgv3
*} msgv4 { <entry_header>-msgv4 }|
*).
*        ENDLOOP.
*      ENDIF.
*
*      APPEND lv_ptf_key TO ev_document_id.
*    ENDIF.

  endmethod.


  method execute_action.
    data(lv_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    case lv_step_data-action.
      when c_set_foreign_trade_fields.
        me->set_foreign_trade_fields(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.
      when c_confirm_all_items.
        me->confirm_all_items(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_pgi.
        me->pgi(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_pick_all_items.
        me->pick_all_items(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_create_with_serial_numbers.
        me->create_with_serial_numbers(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_pick_and_pgi.
        me->pick_and_pgi(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_pick_and_pgi_cs.
        me->pick_and_pgi_cs(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).

      when c_create_simple.
        me->create_simple(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_create_from_sto.
        me->create_from_sto(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_add_serial_numbers.
        me->add_serial_numbers(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_create_with_partitial_items.
        data ls_testdata type ty_gs_ptf_dl_cr_partitial_td.
        cl_ptf_util=>get_testdata(
          exporting
            is_step_data = lv_step_data
          importing
            es_testdata  = ls_testdata
        ).
        me->dlv_partitial(
          exporting
            iv_test_data        = ls_testdata
            iv_with_picking     = abap_false
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_create_without_picking.
        me->dlv(
          exporting
            iv_with_picking     = abap_false
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_reverse_goods_movement.
        me->reverse_goods_movement(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_update_items.
        me->update_delivery_item(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_create_with_ref_items.
        me->create_with_reference_items(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_update_multiple_items.
        me->update_delivery_items(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_add_batch_split_items.
        add_batch_split_items(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_delete_batch_split_items.
        delete_batch_split_items(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_create_batch_split_items.
        create_batch_split_items(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_delete.
        me->delete_delivery_document(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_log_status.
        me->log_status(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when c_change_shipto_party_address.
        me->change_shipto_party_address(
          exporting
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      when others.
        me->mo_run_environment->append_log( iv_log_statement = |Could not find method { lv_step_data-action } for the BO { lv_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        return.
    endcase.

  endmethod.


  method execute_check.
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    case ls_step_data-action.
      when c_check_compare_dlv.
        me->check_compare_dlv(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.

      when c_check_compare_salesdoc.
        me->check_compare_salesdoc(
          exporting
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        return.

      when others.
        me->mo_run_environment->append_log( iv_log_statement = |Could not find method { ls_step_data-action } for the BO { ls_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        return.
    endcase.

  endmethod.


  method handle_transfer_of_control.
    check is_delivery_header-spe_le_scenario = if_le_shp_ico_c=>spe_le_scenario-intercompany_stock_transfer or
          is_delivery_header-spe_le_scenario = if_le_shp_ico_c=>spe_le_scenario-intercompany_sales_process or
          is_delivery_header-spe_le_scenario = if_le_shp_ico_c=>spe_le_scenario-multistage_sales_process or
          is_delivery_header-spe_le_scenario = if_le_shp_ico_c=>spe_le_scenario-multistage_stock_transfer or
          is_delivery_header-spe_le_scenario = if_le_shp_ico_c=>spe_le_scenario-sell_from_stock_with_vsit.

    " Initialize Transfer of Control fields
    data(transfer_of_control_data) = corresponding ico_likp_tocd( is_delivery_header ).
    move-corresponding transfer_of_control_data to cs_header_data.
    cs_header_data-kz_ico_tocd_update = abap_true.

    " Internal Transfer of Control
    if is_delivery_header-int_act_date_tocd is initial and
       ( is_delivery_header-spe_le_scenario = if_le_shp_ico_c=>spe_le_scenario-intercompany_stock_transfer or
      is_delivery_header-spe_le_scenario = if_le_shp_ico_c=>spe_le_scenario-multistage_sales_process or
      is_delivery_header-spe_le_scenario = if_le_shp_ico_c=>spe_le_scenario-multistage_stock_transfer or
         is_delivery_header-spe_le_scenario = if_le_shp_ico_c=>spe_le_scenario-intercompany_sales_process ).
      get time stamp field cs_header_data-int_act_date_tocd.
      cs_header_data-int_act_date_tocd = cs_header_data-int_act_date_tocd - 1.
      cs_header_data-int_tzone_tocd = sy-zonlo.
    endif.
    " External Transfer of Control
    if is_delivery_header-ext_act_date_tocd is initial and
       ( is_delivery_header-spe_le_scenario = if_le_shp_ico_c=>spe_le_scenario-intercompany_sales_process or
      is_delivery_header-spe_le_scenario = if_le_shp_ico_c=>spe_le_scenario-multistage_sales_process or
      is_delivery_header-spe_le_scenario = if_le_shp_ico_c=>spe_le_scenario-multistage_stock_transfer or
         is_delivery_header-spe_le_scenario = if_le_shp_ico_c=>spe_le_scenario-sell_from_stock_with_vsit ).
      get time stamp field cs_header_data-ext_act_date_tocd.
      cs_header_data-ext_act_date_tocd = cs_header_data-ext_act_date_tocd - 1.
      cs_header_data-ext_tzone_tocd = sy-zonlo.
    endif.

  endmethod.


  method keeping_lock_task.

    check p_task eq 'PTF_OUTB_DELIVERY'.
    if mv_locked_async eq 'R'. " lock requested
      receive results from function 'SD_DOC_LOCK' keeping task
                          importing
                            ev_executed = mv_locked_async
                          exceptions
                              system_failure        = 1
                              communication_failure = 2
                              resource_failure      = 3.
    endif.
    if mv_unlocked_async eq 'R'. " unlock requested
      receive results from function 'SD_DOC_UNLOCK' keeping task
                          importing
                            ev_executed = mv_unlocked_async
                          exceptions
                              system_failure        = 1
                              communication_failure = 2
                              resource_failure      = 3.
    endif.

  endmethod.


  method lock.
    data: lv_vbeln type vbeln.

    clear:
      ev_check_status,
      ev_execution_status,
      ev_document_id.

    mv_locked_async = 'R'. " Lock requested

    loop at is_d_step-reference_step assigning field-symbol(<ls_d_step>).
      data(ls_d_step) = me->mo_run_environment->get_step_data( iv_step_number = <ls_d_step> ).
      loop at ls_d_step-document_id assigning field-symbol(<lv_docid>).
        lv_vbeln = <lv_docid>.

        call function 'SD_DOC_LOCK' starting new task 'PTF_OUTB_DELIVERY' calling cl_ptf_bo_outb_delivery=>keeping_lock_task on end of task
          exporting
            iv_vbtyp              = if_sd_doc_category=>delivery
            iv_vbeln              = lv_vbeln
          exceptions
            system_failure        = 1
            communication_failure = 2
            resource_failure      = 3.

        wait for asynchronous tasks until mv_locked_async eq abap_true " lock is set
                                       up to 10 seconds.
        if mv_locked_async eq abap_true.
          ev_execution_status = abap_true.
        endif.
        insert <lv_docid> into table ev_document_id.
      endloop.
    endloop.

    clear mv_locked_async.

  endmethod.


  method log_status.
*     Reads status values of DLV and logs them
    data: lt_vbeln type cl_ptf_util=>ty_vbeln_tab,
          lv_likp  type likp,
          lt_lips  type table of lips.

    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    ev_check_status = abap_false.

    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_vbeln.
    endloop.

    if lt_vbeln is not initial.
      loop at lt_vbeln assigning field-symbol(<lv_vbel>).
        select single vbeln, gbstk, fkstk, fkivk, cmgst from likp where vbeln = @<lv_vbel>-vbeln into corresponding fields of @lv_likp.
        if sy-subrc <> 0.
          "Document not found
          me->mo_run_environment->append_log( iv_log_statement = |Could not find document { <lv_vbel>-vbeln }.| ).
          ev_execution_status = abap_false.
        else.
          me->mo_run_environment->append_log( iv_log_statement = |DLV-Number: { <lv_vbel>-vbeln }  /  GBSTK: { lv_likp-gbstk } | ).
          me->mo_run_environment->append_log( iv_log_statement = |DLV-Number: { <lv_vbel>-vbeln }  /  FKSTK: { lv_likp-fkstk } | ).
          me->mo_run_environment->append_log( iv_log_statement = |DLV-Number: { <lv_vbel>-vbeln }  /  FKIVK: { lv_likp-fkivk } | ).
          me->mo_run_environment->append_log( iv_log_statement = |DLV-Number: { <lv_vbel>-vbeln }  /  CMGST: { lv_likp-cmgst } | ).
          ev_check_status = abap_true.
        endif.
        clear lv_likp.
        select * from lips where vbeln = @<lv_vbel>-vbeln into table @lt_lips.
        if sy-subrc <> 0.
          "No items
          me->mo_run_environment->append_log( iv_log_statement = |Could not find items for document { <lv_vbel>-vbeln }.| ).
        else.
          loop at lt_lips assigning field-symbol(<lv_lips>).
            me->mo_run_environment->append_log( iv_log_statement = |DLV-Number: { <lv_lips>-vbeln }  / Item-Number: { <lv_lips>-posnr } / gbsta: { <lv_lips>-gbsta } | ).
            me->mo_run_environment->append_log( iv_log_statement = |DLV-Number: { <lv_lips>-vbeln }  / Item-Number: { <lv_lips>-posnr } / fksta: { <lv_lips>-fksta } | ).
            me->mo_run_environment->append_log( iv_log_statement = |DLV-Number: { <lv_lips>-vbeln }  / Item-Number: { <lv_lips>-posnr } / lccst: { <lv_lips>-lccst } | ).
          endloop.
        endif.
        clear lt_lips.
      endloop.
    else.
      me->mo_run_environment->append_log( iv_log_statement = |No documents found.| ).
      return.
    endif.

    ev_execution_status = abap_true.

  endmethod.


  method pgi.

    data: lt_vbeln       type cl_ptf_util=>ty_vbeln_tab,
          ls_step_data   type cl_ptf_util=>gt_ptf_step,
          ls_testdata    type ty_gs_ptf_dl_goods_issue_td,
          ct_worktab     type table of  lipov,
          lv_wadat_ist   type dats,
          delivery_items type table of vbpok,
          error          type xfeld,
          header_data    type vbkok,
          prot           type prot_tab.

    ls_step_data = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    if ls_step_data-variant is not initial.
      cl_ptf_util=>get_testdata(
        exporting
          is_step_data = ls_step_data
        importing
          es_testdata  = ls_testdata
      ).
    endif.

    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_vbeln.
    endloop.
    if lt_vbeln is initial.
      me->mo_run_environment->append_log( |No reference document found.| ).
      return.
    endif.

    "Determine Actual GI Date
    if ls_testdata-delta_act_gi_date is not initial.
      lv_wadat_ist = sy-datum + ls_testdata-delta_act_gi_date.
    else.
      lv_wadat_ist = sy-datum.
    endif.

    loop at lt_vbeln assigning field-symbol(<delivery>).

      append value #(
        vbeln     = <delivery>-vbeln
       ) to ct_worktab.

      data(delivery_header) = cl_sd_delivery_data=>get_persisted_delivery( conv #( <delivery>-vbeln ) )->get_delivery_header( ).

      header_data-vbeln_vl  = <delivery>-vbeln.
      header_data-vbtyp_vl  = delivery_header-vbtyp.
      header_data-wabuc     = abap_true.
      header_data-wadat_ist = lv_wadat_ist.

        if delivery_header-SPE_LE_SCENARIO is INITIAL .
      SELECT SINGLE vcm_chain_category FROM lips WHERE vbeln = @<delivery>-vbeln INTO @DATA(lv_cat).
          IF lv_cat = 'MISL'.
          delivery_header-SPE_LE_SCENARIO = '5'.
          endif.
          endif.

      me->handle_transfer_of_control(
        exporting
          is_delivery_header = delivery_header
        changing
          cs_header_data     = header_data ).

      call function 'WS_DELIVERY_UPDATE_2'
        exporting
          vbkok_wa     = header_data
          delivery     = header_data-vbeln_vl
        importing
          ef_error_any = error
        tables
          prot         = prot
          vbpok_tab    = delivery_items.

      if error eq abap_true.
        ev_execution_status = abap_false.
        loop at prot assigning field-symbol(<prot>).
          me->mo_run_environment->append_log( |Error while PGI. SYST: msgid: { <prot>-msgid } msgno: { <prot>-msgno } msgty: { <prot>-msgty } v1: { <prot>-msgv1 } v2: { <prot>-msgv2 } v3: { <prot>-msgv3 } v4: { <prot>-msgv4 }.| ).
        endloop.
      else.
        call function 'BAPI_TRANSACTION_COMMIT'
          exporting
            wait = 'X'.

        ev_execution_status = abap_true.
        append <delivery> to ev_document_id.
      endif.


*      SELECT * FROM lips WHERE vbeln = @<delivery>-vbeln INTO TABLE @DATA(delivery_items).
*      SELECT SINGLE * FROM likp WHERE vbeln = @<delivery>-vbeln INTO @DATA(delivery).
*
*
*    LOOP AT delivery_items ASSIGNING FIELD-SYMBOL(<delivery_item>).
*      created_item-deliv_numb = <delivery_item>-vbeln. " Delivery No
*      created_item-deliv_item = <delivery_item>-posnr. " Delivery Item
*      created_item-ref_doc = <delivery_item>-vgbel.    " Sales order - Ref Doc
*      created_item-ref_item = <delivery_item>-vgpos.   " SO Line item - Ref doc item
*      created_item-material = <delivery_item>-matnr.   " Material No
*      created_item-dlv_qty = <delivery_item>-lfimg.    " Delivery Qty
*        APPEND created_item TO lt_created_items.
*      ENDLOOP.
*
*      DATA ls_header_data     TYPE vbkok.
*      DATA ls_delivery_item   TYPE vbpok.
*      DATA: ef_error_any_0              TYPE  xfeld,
*            ef_error_in_item_deletion_0 TYPE  xfeld,
*            ef_error_in_pod_update_0    TYPE  xfeld,
*            ef_error_in_interface_0     TYPE  xfeld,
*            ef_error_in_goods_issue_0   TYPE  xfeld,
*            ef_error_in_final_check_0   TYPE  xfeld,
*            ef_error_partner_update     TYPE  xfeld,
*            ef_error_sernr_update       TYPE  xfeld.
*
**    DATA lt_delivery_items  TYPE TABLE OF vbpok.
*
**-Populate required fields to perform PGI
*
** Loop through all Items
*      LOOP AT lt_created_items INTO ls_created_item.
*        ls_delivery_item-vbeln_vl = ls_created_item-deliv_numb. " Delivery No
*        ls_delivery_item-posnr_vl = ls_created_item-deliv_item. " Delivery Item
*        ls_delivery_item-vbeln    = ls_created_item-ref_doc.    " Sales order - Ref Doc
*        ls_delivery_item-posnn    = ls_created_item-ref_item.   " SO Line item - Ref doc item
*        ls_delivery_item-matnr    = ls_created_item-material.   " Material No
**      ls_delivery_item-werks    = 'ZZZ1'.                     " Plant
*        ls_delivery_item-pikmg    = ls_created_item-dlv_qty.    " Delivery Qty
*        ls_delivery_item-taqui    = 'X'.                        " Transfer order confirmed
*        APPEND ls_delivery_item TO rt_delivery_items.
*      ENDLOOP.
*
** Assign Header Data
*      ls_header_data-vbeln_vl = ls_created_item-deliv_numb.   " Delivery Number
*      ls_header_data-vbtyp_vl = if_sd_doc_category=>delivery. " Delivery Type
*      ls_header_data-wabuc    = 'X'.                          " Post good issue automatically
*
*
**-Do PGI
*    CALL FUNCTION 'WS_DELIVERY_UPDATE_2'
*        EXPORTING
*        vbkok_wa                  = ls_header_data
*        synchron                  = 'X'
*        commit                    = 'X'
*        delivery                  = ls_created_item-deliv_numb
*        if_database_update_1      = '1'
*        if_error_messages_send    = 'X'
*        IMPORTING
*        ef_error_any              = ef_error_any_0
*        ef_error_in_item_deletion = ef_error_in_item_deletion_0
*        ef_error_in_pod_update    = ef_error_in_pod_update_0
*        ef_error_in_interface     = ef_error_in_interface_0
*        ef_error_in_goods_issue   = ef_error_in_goods_issue_0
*        ef_error_in_final_check   = ef_error_in_final_check_0
*          ef_error_partner_update     = ef_error_partner_update
*          ef_error_sernr_update       = ef_error_sernr_update
*        TABLES
*          vbpok_tab                   = rt_delivery_items.
*
*    IF ef_error_any_0 EQ abap_false.
*      ev_execution_status = abap_true.
*      APPEND <delivery> TO ev_document_id.
*    ELSE.
*      ev_execution_status = abap_false.
*      me->mo_run_environment->append_log( |Error while PGI: sy-msgid: { sy-msgid } sy-msgli: { sy-msgli } sy-msgno: { sy-msgno } sy-msgty: { sy-msgty } sy-msgv1: { sy-msgv1 } sy-msgv2: { sy-msgv2 } sy-msgv3: { sy-msgv3 } sy-msgv4: { sy-msgv4 }.| ).
*      RETURN.
*    ENDIF.
    endloop.

  endmethod.


  method pgi_picking.

    data ls_created_item    type bapidlvitemcreated.
    data ls_header_data     type vbkok.
    data ls_delivery_item   type vbpok.
    data: ef_error_any_0              type  xfeld,
          ef_error_in_item_deletion_0 type  xfeld,
          ef_error_in_pod_update_0    type  xfeld,
          ef_error_in_interface_0     type  xfeld,
          ef_error_in_goods_issue_0   type  xfeld,
          ef_error_in_final_check_0   type  xfeld,
          ef_error_partner_update     type  xfeld,
          ef_error_sernr_update       type  xfeld.

*    DATA lt_delivery_items  TYPE TABLE OF vbpok.

*-Populate required fields to perform PGI

* Loop through all Items
    loop at it_created_items into ls_created_item.
      ls_delivery_item-vbeln_vl = ls_created_item-deliv_numb. " Delivery No
      ls_delivery_item-posnr_vl = ls_created_item-deliv_item. " Delivery Item
      ls_delivery_item-vbeln    = ls_created_item-ref_doc.    " Sales order - Ref Doc
      ls_delivery_item-posnn    = ls_created_item-ref_item.   " SO Line item - Ref doc item
      ls_delivery_item-matnr    = ls_created_item-material.   " Material No
*      ls_delivery_item-werks    = 'ZZZ1'.                     " Plant
      ls_delivery_item-pikmg    = ls_created_item-dlv_qty.    " Delivery Qty
      ls_delivery_item-taqui    = 'X'.                        " Transfer order confirmed
      append ls_delivery_item to rt_delivery_items.
    endloop.

* Assign Header Data
    ls_header_data-vbeln_vl = ls_created_item-deliv_numb.   " Delivery Number
    ls_header_data-vbtyp_vl = if_sd_doc_category=>delivery. " Delivery Type
    ls_header_data-wabuc    = 'X'.                          " Post good issue automatically
    ls_header_data-komue    = 'X'.                          " Update delivery qty with picking qty


*-Do Picking and PGI
    call function 'WS_DELIVERY_UPDATE'
      exporting
        vbkok_wa                    = ls_header_data
        delivery                    = ls_created_item-deliv_numb
        update_picking              = iv_with_picking
        if_database_update          = '1'
        if_error_messages_send_0    = 'X'
      importing
        ef_error_any_0              = ef_error_any_0
        ef_error_in_item_deletion_0 = ef_error_in_item_deletion_0
        ef_error_in_pod_update_0    = ef_error_in_pod_update_0
        ef_error_in_interface_0     = ef_error_in_interface_0
        ef_error_in_goods_issue_0   = ef_error_in_goods_issue_0
        ef_error_in_final_check_0   = ef_error_in_final_check_0
        ef_error_partner_update     = ef_error_partner_update
        ef_error_sernr_update       = ef_error_sernr_update
      tables
        vbpok_tab                   = rt_delivery_items.

    if ef_error_in_goods_issue_0 is not initial.
      mo_run_environment->append_log( iv_log_statement = |An ERROR occured in Goods Issue.| ).
    endif.
*     ignored:  ef_error_any_0              IS NOT INITIAL
    if ef_error_in_item_deletion_0 is not initial
    or ef_error_in_pod_update_0    is not initial
    or ef_error_in_interface_0     is not initial
    or ef_error_in_final_check_0   is not initial
    or ef_error_partner_update     is not initial
    or ef_error_sernr_update       is not initial.
      mo_run_environment->append_log( iv_log_statement = |Error ccured in WS_DELIVERY_UPDATE, elsewhere than in Goods Issue.| ).
    endif.

    call function 'BAPI_TRANSACTION_COMMIT'
      exporting
        wait = 'X'.

  endmethod.


  method pick_all_items.

    types:
      begin of ty_s_vbfs,
        etenr type vbfs-etenr,
        mandt type vbfs-mandt,
        msgid type vbfs-msgid,
        msgno type symsgno,
        msgty type vbfs-msgty,
        msgv1 type vbfs-msgv1,
        msgv2 type vbfs-msgv2,
        msgv3 type vbfs-msgv3,
        msgv4 type vbfs-msgv4,
        posnr type vbfs-posnr,
        sammg type vbfs-sammg,
        smart type vbfs-smart,
        vbeln type vbfs-vbeln,
        zaehl type vbfs-zaehl,
        subrc type sy-subrc,
      end of ty_s_vbfs .
    types:
      tt_protocol type table of prott .

    data: lt_vbeln              type table of vbeln,
          lv_delivery_number    type vbeln,
          delivery_item_manager type ref to cl_od_api_item_process,
          error_log_item        type ty_s_vbfs,
          protocol_item         type tt_protocol,
          lv_ptf_key            type ptfkey.


    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_vbeln.
    endloop.
    if lt_vbeln is initial.
      me->mo_run_environment->append_log( |No reference document found.| ).
      return.
    endif.

    ev_execution_status = abap_true.

    wait up to 3 seconds. "added May 2023, as created OutbDelievry was often locked by VCM queue user directly after creation in HBR

    loop at lt_vbeln into lv_delivery_number.
      delivery_item_manager = new cl_od_api_item_process( ).

      delivery_item_manager->pick_all(
        exporting
          im_deliverydocument = lv_delivery_number
        importing
          ex_error_log        = error_log_item
          ex_protocol         = protocol_item
      ).

      if error_log_item is not initial.
        me->mo_run_environment->append_log(
  iv_log_statement = |The following error occured: msgid: { error_log_item-msgid } msgno { error_log_item-msgno } msgty { error_log_item-msgty } msgv1 { error_log_item-msgv1 } msgv2 { error_log_item-msgv2 } msgv3 { error_log_item-msgv3 } msgv4 {
  error_log_item-msgv4 }|
  ).
        ev_execution_status = abap_false.
      endif.

      if protocol_item is not initial.
        loop at protocol_item assigning field-symbol(<entry_item>).
          me->mo_run_environment->append_log(
    iv_log_statement = |The following protocol entry exists: msgid: { <entry_item>-msgid } msgno { <entry_item>-msgno } msgty { <entry_item>-msgty } msgv1 { <entry_item>-msgv1 } msgv2 { <entry_item>-msgv2 } msgv3 { <entry_item>-msgv3
    } msgv4 { <entry_item>-msgv4 }|
    ).
        endloop.
      endif.

      append lv_ptf_key to ev_document_id.

    endloop.

  endmethod.


  method pick_and_pgi.

    types:
      begin of ty_s_vbfs,
        etenr type vbfs-etenr,
        mandt type vbfs-mandt,
        msgid type vbfs-msgid,
        msgno type symsgno,
        msgty type vbfs-msgty,
        msgv1 type vbfs-msgv1,
        msgv2 type vbfs-msgv2,
        msgv3 type vbfs-msgv3,
        msgv4 type vbfs-msgv4,
        posnr type vbfs-posnr,
        sammg type vbfs-sammg,
        smart type vbfs-smart,
        vbeln type vbfs-vbeln,
        zaehl type vbfs-zaehl,
        subrc type sy-subrc,
      end of ty_s_vbfs .
    types:
      tt_protocol type table of prott .
    data: lt_vbeln                type table of vbeln,
          lv_delivery_number      type vbeln,
          delivery_item_manager   type ref to cl_od_api_item_process,
          delivery_header_manager type ref to cl_od_api_header_process,
          error_log_item          type ty_s_vbfs,
          protocol_item           type tt_protocol,
          error_log_header        type ty_s_vbfs,
          protocol_header         type tt_protocol,
          lv_ptf_key              type ptfkey.


    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_vbeln.
    endloop.
    if lt_vbeln is initial.
      me->mo_run_environment->append_log( |No reference document found.| ).
      return.
    endif.

    ev_execution_status = abap_true.

    loop at lt_vbeln into lv_delivery_number.
      delivery_item_manager = new cl_od_api_item_process( ).

      delivery_item_manager->pick_all(
        exporting
          im_deliverydocument = lv_delivery_number
        importing
          ex_error_log        = error_log_item
          ex_protocol         = protocol_item
      ).

      if error_log_item is not initial.
        me->mo_run_environment->append_log(
  iv_log_statement = |The following error occured: msgid: { error_log_item-msgid } msgno { error_log_item-msgno } msgty { error_log_item-msgty } msgv1 { error_log_item-msgv1 } msgv2 { error_log_item-msgv2 } msgv3 { error_log_item-msgv3 } msgv4 {
  error_log_item-msgv4 }|
  ).
        ev_execution_status = abap_false.
      endif.

      if protocol_item is not initial.
        loop at protocol_item assigning field-symbol(<entry_item>).
          me->mo_run_environment->append_log(
    iv_log_statement = |The following protocol entry exists: msgid: { <entry_item>-msgid } msgno { <entry_item>-msgno } msgty { <entry_item>-msgty } msgv1 { <entry_item>-msgv1 } msgv2 { <entry_item>-msgv2 } msgv3 { <entry_item>-msgv3
    } msgv4 { <entry_item>-msgv4 }|
    ).
        endloop.
      endif.

      commit work and wait.
      wait up to 3 seconds.

      delivery_item_manager->confirm_picking_all(
        exporting
          im_deliverydocument = lv_delivery_number
        importing
          ex_error_log        = error_log_item
          ex_protocol         = protocol_item
      ).

      if error_log_item is not initial.
        me->mo_run_environment->append_log(
  iv_log_statement = |The following error occured: msgid: { error_log_item-msgid } msgno { error_log_item-msgno } msgty { error_log_item-msgty } msgv1 { error_log_item-msgv1 } msgv2 { error_log_item-msgv2 } msgv3 { error_log_item-msgv3 } msgv4 {
  error_log_item-msgv4 }|
  ).
        ev_execution_status = abap_false.
      endif.

      if protocol_item is not initial.
        loop at protocol_item assigning field-symbol(<entry_item_conf>).
          me->mo_run_environment->append_log(
    iv_log_statement = |The following protocol entry exists: msgid: { <entry_item_conf>-msgid } msgno { <entry_item_conf>-msgno } msgty { <entry_item_conf>-msgty } msgv1 { <entry_item_conf>-msgv1 } msgv2 { <entry_item_conf>-msgv2 } msgv3 {
  <entry_item_conf>-msgv3
    } msgv4 { <entry_item_conf>-msgv4 }|
    ).
        endloop.
      endif.

      commit work and wait.
      wait up to 3 seconds.

      delivery_header_manager = new cl_od_api_header_process( ).

      delivery_header_manager->pgi(
        exporting
          im_deliverydocument = lv_delivery_number
        importing
          ex_error_log        = error_log_header
          ex_protocol         = protocol_header
      ).

      if error_log_header is not initial.
        me->mo_run_environment->append_log(
          iv_log_statement = |The following error occured: msgid: { error_log_header-msgid } msgno { error_log_header-msgno } msgty { error_log_header-msgty } msgv1 { error_log_header-msgv1 } msgv2 { error_log_header-msgv2 } msgv3 {
    error_log_header-msgv3 } msgv4 {
    error_log_header-msgv4 }|
        ).
        ev_execution_status = abap_false.
      endif.

      if protocol_item is not initial.
        loop at protocol_item assigning field-symbol(<entry_header>).
          me->mo_run_environment->append_log(
    iv_log_statement = |The following protocol entry exists: msgid: { <entry_header>-msgid } msgno { <entry_header>-msgno } msgty { <entry_header>-msgty } msgv1 { <entry_header>-msgv1 } msgv2 { <entry_header>-msgv2 } msgv3 { <entry_header>-msgv3
    } msgv4 { <entry_header>-msgv4 }|
    ).
        endloop.

        commit work and wait.
        wait up to 3 seconds.

      endif.

      append lv_ptf_key to ev_document_id.

    endloop.

  endmethod.


  method pick_and_pgi_cs.
    data: ls_vbkok_wa  type vbkok,
          lt_vbpok_tab type table of vbpok,
          ls_vbpok     type vbpok,
          lt_prot      type table of prott.

    data: v_error.

    types: begin of lt_lips,
             vbeln type lips-vbeln,
             posnr type lips-posnr,
             lfimg type lips-lfimg,
           end of lt_lips.

    data: lv_vbeln type vbeln,
          lv_posnr type posnr,
          lv_lfimg type lfimg.

    types: begin of lt_data,
             deldoc(10),
           end of lt_data.

    data: it_data type standard table of lt_data,
          wa_data type lt_data,
          it_lips type standard table of lt_lips,
          wa_lips type lt_lips.

    data: lt_vbeln           type table of vbeln,
          lv_delivery_number type vbeln,
          "        error_log_item          TYPE ty_s_vbfs,
          "        protocol_item           TYPE tt_protocol,
          "        error_log_header        TYPE ty_s_vbfs,
          "        protocol_header         TYPE tt_protocol,
          lv_ptf_key         type ptfkey.


    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_vbeln.
    endloop.

    ev_execution_status = abap_true.

    loop at lt_vbeln into lv_delivery_number.

      select vbeln
       into table it_data
       from likp
       where vbeln =  lv_delivery_number.

      clear lt_vbpok_tab.

* loop for delivery documents
      loop at it_data into wa_data.

*   prefixing zeros
        call function 'CONVERSION_EXIT_ALPHA_INPUT'
          exporting
            input  = wa_data-deldoc
          importing
            output = wa_data-deldoc.

*   getting line item information
        select vbeln posnr lfimg
           into table it_lips
           from lips
           where vbeln = wa_data-deldoc.

*   setting header values
        ls_vbkok_wa-vbeln_vl = wa_data-deldoc.
        ls_vbkok_wa-wabuc = 'X'.

*   inner loop for setting line data
        loop at it_lips into wa_lips.

          lv_vbeln = wa_lips-vbeln.
          lv_posnr = wa_lips-posnr.
          lv_lfimg = wa_lips-lfimg.

          ls_vbpok-vbeln_vl = lv_vbeln.
          ls_vbpok-posnr_vl = lv_posnr.
          ls_vbpok-vbeln = lv_vbeln.
          ls_vbpok-posnn = lv_posnr.
          ls_vbpok-pikmg = lv_lfimg.

          append ls_vbpok to lt_vbpok_tab.

        endloop.

      endloop.

      call function 'WS_DELIVERY_UPDATE'
        exporting
          vbkok_wa                 = ls_vbkok_wa
          synchron                 = 'X'
*         NO_MESSAGES_UPDATE       = ' '
          commit                   = 'X'
          delivery                 = lv_vbeln
          update_picking           = 'X'
          nicht_sperren            = 'X'
          if_confirm_central       = 'X'
*         IF_WMPP                  = ' '
*         IF_GET_DELIVERY_BUFFERED = ' '
*         IF_NO_GENERIC_SYSTEM_SERVICE       = ' '
          if_database_update       = '1'
*         IF_NO_INIT               = ' '
*         IF_NO_READ               = ' '
          if_error_messages_send_0 = 'X'
*         IF_NO_BUFFER_REFRESH     = ' '
*         IT_PARTNER_UPDATE        =
*         IT_SERNR_UPDATE          =
*         IF_NO_REMOTE_CHG         = ' '
*         IF_NO_MES_UPD_PACK       = ' '
*         IF_LATE_DELIVERY_UPD     = ' '
        importing
          ef_error_any_0           = v_error
*         EF_ERROR_IN_ITEM_DELETION_0        =
*         EF_ERROR_IN_POD_UPDATE_0 =
*         EF_ERROR_IN_INTERFACE_0  =
*         EF_ERROR_IN_GOODS_ISSUE_0          = v_error
*         EF_ERROR_IN_FINAL_CHECK_0          =
*         EF_ERROR_PARTNER_UPDATE  =
*         EF_ERROR_SERNR_UPDATE    =
        tables
          vbpok_tab                = lt_vbpok_tab
          prot                     = lt_prot
*         VERKO_TAB                =
*         VERPO_TAB                =
*         VBSUPCON_TAB             =
*         IT_VERPO_SERNR           =
*         IT_PACKING               =
*         IT_PACKING_SERNR         =
*         IT_REPACK                =
*         IT_HANDLING_UNITS        =
*         IT_OBJECTS               =
*         ET_CREATED_HUS           =
*         TVPOD_TAB                =
*         IT_TMSTMP                =
*         IT_BAPIADDR1             =
*         IT_TEXTL                 =
*         IT_TEXTH                 =
*         IT_AAC_ITEM_BLOCK        =
*         IT_HU_HEADER_EPC         =
*         IT_HU_ITEMS_EPC          =
        exceptions
          error_message            = 1
          others                   = 2.

*    Check the return table.
      loop at lt_prot  assigning field-symbol(<entry_item>) where msgty = 'E' or msgty = 'A'.
        me->mo_run_environment->append_log(
   iv_log_statement = |The following protocol entry exists: msgid: { <entry_item>-msgid } msgno { <entry_item>-msgno } msgty { <entry_item>-msgty } msgv1 { <entry_item>-msgv1 } msgv2 { <entry_item>-msgv2 } msgv3 { <entry_item>-msgv3
   } msgv4 { <entry_item>-msgv4 }|
   ).
        ev_execution_status = abap_false.
      endloop.

      if sy-subrc ne 0.

        call function 'BAPI_TRANSACTION_COMMIT'
*     EXPORTING
*       WAIT          =
*     IMPORTING
*       RETURN        =
          .
        lv_ptf_key = lv_delivery_number.
        append lv_ptf_key to ev_document_id.
      endif.


      refresh lt_vbpok_tab.
      clear lt_prot[].



    endloop.

  endmethod.


  method print_items_vbap_lips.

    data lv_c80 type c length 80.

    select * from vbap into table @data(lt_vbap) where vbeln = @iv_sls_id order by posnr.
    select * from lips into table @data(lt_lips) where vbeln = @iv_dlv_id order by posnr.

    mo_run_environment->append_log( iv_log_statement = |VBAP:| ).
    loop at lt_vbap into data(ls_vbap).
      clear lv_c80.
      lv_c80    = ls_vbap-posnr.
      lv_c80+7  = |{ ls_vbap-kwmeng }|.
      lv_c80+15 = ls_vbap-vrkme.
      lv_c80+18 = ls_vbap-matnr.
      mo_run_environment->append_log( iv_log_statement = conv #( lv_c80 ) ).
    endloop.
    if sy-subrc is not initial.
      mo_run_environment->append_log( iv_log_statement = |(initial)| ).
    endif.

    mo_run_environment->append_log( iv_log_statement = |LIPS:| ).
    loop at lt_lips into data(ls_lips).
      clear lv_c80.
      lv_c80    = ls_lips-posnr.
      lv_c80+7  = |{ ls_lips-lfimg }|.
      lv_c80+15 = ls_lips-vrkme.
      lv_c80+18 = ls_lips-matnr.
      mo_run_environment->append_log( iv_log_statement = conv #( lv_c80 ) ).
    endloop.
    if sy-subrc is not initial.
      mo_run_environment->append_log( iv_log_statement = |(initial)| ).
    endif.

  endmethod.


  method remove_batch_split_items.

    data ls_vbpok                type vbpok.
    data ls_vbkok                type vbkok.
    data ls_higher_level_vbpok   type vbpok.
    data lt_vbpok                type standard table of vbpok.
    data lv_higher_level_item_no type posnr.
    data lv_any_error            type xfeld.
    data lt_messages             type standard table of prott.
    data lt_testdata             type ty_gt_ptf_batch_split_itm_td.

    if it_testdata is initial or
       it_lips     is initial.
      return.
    endif.

    " higher level item quantity need to be updated if batch-split item is deleted
    ls_higher_level_vbpok-vbeln_vl = iv_delivery_number.
    ls_higher_level_vbpok-lianp    = abap_true.
    ls_higher_level_vbpok-taqui    = abap_false.
    ls_higher_level_vbpok-lfimg    = 0.

    lt_testdata = it_testdata.
    sort lt_testdata by higher_level_item.
    delete adjacent duplicates from lt_testdata comparing higher_level_item.

    loop at lt_testdata assigning field-symbol(<lf_testdata>).
      " check whether higher-level item exists
      if line_exists( it_lips[ vbeln = iv_delivery_number posnr = <lf_testdata>-higher_level_item ] ).
        data(lips) = it_lips[ vbeln = iv_delivery_number posnr = <lf_testdata>-higher_level_item ].
      else.
        continue.
      endif.

      " delete all batch-split items assigned to current higher level item
      loop at it_lips assigning field-symbol(<lf_lips>)
           where uecha = <lf_testdata>-higher_level_item.
        " delete batch-split item
        ls_vbpok-vbeln_vl  = iv_delivery_number.
        ls_vbpok-posnr_vl  = <lf_testdata>-higher_level_item.
        ls_vbpok-lips_del  = abap_true.
        ls_vbpok-wms_rfpos = <lf_lips>-posnr.
        ls_vbpok-wms_rfbel = iv_delivery_number.
        ls_vbpok-umvkz     = <lf_lips>-umvkz.
        ls_vbpok-umvkn     = <lf_lips>-umvkn.

        if lv_higher_level_item_no <> <lf_testdata>-higher_level_item.
          " make sure higher-level item will not contain a batch
          ls_higher_level_vbpok-posnr_vl = <lf_testdata>-higher_level_item.
          insert ls_higher_level_vbpok into table lt_vbpok.
          lv_higher_level_item_no = <lf_testdata>-higher_level_item.
        endif.

        insert ls_vbpok into table lt_vbpok.
      endloop.  " it_lips
    endloop.  " it_testdata

    if lt_vbpok is not initial.
      " update delivery using function module WS_DELIVERY_UPDATE_2
      ls_vbkok-vbeln_vl = iv_delivery_number.
      ls_vbkok-vbtyp_vl = if_sd_doc_category=>delivery.

      call function 'WS_DELIVERY_UPDATE_2'
        exporting
          vbkok_wa     = ls_vbkok
          delivery     = iv_delivery_number
        importing
          ef_error_any = lv_any_error
        tables
          vbpok_tab    = lt_vbpok
          prot         = lt_messages.

      if lv_any_error = abap_true.
        loop at lt_messages assigning field-symbol(<prot>).
          message id <prot>-msgid type <prot>-msgty number <prot>-msgno with <prot>-msgv1 <prot>-msgv2 <prot>-msgv3 <prot>-msgv4 into data(message).
          mo_run_environment->append_log(
          iv_log_statement = |The following error occured: msgid: { <prot>-msgid } msgno { <prot>-msgno } msgty { <prot>-msgty } msgv1 {
                              <prot>-msgv1 } msgv2 { <prot>-msgv2 } msgv3 { <prot>-msgv3 } msgv4 { <prot>-msgv4 }| ).
          mo_run_environment->append_log( iv_log_statement = |{ message }| ).
        endloop.
      else.
        " commit changes
        cl_ptf_util=>do_commitment( io_run_environment = mo_run_environment ).
      endif.
    endif.  " lt_vbpok

  endmethod.


  method reserve_action_1.
  endmethod.


  method reserve_action_2.
  endmethod.


  method reserve_action_3.
  endmethod.


  method reverse_goods_movement.
    data: lt_return         type table of bapiret2,
          lv_delivery_vbeln type vbeln,
          lt_mesg           type table of mesg.

    data: lsgoodsmvt_header type bapi2017_gm_head_02,
          lt_goodsmvt_items type table of bapi2017_gm_item_show,
          lt_emkpf          type table of ty_t_mkpf,
          lt_emseg          type table of ty_t_mseg,
          lf_task_name(7)   type c value 'VLC1',
          lt_vbeln          type cl_ptf_util=>ty_vbeln_tab.
*****************************************************************************
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_vbeln.
    endloop.
*****************************************************************************
    ev_execution_status = abap_true.

    loop at lt_vbeln into lv_delivery_vbeln.

      select mblnr, mjahr, budat from matdoc into table @data(matdocs) where vbeln_im = @lv_delivery_vbeln.

      loop at matdocs assigning field-symbol(<matdoc>).
        call function 'BAPI_GOODSMVT_GETDETAIL'
          exporting
            materialdocument = <matdoc>-mblnr
            matdocumentyear  = <matdoc>-mjahr
          importing
            goodsmvt_header  = lsgoodsmvt_header
          tables
            goodsmvt_items   = lt_goodsmvt_items
            return           = lt_return.

        mv_numberofcalls = 1.

        call function 'VELO17_WS_REVERSE_GOODS_ISSUE'
          starting new task lf_task_name
          calling task_finished on end of task
          exporting
            i_vbeln                   = lv_delivery_vbeln
            i_budat                   = <matdoc>-budat
            i_tcode                   = 'VL09'  "cancel delivery
            i_vbtyp                   = if_sd_doc_category=>delivery  "delivery * SDIMP CCF
          tables
            t_mesg                    = lt_mesg
            emkpf_et                  = lt_emkpf
            emseg_et                  = lt_emseg
          exceptions
            error_reverse_goods_issue = 1
            error_message             = 2                "refer core note 1449556
            others                    = 3.               "refer core note 1449556

        wait until mv_numberofcalls = 0 up to 30 seconds.

        if mv_numberofcalls > 0.
          me->mo_run_environment->append_log( iv_log_statement = |Processing of Reverse Goods Movement took to much time| ).
          ev_execution_status = abap_false.
          exit.
        else.
          me->mo_run_environment->append_log( iv_log_statement = |Reversed matdoc { <matdoc>-mblnr }| ).
        endif.

      endloop.

    endloop.

  endmethod.


  method set_foreign_trade_fields.
    data: foreign_trade_data type ty_gs_ptf_foreign_trade_fields,
          deliveries         type table of vbeln,
          ranged_deliveres   type range of vbeln.

    ev_execution_status = abap_false.

    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = step_data
      importing
        es_testdata  = foreign_trade_data
    ).


    loop at step_data-reference_step assigning field-symbol(<ref_step>).
      data(ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      append lines of ptf_keys to deliveries.
    endloop.

    loop at deliveries assigning field-symbol(<delivery>).
      append value #( sign   = 'I' option = 'EQ' low = <delivery> high = ''  ) to ranged_deliveres.
    endloop.

    update lips
    set spe_herkl = @foreign_trade_data-spe_herkl,
        spe_herkr = @foreign_trade_data-spe_herkr,
        itm_comco = @foreign_trade_data-itm_comco
    where vbeln in @ranged_deliveres.

    commit work and wait.

    if sy-subrc eq 0.
      ev_execution_status = abap_true.
    else.
      me->mo_run_environment->append_log( iv_log_statement = |Couldn't update LIPS table with the corresponding foreing trade data| ).
    endif.



  endmethod.


  method task_finished.
    mv_numberofcalls = mv_numberofcalls - 1.
  endmethod.


  method unlock.
    data: lv_vbeln type vbeln.

    clear:
      ev_check_status,
      ev_execution_status,
      ev_document_id.

    mv_unlocked_async = 'R'. " unlock requested

    loop at is_d_step-reference_step assigning field-symbol(<ls_d_step>).
      data(ls_d_step) = me->mo_run_environment->get_step_data( iv_step_number = <ls_d_step> ).
      loop at ls_d_step-document_id assigning field-symbol(<lv_docid>).
        lv_vbeln = <lv_docid>.

        call function 'SD_DOC_UNLOCK' starting new task 'PTF_OUTB_DELIVERY' calling cl_ptf_bo_outb_delivery=>keeping_lock_task on end of task
          exporting
            iv_vbtyp              = if_sd_doc_category=>delivery
            iv_vbeln              = lv_vbeln
          exceptions
            system_failure        = 1
            communication_failure = 2
            resource_failure      = 3.

        wait for asynchronous tasks until mv_unlocked_async eq abap_true " unlock set
                                    up to 10 seconds.
        if mv_unlocked_async eq abap_true.
          ev_execution_status = abap_true.
        endif.
        insert <lv_docid> into table ev_document_id.
      endloop.
    endloop.

    clear: mv_unlocked_async.

  endmethod.


  method update_delivery_item.
    data: ls_testdata        type ty_gs_ptf_del_item_update_td,
          lt_vbeln           type table of vbeln,
          lv_delivery_number type vbeln,
          vbpok              type table of  vbpok.

    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = step_data
      importing
        es_testdata  = ls_testdata ).

    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_vbeln.
    endloop.

    data(delivery_update) = cl_api_le_dlv_upd_coll_factory=>get_instance( ).

    ev_execution_status = abap_true.

    loop at lt_vbeln into lv_delivery_number.
      vbpok = value #( (  vbeln_vl = lv_delivery_number
                          posnr_vl = ls_testdata-delivery_item
                          lfimg    = ls_testdata-delivery_quantity
                          lgmng    = ls_testdata-delivery_quantity
                          vrkme    = ls_testdata-delivery_quantity_unit
                          taqui    = abap_false
                          lianp    = abap_true ) ).


      delivery_update->update(
        exporting
          is_vbkok       = value vbkok( vbeln_vl = lv_delivery_number
                                        vbtyp_vl = if_sd_doc_category=>delivery )
          it_vbpok       = vbpok
        importing
          et_prot        = data(messages)
          ef_error_any_0 = data(any_error) ).

      if any_error eq abap_true.
        loop at messages assigning field-symbol(<prot>).
          me->mo_run_environment->append_log(
        iv_log_statement = |The following error occured: msgid: { <prot>-msgid } msgno { <prot>-msgno } msgty { <prot>-msgty } msgv1 { <prot>-msgv1 } msgv2 { <prot>-msgv2 } msgv3 {
  <prot>-msgv3 } msgv4 {
  <prot>-msgv4 }| ).
          ev_execution_status = abap_false.
        endloop.
      endif.

      call function 'BAPI_TRANSACTION_COMMIT'
        exporting
          wait = 'X'.
    endloop.

    append lv_delivery_number to ev_document_id.
  endmethod.


  method update_delivery_items.
    data: lt_testdata        type ty_gt_ptf_del_item_update_td,
          lt_vbeln           type table of vbeln,
          lv_delivery_number type vbeln,
          vbpok              type vbpok,
          vbpok_tab          type table of  vbpok,
          ls_quantities      type shp_set_of_quantity.

    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = step_data
      importing
        es_testdata  = lt_testdata ).

    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_vbeln.
    endloop.

    data(delivery_update) = cl_api_le_dlv_upd_coll_factory=>get_instance( ).

    ev_execution_status = abap_true.

    loop at lt_vbeln into lv_delivery_number.
      cl_le_api_dlv_upd_transact=>get( )->read_delivery(
     exporting
       iv_vbeln             = lv_delivery_number
     importing
       et_xlips             = data(lt_xlips)
       et_xvbfa             = data(lt_xvbfa)
  ).

      loop at lt_testdata into data(ls_testdata).
        if line_exists( lt_xlips[ vbeln = lv_delivery_number posnr = ls_testdata-delivery_item ] ).
          data(xlips) = lt_xlips[ vbeln = lv_delivery_number posnr = ls_testdata-delivery_item ].
        else.
          clear xlips.
        endif.
        vbpok-vbeln_vl = lv_delivery_number.
        vbpok-posnr_vl = ls_testdata-delivery_item.
        vbpok-lianp    = abap_true.
        vbpok-taqui    = abap_false.
        if ls_testdata-delivery_quantity_unit is not initial.
          ls_quantities-lfimg = ls_testdata-delivery_quantity.
          ls_quantities-akmng = 'A'.
          ls_quantities-vrkme = ls_testdata-delivery_quantity_unit.
          ls_quantities-meins = xlips-meins.

          call function 'SHP_QUANTITY_SET_WITH_UOM'
            exporting
              if_matnr                  = xlips-matnr
              if_charg                  = xlips-charg
              if_werks                  = xlips-werks
            changing
              cs_soq                    = ls_quantities
            exceptions
              error_from_mat_conversion = 1
              conversion_overflow       = 2
              essential_data_missing    = 3
              error                     = 4
              others                    = 5.

          vbpok-umvkz = xlips-umvkz.
          vbpok-umvkn = xlips-umvkn.
          vbpok-akmng = 'B'.
          vbpok-lgmng = ls_quantities-lgmng.
          vbpok-meins = ls_quantities-meins.
          vbpok-lfimg = ls_quantities-lfimg.
          vbpok-vrkme = ls_quantities-vrkme.

        else.
          me->mo_run_environment->append_log( iv_log_statement = |Delivery Quantity Unit is missing for item { ls_testdata-delivery_item }| ).
          ev_execution_status = abap_false.
        endif.

        insert vbpok into table vbpok_tab.
        clear vbpok.
      endloop.

      try.
          delivery_update->update(
            exporting
              is_vbkok       = value vbkok( vbeln_vl = lv_delivery_number
                                            vbtyp_vl = if_sd_doc_category=>delivery )
              it_vbpok       = vbpok_tab
            importing
              et_prot        = data(messages)
              ef_error_any_0 = data(any_error) ).
        catch cx_root.
          ev_execution_status = abap_false.
          any_error = abap_true.
      endtry.

      if any_error eq abap_true.
        loop at messages assigning field-symbol(<prot>).
          message id <prot>-msgid type <prot>-msgty number <prot>-msgno with <prot>-msgv1 <prot>-msgv2 <prot>-msgv3 <prot>-msgv4 into data(message).
          me->mo_run_environment->append_log(
        iv_log_statement = |The following error occured: msgid: { <prot>-msgid } msgno { <prot>-msgno } msgty { <prot>-msgty } msgv1 { <prot>-msgv1 } msgv2 { <prot>-msgv2 } msgv3 {
  <prot>-msgv3 } msgv4 {
  <prot>-msgv4 }| ).
          me->mo_run_environment->append_log( iv_log_statement = |{ message }| ).
        endloop.
        ev_execution_status = abap_false.
      else.
        call function 'BAPI_TRANSACTION_COMMIT'
          exporting
            wait = 'X'.
      endif.
    endloop.

    append lv_delivery_number to ev_document_id.
  endmethod.


  method delete_batch_split_items.

    " separate the method ADD_BATCH_SPLIT_ITEMS due to 2 commit work
    data lt_testdata             type ty_gt_ptf_batch_split_itm_td.
    data lt_vbeln                type table of vbeln.
    data lv_delivery_number      type vbeln.

    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = step_data
      importing
        es_testdata  = lt_testdata ).

    data(ls_step_data) = mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_vbeln.
    endloop.

    ev_execution_status = abap_true.

    loop at lt_vbeln into lv_delivery_number.
      cl_le_api_dlv_upd_transact=>get( )->read_delivery(
        exporting
          iv_vbeln = lv_delivery_number
        importing
          et_xlips = data(lt_xlips)
          et_xvbfa = data(lt_xvbfa) ).

      if lt_xlips is not initial.
        " make sure already existing batch-split items are deleted
        remove_batch_split_items( iv_delivery_number = lv_delivery_number
                                  it_testdata        = lt_testdata
                                  it_lips            = lt_xlips ).
        data(lt_log) = mo_run_environment->get_log( ).
        data(lv_index) = lines( lt_log ).
        if lv_index = 0.
          continue.
        endif.
        data(ls_log) = lt_log[ lv_index ].
        if ls_log-type ca 'AEX'.
          ev_execution_status = abap_false.
        endif.
      endif.

    endloop.

  endmethod.


  method create_batch_split_items.

    " separate the method ADD_BATCH_SPLIT_ITEMS due to 2 commit work
    data lt_testdata             type ty_gt_ptf_batch_split_itm_td.
    data lt_vbeln                type table of vbeln.
    data lv_delivery_number      type vbeln.
    data lv_higher_level_item_no type posnr.
    data ls_vbpok                type vbpok.
    data ls_vbkok                type vbkok.
    data ls_higher_level_vbpok   type vbpok.
    data lt_vbpok                type standard table of vbpok.
    data ls_quantities           type shp_set_of_quantity.
    data lv_any_error            type xfeld.
    data lt_messages             type standard table of prott.

    cl_ptf_util=>get_testdata(
      exporting
        is_step_data = step_data
      importing
        es_testdata  = lt_testdata ).

    data(ls_step_data) = mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_vbeln.
    endloop.

    ev_execution_status = abap_true.

    loop at lt_vbeln into lv_delivery_number.
      clear lt_vbpok.

      cl_le_api_dlv_upd_transact=>get( )->read_delivery(
        exporting
          iv_vbeln = lv_delivery_number
        importing
          et_xlips = data(lt_xlips)
          et_xvbfa = data(lt_xvbfa) ).

      if lt_xlips is initial.
        continue.
      endif.

      ls_higher_level_vbpok-vbeln_vl = lv_delivery_number.
      ls_higher_level_vbpok-lianp    = abap_true.
      ls_higher_level_vbpok-taqui    = abap_false.
      ls_higher_level_vbpok-lfimg    = 0.

      loop at lt_testdata into data(ls_testdata).
        clear ls_vbpok.

        " check whether higher-level item exists
        if line_exists( lt_xlips[ vbeln = lv_delivery_number posnr = ls_testdata-higher_level_item ] ).
          data(xlips) = lt_xlips[ vbeln = lv_delivery_number posnr = ls_testdata-higher_level_item ].
        else.
          mo_run_environment->append_log( iv_log_statement = |Higher-level item { ls_testdata-higher_level_item } is missing in deliver { lv_delivery_number }| ).
          ev_execution_status = abap_false.
          continue.
        endif.

        if ls_testdata-delivery_item <= 900000.
          mo_run_environment->append_log( iv_log_statement = |Batch-split item number must be higher than 900000| ).
          ev_execution_status = abap_false.
          continue.
        endif.

        if ls_testdata-batch is initial.
          mo_run_environment->append_log( iv_log_statement = |Batch is not specified for delivery item { ls_testdata-delivery_item }| ).
          ev_execution_status = abap_false.
          continue.
        endif.

        if ls_testdata-delivery_quantity_unit is not initial.
          ls_quantities-lfimg = ls_testdata-delivery_quantity.
          ls_quantities-akmng = 'A'.
          ls_quantities-vrkme = ls_testdata-delivery_quantity_unit.
          ls_quantities-meins = xlips-meins.

          call function 'SHP_QUANTITY_SET_WITH_UOM'
            exporting
              if_matnr                  = xlips-matnr
              if_charg                  = ls_testdata-batch
              if_werks                  = xlips-werks
            changing
              cs_soq                    = ls_quantities
            exceptions
              error_from_mat_conversion = 1
              conversion_overflow       = 2
              essential_data_missing    = 3
              error                     = 4
              others                    = 5.

          ls_vbpok-umvkz = xlips-umvkz.
          ls_vbpok-umvkn = xlips-umvkn.
          ls_vbpok-akmng = 'B'.
          ls_vbpok-lgmng = ls_quantities-lgmng.
          ls_vbpok-meins = ls_quantities-meins.
          ls_vbpok-lfimg = ls_quantities-lfimg.
          ls_vbpok-vrkme = ls_quantities-vrkme.

        else.
          mo_run_environment->append_log( iv_log_statement = |Delivery Quantity Unit is missing for item { ls_testdata-delivery_item }| ).
          ev_execution_status = abap_false.
        endif.

        ls_vbpok-vbeln_vl  = lv_delivery_number.
        ls_vbpok-posnr_vl  = ls_testdata-higher_level_item.
        ls_vbpok-lianp     = abap_true.
        ls_vbpok-taqui     = abap_false.
        ls_vbpok-wms_rfpos = ls_testdata-delivery_item.
        ls_vbpok-wms_rfbel = lv_delivery_number.
        ls_vbpok-charg     = ls_testdata-batch.

        if lv_higher_level_item_no <> ls_testdata-higher_level_item.
          " make sure higher-level item will not contain a batch
          ls_higher_level_vbpok-posnr_vl = ls_testdata-higher_level_item.
          insert ls_higher_level_vbpok into table lt_vbpok.
          lv_higher_level_item_no = ls_testdata-higher_level_item.
        endif.

        insert ls_vbpok into table lt_vbpok.
      endloop.  " lt_testdata


      if lt_vbpok is not initial.
        " update delivery using function module WS_DELIVERY_UPDATE_2
        ls_vbkok-vbeln_vl = lv_delivery_number.
        ls_vbkok-vbtyp_vl = if_sd_doc_category=>delivery.

        call function 'WS_DELIVERY_UPDATE_2'
          exporting
            vbkok_wa     = ls_vbkok
            delivery     = lv_delivery_number
          importing
            ef_error_any = lv_any_error
          tables
            vbpok_tab    = lt_vbpok
            prot         = lt_messages.

        if lv_any_error = abap_true.
          loop at lt_messages assigning field-symbol(<prot>).
            message id <prot>-msgid type <prot>-msgty number <prot>-msgno with <prot>-msgv1 <prot>-msgv2 <prot>-msgv3 <prot>-msgv4 into data(message).
            mo_run_environment->append_log(
            iv_log_statement = |The following error occured: msgid: { <prot>-msgid } msgno { <prot>-msgno } msgty { <prot>-msgty } msgv1 {
                                <prot>-msgv1 } msgv2 { <prot>-msgv2 } msgv3 { <prot>-msgv3 } msgv4 { <prot>-msgv4 }| ).
            mo_run_environment->append_log( iv_log_statement = |{ message }| ).
          endloop.

          ev_execution_status = abap_false.
        else.
          " commit changes
          cl_ptf_util=>do_commitment( io_run_environment = mo_run_environment ).
        endif.
      endif.  " lt_vbpok
    endloop.  " lt_vbeln

    if lv_delivery_number is not initial.
      append lv_delivery_number to ev_document_id.
    endif.

  endmethod.
ENDCLASS.
