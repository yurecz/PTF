class TCL_PTF_CFD_ICO_AUNIT_EXEC_TMP definition
  public
  inheriting from TCL_PTF_TEST_CLASS_SUPER
  final
  create public
  for testing
  duration long
  risk level dangerous .

public section.
  PROTECTED SECTION.
private section.

  methods THREE_ICO_TESTS for testing.
ENDCLASS.



CLASS TCL_PTF_CFD_ICO_AUNIT_EXEC_TMP IMPLEMENTATION.


  METHOD THREE_ICO_TESTS.

*commented/inactivated in infinity, March 16

*    _call_named_scripts( VALUE #(
*
*( 'SDBIL_ADVC_ICO_DE_US_DLV_START' )
*( 'SDBIL_BD_ICO_W_ACC_RET_BTC' )
*( 'SDBIL_ICO_DE_US_DLV_START' )
*
*) ).

  ENDMETHOD.
ENDCLASS.
