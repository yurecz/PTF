*"* use this source file for your ABAP unit test classes
CLASS ltcl_ptf_variant DEFINITION FOR TESTING
  RISK LEVEL HARMLESS DURATION SHORT.
  PRIVATE SECTION.

*    TYPES:
*     ty_ptf_varid_t TYPE TABLE OF ptf_varid.
*    TYPES:
*     ty_ptf_varcon_t TYPE TABLE OF ptf_varcon.
*    TYPES:
*     ty_ptf_varref_t TYPE TABLE OF ptf_varref.

    METHODS read FOR TESTING.
*    METHODS save_ptfvarid FOR TESTING.
*    METHODS save_ptf_varid_t FOR TESTING.
*    METHODS save_ptf_varcon FOR TESTING.
    METHODS save_cg FOR TESTING.
    METHODS read_for_selection FOR TESTING.
    METHODS read_for_sel_4_fields FOR TESTING.
    METHODS read_for_sel_2_fields FOR TESTING.
    METHODS read_for_sel_more_fields FOR TESTING.
    METHODS delete FOR TESTING.
*    METHODS update_varname FOR TESTING.
*    METHODS update_vardescr FOR TESTING.
*    METHODS update_varname_descr FOR TESTING.
*    METHODS update_ptf_varid FOR TESTING.


    CONSTANTS: mc_read TYPE i VALUE 1.
    CONSTANTS: mc_save TYPE i VALUE 2.
    CONSTANTS: mc_sel  TYPE i VALUE 3.
    CONSTANTS: mc_sel_2  TYPE i VALUE 4.
    CONSTANTS: mc_del    TYPE i VALUE 5.
    CONSTANTS: mc_update TYPE i VALUE 6.

    CLASS-DATA go_ptf_tables TYPE REF TO if_osql_test_environment.
*    CLASS-DATA go_ptf_varcon TYPE REF TO if_osql_test_environment.
*    CLASS-DATA go_ptf_varref TYPE REF TO if_osql_test_environment.
    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.
*    CLASS-DATA: gs_ptf_varid TYPE ptf_varid.
*    CLASS-DATA: gt_ptf_varcon TYPE STANDARD TABLE OF ptf_varcon WITH DEFAULT KEY.
*    CLASS-DATA: gt_ptf_varref TYPE STANDARD TABLE OF ptf_varref WITH DEFAULT KEY.
*    CLASS-DATA: gs_ptf_varid_t TYPE ptf_varid_t.

    METHODS setup.
    METHODS setup_sql_double IMPORTING iv_sencario TYPE i.

    METHODS setup_outtab
      EXPORTING et_outtab TYPE cl_ptf_variant=>gty_step_data_tab.


    DATA fcut TYPE REF TO cl_ptf_variant.

ENDCLASS.

CLASS ltcl_ptf_variant IMPLEMENTATION.
  METHOD class_setup.
    go_ptf_tables = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'PTF_VARID' )  ( 'PTF_VARCON' ) ( 'PTF_VARREF' ) ( 'PTF_VARID_T' ) ( 'PTF_VARCAT' ) ( 'PTF_VAREXPMESS' ) ) ).
  ENDMETHOD.

  METHOD setup.
    go_ptf_tables->clear_doubles( ).
*    go_ptf_varcon->clear_doubles( ).
*    go_ptf_varref->clear_doubles( ).
  ENDMETHOD.

  METHOD setup_outtab.
    DATA lt_step_tab TYPE cl_ptf_variant=>gty_step_data_tab.
    DATA lt_expmess TYPE ptf_exp_message_t.

