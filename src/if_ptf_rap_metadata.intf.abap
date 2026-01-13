interface IF_PTF_RAP_METADATA
  public .


  methods CHECK_RAP_BO
    importing
      !IV_BUS_OBJ type PTF_BO
    returning
      value(RV_IS_RAP_BO) type ABAP_BOOL .
  methods CHECK_RAP_BO_ACTION
    importing
      !IV_BUS_OBJ type PTF_BO
      !IV_ACTION type PTF_ACT
    returning
      value(RV_IS_RAP_BO_ACTION) type ABAP_BOOL .
  methods CHECK_RAP_BO_BDEF_ACTION
    importing
      !IV_BUS_OBJ type PTF_BO
      !IV_ACTION type PTF_ACT
    returning
      value(RV_IS_RAP_BO_ACTION) type ABAP_BOOL .
  methods CHECK_RAP_BO_CHECK_ACTION
    importing
      !IV_BUS_OBJ type PTF_BO
      !IV_ACTION type PTF_ACT
    returning
      value(RV_RESULT) type ABAP_BOOL .
  methods GET_KEY_FIELDS
    importing
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IV_VIRTUAL type ABAP_BOOL default ABAP_OFF
    returning
      value(RT_COMPONENTS) type ABAP_COMPONENT_TAB .
  methods RECURSIVE_GET_COMPONENTS
    importing
      !IO_STRUCTDESCR type ref to CL_ABAP_STRUCTDESCR
    returning
      value(RT_COMPONENTS) type ABAP_COMPONENT_TAB .
endinterface.
