class CL_PTF_RAP_KEY_FINDER definition
  public
  final
  create public .

public section.

  interfaces IF_PTF_RAP_KEY_FINDER .

  aliases FIND_KEYS
    for IF_PTF_RAP_KEY_FINDER~FIND_KEYS .

  methods CONSTRUCTOR
    importing
      !IO_RUN_ENVIRONMENT type ref to CL_PTF_RUN .
protected section.
private section.

  types:
    BEGIN OF ts_sel_data,
      name      TYPE cl_abap_behvdescr=>t_typename,
      data      TYPE REF TO data,
    END OF ts_sel_data .
  types:
    tt_sel_data TYPE STANDARD TABLE OF ts_sel_data WITH DEFAULT KEY .

  data MO_RUN_ENVIRONMENT type ref to CL_PTF_RUN .
  data MO_PTF_RAP_METADATA type ref to IF_PTF_RAP_METADATA .
  data MO_PTF_RAP_VALIDATE_TDO type ref to IF_PTF_RAP_VALIDATE_TDO .
  data MV_SOURCE type STRING .

  methods QUERY_BO
    importing
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IV_ACTION type CL_ABAP_BEHVDESCR=>T_SUB_NAME
      !IT_SEL_DATA type TT_SEL_DATA
      !IV_MAXINSTANCES type INT4 default 100
    exporting
      !ER_KEYS type ref to DATA
      !EV_ERROR type ABAP_BOOL .
  methods PREPARE_QUERY
    importing
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IT_SEL_DATA type TT_SEL_DATA
    exporting
      !EV_FIELDS type STRING
      !EV_COUNT_FIELDS type STRING
      !EV_T_JOIN type STRING
      !EV_WHERE type STRING
      !EV_ERROR type ABAP_BOOL .
  methods EXECUTE_QUERY
    importing
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IV_ACTION type CL_ABAP_BEHVDESCR=>T_SUB_NAME
      !IV_FIELDS type STRING
      !IV_COUNT_FIELDS type STRING
      !IV_T_JOIN type STRING
      !IV_WHERE type STRING
      !IV_MAXINSTANCES type INT4 default 100
    exporting
      !ER_KEYS type ref to DATA
      !EV_ERROR type ABAP_BOOL .
  methods CHECK_MAXINSTANCES
    importing
      !IS_TEST_DATA type DATA
    returning
      value(RV_MAXINSTANCES) type INT4 .
  methods RECURSIVE_BUILD_SEL_DATA
    importing
      !IV_ROOT type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IV_IS_ROOT type ABAP_BOOL default ABAP_OFF
      !IS_TEST_DATA type ANY
    exporting
      value(EV_ERROR) type ABAP_BOOL
    changing
      !CT_SEL_DATA type TT_SEL_DATA .
  methods PREPARE_FIELDS
    importing
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
    exporting
      !EV_FIELDS type STRING
      !EV_COUNT_FIELDS type STRING
      !EV_ERROR type ABAP_BOOL .
  methods PREPARE_T_JOIN
    importing
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IT_SEL_DATA type TT_SEL_DATA
    exporting
      !EV_T_JOIN type STRING
      !EV_ERROR type ABAP_BOOL .
  methods PREPARE_WHERE
    importing
      !IV_NAME type CL_ABAP_BEHVDESCR=>T_TYPENAME
      !IT_SEL_DATA type TT_SEL_DATA
    exporting
      !EV_WHERE type STRING
      !EV_ERROR type ABAP_BOOL .
  methods GET_SOURCE
    importing
      !IS_TEST_DATA type ANY
    returning
      value(RV_SOURCE) type STRING .
  methods CHECK_IGNORE
    importing
      !IS_TEST_DATA type ANY
    returning
      value(RV_IGNORE) type ABAP_BOOL .
ENDCLASS.