*    DATA lt_step_tab1 TYPE STANDARD TABLE OF numc3.
    DATA lt_step_tab2 TYPE STANDARD TABLE OF i."numc3.
    DATA lt_step_tab3 TYPE STANDARD TABLE OF i."numc3.

    APPEND '1' TO lt_step_tab2.
    APPEND '1' TO lt_step_tab3.
    APPEND '2' TO lt_step_tab3.

    lt_expmess = VALUE #( ( opt = 'CONTAIN' msgty = 'E' operator = 'AND' )
                          ( opt = 'CONTAIN' msgno_low = '030' )
                        ).

    lt_step_tab = VALUE #( ( bus_obj = 'DMR'     action = 'CREATE' variant = 'VARIANTE_1'  )
                           ( bus_obj = 'DMR'     action = 'CREATE' variant = 'VARIANTE_2' reference_step = lt_step_tab2 )
                           ( bus_obj = 'INVOICE' action = 'CREATE' variant = ' '          reference_step = lt_step_tab3 )
                           ( bus_obj = 'PTF_RUN' action = 'CHECK_MESSAGES'                reference_step = lt_step_tab2  exp_messages = lt_expmess  )
    ).
    et_outtab = lt_step_tab.

  ENDMETHOD.

  METHOD setup_sql_double.

    DATA lt_ptfvarid   TYPE STANDARD TABLE OF ptf_varid   WITH DEFAULT KEY.
    DATA lt_ptfvarcon  TYPE STANDARD TABLE OF ptf_varcon  WITH DEFAULT KEY.
    DATA lt_ptfvarref  TYPE STANDARD TABLE OF ptf_varref  WITH DEFAULT KEY.
    DATA lt_ptfvarcat  TYPE STANDARD TABLE OF ptf_varcat  WITH DEFAULT KEY.
    DATA lt_ptfvarid_t TYPE STANDARD TABLE OF ptf_varid_t WITH DEFAULT KEY.
    DATA lt_ptfvarexpmess  TYPE STANDARD TABLE OF ptf_varexpmess  WITH DEFAULT KEY.

    CASE iv_sencario.
      WHEN mc_read.  "corresponds to exected data in method "setup_outtab"

        lt_ptfvarid = VALUE #( ( varname = 'TEST' ) ).


        lt_ptfvarcon = VALUE #( ( varname = 'TEST' step_number = '1' bus_obj = 'DMR'     action = 'CREATE' variant = 'VARIANTE_1' )
                                ( varname = 'TEST' step_number = '3' bus_obj = 'INVOICE' action = 'CREATE' variant = ' '          )
                                ( varname = 'TEST' step_number = '2' bus_obj = 'DMR'     action = 'CREATE' variant = 'VARIANTE_2' )
                                ( varname = 'TEST' step_number = '4' bus_obj = 'PTF_RUN' action = 'CHECK_MESSAGES'                )
                               ).


        lt_ptfvarref = VALUE #( ( varname = 'TEST' step_number = '2' reference_step = '1' )
                                ( varname = 'TEST' step_number = '3' reference_step = '1' )
                                ( varname = 'TEST' step_number = '3' reference_step = '2' )
                                ( varname = 'TEST' step_number = '4' reference_step = '1' )
                              ).

        lt_ptfvarexpmess = VALUE #( ( varname = 'TEST' step_number = '4' line_number = 1 opt = 'CONTAIN' msgty     = 'E'   operator = 'AND' )
                                    ( varname = 'TEST' step_number = '4' line_number = 2 opt = 'CONTAIN' msgno_low = '030'                  )
                                  ).

      WHEN mc_save.
        "tables to be empty

      WHEN mc_sel.
        lt_ptfvarid = VALUE #( ( varname = 'TEST' erdat = sy-datlo ernam = sy-uname )  ).
        lt_ptfvarid_t = VALUE #( ( varname = 'TEST' vtext = 'TESTVARIANT' langu = sy-langu ) ).

      WHEN mc_sel_2.
        lt_ptfvarid = VALUE #( ( varname = 'TEST'  erdat = sy-datlo ernam = sy-uname )
                               ( varname = 'TEST2' erdat = sy-datlo ernam = sy-uname ) ).
        lt_ptfvarid_t = VALUE #( ( varname = 'TEST'  vtext = 'TESTVARIANT'  langu = sy-langu )
                                 ( varname = 'TEST2' vtext = 'TESTVARIANT2' langu = sy-langu ) ).
      WHEN mc_del.

        lt_ptfvarid = VALUE #( ( varname = 'TEST'  ernam = 'MUSTERMANN')
                               ( varname = 'TEST2' ernam = 'SOMEONE' )
                             ).

        lt_ptfvarid_t = VALUE #( ( varname = 'TEST'  vtext = 'TESTVARIANT'  langu = sy-langu )
                                 ( varname = 'TEST2' vtext = 'TESTVARIANT2' langu = sy-langu ) ).

        lt_ptfvarcon = VALUE #( ( varname = 'TEST'  step_number = '1' bus_obj = 'DMR'     action = 'CREATE' variant = 'VARIANTE_1' )
                                ( varname = 'TEST'  step_number = '3' bus_obj = 'INVOICE' action = 'CREATE' variant = ' '          )
                                ( varname = 'TEST'  step_number = '2' bus_obj = 'DMR'     action = 'CREATE' variant = 'VARIANTE_2' )
                                ( varname = 'TEST2' step_number = '1' bus_obj = 'OR'      action = 'CREATE' variant = 'VARIANTE_1' )
                                ( varname = 'TEST2' step_number = '3' bus_obj = 'INVOICE' action = 'CREATE' variant = ' '          )
                                ( varname = 'TEST2' step_number = '2' bus_obj = 'DMR'     action = 'CREATE' variant = 'VARIANTE_2' )
                               ).


        lt_ptfvarref = VALUE #( ( varname = 'TEST'  step_number = '2' reference_step = '1')
                                ( varname = 'TEST'  step_number = '3' reference_step = '1' )
                                ( varname = 'TEST'  step_number = '3' reference_step = '2')
                                ( varname = 'TEST2' step_number = '2' reference_step = '1')
                                ( varname = 'TEST2' step_number = '3' reference_step = '1' )
                                ( varname = 'TEST2' step_number = '3' reference_step = '2')
                                 ).

        lt_ptfvarcat = VALUE #( ( varname = 'TEST'  step_number = 1 text = 'Some extensive description.')
                                ( varname = 'TEST2' step_number = 1 text = 'This script also has a detailed description.') ).

        lt_ptfvarexpmess = VALUE #( ( varname = 'TEST'  step_number = '4' line_number = 1 opt = 'CONTAIN' msgty     = 'E'   operator = 'AND' )
                                    ( varname = 'TEST'  step_number = '4' line_number = 2 opt = 'CONTAIN' msgno_low = '030'                  )
                                    ( varname = 'TEST2' step_number = '4' line_number = 1 opt = 'CONTAIN' msgty     = 'I'                    )
                                  ).

      WHEN mc_update.
        lt_ptfvarid = VALUE #( ( varname = 'TEST'  erdat = sy-datlo ernam = sy-uname )
                               ( varname = 'TEST2' erdat = sy-datlo ernam = sy-uname ) ).

        lt_ptfvarid_t = VALUE #( ( varname = 'TEST'  vtext = 'TESTVARIANT'  langu = sy-langu )
                                 ( varname = 'TEST2' vtext = 'TESTVARIANT2' langu = sy-langu ) ).

    ENDCASE.

    go_ptf_tables->insert_test_data( lt_ptfvarid ).
    go_ptf_tables->insert_test_data( lt_ptfvarid_t ).
    go_ptf_tables->insert_test_data( lt_ptfvarcon ).
    go_ptf_tables->insert_test_data( lt_ptfvarcat ).
    go_ptf_tables->insert_test_data( lt_ptfvarref ).
    go_ptf_tables->insert_test_data( lt_ptfvarexpmess ).

  ENDMETHOD.

  METHOD class_teardown.

    "removes all doubles created as part of test session
    go_ptf_tables->destroy( ).
*    go_ptf_varcon->destroy( ).
*    go_ptf_varref->destroy( ).

  ENDMETHOD.


  METHOD read.
    DATA lt_step_tab_expected TYPE cl_ptf_variant=>gty_step_data_tab.

    me->setup_outtab(
      IMPORTING
        et_outtab = lt_step_tab_expected
    ).

    setup_sql_double( mc_read ).
    fcut = NEW cl_ptf_variant( ).
    fcut->read(
      EXPORTING
        iv_varname     = 'TEST'
      IMPORTING
        et_variant_tab = DATA(lt_return_tab)
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =    lt_return_tab
        exp                  =    lt_step_tab_expected
        msg                  =    'Table contains wrong entries'
    ).
  ENDMETHOD.

*  METHOD save_ptfvarid.
*    DATA lt_step_tab TYPE cl_ptf_variant=>gty_step_data_tab.
*    me->setup_outtab(
*     IMPORTING
*       et_outtab = lt_step_tab
*   ).
*
*    setup_sql_double( mc_save ).
*    fcut = NEW cl_ptf_variant( ).
*    fcut->save(
*      EXPORTING
*        it_variant_tab = lt_step_tab
*        iv_varname     = 'TESTVARIANT'
*        iv_vardescr    = 'Test Variant for PTF'
*        iv_user_specific = abap_false
*      IMPORTING
*        ev_saved       = DATA(lv_saved)
*    ).
*
*    cl_abap_unit_assert=>assert_equals(
*      EXPORTING
*        act                  =     lv_saved
*        exp                  =     abap_true
*        msg                  =     'Error while saving ptf_varid'
*    ).
*  ENDMETHOD.

*  METHOD save_ptf_varid_t.
*    DATA lt_step_tab TYPE cl_ptf_variant=>gty_step_data_tab.
*    me->setup_outtab(
*     IMPORTING
*       et_outtab = lt_step_tab
*   ).
*
*    setup_sql_double( mc_save ).
*    fcut = NEW cl_ptf_variant( ).
*    fcut->save(
*     EXPORTING
*       it_variant_tab = lt_step_tab
*       iv_varname     = 'TESTVARIANT'
*       iv_vardescr    = 'Test Variant for PTF'
*       iv_user_specific = abap_false
*      IMPORTING
*       ev_saved       = DATA(lv_saved)
*   ).
*    cl_abap_unit_assert=>assert_equals(
*      EXPORTING
*        act                  =     lv_saved
*        exp                  =     abap_true
*        msg                  =     'Error while saving ptf_varid'
*    ).
*  ENDMETHOD.

*  METHOD save_ptf_varcon.
*    DATA lt_step_tab TYPE cl_ptf_variant=>gty_step_data_tab.
*    me->setup_outtab(
*     IMPORTING
*       et_outtab = lt_step_tab
*   ).
*
*    setup_sql_double( mc_save ).
*    fcut = NEW cl_ptf_variant( ).
*    fcut->save(
*     EXPORTING
*       it_variant_tab = lt_step_tab
*       iv_varname     = 'TESTVARIANT'
*       iv_vardescr    = 'Test Variant for PTF'
*       iv_user_specific = abap_false
*        IMPORTING
*       ev_saved       = DATA(lv_saved)
*   ).
*    cl_abap_unit_assert=>assert_equals(
*      EXPORTING
*        act                  =     lv_saved
*        exp                  =     abap_true
*        msg                  =     'Error while saving ptf_varid'
*    ).
*  ENDMETHOD.

