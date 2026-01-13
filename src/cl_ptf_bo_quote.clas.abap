CLASS cl_ptf_bo_quote DEFINITION
  PUBLIC
  INHERITING FROM cl_ptf_bo
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS create REDEFINITION .
    METHODS change REDEFINITION .
    METHODS delete REDEFINITION .
    METHODS check REDEFINITION .
    METHODS execute_action REDEFINITION .
    METHODS execute_check REDEFINITION .
    METHODS check_existence REDEFINITION.

    TYPES:
* Structure for Quote create
      BEGIN OF ty_gs_i_ptf_quote_cr_td,
        document_type        TYPE auart,
        sales_organization   TYPE vkorg,
        distribution_channel TYPE vtweg,
        division             TYPE spart,
        customer_id          TYPE kunnr,
        order_reason         TYPE augru,
        valid_to_date        TYPE bnddt,
        purch_number         TYPE bstkd,
        item_list            TYPE cl_ptf_sd_util=>ty_gt_item_list_td,
      END OF ty_gs_i_ptf_quote_cr_td .

    TYPES:
    partner_change TYPE STANDARD TABLE OF bapiparnrc WITH DEFAULT KEY .
    TYPES:
    adress_tab  TYPE STANDARD TABLE OF bapiaddr1 WITH DEFAULT KEY .

    TYPES:
* Structure for Quote change
      BEGIN OF ty_gs_i_ptf_quote_ch_td,
        document_type        TYPE auart,
        sales_organization   TYPE vkorg,
        distribution_channel TYPE vtweg,
        division             TYPE spart,
        customer_id          TYPE kunnr,
        order_reason         TYPE augru,
        valid_to_date        TYPE bnddt,
        item_list            TYPE cl_ptf_sd_util=>ty_gt_item_list_td,
        order_partners       TYPE cl_ptf_sd_util=>ty_order_partners,
        partner_change       TYPE partner_change,
        adress_data          TYPE adress_tab,
      END OF ty_gs_i_ptf_quote_ch_td .

    TYPES:
* Structure for check of Quotes / Requests for Quotes
      BEGIN OF ty_gs_ptf_rq_check_td,
        vbak       TYPE cl_ptf_bo_or=>vbak_tab,
        vbap       TYPE cl_ptf_bo_or=>vbap_tab,
        vbak_check TYPE cl_ptf_bo_or=>vbak_check_tab,
        vbap_check TYPE cl_ptf_bo_or=>vbap_check_tab,
      END OF ty_gs_ptf_rq_check_td .



    TYPES:
    ty_gt_configuration_ref TYPE STANDARD TABLE OF bapicucfg WITH DEFAULT KEY.
    TYPES:
    ty_gt_configuration_inst TYPE STANDARD TABLE OF bapicuins WITH DEFAULT KEY.
    TYPES:
    ty_gt_configuration_value TYPE STANDARD TABLE OF bapicuval WITH DEFAULT KEY.
    TYPES:
    ty_gt_configuration_vk TYPE STANDARD TABLE OF bapicuvk WITH DEFAULT KEY.

    TYPES:
* Structure for Standard Order (TA/OR) create
      BEGIN OF ty_gs_i_ptf_or_cr_td,
        document_type        TYPE auart,
        payment_terms        TYPE dzterm,
        payment_method       TYPE dzlsch,
        sales_organization   TYPE vkorg,
        distribution_channel TYPE vtweg,
        division             TYPE spart,
        customer_id          TYPE kunnr,
        order_reason         TYPE augru,
        valid_to_date        TYPE bnddt,
        billing_block        TYPE faksk,
        tax_dest_country     TYPE land1tx,
        tax_dept_country     TYPE landtx,
        tax_classification   TYPE taxk1_ak,
        service_render_date  TYPE fbuda,
        purch_number         TYPE bstkd,
        currency             TYPE waerk,
        billing_date         TYPE  fkdat,
        item_list            TYPE cl_ptf_sd_util=>ty_gt_item_list_td,
        order_partners       TYPE cl_ptf_sd_util=>ty_order_partners,
        condition            TYPE cl_ptf_sd_util=>lty_sales_conditions_in,
        ext_fields_item      TYPE cl_ptf_sd_util=>ty_gt_ext_field_td,
        sales_text           TYPE cl_ptf_sd_util=>ty_bapisdtext,
        adress_data          TYPE adress_tab,
        configuration_ref    TYPE ty_gt_configuration_ref,
        configuration_inst   TYPE ty_gt_configuration_inst,
        configuration_value  TYPE ty_gt_configuration_value,
        configuration_vk     TYPE ty_gt_configuration_vk,
      END OF ty_gs_i_ptf_or_cr_td .

    CLASS-METHODS compare_vbak_data
      IMPORTING
        !is_testdata        TYPE cl_ptf_bo_or=>ty_gs_ptf_sd_check_td
        !is_check_step_data TYPE cl_ptf_util=>gt_ptf_step
        !iv_run_environment TYPE REF TO cl_ptf_run
      RETURNING
        VALUE(rv_is_equal)  TYPE abap_bool .
    CLASS-METHODS compare_vbap_data
      IMPORTING
        !is_testdata        TYPE cl_ptf_bo_or=>ty_gs_ptf_sd_check_td
        !is_check_step_data TYPE cl_ptf_util=>gt_ptf_step
        !iv_run_environment TYPE REF TO cl_ptf_run
      RETURNING
        VALUE(rv_is_equal)  TYPE abap_bool .

    CONSTANTS c_create_with_reference TYPE string VALUE 'CREATE_WITH_REFERENCE' ##NO_TEXT.
    CONSTANTS c_check_partner TYPE string VALUE 'CHECK_PARTNER' ##NO_TEXT.

    TYPES:
