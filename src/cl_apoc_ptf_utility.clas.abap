CLASS cl_apoc_ptf_utility DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_apoc_ptf_utility.

    METHODS:
      convert_oc_key_to_bobf_key_tab
        IMPORTING
                  i_output_item_key       TYPE apoc_s_or_item-key
        RETURNING VALUE(r_bobf_key_table) TYPE /bobf/t_frw_key ,
      convert_item_tab_to_bobf_tab
        IMPORTING
                  i_output_item_table     TYPE apoc_t_or_item
        RETURNING VALUE(r_bobf_key_table) TYPE /bobf/t_frw_key.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS CL_APOC_PTF_UTILITY IMPLEMENTATION.


  METHOD convert_item_tab_to_bobf_tab.
    DATA bobf_structure TYPE /bobf/s_frw_key.

    LOOP AT i_output_item_table INTO DATA(output_item).
      bobf_structure-key  = output_item-key.
      INSERT bobf_structure INTO TABLE r_bobf_key_table.
    ENDLOOP.
  ENDMETHOD.


  METHOD convert_oc_key_to_bobf_key_tab.

    DATA output_item_key_in_structure TYPE /bobf/s_frw_key.
    output_item_key_in_structure-key = i_output_item_key.

    INSERT output_item_key_in_structure INTO TABLE r_bobf_key_table.
  ENDMETHOD.


  METHOD if_apoc_ptf_utility~convert_oc_key_to_bobf_key_tab.
    DATA output_key_as_structure TYPE /bobf/s_frw_key.
    output_key_as_structure-key = i_output_key.

    INSERT output_key_as_structure INTO TABLE r_bobf_key_table.

    IF r_bobf_key_table IS INITIAL.
      RAISE EXCEPTION NEW  cx_apoc_ptf_conv_to_bobf_tab( msgid = |APOC_PTF_MSG| msgno = 1 msgty = |E| ).
    ENDIF.
  ENDMETHOD.


  METHOD if_apoc_ptf_utility~get_or_root_key.
    SELECT SINGLE db_key                                "#EC CI_NOFIRST
           FROM apoc_d_or_root                          "#EC CI_NOORDER
           INTO r_or_root_key
           WHERE appl_object_id = i_application_obj_id.
    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW cx_apoc_root_does_not_exist( msgid = |APOC_PTF_MSG| msgno = 0 msgty = |E| ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
