CLASS ltc_split DEFINITION FOR TESTING
RISK LEVEL HARMLESS
DURATION SHORT.

  PRIVATE SECTION.
    CLASS-DATA digit TYPE c LENGTH 1 VALUE if_ptf_id_handler=>sc_digit .

    DATA mo_cut TYPE REF TO if_ptf_id_handler.

    METHODS:
      setup,
      assert_only_digits IMPORTING
                           iv_error  TYPE abap_bool
                           iv_prefix TYPE etvar_id
                           iv_suffix TYPE etvar_id ,
      split__and_assert_only_digits IMPORTING
                                      iv_pattern          TYPE etvar_id
                                      iv_exp_no_of_digits TYPE i OPTIONAL
                                    EXPORTING
                                      ev_no_of_digits     TYPE i,
      split__and_assert IMPORTING
                          iv_pattern          TYPE etvar_id
                          iv_exp_no_of_digits TYPE i OPTIONAL
                          iv_exp_prefix       TYPE etvar_id OPTIONAL
                          iv_exp_suffix       TYPE etvar_id OPTIONAL
                        EXPORTING
                          ev_no_of_digits     TYPE i,

      neg_no_digit FOR TESTING,
      neg_no_digit2 FOR TESTING,

      pos_01_digits FOR TESTING,
      pos_02_digits FOR TESTING,
      pos_03_digits FOR TESTING,
      pos_04_digits FOR TESTING,
      pos_05_digits FOR TESTING,
      pos_06_digits FOR TESTING,
      pos_07_digits FOR TESTING,
      pos_12_digits FOR TESTING,

*      neg_13_digits FOR TESTING,

      pos_01_prefix_01_digits FOR TESTING,
      pos_02_prefix_01_digits FOR TESTING,
      pos_03_prefix_01_digits FOR TESTING,
      pos_06_prefix_01_digits FOR TESTING,
      pos_01_prefix_02_digits FOR TESTING,
      pos_02_prefix_02_digits FOR TESTING,
      pos_03_prefix_02_digits FOR TESTING,
      pos_06_prefix_02_digits FOR TESTING,
      pos_06_prefix_06_digits FOR TESTING,
      pos_18_prefix_12_digits FOR TESTING,

      pos_no_prefix_02_digits_01_suf FOR TESTING,
      pos_01_prefix_02_digits_01_suf FOR TESTING,
      pos_02_prefix_02_digits_01_suf FOR TESTING,
      pos_06_prefix_02_digits_01_suf FOR TESTING,

      pos_no_prefix_02_digits_02_suf FOR TESTING,
      pos_01_prefix_02_digits_02_suf FOR TESTING,
      pos_02_prefix_02_digits_02_suf FOR TESTING,
      pos_06_prefix_02_digits_02_suf FOR TESTING,

      pos_no_prefix_02_digits_06_suf FOR TESTING,
      pos_01_prefix_02_digits_06_suf FOR TESTING,
      pos_02_prefix_02_digits_06_suf FOR TESTING,
      pos_06_prefix_02_digits_06_suf FOR TESTING,
      pos_10_prefix_12_digits_08_suf FOR TESTING,

      pos_04_prf_wzro_02_dgts_03_suf FOR TESTING,
      pos_05_prf_wzro_02_dgts_03_suf FOR TESTING,

      pos_01_digits_01_suf FOR TESTING,
      pos_01_digits_02_suf FOR TESTING,
      pos_01_digits_03_suf FOR TESTING,
      pos_01_digits_06_suf FOR TESTING,
      pos_02_digits_01_suf FOR TESTING,
      pos_02_digits_02_suf FOR TESTING,
      pos_02_digits_03_suf FOR TESTING,
      pos_02_digits_06_suf FOR TESTING,
      pos_06_digits_01_suf FOR TESTING,
      pos_06_digits_02_suf FOR TESTING,
      pos_06_digits_03_suf FOR TESTING,
      pos_06_digits_06_suf FOR TESTING,
      pos_12_digits_18_suf FOR TESTING,

      neg_several_blocks_of_digits FOR TESTING,
      neg_several_blocks_of_digits2 FOR TESTING,
      neg_several_blocks_of_digits3 FOR TESTING.

ENDCLASS.

