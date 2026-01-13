class CL_PTF_RAP_PERMISSIONS definition
  public
  final
  create public .

public section.

  interfaces IF_PTF_RAP_PERMISSIONS .

  aliases BUILD_PERMISSIONS
    for IF_PTF_RAP_PERMISSIONS~BUILD_PERMISSIONS .
  aliases HANDLE_PERMISSIONS_ERROR
    for IF_PTF_RAP_PERMISSIONS~HANDLE_PERMISSIONS_ERROR .

  methods BUILD_PERMISSIONS_INSTANCE
    importing
      !IV_OP type ABP_BEHV_OP
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IS_TEST_DATA type DATA
    exporting
      !EV_ERROR type ABAP_BOOL
    changing
      !CT_PERMISSIONS type ABP_BEHV_PERMISSIONS_TAB .
  methods CONSTRUCTOR
    importing
      !IO_RUN_ENVIRONMENT type ref to CL_PTF_RUN .
protected section.
private section.

  data MO_RUN_ENVIRONMENT type ref to CL_PTF_RUN .
  data MO_PTF_RAP_METADATA type ref to IF_PTF_RAP_METADATA .
  data MO_PTF_RAP_VALIDATE_TDO type ref to IF_PTF_RAP_VALIDATE_TDO .

  methods RECURSIVE_FILL_PERMISSIONS
    importing
      !IV_OP type ABP_BEHV_OP
      !IT_COMPONENTS type ABAP_COMPONENT_TAB
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IS_TEST_DATA type DATA
      !IS_PARENT_INSTANCE type DATA optional
    exporting
      !EV_ERROR type ABAP_BOOL
    changing
      !CT_PERMISSIONS type ABP_BEHV_PERMISSIONS_TAB .
  methods FILL_CHILD_PERMISSIONS
    importing
      !IV_OP type ABP_BEHV_OP
      !IS_TEST_DATA type DATA
      !IS_PARENT_INSTANCE type DATA optional
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
    exporting
      !ER_INSTANCE type ref to DATA
      !ET_CHILD_COMPONENTS type ABAP_COMPONENT_TAB
      !EV_ERROR type ABAP_BOOL
    changing
      !CS_PERMISSION type ABP_BEHV_PERMISSIONS .
ENDCLASS.



CLASS CL_PTF_RAP_PERMISSIONS IMPLEMENTATION.


  METHOD build_permissions_instance.
    DATA: lo_structdescr TYPE REF TO cl_abap_structdescr,
          lr_dyn_row     TYPE REF TO data,
          "lx_conv_error  TYPE REF TO cx_sy_conversion_error,
          ls_permission  TYPE abp_behv_permissions,
          lv_name        TYPE cl_abap_behvdescr=>t_typename,
          lv_p_sub_name  TYPE cl_abap_behvdescr=>t_sub_name,
          lv_tabix       TYPE syst-tabix.

    FIELD-SYMBOLS: <fs_instances_perm> TYPE STANDARD TABLE,
                   <fs_permission>     TYPE abp_behv_permissions,
                   <fs_request_perm>   TYPE any,
                   <fs_dyn_row>        TYPE any,
                   <fs_structure>      TYPE any,
                   <fs_action>         TYPE any,
                   <fs_field>          TYPE any,
                   <fs_component>      TYPE abap_componentdescr.

    CLEAR ev_error.

    lv_name = is_step_data-bus_obj.

*   Check if we have childentity mentioned
    ASSIGN COMPONENT '_CHILDENTITYNAME' OF STRUCTURE is_test_data TO FIELD-SYMBOL(<fs_childentityname>).
    IF sy-subrc = 0.
      lv_name = <fs_childentityname>.

    ENDIF.

