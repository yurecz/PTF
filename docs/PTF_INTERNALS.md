# PTF Internal Workings

This document describes the internal architecture and execution flow of the Process Test Framework (PTF) to help LLMs understand the codebase faster.

## Core Data Structures

### Step Data Structure (`cl_ptf_util=>gt_ptf_step`)

The primary data structure representing a PTF test step:

```abap
TYPES: gt_ptf_step TYPE ptf_Step.
```

**Key Fields:**
- `step_number` (TYPE i): Sequential step identifier in test case
- `bus_obj` (TYPE ptf_bo): Business Object name (e.g., 'OR', 'INVOICE', 'I_SalesOrderTP')
- `action` (TYPE ptf_act): Action to execute (e.g., 'CREATE', 'CHANGE', 'MODIFY', 'RETRIEVE')
- `variant` (TYPE ptf_tdcv): Test Data Container Variant name
- `test_data_container` (TYPE etobj_name): TDC object name
- `reference_step` (TYPE numc3): Reference to previous step number(s)
- `document_id` (TYPE ptfkey): Result document IDs from execution
- `json_file` (TYPE string): JSON payload for step input
- `data_object_json` (TYPE string): JSON data retrieved by RETRIEVE/RETRIEVE_ALL actions
- `execution_status` (TYPE abap_bool): Step execution success flag
- `check_status` (TYPE abap_bool): Check action result flag
- `check_flag` (TYPE abap_bool): Indicates if action is a check action
- `is_manual` (TYPE abap_bool): Manual document ID entry flag
- `is_pid` (TYPE abap_bool): Indicates if document_id contains preliminary ID (%PID)
- `exp_messages` (TYPE ptf_exp_message_t): Expected messages for validation
- `act_messages` (TYPE bapirettab): Actual messages from execution
- `log` (TYPE bapirettab): Execution log messages

### Output Table Structure (`cl_ptf_util=>ty_outtab`)

ALV grid display structure with icons and styling:

```abap
BEGIN OF ty_outtab,
  step_number         TYPE i,
  bus_obj             TYPE ptf_bo,
  action              TYPE ptf_act,
  variant             TYPE ptf_tdcv,
  test_data_container TYPE etobj_name,
  reference_step      TYPE numc3,
  reference_step_more TYPE icon_d,
  document_id         TYPE ptfkey,
  document_id_more    TYPE icon_d,
  is_manual           TYPE abap_bool,
  json_file           TYPE string,
  json_file_more      TYPE icon_d,
  exp_messages        TYPE ptf_exp_message_t,
  act_messages        TYPE bapirettab,
  execution_status    TYPE icon_d,
  check_status        TYPE icon_d,
  handle_style        TYPE lvc_t_styl,
END OF ty_outtab.
```

## Execution Flow

### 1. Test Case Execution Entry Points

**GUI Execution** (`/n/ptf/run`):
- Program: `process_test_framework_alv.prog.abap`
- Entry: User clicks "Execute" button
- Flow: `ptf_step_alv_event.prog.abap` → `tcl_ptf_step_in_au.clas.abap`

**RFC Execution**:
- Function: `PTF_INVOKE_ACTION` in `ptf_rfc.fugr`
- Used by: External systems calling PTF remotely

**Unit Test Execution**:
- Class: `tcl_ptf_step_in_au.clas.abap`
- Method: `execute_step_in_aunit`
- Flow: ABAP Unit → Step execution → Result validation

### 2. Step Execution Flow

```
1. tcl_ptf_step_in_au=>execute_step_in_aunit()
   ↓
2. Create cl_ptf_run instance with step data
   ↓
3. Determine BO class: 'CL_PTF_BO_' + bus_obj
   ↓
4. Call BO class method based on action type:
   - CREATE → if_ptf_bo~create()
   - CHANGE → if_ptf_bo~change()
   - DELETE → if_ptf_bo~delete()
   - CHECK* → if_ptf_bo~execute_check()
   - Other → if_ptf_bo~execute_action()
   ↓
5. Execute EML/BAPI/Custom logic in BO class
   ↓
6. Collect results:
   - document_id (created keys)
   - execution_status (success/failure)
   - check_status (for check actions)
   - act_messages (BAPI return messages)
   ↓
7. Update step_data structure
   ↓
8. Log execution to Application Log
```

