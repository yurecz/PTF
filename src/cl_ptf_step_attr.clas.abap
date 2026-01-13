CLASS cl_ptf_step_attr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_ptf_step_attr .

    CLASS-DATA sv_au_session TYPE abap_boolean .

    CLASS-METHODS get_instance
      RETURNING
        VALUE(ro_instance) TYPE REF TO cl_ptf_step_attr .
    CLASS-METHODS delete_singleton .
  PROTECTED SECTION.
private section.

  class-data SO_INSTANCE type ref to CL_PTF_STEP_ATTR .
  data MV_TDC_PROBLEM type ABAP_BOOLEAN .
  data MV_SUBSTITUTED_TDC_NAME type ETOBJ_NAME .
  data MV_STOP_RUN_AFTER_STEP type ABAP_BOOLEAN .
  data MT_ACTUAL_MESSAGES type PTF_T100_MESSAGE_T .
  data MV_DATA_OBJECT_JSON type STRING .
  data MV_IS_PID type ABAP_BOOLEAN .
ENDCLASS.



CLASS CL_PTF_STEP_ATTR IMPLEMENTATION.


  METHOD delete_singleton.

    CLEAR so_instance.

  ENDMETHOD.


  METHOD get_instance.

    IF so_instance IS INITIAL.
      so_instance = NEW cl_ptf_step_attr( ).
    ENDIF.

    ro_instance = so_instance.

  ENDMETHOD.


  METHOD if_ptf_step_attr~add_actual_messages.

    APPEND LINES OF it_messages TO mt_actual_messages.

  ENDMETHOD.


  METHOD if_ptf_step_attr~get_actual_messages.

    rt_result = mt_actual_messages.

  ENDMETHOD.


  METHOD if_ptf_step_attr~get_pid_indicator.

    rv_result = mv_is_pid.

  ENDMETHOD.


  METHOD if_ptf_step_attr~get_substituted_tdc_name.

    rv_result = mv_substituted_tdc_name.

  ENDMETHOD.


  METHOD if_ptf_step_attr~get_tdo.

    rv_result = mv_data_object_json.

  ENDMETHOD.


  METHOD if_ptf_step_attr~has_tdc_error.

    rv_result = mv_tdc_problem.

  ENDMETHOD.


  METHOD if_ptf_step_attr~has_to_stop_run_after_step.

    rv_result = mv_stop_run_after_step.

  ENDMETHOD.


  METHOD if_ptf_step_attr~set_pid_indicator.

    mv_is_pid = iv_is_pid.

  ENDMETHOD.


  METHOD if_ptf_step_attr~set_stop_run_after_step.

    mv_stop_run_after_step = iv_flag.

  ENDMETHOD.


  METHOD if_ptf_step_attr~set_substituted_tdc_name.


    mv_substituted_tdc_name = iv_substituted_tdc_name.

  ENDMETHOD.


  METHOD if_ptf_step_attr~set_tdc_error.

    mv_tdc_problem = iv_error_flag.

  ENDMETHOD.


  METHOD if_ptf_step_attr~set_tdo.

    mv_data_object_json = iv_data_object_json.

  ENDMETHOD.
ENDCLASS.
