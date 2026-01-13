CLASS apoc_ptf_validator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES: if_apoc_ptf_item_validation.
    methods:
      validate_create_output_request
        importing
          failed_roots  type if_apoc_or_h_api=>ty_gt_failed_object
          messages_from_oc_api  type ref to /bobf/if_frw_message
        raising cx_apoc_ptf_exception,
      validate_bopf_save
        importing
          is_rejected  type boole_d
          change  type ref to /bobf/if_tra_change
          messages  type ref to /bobf/if_frw_message
          rejected_keys  type /bobf/t_frw_key2
        raising cx_apoc_ptf_exception.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS APOC_PTF_VALIDATOR IMPLEMENTATION.


  METHOD if_apoc_ptf_item_validation~check_changed_attribute.
    READ TABLE i_modified_item ASSIGNING FIELD-SYMBOL(<modified_item>) INDEX 1.

    ASSIGN COMPONENT i_attribute_value_pair-i_attribute_name OF STRUCTURE <modified_item> TO FIELD-SYMBOL(<attribute>).

    IF <attribute> IS ASSIGNED.
      IF i_attribute_value_pair-i_value = <attribute>.
        r_has_attribute_changed = abap_true.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD if_apoc_ptf_item_validation~compare_items.

  ENDMETHOD.


  METHOD validate_bopf_save.

  ENDMETHOD.


  METHOD validate_create_output_request.

  ENDMETHOD.
ENDCLASS.
