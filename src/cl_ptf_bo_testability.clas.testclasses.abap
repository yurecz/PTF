*"* use this source file for your ABAP unit test classes
CLASS lcl_ptf_bo_testability_test DEFINITION DEFERRED.
CLASS cl_ptf_bo_testability DEFINITION LOCAL FRIENDS lcl_ptf_bo_testability_test.

CLASS lcl_ptf_bo_testability_test DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
.
*?﻿<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
*?<asx:values>
*?<TESTCLASS_OPTIONS>
*?<TEST_CLASS>lcl_Ptf_Bo_Testability_Test
*?</TEST_CLASS>
*?<TEST_MEMBER>f_Cut
*?</TEST_MEMBER>
*?<OBJECT_UNDER_TEST>CL_PTF_BO_TESTABILITY
*?</OBJECT_UNDER_TEST>
*?<OBJECT_IS_LOCAL/>
*?<GENERATE_FIXTURE/>
*?<GENERATE_CLASS_FIXTURE/>
*?<GENERATE_INVOCATION/>
*?<GENERATE_ASSERT_EQUAL/>
*?</TESTCLASS_OPTIONS>
*?</asx:values>
*?</asx:abap>
  PRIVATE SECTION.
    DATA:
      f_cut TYPE REF TO cl_ptf_bo_testability.  "class under test

    METHODS: create FOR TESTING.
ENDCLASS.       "lcl_Ptf_Bo_Testability_Test


CLASS lcl_ptf_bo_testability_test IMPLEMENTATION.

  METHOD create.
    DATA: environment TYPE REF TO cl_ptf_run.
    DATA: steps TYPE cl_ptf_util=>gt_ptf_step_tab.
    DATA: ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab.
    DATA: ev_execution_status TYPE abap_bool.
    DATA: ev_check_status     TYPE abap_bool .
    DATA: ebdr_request TYPE bapiebdrrequest.

    environment = NEW cl_ptf_run( it_ptf_steps = steps ).
    f_cut = NEW cl_ptf_bo_testability( iv_run_environment = environment ).
    DATA(bo_dao) = NEW lcl_ptf_bo_api_test_dao_impl( ).
    bo_dao->test_case = 1.
    DATA(ptf_dao) = NEW lcl_ptf_def_act_test_dao_impl( ).

    ebdr_request-precedingdocumentitem = '000001'.
    ebdr_request-precedingdocumenttype = 'DMRR'.
    ebdr_request-precedingdocumentitemcategory = 'DMR'.
    ebdr_request-extbillingdocrequesttype = 'BDR1'.
    ebdr_request-salesorganization = '0001'.
    ebdr_request-distributionchannel = '01'.
    ebdr_request-division = '01'.
    ebdr_request-soldtoparty = 'MY_CUST_01'.
    ebdr_request-transactioncurrency = 'EUR'.
    ebdr_request-material = 'ATP_AK_108'.
    ebdr_request-quantity = '3'.
    ebdr_request-plant = '0001'.
    ebdr_request-departurecountry = 'UA'.

    APPEND ebdr_request TO ptf_dao->test_data_to_return-ebdr_request_in.

    f_cut->ptf_dao = ptf_dao.
    f_cut->bo_dao = bo_dao.

    f_cut->create(
      EXPORTING
        iv_step_number      = 800
      IMPORTING
        ev_document_id      = ev_document_id
        ev_execution_status = ev_execution_status
        ev_check_status     = ev_check_status
    ).

  ENDMETHOD.




ENDCLASS.
