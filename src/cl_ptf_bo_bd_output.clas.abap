CLASS cl_ptf_bo_bd_output DEFINITION
  PUBLIC
  INHERITING FROM cl_ptf_bo
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_output_parameter,
        parameter TYPE string,
        value     TYPE string,
      END OF ty_output_parameter,
      ty_output_parameters TYPE STANDARD TABLE OF ty_output_parameter WITH DEFAULT KEY,
      BEGIN OF ty_string,
        value                    TYPE string,
        ecatt_quality_tool_kappa TYPE string,
      END OF ty_string,
      ty_table_of_strings TYPE STANDARD TABLE OF ty_string WITH DEFAULT KEY,
      BEGIN OF ty_output_check,
        xml                      TYPE string,
        application_business_key TYPE string,
        service_name             TYPE string,
        sender_country           TYPE string,
        language                 TYPE string,
        parameters               TYPE ty_output_parameters,
        irrelevant_components    TYPE ty_table_of_strings,
      END OF ty_output_check,
      BEGIN OF ty_output_struc_check,
        xml                      TYPE string,
        application_business_key TYPE string,
        service_name             TYPE string,
        sender_country           TYPE string,
        language                 TYPE string,
        parameters               TYPE ty_output_parameters,
      END OF ty_output_struc_check,
      BEGIN OF ty_condition,
        node  TYPE string,
        value TYPE string,
        regex TYPE string,
      END OF ty_condition,
      BEGIN OF ty_query_output_check,
        path                     TYPE ty_table_of_strings,
        condition                TYPE ty_condition,
        to_check                 TYPE ty_condition,
        application_business_key TYPE string,
        service_name             TYPE string,
        sender_country           TYPE string,
        language                 TYPE string,
        parameters               TYPE ty_output_parameters,
        class_validator          TYPE string,
      END OF ty_query_output_check,
      BEGIN OF ty_key_value,
        name  TYPE string,
        value TYPE string,
      END OF ty_key_value,
      ty_key_value_map TYPE STANDARD TABLE OF ty_key_value WITH EMPTY KEY.


    METHODS change
        REDEFINITION .
    METHODS check
        REDEFINITION .
    METHODS create
        REDEFINITION .
    METHODS delete
        REDEFINITION .
    METHODS execute_action
        REDEFINITION .
    METHODS execute_check
        REDEFINITION .
    METHODS check_existence
        REDEFINITION .
  PROTECTED SECTION.
private section.

  constants C_KEY_LANGUAGE type STRING value 'Language' ##NO_TEXT.
  constants C_KEY_SENDERCOUNTRY type STRING value 'SenderCountry' ##NO_TEXT.
  constants C_CHECK_VALUES_ONLY type STRING value 'CHECK_VALUES_ONLY' ##NO_TEXT.
  constants C_CHECK_STRUCTURE_ONLY type STRING value 'CHECK_STRUCTURE_ONLY' ##NO_TEXT.
  constants C_CHECK_QUERY_BASED type STRING value 'CHECK_QUERY_BASE' ##NO_TEXT.
  constants C_CHECK_EXISTENCE_OUTPUTITEM type STRING value 'CHECK_EXISTENCE_OUTPUTITEM' ##NO_TEXT.
  constants C_CHECK_STATUS_NOT_IN_PREP type STRING value 'CHECK_STATUS_NOT_IN_PREP' ##NO_TEXT.
  constants C_CHECK_OUTPUT_ITEMS_SENT type STRING value 'CHECK_OUTPUT_ITEMS_SENT' ##NO_TEXT.
  constants C_CHECK_OUTPUT_ITEMS_DETERMND type STRING value 'CHECK_OUTPUT_ITEMS_DETERMND' ##NO_TEXT.
  constants C_CHECK_OUTPUT_ITEMS_REMOVED type STRING value 'CHECK_OUTPUT_ITEMS_REMOVED' ##NO_TEXT.

  methods RETRIEVE_OUTPUT
    importing
      !DOCUMENT type PTFKEY
      !APPLICATION_BUSINESS_KEY type STRING
      !SERVICE_NAME type STRING
      !SENDER_COUNTRY type STRING
      !LANGUAGE type STRING
      !PARAMETERS type TY_OUTPUT_PARAMETERS
    returning
      value(XML) type STRING
    raising
      CX_SOMU_ERROR .
  methods CHECK_VALUES_ONLY
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_STRUCTURE_ONLY
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_QUERY_BASE
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_SUB_NODES
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_EXISTENCE_OUTPUTITEM
    importing
      !IV_STEP_NUMBER type I
      !IV_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_OUTPUT_ITEMS_SENT
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_OUTPUT_ITEMS_DETERMND
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_OUTPUT_ITEMS_REMOVED
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
ENDCLASS.



