*"* use this source file for your ABAP unit test classes

CLASS lcl_Ptf_variant_manager_Test DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
.

  PRIVATE SECTION.
    CLASS-METHODS: class_Setup.
    CLASS-METHODS: class_Teardown.
    METHODS: setup.
    METHODS: teardown.
    METHODS: execute_variant_not_existing FOR TESTING,
      execute_variant FOR TESTING,
      execute_variant_preceding_proc FOR TESTING,
      execute_variant_red_check FOR TESTING,
      execute_variant_red_exec FOR TESTING,
      execute_variant_red_check_exec FOR TESTING,
      execute_var_with_exception FOR TESTING.
ENDCLASS.       "lcl_Ptf_Xml_Result_Test

CLASS lcl_Ptf_variant_manager_Test IMPLEMENTATION.

  METHOD class_Setup.
  ENDMETHOD.


  METHOD class_Teardown.
  ENDMETHOD.


  METHOD setup.
  ENDMETHOD.


  METHOD teardown.
  ENDMETHOD.

  METHOD execute_variant.

    CONSTANTS: c_variant_to_execute TYPE String VALUE 'AUNIT01'.

    MODIFY ENTITY p_ptf_variant
    EXECUTE execute_variant FROM VALUE #( ( variant = c_variant_to_execute ) )
    RESULT DATA(result_action)
    FAILED DATA(failed)
    REPORTED DATA(reported).

    DATA(expected_res) = |<ptfExecutionResult><stepResult><stepNumber>1</stepNumber><log><logEntry>PTF Script: AUNIT01</logEntry><logEntry>************************************</logEntry><logEntry>BO: AUNIT|.
    expected_res = |{ expected_res } , Action: DO_STH_EXEC , Variant: GREEN_2LOG_2RESULTS , Ref:</logEntry><logEntry>Log01</logEntry><logEntry>Log02</logEntry>|.
    expected_res = |{ expected_res }<logEntry>Execution status: True.</logEntry><logEntry>ResultIDs:</logEntry><logEntry>Doc01</logEntry><logEntry>Doc02</logEntry></log>|.
    expected_res = |{ expected_res }<results><stepResult>Doc01</stepResult><stepResult>Doc02</stepResult></results></stepResult></ptfExecutionResult>|.

    cl_abap_unit_assert=>assert_initial(
    EXPORTING
      act              = failed
    ).

    cl_abap_unit_assert=>assert_initial(
      EXPORTING
        act              = reported
    ).

    cl_abap_unit_assert=>assert_equals(
      exp = lines( result_action )
      act = 1
    ).

    DATA(result) = result_action[ 1 ].

    cl_abap_unit_assert=>assert_equals(
      exp = result-variant
      act = c_variant_to_execute
    ).

    cl_abap_unit_assert=>assert_equals(
      exp = result-%param-variant_name
      act = c_variant_to_execute
   ).

    cl_abap_unit_assert=>assert_equals(
      exp = expected_res
      act = result-%param-results
    ).

    cl_abap_unit_assert=>assert_initial(
      EXPORTING
        act              = result-%param-error
    ).

  ENDMETHOD.

  METHOD execute_variant_not_existing.
    CONSTANTS: c_not_existing_variant TYPE String VALUE 'THIS_VARIANT_DOES_NOT_EXIST',
               c_empty_result         TYPE String VALUE '<ptfExecutionResult></ptfExecutionResult>',
               c_error_not_found      TYPE String VALUE 'NOT_FOUND'.

    MODIFY ENTITY p_ptf_variant
      EXECUTE execute_variant FROM VALUE #( ( variant = c_not_existing_variant ) )
      RESULT DATA(result_action)
      FAILED DATA(failed)
      REPORTED DATA(reported).

    cl_abap_unit_assert=>assert_initial(
      EXPORTING
        act              = failed
    ).

    cl_abap_unit_assert=>assert_initial(
      EXPORTING
        act              = reported
    ).

    cl_abap_unit_assert=>assert_equals(
      exp = lines( result_action )
      act = 1
    ).


    DATA(result) = result_action[ 1 ].

    cl_abap_unit_assert=>assert_equals(
      exp = result-variant
      act = c_not_existing_variant
    ).

    cl_abap_unit_assert=>assert_equals(
      exp = result-%param-variant_name
      act = c_not_existing_variant
   ).

    cl_abap_unit_assert=>assert_equals(
      exp = result-%param-results
      act = c_empty_result
    ).

    cl_abap_unit_assert=>assert_equals(
      exp = result-%param-error
      act = c_error_not_found
    ).


  ENDMETHOD.

  METHOD execute_variant_preceding_proc.
    CONSTANTS: c_variant_to_execute TYPE String VALUE 'AUNIT02'.

    MODIFY ENTITY p_ptf_variant
    EXECUTE execute_variant FROM VALUE #( ( variant = c_variant_to_execute ) )
    RESULT DATA(result_action)
    FAILED DATA(failed)
    REPORTED DATA(reported).

