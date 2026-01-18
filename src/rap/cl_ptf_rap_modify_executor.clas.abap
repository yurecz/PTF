CLASS cl_ptf_rap_modify_executor DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        io_run_environment TYPE REF TO cl_ptf_run
        io_eml             TYPE REF TO if_ptf_bo_rap_generic_eml
        io_operations      TYPE REF TO if_ptf_rap_operations .

    METHODS execute
      IMPORTING
        iv_step_number      TYPE i
      EXPORTING
        ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        ev_execution_status TYPE abap_bool
        ev_check_status     TYPE abap_bool .

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mo_run_environment TYPE REF TO cl_ptf_run .
    DATA mo_eml TYPE REF TO if_ptf_bo_rap_generic_eml .
    DATA mo_operations TYPE REF TO if_ptf_rap_operations .
    DATA mo_ptf_rap_json_ref_parser TYPE REF TO if_ptf_rap_json_ref_parser .
    DATA mo_ptf_rap_metadata TYPE REF TO if_ptf_rap_metadata .
    DATA mv_global_cid_counter TYPE i .

    METHODS collect_messages
      IMPORTING
        it_reported TYPE abp_behv_response_tab
      CHANGING
        ct_messages TYPE bapirettab .

    METHODS commit_entities
      IMPORTING
        iv_simulation       TYPE abap_bool DEFAULT abap_off
        it_root_entities    TYPE abp_entity_name_tab
      EXPORTING
        et_reported_commit  TYPE abp_behv_response_tab
        ev_error            TYPE abap_bool
      CHANGING
        ct_pid_mapped       TYPE if_ptf_bo_rap_generic_eml=>tt_pid_mapped .

    METHODS deserialize_json
      IMPORTING
        iv_entity     TYPE abp_entity_name
        iv_json       TYPE string
        iv_step_number TYPE i
        it_reference_step TYPE ptf_step_count_t
      EXPORTING
        et_operations TYPE abp_behv_changes_tab
      RAISING
        cx_ptf_json .

    METHODS extract_document_ids
      IMPORTING
        iv_entity      TYPE abp_entity_name
        it_pid_mapped  TYPE if_ptf_bo_rap_generic_eml=>tt_pid_mapped
        it_mapped      TYPE abp_behv_response_tab
        it_operations  TYPE abp_behv_changes_tab
      EXPORTING
        ev_document_id TYPE cl_ptf_util=>ty_vbeln_tab .

    METHODS parse_instance_references
      IMPORTING
        iv_entity_name  TYPE abp_entity_name
        iv_step_number  TYPE i
      EXPORTING
        ev_error        TYPE abap_bool
      CHANGING
        cs_instance     TYPE any .

    METHODS check_ref_step_instance
      IMPORTING
        iv_entity_name  TYPE abp_entity_name
        iv_step_number  TYPE i
        it_reference_step TYPE ptf_step_count_t
      CHANGING
        cs_instance     TYPE any .

    METHODS process_instances
      IMPORTING
        iv_entity_name    TYPE abp_entity_name
        iv_step_number    TYPE i
        it_reference_step TYPE ptf_step_count_t
        it_key_fields     TYPE abap_component_tab
        is_json_instance  TYPE any
      CHANGING
        cs_instance       TYPE any .

    METHODS validate_keys_required
      IMPORTING
        iv_entity_name   TYPE abp_entity_name
        iv_operation     TYPE string
        it_instances     TYPE REF TO data
        it_key_fields    TYPE abap_component_tab
      RAISING
        cx_ptf_json .

    METHODS process_create
      IMPORTING
        iv_entity_name      TYPE abp_entity_name
        iv_step_number      TYPE i
        it_reference_step   TYPE ptf_step_count_t
        it_key_fields       TYPE abap_component_tab
        is_operation        TYPE abp_behv_changes
        it_json_instances   TYPE STANDARD TABLE
      EXPORTING
        er_instances        TYPE REF TO data .

    METHODS process_create_by
      IMPORTING
        iv_entity_name      TYPE abp_entity_name
        iv_step_number      TYPE i
        it_reference_step   TYPE ptf_step_count_t
        it_key_fields       TYPE abap_component_tab
        is_operation        TYPE abp_behv_changes
        it_json_instances   TYPE STANDARD TABLE
        iv_operation_cid_ref TYPE string
      EXPORTING
        er_instances        TYPE REF TO data .

    METHODS process_update
      IMPORTING
        iv_entity_name      TYPE abp_entity_name
        iv_step_number      TYPE i
        it_reference_step   TYPE ptf_step_count_t
        it_key_fields       TYPE abap_component_tab
        is_operation        TYPE abp_behv_changes
        it_json_instances   TYPE STANDARD TABLE
      EXPORTING
        er_instances        TYPE REF TO data
      RAISING
        cx_ptf_json .

    METHODS process_delete
      IMPORTING
        iv_entity_name      TYPE abp_entity_name
        iv_step_number      TYPE i
        it_reference_step   TYPE ptf_step_count_t
        is_operation        TYPE abp_behv_changes
        it_json_instances   TYPE STANDARD TABLE
      EXPORTING
        er_instances        TYPE REF TO data
      RAISING
        cx_ptf_json .

    METHODS process_execute
      IMPORTING
        iv_entity_name      TYPE abp_entity_name
        iv_step_number      TYPE i
        it_reference_step   TYPE ptf_step_count_t
        it_key_fields       TYPE abap_component_tab
        is_operation        TYPE abp_behv_changes
        it_json_instances   TYPE STANDARD TABLE
      EXPORTING
        er_instances        TYPE REF TO data
      RAISING
        cx_ptf_json .
ENDCLASS.



CLASS CL_PTF_RAP_MODIFY_EXECUTOR IMPLEMENTATION.


  METHOD constructor.
    me->mo_run_environment = io_run_environment.
    me->mo_eml = io_eml.
    me->mo_operations = io_operations.
    me->mo_ptf_rap_json_ref_parser = NEW cl_ptf_rap_json_ref_parser( io_run_environment = io_run_environment ).
    me->mo_ptf_rap_metadata = NEW cl_ptf_rap_metadata( ).
  ENDMETHOD.


  METHOD execute.
*   MODIFY action for RAP Business Objects using EML MODIFY ENTITIES OPERATIONS
    DATA: lt_operations        TYPE abp_behv_changes_tab,
          lt_failed            TYPE abp_behv_response_tab,
          lt_mapped            TYPE abp_behv_response_tab,
          lt_reported          TYPE abp_behv_response_tab,
          lt_reported_commit   TYPE abp_behv_response_tab,
          lt_messages          TYPE bapirettab,
          lt_act_messages      TYPE ptf_t100_message_t,
          lv_error             TYPE abap_bool,
          ls_step_data         TYPE cl_ptf_util=>gt_ptf_step,
          lt_root_entities     TYPE abp_entity_name_tab,
          lt_pid_mapped        TYPE if_ptf_bo_rap_generic_eml=>tt_pid_mapped.

    CLEAR: ev_execution_status, ev_check_status, ev_document_id.

*   Get step data
    ls_step_data = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

*   Deserialize JSON to operations table for MODIFY action
*   MODIFY uses json_file field (same as other RAP operations)
    TRY.
        me->deserialize_json(
          EXPORTING
            iv_entity     = ls_step_data-bus_obj
            iv_json       = ls_step_data-json_file
            iv_step_number = iv_step_number
            it_reference_step = ls_step_data-reference_step
          IMPORTING
            et_operations = lt_operations ).

      CATCH cx_ptf_json INTO DATA(lx_json).
        me->mo_run_environment->append_log( lx_json->get_text( ) ).
        ev_execution_status = abap_off.
        RETURN.
    ENDTRY.

    IF lt_operations IS INITIAL.
      me->mo_run_environment->append_log( 'No operations found in JSON payload' ).
      ev_execution_status = abap_off.
      RETURN.
    ENDIF.