CLASS CL_PTF_BO_BD_OUTPUT IMPLEMENTATION.


  METHOD change.
  ENDMETHOD.


  METHOD check.
    DATA: test_data       TYPE ty_output_check,
          regex_check     TYPE cl_sd_bil_xml_util=>ty_regex_check,
          regex_checks    TYPE cl_sd_bil_xml_util=>ty_regex_checks,
          value_equal     TYPE abap_bool,
          structure_equal TYPE abap_bool,
          differences     TYPE STANDARD TABLE OF string,
          documents       TYPE cl_ptf_util=>ty_vbeln_tab.


    DATA(step_data) = mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = test_data
    ).

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(ref_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      APPEND LINES OF ref_keys TO documents.
    ENDLOOP.

    IF documents IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No reference documents| ).
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.

    regex_check-regex = '.*'.
    LOOP AT test_data-irrelevant_components ASSIGNING FIELD-SYMBOL(<irrelevant_component>).
      regex_check-node = <irrelevant_component>-value.
      APPEND regex_check TO regex_checks.
    ENDLOOP.

    ev_check_status = abap_true.

    LOOP AT documents ASSIGNING FIELD-SYMBOL(<document>).
      TRY.

          DATA(output_xml) = me->retrieve_output(
                               document                 = <document>-vbeln
                               application_business_key = test_data-application_business_key
                               service_name             = test_data-service_name
                               sender_country           = test_data-sender_country
                               language                 = test_data-language
                               parameters               = test_data-parameters
                             ).

          cl_sd_bil_xml_util=>compare_values(
            EXPORTING
              expected_xml = test_data-xml
              actual_xml   = output_xml
              regex_checks = regex_checks
            IMPORTING
              equal        = value_equal
              differences  = differences
          ).

          cl_sd_bil_xml_util=>compare_structure(
            EXPORTING
              expected_xml = test_data-xml
              actual_xml   = output_xml
            IMPORTING
              equal        = structure_equal
              differences  = differences
          ).

          "Only overwrite if all preceding documents were checked succ
          IF ev_check_status EQ abap_true.
            ev_check_status = xsdbool( structure_equal EQ abap_true AND value_equal EQ abap_true ).
          ENDIF.

          me->mo_run_environment->append_log( iv_log_statement = |Output check results for { <document>-vbeln }| ).
          LOOP AT differences ASSIGNING FIELD-SYMBOL(<difference>).
            me->mo_run_environment->append_log( iv_log_statement = <difference> ).
          ENDLOOP.

        CATCH cx_root INTO DATA(exp). " Parse error while creating XML document
          me->mo_run_environment->append_log( iv_log_statement = |Error occured while checking output.| ).
          me->mo_run_environment->append_log( iv_log_statement = |Error message: { exp->get_text( ) }| ).
          ev_execution_status = abap_false.
          ev_check_status = abap_false.
          RETURN.
      ENDTRY.

    ENDLOOP.

    ev_execution_status = abap_true.

  ENDMETHOD.


  METHOD check_existence.

    rv_exists = abap_true.

