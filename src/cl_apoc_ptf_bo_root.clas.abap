CLASS cl_apoc_ptf_bo_root DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_apoc_ptf_bo_root.

    METHODS: constructor.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      m_apoc_ptf_utility    TYPE REF TO if_apoc_ptf_utility,
      m_service_manager     TYPE REF TO /bobf/if_tra_service_manager,
      m_transaction_manager TYPE REF TO /bobf/if_tra_transaction_mgr,
      m_failed_keys         TYPE  /bobf/t_frw_key,
      m_bo_preparation      TYPE REF TO if_apoc_ptf_bo_preparation,
      output_control_helper_factory   type ref to if_apoc_or_h_factory,
      output_control_api type ref to if_apoc_or_h_api,
      BOBF_service_manager TYPE REF TO /bobf/if_tra_service_manager.


ENDCLASS.



CLASS CL_APOC_PTF_BO_ROOT IMPLEMENTATION.


  METHOD constructor.
    output_control_helper_factory = cl_apoc_or_h_factory=>get_helper_factory( ).
    output_control_api = output_control_helper_factory->get_apoc_or_api( ).
    BOBF_service_manager ?= /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = if_apoc_output_request_c=>sc_bo_key ).
  ENDMETHOD.


  METHOD if_apoc_ptf_bo_root~check_existence.

    TYPES:
      BEGIN OF object_id_as_integer,
        id TYPE i,
      END OF object_id_as_integer.
    DATA appl_object_id_as_i TYPE object_id_as_integer.
    DATA appl_object_ids_as_i TYPE STANDARD TABLE OF object_id_as_integer.

    "MSN: Imho, this complete logic can never work, and I doubt it is ever called
    "     with real data from elsewhere, but, well, keep it at least as reference

    SELECT appl_object_id                               "#EC CI_NOWHERE
           FROM apoc_d_or_root
           INTO TABLE @DATA(existing_appl_obj_ids).

    LOOP AT i_root INTO DATA(root).
      appl_object_id_as_i-id = CONV #( root-appl_object_id ).
      "MSN: Variable is defiend FALSE, WHILE statement goes against TRUE...
      "     So, whatever was the intention, it will not work...
      DATA does_id_exist_already TYPE abap_bool VALUE abap_false.
      WHILE does_id_exist_already EQ abap_true.
        IF line_exists( existing_appl_obj_ids[ appl_object_id = appl_object_id_as_i-id ] ).
          appl_object_id_as_i-id += 1.
        ELSE.
          does_id_exist_already = abap_true.
        ENDIF.
      ENDWHILE.
      INSERT appl_object_id_as_i INTO TABLE appl_object_ids_as_i .
    ENDLOOP.

  ENDMETHOD.


  METHOD if_apoc_ptf_bo_root~create_manual_items.

    DATA items_to_be_created TYPE /bobf/t_frw_modification.

    LOOP AT i_items INTO DATA(item).


      DATA item_as_reference TYPE REF TO apoc_s_or_item ##NEEDED.

      MOVE-CORRESPONDING item TO item_as_reference->*.

      DATA(item_key) = /bobf/cl_frw_factory=>get_new_key( ).

      " create the modification table
      DATA item_to_be_created TYPE /bobf/s_frw_modification.
      item_to_be_created = VALUE #(
                           node = if_apoc_output_request_c=>sc_node-item
                            change_mode =  /bobf/if_frw_c=>sc_modify_create
                            association = if_apoc_output_request_c=>sc_association-root-item
                            key = item_key
                            data = item_as_reference
                            source_key     =  item-root_key
                            source_node    =  if_apoc_output_request_c=>sc_node-root
                            root_key       =  item-root_key
      ).

      APPEND item_to_be_created TO items_to_be_created.

    ENDLOOP.

    IF m_service_manager IS NOT BOUND.
      m_service_manager ?= /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = if_apoc_output_request_c=>sc_bo_key ).
    ENDIF.
    " 2) Run the service manager
    m_service_manager->modify(
      EXPORTING
        it_modification = items_to_be_created
      IMPORTING
      eo_change       = DATA(changed_items)
      eo_message      = DATA(message_object_during_modify)
    ).

    " 3) commit
    IF m_transaction_manager IS NOT BOUND.
      m_transaction_manager = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).
    ENDIF.
    m_transaction_manager->save(
     IMPORTING
      ev_rejected            = DATA(save_failed)
      eo_message             = DATA(messages_during_save)
  ).

    IF save_failed = 'X'.
      RAISE EXCEPTION NEW cx_apoc_ptf_exception( msgid = |APOC_PTF_MSG| msgno = 3 msgty = |E| ).
    ENDIF.
  ENDMETHOD.


  METHOD if_apoc_ptf_bo_root~create_root_without_items.

  ENDMETHOD.


  METHOD if_apoc_ptf_bo_root~create_root_with_items.

    DATA:
      lt_data TYPE if_apoc_or_h_api=>ty_gt_or_root_d,
      lt_root TYPE apoc_t_or_root.

    MOVE-CORRESPONDING lt_data TO lt_root.

    "We want to create a new Output Request(OR) Root. What if an OR with our Application Object ID already exists? Lets check that it doesn't (and if it does, lets change our ID)
    if_apoc_ptf_bo_root~check_existence( i_root = lt_root ).

    "Our data needs to be prepared so the BOBF API can use it. Let's use a different class and method to descend a level of abstraction
    IF m_bo_preparation IS NOT BOUND.
      m_bo_preparation = NEW cl_apoc_ptf_bo_preparation( ).
    ENDIF.

    DATA(roots_to_create) = m_bo_preparation->prepare_root_data( ).

    "Now let's call our productive OR Creation API. First we need to get the instances of the factory, the api and the BOBF service manager
    DATA(mo_apoc_or_h_factory) = cl_apoc_or_h_factory=>get_helper_factory( ).
    DATA(mo_apoc_or_h_api) = mo_apoc_or_h_factory->get_apoc_or_api( ).
    DATA mo_service_manager TYPE REF TO /bobf/if_tra_service_manager .
    mo_service_manager ?= /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = if_apoc_output_request_c=>sc_bo_key ).

    mo_apoc_or_h_api->create_output_request(
      EXPORTING
        io_srv_mgr                = mo_service_manager
        it_data                   = lt_data
        iv_determine_output_items = abap_true
      IMPORTING
        et_key                    = DATA(root_keys)
        et_or_root                = DATA(output_requests)
        et_or_item_determined     = DATA(determined_items) ).

    "Save our newly created OR Root
    DATA(mo_trans_mgr) = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).
    mo_trans_mgr->save(
      IMPORTING
        ev_rejected         = DATA(did_save_fail)
        eo_message          = DATA(message_from_save)
        et_rejecting_bo_key = DATA(rejected_bo_keys) ).

    "Lastly validate if all the OR roots we wanted to create are now stored in the database
    if_apoc_ptf_bo_root~validate_created_roots( i_created_roots = output_requests
                                                i_wanted_roots  = roots_to_create ).

  ENDMETHOD.


  METHOD if_apoc_ptf_bo_root~determine_items.