*   Consolidate operations: EML deduplicates by (entity + op + sub_name)
*   Merge instances from duplicate operations to ensure all instances execute
    DATA: lt_consolidated_ops TYPE abp_behv_changes_tab,
          lv_found            TYPE abap_bool.

    FIELD-SYMBOLS: <ft_new_inst_cons>  TYPE STANDARD TABLE,
                   <ft_exist_inst_cons> TYPE STANDARD TABLE,
                   <fs_new_inst_cons>   TYPE any.

    LOOP AT lt_operations INTO DATA(ls_op_cons).
*     Check if operation with same entity+op+sub_name already exists
      lv_found = abap_off.
      LOOP AT lt_consolidated_ops ASSIGNING FIELD-SYMBOL(<fs_existing_op_cons>)
        WHERE entity_name = ls_op_cons-entity_name
          AND op = ls_op_cons-op
          AND sub_name = ls_op_cons-sub_name.
        lv_found = abap_on.
        EXIT.
      ENDLOOP.

      IF lv_found = abap_on.
*       Found duplicate - merge instances
        IF ls_op_cons-instances IS BOUND AND <fs_existing_op_cons>-instances IS BOUND.
          ASSIGN ls_op_cons-instances->* TO <ft_new_inst_cons>.
          ASSIGN <fs_existing_op_cons>-instances->* TO <ft_exist_inst_cons>.

          IF <ft_new_inst_cons> IS ASSIGNED AND <ft_exist_inst_cons> IS ASSIGNED.
*           Append new instances to existing operation
            LOOP AT <ft_new_inst_cons> ASSIGNING <fs_new_inst_cons>.
              APPEND <fs_new_inst_cons> TO <ft_exist_inst_cons>.
            ENDLOOP.
            me->mo_run_environment->append_log( |Consolidated { lines( <ft_new_inst_cons> ) } instances into existing operation (entity={ ls_op_cons-entity_name }, op={ ls_op_cons-op })| ).
          ENDIF.
        ENDIF.
      ELSE.
*       New operation - add to consolidated list
        APPEND ls_op_cons TO lt_consolidated_ops.
      ENDIF.
    ENDLOOP.

*   Replace with consolidated operations
    lt_operations = lt_consolidated_ops.

*   Diagnostic: Log operations before EML execution
    me->mo_run_environment->append_log( |Operations passed to EML: { lines( lt_operations ) }| ).
    LOOP AT lt_operations INTO DATA(ls_op_diag).
      DATA(lv_inst_count) = 0.
      IF ls_op_diag-instances IS BOUND.
        ASSIGN ls_op_diag-instances->* TO FIELD-SYMBOL(<ft_instances_diag>).
        IF sy-subrc = 0.
          lv_inst_count = lines( <ft_instances_diag> ).
        ENDIF.
      ENDIF.
      me->mo_run_environment->append_log( |Op { sy-tabix }: entity={ ls_op_diag-entity_name }, op={ ls_op_diag-op }, sub_name={ ls_op_diag-sub_name }, instances={ lv_inst_count }| ).
    ENDLOOP.

*   Execute EML MODIFY ENTITIES
    me->mo_eml->modify_entities(
      IMPORTING
        et_failed     = lt_failed
        et_mapped     = lt_mapped
        et_reported   = lt_reported
      CHANGING
        ct_operations = lt_operations ).

*   Collect messages from REPORTED
    me->collect_messages(
      EXPORTING
        it_reported = lt_reported
      CHANGING
        ct_messages = lt_messages ).

*   Check for errors
    me->mo_operations->handle_operations_error(
      EXPORTING
        it_failed   = lt_failed
        it_mapped   = lt_mapped
        it_reported = lt_reported
      IMPORTING
        ev_error    = lv_error ).

    IF lv_error = abap_on.
      ev_execution_status = abap_off.

*     Add messages to step attributes
      IF lt_messages IS NOT INITIAL.
        MOVE-CORRESPONDING lt_messages TO lt_act_messages.
        cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~add_actual_messages( lt_act_messages ).
      ENDIF.

      RETURN.
    ENDIF.

*   Fill list of root entities for commit (collect all entities from operations)
    LOOP AT lt_operations INTO DATA(ls_op_root).
      IF NOT line_exists( lt_root_entities[ table_line = ls_op_root-entity_name ] ).
        INSERT ls_op_root-entity_name INTO TABLE lt_root_entities.
      ENDIF.
    ENDLOOP.

*   Execute COMMIT ENTITIES
    me->commit_entities(
      EXPORTING
        it_root_entities    = lt_root_entities
      IMPORTING
        et_reported_commit  = lt_reported_commit
        ev_error            = lv_error
      CHANGING
        ct_pid_mapped       = lt_pid_mapped ).

*   Collect commit messages
    me->collect_messages(
      EXPORTING
        it_reported = lt_reported_commit
      CHANGING
        ct_messages = lt_messages ).

*   Add all messages to step attributes
    IF lt_messages IS NOT INITIAL.
      MOVE-CORRESPONDING lt_messages TO lt_act_messages.
      cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~add_actual_messages( lt_act_messages ).
    ENDIF.

*   Extract document IDs (only for successful operations)
*   Priority: lt_pid_mapped (real keys after commit) > lt_mapped (preliminary keys)
    IF lv_error = abap_off.
*     Extract document IDs for all entities in operations
      DATA(lt_doc_ids_temp) = VALUE cl_ptf_util=>ty_vbeln_tab( ).
      LOOP AT lt_root_entities INTO DATA(lv_entity).
        CLEAR lt_doc_ids_temp.
        me->extract_document_ids(
          EXPORTING
            iv_entity      = lv_entity
            it_pid_mapped  = lt_pid_mapped
            it_mapped      = lt_mapped
            it_operations  = lt_operations
          IMPORTING
            ev_document_id = lt_doc_ids_temp ).

        APPEND LINES OF lt_doc_ids_temp TO ev_document_id.
      ENDLOOP.

*     Log extracted document IDs
      IF ev_document_id IS NOT INITIAL.
        DATA(lv_doc_id_str) = VALUE string( ).
        LOOP AT ev_document_id ASSIGNING FIELD-SYMBOL(<lv_doc_id>).
          lv_doc_id_str = CONV string( <lv_doc_id> ).
          me->mo_run_environment->append_log( |Extracted document ID: { lv_doc_id_str }| ).
        ENDLOOP.
      ELSE.
        me->mo_run_environment->append_log( 'No document IDs extracted from MAPPED table' ).
      ENDIF.
    ENDIF.

