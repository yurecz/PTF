class CL_PTF_BO_RAP_GENERIC definition
  public
  inheriting from CL_PTF_BO
  create public .

public section.

  methods CHECK_IF_EXISTS
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods RETRIEVE
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods RETRIEVE_ALL
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ENTITY_ACTION
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods COMMIT
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods MODIFY
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CONSTRUCTOR
    importing
      !IV_RUN_ENVIRONMENT type ref to CL_PTF_RUN .

  methods CHANGE
    redefinition .
  methods CHECK
    redefinition .
  methods CHECK_EXISTENCE
    redefinition .
  methods CREATE
    redefinition .
  methods DELETE
    redefinition .
  methods EXECUTE_ACTION
    redefinition .
  methods EXECUTE_CHECK
    redefinition .
protected section.
private section.

  data MO_PTF_BO_RAP_GENERIC_EML type ref to IF_PTF_BO_RAP_GENERIC_EML .
  data MO_PTF_RAP_METADATA type ref to IF_PTF_RAP_METADATA .
  data MO_PTF_RAP_VALIDATE_TDO type ref to IF_PTF_RAP_VALIDATE_TDO .
  data MO_PTF_RAP_JSON_REF_PARSER type ref to IF_PTF_RAP_JSON_REF_PARSER .
  data MO_PTF_RAP_PERMISSIONS type ref to IF_PTF_RAP_PERMISSIONS .
  data MO_PTF_RAP_OPERATIONS type ref to IF_PTF_RAP_OPERATIONS .
  data MO_PTF_RAP_KEY_FINDER type ref to IF_PTF_RAP_KEY_FINDER .
  data MO_PTF_JSON_REPOSITORY type ref to IF_PTF_JSON_REPOSITORY .
  data MO_PTF_RAP_MODIFY_EXECUTOR type ref to CL_PTF_RAP_MODIFY_EXECUTOR .
  class-data MT_ROOT_ENTITIES type ABP_ENTITY_NAME_TAB .
  class-data MT_PID_MAPPED type IF_PTF_BO_RAP_GENERIC_EML=>TT_PID_MAPPED .

  methods OPERATION
    importing
      !IV_OP type ABP_BEHV_OP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ADJUST_OPERATION_CODE
    changing
      !CT_OPERATIONS type ABP_BEHV_CHANGES_TAB
      !CV_OP type ABP_BEHV_OP .
  methods GET_TEST_DATA
    importing
      !IV_STEP_NUMBER type I
    exporting
      !ES_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !ER_TEST_DATA type ref to DATA
      !EV_ERROR type ABAP_BOOL .
  methods GET_PERMISSIONS
    importing
      !IV_OP type ABP_BEHV_OP
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IS_TEST_DATA type DATA
    exporting
      !ET_PERMISSIONS type ABP_BEHV_PERMISSIONS_TAB
      !EV_ERROR type ABAP_BOOL .
  methods PROCESS_OPERATIONS
    importing
      !IV_OP type ABP_BEHV_OP
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !ET_FAILED type ABP_BEHV_RESPONSE_TAB
      !ET_MAPPED type ABP_BEHV_RESPONSE_TAB
      !ET_REPORTED_COMMIT type ABP_BEHV_RESPONSE_TAB
      !ET_MESSAGES type BAPIRETTAB
      !EV_CHECK_STATUS type ABAP_BOOL
      !EV_ERROR type ABAP_BOOL
    changing
      !CT_OPERATIONS type ABP_BEHV_CHANGES_TAB
      !CR_TEST_DATA type ref to DATA .
  methods COMMIT_ENTITIES
    importing
      !IV_SIMULATION type ABAP_BOOL default ABAP_OFF
    exporting
      !ET_REPORTED_COMMIT type ABP_BEHV_RESPONSE_TAB
      !EV_ERROR type ABAP_BOOL .
  methods CHECK_IF_SIMULATION
    importing
      !IS_TEST_DATA type DATA
    returning
      value(RV_SIMULATION) type ABAP_BOOL .
  methods CHECK_IF_COMMIT
    importing
      !IS_TEST_DATA type DATA
    returning
      value(RV_COMMIT) type ABAP_BOOL .
  methods RETRIEVE_DOCUMENT_ID
    importing
      !IV_OP type ABP_BEHV_OP
      !IT_FAILED type ABP_BEHV_RESPONSE_TAB optional
      !IT_MAPPED type ABP_BEHV_RESPONSE_TAB optional
      !IT_REPORTED_COMMIT type ABP_BEHV_RESPONSE_TAB optional
      !IT_OPERATIONS type ABP_BEHV_CHANGES_TAB optional
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP optional
      !IS_TEST_DATA type DATA optional
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_IS_PID type ABAP_BOOL .
  methods RETRIEVE_DATA
    importing
      !IT_OPERATIONS_READ type ABP_BEHV_RETRIEVALS_TAB
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
    exporting
      value(ER_DATA) type ref to DATA
      !EV_ERROR type ABAP_BOOL .
  methods CHECK_REFERENCE_STEP
    importing
      !IV_OP type ABP_BEHV_OP
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    changing
      !CS_TEST_DATA type DATA .
  methods COLLECT_PID_MAPPED
    importing
      !IS_PID_MAPPED type IF_PTF_BO_RAP_GENERIC_EML=>TS_PID_MAPPED .
  methods COLLECT_MESSAGES
    importing
      !IT_REPORTED type ABP_BEHV_RESPONSE_TAB
    changing
      !CT_MESSAGES type BAPIRETTAB .
  methods SEARCH_KEYS
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_ERROR type ABAP_BOOL
    changing
      !CR_TEST_DATA type ref to DATA .
  methods GET_CHILDENTITYNAME
    importing
      !IS_TEST_DATA type ANY
    exporting
      !EV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME .
  methods PROCESS_READ_OPERATIONS
    importing
      !IV_OP type ABP_BEHV_OP
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IS_TEST_DATA type DATA
      !IT_OPERATIONS type ABP_BEHV_CHANGES_TAB
    exporting
      !ER_TEST_DATA type ref to DATA
      !ET_MESSAGES type BAPIRETTAB
      !EV_CHECK_STATUS type ABAP_BOOL
      !EV_ERROR type ABAP_BOOL .
  methods PROCESS_OTHER_OPERATIONS
    importing
      !IV_OP type ABP_BEHV_OP
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IS_TEST_DATA type DATA
    exporting
      !ET_FAILED type ABP_BEHV_RESPONSE_TAB
      !ET_MAPPED type ABP_BEHV_RESPONSE_TAB
      !ET_REPORTED_COMMIT type ABP_BEHV_RESPONSE_TAB
      !ET_MESSAGES type BAPIRETTAB
      !EV_ERROR type ABAP_BOOL
    changing
      !CT_OPERATIONS type ABP_BEHV_CHANGES_TAB .
  methods RETRIEVE_DOC_ID_FROM_TD_INST
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IS_TEST_DATA type DATA
    changing
      !CV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB .
  methods RETRIEVE_DOC_ID_FROM_MAPPED
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IS_TEST_DATA type DATA
      !IT_MAPPED type ABP_BEHV_RESPONSE_TAB
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_IS_PID type ABAP_BOOL .
  methods RETRIEVE_DOC_ID_FROM_REP_COMM
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IT_REPORTED_COMMIT type ABP_BEHV_RESPONSE_TAB
    changing
      !CV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !CV_IS_PID type ABAP_BOOL .
  methods RETRIEVE_DOC_ID_FROM_OPS
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IT_OPERATIONS type ABP_BEHV_CHANGES_TAB
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_IS_PID type ABAP_BOOL .
  methods RETRIEVE_DOC_ID_FROM_FAILED
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IT_FAILED type ABP_BEHV_RESPONSE_TAB
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB .
  methods RETR_DOC_ID_FROM_REP_COMM_STEP
    importing
      !IT_REPORTED_COMMIT type ABP_BEHV_RESPONSE_TAB
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB .
  methods RETRIEVE_PID_MAPPED
    importing
      !IV_OP type ABP_BEHV_OP
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IT_MAPPED type ABP_BEHV_RESPONSE_TAB
      !IT_OPERATIONS type ABP_BEHV_CHANGES_TAB .
  methods RETR_DOC_ID_FROM_PID_MAPPED
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP optional
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB .
  methods BUILD_RESULTID_FROM_STRUCT
    importing
      !IV_DOC_LENGTH type I
      !IS_STRUCT type DATA
    returning
      value(RT_DOCUMENT_ID) type CL_PTF_UTIL=>TY_VBELN_TAB .
  methods GET_PARAM_RESULTS
    importing
      !IT_OPERATIONS type DATA
    exporting
      !ER_TEST_DATA type ref to DATA .
ENDCLASS.



CLASS CL_PTF_BO_RAP_GENERIC IMPLEMENTATION.


  METHOD build_resultid_from_struct.

    DATA: lo_typedescr   TYPE REF TO cl_abap_typedescr,
          lo_structdescr TYPE REF TO cl_abap_structdescr,
          lo_elemdescr   TYPE REF TO cl_abap_elemdescr,
          lv_length      TYPE i,
          lv_offset      TYPE i,
          lv_ptf_key     TYPE ptfkey.

    FIELD-SYMBOLS <fs_field>     TYPE any.

    CLEAR rt_document_id.

    lo_typedescr = cl_abap_typedescr=>describe_by_data( is_struct ).

    CASE lo_typedescr->type_kind.
      WHEN cl_abap_typedescr=>typekind_struct1
        OR cl_abap_typedescr=>typekind_struct2. "structure
        lo_structdescr ?= cl_abap_structdescr=>describe_by_data( is_struct ).
        DATA(lt_components) = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

        CLEAR: lv_ptf_key, lv_offset.

        LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
          IF <fs_component>-type->type_kind <> cl_abap_typedescr=>typekind_table
            AND <fs_component>-type->type_kind <> cl_abap_typedescr=>typekind_struct1
            AND <fs_component>-type->type_kind <> cl_abap_typedescr=>typekind_struct2.

            ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_struct TO <fs_field>.
            IF sy-subrc = 0.

