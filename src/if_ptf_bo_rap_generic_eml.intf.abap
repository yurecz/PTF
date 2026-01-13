interface IF_PTF_BO_RAP_GENERIC_EML
  public .

  types:
    BEGIN OF TS_FAILED_PID,
      root_name   TYPE abp_entity_name,
      pid         TYPE abp_behv_pid,
      r_pre       TYPE REF TO data,
    END OF TS_FAILED_PID .
  types:
    BEGIN OF TS_PID_MAPPED,
          step_number TYPE i,
          root_name   TYPE abp_entity_name,
          pid         TYPE abp_behv_pid,
          r_pre       TYPE REF TO data,
          key         TYPE ptfkey,
         END OF TS_PID_MAPPED .
  types:
    TT_PID_MAPPED TYPE STANDARD TABLE OF TS_PID_MAPPED .
  types:
    TT_FAILED_PID TYPE STANDARD TABLE OF TS_FAILED_PID .

  methods GET_PERMISSIONS
    exporting
      !ET_FAILED type ABP_BEHV_RESPONSE_TAB
      !ET_REPORTED type ABP_BEHV_RESPONSE_TAB
    changing
      !CT_OPERATIONS type ABP_BEHV_PERMISSIONS_TAB .
  methods MODIFY_ENTITIES
    exporting
      !ET_FAILED type ABP_BEHV_RESPONSE_TAB
      !ET_MAPPED type ABP_BEHV_RESPONSE_TAB
      !ET_REPORTED type ABP_BEHV_RESPONSE_TAB
    changing
      !CT_OPERATIONS type ABP_BEHV_CHANGES_TAB .
  methods READ_ENTITIES
    exporting
      !ET_FAILED type ABP_BEHV_RESPONSE_TAB
      !ET_REPORTED type ABP_BEHV_RESPONSE_TAB
    changing
      !CT_OPERATIONS type ABP_BEHV_RETRIEVALS_TAB .
  methods COMMIT_ENTITIES
    importing
      !IV_SIMULATION type ABAP_BOOL default ABAP_OFF
      !IT_ROOT_ENTITIES type ABP_ENTITY_NAME_TAB optional
    exporting
      !ET_FAILED type ABP_BEHV_RESPONSE_TAB
      !ET_REPORTED type ABP_BEHV_RESPONSE_TAB
    changing
      !CT_PID_MAPPED type TT_PID_MAPPED optional .
  methods READ_ALL_ENTITIES
    changing
      !CT_FAILED type ABP_BEHV_RESPONSE_TAB
      !CT_REPORTED type ABP_BEHV_RESPONSE_TAB
      !CT_OPERATIONS type ABP_BEHV_RETRIEVALS_TAB .
endinterface.
