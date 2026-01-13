CLASS cl_ptf_run DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !it_ptf_steps TYPE cl_ptf_util=>gt_ptf_step_tab .
    METHODS execute
      IMPORTING
        !iv_run_uuid        TYPE sysuuid_c26 OPTIONAL
        !ptf_test_landscape TYPE ptf_test_landscape OPTIONAL
      EXPORTING
        !ev_step_index      TYPE i
        !ev_log_status      TYPE sysubrc .
    METHODS append_log
      IMPORTING
        !iv_log_statement TYPE string .
    METHODS log_step_start
      IMPORTING
        !is_step_data TYPE cl_ptf_util=>gt_ptf_step .
    METHODS log_step_end
      IMPORTING
        !is_step_data TYPE cl_ptf_util=>gt_ptf_step .
    METHODS append_log_structure
      IMPORTING
        !is_log TYPE bapiret2 .
    METHODS get_log
      RETURNING
        VALUE(log) TYPE cl_ptf_util=>gt_ptf_return_tab .
    METHODS append_logs
      IMPORTING
        logs TYPE cl_ptf_util=>gt_ptf_return_tab .
    CLASS-METHODS set_not_running
      IMPORTING
        !iv_run_uuid TYPE sysuuid_c26 .
    METHODS get_all_steps
      RETURNING
        VALUE(step_data) TYPE cl_ptf_util=>gt_ptf_step_tab .
    METHODS get_keys_of_touch_doc_of_step
      IMPORTING
        !iv_step_number TYPE i
      RETURNING
        VALUE(ptf_keys) TYPE cl_ptf_util=>ty_vbeln_tab .
    METHODS get_result_key_data
      IMPORTING
        !it_step_number      TYPE cl_ptf_util=>gty_reference_tab
      RETURNING
        VALUE(rt_result_key) TYPE cl_ptf_util=>ty_result_key_data_tab .
    METHODS get_step_data
      IMPORTING
        !iv_step_number  TYPE i
      RETURNING
        VALUE(step_data) TYPE cl_ptf_util=>gt_ptf_step .
    METHODS set_step_data
      IMPORTING
        !iv_step_number TYPE i
        !step_data      TYPE cl_ptf_util=>gt_ptf_step .
    METHODS do_preperation
      IMPORTING
        !is_new_version     TYPE abap_bool
      CHANGING
        !step_number        TYPE i
        !document_id        TYPE cl_ptf_util=>ty_vbeln_tab
        !execution_status   TYPE abap_bool
        !check_status       TYPE abap_bool
        !is_step_data       TYPE cl_ptf_util=>gt_ptf_step OPTIONAL
        !it_step_data       TYPE cl_ptf_util=>gt_ptf_step_tab OPTIONAL
        !it_return          TYPE cl_ptf_util=>gt_ptf_return_tab OPTIONAL
      RETURNING
        VALUE(rt_parameter) TYPE abap_parmbind_tab .
*      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP optional
*      !IT_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP_TAB optional
*      !IT_RETURN type CL_PTF_UTIL=>GT_PTF_RETURN_TAB optional
    METHODS prepare_action_call
      EXPORTING
        !ev_method_name     TYPE ptf_act
      CHANGING
        !document_id        TYPE cl_ptf_util=>ty_vbeln_tab
        !execution_status   TYPE abap_bool
        !check_status       TYPE abap_bool
        !is_step_data       TYPE cl_ptf_util=>gt_ptf_step
      RETURNING
        VALUE(rt_parameter) TYPE abap_parmbind_tab .
    METHODS set_variant_name
      IMPORTING
        !iv_varname TYPE ptf_varname .
    METHODS get_variant_name
      RETURNING
        VALUE(rv_result) TYPE ptf_varname .
    METHODS execute_in_this_session
      IMPORTING
        !iv_run_uuid   TYPE sysuuid_c26 OPTIONAL
      CHANGING
        !gv_step_index TYPE i
        !gv_log_status TYPE sysubrc .
    METHODS get_key_structure_by_db_table
      IMPORTING
        !iv_tablename    TYPE tabname
      RETURNING
        VALUE(rr_result) TYPE REF TO data .
    METHODS execute_step
      IMPORTING
        iv_run_uuid__obsolete TYPE sysuuid_c26 OPTIONAL
        iv_step_index         TYPE i
      CHANGING
        cv_log_status         TYPE sysubrc .
    METHODS get_rfc_destination
      IMPORTING
        ptf_test_landscape TYPE ptf_test_landscape
        ptf_bo             TYPE ptf_bo
      RETURNING
        VALUE(rfc_dest)    TYPE rfc_dest.
  PROTECTED SECTION.

  PRIVATE SECTION.

    CONSTANTS gc_change TYPE ptf_act VALUE 'CHANGE' ##NO_TEXT.
    CONSTANTS gc_check TYPE ptf_act VALUE 'CHECK' ##NO_TEXT.
    CONSTANTS gc_create TYPE ptf_act VALUE 'CREATE' ##NO_TEXT.
    CONSTANTS gc_delete TYPE ptf_act VALUE 'DELETE' ##NO_TEXT.
    CONSTANTS gc_execute TYPE ptf_act VALUE 'EXECUTE_ACTION' ##NO_TEXT.
    CONSTANTS gc_execute_check TYPE ptf_act VALUE 'EXECUTE_CHECK' ##NO_TEXT.
    CONSTANTS gc_prefix_class_obsol TYPE ptf_act VALUE 'CL_PTF_BO_' ##NO_TEXT.
    CONSTANTS gc_prefix_method_obsol TYPE ptf_act VALUE 'IF_PTF_BO~' ##NO_TEXT.
    DATA mt_ptf_run_log TYPE cl_ptf_util=>gt_ptf_return_tab .
    DATA mt_ptf_step TYPE cl_ptf_util=>gt_ptf_step_tab .
    DATA mv_variant_name TYPE ptf_varname .

    METHODS get_key_components_for_db_tabl
      IMPORTING
        !iv_tablename    TYPE tabname
      RETURNING
        VALUE(rt_result) TYPE abap_component_tab .
    METHODS replace_not_allowed_chars
      IMPORTING
        !string       TYPE string
      RETURNING
        VALUE(result) TYPE string .
    METHODS write_exec_log
      IMPORTING
        !iv_run_uuid     TYPE sysuuid_c26
        !iv_log_status   TYPE sysubrc
        !iv_dump_occured TYPE abap_bool
        !iv_session_type TYPE ptf_session_type
        !iv_runtime      TYPE timestampl .
    METHODS assert_not_running
      IMPORTING
        !iv_run_uuid    TYPE sysuuid_c26
        !io_listener    TYPE REF TO if_aunit_listener "LCL_AUNIT_LISTENER
      RETURNING
        VALUE(rv_error) TYPE abap_bool .
    METHODS start_aunit_session
      IMPORTING
        !iv_testclass_name TYPE progname
      EXPORTING
        !eo_listener       TYPE REF TO if_aunit_listener .
ENDCLASS.