* Structure for check inquiry partner address
      BEGIN OF ty_gs_ptf_sd_partner_td,
        item_number TYPE posnr,
        role        TYPE parvw,
        customer    TYPE kunnr,
        adrnr       TYPE ad_addrnum,
        adrda       TYPE adrda,
        addr_type   TYPE ad_adrtype,
      END OF ty_gs_ptf_sd_partner_td .

    TYPES:
        partner_tab TYPE STANDARD TABLE OF ty_gs_ptf_sd_partner_td WITH DEFAULT KEY .

    TYPES:
      BEGIN OF ty_gs_ptf_sd_check_partner_td,
        partner TYPE partner_tab,
      END OF ty_gs_ptf_sd_check_partner_td .

  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
    ty_gt_order_partners TYPE STANDARD TABLE OF bapiparnr .
    TYPES:
      ty_gt_order_items    TYPE STANDARD TABLE OF bapisditm .
    TYPES:
      ty_gt_schedules      TYPE STANDARD TABLE OF bapischdl .


    METHODS prepare_testdata_create
      IMPORTING
        !ls_testdata        TYPE ty_gs_i_ptf_quote_cr_td
      EXPORTING
        !ls_order_header_in TYPE bapisdhd1
        !lt_order_partners  TYPE ty_gt_order_partners
        !lt_order_items     TYPE ty_gt_order_items
        !lt_schedules       TYPE ty_gt_schedules .

    METHODS create_with_reference
      IMPORTING
        !step_data           TYPE cl_ptf_util=>gt_ptf_step                                                                                                                                          "parameter for better performance
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .

    METHODS change_header_partner_address
      IMPORTING
        !iv_quotation_number TYPE ptfkey
        !iv_change_tdc       TYPE ty_gs_i_ptf_quote_ch_td
      EXPORTING
        !ev_test_success     TYPE abap_bool
        !ev_result           TYPE ty_gs_i_ptf_quote_ch_td
        !et_return           TYPE cl_ptf_util=>gt_ptf_return_tab .

    METHODS check_partner
      IMPORTING
        !step_data           TYPE cl_ptf_util=>gt_ptf_step                                                                                                                                          "parameter for better performance
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .
ENDCLASS.



