interface IF_PTF_RAP_JSON_REF_PARSER
  public .


  types:
    begin of enum te_operation,
      insert,
      delete,
    end of enum te_operation .

  methods PARSE_REFERENCES
    importing
      !IV_ENTITY_NAME type ABP_ENTITY_NAME
      !IV_STEP_NUMBER type I
      !IV_PARAM type ABAP_BOOL default ABAP_OFF
    exporting
      !EV_ERROR type ABAP_BOOL
    changing
      !CS_TEST_DATA type DATA .
  methods PARSE_REFERENCE
    importing
      !IV_ENTITY_NAME type ABP_ENTITY_NAME
      !IV_NAME type STRING
      !IV_STEP_NUMBER type I
      !IV_PARAM type ABAP_BOOL default ABAP_OFF
    exporting
      !EV_ERROR type ABAP_BOOL
    changing
      !CV_VALUE type ANY .
endinterface.
