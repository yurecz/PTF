class CL_PTF_RAP_OPERATIONS definition
  public
  final
  create public .

public section.

  interfaces IF_PTF_RAP_OPERATIONS .

  aliases BUILD_OPERATIONS
    for IF_PTF_RAP_OPERATIONS~BUILD_OPERATIONS .
  aliases CONVERT_TO_OPERATIONS_READ
    for IF_PTF_RAP_OPERATIONS~CONVERT_TO_OPERATIONS_READ .
  aliases FILTER_OPERATIONS
    for IF_PTF_RAP_OPERATIONS~FILTER_OPERATIONS .
  aliases HANDLE_OPERATIONS_ERROR
    for IF_PTF_RAP_OPERATIONS~HANDLE_OPERATIONS_ERROR .

  methods CONSTRUCTOR
    importing
      !IO_RUN_ENVIRONMENT type ref to CL_PTF_RUN .
protected section.
private section.

  data MO_RUN_ENVIRONMENT type ref to CL_PTF_RUN .
  data MO_PTF_RAP_METADATA type ref to IF_PTF_RAP_METADATA .
  data MO_PTF_RAP_VALIDATE_TDO type ref to IF_PTF_RAP_VALIDATE_TDO .
  data MV_SOURCE type STRING .

  methods BUILD_OPERATIONS_INSTANCE
    importing
      !IV_OP type ABP_BEHV_OP
      !IV_INSTANCE_NO type INT4 default 1
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IS_TEST_DATA type DATA
      !IT_PERMISSIONS type ABP_BEHV_PERMISSIONS_TAB
    exporting
      !EV_ERROR type ABAP_BOOL
    changing
      !CT_OPERATIONS type ABP_BEHV_CHANGES_TAB .
  methods RECURSIVE_FILL_ENTRY
    importing
      !IV_OP type ABP_BEHV_OP
      !IV_P_OP_R type ABP_BEHV_OP
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IV_INSTANCE_NO type INT4
      !IV_CID_REF type INT4   ##NEEDED
      !IV_PARTIAL type ABAP_BOOL default ABAP_OFF
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IS_TEST_DATA type DATA
      !IS_P_TEST_DATA type DATA optional
      !IS_PARENT_INSTANCE type DATA optional
      !IT_PERMISSIONS type ABP_BEHV_PERMISSIONS_TAB
    exporting
      !EV_ERROR type ABAP_BOOL
    changing
      !CT_OPERATIONS type ABP_BEHV_CHANGES_TAB
      !CV_CID type INT4 .
  methods FILL_CHILD_ENTRY
    importing
      !IT_PERMISSIONS type ABP_BEHV_PERMISSIONS_TAB
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IS_PARENT_INSTANCE type DATA optional
      !IS_TEST_DATA type DATA
      !IS_P_TEST_DATA type DATA
      !IV_OP type ABP_BEHV_OP
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IV_INSTANCE_NO type INT4
      !IV_CID_REF type INT4
      !IV_CID type INT4
      !IV_PARTIAL type ABAP_BOOL default ABAP_OFF
    exporting
      !ER_INSTANCE type ref to DATA
      !EV_ERROR type ABAP_BOOL
    changing
      !CS_OPERATION type ABP_BEHV_CHANGES .
  methods RECURSIVE_FILL_PARAM
    importing
      !IS_DATA type DATA
      !IV_NAME type STRING optional
    exporting
      !ES_DATA type DATA
      !EV_ERROR type ABAP_BOOL .
  methods CHECK_VALUE_RESULTS
    importing
      !IV_OP type ABP_BEHV_OP
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IV_ACTION type ABP_ACTION_NAME
    returning
      value(RV_HAS_RESULTS) type ABAP_BOOL .
  methods CHECK_IGNORE
    importing
      !IS_TEST_DATA type ANY
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IV_ACTION type CL_ABAP_BEHVDESCR=>T_SUB_NAME
      !IV_ROOT type ABAP_BOOL default ABAP_OFF
    returning
      value(RV_IGNORE) type ABAP_BOOL .
  methods CHECK_IS_DRAFT
    importing
      !IS_TEST_DATA type ANY
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
    returning
      value(RV_IS_DRAFT) type ABAP_BOOL .
  methods CHECK_KEY_EMPTY
    importing
      !IV_OP type ABP_BEHV_OP
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IV_ACTION type CL_ABAP_BEHVDESCR=>T_SUB_NAME optional
      !IS_DYN_ROW type ANY
    exporting
      !EV_ERROR type ABAP_BOOL .
  methods GET_ENTITYNAME
    importing
      !IS_TEST_DATA type ANY
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
    exporting
      !EV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      value(EV_CHILD_ENTITY) type ABAP_BOOL .
  methods GET_ACTION
    importing
      !IS_TEST_DATA type ANY
      !IV_NAME type ABP_ENTITY_NAME
      !IV_ACTION type ABP_ACTION_NAME
    exporting
      !EV_ACTION type ABP_ACTION_NAME
      !EV_CHILD_ACTION type ABAP_BOOL
      !EV_ERROR type ABAP_BOOL .
  methods GET_SOURCE
    importing
      !IS_TEST_DATA type ANY
    returning
      value(RV_SOURCE) type STRING .
  methods COMPARE_CHAR_FIELDS_LENGTHS
    importing
      !IV_OP type ABP_BEHV_OP
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IS_DYN_ROW type ANY
      !IS_TEST_DATA type ANY
      !IV_ROOT type ABAP_BOOL default ABAP_OFF .
  methods FILL_CONTROL_FLAGS
    importing
      !IV_OP type ABP_BEHV_OP
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IS_PERM_RESULT type ANY
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IS_TEST_DATA type ANY
      !IV_ROOT type ABAP_BOOL default ABAP_OFF
    exporting
      !EV_ERROR type ABAP_BOOL
    changing
      !CS_DYN_ROW type ANY .
  methods CHECK_CONTROL_FLAGS
    importing
      !IS_DYN_ROW type ANY
    exporting
      !EV_CHANGED type ABAP_BOOL .
  methods CHECK_OPERATION
    importing
      !IS_TEST_DATA type ANY
      !IS_RESULT type ANY
      !IT_KEY_COMPONENTS type ABAP_COMPONENT_TAB
      !IV_KEY_FULLY_FILLED type ABAP_BOOL default ABAP_ON
    returning
      value(RV_KEEP_OPERATION) type ABAP_BOOL .
  methods RECURSIVE_COMPARE_CHAR_PARAMS
    importing
      !IS_PARAM type ANY
      !IS_TEST_DATA_PARAM type ANY
      !IV_NAME type STRING optional .
  methods COLLECT_KEY_VALUES
    importing
      !IT_KEY_COMPONENTS type ABAP_COMPONENT_TAB
      !IS_DATA type ANY
    returning
      value(RT_KEY_VALUES) type STRING_TABLE .
  methods FILTER_OPERATIONS_INSTANCE
    importing
      !IS_PARENT_INSTANCE type DATA optional
      !IV_P_NAME type PTF_BO optional
      !IV_NAME type PTF_BO
      !IV_ACTION type PTF_ACT
      !IT_OPERATIONS type ABP_BEHV_RETRIEVALS_TAB
    exporting
      !EV_ABORT_FILTER type ABAP_BOOL
      !EV_ERROR type ABAP_BOOL
    changing
      !CT_OPERATIONS_L type ABP_BEHV_RETRIEVALS_TAB
      !CT_OPERATIONS_F type ABP_BEHV_RETRIEVALS_TAB
      !CS_TEST_DATA type DATA .
  methods SET_DRAFT
    importing
      !IV_OP type ABP_BEHV_OP
      !IV_IS_DRAFT type ABAP_BOOL
      !IV_ROOT type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
    exporting
      !EV_ERROR type ABAP_BOOL
    changing
      !CS_DYN_ROW type ANY .
  methods MOVE_OPERATIONS_RESULT
    importing
      !IS_OPERATION type ABP_BEHV_RETRIEVALS
      !IS_RESULT type DATA
      !IV_P_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IV_SUB_NAME type CL_ABAP_BEHVDESCR=>T_SUB_NAME
      !IV_TABIX type SYST-TABIX
    changing
      !CT_OPERATIONS type ABP_BEHV_RETRIEVALS_TAB
      !CS_RESULTS type STANDARD TABLE .
  methods CHECK_RIGHT_OPERATION
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IT_OPERATIONS type ABP_BEHV_CHANGES_TAB
      !IR_OPERATION type ref to ABP_BEHV_CHANGES
      !IV_INSTANCE_NO type INT4
      !IV_CID_REF type INT4
    changing
      !CV_OPERATION_ALREADY_ADDED type ABAP_BOOL .
ENDCLASS.



CLASS CL_PTF_RAP_OPERATIONS IMPLEMENTATION.


  METHOD build_operations_instance.

    DATA: lr_dyn_row        TYPE REF TO data,
          lt_key_components TYPE abap_component_tab,
          ls_operation      TYPE abp_behv_changes,
          lv_p_sub_name     TYPE cl_abap_behvdescr=>t_sub_name,
          lv_p_op_r         TYPE abp_behv_op,
          lv_cid            TYPE i,
          lv_cid_ref        TYPE i,
          lv_error          TYPE abap_bool,
          lv_no_operation   TYPE abap_bool.

    FIELD-SYMBOLS: <fs_operation>   TYPE abp_behv_changes,
                   <fs_perm_result> TYPE any,
                   <fs_dyn_row>     TYPE any,
                   <fs_field>       TYPE any,
                   <fs_instances>   TYPE STANDARD TABLE,
                   <fs_param>       TYPE any,
                   <fs_cid>         TYPE any.

    CLEAR ev_error.

*   Get source of test data (TDC/JSON)
    me->mv_source = me->get_source(
      EXPORTING
        is_test_data = is_test_data
    ).

*   Check if we have ignore flag
    DATA(lv_ignore) = me->check_ignore(
      EXPORTING
        is_test_data  = is_test_data
        iv_name       = is_step_data-bus_obj
        iv_action     = is_step_data-action
        iv_root       = abap_on
    ).

*   Check if we have isDraft flag
    DATA(lv_is_draft) = me->check_is_draft(
      EXPORTING
        is_test_data  = is_test_data
        iv_name       = is_step_data-bus_obj
    ).

*   Get entityname
    me->get_entityname(
      EXPORTING
        is_test_data    = is_test_data
        iv_name         = is_step_data-bus_obj
      IMPORTING
        ev_name         = DATA(lv_name)
        ev_child_entity = DATA(lv_child_entity)
    ).

*   Check if entity name is valid
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

*   Get action
    IF iv_op = if_abap_behv=>op-m-action.
      me->get_action(
        EXPORTING
          is_test_data    = is_test_data
          iv_name         = lv_name
          iv_action       = is_step_data-action
        IMPORTING
          ev_action       = DATA(lv_action)
          ev_child_action = DATA(lv_child_action)
          ev_error        = ev_error
      ).
      IF ev_error = abap_on.
        RETURN.

      ENDIF.

    ENDIF.

*   Log child entity and child action
    IF iv_op = if_abap_behv=>op-m-action AND lv_child_entity = abap_on AND lv_child_action = abap_on.
      me->mo_run_environment->append_log( |Child Entity { lv_name }, action { lv_action }| ).

    ENDIF.

*   Check if operation/action is allowed

    CASE iv_op.
      WHEN if_abap_behv=>op-m-action.
        me->mo_ptf_rap_validate_tdo->check_action(
          EXPORTING
            iv_name   = lv_name     "is_step_data-bus_obj
            iv_action = lv_action   "is_step_data-action
          IMPORTING
            ev_error  = ev_error ).
        IF ev_error = abap_on.
          RETURN.

        ENDIF.

      WHEN OTHERS.
        me->mo_ptf_rap_validate_tdo->check_operation(
          EXPORTING
            iv_op     = iv_op
            iv_name   = is_step_data-bus_obj
            iv_root   = abap_on
          IMPORTING
            ev_error  = lv_error ).
        IF lv_error = abap_on.

          IF lv_ignore = abap_off.
            ev_error = abap_on.
            RETURN.
          ELSE.
            "if json said ignore:true, than an error does not matter
            lv_no_operation = abap_on. "don't build an operation because it will dump
            me->mo_run_environment->append_log( |Keys of entity { is_step_data-bus_obj } will not be passed to child entities| ).
          ENDIF.

        ENDIF.

    ENDCASE.

*   Fill action name if the operation is to execute an action
    CASE iv_op.
      WHEN if_abap_behv=>op-m-action.
        lv_p_sub_name = lv_action. "is_step_data-action
        lv_p_op_r = if_abap_behv=>op-m-action. "For action operation results have action operation

*       Validate params
        me->mo_ptf_rap_validate_tdo->check_params(
          EXPORTING
            iv_name       = lv_name
            iv_p_sub_name = lv_p_sub_name
            is_data       = is_test_data
          IMPORTING
            ev_error      = ev_error
        ).
        IF ev_error = abap_on.
          RETURN.

        ENDIF.

      WHEN OTHERS.
        lv_p_op_r = if_abap_behv=>op-r-read. "For other operations results have read operation

    ENDCASE.

    IF lv_no_operation = abap_off.
*     Generate keys based on existence of %PID
      ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-pid OF STRUCTURE is_test_data TO FIELD-SYMBOL(<fs_pid>).
      IF sy-subrc = 0.
        IF <fs_pid> IS NOT INITIAL.
          DATA(lv_virtual) = abap_on.

        ENDIF.

      ENDIF.

*     Get key fields
      lt_key_components = me->mo_ptf_rap_metadata->get_key_fields( EXPORTING iv_name = is_step_data-bus_obj iv_virtual = lv_virtual ).

*     Build root entity
      ASSIGN it_permissions[ entity_name = lv_name ]-results->* TO <fs_perm_result>. "is_step_data-bus_obj

      IF NOT line_exists( ct_operations[ entity_name = lv_name ] ).
        ls_operation-entity_name  = lv_name. "is_step_data-bus_obj
        ls_operation-sub_name     = lv_p_sub_name.
        ls_operation-instances = cl_abap_behvdescr=>create_data(
                                  p_name      = lv_name "is_step_data-bus_obj
                                  p_sub_name  = lv_p_sub_name
                                  p_op        = iv_op
                                  p_kind      = if_abap_behv=>typekind-import
                               ).

*       Check if we need to value results, there are cases when it can dump if we try to create a result of whose type doesn't exist
        DATA(lv_has_results) = me->check_value_results(
          EXPORTING
            iv_op       = iv_op
            iv_name     = lv_name
            iv_action   = lv_action
        ).

        IF lv_has_results = abap_on.
          ls_operation-results = cl_abap_behvdescr=>create_data(
                                    p_name      = lv_name "is_step_data-bus_obj
                                    p_sub_name  = lv_p_sub_name
                                    p_op        = lv_p_op_r "if_abap_behv=>op-r-read "switched read with action on 05.05.2022 for R_BillingDocumentRequestTP
                                    p_kind      = if_abap_behv=>typekind-result
                                 ).

        ENDIF.

        ls_operation-op = iv_op.

        ASSIGN ls_operation-instances->* TO <fs_instances>.

      ELSE.
        ASSIGN ct_operations[ entity_name = lv_name ] TO <fs_operation>.

        ASSIGN <fs_operation>-instances->* TO <fs_instances>.

      ENDIF.

      CREATE DATA lr_dyn_row LIKE LINE OF <fs_instances>.
      ASSIGN lr_dyn_row->* TO <fs_dyn_row>.