*  METHOD save_ptf_varref.
*    DATA lt_step_tab TYPE cl_ptf_variant=>gty_step_data_tab.
*    me->setup_outtab(
*     IMPORTING
*       et_outtab = lt_step_tab
*   ).
*
*    setup_sql_double( mc_save ).
*    fcut = NEW cl_ptf_variant( ).
*    fcut->save(
*     EXPORTING
*       it_variant_tab = lt_step_tab
*       iv_varname     = 'TESTVARIANT'
*       iv_vardescr    = 'Test Variant for PTF'
*       iv_user_specific = abap_false
*       IMPORTING
*       ev_saved       = DATA(lv_saved)
*   ).
*    cl_abap_unit_assert=>assert_equals(
*      EXPORTING
*        act                  =     lv_saved
*        exp                  =     abap_true
*        msg                  =     'Error while saving ptf_varid'
*    ).
*  ENDMETHOD.

  METHOD save_cg.

    "inserts into db tables, but without commit work

    CONSTANTS lc_any_variant TYPE ptf_varname VALUE 'AUNIT_PTF_VARIANT'.

    DATA lt_step_tab TYPE cl_ptf_variant=>gty_step_data_tab.
    me->setup_outtab(
     IMPORTING
       et_outtab = lt_step_tab
   ).

    setup_sql_double( mc_save )."mocks relevant tables, empty
    fcut = NEW cl_ptf_variant( ).
    fcut->save(
     EXPORTING
       it_variant_tab   = lt_step_tab
       iv_varname       = lc_any_variant
       iv_vardescr      = 'Test Variant for PTF'
       iv_scope_item    = 'BD9'
       iv_user_specific = abap_false
       it_vartext       = VALUE #( ( 'This is a PTF script with 4 steps.' ) )
   ).

    SELECT SINGLE * FROM ptf_varid INTO @DATA(ls_varid) WHERE varname = @lc_any_variant.
    cl_abap_unit_assert=>assert_not_initial( ls_varid ).
    SELECT * FROM ptf_varcon INTO TABLE @DATA(lt_varcon) WHERE varname = @lc_any_variant.
    cl_abap_unit_assert=>assert_not_initial( lt_varcon ).
    SELECT * FROM ptf_varref INTO TABLE @DATA(lt_varref) WHERE varname = @lc_any_variant.
    cl_abap_unit_assert=>assert_not_initial( lt_varref ).
    SELECT * FROM ptf_varid_t INTO TABLE @DATA(lt_varid_text) WHERE varname = @lc_any_variant.
    cl_abap_unit_assert=>assert_not_initial( lt_varid_text ).
    SELECT * FROM ptf_varcat INTO TABLE @DATA(lt_varcat) WHERE varname = @lc_any_variant.
    cl_abap_unit_assert=>assert_not_initial( lt_varcat ).
    SELECT * FROM ptf_varexpmess INTO TABLE @DATA(lt_varexpmess) WHERE varname = @lc_any_variant.
    cl_abap_unit_assert=>assert_not_initial( lt_varexpmess ).

  ENDMETHOD.

  METHOD read_for_selection.
    DATA ls_input TYPE ptf_selection.
    DATA lt_step_tab TYPE cl_ptf_variant=>gty_step_data_tab.
    DATA lt_exp_outtab TYPE cl_ptf_variant=>gty_ptf_variant_tab.
    lt_exp_outtab = VALUE #( ( varname = 'TEST' vardescr = 'TESTVARIANT' erdat = sy-datlo ernam = sy-uname ) ).

    ls_input-vardescr = 'TESTVARIANT'.


    setup_sql_double( mc_sel ).
    fcut = NEW cl_ptf_variant( ).
    fcut->read_for_selection(
      EXPORTING
        is_sel_param     = ls_input
      IMPORTING
        et_selection_tab = DATA(lt_outtab)
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =     lt_outtab
        exp                  =     lt_exp_outtab
        msg                  =     'Wrong data retrieved in read for selection method'

    ).
  ENDMETHOD.

  METHOD read_for_sel_4_fields.
    DATA ls_input TYPE ptf_selection.
    DATA lt_step_tab TYPE cl_ptf_variant=>gty_step_data_tab.
    DATA lt_exp_outtab TYPE cl_ptf_variant=>gty_ptf_variant_tab.
    lt_exp_outtab = VALUE #( ( varname = 'TEST' vardescr = 'TESTVARIANT' erdat = sy-datlo ernam = sy-uname ) ).

    ls_input-vardescr = 'TESTVARIANT'.
    ls_input-varname = 'TEST'.
    ls_input-ernam = sy-uname.
    ls_input-erdat = sy-datlo.


    setup_sql_double( mc_sel ).
    fcut = NEW cl_ptf_variant( ).
    fcut->read_for_selection(
      EXPORTING
        is_sel_param     = ls_input
      IMPORTING
        et_selection_tab = DATA(lt_outtab)
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =     lt_outtab
        exp                  =     lt_exp_outtab
        msg                  =     'Wrong data retrieved in read for selection method'

    ).
  ENDMETHOD.

  METHOD read_for_sel_2_fields.
    DATA ls_input TYPE ptf_selection.
    DATA lt_step_tab TYPE cl_ptf_variant=>gty_step_data_tab.
    DATA lt_exp_outtab TYPE cl_ptf_variant=>gty_ptf_variant_tab.
    lt_exp_outtab = VALUE #( ( varname = 'TEST' vardescr = 'TESTVARIANT' erdat = sy-datlo ernam = sy-uname ) ).

    ls_input-vardescr = 'TESTVARIANT'.
    ls_input-ernam = sy-uname.



    setup_sql_double( mc_sel ).
    fcut = NEW cl_ptf_variant( ).
    fcut->read_for_selection(
      EXPORTING
        is_sel_param     = ls_input
      IMPORTING
        et_selection_tab = DATA(lt_outtab)
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =     lt_outtab
        exp                  =     lt_exp_outtab
        msg                  =     'Wrong data retrieved in read for selection method'

    ).
  ENDMETHOD.

  METHOD read_for_sel_more_fields.
    DATA ls_input TYPE ptf_selection.
    DATA lt_step_tab TYPE cl_ptf_variant=>gty_step_data_tab.
    DATA lt_exp_outtab TYPE cl_ptf_variant=>gty_ptf_variant_tab.
    lt_exp_outtab = VALUE #( ( varname = 'TEST' vardescr = 'TESTVARIANT' erdat = sy-datlo ernam = sy-uname )
                             ( varname = 'TEST2' vardescr = 'TESTVARIANT2' erdat = sy-datlo ernam = sy-uname ) ).

    ls_input-ernam = sy-uname.

    setup_sql_double( mc_sel_2 ).
    fcut = NEW cl_ptf_variant( ).
    fcut->read_for_selection(
      EXPORTING
        is_sel_param     = ls_input
      IMPORTING
        et_selection_tab = DATA(lt_outtab)
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =     lt_outtab
        exp                  =     lt_exp_outtab
        msg                  =     'Wrong data retrieved in read for selection method'

    ).
  ENDMETHOD.

  METHOD delete.

    CONSTANTS lc_any_variant       TYPE ptf_varname VALUE 'TEST2'.
    CONSTANTS lc_undeleted_variant TYPE ptf_varname VALUE 'TEST'.

    DATA lv_varname TYPE varname.
