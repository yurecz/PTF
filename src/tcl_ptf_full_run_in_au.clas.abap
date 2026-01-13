class TCL_PTF_FULL_RUN_IN_AU definition
  public
  create public
  for testing
  duration long
  risk level dangerous .

public section.

  class-data ENVIRONMENT type ref to IF_OSQL_TEST_ENVIRONMENT .

  class-methods CLASS_CONSTRUCTOR .
  PROTECTED SECTION.
private section.

  class-methods NOTE_STEP_DATA_ISSUE__INTERNAL
    importing
      !IV_RUN_UUID type SYSUUID_C26
      !IV_STEP_NO type I .
  methods EXECUTE_PTF_RUN
  for testing .
  methods SETUP .
  methods TEARDOWN .
  class-methods CLASS_SETUP .
  class-methods CLASS_TEARDOWN .
  methods EXECUTE_PTF_RUN_V2__IN_1_METH .
  methods EXECUTE_PTF_RUN_V3__LOOP_PART
  for testing .
ENDCLASS.



CLASS TCL_PTF_FULL_RUN_IN_AU IMPLEMENTATION.


  METHOD class_constructor.
  ENDMETHOD.


  METHOD class_setup.
  ENDMETHOD.


  METHOD class_teardown.
    IF environment IS BOUND.
*      environment->destroy( ).
    ENDIF.
  ENDMETHOD.


  METHOD execute_ptf_run.

    RETURN." !!!!  NOT USED ANYMORE

*    DATA:
*      lt_step_data  TYPE cl_ptf_util=>gt_ptf_step_tab,
*      lv_step_index TYPE i,
*      lv_log_status TYPE sysubrc,
*      lv_run_uuid   TYPE sysuuid_c26,
*      lo_ptf_run    TYPE REF TO cl_ptf_run.
*
*    IMPORT t_step_data  = lt_step_data
*           run_uuid     = lv_run_uuid
*           FROM MEMORY ID 'CG__PTF_STEP_ALL'.
*    FREE MEMORY ID 'CG__PTF_STEP_ALL'.
*
*    IF lt_step_data IS INITIAL. " Central AU run, not triggered by CL_PTF_RUN
*      RETURN.
*    ENDIF.
*
*    lv_step_index = 0.   "1 is the first step, increase is done in the loop
*    lv_log_status = 0.
*
*    lo_ptf_run = NEW cl_ptf_run( it_ptf_steps   = lt_step_data ).
*
*    "Execute the run in the current AU session
*    lo_ptf_run->execute_in_this_session(
*      EXPORTING
*        iv_run_uuid   = lv_run_uuid
*      CHANGING
*        gv_step_index = lv_step_index
*        gv_log_status = lv_log_status
*    ).
*
*    EXPORT v_log_status = lv_log_status
*           v_step_index = lv_step_index
*           TO MEMORY ID 'PTF_RUN_RESULT'.
*
*    "run ended without dump - update ABAP memory
*    cl_ptf_run=>set_not_running( lv_run_uuid ).

  ENDMETHOD.


  METHOD EXECUTE_PTF_RUN_V2__IN_1_METH. "method was FOR TESTING, removed when commented out

    RETURN. " !!

