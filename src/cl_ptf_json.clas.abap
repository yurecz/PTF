class CL_PTF_JSON definition
  public
  final
  create public .

public section.

  class-methods DESERIALIZE
    importing
      !IV_ENTITY type ABP_ENTITY_NAME
      !IV_ACTION type ABP_ACTION_NAME
      !IV_JSON type STRING
    exporting
      value(ER_DATA) type ref to DATA
    raising
      CX_PTF_JSON .
  class-methods VALIDATE_JSON
    importing
      !IV_JSON type STRING
    raising
      CX_PTF_JSON .
  class-methods GENERATE_SAMPLE_JSON
    importing
      !IV_PTF_BO type PTF_BO
      !IV_PTF_ACT type PTF_ACT
      !IV_PTF_JSON_OPT type PTF_JSON_OPT default '2'
    returning
      value(RV_JSON) type STRING .
  class-methods CONVERT_OPERATIONS_READ
    importing
      !IT_OPERATIONS_READ type ABP_BEHV_RETRIEVALS_TAB
      !IV_ENTITY type ABP_ENTITY_NAME
    exporting
      value(ER_DATA) type ref to DATA
    raising
      CX_PTF_JSON .
  class-methods PRETTY_PRINTER
    importing
      !IV_ENTITY type ABP_ENTITY_NAME
    changing
      !CV_JSON type STRING .
  class-methods PRETTY_PRINTER_TDO
    changing
      !CV_JSON type STRING .
  class-methods CLASS_CONSTRUCTOR .
  class-methods CLEANUP_JSON
    changing
      !CV_JSON type STRING .
  class-methods CONVERT_KEYS
    importing
      !IR_DATA type ref to DATA
    exporting
      !ER_DATA type ref to DATA
    raising
      CX_PTF_JSON .
  class-methods COUNT_INSTANCES
    importing
      !IV_JSON type STRING
    returning
      value(RV_INSTANCES) type INT4 .
  PROTECTED SECTION.
private section.

  types:
    BEGIN OF ts_fields,
      name  TYPE string,
      value TYPE string,
    END OF ts_fields .
  types:
    tt_fields TYPE STANDARD TABLE OF ts_fields WITH DEFAULT KEY .
  types:
    BEGIN OF ts_params,
      name  TYPE string,
      value TYPE REF TO data,
    END OF ts_params .
  types:
    tt_params TYPE STANDARD TABLE OF ts_params WITH DEFAULT KEY .
  types:
    BEGIN OF ts_operators,
      name  TYPE string,
      operator TYPE string,
    END OF ts_operators .
  types:
    tt_operators TYPE STANDARD TABLE OF ts_operators WITH DEFAULT KEY .
  types:
    BEGIN OF ts_initials,
      name  TYPE string,
      initial TYPE string,
    END OF ts_initials .
  types:
    tt_initials TYPE STANDARD TABLE OF ts_initials WITH DEFAULT KEY .
  types:
    BEGIN OF ts_associations,
      assocname       TYPE string,
      childentityname TYPE string,
      fields          TYPE tt_fields,
      operators       TYPE tt_operators,
      initials        TYPE tt_initials,
      params          TYPE tt_params,
      ignore          TYPE abap_bool,
      id              TYPE sysuuid_c32,
      parent_id       TYPE sysuuid_c32,
    END OF ts_associations .
  types:
    tt_associations TYPE STANDARD TABLE OF ts_associations WITH DEFAULT KEY .
  types:
    BEGIN OF ts_data,
      fields       TYPE tt_fields,
      operators    TYPE tt_operators,
      initials     TYPE tt_initials,
      params       TYPE tt_params,
      ignore       TYPE abap_bool,
      associations TYPE tt_associations,
    END OF ts_data .
  types:
    TT_ASSOC TYPE STANDARD TABLE OF cl_abap_behv_load=>t_assoc WITH DEFAULT KEY .
  types:
    TT_FEATURE TYPE STANDARD TABLE OF cl_abap_behv_load=>t_feature WITH DEFAULT KEY .

  class-data MO_PTF_RAP_METADATA type ref to IF_PTF_RAP_METADATA .

  class-methods GENERATE_JSON_FIELDS
    importing
      !IV_ENTITY type ABP_ENTITY_NAME
      !IV_PTF_ACT type PTF_ACT
      !IV_PTF_JSON_OPT type PTF_JSON_OPT default '2'
      !IV_LAST type ABAP_BOOL default ABAP_ON
      !IT_PERMISSIONS type ABP_BEHV_PERMISSIONS_TAB
      !IT_ENTITIES type CL_ABAP_BEHV_LOAD=>TT_ENTITY
      !IT_ACTIONS type CL_ABAP_BEHV_LOAD=>TT_ACTION
      !IT_FEATURES type CL_ABAP_BEHV_LOAD=>TT_FEATURE
      !IV_NESTING_LEVEL type INT4 default 1
    changing
      !CT_ASSOCIATIONS type CL_ABAP_BEHV_LOAD=>TT_ASSOC
      !CV_JSON type STRING .
  class-methods RECURSIVE_FILL_ASSOCIATIONS
    importing
      !IS_DATA type DATA
      !IV_PARENT_ID type SYSUUID_C32 optional
      !IV_ACTION type ABP_ACTION_NAME
    changing
      !CT_ASSOCIATIONS type TT_ASSOCIATIONS .
  class-methods RECURSIVE_GEN_DATA_STRUCTURE
    importing
      !IV_PARENT_ID type SYSUUID_C32 optional
      !IT_ASSOCIATIONS type TT_ASSOCIATIONS
    changing
      !CT_COMPONENT_TAB type ABAP_COMPONENT_TAB
    raising
      CX_PTF_JSON .
  class-methods RECURSIVE_FILL_DATA_STRUCTURE
    importing
      !IV_PARENT_ID type SYSUUID_C32 optional
      !IV_CHILDENTITYNAME type STRING optional
      !IS_DATA type TS_DATA
    changing
      !CR_DATA type ref to DATA .
  class-methods RECURSIVE_GEN_PARAMS
    importing
      !IS_COMPONENTDESCR type ABAP_COMPONENTDESCR
      !IT_ASSOCIATIONS type CL_PTF_JSON=>TT_ASSOC
      !IT_FEATURES type CL_PTF_JSON=>TT_FEATURE
      !IV_SOURCE_ENTITY type ABP_ENTITY_NAME
    changing
      !CV_JSON type STRING .
  class-methods RECURSIVE_FILL_PARAMS
    importing
      !IR_DATA type ref to DATA
    exporting
      !ER_DATA type ref to DATA
    raising
      CX_PTF_JSON .
  class-methods ADD_KEY_FIELDS
    importing
      !IV_ENTITY type ABP_ENTITY_NAME
      !IV_ACTION type ABP_ACTION_NAME optional
      !IV_ROOT type ABAP_BOOL default ABAP_OFF
    changing
      !CT_FIELDS type TT_FIELDS .
  class-methods RECURSIVE_FILL_OPS_READ_ASSOCS
    importing
      !IT_OPERATIONS_READ type ABP_BEHV_RETRIEVALS_TAB
      !IT_ASSOCIATIONS type CL_ABAP_BEHV_LOAD=>TT_ASSOC
      !IV_NAME type ABP_ENTITY_NAME optional
      !IV_PARENT_ID type SYSUUID_C32 optional
    changing
      !CT_ASSOCIATIONS type TT_ASSOCIATIONS .
  class-methods CONVERT_OPS_READ_INSTANCE
    importing
      !IT_OPERATIONS_READ type ABP_BEHV_RETRIEVALS_TAB
      !IV_ENTITY type ABP_ENTITY_NAME
    exporting
      value(ER_DATA) type ref to DATA
    raising
      CX_PTF_JSON .
  class-methods FILL_OP_READ_RESULT
    importing
      !IT_OPERATIONS_READ type ABP_BEHV_RETRIEVALS_TAB
      !IT_ASSOCIATIONS type CL_ABAP_BEHV_LOAD=>TT_ASSOC
      !IV_PARENT_ID type SYSUUID_C32 optional
      !IS_RESULT type ANY
      !IS_OPERATION_READ type ABP_BEHV_RETRIEVALS
    changing
      !CT_ASSOCIATIONS type TT_ASSOCIATIONS .
  class-methods HANDLE_EXCEPTION
    importing
      !IO_MESSAGE type ref to IF_MESSAGE
    raising
      CX_PTF_JSON .
  class-methods FILL_FIELDS
    importing
      !IS_DATA type ANY
    exporting
      !ET_FIELDS type TT_FIELDS .
  class-methods FILL_OPERATORS
    importing
      !IS_DATA type ANY
    exporting
      !ET_OPERATORS type TT_OPERATORS .
  class-methods FILL_INITIALS
    importing
      !IS_DATA type ANY
    exporting
      !ET_INITIALS type TT_INITIALS .
  class-methods FILL_PARAMS
    importing
      !IS_DATA type ANY
    exporting
      !ET_PARAMS type TT_PARAMS
    raising
      CX_PTF_JSON .
  class-methods FILL_IGNORE
    importing
      !IS_DATA type ANY
    changing
      !CT_FIELDS type TT_FIELDS .
  class-methods FILL_ACTION
    importing
      !IS_DATA type ANY
    changing
      !CT_FIELDS type TT_FIELDS
      !CV_ACTION type ABP_ACTION_NAME .
  class-methods FILL_CHILDENTITYNAME
    importing
      !IS_DATA type ANY
    changing
      !CT_FIELDS type TT_FIELDS
      !CV_ENTITY type ABP_ENTITY_NAME .
  class-methods FILL_SIMULATION
    importing
      !IS_DATA type ANY
    changing
      !CT_FIELDS type TT_FIELDS .
  class-methods FILL_COMMIT
    importing
      !IS_DATA type ANY
    changing
      !CT_FIELDS type TT_FIELDS .
  class-methods FILL_ISEXISTING
    importing
      !IS_DATA type ANY
    changing
      !CT_FIELDS type TT_FIELDS .
  class-methods FILL_ISDRAFT
    importing
      !IS_DATA type ANY
    changing
      !CT_FIELDS type TT_FIELDS .
  class-methods FILL_MAXINSTANCES
    importing
      !IS_DATA type ANY
    changing
      !CT_FIELDS type TT_FIELDS .
  class-methods FILL_SOURCE
    changing
      !CT_FIELDS type TT_FIELDS .
  class-methods GENERATE_DATA
    importing
      !IS_DATA type TS_DATA
    exporting
      !ER_DATA type ref to DATA
    raising
      CX_PTF_JSON .
  class-methods FILTER_OPS_READ_RESULTS
    importing
      !IV_ENTITY type ABP_ENTITY_NAME
      !IS_RESULT type ANY
      !IT_OPERATIONS_READ type ABP_BEHV_RETRIEVALS_TAB
    exporting
      !ET_OPERATIONS_READ type ABP_BEHV_RETRIEVALS_TAB .
  class-methods GENERATE_PARAMS
    importing
      !IO_DATADESCR type ref to CL_ABAP_DATADESCR
      !IS_ACTION type CL_ABAP_BEHV_LOAD=>T_ACTION
    changing
      !CV_JSON type STRING .
  class-methods RECURSIVE_LOAD_PARAMS_FEATURES
    importing
      !IV_PARAMETER_TYPE type RBDEF_ACTION-PAR_TYPE_NAME
      !IV_STOP_RECURSION type ABAP_BOOL optional
    changing
      !CT_ASSOCIATIONS type CL_PTF_JSON=>TT_ASSOC
      !CT_FEATURES type CL_PTF_JSON=>TT_FEATURE .
  class-methods GET_PERMISSIONS
    importing
      !IV_ENTITY type ABP_ENTITY_NAME
      !IT_ENTITIES type CL_ABAP_BEHV_LOAD=>TT_ENTITY
      !IT_ASSOCIATIONS type CL_ABAP_BEHV_LOAD=>TT_ASSOC
    exporting
      !ET_PERMISSIONS type ABP_BEHV_PERMISSIONS_TAB .
ENDCLASS.



CLASS CL_PTF_JSON IMPLEMENTATION.


  METHOD add_key_fields.
*   Commented it because we need %PID to exist in the keys of the root entity
**   Skip if the action is CHECK or CHECK_IF_EXISTS
*    IF iv_action = 'CHECK'
*      OR iv_action = 'CHECK_IF_EXISTS'.
*      RETURN.
*
*    ENDIF.

*   Check if action is not factory
    IF NOT iv_action IS INITIAL.
      cl_abap_behv_load=>get_load(
        EXPORTING
          entity  = iv_entity
          all     = abap_off
        IMPORTING
          actions = DATA(lt_actions)
        RECEIVING
          result  = DATA(lv_result)
      ).
      IF lv_result <> cl_abap_behv_load=>ok.
        RETURN.

      ENDIF.

*     Don't add key fields for factory and static actions
      IF line_exists( lt_actions[ name = iv_action ] ).
        IF lt_actions[ name = iv_action ]-properties-is_static = abap_on.
*        IF lt_actions[ name = iv_action ]-properties-kind = cl_abap_behv_load=>c_action_factory
*          OR lt_actions[ name = iv_action ]-properties-is_static = abap_on.
          RETURN.

        ENDIF.

      ENDIF.

    ENDIF.

*   Push key fields if they don't exist
    DATA(lt_components) = mo_ptf_rap_metadata->get_key_fields( iv_name = iv_entity iv_virtual = abap_on ).

    LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
      IF NOT line_exists( ct_fields[ name = <fs_component>-name ] ).
        APPEND VALUE #( name = <fs_component>-name ) TO ct_fields.

      ENDIF.

    ENDLOOP.

*    CASE iv_action.
*      WHEN 'CHECK' OR 'CHECK_IF_EXISTS'.
**       Add %PID for the root entity if it exists
*        IF iv_root = abap_on.
*          IF line_exists( lt_components[ name = cl_abap_behv=>co_techfield_name-pid ] ).
*            IF NOT line_exists( ct_fields[ name = cl_abap_behv=>co_techfield_name-pid ] ).
*              APPEND VALUE #( name = cl_abap_behv=>co_techfield_name-pid ) TO ct_fields.
*
*            ENDIF.
*
*          ENDIF.
*
*        ENDIF.
*
*    ENDCASE.

  ENDMETHOD.


  METHOD class_constructor.
    mo_ptf_rap_metadata = NEW cl_ptf_rap_metadata( ).

  ENDMETHOD.


  METHOD cleanup_json.
    DATA: lv_xjson                TYPE xstring.

    CONSTANTS: "lc_to_replace   TYPE x LENGTH 2 VALUE '0B20',
      lc_to_replace   TYPE x LENGTH 3 VALUE 'E2808B', "Zero width space
      lc_nbs_to_replace TYPE x LENGTH 2 VALUE 'C2A0', "Non breaking space
      lc_replace_with TYPE x LENGTH 1 VALUE '20'.

*    REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf IN lv_json WITH space.

    DATA(lr_conv_out) = cl_abap_conv_out_ce=>create( ).

    lr_conv_out->convert( EXPORTING data = cv_json IMPORTING buffer = lv_xjson ).

*   Replace strange character 0B20 / E2808B that comes from copy / paste in Windows (zero width space)
    REPLACE ALL OCCURRENCES OF lc_to_replace IN lv_xjson WITH lc_replace_with IN BYTE MODE.

*   Replace strange character A000 / C2A0 that comes from copy / paste in Windows (non-break space)
    REPLACE ALL OCCURRENCES OF lc_nbs_to_replace IN lv_xjson WITH lc_replace_with IN BYTE MODE.

    DATA(lr_conv_in) = cl_abap_conv_in_ce=>create( ).

    lr_conv_in->convert( EXPORTING input = lv_xjson IMPORTING data = cv_json ).

  ENDMETHOD.


  METHOD convert_keys.
    DATA: lo_tabledescr     TYPE REF TO cl_abap_tabledescr,
          lo_structdescr    TYPE REF TO cl_abap_structdescr,
          lo_refdescr       TYPE REF TO cl_abap_refdescr,
          lr_data           TYPE REF TO data,
          lt_root_comp_tab  TYPE abap_component_tab,
          ls_componentdescr TYPE abap_componentdescr,
          ls_fields         TYPE ts_fields,
          ls_data           TYPE ts_data.

    FIELD-SYMBOLS: <fs_table>       TYPE STANDARD TABLE,
                   <fs_data_table>  TYPE STANDARD TABLE,
                   <fs_line>        TYPE any,
                   <fs_data>        TYPE any,
                   <fs_value>       TYPE any,
                   <fs_data_field>  TYPE ts_fields.

    CLEAR er_data.

    ASSIGN ir_data->* TO <fs_table>.

    LOOP AT <fs_table> ASSIGNING <fs_line>.
      CLEAR: lt_root_comp_tab, ls_data.

      lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_line> ).
      DATA(lt_components) = mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

      LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
        CLEAR ls_fields.

        ls_fields-name = <fs_component>-name.

        ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_line> TO <fs_value>.
        IF sy-subrc = 0.
          ls_fields-value = <fs_value>.

        ENDIF.

        APPEND ls_fields TO ls_data-fields.

      ENDLOOP.

*     Generate the dynamic ABAP data object
*     Generate the fields of the root entity
      LOOP AT ls_data-fields ASSIGNING <fs_data_field>.
        CLEAR: ls_componentdescr.

        ls_componentdescr = VALUE #( name = <fs_data_field>-name type = cl_abap_elemdescr=>get_string( ) ).

        APPEND ls_componentdescr TO lt_root_comp_tab.

      ENDLOOP.

      IF lt_root_comp_tab IS INITIAL.
        RAISE EXCEPTION TYPE cx_ptf_json MESSAGE ID 'PTF' TYPE 'E' NUMBER '071'.

      ENDIF.

      TRY.
          lo_structdescr = cl_abap_structdescr=>get( lt_root_comp_tab ).

        CATCH cx_sy_struct_comp_name INTO DATA(lx_sy_struct_comp_name).
          handle_exception( lx_sy_struct_comp_name ).

      ENDTRY.

      CREATE DATA lr_data TYPE HANDLE lo_structdescr.

      ASSIGN lr_data->* TO <fs_data>.

      LOOP AT ls_data-fields ASSIGNING <fs_data_field>.
        ASSIGN COMPONENT <fs_data_field>-name OF STRUCTURE <fs_data> TO <fs_value>.
        IF sy-subrc = 0.
          <fs_value> = <fs_data_field>-value.

        ENDIF.

      ENDLOOP.

      IF lo_tabledescr IS NOT BOUND.
*       Create references table
        lo_refdescr ?= cl_abap_refdescr=>describe_by_data( lr_data ).
        lo_tabledescr = cl_abap_tabledescr=>get( EXPORTING p_line_type = lo_refdescr ).

        CREATE DATA er_data TYPE HANDLE lo_tabledescr.

        ASSIGN er_data->* TO <fs_data_table>.

*        lo_tabledescr = cl_abap_tabledescr=>get( EXPORTING p_line_type = lo_structdescr ).
*
*        CREATE DATA er_data TYPE HANDLE lo_tabledescr.
*
*        ASSIGN er_data->* TO <fs_data_table>.

      ENDIF.