*             Skip % fields
              IF <fs_component>-name CP '%*'.
                CONTINUE.
              ENDIF.

              CASE <fs_component>-type->type_kind.
                WHEN cl_abap_typedescr=>typekind_date
                  OR cl_abap_typedescr=>typekind_time.
                  lv_length = strlen( <fs_field> ).

                WHEN OTHERS.
                  lo_elemdescr ?= <fs_component>-type.
                  lv_length = lo_elemdescr->output_length.

              ENDCASE.

              IF lv_offset EQ 0 AND lv_length EQ 70.
                lv_ptf_key = <fs_field>.
                EXIT.

              ELSEIF lv_offset + lv_length + 1 <= iv_doc_length. "prevent dump

                IF lv_offset > 0.
                  lv_ptf_key+lv_offset(lv_length) = '|'.
                  lv_offset += 1.
                ENDIF.

                lv_ptf_key+lv_offset(lv_length) = <fs_field>.
                lv_offset += lv_length.

              ELSE.
                EXIT.

              ENDIF.

            ENDIF.

          ENDIF.

        ENDLOOP.

        IF lv_ptf_key IS NOT INITIAL.
          APPEND lv_ptf_key TO rt_document_id.
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD change.
    me->operation(
      EXPORTING
        iv_op               = if_abap_behv=>op-m-update
        iv_step_number      = iv_step_number
      IMPORTING
        ev_document_id      = ev_document_id
        ev_execution_status = ev_execution_status
        ev_check_status     = ev_check_status
    ).

  ENDMETHOD.


  METHOD check.
    me->operation(
      EXPORTING
        iv_op               = if_abap_behv=>op-r-read
        iv_step_number      = iv_step_number
      IMPORTING
        ev_document_id      = ev_document_id
        ev_execution_status = ev_execution_status
        ev_check_status     = ev_check_status
    ).

  ENDMETHOD.


  METHOD check_existence.
    "Cannot be implemented because we need step data to determine the bo entity
*    DATA: lt_operations TYPE abp_behv_retrievals_tab,
*          ls_operation  TYPE abp_behv_retrievals.
*
*    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
*
*    DATA(ls_pkey) = cl_abap_behvdescr=>create_data(
*                       p_name  = is_step_data-bus_obj
*                       p_op    = cl_abap_behvdescr=>op_virtual_pkey
*                       p_structure  = abap_on
*                    ).
*
*    READ ENTITIES OPERATIONS lt_operations
*      FAILED DATA(lt_failed).

  ENDMETHOD.


  METHOD check_if_commit.
    DATA: lo_typedescr TYPE REF TO cl_abap_typedescr.

    FIELD-SYMBOLS: <fs_test_data_ref>   TYPE any,
                   <fs_test_data>       TYPE any,
                   <fs_commit>          TYPE any.

*   Check if it's a table or structure
    lo_typedescr = cl_abap_typedescr=>describe_by_data( is_test_data ).

    CASE lo_typedescr->type_kind.
      WHEN cl_abap_typedescr=>typekind_table. "itab
        LOOP AT is_test_data ASSIGNING <fs_test_data_ref>.
          ASSIGN <fs_test_data_ref>->* TO <fs_test_data>.

          ASSIGN COMPONENT '_COMMIT' OF STRUCTURE <fs_test_data> TO <fs_commit>.
          IF sy-subrc = 0.
            rv_commit = CONV #( <fs_commit> ).

          ELSE.
            rv_commit = abap_on. "default value

          ENDIF.

          EXIT.

        ENDLOOP.

      WHEN cl_abap_typedescr=>typekind_struct1
        OR cl_abap_typedescr=>typekind_struct2. "structure
        ASSIGN COMPONENT '_COMMIT' OF STRUCTURE is_test_data TO <fs_commit>.
        IF sy-subrc = 0.
          rv_commit = CONV #( <fs_commit> ).

        ELSE.
          rv_commit = abap_on. "default value

        ENDIF.

   ENDCASE.

  ENDMETHOD.


  METHOD check_if_exists.
    me->execute_check(
      EXPORTING
        iv_step_number      = iv_step_number
      IMPORTING
        ev_document_id      = ev_document_id
        ev_execution_status = ev_execution_status
        ev_check_status     = ev_check_status
    ).

  ENDMETHOD.


  METHOD check_if_simulation.
    DATA: lo_typedescr TYPE REF TO cl_abap_typedescr.

    FIELD-SYMBOLS: <fs_test_data_ref>   TYPE any,
                   <fs_test_data>       TYPE any,
                   <fs_simulation>      TYPE any.

*   Check if it's a table or structure
    lo_typedescr = cl_abap_typedescr=>describe_by_data( is_test_data ).

    CASE lo_typedescr->type_kind.
      WHEN cl_abap_typedescr=>typekind_table. "itab
        LOOP AT is_test_data ASSIGNING <fs_test_data_ref>.
          ASSIGN <fs_test_data_ref>->* TO <fs_test_data>.

          ASSIGN COMPONENT '_SIMULATION' OF STRUCTURE <fs_test_data> TO <fs_simulation>.
          IF sy-subrc = 0.
            rv_simulation = CONV #( <fs_simulation> ).

          ENDIF.

          EXIT.

        ENDLOOP.

      WHEN cl_abap_typedescr=>typekind_struct1
        OR cl_abap_typedescr=>typekind_struct2. "structure
        ASSIGN COMPONENT '_SIMULATION' OF STRUCTURE is_test_data TO <fs_simulation>.
        IF sy-subrc = 0.
          rv_simulation = CONV #( <fs_simulation> ).

        ENDIF.

   ENDCASE.

  ENDMETHOD.


  METHOD check_reference_step.
    DATA: lv_ptf_key         TYPE ptfkey.

    FIELD-SYMBOLS: <fs_field>     TYPE any,
                   <fs_component> TYPE abap_componentdescr.

*   Identify the key fields
    DATA(lt_components) = me->mo_ptf_rap_metadata->get_key_fields( EXPORTING iv_name = is_step_data-bus_obj ).

*   Check if we have a previous reference step and get the key if there is one
    READ TABLE is_step_data-reference_step ASSIGNING FIELD-SYMBOL(<fs_ref_step>) INDEX 1.
    IF sy-subrc = 0.
*     Issue warning if there is more than one reference step
      IF lines( is_step_data-reference_step ) > 1.
        me->mo_run_environment->append_log( |Multiple reference steps mentioned, only the first one used: { <fs_ref_step> }| ).

      ENDIF.

      IF <fs_ref_step> IS NOT INITIAL. "It can have value 0 then we ignore this
*       Check if we have static action
        IF iv_op = if_abap_behv=>op-m-action.
          cl_abap_behv_load=>get_load(
            EXPORTING
              entity  = is_step_data-bus_obj
              all     = abap_off
            IMPORTING
              actions = DATA(lt_actions)
            RECEIVING
              result  = DATA(lv_result)
          ).
          IF lv_result <> cl_abap_behv_load=>ok.
            RETURN.

          ENDIF.

          IF line_exists( lt_actions[ name = is_step_data-action ] ).
            IF lt_actions[ name = is_step_data-action ]-properties-is_static = abap_on.
              me->mo_run_environment->append_log( 'Key values from reference step make no sense for a static action. Ignoring the reference !' ).
              RETURN.

            ENDIF.

          ENDIF.

        ENDIF.

        DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <fs_ref_step> ).

        TRY.
            lv_ptf_key = lt_ptf_keys[ 1 ].

*           Issue warning if there is more than one result id
            IF lines( lt_ptf_keys ) > 1.
              me->mo_run_environment->append_log( |Multiple ResultIDs provided by reference step { <fs_ref_step> }, only the first one used: { lv_ptf_key }| ).

            ENDIF.

            DATA(ls_ref_step_data) = me->mo_run_environment->get_step_data( iv_step_number = <fs_ref_step> ).

            CASE ls_ref_step_data-is_pid.
              WHEN abap_off.
                SPLIT lv_ptf_key AT cl_ptf_util=>gc_key_field_delimiter INTO TABLE DATA(lt_ptf_key_components).

                LOOP AT lt_components ASSIGNING <fs_component>.
                  DATA(lv_tabix) = sy-tabix.
                  READ TABLE lt_ptf_key_components ASSIGNING FIELD-SYMBOL(<fs_ptf_key_component>) INDEX lv_tabix.
                  IF sy-subrc = 0.
                    ASSIGN COMPONENT <fs_component>-name OF STRUCTURE cs_test_data TO <fs_field>.
                    IF sy-subrc = 0.
                      <fs_field> = <fs_ptf_key_component>.

                    ELSE.
                       me->mo_run_environment->append_log( |Root Entity Key { <fs_component>-name } not found in test data !| ).

                    ENDIF.

                  ENDIF.

                ENDLOOP.

                me->mo_run_environment->append_log( |Test Data Root Entity Keys overwritten from reference step { <fs_ref_step> } !| ).

              WHEN abap_on.
                ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-pid OF STRUCTURE cs_test_data TO <fs_field>.
                IF sy-subrc = 0.
                  <fs_field> = lv_ptf_key.

                  me->mo_run_environment->append_log( |Root Entity %PID filled from reference step { <fs_ref_step> } !| ).

                ELSE.
                  me->mo_run_environment->append_log( 'Test Data doesn''t have component %PID !' ).

                ENDIF.

*               Clear other keys mentioned
                LOOP AT lt_components ASSIGNING <fs_component>.
                  ASSIGN COMPONENT <fs_component>-name OF STRUCTURE cs_test_data TO <fs_field>.
                  IF sy-subrc = 0.
                    IF <fs_field> IS NOT INITIAL.
                      CLEAR <fs_field>.

                      me->mo_run_environment->append_log( |Root Entity Key component { <fs_component>-name }: cleared value as %PID is filled by reference step !| ).

                    ENDIF.

                  ENDIF.

                ENDLOOP.


            ENDCASE.

          CATCH cx_sy_itab_line_not_found.
            me->mo_run_environment->append_log( |No Document ID provided from reference step { <fs_ref_step> } !| ).
            RETURN.

        ENDTRY.

      ENDIF.

    ELSE.
