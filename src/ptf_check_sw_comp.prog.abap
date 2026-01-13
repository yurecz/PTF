*&---------------------------------------------------------------------*
*& Report PTF_CHECK_SW_COMP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ptf_check_sw_comp.

"is_devc_existing_and_editable in this system?  Note that the answer is system-specific, NOT client-specific

TYPES:
  BEGIN OF ty_s_devc,
    devc              TYPE devclass,
    srcsystem         TYPE srcsystem,
    dlvunit           TYPE dlvunit,  "from TADIR of package
    dlvunit_tdevc     TYPE dlvunit,  "from TDEVC of package
    is_existing	      TYPE abap_bool,
    is_not_editable	  TYPE abap_bool,
    is_restricted     TYPE abap_bool,
    is_not_changeable TYPE abap_bool,
  END OF ty_s_devc.

CONSTANTS: lc_package_cloud_home   TYPE devclass VALUE 'PTF'.                 "SWC SAPPCORE_H
CONSTANTS: lc_package_onprem_home  TYPE devclass VALUE 'APPL_FIN_TEST_MIG'.   "SWC SAPOCORE_H
CONSTANTS: lc_package_old_home     TYPE devclass VALUE 'ERP_SD_HOME_RETURNS'. "SWC HOME

*DATA:
*  lv_existing  TYPE abap_bool,       "'X' - DEVC is existing
*  lv_editable  TYPE abap_bool.       "'X' - namespace of DEVC is editable
DATA ls_devc TYPE ty_s_devc.
DATA lt_devc TYPE STANDARD TABLE OF ty_s_devc.
DATA gt_dlvunit               TYPE trdlvunits.   "value in 'changeable' comes from db table DLV_SYSTC
DATA gt_namespaces            TYPE trnsp_namespaces.


WRITE: 'System:', sy-sysid, sy-mandt, /.


"CLOUD HOME
APPEND VALUE #( devc = '-- CLOUD HOME ----' ) TO lt_devc.

PERFORM check_package USING lc_package_cloud_home CHANGING ls_devc.
APPEND ls_devc TO lt_devc.

PERFORM check_package USING 'FINS_FAA_MD_S4HOME' CHANGING ls_devc.  "FIN: ER9
APPEND ls_devc TO lt_devc.

"OP HOME
APPEND VALUE #( devc = '-- OP HOME -------' ) TO lt_devc.

PERFORM check_package USING lc_package_onprem_home CHANGING ls_devc. "editable in ER9
APPEND ls_devc TO lt_devc.

PERFORM check_package USING 'HOME_FIN_FCLM' CHANGING ls_devc.   "?  PTF BO exists
APPEND ls_devc TO lt_devc.

PERFORM check_package USING 'HOME_VDM' CHANGING ls_devc.   "?       just chosen randomly
APPEND ls_devc TO lt_devc.

PERFORM check_package USING 'CNV_OBJ_REP_STRUCT' CHANGING ls_devc.   "not editable in ER9?
APPEND ls_devc TO lt_devc.

PERFORM check_package USING 'HOME_RETAIL_S4HANA' CHANGING ls_devc.   "not editable in ER9?
APPEND ls_devc TO lt_devc.



"non home, prod
APPEND VALUE #( devc = '-- EMO & not home at all ---------' ) TO lt_devc.

PERFORM check_package USING 'CTE_HCM_GDPR_IMP' CHANGING ls_devc.   "EMO: S4COREOP concur?   nicht home sondern prod    SESA-'Transport Layer for ECC-SE/S4COREOP'
APPEND ls_devc TO lt_devc.


"HOME
APPEND VALUE #( devc = '-- HOME ---------' ) TO lt_devc.

PERFORM check_package USING lc_package_old_home CHANGING ls_devc.
APPEND ls_devc TO lt_devc.

PERFORM check_package USING 'CRMS4_PTF_HOME' CHANGING ls_devc. "CRM: ER1
APPEND ls_devc TO lt_devc.

PERFORM check_package USING 'PTF_LMD_ROUTE' CHANGING ls_devc.  "ER9, OP focus
APPEND ls_devc TO lt_devc.







LOOP AT lt_devc INTO DATA(ls_result).
  PERFORM output USING ls_result.
ENDLOOP.

CHECK gt_dlvunit is not initial.
CHECK gt_namespaces is not initial.

"EOP
*-------------------------------------------------------------------




FORM check_package
  USING
    iv_devc TYPE devclass
  CHANGING
    cs_devc TYPE ty_s_devc .

  DATA ls_tdevc                 TYPE tdevc.


  CLEAR cs_devc.

  CALL FUNCTION 'TRINT_DEVCLASS_GET'
    EXPORTING
      iv_devclass        = iv_devc
    IMPORTING
      es_tdevc           = ls_tdevc
    EXCEPTIONS
      devclass_not_found = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
    cs_devc-devc = iv_devc.
    RETURN.
  ENDIF.

  ASSERT ls_tdevc-devclass EQ iv_devc.
  cs_devc-devc = ls_tdevc-devclass.
  cs_devc-is_existing = abap_true.

  SELECT SINGLE srcsystem, component FROM tadir INTO ( @cs_devc-srcsystem , @cs_devc-dlvunit ) WHERE
    pgmid = 'R3TR' AND  object = 'DEVC' AND
    obj_name = @iv_devc .
  ASSERT sy-subrc IS INITIAL.

  SELECT SINGLE dlvunit FROM tdevc INTO @cs_devc-dlvunit_tdevc WHERE devclass = @iv_devc .
  ASSERT sy-subrc IS INITIAL.

  ASSERT NOT ( cs_devc-dlvunit_tdevc IS INITIAL AND cs_devc-dlvunit IS NOT INITIAL ).




  "Check if system is editable


  "If RESTRICTED is set, no further objects could be added to the package
  "-> consider it as not editable
  IF ls_tdevc-restricted IS NOT INITIAL.
