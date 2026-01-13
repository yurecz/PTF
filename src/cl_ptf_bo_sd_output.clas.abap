class CL_PTF_BO_SD_OUTPUT definition
  public
  inheriting from CL_PTF_BO
  final
  create public .

public section.

  types:
    ty_gt_order_items    TYPE STANDARD TABLE OF bapisditm .
  types:
    BEGIN OF ty_gs_field,
      name TYPE string,
    END OF ty_gs_field .
  types:
    ty_gt_field TYPE STANDARD TABLE OF ty_gs_field WITH DEFAULT KEY .
  types:
    BEGIN OF ty_gs_party,
      unconditional_take_over_fields TYPE  ty_gt_field.
      INCLUDE TYPE tds_goal_basic_party AS goal_data.
  TYPES:
    END OF ty_gs_party .
  types:
    ty_gt_party TYPE STANDARD TABLE OF ty_gs_party WITH DEFAULT KEY .
  types:
    BEGIN OF ty_gs_item,
      unconditional_take_over_fields TYPE ty_gt_field,
      delete_entry                   TYPE abap_bool,
      party_list                     TYPE ty_gt_party.
      INCLUDE TYPE tds_goal_so_item AS goal_data.
  TYPES:
    END OF ty_gs_item .
  types:
    ty_gt_item TYPE STANDARD TABLE OF ty_gs_item WITH DEFAULT KEY .
  types:
    BEGIN OF ty_gs_head,
      unconditional_take_over_fields TYPE ty_gt_field,
      party_list                     TYPE ty_gt_party.
      INCLUDE TYPE tds_goal_so_head AS goal_data.
  TYPES:
    END OF ty_gs_head .
  types:
    BEGIN OF ty_gs_i_ptf_so_cr_td,
      goal_bo_id TYPE tabname,
      head       TYPE ty_gs_head,
      item_list  TYPE ty_gt_item,
    END OF ty_gs_i_ptf_so_cr_td .

  constants GC_CREATE_SO_BY_GOAL type STRING value 'CREATE_SO_BY_GOAL' ##NO_TEXT.
  constants GC_CHANGE_SO type STRING value 'CHANGE_SO' ##NO_TEXT.
  constants GC_CHECK_OUTPUT_ITEMS type STRING value 'CHECK_OUTPUT_ITEMS' ##NO_TEXT.
  constants GC_CHECK_ORDER_CONF_CHANGE type STRING value 'CHECK_ORDER_CONF_CHANGE' ##NO_TEXT.
  constants GC_CHECK_DCD_GENERATED type STRING value 'CHECK_DCD_GENERATED' ##NO_TEXT.
  data GC_RELEASE_DCD type STRING value 'RELEASE_DCD' ##NO_TEXT.

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
protected section.
private section.

  methods CREATE_SO_BY_GOAL
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_OUTPUT_ITEMS
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB .
  methods CHANGE_SO
    importing
      !IV_STEP_NUMBER type I
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_ORDER_CONF_CHANGE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_CHECK_STATUS type ABAP_BOOL
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB .
  methods SET_SALESORDER_DATA
    importing
      !IO_GOAL_ACCESS type ref to IF_GOAL_ACCESS
    changing
      !CS_SALESORDER_TEST_DATA type TY_GS_I_PTF_SO_CR_TD .
  methods MERGE_GOAL_ENTITY_TEST_DATA
    importing
      !IS_ENTITY_TEST_DATA type DATA
    exporting
      !ES_CHANGED_FIELD type IF_GOAL_TYPES=>TCS_CHANGED_FIELD
    changing
      !CS_ENTITY_DATA type DATA .
  methods LOG_GOAL_MESSAGES
    exporting
      !IO_GOAL_ACCESS type ref to IF_GOAL_ACCESS
    returning
      value(RV_ERROR_OCCURED) type ABAP_BOOL .
  methods CHECK_DCD_GENERATED
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods RELEASE_DCD
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
ENDCLASS.



