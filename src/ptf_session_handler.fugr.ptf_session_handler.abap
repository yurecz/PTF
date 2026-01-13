FUNCTION ptf_session_handler.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     VALUE(LT_RETURN) TYPE  I
*"  CHANGING
*"     VALUE(LT_STEP_DATA) TYPE  I OPTIONAL
*"     VALUE(LS_STEP_DATA) TYPE  I OPTIONAL
*"----------------------------------------------------------------------

**  DATA: lv_step   TYPE string,
**        lv_action TYPE ptf_act.
**
**  CHECK 1 = 1.
**
**  DATA environment TYPE REF TO  if_osql_test_environment.
**  "environment = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'VBRK' )  ) ). "The reference to a test class (identified by FOR TESTING) is only possible in test classes.
**
**  CHECK 1 = 1.

*   DATA lr_bo TYPE REF TO object.
*      cl_ptf_util=>do_preperation(
*          CHANGING
*           is_step_data = ls_step_data
*           it_step_data = lt_step_data
*           it_return    = lt_return
*         RECEIVING
*           rt_parameter = DATA(lt_parameter) ).
*      lv_step = ls_step_data-var_step.
*      CONCATENATE 'Step ' lv_step ':' INTO DATA(lv_step_number).
*      APPEND VALUE #( id = lv_step_number message = '************************************' ) TO lt_return.
*      CONCATENATE  'CL_PTF_BO_' ls_step_data-bus_obj INTO DATA(lv_object).
*      CREATE OBJECT lr_bo TYPE (lv_object).
*
*      IF ls_step_data-action EQ 'CREATE' OR ls_step_data-action EQ 'CHANGE' OR ls_step_data-action EQ 'DELETE' OR
*         ls_step_data-action EQ 'CHECK'.
*        CONCATENATE 'IF_PTF_BO~' ls_step_data-action INTO lv_action.
*      ELSE.
*        IF ls_step_data-check_flag IS NOT INITIAL.
*          CONCATENATE 'IF_PTF_BO~' 'EXECUTE_CHECK' INTO lv_action.
*        ELSE.
*          CONCATENATE 'IF_PTF_BO~' 'EXECUTE_ACTION' INTO lv_action.
*        ENDIF.
*      ENDIF.
*      CALL METHOD lr_bo->(lv_action)
*        PARAMETER-TABLE
*        lt_parameter.

ENDFUNCTION.