### 3. BO Class Hierarchy

**Base Interface**: `if_ptf_bo`
```abap
METHODS:
  create() EXPORTING ev_document_id ev_execution_status ev_check_status
  change() ...
  delete() ...
  check() ...
  execute_action() ...
  execute_check() ...
```

**Common BO Classes**:
- `cl_ptf_bo_or` - Sales Orders
- `cl_ptf_bo_invoice` - Billing Documents
- `cl_ptf_bo_ebdr` - Contract Documents
- `cl_ptf_bo_rap_generic` - Generic RAP BO handler
- `cl_ptf_bo_ptf_wait` - Wait/polling actions

**RAP BO Execution Path**:
```
cl_ptf_bo_rap_generic
  ↓
cl_ptf_bo_rap_generic_eml (EML wrapper)
  ↓
MODIFY ENTITIES / READ ENTITIES / GET PERMISSIONS
  ↓
COMMIT ENTITIES
```

## JSON Payload System

### JSON Input (`json_file` field)

Used for step input data, replaces TDC/TDCV:

**Standard Actions** (CREATE/CHANGE/DELETE):
```json
{
  "fields": [
    {"name": "FIELD1", "value": "VALUE1"},
    {"name": "FIELD2", "value": "VALUE2"}
  ],
  "associations": [
    {"name": "_ASSOC", "instances": [...]}
  ]
}
```

**MODIFY Action** (EML operations array):
```json
[
  {
    "op": "CREATE",
    "entity": "I_SalesOrderTP",
    "instances": [
      {"%CID": "id-1", "SalesOrderType": "OR"}
    ]
  }
]
```

**Deserialization**:
- Standard actions: `cl_ptf_json=>deserialize()`
- MODIFY action: `cl_ptf_rap_modify_executor=>deserialize_json()`

### JSON Output (`data_object_json` field)

Populated by RETRIEVE/RETRIEVE_ALL actions:

**Source**: Backend BO data serialized to JSON after READ operation
**Usage**: View via "Show Retrieved BO Data" button in UI
**Format**: Same structure as JSON input (fields + associations)

**Viewer Restrictions**:
- Read-only display
- Edit buttons disabled
- Used for debugging/verification only

## Document ID Extraction

### Traditional BOs (BAPI-based)

**Direct Key Return**:
```abap
CALL FUNCTION 'BAPI_SALESORDER_CREATE'
  IMPORTING
    salesdocument = lv_vbeln.  " Direct document number

ls_step_data-document_id = VALUE #( ( vbeln = lv_vbeln ) ).
```

### RAP BOs (EML-based)

**Late Numbering Flow** (most common):
```
1. MODIFY ENTITIES returns %PID (preliminary ID)
   → lt_mapped contains temporary keys like %00000001
   
2. COMMIT ENTITIES converts %PID to real keys
   → Uses CONVERT KEY OF to get actual document numbers
   → Stores mapping in lt_pid_mapped table
   
3. extract_document_ids() prioritizes:
   a) lt_pid_mapped (real keys) - PRIMARY SOURCE
   b) lt_mapped (direct keys) - FALLBACK
```

**Implementation**: `cl_ptf_rap_modify_executor=>extract_document_ids()`

**Key Field Detection**:
- Uses `cl_ptf_rap_metadata=>get_key_fields()` to identify key components
- Concatenates multi-field keys with delimiter: `KEY1~KEY2~KEY3`
- Filters temporary keys containing `$` or `%`

## UI Components

### "Show Retrieved BO Data" Button

**Location**: Step toolbar in `/n/ptf/run`

**Enabled When**:
- Action is RETRIEVE or RETRIEVE_ALL
- `data_object_json` field is populated
- Code: `ptf_step_alv_event.prog.abap:699-710`

**Functionality**:
- Opens JSON editor screen (8001)
- Displays `data_object_json` content in read-only mode
- Disables Save/Format buttons for retrieved data
- Sets global variable `gv_retrieved_data` for display

**Use Cases**:
- Verify what data was actually retrieved from backend
- Debug RETRIEVE operations
- Compare expected vs actual structure
- Copy structure for next step's JSON

### ALV Grid Icons

**Execution Status**:
- Green checkmark: `execution_status = abap_on`
- Red X: `execution_status = abap_off`

