"! <p class="shorttext synchronized" lang="en">Modify and save data by accessing OC and BOBF APIs</p>
CLASS cl_apoc_ptf_bo_item DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      ty_key TYPE c LENGTH 70.

    METHODS:
      "! <p class="shorttext synchronized" lang="en">Modifies an attribute</p>
      "! Modifies an attribute of the "ITEM" node of the BO Output Request
      "! @parameter i_attribute_name | <p class="shorttext synchronized" lang="en"></p>
      "! @parameter i_value | <p class="shorttext synchronized" lang="en"></p>
      "! @raising cx_apoc_ptf_exception | <p class="shorttext synchronized" lang="en"></p>
      modify_item_attribute
        IMPORTING i_attribute_name TYPE string
                  i_value          TYPE string
                  i_item_key       TYPE ty_key
        RAISING   cx_apoc_ptf_exception
                  cx_apoc_invalid_attribute_name
                  cx_apoc_item_does_not_exist
                  cx_apoc_error_bobf_retrieve
                  cx_apoc_bobf_save_failed
                  cx_apoc_bobf_modify_failed,
      "! <p class="shorttext synchronized" lang="en"></p>
      "! Assign an attribute consisting of a name/value pair generically and keep the rest of the item attributes
      "! @parameter i_attribute_name | <p class="shorttext synchronized" lang="en"></p>
      "! @parameter i_value | <p class="shorttext synchronized" lang="en"></p>
      "! @parameter i_item_structure | <p class="shorttext synchronized" lang="en"></p>
      "! @parameter changed_item_as_reference | <p class="shorttext synchronized" lang="en"></p>
      "! @raising cx_apoc_invalid_attribute_name | <p class="shorttext synchronized" lang="en"></p>
      assign_generic_attribute
        IMPORTING i_attribute_name                 TYPE string
                  i_value                          TYPE string
                  i_item_structure                 TYPE apoc_s_or_item
        RETURNING VALUE(changed_item_as_reference) TYPE REF TO apoc_s_or_item
        RAISING   cx_apoc_invalid_attribute_name,
      "! <p class="shorttext synchronized" lang="en"></p>
      "!
      "! @parameter i_item_application_object_id | <p class="shorttext synchronized" lang="en"></p>
      "! @parameter i_item_id | <p class="shorttext synchronized" lang="en"></p>
      "! @parameter r_new_copy_of_item | <p class="shorttext synchronized" lang="en"></p>
      "! @raising cx_apoc_ptf_exception | <p class="shorttext synchronized" lang="en"></p>
      "! @raising cx_apoc_item_does_not_exist | <p class="shorttext synchronized" lang="en"></p>
      resend_output_item
        IMPORTING i_item_application_object_id TYPE apoc_appl_object_id
                  i_item_id                    TYPE apoc_or_item_id
        RETURNING VALUE(r_new_copy_of_item)    TYPE /bobf/t_frw_key
        RAISING   cx_apoc_ptf_exception
                  cx_apoc_item_does_not_exist,
      check_item
        IMPORTING i_item_key        TYPE ty_key
        RETURNING VALUE(r_is_valid) TYPE abap_bool
        RAISING   cx_apoc_item_does_not_exist
                  cx_apoc_ptf_exception,
      duplicate
        IMPORTING i_item_key        TYPE ty_key
        RETURNING VALUE(r_is_valid) TYPE abap_bool
        RAISING   cx_apoc_ptf_exception.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      m_service_manager     TYPE REF TO /bobf/if_tra_service_manager,
      m_transaction_manager TYPE REF TO /bobf/if_tra_transaction_mgr,
      m_apoc_ptf_utility    TYPE REF TO cl_apoc_ptf_utility,
      m_item_validation     TYPE REF TO if_apoc_ptf_item_validation.

    METHODS: check_validity_of_attribute
        IMPORTING
          i_attribute_name TYPE string
        RAISING
          cx_apoc_invalid_attribute_name,
      get_item_key
        IMPORTING
          i_application_obj_id TYPE apoc_appl_object_id
          i_item_id            TYPE apoc_or_item_id
        RETURNING
          VALUE(r_item_key)    TYPE apoc_s_or_item-key
        RAISING
          cx_apoc_item_does_not_exist,
      retrieve_item_from_bobf
        IMPORTING
                  i_bobf_key_table                   TYPE /bobf/t_frw_key
        RETURNING VALUE(r_retrieved_items_from_bobf) TYPE apoc_t_or_item
        RAISING   cx_apoc_error_bobf_retrieve.

