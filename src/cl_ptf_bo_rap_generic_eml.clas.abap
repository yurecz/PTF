class CL_PTF_BO_RAP_GENERIC_EML definition
  public
  create public .

public section.

  interfaces IF_PTF_BO_RAP_GENERIC_EML .

  aliases COMMIT_ENTITIES
    for IF_PTF_BO_RAP_GENERIC_EML~COMMIT_ENTITIES .
  aliases GET_PERMISSIONS
    for IF_PTF_BO_RAP_GENERIC_EML~GET_PERMISSIONS .
  aliases MODIFY_ENTITIES
    for IF_PTF_BO_RAP_GENERIC_EML~MODIFY_ENTITIES .
  aliases READ_ALL_ENTITIES
    for IF_PTF_BO_RAP_GENERIC_EML~READ_ALL_ENTITIES .
  aliases READ_ENTITIES
    for IF_PTF_BO_RAP_GENERIC_EML~READ_ENTITIES .

  methods CONSTRUCTOR .
protected section.
private section.

  data MO_PTF_RAP_METADATA type ref to IF_PTF_RAP_METADATA .

  methods RECURSIVE_DEL_ASSOCS
    importing
      !IV_ENTITY_NAME type ABP_ENTITY_NAME
    changing
      !CT_ASSOCIATIONS type CL_ABAP_BEHV_LOAD=>TT_ASSOC .
ENDCLASS.



CLASS CL_PTF_BO_RAP_GENERIC_EML IMPLEMENTATION.


  METHOD constructor.
    me->mo_ptf_rap_metadata = NEW cl_ptf_rap_metadata( ).

  ENDMETHOD.


  METHOD if_ptf_bo_rap_generic_eml~commit_entities.

    DATA lt_failed_pid TYPE STANDARD TABLE OF abp_behv_pid.
    DATA lr_pkey TYPE REF TO data.
    DATA lt_keys TYPE STANDARD TABLE OF string.

    FIELD-SYMBOLS: <fs_pid_mapped> TYPE if_ptf_bo_rap_generic_eml=>ts_pid_mapped,
                   <fs_pkey>       TYPE any.

    CLEAR: et_failed, et_reported.

    CASE iv_simulation.

      WHEN abap_off.
*        COMMIT ENTITIES RESPONSES OF it_root_entities
*          FAILED et_failed
*          REPORTED et_reported.

        COMMIT ENTITIES BEGIN RESPONSES OF it_root_entities
          FAILED et_failed
          REPORTED et_reported.
        IF sy-subrc <> 0.
          "Collect PIDs from FAILED
          LOOP AT et_failed ASSIGNING FIELD-SYMBOL(<fs_failed>).
            ASSIGN <fs_failed>-entries->* TO FIELD-SYMBOL(<lt_failed_entries>).
            ASSERT sy-subrc IS INITIAL.
            LOOP AT <lt_failed_entries> ASSIGNING FIELD-SYMBOL(<ls_failed_entry>).
              ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-pid OF STRUCTURE <ls_failed_entry> TO FIELD-SYMBOL(<lv_pid>).
              IF sy-subrc IS INITIAL.
                APPEND <lv_pid> TO lt_failed_pid.
              ENDIF.
            ENDLOOP.
          ENDLOOP.
        ENDIF.

        LOOP AT ct_pid_mapped ASSIGNING <fs_pid_mapped>.

          "Do nothing if PID was returned in FAILED
          IF <fs_pid_mapped>-pid IS NOT INITIAL  AND  line_exists( lt_failed_pid[ table_line = <fs_pid_mapped>-pid ] ).
            CONTINUE.
          ENDIF.

          " Convert the PID

          "Create target structure
          CLEAR lr_pkey.
          lr_pkey  = cl_abap_behvdescr=>create_data(  "TO
                                 p_name      = <fs_pid_mapped>-root_name
                                 p_op        = cl_abap_behvdescr=>op_primarykey   "same as cl_abap_behv_ctrl=>d010behv_op-virtual-primarykey
                                 p_structure = abap_on
                           ).
          ASSIGN lr_pkey->* TO <fs_pkey>.