*    DATA lt_step_tab TYPE cl_ptf_variant=>gty_step_data_tab.
*    DATA ls_param TYPE ptf_selection.
*    me->setup_outtab(
*      IMPORTING
*        et_outtab = lt_step_tab
*    ).

    "WHEN
    lv_varname = lc_any_variant. "'TEST2'.
    setup_sql_double( mc_del ).
    fcut = NEW cl_ptf_variant( ).

    "WHEN
    DATA(lv_deleted) = fcut->delete( lv_varname ).

    "THEN

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =    lv_deleted
        exp                  =    abap_true
        msg                  =    'Unexpected value'
    ).

    SELECT SINGLE * FROM ptf_varid INTO @DATA(ls_varid) WHERE varname = @lc_any_variant.
    cl_abap_unit_assert=>assert_initial( ls_varid ).
    SELECT * FROM ptf_varcon INTO TABLE @DATA(lt_varcon) WHERE varname = @lc_any_variant.
    cl_abap_unit_assert=>assert_initial( lt_varcon ).
    SELECT * FROM ptf_varref INTO TABLE @DATA(lt_varref) WHERE varname = @lc_any_variant.
    cl_abap_unit_assert=>assert_initial( lt_varref ).
    SELECT * FROM ptf_varid_t INTO TABLE @DATA(lt_varid_texts) WHERE varname = @lc_any_variant.
    cl_abap_unit_assert=>assert_initial( lt_varid_texts ).
    SELECT * FROM ptf_varcat INTO TABLE @DATA(lt_varcat) WHERE varname = @lc_any_variant.
    cl_abap_unit_assert=>assert_initial( lt_varcat ).
    SELECT * FROM ptf_varexpmess INTO TABLE @DATA(lt_varexpmess) WHERE varname = @lc_any_variant.
    cl_abap_unit_assert=>assert_initial( lt_varexpmess ).

    SELECT SINGLE * FROM ptf_varid INTO @ls_varid WHERE varname = @lc_undeleted_variant.
    cl_abap_unit_assert=>assert_not_initial( ls_varid ).
    SELECT * FROM ptf_varcon INTO TABLE @lt_varcon WHERE varname = @lc_undeleted_variant.
    cl_abap_unit_assert=>assert_not_initial( lt_varcon ).
    SELECT * FROM ptf_varref INTO TABLE @lt_varref WHERE varname = @lc_undeleted_variant.
    cl_abap_unit_assert=>assert_not_initial( lt_varref ).
    SELECT * FROM ptf_varid_t INTO TABLE @lt_varid_texts WHERE varname = @lc_undeleted_variant..
    cl_abap_unit_assert=>assert_not_initial( lt_varid_texts ).
    SELECT * FROM ptf_varcat INTO TABLE @lt_varcat WHERE varname = @lc_undeleted_variant..
    cl_abap_unit_assert=>assert_not_initial( lt_varcat ).
    SELECT * FROM ptf_varexpmess INTO TABLE @lt_varexpmess WHERE varname = @lc_undeleted_variant..
    cl_abap_unit_assert=>assert_not_initial( lt_varexpmess ).

  ENDMETHOD.

*  METHOD update_varname.
*    DATA lv_varname TYPE ptf_varname.
*    lv_varname = 'TEST5'.
*
*    setup_sql_double( mc_update ).
*    fcut = NEW cl_ptf_variant( ).
*    DATA(lv_updated) = fcut->update(
**                       it_variant_tab  =
*                       iv_varname      = 'TEST2'
*                       iv_varname_new  = lv_varname
**                       iv_vardescr_new = lv_vardescr
*                   ).
*
*
*    cl_abap_unit_assert=>assert_equals(
*      EXPORTING
*        act                  =     abap_true
*        exp                  =     lv_updated
*        msg                  =     'Varname not updated'
*    ).
*  ENDMETHOD.

*  METHOD update_vardescr.
*    DATA lv_vardescr TYPE rvart_vtxt.
*    lv_vardescr = 'TEST5'.
*
*    setup_sql_double( mc_update ).
*    fcut = NEW cl_ptf_variant( ).
*    DATA(lv_updated) = fcut->update(
**                       it_variant_tab  =
*                       iv_varname      = 'TEST2'
**                       iv_varname_new  = lv_varname
*                       iv_vardescr_new = lv_vardescr
*                   ).
*
*
*    cl_abap_unit_assert=>assert_equals(
*      EXPORTING
*        act                  =     abap_true
*        exp                  =     lv_updated
*        msg                  =     'Variant Description not updated'
*    ).
*  ENDMETHOD.

*  METHOD update_varname_descr.
*    DATA lv_vardescr TYPE rvart_vtxt.
*    lv_vardescr = 'TEST5'.
*    DATA lv_varname TYPE ptf_varname VALUE 'NEWVARIANT'.
*
*    setup_sql_double( mc_update ).
*    fcut = NEW cl_ptf_variant( ).
*    DATA(lv_updated) = fcut->update(
**                       it_variant_tab  =
*                       iv_varname      = 'TEST2'
*                       iv_varname_new  = lv_varname
*                       iv_vardescr_new = lv_vardescr
*                   ).
*
*
*    cl_abap_unit_assert=>assert_equals(
*      EXPORTING
*        act                  =     abap_true
*        exp                  =     lv_updated
*        msg                  =     'Variant Description not updated'
*    ).
*  ENDMETHOD.

*  METHOD update_ptf_varid.
*    DATA lv_varname TYPE ptf_varname VALUE 'NEWVARIANT'.
*
*    setup_sql_double( mc_update ).
*    fcut = NEW cl_ptf_variant( ).
*    DATA(lv_updated) = fcut->update(
**                       it_variant_tab  =
*                       iv_varname      = 'TEST2'
*                       iv_varname_new  = lv_varname
*                   ).
*
*
*    cl_abap_unit_assert=>assert_equals(
*      EXPORTING
*        act                  =     abap_true
*        exp                  =     lv_updated
*        msg                  =     'Variant Description not updated'
*    ).
*  ENDMETHOD.


ENDCLASS.

CLASS ltcl_ptf_variant2 DEFINITION FOR TESTING
  RISK LEVEL HARMLESS DURATION SHORT.
  PRIVATE SECTION.
    METHODS search FOR TESTING.
ENDCLASS.

CLASS ltcl_ptf_variant2 IMPLEMENTATION.
  METHOD search.
    DATA ls_input TYPE ptf_selection.
    DATA lt_step_tab TYPE cl_ptf_variant=>gty_step_data_tab.
    DATA lt_exp_outtab TYPE cl_ptf_variant=>gty_ptf_variant_tab.
    lt_exp_outtab = VALUE #( ( varname = 'TEST' vardescr = 'TESTVARIANT' erdat = sy-datlo ernam = sy-uname ) ).

    ls_input-varname = 'edit*'.
    ls_input-vardescr = 'edit*test'.

*    ls_input-vardescr = 'TESTVARIANT'.

    DATA(fcut) = NEW cl_ptf_variant( ).
    fcut->read_for_selection(
      EXPORTING
        is_sel_param     = ls_input
      IMPORTING
        et_selection_tab = DATA(lt_sel_tab)
        ).

    fcut->search(
      EXPORTING
        is_sel_param     = ls_input
        it_variant_tab   = lt_sel_tab
      IMPORTING
        et_selection_tab = DATA(lt_selection_tab)
    ).

*    cl_abap_unit_assert=>assert_equals(
*      EXPORTING
*        act                  =     lt_selection_tab
*        exp                  =     lt_exp_outtab
*        msg                  =     'Wrong data retrieved in read for selection method'

*    ).
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_ptf_variant_isolated DEFINITION DEFERRED.
CLASS cl_ptf_variant DEFINITION LOCAL FRIENDS ltcl_ptf_variant_isolated.

