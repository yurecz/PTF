class CL_PTF_RAP_VALIDATE_TDO definition
  public
  create public .

public section.

  interfaces IF_PTF_RAP_VALIDATE_TDO .

  aliases CHECK_ACTION
    for IF_PTF_RAP_VALIDATE_TDO~CHECK_ACTION .
  aliases CHECK_ASSOCIATION
    for IF_PTF_RAP_VALIDATE_TDO~CHECK_ASSOCIATION .
  aliases CHECK_DATA
    for IF_PTF_RAP_VALIDATE_TDO~CHECK_DATA .
  aliases CHECK_ENTITY
    for IF_PTF_RAP_VALIDATE_TDO~CHECK_ENTITY .
  aliases CHECK_KEY_EMPTY
    for IF_PTF_RAP_VALIDATE_TDO~CHECK_KEY_EMPTY .
  aliases CHECK_KEY_FULLY_FILLED
    for IF_PTF_RAP_VALIDATE_TDO~CHECK_KEY_FULLY_FILLED .
  aliases CHECK_OPERATION
    for IF_PTF_RAP_VALIDATE_TDO~CHECK_OPERATION .
  aliases MOVE_TEST_DATA
    for IF_PTF_RAP_VALIDATE_TDO~MOVE_TEST_DATA .

  methods CONSTRUCTOR
    importing
      !IO_RUN_ENVIRONMENT type ref to CL_PTF_RUN .
protected section.
private section.

  types:
    tt_messages TYPE STANDARD TABLE OF string .

  data MO_RUN_ENVIRONMENT type ref to CL_PTF_RUN .
  data MO_PTF_RAP_METADATA type ref to IF_PTF_RAP_METADATA .
  data MV_SOURCE type STRING .

  methods CHECK_IS_EXISTING
    importing
      !IS_TEST_DATA type ANY
      !IV_CHECK_ONLY_KEYS type ABAP_BOOL
    returning
      value(RV_IS_EXISTING) type ABAP_BOOL .
  methods CHECK_DATA_INSTANCE
    importing
      !IS_TEST_DATA type DATA
      !IS_PARENT_INSTANCE type DATA optional
      !IT_OPERATIONS_READ type ABP_BEHV_RETRIEVALS_TAB
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IV_SUB_NAME type CL_ABAP_BEHVDESCR=>T_SUB_NAME optional
      !IV_ENTITY_NAME type ABP_ENTITY_NAME
      !IV_CHECK_ONLY_KEYS type ABAP_BOOL default ABAP_OFF
    exporting
      !EV_ERROR type ABAP_BOOL .
  methods CHECK_OPERATOR
    importing
      !IV_OPERATOR type CHAR02
    returning
      value(RV_RESULT) type ABAP_BOOL .
  methods DYNAMIC_CHECK
    importing
      !IV_EXPECTED type DATA
      !IV_ACTUAL type DATA
      !IV_OPERATOR type CHAR02
    returning
      value(EV_RESULT) type ABAP_BOOL .
  methods RECURSIVE_CHECK_PARAMS
    importing
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IV_P_SUB_NAME type CL_ABAP_BEHVDESCR=>T_SUB_NAME
      !IV_COMPONENT_NAME type FIELDNAME optional
      !IS_DATA type ANY
      !IS_PARAMS type ANY
    exporting
      !EV_ERROR type ABAP_BOOL .
  methods LOG_MESSAGES
    importing
      !IT_MESSAGES type TT_MESSAGES .
  methods LOG_CHECK_DATA_MESSAGES
    importing
      !IT_KEY_COMPONENTS type ABAP_COMPONENT_TAB
      !IS_RESULT_C type ANY
      !IV_IS_EXISTING type ABAP_BOOL
      !IV_LINE_FOUND type ABAP_BOOL
      !IV_ENTITY_NAME type ABP_ENTITY_NAME
    exporting
      !EV_ERROR type ABAP_BOOL .
  methods CHECK_DATA_ENTITY
    importing
      !IT_COMPONENTS type ABAP_COMPONENT_TAB
      !IT_KEY_COMPONENTS type ABAP_COMPONENT_TAB
      !IT_OPERATIONS_READ type ABP_BEHV_RETRIEVALS_TAB
      !IS_OPERATION_READ type ABP_BEHV_RETRIEVALS
      !IS_TEST_DATA type ANY
      !IS_RESULT_C type ANY
      !IV_ENTITY_NAME type ABP_ENTITY_NAME
      !IV_CHECK_ONLY_KEYS type ABAP_BOOL
    exporting
      !EV_LINE_FOUND type ABAP_BOOL
      !EV_ERROR type ABAP_BOOL .
  methods CHECK_DATA_CHILD_ENTITIES
    importing
      !IT_COMPONENTS type ABAP_COMPONENT_TAB
      !IT_OPERATIONS_READ type ABP_BEHV_RETRIEVALS_TAB
      !IS_TEST_DATA type ANY
      !IS_RESULT_C type ANY
      !IV_ENTITY_NAME type ABP_ENTITY_NAME
      !IV_CHECK_ONLY_KEYS type ABAP_BOOL
    exporting
      !EV_ERROR type ABAP_BOOL .
  methods GET_SOURCE
    importing
      !IS_TEST_DATA type ANY
    returning
      value(RV_SOURCE) type STRING .
  methods CLEANUP_COMPONENTS
    importing
      !IS_TEST_DATA type ANY
      !IS_RESULT_C type ANY
    changing
      !CT_COMPONENTS type ABAP_COMPONENT_TAB .
  methods CHECK_IGNORE
    importing
      !IS_TEST_DATA type ANY
    returning
      value(RV_IGNORE) type ABAP_BOOL .
ENDCLASS.



CLASS CL_PTF_RAP_VALIDATE_TDO IMPLEMENTATION.


  METHOD check_data_child_entities.
    DATA: lo_tabledescr    TYPE REF TO cl_abap_tabledescr,
          lo_structdescr   TYPE REF TO cl_abap_structdescr,
          lt_test_c_comp   TYPE abap_component_tab,
          lv_entity_name   TYPE abp_entity_name,
          lv_sub_name      TYPE cl_abap_behvdescr=>t_sub_name,
          lv_error         TYPE abap_bool.

    FIELD-SYMBOLS: <fs_component>     TYPE abap_componentdescr,
                   <fs_test_c_tcomp>  TYPE abap_keydescr,
                   <fs_test_c_comp>   TYPE abap_componentdescr,
                   <fs_test_data_t>   TYPE any,
                   <fs_test_data>     TYPE any.

    CLEAR: ev_error.

    LOOP AT it_components ASSIGNING <fs_component>.
      IF <fs_component>-name CP '_*'. "delete components starting with _ because they cannot represent a child entity
        CONTINUE.

      ENDIF.

      lv_entity_name = <fs_component>-name. "entity name

