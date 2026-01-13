interface IF_PTF_BO_SO_DYNAMIC_CODE
  public .


  class-methods DYNAMIC_TEST_DATA_CHANGE
    importing
      !IV_STEP_NUMBER type I
      !IO_PTF_BO type ref to CL_PTF_BO
    exporting
      !EV_IMMEDIATE_EXIT type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
    changing
      !CS_SALESORDER_TEST_DATA type CL_PTF_BO_SO=>TY_GS_I_PTF_SO_CR_TD optional
    returning
      value(RV_EXECUTION_STATUS) type ABAP_BOOL .
  class-methods CUSTOM_DYNAMIC_CHECK
    importing
      !IV_STEP_NUMBER type I
      !IO_PTF_BO type ref to CL_PTF_BO
    exporting
      !EV_IMMEDIATE_EXIT type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
    changing
      !CS_SALESORDER_TEST_DATA type CL_PTF_BO_SO=>TY_GS_SO_CHECK_DATA optional
    returning
      value(RV_CHECK_STATUS) type ABAP_BOOL .
endinterface.
