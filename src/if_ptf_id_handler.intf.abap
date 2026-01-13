interface IF_PTF_ID_HANDLER
  public .


  constants SC_DIGIT type C value '#' ##NO_TEXT.

  methods GET_NEXT_NUMBER
    importing
      !IV_NO_OF_MAX_FILLED_DIGITS type I
    returning
      value(RV_NUMBER) type PTF_ID_N12 .
  methods SPLIT_PATTERN
    importing
      !IV_PATTERN type ETVAR_ID
    exporting
      !EV_NO_OF_DIGITS type I
      !EV_PREFIX type ETVAR_ID
      !EV_SUFFIX type ETVAR_ID
      !EV_ERROR type ABAP_BOOL
      !EV_ERROR_TEXT type PTF_TEXT60_CS .
endinterface.