*          IF <fs_pid_mapped>-root_name NE 'I_QLTYNOTIFICATIONTP' AND <fs_pid_mapped>-root_name NE 'R_QLTYNOTIFICATIONTP'
*            AND <fs_pid_mapped>-root_name NE 'I_EQUIPMENTTP' AND <fs_pid_mapped>-root_name NE 'R_EQUIPMENTTP'.                      "for now, only active for selected examples
          IF <fs_pid_mapped>-r_pre IS NOT BOUND.

            "Std preliminary case with pid only
            CONVERT KEY OF (<fs_pid_mapped>-root_name) FROM <fs_pid_mapped>-pid TO <fs_pkey>.
*
          ELSE.

            "special case (preliminary Key is not just %PID, but uses, additionally or only, primary key fields)
            IF <fs_pid_mapped>-r_pre->* IS NOT INITIAL.
              ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-pre OF STRUCTURE <fs_pid_mapped>-r_pre->* TO FIELD-SYMBOL(<ls_pre>).    "co_techfield_name-pre is '%PRE'    (%PID and %KEY)
              ASSERT sy-subrc EQ 0.
*              ASSIGN COMPONENT '%TMP' OF STRUCTURE <fs_pid_mapped>-r_pre->* TO FIELD-SYMBOL(<...>).  not needed

              CONVERT KEY OF (<fs_pid_mapped>-root_name) FROM <ls_pre> TO <fs_pkey>.
            ENDIF.

          ENDIF.

          CLEAR lt_keys.
          LOOP AT me->mo_ptf_rap_metadata->get_key_fields( <fs_pid_mapped>-root_name ) REFERENCE INTO DATA(lr_component).

            ASSIGN COMPONENT lr_component->name OF STRUCTURE <fs_pkey> TO FIELD-SYMBOL(<fs_key>).
            CHECK sy-subrc = 0.
            DATA(lr_key) = NEW string( ).
            lr_key->* = <fs_key>.
            INSERT lr_key->* INTO  TABLE lt_keys.

          ENDLOOP.

          <fs_pid_mapped>-key = concat_lines_of( table = lt_keys sep = cl_ptf_util=>gc_key_field_delimiter ).

        ENDLOOP.

        COMMIT ENTITIES END.


      WHEN abap_on.
*        COMMIT ENTITIES IN SIMULATION MODE RESPONSES OF it_root_entities
*          FAILED et_failed
*          REPORTED et_reported.

        COMMIT ENTITIES BEGIN  IN SIMULATION MODE  RESPONSES OF it_root_entities
          FAILED et_failed
          REPORTED et_reported.
        IF sy-subrc <> 0 ##NEEDED. "New SLIN requirement, to be filled in the future

        ENDIF.
*If there is an error in the early or late save phase, this can be determined using sy-subrc after COMMIT ENTITIES or COMMIT ENTITIES BEGIN.
* It is not guaranteed that the FAILED parameter contains all errors when RESPONSE is used in, for example, nested BO RAP entities. To be able to respond to an error, sy-subrc must be queried.
*
*Procedure
*Sy-subrc must be evaluated after COMMIT ENTITIES. In the case of an error in the early save phase, sy-subrc = 4; in the late save phase, sy-subrc = 8.
*When using COMMIT ENTITIES BEGIN, sy-subrc must be queried after COMMIT ENTITIES BEGIN and not after COMMIT ENTITIES END.


        LOOP AT ct_pid_mapped ASSIGNING <fs_pid_mapped>.

          cl_abap_behv_load=>get_load( EXPORTING entity = <fs_pid_mapped>-root_name IMPORTING head = DATA(ls_head)  ).
          IF ls_head-with_late_numbering EQ abap_on.
            CLEAR ls_head.
            CONTINUE.
          ENDIF.

          "Do nothing if returned in FAILED
          IF line_exists( lt_failed_pid[ table_line = <fs_pid_mapped>-pid ] ).
            CONTINUE.
          ENDIF.

