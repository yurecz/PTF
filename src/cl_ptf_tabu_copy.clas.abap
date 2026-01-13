class CL_PTF_TABU_COPY definition
  public
  final
  create public .

public section.

  interfaces IF_OO_ADT_CLASSRUN .
protected section.
private section.

  types:
    BEGIN OF ty_s_json,
      varname	     TYPE ptf_varname,
      step_number  TYPE n LENGTH 3,
      input_string TYPE	ptf_json_string,
    END OF ty_s_json .
  types:
    ty_t_json TYPE STANDARD TABLE OF ty_s_json WITH key varname step_number .

  class-data SC_RFCDEST type RFCDEST value 'HOME' ##NO_TEXT.

  methods GET_VARCON_JSON_DATA
    returning
      value(RT_RESULT) type TY_T_JSON .
ENDCLASS.



CLASS CL_PTF_TABU_COPY IMPLEMENTATION.


  METHOD get_varcon_json_data. "Fill itab for records which have a JSON, using dedicated RTFC table read

    DATA it_3fieldnames TYPE STANDARD TABLE OF rfc_db_fld ."OCCURS 0.
    it_3fieldnames = VALUE #( ( fieldname = 'STEP_NUMBER' ) ( fieldname = 'VARNAME' ) ( fieldname = 'INPUT_STRING' ) ).

    DATA lt_3columns TYPE sdti_result_tab.
    DATA ls_json TYPE ty_s_json.

    "CALL FM for 2 key fields + field INPUT_STRING
    CALL FUNCTION 'RFC_READ_TABLE'
      DESTINATION sc_rfcdest
      EXPORTING
        query_table          = 'PTF_VARCON'
        delimiter            = '|'            "here with delimiter
        no_data              = ' '
*       rowskips             = 0
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
        WRITE : 'RFC failed.'.
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
        APPEND ls_json TO rt_result.
      ENDIF.
    ENDLOOP.

    SORT rt_result BY varname step_number.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

* Copies content of PTF db tables (metadata and scripts) from RFC destination
* Use only in decentral systems

************************************************************************
*        DATA
************************************************************************
    FIELD-SYMBOLS : <l_table> TYPE table,
                    <l_line>  TYPE any.
    FIELD-SYMBOLS : <l_field> TYPE any.
*    DATA: zflag TYPE c.
    DATA lv_tabnam TYPE dd02l-tabname.

    DATA p_source TYPE rfcdest VALUE 'HOME'. "'CIL'.
************************************************************************
*        INTERNAL TABLES
************************************************************************
    TYPES: BEGIN OF ty_c4000,
             wa TYPE c LENGTH 4000,
           END OF  ty_c4000.
    DATA: lt_data   TYPE STANDARD TABLE OF ty_c4000, "LIKE STANDARD TABLE OF DPS_RFC_TAB_4000_S,"
          lt_fields TYPE STANDARD TABLE OF rfc_db_fld, " LIKE rfc_db_fld OCCURS 0 WITH HEADER LINE,
          ls_field  TYPE rfc_db_fld,
          lt_tabnam TYPE TABLE OF dd02l-tabname.


    "Authority check
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

    ASSERT sy-sysid EQ 'C50'.



    DATA p_tabnam TYPE RANGE OF dd02l-tabname.
    DATA ls_tabnam LIKE LINE OF p_tabnam.
    ls_tabnam-sign = 'I'.
    ls_tabnam-option ='EQ'.

*  IF p_scrpt EQ 'X'.
    ls_tabnam-low	= 'PTF_VARCAT'. APPEND ls_tabnam TO p_tabnam.
    ls_tabnam-low	= 'PTF_VARCON'. APPEND ls_tabnam TO p_tabnam.
    ls_tabnam-low	= 'PTF_VARREF'. APPEND ls_tabnam TO p_tabnam.
    ls_tabnam-low	= 'PTF_VARID'.  APPEND ls_tabnam TO p_tabnam.
    ls_tabnam-low	= 'PTF_VARID_T'. APPEND ls_tabnam TO p_tabnam.
    ls_tabnam-low	= 'PTF_VAREXPMESS'. APPEND ls_tabnam TO p_tabnam.
    ls_tabnam-low	= 'PTF_INPUT_REPO'. APPEND ls_tabnam TO p_tabnam.
    ls_tabnam-low	= 'PTF_VARDATASET'. APPEND ls_tabnam TO p_tabnam.
