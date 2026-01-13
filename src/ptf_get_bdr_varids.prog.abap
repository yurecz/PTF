*&---------------------------------------------------------------------*
*& Report PTF_GET_BDR_VARIDS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ptf_get_bdr_varids.

DATA lt_varname TYPE STANDARD TABLE OF ptf_varname.
DATA lt_result  TYPE STANDARD TABLE OF ptf_varname.
SELECT DISTINCT ptf_script FROM ptf_exec_log WHERE ptf_script LIKE '%BDR%' INTO TABLE @lt_varname. "@data(lt_varname).

LOOP AT lt_varname INTO DATA(lv_varname).

  CHECK lv_varname IS NOT INITIAL.
  CHECK lv_varname(1) NE '_'.
  SELECT SINGLE varname FROM ptf_varid INTO @DATA(lv_dummy) WHERE varname = @lv_varname.
  IF sy-subrc IS NOT INITIAL.
    CONTINUE.
  ENDIF.

  APPEND lv_varname TO lt_result.
  WRITE: / lv_varname.

ENDLOOP.

CHECK 1 = 1.