*         Convert the PID
          CLEAR lr_pkey.
          lr_pkey  = cl_abap_behvdescr=>create_data(
                                 p_name      = <fs_pid_mapped>-root_name
                                 p_op        = cl_abap_behv_ctrl=>d010behv_op-virtual-primarykey
                                 p_structure = abap_on
                           ).
          ASSIGN lr_pkey->* TO <fs_pkey>.

          CONVERT KEY OF (<fs_pid_mapped>-root_name) FROM <fs_pid_mapped>-pid TO <fs_pkey>.

          CLEAR lt_keys.
          LOOP AT me->mo_ptf_rap_metadata->get_key_fields( <fs_pid_mapped>-root_name ) REFERENCE INTO lr_component.

            ASSIGN COMPONENT lr_component->name OF STRUCTURE <fs_pkey> TO <fs_key>.
            CHECK sy-subrc = 0.
            lr_key = NEW string( ).
            lr_key->* = <fs_key>.
            INSERT lr_key->* INTO  TABLE lt_keys.

          ENDLOOP.

          <fs_pid_mapped>-key = concat_lines_of( table = lt_keys sep = cl_ptf_util=>gc_key_field_delimiter ).

        ENDLOOP.

        COMMIT ENTITIES END.

    ENDCASE.

  ENDMETHOD.


  METHOD if_ptf_bo_rap_generic_eml~get_permissions.
    GET PERMISSIONS "ONLY INSTANCE FEATURES "ONLY GLOBAL "ONLY INSTANCE FEATURES
      OPERATIONS ct_operations
      FAILED et_failed
      REPORTED et_reported.

  ENDMETHOD.


  METHOD if_ptf_bo_rap_generic_eml~modify_entities.
    MODIFY ENTITIES
      OPERATIONS ct_operations
      FAILED et_failed
      MAPPED et_mapped
      REPORTED et_reported.

  ENDMETHOD.


  METHOD if_ptf_bo_rap_generic_eml~read_all_entities.
    DATA: lr_dyn_row      TYPE REF TO data,
          lo_structdescr  TYPE REF TO cl_abap_structdescr,
          lt_failed       TYPE abp_behv_response_tab,
          lt_reported     TYPE abp_behv_response_tab,
          lt_operations   TYPE abp_behv_retrievals_tab,
          ls_operation    TYPE abp_behv_retrievals.

    FIELD-SYMBOLS: <fs_instances> TYPE STANDARD TABLE.

    IF ct_operations IS INITIAL.
      RETURN.

    ENDIF.

*   Remove child operations if we have root operation
    IF line_exists( ct_operations[ op = cl_abap_behvdescr=>op_read sub_name = space ] ).
      DELETE ct_operations WHERE sub_name IS NOT INITIAL.

    ENDIF.

    me->read_entities(
      IMPORTING
        et_failed     = lt_failed
        et_reported   = lt_reported
      CHANGING
        ct_operations = ct_operations
    ).

*   FAILED and REPORTED are SORTED tables with unique key
    INSERT LINES OF lt_failed INTO TABLE ct_failed.
    INSERT LINES OF lt_reported INTO TABLE ct_reported.

    LOOP AT ct_operations ASSIGNING FIELD-SYMBOL(<fs_operation>).
      cl_abap_behv_load=>get_load(
        EXPORTING
          entity        = <fs_operation>-entity_name
          all           = abap_on
        IMPORTING
          associations  = DATA(lt_associations)
      ).