CLASS CL_PTF_BO_QUOTE IMPLEMENTATION.


  METHOD change.
    DATA: ls_testdata TYPE ty_gs_i_ptf_quote_ch_td.
    DATA: lt_message TYPE if_goal_types=>tct_message.
    DATA: iv_vbeln TYPE vbeln_va.
    DATA: ls_vbak     TYPE vbak.
    DATA: lv_bo_key TYPE if_goal_types=>tcd_bo_key.
    DATA: lt_changed_field TYPE if_goal_types=>tct_changed_field.
    DATA: ls_control_settings TYPE if_goal_access=>tcs_control_settings.
    DATA: ls_changed_field TYPE if_goal_types=>tcs_changed_field.
    DATA: ls_head_data TYPE tds_goal_quot_head.
    DATA: ls_item_data TYPE tds_goal_quot_item.
    DATA: lt_item_data TYPE STANDARD TABLE OF tds_goal_quot_item.
    DATA: lv_field TYPE fieldname.
    DATA: lo_access TYPE REF TO if_goal_access.
    DATA: ls_error TYPE if_goal_types=>tcs_error.
    DATA: lx_goal_exc TYPE REF TO cx_goal_exc.
    DATA: lv_text_exc TYPE string.
    DATA: ls_field_property TYPE if_goal_types=>tcs_object_property.
    DATA: lt_field_property TYPE if_goal_types=>tct_object_property,
          lt_vbeln          TYPE cl_ptf_util=>ty_vbeln_tab.
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    DATA  lt_return     TYPE cl_ptf_util=>gt_ptf_return_tab.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

    IF ls_testdata IS INITIAL. "Cannot merge both conditions, because ls_testdata could be null
      me->mo_run_environment->append_log( iv_log_statement = |Test data can not be loaded .| ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    IF lt_vbeln IS NOT INITIAL.
      LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<lv_vbel>).
        SELECT SINGLE * FROM vbak WHERE vbeln = @<lv_vbel>-vbeln INTO @ls_vbak.
        IF ls_vbak IS INITIAL.
          "Document not found
          me->mo_run_environment->append_log( iv_log_statement = |Could not find Quotation to be changed { <lv_vbel>-vbeln }.| ).
          ev_execution_status = abap_false.
          RETURN.
        ELSE.
          "          lv_bo_key = <lv_vbel>-vbeln.
          "          try.
          "              call method cl_goal_api=>so_instance->open
          "                exporting
          "                  iv_bo_id            = if_goal_sdoc=>co_bo_id-salesquotation
          "                  iv_bo_key           = lv_bo_key
          "                  iv_read_only        = abap_false
          "                  is_control_settings = ls_control_settings
          "                receiving
          "                  ro_access           = lo_access.
          "            catch cx_goal_exc into lx_goal_exc.
          "              lv_text_exc = lx_goal_exc->get_text( ).
          "              message lv_text_exc type 'I'.
          "              exit.
          "          endtry.

          "          call method lo_access->get_entity
          "            exporting
          "              iv_entity_id      = if_goal_sdoc_head=>co_entity_id
          "            importing
          "              es_entity_data    = ls_head_data
          "              es_field_property = ls_field_property.

          "          call method lo_access->get_entity_set
          "            exporting
          "              iv_entity_id      = if_goal_sdoc_item=>co_entity_id
          "              iv_handle_parent  = ls_head_data-handle
          "            importing
          "              et_entity_data    = lt_item_data
          "              et_field_property = lt_field_property.

          "          ls_item_data-handle = lt_item_data[ 1 ]-handle.
          "          ls_item_data = '2' .
          "          ls_changed_field-handle = ls_item_data-handle.
          "          lv_field = 'REQUESTED_QTY'.
          "          insert lv_field into table ls_changed_field-field.

          "          append ls_item_data to lt_item_data.
          "          append ls_changed_field to lt_changed_field.

          "          try.
          "              call method lo_access->set_entity_set
          "                exporting
          "                  iv_entity_id     = 'ITEM'
          "                  it_entity_data   = lt_item_data
          "                  it_changed_field = lt_changed_field
          "                  iv_handle_parent = ls_head_data-handle.
          "            catch cx_goal_exc into lx_goal_exc.    "
          "              lv_text_exc = lx_goal_exc->get_text( ).
          "              message lv_text_exc type 'I'.
          "              exit.
          "          endtry.

          "          call method lo_access->get_entity_set
          "            exporting
          "              iv_entity_id      = if_goal_sdoc_item=>co_entity_id
          "              iv_handle_parent  = ls_head_data-handle
          "            importing
          "              et_entity_data    = lt_item_data
          "              et_field_property = lt_field_property.

          "          lo_access->save( ).


          me->change_header_partner_address(
            EXPORTING
              iv_quotation_number = <lv_vbel>-vbeln
              iv_change_tdc   = ls_testdata
            IMPORTING
              ev_test_success = ev_execution_status
              et_return       = lt_return
          ).
          cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
          APPEND <lv_vbel>-vbeln TO ev_document_id.

        ENDIF.
      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD change_header_partner_address.
    DATA:
      ls_header_inx       TYPE bapisdh1x,
      ls_header_in        TYPE bapisdh1,
      lt_return	          TYPE cl_ptf_util=>gt_ptf_return_tab,
      ls_return           TYPE bapiret2,
      ls_partnerchange    TYPE bapiparnrc,
      ls_partneraddress   TYPE bapiaddr1,
      lt_doc_partners     TYPE TABLE OF bapiparnr,
      lt_partnerchanges   TYPE TABLE OF bapiparnrc,
      lt_partneraddresses TYPE TABLE OF bapiaddr1.

    DATA: lv_vbeln TYPE vbeln.
    MOVE iv_quotation_number TO lv_vbeln.

    LOOP AT iv_change_tdc-partner_change ASSIGNING FIELD-SYMBOL(<ls_partner_change>).
      MOVE-CORRESPONDING <ls_partner_change> TO ls_partnerchange.
      ls_partnerchange-document = lv_vbeln.
      APPEND ls_partnerchange TO lt_partnerchanges.
    ENDLOOP.

    LOOP AT iv_change_tdc-adress_data ASSIGNING FIELD-SYMBOL(<ls_adress_data>).
      APPEND <ls_adress_data> TO lt_partneraddresses.
    ENDLOOP.

    ls_header_in-qt_valid_t = iv_change_tdc-valid_to_date.
    ls_header_inx-updateflag  = 'U'.
    CLEAR et_return.

* execute the chnages
    CALL FUNCTION 'BAPI_CUSTOMERQUOTATION_CHANGE'
      EXPORTING
        salesdocument        = lv_vbeln   " Quotation Number
        quotation_header_in  = ls_header_in
        quotation_header_inx = ls_header_inx  " Sales Quotation Check List
      TABLES
        return               = et_return " Return Code
