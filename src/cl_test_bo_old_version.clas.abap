CLASS cl_test_bo_old_version DEFINITION
  PUBLIC
  INHERITING FROM cl_ptf_template
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_ptf_bo .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS CL_TEST_BO_OLD_VERSION IMPLEMENTATION.


  METHOD if_ptf_bo~change.

  ENDMETHOD.


  METHOD if_ptf_bo~check.

  ENDMETHOD.


  METHOD if_ptf_bo~create.
    DATA: ls_return             TYPE bapiret2.
    cs_step_data-check_status = abap_true.
    cs_step_data-execution_status = abap_true.
    APPEND '0123456789012345678901234567890123456789012345678901234567890123456789' TO cs_step_data-document_id.
    CONCATENATE 'Here some log: ' sy-datum INTO ls_return-message SEPARATED BY space.
    APPEND ls_return TO et_return.
  ENDMETHOD.


  METHOD if_ptf_bo~delete.

  ENDMETHOD.


  METHOD if_ptf_bo~execute_action.

  ENDMETHOD.


  METHOD if_ptf_bo~execute_check.

  ENDMETHOD.
ENDCLASS.
