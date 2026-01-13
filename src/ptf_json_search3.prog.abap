*&---------------------------------------------------------------------*
*& Report PTF_JSON_SEARCH3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT PTF_JSON_SEARCH3.


SELECT * FROM ptf_varcon WHERE input_string LIKE '%PartnerFunctionForEdit%' INTO TABLE @DATA(lt_itab1).

SELECT * FROM ptf_varcon WHERE input_string LIKE '%PartnerFunction%' INTO TABLE @DATA(lt_itab2).

WRITE: /, / '%PartnerFunctionForEdit%:'.
LOOP AT lt_itab1 INTO DATA(ls_varcon).

  WRITE: /, / ls_varcon-varname, '|', ls_varcon-step_number, '|', ls_varcon-input_string.
  WRITE: / ls_varcon-input_string+100.
ENDLOOP.


WRITE: /, / '%PartnerFunction%:'.
LOOP AT lt_itab2 INTO ls_varcon.

  WRITE: /, / ls_varcon-varname, '|', ls_varcon-step_number, '|', ls_varcon-input_string.
  WRITE: / ls_varcon-input_string+100.
ENDLOOP.