*   Set return values
*   MODIFY action executes CREATE/DELETE/UPDATE - these are NOT check actions
*   check_status should remain empty (only set for CHECK/READ actions)
    IF lv_error = abap_off.
      ev_execution_status = abap_on.
    ELSE.
      ev_execution_status = abap_off.
    ENDIF.

  ENDMETHOD.


  METHOD collect_messages.
    DATA: lo_message TYPE REF TO if_abap_behv_message,
          ls_message TYPE bapiret2.

    FIELD-SYMBOLS: <fs_reported> TYPE abp_behv_response,
                   <fs_entries>  TYPE any,
                   <fs_entry>    TYPE any,
                   <fs_field>    TYPE any.

    LOOP AT it_reported ASSIGNING <fs_reported>.
      ASSIGN <fs_reported>-entries->* TO <fs_entries>.

      LOOP AT <fs_entries> ASSIGNING <fs_entry>.
        ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-msg OF STRUCTURE <fs_entry> TO <fs_field>.
        IF sy-subrc = 0.
          lo_message = <fs_field>.
        ENDIF.

        IF lo_message IS BOUND.
          ls_message-type       = lo_message->if_t100_dyn_msg~msgty.
          ls_message-id         = lo_message->if_t100_message~t100key-msgid.
          ls_message-number     = lo_message->if_t100_message~t100key-msgno.
          ls_message-message_v1 = lo_message->if_t100_dyn_msg~msgv1.
          ls_message-message_v2 = lo_message->if_t100_dyn_msg~msgv2.
          ls_message-message_v3 = lo_message->if_t100_dyn_msg~msgv3.
          ls_message-message_v4 = lo_message->if_t100_dyn_msg~msgv4.
          ls_message-message    = lo_message->if_message~get_text( ).

          APPEND ls_message TO ct_messages.
          CLEAR: ls_message, lo_message.
        ENDIF.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


  METHOD commit_entities.
    DATA: lo_message       TYPE REF TO if_abap_behv_message,
          lt_failed_commit TYPE abp_behv_response_tab,
          lv_message       TYPE string.

    FIELD-SYMBOLS: <fs_field> TYPE any,
                   <fs_value> TYPE any.

    CLEAR ev_error.

    me->mo_eml->commit_entities(
      EXPORTING
        iv_simulation     = iv_simulation
        it_root_entities  = it_root_entities
      IMPORTING
        et_failed         = lt_failed_commit
        et_reported       = et_reported_commit
      CHANGING
        ct_pid_mapped     = ct_pid_mapped
    ).

    LOOP AT et_reported_commit ASSIGNING FIELD-SYMBOL(<fs_reported_commit>).

      IF <fs_reported_commit>-entity_name IS INITIAL.
        ASSIGN <fs_reported_commit>-entries->* TO FIELD-SYMBOL(<fs_messages>).

        LOOP AT <fs_messages> ASSIGNING FIELD-SYMBOL(<fs_message>).
          lo_message = <fs_message>.

          lv_message = |({ lo_message->if_t100_dyn_msg~msgty }){ lo_message->if_message~get_text( ) }|.
          me->mo_run_environment->append_log( lv_message ).

        ENDLOOP.

      ELSE.
        ASSIGN <fs_reported_commit>-entries->* TO FIELD-SYMBOL(<fs_entries_commit>).

        LOOP AT <fs_entries_commit> ASSIGNING FIELD-SYMBOL(<fs_entry_commit>).

          DATA lv_msgty TYPE symsgty.
          CLEAR lv_msgty.

          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-msg OF STRUCTURE <fs_entry_commit> TO <fs_field>.
          IF sy-subrc = 0.
            lo_message = <fs_field>.

            IF lo_message->if_t100_dyn_msg~msgty IS NOT INITIAL.
              lv_msgty = lo_message->if_t100_dyn_msg~msgty.
            ELSE.
              lv_msgty = SWITCH #( lo_message->m_severity
                WHEN if_abap_behv_message=>severity-error       THEN 'E'
                WHEN if_abap_behv_message=>severity-warning     THEN 'W'
                WHEN if_abap_behv_message=>severity-information THEN 'I'
                WHEN if_abap_behv_message=>severity-success     THEN 'S' ).
            ENDIF.

            lv_message = |({ lv_msgty }){ lo_message->if_message~get_text( ) }|.
            me->mo_run_environment->append_log( lv_message ).

            IF lv_msgty <> 'S' AND lv_msgty <> 'W' AND lv_msgty <> 'I' .
              ev_error = abap_on.
            ENDIF.

          ENDIF.

        ENDLOOP.

      ENDIF.

    ENDLOOP.

    LOOP AT lt_failed_commit ASSIGNING FIELD-SYMBOL(<fs_failed_commit>).
      ASSIGN <fs_failed_commit>-entries->* TO FIELD-SYMBOL(<fs_failed_commit_entries>).

      LOOP AT <fs_failed_commit_entries> ASSIGNING FIELD-SYMBOL(<fs_failed_commit_entry>).
        ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-fail OF STRUCTURE <fs_failed_commit_entry> TO <fs_field>.
        IF sy-subrc = 0.
          ASSIGN COMPONENT 'CAUSE' OF STRUCTURE <fs_field> TO <fs_value>.
          IF sy-subrc = 0.
            me->mo_run_environment->append_log( |Commit failed: { <fs_value> }| ).
            ev_error = abap_on.
          ENDIF.
        ENDIF.
      ENDLOOP.

    ENDLOOP.

    IF ev_error EQ abap_off.
      me->mo_run_environment->append_log( 'Executed/committed without EML error' ).
    ENDIF.

  ENDMETHOD.


  METHOD deserialize_json.
*   Deserialize JSON for MODIFY action
*   Handles EML operation format: [{"op": "CREATE", "entity": "...", "instances": [...]}]
*
*   IMPORTANT: /ui2/cl_json=>deserialize with generic REF TO data
*   ============================================================
*   When deserializing to a generic REF TO data (no type information at compile time),
*   /ui2/cl_json creates NESTED REFERENCES for all structures and values:
*   - Each array element is a reference: <fs_json_op>->* needed
*   - Each component value is a reference: <fs_op>->*, <fs_entity>->* needed
*   - Nested arrays are references: <fs_instances>->* needed
*   - Instance elements are references: <fs_instance>->* needed
*
*   The assoc_arrays parameter only affects HOW arrays are represented
*   (associative vs standard tables), NOT whether values are wrapped in references.
*
*   See: https://github.com/SAP/abap-to-json/blob/main/docs/data-access.md
*   for patterns on working with dynamic data from /ui2/cl_json
*
    DATA: lr_json_data   TYPE REF TO data,
          lr_instances   TYPE REF TO data,
          ls_operation   TYPE abp_behv_changes,
          lv_json        TYPE string.

    FIELD-SYMBOLS: <ft_json_ops>     TYPE STANDARD TABLE,
                   <fs_json_op>      TYPE any,
                   <fs_op>           TYPE any,
                   <fs_entity>       TYPE any,
                   <fs_sub_name>     TYPE any,
                   <fs_instances>    TYPE any,
                   <ft_instances>    TYPE STANDARD TABLE,
                   <ft_target_table> TYPE STANDARD TABLE,
                   <fs_instance>     TYPE any,
                   <fs_target>       TYPE any,
                   <fs_field>        TYPE any,
                   <fs_value>        TYPE any.

    CLEAR et_operations.
    lv_json = iv_json.

*   Debug: Log JSON length
    me->mo_run_environment->append_log( |JSON length: { strlen( lv_json ) }| ).

*   Parse JSON array into dynamic structure
*   Result: lr_json_data points to table of references to structures
    /ui2/cl_json=>deserialize(
        EXPORTING
          json          = lv_json
          assoc_arrays  = abap_off
        CHANGING
          data          = lr_json_data ).

    IF lr_json_data IS NOT BOUND.
      me->mo_run_environment->append_log( 'JSON deserialization failed - no data created' ).
      RAISE EXCEPTION NEW cx_ptf_json( textid = cx_ptf_json=>invalid_json ).
    ENDIF.

*   Validate JSON structure (must be array of operations)
    DATA(lo_type_descr) = cl_abap_typedescr=>describe_by_data( lr_json_data->* ).

    IF lo_type_descr->kind <> cl_abap_typedescr=>kind_table.
*     Common error: single operation object instead of array
      me->mo_run_environment->append_log( '❌ MODIFY JSON format error' ).
      me->mo_run_environment->append_log( |Found: JSON object (type kind { lo_type_descr->kind })| ).
      me->mo_run_environment->append_log( 'Expected: JSON array of operations' ).
      me->mo_run_environment->append_log( ' ' ).
      me->mo_run_environment->append_log( '✅ Correct: [ { "op": "CREATE|UPDATE|DELETE|EXECUTE", "entity": "...", "instances": [...] } ]' ).
      me->mo_run_environment->append_log( '❌ Wrong:   { "op": "CREATE|UPDATE|DELETE|EXECUTE", "entity": "...", "instances": [...] }' ).
      me->mo_run_environment->append_log( ' ' ).
      me->mo_run_environment->append_log( 'Wrap your operation in square brackets [ ] - MODIFY accepts array of operations' ).
      RAISE EXCEPTION NEW cx_ptf_json( textid = cx_ptf_json=>invalid_json ).
    ENDIF.

    ASSIGN lr_json_data->* TO <ft_json_ops>.
    IF sy-subrc <> 0.
      me->mo_run_environment->append_log( 'Failed to assign deserialized data to table field symbol' ).
      RAISE EXCEPTION NEW cx_ptf_json( textid = cx_ptf_json=>invalid_json ).
    ENDIF.

