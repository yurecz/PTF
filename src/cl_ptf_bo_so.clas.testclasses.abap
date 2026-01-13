**"* use this source file for your ABAP unit test classes
*
*class ltcl_ptf_bo_so definition deferred.
*class cl_ptf_bo_so definition local friends ltcl_ptf_bo_so.
*class ltcl_ptf_bo_so definition final for testing
*  duration short
*  risk level harmless.
*  public section.
*  private section.
*
*    class-data:
*      go_cut type ref to cl_ptf_bo_so.
*
*    class-methods:
*      class_setup.
*    methods:
*      merge_goal_entity_test_data for testing raising cx_static_check.
*endclass.
*
*
*class ltcl_ptf_bo_so implementation.
*
*
*  method class_setup.
*    go_cut = new cl_ptf_bo_so( iv_run_environment = value #(  ) ).
*  endmethod.
*
*  method merge_goal_entity_test_data.
*    data:
*      ls_item_test_data type tds_goal_so_item,
*      ls_item_data      type tds_goal_so_item,
*      ls_changed_field  type if_goal_types=>tcs_changed_field.
*
*    " empty input data - no fields should be added
*    go_cut->merge_goal_entity_test_data(
*      exporting
*        is_entity_test_data   = ls_item_test_data
*        iv_add_changed_fields = ''
*      importing
*        es_changed_field      = ls_changed_field
*      changing
*        cs_entity_data        = ls_item_data
*    ).
*    cl_abap_unit_assert=>assert_initial( ls_changed_field-field ).
*
*    " setting data in a standard way:
*    ls_item_test_data-requested_qty = 2.
*    go_cut->merge_goal_entity_test_data(
*      exporting
*        is_entity_test_data   = ls_item_test_data
*        iv_add_changed_fields = ''
*      importing
*        es_changed_field      = ls_changed_field
*      changing
*        cs_entity_data        = ls_item_data
*    ).
*    cl_abap_unit_assert=>assert_equals( act = ls_changed_field-field
*                                        exp = value if_goal_types=>tct_fieldname_sorted( ( conv #( 'REQUESTED_QTY' ) ) ) ).
*    cl_abap_unit_assert=>assert_equals( act = ls_item_data-requested_qty exp = 2 ).
*
*    " clearing a field with an initial value.
*    clear ls_item_test_data-requested_qty.
*    ls_item_data-purchase_order_id = 'Test'.
*    go_cut->merge_goal_entity_test_data(
*      exporting
*        is_entity_test_data   = ls_item_test_data
*        iv_add_changed_fields = 'requested_qty purchase_order_id'
*      importing
*        es_changed_field      = ls_changed_field
*      changing
*        cs_entity_data        = ls_item_data
*    ).
*    cl_abap_unit_assert=>assert_equals( act = ls_changed_field-field
*                                        exp = value if_goal_types=>tct_fieldname_sorted( ( conv #( 'REQUESTED_QTY' ) ) ( conv #( 'PURCHASE_ORDER_ID' ) ) ) ).
*    cl_abap_unit_assert=>assert_initial( ls_item_data-requested_qty ).
*    cl_abap_unit_assert=>assert_initial( ls_item_data-purchase_order_id ).
*  endmethod.
*endclass.