**Check Status**:
- Green checkmark: `check_status = abap_on`
- Red X: `check_status = abap_off`
- Gray: Not a check action

## Special Action Types

### MODIFY Action (RAP BOs)

**Executor Class**: `cl_ptf_rap_modify_executor`

**Flow**:
```
1. deserialize_json() - Parse EML operations array
   ↓
2. Create typed EML structures via cl_abap_behvdescr
   ↓
3. Auto-generate %CID if missing (format: AUTO-YYYYMMDD-HHMMSS-counter)
   ↓
4. modify_entities() - Execute EML MODIFY
   ↓
5. commit_entities() - Commit with PID conversion
   ↓
6. extract_document_ids() - Get real keys from PID_MAPPED
```

**Nested References Handling**:
- `/ui2/cl_json=>deserialize` with generic REF TO data creates references at ALL levels
- Requires multi-level dereferencing: `<fs_op>->*`, `<fs_value>->*`, etc.
- See: `AGENTS.md` section "CRITICAL: /ui2/cl_json nested references behavior"

### RETRIEVE/RETRIEVE_ALL Actions

**Purpose**: Read BO data and store in `data_object_json`

**Flow**:
```
1. cl_ptf_bo_rap_generic=>retrieve_data()
   ↓
2. Execute READ ENTITIES with fields list
   ↓
3. Serialize result to JSON via cl_ptf_json=>serialize()
   ↓
4. Store in step_data-data_object_json
   ↓
5. Enable "Show Retrieved BO Data" button in UI
```

**Storage**: `cl_ptf_step_attr=>get_instance()->set_tdo(iv_data_object_json)`

## Test Data Sources

### 1. Test Data Container (TDC/TDCV)

**Traditional Method**:
- eCATT Test Data Container objects
- Accessed via: `cl_apl_ecatt_tdc_api`
- Fields: `test_data_container` + `variant`

### 2. JSON Payload

**Modern Method**:
- Inline JSON in `json_file` field
- No TDC dependency
- Portable across systems

### 3. Manual Entry

**UI Feature**:
- Set `is_manual = abap_on`
- User enters document IDs directly in ALV
- Skip action execution, use for validation only

### 4. Reference Steps

**Key Chaining**:
```abap
reference_step = VALUE #( ( 1 ) ( 2 ) )  " Use docs from steps 1 and 2
```

**Resolution**:
- `cl_ptf_run=>get_keys_of_touch_doc_of_step()`
- Retrieves document_id from referenced steps
- Substitutes into current step's test data

## Singleton Services

### cl_ptf_step_attr (Singleton)

**Purpose**: Thread-local storage for step-level attributes

**Key Methods**:
```abap
get_instance() RETURNING VALUE(ro_instance)
get_tdo() RETURNING VALUE(rv_result) TYPE string
set_tdo(iv_data_object_json TYPE string)
get_actual_messages() RETURNING VALUE(rt_messages)
add_actual_messages(it_messages TYPE ptf_t100_message_t)
```

**Usage Pattern**:
```abap
DATA(lo_attr) = cl_ptf_step_attr=>get_instance( ).
lo_attr->if_ptf_step_attr~set_tdo( lv_json ).
```

### cl_ptf_run (Run Environment)

**Purpose**: Runtime context for test case execution

**Key Methods**:
```abap
get_step_data(iv_step_number TYPE i) RETURNING VALUE(rs_step_data)
append_log(iv_log_statement TYPE string)
get_keys_of_touch_doc_of_step(iv_step_number TYPE i)
```

**Instantiation**:
```abap
DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).
```

## Message Handling

### Expected Messages (`exp_messages`)

**Structure**: `ptf_exp_message_t`
```abap
BEGIN OF ty_exp_message,
  msgid TYPE symsgid,
  msgno TYPE symsgno,
  msgty TYPE symsgty,
  msgv1 TYPE symsgv,
  ...
END OF ty_exp_message.
```

**Validation**:
- Compare `exp_messages` against `act_messages`
- Set `check_status` based on match
- Log differences

### Actual Messages (`act_messages`)

**Source**: BAPI return tables (TYPE bapirettab)

**Collection Points**:
1. Direct BAPI RETURN parameter
2. EML REPORTED table conversion
3. Custom message generation in BO classes