*  ENDIF.

*  IF p_metadt EQ 'X'.
    ls_tabnam-low	= 'PTFBO'.  APPEND ls_tabnam TO p_tabnam.
    ls_tabnam-low	= 'PTFBOT'. APPEND ls_tabnam TO p_tabnam.
    ls_tabnam-low	= 'PTFBOA'. APPEND ls_tabnam TO p_tabnam.
    ls_tabnam-low	= 'PTFBOAT'. APPEND ls_tabnam TO p_tabnam.
*  ENDIF.

*  IF 1 = 2.
    ls_tabnam-low  = 'PTF_VAR_TAG'.  APPEND ls_tabnam TO p_tabnam.
    ls_tabnam-low  = 'PTF_VAR_TAGT'.  APPEND ls_tabnam TO p_tabnam.
    ls_tabnam-low  = 'PTF_VAR_TAG_MAP'.  APPEND ls_tabnam TO p_tabnam.
*  ENDIF.



    CHECK p_tabnam[] IS NOT INITIAL.
    SELECT tabname  FROM dd02l INTO TABLE lt_tabnam WHERE tabname IN p_tabnam.

    "LOOP over all db tables
    LOOP AT lt_tabnam INTO lv_tabnam.

* Retrieve Table definition
*      WRITE : / lv_tabnam. ""
*    PERFORM frm_init_internal_table USING lv_tabnam.
****
*FORM frm_init_internal_table USING    p_p_tabnam.
      DATA: d_ref      TYPE REF TO data,
            new_line   TYPE REF TO data,
            i_alv_cat  TYPE TABLE OF lvc_s_fcat,
            ls_alv_cat LIKE LINE OF i_alv_cat.

      DATA itab TYPE STANDARD TABLE OF dntab.
*  DATA: BEGIN OF itab OCCURS 0.
*          INCLUDE STRUCTURE dntab.
*  DATA: END OF itab.

      CLEAR itab.
      CLEAR ls_field.
      CLEAR lt_fields.
      CLEAR i_alv_cat.

      CALL FUNCTION 'NAMETAB_GET'
        EXPORTING
          langu          = sy-langu
          tabname        = lv_tabnam
        TABLES
          nametab        = itab
        EXCEPTIONS
          no_texts_found = 1.

      LOOP AT itab INTO DATA(ls_itab).
        ls_alv_cat-fieldname = ls_itab-fieldname.
        ls_alv_cat-ref_table = lv_tabnam.
        ls_alv_cat-ref_field = ls_itab-fieldname.
        APPEND ls_alv_cat TO i_alv_cat.
        ls_field-fieldname = ls_itab-fieldname.
        APPEND ls_field TO lt_fields.
      ENDLOOP.

*     Create a new table.
      CALL METHOD cl_alv_table_create=>create_dynamic_table
        EXPORTING
          it_fieldcatalog = i_alv_cat
        IMPORTING
          ep_table        = d_ref.

*     Create a new Line with the same structure of the table.
      ASSIGN d_ref->* TO <l_table>.
      CREATE DATA new_line LIKE LINE OF <l_table>.
      ASSIGN new_line->* TO <l_line>.

*ENDFORM.                    " frm_init_internal_table
****


* Clear data -  NOT DONE

* Copy
*    IF p_copy = abap_true.
*      PERFORM frm_get_data_via_rfc USING lv_tabnam. " Get data via RFC
*****
*FORM frm_get_data_via_rfc  USING    p_p_tabnam.

      CLEAR lt_data.
      DATA lt_options_empty TYPE STANDARD TABLE OF rfc_db_opt.
      CLEAR lt_options_empty.
      CLEAR <l_table>.
*  it_options-text = p_sel_op.
*  APPEND it_options.

* Get table data via RFC

      CALL FUNCTION 'RFC_READ_TABLE'
        DESTINATION sc_rfcdest
        EXPORTING
          query_table          = lv_tabnam
*         DELIMITER            = ' '
          no_data              = ' '
