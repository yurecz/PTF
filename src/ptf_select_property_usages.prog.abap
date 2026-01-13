*&---------------------------------------------------------------------*
*& Report PTF_SELECT_PROPERTY_USAGES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT PTF_SELECT_PROPERTY_USAGES.

SELECT * FROM ptf_varcon USING ALL CLIENTS WHERE input_string "LIKE '%commit%'
      LIKE '%initial%'
      INTO TABLE @DATA(lt_step) .

IF lt_step IS NOT INITIAL.
  SELECT * FROM ptf_varid USING ALL CLIENTS
    FOR ALL ENTRIES IN @lt_step WHERE varname = @lt_step-varname AND mandt = @lt_step-mandt
    INTO TABLE @DATA(lt_script).
ENDIF.

LOOP AT lt_script INTO DATA(ls_script).
  CONCATENATE ls_script-mandt ls_script-varname `     ` ls_script-erdat ls_script-ernam ls_script-last_change_date ls_script-last_change_user INTO DATA(string) SEPARATED BY ','.
  WRITE / string.
ENDLOOP.


SELECT * FROM ptf_varcon USING ALL CLIENTS
      WHERE bus_obj LIKE 'R#_%'  ESCAPE '#'  OR bus_obj LIKE 'I#_%' ESCAPE '#'  OR bus_obj LIKE 'A#_%' ESCAPE '#'
      "WHERE bus_obj LIKE '_#_%'  ESCAPE '#'  AND action <> 'COMMIT'
      INTO TABLE @DATA(lt_r_step) .

IF lt_r_step IS NOT INITIAL.
  SELECT * FROM ptf_varid USING ALL CLIENTS
    FOR ALL ENTRIES IN @lt_r_step WHERE varname = @lt_r_step-varname AND mandt = @lt_r_step-mandt
    INTO TABLE @DATA(lt_r_script).
ENDIF.

check 1 = 1.
