CLASS ltc_remove_duplicate_scripts DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    DATA mo_cut     TYPE REF TO cl_ptf_util.
    DATA mt_varname	TYPE cl_ptf_util=>ty_t_varname.

    METHODS:
      setup,
      call_and_validate_result
        IMPORTING
          it_input    TYPE cl_ptf_util=>ty_t_varname
          it_expected TYPE cl_ptf_util=>ty_t_varname,

      no_doubles_2_recs FOR TESTING,
      no_doubles_3_recs FOR TESTING,
      no_doubles_3recs_pls_1_initial FOR TESTING,
      same_3x FOR TESTING,
      a_5rec_with_2same FOR TESTING,
      b_5rec_with_2same FOR TESTING,
      c_8rec_with_3same FOR TESTING,
      complex FOR TESTING.

ENDCLASS.


CLASS ltc_remove_duplicate_scripts IMPLEMENTATION.

  METHOD setup.
*    me->mo_cut = NEW cl_ptf_util( ). "created remove_duplicate_scripts as static method as the constructor expects BO and action (seems class instance was designed with TDC access in mind)
    CLEAR mt_varname.
  ENDMETHOD.

  METHOD call_and_validate_result.

    DATA lt_varname_unique TYPE cl_ptf_util=>ty_t_varname.

    cl_ptf_util=>remove_duplicate_scripts(
      EXPORTING
        it_varname         = it_input
      IMPORTING
        et_varname_unique  = lt_varname_unique
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = lt_varname_unique
        exp                  = it_expected
    ).

    "Compare number also against result from DELETE ADJACENT DUPLICATES
    DATA lt_varname_sorted_wo_dupl TYPE SORTED TABLE OF ptf_varname WITH NON-UNIQUE DEFAULT KEY .
    lt_varname_sorted_wo_dupl = it_input.
    DELETE lt_varname_sorted_wo_dupl WHERE table_line = space.
    DELETE ADJACENT DUPLICATES FROM lt_varname_sorted_wo_dupl.
    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = lines( lt_varname_unique )
        exp                  = lines( lt_varname_sorted_wo_dupl )
    ).

  ENDMETHOD.

  METHOD no_doubles_2_recs.
    mt_varname = VALUE #( ( 'SFS_STDO' ) ( 'CR_EBDR_ED01_EC01' ) ).
    call_and_validate_result( it_input = mt_varname it_expected = mt_varname ).
  ENDMETHOD.

  METHOD no_doubles_3_recs.
    mt_varname = VALUE #( ( 'SFS_STDO' ) ( 'CR_EBDR_ED01_EC' ) ( 'NUMBER3' ) ).
    call_and_validate_result( it_input = mt_varname it_expected = mt_varname ).
  ENDMETHOD.

  METHOD no_doubles_3recs_pls_1_initial.

    DATA lt_expected TYPE cl_ptf_util=>ty_t_varname.
    mt_varname  = VALUE #( ( 'SFS_STDO' ) ( space ) ( 'CR_EBDR_ED01_EC' ) ( 'NUMBER3' ) ).
    lt_expected = VALUE #( ( 'SFS_STDO' ) ( 'CR_EBDR_ED01_EC' ) ( 'NUMBER3' ) ).

    call_and_validate_result( it_input = mt_varname it_expected = lt_expected ).

  ENDMETHOD.

  METHOD same_3x.

    DATA lt_expected TYPE cl_ptf_util=>ty_t_varname.
    mt_varname  = VALUE #( ( 'SFS_STDO' ) ( 'SFS_STDO' ) ( 'SFS_STDO' ) ).
    lt_expected = VALUE #( ( 'SFS_STDO' ) ).

    call_and_validate_result( it_input = mt_varname it_expected = lt_expected ).

  ENDMETHOD.

  METHOD a_5rec_with_2same.

    DATA lt_expected TYPE cl_ptf_util=>ty_t_varname.
    mt_varname  = VALUE #( ( 'SFS_STDO' ) ( 'CR_EBDR_ED01_EC' ) ( 'SFS_STDO' ) ( 'ANUMBER3' ) ( 'SFS_STDO' ) ).
    lt_expected = VALUE #( ( 'SFS_STDO' ) ( 'CR_EBDR_ED01_EC' ) ( 'ANUMBER3' ) ).

    call_and_validate_result( it_input = mt_varname it_expected = lt_expected ).

  ENDMETHOD.

  METHOD b_5rec_with_2same.

    DATA lt_expected TYPE cl_ptf_util=>ty_t_varname.
    mt_varname  = VALUE #( ( 'SFS_STDO' ) ( 'ANUMBER3' ) ( 'ANUMBER3' ) ( 'CR_EBDR_ED01_EC' ) ( 'ANUMBER3' ) ).
    lt_expected = VALUE #( ( 'SFS_STDO' ) ( 'ANUMBER3' ) ( 'CR_EBDR_ED01_EC' ) ).

    call_and_validate_result( it_input = mt_varname it_expected = lt_expected ).

  ENDMETHOD.

  METHOD c_8rec_with_3same.

    DATA lt_expected TYPE cl_ptf_util=>ty_t_varname.
    mt_varname  = VALUE #( ( '8' ) ( '5' ) ( '8' ) ( '5' ) ( '7' ) ( 'BC' ) ( '5' ) ( '9' ) ).
    lt_expected = VALUE #( ( '8' ) ( '5' ) ( '7' ) ( 'BC' ) ( '9' ) ).

    call_and_validate_result( it_input = mt_varname it_expected = lt_expected ).

  ENDMETHOD.

  METHOD complex.

    DATA lt_expected TYPE cl_ptf_util=>ty_t_varname.
    mt_varname  = VALUE #( ( '8' ) ( 'ABCDE' ) ( '3' ) ( 'HELLO' ) ( 'ABC' ) ( space ) ( 'ABC' ) ( '9' ) ( 'BCDE' ) ( '8' ) ).
    lt_expected = VALUE #( ( '8' ) ( 'ABCDE' ) ( '3' ) ( 'HELLO' ) ( 'ABC' ) ( '9' ) ( 'BCDE' ) ).

    call_and_validate_result( it_input = mt_varname it_expected = lt_expected ).

  ENDMETHOD.