**Storage**:
```abap
cl_ptf_step_attr=>get_instance( )->add_actual_messages( lt_messages ).
```

## Error Handling Patterns

### BO Class Level

```abap
IF lv_error = abap_on.
  ev_execution_status = abap_off.
  ev_check_status = abap_off.
  RETURN.
ENDIF.
```

### EML Level (RAP)

```abap
IF line_exists( lt_failed[ entity_name = iv_entity ] ).
  " Extract error messages from REPORTED
  me->collect_messages( it_reported = lt_reported ).
  ev_error = abap_on.
ENDIF.
```

### Commit Level

```abap
COMMIT ENTITIES
  FAILED lt_failed_commit
  REPORTED lt_reported_commit.

IF lt_failed_commit IS NOT INITIAL.
  " Handle commit failure
  ev_error = abap_on.
ENDIF.
```

## Logging System

### Append Log Pattern

```abap
me->mo_run_environment->append_log( |Message text| ).
me->mo_run_environment->append_log( iv_log_statement = lv_message ).
```

### Application Log

- Automatically created per test run
- Object: PTF
- Subobject: TEST
- View via: SLG1 transaction

### Debug Logging

**Step execution**:
```
Processing operation: CREATE
Added operation for entity I_SALESORDERTP with 1 instances
Executed/committed without EML error
Extracted 1 document ID(s) from PID_MAPPED (real keys)
Extracted document ID: 0000000123
```

## RAP-Specific Components

### cl_ptf_rap_modify_executor (MODIFY Action Execution)

**Purpose**: Deserializes JSON and executes RAP MODIFY operations (CREATE/UPDATE/DELETE/EXECUTE)

**Key Methods:**

#### execute() - Main Orchestration
```
1. Get step data (json_file contains EML operations array)
2. deserialize_json() → operations table (ABP_BEHV_CHANGES_TAB)
3. mo_eml->modify_entities() → Execute EML MODIFY ENTITIES OPERATIONS
4. collect_messages() → Extract messages from REPORTED
5. handle_operations_error() → Check FAILED table
6. commit_entities() → COMMIT ENTITIES with PID conversion
7. extract_document_ids() → Get real keys from PID_MAPPED/MAPPED
```

#### deserialize_json() - JSON to EML Operations
```
1. Parse JSON array with /ui2/cl_json=>deserialize
   - Creates nested references at ALL levels
   
2. Loop through JSON operations:
   - Extract 'op' code → map to if_abap_behv constants
   - Extract 'entity' name → target BO entity
   - Extract 'sub_name' → for CREATE_BY/EXECUTE
   - Extract 'instances' array → dereferenced to table
   
3. Create typed EML structure:
   - cl_abap_behvdescr=>create_data(p_op=... p_name=... p_kind=...)
   - Returns correctly typed structure for operation
   
4. Map JSON fields to EML structure:
   - Iterate JSON components (5-10 fields, not target 80-100)
   - Dereference: <fs_value>->* → <actual_value>
   - Direct assignment: <fs_field> = <actual_value>
   - NO CONVERSION: UUID x16 passed as-is
   
5. Set %control for UPDATE operations:
   - Get key fields: lo_metadata->get_key_fields()
   - Skip key fields (identification only)
   - Mark non-key fields: <fs_control_field> = if_abap_behv=>mk-on
   
6. Auto-generate %CID if missing:
   - Format: AUTO-{YYYYMMDD}{HHMMSS}-{counter}
   - For CREATE and CREATE_BY operations
```

**UUID Handling:**
- **No conversion applied** - Direct assignment from JSON to EML structure
- JSON value must already be in **x16 format** (32 hex chars, no hyphens)
- Example: `"NOTEBASICUUID": "42010AEF83EE1FE0BCE4BDE0DDB24D36"`
- Assignment: `<fs_field> = <actual_value>` where actual_value is the x16 string
- ABAP runtime handles x16 string → sysuuid_x16 type conversion automatically

**Key Field Detection:**
- Uses `cl_ptf_rap_metadata->get_key_fields(iv_name = entity_name)`
- Returns `abap_component_tab` with key field names (multiple components for compound keys)
- Key fields in UPDATE:
  * Present in instances for record identification
  * NOT marked in %control (excluded from modification)
  * Used to populate %key/%tky automatically by EML runtime

