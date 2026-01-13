*&---------------------------------------------------------------------*
*& Report PTF_DUMMY_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ptf_dummy_report.

DATA lv_count TYPE i.

CHECK 1 = 1.



IMPORT v_count   = lv_count FROM MEMORY ID 'PTF_XY_COUNT'.

ADD 1 TO lv_count.

EXPORT v_count   = lv_count TO MEMORY ID 'PTF_XY_COUNT'.
