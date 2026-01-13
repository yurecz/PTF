*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section
INTERFACE lif_ptf_bo_api_dao.

  METHODS bapi_ebdr_createmultiple
    IMPORTING
      VALUE(testrun)                    TYPE  bapivbrktestrun-testrun DEFAULT ' '
      VALUE(is_control_data)            TYPE  bapiebdrrequestctrl OPTIONAL
      VALUE(is_administration_data)     TYPE  bapiebdrrequestadmin OPTIONAL
      VALUE(it_data)                    TYPE  bapiebdrrequest_t
      VALUE(it_condition_data)          TYPE  bapiebdrrequestcond_t OPTIONAL
      VALUE(it_text_data)               TYPE  bapiebdrrequesttext_t OPTIONAL
      VALUE(it_payment_card_data)       TYPE  bapivfpaymentcard_t OPTIONAL
    EXPORTING
      VALUE(et_ebdrcreateddoc)          TYPE  bapiebdrrequestextbilldocreq_t
      VALUE(et_ebdrcreateddocitem)      TYPE  bapiebdrrequestresult_t
      VALUE(et_ebdrcreatefaileddocitem) TYPE  bapiebdrrequestfailed_t
      VALUE(et_message)                 TYPE  bapiebdrrequestmsg_t
      VALUE(return)                     TYPE  bapiret2_t.

ENDINTERFACE.

INTERFACE lif_ptf_default_actions_dao.
  METHODS append_log
    IMPORTING iv_log_statement TYPE string.

  METHODS append_log_structure
    IMPORTING is_log TYPE bapiret2.

  METHODS get_keys_of_touch_doc_of_step
    IMPORTING iv_step_number  TYPE i
    RETURNING VALUE(ptf_keys) TYPE cl_ptf_util=>ty_vbeln_tab.

  METHODS get_step_data
    IMPORTING iv_step_number   TYPE i
    RETURNING VALUE(step_data) TYPE cl_ptf_util=>gt_ptf_step.

  METHODS do_commitment
    IMPORTING
      !io_run_environment TYPE REF TO cl_ptf_run .

  METHODS ensure_posnr_filled
    IMPORTING
      !iv_variant         TYPE ptf_tdcv
      !iv_run_environment TYPE REF TO cl_ptf_run
    CHANGING
      !is_data            TYPE cl_ptf_bo_dmr=>ty_gs_i_ptf_dmr_cr_td .

  METHODS get_testdata
    IMPORTING
      !is_step_data TYPE cl_ptf_util=>gt_ptf_step
    EXPORTING
      !es_testdata  TYPE any .

ENDINTERFACE.
