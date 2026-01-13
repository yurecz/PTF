class CL_PTF_BO_PTF_RUN definition
  public
  inheriting from CL_PTF_BO
  final
  create public .

public section.

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

  methods CHECK_MESSAGES
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL  ##RELAX.
  methods APPLY_EXPECTATIONS
    importing
      !IT_EXP_MESSAGES type PTF_EXP_MESSAGE_T
      !IT_ACT_MESSAGES type BAPIRETTAB
      !IV_BUS_OBJ type PTF_BO
      !IV_STEP_NUMBER type I
    exporting
      !EV_CHECK_STATUS type ABAP_BOOL .
ENDCLASS.



CLASS CL_PTF_BO_PTF_RUN IMPLEMENTATION.


  METHOD apply_expectations.
    DATA: lo_ptf_rap_json_ref_parser  TYPE REF TO if_ptf_rap_json_ref_parser,
          lv_or_valid                 TYPE abap_bool,
          lv_valid                    TYPE abap_bool,
          lv_error                    TYPE abap_bool,
          lv_msgno_low                TYPE i,
          lv_msgno_high               TYPE i.

    CLEAR ev_check_status.

*   Instantiate reference parser
    lo_ptf_rap_json_ref_parser  = NEW cl_ptf_rap_json_ref_parser( me->mo_run_environment ).

*   Copy expected messages to local variable to avoid write-only dump in case of parsing references
    DATA(lt_exp_messages) = it_exp_messages.

    LOOP AT lt_exp_messages ASSIGNING FIELD-SYMBOL(<fs_exp_messages>).
      CLEAR lv_valid.

      LOOP AT it_act_messages ASSIGNING FIELD-SYMBOL(<fs_act_messages>).
        IF <fs_exp_messages>-msgid IS NOT INITIAL AND <fs_exp_messages>-msgid <> <fs_act_messages>-id. "Same message ID
          CONTINUE.

        ENDIF.

        IF <fs_exp_messages>-msgty IS NOT INITIAL AND <fs_exp_messages>-msgty <> <fs_act_messages>-type. "Same message type if there is
          CONTINUE.

        ENDIF.

        IF <fs_exp_messages>-msgno_low IS NOT INITIAL. "Same message number if there is
          lv_msgno_low = <fs_exp_messages>-msgno_low.

          IF <fs_exp_messages>-msgno_high IS NOT INITIAL.
            lv_msgno_high = <fs_exp_messages>-msgno_high.

            IF <fs_act_messages>-number NOT BETWEEN lv_msgno_low AND lv_msgno_high.
              CONTINUE.

            ENDIF.

          ELSE.
            IF <fs_act_messages>-number <> lv_msgno_low.
              CONTINUE.

            ENDIF.

          ENDIF.

        ENDIF.

        IF <fs_exp_messages>-msgv1 IS NOT INITIAL.
          lo_ptf_rap_json_ref_parser->parse_reference(
            EXPORTING
              iv_entity_name = iv_bus_obj
              iv_name        = 'MSGV1'
              iv_step_number = iv_step_number
            IMPORTING
              ev_error       = lv_error
            CHANGING
              cv_value       = <fs_exp_messages>-msgv1
          ).

          IF lv_error = abap_on.
            RETURN.

          ENDIF.

          IF <fs_act_messages>-message_v1 <> <fs_exp_messages>-msgv1.
            CONTINUE.

          ENDIF.

        ENDIF.

        IF <fs_exp_messages>-msgv2 IS NOT INITIAL.
          lo_ptf_rap_json_ref_parser->parse_reference(
            EXPORTING
              iv_entity_name = iv_bus_obj
              iv_name        = 'MSGV2'
              iv_step_number = iv_step_number
            IMPORTING
              ev_error       = lv_error
            CHANGING
              cv_value       = <fs_exp_messages>-msgv2
          ).

          IF lv_error = abap_on.
            RETURN.

          ENDIF.

          IF <fs_act_messages>-message_v2 <> <fs_exp_messages>-msgv2.
            CONTINUE.

          ENDIF.

        ENDIF.

        IF <fs_exp_messages>-msgv3 IS NOT INITIAL.
          lo_ptf_rap_json_ref_parser->parse_reference(
            EXPORTING
              iv_entity_name = iv_bus_obj
              iv_name        = 'MSGV3'
              iv_step_number = iv_step_number
            IMPORTING
              ev_error       = lv_error
            CHANGING
              cv_value       = <fs_exp_messages>-msgv3
          ).

          IF lv_error = abap_on.
            RETURN.

          ENDIF.

          IF <fs_act_messages>-message_v3 <> <fs_exp_messages>-msgv3.
            CONTINUE.

          ENDIF.

        ENDIF.

        IF <fs_exp_messages>-msgv4 IS NOT INITIAL.
          lo_ptf_rap_json_ref_parser->parse_reference(
            EXPORTING
              iv_entity_name = iv_bus_obj
              iv_name        = 'MSGV4'
              iv_step_number = iv_step_number
            IMPORTING
              ev_error       = lv_error
            CHANGING
              cv_value       = <fs_exp_messages>-msgv4
          ).

          IF lv_error = abap_on.
            RETURN.

          ENDIF.

          IF <fs_act_messages>-message_v4 <> <fs_exp_messages>-msgv4.
            CONTINUE.

          ENDIF.

        ENDIF.

        lv_valid = abap_on.
        EXIT.

      ENDLOOP.

*     Reverse value of "valid" if we have NOTCONTAIN option
      IF <fs_exp_messages>-opt = 'NOTCONTAIN'.
        lv_valid = SWITCH #( lv_valid WHEN abap_on THEN abap_off ELSE abap_on ).

      ENDIF.

