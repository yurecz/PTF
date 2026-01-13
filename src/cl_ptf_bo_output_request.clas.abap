CLASS cl_ptf_bo_output_request DEFINITION INHERITING FROM cl_ptf_bo
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: create REDEFINITION,
      change REDEFINITION,
      delete REDEFINITION,
      check REDEFINITION,
      execute_action REDEFINITION,
      execute_check REDEFINITION,
      check_existence REDEFINITION.

    TYPES:
      BEGIN OF ty_gs_i_ptf_or_cr_td,
        root TYPE apoc_s_or_root,
      END OF ty_gs_i_ptf_or_cr_td.

    TYPES:
      BEGIN OF ty_gs_i_ptf_or_modify,
        attribute_name  TYPE string,
        attribute_value TYPE string,
      END OF ty_gs_i_ptf_or_modify.

    TYPES:
      BEGIN OF ty_gs_i_ptf_or_neg_test,
        is_negative TYPE abap_bool,
      END OF ty_gs_i_ptf_or_neg_test.

    TYPES:
      apoc_s_or_root_check TYPE STANDARD TABLE OF apoc_tst_or_root_check WITH DEFAULT KEY .

    TYPES:
      BEGIN OF ty_gs_ptf_or_check_td,
        root       TYPE apoc_s_or_root,
        root_check TYPE apoc_s_or_root_check,
      END OF ty_gs_ptf_or_check_td .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      m_ptf_bo_item TYPE REF TO cl_apoc_ptf_bo_item,
      m_ptf_bo_root TYPE REF TO if_apoc_ptf_bo_root.

    METHODS:
      item_create
        IMPORTING
          step_data           TYPE cl_ptf_util=>gt_ptf_step
          iv_step_number      TYPE i
        EXPORTING
          ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
          ev_execution_status TYPE abap_bool
          ev_check_status     TYPE abap_bool,
      item_preview
        IMPORTING
          step_data           TYPE cl_ptf_util=>gt_ptf_step
          iv_step_number      TYPE i
        EXPORTING
          ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
          ev_execution_status TYPE abap_bool
          ev_check_status     TYPE abap_bool,
      item_modify
        IMPORTING
          step_data           TYPE cl_ptf_util=>gt_ptf_step
          iv_step_number      TYPE i
        EXPORTING
          ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
          ev_execution_status TYPE abap_bool
          ev_check_status     TYPE abap_bool,
      item_check
        IMPORTING
          step_data           TYPE cl_ptf_util=>gt_ptf_step
          iv_step_number      TYPE i
        EXPORTING
          ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
          ev_execution_status TYPE abap_bool
          ev_check_status     TYPE abap_bool,
      compare_items_with_tdc
        IMPORTING
          step_data           TYPE cl_ptf_util=>gt_ptf_step
          iv_step_number      TYPE i
        EXPORTING
          ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
          ev_execution_status TYPE abap_bool
          ev_check_status     TYPE abap_bool,
      determine_items
        IMPORTING
          step_data           TYPE cl_ptf_util=>gt_ptf_step
          iv_step_number      TYPE i
        EXPORTING
          ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
          ev_execution_status TYPE abap_bool
          ev_check_status     TYPE abap_bool,
      send_output
        IMPORTING
          step_data           TYPE cl_ptf_util=>gt_ptf_step
          iv_step_number      TYPE i
        EXPORTING
          ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
          ev_execution_status TYPE abap_bool
          ev_check_status     TYPE abap_bool,
      get_items_in_preparation
        IMPORTING
          step_data           TYPE cl_ptf_util=>gt_ptf_step
          iv_step_number      TYPE i
        EXPORTING
          ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
          ev_execution_status TYPE abap_bool
          ev_check_status     TYPE abap_bool,
      item_resend
        IMPORTING
          step_data           TYPE cl_ptf_util=>gt_ptf_step
          iv_step_number      TYPE i
        EXPORTING
          ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
          ev_execution_status TYPE abap_bool
          ev_check_status     TYPE abap_bool,
      item_duplicate
        IMPORTING
          step_data           TYPE cl_ptf_util=>gt_ptf_step
          iv_step_number      TYPE i
        EXPORTING
          ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
          ev_execution_status TYPE abap_bool
          ev_check_status     TYPE abap_bool,
      create_root_without_items
        IMPORTING
          step_data           TYPE cl_ptf_util=>gt_ptf_step
          iv_step_number      TYPE i
        EXPORTING
          ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
          ev_execution_status TYPE abap_bool
          ev_check_status     TYPE abap_bool,
      get_testdata_from_container
        RETURNING
          VALUE(r_result) TYPE cl_ptf_util=>ty_vbeln_tab.

    CONSTANTS: c_determine_output_items    TYPE string VALUE 'DETERMINE_OUTPUT_ITEMS',
               c_item_preview              TYPE string VALUE 'ITEM_PREVIEW',
               c_modify_item               TYPE string VALUE 'MODIFY_ITEM',
               c_check_item                TYPE string VALUE 'CHECK_ITEM',
               c_resend_item               TYPE string VALUE 'RESEND_ITEM',
               c_determine_items           TYPE string VALUE 'DETERMINE_ITEMS',
               c_send_output               TYPE string VALUE 'SEND_OUTPUT',
               c_compare_items_with_tdc    TYPE string VALUE 'COMPARE_ITEMS_WITH_TDC',
               c_get_items_in_preparation  TYPE string VALUE 'GET_ITEMS_IN_PREPARATION',
               c_item_duplicate            TYPE string VALUE 'ITEM_DUPLICATE',
               c_create_root_without_items TYPE string VALUE 'ROOT_CREATE_WITHOUT_ITEMS'.
