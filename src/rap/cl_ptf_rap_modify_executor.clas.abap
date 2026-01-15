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
      EXPORTING
        et_operations TYPE abp_behv_changes_tab
      RAISING
        cx_ptf_json .
ENDCLASS.



CLASS CL_PTF_RAP_MODIFY_EXECUTOR IMPLEMENTATION.


  METHOD constructor.
    me->mo_run_environment = io_run_environment.
    me->mo_eml = io_eml.
    me->mo_operations = io_operations.
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
          ls_message-id         = lo_message->if_t100_dyn_msg~msgid.
          ls_message-number     = lo_message->if_t100_dyn_msg~msgno.
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

*   Parse JSON array
    /ui2/cl_json=>deserialize(
        EXPORTING
          json          = lv_json
          assoc_arrays  = abap_on
        CHANGING
          data          = lr_json_data ).

    IF lr_json_data IS NOT BOUND.
      RAISE EXCEPTION NEW cx_ptf_json( textid = cx_ptf_json=>invalid_json ).
    ENDIF.

    ASSIGN lr_json_data->* TO <ft_json_ops>.
    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW cx_ptf_json( textid = cx_ptf_json=>invalid_json ).
    ENDIF.

*   Process each operation
    LOOP AT <ft_json_ops> ASSIGNING <fs_json_op>.
      CLEAR ls_operation.

*     Extract operation code
      ASSIGN COMPONENT 'OP' OF STRUCTURE <fs_json_op> TO <fs_op>.
      IF sy-subrc <> 0.
        CONTINUE. "Skip entries without 'op' field (e.g., comments)
      ENDIF.

      DATA(lv_op_code) = CONV string( <fs_op> ).
      lv_op_code = to_upper( lv_op_code ).

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

*     Extract entity name
      ASSIGN COMPONENT 'ENTITY' OF STRUCTURE <fs_json_op> TO <fs_entity>.
      IF sy-subrc = 0.
        ls_operation-entity_name = to_upper( CONV string( <fs_entity> ) ).
      ELSE.
        CONTINUE. "Skip operations without entity
      ENDIF.

*     Extract sub_name (for CREATE_BY or EXECUTE actions)
      ASSIGN COMPONENT 'SUB_NAME' OF STRUCTURE <fs_json_op> TO <fs_sub_name>.
      IF sy-subrc = 0.
        ls_operation-sub_name = to_upper( CONV string( <fs_sub_name> ) ).
      ENDIF.

*     Extract instances array
      ASSIGN COMPONENT 'INSTANCES' OF STRUCTURE <fs_json_op> TO <fs_instances>.
      IF sy-subrc <> 0.
        CONTINUE. "Skip operations without instances
      ENDIF.

      ASSIGN <fs_instances> TO <ft_instances>.

*     Create typed target table using cl_abap_behvdescr
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

      IF lr_instances IS NOT BOUND.
        CONTINUE.
      ENDIF.

      ASSIGN lr_instances->* TO <ft_target_table>.

*     Process each instance
      LOOP AT <ft_instances> ASSIGNING <fs_instance>.
        APPEND INITIAL LINE TO <ft_target_table> ASSIGNING <fs_target>.

*       Get structure components
        DATA(lo_struct_descr) = CAST cl_abap_structdescr(
          cl_abap_typedescr=>describe_by_data( <fs_target> ) ).

*       Map JSON fields to structure fields
        LOOP AT lo_struct_descr->components INTO DATA(ls_comp).
          DATA(lv_comp_name) = to_upper( ls_comp-name ).

*         Try to find matching field in JSON (case-insensitive)
          ASSIGN COMPONENT lv_comp_name OF STRUCTURE <fs_instance> TO <fs_value>.
          IF sy-subrc = 0.
            ASSIGN COMPONENT lv_comp_name OF STRUCTURE <fs_target> TO <fs_field>.
            IF sy-subrc = 0.
              <fs_field> = <fs_value>.

*             Set %control field if present
              DATA(lv_control_name) = lv_comp_name && '-' && if_abap_behv=>flag_changed.
              ASSIGN COMPONENT lv_control_name OF STRUCTURE <fs_target> TO <fs_field>.
              IF sy-subrc = 0.
                <fs_field> = if_abap_behv=>mk-on.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDLOOP.

*     Store operation with instances
      ls_operation-instances = lr_instances.
      APPEND ls_operation TO et_operations.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