ENDCLASS.


CLASS ltc_ptf_util DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.
  PUBLIC SECTION.
  PRIVATE SECTION.
    DATA f_cut TYPE REF TO cl_ptf_util.
    METHODS setup RAISING cx_ecatt_tdc_access.
    METHODS teardown.

    CLASS-METHODS class_setup.
*    METHODS get_testdata FOR TESTING.
    METHODS set_variant
      IMPORTING
                iv_document_type        TYPE auart
                iv_sales_organization   TYPE vkorg
                iv_distribution_channel TYPE vtweg
                iv_division             TYPE spart
                iv_customer_id          TYPE kunnr
                iv_order_reason         TYPE augru
                iv_billing_block        TYPE faksk
                iv_item_list            TYPE cl_ptf_sd_util=>ty_gt_item_list_td
      RETURNING VALUE(ro_variant)       TYPE cl_ptf_bo_dmr=>ty_gs_i_ptf_dmr_cr_td.
    METHODS set_item_list
      IMPORTING
                iv_material_id     TYPE matnr
                iv_quantity        TYPE dzmeng
                iv_posnr           TYPE posnr_va
      RETURNING VALUE(rt_itemlist) TYPE cl_ptf_sd_util=>ty_gt_item_list_td.

*    METHODS set_cursor FOR TESTING.
    METHODS get_syst_field_cdatp FOR TESTING.
    METHODS get_syst_field_idatm FOR TESTING.
    METHODS get_syst_field_idatm_string FOR TESTING.
    METHODS get_syst_field_ignore_sy_datum FOR TESTING.
    METHODS get_sys__ignore_sy_dat__string FOR TESTING.
    METHODS get_syst_field_ignr_syst_datum FOR TESTING.
    METHODS get_syst_field_sydatum FOR TESTING.
    METHODS get_syst_field_sydatum_plus FOR TESTING.
    METHODS get_syst_field_sydatum_plus_yr FOR TESTING.
    METHODS get_syst_field_sydatlo FOR TESTING.
    METHODS get_syst_field_sy_typo FOR TESTING.
    METHODS get_syst_field_syuname FOR TESTING.
    METHODS get_syst_field_ignore_string1 FOR TESTING.
    METHODS get_syst_field_ignore_string2 FOR TESTING.
    METHODS get_syst_field_ignore_string3 FOR TESTING.
    METHODS get_syst_field_ignore_string4 FOR TESTING.
    METHODS get_syst_field_ignore_string5 FOR TESTING.
    METHODS get_syst_field_ignore_number FOR TESTING.
    METHODS get_syst_field_ignore_abapstr1 FOR TESTING.
    METHODS get_syst_field_ignore_abapstr2 FOR TESTING.
    METHODS get_syst_field_ignore_soap FOR TESTING.
    METHODS get_syst_field_ignore_char FOR TESTING.
    METHODS get_syst_field_ignore_initial FOR TESTING.
    METHODS get_syst_field_w_filled_ev FOR TESTING.
    METHODS get_syst_field_w_filled_ev_sy FOR TESTING.

    METHODS constructor_bo_unkown FOR TESTING.
    METHODS inject_message IMPORTING iv_case TYPE i.
    CLASS-METHODS class_teardown.
    METHODS setup_sql_double.

    CLASS-DATA go_ptf_util TYPE REF TO if_osql_test_environment.