*   Debug: Log number of operations found in JSON
    DATA(lv_lines) = lines( <ft_json_ops> ).
    me->mo_run_environment->append_log( |Parsed { lv_lines } JSON elements| ).

*   Process each operation
    LOOP AT <ft_json_ops> ASSIGNING <fs_json_op>.
      CLEAR ls_operation.

*     Dereference JSON operation element (1st level: array element -> structure)
      ASSIGN <fs_json_op>->* TO FIELD-SYMBOL(<json_op>).
      IF sy-subrc <> 0.
        CONTINUE. "Skip invalid JSON elements
      ENDIF.

*     Extract operation code (2nd level: structure component -> value)
      ASSIGN COMPONENT 'OP' OF STRUCTURE <json_op> TO <fs_op>.
      IF sy-subrc <> 0.
        me->mo_run_environment->append_log( |Skipping JSON element (no 'op' field) - probably comment| ).
        CONTINUE. "Skip entries without 'op' field (e.g., comments)
      ENDIF.

*     Dereference op value (value is also a reference)
      DATA(lv_op_code) = CONV string( <fs_op>->* ).
      lv_op_code = to_upper( lv_op_code ).
      me->mo_run_environment->append_log( |Processing operation: { lv_op_code }| ).

*     Validate operation code (skip unknown operations)
      IF lv_op_code <> 'CREATE' AND lv_op_code <> 'CREATE_BY' AND lv_op_code <> 'UPDATE'
        AND lv_op_code <> 'DELETE' AND lv_op_code <> 'EXECUTE'.
        me->mo_run_environment->append_log( |Unknown operation '{ lv_op_code }' - skipping| ).
        CONTINUE.
      ENDIF.

*     Extract entity name (dereference value reference)
      ASSIGN COMPONENT 'ENTITY' OF STRUCTURE <json_op> TO <fs_entity>.
      IF sy-subrc = 0.
        ls_operation-entity_name = to_upper( CONV string( <fs_entity>->* ) ).
      ELSE.
        CONTINUE. "Skip operations without entity
      ENDIF.

*     Extract sub_name for CREATE_BY or EXECUTE (dereference value reference)
      ASSIGN COMPONENT 'SUB_NAME' OF STRUCTURE <json_op> TO <fs_sub_name>.
      IF sy-subrc = 0.
        ls_operation-sub_name = to_upper( CONV string( <fs_sub_name>->* ) ).
      ENDIF.

*     Extract %CID_REF for CREATE_BY (operation-level reference to parent)
      DATA(lv_operation_cid_ref) = VALUE string( ).
      ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-cid_ref OF STRUCTURE <json_op> TO FIELD-SYMBOL(<fs_cid_ref>).
      IF sy-subrc = 0.
*       Dereference the value (JSON values are references)
        TRY.
            lv_operation_cid_ref = CONV string( <fs_cid_ref>->* ).
            me->mo_run_environment->append_log( |Extracted operation-level %CID_REF: { lv_operation_cid_ref }| ).
          CATCH cx_root.
*           Fallback: use direct value if not a reference
            lv_operation_cid_ref = CONV string( <fs_cid_ref> ).
        ENDTRY.
      ELSE.
*       Fallback: try _CID_REF (in case /ui2/cl_json converted % to _)
        ASSIGN COMPONENT '_CID_REF' OF STRUCTURE <json_op> TO <fs_cid_ref>.
        IF sy-subrc = 0.
          TRY.
              lv_operation_cid_ref = CONV string( <fs_cid_ref>->* ).
              me->mo_run_environment->append_log( |Extracted operation-level _CID_REF: { lv_operation_cid_ref }| ).
            CATCH cx_root.
              lv_operation_cid_ref = CONV string( <fs_cid_ref> ).
          ENDTRY.
        ENDIF.
      ENDIF.

*     Extract instances array and dereference
      ASSIGN COMPONENT 'INSTANCES' OF STRUCTURE <json_op> TO <fs_instances>.
      IF sy-subrc <> 0.
        CONTINUE. "Skip operations without instances
      ENDIF.

*     Dereference instances array (component value is reference to table)
      ASSIGN <fs_instances>->* TO <ft_instances>.

*     Get key fields for this entity (for %control filtering)
      DATA(lo_metadata) = NEW cl_ptf_rap_metadata( ).
      DATA(lt_key_fields) = lo_metadata->get_key_fields( iv_name = ls_operation-entity_name ).

*     Delegate to operation-specific method
      TRY.
          CASE lv_op_code.
            WHEN 'CREATE'.
              ls_operation-op = if_abap_behv=>op-m-create.
              me->process_create(
                EXPORTING
                  iv_entity_name    = ls_operation-entity_name
                  iv_step_number    = iv_step_number
                  it_reference_step = it_reference_step
                  it_key_fields     = lt_key_fields
                  is_operation      = ls_operation
                  it_json_instances = <ft_instances>
                IMPORTING
                  er_instances      = lr_instances ).

            WHEN 'CREATE_BY'.
              ls_operation-op = if_abap_behv=>op-m-create_ba.
              me->process_create_by(
                EXPORTING
                  iv_entity_name       = ls_operation-entity_name
                  iv_step_number       = iv_step_number
                  it_reference_step    = it_reference_step
                  it_key_fields        = lt_key_fields
                  is_operation         = ls_operation
                  it_json_instances    = <ft_instances>
                  iv_operation_cid_ref = lv_operation_cid_ref
                IMPORTING
                  er_instances         = lr_instances ).

            WHEN 'UPDATE'.
              ls_operation-op = if_abap_behv=>op-m-update.
              me->process_update(
                EXPORTING
                  iv_entity_name    = ls_operation-entity_name
                  iv_step_number    = iv_step_number
                  it_reference_step = it_reference_step
                  it_key_fields     = lt_key_fields
                  is_operation      = ls_operation
                  it_json_instances = <ft_instances>
                IMPORTING
                  er_instances      = lr_instances ).

            WHEN 'DELETE'.
              ls_operation-op = if_abap_behv=>op-m-delete.
              me->process_delete(
                EXPORTING
                  iv_entity_name    = ls_operation-entity_name
                  iv_step_number    = iv_step_number
                  it_reference_step = it_reference_step
                  is_operation      = ls_operation
                  it_json_instances = <ft_instances>
                IMPORTING
                  er_instances      = lr_instances ).

            WHEN 'EXECUTE'.
              ls_operation-op = if_abap_behv=>op-m-action.
              me->process_execute(
                EXPORTING
                  iv_entity_name    = ls_operation-entity_name
                  iv_step_number    = iv_step_number
                  it_reference_step = it_reference_step
                  it_key_fields     = lt_key_fields
                  is_operation      = ls_operation
                  it_json_instances = <ft_instances>
                IMPORTING
                  er_instances      = lr_instances ).
          ENDCASE.

        CATCH cx_root INTO DATA(lx_error).
          me->mo_run_environment->append_log( |Error processing { lv_op_code } for { ls_operation-entity_name }: { lx_error->get_text( ) }| ).
          CONTINUE.
      ENDTRY.

      IF lr_instances IS NOT BOUND.
        me->mo_run_environment->append_log( |Failed to process { lv_op_code } for entity { ls_operation-entity_name }| ).
        CONTINUE.
      ENDIF.

*     Store operation with instances
      ls_operation-instances = lr_instances.
      APPEND ls_operation TO et_operations.
    ENDLOOP.

    me->mo_run_environment->append_log( |Total operations created: { lines( et_operations ) }| ).

  ENDMETHOD.


  METHOD extract_document_ids.
