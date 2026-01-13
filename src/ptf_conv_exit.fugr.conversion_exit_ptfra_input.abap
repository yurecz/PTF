FUNCTION CONVERSION_EXIT_PTFRA_INPUT.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(INPUT) TYPE  CLIKE
*"  EXPORTING
*"     REFERENCE(OUTPUT) TYPE  CLIKE
*"--------------------------------------------------------------------

  output = |{ input CASE = UPPER }|.


ENDFUNCTION.