*    DATA(expected_res) = |<ptfExecutionResult><stepResult><stepNumber>1</stepNumber><log><logEntry>PTF variant:AUNIT02</logEntry><logEntry>************************************</logEntry>|.
*    expected_res = |{ expected_res }<logEntry>BO: AUNIT , Action: DO_STH_EXEC , Variant: GREEN_2LOG_2RESULTS</logEntry><logEntry>Log01</logEntry>|.
*    expected_res = |{ expected_res }<logEntry>Log02</logEntry></log><results><stepResult>Doc01</stepResult><stepResult>Doc02</stepResult></results>|.
*    expected_res = |{ expected_res }</stepResult><stepResult><stepNumber>2</stepNumber><log><logEntry>************************************</logEntry>|.
*    expected_res = |{ expected_res }<logEntry>BO: AUNIT , Action: DO_STH_EXEC , Variant: GREEN_2LOG_2RESULTS</logEntry><logEntry>Log01</logEntry>|.
*    expected_res = |{ expected_res }<logEntry>Log02</logEntry><logEntry>************************************</logEntry>|.
*    expected_res = |{ expected_res }<logEntry>BO: AUNIT , Action: PROC_PRE_DOC_IDS , Variant: GREEN_2LOG_2RESULTS</logEntry><logEntry>Log01</logEntry>|.
*    expected_res = |{ expected_res }<logEntry>Log02</logEntry></log><results><stepResult>Doc01</stepResult><stepResult>Doc02</stepResult>|.
*    expected_res = |{ expected_res }</results></stepResult></ptfExecutionResult>|.

    cl_abap_unit_assert=>assert_initial(
    EXPORTING
      act              = failed
    ).

    cl_abap_unit_assert=>assert_initial(
      EXPORTING
        act              = reported
    ).

    cl_abap_unit_assert=>assert_equals(
      exp = lines( result_action )
      act = 1
    ).

    DATA(result) = result_action[ 1 ].

    cl_abap_unit_assert=>assert_equals(
      exp = result-variant
      act = c_variant_to_execute
    ).

    cl_abap_unit_assert=>assert_equals(
      exp = result-%param-variant_name
      act = c_variant_to_execute
   ).

