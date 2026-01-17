CLASS cl_ptf_rap_modify_formatter DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS format_json
      IMPORTING
        iv_entity TYPE abp_entity_name
      CHANGING
        cv_json   TYPE string .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS cl_ptf_rap_modify_formatter IMPLEMENTATION.


  METHOD format_json.
*   Pretty printer for MODIFY action JSON format
*   MODIFY uses EML operations array: [{"op":"CREATE","entity":"...","instances":[...]}]
*   Uses /ui2/cl_json for formatting with entity/action/field name replacements
    DATA: lr_data TYPE REF TO data,
          lt_components TYPE cl_abap_structdescr=>component_table.

*   Load entity metadata to replace internal names with external names
    cl_abap_behv_load=>get_load(
      EXPORTING
        entity   = iv_entity
        all      = abap_on
      IMPORTING
        entities = DATA(lt_entities)
        actions  = DATA(lt_actions) ).

*   Get field structure to replace field names
    TRY.
        DATA(lo_struct_descr) = CAST cl_abap_structdescr(
          cl_abap_behvdescr=>get_type(
            p_structure = abap_true
            p_name      = iv_entity
            p_op        = if_abap_behv=>op-m-update ) ).
        lt_components = lo_struct_descr->get_components( ).
      CATCH cx_root.
*       If field metadata unavailable, continue without field name replacement
    ENDTRY.

*   Use /ui2/cl_json to format the JSON with proper indentation
    TRY.
        /ui2/cl_json=>deserialize(
          EXPORTING
            json = cv_json
          CHANGING
            data = lr_data ).

        cv_json = /ui2/cl_json=>serialize(
          data          = lr_data
          compress      = abap_false
          format_output = abap_true ).

      CATCH cx_root.
*       If formatting fails, return original JSON
        RETURN.
    ENDTRY.

*   Replace internal entity names with external names in formatted JSON
*   Must be done AFTER serialization because /ui2/cl_json uppercases all names
    LOOP AT lt_entities ASSIGNING FIELD-SYMBOL(<fs_entity>).
      cv_json = replace( val = cv_json pcre = to_upper( <fs_entity>-name ) with = <fs_entity>-ext_name case = abap_false occ = 0 ).
    ENDLOOP.

*   Replace internal action names with external names
    LOOP AT lt_actions ASSIGNING FIELD-SYMBOL(<fs_action>).
      cv_json = replace( val = cv_json pcre = to_upper( <fs_action>-name ) with = <fs_action>-ext_name case = abap_false occ = 0 ).
    ENDLOOP.

*   Replace internal field names with external names (using component-suffix for external name)
    LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
      IF <fs_component>-suffix IS NOT INITIAL.
*       suffix contains the external name from CDS annotations
        cv_json = replace( val = cv_json pcre = to_upper( <fs_component>-name ) with = <fs_component>-suffix case = abap_false occ = 0 ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