*     Move components 1 by 1 and apply conversion routine where applicable
      me->mo_ptf_rap_validate_tdo->move_test_data(
        EXPORTING
          is_test_data   = is_test_data
          iv_name        = is_step_data-bus_obj
          iv_root        = abap_on
          iv_context     = if_ptf_rap_validate_tdo=>operations
        IMPORTING
          ev_error       = ev_error
        CHANGING
          cs_target_data = <fs_dyn_row> ).
      IF ev_error = abap_on.
        RETURN.

      ENDIF.

*     Check if we have empty key
      me->check_key_empty(
        EXPORTING
          iv_op       = iv_op
          iv_name     = lv_name "is_step_data-bus_obj
          iv_action   = lv_p_sub_name
          is_dyn_row  = <fs_dyn_row>
        IMPORTING
          ev_error    = ev_error ).
      IF ev_error = abap_on.
        RETURN.

      ENDIF.

*     Issue warning if the line is empty
      CASE iv_op.
        WHEN if_abap_behv=>op-m-create.
          IF <fs_dyn_row> IS INITIAL.
            me->mo_run_environment->append_log( |Root entity { is_step_data-bus_obj }: Line is empty| ).

          ENDIF.

      ENDCASE.

*     Add params in case of action
      IF lv_ignore = abap_off.
        IF iv_op = if_abap_behv=>op-m-action.
          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-param OF STRUCTURE <fs_dyn_row> TO <fs_param>.
          IF sy-subrc = 0.
            ASSIGN COMPONENT '_PARAMS' OF STRUCTURE is_test_data TO <fs_field>.
            IF sy-subrc = 0.
              me->recursive_fill_param(
                EXPORTING
                  is_data   = <fs_field>
                IMPORTING
                  es_data   = <fs_param>
                  ev_error  = ev_error ).
              IF ev_error = abap_on.
                RETURN.

              ENDIF.

            ENDIF.

          ENDIF.

        ENDIF.

      ENDIF.

*     Compare char field lengths
      me->compare_char_fields_lengths(
        EXPORTING
          iv_op         = iv_op
          iv_name       = is_step_data-bus_obj
          is_dyn_row    = <fs_dyn_row>
          is_test_data  = is_test_data
          iv_root       = abap_on
      ).

*     Assign %CID to root entity for create or action
      CASE iv_op.
        WHEN if_abap_behv=>op-m-create
          OR if_abap_behv=>op-m-action.
          lv_cid = 1.

          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-cid OF STRUCTURE <fs_dyn_row> TO <fs_cid>.
          IF sy-subrc = 0.
            <fs_cid> = |C{ is_step_data-step_number }{ iv_instance_no }{ lv_cid }|.

          ENDIF.

      ENDCASE.

*     Assign %IS_DRAFT to root entity for create / change / delete action
      me->set_draft(
        EXPORTING
          iv_op       = iv_op
          iv_is_draft = lv_is_draft
          iv_root     = is_step_data-bus_obj
          iv_name     = lv_name
        IMPORTING
          ev_error    = ev_error
        CHANGING
          cs_dyn_row  = <fs_dyn_row> ).
      IF ev_error = abap_on.
        RETURN.

      ENDIF.

      me->fill_control_flags(
        EXPORTING
          iv_op           = iv_op
          iv_name         = is_step_data-bus_obj
          is_perm_result  = <fs_perm_result>
          is_step_data    = is_step_data
          is_test_data    = is_test_data
          iv_root         = abap_on
        IMPORTING
          ev_error        = ev_error   "might be changed to true (by child logic) at the end of this method, but will never be changed to false after this point
        CHANGING
          cs_dyn_row      = <fs_dyn_row>
      ).
      IF lv_ignore = abap_on.
        IF ev_error = abap_on.  "Possible reasons: Mandatory field is empty. Or: Field has a value but it's also flagged in _INITIALS.
          CLEAR ev_error.
        ENDIF.
      ENDIF.

      APPEND <fs_dyn_row> TO <fs_instances>.

*     Check flags and set ignore to true if no flag has been changed

      me->check_control_flags(
        EXPORTING
          is_dyn_row    = <fs_dyn_row>
        IMPORTING
          ev_changed    = DATA(lv_changed)
      ).

      IF lv_changed = abap_off.   "toDo: skip logging if lv_ignore is already true
        me->mo_run_environment->append_log( |Root Entity { is_step_data-bus_obj }: operation ignored due to no field control flags| ).  "even if ignore:true was not set in JSON for this root entity
        lv_ignore = abap_on.
      ENDIF.

      IF lv_ignore = abap_off.
*       Log the keys of root entity
        CASE iv_op.
          WHEN if_abap_behv=>op-m-create
            OR if_abap_behv=>op-m-update
            OR if_abap_behv=>op-m-delete.
            DATA(lt_key_values) = me->collect_key_values(
                                    EXPORTING
                                      it_key_components = lt_key_components
                                      is_data           = <fs_dyn_row> ).

            IF lt_key_values IS NOT INITIAL.
              me->mo_run_environment->append_log( |Root Entity { is_step_data-bus_obj } Key Values:| ).
              LOOP AT lt_key_values ASSIGNING FIELD-SYMBOL(<fs_key_values>).
                me->mo_run_environment->append_log( |{ <fs_key_values> }| ).

              ENDLOOP.

            ENDIF.

        ENDCASE.

        IF NOT line_exists( ct_operations[ entity_name = lv_name ] ).
          APPEND ls_operation TO ct_operations.

        ENDIF.

      ENDIF.


*     Add child entities
*     Recursive fill entry

*     Pass current %CID as number to next %CID_REF as number
      CASE iv_op.
        WHEN if_abap_behv=>op-m-create
          OR if_abap_behv=>op-m-action.
          lv_cid_ref = lv_cid.

      ENDCASE.

      me->recursive_fill_entry(
        EXPORTING
          iv_op               = iv_op
          iv_p_op_r           = lv_p_op_r
          iv_name             = is_step_data-bus_obj
          iv_instance_no      = iv_instance_no
          iv_cid_ref          = lv_cid_ref
          iv_partial          = lv_ignore
          is_step_data        = is_step_data
          is_test_data        = is_test_data
          is_parent_instance  = <fs_dyn_row>
          it_permissions      = it_permissions
        IMPORTING
          ev_error            = lv_error
        CHANGING
          ct_operations       = ct_operations
          cv_cid              = lv_cid
      ).

    ELSE.
      me->recursive_fill_entry(
        EXPORTING
          iv_op               = iv_op
          iv_p_op_r           = lv_p_op_r
          iv_name             = is_step_data-bus_obj
          iv_instance_no      = iv_instance_no
          iv_cid_ref          = lv_cid_ref
          iv_partial          = lv_ignore
          is_step_data        = is_step_data
          is_test_data        = is_test_data
          "is_parent_instance  = <fs_dyn_row>
          it_permissions      = it_permissions
        IMPORTING
          ev_error            = lv_error
        CHANGING
          ct_operations       = ct_operations
          cv_cid              = lv_cid
      ).

    ENDIF.

    IF lv_error = abap_on.      "... and if Lv_error EQ false, Ev_error stays like it was set by fill_control_flags()
      ev_error = abap_on.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD check_control_flags.
    DATA: lo_structdescr          TYPE REF TO cl_abap_structdescr,
          lt_components           TYPE abap_component_tab.

    FIELD-SYMBOLS: <fs_control>         TYPE any,
                   <fs_flag_control>    TYPE any,
                   <fs_component>       TYPE abap_componentdescr.

    CLEAR ev_changed.

    ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-control OF STRUCTURE is_dyn_row TO <fs_control>.
    IF sy-subrc = 0.
      lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_control> ).
      lt_components = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

      LOOP AT lt_components ASSIGNING <fs_component>.
        ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_control> TO <fs_flag_control>.
        IF sy-subrc = 0.
          IF <fs_flag_control> = cl_abap_behv=>flag_changed.
            ev_changed = abap_on.
            EXIT.

          ENDIF.

        ENDIF.

      ENDLOOP.

    ELSE.
      ev_changed = abap_on. "Not all actions have %control

    ENDIF.

  ENDMETHOD.


  METHOD check_ignore.
*   If action is RETRIEVE_ALL then ignore is always false even if true in JSON
    IF iv_action = 'RETRIEVE_ALL'.
      rv_ignore = abap_off.
      RETURN.

    ENDIF.

    ASSIGN COMPONENT '_IGNORE' OF STRUCTURE is_test_data TO FIELD-SYMBOL(<fs_field>).
    IF sy-subrc = 0.
      IF <fs_field> = abap_on.
        rv_ignore = abap_on.

        CASE iv_root.
          WHEN abap_off.
            me->mo_run_environment->append_log( |Entity { iv_name } is ignored| ).

          WHEN abap_on.
            me->mo_run_environment->append_log( |Root entity { iv_name } is ignored| ).

        ENDCASE.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD check_is_draft.
    ASSIGN COMPONENT '_IS_DRAFT' OF STRUCTURE is_test_data TO FIELD-SYMBOL(<fs_field>).
    IF sy-subrc = 0.
      IF <fs_field> = abap_on.
        rv_is_draft = abap_on.
        me->mo_run_environment->append_log( |Root entity { iv_name }: Property isDraft is set in step input| ).

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD check_key_empty.
    DATA: lv_key_empty TYPE abap_bool.

    FIELD-SYMBOLS: <fs_value> TYPE any.

    CLEAR ev_error.

    CASE iv_op.
      WHEN if_abap_behv=>op-m-update
        OR if_abap_behv=>op-m-delete
        OR if_abap_behv=>op-r-read.
        lv_key_empty = me->mo_ptf_rap_validate_tdo->check_key_empty( iv_name = iv_name
                                                                     is_data = is_dyn_row ).

*       Check if we have %PID
        IF lv_key_empty = abap_on.
          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-pid OF STRUCTURE is_dyn_row TO <fs_value>.
          IF sy-subrc = 0.
            IF <fs_value> IS NOT INITIAL.
              lv_key_empty = abap_off.

            ENDIF.

          ENDIF.

        ENDIF.

        IF lv_key_empty = abap_on.
          me->mo_run_environment->append_log( |Root entity { iv_name }: Key is empty| ).
          ev_error = abap_on.
          RETURN.

        ENDIF.

      WHEN if_abap_behv=>op-m-action.
*       Check if action is not static
        cl_abap_behv_load=>get_load(
          EXPORTING
            entity    = iv_name
            all       = abap_off
          IMPORTING
            actions   = DATA(lt_actions)
        ).
        IF lt_actions[ name = iv_action ]-properties-is_static = abap_off.
          lv_key_empty = me->mo_ptf_rap_validate_tdo->check_key_empty( iv_name = iv_name
                                                                       is_data = is_dyn_row ).

*         Check if we have %PID
          IF lv_key_empty = abap_on.
            ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-pid OF STRUCTURE is_dyn_row TO <fs_value>.
            IF sy-subrc = 0.
              IF <fs_value> IS NOT INITIAL.
                lv_key_empty = abap_off.

              ENDIF.

            ENDIF.

          ENDIF.

          IF lv_key_empty = abap_on.
            me->mo_run_environment->append_log( |Root entity { iv_name }, instance action { iv_action }: Key is empty| ).
            ev_error = abap_on.
            RETURN.

          ENDIF.

        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD check_operation.
    rv_keep_operation = abap_on.

    LOOP AT it_key_components ASSIGNING FIELD-SYMBOL(<fs_key_component>).
      DATA(lv_tabix) = sy-tabix.

*     Skip the check of the last key component if the key is not fully mentioned
      IF lv_tabix = lines( it_key_components ) AND iv_key_fully_filled = abap_off.
        CONTINUE.

      ENDIF.

      ASSIGN COMPONENT <fs_key_component>-name OF STRUCTURE is_test_data TO FIELD-SYMBOL(<fs_test_field>).
      IF sy-subrc = 0.
        ASSIGN COMPONENT <fs_key_component>-name OF STRUCTURE is_result TO FIELD-SYMBOL(<fs_result_field>).
        IF sy-subrc = 0.
*          IF <fs_test_field> IS NOT INITIAL. "In case of item filled with character fields -> it can become initial after conversion
            IF <fs_test_field> <> <fs_result_field>.
              rv_keep_operation = abap_off.
              EXIT.

            ENDIF.

*          ENDIF.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD check_right_operation.

    TYPES: BEGIN OF ts_cid_ref_mapping,
             entity_name TYPE abp_entity_name,
             sub_name    TYPE abp_entity_name,
             cid         TYPE abp_behv_cid,
           END OF ts_cid_ref_mapping.

    TYPES tt_cid_ref_mapping TYPE STANDARD TABLE OF ts_cid_ref_mapping WITH DEFAULT KEY.

    DATA lt_cid_ref_mapping TYPE tt_cid_ref_mapping.
*    DATA lv_is_op_to_be_changed TYPE abap_bool.

    FIELD-SYMBOLS <lt_instances>      TYPE STANDARD TABLE.
    FIELD-SYMBOLS <lt_instances_ref>  TYPE STANDARD TABLE.
    FIELD-SYMBOLS <ls_instance>       TYPE any.
    FIELD-SYMBOLS <ls_instance_ref>   TYPE any.
    FIELD-SYMBOLS <ls_target_ref>     TYPE any.
    FIELD-SYMBOLS <ls_operation>      TYPE abp_behv_changes.
    FIELD-SYMBOLS <ls_operation_ref>  TYPE abp_behv_changes.
    FIELD-SYMBOLS <lv_cid>            TYPE any.
    FIELD-SYMBOLS <lv_cid_ref>        TYPE any.

*   Check if the referenced CIDs of the current selected operation ir_operation and the current referenced CID iv_cid_ref belong to the same combo of Entity Name / Sub Name

    DATA(lv_cid_ref) = |C{ is_step_data-step_number }{ iv_instance_no }{ iv_cid_ref }|.

    ASSIGN ir_operation->instances->* TO <lt_instances>.
    IF sy-subrc = 0.

      LOOP AT it_operations ASSIGNING <ls_operation_ref>.
        ASSIGN <ls_operation_ref>-instances->* TO <lt_instances_ref>.
        IF sy-subrc = 0.
          "loop over operations that are already there
          LOOP AT <lt_instances_ref> ASSIGNING <ls_instance_ref>.
            CASE <ls_operation_ref>-op.

              WHEN if_abap_behv=>op-m-create.
                ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-cid OF STRUCTURE <ls_instance_ref> TO <lv_cid>.
                IF sy-subrc = 0.

                  "loop over instances of current operation
                  LOOP AT <lt_instances> ASSIGNING <ls_instance>.
*                   Get the Entity Name / Sub Name combo of the referenced CIDs of the current selected operation
                    ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-cid_ref OF STRUCTURE <ls_instance> TO <lv_cid_ref>.
                    IF sy-subrc = 0.
                      IF <lv_cid_ref> = <lv_cid>.
                        APPEND VALUE #( entity_name = <ls_operation_ref>-entity_name sub_name = <ls_operation_ref>-sub_name cid = <lv_cid> ) TO lt_cid_ref_mapping.
                      ENDIF.
                    ENDIF.
                  ENDLOOP.

*                 The ref cid of the current instance target that we want to add to an operation
                  IF <lv_cid> = lv_cid_ref.
                    APPEND VALUE #( entity_name = <ls_operation_ref>-entity_name sub_name = <ls_operation_ref>-sub_name cid = <lv_cid> ) TO lt_cid_ref_mapping.
                  ENDIF.

                ENDIF.

              WHEN if_abap_behv=>op-m-create_ba.
                ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-target OF STRUCTURE <ls_instance_ref> TO FIELD-SYMBOL(<lt_target_ref>).
                IF sy-subrc = 0.
                  LOOP AT <lt_target_ref> ASSIGNING <ls_target_ref>.
                    ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-cid OF STRUCTURE <ls_target_ref> TO <lv_cid>.
                    IF sy-subrc = 0.

                      LOOP AT <lt_instances> ASSIGNING <ls_instance>.