*       partners             = lt_doc_partners
        partnerchanges       = lt_partnerchanges
        partneraddresses     = lt_partneraddresses.

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

* check if the process ended without errors.
    LOOP AT et_return ASSIGNING FIELD-SYMBOL(<ls_ret_mes>).
      me->mo_run_environment->append_log( iv_log_statement = |{ <ls_ret_mes>-message }| ).
      IF <ls_ret_mes>-type CA 'E'.
        ev_test_success = abap_false.
        EXIT.
      ELSE.
        ev_test_success = abap_true.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD check.
    DATA: ls_testdata        TYPE cl_ptf_bo_or=>ty_gs_ptf_sd_check_td,
          lv_prestepnumber   TYPE LINE OF cl_ptf_util=>gt_ptf_step-reference_step,
          ls_check_step_data TYPE cl_ptf_util=>gt_ptf_step,
          lv_vbeln           TYPE vbeln,
          error_message      TYPE bapi_msg,
          ls_return          TYPE bapiret2,
          lv_step_success    TYPE abap_bool,
          var_step           TYPE string.

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

    lv_step_success = abap_true.
    CLEAR: lv_prestepnumber, ls_check_step_data.
    IF ls_testdata-vbak_check IS NOT INITIAL OR ls_testdata-vbap_check IS NOT INITIAL.

*  Check if reference step number for checking object is filled and reference object exists
      LOOP AT ls_step_data-reference_step INTO lv_prestepnumber.
        ls_check_step_data = me->mo_run_environment->get_step_data( iv_step_number = lv_prestepnumber ).
        IF ls_check_step_data-document_id IS INITIAL.
          lv_step_success = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = 'No reference document exists!' ).
        ELSE.
          IF ls_testdata-vbak_check IS NOT INITIAL.
            compare_vbak_data(
              EXPORTING
                is_testdata        = ls_testdata
                is_check_step_data = ls_check_step_data
                iv_run_environment = me->mo_run_environment
              RECEIVING
                rv_is_equal        = ev_check_status
            ).
            IF ev_check_status EQ abap_false.
              lv_step_success = abap_false.
            ENDIF.
          ENDIF.
          IF ls_testdata-vbap_check IS NOT INITIAL.
            compare_vbap_data(
              EXPORTING
                is_testdata        = ls_testdata
                is_check_step_data = ls_check_step_data
                iv_run_environment = me->mo_run_environment
              RECEIVING
                rv_is_equal        = ev_check_status
            ).
            IF ev_check_status EQ abap_false.
              lv_step_success = abap_false.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
    ev_check_status = lv_step_success.
** Output in case of success
    IF ev_check_status EQ abap_true.
      ev_execution_status = abap_true.
      var_step = ls_step_data-step_number.
      CONCATENATE 'The Values of the checked document are correct. Processstep is:' var_step   INTO error_message SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = |{ error_message }| ).
    ELSE.
      ev_execution_status = abap_true.
      var_step = ls_step_data-step_number.
      CONCATENATE 'The Values of the checked document are correct. Processstep is:' var_step   INTO error_message SEPARATED BY space.
      me->mo_run_environment->append_log( iv_log_statement = |{ error_message }| ).
    ENDIF.

  ENDMETHOD.


  METHOD check_existence.
    DATA: lv_vbeln TYPE vbeln.
    MOVE iv_id TO lv_vbeln.

    SELECT SINGLE * FROM vbak WHERE vbeln = @lv_vbeln INTO @DATA(ls_order).
    IF sy-subrc <> 0.
      me->mo_run_environment->append_log( iv_log_statement = |Quotation { lv_vbeln } does not exist.| ).
      rv_exists = abap_false.
    ELSE.
      rv_exists = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD check_partner.
    DATA: test_data TYPE ty_gs_ptf_sd_check_partner_td.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = test_data
    ).

    ev_check_status = abap_true.

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(doc_ids)  = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).

      LOOP AT doc_ids ASSIGNING FIELD-SYMBOL(<doc>).
        LOOP AT test_data-partner ASSIGNING FIELD-SYMBOL(<partner>).
          IF <partner>-item_number IS NOT INITIAL.
            SELECT SINGLE vbeln, posnr, parvw FROM vbpa  INTO @DATA(entry_pos) WHERE vbeln = @<doc>-vbeln AND posnr = @<partner>-item_number AND kunnr = @<partner>-customer AND parvw = @<partner>-role
                          AND adrda = @<partner>-adrda AND addr_type = @<partner>-addr_type.
          ELSE.
            SELECT SINGLE vbeln, posnr, parvw FROM vbpa INTO @DATA(entry) WHERE vbeln = @<doc>-vbeln AND kunnr = @<partner>-customer AND parvw = @<partner>-role
                          AND adrda = @<partner>-adrda AND addr_type = @<partner>-addr_type.
          ENDIF.
          IF sy-subrc <> 0.
            ev_check_status = abap_false.
            IF <partner>-item_number IS NOT INITIAL.
              me->mo_run_environment->append_log( iv_log_statement = |Partner { <partner>-role } { <partner>-customer } contains inconsistant data in SD { <doc>-vbeln } for position { <partner>-item_number }| ).
            ELSE.
              me->mo_run_environment->append_log( iv_log_statement = |Partner { <partner>-role } { <partner>-customer } contains inconsistant data in SD { <doc>-vbeln }| ).
            ENDIF.
          ENDIF."IF sy-subrc <> 0.
        ENDLOOP."LOOP AT test_data-partner ASSIGNING FIELD-SYMBOL(<partner>).
      ENDLOOP."LOOP AT doc_ids ASSIGNING FIELD-SYMBOL(<doc>).
    ENDLOOP."LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
    ev_execution_status = abap_true.
  ENDMETHOD.


  METHOD compare_vbak_data. "should be adapted to VBAK, lloks at VBAP

    DATA: ls_testdata        TYPE cl_ptf_bo_or=>ty_gs_ptf_sd_check_td,
          ls_vbap_check      TYPE sdbil_tst_vbap_check,
          lv_prestepnumber   TYPE LINE OF cl_ptf_util=>gt_ptf_step-reference_step,
          ls_check_step_data TYPE cl_ptf_util=>gt_ptf_step,
          lt_vbap            TYPE TABLE OF vbap,
          ls_vbap            TYPE vbap,
          ls_testdata_vbap   TYPE vbap,
          lv_vbeln           TYPE vbeln,
          lt_fieldinfo       TYPE extdfiest,
          ls_fieldinfo       TYPE LINE OF extdfiest,
          lv_fieldname       TYPE fieldname,
          lv_index           TYPE i,
          error_message      TYPE bapi_msg,
          ls_return          TYPE bapiret2,
          lv_input           TYPE string,
          msg_str1           TYPE string,
          msg_str2           TYPE string.

    TYPES:
      BEGIN OF ty_vbeln_orig,
        vbeln TYPE vbeln,
      END OF ty_vbeln_orig.
    DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.


    FIELD-SYMBOLS: <lv_testdata_value> TYPE any,
                   <lv_document_value> TYPE any,
                   <lv_fieldvalue>     TYPE any.

    ls_testdata = is_testdata.
    ls_check_step_data = is_check_step_data.
    rv_is_equal  = abap_true.