ENDCLASS.



CLASS CL_PTF_BO_OUTPUT_REQUEST IMPLEMENTATION.


  METHOD change.

  ENDMETHOD.


  METHOD check.
    DATA: ls_testdata        TYPE cl_ptf_bo_output_request=>ty_gs_ptf_or_check_td,
          lv_prestepnumber   TYPE LINE OF cl_ptf_util=>gt_ptf_step-reference_step,
          ls_check_step_data TYPE cl_ptf_util=>gt_ptf_step,
          ls_output_request  TYPE apoc_s_or_root,
          error_message      TYPE bapi_msg,
          ls_return          TYPE bapiret2,
          lv_step_success    TYPE abap_bool,
          var_step           TYPE string.

    DATA(ls_current_step) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_current_step
      IMPORTING
        es_testdata  = ls_testdata
    ).

    lv_step_success = abap_true.
    CLEAR: lv_prestepnumber, ls_check_step_data.
    IF ls_testdata-root_check IS NOT INITIAL.
      READ TABLE ls_current_step-reference_step ASSIGNING FIELD-SYMBOL(<reference_step>) INDEX 1 .
      IF sy-subrc <> 0.
        ev_execution_status = abap_false.
        RETURN.
      ENDIF.
      DATA(lt_or_ids) = me->mo_run_environment->get_step_data( iv_step_number = <reference_step> )-document_id.
      "read from db and compare with tdc
      LOOP AT lt_or_ids INTO DATA(ls_or_tmp).
        DATA(ls_or_id) = ls_or_tmp.
      ENDLOOP.
      READ TABLE lt_or_ids ASSIGNING FIELD-SYMBOL(<fs_or_id>) INDEX 1.
      IF sy-subrc <> 0.
        ev_execution_status = abap_false.
        RETURN.
      ENDIF.
      SELECT SINGLE *
             FROM apoc_d_or_root
             WHERE appl_object_type = 'BILLING_DOCUMENT'
               AND appl_object_id   = @( CONV apoc_appl_object_id( <fs_or_id> ) )
             INTO @DATA(ls_root).
      READ TABLE ls_testdata-root_check ASSIGNING FIELD-SYMBOL(<fs_root_check>) INDEX 1.
      IF sy-subrc <> 0.
        ev_execution_status = abap_false.
        RETURN.
      ENDIF.
      IF <fs_root_check>-appl_object_id  EQ abap_true              AND
         ls_testdata-root-appl_object_id EQ ls_root-appl_object_id.
        ev_document_id      = VALUE #( ( vbeln = CONV #( ls_root-appl_object_id ) ) ).
        ev_check_status     = abap_true.
        ev_execution_status = abap_true.
      ELSE.
        ev_check_status     = abap_false.
        ev_execution_status = abap_false.

      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD check_existence.
    DATA: lv_id TYPE apoc_appl_object_id.

    MOVE iv_id TO lv_id.
    SELECT SINGLE *                                     "#EC CI_NOFIRST
           FROM apoc_d_or_root
           WHERE appl_object_id = @lv_id
           INTO @DATA(ls_or).
    IF sy-subrc <> 0.
      me->mo_run_environment->append_log( iv_log_statement = |OR { lv_id } does not exist.| ).
      rv_exists = abap_false.
    ELSE.
      rv_exists = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD compare_items_with_tdc.
    " get EXPECTED item data from TDC

    " get actual item
  ENDMETHOD.


  METHOD create.

    DATA:
      ls_testdata    TYPE ty_gs_i_ptf_or_cr_td,
      lt_data        TYPE if_apoc_or_h_api=>ty_gt_or_root_d,
      lv_document_id TYPE cl_ptf_util=>ty_vbeln.


