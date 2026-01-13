CLASS tcl_ptf_db_mock_util DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  FOR TESTING .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_struc,
        tablename TYPE tabname16,
        data_ref  TYPE REF TO data,
      END OF ty_struc .
    TYPES:
      ty_content_tab TYPE STANDARD TABLE OF ty_struc .

    CLASS-DATA mv_tdc TYPE etobj_name .
    CLASS-DATA mv_tdcv TYPE etvar_id .

*  types:
*    BEGIN OF ty_gs_ptf_field,
*      fieldname  TYPE name_feld,
*      fieldvalue TYPE string,    "works for non-c-like types?
*    END OF ty_gs_ptf_field .
*  types:
*    ty_gt_ptf_field TYPE STANDARD TABLE OF ty_gs_ptf_field WITH DEFAULT KEY .
*  types:
** Structure for changes within one record
*    BEGIN OF ty_gs_record,
*      key_fields    TYPE ty_gt_ptf_field,
*      mocked_fields TYPE ty_gt_ptf_field,
*    END OF ty_gs_record .
*  types:
*    ty_gt_record TYPE STANDARD TABLE OF ty_gs_record WITH DEFAULT KEY .
*  types:
** Structure for delta mocking (table-indep. type, fields of existing record)
*    BEGIN OF ty_gs_delta_mock_td,
*      dbtable            TYPE tabname16,
*      changes_per_record TYPE ty_gt_record,
*    END OF ty_gs_delta_mock_td .
*  "typing tdc parameter
*  types:
*    ty_gt_delta_mock_td TYPE STANDARD TABLE OF ty_gs_delta_mock_td WITH DEFAULT KEY .
*  types:
** Structure for other mocking modes (TVFK, 3 modes)
*  "typing tdc parameter
*    BEGIN OF ty_gs_mock_tvfk_td,
*      dbtable      TYPE tabname16,
*      mock_mode    TYPE c LENGTH 1,
*              "values: ALL - Full replacement of table content
*              "        INS - Record insertion
*              "        DEL - Record deletion
*      tvfk_content TYPE STANDARD TABLE OF tvfk WITH DEFAULT KEY,
*    END OF ty_gs_mock_tvfk_td .
**  types:
**    ty_gt_mock_tvfk_td TYPE STANDARD TABLE OF ty_gs_mock_tvfk_td WITH DEFAULT KEY .
    CLASS-METHODS startmock
      EXPORTING
        !et_content TYPE ty_content_tab .
    CLASS-METHODS endmock .
    CLASS-METHODS get_log
      RETURNING
        VALUE(rt_log) TYPE cl_ptf_util=>gt_ptf_return_tab .
    CLASS-METHODS get_key_fields_of_dbtable
      IMPORTING
        !iv_table_name     TYPE tabname16
      RETURNING
        VALUE(rt_keyfield) TYPE ddfieldnames .
    CLASS-METHODS remock
      EXPORTING
        !et_content TYPE ty_content_tab .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA mt_log TYPE cl_ptf_util=>gt_ptf_return_tab .
    CLASS-DATA environment TYPE REF TO if_osql_test_environment .
    CLASS-METHODS replace_system_fields
      IMPORTING
        iv_dbtable TYPE ddobjname
      CHANGING
        ct_content TYPE STANDARD TABLE.
ENDCLASS.



CLASS TCL_PTF_DB_MOCK_UTIL IMPLEMENTATION.


  METHOD endmock.

    IF environment IS BOUND.
      environment->destroy( ).
    ENDIF.
    APPEND VALUE #( message =  | Mocking ended for all DB tables. | ) TO mt_log.

  ENDMETHOD.


  METHOD get_key_fields_of_dbtable.

