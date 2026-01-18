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
        ev_check_status = abap_off.
        RETURN.
    ENDTRY.

    IF lt_operations IS INITIAL.
      me->mo_run_environment->append_log( 'No operations found in JSON payload' ).
      ev_execution_status = abap_off.
      ev_check_status = abap_off.
      RETURN.
    ENDIF.

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
      ev_check_status = abap_off.

*     Add messages to step attributes
      IF lt_messages IS NOT INITIAL.
        MOVE-CORRESPONDING lt_messages TO lt_act_messages.
        cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~add_actual_messages( lt_act_messages ).
      ENDIF.

      RETURN.
    ENDIF.

*   Fill list of root entities for commit
    IF NOT line_exists( lt_root_entities[ table_line = ls_step_data-bus_obj ] ).
      INSERT ls_step_data-bus_obj INTO TABLE lt_root_entities.
    ENDIF.

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
      me->extract_document_ids(
        EXPORTING
          iv_entity      = ls_step_data-bus_obj
          it_pid_mapped  = lt_pid_mapped
          it_mapped      = lt_mapped
          it_operations  = lt_operations
        IMPORTING
          ev_document_id = ev_document_id ).

*     Log extracted document IDs
      IF ev_document_id IS NOT INITIAL.
        LOOP AT ev_document_id ASSIGNING FIELD-SYMBOL(<lv_doc_id>).
          DATA(lv_doc_id_str) = CONV string( <lv_doc_id> ).
          me->mo_run_environment->append_log( |Extracted document ID: { lv_doc_id_str }| ).
        ENDLOOP.
      ELSE.
        me->mo_run_environment->append_log( 'No document IDs extracted from MAPPED table' ).
      ENDIF.
    ENDIF.

*   Set return values
    IF lv_error = abap_off.
      ev_execution_status = abap_on.
      ev_check_status = abap_on.
    ELSE.
      ev_execution_status = abap_off.
      ev_check_status = abap_off.
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
      RAISE EXCEPTION NEW cx_ptf_json( textid = cx_ptf_json=>invalid_json ).
    ENDIF.

    ASSIGN lr_json_data->* TO <ft_json_ops>.
    IF sy-subrc <> 0.
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

*     Map op code to EML constant
      CASE lv_op_code.
        WHEN 'CREATE'.
          ls_operation-op = if_abap_behv=>op-m-create.
        WHEN 'CREATE_BY'.
          ls_operation-op = if_abap_behv=>op-m-create_ba.
        WHEN 'UPDATE'.
          ls_operation-op = if_abap_behv=>op-m-update.
        WHEN 'DELETE'.
          ls_operation-op = if_abap_behv=>op-m-delete.
        WHEN 'EXECUTE'.
          ls_operation-op = if_abap_behv=>op-m-action.
        WHEN OTHERS.
          CONTINUE. "Skip unknown operations
      ENDCASE.

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

*     Create typed target table using cl_abap_behvdescr
      TRY.
          CASE ls_operation-op.
            WHEN if_abap_behv=>op-m-create.
              lr_instances = cl_abap_behvdescr=>create_data(
                p_op       = if_abap_behv=>op-m-create
                p_name     = ls_operation-entity_name
                p_kind     = if_abap_behv=>typekind-import ).

            WHEN if_abap_behv=>op-m-create_ba.
              lr_instances = cl_abap_behvdescr=>create_data(
                p_op       = if_abap_behv=>op-m-create_ba
                p_name     = ls_operation-entity_name
                p_sub_name = ls_operation-sub_name
                p_kind     = if_abap_behv=>typekind-import ).

            WHEN if_abap_behv=>op-m-update.
              lr_instances = cl_abap_behvdescr=>create_data(
                p_op       = if_abap_behv=>op-m-update
                p_name     = ls_operation-entity_name
                p_kind     = if_abap_behv=>typekind-import ).

            WHEN if_abap_behv=>op-m-delete.
              lr_instances = cl_abap_behvdescr=>create_data(
                p_op       = if_abap_behv=>op-m-delete
                p_name     = ls_operation-entity_name
                p_kind     = if_abap_behv=>typekind-import ).

            WHEN if_abap_behv=>op-m-action.
              lr_instances = cl_abap_behvdescr=>create_data(
                p_op       = if_abap_behv=>op-m-action
                p_name     = ls_operation-entity_name
                p_sub_name = ls_operation-sub_name
                p_kind     = if_abap_behv=>typekind-import ).
          ENDCASE.

        CATCH cx_root INTO DATA(lx_error).
          me->mo_run_environment->append_log( |Error creating data structure for { ls_operation-entity_name }: { lx_error->get_text( ) }| ).
          CONTINUE.
      ENDTRY.

      IF lr_instances IS NOT BOUND.
        me->mo_run_environment->append_log( |Failed to create data structure for entity { ls_operation-entity_name }| ).
        CONTINUE.
      ENDIF.

      ASSIGN lr_instances->* TO <ft_target_table>.