CLASS ltcl_ptf_variant_isolated DEFINITION FOR TESTING
  RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.

    "unit tests of method save_ptf_varref:
    METHODS save_varref FOR TESTING.
    METHODS save_varref_bidirectional_data FOR TESTING.
    METHODS save_varref__itab_empty FOR TESTING.
    METHODS save_varref__irrelevant_input FOR TESTING.

    "unit tests of method enrich_with_varref_data:
    METHODS enrich_variant_w_varref FOR TESTING.
    METHODS enrich_variant_w_varref__dc FOR TESTING.
    METHODS enrich_var_w_vref__all_empty FOR TESTING.
    METHODS enrch_var_w_vref__no_ref_input FOR TESTING.

    METHODS setup.

    METHODS get_std_variant_steps
      EXPORTING
        et_variant_tab     TYPE cl_ptf_variant=>gty_step_data_tab
        et_varref_expected TYPE cl_ptf_variant=>gty_ptf_varref.
    METHODS get_bidirectional_data
      EXPORTING
        et_variant_tab TYPE cl_ptf_variant=>gty_step_data_tab
        et_varref      TYPE cl_ptf_variant=>gty_ptf_varref.
    METHODS get_irrelevant_variant_steps
      EXPORTING
        et_variant_tab     TYPE cl_ptf_variant=>gty_step_data_tab
        et_varref_expected TYPE cl_ptf_variant=>gty_ptf_varref.

    DATA fcut TYPE REF TO cl_ptf_variant.

    CONSTANTS gc_any_varname TYPE ptf_varname VALUE 'VARIANT1_AUNIT'.
ENDCLASS.


CLASS ltcl_ptf_variant_isolated IMPLEMENTATION.

  METHOD setup.
    fcut = NEW cl_ptf_variant( ).
    fcut->go_transport = cl_ptf_transport=>factory( ).
  ENDMETHOD.

  METHOD get_std_variant_steps. "this data can not be used in both directions, but only as input for save_varref.  reason: initial records are never created in itab variant_tab-reference_step.

    et_variant_tab = VALUE #(
                         ( bus_obj = 'DMR'     action = 'CREATE'              variant = 'VARIANT_1'   )
                         ( bus_obj = 'DMR'     action = 'CREATE'              variant = 'VARIANT_2'  reference_step = VALUE #( ( 1 )             )   )
                         ( bus_obj = 'PTF_RUN' action = 'START_DATA_MOCKING'  variant = 'VARIANT_M1' reference_step = VALUE #( ( 0 )             )   )
                         ( bus_obj = 'INVOICE' action = 'CREATE'              variant = ' '          reference_step = VALUE #( ( 1 ) ( 2 )       )   )
                         ( bus_obj = 'INVOICE' action = 'CHECK'               variant = ' '          reference_step = VALUE #( ( 4 ) ( 2 ) ( 3 ) )   )
                         ( bus_obj = 'PTF_RUN' action = 'END_DATA_MOCKING'    variant = 'VARIANT_M1' reference_step = VALUE #( ( 0 )             )   )
  ).


    et_varref_expected = VALUE #(
                         ( mandt = sy-mandt varname = gc_any_varname step_number = '2' reference_step = '1'  ref_index = '1'  )
                         ( mandt = sy-mandt varname = gc_any_varname step_number = '4' reference_step = '1'  ref_index = '1'  )
                         ( mandt = sy-mandt varname = gc_any_varname step_number = '4' reference_step = '2'  ref_index = '2'  )
                         ( mandt = sy-mandt varname = gc_any_varname step_number = '5' reference_step = '4'  ref_index = '1'  )
                         ( mandt = sy-mandt varname = gc_any_varname step_number = '5' reference_step = '2'  ref_index = '2'  )
                         ( mandt = sy-mandt varname = gc_any_varname step_number = '5' reference_step = '3'  ref_index = '3'  )
                        ).

  ENDMETHOD.

  METHOD get_bidirectional_data.

    et_variant_tab = VALUE #(
                         ( bus_obj = 'DMR'     action = 'CREATE'              variant = 'VARIANT_1'   )
                         ( bus_obj = 'DMR'     action = 'CREATE'              variant = 'VARIANT_2'  reference_step = VALUE #( ( 1 )             )   )
                         ( bus_obj = 'INVOICE' action = 'CREATE'              variant = ' '          reference_step = VALUE #( ( 1 ) ( 2 )       )   )
                         ( bus_obj = 'INVOICE' action = 'CHECK'               variant = ' '          reference_step = VALUE #( ( 3 ) ( 1 ) ( 2 ) )   )
                         ( bus_obj = 'PTF_RUN' action = 'END_DATA_MOCKING'    variant = 'VARIANT_M1'  )
  ).

    "step_number NOT sorted. ref_index not sorted.
    et_varref = VALUE #(
                         ( mandt = sy-mandt varname = gc_any_varname step_number = '2' reference_step = '1'  ref_index = '1'
                          )
                         ( mandt = sy-mandt varname = gc_any_varname step_number = '4' reference_step = '3'  ref_index = '1'   "step 4 before step 3, must have no effect
                          )
                         ( mandt = sy-mandt varname = gc_any_varname step_number = '4' reference_step = '2'  ref_index = '3'   "ref_index 3 before ref_index 2,  must have no effect
                          )
                         ( mandt = sy-mandt varname = gc_any_varname step_number = '4' reference_step = '1'  ref_index = '2'
                          )
                         ( mandt = sy-mandt varname = gc_any_varname step_number = '3' reference_step = '1'  ref_index = '1'
                          )
                         ( mandt = sy-mandt varname = gc_any_varname step_number = '3' reference_step = '2'  ref_index = '2'
                          )
                        ).

    "sorted by step number and ref_index
*    et_varref = VALUE #(
*                         ( mandt = sy-mandt varname = gc_any_varname step_number = '2' reference_step = '1'  )"ref_index = '1' )
*                         ( mandt = sy-mandt varname = gc_any_varname step_number = '3' reference_step = '1'  )"ref_index = '1' )
*                         ( mandt = sy-mandt varname = gc_any_varname step_number = '3' reference_step = '2'  )"ref_index = '2' )
*                         ( mandt = sy-mandt varname = gc_any_varname step_number = '4' reference_step = '3'  )"ref_index = '1' )
*                         ( mandt = sy-mandt varname = gc_any_varname step_number = '4' reference_step = '1'  )"ref_index = '2' )
*                         ( mandt = sy-mandt varname = gc_any_varname step_number = '4' reference_step = '2'  )"ref_index = '3' )
*                        ).

  ENDMETHOD.

  METHOD get_irrelevant_variant_steps.

    et_variant_tab = VALUE #(
                         ( bus_obj = 'PTF_RUN' action = 'START_DATA_MOCKING'  variant = 'VARIANT_M1' reference_step = VALUE #( ( 0 )             )   )
                         ( bus_obj = 'DMR'     action = 'CREATE'              variant = 'VARIANT_1'   )
                         ( bus_obj = 'CMR'     action = 'CREATE'              variant = 'VARIANT_2'  reference_step = VALUE #( ( 0 ) ( 0 )       )   )
                         ( bus_obj = 'PTF_RUN' action = 'END_DATA_MOCKING'    variant = 'VARIANT_M1' reference_step = VALUE #( ( 0 )             )   )
                     ).

    et_varref_expected = VALUE #( ).

  ENDMETHOD.


* FOR TESTING:

  METHOD save_varref.

    DATA lt_step_tab_input TYPE cl_ptf_variant=>gty_step_data_tab.

*given
    get_std_variant_steps(
         IMPORTING
           et_variant_tab = lt_step_tab_input
           et_varref_expected = DATA(lt_varref_expected)
       ).

*when
    fcut->save_ptf_varref(
      EXPORTING
       it_variant_tab = lt_step_tab_input
       iv_varname     = gc_any_varname
       is_version     = value #( script_version = 0 )
      IMPORTING
        et_varref     = DATA(lt_varref_result)
    ).

*then
    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = lt_varref_result
        exp                  = lt_varref_expected
    ).

  ENDMETHOD.

  METHOD save_varref_bidirectional_data.

    DATA lt_step_tab TYPE cl_ptf_variant=>gty_step_data_tab.

    get_bidirectional_data(
      IMPORTING
        et_variant_tab = lt_step_tab
        et_varref      = DATA(lt_varref_expected)     "not sorted
    ).

    fcut->save_ptf_varref(   "builds et_varref based on it_variant_tab, keeping the order
      EXPORTING
       it_variant_tab = lt_step_tab
       iv_varname     = gc_any_varname
       is_version     = value #( script_version = 0 )
      IMPORTING
        et_varref     = DATA(lt_varref_result)   "is build based on the order of lt_step_tab, which is always implicitly sorted
    ).

    SORT lt_varref_expected.                       "sort it to allow comparison
    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = lt_varref_result
        exp                  = lt_varref_expected
    ).

  ENDMETHOD.

  METHOD save_varref__itab_empty.

*given
    DATA lt_empty_step_tab TYPE cl_ptf_variant=>gty_step_data_tab.

*when
    fcut->save_ptf_varref(
      EXPORTING
       it_variant_tab = lt_empty_step_tab
       iv_varname     = gc_any_varname
       is_version     = value #( script_version = 1  src_system = sy-sysid )
      IMPORTING
        et_varref     = DATA(lt_varref)
    ).

*then
    cl_abap_unit_assert=>assert_initial(
      EXPORTING
        act                  = lt_varref
    ).

  ENDMETHOD.

  METHOD save_varref__irrelevant_input.

    DATA lt_step_tab TYPE cl_ptf_variant=>gty_step_data_tab.

*given
    get_irrelevant_variant_steps(
         IMPORTING
           et_variant_tab = lt_step_tab
           et_varref_expected = DATA(lt_varref_expected)
       ).

*when
    fcut->save_ptf_varref(
      EXPORTING
       it_variant_tab = lt_step_tab
       iv_varname     = gc_any_varname
       is_version     = value #( script_version = 1  src_system = sy-sysid )
      IMPORTING
        et_varref     = DATA(lt_varref)
    ).

*then
    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = lt_varref
        exp                  = lt_varref_expected
    ).

  ENDMETHOD.


  METHOD enrich_variant_w_varref.   "input: varref und variant_tab(w/o refs)      output: variant_tab(with refs)

    DATA lt_variant_tab TYPE cl_ptf_variant=>gty_step_data_tab.

* given
    get_bidirectional_data(
         IMPORTING
           et_variant_tab = DATA(lt_step_tab_expected)
           et_varref = DATA(lt_varref_input)
       ).

    "Remove ref info from step_tab => becomes the input that is to be enriched
    lt_variant_tab = lt_step_tab_expected.
    LOOP AT lt_variant_tab REFERENCE INTO DATA(lr_variant).
      CLEAR lr_variant->reference_step.
    ENDLOOP.

**when
    fcut->enrich_with_varref_data(
      EXPORTING
        it_varref      = lt_varref_input
      CHANGING
        ct_variant_tab = lt_variant_tab "in+out
    ).

*then
    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = lt_variant_tab
        exp                  = lt_step_tab_expected
    ).

  ENDMETHOD.

  METHOD enrich_variant_w_varref__dc. "test downward compatibility to old db records with empty ref_index.     "input: varref und variant_tab(w/o refs)      output: variant_tab(with refs)

    DATA lt_variant_tab TYPE cl_ptf_variant=>gty_step_data_tab.
    DATA lt_varref_input TYPE cl_ptf_variant=>gty_ptf_varref.

* given
    get_bidirectional_data(
         IMPORTING
           et_variant_tab = DATA(lt_step_tab_expected)
*           et_varref = DATA(lt_varref_input)
       ).

    "Remove ref info from step_tab => becomes the input that is to be enriched
    lt_variant_tab = lt_step_tab_expected.
    LOOP AT lt_variant_tab REFERENCE INTO DATA(lr_variant).
      CLEAR lr_variant->reference_step.
    ENDLOOP.

    lt_varref_input = VALUE #(
        ( mandt = sy-mandt varname = gc_any_varname step_number = '2' reference_step = '1' ) "ref_index has initial value in all records
        ( mandt = sy-mandt varname = gc_any_varname step_number = '4' reference_step = '3' ) "step 4 before step 3, must have no effect
        ( mandt = sy-mandt varname = gc_any_varname step_number = '4' reference_step = '1' )
        ( mandt = sy-mandt varname = gc_any_varname step_number = '4' reference_step = '2' )
        ( mandt = sy-mandt varname = gc_any_varname step_number = '3' reference_step = '1' )
        ( mandt = sy-mandt varname = gc_any_varname step_number = '3' reference_step = '2' )

       ).