*     If test data object is initial issue error
      IF cs_test_data IS INITIAL.
        me->mo_run_environment->append_log( 'No Test Data or Reference Step Provided !' ).
        RETURN.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD collect_messages.
    DATA: lo_message TYPE REF TO if_abap_behv_message, "if_t100_dyn_msg,
          ls_message TYPE bapiret2.

    FIELD-SYMBOLS: <fs_reported> TYPE abp_behv_response,
                   <fs_entries>  TYPE any,
                   <fs_entry>    TYPE any,
                   <fs_field>    TYPE any.

    LOOP AT it_reported ASSIGNING <fs_reported>.
      ASSIGN <fs_reported>-entries->* TO <fs_entries>.

      LOOP AT <fs_entries> ASSIGNING <fs_entry>.

        CLEAR: lo_message, ls_message.

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

          ls_message-type       = lo_message->if_t100_dyn_msg~msgty.

          IF ls_message-type IS INITIAL.
            ls_message-type = SWITCH #( lo_message->m_severity
              WHEN if_abap_behv_message=>severity-error       THEN 'E'
              WHEN if_abap_behv_message=>severity-warning     THEN 'W'
              WHEN if_abap_behv_message=>severity-information THEN 'I'
              WHEN if_abap_behv_message=>severity-success     THEN 'S' ).

          ENDIF.

          ls_message-id         = lo_message->if_t100_message~t100key-msgid.
          ls_message-number     = lo_message->if_t100_message~t100key-msgno.
          ls_message-message    = lo_message->if_message~get_text( ).
          ls_message-message_v1 = lo_message->if_t100_dyn_msg~msgv1.
          ls_message-message_v2 = lo_message->if_t100_dyn_msg~msgv2.
          ls_message-message_v3 = lo_message->if_t100_dyn_msg~msgv3.
          ls_message-message_v4 = lo_message->if_t100_dyn_msg~msgv4.

          APPEND ls_message TO ct_messages.

        ENDIF.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


  METHOD collect_pid_mapped.
    APPEND is_pid_mapped TO me->mt_pid_mapped.

  ENDMETHOD.


  METHOD commit.
    DATA: lv_error           TYPE abap_bool.

    "DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    CLEAR: ev_document_id, ev_execution_status, ev_check_status.

    me->commit_entities(
      IMPORTING
        et_reported_commit  = DATA(lt_reported_commit)
        ev_error            = lv_error ).

    IF lv_error = abap_on.
      RETURN.

    ENDIF.

    me->retrieve_document_id(
      EXPORTING
        iv_op               = if_abap_behv=>op-r-read
        it_reported_commit  = lt_reported_commit
        "is_step_data        = ls_step_data
      IMPORTING
        ev_document_id      = ev_document_id ).

    ev_execution_status = abap_on.

  ENDMETHOD.


  METHOD commit_entities.

    DATA: lo_message       TYPE REF TO if_abap_behv_message, "if_t100_dyn_msg, "if_message
          lt_failed_commit TYPE abp_behv_response_tab,
          lv_message       TYPE string.

    FIELD-SYMBOLS: <fs_field> TYPE any,
                   <fs_value> TYPE any.

    CLEAR ev_error.

*   it_root_entities doesn't necessary seem to be needed
*   keeping it for the time being
*   added also because I thought there is a problem when commiting without mentioning the root entities
    me->mo_ptf_bo_rap_generic_eml->commit_entities(
      EXPORTING
        iv_simulation     = iv_simulation
        it_root_entities  = me->mt_root_entities
      IMPORTING
        et_failed         = lt_failed_commit
        et_reported       = et_reported_commit
      CHANGING
        ct_pid_mapped     = me->mt_pid_mapped
    ).


    CLEAR me->mt_root_entities.


    LOOP AT et_reported_commit ASSIGNING FIELD-SYMBOL(<fs_reported_commit>).

      IF <fs_reported_commit>-entity_name IS INITIAL.
        ASSIGN <fs_reported_commit>-entries->* TO FIELD-SYMBOL(<fs_messages>).

        LOOP AT <fs_messages> ASSIGNING FIELD-SYMBOL(<fs_message>).
          lo_message = <fs_message>.

          lv_message = |({ lo_message->if_t100_dyn_msg~msgty }){ lo_message->if_message~get_text( ) }|.
          me->mo_run_environment->append_log( lv_message ).

*         Don't flag ev_error because a save can be successful even with error

        ENDLOOP.

      ELSE.
*       Std

*       Get the key fields
        DATA(lt_components) = me->mo_ptf_rap_metadata->get_key_fields( EXPORTING iv_name = <fs_reported_commit>-entity_name ).

        ASSIGN <fs_reported_commit>-entries->* TO FIELD-SYMBOL(<fs_entries_commit>).

        LOOP AT <fs_entries_commit> ASSIGNING FIELD-SYMBOL(<fs_entry_commit>).

          DATA lv_msgty TYPE symsgty.
          CLEAR lv_msgty.

          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-msg OF STRUCTURE <fs_entry_commit> TO <fs_field>.
          IF sy-subrc = 0.
            lo_message = <fs_field>.

            "find message type
            IF lo_message->if_t100_dyn_msg~msgty IS NOT INITIAL.
              lv_msgty = lo_message->if_t100_dyn_msg~msgty.
            ELSE.
              lv_msgty = SWITCH #( lo_message->m_severity
                WHEN if_abap_behv_message=>severity-error       THEN 'E'
                WHEN if_abap_behv_message=>severity-warning     THEN 'W'
                WHEN if_abap_behv_message=>severity-information THEN 'I'
                WHEN if_abap_behv_message=>severity-success     THEN 'S' ).
            ENDIF.

*           Log the key values for the message
            lv_message = |({ lv_msgty }){ lo_message->if_message~get_text( ) }(Key:|.
            LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
              ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_entry_commit> TO <fs_value>.
              IF sy-subrc = 0.
                lv_message = |{ lv_message }{ <fs_value> } |.
              ENDIF.
            ENDLOOP.
            lv_message = |{ lv_message })|.
            me->mo_run_environment->append_log( lv_message ).

            "ev_error
            IF lv_msgty <> 'S' AND lv_msgty <> 'W' AND lv_msgty <> 'I' .
              ev_error = abap_on.
            ENDIF.

          ENDIF.

        ENDLOOP.

      ENDIF.

    ENDLOOP. "et_reported_commit


    LOOP AT lt_failed_commit ASSIGNING FIELD-SYMBOL(<fs_failed_commit>).
      ASSIGN <fs_failed_commit>-entries->* TO FIELD-SYMBOL(<fs_failed_commit_entries>).

      LOOP AT <fs_failed_commit_entries> ASSIGNING FIELD-SYMBOL(<fs_failed_commit_entry>).
        ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-fail OF STRUCTURE <fs_failed_commit_entry> TO <fs_field>.
        IF sy-subrc = 0.
          ASSIGN COMPONENT 'CAUSE' OF STRUCTURE <fs_field> TO <fs_value>.
          IF sy-subrc = 0.
            me->mo_run_environment->append_log( |EML Modify Commit Technical Error: { <fs_value> }| ).
            ev_error = abap_on.
          ENDIF.
        ENDIF.
      ENDLOOP.

    ENDLOOP.


    IF ev_error EQ abap_off.

*     Log mapped entries
      LOOP AT me->mt_pid_mapped ASSIGNING FIELD-SYMBOL(<fs_pid_mapped>).
*        me->mo_run_environment->append_log( |Root Name: { <fs_pid_mapped>-root_name }| ).
        me->mo_run_environment->append_log( |Preliminary Key mapped for Root Name: { <fs_pid_mapped>-root_name }| ).

        IF <fs_pid_mapped>-pid IS NOT INITIAL.

          "Log mt_pid_mapped-PID
          me->mo_run_environment->append_log( |%PID { <fs_pid_mapped>-pid } mapped to key { <fs_pid_mapped>-key }| ).

        ELSE.

          "Assign %PRE
          CHECK <fs_pid_mapped>-r_pre IS BOUND.
          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-pre OF STRUCTURE <fs_pid_mapped>-r_pre->* TO FIELD-SYMBOL(<ls_pre>).
          CHECK sy-subrc EQ 0.

          "Log %TMP
          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-tmp OF STRUCTURE <ls_pre> TO FIELD-SYMBOL(<lv_tmp>).
          CHECK sy-subrc EQ 0.
          DATA(lo_structdescr) = cl_abap_structdescr=>describe_by_data( <lv_tmp> ).
          DATA lv_tmp_string TYPE string.
          CLEAR lv_tmp_string.
          LOOP AT CAST cl_abap_structdescr( lo_structdescr )->get_components( ) REFERENCE INTO DATA(lr_component).
            ASSIGN COMPONENT lr_component->name OF STRUCTURE <lv_tmp> TO FIELD-SYMBOL(<lv_tmp_field>).
            IF sy-subrc = 0.
              lv_tmp_string = lv_tmp_string && <lv_tmp_field>.
            ENDIF.
          ENDLOOP.
          me->mo_run_environment->append_log( |%TMP { lv_tmp_string } mapped to key { <fs_pid_mapped>-key }| ).

          "If not empty, also log %PID (from %PRE). Not relevant for *_QLTYNOTIFICATIONTP but for cases where a preliminary key is a combination of %KEY and %PID
          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-pid OF STRUCTURE <ls_pre> TO FIELD-SYMBOL(<lv_pid>).
          CHECK sy-subrc EQ 0.
          IF <lv_pid> IS NOT INITIAL.
            me->mo_run_environment->append_log( |%PID was also filled as part of the preliminary key: { <lv_pid> }.| ).
          ENDIF.

        ENDIF.

      ENDLOOP.

      me->mo_run_environment->append_log( 'Executed/committed without EML error' ).

    ENDIF.

  ENDMETHOD.


  METHOD constructor.
    super->constructor( iv_run_environment ).

    me->mo_ptf_bo_rap_generic_eml   = NEW cl_ptf_bo_rap_generic_eml( ).
    me->mo_ptf_rap_metadata         = NEW cl_ptf_rap_metadata( ).
    me->mo_ptf_rap_validate_tdo     = NEW cl_ptf_rap_validate_tdo( iv_run_environment ).
    me->mo_ptf_rap_json_ref_parser  = NEW cl_ptf_rap_json_ref_parser( iv_run_environment ).
    me->mo_ptf_rap_permissions      = NEW cl_ptf_rap_permissions( iv_run_environment ).
    me->mo_ptf_rap_operations       = NEW cl_ptf_rap_operations( iv_run_environment ).
    me->mo_ptf_rap_key_finder       = NEW cl_ptf_rap_key_finder( iv_run_environment ).
    me->mo_ptf_json_repository      = NEW cl_ptf_json_repository( ).
    me->mo_ptf_rap_modify_executor  = NEW cl_ptf_rap_modify_executor(
      io_run_environment = me->mo_run_environment
      io_eml             = me->mo_ptf_bo_rap_generic_eml
      io_operations      = me->mo_ptf_rap_operations ).

  ENDMETHOD.


  METHOD create.
    me->operation(
      EXPORTING
        iv_op               = if_abap_behv=>op-m-create
        iv_step_number      = iv_step_number
      IMPORTING
        ev_document_id      = ev_document_id
        ev_execution_status = ev_execution_status
        ev_check_status     = ev_check_status
    ).

  ENDMETHOD.


  METHOD delete.
    me->operation(
      EXPORTING
        iv_op               = if_abap_behv=>op-m-delete
        iv_step_number      = iv_step_number
      IMPORTING
        ev_document_id      = ev_document_id
        ev_execution_status = ev_execution_status
        ev_check_status     = ev_check_status
    ).

  ENDMETHOD.


  METHOD entity_action.
    me->execute_action(
      EXPORTING
        iv_step_number      = iv_step_number
      IMPORTING
        ev_document_id      = ev_document_id
        ev_execution_status = ev_execution_status
        ev_check_status     = ev_check_status
    ).

  ENDMETHOD.


  METHOD execute_action.
    me->operation(
      EXPORTING
        iv_op               = if_abap_behv=>op-m-action
        iv_step_number      = iv_step_number
      IMPORTING
        ev_document_id      = ev_document_id
        ev_execution_status = ev_execution_status
        ev_check_status     = ev_check_status
    ).

  ENDMETHOD.


  METHOD execute_check.
    me->operation(
      EXPORTING
        iv_op               = if_abap_behv=>op-r-read
        iv_step_number      = iv_step_number
      IMPORTING
        ev_document_id      = ev_document_id
        ev_execution_status = ev_execution_status
        ev_check_status     = ev_check_status
    ).

  ENDMETHOD.


  METHOD get_childentityname.
    DATA: lo_typedescr TYPE REF TO cl_abap_typedescr.

    FIELD-SYMBOLS: <fs_test_data_ref>   TYPE any,
                   <fs_test_data>       TYPE any,
                   <fs_childentityname> TYPE any.

    CLEAR: ev_name.