*    cs_devc-is_editable = 'R'. "not editable as it is restricted
    cs_devc-is_restricted = 'X'. "not editable as it is restricted
*      RETURN.
  ENDIF.
*  DATA ls_dlvunit               TYPE trdlvunit.
  DATA lt_dlvunit               TYPE trdlvunits.
  DATA lt_namespaces            TYPE trnsp_namespaces.
  DATA lv_obj_name              TYPE tadir-obj_name.
  lv_obj_name = iv_devc.
  " Call this Function Module if we want to check
  " the modifiability of the namespace (development class)
  " and software component
  CALL FUNCTION 'TRINT_CHECK_NSP_OBJ_DU_EDIT'
    EXPORTING
      iv_mode                       = 'M'
      iv_pgmid                      = 'R3TR'
      iv_object                     = 'DEVC'
      iv_obj_name                   = lv_obj_name
      iv_devclass                   = iv_devc
*     IV_TDEVC_FILLED               = ' '
*     IV_PATTERN_OBJ                = ' '
*     IV_GENFLAG                    = ' '
      iv_check_editflag             = 'X'
    IMPORTING
      et_namespaces                 = lt_namespaces   "same result for all clients
      et_dlvunits                   = lt_dlvunit      "value in 'changeable' comes from db table DLV_SYSTC
    EXCEPTIONS
      object_inconsistent           = 1
      genflag_required              = 2
      missing_input                 = 3
      system_error                  = 4
      no_du_changeable              = 5 "et_namespaces and et_dlvunits are not set when this is raised
      no_authority_change_component = 6
      OTHERS                        = 7.
  IF sy-subrc EQ 5.
    cs_devc-is_not_changeable = 'X'. "not editable as per db table DLV_SYSTC
  ELSEIF sy-subrc <> 0.
    WRITE: / 'Exception for ', iv_devc, ':', sy-subrc.
*      RETURN.
  ENDIF.
  APPEND LINES OF lt_dlvunit TO gt_dlvunit.
  APPEND LINES OF lt_namespaces TO gt_namespaces.


  DATA lv_sysedit               TYPE tadir-edtflag.
  DATA lv_cliedit               TYPE cccoractiv.
  DATA lv_cliindedit            TYPE ccnocliind.

  CALL FUNCTION 'TR_SYS_PARAMS'
    IMPORTING
      systemedit         = lv_sysedit
      system_client_edit = lv_cliedit
      sys_cliinddep_edit = lv_cliindedit
    EXCEPTIONS
      no_systemname      = 1
      no_systemtype      = 2
      OTHERS             = 3.
  IF sy-subrc      NE 0   OR
     lv_sysedit    EQ 'N' OR
     lv_cliindedit EQ '2' OR
     lv_cliindedit EQ '3' OR
     lv_cliedit    EQ '2'.

    IF lv_sysedit    EQ 'N'.
      CHECK 1 = 1.
    ENDIF.
    IF lv_cliindedit EQ '2' OR lv_cliindedit EQ '3'.
      CHECK 1 = 1.
    ENDIF.
    IF lv_cliedit    EQ '2'.
      CHECK 1 = 1.
    ENDIF.

    cs_devc-is_not_editable = abap_true. "due to FM TR_SYS_PARAMS
*    RETURN.
  ENDIF.


ENDFORM.

FORM output USING is_devc TYPE ty_s_devc.

  IF is_devc-devc(1) EQ '-'.
    SKIP.
    WRITE: / is_devc-devc, '-----------------------------------------------------------------------------------------------------------------------------------------------------------'.
    RETURN.
  ENDIF.

  WRITE: / is_devc-devc, ':'.

  IF is_devc-is_existing IS INITIAL.
    WRITE: 'not found'.
    RETURN.
  ENDIF.

  WRITE: ' SW Comp "',
  "is_devc-dlvunit ,'/',
  is_devc-dlvunit_tdevc, '"with SRCSYSTEM "', is_devc-srcsystem ,
  "'"of Package "', is_devc-devc,
  '" is:'.
  IF is_devc-is_not_editable EQ abap_true.
    WRITE: 'NOT editable.'.
  ENDIF.
  IF is_devc-is_restricted EQ abap_true.
    WRITE: ' restricted.'.
  ENDIF.
  IF is_devc-is_not_changeable EQ abap_true.
    WRITE: ' not changeable.'.
  ENDIF.

  IF is_devc-is_not_editable NE abap_true AND is_devc-is_restricted NE abap_true AND is_devc-is_not_changeable NE abap_true.
    WRITE: 'editable.'.
  ENDIF.

ENDFORM.
