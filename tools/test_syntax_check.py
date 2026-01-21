#!/usr/bin/env python3
"""
Test script for ABAP syntax check MCP capability.

This script demonstrates the syntax check functionality by showing:
1. The function signature and parameters
2. Expected request format
3. Expected response format

To run a real test, ensure credentials are configured:
- ABAP_BASE_URL
- ABAP_CLIENT
- ABAP_USER
- Password via keyring or ABAP_PASSWORD env var
"""

# Example ABAP source code
VALID_ABAP = """REPORT z_test.
DATA lv_text TYPE string.
lv_text = 'Hello World'.
WRITE: / lv_text.
"""

INVALID_ABAP = """REPORT z_test.
DATA lv_text TYPE string.
lv_text = 'Hello World'
WRITE: / lv_text.
"""

def show_usage():
    """Display usage information."""
    print("=" * 70)
    print("ABAP Syntax Check - MCP Tool")
    print("=" * 70)
    print()
    
    print("Function signature:")
    print("-" * 70)
    print("check_syntax(")
    print("    source: str,              # ABAP source code to check")
    print("    creds: Credentials,       # Authentication credentials")
    print("    client: Optional[str],    # SAP client (optional)")
    print("    verify_tls: bool = True   # TLS verification")
    print(") -> FetchResult")
    print()
    
    print("ADT Endpoint:")
    print("-" * 70)
    print("POST /sap/bc/adt/abap/parser?sap-client={client}")
    print("Content-Type: text/plain; charset=utf-8")
    print("Accept: application/xml, text/plain, */*;q=0.1")
    print()
    
    print("Example: Valid ABAP")
    print("-" * 70)
    print(VALID_ABAP)
    print()
    
    print("Example: Invalid ABAP (missing period)")
    print("-" * 70)
    print(INVALID_ABAP)
    print()
    
    print("Expected Response Format (XML):")
    print("-" * 70)
    print("""<?xml version="1.0" encoding="UTF-8"?>
<messages xmlns="http://www.sap.com/adt/messages">
  <message>
    <type>E</type>
    <shortText>Syntax error: period expected</shortText>
    <line>3</line>
    <column>30</column>
  </message>
</messages>""")
    print()
    
    print("MCP Tool Usage:")
    print("-" * 70)
    print("""{
  "name": "abap.checkSyntax",
  "arguments": {
    "source": "REPORT z_test.\\nWRITE: 'Hello World'.",
    "client": "815"
  }
}""")
    print()
    
    print("Required Authorizations:")
    print("-" * 70)
    print("- S_DEVELOP (ACTVT=03,16; OBJTYPE=PROG)")
    print("- S_ADT_RES (Access to ADT resources)")
    print()

if __name__ == "__main__":
    show_usage()
