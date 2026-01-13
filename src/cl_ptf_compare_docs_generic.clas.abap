class CL_PTF_COMPARE_DOCS_GENERIC definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ty_gs_count,
      compared           TYPE i, "fields
      compared_not_empty TYPE i, "fields
      records            type i,
    END OF ty_gs_count .

  methods COMPARE_RECORDS
    importing
      !IR_ACT_TAB type ref to DATA
      !IR_EXP_TAB type ref to DATA
      !IT_FIELDS_TO_IGNORE type DDFIELDNAMES optional
    exporting
      !ET_FINDING type HRTB_ALEOX_MSG_LONGTXT
      !ES_INFO type TY_GS_COUNT .
  PROTECTED SECTION.
private section.
ENDCLASS.



CLASS CL_PTF_COMPARE_DOCS_GENERIC IMPLEMENTATION.


  METHOD compare_records.

    "expects the itabs IR_ACT_TAB and IR_EXP_TAB are referring to have a sorted content

    DATA:
      ref_rowtype       TYPE REF TO cl_abap_structdescr,
      ref_tabletype     TYPE REF TO cl_abap_tabledescr,
      lt_ignore         TYPE STANDARD TABLE OF fieldname,
      cnt_record        TYPE i,
      lb_key_was_logged TYPE abap_bool,
      lt_fieldinfo      TYPE extdfiest,
      ls_fieldinfo      TYPE LINE OF extdfiest,
      lv_fieldname      TYPE fieldname,
      lv_fieldvalue     TYPE string,
      msg_str1          TYPE string,
      msg_str2          TYPE string.

    FIELD-SYMBOLS:
      <lv_exp_fieldvalue> TYPE any,
      <lv_act_fieldvalue> TYPE any.

    CLEAR: et_finding, es_info.

    ref_tabletype ?= cl_abap_typedescr=>describe_by_data_ref( ir_act_tab ).
    ref_rowtype   ?= ref_tabletype->get_table_line_type( ).
    DATA(itable_name)  = ref_tabletype->get_relative_name( ).
    DATA(rowtype_name) = ref_rowtype->get_relative_name( ).

    IF ref_rowtype IS NOT BOUND.
      ASSERT 1 = 2.       "todo: set error
      RETURN.
    ENDIF.

    IF it_fields_to_ignore IS NOT INITIAL.
      lt_ignore = it_fields_to_ignore.
    ELSE.
      IF rowtype_name EQ 'VBRK'.
        lt_ignore = VALUE #(
        ( 'VBELN' )
        ( 'KNUMV' )
        ( 'ZUKRI' )
        ( 'XBLNR' )
        ( 'ZUONR' )
        ( 'KIDNO' )
        ( 'ERNAM' )
        ( 'ERDAT' )
        ( 'AEDAT' )
        ( 'CHANGED_ON' )
         ).
*      ELSEIF rowtype_name EQ 'VBAK'.
*        lt_ignore = VALUE #(
*        ( 'VBELN' )
*        ...
      ENDIF.
    ENDIF.



    DATA lr_structure_exp TYPE REF TO data.
    DATA lr_structure_act TYPE REF TO data.
    CREATE DATA lr_structure_exp TYPE HANDLE ref_rowtype.
    CREATE DATA lr_structure_act TYPE HANDLE ref_rowtype.


    CLEAR lt_fieldinfo.
    CALL FUNCTION 'DD_INT_TABLINFO_GET'
      EXPORTING
        typename       = CONV tabname( rowtype_name )
      TABLES
        extdfies_tab   = lt_fieldinfo
      EXCEPTIONS
        not_found      = 1
        internal_error = 2
        OTHERS         = 3.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.


    IF ir_exp_tab->* IS INITIAL AND ir_act_tab->* IS INITIAL.
      APPEND  |Both tables are empty.| TO et_finding.
    ENDIF.

    IF lines( ir_exp_tab->* ) NE lines( ir_act_tab->* ).
      APPEND  |# Records expected: { lines( ir_exp_tab->* ) }. # Records actual: { lines( ir_act_tab->* ) }| TO et_finding.
    ENDIF.
*   Note: Key field values are compared like normal attributes (if not ignored). They are not used for access.


    LOOP AT ir_exp_tab->* INTO lr_structure_exp->*.
      CLEAR lb_key_was_logged.
      ADD 1 TO cnt_record.
      FIELD-SYMBOLS <itab> TYPE table.
      ASSIGN ir_act_tab->* TO <itab>.
      READ TABLE <itab> INDEX sy-tabix REFERENCE INTO lr_structure_act .               "READ TABLE lr_itab_act->*  doesn't work with index...

      CLEAR ls_fieldinfo.
      LOOP AT lt_fieldinfo INTO ls_fieldinfo.

        "skip fields from ignore list
        READ TABLE lt_ignore WITH KEY table_line = ls_fieldinfo-fieldname TRANSPORTING NO FIELDS.
        IF sy-subrc IS INITIAL.
          IF cnt_record EQ 1. "count ignored fields only for first record
*            WRITE: / |{ ls_fieldinfo-fieldname } shall be ignored.|.
            DATA lt_ignored_fields TYPE STANDARD TABLE OF fieldname.
            APPEND ls_fieldinfo-fieldname TO lt_ignored_fields.
          ENDIF.
          CONTINUE.
        ENDIF.

        ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE lr_structure_exp->* TO <lv_exp_fieldvalue>.
        ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE lr_structure_act->* TO <lv_act_fieldvalue>.

        IF cnt_record EQ 1. "count compared fields only for first record
          ADD 1 TO es_info-compared.
          IF <lv_exp_fieldvalue> IS NOT INITIAL.
            ADD 1 TO es_info-compared_not_empty.
          ENDIF.
        ENDIF.

        IF <lv_exp_fieldvalue> NE <lv_act_fieldvalue>.
          msg_str1 = '"' && <lv_exp_fieldvalue> && '"'.
          msg_str2 = '"' && <lv_act_fieldvalue> && '"'.

          IF lb_key_was_logged IS INITIAL.
            lb_key_was_logged = abap_true.
            DATA(lr_key) = NEW cl_ptf_run( VALUE #( ( ) ) )->get_key_structure_by_db_table( CONV #( rowtype_name ) ).
            ASSERT lr_key IS BOUND.
            MOVE-CORRESPONDING lr_structure_exp->* TO lr_key->*.
            APPEND  |Record key: { CONV char80( lr_key->* ) }| TO et_finding.
          ENDIF.

          APPEND  |{ ls_fieldinfo-fieldname }: Expected:{ msg_str1 } Actual:{ msg_str2 }| TO et_finding.
        ENDIF.

      ENDLOOP.

    ENDLOOP.

    es_info-records = cnt_record.

  ENDMETHOD.
ENDCLASS.
