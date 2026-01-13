*&---------------------------------------------------------------------*
*& Report PTF_COUNT_BO_USAGE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ptf_count_bo_usage.

WRITE: 'Client:', sy-sysid, sy-mandt, /.

SELECT COUNT(*) FROM ptf_varid INTO @DATA(lv_script_count) WHERE NOT varname LIKE 'Z%'.
WRITE: / 'No of PTF scripts (Z* ignored):', lv_script_count.
SELECT COUNT(*) FROM ptf_varcon INTO @DATA(lv_step_count) WHERE NOT varname LIKE 'Z%'.
WRITE: / 'No of steps in these          :', lv_step_count.




SELECT  bus_obj, varname FROM ptf_varcon GROUP BY varname, bus_obj INTO TABLE @DATA(lt_group).
WRITE: /, / 'Unique PTF BO usage in scripts:'.


DATA count TYPE i.
DATA current TYPE ptf_bo.
DATA bo_count TYPE i.

SORT lt_group BY bus_obj.
LOOP AT lt_group INTO DATA(ls_group).

  ADD 1 TO count.

  AT NEW ('BUS_OBJ').
    IF NOT current IS INITIAL.
      WRITE: / current, ':', count.
      ADD 1 TO bo_count.
    ENDIF.
    CLEAR count.
    current = ls_group-bus_obj.
  ENDAT.

ENDLOOP.

WRITE: / bo_count, 'BOs'.