CLASS CL_PTF_RAP_KEY_FINDER IMPLEMENTATION.


  METHOD check_ignore.
    ASSIGN COMPONENT '_IGNORE' OF STRUCTURE is_test_data TO FIELD-SYMBOL(<fs_field>).
    IF sy-subrc = 0.
      IF <fs_field> = abap_on.
        rv_ignore = abap_on.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD check_maxinstances.
    ASSIGN COMPONENT '_MAXINSTANCES' OF STRUCTURE is_test_data TO FIELD-SYMBOL(<fs_maxinstances>).
    IF sy-subrc = 0.
      rv_maxinstances = CONV #( <fs_maxinstances> ).

      IF rv_maxinstances > 100.
        rv_maxinstances = 100. "default value

        me->mo_run_environment->append_log( 'Limit set to more than 100, will be reduced to 100 !' ).

      ENDIF.

    ELSE.
      rv_maxinstances = 100. "default value

    ENDIF.

  ENDMETHOD.


  METHOD constructor.
    me->mo_run_environment      = io_run_environment.
    me->mo_ptf_rap_metadata     = NEW cl_ptf_rap_metadata( ).
    me->mo_ptf_rap_validate_tdo = NEW cl_ptf_rap_validate_tdo( io_run_environment ).

  ENDMETHOD.


  METHOD execute_query.
    DATA: lx_osql    TYPE REF TO cx_sy_dynamic_osql_syntax,
          lv_no_rows TYPE i.

    FIELD-SYMBOLS: <fs_keys>       TYPE STANDARD TABLE.

    CLEAR: er_keys, ev_error.

    er_keys = cl_abap_behvdescr=>create_data(
                      p_name      = iv_name
                      p_op        = cl_abap_behv_ctrl=>d010behv_op-virtual-primarykey
                    ).

    ASSIGN er_keys->* TO <fs_keys>.

    TRY.
        SELECT SINGLE (iv_count_fields)
          FROM (iv_t_join)
         WHERE (iv_where)
          INTO @lv_no_rows.

      CATCH cx_sy_dynamic_osql_syntax INTO lx_osql.
        ev_error = abap_on.
        me->mo_run_environment->append_log( |Entity { iv_name }, SQL Error: { lx_osql->get_text( ) }| ).

    ENDTRY.

    IF lv_no_rows IS INITIAL.
      me->mo_run_environment->append_log( |Entity { iv_name }: no instance found !| ).
      ev_error = abap_on.
      RETURN.

    ENDIF.

    CASE iv_action.
      WHEN 'CHECK_IF_EXISTS'.
        me->mo_run_environment->append_log( |Entity { iv_name }: { lv_no_rows } instances found !| ).

    ENDCASE.

    IF lv_no_rows > iv_maxinstances AND iv_maxinstances IS NOT INITIAL.
      me->mo_run_environment->append_log( |Entity { iv_name }, selection yields { lv_no_rows } entries, only first { iv_maxinstances } are kept| ).

    ENDIF.

    TRY.
        SELECT DISTINCT (iv_fields)
          FROM (iv_t_join)
         WHERE (iv_where)
         "ORDER BY PRIMARY KEY "doesn't work for all views
         ORDER BY (iv_fields)
          INTO CORRESPONDING FIELDS OF TABLE @<fs_keys>
            UP TO @iv_maxinstances ROWS.

      CATCH cx_sy_dynamic_osql_syntax INTO lx_osql.
        ev_error = abap_on.
        me->mo_run_environment->append_log( |Entity { iv_name }, SQL Error: { lx_osql->get_text( ) }| ).

    ENDTRY.

  ENDMETHOD.


  METHOD get_source.
*   Default value: TDC
    rv_source = 'TDC'.

    ASSIGN COMPONENT '_SOURCE' OF STRUCTURE is_test_data TO FIELD-SYMBOL(<fs_source>).
    IF sy-subrc = 0.
      rv_source = <fs_source>.

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_rap_key_finder~find_keys.
    DATA lt_sel_data    TYPE tt_sel_data.

    CLEAR ev_error.