*  retrieve reference BOs from DB
    MOVE ls_check_step_data-document_id TO lt_vbeln_key.
    SELECT * FROM vbap INTO TABLE lt_vbap FOR ALL ENTRIES IN lt_vbeln_key
      WHERE vbeln = lt_vbeln_key-vbeln ORDER BY PRIMARY KEY.
    IF sy-subrc NE 0.
      rv_is_equal  = abap_false.
*  Check which vbeln was not found
      SORT ls_check_step_data-document_id BY vbeln.
      CLEAR lv_vbeln.
      LOOP AT ls_check_step_data-document_id INTO lv_vbeln.
        READ TABLE lt_vbap TRANSPORTING NO FIELDS WITH KEY vbeln = lv_vbeln.
        IF sy-subrc NE 0.
          rv_is_equal = abap_false.
          iv_run_environment->append_log( iv_log_statement = |No database entry was found with VBELN: { lv_vbeln }| ).
        ENDIF.
      ENDLOOP.
    ELSE.
*   get fieldinfo to check which fields of vbap structure have to be checked
      CLEAR lt_fieldinfo.
      CALL FUNCTION 'DD_INT_TABLINFO_GET'
        EXPORTING
          typename       = 'VBAP'
        TABLES
          extdfies_tab   = lt_fieldinfo
        EXCEPTIONS
          not_found      = 1
          internal_error = 2
          OTHERS         = 3.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

      DATA(lv_lines_with_flags) =    lines( ls_testdata-vbap_check ).
      "DATA(lv_lines_w_expctd_data) = lines( ls_testdata-vbap ).
      DATA(lv_lines_in_doc) =        lines( lt_vbap ).
      "if lv_lines_with_flags GT lv_lines_w_expctd_data.
      IF lv_lines_with_flags GT lv_lines_in_doc.
        rv_is_equal = abap_false.
        iv_run_environment->append_log( iv_log_statement = |The document has less items than expected. Items in VBAP: { lv_lines_in_doc }| ).
      ENDIF.

      lv_index = 0.
      LOOP AT ls_testdata-vbap_check INTO ls_vbap_check.
        lv_index = lv_index + 1.
        CLEAR ls_vbap.
        READ TABLE lt_vbap INTO ls_vbap INDEX lv_index.
        READ TABLE ls_testdata-vbap INTO ls_testdata_vbap INDEX lv_index.
        CLEAR ls_fieldinfo.
        LOOP AT lt_fieldinfo INTO ls_fieldinfo.
          ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbap_check TO <lv_fieldvalue>.
          IF sy-subrc EQ 0 AND <lv_fieldvalue> EQ 'X'.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbap TO <lv_document_value>.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_testdata_vbap TO <lv_testdata_value>.

