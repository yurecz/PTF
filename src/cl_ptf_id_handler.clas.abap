class CL_PTF_ID_HANDLER definition
  public
  create public .

public section.

  interfaces IF_PTF_ID_HANDLER .

  aliases SC_DIGIT
    for IF_PTF_ID_HANDLER~SC_DIGIT .
protected section.
private section.

  constants SC_NR_OBJECT type NROBJ value 'PTF_ID_16' ##NO_TEXT.

  methods CREATE_MISSING_INTERVAL
    importing
      !IV_NRRANGE_NR type NRNR
    exporting
      !EV_ERROR type ABAP_BOOL
      !EV_NUMBER type PTF_ID_N16 .
ENDCLASS.



CLASS CL_PTF_ID_HANDLER IMPLEMENTATION.


  METHOD create_missing_interval.

    "creates one interval.
    "-only if it does not exist in the nrobject
    "-gets one number into EV_NUMBER

    DATA ls_nriv_info__not_used TYPE nriv  ##NEEDED.

    CLEAR: ev_error, ev_number.

    CHECK iv_nrrange_nr IS NOT INITIAL.


    "double check that the interval is missing
    CALL FUNCTION 'NUMBER_GET_INFO'
      EXPORTING
        nr_range_nr        = iv_nrrange_nr
        object             = sc_nr_object
*       subobject          = id_subobject
*       toyear             = id_toyear
      IMPORTING
        interval           = ls_nriv_info__not_used
      EXCEPTIONS
        interval_not_found = 4
        OTHERS             = 8.
    IF sy-subrc EQ 0.
      "interval is NOT missing
      ev_error = 1.
      RETURN.
    ELSEIF sy-subrc EQ 8.
      ev_error = 2.
      RETURN.
    ENDIF.

    "prepare interval data

    DATA lt_target_interval TYPE STANDARD TABLE OF inriv.
    lt_target_interval = VALUE #(
    ( nrrangenr = '01' fromnumber = '0000000000000001' tonumber = '0000000000000009'  )
    ( nrrangenr = '02' fromnumber = '0000000000000010' tonumber = '0000000000000099'  )
    ( nrrangenr = '03' fromnumber = '0000000000000100' tonumber = '0000000000000999'  )
    ( nrrangenr = '04' fromnumber = '0000000000001000' tonumber = '0000000000009999'  )
    ( nrrangenr = '05' fromnumber = '0000000000010000' tonumber = '0000000000099999'  )
    ( nrrangenr = '06' fromnumber = '0000000000100000' tonumber = '0000000000999999'  )
    ( nrrangenr = 'A0' fromnumber = '0000000001000000' tonumber = '0000000009999999'  )
     ).
    DELETE lt_target_interval WHERE nrrangenr <> iv_nrrange_nr.

    IF lt_target_interval IS INITIAL.
      ev_error = 9.
      RETURN.
    ENDIF.
    ASSERT lines( lt_target_interval ) EQ 1.

    lt_target_interval[ 1 ]-externind = ''.
    lt_target_interval[ 1 ]-procind   = 'I'. "Insert


    "create one interval

    CALL FUNCTION 'NUMBER_RANGE_ENQUEUE'
      EXPORTING
        object           = sc_nr_object
      EXCEPTIONS
        foreign_lock     = 1
        object_not_found = 2
        system_failure   = 3
        OTHERS           = 4.
    IF sy-subrc <> 0.
      ev_error = 3.
      RETURN.
    ENDIF.


    DATA ls_inr_err     TYPE inrer  ##NEEDED.
    DATA lv_flg_error   TYPE xfeld.
    DATA lv_flg_warning TYPE xfeld  ##NEEDED.
    DATA lt_nriv_err    TYPE STANDARD TABLE OF inriv.

    CALL FUNCTION 'NUMBER_RANGE_INTERVAL_UPDATE'
      EXPORTING
        object           = sc_nr_object
      IMPORTING
        error            = ls_inr_err
        error_occured    = lv_flg_error
        warning_occured  = lv_flg_warning "not evaluated
      TABLES
        error_iv         = lt_nriv_err         "output
        interval         = lt_target_interval  "input
      EXCEPTIONS
        object_not_found = 1
        OTHERS           = 2.
*    IF sy-subrc <> 0.
*      ev_error = 4.
*      RETURN.
*    ENDIF.
*    IF lv_flg_error EQ abap_true.
*      ev_error = 8.  "todo: revisit exception code
*      RETURN.
*    ENDIF.
    IF sy-subrc <> 0.
      ev_error = 4.
    ELSEIF lv_flg_error EQ abap_true.
      ev_error = 8.  "todo: revisit exception code
    ENDIF.
    IF ev_error IS NOT INITIAL.
      CALL FUNCTION 'NUMBER_RANGE_DEQUEUE'
        EXPORTING
          object = sc_nr_object.
      RETURN.
    ENDIF.

    "write to DB
    CALL FUNCTION 'NUMBER_RANGE_UPDATE_CLOSE'
      EXPORTING
        object                 = sc_nr_object
      EXCEPTIONS
        no_changes_made        = 1
        object_not_initialized = 2
        OTHERS                 = 3.
    IF sy-subrc <> 0.
      ev_error = 5.
      CALL FUNCTION 'NUMBER_RANGE_DEQUEUE'
        EXPORTING
          object = sc_nr_object.
      RETURN.
    ENDIF.

    CALL FUNCTION 'NUMBER_RANGE_DEQUEUE'
      EXPORTING
        object           = sc_nr_object
      EXCEPTIONS
        object_not_found = 1
        OTHERS           = 2.
    IF sy-subrc <> 0.
      ev_error = 6.
      RETURN.
    ENDIF.



    "get number from created interval
    DATA lv_rc_we_do_not_use_it TYPE c  ##NEEDED.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr        = iv_nrrange_nr
        object             = sc_nr_object
      IMPORTING
        number             = ev_number
        returncode         = lv_rc_we_do_not_use_it   "eq '1'. "warning: critical numbers   eq '2'. "warning: last number
      EXCEPTIONS
        interval_not_found = 1