*   Validate Root entity name
    me->mo_ptf_rap_validate_tdo->check_entity(
      EXPORTING
        iv_root   = iv_name
        iv_name   = iv_name
      IMPORTING
        ev_error  = ev_error
    ).
    IF ev_error = abap_on.
      RETURN.

    ENDIF.

    ASSIGN cr_test_data->* TO FIELD-SYMBOL(<fs_test_data>).

*   Get source of test data (TDC/JSON)
    me->mv_source = me->get_source(
      EXPORTING
        is_test_data = <fs_test_data>
    ).

*   Validate fields
    me->mo_ptf_rap_validate_tdo->check_fields(
      EXPORTING
        iv_name   = iv_name
        is_data   = <fs_test_data>
      IMPORTING
        ev_error  = ev_error
    ).
    IF ev_error = abap_on.
      RETURN.

    ENDIF.

*   Check maxinstances
    DATA(lv_maxinstances) = me->check_maxinstances( is_test_data = <fs_test_data> ).

*   Prepare the data for dynamic select
    me->recursive_build_sel_data(
      EXPORTING
        iv_root       = iv_name
        iv_name       = iv_name
        iv_is_root    = abap_on
        is_test_data  = <fs_test_data>
      IMPORTING
        ev_error      = ev_error
      CHANGING
        ct_sel_data   = lt_sel_data
    ).
    IF ev_error = abap_on.
      RETURN.

    ENDIF.

    me->query_bo(
      EXPORTING
        iv_name         = iv_name
        iv_action       = iv_action
        it_sel_data     = lt_sel_data
        iv_maxinstances = lv_maxinstances
      IMPORTING
        er_keys         = DATA(lr_keys)
        ev_error        = ev_error
    ).
    IF ev_error = abap_on.
      RETURN.

    ENDIF.

*   Convert the found root keys into new TDO
*   This means that the old TDO that was made out of input JSON will be replaced by this new TDO
*   This means that whatever properties have been input in the previous TDO such as ignore will be lost
    TRY.
        cl_ptf_json=>convert_keys(
          EXPORTING
            ir_data = lr_keys
          IMPORTING
            er_data = cr_test_data ).

      CATCH cx_ptf_json INTO DATA(lx_ptf_json).
        me->mo_run_environment->append_log( lx_ptf_json->get_text( ) ).
        RETURN.

    ENDTRY.

  ENDMETHOD.


  METHOD prepare_fields.
    DATA: lo_tabledescr  TYPE REF TO cl_abap_tabledescr,
          lo_structdescr TYPE REF TO cl_abap_structdescr,
          lt_fields      TYPE STANDARD TABLE OF string,
          lt_f_whitelist TYPE string_hashed_table,
          lv_fields      TYPE string.

    FIELD-SYMBOLS: <fs_keys>       TYPE STANDARD TABLE,
                   <fs_component>  TYPE abap_componentdescr,
                   <fs_field>      TYPE any.

    CLEAR: ev_fields, ev_count_fields, ev_error.

    DATA(lr_keys) = cl_abap_behvdescr=>create_data(
                      p_name      = iv_name
                      p_op        = cl_abap_behv_ctrl=>d010behv_op-virtual-primarykey
                    ).

    ASSIGN lr_keys->* TO <fs_keys>.

*   Get fields
    lo_tabledescr ?= cl_abap_tabledescr=>describe_by_data( <fs_keys> ).
    lo_structdescr ?= lo_tabledescr->get_table_line_type( ).

    DATA(lt_key_components) = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

    LOOP AT lt_key_components ASSIGNING <fs_component>.
      lv_fields = |{ lv_fields } { iv_name }~{ <fs_component>-name }|.

      IF NOT line_exists( lt_f_whitelist[ table_line = |{ iv_name }~{ <fs_component>-name }| ] ).
        INSERT |{ iv_name }~{ <fs_component>-name }| INTO TABLE lt_f_whitelist.

      ENDIF.

    ENDLOOP.

    CONDENSE lv_fields.