*   Check if we have action mentioned
    CASE iv_op.
      WHEN if_abap_behv=>op-m-action.
        CASE is_step_data-action.
          WHEN 'ENTITY_ACTION'.
            ASSIGN COMPONENT '_ACTION' OF STRUCTURE is_test_data TO <fs_action>.
            IF sy-subrc = 0.
              lv_p_sub_name = <fs_action>.

            ENDIF.

          WHEN OTHERS.
            lv_p_sub_name = is_step_data-action.

        ENDCASE.

    ENDCASE.

*   Validate entity
    me->mo_ptf_rap_validate_tdo->check_entity(
      EXPORTING
        iv_root   = is_step_data-bus_obj
        iv_name   = lv_name
      IMPORTING
        ev_error  = ev_error
    ).
    IF ev_error = abap_on.
      RETURN.

    ENDIF.

*   Validate fields
    me->mo_ptf_rap_validate_tdo->check_fields(
      EXPORTING
        iv_name   = lv_name
        is_data   = is_test_data
      IMPORTING
        ev_error  = ev_error
    ).
    IF ev_error = abap_on.
      RETURN.

    ENDIF.

    lo_structdescr ?= cl_abap_structdescr=>describe_by_data( is_test_data ).
    DATA(lt_components) = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

*   Get also the key components as they might be missing from the test data
    DATA(lt_key_components) = me->mo_ptf_rap_metadata->get_key_fields( EXPORTING iv_name = lv_name ). "is_step_data-bus_obj

    APPEND LINES OF lt_key_components TO lt_components.
    SORT lt_components. DELETE ADJACENT DUPLICATES FROM lt_components.

*   Get permission for root entity
    IF NOT line_exists( ct_permissions[ entity_name = lv_name ] ).
      ls_permission-entity_name = lv_name. "is_step_data-bus_obj

      ls_permission-instances = cl_abap_behvdescr=>create_data(
                                      p_name      = lv_name "is_step_data-bus_obj
                                      p_op        = cl_abap_behvdescr=>op_permission
                                      "p_sub_name  = lv_p_sub_name
                                      "p_kind = if_abap_behv=>typekind-request
                                      "p_structure = abap_on
                                   ).

      ls_permission-request = cl_abap_behvdescr=>create_data(
                                      p_name      = lv_name "is_step_data-bus_obj
                                      p_op        = cl_abap_behvdescr=>op_permission
                                      "p_sub_name  = lv_p_sub_name
                                      p_kind      = if_abap_behv=>typekind-request
                                      "p_structure = abap_on
                                   ).

      ls_permission-results = cl_abap_behvdescr=>create_data(
                                      p_name      = lv_name "is_step_data-bus_obj
                                      p_op        = cl_abap_behvdescr=>op_permission
                                      "p_sub_name  = lv_p_sub_name
                                      p_kind      = if_abap_behv=>typekind-result
                                   ).

      ASSIGN ls_permission-instances->* TO <fs_instances_perm>.

    ELSE.
      ASSIGN ct_permissions[ entity_name = lv_name ] TO <fs_permission>.

      ASSIGN <fs_permission>-instances->* TO <fs_instances_perm>.

    ENDIF.

    CREATE DATA lr_dyn_row LIKE LINE OF <fs_instances_perm>.
    ASSIGN lr_dyn_row->* TO <fs_dyn_row>.

*    TRY.
*        <fs_dyn_row> = CORRESPONDING #( is_test_data ).
*
*      CATCH cx_sy_conversion_error INTO lx_conv_error.
*        me->mo_run_environment->append_log( |Root entity { is_step_data-bus_obj }: Error converting test data to entity data| ).
*        me->mo_run_environment->append_log( lx_conv_error->get_text( ) ).
*        ev_error = abap_on.
*        RETURN.
*
*    ENDTRY.