ENDCLASS.



CLASS CL_APOC_PTF_BO_ITEM IMPLEMENTATION.


  METHOD assign_generic_attribute.
    DATA item_as_reference TYPE REF TO apoc_s_or_item.

    FIELD-SYMBOLS:
      <structure_of_item> TYPE any,
      <attribute>         TYPE any.

    check_validity_of_attribute( i_attribute_name =  i_attribute_name ).

    CREATE DATA item_as_reference.

    ASSIGN item_as_reference->* TO <structure_of_item>.
    MOVE-CORRESPONDING i_item_structure TO <structure_of_item>.
    ASSIGN COMPONENT i_attribute_name OF STRUCTURE <structure_of_item> TO <attribute>.
    <attribute> = i_value.

    changed_item_as_reference = item_as_reference.
  ENDMETHOD.


  METHOD check_item.

    IF m_apoc_ptf_utility IS NOT BOUND.
      m_apoc_ptf_utility = NEW #( ).
    ENDIF.

    IF i_item_key IS INITIAL.
      RAISE EXCEPTION TYPE cx_apoc_ptf_exception.
    ENDIF.

    DATA(item_key_in_bobf_table) = m_apoc_ptf_utility->convert_oc_key_to_bobf_key_tab( i_output_item_key = CONV #( i_item_key ) ).

    IF m_service_manager IS NOT BOUND.
      m_service_manager ?= /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = if_apoc_output_request_c=>sc_bo_key ).
    ENDIF.

    m_service_manager->check_consistency(
      EXPORTING
        iv_node_key         = if_apoc_output_request_c=>sc_node-item
        it_key              = item_key_in_bobf_table
        iv_check_scope      = '0'
      IMPORTING
        eo_message          = DATA(message_from_bobf)
        et_inconsistent_key = DATA(failed_key) ).

    IF failed_key IS NOT INITIAL.
      r_is_valid = abap_false.
      RETURN.
    ENDIF.

    message_from_bobf->get_messages( IMPORTING et_message = DATA(lt_msg) ).
    IF line_exists( lt_msg[ KEY consistency severity = 'E' ] ).
      r_is_valid = abap_false.
      RETURN.
    ENDIF.

    r_is_valid = abap_true.

  ENDMETHOD.


  METHOD check_validity_of_attribute.
    DATA: components          TYPE abap_compdescr,
          strucdescr          TYPE REF TO cl_abap_structdescr,
          apoc_item_structure TYPE apoc_s_or_item,
          is_attribute_valid  TYPE abap_bool.


    strucdescr ?= cl_abap_typedescr=>describe_by_data( apoc_item_structure ).

    LOOP AT strucdescr->components ASSIGNING FIELD-SYMBOL(<component_name>).
      IF <component_name>-name = i_attribute_name.
        is_attribute_valid = abap_true.
      ENDIF.
    ENDLOOP.

    IF is_attribute_valid = abap_false.
      RAISE EXCEPTION TYPE cx_apoc_invalid_attribute_name.
    ENDIF.
  ENDMETHOD.


  METHOD duplicate.
    "Logic
  ENDMETHOD.


  METHOD get_item_key.
    "Two items with same application object id?
    SELECT SINGLE db_key                                "#EC CI_NOFIRST
           FROM apoc_d_or_item                          "#EC CI_NOORDER
           INTO r_item_key
           WHERE appl_object_id = i_application_obj_id
             AND item_id        = i_item_id.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_apoc_item_does_not_exist.
    ENDIF.
  ENDMETHOD.


  METHOD modify_item_attribute.

    check_validity_of_attribute( i_attribute_name = i_attribute_name ).

    IF m_apoc_ptf_utility IS NOT BOUND.
      m_apoc_ptf_utility = NEW #( ).
    ENDIF.

    DATA(item_key_as_bobf_table) = m_apoc_ptf_utility->convert_oc_key_to_bobf_key_tab( i_output_item_key = CONV #( i_item_key ) ).


    IF m_service_manager IS NOT BOUND.
      m_service_manager ?= /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = if_apoc_output_request_c=>sc_bo_key ).
    ENDIF.
    DATA(retrieved_items_from_bobf) = retrieve_item_from_bobf( item_key_as_bobf_table ).

    IF retrieved_items_from_bobf IS INITIAL.
      RAISE EXCEPTION TYPE cx_apoc_error_bobf_retrieve.
    ENDIF.

    READ TABLE retrieved_items_from_bobf INTO DATA(unchanged_item) INDEX 1.

    DATA(changed_item_reference) = assign_generic_attribute(
                             i_attribute_name = i_attribute_name
                             i_value          = i_value
                             i_item_structure = unchanged_item
                           ).


    DATA modification_table TYPE /bobf/t_frw_modification.
    modification_table = VALUE #(
                        ( node = if_apoc_output_request_c=>sc_node-item
                          change_mode =  /bobf/if_frw_c=>sc_modify_update
                          changed_fields = VALUE #( ( if_apoc_output_request_c=>sc_node_attribute-item-ux_fc_receiver_id ) )
                          key = unchanged_item-key
                          data = changed_item_reference  )
    ).


    m_service_manager->modify(
      EXPORTING
        it_modification = modification_table
      IMPORTING
      eo_change       = DATA(changed_items)
      eo_message      = DATA(message_object_during_modify)
    ).

    IF changed_items IS NOT BOUND.
      RAISE EXCEPTION TYPE cx_apoc_bobf_modify_failed.
    ENDIF.

    IF message_object_during_modify IS BOUND.
      message_object_during_modify->get_messages(
        IMPORTING
          et_message              = DATA(messages_during_modify)
      ).

      LOOP AT messages_during_modify ASSIGNING FIELD-SYMBOL(<message_during_modify>).
        IF <message_during_modify>-severity = 'E'.
          MESSAGE ID <message_during_modify>-message->if_t100_message~t100key-msgid
                  TYPE <message_during_modify>-severity
                  NUMBER <message_during_modify>-message->if_t100_message~t100key-msgno
                  WITH <message_during_modify>-message->if_t100_message~t100key-attr1
                  INTO DATA(msg_dummy).
          RAISE EXCEPTION TYPE cx_apoc_bobf_modify_failed.
        ENDIF.
      ENDLOOP.
    ENDIF.

    IF m_transaction_manager IS NOT BOUND.
      m_transaction_manager = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).
    ENDIF.
    m_transaction_manager->save(
       IMPORTING
        ev_rejected            = DATA(save_failed)
        eo_message             = DATA(messages_during_save)
    ).

    IF save_failed EQ abap_true.
      messages_during_save->get_messages(
        IMPORTING
          et_message              = DATA(message_table_from_save)
      ).
      RAISE EXCEPTION TYPE cx_apoc_bobf_save_failed.
    ENDIF.

    item_key_as_bobf_table = m_apoc_ptf_utility->convert_oc_key_to_bobf_key_tab( i_output_item_key = changed_item_reference->key ).

    DATA(modified_item) = retrieve_item_from_bobf( item_key_as_bobf_table ).

    IF m_item_validation IS NOT BOUND.
      m_item_validation = NEW apoc_ptf_validator( ).
    ENDIF.

    DATA attribute_value_pair TYPE if_apoc_ptf_item_validation=>ty_attribute_value_pair.
    attribute_value_pair-i_attribute_name = i_attribute_name.
    attribute_value_pair-i_value = i_value.

    IF m_item_validation->check_changed_attribute(
         i_attribute_value_pair = attribute_value_pair
         i_modified_item        = modified_item
       ) = abap_false.
      RAISE EXCEPTION TYPE cx_apoc_ptf_exception.
    ENDIF.

  ENDMETHOD.


  METHOD resend_output_item.

    DATA(item_key) = get_item_key(
                           i_application_obj_id = i_item_application_object_id
                           i_item_id            = i_item_id
                         ).

    IF m_apoc_ptf_utility IS NOT BOUND.
      m_apoc_ptf_utility = NEW #( ).
    ENDIF.

    DATA(item_key_in_bobf_table) = m_apoc_ptf_utility->convert_oc_key_to_bobf_key_tab( i_output_item_key = item_key ).

    IF m_service_manager IS NOT BOUND.
      m_service_manager ?= /bobf/cl_tra_serv_mgr_factory=>get_service_manager( iv_bo_key = if_apoc_output_request_c=>sc_bo_key ).
    ENDIF.

    DATA resent_item TYPE apoc_t_or_item.


    m_service_manager->do_action(
      EXPORTING
        iv_act_key              = if_apoc_output_request_c=>sc_action-item-resend
        it_key                  = item_key_in_bobf_table
      IMPORTING
        eo_change               = DATA(lo_change)
        eo_message              = DATA(lo_message)
        et_data                 = resent_item
    ).

    IF resent_item IS INITIAL.
      RAISE EXCEPTION TYPE cx_apoc_ptf_exception.
    ENDIF.

    DATA(resent_item_key_as_bobf_table) = m_apoc_ptf_utility->convert_item_tab_to_bobf_tab( i_output_item_table = resent_item ).

    "retrieve resent item and check if status = 1
    m_service_manager->retrieve(
      EXPORTING
        iv_node_key             = if_apoc_output_request_c=>sc_node-item
        it_key                  = resent_item_key_as_bobf_table
      IMPORTING
        eo_message              = lo_message
        eo_change               = lo_change
        et_data                 = resent_item
    ).

    READ TABLE resent_item INTO DATA(single_resent_item) INDEX 1.

    IF single_resent_item-status = 1.
      r_new_copy_of_item = VALUE #( ( key = single_resent_item-key ) ) .

      IF m_transaction_manager IS NOT BOUND.
        m_transaction_manager = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).
      ENDIF.
      m_transaction_manager->save(
       IMPORTING
        ev_rejected            = DATA(save_failed)
        eo_message             = DATA(messages_during_save)
    ).

    ELSE.
      RAISE EXCEPTION TYPE cx_apoc_ptf_exception.
    ENDIF.

  ENDMETHOD.


  METHOD retrieve_item_from_bobf.

