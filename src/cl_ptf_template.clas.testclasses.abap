CLASS ltcl_ptf_template DEFINITION DEFERRED.
CLASS cl_ptf_template DEFINITION LOCAL FRIENDS ltcl_ptf_template.

CLASS ltcl_ptf_template DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
.
  PRIVATE SECTION.

    METHODS: check_existence FOR TESTING.
    METHODS: compare_document_data FOR TESTING.
    METHODS: do_commitment FOR TESTING.
    METHODS: get_testdata FOR TESTING.
    METHODS: prestep_posnr FOR TESTING.
*    METHODS: get_system_field FOR TESTING.
    METHODS set_item_list
      IMPORTING
                iv_material_id     TYPE matnr
                iv_quantity        TYPE dzmeng
                iv_posnr           TYPE posnr_va
                iv_fkdat           TYPE string     OPTIONAL
                iv_werks           TYPE werks_d   OPTIONAL
      RETURNING VALUE(rt_itemlist) TYPE cl_ptf_sd_util=>ty_gt_item_list_td.
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
ENDCLASS.


CLASS ltcl_ptf_template IMPLEMENTATION.

  METHOD check_existence.
*
*    DATA: iv_vbeln     TYPE vbeln,
*          cs_step_data TYPE if_ptf_param_types=>gt_ptf_step,
*          ct_step_data TYPE if_ptf_param_types=>gt_ptf_step_tab,
*          ct_return    TYPE if_ptf_param_types=>gt_ptf_return_tab,
*          bo           TYPE REF TO cl_ptf_bo_dmr.
*
*    CREATE OBJECT bo.
*
*    cs_step_data-bus_obj = 'DMR'.
*    cs_step_data-action = 'CREATE'.
*    cs_step_data-tdcv = 'DMR_CR_I1_Q1'.
*    cs_step_data-var_step = 1.
*    APPEND cs_step_data TO ct_step_data.
*
*    bo->if_ptf_bo~create(
*      IMPORTING
*        et_return    = ct_return
*      CHANGING
*        cs_step_data = cs_step_data
*        ct_step_data = ct_step_data ).
*
*    READ TABLE ct_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data>) INDEX cs_step_data-var_step.
*    READ TABLE <ls_step_data>-vbeln_tab INTO iv_vbeln INDEX 1.
*
*    cl_ptf_template=>check_existence(
*      EXPORTING
*        iv_vbeln     = iv_vbeln
*      CHANGING
*        cs_step_data = cs_step_data
*        ct_step_data =  ct_step_data
*        ct_return    = ct_return ).
*
*    READ TABLE ct_step_data ASSIGNING <ls_step_data> INDEX cs_step_data-var_step.
*
*    cl_abap_unit_assert=>assert_equals(
*      act   = <ls_step_data>-step_success
*      exp   = abap_true   ).

  ENDMETHOD.




  METHOD compare_document_data.
*    DATA: iv_vbeln     TYPE vbeln,
*          cs_step_data TYPE if_ptf_param_types=>gt_ptf_step,
*          ct_step_data TYPE if_ptf_param_types=>gt_ptf_step_tab,
*          ct_return    TYPE if_ptf_param_types=>gt_ptf_return_tab,
*          bo           TYPE REF TO cl_ptf_bo_dmr.
*
*    CREATE OBJECT bo.
*
*    cs_step_data-bus_obj = 'DMR'.
*    cs_step_data-action = 'CREATE'.
*    cs_step_data-tdcv = 'DMR_CR_I2_Q1'.
*    cs_step_data-var_step = 1.
*    APPEND cs_step_data TO ct_step_data.
*
*    bo->if_ptf_bo~create(
*      IMPORTING
*        et_return    = ct_return
*      CHANGING
*        cs_step_data = cs_step_data
*        ct_step_data = ct_step_data ).
*
*    CLEAR cs_step_data.
*    cs_step_data-bus_obj = 'DMR'.
*    cs_step_data-action = 'CHECK'.
*    cs_step_data-tdcv = 'CHECK_CUSTOMER_MATERIAL'.
*    cs_step_data-var_step = 2.
*    APPEND 1 TO   cs_step_data-vo_bo.
*    APPEND cs_step_data TO ct_step_data.
*
*    CALL METHOD cl_ptf_template=>compare_document_data
*      EXPORTING
*        iv_table_name = 'VBAP'
*      CHANGING
*        et_return     = ct_return
*        ct_step_data  = ct_step_data
*        cs_step_data  = cs_step_data.
*
*    cl_abap_unit_assert=>assert_equals(
*      act   = cs_step_data-step_success
*      exp   = 'X'     ).
  ENDMETHOD.

  METHOD do_commitment.
