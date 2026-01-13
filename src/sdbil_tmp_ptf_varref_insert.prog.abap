*&---------------------------------------------------------------------*
*& Report SDBIL_TMP_PTF_VARREF_INSERT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT sdbil_tmp_ptf_varref_insert.

*TABLES ptf_varref_tmp.
*SELECT-OPTIONS: svarname FOR ptf_varref_tmp-varname.
*
*
*DATA ls_varref TYPE ptf_varref_tmp.
*DATA lt_varref TYPE STANDARD TABLE OF ptf_varref_tmp.
*
*lt_varref = VALUE #( ( varname = svarname step_number = '002' reference_step = '001' )
*                     ( varname = svarname step_number = '005' reference_step = '002' )
*                     ( varname = svarname step_number = '005' reference_step = '003' )
*                     ( varname = svarname step_number = '005' reference_step = '004' )
*                   ).
*INSERT ptf_varref_tmp FROM TABLE lt_varref.
*
*
*IF sy-subrc IS INITIAL.
*  WRITE: 'SY-DBCNT:', sy-dbcnt.
*ELSE.
*  WRITE: 'SY-SUBRC:', sy-subrc.
*ENDIF.
