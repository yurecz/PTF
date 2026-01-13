# ABAP ADT URL patterns (artifact fetching)

These are the typical ABAP Development Tools (ADT) URL patterns used to fetch ABAP artifacts from an ABAP system.

Notes:
- The `#start=...` fragment is an editor cursor hint and is **not** sent to the server; you can ignore it when fetching.
- Most ADT endpoints require authentication (401 otherwise).
- Replace `<BASE_URL>` with something like `https://ldai1emo.wdf.sap.corp:44300`.

## ABAP Class sources

### Main source
Template:
- `<BASE_URL>/sap/bc/adt/oo/classes/<CLASS_NAME>/source/main?version=<active|inactive>&sap-client=<CLIENT>`

Example:
- `https://ldai1emo.wdf.sap.corp:44300/sap/bc/adt/oo/classes/cl_farr_cv_odata_atta_persist/source/main?version=active&sap-client=815`

### Includes
Template:
- `<BASE_URL>/sap/bc/adt/oo/classes/<CLASS_NAME>/includes/<INCLUDE_KIND>?version=<active|inactive>&sap-client=<CLIENT>`

Where `<INCLUDE_KIND>` is typically one of:
- `definitions`
- `implementations`
- `testclasses`
- `macros`

Examples:
- `https://ldai1emo.wdf.sap.corp:44300/sap/bc/adt/oo/classes/cl_farr_cv_odata_atta_persist/includes/implementations?version=active&sap-client=815`
- `https://ldai1emo.wdf.sap.corp:44300/sap/bc/adt/oo/classes/cl_farr_cv_odata_atta_persist/includes/testclasses?version=active&sap-client=815`
- `https://ldai1emo.wdf.sap.corp:44300/sap/bc/adt/oo/classes/cl_im_sdbil_hdm_attach_persist/includes/definitions?version=active&sap-client=815`
- `https://ldai1emo.wdf.sap.corp:44300/sap/bc/adt/oo/classes/cl_im_sdbil_hdm_attach_persist/includes/macros?version=active&sap-client=815`
