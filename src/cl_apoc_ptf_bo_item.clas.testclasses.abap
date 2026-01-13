CLASS lcl_/bobf/cm_frw_mock DEFINITION CREATE PUBLIC INHERITING FROM /bobf/cm_frw.

  PUBLIC SECTION.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_/bobf/cm_frw_mock IMPLEMENTATION.

ENDCLASS.

CLASS lcl_bobf_change_mock DEFINITION CREATE PUBLIC FOR TESTING.

  PUBLIC SECTION.
    INTERFACES:  /bobf/if_tra_change  PARTIALLY IMPLEMENTED.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: m_bo_keys  TYPE STANDARD TABLE OF /bobf/obm_bo_key.


ENDCLASS.

CLASS lcl_bobf_change_mock IMPLEMENTATION.

  METHOD /bobf/if_tra_change~add.
    INSERT iv_bo_key INTO TABLE m_bo_keys.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_bobf_change_frw_mock DEFINITION CREATE PUBLIC FOR TESTING.

  PUBLIC SECTION.
    INTERFACES:  /bobf/if_frw_change  PARTIALLY IMPLEMENTED.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: mt_message  TYPE /bobf/t_frw_message_k.


ENDCLASS.

CLASS lcl_bobf_change_frw_mock IMPLEMENTATION.

ENDCLASS.

CLASS lcl_bobf_message_class_mock DEFINITION CREATE PUBLIC FOR TESTING.

  PUBLIC SECTION.
    INTERFACES:  /bobf/if_frw_message PARTIALLY IMPLEMENTED.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: mt_message  TYPE /bobf/t_frw_message_k.


ENDCLASS.

CLASS lcl_bobf_message_class_mock IMPLEMENTATION.
  METHOD /bobf/if_frw_message~add_message.
    DATA: message  TYPE /bobf/s_frw_message_k.

    DATA(bobf_msg_object) = NEW lcl_/bobf/cm_frw_mock( ).
    message-message = bobf_msg_object.

    message-message->if_t100_message~t100key-msgid = is_msg-msgid.
    message-message->if_t100_message~t100key-msgno = is_msg-msgno.
    message-message->if_t100_message~t100key-attr1 = CONV #( is_msg-msgv1 ).  "this does not make any sense semantically, but it is a LTC...
    message-severity = is_msg-msgty.

    INSERT message INTO TABLE mt_message.

  ENDMETHOD.

  METHOD /bobf/if_frw_message~get_messages.
    et_message  = mt_message.
  ENDMETHOD.
ENDCLASS.


