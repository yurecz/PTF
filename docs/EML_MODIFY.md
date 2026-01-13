# RAP EML MODIFY ENTITIES (Dynamic Form)

This document summarizes the ABAP EML dynamic form of `MODIFY ENTITIES ... OPERATIONS` and its input model.
It is intended to guide the PTF `MODIFY` action implementation and JSON payload mapping.

## Dynamic form syntax

```
MODIFY ENTITIES [IN LOCAL MODE | [FORWARDING] PRIVILEGED]
  OPERATIONS op_tab
  [response_param].
```

## Operations table (`op_tab`)

`op_tab` must be a table of type `ABP_BEHV_CHANGES_TAB` with the following components:

- `op` (mandatory): operation code, set via `IF_ABAP_BEHV` constants (for example `op-m-create`) or literal codes (for example `'C'` for create).
- `entity_name` (mandatory): BO entity name in uppercase.
- `sub_name` (optional): association alias for create-by-association or action name for `EXECUTE`, in uppercase.
- `instances` (mandatory): reference to an internal table (static type `DATA`) holding the instances input.
- `request` (optional): reference to an internal table (static type `DATA`) for requests.
- `results` (optional): reference to an internal table (static type `DATA`) to hold action results.

## Response parameters

`response_param` tables must be typed with `ABP_BEHV_RESPONSE_TAB`.

## Field specification rules for instances tables

Field specification expressions define the input parameters for modify operations.
The internal table used for `instances` must be typed with the correct BDEF-derived type.
The valid field spec expressions and required table components depend on the operation:

### CREATE
- Field spec: `FROM` / `AUTO FILL CID WITH` / `FIELDS (...) WITH` / `SET FIELDS WITH`
- Table type: `TABLE FOR CREATE bdef`
- Components: `%cid`, `%control`, `%data`, `%key`
- Note: for `FROM` and `AUTO FILL CID`, `%control` must be filled explicitly.

### CREATE BY _assoc
- Field spec: `FROM` / `AUTO FILL CID WITH` / `FIELDS (...) WITH` / `SET FIELDS WITH`
- Table type: `TABLE FOR CREATE bdef_assoc`
- Components: `%cid_ref`, `%key`, `%pky`, `%target`, `%tky`
- Note: for `FROM` and `AUTO FILL CID`, `%control` must be filled explicitly inside `%target`.

### UPDATE
- Field spec: `FROM` / `FIELDS (...) WITH` / `SET FIELDS WITH`
- Table type: `TABLE FOR UPDATE bdef`
- Components: `%cid_ref`, `%control`, `%data`, `%key`, `%pky`, `%tky`
- Note: for `FROM`, `%control` must be filled explicitly.

### DELETE
- Field spec: `FROM`
- Table type: `TABLE FOR DELETE bdef`
- Components: `%cid_ref`, `%key`, `%pky`, `%tky`

### EXECUTE (actions)
- Field spec: `FROM`
- Table type: `TABLE FOR ACTION IMPORT bdef~action`
- Components: `%cid_ref`, `%key`, `%param`, `%pky`, `%tky`

## Additional notes

- `IN LOCAL MODE` excludes feature controls and authorization checks; it is only allowed within the RAP BO runtime implementation.
- `PRIVILEGED` requires `privileged` to be specified in the BDEF.

## BO-specific JSON template guidance (draft)

Given a BDEF name in the PTF step (for example `R_LstMiRouteTP`), we can build a BO-specific `MODIFY` JSON template by using the BDEF to list:
- Entities (root + sub-entities) and allowed operations (create/update/delete).
- Actions per entity and their parameter type names.

The template can then be structured so that:
- Data-changing operations use instance-level fields (flat) inside `instances`.
- Actions accept their input fields directly on the operation (mapped to `%param`).
- Keys are provided separately as `key` for update/delete.

Example skeleton for `R_LstMiRouteTP` (BDEF-driven):

```json
[
  {
    "_comment": "JSON MODIFY Example for RAP BO R_LstMiRouteTP",
    "op": "UPDATE",
    "entity": "R_LstMiRouteTP",
    "instances": [
      {
        "key": {
          "LastMileRouteUUID": "..."
        },
        "LastMileRouteDepartureLocation": "..."
      }
    ]
  },
  {
    "op": "CREATE",
    "entity": "R_LstMiRteCheckOutTP",
    "sub_name": "_Load",
    "instances": [
      {
        "LastMileRouteUUID": "...",
        "LastMileRouteCheckOutUUID": "..."
      }
    ]
  },
  {
    "op": "EXECUTE",
    "entity": "R_LstMiRteCheckOutTP",
    "sub_name": "AssignCheckOutLoadRequest",
    "key": {
      "LastMileRouteCheckOutUUID": "..."
    },
    "ParamFieldA": "...",
    "ParamFieldB": "..."
  }
]
```

