# Compound Keys in PTF Actions (CREATE/UPDATE/DELETE)

## Overview

This document explains how **PTF actions** (CREATE, UPDATE, DELETE) handle entities with compound keys and populate the `document_id` column.

**Important Distinction:**
- **PTF Actions**: CREATE, UPDATE, DELETE, EXECUTE, MODIFY - Framework-level test actions in `/n/ptf/run`
- **RAP Operations**: Low-level EML operations inside MODIFY action's operations array
- **This document covers**: PTF CREATE/UPDATE/DELETE actions (traditional format), not MODIFY
- **For MODIFY**: See [COMPOUND_KEYS.md](COMPOUND_KEYS.md)

## Key Delimiter

All compound keys are concatenated using the pipe delimiter:

```abap
cl_ptf_util=>gc_key_field_delimiter = '|'  "Pipe character
```

## JSON Format for PTF Actions

PTF CREATE/UPDATE/DELETE actions use a different JSON format than MODIFY:

```json
{
  "fields": [
    {"name": "KEY_FIELD_1", "value": "VALUE1"},
    {"name": "KEY_FIELD_2", "value": "VALUE2"},
    {"name": "DATA_FIELD", "value": "DATA_VALUE"}
  ],
  "associations": []
}
```

**NOT** the operations array format used by MODIFY.

## PTF CREATE Action - Compound Key Extraction

**Scenario:** Create entity with multiple key fields

**Entity:** `I_ProductionSupplyAreaTP`
- Key Field 1: `ProductionSupplyArea`
- Key Field 2: `ProductionSupplyAreaVersion`

**PTF Action JSON:**
```json
{
  "fields": [
    {"name": "ProductionSupplyArea", "value": "TEST_ARE01"},
    {"name": "ProductionSupplyAreaVersion", "value": "0001"},
    {"name": "ProductionSupplyAreaName", "value": "Test Area"}
  ]
}
```

**Execution Flow:**

1. **PTF deserializes JSON** → calls `cl_ptf_bo_rap_generic->create()`
2. **create()** → calls `operation()` with `op-m-create`
3. **operation()** executes EML:
   ```abap
   MODIFY ENTITIES OF I_ProductionSupplyAreaTP
     CREATE FIELDS ( ProductionSupplyArea ProductionSupplyAreaVersion ProductionSupplyAreaName )
     WITH VALUE #( ( ProductionSupplyArea = 'TEST_ARE01'
                     ProductionSupplyAreaVersion = '0001'
                     ProductionSupplyAreaName = 'Test Area' ) )
     MAPPED DATA(lt_mapped)
     FAILED DATA(lt_failed)
     REPORTED DATA(lt_reported).
   
   COMMIT ENTITIES
     REPORTED DATA(lt_reported_commit).
   ```

4. **Document ID Extraction** (method `retrieve_document_id`):

   **Primary Source - PID_MAPPED** (checked first):
   ```abap
   " After COMMIT, PTF stores %PID → real key mapping in mt_pid_mapped
   " If found, returns real keys directly
   ```

   **Fallback 1 - MAPPED Table**:
   ```abap
   " Method: retrieve_doc_id_from_mapped()
   " Processes lt_mapped entries for CREATE operations
   ```

   **Key Concatenation Logic** (from `retrieve_doc_id_from_mapped`):
   ```abap
   " Get key metadata
   DATA(lt_components) = mo_ptf_rap_metadata->get_key_fields( is_step_data-bus_obj ).
   
   LOOP AT <fs_entries> ASSIGNING <fs_entry>.
     CLEAR lv_ptf_key.
     
     " Loop through key components
     LOOP AT lt_components ASSIGNING <fs_component>.
       DATA(lv_tabix) = sy-tabix.
       ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_entry> TO <fs_field>.
       
       IF lv_tabix = 1.
         lv_ptf_key = <fs_field>.              " First: TEST_ARE01
       ELSE.
         " Concatenate with delimiter
         lv_ptf_key = |{ lv_ptf_key }{ cl_ptf_util=>gc_key_field_delimiter }{ <fs_field> }|.
         " Result: TEST_ARE01|0001
       ENDIF.
     ENDLOOP.
     
     " Filter temporary keys containing $ or %
     IF lv_ptf_key IS NOT INITIAL AND lv_ptf_key NA '$%'.
       APPEND lv_ptf_key TO ev_document_id.
     ENDIF.
   ENDLOOP.
   ```

   **Fallback 2 - REPORTED_COMMIT Table**:
   ```abap
   " Method: retrieve_doc_id_from_rep_comm()
   " For late numbering entities, COMMIT ENTITIES provides real keys
   " Same concatenation logic with pipe delimiter
   ```