*     Check the type of field
      CASE <fs_component>-type->type_kind.
        WHEN cl_abap_typedescr=>typekind_table. "itab
          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_test_data TO <fs_test_data_t>.

          lo_tabledescr ?= cl_abap_tabledescr=>describe_by_data( <fs_test_data_t> ).
          LOOP AT lo_tabledescr->key ASSIGNING <fs_test_c_tcomp> WHERE name CP '_*'. "Association starts with _
            lv_sub_name = <fs_test_c_tcomp>-name.
            EXIT.

          ENDLOOP.

          LOOP AT <fs_test_data_t> ASSIGNING <fs_test_data>.
            me->check_data_instance(
              EXPORTING
                is_test_data       = <fs_test_data>
                is_parent_instance = is_result_c
                it_operations_read = it_operations_read
                iv_name            = iv_entity_name
                iv_sub_name        = lv_sub_name
                iv_entity_name     = lv_entity_name
                iv_check_only_keys = iv_check_only_keys
              IMPORTING
                ev_error           = lv_error ).
            IF lv_error = abap_on.
              ev_error = abap_on.

            ENDIF.

          ENDLOOP.

        WHEN cl_abap_typedescr=>typekind_struct1
          OR cl_abap_typedescr=>typekind_struct2. "structure
          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_test_data TO <fs_test_data>.

          lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_test_data> ).
          lt_test_c_comp = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

          LOOP AT lt_test_c_comp ASSIGNING <fs_test_c_comp> WHERE name CP '_*'. "Association starts with _
            lv_sub_name = <fs_test_c_comp>-name.
            EXIT.

          ENDLOOP.

          me->check_data_instance(
            EXPORTING
              is_test_data       = <fs_test_data>
              is_parent_instance = is_result_c
              it_operations_read = it_operations_read
              iv_name            = iv_entity_name
              iv_sub_name        = lv_sub_name
              iv_entity_name     = lv_entity_name
              iv_check_only_keys = iv_check_only_keys
            IMPORTING
              ev_error           = lv_error ).
          IF lv_error = abap_on.
            ev_error = abap_on.

          ENDIF.

      ENDCASE.

    ENDLOOP.

  ENDMETHOD.


  METHOD check_data_entity.
    DATA: lo_tabledescr  TYPE REF TO cl_abap_tabledescr,
          lo_structdescr TYPE REF TO cl_abap_structdescr,
          lt_test_c_comp TYPE abap_component_tab,
          lv_entity_name TYPE abp_entity_name,
          lv_sub_name    TYPE cl_abap_behvdescr=>t_sub_name,
          lv_operator    TYPE char02,
          lv_error       TYPE abap_bool.

    FIELD-SYMBOLS: <fs_component>    TYPE abap_componentdescr,
                   <fs_test_data_t>  TYPE any,
                   <fs_test_c_tcomp> TYPE abap_keydescr,
                   <fs_test_c_comp>  TYPE abap_componentdescr,
                   <fs_field_c>      TYPE any,
                   <fs_field_e>      TYPE any,
                   <fs_test_data>    TYPE any,
                   <fs_result_e>     TYPE any,
                   <fs_operators>    TYPE any,
                   <fs_operator>     TYPE any.

    CLEAR: ev_error, ev_line_found.

*   Check if we have operators
    ASSIGN COMPONENT '_OPERATORS' OF STRUCTURE is_test_data TO <fs_operators>.

    LOOP AT is_operation_read-results->* ASSIGNING <fs_result_e>.
      ev_line_found = abap_on.
      LOOP AT it_key_components ASSIGNING <fs_component>.
        ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_result_c TO <fs_field_c>.
        ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_result_e> TO <fs_field_e>.
        IF <fs_field_c> IS ASSIGNED AND <fs_field_e> IS ASSIGNED.
          IF <fs_field_c> <> <fs_field_e>.
            ev_line_found = abap_off. "not the good entry
            EXIT.

          ENDIF.

        ELSE.
          ev_line_found = abap_off. "shouldn't happen
          EXIT.

        ENDIF.

      ENDLOOP.

      IF ev_line_found = abap_on. "this is the existing data to be checked against
        LOOP AT it_components ASSIGNING <fs_component>.
          IF <fs_component>-name CP '_*'.
            CONTINUE.

          ENDIF.

          UNASSIGN: <fs_field_c>, <fs_field_e>.
          lv_entity_name = <fs_component>-name. "entity name

*         Check the type of field
          CASE <fs_component>-type->type_kind.
            WHEN cl_abap_typedescr=>typekind_table. "itab
              ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_test_data TO <fs_test_data_t>.

              lo_tabledescr ?= cl_abap_tabledescr=>describe_by_data( <fs_test_data_t> ).
              LOOP AT lo_tabledescr->key ASSIGNING <fs_test_c_tcomp> WHERE name CP '_*'. "Association starts with _
                lv_sub_name = <fs_test_c_tcomp>-name.
                EXIT.

              ENDLOOP.

              LOOP AT <fs_test_data_t> ASSIGNING <fs_test_data>.
                me->check_data_instance(
                  EXPORTING
                    is_test_data       = <fs_test_data>
                    is_parent_instance = is_result_c
                    it_operations_read = it_operations_read
                    iv_name            = iv_entity_name
                    iv_sub_name        = lv_sub_name
                    iv_entity_name     = lv_entity_name
                    iv_check_only_keys = iv_check_only_keys
                  IMPORTING
                    ev_error           = lv_error ).
                IF lv_error = abap_on.
                  ev_error = abap_on.

                ENDIF.

              ENDLOOP.

            WHEN cl_abap_typedescr=>typekind_struct1
              OR cl_abap_typedescr=>typekind_struct2. "structure
              ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_test_data TO <fs_test_data>.

              lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_test_data> ).
              lt_test_c_comp = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

              LOOP AT lt_test_c_comp ASSIGNING <fs_test_c_comp> WHERE name CP '_*'. "Association starts with _
                lv_sub_name = <fs_test_c_comp>-name.
                EXIT.

              ENDLOOP.

              me->check_data_instance(
                EXPORTING
                  is_test_data       = <fs_test_data>
                  is_parent_instance = is_result_c
                  it_operations_read = it_operations_read
                  iv_name            = iv_entity_name
                  iv_sub_name        = lv_sub_name
                  iv_entity_name     = lv_entity_name
                  iv_check_only_keys = iv_check_only_keys
                IMPORTING
                  ev_error           = lv_error ).
              IF lv_error = abap_on.
                ev_error = abap_on.

              ENDIF.

            WHEN OTHERS. "element
*             Check if it's key
              IF iv_check_only_keys = abap_on.
                IF NOT line_exists( it_key_components[ name = <fs_component>-name ] ).
                  me->mo_run_environment->append_log( |Entity { iv_entity_name }: Warning checking data| ).
                  me->mo_run_environment->append_log( |Field { <fs_component>-name } is not a key field !| ).
*                 ev_error = abap_on.
                  CONTINUE.

                ENDIF.

              ENDIF.

              IF NOT line_exists( it_key_components[ name = <fs_component>-name ] ). "check only non-key fields
                ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_result_c TO <fs_field_c>.
                ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_result_e> TO <fs_field_e>.
                IF <fs_field_c> IS ASSIGNED AND <fs_field_e> IS ASSIGNED.
*                 Check if we have operator
                  lv_operator = '='.

                  IF <fs_operators> IS ASSIGNED.
                    ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_operators> TO <fs_operator>.
                    IF sy-subrc = 0.
                      lv_operator = <fs_operator>.

                    ENDIF.

                  ENDIF.

                  IF me->check_operator( lv_operator ) = abap_on.
                    IF me->dynamic_check( iv_expected = <fs_field_c> iv_actual = <fs_field_e> iv_operator = lv_operator ) = abap_off. "Values do not match, issue message
                      me->mo_run_environment->append_log( |Entity { iv_entity_name }: Deviating value| ).
                      me->mo_run_environment->append_log( |Field { <fs_component>-name }| ).
                      me->mo_run_environment->append_log( |Expected: '{ <fs_field_c> }'| ).
                      me->mo_run_environment->append_log( |Actual: '{ <fs_field_e> }'| ).
                      IF lv_operator <> '='.
                        me->mo_run_environment->append_log( |Operator: '{ lv_operator }'| ).

                      ENDIF.

                      ev_error = abap_on.

                    ENDIF.

                  ELSE.
                    me->mo_run_environment->append_log( |Entity { iv_entity_name }: Operator '{ lv_operator }' is invalid| ).

                    ev_error = abap_on.

                  ENDIF.

                ENDIF.

              ENDIF.

          ENDCASE.

        ENDLOOP.

        EXIT. "Line was found, exit processing

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD check_data_instance.
    DATA: lo_structdescr TYPE REF TO cl_abap_structdescr,
          lt_components  TYPE abap_component_tab,
          lv_line_found  TYPE abap_bool,
          lv_root        TYPE abap_bool.

    FIELD-SYMBOLS: <fs_result_c>      TYPE any. "data to be checked

    CLEAR ev_error.

