# PTF MODIFY Action - Specification and Examples

This document describes the PTF MODIFY action JSON format and provides tested examples.

## Overview

PTF MODIFY action directly maps to RAP's `MODIFY ENTITIES ... OPERATIONS` EML statement, accepting an operations array that specifies CREATE, UPDATE, DELETE, EXECUTE, and CREATE_BY operations.

## JSON Format

```json
[
  {
    "op": "CREATE|UPDATE|DELETE|EXECUTE|CREATE_BY",
    "entity": "ENTITY_NAME",
    "sub_name": "ASSOCIATION_NAME",
    "instances": [
      {
        "field1": "value1",
        "%CID": "unique-id",
        "%CID_REF": "parent-id"
      }
    ]
  }
]
```

### Operation Types

**CREATE**
- Creates new entity instances
- Auto-generates `%CID` if omitted (format: `AUTO-YYYYMMDD-HHMMSS-counter`)
- Use `%CID` when child entities need to reference this parent in same request

**CREATE_BY** (Create by Association)
- Creates child entities via association
- Requires `sub_name` field with association name
- Use `%CID_REF` to reference parent created in same request
- Use direct key fields to reference existing parent

**UPDATE**
- Updates existing entity instances
- Key fields specified directly (not in `%pky` wrapper)
- Key fields used for identification only, NOT marked in `%control`
- Only non-key fields are marked for modification

**DELETE**
- Deletes entity instances
- Requires key fields for identification

**EXECUTE** (Actions)
- Executes entity actions
- Requires `sub_name` field with action name
- Action parameters specified at operation level

### Field Specifications

**Key Fields:**
- Specified directly in instances (no wrapper)
- Used for record identification in UPDATE/DELETE
- NOT marked for modification in `%control`
- Automatically detected via `cl_ptf_rap_metadata->get_key_fields()`

**UUID Fields:**
- Must use x16 format (32 hex characters, no hyphens)
- Example: `"NOTEBASICUUID": "42010AEF83EE1FE0BCE4BDE0DDB24D36"`

**%CID (Content ID):**
- Optional for CREATE operations
- Auto-generated if omitted
- Required when child entities reference parent in same request

**%CID_REF (Parent Reference):**
- Used in CREATE_BY to reference parent's %CID
- Only for parents created in same request
- For existing parents, use direct key fields

### Shortcuts

**Single Operation:**
```json
{
  "op": "UPDATE",
  "entity": "R_LstMiRouteTP",
  "instances": [...]
}
```

**Single Instance:**
```json
{
  "op": "UPDATE",
  "entity": "R_LstMiRouteTP",
  "instance": {...}
}
```

## Examples

### Example 1: Note Creation (Tested)

**Entity:** `I_NoteBasicTP`

**JSON:**
```json
[
  {"_comment": "JSON MODIFY Example for RAP BO I_NoteBasicTP - see docs/EML_MODIFY.md for full syntax"},
  {
    "op": "CREATE",
    "entity": "I_NoteBasicTP",
    "instances": [
      {
        "%CID": "new-1",
        "NOTEBASICOBJECTNODETYPE": "SOURCINGPROJECT",
        "NOTEBASICOBJECT": "19BBB21A28891EEF9DCE88CC2CD4424B",
        "NOTEBASICTYPE": "SRCGPROJNOTE",
        "NOTEBASICLANGUAGE": "EN",
        "NoteBasicContent": "Test Content",
        "_comment": "...add more fields as needed"
      }
    ]
  }
]
```

**Result:** Note created successfully, document ID extracted from PID_MAPPED after COMMIT.

### Example 2: Create by Association

Multi-level hierarchy creation (Route → Visit → Delivery → Item):