*    data: lv_step_number type i,
*            documents       TYPE cl_ptf_util=>ty_vbeln_tab.
*
*    lv_step_number = iv_id.
*
*    rv_exists = abap_true.
*
*    DATA(step_data) = mo_run_environment->get_step_data( iv_step_number = lv_step_number ).
*
*    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
*      DATA(ref_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
*      APPEND LINES OF ref_keys TO documents.
*    ENDLOOP.
*
*    LOOP AT documents ASSIGNING FIELD-SYMBOL(<document>).
*      SELECT SINGLE @abap_true
*        FROM apoc_d_or_item
*        WHERE appl_object_type = 'BILLING_DOCUMENT'
*          AND appl_object_id   = @<document>-vbeln
*        INTO @DATA(lv_output_exists).
*
*      IF sy-subrc <> 0.
*        rv_exists = abap_false.
*        RETURN.
*      ENDIF.
*    ENDLOOP.
  ENDMETHOD.


  METHOD check_existence_outputitem.
    DATA: documents TYPE cl_ptf_util=>ty_vbeln_tab.

    ev_check_status = abap_true.
    ev_execution_status = abap_true.

    LOOP AT iv_step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(ref_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      APPEND LINES OF ref_keys TO documents.
    ENDLOOP.

    IF documents IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No reference documents| ).
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.

    LOOP AT documents ASSIGNING FIELD-SYMBOL(<document>).
      SELECT SINGLE @abap_true
        FROM apoc_d_or_item
        WHERE appl_object_type = 'BILLING_DOCUMENT'
          AND appl_object_id   = @<document>-vbeln
        INTO @DATA(lv_output_exists).

      IF sy-subrc <> 0.
        ev_check_status = abap_false.
        ev_execution_status = abap_false.
        RETURN.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD check_output_items_determnd.

    DATA lt_billing_document TYPE cl_sdbil_oc_mass_change=>tt_billing_doc_number.
    DATA lv_timestamp_long TYPE timestampl.

    ev_execution_status = abap_true.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).

      DATA(lt_billing_document_temp) = mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).

      APPEND LINES OF lt_billing_document_temp
        TO lt_billing_document.

    ENDLOOP.

    GET TIME STAMP FIELD lv_timestamp_long.

    DATA(lv_timestamp_compare) = cl_abap_tstmp=>subtractsecs(
      tstmp = lv_timestamp_long
      secs  = 300 ).

    SELECT appl_object_id
      FROM apoc_d_or_item
      FOR ALL ENTRIES IN @lt_billing_document
      WHERE appl_object_type = 'BILLING_DOCUMENT'
        AND appl_object_id   = @lt_billing_document-billingdocnumber
        AND status           = '1'
        AND item_origin      = '1'
        AND crea_date_time   > @lv_timestamp_compare
      INTO TABLE @DATA(lt_billing_output_item).

    IF lt_billing_output_item IS INITIAL.

      mo_run_environment->append_log( iv_log_statement = |Check failed: No output item with status 'In Preparation' exists.| ).
      mo_run_environment->append_log( iv_log_statement = |This might be caused by current OPD settings not determining any output item.| ).

    ELSE.

      ev_check_status = abap_true.

      mo_run_environment->append_log( iv_log_statement = |Check successful: At least one output item with status 'In Preparation' exists.| ).

    ENDIF.

  ENDMETHOD.


  METHOD check_output_items_removed.

    DATA lt_billing_document TYPE cl_sdbil_oc_mass_change=>tt_billing_doc_number.

    ev_execution_status = abap_true.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).

      DATA(lt_billing_document_temp) = mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).

      APPEND LINES OF lt_billing_document_temp
        TO lt_billing_document.

    ENDLOOP.

    SELECT appl_object_id
      FROM apoc_d_or_item
      FOR ALL ENTRIES IN @lt_billing_document
      WHERE appl_object_type = 'BILLING_DOCUMENT'
        AND appl_object_id   = @lt_billing_document-billingdocnumber
        AND status           = '1'
        AND item_origin      = '1'
      INTO TABLE @DATA(lt_billing_output_item).

    IF lt_billing_output_item IS NOT INITIAL.

      mo_run_environment->append_log( iv_log_statement = |Check failed: Output items with status 'In Preparation' must not exist.| ).
      mo_run_environment->append_log( iv_log_statement = |Remove output items failed for the following documents:| ).

      LOOP AT lt_billing_output_item INTO DATA(ls_billing_output_item).

        mo_run_environment->append_log( iv_log_statement = CONV #( ls_billing_output_item-appl_object_id ) ).

      ENDLOOP.

    ELSE.

      ev_check_status = abap_true.

      mo_run_environment->append_log( iv_log_statement = |Check successful: No output items with status 'In Preparation' exist.| ).

    ENDIF.

  ENDMETHOD.


  METHOD check_output_items_sent.

    DATA lt_billing_document TYPE cl_sdbil_oc_mass_change=>tt_billing_doc_number.

    ev_execution_status = abap_true.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).

      DATA(lt_billing_document_temp) = mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).

      APPEND LINES OF lt_billing_document_temp
        TO lt_billing_document.

    ENDLOOP.

    SELECT appl_object_id
      FROM apoc_d_or_item
      FOR ALL ENTRIES IN @lt_billing_document
      WHERE appl_object_type = 'BILLING_DOCUMENT'
        AND appl_object_id   = @lt_billing_document-billingdocnumber
        AND status           = '1'
      INTO TABLE @DATA(lt_billing_output_item).

    IF lt_billing_output_item IS NOT INITIAL.

      mo_run_environment->append_log( iv_log_statement = |Check failed: Output items with status 'In Preparation' must not exist.| ).
      mo_run_environment->append_log( iv_log_statement = |Send output items failed for the following documents:| ).

      LOOP AT lt_billing_output_item INTO DATA(ls_billing_output_item).

        mo_run_environment->append_log( iv_log_statement = CONV #( ls_billing_output_item-appl_object_id ) ).

      ENDLOOP.

      mo_run_environment->append_log( iv_log_statement = |This might be caused by current OPD settings not being set up accordingly.| ).

    ELSE.

      ev_check_status = abap_true.

      mo_run_environment->append_log( iv_log_statement = |Check successful: No output items with status 'In Preparation' exist.| ).

    ENDIF.

  ENDMETHOD.


  METHOD check_query_base.
    DATA: test_data             TYPE ty_query_output_check,
          documents             TYPE cl_ptf_util=>ty_vbeln_tab,
          query_fullfill        TYPE abap_bool,
          differences           TYPE STANDARD TABLE OF string,
          check                 TYPE cl_sd_bil_xml_util=>ty_xml_query_checks,
          condition             TYPE cl_sd_bil_xml_util=>ty_condition,
          constructor_parameter TYPE abap_parmbind_tab,
          validator             TYPE REF TO cl_ptf_oc_gen_node_validator.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = test_data
    ).

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(ref_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      APPEND LINES OF ref_keys TO documents.
    ENDLOOP.

    IF documents IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No reference documents| ).
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.

    ev_check_status = abap_true.

    LOOP AT test_data-path ASSIGNING FIELD-SYMBOL(<waypoint>).
      APPEND <waypoint>-value TO check-path.
    ENDLOOP.

    check-to_check = test_data-to_check.

    check-condition = test_data-condition.

    LOOP AT documents ASSIGNING FIELD-SYMBOL(<document>).
      TRY.

          DATA(output_xml) = me->retrieve_output(
                               document                 = <document>-vbeln
                               application_business_key = test_data-application_business_key
                               service_name             = test_data-service_name
                               sender_country           = test_data-sender_country
                               language                 = test_data-language
                               parameters               = test_data-parameters
                             ).

          IF test_data-class_validator IS INITIAL.
            cl_sd_bil_xml_util=>check_xml_condition_based(
              EXPORTING
                xml         = output_xml
                check       = check
              IMPORTING
                fullfills   = query_fullfill
                differences = differences
            ).
          ELSE.
            TRY.
                CREATE OBJECT validator TYPE (test_data-class_validator) PARAMETER-TABLE constructor_parameter.

              CATCH cx_root.
                me->mo_run_environment->append_log( iv_log_statement = |Could not initiate validator.| ).
                ev_check_status = abap_false.
                ev_execution_status = abap_false.
                RETURN.
            ENDTRY.

            DATA(is_instance_gen_node_validator) = xsdbool( validator IS INSTANCE OF cl_ptf_oc_gen_node_validator ).

            IF is_instance_gen_node_validator NE abap_true.
              me->mo_run_environment->append_log( iv_log_statement = |Validator type incorrect| ).
              ev_check_status = abap_false.
              ev_execution_status = abap_false.
              RETURN.
            ENDIF.

            DATA(node_validator) = NEW cl_ptf_bd_oc_node_validator(
              step_data       = step_data
              iv_step_number  = iv_step_number
              run_environment = me->mo_run_environment
              validator       = validator
            ).

            cl_sd_bil_xml_util=>check_xml_condition_based(
              EXPORTING
                xml         = output_xml
                check       = check
                validator = node_validator
              IMPORTING
                fullfills   = query_fullfill
                differences = differences
            ).

          ENDIF.

          "Only overwrite if all preceding documents were checked succ
          IF ev_check_status EQ abap_true.
            ev_check_status = query_fullfill.
          ENDIF.

          me->mo_run_environment->append_log( iv_log_statement = |Output check results for { <document>-vbeln }| ).
          LOOP AT differences ASSIGNING FIELD-SYMBOL(<difference>).
            me->mo_run_environment->append_log( iv_log_statement = <difference> ).
          ENDLOOP.

        CATCH cx_root INTO DATA(exp). " Parse error while creating XML document
          me->mo_run_environment->append_log( iv_log_statement = |Error occured while checking output.| ).
          me->mo_run_environment->append_log( iv_log_statement = |Error message: { exp->get_text( ) }| ).
          ev_execution_status = abap_false.
          ev_check_status = abap_false.
          RETURN.
      ENDTRY.

    ENDLOOP.

    ev_execution_status = abap_true.

  ENDMETHOD.


  METHOD check_structure_only.
    DATA: test_data       TYPE ty_output_struc_check,
          structure_equal TYPE abap_bool,
          differences     TYPE STANDARD TABLE OF string,
          documents       TYPE cl_ptf_util=>ty_vbeln_tab.


    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = test_data
    ).

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(ref_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      APPEND LINES OF ref_keys TO documents.
    ENDLOOP.

    IF documents IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No reference documents| ).
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.

    ev_check_status = abap_true.

    LOOP AT documents ASSIGNING FIELD-SYMBOL(<document>).
      TRY.

          DATA(output_xml) = me->retrieve_output(
                               document                 = <document>-vbeln
                               application_business_key = test_data-application_business_key
                               service_name             = test_data-service_name
                               sender_country           = test_data-sender_country
                               language                 = test_data-language
                               parameters               = test_data-parameters
                             ).

          cl_sd_bil_xml_util=>compare_structure(
            EXPORTING
              expected_xml = test_data-xml
              actual_xml   = output_xml
            IMPORTING
              equal        = structure_equal
              differences  = differences
          ).

          "Only overwrite if all preceding documents were checked succ
          IF ev_check_status EQ abap_true.
            ev_check_status = structure_equal.
          ENDIF.

          me->mo_run_environment->append_log( iv_log_statement = |Output check results for { <document>-vbeln }| ).
          LOOP AT differences ASSIGNING FIELD-SYMBOL(<difference>).
            me->mo_run_environment->append_log( iv_log_statement = <difference> ).
          ENDLOOP.

        CATCH cx_root INTO DATA(exp). " Parse error while creating XML document
          me->mo_run_environment->append_log( iv_log_statement = |Error occured while checking output.| ).
          me->mo_run_environment->append_log( iv_log_statement = |Error message: { exp->get_text( ) }| ).
          ev_execution_status = abap_false.
          ev_check_status = abap_false.
          RETURN.
      ENDTRY.

    ENDLOOP.

    ev_execution_status = abap_true.

  ENDMETHOD.


  METHOD check_sub_nodes.