ENDCLASS.
*
CLASS ltc_ptf_util IMPLEMENTATION.
  METHOD setup.
    f_cut = NEW cl_ptf_util(
*        iv_tdcv_name =
        iv_bo        = 'DMR'
        iv_action    = 'CREATE' ).
  ENDMETHOD.

  METHOD class_setup.
    go_ptf_util = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'PTF_VARID' ) ) ).
  ENDMETHOD.

  METHOD class_teardown.
    "removes all doubles created as part of test session
    go_ptf_util->destroy( ).
  ENDMETHOD.
  METHOD set_item_list.
    DATA ls_item_list TYPE cl_ptf_sd_util=>ty_gs_item_list_td.
    DATA lt_item_list TYPE cl_ptf_sd_util=>ty_gt_item_list_td.
    ls_item_list-material_id = iv_material_id.
    ls_item_list-posnr = iv_posnr.
    ls_item_list-quantity = iv_quantity.
    APPEND ls_item_list TO lt_item_list.

    rt_itemlist = lt_item_list.
  ENDMETHOD.

  METHOD set_variant.
    DATA(lo_variant) = VALUE cl_ptf_bo_dmr=>ty_gs_i_ptf_dmr_cr_td( document_type = iv_document_type
                                                                 sales_organization = iv_sales_organization
                                                                 distribution_channel = iv_distribution_channel
                                                                 division = iv_division
                                                                 customer_id = iv_customer_id
                                                                 order_reason = iv_order_reason
                                                                 item_list = iv_item_list
                                                                              ).
    ro_variant = lo_variant.
  ENDMETHOD.

  METHOD setup_sql_double.
*    DATA lt_ptfboa TYPE STANDARD TABLE OF ptfboa WITH DEFAULT KEY.
*    lt_ptfboa = VALUE #( ( ptf_bo = 'DMR' ptf_act = 'CREATE' ptf_tdcp = 'I_PTF_DMR_CR'  ptf_tdc = 'TDC_PTF_OL' )
*                         ( ptf_bo = 'DMR' ptf_act = 'CREATE' ptf_tdcp = ' '  ptf_tdc = 'TDC_PTF_OL' ) ).
  ENDMETHOD.

  METHOD teardown.
    go_ptf_util->clear_doubles( ).
  ENDMETHOD.