CLASS ltc_split IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW cl_ptf_id_handler( ).
  ENDMETHOD.

  METHOD assert_only_digits.
    cl_abap_unit_assert=>assert_initial( iv_error ).
    cl_abap_unit_assert=>assert_initial( iv_prefix ).
    cl_abap_unit_assert=>assert_initial( iv_suffix ).
  ENDMETHOD.

  METHOD split__and_assert_only_digits.
    CLEAR ev_no_of_digits.
    mo_cut->split_pattern(
      EXPORTING
        iv_pattern      = iv_pattern
      IMPORTING
        ev_error        = DATA(lv_error)
        ev_no_of_digits = ev_no_of_digits
        ev_prefix       = DATA(lv_prefix)
        ev_suffix       = DATA(lv_suffix)
    ).
    assert_only_digits(
      iv_error  = lv_error
      iv_prefix = lv_prefix
      iv_suffix = lv_suffix
    ).
    IF iv_exp_no_of_digits IS SUPPLIED.
      cl_abap_unit_assert=>assert_equals( act = ev_no_of_digits exp = iv_exp_no_of_digits ).
    ENDIF.
  ENDMETHOD.

  METHOD split__and_assert.
    CLEAR ev_no_of_digits.
    mo_cut->split_pattern(
      EXPORTING
        iv_pattern      = iv_pattern
      IMPORTING
        ev_error        = DATA(lv_error)
        ev_no_of_digits = ev_no_of_digits
        ev_prefix       = DATA(lv_prefix)
        ev_suffix       = DATA(lv_suffix)
    ).

    cl_abap_unit_assert=>assert_initial( lv_error ).

    IF iv_exp_no_of_digits IS SUPPLIED.
      cl_abap_unit_assert=>assert_equals( act = ev_no_of_digits exp = iv_exp_no_of_digits ).
    ENDIF.
    IF iv_exp_prefix IS SUPPLIED.
      cl_abap_unit_assert=>assert_equals( act = lv_prefix exp = iv_exp_prefix ).
    ENDIF.
    IF iv_exp_suffix IS SUPPLIED.
      cl_abap_unit_assert=>assert_equals( act = lv_suffix exp = iv_exp_suffix ).
    ENDIF.
  ENDMETHOD.

* tests

  METHOD neg_no_digit.
    mo_cut->split_pattern(
      EXPORTING
        iv_pattern      = ''
      IMPORTING
        ev_error        = DATA(lv_error)
        ev_no_of_digits = DATA(lv_no_of_digits)
        ev_prefix       = DATA(lv_prefix)
        ev_suffix       = DATA(lv_suffix)
    ).
    cl_abap_unit_assert=>assert_not_initial( lv_error ).
  ENDMETHOD.
  METHOD neg_no_digit2.
    mo_cut->split_pattern(
      EXPORTING
        iv_pattern      = '123'
      IMPORTING
        ev_error        = DATA(lv_error)
        ev_no_of_digits = DATA(lv_no_of_digits)
        ev_prefix       = DATA(lv_prefix)
        ev_suffix       = DATA(lv_suffix)
    ).
    cl_abap_unit_assert=>assert_not_initial( lv_error ).
  ENDMETHOD.

  METHOD pos_01_digits.
    mo_cut->split_pattern(
    EXPORTING
      iv_pattern      = '#'
    IMPORTING
      ev_error        = DATA(lv_error)
      ev_no_of_digits = DATA(lv_no_of_digits)
      ev_prefix       = DATA(lv_prefix)
      ev_suffix       = DATA(lv_suffix)
  ).

    assert_only_digits(
      iv_error  = lv_error
      iv_prefix = lv_prefix
      iv_suffix = lv_suffix
    ).
*    cl_abap_unit_assert=>assert_initial( lv_error ).
    cl_abap_unit_assert=>assert_equals( act = lv_no_of_digits exp = 1 ).