*                       Get the Entity Name / Sub Name combo of the referenced CIDs of the current selected operation
                        ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-cid_ref OF STRUCTURE <ls_instance> TO <lv_cid_ref>.
                        IF sy-subrc = 0.
                          IF <lv_cid_ref> = <lv_cid>.
                            APPEND VALUE #( entity_name = <ls_operation_ref>-entity_name sub_name = <ls_operation_ref>-sub_name cid = <lv_cid> ) TO lt_cid_ref_mapping.
                          ENDIF.
                        ENDIF.
                      ENDLOOP.

*                     The ref cid of the current instance target that we want to add to an operation
                      IF <lv_cid> = lv_cid_ref.
                        APPEND VALUE #( entity_name = <ls_operation_ref>-entity_name sub_name = <ls_operation_ref>-sub_name cid = <lv_cid> ) TO lt_cid_ref_mapping.
                      ENDIF.

                    ENDIF.

                  ENDLOOP.

                ENDIF.

              ENDCASE.

          ENDLOOP.

        ENDIF.

      ENDLOOP.

    ENDIF.


*   Now we check the consistency of the mapped combos; if we do not get consistency then we need to make a new operation
    SORT lt_cid_ref_mapping BY entity_name sub_name.
    DELETE ADJACENT DUPLICATES FROM lt_cid_ref_mapping COMPARING entity_name sub_name.

    IF lines( lt_cid_ref_mapping ) > 1. "We have more than one parent
**     Check to see if there is some operation having at least one instance with the same ref cid
**     And choose that operation
*      LOOP AT it_operations ASSIGNING <ls_operation> WHERE entity_name = cr_operation->entity_name AND sub_name = cr_operation->sub_name.
*        ASSIGN <ls_operation_ref>-instances->* TO <lt_instances>.
*        IF sy-subrc = 0.
*          LOOP AT <lt_instances> ASSIGNING <ls_instance>.
*            ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-cid_ref OF STRUCTURE <ls_instance> TO <lv_cid_ref>.
*            IF sy-subrc = 0.
*              IF <lv_cid_ref> = lv_cid_ref.
*                GET REFERENCE OF <ls_operation> INTO cr_operation.
*                lv_is_op_to_be_changed = abap_on.
*                EXIT.
*              ENDIF.
*
*            ENDIF.
*
*          ENDLOOP.
*
*          IF lv_is_op_to_be_changed = abap_on.
*            EXIT.
*          ENDIF.
*
*        ENDIF.
*
*      ENDLOOP.
*
*      IF lv_is_op_to_be_changed = abap_on.
*        RETURN.
*      ENDIF.

*     We need a new operation
      cv_operation_already_added = abap_off.

    ENDIF.

  ENDMETHOD.


  METHOD check_value_results.
    CASE iv_op.
      WHEN if_abap_behv=>op-m-action.
        cl_abap_behv_load=>get_load(
          EXPORTING
            entity  = iv_name
          IMPORTING
            actions = DATA(lt_actions)
        ).

        IF line_exists( lt_actions[ owner_entity = iv_name name = iv_action ] ).
          IF lt_actions[ owner_entity = iv_name name = iv_action ]-result_type IS NOT INITIAL.
            rv_has_results = abap_on.

          ENDIF.

        ENDIF.

      WHEN OTHERS.
        rv_has_results = abap_on.

    ENDCASE.

  ENDMETHOD.


  METHOD collect_key_values.
    DATA: lv_key_values TYPE string,
          lv_is_first   TYPE abap_bool VALUE abap_on.

    FIELD-SYMBOLS: <fs_field> TYPE any.

    LOOP AT it_key_components ASSIGNING FIELD-SYMBOL(<fs_component>).
      ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_data TO <fs_field>.
      IF sy-subrc = 0.
        IF <fs_field> IS NOT INITIAL.
          IF lv_is_first = abap_on.
            lv_key_values = |Key: { <fs_component>-name }, Value: { <fs_field> }|.
            lv_is_first = abap_off.

          ELSE.
            IF strlen( lv_key_values ) + strlen( |, Key: { <fs_component>-name }, Value: { <fs_field> }| ) > 127  ##NUMBER_OK.
              APPEND |{ lv_key_values },| TO rt_key_values.

              lv_key_values = |Key: { <fs_component>-name }, Value: { <fs_field> }|.

            ELSE.
              lv_key_values = |{ lv_key_values }, Key: { <fs_component>-name }, Value: { <fs_field> }|.

            ENDIF.

          ENDIF.

        ENDIF.

      ENDIF.

    ENDLOOP.

    IF lv_key_values IS NOT INITIAL.
      APPEND lv_key_values TO rt_key_values.

    ENDIF.

  ENDMETHOD.


  METHOD compare_char_fields_lengths.
    DATA: lo_structdescr TYPE REF TO cl_abap_structdescr,
          lv_typekind    TYPE abap_typekind,
          lv_message     TYPE string.

    FIELD-SYMBOLS: <fs_component>       TYPE abap_componentdescr,
                   <fs_key_component>   TYPE abap_componentdescr,
                   <fs_field>           TYPE any,
                   <fs_value>           TYPE any,
                   <fs_test_data_field> TYPE any.

    lo_structdescr ?= cl_abap_structdescr=>describe_by_data( is_dyn_row ).
    DATA(lt_components) = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

*   Get key fields
    DATA(lt_key_components) = me->mo_ptf_rap_metadata->get_key_fields( EXPORTING iv_name = iv_name ). "is_step_data-bus_obj

    CASE iv_root.
      WHEN abap_on.
        LOOP AT lt_components ASSIGNING <fs_component>.
          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_dyn_row TO <fs_field>.
          IF sy-subrc = 0.
            CASE <fs_component>-name.
              WHEN cl_abap_behv=>co_techfield_name-param.
                ASSIGN COMPONENT '_PARAMS' OF STRUCTURE is_test_data TO <fs_test_data_field>.
                IF sy-subrc = 0.
                  me->recursive_compare_char_params(
                    EXPORTING
                      is_param            = <fs_field>
                      is_test_data_param  = <fs_test_data_field>
                  ).

                ENDIF.

              WHEN OTHERS.
                ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_test_data TO <fs_test_data_field>.
                IF sy-subrc = 0.
                  IF <fs_field> IS NOT INITIAL.
                    DESCRIBE FIELD <fs_field> TYPE lv_typekind.
                    CASE lv_typekind.
                      WHEN cl_abap_typedescr=>typekind_char
                        OR cl_abap_typedescr=>typekind_num.
                        IF strlen( <fs_test_data_field> ) > strlen( <fs_field> ).
                          me->mo_run_environment->append_log( |Root Entity Field { <fs_component>-name } trimmed: { <fs_field> }, original: { <fs_test_data_field> } !| ).

                          CASE iv_op.
                            WHEN if_abap_behv=>op-r-read.
*                             Determine the key values for the error
                              lv_message = 'Warning Key Fields: '.

                              LOOP AT lt_key_components ASSIGNING <fs_key_component>.
                                ASSIGN COMPONENT <fs_key_component>-name OF STRUCTURE is_dyn_row TO <fs_value>.
                                IF sy-subrc = 0.
                                  lv_message = |{ lv_message } { <fs_key_component>-name }: { <fs_value> }|.

                                ENDIF.

                              ENDLOOP.

                              me->mo_run_environment->append_log( lv_message ).

                          ENDCASE.

                        ENDIF.

                    ENDCASE.

                  ENDIF.

                ENDIF.

            ENDCASE.

          ENDIF.

        ENDLOOP.

      WHEN abap_off.
        LOOP AT lt_components ASSIGNING <fs_component>.
          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_dyn_row TO <fs_field>.
          IF sy-subrc = 0.
            ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_test_data TO <fs_test_data_field>.
            IF sy-subrc = 0.
              IF <fs_field> IS NOT INITIAL.
                DESCRIBE FIELD <fs_field> TYPE lv_typekind.
                CASE lv_typekind.
                  WHEN cl_abap_typedescr=>typekind_char
                    OR cl_abap_typedescr=>typekind_num.
                    IF strlen( <fs_test_data_field> ) > strlen( <fs_field> ).
                      me->mo_run_environment->append_log( |Child Entity Field { <fs_component>-name } trimmed: { <fs_field> }, original: { <fs_test_data_field> } !| ).

                      CASE iv_op.
                        WHEN if_abap_behv=>op-r-read.
*                         Determine the key values for the error
                          lv_message = 'Warning Key Fields: '.

                          LOOP AT lt_key_components ASSIGNING <fs_key_component>.
                            ASSIGN COMPONENT <fs_key_component>-name OF STRUCTURE is_dyn_row TO <fs_value>.
                            IF sy-subrc = 0.
                              lv_message = |{ lv_message } { <fs_key_component>-name }: { <fs_value> }|.

                            ENDIF.

                          ENDLOOP.

                          me->mo_run_environment->append_log( lv_message ).

                      ENDCASE.

                    ENDIF.

                ENDCASE.

              ENDIF.

            ENDIF.

          ENDIF.

        ENDLOOP.

    ENDCASE.

  ENDMETHOD.


  METHOD constructor.
    me->mo_run_environment      = io_run_environment.
    me->mo_ptf_rap_metadata     = NEW cl_ptf_rap_metadata( ).
    me->mo_ptf_rap_validate_tdo = NEW cl_ptf_rap_validate_tdo( io_run_environment ).

  ENDMETHOD.


  METHOD fill_child_entry.
    DATA: lr_child_row      TYPE REF TO data,
          lr_dyn_row        TYPE REF TO data,
          lr_comp_row       TYPE REF TO data,
          lr_parent_tdo_row TYPE REF TO data,
          lt_key_values     TYPE string_table,
          lv_key_empty      TYPE abap_bool.

    FIELD-SYMBOLS: <fs_instances>      TYPE STANDARD TABLE,
                   <fs_results>        TYPE STANDARD TABLE,
                   <fs_child_row>      TYPE any,
                   <fs_cid_ref>        TYPE any,
                   <fs_target>         TYPE STANDARD TABLE,
                   <fs_dyn_row>        TYPE any,
                   <fs_comp_row>       TYPE any,
                   <fs_parent_tdo_row> TYPE any,
                   <fs_component>      TYPE abap_componentdescr,
                   <fs_key_field>      TYPE any,
                   <fs_key_values>     TYPE string,
                   <fs_field>          TYPE any,
                   <fs_cid>            TYPE any,
                   <fs_perm_result>    TYPE any.

    CLEAR: er_instance, ev_error.

*   Check if we have ignore flag
    DATA(lv_ignore) = me->check_ignore(
      EXPORTING
        is_test_data  = is_test_data
        iv_name       = iv_name
        iv_action     = is_step_data-action
    ).

*   Check if operation is allowed
    IF lv_ignore = abap_off.
      me->mo_ptf_rap_validate_tdo->check_operation(
        EXPORTING
          iv_op   = iv_op
          iv_name = iv_name
        IMPORTING
          ev_error = ev_error ).
      IF ev_error = abap_on.
        RETURN.

      ENDIF.

    ENDIF.

*   Generate keys based on existence of %PID
    ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-pid OF STRUCTURE is_parent_instance TO FIELD-SYMBOL(<fs_pid>).
    IF sy-subrc = 0.
      IF <fs_pid> IS NOT INITIAL.
        DATA(lv_virtual) = abap_on.

      ENDIF.

    ENDIF.

*   Get key fields
    DATA(lt_key_components) = me->mo_ptf_rap_metadata->get_key_fields( EXPORTING iv_name = iv_name iv_virtual = lv_virtual ).

    ASSIGN it_permissions[ entity_name = iv_name ]-results->* TO <fs_perm_result>.
    IF sy-subrc = 0. "We have child entity test data
      ASSIGN cs_operation-instances->* TO <fs_instances>.

      CASE iv_op.
        WHEN if_abap_behv=>op-m-create.
          CREATE DATA lr_child_row LIKE LINE OF <fs_instances>.
          ASSIGN lr_child_row->* TO <fs_child_row>.

*         Move the key fields
          <fs_child_row> = CORRESPONDING #( is_test_data ).

*         Assign %CID_REF to child entity for create
          IF iv_partial = abap_off.
            CASE iv_op.
              WHEN if_abap_behv=>op-m-create.
                ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-cid_ref OF STRUCTURE <fs_child_row> TO <fs_cid_ref>.
                IF sy-subrc = 0.
                  <fs_cid_ref> = |C{ is_step_data-step_number }{ iv_instance_no }{ iv_cid_ref }|.

                ENDIF.

            ENDCASE.

          ENDIF.

*         Move the test data to the %TARGET
          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-target OF STRUCTURE <fs_child_row> TO <fs_target>.

          CREATE DATA lr_dyn_row LIKE LINE OF <fs_target>.
          ASSIGN lr_dyn_row->* TO <fs_dyn_row>.

        WHEN if_abap_behv=>op-r-read.
          CREATE DATA lr_dyn_row LIKE LINE OF <fs_instances>.
          ASSIGN lr_dyn_row->* TO <fs_dyn_row>.

          ASSIGN cs_operation-results->* TO <fs_results>.

*         We use this object for comparing character lengths also for the additional key(s) of the child node
          CREATE DATA lr_comp_row LIKE LINE OF <fs_results>.
          ASSIGN lr_comp_row->* TO <fs_comp_row>.

*         We use this object instead of is_parent_instance becaue is_parent_instance has only the partial keys of the parent
          CREATE DATA lr_parent_tdo_row LIKE LINE OF <fs_results>.
          ASSIGN lr_parent_tdo_row->* TO <fs_parent_tdo_row>.

        WHEN OTHERS.
          CREATE DATA lr_dyn_row LIKE LINE OF <fs_instances>.
          ASSIGN lr_dyn_row->* TO <fs_dyn_row>.

      ENDCASE.

*     Move components 1 by 1 and apply conversion routine where applicable
      me->mo_ptf_rap_validate_tdo->move_test_data(
        EXPORTING
          is_test_data   = is_test_data
          iv_name        = iv_name
          iv_context     = if_ptf_rap_validate_tdo=>operations
        IMPORTING
          ev_error       = ev_error
        CHANGING
          cs_target_data = <fs_dyn_row> ).
      IF ev_error = abap_on.
        RETURN.

      ENDIF.

*     Data for comparison and parent data
      CASE iv_op.
        WHEN if_abap_behv=>op-r-read.
          me->mo_ptf_rap_validate_tdo->move_test_data(
            EXPORTING
              is_test_data   = is_test_data
              iv_name        = iv_name
              iv_compare     = abap_on
              iv_context     = if_ptf_rap_validate_tdo=>operations
            IMPORTING
              ev_error       = ev_error
            CHANGING
              cs_target_data = <fs_comp_row> ).
          IF ev_error = abap_on.
            RETURN.

          ENDIF.

*         Move the specific key field from the parent tdo that cannot be found in is_parent_instance in case of READ
          me->mo_ptf_rap_validate_tdo->move_test_data(
            EXPORTING
              is_test_data   = is_p_test_data
              iv_name        = iv_name
              iv_compare     = abap_on
              iv_context     = if_ptf_rap_validate_tdo=>operations
            IMPORTING
              ev_error       = ev_error
            CHANGING
              cs_target_data = <fs_parent_tdo_row> ).
          IF ev_error = abap_on.
            RETURN.

          ENDIF.

        WHEN if_abap_behv=>op-m-create.
*         Move the %PID from the parent tdo that cannot be found in is_parent_instance in case of CREATE
          me->mo_ptf_rap_validate_tdo->move_test_data(
            EXPORTING
              is_test_data   = is_p_test_data
              iv_name        = iv_name
              iv_context     = if_ptf_rap_validate_tdo=>operations
            IMPORTING
              ev_error       = ev_error
            CHANGING
              cs_target_data = <fs_child_row> ).
          IF ev_error = abap_on.
            RETURN.

          ENDIF.

      ENDCASE.

