class TCL_PTF_EXAMPLES_AUNIT definition
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

  methods EXAMPLE__TAG_OUTPUT
  for testing .
  methods EXAMPLE__SCOPE_ITEM_1Z1
  for testing .
  methods EXAMPLE__TWO_NAMED_SCRIPTS
  for testing .
ENDCLASS.



CLASS TCL_PTF_EXAMPLES_AUNIT IMPLEMENTATION.


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
ENDCLASS.