*   Move components 1 by 1 and apply conversion routine where applicable
    me->mo_ptf_rap_validate_tdo->move_test_data(
      EXPORTING
        is_test_data   = is_test_data
        iv_name        = lv_name
        iv_root        = abap_on
        iv_context     = if_ptf_rap_validate_tdo=>permissions
      IMPORTING
        ev_error       = ev_error
      CHANGING
        cs_target_data = <fs_dyn_row> ).
    IF ev_error = abap_on.
      RETURN.

    ENDIF.

    IF NOT <fs_dyn_row> IS INITIAL.
      CASE iv_op.
        WHEN if_abap_behv=>op-m-create.
          "Don't do anything in creation mode

        WHEN if_abap_behv=>op-m-action.
*         Don't fill instances in case of actions that have authorization and don't have real key
          DATA(lv_key_empty) = me->mo_ptf_rap_validate_tdo->check_key_empty( iv_name = lv_name
                                                                             is_data = <fs_dyn_row> ).
          IF lv_key_empty = abap_on.
            cl_abap_behv_load=>get_load(
              EXPORTING
                entity    = lv_name
                all       = abap_off
              IMPORTING
                features  = DATA(lt_features)
            ).
            IF line_exists( lt_features[ owner_entity = lv_name element = lv_p_sub_name ] ).
              IF lt_features[ owner_entity = lv_name element = lv_p_sub_name ]-authorization_features IS INITIAL.
                APPEND <fs_dyn_row> TO <fs_instances_perm>.

              ENDIF.

            ENDIF.

          ELSE.
            APPEND <fs_dyn_row> TO <fs_instances_perm>.

          ENDIF.

        WHEN OTHERS.
          APPEND <fs_dyn_row> TO <fs_instances_perm>.

      ENDCASE.

    ENDIF.

    IF NOT line_exists( ct_permissions[ entity_name = lv_name ] ).
      ASSIGN ls_permission-request->* TO <fs_request_perm>.

    ELSE.
      ASSIGN <fs_permission>-request->* TO <fs_request_perm>.

    ENDIF.

    ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-field OF STRUCTURE <fs_request_perm> TO <fs_structure>.
    IF sy-subrc = 0.
      LOOP AT lt_components ASSIGNING <fs_component>.
        lv_tabix = sy-tabix.
        ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_structure> TO <fs_field>.
        IF sy-subrc = 0.
*          <fs_field> = cl_abap_behv=>flag_changed.

          DELETE lt_components INDEX lv_tabix.

        ENDIF.

      ENDLOOP.

*     Flag all permissions because we get a dump for a field that is mandatory but missing in TDO
      lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_structure> ).
      DATA(lt_perm_components) = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

      LOOP AT lt_perm_components ASSIGNING <fs_component>.
        ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_structure> TO <fs_field>.
        IF sy-subrc = 0.
          <fs_field> = cl_abap_behv=>flag_changed.

        ENDIF.

      ENDLOOP.

    ENDIF.

*   Check action permission
    CASE iv_op.
      WHEN if_abap_behv=>op-m-action.
        ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-action OF STRUCTURE <fs_request_perm> TO <fs_action>.
        IF sy-subrc = 0.
          ASSIGN COMPONENT lv_p_sub_name OF STRUCTURE <fs_action> TO <fs_field>.
          IF sy-subrc = 0.
            <fs_field> = cl_abap_behv=>flag_changed.

          ENDIF.

        ENDIF.

    ENDCASE.

    IF NOT line_exists( ct_permissions[ entity_name = lv_name ] ).
      APPEND ls_permission TO ct_permissions.

    ENDIF.