*     Issue warning if the line is empty
      CASE iv_op.
        WHEN if_abap_behv=>op-m-create.
          IF <fs_dyn_row> IS INITIAL.
            me->mo_run_environment->append_log( |Child entity { iv_name }: Line is empty| ).

          ENDIF.

      ENDCASE.

*     Check if we have empty key
      CASE iv_op.
        WHEN if_abap_behv=>op-m-update
          OR if_abap_behv=>op-m-delete.
          lv_key_empty = me->mo_ptf_rap_validate_tdo->check_key_empty( iv_name = iv_name
                                                                       is_data = <fs_dyn_row> ).

          IF lv_key_empty = abap_on.
            me->mo_run_environment->append_log( |Child entity { iv_name }: Key is empty| ).
            ev_error = abap_on.
            RETURN.

          ENDIF.

      ENDCASE.

*     Move the key fields from parent
      CASE iv_op.
        WHEN if_abap_behv=>op-m-create.
          IF is_parent_instance IS SUPPLIED.
            LOOP AT lt_key_components ASSIGNING <fs_component>.
              ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_parent_instance TO <fs_key_field>.
              IF sy-subrc = 0.
                IF NOT <fs_key_field> IS INITIAL.
                  ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_child_row> TO <fs_field>.
                  IF sy-subrc = 0.
                    <fs_field> = <fs_key_field>.

                  ENDIF.

                  ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_dyn_row> TO <fs_field>.
                  IF sy-subrc = 0.
                    <fs_field> = <fs_key_field>.

                  ENDIF.

                ENDIF.

              ENDIF.

            ENDLOOP.

          ENDIF.

        WHEN if_abap_behv=>op-m-update
          OR if_abap_behv=>op-m-delete.
*         Move the key fields from parent
          IF is_parent_instance IS SUPPLIED.
            LOOP AT lt_key_components ASSIGNING <fs_component>.
              ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_parent_instance TO <fs_key_field>.
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

        WHEN if_abap_behv=>op-r-read.
*         Move the key fields from parent
          IF is_parent_instance IS SUPPLIED AND <fs_parent_tdo_row> IS ASSIGNED.
            LOOP AT lt_key_components ASSIGNING <fs_component>.
              ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_parent_instance TO <fs_key_field>.
              IF sy-subrc = 0.
                IF NOT <fs_key_field> IS INITIAL.
                  ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_dyn_row> TO <fs_field>.
                  IF sy-subrc = 0.
                    <fs_field> = <fs_key_field>.

                  ENDIF.

                  ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_comp_row> TO <fs_field>.
                  IF sy-subrc = 0.
                    <fs_field> = <fs_key_field>.

                  ENDIF.

                ENDIF.

              ELSE.
                ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_parent_tdo_row> TO <fs_key_field>.
                IF sy-subrc = 0.
                  IF NOT <fs_key_field> IS INITIAL.
                    ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_dyn_row> TO <fs_field>.
                    IF sy-subrc = 0.
                      <fs_field> = <fs_key_field>.

                    ENDIF.

                    ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_comp_row> TO <fs_field>.
                    IF sy-subrc = 0.
                      <fs_field> = <fs_key_field>.

                    ENDIF.

                  ENDIF.

                ENDIF.

              ENDIF.

            ENDLOOP.

          ENDIF.

      ENDCASE.

*     Check if we have empty key
      CASE iv_op.
        WHEN if_abap_behv=>op-r-read.
          lv_key_empty = me->mo_ptf_rap_validate_tdo->check_key_empty( iv_name = iv_name
                                                                       is_data = <fs_comp_row> ).

          IF lv_key_empty = abap_on.
            me->mo_run_environment->append_log( |Child entity { iv_name }: Key is empty| ).
            ev_error = abap_on.
            RETURN.

          ENDIF.

      ENDCASE.

*     Compare char field lengths
      CASE iv_op.
        WHEN if_abap_behv=>op-r-read.
          me->compare_char_fields_lengths(
            EXPORTING
              iv_op         = iv_op
              iv_name       = iv_name
              is_dyn_row    = <fs_comp_row>
              is_test_data  = is_test_data
          ).

        WHEN OTHERS.
          me->compare_char_fields_lengths(
            EXPORTING
              iv_op         = iv_op
              iv_name       = iv_name
              is_dyn_row    = <fs_dyn_row>
              is_test_data  = is_test_data
          ).

      ENDCASE.

*     Assign %CID to child entity for create
      CASE iv_op.
        WHEN if_abap_behv=>op-m-create.
          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-cid OF STRUCTURE <fs_dyn_row> TO <fs_cid>.
          IF sy-subrc = 0.
            <fs_cid> = |C{ is_step_data-step_number }{ iv_instance_no }{ iv_cid }|.

          ENDIF.

      ENDCASE.

      me->fill_control_flags(
        EXPORTING
          iv_op           = iv_op
          iv_name         = iv_name
          is_perm_result  = <fs_perm_result>
          is_step_data    = is_step_data
          is_test_data    = is_test_data
        IMPORTING
          ev_error        = ev_error
        CHANGING
          cs_dyn_row      = <fs_dyn_row>
      ).

      GET REFERENCE OF <fs_dyn_row> INTO er_instance.

*     Check flags and set ignore to true if no flag has been changed
      me->check_control_flags(
        EXPORTING
          is_dyn_row    = <fs_dyn_row>
        IMPORTING
          ev_changed    = DATA(lv_changed)
      ).

      IF lv_changed = abap_off.
        me->mo_run_environment->append_log( |Child Entity { iv_name }: operation ignored due to no field control flags| ).
        lv_ignore = abap_on.

      ENDIF.

      CASE iv_op.
        WHEN if_abap_behv=>op-m-create.
          APPEND <fs_dyn_row> TO <fs_target>.

      ENDCASE.

      CASE iv_op.
        WHEN if_abap_behv=>op-m-create.
          IF lv_ignore = abap_off.
            APPEND <fs_child_row> TO <fs_instances>.

          ENDIF.

        WHEN OTHERS.
          IF lv_ignore = abap_off.
            APPEND <fs_dyn_row> TO <fs_instances>.

            IF iv_partial = abap_on.
*             Log Change / Delete
              CASE iv_op.
                WHEN if_abap_behv=>op-m-update.
                  me->mo_run_environment->append_log( |Child Entity Name: { iv_name } prepared for update| ).

                WHEN if_abap_behv=>op-m-delete.
                  me->mo_run_environment->append_log( |Child Entity Name: { iv_name } prepared for deletion| ).

              ENDCASE.

              CASE iv_op.
                WHEN if_abap_behv=>op-m-update
                  OR if_abap_behv=>op-m-delete.
                  lt_key_values = me->collect_key_values(
                                    EXPORTING
                                      it_key_components = lt_key_components
                                      is_data           = <fs_dyn_row> ).

                  IF lt_key_values IS NOT INITIAL.
                    LOOP AT lt_key_values ASSIGNING <fs_key_values>.
                      me->mo_run_environment->append_log( |{ <fs_key_values> }| ).

                    ENDLOOP.

                  ENDIF.

              ENDCASE.

            ENDIF.

          ENDIF.

      ENDCASE.

    ENDIF.

  ENDMETHOD.


  METHOD fill_control_flags.

    "called per entity instance

    DATA: lo_structdescr          TYPE REF TO cl_abap_structdescr,
          lt_components           TYPE abap_component_tab,
          ls_flag_control_issues  TYPE if_ptf_rap_validate_tdo=>ts_flag_control_issues,
          lv_initial              TYPE abap_bool.

    FIELD-SYMBOLS: <fs_control>         TYPE any,
                   <fs_global>          TYPE any,
                   <fs_structure>       TYPE any,
                   <fs_flag_control>    TYPE any,
                   <fs_field_control>   TYPE any,
                   <fs_field>           TYPE any,
                   <fs_initial>         TYPE any,
                   <fs_component>       TYPE abap_componentdescr.

    CLEAR ev_error.

*   Check if we have initials
    ASSIGN COMPONENT '_INITIALS' OF STRUCTURE is_test_data TO FIELD-SYMBOL(<fs_initials>).

    CASE iv_op.
      WHEN if_abap_behv=>op-m-create
        OR if_abap_behv=>op-m-update
        OR if_abap_behv=>op-r-read.
        ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-control OF STRUCTURE cs_dyn_row TO <fs_control>.
        IF sy-subrc = 0.
          lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_control> ).
          lt_components = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

          LOOP AT lt_components ASSIGNING <fs_component>.
            CASE iv_op.
              WHEN if_abap_behv=>op-m-create
                OR if_abap_behv=>op-m-update.

                ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-global OF STRUCTURE is_perm_result TO <fs_global>.
                IF sy-subrc = 0.
*                 Map permissions result data to control flags
                  ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-field OF STRUCTURE <fs_global> TO <fs_structure>.
                  IF sy-subrc = 0.
*                   Check the fields
                    ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_control> TO <fs_flag_control>.
                    IF sy-subrc = 0.
                      ASSIGN COMPONENT <fs_component>-name OF STRUCTURE cs_dyn_row TO <fs_field>.
                      IF sy-subrc = 0.
                        ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_structure> TO <fs_field_control>.
                        IF sy-subrc = 0.
                          CLEAR lv_initial.

                          IF <fs_initials> IS ASSIGNED.
                            ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_initials> TO <fs_initial>.
                            IF sy-subrc = 0.
                              IF <fs_initial> = abap_on.
                                lv_initial = abap_on.     "field was given explicitly with initial value
                              ENDIF.
                            ENDIF.
                          ENDIF.

                          me->mo_ptf_rap_validate_tdo->set_control_flag(
                            EXPORTING
                              iv_op                   = iv_op
                              iv_name                 = <fs_component>-name
                              iv_action               = is_step_data-action
                              iv_field                = <fs_field>
                              iv_field_control        = <fs_field_control>
                              iv_initial              = lv_initial
                              is_test_data            = is_test_data
                            IMPORTING
                              es_flag_control_issues  = ls_flag_control_issues
                              ev_flag_control         = <fs_flag_control>
                          ).

                          CASE iv_root.
                            WHEN abap_on.
                              CASE abap_on.
                                WHEN ls_flag_control_issues-e_is_mandatory.
                                  me->mo_run_environment->append_log( |Error Root Name: { iv_name }| ).
                                  me->mo_run_environment->append_log( |Field { <fs_component>-name } is mandatory !| ).
                                  ev_error = abap_on.

                                WHEN ls_flag_control_issues-w_use_initial.
