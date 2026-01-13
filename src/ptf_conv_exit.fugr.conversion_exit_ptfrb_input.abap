FUNCTION conversion_exit_ptfrb_input.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(INPUT) TYPE  CLIKE
*"  EXPORTING
*"     REFERENCE(OUTPUT) TYPE  CLIKE
*"--------------------------------------------------------------------

  output = |{ input CASE = UPPER }|.


ENDFUNCTION.