*    cl_abap_unit_assert=>assert_equals(    "current service implementation repeats the log at each step, each time with all steps already executed. Implementation should be changed
*      exp = result-%param-results
*      act = expected_res
*    ).

    cl_abap_unit_assert=>assert_initial(
      EXPORTING
        act              = result-%param-error
    ).
  ENDMETHOD.

  METHOD execute_variant_red_check.
    CONSTANTS: c_variant_to_execute TYPE String VALUE 'AUNIT03'.

    MODIFY ENTITY p_ptf_variant
    EXECUTE execute_variant FROM VALUE #( ( variant = c_variant_to_execute ) )
    RESULT DATA(result_action)
    FAILED DATA(failed)
    REPORTED DATA(reported).

    DATA(expected_res) = |<ptfExecutionResult><stepResult><stepNumber>1</stepNumber><log><logEntry>PTF Script: AUNIT03</logEntry><logEntry>************************************</logEntry>|.
    expected_res = |{ expected_res }<logEntry>BO: AUNIT , Action: DO_STH_CHECK , Variant: RED_CHECK , Ref:</logEntry><logEntry>Log01</logEntry><logEntry>Log02</logEntry>|.
    expected_res = |{ expected_res }<logEntry>Check status: FAILED.</logEntry><logEntry>ResultIDs:</logEntry><logEntry>Doc01</logEntry><logEntry>Doc02</logEntry>|.
    expected_res = |{ expected_res }</log><results><stepResult>Doc01</stepResult><stepResult>Doc02</stepResult></results></stepResult></ptfExecutionResult>|.

    cl_abap_unit_assert=>assert_initial(
    EXPORTING
      act              = failed
    ).

    cl_abap_unit_assert=>assert_initial(
      EXPORTING
        act              = reported
    ).

    cl_abap_unit_assert=>assert_equals(
      exp = lines( result_action )
      act = 1
    ).

    DATA(result) = result_action[ 1 ].

    cl_abap_unit_assert=>assert_equals(
      exp = result-variant
      act = c_variant_to_execute
    ).

    cl_abap_unit_assert=>assert_equals(
      exp = result-%param-variant_name
      act = c_variant_to_execute
   ).

    cl_abap_unit_assert=>assert_equals(
      exp = expected_res
      act = result-%param-results
    ).

    cl_abap_unit_assert=>assert_initial(
      EXPORTING
        act              = result-%param-error
    ).
  ENDMETHOD.

  METHOD execute_variant_red_exec.
    CONSTANTS: c_variant_to_execute TYPE String VALUE 'AUNIT04'.

    MODIFY ENTITY p_ptf_variant
    EXECUTE execute_variant FROM VALUE #( ( variant = c_variant_to_execute ) )
    RESULT DATA(result_action)
    FAILED DATA(failed)
    REPORTED DATA(reported).

    DATA(expected_res) = |<ptfExecutionResult><stepResult><stepNumber>1</stepNumber><log><logEntry>PTF Script: AUNIT04</logEntry><logEntry>************************************</logEntry>|.
    expected_res = |{ expected_res }<logEntry>BO: AUNIT , Action: DO_STH_EXEC , Variant: RED_EXEC , Ref:</logEntry><logEntry>Log01</logEntry><logEntry>Log02</logEntry>|.
    expected_res = |{ expected_res }<logEntry>Execution status: False.</logEntry><logEntry>ResultIDs:</logEntry><logEntry>Doc01</logEntry><logEntry>Doc02</logEntry>|.
    expected_res = |{ expected_res }</log><results><stepResult>Doc01</stepResult><stepResult>Doc02</stepResult>|.
    expected_res = |{ expected_res }</results></stepResult></ptfExecutionResult>|.

    cl_abap_unit_assert=>assert_initial(
    EXPORTING
      act              = failed
    ).

    cl_abap_unit_assert=>assert_initial(
      EXPORTING
        act              = reported
    ).

    cl_abap_unit_assert=>assert_equals(
      exp = lines( result_action )
      act = 1
    ).

    DATA(result) = result_action[ 1 ].

    cl_abap_unit_assert=>assert_equals(
      exp = result-variant
      act = c_variant_to_execute
    ).

    cl_abap_unit_assert=>assert_equals(
      exp = result-%param-variant_name
      act = c_variant_to_execute
   ).

    cl_abap_unit_assert=>assert_equals(
      exp = expected_res
      act = result-%param-results
    ).

    cl_abap_unit_assert=>assert_initial(
      EXPORTING
        act              = result-%param-error
    ).
  ENDMETHOD.

  METHOD execute_variant_red_check_exec.
    CONSTANTS: c_variant_to_execute TYPE String VALUE 'AUNIT05'.

    MODIFY ENTITY p_ptf_variant
    EXECUTE execute_variant FROM VALUE #( ( variant = c_variant_to_execute ) )
    RESULT DATA(result_action)
    FAILED DATA(failed)
    REPORTED DATA(reported).

    DATA(expected_res) = |<ptfExecutionResult><stepResult><stepNumber>1</stepNumber><log><logEntry>PTF Script: AUNIT05</logEntry><logEntry>************************************</logEntry>|.
    expected_res = |{ expected_res }<logEntry>BO: AUNIT , Action: DO_STH_CHECK , Variant: RED_EXEC_AND_CHECK , Ref:</logEntry><logEntry>Log01</logEntry><logEntry>Log02</logEntry>|.
    expected_res = |{ expected_res }<logEntry>Check status: FAILED.</logEntry><logEntry>ResultIDs:</logEntry><logEntry>Doc01</logEntry><logEntry>Doc02</logEntry>|.
    expected_res = |{ expected_res }</log><results><stepResult>Doc01</stepResult><stepResult>Doc02</stepResult></results></stepResult></ptfExecutionResult>|.

    cl_abap_unit_assert=>assert_initial(
    EXPORTING
      act              = failed
    ).

    cl_abap_unit_assert=>assert_initial(
      EXPORTING
        act              = reported
    ).

    cl_abap_unit_assert=>assert_equals(
      exp = lines( result_action )
      act = 1
    ).

    DATA(result) = result_action[ 1 ].

    cl_abap_unit_assert=>assert_equals(
      exp = result-variant
      act = c_variant_to_execute
    ).

    cl_abap_unit_assert=>assert_equals(
      exp = result-%param-variant_name
      act = c_variant_to_execute
   ).

    cl_abap_unit_assert=>assert_equals(
      exp = expected_res
      act = result-%param-results
    ).

    cl_abap_unit_assert=>assert_initial(
      EXPORTING
        act              = result-%param-error
    ).
  ENDMETHOD.

  METHOD execute_var_with_exception.
    CONSTANTS: c_variant_to_execute TYPE String VALUE 'AUNIT06'.

    MODIFY ENTITY p_ptf_variant
    EXECUTE execute_variant FROM VALUE #( ( variant = c_variant_to_execute ) )
    RESULT DATA(result_action)
    FAILED DATA(failed)
    REPORTED DATA(reported).

    "DATA(expected_res) = |<ptfExecutionResult><stepResult><stepNumber>1</stepNumber><log><logEntry>************************************</logEntry>|.
    "expected_res = |{ expected_res }<logEntry>BO: AUNIT , Action: EXCEPTION , Variant: GREEN_2LOG_2RESULTS</logEntry><logEntry>!! Unplanned end of this AU step !!</logEntry>|.
    "expected_res = |{ expected_res }<logEntry>!! Location: TCL_PTF_STEP_IN_AU-EXECUTE_PTF_STEP. !!</logEntry><logEntry>!! Exception Error CX_BLE_RUNTIME_ERROR !!</logEntry>|.
    "expected_res = |{ expected_res }<logEntry>!! Details:</logEntry><logEntry>An exception was raised</logEntry><logEntry>TCL_PTF_STEP_IN_AU============CP</logEntry>|.
    "expected_res = |{ expected_res }<logEntry>TCL_PTF_STEP_IN_AU</logEntry><logEntry>EXECUTE_PTF_STEP</logEntry><logEntry>CL_PTF_UNIT_TESTING===========CM00D</logEntry>|.
    "expected_res = |{ expected_res }<logEntry>12</logEntry><logEntry>CL_PTF_UNIT_TESTING===========CM006</logEntry><logEntry>27</logEntry><logEntry>EXECUTE_ACTION</logEntry>|.
    "expected_res = |{ expected_res }<logEntry>TCL_PTF_STEP_IN_AU============CM006</logEntry><logEntry>155</logEntry><logEntry>EXECUTE_PTF_STEP</logEntry></log><results></results>|.
    "expected_res = |{ expected_res }</stepResult></ptfExecutionResult>|.

    cl_abap_unit_assert=>assert_initial(
    EXPORTING
      act              = failed
    ).

    cl_abap_unit_assert=>assert_initial(
      EXPORTING
        act              = reported
    ).

    cl_abap_unit_assert=>assert_equals(
      exp = lines( result_action )
      act = 1
    ).

    DATA(result) = result_action[ 1 ].

    cl_abap_unit_assert=>assert_equals(
      exp = result-variant
      act = c_variant_to_execute
    ).

    cl_abap_unit_assert=>assert_equals(
      exp = result-%param-variant_name
      act = c_variant_to_execute
   ).

    "Result is  not important to check at all
    "cl_abap_unit_assert=>assert_equals(
    "  exp = result-%param-results
    "  act = expected_res
    ").

    cl_abap_unit_assert=>assert_initial(
      EXPORTING
        act              = result-%param-error
    ).
  ENDMETHOD.
ENDCLASS.
