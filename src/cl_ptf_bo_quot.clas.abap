class CL_PTF_BO_QUOT definition
  public
  inheriting from CL_PTF_BO
  final
  create public .

public section.

  types:
    ty_gt_code_line type standard table of string with default key .
  types:
    begin of ty_gs_dynamic_code,
        code        type string,
        description type string,
      end of ty_gs_dynamic_code .
  types:
    ty_gt_dynamic_code type standard table of ty_gs_dynamic_code with default key .
  types:
    begin of ty_gs_relative_date,
        date_field_name type string,
        offset_in_days  type i,
      end of ty_gs_relative_date .
  types:
    ty_gt_relative_date type standard table of ty_gs_relative_date with default key .
  types:
    begin of ty_gs_field,
        name type string,
      end of ty_gs_field .
  types:
    ty_gt_field type standard table of ty_gs_field with default key .
  types:
    begin of ty_gs_sline,
        unconditional_take_over_fields type ty_gt_field,
        relative_dates                 type ty_gt_relative_date,
        delete_entry                   type abap_bool.
        include type tds_goal_sdoc_sline as goal_data.
    " include type tds_goal_so_sline as goal_data.
    types:
    end of ty_gs_sline .
  types:
    ty_gt_sline type standard table of ty_gs_sline with default key .
  types:
    begin of ty_gs_party,
        unconditional_take_over_fields type ty_gt_field.
        include type tds_goal_basic_party as goal_data.
    types:
      end of ty_gs_party .
  types:
    ty_gt_party type standard table of ty_gs_party with default key .
  types:
    begin of ty_gs_text,
        unconditional_take_over_fields type ty_gt_field.
        include type tds_goal_basic_text as goal_data.
    types:
      end of ty_gs_text .
  types:
    ty_gt_text type standard table of ty_gs_text with default key .
  types:
    begin of ty_gs_pricecondition,
        unconditional_take_over_fields type ty_gt_field.
        include type tds_goal_basic_cond as goal_data.
    types:
      end of ty_gs_pricecondition .
  types:
    ty_gt_pricecondition type standard table of ty_gs_pricecondition with default key .
  types:
    begin of ty_gs_item,
        unconditional_take_over_fields type ty_gt_field,
        relative_dates                 type ty_gt_relative_date,
        delete_entry                   type abap_bool,
        sline_list                     type ty_gt_sline,
        party_list                     type ty_gt_party,
        text_list                      type ty_gt_text,
        pricecondition_list            type ty_gt_pricecondition,
        wbs_relative_number            type int2.
        include type tds_goal_quot_item as goal_data.
    types:
      end of ty_gs_item .
  types:
    ty_gt_item type standard table of ty_gs_item with default key .
  types:
    begin of ty_gs_head,
        unconditional_take_over_fields type ty_gt_field,
        relative_dates                 type ty_gt_relative_date,
        party_list                     type ty_gt_party,
        text_list                      type ty_gt_text,
        pricecondition_list            type ty_gt_pricecondition.
        include type tds_goal_quot_head as goal_data.
    types:
      end of ty_gs_head .
  types:
    begin of ty_gs_i_ptf_quot_cr_td,
        goal_bo_id               type tabname,
        " vcm_run_sync             type abap_bool,
        head                     type ty_gs_head,
        item_list                type ty_gt_item,
        dynamic_testdata_changes type ty_gt_dynamic_code,
        goal_scenario_ids        type tdt_scenario_id,
      end of ty_gs_i_ptf_quot_cr_td .
  types:
    begin of ty_gs_ptf_check_rpts_td,
        idle_seconds  type i,  " Idle Seconds Before Start
        max_repeats   type i,  " Maximum Number of Repeats
        break_seconds type i,  " Break Seconds Between Repeats
      end of ty_gs_ptf_check_rpts_td .
  types:
    begin of ty_gs_text_check_data,
        text_id        type tdid,
        language       type sylangu,
        text_reference type string,
        check_no_entry type abap_bool,
      end of ty_gs_text_check_data .
  types:
    ty_gt_text_check_data type standard table of ty_gs_text_check_data with default key .
  types:
    begin of ty_gs_condition,
        field_name type string,
        operator   type c length 2,
        value      type string,
      end of ty_gs_condition .
  types:
    ty_gt_condition type standard table of ty_gs_condition with default key .
  types:
    begin of ty_gs_sline_check_data,
        sline_id              type etenr,
        dynamic_selection_key type ty_gt_condition,
        check_conditions      type ty_gt_condition,
        dynamic_dates         type ty_gt_relative_date,
        description           type c length 30,
      end of ty_gs_sline_check_data .
  types:
    ty_gt_sline_check_data type standard table of ty_gs_sline_check_data with default key .
  types:
    begin of ty_gs_partner_check_data,
        partner_function         type parvw,
        check_conditions         type ty_gt_condition,
        check_address_conditions type ty_gt_condition,
      end of ty_gs_partner_check_data .
  types:
    ty_gt_partner_check_data type standard table of ty_gs_partner_check_data with default key .
  types:
    begin of ty_gs_price_check_data,
        kschl                type kscha,
        check_conditions     type ty_gt_condition,
        entry_must_not_exist type abap_bool,
      end of ty_gs_price_check_data .
  types:
    ty_gt_price_check_data type standard table of ty_gs_price_check_data with default key .
  types:
    begin of ty_gs_item_check_data,
        item_id                        type posnr,
        dynamic_selection_key          type ty_gt_condition,
        check_conditions               type ty_gt_condition,
        dynamic_dates                  type ty_gt_relative_date,
        sline_check_data               type ty_gt_sline_check_data,
        partner_check_data             type ty_gt_partner_check_data,
        business_data_check_conditions type ty_gt_condition,
        text_check_data                type ty_gt_text_check_data,
        price_check_data               type ty_gt_price_check_data,
        price_check_suppl_data         type ty_gt_price_check_data,
        description                    type c length 30,
      end of ty_gs_item_check_data .
  types:
    ty_gt_quot_item_check_data type standard table of ty_gs_item_check_data with default key .
  types:
    begin of ty_gs_quot_check_data,
        head_check_conditions          type ty_gt_condition,
        dynamic_dates                  type ty_gt_relative_date,
        item_check_data                type ty_gt_quot_item_check_data,
        partner_check_data             type ty_gt_partner_check_data,
        business_data_check_conditions type ty_gt_condition,
        text_check_data                type ty_gt_text_check_data,
        dynamic_custom_checks          type ty_gt_dynamic_code,
      end of ty_gs_quot_check_data .

  constants C_WAIT type STRING value 'WAIT' ##NO_TEXT.

  methods LOG_GOAL_MESSAGES
    exporting
      !IO_GOAL_ACCESS type ref to IF_GOAL_ACCESS
    returning
      value(RV_ERROR_OCCURED) type ABAP_BOOL .
  methods WAIT
    importing
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
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
  protected section.
private section.

  types:
    ty_lt_vbap_sample type standard table of vbap with default key .
  types:
    begin of lty_suppl_data,
        kposn           type kposn,
        kschl           type kscha,
        konv_suppl_data type konv_suppl_data,
      end of lty_suppl_data .
  types:
    ltty_suppl_data type sorted table of lty_suppl_data with non-unique key kposn kschl .

  methods RUN_DYNAMIC_TEST_DATA_CHANGES
    importing
      !IV_STEP_NUMBER type I
      !IT_DYNAMIC_CODE type TY_GT_DYNAMIC_CODE
    exporting
      !EV_IMMEDIATE_EXIT type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
    changing
      !CS_QUOT_TEST_DATA type TY_GS_I_PTF_QUOT_CR_TD optional
    returning
      value(RV_EXECUTION_STATUS) type ABAP_BOOL .
  methods RUN_CUSTOM_DYNAMIC_CHECKS
    importing
      !IV_STEP_NUMBER type I
      !IT_DYNAMIC_CODE type TY_GT_DYNAMIC_CODE
    exporting
      !EV_IMMEDIATE_EXIT type ABAP_BOOL
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
    changing
      !CS_QUOT_TEST_DATA type TY_GS_QUOT_CHECK_DATA optional
    returning
      value(RV_CHECK_STATUS) type ABAP_BOOL .
  methods MERGE_GOAL_QUOTATION
    importing
      !IO_GOAL_ACCESS type ref to IF_GOAL_ACCESS
    changing
      !CS_QUOTATION_TEST_DATA type TY_GS_I_PTF_QUOT_CR_TD .
  methods SET_RELATIVE_DATES
    importing
      !IT_RELATIVE_DATES type TY_GT_RELATIVE_DATE
    changing
      !CS_ENTITY_TEST_DATA type DATA .
  methods MERGE_GOAL_ENTITY_TEST_DATA
    importing
      !IS_ENTITY_TEST_DATA type DATA
      !IT_UNCNDNL_TAKE_OVER_FIELDS type TY_GT_FIELD
    exporting
      !ES_CHANGED_FIELD type IF_GOAL_TYPES=>TCS_CHANGED_FIELD
    changing
      !CS_ENTITY_DATA type DATA .
  methods EVALUATE_CHECK_CONDITION
    importing
      !IS_DATA type DATA
      !IS_CONDITION type TY_GS_CONDITION
      !IV_VERBOSE_MODE type ABAP_BOOL default ABAP_TRUE
    returning
      value(RV_CONDITION_RESULT) type ABAP_BOOL .
