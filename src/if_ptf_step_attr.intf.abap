interface IF_PTF_STEP_ATTR
  public .


  methods SET_TDC_ERROR
    importing
      !IV_ERROR_FLAG type ABAP_BOOLEAN .
  methods HAS_TDC_ERROR
    returning
      value(RV_RESULT) type ABAP_BOOLEAN .
  methods SET_SUBSTITUTED_TDC_NAME
    importing
      !IV_SUBSTITUTED_TDC_NAME type ETOBJ_NAME .
  methods GET_SUBSTITUTED_TDC_NAME
    returning
      value(RV_RESULT) type ETOBJ_NAME .
  methods SET_STOP_RUN_AFTER_STEP
    importing
      !IV_FLAG type ABAP_BOOLEAN .
  methods HAS_TO_STOP_RUN_AFTER_STEP
    returning
      value(RV_RESULT) type ABAP_BOOLEAN .
  methods ADD_ACTUAL_MESSAGES
    importing
      !IT_MESSAGES type PTF_T100_MESSAGE_T .
  methods GET_ACTUAL_MESSAGES
    returning
      value(RT_RESULT) type PTF_T100_MESSAGE_T .
  methods SET_TDO
    importing
      !IV_DATA_OBJECT_JSON type STRING .
  methods GET_TDO
    returning
      value(RV_RESULT) type STRING .
  methods SET_PID_INDICATOR
    importing
      !IV_IS_PID type ABAP_BOOLEAN .
  methods GET_PID_INDICATOR
    returning
      value(RV_RESULT) type ABAP_BOOLEAN .
endinterface.
