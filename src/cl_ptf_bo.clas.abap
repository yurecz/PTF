class CL_PTF_BO definition
  public
  abstract
  create public .

public section.

  data MO_RUN_ENVIRONMENT type ref to CL_PTF_RUN read-only .   "Needs to be public cause abap has no final for protected or private attributes

  class-methods IS_NEW_VERSION
    returning
      value(RV_IS_NEW_VERSION) type ABAP_BOOL .
  methods CONSTRUCTOR
    importing
      !IV_RUN_ENVIRONMENT type ref to CL_PTF_RUN .
  methods CREATE
  abstract
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHANGE
  abstract
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods DELETE
  abstract
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK
  abstract
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods EXECUTE_ACTION
  abstract
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods EXECUTE_CHECK
  abstract
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_EXISTENCE
  abstract
    importing
      !IV_ID type PTFKEY
    returning
      value(RV_EXISTS) type ABAP_BOOL .
  PROTECTED SECTION.


private section.
ENDCLASS.



CLASS CL_PTF_BO IMPLEMENTATION.


  METHOD constructor.
    me->mo_run_environment = iv_run_environment.
  ENDMETHOD.


  METHOD is_new_version.
    rv_is_new_version = abap_true.
  ENDMETHOD.
ENDCLASS.
