CLASS apoc_ptf_root_repository DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS: initial_application_object_id TYPE n LENGTH 70 VALUE '1'.
    METHODS:
      constructor
        IMPORTING ptf_environment TYPE REF TO cl_ptf_run,
      create_root_without_items
        IMPORTING step_data       TYPE cl_ptf_util=>gt_ptf_step
                  step_number     TYPE i
        RETURNING VALUE(root_key) TYPE /bobf/conf_key
        RAISING   cx_apoc_ptf_exception,
      get_testdata_from_container
        RETURNING VALUE(root_attributes_from_tdc) TYPE apoc_s_or_root,
      delete_root_from_db
        RAISING cx_apoc_ptf_exception,
      prepare_mod_table_for_creation
        IMPORTING root_attributes TYPE apoc_s_or_root
        EXPORTING creation_table  TYPE if_apoc_or_h_api=>ty_gt_or_root_d,
      prepare_mod_table_for_deletion
        RETURNING VALUE(modification_table) TYPE /bobf/t_frw_modification,
      validate_modify
        IMPORTING
          change   TYPE REF TO /bobf/if_tra_change
          messages TYPE REF TO /bobf/if_frw_message,
      set_application_object_id
        RETURNING
          VALUE(result) TYPE apoc_s_or_root-appl_object_id
      .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: root_attributes               TYPE apoc_s_or_root,
          validator                     TYPE REF TO apoc_ptf_validator,
          ptf_environment               TYPE REF TO cl_ptf_run,
          step_data                     TYPE cl_ptf_util=>gt_ptf_step,
          step_number                   TYPE i,
          output_control_helper_factory TYPE REF TO if_apoc_or_h_factory,
          output_control_api            TYPE REF TO if_apoc_or_h_api,
          bopf_service_manager          TYPE REF TO /bobf/if_tra_service_manager,
          bopf_trans_mgr                TYPE REF TO /bobf/if_tra_transaction_mgr.

ENDCLASS.



CLASS APOC_PTF_ROOT_REPOSITORY IMPLEMENTATION.


  METHOD constructor.
    me->ptf_environment = ptf_environment.
    output_control_helper_factory = cl_apoc_or_h_factory=>get_helper_factory( ).
    output_control_api = output_control_helper_factory->get_apoc_or_api( ).
    bopf_service_manager ?= /bobf/cl_tra_serv_mgr_factory=>get_service_manager(
                              iv_bo_key = if_apoc_output_request_c=>sc_bo_key ).
    bopf_trans_mgr = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).
    validator = NEW apoc_ptf_validator(  ).
  ENDMETHOD.


  METHOD create_root_without_items.
    me->step_data = step_data.
    me->step_number = step_number.

    root_attributes = get_testdata_from_container( ).

    root_attributes-appl_object_id = set_application_object_id(  ).

    prepare_mod_table_for_creation(
      EXPORTING
        root_attributes = root_attributes
      IMPORTING
        creation_table = DATA(root_prepared_for_oc_api)
    ).

    output_control_api->create_output_request(
      EXPORTING
        io_srv_mgr                = bopf_service_manager
        it_data                   = root_prepared_for_oc_api
      IMPORTING
        et_key                    = DATA(keys_from_oc_api)
        et_failed_object          = DATA(failed_roots)
        eo_change_modify          = DATA(change_object_from_oc_api)
        eo_message_modify         = DATA(messages_from_oc_api)
*        eo_change_action          =
*        eo_message_action         =
        et_or_root                = DATA(created_roots)
    ).

    validator->validate_create_output_request(
        failed_roots         = failed_roots
        messages_from_oc_api = messages_from_oc_api
    ).

    bopf_trans_mgr->save(
      IMPORTING
        ev_rejected            = DATA(is_save_rejected)
        eo_change              = DATA(change_from_save_transaction)
        eo_message             = DATA(message_from_save)
        et_rejecting_bo_key    = DATA(rejected_keys)
    ).

    validator->validate_bopf_save(
        is_rejected   = is_save_rejected
        change        = change_from_save_transaction
        messages      = message_from_save
        rejected_keys = rejected_keys
    ).

    root_key = created_roots[ 1 ]-key.

  ENDMETHOD.


  METHOD delete_root_from_db.

    DATA(modification_table) = prepare_mod_table_for_deletion( ).

    bopf_service_manager->modify(
      EXPORTING
        it_modification = modification_table
      IMPORTING
        eo_change       = DATA(change_from_deletion)
        eo_message      = DATA(messages_from_deletion)
    ).

    validate_modify( change = change_from_deletion messages = messages_from_deletion ).
  ENDMETHOD.


  METHOD get_testdata_from_container.

    DATA(current_step) = me->ptf_environment->get_step_data( iv_step_number = step_number ).

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = current_step
    IMPORTING
      es_testdata  = root_attributes_from_tdc
    ).
  ENDMETHOD.


  METHOD prepare_mod_table_for_creation.
    creation_table = VALUE #( ( appl_object_id = root_attributes-appl_object_id
                                appl_object_type = root_attributes-appl_object_type ) ).
  ENDMETHOD.


  METHOD prepare_mod_table_for_deletion.
    DATA modification_entry TYPE /bobf/s_frw_modification.

    modification_entry = VALUE #(
                         node = if_apoc_output_request_c=>sc_node-root
                          change_mode =  /bobf/if_frw_c=>sc_modify_delete
                          key = root_attributes-key ).
    APPEND modification_entry TO modification_table.
  ENDMETHOD.


  METHOD set_application_object_id.
    DATA(temporary_obj_id) = initial_application_object_id.

    SELECT * FROM apoc_d_or_root WHERE appl_object_type = 'APOC_TEST_OBJECT' INTO TABLE @DATA(output_requests_on_db).

    DATA(application_object_id_exists) = abap_true.
    WHILE application_object_id_exists = abap_true.
      result = temporary_obj_id.
      TRY.
          DATA(tmp) = output_requests_on_db[ appl_object_id = result ].
        CATCH cx_sy_itab_line_not_found.
          EXIT.
      ENDTRY.
      temporary_obj_id += 1.
    ENDWHILE.

  ENDMETHOD.


  METHOD validate_modify.

  ENDMETHOD.
ENDCLASS.