CLASS lcl_bobf_service_manager_mock DEFINITION CREATE PUBLIC FOR TESTING.

  PUBLIC SECTION.
    INTERFACES: /bobf/if_tra_service_manager PARTIALLY IMPLEMENTED.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_bobf_service_manager_mock IMPLEMENTATION.

  METHOD /bobf/if_tra_service_manager~retrieve.
    DATA:
      failed_key TYPE /bobf/s_frw_key,
      item_table TYPE apoc_t_or_item.

    LOOP AT it_key ASSIGNING FIELD-SYMBOL(<fs_key>).
      DATA message TYPE symsg.
      CASE <fs_key>-key.
        WHEN '0001'.

        WHEN '0002'.
          item_table = VALUE #(
                        (
                        key = '0002'
                        appl_object_id = 'Valid Object'
                        item_id = '1' )
                        ).
          et_data = item_table.
          eo_message = NEW lcl_bobf_message_class_mock( ).
          message-msgid = 'DUMMY'.
          message-msgno = '1'.
          message-msgty = 'E'.
          message-msgv1 = 'Valid Object'.
          eo_message->add_message(
            EXPORTING
              is_msg       = message
          ).

        WHEN '0003'.
          item_table = VALUE #(
                        (
                        key = '0003'
                        appl_object_id = 'Valid Object'
                        item_id = '1'
                        channel = 'PRINT' )
                        ).
          et_data = item_table.
        WHEN '0004'.
          item_table = VALUE #(
                (
                key = '0004'
                appl_object_id = 'Valid Object'
                item_id = '1'
                channel = 'PRINT' )
                ).
          et_data = item_table.
        WHEN OTHERS.
          INSERT <fs_key> INTO TABLE et_failed_key.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.

  METHOD /bobf/if_tra_service_manager~modify.
    LOOP AT it_modification ASSIGNING  FIELD-SYMBOL(<modification_entry>).
      DATA message TYPE symsg.
      CASE <modification_entry>-key.

        WHEN  '0003'.
          eo_message = NEW lcl_bobf_message_class_mock( ).
          message-msgid = 'DUMMY'.
          message-msgno = '1'.
          message-msgty = 'E'.
          message-msgv1 = 'Valid Object'.
          eo_message->add_message(
            EXPORTING
              is_msg       = message
          ).
          eo_change = NEW lcl_bobf_change_mock( ).
          eo_change->add(
            EXPORTING
              iv_bo_key = <modification_entry>-key
              io_change = NEW lcl_bobf_change_frw_mock( )
          ).
        WHEN '0004'.
          eo_message = NEW lcl_bobf_message_class_mock( ).
          eo_change = NEW lcl_bobf_change_mock( ).
          eo_change->add(
            EXPORTING
              iv_bo_key = <modification_entry>-key
              io_change = NEW lcl_bobf_change_frw_mock( )
          ).
        WHEN OTHERS.

      ENDCASE.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_bobf_transaction_mgr_mock DEFINITION CREATE PUBLIC FOR TESTING.

  PUBLIC SECTION.
    INTERFACES: /bobf/if_tra_transaction_mgr PARTIALLY IMPLEMENTED.
    METHODS simulate_failed_save.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: m_fail_save TYPE abap_bool.
ENDCLASS.

CLASS lcl_bobf_transaction_mgr_mock IMPLEMENTATION.

  METHOD simulate_failed_save.
    m_fail_save = abap_true.
  ENDMETHOD.

  METHOD /bobf/if_tra_transaction_mgr~save.
    IF m_fail_save = abap_true.
      ev_rejected = 'X'.
      eo_message = NEW lcl_bobf_message_class_mock( ).

    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS ltcl_apoc_ptf_bo_item_modifier DEFINITION DEFERRED.
CLASS cl_apoc_ptf_bo_item DEFINITION LOCAL FRIENDS ltcl_apoc_ptf_bo_item_modifier.
CLASS ltcl_apoc_ptf_bo_item_modifier DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA:
      cut                    TYPE REF TO cl_apoc_ptf_bo_item,
      m_transaction_mgr_mock TYPE REF TO lcl_bobf_transaction_mgr_mock.

    CLASS-METHODS:
      class_setup,
      class_teardown.

    CLASS-DATA:
      g_environment            TYPE REF TO if_osql_test_environment.

    METHODS:

      setup,
      "! check if false import parameter is recognized
      "! @raising cx_static_check | unit test exception
      invalid_import_parameter FOR TESTING RAISING cx_static_check,
      valid_import_parameter   FOR TESTING RAISING cx_static_check,
      item_does_not_exist      FOR TESTING RAISING cx_static_check,
      bobf_returns_nothing      FOR TESTING RAISING cx_static_check,
      bobf_cant_find_key FOR TESTING RAISING cx_static_check,
      bobf_retrieve_works FOR TESTING RAISING cx_static_check,
      change_channel_to_email FOR TESTING RAISING cx_static_check,
      bobf_save_fails FOR TESTING RAISING cx_static_check.
*      avb      FOR TESTING RAISING cx_static_check.

ENDCLASS.