* Since our importing parameter ist the Application Object ID, we need to get the corresponding root. We are assuming that there are two roots with the same application object ids (but different object types)
    IF m_apoc_ptf_utility IS NOT BOUND.
      m_apoc_ptf_utility = NEW cl_apoc_ptf_utility( ).
    ENDIF.

    TRY.

        DATA(root_key) = m_apoc_ptf_utility->get_or_root_key( i_root_application_object_id ).

      CATCH cx_apoc_root_does_not_exist INTO DATA(x_root_not_found).
        IF x_root_not_found IS BOUND.
          RAISE EXCEPTION NEW cx_apoc_ptf_determination( previous = x_root_not_found ).
        ENDIF.
    ENDTRY.

* Now that we've got a key, we need to convert the key to a type that bobf can work with
    TRY.
        DATA(root_key_as_bobf_table) = m_apoc_ptf_utility->convert_oc_key_to_bobf_key_tab( i_output_key = root_key ).
      CATCH cx_apoc_ptf_conv_to_bobf_tab INTO DATA(x_key_conversion_failed).
        IF x_key_conversion_failed IS BOUND.
          RAISE EXCEPTION NEW cx_apoc_ptf_determination( previous = x_key_conversion_failed ).
        ENDIF.
    ENDTRY.

    " Same for the parameters

    DATA: determined_items             TYPE apoc_t_or_item,
          parameters_for_determination TYPE apoc_s_or_root_det_items.

    DATA(parameters_as_reference) = REF #( parameters_for_determination ).

    CLEAR m_failed_keys.

    " Execute the Determination through the BOBF service manager

    IF m_service_manager IS NOT BOUND.
      m_service_manager ?= /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = if_apoc_output_request_c=>sc_bo_key ).
    ENDIF.

    m_service_manager->do_action(
      EXPORTING
        iv_act_key              = if_apoc_output_request_c=>sc_action-root-determine_ouput_items
        it_key                  = root_key_as_bobf_table
        is_parameters           = parameters_as_reference
      IMPORTING
        eo_change               = DATA(bobf_change)
        eo_message              = DATA(bobf_message)
        et_failed_key           = m_failed_keys
        et_data                 = determined_items
    ).

* Did it work? Let's check
    IF determined_items IS INITIAL AND m_failed_keys IS NOT INITIAL.
      RAISE EXCEPTION NEW cx_apoc_ptf_determination( msgid = |APOC_PTF_MSG| msgno = 2 msgty = |E|  ).
    ENDIF.

* If everything worked save
    IF m_transaction_manager IS NOT BOUND.
      m_transaction_manager = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).
    ENDIF.
    m_transaction_manager->save(
     IMPORTING
      ev_rejected            = DATA(save_failed)
      eo_message             = DATA(messages_during_save)
  ).

* Did the save work?
    IF save_failed = 'X'.
      RAISE EXCEPTION NEW cx_apoc_ptf_determination( msgid = |APOC_PTF_MSG| msgno = 3 msgty = |E| ).
    ENDIF.

* It is difficult to validate if the determined items have been created, because that depends on the OPD
  ENDMETHOD.


  METHOD if_apoc_ptf_bo_root~get_items_in_preparation.
* Get output items for the application Object id AND status = 1
    SELECT db_key                                       "#EC CI_NOFIRST
           FROM apoc_d_or_item
           INTO TABLE item_keys
           WHERE appl_object_id = application_object_id
             AND status         = 1.
    IF sy-subrc <> 0 or item_keys is initial.
      RAISE EXCEPTION NEW cx_apoc_ptf_exception( msgid = |APOC_PTF_MSG| msgno = 3 msgty = |E| ).
    ENDIF.
  ENDMETHOD.


  METHOD if_apoc_ptf_bo_root~validate_created_roots.

    LOOP AT i_created_roots ASSIGNING FIELD-SYMBOL(<fs_or_root>).

      IF NOT line_exists( i_wanted_roots[ appl_object_id = <fs_or_root>-appl_object_id ] ).
        RAISE EXCEPTION NEW cx_apoc_ptf_exception( msgid = |APOC_PTF_MSG| msgno = 3 msgty = |E| ). "TODO: CREATE MESSAGE IN MESSAGE CLASS
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