ENDCLASS.



CLASS CL_PTF_BO_QUOT IMPLEMENTATION.


  method change.

    data: ls_testdata       type ty_gs_i_ptf_quot_cr_td,
          lv_immediate_exit type abap_bool.

    ev_execution_status = abap_false.
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata( exporting is_step_data = ls_step_data
                               importing es_testdata  = ls_testdata ).

    if ls_testdata-dynamic_testdata_changes is not initial.
      ev_execution_status = me->run_dynamic_test_data_changes(
        exporting
          iv_step_number    = iv_step_number
          it_dynamic_code   = ls_testdata-dynamic_testdata_changes
        importing
          ev_immediate_exit = lv_immediate_exit
          ev_document_id    = ev_document_id
        changing
          cs_quot_test_data = ls_testdata
      ).
      check lv_immediate_exit = abap_false.
    endif.

    if ls_testdata-goal_bo_id is initial.
      ls_testdata-goal_bo_id = if_goal_sdoc=>co_bo_id-salesquotation.
    endif.

    loop at ls_step_data-reference_step assigning field-symbol(<prestep_numbr>).
      data(ls_step_precessor) = me->mo_run_environment->get_step_data( iv_step_number = <prestep_numbr> ).
      move ls_step_precessor-document_id to ev_document_id.
      loop at ev_document_id  assigning field-symbol(<vbeln>).
        try.
            data(lo_goal_access) = cl_goal_api=>so_instance->open(
              exporting
                iv_bo_id            = ls_testdata-goal_bo_id
                iv_bo_key           = <vbeln>-vbeln && ''
                iv_read_only        = abap_false
                is_control_settings = value if_goal_access=>tcs_control_settings( no_conversion = abap_true )
                it_scenario_id      = ls_testdata-goal_scenario_ids ).
            merge_goal_quotation(
              exporting
                io_goal_access         = lo_goal_access
              changing
                cs_quotation_test_data = ls_testdata ).
            lo_goal_access->save( exporting iv_synchron = abap_true ).
            data(lv_error_occured) = log_goal_messages(
              importing
                io_goal_access = lo_goal_access ).
            lo_goal_access->close( ).
            if lv_error_occured = abap_true.
              exit.
            endif.

          catch cx_goal_exc into data(lx_goal_exc).
            cl_message_helper=>set_msg_vars_for_if_t100_msg( lx_goal_exc ).
            me->mo_run_environment->append_log( iv_log_statement = |{ lx_goal_exc->get_text( ) }| ).
            exit.
        endtry.
      endloop.
    endloop.
    ev_execution_status = abap_true.
  endmethod.


  method check.

    data:
      lv_vbeln          type vbeln,
      ls_testdata       type ty_gs_quot_check_data,
      lt_vbap_sample    type table of vbap,
      lt_vbep_sample    type table of vbep,
      lc_posnr_initial  type posnr value '000000',
      lv_date           like sy-datum,
      ls_result_key     type cl_ptf_util=>ty_result_key_data,
      lt_lines          type standard table of tline,
      lt_inlines        type standard table of tline,
      ls_suppl_data     type lty_suppl_data,
      lt_suppl_data     type ltty_suppl_data,
      lv_immediate_exit type abap_bool.

    field-symbols:
      <fs_vbkd> type vbkd,
      <fs_vbpa> type vbpa,
      <fs_adrc> type adrc.

    ev_check_status = abap_true.

    " get sample vbeln
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    if lines( ls_step_data-reference_step ) = 1.
      data(ls_reference_step) = me->mo_run_environment->get_step_data( iv_step_number = ls_step_data-reference_step[ 1 ] ).
      if ls_reference_step-document_id is not initial.
        lv_vbeln = ls_reference_step-document_id[ 1 ].
      endif.
    else.
      data(lt_result_key_data) =  me->mo_run_environment->get_result_key_data( it_step_number =  ls_step_data-reference_step ) .
      loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
        read table lt_result_key_data with key step_number = <lv_ref_step> into ls_result_key.
        case ls_result_key-bus_obj .
          when 'QUOT'.
            data(lt_vbeln) =  me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
            if lt_vbeln is not initial .
              lv_vbeln = lt_vbeln[ 1 ].
            endif.
        endcase.
      endloop.
    endif.
    if lv_vbeln is initial.
      me->mo_run_environment->append_log( iv_log_statement = 'Error: No document id provided by reference step' ).
      ev_check_status = abap_false.
      return.
    endif.

    " get check data
    cl_ptf_util=>get_testdata( exporting is_step_data = ls_step_data
                               importing es_testdata  = ls_testdata ).

    " run custom dynamic checks
    if ls_testdata-dynamic_custom_checks is not initial.
      ev_check_status = me->run_custom_dynamic_checks(
        exporting
          iv_step_number    = iv_step_number
          it_dynamic_code   = ls_testdata-dynamic_custom_checks
        importing
          ev_immediate_exit = lv_immediate_exit
          ev_document_id    = ev_document_id
        changing
          cs_quot_test_data = ls_testdata ).
      check lv_immediate_exit = abap_false.
    endif.

    " read tables
    select single * from vbak into @data(ls_vbak) where vbeln = @lv_vbeln.
    if sy-subrc <> 0.
      me->mo_run_environment->append_log( |Error: VBAK entry for vbeln = { lv_vbeln } does not exist.| ).
      ev_check_status = abap_false.
      return.
    endif.
    select * from vbap into table @data(lt_vbap) where vbeln = @lv_vbeln.
    select * from vbep into table @data(lt_vbep) where vbeln = @lv_vbeln.
    select * from vbpa into table @data(lt_vbpa) where vbeln = @lv_vbeln.
    select * from vbkd into table @data(lt_vbkd) where vbeln = @lv_vbeln.
    if lt_vbpa[] is not initial.
      select * from adrc into table @data(lt_adrc) for all entries in @lt_vbpa where addrnumber = @lt_vbpa-adrnr.
    endif.
    select * from prcd_elements into table @data(lt_prcd_elememts) where knumv = @ls_vbak-knumv.

    "Read condition supplement data
    loop at lt_prcd_elememts reference into data(lr_prcd_elememts)
         where common_suppl_data eq abap_true.
      clear ls_suppl_data.
      data(lv_suppl_data_guid) = cl_prc_suppl_data_factory=>factory->get_handler_by_knumv( ls_vbak-knumv )->get_db_guid(
                                                                                                              iv_knumv = lr_prcd_elememts->knumv
                                                                                                              iv_kposn = lr_prcd_elememts->kposn
                                                                                                              iv_kschl = lr_prcd_elememts->kschl
                                                                                                              iv_stunr = lr_prcd_elememts->stunr
                                                                                                              iv_zaehk = lr_prcd_elememts->zaehk ).
      check lv_suppl_data_guid is not initial.
      ls_suppl_data-konv_suppl_data = cl_prc_suppl_data_factory=>factory->get_handler_by_knumv( ls_vbak-knumv )->get_suppl_data( lv_suppl_data_guid ).
      check ls_suppl_data-konv_suppl_data is not initial.
      ls_suppl_data-kposn = lr_prcd_elememts->kposn.
      ls_suppl_data-kschl = lr_prcd_elememts->kschl.
      insert ls_suppl_data into table lt_suppl_data.
    endloop.

    " Prepare header data with dynamic dates
    loop at ls_testdata-dynamic_dates reference into data(lr_dynamic_date_head).
      check lr_dynamic_date_head->date_field_name is not initial.
      split lr_dynamic_date_head->date_field_name at '-' into data(lv_table_name) data(lv_field_name).
      if lv_field_name is initial.
        lv_field_name = lv_table_name.
        lv_table_name = ''.
      endif.
      check lv_field_name is not initial.

      case lv_table_name.
        when 'VBAK' or 'vbak' or ''.
          loop at ls_testdata-head_check_conditions reference into data(lr_head_check_condition) where field_name = lr_dynamic_date_head->date_field_name.
            lv_date = sy-datum + lr_dynamic_date_head->offset_in_days.
            lr_head_check_condition->value = lv_date.
          endloop.
        when 'VBKD' or 'vbkd'.
          loop at ls_testdata-business_data_check_conditions reference into data(lr_business_data_check_cond) where field_name = lr_dynamic_date_head->date_field_name.
            lv_date = sy-datum + lr_dynamic_date_head->offset_in_days.
            lr_business_data_check_cond->value = lv_date.
          endloop.
      endcase.

    endloop.

    " Check header data
    loop at ls_testdata-head_check_conditions assigning field-symbol(<fs_head_check_condition>).
      if evaluate_check_condition( is_data = ls_vbak is_condition = <fs_head_check_condition> ) = abap_false.
        ev_check_status = abap_false.
      endif.
    endloop.

    " Check business data on header level
    assign lt_vbkd[ posnr = lc_posnr_initial ] to <fs_vbkd>.
    loop at ls_testdata-business_data_check_conditions assigning field-symbol(<fs_head_bd_check_condition>).
      if evaluate_check_condition( is_data = <fs_vbkd> is_condition = <fs_head_bd_check_condition> ) = abap_false.
        ev_check_status = abap_false.
      endif.
    endloop.

    " Check partner data on header level
    loop at ls_testdata-partner_check_data reference into data(lr_partner_check_data_head).
      if line_exists( lt_vbpa[ posnr = lc_posnr_initial parvw = lr_partner_check_data_head->partner_function ] ).
        assign lt_vbpa[ posnr = lc_posnr_initial parvw = lr_partner_check_data_head->partner_function ] to <fs_vbpa>.
        loop at lr_partner_check_data_head->check_conditions assigning field-symbol(<fs_partner_check_condition_h>).
          if evaluate_check_condition( is_data = <fs_vbpa> is_condition = <fs_partner_check_condition_h> ) = abap_false.
            ev_check_status = abap_false.
          endif.
        endloop.
        unassign <fs_adrc>.
        assign lt_adrc[ addrnumber = <fs_vbpa>-adrnr ] to <fs_adrc>.
        if sy-subrc = 0.
          loop at lr_partner_check_data_head->check_address_conditions assigning field-symbol(<fs_address_check_condition_h>).
            if evaluate_check_condition( is_data = <fs_adrc> is_condition = <fs_address_check_condition_h> ) = abap_false.
              ev_check_status = abap_false.
            endif.
          endloop.
        else.
          me->mo_run_environment->append_log( |'Error: Address details not found for address number { <fs_vbpa>-adrnr } from VBPA| ).
          ev_check_status = abap_false.
        endif.
      else.
        me->mo_run_environment->append_log( |'Error: VBPA entry for partner function { lr_partner_check_data_head->partner_function } does not exist.| ).
        ev_check_status = abap_false.
      endif.
    endloop.

    " Check head texts
    if ls_testdata-text_check_data is not initial.
      me->mo_run_environment->append_log( 'Comparing header text with reference).' ).
      loop at ls_testdata-text_check_data reference into data(lr_head_text_check_data).
        call function 'READ_TEXT_INLINE'
          exporting
            id              = lr_head_text_check_data->text_id  "Text ID of text to be read
            inline_count    = 2                            " Number of lines for inline table
            language        = lr_head_text_check_data->language      " Language of text to be read
            name            = conv tdobname( lv_vbeln && '' )             " Name of text to be read
            object          = conv tdobject( 'VBBK' ) "Object of text to be read
          tables
            inlines         = lt_inlines[]     "
            lines           = lt_lines[]       " Lines of text read
          exceptions
            id              = 1                " Text ID invalid
            language        = 2                " Invalid language
            name            = 3                " Invalid text name
            not_found       = 4                " Text not found
            object          = 5                " Invalid text object
            reference_check = 6                " Reference chain cancelled
            others          = 7.
        if sy-subrc <> 0.
          if lr_head_text_check_data->check_no_entry = abap_false.
            ev_check_status = abap_false.
            me->mo_run_environment->append_log( |Error: No head text entry found for (id = { lr_head_text_check_data->text_id }, language = { lr_head_text_check_data->language }).| ).
          endif.
        elseif lr_head_text_check_data->check_no_entry = abap_true.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( |Error: An entry for (id = { lr_head_text_check_data->text_id }, language = { lr_head_text_check_data->language }) has been found but should not exist.| ).
          continue.
        endif.

        if not ( lr_head_text_check_data->text_reference is initial and lt_lines[] is initial     " in case text is empty and also no line was created in text
          or lines( lt_lines[] ) > 0 and lt_lines[ 1 ]-tdline = lr_head_text_check_data->text_reference ).
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( |Error: Head text entry is not equal to reference (id = { lr_head_text_check_data->text_id }, language = { lr_head_text_check_data->language }).| ).
          me->mo_run_environment->append_log( |Reference text: { lr_head_text_check_data->text_reference } | ).
          if lt_lines[] is initial.
            me->mo_run_environment->append_log( 'Actual text is empty.' ).
          else.
            me->mo_run_environment->append_log( |Actual text:' { lt_lines[ 1 ]-tdline }'| ).
          endif.
        endif.
      endloop.
    endif.


    " Check item data
    loop at ls_testdata-item_check_data reference into data(lr_item_check_data).
      clear lt_vbap_sample.
      me->mo_run_environment->append_log( |{ sy-tabix } item check ( { lr_item_check_data->description } ).| ).

      " Prepare item data with dynamic dates
      loop at lr_item_check_data->dynamic_dates reference into data(lr_dynamic_date_item).
        check lr_dynamic_date_item->date_field_name is not initial.
        split lr_dynamic_date_item->date_field_name at '-' into lv_table_name lv_field_name.
        if lv_field_name is initial.
          lv_field_name = lv_table_name.
          lv_table_name = ''.
        endif.
        check lv_field_name is not initial.

        case lv_table_name.
          when 'VBAK' or 'vbak' or ''.
            loop at lr_item_check_data->check_conditions reference into data(lr_item_check_condition) where field_name = lv_field_name.
              lv_date = sy-datum + lr_dynamic_date_item->offset_in_days.
              lr_item_check_condition->value = lv_date.
            endloop.
          when 'VBKD' or 'vbkd'.
            loop at lr_item_check_data->business_data_check_conditions reference into lr_business_data_check_cond where field_name = lv_field_name.
              lv_date = sy-datum + lr_dynamic_date_head->offset_in_days.
              lr_business_data_check_cond->value = lv_date.
            endloop.
        endcase.
      endloop.

      " get vbap entries by item id or selection criteria
      if lr_item_check_data->item_id is initial.
        loop at lt_vbap assigning field-symbol(<fs_vbap>).
          data(lv_vbap_valid) = abap_true.
          loop at lr_item_check_data->dynamic_selection_key assigning field-symbol(<fs_item_dynamic_select_key>).
            if evaluate_check_condition( is_data = <fs_vbap> is_condition = <fs_item_dynamic_select_key> iv_verbose_mode = abap_false ) = abap_false.
              lv_vbap_valid = abap_false.
            endif.
          endloop.
          if lv_vbap_valid = abap_true.
            insert <fs_vbap> into table lt_vbap_sample.
          endif.
        endloop.
      else.
        if line_exists( lt_vbap[ posnr = lr_item_check_data->item_id ] ).
          insert lt_vbap[ posnr = lr_item_check_data->item_id ] into table lt_vbap_sample.
        endif.
      endif.

      " check if at least one vbap entry is found
      if lt_vbap_sample is initial.
        if lr_item_check_data->item_id is initial.
          me->mo_run_environment->append_log( 'Warning: No VBAP entry found for item_check_data selection criteria.' ).
        else.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( 'Error: No VBAP entry found for item_check_data selection criteria.' ).
        endif.
      endif.

      loop at lt_vbap_sample assigning field-symbol(<fs_vbap_sample>).
        me->mo_run_environment->append_log( 'Comparing to VBAP / VBKD / VBPA entry with posnr = ' && <fs_vbap_sample>-posnr && '.' ).
        loop at lr_item_check_data->check_conditions assigning field-symbol(<fs_item_check_condition>).
          if evaluate_check_condition( is_data = <fs_vbap_sample> is_condition = <fs_item_check_condition> ) = abap_false.
            ev_check_status = abap_false.
          endif.
        endloop.

        " Check business data on item level
        if lr_item_check_data->business_data_check_conditions is not initial.
          assign lt_vbkd[ posnr = lc_posnr_initial ] to <fs_vbkd>.
          if line_exists( lt_vbkd[ posnr = <fs_vbap_sample>-posnr ] ).
            assign lt_vbkd[ posnr = <fs_vbap_sample>-posnr ] to <fs_vbkd>.
          endif.
          loop at lr_item_check_data->business_data_check_conditions assigning field-symbol(<fs_item_bd_check_condition>).
            if evaluate_check_condition( is_data = <fs_vbkd> is_condition = <fs_item_bd_check_condition> ) = abap_false.
              ev_check_status = abap_false.
            endif.
          endloop.
        endif.

        " Check partner data on item level
        loop at lr_item_check_data->partner_check_data reference into data(lr_partner_check_data_item).
          unassign <fs_vbpa>.
          if line_exists( lt_vbpa[ posnr = <fs_vbap_sample>-posnr parvw = lr_partner_check_data_item->partner_function ] ).
            assign lt_vbpa[ posnr = <fs_vbap_sample>-posnr parvw = lr_partner_check_data_item->partner_function ] to <fs_vbpa>.
          elseif line_exists( lt_vbpa[ posnr = lc_posnr_initial parvw = lr_partner_check_data_item->partner_function ] ).
            assign lt_vbpa[ posnr = lc_posnr_initial parvw = lr_partner_check_data_item->partner_function ] to <fs_vbpa>.
          else.
            me->mo_run_environment->append_log( |Error: VBPA entry for partner function ' { lr_partner_check_data_item->partner_function } does not exist.| ).
            ev_check_status = abap_false.
            continue.
          endif.
          loop at lr_partner_check_data_item->check_conditions assigning field-symbol(<fs_partner_check_condition_i>).
            if evaluate_check_condition( is_data = <fs_vbpa> is_condition = <fs_partner_check_condition_i> ) = abap_false.
              ev_check_status = abap_false.
            endif.
          endloop.
          unassign <fs_adrc>.
          assign lt_adrc[ addrnumber = <fs_vbpa>-adrnr ] to <fs_adrc>.
          if sy-subrc = 0.
            loop at lr_partner_check_data_item->check_address_conditions assigning field-symbol(<fs_address_check_condition_i>).
              if evaluate_check_condition( is_data = <fs_adrc> is_condition = <fs_address_check_condition_i> ) = abap_false.
                ev_check_status = abap_false.
              endif.
            endloop.
          else.
            me->mo_run_environment->append_log( |Error: Address details not found for address number { <fs_vbpa>-adrnr } from VBPA| ).
            ev_check_status = abap_false.
          endif.
        endloop.

        " Check price condition on item level
        loop at lr_item_check_data->price_check_data reference into data(lr_price_check_data_item).
          if line_exists( lt_prcd_elememts[ kposn = <fs_vbap_sample>-posnr kschl = lr_price_check_data_item->kschl ] )
            and lr_price_check_data_item->entry_must_not_exist = abap_false.
            assign lt_prcd_elememts[ kposn = <fs_vbap_sample>-posnr kschl = lr_price_check_data_item->kschl ]
                to field-symbol(<fs_prcd_element>).
            loop at lr_price_check_data_item->check_conditions assigning field-symbol(<fs_price_check_condition_i>).
              if evaluate_check_condition( is_data = <fs_prcd_element> is_condition = <fs_price_check_condition_i> ) = abap_false.
                ev_check_status = abap_false.
              endif.
            endloop.
          elseif line_exists( lt_prcd_elememts[ kposn = <fs_vbap_sample>-posnr kschl = lr_price_check_data_item->kschl ] )
            and lr_price_check_data_item->entry_must_not_exist = abap_true.
            me->mo_run_environment->append_log( |'Error: Condition { <fs_vbap_sample>-posnr } { lr_price_check_data_item->kschl } exists but it shouldn''t| ).
            ev_check_status = abap_false.
          elseif lr_price_check_data_item->entry_must_not_exist = abap_false.
            me->mo_run_environment->append_log( |'Error: Condition { <fs_vbap_sample>-posnr } { lr_price_check_data_item->kschl } not found| ).
            ev_check_status = abap_false.
          endif.
        endloop.

        " Check price condition supplement data on item level
        loop at lr_item_check_data->price_check_suppl_data reference into data(lr_price_check_suppl_data_item).
          if line_exists( lt_suppl_data[ kposn = <fs_vbap_sample>-posnr kschl = lr_price_check_suppl_data_item->kschl ] )
            and lr_price_check_suppl_data_item->entry_must_not_exist = abap_false.
            assign lt_suppl_data[ kposn = <fs_vbap_sample>-posnr kschl = lr_price_check_suppl_data_item->kschl ]-konv_suppl_data
              to field-symbol(<fs_suppl_data>).
            loop at lr_price_check_suppl_data_item->check_conditions assigning field-symbol(<fs_suppl_check_condition_i>).
              if evaluate_check_condition( is_data = <fs_suppl_data> is_condition = <fs_suppl_check_condition_i> ) = abap_false.
                ev_check_status = abap_false.
              endif.
            endloop.
          elseif line_exists( lt_suppl_data[ kposn = <fs_vbap_sample>-posnr kschl = lr_price_check_suppl_data_item->kschl ] )
            and lr_price_check_suppl_data_item->entry_must_not_exist = abap_true.
            me->mo_run_environment->append_log( |'Error: Condition supplement { <fs_vbap_sample>-posnr } { lr_price_check_data_item->kschl } exists but it shouldn''t| ).
            ev_check_status = abap_false.
          elseif lr_price_check_suppl_data_item->entry_must_not_exist = abap_false.
            me->mo_run_environment->append_log( |'Error: Condition supplement { <fs_vbap_sample>-posnr } { lr_price_check_suppl_data_item->kschl } not found| ).
            ev_check_status = abap_false.
          endif.
        endloop.

        " Check item texts
        if lr_item_check_data->text_check_data is not initial.
          me->mo_run_environment->append_log( 'Comparing item text with reference).' ).
          loop at lr_item_check_data->text_check_data reference into data(lr_item_text_check_data).
            clear: lt_inlines[], lt_lines[].
            call function 'READ_TEXT_INLINE'
              exporting
                id              = lr_item_text_check_data->text_id  "Text ID of text to be read
                inline_count    = 2                            " Number of lines for inline table
                language        = lr_item_text_check_data->language      " Language of text to be read
                name            = conv tdobname( lv_vbeln && <fs_vbap_sample>-posnr && '' ) " Name of text to be read
                object          = conv tdobject( 'VBBP' ) "Object of text to be read
              tables
                inlines         = lt_inlines[]     "
                lines           = lt_lines[]       " Lines of text read
              exceptions
                id              = 1                " Text ID invalid
                language        = 2                " Invalid language
                name            = 3                " Invalid text name
                not_found       = 4                " Text not found
                object          = 5                " Invalid text object
                reference_check = 6                " Reference chain cancelled
                others          = 7.
            if sy-subrc <> 0.
              if lr_item_text_check_data->check_no_entry = abap_false.
                ev_check_status = abap_false.
                me->mo_run_environment->append_log( |Error: No item text entry found for (id = { lr_item_text_check_data->text_id }, language = { lr_item_text_check_data->language }).| ).
              endif.
            elseif lr_item_text_check_data->check_no_entry = abap_true.
              ev_check_status = abap_false.
              me->mo_run_environment->append_log( |Error: An entry for (id = { lr_item_text_check_data->text_id }, language = { lr_item_text_check_data->language }) has been found but should not exist.| ).
              continue.
            endif.

            if not ( lr_item_text_check_data->text_reference is initial and lt_lines[] is initial      " in case text is empty and also no line was created in text
              or lines( lt_lines[] ) > 0 and lt_lines[ 1 ]-tdline = lr_item_text_check_data->text_reference ).
              ev_check_status = abap_false.
              me->mo_run_environment->append_log( |Error: Item text entry is not equal to reference (id = { lr_item_text_check_data->text_id }, language = { lr_item_text_check_data->language }).| ).
              me->mo_run_environment->append_log( |Reference text: { lr_item_text_check_data->text_reference }| ).
              if lt_lines[] is initial.
                me->mo_run_environment->append_log( 'Actual text is empty.' ).
              else.
                me->mo_run_environment->append_log( |Actual text:{ lt_lines[ 1 ]-tdline }| ).
              endif.
            endif.
          endloop.
        endif.

        " Check schedule line data.
        loop at lr_item_check_data->sline_check_data reference into data(lr_sline_check_data).
          clear lt_vbep_sample.
          me->mo_run_environment->append_log( iv_log_statement = sy-tabix && ' sline check ( ' && lr_sline_check_data->description && ' ).' ).

          " Prepare sline data with dynamic dates
          loop at lr_sline_check_data->dynamic_dates reference into data(lr_dynamic_date_sline).
            check lr_dynamic_date_sline->date_field_name is not initial.
            loop at lr_sline_check_data->check_conditions reference into data(lr_sline_check_condition) where field_name = lr_dynamic_date_sline->date_field_name.
              lv_date = sy-datum + lr_dynamic_date_sline->offset_in_days.
              lr_sline_check_condition->value = lv_date.
            endloop.
          endloop.

          " get vbep entries by sline id or selection criteria
          if lr_sline_check_data->sline_id is initial.
            loop at lt_vbep assigning field-symbol(<fs_vbep>) where posnr = <fs_vbap_sample>-posnr.
              data(lv_vbep_valid) = abap_true.
              loop at lr_sline_check_data->dynamic_selection_key assigning field-symbol(<fs_sline_dynamic_select_key>).
                if evaluate_check_condition( is_data = <fs_vbep> is_condition = <fs_sline_dynamic_select_key> iv_verbose_mode = abap_false ) = abap_false.
                  lv_vbep_valid = abap_false.
                endif.
                if lv_vbep_valid = abap_true.
                  insert <fs_vbep> into table lt_vbep_sample.
                endif.
              endloop.
            endloop.
          else.
            if line_exists( lt_vbep[ posnr = <fs_vbap_sample>-posnr etenr = lr_sline_check_data->sline_id ] ).
              insert lt_vbep[ posnr = <fs_vbap_sample>-posnr etenr = lr_sline_check_data->sline_id ] into table lt_vbep_sample.
            endif.
          endif.

          " check if at least one vbap entry is found
          if lt_vbep_sample is initial.
            if lr_sline_check_data->sline_id is initial.
              me->mo_run_environment->append_log( |Warning: No VBEP entry found for sline_check_data selection criteria.| ).
            else.
              ev_check_status = abap_false.
              me->mo_run_environment->append_log( |Error: No VBEP entry found for sline_check_data selection criteria.| ).
            endif.
          endif.

          loop at lt_vbep_sample assigning field-symbol(<fs_vbep_sample>).
            me->mo_run_environment->append_log( |Comparing to VBEP entry with etenr = { <fs_vbep_sample>-etenr }.| ).
            loop at lr_sline_check_data->check_conditions assigning field-symbol(<fs_sline_check_condition>).
              if evaluate_check_condition( is_data = <fs_vbep_sample> is_condition = <fs_sline_check_condition> ) = abap_false.
                ev_check_status = abap_false.
              endif.
            endloop.
          endloop.
        endloop.
      endloop.
    endloop.

  endmethod.


  method check_existence.
    data: lv_vbeln type vbeln.

    move iv_id to lv_vbeln.

    select single * from vbak where vbeln = @lv_vbeln into @data(ls_quotation).
    if sy-subrc <> 0.
      me->mo_run_environment->append_log( iv_log_statement = |Quotation { lv_vbeln } does not exist.| ).
      rv_exists = abap_false.
    else.
      rv_exists = abap_true.
    endif.
  endmethod.


  method create.

    data: lv_vbeln          type vbeln_va,
          ls_testdata       type ty_gs_i_ptf_quot_cr_td,
          lv_immediate_exit type abap_bool.

    ev_execution_status = abap_false.
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata( exporting is_step_data = ls_step_data
                               importing es_testdata  = ls_testdata ).

    " Run dynamic testdata changes
    if ls_testdata-dynamic_testdata_changes is not initial.
      ev_execution_status = me->run_dynamic_test_data_changes(
        exporting
          iv_step_number    = iv_step_number
          it_dynamic_code   = ls_testdata-dynamic_testdata_changes
        importing
          ev_immediate_exit = lv_immediate_exit
          ev_document_id    = ev_document_id
        changing
          cs_quot_test_data = ls_testdata
      ).
      check lv_immediate_exit = abap_false.
    endif.

    if ls_testdata-goal_bo_id is initial.
      ls_testdata-goal_bo_id = if_goal_sdoc=>co_bo_id-salesquotation.
    endif.

    try.
        data(lo_access) = cl_goal_api=>so_instance->create(
          iv_bo_id            = ls_testdata-goal_bo_id
          is_control_settings = value if_goal_access=>tcs_control_settings( no_conversion = abap_true )
          is_load_parameter   = value cl_goal_salesquotation=>tcs_load_parameter( type_code               = ls_testdata-head-type_code
                                                                                  sales_organization_id   = ls_testdata-head-sales_organization_id
                                                                                  distribution_channel_id = ls_testdata-head-distribution_channel_id
                                                                                  division_id             = ls_testdata-head-division_id )
          it_scenario_id      = ls_testdata-goal_scenario_ids ).
      catch cx_goal_exc into data(lx_goal_exc).
        cl_message_helper=>set_msg_vars_for_if_t100_msg( lx_goal_exc ).
        me->mo_run_environment->append_log( iv_log_statement = |{ lx_goal_exc->get_text( ) }| ).
        exit.
    endtry.

    merge_goal_quotation( exporting io_goal_access         = lo_access
                          changing  cs_quotation_test_data = ls_testdata ).

    lo_access->save( exporting iv_synchron = abap_true
                     importing ev_bo_key   = lv_vbeln ).

    if lv_vbeln is initial.
      me->mo_run_environment->append_log( iv_log_statement = |{ 'Document save failed.' }| ).
    endif.
    data(lv_error_occured) = log_goal_messages(
      importing
        io_goal_access = lo_access ).
    if lv_error_occured = abap_true.
      exit.
    endif.
    lo_access->close(  ).

    append value #( vbeln = lv_vbeln ) to ev_document_id.
    ev_execution_status = abap_true.

  endmethod.


  method delete.
  endmethod.


  method evaluate_check_condition.

    rv_condition_result = abap_true.
    assign component is_condition-field_name of structure is_data to field-symbol(<fs_l_value>).
    if sy-subrc <> 0.
      if iv_verbose_mode = abap_true.
        me->mo_run_environment->append_log( |Error: Assignment failed for field name { is_condition-field_name } ''.| ).
      endif.
      rv_condition_result = abap_false.
      return.
    endif.

    case is_condition-operator.
      when '' or '= ' or ' =' or 'eq'.
        if is_condition-value is initial and <fs_l_value> is not initial.
          rv_condition_result = abap_false.
        elseif not ( <fs_l_value> = is_condition-value ).
          rv_condition_result = abap_false.
        endif.
      when '>' or 'gt'.
        if not ( <fs_l_value> > is_condition-value ).
          rv_condition_result = abap_false.
        endif.
      when '<' or 'lt'.
        if not ( <fs_l_value> < is_condition-value ).
          rv_condition_result = abap_false.
        endif.
      when '>=' or 'ge'.
        if not ( <fs_l_value> >= is_condition-value ).
          rv_condition_result = abap_false.
        endif.
      when '<=' or 'le'.
        if not ( <fs_l_value> <= is_condition-value ).
          rv_condition_result = abap_false.
        endif.
      when '<>' or 'ne'.
        if is_condition-value is initial and <fs_l_value> is initial.
          rv_condition_result = abap_false.
        elseif not ( <fs_l_value> <> is_condition-value ).
          rv_condition_result = abap_false.
        endif.
      when others.
        if iv_verbose_mode = abap_true.
          me->mo_run_environment->append_log( |Operator { is_condition-operator } is not defined for check.| ).
        endif.
        rv_condition_result = abap_false.
        return.
    endcase.
    if rv_condition_result = abap_false.
      if iv_verbose_mode = abap_true.
        me->mo_run_environment->append_log( |Condition {  is_condition-field_name } { is_condition-operator } { is_condition-value } failed.| ).
        me->mo_run_environment->append_log( |( { is_condition-field_name } = { <fs_l_value> } )| ).
      endif.
    endif.

  endmethod.


  method execute_action.

    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    case ls_step_data-action.
      when c_wait.
        me->wait(
          exporting
            iv_step_number      = iv_step_number
          importing
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status ).

    endcase.
  endmethod.


  method execute_check.
  endmethod.


  method log_goal_messages.
    rv_error_occured = abap_false.
    io_goal_access->get_messages(
      importing
        et_message = data(lt_message_save)
        es_error   = data(ls_error) ).

    loop at lt_message_save reference into data(lr_message).
      me->mo_run_environment->append_log( iv_log_statement = |{ lr_message->msgtx }| ).
    endloop.

    if not ls_error is initial.
      me->mo_run_environment->append_log( iv_log_statement = |{ ls_error-msgtx }| ).
      rv_error_occured = abap_true.
    endif.
  endmethod.


  method merge_goal_entity_test_data.
    data:
      ls_entity_admin          type tds_goal_entity_admin.
    clear es_changed_field.

    " create a new handle if not yet provided
    assign component 'handle' of structure cs_entity_data to field-symbol(<fs_entity_data_handle>).
    check sy-subrc = 0.
    move-corresponding cs_entity_data to ls_entity_admin.
    if <fs_entity_data_handle> is initial.
      <fs_entity_data_handle> = cl_goal_util=>so_instance->create_guid( ).
    endif.
    es_changed_field-handle = <fs_entity_data_handle>.

    " read component list of input entity structure
    data(lt_entity_component) =  cast cl_abap_structdescr( cl_abap_typedescr=>describe_by_data( is_entity_test_data ) )->get_components( ).

    loop at lt_entity_component assigning field-symbol(<fs_entity_component>).
      assign component <fs_entity_component>-name of structure is_entity_test_data to field-symbol(<fs_test_data>).
      check sy-subrc = 0.
      if <fs_test_data> is not initial or line_exists( it_uncndnl_take_over_fields[ name = <fs_entity_component>-name ] ).
        assign component <fs_entity_component>-name of structure cs_entity_data to field-symbol(<fs_entity_data>).
        check sy-subrc = 0.
        if <fs_entity_data> <> <fs_test_data> or line_exists( it_uncndnl_take_over_fields[ name = <fs_entity_component>-name ] ).
          <fs_entity_data> = <fs_test_data>.
          insert conv #( <fs_entity_component>-name ) into table es_changed_field-field.
        endif.
      endif.
    endloop.

  endmethod.


  method merge_goal_quotation.

    data: ls_head_entity   type tds_goal_quot_head,
          lt_item_entity   type standard table of tds_goal_quot_item,
          lr_item_entity   type ref to tds_goal_quot_item,
          " lt_sline_entity  type standard table of tds_goal_so_sline,
          " lr_sline_entity  type ref to tds_goal_so_sline,
          lt_sline_entity  type standard table of tds_goal_sdoc_sline,
          lr_sline_entity  type ref to tds_goal_sdoc_sline,
          lt_party_entity  type standard table of tds_goal_basic_party,
          lr_party_entity  type ref to tds_goal_basic_party,
          lt_text_entity   type standard table of tds_goal_basic_text,
          lr_text_entity   type ref to tds_goal_basic_text,
          lt_cond_entity   type standard table of tds_goal_basic_cond,
          lr_cond_entity   type ref to tds_goal_basic_cond,
          ls_changed_field type if_goal_types=>tcs_changed_field,
          lt_changed_field type if_goal_types=>tct_changed_field.

    " set header data
    io_goal_access->get_entity(
      exporting
        iv_entity_id   = if_goal_sdoc_head=>co_entity_id
      importing
        es_entity_data = ls_head_entity ).
    set_relative_dates(
      exporting
        it_relative_dates   = cs_quotation_test_data-head-relative_dates
      changing
        cs_entity_test_data = cs_quotation_test_data-head-goal_data ).
    merge_goal_entity_test_data(
      exporting
        is_entity_test_data         = cs_quotation_test_data-head-goal_data
        it_uncndnl_take_over_fields = cs_quotation_test_data-head-unconditional_take_over_fields
      importing
        es_changed_field            = ls_changed_field
      changing
        cs_entity_data              = ls_head_entity ).
    " readonly fields:
    if line_exists( ls_changed_field-field[ table_line = if_goal_sdoc_head=>co_field_name-type_code ] ).
      delete ls_changed_field-field where table_line = if_goal_sdoc_head=>co_field_name-type_code.
    endif.

    io_goal_access->set_entity(
      iv_entity_id     = if_goal_sdoc_head=>co_entity_id
      is_entity_data   = ls_head_entity
      is_changed_field = ls_changed_field ).

    " set head partner data
    clear lt_changed_field.
    io_goal_access->get_entity_set(
      exporting
        iv_entity_id     = if_goal_basic_party=>co_entity_id-head_party
        iv_handle_parent = ls_head_entity-handle
      importing
        et_entity_data   = lt_party_entity ).

    loop at cs_quotation_test_data-head-party_list assigning field-symbol(<fs_head_party_test_data>).
      if line_exists( lt_party_entity[ function_code = <fs_head_party_test_data>-function_code ] ).
        lr_party_entity = ref #( lt_party_entity[ function_code = <fs_head_party_test_data>-function_code ] ).
      else.
        append value #( ) to lt_party_entity reference into lr_party_entity.
      endif.
      merge_goal_entity_test_data(
        exporting
          is_entity_test_data         = <fs_head_party_test_data>-goal_data
          it_uncndnl_take_over_fields = <fs_head_party_test_data>-unconditional_take_over_fields
        importing
          es_changed_field            = ls_changed_field
        changing
          cs_entity_data              = lr_party_entity->* ).
      append ls_changed_field to lt_changed_field.
    endloop.
    io_goal_access->set_entity_set(
      exporting
        iv_entity_id     = if_goal_basic_party=>co_entity_id-head_party
        iv_handle_parent = ls_head_entity-handle
        it_entity_data   = lt_party_entity
        it_changed_field = lt_changed_field ).

    " set header texts
    if cs_quotation_test_data-head-text_list is not initial.
      clear lt_changed_field.
      try.
          io_goal_access->get_entity_set(
            exporting
              iv_entity_id     = if_goal_basic_text=>co_entity_id-head_text
              iv_handle_parent = ls_head_entity-handle
            importing
              et_entity_data   = lt_text_entity ).
        catch cx_goal_exc into data(lx_goal_exc).
          cl_message_helper=>set_msg_vars_for_if_t100_msg( lx_goal_exc ).
          me->mo_run_environment->append_log( iv_log_statement = |{ lx_goal_exc->get_text( ) }| ).
      endtry.

      loop at cs_quotation_test_data-head-text_list assigning field-symbol(<fs_head_text_test_data>).
        if line_exists( lt_text_entity[ text_id = <fs_head_text_test_data>-text_id spras = <fs_head_text_test_data>-spras ] ).
          lr_text_entity = ref #( lt_text_entity[ text_id = <fs_head_text_test_data>-text_id spras = <fs_head_text_test_data>-spras ] ).
        else.
          append value #( ) to lt_text_entity reference into lr_text_entity.
        endif.
        merge_goal_entity_test_data(
          exporting
            is_entity_test_data         = <fs_head_text_test_data>-goal_data
            it_uncndnl_take_over_fields = <fs_head_text_test_data>-unconditional_take_over_fields
          importing
            es_changed_field            = ls_changed_field
          changing
            cs_entity_data              = lr_text_entity->*
        ).
        append ls_changed_field to lt_changed_field.
      endloop.
      io_goal_access->set_entity_set(
        exporting
          iv_entity_id     = if_goal_basic_text=>co_entity_id-head_text
          iv_handle_parent = ls_head_entity-handle
          it_entity_data   = lt_text_entity
          it_changed_field = lt_changed_field ).
    endif.

    " set header price condition
    clear lt_changed_field.
    io_goal_access->get_entity_set(
      exporting
        iv_entity_id     = if_goal_basic_cond=>co_entity_id-head_cond
        iv_handle_parent = ls_head_entity-handle
      importing
        et_entity_data   = lt_cond_entity ).
    loop at cs_quotation_test_data-head-pricecondition_list assigning field-symbol(<fs_head_cond_test_data>).
      if line_exists( lt_cond_entity[ type_code = <fs_head_cond_test_data>-type_code ] ).
        lr_cond_entity = ref #( lt_cond_entity[ type_code = <fs_head_cond_test_data>-type_code ] ).
      else.
        append value #( ) to lt_cond_entity reference into lr_cond_entity.
      endif.
      merge_goal_entity_test_data(
        exporting
          is_entity_test_data         = <fs_head_cond_test_data>-goal_data
          it_uncndnl_take_over_fields = <fs_head_cond_test_data>-unconditional_take_over_fields
        importing
          es_changed_field            = ls_changed_field
        changing
          cs_entity_data              = lr_cond_entity->*
      ).
      append ls_changed_field to lt_changed_field.
    endloop.
    io_goal_access->set_entity_set(
      exporting
        iv_entity_id     = if_goal_basic_cond=>co_entity_id-head_cond
        iv_handle_parent = ls_head_entity-handle
        it_entity_data   = lt_cond_entity
        it_changed_field = lt_changed_field ).

    " set item data
    io_goal_access->get_entity_set(
      exporting
        iv_handle_parent = ls_head_entity-handle
        iv_entity_id     = if_goal_sdoc_item=>co_entity_id
      importing
        et_entity_data   = lt_item_entity ).

    loop at cs_quotation_test_data-item_list assigning field-symbol(<fs_item_test_data>).
      if line_exists( lt_item_entity[ item_id = <fs_item_test_data>-item_id ] ).
        lr_item_entity = ref #( lt_item_entity[ item_id = <fs_item_test_data>-item_id ] ).
      else.
        data(ls_new_item_entity) = value tds_goal_quot_item(  ).
        lr_item_entity = ref #( ls_new_item_entity ).
      endif.

      if <fs_item_test_data>-delete_entry = abap_true.
        io_goal_access->del_entity(
          exporting
            iv_handle = lr_item_entity->handle ).
        continue.
      endif.
      set_relative_dates(
        exporting
          it_relative_dates   = <fs_item_test_data>-relative_dates
        changing
          cs_entity_test_data = <fs_item_test_data>-goal_data ).
      merge_goal_entity_test_data(
        exporting
          is_entity_test_data         = <fs_item_test_data>-goal_data
          it_uncndnl_take_over_fields = <fs_item_test_data>-unconditional_take_over_fields
        importing
          es_changed_field            = ls_changed_field
        changing
          cs_entity_data              = lr_item_entity->* ).

*      set_data_container_item( is_item_data      = lr_item_entity->*
*                               is_data_container = <fs_item_test_data>-data_container_item ).

      io_goal_access->set_entity(
        exporting
          iv_entity_id     = if_goal_sdoc_item=>co_entity_id
          iv_handle_parent = ls_head_entity-handle
          is_entity_data   = lr_item_entity->*
          is_changed_field = ls_changed_field ).

*      " set sline data
*      clear lt_changed_field.
*      io_goal_access->get_entity_set(
*        exporting
*          iv_entity_id     = if_goal_sdoc_sline=>co_entity_id
*          iv_handle_parent = lr_item_entity->handle
*        importing
*          et_entity_data   = lt_sline_entity ).
*      loop at <fs_item_test_data>-sline_list assigning field-symbol(<fs_sline_test_data>).
*        if line_exists( lt_sline_entity[ sline_id = <fs_sline_test_data>-sline_id ] ).
*          lr_sline_entity = ref #( lt_sline_entity[ sline_id = <fs_sline_test_data>-sline_id ] ).
*        else.
*          append value #( ) to lt_sline_entity reference into lr_sline_entity.
*        endif.
*        if <fs_sline_test_data>-delete_entry = abap_true.
*          io_goal_access->del_entity( iv_handle = lr_sline_entity->handle ).
*          continue.
*        endif.
*        set_relative_dates(
*          exporting
*            it_relative_dates   = <fs_sline_test_data>-relative_dates
*          changing
*            cs_entity_test_data = <fs_sline_test_data>-goal_data ).
*        merge_goal_entity_test_data(
*          exporting
*            is_entity_test_data         = <fs_sline_test_data>-goal_data
*            it_uncndnl_take_over_fields = <fs_sline_test_data>-unconditional_take_over_fields
*          importing
*            es_changed_field            = ls_changed_field
*          changing
*            cs_entity_data              = lr_sline_entity->* ).
*        append ls_changed_field to lt_changed_field.
*      endloop.
*      io_goal_access->set_entity_set(
*        exporting
*          iv_entity_id     = if_goal_sdoc_sline=>co_entity_id
*          iv_handle_parent = lr_item_entity->handle
*          it_entity_data   = lt_sline_entity
*          it_changed_field = lt_changed_field ).

      " set item partner data
      clear lt_changed_field.
      io_goal_access->get_entity_set(
        exporting
          iv_entity_id     = if_goal_basic_party=>co_entity_id-item_party
          iv_handle_parent = lr_item_entity->handle
        importing
          et_entity_data   = lt_party_entity ).
      loop at <fs_item_test_data>-party_list assigning field-symbol(<fs_item_party_test_data>).
        if line_exists( lt_party_entity[ function_code = <fs_item_party_test_data>-function_code ] ).
          lr_party_entity = ref #( lt_party_entity[ function_code = <fs_item_party_test_data>-function_code ] ).
        else.
          append value #( ) to lt_party_entity reference into lr_party_entity.
        endif.
        merge_goal_entity_test_data(
          exporting
            is_entity_test_data         = <fs_item_party_test_data>-goal_data
            it_uncndnl_take_over_fields = <fs_item_party_test_data>-unconditional_take_over_fields
          importing
            es_changed_field            = ls_changed_field
          changing
            cs_entity_data              = lr_party_entity->* ).
        append ls_changed_field to lt_changed_field.
      endloop.
      io_goal_access->set_entity_set(
        exporting
          iv_entity_id     = if_goal_basic_party=>co_entity_id-item_party
          iv_handle_parent = lr_item_entity->handle
          it_entity_data   = lt_party_entity
          it_changed_field = lt_changed_field ).

      " set item texts
      clear lt_changed_field.
      if <fs_item_test_data>-text_list is not initial.
        try.
            io_goal_access->get_entity_set(
              exporting
                iv_entity_id     = if_goal_basic_text=>co_entity_id-item_text
                iv_handle_parent = lr_item_entity->handle
              importing
                et_entity_data   = lt_text_entity ).
          catch cx_goal_exc into lx_goal_exc.
            cl_message_helper=>set_msg_vars_for_if_t100_msg( lx_goal_exc ).
            me->mo_run_environment->append_log( iv_log_statement = |{ lx_goal_exc->get_text( ) }| ).
        endtry.

        loop at <fs_item_test_data>-text_list assigning field-symbol(<fs_item_text_test_data>).
          if line_exists( lt_text_entity[ text_id = <fs_item_text_test_data>-text_id spras = <fs_item_text_test_data>-spras ] ).
            lr_text_entity = ref #( lt_text_entity[ text_id = <fs_item_text_test_data>-text_id spras = <fs_item_text_test_data>-spras ] ).
          else.
            append value #( ) to lt_text_entity reference into lr_text_entity.
          endif.
          merge_goal_entity_test_data(
            exporting
              is_entity_test_data         = <fs_item_text_test_data>-goal_data
              it_uncndnl_take_over_fields = <fs_item_text_test_data>-unconditional_take_over_fields
            importing
              es_changed_field            = ls_changed_field
            changing
              cs_entity_data              = lr_text_entity->*
          ).
          append ls_changed_field to lt_changed_field.
        endloop.
        io_goal_access->set_entity_set(
          exporting
            iv_entity_id     = if_goal_basic_text=>co_entity_id-item_text
            iv_handle_parent = lr_item_entity->handle
            it_entity_data   = lt_text_entity
            it_changed_field = lt_changed_field ).
      endif.

      " set item price condition
      clear lt_changed_field.
      io_goal_access->get_entity_set(
        exporting
          iv_entity_id     = if_goal_basic_cond=>co_entity_id-item_cond
          iv_handle_parent = lr_item_entity->handle
        importing
          et_entity_data   = lt_cond_entity ).

      loop at <fs_item_test_data>-pricecondition_list assigning field-symbol(<fs_item_cond_test_data>).
        if line_exists( lt_cond_entity[ type_code = <fs_item_cond_test_data>-type_code ] ).
          lr_cond_entity = ref #( lt_cond_entity[ type_code = <fs_item_cond_test_data>-type_code ] ).
        else.
          append value #( ) to lt_cond_entity reference into lr_cond_entity.
        endif.
        merge_goal_entity_test_data(
          exporting
            is_entity_test_data         = <fs_item_cond_test_data>-goal_data
            it_uncndnl_take_over_fields = <fs_item_cond_test_data>-unconditional_take_over_fields
          importing
            es_changed_field            = ls_changed_field
          changing
            cs_entity_data              = lr_cond_entity->*
        ).
        append ls_changed_field to lt_changed_field.
      endloop.
      io_goal_access->set_entity_set(
        exporting
          iv_entity_id     = if_goal_basic_cond=>co_entity_id-item_cond
          iv_handle_parent = lr_item_entity->handle
          it_entity_data   = lt_cond_entity
          it_changed_field = lt_changed_field ).

    endloop.

  endmethod.


  method run_custom_dynamic_checks.

    data:
      lv_class                    type string,
      lo_oref                     type ref to object,
      lo_ptf_bo_quot_dynamic_code type ref to if_ptf_bo_quot_dynamic_code,
      lt_dynamic_code             type ty_gt_code_line.

    clear ev_immediate_exit.
    rv_check_status = abap_true.

    me->mo_run_environment->append_log( iv_log_statement = 'Running Custom Dynamic Checks.' ).
    loop at it_dynamic_code reference into data(lr_dynamic_code).
      do 2 times.
        clear lt_dynamic_code.
        " some systems block the creation of dynamic code for testing
        " in this case the code is generated a second time without the for testing environment
        if sy-index = 1.
          append lines of value ty_gt_code_line(
            ( `program.` )
            ( `class dcl_ptf_bo_quot_dynamic_code definition for testing.` ) " <--
            ( `  public section.` )
            ( `    interfaces if_ptf_bo_quot_dynamic_code.` )
            ( `endclass.` )
            ( `class dcl_ptf_bo_quot_dynamic_code implementation.` )
            ( `  method if_ptf_bo_quot_dynamic_code~dynamic_test_data_change.` )
            ( `  endmethod.` )
            ( `  method if_ptf_bo_quot_dynamic_code~custom_dynamic_check.` ) ) to lt_dynamic_code.
        else.
          append lines of value ty_gt_code_line(
            ( `program.` )
            ( `class dcl_ptf_bo_quot_dynamic_code definition.` ) " <--
            ( `  public section.` )
            ( `    interfaces if_ptf_bo_quot_dynamic_code.` )
            ( `endclass.` )
            ( `class dcl_ptf_bo_quot_dynamic_code implementation.` )
            ( `  method if_ptf_bo_quot_dynamic_code~dynamic_test_data_change.` )
            ( `  endmethod.` )
            ( `  method if_ptf_bo_quot_dynamic_code~custom_dynamic_check.` ) ) to lt_dynamic_code.
        endif.
        split lr_dynamic_code->code at cl_abap_char_utilities=>cr_lf into table data(lt_code_lines).
        append lines of lt_code_lines to lt_dynamic_code.
        append lines of value ty_gt_code_line(
          ( `  endmethod.` )
          ( `endclass.` ) ) to lt_dynamic_code.

        generate subroutine pool lt_dynamic_code name data(lv_prog).
        if sy-subrc <> 0.
          me->mo_run_environment->append_log( iv_log_statement = 'Error when compiling dynamic code.' ).
          continue.
        endif.
        lv_class = `\PROGRAM=` && lv_prog && `\CLASS=DCL_PTF_BO_QUOT_DYNAMIC_CODE`.
        try.
            " when dynamic generated code for testing is not allowed the object instantiation fails.
            create object lo_oref type (lv_class).
            lo_ptf_bo_quot_dynamic_code ?= lo_oref.
            if not lo_ptf_bo_quot_dynamic_code->custom_dynamic_check(
                     exporting
                       iv_step_number          = iv_step_number
                       io_ptf_bo               = me
                     importing
                       ev_immediate_exit       = ev_immediate_exit
                       ev_document_id          = ev_document_id
                     changing
                       cs_quot_test_data       = cs_quot_test_data
                   ).
              me->mo_run_environment->append_log( iv_log_statement = 'Error: Custom Dynamic Check failed.' ).
              rv_check_status = abap_false.
            endif.
            exit.
          catch cx_sy_create_object_error.
            me->mo_run_environment->append_log( iv_log_statement = 'For testing environment not allowed. Dynamic test mocking might not be possible. Retrying code generation without for testing.' ).
        endtry.
      enddo.
    endloop.


  endmethod.


  method run_dynamic_test_data_changes.

    data:
      lv_class                    type string,
      lo_oref                     type ref to object,
      lo_ptf_bo_quot_dynamic_code type ref to if_ptf_bo_quot_dynamic_code,
      lt_dynamic_code             type ty_gt_code_line.

    clear ev_immediate_exit.
    rv_execution_status = abap_true.

    me->mo_run_environment->append_log( iv_log_statement = 'Running Dynamic Testdata Changes.' ).
    loop at it_dynamic_code reference into data(lr_dynamic_code).
      do 2 times.
        clear lt_dynamic_code.
        " some systems block the creation of dynamic code for testing
        " in this case the code is generated a second time without the for testing environment
        if sy-index = 1.
          append lines of value ty_gt_code_line(
            ( `program.` )
            ( `class dcl_ptf_bo_quot_dynamic_code definition for testing.` ) " <--
            ( `  public section.` )
            ( `    interfaces if_ptf_bo_quot_dynamic_code.` )
            ( `endclass.` )
            ( `class dcl_ptf_bo_quot_dynamic_code implementation.` )
            ( `  method if_ptf_bo_quot_dynamic_code~dynamic_test_data_change.` ) ) to lt_dynamic_code.
        else.
          append lines of value ty_gt_code_line(
            ( `program.` )
            ( `class dcl_ptf_bo_quot_dynamic_code definition.` ) " <--
            ( `  public section.` )
            ( `    interfaces if_ptf_bo_quot_dynamic_code.` )
            ( `endclass.` )
            ( `class dcl_ptf_bo_quot_dynamic_code implementation.` )
            ( `  method if_ptf_bo_quot_dynamic_code~dynamic_test_data_change.` ) ) to lt_dynamic_code.
        endif.
        split lr_dynamic_code->code at cl_abap_char_utilities=>cr_lf into table data(lt_code_lines).
        append lines of lt_code_lines to lt_dynamic_code.
        append lines of value ty_gt_code_line(
          ( `  endmethod.` )
          ( `  method if_ptf_bo_quot_dynamic_code~custom_dynamic_check.` )
          ( `  endmethod.` )
          ( `endclass.` ) ) to lt_dynamic_code.

        generate subroutine pool lt_dynamic_code name data(lv_prog).
        if sy-subrc <> 0.

          me->mo_run_environment->append_log( iv_log_statement = 'Error when compiling dynamic code.' ).
          continue.
        endif.
        lv_class = `\PROGRAM=` && lv_prog && `\CLASS=DCL_PTF_BO_QUOT_DYNAMIC_CODE`.

        try.
            " when dynamic generated code for testing is not allowed the object instantiation fails.
            create object lo_oref type (lv_class).
            lo_ptf_bo_quot_dynamic_code ?= lo_oref.
            if not lo_ptf_bo_quot_dynamic_code->dynamic_test_data_change(
                     exporting
                       iv_step_number          = iv_step_number
                       io_ptf_bo               = me
                     importing
                       ev_immediate_exit       = ev_immediate_exit
                       ev_document_id          = ev_document_id
                     changing
                       cs_quot_test_data       = cs_quot_test_data
                   ).

              me->mo_run_environment->append_log( iv_log_statement = 'Error: Dynamic Testdata Change failed.' ).
              rv_execution_status = abap_false.
            endif.
            exit.
          catch cx_sy_create_object_error.
            me->mo_run_environment->append_log( iv_log_statement = 'For testing environment not allowed. Dynamic test mocking might not be possible. Retrying code generation without for testing.' ).
        endtry.
      enddo.
    endloop.

  endmethod.


  method set_relative_dates.
    loop at it_relative_dates reference into data(lr_relative_date).
      assign component lr_relative_date->date_field_name of structure cs_entity_test_data to field-symbol(<fs_test_data>).
      check sy-subrc = 0.
      <fs_test_data> = sy-datum + lr_relative_date->offset_in_days.
    endloop.

  endmethod.


  method wait.

    data:
      ls_testdata      type ty_gs_ptf_check_rpts_td,
      lv_attempts_max  type tb_attempts,
      lv_attempts_act  type tb_attempts,  " actual attempts
      lv_waiting_time  type s_mec_cputest_break_seconds,
      lv_idle_seconds  type s_mec_cputest_break_seconds,  " Idle Seconds Before Start
      lv_max_repeats   type i,  " Maximum Number of Repeats
      lv_break_seconds type s_mec_cputest_break_seconds,  " Break Seconds Between Repeats
      lt_sales_key     type table of sales_key,
      lv_vbeln         type vbeln_va,
      lt_vbap          type standard table of vbap,
      lv_no_quotation  type abap_bool,
      lv_number(5)     type c.

    ev_execution_status = abap_true.
    ev_check_status     = abap_true.

    " get test parameter
    data(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata( exporting is_step_data = ls_step_data
                               importing es_testdata  = ls_testdata ).

    lv_idle_seconds  = ls_testdata-idle_seconds.    "  Number of Idle Seconds Before Start
    lv_max_repeats   = ls_testdata-max_repeats.     " Maximum Number of Repeats
    lv_break_seconds = ls_testdata-break_seconds.   " Number of Seconds Between Repeats
    lv_attempts_max  = 1 + lv_max_repeats.          " Maximum Number of Attempts = (first try) + (repeats)

    me->mo_run_environment->append_log( |Parameter: Idle Seconds Before Start: { lv_idle_seconds }| ).
    me->mo_run_environment->append_log( |Parameter: Maximum number of repeats: { lv_max_repeats }| ).
    me->mo_run_environment->append_log( |Parameter: Number of seconds between repeats: { lv_break_seconds }| ).

    data: lv_no_so type boole_d.
    wait up to lv_idle_seconds seconds.

    " check and wait
    loop at ls_step_data-reference_step assigning field-symbol(<lv_ref_step>).
      data(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <lv_ref_step> ).
      append lines of lt_ptf_keys to lt_sales_key.
    endloop.

    if lt_sales_key[] is initial.
      me->mo_run_environment->append_log( |No quotation from reference step| ).
    endif.

    " wait for quotation
    clear lv_attempts_act.
    do lv_attempts_max times.
      lv_attempts_act = lv_attempts_act + 1.
      clear: lt_vbap.
      call function 'SD_VBAP_ARRAY_READ_VBELN'
        tables
          it_vbak_key           = lt_sales_key
          et_vbap               = lt_vbap
        exceptions
          records_not_found     = 1
          records_not_requested = 2
          others                = 3.
      if sy-subrc <> 0.
        lv_waiting_time = lv_waiting_time + lv_break_seconds.
        wait up to lv_break_seconds seconds.

      else.
        lv_no_so = abap_false.
        loop at lt_sales_key into lv_vbeln.
          if not line_exists( lt_vbap[ vbeln = lv_vbeln ] ).
            lv_no_so = abap_true.
            exit.
          endif.
        endloop.
        if lv_no_so = abap_true.
          add lv_break_seconds to lv_waiting_time.
          wait up to lv_break_seconds seconds.
        else.
          " quotation found
          exit.
        endif.
      endif.
    enddo.

    lv_number = lv_attempts_act.
    me->mo_run_environment->append_log( |Actual number of attempts: { lv_number }| ).

    lv_number = lv_waiting_time.
    me->mo_run_environment->append_log( |Total waiting time: { lv_number } seconds| ).

    if lv_no_so eq abap_false.
      loop at lt_sales_key into lv_vbeln.
        me->mo_run_environment->append_log( |Quotation { lv_vbeln } found| ).
      endloop.
    else.
      me->mo_run_environment->append_log( |Quotation not found after waiting| ).
    endif.

  endmethod.
ENDCLASS.