CLASS cl_ptf_run IMPLEMENTATION.


  METHOD append_log.
    DATA: ls_log     TYPE bapiret2.
    ls_log-message = iv_log_statement.
    APPEND ls_log  TO me->mt_ptf_run_log.
  ENDMETHOD.


  METHOD append_log_structure.

    DATA(ls_log) = is_log.

    IF ls_log-message IS INITIAL.
      IF ls_log-type EQ 'E' OR ls_log-type EQ 'I' OR ls_log-type EQ 'W' OR ls_log-type EQ 'S' AND
        ls_log-id IS NOT INITIAL
        AND ls_log-number IS NOT INITIAL.
        MESSAGE ID ls_log-id TYPE ls_log-type NUMBER ls_log-number WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO ls_log-message.
      ENDIF.
    ENDIF.

    APPEND ls_log  TO me->mt_ptf_run_log.


    "store this T100 message on step level

    CHECK ls_log-id IS NOT INITIAL AND ls_log-number IS NOT INITIAL.

    cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~add_actual_messages( VALUE #( ( CORRESPONDING #( ls_log ) ) )  ).

  ENDMETHOD.


  METHOD assert_not_running.

    "We expect ls_run_head-is_step_running to be abap_false - if not, there is a problem

    DATA lo_listener TYPE REF TO lcl_aunit_listener.
    lo_listener = CAST #( io_listener ).

    DATA(lo_mem) = NEW cl_ptf_abap_memory( ).
    DATA(ls_run_head) = lo_mem->get_run_head( iv_run_uuid ).

    IF ls_run_head-is_step_running EQ abap_true.

      "the AU step ended unplanned

      rv_error = abap_true.
      APPEND VALUE #( message = |!! Unplanned end of this AU step !!| ) TO me->mt_ptf_run_log.
      DATA lt_alert TYPE cl_ptf_wrapper=>tt_test_log.
      lt_alert = lo_listener->mt_failed.
      LOOP AT lt_alert INTO DATA(ls_alert).
        CONCATENATE ls_alert-clas '-' ls_alert-meth '.' ls_alert-prog "',' ls_alert-kind ',' ls_alert-severity
         INTO DATA(string).
        APPEND VALUE #( message = |!! Location: { me->replace_not_allowed_chars( string = string ) } !!| ) TO me->mt_ptf_run_log.
        APPEND VALUE #( message = |!! { me->replace_not_allowed_chars( string = ls_alert-msgtxt ) } !!| ) TO me->mt_ptf_run_log.
      ENDLOOP.
      DATA(lt_detail) = lo_listener->mt_fail_details.
      IF lt_detail IS NOT INITIAL.
        APPEND VALUE #( message = |!! Details:| ) TO me->mt_ptf_run_log.
        LOOP AT lt_detail INTO DATA(ls_detail).
          APPEND VALUE #( message = replace_not_allowed_chars( string = ls_detail ) ) TO me->mt_ptf_run_log.
        ENDLOOP.
      ENDIF.

    ELSE.
      ASSERT ls_run_head-is_step_running NE 'A'.
*      APPEND VALUE #( message = |!! Problem in status handling !!| ) TO me->mt_ptf_run_log.
*      EXIT.
    ENDIF.

  ENDMETHOD.


  METHOD constructor.
    me->mt_ptf_step = it_ptf_steps.
  ENDMETHOD.


  METHOD do_preperation.
    DATA: ls_parameter TYPE   abap_parmbind.

    IF is_new_version EQ abap_true.
      CLEAR: ls_parameter.
      ls_parameter-kind = cl_abap_objectdescr=>exporting.
      ls_parameter-name =  'IV_STEP_NUMBER'.
      GET REFERENCE OF step_number INTO ls_parameter-value.
      INSERT ls_parameter INTO TABLE rt_parameter.

      CLEAR: ls_parameter.
      ls_parameter-kind = cl_abap_objectdescr=>importing.
      ls_parameter-name =  'EV_DOCUMENT_ID'.
      GET REFERENCE OF document_id INTO ls_parameter-value.
      INSERT ls_parameter INTO TABLE rt_parameter.

      CLEAR: ls_parameter.
      ls_parameter-kind = cl_abap_objectdescr=>importing.
      ls_parameter-name =  'EV_EXECUTION_STATUS'.
      GET REFERENCE OF execution_status INTO ls_parameter-value.
      INSERT ls_parameter INTO TABLE rt_parameter.

      CLEAR: ls_parameter.
      ls_parameter-kind = cl_abap_objectdescr=>importing.
      ls_parameter-name =  'EV_CHECK_STATUS'.
      GET REFERENCE OF check_status INTO ls_parameter-value.
      INSERT ls_parameter INTO TABLE rt_parameter.
    ELSE.
      ASSERT 1 = 2.
*      ls_parameter-kind = cl_abap_objectdescr=>changing.
*      ls_parameter-name =  'CS_STEP_DATA'.
*      GET REFERENCE OF is_step_data INTO ls_parameter-value.
*      INSERT ls_parameter INTO TABLE rt_parameter.
*
*      ls_parameter-kind = cl_abap_objectdescr=>changing.
*      ls_parameter-name =  'CT_STEP_DATA'.
*      GET REFERENCE OF it_step_data INTO ls_parameter-value.
*      INSERT ls_parameter INTO TABLE rt_parameter.
*
*      ls_parameter-kind = cl_abap_objectdescr=>importing.
*      ls_parameter-name =  'ET_RETURN'.
*      GET REFERENCE OF it_return INTO ls_parameter-value.
*      INSERT ls_parameter INTO TABLE rt_parameter.
    ENDIF.

  ENDMETHOD.


  METHOD execute.

    DATA:
      document_id              TYPE cl_ptf_util=>ty_vbeln_tab,
      execution_status         TYPE abap_bool,
      check_status             TYPE abap_bool,
      lo_bo                    TYPE REF TO object,
      lv_class_name            TYPE string,
      lv_method_name           TYPE ptf_act,
      ls_parameter_constructor TYPE abap_parmbind,
      lt_parameter_constructor TYPE abap_parmbind_tab,
      lt_parameter             TYPE abap_parmbind_tab,
      lv_end_the_run           TYPE abap_bool,
      dump_occured             TYPE abap_bool,
      ls_run_head              TYPE cl_ptf_util=>ty_run_head,
      lo_listener              TYPE REF TO if_aunit_listener,
      lo_mem                   TYPE REF TO cl_ptf_abap_memory.

*  DATA forward_invoice     TYPE c.         " 'X' means forward invoice CREATE to RAP BO action
    DATA use_aunit           TYPE c.         "'0' - do not use AUnit, and stay in this session for the whole run      '1' - use AUnit, one AU session per step (this is also the default if there is no record)
    DATA use_overall_session TYPE abap_bool. "true: 'one AU session for the run'

    CONSTANTS lc_param_au          TYPE c LENGTH 20 VALUE 'USE_AUNIT'.
*  CONSTANTS lc_param_inv_forward TYPE c LENGTH 20 VALUE 'FORWARD_INVOICE'.
    CONSTANTS lc_tclass_step     TYPE progname VALUE 'TCL_PTF_STEP_IN_AU'.
    CONSTANTS lc_tclass_full_run TYPE progname VALUE 'TCL_PTF_FULL_RUN_IN_AU'.

    use_aunit = abap_true.
    SELECT SINGLE * FROM ptf_ctrl_prmtr INTO @DATA(ls_ctrl_au) WHERE parameter_name = @lc_param_au.
    IF sy-subrc IS INITIAL AND ls_ctrl_au-value EQ '0'.
      use_aunit = abap_false.
    ENDIF.
*  SELECT SINGLE * FROM ptf_ctrl_prmtr INTO @DATA(ls_ctrl_inv) WHERE parameter_name = @lc_param_inv_forward.
*  IF sy-subrc IS INITIAL AND ls_ctrl_inv-value EQ 'X'.
*    forward_invoice = abap_true.
*  ENDIF.

    FREE MEMORY ID 'CG__PTF_MOCK_TD'.
    FREE MEMORY ID 'CG__PTF_FT_TOG_MOCK'.
    FREE MEMORY ID 'CG__PTF_BP_SWITCH'.

    IF get_variant_name( ) IS NOT INITIAL.
      DATA lv_message TYPE bapi_msg.
      lv_message = 'PTF Script:'.
      lv_message+12 = get_variant_name( ).
      APPEND VALUE #( message = lv_message ) TO mt_ptf_run_log.
    ENDIF.


    "'one AU session for the run' is currently only applied if BO TaxAbroad or COMMIT for a RAP BO  occurs in the script (note that use_aunit is then ignored)
    READ TABLE mt_ptf_step WITH KEY bus_obj = 'TAX_ABROAD' TRANSPORTING NO FIELDS.
    IF sy-subrc IS INITIAL.
      use_overall_session = abap_true.
    ELSE.
      READ TABLE mt_ptf_step WITH KEY action = 'COMMIT' ASSIGNING FIELD-SYMBOL(<ls_commit_step>).
      IF sy-subrc IS INITIAL.
        IF NEW cl_ptf_rap_metadata( )->check_rap_bo( <ls_commit_step>-bus_obj ).
          use_overall_session = abap_true.
        ENDIF.
      ENDIF.
    ENDIF.

    IF use_aunit EQ abap_true OR use_overall_session EQ abap_true.
      "Log a warning if AUnits with our risk level are not allowed in the current client
      " Execution of unit tests allowed in this client?
      IF ( NOT cl_aunit_permission_control=>is_test_enabled_client( ) ).
        MESSAGE e200(sabp_unit) INTO lv_message.
        APPEND VALUE #( message = lv_message ) TO mt_ptf_run_log.
      ENDIF.
      " Check needed risk level - PTF AU classes have risk level Dangerous
      DATA(current_max_risk_level) = cl_aunit_permission_control=>get_max_risk_level( ).
      IF current_max_risk_level NE if_aunit_attribute_enums=>c_risk_level-critical AND
        current_max_risk_level NE if_aunit_attribute_enums=>c_risk_level-dangerous.
        MESSAGE e060(ptf) INTO lv_message.
        APPEND VALUE #( message = lv_message ) TO mt_ptf_run_log.
      ENDIF.
    ENDIF.


*****new mode 'one AU session for the run'
    IF use_overall_session EQ abap_true.

      EXPORT t_step_data  = me->mt_ptf_step
             run_uuid     = iv_run_uuid
        TO MEMORY ID 'CG__PTF_STEP_ALL'.


      lo_mem = NEW cl_ptf_abap_memory( ).
      ls_run_head = lo_mem->get_run_head( iv_run_uuid ).

      ls_run_head-is_step_running = abap_true. "more precise here: run is running
      ls_run_head-current_step_number = ev_step_index. "has value 0 when starting the run   "currently never updated for RunIn1Session

      lo_mem->update_run_head( ls_run_head ).


      "Start Aunit session that executes the full run
      start_aunit_session(
        EXPORTING
          iv_testclass_name = lc_tclass_full_run
        IMPORTING
          eo_listener = lo_listener ).

      "Run ended

      "open?:
      " -processing after all steps are executed

      IMPORT v_log_status = ev_log_status
             v_step_index = ev_step_index  "set correctly by TCL_PTF_FULL_RUN_IN_AU, always the last executed step     "1 is the first step - now increased to the current number right after the loop statement
             FROM MEMORY ID 'PTF_RUN_RESULT'.
      FREE MEMORY ID 'PTF_RUN_RESULT'.


      IMPORT t_step_data  = me->mt_ptf_step "mt_ptf_step is overwritten, not only the transient columns
        FROM MEMORY ID 'CG__PTF_STEP_ALL'.
      FREE MEMORY ID 'CG__PTF_STEP_ALL'.

      DATA lt_run_log TYPE cl_ptf_util=>gt_ptf_return_tab.
      IMPORT t_log         = lt_run_log
*           v_duration    = lv_step_duration
*           v_end_the_run = lv_end_the_run
        FROM MEMORY ID 'CG__PTF_STEP_RESULT'.
      APPEND LINES OF lt_run_log TO me->mt_ptf_run_log.
      FREE MEMORY ID 'CG__PTF_STEP_RESULT'.

*      APPEND LINES OF me->mt_ptf_run_log TO <ls_step_data>-log. "needed for odata?

      "Check whether AUnit ended normally
      DATA(lv_error) = me->assert_not_running( iv_run_uuid = iv_run_uuid io_listener = lo_listener ).  "writes also to log
      IF lv_error EQ abap_true.
        dump_occured = abap_true. "simplify? directly set dump_occured
        ev_log_status = 1. "failed
      ENDIF.

      "update run head - as it is read in write_exec_log (that has no imp. param. for this) to fill failed_step_number
      ls_run_head = lo_mem->get_run_head( iv_run_uuid ).
      ls_run_head-is_step_running = abap_false. "if dumped, then still 'X'
      ls_run_head-current_step_number = ev_step_index. "imported above
      lo_mem->update_run_head( ls_run_head ).

      me->write_exec_log(
        EXPORTING
          iv_run_uuid     = iv_run_uuid
          iv_log_status   = ev_log_status
          iv_dump_occured = dump_occured
          iv_session_type = 'R'
          iv_runtime      = 0 "lv_duration_all_steps   "not set
      ).

      RETURN.

    ENDIF.  "use_overall_session



*****Old modes: loop over steps (with or without Aunit)   MOVE to a new method EXECUTE_IN_STEP_SESSIONs
    LOOP AT me->mt_ptf_step ASSIGNING FIELD-SYMBOL(<ls_step_data>).

      CLEAR: lv_class_name, lv_method_name, lt_parameter.
      "clear step fields - needed in non-AU mode
*    cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~set_tdc_error( space ).
*    cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~set_substituted_tdc_name( space ).
      cl_ptf_step_attr=>delete_singleton( ).

      IF <ls_step_data>-bus_obj IS INITIAL
        AND <ls_step_data>-action IS INITIAL
        AND <ls_step_data>-variant IS INITIAL.
        EXIT.   "end the loop
      ENDIF.

      CHECK <ls_step_data>-action IS NOT INITIAL AND <ls_step_data>-bus_obj IS NOT INITIAL.   "end loop pass

      me->log_step_start( <ls_step_data> ).

      IF <ls_step_data>-bus_obj EQ 'PTF_RUN'.
        IF <ls_step_data>-action EQ 'EXIT'.
          APPEND VALUE #( message = |End of PTF run due to EXIT.| ) TO me->mt_ptf_run_log.
          <ls_step_data>-execution_status = abap_true.
          EXIT.
        ENDIF.
      ENDIF.



      IF use_aunit IS INITIAL.
******************************************************************************************
        "Mode 'NO AUnit'. does also not open a new session      "might become obsolete and replaced with EXECUTE_IN_THIS_SESSION

        APPEND VALUE #( message = |-PTF RUN WITHOUT AUnit-| ) TO me->mt_ptf_run_log.   "ToDo: currently logged per step, not perfect

        DATA(lo_ptf_rap_metadata) = NEW cl_ptf_rap_metadata( ).
        DATA(lv_is_rap_bo) = lo_ptf_rap_metadata->check_rap_bo( <ls_step_data>-bus_obj ).

        SELECT SINGLE * FROM ptfbo INTO @DATA(ls_ptf_bo_db) WHERE ptf_bo = @<ls_step_data>-bus_obj.
        ASSERT sy-subrc IS INITIAL OR lv_is_rap_bo EQ abap_on.

        "Create BO class instance
        IF ls_ptf_bo_db-bo_class IS INITIAL.
          IF lv_is_rap_bo = abap_off.
            lv_class_name = |CL_PTF_BO_{ ls_ptf_bo_db-ptf_bo }|.

          ELSE.
            lv_class_name = |CL_PTF_BO_RAP_GENERIC|.

          ENDIF.
        ELSE.
          lv_class_name = |{ ls_ptf_bo_db-bo_class }|.
        ENDIF.
        CLEAR: ls_parameter_constructor,lt_parameter_constructor.
        ls_parameter_constructor-kind = cl_abap_objectdescr=>exporting.
        ls_parameter_constructor-name = 'IV_RUN_ENVIRONMENT'.
        GET REFERENCE OF me INTO ls_parameter_constructor-value.
        INSERT ls_parameter_constructor INTO TABLE lt_parameter_constructor.
        TRY.
            CREATE OBJECT lo_bo TYPE (lv_class_name) PARAMETER-TABLE lt_parameter_constructor.
          CATCH cx_sy_create_object_error INTO DATA(lx).
            APPEND VALUE #( message = |Couldn't find the class { lv_class_name } for BO { ls_ptf_bo_db-ptf_bo }| ) TO me->mt_ptf_run_log.
            <ls_step_data>-execution_status = abap_false.
            <ls_step_data>-check_status = abap_false.
            ev_step_index = ev_step_index + 1.
            RETURN.
        ENDTRY.
        CHECK lo_bo IS BOUND.  "end loop pass

        CLEAR document_id.
        CLEAR execution_status.
        CLEAR check_status.

        me->prepare_action_call(
          IMPORTING
            ev_method_name   = lv_method_name
          CHANGING
            document_id      = document_id
            execution_status = execution_status
            check_status     = check_status
            is_step_data     = <ls_step_data>
          RECEIVING
            rt_parameter     = lt_parameter
        ).

        TRY.

            CALL METHOD lo_bo->(lv_method_name)
              PARAMETER-TABLE
              lt_parameter.

          CATCH cx_sy_dyn_call_illegal_method INTO DATA(lx_methodcall).
            APPEND VALUE #( message = |Couldn't find the method { lv_method_name } in { lv_class_name } for BO { ls_ptf_bo_db-ptf_bo }| ) TO me->mt_ptf_run_log.
            <ls_step_data>-execution_status = abap_false.
            <ls_step_data>-check_status = abap_false.
            ev_step_index = ev_step_index + 1.
            RETURN.
        ENDTRY.

        "maybe put these two messages at the beginning of the step's log?
        IF cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~has_tdc_error( ) IS NOT INITIAL.
          APPEND VALUE #( message = |TDC does not exist.| ) TO me->mt_ptf_run_log.
          "cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~set_stop_run_after_step( abap_true ).
          lv_end_the_run = abap_true.
        ENDIF.

        IF cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~get_substituted_tdc_name( ) IS NOT INITIAL.
          APPEND VALUE #( message = |!! Z-TDC: { cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~get_substituted_tdc_name( ) } found, used this one !! | ) TO me->mt_ptf_run_log.
        ENDIF.

        IF <ls_step_data>-check_flag EQ abap_true.   "now using <ls_step_data>-check_flag which at runtime also considers RAP BOs
          <ls_step_data>-check_status = check_status.
          <ls_step_data>-execution_status = execution_status.
        ELSE.
          <ls_step_data>-execution_status = execution_status.
        ENDIF.
        <ls_step_data>-document_id = document_id.
        "lv_end_the_run = zcl_ptf_error=>get_stop_run_after_step( ).

        DATA lv_one_created_doc TYPE ptfkey. "cl_ptf_util=>ty_vbeln.
        CLEAR lv_one_created_doc.
        LOOP AT document_id INTO lv_one_created_doc.
        ENDLOOP.
        EXPORT created_doc = lv_one_created_doc TO MEMORY ID 'PTF_LAST_CREATED_DOC'.


      ELSE.
******************************************************************************************
        "Mode 'AUnit session per step'

        EXPORT s_step_data  = <ls_step_data>
               run_uuid     = iv_run_uuid
               ptf_test_landcape = ptf_test_landscape
               TO MEMORY ID 'CG__PTF_STEP'.

        EXPORT t_step_data  = me->mt_ptf_step
               TO MEMORY ID 'CG__PTF_STEP_ALL'.

        lo_mem = NEW cl_ptf_abap_memory( ).
        ls_run_head = lo_mem->get_run_head( iv_run_uuid ).

        ls_run_head-is_step_running = abap_true.
        ls_run_head-current_step_number = ev_step_index. "0 is the first step HERE, as we increase in this mode only later in the loop pass

        lo_mem->update_run_head( ls_run_head ).


        "Start AUnit session, for this step
        start_aunit_session(
          EXPORTING
            iv_testclass_name = lc_tclass_step
          IMPORTING
            eo_listener = lo_listener ).


        "Ensure that step in AUnit ended normally
        DATA(lv_error_in_step) = me->assert_not_running( iv_run_uuid = iv_run_uuid io_listener = lo_listener ).
        IF lv_error_in_step EQ abap_true.
          <ls_step_data>-execution_status = abap_false.
          <ls_step_data>-check_status = abap_false.
          dump_occured = abap_true.
        ENDIF.


        DATA:
          ls_step_data_upd      TYPE cl_ptf_util=>gt_ptf_step, "structure
          gt_log_delta          TYPE cl_ptf_util=>gt_ptf_return_tab,
          lv_step_duration      TYPE timestampl,
          lv_duration_all_steps TYPE timestampl.
        CLEAR: ls_step_data_upd, gt_log_delta, lv_step_duration.

        IMPORT s_step_data  = ls_step_data_upd
               FROM MEMORY ID 'CG__PTF_STEP'.

        IF sy-subrc IS INITIAL.
          "persisted fields
*      ASSERT ls_step_data_upd-bus_obj EQ <ls_step_data>-bus_obj.
*      ASSERT ls_step_data_upd-action  EQ <ls_step_data>-action.
*      ls_step_data_upd-check_flag
          ASSERT ls_step_data_upd-step_number EQ <ls_step_data>-step_number.
*      ls_step_data_upd-variant
*      ls_step_data_upd-test_data_container
          ls_step_data_upd-reference_step = <ls_step_data>-reference_step.  "keep the refSteps from before, heal INVOICE CREATE forward workaround (which deletes itab reference_step)

          "transient fields - update me->mt_ptf_step with step results
          <ls_step_data>-document_id      = ls_step_data_upd-document_id.
          <ls_step_data>-execution_status = ls_step_data_upd-execution_status.
          <ls_step_data>-check_status     = ls_step_data_upd-check_status.
          <ls_step_data>-act_messages     = ls_step_data_upd-act_messages.
          <ls_step_data>-is_pid           = ls_step_data_upd-is_pid.
          <ls_step_data>-is_manual        = ls_step_data_upd-is_manual.
          <ls_step_data>-data_object_json = ls_step_data_upd-data_object_json.
          <ls_step_data>-log              = ls_step_data_upd-log.  "never filled
        ENDIF.


        IMPORT t_log         = gt_log_delta
               v_duration    = lv_step_duration
               v_end_the_run = lv_end_the_run
               FROM MEMORY ID 'CG__PTF_STEP_RESULT'.

        IF sy-subrc IS INITIAL.
          APPEND LINES OF gt_log_delta TO me->mt_ptf_run_log.
*        APPEND LINES OF me->mt_ptf_run_log TO <ls_step_data>-log.
          APPEND LINES OF gt_log_delta TO <ls_step_data>-log.
          ADD lv_step_duration TO lv_duration_all_steps.
        ENDIF.

        FREE MEMORY ID 'CG__PTF_STEP'.
        FREE MEMORY ID 'CG__PTF_STEP_RESULT'.

      ENDIF.  "Aunit Mode / other mode



      "Loop-pass end handling for both modes

***
      IF lines( <ls_step_data>-document_id ) GT 1.
        DATA(lb_multiple) = abap_true.
      ENDIF.
***
      "Handle failed check
      IF <ls_step_data>-check_flag EQ abap_true  AND  <ls_step_data>-check_status EQ abap_false.
        ev_log_status = 1.
        APPEND VALUE #( message = '************************************' ) TO me->mt_ptf_run_log.
        APPEND VALUE #( message = |Check failed, PTF run is stopped.| ) TO me->mt_ptf_run_log.
        "toDO: export failed <ls_step_data>-step_number for SUT class
        EXIT. "Exit loop, end run
      ENDIF.

      ev_step_index = ev_step_index + 1.

      IF dump_occured EQ abap_true OR lv_end_the_run EQ abap_true.
        ev_log_status = 1.
        APPEND VALUE #( message = '************************************' ) TO me->mt_ptf_run_log.
        APPEND VALUE #( message = |Serious problem occured, PTF run is stopped.| ) TO me->mt_ptf_run_log.
        EXIT.
      ENDIF.

    ENDLOOP."LOOP AT gt_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data>).




    FREE MEMORY ID 'CG__PTF_MOCK_TD'.
    FREE MEMORY ID 'CG__PTF_FT_TOG_MOCK'.
    FREE MEMORY ID 'CG__PTF_BP_SWITCH'.

    APPEND VALUE #( message = '************************************' ) TO me->mt_ptf_run_log.
    IF lv_duration_all_steps IS NOT INITIAL.
      APPEND VALUE #( message = |Sum of step durations:  { lv_duration_all_steps } .| ) TO me->mt_ptf_run_log.
    ENDIF.

    "Was the last step a failed normal action?
    IF <ls_step_data>-check_flag EQ abap_false  AND  <ls_step_data>-execution_status EQ abap_false.
      ev_log_status = 1.  "considered in this method since May 2023
    ENDIF.


    me->write_exec_log(
      EXPORTING
        iv_run_uuid     = iv_run_uuid
        iv_log_status   = ev_log_status
        iv_dump_occured = dump_occured
        iv_session_type = 'S'
        iv_runtime      = lv_duration_all_steps
    ).

    IF lb_multiple EQ abap_true.
      SELECT SINGLE * FROM ptf_temp_multres WHERE varname = @ls_run_head-variant INTO @DATA(dummy).
      IF sy-subrc IS NOT INITIAL.
        DATA ls_multres TYPE ptf_temp_multres.
        ls_multres-varname = ls_run_head-variant.
        ls_multres-mandt = sy-mandt.
        INSERT ptf_temp_multres FROM ls_multres.
        IF sy-dbcnt EQ '876'. ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD execute_in_this_session.

*    "OPEN: -fill current step in run head at least when dumped - needs EXPORT (and import somewhere). currently only run_header stores this, which is outside of this session
*
*    DATA:
*      lo_bo                    TYPE REF TO object,
*      lv_method_name           TYPE ptf_act,
*      document_id              TYPE cl_ptf_util=>ty_vbeln_tab,
*      execution_status         TYPE abap_bool,
*      check_status             TYPE abap_bool,
*      ls_parameter_constructor TYPE abap_parmbind,
*      lt_parameter_constructor TYPE abap_parmbind_tab,
*      lt_parameter             TYPE abap_parmbind_tab,
*      lv_class_name            TYPE string,
*      lt_run_log               TYPE cl_ptf_util=>gt_ptf_return_tab,
*      lv_end_the_run           TYPE abap_bool,
*      dump_occured             TYPE abap_bool,
*      lv_timestamp_start       TYPE timestampl,
*      lv_timestamp_end         TYPE timestampl.
*
*    APPEND VALUE #( message = |-PTF RUN in a SINGLE session-| ) TO me->mt_ptf_run_log.
*
*    GET TIME STAMP FIELD lv_timestamp_start.
*
*
*    LOOP AT me->mt_ptf_step ASSIGNING FIELD-SYMBOL(<ls_step_data>).
****TEMP RITA
*      IF <ls_step_data>-bus_obj EQ 'OUTB_DELIVERY' AND <ls_step_data>-action EQ 'PICK_ALL_ITEMS'.
*        DATA count_pick_calls TYPE i.
*        ADD 1 TO count_pick_calls.
*      ENDIF.
****
*
*      CLEAR: lv_class_name, lv_method_name, lt_parameter.
*      "clear step fields
*      CLEAR document_id.
*      CLEAR execution_status.
*      CLEAR check_status.
**      cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~set_tdc_error( space ).
**      cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~set_substituted_tdc_name( space ).
*      cl_ptf_step_attr=>delete_singleton( ).
*
*      IF <ls_step_data>-bus_obj IS INITIAL
*        AND <ls_step_data>-action IS INITIAL
*        AND <ls_step_data>-variant IS INITIAL.
*        EXIT.   "end the loop
*      ENDIF.
*
*      CHECK <ls_step_data>-action IS NOT INITIAL AND <ls_step_data>-bus_obj IS NOT INITIAL.   "end loop pass
*
*      me->log_step_start( <ls_step_data> ).
*
*      IF <ls_step_data>-bus_obj EQ 'PTF_RUN'.
*        IF <ls_step_data>-action EQ 'EXIT'.
*          APPEND VALUE #( message = |End of PTF run due to EXIT.| ) TO me->mt_ptf_run_log.
*          <ls_step_data>-execution_status = abap_true.
*          EXIT.
*        ENDIF.
*      ENDIF.
*
*      "Workaround: Before each action, export log, needed if the action dumps to preserve action name
*      lt_run_log = me->get_log( ).
*      EXPORT t_log         = lt_run_log
**           v_duration    = lv_run_time
**           v_end_the_run = lv_end_the_run
*      TO MEMORY ID 'CG__PTF_STEP_RESULT'.
*
**      IF use_aunit IS INITIAL.
*******************************************************************************************
*      "execute run in current session (currently, this will be an already started AU session. current normal session might also come.)            BASED ON: "Mode 'NO AUnit'. does also not open a new session"
*
****
**adding db mocking here
*      DATA:
*        lv_tdc      TYPE etobj_name,
*        lv_tdcv     TYPE etvar_id,
*        lv_tdc_old  TYPE etobj_name,
*        lv_tdcv_old TYPE etvar_id.
*
*      IF <ls_step_data>-bus_obj EQ cl_ptf_util=>gc_bo_ptfrun AND <ls_step_data>-action EQ cl_ptf_util=>gc_action_mock_db. "'START_DATA_MOCKING'.
*
*        IF <ls_step_data>-variant CS ','.
*          SPLIT <ls_step_data>-variant AT ',' INTO lv_tdc lv_tdcv.
*        ELSE.
*          lv_tdc  = <ls_step_data>-test_data_container.
*          lv_tdcv = <ls_step_data>-variant.
*        ENDIF.
*
*        IF lv_tdc IS INITIAL OR lv_tdcv IS INITIAL.
*          me->append_log( iv_log_statement = |Wrong configuration. Please fill TDC and TDCV.| ).
*          execution_status = abap_false.
*          RETURN.
*        ENDIF.
*
**        IMPORT v_mock_tdc   = lv_tdc_old
**               v_mock_tdcv  = lv_tdcv_old
**               "tdc_done     = lv_tdc_done
**               FROM MEMORY ID 'CG__PTF_MOCK_TD'.
*        IF lv_tdc_old IS NOT INITIAL AND lv_tdcv_old IS NOT INITIAL."ToDO: fill them!
*          IF lv_tdc NE lv_tdc_old OR lv_tdcv NE lv_tdcv_old.
*            "mocking from another tdc/tdcv is already active. gets lost.
**            me->append_log( iv_log_statement = |Old mocking is ended by this new mock action.| ).
*          ENDIF.
*        ENDIF.
*
*        "ok, we will use the given TDC+TDCV
*        "use lv_tdc
*        "use lv_tdcv
*
**        me->append_log( iv_log_statement = |DB mocking is now active.| ).
**
**          tcl_ptf_db_mock_util=>mv_tdc  = lv_tdc.  "PROBLEM: The reference to a test class (identified by FOR TESTING) is only possible in test classes.
**          tcl_ptf_db_mock_util=>mv_tdcv = lv_tdcv.
**          tcl_ptf_db_mock_util=>startmock( ).
***          EXPORT
***           v_mock_tdc   = lv_tdc
***           v_mock_tdcv  = lv_tdcv
***           tdc_done     = abap_true
***           TO MEMORY ID 'CG__PTF_MOCK_TD'.
**        DATA(lt_log_mocking) = tcl_ptf_db_mock_util=>get_log( ).
**        LOOP AT lt_log_mocking REFERENCE INTO DATA(lr_log).
**          lo_ptf_run->append_log_structure( is_log = lr_log->* ).
**        ENDLOOP.
**
**
**        execution_status = abap_true.
*
*      ENDIF.
**end logic of mocking >>>
****
*      SELECT SINGLE * FROM ptfbo INTO @DATA(ls_ptf_bo_db) WHERE ptf_bo = @<ls_step_data>-bus_obj.
*      IF sy-subrc IS NOT INITIAL.
*        DATA(lo_ptf_rap_metadata) = NEW cl_ptf_rap_metadata( ).
*        DATA(lv_is_rap_bo) = lo_ptf_rap_metadata->check_rap_bo( <ls_step_data>-bus_obj ).
*        ASSERT lv_is_rap_bo EQ abap_on.
*      ENDIF.
*
*      "Create BO class instance
*      IF ls_ptf_bo_db-bo_class IS INITIAL.
*        IF lv_is_rap_bo = abap_off.
*          lv_class_name = |CL_PTF_BO_{ ls_ptf_bo_db-ptf_bo }|.
*
*        ELSE.
*          lv_class_name = |CL_PTF_BO_RAP_GENERIC|.
*
*        ENDIF.
*
*      ELSE.
*        lv_class_name = |{ ls_ptf_bo_db-bo_class }|.
*      ENDIF.
*      CLEAR: ls_parameter_constructor,lt_parameter_constructor.
*      ls_parameter_constructor-kind = cl_abap_objectdescr=>exporting.
*      ls_parameter_constructor-name = 'IV_RUN_ENVIRONMENT'.
*      GET REFERENCE OF me INTO ls_parameter_constructor-value.
*      INSERT ls_parameter_constructor INTO TABLE lt_parameter_constructor.
*      TRY.
*          CREATE OBJECT lo_bo TYPE (lv_class_name) PARAMETER-TABLE lt_parameter_constructor.
*        CATCH cx_sy_create_object_error INTO DATA(lx).
*          APPEND VALUE #( message = |Couldn't find the class { lv_class_name } for BO { ls_ptf_bo_db-ptf_bo }| ) TO me->mt_ptf_run_log.
*          <ls_step_data>-execution_status = abap_false.
*          <ls_step_data>-check_status = abap_false.
*          gv_step_index = gv_step_index + 1.
*          RETURN.
*      ENDTRY.
*      CHECK lo_bo IS BOUND.  "end loop pass
*
*      me->prepare_action_call(
*        IMPORTING
*          ev_method_name   = lv_method_name
*        CHANGING
*          document_id      = document_id
*          execution_status = execution_status
*          check_status     = check_status
*          is_step_data     = <ls_step_data>
*        RECEIVING
*          rt_parameter     = lt_parameter
*      ).
*
*****Temp: RITA problem for RunIn1Session
*      IF count_pick_calls GT 1.
*        APPEND VALUE #( message = |WORKAROUND: Refreshing CL_API_LE_DLV_UPD_COLL_FACTORY.| ) TO me->mt_ptf_run_log.
*        cl_api_le_dlv_upd_coll_factory=>changeset_end( ).
*        count_pick_calls = 1.
*      ENDIF.
*****
*      TRY.
*
*          CALL METHOD lo_bo->(lv_method_name)
*            PARAMETER-TABLE
*            lt_parameter.
*
*        CATCH cx_sy_dyn_call_illegal_method INTO DATA(lx_methodcall).
*          APPEND VALUE #( message = |Couldn't find the method { lv_method_name } in { lv_class_name } for BO { ls_ptf_bo_db-ptf_bo }| ) TO me->mt_ptf_run_log.
*          <ls_step_data>-execution_status = abap_false.
*          <ls_step_data>-check_status = abap_false.
*          gv_step_index = gv_step_index + 1.
*          RETURN.
*      ENDTRY.
*
*      "maybe put these two messages at the beginning of the step's log?
*      IF cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~has_tdc_error( ) IS NOT INITIAL.
*        APPEND VALUE #( message = |TDC does not exist.| ) TO me->mt_ptf_run_log.
*        "cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~set_stop_run_after_step( abap_true ).
*        lv_end_the_run = abap_true.
*      ENDIF.
*
*      IF cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~get_substituted_tdc_name( ) IS NOT INITIAL.
*        APPEND VALUE #( message = |!! Z-TDC: { cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~get_substituted_tdc_name( ) } found, used this one !! | ) TO me->mt_ptf_run_log.
*      ENDIF.
*
*
**      IF use_aunit IS INITIAL.   "only in mode 'No AUnit'.
*
**      SELECT SINGLE * FROM ptfboa INTO @DATA(lv_ptf_boa_db) WHERE ptf_bo = @<ls_step_data>-bus_obj AND ptf_act = @<ls_step_data>-action.
**      IF sy-subrc IS NOT INITIAL.
**        "If not in PTFBOA, it has to be a RAP action, or there is a problem
**        ASSERT cl_ptf_rap_metadata=>check_rap_bo_action( EXPORTING iv_bus_obj = <ls_step_data>-bus_obj iv_action = <ls_step_data>-action ).
**      ENDIF.
**      ASSERT sy-subrc IS INITIAL.
*      IF <ls_step_data>-check_flag EQ abap_true.   "IF lv_ptf_boa_db-ptf_check_action EQ abap_true.     "WHY NOT EVALUATE ls_step_data-CHECK_FLAG ?? this at runtime even considers RAP BOs      ...done now
*        <ls_step_data>-check_status = check_status.
*        <ls_step_data>-execution_status = execution_status.
*      ELSE.
*        <ls_step_data>-execution_status = execution_status.
*      ENDIF.
*      <ls_step_data>-document_id = document_id.
*      "lv_end_the_run = zcl_ptf_error=>get_stop_run_after_step( ).
*
*      DATA lv_one_created_doc TYPE ptfkey.
*      CLEAR lv_one_created_doc.
*      LOOP AT document_id INTO lv_one_created_doc.
*      ENDLOOP.
*      EXPORT created_doc = lv_one_created_doc TO MEMORY ID 'PTF_LAST_CREATED_DOC'.
**      ENDIF.
*
*      "After each step, export log and step data itab, needed if the next step dumps
*
**      lt_run_log = me->get_log( ).          log is currently exported at the beginning of each step, and after the loop. sufficient, even if a step dumps
**      EXPORT t_log         = lt_run_log
***           v_duration    = lv_run_time
***           v_end_the_run = lv_end_the_run
**      TO MEMORY ID 'CG__PTF_STEP_RESULT'.
*
*      DATA(steps) = me->get_all_steps( ).
*      EXPORT t_step_data  = steps
*        TO MEMORY ID 'CG__PTF_STEP_ALL'.
*
*
*      "Loop end handling for both modes
*
*      "Handle failed check
*      IF <ls_step_data>-check_flag EQ abap_true  AND  <ls_step_data>-check_status EQ abap_false.
*        gv_log_status = 1.
*        APPEND VALUE #( message = '************************************' ) TO me->mt_ptf_run_log.
*        APPEND VALUE #( message = |Check failed, PTF run is stopped.| ) TO me->mt_ptf_run_log.
*        "toDO: export failed <ls_step_data>-step_number for SUT class
*        EXIT. "Exit loop, end run
*      ENDIF.
*
*      "Increase index
*      gv_step_index = gv_step_index + 1.
*
*      IF dump_occured EQ abap_true OR lv_end_the_run EQ abap_true.
*        gv_log_status = 1. "20210702: Flags for dump or end_the_run now set run to failed
*        EXIT.
*      ENDIF.
*
*    ENDLOOP."LOOP AT gt_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data>).
*
*
*
*    GET TIME STAMP FIELD lv_timestamp_end.
*    DATA(lv_duration_all_steps) = cl_abap_tstmp=>subtract( EXPORTING tstmp1 = lv_timestamp_end tstmp2 = lv_timestamp_start ).
*    APPEND VALUE #( message = '************************************' ) TO me->mt_ptf_run_log.
*    IF lv_duration_all_steps IS NOT INITIAL.
*      APPEND VALUE #( message = |Sum of step durations:  { lv_duration_all_steps } .| ) TO me->mt_ptf_run_log.
*    ENDIF.
*
*    "moved here from one level higher (EXECUTE), mostly as here lv_runtime is available  "also done in the loop, per step. here needed for the log part after endloop
*    EXPORT t_log         = me->mt_ptf_run_log
*           v_duration    = lv_duration_all_steps
**           v_end_the_run = lv_end_the_run
*    TO MEMORY ID 'CG__PTF_STEP_RESULT'.
*
*    "Was the last step a failed normal action?
*    IF <ls_step_data>-check_flag EQ abap_false  AND  <ls_step_data>-execution_status EQ abap_false.
*      CHECK 1 = 1.     "not considered in the past, ok?
*      "gv_log_status = 1.
*    ENDIF.
*
*
*    COMMIT WORK AND WAIT.


  ENDMETHOD.


  METHOD execute_step.

    READ TABLE mt_ptf_step ASSIGNING FIELD-SYMBOL(<ls_step_data>) INDEX iv_step_index.
    ASSERT sy-subrc IS INITIAL.

* STD STEP LOGIC - has to be in CL (not TCL) if reuse by non AU mode is needed

    "Clear attributes
*    cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~set_tdc_error( space ).
*    cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~set_substituted_tdc_name( space ).
    cl_ptf_step_attr=>delete_singleton( ).

    DATA:
      document_id      TYPE cl_ptf_util=>ty_vbeln_tab,
      execution_status TYPE abap_bool,
      check_status     TYPE abap_bool.
    DATA:
      lo_bo                    TYPE REF TO object,
      lv_method_name           TYPE ptf_act,
      ls_parameter_constructor TYPE abap_parmbind,
      lt_parameter_constructor TYPE abap_parmbind_tab,
      lt_parameter             TYPE abap_parmbind_tab,
      lv_class_name            TYPE string.

    IF <ls_step_data>-is_manual EQ abap_true.
      "then do nothing
      append_log( iv_log_statement = |Step execution skipped, as ResultID was set to manual in UI.| ).
    ELSE.

      SELECT SINGLE * FROM ptfbo INTO @DATA(ls_ptf_bo_db) WHERE ptf_bo = @<ls_step_data>-bus_obj.
      IF sy-subrc IS NOT INITIAL.
        DATA(lo_ptf_rap_metadata) = NEW cl_ptf_rap_metadata( ).
        DATA(lv_is_rap_bo) = lo_ptf_rap_metadata->check_rap_bo( <ls_step_data>-bus_obj ).
        ASSERT lv_is_rap_bo EQ abap_on.
      ENDIF.

      "Create BO class instance
      IF ls_ptf_bo_db-bo_class IS INITIAL.
        IF lv_is_rap_bo = abap_off.
          lv_class_name = |CL_PTF_BO_{ ls_ptf_bo_db-ptf_bo }|.

        ELSE.
          lv_class_name = |CL_PTF_BO_RAP_GENERIC|.

        ENDIF.

      ELSE.
        lv_class_name = |{ ls_ptf_bo_db-bo_class }|.
      ENDIF.
      CLEAR: ls_parameter_constructor,lt_parameter_constructor.
      ls_parameter_constructor-kind = cl_abap_objectdescr=>exporting.
      ls_parameter_constructor-name = 'IV_RUN_ENVIRONMENT'.
      GET REFERENCE OF me INTO ls_parameter_constructor-value.
      INSERT ls_parameter_constructor INTO TABLE lt_parameter_constructor.
      TRY.
          CREATE OBJECT lo_bo TYPE (lv_class_name) PARAMETER-TABLE lt_parameter_constructor.
        CATCH cx_sy_create_object_error INTO DATA(lx).
          append_log( |Couldn't find the class { lv_class_name } for BO { ls_ptf_bo_db-ptf_bo }| ).
          <ls_step_data>-execution_status = abap_false.
          <ls_step_data>-check_status = abap_false.
          cv_log_status = 1.
          RETURN.
      ENDTRY.
      ASSERT lo_bo IS BOUND.

      DATA(lv_log_pos_before_call) = lines( me->mt_ptf_run_log ) + 1.

      me->prepare_action_call(
        IMPORTING
          ev_method_name   = lv_method_name
        CHANGING
          document_id      = document_id
          execution_status = execution_status
          check_status     = check_status
          is_step_data     = <ls_step_data>
        RECEIVING
          rt_parameter     = lt_parameter
      ).

      TRY.

          DATA(info_for_debugging) = <ls_step_data>-step_number.

          CALL METHOD lo_bo->(lv_method_name)
            PARAMETER-TABLE
            lt_parameter.

        CATCH cx_sy_dyn_call_illegal_method INTO DATA(lx_methodcall).
          append_log( |Couldn't find the method { lv_method_name } in { lv_class_name } for BO { ls_ptf_bo_db-ptf_bo }| ).
          <ls_step_data>-execution_status = abap_false.
          <ls_step_data>-check_status = abap_false.
          cv_log_status = 1.
          RETURN.
      ENDTRY.

      IF cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~has_tdc_error( ) IS NOT INITIAL.
        APPEND VALUE #( message = |!! TDC does not exist!! PTF run is stopped after this step.| ) TO me->mt_ptf_run_log.
        cv_log_status = 1.
        "we keep the status values coming from the method
        RETURN.
      ENDIF.

      IF cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~get_substituted_tdc_name( ) IS NOT INITIAL.
        INSERT VALUE #( message = |!! Z-TDC: { cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~get_substituted_tdc_name( ) } found, used this one !! | )
          INTO me->mt_ptf_run_log INDEX lv_log_pos_before_call.
      ENDIF.

      "Step data: Take over components that are not in action signature
      DATA(act_messages) = cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~get_actual_messages( ).
      IF act_messages IS NOT INITIAL.
        MOVE-CORRESPONDING act_messages TO <ls_step_data>-act_messages.
      ENDIF.
      "Components DATA_OBJECT_JSON and IS_PID are currently set with SET_STEP_DATA and only by CL_PTF_BO_RAP_GENERIC-OPERATION . Works.

      "Step data: Take over 2 status values, from action signature parameters
      IF <ls_step_data>-check_flag EQ abap_true.
        <ls_step_data>-check_status = check_status.
        <ls_step_data>-execution_status = execution_status.
      ELSE.
        <ls_step_data>-execution_status = execution_status.
      ENDIF.

    ENDIF. "IF is_manual is initial

    "Step data: Take over itab document_id from action signature parameters
    IF <ls_step_data>-is_manual EQ abap_false.
      "normal takeover of document IDs
      <ls_step_data>-document_id = document_id.
    ELSE.
      "manual entry feature is active for this step: do not overwrite ls_step_data-DOCUMENT_ID, keep the manually entered docID(s)
      <ls_step_data>-execution_status = abap_true.
      IF <ls_step_data>-check_flag EQ abap_true.
        <ls_step_data>-check_status = abap_true.  "check status successful is required, else the run would stop
      ENDIF.
      ASSERT document_id IS INITIAL.
    ENDIF.

    log_step_end( <ls_step_data> ).

    DATA lv_one_created_doc TYPE ptfkey.
    CLEAR lv_one_created_doc.
    LOOP AT <ls_step_data>-document_id INTO lv_one_created_doc.
    ENDLOOP.
    EXPORT created_doc = lv_one_created_doc TO MEMORY ID 'PTF_LAST_CREATED_DOC'.

    "After each step, export log and step data itab, needed if the next step dumps

*      lt_run_log = me->get_log( ).          log is currently exported at the beginning of each step, and after the loop. sufficient, even if a step dumps
*      EXPORT t_log         = lt_run_log
**           v_duration    = lv_run_time
**           v_end_the_run = lv_end_the_run
*      TO MEMORY ID 'CG__PTF_STEP_RESULT'.

    DATA(steps) = me->get_all_steps( ).
    EXPORT t_step_data  = steps
      TO MEMORY ID 'CG__PTF_STEP_ALL'.



    "Loop end handling

    "Handle failed check
    IF <ls_step_data>-check_flag EQ abap_true  AND  <ls_step_data>-check_status EQ abap_false.
      cv_log_status = 1.
      append_log( '************************************' ).
      append_log( |Check failed, PTF run is stopped.| ).
      "toDO: export failed <ls_step_data>-step_number for SUT class  not needed: EXECUTE_PTF_RUN_V3__LOOP_PART always exports the current stepNo in v_step_index. no matter if run failed, was successful, or even dumped
      RETURN.
    ENDIF.

*    "Increase index                "we now do this at the beginning of the loop, once. much better.
*    cv_step_index = cv_step_index + 1.

  ENDMETHOD.


  METHOD get_all_steps.
    step_data = me->mt_ptf_step.
  ENDMETHOD.


  METHOD get_keys_of_touch_doc_of_step.
    READ TABLE me->mt_ptf_step INDEX iv_step_number ASSIGNING FIELD-SYMBOL(<ls_step_data>).
    IF <ls_step_data> IS ASSIGNED.
      ptf_keys = <ls_step_data>-document_id.
    ENDIF.
  ENDMETHOD.


  METHOD get_key_components_for_db_tabl.

    DATA:
      lt_fieldinfo TYPE extdfiest,
      ls_fieldinfo TYPE LINE OF extdfiest,
      ls_component TYPE abap_componentdescr.

    CALL FUNCTION 'DD_INT_TABLINFO_GET'   "or use CL_ABAP_TABLEDESCR
      EXPORTING
        typename       = iv_tablename
      TABLES
        extdfies_tab   = lt_fieldinfo
      EXCEPTIONS
        not_found      = 1
        internal_error = 2
        OTHERS         = 3.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    LOOP AT lt_fieldinfo INTO ls_fieldinfo WHERE keyflag = 'X'.
      CHECK ls_fieldinfo-fieldname NE 'MANDT'.
      CHECK ls_fieldinfo-fieldname NE 'CLIENT'.
      CLEAR ls_component.
      ls_component-name  = ls_fieldinfo-fieldname.
      ls_component-type ?= cl_abap_typedescr=>describe_by_name( ls_fieldinfo-rollname ).  "DTEL
      INSERT ls_component INTO TABLE rt_result.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_key_structure_by_db_table.

    DATA:
      lt_fieldinfo  TYPE extdfiest,
      ls_fieldinfo  TYPE LINE OF extdfiest,
      ls_component  TYPE abap_componentdescr,
      lt_component  TYPE abap_component_tab,
      lo_strucdescr TYPE REF TO cl_abap_structdescr. "Referenz auf Datentyp der Struktur

    CALL FUNCTION 'DD_INT_TABLINFO_GET'   "or use CL_ABAP_TABLEDESCR
      EXPORTING
        typename       = iv_tablename
      TABLES
        extdfies_tab   = lt_fieldinfo
      EXCEPTIONS
        not_found      = 1
        internal_error = 2
        OTHERS         = 3.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    LOOP AT lt_fieldinfo INTO ls_fieldinfo WHERE keyflag = 'X'.
      CHECK ls_fieldinfo-fieldname NE 'MANDT'.
      CHECK ls_fieldinfo-fieldname NE 'CLIENT'.
      CLEAR ls_component.
      ls_component-name  = ls_fieldinfo-fieldname.
      ls_component-type ?= cl_abap_typedescr=>describe_by_name( ls_fieldinfo-rollname ).  "DTEL
      INSERT ls_component INTO TABLE lt_component.
    ENDLOOP.

    CHECK lt_component IS NOT INITIAL.

    "create structure description
    lo_strucdescr = cl_abap_structdescr=>create( lt_component ).

    "create structure
    CREATE DATA rr_result TYPE HANDLE lo_strucdescr.

*    FIELD-SYMBOLS <fs_struct> TYPE any.
*    ASSIGN rr_result->* TO <fs_struct>.

  ENDMETHOD.


  METHOD get_log.
    log = me->mt_ptf_run_log.
  ENDMETHOD.

  METHOD append_logs.
    APPEND LINES OF logs TO me->mt_ptf_run_log.
  ENDMETHOD.

  METHOD get_result_key_data.

* returns one record for each document ID of each reference step
* line type:
*    BEGIN OF ty_result_key_data,
*        step_number          TYPE i,
*        bus_obj              TYPE ptf_bo,   "action name could be of interest
*        sbo_bo_type          TYPE sbo_bo_type,
*        document_id_char70   TYPE ty_vbeln,  cl_ptf_util=>
*        document_id_key_type TYPE REF TO data,
*      END OF ty_result_key_data .
    "Add also alternative keys?

    DATA ls_result_key  TYPE cl_ptf_util=>ty_result_key_data.
    DATA lv_table       TYPE tabname.
    DATA lb_rap_bo      TYPE abap_bool.
    DATA lo_structdescr TYPE REF TO cl_abap_structdescr.
    DATA lt_component   TYPE cl_abap_structdescr=>component_table.
    DATA lr_key         TYPE REF TO data.
    DATA lv_step_number TYPE cl_ptf_util=>gty_ref_step.
    DATA lt_step_number TYPE STANDARD TABLE OF cl_ptf_util=>gty_ref_step WITH EMPTY KEY WITH UNIQUE HASHED KEY k2_unique COMPONENTS table_line.

    "keep given order but remove duplicates
    LOOP AT it_step_number INTO lv_step_number.
      READ TABLE lt_step_number
        TRANSPORTING NO FIELDS
        WITH TABLE KEY k2_unique COMPONENTS table_line = lv_step_number.
      CHECK sy-subrc IS NOT INITIAL.
      CHECK lv_step_number NE 0.  "filter out rare initial values that have no meaning and would dump
      APPEND lv_step_number TO lt_step_number.
    ENDLOOP.

    LOOP AT lt_step_number INTO lv_step_number.
      CLEAR lv_table.

      READ TABLE me->mt_ptf_step INDEX lv_step_number ASSIGNING FIELD-SYMBOL(<ls_step_data>).
      ASSERT sy-subrc IS INITIAL.

      DATA(lo_ptf_rap_metadata) = NEW cl_ptf_rap_metadata( ).
      IF lo_ptf_rap_metadata->check_rap_bo( <ls_step_data>-bus_obj ).
        lb_rap_bo = abap_true.
        SELECT SINGLE bo_type FROM sbo_i_bodef WHERE object_type_category = 'BDEF' AND object_name = @<ls_step_data>-bus_obj INTO @ls_result_key-sbo_bo_type. "get SAP Object Type of RAP BO
      ENDIF.

      ls_result_key-step_number = <ls_step_data>-step_number.
      ls_result_key-bus_obj     = <ls_step_data>-bus_obj.


      IF lb_rap_bo EQ abap_false.
        SELECT SINGLE * FROM ptfbo WHERE ptf_bo = @<ls_step_data>-bus_obj INTO @DATA(ls_ptfbo).
        IF sy-subrc IS INITIAL.
          ls_result_key-sbo_bo_type = ls_ptfbo-sbo_bo_type. "SAP Object Type from PTFBO
          lv_table                  = ls_ptfbo-root_table.  "ToDo: Maybe add a warning here if record has empty ptfbo-root_table ? or would this be too much,as most BOs have single key field and then typed component document_id_key_type not really needed?
        ELSE.
          "problem, non-RAP-BO without PTFBO record. ToDo: when early checks are implemented, add a Dump here
        ENDIF.
        IF lv_table IS INITIAL.
          "Temporary hardcoded table names, in the future we will read the root table name from PTFBO, for non RAP BOs.
          IF <ls_step_data>-bus_obj EQ 'INVOICE'." OR <ls_step_data>-bus_obj EQ 'EBDR' OR <ls_step_data>-bus_obj EQ 'PREBILLING_DOC'.
            lv_table = 'VBRK'.
*          ELSEIF <ls_step_data>-bus_obj EQ 'OR'.
*            lv_table = 'VBAK'.
          ELSEIF <ls_step_data>-bus_obj EQ 'GOODS_RECEIPT'.
            lv_table = 'MKPF'.
          ENDIF.
        ENDIF.

      ENDIF.

      "Per document id
      LOOP AT <ls_step_data>-document_id ASSIGNING FIELD-SYMBOL(<doc_id>).
        CLEAR ls_result_key-document_id_key_type.
        CHECK <doc_id>-vbeln IS NOT INITIAL.

        "fill component DOCUMENT_ID_CHAR70 of ls_result_key
        ls_result_key-document_id_char70 = <doc_id>-vbeln.

        "fill component DOCUMENT_ID_KEY_TYPE of ls_result_key

        "create a data object for each ID
        IF lv_table IS NOT INITIAL.
          "PTF BO
          lt_component = me->get_key_components_for_db_tabl( lv_table ).
        ELSEIF lb_rap_bo EQ abap_true.
          "RAP BO
          lt_component = lo_ptf_rap_metadata->get_key_fields( <ls_step_data>-bus_obj ).
        ENDIF.
        "common logic
        IF lt_component IS NOT INITIAL. "without key components, document_id_key_type will not be filled

          lo_structdescr = cl_abap_structdescr=>create( lt_component ).
          CREATE DATA lr_key TYPE HANDLE lo_structdescr.
          IF lines( lt_component ) EQ 1.  "CL_PTF_BO_RAP_GENERIC adds delimiter '|' between field values        "or always split at '|', if there is only one result, just do the move
            MOVE <doc_id>-vbeln TO lr_key->*.
          ELSE.
            SPLIT <doc_id>-vbeln
             AT cl_ptf_util=>gc_key_field_delimiter
             INTO TABLE DATA(lt_value).
            IF lines( lt_value ) LE lines( lt_component ).
              LOOP AT lt_value INTO DATA(lv_value).
                ASSIGN COMPONENT sy-tabix OF STRUCTURE lr_key->* TO FIELD-SYMBOL(<component>).
                <component> = lv_value.
                UNASSIGN <component>.
              ENDLOOP.
            ENDIF.
          ENDIF.
          ls_result_key-document_id_key_type = lr_key.

          "omit duplicate keys (same BO and docID), ignoring step no.   "BO/OR/R_SalesOrderTP will not be seen as the same BO -> better use SAP object type if filled "even this does not cover all cases, e.g. action pass_id
          READ TABLE rt_result_key TRANSPORTING NO FIELDS WITH KEY
            bus_obj            = ls_result_key-bus_obj
            document_id_char70 = ls_result_key-document_id_char70.
          CHECK sy-subrc IS NOT INITIAL.

        ENDIF.
        APPEND ls_result_key TO rt_result_key.
      ENDLOOP.


    ENDLOOP.

  ENDMETHOD.


  METHOD get_step_data.
    READ TABLE me->mt_ptf_step INDEX iv_step_number INTO step_data.
  ENDMETHOD.


  METHOD get_variant_name.
    rv_result = mv_variant_name.
  ENDMETHOD.


  METHOD log_step_end.

    "Log a status
    IF is_step_data-check_flag EQ abap_true.
      IF is_step_data-check_status EQ abap_true.
        append_log( 'Check status: OK.' ).
      ELSE.
        append_log( 'Check status: FAILED.' ).
      ENDIF.
    ELSE.
      IF is_step_data-execution_status EQ abap_true.
        append_log( 'Execution status: True.' ).
      ELSE.
        append_log( 'Execution status: False.' ).
      ENDIF.
    ENDIF.
    "Log the ID(s)
    IF is_step_data-document_id IS INITIAL. "itab
      append_log( 'ResultIDs: No ResultID returned.' ).
    ELSEIF lines( is_step_data-document_id ) EQ 1.
      append_log( |ResultID: { is_step_data-document_id[ 1 ]-vbeln }| ).
    ELSE.
      append_log( 'ResultIDs:' ).
      LOOP AT is_step_data-document_id REFERENCE INTO DATA(lr_id).
        append_log( |'{ CONV string( lr_id->*-vbeln ) }'| ).
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD log_step_start.

    DATA lv_step TYPE string.
    DATA lv_message1 TYPE bapi_msg.
    DATA lv_message2 TYPE bapi_msg.

    lv_step = is_step_data-step_number.
    CONCATENATE `Step ` lv_step ':' INTO DATA(lv_step_id).

    DATA(lv_tdc_variant_displ) = is_step_data-variant.
    IF lv_tdc_variant_displ IS INITIAL.
      lv_tdc_variant_displ = '-'.
    ENDIF.

    DATA lv_ref_displ TYPE string.
    DATA(itab) = is_step_data-reference_step.
    LOOP AT itab REFERENCE INTO DATA(lr_step).
      IF sy-tabix EQ 1.
        lv_ref_displ = lv_ref_displ && lr_step->*.
      ELSE.
        lv_ref_displ = lv_ref_displ && ',' && lr_step->*.
      ENDIF.
    ENDLOOP.

    APPEND VALUE #( message = '************************************' ) TO me->mt_ptf_run_log.

    lv_message1 = |BO: { space }{ is_step_data-bus_obj } , Action: { is_step_data-action } , Variant: { lv_tdc_variant_displ } , Ref: { lv_ref_displ }|.
    APPEND VALUE #( id = lv_step_id
                    message = lv_message1 )
*                    message = |BO: { space }{ is_step_data-bus_obj } , Action: { is_step_data-action } , Variant: { lv_tdc_variant_displ }| )
                    TO me->mt_ptf_run_log.
    IF is_step_data-test_data_container IS NOT INITIAL.
      lv_message2 = |TDC: { is_step_data-test_data_container }|.
      IF lv_message1+96(4) NE '    '.
        lv_message2 = lv_message2 && | Variant: { lv_tdc_variant_displ }|.
      ENDIF.
      APPEND VALUE #( message = lv_message2 ) TO me->mt_ptf_run_log.
    ENDIF.

    IF is_step_data-json_file IS NOT INITIAL.
      DATA(lv_len) = strlen( is_step_data-json_file ).
      APPEND VALUE #( message = `JSON provided, length ` && lv_len && `.` ) TO me->mt_ptf_run_log.
    ENDIF.

  ENDMETHOD.


  METHOD prepare_action_call.

    "Find method name

    IF is_step_data-action EQ gc_create OR
      is_step_data-action EQ gc_change OR
      is_step_data-action EQ gc_delete OR
      is_step_data-action EQ gc_check.
      MOVE is_step_data-action TO ev_method_name.
    ELSE.
      IF is_step_data-check_flag IS NOT INITIAL.
        MOVE 'EXECUTE_CHECK' TO ev_method_name.
      ELSE.
        MOVE 'EXECUTE_ACTION' TO ev_method_name.
      ENDIF.
    ENDIF.

*   Add aditional check if RAP BO
    DATA(lo_ptf_rap_metadata) = NEW cl_ptf_rap_metadata( ).
    DATA(lv_is_rap_bo) = lo_ptf_rap_metadata->check_rap_bo( is_step_data-bus_obj ).
    IF lv_is_rap_bo = abap_on.
      CASE is_step_data-action.
        WHEN 'CHECK_IF_EXISTS'.
          MOVE 'EXECUTE_CHECK' TO ev_method_name.

        WHEN 'ENTITY_ACTION'.
          MOVE 'ENTITY_ACTION' TO ev_method_name.

        WHEN 'RETRIEVE'.
          MOVE 'RETRIEVE' TO ev_method_name.

        WHEN 'RETRIEVE_ALL'.
          MOVE 'RETRIEVE_ALL' TO ev_method_name.

        WHEN 'COMMIT'.
          MOVE 'COMMIT' TO ev_method_name.

      ENDCASE.

    ENDIF.

    "Build itab with parameter references

    DATA ls_parameter TYPE   abap_parmbind.

    CLEAR ls_parameter.
    ls_parameter-kind = cl_abap_objectdescr=>exporting.
    ls_parameter-name =  'IV_STEP_NUMBER'.
*    GET REFERENCE OF step_number INTO ls_parameter-value.
    GET REFERENCE OF is_step_data-step_number INTO ls_parameter-value.
    INSERT ls_parameter INTO TABLE rt_parameter.

    CLEAR ls_parameter.
    ls_parameter-kind = cl_abap_objectdescr=>importing.
    ls_parameter-name =  'EV_DOCUMENT_ID'.
    GET REFERENCE OF document_id INTO ls_parameter-value.
    INSERT ls_parameter INTO TABLE rt_parameter.

    CLEAR ls_parameter.
    ls_parameter-kind = cl_abap_objectdescr=>importing.
    ls_parameter-name =  'EV_EXECUTION_STATUS'.
    GET REFERENCE OF execution_status INTO ls_parameter-value.
    INSERT ls_parameter INTO TABLE rt_parameter.

    CLEAR ls_parameter.
    ls_parameter-kind = cl_abap_objectdescr=>importing.
    ls_parameter-name =  'EV_CHECK_STATUS'.
    GET REFERENCE OF check_status INTO ls_parameter-value.
    INSERT ls_parameter INTO TABLE rt_parameter.

  ENDMETHOD.


  METHOD replace_not_allowed_chars.
    "First solution: Just delete them
    "If that causes problems --> escape them https://stackoverflow.com/questions/730133/invalid-characters-in-xml
    result = string.
    REPLACE ALL OCCURRENCES OF '<' IN result WITH ''.
    REPLACE ALL OCCURRENCES OF '>' IN result WITH ''.
    REPLACE ALL OCCURRENCES OF '&' IN result WITH ''.
    REPLACE ALL OCCURRENCES OF '"' IN result WITH ''.
    REPLACE ALL OCCURRENCES OF |'| IN result WITH ''.
  ENDMETHOD.


  METHOD set_not_running.

    "ABAP memory: Mark run as not running (expects step to be running before)                 "toDo: better move this to another class, maybe create cl_ptf_run_head
    DATA lr_run_head TYPE REF TO cl_ptf_util=>ty_run_head.
    DATA lt_run_head TYPE cl_ptf_util=>ty_gt_run_head.

    IMPORT t_run_head = lt_run_head
      FROM MEMORY ID 'PTF_RUNS'.
    READ TABLE lt_run_head WITH TABLE KEY run_uuid = iv_run_uuid REFERENCE INTO lr_run_head.
    ASSERT sy-subrc IS INITIAL.
    IF lr_run_head->is_step_running EQ 'X'.
      "Standard
      CLEAR lr_run_head->is_step_running.
    ELSE.
      lr_run_head->is_step_running = 'A'.
    ENDIF.
    EXPORT t_run_head = lt_run_head TO MEMORY ID 'PTF_RUNS'.

  ENDMETHOD.


  METHOD set_step_data.
    MODIFY me->mt_ptf_step FROM step_data INDEX iv_step_number.

  ENDMETHOD.


  METHOD set_variant_name.
    mv_variant_name = iv_varname.
  ENDMETHOD.


  METHOD start_aunit_session.

    "Create and start a new AUnit session for a given global test class

    DATA lo_task TYPE REF TO if_aunit_task.

    CLEAR eo_listener.

    ASSERT iv_testclass_name IS NOT INITIAL.

    eo_listener = NEW lcl_aunit_listener( ib_treat_tolerabe_as_failed = abap_false ).
    lo_task = NEW cl_aunit_factory( )->create_task( listener = eo_listener ).
    lo_task->add_class_pool( iv_testclass_name ).
    lo_task->run( ).

    CHECK 1 = 1.

  ENDMETHOD.


  METHOD write_exec_log.

    DATA(lo_mem) = NEW cl_ptf_abap_memory( ). "instanz besser als member an ptf_run?
    DATA(ls_run_head) = lo_mem->get_run_head( iv_run_uuid ).

    DATA ls_log TYPE ptf_exec_log.
    ls_log = VALUE #(
     start_date = ls_run_head-start_date
     start_time = ls_run_head-start_time
     run_result = iv_log_status
     userid     = sy-uname
     is_batch   = ls_run_head-is_batch  "former: sy-batch
     dump_occured = iv_dump_occured
     session_type = iv_session_type
     ).

    IF iv_dump_occured IS NOT INITIAL.
      ls_log-failed_step_number = ls_run_head-current_step_number.
    ENDIF.

    IF ls_run_head-variant IS NOT INITIAL.
      ls_log-ptf_script = ls_run_head-variant.
    ENDIF.

    ls_log-runtime = iv_runtime.    "time stamp long , 100 ns using a packed number with length 11 and seven decimal places, format "yyyymmddhhmmss.sssssss"
    "CONVERT TIME STAMP xxxx TIME ZONE 'UTC' INTO DATE ls_log-start_date TIME ls_log-start_time.

