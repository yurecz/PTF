*"* use this source file for your ABAP unit test classes

CLASS lcl_Ptf_Xml_Result_Test DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
.
*?﻿<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
*?<asx:values>
*?<TESTCLASS_OPTIONS>
*?<TEST_CLASS>lcl_Ptf_Xml_Result_Test
*?</TEST_CLASS>
*?<TEST_MEMBER>f_Cut
*?</TEST_MEMBER>
*?<OBJECT_UNDER_TEST>CL_PTF_XML_RESULT
*?</OBJECT_UNDER_TEST>
*?<OBJECT_IS_LOCAL/>
*?<GENERATE_FIXTURE>X
*?</GENERATE_FIXTURE>
*?<GENERATE_CLASS_FIXTURE>X
*?</GENERATE_CLASS_FIXTURE>
*?<GENERATE_INVOCATION>X
*?</GENERATE_INVOCATION>
*?<GENERATE_ASSERT_EQUAL>X
*?</GENERATE_ASSERT_EQUAL>
*?</TESTCLASS_OPTIONS>
*?</asx:values>
*?</asx:abap>
  PRIVATE SECTION.
    DATA:
      f_Cut TYPE REF TO cl_Ptf_Xml_Result.  "class under test
    CLASS-METHODS: class_Setup.
    CLASS-METHODS: class_Teardown.
    METHODS: setup.
    METHODS: teardown.
    METHODS: get_Xml_Result FOR TESTING.
ENDCLASS.       "lcl_Ptf_Xml_Result_Test


CLASS lcl_Ptf_Xml_Result_Test IMPLEMENTATION.

  METHOD class_Setup.



  ENDMETHOD.


  METHOD class_Teardown.



  ENDMETHOD.


  METHOD setup.


    CREATE OBJECT f_Cut.
  ENDMETHOD.


  METHOD teardown.



  ENDMETHOD.


  METHOD get_Xml_Result.
    DATA: step_Data TYPE cl_Ptf_Util=>gt_Ptf_Step_Tab,
          results   TYPE cl_ptf_util=>ty_vbeln_tab,
          logs      TYPE cl_ptf_util=>gt_ptf_return_tab.

    APPEND '0090000000' TO results.
    APPEND VALUE #( message = 'Hello World.' ) TO logs.
    APPEND VALUE #( step_number = 1 bus_obj = 'Homer' action = 'Simpson' document_id = results log = logs ) TO step_data.
    CLEAR results.
    CLEAR logs.

    APPEND '0090000000' TO results.
    APPEND '0090000001' TO results.
    APPEND VALUE #( message = 'Hello World.' ) TO logs.
    APPEND VALUE #( message = 'Hello World.' ) TO logs.
    APPEND VALUE #( step_number = 2 bus_obj = 'Homer' action = 'Simpson' document_id = results log = logs ) TO step_data.
    CLEAR results.
    CLEAR logs.

    APPEND '0090000000' TO results.
    APPEND '0090000001' TO results.
    APPEND VALUE #( step_number = 3 bus_obj = 'Homer' action = 'Simpson' document_id = results log = logs ) TO step_data.
    CLEAR results.
    CLEAR logs.

    APPEND VALUE #( message = 'Hello World.' ) TO logs.
    APPEND VALUE #( message = 'Hello World.' ) TO logs.
    APPEND VALUE #( step_number = 4 bus_obj = 'Homer' action = 'Simpson' document_id = results log = logs ) TO step_data.
    CLEAR results.
    CLEAR logs.

    APPEND VALUE #( step_number = 5 bus_obj = '' action = '' document_id = results log = logs ) TO step_data.

    DATA(actual_result) = cl_Ptf_Xml_Result=>get_Xml_Result( step_Data ).

    "Build expected result
    DATA(expected_result) = |<ptfExecutionResult>|.
    "Add step1 result
    expected_result = |{ expected_result }<stepResult><stepNumber>1</stepNumber><log><logEntry>Hello World.</logEntry></log><results><stepResult>0090000000</stepResult></results></stepResult>|.
    "Add step2 result
    expected_result = |{ expected_result }<stepResult><stepNumber>2</stepNumber><log><logEntry>Hello World.</logEntry><logEntry>Hello World.</logEntry></log>|.
    expected_result = |{ expected_result }<results><stepResult>0090000000</stepResult><stepResult>0090000001</stepResult></results></stepResult>|.
    "Add step3 result
    expected_result = |{ expected_result }<stepResult><stepNumber>3</stepNumber><log></log><results><stepResult>0090000000</stepResult><stepResult>0090000001</stepResult></results></stepResult>|.
    "Add step4 result
    expected_result = |{ expected_result }<stepResult><stepNumber>4</stepNumber><log><logEntry>Hello World.</logEntry><logEntry>Hello World.</logEntry></log><results></results></stepResult>|.
    "End result string
    expected_result = |{ expected_result }</ptfExecutionResult>|.

    cl_Abap_Unit_Assert=>assert_Equals(
      act   = actual_result
      exp   = expected_result
    ).
  ENDMETHOD.




ENDCLASS.
