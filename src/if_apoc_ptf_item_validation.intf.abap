INTERFACE if_apoc_ptf_item_validation
  PUBLIC .

  TYPES: BEGIN OF ty_attribute_value_pair,
           i_attribute_name TYPE string,
           i_value          TYPE string,
         END OF ty_attribute_value_pair,

         BEGIN OF ty_item_comparison,
           actual_items TYPE /bobf/t_conf_key,
           expected_items TYPE /bobf/t_conf_key,
         END OF ty_item_comparison.


  METHODS:

    check_changed_attribute
      IMPORTING
                i_attribute_value_pair         TYPE ty_attribute_value_pair
                i_modified_item                TYPE apoc_t_or_item
      RETURNING VALUE(r_has_attribute_changed) TYPE abap_bool,

    compare_items
      IMPORTING
        i_items_to_compare TYPE ty_item_comparison
      RETURNING
        VALUE(r_is_equal) TYPE abap_bool.

ENDINTERFACE.