*   recursive fill permissions
    me->recursive_fill_permissions(
      EXPORTING
        iv_op               = iv_op
        it_components       = lt_components
        is_step_data        = is_step_data
        is_test_data        = is_test_data
        is_parent_instance  = <fs_dyn_row>
      IMPORTING
        ev_error            = ev_error
      CHANGING
        ct_permissions      = ct_permissions
    ).

    IF ev_error = abap_on.
      RETURN.

    ENDIF.

  ENDMETHOD.


  METHOD constructor.
    me->mo_run_environment      = io_run_environment.
    me->mo_ptf_rap_metadata     = NEW cl_ptf_rap_metadata( ).
    me->mo_ptf_rap_validate_tdo = NEW cl_ptf_rap_validate_tdo( io_run_environment ).

  ENDMETHOD.


  METHOD fill_child_permissions.
    DATA: lo_structdescr          TYPE REF TO cl_abap_structdescr,
          lr_dyn_row              TYPE REF TO data,
          "lx_conv_error           TYPE REF TO cx_sy_conversion_error,
          lv_tabix                TYPE syst-tabix.

    FIELD-SYMBOLS: <fs_component>      TYPE abap_componentdescr,
                   <fs_instances_perm> TYPE STANDARD TABLE,
                   <fs_dyn_row>        TYPE any,
                   <fs_request_perm>   TYPE any,
                   <fs_structure>      TYPE any,
                   <fs_field>          TYPE any.

    CLEAR: er_instance, et_child_components, ev_error.

*   Validate fields
    me->mo_ptf_rap_validate_tdo->check_fields(
      EXPORTING
        iv_name   = iv_name
        is_data   = is_test_data
      IMPORTING
        ev_error  = ev_error
    ).
    IF ev_error = abap_on.
      RETURN.

    ENDIF.

    ASSIGN cs_permission-instances->* TO <fs_instances_perm>.

    CREATE DATA lr_dyn_row LIKE LINE OF <fs_instances_perm>.
    ASSIGN lr_dyn_row->* TO <fs_dyn_row>.

*    TRY.
*        <fs_dyn_row> = CORRESPONDING #( is_test_data ).
*
*      CATCH cx_sy_conversion_error INTO lx_conv_error.
*        me->mo_run_environment->append_log( |Child entity { iv_name }: Error converting test data to entity data| ).
*        me->mo_run_environment->append_log( lx_conv_error->get_text( ) ).
*        ev_error = abap_on.
*        RETURN.
*
*    ENDTRY.

*   Move components 1 by 1 and apply conversion routine where applicable
    me->mo_ptf_rap_validate_tdo->move_test_data(
      EXPORTING
        is_test_data   = is_test_data
        iv_name        = iv_name
        iv_context     = if_ptf_rap_validate_tdo=>permissions
      IMPORTING
        ev_error       = ev_error
      CHANGING
        cs_target_data = <fs_dyn_row> ).
    IF ev_error = abap_on.
      RETURN.

    ENDIF.

*   Get key fields
    DATA(lt_key_components) = me->mo_ptf_rap_metadata->get_key_fields( EXPORTING iv_name = iv_name ).

*   Move the key fields from parent
    IF is_parent_instance IS SUPPLIED.
      LOOP AT lt_key_components ASSIGNING <fs_component>.
        ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_parent_instance TO FIELD-SYMBOL(<fs_key_field>).
        IF sy-subrc = 0.
          IF NOT <fs_key_field> IS INITIAL.
            ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_dyn_row> TO <fs_field>.
            IF sy-subrc = 0.
              <fs_field> = <fs_key_field>.

            ENDIF.

          ENDIF.

        ENDIF.

      ENDLOOP.

    ENDIF.

    IF NOT <fs_dyn_row> IS INITIAL.

      CASE iv_op.
        WHEN if_abap_behv=>op-m-create
          OR if_abap_behv=>op-m-create_ba.
          "Don't do anything in creation mode

        WHEN OTHERS.

*     If key is not complete then do not add the item to instances
      DATA(lv_is_full_key) = abap_on.

      LOOP AT lt_key_components ASSIGNING <fs_component>.
        ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_dyn_row> TO <fs_field>.
        IF sy-subrc = 0.
          IF <fs_field> IS INITIAL.
            lv_is_full_key = abap_off.

          ENDIF.

        ENDIF.

      ENDLOOP.

      IF lv_is_full_key = abap_on.
        APPEND <fs_dyn_row> TO <fs_instances_perm>.

      ENDIF.

