interface IF_PTF_RAP_PERMISSIONS
  public .


  types:
    BEGIN OF ts_permissions_grouped,
           entity_name TYPE abp_entity_name,
           permissions TYPE abp_behv_permissions_tab,
         END OF ts_permissions_grouped .
  types:
    tt_permissions_grouped TYPE STANDARD TABLE OF ts_permissions_grouped WITH KEY entity_name .

  methods BUILD_PERMISSIONS
    importing
      !IV_OP type ABP_BEHV_OP
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IS_TEST_DATA type DATA
    exporting
      !EV_ERROR type ABAP_BOOL
    changing
      !CT_PERMISSIONS type ABP_BEHV_PERMISSIONS_TAB .
  methods HANDLE_PERMISSIONS_ERROR
    importing
      !IT_FAILED type ABP_BEHV_RESPONSE_TAB
      !IT_COMPONENTS type ABAP_COMPONENT_TAB
    exporting
      !EV_ERROR type ABAP_BOOL .
  methods GROUP_PERMISSIONS
    importing
      !IT_PERMISSIONS type ABP_BEHV_PERMISSIONS_TAB
    exporting
      !ET_PERMISSIONS_GROUPED type TT_PERMISSIONS_GROUPED .
endinterface.