*   Extract document IDs from PID_MAPPED (real keys) + MAPPED (preliminary keys) + operations
*   Pattern follows cl_ptf_bo_rap_generic=>retr_doc_id_from_pid_mapped + retrieve_doc_id_from_mapped
*
*   Flow: MODIFY returns %PID -> COMMIT converts to real keys -> stored in PID_MAPPED
*   All sources are checked additively (no early returns) to capture all affected instances
    DATA: lv_ptf_key      TYPE ptfkey,
          lo_metadata     TYPE REF TO cl_ptf_rap_metadata.

    FIELD-SYMBOLS: <fs_entries>    TYPE STANDARD TABLE,
                   <fs_entry>      TYPE any,
                   <fs_field>      TYPE any,
                   <fs_pid_mapped> TYPE if_ptf_bo_rap_generic_eml=>ts_pid_mapped,
                   <fs_operation>  TYPE abp_behv_changes.

    CLEAR ev_document_id.

*   Extract document IDs from PID_MAPPED (real keys after commit for CREATE operations)
    DATA(lv_pid_count) = REDUCE i( INIT cnt = 0 FOR <pid> IN it_pid_mapped WHERE ( root_name = iv_entity ) NEXT cnt = cnt + 1 ).
    me->mo_run_environment->append_log( |PID_MAPPED for { iv_entity }: found { lv_pid_count } entries| ).
    LOOP AT it_pid_mapped ASSIGNING <fs_pid_mapped> WHERE root_name = iv_entity.
      IF <fs_pid_mapped>-key IS NOT INITIAL.
        APPEND <fs_pid_mapped>-key TO ev_document_id.
        me->mo_run_environment->append_log( |Extracted key from PID_MAPPED [{ sy-tabix }]: { <fs_pid_mapped>-key }| ).
      ENDIF.
    ENDLOOP.

*   Extract from MAPPED (for entities without late numbering - CREATE operations)
    IF line_exists( it_mapped[ entity_name = iv_entity ] ).
*     Get key field metadata
      lo_metadata = NEW cl_ptf_rap_metadata( ).
      DATA(lt_components) = lo_metadata->get_key_fields( iv_name = iv_entity ).

      IF lt_components IS NOT INITIAL.
*       Extract entries from MAPPED
        DATA(lr_entries) = it_mapped[ entity_name = iv_entity ]-entries.
        ASSIGN lr_entries->* TO <fs_entries>.

        IF <fs_entries> IS ASSIGNED.
          DATA(lv_entries_count) = lines( <fs_entries> ).
          me->mo_run_environment->append_log( |MAPPED for { iv_entity }: found { lv_entries_count } entries| ).
*         Process each mapped entry (could be multiple creates)
          LOOP AT <fs_entries> ASSIGNING <fs_entry>.
            CLEAR lv_ptf_key.
            me->mo_run_environment->append_log( |Processing MAPPED entry { sy-tabix } of { lv_entries_count }| ).

*           Build PTF key from key field values
            LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
              DATA(lv_tabix) = sy-tabix.

              ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_entry> TO <fs_field>.
              IF sy-subrc = 0.
                IF lv_tabix = 1.
                  lv_ptf_key = <fs_field>.
                ELSE.
*                 Concatenate with delimiter
                  lv_ptf_key = |{ lv_ptf_key }{ cl_ptf_util=>gc_key_field_delimiter }{ <fs_field> }|.
                ENDIF.
              ENDIF.
            ENDLOOP.

*           Don't add temporary keys (ex. %00000000001) - indicated by $ or %
            IF lv_ptf_key IS NOT INITIAL AND lv_ptf_key NA '$%'.
              APPEND lv_ptf_key TO ev_document_id.
              me->mo_run_environment->append_log( |Extracted key from MAPPED: { lv_ptf_key }| ).
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDIF.

*   Extract from UPDATE/DELETE operations (keys are in the instances)

    LOOP AT it_operations ASSIGNING <fs_operation>
      WHERE entity_name = iv_entity
        AND ( op = if_abap_behv=>op-m-update OR op = if_abap_behv=>op-m-delete ).

*     Get key field metadata if not already loaded
      IF lo_metadata IS NOT BOUND.
        lo_metadata = NEW cl_ptf_rap_metadata( ).
        lt_components = lo_metadata->get_key_fields( iv_name = iv_entity ).
      ENDIF.

      IF lt_components IS INITIAL.
        me->mo_run_environment->append_log( |No key fields found for entity { iv_entity }| ).
        CONTINUE.
      ENDIF.

*     Access instances table
      ASSIGN <fs_operation>-instances->* TO <fs_entries>.
      IF <fs_entries> IS NOT ASSIGNED.
        CONTINUE.
      ENDIF.

*     Extract keys from each instance
      LOOP AT <fs_entries> ASSIGNING <fs_entry>.
        CLEAR lv_ptf_key.

*       Build PTF key from key field values in the instance
        LOOP AT lt_components ASSIGNING <fs_component>.
          lv_tabix = sy-tabix.

          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_entry> TO <fs_field>.
          IF sy-subrc = 0 AND <fs_field> IS NOT INITIAL.
            IF lv_tabix = 1.
              lv_ptf_key = <fs_field>.
            ELSE.
*             Concatenate with delimiter
              lv_ptf_key = |{ lv_ptf_key }{ cl_ptf_util=>gc_key_field_delimiter }{ <fs_field> }|.
            ENDIF.
          ENDIF.
        ENDLOOP.

        IF lv_ptf_key IS NOT INITIAL.
          APPEND lv_ptf_key TO ev_document_id.
          me->mo_run_environment->append_log( |Extracted key from { <fs_operation>-op } operation: { lv_ptf_key }| ).
        ENDIF.
      ENDLOOP.
    ENDLOOP.

*   Log summary
    IF ev_document_id IS INITIAL.
      me->mo_run_environment->append_log( |No document IDs could be extracted for entity { iv_entity }| ).
    ELSE.
      me->mo_run_environment->append_log( |Total extracted: { lines( ev_document_id ) } document ID(s) for entity { iv_entity }| ).
    ENDIF.

  ENDMETHOD.


  METHOD parse_instance_references.
*   Parse JSON /Step[x]/ references in an operation instance
*   Delegates to cl_ptf_rap_json_ref_parser for each field
    CLEAR ev_error.

    TRY.
        me->mo_ptf_rap_json_ref_parser->parse_references(
          EXPORTING
            iv_entity_name  = iv_entity_name
            iv_step_number  = iv_step_number
          IMPORTING
            ev_error        = ev_error
          CHANGING
            cs_test_data    = cs_instance ).

        IF ev_error = abap_on.
          me->mo_run_environment->append_log( |Error parsing JSON references for entity { iv_entity_name }| ).
        ENDIF.

      CATCH cx_root INTO DATA(lx_error).
        me->mo_run_environment->append_log( |Exception parsing references: { lx_error->get_text( ) }| ).
        ev_error = abap_on.
    ENDTRY.

  ENDMETHOD.


  METHOD check_ref_step_instance.
*   Check ALV reference_step field and overwrite keys in instance
*   Follows logic from cl_ptf_bo_rap_generic=>check_reference_step()
    DATA: lv_ptf_key TYPE ptfkey.

    FIELD-SYMBOLS: <fs_field>         TYPE any,
                   <fs_component>     TYPE abap_componentdescr,
                   <fs_ref_step>      TYPE any.

*   Get key fields for this entity
    DATA(lt_components) = me->mo_ptf_rap_metadata->get_key_fields( EXPORTING iv_name = iv_entity_name ).

*   Check if we have a reference step
    READ TABLE it_reference_step ASSIGNING <fs_ref_step> INDEX 1.
    IF sy-subrc <> 0 OR <fs_ref_step> IS INITIAL.
      RETURN. " No reference step
    ENDIF.