** Method for finding data_type!!
*  METHOD get_testdata.
*    DATA ls_tdv_content TYPE if_ptf_param_types=>ty_gs_i_ptf_dmr_cr_td.
*
*    CREATE OBJECT f_cut
*      EXPORTING
*        iv_tdcv_name = 'DMR_CR_I1_Q1'  " Variant name
*        iv_bo        = 'DMR'  " Business Object for Process Test Framework
*        iv_action    = 'CREATE'. " Process Test Framework Action
*
*    f_cut->get_testdata(
*      EXPORTING
*        iv_var_name     = 'DMR_CR_I1_Q1'
*        iv_bo           = 'DMR'
*        iv_act          = 'CREATE'
*      IMPORTING
*        es_tdcv_content = ls_tdv_content ).
*
*    DATA(lo_variant) = me->set_variant(
*                       iv_document_type        = 'L2'
*                       iv_sales_organization   = '0001'
*                       iv_distribution_channel = '01'
*                       iv_division             = '01'
*                       iv_customer_id          = 'KRIKRI'
*                       iv_order_reason         = '001'
*                       iv_billing_block        = ' '
*                       iv_item_list            = set_item_list(   iv_material_id = 'CHR_TEST01'
*                                                                  iv_quantity    = '1'
*                                                                  iv_posnr       = '000010'
*                                                               )
*                   ).
*    cl_abap_unit_assert=>assert_equals(
*      EXPORTING
*        act                  =  ls_tdv_content   " Data object with current value
*        exp                  =  lo_variant  " Data object with expected type
*        msg                  =  'Wrong data retrieved'   " Description
*    ).
*  ENDMETHOD.
*

*
*  METHOD set_cursor.
*    DATA lv_bo TYPE ptf_bo VALUE 'DMR'.
*    DATA lv_act TYPE ptf_act VALUE 'CREATE'.
*    DATA lv_tdcv TYPE ptf_tdcv VALUE 'TESTVARIANTE'.
*    DATA lv_ref_step TYPE ptf_ref_step VALUE '2'.
*
*    DATA ls_struct TYPE cl_ptf_util=>gty_sel_screen.
** Test bo:
*    ls_struct-ptf_bo = lv_bo.
*    ls_struct-ptf_var_step = lv_ref_step.
*    cl_ptf_util=>set_cursor(
*      EXPORTING
*        is_cursor_table = ls_struct
*      RECEIVING
*        rv_cursor_pos   = DATA(lt_cursor)
*    ).
*
*    cl_abap_unit_assert=>assert_equals(
*      EXPORTING
*        act                  =  lt_cursor
*        exp                  =  'P_BO2'
*        msg                  = 'Wrong cursor position for Business object'
*    ).
*
*    CLEAR ls_struct.
*    CLEAR lt_cursor.
** Test Action:
*    ls_struct-ptf_act = lv_act.
*    ls_struct-ptf_var_step = lv_ref_step.
*    cl_ptf_util=>set_cursor(
*      EXPORTING
*        is_cursor_table = ls_struct
*      RECEIVING
*        rv_cursor_pos   = lt_cursor
*    ).
*
*    cl_abap_unit_assert=>assert_equals(
*      EXPORTING
*        act                  =  lt_cursor
*        exp                  =  'P_ACT2'
*        msg                  = 'Wrong cursor position for Business object'
*    ).
*    CLEAR ls_struct.
*    CLEAR lt_cursor.
** Test Vo_Bo10:
*    ls_struct-ptf_ref_step = 'X'.
*    ls_struct-ptf_var_step = 10.
*    cl_ptf_util=>set_cursor(
*      EXPORTING
*        is_cursor_table = ls_struct
*      RECEIVING
*        rv_cursor_pos   = lt_cursor
*    ).
*
*    cl_abap_unit_assert=>assert_equals(
*      EXPORTING
*        act                  =  lt_cursor
*        exp                  =  'P_V_BO10'
*        msg                  = 'Wrong cursor position for Business object'
*    ).
*
*    CLEAR ls_struct.
*    CLEAR lt_cursor.
** Test Vo_Bo1:
*    ls_struct-ptf_ref_step = '>'.
*    ls_struct-ptf_var_step = 1.
*    cl_ptf_util=>set_cursor(
*      EXPORTING
*        is_cursor_table = ls_struct
*      RECEIVING
*        rv_cursor_pos   = lt_cursor
*    ).
*
*    cl_abap_unit_assert=>assert_equals(
*      EXPORTING
*        act                  =  lt_cursor
*        exp                  =  'P_VO_BO1'
*        msg                  = 'Wrong cursor position for Business object'
*    ).
*  ENDMETHOD.


  METHOD get_syst_field_cdatp.

    DATA lv_date TYPE fkdat.

    f_cut->get_syst_field(
      EXPORTING
        iv_field_name  = 'CDATP1'
      IMPORTING
        ev_field_value = lv_date
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =  lv_date
        exp                  =  sy-datlo + 1
        msg                  =  'Wrong date retrieved'
    ).
  ENDMETHOD.

  METHOD get_syst_field_idatm.

    DATA lv_date TYPE fkdat.
    DATA lv_yesterday_inverted TYPE gdatu_inv.

    f_cut->get_syst_field(
      EXPORTING
        iv_field_name  = 'IDATM1'
      IMPORTING
        ev_field_value = lv_date
    ).

    DATA lv_date_char15 TYPE char15.
    DATA lv_yesterday TYPE dats.
    lv_yesterday = sy-datlo - 1.
    WRITE lv_yesterday TO lv_date_char15.
    CALL FUNCTION 'CONVERSION_EXIT_INVDT_INPUT'
      EXPORTING
        input  = lv_date_char15
      IMPORTING
        output = lv_yesterday_inverted.

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =  lv_date
        exp                  =  lv_yesterday_inverted
    ).
  ENDMETHOD.

  METHOD get_syst_field_idatm_string.

    DATA result_string TYPE string.
    DATA lv_yesterday_inverted TYPE gdatu_inv.

    f_cut->get_syst_field(
      EXPORTING
        iv_field_name  = 'IDATM1'
      IMPORTING
        ev_field_value = result_string
    ).

    DATA lv_date_char15 TYPE char15.
    DATA lv_yesterday TYPE dats.
    lv_yesterday = sy-datlo - 1.
    WRITE lv_yesterday TO lv_date_char15.
    CALL FUNCTION 'CONVERSION_EXIT_INVDT_INPUT'
      EXPORTING
        input  = lv_date_char15
      IMPORTING
        output = lv_yesterday_inverted.

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =  result_string
        exp                  =  lv_yesterday_inverted
    ).
  ENDMETHOD.

  METHOD get_syst_field_ignore_sy_datum.

    DATA lv_date TYPE fkdat.

    f_cut->get_syst_field(
      EXPORTING
        iv_field_name  = 'sy-datum'
      IMPORTING
        ev_field_value = lv_date
    ).

    cl_abap_unit_assert=>assert_initial( lv_date ).