CLASS ltcl_apoc_ptf_bo_item_modifier IMPLEMENTATION.
  METHOD class_setup.
    g_environment = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'APOC_D_OR_ITEM' ) ) ).
  ENDMETHOD.

  METHOD class_teardown.
    g_environment->destroy( ).
  ENDMETHOD.

  METHOD setup.
    cut = NEW #( ).
    cut->m_service_manager = NEW lcl_bobf_service_manager_mock( ).
    m_transaction_mgr_mock = NEW lcl_bobf_transaction_mgr_mock( ).
    cut->m_transaction_manager = m_transaction_mgr_mock.
    g_environment->clear_doubles( ).
  ENDMETHOD.

  METHOD invalid_import_parameter.
    TRY.
        cut->modify_item_attribute(
          EXPORTING
            i_attribute_name = 'Invalid Import Parameter'
            i_value     = '123'
            i_item_key = '12345'
        ).
      CATCH  cx_apoc_invalid_attribute_name  INTO DATA(exception).
    ENDTRY.

    DATA exception_was_returned TYPE abap_bool.
    IF exception IS NOT INITIAL.
      exception_was_returned = abap_true.
    ENDIF.

    cl_abap_unit_assert=>assert_equals( msg = 'Invalid attribute is not recognized as such' exp = exception_was_returned act = abap_true ).
  ENDMETHOD.


  METHOD valid_import_parameter.
    TRY.
        cut->modify_item_attribute(
          EXPORTING
            i_attribute_name = 'CHANNEL'
            i_value     = '123'
            i_item_key = '0001'
        ).
      CATCH  cx_apoc_invalid_attribute_name INTO DATA(invalid_attribute_exception).
      CATCH  cx_apoc_error_bobf_retrieve INTO DATA(excepted_exception).
    ENDTRY.

    DATA exception_was_returned TYPE abap_bool.
    IF invalid_attribute_exception IS NOT INITIAL.
      exception_was_returned = abap_true.
    ENDIF.

    cl_abap_unit_assert=>assert_equals( msg = 'Valid attribute is recognized as invalid which leads to an exception' exp = exception_was_returned act = abap_false ).
  ENDMETHOD.

  METHOD item_does_not_exist.
    "Create Test Data Double for APOC_D_OR_ITEM
