*&---------------------------------------------------------------------*
*& Report SDBIL_PTF_TEMP_TVKWZ
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT sdbil_ptf_temp_tvkwz.

IF sy-sysid NE 'C50'.
  WRITE: / 'Stopped, nothing done'.
  RETURN.
ENDIF.

DATA ls_tvkwz TYPE tvkwz.
ls_tvkwz = VALUE #( vkorg = '1010' vtweg = '10' werks = '1210' ).

INSERT tvkwz FROM ls_tvkwz.

WRITE: / 'sy-subrc:', sy-subrc.