*     Flag or_valid with true if the operator is OR,
*     to be used to validate subsequent operation even if it will not be valid
      IF <fs_exp_messages>-operator = 'OR' AND lv_valid = abap_on.
        lv_or_valid = abap_on.

      ENDIF.

*     Unflag or_valid if the operator is AND
      IF <fs_exp_messages>-operator = 'AND'.
        lv_or_valid = abap_off.

      ENDIF.

*     If current validation is true or previous or validation was true then the status is ok
      IF lv_valid = abap_on OR lv_or_valid = abap_on.
        ev_check_status = abap_on.

      ELSE.
        ev_check_status = abap_off.

*       If current operator is not OR then stop processing
        IF <fs_exp_messages>-operator <> 'OR'.
          EXIT.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  method CHANGE.
  endmethod.


  method CHECK.
  endmethod.


  method CHECK_EXISTENCE.
  endmethod.


  METHOD check_messages.
    DATA: lt_reference_steps          TYPE STANDARD TABLE OF c WITH DEFAULT KEY,
          lt_act_messages             TYPE bapirettab.

    CLEAR: ev_document_id, ev_execution_status, ev_check_status.

*   Get step data for expected messages
    DATA(ls_step_data_exp) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).

*   Get expected messages
    DATA(lt_exp_messages) = ls_step_data_exp-exp_messages.

    IF ls_step_data_exp-reference_step IS INITIAL.
      me->mo_run_environment->append_log( 'No reference step(s) provided !' ).
      RETURN.

    ENDIF.

*   Begin Log
    lt_reference_steps = CORRESPONDING #( ls_step_data_exp-reference_step ).
    DATA(lv_steps) = concat_lines_of( table = lt_reference_steps sep = ', ' ).
    me->mo_run_environment->append_log( |Validating messages of referenced step(s): { lv_steps }| ).

*   Get actual messages
    LOOP AT ls_step_data_exp-reference_step ASSIGNING FIELD-SYMBOL(<fs_reference_step>).
      DATA(ls_step_data_act) = me->mo_run_environment->get_step_data( iv_step_number =  <fs_reference_step> ).

      APPEND LINES OF ls_step_data_act-act_messages TO lt_act_messages.

    ENDLOOP.

*   Execution runs successfully if both expected and actual messages are initial
    IF lt_exp_messages IS INITIAL
      AND lt_act_messages IS INITIAL.
      ev_check_status     = abap_on.
      ev_execution_status = abap_on.
      RETURN.

    ENDIF.

*   Check expected messages
    IF lt_exp_messages IS INITIAL.
      me->mo_run_environment->append_log( 'No expected messages !' ).
      RETURN.

    ENDIF.

**   Check actual messages
*    IF lt_act_messages IS INITIAL.
*      me->mo_run_environment->append_log( 'No actual messages !' ).
*      RETURN.
*
*    ENDIF.

*   Apply expectations
    me->apply_expectations(
      EXPORTING
        it_exp_messages = lt_exp_messages
        it_act_messages = lt_act_messages
        iv_bus_obj      = ls_step_data_exp-bus_obj
        iv_step_number  = iv_step_number
      IMPORTING
        ev_check_status = ev_check_status
    ).

    CASE ev_check_status.
      WHEN abap_off. "Expectations failed
        me->mo_run_environment->append_log( 'Expectations failed !' ).
        me->mo_run_environment->append_log( 'Expectations:' ).

        LOOP AT lt_exp_messages ASSIGNING FIELD-SYMBOL(<fs_exp_message>).
          me->mo_run_environment->append_log( |Option: { SWITCH #( <fs_exp_message>-opt WHEN 'CONTAIN' THEN 'Contain' WHEN 'NOTCONTAIN' THEN 'NotContain' ) } |
                                              && |Id: { <fs_exp_message>-msgid } Type: { <fs_exp_message>-msgty } |
                                              && |Low: { <fs_exp_message>-msgno_low } High: { <fs_exp_message>-msgno_high } |
                                              && |V1: { <fs_exp_message>-msgv1 } V2: { <fs_exp_message>-msgv2 } |
                                              && |V3: { <fs_exp_message>-msgv3 } V4: { <fs_exp_message>-msgv4 }|
                                              && |Operator: { <fs_exp_message>-operator }| ).

        ENDLOOP.

        me->mo_run_environment->append_log( 'Actual Messages:' ).

        LOOP AT lt_act_messages ASSIGNING FIELD-SYMBOL(<fs_act_message>).
          me->mo_run_environment->append_log( |Id: { <fs_act_message>-id } Type: { <fs_act_message>-type } No: { <fs_act_message>-number } |
                                              && |V1: { <fs_act_message>-message_v1 } V2: { <fs_act_message>-message_v2 } |
                                              && |V3: { <fs_act_message>-message_v3 } V4: { <fs_act_message>-message_v4 }| ).

        ENDLOOP.

      WHEN abap_on. "Expectations fulfilled
        me->mo_run_environment->append_log( |Expectations fulfilled ! There are { lines( lt_act_messages ) } actual messages.| ).

    ENDCASE.

    ev_execution_status = abap_on.

  ENDMETHOD.


  method CREATE.
  endmethod.


  method DELETE.
  endmethod.


  method EXECUTE_ACTION.
  endmethod.


  METHOD execute_check.

    CLEAR: ev_document_id, ev_execution_status, ev_check_status.

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).

    CASE ls_step_data-action.

      WHEN 'CHECK_MESSAGES'.
        me->check_messages(
          EXPORTING
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.

      WHEN OTHERS.
        me->mo_run_environment->append_log( iv_log_statement =  |Could not find method { ls_step_data-action } for the BO { ls_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.
    ENDCASE.


  ENDMETHOD.
ENDCLASS.
