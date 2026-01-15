class CL_PTF_RAP_MODIFY_TEMPLATE definition
  public
  final
  create public .

public section.

  class-methods GENERATE
    importing
      !IV_ENTITY type ABP_ENTITY_NAME
      !IV_JSON_OPT type PTF_JSON_OPT default '2'
    returning
      value(RV_JSON) type STRING .
  PROTECTED SECTION.
private section.

  class-methods GENERATE_CREATE_TEMPLATE
    importing
      !IV_ENTITY type ABP_ENTITY_NAME
      !IT_ENTITIES type CL_ABAP_BEHV_LOAD=>TT_ENTITY
      !IT_ASSOCIATIONS type CL_ABAP_BEHV_LOAD=>TT_ASSOC
      !IT_PERMISSIONS type ABP_BEHV_PERMISSIONS_TAB
      !IV_JSON_OPT type PTF_JSON_OPT
    returning
      value(RV_JSON) type STRING .
  class-methods GENERATE_UPDATE_TEMPLATE
    importing
      !IV_ENTITY type ABP_ENTITY_NAME
      !IT_ENTITIES type CL_ABAP_BEHV_LOAD=>TT_ENTITY
      !IT_PERMISSIONS type ABP_BEHV_PERMISSIONS_TAB
      !IV_JSON_OPT type PTF_JSON_OPT
    returning
      value(RV_JSON) type STRING .
  class-methods GENERATE_DELETE_TEMPLATE
    importing
      !IV_ENTITY type ABP_ENTITY_NAME
      !IT_ENTITIES type CL_ABAP_BEHV_LOAD=>TT_ENTITY
    returning
      value(RV_JSON) type STRING .
  class-methods GET_ENTITY_FIELDS
    importing
      !IV_ENTITY type ABP_ENTITY_NAME
      !IT_PERMISSIONS type ABP_BEHV_PERMISSIONS_TAB
      !IV_ONLY_KEYS type ABAP_BOOL default ABAP_OFF
    returning
      value(RV_FIELDS_JSON) type STRING .
ENDCLASS.



CLASS CL_PTF_RAP_MODIFY_TEMPLATE IMPLEMENTATION.


  METHOD generate.
*   Generate JSON template for MODIFY action based on BDEF metadata
    DATA: lt_entities     TYPE cl_abap_behv_load=>tt_entity,
          lt_associations TYPE cl_abap_behv_load=>tt_assoc,
          lt_actions      TYPE cl_abap_behv_load=>tt_action,
          lt_permissions  TYPE abp_behv_permissions_tab,
          ls_entity       TYPE cl_abap_behv_load=>t_entity.

*   Load BDEF metadata
    cl_abap_behv_load=>get_load(
      EXPORTING
        entity       = iv_entity
        all          = abap_on
      IMPORTING
        entities     = lt_entities
        associations = lt_associations
        actions      = lt_actions
    ).

*   Check if entity exists
    IF NOT line_exists( lt_entities[ name = iv_entity ] ).
      rv_json = |[\{"_comment":"Entity { iv_entity } not found in BDEF"\}]|.
      RETURN.
    ENDIF.

    ls_entity = lt_entities[ name = iv_entity ].

*   Get permissions
    cl_ptf_json=>get_permissions(
      EXPORTING
        iv_entity       = iv_entity
        it_entities     = lt_entities
        it_associations = lt_associations
      IMPORTING
        et_permissions  = lt_permissions
    ).

*   Build template with multiple operation examples
    rv_json = |[{ cl_abap_char_utilities=>newline }|.
    rv_json = |{ rv_json }  \{|.
    rv_json = |{ rv_json }"_comment": "JSON MODIFY Example for RAP BO { ls_entity-ext_name } - see docs/EML_MODIFY.md for full syntax"|.
    rv_json = |{ rv_json }\},{ cl_abap_char_utilities=>newline }|.

*   Add CREATE example if entity supports create
    IF ls_entity-properties-has_create = cl_abap_behv_load=>c_enabled
      OR ls_entity-properties-has_create = cl_abap_behv_load=>c_enabled_both.

      DATA(lv_create_json) = generate_create_template(
        iv_entity       = iv_entity
        it_entities     = lt_entities
        it_associations = lt_associations
        it_permissions  = lt_permissions
        iv_json_opt     = iv_json_opt ).

      rv_json = |{ rv_json }{ lv_create_json }|.

    ENDIF.

*   Add UPDATE example if entity supports update
    IF ls_entity-properties-has_update = cl_abap_behv_load=>c_enabled
      OR ls_entity-properties-has_update = cl_abap_behv_load=>c_enabled_both.

      IF ls_entity-properties-has_create = cl_abap_behv_load=>c_enabled
        OR ls_entity-properties-has_create = cl_abap_behv_load=>c_enabled_both.
        rv_json = |{ rv_json },{ cl_abap_char_utilities=>newline }|.
      ENDIF.

      DATA(lv_update_json) = generate_update_template(
        iv_entity      = iv_entity
        it_entities    = lt_entities
        it_permissions = lt_permissions
        iv_json_opt    = iv_json_opt ).

      rv_json = |{ rv_json }{ lv_update_json }|.

    ENDIF.

*   Add DELETE example if entity supports delete
    IF ls_entity-properties-has_delete = cl_abap_behv_load=>c_enabled
      OR ls_entity-properties-has_delete = cl_abap_behv_load=>c_enabled_both.

      IF ls_entity-properties-has_create = cl_abap_behv_load=>c_enabled
        OR ls_entity-properties-has_create = cl_abap_behv_load=>c_enabled_both
        OR ls_entity-properties-has_update = cl_abap_behv_load=>c_enabled
        OR ls_entity-properties-has_update = cl_abap_behv_load=>c_enabled_both.
        rv_json = |{ rv_json },{ cl_abap_char_utilities=>newline }|.
      ENDIF.

      DATA(lv_delete_json) = generate_delete_template(
        iv_entity   = iv_entity
        it_entities = lt_entities ).

      rv_json = |{ rv_json }{ lv_delete_json }|.

    ENDIF.

    rv_json = |{ rv_json }{ cl_abap_char_utilities=>newline }]|.

  ENDMETHOD.


  METHOD generate_create_template.