*    DATA: test_data    TYPE ty_query_output_check,
*          documents    TYPE cl_ptf_util=>ty_vbeln_tab,
*          regex_check  TYPE cl_sd_bil_xml_util=>ty_regex_check,
*          regex_checks TYPE cl_sd_bil_xml_util=>ty_regex_checks,
*          value_equal  TYPE abap_bool,
**          query_fullfill        TYPE abap_bool,
*          differences  TYPE STANDARD TABLE OF string.
**          check                 TYPE cl_sd_bil_xml_util=>ty_xml_query_checks.
**          condition             TYPE cl_sd_bil_xml_util=>ty_condition,
**          constructor_parameter TYPE abap_parmbind_tab,
**          validator             TYPE REF TO cl_ptf_oc_gen_node_validator.
*
*    cl_ptf_util=>get_testdata(
*      EXPORTING
*        is_step_data = step_data
*      IMPORTING
*        es_testdata  = test_data
*    ).
*
*    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
*      DATA(ref_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
*      APPEND LINES OF ref_keys TO documents.
*    ENDLOOP.
*
*    IF documents IS INITIAL.
*      me->mo_run_environment->append_log( iv_log_statement = |No reference documents| ).
*      ev_check_status = abap_false.
*      ev_execution_status = abap_false.
*      RETURN.
*    ENDIF.
*
*    regex_check-regex = '.*'.
*    LOOP AT test_data-irrelevant_components ASSIGNING FIELD-SYMBOL(<irrelevant_component>).
*      regex_check-node = <irrelevant_component>-value.
*      APPEND regex_check TO regex_checks.
*    ENDLOOP.
*
*    ev_check_status = abap_true.
*
*    LOOP AT test_data-path ASSIGNING FIELD-SYMBOL(<waypoint>).
*      APPEND <waypoint>-value TO check-path.
*    ENDLOOP.
*
*    LOOP AT documents ASSIGNING FIELD-SYMBOL(<document>).
*      TRY.
*
*          DATA(output_xml) = me->retrieve_output(
*                               document                 = <document>-vbeln
*                               application_business_key = test_data-application_business_key
*                               service_name             = test_data-service_name
*                               sender_country           = test_data-sender_country
*                               language                 = test_data-language
*                               parameters               = test_data-parameters
*                             ).
*
*
*
*
*
*          cl_sd_bil_xml_util=>compare_values(
*            EXPORTING
*              expected_xml = test_data-xml
*              actual_xml   = output_xml
*              regex_checks = regex_checks
*            IMPORTING
*              equal        = value_equal
*              differences  = differences
*          ).
*
*
*
*
*
*          "Only overwrite if all preceding documents were checked succ
*          IF ev_check_status EQ abap_true.
*            ev_check_status = value_equal.
*          ENDIF.
*
*          me->mo_run_environment->append_log( iv_log_statement = |Output check results for { <document>-vbeln }| ).
*          LOOP AT differences ASSIGNING FIELD-SYMBOL(<difference>).
*            me->mo_run_environment->append_log( iv_log_statement = <difference> ).
*          ENDLOOP.
*
*        CATCH cx_root INTO DATA(exp). " Parse error while creating XML document
*          me->mo_run_environment->append_log( iv_log_statement = |Error occured while checking output.| ).
*          me->mo_run_environment->append_log( iv_log_statement = |Error message: { exp->get_text( ) }| ).
*          ev_execution_status = abap_false.
*          ev_check_status = abap_false.
*          RETURN.
*      ENDTRY.
*
*    ENDLOOP.
*
*    ev_execution_status = abap_true.

  ENDMETHOD.


  METHOD check_values_only.
    DATA: test_data    TYPE ty_output_check,
          regex_check  TYPE cl_sd_bil_xml_util=>ty_regex_check,
          regex_checks TYPE cl_sd_bil_xml_util=>ty_regex_checks,
          value_equal  TYPE abap_bool,
          differences  TYPE STANDARD TABLE OF string,
          documents    TYPE cl_ptf_util=>ty_vbeln_tab.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = test_data
    ).

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(ref_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      APPEND LINES OF ref_keys TO documents.
    ENDLOOP.

    IF documents IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No reference documents| ).
      ev_check_status = abap_false.
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.

    regex_check-regex = '.*'.
    LOOP AT test_data-irrelevant_components ASSIGNING FIELD-SYMBOL(<irrelevant_component>).
      regex_check-node = <irrelevant_component>-value.
      APPEND regex_check TO regex_checks.
    ENDLOOP.

    ev_check_status = abap_true.

    LOOP AT documents ASSIGNING FIELD-SYMBOL(<document>).
      TRY.

          DATA(output_xml) = me->retrieve_output(
                               document                 = <document>-vbeln
                               application_business_key = test_data-application_business_key
                               service_name             = test_data-service_name
                               sender_country           = test_data-sender_country
                               language                 = test_data-language
                               parameters               = test_data-parameters
                             ).

          cl_sd_bil_xml_util=>compare_values(
            EXPORTING
              expected_xml = test_data-xml
              actual_xml   = output_xml
              regex_checks = regex_checks
            IMPORTING
              equal        = value_equal
              differences  = differences
          ).

          "Only overwrite if all preceding documents were checked succ
          IF ev_check_status EQ abap_true.
            ev_check_status = value_equal.
          ENDIF.

          me->mo_run_environment->append_log( iv_log_statement = |Output check results for { <document>-vbeln }| ).
          LOOP AT differences ASSIGNING FIELD-SYMBOL(<difference>).
            me->mo_run_environment->append_log( iv_log_statement = <difference> ).
          ENDLOOP.

        CATCH cx_root INTO DATA(exp). " Parse error while creating XML document
          me->mo_run_environment->append_log( iv_log_statement = |Error occured while checking output.| ).
          me->mo_run_environment->append_log( iv_log_statement = |Error message: { exp->get_text( ) }| ).
          ev_execution_status = abap_false.
          ev_check_status = abap_false.
          RETURN.
      ENDTRY.

    ENDLOOP.

    ev_execution_status = abap_true.
  ENDMETHOD.


  METHOD create.
  ENDMETHOD.


  METHOD delete.
  ENDMETHOD.


  METHOD execute_action.
  ENDMETHOD.


  METHOD execute_check.
    DATA(step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    CASE step_data-action.
      WHEN c_check_query_based.
        me->check_query_base(
          EXPORTING
            step_data           = step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_check_values_only.
        me->check_values_only(
          EXPORTING
            step_data           = step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_check_structure_only.
        me->check_structure_only(
          EXPORTING
            step_data           = step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_check_existence_outputitem.
        me->check_existence_outputitem(
          EXPORTING
            iv_step_data        = step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_check_output_items_removed.
        check_output_items_removed(
          EXPORTING
            step_data           = step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_check_output_items_determnd.
        check_output_items_determnd(
          EXPORTING
            step_data           = step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_check_output_items_sent.
        check_output_items_sent(
          EXPORTING
            step_data           = step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.

      WHEN OTHERS.
        me->mo_run_environment->append_log( iv_log_statement = |Could not find method { step_data-action } for the BO { step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.
    ENDCASE.
  ENDMETHOD.


  METHOD retrieve_output.
    DATA: log             TYPE LINE OF cl_ptf_util=>gt_ptf_return_tab,
          key_value_map   TYPE ty_key_value_map,
          converted_langu TYPE string,
          output_entity   TYPE REF TO data.

    FIELD-SYMBOLS: <output_entity> TYPE any.


    IF service_name NE 'FDP_OM_FORM_MASTER_SRV'.
      key_value_map = VALUE #(
                               ( name  = application_business_key value = document )
                               ( name  = c_key_language              value = language )
                               ( name  = c_key_sendercountry         value = sender_country )
                              ).
    ELSE.

      "Convert Language (only for FDP_OM_FORM_MASTER_SRV)

      DATA: lv_langu TYPE string.

      CALL FUNCTION 'CONVERSION_EXIT_ISOLA_INPUT'
        EXPORTING
          input            = language
        IMPORTING
          output           = converted_langu
        EXCEPTIONS
          unknown_language = 1
          OTHERS           = 2.
      IF sy-subrc <> 0.
        converted_langu = language.
      ELSE.
        key_value_map = VALUE #(
              ( name = if_somu_fpd_om_form_master=>gc_query_parameters-applicationobjecttype value = application_business_key )
              ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-applicationobjectid value = document )
              ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-localelanguage      value = converted_langu )
              ( name  = c_key_sendercountry         value = sender_country )
             ).
      ENDIF.
    ENDIF.

    LOOP AT parameters ASSIGNING FIELD-SYMBOL(<parameter>).
      APPEND VALUE #( name = <parameter>-parameter value = <parameter>-value  ) TO key_value_map.
    ENDLOOP.

    cl_somu_form_services=>get_instance( )->get_data(
          EXPORTING
            iv_service_name          = service_name
            it_key                   = key_value_map
          IMPORTING
            er_data_container        = output_entity ).

    ASSIGN output_entity->* TO <output_entity>.

    CALL TRANSFORMATION id
      SOURCE data = <output_entity>
      RESULT XML DATA(xstring).

    xml = cl_proxy_service=>xstring2cstring( xstring = xstring ).

  ENDMETHOD.
ENDCLASS.