*   Issue warning if multiple reference steps
    IF lines( it_reference_step ) > 1.
      me->mo_run_environment->append_log( |Multiple reference steps mentioned, only the first one used: { <fs_ref_step> }| ).
    ENDIF.

*   Get keys from reference step
    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <fs_ref_step> ).

    TRY.
        lv_ptf_key = lt_ptf_keys[ 1 ].

*       Issue warning if multiple result IDs
        IF lines( lt_ptf_keys ) > 1.
          me->mo_run_environment->append_log( |Multiple ResultIDs provided by reference step { <fs_ref_step> }, only the first one used: { lv_ptf_key }| ).
        ENDIF.

        DATA(ls_ref_step_data) = me->mo_run_environment->get_step_data( iv_step_number = <fs_ref_step> ).

*       Handle %PID case vs regular keys
        CASE ls_ref_step_data-is_pid.
          WHEN abap_off.
*           Split compound keys and assign to key fields
            SPLIT lv_ptf_key AT cl_ptf_util=>gc_key_field_delimiter INTO TABLE DATA(lt_ptf_key_components).

            LOOP AT lt_components ASSIGNING <fs_component>.
              DATA(lv_tabix) = sy-tabix.
              READ TABLE lt_ptf_key_components ASSIGNING FIELD-SYMBOL(<fs_ptf_key_component>) INDEX lv_tabix.
              IF sy-subrc = 0.
                ASSIGN COMPONENT <fs_component>-name OF STRUCTURE cs_instance TO <fs_field>.
                IF sy-subrc = 0.
                  <fs_field> = <fs_ptf_key_component>.
                ELSE.
                  me->mo_run_environment->append_log( |Key field { <fs_component>-name } not found in instance structure| ).
                ENDIF.
              ENDIF.
            ENDLOOP.

            me->mo_run_environment->append_log( |Instance keys overwritten from reference step { <fs_ref_step> }| ).

          WHEN abap_on.
*           Assign %PID
            ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-pid OF STRUCTURE cs_instance TO <fs_field>.
            IF sy-subrc = 0.
              <fs_field> = lv_ptf_key.
              me->mo_run_environment->append_log( |Instance %PID filled from reference step { <fs_ref_step> }| ).

*             Clear other key fields
              LOOP AT lt_components ASSIGNING <fs_component>.
                ASSIGN COMPONENT <fs_component>-name OF STRUCTURE cs_instance TO <fs_field>.
                IF sy-subrc = 0 AND <fs_field> IS NOT INITIAL.
                  CLEAR <fs_field>.
                ENDIF.
              ENDLOOP.

            ELSE.
              me->mo_run_environment->append_log( 'Instance structure doesn''t have component %PID' ).
            ENDIF.

        ENDCASE.

      CATCH cx_root INTO DATA(lx_error).
        me->mo_run_environment->append_log( |Error in check_reference_step: { lx_error->get_text( ) }| ).
    ENDTRY.

  ENDMETHOD.

  METHOD process_instances.
*   Map each JSON field to corresponding EML structure field
    DATA(lo_json_descr) = CAST cl_abap_structdescr(
      cl_abap_typedescr=>describe_by_data( is_json_instance ) ).

*   Performance: iterate through JSON fields (typically 5-10) instead of target fields (80-100)
    LOOP AT lo_json_descr->components INTO DATA(ls_json_comp).
      DATA(lv_field_name) = to_upper( ls_json_comp-name ).

*     Get JSON field value
      ASSIGN COMPONENT lv_field_name OF STRUCTURE is_json_instance TO FIELD-SYMBOL(<fs_value>).
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

*     Try to assign to target EML structure
      ASSIGN COMPONENT lv_field_name OF STRUCTURE cs_instance TO FIELD-SYMBOL(<fs_field>).
      IF sy-subrc = 0.
*       Dereference field value (component values are also references)
        ASSIGN <fs_value>->* TO FIELD-SYMBOL(<actual_value>).
        IF sy-subrc = 0.
          <fs_field> = <actual_value>.
        ELSE.
*         Not a reference, use direct value (fallback for edge cases)
          <fs_field> = <fs_value>.
        ENDIF.
      ELSE.
*       Fallback: Field not found, check if it's _CID/_CID_REF and map to %CID/%CID_REF
        IF lv_field_name = '_CID'.
          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-cid OF STRUCTURE cs_instance TO <fs_field>.
          IF sy-subrc = 0.
            TRY.
                <fs_field> = <fs_value>->*.
              CATCH cx_root.
                <fs_field> = <fs_value>.
            ENDTRY.
          ENDIF.
        ELSEIF lv_field_name = '_CID_REF'.
          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-cid_ref OF STRUCTURE cs_instance TO <fs_field>.
          IF sy-subrc = 0.
            TRY.
                <fs_field> = <fs_value>->*.
              CATCH cx_root.
                <fs_field> = <fs_value>.
            ENDTRY.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.

*   Parse JSON /Step[x]/ references in target structure (now with clean values)
    me->parse_instance_references(
      EXPORTING
        iv_entity_name  = iv_entity_name
        iv_step_number  = iv_step_number
      IMPORTING
        ev_error        = DATA(lv_ref_error)
      CHANGING
        cs_instance     = cs_instance ).

    IF lv_ref_error = abap_on.
      me->mo_run_environment->append_log( |Error parsing references, but continuing with instance| ).
    ENDIF.

*   Check ALV reference_step and overwrite keys if present
    me->check_ref_step_instance(
      EXPORTING
        iv_entity_name    = iv_entity_name
        iv_step_number    = iv_step_number
        it_reference_step = it_reference_step
      CHANGING
        cs_instance       = cs_instance ).

*   Set %control fields for non-key fields
    ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-control OF STRUCTURE cs_instance TO FIELD-SYMBOL(<fs_control_struct>).
    IF sy-subrc = 0.
      LOOP AT lo_json_descr->components INTO ls_json_comp.
        lv_field_name = to_upper( ls_json_comp-name ).

*       Skip key fields - they're for identification, not modification
        DATA(lv_is_key) = abap_off.
        LOOP AT it_key_fields INTO DATA(ls_key_field).
          IF lv_field_name = to_upper( ls_key_field-name ).
            lv_is_key = abap_on.
            EXIT.
          ENDIF.
        ENDLOOP.

        IF lv_is_key = abap_on.
          CONTINUE.
        ENDIF.

*       Check if field exists in target and was populated
        ASSIGN COMPONENT lv_field_name OF STRUCTURE cs_instance TO <fs_field>.
        IF sy-subrc = 0 AND <fs_field> IS NOT INITIAL.
          ASSIGN COMPONENT lv_field_name OF STRUCTURE <fs_control_struct> TO FIELD-SYMBOL(<fs_control_field>).
          IF sy-subrc = 0.
            <fs_control_field> = if_abap_behv=>mk-on.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD validate_keys_required.
