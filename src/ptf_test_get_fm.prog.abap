*&---------------------------------------------------------------------*
*& Report ptf_test_get_varcon
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ptf_test_get_varcon.


*TYPES: BEGIN OF ty_c4000,
*         wa TYPE c LENGTH 4000,
*       END OF  ty_c4000.
*DATA it_fields  LIKE rfc_db_fld OCCURS 0 WITH HEADER LINE.
*DATA it_data       TYPE STANDARD TABLE OF ty_c4000.
**DATA it_data_call2 TYPE STANDARD TABLE OF ty_c4000.
*
*FIELD-SYMBOLS : <l_table> TYPE table,
*                <l_line>  TYPE any.
*FIELD-SYMBOLS : <l_field> TYPE any.
*DATA lt_varcon TYPE STANDARD TABLE OF ptf_varcon.
*
*
*
*
*DATA: "d_ref      TYPE REF TO data,
*  new_line   TYPE REF TO data,
*  i_alv_cat  TYPE TABLE OF lvc_s_fcat,
*  ls_alv_cat LIKE LINE OF i_alv_cat.
*
*
*DATA: BEGIN OF itab OCCURS 0.
*        INCLUDE STRUCTURE dntab.
*DATA: END OF itab.
*
*REFRESH itab.
*CLEAR it_fields.     """
*CLEAR it_fields[].   """
*
*CALL FUNCTION 'NAMETAB_GET'
*  EXPORTING
*    langu          = sy-langu
*    tabname        = 'PTF_VARCON'
*  TABLES
*    nametab        = itab
*  EXCEPTIONS
*    no_texts_found = 1.
*
*LOOP AT itab .
*  ls_alv_cat-fieldname = itab-fieldname.
*  ls_alv_cat-ref_table = 'PTF_VARCON'.
*  ls_alv_cat-ref_field = itab-fieldname.
*  APPEND ls_alv_cat TO i_alv_cat.
*  it_fields-fieldname = itab-fieldname.
*  APPEND it_fields.
*ENDLOOP.
*CLEAR it_fields.     """2
*
*** Create a new table.
**CALL METHOD cl_alv_table_create=>create_dynamic_table
**  EXPORTING
**    it_fieldcatalog = i_alv_cat
**  IMPORTING
**    ep_table        = d_ref.
*
** Create a new Line with the same structure of the table.
**  ASSIGN d_ref->* TO <l_table>.
*CREATE DATA new_line LIKE LINE OF lt_varcon. "<l_table>.
*ASSIGN new_line->* TO <l_line>.
*
*
*
*
*
*
*"CALL FM for ALL FIELDS  (fixed lenght call)      STRING COLUMNS ARE NOT RETURNED
*DATA lt_data_new TYPE sdti_result_tab.
*DATA lt_varcon_direct TYPE STANDARD TABLE OF ptf_varcon. "sdti_result_tab. "STANDARD TABLE OF string.
*
*
*CALL FUNCTION 'RFC_READ_TABLE'
*  DESTINATION 'HOME'
*  EXPORTING
*    query_table          = 'PTF_VARCON'
**   DELIMITER            = ' '
*    no_data              = ' '
**   rowskips             = 0
*    rowcount             = 0    "if set, this is the max value
**   use_et_data_4_return = abap_true
**  IMPORTING
**   et_data              = lt_data_new       "if use_et_data_4_return = abap_true   it dumps in ER9, in C50 it returns the data without fixed field length                "trailing blanks in char fields are lost!!  mentioned in FM:(no fixed column length)
**   et_data              = lt_varcon_direct  "if use_et_data_4_return = abap_true   it dumps in ER9, in C50, it's returning the records but line is empty as dynamic length doesn't match fixed length itab
*  TABLES
**   options              = it_options  "in
*    fields               = it_fields   "both    in: subset of fields (optional)  out:  attributes for fields
*    data                 = it_data     "out        "ER9: type conflict,dump
*  EXCEPTIONS
*    table_not_available  = 1
*    table_without_data   = 2
*    option_not_valid     = 3
*    field_not_valid      = 4
*    not_authorized       = 5
*    data_buffer_exceeded = 6
*    OTHERS               = 7.
*
*
*
*"CALL FM for 2 key fields + field INPUT_STRING
*DATA it_3fieldnames LIKE rfc_db_fld OCCURS 0.
*it_3fieldnames = VALUE #( ( fieldname = 'STEP_NUMBER' ) ( fieldname = 'VARNAME' ) ( fieldname = 'INPUT_STRING' ) ).
*
*DATA lt_3columns TYPE sdti_result_tab.
*
*CALL FUNCTION 'RFC_READ_TABLE'
*  DESTINATION 'HOME'
*  EXPORTING
*    query_table          = 'PTF_VARCON'
*    delimiter            = '|'            "here with delimiter
*    no_data              = ' '
**   rowskips             = 0
*    rowcount             = 0
*    use_et_data_4_return = abap_true
*  IMPORTING
*    et_data              = lt_3columns  "it seems trailing blanks in char fields are lost!!  mentioned in FM:(no fixed column length)
**   et_data              = lt_varcon_direct   dumps in ER9
*  TABLES
**   options              = it_options  "in
*    fields               = it_3fieldnames   "both    in: subset of fields (optional)  out:  attributes for fields
**   data                 = it_data_call2 "out
*  EXCEPTIONS
*    table_not_available  = 1
*    table_without_data   = 2
*    option_not_valid     = 3
*    field_not_valid      = 4
*    not_authorized       = 5
*    data_buffer_exceeded = 6
*    OTHERS               = 7.
*
*
*DATA:
*  BEGIN OF ls_json,
*    varname       TYPE ptf_varname,
*    step_number  TYPE n LENGTH 3,
*    input_string TYPE  ptf_json_string,
*  END OF ls_json.
*
*DATA lt_json LIKE STANDARD TABLE OF ls_json.
*
**DATA lv_varname TYPE ptf_varname.
**DATA lv_step_no TYPE n LENGTH 3.
*
*LOOP AT lt_3columns INTO DATA(lv_string).
*  FIND FIRST OCCURRENCE OF '|' IN lv_string-line+4 RESULTS DATA(ls_length_varname).
*  DATA(json_start) = 4 + ls_length_varname-offset + 1.
*  DATA(total_length) = strlen( lv_string-line ).
*  IF total_length GT json_start.
*    ls_json-step_number = lv_string-line(3).   "
*    ls_json-varname  = lv_string-line+4(ls_length_varname-offset). "lv_varname
*    ls_json-input_string = lv_string-line+json_start.
*    APPEND ls_json TO lt_json.
*  ENDIF.
*ENDLOOP.
*
*
*
*DATA lv_varname TYPE ptf_varname.
*DATA lv_stepno TYPE n LENGTH 3.
*
*DATA line_c4000 TYPE ty_c4000.
*
** Data convert
*SORT it_data.
**LOOP AT lt_data_new INTO DATA(ls_data).
*LOOP AT it_data INTO DATA(ls_data) .
*  CLEAR <l_line>.
*  CLEAR: lv_stepno, lv_varname.
** CLEAR zflag.
*
*  line_c4000 = ls_data."-line.
*
*  LOOP AT it_fields.
*    ASSIGN COMPONENT it_fields-fieldname OF STRUCTURE <l_line> TO <l_field>.
*    ASSERT sy-subrc IS INITIAL.
*
*    IF it_fields-fieldname NE 'INPUT_STRING'. "better check for type STRING                           """
*      <l_field> = line_c4000-wa+it_fields-offset(it_fields-length).
*    ELSE.
*      <l_field> = line_c4000-wa+it_fields-offset.    "never happens                                                       """
*    ENDIF.
*
*    IF it_fields-fieldname EQ 'STEP_NUMBER'.
*      lv_stepno = <l_field>.
*    ENDIF.
*    IF it_fields-fieldname EQ 'VARNAME'.
*      lv_varname = <l_field>.
*    ENDIF.
*
*  ENDLOOP.
*
*  "access itab lt_json with varname and stepNo, move json to field INPUT_STRING of the assigned record
*  READ TABLE lt_json WITH KEY varname = lv_varname step_number = lv_stepno ASSIGNING FIELD-SYMBOL(<ls_json>).
*  IF sy-subrc IS INITIAL AND <ls_json>-input_string IS NOT INITIAL.
*    DATA lv_input_json TYPE string.
*    lv_input_json = <ls_json>-input_string.
*
*    ASSIGN COMPONENT 'INPUT_STRING' OF STRUCTURE <l_line> TO <l_field>.
*    <l_field> = <ls_json>-input_string.
*    DATA lv_enrich_count TYPE i.
*    ADD 1 TO lv_enrich_count.
*  ENDIF.
*
**    IF zflag = 'X'.
**      CONTINUE.
**    ELSE.
*  APPEND <l_line> TO " <l_table>.
*  lt_varcon.
**    ENDIF.
*
*ENDLOOP.
*
*WRITE: / 'Added content for INPUT_STRING for records:', lv_enrich_count.
*
*IF sy-sysid EQ 'C50'.
*  MODIFY ptf_varcon FROM TABLE lt_varcon.
*  WRITE: / 'Updated db table PTF_VARCON, record:', sy-dbcnt.
*ENDIF.
*
*BREAK-POINT.