**when
    fcut->enrich_with_varref_data(
      EXPORTING
        it_varref      = lt_varref_input
      CHANGING
        ct_variant_tab = lt_variant_tab "in+out
    ).

*then
    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = lt_variant_tab
        exp                  = lt_step_tab_expected
    ).

  ENDMETHOD.

  METHOD enrich_var_w_vref__all_empty.

* given
    DATA lt_variant_tab_empty TYPE cl_ptf_variant=>gty_step_data_tab.
    DATA lt_varref_empty  TYPE cl_ptf_variant=>gty_ptf_varref.

*when
    fcut->enrich_with_varref_data(
      EXPORTING
        it_varref      = lt_varref_empty
      CHANGING
        ct_variant_tab = lt_variant_tab_empty "in+out
    ).

*then
    cl_abap_unit_assert=>assert_initial( lt_variant_tab_empty ).

  ENDMETHOD.


  METHOD enrch_var_w_vref__no_ref_input.

* given
    DATA lt_varref_empty  TYPE cl_ptf_variant=>gty_ptf_varref.
    DATA lt_variant_tab TYPE cl_ptf_variant=>gty_step_data_tab.
    get_bidirectional_data(
         IMPORTING
           et_variant_tab = DATA(lt_step_tab_expected)
*           et_varref = DATA(lt_varref_input)
       ).

    "Remove ref info from step_tab => becomes input data
    lt_variant_tab = lt_step_tab_expected.
    LOOP AT lt_variant_tab REFERENCE INTO DATA(lr_variant).
      CLEAR lr_variant->reference_step.
    ENDLOOP.
    DATA(lt_variant_tab_expected) = lt_variant_tab.

*when
    fcut->enrich_with_varref_data(
      EXPORTING
        it_varref      = lt_varref_empty
      CHANGING
        ct_variant_tab = lt_variant_tab "in+out
    ).

*then:  method under test has not changed lt_variant_tab
    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = lt_variant_tab
        exp                  = lt_variant_tab_expected
    ).

  ENDMETHOD.

ENDCLASS.


CLASS ltcl_enrich_with_expmess_data DEFINITION DEFERRED.
CLASS cl_ptf_variant DEFINITION LOCAL FRIENDS ltcl_enrich_with_expmess_data.

