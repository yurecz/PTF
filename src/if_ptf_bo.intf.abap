interface IF_PTF_BO
  public .


  methods CREATE
    exporting
      !ET_RETURN type CL_PTF_UTIL=>GT_PTF_RETURN_TAB
    changing
      !CS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !CT_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP_TAB .
  methods CHANGE
    exporting
      !ET_RETURN type CL_PTF_UTIL=>GT_PTF_RETURN_TAB
    changing
      !CT_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP_TAB
      !CS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP .
  methods DELETE
    exporting
      !ET_RETURN type CL_PTF_UTIL=>GT_PTF_RETURN_TAB
    changing
      !CT_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP_TAB
      !CS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP .
  methods CHECK
    exporting
      !ET_RETURN type CL_PTF_UTIL=>GT_PTF_RETURN_TAB
    changing
      !CT_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP_TAB
      !CS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP .
  methods EXECUTE_ACTION
    exporting
      !ET_RETURN type CL_PTF_UTIL=>GT_PTF_RETURN_TAB
    changing
      !CT_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP_TAB
      !CS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP .
  methods EXECUTE_CHECK
    exporting
      !ET_RETURN type CL_PTF_UTIL=>GT_PTF_RETURN_TAB
    changing
      !CT_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP_TAB
      !CS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP .
endinterface.