*     Get key fields for this entity (for %control filtering)
      DATA(lo_metadata) = NEW cl_ptf_rap_metadata( ).
      DATA(lt_key_fields) = lo_metadata->get_key_fields( iv_name = ls_operation-entity_name ).

*     Special handling for CREATE_BY with operation-level %CID_REF
      IF ls_operation-op = if_abap_behv=>op-m-create_ba AND lv_operation_cid_ref IS NOT INITIAL.
*       Create ONE parent row with %cid_ref and %target containing all children
        DATA(lr_parent_line) = cl_abap_behvdescr=>create_data(
          p_op         = if_abap_behv=>op-m-create_ba
          p_name       = ls_operation-entity_name
          p_sub_name   = ls_operation-sub_name
          p_structure  = abap_on ).

        ASSIGN lr_parent_line->* TO FIELD-SYMBOL(<fs_parent_line>).

*       Set %cid_ref on parent row
        ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-cid_ref OF STRUCTURE <fs_parent_line> TO FIELD-SYMBOL(<fv_cid_ref_parent>).
        IF sy-subrc = 0.
          <fv_cid_ref_parent> = lv_operation_cid_ref.
          me->mo_run_environment->append_log( |Set %CID_REF on parent row: { <fv_cid_ref_parent> }| ).
        ENDIF.

*       Create %target table for children
        ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-target OF STRUCTURE <fs_parent_line> TO FIELD-SYMBOL(<ft_target>).
        IF sy-subrc <> 0.
          me->mo_run_environment->append_log( |ERROR: Failed to find %TARGET component in CREATE_BY structure| ).
          CONTINUE.
        ENDIF.

*       Process each child instance and add to %target
        DATA(lv_child_counter) = 0.
        LOOP AT <ft_instances> ASSIGNING FIELD-SYMBOL(<fs_child_json>).
          lv_child_counter = lv_child_counter + 1.

*         Dereference child instance
          ASSIGN <fs_child_json>->* TO FIELD-SYMBOL(<json_child_instance>).
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.

*         Create child line
          DATA(lr_child_line) = cl_abap_behvdescr=>create_data(
            p_op         = if_abap_behv=>op-m-create_ba
            p_name       = ls_operation-entity_name
            p_sub_name   = ls_operation-sub_name
            p_structure  = abap_on ).

          ASSIGN lr_child_line->* TO FIELD-SYMBOL(<fs_child_line>).

*         Map JSON fields to child structure
          DATA(lo_child_descr) = CAST cl_abap_structdescr(
            cl_abap_typedescr=>describe_by_data( <json_child_instance> ) ).

          LOOP AT lo_child_descr->components INTO DATA(ls_child_comp).
            DATA(lv_child_field_name) = to_upper( ls_child_comp-name ).

*           Get JSON field value
            ASSIGN COMPONENT lv_child_field_name OF STRUCTURE <json_child_instance> TO FIELD-SYMBOL(<fs_child_value>).
            IF sy-subrc <> 0.
              CONTINUE.
            ENDIF.

*           Try to assign to target child structure
            ASSIGN COMPONENT lv_child_field_name OF STRUCTURE <fs_child_line> TO FIELD-SYMBOL(<fs_child_field>).
            IF sy-subrc = 0.
*             Dereference field value
              TRY.
                  ASSIGN <fs_child_value>->* TO FIELD-SYMBOL(<actual_child_value>).
                  <fs_child_field> = <actual_child_value>.
                CATCH cx_root.
                  <fs_child_field> = <fs_child_value>.
              ENDTRY.