CLASS CL_PTF_BO_SD_OUTPUT IMPLEMENTATION.


  method CHANGE.

  endmethod.


  method CHANGE_SO.
    DATA: ls_change_data TYPE ty_gs_i_ptf_so_cr_td.

    ev_execution_status = abap_false.
    ev_execution_status = abap_true.
    data(lv_previous_step_data) = mo_run_environment->get_step_data( iv_step_number = step_data-reference_step[ 1 ] ).

    IF lv_previous_step_data-document_id IS INITIAL.
       mo_run_environment->append_log( iv_log_statement = |NO Referenced Document to change| ).
       RETURN.
    ENDIF.

    data(lv_vbeln) = lv_previous_step_data-document_id.
*----> get data from test container
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata( EXPORTING is_step_data = ls_step_data IMPORTING es_testdata = ls_change_data ).

*----> get GOAL instance and change
     DATA(lo_access) = cl_goal_api=>so_instance->open(
                iv_bo_id            = if_goal_sdoc=>co_bo_id-salesorder
                iv_bo_key           = lv_vbeln[ 1 ]-vbeln && ''
                iv_read_only        = abap_false
                is_control_settings = value if_goal_access=>tcs_control_settings( no_conversion = abap_true )
      ).
     set_salesorder_data(
              exporting
                io_goal_access          = lo_access
              changing
                cs_salesorder_test_data = ls_change_data ).
     lo_access->save( exporting iv_synchron = abap_true ).
     data(lv_error_occured) = log_goal_messages(
       importing
        io_goal_access = lo_access ).
     lo_access->close( ).
     if lv_error_occured = abap_true.
       RETURN.
     endif.

     ev_execution_status = abap_true.
     ev_execution_status = abap_true.
     ev_document_id = lv_vbeln.
  endmethod.


  method CHECK.
  endmethod.


  METHOD check_dcd_generated.
    DATA:iv_vbeln TYPE vbeln_va,
         lt_vbeln TYPE cl_ptf_util=>ty_vbeln_tab.
    CLEAR:lt_vbeln.
    DATA:iv_lifsp TYPE lifsp_ep,
         lv_msg   TYPE string.
    DATA: lo_dcd      TYPE REF TO cl_ukm_dcd_case,
          l_logsys    TYPE logsys,
          l_case_guid TYPE scmg_case_guid,
          l_objid     TYPE ukm_dcd_obj_id.
    data: l_flag type c.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    CALL FUNCTION 'OWN_LOGICAL_SYSTEM_GET'
      IMPORTING
        own_logical_system             = l_logsys
      EXCEPTIONS
        own_logical_system_not_defined = 1.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      EXIT.
    ENDIF.

    lo_dcd = cl_ukm_dcd_case=>get_instance( ).

    LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<ls_vbeln>).
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = <ls_vbeln>-vbeln
        IMPORTING
          output = <ls_vbeln>-vbeln.

       l_objid =  <ls_vbeln>-vbeln .
