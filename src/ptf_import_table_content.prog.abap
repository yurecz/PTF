*&---------------------------------------------------------------------*
*& Report PTF_IMPORT_TABLE_CONTENT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ptf_import_table_content.
" Do NOT use
" Can copy full table contents for a list of db tables via RFC
" There is no delta logic!

************************************************************************
*        DATA
************************************************************************
FIELD-SYMBOLS : <l_table> TYPE table,
                <l_line>  TYPE any.
FIELD-SYMBOLS : <l_field> TYPE any.
*DATA: zflag TYPE c.
DATA: lv_tabnam TYPE dd02l-tabname.

TYPES:
  BEGIN OF gty_s_json,
    varname	     TYPE ptf_varname,
    step_number  TYPE n LENGTH 3,
    input_string TYPE	ptf_json_string,
  END OF gty_s_json.
TYPES: gty_t_json TYPE STANDARD TABLE OF gty_s_json.
************************************************************************
*        INTERNAL TABLES
************************************************************************
TYPES: BEGIN OF ty_c4000,
         wa TYPE c LENGTH 4000,
       END OF  ty_c4000.
DATA: it_data    TYPE STANDARD TABLE OF ty_c4000, "LIKE STANDARD TABLE OF DPS_RFC_TAB_4000_S,"     OCCURS 0 WITH HEADER LINE,
      it_fields  LIKE rfc_db_fld OCCURS 0 WITH HEADER LINE,
      it_options LIKE rfc_db_opt OCCURS 0 WITH HEADER LINE,
      lt_tabnam  TYPE TABLE OF dd02l-tabname.

************************************************************************
*        PARAMETERS
************************************************************************

* Block 1 - Table Name
SELECTION-SCREEN BEGIN OF BLOCK bk1 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS p_tabnam FOR lv_tabnam NO INTERVALS  NO-DISPLAY ." OBLIGATORY.
*  PARAMETERS: p_sel_op TYPE rfc_db_opt  NO-DISPLAY.

  PARAMETERS: p_scrpt AS CHECKBOX.
  PARAMETERS: p_metadt AS CHECKBOX.

SELECTION-SCREEN END OF BLOCK bk1.


* Block 2 - Process Method
SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN BEGIN OF BLOCK bk2 WITH FRAME TITLE TEXT-002.
  PARAMETERS: p_source LIKE rfcdes-rfcdest DEFAULT 'HOME'. "'CIL'.

  SELECTION-SCREEN SKIP 1.
  SELECTION-SCREEN SKIP 1.
  PARAMETERS: p_clear AS CHECKBOX.
  PARAMETERS: p_copy AS CHECKBOX DEFAULT abap_true.
  PARAMETERS: p_test AS CHECKBOX DEFAULT abap_true.
SELECTION-SCREEN END OF BLOCK bk2.

** Block 3 - Conversion option
*SELECTION-SCREEN SKIP 1.
*SELECTION-SCREEN BEGIN OF BLOCK bk3 WITH FRAME TITLE TEXT-003.
*
*
*SELECTION-SCREEN END OF BLOCK bk3.


*----------------------------------------------------------------------*
************************************************************************
*----------------------------------------------------------------------*
*
*        MAIN PROGRAM
*
*----------------------------------------------------------------------*
************************************************************************
*----------------------------------------------------------------------*
START-OF-SELECTION.

  CALL FUNCTION 'TR_AUTHORITY_CHECK_ADMIN'
    EXPORTING
      iv_user          = sy-uname
      iv_adminfunction = 'TADM' "Special transport functions in TMS
    EXCEPTIONS
      e_no_authority   = 1
      e_invalid_user   = 2
      OTHERS           = 3.
  CASE sy-subrc.
    WHEN 1.
      WRITE: / 'No authority'.
      RETURN.
    WHEN 2.
      WRITE: / 'Invalid user'.
      RETURN.
    WHEN 3.
      WRITE: / 'Error checking authorization'.
      RETURN.
  ENDCASE.

  ASSERT sy-sysid(2) NE 'ER'.

  "Functionality...

  PERFORM add_ptf_table_names.

  CHECK p_tabnam[] IS NOT INITIAL.
  SELECT tabname  FROM dd02l INTO TABLE lt_tabnam WHERE tabname IN p_tabnam.

  LOOP AT lt_tabnam INTO lv_tabnam.