*   Validate fields
    SPLIT lv_fields AT space INTO TABLE lt_fields.

    LOOP AT lt_fields ASSIGNING <fs_field>.
      TRY.
          <fs_field> = cl_abap_dyn_prg=>check_whitelist_tab(
            EXPORTING
              val       = <fs_field>
              whitelist = lt_f_whitelist ).
        CATCH cx_abap_not_in_whitelist ##NO_HANDLER.
          ev_error = abap_on.
          me->mo_run_environment->append_log( |Table { iv_name }, column { <fs_field> } is invalid| ).
          EXIT.

      ENDTRY.

      IF ev_fields IS INITIAL.
        ev_fields = <fs_field>.

      ELSE.
        ev_fields = |{ ev_fields }, { <fs_field> }|.

      ENDIF.

    ENDLOOP.

    IF ev_error = abap_on.
      RETURN.

    ENDIF.

    CONDENSE ev_fields.

*   Count the total number of rows - very tricky if more than one key field
    ev_count_fields = SWITCH #( lines( lt_fields ) WHEN 1 THEN |COUNT( DISTINCT { ev_fields } )|
                                                   ELSE |COUNT( DISTINCT CONCAT( { ev_fields } ) )| ).

  ENDMETHOD.


  METHOD prepare_query.
    CLEAR: ev_fields, ev_count_fields, ev_t_join, ev_where, ev_error.

    me->prepare_fields(
      EXPORTING
        iv_name         = iv_name
      IMPORTING
        ev_fields       = ev_fields
        ev_count_fields = ev_count_fields
        ev_error        = ev_error ).
    IF ev_error = abap_on.
      RETURN.

    ENDIF.

    me->prepare_t_join(
      EXPORTING
        iv_name     = iv_name
        it_sel_data = it_sel_data
      IMPORTING
        ev_t_join   = ev_t_join
        ev_error    = ev_error ).
    IF ev_error = abap_on.
      RETURN.

    ENDIF.

    me->prepare_where(
      EXPORTING
        iv_name     = iv_name
        it_sel_data = it_sel_data
      IMPORTING
        ev_where    = ev_where
        ev_error    = ev_error ).
    IF ev_error = abap_on.
      RETURN.

    ENDIF.

  ENDMETHOD.


  METHOD prepare_t_join.
    DATA: lo_tabledescr  TYPE REF TO cl_abap_tabledescr,
          lo_structdescr TYPE REF TO cl_abap_structdescr,
          lt_t_whitelist TYPE string_hashed_table,
          lt_j_whitelist TYPE string_hashed_table,
          lv_tabix       TYPE syst-tabix,
          lv_table_name  TYPE string,
          lv_join_name   TYPE string,
          lv_join        TYPE string,
          lv_whitelist   TYPE string,
          lv_field       TYPE string.

    FIELD-SYMBOLS: <fs_keys>       TYPE STANDARD TABLE,
                   <fs_sel_data>   TYPE ts_sel_data,
                   <fs_component>  TYPE abap_componentdescr.

    CLEAR: ev_t_join, ev_error.

    DATA(lr_keys) = cl_abap_behvdescr=>create_data(
                      p_name      = iv_name
                      p_op        = cl_abap_behv_ctrl=>d010behv_op-virtual-primarykey
                    ).

    ASSIGN lr_keys->* TO <fs_keys>.

*   Get fields
    lo_tabledescr ?= cl_abap_tabledescr=>describe_by_data( <fs_keys> ).
    lo_structdescr ?= lo_tabledescr->get_table_line_type( ).

    DATA(lt_key_components) = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

    LOOP AT lt_key_components ASSIGNING <fs_component>.
      IF NOT line_exists( lt_j_whitelist[ table_line = <fs_component>-name ] ).
        INSERT <fs_component>-name INTO TABLE lt_j_whitelist.

      ENDIF.

    ENDLOOP.

*   Get tables
    LOOP AT it_sel_data ASSIGNING <fs_sel_data>.
      IF <fs_sel_data>-name <> iv_name. "not the root entity
        IF NOT line_exists( lt_t_whitelist[ table_line = <fs_sel_data>-name ] ).
          INSERT CONV #( <fs_sel_data>-name ) INTO TABLE lt_t_whitelist.

        ENDIF.

      ENDIF.

    ENDLOOP.