* get case guid
      CALL METHOD lo_dcd->get_current_dcd_4_obj
        EXPORTING
          iv_dcd_obj_type   = 'VBAK'
          iv_dcd_obj_id     = l_objid
          iv_dcd_obj_logsys = l_logsys
        IMPORTING
          ev_case_guid      = l_case_guid.

      if sy-subrc eq 0.
        l_flag = 'X'.
      else.
        CALL METHOD lo_dcd->get_current_dcd_4_obj
        EXPORTING
          iv_dcd_obj_type   = 'LIKP'
          iv_dcd_obj_id     = l_objid
          iv_dcd_obj_logsys = l_logsys
        IMPORTING
          ev_case_guid      = l_case_guid.

        IF sy-subrc eq 0.
          l_flag = 'X'.
        endif.
      endif.

      IF l_flag = 'X'.
        ev_check_status = abap_true.
        ev_execution_status = abap_true.      .
        APPEND l_case_guid TO ev_document_id.
        lv_msg =  |{ l_case_guid } DCD was Created Successfuly|.
        me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
      ELSE.
        lv_msg =  |{ l_case_guid } DCD Was not Created Successfuly |.
        me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
        ev_check_status = abap_false.
        ev_execution_status = abap_false.
      ENDIF.

    ENDLOOP.




  ENDMETHOD.


  method CHECK_EXISTENCE.
  endmethod.


 method CHECK_ORDER_CONF_CHANGE.
    DATA: lv_vbeln TYPE cl_ptf_util=>ty_vbeln_tab,
          iv_lifsp type lifsp_ep,
          lv_msg   type string.

    ev_execution_status = abap_false.
    ev_check_status     = abap_false.

    lv_vbeln = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = step_data-reference_step[ 1 ] ).
    IF lv_vbeln[ 1 ]-vbeln IS INITIAL.
      mo_run_environment->append_log( iv_log_statement = |NO Order Confirmation change Output item Created, please have a check | ).
      RETURN.
    ENDIF.
    DATA(lv_salesorder_id) = lv_vbeln[ 1 ]-vbeln.
    select single CMGST into @data(iv_CMGST) from vbak
                              where vbeln eq @lv_salesorder_id and cmgst eq 'D'.
    if sy-subrc <> 0.
        lv_msg =  |Sales Order : { lv_salesorder_id } Is Not Released|.
        me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
        RETURN.
    ENDIF.
    SELECT * FROM apoc_d_or_item WHERE appl_object_type = 'SALES_DOCUMENT' AND appl_object_id = @lv_salesorder_id INTO TABLE @DATA(lt_output_item).
    IF sy-subrc <> 0.
      me->mo_run_environment->append_log( iv_log_statement = |NO Output item exist for document { lv_vbeln[ 1 ]-vbeln }, please check OPD setting | ).
      RETURN.
    ENDIF.

    LOOP AT lt_output_item INTO DATA(lr_output_item).
      IF lr_output_item-output_type = 'ORDER_CONFIRMATION_CHANGE'.
        me->mo_run_environment->append_log( iv_log_statement = |Order Confirmation change Output item Created | ).
        ev_execution_status = abap_true.
        ev_check_status     = abap_true.
        return.
      ENDIF.
    ENDLOOP.

    me->mo_run_environment->append_log( iv_log_statement = |NO Order Confirmation change Output item Created, please have a check | ).

 endmethod.


  method CHECK_OUTPUT_ITEMS.
    DATA: lv_vbeln TYPE cl_ptf_util=>ty_vbeln_tab,
          iv_lifsp type lifsp_ep,
          lv_msg   type string.


    ev_execution_status = abap_false.
    ev_check_status     = abap_false.

    lv_vbeln = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = step_data-reference_step[ 1 ] ).

   DATA(ls_current_step) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    IF lv_vbeln[ 1 ]-vbeln IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No reference document exist | ).
      RETURN.
    ENDIF.
    DATA(lv_salesorder_id) = lv_vbeln[ 1 ]-vbeln.
    select single CMGST into @data(iv_CMGST) from vbak
                              where vbeln eq @lv_salesorder_id and cmgst eq 'B'.
    if sy-subrc <> 0.
        lv_msg =  |Sales Order : { lv_salesorder_id } Is Not Blocked for Credit Check|.
        me->mo_run_environment->append_log( iv_log_statement = lv_msg ).
        RETURN.
    ENDIF.
    SELECT * FROM apoc_d_or_item WHERE appl_object_type = 'SALES_DOCUMENT' AND appl_object_id = @lv_salesorder_id INTO TABLE @DATA(lt_output_item).
    IF sy-subrc <> 0.
      me->mo_run_environment->append_log( iv_log_statement = |NO Output item exist for document &lv_vbeln, please check OPD setting | ).
      RETURN.
    ENDIF.

    LOOP AT lt_output_item INTO DATA(lr_output_item).
      IF lr_output_item-output_type <> 'ORDER_CONFIRMATION'.
        me->mo_run_environment->append_log( iv_log_statement = |Output item is not correct for output type| ).
        return.
      ENDIF.
      IF lr_output_item-appl_object_id <> lv_salesorder_id.
        me->mo_run_environment->append_log( iv_log_statement = |Output item is not correct for sales order id| ).
        return.
      ENDIF.
      IF lr_output_item-sender_organization_id <> '1010'.
        me->mo_run_environment->append_log( iv_log_statement = |Output item is not correct for sender org| ).
        return.
      ENDIF.
    ENDLOOP.

    ev_execution_status = abap_true.
    ev_check_status     = abap_true.

  endmethod.


  method CREATE.

  endmethod.


  method CREATE_SO_BY_GOAL.
    DATA: lv_vbeln    TYPE vbeln_va,
          ls_testdata TYPE ty_gs_i_ptf_so_cr_td.

    SET UPDATE TASK LOCAL.

