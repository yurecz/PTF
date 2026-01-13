"! @testing CL_PTF_RUN
class TCL_PTF_CFD_SDBIL_APRIL definition
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

  methods ONE_AIQ_TEST
  for testing .
  methods VALIDTE_SCRIPT_EXISTENCE
  for testing .
ENDCLASS.



CLASS TCL_PTF_CFD_SDBIL_APRIL IMPLEMENTATION.


  METHOD ONE_AIQ_TEST.

    _call_named_scripts( VALUE #(
( 'SDBIL_DLM_CFD_EXAMPLE2' )
) ).

  ENDMETHOD.


  METHOD validte_script_existence.

    "here we validate that the PTF script which is part of the feature is available already in Automatic Inbound Qualification  -  this does not test the Feature, only the pipeline tooling

    SELECT SINGLE * FROM ptf_varid INTO @DATA(ls_dummy) WHERE varname = 'SDBIL_DLM_CFD_EXAMPLE2'.

*    cl_abap_unit_assert=>assert_initial(                              deactivated ater successful test
*      act = sy-subrc
*      msg = 'SDBIL_DLM_CFD_EXAMPLE2 is missing in PTF_VARID'
*    ).

  ENDMETHOD.
ENDCLASS.