*       NUMBER_RANGE_NOT_INTERN = 2
        object_not_found   = 3
*       QUANTITY_IS_0      = 4
*       QUANTITY_IS_NOT_1  = 5
        interval_overflow  = 6
        buffer_overflow    = 7
        OTHERS             = 8.
    IF sy-subrc EQ 1.
      "interval not found
      ev_error = 7.
    ELSEIF sy-subrc GT 0.
      ev_error = sy-subrc + 10.
    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_id_handler~get_next_number.

    "get number from suitable number range interval, for lv_no_of_max_filled_digits digits
    "RV_NUMBER is NUMC 12, we return a number always with 12 digits including zeroes. 12 is the maximum length we currently offer.

    DATA lv_range_nr_n TYPE n LENGTH 2.
    DATA lv_range_nr_c TYPE nrnr.
    DATA lv_number_n16 TYPE ptf_id_n16.
    DATA lv_rc_we_do_not_use_it TYPE c ##NEEDED.

    CLEAR rv_number.

    CHECK iv_no_of_max_filled_digits NE 0.
    CHECK iv_no_of_max_filled_digits LE 12.

    "map length to interval id
    CASE iv_no_of_max_filled_digits.
      WHEN 1 OR 2 OR 3 OR 4 OR 5 OR 6.
        lv_range_nr_n = iv_no_of_max_filled_digits.
        lv_range_nr_c = lv_range_nr_n.
      WHEN 7 OR 8 OR 9 OR 10 OR 11 OR 12.
        lv_range_nr_c = 'A0'.
    ENDCASE.


    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr        = lv_range_nr_c
        object             = sc_nr_object
      IMPORTING
        number             = lv_number_n16
        returncode         = lv_rc_we_do_not_use_it   "eq '1'. "warning: critical numbers   eq '2'. "warning: last number
      EXCEPTIONS
        interval_not_found = 1
*       NUMBER_RANGE_NOT_INTERN = 2
        object_not_found   = 3
*       QUANTITY_IS_0      = 4
*       QUANTITY_IS_NOT_1  = 5
        interval_overflow  = 6
        buffer_overflow    = 7
        OTHERS             = 8.
    IF sy-subrc EQ 1.
      "interval not found - create it and then get a number
      create_missing_interval(
        EXPORTING
          iv_nrrange_nr = lv_range_nr_c
        IMPORTING
          ev_error      =  DATA(error_flag) ##NEEDED
          ev_number     =  lv_number_n16
      ).
    ELSEIF sy-subrc GT 0.
      RETURN.
    ENDIF.

    "return the last 12 digits.
    rv_number = lv_number_n16+4.

  ENDMETHOD.


  METHOD if_ptf_id_handler~split_pattern.

    CLEAR: ev_prefix, ev_suffix, ev_no_of_digits, ev_error, ev_error_text.

    ev_error = abap_true.

    DATA(lv_pattern) = iv_pattern.

    FIND FIRST OCCURRENCE OF sc_digit IN lv_pattern MATCH OFFSET DATA(pos_first_zero).  "first char has position 0, second is 1...
    IF sy-subrc IS NOT INITIAL.
      "no zero
      ev_error_text = |There are no numbers (#) in pattern: { lv_pattern }|.
      RETURN.
    ENDIF.
    FIND ALL OCCURRENCES OF  sc_digit IN lv_pattern MATCH COUNT DATA(number_of_zeroes).
    IF NOT lv_pattern+pos_first_zero(number_of_zeroes) CO sc_digit.
      "zeroes are not a continuous block.   (position to be found in sy-fdpos: first char has fdpos = 0; second char has 1; ... )
      ev_error_text = |Numbers (#) are not one continuous block in pattern: { lv_pattern }|.
      RETURN.
    ENDIF.

    FIND ALL OCCURRENCES OF sc_digit IN lv_pattern MATCH OFFSET DATA(pos_last_zero).

    IF pos_first_zero NE 0.
      ev_prefix = lv_pattern(pos_first_zero).
    ENDIF.

    DATA(pos_suffix_start) = pos_last_zero + 1.
    IF strlen( lv_pattern ) GE pos_suffix_start.
      ev_suffix = lv_pattern+pos_suffix_start.
    ENDIF.

    ev_no_of_digits = number_of_zeroes.
    ev_error = abap_false.

  ENDMETHOD.
ENDCLASS.