*      APPEND <fs_data> TO <fs_data_table>.

       APPEND lr_data TO <fs_data_table>.

    ENDLOOP.

  ENDMETHOD.


  METHOD convert_operations_read.
    DATA: lo_tabledescr       TYPE REF TO cl_abap_tabledescr,
          lo_refdescr         TYPE REF TO cl_abap_refdescr,
          lr_data             TYPE REF TO data,
          lt_operations_read  TYPE abp_behv_retrievals_tab.

    FIELD-SYMBOLS: <fs_data_table>     TYPE STANDARD TABLE,
                   <fs_operation_read> TYPE abp_behv_retrievals,
                   <fs_result>         TYPE any.

    IF line_exists( it_operations_read[ entity_name = iv_entity sub_name = space ] ). "Get root entity
      ASSIGN it_operations_read[ entity_name = iv_entity sub_name = space ] TO <fs_operation_read>.

      LOOP AT <fs_operation_read>-results->* ASSIGNING <fs_result>.
*        DATA(lt_operations_read) = it_operations_read.
        lt_operations_read = it_operations_read.

*       Keep only the entries corresponding of one instance
        cl_ptf_json=>filter_ops_read_results(
          EXPORTING
            iv_entity = iv_entity
            is_result = <fs_result>
            it_operations_read = it_operations_read
          IMPORTING
            et_operations_read = lt_operations_read
        ).

        cl_ptf_json=>convert_ops_read_instance(
          EXPORTING
            it_operations_read = lt_operations_read
            iv_entity          = iv_entity
          IMPORTING
            er_data            = lr_data
        ).

        IF lo_tabledescr IS NOT BOUND.
*         Create references table
          lo_refdescr ?= cl_abap_refdescr=>describe_by_data( lr_data ).
          lo_tabledescr = cl_abap_tabledescr=>get( EXPORTING p_line_type = lo_refdescr ).

          CREATE DATA er_data TYPE HANDLE lo_tabledescr.

          ASSIGN er_data->* TO <fs_data_table>.

        ENDIF.

        APPEND lr_data TO <fs_data_table>.

      ENDLOOP.

    ELSEIF line_exists( it_operations_read[ 1 ] ). "Start with associations
      ASSIGN it_operations_read[ 1 ] TO <fs_operation_read>.

      lt_operations_read = it_operations_read.

      cl_ptf_json=>convert_ops_read_instance(
        EXPORTING
          it_operations_read = lt_operations_read
          iv_entity          = iv_entity
        IMPORTING
          er_data            = lr_data
      ).

      IF lo_tabledescr IS NOT BOUND.
*       Create references table
        lo_refdescr ?= cl_abap_refdescr=>describe_by_data( lr_data ).
        lo_tabledescr = cl_abap_tabledescr=>get( EXPORTING p_line_type = lo_refdescr ).

        CREATE DATA er_data TYPE HANDLE lo_tabledescr.

        ASSIGN er_data->* TO <fs_data_table>.

      ENDIF.

      APPEND lr_data TO <fs_data_table>.

    ENDIF.

  ENDMETHOD.


  METHOD convert_ops_read_instance.
    DATA: lo_structdescr     TYPE REF TO cl_abap_structdescr,
          lt_root_comp_tab   TYPE abap_component_tab,
          ls_componentdescr  TYPE abap_componentdescr,
          ls_fields          TYPE ts_fields,
          ls_data            TYPE ts_data.

    FIELD-SYMBOLS: <fs_operation_read> TYPE abp_behv_retrievals,
                   <fs_result>         TYPE any,
                   <fs_value>          TYPE any,
                   <fs_data_field>     TYPE ts_fields.

*   Get metadata
    cl_abap_behv_load=>get_load(
      EXPORTING
        entity        = iv_entity
        all           = abap_on
      IMPORTING
        associations  = DATA(lt_associations)
    ).

    IF line_exists( it_operations_read[ entity_name = iv_entity sub_name = space ] ). "Get root entity
      ASSIGN it_operations_read[ entity_name = iv_entity sub_name = space ] TO <fs_operation_read>.

      LOOP AT <fs_operation_read>-results->* ASSIGNING <fs_result>.
*       Get associations
        cl_ptf_json=>recursive_fill_ops_read_assocs( EXPORTING it_operations_read  = it_operations_read
                                                               it_associations     = lt_associations
                                                               iv_name             = <fs_operation_read>-entity_name
                                                      CHANGING ct_associations     = ls_data-associations ).

        lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_result> ).
        DATA(lt_components) = mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

        LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
          CLEAR ls_fields.

          ls_fields-name = <fs_component>-name.

          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_result> TO <fs_value>.
          IF sy-subrc = 0.
            ls_fields-value = <fs_value>.

          ENDIF.

          APPEND ls_fields TO ls_data-fields.

        ENDLOOP.

        EXIT. "there should be only one entry

      ENDLOOP.

    ELSEIF line_exists( it_operations_read[ 1 ] ). "Start with associations
      TRY.
          DATA(lv_parent_id) = cl_system_uuid=>create_uuid_c32_static( ).

        CATCH cx_uuid_error ##NO_HANDLER.
      ENDTRY.

*     Get associations
      cl_ptf_json=>recursive_fill_ops_read_assocs( EXPORTING it_operations_read  = it_operations_read
                                                             it_associations     = lt_associations
                                                             "iv_name             = ls_read_operation-entity_name
                                                             iv_parent_id        = lv_parent_id
                                                    CHANGING ct_associations     = ls_data-associations ).

    ENDIF.

*   Generate the fields of the root entity
    LOOP AT ls_data-fields ASSIGNING <fs_data_field>.
      CLEAR: ls_componentdescr.

      ls_componentdescr = VALUE #( name = <fs_data_field>-name type = cl_abap_elemdescr=>get_string( ) ).

      APPEND ls_componentdescr TO lt_root_comp_tab.

    ENDLOOP.

    cl_ptf_json=>recursive_gen_data_structure( EXPORTING it_associations  = ls_data-associations
                                                         iv_parent_id     = lv_parent_id
                                               CHANGING  ct_component_tab = lt_root_comp_tab ).

**   Generate the fields of the root entity
*    LOOP AT ls_data-fields ASSIGNING <fs_data_field>.
*      CLEAR: ls_componentdescr.
*
*      ls_componentdescr = VALUE #( name = <fs_data_field>-name type = cl_abap_elemdescr=>get_string( ) ).
*
*      APPEND ls_componentdescr TO lt_root_comp_tab.
*
*    ENDLOOP.

    IF lt_root_comp_tab IS INITIAL.
      RAISE EXCEPTION TYPE cx_ptf_json MESSAGE ID 'PTF' TYPE 'E' NUMBER '071'.

    ENDIF.

    TRY.
        lo_structdescr = cl_abap_structdescr=>get( lt_root_comp_tab ).

      CATCH cx_sy_struct_comp_name INTO DATA(lx_sy_struct_comp_name).
        handle_exception( lx_sy_struct_comp_name ).

    ENDTRY.

    CREATE DATA er_data TYPE HANDLE lo_structdescr.

    ASSIGN er_data->* TO FIELD-SYMBOL(<fs_data>).

*   Fill the generated structure with data
    cl_ptf_json=>recursive_fill_data_structure( EXPORTING iv_parent_id = lv_parent_id
                                                          is_data      = ls_data
                                                CHANGING  cr_data      = er_data ).

    LOOP AT ls_data-fields ASSIGNING <fs_data_field>.
      ASSIGN COMPONENT <fs_data_field>-name OF STRUCTURE <fs_data> TO <fs_value>.
      IF sy-subrc = 0.
        <fs_value> = <fs_data_field>-value.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD count_instances.
    DATA: lo_typedescr  TYPE REF TO cl_abap_typedescr,
          lr_data       TYPE REF TO data.

    FIELD-SYMBOLS: <fs_table> TYPE STANDARD TABLE.

*   Do the actual deserialization
    /ui2/cl_json=>deserialize(
        EXPORTING
          json          = iv_json
          assoc_arrays  = abap_on
        CHANGING
          data          = lr_data ).

    IF lr_data IS BOUND.
*     Check if it's a table or structure
      lo_typedescr = cl_abap_typedescr=>describe_by_data( lr_data->* ).

      CASE lo_typedescr->type_kind.
        WHEN cl_abap_typedescr=>typekind_table. "itab
          ASSIGN lr_data->* TO <fs_table>.
          IF <fs_table> IS ASSIGNED.
            rv_instances = lines( <fs_table> ).

          ENDIF.

        WHEN cl_abap_typedescr=>typekind_struct1
          OR cl_abap_typedescr=>typekind_struct2. "structure
          rv_instances = 1.

      ENDCASE.

    ENDIF.

  ENDMETHOD.


  METHOD deserialize.
    DATA: lr_data                 TYPE REF TO data,
          ls_data                 TYPE ts_data,
          "ls_fields               TYPE ts_fields,
          lv_entity               TYPE abp_entity_name,
          lv_action               TYPE abp_action_name.

    lv_entity = iv_entity.
    lv_action = iv_action.

    DATA(lv_json) = iv_json.

    IF lv_json IS NOT INITIAL.
*     Cleanup JSON
      cleanup_json( CHANGING cv_json = lv_json ).

*     Validate JSON
      validate_json( EXPORTING iv_json = lv_json ).

    ELSE. "An empty object has to be generated if incoming JSON is empty
      lv_json = '{"_comment":"Empty JSON"}'.

    ENDIF.

*   Do the actual deserialization
    /ui2/cl_json=>deserialize(
        EXPORTING
          json          = lv_json
          assoc_arrays  = abap_on
        CHANGING
          data          = lr_data ).

    IF lr_data IS NOT BOUND.
      RAISE EXCEPTION NEW cx_ptf_json( textid = cx_ptf_json=>invalid_json ).

    ENDIF.

    ASSIGN lr_data->* TO FIELD-SYMBOL(<fs_data>).

*   Generate the intermediary data object that sits between input JSON and TDO

*   Get associations
    cl_ptf_json=>recursive_fill_associations( EXPORTING is_data         = <fs_data>
                                                        iv_action       = lv_action
                                              CHANGING  ct_associations = ls_data-associations ).

*   Get fields of root entity
    cl_ptf_json=>fill_fields( EXPORTING is_data = <fs_data> IMPORTING et_fields = ls_data-fields ).

*   Get operators of root entity
    cl_ptf_json=>fill_operators( EXPORTING is_data = <fs_data> IMPORTING et_operators = ls_data-operators ).

*   Get initials of root entity
    cl_ptf_json=>fill_initials( EXPORTING is_data = <fs_data> IMPORTING et_initials = ls_data-initials ).

*   Get params of root entity
    cl_ptf_json=>fill_params( EXPORTING is_data = <fs_data> IMPORTING et_params = ls_data-params ).

*   Check if we should add ignore
    cl_ptf_json=>fill_ignore( EXPORTING is_data = <fs_data> CHANGING ct_fields = ls_data-fields ).

*   Check if we should add action
    cl_ptf_json=>fill_action( EXPORTING is_data = <fs_data> CHANGING ct_fields = ls_data-fields cv_action = lv_action ).

*   Check if we should add child entity name
    cl_ptf_json=>fill_childentityname( EXPORTING is_data = <fs_data> CHANGING ct_fields = ls_data-fields cv_entity = lv_entity ).

*   Check if we should add simulation
    cl_ptf_json=>fill_simulation( EXPORTING is_data = <fs_data> CHANGING ct_fields = ls_data-fields ).

*   Check if we should add commit
    cl_ptf_json=>fill_commit( EXPORTING is_data = <fs_data> CHANGING ct_fields = ls_data-fields ).

*   Check if we should add isExisting
    cl_ptf_json=>fill_isexisting( EXPORTING is_data = <fs_data> CHANGING ct_fields = ls_data-fields ).

*   Check if we should add isDraft
    cl_ptf_json=>fill_isdraft( EXPORTING is_data = <fs_data> CHANGING ct_fields = ls_data-fields ).

*   Check if we should add maxInstances
    cl_ptf_json=>fill_maxinstances( EXPORTING is_data = <fs_data> CHANGING ct_fields = ls_data-fields ).

*   Add source property
    cl_ptf_json=>fill_source( CHANGING ct_fields = ls_data-fields ).

*   Push key fields if they don't exist
    cl_ptf_json=>add_key_fields(
      EXPORTING
        iv_entity = lv_entity
        iv_action = lv_action
        iv_root   = abap_on
      CHANGING
        ct_fields = ls_data-fields
    ).

*   Generate the dynamic ABAP data object ( TDO )

    cl_ptf_json=>generate_data( EXPORTING is_data = ls_data IMPORTING er_data = er_data ).

  ENDMETHOD.


  METHOD fill_action.
    DATA: ls_fields TYPE ts_fields.

    ASSIGN COMPONENT 'ACTION' OF STRUCTURE is_data TO FIELD-SYMBOL(<fs_action_ref>).
    IF sy-subrc = 0.
      ASSIGN <fs_action_ref>->* TO FIELD-SYMBOL(<fs_action>).
      IF sy-subrc = 0.
        ls_fields = VALUE #( name = '_ACTION' value = to_upper( <fs_action> ) ).

        APPEND ls_fields TO ct_fields.

        cv_action = ls_fields-value.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD fill_childentityname.
    DATA: ls_fields TYPE ts_fields.

    ASSIGN COMPONENT 'CHILDENTITYNAME' OF STRUCTURE is_data TO FIELD-SYMBOL(<fs_childentityname_ref>).
    IF sy-subrc = 0.
      ASSIGN <fs_childentityname_ref>->* TO FIELD-SYMBOL(<fs_childentityname>).
      IF sy-subrc = 0.
        ls_fields = VALUE #( name = '_CHILDENTITYNAME' value = to_upper( <fs_childentityname> ) ).

        APPEND ls_fields TO ct_fields.

        cv_entity = ls_fields-value.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD fill_commit.
    DATA: ls_fields TYPE ts_fields.

    ASSIGN COMPONENT 'COMMIT' OF STRUCTURE is_data TO FIELD-SYMBOL(<fs_commit_ref>).
    IF sy-subrc = 0.
      ASSIGN <fs_commit_ref>->* TO FIELD-SYMBOL(<fs_commit>).
      IF sy-subrc = 0.
        <fs_commit> = SWITCH abap_bool( <fs_commit> WHEN 'true' THEN abap_on
                                        WHEN abap_on THEN abap_on
                                        ELSE abap_off ).

        ls_fields = VALUE #( name = '_COMMIT' value = <fs_commit> ).

        APPEND ls_fields TO ct_fields.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD fill_fields.
    DATA: lo_structdescr  TYPE REF TO cl_abap_structdescr,
          lo_typedescr    TYPE REF TO cl_abap_typedescr,
          lt_components   TYPE abap_component_tab,
          ls_fields       TYPE ts_fields.

    FIELD-SYMBOLS: <fs_table>      TYPE ANY TABLE,
                   <fs_component>  TYPE abap_componentdescr,
                   <fs_structure>  TYPE any,
                   <fs_fields_ref> TYPE any,
                   <fs_line_ref>   TYPE any,
                   <fs_line>       TYPE any,
                   <fs_name_ref>   TYPE any,
                   <fs_name>       TYPE any,
                   <fs_value_ref>  TYPE any,
                   <fs_value>      TYPE any.

    CLEAR et_fields.

    ASSIGN COMPONENT 'FIELDS' OF STRUCTURE is_data TO <fs_fields_ref>.
    IF sy-subrc = 0.
*     Check if it's a standard table
      lo_typedescr = cl_abap_typedescr=>describe_by_data( <fs_fields_ref>->* ).

      CASE lo_typedescr->type_kind.
        WHEN cl_abap_typedescr=>typekind_table. "itab
          ASSIGN <fs_fields_ref>->* TO <fs_table>.

          LOOP AT <fs_table> ASSIGNING <fs_line_ref>.
            UNASSIGN: <fs_name>, <fs_value>.

            ASSIGN <fs_line_ref>->* TO <fs_line>.
            IF sy-subrc = 0.
              ASSIGN COMPONENT 'NAME' OF STRUCTURE <fs_line> TO <fs_name_ref>.
              IF sy-subrc = 0.
                ASSIGN <fs_name_ref>->* TO <fs_name>.

              ENDIF.

              ASSIGN COMPONENT 'VALUE' OF STRUCTURE <fs_line> TO <fs_value_ref>.
              IF sy-subrc = 0.
                ASSIGN <fs_value_ref>->* TO <fs_value>.

              ENDIF.

              IF <fs_name> IS ASSIGNED.
                CLEAR ls_fields.

                IF <fs_value> IS ASSIGNED.
                  ls_fields = VALUE #( name = to_upper( <fs_name> ) value = <fs_value> ).

                ELSE.
                  ls_fields = VALUE #( name = to_upper( <fs_name> ) ).

                ENDIF.

                APPEND ls_fields TO et_fields.

              ENDIF.

            ENDIF.

          ENDLOOP.

        WHEN cl_abap_typedescr=>typekind_struct1
          OR cl_abap_typedescr=>typekind_struct2. "structure
          ASSIGN <fs_fields_ref>->* TO <fs_structure>.

          lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_structure> ).
          lt_components = mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

          LOOP AT lt_components ASSIGNING <fs_component>.
            ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_structure> TO <fs_value_ref>.
            IF sy-subrc = 0.
              ASSIGN <fs_value_ref>->* TO <fs_value>.
              IF sy-subrc = 0.
                CLEAR ls_fields.

                ls_fields = VALUE #( name = to_upper( <fs_component>-name ) value = <fs_value> ).

                APPEND ls_fields TO et_fields.

              ENDIF.

            ENDIF.

          ENDLOOP.

      ENDCASE.

    ENDIF.

  ENDMETHOD.


  METHOD fill_ignore.
    DATA: ls_fields TYPE ts_fields.

    FIELD-SYMBOLS: <fs_ignore_ref> TYPE any,
                   <fs_ignore>     TYPE any.

    ASSIGN COMPONENT 'IGNORE' OF STRUCTURE is_data TO <fs_ignore_ref>.
    IF sy-subrc = 0.
      ASSIGN <fs_ignore_ref>->* TO <fs_ignore>.
      IF sy-subrc = 0.
        <fs_ignore> = SWITCH abap_bool( <fs_ignore> WHEN 'true' THEN abap_on
                                        WHEN abap_on THEN abap_on
                                        ELSE abap_off ).

      ENDIF.

    ENDIF.

    IF <fs_ignore> IS ASSIGNED.
      ls_fields = VALUE #( name = '_IGNORE' value = <fs_ignore> ).

    ELSE.
      ls_fields = VALUE #( name = '_IGNORE' value = abap_off ).

    ENDIF.

    APPEND ls_fields TO ct_fields.