*                                  IF me->mv_source = 'TDC'.
*                                    me->mo_run_environment->append_log( |To update field { <fs_component>-name } to blank use _INITIALS flag structure !| ).
*
*                                  ENDIF.

                                WHEN ls_flag_control_issues-w_is_readonly.
                                  me->mo_run_environment->append_log( |Field { <fs_component>-name } is read-only, will be ignored !| ).

                                WHEN ls_flag_control_issues-e_value_w_initial.
                                  me->mo_run_environment->append_log( |Field { <fs_component>-name } has a value but it's also flagged in _INITIALS !| ).

                                  ev_error = abap_on.

                              ENDCASE.

                            WHEN abap_off.
                              CASE abap_on.
                                WHEN ls_flag_control_issues-e_is_mandatory.
                                  me->mo_run_environment->append_log( |Error Root Name: { is_step_data-bus_obj }, Entity Name: { iv_name } | ).
                                  me->mo_run_environment->append_log( |Field { <fs_component>-name } is mandatory !| ).
                                  ev_error = abap_on.

                                WHEN ls_flag_control_issues-w_use_initial.
*                                  IF me->mv_source = 'TDC'.
*                                    me->mo_run_environment->append_log( |To update field { <fs_component>-name } to blank use _INITIALS flag structure !| ).
*
*                                  ENDIF.

                                WHEN ls_flag_control_issues-w_is_readonly.
                                  me->mo_run_environment->append_log( |Field { <fs_component>-name } is read-only, will be ignored !| ).

                                WHEN ls_flag_control_issues-e_value_w_initial.
                                  me->mo_run_environment->append_log( |Field { <fs_component>-name } has a value but it's also flagged in _INITIALS !| ).

                                  ev_error = abap_on.

                              ENDCASE.

                          ENDCASE.

                        ENDIF.

                      ENDIF.

                    ENDIF.

                  ENDIF.

                ENDIF.

              WHEN if_abap_behv=>op-r-read.
*               Map all control flags
*                ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-global OF STRUCTURE is_perm_result TO <fs_global>.
*                IF sy-subrc = 0.
*                  ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-field OF STRUCTURE <fs_global> TO <fs_structure>.
*                  IF sy-subrc = 0.
*                   Check the fields
                    ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_control> TO <fs_flag_control>.
                    IF sy-subrc = 0.
                      me->mo_ptf_rap_validate_tdo->set_control_flag(
                        EXPORTING
                          iv_op                   = iv_op
                          iv_name                 = <fs_component>-name
                          iv_action               = is_step_data-action
                          is_test_data            = is_test_data
                        IMPORTING
                          "es_flag_control_issues  = ls_flag_control_issues
                          ev_flag_control         = <fs_flag_control>
                      ).

                    ENDIF.

*                  ENDIF.
*
*                ENDIF.

            ENDCASE.

          ENDLOOP.

          IF ev_error EQ abap_on.
            IF iv_op EQ if_abap_behv=>op-m-create or iv_op EQ if_abap_behv=>op-m-update.
              me->mo_run_environment->append_log( |End of control messages for Entity: { iv_name }. | ).
            ENDIF.
          ENDIF.

        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD filter_operations_instance.
    DATA: lo_tabledescr       TYPE REF TO cl_abap_tabledescr,
          lo_structdescr      TYPE REF TO cl_abap_structdescr,
          lo_typedescr        TYPE REF TO cl_abap_typedescr,
          lr_result_c         TYPE REF TO data,
          lt_key_values       TYPE string_table,
          lv_sub_name         TYPE cl_abap_behvdescr=>t_sub_name,
          lv_keep_operation   TYPE abap_bool,
          lv_test_data_valid  TYPE abap_bool,
          lv_key_fully_filled TYPE abap_bool,
          lv_key_empty        TYPE abap_bool,
          lv_tabix            TYPE syst-tabix,
          lv_root             TYPE abap_bool,
          lv_virtual          TYPE abap_bool.

    FIELD-SYMBOLS: <fs_operation>   TYPE abp_behv_retrievals,
                   <fs_test_data>   TYPE any,
                   <fs_test_data_c> TYPE any, "test data to be checked
                   <fs_component>   TYPE abap_componentdescr,
                   <fs_results>     TYPE STANDARD TABLE,
                   <fs_table>       TYPE STANDARD TABLE,
                   <fs_result>      TYPE any,
                   <fs_result_c>    TYPE any, "data to be checked
                   <fs_pid>         TYPE any,
                   <fs_key_values>  TYPE string.

    CLEAR: ev_error, ev_abort_filter.

*   Move all operations to operations left to be filtered
    IF ct_operations_l IS INITIAL.
      ct_operations_l = it_operations.

      LOOP AT ct_operations_l ASSIGNING <fs_operation>.
        lv_tabix = sy-tabix.

        lo_tabledescr ?= cl_abap_refdescr=>describe_by_data( <fs_operation>-results->* ).
        CREATE DATA <fs_operation>-results TYPE HANDLE lo_tabledescr.

        ASSIGN <fs_operation>-results->* TO <fs_results>.

        IF it_operations[ lv_tabix ]-results IS BOUND.
          APPEND LINES OF it_operations[ lv_tabix ]-results->* TO <fs_results>.

        ENDIF.

      ENDLOOP.

    ENDIF.

*   Generate filtered operations
    IF ct_operations_f IS INITIAL.
      ct_operations_f = it_operations.

      LOOP AT ct_operations_f ASSIGNING <fs_operation>.
        lo_tabledescr ?= cl_abap_refdescr=>describe_by_data( <fs_operation>-results->* ).
        CREATE DATA <fs_operation>-results TYPE HANDLE lo_tabledescr.

      ENDLOOP.

    ENDIF.

*   Generate keys based on existence of %PID
    IF is_parent_instance IS SUPPLIED. "Recursion takes place at child level
      ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-pid OF STRUCTURE is_parent_instance TO <fs_pid>.
      IF sy-subrc = 0.
        IF <fs_pid> IS NOT INITIAL.
          lv_virtual = abap_on.

        ENDIF.

      ENDIF.

    ELSE. "Recursion takes place at root level
      ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-pid OF STRUCTURE cs_test_data TO <fs_pid>.
      IF sy-subrc = 0.
        IF <fs_pid> IS NOT INITIAL.
          lv_virtual = abap_on.

        ENDIF.

      ENDIF.

    ENDIF.

    DATA(lt_key_components) = me->mo_ptf_rap_metadata->get_key_fields( EXPORTING iv_name = iv_name iv_virtual = lv_virtual ).

*   Check if it's a table or structure
    lo_typedescr = cl_abap_typedescr=>describe_by_data( cs_test_data ).

*   Check if test data is itab or structure
    CASE lo_typedescr->type_kind.
      WHEN cl_abap_typedescr=>typekind_table. "itab
        lo_tabledescr ?= cl_abap_structdescr=>describe_by_data( cs_test_data ).
        lo_structdescr ?= lo_tabledescr->get_table_line_type( ).

      WHEN OTHERS.
        lo_structdescr ?= cl_abap_structdescr=>describe_by_data( cs_test_data ).

    ENDCASE.

    DATA(lt_components) = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

    IF iv_p_name IS SUPPLIED. "Recursion takes place at child level, read the association name
      LOOP AT lt_components ASSIGNING <fs_component> WHERE name CP '_*'. "Association starts with _
        lv_sub_name = <fs_component>-name.
        EXIT.
      ENDLOOP.

    ENDIF.

*   Filter components
    DELETE lt_components WHERE name CP '_*'.
    DELETE lt_components WHERE name CP '%*'.

    LOOP AT lt_components ASSIGNING <fs_component>.
      lv_tabix = sy-tabix.

      IF line_exists( lt_key_components[ name = <fs_component>-name ] ).
        DELETE lt_components INDEX lv_tabix.
        CONTINUE.

      ENDIF.

    ENDLOOP.

*   In case of reverse associations the following 2 reads are not successful but <fs_operation>
*   is still assigned from above
    UNASSIGN <fs_operation>.

    IF iv_p_name IS NOT SUPPLIED.  "Recursion takes place at root level, read the READ operation that will be filtered
      READ TABLE ct_operations_l ASSIGNING <fs_operation>
      WITH KEY op = if_abap_behv=>op-r-read entity_name = iv_name.

    ELSE.  "Recursion takes place at child level, read the READ BY ASSOCIATION operation that will be filtered
      READ TABLE ct_operations_l ASSIGNING <fs_operation>
      WITH KEY op = if_abap_behv=>op-r-read_ba entity_name = iv_p_name sub_name = lv_sub_name.

    ENDIF.

    IF <fs_operation> IS NOT ASSIGNED.
*     Don't filter anything, this should happen when we have reverse relationships in input JSON
      ev_abort_filter = abap_on.
      ct_operations_f = it_operations.
      RETURN.

    ENDIF.

    IF <fs_operation> IS ASSIGNED.
      IF <fs_operation>-results IS BOUND.
        ASSIGN <fs_operation>-results->* TO <fs_results>.
        IF sy-subrc = 0.
          LOOP AT <fs_results> ASSIGNING <fs_result>.
            lv_tabix = sy-tabix.

            CLEAR lv_keep_operation.

            CREATE DATA lr_result_c LIKE <fs_result>.
            ASSIGN lr_result_c->* TO <fs_result_c>.

            lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_result> ).
            DATA(lt_result_components) = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

*           Check if test data is itab or structure
            CASE lo_typedescr->type_kind.
              WHEN cl_abap_typedescr=>typekind_table. "itab
                IF cs_test_data IS NOT INITIAL. "Only filter if we have test data to filter against
                  LOOP AT cs_test_data ASSIGNING <fs_test_data>.
                    lv_root = COND #( WHEN iv_p_name IS NOT SUPPLIED THEN abap_on ELSE abap_off ).

                    me->mo_ptf_rap_validate_tdo->move_test_data(
                      EXPORTING
                        is_test_data   = <fs_test_data>
                        iv_name        = iv_name
                        iv_root        = lv_root
                        iv_context     = if_ptf_rap_validate_tdo=>filters
                      IMPORTING
                        ev_error       = ev_error
                      CHANGING
                        cs_target_data = <fs_result_c> ).
                    IF ev_error = abap_on.
                      EXIT.

                    ENDIF.

                    IF is_parent_instance IS SUPPLIED.
                      me->mo_ptf_rap_validate_tdo->move_test_data(
                        EXPORTING
                          is_test_data   = is_parent_instance
                          iv_name        = iv_name
                          iv_root        = lv_root
                          iv_context     = if_ptf_rap_validate_tdo=>filters
                          iv_parent      = abap_on
                        IMPORTING
                          ev_error       = ev_error
                        CHANGING
                          cs_target_data = <fs_result_c> ).
                      IF ev_error = abap_on.
                        EXIT.

                      ENDIF.

                    ENDIF.

                    IF lv_keep_operation = abap_off.
*                     If the key is not fully filled then make a partial key check (by skipping the LAST key field)
                      lv_key_fully_filled = me->mo_ptf_rap_validate_tdo->check_key_fully_filled( iv_name = iv_name
                                                                                                 is_data = <fs_result_c> ).

                      lv_keep_operation = me->check_operation(
                        is_test_data        = <fs_result_c>
                        is_result           = <fs_result>
                        it_key_components   = lt_key_components
                        iv_key_fully_filled = lv_key_fully_filled
                      ).

                      IF lv_keep_operation = abap_on.
                        lv_test_data_valid = abap_on. "test data is valid

                      ENDIF.

                    ENDIF.

                    LOOP AT lt_components ASSIGNING <fs_component>.
                      IF NOT line_exists( lt_result_components[ name = <fs_component>-name ] ).
                        ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_test_data> TO <fs_test_data_c>.
                        IF sy-subrc = 0.
                          me->filter_operations_instance(
                            EXPORTING
                              is_parent_instance  = <fs_result_c>
                              iv_p_name           = iv_name
                              iv_name             = CONV #( <fs_component>-name )
                              iv_action           = iv_action
                              it_operations       = it_operations
                            IMPORTING
                              ev_abort_filter     = ev_abort_filter
                              ev_error            = ev_error
                            CHANGING
                              ct_operations_l     = ct_operations_l
                              ct_operations_f     = ct_operations_f
                              cs_test_data        = <fs_test_data_c>
                          ).
                          IF ev_error = abap_on OR ev_abort_filter = abap_on.
                            EXIT.

                          ENDIF.

                        ENDIF.

                      ENDIF.

                    ENDLOOP.

                    IF ev_error = abap_on OR ev_abort_filter = abap_on.
                      EXIT.

                    ENDIF.

                  ENDLOOP.

                  IF ev_error = abap_on OR ev_abort_filter = abap_on.
                    EXIT.

                  ENDIF.

                  IF lv_keep_operation = abap_on.
                    me->move_operations_result(
                      EXPORTING
                        is_operation  = <fs_operation>
                        is_result     = <fs_result>
                        iv_p_name     = iv_p_name
                        iv_name       = iv_name
                        iv_sub_name   = lv_sub_name
                        iv_tabix      = lv_tabix
                      CHANGING
                        ct_operations = ct_operations_f
                        cs_results    = <fs_results>
                    ).

                  ENDIF.

                ENDIF.

              WHEN OTHERS. "structure
                lv_root = COND #( WHEN iv_p_name IS NOT SUPPLIED THEN abap_on ELSE abap_off ).

                me->mo_ptf_rap_validate_tdo->move_test_data(
                  EXPORTING
                    is_test_data   = cs_test_data
                    iv_name        = iv_name
                    iv_root        = lv_root
                    iv_context     = if_ptf_rap_validate_tdo=>filters
                  IMPORTING
                    ev_error       = ev_error
                  CHANGING
                    cs_target_data = <fs_result_c> ).
                IF ev_error = abap_on.
                  EXIT.

                ENDIF.

                IF is_parent_instance IS SUPPLIED.
                  me->mo_ptf_rap_validate_tdo->move_test_data(
                    EXPORTING
                      is_test_data   = is_parent_instance
                      iv_name        = iv_name
                      iv_root        = lv_root
                      iv_context     = if_ptf_rap_validate_tdo=>filters
                      iv_parent      = abap_on
                    IMPORTING
                      ev_error       = ev_error
                    CHANGING
                      cs_target_data = <fs_result_c> ).
                  IF ev_error = abap_on.
                    EXIT.

                  ENDIF.

                ENDIF.

*               If the key is not fully filled then make a partial key check (by skipping the LAST key field)

                lv_key_fully_filled = me->mo_ptf_rap_validate_tdo->check_key_fully_filled( iv_name = iv_name
                                                                                           is_data = <fs_result_c> ).

                lv_keep_operation = me->check_operation(
                  is_test_data        = <fs_result_c>
                  is_result           = <fs_result>
                  it_key_components   = lt_key_components
                  iv_key_fully_filled = lv_key_fully_filled
                ).

                IF lv_keep_operation = abap_on.
                  lv_test_data_valid = abap_on. "test data is valid

                ENDIF.

                LOOP AT lt_components ASSIGNING <fs_component>.
                  IF NOT line_exists( lt_result_components[ name = <fs_component>-name ] ).
                    ASSIGN COMPONENT <fs_component>-name OF STRUCTURE cs_test_data TO <fs_test_data_c>.
                    IF sy-subrc = 0.
                      me->filter_operations_instance(
                        EXPORTING
                          is_parent_instance  = <fs_result_c>
                          iv_p_name           = iv_name
                          iv_name             = CONV #( <fs_component>-name )
                          iv_action           = iv_action
                          it_operations       = it_operations
                        IMPORTING
                          ev_abort_filter     = ev_abort_filter
                          ev_error            = ev_error
                        CHANGING
                          ct_operations_l     = ct_operations_l
                          ct_operations_f     = ct_operations_f
                          cs_test_data        = <fs_test_data_c>
                      ).
                      IF ev_error = abap_on OR ev_abort_filter = abap_on.
                        EXIT.

                      ENDIF.

                    ENDIF.

                  ENDIF.

                ENDLOOP.

                IF ev_error = abap_on OR ev_abort_filter = abap_on.
                  EXIT.

                ENDIF.

                IF lv_keep_operation = abap_on.
                  me->move_operations_result(
                    EXPORTING
                      is_operation  = <fs_operation>
                      is_result     = <fs_result>
                      iv_p_name     = iv_p_name
                      iv_name       = iv_name
                      iv_sub_name   = lv_sub_name
                      iv_tabix      = lv_tabix
                    CHANGING
                      ct_operations = ct_operations_f
                      cs_results    = <fs_results>
                  ).

                ENDIF.

            ENDCASE.

          ENDLOOP.

*         Check if test data is eligible if no entry has been found, only for action RETRIEVE
          IF iv_action = 'RETRIEVE'.
            IF lv_test_data_valid = abap_off.
              IF iv_p_name IS NOT SUPPLIED.
                READ TABLE it_operations ASSIGNING <fs_operation>
                WITH KEY op = if_abap_behv=>op-r-read entity_name = iv_name.

              ELSE.
                READ TABLE it_operations ASSIGNING <fs_operation>
                WITH KEY op = if_abap_behv=>op-r-read_ba entity_name = iv_p_name sub_name = lv_sub_name.

              ENDIF.

              IF <fs_operation> IS ASSIGNED.
                IF <fs_operation>-results IS BOUND.
                  ASSIGN <fs_operation>-results->* TO <fs_results>.
                  IF sy-subrc = 0.
*                   Check if test data is itab or structure
                    CASE lo_typedescr->type_kind.
                      WHEN cl_abap_typedescr=>typekind_table. "itab
                        IF cs_test_data IS NOT INITIAL. "Only filter if we have test data to filter against
                          LOOP AT cs_test_data ASSIGNING <fs_test_data>.
                            lv_tabix = sy-tabix.

                            LOOP AT <fs_results> ASSIGNING <fs_result>.
                              CREATE DATA lr_result_c LIKE <fs_result>.
                              ASSIGN lr_result_c->* TO <fs_result_c>.

                              lv_root = COND #( WHEN iv_p_name IS NOT SUPPLIED THEN abap_on ELSE abap_off ).

                              me->mo_ptf_rap_validate_tdo->move_test_data(
                                EXPORTING
                                  is_test_data   = <fs_test_data>
                                  iv_name        = iv_name
                                  iv_root        = lv_root
                                  iv_context     = if_ptf_rap_validate_tdo=>filters
                                IMPORTING
                                  ev_error       = ev_error
                                CHANGING
                                  cs_target_data = <fs_result_c> ).
                              IF ev_error = abap_on.
                                EXIT.

                              ENDIF.

                              IF is_parent_instance IS SUPPLIED.
                                me->mo_ptf_rap_validate_tdo->move_test_data(
                                  EXPORTING
                                    is_test_data   = is_parent_instance
                                    iv_name        = iv_name
                                    iv_root        = lv_root
                                    iv_context     = if_ptf_rap_validate_tdo=>filters
                                    iv_parent      = abap_on
                                  IMPORTING
                                    ev_error       = ev_error
                                  CHANGING
                                    cs_target_data = <fs_result_c> ).
                                IF ev_error = abap_on.
                                  EXIT.

                                ENDIF.

                              ENDIF.

*                             If the key is not fully filled and key of child entity TDO is empty then skip the check
*                             We check also the key of child TDO not to be empty because a text inserted in a numeric key can be converted to initial value
*                             So the check on key fully filled could return false so we make a check on the raw data (child entity TDO)
*                             to see if the user filled something in one key
                              lv_key_fully_filled = me->mo_ptf_rap_validate_tdo->check_key_fully_filled( iv_name = iv_name
                                                                                                         is_data = <fs_result_c> ).

                              lv_key_empty = me->mo_ptf_rap_validate_tdo->check_key_empty( iv_name = iv_name
                                                                                           is_data = <fs_test_data> ).

                              IF lv_key_fully_filled = abap_off AND lv_key_empty = abap_on.
                                lv_test_data_valid = abap_on.
                                CONTINUE.

                              ENDIF.

                              lv_keep_operation = me->check_operation(
                                is_test_data      = <fs_result_c>
                                is_result         = <fs_result>
                                it_key_components = lt_key_components
                              ).

                              IF lv_keep_operation = abap_on.
                                lv_test_data_valid = abap_on.
                                EXIT.

                              ENDIF.

                            ENDLOOP.

                            IF lv_test_data_valid = abap_off.
*                             Issue error that no entry was found
                              lt_key_values = me->collect_key_values(
                                                      EXPORTING
                                                        it_key_components = lt_key_components
                                                        is_data           = <fs_test_data> ).

                              IF lt_key_values IS NOT INITIAL.
                                me->mo_run_environment->append_log( |Error Entity { iv_name }: not found ! Key Values:| ).
                                LOOP AT lt_key_values ASSIGNING <fs_key_values>.
                                  me->mo_run_environment->append_log( |{ <fs_key_values> }| ).

                                ENDLOOP.

                              ENDIF.

*                             Delete the entry so that it will not be logged again in a subsequent recursive call of this method
                              ASSIGN cs_test_data TO <fs_table>.
                              DELETE <fs_table> INDEX lv_tabix.

                              ev_error = abap_on.
                              EXIT.

                            ENDIF.

                          ENDLOOP.

                        ENDIF.

                      WHEN OTHERS.
                        LOOP AT <fs_results> ASSIGNING <fs_result>.
                          CREATE DATA lr_result_c LIKE <fs_result>.
                          ASSIGN lr_result_c->* TO <fs_result_c>.

                          lv_root = COND #( WHEN iv_p_name IS NOT SUPPLIED THEN abap_on ELSE abap_off ).

                          me->mo_ptf_rap_validate_tdo->move_test_data(
                            EXPORTING
                              is_test_data   = cs_test_data
                              iv_name        = iv_name
                              iv_root        = lv_root
                              iv_context     = if_ptf_rap_validate_tdo=>filters
                            IMPORTING
                              ev_error       = ev_error
                            CHANGING
                              cs_target_data = <fs_result_c> ).
                          IF ev_error = abap_on.
                            EXIT.

                          ENDIF.

                          IF is_parent_instance IS SUPPLIED.
                            me->mo_ptf_rap_validate_tdo->move_test_data(
                              EXPORTING
                                is_test_data   = is_parent_instance
                                iv_name        = iv_name
                                iv_root        = lv_root
                                iv_context     = if_ptf_rap_validate_tdo=>filters
                                iv_parent      = abap_on
                              IMPORTING
                                ev_error       = ev_error
                              CHANGING
                                cs_target_data = <fs_result_c> ).
                            IF ev_error = abap_on.
                              EXIT.

                            ENDIF.

                          ENDIF.

*                         If the key is not fully filled then skip the check
                          lv_key_fully_filled = me->mo_ptf_rap_validate_tdo->check_key_fully_filled( iv_name = iv_name
                                                                                                     is_data = <fs_result_c> ).
                          IF lv_key_fully_filled = abap_off.
                            lv_test_data_valid = abap_on.
                            CONTINUE.

                          ENDIF.

                          lv_keep_operation = me->check_operation(
                            is_test_data      = <fs_result_c>
                            is_result         = <fs_result>
                            it_key_components = lt_key_components
                          ).

                          IF lv_keep_operation = abap_on.
                            lv_test_data_valid = abap_on. "test data is valid

                          ENDIF.

                          IF lv_test_data_valid = abap_off.
*                           Issue error that no entry was found
                            lt_key_values = me->collect_key_values(
                                                    EXPORTING
                                                      it_key_components = lt_key_components
                                                      is_data           = cs_test_data ).

                            IF lt_key_values IS NOT INITIAL.
                              me->mo_run_environment->append_log( |Entity { iv_name } not found ! Key Values:| ).
                              LOOP AT lt_key_values ASSIGNING <fs_key_values>.
                                me->mo_run_environment->append_log( |{ <fs_key_values> }| ).

                              ENDLOOP.

                            ENDIF.

                            ev_error = abap_on.
                            EXIT.

                          ENDIF.

                        ENDLOOP.

                    ENDCASE.

                  ENDIF.

                ENDIF.

              ENDIF.

            ENDIF.

          ENDIF.

        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD get_action.
    CLEAR: ev_action, ev_child_action, ev_error.

    ev_action = iv_action.

    ASSIGN COMPONENT '_ACTION' OF STRUCTURE is_test_data TO FIELD-SYMBOL(<fs_action>).
    IF sy-subrc = 0.
      IF iv_action <> 'ENTITY_ACTION'.
        IF <fs_action> <> iv_action.
          me->mo_run_environment->append_log( |Entity { iv_name }, action { <fs_action> } from JSON property different than action { iv_action } from step| ).
          ev_error = abap_on.
          RETURN.

        ENDIF.

      ENDIF.

      ev_action = <fs_action>.
      ev_child_action = abap_on.

    ENDIF.

  ENDMETHOD.


  METHOD get_entityname.
    CLEAR: ev_name, ev_child_entity.

    ev_name = iv_name.

    ASSIGN COMPONENT '_CHILDENTITYNAME' OF STRUCTURE is_test_data TO FIELD-SYMBOL(<fs_childentityname>).
    IF sy-subrc = 0.
      ev_name = <fs_childentityname>.
      ev_child_entity = abap_on.

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


  METHOD if_ptf_rap_operations~build_operations.
    DATA: lo_typedescr            TYPE REF TO cl_abap_typedescr.

    FIELD-SYMBOLS: <fs_test_data_ref>   TYPE any,
                   <fs_test_data>       TYPE any.

    CLEAR: et_operations, ev_error.

*   Check if it's a table or structure
    lo_typedescr = cl_abap_typedescr=>describe_by_data( is_test_data ).

    CASE lo_typedescr->type_kind.
      WHEN cl_abap_typedescr=>typekind_table. "itab
        LOOP AT is_test_data ASSIGNING <fs_test_data_ref>.
          DATA(lv_tabix) = sy-tabix.

          ASSIGN <fs_test_data_ref>->* TO <fs_test_data>.

          me->build_operations_instance(
            EXPORTING
              iv_op = iv_op
              iv_instance_no = lv_tabix
              is_step_data   = is_step_data
              is_test_data   = <fs_test_data>
              it_permissions = it_permissions
            IMPORTING
              ev_error       = ev_error
            CHANGING
              ct_operations  = et_operations ).
          IF ev_error = abap_on.
            EXIT.

          ENDIF.

        ENDLOOP.

      WHEN cl_abap_typedescr=>typekind_struct1
        OR cl_abap_typedescr=>typekind_struct2. "structure
        me->build_operations_instance(
          EXPORTING
            iv_op = iv_op
            iv_instance_no = iv_instance_no
            is_step_data   = is_step_data
            is_test_data   = is_test_data
            it_permissions = it_permissions
          IMPORTING
            ev_error       = ev_error
          CHANGING
            ct_operations  = et_operations ).

    ENDCASE.

*   Issue error message if we have no operations
    IF et_operations IS INITIAL.
*     Issue error message
      me->mo_run_environment->append_log( 'No EML operations generated' ).
      ev_error = abap_on.
      RETURN.

    ENDIF.

  ENDMETHOD.


  METHOD IF_PTF_RAP_OPERATIONS~CONVERT_TO_OPERATIONS_READ.

    DATA: lr_dyn_row        TYPE REF TO data,
          ls_read_operation TYPE abp_behv_retrievals,
          lv_op             TYPE abp_behv_op.

    FIELD-SYMBOLS: <fs_read_instances> TYPE STANDARD TABLE,
                   <fs_dyn_row>        TYPE any.

    CLEAR et_operations_read.

    LOOP AT it_operations ASSIGNING FIELD-SYMBOL(<fs_operation>).

      CLEAR ls_read_operation.

*     Change op to read or read_ba
      IF <fs_operation>-sub_name IS INITIAL.
        lv_op = if_abap_behv=>op-r-read.

      ELSE.
        CASE iv_op.
          WHEN if_abap_behv=>op-m-create
            OR if_abap_behv=>op-r-read.
            lv_op = if_abap_behv=>op-r-read_ba.

          WHEN if_abap_behv=>op-r-evaluate.
            lv_op = if_abap_behv=>op-r-evaluate.

          WHEN OTHERS.
            lv_op = if_abap_behv=>op-r-read.

        ENDCASE.

      ENDIF.

      ls_read_operation-op = lv_op.

      ls_read_operation-entity_name = <fs_operation>-entity_name.
      ls_read_operation-sub_name    = <fs_operation>-sub_name.

      ls_read_operation-instances = cl_abap_behvdescr=>create_data(
                                p_name      = <fs_operation>-entity_name
                                p_sub_name  = <fs_operation>-sub_name
                                p_op        = lv_op
                                p_kind      = if_abap_behv=>typekind-import
                             ).

*     Value the FULL flag, because some behavior implementations keep account of this flag
*     and don't bring RESULTS if it's not valued
      ls_read_operation-full    = abap_on.

      ls_read_operation-results = cl_abap_behvdescr=>create_data(
                                p_name      = <fs_operation>-entity_name
                                p_sub_name  = <fs_operation>-sub_name
                                p_op        = lv_op
                                p_kind      = if_abap_behv=>typekind-result
                             ).

      ASSIGN ls_read_operation-instances->* TO <fs_read_instances>.

      CREATE DATA lr_dyn_row LIKE LINE OF <fs_read_instances>.
      ASSIGN lr_dyn_row->* TO <fs_dyn_row>.

      IF <fs_operation>-instances IS BOUND.
*       delete duplicate entries
        DELETE ADJACENT DUPLICATES FROM <fs_operation>-instances->*.

        LOOP AT <fs_operation>-instances->* ASSIGNING FIELD-SYMBOL(<fs_instance>).
          <fs_dyn_row> = CORRESPONDING #( <fs_instance> ).
          APPEND <fs_dyn_row> TO <fs_read_instances>.

        ENDLOOP.

      ENDIF.

      APPEND ls_read_operation TO et_operations_read.

    ENDLOOP.

  ENDMETHOD.


  METHOD if_ptf_rap_operations~filter_operations.
    DATA: lo_typedescr            TYPE REF TO cl_abap_typedescr,
          lr_test_data            TYPE REF TO data,
          lt_operations_l         TYPE abp_behv_retrievals_tab, "operations left to be filtered
          lt_operations_f         TYPE abp_behv_retrievals_tab. "operations filtered

    FIELD-SYMBOLS: <fs_test_data> TYPE ANY.

    CLEAR ev_error.

*   Copy TDO data to a local variable so that non matching items with full key can be removed in case of RETRIEVE
    CREATE DATA lr_test_data LIKE is_test_data.
    ASSIGN lr_test_data->* TO <fs_test_data>.
    <fs_test_data> = is_test_data.


*   Check if it's a table or structure
    lo_typedescr = cl_abap_typedescr=>describe_by_data( is_test_data ).

    CASE lo_typedescr->type_kind.
      WHEN cl_abap_typedescr=>typekind_table. "itab
*       don't filter multiple instances, multiple instances occur only in case of RETRIEVE_ALL and CHECK_IF_EXISTS with free key
        RETURN.

      WHEN cl_abap_typedescr=>typekind_struct1
        OR cl_abap_typedescr=>typekind_struct2. "structure
        me->filter_operations_instance(
          EXPORTING
            iv_name         = iv_name
            iv_action       = iv_action
            it_operations   = ct_operations "all operations to be filtered
          IMPORTING
            ev_error        = ev_error
          CHANGING
            ct_operations_l = lt_operations_l
            ct_operations_f = lt_operations_f
            cs_test_data    = <fs_test_data>
        ).

        ct_operations = lt_operations_f. "filtered operations

    ENDCASE.

  ENDMETHOD.


  METHOD if_ptf_rap_operations~handle_operations_error.
    DATA: lo_message      TYPE REF TO if_t100_dyn_msg, "if_message
          lt_components   TYPE abap_component_tab,
          lv_is_key_found TYPE abap_bool,
          lv_message      TYPE string.

    FIELD-SYMBOLS: <fs_reported> TYPE abp_behv_response,
                   <fs_entries>  TYPE any,
                   <fs_field>    TYPE any,
                   <fs_value>    TYPE any.

    CLEAR ev_error.

    IF it_failed IS NOT INITIAL OR iv_is_read = abap_on.
      LOOP AT it_reported ASSIGNING <fs_reported>.
        IF <fs_reported>-entity_name IS INITIAL.
          ASSIGN <fs_reported>-entries->* TO FIELD-SYMBOL(<fs_messages>).

          lv_message = |Root Name: { <fs_reported>-root_name }|.

          me->mo_run_environment->append_log( lv_message ).

          LOOP AT <fs_messages> ASSIGNING FIELD-SYMBOL(<fs_message>).
            lo_message = <fs_message>.

            lv_message = |({ lo_message->msgty }){ lo_message->if_message~get_text( ) }|.

            me->mo_run_environment->append_log( lv_message ).

*           Don't flag ev_error because a save can be successful even with error

          ENDLOOP.

        ELSE.
          me->mo_run_environment->append_log( |Error Root Name: { <fs_reported>-root_name }, Entity Name: { <fs_reported>-entity_name } | ).

*         Get the key fields
          lt_components = me->mo_ptf_rap_metadata->get_key_fields( EXPORTING iv_name = <fs_reported>-entity_name ).

          ASSIGN <fs_reported>-entries->* TO <fs_entries>.

          LOOP AT <fs_entries> ASSIGNING FIELD-SYMBOL(<fs_entry>).
            ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-msg OF STRUCTURE <fs_entry> TO <fs_field>.
            IF sy-subrc = 0.
              lo_message = <fs_field>.
              me->mo_run_environment->append_log( |Error Message: { lo_message->if_message~get_text( ) }| ).

*             Determine the key values for the error
              lv_message = 'Error Key Fields: '.

              LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
                ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_entry> TO <fs_value>.
                IF sy-subrc = 0.
                  lv_message = |{ lv_message } { <fs_component>-name }: { <fs_value> }|.

                ENDIF.

              ENDLOOP.

              me->mo_run_environment->append_log( lv_message ).

              ev_error = abap_on.

            ENDIF.

          ENDLOOP.

        ENDIF.

      ENDLOOP.

      "Handle FAILED
      LOOP AT it_failed ASSIGNING FIELD-SYMBOL(<fs_failed>).
        me->mo_run_environment->append_log( |Error Root Name: { <fs_failed>-root_name }, Entity Name: { <fs_failed>-entity_name } | ).

*       Get the key fields
        lt_components = me->mo_ptf_rap_metadata->get_key_fields( EXPORTING iv_name = <fs_failed>-entity_name ).

        ASSIGN <fs_failed>-entries->* TO FIELD-SYMBOL(<fs_failed_entries>).

        LOOP AT <fs_failed_entries> ASSIGNING FIELD-SYMBOL(<fs_failed_entry>).
          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-fail OF STRUCTURE <fs_failed_entry> TO <fs_field>.
          IF sy-subrc = 0.
            lv_is_key_found = abap_off.

            ASSIGN COMPONENT 'CAUSE' OF STRUCTURE <fs_field> TO <fs_value>.
            IF sy-subrc = 0.
*             Check if we are in RETRIEVE_ALL action, don't issue error for NOT_FOUND
              IF is_step_data IS SUPPLIED.
                CASE is_step_data-action.
                  WHEN 'RETRIEVE_ALL'.
                    IF <fs_failed>-entity_name <> is_step_data-bus_obj.
                      IF <fs_value> = if_abap_behv=>cause-not_found. "'NOT_FOUND'.
                        CONTINUE.

                      ENDIF.

                    ENDIF.

                ENDCASE.

              ENDIF.

              CASE iv_is_read.
                WHEN abap_on.
                  me->mo_run_environment->append_log( |EML Read Technical Error: { <fs_value> }| ).

                WHEN abap_off.
                  me->mo_run_environment->append_log( |EML Modify Technical Error: { <fs_value> }| ).

              ENDCASE.

              lv_is_key_found = abap_off.

*             Check if we have key
              LOOP AT lt_components ASSIGNING <fs_component>.
                ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_failed_entry> TO <fs_value>.
                IF sy-subrc = 0.
                  IF NOT <fs_value> IS INITIAL.
                    lv_is_key_found = abap_on.
                    EXIT.

                  ENDIF.

                ENDIF.

              ENDLOOP.

              IF lv_is_key_found = abap_on.
*               Determine the key values for the error
                lv_message = 'Error Key Fields: '.

                LOOP AT lt_components ASSIGNING <fs_component>.
                  ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_failed_entry> TO <fs_value>.
                  IF sy-subrc = 0.
                    lv_message = |{ lv_message } { <fs_component>-name }: { <fs_value> }|.

                  ENDIF.

                ENDLOOP.

                me->mo_run_environment->append_log( lv_message ).

              ENDIF.

              ev_error = abap_on.

            ENDIF.

          ENDIF.

        ENDLOOP.

      ENDLOOP.

      RETURN.

    ENDIF.

    IF it_failed IS INITIAL AND iv_is_read = abap_off.
      LOOP AT it_reported ASSIGNING <fs_reported>.
        ASSIGN <fs_reported>-entries->* TO <fs_entries>.

        LOOP AT <fs_entries> ASSIGNING <fs_entry>.

          CLEAR lo_message.

          DATA(lo_typedescr) = cl_abap_typedescr=>describe_by_data( <fs_entry> ).
          CASE lo_typedescr->type_kind.
            WHEN cl_abap_typedescr=>typekind_oref.
              IF <fs_entry> IS INSTANCE OF if_abap_behv_message.
                "Oref to an if_abap_behv_message instance
                lo_message = <fs_entry>.
              ENDIF.
            WHEN cl_abap_typedescr=>typekind_struct1
              OR cl_abap_typedescr=>typekind_struct2. "structure
              "We expect a field %MSG that contains an oref to an if_abap_behv_message instance
              ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-msg OF STRUCTURE <fs_entry> TO <fs_field>.
              IF sy-subrc = 0.
                lo_message = <fs_field>.
              ENDIF.
          ENDCASE.

          IF lo_message IS BOUND.
            me->mo_run_environment->append_log( lo_message->if_message~get_text( ) ).

          ENDIF.

        ENDLOOP.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD move_operations_result.
*    DATA: lo_tabledescr  TYPE REF TO cl_abap_tabledescr.

    FIELD-SYMBOLS: <fs_operation_c> TYPE abp_behv_retrievals, "copy
                   <fs_results_c>   TYPE STANDARD TABLE. "copy

*   Move operation to filtered operation and delete it from the source
    IF iv_p_name IS INITIAL.
      READ TABLE ct_operations ASSIGNING <fs_operation_c>
      WITH KEY op = if_abap_behv=>op-r-read entity_name = iv_name.
*     Not needed anymore, there should always be a line with the right operation
*      IF sy-subrc <> 0.
*        APPEND INITIAL LINE TO ct_operations ASSIGNING <fs_operation_c>.
*
*        <fs_operation_c>-op          = is_operation-op.
*        <fs_operation_c>-entity_name = is_operation-entity_name.
*        lo_tabledescr ?= cl_abap_refdescr=>describe_by_data( is_operation-results->* ).
*        CREATE DATA <fs_operation_c>-results TYPE HANDLE lo_tabledescr.
*
*      ENDIF.

      ASSIGN <fs_operation_c>-results->* TO <fs_results_c>.
      APPEND is_result TO <fs_results_c>.

    ELSE.
*     Not needed anymore, there should always be a line with the right operation
      READ TABLE ct_operations ASSIGNING <fs_operation_c>
      WITH KEY op = if_abap_behv=>op-r-read_ba entity_name = iv_p_name sub_name = iv_sub_name.
*      IF sy-subrc <> 0.
*        APPEND INITIAL LINE TO ct_operations ASSIGNING <fs_operation_c>.
*
*        <fs_operation_c>-op          = is_operation-op.
*        <fs_operation_c>-entity_name = is_operation-entity_name.
*        <fs_operation_c>-sub_name    = is_operation-sub_name.
*        lo_tabledescr ?= cl_abap_refdescr=>describe_by_data( is_operation-results->* ).
*        CREATE DATA <fs_operation_c>-results TYPE HANDLE lo_tabledescr.
*
*      ENDIF.

      ASSIGN <fs_operation_c>-results->* TO <fs_results_c>.
      APPEND is_result TO <fs_results_c>.

    ENDIF.

    DELETE cs_results INDEX iv_tabix.

  ENDMETHOD.


  METHOD recursive_compare_char_params.
    DATA: lo_structdescr TYPE REF TO cl_abap_structdescr,
          lv_typekind    TYPE abap_typekind,
          lv_tabix       TYPE syst-tabix.

    FIELD-SYMBOLS: <fs_table>           TYPE STANDARD TABLE,
                   <fs_test_table>      TYPE STANDARD TABLE,
                   <fs_structure>       TYPE any,
                   <fs_test_structure>  TYPE any.

    DATA(lo_datadescr) = cl_abap_datadescr=>describe_by_data( is_param ).

    CASE lo_datadescr->type_kind.
      WHEN cl_abap_typedescr=>typekind_table.
        ASSIGN is_param TO <fs_table> ##SUBRC_READ.
        IF sy-subrc = 0.
          ASSIGN is_test_data_param TO <fs_test_table>  ##SUBRC_READ.
          IF sy-subrc = 0.
            LOOP AT <fs_table> ASSIGNING <fs_structure>.
              lv_tabix = sy-tabix.
              READ TABLE <fs_test_table> ASSIGNING <fs_test_structure> INDEX lv_tabix.
              IF sy-subrc = 0.
                me->recursive_compare_char_params(
                  is_param            = <fs_structure>
                  is_test_data_param  = <fs_test_structure>
                ).

              ENDIF.

            ENDLOOP.

          ENDIF.

        ENDIF.

      WHEN cl_abap_typedescr=>typekind_struct1
        OR cl_abap_typedescr=>typekind_struct2. "structure
        ASSIGN is_param TO <fs_structure> ##SUBRC_READ.
        IF sy-subrc = 0.
          ASSIGN is_test_data_param TO <fs_test_structure> ##SUBRC_READ.
          IF sy-subrc = 0.
            lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_structure> ).
            DATA(lt_components) = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

            LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
              ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_structure> TO FIELD-SYMBOL(<fs_field>).
              IF sy-subrc = 0.
                ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_test_structure> TO FIELD-SYMBOL(<fs_test_field>).
                IF sy-subrc = 0.
                  me->recursive_compare_char_params(
                      is_param            = <fs_field>
                      is_test_data_param  = <fs_test_field>
                      iv_name             = <fs_component>-name
                  ).

                ENDIF.

              ENDIF.

            ENDLOOP.

          ENDIF.

        ENDIF.

      WHEN OTHERS.
        DESCRIBE FIELD is_param TYPE lv_typekind.
        CASE lv_typekind.
          WHEN cl_abap_typedescr=>typekind_char
            OR cl_abap_typedescr=>typekind_num.
            IF strlen( is_test_data_param ) > strlen( is_param ).
              me->mo_run_environment->append_log( |Parameter Field { iv_name } trimmed: { is_param }, original: { is_test_data_param } !| ).

            ENDIF.

        ENDCASE.

    ENDCASE.

  ENDMETHOD.


  METHOD recursive_fill_entry.
    DATA: lo_structdescr      TYPE REF TO cl_abap_structdescr,
          lo_tabledescr       TYPE REF TO cl_abap_tabledescr,
          lr_instance         TYPE REF TO data,
          lt_components       TYPE abap_component_tab,
          ls_operation        TYPE abp_behv_changes,
          lv_op               TYPE abp_behv_op,
          lv_name             TYPE cl_abap_behvdescr=>t_typename,
          lv_sub_name         TYPE cl_abap_behvdescr=>t_sub_name,
          lv_cid              TYPE i,
          lv_cid_ref          TYPE i,
          lv_is_operation     TYPE abap_bool,
          lv_no_operation     TYPE abap_bool.

    FIELD-SYMBOLS: <fs_component>   TYPE abap_componentdescr,
                   <fs_instance>    TYPE any,
                   <fs_result>      TYPE any,
                   <fs_test_data_t> TYPE any,
                   <fs_test_data>   TYPE any,
                   <fs_operation>   TYPE abp_behv_changes.

    CLEAR ev_error.