```json
[
  {
    "op": "CREATE",
    "entity": "R_LstMiRouteTP",
    "instances": [
      { 
        "%CID": "route-1", 
        "LastMileRouteType": "...", 
        "LastMileRouteCategory": "..." 
      }
    ]
  },
  {
    "op": "CREATE_BY",
    "entity": "R_LstMiRouteTP",
    "sub_name": "_Visit",
    "instances": [
      { 
        "%CID": "visit-1", 
        "%CID_REF": "route-1", 
        "LastMileRouteStopType": "...", 
        "LastMileRouteStopSequenceValue": "..." 
      }
    ]
  },
  {
    "op": "CREATE_BY",
    "entity": "R_LstMiRteVisitTP",
    "sub_name": "_CustomerDelivery",
    "instances": [
      { 
        "%CID": "dlv-1", 
        "%CID_REF": "visit-1", 
        "LastMileRouteDocumentType": "...", 
        "DeliveryDocument": "..." 
      }
    ]
  },
  {
    "op": "CREATE_BY",
    "entity": "R_LstMiRouteVisitCustDlvTP",
    "sub_name": "_Item",
    "instances": [
      { 
        "%CID_REF": "dlv-1", 
        "DeliveryDocumentItem": "...", 
        "ProductID": "...", 
        "LastMileRoutePlannedQuantity": "..." 
      }
    ]
  }
]
```

**Key Points:**
- Each child references its parent via `%CID_REF`
- Parent entities need `%CID` only if referenced by children
- Leaf entities (no children) don't need `%CID`

### Example 3: UPDATE with Direct Key Specification

```json
{
  "op": "UPDATE",
  "entity": "R_LstMiRouteTP",
  "instances": [
    {
      "LastMileRouteUUID": "...",
      "LastMileRouteDepartureLocation": "..."
    }
  ]
}
```

**Key Points:**
- `LastMileRouteUUID` is the key field (for identification)
- Key field NOT marked in `%control`
- Only `LastMileRouteDepartureLocation` is updated

## EML Background

PTF MODIFY maps to RAP's dynamic EML form:

```abap
MODIFY ENTITIES OPERATIONS op_tab
  FAILED DATA(lt_failed)
  MAPPED DATA(lt_mapped)
  REPORTED DATA(lt_reported).

COMMIT ENTITIES
  REPORTED DATA(lt_reported_commit).
```

**Operations Table Structure (`ABP_BEHV_CHANGES_TAB`):**
- `op`: Operation code (via `IF_ABAP_BEHV` constants)
- `entity_name`: BO entity name (uppercase)
- `sub_name`: Association name (CREATE_BY) or action name (EXECUTE)
- `instances`: Reference to typed table with instance data
- `request`, `results`: Optional for actions

**Response Tables (`ABP_BEHV_RESPONSE_TAB`):**
- `FAILED`: Validation/execution failures
- `MAPPED`: Created instance keys (with %PID for late numbering)
- `REPORTED`: Messages and diagnostics

**Document ID Extraction:**
1. MODIFY ENTITIES returns %PID (preliminary ID) in MAPPED
2. COMMIT ENTITIES converts %PID to real keys
3. PTF extracts from PID_MAPPED (primary) or MAPPED (fallback)
4. Compound keys concatenated with `|` delimiter

## Implementation

- Code location: [cl_ptf_rap_modify_executor.clas.abap](../src/rap/cl_ptf_rap_modify_executor.clas.abap)
- Deserialization: Lines 350-610 (deserialize_json method)
- Document ID extraction: Lines 607-700 (extract_document_ids method)
- Template generation: [cl_ptf_rap_modify_template.clas.abap](../src/rap/cl_ptf_rap_modify_template.clas.abap)

## Testing

1. Open `/n/ptf/run` in ERX/815
2. Create test step:
   - Business Object: RAP entity (e.g., `I_NOTEBASICTP`)
   - Action: `MODIFY`
   - JSON File: Use examples above
3. Execute and check Application Log for:
   - `Processing operation: CREATE/UPDATE/DELETE`
   - `Executed/committed without EML error`
   - `Extracted document ID: ...`

## References

- Implementation: [cl_ptf_rap_modify_executor.clas.abap](../src/rap/cl_ptf_rap_modify_executor.clas.abap)
- Template generation: [cl_ptf_rap_modify_template.clas.abap](../src/rap/cl_ptf_rap_modify_template.clas.abap)
- PTF Architecture: [PTF_INTERNALS.md](PTF_INTERNALS.md)
- Established PTF actions: [PTF_ACTIONS_COMPOUND_KEYS.md](PTF_ACTIONS_COMPOUND_KEYS.md)