*     Delete all associations with reverse relationship
      me->recursive_del_assocs(
        EXPORTING
          iv_entity_name  = <fs_operation>-entity_name
        CHANGING
          ct_associations = lt_associations ).

      IF <fs_operation>-sub_name IS NOT INITIAL.
        DATA(lv_source_entity) = lt_associations[ source_entity = <fs_operation>-entity_name name = <fs_operation>-sub_name ]-target_entity.

        DELETE lt_associations WHERE source_entity <> lv_source_entity.

      ELSE.
        DELETE lt_associations WHERE source_entity <> <fs_operation>-entity_name.

      ENDIF.

      LOOP AT lt_associations ASSIGNING FIELD-SYMBOL(<fs_association>) WHERE properties-enabled = cl_abap_behv_load=>c_enabled.
        CLEAR ls_operation.

        ls_operation-entity_name  = <fs_association>-source_entity. "is_step_data-bus_obj
        ls_operation-sub_name     = <fs_association>-name.

        ls_operation-instances = cl_abap_behvdescr=>create_data(
                                  p_name      = <fs_association>-source_entity
                                  p_op        = cl_abap_behvdescr=>op_read_ba
                                  p_sub_name  = <fs_association>-name
                                  p_kind      = if_abap_behv=>typekind-import
                               ).

*       Value the FULL flag, because some behavior implementations keep account of this flag
*       and don't bring RESULTS if it's not valued
        ls_operation-full    = abap_on.

        ls_operation-results = cl_abap_behvdescr=>create_data(
                                  p_name      = <fs_association>-source_entity
                                  p_op        = if_abap_behv=>op-r-read_ba
                                  p_sub_name  = <fs_association>-name
                                  p_kind      = if_abap_behv=>typekind-result
                               ).

        ls_operation-op           = cl_abap_behvdescr=>op_read_ba.

        ASSIGN ls_operation-instances->* TO <fs_instances>.

        LOOP AT <fs_operation>-results->* ASSIGNING FIELD-SYMBOL(<fs_result>).
          CREATE DATA lr_dyn_row LIKE LINE OF <fs_instances>.
          ASSIGN lr_dyn_row->* TO FIELD-SYMBOL(<fs_dyn_row>).

          TRY.
              <fs_dyn_row> = CORRESPONDING #( <fs_result> ).

            CATCH cx_sy_conversion_error ##NO_HANDLER.
          ENDTRY.

          ASSIGN COMPONENT cl_abap_behv=>co_techfield_name-control OF STRUCTURE <fs_dyn_row> TO FIELD-SYMBOL(<fs_control>).
          IF sy-subrc = 0.
            lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_control> ).
            DATA(lt_components) = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

            LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
*             Mark all the fields
              ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_control> TO FIELD-SYMBOL(<fs_flag_control>).
              IF sy-subrc = 0.
                <fs_flag_control> = cl_abap_behv=>flag_changed.

              ENDIF.

            ENDLOOP.

          ENDIF.

          APPEND <fs_dyn_row> TO <fs_instances>.

        ENDLOOP.

        SORT <fs_instances>.
        DELETE ADJACENT DUPLICATES FROM <fs_instances>.

        APPEND ls_operation TO lt_operations.

      ENDLOOP.

    ENDLOOP.

    me->if_ptf_bo_rap_generic_eml~read_all_entities(
      CHANGING
        ct_failed     = ct_failed
        ct_reported   = ct_reported
        ct_operations = lt_operations
    ).

    APPEND LINES OF lt_operations TO ct_operations.

  ENDMETHOD.


  METHOD if_ptf_bo_rap_generic_eml~read_entities.
    READ ENTITIES
      OPERATIONS ct_operations
      FAILED et_failed
      REPORTED et_reported.

  ENDMETHOD.


  METHOD recursive_del_assocs.
    DATA(lt_associations) = FILTER #( ct_associations WHERE source_entity = iv_entity_name ).
    ct_associations = FILTER #( ct_associations EXCEPT WHERE source_entity = iv_entity_name ).
    DELETE ct_associations WHERE target_entity = iv_entity_name.

    LOOP AT lt_associations ASSIGNING FIELD-SYMBOL(<fs_association>) WHERE source_entity = iv_entity_name.
      DATA(lv_entity_name) = <fs_association>-target_entity.

      me->recursive_del_assocs(
        EXPORTING
          iv_entity_name  = lv_entity_name
        CHANGING
          ct_associations = ct_associations ).

    ENDLOOP.

    INSERT LINES OF lt_associations INTO TABLE ct_associations.

  ENDMETHOD.
ENDCLASS.
