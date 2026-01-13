*&---------------------------------------------------------------------*
*& Report PTF_CHECK_T000_RCRDNG_OF_CHNGS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ptf_check_t000_rcrdng_of_chngs.

SELECT SINGLE * FROM t000 INTO @DATA(ls_data).

WRITE: sy-mandt, 'CCCORACTIV:',ls_data-cccoractiv.

IF ls_data-cccoractiv EQ '1'.
  WRITE: / 'Automatic recording of changes is ACTIVE'.
ELSE.
  WRITE: / 'Automatic recording of changes is NOT ACTIVE'.
ENDIF.

CASE ls_data-cccoractiv.
  WHEN space.
    "Changes without automatic recording
  WHEN '1'.
    "Automatic recording of changes
  WHEN '2'.
    "No changes allowed
  WHEN '3'.
    "Changes without automatic recording, no transport allowed
ENDCASE.