*   Check if parent (iv_name is the parent of the components we loop over in this method) has ignore flag
    DATA(lv_p_ignore) = me->check_ignore(
      EXPORTING
        is_test_data  = is_test_data "is_p_test_data    fix July 30, 2024
        iv_name       = is_step_data-bus_obj
        iv_action     = is_step_data-action
        iv_root       = abap_on
    ).

    CASE iv_op.
      WHEN if_abap_behv=>op-m-create
        OR if_abap_behv=>op-m-action.
        lv_cid = cv_cid. "keep current value of %CID

    ENDCASE.

    CASE iv_op.
      WHEN if_abap_behv=>op-m-create.
        lv_op = cl_abap_behvdescr=>op_create_ba.

      WHEN if_abap_behv=>op-r-read.
        lv_op = cl_abap_behvdescr=>op_read_ba.

      WHEN OTHERS.
        lv_op = iv_op.

    ENDCASE.

    CASE iv_op.
      WHEN if_abap_behv=>op-m-create
        OR if_abap_behv=>op-m-update
        OR if_abap_behv=>op-m-delete
        OR if_abap_behv=>op-r-read.
        lo_structdescr ?= cl_abap_structdescr=>describe_by_data( is_test_data ).
        lt_components = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

        LOOP AT lt_components ASSIGNING <fs_component>.
          TRY.
              ASSIGN it_permissions[ entity_name = CONV #( <fs_component>-name ) ]-results->* TO <fs_result>.
              IF sy-subrc = 0. "We have child entity test data
                ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_test_data TO <fs_test_data_t>.
                IF sy-subrc = 0.
                  lv_name = <fs_component>-name. "entity name

*                 We also need to find the association name from parent to current entity ( parent entity + association name = child entity name )
                  CLEAR lv_sub_name.

                  DESCRIBE FIELD <fs_test_data_t> TYPE DATA(lv_type).

                  CASE lv_type.
                    WHEN cl_abap_typedescr=>typekind_table. "itab
                      lo_tabledescr ?= cl_abap_tabledescr=>describe_by_data( <fs_test_data_t> ).
                      LOOP AT lo_tabledescr->key ASSIGNING FIELD-SYMBOL(<fs_test_c_tcomp>) WHERE name CP '_*'. "Association starts with _
                        lv_sub_name = <fs_test_c_tcomp>-name.
                        EXIT.
                      ENDLOOP.

                    WHEN OTHERS. "presumably structure
                      lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_test_data_t> ).
                      DATA(lt_test_c_comp) = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

                      LOOP AT lt_test_c_comp ASSIGNING FIELD-SYMBOL(<fs_test_c_comp>) WHERE name CP '_*'. "Association starts with _
                        lv_sub_name = <fs_test_c_comp>-name.
                        EXIT.
                      ENDLOOP.

                  ENDCASE.

                  IF lv_sub_name IS INITIAL.