* This method converts strings to corresponding system fields
            lv_input = ( <lv_testdata_value> ).
            TRY.
                cl_ptf_util=>get_syst_field(
                  EXPORTING
                    iv_field_name  = lv_input
                  IMPORTING
                    ev_field_value = <lv_testdata_value>
                ).
              CATCH cx_sy_dyn_call_illegal_type.
            ENDTRY.
            IF <lv_document_value> NE <lv_testdata_value>.
              rv_is_equal = abap_false.
              msg_str1 = <lv_testdata_value>.
              msg_str2 = <lv_document_value>.
              iv_run_environment->append_log( iv_log_statement = |Value of VBAP field { ls_fieldinfo-fieldname } is not as expected ({ msg_str1 }). Stored value is: { msg_str2 }| ).
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD compare_vbap_data.

    DATA: ls_testdata        TYPE cl_ptf_bo_or=>ty_gs_ptf_sd_check_td,
          ls_vbap_check      TYPE sdbil_tst_vbap_check,
          lv_prestepnumber   TYPE LINE OF cl_ptf_util=>gt_ptf_step-reference_step,
          ls_check_step_data TYPE cl_ptf_util=>gt_ptf_step,
          lt_vbap            TYPE TABLE OF vbap,
          ls_vbap            TYPE vbap,
          ls_testdata_vbap   TYPE vbap,
          lv_vbeln           TYPE vbeln,
          lt_fieldinfo       TYPE extdfiest,
          ls_fieldinfo       TYPE LINE OF extdfiest,
          lv_fieldname       TYPE fieldname,
          lv_index           TYPE i,
          error_message      TYPE bapi_msg,
          ls_return          TYPE bapiret2,
          lv_input           TYPE string,
          msg_str1           TYPE string,
          msg_str2           TYPE string.

    TYPES:
      BEGIN OF ty_vbeln_orig,
        vbeln TYPE vbeln,
      END OF ty_vbeln_orig.
    DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.


    FIELD-SYMBOLS: <lv_testdata_value> TYPE any,
                   <lv_document_value> TYPE any,
                   <lv_fieldvalue>     TYPE any.

    ls_testdata = is_testdata.
    ls_check_step_data = is_check_step_data.
    rv_is_equal  = abap_true.

*  retrieve reference BOs from DB
    MOVE ls_check_step_data-document_id TO lt_vbeln_key.
    SELECT * FROM vbap INTO TABLE lt_vbap FOR ALL ENTRIES IN lt_vbeln_key
      WHERE vbeln = lt_vbeln_key-vbeln ORDER BY PRIMARY KEY.
    IF sy-subrc NE 0.
      rv_is_equal  = abap_false.
*  Check which vbeln was not found
      SORT ls_check_step_data-document_id BY vbeln.
      CLEAR lv_vbeln.
      LOOP AT ls_check_step_data-document_id INTO lv_vbeln.
        READ TABLE lt_vbap TRANSPORTING NO FIELDS WITH KEY vbeln = lv_vbeln.
        IF sy-subrc NE 0.
          rv_is_equal = abap_false.
          iv_run_environment->append_log( iv_log_statement = |No database entry was found with VBELN: { lv_vbeln }| ).
        ENDIF.
      ENDLOOP.
    ELSE.
*   get fieldinfo to check which fields of vbap structure have to be checked
      CLEAR lt_fieldinfo.
      CALL FUNCTION 'DD_INT_TABLINFO_GET'
        EXPORTING
          typename       = 'VBAP'
        TABLES
          extdfies_tab   = lt_fieldinfo
        EXCEPTIONS
          not_found      = 1
          internal_error = 2
          OTHERS         = 3.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

      DATA(lv_lines_with_flags) =    lines( ls_testdata-vbap_check ).
      "DATA(lv_lines_w_expctd_data) = lines( ls_testdata-vbap ).
      DATA(lv_lines_in_doc) =        lines( lt_vbap ).
      "if lv_lines_with_flags GT lv_lines_w_expctd_data.
      IF lv_lines_with_flags GT lv_lines_in_doc.
        rv_is_equal = abap_false.
        iv_run_environment->append_log( iv_log_statement = |The document has less items than expected. Items in VBAP: { lv_lines_in_doc }| ).
      ENDIF.

      lv_index = 0.
      LOOP AT ls_testdata-vbap_check INTO ls_vbap_check.
        lv_index = lv_index + 1.
        CLEAR ls_vbap.
        READ TABLE lt_vbap INTO ls_vbap INDEX lv_index.
        READ TABLE ls_testdata-vbap INTO ls_testdata_vbap INDEX lv_index.
        CLEAR ls_fieldinfo.
        LOOP AT lt_fieldinfo INTO ls_fieldinfo.
          ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbap_check TO <lv_fieldvalue>.
          IF sy-subrc EQ 0 AND <lv_fieldvalue> EQ 'X'.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_vbap TO <lv_document_value>.
            ASSIGN COMPONENT ls_fieldinfo-fieldname OF STRUCTURE ls_testdata_vbap TO <lv_testdata_value>.

