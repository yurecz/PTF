class CL_PTF_RAP_METADATA definition
  public
  create public .

public section.

  interfaces IF_PTF_RAP_METADATA .

  aliases CHECK_RAP_BO
    for IF_PTF_RAP_METADATA~CHECK_RAP_BO .
  aliases CHECK_RAP_BO_ACTION
    for IF_PTF_RAP_METADATA~CHECK_RAP_BO_ACTION .
  aliases CHECK_RAP_BO_BDEF_ACTION
    for IF_PTF_RAP_METADATA~CHECK_RAP_BO_BDEF_ACTION .
  aliases CHECK_RAP_BO_CHECK_ACTION
    for IF_PTF_RAP_METADATA~CHECK_RAP_BO_CHECK_ACTION .
  aliases GET_KEY_FIELDS
    for IF_PTF_RAP_METADATA~GET_KEY_FIELDS .
  aliases RECURSIVE_GET_COMPONENTS
    for IF_PTF_RAP_METADATA~RECURSIVE_GET_COMPONENTS .
  PROTECTED SECTION.
private section.
ENDCLASS.



CLASS CL_PTF_RAP_METADATA IMPLEMENTATION.


  METHOD if_ptf_rap_metadata~check_rap_bo.
    rv_is_rap_bo = abap_off.

    SELECT SINGLE obj_name
      INTO @DATA(lv_obj_name)
      FROM tadir
     WHERE tadir~pgmid      = 'R3TR'
       AND tadir~object     = 'BDEF'
       AND tadir~obj_name   = @iv_bus_obj ##NEEDED.
    IF sy-subrc = 0.
      rv_is_rap_bo = abap_on.

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_rap_metadata~check_rap_bo_action.
    DATA lo_abap_classdescr TYPE REF TO cl_abap_classdescr.

    rv_is_rap_bo_action = abap_off.

    DATA(lv_is_rap_bo) = check_rap_bo( iv_bus_obj ).

    IF lv_is_rap_bo = abap_off.
      RETURN.
    ENDIF.

*   get the list of methods of the generic rap bo class
    lo_abap_classdescr ?= cl_abap_classdescr=>describe_by_name( p_name = 'CL_PTF_BO_RAP_GENERIC' ).

    DATA(lt_methods) = lo_abap_classdescr->methods.

    DELETE lt_methods WHERE visibility <> cl_abap_objectdescr=>public.

*   Delete other not used methods
    DELETE lt_methods WHERE name = 'CONSTRUCTOR'.
    DELETE lt_methods WHERE name = 'IS_NEW_VERSION'.
    DELETE lt_methods WHERE name = 'CHECK_EXISTENCE'.
    DELETE lt_methods WHERE name = 'EXECUTE_CHECK'.
    DELETE lt_methods WHERE name = 'EXECUTE_ACTION'.

    READ TABLE lt_methods WITH KEY name = iv_action TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      rv_is_rap_bo_action = abap_on.
      RETURN.

    ELSE.

*     Get RAP BOs actions
      TRY.

          DATA(lo_rap_bhv_metadata_provider) = cl_rap_bhv_metadata_provider=>get_instance_for_entity( CONV #( iv_bus_obj ) ).

          DATA(lt_actions) = lo_rap_bhv_metadata_provider->get_actions( ).
          READ TABLE lt_actions WITH KEY name = iv_action TRANSPORTING NO FIELDS.
          IF sy-subrc = 0.
            rv_is_rap_bo_action = abap_on.
            RETURN.
          ENDIF.

          IF iv_bus_obj EQ 'R_CONDITIONCONTRACTTP' "was first reported for this BO
            OR iv_bus_obj EQ 'R_PRODUCTIONMODELTP'  "ERX only
            OR iv_bus_obj EQ 'R_BILLINGDOCUMENTTP'.
            DATA(lt_functions) = lo_rap_bhv_metadata_provider->get_functions( ).
            READ TABLE lt_functions WITH KEY name = iv_action TRANSPORTING NO FIELDS.
            IF sy-subrc = 0.
              rv_is_rap_bo_action = abap_on.
              RETURN.
            ENDIF.
          ENDIF.

        CATCH cx_rap_no_bhv_definition_found ##NO_HANDLER.
        CATCH cx_rap_bdef_empty.
          rv_is_rap_bo_action = abap_on. "The object could be inactive in the system where the test run is executed.

      ENDTRY.

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_rap_metadata~check_rap_bo_check_action.
    rv_result = abap_off.

    DATA(lv_is_rap_bo) = check_rap_bo( iv_bus_obj ).

    IF lv_is_rap_bo = abap_off.
      RETURN.

    ENDIF.

    IF iv_action EQ 'CHECK' OR
      iv_action EQ 'CHECK_IF_EXISTS'.
      rv_result = abap_on.
      RETURN.

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_rap_metadata~get_key_fields.
    DATA: lo_structdescr TYPE REF TO cl_abap_structdescr,
          lv_op          TYPE abp_behv_op.

    CASE iv_virtual.
      WHEN abap_off.
        lv_op = cl_abap_behv_ctrl=>d010behv_op-virtual-primarykey.

      WHEN abap_on.
        lv_op = cl_abap_behvdescr=>op_virtual_pkey.

    ENDCASE.

*   Identify the key fields
    DATA(lr_pkey)  = cl_abap_behvdescr=>create_data(
                           p_name      = iv_name
                           p_op        = lv_op
                           p_structure = abap_on
                        ).

    ASSIGN lr_pkey->* TO FIELD-SYMBOL(<fs_pkey>).

    lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_pkey> ).
    rt_components = recursive_get_components( lo_structdescr ).

  ENDMETHOD.


  METHOD if_ptf_rap_metadata~recursive_get_components.
    DATA: lo_structdesc  TYPE REF TO cl_abap_structdescr,
          lt_components  TYPE abap_component_tab,
          lt_icomponents TYPE abap_component_tab.

    FIELD-SYMBOLS: <fs_component> TYPE abap_componentdescr.

    lt_components = io_structdescr->get_components( ).

    LOOP AT lt_components ASSIGNING <fs_component>.
      IF <fs_component>-as_include = abap_on.
        lo_structdesc ?= <fs_component>-type.

        lt_icomponents = if_ptf_rap_metadata~recursive_get_components( lo_structdesc ).

        APPEND LINES OF lt_icomponents TO rt_components.

      ELSE.
        APPEND <fs_component> TO rt_components.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD if_ptf_rap_metadata~check_rap_bo_bdef_action.

    rv_is_rap_bo_action = abap_false.
    CHECK if_ptf_rap_metadata~check_rap_bo( iv_bus_obj ).

    cl_abap_behv_load=>get_load(
          EXPORTING
            entity                     = iv_bus_obj                 " Entity Name for ABAP Behavior
            check_syntax               = abap_true
          IMPORTING
            actions                    = DATA(actions)
        ).

    READ TABLE actions WITH KEY owner_entity = iv_bus_obj  name = iv_action INTO DATA(action).
    IF sy-subrc = 0.
      rv_is_rap_bo_action = abap_true.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
