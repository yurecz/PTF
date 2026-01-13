interface IF_PTF_STEP_SHIFT
  public .


  types:
    begin of enum te_operation,
      insert,
      delete,
    end of enum te_operation .

  methods SHIFT_STEP_IDS_IN_SCRIPT
    importing
      !IV_ROW_NUMBER type INT4
      !IV_OPERATION type TE_OPERATION
    exporting
      !EV_REFERENCE_SHIFTED type ABAP_BOOL
    changing
      !CT_OUTTAB_STEP type CL_PTF_UTIL=>TY_OUTTAB_TAB .
  methods SHIFT_STEP_IDS_IN_TABLE
    importing
      !IV_ROW_NUMBER type INT4
      !IV_E_UCOMM type SYST_UCOMM
    exporting
      !EV_REFERENCE_SHIFTED type ABAP_BOOL
      !EV_ADAPTED_ALV_REFSTEP type ABAP_BOOL
    changing
      !CT_OUTTAB_STEP type CL_PTF_UTIL=>TY_OUTTAB_TAB
      !CT_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP_TAB .
endinterface.