*   Validate table
    cl_abap_tabledescr=>describe_by_name(
                EXPORTING p_name          = iv_name
                "RECEIVING p_descr_ref     = lo_typedescr
                EXCEPTIONS type_not_found = 1 ).
    IF sy-subrc <> 0.
      me->mo_run_environment->append_log( |Entity { iv_name } is invalid| ).

    ENDIF.

    lv_whitelist = iv_name.

    TRY.
        lv_table_name = cl_abap_dyn_prg=>check_whitelist_str(
          EXPORTING
            val       = iv_name
            whitelist = lv_whitelist ).
      CATCH cx_abap_not_in_whitelist ##NO_HANDLER.
        ev_error = abap_on.
        me->mo_run_environment->append_log( |Entity { iv_name } is invalid| ).
        RETURN.

    ENDTRY.

    IF ev_error = abap_on.
      RETURN.

    ENDIF.

*   Validate JOIN
    LOOP AT it_sel_data ASSIGNING <fs_sel_data>.
      IF <fs_sel_data>-name <> iv_name. "not the root entity
        TRY.
            lv_join_name = cl_abap_dyn_prg=>check_whitelist_tab(
                            EXPORTING
                              val       = <fs_sel_data>-name
                              whitelist = lt_t_whitelist ).
          CATCH cx_abap_not_in_whitelist ##NO_HANDLER.
            ev_error = abap_on.
            me->mo_run_environment->append_log( |Entity { <fs_sel_data>-name } is invalid| ).
            EXIT.

        ENDTRY.

        lv_join = |{ lv_join } JOIN { lv_join_name } ON |.

        LOOP AT lt_key_components ASSIGNING <fs_component>.
          lv_tabix = sy-tabix.

          TRY.
              lv_field = cl_abap_dyn_prg=>check_whitelist_tab(
                EXPORTING
                  val       = <fs_component>-name
                  whitelist = lt_j_whitelist ).
            CATCH cx_abap_not_in_whitelist ##NO_HANDLER.
              ev_error = abap_on.
              me->mo_run_environment->append_log( |Table { <fs_sel_data>-name }, column { <fs_component>-name } is invalid| ).
              EXIT.

          ENDTRY.

          lv_join = SWITCH #( lv_tabix WHEN 1 THEN |{ lv_join } { lv_join_name }~{ lv_field } = { lv_table_name }~{ lv_field }|
                                       ELSE |{ lv_join } AND { lv_join_name }~{ lv_field } = { lv_table_name }~{ lv_field }| ).

        ENDLOOP.

        IF ev_error = abap_on.
          EXIT.

        ENDIF.

      ENDIF.

    ENDLOOP.

    IF ev_error = abap_on.
      RETURN.

    ENDIF.

    ev_t_join = |{ lv_table_name } { lv_join }|.

    CONDENSE ev_t_join.

  ENDMETHOD.


  METHOD prepare_where.
    DATA: lo_structdescr TYPE REF TO cl_abap_structdescr,
          lt_w_whitelist TYPE string_hashed_table,
          lv_tabix       TYPE syst-tabix,
          lv_field       TYPE string,
          lv_where_table TYPE string,
          lv_initial     TYPE abap_bool.

    FIELD-SYMBOLS: <fs_data_table> TYPE STANDARD TABLE,
                   <fs_sel_data>   TYPE ts_sel_data,
                   <fs_component>  TYPE abap_componentdescr,
                   <fs_value>      TYPE any.

    CLEAR: ev_where, ev_error.