*   Generate CREATE operation template
    DATA: ls_entity TYPE cl_abap_behv_load=>t_entity.

    ls_entity = it_entities[ name = iv_entity ].

    rv_json = |  \{{ cl_abap_char_utilities=>newline }|.
    rv_json = |{ rv_json }    "op": "CREATE",{ cl_abap_char_utilities=>newline }|.
    rv_json = |{ rv_json }    "entity": "{ ls_entity-ext_name }",{ cl_abap_char_utilities=>newline }|.
    rv_json = |{ rv_json }    "instances": [{ cl_abap_char_utilities=>newline }|.
    rv_json = |{ rv_json }      \{{ cl_abap_char_utilities=>newline }|.

*   Add optional ref field
    rv_json = |{ rv_json }        "ref": "new-1",{ cl_abap_char_utilities=>newline }|.

*   Add entity fields
    DATA(lv_fields) = get_entity_fields(
      iv_entity      = iv_entity
      it_permissions = it_permissions
      iv_only_keys   = COND #( WHEN iv_json_opt = '1' THEN abap_on ELSE abap_off ) ).

    rv_json = |{ rv_json }{ lv_fields }|.

    rv_json = |{ rv_json }      \}{ cl_abap_char_utilities=>newline }|.
    rv_json = |{ rv_json }    ]{ cl_abap_char_utilities=>newline }|.
    rv_json = |{ rv_json }  \}|.

  ENDMETHOD.


  METHOD generate_update_template.
*   Generate UPDATE operation template
    DATA: ls_entity TYPE cl_abap_behv_load=>t_entity.

    ls_entity = it_entities[ name = iv_entity ].

    rv_json = |  \{{ cl_abap_char_utilities=>newline }|.
    rv_json = |{ rv_json }    "op": "UPDATE",{ cl_abap_char_utilities=>newline }|.
    rv_json = |{ rv_json }    "entity": "{ ls_entity-ext_name }",{ cl_abap_char_utilities=>newline }|.
    rv_json = |{ rv_json }    "instances": [{ cl_abap_char_utilities=>newline }|.
    rv_json = |{ rv_json }      \{{ cl_abap_char_utilities=>newline }|.

*   Add key structure
    rv_json = |{ rv_json }        "key": \{{ cl_abap_char_utilities=>newline }|.

    DATA(lv_keys) = get_entity_fields(
      iv_entity      = iv_entity
      it_permissions = it_permissions
      iv_only_keys   = abap_on ).

    rv_json = |{ rv_json }{ lv_keys }|.
    rv_json = |{ rv_json }        \},{ cl_abap_char_utilities=>newline }|.

*   Add fields to update
    DATA(lv_fields) = get_entity_fields(
      iv_entity      = iv_entity
      it_permissions = it_permissions
      iv_only_keys   = COND #( WHEN iv_json_opt = '1' THEN abap_on ELSE abap_off ) ).

    rv_json = |{ rv_json }{ lv_fields }|.

    rv_json = |{ rv_json }      \}{ cl_abap_char_utilities=>newline }|.
    rv_json = |{ rv_json }    ]{ cl_abap_char_utilities=>newline }|.
    rv_json = |{ rv_json }  \}|.

  ENDMETHOD.


  METHOD generate_delete_template.
*   Generate DELETE operation template
    DATA: ls_entity TYPE cl_abap_behv_load=>t_entity.

    ls_entity = it_entities[ name = iv_entity ].

    rv_json = |  \{{ cl_abap_char_utilities=>newline }|.
    rv_json = |{ rv_json }    "op": "DELETE",{ cl_abap_char_utilities=>newline }|.
    rv_json = |{ rv_json }    "entity": "{ ls_entity-ext_name }",{ cl_abap_char_utilities=>newline }|.
    rv_json = |{ rv_json }    "instances": [{ cl_abap_char_utilities=>newline }|.
    rv_json = |{ rv_json }      \{{ cl_abap_char_utilities=>newline }|.

*   Only key fields for DELETE
    rv_json = |{ rv_json }        "key": \{{ cl_abap_char_utilities=>newline }|.

    DATA(lv_keys) = get_entity_fields(
      iv_entity      = iv_entity
      it_permissions = VALUE #( )  "No permissions needed for key display
      iv_only_keys   = abap_on ).

    rv_json = |{ rv_json }{ lv_keys }|.
    rv_json = |{ rv_json }        \}{ cl_abap_char_utilities=>newline }|.

    rv_json = |{ rv_json }      \}{ cl_abap_char_utilities=>newline }|.
    rv_json = |{ rv_json }    ]{ cl_abap_char_utilities=>newline }|.
    rv_json = |{ rv_json }  \}|.

  ENDMETHOD.


  METHOD get_entity_fields.
*   Get entity fields as JSON string, prioritizing non-read-only fields
    DATA: lo_struct_descr  TYPE REF TO cl_abap_structdescr,
          lt_components    TYPE abap_component_tab,
          lv_field_count   TYPE i,
          ls_permission    TYPE abp_behv_permissions,
          lr_result        TYPE REF TO data,
          lr_global        TYPE REF TO data.

    FIELD-SYMBOLS: <fs_component>     TYPE abap_componentdescr,
                   <fs_result>        TYPE any,
                   <fs_global>        TYPE any,
                   <fs_field_control> TYPE any.

*   Get entity structure
    TRY.
        lr_result = cl_abap_behvdescr=>create_data(
          p_name      = iv_entity
          p_op        = cl_abap_behvdescr=>op_primarykey
          p_structure = abap_on ).
        lo_struct_descr ?= cl_abap_typedescr=>describe_by_data_ref( lr_result ).
        lt_components = lo_struct_descr->get_components( ).

      CATCH cx_abap_behvdescr cx_sy_move_cast_error.
        rv_fields_json = |        "field": "value"{ cl_abap_char_utilities=>newline }|.
        RETURN.
    ENDTRY.

*   Get key fields
    DATA(lt_key_fields) = cl_ptf_rap_metadata=>get_instance( )->get_key_fields( iv_name = iv_entity ).

*   Get permissions for filtering
    IF it_permissions IS NOT INITIAL.
      READ TABLE it_permissions INTO ls_permission WITH KEY entity_name = iv_entity.
      IF sy-subrc = 0 AND ls_permission-results IS BOUND.
        ASSIGN ls_permission-results->* TO <fs_result>.
        IF sy-subrc = 0.
          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-global OF STRUCTURE <fs_result> TO <fs_global>.
          IF sy-subrc = 0.
            ASSIGN <fs_global>->* TO lr_global.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

*   Build fields JSON - prioritize non-read-only fields
    LOOP AT lt_components ASSIGNING <fs_component>.
*     Skip technical fields
      IF <fs_component>-name = cl_abap_behv=>co_techfield_name-cid
        OR <fs_component>-name = cl_abap_behv=>co_techfield_name-cid_ref
        OR <fs_component>-name = cl_abap_behv=>co_techfield_name-pid
        OR <fs_component>-name = cl_abap_behv=>co_techfield_name-control
        OR <fs_component>-name = cl_abap_behv=>co_techfield_name-param
        OR <fs_component>-name = cl_abap_behv=>co_techfield_name-is_draft.
        CONTINUE.
      ENDIF.

*     If only keys requested, skip non-key fields
      IF iv_only_keys = abap_on.
        IF NOT line_exists( lt_key_fields[ name = <fs_component>-name ] ).
          CONTINUE.
        ENDIF.
      ENDIF.

*     Check if field is read-only via permissions
      DATA(lv_is_read_only) = abap_off.
      IF lr_global IS BOUND.
        ASSIGN COMPONENT <fs_component>-name OF STRUCTURE lr_global TO <fs_field_control>.
        IF sy-subrc = 0.
          IF <fs_field_control> = if_abap_behv=>fc-f-read_only.
            lv_is_read_only = abap_on.
          ENDIF.
        ENDIF.
      ENDIF.

*     Skip read-only fields unless we're showing keys only
      IF lv_is_read_only = abap_on AND iv_only_keys = abap_off.
        CONTINUE.
      ENDIF.

*     Add field to JSON
      lv_field_count = lv_field_count + 1.

      IF lv_field_count > 1.
        rv_fields_json = |{ rv_fields_json },{ cl_abap_char_utilities=>newline }|.
      ENDIF.

      rv_fields_json = |{ rv_fields_json }        "{ <fs_component>-name }": ""|.

*     Limit number of fields in template
      IF lv_field_count >= 5 AND iv_only_keys = abap_off.
        rv_fields_json = |{ rv_fields_json }{ cl_abap_char_utilities=>newline }        "_comment": "...add more fields as needed"|.
        EXIT.
      ENDIF.

    ENDLOOP.

    IF rv_fields_json IS INITIAL.
      rv_fields_json = |        "field": "value"|.
    ENDIF.

    rv_fields_json = |{ rv_fields_json }{ cl_abap_char_utilities=>newline }|.

  ENDMETHOD.
ENDCLASS.