**Compound Key Handling (Multiple Key Components):**

**Note:** The examples below show RAP operations (CREATE, UPDATE, DELETE) within the PTF MODIFY action, not separate PTF CREATE/UPDATE/DELETE actions.

**RAP CREATE Operation (within MODIFY):**
```
JSON with compound key:
{
  "op": "CREATE",
  "entity": "I_ProductionSupplyAreaTP", 
  "instances": [{
    "ProductionSupplyArea": "TEST_ARE01",  // Key field 1
    "ProductionSupplyAreaVersion": "0001", // Key field 2
    "ProductionSupplyAreaName": "Test Area"
  }]
}

Flow:
1. All key fields assigned to EML structure
2. EML runtime populates %key structure with both fields
3. COMMIT returns both key values in MAPPED

Result extraction:
- extract_document_ids() loops through key components
- Concatenates: "TEST_ARE01|0001" (using | delimiter)
- Stored in document_id for reference steps
```

**RAP UPDATE Operation (within MODIFY):**
```
JSON with compound key (in MODIFY operations array):
{
  "op": "UPDATE",
  "entity": "I_ProductionSupplyAreaTP",
  "instances": [{
    "ProductionSupplyArea": "TEST_ARE01",       // Key 1 - identification
    "ProductionSupplyAreaVersion": "0001",      // Key 2 - identification  
    "ProductionSupplyAreaName": "Updated Name"  // Data field - modification
  }]
}

Flow:
1. get_key_fields() returns: [ProductionSupplyArea, ProductionSupplyAreaVersion]
2. Both key fields assigned to <fs_target>
3. %control check: lv_is_key_field for EACH field
   - ProductionSupplyArea: SKIPPED (key field, no %control mark)
   - ProductionSupplyAreaVersion: SKIPPED (key field, no %control mark)
   - ProductionSupplyAreaName: MARKED (data field, %control-ProductionSupplyAreaName = mk-on)
4. EML runtime:
   - Extracts both key values → populates %key/%tky
   - Uses both values to identify record
   - Only updates ProductionSupplyAreaName
```

**RAP DELETE Operation (within MODIFY):**
```
JSON with compound key (in MODIFY operations array):
{
  "op": "DELETE",
  "entity": "I_ProductionSupplyAreaTP",
  "instances": [{
    "ProductionSupplyArea": "TEST_ARE01",   // Key 1
    "ProductionSupplyAreaVersion": "0001"   // Key 2
  }]
}

Flow:
1. Both key fields assigned to DELETE structure
2. EML runtime extracts to %key/%tky
3. Uses both values to identify record for deletion
```

**Key Delimiter Constant:**
```abap
cl_ptf_util=>gc_key_field_delimiter = '|'  "Pipe character
```

**Example Compound Key Extraction:**
```abap
"From extract_document_ids() method (lines 673-684):
LOOP AT lt_components ASSIGNING <fs_component>.
  DATA(lv_tabix) = sy-tabix.
  ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_entry> TO <fs_field>.
  IF sy-subrc = 0.
    IF lv_tabix = 1.
      lv_ptf_key = <fs_field>.              "First key: TEST_ARE01"
    ELSE.
      lv_ptf_key = |{ lv_ptf_key }|{ <fs_field> }|.  "Result: TEST_ARE01|0001"
    ENDIF.
  ENDIF.
ENDLOOP.
```

**Important Notes:**
- **All key components must be provided** in JSON for UPDATE/DELETE
- **Order doesn't matter** - EML matches by field name, not position
- **Delimiter only in document_id** - not in JSON or EML structures
- **Referenced steps**: When using reference_step, PTF splits document_id by | to restore individual key values

### cl_ptf_bo_rap_generic_eml (EML Wrapper)

**Purpose**: Direct EML execution wrapper

**Method: modify_entities()**
```abap
METHOD if_ptf_bo_rap_generic_eml~modify_entities.
  MODIFY ENTITIES
    OPERATIONS ct_operations
    FAILED et_failed
    MAPPED et_mapped
    REPORTED et_reported.
ENDMETHOD.
```

**No additional logic** - Pure passthrough to EML
- Operations table already correctly typed from deserialize_json
- EML runtime handles:
  * Type validation
  * %control interpretation
  * Key field extraction (%key/%tky/%pky)
  * Early/late numbering
  * Authorization checks
  * Feature control
  * Validations and determinations

