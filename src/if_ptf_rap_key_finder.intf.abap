interface IF_PTF_RAP_KEY_FINDER
  public .


  methods FIND_KEYS
    importing
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IV_ACTION type CL_ABAP_BEHVDESCR=>T_SUB_NAME
    exporting
      !EV_ERROR type ABAP_BOOL
    changing
      !CR_TEST_DATA type ref to DATA .
endinterface.
