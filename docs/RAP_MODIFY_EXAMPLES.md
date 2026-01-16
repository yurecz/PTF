# RAP MODIFY Action - Working Examples (ERX/001)

**⚠️ Development Status**: MODIFY action is under active development. These examples reflect the current implementation but may require adjustments after system testing.

Simplified working examples for the RAP MODIFY action in ERX/001 system.

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

**Key Fields:**
- **%CID**: Content ID for CREATE operations (auto-generated if omitted)
- **%CID_REF**: References parent %CID for CREATE_BY operations
- **Direct key specification**: For UPDATE/DELETE, key fields can be specified directly in instances (not wrapped in %pky). Keys identify the record but are NOT marked for modification in %control.
- **UUID format**: UUID key fields must use x16 format (32 hex characters without hyphens, e.g., `42010AEF83EE1FE0BCE4BDE0DDB24D36`)

## Example 1: Sales Order - CREATE with Items

**Entity:** `I_SalesOrderTP`

**JSON:**
```json
[
  {
    "op": "CREATE",
    "entity": "I_SalesOrderTP",
    "instances": [
      {
        "%CID": "so-001",
        "SalesOrderType": "OR",
        "SalesOrganization": "1010",
        "DistributionChannel": "10",
        "OrganizationDivision": "00",
        "SoldToParty": "1000001"
      }
    ]
  },
  {
    "op": "CREATE_BY",
    "entity": "I_SalesOrderTP",
    "sub_name": "_ITEM",
    "instances": [
      {
        "%CID_REF": "so-001",
        "%CID": "item-001",
        "Material": "TG11",
        "RequestedQuantity": "5",
        "RequestedQuantityUnit": "EA"
      }
    ]
  }
]
```

**Result:** Sales Order created with one item, document ID returned (e.g., `0000000123`)

## Example 2: Note Creation

**Entity:** `I_NoteBasicTP`

**JSON:**
```json
[
  {"_comment": "Comments are automatically skipped - no 'op' field"},
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
        "NoteBasicContent": "Test Content"
      }
    ]
  }
]
```

**Result:** Note created for sourcing project, Note GUID returned from PID_MAPPED

## Example 3: Note Update (Direct Key Specification)

**Entity:** `I_NoteBasicTP`

**JSON:**
```json
[
  {"_comment": "UPDATE with direct key specification - key used for identification, NOT marked for update in %control"},
  {
    "op": "UPDATE",
    "entity": "I_NoteBasicTP",
    "instances": [
      {
        "NOTEBASICUUID": "42010AEF83EE1FE0BCE4BDE0DDB24D36",
        "NOTEBASICCOMMENT": "Updated comment text"
      }
    ]
  }
]
```

**Notes:**
- `NOTEBASICUUID` is the key field - used to identify which note to update
- Key field is NOT marked for modification in `%control`
- Only `NOTEBASICCOMMENT` is actually updated
- **UUID format**: UUID key fields must use x16 format (32 hex characters without hyphens, e.g., `42010AEF83EE1FE0BCE4BDE0DDB24D36`)

## Testing in PTF

1. Open `/n/ptf/run` in ERX/001
2. Create test case with:
   - Business Object: `I_SalesOrderTP` or `I_NoteBasicTP`
   - Action: `MODIFY`
   - JSON File: Copy JSON from examples above
3. Execute and check logs for:
   - `Processing operation: CREATE`
   - `Executed/committed without EML error`
   - `Extracted document ID: NNNNNNNNNN`

## Example 4: Compound Keys (Multiple Key Components)

**Context:** RAP operations (UPDATE, DELETE) within PTF MODIFY action

Entity with multiple key fields: `I_ProductionSupplyAreaTP`
- Key fields: `ProductionSupplyArea` + `ProductionSupplyAreaVersion`

**MODIFY Action JSON (with RAP operations):**
```json
[
  {
    "op": "UPDATE",
    "entity": "I_ProductionSupplyAreaTP",
    "instances": [
      {
        "ProductionSupplyArea": "TEST_ARE01",
        "ProductionSupplyAreaVersion": "0001",
        "ProductionSupplyAreaName": "Updated Area Name",
        "ProductionSupplyAreaIsActive": true
      }
    ]
  },
  {
    "op": "DELETE",
    "entity": "I_ProductionSupplyAreaTP",
    "instances": [
      {
        "ProductionSupplyArea": "TEST_ARE02",
        "ProductionSupplyAreaVersion": "0001"
      }
    ]
  }
]
```

**Compound Key Behavior:**
- **All key components must be specified** for RAP UPDATE/DELETE operations (within MODIFY)
- Key fields used for record identification only (NOT modified in RAP UPDATE)
- `%control` marks only non-key fields (`ProductionSupplyAreaName`, `ProductionSupplyAreaIsActive`)
- EML runtime automatically combines key fields into `%key`/`%tky` structure
- PTF stores document_id as concatenated string: `"TEST_ARE01|0001"` (for internal reference using pipe delimiter)
- Order of key fields in JSON doesn't matter (matched by name, not position)

**Example with two-field keys from test data:**
- Entity: `R_PRODUCTIONSUPPLYAREATP`
- Key 1: `ProductionSupplyArea = "TEST_ARE01"`
- Key 2: `ProductionSupplyAreaType = "0001"`
- Result document_id: `"TEST_ARE01|0001"`

## Document ID Extraction

- **PID_MAPPED (Primary)**: Real keys after COMMIT (for late numbering entities)
- **MAPPED (Fallback)**: Direct keys (for early numbering entities)

## References

- Implementation: `src/rap/cl_ptf_rap_modify_executor.clas.abap`
- JSON Format: `docs/EML_MODIFY.md`