* Retrieve Table definition
    WRITE : / lv_tabnam.
    PERFORM frm_init_internal_table USING lv_tabnam.

* Clear data
    IF p_clear = abap_true.
      IF 1 = 1.
        WRITE: / 'Clear on DB tables is commented out.'.
      ELSE.
        PERFORM frm_clear_data USING lv_tabnam.
      ENDIF.
    ENDIF.

    IF p_copy = abap_true.
      PERFORM frm_get_data_via_rfc USING lv_tabnam. " Get data via RFC
      PERFORM frm_insert_data USING lv_tabnam.      " Insert data
    ENDIF.

    IF p_test = abap_false.
      COMMIT WORK.
    ELSE.
      ROLLBACK WORK.
      WRITE: / 'Test flag set: ROLLBACK WORK'.
    ENDIF.

  ENDLOOP.

END-OF-SELECTION.

*&---------------------------------------------------------------------*
FORM add_ptf_table_names.

  DATA ls_tabnam LIKE p_tabnam.

  ls_tabnam-sign = 'I'.
  ls_tabnam-option ='EQ'.

  IF p_scrpt EQ 'X'.
    ls_tabnam-low	= 'PTF_VARCAT'. APPEND ls_tabnam TO p_tabnam.
    ls_tabnam-low	= 'PTF_VARCON'. APPEND ls_tabnam TO p_tabnam.
    ls_tabnam-low	= 'PTF_VARREF'. APPEND ls_tabnam TO p_tabnam.
    ls_tabnam-low	= 'PTF_VARID'.  APPEND ls_tabnam TO p_tabnam.
    ls_tabnam-low	= 'PTF_VARID_T'. APPEND ls_tabnam TO p_tabnam.
    ls_tabnam-low	= 'PTF_VAREXPMESS'. APPEND ls_tabnam TO p_tabnam.
    ls_tabnam-low	= 'PTF_INPUT_REPO'. APPEND ls_tabnam TO p_tabnam.
    ls_tabnam-low	= 'PTF_VARDATASET'. APPEND ls_tabnam TO p_tabnam.
  ENDIF.

  IF p_metadt EQ 'X'.
    ls_tabnam-low	= 'PTFBO'.  APPEND ls_tabnam TO p_tabnam.
    ls_tabnam-low	= 'PTFBOT'. APPEND ls_tabnam TO p_tabnam.
    ls_tabnam-low	= 'PTFBOA'. APPEND ls_tabnam TO p_tabnam.
    ls_tabnam-low	= 'PTFBOAT'. APPEND ls_tabnam TO p_tabnam.
  ENDIF.

  "PTF Tags
*  IF 1 = 2.
  ls_tabnam-low	= 'PTF_VAR_TAG'.  APPEND ls_tabnam TO p_tabnam.
  ls_tabnam-low	= 'PTF_VAR_TAGT'.  APPEND ls_tabnam TO p_tabnam.
  ls_tabnam-low	= 'PTF_VAR_TAG_MAP'.  APPEND ls_tabnam TO p_tabnam.
*  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  frm_insert_data
*&---------------------------------------------------------------------*
*       Modify the table with the data of dynamic internal table.
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM frm_insert_data  USING    p_p_tabnam.

*  FIELD-SYMBOLS : <l_field> TYPE any.

*Delete empty lines from itab
  LOOP AT <l_table> ASSIGNING <l_line>.
    IF <l_line> IS INITIAL.
      DELETE <l_table>.
    ENDIF.
  ENDLOOP.

*** << temp
  SELECT COUNT( * ) FROM (p_p_tabnam)
     INTO @DATA(count).
  IF count IS NOT INITIAL.
    WRITE : 'Skipping non initial table:' , p_p_tabnam.
    RETURN.
  ENDIF.
*** temp >>

  ASSERT sy-sysid(2) NE 'ER'.

*Insert data to database
  MODIFY (p_p_tabnam) FROM TABLE <l_table>.
  WRITE : 'Modify' , sy-dbcnt.

ENDFORM.                    " frm_insert_data