**Result:** `document_id = "TEST_ARE01|0001"`

## PTF UPDATE Action - Compound Key Extraction

**Scenario:** Update entity identified by compound key

**PTF Action JSON:**
```json
{
  "fields": [
    {"name": "ProductionSupplyArea", "value": "TEST_ARE01"},
    {"name": "ProductionSupplyAreaVersion", "value": "0001"},
    {"name": "ProductionSupplyAreaName", "value": "Updated Name"}
  ]
}
```

**Execution Flow:**

1. **PTF deserializes JSON** → calls `cl_ptf_bo_rap_generic->change()`
2. **change()** → calls `operation()` with `op-m-update`
3. **operation()** executes EML UPDATE

4. **Document ID Extraction** (method `retrieve_document_id`):

   **Primary Source - Test Data** (for UPDATE/DELETE):
   ```abap
   " Method: retrieve_doc_id_from_td_inst()
   " Extracts keys directly from the JSON test data structure
   ```

   **Key Extraction Logic** (from `retrieve_doc_id_from_td_inst`):
   ```abap
   " Get key metadata
   DATA(lt_components) = mo_ptf_rap_metadata->get_key_fields( is_step_data-bus_obj ).
   
   " Loop through key components
   LOOP AT lt_components ASSIGNING <fs_component>.
     DATA(lv_tabix) = sy-tabix.
     
     " Extract key field value from test data
     ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_test_data TO <fs_field>.
     IF sy-subrc = 0.
       IF lv_tabix = 1.
         lv_ptf_key = <fs_field>.              " First: TEST_ARE01
       ELSE.
         " Concatenate with delimiter
         lv_ptf_key = |{ lv_ptf_key }{ cl_ptf_util=>gc_key_field_delimiter }{ <fs_field> }|.
         " Result: TEST_ARE01|0001
       ENDIF.
     ENDIF.
   ENDLOOP.
   
   APPEND lv_ptf_key TO cv_document_id.
   ```

**Result:** `document_id = "TEST_ARE01|0001"`

## PTF DELETE Action - Compound Key Extraction

**Scenario:** Delete entity identified by compound key

**PTF Action JSON:**
```json
{
  "fields": [
    {"name": "ProductionSupplyArea", "value": "TEST_ARE01"},
    {"name": "ProductionSupplyAreaVersion", "value": "0001"}
  ]
}
```

**Execution Flow:**

1. **PTF deserializes JSON** → calls `cl_ptf_bo_rap_generic->delete()`
2. **delete()** → calls `operation()` with `op-m-delete`
3. **operation()** executes EML DELETE

4. **Document ID Extraction**:
   - Same as UPDATE action
   - Uses `retrieve_doc_id_from_td_inst()` method
   - Extracts all key fields from test data
   - Concatenates with pipe delimiter

**Result:** `document_id = "TEST_ARE01|0001"`

## Document ID Extraction - Priority Order

The `retrieve_document_id()` method follows this priority:

### For CREATE/ACTION Operations:
1. **PID_MAPPED** (highest priority) - Real keys from prior COMMIT
2. **MAPPED** - Keys from MODIFY ENTITIES response
3. **REPORTED_COMMIT** - Keys from COMMIT ENTITIES response
4. **OPERATIONS RESULTS** (ACTION only) - Result parameters
5. **FAILED** (ACTION only) - Failed entries

### For UPDATE/DELETE/READ Operations:
1. **PID_MAPPED** (highest priority) - Real keys from prior COMMIT
2. **Test Data** - Keys extracted directly from JSON input

## Key Components Used

**Class:** `cl_ptf_bo_rap_generic`