*    DATA apoc_d_or_item_double TYPE STANDARD TABLE OF apoc_d_or_item.
*    apoc_d_or_item_double = VALUE #(
*                      ( db_key = '1'
*                        appl_object_id = '12344' )
*                       ).
*    g_environment->insert_test_data( apoc_d_or_item_double ).
*
*    TRY.
*        cut->modify_item_attribute(
*          EXPORTING
*            i_attribute_name = 'CHANNEL'
*            i_value     = '123'
*            i_item_key = '12345'
*        ).
*      CATCH  cx_apoc_item_does_not_exist  INTO DATA(exception).
*    ENDTRY.
*
*    DATA exception_was_returned TYPE abap_bool.
*    IF exception IS NOT INITIAL.
*      exception_was_returned = abap_true.
*    ENDIF.
*
*    cl_abap_unit_assert=>assert_equals( msg = 'Non existing Output Item is processed' exp = exception_was_returned act = abap_true ).
  ENDMETHOD.

  METHOD bobf_returns_nothing.
    "Create Test Data Double for APOC_D_OR_ITEM
    DATA apoc_d_or_item_double TYPE STANDARD TABLE OF apoc_d_or_item.
    apoc_d_or_item_double = VALUE #(
                      ( db_key = '0001'
                        appl_object_id = 'This Object ID does not return anything in bobf retrieve'
                        item_id = '1' )
                       ).
    g_environment->insert_test_data( apoc_d_or_item_double ).

    TRY.
        cut->modify_item_attribute(
          EXPORTING
            i_attribute_name = 'CHANNEL'
            i_value     = '123'
            i_item_key = '0001'
        ).
      CATCH cx_apoc_error_bobf_retrieve INTO DATA(error_msg_exception).
    ENDTRY.

    DATA exception_was_returned TYPE abap_bool.
    IF error_msg_exception IS NOT INITIAL.
      exception_was_returned = abap_true.
    ENDIF.

    cl_abap_unit_assert=>assert_equals( msg = 'Exception during bobf retrieve is not caught' exp = exception_was_returned act = abap_true ).
  ENDMETHOD.

  METHOD bobf_cant_find_key.
    "Create Test Data Double for APOC_D_OR_ITEM
    DATA apoc_d_or_item_double TYPE STANDARD TABLE OF apoc_d_or_item.
    apoc_d_or_item_double = VALUE #(
                      ( db_key = '0000'
                        appl_object_id = 'This Object IDs dbkey cant be found by BOBF'
                        item_id = '1' )
                       ).
    g_environment->insert_test_data( apoc_d_or_item_double ).

    TRY.
        cut->modify_item_attribute(
          EXPORTING
            i_attribute_name = 'CHANNEL'
            i_value     = '123'
            i_item_key = '0000'
        ).
      CATCH cx_apoc_error_bobf_retrieve INTO DATA(error_msg_exception).
    ENDTRY.

    DATA exception_was_returned TYPE abap_bool.
    IF error_msg_exception IS NOT INITIAL.
      exception_was_returned = abap_true.
    ENDIF.

    cl_abap_unit_assert=>assert_equals( msg = 'Exception during bobf retrieve is not caught' exp = exception_was_returned act = abap_true ).
  ENDMETHOD.

  METHOD bobf_retrieve_works.
    "Create Test Data Double for APOC_D_OR_ITEM
    DATA apoc_d_or_item_double TYPE STANDARD TABLE OF apoc_d_or_item.
    apoc_d_or_item_double = VALUE #(
                      ( db_key = '0002'
                        appl_object_id = 'Valid Object'
                        item_id = '1' )
                       ).
    g_environment->insert_test_data( apoc_d_or_item_double ).

    TRY.
        cut->modify_item_attribute(
          EXPORTING
            i_attribute_name = 'CHANNEL'
            i_value     = '123'
            i_item_key = '0002'
        ).
      CATCH cx_apoc_error_bobf_retrieve INTO DATA(error_msg_exception).
    ENDTRY.

    DATA exception_was_returned TYPE abap_bool.
    IF error_msg_exception IS NOT INITIAL.
      DATA(message_from_retrieve) = error_msg_exception->if_t100_dyn_msg~msgv1.

    ENDIF.

    cl_abap_unit_assert=>assert_equals( msg = 'Exception during bobf retrieve is not caught' exp = 'Valid Object' act = message_from_retrieve ).
  ENDMETHOD.

  METHOD change_channel_to_email.
    "Create Test Data Double for APOC_D_OR_ITEM
    DATA apoc_d_or_item_double TYPE STANDARD TABLE OF apoc_d_or_item.
    apoc_d_or_item_double = VALUE #(
                      ( db_key = '0003'
                        appl_object_id = 'Valid Object'
                        item_id = '1'
                        channel = 'PRINT' )
                       ).
    g_environment->insert_test_data( apoc_d_or_item_double ).

    TRY.
        cut->modify_item_attribute(
          EXPORTING
            i_attribute_name = 'CHANNEL'
            i_value     = 'EMAIL'
            i_item_key = '0003'
        ).
      CATCH cx_apoc_error_bobf_retrieve INTO DATA(error_msg_exception).
      CATCH cx_apoc_bobf_modify_failed  INTO DATA(modify_exception).
    ENDTRY.

    DATA exception_was_returned TYPE abap_bool.
    IF modify_exception IS NOT INITIAL.
      DATA(message_from_retrieve) = modify_exception->if_t100_dyn_msg~msgv1.

    ENDIF.

    cl_abap_unit_assert=>assert_equals( msg = 'Exception during bobf retrieve is not caught' exp = 'Valid Object' act = message_from_retrieve ).

  ENDMETHOD.

  METHOD bobf_save_fails.
    "Create Test Data Double for APOC_D_OR_ITEM
    DATA apoc_d_or_item_double TYPE STANDARD TABLE OF apoc_d_or_item.
    apoc_d_or_item_double = VALUE #(
                      ( db_key = '0004'
                        appl_object_id = 'Valid Object'
                        item_id = '1'
                        channel = 'PRINT' )
                       ).
    g_environment->insert_test_data( apoc_d_or_item_double ).

    m_transaction_mgr_mock->simulate_failed_save( ).

    TRY.
        cut->modify_item_attribute(
          EXPORTING
            i_attribute_name = 'CHANNEL'
            i_value     = 'EMAIL'
            i_item_key = '0004'
        ).
      CATCH cx_apoc_bobf_save_failed  INTO DATA(save_exception).
    ENDTRY.

    DATA exception_was_returned TYPE abap_bool.
    IF save_exception IS NOT INITIAL.
      exception_was_returned = abap_true.
    ENDIF.

    cl_abap_unit_assert=>assert_equals( msg = 'Exception during bobf save is not caught' exp = abap_true act = exception_was_returned ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_generic_attr_assignment DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA:
      cut TYPE REF TO cl_apoc_ptf_bo_item.
    METHODS:
      setup,
      change_channel_to_email FOR TESTING RAISING cx_static_check,
      invalid_attribute_name FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_generic_attr_assignment IMPLEMENTATION.
  METHOD setup.
    cut = NEW #( ).
  ENDMETHOD.

  METHOD change_channel_to_email.
    DATA(attribute_name) = 'CHANNEL'.
    DATA(channel_value) = 'EMAIL'.
    DATA item_structure  TYPE apoc_s_or_item.

    item_structure-channel = 'PRINT'.


    cut->assign_generic_attribute(
      EXPORTING
        i_attribute_name          = CONV #( attribute_name )
        i_value                   = CONV #( channel_value )
        i_item_structure          = item_structure
      RECEIVING
        changed_item_as_reference = DATA(act_item_reference)
    ).

    cl_abap_unit_assert=>assert_equals( msg = 'Channel change to EMAIL didnt work' exp = channel_value act = act_item_reference->channel ).

  ENDMETHOD.

  METHOD invalid_attribute_name.
    DATA(attribute_name) = 'Invalid Attribute Name'.
    DATA(channel_value) = 'EMAIL'.
    DATA item_structure  TYPE apoc_s_or_item.

    item_structure-channel = 'PRINT'.
    TRY.
        cut->assign_generic_attribute(
          EXPORTING
            i_attribute_name          = CONV #( attribute_name )
            i_value                   = CONV #( channel_value )
            i_item_structure          = item_structure
          RECEIVING
            changed_item_as_reference = DATA(act_item_reference)
        ).
      CATCH cx_apoc_invalid_attribute_name INTO DATA(invalid_attribute_exception).
    ENDTRY.

    IF invalid_attribute_exception IS NOT INITIAL.
      DATA(exception_thrown) = abap_true.
    ENDIF.

    cl_abap_unit_assert=>assert_equals( msg = 'Exception should be thrown' exp = abap_true act = exception_thrown ).

  ENDMETHOD.
ENDCLASS.

CLASS ltcl_ptf_bo_item_resend DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA:
      cut TYPE REF TO cl_apoc_ptf_bo_item.

    METHODS:
      setup,
      first_test FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_ptf_bo_item_resend IMPLEMENTATION.

  METHOD setup.
    cut = NEW #( ).
  ENDMETHOD.

  METHOD first_test.
    DATA:
      application_object_id TYPE apoc_appl_object_id,
      item_id               TYPE apoc_or_item_id.

*    data(key_of_resent_item) = cut->resend_output_item(
*      EXPORTING
*        i_item_application_object_id = application_object_id
*        i_item_id                    = item_id
*    ).
*    CATCH cx_apoc_ptf_exception.
*    CATCH cx_apoc_item_does_not_exist.

*   cl_abap_unit_assert=>assert_not_initial(
*     EXPORTING
*       act              = key_of_resent_item
*   ).
  ENDMETHOD.


ENDCLASS.
