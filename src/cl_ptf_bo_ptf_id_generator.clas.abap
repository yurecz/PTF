class CL_PTF_BO_PTF_ID_GENERATOR definition
  public
  inheriting from CL_PTF_BO
  final
  create public .

public section.

  class-data SC_DIGIT type C value '#' ##NO_TEXT.

  methods CONSTRUCTOR
    importing
      !IV_RUN_ENVIRONMENT type ref to CL_PTF_RUN
      !IO_ID_HANDLER type ref to IF_PTF_ID_HANDLER optional .

  methods CHANGE
    redefinition .
  methods CHECK
    redefinition .
  methods CHECK_EXISTENCE
    redefinition .
  methods CREATE
    redefinition .
  methods DELETE
    redefinition .
  methods EXECUTE_ACTION
    redefinition .
  methods EXECUTE_CHECK
    redefinition .
protected section.
private section.

  data MO_ID_HANDLER type ref to IF_PTF_ID_HANDLER .

  methods GET_UUID
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods GET_NEXT_ID
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
ENDCLASS.



CLASS CL_PTF_BO_PTF_ID_GENERATOR IMPLEMENTATION.


  method CHANGE.
  endmethod.


  method CHECK.
  endmethod.


  method CHECK_EXISTENCE.
  endmethod.


  METHOD constructor.

    super->constructor( iv_run_environment = iv_run_environment ).

    IF io_id_handler IS BOUND.
      mo_id_handler = io_id_handler.
    ELSE.
      mo_id_handler = NEW cl_ptf_id_handler( ).
    ENDIF.

  ENDMETHOD.


  method CREATE.
  endmethod.


  method DELETE.
  endmethod.


  method EXECUTE_ACTION.

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).

    SELECT SINGLE * FROM ptfboa INTO @DATA(ls_ptfboa) WHERE ptf_bo = @ls_step_data-bus_obj AND ptf_act = @ls_step_data-action.
    IF ls_ptfboa-abap_method IS NOT INITIAL.

      "1. Use PTFBOA-ABAP_METHOD if filled
      TRY.
          CALL METHOD me->(ls_ptfboa-abap_method)
            EXPORTING
              step_data           = ls_step_data
              iv_step_number      = iv_step_number
            IMPORTING
              ev_document_id      = ev_document_id
              ev_execution_status = ev_execution_status
              ev_check_status     = ev_check_status.
        CATCH cx_sy_dyn_call_illegal_method INTO DATA(lx_methodcall).
          me->mo_run_environment->append_log( iv_log_statement = |Couldn't find the method { ls_ptfboa-abap_method } from PTFBOA for BO { ls_step_data-bus_obj }| ).
          ev_execution_status = abap_false.
          ev_check_status = abap_false.
      ENDTRY.

*      RETURN.

    ELSE.

      "2. If there is a method with the same name as the action, call it
      DATA(lo_description) = CAST cl_abap_classdescr( cl_abap_typedescr=>describe_by_object_ref( me ) ).
      READ TABLE lo_description->methods WITH TABLE KEY primary_key COMPONENTS name = ls_step_data-action INTO DATA(ls).
      IF sy-subrc IS INITIAL.
        TRY.
            CALL METHOD me->(ls_step_data-action)
              EXPORTING
                step_data           = ls_step_data
                iv_step_number      = iv_step_number
              IMPORTING
                ev_document_id      = ev_document_id
                ev_execution_status = ev_execution_status
                ev_check_status     = ev_check_status.
          CATCH cx_sy_dyn_call_illegal_method INTO lx_methodcall.
            DATA lt_callstack TYPE abap_callstack.
            CALL FUNCTION 'SYSTEM_CALLSTACK'
              EXPORTING
                max_level = 1
              IMPORTING
                callstack = lt_callstack.
            DATA(lv_method) = lt_callstack[ 1 ]-blockname.
*          me->mo_run_environment->append_log( iv_log_statement = |Couldn't find the method { ls_step_data-action } for BO { ls_step_data-bus_obj }| ).
            me->mo_run_environment->append_log( iv_log_statement = |Dynamic call out of { lv_method }, based on action name { ls_step_data-action }, failed. { cl_abap_classdescr=>get_class_name( me ) }| ).
            ev_execution_status = abap_false.
            ev_check_status = abap_false.
        ENDTRY.

*        RETURN.

      ENDIF.

    ENDIF.

  endmethod.


  method EXECUTE_CHECK.
  endmethod.


  METHOD get_next_id.

    CLEAR ev_execution_status.

    IF strlen( step_data-variant ) GT 30.  "ETVAR_ID is c30. Field VARIANT is currently longer because of the Mock-TDC workaround, shall be shortened to 30 in the future.
      mo_run_environment->append_log( |Maximum pattern length is 30 chars.| ).
      RETURN.
    ENDIF.

    DATA lv_pattern TYPE c LENGTH 30.
    lv_pattern = step_data-variant.

    mo_id_handler->split_pattern(
      EXPORTING
        iv_pattern      = lv_pattern
      IMPORTING
        ev_no_of_digits = DATA(lv_no_of_digits)
        ev_prefix       = DATA(lv_prefix)
        ev_suffix       = DATA(lv_suffix)
        ev_error        = DATA(lv_error)
        ev_error_text   = DATA(lv_error_text)
    ).
    "lv_no_of_digits EQ 0 is not allowed. we start strict, split_pattern sets ev_error in this case

    IF lv_error IS NOT INITIAL.
      mo_run_environment->append_log( conv #( lv_error_text(60) ) ).
      RETURN.
    ENDIF.

    IF lv_no_of_digits GT 12.
      mo_run_environment->append_log( |Maximum number length is 12 digits. Use prefix with 0s if you need more.| ).
      RETURN.
    ENDIF.


*    "get number from suitable number range interval, for lv_no_of_digits digits, into lv_number_n12.
    DATA(lv_number_n12) = mo_id_handler->get_next_number(
      EXPORTING
        iv_no_of_max_filled_digits = lv_no_of_digits
    ).

    IF lv_number_n12 IS INITIAL.
      mo_run_environment->append_log( |Error in number range access!| ).
      RETURN.
    ENDIF.


    DATA offset TYPE i.
    DATA lv_number_requested TYPE string.
    DATA lv_id TYPE ptfkey.

    offset = 12 - lv_no_of_digits.
    lv_number_requested = lv_number_n12+offset.

    lv_id = lv_prefix && lv_number_requested && lv_suffix.

    APPEND lv_id TO ev_document_id.
    ev_execution_status = abap_true.

  ENDMETHOD.


  METHOD get_uuid.

    CLEAR ev_execution_status.

    DATA(lo_uuid_handler) = cl_uuid_factory=>create_system_uuid( ).

    TRY.
        DATA(uuid_c26) = lo_uuid_handler->create_uuid_c26( ).
      CATCH cx_uuid_error INTO DATA(lx_uuid).
        DATA(lv_error) = lx_uuid->get_text( ).
        RETURN.
    ENDTRY.

    APPEND uuid_c26 TO ev_document_id.
    ev_execution_status = abap_true.

  ENDMETHOD.
ENDCLASS.