ENDCASE.

    ENDIF.

    GET REFERENCE OF <fs_dyn_row> INTO er_instance.

    ASSIGN cs_permission-request->* TO <fs_request_perm>.

    ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-field OF STRUCTURE <fs_request_perm> TO <fs_structure>.
    IF sy-subrc = 0.
      lo_structdescr ?= cl_abap_structdescr=>describe_by_data( is_test_data ).
      et_child_components = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

*     Get also the key components as they might be missing from the test data
      APPEND LINES OF lt_key_components TO et_child_components.
      SORT et_child_components. DELETE ADJACENT DUPLICATES FROM et_child_components.

      LOOP AT et_child_components ASSIGNING FIELD-SYMBOL(<fs_child_component>).
        lv_tabix = sy-tabix.
        ASSIGN COMPONENT <fs_child_component>-name OF STRUCTURE <fs_structure> TO <fs_field>.
        IF sy-subrc = 0.
*          <fs_field> = cl_abap_behv=>flag_changed.

          DELETE et_child_components INDEX lv_tabix.

        ELSE. "Check if components belongs to parent instance (reverse association)
          IF <fs_child_component>-name NP '%*'. "Check not to be a technical field
            ASSIGN COMPONENT <fs_child_component>-name OF STRUCTURE is_parent_instance TO <fs_field>.
            IF sy-subrc = 0.
              DELETE et_child_components INDEX lv_tabix.

            ENDIF.

          ENDIF.

        ENDIF.

      ENDLOOP.

*     Flag all permissions because we get a dump for a field that is mandatory but missing in TDO
      lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_structure> ).
      DATA(lt_perm_components) = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

      LOOP AT lt_perm_components ASSIGNING <fs_component>.
        ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_structure> TO <fs_field>.
        IF sy-subrc = 0.
          <fs_field> = cl_abap_behv=>flag_changed.

        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_rap_permissions~build_permissions.
    DATA: lo_typedescr  TYPE REF TO cl_abap_typedescr.

    FIELD-SYMBOLS: <fs_test_data_ref> TYPE any,
                   <fs_test_data>     TYPE any.

    CLEAR ev_error.

*   Check if it's a table or structure
    lo_typedescr = cl_abap_typedescr=>describe_by_data( is_test_data ).

    CASE lo_typedescr->type_kind.
      WHEN cl_abap_typedescr=>typekind_table. "itab
        LOOP AT is_test_data ASSIGNING <fs_test_data_ref>.
          ASSIGN <fs_test_data_ref>->* TO <fs_test_data>.

          me->build_permissions_instance(
            EXPORTING
              iv_op           = iv_op
              is_step_data    = is_step_data
              is_test_data    = <fs_test_data>
            IMPORTING
              ev_error        = ev_error
            CHANGING
              ct_permissions  = ct_permissions
          ).
          IF ev_error = abap_on.
            RETURN.

          ENDIF.

        ENDLOOP.

      WHEN cl_abap_typedescr=>typekind_struct1
        OR cl_abap_typedescr=>typekind_struct2. "structure
        me->build_permissions_instance(
          EXPORTING
            iv_op           = iv_op
            is_step_data    = is_step_data
            is_test_data    = is_test_data
          IMPORTING
            ev_error        = ev_error
          CHANGING
            ct_permissions  = ct_permissions
        ).
        IF ev_error = abap_on.
          RETURN.

        ENDIF.

      WHEN OTHERS.
        me->mo_run_environment->append_log( |Root entity { is_step_data-bus_obj }: Test data not of proper type| ).
        ev_error = abap_on.
        RETURN.

    ENDCASE.

  ENDMETHOD.


  METHOD if_ptf_rap_permissions~group_permissions.
    DATA ls_permissions_grouped TYPE if_ptf_rap_permissions=>ts_permissions_grouped.
    DATA lv_root_entity         TYPE abp_root_entity_name.

    CLEAR et_permissions_grouped.