*        LOOP AT ls_table-changes_per_record REFERENCE INTO DATA(lr_per_record).
*          LOOP AT ls_per_record->key_fields REFERENCE INTO DATA(lr_key_field).
*            APPEND lr_key_field->fieldname TO lt_key.
*          ENDLOOP.
*        ENDLOOP.

    DATA: gotstate   TYPE  ddgotstate,
          dd02v_wa   TYPE  dd02v,
          dd09l_wa   TYPE  dd09v,
          dd03p_tab  TYPE STANDARD TABLE OF dd03p,
          lv_dd_name TYPE ddobjname.

    CLEAR rt_keyfield.

    lv_dd_name = iv_table_name.
    CALL FUNCTION 'DDIF_TABL_GET'
      EXPORTING
        name          = lv_dd_name
      IMPORTING
        gotstate      = gotstate
        dd02v_wa      = dd02v_wa
        dd09l_wa      = dd09l_wa
      TABLES
        dd03p_tab     = dd03p_tab
      EXCEPTIONS
        illegal_input = 1
        OTHERS        = 2.
    IF sy-subrc IS NOT INITIAL.
      RETURN.
    ENDIF.

    LOOP AT dd03p_tab REFERENCE INTO DATA(lr_field) WHERE keyflag = 'X' .
      CHECK lr_field->fieldname NE '.INCLUDE'.
      APPEND lr_field->fieldname TO rt_keyfield.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_log.

    rt_log = mt_log.

  ENDMETHOD.


  METHOD remock.

    DATA dbtable_list TYPE STANDARD TABLE OF ddstrucobjname.
    DATA lv_dbtable_2 TYPE ddstrucobjname.
    DATA lr_mock_table_content TYPE REF TO data.
    FIELD-SYMBOLS <lt_mock_table_content> TYPE STANDARD TABLE.

    IMPORT table_list = dbtable_list FROM MEMORY ID 'PTF_MOCKED_TABLES'.
    IF dbtable_list IS INITIAL.
      APPEND VALUE #( message =  | ERROR occurred in DB mocking. | ) TO mt_log.
      RETURN.
    ENDIF.

    environment = cl_osql_test_environment=>create( i_dependency_list = dbtable_list ).  "This method should be called only once per test class.

    TRY.
        cl_osql_replace=>set_survive_submit( ).
      CATCH cx_osql_replace .
        ASSERT 1 = 2.
    ENDTRY.


    LOOP AT dbtable_list INTO DATA(lv_dbtable).

      CREATE DATA lr_mock_table_content TYPE STANDARD TABLE OF (lv_dbtable).
      ASSIGN lr_mock_table_content->* TO <lt_mock_table_content>.
      IMPORT
        dbtable   = lv_dbtable_2
        t_content = <lt_mock_table_content>
        FROM MEMORY ID lv_dbtable.
      IF lv_dbtable NE lv_dbtable_2.
        "BREAK-POINT.
      ENDIF.
      environment->insert_test_data( <lt_mock_table_content> ).
      IF <lt_mock_table_content> IS INITIAL.
        APPEND VALUE #( message =  | Info: Table { lv_dbtable } is still mocked with empty content. | ) TO mt_log.
      ENDIF.

    ENDLOOP.

    APPEND VALUE #( message =  | Mock content taken over from the prec. step for { lines( dbtable_list ) } tables. | ) TO mt_log.
    APPEND VALUE #( message = |-- End of mock details ------------------------------| ) TO mt_log.


    "Allow to look at the mocking result in debugging
    DATA lr_debug_content TYPE REF TO data.
    CONSTANTS lc_param_name TYPE c LENGTH 20 VALUE 'READ_MOCKED_DB'.
    CONSTANTS lc_param_value_on TYPE c LENGTH 20 VALUE 'DEBUG'.
    SELECT SINGLE * FROM ptf_ctrl_prmtr INTO @DATA(ls_parameter) WHERE parameter_name = @lc_param_name.
    IF sy-subrc IS INITIAL  AND  ls_parameter-value EQ lc_param_value_on.
      LOOP AT dbtable_list INTO lv_dbtable.
        CREATE DATA lr_debug_content TYPE STANDARD TABLE OF (lv_dbtable).
        SELECT * FROM (lv_dbtable) INTO TABLE @lr_debug_content->*.
        IF sy-subrc IS INITIAL.
          DATA(lines) = lines( lr_debug_content->* ).
          CHECK 1 = 1.
        ELSE.
          CHECK 1 = 1.
        ENDIF.
        CLEAR lr_debug_content->*.
        CLEAR lr_debug_content.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD replace_system_fields.
    DATA: gotstate   TYPE  ddgotstate,
          dd02v_wa   TYPE  dd02v,
          dd09l_wa   TYPE  dd09v,
          dd03p_tab  TYPE STANDARD TABLE OF dd03p,
          lv_field_name  type string  .
    IF ct_content IS INITIAL.
      RETURN.
    ENDIF.
    CALL FUNCTION 'DDIF_TABL_GET'
      EXPORTING
        name          = iv_dbtable
      IMPORTING
        gotstate      = gotstate
        dd02v_wa      = dd02v_wa
        dd09l_wa      = dd09l_wa
      TABLES
        dd03p_tab     = dd03p_tab
      EXCEPTIONS
        illegal_input = 1
        OTHERS        = 2.
    IF sy-subrc IS NOT INITIAL.
      RETURN.
    ENDIF.
    LOOP AT ct_content ASSIGNING FIELD-SYMBOL(<ls_table_row>).
      LOOP AT dd03p_tab REFERENCE INTO DATA(lr_field).
        ASSIGN COMPONENT lr_field->fieldname OF STRUCTURE <ls_table_row> TO FIELD-SYMBOL(<lv_value>).
        IF <lv_value> IS ASSIGNED.
          lv_field_name = <lv_value>.
          cl_ptf_util=>get_syst_field( EXPORTING iv_field_name = lv_field_name IMPORTING ev_field_value = <lv_value> ).
          UNASSIGN <lv_value>.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.


  METHOD startmock.

    "per table: define data. create envir. inject.

    DATA lo_access_tdc TYPE REF TO cl_apl_ecatt_tdc_api.
    DATA lt_parameter TYPE etpar_ref_tabtype.
    DATA lt_key TYPE STANDARD TABLE OF fieldname.
    DATA lr_mock_table_content TYPE REF TO data.
    FIELD-SYMBOLS <lt_mock_table_content> TYPE STANDARD TABLE.
    DATA lr_last_version TYPE REF TO ty_struc.
    DATA lb_new_table TYPE abap_bool.

    "use local TDC if existing, priority before transported TDC
    TRY.
        lo_access_tdc = cl_apl_ecatt_tdc_api=>get_instance( 'Z' && mv_tdc ).
        lt_parameter = lo_access_tdc->get_variant_content( i_variant_name = 'Z' && mv_tdcv ).
        APPEND VALUE #( message =  | Using local TDC { 'Z' && mv_tdc }| ) TO mt_log.
      CATCH cx_ecatt_tdc_access.
        "no problem, as local TDC is optional. use HOME TDC
        TRY.
            lo_access_tdc = cl_apl_ecatt_tdc_api=>get_instance( mv_tdc ).
          CATCH cx_ecatt_tdc_access.
            APPEND VALUE #( message =  | Error when accessing TDC { mv_tdc }| ) TO mt_log.
            RETURN. "toDO: for this and the RETURN 6 lines below, caller TCL_PTF_STEP_IN_AU-EXECUTE_PTF_STEP incorrectly assumes that mocking was succesfully started.
        ENDTRY.
        TRY.
            lt_parameter = lo_access_tdc->get_variant_content( i_variant_name = mv_tdcv ).
          CATCH cx_ecatt_tdc_access.
            APPEND VALUE #( message =  | Error when accessing TDC variant { mv_tdcv }| ) TO mt_log.
            RETURN.
        ENDTRY.
    ENDTRY.


    "Handle all TABLE SPECIFIC tdc parameters (mock modes F,I,D)

    FIELD-SYMBOLS <param_value> TYPE any.
    FIELD-SYMBOLS <lt_param_content_records> TYPE STANDARD TABLE.

    LOOP AT lt_parameter INTO DATA(ls_param) ."WHERE parname(19) NE 'FIELD_DELTA_GENERIC'.
      CLEAR lb_new_table.
      CLEAR lr_mock_table_content.