*NUMBER_OF_STEPS
*DUMP_NAME
*FAILED_STEP_NUMBER
*FAILED_BO
*FAILED_BOA

    IF ls_log-ptf_script IS INITIAL.
      ls_log-ptf_script = 'SCRIPT_UNKNOWN'.
    ENDIF.

    CHECK ls_log-start_date IS NOT INITIAL.
    CHECK ls_log-start_time IS NOT INITIAL.

    INSERT ptf_exec_log FROM ls_log.

    "DELETE old log records
    DATA lv_date_limit TYPE dats.
    lv_date_limit = sy-datum - 100.
    DELETE FROM ptf_exec_log WHERE start_date < lv_date_limit.
    CHECK sy-dbcnt EQ sy-dbcnt.

  ENDMETHOD.

  METHOD get_rfc_destination.

    SELECT
    FROM
      ptf_bo_dest
    FIELDS ptf_bo, ptf_landscape, user_name,
      CASE
        WHEN user_name EQ @sy-uname THEN 1
        ELSE 0
      END +
      CASE
        WHEN ptf_bo EQ @ptf_bo THEN 1
        ELSE 0
      END
      AS hits,
    rfc_dest
    WHERE ( ptf_bo = @ptf_bo OR ptf_bo IS INITIAL ) AND ( user_name = @sy-uname OR user_name IS INITIAL ) AND ptf_landscape = @ptf_test_landscape
    INTO TABLE @DATA(rfc_dests).

    SORT rfc_dests DESCENDING BY hits ptf_bo user_name.
    READ TABLE rfc_dests INDEX 1 INTO DATA(rfc_dest_result).
    rfc_dest = rfc_dest_result-rfc_dest.


  ENDMETHOD.

ENDCLASS.