*   Get source of test data (TDC/JSON)
    me->mv_source = me->get_source(
      EXPORTING
        is_test_data = is_test_data
    ).

*   Check if we have isExisting flag
    DATA(lv_is_existing) = me->check_is_existing(
      EXPORTING
        is_test_data        = is_test_data
        iv_check_only_keys  = iv_check_only_keys
    ).

*   Check if we have ignore flag
    DATA(lv_ignore) = me->check_ignore(
      EXPORTING
        is_test_data  = is_test_data
    ).

    lo_structdescr ?= cl_abap_structdescr=>describe_by_data( is_test_data ).
    lt_components = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

*   Generate keys based on existence of %PID
    DATA(lv_virtual) = COND abap_bool( WHEN line_exists( lt_components[ name = cl_abap_behv=>co_techfield_name-pid ] ) THEN abap_on ELSE abap_off ).

*   Get the key components of the entity
    DATA(lt_key_components) = me->mo_ptf_rap_metadata->get_key_fields( EXPORTING iv_name = iv_entity_name iv_virtual = lv_virtual ).

    IF iv_sub_name IS INITIAL.
      DATA(ls_result) = cl_abap_behvdescr=>create_data(
                          p_name      = iv_name "is_step_data-bus_obj
                          p_op        = if_abap_behv=>op-r-read
                          p_kind      = if_abap_behv=>typekind-result
                          p_structure = abap_on ).

      ASSIGN ls_result->* TO <fs_result_c>.

    ELSE.
      DATA(ls_result_sub) = cl_abap_behvdescr=>create_data(
                              p_name      = iv_name "is_step_data-bus_obj
                              p_op        = if_abap_behv=>op-r-read_ba
                              p_sub_name  = iv_sub_name
                              p_kind      = if_abap_behv=>typekind-result
                              p_structure = abap_on ).

      ASSIGN ls_result_sub->* TO <fs_result_c>.

    ENDIF.

*   Move components 1 by 1 and apply conversion routine where applicable
    lv_root = COND #( WHEN iv_name = iv_entity_name THEN abap_on ELSE abap_off ).

    me->move_test_data(
      EXPORTING
        is_test_data   = is_test_data
        iv_name        = iv_entity_name
        iv_root        = lv_root
        iv_context     = if_ptf_rap_validate_tdo=>checks
      IMPORTING
        ev_error       = ev_error
      CHANGING
        cs_target_data = <fs_result_c> ).
    IF ev_error = abap_on.
      RETURN.

    ENDIF.

    IF is_parent_instance IS SUPPLIED.
      me->move_test_data(
        EXPORTING
          is_test_data   = is_parent_instance
          iv_name        = iv_entity_name
          iv_root        = lv_root
          iv_context     = if_ptf_rap_validate_tdo=>checks
          iv_parent      = abap_on
        IMPORTING
          ev_error       = ev_error
        CHANGING
          cs_target_data = <fs_result_c> ).
      IF ev_error = abap_on.
        RETURN.

      ENDIF.

    ENDIF.

*   Remove components that are initial and coming from TDC and are not present in _INITIALS
    me->cleanup_components(
      EXPORTING
        is_test_data  = is_test_data
        is_result_c   = <fs_result_c>
      CHANGING
        ct_components = lt_components
    ).

    READ TABLE it_operations_read ASSIGNING FIELD-SYMBOL(<fs_operation_read>) WITH KEY entity_name = iv_name sub_name = iv_sub_name.
    IF sy-subrc = 0.
      IF lv_ignore = abap_on. "We have ignore so don't call log_check_data_messages and return
        me->check_data_child_entities(
          EXPORTING
            it_operations_read = it_operations_read
            it_components      = lt_components
            is_test_data       = is_test_data
            is_result_c        = <fs_result_c>
            iv_entity_name     = iv_entity_name
            iv_check_only_keys = iv_check_only_keys
          IMPORTING
            ev_error           = ev_error
        ).

        RETURN.

      ELSE. "We do not have ignore so we have to check the entity
        me->check_data_entity(
          EXPORTING
            it_operations_read = it_operations_read
            it_components      = lt_components
            it_key_components  = lt_key_components
            is_operation_read  = <fs_operation_read>
            is_test_data       = is_test_data
            is_result_c        = <fs_result_c>
            iv_entity_name     = iv_entity_name
            iv_check_only_keys = iv_check_only_keys
          IMPORTING
            ev_line_found      = lv_line_found
            ev_error           = ev_error
        ).

      ENDIF.

    ELSE. "Look for child entities
      me->check_data_child_entities(
        EXPORTING
          it_operations_read = it_operations_read
          it_components      = lt_components
          is_test_data       = is_test_data
          is_result_c        = <fs_result_c>
          iv_entity_name     = iv_entity_name
          iv_check_only_keys = iv_check_only_keys
        IMPORTING
          ev_error           = ev_error
      ).

*     Return and don't call log_check_data_messages because
*     a log could be issued
      IF lv_ignore = abap_on.
        RETURN.

      ENDIF.

    ENDIF.

    me->log_check_data_messages(
      EXPORTING
        it_key_components = lt_key_components
        is_result_c       = <fs_result_c>
        iv_is_existing    = lv_is_existing
        iv_line_found     = lv_line_found
        iv_entity_name    = iv_entity_name
      IMPORTING
        ev_error          = DATA(lv_error)
    ).
    IF lv_error = abap_on.
      ev_error = lv_error.

    ENDIF.

  ENDMETHOD.


  METHOD check_ignore.
    ASSIGN COMPONENT '_IGNORE' OF STRUCTURE is_test_data TO FIELD-SYMBOL(<fs_field>).
    IF sy-subrc = 0.
      IF <fs_field> = abap_on.
        rv_ignore = abap_on.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD check_is_existing.
*   Check if we have isExisting flag
    rv_is_existing = abap_on. "By default for CHECK and CHECK_IF_EXISTS we have the value true

    IF iv_check_only_keys = abap_on. "For CHECK_IF_EXISTS the user can control the property in order to make a negative check
      ASSIGN COMPONENT '_IS_EXISTING' OF STRUCTURE is_test_data TO FIELD-SYMBOL(<fs_is_existing>).
      IF sy-subrc = 0.
        rv_is_existing = SWITCH abap_bool( <fs_is_existing> WHEN abap_on THEN abap_on
                                                            WHEN abap_off THEN abap_off
                                                            ELSE abap_on ).

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD check_operator.
    CASE iv_operator.
      WHEN '='
      OR '<>'
      OR '>'
      OR '<'
      OR '>='
      OR '<='.
        rv_result = abap_on.

      WHEN OTHERS.
        rv_result = abap_off.

    ENDCASE.

  ENDMETHOD.


  METHOD cleanup_components.
    DATA: lv_initial TYPE abap_bool.

    IF me->mv_source = 'TDC'.
      LOOP AT ct_components ASSIGNING FIELD-SYMBOL(<fs_component>).
        DATA(lv_tabix) = sy-tabix.

        ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_result_c TO FIELD-SYMBOL(<fs_value>).
        IF sy-subrc = 0.
          CLEAR lv_initial.

          ASSIGN COMPONENT '_INITIALS' OF STRUCTURE is_test_data TO FIELD-SYMBOL(<fs_initials>).
          IF sy-subrc = 0.
            ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_initials> TO FIELD-SYMBOL(<fs_initial>).
            IF sy-subrc = 0.
              IF <fs_initial> = abap_on.
                lv_initial = abap_on.

              ENDIF.

            ENDIF.

            IF lv_initial = abap_off AND <fs_value> IS INITIAL. "no initial flag and the value is initial so remove it
              DELETE ct_components INDEX lv_tabix.
              CONTINUE.

            ENDIF.

          ELSE. "no _INITIALS component
            IF <fs_value> IS INITIAL. "remove component if it's value is initial
              DELETE ct_components INDEX lv_tabix.
              CONTINUE.

            ENDIF.

          ENDIF.

        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD CONSTRUCTOR.
    me->mo_run_environment  = io_run_environment.
    me->mo_ptf_rap_metadata = NEW cl_ptf_rap_metadata( ).

  ENDMETHOD.


  METHOD dynamic_check.
    DATA: lo_tabledescr  TYPE REF TO cl_abap_tabledescr,
          lo_structdescr TYPE REF TO cl_abap_structdescr,
          lr_data        TYPE REF TO data,
          lt_components  TYPE abap_component_tab,
          ls_component   TYPE abap_componentdescr,
          lv_operator    TYPE char02.

    FIELD-SYMBOLS: <fs_actual_t> TYPE STANDARD TABLE,
                   <fs_actual_l> TYPE any,
                   <fs_value>    TYPE any.