* This method converts strings to corresponding system fields
            lv_input = ( <lv_testdata_value> ).
            TRY.
                cl_ptf_util=>get_syst_field(
                  EXPORTING
                    iv_field_name  = lv_input
                  IMPORTING
                    ev_field_value = <lv_testdata_value>
                ).
              CATCH cx_sy_dyn_call_illegal_type.
            ENDTRY.
            IF <lv_document_value> NE <lv_testdata_value>.
              rv_is_equal = abap_false.
              msg_str1 = <lv_testdata_value>.
              msg_str2 = <lv_document_value>.
              iv_run_environment->append_log( iv_log_statement = |Value of VBAP field { ls_fieldinfo-fieldname } is not as expected ({ msg_str1 }). Stored value is: { msg_str2 }| ).
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD create.
    DATA: ls_testdata        TYPE ty_gs_i_ptf_quote_cr_td,
          ls_order_header_in TYPE bapisdhd1,
          lt_order_partners  TYPE TABLE OF bapiparnr,
          lt_order_items     TYPE TABLE OF bapisditm,
          lt_schedules       TYPE TABLE OF bapischdl,
          ls_return          TYPE bapiret2,
          lt_return          TYPE TABLE OF bapiret2,
          lv_vbeln           TYPE vbeln.
*****************************************************************************
* 1 Step: get tdcv
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).
*****************************************************************************
* 3 Step: Prepare Testdata for 'SD_SALESDOCUMENT_CREATE'
    CALL METHOD prepare_testdata_create
      EXPORTING
        ls_testdata        = ls_testdata
      IMPORTING
        ls_order_header_in = ls_order_header_in
        lt_order_partners  = lt_order_partners
        lt_order_items     = lt_order_items
        lt_schedules       = lt_schedules.
*****************************************************************************
* 4 Step: Create and commit Sales Order
    CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
      EXPORTING
        sales_header_in    = ls_order_header_in
      IMPORTING
        salesdocument_ex   = lv_vbeln
      TABLES
        return             = lt_return
        sales_items_in     = lt_order_items
        sales_partners     = lt_order_partners
        sales_schedules_in = lt_schedules.
    LOOP AT lt_return INTO DATA(lv_return).
      me->mo_run_environment->append_log( iv_log_statement = |Message: { lv_return-message } | ).
    ENDLOOP.

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).

*****************************************************************************
* 6 Step: Check whether Sales Order exists
    DATA: lv_ptf_key TYPE ptfkey.
    MOVE lv_vbeln TO lv_ptf_key.
    APPEND lv_vbeln TO ev_document_id.
    ev_execution_status = me->check_existence( iv_id = lv_ptf_key ).

  ENDMETHOD.


  METHOD create_with_reference.
    DATA:
      ls_testdata TYPE ty_gs_i_ptf_or_cr_td,
      lv_vbak     TYPE vbak.
*      lv_vbap     type vbap.

    DATA: ls_load_parameter TYPE tds_goal_so_load.
    DATA: ls_head_data TYPE tds_goal_so_head.
    DATA: lt_item_data TYPE STANDARD TABLE OF tds_goal_so_item.
    DATA: lo_access TYPE REF TO if_goal_access.
    DATA: ls_error TYPE if_goal_types=>tcs_error.
    DATA: lv_bo_key TYPE if_goal_types=>tcd_bo_key.
    DATA: lx_goal_exc TYPE REF TO cx_goal_exc.
    DATA: lv_text_exc TYPE string.
    DATA: ls_field_property TYPE if_goal_types=>tcs_object_property.
    DATA: lt_field_property TYPE if_goal_types=>tct_object_property.
    DATA: lt_message TYPE if_goal_types=>tct_message.
    DATA: iv_vbeln TYPE vbeln_va,
          lt_vbeln TYPE cl_ptf_util=>ty_vbeln_tab.

*****************************************************************************
* get tdcv
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata
    ).

    IF ls_testdata IS INITIAL. "Cannot merge both conditions, because ls_testdata could be null
      me->mo_run_environment->append_log( iv_log_statement = |Cannot delcare document type to be created .| ).
      ev_execution_status = abap_false.
      RETURN.
    ELSEIF ls_testdata-document_type IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Cannot delcare document type to be created .| ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.