*    DATA: ct_return TYPE if_ptf_param_types=>gt_ptf_return_tab,
*          lt_return TYPE if_ptf_param_types=>gt_ptf_return_tab,
*          ls_return TYPE bapiret2.
*
*    CALL METHOD cl_ptf_template=>do_commitment
*      EXPORTING
*        it_return = lt_return
*        is_return = ls_return
*      CHANGING
*        ct_return = ct_return.
*
*    CLEAR ls_return.
*    READ TABLE  ct_return INTO  ls_return INDEX 1.
*
*    cl_abap_unit_assert=>assert_equals(
*      act   = ls_return-message
*      exp   = ' '         ).
  ENDMETHOD.

  METHOD get_testdata.

*    DATA: ls_testdata  TYPE if_ptf_param_types=>ty_gs_i_ptf_dmr_cr_td,
*          cs_step_data TYPE if_ptf_param_types=>gt_ptf_step.
*
*    cs_step_data-bus_obj = 'DMR'.
*    cs_step_data-action = 'CREATE'.
*    cs_step_data-variant = 'DMR_CR_I1_Q1'.
*    cs_step_data-step_number  = 1.
*
*
*    CALL METHOD cl_ptf_template=>get_testdata
*      EXPORTING
*        is_step_data = cs_step_data
*      IMPORTING
*        es_testdata  = ls_testdata.
*
*    cl_abap_unit_assert=>assert_equals(
*      act   = ls_testdata-document_type
*      exp   = 'L2'        ).

  ENDMETHOD.

  METHOD prestep_posnr.

    DATA: ls_testdata   TYPE cl_ptf_bo_dmr=>ty_gs_i_ptf_dmr_cr_td,
          cs_step_data  TYPE cl_ptf_util=>gt_ptf_step,
          lt_return     TYPE cl_ptf_util=>gt_ptf_return_tab,
          item_list     TYPE cl_ptf_sd_util=>ty_gt_item_list_td,
          row_item_list TYPE cl_ptf_sd_util=>ty_gs_item_list_td.

    cs_step_data-bus_obj = 'DMR'.
    cs_step_data-action = 'CREATE'.
    cs_step_data-variant = 'DMR_CR_I1_Q1'.
    cs_step_data-step_number = 1.

    row_item_list-posnr = '000010'.
    APPEND row_item_list TO  ls_testdata-item_list.
    row_item_list-posnr = '000010'.
    APPEND row_item_list TO ls_testdata-item_list.

    CALL METHOD cl_ptf_template=>prestep_posnr
      EXPORTING
        is_step_data = cs_step_data
      CHANGING
        is_data      = ls_testdata
        ct_return    = lt_return.

    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.

    cl_abap_unit_assert=>assert_equals(
      act   = ls_return-message
      exp   = 'Duplicates in column PostionNumber are not allowed!The variant is:DMR_CR_I1_Q1' ).

  ENDMETHOD.

*  METHOD get_system_field.
*    DATA(lo_template) = NEW cl_ptf_template( ).
*    DATA: ls_testdata  TYPE if_ptf_param_types=>ty_gs_i_ptf_dmr_cr_td,
*          cs_step_data TYPE if_ptf_param_types=>gt_ptf_step.
*
*    DATA(lo_util) = new cl_ptf_util( ).
*
*
*    lo_util->get_syst_field(
*      EXPORTING
*        iv_field_name  = 'CDATP1'
*      IMPORTING
*        ev_field_value = DATA(lv_date)
*    ).
*
*
*    cl_abap_unit_assert=>assert_equals(
*      EXPORTING
*        act                  =  lv_date
*        exp                  =  sy-datlo + 1
*        msg                  =   'Wrong date retireved'
*    ).
*  ENDMETHOD.

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

  METHOD set_item_list.
    DATA ls_item_list TYPE cl_ptf_sd_util=>ty_gs_item_list_td.
    DATA lt_item_list TYPE cl_ptf_sd_util=>ty_gt_item_list_td.
    ls_item_list-material_id = iv_material_id.
    ls_item_list-posnr = iv_posnr.
    ls_item_list-quantity = iv_quantity.
    APPEND ls_item_list TO lt_item_list.

    rt_itemlist = lt_item_list.
  ENDMETHOD.

ENDCLASS.
