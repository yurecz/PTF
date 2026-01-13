CLASS tcl_ptf_rap_prodsarea_aunit DEFINITION
  PUBLIC
  INHERITING FROM tcl_ptf_test_class_super
  FINAL
  CREATE PUBLIC
  FOR TESTING
  DURATION LONG
  RISK LEVEL DANGEROUS .

  PUBLIC SECTION.
  PROTECTED SECTION.
private section.

  class-methods CLASS_SETUP .
  methods PRODSUPPAREA_815  for testing .
  methods Z_R_SALORD_ACTION_2PARAM."  for testing .
  methods Z_R_SALORD_CRE_AND_HD_ACTION."  for testing .
  methods Z_R_SALORD_LEV3_CREATE."  for testing .
ENDCLASS.



CLASS TCL_PTF_RAP_PRODSAREA_AUNIT IMPLEMENTATION.


  METHOD class_setup.
    IF sy-sysid NE 'ER9'.
      cl_abap_unit_assert=>abort(
*  quit   = 2                " Alter control flow/ quit test (METHOD, >>>CLASS<<<)
      ).
    ENDIF.
  ENDMETHOD.


  METHOD prodsupparea_815.

    _call_named_scripts( VALUE #(

       ( 'R_PRODUCTIONSUPPLYAREATP_CUD_J' )
       ( 'Z_R_PRODSUPPLYAR_CUD_REFSTEP' )
       ( 'Z_R_PRODSUP_CUD_REFSTEP_NO_JSN' )
       ( 'Z_R_SUPLLYAREA_DELETE_NODE' )
       ( 'Z_R_SUPLLYAREA_DELE_NODE' )
*       ( 'Z_R_SUPLLYAREA_DELE_NODE_NEG' ) "negative test shall fail
       ( 'Z_R_PRODSUPPLYAR_CUD_REFSTEP' )  "duplicate

     ) ).

  ENDMETHOD.


  METHOD z_r_salord_action_2param.

*    tcl_ptf_starter=>ptf_single_call( 'Z_R_SALORD_ACTION_2PARAM' ).


  ENDMETHOD.


  METHOD z_r_salord_cre_and_hd_action.

*    tcl_ptf_starter=>ptf_single_call( 'Z_R_SALORD_CRE_AND_HD_ACTION' ).


  ENDMETHOD.


  METHOD z_r_salord_lev3_create.

*    tcl_ptf_starter=>ptf_single_call( 'Z_R_SALORD_LEV3_CREATE' ).

  ENDMETHOD.
ENDCLASS.