*    DATA:
*      lt_step_data  TYPE cl_ptf_util=>gt_ptf_step_tab,
*      lv_step_index TYPE i,
*      lv_log_status TYPE sysubrc,
*      lv_run_uuid   TYPE sysuuid_c26,
*      lo_ptf_run    TYPE REF TO cl_ptf_run.
*
*    IMPORT t_step_data  = lt_step_data
*           run_uuid     = lv_run_uuid
*           FROM MEMORY ID 'CG__PTF_STEP_ALL'.
*    FREE MEMORY ID 'CG__PTF_STEP_ALL'.
*
*    IF lt_step_data IS INITIAL. " Central AU run, not triggered by CL_PTF_RUN
*      RETURN.
*    ENDIF.
*
*    lv_step_index = 0.   "0 is the first step
*    lv_log_status = 0.
*
*    lo_ptf_run = NEW cl_ptf_run( it_ptf_steps   = lt_step_data ).
*
**    "Execute the run in the current AU session
**    lo_ptf_run->execute_in_this_session(
**      EXPORTING
**        iv_run_uuid   = lv_run_uuid
**      CHANGING
**        gv_step_index = lv_step_index
**        gv_log_status = lv_log_status
**    ).
**  METHOD execute_in_this_session.
*
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
**      dump_occured             TYPE abap_bool,
*      lv_timestamp_start       TYPE timestampl,
*      lv_timestamp_end         TYPE timestampl.
*
*    lo_ptf_run->append_log( |-PTF RUN in a SINGLE session-| ).
*
*    GET TIME STAMP FIELD lv_timestamp_start.
*
*
*    LOOP AT
*      "lo_ptf_run->mt_ptf_step
*      lt_step_data
*      ASSIGNING FIELD-SYMBOL(<ls_step_data>).
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
*      cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~set_tdc_error( space ).
*      cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~set_substituted_tdc_name( space ).
*
*      IF <ls_step_data>-bus_obj IS INITIAL
*        AND <ls_step_data>-action IS INITIAL
*        AND <ls_step_data>-variant IS INITIAL.
*        EXIT.   "end the loop
*      ENDIF.
*
*      CHECK <ls_step_data>-action IS NOT INITIAL AND <ls_step_data>-bus_obj IS NOT INITIAL.   "end loop pass
*
*      lo_ptf_run->log_step_start( <ls_step_data> ).
*
*      IF <ls_step_data>-bus_obj EQ 'PTF_RUN'.
*        IF <ls_step_data>-action EQ 'EXIT'.
*          lo_ptf_run->append_log( |End of PTF run due to EXIT.| ).
*          <ls_step_data>-execution_status = abap_true.
*          EXIT.
*        ENDIF.
*      ENDIF.
*
*      "Workaround: Before each action, export log, needed if the action dumps to preserve action name
*      lt_run_log = lo_ptf_run->get_log( ).
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
*          lo_ptf_run->append_log( |Wrong configuration. Please fill TDC and TDCV.| ).
*          execution_status = abap_false.
*          RETURN.  "insufficient
*        ENDIF.
*
**        IMPORT v_mock_tdc   = lv_tdc_old
**               v_mock_tdcv  = lv_tdcv_old
**               "tdc_done     = lv_tdc_done
**               FROM MEMORY ID 'CG__PTF_MOCK_TD'.
*        IF lv_tdc_old IS NOT INITIAL AND lv_tdcv_old IS NOT INITIAL.
*          "mocking from another tdc/tdcv is already active. gets lost.
*          lo_ptf_run->append_log( iv_log_statement = |As this tests runs in one session, DB mocking can be done only once. Stopping now.| ).
*          RETURN.   "insufficient           "open: but I could allow different content for already mocked tables
*        ENDIF.
*
*        "ok, we will use the given TDC+TDCV
*        "use lv_tdc
*        "use lv_tdcv
*
*        lo_ptf_run->append_log( |DB mocking is now active.| ).
*
*        tcl_ptf_db_mock_util=>mv_tdc  = lv_tdc.  "PROBLEM: The reference to a test class (identified by FOR TESTING) is only possible in test classes.
*        tcl_ptf_db_mock_util=>mv_tdcv = lv_tdcv.
*        tcl_ptf_db_mock_util=>startmock( ).
**          EXPORT
**           v_mock_tdc   = lv_tdc
**           v_mock_tdcv  = lv_tdcv
**           tdc_done     = abap_true
**           TO MEMORY ID 'CG__PTF_MOCK_TD'.
*        lv_tdc_old  = lv_tdc. "in one session, the local variables are enough
*        lv_tdcv_old = lv_tdcv.
*        DATA(lt_log_mocking) = tcl_ptf_db_mock_util=>get_log( ).
*        LOOP AT lt_log_mocking REFERENCE INTO DATA(lr_log).
*          lo_ptf_run->append_log_structure( is_log = lr_log->* ).
*        ENDLOOP.
*
*        execution_status = abap_true.
*
*      ELSE.
**end logic of mocking >>>
****
*        SELECT SINGLE * FROM ptfbo INTO @DATA(ls_ptf_bo_db) WHERE ptf_bo = @<ls_step_data>-bus_obj.
*        IF sy-subrc IS NOT INITIAL.
*          DATA(lo_ptf_rap_metadata) = NEW cl_ptf_rap_metadata( ).
*          DATA(lv_is_rap_bo) = lo_ptf_rap_metadata->check_rap_bo( <ls_step_data>-bus_obj ).
*          ASSERT lv_is_rap_bo EQ abap_on.
*        ENDIF.
*
*        "Create BO class instance
*        IF ls_ptf_bo_db-bo_class IS INITIAL.
*          IF lv_is_rap_bo = abap_off.
*            lv_class_name = |CL_PTF_BO_{ ls_ptf_bo_db-ptf_bo }|.
*
*          ELSE.
*            lv_class_name = |CL_PTF_BO_RAP_GENERIC|.
*
*          ENDIF.
*
*        ELSE.
*          lv_class_name = |{ ls_ptf_bo_db-bo_class }|.
*        ENDIF.
*        CLEAR: ls_parameter_constructor,lt_parameter_constructor.
*        ls_parameter_constructor-kind = cl_abap_objectdescr=>exporting.
*        ls_parameter_constructor-name = 'IV_RUN_ENVIRONMENT'.
*        GET REFERENCE OF lo_ptf_run INTO ls_parameter_constructor-value. "former: of ME
*        INSERT ls_parameter_constructor INTO TABLE lt_parameter_constructor.
*        TRY.
*            CREATE OBJECT lo_bo TYPE (lv_class_name) PARAMETER-TABLE lt_parameter_constructor.
*          CATCH cx_sy_create_object_error INTO DATA(lx).
*            lo_ptf_run->append_log( |Couldn't find the class { lv_class_name } for BO { ls_ptf_bo_db-ptf_bo }| ).
*            <ls_step_data>-execution_status = abap_false.
*            <ls_step_data>-check_status = abap_false.
*            lv_step_index = lv_step_index + 1.
*            RETURN. "  "insufficient
*        ENDTRY.
*        CHECK lo_bo IS BOUND.  "end loop pass
*
*        lo_ptf_run->prepare_action_call(
*          IMPORTING
*            ev_method_name   = lv_method_name
*          CHANGING
*            document_id      = document_id
*            execution_status = execution_status
*            check_status     = check_status
*            is_step_data     = <ls_step_data>
*          RECEIVING
*            rt_parameter     = lt_parameter
*        ).
*
*****Temp: RITA problem for RunIn1Session
*        IF count_pick_calls GT 1.
*          lo_ptf_run->append_log( |WORKAROUND: Refreshing CL_API_LE_DLV_UPD_COLL_FACTORY.| ).
*          cl_api_le_dlv_upd_coll_factory=>changeset_end( ).
*          count_pick_calls = 1.
*        ENDIF.
*****
*        TRY.
*
*            CALL METHOD lo_bo->(lv_method_name)
*              PARAMETER-TABLE
*              lt_parameter.
*
*          CATCH cx_sy_dyn_call_illegal_method INTO DATA(lx_methodcall).
*            lo_ptf_run->append_log( |Couldn't find the method { lv_method_name } in { lv_class_name } for BO { ls_ptf_bo_db-ptf_bo }| ).
*            <ls_step_data>-execution_status = abap_false.
*            <ls_step_data>-check_status = abap_false.
*            lv_step_index = lv_step_index + 1.
*            RETURN.   "insufficient
*        ENDTRY.
*
*        "maybe put these two messages at the beginning of the step's log?
*        IF cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~has_tdc_error( ) IS NOT INITIAL.
*          lo_ptf_run->append_log( |TDC does not exist.| ).
*          "cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~set_stop_run_after_step( abap_true ).
*          lv_end_the_run = abap_true.
*        ENDIF.
*
*        IF cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~get_substituted_tdc_name( ) IS NOT INITIAL.
*          lo_ptf_run->append_log( |!! Z-TDC: { cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~get_substituted_tdc_name( ) } found, used this one !! | ).
*        ENDIF.
*
*      ENDIF. "mocking step / Normal step
*
*
**      IF use_aunit IS INITIAL.   "only in mode 'No AUnit'.
*
*      IF <ls_step_data>-check_flag EQ abap_true.   "now looking at <ls_step_data>-check_flag instead of SELECT to  PTFBOA
*        <ls_step_data>-check_status = check_status.
*        <ls_step_data>-execution_status = execution_status.
*      ELSE.
*        <ls_step_data>-execution_status = execution_status.
*      ENDIF.
*      <ls_step_data>-document_id = document_id.
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
*      DATA(steps) = lo_ptf_run->get_all_steps( ).
*      EXPORT t_step_data  = steps
*        TO MEMORY ID 'CG__PTF_STEP_ALL'.
*
*
*      "Loop end handling for both modes
*
*      "Handle failed check
*      IF <ls_step_data>-check_flag EQ abap_true  AND  <ls_step_data>-check_status EQ abap_false.
*        lv_log_status = 1.
*        lo_ptf_run->append_log( '************************************' ).
*        lo_ptf_run->append_log( |Check failed, PTF run is stopped.| ).
*        "toDO: export failed <ls_step_data>-step_number for SUT class
*        EXIT. "Exit loop, end run
*      ENDIF.
*
*      "Increase index
*      lv_step_index = lv_step_index + 1.
*
*      IF
**        dump_occured EQ abap_true OR
*        lv_end_the_run EQ abap_true.
*        lv_log_status = 1. "20210702: Flags for dump or end_the_run now set run to failed
*        EXIT.
*      ENDIF.
*
*    ENDLOOP."LOOP AT lt_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data>).
*
*
*
*    GET TIME STAMP FIELD lv_timestamp_end.
*    DATA(lv_duration_all_steps) = cl_abap_tstmp=>subtract( EXPORTING tstmp1 = lv_timestamp_end tstmp2 = lv_timestamp_start ).
*    lo_ptf_run->append_log( '************************************' ).
*    IF lv_duration_all_steps IS NOT INITIAL.
*      lo_ptf_run->append_log( |Sum of step durations:  { lv_duration_all_steps } .| ).
*    ENDIF.
*
*    "moved here from one level higher (EXECUTE), mostly as here lv_runtime is available  "also done in the loop, per step. here needed for the log part after endloop
*    DATA(lt_log_for_export) = lo_ptf_run->get_log( ).
*    EXPORT t_log         = lt_log_for_export
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
*
*
**  ENDMETHOD.
*
*    EXPORT v_log_status = lv_log_status
*           v_step_index = lv_step_index
*           TO MEMORY ID 'PTF_RUN_RESULT'.
*
*    "run ended without dump - update ABAP memory
*    cl_ptf_run=>set_not_running( lv_run_uuid ).

  ENDMETHOD.


  METHOD execute_ptf_run_v3__loop_part.

    DATA:
      lt_step_data       TYPE cl_ptf_util=>gt_ptf_step_tab,
*      lv_step_index    TYPE i,
      lv_step_index_ok   TYPE i,
      lv_log_status      TYPE sysubrc,
      lv_run_uuid        TYPE sysuuid_c26,
      lo_ptf_run         TYPE REF TO cl_ptf_run,
      lt_run_log         TYPE cl_ptf_util=>gt_ptf_return_tab,
      lv_timestamp_start TYPE timestampl,
      lv_timestamp_end   TYPE timestampl.

    IMPORT t_step_data  = lt_step_data
           run_uuid     = lv_run_uuid
           FROM MEMORY ID 'CG__PTF_STEP_ALL'.
    FREE MEMORY ID 'CG__PTF_STEP_ALL'.

    IF lt_step_data IS INITIAL. " Central AU run, not triggered by CL_PTF_RUN
      RETURN.
    ENDIF.

*    lv_step_index = 0.   "0 is the first step
    lv_step_index_ok = 0. "actually first step is 1, will be increased first in every loop pass now.
    lv_log_status = 0.  "0: run succesful   1: run failed

    lo_ptf_run = NEW cl_ptf_run( it_ptf_steps   = lt_step_data ).
*   Set variant name into lo_ptf_run
    DATA(lo_ptf_abap_memory) = NEW cl_ptf_abap_memory( ).
    DATA(ls_result) = lo_ptf_abap_memory->get_run_head( EXPORTING iv_run_uuid = lv_run_uuid ).
    lo_ptf_run->set_variant_name( ls_result-variant ).

    lo_ptf_run->append_log( |-PTF Run in a SINGLE session-| ).

    GET TIME STAMP FIELD lv_timestamp_start.


    LOOP AT lt_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data>).
****TEMP RITA
      IF <ls_step_data>-bus_obj EQ 'OUTB_DELIVERY' AND <ls_step_data>-action EQ 'PICK_ALL_ITEMS'.
        DATA pick_was_called TYPE abap_bool.
        IF pick_was_called EQ abap_true.
          lo_ptf_run->append_log( |WORKAROUND: Refreshing CL_API_LE_DLV_UPD_COLL_FACTORY.| ).
          cl_api_le_dlv_upd_coll_factory=>changeset_end( ).
        ENDIF.
        pick_was_called = abap_true.
      ENDIF.
****

      IF <ls_step_data>-bus_obj IS INITIAL
        AND <ls_step_data>-action IS INITIAL
        AND <ls_step_data>-variant IS INITIAL.
        EXIT.   "exit the loop
      ENDIF.

      ADD 1 TO lv_step_index_ok.

      "export step index, to have it current in case of a dump
      EXPORT v_log_status = lv_log_status    "exporting the log status has no benefit here, as it is always 0 (ok) at the beginning of a step
             v_step_index = lv_step_index_ok
             TO MEMORY ID 'PTF_RUN_RESULT'.

      CHECK <ls_step_data>-action IS NOT INITIAL AND <ls_step_data>-bus_obj IS NOT INITIAL.   "end loop pass    "loop ends when first 3 columns are empty, record is ignored and loop goes on when first 2 are empty. why??

      lo_ptf_run->log_step_start( <ls_step_data> ).

      IF <ls_step_data>-bus_obj EQ 'PTF_RUN'.
        IF <ls_step_data>-action EQ 'EXIT'.
          lo_ptf_run->append_log( |End of PTF run due to EXIT.| ).
          <ls_step_data>-execution_status = abap_true.     "NO EFFECT as this changes only the local itab!!
          EXIT.  "exit the loop
        ENDIF.
      ENDIF.

      "We export the log at the beginning of each step (benefit compared to end of step: if the step dumps, we have already logged BO and action name), and after the loop.
      lt_run_log = lo_ptf_run->get_log( ).
      EXPORT t_log         = lt_run_log
*           v_duration    = lv_run_time
*           v_end_the_run = lv_end_the_run
      TO MEMORY ID 'CG__PTF_STEP_RESULT'.
*** END of outer method



      IF <ls_step_data>-bus_obj EQ cl_ptf_util=>gc_bo_ptfrun  AND <ls_step_data>-action NE cl_ptf_util=>gc_check_messages.  "action check_messages is implemented in BO class PTF_RUN, called like normal actions
**db mocking    CALL TO tcl_ptf_db_mock_util HAS TO BE IN A TCL (this one, or a reuse class).  ToDo: extract to own method
        DATA:
          lv_tdc      TYPE etobj_name,
          lv_tdcv     TYPE etvar_id,
          lv_tdc_old  TYPE etobj_name,
          lv_tdcv_old TYPE etvar_id.

        IF <ls_step_data>-action EQ cl_ptf_util=>gc_action_mock_db. "'START_DATA_MOCKING'.

          IF <ls_step_data>-variant CS ','.
            SPLIT <ls_step_data>-variant AT ',' INTO lv_tdc lv_tdcv.
          ELSE.
            lv_tdc  = <ls_step_data>-test_data_container.
            lv_tdcv = <ls_step_data>-variant.
          ENDIF.

          IF lv_tdc IS INITIAL OR lv_tdcv IS INITIAL.
            lo_ptf_run->append_log( |Wrong configuration. Please fill TDC and TDCV. Stopping now.| ).
            <ls_step_data>-execution_status = abap_false.
            EXIT.  "end the run
          ENDIF.

*        IMPORT v_mock_tdc   = lv_tdc_old
*               v_mock_tdcv  = lv_tdcv_old
*               "tdc_done     = lv_tdc_done
*               FROM MEMORY ID 'CG__PTF_MOCK_TD'.
          IF lv_tdc_old IS NOT INITIAL AND lv_tdcv_old IS NOT INITIAL.
            "mocking from another tdc/tdcv is already active.
            lo_ptf_run->append_log( iv_log_statement = |As this tests runs in one session, DB mocking can be done only once. Stopping now.| ).
            EXIT.   "end the run           "open: but I could allow different content for already mocked tables
          ENDIF.

          "ok, we will use the given TDC+TDCV
          "use lv_tdc
          "use lv_tdcv

          lo_ptf_run->append_log( |DB mocking is now active (ignore Execution status).| ).

          tcl_ptf_db_mock_util=>mv_tdc  = lv_tdc.
          tcl_ptf_db_mock_util=>mv_tdcv = lv_tdcv.
          tcl_ptf_db_mock_util=>startmock( ).
*          EXPORT
*           v_mock_tdc   = lv_tdc
*           v_mock_tdcv  = lv_tdcv
*           tdc_done     = abap_true
*           TO MEMORY ID 'CG__PTF_MOCK_TD'.
          lv_tdc_old  = lv_tdc. "in one session, the local variables are enough
          lv_tdcv_old = lv_tdcv.
          DATA(lt_log_mocking) = tcl_ptf_db_mock_util=>get_log( ).
          LOOP AT lt_log_mocking REFERENCE INTO DATA(lr_log).
            lo_ptf_run->append_log_structure( is_log = lr_log->* ).
          ENDLOOP.

          <ls_step_data>-execution_status = abap_true.    "NO EFFECT as this changes only the local itab!!

        ELSEIF <ls_step_data>-action EQ cl_ptf_util=>gc_action_end_mock_db. "'END_DATA_MOCKING'.
          tcl_ptf_db_mock_util=>endmock( ). "instead of  FREE MEMORY ID 'CG__PTF_MOCK_TD'.
          lo_ptf_run->append_log( iv_log_statement = |DB mocking DEactivated. (ignore Execution status)| ).
          <ls_step_data>-execution_status = abap_true.    "NO EFFECT as this changes only the local itab!!

**end logic of db mocking >>>

**FT mocking
          DATA lv_feat_tog_id LIKE lv_tdcv.
          DATA lb_active TYPE abap_bool.

        ELSEIF <ls_step_data>-action EQ cl_ptf_util=>gc_action_start_ftmock_active. "'START_MOCK_FT_IS_ACTIVE'
          IF <ls_step_data>-variant IS NOT INITIAL.
*            EXPORT v_feat_toggle_id   = <ls_step_data>-variant
*                   b_active           = abap_true
*            TO MEMORY ID 'CG__PTF_FT_TOG_MOCK'.
             "in one session, local variables are enough
            lv_feat_tog_id = <ls_step_data>-variant.
            lb_active = abap_true.
            lo_ptf_run->append_log( iv_log_statement = |Starting to mock: Feature toggle is simulated ON. (Ignore Execution status)| ).
            <ls_step_data>-execution_status = abap_true.    "NO EFFECT as this changes only the local itab!!
            DATA(lv_safe) = cl_feature_toggle_4_test=>define_test_toggle(
              iv_toggle_id = CONV #( lv_feat_tog_id )  "limitation: only 30 of 40 chars supported
              iv_active    = lb_active ).
            IF lv_safe EQ abap_true.   "does not fail even if the ID is unknown
              lo_ptf_run->append_log( iv_log_statement = |FT mocking... FT ID:| && lv_feat_tog_id && |, state:<| && lb_active && |>.| ).
            ELSE.
              lo_ptf_run->append_log( iv_log_statement = |FT mocking FAILED. FT ID:| && lv_feat_tog_id && |.| ).
            ENDIF.
          ENDIF.

        ELSEIF <ls_step_data>-action EQ cl_ptf_util=>gc_action_start_ftmock_inactv. "'START_MOCK_FT_IS_INACTIVE'
          IF <ls_step_data>-variant IS NOT INITIAL.
*            EXPORT v_feat_toggle_id   = <ls_step_data>-variant
*                   b_active           = abap_false
*            TO MEMORY ID 'CG__PTF_FT_TOG_MOCK'.
            lv_feat_tog_id = <ls_step_data>-variant.
            lb_active = abap_false.
            lo_ptf_run->append_log( iv_log_statement = |Starting to mock: Feature toggle is simulated OFF. (Ignore Execution status)| ).
            <ls_step_data>-execution_status = abap_true.    "NO EFFECT as this changes only the local itab!!
            lv_safe = cl_feature_toggle_4_test=>define_test_toggle(
              iv_toggle_id = CONV #( lv_feat_tog_id )  "limitation: only 30 of 40 chars supported
              iv_active    = lb_active ).
            IF lv_safe EQ abap_true.   "does not fail even if the ID is unknown
              lo_ptf_run->append_log( iv_log_statement = |FT mocking... FT ID:| && lv_feat_tog_id && |, state:<| && lb_active && |>.| ).
            ELSE.
              lo_ptf_run->append_log( iv_log_statement = |FT mocking FAILED. FT ID:| && lv_feat_tog_id && |.| ).
            ENDIF.

          ENDIF.
        ELSEIF <ls_step_data>-action EQ cl_ptf_util=>gc_action_end_ftmock.          "'END_FT_MOCKING'
          cl_feature_toggle_4_test=>cleanup_test_toggle( ).   "instead of  FREE MEMORY ID 'CG__PTF_FT_TOG_MOCK'.
          lo_ptf_run->append_log( iv_log_statement = |Feature toggle mocking has been stopped. (Ignore Execution status)| ).
          <ls_step_data>-execution_status = abap_true.    "NO EFFECT as this changes only the local itab!!
** end of coding for FT mocking >>>

        ELSE.
          ASSERT 1 = 2.  "unexpected action for PTF_RUN
        ENDIF.

      ELSE. " IF BO EQ 'PTF_RUN'


        "Execute the std part of the step
        lo_ptf_run->execute_step(
          EXPORTING
            iv_step_index   = lv_step_index_ok
*          IMPORTING
*            ev_stop_the_run = lv_stop_the_run
          CHANGING
            cv_log_status   = lv_log_status
        ).

*       BUPA switch mocking                     "could be moved to an reuse method, even non TCL seems possible, same coding (slight log text delta) is also in TCL_PTF_STEP_IN_AU-EXECUTE_PTF_STEP
        "Has BuPa multi address switch mocking JUST been activated in ABAP memory?
        IF <ls_step_data>-bus_obj EQ cl_ptf_bo_bupa_switch_mock=>gc_bo_name. " |BUPA_MULTI_ADDR_SWITCH_MOCK|
          DATA lv_switch TYPE sftgl_ft_id.
          DATA lb_switch_active TYPE abap_bool.
          IMPORT v_bp_switch   = lv_switch
                 b_active      = lb_switch_active
                 FROM MEMORY ID 'CG__PTF_BP_SWITCH'.
          IF sy-subrc IS INITIAL AND lv_switch IS NOT INITIAL.
            DATA(lo_switch_handler) = NEW cl_bupa_multi_addr_4_test( ).
            "Now do it, for this session, until another action of this BO is called
            lo_switch_handler->define_switch_status( iv_switch_id = CONV string( lv_switch )
                                                     iv_active    = lb_switch_active ).
            IF lb_switch_active EQ abap_true.
              lo_ptf_run->append_log( iv_log_statement = |Switch mocking will stay active until changed. Switch:| && lv_switch && |, mocked state: ON.| )."this is the own text for RunIn1Session
            ELSE.
              lo_ptf_run->append_log( iv_log_statement = |Switch mocking will stay active until changed. Switch:| && lv_switch && |, mocked state: OFF.| ).
            ENDIF.
            "clearing ABAP memory is not needed: any new action of this BO will either clear it or overwrite it
          ENDIF.
        ENDIF.


      ENDIF.

** STD STEP LOGIC - has to be in CL if reuse by non AU mode is needed
*        SELECT SINGLE * FROM ptfbo INTO @DATA(ls_ptf_bo_db) WHERE ptf_bo = @<ls_step_data>-bus_obj.
*...
*        TRY.
*
*            CALL METHOD lo_bo->(lv_method_name)
*              PARAMETER-TABLE
*              lt_parameter.
*
*          CATCH cx_sy_dyn_call_illegal_method INTO DATA(lx_methodcall).
*            ...
*        ENDTRY.
*
*        IF cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~has_tdc_error( ) IS NOT INITIAL.
*          lo_ptf_run->append_log( |TDC does not exist.| ).
*          lv_end_the_run = abap_true.
*        ENDIF.
*
*        IF cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~get_substituted_tdc_name( ) IS NOT INITIAL.
*          lo_ptf_run->append_log( |!! Z-TDC: { cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~get_substituted_tdc_name( ) } found, used this one !! | ).
*        ENDIF.
*
*      ENDIF. "mocking step / Normal step
*
*
*      IF <ls_step_data>-check_flag EQ abap_true.
*        <ls_step_data>-check_status = check_status.
*        <ls_step_data>-execution_status = execution_status.
*      ELSE.
*        <ls_step_data>-execution_status = execution_status.
*      ENDIF.
*      <ls_step_data>-document_id = document_id.
*
*      DATA lv_one_created_doc TYPE ptfkey.
*      CLEAR lv_one_created_doc.
*      LOOP AT document_id INTO lv_one_created_doc.
*      ENDLOOP.
*      EXPORT created_doc = lv_one_created_doc TO MEMORY ID 'PTF_LAST_CREATED_DOC'.
*
*      DATA(steps) = lo_ptf_run->get_all_steps( ).
*      EXPORT t_step_data  = steps
*        TO MEMORY ID 'CG__PTF_STEP_ALL'.
*
*
*      "Loop end handling for both modes
*
*      "Handle failed check
*      IF <ls_step_data>-check_flag EQ abap_true  AND  <ls_step_data>-check_status EQ abap_false.
*        lv_log_status = 1.
*        lo_ptf_run->append_log( '************************************' ).
*        lo_ptf_run->append_log( |Check failed, PTF run is stopped.| ).
*        "toDO: export failed <ls_step_data>-step_number for SUT class
*        EXIT. "Exit loop, end run
*      ENDIF.
*

*>> END STD STEP LOGIC


      IF lv_log_status EQ 1. "failed
        EXIT. "exit the loop
      ENDIF.

    ENDLOOP."LOOP AT lt_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data>).



    GET TIME STAMP FIELD lv_timestamp_end.
    DATA(lv_duration_all_steps) = cl_abap_tstmp=>subtract( EXPORTING tstmp1 = lv_timestamp_end tstmp2 = lv_timestamp_start ).
    lo_ptf_run->append_log( '************************************' ).
    IF lv_duration_all_steps IS NOT INITIAL.
      lo_ptf_run->append_log( |Sum of step durations:  { lv_duration_all_steps } .| ).
    ENDIF.

    "also done at the beginning of the loop, per step. here needed for the last step, and the log part after endloop
    DATA(lt_log_for_export) = lo_ptf_run->get_log( ).
    EXPORT t_log         = lt_log_for_export
           v_duration    = lv_duration_all_steps
*           v_end_the_run = lv_end_the_run
    TO MEMORY ID 'CG__PTF_STEP_RESULT'.

    "After the loop: Was the last step a failed normal action?
    IF <ls_step_data>-check_flag EQ abap_false  AND  <ls_step_data>-execution_status EQ abap_false.
      lv_log_status = 1.  "considered in this method since May 2023
    ENDIF.


*   Rollback performed by AUnit Framework will clear all changes that have not been committed until now


    EXPORT v_log_status = lv_log_status
           v_step_index = lv_step_index_ok
           TO MEMORY ID 'PTF_RUN_RESULT'.

    "run ended without dump - update ABAP memory
    cl_ptf_run=>set_not_running( lv_run_uuid ).

  ENDMETHOD.


  METHOD note_step_data_issue__internal.

    DATA lo_mem      TYPE REF TO cl_ptf_abap_memory.
    DATA ls_run_head TYPE cl_ptf_util=>ty_run_head.
    DATA ls_log TYPE ptf_exec_log.

    lo_mem = NEW cl_ptf_abap_memory( ).
    ls_run_head = lo_mem->get_run_head( iv_run_uuid ).

    ls_log = VALUE #(
     start_date = ls_run_head-start_date
     start_time = ls_run_head-start_time
*     run_result = iv_log_status
     userid     = sy-uname
     is_batch   = ls_run_head-is_batch
*     dump_occured = iv_dump_occured
*     session_type = iv_session_type
     ).

    IF ls_run_head-variant IS NOT INITIAL.
      ls_log-ptf_script = ls_run_head-variant.
    ENDIF.

    "ensure that key is unique
    ls_log-ptf_script+26 = 'YY'.
    data lv_step_numc3 type n length 3.
    lv_step_numc3 = IV_STEP_NO.
    ls_log-ptf_script+28 = lv_step_numc3.

    ls_log-failed_boa = 'PTFBOA validation'.

    CHECK ls_log-start_date IS NOT INITIAL.
    CHECK ls_log-start_time IS NOT INITIAL.

    INSERT ptf_exec_log FROM ls_log.
    COMMIT WORK AND WAIT.

  ENDMETHOD.


  METHOD setup.
  ENDMETHOD.


  METHOD teardown.
  ENDMETHOD.
ENDCLASS.
