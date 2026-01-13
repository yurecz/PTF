*&---------------------------------------------------------------------*
*& Report PTF_TEST_1_SCRIPT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ptf_test_1_script.


*CLASS ltc_caller DEFINITION. "FOR TESTING RISK LEVEL CRITICAL DURATION LONG.   "GLOBAL MACHEN
*
*  PUBLIC SECTION.
*    TYPES: ty_t_varname TYPE STANDARD TABLE OF ptf_varname.
*    CLASS-METHODS:
*      call_script IMPORTING iv_ptf_script   TYPE ptf_varname
*                  RETURNING VALUE(rv_subrc) TYPE sysubrc,
*      ptf_mass_call IMPORTING it_varname TYPE ty_t_varname,
*      ptf_single_call IMPORTING iv_varname TYPE ptf_varname.
*
*ENDCLASS.
*
*CLASS ltc_caller IMPLEMENTATION.
*
*  METHOD ptf_single_call.
*    DATA(rc) = call_script( iv_varname ).
*    cl_abap_unit_assert=>assert_initial(
*      EXPORTING
*        act              = rc
*        msg              = 'The test failed:' && iv_varname
*    ).
*  ENDMETHOD.
*
*  METHOD ptf_mass_call.
*    DATA overall_rc TYPE i.
*    DATA no_failed TYPE i.
*    DATA no_executed TYPE i.
*    DATA failed_ids TYPE string.
*    LOOP AT it_varname ASSIGNING FIELD-SYMBOL(<variant>)." WHERE varname(5) = 'ZCG_H'.
*      DATA(rc) = call_script( <variant> ).
*      ADD 1 TO no_executed.
*      IF rc IS NOT INITIAL.
*        overall_rc = rc.
*        ADD 1 TO no_failed.
*        CONCATENATE failed_ids <variant> '|' INTO failed_ids .
*      ENDIF.
*    ENDLOOP.
*
*    cl_abap_unit_assert=>assert_initial(
*      EXPORTING
*        act              = overall_rc
*        msg              = no_failed && ' of_' && no_executed && ' tests failed:' &&  failed_ids && '.'  "cl_abap_char_utilities=>cr_lf
*    ).
*  ENDMETHOD.
*
*  METHOD call_script.
**WRITE: 'Started'.
*
*    DATA: ls_step_data  TYPE cl_ptf_util=>gt_ptf_step,
*          lt_step_data  TYPE TABLE OF cl_ptf_util=>gt_ptf_step,
*          lt_return     TYPE cl_ptf_util=>gt_ptf_return_tab,
*          lv_step_index TYPE i,
*          lv_index      TYPE i,
*          lv_log_status TYPE sysubrc,
*          ptf_runner    TYPE REF TO cl_ptf_run,
*          lr_run_head   TYPE cl_ptf_util=>ty_run_head,
*          lt_run_head   TYPE cl_ptf_util=>ty_gt_run_head.
*
*
**CLEAR ls_step_data.
**ls_step_data-step_number = 1.
**ls_step_data-bus_obj = 'DMR'.
*
*****
*    IF iv_ptf_script IS INITIAL.
**      BREAK-POINT.
*      EXIT.
*    ENDIF.
*
*    DATA gt_variant TYPE cl_ptf_variant=>gty_step_data_tab.
*    DATA gs_variant TYPE cl_ptf_variant=>gty_step_data.
*
*    DATA go_variant TYPE REF TO cl_ptf_variant.
*
*    IF go_variant IS NOT BOUND.
*      go_variant = NEW cl_ptf_variant( ).
*    ENDIF.
*
*    go_variant->read(
*      EXPORTING
*        iv_varname     = iv_ptf_script
*      IMPORTING
*        et_variant_tab = gt_variant
*         ).
*    IF gt_variant IS INITIAL.
**      BREAK-POINT.
*      EXIT.
*    ENDIF.
*
*    MOVE-CORRESPONDING gt_variant TO lt_step_data.
*    LOOP AT lt_step_data ASSIGNING FIELD-SYMBOL(<fs>).
*      <fs>-step_number = sy-tabix.
*    ENDLOOP.
****
*    "outdated: does not fill the check flag in lt_step_data...
*
*    ptf_runner = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).
*
*    TRY.
*        DATA(uuid) = NEW cl_system_uuid( )->if_system_uuid~create_uuid_c26( ).
*      CATCH cx_uuid_error.
*        cl_abap_unit_assert=>fail( ).
*    ENDTRY.
*
*    lr_run_head-run_uuid            = uuid.
*    lr_run_head-variant             = ''.
*    lr_run_head-start_timestamp     = ''.
*    lr_run_head-user                = sy-uname.
*    lr_run_head-is_step_running     = ''.
*    lr_run_head-is_finished         = ''.
*    lr_run_head-current_step_number = ''.
*
*    APPEND lr_run_head TO lt_run_head.
*
*    EXPORT t_run_head = lt_run_head TO MEMORY ID 'PTF_RUNS'.
*
*    ptf_runner->execute(
*      EXPORTING
*        iv_run_uuid = uuid
*      CHANGING
*        gv_step_index = lv_step_index
*        gv_log_status = lv_log_status
*    ).
*
*    lt_step_data = ptf_runner->get_all_steps( ).
*    lt_return = ptf_runner->get_log( ).
*
*
**  IF glv_log_status EQ 0 AND gv_step_index GT 0. "Ensure that at least one step was executed with gv_step_index GT 0
*    IF lv_log_status EQ 0 AND lv_step_index GT 0. "Ensure that at least one step was executed with gv_step_index GT 0
*      READ TABLE lt_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data>) INDEX lv_step_index.
*      IF <ls_step_data> IS ASSIGNED.
*        IF <ls_step_data>-check_flag EQ abap_true AND <ls_step_data>-check_status EQ abap_true.
*          rv_subrc = 0.
*        ELSEIF <ls_step_data>-check_flag EQ abap_false.
*          LOOP AT lt_step_data ASSIGNING <ls_step_data>.
*            IF <ls_step_data>-execution_status EQ abap_false.   "OBSOLETE CODING, has error
*              rv_subrc = 1.
**            gv_failed_bo = <ls_step_data>-bus_obj.
**            gv_failed_bo_action = <ls_step_data>-action.
*              EXIT.
*            ENDIF.
*            lv_step_index = lv_step_index - 1.
*            IF lv_step_index EQ 0.
*              rv_subrc = 0.
*              EXIT.
*            ENDIF.
*          ENDLOOP.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*
**
**
**READ TABLE lt_step_data INTO ls_step_data INDEX 8.
**READ TABLE ls_step_data-document_id INTO DATA(lv_invoicelist_id) INDEX 1.
**
**"Via Message the sales order VBELN can be read by an eCatt script call
**MESSAGE ID '00' TYPE 'I' NUMBER 398 WITH lv_invoicelist_id. "& & & &
*
*
**WRITE: /, 'End.'.
*
*  ENDMETHOD.
*
*ENDCLASS.
*
*
*
*CLASS ltc_single_test DEFINITION FOR TESTING
*  RISK LEVEL CRITICAL
*  DURATION LONG.
*
*  PRIVATE SECTION.
*    METHODS:
*      call_test_zcg_bd_from_bdr ."FOR TESTING.
**      call_ptf2 FOR TESTING.
*ENDCLASS.
*
*CLASS ltc_single_test IMPLEMENTATION.
*
*  METHOD call_test_zcg_bd_from_bdr.
*    DATA lc_varid TYPE ptf_varname VALUE 'ZCG_BD_FROM_BDR'.
*    ltc_caller=>ptf_single_call( lc_varid ).
**    cl_abap_unit_assert=>assert_initial(
**      EXPORTING
**        act              = rc
**        msg              = lc_varid && ' failed'
**    ).
*  ENDMETHOD.
**  METHOD call_ptf2.
**    DATA lc_varid TYPE ptf_varname VALUE 'ZCG_OR_ER9_001'.
**    DATA(rc) = call_script( lc_varid ).
**    cl_abap_unit_assert=>assert_initial(
**      EXPORTING
**        act              = rc
**        msg              = lc_varid && ' failed'
**    ).
**  ENDMETHOD.
*
*ENDCLASS.
*
*
*CLASS ltc_tags DEFINITION FOR TESTING
*  RISK LEVEL CRITICAL
*  DURATION LONG.
*  PRIVATE SECTION.
*    METHODS:
*      call_tag_output ."FOR TESTING.
*
*ENDCLASS.
*CLASS ltc_tags IMPLEMENTATION.
*
*  METHOD call_tag_output.
*    DATA lt_varid TYPE STANDARD TABLE OF ptf_varname.
*    SELECT varname FROM ptf_var_tag_map INTO TABLE @lt_varid WHERE tag = 'OUTPUT'.
*    ltc_caller=>ptf_mass_call( lt_varid ).
*  ENDMETHOD.
*ENDCLASS.
*
*CLASS ltc_scope_items DEFINITION FOR TESTING
*  RISK LEVEL CRITICAL
*  DURATION LONG.
*  PRIVATE SECTION.
*    METHODS:
*      call_scope_item_1z1 ."FOR TESTING.
*ENDCLASS.
*CLASS ltc_scope_items IMPLEMENTATION.
*  METHOD call_scope_item_1z1.
*    DATA lt_varid TYPE STANDARD TABLE OF ptf_varname.
*    SELECT varname FROM ptf_varid INTO TABLE @lt_varid WHERE scope_item = '1Z1'.
*    ltc_caller=>ptf_mass_call( lt_varid ).
*  ENDMETHOD.
*
*ENDCLASS.
