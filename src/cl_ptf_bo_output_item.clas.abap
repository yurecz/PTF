class CL_PTF_BO_OUTPUT_ITEM definition
  public
  inheriting from CL_PTF_BO
  final
  create public .

public section.

  types:
    BEGIN OF ty_proceed_output_item,
        output_channel TYPE string,
      END OF ty_proceed_output_item .
  types:
    BEGIN OF ty_create_output_item,
        status                      TYPE apoc_or_output_status,
        dispatch_time               TYPE apoc_or_dispatch_time,
        appl_object_type            TYPE apoc_appl_object_type,
        receiver_role               TYPE apoc_role_code,
        receiver_id                 TYPE apoc_receiver_id,
        output_channel              TYPE apoc_channel,
        form_template_country_code  TYPE apoc_form_template_country,
        form_template_language_code TYPE apoc_form_template_language,
        form_template_name          TYPE apoc_form_template_id,
        output_type                 TYPE apoc_output_type,
        sender_organization_id      TYPE sfm_v_org_type,
        sender_organization_type    TYPE sfm_v_org_type,
        sender_org_unit_type        TYPE sfm_v_org_type,
        sender_country_code         TYPE sfm_v_sender_country,
        print_queue_name            TYPE apoc_print_queue,
        sender_email_uri            TYPE apoc_email_address,
        email_template_id           TYPE apoc_email_template,
        email_subject               TYPE apoc_email_subject,
        email_uri                   TYPE apoc_email_address,
      END OF ty_create_output_item .
  types:
    BEGIN OF ty_check_status_output_item,
        status TYPE apoc_or_output_status,
      END OF ty_check_status_output_item .
  types:
    BEGIN OF ty_value_range,
           sign   TYPE tvarv_sign,
           option TYPE tvarv_opti,
           low    TYPE rvari_val_255,
           high   TYPE rvari_val_255,
         END OF ty_value_range .
  types:
    tt_value_range TYPE STANDARD TABLE OF ty_value_range WITH EMPTY KEY .
  types:
    BEGIN OF ty_job_parameter_value,
           name              TYPE apj_job_parameter_name,
           t_value           TYPE tt_value_range,
         END OF ty_job_parameter_value .
  types:
    tt_job_parameter_value TYPE STANDARD TABLE OF ty_job_parameter_value WITH NON-UNIQUE KEY name
          WITH NON-UNIQUE SORTED KEY name COMPONENTS name .

  constants C_PROCEED_ALL_ITEMS type STRING value 'PROCEED_ALL_ITEMS' ##NO_TEXT.
  constants C_ISSUE_OUTPUT type STRING value 'ISSUE_OUTPUT' ##NO_TEXT.
  constants C_CHECK_STATUS type STRING value 'CHECK_STATUS' ##NO_TEXT.
  constants C_EXECUTE_MASS_CHANGES type STRING value 'EXECUTE_MASS_CHANGES' ##NO_TEXT.

  methods PROCEED_ALL_ITEMS
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !ET_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_STATUS
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !ET_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods ISSUE_OUTPUT
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !ET_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods EXECUTE_MASS_CHANGES
    importing
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !ET_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .

  methods CHANGE
    redefinition .
  methods CHECK
    redefinition .
  methods CHECK_EXISTENCE
    redefinition .
  methods CREATE
    redefinition .
  methods DELETE
    redefinition .
  methods EXECUTE_ACTION
    redefinition .
  methods EXECUTE_CHECK
    redefinition .
  PROTECTED SECTION.
private section.

  methods SET_SCHEDULE_INFO
    returning
      value(SCHEDULE_INFO) type IF_APJ_RT_TYPES=>TY_JOB_SCHEDULE_INFO .
ENDCLASS.