*                   Issue error message
                    me->mo_run_environment->append_log( |Child Entity { lv_name } does not have association name !| ).
                    ev_error = abap_on.
                    EXIT.
                  ENDIF.

*                 Check if association name is valid
                  me->mo_ptf_rap_validate_tdo->check_association(
                    EXPORTING
                      iv_p_name     = iv_name       "parent entity name
                      iv_name       = lv_name       "child entity name
                      iv_sub_name   = lv_sub_name   "association name
                      iv_op         = iv_op         "operation name
                    IMPORTING
                      ev_reverse    = DATA(lv_reverse) "reverse relationship
                      ev_error      = ev_error ).
                  IF ev_error = abap_on.
                    EXIT.

                  ENDIF.

*                 Check if operation is allowed
                  CLEAR lv_no_operation.

                  me->mo_ptf_rap_validate_tdo->check_operation(
                    EXPORTING
                      iv_op     = iv_op
                      iv_name   = lv_name
                    IMPORTING
                      ev_error  = lv_no_operation ).
                  IF lv_no_operation = abap_on. "don't build an operation because it will dump
                    me->mo_run_environment->append_log( |Keys of entity { lv_name } will not be passed to child entities| ).

                  ENDIF.

*                 Check if operation is not already existing
                  CASE iv_op.
                    WHEN if_abap_behv=>op-m-create
                      OR if_abap_behv=>op-r-read.
                      CASE lv_reverse.
                        WHEN abap_off.
                          READ TABLE ct_operations ASSIGNING <fs_operation> WITH KEY op = lv_op entity_name = iv_name sub_name = lv_sub_name.
                          IF sy-subrc = 0.
                            lv_is_operation = abap_on.

