CLASS apoc_ptf_item_repository DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      constructor,
      create_items_from_tdc
        IMPORTING step_data        TYPE cl_ptf_util=>gt_ptf_step
                  step_number      TYPE i
        RETURNING VALUE(item_keys) TYPE /bobf/conf_key,
      get_root_key_from_step_data
        RETURNING
          VALUE(result) TYPE /bobf/conf_key,
      get_testdata_from_container
        RETURNING VALUE(item_attributes_from_tdc) TYPE apoc_t_or_item,
      prepare_mod_table_for_creation
        RETURNING VALUE(item_as_mod_table) TYPE /bobf/t_frw_modification .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      ptf_environment      TYPE REF TO cl_ptf_run,
      step_data            TYPE cl_ptf_util=>gt_ptf_step,
      step_number          TYPE i,
      items_from_tdc       TYPE apoc_t_or_item,
      bopf_service_manager TYPE REF TO /bobf/if_tra_service_manager,
      bopf_trans_mgr       TYPE REF TO /bobf/if_tra_transaction_mgr,
      validator            TYPE REF TO apoc_ptf_validator.
ENDCLASS.



CLASS APOC_PTF_ITEM_REPOSITORY IMPLEMENTATION.


  METHOD constructor.
    me->ptf_environment = ptf_environment.
    bopf_service_manager ?= /bobf/cl_tra_serv_mgr_factory=>get_service_manager(
                              iv_bo_key = if_apoc_output_request_c=>sc_bo_key ).
    bopf_trans_mgr = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).
    validator = NEW apoc_ptf_validator(  ).

  ENDMETHOD.


  METHOD create_items_from_tdc.
    me->step_data = step_data.
    me->step_number = step_number.

    DATA(root_key) = get_root_key_from_step_data(  ).

    items_from_tdc = get_testdata_from_container( ).

    DATA(prepared_items) = prepare_mod_table_for_creation( ).

    bopf_service_manager->modify(
      EXPORTING
        it_modification = prepared_items
      IMPORTING
        eo_change       = DATA(change)
        eo_message      = DATA(message_from_bopf_create)
    ).

*    validate

    bopf_trans_mgr->save(
*  IMPORTING
*    ev_rejected            =
*    eo_change              =
*    eo_message             =
*    et_rejecting_bo_key    =
    ).

    "validate



  ENDMETHOD.


  METHOD get_root_key_from_step_data.
    LOOP AT step_data-reference_step INTO DATA(ls_reference_step).
      DATA(lt_or_id) = me->ptf_environment->get_step_data( iv_step_number = ls_reference_step )-document_id.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_testdata_from_container.
    DATA(current_step) = me->ptf_environment->get_step_data( iv_step_number = step_number ).

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = current_step
    IMPORTING
      es_testdata  = item_attributes_from_tdc
    ).
  ENDMETHOD.


  METHOD prepare_mod_table_for_creation.

  ENDMETHOD.
ENDCLASS.