*             Set %control for non-key fields
              IF NOT line_exists( lt_key_fields[ name = lv_child_field_name ] ) AND <fs_child_field> IS NOT INITIAL.
                ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-control OF STRUCTURE <fs_child_line> TO FIELD-SYMBOL(<fs_child_control_struct>).
                IF sy-subrc = 0.
                  ASSIGN COMPONENT lv_child_field_name OF STRUCTURE <fs_child_control_struct> TO FIELD-SYMBOL(<fs_child_control_field>).
                  IF sy-subrc = 0.
                    <fs_child_control_field> = if_abap_behv=>mk-on.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDLOOP.

*         Auto-generate %CID for child if not provided
          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-cid OF STRUCTURE <fs_child_line> TO FIELD-SYMBOL(<fv_child_cid>).
          IF sy-subrc = 0 AND <fv_child_cid> IS INITIAL.
            <fv_child_cid> = |AUTO-{ sy-datum }{ sy-uzeit }-{ lv_child_counter }|.
          ENDIF.

*         Parse JSON references in child instance
          me->parse_instance_references(
            EXPORTING
              iv_entity_name  = ls_operation-entity_name
              iv_step_number  = iv_step_number
            IMPORTING
              ev_error        = DATA(lv_child_ref_error)
            CHANGING
              cs_instance     = <fs_child_line> ).

*         Check ALV reference_step for child
          me->check_ref_step_instance(
            EXPORTING
              iv_entity_name    = ls_operation-entity_name
              iv_step_number    = iv_step_number
              it_reference_step = it_reference_step
            CHANGING
              cs_instance       = <fs_child_line> ).

*         Add child to %target table
          INSERT <fs_child_line> INTO TABLE <ft_target>.
        ENDLOOP.

*       Insert the ONE parent row (with %cid_ref and %target) into result table
        INSERT <fs_parent_line> INTO TABLE <ft_target_table>.
        me->mo_run_environment->append_log( |CREATE_BY with %CID_REF: Added 1 parent row with { lv_child_counter } children in %TARGET| ).

      ELSE.
*       Standard processing for CREATE, UPDATE, DELETE, EXECUTE (one row per JSON instance)
*       Also for CREATE_BY without %CID_REF (direct parent keys in instances)
        DATA(lv_instance_counter) = 0.
        LOOP AT <ft_instances> ASSIGNING <fs_instance>.
        lv_instance_counter = lv_instance_counter + 1.
*       Dereference instance element (array element -> structure)
        ASSIGN <fs_instance>->* TO FIELD-SYMBOL(<json_instance>).
        IF sy-subrc <> 0.
          CONTINUE. "Skip invalid instance elements
        ENDIF.

        APPEND INITIAL LINE TO <ft_target_table> ASSIGNING <fs_target>.

*       Get structure components of JSON instance (more efficient: iterate over fewer fields)
        DATA(lo_json_descr) = CAST cl_abap_structdescr(
          cl_abap_typedescr=>describe_by_data( <json_instance> ) ).

*       Map each JSON field to corresponding EML structure field (dereference JSON values)
*       Performance: iterate through JSON fields (typically 5-10) instead of target fields (80-100)
        LOOP AT lo_json_descr->components INTO DATA(ls_json_comp).
          DATA(lv_field_name) = to_upper( ls_json_comp-name ).

*         Get JSON field value
          ASSIGN COMPONENT lv_field_name OF STRUCTURE <json_instance> TO <fs_value>.
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.

*         Try to assign to target EML structure
          ASSIGN COMPONENT lv_field_name OF STRUCTURE <fs_target> TO <fs_field>.
          IF sy-subrc = 0.
*           Dereference field value (component values are also references)
            ASSIGN <fs_value>->* TO FIELD-SYMBOL(<actual_value>).
            IF sy-subrc = 0.
              <fs_field> = <actual_value>.
            ELSE.
*             Not a reference, use direct value (fallback for edge cases)
              <fs_field> = <fs_value>.
            ENDIF.
          ENDIF.
        ENDLOOP.

