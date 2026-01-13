class CL_PTF_BO_BUPA_SWITCH_MOCK definition
  public
  inheriting from CL_PTF_BO
  final
  create public .

public section.

  constants:
    BEGIN OF gc_action,
        mock_on_q2c    TYPE char30 VALUE 'MOCK_Q2C_ACTIVE' ##NO_TEXT,
        mock_on_cstmr  TYPE char30 VALUE 'MOCK_CUSTOMER_ACTIVE' ##NO_TEXT,
        mock_on_iln    TYPE char30 VALUE 'MOCK_ILN_ACTIVE',
        mock_on_tax    TYPE char30 VALUE 'MOCK_TAXNUM_ACTIVE',
        cleanup        TYPE char30 VALUE 'CLEANUP',
        mock_off_q2c   TYPE char30 VALUE 'MOCK_Q2C_INACTIVE',
        mock_off_cstmr TYPE char30 VALUE 'MOCK_CUSTOMER_INACTIVE',
        mock_off_iln   TYPE char30 VALUE 'MOCK_ILN_INACTIVE',
        mock_off_tax   TYPE char30 VALUE 'MOCK_TAXNUM_INACTIVE',
      END OF gc_action .
  constants GC_BO_NAME type PTF_BO value 'BUPA_MULTI_ADDR_SWITCH_MOCK' ##NO_TEXT.

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

  methods START_SWITCH_MOCK
    importing
      !IV_ACTION type PTF_ACT
    exporting
      !EV_EXECUTION_STATUS type ABAP_BOOL .
ENDCLASS.



CLASS CL_PTF_BO_BUPA_SWITCH_MOCK IMPLEMENTATION.


  method CHANGE.
  endmethod.


  method CHECK.
  endmethod.


  method CHECK_EXISTENCE.
  endmethod.


  method CREATE.
  endmethod.


  method DELETE.
  endmethod.


  METHOD execute_action.

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).


    CASE ls_step_data-action.

      WHEN
        gc_action-mock_on_q2c OR
        gc_action-mock_on_cstmr OR
        gc_action-mock_on_iln OR
        gc_action-mock_on_tax OR
        gc_action-mock_off_q2c OR
        gc_action-mock_off_cstmr OR
        gc_action-mock_off_iln OR
        gc_action-mock_off_tax .

        start_switch_mock(
          EXPORTING iv_action = ls_step_data-action
          IMPORTING ev_execution_status = ev_execution_status ).

        RETURN.

      WHEN gc_action-cleanup.
        FREE MEMORY ID 'CG__PTF_BP_SWITCH'.
        me->mo_run_environment->append_log( iv_log_statement = |Mocking stopped for all BuPA switches.| ).
        ev_execution_status = abap_true.
        RETURN.

      WHEN OTHERS.
        me->mo_run_environment->append_log( iv_log_statement =  |Could not find method { ls_step_data-action } for the BO { ls_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.
    ENDCASE.

  ENDMETHOD.


  method EXECUTE_CHECK.
  endmethod.


  METHOD start_switch_mock.

    DATA lb_current_switch_state TYPE abap_bool.
    DATA lv_switch TYPE sfw_switchid. "sftgl_ft_id.
    DATA lb_target_state TYPE abap_bool.
    DATA lv_state_text TYPE string.


    "set Switch ID, print old state to log

    CASE iv_action.
      WHEN gc_action-mock_on_cstmr OR gc_action-mock_off_cstmr.
        lb_current_switch_state = cl_bupa_multiple_addresses=>if_bupa_multiple_addresses~is_cust_multiple_addr_active( ).
        lv_switch = cl_bupa_multiple_addresses=>if_bupa_multiple_addresses~feature_toggle-bpcustomer_multi_addr.

      WHEN gc_action-mock_on_q2c OR gc_action-mock_off_q2c.
        lb_current_switch_state = cl_bupa_multiple_addresses=>if_bupa_multiple_addresses~is_o2c_multiple_addr_active( ).
        lv_switch = cl_bupa_multiple_addresses=>if_bupa_multiple_addresses~feature_toggle-o2c_multi_bp_addr.  "constant starts with O2C, not with Q2C -  same as CL_BUPA_MULTI_ADDR_4_TEST-define_switch_status.
*                                                                                                            cl_bupa_multiple_addresses=>if_bupa_multiple_addresses~is_o2c_multiple_addr_active would expect Q2C* but is not relevant

      WHEN gc_action-mock_on_iln OR gc_action-mock_off_iln.
        lb_current_switch_state = cl_bupa_multiple_addresses=>if_bupa_multiple_addresses~is_iln_multiple_addr_active( ).
        lv_switch = cl_bupa_multiple_addresses=>if_bupa_multiple_addresses~feature_toggle-bpiln_multi_addr.

      WHEN gc_action-mock_on_tax OR gc_action-mock_off_tax.
        lb_current_switch_state = cl_bupa_multiple_addresses=>if_bupa_multiple_addresses~is_taxnum_multiple_addr_active( ).
        lv_switch = cl_bupa_multiple_addresses=>if_bupa_multiple_addresses~feature_toggle-bptaxnum_multi_addr.

      WHEN OTHERS.
        ASSERT 1 = 2.
    ENDCASE.

    "get target state
    CASE iv_action.
      WHEN gc_action-mock_on_q2c OR
        gc_action-mock_on_cstmr OR
        gc_action-mock_on_iln OR
        gc_action-mock_on_tax .
        lb_target_state = abap_true.
        lv_state_text = 'ON'.
      WHEN gc_action-mock_off_q2c OR
        gc_action-mock_off_cstmr OR
        gc_action-mock_off_iln OR
        gc_action-mock_off_tax .
        lb_target_state = abap_false.
        lv_state_text = 'OFF'.
    ENDCASE.

    IF lb_target_state EQ lb_current_switch_state.
      me->mo_run_environment->append_log( iv_log_statement = |(Note:Switch had already the target state, without mocking.)| ).
    ENDIF.

    IF lb_current_switch_state IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |The Switch state before was OFF.| ).
    ELSE.
      me->mo_run_environment->append_log( iv_log_statement = |The Switch state before was ON.| ).
    ENDIF.



    "inform PTF

    EXPORT v_bp_switch  = lv_switch         "currently only one switch can be mocked at a time
           b_active     = lb_target_state
    TO MEMORY ID 'CG__PTF_BP_SWITCH'.

    me->mo_run_environment->append_log( iv_log_statement = |Starting to mock: Switch { lv_switch } is simulated { lv_state_text }.| ).
    ev_execution_status = abap_true.
    RETURN.


  ENDMETHOD.
ENDCLASS.