*   Convert the operator
    lv_operator = iv_operator.
    CASE lv_operator.
      WHEN '='.
        lv_operator = 'EQ'.

      WHEN '<>'.
        lv_operator = 'NE'.

      WHEN '>'.
        lv_operator = 'GT'.

      WHEN '<'.
        lv_operator = 'LT'.

      WHEN '>='.
        lv_operator = 'GE'.

      WHEN '<='.
        lv_operator = 'LE'.

      WHEN OTHERS.
        RETURN.

    ENDCASE.

    ls_component-name = 'SIGN'.
    ls_component-type = cl_abap_elemdescr=>get_c( p_length = 1 ).

    APPEND ls_component TO lt_components.

    ls_component-name = 'OPTION'.
    ls_component-type = cl_abap_elemdescr=>get_c( p_length = 2 ).

    APPEND ls_component TO lt_components.

    ls_component-name = 'LOW'.
    ls_component-type ?= cl_abap_elemdescr=>describe_by_data( iv_actual ).

    APPEND ls_component TO lt_components.

    ls_component-name = 'HIGH'.
    ls_component-type ?= cl_abap_elemdescr=>describe_by_data( iv_actual ).

    APPEND ls_component TO lt_components.

    lo_structdescr = cl_abap_structdescr=>get( lt_components ).
    lo_tabledescr = cl_abap_tabledescr=>get( EXPORTING p_line_type = lo_structdescr ).

    CREATE DATA lr_data TYPE HANDLE lo_tabledescr.

    ASSIGN lr_data->* TO <fs_actual_t>.

    APPEND INITIAL LINE TO <fs_actual_t> ASSIGNING <fs_actual_l>.

    ASSIGN COMPONENT 'SIGN' OF STRUCTURE <fs_actual_l> TO <fs_value>.
    IF sy-subrc = 0.
      <fs_value> = 'I'.

    ENDIF.

    ASSIGN COMPONENT 'OPTION' OF STRUCTURE <fs_actual_l> TO <fs_value>.
    IF sy-subrc = 0.
      <fs_value> = lv_operator.

    ENDIF.

    ASSIGN COMPONENT 'LOW' OF STRUCTURE <fs_actual_l> TO <fs_value>.
    IF sy-subrc = 0.
      <fs_value> = iv_actual.

    ENDIF.

*   Do the actual comparison
    IF iv_expected IN <fs_actual_t>.
      ev_result = abap_on.

    ENDIF.

  ENDMETHOD.


  METHOD get_source.
*   Default value: TDC
    rv_source = 'TDC'.

    ASSIGN COMPONENT '_SOURCE' OF STRUCTURE is_test_data TO FIELD-SYMBOL(<fs_source>).
    IF sy-subrc = 0.
      rv_source = <fs_source>.

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_rap_validate_tdo~check_action.
    CLEAR ev_error.

    cl_abap_behv_load=>get_load(
      EXPORTING
        entity    = iv_name
        all       = abap_off
      IMPORTING
        actions   = DATA(lt_actions)
      RECEIVING
        result    = DATA(lv_result)
    ).
    IF lv_result <> cl_abap_behv_load=>ok.
      me->mo_run_environment->append_log( |Entity { iv_name } not valid !| ).
      ev_error = abap_on.
      RETURN.

    ENDIF.

    READ TABLE lt_actions ASSIGNING FIELD-SYMBOL(<fs_action>) WITH KEY name = iv_action.
    IF sy-subrc <> 0.
      me->mo_run_environment->append_log( |Entity { iv_name }, action { iv_action } is not valid !| ).
      ev_error = abap_on.
      RETURN.

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_rap_validate_tdo~check_association.
    FIELD-SYMBOLS: <fs_association> TYPE cl_abap_behv_load=>t_assoc.

    CLEAR: ev_reverse, ev_error.

    cl_abap_behv_load=>get_load(
      EXPORTING
        entity        = iv_name
        all           = abap_on
      IMPORTING
        associations  = DATA(lt_associations)
      RECEIVING
        result        = DATA(lv_result)
    ).
    IF lv_result <> cl_abap_behv_load=>ok.
      me->mo_run_environment->append_log( |Entity { iv_name } not valid !| ).
      ev_error = abap_on.
      RETURN.

    ENDIF.

    READ TABLE lt_associations ASSIGNING <fs_association> WITH KEY source_entity = iv_p_name target_entity = iv_name name = iv_sub_name.
    IF sy-subrc <> 0.
      IF iv_op = if_abap_behv=>op-r-read.
*       Look in reverse
        READ TABLE lt_associations ASSIGNING <fs_association> WITH KEY source_entity = iv_name name = iv_sub_name. "target_entity = iv_p_name
        IF sy-subrc = 0.
          ev_reverse = abap_on.

        ENDIF.

      ENDIF.

      IF <fs_association> IS NOT ASSIGNED.
*       The entity could be foreign so get the associations of the parent
        cl_abap_behv_load=>get_load(
          EXPORTING
            entity        = iv_p_name
            all           = abap_on
          IMPORTING
            associations  = lt_associations
          RECEIVING
            result        = lv_result
        ).
        IF lv_result <> cl_abap_behv_load=>ok.
          me->mo_run_environment->append_log( |Entity { iv_name } not valid !| ).
          ev_error = abap_on.
          RETURN.

        ENDIF.

        READ TABLE lt_associations ASSIGNING <fs_association> WITH KEY source_entity = iv_p_name target_entity = iv_name name = iv_sub_name.

      ENDIF.

    ENDIF.

    IF <fs_association> IS ASSIGNED.
      IF <fs_association>-properties-enabled <> cl_abap_behv_load=>c_enabled.
        me->mo_run_environment->append_log( |Association { iv_sub_name }, entity { iv_name }, parent { iv_p_name } is not enabled !| ).
        ev_error = abap_on.
        RETURN.

      ENDIF.

      CASE iv_op.
        WHEN if_abap_behv=>op-m-create.
          IF <fs_association>-properties-has_create <> cl_abap_behv_load=>c_enabled_both.
            me->mo_run_environment->append_log( |Create operation for association { iv_sub_name }, entity { iv_name }, parent { iv_p_name } is not allowed !| ).
            ev_error = abap_on.
            RETURN.

          ENDIF.

      ENDCASE.

    ELSE.
      me->mo_run_environment->append_log( |Association { iv_sub_name } for entity { iv_name }, parent { iv_p_name } not valid !| ).
      ev_error = abap_on.
      RETURN.

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_rap_validate_tdo~check_data.
    DATA: lo_typedescr            TYPE REF TO cl_abap_typedescr.

    FIELD-SYMBOLS: <fs_test_data_ref>   TYPE any,
                   <fs_test_data>       TYPE any.

    CLEAR ev_error.