*   Check if it's a table or structure
    lo_typedescr = cl_abap_typedescr=>describe_by_data( is_test_data ).

    CASE lo_typedescr->type_kind.
      WHEN cl_abap_typedescr=>typekind_table. "itab
        LOOP AT is_test_data ASSIGNING <fs_test_data_ref>.
          ASSIGN <fs_test_data_ref>->* TO <fs_test_data>.

          EXIT.

        ENDLOOP.

      WHEN cl_abap_typedescr=>typekind_struct1
        OR cl_abap_typedescr=>typekind_struct2. "structure
        ASSIGN is_test_data TO <fs_test_data>.

    ENDCASE.

*   Check if we have childentity mentioned
    ASSIGN COMPONENT '_CHILDENTITYNAME' OF STRUCTURE <fs_test_data> TO <fs_childentityname>.
    IF sy-subrc = 0.
      ev_name = <fs_childentityname>.

    ENDIF.

  ENDMETHOD.


  METHOD get_permissions.
    DATA lt_failed_perm_sum TYPE abp_behv_response_tab.
    DATA lv_name            TYPE cl_abap_behvdescr=>t_typename.

    CLEAR: et_permissions, ev_error.

    lv_name = is_step_data-bus_obj.

    me->get_childentityname(
          EXPORTING
            is_test_data = is_test_data
          IMPORTING
            ev_name      = DATA(lv_childentityname) ).
    IF lv_childentityname IS NOT INITIAL.
      lv_name = lv_childentityname.

    ENDIF.

*   Get also the key components as they might be missing from the TDO
    DATA(lt_key_components) = me->mo_ptf_rap_metadata->get_key_fields( EXPORTING iv_name = lv_name ). "is_step_data-bus_obj

    me->mo_ptf_rap_permissions->build_permissions(
      EXPORTING
        iv_op           = iv_op
        is_step_data    = is_step_data
        is_test_data    = is_test_data
      IMPORTING
        ev_error        = ev_error
      CHANGING
        ct_permissions  = et_permissions
    ).

    IF ev_error = abap_on.
      RETURN.

    ENDIF.

*   GET PERMISSIONS Dynamic EML statement only works with entities belonging to the same root node
*   So we have to group the permissions
    me->mo_ptf_rap_permissions->group_permissions(
      EXPORTING
        it_permissions         = et_permissions
      IMPORTING
        et_permissions_grouped = DATA(lt_permissions_grouped)
    ).

    CLEAR et_permissions.

    LOOP AT lt_permissions_grouped ASSIGNING FIELD-SYMBOL(<ls_permissions_grouped>).
      me->mo_ptf_bo_rap_generic_eml->get_permissions(
        IMPORTING
          et_failed     = DATA(lt_failed_perm)
          "et_reported   = DATA(lt_reported_perm)
        CHANGING
          ct_operations = <ls_permissions_grouped>-permissions
      ).

      INSERT LINES OF lt_failed_perm INTO TABLE lt_failed_perm_sum.
      APPEND LINES OF <ls_permissions_grouped>-permissions TO et_permissions.

    ENDLOOP.

    me->mo_ptf_rap_permissions->handle_permissions_error(
      EXPORTING
        it_failed      = lt_failed_perm_sum
        it_components  = lt_key_components
      IMPORTING
        ev_error       = ev_error
    ).
    IF ev_error = abap_on.
      RETURN.

    ENDIF.

  ENDMETHOD.


  METHOD get_test_data.

    CLEAR: er_test_data, ev_error.

    es_step_data = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

