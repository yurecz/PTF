# RAP MODIFY Action - JSON Format Reference

**⚠️ Development Status**: MODIFY action code exists but is **not yet tested in ABAP system**. This document describes the JSON format the code expects, not proven behavior.

## JSON Format (Code Expectation)

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

**Code Facts:**
- Deserialized by `cl_ptf_rap_modify_executor=>deserialize_json()`
- Auto-generates %CID if omitted (format: `AUTO-YYYYMMDD-HHMMSS-counter`)
- Key fields: code checks `cl_ptf_rap_metadata->get_key_fields()` and skips them in %control
- UUID fields: code expects x16 format (32 hex chars, no hyphens)

## Implementation Status

- Code location: [cl_ptf_rap_modify_executor.clas.abap](../src/rap/cl_ptf_rap_modify_executor.clas.abap)
- Deserialization: Lines 350-610 (deserialize_json method)
- Document ID extraction: Lines 607-700 (extract_document_ids method)
- Template generation: [cl_ptf_rap_modify_template.clas.abap](../src/rap/cl_ptf_rap_modify_template.clas.abap)

**Testing Required**: Deploy to ERX/815 and validate actual behavior before documenting working examples.

## References

- JSON Format Spec: [EML_MODIFY.md](EML_MODIFY.md)
- PTF Architecture: [PTF_INTERNALS.md](PTF_INTERNALS.md)