*    ASSIGN COMPONENT 'IGNORE' OF STRUCTURE is_data TO FIELD-SYMBOL(<fs_ignore_ref>).
*    IF sy-subrc = 0.
*      ASSIGN <fs_ignore_ref>->* TO FIELD-SYMBOL(<fs_ignore>).
*      IF sy-subrc = 0.
*        IF <fs_ignore> = 'true'.
*          <fs_ignore> = abap_on.
*
*          ls_fields = VALUE #( name = '_IGNORE' value = <fs_ignore> ).
*
*          APPEND ls_fields TO ct_fields.
*
*        ENDIF.
*
*      ENDIF.
*
*    ENDIF.

  ENDMETHOD.


  METHOD fill_initials.
    DATA: lo_structdescr  TYPE REF TO cl_abap_structdescr,
          lo_typedescr    TYPE REF TO cl_abap_typedescr,
          lt_components   TYPE abap_component_tab,
          ls_initials     TYPE ts_initials,
          lv_initial      TYPE abap_bool.

    FIELD-SYMBOLS: <fs_table>      TYPE ANY TABLE,
                   <fs_component>  TYPE abap_componentdescr,
                   <fs_structure>  TYPE any,
                   <fs_fields_ref> TYPE any,
                   <fs_line_ref>   TYPE any,
                   <fs_line>       TYPE any,
                   <fs_name_ref>   TYPE any,
                   <fs_name>       TYPE any,
                   <fs_value_ref>  TYPE any,
                   <fs_value>      TYPE any.

    CLEAR et_initials.

    ASSIGN COMPONENT 'FIELDS' OF STRUCTURE is_data TO <fs_fields_ref>.
    IF sy-subrc = 0.
*     Check if it's a standard table
      lo_typedescr = cl_abap_typedescr=>describe_by_data( <fs_fields_ref>->* ).

      CASE lo_typedescr->type_kind.
        WHEN cl_abap_typedescr=>typekind_table. "itab
          ASSIGN <fs_fields_ref>->* TO <fs_table>.

          LOOP AT <fs_table> ASSIGNING <fs_line_ref>.
            UNASSIGN: <fs_name>, <fs_value>.

            ASSIGN <fs_line_ref>->* TO <fs_line>.
            IF sy-subrc = 0.
              ASSIGN COMPONENT 'NAME' OF STRUCTURE <fs_line> TO <fs_name_ref>.
              IF sy-subrc = 0.
                ASSIGN <fs_name_ref>->* TO <fs_name>.

              ENDIF.

              ASSIGN COMPONENT 'VALUE' OF STRUCTURE <fs_line> TO <fs_value_ref>.
              IF sy-subrc = 0.
                ASSIGN <fs_value_ref>->* TO <fs_value>.

              ENDIF.

              IF <fs_name> IS ASSIGNED.
                CLEAR ls_initials.

                IF <fs_value> IS ASSIGNED.
                  lv_initial = COND abap_bool( WHEN <fs_value> IS INITIAL THEN abap_on
                                               WHEN <fs_value> CO space THEN abap_on "One or more spaces between double quotes
                                               ELSE abap_off ).

                  ls_initials = VALUE #( name = to_upper( <fs_name> ) initial = lv_initial ).

                ELSE.
                  ls_initials = VALUE #( name = to_upper( <fs_name> ) initial = abap_on ). "default value

                ENDIF.

                APPEND ls_initials TO et_initials.

              ENDIF.

            ENDIF.

          ENDLOOP.

        WHEN cl_abap_typedescr=>typekind_struct1
          OR cl_abap_typedescr=>typekind_struct2. "structure
          ASSIGN <fs_fields_ref>->* TO <fs_structure>.

          lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_structure> ).
          lt_components = mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

          LOOP AT lt_components ASSIGNING <fs_component>.
            ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_structure> TO <fs_value_ref>.
            IF sy-subrc = 0.
              ASSIGN <fs_value_ref>->* TO <fs_value>.
              IF sy-subrc = 0.
                CLEAR ls_initials.

                lv_initial = COND abap_bool( WHEN <fs_value> IS INITIAL THEN abap_on
                                             WHEN <fs_value> CO space THEN abap_on "One or more spaces between double quotes
                                             ELSE abap_off ).

                ls_initials = VALUE #( name = <fs_component>-name initial = lv_initial ).

                APPEND ls_initials TO et_initials.

              ENDIF.

            ENDIF.

          ENDLOOP.

      ENDCASE.

    ENDIF.

  ENDMETHOD.


  METHOD FILL_ISDRAFT.
    DATA: ls_fields TYPE ts_fields.

    ASSIGN COMPONENT 'ISDRAFT' OF STRUCTURE is_data TO FIELD-SYMBOL(<fs_is_draft_ref>).
    IF sy-subrc = 0.
      ASSIGN <fs_is_draft_ref>->* TO FIELD-SYMBOL(<fs_is_draft>).
      IF sy-subrc = 0.
        <fs_is_draft> = SWITCH abap_bool( <fs_is_draft> WHEN 'true' THEN abap_on
                                        WHEN abap_on THEN abap_on
                                        ELSE abap_off ).

        ls_fields = VALUE #( name = '_IS_DRAFT' value = <fs_is_draft> ).

        APPEND ls_fields TO ct_fields.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD fill_isexisting.
    DATA: ls_fields TYPE ts_fields.

    FIELD-SYMBOLS: <fs_is_existing_ref> TYPE any,
                   <fs_is_existing>     TYPE any.

    ASSIGN COMPONENT 'ISEXISTING' OF STRUCTURE is_data TO <fs_is_existing_ref>.
    IF sy-subrc = 0.
      ASSIGN <fs_is_existing_ref>->* TO <fs_is_existing>.
      IF sy-subrc = 0.
        <fs_is_existing> = SWITCH abap_bool( <fs_is_existing> WHEN 'true' THEN abap_on
                                             WHEN abap_on THEN abap_on
                                             ELSE abap_off ).

      ENDIF.

    ENDIF.

    IF <fs_is_existing> IS ASSIGNED.
      ls_fields = VALUE #( name = '_IS_EXISTING' value = <fs_is_existing> ).

    ELSE.
      ls_fields = VALUE #( name = '_IS_EXISTING' value = abap_on ).

    ENDIF.

    APPEND ls_fields TO ct_fields.

*    ASSIGN COMPONENT 'ISEXISTING' OF STRUCTURE is_data TO FIELD-SYMBOL(<fs_is_existing_ref>).
*    IF sy-subrc = 0.
*      ASSIGN <fs_is_existing_ref>->* TO FIELD-SYMBOL(<fs_is_existing>).
*      IF sy-subrc = 0.
*        <fs_is_existing> = SWITCH abap_bool( <fs_is_existing> WHEN 'true' THEN abap_on
*                                        WHEN abap_on THEN abap_on
*                                        ELSE abap_off ).
*
*        ls_fields = VALUE #( name = '_IS_EXISTING' value = <fs_is_existing> ).
*
*        APPEND ls_fields TO ct_fields.
*
*      ENDIF.
*
*    ENDIF.

  ENDMETHOD.


  METHOD fill_maxinstances.
    DATA: ls_fields TYPE ts_fields.

    ASSIGN COMPONENT 'MAXINSTANCES' OF STRUCTURE is_data TO FIELD-SYMBOL(<fs_maxinstances_ref>).
    IF sy-subrc = 0.
      ASSIGN <fs_maxinstances_ref>->* TO FIELD-SYMBOL(<fs_maxinstances>).
      IF sy-subrc = 0.
        ls_fields = VALUE #( name = '_MAXINSTANCES' value = <fs_maxinstances> ).

        APPEND ls_fields TO ct_fields.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD fill_operators.
    DATA: lo_structdescr  TYPE REF TO cl_abap_structdescr,
          lo_typedescr    TYPE REF TO cl_abap_typedescr,
          lt_components   TYPE abap_component_tab,
          ls_operators    TYPE ts_operators.

    FIELD-SYMBOLS: <fs_table>      TYPE ANY TABLE,
                   <fs_component>  TYPE abap_componentdescr,
                   <fs_structure>  TYPE any,
                   <fs_fields_ref> TYPE any,
                   <fs_line_ref>   TYPE any,
                   <fs_line>       TYPE any,
                   <fs_name_ref>   TYPE any,
                   <fs_name>       TYPE any,
                   <fs_value_ref>  TYPE any,
                   <fs_value>      TYPE any.

    CLEAR et_operators.

    ASSIGN COMPONENT 'FIELDS' OF STRUCTURE is_data TO <fs_fields_ref>.
    IF sy-subrc = 0.
*     Check if it's a standard table
      lo_typedescr = cl_abap_typedescr=>describe_by_data( <fs_fields_ref>->* ).

      CASE lo_typedescr->type_kind.
        WHEN cl_abap_typedescr=>typekind_table. "itab
          ASSIGN <fs_fields_ref>->* TO <fs_table>.

          LOOP AT <fs_table> ASSIGNING <fs_line_ref>.
            UNASSIGN: <fs_name>, <fs_value>.

            ASSIGN <fs_line_ref>->* TO <fs_line>.
            IF sy-subrc = 0.
              ASSIGN COMPONENT 'NAME' OF STRUCTURE <fs_line> TO <fs_name_ref>.
              IF sy-subrc = 0.
                ASSIGN <fs_name_ref>->* TO <fs_name>.

              ENDIF.

              ASSIGN COMPONENT 'OPERATOR' OF STRUCTURE <fs_line> TO <fs_value_ref>.
              IF sy-subrc = 0.
                ASSIGN <fs_value_ref>->* TO <fs_value>.

              ENDIF.

              IF <fs_name> IS ASSIGNED.
                CLEAR ls_operators.

                IF <fs_value> IS ASSIGNED.
                  ls_operators = VALUE #( name = to_upper( <fs_name> ) operator = <fs_value> ).

                ELSE.
                  ls_operators = VALUE #( name = to_upper( <fs_name> ) operator = '=' ).

                ENDIF.

                APPEND ls_operators TO et_operators.

              ENDIF.

            ENDIF.

          ENDLOOP.

        WHEN cl_abap_typedescr=>typekind_struct1
          OR cl_abap_typedescr=>typekind_struct2. "structure
          ASSIGN <fs_fields_ref>->* TO <fs_structure>.

          lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_structure> ).
          lt_components = mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

          LOOP AT lt_components ASSIGNING <fs_component>.
            ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_structure> TO <fs_value_ref>.
            IF sy-subrc = 0.
              ASSIGN <fs_value_ref>->* TO <fs_value>.
              IF sy-subrc = 0.
                CLEAR ls_operators.

                ls_operators = VALUE #( name = <fs_component>-name operator = '=' ).

                APPEND ls_operators TO et_operators.

              ENDIF.

            ENDIF.

          ENDLOOP.

      ENDCASE.

    ENDIF.

  ENDMETHOD.


  METHOD fill_op_read_result.
    DATA: lo_structdescr  TYPE REF TO cl_abap_structdescr,
          ls_associations TYPE ts_associations,
          ls_fields       TYPE ts_fields.

    FIELD-SYMBOLS: <fs_value> TYPE any.

*   Check if the entry is the right child
    IF iv_parent_id IS NOT INITIAL.
      DATA(lv_is_line_found) = abap_on.

      IF line_exists( ct_associations[ id = iv_parent_id ] ). "Sometimes there is no parent entity
*       Get the parent line
        DATA(ls_association) = ct_associations[ id = iv_parent_id ].

*       Get Key Fields of the association
        DATA(lt_key_components) = mo_ptf_rap_metadata->get_key_fields( iv_name = CONV #( ls_association-childentityname ) ).

        LOOP AT lt_key_components ASSIGNING FIELD-SYMBOL(<fs_key_component>).
          READ TABLE ls_association-fields ASSIGNING FIELD-SYMBOL(<fs_fields>) WITH KEY name = <fs_key_component>-name.
          IF sy-subrc = 0.
            ASSIGN COMPONENT <fs_fields>-name OF STRUCTURE is_result TO <fs_value>.
            IF sy-subrc = 0.
              IF <fs_value> <> <fs_fields>-value.
                lv_is_line_found = abap_off.

              ENDIF.

            ENDIF.

          ENDIF.

        ENDLOOP.

        IF lv_is_line_found = abap_off.
          RETURN.

        ENDIF.

      ENDIF.

    ENDIF.

    CLEAR: ls_associations.

    ls_associations-assocname        = is_operation_read-sub_name.

    ls_associations-childentityname  = it_associations[ source_entity = is_operation_read-entity_name name = is_operation_read-sub_name ]-target_entity.

    lo_structdescr ?= cl_abap_structdescr=>describe_by_data( is_result ).
    DATA(lt_components) = mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

    LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
      CLEAR ls_fields.

      ls_fields-name = <fs_component>-name.

      ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_result TO <fs_value>.
      IF sy-subrc = 0.
        ls_fields-value = <fs_value>.

      ENDIF.

      APPEND ls_fields TO ls_associations-fields.

    ENDLOOP.

    TRY.
        ls_associations-id = cl_system_uuid=>create_uuid_c32_static( ).

      CATCH cx_uuid_error ##NO_HANDLER.
    ENDTRY.

    ls_associations-parent_id = iv_parent_id.

    APPEND ls_associations TO ct_associations.

    cl_ptf_json=>recursive_fill_ops_read_assocs( EXPORTING it_operations_read = it_operations_read
                                                           it_associations    = it_associations
                                                           iv_name            = CONV #( ls_associations-childentityname )
                                                           iv_parent_id       = ls_associations-id
                                                 CHANGING  ct_associations    = ct_associations ).

  ENDMETHOD.


  METHOD fill_params.
    DATA: lo_structdescr  TYPE REF TO cl_abap_structdescr,
          lo_typedescr    TYPE REF TO cl_abap_typedescr,
          lt_components   TYPE abap_component_tab,
          lr_value        TYPE REF TO data,
          ls_params       TYPE ts_params.

    FIELD-SYMBOLS: <fs_table>      TYPE ANY TABLE,
                   <fs_structure>  TYPE any,
                   <fs_component>  TYPE abap_componentdescr,
                   <fs_line_ref>   TYPE any,
                   <fs_line>       TYPE any,
                   <fs_name_ref>   TYPE any,
                   <fs_name>       TYPE any,
                   <fs_value_ref>  TYPE any,
                   <fs_value>      TYPE any.

    CLEAR et_params.

    ASSIGN COMPONENT 'PARAMS' OF STRUCTURE is_data TO FIELD-SYMBOL(<fs_params_ref>).
    IF sy-subrc = 0.
*     Check if it's a standard table
      lo_typedescr = cl_abap_typedescr=>describe_by_data( <fs_params_ref>->* ).

      CASE lo_typedescr->type_kind.
        WHEN cl_abap_typedescr=>typekind_table. "itab
          ASSIGN <fs_params_ref>->* TO <fs_table>.

          LOOP AT <fs_table> ASSIGNING <fs_line_ref>.
            UNASSIGN: <fs_name>, <fs_value>.

            ASSIGN <fs_line_ref>->* TO <fs_line>.
            IF sy-subrc = 0.
              ASSIGN COMPONENT 'NAME' OF STRUCTURE <fs_line> TO <fs_name_ref>.
              IF sy-subrc = 0.
                ASSIGN <fs_name_ref>->* TO <fs_name>.

              ENDIF.

              ASSIGN COMPONENT 'VALUE' OF STRUCTURE <fs_line> TO <fs_value_ref>.
              IF sy-subrc = 0.
                ASSIGN <fs_value_ref>->* TO <fs_value>.

              ENDIF.

              IF <fs_name> IS ASSIGNED AND <fs_value> IS ASSIGNED.
                cl_ptf_json=>recursive_fill_params(
                  EXPORTING
                    ir_data = <fs_line_ref>
                  IMPORTING
                    er_data = lr_value ).

                CLEAR ls_params.

                ls_params = VALUE #( name = to_upper( <fs_name> ) value = lr_value ).

                APPEND ls_params TO et_params.

              ENDIF.

            ENDIF.

          ENDLOOP.

        WHEN cl_abap_typedescr=>typekind_struct1
          OR cl_abap_typedescr=>typekind_struct2. "structure
          ASSIGN <fs_params_ref>->* TO <fs_structure>.

          lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_structure> ).
          lt_components = mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

          LOOP AT lt_components ASSIGNING <fs_component>.
            ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_structure> TO <fs_value_ref>.
            IF sy-subrc = 0.
              cl_ptf_json=>recursive_fill_params(
                EXPORTING
                  ir_data = <fs_value_ref>
                IMPORTING
                  er_data = lr_value ).

              CLEAR ls_params.

              ls_params = VALUE #( name = to_upper( <fs_component>-name ) value = lr_value ).

              APPEND ls_params TO et_params.

            ENDIF.

          ENDLOOP.

      ENDCASE.

    ENDIF.

  ENDMETHOD.


  METHOD fill_simulation.
    DATA: ls_fields TYPE ts_fields.

    ASSIGN COMPONENT 'SIMULATION' OF STRUCTURE is_data TO FIELD-SYMBOL(<fs_simulation_ref>).
    IF sy-subrc = 0.
      ASSIGN <fs_simulation_ref>->* TO FIELD-SYMBOL(<fs_simulation>).
      IF sy-subrc = 0.
        <fs_simulation> = SWITCH abap_bool( <fs_simulation> WHEN 'true' THEN abap_on
                                            WHEN abap_on THEN abap_on
                                            ELSE abap_off ).

          ls_fields = VALUE #( name = '_SIMULATION' value = <fs_simulation> ).

          APPEND ls_fields TO ct_fields.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD fill_source.
    APPEND VALUE #( name = '_SOURCE' value = 'JSON' ) TO ct_fields.

  ENDMETHOD.


  METHOD filter_ops_read_results.
    DATA: lo_tabledescr TYPE REF TO cl_abap_tabledescr.

    FIELD-SYMBOLS: <fs_operation_read>      TYPE abp_behv_retrievals,
                   <fs_operation_read_new>  TYPE abp_behv_retrievals,
                   <fs_results_table>       TYPE STANDARD TABLE,
                   <fs_value_act>           TYPE any,
                   <fs_value_exp>           TYPE any,
                   <fs_result>              TYPE any.

    CLEAR et_operations_read.

    cl_abap_behv_load=>get_load(
      EXPORTING
        entity       = iv_entity
        all          = abap_on
      IMPORTING
        entities     = DATA(lt_entities)
        associations = DATA(lt_associations)
    ).

*   Get Key Fields of the root entity
    DATA(lt_key_components) = mo_ptf_rap_metadata->get_key_fields( iv_name = iv_entity ).

    LOOP AT it_operations_read ASSIGNING <fs_operation_read>.
      DATA(lv_is_foreign) = abap_off.

      IF line_exists( lt_associations[ source_entity = <fs_operation_read>-entity_name name = <fs_operation_read>-sub_name ] ).
        DATA(ls_association) = lt_associations[ source_entity = <fs_operation_read>-entity_name name = <fs_operation_read>-sub_name ].

        IF NOT line_exists( lt_entities[ name = ls_association-target_entity ] ).
          lv_is_foreign = abap_on.

        ENDIF.

      ENDIF.

      LOOP AT <fs_operation_read>-results->* ASSIGNING <fs_result>.