**Methods:**
- `create()` → `operation(op-m-create)` → `retrieve_document_id()`
- `change()` → `operation(op-m-update)` → `retrieve_document_id()`
- `delete()` → `operation(op-m-delete)` → `retrieve_document_id()`

**Document ID Extraction Methods:**
- `retrieve_document_id()` - Main dispatcher (lines 1782-1929)
- `retrieve_doc_id_from_mapped()` - From MAPPED table (lines 1979-2057)
- `retrieve_doc_id_from_td_inst()` - From test data (lines 2259-2280+)
- `retrieve_doc_id_from_rep_comm()` - From REPORTED_COMMIT (lines 2205-2257)
- `retr_doc_id_from_pid_mapped()` - From stored PID mappings

**Key Detection:**
- `cl_ptf_rap_metadata->get_key_fields(iv_name = entity_name)`
- Returns `abap_component_tab` with all key field names

## Comparison: PTF Actions vs MODIFY Action

| Aspect | PTF CREATE/UPDATE/DELETE | MODIFY Action |
|--------|--------------------------|---------------|
| **JSON Format** | `{fields: [], associations: []}` | `[{op, entity, instances}]` |
| **Key Extraction For CREATE** | From MAPPED/REPORTED_COMMIT | From MAPPED/PID_MAPPED |
| **Key Extraction For UPDATE/DELETE** | From test data JSON | From test data JSON |
| **Concatenation Logic** | Same (pipe delimiter) | Same (pipe delimiter) |
| **Implementation** | `cl_ptf_bo_rap_generic` | `cl_ptf_rap_modify_executor` |
| **When Used** | Traditional PTF actions | EML operations array |

## Examples

### Single Key Field
- Entity: `I_NoteBasicTP`
- Key: `NoteBasicUUID`
- document_id: `42010AEF83EE1FE0BCE4BDE0DDB24D36` (no delimiter, single key)

### Two Key Fields
- Entity: `I_ProductionSupplyAreaTP`
- Keys: `ProductionSupplyArea`, `ProductionSupplyAreaVersion`
- Values: `TEST_ARE01`, `0001`
- document_id: `TEST_ARE01|0001`

### Three Key Fields
- Entity: `I_SalesOrderItemTP`
- Keys: `SalesOrder`, `SalesOrderItem`, `Language`
- Values: `0000000001`, `000010`, `EN`
- document_id: `0000000001|000010|EN`

## Testing in PTF

1. Open `/n/ptf/run` in ERX/001
2. Create test step:
   - **Business Object**: Entity with compound keys (e.g., `I_PRODUCTIONSUPPLYAREATP`)
   - **Action**: CREATE, UPDATE, or DELETE (not MODIFY)
   - **JSON File**: Traditional format with `fields` array
3. Execute and check Application Log:
   - CREATE: `Root Entity ... has %PID: ...` or extracted from MAPPED
   - UPDATE/DELETE: Extracted from test data
4. View result table:
   - **Column**: `DOCUMENT_ID`
   - **Value**: Concatenated keys with pipe delimiter

## Code References

- **Main class**: [cl_ptf_bo_rap_generic.clas.abap](../src/cl_ptf_bo_rap_generic.clas.abap)
- **CREATE**: Lines 918-929
- **UPDATE (CHANGE)**: Inherits from `cl_ptf_bo->change()` → calls `operation(op-m-update)`
- **DELETE**: Lines 932-943
- **Document ID extraction**: Lines 1782-1929
- **Key concatenation**: Lines 2000-2007, 2234-2241, 2269-2277
- **Metadata**: [cl_ptf_rap_metadata.clas.abap](../src/rap/cl_ptf_rap_metadata.clas.abap)
- **Delimiter constant**: [cl_ptf_util.clas.abap](../src/util/cl_ptf_util.clas.abap) line 144

## See Also

- [COMPOUND_KEYS.md](COMPOUND_KEYS.md) - RAP operations within MODIFY action
- [PTF_INTERNALS.md](PTF_INTERNALS.md) - General PTF architecture
- [RAP_MODIFY_EXAMPLES.md](RAP_MODIFY_EXAMPLES.md) - MODIFY action examples
- [EML_MODIFY.md](EML_MODIFY.md) - MODIFY action JSON format
