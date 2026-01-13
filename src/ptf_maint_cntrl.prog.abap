*&---------------------------------------------------------------------*
*& Report PTF_MAINT_CNTRL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ptf_maint_cntrl.

CONSTANTS lc_param_au          TYPE c LENGTH 20 VALUE 'USE_AUNIT'.
CONSTANTS lc_param_inv_forward TYPE c LENGTH 20 VALUE 'FORWARD_INVOICE'.

PARAMETERS: p_set_au TYPE abap_bool.
PARAMETERS: p_clr_au TYPE abap_bool.
SELECTION-SCREEN ULINE.
PARAMETERS: p_setinv TYPE abap_bool.
PARAMETERS: p_clrinv TYPE abap_bool.

IF p_set_au EQ 'X' AND p_clr_au EQ 'X'.
  RETURN.
ENDIF.
IF p_setinv EQ 'X' AND p_clrinv EQ 'X'.
  RETURN.
ENDIF.

IF p_set_au EQ 'X'.

  SELECT SINGLE * FROM ptf_ctrl_prmtr INTO @DATA(ls_x) WHERE parameter_name = @lc_param_au.

  IF sy-subrc IS NOT INITIAL.
    INSERT INTO ptf_ctrl_prmtr  VALUES @( VALUE #( parameter_name = lc_param_au value = '1'  last_change_date = sy-datum last_change_time = sy-uzeit last_change_user = sy-uname ) ).
  ELSE.
    UPDATE ptf_ctrl_prmtr SET value = '1',
     last_change_date = @sy-datum, last_change_time = @sy-uzeit, last_change_user = @sy-uname
     WHERE parameter_name = @lc_param_au.
  ENDIF.

  IF sy-subrc IS INITIAL.
    WRITE: / 'AU set to 1'.
  ENDIF.

ENDIF.

IF p_clr_au EQ 'X'.

  SELECT SINGLE * FROM ptf_ctrl_prmtr INTO @DATA(ls_x2) WHERE parameter_name = @lc_param_au.

  IF sy-subrc IS INITIAL.
    UPDATE ptf_ctrl_prmtr SET value = '0',
     last_change_date = @sy-datum, last_change_time = @sy-uzeit, last_change_user = @sy-uname
     WHERE parameter_name = @lc_param_au.
  ENDIF.
  IF sy-subrc IS INITIAL.
    WRITE: / 'AU set to 0'.
  ENDIF.

ENDIF.


IF p_setinv EQ 'X'.

  SELECT SINGLE * FROM ptf_ctrl_prmtr INTO @DATA(ls_x3) WHERE parameter_name = @lc_param_inv_forward.

  IF sy-subrc IS NOT INITIAL.
    INSERT INTO ptf_ctrl_prmtr  VALUES @( VALUE #( parameter_name = lc_param_inv_forward value = 'X'  last_change_date = sy-datum last_change_time = sy-uzeit last_change_user = sy-uname ) ).
  ELSE.
    UPDATE ptf_ctrl_prmtr SET value = 'X',
     last_change_date = @sy-datum, last_change_time = @sy-uzeit, last_change_user = @sy-uname
     WHERE parameter_name = @lc_param_inv_forward.
  ENDIF.

  IF sy-subrc IS INITIAL.
    WRITE: / 'FORWARD_INVOICE set to X'.
  ENDIF.

ENDIF.

IF p_clrinv EQ 'X'.

  SELECT SINGLE * FROM ptf_ctrl_prmtr INTO @DATA(ls_x4) WHERE parameter_name = @lc_param_inv_forward.

  IF sy-subrc IS INITIAL.
    UPDATE ptf_ctrl_prmtr SET value = @space,
     last_change_date = @sy-datum, last_change_time = @sy-uzeit, last_change_user = @sy-uname
     WHERE parameter_name = @lc_param_inv_forward.
  ENDIF.
  IF sy-subrc IS INITIAL.
    WRITE: / 'FORWARD_INVOICE set to SPACE'.
  ENDIF.

ENDIF.
