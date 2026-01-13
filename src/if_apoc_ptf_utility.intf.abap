INTERFACE if_apoc_ptf_utility
  PUBLIC .
  METHODS:

    convert_oc_key_to_bobf_key_tab
      IMPORTING
                i_output_key            TYPE /bobf/conf_key
      RETURNING VALUE(r_bobf_key_table) TYPE /bobf/t_frw_key
      RAISING      cx_apoc_ptf_conv_to_bobf_tab ,

    get_or_root_key
      IMPORTING
        i_application_obj_id TYPE apoc_appl_object_id
      RETURNING
        VALUE(r_or_root_key) TYPE apoc_s_or_root-key
      RAISING
        cx_apoc_root_does_not_exist.
ENDINTERFACE.
