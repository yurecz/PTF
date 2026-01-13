interface IF_PTF_JSON_REPOSITORY
  public .


  methods CHECK
    importing
      !IV_VARIANT type PTF_TDCV
    returning
      value(RV_JSON_REPOSITORY) type ABAP_BOOL .
  methods LOAD
    importing
      !IV_INPUT_ID type PTF_INPUT_REPO-INPUT_ID
    returning
      value(RS_PTF_INPUT_REPO) type PTF_INPUT_REPO
    raising
      CX_PTF_JSON_REPOSITORY .
  methods SAVE
    importing
      !IV_INPUT_ID type PTF_INPUT_REPO-INPUT_ID
      !IV_BUS_OBJ type PTF_INPUT_REPO-BUS_OBJ
      !IV_ACTION type PTF_INPUT_REPO-ACTION
      !IV_DESCR type PTF_INPUT_REPO-DESCR
      !IV_INPUT_STRING type PTF_INPUT_REPO-INPUT_STRING
      !IV_UPDATE type ABAP_BOOL optional
    raising
      CX_PTF_JSON_REPOSITORY .
  methods DELETE
    importing
      !IV_INPUT_ID type PTF_INPUT_REPO-INPUT_ID
    raising
      CX_PTF_JSON_REPOSITORY .
  methods IS_IN_CUSTOMER_NS
    importing
      !IV_INPUT_ID type PTF_INPUT_REPO-INPUT_ID
    returning
      value(RV_RESULT) type ABAP_BOOL .
  methods IS_MAINTNCE_HERE_ALLOWED_FOR
    importing
      !IV_INPUT_ID type PTF_INPUT_REPO-INPUT_ID
    returning
      value(RV_RESULT) type ABAP_BOOL .
endinterface.