*    cl_abap_unit_assert=>assert_initial( lv_prefix ).
*    cl_abap_unit_assert=>assert_initial( lv_suffix ).
  ENDMETHOD.

  METHOD pos_02_digits.
    mo_cut->split_pattern(
    EXPORTING
      iv_pattern      = digit && digit
    IMPORTING
      ev_error        = DATA(lv_error)
      ev_no_of_digits = DATA(lv_no_of_digits)
      ev_prefix       = DATA(lv_prefix)
      ev_suffix       = DATA(lv_suffix)
  ).

    assert_only_digits(
      iv_error  = lv_error
      iv_prefix = lv_prefix
      iv_suffix = lv_suffix
    ).

    cl_abap_unit_assert=>assert_equals( act = lv_no_of_digits exp = 2 ).
  ENDMETHOD.

  METHOD pos_03_digits.
    split__and_assert_only_digits(
    EXPORTING
      iv_pattern      = digit && digit && digit "'###'
      iv_exp_no_of_digits = 3
  ).
  ENDMETHOD.
  METHOD pos_04_digits.
    split__and_assert_only_digits(
    EXPORTING
      iv_pattern      = '####'
      iv_exp_no_of_digits = 4
  ).
  ENDMETHOD.
  METHOD pos_05_digits.
    split__and_assert_only_digits(
    EXPORTING
      iv_pattern      = '#####'
      iv_exp_no_of_digits = 5
  ).
  ENDMETHOD.
  METHOD pos_06_digits.
    split__and_assert_only_digits(
    EXPORTING
      iv_pattern      = '######'
      iv_exp_no_of_digits = 6
  ).
  ENDMETHOD.
  METHOD pos_07_digits.
    split__and_assert_only_digits(
    EXPORTING
      iv_pattern      = '#######'
      iv_exp_no_of_digits = 7
  ).
  ENDMETHOD.
  METHOD pos_12_digits.
    split__and_assert_only_digits(
    EXPORTING
      iv_pattern      = '############'
      iv_exp_no_of_digits = 12
  ).
  ENDMETHOD.

