# PTF MODIFY Action - Tested Examples

This document contains tested examples for the PTF MODIFY action.

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

**Key Points:**
- Operations array with `op`, `entity`, `sub_name`, `instances`
- Auto-generates %CID if omitted
- Key fields checked by `cl_ptf_rap_metadata->get_key_fields()` and skipped in %control
- UUID fields: x16 format (32 hex chars, no hyphens)

## Example 1: Note Creation (Tested)

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
3. Execute and check Application Log

## References

- JSON Format Spec: [EML_MODIFY.md](EML_MODIFY.md)
- PTF Architecture: [PTF_INTERNALS.md](PTF_INTERNALS.md)