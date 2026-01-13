FUNCTION ptf_read_script.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_NAME) TYPE  PTF_VARNAME
*"  EXPORTING
*"     VALUE(ET_VARCON) TYPE  PTF_VARCON_T
*"     VALUE(EV_CLIENT) TYPE  PTF_CLIENT
*"  TABLES
*"      ET_VARID STRUCTURE  PTF_VARID
*"      ET_VARREF STRUCTURE  PTF_VARREF
*"      ET_VARID_T STRUCTURE  PTF_VARID_T
*"      ET_VAREXPMESS STRUCTURE  PTF_VAREXPMESS
*"      ET_VARCAT STRUCTURE  PTF_VARCAT
*"      ET_VAR_TAG_MAP STRUCTURE  PTF_VAR_TAG_MAP
*"  EXCEPTIONS
*"      NOT_FOUND
*"      NOT_AUTHORIZED
*"----------------------------------------------------------------------

  CALL FUNCTION 'TR_AUTHORITY_CHECK_DISPLAY'
    EXCEPTIONS
      OTHERS = 1.
  IF sy-subrc NE 0.
    RAISE not_authorized.
  ENDIF.

  CLEAR: et_varcon, ev_client, et_varid, et_varref, et_varid_t, et_varexpmess, et_varcat, et_var_tag_map.

  ev_client = sy-sysid && sy-mandt.

  SELECT * FROM ptf_varid INTO TABLE et_varid WHERE varname = iv_name.
  IF sy-subrc IS NOT INITIAL.
    RAISE not_found.
  ENDIF.

  SELECT * FROM ptf_varid_t INTO TABLE et_varid_t WHERE varname = iv_name.

  SELECT * FROM ptf_varref INTO TABLE et_varref WHERE varname = iv_name.
  SELECT * FROM ptf_varexpmess INTO TABLE et_varexpmess WHERE varname = iv_name.

  SELECT * FROM ptf_varcat INTO TABLE et_varcat WHERE varname = iv_name.
  "open: PTF_VAR_TAG_MAP

  SELECT * FROM ptf_varcon INTO TABLE et_varcon WHERE varname = iv_name.

ENDFUNCTION.
