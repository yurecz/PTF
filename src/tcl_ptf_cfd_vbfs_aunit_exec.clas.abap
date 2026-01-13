CLASS tcl_ptf_cfd_vbfs_aunit_exec DEFINITION
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

    METHODS script__messg_simple
        FOR TESTING .
    METHODS script__std_create_messages
        FOR TESTING .
    METHODS check_ptf_script_existence
        FOR TESTING .
    METHODS chck_script_exstce_wo_assrt
        FOR TESTING .
ENDCLASS.



CLASS TCL_PTF_CFD_VBFS_AUNIT_EXEC IMPLEMENTATION.


  METHOD chck_script_exstce_wo_assrt.

    SELECT SINGLE varname FROM ptf_varid INTO @DATA(lv_dummy) WHERE varname = 'SDBIL_STD_CREATE_MESSAGES'.

    IF sy-subrc IS NOT INITIAL.
      cl_abap_unit_assert=>fail(
        level = if_abap_unit_constant=>severity-low "TOLERABLE !
        msg = 'PTF script SDBIL_STD_CREATE_MESSAGES not found' ).
    ENDIF.

  ENDMETHOD.


  METHOD check_ptf_script_existence.

    SELECT SINGLE varname FROM ptf_varid INTO @DATA(lv_dummy) WHERE varname = 'SDBIL_STD_CREATE_MESSAGES'.

    cl_abap_unit_assert=>assert_initial(
      act   = sy-subrc
      level = if_abap_unit_constant=>severity-low "TOLERABLE !
      msg   = 'PTF script SDBIL_STD_CREATE_MESSAGES not found' ).

  ENDMETHOD.


  METHOD script__messg_simple.

*    _call_named_scripts( VALUE #(
*       ( 'SDBIL_MESSG_SIMPLE' )
*      ) ).

  ENDMETHOD.


  METHOD script__std_create_messages.

*    _call_named_scripts( VALUE #(
*       ( 'SDBIL_STD_CREATE_MESSAGES' )
*      ) ).

  ENDMETHOD.
ENDCLASS.
