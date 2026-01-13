*"* use this source file for your ABAP unit test classes
CLASS ltc_compare_records DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PUBLIC SECTION.
  PRIVATE SECTION.
*    DATA f_cut TYPE REF TO cl_ptf_util.

    METHODS single_records FOR TESTING.
    METHODS multiple_records FOR TESTING.
    METHODS multpl_records_deviating_attr FOR TESTING.
    METHODS multpl_records_deviating_posnr FOR TESTING.
    METHODS multpl_records_deviating_no FOR TESTING.

ENDCLASS.

CLASS ltc_compare_records IMPLEMENTATION.

  METHOD single_records.
    DATA(lo_cut) = NEW cl_ptf_compare_docs_generic( ).

    DATA(lt_vbrk_act) = VALUE vbrk_t( ( vbeln = '1234567890' vbtyp = 'C' ) ).
    DATA(lt_vbrk_exp) = VALUE vbrk_t( ( vbeln = '3336667787' vbtyp = 'C' ) ).

    lo_cut->compare_records(
      EXPORTING
        ir_act_tab = REF #( lt_vbrk_act )
        ir_exp_tab = REF #( lt_vbrk_exp )
        it_fields_to_ignore = VALUE #( ( 'VBELN' ) )
      IMPORTING
        et_finding = DATA(lt_finding)
    ).
    cl_abap_unit_assert=>assert_initial( lt_finding ).

  ENDMETHOD.

  METHOD multiple_records.
    DATA(lo_cut) = NEW cl_ptf_compare_docs_generic( ).

    DATA(lt_vbap_act) = VALUE vbap_t( ( vbeln = '1234567890' posnr = '000010' matnr = 'TG11') ( vbeln = '1234567890' posnr = '000020' matnr = 'TG12' ) ).
    DATA(lt_vbap_exp) = VALUE vbap_t( ( vbeln = '3336667787' posnr = '000010' matnr = 'TG11') ( vbeln = '3336667787' posnr = '000020' matnr = 'TG12' ) ).

    lo_cut->compare_records(
      EXPORTING
        ir_act_tab = REF #( lt_vbap_act )
        ir_exp_tab = REF #( lt_vbap_exp )
        it_fields_to_ignore = VALUE #( ( 'VBELN' ) )
      IMPORTING
        et_finding = DATA(lt_finding)
    ).
    cl_abap_unit_assert=>assert_initial( lt_finding ).

  ENDMETHOD.

  METHOD multpl_records_deviating_attr.
    DATA(lo_cut) = NEW cl_ptf_compare_docs_generic( ).

    DATA(lt_vbap_act) = VALUE vbap_t( ( vbeln = '1234567890' posnr = '000010' matnr = 'TG19') ( vbeln = '1234567890' posnr = '000020' matnr = 'TG12' ) ).
    DATA(lt_vbap_exp) = VALUE vbap_t( ( vbeln = '3336667787' posnr = '000010' matnr = 'TG11') ( vbeln = '3336667787' posnr = '000020' matnr = 'TG12' ) ).

    lo_cut->compare_records(
      EXPORTING
        ir_act_tab = REF #( lt_vbap_act )
        ir_exp_tab = REF #( lt_vbap_exp )
        it_fields_to_ignore = VALUE #( ( 'VBELN' ) )
      IMPORTING
        et_finding = DATA(lt_finding)
        es_info    = DATA(ls_info)
    ).
    cl_abap_unit_assert=>assert_not_initial( lt_finding ).

  ENDMETHOD.

  METHOD multpl_records_deviating_posnr.   "key field posnr is handled like any other field. it is compared. the method does not sort, assumes sorted input.
    DATA(lo_cut) = NEW cl_ptf_compare_docs_generic( ).

    DATA(lt_vbap_act) = VALUE vbap_t( ( vbeln = '1234567890' posnr = '000010' matnr = 'TG11') ( vbeln = '1234567890' posnr = '000020' matnr = 'TG12' ) ).
    DATA(lt_vbap_exp) = VALUE vbap_t( ( vbeln = '3336667787' posnr = '000020' matnr = 'TG11') ( vbeln = '3336667787' posnr = '000010' matnr = 'TG12' ) ).

    lo_cut->compare_records(
      EXPORTING
        ir_act_tab = REF #( lt_vbap_act )
        ir_exp_tab = REF #( lt_vbap_exp )
        it_fields_to_ignore = VALUE #( ( 'VBELN' ) )
      IMPORTING
        et_finding = DATA(lt_finding)
        es_info    = DATA(ls_info)
    ).
    cl_abap_unit_assert=>assert_not_initial( lt_finding ).

  ENDMETHOD.

  METHOD multpl_records_deviating_no.
    DATA(lo_cut) = NEW cl_ptf_compare_docs_generic( ).

    DATA(lt_vbap_act) = VALUE vbap_t( ( vbeln = '1234567890' posnr = '000010' matnr = 'TG11') ( vbeln = '1234567890' posnr = '000020' matnr = 'TG12' ) ).
    DATA(lt_vbap_exp) = VALUE vbap_t( ( vbeln = '3336667787' posnr = '000010' matnr = 'TG11')      ).

    lo_cut->compare_records(
      EXPORTING
        ir_act_tab = REF #( lt_vbap_act )
        ir_exp_tab = REF #( lt_vbap_exp )
        it_fields_to_ignore = VALUE #( ( 'VBELN' ) )
      IMPORTING
        et_finding = DATA(lt_finding)
        es_info    = DATA(ls_info)
    ).
    cl_abap_unit_assert=>assert_not_initial( lt_finding ).

  ENDMETHOD.

ENDCLASS.