*&---------------------------------------------------------------------*
*&      Form  frm_init_internal_table
*&---------------------------------------------------------------------*
*       Build the Dynamic internal table
*----------------------------------------------------------------------*
*      -->P_P_TABNAM  text
*----------------------------------------------------------------------*
FORM frm_init_internal_table USING    p_p_tabnam.
  DATA: d_ref      TYPE REF TO data,
        new_line   TYPE REF TO data,
        i_alv_cat  TYPE TABLE OF lvc_s_fcat,
        ls_alv_cat LIKE LINE OF i_alv_cat.

  DATA: BEGIN OF itab OCCURS 0.
          INCLUDE STRUCTURE dntab.
  DATA: END OF itab.

  REFRESH itab.
  CLEAR it_fields. CLEAR it_fields[].
  CALL FUNCTION 'NAMETAB_GET'
    EXPORTING
      langu          = sy-langu
      tabname        = p_p_tabnam
    TABLES
      nametab        = itab
    EXCEPTIONS
      no_texts_found = 1.

  LOOP AT itab .
    ls_alv_cat-fieldname = itab-fieldname.
    ls_alv_cat-ref_table = p_p_tabnam.
    ls_alv_cat-ref_field = itab-fieldname.
    APPEND ls_alv_cat TO i_alv_cat.
    it_fields-fieldname = itab-fieldname.
    APPEND it_fields.
  ENDLOOP.
  CLEAR it_fields. "header line

* Create a new table.
  CALL METHOD cl_alv_table_create=>create_dynamic_table
    EXPORTING
      it_fieldcatalog = i_alv_cat
    IMPORTING
      ep_table        = d_ref.

* Create a new Line with the same structure of the table.
  ASSIGN d_ref->* TO <l_table>.
  CREATE DATA new_line LIKE LINE OF <l_table>.
  ASSIGN new_line->* TO <l_line>.

ENDFORM.                    " frm_init_internal_table

*&---------------------------------------------------------------------*
*&      Form  frm_getdata
*&---------------------------------------------------------------------*
*       Get data via RFC
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM frm_get_data_via_rfc  USING    p_p_tabnam.

  DATA lt_json TYPE gty_t_json.
  DATA lv_varname TYPE ptf_varname.
  DATA lv_stepno TYPE n LENGTH 3.

  REFRESH it_data.
  REFRESH it_options.
  REFRESH <l_table>.
*  it_options-text = p_sel_op.
*  APPEND it_options.

* Get table data via RFC
  CALL FUNCTION 'RFC_READ_TABLE'
    DESTINATION p_source
    EXPORTING
      query_table          = p_p_tabnam
*     DELIMITER            = ' '
      no_data              = ' '
*     rowskips             = 0
      rowcount             = 0
    TABLES
*     options              = it_options
      fields               = it_fields
      data                 = it_data
    EXCEPTIONS
      table_not_available  = 1
      table_without_data   = 2
      option_not_valid     = 3
      field_not_valid      = 4
      not_authorized       = 5
      data_buffer_exceeded = 6
      OTHERS               = 7.
  IF sy-subrc <> 0.
    IF sy-msgty IS INITIAL.
      WRITE : 'RFC failed.'.
    ELSE.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.

  CLEAR it_fields. "header line

  IF p_p_tabnam EQ 'PTF_VARCON'.
    PERFORM get_varcon_json CHANGING lt_json.
  ENDIF.

* Data convert
  SORT it_data.
  LOOP AT it_data INTO DATA(ls_data).
    CLEAR <l_line>.
    CLEAR: lv_stepno, lv_varname.