Notes:
- The BDEF tells us which operations/actions exist per entity, so we only list valid ones.
- For actions, the parameter type name (e.g., `D_LstMiRteAssgChkOutLoadReqP`) must be resolved to a DDIC structure to build the concrete input fields.
- For create/update/delete, the input field list should come from the BDEF derived types or RAP metadata (not from the BDEF text alone).
- Read-only fields must be excluded from the generated input template for the relevant operation.

## Decisions for PTF MODIFY JSON (EML-first)

- **EML-first JSON model:** JSON mirrors `MODIFY ENTITIES ... OPERATIONS` semantics directly (operation + instances) and does not reuse the existing PTF RAP JSON shape.
- **Single semantics for create/update/delete:** Map JSON to the `FROM` variant and always generate `%control` from provided instance fields.
- **Control handling:** `control` is optional in JSON; if absent, the framework sets all instance fields to changed.
- **CID handling:** Users do not provide `%cid`. The framework auto-generates `%cid` for CREATE and wires `%cid_ref` for CREATE BY when parent/child are created in the same request.
- **Action parameters:** Actions map operation-level fields to `%param`, shaped from the action parameter DDIC type.
- **BO-specific templates:** Templates are generated per BDEF, listing only valid operations/actions and excluding read-only fields.
- **Reduced nesting shortcuts:** The canonical shape is an array of operations with `instances[]`, but we allow two shortcuts:
  - Single operation can be expressed as a single object (no array).
  - Single instance can be expressed as `instance` (object) instead of `instances` (array).

## Create-by-association example (CID generated)

In this JSON, the parent instance is created and a child is created by association in the same request.
The `parent_ref` is a local reference used to wire `%cid_ref` internally; users do not provide `%cid` or `%cid_ref`.

```json
[
  {
    "_comment": "CREATE BY association example (CID auto-generated)",
    "op": "CREATE",
    "entity": "R_LstMiRouteTP",
    "instances": [
      {
        "ref": "route-1",
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
        "parent_ref": "route-1",
        "LastMileRouteStopType": "...",
        "LastMileRouteStopSequenceValue": "..."
      }
    ]
  }
]
```

Rules:
- `ref` is set per instance and is only needed when a child needs to reference a parent created in the same payload.
- If instances need different parents, split them into multiple `CREATE_BY` operations (one per parent).
- Use `parent_ref` for parents created in the same payload; for existing parents, use `key` on the child instance.

Single payload example with both cases:

```json
[
  {
    "_comment": "CREATE BY association example (new + existing parent)",
    "op": "CREATE",
    "entity": "R_LstMiRouteTP",
    "instances": [
      {
        "ref": "route-1",
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
        "parent_ref": "route-1",
        "LastMileRouteStopType": "...",
        "LastMileRouteStopSequenceValue": "..."
      }
    ]
  },
  {
    "op": "CREATE_BY",
    "entity": "R_LstMiRouteTP",
    "sub_name": "_Visit",
    "instances": [
      {
        "key": {
          "LastMileRouteUUID": "...existing..."
        },
        "LastMileRouteStopType": "...",
        "LastMileRouteStopSequenceValue": "..."
      }
    ]
  }
]
```

Multi-level create example (root -> Visit -> VisitDlv -> VisitDlvItem):

```json
[
  {
    "op": "CREATE",
    "entity": "R_LstMiRouteTP",
    "instances": [
      { "ref": "route-1", "LastMileRouteType": "...", "LastMileRouteCategory": "..." }
    ]
  },
  {
    "op": "CREATE_BY",
    "entity": "R_LstMiRouteTP",
    "sub_name": "_Visit",
    "instances": [
      { "ref": "visit-1", "parent_ref": "route-1", "LastMileRouteStopType": "...", "LastMileRouteStopSequenceValue": "..." }
    ]
  },
  {
    "op": "CREATE_BY",
    "entity": "R_LstMiRteVisitTP",
    "sub_name": "_CustomerDelivery",
    "instances": [
      { "ref": "dlv-1", "parent_ref": "visit-1", "LastMileRouteDocumentType": "...", "DeliveryDocument": "..." }
    ]
  },
  {
    "op": "CREATE_BY",
    "entity": "R_LstMiRouteVisitCustDlvTP",
    "sub_name": "_Item",
    "instances": [
      { "parent_ref": "dlv-1", "DeliveryDocumentItem": "...", "ProductID": "...", "LastMileRoutePlannedQuantity": "..." }
    ]
  }
]
```

Shortcut examples:

Single operation (single object instead of array):

```json
{
  "op": "UPDATE",
  "entity": "R_LstMiRouteTP",
  "instances": [
    {
      "key": {
        "LastMileRouteUUID": "..."
      },
      "LastMileRouteDepartureLocation": "..."
    }
  ]
}
```

Single instance (no `instances` array):

```json
{
  "op": "UPDATE",
  "entity": "R_LstMiRouteTP",
  "instance": {
    "key": {
      "LastMileRouteUUID": "..."
    },
    "LastMileRouteDepartureLocation": "..."
  }
}
```