*   Common validation: operations that modify/delete existing entities need key fields
*   Validates that at least one key field is populated in each instance
    FIELD-SYMBOLS: <ft_instances> TYPE STANDARD TABLE,
                   <fs_instance>   TYPE any,
                   <fs_key_value>  TYPE any.

    ASSIGN it_instances->* TO <ft_instances>.

    DATA lv_has_empty_keys TYPE abap_bool VALUE abap_off.
    LOOP AT <ft_instances> ASSIGNING <fs_instance>.
      DATA lv_all_keys_empty TYPE abap_bool VALUE abap_on.
      LOOP AT it_key_fields INTO DATA(ls_key).
        ASSIGN COMPONENT ls_key-name OF STRUCTURE <fs_instance> TO <fs_key_value>.
        IF sy-subrc = 0 AND <fs_key_value> IS NOT INITIAL.
          lv_all_keys_empty = abap_off.
          EXIT.
        ENDIF.
      ENDLOOP.
      IF lv_all_keys_empty = abap_on.
        lv_has_empty_keys = abap_on.
        EXIT.
      ENDIF.
    ENDLOOP.

    IF lv_has_empty_keys = abap_on.
      me->mo_run_environment->append_log( |❌ { iv_operation } operation validation error| ).
      me->mo_run_environment->append_log( |Entity { iv_entity_name } requires key fields for { iv_operation }| ).
      me->mo_run_environment->append_log( 'Empty instance found: {}' ).
      me->mo_run_environment->append_log( ' ' ).
      me->mo_run_environment->append_log( 'Solutions:' ).
      me->mo_run_environment->append_log( '1. Provide key fields in JSON instances:' ).
      DATA(lv_key_example) = ''.
      LOOP AT it_key_fields INTO ls_key.
        IF sy-tabix > 1.
          lv_key_example = lv_key_example && ', '.
        ENDIF.
        lv_key_example = lv_key_example && |"{ ls_key-name }": "value"|.
      ENDLOOP.
      me->mo_run_environment->append_log( |   "instances": [\{ { lv_key_example } \}]| ).
      me->mo_run_environment->append_log( '2. OR set reference_step in PTF ALV to use keys from previous step' ).
      RAISE EXCEPTION NEW cx_ptf_json( textid = cx_ptf_json=>invalid_json ).
    ENDIF.
  ENDMETHOD.

  METHOD process_create.
*   Process CREATE operation: simple instance processing with auto-CID

    FIELD-SYMBOLS: <ft_target_table> TYPE STANDARD TABLE,
                   <fs_instance>     TYPE any,
                   <fs_json_instance> TYPE any,
                   <fs_target>       TYPE any,
                   <fs_cid>          TYPE any.

*   Create typed target table
    er_instances = cl_abap_behvdescr=>create_data(
      p_op   = if_abap_behv=>op-m-create
      p_name = iv_entity_name
      p_kind = if_abap_behv=>typekind-import ).

    ASSIGN er_instances->* TO <ft_target_table>.

*   Process each JSON instance
    LOOP AT it_json_instances ASSIGNING <fs_instance>.
      ASSIGN <fs_instance>->* TO <fs_json_instance>.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      APPEND INITIAL LINE TO <ft_target_table> ASSIGNING <fs_target>.

*     Map fields and set %control
      me->process_instances(
        EXPORTING
          iv_entity_name    = iv_entity_name
          iv_step_number    = iv_step_number
          it_reference_step = it_reference_step
          it_key_fields     = it_key_fields
          is_json_instance  = <fs_json_instance>
        CHANGING
          cs_instance       = <fs_target> ).

*     Auto-fill %CID if not provided
      ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-cid OF STRUCTURE <fs_target> TO <fs_cid>.
      IF sy-subrc = 0 AND <fs_cid> IS INITIAL.
        me->mv_global_cid_counter = me->mv_global_cid_counter + 1.
        <fs_cid> = |AUTO-{ sy-datum }{ sy-uzeit }-{ me->mv_global_cid_counter }|.
      ENDIF.
    ENDLOOP.

    me->mo_run_environment->append_log( |CREATE: Processed { lines( it_json_instances ) } instances| ).
  ENDMETHOD.

  METHOD process_create_by.
*   Process CREATE_BY operation: Create children under parent
*
*   Structure hierarchy:
*   Parent row: %CID_REF + %TARGET (NO %CONTROL at parent level)
*   Child rows (inside %TARGET): %CID + %CONTROL + child fields
*
*   Note: %CONTROL exists only at child level, not parent level
    DATA: lt_temp_children    TYPE REF TO data.

    FIELD-SYMBOLS: <ft_target_table>  TYPE STANDARD TABLE,
                   <ft_temp_children> TYPE STANDARD TABLE,
                   <fs_instance>      TYPE any,
                   <fs_json_instance> TYPE any,
                   <fs_target>        TYPE any,
                   <fs_cid>           TYPE any,
                   <fs_cid_ref>       TYPE any,
                   <ft_target>        TYPE any.

*   Create typed target table
    er_instances = cl_abap_behvdescr=>create_data(
      p_op       = if_abap_behv=>op-m-create_ba
      p_name     = iv_entity_name
      p_sub_name = is_operation-sub_name
      p_kind     = if_abap_behv=>typekind-import ).

    ASSIGN er_instances->* TO <ft_target_table>.

*   Get type of %TARGET field (child entity structure)
    DATA(lo_parent_descr) = CAST cl_abap_structdescr(
      CAST cl_abap_tabledescr( cl_abap_typedescr=>describe_by_data( <ft_target_table> ) )->get_table_line_type( ) ).

    DATA(lo_target_comp) = lo_parent_descr->get_component_type( p_name = cl_abap_behv=>co_techfield_name-target ).
    DATA(lo_target_table_descr) = CAST cl_abap_tabledescr( lo_target_comp ).

*   Create temp children table with correct child entity type (not parent type)
    CREATE DATA lt_temp_children TYPE HANDLE lo_target_table_descr.
    ASSIGN lt_temp_children->* TO <ft_temp_children>.

    LOOP AT it_json_instances ASSIGNING <fs_instance>.
      ASSIGN <fs_instance>->* TO <fs_json_instance>.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      APPEND INITIAL LINE TO <ft_temp_children> ASSIGNING <fs_target>.

*     Map fields and set %control
      me->process_instances(
        EXPORTING
          iv_entity_name    = iv_entity_name
          iv_step_number    = iv_step_number
          it_reference_step = it_reference_step
          it_key_fields     = it_key_fields
          is_json_instance  = <fs_json_instance>
        CHANGING
          cs_instance       = <fs_target> ).

*     Auto-fill %CID if not provided (children also need CID)
      ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-cid OF STRUCTURE <fs_target> TO <fs_cid>.
      IF sy-subrc = 0 AND <fs_cid> IS INITIAL.
        me->mv_global_cid_counter = me->mv_global_cid_counter + 1.
        <fs_cid> = |AUTO-{ sy-datum }{ sy-uzeit }-{ me->mv_global_cid_counter }|.
      ENDIF.
    ENDLOOP.

*   Post-processing: Move children to %TARGET
    IF iv_operation_cid_ref IS NOT INITIAL.
*     Case 1: %CID_REF provided - create one parent row with reference
      APPEND INITIAL LINE TO <ft_target_table> ASSIGNING <fs_target>.
      ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-cid_ref OF STRUCTURE <fs_target> TO <fs_cid_ref>.
      IF sy-subrc = 0.
        <fs_cid_ref> = iv_operation_cid_ref.
      ENDIF.
      ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-target OF STRUCTURE <fs_target> TO <ft_target>.
      IF sy-subrc = 0.
        <ft_target> = <ft_temp_children>.
      ENDIF.
      me->mo_run_environment->append_log( |CREATE_BY: Moved { lines( <ft_temp_children> ) } children to %TARGET under %CID_REF| ).
    ELSE.
*     Case 2: No %CID_REF - group children by parent keys and create parent rows
*     Each JSON instance should have parent key fields + child fields
*     We need to group by parent keys and create one parent row per unique parent
      DATA: lt_parent_keys TYPE string_table,
            lv_parent_key  TYPE string.

      DATA(lo_parent_meta) = NEW cl_ptf_rap_metadata( ).
      DATA(lt_parent_key_fields) = lo_parent_meta->get_key_fields( iv_name = iv_entity_name ).

*     For simplicity, assuming all instances belong to same parent (common case)
*     TODO: Handle multiple parents by grouping instances
      IF <ft_temp_children> IS NOT INITIAL.
        APPEND INITIAL LINE TO <ft_target_table> ASSIGNING <fs_target>.