*         rowskips             = 0
          rowcount             = 0
        TABLES
          options              = lt_options_empty
          fields               = lt_fields
          data                 = lt_data
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

      IF lv_tabnam EQ 'PTF_VARCON'.
        DATA(lt_json) = get_varcon_json_data( ).
      ENDIF.

      DATA lv_varname TYPE ptf_varname.
      DATA lv_stepno TYPE n LENGTH 3.

*     Data convert
      SORT lt_data.
      LOOP AT lt_data INTO DATA(ls_data).
        "one record

        CLEAR <l_line>.
        CLEAR: lv_stepno, lv_varname.
*        CLEAR zflag.

        "Do not copy script 'AUNIT05'. Allows to spot in a client that the scripts are coming from this class, not from the image
        IF lv_tabnam EQ 'PTF_VARID'.
          IF ls_data+3(7) EQ 'AUNIT05'.
            CONTINUE.
          ENDIF.
        ENDIF.

        LOOP AT lt_fields INTO ls_field.

          IF lv_tabnam EQ 'PTF_VARCON'.
            IF ls_field-fieldname EQ 'INPUT_STRING' AND ls_data+3(9) EQ 'DEMO_RAP_'.
              CHECK 1 NE 2. "allow breakpoint
            ENDIF.
          ENDIF.

          ASSIGN COMPONENT ls_field-fieldname OF STRUCTURE <l_line> TO <l_field>.
          "copy field value
          <l_field> = ls_data+ls_field-offset(ls_field-length).

          IF ls_field-fieldname EQ 'STEP_NUMBER'.
            lv_stepno = <l_field>.
          ENDIF.
          IF ls_field-fieldname EQ 'VARNAME'.
            lv_varname = <l_field>.
          ENDIF.

        ENDLOOP.

        IF lv_tabnam EQ 'PTF_VARCON'.
          "access itab lt_json with varname and stepNo, copy json to field INPUT_STRING of the assigned record
          READ TABLE lt_json WITH KEY varname = lv_varname step_number = lv_stepno ASSIGNING FIELD-SYMBOL(<ls_json>).
          IF sy-subrc IS INITIAL AND <ls_json>-input_string IS NOT INITIAL.
            ASSIGN COMPONENT 'INPUT_STRING' OF STRUCTURE <l_line> TO <l_field>.
            <l_field> = <ls_json>-input_string.
            DATA lv_enrich_count TYPE i.
            ADD 1 TO lv_enrich_count.
          ENDIF.
        ENDIF.

*        IF zflag = 'X'.
*          CONTINUE.
*        ELSE.
        APPEND <l_line> TO <l_table>.
*        ENDIF.
      ENDLOOP.

*ENDFORM.                    " frm_get_data_via_rfc
****

*      PERFORM frm_insert_data USING lv_tabnam.      " Insert data
****
*FORM frm_insert_data  USING    p_p_tabnam.

*  FIELD-SYMBOLS : <l_field> TYPE any.

      DO 1 TIMES.

*Delete empty lines from itab
        LOOP AT <l_table> ASSIGNING <l_line>.
          IF <l_line> IS INITIAL.
            DELETE <l_table>.
          ENDIF.
        ENDLOOP.

        SELECT COUNT( * ) FROM (lv_tabnam) INTO @DATA(count).
        IF count IS NOT INITIAL.
          IF out IS BOUND.
            WRITE : 'Skipping non initial table:' , lv_tabnam.
            out->write( 'Did not copy' && lv_tabnam && 'which was not initial in target system' ).
          ENDIF.
          EXIT. "DO ENDDO
        ENDIF.

        ASSERT sy-sysid(2) NE 'ER'.

*       INSERT data to database
        MODIFY (lv_tabnam) FROM TABLE <l_table>.
        IF out IS BOUND.
          WRITE : 'Modify' , sy-dbcnt.
          out->write( 'Copied content of table' && lv_tabnam && ', records:' && sy-dbcnt ).
        ENDIF.

      ENDDO.

*  ENDFORM.                    " frm_insert_data
****

*    ENDIF.   "p_copy = abap_true.

*    IF p_test = abap_false.
      COMMIT WORK.  "per table
*    ELSE.
*      ROLLBACK WORK.
*      WRITE: / 'Test flag set: ROLLBACK WORK'.
*    ENDIF.

    ENDLOOP.


  ENDMETHOD.
ENDCLASS.