### cl_ptf_rap_metadata

**Purpose**: RAP BO structure introspection

**Key Methods**:
```abap
get_key_fields(iv_name TYPE abp_entity_name)
check_rap_bo_action(iv_bus_obj TYPE string iv_action TYPE string)
```

### cl_ptf_rap_operations

**Purpose**: RAP operation validation and execution

**Responsibilities**:
- Validate entity names
- Check field existence
- Handle control fields (%control)
- Manage technical fields (%cid, %pky, %tky)

### cl_ptf_rap_modify_template

**Purpose**: Generate MODIFY JSON templates

**Generated Format**: EML operations array structure

## Performance Considerations

### JSON Iteration Optimization

**Problem**: Target EML structure has 80-100 fields, JSON has 5-10

**Solution**: Iterate JSON components, not target structure
```abap
DATA(lo_json_descr) = CAST cl_abap_structdescr(
  cl_abap_typedescr=>describe_by_data( <json_instance> ) ).

LOOP AT lo_json_descr->components INTO DATA(ls_json_comp).
  " Map to target structure
ENDLOOP.
```

### Early Return Pattern

```abap
" Check PID_MAPPED first (real keys)
IF ev_document_id IS NOT INITIAL.
  RETURN.  " Skip MAPPED fallback
ENDIF.
```

## Development Patterns

### BO Class Template

```abap
CLASS cl_ptf_bo_xxx DEFINITION
  PUBLIC
  INHERITING FROM cl_ptf_bo_base
  CREATE PUBLIC.
  
  PUBLIC SECTION.
    METHODS:
      create REDEFINITION,
      change REDEFINITION,
      delete REDEFINITION,
      execute_action REDEFINITION,
      execute_check REDEFINITION.
ENDCLASS.

CLASS cl_ptf_bo_xxx IMPLEMENTATION.
  METHOD execute_action.
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number ).
    
    CASE ls_step_data-action.
      WHEN 'MY_ACTION'.
        me->my_action(
          EXPORTING step_data = ls_step_data
          IMPORTING ev_document_id ev_execution_status ev_check_status ).
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
```

### Action Method Pattern

```abap
METHOD my_action.
  " 1. Get test data
  cl_ptf_util=>get_testdata(
    EXPORTING is_step_data = step_data
    IMPORTING es_testdata = ls_testdata ).
  
  " 2. Execute business logic
  CALL FUNCTION 'MY_BAPI'
    EXPORTING ...
    IMPORTING return = lt_return.
  
  " 3. Set results
  ev_document_id = VALUE #( ( vbeln = lv_result_key ) ).
  ev_execution_status = xsdbool( lv_error IS INITIAL ).
  
  " 4. Log execution
  me->mo_run_environment->append_log( |Created document: { lv_result_key }| ).
ENDMETHOD.
```

## Key Utilities

### cl_ptf_util

**Common Functions**:
- `get_testdata()` - Load TDC data
- `do_commitment()` - Execute COMMIT WORK
- `ensure_posnr_filled()` - Item number generation
- `get_key_field_descriptor()` - Key structure analysis

### cl_ptf_json

**JSON Operations**:
- `deserialize()` - JSON to ABAP structure
- `serialize()` - ABAP to JSON
- `generate_sample_json()` - Template generation
- `count_instances()` - Count JSON array elements

## References

- **Step execution**: `tcl_ptf_step_in_au.clas.abap`
- **RAP generic**: `cl_ptf_bo_rap_generic.clas.abap`
- **MODIFY executor**: `cl_ptf_rap_modify_executor.clas.abap`
- **UI handling**: `ptf_step_alv_event.prog.abap`
- **JSON operations**: `cl_ptf_json.clas.abap`
- **Utilities**: `cl_ptf_util.clas.abap`

## Related Documentation

- [DEVELOPMENT_GOALS.md](DEVELOPMENT_GOALS.md) - Upcoming features
- [EML_MODIFY.md](EML_MODIFY.md) - MODIFY action technical details
- [RAP_MODIFY_EXAMPLES.md](RAP_MODIFY_EXAMPLES.md) - Working examples
- [AGENTS.md](../AGENTS.md) - LLM development guidelines
