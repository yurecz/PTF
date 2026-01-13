CLASS tcl_ptf_rap_so_aunit DEFINITION
  PUBLIC
  INHERITING FROM tcl_ptf_test_class_super
  FINAL
  CREATE PUBLIC
  FOR TESTING
  DURATION LONG
  RISK LEVEL DANGEROUS .

  PUBLIC SECTION.
  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-METHODS: class_setup.

    METHODS example__two_named_scripts          FOR TESTING .

    METHODS so_001        FOR TESTING .

    METHODS z_r_salord_action_2param         FOR TESTING .
    METHODS z_r_salord_action_1param        FOR TESTING .
    METHODS z_r_salord_cre_and_hd_action        FOR TESTING .
    METHODS z_r_salord_lev3_create_sline        FOR TESTING .
    METHODS z_r_salord_lev3_create         FOR TESTING .
    METHODS z_r_sales_order_action FOR TESTING.

ENDCLASS.



CLASS TCL_PTF_RAP_SO_AUNIT IMPLEMENTATION.


  METHOD class_setup.
    IF sy-sysid NE 'ER9'.
      cl_abap_unit_assert=>abort(
*  quit   = 2                " Alter control flow/ quit test (METHOD, >>>CLASS<<<)
      ).
    ENDIF.
  ENDMETHOD.


  METHOD example__two_named_scripts.
*    _call_named_scripts( VALUE #( ( 'SFS_STD' ) ( 'CR_EBDR_ED01_EC01' ) ) ).
  ENDMETHOD.


  METHOD so_001.

    RETURN.

    _call_named_scripts( VALUE #( "( 'SFS_STD' ) ( 'CR_EBDR_ED01_EC01' )


       ( 'Z_R_SALORD_LEV3_CREATE_SLINE' )
       ( 'Z_R_SALORD_LEV3_CREATE' )

*       ( 'Z_R_SALES_ORDER_ACTION' ) "(fails)
       ( 'Z_R_SALORD_ACTION_1PARAM' )

       ( 'Z_R_SALORD_ACTION_2PARAM' )
       ( 'Z_R_SALORD_ACTION_DEEP IN WORK' )

       ( 'Z_R_SALORD_CRE_AND_HD_ACTION' )



  ) ).

  ENDMETHOD.


  METHOD z_r_sales_order_action.

    tcl_ptf_starter=>ptf_single_call( 'Z_R_SALES_ORDER_ACTION' ).


  ENDMETHOD.


  METHOD z_r_salord_action_1param.

    tcl_ptf_starter=>ptf_single_call( 'Z_R_SALORD_ACTION_1PARAM' ).


  ENDMETHOD.


  METHOD z_r_salord_action_2param.

    tcl_ptf_starter=>ptf_single_call( 'Z_R_SALORD_ACTION_2PARAM' ).


  ENDMETHOD.


  METHOD z_r_salord_cre_and_hd_action.

    tcl_ptf_starter=>ptf_single_call( 'Z_R_SALORD_CRE_AND_HD_ACTION' ).


  ENDMETHOD.


  METHOD z_r_salord_lev3_create.

    tcl_ptf_starter=>ptf_single_call( 'Z_R_SALORD_LEV3_CREATE' ).

  ENDMETHOD.


  METHOD z_r_salord_lev3_create_sline.

    tcl_ptf_starter=>ptf_single_call( 'Z_R_SALORD_LEV3_CREATE_SLINE' ).


  ENDMETHOD.
ENDCLASS.