*   Group permissions by root name because the dynamic EML statement GET PERMISSIONS only work with entities belonging to the same root entity
    LOOP AT it_permissions ASSIGNING FIELD-SYMBOL(<ls_permission>).
*     We have to clear the variable lv_root_entity otherwise it will not get changed
      CLEAR lv_root_entity.

      cl_abap_behv_load=>check_existence(
        EXPORTING
          entity      = <ls_permission>-entity_name
        CHANGING
          root_entity = lv_root_entity
      ).

      IF NOT line_exists( et_permissions_grouped[ entity_name = lv_root_entity ] ).
        CLEAR ls_permissions_grouped.

        ls_permissions_grouped-entity_name = lv_root_entity.
        APPEND <ls_permission> TO ls_permissions_grouped-permissions.

        APPEND ls_permissions_grouped TO et_permissions_grouped.

      ELSE.
        ASSIGN et_permissions_grouped[ entity_name = lv_root_entity ] TO FIELD-SYMBOL(<ls_permissions_grouped>).
        IF sy-subrc = 0.
          APPEND <ls_permission> TO <ls_permissions_grouped>-permissions.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD if_ptf_rap_permissions~handle_permissions_error.
    DATA: lv_message              TYPE string.

    FIELD-SYMBOLS: <fs_field>             TYPE any,
                   <fs_value>             TYPE any.

    CLEAR ev_error.

    IF it_failed IS NOT INITIAL.
      LOOP AT it_failed ASSIGNING FIELD-SYMBOL(<fs_failed_perm>).
        ASSIGN <fs_failed_perm>-entries->* TO FIELD-SYMBOL(<fs_failed_perm_entries>).

        LOOP AT <fs_failed_perm_entries> ASSIGNING FIELD-SYMBOL(<fs_failed_perm_entry>).
          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-fail OF STRUCTURE <fs_failed_perm_entry> TO <fs_field>.
          IF sy-subrc = 0.
            ASSIGN COMPONENT 'CAUSE' OF STRUCTURE <fs_field> TO <fs_value>.
            IF sy-subrc = 0.
              me->mo_run_environment->append_log( |EML Read Permission Technical Error: { <fs_value> }| ).

*             Determine the key values for the error
              lv_message = 'Error Key Fields: '.

              LOOP AT it_components ASSIGNING FIELD-SYMBOL(<fs_component>).
                ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_failed_perm_entry> TO <fs_value>.
                IF sy-subrc = 0.
                  lv_message = |{ lv_message } { <fs_component>-name }: { <fs_value> }|.

                ENDIF.

              ENDLOOP.

              me->mo_run_environment->append_log( lv_message ).

              ev_error = abap_on.

            ENDIF.

          ENDIF.

        ENDLOOP.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD recursive_fill_permissions.
    DATA: lr_instance         TYPE REF TO data,
          lt_child_components TYPE abap_component_tab,
          ls_permission       TYPE abp_behv_permissions,
          lv_name             TYPE cl_abap_behvdescr=>t_typename.

    FIELD-SYMBOLS: <fs_child_test_data_t> TYPE any,
                   <fs_child_test_data>   TYPE any,
                   <fs_instance>          TYPE any.

    CLEAR ev_error.

    LOOP AT it_components ASSIGNING FIELD-SYMBOL(<fs_component>).
*     Skip association names that start with '_*'.
      IF <fs_component>-name CP '_*'.
        CONTINUE.

      ENDIF.

*     Skip %PID
      IF <fs_component>-name = cl_abap_behv=>co_techfield_name-pid.
        CONTINUE.

      ENDIF.

      lv_name = <fs_component>-name.

      CLEAR ls_permission.

      ls_permission-entity_name = lv_name.