*     "parameter type
      DATA(lo_type_desc) = cl_abap_typedescr=>describe_by_data_ref( p_data_ref =  ls_param-value_ref ).
      CHECK lo_type_desc->absolute_name IS NOT INITIAL.
      DATA(rel_name) = lo_type_desc->get_relative_name( ).
      CHECK rel_name NE 'TY_GT_GEN_DELTA_MOCK_TD'. "generic mocking will be handled after specific mocking, separately.
      CHECK ls_param-parname(6) EQ 'TABLE_'.

      IF  lo_type_desc->kind EQ cl_abap_typedescr=>kind_struct.
        "ASSIGN ls_param-value_ref->* TO <param_value>.  "structure-typed parameters
        APPEND VALUE #( message =  | TDC param. { ls_param-parname  } with type structure ignored. Use table types for TDC params that mock a dedicated db table (modes F,I,D).| ) TO mt_log.
        CONTINUE.
      ELSEIF  lo_type_desc->kind NE cl_abap_typedescr=>kind_table.
        APPEND VALUE #( message =  | TDC param. { ls_param-parname  } with type of kind { lo_type_desc->kind } ignored.| ) TO mt_log.
        CONTINUE.
      ENDIF.
*      IF lo_type_desc->kind EQ cl_abap_typedescr=>kind_table.
      FIELD-SYMBOLS <lt_table> TYPE STANDARD TABLE.