*        DATA(lv_tabix)          = sy-tabix.
        DATA(lv_is_line_found)  = abap_on.

        CASE lv_is_foreign.
          WHEN abap_off.
            LOOP AT lt_key_components ASSIGNING FIELD-SYMBOL(<fs_key_component>).
              ASSIGN COMPONENT <fs_key_component>-name OF STRUCTURE <fs_result> TO <fs_value_act>.
              IF sy-subrc = 0.
                ASSIGN COMPONENT <fs_key_component>-name OF STRUCTURE is_result TO <fs_value_exp>.
                IF sy-subrc = 0.
                  IF <fs_value_act> <> <fs_value_exp>.
                    lv_is_line_found = abap_off.
                    EXIT.

                  ENDIF.

                ENDIF.

              ENDIF.

            ENDLOOP.

          WHEN abap_on.
*           Apply only for root entities for the moment
            IF iv_entity = ls_association-source_entity.
*             Get Key Fields of the foreign entity
              DATA(lt_fkey_components) = mo_ptf_rap_metadata->get_key_fields( iv_name = ls_association-target_entity ).

              LOOP AT lt_fkey_components ASSIGNING FIELD-SYMBOL(<fs_fkey_component>).
                ASSIGN COMPONENT <fs_fkey_component>-name OF STRUCTURE <fs_result> TO <fs_value_act>.
                IF sy-subrc = 0.
                  ASSIGN COMPONENT <fs_fkey_component>-name OF STRUCTURE is_result TO <fs_value_exp>.
                  IF sy-subrc = 0.
                    IF <fs_value_act> <> <fs_value_exp>.
                      lv_is_line_found = abap_off.
                      EXIT.

                    ENDIF.

                  ENDIF.

                ENDIF.

              ENDLOOP.

            ELSE.
              lv_is_line_found = abap_off.

            ENDIF.

        ENDCASE.

        IF lv_is_line_found = abap_on.
          IF NOT line_exists( et_operations_read[ entity_name = <fs_operation_read>-entity_name sub_name = <fs_operation_read>-sub_name ] ).
            APPEND INITIAL LINE TO et_operations_read ASSIGNING <fs_operation_read_new>.

            <fs_operation_read_new>-entity_name = <fs_operation_read>-entity_name.
            <fs_operation_read_new>-sub_name    = <fs_operation_read>-sub_name.
            lo_tabledescr ?= cl_abap_refdescr=>describe_by_data( <fs_operation_read>-results->* ).
            CREATE DATA <fs_operation_read_new>-results TYPE HANDLE lo_tabledescr.

          ELSE.
            ASSIGN et_operations_read[ entity_name = <fs_operation_read>-entity_name sub_name = <fs_operation_read>-sub_name ] TO <fs_operation_read_new>.

          ENDIF.

          ASSIGN <fs_operation_read_new>-results->* TO <fs_results_table>.
          APPEND <fs_result> TO <fs_results_table>.

        ENDIF.

*        This solution doesn't work due to the fact that results is a data reference.
*        Deleting something from it leads to deleting from any other identical reference
*        IF lv_is_line_found = abap_off.
*          ASSIGN <fs_operation_read>-results->* TO <fs_results_table>.
*          DELETE <fs_results_table> INDEX lv_tabix.
*          CONTINUE.
*
*        ENDIF.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


  METHOD generate_data.
    DATA: lo_structdescr          TYPE REF TO cl_abap_structdescr,
          lo_datadescr            TYPE REF TO cl_abap_datadescr,
          lx_sy_struct_comp_name  TYPE REF TO cx_sy_struct_comp_name,
          lt_operator_comp_tab    TYPE abap_component_tab,
          lt_initial_comp_tab     TYPE abap_component_tab,
          lt_param_comp_tab       TYPE abap_component_tab,
          lt_root_comp_tab        TYPE abap_component_tab,
          ls_componentdescr       TYPE abap_componentdescr.

    FIELD-SYMBOLS: <fs_value>         TYPE any,
                   <fs_data_field>    TYPE ts_fields,
                   <fs_data_operator> TYPE ts_operators,
                   <fs_data_initial>  TYPE ts_initials,
                   <fs_data_param>    TYPE ts_params,
                   <fs_operators>     TYPE any,
                   <fs_initials>      TYPE any,
                   <fs_params>        TYPE any.

*   1st Part - Generate the initial TDO

    cl_ptf_json=>recursive_gen_data_structure( EXPORTING it_associations  = is_data-associations
                                               CHANGING  ct_component_tab = lt_root_comp_tab ).

*   Generate the fields of the root entity
    LOOP AT is_data-fields ASSIGNING <fs_data_field>.
      CLEAR ls_componentdescr.

      ls_componentdescr = VALUE #( name = <fs_data_field>-name type = cl_abap_elemdescr=>get_string( ) ).

      APPEND ls_componentdescr TO lt_root_comp_tab.

    ENDLOOP.

*   Generate the operators of the root entity
    IF NOT is_data-operators IS INITIAL.
      LOOP AT is_data-operators ASSIGNING <fs_data_operator>.
        CLEAR ls_componentdescr.

        ls_componentdescr = VALUE #( name = <fs_data_operator>-name type = cl_abap_elemdescr=>get_string( ) ).

        APPEND ls_componentdescr TO lt_operator_comp_tab.

      ENDLOOP.

      CLEAR: ls_componentdescr.

      TRY.
          lo_structdescr = cl_abap_structdescr=>get( lt_operator_comp_tab ).

        CATCH cx_sy_struct_comp_name INTO lx_sy_struct_comp_name.
          handle_exception( lx_sy_struct_comp_name ).

      ENDTRY.

      ls_componentdescr = VALUE #( name = '_OPERATORS' type = lo_structdescr ).

      APPEND ls_componentdescr TO lt_root_comp_tab.

    ENDIF.

*   Generate the initials of the root entity
    IF NOT is_data-initials IS INITIAL.
      LOOP AT is_data-initials ASSIGNING <fs_data_initial>.
        CLEAR ls_componentdescr.

        ls_componentdescr = VALUE #( name = <fs_data_initial>-name type = cl_abap_elemdescr=>get_string( ) ).

        APPEND ls_componentdescr TO lt_initial_comp_tab.

      ENDLOOP.

      CLEAR: ls_componentdescr.

      TRY.
          lo_structdescr = cl_abap_structdescr=>get( lt_initial_comp_tab ).

        CATCH cx_sy_struct_comp_name INTO lx_sy_struct_comp_name.
          handle_exception( lx_sy_struct_comp_name ).

      ENDTRY.

      ls_componentdescr = VALUE #( name = '_INITIALS' type = lo_structdescr ).

      APPEND ls_componentdescr TO lt_root_comp_tab.

    ENDIF.

*   Generate the params of the root entity
    IF NOT is_data-params IS INITIAL.
      LOOP AT is_data-params ASSIGNING <fs_data_param>.
        CLEAR ls_componentdescr.

        ASSIGN <fs_data_param>-value->* TO <fs_value>.

        IF <fs_value> IS ASSIGNED.
          lo_datadescr ?= cl_abap_datadescr=>describe_by_data( <fs_value> ).
          ls_componentdescr = VALUE #( name = <fs_data_param>-name type = lo_datadescr ).

          APPEND ls_componentdescr TO lt_param_comp_tab.

        ENDIF.

      ENDLOOP.

      IF lt_param_comp_tab IS NOT INITIAL.
        TRY.
            lo_structdescr = cl_abap_structdescr=>get( lt_param_comp_tab ).

          CATCH cx_sy_struct_comp_name INTO lx_sy_struct_comp_name.
            handle_exception( lx_sy_struct_comp_name ).

        ENDTRY.

        CLEAR ls_componentdescr.

        ls_componentdescr = VALUE #( name = '_PARAMS' type = lo_structdescr ).

        APPEND ls_componentdescr TO lt_root_comp_tab.

      ENDIF.

    ENDIF.

    IF lt_root_comp_tab IS INITIAL.
      RAISE EXCEPTION TYPE cx_ptf_json MESSAGE ID 'PTF' TYPE 'E' NUMBER '071'.

    ENDIF.

    TRY.
      lo_structdescr = cl_abap_structdescr=>get( lt_root_comp_tab ).

      CATCH cx_sy_struct_comp_name INTO lx_sy_struct_comp_name.
        handle_exception( lx_sy_struct_comp_name ).

    ENDTRY.

*   2nd Part - Fill values of the TDO

    CREATE DATA er_data TYPE HANDLE lo_structdescr.

    ASSIGN er_data->* TO FIELD-SYMBOL(<fs_data>).

*   Fill the generated structure with data
    cl_ptf_json=>recursive_fill_data_structure( EXPORTING is_data = is_data
                                                CHANGING  cr_data = er_data ).

    LOOP AT is_data-fields ASSIGNING <fs_data_field>.
      ASSIGN COMPONENT <fs_data_field>-name OF STRUCTURE <fs_data> TO <fs_value>.
      IF sy-subrc = 0.
        <fs_value> = <fs_data_field>-value.

      ENDIF.

    ENDLOOP.

    ASSIGN COMPONENT '_OPERATORS' OF STRUCTURE <fs_data> TO <fs_operators>.
    IF sy-subrc = 0.
      LOOP AT is_data-operators ASSIGNING <fs_data_operator>.
        ASSIGN COMPONENT <fs_data_operator>-name OF STRUCTURE <fs_operators> TO <fs_value>.
        IF sy-subrc = 0.
          <fs_value> = <fs_data_operator>-operator.

        ENDIF.

      ENDLOOP.

    ENDIF.

    ASSIGN COMPONENT '_INITIALS' OF STRUCTURE <fs_data> TO <fs_initials>.
    IF sy-subrc = 0.
      LOOP AT is_data-initials ASSIGNING <fs_data_initial>.
        ASSIGN COMPONENT <fs_data_initial>-name OF STRUCTURE <fs_initials> TO <fs_value>.
        IF sy-subrc = 0.
          <fs_value> = <fs_data_initial>-initial.

        ENDIF.

      ENDLOOP.

    ENDIF.

    ASSIGN COMPONENT '_PARAMS' OF STRUCTURE <fs_data> TO <fs_params>.
    IF sy-subrc = 0.
      LOOP AT is_data-params ASSIGNING <fs_data_param>.
        ASSIGN COMPONENT <fs_data_param>-name OF STRUCTURE <fs_params> TO <fs_value>.
        IF sy-subrc = 0.
          <fs_value> = <fs_data_param>-value->*.

        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD generate_json_fields.
    DATA: lo_structdescr      TYPE REF TO cl_abap_structdescr,
          lt_components       TYPE abap_component_tab,
          ls_entity           TYPE cl_abap_behv_load=>t_entity,
          lv_length           TYPE i,
          lv_first            TYPE abap_bool,
          lv_last             TYPE abap_bool,
          lv_is_assoc         TYPE abap_bool,
          lv_is_enabled       TYPE abap_bool,
          lv_is_action        TYPE abap_bool,
          lv_field_added      TYPE abap_bool,
          lv_tabix            TYPE syst-tabix,
          lv_entity           TYPE abp_entity_name.

    FIELD-SYMBOLS: <fs_permission>      TYPE abp_behv_permissions,
                   <fs_component>       TYPE abap_componentdescr,
                   <fs_result>          TYPE any,
                   <fs_structure>       TYPE any,
                   <fs_global>          TYPE any,
                   <fs_field_control>   TYPE any.

    DATA(lv_nesting_level) = iv_nesting_level.

    DATA(lt_key_components) = mo_ptf_rap_metadata->get_key_fields( iv_name = iv_entity ).

    READ TABLE it_permissions ASSIGNING <fs_permission> WITH KEY entity_name = iv_entity.
    IF sy-subrc = 0.
      CASE iv_ptf_act.
        WHEN 'CREATE'.
          lv_is_enabled = abap_on.

        WHEN 'CHANGE'.
          lv_is_enabled = abap_on.

        WHEN 'DELETE'.
          lv_is_enabled = abap_on.

        WHEN 'CHECK' OR 'RETRIEVE'.
          lv_is_enabled = abap_on.

        WHEN 'CHECK_IF_EXISTS' OR 'RETRIEVE_ALL'.
          lv_is_enabled = abap_on.

          IF iv_ptf_json_opt = '2'.
            CLEAR ct_associations.

          ENDIF.

        WHEN 'ENTITY_ACTION'.
          DATA(lt_actions) = FILTER #( it_actions WHERE owner_entity <> iv_entity ).

          IF lt_actions IS NOT INITIAL.
            CLEAR cv_json.

            LOOP AT lt_actions ASSIGNING FIELD-SYMBOL(<fs_action>).
              ls_entity = it_entities[ name = <fs_action>-owner_entity ].

              cv_json = |{ cv_json }\{"_comment":"JSON Action Example for RAP BO child entity { ls_entity-ext_name } - action { <fs_action>-ext_name } - remove if not used"|. "begin root entity
              cv_json = |{ cv_json },"action":"{ <fs_action>-ext_name }","childEntityName":"{ ls_entity-ext_name }"|.
              cv_json = |{ cv_json },"fields":[|. "begin entity

              READ TABLE it_permissions ASSIGNING <fs_permission> WITH KEY entity_name = <fs_action>-owner_entity.
              IF sy-subrc = 0.
                ASSIGN <fs_permission>-results->* TO <fs_result>.
                IF sy-subrc = 0.
                  ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-global OF STRUCTURE <fs_result> TO <fs_global>.
                  IF sy-subrc = 0.
                    ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-field OF STRUCTURE <fs_global> TO <fs_structure>.
                    IF sy-subrc = 0.
                      "get the fields and parameters of the action
                      DATA(lr_child_act)  = cl_abap_behvdescr=>create_data(
                         p_name      = <fs_action>-owner_entity
                         p_sub_name  = <fs_action>-name
                         p_op        = if_abap_behv=>op-m-action
                         p_kind      = if_abap_behv=>typekind-import
                         p_structure = abap_on
                      ).

                      ASSIGN lr_child_act->* TO FIELD-SYMBOL(<fs_child_act>).

                      lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_child_act> ).
                      lt_components = mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

*                     Remove CID Ref
                      DELETE lt_components WHERE name = cl_abap_behv=>co_techfield_name-cid_ref.

*                     Remove preliminary ID
                      DELETE lt_components WHERE name = cl_abap_behv=>co_techfield_name-pid.

*                     Remove CID
                      DELETE lt_components WHERE name = cl_abap_behv=>co_techfield_name-cid.

*                     Remove IS_DRAFT
                      DELETE lt_components WHERE name = cl_abap_behv=>co_techfield_name-is_draft.

                      LOOP AT lt_components ASSIGNING <fs_component>.
                        CASE <fs_component>-name.
                          WHEN cl_abap_behv=>co_techfield_name-param. "%PARAM - nested data

                          WHEN OTHERS.
                            cv_json = |{ cv_json }\{"name":"{ <fs_component>-name }","value":"key"\},|. "mandatory
                            lv_field_added = abap_on.

                        ENDCASE.

                        AT LAST.
                          IF lv_field_added = abap_on.
                            lv_length = strlen( cv_json ) - 1.
                            cv_json = cv_json+0(lv_length).

                          ENDIF.

                        ENDAT.

                      ENDLOOP.

                      cv_json = |{ cv_json }]|. "end fields

                      READ TABLE lt_components ASSIGNING <fs_component> WITH KEY name = cl_abap_behv=>co_techfield_name-param.
                      IF sy-subrc = 0.
                        cl_ptf_json=>generate_params(
                          EXPORTING
                            io_datadescr  = <fs_component>-type
                            is_action     = <fs_action>
                          CHANGING
                            cv_json       = cv_json
                        ).

                      ENDIF.

                    ENDIF.

                  ENDIF.

                ENDIF.

              ENDIF.

              cv_json = |{ cv_json }\}|. "end entity fields

            ENDLOOP.

          ELSE.
            cv_json = '{"_comment":"No actions found for child entities"}'.

          ENDIF.

          RETURN.

        WHEN OTHERS.
          TRY.
              DATA(ls_action) = it_actions[ owner_entity = iv_entity name = iv_ptf_act ] ##NEEDED.

              lv_is_enabled = abap_on.
              lv_is_action  = abap_on.

            CATCH cx_sy_itab_line_not_found ##NO_HANDLER.
          ENDTRY.

      ENDCASE.

      IF lv_is_enabled = abap_on.
*       Remove ignore flag if we have CHECK_IF_EXISTS action or if we have an action
        IF iv_ptf_act <> 'CREATE'
          AND iv_ptf_act <> 'CHECK_IF_EXISTS'
          AND iv_ptf_act <> 'RETRIEVE'
          AND iv_ptf_act <> 'RETRIEVE_ALL'
          AND lv_is_action = abap_off.
          cv_json = |{ cv_json },"ignore":false|.

        ENDIF.

*       Add "isExisting" if we ave CHECK_IF_EXISTS
        IF iv_ptf_act = 'CHECK_IF_EXISTS'.
          cv_json = |{ cv_json },"isExisting":true|. "isExisting

        ENDIF.

*       Add "isDraft" if applicable
        IF iv_nesting_level = 1.
          CASE iv_ptf_act.
            WHEN 'CREATE' OR 'CHANGE' OR 'DELETE'.
              ls_entity = it_entities[ name = iv_entity ].
              IF ls_entity-draft_name IS NOT INITIAL.
                cv_json = |{ cv_json },"isDraft":false|. "isDraft

              ENDIF.

          ENDCASE.

        ENDIF.

        cv_json = |{ cv_json },"fields":[|. "begin entity

        ASSIGN <fs_permission>-results->* TO <fs_result>.
        IF sy-subrc = 0.
          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-global OF STRUCTURE <fs_result> TO <fs_global>.
          IF sy-subrc = 0.
            ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-field OF STRUCTURE <fs_global> TO <fs_structure>.
            IF sy-subrc = 0.
*             Remove non key components
              CASE iv_ptf_act.
                WHEN 'DELETE'.
                  IF iv_ptf_json_opt = '2' OR iv_ptf_json_opt = '3'.
*                   Identify ONLY the key fields
                    lt_components = mo_ptf_rap_metadata->get_key_fields( iv_name = iv_entity ).

                  ENDIF.

                WHEN 'CREATE' OR 'CHANGE' OR 'CHECK'.
                  IF iv_ptf_json_opt = '2' OR iv_ptf_json_opt = '3'.
                    lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_structure> ).
                    lt_components = lo_structdescr->get_components( ).

                  ENDIF.

                WHEN 'RETRIEVE'.
*                 Identify ONLY the key fields
                  lt_components = mo_ptf_rap_metadata->get_key_fields( iv_name = iv_entity ).

                WHEN 'RETRIEVE_ALL' OR 'CHECK_IF_EXISTS'.
                  IF iv_ptf_json_opt = '2' OR iv_ptf_json_opt = '4'.
*                   Identify ONLY the key fields
                    lt_components = mo_ptf_rap_metadata->get_key_fields( iv_name = iv_entity ).

                  ELSEIF iv_ptf_json_opt = '3'.
*                   Identify all components of the structure
                    lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_structure> ).
                    lt_components = lo_structdescr->get_components( ).

                  ENDIF.

                WHEN OTHERS. "Actions
                  "get the parameters of the action
                  DATA(lr_act)  = cl_abap_behvdescr=>create_data(
                     p_name      = iv_entity
                     p_sub_name  = iv_ptf_act
                     p_op        = if_abap_behv=>op-m-action
                     p_kind      = if_abap_behv=>typekind-import
                     p_structure = abap_on
                  ).

                  ASSIGN lr_act->* TO FIELD-SYMBOL(<fs_act>).

                  lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_act> ).
                  lt_components = mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

