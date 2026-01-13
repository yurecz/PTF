*&---------------------------------------------------------------------*
*& Report PTF_CHECK_DB_CONSISTENCY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ptf_check_db_consistency.

WRITE: 'Client:', sy-sysid, sy-mandt, /.

TYPES:
tt_varname TYPE STANDARD TABLE OF ptf_varname WITH DEFAULT KEY.

*PTF_VARID

*PTF_VARCAT
*PTF_VARCON
*PTF_VARID_T
*PTF_VARREF
DATA lt_varname TYPE tt_varname.

SELECT DISTINCT varname FROM ptf_varcon INTO TABLE lt_varname WHERE varname NOT IN ( SELECT DISTINCT varname FROM ptf_varid ).
IF lt_varname IS NOT INITIAL.
  WRITE: /, / 'Lost entries in PTF_VARCON:'.
  PERFORM print_names USING lt_varname.
ELSE.
  WRITE: /, / 'PTF_VARCON is ok.'.
ENDIF.

SELECT DISTINCT varname FROM ptf_varcat INTO TABLE lt_varname WHERE varname NOT IN ( SELECT DISTINCT varname FROM ptf_varid ).
IF lt_varname IS NOT INITIAL.
  WRITE: /, / 'Lost entries in PTF_VARCAT:'.
  PERFORM print_names USING lt_varname.
ELSE.
  WRITE: /, / 'PTF_VARCAT is ok.'.
ENDIF.

SELECT DISTINCT varname FROM ptf_varid_t INTO TABLE lt_varname WHERE varname NOT IN ( SELECT DISTINCT varname FROM ptf_varid ).
IF lt_varname IS NOT INITIAL.
  WRITE: /, / 'Lost entries in PTF_VARID_T:'.
  PERFORM print_names USING lt_varname.
ELSE.
  WRITE: /, / 'PTF_VARID_T is ok.'.
ENDIF.

SELECT DISTINCT varname FROM ptf_varref INTO TABLE lt_varname WHERE varname NOT IN ( SELECT DISTINCT varname FROM ptf_varid ).
IF lt_varname IS NOT INITIAL.
  WRITE: /, / 'Lost entries in PTF_VARREF:'.
  PERFORM print_names USING lt_varname.
ELSE.
  WRITE: /, / 'PTF_VARREF is ok.'.
ENDIF.



ULINE.

SELECT DISTINCT varname FROM ptf_varid INTO TABLE lt_varname WHERE varname NOT IN ( SELECT DISTINCT varname FROM ptf_varcon ).
IF lt_varname IS NOT INITIAL.
  WRITE: /, / 'Scripts that have no steps:'.
  PERFORM print_names USING lt_varname.
ELSE.
  WRITE: /, / '(There are no scripts without steps.)'.
ENDIF.

FORM print_names USING it_varname TYPE tt_varname.

  LOOP AT it_varname INTO DATA(one_varname).
    WRITE: / one_varname.
  ENDLOOP.

ENDFORM.
