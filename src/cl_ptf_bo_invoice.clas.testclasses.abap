**"* use this source file for your ABAP unit test classes
*CLASS lth_tdc_variant DEFINITION CREATE PRIVATE FOR TESTING.
*
*
*  PUBLIC SECTION.
*    " Types
*    TYPES: typ_input_ptf_create TYPE cl_ptf_bo_invoice=>ty_gs_input_ptf_create_td.
*    TYPES: tt_variant           TYPE STANDARD TABLE OF REF TO lth_tdc_variant WITH DEFAULT KEY.
*    TYPES: typ_variant TYPE REF TO lth_tdc_variant.
*
*
*    CLASS-METHODS:
*      s_get_variant
*        IMPORTING
*          iv_tdc_name       TYPE etobj_name
*          iv_var_name       TYPE etvar_id
*        RETURNING
*          VALUE(rv_variant) TYPE typ_variant
*        RAISING
*          cx_ecatt_tdc_access.
*
*    METHODS:
*      get_input_ptf_create_invoice
*        RETURNING
*          VALUE(rv_input_ptf_create_inv) TYPE typ_input_ptf_create.
*
*    METHODS:
*      get_input_ptf_dmr_create
*        RETURNING
*          VALUE(rv_input_ptf_create) TYPE cl_ptf_bo_dmr=>ty_gs_input_ptf_create_td.
*
*    METHODS:
*      get_input_ptf_dmr_change
*        RETURNING
*          VALUE(rv_input_ptf_create) TYPE cl_ptf_bo_dmr=>ty_gs_input_ptf_create_td.
*
*
*  PRIVATE SECTION.
*    CLASS-DATA:
*      so_tdc_api TYPE REF TO cl_apl_ecatt_tdc_api.
*
*    DATA:
*      mv_name TYPE etvar_id.
*
*
*    METHODS:
*      init
*        IMPORTING
*          iv_name TYPE csequence.
*
*
*ENDCLASS.
*
*CLASS lth_tdc_variant IMPLEMENTATION.
*  METHOD s_get_variant.
*    DATA:
*      lt_variant TYPE etvar_name_tabtype,
*      lv_variant LIKE LINE OF lt_variant,
*      lo_variant TYPE REF TO lth_tdc_variant.
*
*    so_tdc_api = cl_apl_ecatt_tdc_api=>get_instance( iv_tdc_name ).
*    lt_variant = so_tdc_api->get_variant_list( ).
*
*    READ TABLE lt_variant INTO lv_variant
*         WITH KEY table_line = iv_var_name.
*    IF sy-subrc = 0.
*      CREATE OBJECT rv_variant.
*      rv_variant->init( iv_name = lv_variant ).
*    ENDIF.
*
*  ENDMETHOD.
*
*  METHOD init.
*    mv_name = iv_name.
*  ENDMETHOD.
*
*
*  METHOD get_input_ptf_create_invoice.
*    TRY.
*        so_tdc_api->get_value(
*          EXPORTING
*            i_param_name = 'I_PTF_DMR_CR'
*            i_variant_name = me->mv_name
*          CHANGING
*            e_param_value = rv_input_ptf_create_inv ).
*
*      CATCH cx_ecatt_tdc_access.
*        cl_aunit_assert=>fail(
*          msg = 'Error reading test data for I_PTF_DMR_CR' ).
*
*    ENDTRY.
*  ENDMETHOD.
*
*  METHOD get_input_ptf_dmr_create.
*    TRY.
*        so_tdc_api->get_value(
*          EXPORTING
*            i_param_name = 'I_PTF_DMR_CR'
*            i_variant_name = me->mv_name
*          CHANGING
*            e_param_value = rv_input_ptf_create ).
*
*      CATCH cx_ecatt_tdc_access.
*        cl_aunit_assert=>fail(
*          msg = 'Error reading test data for I_PTF_DMR_CR' ).
*
*    ENDTRY.
*  ENDMETHOD.
*
*  METHOD get_input_ptf_dmr_change.
*    TRY.
*        so_tdc_api->get_value(
*          EXPORTING
*            i_param_name = 'I_PTF_DMR_CH'
*            i_variant_name = me->mv_name
*          CHANGING
*            e_param_value = rv_input_ptf_create ).
*
*      CATCH cx_ecatt_tdc_access.
*        cl_aunit_assert=>fail(
*          msg = 'Error reading test data for I_PTF_DMR_CR' ).
*
*    ENDTRY.
*  ENDMETHOD.
*
*ENDCLASS.
*
*
*CLASS ltcl_ptf_bo_invoice DEFINITION FOR TESTING
*  DURATION SHORT
*  RISK LEVEL HARMLESS
*  FINAL.
*  PUBLIC SECTION.
*
*    METHODS create_invoice FOR TESTING.
*
*  PRIVATE SECTION.
*
*    CONSTANTS c_tdc_ptf TYPE etobj_name VALUE 'ZTDC_PTF'.
*    CONSTANTS c_var_ptf TYPE etvar_id   VALUE 'DMR_CR_I2_Q1'.
*    CONSTANTS c_var_inv TYPE etvar_id   VALUE '0000000'.
*    CONSTANTS c_var_ptf_ch     TYPE etvar_id    VALUE 'DMR_CH_P2_Q5'.
*ENDCLASS.
*
*
*
*CLASS ltcl_ptf_bo_invoice IMPLEMENTATION.
*
*
*  METHOD create_invoice.
*
*    TYPES:
*      BEGIN OF gty_vbeln_rfbsk,
*        vbeln TYPE  vbeln,
*        rfbsk TYPE rfbsk,
*      END OF gty_vbeln_rfbsk .
*
*    DATA: bool_success       TYPE abap_bool,
*          lt_document_number TYPE tt_vbeln,
*          ls_data            TYPE cl_ptf_bo_invoice=>ty_gs_input_ptf_create_td,
*          lt_inv_comp        TYPE TABLE OF    gty_vbeln_rfbsk,
*          ls_inv_comp        TYPE gty_vbeln_rfbsk.
****************************************************************************************************
**DMR Create
*    TRY.
*        DATA(lo_variant_dmr_cr) = lth_tdc_variant=>s_get_variant( EXPORTING  iv_tdc_name = c_tdc_ptf  iv_var_name = c_var_ptf ).
*      CATCH cx_ecatt_tdc_access.
*    ENDTRY.
*    IF lo_variant_dmr_cr IS BOUND.
*      DATA(ls_ptf_create_dmr) = lo_variant_dmr_cr->get_input_ptf_dmr_create( ).
*    ENDIF.
*
*    DATA(lo_dmr) = NEW cl_ptf_bo_dmr( ).
*    lo_dmr->create(
*      EXPORTING
*               is_testdata     = ls_ptf_create_dmr
*               iv_tdc_variant  = c_var_ptf
*     IMPORTING
*               ev_order_number = DATA(ev_order_number)
*               ev_test_success = bool_success
*               ev_result_data  = DATA(ptf_test_result) ).
*    APPEND ev_order_number TO lt_document_number.
****************************************************************************************************
***DMR Change
**    TRY.
**        DATA(lo_variant_dmr_ch) = lth_tdc_variant=>s_get_variant( EXPORTING  iv_tdc_name = c_tdc_ptf   iv_var_name = c_var_ptf_ch ).
**      CATCH cx_ecatt_tdc_access.
**    ENDTRY.
**    IF lo_variant_dmr_ch IS BOUND.
**      DATA(ls_ptf_change_dmr) = lo_variant_dmr_ch->get_input_ptf_dmr_change( ).
**    ENDIF.
**
**    lo_dmr->change_quantity(
**      EXPORTING
**        iv_order_number = ev_order_number
**        iv_chance_tdc   = ls_ptf_change_dmr ).
****************************************************************************************************
**Invoice Create
*    DATA(lo_invoice) = NEW cl_ptf_bo_invoice( ).
*    lo_invoice->create(
*      EXPORTING
*        it_document_number         = lt_document_number
**       iv_document_category       =
*      IMPORTING
*        et_billing_document_number = DATA(lt_billing_doc_number)
*        et_return                  = DATA(lt_return)
*      RECEIVING
*        rb_continue                = bool_success ).
****************************************************************************************************
**Check
*    SELECT SINGLE vbeln FROM vbfa INTO @DATA(bill_doc_vbeln) WHERE vbelv = @ev_order_number.
*    SELECT SINGLE rfbsk FROM vbrk INTO @DATA(bill_status) WHERE vbeln = @bill_doc_vbeln.
*
*    ls_inv_comp-vbeln = bill_doc_vbeln.
*    ls_inv_comp-rfbsk = bill_status.
*    APPEND ls_inv_comp TO lt_inv_comp.
*
*    cl_abap_unit_assert=>assert_equals(
*                         act   = lt_billing_doc_number  " -price
*                         exp   = lt_inv_comp
*                         msg   = 'Error in Create Method for Invoice: Test data container:_' &&  c_tdc_ptf  && '_Variant: _' &&  c_var_ptf ).
*
*    " Preis abfragen, vorgefertiogte Variante abfragen.....
*
***********************************************************************************************************************************************************************
*
*
*  ENDMETHOD.
*
*ENDCLASS.
