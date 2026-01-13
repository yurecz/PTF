CLASS tcl_ptf_test_class_super DEFINITION
  PUBLIC
  CREATE PUBLIC
  FOR TESTING
  DURATION LONG
  RISK LEVEL DANGEROUS .

  PUBLIC SECTION.

    TYPES:
      ty_t_ptf_variant_tag TYPE STANDARD TABLE OF ptf_variant_tag .
    TYPES:
      ty_t_scope_item      TYPE STANDARD TABLE OF ptf_scope_item .

  PROTECTED SECTION.

    METHODS _call_with_tag
      IMPORTING
        !it_tag TYPE ty_t_ptf_variant_tag .
    METHODS _call_with_scope_item
      IMPORTING
        !it_scope_item TYPE ty_t_scope_item .
    METHODS _call_named_scripts
      IMPORTING
        !it_varname      TYPE tcl_ptf_starter=>ty_t_varname
        !iv_add_full_log TYPE abap_bool OPTIONAL .

private section.

  methods EXAMPLE__TAG_OUTPUT
  for testing .
  methods EXAMPLE__SCOPE_ITEM_1Z1
  for testing .
  methods EXAMPLE__TWO_NAMED_SCRIPTS
  for testing .
ENDCLASS.



CLASS TCL_PTF_TEST_CLASS_SUPER IMPLEMENTATION.


  METHOD example__scope_item_1z1.
"inactive in CE2105 landscape
*    _call_with_scope_item( VALUE #( ( '1Z1' ) ) ).
  ENDMETHOD.


  METHOD example__tag_output.
"inactive in CE2105 landscape
*    _call_with_tag( it_tag = VALUE #( ( 'OUTPUT' ) ) ).
  ENDMETHOD.


  METHOD example__two_named_scripts.
"inactive in CE2105 landscape
*    _call_named_scripts( VALUE #( ( 'SFS_STD' ) ( 'CR_EBDR_ED01_EC01' ) ) ).
  ENDMETHOD.


  METHOD _call_named_scripts.

    cl_abap_unit_assert=>assert_not_initial( it_varname ).

    DATA lt_varname_existing TYPE tcl_ptf_starter=>ty_t_varname.
    cl_ptf_util=>remove_duplicate_scripts(
      EXPORTING
        it_varname         = it_varname
      IMPORTING
        et_varname_unique  = DATA(lt_varname_unique)
    ).

*    SELECT varname FROM ptf_varid INTO TABLE @DATA(lt_varname_db) FOR ALL ENTRIES IN @lt_varname_sorted WHERE varname = @lt_varname_sorted-table_line.
    "take over only existing scripts, without changing the order
    LOOP AT lt_varname_unique INTO DATA(lv_varname).
      TRANSLATE lv_varname TO UPPER CASE.
      SELECT SINGLE varname FROM ptf_varid INTO @DATA(lv_dummy) WHERE varname = @lv_varname.
      IF sy-subrc IS INITIAL.
        APPEND lv_varname TO lt_varname_existing.
      ENDIF.
    ENDLOOP.
    cl_abap_unit_assert=>assert_equals(
      exp = lines( lt_varname_unique )
      act = lines( lt_varname_existing )
      level = if_abap_unit_constant=>severity-low
      msg = 'Named scripts: Not all scripts found' ).

    tcl_ptf_starter=>ptf_mass_call(
      it_varname      = CONV #( lt_varname_existing )
      iv_add_full_log = iv_add_full_log
    ).

  ENDMETHOD.


  METHOD _call_with_scope_item.
    DATA lt_varname TYPE STANDARD TABLE OF ptf_varname.
    cl_abap_unit_assert=>assert_not_initial( act = it_scope_item level = if_abap_unit_constant=>severity-low ).
    SELECT varname FROM ptf_varid INTO TABLE @lt_varname FOR ALL ENTRIES IN @it_scope_item WHERE scope_item = @it_scope_item-table_line.
    IF lines( it_scope_item ) EQ 1.
      tcl_ptf_starter=>ptf_mass_call( it_varname = lt_varname iv_group_id = it_scope_item[ 1 ] ).
    ELSE.
      tcl_ptf_starter=>ptf_mass_call( lt_varname ).
    ENDIF.
  ENDMETHOD.


  METHOD _call_with_tag.
    DATA lt_varname TYPE STANDARD TABLE OF ptf_varname.
    cl_abap_unit_assert=>assert_not_initial( act = it_tag  level = if_abap_unit_constant=>severity-low ).
    SELECT varname FROM ptf_var_tag_map INTO TABLE @lt_varname FOR ALL ENTRIES IN @it_tag WHERE tag = @it_tag-table_line.
    IF lines( it_tag ) EQ 1.
      tcl_ptf_starter=>ptf_mass_call( it_varname = lt_varname iv_group_id = it_tag[ 1 ] ).
    ELSE.
      tcl_ptf_starter=>ptf_mass_call( lt_varname ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