*       Copy parent key fields from first child instance to parent row
        READ TABLE <ft_temp_children> INDEX 1 ASSIGNING FIELD-SYMBOL(<fs_first_child>).
        IF sy-subrc = 0.
          LOOP AT lt_parent_key_fields INTO DATA(ls_parent_key).
            ASSIGN COMPONENT ls_parent_key-name OF STRUCTURE <fs_first_child> TO FIELD-SYMBOL(<fs_parent_key_value>).
            IF sy-subrc = 0.
              ASSIGN COMPONENT ls_parent_key-name OF STRUCTURE <fs_target> TO FIELD-SYMBOL(<fs_target_parent_key>).
              IF sy-subrc = 0.
                <fs_target_parent_key> = <fs_parent_key_value>.
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDIF.

*       Move all children to %TARGET
        ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-target OF STRUCTURE <fs_target> TO <ft_target>.
        IF sy-subrc = 0.
          <ft_target> = <ft_temp_children>.
        ENDIF.
        me->mo_run_environment->append_log( |CREATE_BY: Moved { lines( <ft_temp_children> ) } children to %TARGET with parent keys| ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD process_update.
*   Process UPDATE operation: instance processing with %control for modifications

    FIELD-SYMBOLS: <ft_target_table> TYPE STANDARD TABLE,
                   <fs_instance>     TYPE any,
                   <fs_json_instance> TYPE any,
                   <fs_target>       TYPE any.

*   Create typed target table
    er_instances = cl_abap_behvdescr=>create_data(
      p_op   = if_abap_behv=>op-m-update
      p_name = iv_entity_name
      p_kind = if_abap_behv=>typekind-import ).

    ASSIGN er_instances->* TO <ft_target_table>.

*   Process each JSON instance
    LOOP AT it_json_instances ASSIGNING <fs_instance>.
      ASSIGN <fs_instance>->* TO <fs_json_instance>.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      APPEND INITIAL LINE TO <ft_target_table> ASSIGNING <fs_target>.

*     Map fields and set %control
      me->process_instances(
        EXPORTING
          iv_entity_name    = iv_entity_name
          iv_step_number    = iv_step_number
          it_reference_step = it_reference_step
          it_key_fields     = it_key_fields
          is_json_instance  = <fs_json_instance>
        CHANGING
          cs_instance       = <fs_target> ).
    ENDLOOP.

*   Validate: UPDATE requires key fields
    me->validate_keys_required(
      EXPORTING
        iv_entity_name = iv_entity_name
        iv_operation   = 'UPDATE'
        it_instances   = er_instances
        it_key_fields  = it_key_fields ).

    me->mo_run_environment->append_log( |UPDATE: Processed { lines( it_json_instances ) } instances| ).
  ENDMETHOD.

  METHOD process_delete.
*   Process DELETE operation: keys from JSON or reference_step

    DATA: lo_json_descr   TYPE REF TO cl_abap_structdescr,
          ls_json_comp    TYPE abap_compdescr,
          lv_field_name   TYPE string,
          lx_error        TYPE REF TO cx_root.

    FIELD-SYMBOLS: <ft_target_table>   TYPE STANDARD TABLE,
                   <fs_instance>       TYPE any,
                   <fs_json_instance>  TYPE any,
                   <fs_target>         TYPE any,
                   <fs_json_field>     TYPE any,
                   <fs_target_field>   TYPE any.

*   Create typed target table
    er_instances = cl_abap_behvdescr=>create_data(
      p_op   = if_abap_behv=>op-m-delete
      p_name = iv_entity_name
      p_kind = if_abap_behv=>typekind-import ).

    ASSIGN er_instances->* TO <ft_target_table>.

*   For each JSON instance, create a target row (reference_step will fill keys if JSON is empty)
    LOOP AT it_json_instances ASSIGNING <fs_instance>.
*     Always append row first (ensures reference_step can fill keys even if JSON parsing fails)
      APPEND INITIAL LINE TO <ft_target_table> ASSIGNING <fs_target>.

*     Try to copy explicit keys from JSON (if present)
      TRY.
          IF <fs_instance> IS BOUND.
            ASSIGN <fs_instance>->* TO <fs_json_instance>.
            IF <fs_json_instance> IS ASSIGNED.
              lo_json_descr = CAST cl_abap_structdescr(
                cl_abap_typedescr=>describe_by_data( <fs_json_instance> ) ).

              LOOP AT lo_json_descr->components INTO ls_json_comp.
                lv_field_name = to_upper( ls_json_comp-name ).

                ASSIGN COMPONENT lv_field_name OF STRUCTURE <fs_json_instance> TO <fs_json_field>.
                IF sy-subrc = 0.
                  ASSIGN COMPONENT lv_field_name OF STRUCTURE <fs_target> TO <fs_target_field>.
                  IF sy-subrc = 0.
*                   Dereference JSON value
                    TRY.
                        <fs_target_field> = <fs_json_field>->*.
                      CATCH cx_root.
                        <fs_target_field> = <fs_json_field>.
                    ENDTRY.
                  ENDIF.
                ENDIF.
              ENDLOOP.
            ENDIF.
          ENDIF.
        CATCH cx_root INTO lx_error.
          me->mo_run_environment->append_log( |Warning: Failed to parse JSON instance for DELETE: { lx_error->get_text( ) }| ).
      ENDTRY.

*     Apply reference_step (fills keys from previous step, overwrites JSON keys if both provided)
      me->check_ref_step_instance(
        EXPORTING
          iv_entity_name    = iv_entity_name
          iv_step_number    = iv_step_number
          it_reference_step = it_reference_step
        CHANGING
          cs_instance       = <fs_target> ).
    ENDLOOP.

*   Validate: DELETE requires key fields
    DATA(lo_metadata_del) = NEW cl_ptf_rap_metadata( ).
    DATA(lt_key_fields_del) = lo_metadata_del->get_key_fields( iv_name = iv_entity_name ).
    
    me->validate_keys_required(
      EXPORTING
        iv_entity_name = iv_entity_name
        iv_operation   = 'DELETE'
        it_instances   = er_instances
        it_key_fields  = lt_key_fields_del ).

    me->mo_run_environment->append_log( |DELETE: Processed { lines( <ft_target_table> ) } instances| ).
  ENDMETHOD.

  METHOD process_execute.
*   Process EXECUTE (action) operation: instance keys + action parameters

    FIELD-SYMBOLS: <ft_target_table> TYPE STANDARD TABLE,
                   <fs_instance>     TYPE any,
                   <fs_json_instance> TYPE any,
                   <fs_target>       TYPE any.

*   Create typed target table
    er_instances = cl_abap_behvdescr=>create_data(
      p_op       = if_abap_behv=>op-m-action
      p_name     = iv_entity_name
      p_sub_name = is_operation-sub_name
      p_kind     = if_abap_behv=>typekind-import ).

    ASSIGN er_instances->* TO <ft_target_table>.

*   Process each JSON instance
    LOOP AT it_json_instances ASSIGNING <fs_instance>.
      ASSIGN <fs_instance>->* TO <fs_json_instance>.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      APPEND INITIAL LINE TO <ft_target_table> ASSIGNING <fs_target>.

*     Map fields (keys + action parameters)
      me->process_instances(
        EXPORTING
          iv_entity_name    = iv_entity_name
          iv_step_number    = iv_step_number
          it_reference_step = it_reference_step
          it_key_fields     = it_key_fields
          is_json_instance  = <fs_json_instance>
        CHANGING
          cs_instance       = <fs_target> ).
    ENDLOOP.

*   Validate: EXECUTE (instance actions) requires key fields
*   Note: Static actions don't need keys, but we validate anyway - static actions typically have empty instances array
    me->validate_keys_required(
      EXPORTING
        iv_entity_name = iv_entity_name
        iv_operation   = |EXECUTE ({ is_operation-sub_name })|
        it_instances   = er_instances
        it_key_fields  = it_key_fields ).

    me->mo_run_environment->append_log( |EXECUTE ({ is_operation-sub_name }): Processed { lines( it_json_instances ) } instances| ).
  ENDMETHOD.

ENDCLASS.