*======================================================
*  step1 get data from tdcv
*======================================================
    ev_execution_status = abap_false.
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).
    IF ls_testdata-goal_bo_id IS INITIAL.
      ls_testdata-goal_bo_id = if_goal_sdoc=>co_bo_id-salesorder.
    ENDIF.
    TRY.
        DATA(lo_access) = cl_goal_api=>so_instance->create(
          iv_bo_id            = ls_testdata-goal_bo_id
          is_control_settings = VALUE if_goal_access=>tcs_control_settings( no_conversion = abap_true )
          is_load_parameter   = VALUE cl_goal_salesorder=>tcs_load_parameter( type_code               = ls_testdata-head-type_code
                                                                              sales_organization_id   = ls_testdata-head-sales_organization_id
                                                                              distribution_channel_id = ls_testdata-head-distribution_channel_id
                                                                              division_id             = ls_testdata-head-division_id ) ).
      CATCH cx_goal_exc INTO DATA(lx_goal_exc).
        cl_message_helper=>set_msg_vars_for_if_t100_msg( lx_goal_exc ).
        me->mo_run_environment->append_log( iv_log_statement = |{ lx_goal_exc->get_text( ) }| ).
        EXIT.
    ENDTRY.

    set_salesorder_data(
      EXPORTING
        io_goal_access          = lo_access
      CHANGING
        cs_salesorder_test_data = ls_testdata ).

    lo_access->save( IMPORTING ev_bo_key = lv_vbeln ).

    DATA(lv_error_occured) = log_goal_messages(
      IMPORTING
        io_goal_access = lo_access ).
    IF lv_error_occured = abap_true.
      EXIT.
    ENDIF.

    lo_access->close(  ).

    APPEND VALUE #( vbeln = lv_vbeln ) TO ev_document_id.
    ev_execution_status = abap_true.

  endmethod.


  method DELETE.

  endmethod.


  METHOD execute_action.
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    CASE ls_step_data-action.
      WHEN gc_create_so_by_goal.
        me->create_so_by_goal(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
     WHEN gc_change_so.
        me->change_so(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
     WHEN gc_check_output_items.
        me->check_output_items(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
     WHEN gc_check_order_conf_change.
        me->check_order_conf_change(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.

    WHEN gc_check_dcd_generated.
        me->check_dcd_generated(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
    WHEN gc_RELEASE_DCD.
        me->RELEASE_DCD(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.

     WHEN OTHERS.
        me->mo_run_environment->append_log( iv_log_statement = |Could not find method { ls_step_data-action } for the BO { ls_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.
    ENDCASE.
  ENDMETHOD.


  METHOD execute_check.
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    CASE ls_step_data-action.
      WHEN gc_check_output_items.
        me->check_output_items(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN gc_check_order_conf_change.
        me->check_order_conf_change(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN gc_check_dcd_generated.
        me->check_dcd_generated(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.

      WHEN OTHERS.
        me->mo_run_environment->append_log( iv_log_statement = |Could not find method { ls_step_data-action } for the BO { ls_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.
    ENDCASE.
  ENDMETHOD.


  method log_goal_messages.
    rv_error_occured = abap_false.
    io_goal_access->get_messages(
      importing
        et_message = data(lt_message_save)
        es_error   = data(ls_error) ).

    loop at lt_message_save reference into data(lr_message).
      cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~add_actual_messages( it_messages = value #( ( id         = lr_message->msgid
                                                                                                        number     = lr_message->msgno
                                                                                                        type       = lr_message->msgty
                                                                                                        message_v1 = lr_message->msgv1
                                                                                                        message_v2 = lr_message->msgv2
                                                                                                        message_v3 = lr_message->msgv3
                                                                                                        message_v4 = lr_message->msgv4 ) ) ).
      me->mo_run_environment->append_log( iv_log_statement = |{ lr_message->msgtx }| ).
    endloop.

    if not ls_error is initial.
      cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~add_actual_messages( it_messages = value #( ( id         = ls_error-msgid
                                                                                                        number     = ls_error-msgno
                                                                                                        type       = ls_error-msgty
                                                                                                        message_v1 = ls_error-msgv1
                                                                                                        message_v2 = ls_error-msgv2
                                                                                                        message_v3 = ls_error-msgv3
                                                                                                        message_v4 = ls_error-msgv4 ) ) ).
      me->mo_run_environment->append_log( iv_log_statement = |{ ls_error-msgtx }| ).
      rv_error_occured = abap_true.
    endif.
  endmethod.


  METHOD merge_goal_entity_test_data.
    DATA:
      ls_entity_admin          TYPE tds_goal_entity_admin.
    CLEAR es_changed_field.

    " create a new handle if not yet provided
    ASSIGN COMPONENT 'handle' OF STRUCTURE cs_entity_data TO FIELD-SYMBOL(<fs_entity_data_handle>).
    CHECK sy-subrc = 0.
    MOVE-CORRESPONDING cs_entity_data TO ls_entity_admin.
    IF <fs_entity_data_handle> IS INITIAL.
      <fs_entity_data_handle> = cl_goal_util=>so_instance->create_guid( ).
    ENDIF.
    es_changed_field-handle = <fs_entity_data_handle>.

    " read component list of input entity structure
    DATA(lt_entity_component) =  CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_data( is_entity_test_data ) )->get_components( ).

    LOOP AT lt_entity_component ASSIGNING FIELD-SYMBOL(<fs_entity_component>).
      ASSIGN COMPONENT <fs_entity_component>-name OF STRUCTURE is_entity_test_data TO FIELD-SYMBOL(<fs_test_data>).
      CHECK sy-subrc = 0.
      IF <fs_test_data> IS NOT INITIAL.
        ASSIGN COMPONENT <fs_entity_component>-name OF STRUCTURE cs_entity_data TO FIELD-SYMBOL(<fs_entity_data>).
        CHECK sy-subrc = 0.
        IF <fs_entity_data> <> <fs_test_data> .
          <fs_entity_data> = <fs_test_data>.
          INSERT CONV #( <fs_entity_component>-name ) INTO TABLE es_changed_field-field.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD release_dcd.
    DATA: doc_ids              TYPE TABLE OF vbeln.
    DATA :  c_odata_uri TYPE string VALUE '/sap/opu/odata/sap/API_SLS_DOC_WITH_CREDIT_BLOCK/'.

    DATA: lt_parameters      TYPE /iwfnd/sutil_property_t,
          lv_status_code_txt TYPE string,
          lv_msg             TYPE string,
          lv_vbeln           TYPE vbeln,
          lv_url             TYPE string,
          lv_objkey          TYPE ptfkey.

    DATA: BEGIN OF ls_response,
            d TYPE string,
          END OF ls_response.
*--> 1 Step: Check and get created SO

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(ref_doc_ids) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      LOOP AT ref_doc_ids ASSIGNING FIELD-SYMBOL(<ref_doc_id>).
        APPEND <ref_doc_id> TO doc_ids.
      ENDLOOP.
    ENDLOOP.

*--> 2 Step: Check the pervious Step
    ev_execution_status = abap_false.
    DATA(lo_odata_caller) = cl_sdbil_odata_call=>get_instance( c_odata_uri ).
    IF doc_ids IS NOT INITIAL .
      READ TABLE doc_ids INTO     lv_vbeln  INDEX 1.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_vbeln
        IMPORTING
          output = lv_vbeln.
*      lt_parameters = VALUE #( ( name = 'SDDocumentCategory'        value =  'C'     )
*                              ( name = 'SalesDocument'    value =  lv_vbeln        )
*                           ).

      lv_url = c_odata_uri && |ReleaseCreditBlock?SDDocumentCategory='C'&SalesDocument='{ lv_vbeln }'|.
      lo_odata_caller->call_service(
      EXPORTING
        iv_method           = 'POST'
        iv_url              = lv_url
      IMPORTING
        ev_status_code      = DATA(lv_status_code)
        ev_status_text      = DATA(lv_status_text)
        es_json_response    = ls_response
        ev_body             = DATA(lv_body)
    ).

      lv_status_code_txt = lv_status_code.



      IF lv_status_code = 200.
        lv_msg = |Sales Order{ lv_vbeln } Is Released|.
        mo_run_environment->append_log( iv_log_statement = lv_msg ).
        APPEND lv_vbeln TO ev_document_id.
        ev_execution_status = abap_true.
      ELSE.
        ev_execution_status = abap_false.
        mo_run_environment->append_log( iv_log_statement = |Sales Order { lv_vbeln }Is not Released | ).
      ENDIF.


    ENDIF.
  ENDMETHOD.


  method SET_SALESORDER_DATA.
      DATA:ls_head_entity   TYPE tds_goal_so_head,
         lt_item_entity   TYPE STANDARD TABLE OF tds_goal_so_item,
         lr_item_entity   TYPE REF TO tds_goal_so_item,
         lt_party_entity  TYPE STANDARD TABLE OF tds_goal_basic_party,
         lr_party_entity  TYPE REF TO tds_goal_basic_party,
         ls_changed_field TYPE if_goal_types=>tcs_changed_field,
         lt_changed_field TYPE if_goal_types=>tct_changed_field.
*****************************************
* -> step 1 set header data
*****************************************
    io_goal_access->get_entity(
      EXPORTING
        iv_entity_id   = if_goal_sdoc_head=>co_entity_id
      IMPORTING
        es_entity_data = ls_head_entity ).
    merge_goal_entity_test_data(
      EXPORTING
        is_entity_test_data = cs_salesorder_test_data-head-goal_data
      IMPORTING
        es_changed_field    = ls_changed_field
      CHANGING
        cs_entity_data      = ls_head_entity
    ).

    " readonly fields:
    IF line_exists( ls_changed_field-field[ table_line = if_goal_sdoc_head=>co_field_name-type_code ] ).
      DELETE ls_changed_field-field WHERE table_line = if_goal_sdoc_head=>co_field_name-type_code.
    ENDIF.

    io_goal_access->set_entity(
      iv_entity_id     = if_goal_sdoc_head=>co_entity_id
      is_entity_data   = ls_head_entity
      is_changed_field = ls_changed_field ).

*****************************************
* -> step 2 set header partner data
*****************************************
    CLEAR lt_changed_field.
    io_goal_access->get_entity_set(
      EXPORTING
        iv_entity_id     = if_goal_basic_party=>co_entity_id-head_party
        iv_handle_parent = ls_head_entity-handle
      IMPORTING
        et_entity_data   = lt_party_entity
    ).
    LOOP AT cs_salesorder_test_data-head-party_list ASSIGNING FIELD-SYMBOL(<fs_head_party_test_data>).
      IF line_exists( lt_party_entity[ function_code = <fs_head_party_test_data>-function_code ] ).
        lr_party_entity = REF #( lt_party_entity[ function_code = <fs_head_party_test_data>-function_code ] ).
      ELSE.
        APPEND VALUE #( ) TO lt_party_entity REFERENCE INTO lr_party_entity.
      ENDIF.
      merge_goal_entity_test_data(
        EXPORTING
          is_entity_test_data = <fs_head_party_test_data>-goal_data
        IMPORTING
          es_changed_field    = ls_changed_field
        CHANGING
          cs_entity_data      = lr_party_entity->*
      ).
      INSERT ls_changed_field INTO TABLE lt_changed_field.
    ENDLOOP.
    io_goal_access->set_entity_set(
      EXPORTING
        iv_entity_id     = if_goal_basic_party=>co_entity_id-head_party
        iv_handle_parent = ls_head_entity-handle
        it_entity_data   = lt_party_entity
        it_changed_field = lt_changed_field
    ).
*****************************************
* -> step 3 set item data
*****************************************
    io_goal_access->get_entity_set(
      EXPORTING
        iv_entity_id   = if_goal_sdoc_item=>co_entity_id
      IMPORTING
        et_entity_data = lt_item_entity
    ).
    LOOP AT cs_salesorder_test_data-item_list ASSIGNING FIELD-SYMBOL(<fs_item_test_data>).
      IF line_exists( lt_item_entity[ item_id = <fs_item_test_data>-item_id ] ).
        lr_item_entity = REF #( lt_item_entity[ item_id = <fs_item_test_data>-item_id ] ).
      ELSE.
        DATA(ls_new_item_entity) = VALUE tds_goal_so_item( ).
        lr_item_entity = REF #( ls_new_item_entity ).
      ENDIF.
      IF <fs_item_test_data>-delete_entry = abap_true.
        io_goal_access->del_entity(
          EXPORTING
            iv_handle = lr_item_entity->handle
        ).
        CONTINUE.
      ENDIF.
      merge_goal_entity_test_data(
        EXPORTING
          is_entity_test_data = <fs_item_test_data>-goal_data
        IMPORTING
          es_changed_field    = ls_changed_field
        CHANGING
          cs_entity_data      = lr_item_entity->*
      ).
      io_goal_access->set_entity(
        EXPORTING
          iv_entity_id     = if_goal_sdoc_item=>co_entity_id
          is_entity_data   = lr_item_entity->*
          is_changed_field = ls_changed_field
      ).
*****************************************
* -> step 4 set item partner data
*****************************************
      CLEAR lt_changed_field.
      io_goal_access->get_entity_set(
        EXPORTING
          iv_entity_id     = if_goal_basic_party=>co_entity_id-item_party
          iv_handle_parent = lr_item_entity->handle
        IMPORTING
          et_entity_data   = lt_party_entity
      ).
      LOOP AT <fs_item_test_data>-party_list ASSIGNING FIELD-SYMBOL(<fs_item_party_test_data>).
        IF line_exists( lt_party_entity[ function_code = <fs_item_party_test_data>-function_code ] ).
          lr_party_entity = REF #( lt_party_entity[ function_code = <fs_item_party_test_data>-function_code ] ).
        ELSE.
          APPEND VALUE #( ) TO lt_party_entity REFERENCE INTO lr_party_entity.
        ENDIF.
        merge_goal_entity_test_data(
          EXPORTING
            is_entity_test_data = <fs_item_party_test_data>-goal_data
          IMPORTING
            es_changed_field    = ls_changed_field
          CHANGING
            cs_entity_data      = lr_party_entity->*
        ).
        APPEND ls_changed_field TO lt_changed_field.
      ENDLOOP.
      io_goal_access->set_entity_set(
        EXPORTING
          iv_entity_id     = if_goal_basic_party=>co_entity_id-item_party
          iv_handle_parent = lr_item_entity->handle
          it_entity_data   = lt_party_entity
          it_changed_field = lt_changed_field
      ).
    ENDLOOP.
  endmethod.
ENDCLASS.