*                 Remove CID Ref
                  DELETE lt_components WHERE name = cl_abap_behv=>co_techfield_name-cid_ref.

*                 Remove preliminary ID
                  DELETE lt_components WHERE name = cl_abap_behv=>co_techfield_name-pid.

*                 Remove CID
                  DELETE lt_components WHERE name = cl_abap_behv=>co_techfield_name-cid.

              ENDCASE.

              LOOP AT lt_components ASSIGNING <fs_component>.
                CASE lv_is_action.
                  WHEN abap_on.
                    CASE <fs_component>-name.
                      WHEN cl_abap_behv=>co_techfield_name-param. "%PARAM - nested data

                      WHEN OTHERS.
                        cv_json = |{ cv_json }\{"name":"{ <fs_component>-name }","value":"key"\},|. "mandatory
                        lv_field_added = abap_on.

                    ENDCASE.

                  WHEN abap_off.
                    ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_structure> TO <fs_field_control>.
                    IF sy-subrc = 0.
                      READ TABLE lt_key_components WITH KEY name = <fs_component>-name TRANSPORTING NO FIELDS.
                      IF sy-subrc = 0.
*                        IF <fs_field_control> <> if_abap_behv=>fc-f-read_only.
                        cv_json = |{ cv_json }\{"name":"{ <fs_component>-name }","value":"key"|.

                        cv_json = |{ cv_json }\},|.
                        lv_field_added = abap_on.

*                        ENDIF.

                      ELSE.
                        CASE <fs_field_control>.
                          WHEN if_abap_behv=>fc-f-mandatory
                            "OR if_abap_behv=>fc-f-read_only
                            OR if_abap_behv=>perm-f-mandatory_create OR '30'.
                            cv_json = |{ cv_json }\{"name":"{ <fs_component>-name }","value":"mandatory"|.

                            IF iv_ptf_act = 'CHECK'.
                               cv_json = |{ cv_json },"operator":"="|.

                            ENDIF.

                            cv_json = |{ cv_json }\},|.
                            lv_field_added = abap_on.

                          WHEN OTHERS.
                            IF iv_ptf_json_opt = '3'. "All fields
                              cv_json = |{ cv_json }\{"name":"{ <fs_component>-name }","value":"optional"|.

                              IF iv_ptf_act = 'CHECK'.
                                cv_json = |{ cv_json },"operator":"="|.

                              ENDIF.

                              cv_json = |{ cv_json }\},|.
                              lv_field_added = abap_on.

                            ENDIF.

                             "cv_json = |{ cv_json }\{"name":"{ <fs_component>-name }","value":"fill optional value"\},|.

                        ENDCASE.

                      ENDIF.

                    ENDIF.

                ENDCASE.

                AT LAST.
                  IF lv_field_added = abap_on.
                    lv_length = strlen( cv_json ) - 1.
                    cv_json = cv_json+0(lv_length).

                  ENDIF.

                ENDAT.

              ENDLOOP.

            ENDIF.

          ENDIF.

          cv_json = |{ cv_json }]|. "end fields

*         Add parameters
          IF lv_is_action = abap_on.
            READ TABLE lt_components ASSIGNING <fs_component> WITH KEY name = cl_abap_behv=>co_techfield_name-param.
            IF sy-subrc = 0.
              cl_ptf_json=>generate_params(
                EXPORTING
                  io_datadescr  = <fs_component>-type
                  is_action     = ls_action
                CHANGING
                  cv_json       = cv_json
              ).

            ENDIF.

          ENDIF.

        ENDIF.

      ELSE.
        cv_json = |{ cv_json },"ignore":true|.

      ENDIF.

*     If we have action then don't do assocations
*     To be changed in the future for actions that are n levels deep
      IF lv_is_action = abap_on.
        cv_json = |{ cv_json }\}|. "end entity fields
        RETURN.

      ENDIF.

*     Check if we have associations
      DATA(lt_associations) = FILTER #( ct_associations WHERE source_entity = iv_entity ).
      ct_associations = FILTER #( ct_associations EXCEPT WHERE source_entity = iv_entity ).
      DELETE ct_associations WHERE target_entity = iv_entity.

*     Remove associations that are not enabled
      DELETE lt_associations WHERE properties-enabled <> cl_abap_behv_load=>c_enabled.

*     Remove associations in CREATE operation that are not creatable
      CASE iv_ptf_act.
        WHEN 'CREATE'.
          DELETE lt_associations WHERE properties-has_create <> cl_abap_behv_load=>c_enabled_both.

      ENDCASE.

      IF NOT lt_associations IS INITIAL.
        lv_is_assoc = abap_on.
*        cv_nesting_level = cv_nesting_level + 1.
        lv_nesting_level = iv_nesting_level + 1.

      ENDIF.

*      IF iv_nesting_level <= 3. "Add only one level of deepness (currently although the logic works for n levels)
      IF lv_is_assoc = abap_on.
        cv_json = |{ cv_json },"associations":[|. "begin associations
      ENDIF.

      LOOP AT lt_associations ASSIGNING FIELD-SYMBOL(<fs_association>).
        lv_tabix = sy-tabix.

        IF lv_tabix = 1.
          lv_first = abap_on.

        ELSE.
          lv_first = abap_off.

        ENDIF.

        IF lv_tabix = lines( lt_associations ).
          lv_last = abap_on.

        ELSE.
          lv_last = abap_off.

        ENDIF.

        IF lv_first = abap_off.
          cv_json = |{ cv_json },|.

        ENDIF.

        IF line_exists( it_entities[ name = <fs_association>-target_entity ] ).
          ls_entity = it_entities[ name = <fs_association>-target_entity ].

          cv_json = |{ cv_json }\{"childEntityName":"{ ls_entity-ext_name }","assocName":"{ <fs_association>-name }"|.

          lv_entity = <fs_association>-target_entity.

          "RECURSION
          cl_ptf_json=>generate_json_fields(
            EXPORTING
              iv_entity         = lv_entity
              iv_ptf_act        = iv_ptf_act
              iv_ptf_json_opt   = iv_ptf_json_opt
              iv_last           = lv_last
              it_permissions    = it_permissions
              it_entities       = it_entities
              it_actions        = it_actions
              it_features       = it_features
              iv_nesting_level  = lv_nesting_level
            CHANGING
              ct_associations   = ct_associations
              cv_json           = cv_json ).

        ELSE. "foreign entity
          cl_abap_behv_load=>get_load(
            EXPORTING
              entity = <fs_association>-target_entity
              all    = abap_on
            IMPORTING
              entities     = DATA(lt_foreign_entities)
              associations = DATA(lt_foreign_associations)
          ).

          ls_entity = lt_foreign_entities[ name = <fs_association>-target_entity ].

          cv_json = |{ cv_json }\{"childEntityName":"{ ls_entity-ext_name }","assocName":"{ <fs_association>-name }"|.

          lv_entity = <fs_association>-target_entity.

*         Get Permissions for the foreign entity and its respective child entities
          cl_ptf_json=>get_permissions(
            EXPORTING
              iv_entity       = lv_entity
              it_entities     = lt_foreign_entities
              it_associations = lt_foreign_associations
            IMPORTING
              et_permissions  = DATA(lt_foreign_permissions)
          ).

          "RECURSION
          cl_ptf_json=>generate_json_fields(
            EXPORTING
              iv_entity         = lv_entity
              iv_ptf_act        = iv_ptf_act
              iv_ptf_json_opt   = iv_ptf_json_opt
              iv_last           = lv_last
              it_permissions    = lt_foreign_permissions
              it_entities       = lt_foreign_entities
              it_actions        = it_actions
              it_features       = it_features
              iv_nesting_level  = lv_nesting_level
            CHANGING
              ct_associations   = lt_foreign_associations
              cv_json           = cv_json ).

        ENDIF.

      ENDLOOP.

      IF lv_is_assoc = abap_on.
        cv_json = |{ cv_json }]|. "end associations

      ENDIF.

*      ENDIF. "cv_nesting_level

    ELSE.
*     Check if entity is local or foreign
      READ TABLE it_entities WITH KEY name = iv_entity TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0. "Foreign
        cv_json = |{ cv_json },"ignore":true|.

      ENDIF.

    ENDIF.

    IF iv_last = abap_off.
      cv_json = |{ cv_json }\},|. "end entity fields

    ELSE.
      cv_json = |{ cv_json }\}|. "end entity fields

    ENDIF.

  ENDMETHOD.


  METHOD generate_params.
    DATA: lo_structdescr      TYPE REF TO cl_abap_structdescr,
          lt_associations     TYPE cl_ptf_json=>tt_assoc,
          lt_features         TYPE cl_ptf_json=>tt_feature,
          lv_length           TYPE i.

    cl_ptf_json=>recursive_load_params_features(
      EXPORTING
        iv_parameter_type = is_action-parameter_type
      CHANGING
        ct_associations   = lt_associations
        ct_features       = lt_features
    ).

    SORT lt_associations BY source_entity name.
    DELETE ADJACENT DUPLICATES FROM lt_associations COMPARING source_entity name target_entity.

    SORT lt_features BY owner_entity element_kind element.
    DELETE ADJACENT DUPLICATES FROM lt_features COMPARING owner_entity element_kind element.

    cv_json = |{ cv_json },"params":[|.

    lo_structdescr ?= io_datadescr.
    DATA(lt_param_components) = mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

*   Remove %Control
    DELETE lt_param_components WHERE name = cl_abap_behv=>co_techfield_name-control.

    LOOP AT lt_param_components ASSIGNING FIELD-SYMBOL(<fs_param_component>).
      cl_ptf_json=>recursive_gen_params(
        EXPORTING
          is_componentdescr = <fs_param_component>
          it_associations   = lt_associations
          it_features       = lt_features
          iv_source_entity  = is_action-parameter_type
        CHANGING
          cv_json           = cv_json ).

      AT LAST.
        lv_length = strlen( cv_json ) - 1.
        cv_json = cv_json+0(lv_length).

      ENDAT.

    ENDLOOP.

    cv_json = |{ cv_json }]|. "end params

  ENDMETHOD.


  METHOD generate_sample_json.
*   Get permissions for the entities
    DATA lt_permissions   TYPE abp_behv_permissions_tab.

*   Generate default JSON
*    rv_json = '{"_comment":"JSON Example",'
*        && '"fields":['.
*
*    IF iv_ptf_json_opt <> '1'.
*      rv_json = rv_json
*        && '{"name":"col1","value":"val1"},{"name":"col2","value":"val2"},{"name":"col3","value":"val3"}'.
*
*    ENDIF.
*
*    rv_json = rv_json
*        && '],"associations":[{"childEntityName":"childEntity1","assocName":"assocName1","fields":['.
*
*    IF iv_ptf_json_opt <> '1'.
*      rv_json = rv_json
*          && '{"name":"ccol1","value":"cval1"},{"name":"ccol2","value":"cval2"}'.
*
*    ENDIF.
*
*    rv_json = rv_json
*        && ']}]}'.

*   Check if we have a valid RAP business object
    IF mo_ptf_rap_metadata->check_rap_bo( iv_bus_obj = iv_ptf_bo ) = abap_on
      AND mo_ptf_rap_metadata->check_rap_bo_action( iv_bus_obj = iv_ptf_bo iv_action = iv_ptf_act ) = abap_on.
      cl_abap_behv_load=>get_load(
        EXPORTING
          entity = iv_ptf_bo
          all    = abap_on
        IMPORTING
          entities     = DATA(lt_entities)
          associations = DATA(lt_associations)
          actions      = DATA(lt_actions)
          features     = DATA(lt_features)
      ).

*     Stop code generation if there are no entities found
      IF NOT line_exists( lt_entities[ name = iv_ptf_bo ] ).
        RETURN.

      ENDIF.