*   Generate where condition
    LOOP AT it_sel_data ASSIGNING <fs_sel_data>.
      ASSIGN <fs_sel_data>-data->* TO <fs_data_table>.

      IF lines( it_sel_data ) > 1.
        IF ev_where IS INITIAL.
          ev_where = '( '.

        ELSE.
          ev_where = |{ ev_where } AND ( |.

        ENDIF.

      ENDIF.

      LOOP AT <fs_data_table> ASSIGNING FIELD-SYMBOL(<fs_data_ref>).
        lv_tabix = sy-tabix.

        CLEAR lv_where_table.

        ASSIGN <fs_data_ref>->* TO FIELD-SYMBOL(<fs_data>).

        IF lines( <fs_data_table> ) > 1.
          IF lv_tabix = 1.
            ev_where = |{ ev_where } ( |.

          ELSE.
            ev_where = |{ ev_where } OR ( |.

          ENDIF.

        ENDIF.

        lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_data> ).
        DATA(lt_components) = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

        DELETE lt_components WHERE name CP '_*'.

        LOOP AT lt_components ASSIGNING <fs_component>.
          INSERT |{ <fs_component>-name }| INTO TABLE lt_w_whitelist.

        ENDLOOP.

        LOOP AT lt_components ASSIGNING <fs_component>.
          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_data> TO <fs_value>.
          IF sy-subrc = 0.
*           Check if we have initials
            lv_initial = abap_off.

            ASSIGN COMPONENT '_INITIALS' OF STRUCTURE <fs_data> TO FIELD-SYMBOL(<fs_initials_ref>).
            IF sy-subrc = 0.
              ASSIGN <fs_initials_ref>->* TO FIELD-SYMBOL(<fs_initials>).
              IF sy-subrc = 0.
                ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_initials> TO FIELD-SYMBOL(<fs_initial>).
                IF sy-subrc = 0.
                  lv_initial = <fs_initial>.

                ENDIF.

              ENDIF.

*            ELSE. "there is no _INITIALS component
*              IF me->mv_source = 'TDC'. "data is coming from TDC
*                IF <fs_value> IS INITIAL. "no value from TDC
*                  lv_initial = abap_on. "force initial flag
*
*                ENDIF.
*
*              ENDIF.

            ENDIF.

            IF <fs_value> IS NOT INITIAL OR lv_initial = abap_on.
*              IF <fs_value> IS NOT INITIAL AND lv_initial = abap_on.
*                ev_error = abap_on.
**                me->mo_run_environment->append_log( |Table { <fs_sel_data>-name }, column { <fs_component>-name } has a value but property "initial" is "true" !| ).
*                me->mo_run_environment->append_log( |Table { <fs_sel_data>-name }, column { <fs_component>-name } has a value but it's also flagged in _INITIALS !| ).
*
*                RETURN.
*
*              ENDIF.

              TRY.
                  lv_field = cl_abap_dyn_prg=>check_whitelist_tab(
                    EXPORTING
                      val       = <fs_component>-name
                      whitelist = lt_w_whitelist ).

                CATCH cx_abap_not_in_whitelist ##NO_HANDLER.
                  ev_error = abap_on.
                  me->mo_run_environment->append_log( |Table { <fs_sel_data>-name }, column { <fs_component>-name } is invalid| ).
                  EXIT.

              ENDTRY.

              IF lv_where_table IS INITIAL.
                lv_where_table = |{ <fs_sel_data>-name }~{ lv_field } = '{ <fs_value> }'|.

              ELSE.
                lv_where_table = |{ lv_where_table } AND { <fs_sel_data>-name }~{ lv_field } = '{ <fs_value> }'|.

              ENDIF.

            ENDIF.

          ENDIF.

        ENDLOOP.

        IF ev_error = abap_on.
          EXIT.

        ENDIF.

        ev_where = |{ ev_where } { lv_where_table }|.

        IF lines( <fs_data_table> ) > 1.
          ev_where = |{ ev_where } ) |.

        ENDIF.

      ENDLOOP.

      IF ev_error = abap_on.
        EXIT.

      ENDIF.

      IF lines( it_sel_data ) > 1.
        ev_where = |{ ev_where } ) |.

      ENDIF.

    ENDLOOP.

    IF ev_error = abap_on.
      RETURN.

    ENDIF.

    CONDENSE ev_where.

*   Validate where
    TRY.
        ev_where = cl_abap_dyn_prg=>escape_quotes_str(
          EXPORTING
             val = ev_where ).

      CATCH cx_abap_invalid_value ##NO_HANDLER.
        ev_error = abap_on.
        me->mo_run_environment->append_log( |Entity { iv_name }, where condition is invalid| ).
        RETURN.

    ENDTRY.

    IF ev_error = abap_on.
      RETURN.

    ENDIF.

  ENDMETHOD.


  METHOD query_bo.
    CLEAR: er_keys, ev_error.

    me->prepare_query(
      EXPORTING
        iv_name         = iv_name
        it_sel_data     = it_sel_data
      IMPORTING
        ev_fields       = DATA(lv_fields)
        ev_count_fields = DATA(lv_count_fields)
        ev_t_join       = DATA(lv_t_join)
        ev_where        = DATA(lv_where)
        ev_error        = ev_error
    ).
    IF ev_error = abap_on.
      RETURN.

    ENDIF.

    me->execute_query(
      EXPORTING
        iv_name         = iv_name
        iv_action       = iv_action
        iv_fields       = lv_fields
        iv_count_fields = lv_count_fields
        iv_t_join       = lv_t_join
        iv_where        = lv_where
        iv_maxinstances = iv_maxinstances
      IMPORTING
        er_keys         = er_keys
        ev_error        = ev_error
    ).

  ENDMETHOD.


  METHOD recursive_build_sel_data.
    DATA: lo_tabledescr  TYPE REF TO cl_abap_tabledescr,
          lo_structdescr TYPE REF TO cl_abap_structdescr,
          lo_refdescr    TYPE REF TO cl_abap_refdescr,
          lr_data        TYPE REF TO data ##NEEDED,
          lr_struct      TYPE REF TO data,
          ls_sel_data    TYPE ts_sel_data,
          lv_initials    TYPE abap_bool.

    FIELD-SYMBOLS: <fs_data_table>  TYPE STANDARD TABLE,
                   <fs_test_data>   TYPE any,
                   <fs_td_initials> TYPE any,
                   <fs_struct>      TYPE any,
                   <fs_field>       TYPE any.

    CLEAR ev_error.

*   Validate entity
    me->mo_ptf_rap_validate_tdo->check_entity(
      EXPORTING
        iv_root   = iv_root
        iv_name   = iv_name
      IMPORTING
        ev_error  = ev_error
    ).
    IF ev_error = abap_on.
      RETURN.

    ENDIF.

    lo_structdescr ?= cl_abap_structdescr=>describe_by_data( is_test_data ).
    DATA(lt_components) = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

    lo_structdescr ?= cl_abap_structdescr=>describe_by_name( iv_name ).
    DATA(lt_t_components) = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

*   Add initials if they are in TDO
    ASSIGN COMPONENT '_INITIALS' OF STRUCTURE is_test_data TO <fs_td_initials>.
    IF sy-subrc = 0.
      lo_refdescr ?= cl_abap_refdescr=>describe_by_data( lr_data ).
      APPEND VALUE #( name = '_INITIALS' type = lo_refdescr ) TO lt_t_components.

    ENDIF.

    lo_structdescr = cl_abap_structdescr=>get( lt_t_components ).

    CREATE DATA lr_struct TYPE HANDLE lo_structdescr.
    ASSIGN lr_struct->* TO <fs_struct>.

*   Check if we have ignore flag
    DATA(lv_ignore) = me->check_ignore(
      EXPORTING
        is_test_data  = is_test_data
    ).

    IF lv_ignore = abap_off.
*     Move components 1 by 1 and apply conversion routine where applicable
      me->mo_ptf_rap_validate_tdo->move_test_data(
        EXPORTING
          is_test_data   = is_test_data
          iv_name        = iv_name
          iv_root        = iv_is_root
          iv_context     = if_ptf_rap_validate_tdo=>key_finder
        IMPORTING
          ev_error       = ev_error
        CHANGING
          cs_target_data = <fs_struct> ).
      IF ev_error = abap_on.
        RETURN.

      ENDIF.

*     Check and Move initials
      ASSIGN COMPONENT '_INITIALS' OF STRUCTURE is_test_data TO <fs_td_initials>.
      IF sy-subrc = 0.
        IF <fs_td_initials> IS NOT INITIAL.
          lv_initials = abap_on.

        ENDIF.

        ASSIGN COMPONENT '_INITIALS' OF STRUCTURE <fs_struct> TO FIELD-SYMBOL(<fs_initials>).
        IF sy-subrc = 0.
          IF <fs_td_initials> IS NOT INITIAL. "don't assign the reference to component _INITIALS if there is no field marked with "initial"
            GET REFERENCE OF <fs_td_initials> INTO <fs_initials>.

          ENDIF.

        ENDIF.

      ENDIF.

    ENDIF.

**   Issue an error if no data is provided and no fields are mentioned (even blank) and the node is not ignored
*    IF <fs_struct> IS INITIAL AND lv_initials = abap_off AND lv_ignore = abap_off. "AND iv_is_root = abap_off.
*      me->mo_run_environment->append_log( |Entity { iv_name }: no fields given, value at least one field !| ).
*      ev_error = abap_on.
*      RETURN.
*
*    ENDIF.

    IF ( <fs_struct> IS NOT INITIAL OR lv_initials = abap_on ) AND lv_ignore = abap_off.
      IF line_exists( ct_sel_data[ name = iv_name ] ).
        ASSIGN ct_sel_data[ name = iv_name ]-data->* TO <fs_data_table>.

        APPEND lr_struct TO <fs_data_table>.

      ELSE.
        ls_sel_data-name = iv_name.

*       Create references table
        lo_refdescr ?= cl_abap_refdescr=>describe_by_data( lr_struct ).
        lo_tabledescr = cl_abap_tabledescr=>get( EXPORTING p_line_type = lo_refdescr ).

        CREATE DATA ls_sel_data-data TYPE HANDLE lo_tabledescr.

        ASSIGN ls_sel_data-data->* TO <fs_data_table>.

        APPEND lr_struct TO <fs_data_table>.

        APPEND ls_sel_data TO ct_sel_data.

      ENDIF.

    ENDIF.

*   Look for children entities
    DELETE lt_components WHERE name CP '_*'.

    LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
      ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_struct> TO <fs_field>.
      IF sy-subrc <> 0. "Element is not part of current entity
        ASSIGN COMPONENT <fs_component>-name OF STRUCTURE is_test_data TO <fs_test_data>.
        IF sy-subrc = 0.
          DATA(lo_datadescr) = cl_abap_datadescr=>describe_by_data( <fs_test_data> ).

          CASE lo_datadescr->type_kind.
            WHEN cl_abap_typedescr=>typekind_table.
              LOOP AT <fs_test_data> ASSIGNING FIELD-SYMBOL(<fs_test_data_l>).
                me->recursive_build_sel_data(
                  EXPORTING
                    iv_root      = iv_root
                    iv_name      = CONV #( <fs_component>-name )
                    is_test_data = <fs_test_data_l>
                  IMPORTING
                    ev_error     = ev_error
                  CHANGING
                    ct_sel_data  = ct_sel_data
                ).
                IF ev_error = abap_on.
                  EXIT.

                ENDIF.

              ENDLOOP.

            WHEN cl_abap_typedescr=>typekind_struct1
              OR cl_abap_typedescr=>typekind_struct2. "structure
              me->recursive_build_sel_data(
                EXPORTING
                  iv_root      = iv_root
                  iv_name      = CONV #( <fs_component>-name )
                  is_test_data = <fs_test_data>
                IMPORTING
                  ev_error     = ev_error
                CHANGING
                  ct_sel_data  = ct_sel_data
              ).

          ENDCASE.

          IF ev_error = abap_on.
            RETURN.

          ENDIF.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
