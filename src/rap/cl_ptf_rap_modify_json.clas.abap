class CL_PTF_RAP_MODIFY_JSON definition
  public
  final
  create public .

public section.

  class-methods DESERIALIZE
    importing
      !IV_ENTITY type ABP_ENTITY_NAME
      !IV_JSON type STRING
    exporting
      value(ET_OPERATIONS) type ABP_BEHV_CHANGES_TAB
    raising
      CX_PTF_JSON .
  PROTECTED SECTION.
private section.
ENDCLASS.



CLASS CL_PTF_RAP_MODIFY_JSON IMPLEMENTATION.


  METHOD deserialize.
*   Deserialize MODIFY JSON payload (EML-style operations array) to ABP_BEHV_CHANGES_TAB
    DATA: lr_json_data       TYPE REF TO data,
          ls_operation       TYPE abp_behv_changes,
          lr_instances       TYPE REF TO data,
          lv_json            TYPE string,
          lv_cid_counter     TYPE i VALUE 1.

    FIELD-SYMBOLS: <ft_json_ops>      TYPE STANDARD TABLE,
                   <fs_json_op>       TYPE any,
                   <fs_op>            TYPE any,
                   <fs_entity>        TYPE any,
                   <fs_sub_name>      TYPE any,
                   <fs_instances>     TYPE any,
                   <fs_instance>      TYPE any,
                   <ft_instances>     TYPE STANDARD TABLE,
                   <ft_target_table>  TYPE STANDARD TABLE,
                   <fs_target_line>   TYPE any,
                   <fs_ref>           TYPE any,
                   <fs_parent_ref>    TYPE any,
                   <fs_key>           TYPE any,
                   <fs_field>         TYPE any.

    CLEAR et_operations.

    lv_json = iv_json.

    IF lv_json IS INITIAL.
      RETURN.
    ENDIF.

*   Cleanup and validate JSON
    cl_ptf_json=>cleanup_json( CHANGING cv_json = lv_json ).
    cl_ptf_json=>validate_json( EXPORTING iv_json = lv_json ).

*   Deserialize JSON to dynamic structure
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

*   Process each operation in the array
    LOOP AT <ft_json_ops> ASSIGNING <fs_json_op>.
      CLEAR ls_operation.

*     Extract operation code
      ASSIGN COMPONENT 'OP' OF STRUCTURE <fs_json_op> TO <fs_op>.
      IF sy-subrc <> 0.
        CONTINUE. "Skip operations without 'op' field
      ENDIF.

      ASSIGN <fs_op> TO FIELD-SYMBOL(<fv_op>).

*     Map op code to EML constant
      CASE to_upper( <fv_op> ).
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
          CONTINUE. "Skip unknown operation codes
      ENDCASE.

*     Extract entity name
      ASSIGN COMPONENT 'ENTITY' OF STRUCTURE <fs_json_op> TO <fs_entity>.
      IF sy-subrc = 0.
        ASSIGN <fs_entity> TO FIELD-SYMBOL(<fv_entity>).
        ls_operation-entity_name = to_upper( <fv_entity> ).
      ELSE.
        CONTINUE. "Skip operations without entity
      ENDIF.

*     Extract sub_name (for CREATE_BY or EXECUTE)
      ASSIGN COMPONENT 'SUB_NAME' OF STRUCTURE <fs_json_op> TO <fs_sub_name>.
      IF sy-subrc = 0.
        ASSIGN <fs_sub_name> TO FIELD-SYMBOL(<fv_sub_name>).
        ls_operation-sub_name = to_upper( <fv_sub_name> ).
      ENDIF.

*     Extract instances array
      ASSIGN COMPONENT 'INSTANCES' OF STRUCTURE <fs_json_op> TO <fs_instances>.
      IF sy-subrc <> 0.
        CONTINUE. "Skip operations without instances
      ENDIF.

      ASSIGN <fs_instances> TO <ft_instances>.

*     Create target table based on operation type
      CASE ls_operation-op.
        WHEN if_abap_behv=>op-m-create.
          lr_instances = cl_abap_behvdescr=>create_data(
            p_op         = if_abap_behv=>op-m-create
            p_name       = ls_operation-entity_name
            p_data       = abap_on ).

        WHEN if_abap_behv=>op-m-create_ba.
          lr_instances = cl_abap_behvdescr=>create_data(
            p_op         = if_abap_behv=>op-m-create_ba
            p_name       = ls_operation-entity_name
            p_sub_name   = ls_operation-sub_name
            p_data       = abap_on ).

        WHEN if_abap_behv=>op-m-update.
          lr_instances = cl_abap_behvdescr=>create_data(
            p_op         = if_abap_behv=>op-m-update
            p_name       = ls_operation-entity_name
            p_data       = abap_on ).

        WHEN if_abap_behv=>op-m-delete.
          lr_instances = cl_abap_behvdescr=>create_data(
            p_op         = if_abap_behv=>op-m-delete
            p_name       = ls_operation-entity_name
            p_data       = abap_on ).

        WHEN if_abap_behv=>op-r-read.
          lr_instances = cl_abap_behvdescr=>create_data(
            p_op         = if_abap_behv=>op-r-read
            p_name       = ls_operation-entity_name
            p_sub_name   = ls_operation-sub_name
            p_data       = abap_on ).

      ENDCASE.

      IF lr_instances IS NOT BOUND.
        CONTINUE.
      ENDIF.

      ASSIGN lr_instances->* TO <ft_target_table>.