*     Delete actions that are not enabled
      DELETE lt_actions WHERE properties-enabled <> cl_abap_behv_load=>c_enabled.

      DATA(ls_entity) = lt_entities[ name = iv_ptf_bo ].

      CASE iv_ptf_act.
        WHEN 'CREATE'.
          CASE ls_entity-properties-has_create.
            WHEN cl_abap_behv_load=>c_enabled_both.
              rv_json = |\{"_comment":"JSON Create Example for RAP BO { ls_entity-ext_name }"{ cl_abap_char_utilities=>newline }|. "begin root entity

            WHEN abap_off.
              rv_json = |\{"_comment":"JSON Create for RAP BO { ls_entity-ext_name } not allowed"{ cl_abap_char_utilities=>newline }|. "begin root entity

          ENDCASE.

        WHEN 'CHANGE'.
          CASE ls_entity-properties-has_update.
            WHEN cl_abap_behv_load=>c_enabled_both.
              rv_json = |\{"_comment":"JSON Update Example for RAP BO { ls_entity-ext_name }"{ cl_abap_char_utilities=>newline }|. "begin root entity

            WHEN abap_off.
              rv_json = |\{"_comment":"JSON Update for RAP BO { ls_entity-ext_name } not allowed"{ cl_abap_char_utilities=>newline }|. "begin root entity

          ENDCASE.

        WHEN 'DELETE'.
          CASE ls_entity-properties-has_delete.
            WHEN cl_abap_behv_load=>c_enabled_both.
              rv_json = |\{"_comment":"JSON Delete Example for RAP BO { ls_entity-ext_name }"{ cl_abap_char_utilities=>newline }|. "begin root entity

            WHEN abap_off.
              rv_json = |\{"_comment":"JSON Delete for RAP BO { ls_entity-ext_name } not allowed"{ cl_abap_char_utilities=>newline }|. "begin root entity

          ENDCASE.

        WHEN 'CHECK'.
          rv_json = |\{"_comment":"JSON Check Example for RAP BO { ls_entity-ext_name }"{ cl_abap_char_utilities=>newline }|. "begin root entity

        WHEN 'CHECK_IF_EXISTS'.
          rv_json = |\{"_comment":"JSON Check if Exists Example for RAP BO { ls_entity-ext_name }"{ cl_abap_char_utilities=>newline }|. "begin root entity

        WHEN 'ENTITY_ACTION'.
*         make one per each child entity action
*          rv_json = |\{"_comment":"JSON Action Example for RAP BO child entity"{ cl_abap_char_utilities=>newline }|. "begin child entity
*          rv_json = |{ rv_json },"action":"actionName","childEntityName":"childEntityName","fields":[\{"name":"ccol1","value":"cval1"\},\{"name":"ccol2","value":"cval2"\}],"params":[]|.
*
*          rv_json = |{ rv_json }\}|. "end child entity
*          RETURN.

        WHEN 'RETRIEVE'.
          rv_json = |\{"_comment":"JSON Retrieve Example for RAP BO { ls_entity-ext_name }"{ cl_abap_char_utilities=>newline }|. "begin root entity

        WHEN 'RETRIEVE_ALL'.
          rv_json = |\{"_comment":"JSON Retrieve All Example for RAP BO { ls_entity-ext_name }"{ cl_abap_char_utilities=>newline }|. "begin root entity

        WHEN 'COMMIT'.
          CLEAR rv_json.
          RETURN.

        WHEN 'MODIFY'.
          rv_json = |\{"_comment":"JSON MODIFY Example for RAP BO { ls_entity-ext_name } - EML operations table"{ cl_abap_char_utilities=>newline }|.
          CLEAR rv_json.
          RETURN.

        WHEN OTHERS. "Action
          TRY.
              DATA(ls_action) = lt_actions[ name = iv_ptf_act ] ##NEEDED.
              "lv_is_action = abap_on.

              rv_json = |\{"_comment":"JSON Action Example for RAP BO { ls_entity-ext_name } - action { ls_action-ext_name }"{ cl_abap_char_utilities=>newline }|. "begin root entity
              rv_json = |{ rv_json },"action":"{ ls_action-ext_name }"|.

            CATCH cx_sy_itab_line_not_found ##NO_HANDLER.
              rv_json = |\{"_comment":"JSON Action { ls_action-ext_name } is invalid"{ cl_abap_char_utilities=>newline }|. "begin root entity

          ENDTRY.

      ENDCASE.

      cl_ptf_json=>get_permissions(
        EXPORTING
          iv_entity       = iv_ptf_bo
          it_entities     = lt_entities
          it_associations = lt_associations
        IMPORTING
          et_permissions  = lt_permissions
      ).

      cl_ptf_json=>generate_json_fields(
          EXPORTING
            iv_entity       = iv_ptf_bo
            iv_ptf_act      = iv_ptf_act
            iv_ptf_json_opt = iv_ptf_json_opt
            it_permissions  = lt_permissions
            it_entities     = lt_entities
            it_actions      = lt_actions
            it_features     = lt_features
          CHANGING
            ct_associations = lt_associations
            cv_json         = rv_json ).

      "rv_json = |{ rv_json }\}|. "end root entity

      cl_ptf_json=>pretty_printer( EXPORTING iv_entity = iv_ptf_bo CHANGING cv_json = rv_json ).

    ENDIF.

  ENDMETHOD.


  METHOD handle_exception.
    DATA: lx_sxml_parse_error     TYPE REF TO cx_sxml_parse_error,
          lv_text                 TYPE string,
          lv_msgv1                TYPE char50,
          lv_msgv2                TYPE char50,
          lv_msgv3                TYPE char50,
          lv_msgv4                TYPE char50.

    lv_text = io_message->get_text( ).

    lv_msgv1 = COND #( WHEN strlen( lv_text ) > 0 THEN lv_text+0 ).
    lv_msgv2 = COND #( WHEN strlen( lv_text ) > 50 THEN lv_text+50 ) ##NUMBER_OK.
    lv_msgv3 = COND #( WHEN strlen( lv_text ) > 100 THEN lv_text+100 ).
    lv_msgv4 = COND #( WHEN strlen( lv_text ) > 150 THEN lv_text+150 ) ##NUMBER_OK.

    IF io_message IS INSTANCE OF cx_sxml_parse_error.
      lx_sxml_parse_error ?= io_message.
      RAISE EXCEPTION TYPE cx_ptf_json MESSAGE ID 'PTF' TYPE 'E' NUMBER '070' WITH lv_msgv1 lv_msgv2 lv_msgv3 lv_msgv4
      EXPORTING offset = lx_sxml_parse_error->xml_offset.

    ELSE.
      RAISE EXCEPTION TYPE cx_ptf_json MESSAGE ID 'PTF' TYPE 'E' NUMBER '070' WITH lv_msgv1 lv_msgv2 lv_msgv3 lv_msgv4.

    ENDIF.

  ENDMETHOD.


  METHOD pretty_printer.
    DATA: lv_offset          TYPE i,
          lv_length          TYPE i,
          lv_comm_occ        TYPE i,
          lv_opensbrackets   TYPE i,
          lv_is_params       TYPE abap_bool,
          lv_horizontal_tabs TYPE string.

    CONSTANTS: lc_ignore          TYPE string VALUE ',"ignore"',
               lc_isdraft         TYPE string VALUE ',"isDraft"',
               lc_fields          TYPE string VALUE ',"fields"',
               lc_params          TYPE string VALUE ',"params"',
               lc_action          TYPE string VALUE ',"action"',
               lc_childentityname TYPE string VALUE '{"childEntityName":',
               lc_associations    TYPE string VALUE ',"associations":[',
               lc_opensbracket    TYPE string VALUE '[',
               lc_closesbracket   TYPE string VALUE ']',
               lc_endassociation  TYPE string VALUE ']}',
               lc_comment         TYPE string VALUE '{"_comment":',
               lc_name            TYPE string VALUE '{"name":'.

    DATA(lv_json) = cv_json.

    cl_abap_behv_load=>get_load(
      EXPORTING
        entity       = iv_entity
        all          = abap_on
      IMPORTING
        entities     = DATA(lt_entities)
        "associations = DATA(lt_associations)
        actions      = DATA(lt_actions)
        "features     = DATA(lt_features)
    ).

*   Remove all cr_lf added by editor
    lv_json = replace( val = lv_json sub = cl_abap_char_utilities=>cr_lf with = space occ = 0 ).

*   Remove all new lines
    lv_json = replace( val = lv_json sub = cl_abap_char_utilities=>newline with = space occ = 0 ).

*   Remove all horizontal tabs
    lv_json = replace( val = lv_json sub = cl_abap_char_utilities=>horizontal_tab with = space occ = 0 ).

*   Remove unneeded spaces between JSON delimiters
    lv_json = replace( val = lv_json pcre = '(?<=\,|\"|\{|\[|\]|\}|\:)\s+(?=|\"|\{|\[|\]|\}|\:)' with = '' occ = 0 ).

*   Add one new line before first ,"ignore" else "isDraft", else "fields"
    IF count( val = lv_json pcre = lc_ignore ) > 0.
      lv_json = replace( val = lv_json pcre = lc_ignore with = |{ cl_abap_char_utilities=>newline }{ lc_ignore }| ).

    ELSEIF count( val = lv_json pcre = lc_isdraft ) > 0.
      lv_json = replace( val = lv_json pcre = lc_isdraft with = |{ cl_abap_char_utilities=>newline }{ lc_isdraft }| ).

    ELSE.
*     Add only if there is no ,"action"
      IF count( val = lv_json pcre = lc_action ) = 0.
        lv_json = replace( val = lv_json pcre = lc_fields with = |{ cl_abap_char_utilities=>newline }{ lc_fields }| ).

      ENDIF.

    ENDIF.

*   Add one new line before each ,"action"
    lv_json = replace( val = lv_json pcre = lc_action with = |{ cl_abap_char_utilities=>newline }{ lc_action }| occ = 0 ).

*   Add 2 new lines before \{"childEntityName"
    lv_json = replace( val = lv_json pcre = |\\{ lc_childentityname }| with = |{ cl_abap_char_utilities=>newline }{ cl_abap_char_utilities=>newline }\\{ lc_childentityname }| occ = 0 ).

*   Replace entities name with external names
    LOOP AT lt_entities ASSIGNING FIELD-SYMBOL(<fs_entity>).
      lv_json = replace( val = lv_json pcre = <fs_entity>-name with = <fs_entity>-ext_name case = abap_false occ = 0 ).

    ENDLOOP.

*   Replace action names with external names
    LOOP AT lt_actions ASSIGNING FIELD-SYMBOL(<fs_action>).
      lv_json = replace( val = lv_json pcre = <fs_action>-name with = <fs_action>-ext_name case = abap_false occ = 0 ).

    ENDLOOP.

*   Add 2 new lines before each {"_comment after the first
*   Add 1 new line after end of associations
    CLEAR: lv_length, lv_offset.

    DO.
      lv_length = strlen( lc_comment ).

      TRY.
          IF lv_json+lv_offset(lv_length) = lc_comment.
            lv_comm_occ = lv_comm_occ + 1.

            IF lv_comm_occ > 1.
              lv_json = |{ lv_json+0(lv_offset) }{ cl_abap_char_utilities=>newline }{ cl_abap_char_utilities=>newline }{ lv_json+lv_offset }|.
              lv_offset = lv_offset + 2.

            ENDIF.

          ENDIF.

        CATCH cx_sy_range_out_of_bounds ##NO_HANDLER.
      ENDTRY.

      lv_length = strlen( lc_opensbracket ).

      TRY.
          DATA(lv_prev_offset) = lv_offset - 1. "check if previous character was not again [

          IF lv_json+lv_prev_offset(lv_length) <> lc_opensbracket.
            IF lv_json+lv_offset(lv_length) = lc_opensbracket.
              lv_opensbrackets = lv_opensbrackets + 1.

            ENDIF.

          ENDIF.

        CATCH cx_sy_range_out_of_bounds ##NO_HANDLER.
      ENDTRY.

      lv_length = strlen( lc_associations ).

      TRY.
          IF lv_json+lv_offset(lv_length) = lc_associations.
            DATA(lv_associations_tabs) = lv_opensbrackets.

            IF lv_associations_tabs > 1.
              lv_associations_tabs = lv_associations_tabs + 1.

            ENDIF.

            CLEAR lv_horizontal_tabs.

            DO lv_associations_tabs TIMES.
              lv_horizontal_tabs = |{ lv_horizontal_tabs }{ cl_abap_char_utilities=>horizontal_tab }|.

            ENDDO.

            lv_json = |{ lv_json+0(lv_offset) }{ cl_abap_char_utilities=>newline }{ lv_horizontal_tabs }{ lv_json+lv_offset }|.
            lv_offset = lv_offset + lv_associations_tabs + 1.

          ENDIF.

        CATCH cx_sy_range_out_of_bounds ##NO_HANDLER.
      ENDTRY.

      lv_length = strlen( lc_childentityname ).

      TRY.
          IF lv_json+lv_offset(lv_length) = lc_childentityname.
            DATA(lv_centityname_tabs) = lv_opensbrackets.

            CLEAR lv_horizontal_tabs.

            DO lv_centityname_tabs TIMES.
              lv_horizontal_tabs = |{ lv_horizontal_tabs }{ cl_abap_char_utilities=>horizontal_tab }|.

            ENDDO.

            lv_json = |{ lv_json+0(lv_offset) }{ lv_horizontal_tabs }{ lv_json+lv_offset }|.
            lv_offset = lv_offset + lv_centityname_tabs.

          ENDIF.

        CATCH cx_sy_range_out_of_bounds ##NO_HANDLER.
      ENDTRY.

      lv_length = strlen( lc_action ).

      TRY.
          IF lv_json+lv_offset(lv_length) = lc_action.
            lv_is_params = abap_off.

          ENDIF.

        CATCH cx_sy_range_out_of_bounds ##NO_HANDLER.
      ENDTRY.


      lv_length = strlen( lc_params ).

      TRY.
          IF lv_json+lv_offset(lv_length) = lc_params.
            lv_is_params = abap_on.

            DATA(lv_params_tabs) = lv_opensbrackets.

            IF lv_params_tabs IS INITIAL.
              lv_params_tabs = lv_params_tabs + 1.

            ENDIF.

            CLEAR lv_horizontal_tabs.

            DO lv_params_tabs TIMES.
              lv_horizontal_tabs = |{ lv_horizontal_tabs }{ cl_abap_char_utilities=>horizontal_tab }|.

            ENDDO.

            lv_json = |{ lv_json+0(lv_offset) }{ cl_abap_char_utilities=>newline }{ lv_horizontal_tabs }{ lv_json+lv_offset }|.
            lv_offset = lv_offset + lv_params_tabs + 1.

          ENDIF.

        CATCH cx_sy_range_out_of_bounds ##NO_HANDLER.
      ENDTRY.

      lv_length = strlen( lc_name ).

      TRY.
          IF lv_json+lv_offset(lv_length) = lc_name.
            DATA(lv_name_tabs) = lv_opensbrackets.

            IF lv_is_params = abap_on.
              lv_name_tabs = lv_name_tabs + 1.

            ENDIF.

            CLEAR lv_horizontal_tabs.

            DO lv_name_tabs TIMES.
              lv_horizontal_tabs = |{ lv_horizontal_tabs }{ cl_abap_char_utilities=>horizontal_tab }|.

            ENDDO.

            lv_json = |{ lv_json+0(lv_offset) }{ cl_abap_char_utilities=>newline }{ lv_horizontal_tabs }{ lv_json+lv_offset }|.
            lv_offset = lv_offset + lv_name_tabs + 1.

          ENDIF.

        CATCH cx_sy_range_out_of_bounds ##NO_HANDLER.
      ENDTRY.

      lv_length = strlen( lc_closesbracket ).

      TRY.
          DATA(lv_next_offset) = lv_offset + 1. "check if next character is not again ]

          IF lv_json+lv_next_offset(lv_length) <> lc_closesbracket.
            IF lv_json+lv_offset(lv_length) = lc_closesbracket.
              IF lv_opensbrackets > 0.
                lv_opensbrackets = lv_opensbrackets - 1.

              ENDIF.

            ENDIF.

          ENDIF.

        CATCH cx_sy_range_out_of_bounds ##NO_HANDLER.
      ENDTRY.

      lv_length = strlen( lc_endassociation ).

      TRY.
          IF lv_json+lv_offset(lv_length) = lc_endassociation. "also end of params
            DATA(lv_endassoc_tabs) = lv_opensbrackets.

            IF lv_is_params = abap_on AND lv_endassoc_tabs IS NOT INITIAL.
              lv_endassoc_tabs = lv_endassoc_tabs + 1.

            ENDIF.

            CLEAR lv_horizontal_tabs.

            DO lv_endassoc_tabs TIMES.
              lv_horizontal_tabs = |{ lv_horizontal_tabs }{ cl_abap_char_utilities=>horizontal_tab }|.

            ENDDO.

            lv_json = |{ lv_json+0(lv_offset) }{ cl_abap_char_utilities=>newline }{ lv_horizontal_tabs }{ lv_json+lv_offset }|.
            lv_offset = lv_offset + lv_endassoc_tabs + 1.

          ENDIF.

        CATCH cx_sy_range_out_of_bounds ##NO_HANDLER.
      ENDTRY.

      lv_offset = lv_offset + 1.

      IF lv_offset >= strlen( lv_json ).
        EXIT.

      ENDIF.

    ENDDO.

    cv_json = lv_json.

  ENDMETHOD.


  METHOD pretty_printer_tdo.
    DATA: lv_offset          TYPE i,
          lv_next_offset     TYPE i,
          lv_length          TYPE i,
          lv_opensbrackets   TYPE i,
          lv_horizontal_tabs TYPE string.

    CONSTANTS: lc_opensbracket    TYPE string VALUE '[',
               lc_closesbracket   TYPE string VALUE ']',
               lc_new_field       TYPE string VALUE ',"',
               lc_new_assoc       TYPE string VALUE ',{'.

    DATA(lv_json) = cv_json.

*   Remove all cr_lf added by editor
    lv_json = replace( val = lv_json sub = cl_abap_char_utilities=>cr_lf with = space occ = 0 ).

*   Remove all new lines
    lv_json = replace( val = lv_json sub = cl_abap_char_utilities=>newline with = space occ = 0 ).

*   Remove all horizontal tabs
    lv_json = replace( val = lv_json sub = cl_abap_char_utilities=>horizontal_tab with = space occ = 0 ).

*   Remove unneeded spaces between JSON delimiters
    lv_json = replace( val = lv_json pcre = '(?<=\,|\"|\{|\[|\]|\}|\:)\s+(?=|\"|\{|\[|\]|\}|\:)' with = '' occ = 0 ).

*   Add 1 new line after beggining of [
    CLEAR: lv_length, lv_offset.

    DO.
      lv_length = strlen( lc_opensbracket ).

      TRY.
          DATA(lv_prev_offset) = lv_offset - 1. "check if previous character was not again [

          IF lv_json+lv_prev_offset(lv_length) <> lc_opensbracket.
            IF lv_json+lv_offset(lv_length) = lc_opensbracket.
              lv_opensbrackets = lv_opensbrackets + 1.

              CLEAR lv_horizontal_tabs.

              DO lv_opensbrackets TIMES.
                lv_horizontal_tabs = |{ lv_horizontal_tabs }{ cl_abap_char_utilities=>horizontal_tab }|.

              ENDDO.

              lv_json = |{ lv_json+0(lv_offset) }{ cl_abap_char_utilities=>newline }{ lv_horizontal_tabs }{ lv_json+lv_offset }|.
              lv_offset = lv_offset + lv_opensbrackets + 1.

            ENDIF.

          ENDIF.

        CATCH cx_sy_range_out_of_bounds ##NO_HANDLER.
      ENDTRY.

      lv_length = strlen( lc_new_field ).

      TRY.
        IF lv_json+lv_offset(lv_length) = lc_new_field.
          lv_next_offset = lv_offset + 1.

          CLEAR lv_horizontal_tabs.

          DO lv_opensbrackets TIMES.
            lv_horizontal_tabs = |{ lv_horizontal_tabs }{ cl_abap_char_utilities=>horizontal_tab }|.

          ENDDO.

          lv_json = |{ lv_json+0(lv_next_offset) }{ cl_abap_char_utilities=>newline }{ lv_horizontal_tabs }{ lv_json+lv_next_offset }|.
          lv_offset = lv_offset + lv_opensbrackets + 1.

        ENDIF.

        CATCH cx_sy_range_out_of_bounds ##NO_HANDLER.
      ENDTRY.

      lv_length = strlen( lc_new_assoc ).

      TRY.
        IF lv_json+lv_offset(lv_length) = lc_new_assoc.
          lv_next_offset = lv_offset + 1.

          CLEAR lv_horizontal_tabs.

          DO lv_opensbrackets TIMES.
            lv_horizontal_tabs = |{ lv_horizontal_tabs }{ cl_abap_char_utilities=>horizontal_tab }|.

          ENDDO.

          lv_json = |{ lv_json+0(lv_next_offset) }{ cl_abap_char_utilities=>newline }{ lv_horizontal_tabs }{ lv_json+lv_next_offset }|.
          lv_offset = lv_offset + lv_opensbrackets + 1.

        ENDIF.

        CATCH cx_sy_range_out_of_bounds ##NO_HANDLER.
      ENDTRY.

      lv_length = strlen( lc_closesbracket ).

      TRY.
          lv_next_offset = lv_offset + 1. "check if next character is not again ]

          IF lv_json+lv_next_offset(lv_length) <> lc_closesbracket.
            IF lv_json+lv_offset(lv_length) = lc_closesbracket.
              IF lv_opensbrackets > 0.
                lv_opensbrackets = lv_opensbrackets - 1.

              ENDIF.

            ENDIF.

          ENDIF.

        CATCH cx_sy_range_out_of_bounds ##NO_HANDLER.
      ENDTRY.

      lv_offset = lv_offset + 1.

      IF lv_offset >= strlen( lv_json ).
        EXIT.

      ENDIF.

    ENDDO.

    cv_json = lv_json.

  ENDMETHOD.


  METHOD recursive_fill_associations.
    DATA: ls_associations TYPE ts_associations,
          lv_entity       TYPE abp_entity_name.

    FIELD-SYMBOLS: <fs_table>           TYPE ANY TABLE,
                   <fs_assoc_line>      TYPE any,
                   <fs_line>            TYPE any.

    ASSIGN is_data TO FIELD-SYMBOL(<fs_data>).

*   Get associations
    ASSIGN COMPONENT 'ASSOCIATIONS' OF STRUCTURE <fs_data> TO FIELD-SYMBOL(<fs_associations>).
    IF sy-subrc = 0.
      ASSIGN <fs_associations>->* TO <fs_table>.
      IF sy-subrc = 0.
        LOOP AT <fs_table> ASSIGNING FIELD-SYMBOL(<fs_association>).
          ASSIGN <fs_association>->* TO <fs_assoc_line>.
          IF sy-subrc = 0.
            ASSIGN COMPONENT 'ASSOCNAME' OF STRUCTURE <fs_assoc_line> TO FIELD-SYMBOL(<fs_assocname_ref>).
            IF sy-subrc = 0.
              ASSIGN <fs_assocname_ref>->* TO FIELD-SYMBOL(<fs_assocname>).

            ENDIF.

            ASSIGN COMPONENT 'CHILDENTITYNAME' OF STRUCTURE <fs_assoc_line> TO FIELD-SYMBOL(<fs_childentityname_ref>).
            IF sy-subrc = 0.
              ASSIGN <fs_childentityname_ref>->* TO FIELD-SYMBOL(<fs_childentityname>).

            ENDIF.

            IF <fs_assocname> IS ASSIGNED AND <fs_childentityname> IS ASSIGNED.
              CLEAR: ls_associations.

              ls_associations-assocname        = to_upper( <fs_assocname> ).

              ls_associations-childentityname  = to_upper( <fs_childentityname> ).

              lv_entity = ls_associations-childentityname.

              cl_ptf_json=>fill_fields( EXPORTING is_data = <fs_assoc_line> IMPORTING et_fields = ls_associations-fields ).

*             Push key fields if they don't exist
              cl_ptf_json=>add_key_fields(
                EXPORTING
                  iv_entity = lv_entity
                  iv_action = iv_action
                CHANGING
                  ct_fields = ls_associations-fields
              ).

*             Check if we should add operators
              cl_ptf_json=>fill_operators( EXPORTING is_data = <fs_assoc_line> IMPORTING et_operators = ls_associations-operators ).

*             Check if we should add initials
              cl_ptf_json=>fill_initials( EXPORTING is_data = <fs_assoc_line> IMPORTING et_initials = ls_associations-initials ).

*             Check if we should add ignore
              cl_ptf_json=>fill_ignore( EXPORTING is_data = <fs_assoc_line> CHANGING ct_fields = ls_associations-fields ).

*             Check if we should add isExisting
              cl_ptf_json=>fill_isexisting( EXPORTING is_data = <fs_assoc_line> CHANGING ct_fields = ls_associations-fields ).

              TRY.
                  ls_associations-id = cl_system_uuid=>create_uuid_c32_static( ).

                CATCH cx_uuid_error ##NO_HANDLER.
              ENDTRY.

              ls_associations-parent_id = iv_parent_id.

*             Check if there are child associations
              ASSIGN <fs_association>->* TO <fs_line>.

              cl_ptf_json=>recursive_fill_associations( EXPORTING is_data         = <fs_line>
                                                                  iv_parent_id    = ls_associations-id
                                                                  iv_action       = iv_action
                                                        CHANGING  ct_associations = ct_associations ).

              APPEND ls_associations TO ct_associations.

            ENDIF.

          ENDIF.

        ENDLOOP.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD recursive_fill_data_structure.
    DATA: lr_data        TYPE REF TO data,
          lo_structdescr TYPE REF TO cl_abap_structdescr,
          lt_components  TYPE abap_component_tab.

    FIELD-SYMBOLS: <fs_data_association> TYPE ts_associations,
                   <fs_assoc_table>      TYPE STANDARD TABLE,
                   <fs_assoc_line>       TYPE any,
                   <fs_operators>        TYPE any,
                   <fs_initials>         TYPE any,
                   <fs_data_field>       TYPE ts_fields,
                   <fs_data_operator>    TYPE ts_operators,
                   <fs_data_initial>     TYPE ts_initials,
                   <fs_value>            TYPE any.

    DATA(lt_associations) = is_data-associations.
    DELETE lt_associations WHERE parent_id <> iv_parent_id.
    IF iv_childentityname IS SUPPLIED.
      DELETE lt_associations WHERE childentityname <> iv_childentityname.

    ENDIF.

    SORT lt_associations BY assocname childentityname.

    ASSIGN cr_data->* TO FIELD-SYMBOL(<fs_data>).

    LOOP AT lt_associations ASSIGNING <fs_data_association>.
      ASSIGN COMPONENT <fs_data_association>-childentityname OF STRUCTURE <fs_data> TO <fs_assoc_table>.
      IF sy-subrc = 0.
        APPEND INITIAL LINE TO <fs_assoc_table> ASSIGNING <fs_assoc_line>.

        lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_assoc_line> ).
        lt_components = mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

        LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
          READ TABLE <fs_data_association>-fields ASSIGNING <fs_data_field> WITH KEY name = <fs_component>-name.
          IF sy-subrc = 0. "We have a plain field name
            ASSIGN COMPONENT <fs_data_field>-name OF STRUCTURE <fs_assoc_line> TO <fs_value>.
            IF sy-subrc = 0.
              <fs_value> = <fs_data_field>-value.

            ENDIF.

          ELSE.
            CASE <fs_component>-name.
              WHEN '_OPERATORS'. "We have operators
                ASSIGN COMPONENT '_OPERATORS' OF STRUCTURE <fs_assoc_line> TO <fs_operators>.
                IF sy-subrc = 0.
                  LOOP AT <fs_data_association>-operators ASSIGNING <fs_data_operator>.
                    ASSIGN COMPONENT <fs_data_operator>-name OF STRUCTURE <fs_operators> TO <fs_value>.
                    IF sy-subrc = 0.
                      <fs_value> = <fs_data_operator>-operator.

                    ENDIF.

                  ENDLOOP.

                ENDIF.

              WHEN '_INITIALS'. "We have initials
                ASSIGN COMPONENT '_INITIALS' OF STRUCTURE <fs_assoc_line> TO <fs_initials>.
                IF sy-subrc = 0.
                  LOOP AT <fs_data_association>-initials ASSIGNING <fs_data_initial>.
                    ASSIGN COMPONENT <fs_data_initial>-name OF STRUCTURE <fs_initials> TO <fs_value>.
                    IF sy-subrc = 0.
                      <fs_value> = <fs_data_initial>-initial.

                    ENDIF.

                  ENDLOOP.

                ENDIF.

              WHEN OTHERS.
*               Here we should have a name of a child entity of the current entity name however
*               we might have an association, alternative would be to check if the field doesn't have _, because that is the field that holds the actual assoc name
                READ TABLE is_data-associations WITH KEY parent_id = <fs_data_association>-id childentityname = <fs_component>-name
                TRANSPORTING NO FIELDS.
                IF sy-subrc = 0.
                  GET REFERENCE OF <fs_assoc_line> INTO lr_data.

                  cl_ptf_json=>recursive_fill_data_structure( EXPORTING iv_parent_id        = <fs_data_association>-id
                                                                        iv_childentityname  = <fs_component>-name
                                                                        is_data             = is_data
                                                              CHANGING  cr_data             = lr_data ).

                ENDIF.

            ENDCASE.

          ENDIF.

        ENDLOOP.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD recursive_fill_ops_read_assocs.
    FIELD-SYMBOLS: <fs_operation_read> TYPE abp_behv_retrievals,
                   <fs_result>         TYPE any.

    IF iv_name IS SUPPLIED. "We have root entity
      LOOP AT it_operations_read ASSIGNING <fs_operation_read> WHERE entity_name = iv_name AND sub_name IS NOT INITIAL.
        LOOP AT <fs_operation_read>-results->* ASSIGNING <fs_result>.
          fill_op_read_result(
            EXPORTING
              it_operations_read  = it_operations_read
              it_associations     = it_associations
              iv_parent_id        = iv_parent_id
              is_result           = <fs_result>
              is_operation_read   = <fs_operation_read>
            CHANGING
              ct_associations     = ct_associations
          ).

        ENDLOOP.

      ENDLOOP.

    ELSE. "We do not have root entity
      READ TABLE it_operations_read ASSIGNING <fs_operation_read> INDEX 1.
      IF sy-subrc = 0.
        LOOP AT <fs_operation_read>-results->* ASSIGNING <fs_result>.
          fill_op_read_result(
            EXPORTING
              it_operations_read  = it_operations_read
              it_associations     = it_associations
              iv_parent_id        = iv_parent_id
              is_result           = <fs_result>
              is_operation_read   = <fs_operation_read>
            CHANGING
              ct_associations     = ct_associations
          ).

        ENDLOOP.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD recursive_fill_params.
    DATA: lo_datadescr           TYPE REF TO cl_abap_datadescr,
          lo_tabledescr          TYPE REF TO cl_abap_tabledescr,
          lo_structdescr         TYPE REF TO cl_abap_structdescr,
          lx_sy_struct_comp_name TYPE REF TO cx_sy_struct_comp_name,
          lr_data                TYPE REF TO data,
          lt_components          TYPE abap_component_tab,
          lt_component_tab       TYPE abap_component_tab,
          ls_componentdescr      TYPE abap_componentdescr.

    FIELD-SYMBOLS: <fs_table>           TYPE STANDARD TABLE,
                   <fs_table_fields>    TYPE STANDARD TABLE,
                   <fs_param>           TYPE any,
                   <fs_line_ref>        TYPE any,
                   <fs_line_fields_ref> TYPE any,
                   <fs_line>            TYPE any,
                   <fs_name_ref>        TYPE any,
                   <fs_name>            TYPE any,
                   <fs_value_ref>       TYPE any,
                   <fs_value>           TYPE any,
                   <fs_field_ref>       TYPE any,
                   <fs_field>           TYPE any,
                   <fs_data>            TYPE any,
                   <fs_data_table>      TYPE STANDARD TABLE,
                   <fs_componentdescr>  TYPE abap_componentdescr.

    CLEAR er_data.

    ASSIGN ir_data->* TO <fs_param>.
    IF sy-subrc = 0.
      ASSIGN COMPONENT 'NAME' OF STRUCTURE <fs_param> TO <fs_name_ref>.
      IF sy-subrc = 0.
        ASSIGN <fs_name_ref>->* TO <fs_name>.

      ENDIF.

      ASSIGN COMPONENT 'VALUE' OF STRUCTURE <fs_param> TO <fs_value_ref>.
      IF sy-subrc = 0.
        ASSIGN <fs_value_ref>->* TO <fs_value>.

      ENDIF.

      IF <fs_name> IS ASSIGNED AND <fs_value> IS ASSIGNED.
        lo_datadescr ?= cl_abap_datadescr=>describe_by_data( <fs_value> ).

        CASE lo_datadescr->type_kind.
          WHEN cl_abap_typedescr=>typekind_table.
            ASSIGN <fs_value> TO <fs_table>.
            READ TABLE <fs_table> ASSIGNING <fs_line_ref> INDEX 1.
            IF sy-subrc = 0.
              ASSIGN <fs_line_ref>->* TO <fs_line>.

              lo_datadescr ?= cl_abap_datadescr=>describe_by_data( <fs_line> ).

              CASE lo_datadescr->type_kind.
                WHEN cl_abap_typedescr=>typekind_table. "internal table
                  LOOP AT <fs_table> ASSIGNING <fs_line_ref>.
                    ASSIGN <fs_line_ref>->* TO <fs_table_fields>.
                    LOOP AT <fs_table_fields> ASSIGNING <fs_line_fields_ref>.
                      UNASSIGN: <fs_name>, <fs_value>.

                      ASSIGN <fs_line_fields_ref>->* TO <fs_line>.

                      ASSIGN COMPONENT 'NAME' OF STRUCTURE <fs_line> TO <fs_name_ref>.
                      IF sy-subrc = 0.
                        ASSIGN <fs_name_ref>->* TO <fs_name>.

                      ENDIF.

                      ASSIGN COMPONENT 'VALUE' OF STRUCTURE <fs_line> TO <fs_value_ref>.
                      IF sy-subrc = 0. "because value might be nested
                        cl_ptf_json=>recursive_fill_params(
                                              EXPORTING
                                                ir_data        = <fs_line_fields_ref>
                                              IMPORTING
                                                er_data        = lr_data
                        ).

                        ASSIGN lr_data->* TO <fs_value>.

                        lo_datadescr ?= cl_abap_datadescr=>describe_by_data( <fs_value> ).

                      ENDIF.

                      IF NOT line_exists( lt_component_tab[ name = <fs_name> ] ).
                        ls_componentdescr = VALUE #( name = <fs_name> type = lo_datadescr ).
                        APPEND ls_componentdescr TO lt_component_tab.

                      ENDIF.

                    ENDLOOP.

                  ENDLOOP.

                  TRY.
                      lo_structdescr = cl_abap_structdescr=>get( lt_component_tab ).

                    CATCH cx_sy_struct_comp_name INTO lx_sy_struct_comp_name.
                      handle_exception( lx_sy_struct_comp_name ).

                  ENDTRY.

                  lo_tabledescr = cl_abap_tabledescr=>get( EXPORTING p_line_type = lo_structdescr ).

                  CREATE DATA er_data TYPE HANDLE lo_tabledescr.

                  ASSIGN er_data->* TO <fs_data_table>.

                  LOOP AT <fs_table> ASSIGNING <fs_line_ref>.
                    ASSIGN <fs_line_ref>->* TO <fs_table_fields>.

                    APPEND INITIAL LINE TO <fs_data_table> ASSIGNING <fs_data>.

                    LOOP AT <fs_table_fields> ASSIGNING <fs_line_fields_ref>.
                      UNASSIGN: <fs_name>, <fs_value>.

                      ASSIGN <fs_line_fields_ref>->* TO <fs_line>.

                      ASSIGN COMPONENT 'NAME' OF STRUCTURE <fs_line> TO <fs_name_ref>.
                      IF sy-subrc = 0.
                        ASSIGN <fs_name_ref>->* TO <fs_name>.

                      ENDIF.

                      ASSIGN COMPONENT 'VALUE' OF STRUCTURE <fs_line> TO <fs_value_ref>.
                      IF sy-subrc = 0. "because value might be nested
                        cl_ptf_json=>recursive_fill_params(
                                              EXPORTING
                                                ir_data        = <fs_line_fields_ref>
                                              IMPORTING
                                                er_data = lr_data
                        ).

                        ASSIGN lr_data->* TO <fs_value>.

                      ENDIF.

                      IF <fs_name> IS ASSIGNED AND <fs_value> IS ASSIGNED.
                        ASSIGN COMPONENT <fs_name> OF STRUCTURE <fs_data> TO <fs_field>.
                        IF sy-subrc = 0.
                          <fs_field> = <fs_value>.

                        ENDIF.

                      ENDIF.

                    ENDLOOP.

                  ENDLOOP.

                WHEN cl_abap_typedescr=>typekind_struct1
                  OR cl_abap_typedescr=>typekind_struct2. "structure
                  LOOP AT <fs_table> ASSIGNING <fs_line_ref>.
                    UNASSIGN: <fs_name>, <fs_value>.

                    ASSIGN <fs_line_ref>->* TO <fs_line>.

                    ASSIGN COMPONENT 'NAME' OF STRUCTURE <fs_line> TO <fs_name_ref>.
                    IF sy-subrc = 0.
                      ASSIGN <fs_name_ref>->* TO <fs_name>.

                    ENDIF.

                    ASSIGN COMPONENT 'VALUE' OF STRUCTURE <fs_line> TO <fs_value_ref>.
                    IF sy-subrc = 0. "because value might be nested
                      cl_ptf_json=>recursive_fill_params(
                                            EXPORTING
                                              ir_data         = <fs_line_ref>
                                            IMPORTING
                                              er_data         = lr_data
                      ).

                      ASSIGN lr_data->* TO <fs_value>.

                      lo_datadescr ?= cl_abap_datadescr=>describe_by_data( <fs_value> ).

                    ENDIF.

                    IF <fs_name> IS ASSIGNED AND <fs_value> IS ASSIGNED.
                      ls_componentdescr = VALUE #( name = <fs_name> type = lo_datadescr ).
                      APPEND ls_componentdescr TO lt_component_tab.

                    ENDIF.

                  ENDLOOP.

                  TRY.
                      lo_structdescr = cl_abap_structdescr=>get( lt_component_tab ).

                    CATCH cx_sy_struct_comp_name INTO lx_sy_struct_comp_name.
                      handle_exception( lx_sy_struct_comp_name ).

                  ENDTRY.

                  CREATE DATA er_data TYPE HANDLE lo_structdescr.

                  ASSIGN er_data->* TO <fs_data>.

                  LOOP AT <fs_table> ASSIGNING <fs_line_ref>.
                    UNASSIGN: <fs_name>, <fs_value>.

                    ASSIGN <fs_line_ref>->* TO <fs_line>.

                    ASSIGN COMPONENT 'NAME' OF STRUCTURE <fs_line> TO <fs_name_ref>.
                    IF sy-subrc = 0.
                      ASSIGN <fs_name_ref>->* TO <fs_name>.

                    ENDIF.

                    ASSIGN COMPONENT 'VALUE' OF STRUCTURE <fs_line> TO <fs_value_ref>.
                    IF sy-subrc = 0. "because value might be nested
                      cl_ptf_json=>recursive_fill_params(
                                            EXPORTING
                                              ir_data         = <fs_line_ref>
                                            IMPORTING
                                              er_data         = lr_data
                      ).

                      ASSIGN lr_data->* TO <fs_value>.

                    ENDIF.

                    IF <fs_name> IS ASSIGNED AND <fs_value> IS ASSIGNED.
                      ASSIGN COMPONENT <fs_name> OF STRUCTURE <fs_data> TO <fs_field>.
                      IF sy-subrc = 0.
                        <fs_field> = <fs_value>.

                      ENDIF.

                    ENDIF.

                  ENDLOOP.

              ENDCASE.

            ENDIF.

          WHEN OTHERS.
            CREATE DATA er_data TYPE HANDLE lo_datadescr.
            er_data->* = <fs_value>.

        ENDCASE.

      ELSE. "simple JSON
        lo_datadescr ?= cl_abap_datadescr=>describe_by_data( <fs_param> ).

        CASE lo_datadescr->type_kind.
          WHEN cl_abap_typedescr=>typekind_table.
            ASSIGN <fs_param> TO <fs_table>.
            READ TABLE <fs_table> ASSIGNING <fs_line_ref> INDEX 1.
            IF sy-subrc = 0.
              LOOP AT <fs_table> ASSIGNING <fs_line_ref>.
                cl_ptf_json=>recursive_fill_params(
                            EXPORTING
                              ir_data         = <fs_line_ref>
                            IMPORTING
                              er_data         = lr_data
                ).

                ASSIGN lr_data->* TO <fs_value>.

                TRY.
                    lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_value> ).

                  CATCH cx_sy_struct_comp_name INTO lx_sy_struct_comp_name.
                    handle_exception( lx_sy_struct_comp_name ).

                ENDTRY.

                lt_components = mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

                LOOP AT lt_components ASSIGNING <fs_componentdescr>.
                  IF NOT line_exists( lt_component_tab[ name = <fs_componentdescr>-name ] ).
                    ls_componentdescr = VALUE #( name = <fs_name> type = lo_datadescr ).
                    APPEND ls_componentdescr TO lt_component_tab.

                  ENDIF.

                ENDLOOP.

              ENDLOOP.

              lt_component_tab = mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

              lo_tabledescr = cl_abap_tabledescr=>get( EXPORTING p_line_type = lo_structdescr ).

              CREATE DATA er_data TYPE HANDLE lo_tabledescr.

              ASSIGN er_data->* TO <fs_data_table>.

              LOOP AT <fs_table> ASSIGNING <fs_line_ref>.
                APPEND INITIAL LINE TO <fs_data_table> ASSIGNING <fs_data>.

                LOOP AT lt_component_tab ASSIGNING <fs_componentdescr>.
                  cl_ptf_json=>recursive_fill_params(
                                        EXPORTING
                                          ir_data        = <fs_line_ref>
                                        IMPORTING
                                          er_data        = lr_data
                  ).

                  ASSIGN lr_data->* TO <fs_value>.

                  <fs_data> = <fs_value>.

                ENDLOOP.

              ENDLOOP.

            ENDIF.

          WHEN cl_abap_typedescr=>typekind_struct1
            OR cl_abap_typedescr=>typekind_struct2. "structure
            TRY.
                lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_param> ).

              CATCH cx_sy_struct_comp_name INTO lx_sy_struct_comp_name.
                handle_exception( lx_sy_struct_comp_name ).

            ENDTRY.

            lt_component_tab = mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

            LOOP AT lt_component_tab ASSIGNING <fs_componentdescr>.
              ASSIGN COMPONENT <fs_componentdescr>-name OF STRUCTURE <fs_param> TO <fs_field_ref>.
              IF sy-subrc = 0.
                cl_ptf_json=>recursive_fill_params(
                                      EXPORTING
                                        ir_data         = <fs_field_ref>
                                      IMPORTING
                                        er_data         = lr_data
                ).

                ASSIGN lr_data->* TO <fs_value>.

                lo_datadescr ?= cl_abap_datadescr=>describe_by_data( <fs_value> ).

                <fs_componentdescr>-type = lo_datadescr.

              ENDIF.

            ENDLOOP.

            TRY.
                lo_structdescr = cl_abap_structdescr=>get( lt_component_tab ).

              CATCH cx_sy_struct_comp_name INTO lx_sy_struct_comp_name.
                handle_exception( lx_sy_struct_comp_name ).

            ENDTRY.

            CREATE DATA er_data TYPE HANDLE lo_structdescr.

            ASSIGN er_data->* TO <fs_data>.

            LOOP AT lt_component_tab ASSIGNING <fs_componentdescr>.
              ASSIGN COMPONENT <fs_componentdescr>-name OF STRUCTURE <fs_param> TO <fs_field_ref>.
              IF sy-subrc = 0.
                cl_ptf_json=>recursive_fill_params(
                                      EXPORTING
                                        ir_data         = <fs_field_ref>
                                      IMPORTING
                                        er_data         = lr_data
                ).

                ASSIGN lr_data->* TO <fs_value>.

                ASSIGN COMPONENT <fs_componentdescr>-name OF STRUCTURE <fs_data> TO <fs_field>.
                IF sy-subrc = 0.
                  <fs_field> = <fs_value>.

                ENDIF.

              ENDIF.

            ENDLOOP.

          WHEN OTHERS.
            CREATE DATA er_data TYPE HANDLE lo_datadescr.
            er_data->* = <fs_param>.

        ENDCASE.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD recursive_gen_data_structure.
    DATA: lo_tabledescr           TYPE REF TO cl_abap_tabledescr,
          lo_structdescr          TYPE REF TO cl_abap_structdescr,
          lx_sy_struct_comp_name  TYPE REF TO cx_sy_struct_comp_name,
          lt_operator_comp_tab    TYPE abap_component_tab,
          lt_initial_comp_tab     TYPE abap_component_tab,
          lt_component_tab        TYPE abap_component_tab,
          ls_componentdescr       TYPE abap_componentdescr.

    FIELD-SYMBOLS: <fs_data_association> TYPE ts_associations,
                   <fs_data_field>       TYPE ts_fields,
                   <fs_data_operator>    TYPE ts_operators,
                   <fs_data_initial>     TYPE ts_initials,
                   <fs_componentdescr>   TYPE abap_componentdescr.

    DATA(lt_associations) = it_associations.
    DELETE lt_associations WHERE parent_id <> iv_parent_id.
    SORT lt_associations BY assocname childentityname.

    LOOP AT lt_associations ASSIGNING <fs_data_association>.
      AT NEW childentityname.
        CLEAR: lt_component_tab.

*       Check if we already have a component like this
        IF line_exists( ct_component_tab[ name = <fs_data_association>-childentityname ] ).
          lo_tabledescr ?= ct_component_tab[ name = <fs_data_association>-childentityname ]-type.
          lo_structdescr ?= lo_tabledescr->get_table_line_type( ).
          lt_component_tab = mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

        ENDIF.

      ENDAT.

*     Add the non technical fields (that don't start with _ ) of the entity as fields
      LOOP AT <fs_data_association>-fields ASSIGNING <fs_data_field> WHERE name NP '_*'.
        IF NOT line_exists( lt_component_tab[ name = <fs_data_field>-name ] ).
          CLEAR: ls_componentdescr.

          ls_componentdescr = VALUE #( name = <fs_data_field>-name type = cl_abap_elemdescr=>get_string( ) ).

          APPEND ls_componentdescr TO lt_component_tab.

        ENDIF.

      ENDLOOP.

*     Add the association name as component, it has to be the first field that starts with _
*     otherwise later on in the execution the name of the association could not be determined
*     This should also be considered in manual TDC creation if the user wants to use a TDC as source instead of JSON
      IF NOT line_exists( lt_component_tab[ name = <fs_data_association>-assocname ] ).
        CLEAR: ls_componentdescr.

        ls_componentdescr = VALUE #( name = <fs_data_association>-assocname type = cl_abap_elemdescr=>get_c( 1 ) ).

        APPEND ls_componentdescr TO lt_component_tab.

      ENDIF.

*     Add the technical fields (that start with _ ) of the entity as fields
      LOOP AT <fs_data_association>-fields ASSIGNING <fs_data_field> WHERE name CP '_*'.
        IF NOT line_exists( lt_component_tab[ name = <fs_data_field>-name ] ).
          CLEAR: ls_componentdescr.

          ls_componentdescr = VALUE #( name = <fs_data_field>-name type = cl_abap_elemdescr=>get_string( ) ).

          APPEND ls_componentdescr TO lt_component_tab.

        ENDIF.

      ENDLOOP.

*     Add other child entities as components
      cl_ptf_json=>recursive_gen_data_structure( EXPORTING it_associations  = it_associations
                                                           iv_parent_id     = <fs_data_association>-id
                                                 CHANGING  ct_component_tab = lt_component_tab ).

**     Add the fields of the entity as fields
*      LOOP AT <fs_data_association>-fields ASSIGNING <fs_data_field>.
*        IF NOT line_exists( lt_component_tab[ name = <fs_data_field>-name ] ).
*          CLEAR: ls_componentdescr.
*
*          ls_componentdescr = VALUE #( name = <fs_data_field>-name type = cl_abap_elemdescr=>get_string( ) ).
*
*          APPEND ls_componentdescr TO lt_component_tab.
*
*        ENDIF.
*
*      ENDLOOP.

*     Generate the operators of the child entities
      IF <fs_data_association>-operators IS NOT INITIAL.
        IF NOT line_exists( lt_component_tab[ name = '_OPERATORS' ] ).
          CLEAR: lt_operator_comp_tab.

          LOOP AT <fs_data_association>-operators ASSIGNING <fs_data_operator>.
            CLEAR ls_componentdescr.

            ls_componentdescr = VALUE #( name = <fs_data_operator>-name type = cl_abap_elemdescr=>get_string( ) ).

            APPEND ls_componentdescr TO lt_operator_comp_tab.

          ENDLOOP.

          CLEAR: ls_componentdescr.

          TRY.
              lo_structdescr = cl_abap_structdescr=>get( lt_operator_comp_tab ).

            CATCH cx_sy_struct_comp_name INTO lx_sy_struct_comp_name.
              handle_exception( lx_sy_struct_comp_name ).

          ENDTRY.

          ls_componentdescr = VALUE #( name = '_OPERATORS' type = lo_structdescr ).

          APPEND ls_componentdescr TO lt_component_tab.

        ELSE.
          lo_structdescr ?= lt_component_tab[ name = '_OPERATORS' ]-type.
          lt_operator_comp_tab = mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

          LOOP AT <fs_data_association>-operators ASSIGNING <fs_data_operator>.
            IF NOT line_exists( lt_operator_comp_tab[ name =  <fs_data_operator>-name ] ).
              CLEAR ls_componentdescr.

              ls_componentdescr = VALUE #( name = <fs_data_operator>-name type = cl_abap_elemdescr=>get_string( ) ).

              APPEND ls_componentdescr TO lt_operator_comp_tab.

            ENDIF.

          ENDLOOP.

          ASSIGN lt_component_tab[ name = '_OPERATORS' ] TO <fs_componentdescr>.

          TRY.
              lo_structdescr = cl_abap_structdescr=>get( lt_operator_comp_tab ).

            CATCH cx_sy_struct_comp_name INTO lx_sy_struct_comp_name.
              handle_exception( lx_sy_struct_comp_name ).

          ENDTRY.

          <fs_componentdescr>-type = lo_structdescr.

        ENDIF.

      ENDIF.

*     Generate the initials of the child entities
      IF <fs_data_association>-initials IS NOT INITIAL.
        IF NOT line_exists( lt_component_tab[ name = '_INITIALS' ] ).
          CLEAR: lt_initial_comp_tab.

          LOOP AT <fs_data_association>-initials ASSIGNING <fs_data_initial>.
            CLEAR ls_componentdescr.

            ls_componentdescr = VALUE #( name = <fs_data_initial>-name type = cl_abap_elemdescr=>get_string( ) ).

            APPEND ls_componentdescr TO lt_initial_comp_tab.

          ENDLOOP.

          CLEAR: ls_componentdescr.

          TRY.
              lo_structdescr = cl_abap_structdescr=>get( lt_initial_comp_tab ).

            CATCH cx_sy_struct_comp_name INTO lx_sy_struct_comp_name.
              handle_exception( lx_sy_struct_comp_name ).

          ENDTRY.

          ls_componentdescr = VALUE #( name = '_INITIALS' type = lo_structdescr ).

          APPEND ls_componentdescr TO lt_component_tab.

        ELSE.
          lo_structdescr ?= lt_component_tab[ name = '_INITIALS' ]-type.
          lt_initial_comp_tab = mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

          LOOP AT <fs_data_association>-initials ASSIGNING <fs_data_initial>.
            IF NOT line_exists( lt_initial_comp_tab[ name =  <fs_data_initial>-name ] ).
              CLEAR ls_componentdescr.

              ls_componentdescr = VALUE #( name = <fs_data_initial>-name type = cl_abap_elemdescr=>get_string( ) ).

              APPEND ls_componentdescr TO lt_initial_comp_tab.

            ENDIF.

          ENDLOOP.

          ASSIGN lt_component_tab[ name = '_INITIALS' ] TO <fs_componentdescr>.

          TRY.
              lo_structdescr = cl_abap_structdescr=>get( lt_initial_comp_tab ).

            CATCH cx_sy_struct_comp_name INTO lx_sy_struct_comp_name.
              handle_exception( lx_sy_struct_comp_name ).

          ENDTRY.

          <fs_componentdescr>-type = lo_structdescr.

        ENDIF.

      ENDIF.

      TRY.
          lo_structdescr = cl_abap_structdescr=>get( lt_component_tab ).

        CATCH cx_sy_struct_comp_name INTO lx_sy_struct_comp_name.
          handle_exception( lx_sy_struct_comp_name ).

      ENDTRY.

      AT END OF childentityname.
*       Generate the component name of the parent with the name of the child entity
        lo_tabledescr = cl_abap_tabledescr=>get( EXPORTING p_line_type = lo_structdescr ).

        IF NOT line_exists( ct_component_tab[ name = <fs_data_association>-childentityname ] ).
          CLEAR: ls_componentdescr.

          ls_componentdescr = VALUE #( name = <fs_data_association>-childentityname type = lo_tabledescr ).

          APPEND ls_componentdescr TO ct_component_tab.

        ELSE. "update the existing component with new components
          ASSIGN ct_component_tab[ name = <fs_data_association>-childentityname ] TO <fs_componentdescr>.

          <fs_componentdescr>-type = lo_tabledescr.

        ENDIF.

      ENDAT.

    ENDLOOP.

  ENDMETHOD.


  METHOD recursive_gen_params.
    DATA: lo_tabledescr           TYPE REF TO cl_abap_tabledescr,
          lo_structdescr          TYPE REF TO cl_abap_structdescr,
          lt_param_sub_components TYPE abap_component_tab,
          lv_source_entity        TYPE abp_entity_name,
          lv_length               TYPE i.

    FIELD-SYMBOLS: <fs_param_sub_component> TYPE abap_componentdescr.

    CASE is_componentdescr-type->type_kind.
      WHEN cl_abap_typedescr=>typekind_table
        OR cl_abap_typedescr=>typekind_struct1
        OR cl_abap_typedescr=>typekind_struct2. "structure. "itab
*     Determine source entity
      IF line_exists( it_associations[ source_entity = iv_source_entity name = CONV #( is_componentdescr-name ) ] ).
        lv_source_entity = it_associations[ source_entity = iv_source_entity name = CONV #( is_componentdescr-name ) ]-target_entity.

*      ELSE.
*        lv_source_entity = iv_source_entity.

      ENDIF.

    ENDCASE.

    CASE is_componentdescr-type->type_kind.
      WHEN cl_abap_typedescr=>typekind_table. "itab
        cv_json = |{ cv_json }\{"name":"{ is_componentdescr-name }","value":[[|.

        lo_tabledescr ?= is_componentdescr-type.
        lo_structdescr ?= lo_tabledescr->get_table_line_type( ).
        lt_param_sub_components = mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

*       Remove %Control
        DELETE lt_param_sub_components WHERE name = cl_abap_behv=>co_techfield_name-control.

        LOOP AT lt_param_sub_components ASSIGNING <fs_param_sub_component>.
          cl_ptf_json=>recursive_gen_params(
            EXPORTING
              is_componentdescr = <fs_param_sub_component>
              it_associations   = it_associations
              it_features       = it_features
              iv_source_entity  = lv_source_entity
            CHANGING
              cv_json           = cv_json ).

          AT LAST.
            lv_length = strlen( cv_json ) - 1.
            cv_json = cv_json+0(lv_length).

          ENDAT.

        ENDLOOP.

        cv_json = |{ cv_json }]]\},|.

      WHEN cl_abap_typedescr=>typekind_struct1
        OR cl_abap_typedescr=>typekind_struct2. "structure
        cv_json = |{ cv_json }\{"name":"{ is_componentdescr-name }","value":[|.

        lo_structdescr ?= is_componentdescr-type.
        lt_param_sub_components = mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

*       Remove %Control
        DELETE lt_param_sub_components WHERE name = cl_abap_behv=>co_techfield_name-control.

        LOOP AT lt_param_sub_components ASSIGNING <fs_param_sub_component>.
          cl_ptf_json=>recursive_gen_params(
            EXPORTING
              is_componentdescr = <fs_param_sub_component>
              it_associations   = it_associations
              it_features       = it_features
              iv_source_entity  = lv_source_entity
            CHANGING
              cv_json           = cv_json ).

          AT LAST.
            lv_length = strlen( cv_json ) - 1.
            cv_json = cv_json+0(lv_length).

          ENDAT.

        ENDLOOP.

        cv_json = |{ cv_json }]\},|.

      WHEN OTHERS. "element
        IF line_exists( it_features[ owner_entity = iv_source_entity element_kind = cl_abap_behv_load=>c_feature_elem_field ] ).
*         There is at least one feature for this parameter behavior
          IF line_exists( it_features[ owner_entity = iv_source_entity
                                       element_kind = cl_abap_behv_load=>c_feature_elem_field
                                       element      = CONV #( is_componentdescr-name ) ] ).
            DATA(ls_feature) = it_features[ owner_entity = iv_source_entity
                                            element_kind = cl_abap_behv_load=>c_feature_elem_field
                                            element = CONV #( is_componentdescr-name ) ].

            CASE ls_feature-static_features.
              WHEN cl_abap_behv_load=>c_feature_sf_mandatory_execute.
                cv_json = |{ cv_json }\{"name":"{ is_componentdescr-name }","value":"mandatory"\},|.

              WHEN OTHERS.
                cv_json = |{ cv_json }\{"name":"{ is_componentdescr-name }","value":"optional"\},|.

            ENDCASE.

          ELSE.
            "This field is not defined in the parameter behvior, mark it as "optional"
            cv_json = |{ cv_json }\{"name":"{ is_componentdescr-name }","value":"optional"\},|.

          ENDIF.

        ELSE.
*         There is no feature for any parameter behavior defined field, as we do cannot determine the value, we set ""
          cv_json = |{ cv_json }\{"name":"{ is_componentdescr-name }","value":""\},|.

        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD recursive_load_params_features.

    IF NOT iv_parameter_type IS INITIAL.

      cl_abap_behv_load=>get_load(
        EXPORTING
          entity         = iv_parameter_type
          all            = abap_off
        IMPORTING
          associations   = DATA(lt_associations)
          features       = DATA(lt_features)
        RECEIVING
          result         = DATA(lv_result)
      ).

      IF lv_result = cl_abap_behv_load=>ok.

        INSERT LINES OF lt_associations INTO TABLE ct_associations.
        INSERT LINES OF lt_features INTO TABLE ct_features.

        IF iv_stop_recursion = abap_off.

          LOOP AT lt_associations ASSIGNING FIELD-SYMBOL(<fs_association>).
*           Stop the recursion if we traverse back to parent
            DATA(lv_stop_recursion) = SWITCH #( <fs_association>-name WHEN '_PARENT' THEN abap_on ).

            cl_ptf_json=>recursive_load_params_features(
              EXPORTING
                iv_parameter_type = <fs_association>-target_entity
                iv_stop_recursion = lv_stop_recursion
              CHANGING
                ct_associations   = ct_associations
                ct_features       = ct_features
            ).

          ENDLOOP.

        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD validate_json.
*   Check if JSON is syntactically correct
    DATA(lo_reader) = cl_sxml_string_reader=>create( cl_abap_conv_codepage=>create_out( )->convert( iv_json ) ).
    TRY.
        lo_reader->next_node( ).
        lo_reader->skip_node( ).
      CATCH cx_sxml_parse_error INTO DATA(lx_sxml_parse_error).
        handle_exception( lx_sxml_parse_error ).

    ENDTRY.

  ENDMETHOD.


  METHOD get_permissions.
    DATA lt_entity_names  TYPE abp_entity_name_tab.
    DATA lt_permissions   TYPE abp_behv_permissions_tab.
    DATA ls_permission    TYPE abp_behv_permissions.
    DATA lv_name          TYPE cl_abap_behvdescr=>t_typename.
    DATA lv_root          TYPE cl_abap_behvdescr=>t_typename.

    FIELD-SYMBOLS <ls_request_perm> TYPE any.
    FIELD-SYMBOLS <ls_structure>    TYPE any.
    FIELD-SYMBOLS <lv_field>        TYPE any.

    CLEAR et_permissions.

    INSERT iv_entity INTO TABLE lt_entity_names.

**     If we have an action and no child has the action then remove the association
*      IF lv_is_action = abap_on.
*
*      ENDIF.

    LOOP AT it_associations ASSIGNING FIELD-SYMBOL(<ls_association>).
      INSERT <ls_association>-source_entity INTO TABLE lt_entity_names.
      INSERT <ls_association>-target_entity INTO TABLE lt_entity_names.
    ENDLOOP.

    DELETE ADJACENT DUPLICATES FROM lt_entity_names.

*      LOOP AT lt_associations ASSIGNING FIELD-SYMBOL(<fs_association>).
    LOOP AT lt_entity_names ASSIGNING FIELD-SYMBOL(<lv_entity_name>).
      CLEAR lt_permissions.
      CLEAR: lv_name, lv_root.

*       Check if entity is local or foreign
      READ TABLE it_entities WITH KEY name = <lv_entity_name> TRANSPORTING NO FIELDS.
      IF sy-subrc = 0. "Local
        lv_name = <lv_entity_name>.
        lv_root = iv_entity.

      ELSE. "Foreign entity
        lv_name = <lv_entity_name>.

*       lv_root = <fs_entity_name>. "This can cause a dump if there is a foreign relationship with a child node
        cl_abap_behv_load=>get_load(
          EXPORTING
            entity      = lv_name
          CHANGING
            root_entity = lv_root
        ).

      ENDIF.

      ls_permission-entity_name = lv_name. "<fs_entity_name>. "<fs_association>-target_entity. "
*        ls_permission-instances = cl_abap_behvdescr=>create_data(
*                                        p_name = lv_name
*                                        p_op = cl_abap_behvdescr=>op_permission
*                                        "p_kind = if_abap_behv=>typekind-request
*                                        "p_structure = abap_on
*                                     ).

      ls_permission-request = cl_abap_behvdescr=>create_data(
                                      p_name = lv_name "<fs_association>-target_entity "
                                      "p_root = lv_root "<fs_association>-source_entity "space
                                      p_op = cl_abap_behvdescr=>op_permission
                                      p_kind = if_abap_behv=>typekind-request
                                      "p_structure = abap_on
                                   ).

      ls_permission-results = cl_abap_behvdescr=>create_data(
                                      p_name = lv_name "<fs_entity_name>
                                      "p_root = lv_root "<fs_association>-source_entity "space
                                      p_op = cl_abap_behvdescr=>op_permission
                                      p_kind = if_abap_behv=>typekind-result
                                   ).

      ASSIGN ls_permission-request->* TO <ls_request_perm>.

      ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-field OF STRUCTURE <ls_request_perm> TO <ls_structure>.
      IF sy-subrc = 0.
        DO.
          ASSIGN COMPONENT sy-index OF STRUCTURE <ls_structure> TO <lv_field>.
          IF sy-subrc = 0.
            <lv_field> = cl_abap_behv=>flag_changed.

          ELSE.
            EXIT.

          ENDIF.

        ENDDO.

      ENDIF.

      APPEND ls_permission TO lt_permissions.

      GET PERMISSIONS "ONLY INSTANCE FEATURES
        OPERATIONS lt_permissions
        FAILED DATA(lt_failed_perm)
        REPORTED DATA(lt_reported_perm) ##EML_IN_LOOP_OK.

      APPEND LINES OF lt_permissions TO et_permissions.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
