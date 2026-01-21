# ABAP Syntax Check via ADT API

## ⚠️ CURRENT STATUS: NOT WORKING

**The original endpoint `/sap/bc/adt/abap/parser` does NOT exist** in SAP systems. This was incorrect information from AI.

### What Was Discovered

Through ADT Discovery API (`/sap/bc/adt/discovery`), the **real syntax check endpoint** is:
```
POST /sap/bc/adt/checkruns?reporters={reporter}&sap-client={client}
```

However, this endpoint:
- Requires XML request body with object type/name to check
- Cannot validate arbitrary code snippets
- Works by checking already-created objects in the system

### Conclusion

**ADT syntax check requires object context.** There is no ADT API for checking arbitrary ABAP code snippets without creating objects first.

## Original (Incorrect) Implementation

The MCP server has a non-functional `abap.checkSyntax` tool based on wrong endpoint information.

### Components (Non-Working)

1. **http.py**: Added `post_text()` function for POST requests  
2. **adt.py**: Added `check_syntax()` function using wrong endpoint
3. **server.py**: Added `abap.checkSyntax` MCP tool

### Original (Non-Existent) Endpoint

```
POST /sap/bc/adt/abap/parser?sap-client={client}  ❌ Does not exist
Content-Type: text/plain; charset=utf-8

{ABAP source code}
```

### Response Format

The API returns syntax errors/warnings in XML format (ADT message format with T100 keys):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<messages xmlns="http://www.sap.com/adt/messages">
  <message>
    <type>E</type>
    <shortText>Syntax error message</shortText>
    <atom:link href="..." rel="..." />
    <line>10</line>
    <column>5</column>
  </message>
</messages>
```

## Usage

### MCP Tool

The MCP server exposes `abap.checkSyntax` tool:

**Parameters:**
- `source` (required): ABAP source code to check
- `client` (optional): SAP client (defaults to ABAP_CLIENT env var)
- `insecure` (optional): Skip TLS verification (defaults to false)

**Example:**
```json
{
  "name": "abap.checkSyntax",
  "arguments": {
    "source": "REPORT z_test.\nWRITE: 'Hello World'."
  }
}
```

### Python API

Direct Python usage:

```python
from abap_artifacts.auth import load_credentials
from abap_artifacts.adt import check_syntax

creds = load_credentials(
    base_url='https://ldai1emo.wdf.sap.corp:44300',
    client='815',
    user='PETUKHIN',
    allow_keyring=True
)

result = check_syntax(
    source="REPORT z_test.\nWRITE: 'Hello World'.",
    creds=creds,
    client='815',
    verify_tls=False
)

print('Status:', result.status_code)
print('Messages:', result.text)
```

## Authorization Requirements

Users need the following SAP authorizations:

- **S_DEVELOP**: Object for ABAP Development Workbench
  - ACTVT = 03 (Display), 16 (Execute)
  - OBJTYPE = PROG (or relevant type)
  
- **S_ADT_RES**: Access to ADT resources

## Advantages

1. **No object creation**: Syntax check without creating persistent objects
2. **Fast feedback**: Immediate syntax validation
3. **No activation required**: Check draft code
4. **Version independent**: Works across different ABAP releases

## Use Cases

- Pre-commit syntax validation
- IDE integration for real-time checking
- Automated code quality gates
- Teaching/learning ABAP syntax

## Notes

- The endpoint works with draft/temporary code
- Authentication uses standard ADT credentials
- Response format is XML (can be parsed for structured error handling)
- The parser API is the same one used by Eclipse ADT for real-time syntax checking

## System Compatibility

⚠️ **Important**: The `/sap/bc/adt/abap/parser` endpoint availability is **system-specific**:

- ✅ **Likely available**: SAP BTP ABAP Environment, newer S/4HANA Cloud systems
- ❌ **Not available**: Older on-premise systems (confirmed: ERX/815 on SAP_BASIS 7.50)
- ❓ **Unknown**: Check your system's ADT discovery endpoint

**To verify availability on your system:**
```bash
curl -u USER:PASS "https://YOUR-SYSTEM/sap/bc/adt/discovery?sap-client=XXX" | grep -i parser
```

**If endpoint not available**, consider alternatives:
1. Use activation API (`/sap/bc/adt/activation`) - triggers syntax check
2. Use pretty printer (`/sap/bc/adt/abapsource/prettyprinter`) - validates syntax
3. Use code completion (`/sap/bc/adt/abapsource/codecompletion`) - requires valid syntax

See [SYNTAX_CHECK_TEST_RESULTS.md](SYNTAX_CHECK_TEST_RESULTS.md) for detailed testing information.