*     Validate entity
      me->mo_ptf_rap_validate_tdo->check_entity(
        EXPORTING
          iv_root   = is_step_data-bus_obj
          iv_name   = lv_name
        IMPORTING
          ev_error  = ev_error
      ).
      IF ev_error = abap_on.
        EXIT.

      ENDIF.

      ls_permission-instances = cl_abap_behvdescr=>create_data(
                                      p_name = lv_name
                                      "p_root = is_step_data-bus_obj
                                      "p_sub_name = lv_p_sub_name
                                      p_op = cl_abap_behvdescr=>op_permission
                                      "p_kind = if_abap_behv=>typekind-request
                                      "p_structure = abap_on
                                   ).

      ls_permission-request = cl_abap_behvdescr=>create_data(
                                      p_name = lv_name
                                      "p_root = is_step_data-bus_obj
                                      "p_sub_name = lv_p_sub_name
                                      p_op = cl_abap_behvdescr=>op_permission
                                      p_kind = if_abap_behv=>typekind-request
                                      "p_structure = abap_on
                                   ).

      ls_permission-results = cl_abap_behvdescr=>create_data(
                                      p_name = lv_name
                                      "p_root = is_step_data-bus_obj
                                      "p_sub_name = lv_p_sub_name
                                      p_op = cl_abap_behvdescr=>op_permission
                                      p_kind = if_abap_behv=>typekind-result
                                   ).

      ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_test_data TO <fs_child_test_data_t>.
      IF sy-subrc = 0.
*       Check if test data is itab or structure
        DESCRIBE FIELD <fs_child_test_data_t> TYPE DATA(lv_type).
        CASE lv_type.
          WHEN cl_abap_typedescr=>typekind_table. "itab
            LOOP AT <fs_child_test_data_t> ASSIGNING <fs_child_test_data>.
*             fill_child_permissions
              me->fill_child_permissions(
                EXPORTING
                  iv_op               = iv_op
                  is_parent_instance  = is_parent_instance
                  is_test_data        = <fs_child_test_data>
                  iv_name             = lv_name
                IMPORTING
                  er_instance         = lr_instance
                  et_child_components = lt_child_components
                  ev_error            = ev_error
                CHANGING
                  cs_permission       = ls_permission
              ).

              IF ev_error = abap_on.
                EXIT.

              ENDIF.

              ASSIGN lr_instance->* TO <fs_instance>.

*             recursive fill permissions
              me->recursive_fill_permissions(
                EXPORTING
                  iv_op               = iv_op
                  it_components       = lt_child_components
                  is_step_data        = is_step_data
                  is_test_data        = <fs_child_test_data>
                  is_parent_instance  = <fs_instance>
                IMPORTING
                  ev_error            = ev_error
                CHANGING
                  ct_permissions      = ct_permissions
              ).

            ENDLOOP.

          WHEN OTHERS. "presumably structure
            ASSIGN <fs_child_test_data_t> TO <fs_child_test_data>.

*           fill_child_permissions
            me->fill_child_permissions(
              EXPORTING
                iv_op               = iv_op
                is_parent_instance  = is_parent_instance
                is_test_data        = <fs_child_test_data>
                iv_name             = lv_name
              IMPORTING
                er_instance         = lr_instance
                et_child_components = lt_child_components
                ev_error            = ev_error
              CHANGING
                cs_permission       = ls_permission
            ).

            IF ev_error = abap_on.
              EXIT.

            ENDIF.

            ASSIGN lr_instance->* TO <fs_instance>.

*           recursive fill permissions
            me->recursive_fill_permissions(
              EXPORTING
                iv_op               = iv_op
                it_components       = lt_child_components
                is_step_data        = is_step_data
                is_test_data        = <fs_child_test_data>
                is_parent_instance  = <fs_instance>
              IMPORTING
                ev_error            = ev_error
              CHANGING
                ct_permissions      = ct_permissions
            ).

        ENDCASE.

      ENDIF.

      APPEND ls_permission TO ct_permissions.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