*      CREATE DATA lr_table TYPE STANDARD TABLE OF (lo_type_desc->absolute_name).
      ASSIGN ls_param-value_ref->* TO <lt_table>.
      "Loop at <lt_table> ASSIGNING FIELD-SYMBOL(<mockrequest>).
      READ TABLE <lt_table> INDEX 1 ASSIGNING FIELD-SYMBOL(<mockrequest>). "TEMP, full compatible but does not leverage more than 1 entry
      CHECK sy-subrc IS INITIAL. "ignore empty table parameters
      ASSIGN <mockrequest> TO <param_value>.
*      ENDIF.


      "header level (tablename, mock mode)

      CHECK <param_value> IS NOT INITIAL. "empty table or initial structure
      ASSIGN COMPONENT 'DBTABLE'   OF STRUCTURE <param_value> TO FIELD-SYMBOL(<dbtable>).
      ASSIGN COMPONENT 'MOCK_MODE' OF STRUCTURE <param_value> TO FIELD-SYMBOL(<mock_mode>).
      ASSIGN COMPONENT 'CONTENT'   OF STRUCTURE <param_value> TO <lt_param_content_records>.


      "content type

      CHECK <dbtable> IS NOT INITIAL.
      "CHECK <dbtable> EQ ls_param-parname+6.
      <dbtable> = to_upper( <dbtable> ).
      TRY.
          cl_abap_dyn_prg=>check_table_name_str( val = <dbtable> packages = space ).
        CATCH cx_abap_not_a_table.
          APPEND VALUE #( message =  | { <dbtable> } is not a db table| ) TO mt_log.
          RETURN.
        CATCH cx_abap_not_in_package.
      ENDTRY.

      lt_key = get_key_fields_of_dbtable( <dbtable> ).
      IF lt_key IS INITIAL.
        APPEND VALUE #( message =  | Error in FM DDIF_TABL_GET for db table { <dbtable> } . Entry ignored. | ) TO mt_log.
        CONTINUE.
      ENDIF.
      CREATE DATA lr_mock_table_content TYPE STANDARD TABLE OF (<dbtable>) WITH KEY (lt_key).
      ASSIGN lr_mock_table_content->* TO <lt_mock_table_content>.
      ASSERT sy-subrc IS INITIAL.


      "content         fill <lt_mock_table_content> from TDC and/or db

      "If there is a field MANDT, fill it.
      IF <lt_param_content_records> IS NOT INITIAL.
        ASSIGN COMPONENT 'MANDT' OF STRUCTURE <lt_param_content_records>[ 1 ] TO FIELD-SYMBOL(<dummy>).
        IF sy-subrc IS NOT INITIAL.
          ASSIGN COMPONENT 'CLIENT' OF STRUCTURE <lt_param_content_records>[ 1 ] TO <dummy>.
        ENDIF.
        IF sy-subrc IS INITIAL.
          IF <dummy> IS INITIAL.
            LOOP AT <lt_param_content_records> ASSIGNING FIELD-SYMBOL(<rec>).
              ASSIGN COMPONENT 1 OF STRUCTURE <rec> TO FIELD-SYMBOL(<mandt>).
              <mandt> = sy-mandt.
            ENDLOOP.
          ELSE.
            APPEND VALUE #( message =  | MANDT filled with '{ <dummy> }', PTF will not overwrite it.| ) TO mt_log.
          ENDIF.
        ENDIF. "structure is client specific
      ENDIF.
      replace_system_fields( EXPORTING iv_dbtable = CONV #( <dbtable> ) CHANGING ct_content = <lt_param_content_records> ).

      IF <mock_mode> EQ cl_ptf_util=>gc_mock_mode_all.
        "Mock mode 4 / ALL / Full replacement of table content”
        READ TABLE et_content WITH KEY tablename = <dbtable> REFERENCE INTO lr_last_version.     "prüfen, ob tabelle bereits in lt_content drin ist
        IF sy-subrc IS INITIAL.
          "alter content wird ist irrelevant
        ELSE.
          lb_new_table = 'X'.
        ENDIF.
        <lt_mock_table_content> = <lt_param_content_records>.

      ELSEIF <mock_mode> EQ cl_ptf_util=>gc_mock_mode_ins.
        "Mock mode 2 / INS / Fake a record insertion”
        READ TABLE et_content WITH KEY tablename = <dbtable> REFERENCE INTO lr_last_version.     "prüfen, ob tabelle bereits in lt_content drin ist
        IF sy-subrc IS INITIAL.
          ASSIGN lr_last_version->data_ref->* TO <lt_mock_table_content>.    "wird ziel upgedated, auf das auch die ref in der itab zeigt?
        ELSE.
          lb_new_table = 'X'.
          SELECT * FROM (<dbtable>) INTO TABLE @<lt_mock_table_content>.
        ENDIF.
        APPEND LINES OF <lt_param_content_records> TO <lt_mock_table_content>.

      ELSEIF <mock_mode> EQ cl_ptf_util=>gc_mock_mode_del.
        "Mock mode 3 / DEL / Fake a record deletion
        READ TABLE et_content WITH KEY tablename = <dbtable> REFERENCE INTO lr_last_version.   "prüfen, ob tabelle bereits in lt_content drin ist
        IF sy-subrc IS INITIAL.
          ASSIGN lr_last_version->data_ref->* TO <lt_mock_table_content>.
        ELSE.
          lb_new_table = 'X'.
          SELECT * FROM (<dbtable>) INTO TABLE @<lt_mock_table_content>.
        ENDIF.
        LOOP AT <lt_param_content_records> ASSIGNING FIELD-SYMBOL(<ls_hide>).
          DELETE TABLE <lt_mock_table_content> FROM <ls_hide>. "die erzeugte Tabelle muss mit key , mit korrekten Schlüsselfeldern, definiert sein...
          "  ( CREATE DATA lr_mock_table_content TYPE STANDARD TABLE OF (<dbtable>) WITH KEY mandt spras fkart. )
          "... sonst wird für die Tabelle der default key genutzt, und alle felder müssten im TDC gefüllt sein, nicht nur die schlüsselfelder. das wäre unschön.
        ENDLOOP.
      ELSEIF <mock_mode> EQ cl_ptf_util=>gc_mock_mode_upd.
        APPEND VALUE #( message =  | Mock mode { <mock_mode> } given for TDC param. { ls_param-parname }. This is not supported, do use TDC param. FIELD_DELTA_GENERIC for mode 'U'.| ) TO mt_log.
        APPEND VALUE #( message =  | Mocking cancelled.| ) TO mt_log.
      ELSE.
        APPEND VALUE #( message =  | Unknown mock mode <{ <mock_mode> }> given for TDC parameter { ls_param-parname }.| ) TO mt_log.
        APPEND VALUE #( message =  | Mocking cancelled.| ) TO mt_log.
        RETURN.
      ENDIF.

      IF lr_mock_table_content IS INITIAL.   "this, like IS NOT BOUND, does not check the referenced field but the lr_ field itself.    the lr_ will never be initial or not bound, because of line 96-98
        ASSERT 1 = 2.                                       "D049099
*        APPEND VALUE #( message =  | Error in TDC evaluation: Mode { <mock_mode> }, dbtable { <dbtable> } . Mocking cancelled. | ) TO mt_log.
*        RETURN.
      ENDIF.
      APPEND VALUE #( message =  | Mocking with mode '{ <mock_mode> }' started for dbtable { <dbtable> } | ) TO mt_log.
      IF <lt_mock_table_content> IS INITIAL.
        APPEND VALUE #( message =  | Info: Table { <dbtable> } is mocked with empty content. | ) TO mt_log.
      ENDIF.

      "=> in <lt_mock_table_content> steht der veränderte Tabelleninhalt, fertig zum inject

      IF lb_new_table IS NOT INITIAL.
        APPEND VALUE #( tablename = <dbtable> data_ref = lr_mock_table_content ) TO et_content.
      ENDIF.

    ENDLOOP.




    "Handle generic mocking, update specific attributes of existing records of tables. Parameter FIELD_DELTA_GENERIC, mock mode 'U'.

    DATA lt_tables_field_gen           TYPE cl_ptf_util=>ty_gt_gen_delta_mock_td.
    FIELD-SYMBOLS <lt_input_field_gen> TYPE cl_ptf_util=>ty_gt_gen_delta_mock_td.

    CLEAR lr_mock_table_content.
    UNASSIGN <lt_mock_table_content>.

    READ TABLE lt_parameter INTO ls_param WITH KEY parname = 'FIELD_DELTA_GENERIC'. ""toDO: change logic, has to be table name independent, controlled by mock_mode. support for multiple generic parameters needed?
    IF sy-subrc IS INITIAL.

      ASSIGN ls_param-value_ref->* TO <lt_input_field_gen>.
      lt_tables_field_gen = <lt_input_field_gen>.
      "handle all db tables
      LOOP AT lt_tables_field_gen INTO DATA(ls_table).
        CLEAR lt_key.
        CLEAR lb_new_table.

        IF ls_table-dbtable IS INITIAL.
          APPEND VALUE #( message =  | Table name empty in TDC parameter { ls_param-parname }. Entry ignored. | ) TO mt_log.
          CONTINUE.
        ENDIF.
        IF ls_table-mock_mode NE cl_ptf_util=>gc_mock_mode_upd.
          APPEND VALUE #( message =  | Unexpected mock mode { ls_table-mock_mode } found in TDC parameter { ls_param-parname }. Entry ignored. | ) TO mt_log.
          CONTINUE.
        ENDIF.

        lt_key = get_key_fields_of_dbtable( ls_table-dbtable ).
        IF lt_key IS INITIAL.
          APPEND VALUE #( message =  | Error in FM DDIF_TABL_GET for db table { ls_table-dbtable } . Entry ignored. | ) TO mt_log.
          CONTINUE.
        ENDIF.

        CREATE DATA lr_mock_table_content TYPE STANDARD TABLE OF (ls_table-dbtable) WITH KEY (lt_key).
        ASSIGN lr_mock_table_content->* TO <lt_mock_table_content>.

        "auslagern in method select_or_get_mocked()
        READ TABLE et_content WITH KEY tablename = ls_table-dbtable REFERENCE INTO lr_last_version.
        IF sy-subrc IS INITIAL.
          ASSIGN lr_last_version->data_ref->* TO <lt_mock_table_content>.
        ELSE.
          lb_new_table = 'X'.
          SELECT * FROM (ls_table-dbtable) INTO TABLE @<lt_mock_table_content>.
        ENDIF.
        "for empty table end the loop pass, there is nothing to update
        IF lines( <lt_mock_table_content> ) EQ 0.
          APPEND VALUE #( message =  | Table { ls_table-dbtable } is empty on real DB, mode 'U' cannot work. Entry ignored. | ) TO mt_log.
          CONTINUE.
        ENDIF.
        APPEND VALUE #( message =  | Mocking with mode 'U' started for dbtable { ls_table-dbtable } | ) TO mt_log.

        "CHANGE ALL RELEVANT RECORDS
        DATA lv_key_string TYPE string.
        CLEAR lv_key_string.
        LOOP AT ls_table-changes_per_record INTO DATA(ls_per_record).
          DATA lr_struc TYPE REF TO data.
          CREATE DATA lr_struc TYPE (ls_table-dbtable)."oder:  like line of ...
          IF ls_per_record-key_fields IS INITIAL.
            APPEND VALUE #( message =  | No key fields given for table { ls_table-dbtable }. Generic mocking not started. | ) TO mt_log.
            EXIT.
          ENDIF.
          LOOP AT ls_per_record-key_fields REFERENCE INTO DATA(lr_key_field).
            FIELD-SYMBOLS <ls_struc> TYPE any.
            ASSIGN lr_struc->* TO <ls_struc>.
            ASSIGN COMPONENT lr_key_field->fieldname OF STRUCTURE <ls_struc> TO FIELD-SYMBOL(<lv_field>).
            IF sy-subrc IS NOT INITIAL.
              APPEND VALUE #( message =  | Error: Field { lr_key_field->fieldname } to be changed in delta mocking not found for table { ls_table-dbtable }| ) TO mt_log.
              CONTINUE.
            ENDIF.
            <lv_field> = lr_key_field->fieldvalue.
            CONCATENATE lv_key_string lr_key_field->fieldvalue INTO lv_key_string SEPARATED BY space.
          ENDLOOP.

          "If there is a field MANDT, fill it.            similar logic already before for I/U/D, create reuse method?
          ASSIGN COMPONENT 'MANDT' OF STRUCTURE <ls_struc> TO <dummy>.
          IF sy-subrc IS NOT INITIAL.
            ASSIGN COMPONENT 'CLIENT' OF STRUCTURE <ls_struc> TO <dummy>.
          ENDIF.
          IF sy-subrc IS INITIAL.
            IF <dummy> IS INITIAL.
              ASSIGN COMPONENT 1 OF STRUCTURE <ls_struc> TO <mandt>.
              <mandt> = sy-mandt.
            ENDIF.
          ENDIF. "structure is client specific

          READ TABLE <lt_mock_table_content> FROM <ls_struc> ASSIGNING FIELD-SYMBOL(<record>).
          IF sy-subrc IS NOT INITIAL.
            "error handling
            APPEND VALUE #( message =  | Error: Origin record for delta mocking not found:| ) TO mt_log.
            APPEND VALUE #( message =  |  Table { ls_table-dbtable } , record { lv_key_string } .| ) TO mt_log.
            CONTINUE.
          ENDIF.
          APPEND VALUE #( message =  | Mocking fields in dbtable { ls_table-dbtable }, record { lv_key_string } started. | ) TO mt_log.
          "Change relevant fields
          LOOP AT ls_per_record-mocked_fields INTO DATA(ls_attribute).
            "CHANGE FIELD VALUE
            ASSIGN COMPONENT ls_attribute-fieldname OF STRUCTURE <record> TO FIELD-SYMBOL(<field>).
            <field> = ls_attribute-fieldvalue.
          ENDLOOP.
        ENDLOOP."db table record to be changed

        "=> in <lt_mock_table_content>, TYPE STANDARD TABLE, ist jetzt der neue, veränderte Tabelleninhalt

        IF lb_new_table IS NOT INITIAL. "=X means already inserted before this generic tdc param was evaluated
          APPEND VALUE #( tablename = ls_table-dbtable data_ref = lr_mock_table_content ) TO et_content.
        ENDIF.

      ENDLOOP.
    ENDIF. " the generic parameter


    APPEND VALUE #( message = |-- End of mock details ------------------------------| ) TO mt_log.

    "CREATE ENVIRONMENT

    DATA table_list TYPE STANDARD TABLE OF ddstrucobjname.
    LOOP AT et_content INTO DATA(ls_content).
      APPEND ls_content-tablename TO table_list.
    ENDLOOP.

    CHECK table_list IS NOT INITIAL.
    environment = cl_osql_test_environment=>create( i_dependency_list = table_list ).  "This method should be called only once per test class.
    EXPORT
      table_list = table_list
      TO MEMORY ID 'PTF_MOCKED_TABLES'.

    TRY.
        cl_osql_replace=>set_survive_submit( ).
      CATCH cx_osql_replace .
        ASSERT 1 = 2.
    ENDTRY.


    "inject test data into the double
    LOOP AT et_content INTO ls_content.
      ASSIGN ls_content-data_ref->* TO FIELD-SYMBOL(<lt_content>).
      environment->insert_test_data( <lt_content> ).
      EXPORT
        dbtable   = ls_content-tablename
        t_content = <lt_content>
        TO MEMORY ID ls_content-tablename.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