*    cl_abap_unit_assert=>assert_equals(    "has never worked I assume
*      EXPORTING
*        act                  =  lv_date
*        exp                  =  sy-datum
*    ).
  ENDMETHOD.

  METHOD get_sys__ignore_sy_dat__string.

    DATA result_string TYPE string.

    f_cut->get_syst_field(
      EXPORTING
        iv_field_name  = 'sy-datum'
      IMPORTING
        ev_field_value = result_string "same test as above, but with different type (string) for actual parameter of formal parameter ev_field_value (type any)
    ).

    cl_abap_unit_assert=>assert_initial( result_string ).

  ENDMETHOD.

  METHOD get_syst_field_ignr_syst_datum.

    DATA lv_date TYPE fkdat.

    f_cut->get_syst_field(
      EXPORTING
        iv_field_name  = 'SYST-DATUM'
      IMPORTING
        ev_field_value = lv_date
    ).

    cl_abap_unit_assert=>assert_initial( lv_date ).

*    cl_abap_unit_assert=>assert_equals(   "has never worked I assume
*      EXPORTING
*        act                  =  lv_date
*        exp                  =  sy-datum
*    ).
  ENDMETHOD.

  METHOD get_syst_field_sydatum.

    DATA lv_date TYPE fkdat.

    f_cut->get_syst_field(
      EXPORTING
        iv_field_name  = 'sydatum'
      IMPORTING
        ev_field_value = lv_date
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =  lv_date
        exp                  =  sy-datum
        msg                  =  'Wrong date retrieved'
    ).
  ENDMETHOD.

  METHOD get_syst_field_sydatum_plus.

    DATA lv_date TYPE fkdat.

    f_cut->get_syst_field(
      EXPORTING
        iv_field_name  = 'sydatum + 3'
      IMPORTING
        ev_field_value = lv_date
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =  lv_date
        exp                  =  sy-datum + 3
        msg                  =  'Wrong date retrieved'
    ).
  ENDMETHOD.

  METHOD get_syst_field_sydatum_plus_yr.

    DATA lv_date TYPE fkdat.

    f_cut->get_syst_field(
      EXPORTING
        iv_field_name  = 'sydatum + 365'
      IMPORTING
        ev_field_value = lv_date
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =  lv_date
        exp                  =  sy-datum + 365
        msg                  =  'Wrong date retrieved'
    ).
  ENDMETHOD.

  METHOD get_syst_field_sydatlo.

    DATA lv_date TYPE fkdat.

    f_cut->get_syst_field(
      EXPORTING
        iv_field_name  = 'sydatlo'
      IMPORTING
        ev_field_value = lv_date
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =  lv_date
        exp                  =  sy-datlo
        msg                  =  'Wrong date retrieved'
    ).
  ENDMETHOD.

  METHOD get_syst_field_sy_typo.

    DATA lv_date TYPE fkdat.

    f_cut->get_syst_field(
      EXPORTING
        iv_field_name  = 'sydutlo'
      IMPORTING
        ev_field_value = lv_date
    ).

    cl_abap_unit_assert=>assert_initial(
      EXPORTING
        act                  =  lv_date
    ).
  ENDMETHOD.

  METHOD get_syst_field_syuname.

    DATA lv_user TYPE usnam.

    f_cut->get_syst_field(
      EXPORTING
        iv_field_name  = 'syuname'
      IMPORTING
        ev_field_value = lv_user
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =  lv_user
        exp                  =  sy-uname
    ).
  ENDMETHOD.

  METHOD get_syst_field_ignore_string1.

    DATA original_string TYPE string VALUE 'TESTSYSTEM'.
    DATA result_string TYPE string.

    f_cut->get_syst_field(
      EXPORTING
        iv_field_name  = original_string
      IMPORTING
        ev_field_value = result_string
    ).

    cl_abap_unit_assert=>assert_initial( result_string ).

  ENDMETHOD.

  METHOD get_syst_field_ignore_string2.

    DATA original_string TYPE string VALUE 'TESTSYS'.
    DATA result_string TYPE string.

    f_cut->get_syst_field(
      EXPORTING
        iv_field_name  = original_string
      IMPORTING
        ev_field_value = result_string
    ).

    cl_abap_unit_assert=>assert_initial( result_string ).

  ENDMETHOD.

  METHOD get_syst_field_ignore_string3.

    DATA original_string TYPE string VALUE 'SYSTEM'.
    DATA result_string TYPE string.

    f_cut->get_syst_field(
      EXPORTING
        iv_field_name  = original_string
      IMPORTING
        ev_field_value = result_string
    ).

    cl_abap_unit_assert=>assert_initial( result_string ).

  ENDMETHOD.

  METHOD get_syst_field_ignore_string4.

    DATA original_string TYPE string VALUE 'HAMBURG'.
    DATA result_string TYPE string.

    f_cut->get_syst_field(
      EXPORTING
        iv_field_name  = original_string
      IMPORTING
        ev_field_value = result_string
    ).

    cl_abap_unit_assert=>assert_initial( result_string ).

  ENDMETHOD.

  METHOD get_syst_field_ignore_string5.

    DATA original_string TYPE string VALUE 'LYSY'.
    DATA result_string TYPE string.

    f_cut->get_syst_field(
      EXPORTING
        iv_field_name  = original_string
      IMPORTING
        ev_field_value = result_string
    ).

    cl_abap_unit_assert=>assert_initial( result_string ).

  ENDMETHOD.

  METHOD get_syst_field_ignore_number.

    DATA original_string TYPE string VALUE '123'.
    DATA result_string TYPE string.

    f_cut->get_syst_field(
      EXPORTING
        iv_field_name  = original_string
      IMPORTING
        ev_field_value = result_string
    ).

    cl_abap_unit_assert=>assert_initial( result_string ).

  ENDMETHOD.

  METHOD get_syst_field_ignore_abapstr1.

    DATA original_string TYPE string VALUE 'ASSIGNING FIELD-SYMBOL'.
    DATA result_string TYPE string.

    f_cut->get_syst_field(
      EXPORTING
        iv_field_name  = original_string
      IMPORTING
        ev_field_value = result_string
    ).

    cl_abap_unit_assert=>assert_initial( result_string ).

  ENDMETHOD.

  METHOD get_syst_field_ignore_abapstr2.

    DATA original_string TYPE string VALUE 'if sy-subrc'.
    DATA result_string TYPE string.

    f_cut->get_syst_field(
      EXPORTING
        iv_field_name  = original_string
      IMPORTING
        ev_field_value = result_string
    ).

    cl_abap_unit_assert=>assert_initial( result_string ).

  ENDMETHOD.

  METHOD get_syst_field_ignore_soap.

    DATA xml    TYPE string.
    DATA result_string TYPE string.
    xml = '<n0:OrderRequest xmlns:n0="http://sap.com/xi/EDI" xmlns:prx="urn:sap.com:proxy:HBR:/1SAI/TAS813A0CAF5E48F72CEACA:777">' &&
         '<MessageHeader><CreationDateTime>{CreationDateTime}</CreationDateTime><SenderBusinessSystemID>0MB85UO</SenderBusinessSystemID>' &&
         '<SenderParty><InternalID>EDI_PTF01</InternalID></SenderParty>'.

    f_cut->get_syst_field(
      EXPORTING
        iv_field_name  = xml
      IMPORTING
        ev_field_value = result_string
    ).

    cl_abap_unit_assert=>assert_initial( result_string ).

  ENDMETHOD.

  METHOD get_syst_field_ignore_char. "as access with length like in lv_field(2) might fail

    DATA original_string TYPE string VALUE 'J'.
    DATA result_string TYPE string.

    f_cut->get_syst_field(
      EXPORTING
        iv_field_name  = original_string
      IMPORTING
        ev_field_value = result_string
    ).

    cl_abap_unit_assert=>assert_initial( result_string ).

  ENDMETHOD.

  METHOD get_syst_field_ignore_initial.

    DATA original_string TYPE string.
    DATA result_string TYPE string.

    f_cut->get_syst_field(
      EXPORTING
        iv_field_name  = original_string
      IMPORTING
        ev_field_value = result_string
    ).

    cl_abap_unit_assert=>assert_initial( result_string ).

  ENDMETHOD.

  METHOD get_syst_field_w_filled_ev.

    DATA original_string TYPE string VALUE 'HAMBURGER'.
    DATA result_string TYPE string.

    result_string = original_string.

    f_cut->get_syst_field(
      EXPORTING
        iv_field_name  = original_string
      IMPORTING
        ev_field_value = result_string
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =  result_string
        exp                  =  original_string
    ).

  ENDMETHOD.

    METHOD get_syst_field_w_filled_ev_sy.

    DATA original_string TYPE string VALUE 'SY'.
    DATA result_string TYPE string.

    result_string = original_string.

    f_cut->get_syst_field(
      EXPORTING
        iv_field_name  = original_string
      IMPORTING
        ev_field_value = result_string
    ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =  result_string
        exp                  =  original_string
    ).

  ENDMETHOD.



  METHOD constructor_bo_unkown.

    inject_message( '1' ).
    "setup_sql_double( ).
    TRY.
        DATA(lo_util) = NEW cl_ptf_util( iv_bo = 'SOMETHING SENSELESS' iv_action = 'CREATE' ).

        cl_abap_unit_assert=>fail(
          EXPORTING
            msg    =  'Unknown Business Object'
        ).

      CATCH cx_root ##CATCH_ALL.
    ENDTRY.

  ENDMETHOD.

  METHOD inject_message.
    CASE iv_case.
      WHEN '1'.
        TEST-INJECTION bo_message.
          DATA(lv_error) = 1 / 0.
        END-TEST-INJECTION.
      WHEN '2'.
        TEST-INJECTION act_message.
          lv_error = 1 / 0.
        END-TEST-INJECTION.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.
