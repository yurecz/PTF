interface IF_PTF_RAP_OPERATIONS
  public .


  methods BUILD_OPERATIONS
    importing
      !IV_OP type ABP_BEHV_OP
      !IV_INSTANCE_NO type INT4 default 1
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IS_TEST_DATA type DATA
      !IT_PERMISSIONS type ABP_BEHV_PERMISSIONS_TAB
    exporting
      !ET_OPERATIONS type ABP_BEHV_CHANGES_TAB
      !EV_ERROR type ABAP_BOOL .
  methods HANDLE_OPERATIONS_ERROR
    importing
      !IT_FAILED type ABP_BEHV_RESPONSE_TAB
      !IT_MAPPED type ABP_BEHV_RESPONSE_TAB optional
      !IT_REPORTED type ABP_BEHV_RESPONSE_TAB
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP optional
      !IV_IS_READ type ABAP_BOOL default ABAP_OFF
    exporting
      !EV_ERROR type ABAP_BOOL .
  methods CONVERT_TO_OPERATIONS_READ
    importing
      !IV_OP type ABP_BEHV_OP
      !IT_OPERATIONS type ABP_BEHV_CHANGES_TAB
    exporting
      !ET_OPERATIONS_READ type ABP_BEHV_RETRIEVALS_TAB .
  methods FILTER_OPERATIONS
    importing
      !IS_TEST_DATA type DATA
      !IV_NAME type PTF_BO
      !IV_ACTION type PTF_ACT
    exporting
      !EV_ERROR type ABAP_BOOL
    changing
      !CT_OPERATIONS type ABP_BEHV_RETRIEVALS_TAB .
endinterface.