CLASS CL_PTF_BO_OUTPUT_ITEM IMPLEMENTATION.


  METHOD change.
  ENDMETHOD.


  METHOD check.
  ENDMETHOD.


  METHOD check_existence.
  ENDMETHOD.


  METHOD check_status.

    "Checks if the status of a given output item matches with the status deposited in the test data container. -> Output Item key as reference step!
    DATA: lt_key_ids TYPE TABLE OF /bobf/conf_key,
          test_data  TYPE cl_ptf_bo_output_item=>ty_check_status_output_item.


    FIELD-SYMBOLS: <lt_data> TYPE ANY TABLE.

    "Get step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    "Get test data
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = test_data
    ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      APPEND LINES OF ptf_keys TO lt_key_ids.
    ENDLOOP.


    ev_check_status = abap_true.

    LOOP AT lt_key_ids ASSIGNING FIELD-SYMBOL(<key_id>).
      SELECT SINGLE status FROM apoc_d_or_item WHERE db_key = @<key_id> INTO @DATA(actual_status).
      IF actual_status NE test_data-status AND sy-subrc = 0.
        me->mo_run_environment->append_log( iv_log_statement = |Status of Output Item { <key_id> } isn't as expected. Expected: { test_data-status } Actual: { actual_status }| ).
        ev_check_status = abap_false.
      ELSEIF sy-subrc <> 0.
        me->mo_run_environment->append_log( iv_log_statement = | The referenced Output Item { <key_id> } coudn't be found on the database | ).
        ev_check_status = abap_false.
      ELSE.
        me->mo_run_environment->append_log( iv_log_statement = | Check for Output Item { <key_id> } successfully | ).
      ENDIF.
    ENDLOOP.

    ev_execution_status = abap_true.

  ENDMETHOD.


  METHOD create.
    "Creates an output item for a given document
    "Currently only Billing Documents are supported
    DATA: test_data              TYPE         ty_create_output_item,
          lt_doc_ids             TYPE TABLE OF vbeln,
          lo_or_srv_mgr          TYPE REF TO  /bobf/if_tra_service_manager,
          lo_transaction_manager TYPE REF TO /bobf/if_tra_transaction_mgr,
          lv_vbeln               TYPE vbrk-vbeln,
          ls_root_keys           TYPE if_apoc_or_h_api=>ty_gs_root_keys,
          lt_root_keys           TYPE if_apoc_or_h_api=>ty_gt_root_keys,
          lt_key                 TYPE /bobf/t_frw_key,
          ls_key                 LIKE LINE OF lt_key.

    "Get step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    "Get test data
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = test_data
    ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      APPEND LINES OF ptf_keys TO lt_doc_ids.
    ENDLOOP.

    ev_execution_status = abap_true.

    " Get Service Manager and transaction manager
    CALL FUNCTION 'RV_INVOICE_BOPF_OBJ_GET'
      IMPORTING
        eo_or_srv_mgr = lo_or_srv_mgr.   " Containing the public service methods of a service manager
    lo_transaction_manager = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).

    LOOP AT lt_doc_ids ASSIGNING FIELD-SYMBOL(<lv_doc_id>).

      lv_vbeln = <lv_doc_id>.
      CLEAR: ls_root_keys, lt_root_keys.
      ls_root_keys-appl_object_type = test_data-appl_object_type.
      ls_root_keys-appl_object_id   = lv_vbeln.
      INSERT ls_root_keys INTO TABLE lt_root_keys.

      DATA(lo_apoc_or_h_api) = cl_apoc_or_h_factory=>get_helper_factory( )->get_apoc_or_api( ).
      lo_apoc_or_h_api->retrieve_output_request(
        EXPORTING
          io_srv_mgr      = lo_or_srv_mgr
        CHANGING
          ct_or_root_keys = lt_root_keys  ).

      DATA(lv_root) = lt_root_keys[ 1 ]-key.

      "Create a reference of apoc_s_or_item and fill it with your data
      DATA lr_new_item TYPE REF TO apoc_s_or_item.
      CREATE DATA lr_new_item.

      DATA(lv_key) = /bobf/cl_frw_factory=>get_new_key( ).

      lr_new_item->channel = test_data-output_channel.
      lr_new_item->key = lv_key.
      lr_new_item->root_key = lv_root.
      lr_new_item->parent_key = lv_root.
      lr_new_item->appl_object_id = lv_vbeln.
      lr_new_item->appl_object_type = test_data-appl_object_type.
      lr_new_item->dispatch_time = test_data-dispatch_time.
      lr_new_item->form_template_name = test_data-form_template_name.
      lr_new_item->print_queue_name = test_data-print_queue_name.
      lr_new_item->form_template_country_code = test_data-form_template_country_code.
      lr_new_item->form_template_language_code = test_data-form_template_language_code.
      lr_new_item->output_type = test_data-output_type.
      lr_new_item->receiver_role = test_data-receiver_role.
      lr_new_item->receiver_id = test_data-receiver_id.
      lr_new_item->status = test_data-status.
      lr_new_item->sender_organization_id = test_data-sender_organization_id.
      lr_new_item->sender_organization_type = test_data-sender_organization_type.
      lr_new_item->sender_org_unit_type = test_data-sender_org_unit_type.
      lr_new_item->sender_country_code = test_data-sender_country_code.
      lr_new_item->sender_email_uri = test_data-sender_email_uri.
      lr_new_item->email_template_id = test_data-email_template_id.
      lr_new_item->email_subject = test_data-email_subject.

      "Create the modification table
      DATA lt_new_output_item TYPE /bobf/t_frw_modification.
      lt_new_output_item = VALUE #(
                          ( node = if_apoc_output_request_c=>sc_node-item
                            change_mode =  /bobf/if_frw_c=>sc_modify_create
                            association = if_apoc_output_request_c=>sc_association-root-item
                            key = lv_key
                            data = lr_new_item
                            source_key     =  lv_root
                            source_node    =  if_apoc_output_request_c=>sc_node-root
                            root_key       =  lv_root )
      ).

      TRY.
          lo_or_srv_mgr->modify(
            EXPORTING
              it_modification = lt_new_output_item
            IMPORTING
            eo_change       = DATA(changed_items)
            eo_message      = DATA(message_object_during_modify)
          ).
        CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract
          me->mo_run_environment->append_log( iv_log_statement = |Caller violates a BOPF contract.| ).
          ev_execution_status = abap_false.
      ENDTRY.

      IF test_data-output_channel = 'EMAIL'.
        "Create a reference of apoc_s_or_item_email and fill it with your data
        DATA lr_new_item_email TYPE REF TO apoc_s_or_item_email.
        CREATE DATA lr_new_item_email.
        DATA(lv_key_new) = /bobf/cl_frw_factory=>get_new_key( ).

        lr_new_item_email->email_uri = test_data-email_uri.
        lr_new_item_email->key = lv_key_new.
        lr_new_item_email->parent_key = lv_key.
        lr_new_item_email->root_key = lv_root.
        lr_new_item_email->appl_object_id = lv_vbeln.
        lr_new_item_email->appl_object_type = test_data-appl_object_type.
        lr_new_item_email->email_role = 'TO'.

        "Create the modification table
        DATA lt_new_output_item_email TYPE /bobf/t_frw_modification.
        lt_new_output_item_email = VALUE #(
                            ( node = if_apoc_output_request_c=>sc_node-item_email
                              change_mode =  /bobf/if_frw_c=>sc_modify_create
                              association = if_apoc_output_request_c=>sc_association-item-email_to
                              key = lv_key_new
                              data = lr_new_item_email
                              source_key     =  lv_key
                              source_node    =  if_apoc_output_request_c=>sc_node-item
                              root_key       =  lv_root )
        ).

        TRY.
            lo_or_srv_mgr->modify(
              EXPORTING
                it_modification = lt_new_output_item_email
              IMPORTING
              eo_change       = DATA(changed_items_email)
              eo_message      = DATA(message_during_modify_email)
            ).
          CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract
            me->mo_run_environment->append_log( iv_log_statement = |Caller violates a BOPF contract.| ).
            ev_execution_status = abap_false.
        ENDTRY.

      ENDIF.

      ls_key-key = lv_key.
      INSERT ls_key INTO TABLE lt_key.

      IF ev_execution_status = abap_true.
        APPEND lv_key TO ev_document_id.
      ENDIF.

    ENDLOOP.

    lo_transaction_manager->save(
     IMPORTING
      ev_rejected            = DATA(save_failed)
      eo_message             = DATA(messages_during_save)
    ).

    IF save_failed = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |messages_during_save| ).
      ev_execution_status = abap_false.
      CLEAR ev_document_id.
    ELSE.
      LOOP AT ev_document_id ASSIGNING FIELD-SYMBOL(<lv_key_id>).
        me->mo_run_environment->append_log( iv_log_statement = |Output Item with key { <lv_key_id>-vbeln } succesfully saved.| ).
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD delete.
  ENDMETHOD.


  METHOD execute_action.
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    CASE ls_step_data-action.
      WHEN c_proceed_all_items.
        me->proceed_all_items(
          EXPORTING
            is_step_data        = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            et_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_issue_output.
        me->issue_output(
          EXPORTING
            is_step_data        = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            et_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_execute_mass_changes.
        me->execute_mass_changes(
          EXPORTING
            is_step_data        = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            et_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN OTHERS.
        me->mo_run_environment->append_log( iv_log_statement =  |Could not find method { ls_step_data-action } for the BO { ls_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.
    ENDCASE.

  ENDMETHOD.


  METHOD execute_check.
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    CASE ls_step_data-action.
      WHEN c_check_status.
        me->check_status(
          EXPORTING
            is_step_data        = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            et_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN OTHERS.
        me->mo_run_environment->append_log( iv_log_statement =  |Could not find method { ls_step_data-action } for the BO { ls_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.
    ENDCASE.

  ENDMETHOD.


  METHOD execute_mass_changes.
    DATA: doc_ids        TYPE TABLE OF vbeln,
          vbeln          TYPE vbrk-vbeln,
          output_channel TYPE apoc_channel,
          test_data      TYPE tt_job_parameter_value,
          fm_subrc       TYPE sy-subrc,
          parameter      TYPE if_apj_rt_types=>ty_job_parameter_value,
          value_range    TYPE if_apj_rt_types=>ty_value_range.

* SO_VBELN  Billing Document
* SO_FKDAT  Billing Date
* SO_VKORG  Sales Organization
* SO_KUNAG  Sold-to Party
* P_REM_IT  Delete Determined Output Items
* P_DET_IT  Determine Output Items
* P_SEND    Trigger Output

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = is_step_data
      IMPORTING
        es_testdata  = test_data
    ).

    ev_execution_status = abap_true.

    LOOP AT is_step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      APPEND LINES OF ptf_keys TO doc_ids.
    ENDLOOP.

    LOOP AT doc_ids ASSIGNING FIELD-SYMBOL(<doc_id>).
      IF cl_ptf_sd_util=>is_a_billing_doc( document_number = <doc_id> ) EQ abap_true.
        value_range-sign = 'I'.
        value_range-option = 'EQ'.
        value_range-low = <doc_id>.
        APPEND value_range TO parameter-t_value.
      ELSE.
        me->mo_run_environment->append_log( iv_log_statement = |Currently your document { <doc_id> } is not supported for BO OUTPUT_ITEM.| ).
        ev_execution_status = abap_false.
      ENDIF.
    ENDLOOP.

    IF parameter-t_value IS NOT INITIAL.
      parameter-name = 'SO_VBELN'.
      APPEND parameter TO test_data.

      TRY.
          DATA(job_controller) = cl_apj_rt_job_controller=>get_instance( ).
          DATA(schedule_info) = me->set_schedule_info( ).
          DATA(job_info) = job_controller->execute( iv_job_catalog_entry_name          = 'BILLING_DOCUMENTS_OC_MASS_CHANGE'
                                                               iv_job_template_name      = 'BILLING_DOCUMENTS_OC_MASS_CHANGE'
                                                               iv_job_text               = 'Mass Change of Output for Billing Documents'
                                                               it_job_parameter_value    = test_data
                                                               is_schedule_info          = schedule_info ).
          me->mo_run_environment->append_log( iv_log_statement = |Created Output Schedule Job { job_info-job_name } with run count { job_info-job_run_count }| ).
          APPEND job_info-job_name TO et_document_id.
        CATCH cx_root INTO DATA(exp).
          me->mo_run_environment->append_log( iv_log_statement = |Error occured while creating schedule job: { exp->get_text( ) }| ).
          ev_execution_status = abap_false.
          RETURN.
      ENDTRY.
      COMMIT WORK.
      WAIT UP TO 180 SECONDS.
    ELSE.
      "In case no Billing Output Items were created as prerequesite we do want to prevent running this job for all existing Billing Output Items within the system.
      "Currently we see no use case for such a test.
      me->mo_run_environment->append_log( iv_log_statement = |No Billing Documents selected which can be processed!| ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.
  ENDMETHOD.


  METHOD issue_output.

    "Sends an given Output Item. -> Use case: Output Item in status 'In Preparation'. Output Item ke^y as reference step!
    DATA: lt_key                 TYPE /bobf/t_frw_key,
          lt_failed_keys         TYPE /bobf/t_frw_key,
          ls_key                 LIKE LINE OF lt_key,
          lt_key_ids             TYPE TABLE OF /bobf/conf_key,
          lo_or_srv_mgr          TYPE REF TO  /bobf/if_tra_service_manager,
          lo_transaction_manager TYPE REF TO /bobf/if_tra_transaction_mgr.

    "Get step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      APPEND LINES OF ptf_keys TO lt_key_ids.
    ENDLOOP.

    ev_execution_status = abap_true.

    LOOP AT lt_key_ids ASSIGNING FIELD-SYMBOL(<lv_key_id>).
      ls_key-key = <lv_key_id>.
      INSERT ls_key INTO TABLE lt_key.
    ENDLOOP.

    " Get Service Manager and transaction manager
    CALL FUNCTION 'RV_INVOICE_BOPF_OBJ_GET'
      IMPORTING
        eo_or_srv_mgr = lo_or_srv_mgr.   " Containing the public service methods of a service manager
    lo_transaction_manager = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).
    TRY.
        lo_or_srv_mgr->do_action(
          EXPORTING
            iv_act_key              =     '005056917F6C1EE49BDF69D12D5C10CE'             " Action
            it_key                  =      lt_key                                        " Key Table
*         is_parameters           =                                                     " Action
          IMPORTING
*         eo_change               =                  " Interface of Change Object
*         eo_message              =                  " Interface of Message Object
            et_failed_key           =         lt_failed_keys         " Key Table
*         et_failed_action_key    =                  " Key Table
*         ev_static_action_failed =
*         et_data                 =
*         et_data_link            =
        ).
      CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract
        me->mo_run_environment->append_log( iv_log_statement = |Caller violates a BOPF contract.| ).
        ev_execution_status = abap_false.
        CLEAR et_document_id.
    ENDTRY.

    IF NOT lt_failed_keys IS INITIAL.
      LOOP AT lt_failed_keys ASSIGNING FIELD-SYMBOL(<lv_failed_key>).
        me->mo_run_environment->append_log( iv_log_statement = |Issue Output failed for key: { <lv_failed_key>-key }| ).
        ev_execution_status = abap_false.
      ENDLOOP.
    ENDIF.
    lo_transaction_manager->save(
*  EXPORTING
*    iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue " Data element for a transaction pattern
*  IMPORTING
*    ev_rejected            =                                         " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
*    eo_change              =                                         " Interface for transaction change objects
*    eo_message             =                                         " Interface of Message Object
*    et_rejecting_bo_key    =                                         " Key table
    ).
    lo_transaction_manager->save(
       IMPORTING
        ev_rejected            = DATA(save_failed)
        eo_message             = DATA(messages_during_save)
      ).

    IF save_failed = abap_true.
      messages_during_save->get_messages(
*      EXPORTING
*        iv_severity             =                  " To select messages of a certain severity
*        iv_consistency_messages = abap_true        " If true, only messages of action validations are considered
*        iv_action_messages      = abap_true        " If true, only messages of action validations are considered
        IMPORTING
          et_message              = DATA(lt_messages)    " Table of msg instance that are contained in the msg object
      ).
      LOOP AT lt_messages ASSIGNING FIELD-SYMBOL(<ls_message>).
        me->mo_run_environment->append_log( iv_log_statement = | { <ls_message>-message->get_longtext( ) } | ).
      ENDLOOP.
      ev_execution_status = abap_false.
      CLEAR et_document_id.
    ELSE.
      LOOP AT lt_key ASSIGNING FIELD-SYMBOL(<lv_key_ids>).
        me->mo_run_environment->append_log( iv_log_statement = |Issue Output successful for key: { <lv_key_ids>-key }| ).
      ENDLOOP.
    ENDIF.

    COMMIT WORK AND WAIT.

  ENDMETHOD.


  METHOD proceed_all_items.
    DATA: doc_ids        TYPE TABLE OF vbeln,
          vbeln          TYPE vbrk-vbeln,
          output_channel TYPE apoc_channel,
          test_data      TYPE tt_job_parameter_value,
          fm_subrc       TYPE sy-subrc,
          parameter      TYPE if_apj_rt_types=>ty_job_parameter_value,
          value_range    TYPE if_apj_rt_types=>ty_value_range.

* SO_OT     Output Type
* SO_OC     Output Channel
* P_SORT    Sort Order
* P_FIRST   First Processing
* P_REPEAT  Repeat Processing
* P_ERROR   Error Processing
* SO_VBELN  Billing Document
* SO_FKDAT  Billing Date
* SO_VKORG  Sales Organization
* SO_VTWEG  Distribution Channel
* SO_SPART  Divison
* SO_KUNAG  Sold-to Party
* SO_KUNRG  Payer
* SO_LAND1  Destination Country/Region


    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = is_step_data
      IMPORTING
        es_testdata  = test_data
    ).

    ev_execution_status = abap_true.

    LOOP AT is_step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      APPEND LINES OF ptf_keys TO doc_ids.
    ENDLOOP.

    LOOP AT doc_ids ASSIGNING FIELD-SYMBOL(<doc_id>).
      IF cl_ptf_sd_util=>is_a_billing_doc( document_number = <doc_id> ) EQ abap_true.
        value_range-sign = 'I'.
        value_range-option = 'EQ'.
        value_range-low = <doc_id>.
        APPEND value_range TO parameter-t_value.
      ELSE.
        me->mo_run_environment->append_log( iv_log_statement = |Currently your document { <doc_id> } is not supported for BO OUTPUT_ITEM.| ).
        ev_execution_status = abap_false.
      ENDIF.
    ENDLOOP.

    IF parameter-t_value IS NOT INITIAL.
      parameter-name = 'SO_VBELN'.
      APPEND parameter TO test_data.

      TRY.
          DATA(job_controller) = cl_apj_rt_job_controller=>get_instance( ).
          DATA(schedule_info) = me->set_schedule_info( ).
          DATA(job_info) = job_controller->execute( iv_job_catalog_entry_name          = 'BILLING_DOCUMENTS_OUTPUT_RUN'
                                                             iv_job_template_name      = 'BILLING_DOCUMENTS_OUTPUT_RUN'
                                                             iv_job_text               = 'Schedule Billing Output'
                                                             it_job_parameter_value    = test_data
                                                             is_schedule_info          = schedule_info ).
          me->mo_run_environment->append_log( iv_log_statement = |Created Output Schedule Job { job_info-job_name } with run count { job_info-job_run_count }| ).
          APPEND job_info-job_name TO et_document_id.
        CATCH cx_root INTO DATA(exp).
          me->mo_run_environment->append_log( iv_log_statement = |Error occured while creating schedule job: { exp->get_text( ) }| ).
          ev_execution_status = abap_false.
          RETURN.
      ENDTRY.
      COMMIT WORK.
      WAIT UP TO 180 SECONDS.
    ELSE.
      "In case no Billing Output Items were created as prerequesite we do want to prevent running this job for all existing Billing Output Items within the system.
      "Currently we see no use case for such a test.
      me->mo_run_environment->append_log( iv_log_statement = |No Billing Documents selected which can be processed!| ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.
  ENDMETHOD.


  METHOD set_schedule_info.
    schedule_info-type                                 = 'I'.
    schedule_info-start_date_time                      = |{ sy-datlo }{ sy-uzeit }|.
    schedule_info-periodic_granularity                 = ''.
    schedule_info-periodic_value                       = 0.
    schedule_info-end_info-type                        = ''.
    schedule_info-end_info-date_time                   = |{ sy-datlo }{ sy-uzeit }|.
    schedule_info-end_info-max_iterations              = 10.
    schedule_info-test_mode                            = ''.
    schedule_info-job_exception-calender_id            = '01'.
    schedule_info-job_exception-start_restriction_code = ''.

    schedule_info-month_info-day                       = '0'.
    schedule_info-month_info-shift_direction           = '00'.
    schedule_info-month_info-week_number               = '00'.
    schedule_info-timezone                             = 'CET'.
  ENDMETHOD.
ENDCLASS.
