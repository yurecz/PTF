# ABAP Syntax Check - Real Situation

## Summary

**The `/sap/bc/adt/abap/parser` endpoint DOES NOT EXIST in SAP systems.** This was incorrect AI-generated information.

## What Actually Exists

### ADT Discovery Results

From `GET /sap/bc/adt/discovery` on EMO/815:

```xml
<app:collection href="/sap/bc/adt/checkruns">
  <atom:title>Check</atom:title>
  <atom:category term="checkruns" scheme="http://www.sap.com/adt/categories/check"/>
  <adtcomp:templateLinks>
    <adtcomp:templateLink 
      rel="http://www.sap.com/adt/categories/check/relations/reporters" 
      template="/sap/bc/adt/checkruns{?reporters}"/>
  </adtcomp:templateLinks>
</app:collection>

<app:collection href="/sap/bc/adt/checkruns/reporters">
  <atom:title>Reporters</atom:title>
  <atom:category term="reporters" scheme="http://www.sap.com/adt/categories/check"/>
</app:collection>
```

### How `/sap/bc/adt/checkruns` Works

This endpoint requires:
1. **XML Request Body** with object reference
2. **Reporter specification** (e.g., `abapCheckRun`)
3. **Existing object** in the system to check

**Example Request:**
```xml
POST /sap/bc/adt/checkruns?sap-client=815
Content-Type: application/vnd.sap.adt.checkrun+xml

<?xml version="1.0" encoding="UTF-8"?>
<checkrun xmlns="http://www.sap.com/adt/checkrun">
  <objectSet>
    <object uri="/sap/bc/adt/programs/programs/z_my_program" />
  </objectSet>
  <reporters>
    <reporter name="abapCheckRun" />
  </reporters>
</checkrun>
```

**It CANNOT check arbitrary code snippets** - only existing objects.

## How ADT Really Performs Syntax Checks

Eclipse ADT uses a different approach:

### 1. Real-time Check During Editing
- **Implicit check on save**: When you save code via `PUT /sap/bc/adt/programs/{program}/source/main`
- Syntax errors returned in response XML
- No separate syntax check API call needed

### 2. Explicit Check via Activation
- Uses `/sap/bc/adt/activation` endpoint
- Activates object and returns messages
- Still requires existing object

### 3. Check via ATC Integration
- Uses `/sap/bc/adt/checkruns` with ATC reporters
- Comprehensive checks beyond syntax
- Also requires existing objects

## Test Results

### EMO/815 System
```
POST /sap/bc/adt/abap/parser?sap-client=815
Status: 404
Message: "Ressource /sap/bc/adt/abap/parser existiert nicht"
```

### ERX/815 System
Unable to test (authentication issues), but same endpoint structure expected.

## Alternatives for Syntax Checking

### 1. **abaplint** (Recommended)
- Client-side ABAP parser
- No system connection needed
- Fast, offline checking
- https://github.com/abaplint/abaplint

### 2. **Create Temp Object Pattern**
```python
# Pseudo-code
1. Create temp program (Z_TEMP_CHECK_<UUID>)
2. Save source code to it
3. Activate and check for errors
4. Delete temp program
```

### 3. **ABAP Compiler API** (System-Specific)
- Some systems may have internal APIs
- Not part of standard ADT
- Check with basis team

### 4. **Runtime Check**
- Generate code dynamically
- Try to execute in isolated environment
- Catch compilation errors

## Conclusion

**There is NO standard ADT API for checking arbitrary ABAP code without objects.**

The implementation in this repository (`abap.checkSyntax` MCP tool) is based on incorrect information and **does not work**.

## Implementation Status

### What Was Implemented (Non-Functional)
- ✅ `http.py` - POST function (works, but endpoint wrong)
- ✅ `adt.py` - `check_syntax()` function (implemented, but endpoint doesn't exist)
- ✅ `server.py` - MCP tool registration (registered, but not functional)
- ✅ Documentation created (now updated with reality)

### What Should Be Done
- ❌ Remove the non-working `abap.checkSyntax` tool OR
- ✅ Document it as non-functional with explanation OR  
- ✅ Implement alternative using temp object pattern OR
- ✅ Integrate abaplint for client-side checking

## References

- ADT Discovery API: `/sap/bc/adt/discovery`
- ADT Check Service: `/sap/bc/adt/checkruns` (requires object context)
- Eclipse ADT: Real-time checks via save/activation endpoints
- abaplint: https://github.com/abaplint/abaplint