CLASS ltcl_enrich_with_expmess_data DEFINITION FOR TESTING
  RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.

    DATA fcut TYPE REF TO cl_ptf_variant.

    METHODS setup.

    "unit tests
    METHODS all_empty_input       FOR TESTING.
    METHODS empty_expmess         FOR TESTING.
    METHODS success_1_check_step  FOR TESTING.
    METHODS success_2_check_steps FOR TESTING.

ENDCLASS.

CLASS ltcl_enrich_with_expmess_data IMPLEMENTATION.

  METHOD setup.
    fcut = NEW cl_ptf_variant( ).
  ENDMETHOD.

  METHOD all_empty_input.

* given
    DATA lt_variant_tab_empty TYPE cl_ptf_variant=>gty_step_data_tab.
    DATA lt_expmess_empty  TYPE cl_ptf_variant=>gty_varexpmess. "db format

*when
    fcut->enrich_with_expmess_data(
      EXPORTING
        it_expmess     = lt_expmess_empty
      CHANGING
        ct_variant_tab = lt_variant_tab_empty     "in+out
    ).

*then
    cl_abap_unit_assert=>assert_initial( lt_variant_tab_empty ).

  ENDMETHOD.

  METHOD empty_expmess.

* given
    DATA lt_variant_tab TYPE cl_ptf_variant=>gty_step_data_tab.
    DATA lt_variant_tab_before TYPE cl_ptf_variant=>gty_step_data_tab.
    DATA lt_expmess_empty  TYPE cl_ptf_variant=>gty_varexpmess. "db format

    lt_variant_tab = VALUE #(
                         ( bus_obj = 'DMR'     action = 'CREATE'              variant = 'VARIANT_1'   )
                         ( bus_obj = 'DMR'     action = 'CREATE'              variant = 'VARIANT_2'  reference_step = VALUE #( ( 1 )             )   )
                         ( bus_obj = 'PTF_RUN' action = 'START_DATA_MOCKING'  variant = 'VARIANT_M1' reference_step = VALUE #( ( 0 )             )   )
                         ( bus_obj = 'INVOICE' action = 'CREATE'              variant = ' '          reference_step = VALUE #( ( 1 ) ( 2 )       )   )
                         ( bus_obj = 'INVOICE' action = 'CHECK'               variant = ' '          reference_step = VALUE #( ( 4 ) ( 2 ) ( 3 ) )   )
                         ( bus_obj = 'PTF_RUN' action = 'END_DATA_MOCKING'    variant = 'VARIANT_M1' reference_step = VALUE #( ( 0 )             )   )
                     ).
    lt_variant_tab_before = lt_variant_tab.

*when
    fcut->enrich_with_expmess_data(
      EXPORTING
        it_expmess     = lt_expmess_empty
      CHANGING
        ct_variant_tab = lt_variant_tab     "in+out
    ).

*then
    cl_abap_unit_assert=>assert_equals( exp = lt_variant_tab_before  act = lt_variant_tab ).

  ENDMETHOD.

*  METHOD inconsistent_input.

** given
*    DATA lt_variant_tab TYPE cl_ptf_variant=>gty_step_data_tab.
*    DATA lt_expmess  TYPE cl_ptf_variant=>gty_varexpmess. "db format
*
*    lt_variant_tab = VALUE #(
*                         ( bus_obj = 'DMR'     action = 'CREATE'              variant = 'VARIANT_1'   )
*                         ( bus_obj = 'DMR'     action = 'CREATE'              variant = 'VARIANT_2'  reference_step = VALUE #( ( 1 )             )   ) " step 2 is not CHECK_MESSAGES as designed
*                         ( bus_obj = 'PTF_RUN' action = 'START_DATA_MOCKING'  variant = 'VARIANT_M1' reference_step = VALUE #( ( 0 )             )   )
*                         ( bus_obj = 'INVOICE' action = 'CREATE'              variant = ' '          reference_step = VALUE #( ( 1 ) ( 2 )       )   )
*                         ( bus_obj = 'INVOICE' action = 'CHECK'               variant = ' '          reference_step = VALUE #( ( 4 ) ( 2 ) ( 3 ) )   )
*                         ( bus_obj = 'PTF_RUN' action = 'END_DATA_MOCKING'    variant = 'VARIANT_M1' reference_step = VALUE #( ( 0 )             )   )
*                     ).
*
*    lt_expmess = VALUE #(
*                         ( STEP_NUMBER = 2 LINE_NUMBER = 1 opt = 'CONTAIN'    msgid = 'VF'   msgty = 'E'   msgno_low = '099' msgv1 = '1010'  operator = 'AND' )
*                         ( STEP_NUMBER = 2 LINE_NUMBER = 2 opt = 'NOTCONTAIN' msgid = space  msgty = 'S'                                     operator = space )
*                 ).
*
*
**when
*    fcut->enrich_with_expmess_data(
*      EXPORTING
*        it_expmess     = lt_expmess
*      CHANGING
*        ct_variant_tab = lt_variant_tab     "in+out
*    ).

*then
*    cl_abap_unit_assert=>assert_initial( lt_variant_tab_empty ).

*  ENDMETHOD.


  METHOD success_1_check_step.

* given
    DATA lt_variant_tab TYPE cl_ptf_variant=>gty_step_data_tab.
    DATA lt_expmess  TYPE cl_ptf_variant=>gty_varexpmess. "db format

    lt_variant_tab = VALUE #(
                         ( bus_obj = 'DMR'     action = 'CREATE'              variant = 'VARIANT_1'   )
                         ( bus_obj = 'DMR'     action = 'CREATE'              variant = 'VARIANT_2'  reference_step = VALUE #( ( 1 )             )   )
                         ( bus_obj = 'PTF_RUN' action = 'START_DATA_MOCKING'  variant = 'VARIANT_M1' reference_step = VALUE #( ( 0 )             )   )
                         ( bus_obj = 'PTF_RUN' action = 'CHECK_MESSAGES'      variant = space  )
                         ( bus_obj = 'INVOICE' action = 'CREATE'              variant = ' '          reference_step = VALUE #( ( 1 ) ( 2 )       )   )
                         ( bus_obj = 'INVOICE' action = 'CHECK'               variant = ' '          reference_step = VALUE #( ( 4 ) ( 2 ) ( 3 ) )   )
                         ( bus_obj = 'PTF_RUN' action = 'END_DATA_MOCKING'    variant = 'VARIANT_M1' reference_step = VALUE #( ( 0 )             )   )
                     ).

    lt_expmess = VALUE #(
                         ( step_number = 4 line_number = 1 opt = 'CONTAIN'    msgid = 'VF'   msgty = 'E'   msgno_low = '099' msgv1 = '1010'  operator = 'AND' )
                         ( step_number = 4 line_number = 2 opt = 'NOTCONTAIN' msgid = space  msgty = 'S'                                     operator = space )
                 ).

    DATA lt_expmess_internal_format TYPE ptf_exp_message_t.
    MOVE-CORRESPONDING lt_expmess TO lt_expmess_internal_format.

*when
    fcut->enrich_with_expmess_data(
      EXPORTING
        it_expmess     = lt_expmess
      CHANGING
        ct_variant_tab = lt_variant_tab     "in+out
    ).

*then

    cl_abap_unit_assert=>assert_equals( exp = lt_expmess_internal_format  act = lt_variant_tab[ 4 ]-exp_messages ).

    CLEAR lt_variant_tab[ 4 ]-exp_messages.
    LOOP AT lt_variant_tab ASSIGNING FIELD-SYMBOL(<ls_step>).
      cl_abap_unit_assert=>assert_initial( <ls_step>-exp_messages ).
    ENDLOOP.

  ENDMETHOD.

  METHOD success_2_check_steps.

* given
    DATA lt_variant_tab TYPE cl_ptf_variant=>gty_step_data_tab.
    DATA lt_expmess  TYPE cl_ptf_variant=>gty_varexpmess. "db format

    lt_variant_tab = VALUE #(
                         ( bus_obj = 'DMR'     action = 'CREATE'              variant = 'VARIANT_1'   )
                         ( bus_obj = 'DMR'     action = 'CREATE'              variant = 'VARIANT_2'  reference_step = VALUE #( ( 1 )             )   )
                         ( bus_obj = 'PTF_RUN' action = 'CHECK_MESSAGES'      variant = space  ) "line 3
                         ( bus_obj = 'PTF_RUN' action = 'START_DATA_MOCKING'  variant = 'VARIANT_M1' reference_step = VALUE #( ( 0 )             )   )
                         ( bus_obj = 'INVOICE' action = 'CREATE'              variant = ' '          reference_step = VALUE #( ( 1 ) ( 2 )       )   )
                         ( bus_obj = 'INVOICE' action = 'CHECK'               variant = ' '          reference_step = VALUE #( ( 4 ) ( 2 ) ( 3 ) )   )
                         ( bus_obj = 'PTF_RUN' action = 'CHECK_MESSAGES'      variant = space  ) "line 7
                         ( bus_obj = 'PTF_RUN' action = 'END_DATA_MOCKING'    variant = 'VARIANT_M1' reference_step = VALUE #( ( 0 )             )   )
                     ).

    lt_expmess = VALUE #(
                         ( step_number = 3 line_number = 1 opt = 'CONTAIN'    msgid = 'VF'                 msgno_low =  '12'                 operator = space )
                         ( step_number = 7 line_number = 1 opt = 'CONTAIN'    msgid = 'VF'   msgty = 'E'   msgno_low = '099' msgv1 = '1010'  operator = 'AND' )
                         ( step_number = 7 line_number = 2 opt = 'NOTCONTAIN' msgid = space  msgty = 'S'                                     operator = space )
                 ).

    DATA lt_expmess_internal_format_3 TYPE ptf_exp_message_t.
    DATA ls_mess_internal TYPE ptf_exp_message.
    LOOP AT lt_expmess ASSIGNING FIELD-SYMBOL(<ls_mess_db>) WHERE step_number = 3.
      CLEAR ls_mess_internal.
      MOVE-CORRESPONDING <ls_mess_db> TO ls_mess_internal.
      APPEND ls_mess_internal TO lt_expmess_internal_format_3.
    ENDLOOP.
    DATA lt_expmess_internal_format_7 TYPE ptf_exp_message_t.
    LOOP AT lt_expmess ASSIGNING <ls_mess_db> WHERE step_number = 7.
      CLEAR ls_mess_internal.
      MOVE-CORRESPONDING <ls_mess_db> TO ls_mess_internal.
      APPEND ls_mess_internal TO lt_expmess_internal_format_7.
    ENDLOOP.

*when
    fcut->enrich_with_expmess_data(
      EXPORTING
        it_expmess     = lt_expmess
      CHANGING
        ct_variant_tab = lt_variant_tab     "in+out
    ).

*then

    "messages are stored at correct step
    cl_abap_unit_assert=>assert_equals( exp = lt_expmess_internal_format_3 act = lt_variant_tab[ 3 ]-exp_messages ).
    cl_abap_unit_assert=>assert_equals( exp = lt_expmess_internal_format_7 act = lt_variant_tab[ 7 ]-exp_messages ).

    "other steps shall have no messages
    CLEAR lt_variant_tab[ 3 ]-exp_messages.
    CLEAR lt_variant_tab[ 7 ]-exp_messages.
    LOOP AT lt_variant_tab ASSIGNING FIELD-SYMBOL(<ls_step>).
      cl_abap_unit_assert=>assert_initial( <ls_step>-exp_messages ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.


CLASS ltcl_is_in_customer_namespace DEFINITION FOR TESTING
  RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.

    METHODS only_first FOR TESTING.
    METHODS only_second FOR TESTING.
    METHODS both FOR TESTING.
    METHODS none FOR TESTING.
    METHODS first_initial_scnd_filled_pos FOR TESTING.
    METHODS first_initial_scnd_filled_neg FOR TESTING.
    METHODS all_initial FOR TESTING.
    METHODS leading_space_evaluated FOR TESTING.
    METHODS short_positive_1 FOR TESTING.
    METHODS short_positive_2 FOR TESTING.
    METHODS short_negative FOR TESTING.

    METHODS setup.

    DATA fcut TYPE REF TO cl_ptf_variant.

ENDCLASS.


CLASS ltcl_is_in_customer_namespace IMPLEMENTATION.

  METHOD setup.
    fcut = NEW cl_ptf_variant( ).
  ENDMETHOD.

  METHOD only_first.

    cl_abap_unit_assert=>assert_true(
      act = fcut->is_in_customer_namespace( iv_name = 'ZHALLO'  )
    ).

  ENDMETHOD.

  METHOD only_second.

    cl_abap_unit_assert=>assert_true(
      act = fcut->is_in_customer_namespace( iv_name = 'HALLO' iv_2nd_name = 'ZNR2' )
    ).

  ENDMETHOD.

  METHOD both.

    cl_abap_unit_assert=>assert_true(
      act = fcut->is_in_customer_namespace( iv_name = 'YHALLO' iv_2nd_name = 'YNR2' )
    ).

  ENDMETHOD.

  METHOD none.

    cl_abap_unit_assert=>assert_false(
      act = fcut->is_in_customer_namespace( iv_name = 'HALLO' iv_2nd_name = 'NR2' )
    ).

  ENDMETHOD.

  METHOD first_initial_scnd_filled_pos.

    cl_abap_unit_assert=>assert_true(
      act = fcut->is_in_customer_namespace( iv_name = space iv_2nd_name = 'YSECONDNAMEINCUSTNS' )
    ).

  ENDMETHOD.

  METHOD first_initial_scnd_filled_neg.

    cl_abap_unit_assert=>assert_false(
      act = fcut->is_in_customer_namespace( iv_name = space iv_2nd_name = 'SECONDNAMEINSAPNS' )
    ).

  ENDMETHOD.

  METHOD all_initial.

    cl_abap_unit_assert=>assert_false(
      act = fcut->is_in_customer_namespace( iv_name = space iv_2nd_name = space )
    ).

  ENDMETHOD.

  METHOD leading_space_evaluated.

    cl_abap_unit_assert=>assert_false(
      act = fcut->is_in_customer_namespace( iv_name = ' ZSHIFTED' )
    ).

  ENDMETHOD.

  METHOD short_positive_1.

    cl_abap_unit_assert=>assert_true(
      act = fcut->is_in_customer_namespace( iv_name = 'Y' )
    ).

  ENDMETHOD.

  METHOD short_positive_2.

    cl_abap_unit_assert=>assert_true(
      act = fcut->is_in_customer_namespace( iv_name = space iv_2nd_name = 'Z' )
    ).

  ENDMETHOD.

  METHOD short_negative.

    cl_abap_unit_assert=>assert_false(
      act = fcut->is_in_customer_namespace( iv_name = 'A' )
    ).

  ENDMETHOD.

ENDCLASS.
