INTERFACE if_apoc_ptf_bo_root
  PUBLIC .

  METHODS:
    "! <p class="shorttext synchronized" lang="en"></p>
    "! Determines and returns output items of an Output Request Root
    "! @parameter i_root_application_object_id | <p class="shorttext synchronized" lang="en"> Application Object ID</p>
    "! @parameter r_determined_item_keys | <p class="shorttext synchronized" lang="en">Key table of the determined output items</p>
    "! @raising cx_apoc_ptf_determination | <p class="shorttext synchronized" lang="en"></p>
    determine_items
      IMPORTING
                i_root_application_object_id  TYPE apoc_appl_object_id
      RETURNING VALUE(r_determined_item_keys) TYPE /bobf/t_conf_key
      RAISING   cx_apoc_ptf_determination,

    "! <p class="shorttext synchronized" lang="en">Create Output Request roots with items</p>
    "!
    "! @raising cx_apoc_ptf_exception | <p class="shorttext synchronized" lang="en"></p>
    create_root_with_items
      RAISING
        cx_apoc_ptf_exception,

    create_root_without_items,

    create_manual_items
      IMPORTING
        i_items TYPE apoc_t_or_item
      RETURNING VALUE(result) TYPE /bobf/t_conf_key
      RAISING
        cx_apoc_ptf_exception,

    check_existence
      IMPORTING
        i_root TYPE apoc_t_or_root,

    validate_created_roots
      IMPORTING
        i_created_roots TYPE apoc_t_or_root
        i_wanted_roots  TYPE apoc_t_or_root
        RAISING cx_apoc_ptf_exception,

    get_items_in_preparation
      IMPORTING
        application_object_id TYPE apoc_appl_object_id
      RETURNING VALUE(item_keys) TYPE /bobf/t_conf_key
      RAISING
        cx_apoc_ptf_exception.

ENDINTERFACE.