*   Check if it's a table or structure
    lo_typedescr = cl_abap_typedescr=>describe_by_data( is_test_data ).

    CASE lo_typedescr->type_kind.
      WHEN cl_abap_typedescr=>typekind_table. "itab
        LOOP AT is_test_data ASSIGNING <fs_test_data_ref>.
          ASSIGN <fs_test_data_ref>->* TO <fs_test_data>.

          me->check_data_instance(
            EXPORTING
              is_test_data       = <fs_test_data>
              it_operations_read = it_operations_read
              iv_name            = iv_name
              iv_entity_name     = iv_name
              iv_check_only_keys = iv_check_only_keys
            IMPORTING
              ev_error           = ev_error
          ).
          IF ev_error = abap_on.
            EXIT.

          ENDIF.

        ENDLOOP.

      WHEN cl_abap_typedescr=>typekind_struct1
        OR cl_abap_typedescr=>typekind_struct2. "structure
        me->check_data_instance(
          EXPORTING
            is_test_data       = is_test_data
            it_operations_read = it_operations_read
            iv_name            = iv_name
            iv_entity_name     = iv_name
            iv_check_only_keys = iv_check_only_keys
          IMPORTING
            ev_error           = ev_error
        ).

    ENDCASE.

  ENDMETHOD.


  METHOD if_ptf_rap_validate_tdo~check_entity.
    DATA lv_root_entity TYPE abp_root_entity_name.

    CLEAR ev_error.

    DATA(lv_result) = cl_abap_behv_load=>check_existence(
      EXPORTING
        entity      = iv_name
      CHANGING
        root_entity = lv_root_entity
    ).

    IF lv_result <> cl_abap_behv_load=>ok.
      me->mo_run_environment->append_log( |Entity { iv_name } not valid !| ).
      ev_error = abap_on.
      RETURN.

    ENDIF.

    IF lv_root_entity <> iv_root.
*     Get all the associations starting from the root node and check if this entity is contained in any associations
      cl_abap_behv_load=>get_load(
        EXPORTING
          entity        = iv_root
          all           = abap_on
        IMPORTING
          associations  = DATA(lt_associations)
      ).

      IF NOT line_exists( lt_associations[ source_entity = iv_name ] )
        AND NOT line_exists( lt_associations[ target_entity = iv_name ] ).
*       Get all the associations belonging of the root node of the external child entity and check if this entity is contained in any associations
        cl_abap_behv_load=>get_load(
          EXPORTING
            entity        = lv_root_entity
            all           = abap_on
          IMPORTING
            associations  = lt_associations
        ).

        IF NOT line_exists( lt_associations[ source_entity = iv_name ] )
          AND NOT line_exists( lt_associations[ target_entity = iv_name ] ).
          me->mo_run_environment->append_log( |Entity { iv_name } not child of { iv_root } !| ).
          ev_error = abap_on.
          RETURN.

        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_rap_validate_tdo~check_entity_has_draft.
    CLEAR: ev_draft_name, ev_error.

    cl_abap_behv_load=>get_load(
      EXPORTING
        entity    = iv_name
        all       = abap_off
      IMPORTING
        entities  = DATA(lt_entities)
      RECEIVING
        result    = DATA(lv_result)
    ).
    IF lv_result <> cl_abap_behv_load=>ok.
      me->mo_run_environment->append_log( |Entity { iv_name } not valid !| ).
      ev_error = abap_on.
      RETURN.

    ENDIF.

    READ TABLE lt_entities ASSIGNING FIELD-SYMBOL(<fs_entity>) WITH KEY name = iv_name.
    IF sy-subrc = 0.
      IF <fs_entity>-draft_name IS INITIAL.
        me->mo_run_environment->append_log( |Entity { iv_name } is not draft enabled !| ).
        ev_error = abap_on.
        RETURN.
      ELSE.
        ev_draft_name = <fs_entity>-draft_name.

      ENDIF.

    ELSE.
      me->mo_run_environment->append_log( |Entity { iv_name } not valid !| ).
      ev_error = abap_on.
      RETURN.

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_rap_validate_tdo~check_fields.
    DATA: lo_structdescr TYPE REF TO cl_abap_structdescr,
          lo_typedescr   TYPE REF TO cl_abap_typedescr,
          lv_result      TYPE cl_abap_behv_load=>t_result.

    FIELD-SYMBOLS: <fs_value> TYPE any.

    CLEAR ev_error.