*     Process each instance
      LOOP AT <ft_instances> ASSIGNING <fs_instance>.
        ASSIGN <fs_instance> TO FIELD-SYMBOL(<fs_instance_data>).

*       Create target line
        DATA(lr_target_line) = cl_abap_behvdescr=>create_data(
          p_op         = ls_operation-op
          p_name       = ls_operation-entity_name
          p_sub_name   = COND #( WHEN ls_operation-op = if_abap_behv=>op-m-create_ba OR ls_operation-op = if_abap_behv=>op-r-read THEN ls_operation-sub_name )
          p_structure  = abap_on ).

        ASSIGN lr_target_line->* TO <fs_target_line>.

*       Handle %cid for CREATE operations
        IF ls_operation-op = if_abap_behv=>op-m-create OR ls_operation-op = if_abap_behv=>op-m-create_ba.
          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-cid OF STRUCTURE <fs_target_line> TO FIELD-SYMBOL(<fv_cid>).
          IF sy-subrc = 0.
*           Check if JSON has a "ref" field
            ASSIGN COMPONENT 'REF' OF STRUCTURE <fs_instance_data> TO <fs_ref>.
            IF sy-subrc = 0.
              ASSIGN <fs_ref> TO FIELD-SYMBOL(<fv_ref>).
              <fv_cid> = |{ <fv_ref> }|.
            ELSE.
*             Auto-generate %cid
              <fv_cid> = |cid_{ lv_cid_counter }|.
              lv_cid_counter = lv_cid_counter + 1.
            ENDIF.
          ENDIF.
        ENDIF.

*       Handle %cid_ref for CREATE_BY operations
        IF ls_operation-op = if_abap_behv=>op-m-create_ba.
          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-cid_ref OF STRUCTURE <fs_target_line> TO FIELD-SYMBOL(<fv_cid_ref>).
          IF sy-subrc = 0.
*           Check if JSON has a "parent_ref" field
            ASSIGN COMPONENT 'PARENT_REF' OF STRUCTURE <fs_instance_data> TO <fs_parent_ref>.
            IF sy-subrc = 0.
              ASSIGN <fs_parent_ref> TO FIELD-SYMBOL(<fv_parent_ref>).
              <fv_cid_ref> = |{ <fv_parent_ref> }|.
            ENDIF.

*           If no parent_ref, check for "key" structure (existing parent)
            IF <fv_cid_ref> IS INITIAL.
              ASSIGN COMPONENT 'KEY' OF STRUCTURE <fs_instance_data> TO <fs_key>.
              IF sy-subrc = 0.
*               Map key fields to %pky
                ASSIGN <fs_key> TO FIELD-SYMBOL(<fs_key_data>).
                ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-pky OF STRUCTURE <fs_target_line> TO FIELD-SYMBOL(<fs_pky>).
                IF sy-subrc = 0.
*                 Copy key fields
                  DATA(lo_struct_descr) = CAST cl_abap_structdescr(
                    cl_abap_typedescr=>describe_by_data( <fs_key_data> ) ).
                  LOOP AT lo_struct_descr->get_components( ) ASSIGNING FIELD-SYMBOL(<fs_key_comp>).
                    ASSIGN COMPONENT <fs_key_comp>-name OF STRUCTURE <fs_key_data> TO <fs_field>.
                    IF sy-subrc = 0.
                      ASSIGN <fs_field> TO FIELD-SYMBOL(<fv_key_value>).
                      ASSIGN COMPONENT <fs_key_comp>-name OF STRUCTURE <fs_pky> TO FIELD-SYMBOL(<fv_pky_field>).
                      IF sy-subrc = 0.
                        <fv_pky_field> = <fv_key_value>.
                      ENDIF.
                    ENDIF.
                  ENDLOOP.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

*       Map data fields from JSON to target structure
        DATA(lo_target_descr) = CAST cl_abap_structdescr(
          cl_abap_typedescr=>describe_by_data( <fs_instance_data> ) ).

        LOOP AT lo_target_descr->get_components( ) ASSIGNING FIELD-SYMBOL(<fs_comp>).
*         Skip special PTF fields
          IF <fs_comp>-name = 'REF' OR <fs_comp>-name = 'PARENT_REF'
            OR <fs_comp>-name = 'KEY' OR <fs_comp>-name = '_COMMENT'.
            CONTINUE.
          ENDIF.

          ASSIGN COMPONENT <fs_comp>-name OF STRUCTURE <fs_instance_data> TO <fs_field>.
          IF sy-subrc = 0.
            ASSIGN <fs_field> TO <fv_key_value>.
            ASSIGN COMPONENT <fs_comp>-name OF STRUCTURE <fs_target_line> TO FIELD-SYMBOL(<fv_target_field>).
            IF sy-subrc = 0.
              <fv_target_field> = <fv_key_value>.
*             Set %control field if it exists
              ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-control OF STRUCTURE <fs_target_line> TO FIELD-SYMBOL(<fs_control>).
              IF sy-subrc = 0.
                ASSIGN COMPONENT <fs_comp>-name OF STRUCTURE <fs_control> TO FIELD-SYMBOL(<fv_control_field>).
                IF sy-subrc = 0.
                  <fv_control_field> = if_abap_behv=>mk-on.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.

*       Append instance to target table
        INSERT <fs_target_line> INTO TABLE <ft_target_table>.

      ENDLOOP.

*     Store instances reference in operation
      ls_operation-instances = lr_instances.

*     Add operation to result table
      INSERT ls_operation INTO TABLE et_operations.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
