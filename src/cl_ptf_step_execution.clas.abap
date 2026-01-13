CLASS cl_ptf_step_execution DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


    METHODS:
      constructor,

      get_current_step RETURNING VALUE(step) TYPE i,

      execute_ptf_step
        RETURNING VALUE(fluent_object) TYPE REF TO cl_ptf_step_execution,

      set_ptf_step
        IMPORTING
                  bus_obj              TYPE ptf_bo OPTIONAL
                  action               TYPE ptf_act OPTIONAL
                  variant              TYPE ptf_tdcv OPTIONAL
                  reference_step       TYPE cl_ptf_util=>gty_reference_tab OPTIONAL
                  test_data_container  TYPE etobj_name OPTIONAL
        RETURNING VALUE(fluent_object) TYPE REF TO cl_ptf_step_execution,

      get_ptf_execution_results
        RETURNING VALUE(ptf_variant) TYPE cl_ptf_util=>gt_ptf_step_tab.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: ptf_variant     TYPE cl_ptf_util=>gt_ptf_step_tab,
          step_to_execute TYPE cl_ptf_util=>gt_ptf_step,
          current_step    TYPE i.

    CONSTANTS: change        TYPE ptf_act VALUE 'CHANGE',
               check         TYPE ptf_act VALUE 'CHECK',
               create        TYPE ptf_act VALUE 'CREATE',
               delete        TYPE ptf_act VALUE 'DELETE',
               execute       TYPE ptf_act VALUE 'EXECUTE_ACTION',
               execute_check TYPE ptf_act VALUE 'EXECUTE_CHECK'.

ENDCLASS.



CLASS CL_PTF_STEP_EXECUTION IMPLEMENTATION.


  METHOD constructor.
    current_step = 0.
  ENDMETHOD.


  METHOD execute_ptf_step.
    DATA: error_in_config  TYPE abap_bool,
          temp_ptf_variant TYPE cl_ptf_util=>gt_ptf_step_tab,
          parameter        TYPE abap_parmbind,
          parameters       TYPE abap_parmbind_tab,
          bo               TYPE REF TO object,
          method_name      TYPE ptf_act,
          document_id      TYPE cl_ptf_util=>ty_vbeln_tab,
          execution_status TYPE abap_bool,
          check_status     TYPE abap_bool,
          class_name       TYPE string.

    current_step = current_step + 1.
    me->step_to_execute-step_number = current_step.

    SELECT SINGLE * FROM ptfbo INTO @DATA(ptfbo_config) WHERE ptf_bo = @me->step_to_execute-bus_obj.
    IF sy-subrc IS NOT INITIAL.
      error_in_config = abap_true.
      APPEND VALUE #( message = |BO { me->step_to_execute-bus_obj } not found.| ) TO me->step_to_execute-log.
    ENDIF.

    IF error_in_config EQ abap_true.
      APPEND me->step_to_execute TO ptf_variant.
      "Ensure correct order
      SORT ptf_variant BY step_number ASCENDING.
      RETURN.
    ENDIF.

    temp_ptf_variant = ptf_variant.
    APPEND me->step_to_execute TO temp_ptf_variant.

    DATA(run_manager) = NEW cl_ptf_run( it_ptf_steps = temp_ptf_variant ).

    "Create BO class instance
    IF ptfbo_config-bo_class IS INITIAL.
      class_name = |CL_PTF_BO_{ ptfbo_config-ptf_bo }|.
    ELSE.
      class_name = |{ ptfbo_config-bo_class }|.
    ENDIF.
    CLEAR: parameter,parameters.
    parameter-kind = cl_abap_objectdescr=>exporting.
    parameter-name = 'IV_RUN_ENVIRONMENT'.
    GET REFERENCE OF run_manager INTO parameter-value.
    INSERT parameter INTO TABLE parameters.
    TRY.
        CREATE OBJECT bo TYPE (class_name) PARAMETER-TABLE parameters.
      CATCH cx_root INTO DATA(exc).

        APPEND VALUE #( message = |Could not initialize class. | ) TO me->step_to_execute-log.
        APPEND me->step_to_execute TO ptf_variant.
        RETURN.
    ENDTRY.

    IF me->step_to_execute-action EQ create OR
      me->step_to_execute-action EQ change OR
      me->step_to_execute-action EQ delete OR
      me->step_to_execute-action EQ check.
      MOVE me->step_to_execute-action TO method_name.
    ELSE.
      IF me->step_to_execute-check_flag IS NOT INITIAL.
        MOVE 'EXECUTE_CHECK' TO method_name.
      ELSE.
        MOVE 'EXECUTE_ACTION' TO method_name.
      ENDIF.
    ENDIF.

    CLEAR document_id.
    CLEAR execution_status.
    CLEAR check_status.
    CLEAR parameters.

    CLEAR: parameter.
    parameter-kind = cl_abap_objectdescr=>exporting.
    parameter-name =  'IV_STEP_NUMBER'.
    GET REFERENCE OF current_step INTO parameter-value.
    INSERT parameter INTO TABLE parameters.

    CLEAR: parameter.
    parameter-kind = cl_abap_objectdescr=>importing.
    parameter-name =  'EV_DOCUMENT_ID'.
    GET REFERENCE OF document_id INTO parameter-value.
    INSERT parameter INTO TABLE parameters.

    CLEAR: parameter.
    parameter-kind = cl_abap_objectdescr=>importing.
    parameter-name =  'EV_EXECUTION_STATUS'.
    GET REFERENCE OF execution_status INTO parameter-value.
    INSERT parameter INTO TABLE parameters.

    CLEAR: parameter.
    parameter-kind = cl_abap_objectdescr=>importing.
    parameter-name =  'EV_CHECK_STATUS'.
    GET REFERENCE OF check_status INTO parameter-value.
    INSERT parameter INTO TABLE parameters.



    CALL METHOD bo->(method_name)
      PARAMETER-TABLE
      parameters.


    me->step_to_execute-log = run_manager->get_log( ).
    me->step_to_execute-document_id = document_id.
    me->step_to_execute-execution_status = execution_status.
    me->step_to_execute-check_status = check_status.

    APPEND me->step_to_execute TO ptf_variant.

    fluent_object = me.

  ENDMETHOD.


  METHOD get_current_step.
    step = me->current_step.
  ENDMETHOD.


  METHOD get_ptf_execution_results.
    ptf_variant = me->ptf_variant.
  ENDMETHOD.


  METHOD set_ptf_step.
    CLEAR me->step_to_execute.
    me->step_to_execute-bus_obj             = bus_obj.
    me->step_to_execute-action              = action.
    me->step_to_execute-variant             = variant.
    me->step_to_execute-reference_step      = reference_step.
    me->step_to_execute-test_data_container = test_data_container.
    fluent_object = me.
  ENDMETHOD.
ENDCLASS.