*    Not working because lt_features doesn't contain all the possible fields
*    cl_abap_behv_load=>get_load(
*      EXPORTING
*        entity    = iv_name
*        all       = abap_off
*      IMPORTING
*        features  = DATA(lt_features)
*      RECEIVING
*        result    = lv_result
*    ).
*    IF lv_result <> cl_abap_behv_load=>ok.
*      me->mo_run_environment->append_log( |Entity { iv_name } not valid !| ).
*      ev_error = abap_on.
*      RETURN.
*
*    ENDIF.
*
*    lo_structdescr ?= cl_abap_structdescr=>describe_by_data( is_data ).
*    DATA(lt_components) = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).
*
*    LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>) WHERE name NP '_*' AND name NP '%*'. " exclude components starting with '_*' or '%*'
*      IF NOT line_exists( lt_features[ element = <fs_component>-name element_kind = cl_abap_behv_load=>c_feature_elem_field ] ).
**       Check if it's entity
*        lv_result = cl_abap_behv_load=>check_existence(
*          EXPORTING
*            entity      = CONV #( <fs_component>-name ) ).
*        IF lv_result <> cl_abap_behv_load=>ok.
*          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_data TO <fs_value>.
*
**         Check if it's a table or structure
*          lo_typedescr = cl_abap_typedescr=>describe_by_data( <fs_value> ).
*
*          CASE lo_typedescr->type_kind.
*            WHEN cl_abap_typedescr=>typekind_table "itab
*              OR cl_abap_typedescr=>typekind_struct1 "structure
*              OR cl_abap_typedescr=>typekind_struct2.
*              me->mo_run_environment->append_log( |Entity { <fs_component>-name } not valid !| ).
*
*            WHEN OTHERS.
*              me->mo_run_environment->append_log( |Entity { iv_name }, field { <fs_component>-name } not valid !| ).
*
*          ENDCASE.
*
*          ev_error = abap_on.
*          EXIT.
*
*        ENDIF.
*
*      ENDIF.
*
*    ENDLOOP.

    DATA(lr_fields) = cl_abap_behvdescr=>create_data(
                      p_name      = iv_name
                      p_op        = if_abap_behv=>op-r-read "cl_abap_behvdescr=>op_permission
                      p_kind      = if_abap_behv=>typekind-result
                      p_structure = abap_on
                    ).

    lo_structdescr ?= cl_abap_structdescr=>describe_by_data( lr_fields->* ).
    DATA(lt_fields) = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

    lo_structdescr ?= cl_abap_structdescr=>describe_by_data( is_data ).
    DATA(lt_components) = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

    DELETE lt_components WHERE name CP '%*'. "Remove components starting with %
    DELETE lt_components WHERE name CP '_*'. "Remove components starting with _

    LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
      IF NOT line_exists( lt_fields[ name = <fs_component>-name ] ).
*       Check if it's a child entity name
        lv_result = cl_abap_behv_load=>check_existence(
          EXPORTING
            entity      = CONV #( <fs_component>-name ) ).
        IF lv_result <> cl_abap_behv_load=>ok.
          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_data TO <fs_value>.

*         Check if it's a table or structure or simple type
          lo_typedescr = cl_abap_typedescr=>describe_by_data( <fs_value> ).

          CASE lo_typedescr->type_kind.
            WHEN cl_abap_typedescr=>typekind_table "itab
              OR cl_abap_typedescr=>typekind_struct1 "structure
              OR cl_abap_typedescr=>typekind_struct2.
              me->mo_run_environment->append_log( |Entity { <fs_component>-name } not valid !| ).

            WHEN OTHERS.
              me->mo_run_environment->append_log( |Entity { iv_name }, field { <fs_component>-name } not valid !| ).

          ENDCASE.

          ev_error = abap_on.
          EXIT.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD if_ptf_rap_validate_tdo~check_key_empty.
*   Check if key is completely empty
    FIELD-SYMBOLS <fs_value> TYPE ANY.

    rv_key_empty = abap_on.

    DATA(lt_key_components) = me->mo_ptf_rap_metadata->get_key_fields( EXPORTING iv_name = iv_name ).

    LOOP AT lt_key_components ASSIGNING FIELD-SYMBOL(<fs_component>).
      ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_data TO <fs_value>.
      IF sy-subrc = 0.
        IF <fs_value> IS NOT INITIAL.
          rv_key_empty = abap_off.
          EXIT.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD if_ptf_rap_validate_tdo~check_key_fully_filled.
    DATA: lv_pkey_fully_filled TYPE abap_bool VALUE abap_on, "primary key fully filled
          lv_pid_filled        TYPE abap_bool.  "%PID

    FIELD-SYMBOLS <fs_value> TYPE any.

    rv_key_fully_filled = abap_on.

    DATA(lt_key_components) = me->mo_ptf_rap_metadata->get_key_fields( EXPORTING iv_name = iv_name iv_virtual = abap_on ).

    LOOP AT lt_key_components ASSIGNING FIELD-SYMBOL(<fs_component>).
      ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_data TO <fs_value>.
      IF sy-subrc = 0.
        IF <fs_component>-name = cl_abap_behv=>co_techfield_name-pid.
          IF <fs_value> IS NOT INITIAL.
            lv_pid_filled = abap_on.

          ENDIF.

        ELSE.
          IF <fs_value> IS INITIAL.
            lv_pkey_fully_filled = abap_off.

          ENDIF.

        ENDIF.

      ELSE.
        IF <fs_component>-name = cl_abap_behv=>co_techfield_name-pid. "skip the check for %PID
          CONTINUE.

        ELSE.
          lv_pkey_fully_filled = abap_off.

        ENDIF.

      ENDIF.

    ENDLOOP.

    IF lv_pid_filled = abap_off AND lv_pkey_fully_filled = abap_off.
      rv_key_fully_filled = abap_off.

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_rap_validate_tdo~check_operation.
    CLEAR ev_error.

    cl_abap_behv_load=>get_load(
      EXPORTING
        entity    = iv_name
        all       = abap_off
      IMPORTING
        entities  = DATA(lt_entities)
      RECEIVING
        result    = DATA(lv_result)
    ).
    IF lv_result <> cl_abap_behv_load=>ok.
      me->mo_run_environment->append_log( |Entity { iv_name } not valid !| ).
      ev_error = abap_on.
      RETURN.

    ENDIF.

    READ TABLE lt_entities ASSIGNING FIELD-SYMBOL(<fs_entity>) WITH KEY name = iv_name.
    IF sy-subrc = 0.
      CASE iv_op.
        WHEN if_abap_behv=>op-m-create.
*         The CREATE operation is checked only for root entities because child entities don't have any value for property HAS_CREATE (See R_PRODUCTIONSUPPLYAREATP)!!!
          IF iv_root = abap_on.
            IF <fs_entity>-properties-has_create <> cl_abap_behv_load=>c_enabled_both.
              me->mo_run_environment->append_log( |Create operation for entity { iv_name } is not allowed !| ).
              ev_error = abap_on.
              RETURN.

            ENDIF.

          ENDIF.

        WHEN if_abap_behv=>op-m-update.
          IF <fs_entity>-properties-has_update <> cl_abap_behv_load=>c_enabled_both.
            me->mo_run_environment->append_log( |Update operation for entity { iv_name } is not allowed !| ).
            ev_error = abap_on.
            RETURN.

          ENDIF.

        WHEN if_abap_behv=>op-m-delete.
          IF <fs_entity>-properties-has_delete <> cl_abap_behv_load=>c_enabled_both.
            me->mo_run_environment->append_log( |Delete operation for entity { iv_name } is not allowed !| ).
            ev_error = abap_on.
            RETURN.

          ENDIF.

      ENDCASE.

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_rap_validate_tdo~check_params.
    CLEAR ev_error.

    ASSIGN COMPONENT '_PARAMS' OF STRUCTURE is_data TO FIELD-SYMBOL(<fs_data>).
    IF sy-subrc = 0.
      DATA(lr_fields) = cl_abap_behvdescr=>create_data(
         p_name      = iv_name
         p_sub_name  = iv_p_sub_name
         p_op        = if_abap_behv=>op-m-action
         p_kind      = if_abap_behv=>typekind-import
         p_structure = abap_on
      ).

      ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-param OF STRUCTURE lr_fields->* TO FIELD-SYMBOL(<fs_params>).
      IF sy-subrc = 0.
        me->recursive_check_params(
          EXPORTING
            iv_name       = iv_name
            iv_p_sub_name = iv_p_sub_name
            is_data       = <fs_data>
            is_params     = <fs_params>
          IMPORTING
            ev_error      = ev_error
        ).
        IF ev_error = abap_on.
          RETURN.

        ENDIF.

      ELSE.
        me->mo_run_environment->append_log( |Entity { iv_name }, action { iv_p_sub_name }: Parameters don't exist !| ).
        ev_error = abap_on.
        RETURN.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_rap_validate_tdo~move_test_data.
    DATA: lx_conv_error     TYPE REF TO cx_sy_conversion_error,
          lo_structdescr    TYPE REF TO cl_abap_structdescr,
          lo_elemdescr      TYPE REF TO cl_abap_elemdescr,
          lt_messages       TYPE STANDARD TABLE OF string,
          lv_root_child     TYPE string,
          lv_context        TYPE string,
          lv_keys           TYPE string,
          lv_parent         TYPE string,
          lv_compare        TYPE string,
          lv_message        TYPE string,
          lv_funcname       TYPE funcname,
          lv_conv_applied   TYPE abap_bool.

    FIELD-SYMBOLS: <fs_test_data_field>   TYPE any,
                   <fs_target_data_field> TYPE any.

    CLEAR: ev_error.

    lv_root_child = SWITCH #( iv_root WHEN abap_on THEN 'Root' WHEN abap_off THEN 'Child' ).

    IF iv_context IS SUPPLIED.
      lv_parent   = SWITCH #( iv_parent  WHEN abap_on THEN 'parent' ).
      lv_compare  = SWITCH #( iv_compare WHEN abap_on THEN 'compare' ).
      lv_keys     = SWITCH #( iv_context WHEN if_ptf_rap_validate_tdo=>permissions OR if_ptf_rap_validate_tdo=>filters THEN 'keys' ).

      lv_context  = SWITCH #( iv_context WHEN if_ptf_rap_validate_tdo=>key_finder THEN 'key finder'
                                         WHEN if_ptf_rap_validate_tdo=>permissions THEN 'permissions'
                                         WHEN if_ptf_rap_validate_tdo=>operations THEN 'operations'
                                         WHEN if_ptf_rap_validate_tdo=>checks THEN 'checks'
                                         WHEN if_ptf_rap_validate_tdo=>filters THEN 'filters' ).

      lv_message = |{ lv_root_child } entity { iv_name }: Moving { lv_parent } test { lv_compare } data { lv_keys } to entity data for { lv_context }:|.
      lv_message = replace( val = lv_message pcre = '\s\s+' with = ` ` occ = 0 ). "only ` ` works, space or ' ' don't work
      APPEND lv_message TO lt_messages.

    ENDIF.

    lo_structdescr ?= cl_abap_structdescr=>describe_by_data( cs_target_data ).
    DATA(lt_components) = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

    LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
      ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_test_data TO <fs_test_data_field>.
      IF sy-subrc = 0.
        IF <fs_test_data_field> IS NOT INITIAL.
          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE cs_target_data TO <fs_target_data_field>.
          IF sy-subrc = 0.
            TRY.
              lo_elemdescr ?= <fs_component>-type.

              TRY.
                <fs_target_data_field> = <fs_test_data_field>.

                CATCH cx_sy_conversion_error INTO lx_conv_error.
                  CASE iv_root.
                    WHEN abap_on.
                      lv_message = |Root entity { iv_name }: Error converting test data to entity data|.
                      APPEND lv_message TO lt_messages.

                    WHEN abap_off.
                      CASE iv_compare.
                        WHEN abap_off.
                          lv_message = |Child entity { iv_name }: Error converting test data to entity data|.
                          APPEND lv_message TO lt_messages.

                        WHEN abap_on.
                          lv_message = |Child entity { iv_name }: Error converting test compare data to entity data|.
                          APPEND lv_message TO lt_messages.

                      ENDCASE.

                  ENDCASE.

                  lv_message = lx_conv_error->get_text( ).
                  APPEND lv_message TO lt_messages.

                  ev_error = abap_on.

                  me->log_messages( lt_messages ).

                  EXIT.

              ENDTRY.

              IF lo_elemdescr->edit_mask IS NOT INITIAL.
                CASE lo_elemdescr->edit_mask+2.
                  WHEN 'ALPHA' OR 'ISOLA'." OR 'CUNIT'.
                    IF lo_elemdescr->edit_mask+2 = 'ALPHA'. "ALPHA dumps if the length of the input field is longer than allowed
                      IF lo_elemdescr->type_kind = cl_abap_typedescr=>typekind_char
                        OR lo_elemdescr->type_kind = cl_abap_typedescr=>typekind_num.
                        IF strlen( <fs_test_data_field> ) > strlen( <fs_target_data_field> ).
                          lv_message = |{ lv_root_child } entity { iv_name }, field { <fs_component>-name }: Conversion input length longer than allowed|.
                          APPEND lv_message TO lt_messages.

                          ev_error = abap_on.

                          me->log_messages( lt_messages ).

                          EXIT.

                        ENDIF.

                      ENDIF.

                    ENDIF.

                    lv_conv_applied = abap_on.

                    lv_funcname = |CONVERSION_EXIT_{ lo_elemdescr->edit_mask+2 }_INPUT|.

                    CALL FUNCTION lv_funcname
                      EXPORTING
                        input  = <fs_test_data_field>
                      IMPORTING
                        output = <fs_target_data_field>
                      EXCEPTIONS
                        OTHERS = 1.
                    IF sy-subrc <> 0.
                      lv_message = |{ lv_root_child } entity { iv_name }, field { <fs_component>-name }: Conversion routine { lo_elemdescr->edit_mask+2 } raised an error|.
                      APPEND lv_message TO lt_messages.

                      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO lv_message.
                      lv_message = |Error message { sy-msgid }({ sy-msgno }): { lv_message }|.
                      APPEND lv_message TO lt_messages.

                    ELSE.
                      IF <fs_test_data_field> = <fs_target_data_field>.
                        lv_message = |{ lv_root_child } entity { iv_name }, field { <fs_component>-name }: Conversion routine { lo_elemdescr->edit_mask+2 } applied, no effect|.
                        APPEND lv_message TO lt_messages.

                      ELSE.
                        lv_message = |{ lv_root_child } entity { iv_name }, field { <fs_component>-name }: Conversion routine { lo_elemdescr->edit_mask+2 } applied|.
                        APPEND lv_message TO lt_messages.
                        lv_message = |From external format { <fs_test_data_field> } to internal format { <fs_target_data_field> }|.
                        APPEND lv_message TO lt_messages.

                      ENDIF.

                   ENDIF.

                ENDCASE.

              ENDIF.

            CATCH cx_sy_move_cast_error ##NO_HANDLER.
              "Only simple elements are allowed
            ENDTRY.

          ENDIF.

        ENDIF.

      ENDIF.

    ENDLOOP.

    IF ev_error = abap_on.
      RETURN.

    ENDIF.

    IF lv_conv_applied = abap_on
      AND iv_context = if_ptf_rap_validate_tdo=>permissions. "Log messages only for permissions when there is no error to save up lines
      me->log_messages( lt_messages ).

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_rap_validate_tdo~set_control_flag.
    FIELD-SYMBOLS: <fs_test_data_field> TYPE any.

    CLEAR: es_flag_control_issues, ev_flag_control.

    CASE iv_op.
      WHEN if_abap_behv=>op-m-create
        OR if_abap_behv=>op-m-update.
        CASE iv_field_control.
          WHEN if_abap_behv=>fc-f-mandatory OR if_abap_behv=>perm-f-mandatory_create OR '30' ##LITERAL.
            IF iv_field IS INITIAL.
IF iv_op NE if_abap_behv=>op-m-update. "ERX only: avoid UPDATE errors for create-mandatory fields not mentioned. In ER1, compare ER1K8A2CTD
              es_flag_control_issues-e_is_mandatory = abap_on.
              RETURN.
ENDIF.

            ELSE.
              CASE iv_field_control.
                WHEN '30' ##LITERAL.
                  CASE iv_op.
                    WHEN if_abap_behv=>op-m-create.
                      ev_flag_control = cl_abap_behv=>flag_changed.

                  ENDCASE.

                WHEN OTHERS.
                  ev_flag_control = cl_abap_behv=>flag_changed.

              ENDCASE.

            ENDIF.

          WHEN if_abap_behv=>perm-f-read_only_update.
            CASE iv_op.
              WHEN if_abap_behv=>op-m-create.
                IF iv_field IS NOT INITIAL.
                  ev_flag_control = cl_abap_behv=>flag_changed.

                ENDIF.

              WHEN if_abap_behv=>op-m-update.
                "Field is read only, no flag for change
                IF iv_field IS NOT INITIAL. "Only if it's valued
                  es_flag_control_issues-w_is_readonly = abap_on.

                ENDIF.

            ENDCASE.

          WHEN if_abap_behv=>fc-f-unrestricted.
            "Field is unrestricted, set the flag for change
            IF iv_field IS NOT INITIAL. "Only if it's valued
              ev_flag_control = cl_abap_behv=>flag_changed.

            ELSE.
*              CASE iv_op.
*                WHEN if_abap_behv=>op-m-update.
                  IF iv_initial = abap_off.
                    ASSIGN COMPONENT iv_name OF STRUCTURE is_test_data TO <fs_test_data_field>.
                    IF sy-subrc = 0.
                      es_flag_control_issues-w_use_initial = abap_on.

                    ENDIF.

                  ENDIF.

*              ENDCASE.

            ENDIF.

          WHEN if_abap_behv=>fc-f-read_only.
            "Field is read only, no flag for change
            IF iv_field IS NOT INITIAL. "Only if it's valued
              es_flag_control_issues-w_is_readonly = abap_on.

            ENDIF.

        ENDCASE.

*       Check if we force initial value
*        CASE iv_op.
*          WHEN if_abap_behv=>op-m-update.
            IF iv_initial = abap_on.
              "Issue error if field is valued
              IF iv_field IS NOT INITIAL.
                CLEAR ev_flag_control.
                es_flag_control_issues-e_value_w_initial = abap_on.
                RETURN.

              ENDIF.

              ev_flag_control = cl_abap_behv=>flag_changed.

            ENDIF.

*        ENDCASE.

      WHEN if_abap_behv=>op-m-delete.

      WHEN if_abap_behv=>op-r-read.
        CASE iv_action.
          WHEN 'RETRIEVE' OR 'RETRIEVE_ALL'.
            ev_flag_control = cl_abap_behv=>flag_changed.

          WHEN OTHERS.
*           Check if component exists in TDO, this is needed for CHECKS
            ASSIGN COMPONENT iv_name OF STRUCTURE is_test_data TO <fs_test_data_field>.
            IF sy-subrc = 0.
              ev_flag_control = cl_abap_behv=>flag_changed.

            ENDIF.

        ENDCASE.

    ENDCASE.

  ENDMETHOD.


  METHOD log_check_data_messages.
    DATA: lv_message TYPE string.

    FIELD-SYMBOLS: <fs_component>     TYPE abap_componentdescr,
                   <fs_field_c>       TYPE any.

    CLEAR ev_error.

    CASE iv_is_existing.
      WHEN abap_on.
        IF iv_line_found = abap_off. "Line is not found
          me->mo_run_environment->append_log( 'Entity expected to exist was NOT found' ).
          me->mo_run_environment->append_log( |Error Entity Name: { iv_entity_name } not found !| ).

*         Determine the key values for the error
          lv_message = 'Error Key Fields: '.

          LOOP AT it_key_components ASSIGNING <fs_component>.
            ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_result_c TO <fs_field_c>.
            IF sy-subrc = 0.
              IF <fs_field_c> IS NOT INITIAL.
                lv_message = |{ lv_message } { <fs_component>-name }: { <fs_field_c> }|.

              ENDIF.

            ENDIF.

          ENDLOOP.

          me->mo_run_environment->append_log( lv_message ).

          ev_error = abap_on.

        ENDIF.

      WHEN abap_off.
        IF iv_line_found = abap_on. "Line is found
          me->mo_run_environment->append_log( 'Entity expected NOT to exist was found' ).
          me->mo_run_environment->append_log( |Error Entity Name: { iv_entity_name } was found !| ).

*         Determine the key values for the error
          lv_message = 'Error Key Fields: '.

          LOOP AT it_key_components ASSIGNING <fs_component>.
            ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_result_c TO <fs_field_c>.
            IF sy-subrc = 0.
              IF <fs_field_c> IS NOT INITIAL.
                lv_message = |{ lv_message } { <fs_component>-name }: { <fs_field_c> }|.

              ENDIF.

            ENDIF.

          ENDLOOP.

          me->mo_run_environment->append_log( lv_message ).

          ev_error = abap_on.

        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD log_messages.
    LOOP AT it_messages ASSIGNING FIELD-SYMBOL(<fs_message>).
      me->mo_run_environment->append_log( <fs_message> ).

    ENDLOOP.

  ENDMETHOD.


  METHOD recursive_check_params.
    DATA: lo_tabledescr  TYPE REF TO cl_abap_tabledescr,
          lo_structdescr TYPE REF TO cl_abap_structdescr,
          lo_typedescr   TYPE REF TO cl_abap_typedescr,
          lr_data        TYPE REF TO data,
          lr_params      TYPE REF TO data,
          lt_components  TYPE abap_component_tab,
          lt_params      TYPE abap_component_tab.

    FIELD-SYMBOLS: <fs_component>     TYPE abap_componentdescr,
                   <fs_data_table>    TYPE STANDARD TABLE,
                   <fs_params_table>  TYPE STANDARD TABLE,
                   <fs_data>          TYPE any,
                   <fs_params>        TYPE any.

    CLEAR ev_error.

    lo_typedescr = cl_abap_typedescr=>describe_by_data( is_data ).

    CASE lo_typedescr->type_kind.
      WHEN cl_abap_typedescr=>typekind_table. "itab
        lo_tabledescr ?= lo_typedescr.
        lo_structdescr ?= lo_tabledescr->get_table_line_type( ).

        lt_components = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

        lo_typedescr = cl_abap_typedescr=>describe_by_data( is_params ).

        TRY.
          lo_tabledescr ?= lo_typedescr.

        CATCH cx_sy_move_cast_error ##NO_HANDLER.
          me->mo_run_environment->append_log( |Entity { iv_name }, action { iv_p_sub_name }, field { iv_component_name } of wrong type !| ).
          me->mo_run_environment->append_log( 'Expected an internal table' ).
          ev_error = abap_on.
          RETURN.

        ENDTRY.

        lo_structdescr ?= lo_tabledescr->get_table_line_type( ).

        lt_params = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

      WHEN cl_abap_typedescr=>typekind_struct1 "structure
        OR cl_abap_typedescr=>typekind_struct2.
        lo_structdescr ?= cl_abap_structdescr=>describe_by_data( is_data ).
        lt_components = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

        TRY.
          lo_structdescr ?= cl_abap_structdescr=>describe_by_data( is_params ).

        CATCH cx_sy_move_cast_error ##NO_HANDLER.
          me->mo_run_environment->append_log( |Entity { iv_name }, action { iv_p_sub_name }, field { iv_component_name } of wrong type !| ).
          me->mo_run_environment->append_log( 'Expected a structure' ).
          ev_error = abap_on.
          RETURN.

        ENDTRY.

        lt_params = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

    ENDCASE.

    LOOP AT lt_components ASSIGNING <fs_component>.
      IF NOT line_exists( lt_params[ name = <fs_component>-name ] ).
        me->mo_run_environment->append_log( |Entity { iv_name }, action { iv_p_sub_name }, field { <fs_component>-name } not valid !| ).
        ev_error = abap_on.
        EXIT.

      ENDIF.

      lo_typedescr = <fs_component>-type.

      CASE lo_typedescr->type_kind.
        WHEN cl_abap_typedescr=>typekind_table. "itab
*         Check if also params is a table
          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_params TO <fs_params>.

          TRY.
            lo_tabledescr ?= cl_abap_tabledescr=>describe_by_data( <fs_params> ).

          CATCH cx_sy_move_cast_error ##NO_HANDLER.
            me->mo_run_environment->append_log( |Entity { iv_name }, action { iv_p_sub_name }, field { <fs_component>-name } of wrong type !| ).
            me->mo_run_environment->append_log( 'Expected a structure' ).
            ev_error = abap_on.
            EXIT.

          ENDTRY.

          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_data TO <fs_data_table>.
          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_params TO <fs_params_table>.

          lo_tabledescr ?= cl_abap_tabledescr=>describe_by_data( <fs_data_table> ).
          lo_structdescr ?= lo_tabledescr->get_table_line_type( ).

          CREATE DATA lr_data TYPE HANDLE lo_structdescr.
          ASSIGN lr_data->* TO <fs_data>.

          lo_tabledescr ?= cl_abap_tabledescr=>describe_by_data( <fs_params_table> ).
          lo_structdescr ?= lo_tabledescr->get_table_line_type( ).

          CREATE DATA lr_params TYPE HANDLE lo_structdescr.
          ASSIGN lr_params->* TO <fs_params>.

          me->recursive_check_params(
            EXPORTING
              iv_name           = iv_name
              iv_p_sub_name     = iv_p_sub_name
              iv_component_name = CONV #( <fs_component>-name )
              is_data           = <fs_data>
              is_params         = <fs_params>
            IMPORTING
              ev_error          = ev_error
          ).

          IF ev_error = abap_on.
            RETURN.

          ENDIF.

        WHEN cl_abap_typedescr=>typekind_struct1 "structure
          OR cl_abap_typedescr=>typekind_struct2.
          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_data TO <fs_data>.
          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_params TO <fs_params>.

          me->recursive_check_params(
            EXPORTING
              iv_name           = iv_name
              iv_p_sub_name     = iv_p_sub_name
              iv_component_name = CONV #( <fs_component>-name )
              is_data           = <fs_data>
              is_params         = <fs_params>
            IMPORTING
              ev_error          = ev_error
          ).

          IF ev_error = abap_on.
            RETURN.

          ENDIF.

      ENDCASE.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
