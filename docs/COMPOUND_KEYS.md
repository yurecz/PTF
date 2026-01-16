# Compound Keys in PTF MODIFY Action

## ⚠️ Development Status

**MODIFY is under active development** - This documentation describes the current implementation approach, which may change as we validate and refine the feature.

## Summary

This document explains compound key handling for **RAP operations within the PTF MODIFY action**.

**Important Distinction:**
- **PTF Actions**: CREATE, UPDATE, DELETE, EXECUTE (established) + **MODIFY** (under development)
- **RAP Operations**: CREATE, UPDATE, DELETE, EXECUTE - Low-level EML operations inside MODIFY's `operations` array
- **This document covers**: RAP operations (op: "CREATE", op: "UPDATE", etc.) within PTF MODIFY action

When a RAP Business Object entity has **multiple key components** (compound key), PTF handles them transparently. All key fields must be specified individually in JSON, but PTF concatenates them internally for document tracking purposes.

## Key Delimiter

```abap
cl_ptf_util=>gc_key_field_delimiter = '|'  "Pipe character
```

All compound keys are concatenated using the pipe `|` delimiter.

## RAP CREATE Operation (within MODIFY) with Compound Keys

**Example Entity:** `I_ProductionSupplyAreaTP`
- Key Field 1: `ProductionSupplyArea`
- Key Field 2: `ProductionSupplyAreaVersion`

**MODIFY Action JSON with RAP CREATE Operation:**
```json
{
  "op": "CREATE",
  "entity": "I_ProductionSupplyAreaTP",
  "instances": [{
    "ProductionSupplyArea": "TEST_ARE01",
    "ProductionSupplyAreaVersion": "0001",
    "ProductionSupplyAreaName": "Test Area"
  }]
}
```

**Processing Flow:**
1. PTF deserializes JSON and creates EML structure
2. Both key fields assigned to structure:
   ```abap
   <fs_instance>-ProductionSupplyArea = 'TEST_ARE01'.
   <fs_instance>-ProductionSupplyAreaVersion = '0001'.
   ```
3. EML runtime automatically populates `%key` with both values
4. `MODIFY` executed → record created
5. `COMMIT ENTITIES` returns both keys in `MAPPED` table
6. PTF concatenates keys for document_id: `"TEST_ARE01|0001"`

## RAP UPDATE Operation (within MODIFY) with Compound Keys

**MODIFY Action JSON with RAP UPDATE Operation:**
```json
{
  "op": "UPDATE",
  "entity": "I_ProductionSupplyAreaTP",
  "instances": [{
    "ProductionSupplyArea": "TEST_ARE01",
    "ProductionSupplyAreaVersion": "0001",
    "ProductionSupplyAreaName": "Updated Name"
  }]
}
```

**Processing Flow:**
1. `get_key_fields()` returns: `[ProductionSupplyArea, ProductionSupplyAreaVersion]`
2. Field mapping loop processes each field:
   - `ProductionSupplyArea`: Assigned to structure, SKIPPED in %control (is_key_field = true)
   - `ProductionSupplyAreaVersion`: Assigned to structure, SKIPPED in %control (is_key_field = true)
   - `ProductionSupplyAreaName`: Assigned to structure, MARKED in %control (is_key_field = false)
3. Result EML structure:
   ```abap
   <fs_instance>-ProductionSupplyArea = 'TEST_ARE01'.
   <fs_instance>-ProductionSupplyAreaVersion = '0001'.
   <fs_instance>-ProductionSupplyAreaName = 'Updated Name'.
   <fs_control>-ProductionSupplyAreaName = if_abap_behv=>mk-on.
   " Note: Key fields NOT in %control
   ```
4. EML runtime extracts keys → populates `%key`/`%tky` → identifies record
5. Only `ProductionSupplyAreaName` updated (marked in %control)

## RAP DELETE Operation (within MODIFY) with Compound Keys

**MODIFY Action JSON with RAP DELETE Operation:**
```json
{
  "op": "DELETE",
  "entity": "I_ProductionSupplyAreaTP",
  "instances": [{
    "ProductionSupplyArea": "TEST_ARE01",
    "ProductionSupplyAreaVersion": "0001"
  }]
}
```

**Processing Flow:**
1. Both key fields assigned to DELETE structure
2. EML runtime extracts to `%key`/`%tky`
3. Record identified and deleted

## Document ID Extraction Logic

From `cl_ptf_rap_modify_executor->extract_document_ids()`:

```abap
" Get key field metadata
DATA(lt_components) = cl_ptf_rap_metadata->get_key_fields( iv_name = entity_name ).

" Loop through MAPPED/PID_MAPPED entries
LOOP AT mapped_table ASSIGNING <fs_entry>.
  CLEAR lv_ptf_key.
  
  " Concatenate all key components
  LOOP AT lt_components ASSIGNING <fs_component>.
    DATA(lv_tabix) = sy-tabix.
    ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_entry> TO <fs_field>.
    
    IF sy-subrc = 0.
      IF lv_tabix = 1.
        lv_ptf_key = <fs_field>.              " First key: TEST_ARE01
      ELSE.
        " Concatenate with delimiter
        lv_ptf_key = |{ lv_ptf_key }{ cl_ptf_util=>gc_key_field_delimiter }{ <fs_field> }|.
        " Result: TEST_ARE01|0001
      ENDIF.
    ENDIF.
  ENDLOOP.
  
  " Filter temporary keys (%PID, %CID)
  IF lv_ptf_key NA '$%'.
    " Store concatenated key
    APPEND VALUE #( key = lv_ptf_key ) TO lt_document_ids.
  ENDIF.
ENDLOOP.
```

## Key Concatenation Examples

| Entity | Key Components | Values | document_id |
|--------|---------------|--------|-------------|
| `R_PRODUCTIONSUPPLYAREATP` | `ProductionSupplyArea`, `ProductionSupplyAreaType` | `TEST_ARE01`, `0001` | `TEST_ARE01\|0001` |
| `I_BusinessAreaText` | `BusinessArea`, `Language` | `9999`, `EN` | `9999\|EN` |
| `I_NoteBasicTP` | `NoteBasicUUID` | `42010AEF83EE1FE0BCE4BDE0DDB24D36` | `42010AEF83EE1FE0BCE4BDE0DDB24D36` |

## Important Rules

### ✅ Required Behavior
- **All key components MUST be specified** in JSON for RAP UPDATE/DELETE operations (within MODIFY)
- Key fields used for identification only (never modified in RAP UPDATE)
- Order doesn't matter - EML matches by field name, not position
- PTF automatically detects and handles compound keys in MODIFY action

### ❌ Common Mistakes
- ❌ Confusing PTF actions with RAP operations: This applies to RAP operations within MODIFY, not PTF CREATE/UPDATE/DELETE actions
- ❌ Missing key components: JSON must include ALL key fields for RAP UPDATE/DELETE
- ❌ Trying to update key fields: Keys excluded from %control, EML won't update them
- ❌ Wrong delimiter in JSON: Don't concatenate keys in JSON (specify individually)
- ❌ Assuming single key: Always check entity metadata for all key components

### ℹ️ Technical Details
- **JSON Level**: All key fields specified individually
- **EML Level**: EML runtime combines into `%key`/`%tky` structures automatically
- **PTF Storage**: Concatenated with `|` delimiter for document_id tracking
- **Reference Steps**: PTF splits document_id by `|` to restore individual values

## Testing Compound Keys

1. Find entity with compound key:
   ```abap
   DATA(lo_metadata) = NEW cl_ptf_rap_metadata( ).
   DATA(lt_keys) = lo_metadata->get_key_fields( iv_name = 'I_PRODUCTIONSUPPLYAREATP' ).
   " Returns 2 components
   ```

2. Create test in `/n/ptf/run`:
   - BO: Entity with compound key
   - **Action: `MODIFY`** (not CREATE/UPDATE/DELETE - those are different PTF actions)
   - JSON: Array of operations, include all key fields for RAP UPDATE/DELETE operations

3. Check logs:
   - `Extracted document ID: KEY1|KEY2|...`
   - Verify concatenation with pipe delimiter

## Code References

- **Key detection**: [cl_ptf_rap_metadata.clas.abap](../src/rap/cl_ptf_rap_metadata.clas.abap)
- **Deserializer**: [cl_ptf_rap_modify_executor.clas.abap](../src/rap/cl_ptf_rap_modify_executor.clas.abap) lines 522-583
- **Extraction**: [cl_ptf_rap_modify_executor.clas.abap](../src/rap/cl_ptf_rap_modify_executor.clas.abap) lines 667-684
- **Delimiter constant**: [cl_ptf_util.clas.abap](../src/util/cl_ptf_util.clas.abap) line 144
- **Commit logic**: [cl_ptf_bo_rap_generic_eml.clas.abap](../src/rap/cl_ptf_bo_rap_generic_eml.clas.abap) lines 120-128

## See Also

- [RAP_MODIFY_EXAMPLES.md](RAP_MODIFY_EXAMPLES.md) - Example 4 shows compound key usage
- [PTF_INTERNALS.md](PTF_INTERNALS.md) - Detailed MODIFY execution flow
- [EML_MODIFY.md](EML_MODIFY.md) - EML syntax reference
