interface IF_PTF_RAP_VALIDATE_TDO
  public .


  types:
    BEGIN OF ENUM te_context,
           key_finder,
           permissions,
           operations,
           checks,
           filters,
         END OF ENUM te_context .
  types:
    BEGIN OF TS_FLAG_CONTROL_ISSUES,
          e_is_mandatory    TYPE abap_bool,
          w_use_initial     TYPE abap_bool,
          w_is_readonly     TYPE abap_bool,
          e_value_w_initial TYPE abap_bool,
        END OF TS_FLAG_CONTROL_ISSUES .

  methods CHECK_OPERATION
    importing
      !IV_OP type ABP_BEHV_OP
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IV_ROOT type ABAP_BOOL default ABAP_OFF
    exporting
      !EV_ERROR type ABAP_BOOL .
  methods CHECK_ASSOCIATION
    importing
      !IV_P_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IV_SUB_NAME type CL_ABAP_BEHVDESCR=>T_SUB_NAME
      !IV_OP type ABP_BEHV_OP
    exporting
      !EV_REVERSE type ABAP_BOOL
      !EV_ERROR type ABAP_BOOL .
  methods CHECK_ACTION
    importing
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IV_ACTION type ABP_ACTION_NAME
    exporting
      !EV_ERROR type ABAP_BOOL .
  methods CHECK_ENTITY
    importing
      !IV_ROOT type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
    exporting
      !EV_ERROR type ABAP_BOOL .
  methods CHECK_FIELDS
    importing
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IS_DATA type ANY
    exporting
      !EV_ERROR type ABAP_BOOL .
  methods CHECK_PARAMS
    importing
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IV_P_SUB_NAME type CL_ABAP_BEHVDESCR=>T_SUB_NAME
      !IS_DATA type ANY
    exporting
      !EV_ERROR type ABAP_BOOL .
  methods CHECK_ENTITY_HAS_DRAFT
    importing
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
    exporting
      !EV_DRAFT_NAME type RBDEF_ENTITY-DRAFT_NAME
      !EV_ERROR type ABAP_BOOL .
  methods SET_CONTROL_FLAG
    importing
      !IV_OP type ABP_BEHV_OP
      !IV_NAME type STRING
      !IV_ACTION type PTF_ACT
      !IV_FIELD type DATA optional
      !IV_FIELD_CONTROL type ABP_BEHV_FEATURE optional
      !IV_INITIAL type ABAP_BOOL optional
      !IS_TEST_DATA type DATA
    exporting
      !ES_FLAG_CONTROL_ISSUES type TS_FLAG_CONTROL_ISSUES
      !EV_FLAG_CONTROL type ABP_BEHV_FLAG .
  methods CHECK_DATA
    importing
      !IS_TEST_DATA type DATA
      !IT_OPERATIONS_READ type ABP_BEHV_RETRIEVALS_TAB
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IV_CHECK_ONLY_KEYS type ABAP_BOOL default ABAP_OFF
    exporting
      !EV_ERROR type ABAP_BOOL .
  methods CHECK_KEY_EMPTY
    importing
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IS_DATA type ANY
    returning
      value(RV_KEY_EMPTY) type ABAP_BOOL .
  methods MOVE_TEST_DATA
    importing
      !IS_TEST_DATA type ANY
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IV_ROOT type ABAP_BOOL default ABAP_OFF
      !IV_COMPARE type ABAP_BOOL default ABAP_OFF
      !IV_CONTEXT type TE_CONTEXT optional
      !IV_PARENT type ABAP_BOOL optional
    exporting
      !EV_ERROR type ABAP_BOOL
    changing
      !CS_TARGET_DATA type ANY .
  methods CHECK_KEY_FULLY_FILLED
    importing
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IS_DATA type ANY
    returning
      value(RV_KEY_FULLY_FILLED) type ABAP_BOOL .
endinterface.