*************************************************************************
*Check Predecessor Status
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    IF lt_vbeln IS NOT INITIAL.
      LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<lv_vbel>).
        SELECT SINGLE * FROM vbak WHERE vbeln = @<lv_vbel>-vbeln INTO @lv_vbak.
        IF lv_vbak IS INITIAL.
          "Document not found
          me->mo_run_environment->append_log( iv_log_statement = |Could not find Inquiry { <lv_vbel>-vbeln }.| ).
          ev_execution_status = abap_false.
          RETURN.
        ELSE.
          ls_load_parameter-type_code = ls_testdata-document_type.
          ls_load_parameter-ref_document_id = lv_vbak-vbeln.

          TRY.
              CALL METHOD cl_goal_api=>so_instance->create
                EXPORTING
                  iv_bo_id          = if_goal_sdoc=>co_bo_id-salesquotation
                  is_load_parameter = ls_load_parameter
                RECEIVING
                  ro_access         = lo_access.
            CATCH cx_goal_exc INTO lx_goal_exc.
              me->mo_run_environment->append_log( iv_log_statement = lx_goal_exc->get_text( ) ).
              ev_execution_status = abap_false.
              "lv_text_exc = lx_goal_exc->get_text( ).
              "MESSAGE lv_text_exc TYPE 'I'.
              EXIT.
          ENDTRY.

***************************************************************************
* read header data
          CALL METHOD lo_access->get_entity
            EXPORTING
              iv_entity_id   = if_goal_sdoc_head=>co_entity_id
            IMPORTING
              es_entity_data = ls_head_data.
* read item data
          CALL METHOD lo_access->get_entity_set
            EXPORTING
              iv_entity_id      = if_goal_sdoc_item=>co_entity_id
              iv_handle_parent  = ls_head_data-handle
            IMPORTING
              et_entity_data    = lt_item_data
              et_field_property = lt_field_property.
***************************************************************************
          lo_access->save( IMPORTING ev_bo_key = iv_vbeln ).

          IF iv_vbeln IS NOT INITIAL.
            me->mo_run_environment->append_log( iv_log_statement = |Created sales quotation with ID: { iv_vbeln }.| ).
            APPEND iv_vbeln TO ev_document_id.
            ev_execution_status = abap_true.
          ELSE.
            me->mo_run_environment->append_log( iv_log_statement = |Could not create sales quotation.| ).
            ev_execution_status = abap_false.
            RETURN.
          ENDIF.

        ENDIF.

      ENDLOOP.


      DATA: lv_ptf_key TYPE ptfkey.
      MOVE iv_vbeln TO lv_ptf_key.
      cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
    ENDIF.

  ENDMETHOD.


  METHOD delete.
  ENDMETHOD.


  METHOD execute_action.
    DATA(lv_step_data) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).

    CASE lv_step_data-action.
      WHEN c_create_with_reference.
        me->create_with_reference(
      EXPORTING
        step_data           = lv_step_data
        iv_step_number      = iv_step_number
      IMPORTING
        ev_document_id      = ev_document_id
        ev_execution_status = ev_execution_status
        ev_check_status     = ev_check_status
    ).
        RETURN.
        RETURN.
      WHEN OTHERS.
        me->mo_run_environment->append_log( iv_log_statement =  |Could not find method { lv_step_data-action } for the BO { lv_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.
    ENDCASE.
  ENDMETHOD.


  METHOD execute_check.
    DATA(lv_step_data) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).

    CASE lv_step_data-action.
      WHEN c_check_partner.
        me->check_partner(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN OTHERS.
        me->mo_run_environment->append_log( iv_log_statement =  |Could not find method { lv_step_data-action } for the BO { lv_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.
    ENDCASE.

  ENDMETHOD.


  METHOD prepare_testdata_create.

    DATA: ls_order_partners TYPE bapiparnr,
          ls_order_items    TYPE bapisditm,
          ls_schedules      TYPE bapischdl.

    ls_order_header_in-doc_type = ls_testdata-document_type.
    ls_order_header_in-sales_org = ls_testdata-sales_organization.
    ls_order_header_in-distr_chan = ls_testdata-distribution_channel.
    ls_order_header_in-division = ls_testdata-division.
    ls_order_header_in-ord_reason = ls_testdata-order_reason.
    ls_order_header_in-qt_valid_t = ls_testdata-valid_to_date.
    ls_order_header_in-purch_no_c = ls_testdata-purch_number.
    ls_order_partners-partn_role = 'AG'.
*    ls_order_partners-partn_numb = ls_data_order-customer_id.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = ls_testdata-customer_id " C field
      IMPORTING
        output = ls_order_partners-partn_numb.

    APPEND  ls_order_partners TO  lt_order_partners.

    LOOP AT ls_testdata-item_list ASSIGNING FIELD-SYMBOL(<ls_order_item_list>).
      ls_order_items-itm_number = <ls_order_item_list>-posnr.
      ls_order_items-material =  <ls_order_item_list>-material_id.
      ls_order_items-target_qty = <ls_order_item_list>-quantity.
      ls_order_items-plant = <ls_order_item_list>-werks.
      ls_order_items-item_categ = <ls_order_item_list>-item_category.
      APPEND ls_order_items TO lt_order_items.

      ls_schedules-itm_number = <ls_order_item_list>-posnr.
      ls_schedules-req_qty    = <ls_order_item_list>-quantity.
      ls_schedules-req_date    = sy-datum.
      APPEND ls_schedules TO lt_schedules.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