*  METHOD neg_13_digits.
*    mo_cut->split_pattern(
*      EXPORTING
*        iv_pattern      = '#############'
*      IMPORTING
*        ev_error        = DATA(lv_error)
*    ).
*    cl_abap_unit_assert=>assert_not_initial( lv_error ).      split_pattern() has no problem with 13 digits, the calles has to prevent this
*  ENDMETHOD.

  METHOD pos_01_prefix_01_digits.
    split__and_assert(
      EXPORTING
        iv_pattern          = 'P#'
        iv_exp_no_of_digits = 1
        iv_exp_prefix       = 'P'
        iv_exp_suffix       = ''
    ).
  ENDMETHOD.
  METHOD pos_02_prefix_01_digits.
    split__and_assert(
      EXPORTING
        iv_pattern          = 'PT#'
        iv_exp_no_of_digits = 1
        iv_exp_prefix       = 'PT'
        iv_exp_suffix       = ''
    ).
  ENDMETHOD.
  METHOD pos_03_prefix_01_digits.
    split__and_assert(
      EXPORTING
        iv_pattern          = 'PTF#'
        iv_exp_no_of_digits = 1
        iv_exp_prefix       = 'PTF'
        iv_exp_suffix       = ''
    ).
  ENDMETHOD.
  METHOD pos_06_prefix_01_digits.
    split__and_assert(
      EXPORTING
        iv_pattern          = 'PREFIX#'
        iv_exp_no_of_digits = 1
        iv_exp_prefix       = 'PREFIX'
        iv_exp_suffix       = ''
    ).
  ENDMETHOD.
  METHOD pos_01_prefix_02_digits.
    split__and_assert(
      EXPORTING
        iv_pattern          = 'P##'
        iv_exp_no_of_digits = 2
        iv_exp_prefix       = 'P'
        iv_exp_suffix       = ''
    ).
  ENDMETHOD.
  METHOD pos_02_prefix_02_digits.
    split__and_assert(
      EXPORTING
        iv_pattern          = 'PT##'
        iv_exp_no_of_digits = 2
        iv_exp_prefix       = 'PT'
        iv_exp_suffix       = ''
    ).
  ENDMETHOD.
  METHOD pos_03_prefix_02_digits.
    split__and_assert(
      EXPORTING
        iv_pattern          = 'PTF##'
        iv_exp_no_of_digits = 2
        iv_exp_prefix       = 'PTF'
        iv_exp_suffix       = ''
    ).
  ENDMETHOD.
  METHOD pos_06_prefix_02_digits.
    split__and_assert(
      EXPORTING
        iv_pattern          = 'PTFPTF##'
        iv_exp_no_of_digits = 2
        iv_exp_prefix       = 'PTFPTF'
        iv_exp_suffix       = ''
    ).
  ENDMETHOD.
  METHOD pos_06_prefix_06_digits.
    split__and_assert(
      EXPORTING
        iv_pattern          = 'PTFPTF######'
        iv_exp_no_of_digits = 6
        iv_exp_prefix       = 'PTFPTF'
        iv_exp_suffix       = ''
    ).
  ENDMETHOD.
  METHOD pos_18_prefix_12_digits.
    split__and_assert(
      EXPORTING
        iv_pattern          = 'eighteenEighteen############'
        iv_exp_no_of_digits = 12
        iv_exp_prefix       = 'eighteenEighteen'
        iv_exp_suffix       = ''
    ).
  ENDMETHOD.

  METHOD pos_no_prefix_02_digits_01_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = '##A'
        iv_exp_no_of_digits = 2
        iv_exp_prefix       = ''
        iv_exp_suffix       = 'A'
    ).
  ENDMETHOD.
  METHOD pos_01_prefix_02_digits_01_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = 'P##A'
        iv_exp_no_of_digits = 2
        iv_exp_prefix       = 'P'
        iv_exp_suffix       = 'A'
    ).
  ENDMETHOD.
  METHOD pos_02_prefix_02_digits_01_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = 'PT##A'
        iv_exp_no_of_digits = 2
        iv_exp_prefix       = 'PT'
        iv_exp_suffix       = 'A'
    ).
  ENDMETHOD.
  METHOD pos_06_prefix_02_digits_01_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = 'PTFQWE##A'
        iv_exp_no_of_digits = 2
        iv_exp_prefix       = 'PTFQWE'
        iv_exp_suffix       = 'A'
    ).
  ENDMETHOD.

  METHOD pos_no_prefix_02_digits_02_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = '##AB'
        iv_exp_no_of_digits = 2
        iv_exp_prefix       = ''
        iv_exp_suffix       = 'AB'
    ).
  ENDMETHOD.
  METHOD pos_01_prefix_02_digits_02_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = 'P##AB'
        iv_exp_no_of_digits = 2
        iv_exp_prefix       = 'P'
        iv_exp_suffix       = 'AB'
    ).
  ENDMETHOD.
  METHOD pos_02_prefix_02_digits_02_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = 'PT##AB'
        iv_exp_no_of_digits = 2
        iv_exp_prefix       = 'PT'
        iv_exp_suffix       = 'AB'
    ).
  ENDMETHOD.
  METHOD pos_06_prefix_02_digits_02_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = 'PTFABC##AB'
        iv_exp_no_of_digits = 2
        iv_exp_prefix       = 'PTFABC'
        iv_exp_suffix       = 'AB'
    ).
  ENDMETHOD.

  METHOD pos_no_prefix_02_digits_06_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = '##SUFFIX'
        iv_exp_no_of_digits = 2
        iv_exp_prefix       = ''
        iv_exp_suffix       = 'SUFFIX'
    ).
  ENDMETHOD.
  METHOD pos_01_prefix_02_digits_06_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = 'P##SUFFIX'
        iv_exp_no_of_digits = 2
        iv_exp_prefix       = 'P'
        iv_exp_suffix       = 'SUFFIX'
    ).
  ENDMETHOD.
  METHOD pos_02_prefix_02_digits_06_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = 'PT##SUFFIX'
        iv_exp_no_of_digits = 2
        iv_exp_prefix       = 'PT'
        iv_exp_suffix       = 'SUFFIX'
    ).
  ENDMETHOD.
  METHOD pos_06_prefix_02_digits_06_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = 'PTFABC##SUFFIX'
        iv_exp_no_of_digits = 2
        iv_exp_prefix       = 'PTFABC'
        iv_exp_suffix       = 'SUFFIX'
    ).
  ENDMETHOD.
  METHOD pos_10_prefix_12_digits_08_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = '?$)ten($? ############!SUFFIX!'
        iv_exp_no_of_digits = 12
        iv_exp_prefix       = '?$)ten($? '
        iv_exp_suffix       = '!SUFFIX!'
    ).
  ENDMETHOD.

  METHOD pos_04_prf_wzro_02_dgts_03_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = 'PT00##END'
        iv_exp_no_of_digits = 2
        iv_exp_prefix       = 'PT00'
        iv_exp_suffix       = 'END'
    ).
  ENDMETHOD.
  METHOD pos_05_prf_wzro_02_dgts_03_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = '00000##END'
        iv_exp_no_of_digits = 2
        iv_exp_prefix       = '00000'
        iv_exp_suffix       = 'END'
    ).
  ENDMETHOD.

  METHOD pos_01_digits_01_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = '#S'
        iv_exp_no_of_digits = 1
        iv_exp_prefix       = ''
        iv_exp_suffix       = 'S'
    ).
  ENDMETHOD.
  METHOD pos_01_digits_02_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = '#SU'
        iv_exp_no_of_digits = 1
        iv_exp_prefix       = ''
        iv_exp_suffix       = 'SU'
    ).
  ENDMETHOD.
  METHOD pos_01_digits_03_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = '#SUF'
        iv_exp_no_of_digits = 1
        iv_exp_prefix       = ''
        iv_exp_suffix       = 'SUF'
    ).
  ENDMETHOD.
  METHOD pos_01_digits_06_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = '#SUFFIX'
        iv_exp_no_of_digits = 1
        iv_exp_prefix       = ''
        iv_exp_suffix       = 'SUFFIX'
    ).
  ENDMETHOD.

  METHOD pos_02_digits_01_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = '##S'
        iv_exp_no_of_digits = 2
        iv_exp_prefix       = ''
        iv_exp_suffix       = 'S'
    ).
  ENDMETHOD.
  METHOD pos_02_digits_02_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = '##SU'
        iv_exp_no_of_digits = 2
        iv_exp_prefix       = ''
        iv_exp_suffix       = 'SU'
    ).
  ENDMETHOD.
  METHOD pos_02_digits_03_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = '##SUF'
        iv_exp_no_of_digits = 2
        iv_exp_prefix       = ''
        iv_exp_suffix       = 'SUF'
    ).
  ENDMETHOD.
  METHOD pos_02_digits_06_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = '##SUFFIX'
        iv_exp_no_of_digits = 2
        iv_exp_prefix       = ''
        iv_exp_suffix       = 'SUFFIX'
    ).
  ENDMETHOD.

  METHOD pos_06_digits_01_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = '######S'
        iv_exp_no_of_digits = 6
        iv_exp_prefix       = ''
        iv_exp_suffix       = 'S'
    ).
  ENDMETHOD.
  METHOD pos_06_digits_02_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = '######SU'
        iv_exp_no_of_digits = 6
        iv_exp_prefix       = ''
        iv_exp_suffix       = 'SU'
    ).
  ENDMETHOD.
  METHOD pos_06_digits_03_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = '######SUF'
        iv_exp_no_of_digits = 6
        iv_exp_prefix       = ''
        iv_exp_suffix       = 'SUF'
    ).
  ENDMETHOD.
  METHOD pos_06_digits_06_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = '######SUFFIX'
        iv_exp_no_of_digits = 6
        iv_exp_prefix       = ''
        iv_exp_suffix       = 'SUFFIX'
    ).
  ENDMETHOD.
  METHOD pos_12_digits_18_suf.
    split__and_assert(
      EXPORTING
        iv_pattern          = '############lng sffx w. spaces'
        iv_exp_no_of_digits = 12
        iv_exp_prefix       = ''
        iv_exp_suffix       = 'lng sffx w. spaces'
    ).
  ENDMETHOD.

  METHOD neg_several_blocks_of_digits.
    mo_cut->split_pattern(
      EXPORTING
        iv_pattern      = '#A#'
      IMPORTING
        ev_error        = DATA(lv_error)
*        ev_no_of_digits = DATA(lv_no_of_digits)
*        ev_prefix       = DATA(lv_prefix)
*        ev_suffix       = DATA(lv_suffix)
    ).
    cl_abap_unit_assert=>assert_not_initial( lv_error ).
  ENDMETHOD.
  METHOD neg_several_blocks_of_digits2.
    mo_cut->split_pattern(
      EXPORTING
        iv_pattern      = '#A#B'
      IMPORTING
        ev_error        = DATA(lv_error)
    ).
    cl_abap_unit_assert=>assert_not_initial( lv_error ).
  ENDMETHOD.
  METHOD neg_several_blocks_of_digits3.
    mo_cut->split_pattern(
      EXPORTING
        iv_pattern      = '####A######SUFFIX'
      IMPORTING
        ev_error        = DATA(lv_error)
    ).
    cl_abap_unit_assert=>assert_not_initial( lv_error ).
  ENDMETHOD.

ENDCLASS.