*    CLEAR zflag.
    LOOP AT it_fields.
      ASSIGN COMPONENT it_fields-fieldname OF STRUCTURE <l_line> TO <l_field>.
      ASSERT sy-subrc IS INITIAL.

      IF it_fields-fieldname NE 'INPUT_STRING'. "better check for type STRING
        <l_field> = ls_data+it_fields-offset(it_fields-length).
      ELSE.
        BREAK-POINT.
        <l_field> = ls_data+it_fields-offset.      "    "never happens
      ENDIF.

      IF it_fields-fieldname EQ 'STEP_NUMBER'.
        lv_stepno = <l_field>.
      ENDIF.
      IF it_fields-fieldname EQ 'VARNAME'.
        lv_varname = <l_field>.
      ENDIF.

    ENDLOOP. "fields

    IF p_p_tabnam EQ 'PTF_VARCON'.
      "access itab lt_json with varname and stepNo, copy json to field INPUT_STRING of the assigned record
      READ TABLE lt_json WITH KEY varname = lv_varname step_number = lv_stepno ASSIGNING FIELD-SYMBOL(<ls_json>).
      IF sy-subrc IS INITIAL AND <ls_json>-input_string IS NOT INITIAL.
        ASSIGN COMPONENT 'INPUT_STRING' OF STRUCTURE <l_line> TO <l_field>.
        <l_field> = <ls_json>-input_string.
        DATA lv_enrich_count TYPE i.
        ADD 1 TO lv_enrich_count.
      ENDIF.
    ENDIF.

*    IF zflag = 'X'.
*      CONTINUE.
*    ELSE.
    APPEND <l_line> TO <l_table>.
*    ENDIF.
  ENDLOOP. "table records

  IF p_p_tabnam EQ 'PTF_VARCON'.
    WRITE: / 'Added content for INPUT_STRING for records:', lv_enrich_count.
  ENDIF.

ENDFORM.                    " frm_get_data_via_rfc


*&---------------------------------------------------------------------*
*&      Form  frm_clear_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM frm_clear_data  USING    p_p_tabnam.

  SELECT * FROM (p_p_tabnam)
     INTO CORRESPONDING FIELDS OF TABLE <l_table>
*     WHERE (p_sel_op)
    .
  "DELETE TABLE CONTENT IN CURRENT SYSTEM
  DELETE (p_p_tabnam) FROM TABLE <l_table>.
  WRITE : 'Delete' , sy-dbcnt.
  REFRESH <l_table>.

ENDFORM.                    " frm_clear_data


FORM get_varcon_json CHANGING ct_json TYPE gty_t_json.
  "Fill itab for records which have a JSON, using dedicated RFC table read

  "CALL FM for 2 key fields + field INPUT_STRING
  DATA it_3fieldnames LIKE rfc_db_fld OCCURS 0.
  it_3fieldnames = VALUE #( ( fieldname = 'STEP_NUMBER' ) ( fieldname = 'VARNAME' ) ( fieldname = 'INPUT_STRING' ) ).

  DATA lt_3columns TYPE sdti_result_tab.
  DATA ls_json TYPE gty_s_json.

  CALL FUNCTION 'RFC_READ_TABLE'
    DESTINATION p_source
    EXPORTING
      query_table          = 'PTF_VARCON'
      delimiter            = '|'            "here with delimiter
      no_data              = ' '
*     rowskips             = 0
      rowcount             = 0
      use_et_data_4_return = abap_true
    IMPORTING
      et_data              = lt_3columns  "trailing blanks in char fields are lost!!  mentioned in FM:(no fixed column length)
    TABLES
      fields               = it_3fieldnames   "both    in: subset of fields (optional)  out:  attributes for fields
    EXCEPTIONS
      table_not_available  = 1
      table_without_data   = 2
      option_not_valid     = 3
      field_not_valid      = 4
      not_authorized       = 5
      data_buffer_exceeded = 6
      OTHERS               = 7.
  IF sy-subrc <> 0.
    IF sy-msgty IS INITIAL.
      WRITE : 'RFC failed (2. FM call).'.
    ELSE.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.

  LOOP AT lt_3columns INTO DATA(lv_string).
    CLEAR ls_json.
    FIND FIRST OCCURRENCE OF '|' IN lv_string-line+4 RESULTS DATA(ls_length_varname).
    DATA(json_start) = 4 + ls_length_varname-offset + 1.
    DATA(total_length) = strlen( lv_string-line ).
    IF total_length GT json_start.
      ls_json-step_number  = lv_string-line(3).
      ls_json-varname      = lv_string-line+4(ls_length_varname-offset).
      ls_json-input_string = lv_string-line+json_start.
      APPEND ls_json TO ct_json.
    ENDIF.
  ENDLOOP.

  SORT ct_json BY varname	step_number.

ENDFORM.