*       Parse JSON /Step[x]/ references in target structure (now with clean values)
        me->parse_instance_references(
          EXPORTING
            iv_entity_name  = ls_operation-entity_name
            iv_step_number  = iv_step_number
          IMPORTING
            ev_error        = DATA(lv_ref_error)
          CHANGING
            cs_instance     = <fs_target> ).

        IF lv_ref_error = abap_on.
          me->mo_run_environment->append_log( |Error parsing references, but continuing with instance| ).
        ENDIF.

*       Check ALV reference_step and overwrite keys if present
        me->check_ref_step_instance(
          EXPORTING
            iv_entity_name    = ls_operation-entity_name
            iv_step_number    = iv_step_number
            it_reference_step = it_reference_step
          CHANGING
            cs_instance       = <fs_target> ).

*       Set %control fields for non-key fields
        LOOP AT lt_key_fields INTO DATA(ls_key_field).
          DATA(lv_key_name) = to_upper( ls_key_field-name ).

          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-control OF STRUCTURE <fs_target> TO FIELD-SYMBOL(<fs_control_struct>).
          IF sy-subrc = 0.
            LOOP AT lo_json_descr->components INTO ls_json_comp.
              lv_field_name = to_upper( ls_json_comp-name ).

*             Skip key fields - they're for identification, not modification
              IF lv_field_name = lv_key_name.
                CONTINUE.
              ENDIF.

*             Check if field exists in target and was populated
              ASSIGN COMPONENT lv_field_name OF STRUCTURE <fs_target> TO <fs_field>.
              IF sy-subrc = 0 AND <fs_field> IS NOT INITIAL.
                ASSIGN COMPONENT lv_field_name OF STRUCTURE <fs_control_struct> TO FIELD-SYMBOL(<fs_control_field>).
                IF sy-subrc = 0.
                  <fs_control_field> = if_abap_behv=>mk-on.
                ENDIF.
              ENDIF.
            ENDLOOP.
          ENDIF.
        ENDLOOP.

*       Auto-fill %CID for CREATE operations if not provided or initial
        IF ls_operation-op = if_abap_behv=>op-m-create.
          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-cid OF STRUCTURE <fs_target> TO FIELD-SYMBOL(<fs_cid>).
          IF sy-subrc = 0 AND <fs_cid> IS INITIAL.
*           Generate unique CID: AUTO-{step}-{instance}
            <fs_cid> = |AUTO-{ sy-datum }{ sy-uzeit }-{ lv_instance_counter }|.
            me->mo_run_environment->append_log( |Auto-generated %CID: { <fs_cid> }| ).
          ENDIF.
        ENDIF.

*       Auto-fill %CID for CREATE_BY operations if not provided or initial
        IF ls_operation-op = if_abap_behv=>op-m-create_ba.
          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-cid OF STRUCTURE <fs_target> TO <fs_cid>.
          IF sy-subrc = 0 AND <fs_cid> IS INITIAL.
*           Generate unique CID for child entity
            <fs_cid> = |AUTO-{ sy-datum }{ sy-uzeit }-{ lv_instance_counter }|.
            me->mo_run_environment->append_log( |Auto-generated %CID for CREATE_BY: { <fs_cid> }| ).
          ENDIF.
        ENDIF.
      ENDLOOP.
      ENDIF. "End of CREATE_BY vs standard processing branch

*     Store operation with instances
      ls_operation-instances = lr_instances.
      APPEND ls_operation TO et_operations.
      me->mo_run_environment->append_log( |Added operation for entity { ls_operation-entity_name } with { lines( <ft_target_table> ) } instances| ).
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
    LOOP AT it_pid_mapped ASSIGNING <fs_pid_mapped> WHERE root_name = iv_entity.
      IF <fs_pid_mapped>-key IS NOT INITIAL.
        APPEND <fs_pid_mapped>-key TO ev_document_id.
        me->mo_run_environment->append_log( |Extracted key from PID_MAPPED: { <fs_pid_mapped>-key }| ).
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
*         Process each mapped entry (could be multiple creates)
          LOOP AT <fs_entries> ASSIGNING <fs_entry>.
            CLEAR lv_ptf_key.

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

ENDCLASS.