*                           Check if this is really the best operation where to append the instance
*                           ( all instances' ref cids and current ref cid have to reference the same parent operation )
*                           or if a new one should be created

                            GET REFERENCE OF <fs_operation> INTO DATA(lr_operation).

                            me->check_right_operation(
                              EXPORTING
                                is_step_data    = is_step_data
                                it_operations   = ct_operations
                                ir_operation    = lr_operation
                                iv_instance_no  = iv_instance_no
                                iv_cid_ref      = iv_cid_ref
                              CHANGING
                                cv_operation_already_added = lv_is_operation
                            ).

*                            ASSIGN lr_operation->* TO <fs_operation>.

                          ENDIF.

                        WHEN abap_on.
*                         Read also the reverse relationship if we have read
                          READ TABLE ct_operations ASSIGNING <fs_operation> WITH KEY op = lv_op entity_name = lv_name sub_name = lv_sub_name.
                          IF sy-subrc = 0.
                            lv_is_operation = abap_on.

                          ENDIF.

                      ENDCASE.

                    WHEN OTHERS.
                      READ TABLE ct_operations ASSIGNING <fs_operation> WITH KEY op = iv_op entity_name = lv_name.
                      IF sy-subrc = 0.
                        lv_is_operation = abap_on.

                      ENDIF.

                  ENDCASE.

*                 Make new operation if it does not exist yet and if the operation is allowed
                  IF lv_is_operation = abap_off AND lv_no_operation = abap_off.
                    CLEAR ls_operation.

                    CASE iv_op.
                      WHEN if_abap_behv=>op-m-create
                        OR if_abap_behv=>op-r-read.
                        CASE lv_reverse.
                          WHEN abap_off.
                            ls_operation-entity_name  = iv_name. "is_step_data-bus_obj
                            ls_operation-sub_name     = lv_sub_name.

                            ls_operation-instances = cl_abap_behvdescr=>create_data(
                                                      p_name      = iv_name "is_step_data-bus_obj
                                                      p_op        = lv_op
                                                      p_sub_name  = lv_sub_name
                                                      p_kind      = if_abap_behv=>typekind-import
                                                   ).

                            ls_operation-results = cl_abap_behvdescr=>create_data(
                                                      p_name      = iv_name "is_step_data-bus_obj
                                                      p_op        = if_abap_behv=>op-r-read_ba
                                                      p_sub_name  = lv_sub_name
                                                      p_kind      = if_abap_behv=>typekind-result
                                                   ).

                            ls_operation-op = lv_op.

                          WHEN abap_on.
                            ls_operation-entity_name  = lv_name. "is_step_data-bus_obj
                            ls_operation-sub_name     = lv_sub_name.

                            ls_operation-instances = cl_abap_behvdescr=>create_data(
                                                      p_name      = lv_name "is_step_data-bus_obj
                                                      p_op        = lv_op
                                                      p_sub_name  = lv_sub_name
                                                      p_kind      = if_abap_behv=>typekind-import
                                                   ).

                            ls_operation-results = cl_abap_behvdescr=>create_data(
                                                      p_name      = lv_name "is_step_data-bus_obj
                                                      p_op        = if_abap_behv=>op-r-read_ba
                                                      p_sub_name  = lv_sub_name
                                                      p_kind      = if_abap_behv=>typekind-result
                                                   ).

                            ls_operation-op = lv_op.

                        ENDCASE.

                      WHEN OTHERS.
                        ls_operation-entity_name = lv_name.

                        ls_operation-instances = cl_abap_behvdescr=>create_data(
                                                  p_name  = lv_name
                                                  p_op    = iv_op
                                                  p_kind  = if_abap_behv=>typekind-import
                                               ).

                        ls_operation-results = cl_abap_behvdescr=>create_data(
                                                  p_name  = lv_name
                                                  p_op    = iv_p_op_r
                                                  p_kind  = if_abap_behv=>typekind-result
                                               ).

                        ls_operation-op = iv_op.

                    ENDCASE.

*                   Append operation because we need a logical order of the operations
                    APPEND ls_operation TO ct_operations ASSIGNING <fs_operation>.
                    IF sy-subrc = 0.
                      DATA(lv_line_index) = sy-tabix.

                    ENDIF.

                  ENDIF.

*                 Check if test data is itab or structure
                  CASE lv_type.
                    WHEN cl_abap_typedescr=>typekind_table. "itab
                      LOOP AT <fs_test_data_t> ASSIGNING <fs_test_data>.
                        IF lv_no_operation = abap_off. "Operation is allowed
*                         Increment current %CID as number by 1
*                         Pass current %CID as number to next %CID_REF as number
                          CASE iv_op.
                            WHEN if_abap_behv=>op-m-create
                              OR if_abap_behv=>op-m-action.
                              cv_cid      = cv_cid + 1.
                              lv_cid_ref  = cv_cid.

                          ENDCASE.

*                         fill_child_entry.
                          me->fill_child_entry(
                            EXPORTING
                              it_permissions      = it_permissions
                              is_step_data        = is_step_data
                              is_parent_instance  = is_parent_instance   "EML instance operation of the parent ( because here we have keys from level 1 to level -2 )
                              is_test_data        = <fs_test_data>       "TDO data of the current entity instance ( = current child )
                              is_p_test_data      = is_test_data         "TDO data of the parent entity instance ( because here we have the key of level -1 ). Only needed for READ
                              iv_op               = iv_op
                              iv_name             = lv_name
                              iv_instance_no      = iv_instance_no
                              iv_cid_ref          = lv_cid "iv_cid_ref
                              iv_cid              = cv_cid
                              iv_partial          = iv_partial
                            IMPORTING
                              er_instance         = lr_instance
                              ev_error            = ev_error
                            CHANGING
                              cs_operation        = <fs_operation>        "Current operation
                          ).

                          IF ev_error = abap_on.
                            EXIT.

                          ENDIF.

                          ASSIGN lr_instance->* TO <fs_instance>.

*                         Recursive fill entry
                          me->recursive_fill_entry(
                            EXPORTING
                              iv_op               = iv_op
                              iv_p_op_r           = iv_p_op_r
                              iv_name             = lv_name
                              iv_instance_no      = iv_instance_no
                              iv_cid_ref          = lv_cid_ref "iv_cid_ref
                              iv_partial          = lv_p_ignore "iv_partial
                              is_step_data        = is_step_data
                              is_test_data        = <fs_test_data> "TDO data of the current entity instance ( = current child )
                              is_p_test_data      = is_test_data   "TDO data of the parent entity instance ( because here we have the key of level -1 ). Only needed for READ
                              is_parent_instance  = <fs_instance>  "EML instance operation of the current instance
                              it_permissions      = it_permissions
                            IMPORTING
                              ev_error            = ev_error
                            CHANGING
                              ct_operations       = ct_operations
                              cv_cid              = cv_cid
                          ).

                          IF ev_error = abap_on.
                            EXIT.

                          ENDIF.

                        ELSE. "Operation is not allowed, don't fill child entry and jump to the next operation to be built
*                         Pass current %CID as number to next %CID_REF as number
                          CASE iv_op.
                            WHEN if_abap_behv=>op-m-create
                              OR if_abap_behv=>op-m-action.
                              lv_cid_ref = cv_cid.

                          ENDCASE.

*                         Recursive fill entry
                          me->recursive_fill_entry(
                            EXPORTING
                              iv_op               = iv_op
                              iv_p_op_r           = iv_p_op_r
                              iv_name             = lv_name
                              iv_instance_no      = iv_instance_no
                              iv_cid_ref          = lv_cid_ref "iv_cid_ref
                              iv_partial          = lv_p_ignore "iv_partial
                              is_step_data        = is_step_data
                              is_test_data        = <fs_test_data>  "TDO data of the current entity instance ( = current child )
                              is_p_test_data      = is_test_data    "TDO data of the parent entity instance ( because here we have the key of level -1 ). Needed for READ and sometimes for CREATE w/ %PID
                              it_permissions      = it_permissions
                            IMPORTING
                              ev_error            = ev_error
                            CHANGING
                              ct_operations       = ct_operations
                              cv_cid              = cv_cid
                          ).

                          IF ev_error = abap_on.
                            EXIT.

                          ENDIF.

                        ENDIF.

                      ENDLOOP.

                    WHEN OTHERS. "presumably structure
                      ASSIGN <fs_test_data_t> TO <fs_test_data>.

                      IF lv_no_operation = abap_off. "Operation is allowed
*                       Increment current %CID as number by 1
*                       Pass current %CID as number to next %CID_REF as number
                        CASE iv_op.
                          WHEN if_abap_behv=>op-m-create
                            OR if_abap_behv=>op-m-action.
                            cv_cid      = cv_cid + 1.
                            lv_cid_ref  = cv_cid.

                        ENDCASE.

*                       fill_child_entry.
                        me->fill_child_entry(
                          EXPORTING
                            it_permissions      = it_permissions
                            is_step_data        = is_step_data
                            is_parent_instance  = is_parent_instance  "EML instance operation of the parent ( because here we have keys from level 1 to level -2 )
                            is_test_data        = <fs_test_data>      "TDO data of the current entity instance ( = current child )
                            is_p_test_data      = is_test_data        "TDO data of the parent entity instance ( because here we have the key of level -1 ). Needed for READ and sometimes for CREATE w/ %PID
                            iv_op               = iv_op
                            iv_name             = lv_name
                            iv_instance_no      = iv_instance_no
                            iv_cid_ref          = lv_cid "iv_cid_ref
                            iv_cid              = cv_cid
                            iv_partial          = iv_partial
                          IMPORTING
                            er_instance         = lr_instance
                            ev_error            = ev_error
                          CHANGING
                            cs_operation        = <fs_operation> "ls_operation
                        ).

                        IF ev_error = abap_on.
                          EXIT.

                        ENDIF.

                        ASSIGN lr_instance->* TO <fs_instance>.

*                       Recursive fill entry
                        me->recursive_fill_entry(
                          EXPORTING
                            iv_op               = iv_op
                            iv_p_op_r           = iv_p_op_r
                            iv_name             = lv_name
                            iv_instance_no      = iv_instance_no
                            iv_cid_ref          = lv_cid_ref "iv_cid_ref
                            iv_partial          = iv_partial
                            is_step_data        = is_step_data
                            is_test_data        = <fs_test_data> "TDO data of the current entity instance ( = current child )
                            is_p_test_data      = is_test_data   "TDO data of the parent entity instance ( because here we have the key of level -1 ). Only needed for READ
                            is_parent_instance  = <fs_instance>  "EML instance operation of the current instance
                            it_permissions      = it_permissions
                          IMPORTING
                            ev_error            = ev_error
                          CHANGING
                            ct_operations       = ct_operations
                            cv_cid              = cv_cid
                        ).

                        IF ev_error = abap_on.
                          EXIT.

                        ENDIF.

                      ELSE. "Operation is not allowed, don't fill child entry and jump to the next operation to be built
*                       Pass current %CID as number to next %CID_REF as number
                        CASE iv_op.
                          WHEN if_abap_behv=>op-m-create
                            OR if_abap_behv=>op-m-action.
                            lv_cid_ref = cv_cid.

                        ENDCASE.

*                       Recursive fill entry
                        me->recursive_fill_entry(
                          EXPORTING
                            iv_op               = iv_op
                            iv_p_op_r           = iv_p_op_r
                            iv_name             = lv_name
                            iv_instance_no      = iv_instance_no
                            iv_cid_ref          = lv_cid_ref "iv_cid_ref
                            iv_partial          = iv_partial
                            is_step_data        = is_step_data
                            is_test_data        = <fs_test_data>  "TDO data of the current entity instance ( = current child )
                            is_p_test_data      = is_test_data    "TDO data of the parent entity instance ( because here we have the key of level -1 ). Only needed for READ
                            it_permissions      = it_permissions
                          IMPORTING
                            ev_error            = ev_error
                          CHANGING
                            ct_operations       = ct_operations
                            cv_cid              = cv_cid
                        ).

                        IF ev_error = abap_on.
                          EXIT.

                        ENDIF.

                      ENDIF.

                  ENDCASE.

                  IF lv_no_operation = abap_off.
*                   Keep operation only if we have at least one instance
                    IF <fs_operation>-instances->* IS INITIAL.
                      DELETE ct_operations INDEX lv_line_index.

                    ENDIF.

                  ENDIF.

                ENDIF.

              ENDIF.

            CATCH cx_sy_itab_line_not_found ##NO_HANDLER.

          ENDTRY.

        ENDLOOP.

    ENDCASE.

  ENDMETHOD.


  METHOD recursive_fill_param.
    DATA: lo_structdescr    TYPE REF TO cl_abap_structdescr,
          lo_elemdescr      TYPE REF TO cl_abap_elemdescr,
          lv_funcname       TYPE funcname,
          lv_name           TYPE string,
          lv_message        TYPE string.

    FIELD-SYMBOLS: <fs_it_table>      TYPE STANDARD TABLE,
                   <fs_et_table>      TYPE STANDARD TABLE,
                   <fs_control>       TYPE any,
                   <fs_flag_control>  TYPE any,
                   <fs_is_data>       TYPE ANY,
                   <fs_es_data>       TYPE ANY.

    CLEAR: es_data, ev_error.

    DATA(lo_datadescr) = cl_abap_datadescr=>describe_by_data( es_data ).

    lv_name = iv_name.

    CASE lo_datadescr->type_kind.
      WHEN cl_abap_typedescr=>typekind_table.
        ASSIGN is_data TO <fs_it_table>.
        ASSIGN es_data TO <fs_et_table>.

        LOOP AT <fs_it_table> ASSIGNING <fs_is_data>.
          APPEND INITIAL LINE TO <fs_et_table> ASSIGNING <fs_es_data>.

          me->recursive_fill_param(
            EXPORTING
              is_data   = <fs_is_data>
              iv_name   = lv_name
            IMPORTING
              es_data   = <fs_es_data>
              ev_error  = ev_error ).
          IF ev_error = abap_on.
            EXIT.

          ENDIF.

        ENDLOOP.

        IF ev_error = abap_on.
          RETURN.

        ENDIF.

      WHEN cl_abap_typedescr=>typekind_struct1
        OR cl_abap_typedescr=>typekind_struct2. "structure
        lo_structdescr ?= cl_abap_structdescr=>describe_by_data( es_data ).

        DATA(lt_components) = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

        LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
*         Skip line if it's control
          IF <fs_component>-name = cl_abap_behv=>co_techfield_name-control.
            CONTINUE.

          ENDIF.

          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE es_data TO <fs_es_data>.
          IF sy-subrc = 0.
            ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_data TO <fs_is_data>.
            IF sy-subrc = 0.
              IF NOT iv_name IS INITIAL.
                lv_name = |{ iv_name }/{ <fs_component>-name }|.

              ELSE.
                lv_name = <fs_component>-name.

              ENDIF.

              me->recursive_fill_param(
                EXPORTING
                  is_data   = <fs_is_data>
                  iv_name   = lv_name
                IMPORTING
                  es_data   = <fs_es_data>
                  ev_error  = ev_error ).
              IF ev_error = abap_on.
                EXIT.

              ENDIF.

            ENDIF.

          ENDIF.

*         Fill control structure
          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-control OF STRUCTURE es_data TO <fs_control>.
          IF sy-subrc = 0.
            ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_control> TO <fs_flag_control>.
            IF sy-subrc = 0.
              IF <fs_es_data> IS NOT INITIAL.
                <fs_flag_control> = cl_abap_behv=>flag_changed.

              ENDIF.

            ENDIF.

          ENDIF.

        ENDLOOP.

        IF ev_error = abap_on.
          RETURN.

        ENDIF.

      WHEN OTHERS.
        TRY.
          es_data = CONV #( is_data ).

        CATCH cx_sy_conversion_error.
          me->mo_run_environment->append_log( |Error converting value '{ is_data }' to parameter field { iv_name }| ).
          ev_error = abap_on.
          RETURN.

        ENDTRY.

        lo_elemdescr ?= lo_datadescr.

        IF lo_elemdescr->edit_mask IS NOT INITIAL.
          CASE lo_elemdescr->edit_mask+2.
            WHEN 'ALPHA' OR 'ISOLA'." OR 'CUNIT'.
              IF lo_elemdescr->edit_mask+2 = 'ALPHA'. "ALPHA dumps if the length of the input field is longer than allowed
                IF lo_elemdescr->type_kind = cl_abap_typedescr=>typekind_char
                  OR lo_elemdescr->type_kind = cl_abap_typedescr=>typekind_num.
                  IF strlen( is_data ) > strlen( es_data ).
                    me->mo_run_environment->append_log( |Parameter { iv_name }: Conversion input length longer than allowed| ).

                    ev_error = abap_on.

                    RETURN.

                  ENDIF.

                ENDIF.

              ENDIF.

              lv_funcname = |CONVERSION_EXIT_{ lo_elemdescr->edit_mask+2 }_INPUT|.

              CALL FUNCTION lv_funcname
                EXPORTING
                  input  = is_data
                IMPORTING
                  output = es_data
                EXCEPTIONS
                  OTHERS = 1.
              IF sy-subrc <> 0.
                me->mo_run_environment->append_log( |Parameter { iv_name }: Conversion routine { lo_elemdescr->edit_mask+2 } raised an error| ).

                MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO lv_message.
                me->mo_run_environment->append_log( |Error message { sy-msgid }({ sy-msgno }): { lv_message }| ).

              ELSE.
                IF is_data = es_data.
                  me->mo_run_environment->append_log( |Parameter { iv_name }: Conversion routine { lo_elemdescr->edit_mask+2 } applied, no effect| ).

                ELSE.
                  me->mo_run_environment->append_log( |Parameter { iv_name }: Conversion routine { lo_elemdescr->edit_mask+2 } applied| ).
                  me->mo_run_environment->append_log( |From external format { is_data } to internal format { es_data }| ).

                ENDIF.

              ENDIF.

          ENDCASE.

        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD SET_DRAFT.
    CLEAR ev_error.

    IF iv_is_draft  = abap_on.
      CASE iv_op.
        WHEN if_abap_behv=>op-m-create
          OR if_abap_behv=>op-m-update
          OR if_abap_behv=>op-m-delete.
          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-is_draft OF STRUCTURE cs_dyn_row TO FIELD-SYMBOL(<fs_is_draft>).
          IF sy-subrc = 0.
*           Check if root entity is draft enabled
            me->mo_ptf_rap_validate_tdo->check_entity_has_draft(
              EXPORTING
                iv_name       = iv_name
              IMPORTING
                ev_draft_name = DATA(lv_draft_name)
                ev_error      = ev_error
            ).
            IF ev_error = abap_on.
              RETURN.

            ENDIF.

            me->mo_run_environment->append_log( |Root entity { iv_root } is draft enabled| ).
            me->mo_run_environment->append_log( |Draft table name: { lv_draft_name }| ).

            <fs_is_draft> = cl_abap_behv=>flag_changed.

          ENDIF.

      ENDCASE.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