*   Build TDO from TDC
    IF es_step_data-test_data_container IS NOT INITIAL.

      TRY.
          DATA(lo_ptf_util) = NEW cl_ptf_util(
              iv_tdc       = es_step_data-test_data_container
              iv_tdcv_name = es_step_data-variant
              iv_bo        = es_step_data-bus_obj
              iv_action    = es_step_data-action ).
        CATCH cx_ecatt_tdc_access.
          cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~set_tdc_error( abap_true ).
          ev_error = abap_on.
          RETURN.
      ENDTRY.

      DATA(lv_tdc) = lo_ptf_util->get_tdc_name( ).
      DATA(lv_tdcp) = lo_ptf_util->get_tdcp_name(  ).

      TRY.
          DATA(lo_access_tdc) = cl_apl_ecatt_tdc_api=>get_instance( CONV #( lv_tdc ) ).
        CATCH cx_ecatt_tdc_access.
          cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~set_tdc_error( abap_true ).
          ev_error = abap_on.
          RETURN.

      ENDTRY.

      TRY.
          DATA(lv_type) = lo_access_tdc->get_param_definition( i_param_name = CONV #( lv_tdcp ) ).

        CATCH cx_ecatt_tdc_access.
          cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~set_tdc_error( abap_true ).
          ev_error = abap_on.
          RETURN.

      ENDTRY.

      CREATE DATA er_test_data TYPE (lv_type).

      TRY.
          lo_access_tdc->get_value_ref(
            EXPORTING
              i_param_name   = CONV #( lv_tdcp )
              i_variant_name = CONV #( es_step_data-variant )
              "i_path         = i_path
            CHANGING
              e_param_ref    = er_test_data ).

        CATCH cx_ecatt_tdc_access.
          cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~set_tdc_error( abap_true ).
          ev_error = abap_on.
          RETURN.

      ENDTRY.

*     In the future we will have to check er_test_data if it references an internal table for multiple instances
*     or a structure for one instance
*     If we have an internal table then we will have to change it in an internal table with line type of data reference
*     Added new OR condition if reference_step is not initial
*     This is put in the case when the user doesn't fill JSON but uses a RAP Object with reference step so an ABAP object
*     still has to be generated

*   Build TDO from input JSON or JSON Repository
    ELSEIF es_step_data-variant IS NOT INITIAL OR es_step_data-json_file IS NOT INITIAL
      OR es_step_data-reference_step IS NOT INITIAL.

*     Create test data from JSON file instructions
      DATA lr_data TYPE REF TO data ##NEEDED.
      CREATE DATA er_test_data LIKE lr_data.

*     Get local JSON
      DATA(lv_json_file) = es_step_data-json_file.

*     Load JSON from Repository instead of local JSON if available
      IF es_step_data-variant IS NOT INITIAL.
        TRY.
          DATA(ls_ptf_input_repo) = me->mo_ptf_json_repository->load( CONV #( es_step_data-variant ) ).
          lv_json_file = ls_ptf_input_repo-input_string.
        CATCH cx_ptf_json_repository ##NO_HANDLER.
          me->mo_run_environment->append_log( |Error loading from JSON Repository, JSON ID { es_step_data-variant } is invalid !| ).
        ENDTRY.
      ENDIF.


      TRY.
        cl_ptf_json=>deserialize(
          EXPORTING
            iv_entity = es_step_data-bus_obj
            iv_action = es_step_data-action
            iv_json   = lv_json_file
          IMPORTING
            er_data   = er_test_data ).

      CATCH cx_ptf_json INTO DATA(lx_ptf_json).
        me->mo_run_environment->append_log( lx_ptf_json->get_text( ) ).

        IF lx_ptf_json->offset IS NOT INITIAL.
          me->mo_run_environment->append_log( |Source code position: { lx_ptf_json->offset }| ).

        ENDIF.

        ev_error = abap_on.

      ENDTRY.

*   Last fallback class when there is no JSON and no reference step mentioned
    ELSEIF es_step_data-bus_obj IS NOT INITIAL.
      CREATE DATA er_test_data TYPE (es_step_data-bus_obj).

    ENDIF.

  ENDMETHOD.


  METHOD modify.
*   MODIFY action delegates to dedicated executor
    me->mo_ptf_rap_modify_executor->execute(
      EXPORTING
        iv_step_number      = iv_step_number
      IMPORTING
        ev_document_id      = ev_document_id
        ev_execution_status = ev_execution_status
        ev_check_status     = ev_check_status
    ).
  ENDMETHOD.


  METHOD operation.
    DATA: lr_test_data TYPE REF TO data,
          lv_error     TYPE abap_bool.

    FIELD-SYMBOLS: <fs_test_data> TYPE any.

    CLEAR: ev_document_id, ev_execution_status, ev_check_status.

*   Get test data
    me->get_test_data(
      EXPORTING
        iv_step_number  = iv_step_number
      IMPORTING
        es_step_data    = DATA(ls_step_data)
        er_test_data    = lr_test_data
        ev_error        = lv_error ).

    IF lv_error = abap_on.
      RETURN.

    ENDIF.

    ASSIGN lr_test_data->* TO <fs_test_data>.

*   Parse references
    me->mo_ptf_rap_json_ref_parser->parse_references(
      EXPORTING
        iv_entity_name  = ls_step_data-bus_obj
        iv_step_number  = iv_step_number
      IMPORTING
        ev_error        = lv_error
      CHANGING
        cs_test_data    = <fs_test_data> ).

    IF lv_error = abap_on.
      RETURN.

    ENDIF.

*   Check ALV reference step
    me->check_reference_step(
      EXPORTING
        iv_op        = iv_op
        is_step_data = ls_step_data
      CHANGING
        cs_test_data = <fs_test_data> ).

*   Apply free search to find keys of root instances if applicable ( RETRIEVE_ALL & CHECK_IF_EXISTS; root key not given)
    me->search_keys(
      EXPORTING
        is_step_data  = ls_step_data
      IMPORTING
        ev_error      = lv_error
      CHANGING
        cr_test_data  = lr_test_data ).

    IF lv_error = abap_on.
      RETURN.

    ENDIF.

    ASSIGN lr_test_data->* TO <fs_test_data>. "Make the assignment again becaue FS keeps pointing to the original values

*   Get permissions
    me->get_permissions(
      EXPORTING
        iv_op           = iv_op
        is_step_data    = ls_step_data
        is_test_data    = <fs_test_data>
      IMPORTING
        et_permissions  = DATA(lt_permissions)
        ev_error        = lv_error ).

    IF lv_error = abap_on.
      RETURN.

    ENDIF.

*   Build the actual operations
    me->mo_ptf_rap_operations->build_operations(
      EXPORTING
        iv_op           = iv_op
        is_step_data    = ls_step_data
        is_test_data    = <fs_test_data>
        it_permissions  = lt_permissions
      IMPORTING
        et_operations   = DATA(lt_operations)
        ev_error        = lv_error
     ).

    IF lv_error = abap_on.
      RETURN.

    ENDIF.

    DATA(lv_op) = iv_op.

    me->adjust_operation_code(
      CHANGING
        ct_operations = lt_operations
        cv_op         = lv_op ).

    me->process_operations(
      EXPORTING
        iv_op               = lv_op
        is_step_data        = ls_step_data
      IMPORTING
        et_failed           = DATA(lt_failed)
        et_mapped           = DATA(lt_mapped)
        et_reported_commit  = DATA(lt_reported_commit)
        et_messages         = ls_step_data-act_messages
        ev_check_status     = ev_check_status
        ev_error            = lv_error
      CHANGING
        ct_operations       = lt_operations
        cr_test_data        = lr_test_data ).

*   Set messages
    IF ls_step_data-act_messages IS NOT INITIAL.
      DATA lt_act_messages TYPE ptf_t100_message_t.
      MOVE-CORRESPONDING ls_step_data-act_messages TO lt_act_messages.
      cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~add_actual_messages( lt_act_messages ).
    ENDIF.

*    We can have a commit that returns both an error message and a key
*    IF lv_error = abap_on.
*      RETURN.
*
*    ENDIF.

    ASSIGN lr_test_data->* TO <fs_test_data>.

    me->retrieve_document_id(
      EXPORTING
        iv_op               = iv_op
        it_failed           = lt_failed
        it_mapped           = lt_mapped
        it_reported_commit  = lt_reported_commit
        it_operations       = lt_operations
        is_step_data        = ls_step_data
        is_test_data        = <fs_test_data>
      IMPORTING
        ev_document_id      = ev_document_id
        ev_is_pid           = ls_step_data-is_pid ).

*   We can have a commit that returns both an error message and a key
    IF lv_error = abap_on.
      RETURN.

    ENDIF.

    ev_execution_status = abap_on.

*   Set data object json
    ls_step_data-data_object_json = /ui2/cl_json=>serialize(
                                      EXPORTING
                                        data          = <fs_test_data>
                                        assoc_arrays  = abap_on
                                        "format_output = abap_on
    ).

    cl_ptf_json=>pretty_printer_tdo(
      CHANGING
        cv_json = ls_step_data-data_object_json
    ).


    me->mo_run_environment->set_step_data(                         "updates tdo and is_pid
                              EXPORTING
                                iv_step_number = iv_step_number
                                step_data      = ls_step_data ).

*    CASE ls_step_data-action.
*      WHEN 'CHECK'.
*        ev_check_status = abap_on.
*
*    ENDCASE.

  ENDMETHOD.


  METHOD process_operations.
    FIELD-SYMBOLS: <fs_test_data> TYPE any.

    CLEAR: et_failed, et_mapped, et_reported_commit, et_messages,
           ev_check_status, ev_error.

    ASSIGN cr_test_data->* TO <fs_test_data>.

    CASE iv_op.
      WHEN if_abap_behv=>op-r-read
        OR if_abap_behv=>op-r-evaluate.
        me->process_read_operations(
          EXPORTING
            iv_op           = iv_op
            is_step_data    = is_step_data
            is_test_data    = <fs_test_data>
            it_operations   = ct_operations
          IMPORTING
            er_test_data    = cr_test_data
            et_messages     = et_messages
            ev_check_status = ev_check_status
            ev_error        = ev_error
        ).

      WHEN OTHERS.
        me->process_other_operations(
          EXPORTING
            iv_op               = iv_op
            is_step_data        = is_step_data
            is_test_data        = <fs_test_data>
          IMPORTING
            et_failed           = et_failed
            et_mapped           = et_mapped
            et_reported_commit  = et_reported_commit
            et_messages         = et_messages
            ev_error            = ev_error
          CHANGING
            ct_operations       = ct_operations
        ).

    ENDCASE.

  ENDMETHOD.


  METHOD process_other_operations.
    DATA: lt_operations_read TYPE abp_behv_retrievals_tab,
          lt_failed_read     TYPE abp_behv_response_tab,
          lt_reported_read   TYPE abp_behv_response_tab.

    CLEAR: et_failed, et_mapped, et_reported_commit, et_messages, ev_error.

*   Check if we are in simulation mode
    DATA(lv_simulation) = me->check_if_simulation( is_test_data ).

*   Check if we are in commit mode
    DATA(lv_commit) = me->check_if_commit( is_test_data ).

*   Fill list of root entities
    IF NOT line_exists( me->mt_root_entities[ table_line = is_step_data-bus_obj ] ).
      INSERT is_step_data-bus_obj INTO TABLE me->mt_root_entities.

    ENDIF.

*   Call EML MODIFY
    me->mo_ptf_bo_rap_generic_eml->modify_entities(
      IMPORTING
        et_failed     = et_failed
        et_mapped     = et_mapped
        et_reported   = DATA(lt_reported)
      CHANGING
        ct_operations = ct_operations
    ).

*   Retrieve %PIDs
    me->retrieve_pid_mapped(
      iv_op         = iv_op
      is_step_data  = is_step_data
      it_mapped     = et_mapped
      it_operations = ct_operations
    ).

*   Collect messages
    me->collect_messages(
      EXPORTING
        it_reported = lt_reported
      CHANGING
        ct_messages = et_messages ).

*   Read possible errors
    me->mo_ptf_rap_operations->handle_operations_error(        "messages that MODIFY ENTITIES returned in REPORTED will be added to the log already here
      EXPORTING
        it_failed   = et_failed
        it_mapped   = et_mapped
        it_reported = lt_reported
      IMPORTING
        ev_error    = ev_error
     ).

    IF ev_error = abap_on.
*     Read state messages
      me->mo_ptf_rap_operations->convert_to_operations_read(
        EXPORTING
          iv_op               = iv_op
          it_operations       = ct_operations
        IMPORTING
          et_operations_read  = lt_operations_read
      ).

      me->mo_ptf_bo_rap_generic_eml->read_entities(
        IMPORTING
          et_failed     = lt_failed_read
          et_reported   = lt_reported_read
        CHANGING
          ct_operations = lt_operations_read
      ).

*     Collect messages
      me->collect_messages(
        EXPORTING
          it_reported = lt_reported_read
        CHANGING
          ct_messages = et_messages ).

      me->mo_ptf_rap_operations->handle_operations_error(
        EXPORTING
          it_failed   = lt_failed_read
          it_reported = lt_reported_read
          iv_is_read  = abap_on
      ).

      RETURN.

    ENDIF.

*   Call EML COMMIT ENTITIES if flag COMMIT is true
    IF lv_commit = abap_on.
      me->commit_entities(        "messages that COMMIT ENTITIES returned in REPORTED will be added to the log already here
        EXPORTING
          iv_simulation       = lv_simulation
        IMPORTING
          et_reported_commit  = et_reported_commit
          ev_error            = ev_error ).

*     Collect messages
      me->collect_messages(
        EXPORTING
          it_reported = et_reported_commit
        CHANGING
          ct_messages = et_messages ).

    ELSE.
      me->mo_run_environment->append_log( 'No commit executed for this step, "commit":false was set !' ).

    ENDIF.

  ENDMETHOD.


  METHOD process_read_operations.
    DATA: lt_operations_read TYPE abp_behv_retrievals_tab,
          lt_failed_read     TYPE abp_behv_response_tab,
          lt_reported_read   TYPE abp_behv_response_tab.

    CLEAR: er_test_data, et_messages, ev_check_status, ev_error.

    me->mo_ptf_rap_operations->convert_to_operations_read(
      EXPORTING
        iv_op               = iv_op
        it_operations       = it_operations
      IMPORTING
        et_operations_read  = lt_operations_read
    ).

    CASE is_step_data-action.
      WHEN 'RETRIEVE_ALL'.
        me->mo_ptf_bo_rap_generic_eml->read_all_entities(
          CHANGING
            ct_failed     = lt_failed_read
            ct_reported   = lt_reported_read
            ct_operations = lt_operations_read
        ).

      WHEN OTHERS.
        me->mo_ptf_bo_rap_generic_eml->read_entities(
          IMPORTING
            et_failed     = lt_failed_read
            et_reported   = lt_reported_read
          CHANGING
            ct_operations = lt_operations_read
        ).

        me->mo_ptf_rap_operations->filter_operations(
          EXPORTING
            is_test_data  = is_test_data
            iv_name       = is_step_data-bus_obj
            iv_action     = is_step_data-action
          IMPORTING
            ev_error      = ev_error
          CHANGING
            ct_operations = lt_operations_read
        ).

        IF ev_error = abap_on.
          RETURN.

        ENDIF.

    ENDCASE.

    me->mo_ptf_rap_operations->handle_operations_error(
      EXPORTING
        it_failed     = lt_failed_read
        it_reported   = lt_reported_read
        is_step_data  = is_step_data
        "iv_is_read    = abap_on
      IMPORTING
        ev_error      = ev_error
    ).

*   Collect messages
    me->collect_messages(
      EXPORTING
        it_reported = lt_reported_read
      CHANGING
        ct_messages = et_messages ).

*       Skip this error flag if we have checks because we could have negative checks
    IF is_step_data-action <> 'CHECK' AND is_step_data-action <> 'CHECK_IF_EXISTS'.
      IF ev_error = abap_on.
        RETURN.

      ENDIF.

    ENDIF.

    CASE is_step_data-action.
      WHEN 'CHECK'.
*       Check the data
        me->mo_ptf_rap_validate_tdo->check_data(
          EXPORTING
            is_test_data        = is_test_data
            it_operations_read  = lt_operations_read
            iv_name             = is_step_data-bus_obj
          IMPORTING
            ev_error            = ev_error ).

        IF ev_error = abap_off.
          ev_check_status = abap_on.

          me->mo_run_environment->append_log( 'Data was checked successfully !' ).

        ENDIF.

      WHEN 'CHECK_IF_EXISTS'.
*       Check the data
        me->mo_ptf_rap_validate_tdo->check_data(
          EXPORTING
            is_test_data        = is_test_data
            it_operations_read  = lt_operations_read
            iv_name             = is_step_data-bus_obj
            iv_check_only_keys  = abap_on
          IMPORTING
            ev_error            = ev_error ).

        IF ev_error = abap_off.
          ev_check_status = abap_on.

          me->mo_run_environment->append_log( 'Entity existence checked successfully !' ).

        ENDIF.

      WHEN 'RETRIEVE' OR 'RETRIEVE_ALL'.
*       Build the new TDO
        me->retrieve_data(
          EXPORTING
            it_operations_read = lt_operations_read
            iv_name            = is_step_data-bus_obj
          IMPORTING
            er_data            = er_test_data
            ev_error           = ev_error
        ).

        IF ev_error = abap_on.
          RETURN.

        ENDIF.

        CASE is_step_data-action.
          WHEN 'RETRIEVE_ALL'.
*            ASSIGN lt_operations_read[ entity_name = is_step_data-bus_obj sub_name = space ] TO FIELD-SYMBOL(<fs_operation_read>).
*
*            me->mo_run_environment->append_log( |Stored { lines( <fs_operation_read>-results->* ) } instance(s) of type { is_step_data-bus_obj }| ).

            me->mo_run_environment->append_log( |Stored { lines( er_test_data->* ) } instance(s) of type { is_step_data-bus_obj }| ).

          WHEN 'RETRIEVE'.
            me->mo_run_environment->append_log( |Stored the instance of type { is_step_data-bus_obj }| ).

        ENDCASE.

      WHEN OTHERS.
        IF iv_op = if_abap_behv=>op-r-evaluate.
          me->get_param_results(
            EXPORTING
              it_operations = lt_operations_read
            IMPORTING
              er_test_data  = er_test_data
          ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD RETRIEVE.
    me->operation(
      EXPORTING
        iv_op               = if_abap_behv=>op-r-read
        iv_step_number      = iv_step_number
      IMPORTING
        ev_document_id      = ev_document_id
        ev_execution_status = ev_execution_status
        ev_check_status     = ev_check_status
    ).

  ENDMETHOD.


  METHOD retrieve_all.
    me->operation(
      EXPORTING
        iv_op               = if_abap_behv=>op-r-read
        iv_step_number      = iv_step_number
      IMPORTING
        ev_document_id      = ev_document_id
        ev_execution_status = ev_execution_status
        ev_check_status     = ev_check_status
    ).

  ENDMETHOD.


  METHOD retrieve_data.
    DATA lr_data TYPE REF TO data ##NEEDED.

    CLEAR ev_error.

*   Convert read operations to TDO
    TRY.
        cl_ptf_json=>convert_operations_read(
          EXPORTING
            it_operations_read = it_operations_read
            iv_entity          = iv_name
          IMPORTING
            er_data            = er_data ).

      CATCH cx_ptf_json INTO DATA(lx_ptf_json).
        me->mo_run_environment->append_log( lx_ptf_json->get_text( ) ).
        ev_error = abap_on.

    ENDTRY.

  ENDMETHOD.


  METHOD retrieve_document_id.

    DATA lo_typedescr TYPE REF TO cl_abap_typedescr.

    FIELD-SYMBOLS: <fs_test_data_ref> TYPE any,
                   <fs_test_data>     TYPE any.

    CLEAR: ev_document_id, ev_is_pid.

*   Try to retrieve document ID from %PID MAPPED stored in me->mt_pid_mapped
    me->retr_doc_id_from_pid_mapped(
      EXPORTING
        is_step_data   = is_step_data
      IMPORTING
        ev_document_id = ev_document_id
    ).

*   If document ID was found in PID mapped then don't continue execution
    IF ev_document_id IS NOT INITIAL.
      RETURN.
    ENDIF.

    "For function, change operation to E ( = Evaluate = Function invocation )
    DATA(lv_op) = iv_op.
    DATA(lt_operations) = it_operations.
    me->adjust_operation_code(
      CHANGING
        ct_operations = lt_operations "here only input, not used afterwards
        cv_op         = lv_op
    ).


    IF is_step_data IS SUPPLIED.
      "retrieve_document_id() was called at step level

*     Look into mapped for create/action operation or in test data for change/delete/read/function

      CASE lv_op.
        WHEN if_abap_behv=>op-m-create
          OR if_abap_behv=>op-m-action.
          me->retrieve_doc_id_from_mapped(
            EXPORTING
              is_step_data   = is_step_data
              is_test_data   = is_test_data
              it_mapped      = it_mapped
            IMPORTING
              ev_document_id = ev_document_id
              ev_is_pid      = ev_is_pid
          ).

        WHEN if_abap_behv=>op-m-update
          OR if_abap_behv=>op-m-delete
          OR if_abap_behv=>op-r-read
          OR if_abap_behv=>op-r-evaluate.
          IF is_test_data IS SUPPLIED.
*           Check if it's a table or structure
            lo_typedescr = cl_abap_typedescr=>describe_by_data( is_test_data ).

            CASE lo_typedescr->type_kind.
              WHEN cl_abap_typedescr=>typekind_table. "itab
                LOOP AT is_test_data ASSIGNING <fs_test_data_ref>.
                  ASSIGN <fs_test_data_ref>->* TO <fs_test_data>.

                  me->retrieve_doc_id_from_td_inst(
                    EXPORTING
                      is_step_data    = is_step_data
                      is_test_data    = <fs_test_data>
                    CHANGING
                      cv_document_id  = ev_document_id
                  ).

                ENDLOOP.

              WHEN cl_abap_typedescr=>typekind_struct1
                OR cl_abap_typedescr=>typekind_struct2. "structure
                  me->retrieve_doc_id_from_td_inst(
                    EXPORTING
                      is_step_data    = is_step_data
                      is_test_data    = is_test_data
                    CHANGING
                      cv_document_id  = ev_document_id
                  ).

            ENDCASE.
          ENDIF.

      ENDCASE.

*     Look into reported commit if ev_document_id is still empty or we have pid
      IF ev_document_id IS INITIAL OR ev_is_pid = abap_on.
        CASE iv_op.
          WHEN if_abap_behv=>op-m-create
            OR if_abap_behv=>op-m-action.
            me->retrieve_doc_id_from_rep_comm(
              EXPORTING
                is_step_data        = is_step_data
                it_reported_commit  = it_reported_commit
              CHANGING
                cv_document_id      = ev_document_id
                cv_is_pid           = ev_is_pid
            ).

        ENDCASE.

      ENDIF.

*     Look into operations results pid if ev_document_id is still empty in case of action
*     This call was built for non factory actions that have the document id in operation result
      IF iv_op = if_abap_behv=>op-m-action AND ev_document_id IS INITIAL.

        me->retrieve_doc_id_from_ops(
          EXPORTING
            is_step_data    = is_step_data
            it_operations   = it_operations
          IMPORTING
            ev_document_id  = ev_document_id
            ev_is_pid       = ev_is_pid
        ).

*       Look into failed if ev_document_id is still empty in case of action
        IF ev_document_id IS INITIAL.
          me->retrieve_doc_id_from_failed(
            EXPORTING
              is_step_data    = is_step_data
              it_failed       = it_failed
            IMPORTING
              ev_document_id  = ev_document_id
          ).
        ENDIF.

      ENDIF.


    ELSE.
      "retrieve_document_id() was not called at step level but from method commit()
      me->retr_doc_id_from_rep_comm_step(
        EXPORTING
          it_reported_commit = it_reported_commit
        IMPORTING
          ev_document_id     = ev_document_id
      ).

    ENDIF.

  ENDMETHOD.


  METHOD retrieve_doc_id_from_failed.
    DATA: lv_ptf_key      TYPE ptfkey.

    FIELD-SYMBOLS: <fs_field> TYPE any.

    CLEAR ev_document_id.

*   Identify the key fields
    DATA(lt_components) = me->mo_ptf_rap_metadata->get_key_fields( EXPORTING iv_name = is_step_data-bus_obj ).

    IF line_exists( it_failed[ entity_name = is_step_data-bus_obj ] ).  "#EC CI_SORTSEQ
      DATA(lr_failed_entries) = it_failed[ entity_name = is_step_data-bus_obj ]-entries. "#EC CI_SORTSEQ

      ASSIGN lr_failed_entries->* TO FIELD-SYMBOL(<fs_failed_entries>).

      LOOP AT <fs_failed_entries> ASSIGNING FIELD-SYMBOL(<fs_failed_entry>).
        CLEAR lv_ptf_key.

        LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
          DATA(lv_tabix) = sy-tabix.

          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_failed_entry> TO <fs_field>.
          IF <fs_field> IS NOT INITIAL.
            IF lv_tabix = 1.
              lv_ptf_key = <fs_field>.

            ELSE.
              lv_ptf_key = |{ lv_ptf_key }{ cl_ptf_util=>gc_key_field_delimiter }{ <fs_field> }|.

            ENDIF.

          ENDIF.

        ENDLOOP.

        IF lv_ptf_key IS NOT INITIAL.
          IF NOT line_exists( ev_document_id[ table_line = lv_ptf_key ] ) ##WARN_OK.
            APPEND lv_ptf_key TO ev_document_id.

          ENDIF.

        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD retrieve_doc_id_from_mapped.
    DATA: lv_ptf_key            TYPE ptfkey.

    FIELD-SYMBOLS: <fs_entries> TYPE STANDARD TABLE,
                   <fs_field>   TYPE any.

    CLEAR: ev_document_id, ev_is_pid.

*   Identify the key fields
    DATA(lt_components) = me->mo_ptf_rap_metadata->get_key_fields( EXPORTING iv_name = is_step_data-bus_obj ).

    IF line_exists( it_mapped[ entity_name = is_step_data-bus_obj ] ). "#EC CI_SORTSEQ
      DATA(lr_entries) = it_mapped[ entity_name = is_step_data-bus_obj ]-entries. "#EC CI_SORTSEQ

      ASSIGN lr_entries->* TO <fs_entries>.

      READ TABLE <fs_entries> ASSIGNING FIELD-SYMBOL(<fs_entry>) INDEX 1.

      LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
        DATA(lv_tabix) = sy-tabix.

        ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_entry> TO <fs_field>.

        IF lv_tabix = 1.
          lv_ptf_key = <fs_field>.

        ELSE.
          lv_ptf_key = |{ lv_ptf_key }{ cl_ptf_util=>gc_key_field_delimiter }{ <fs_field> }|.

        ENDIF.

      ENDLOOP.

*     Don't add temporary keys (ex. R_MAINTENANCEORDERTP has %00000000001)
      IF lv_ptf_key IS NOT INITIAL AND lv_ptf_key NA '$%'.
        APPEND lv_ptf_key TO ev_document_id.

      ELSE.
        "Check if we have %PID
        IF <fs_entry> IS ASSIGNED.
          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-pid OF STRUCTURE <fs_entry> TO <fs_field>.
          IF sy-subrc = 0.
            IF <fs_field> IS NOT INITIAL.
              lv_ptf_key = <fs_field>.

              IF lv_ptf_key IS NOT INITIAL.
*               Don't issue the message if commit is true and we have test data
*               Check if we are in commit mode
                DATA(lv_commit) = me->check_if_commit( is_test_data ).

                IF lv_commit = abap_off.
                  me->mo_run_environment->append_log( |Root Entity { is_step_data-bus_obj } has %PID: { lv_ptf_key } !| ).

                ENDIF.

                APPEND lv_ptf_key TO ev_document_id.

                ev_is_pid = abap_on.

**               Collect pid mapped
*                me->collect_pid_mapped(
*                  EXPORTING
*                    is_pid_mapped = VALUE #( root_name = is_step_data-bus_obj pid = <fs_field> )
*                ).

              ENDIF.

            ENDIF.

          ENDIF.

        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD retrieve_doc_id_from_ops.
    DATA: lo_elemdescr  TYPE REF TO cl_abap_elemdescr,
          lv_ptf_key    TYPE ptfkey,
          lv_doc_length TYPE i.

    FIELD-SYMBOLS: <fs_param>     TYPE any,
                   <fs_field>     TYPE any,
                   <fs_operation> TYPE abp_behv_changes,
                   <fs_results>   TYPE STANDARD TABLE,
                   <fs_result>    TYPE any.

    CLEAR: ev_document_id, ev_is_pid.

    LOOP AT it_operations ASSIGNING <fs_operation>.
      ASSIGN <fs_operation>-results->* TO <fs_results>.

      IF <fs_results> IS ASSIGNED.
        LOOP AT <fs_results> ASSIGNING <fs_result>.
          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-param OF STRUCTURE <fs_result> TO <fs_param>.
          IF sy-subrc = 0.
            ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-pid OF STRUCTURE <fs_param> TO <fs_field>.
            IF sy-subrc = 0.
              IF <fs_field> IS NOT INITIAL.
                lv_ptf_key = <fs_field>.

                APPEND lv_ptf_key TO ev_document_id.

                ev_is_pid = abap_on.

**               Collect pid mapped
*                me->collect_pid_mapped(
*                  EXPORTING
*                    is_pid_mapped = VALUE #( root_name = is_step_data-bus_obj pid = <fs_field> )
*                ).

              ENDIF.

            ENDIF.

          ENDIF.

        ENDLOOP.

      ENDIF.

    ENDLOOP.

*   Convert all 1st level fields into a ResultId if there is no ResultId
    IF ev_document_id IS INITIAL.
      lo_elemdescr ?= cl_abap_elemdescr=>describe_by_data( lv_ptf_key ).
      lv_doc_length = lo_elemdescr->output_length.

      UNASSIGN <fs_results>.

      LOOP AT it_operations ASSIGNING <fs_operation>.
        ASSIGN <fs_operation>-results->* TO <fs_results>.

        IF <fs_results> IS ASSIGNED.
          LOOP AT <fs_results> ASSIGNING <fs_result>.
            ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-param OF STRUCTURE <fs_result> TO <fs_param>.
            IF sy-subrc = 0.

              ev_document_id = me->build_resultid_from_struct(
                EXPORTING
                iv_doc_length = lv_doc_length
                is_struct     = <fs_param>
              ).
*              CONTINUE.
****
*              DATA iv_doc_length           TYPE i.
*              iv_doc_length = lv_doc_length.
*              DATA ev_ptf_key              TYPE ptfkey.
*              DATA: lo_typedescr   TYPE REF TO cl_abap_typedescr,
*                    lo_structdescr TYPE REF TO cl_abap_structdescr.
*              DATA: lv_length TYPE i,
*                    lv_offset TYPE i.
**             Check if it's a table or structure
*              lo_typedescr = cl_abap_typedescr=>describe_by_data( <fs_param> ).
*
*              CASE lo_typedescr->type_kind.
*                WHEN cl_abap_typedescr=>typekind_struct1
*                  OR cl_abap_typedescr=>typekind_struct2. "structure
*                  lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_param> ).
*                  DATA(lt_components) = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).
*
*                  CLEAR: ev_ptf_key, lv_offset.
*
*                  LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
*                    IF <fs_component>-type->type_kind <> cl_abap_typedescr=>typekind_table
*                      AND <fs_component>-type->type_kind <> cl_abap_typedescr=>typekind_struct1
*                      AND <fs_component>-type->type_kind <> cl_abap_typedescr=>typekind_struct2.
*                      ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_param> TO <fs_field>.
*                      IF sy-subrc = 0.
**                       Skip % fields
*                        IF <fs_component>-name CP '%*'.
*                          CONTINUE.
*
*                        ENDIF.
*
*                        CASE <fs_component>-type->type_kind.
*                          WHEN cl_abap_typedescr=>typekind_date
*                            OR cl_abap_typedescr=>typekind_time.
*                            lv_length = strlen( <fs_field> ).
*
*                          WHEN OTHERS.
*                            DATA lo_elemdescr2 TYPE REF TO cl_abap_elemdescr.
*                            lo_elemdescr2 ?= <fs_component>-type.
*                            lv_length = lo_elemdescr2->output_length.
*
*                        ENDCASE.
*
*                        IF lv_offset + lv_length <= iv_doc_length. "prevent dump
*                          ev_ptf_key+lv_offset(lv_length) = <fs_field>.
*
*                          lv_offset += lv_length.
*
*                        ELSE.
*                          EXIT.
*
*                        ENDIF.
*
*                      ENDIF.
*
*                    ENDIF.
*
*                  ENDLOOP.
*
*                  IF ev_ptf_key IS NOT INITIAL.
*                    APPEND ev_ptf_key TO ev_document_id.
*                  ENDIF.
*
*              ENDCASE.
***
            ENDIF.

          ENDLOOP.

        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD retrieve_doc_id_from_rep_comm.
    DATA: lv_ptf_key            TYPE ptfkey.

    FIELD-SYMBOLS: <fs_field> TYPE any.

*   Identify the key fields
    DATA(lt_components) = me->mo_ptf_rap_metadata->get_key_fields( EXPORTING iv_name = is_step_data-bus_obj ).

    IF line_exists( it_reported_commit[ entity_name = is_step_data-bus_obj ] ). "#EC CI_SORTSEQ
      DATA(lr_late_entries) = it_reported_commit[ entity_name = is_step_data-bus_obj ]-entries. "#EC CI_SORTSEQ

      ASSIGN lr_late_entries->* TO FIELD-SYMBOL(<fs_late_entries>).

      LOOP AT <fs_late_entries> ASSIGNING FIELD-SYMBOL(<fs_late_entry>).
        CLEAR lv_ptf_key.

        LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
          DATA(lv_tabix) = sy-tabix.

          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_late_entry> TO <fs_field>.
          IF <fs_field> IS NOT INITIAL.
            IF lv_tabix = 1.
              lv_ptf_key = <fs_field>.

            ELSE.
              lv_ptf_key = |{ lv_ptf_key }{ cl_ptf_util=>gc_key_field_delimiter }{ <fs_field> }|.

            ENDIF.

          ENDIF.

        ENDLOOP.

        IF lv_ptf_key IS NOT INITIAL.
          IF cv_is_pid = abap_on.
            CLEAR cv_document_id. "Clear ev_document_id because it might contain a PID
            cv_is_pid = abap_off.

          ENDIF.

          IF NOT line_exists( cv_document_id[ table_line = lv_ptf_key ] ) ##WARN_OK.
            APPEND lv_ptf_key TO cv_document_id.

          ENDIF.

        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD retrieve_doc_id_from_td_inst.
    DATA: lv_ptf_key      TYPE ptfkey.

    FIELD-SYMBOLS: <fs_field> TYPE any.

*   Identify the key fields
    DATA(lt_components) = me->mo_ptf_rap_metadata->get_key_fields( EXPORTING iv_name = is_step_data-bus_obj ).

    LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
      DATA(lv_tabix) = sy-tabix.

      ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_test_data TO <fs_field>.
      IF sy-subrc = 0.
        IF lv_tabix = 1.
          lv_ptf_key = <fs_field>.

        ELSE.
          lv_ptf_key = |{ lv_ptf_key }{ cl_ptf_util=>gc_key_field_delimiter }{ <fs_field> }|.

        ENDIF.

      ENDIF.

    ENDLOOP.

    IF lv_ptf_key IS NOT INITIAL.
      APPEND lv_ptf_key TO cv_document_id.

    ENDIF.

  ENDMETHOD.


  METHOD retrieve_pid_mapped.

    "Get PIDs from records in MAPPED. If no PID is found, look for PIDs in itab operation-results->*

    DATA lv_we_have_pid TYPE abap_bool.

    FIELD-SYMBOLS: <lt_entries>   TYPE STANDARD TABLE,
                   <ls_param>     TYPE any,
                   <lv_found_pid> TYPE any.

*   Look into mapped for %PIDs
    IF iv_op = if_abap_behv=>op-m-create
      OR iv_op = if_abap_behv=>op-m-action.

      IF line_exists( it_mapped[ entity_name = is_step_data-bus_obj ] ). "#EC CI_SORTSEQ
        DATA(lr_entries) = it_mapped[ entity_name = is_step_data-bus_obj ]-entries. "#EC CI_SORTSEQ
        ASSIGN lr_entries->* TO <lt_entries>.

        LOOP AT <lt_entries> ASSIGNING FIELD-SYMBOL(<ls_entry>).

          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-pid OF STRUCTURE <ls_entry> TO <lv_found_pid>.
          CHECK sy-subrc EQ 0.

          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-key OF STRUCTURE <ls_entry> TO FIELD-SYMBOL(<ls_key_of_entry>).
          IF <lv_found_pid> IS NOT INITIAL   AND <ls_key_of_entry> is initial.

            "Logic for preliminary key ONLY in %PID
            "Use %PID (alone) if existing

            "Collect pid mapped
            me->collect_pid_mapped(
              EXPORTING
                is_pid_mapped = VALUE #( step_number = is_step_data-step_number root_name = is_step_data-bus_obj pid = <lv_found_pid> )
            ).

            lv_we_have_pid = abap_on.     "do not look into operation results, we have the pid(s) already

          ELSE.

          "Logic for preliminary key in %KEY (additionally to PID or alone)

*          IF is_step_data-bus_obj EQ 'I_QLTYNOTIFICATIONTP' OR is_step_data-bus_obj EQ 'R_QLTYNOTIFICATIONTP'
*            OR is_step_data-bus_obj EQ 'I_EQUIPMENTTP' OR is_step_data-bus_obj EQ 'R_EQUIPMENTTP'.            "for now, only active for selected examples

            ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-pky OF STRUCTURE <ls_entry> TO FIELD-SYMBOL(<ls_pky>).
            CHECK sy-subrc EQ 0.

            IF <ls_pky> IS NOT INITIAL.                                                                      "outdated: AND <lv_found_pid> IS INITIAL.
              "cases where %key (additionally to PID or alone) is used to contain preliminary keys

              DATA(lr_tky) = cl_abap_behvdescr=>create_data(     "might be tky, not sure
                                     p_name      = is_step_data-bus_obj
                                     p_op        = cl_abap_behvdescr=>op_mapped_late
                                     p_structure = abap_on
                               ).

              ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-tmp OF STRUCTURE lr_tky->* TO FIELD-SYMBOL(<ls_tmp>).   "co_techfield_name-tmp is '%TMP'
              MOVE-CORRESPONDING <ls_entry> TO <ls_tmp>.

              "needed in the future, not needed for *_QLTYNOTIFICATIONTP
              ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-pid OF STRUCTURE lr_tky->* TO FIELD-SYMBOL(<ls_pid>).
              <ls_pid> = <lv_found_pid>.

              me->collect_pid_mapped(
                EXPORTING
                  is_pid_mapped = VALUE #( step_number = is_step_data-step_number root_name = is_step_data-bus_obj r_pre = lr_tky ) "pid = <lv_found_pid> )   "note that mt_pid_mapped-PID is not filled, but %key and PID in mt_pid_mapped-r_pre
              ).

              lv_we_have_pid = abap_on.     "do not look into operation results, we have a temp id already

            ENDIF.

*          ELSE.
*            ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-key OF STRUCTURE <ls_entry> TO FIELD-SYMBOL(<ls_key>).
*            IF sy-subrc EQ 0 AND <ls_key> IS NOT INITIAL.
*              "the new logic is also needed for this BO
*              me->mo_run_environment->append_log( 'OPEN A TICKET ON ACH SD-PTF, with script name, system, client.' ).
*            ENDIF.
          ENDIF.


*          "Logic for preliminary key in %PID
*          "Use %PID (alone) if existing
*
*          IF <lv_found_pid> IS NOT INITIAL.
*
*            "Collect pid mapped
*            me->collect_pid_mapped(
*              EXPORTING
*                is_pid_mapped = VALUE #( step_number = is_step_data-step_number root_name = is_step_data-bus_obj pid = <lv_found_pid> )
*            ).
*
*            lv_we_have_pid = abap_on.     "do not look into operation results, we have the pid(s) already
*
*          ENDIF.

        ENDLOOP.

      ENDIF.

    ENDIF.


*   Look into operations for %PIDs
    IF iv_op = if_abap_behv=>op-m-action
      AND lv_we_have_pid = abap_off.

      LOOP AT it_operations ASSIGNING FIELD-SYMBOL(<ls_operation>).
        ASSIGN <ls_operation>-results->* TO FIELD-SYMBOL(<lt_results>).

        IF <lt_results> IS ASSIGNED.

          LOOP AT <lt_results> ASSIGNING FIELD-SYMBOL(<ls_result>).
            ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-param OF STRUCTURE <ls_result> TO <ls_param>.
            IF sy-subrc = 0.
              ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-pid OF STRUCTURE <ls_param> TO <lv_found_pid>.
              IF sy-subrc = 0.
                IF <lv_found_pid> IS NOT INITIAL.

*                 Collect pid mapped
                  me->collect_pid_mapped(
                    EXPORTING
                      is_pid_mapped = VALUE #( step_number = is_step_data-step_number root_name = is_step_data-bus_obj pid = <lv_found_pid> )
                  ).

                ENDIF.

              ENDIF.

            ENDIF.

          ENDLOOP.

        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD retr_doc_id_from_pid_mapped.
    DATA: lv_is_pid_mapped  TYPE abap_bool.

    CLEAR ev_document_id.

    LOOP AT me->mt_pid_mapped ASSIGNING FIELD-SYMBOL(<fs_pid_mapped>).
*     Skip entries that are not at step level if step level data is supplied
      IF is_step_data IS NOT INITIAL AND <fs_pid_mapped>-step_number <> is_step_data-step_number.
        CONTINUE.

      ENDIF.

      IF <fs_pid_mapped>-key IS NOT INITIAL.
**       Identify the key fields
*        DATA(lt_components) = me->mo_ptf_rap_metadata->get_key_fields( EXPORTING iv_name = <fs_pid_mapped>-root_name ).

        APPEND <fs_pid_mapped>-key TO ev_document_id.

        lv_is_pid_mapped = abap_on.

      ENDIF.

*      me->mo_run_environment->append_log( |Root Name: { <fs_pid_mapped>-root_name }| ).
*      me->mo_run_environment->append_log( |%PID { <fs_pid_mapped>-pid } mapped to key { <fs_pid_mapped>-key }| ).

    ENDLOOP.

*   We found a real key, clear the internal table that stores the %PID mappings
    IF lv_is_pid_mapped = abap_on.
      CLEAR me->mt_pid_mapped.

    ENDIF.

  ENDMETHOD.


  METHOD retr_doc_id_from_rep_comm_step.
    DATA: lv_ptf_key      TYPE ptfkey.

    FIELD-SYMBOLS: <fs_field>         TYPE any.

    CLEAR ev_document_id.

    LOOP AT it_reported_commit ASSIGNING FIELD-SYMBOL(<fs_reported_commit>) WHERE entity_name IS NOT INITIAL. "#EC CI_SORTSEQ
      DATA(lt_components) = me->mo_ptf_rap_metadata->get_key_fields( EXPORTING iv_name = <fs_reported_commit>-entity_name ).

      ASSIGN <fs_reported_commit>-entries->* TO FIELD-SYMBOL(<fs_bundled_entries>).

      LOOP AT <fs_bundled_entries> ASSIGNING FIELD-SYMBOL(<fs_bundled_entry>).
        CLEAR lv_ptf_key.

        LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
          DATA(lv_tabix) = sy-tabix.

          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_bundled_entry> TO <fs_field>.
          IF <fs_field> IS NOT INITIAL.
            IF lv_tabix = 1.
              lv_ptf_key = <fs_field>.

            ELSE.
              lv_ptf_key = |{ lv_ptf_key }{ cl_ptf_util=>gc_key_field_delimiter }{ <fs_field> }|.

            ENDIF.

          ENDIF.

        ENDLOOP.

        IF lv_ptf_key IS NOT INITIAL.
          IF NOT line_exists( ev_document_id[ table_line = lv_ptf_key ] ) ##WARN_OK.
            APPEND lv_ptf_key TO ev_document_id.

          ENDIF.

        ENDIF.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


  METHOD search_keys.
    FIELD-SYMBOLS: <fs_test_data> TYPE any.

    CLEAR ev_error.

    ASSIGN cr_test_data->* TO <fs_test_data>.

*   Check if the key is empty
    CASE is_step_data-action.
      WHEN 'RETRIEVE_ALL' OR 'CHECK_IF_EXISTS'.
        DATA(lv_key_fully_filled) = me->mo_ptf_rap_validate_tdo->check_key_fully_filled( iv_name = is_step_data-bus_obj
                                                                                         is_data = <fs_test_data> ).
        IF lv_key_fully_filled = abap_off.
          me->mo_run_environment->append_log( 'Root keys not given, using free search instead' ).

          me->mo_ptf_rap_key_finder->find_keys( EXPORTING iv_name       = is_step_data-bus_obj
                                                          iv_action     = is_step_data-action
                                                IMPORTING ev_error      = ev_error
                                                CHANGING  cr_test_data  = cr_test_data ).

        ELSE.
          me->mo_run_environment->append_log( 'As full key is given for root entity, EML Read is done with key access (free search not required)' ).

        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD adjust_operation_code.

    CHECK ct_operations IS NOT INITIAL.

    DATA(lv_entity_name) = ct_operations[ 1 ]-entity_name.

    cl_abap_behv_load=>get_load(
      EXPORTING
        entity    = lv_entity_name
        all       = abap_off
      IMPORTING
        actions   = DATA(lt_actions)
      RECEIVING
        result    = DATA(lv_result)
    ).
    IF lv_result <> cl_abap_behv_load=>ok.
      RETURN.
    ENDIF.

    LOOP AT ct_operations REFERENCE INTO DATA(lr_op).
***
*temp:
      DATA(lo_rap_bhv_metadata_provider) = cl_rap_bhv_metadata_provider=>get_instance_for_entity( CONV #( lv_entity_name ) ).
      DATA(lt_functions) = lo_rap_bhv_metadata_provider->get_functions( ).
***
      READ TABLE lt_actions REFERENCE INTO DATA(lr_act) WITH KEY name = lr_op->sub_name.
      IF sy-subrc = 0 AND lr_act->properties-is_read_only = abap_true.
***
        "assert: also in function list
        READ TABLE lt_functions WITH KEY name = lr_op->sub_name TRANSPORTING NO FIELDS.
        IF sy-subrc IS NOT INITIAL.
          ASSERT 1 = 2.
        ENDIF.
***
        lr_op->op = if_abap_behv=>op-r-evaluate.
        cv_op = lr_op->op.
***
      ELSE.
        "assert: also not in function list
        READ TABLE lt_functions WITH KEY name = lr_op->sub_name TRANSPORTING NO FIELDS.
        IF sy-subrc IS INITIAL.
          ASSERT 1 = 2.
        ENDIF.
***
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_param_results.

    CONSTANTS lc_result_field_name TYPE c LENGTH 7 VALUE 'results'.

    FIELD-SYMBOLS <lt_operations> TYPE STANDARD TABLE.
    FIELD-SYMBOLS <ls_operation_result_ref> TYPE REF TO data.
    FIELD-SYMBOLS <lt_data> TYPE STANDARD TABLE.

    CHECK it_operations IS NOT INITIAL.
    ASSIGN it_operations TO <lt_operations>.
    CHECK sy-subrc = 0 AND <lt_operations> IS NOT INITIAL.

    " Get a reference type of reuslt line (lr_data)

    READ TABLE <lt_operations> ASSIGNING FIELD-SYMBOL(<ls_operation>) INDEX 1.
    CHECK sy-subrc = 0.
    ASSIGN COMPONENT lc_result_field_name OF STRUCTURE <ls_operation> TO <ls_operation_result_ref>.
    CHECK sy-subrc = 0.

    ASSIGN <ls_operation_result_ref>->* TO <lt_data>.
    CHECK sy-subrc = 0 AND <lt_data> IS NOT INITIAL.
    READ TABLE <lt_data> ASSIGNING FIELD-SYMBOL(<ls_data>) INDEX 1.
    CHECK sy-subrc = 0.
    DATA(lr_data) = REF #( <ls_data> ).

    " Create itab of refs to result lines
    CREATE DATA er_test_data LIKE STANDARD TABLE OF lr_data.

    " Fill itab
    ASSIGN er_test_data->* TO <lt_data>.
    CHECK sy-subrc = 0.
    LOOP AT <lt_operations> ASSIGNING <ls_operation>.
      ASSIGN COMPONENT lc_result_field_name OF STRUCTURE <ls_operation> TO <ls_operation_result_ref>.
      CHECK sy-subrc = 0.
      ASSIGN <ls_operation_result_ref>->* TO FIELD-SYMBOL(<ft_data_tmp>).
      LOOP AT <ft_data_tmp> ASSIGNING <ls_data>.
        lr_data = REF #( <ls_data> ).
        INSERT lr_data INTO TABLE  <lt_data>.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
