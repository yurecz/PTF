interface IF_PTF_VARDATASET
  public .


  methods CHECK
    importing
      !IV_VARNAME type PTF_VARDATASET-VARNAME
      !IV_DATASET_ID type PTF_VARDATASET-DATASET_ID optional
      !IV_VARIABLE_NAME type PTF_VARDATASET-VARIABLE_NAME optional
    returning
      value(RV_VARDATASET) type ABAP_BOOL .
  methods LOAD
    importing
      !IV_VARNAME type PTF_VARDATASET-VARNAME
    returning
      value(RT_PTF_VARDATASET) type PTF_VARDATASET_T
    raising
      CX_PTF_VARDATASET .
  methods LOAD_SINGLE
    importing
      !IV_VARNAME type PTF_VARDATASET-VARNAME
      !IV_DATASET_ID type PTF_VARDATASET-DATASET_ID
      !IV_VARIABLE_NAME type PTF_VARDATASET-VARIABLE_NAME
    returning
      value(RS_PTF_VARDATASET) type PTF_VARDATASET
    raising
      CX_PTF_VARDATASET .
  methods SAVE
    importing
      !IT_PTF_VARDATASET type PTF_VARDATASET_T
    raising
      CX_PTF_VARDATASET .
  methods DELETE
    importing
      !IV_VARNAME type PTF_VARDATASET-VARNAME
    raising
      CX_PTF_VARDATASET .
  methods IS_IN_CUSTOMER_NS
    importing
      !IV_VARNAME type PTF_VARDATASET-VARNAME
    returning
      value(RV_RESULT) type ABAP_BOOL .
  methods IS_MAINTNCE_HERE_ALLOWED_FOR
    importing
      !IV_VARNAME type PTF_VARDATASET-VARNAME
    returning
      value(RV_RESULT) type ABAP_BOOL .
endinterface.