*    DATA output_item_key_in_structure TYPE /bobf/s_frw_key.
*    output_item_key_in_structure-key = i_output_item_key.
*
*    DATA output_item_key_in_table  TYPE /bobf/t_frw_key.
*    INSERT output_item_key_in_structure INTO TABLE output_item_key_in_table.

    m_service_manager->retrieve(
      EXPORTING
        iv_node_key             = if_apoc_output_request_c=>sc_node-item
        it_key                  = i_bobf_key_table
      IMPORTING
        eo_message              = DATA(messages_from_bobf_retrieve)
        et_failed_key           = DATA(failed_item_keys)
        et_data                 = r_retrieved_items_from_bobf
    ).

    IF failed_item_keys IS NOT INITIAL.
      RAISE EXCEPTION TYPE cx_apoc_error_bobf_retrieve.
    ENDIF.

    IF messages_from_bobf_retrieve IS BOUND.
      messages_from_bobf_retrieve->get_messages(
        IMPORTING
          et_message              =    DATA(messages_from_retrieval)
      ).

      LOOP AT messages_from_retrieval ASSIGNING FIELD-SYMBOL(<message>).
        IF <message>-severity = 'E'.
          MESSAGE ID <message>-message->if_t100_message~t100key-msgid
          TYPE <message>-severity
          NUMBER <message>-message->if_t100_message~t100key-msgno
          WITH <message>-message->if_t100_message~t100key-attr1
          INTO DATA(msg_dummy).
          RAISE EXCEPTION TYPE cx_apoc_error_bobf_retrieve.
        ENDIF.
      ENDLOOP.

    ENDIF.
  ENDMETHOD.
ENDCLASS.