******************************************************************************
* 1.  Get data from tdc
    DATA(ls_current_step) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_current_step
    IMPORTING
      es_testdata  = ls_testdata
    ).
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*Check if Output Request ID of test data does not exist yet
    DATA appl_object_id_as_i TYPE i.

    appl_object_id_as_i = CONV #( ls_testdata-root-appl_object_id ).

    SELECT appl_object_id                               "#EC CI_NOWHERE
           FROM apoc_d_or_root
           INTO TABLE @DATA(existing_appl_obj_ids).

    DATA does_id_exist_already TYPE abap_bool VALUE abap_false.
    WHILE does_id_exist_already EQ abap_true.
      IF line_exists( existing_appl_obj_ids[ appl_object_id = appl_object_id_as_i ] ).
        appl_object_id_as_i += 1.
      ELSE.
        does_id_exist_already = abap_true.
      ENDIF.
    ENDWHILE.

**********************************************************************
* 2 Step: Prepare data for BO Creation
    lt_data =
     VALUE #(
        (
        appl_object_id = appl_object_id_as_i
        appl_object_type = ls_testdata-root-appl_object_type
        log_handle = ''
        output_parameter = ls_testdata-root-output_parameter
        )
     ).

*****************************************************************************
* 3 Step: Create Output Request and commit
    DATA(mo_apoc_or_h_factory) = cl_apoc_or_h_factory=>get_helper_factory( ).
    DATA(mo_apoc_or_h_api) = mo_apoc_or_h_factory->get_apoc_or_api( ).
    DATA mo_service_manager TYPE REF TO /bobf/if_tra_service_manager .
    mo_service_manager ?= /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = if_apoc_output_request_c=>sc_bo_key ).
    DATA(mo_trans_mgr) = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).


    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


    mo_apoc_or_h_api->create_output_request(
      EXPORTING
        io_srv_mgr                = mo_service_manager
        it_data                   = lt_data
*        iv_determine_output_items = abap_false
      IMPORTING
        et_key                    = DATA(lt_key)
*        et_failed_object          =
*        eo_change_modify          =
*        eo_message_modify         =
*        eo_change_action          =
*        eo_message_action         =
        et_or_root                = DATA(lt_or_root)
*        et_or_item_determined     =
    ).

    mo_trans_mgr->save(
*      EXPORTING
*        iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
      IMPORTING
        ev_rejected            = DATA(lv_rejected)
*        eo_change              =
        eo_message             = DATA(lo_message)
        et_rejecting_bo_key    = DATA(lt_rejecting_bo_key)
    ).

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
    IF lv_rejected EQ abap_true.
      ev_execution_status = abap_false.
      RETURN.
    ELSE.
      ev_execution_status = abap_true.

      LOOP AT lt_or_root ASSIGNING FIELD-SYMBOL(<fs_or_root>).
        READ TABLE lt_data WITH KEY appl_object_id = <fs_or_root>-appl_object_id TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          ev_execution_status = abap_false.
        ELSE.
          lv_document_id = CONV #( <fs_or_root>-appl_object_id ).
          APPEND lv_document_id TO ev_document_id.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD create_root_without_items.

    DATA(lo_root_creator) = NEW apoc_ptf_root_repository( me->mo_run_environment ).

    TRY.
      lo_root_creator->create_root_without_items(
       EXPORTING
              step_data   = step_data
              step_number = iv_step_number
       RECEIVING
         root_key    = DATA(created_root_key) ).

       ev_execution_status = abap_true.
       ev_document_id = VALUE #( ( vbeln = created_root_key ) ).

   CATCH cx_apoc_ptf_exception INTO DATA(lx_ptf_exception).
    mo_run_environment->append_log( iv_log_statement = lx_ptf_exception->get_longtext( ) ).

  ENDTRY.

  ENDMETHOD.


  METHOD delete.
    DATA(ls_current_step) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).

    LOOP AT ls_current_step-reference_step ASSIGNING FIELD-SYMBOL(<fs_reference_step>).
      DATA(lt_or_ids) = me->mo_run_environment->get_step_data( iv_step_number = <fs_reference_step> )-document_id.
      ev_execution_status = abap_true.
      LOOP AT lt_or_ids ASSIGNING FIELD-SYMBOL(<fs_document_id>).
        DELETE FROM apoc_d_or_root                      "#EC CI_NOFIRST
               WHERE appl_object_id = <fs_document_id>-vbeln.
        IF sy-subrc <> 0.
          ev_execution_status = abap_false.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.


  METHOD determine_items.
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<fs_reference_step>).
      DATA(lt_or_id) = me->mo_run_environment->get_step_data( iv_step_number = <fs_reference_step> )-document_id.
    ENDLOOP.

    DATA(lv_application_obj_id) = lt_or_id[ 1 ].

    IF lv_application_obj_id IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Application object ID is initial| ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.

    IF m_ptf_bo_root IS NOT BOUND.
      m_ptf_bo_root = NEW cl_apoc_ptf_bo_root( ).
    ENDIF.

    TRY.
        DATA(lt_determined_items) = m_ptf_bo_root->determine_items( i_root_application_object_id = CONV #( lv_application_obj_id ) ).
      CATCH cx_apoc_ptf_determination INTO DATA(lx_determination).
        mo_run_environment->append_log( iv_log_statement = lx_determination->get_longtext( ) ).
    ENDTRY.

    ev_execution_status = abap_true.
    ev_document_id = lt_determined_items.


  ENDMETHOD.


  METHOD execute_action.
    DATA(lv_step_data) = me->mo_run_environment->get_step_data(  iv_step_number = iv_step_number ).

    CASE lv_step_data-action.

      WHEN c_create_root_without_items.
        create_root_without_items(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
         ).

      WHEN c_modify_item.
        item_modify(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
         ).

      WHEN c_resend_item.
        item_resend(
         EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
         ).


      WHEN c_determine_items.
        determine_items(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
         ).
      WHEN c_get_items_in_preparation.
        get_items_in_preparation(
         EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
         ).

      WHEN c_send_output.
        send_output(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
         ).

      WHEN c_item_preview.
        item_preview(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).

      WHEN c_compare_items_with_tdc.
        compare_items_with_tdc(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).

      WHEN c_item_duplicate.
        item_duplicate(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).

      WHEN OTHERS.
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
    ENDCASE.
  ENDMETHOD.


  METHOD execute_check.
    DATA(lv_step_data) = me->mo_run_environment->get_step_data(  iv_step_number = iv_step_number ).

    CASE lv_step_data-action.

      WHEN c_check_item.
        item_check(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN OTHERS.
        ev_execution_status = abap_false.
        ev_check_status = abap_false.

    ENDCASE.
  ENDMETHOD.


  METHOD get_items_in_preparation.
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<fs_reference_step>).
      DATA(lt_or_id) = me->mo_run_environment->get_step_data( iv_step_number = <fs_reference_step> )-document_id.
    ENDLOOP.

    DATA(lv_application_obj_id) = lt_or_id[ 1 ].

    IF lv_application_obj_id IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Application object ID is initial| ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.

    IF m_ptf_bo_root IS NOT BOUND.
      m_ptf_bo_root = NEW cl_apoc_ptf_bo_root( ).
    ENDIF.

    TRY.
        DATA(lt_item_keys_with_status_1) = m_ptf_bo_root->get_items_in_preparation( application_object_id = CONV #( lv_application_obj_id ) ).
      CATCH cx_apoc_ptf_exception INTO DATA(lx_ptf_exception).
        mo_run_environment->append_log( iv_log_statement = lx_ptf_exception->get_longtext( ) ).
    ENDTRY.

    ev_execution_status = abap_true.
    ev_document_id = lt_item_keys_with_status_1.
  ENDMETHOD.


  METHOD get_testdata_from_container.

  ENDMETHOD.


  METHOD item_check.
    DATA(ls_current_step) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    DATA(lv_is_negative_test) = abap_false.
    DATA ls_stepdata TYPE ty_gs_i_ptf_or_neg_test.
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_current_step
    IMPORTING
      es_testdata  = ls_stepdata
    ).

    lv_is_negative_test = ls_stepdata-is_negative.


    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<fs_reference_step>).
      DATA(lt_or_id) = me->mo_run_environment->get_step_data( iv_step_number = <fs_reference_step> )-document_id.
    ENDLOOP.

    READ TABLE lt_or_id INTO DATA(lv_item_key) INDEX 1.

    IF m_ptf_bo_item IS NOT BOUND.
      m_ptf_bo_item = NEW cl_apoc_ptf_bo_item( ).
    ENDIF.

    TRY.
        DATA(is_item_valid) = m_ptf_bo_item->check_item( i_item_key = lv_item_key-vbeln ).
      CATCH cx_apoc_item_does_not_exist cx_apoc_ptf_exception INTO DATA(lx_item_does_not_exist).
        ev_execution_status = abap_false.
        RETURN.
    ENDTRY.

    IF lv_is_negative_test = abap_true.
      IF is_item_valid = abap_false.
        ev_check_status = abap_true.
      ENDIF.
    ELSEIF is_item_valid = abap_true.
      ev_check_status = abap_true.
    ENDIF.

    ev_execution_status = abap_true.

  ENDMETHOD.


  METHOD item_create.
    LOOP AT step_data-reference_step INTO DATA(ls_reference_step).
      DATA(lt_or_id) = me->mo_run_environment->get_step_data( iv_step_number = ls_reference_step )-document_id.
    ENDLOOP.

    LOOP AT lt_or_id INTO DATA(lv_root_key).

      DATA(ls_current_step) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
      DATA lt_items_from_tdc    TYPE apoc_t_or_item.

      cl_ptf_util=>get_testdata(
        EXPORTING
          is_step_data = ls_current_step
        IMPORTING
           es_testdata  = lt_items_from_tdc
      ).

      LOOP AT lt_items_from_tdc ASSIGNING FIELD-SYMBOL(<ls_item_from_tdc>).
        <ls_item_from_tdc>-root_key = lv_root_key.
        <ls_item_from_tdc>-parent_key = lv_root_key.
      ENDLOOP.

      IF m_ptf_bo_root IS NOT BOUND.
        m_ptf_bo_root = NEW cl_apoc_ptf_bo_root( ).
      ENDIF.

      TRY.
          m_ptf_bo_root->create_manual_items( i_items = lt_items_from_tdc ).
        CATCH cx_apoc_ptf_exception.
          ev_execution_status = abap_false.
      ENDTRY.

    ENDLOOP.

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).



  ENDMETHOD.


  METHOD item_duplicate.

    " Get data of referenced step
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<fs_reference_step>).
      DATA(lt_or_id) = me->mo_run_environment->get_step_data( iv_step_number = <fs_reference_step> )-document_id.
    ENDLOOP.

    " Get Test Data from Test Data Container
    DATA(ls_current_step) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    DATA ls_testdata TYPE ty_gs_i_ptf_or_neg_test.
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_current_step
      IMPORTING
        es_testdata  = ls_testdata
    ).
    DATA(m_or_item) = NEW cl_apoc_ptf_bo_item( ).

    TRY.
        DATA(result) = m_or_item->duplicate( i_item_key = '1234' ).
      CATCH cx_apoc_ptf_exception INTO DATA(lx_ptf).
        mo_run_environment->append_log( iv_log_statement = lx_ptf->get_longtext( ) ).
    ENDTRY.

    ev_execution_status = abap_true.
    ev_check_status     = abap_true.

  ENDMETHOD.


  METHOD item_modify.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<fs_reference_step>).
      DATA(lt_or_id) = me->mo_run_environment->get_step_data( iv_step_number = <fs_reference_step> )-document_id.
    ENDLOOP.

    READ TABLE lt_or_id INTO DATA(lv_item_key) INDEX 1.

    DATA(ls_current_step) = mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    DATA ls_testdata TYPE ty_gs_i_ptf_or_modify.

    cl_ptf_util=>get_testdata( EXPORTING is_step_data = ls_current_step
                               IMPORTING es_testdata  = ls_testdata ).
    IF m_ptf_bo_item IS NOT BOUND.
      m_ptf_bo_item = NEW cl_apoc_ptf_bo_item( ).
    ENDIF.
    TRY.
        m_ptf_bo_item->modify_item_attribute( i_attribute_name = ls_testdata-attribute_name
                                              i_value          = ls_testdata-attribute_value
                                              i_item_key       = lv_item_key-vbeln ).
        cl_ptf_util=>do_commitment( io_run_environment = mo_run_environment ).
      CATCH cx_apoc_ptf_exception
            cx_apoc_invalid_attribute_name
            cx_apoc_item_does_not_exist
            cx_apoc_error_bobf_retrieve
            cx_apoc_bobf_save_failed
            cx_apoc_bobf_modify_failed.
        RETURN.
    ENDTRY.
    ev_execution_status = abap_true.

  ENDMETHOD.


  METHOD item_preview.

    DATA:
      lo_srv_mgr TYPE REF TO /bobf/if_tra_service_manager,

      lt_item    TYPE STANDARD TABLE OF apoc_s_or_item,
      lt_ao_id   TYPE STANDARD TABLE OF apoc_d_or_item,

      ls_ao_id   TYPE apoc_d_or_item.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
      DATA(lt_or_id) = me->mo_run_environment->get_step_data( iv_step_number = <ls_ref_step> )-document_id.
    ENDLOOP.
    LOOP AT lt_or_id ASSIGNING FIELD-SYMBOL(<ls_ao_id>).
      ls_ao_id-appl_object_id = CONV #( <ls_ao_id>-vbeln ).
      APPEND ls_ao_id TO lt_ao_id.
    ENDLOOP.

    SELECT db_key
      FROM apoc_d_or_item
      FOR ALL ENTRIES IN @lt_ao_id
      WHERE appl_object_type EQ 'BILLING_DOCUMENT'
        AND appl_object_id   EQ @lt_ao_id-appl_object_id
      INTO TABLE @DATA(lt_item_keys).

    lo_srv_mgr ?= /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = if_apoc_output_request_c=>sc_bo_key ).
    TRY.
        lo_srv_mgr->do_action( iv_act_key = if_apoc_output_request_c=>sc_action-item-preview
                               it_key     = CONV #( lt_item_keys ) ).
      CATCH cx_dynamic_check.
    ENDTRY.

    TRY.
        lo_srv_mgr->retrieve( EXPORTING iv_node_key = if_apoc_output_request_c=>sc_node-item
                                        it_key      = CONV #( lt_item_keys )
                              IMPORTING et_data     = lt_item ).
      CATCH cx_dynamic_check.
    ENDTRY.
    LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<ls_item>).
      IF <ls_item>-output_data IS NOT INITIAL.
        ev_execution_status = abap_true.
        EXIT.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD item_resend.
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<fs_reference_step>).
      DATA(lt_or_id) = me->mo_run_environment->get_step_data( iv_step_number = <fs_reference_step> )-document_id.
    ENDLOOP.

    READ TABLE lt_or_id INTO DATA(lv_appl_obj_id) INDEX 1.

    IF m_ptf_bo_item IS NOT BOUND.
      m_ptf_bo_item = NEW cl_apoc_ptf_bo_item( ).
    ENDIF.

    TRY.
        m_ptf_bo_item->resend_output_item(
          EXPORTING
            i_item_application_object_id = CONV #( lv_appl_obj_id )
            i_item_id                    = 1
          RECEIVING
            r_new_copy_of_item           = DATA(new_copy_of_item)
        ).
      CATCH cx_apoc_ptf_exception cx_apoc_item_does_not_exist INTO DATA(resend_exception).
        mo_run_environment->append_log( iv_log_statement = resend_exception->get_longtext( ) ).
        ev_execution_status = abap_false.
    ENDTRY.

    READ TABLE new_copy_of_item INTO DATA(resent_item) INDEX 1.

    ev_document_id = VALUE #( ( vbeln = CONV #( resent_item-key ) ) ).
    ev_execution_status = abap_true.
  ENDMETHOD.


  METHOD send_output.

  ENDMETHOD.
ENDCLASS.
