*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lcl_ptf_def_act_prod_dao_impl DEFINITION CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES: lif_ptf_default_actions_dao.

    METHODS constructor
      IMPORTING iv_run_environment TYPE REF TO cl_ptf_run.


  PRIVATE SECTION.
    DATA mo_run_environment TYPE REF TO cl_ptf_run .
ENDCLASS.

CLASS lcl_ptf_def_act_prod_dao_impl IMPLEMENTATION.
  METHOD constructor.
    me->mo_run_environment = iv_run_environment.
  ENDMETHOD.


  METHOD lif_ptf_default_actions_dao~append_log.
    me->mo_run_environment->append_log( iv_log_statement = iv_log_statement ).
  ENDMETHOD.

  METHOD lif_ptf_default_actions_dao~append_log_structure.
    me->mo_run_environment->append_log_structure( is_log = is_log ).
  ENDMETHOD.

  METHOD lif_ptf_default_actions_dao~do_commitment.
    cl_ptf_util=>do_commitment( io_run_environment = io_run_environment ).
  ENDMETHOD.

  METHOD lif_ptf_default_actions_dao~ensure_posnr_filled.
    cl_ptf_util=>ensure_posnr_filled(
      EXPORTING
        iv_variant         =  iv_variant
        iv_run_environment =  iv_run_environment
      CHANGING
        is_data            = is_data
    ).
  ENDMETHOD.

  METHOD lif_ptf_default_actions_dao~get_keys_of_touch_doc_of_step.
    ptf_keys = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = iv_step_number ).
  ENDMETHOD.

  METHOD lif_ptf_default_actions_dao~get_step_data.
    step_data = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
  ENDMETHOD.

  METHOD lif_ptf_default_actions_dao~get_testdata.
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = is_step_data
      IMPORTING
        es_testdata  = es_testdata
    ).
  ENDMETHOD.

ENDCLASS.

CLASS lcl_ptf_def_act_test_dao_impl DEFINITION CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES: lif_ptf_default_actions_dao.

    DATA: test_data_to_return TYPE cl_ptf_bo_testability=>ty_gs_i_ptf_ebdr_cr_td.
    DATA: statements TYPE TABLE OF string.

ENDCLASS.

CLASS lcl_ptf_def_act_test_dao_impl IMPLEMENTATION.

  METHOD lif_ptf_default_actions_dao~append_log.
    APPEND iv_log_statement TO statements.
  ENDMETHOD.

  METHOD lif_ptf_default_actions_dao~append_log_structure.

  ENDMETHOD.

  METHOD lif_ptf_default_actions_dao~do_commitment.

  ENDMETHOD.

  METHOD lif_ptf_default_actions_dao~ensure_posnr_filled.

  ENDMETHOD.

  METHOD lif_ptf_default_actions_dao~get_keys_of_touch_doc_of_step.

  ENDMETHOD.

  METHOD lif_ptf_default_actions_dao~get_step_data.

  ENDMETHOD.

  METHOD lif_ptf_default_actions_dao~get_testdata.
    es_testdata = test_data_to_return.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_ptf_bo_api_prod_dao_impl DEFINITION CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES: lif_ptf_bo_api_dao.
ENDCLASS.

CLASS lcl_ptf_bo_api_prod_dao_impl IMPLEMENTATION.
  METHOD lif_ptf_bo_api_dao~bapi_ebdr_createmultiple.
    CALL FUNCTION 'BAPI_EBDR_CREATEMULTIPLE'
      EXPORTING
        testrun                    = testrun
        is_control_data            = is_control_data
        is_administration_data     = is_administration_data
        it_data                    = it_data
        it_condition_data          = it_condition_data
        it_text_data               = it_text_data
        it_payment_card_data       = it_payment_card_data
      IMPORTING
        et_ebdrcreateddoc          = et_ebdrcreateddoc
        et_ebdrcreateddocitem      = et_ebdrcreateddocitem
        et_ebdrcreatefaileddocitem = et_ebdrcreatefaileddocitem
        et_message                 = et_message
        return                     = return.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_ptf_bo_api_test_dao_impl DEFINITION CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES: lif_ptf_bo_api_dao.

    DATA: test_case TYPE i.
ENDCLASS.

CLASS lcl_ptf_bo_api_test_dao_impl IMPLEMENTATION.
  METHOD lif_ptf_bo_api_dao~bapi_ebdr_createmultiple.
    CASE test_case.
      WHEN 1.
        CALL FUNCTION 'BAPI_EBDR_CREATEMULTIPLE'
          EXPORTING
            testrun                    = testrun
            is_control_data            = is_control_data
            is_administration_data     = is_administration_data
            it_data                    = it_data
            it_condition_data          = it_condition_data
            it_text_data               = it_text_data
            it_payment_card_data       = it_payment_card_data
          IMPORTING
            et_ebdrcreateddoc          = et_ebdrcreateddoc
            et_ebdrcreateddocitem      = et_ebdrcreateddocitem
            et_ebdrcreatefaileddocitem = et_ebdrcreatefaileddocitem
            et_message                 = et_message
            return                     = return.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
