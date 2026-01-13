*&---------------------------------------------------------------------*
*& Report PTF_TEST_RESULTS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ptf_results.
TABLES: ptf_exec_log, ptf_var_tag_map, ptf_varid.

CONSTANTS: c_ok         TYPE char10 VALUE 'OK',
           c_failed     TYPE char10 VALUE 'FAILED',
           c_dump       TYPE char10 VALUE 'DUMP',
           c_aggregated TYPE char10 VALUE 'AGGREGATED'.

CLASS lcl_report_utilites DEFINITION DEFERRED.

TYPES: BEGIN OF ts_ptf_log,
         ptf_script         TYPE ptf_exec_log-ptf_script,
         dump_occured       TYPE ptf_exec_log-dump_occured,
         start_date         TYPE ptf_exec_log-start_date,
         start_time         TYPE ptf_exec_log-start_time,
         run_result         TYPE ptf_exec_log-run_result, "0 means success, 1 fail
         runtime            TYPE ptf_exec_log-runtime,
         userid             TYPE ptf_exec_log-userid,
         is_batch           TYPE ptf_exec_log-is_batch,
         session_type       TYPE ptf_exec_log-session_type,
         failed_step_number TYPE ptf_exec_log-failed_step_number,
       END OF ts_ptf_log,
       tt_ptf_log TYPE STANDARD TABLE OF ts_ptf_log WITH NON-UNIQUE DEFAULT KEY.

TYPES: BEGIN OF ts_alv_secondlevel,
         ptf_script         TYPE ptf_exec_log-ptf_script,
         run_result         TYPE ptf_exec_log-run_result, "0 means success, 1 fail
         run_result_icon    TYPE text128, "icon-id,
         dump_occured       TYPE ptf_exec_log-dump_occured,
         runtime            TYPE ptf_exec_log-runtime,
         userid             TYPE ptf_exec_log-userid,
         is_batch           TYPE ptf_exec_log-is_batch,
         session_type       TYPE ptf_exec_log-session_type,
         failed_step_number TYPE ptf_exec_log-failed_step_number,
         start_date         TYPE ptf_exec_log-start_date,
         start_time         TYPE ptf_exec_log-start_time,
       END OF ts_alv_secondlevel,
       tt_alv_secondlevel TYPE STANDARD TABLE OF ts_alv_secondlevel WITH NON-UNIQUE DEFAULT KEY.

TYPES: BEGIN OF ts_alv_table,
         ptf_script       TYPE ptf_exec_log-ptf_script,
         hmdaysucc        TYPE int4,
         lastsucc         TYPE sy-datum,
         lastfail         TYPE sy-datum,
         lastdump         TYPE sy-datum,
         today            TYPE char10,
         yesterday        TYPE char10,
         2daysback        TYPE char10,
         3daysback        TYPE char10,
         4daysback        TYPE char10,
         5daysback        TYPE char10,
         6daysback        TYPE char10,
         7daysback        TYPE char10,
         lastweek_num     TYPE int4, "number of runs
         lastweek_s       TYPE int4,
         lastweek_f       TYPE int4,
         lastweek_srate   TYPE char5, "success rate
         last2weeks_s     TYPE int4,
         last2weeks_f     TYPE int4,
         last4weeks_s     TYPE int4,
         last4weeks_f     TYPE int4,
         last8weeks_s     TYPE int4,
         last8weeks_f     TYPE int4,
         last16weeks_s    TYPE int4,
         last16weeks_f    TYPE int4,
         runs6month       TYPE int4,
         runs6month_s     TYPE int4,
         runs6month_f     TYPE int4,
         runs6month_srate TYPE char5,
         t_details        TYPE tt_alv_secondlevel,
         color            TYPE lvc_t_scol,
       END OF ts_alv_table,

       tt_alv_table TYPE STANDARD TABLE OF ts_alv_table WITH NON-UNIQUE DEFAULT KEY.

TYPES: BEGIN OF ts_aggregated,
         today       TYPE int4,
         yesterday   TYPE int4,
         2daysback   TYPE int4,
         3daysback   TYPE int4,
         4daysback   TYPE int4,
         5daysback   TYPE int4,
         6daysback   TYPE int4,
         7daysback   TYPE int4,
         today_s     TYPE int4,
         yesterday_s TYPE int4,
         2daysback_s TYPE int4,
         3daysback_s TYPE int4,
         4daysback_s TYPE int4,
         5daysback_s TYPE int4,
         6daysback_s TYPE int4,
         7daysback_s TYPE int4,
       END OF ts_aggregated.

DATA: gs_aggregated TYPE ts_aggregated,
      gv_percentage TYPE p DECIMALS 3.

CLASS lcl_handle_events DEFINITION.
  PUBLIC SECTION.
    METHODS:
      on_double_click FOR EVENT double_click OF cl_salv_events_table
        IMPORTING row column.
ENDCLASS.                    "lcl_handle_events DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_handle_events IMPLEMENTATION
*---------------------------------------------------------------------*
* §5.2 implement the events for handling the events of cl_salv_table
*---------------------------------------------------------------------*
CLASS lcl_handle_events IMPLEMENTATION.
  METHOD on_double_click.
    PERFORM show_double_click USING row column.
  ENDMETHOD.                    "on_double_click

ENDCLASS.                    "lcl_handle_events IMPLEMENTATION

CLASS lcl_report_utilites DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      class_constructor,
      change_date_to_text IMPORTING iv_date             TYPE sy-datum
                          RETURNING VALUE(rv_date_text) TYPE string,

      find_percentage IMPORTING iv_count             TYPE int4
                                iv_count_s           TYPE int4
                                iv_zero              TYPE abap_bool OPTIONAL
                      RETURNING VALUE(rv_percentage) TYPE string,

      icon_fill IMPORTING iv_run_result  TYPE ptf_exec_log-run_result
                RETURNING VALUE(rv_icon) TYPE text128.

    CLASS-DATA: mv_green_light_icon TYPE lvc_value,
                mv_red_light_icon   TYPE lvc_value.

  PROTECTED SECTION.

  PRIVATE SECTION.
    CLASS-DATA: mc_led_green   TYPE icon-name VALUE 'ICON_LED_GREEN',
                mc_led_red     TYPE icon-name VALUE 'ICON_LED_RED',
                mc_red_light   TYPE icon-name VALUE 'ICON_RED_LIGHT',
                mc_green_light TYPE icon-name VALUE 'ICON_GREEN_LIGHT'.
ENDCLASS.

CLASS lcl_report_utilites IMPLEMENTATION.

  METHOD class_constructor.
    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        name                  = mc_green_light
        info                  = 'Successful run'
      IMPORTING
        result                = mv_green_light_icon
      EXCEPTIONS
        icon_not_found        = 1
        outputfield_too_short = 2
        OTHERS                = 3.

    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        name                  = mc_red_light
        info                  = 'Failed run'
      IMPORTING
        result                = mv_red_light_icon
      EXCEPTIONS
        icon_not_found        = 1
        outputfield_too_short = 2
        OTHERS                = 3.

    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

  ENDMETHOD.

  METHOD find_percentage.
    DATA lv_percentage TYPE p DECIMALS 3.

    IF iv_count <> 0.
      lv_percentage = ( iv_count_s / iv_count ) * 100.
    ENDIF.
    IF iv_zero EQ abap_false OR lv_percentage <> 0.
      rv_percentage = |{ round( val = lv_percentage dec = 0 ) } %|.
    ENDIF.

  ENDMETHOD.

  METHOD change_date_to_text.
    DATA: lv_ddtext  TYPE dd07t-ddtext,
          lv_offset  TYPE i,
          formatdate TYPE string.

    rv_date_text = cl_reca_date=>as_char( EXPORTING id_date = iv_date ).
    DATA(lv_year) = iv_date+0(4).

    FIND FIRST OCCURRENCE OF '.' IN rv_date_text.
    IF sy-subrc EQ 0.
      DATA(lv_separator) = '.'.
    ELSE.
      FIND FIRST OCCURRENCE OF '/' IN rv_date_text.
      IF sy-subrc EQ 0.
        lv_separator = '/'.
      ELSE.
        FIND FIRST OCCURRENCE OF '-' IN rv_date_text.
        IF sy-subrc EQ 0.
          lv_separator = '-'.
        ELSE.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.

    DATA(lv_year_with_separator) = |{ lv_separator }{ lv_year }|.
    FIND FIRST OCCURRENCE OF lv_year_with_separator IN rv_date_text.
    IF sy-subrc EQ 0.
      REPLACE FIRST OCCURRENCE OF lv_year_with_separator IN rv_date_text WITH space.
    ELSE.
      lv_year_with_separator = |{ lv_year }{ lv_separator }|.
      REPLACE FIRST OCCURRENCE OF lv_year_with_separator IN rv_date_text WITH space.
    ENDIF.

*  SELECT SINGLE ddtext
*  FROM dd07t
*  INNER JOIN usr01 ON usr01~datfm = dd07t~domvalue_l
*  INTO @lv_ddtext
*  WHERE usr01~bname      = @sy-uname
*    AND dd07t~domname    = 'XUDATFM'
*    AND dd07t~ddlanguage = 'E'.
*
*  IF sy-subrc IS INITIAL.
*    FIND FIRST OCCURRENCE OF '(' IN lv_ddtext MATCH OFFSET lv_offset.
*    formatdate = lv_ddtext(lv_offset).
*  ENDIF.
*
*  "read user profile from table USR01
*  SELECT SINGLE datfm FROM usr01 INTO @DATA(l_datfm) WHERE bname = @sy-uname.
*  IF sy-subrc = 0.
*    CASE l_datfm.
*      WHEN ‘1.
**        CONCATENATE  l_dat l_month l_yearl INTO ex_date SEPARATED BY ‘.’.
**      WHEN ‘2’.
**        CONCATENATE l_month l_dat l_yearl INTO ex_date SEPARATED BY ‘/’.
**      WHEN ‘3’.
**        CONCATENATE l_month l_dat l_yearl INTO ex_date SEPARATED BY ‘-‘.
**      WHEN ‘4’.
**        CONCATENATE l_yearl l_month l_dat INTO ex_date SEPARATED BY ‘.’.
**      WHEN ‘5’ OR ‘A’ OR ‘B’ OR ‘C’.
**        CONCATENATE l_yearl l_month l_dat INTO ex_date SEPARATED BY ‘/’.
**      WHEN ‘6’.
**        CONCATENATE l_yearl l_month l_dat INTO ex_date SEPARATED BY ‘-‘.
**      WHEN OTHERS.
**        RAISE error_in_reading_usr01.
*    ENDCASE.

  ENDMETHOD.

  METHOD icon_fill.
    DATA lv_value TYPE lvc_value.

    " red/green traffic light instead of 0 and 1 in column Run Result? (0 => green, 1 => red)
    CASE iv_run_result.
      WHEN '0'.
        rv_icon = mv_green_light_icon.
      WHEN '1'.
        rv_icon = mv_red_light_icon.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.

DATA: gt_alv_table TYPE tt_alv_table,
      go_alv       TYPE REF TO cl_salv_table,
      gr_events    TYPE REF TO lcl_handle_events.

DATA: gt_ptf_16_weeks   TYPE tt_ptf_log,
      gt_ptf_8_weeks    TYPE tt_ptf_log,
      gt_ptf_4_weeks    TYPE tt_ptf_log,
      gt_ptf_2_weeks    TYPE tt_ptf_log,
      gt_ptf_1_week     TYPE tt_ptf_log,
      gt_ptf_7_days     TYPE tt_ptf_log,
      gt_ptf_6_days     TYPE tt_ptf_log,
      gt_ptf_5_days     TYPE tt_ptf_log,
      gt_ptf_4_days     TYPE tt_ptf_log,
      gt_ptf_3_days     TYPE tt_ptf_log,
      gt_ptf_2_days     TYPE tt_ptf_log,
      gt_ptf_yesterday  TYPE tt_ptf_log,

      gt_ptf_for_script TYPE tt_ptf_log.

DATA: gv_date_6month_back   TYPE sy-datum,
      gv_date_16weeks_back  TYPE sy-datum,
      gv_date_8weeks_back   TYPE sy-datum,
      gv_date_4weeks_back   TYPE sy-datum,
      gv_date_2weeks_back   TYPE sy-datum,
      gv_date_1week_back    TYPE sy-datum,
      gv_date_7days_back    TYPE sy-datum,
      gv_date_6days_back    TYPE sy-datum,
      gv_date_5days_back    TYPE sy-datum,
      gv_date_4days_back    TYPE sy-datum,
      gv_date_3days_back    TYPE sy-datum,
      gv_date_2days_back    TYPE sy-datum,
      gv_date_yesterday     TYPE sy-datum,
      gv_today              TYPE sy-datum,
      lv_latest_failed_date TYPE sy-datum.

DATA: gv_day        TYPE sy-datum.

DATA: gs_alv      TYPE ts_alv_table.

DATA: gt_sdbil        TYPE RANGE OF ptf_exec_log-ptf_script,
      gt_massc        TYPE RANGE OF ptf_exec_log-ptf_script,
      gt_selectoption TYPE RANGE OF ptf_exec_log-ptf_script,
      gr_script       TYPE RANGE OF ptf_exec_log-ptf_script.

SELECTION-SCREEN BEGIN OF BLOCK rad1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_sdbil  RADIOBUTTON GROUP rad1 DEFAULT 'X' USER-COMMAND c_hide, "“SDBIL”: Reporting considering SDBIL*
              p_massc  RADIOBUTTON GROUP rad1, "“MasterScenarios”: Reporting considering the 'Master Scenarios'
              p_all    RADIOBUTTON GROUP rad1, "“All”:Reporting considering all scripts (without limits)
              p_selopt RADIOBUTTON GROUP rad1. "SelectOptions

  SELECTION-SCREEN BEGIN OF BLOCK selopt WITH FRAME TITLE TEXT-002.
    SELECT-OPTIONS: s_script FOR ptf_exec_log-ptf_script NO INTERVALS MATCHCODE OBJECT shptf_vname MODIF ID pr1, "Scriptname
                    s_tags   FOR ptf_var_tag_map-tag  MODIF ID pr1, " Tags
                    s_sitem  FOR ptf_varid-scope_item MODIF ID pr1. "ScopeItems
  SELECTION-SCREEN END OF BLOCK selopt.

SELECTION-SCREEN END OF BLOCK rad1.
PARAMETERS: p_firday TYPE sy-datum. "first data of a period

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    CASE screen-group1.
      WHEN 'PR1'.
        IF p_selopt = 'X'.
          screen-active = 1.
          screen-invisible = 0.

        ELSE.
          screen-active = 0.
          screen-invisible = 1.

        ENDIF.
        MODIFY SCREEN.

    ENDCASE.

  ENDLOOP.

AT SELECTION-SCREEN ON p_firday.
  IF p_firday IS NOT INITIAL AND p_firday > sy-datum.
    MESSAGE 'Future dates are not accepted' TYPE 'E'.
  ENDIF.

INITIALIZATION.

  gt_sdbil[] = VALUE #( sign = 'I' option = 'CP'
      ( low = 'SDBIL*' )
      ( low = 'BDR_API_REJ_DEL' )
      ( low = 'BDR_CHECK_BD_SIMUL_WO_PPD' )
      ( low = 'BDR_CHECK_PAYPAL_DATA' )
      ( low = 'BDR_CR_EXC_SYS_LOG' )
      ( low = 'BDR_CR_INIT_PREITEM' )
      ( low = 'BDR_CR_NEG_TEST' )
      ( low = 'BDR_CR_REF1A' )
      ( low = 'BDR_CR_REF1B' )
      ( low = 'BDR_CR_REF1C' )
      ( low = 'BDR_CR_REF_2' )
      ( low = 'BDR_CR_REF_3' )
      ( low = 'BDR_CR_WITH_WS' )
      ( low = 'BDR_CR_WITH_WS' )
      ( low = 'BDR_EVENT_CREATE' )
      ( low = 'BDR_EVENT_DELETE' )
      ( low = 'BDR_EVENT_INVOICE_CANCELED' )
      ( low = 'BDR_EVENT_INVOICE_CREATED' )
      ( low = 'BDR_EVENT_REJECT' )
      ( low = 'BDR_ODATA_F2337_GET' )
      ( low = 'BDR_ODATA_TESTER' )
      ( low = 'BD_ATTACHMENT' )
      ( low = 'BD_CHECK_PAYPAL_DATA' )
      ( low = 'BD_CHECK_TEXT_DMR4' )
      ( low = 'BD_CR_WITH_WS' )
      ( low = 'BD_EVENT_CANCELED' )
      ( low = 'BD_EVENT_CHANGED' )
      ( low = 'BD_EVENT_CREATE' )
      ( low = 'CANCEL_BIL_DOC_ODATA' )
      ( low = 'CHECK_BD_FROM_BDR' )
      ( low = 'CHECK_BD_FROM_DMR4' )
      ( low = 'CHECK_BD_FROM_OR' )
      ( low = 'CHECK_BILLING_TYPE' )
      ( low = 'CHECK_EDI_INVOICE_SPLIT_ARIBA' )
      ( low = 'CHECK_EXISTING_BOS' )
      ( low = 'CR_BDR_ED01_EC01' )
      ( low = 'CR_BDR_G2N' )
      ( low = 'CR_BDR_G2N_ED01' )
      ( low = 'CR_BDR_G2N_ED01_SEP' )
      ( low = 'CR_CM01_REF_CI01' )
      ( low = 'CR_CMR' )
      ( low = 'CR_CMR4_REF_CI01' )
      ( low = 'CR_CMR_REF_BD' )
      ( low = 'CR_CMR_REF_SO' )
      ( low = 'CR_DMR4_REF_CI01' )
      ( low = 'CR_DMR_REF_BD' )
      ( low = 'CR_DMR_REF_SO' )
      ( low = 'CR_EBDR_SAME_PREC' )
      ( low = 'INTERCOMDMR' )
      ( low = 'INTERCOMORDER' )
      ( low = 'INTERCOMP_DE_BE' )
      ( low = 'INVOICELIST' )
      ( low = 'INVOICE_CANCEL_INVOICE_LIST' )
      ( low = 'INVOICE_CUSTOMER_INV_CREATE' )
      ( low = 'INVOICE_WITH_FIN_DOC' )
      ( low = 'INV_CANCEL_API' )
      ( low = 'INV_CANCEL_API_NEG' )
      ( low = 'INV_GET_PDF' )
      ( low = 'INV_GET_PDF_NEG_NE' )
      ( low = 'INV_INTRA_REL' )
      ( low = 'ODATA_BDR_FI_REJECT' )
      ( low = 'ODATA_BDR_GET' )
      ( low = 'ODATA_BD_CANCEL_W_OUTP_CHECK' )
      ( low = 'ODATA_GET_INVOICE_LIST' )
      ( low = 'OUTPUT_BD_DMR4' )
      ( low = 'OUTPUT_BD_SFS' )
      ( low = 'OUTPUT_FROM_CONV' )
      ( low = 'OUTPUT_FROM_PS' )
      ( low = 'RAP_SFS_I3_2CNCL' )
      ( low = 'RAP_SFS_I3_NO_FIN_2CNCL' )
      ( low = 'RAP_SFS_I3_Q10_PAL_PARTIAL' )
      ( low = 'RAP_SFS_I3_Q10_PARTIAL' )
      ( low = 'SD_BIL_HF1000003000' )
      ( low = 'SD_BIL_HF1000003924' )
      ( low = 'SD_BIL_HF1000004382' )
      ( low = 'SD_BIL_HF1000006845' )
      ( low = 'SD_BIL_HF14596' )
      ( low = 'SD_BIL_HF16793' )
      ( low = 'SD_BIL_HF17027' )
      ( low = 'SD_BIL_HF18545' )
      ( low = 'SD_BIL_HF4500000036' )
      ( low = 'SD_BIL_HF4500002564' )
      ( low = 'SD_BIL_HF4500002776' )
      ( low = 'SD_BIL_HF4500006204' )
      ( low = 'SD_BIL_HF8131' )
      ( low = 'SD_BIL_OUTPUT_SCHEDULING_PRINT' )
      ( low = 'SD_BIL_OUTPUT_SCHEDULING_P_E' )
      ( low = 'SFS_CANCEL_BD' )
      ( low = 'SFS_CLR_CNCL_I1' )
      ( low = 'SFS_CNCL_I1' )
      ( low = 'SFS_I3' )
      ( low = 'SFS_I50_DIFF_QANTITY' )
      ( low = 'SFS_PBD_BD_CNCL_I1' )
      ( low = 'SFS_PBD_REJ_BD_CNCL_I1' )
      ( low = 'SFS_PBD_REJ_I1' )
      ( low = 'SFS_SPLIT_DIFF_WE_COUNTRIES' )
      ( low = 'SFS_STD' )
      ( low = 'SFS_WITH_TEXT' )
      ( low = 'SNAPSHOT_CHECK' )
      ( low = 'SNAPSHOT_NEG_TEST' )
      ( low = 'SNAP_COMP_INV' )
    ).
  gt_massc[] = VALUE #( sign = 'I' option = 'EQ'
      ( low = 'QUOTE_BDG_01_US' )
      ( low = 'QUOTE_BDG_02_US' )
      ( low = 'QUOTE_BDG_01' )
      ( low = 'QUOTE_BDG_02' )
      ( low = 'MS_1EZ_BD9_DE' )
      ( low = 'MS_1EZ_BD9_US' )
      ( low = 'MS_BKP_BD9_US' )
      ( low = 'MS_BKP_BD9_DE' )
      ( low = 'MS_2EQ_DE' )
      ( low = 'MS_2EQ_US' )
      ( low = 'MS_2ET_DE' )
      ( low = 'MS_2ET_US' )
      ( low = 'BD_FROM_PBD_OR_US' )
      ( low = 'MS_BDA_US' )
      ( low = 'MS_BDA_DE' )
      ( low = 'BD_FROM_PBD_OR_DE' )
      ( low = 'BD9_WITH_TEXT_BEST_PRACTICE_US' )
      ( low = 'BD9_WITH_TEXT_BEST_PRACTICE_DE' )
      ( low = 'BD9_BEST_PRACTICE' )
      ( low = 'BD9_BEST_PRACTICE_US' )
    ).

START-OF-SELECTION.

  IF p_firday IS INITIAL.
    gv_today = sy-datum.
  ELSE.
    gv_today = p_firday.
  ENDIF.

  gv_date_16weeks_back = gv_today - 112.
  gv_date_8weeks_back  = gv_today - 56.
  gv_date_4weeks_back  = gv_today - 28.
  gv_date_2weeks_back  = gv_today - 14.
  gv_date_1week_back   = gv_today - 7.
  gv_date_7days_back   = gv_today - 7.
  gv_date_6days_back   = gv_today - 6.
  gv_date_5days_back   = gv_today - 5.
  gv_date_4days_back   = gv_today - 4.
  gv_date_3days_back   = gv_today - 3.
  gv_date_2days_back   = gv_today - 2.
  gv_date_yesterday    = gv_today - 1.

  gv_date_6month_back = cl_reca_date=>sub_months_from_date( id_months = 6 id_date = gv_today ).

  CASE 'X'.
    WHEN p_sdbil.
      gt_selectoption[] = gt_sdbil[].
    WHEN p_massc.
      gt_selectoption[] = gt_massc[].
    WHEN p_all.
      CLEAR gt_selectoption[].
    WHEN p_selopt.
      PERFORM selopt_select CHANGING gt_selectoption[].
  ENDCASE.

*Result 16 weeks back
  SELECT
    ptf_script
    dump_occured
    start_date
    start_time
    run_result
    runtime
    userid
    is_batch
    session_type
    failed_step_number
    FROM ptf_exec_log
    INTO TABLE gt_ptf_16_weeks
    WHERE start_date BETWEEN gv_date_6month_back AND gv_today
    AND ptf_exec_log~ptf_script IN gt_selectoption[].

  SORT gt_ptf_16_weeks BY start_date DESCENDING.

  "all scripts which we have for 16 weeks
  gr_script = VALUE #( FOR ls_line IN gt_ptf_16_weeks ( " new table entries
                                                  low  = ls_line-ptf_script
                                                  sign  = 'I'
                                                  option = 'EQ' ) ).
  SORT gr_script BY low.
  DELETE ADJACENT DUPLICATES FROM gr_script COMPARING low.

  "agregation line
  APPEND VALUE #( ptf_script = c_aggregated
                  color = VALUE #( ( color-col = 1 color-int = 1 ) ) ) TO gt_alv_table ASSIGNING FIELD-SYMBOL(<ls_aggregated>).

  LOOP AT gt_ptf_16_weeks ASSIGNING FIELD-SYMBOL(<ls_ptf_logg>)
                           GROUP BY ( ptf_script = <ls_ptf_logg>-ptf_script )
                           REFERENCE INTO DATA(group_script).

    LOOP AT GROUP group_script ASSIGNING FIELD-SYMBOL(<ls_group_script>).
      gs_alv-ptf_script = <ls_group_script>-ptf_script.

*lines only for the ptf script
      APPEND <ls_group_script> TO gt_ptf_for_script.
      APPEND INITIAL LINE TO gs_alv-t_details ASSIGNING FIELD-SYMBOL(<ls_details>).
      MOVE-CORRESPONDING <ls_group_script> TO <ls_details>.
      <ls_details>-run_result_icon = lcl_report_utilites=>icon_fill( <ls_details>-run_result ).
    ENDLOOP.

*Last successful test
    IF line_exists( gt_ptf_for_script[ run_result = '0' ] ).
      gs_alv-lastsucc    = gt_ptf_for_script[ run_result = '0' ]-start_date.
    ENDIF.

*Last failed test
    IF line_exists( gt_ptf_for_script[ run_result = '1' ] ).
      gs_alv-lastfail    = gt_ptf_for_script[ run_result = '1' ]-start_date.
    ENDIF.

**Number succesful days (ignoring failed tests at days with a succesful test)
*if there ever has been a day were the script only failed and did not succeed, consider only days AFTER the latest of such days.)
    LOOP AT gt_ptf_for_script ASSIGNING FIELD-SYMBOL(<ls_ptf_log>) WHERE run_result = '1'
                                                                     AND start_date <> gv_today.
      IF NOT line_exists( gt_ptf_for_script[ run_result = '0'
                                             start_date = <ls_ptf_log>-start_date ] ).
        "latest date when script only failed and did not succeed
        IF lv_latest_failed_date < <ls_ptf_log>-start_date.
          lv_latest_failed_date = <ls_ptf_log>-start_date.
        ENDIF.
      ENDIF.

    ENDLOOP.

    LOOP AT gt_ptf_for_script ASSIGNING <ls_ptf_log> WHERE run_result = '0'.
      IF lv_latest_failed_date IS NOT INITIAL.
        "if there ever has been a day were the script only failed and did not succeed, consider only days AFTER the latest of such days
        CHECK <ls_ptf_log>-start_date >= lv_latest_failed_date.
      ENDIF.

      "ignore the current day here. So if yesterday was ok and the daiy before yesterday was failed, SuccDays shall be 1.
      IF gv_day <> <ls_ptf_log>-start_date AND <ls_ptf_log>-start_date <> gv_today.
        gs_alv-hmdaysucc = gs_alv-hmdaysucc + 1.
      ENDIF.
      gv_day = <ls_ptf_log>-start_date.
    ENDLOOP.

*Last dump
    IF line_exists( gt_ptf_for_script[ dump_occured = abap_true ] ).
      gs_alv-lastdump    = gt_ptf_for_script[ dump_occured = abap_true ]-start_date.
    ENDIF.

*Result 6 month back
    LOOP AT gt_ptf_for_script ASSIGNING FIELD-SYMBOL(<ls_6_month>).
      IF <ls_6_month>-run_result = '0'.
        gs_alv-runs6month_s = gs_alv-runs6month_s + 1.
      ELSE.
        gs_alv-runs6month_f = gs_alv-runs6month_f + 1.
      ENDIF.
    ENDLOOP.
    gs_alv-runs6month = gs_alv-runs6month_s + gs_alv-runs6month_f.
    "Success rate last 6 months (Last 6 months successful / Runs in the last 6 months)
    gs_alv-runs6month_srate = lcl_report_utilites=>find_percentage( EXPORTING iv_count = gs_alv-runs6month
                                                                              iv_count_s = gs_alv-runs6month_s
                                                                              iv_zero = '' ).

*Result 16 weeks back
    LOOP AT gt_ptf_for_script ASSIGNING FIELD-SYMBOL(<ls_16_weeks>)
                                               WHERE start_date >= gv_date_16weeks_back
                                                 AND start_date <= gv_today.
      IF <ls_16_weeks>-run_result = '0'.
        gs_alv-last16weeks_s = gs_alv-last16weeks_s + 1.
      ELSE.
        gs_alv-last16weeks_f = gs_alv-last16weeks_f + 1.
      ENDIF.
    ENDLOOP.

*Result 8 weeks back
    LOOP AT gt_ptf_for_script ASSIGNING FIELD-SYMBOL(<ls_8_weeks>)
                                         WHERE start_date >= gv_date_8weeks_back
                                           AND start_date <= gv_today.
      IF <ls_8_weeks>-run_result = '0'.
        gs_alv-last8weeks_s = gs_alv-last8weeks_s + 1.
      ELSE.
        gs_alv-last8weeks_f = gs_alv-last8weeks_f + 1.
      ENDIF.
    ENDLOOP.

*Result 4 weeks back
    LOOP AT gt_ptf_for_script ASSIGNING FIELD-SYMBOL(<ls_4_weeks>)
                                         WHERE start_date >= gv_date_4weeks_back
                                           AND start_date <= gv_today.
      IF <ls_4_weeks>-run_result = '0'.
        gs_alv-last4weeks_s = gs_alv-last4weeks_s + 1.
      ELSE.
        gs_alv-last4weeks_f = gs_alv-last4weeks_f + 1.
      ENDIF.
    ENDLOOP.

*Result 2 weeks back
    LOOP AT gt_ptf_for_script ASSIGNING FIELD-SYMBOL(<ls_2_weeks>)
                                         WHERE start_date >= gv_date_2weeks_back
                                           AND start_date <= gv_today.
      IF <ls_2_weeks>-run_result = '0'.
        gs_alv-last2weeks_s = gs_alv-last2weeks_s + 1.
      ELSE.
        gs_alv-last2weeks_f = gs_alv-last2weeks_f + 1.
      ENDIF.
    ENDLOOP.

*Result 1 week back
    LOOP AT gt_ptf_for_script ASSIGNING FIELD-SYMBOL(<ls_1_week>)
                                         WHERE start_date >= gv_date_1week_back
                                           AND start_date <= gv_today.
      IF <ls_1_week>-run_result = '0'.
        gs_alv-lastweek_s = gs_alv-lastweek_s + 1.
      ELSE.
        gs_alv-lastweek_f = gs_alv-lastweek_f + 1.
      ENDIF.
      gs_alv-lastweek_num = gs_alv-lastweek_num + 1.
    ENDLOOP.

    gs_alv-lastweek_srate = lcl_report_utilites=>find_percentage( EXPORTING iv_count = gs_alv-lastweek_num
                                                                              iv_count_s = gs_alv-lastweek_s
                                                                              iv_zero = '' ).
*Result 7 days back
    PERFORM find_value TABLES gt_ptf_for_script
                        USING gv_date_7days_back
                     CHANGING gs_alv-7daysback
                              gs_aggregated-7daysback
                              gs_aggregated-7daysback_s.

*Result 6 days back
    PERFORM find_value TABLES gt_ptf_for_script
                        USING gv_date_6days_back
                     CHANGING gs_alv-6daysback
                              gs_aggregated-6daysback
                              gs_aggregated-6daysback_s.

*Result 5 days back
    PERFORM find_value TABLES gt_ptf_for_script
                        USING gv_date_5days_back
                     CHANGING gs_alv-5daysback
                              gs_aggregated-5daysback
                              gs_aggregated-5daysback_s.

*Result 4 days back
    PERFORM find_value TABLES gt_ptf_for_script
                        USING gv_date_4days_back
                     CHANGING gs_alv-4daysback
                              gs_aggregated-4daysback
                              gs_aggregated-4daysback_s.

*Result 3 days back
    PERFORM find_value TABLES gt_ptf_for_script
                        USING gv_date_3days_back
                     CHANGING gs_alv-3daysback
                              gs_aggregated-3daysback
                              gs_aggregated-3daysback_s.

*Result 2 days back
    PERFORM find_value TABLES gt_ptf_for_script
                        USING gv_date_2days_back
                     CHANGING gs_alv-2daysback
                              gs_aggregated-2daysback
                              gs_aggregated-2daysback_s.

*Result yesterday
    PERFORM find_value TABLES gt_ptf_for_script
                        USING gv_date_yesterday
                     CHANGING gs_alv-yesterday
                              gs_aggregated-yesterday
                              gs_aggregated-yesterday_s.

*today
    PERFORM find_value TABLES gt_ptf_for_script
                        USING gv_today
                     CHANGING gs_alv-today
                              gs_aggregated-today
                              gs_aggregated-today_s.

    IF p_all = 'X'.
      "scripts (without limits) that have at least one execution in table PTF_EXEC_LOG in the last 2 weeks
      LOOP AT gt_ptf_for_script ASSIGNING <ls_2_weeks>
                                      WHERE start_date >= gv_date_2weeks_back
                                        AND start_date <= gv_today.
        EXIT.
      ENDLOOP.
      CHECK sy-subrc IS INITIAL.
    ENDIF.

    "aggregated line
    "Last successful
    IF gs_alv-lastsucc > <ls_aggregated>-lastsucc.
      <ls_aggregated>-lastsucc = gs_alv-lastsucc.
    ENDIF.

    "Last Failed
    IF gs_alv-lastfail > <ls_aggregated>-lastfail.
      <ls_aggregated>-lastfail = gs_alv-lastfail.
    ENDIF.

    "Last dump
    IF gs_alv-lastdump > <ls_aggregated>-lastdump.
      <ls_aggregated>-lastdump = gs_alv-lastdump.
    ENDIF.

    APPEND gs_alv TO gt_alv_table.
    CLEAR: gs_alv, gv_day, lv_latest_failed_date, gt_ptf_for_script.

  ENDLOOP.

  "Fill WITH successrate of all scripts that run AT the respective day AT least once
  <ls_aggregated>-today = lcl_report_utilites=>find_percentage( EXPORTING iv_count = gs_aggregated-today
                                                                          iv_count_s = gs_aggregated-today_s ).

  <ls_aggregated>-yesterday = lcl_report_utilites=>find_percentage( EXPORTING iv_count = gs_aggregated-yesterday
                                                                              iv_count_s = gs_aggregated-yesterday_s ).

  <ls_aggregated>-2daysback = lcl_report_utilites=>find_percentage( EXPORTING iv_count = gs_aggregated-2daysback
                                                                              iv_count_s = gs_aggregated-2daysback_s ).

  <ls_aggregated>-3daysback = lcl_report_utilites=>find_percentage( EXPORTING iv_count = gs_aggregated-3daysback
                                                                              iv_count_s = gs_aggregated-3daysback_s ).

  <ls_aggregated>-4daysback = lcl_report_utilites=>find_percentage( EXPORTING iv_count = gs_aggregated-4daysback
                                                                              iv_count_s = gs_aggregated-4daysback_s ).

  <ls_aggregated>-5daysback = lcl_report_utilites=>find_percentage( EXPORTING iv_count = gs_aggregated-5daysback
                                                                              iv_count_s = gs_aggregated-5daysback_s ).

  <ls_aggregated>-6daysback = lcl_report_utilites=>find_percentage( EXPORTING iv_count = gs_aggregated-6daysback
                                                                             iv_count_s = gs_aggregated-6daysback_s ).

  <ls_aggregated>-7daysback = lcl_report_utilites=>find_percentage( EXPORTING iv_count = gs_aggregated-7daysback
                                                                             iv_count_s = gs_aggregated-7daysback_s ).

END-OF-SELECTION.

  PERFORM show_grid.

FORM find_value TABLES tt_ptf  TYPE tt_ptf_log
                 USING iv_date TYPE sy-datum
              CHANGING cv_field   TYPE any
                       cv_count   TYPE int4
                       cv_count_s TYPE int4.

  TYPES: ltt_ptf_log TYPE STANDARD TABLE OF ptf_exec_log-ptf_script WITH NON-UNIQUE DEFAULT KEY.

  "all lines for the current date
  DATA(lt_ptf_date) = VALUE ltt_ptf_log( FOR ls_date IN tt_ptf WHERE ( start_date = iv_date ) ( ls_date-ptf_script ) ).

  IF line_exists( tt_ptf[ run_result = '0' start_date = iv_date ] ).
    "have successful run
    cv_field = c_ok.

  ELSE.
    "do not have successful runs but have failed
    IF line_exists( tt_ptf[ run_result = '1' start_date = iv_date ] ).
      "If all runs of the current script at this specific day did dump, please say “DUMP” instead of “FAILED”
      DATA(lt_ptf_dumped) = VALUE ltt_ptf_log( FOR ls_dumped IN tt_ptf WHERE ( dump_occured = abap_true AND start_date = iv_date ) ( ls_dumped-ptf_script ) ).

      IF lines( lt_ptf_dumped[] ) EQ lines( lt_ptf_date[] ).
        cv_field = c_dump.
      ELSE.
        cv_field = c_failed.
      ENDIF.

    ENDIF.

  ENDIF.
  cv_count = cv_count + lines( lt_ptf_date[] ).
  cv_count_s = cv_count_s + lines( VALUE ltt_ptf_log( FOR ls_date IN tt_ptf WHERE ( start_date = iv_date AND run_result = '0' ) ( ls_date-ptf_script ) ) ).

ENDFORM.

FORM show_grid.

  TRY.
      cl_salv_table=>factory(
      EXPORTING
        list_display = abap_false
      IMPORTING
        r_salv_table = go_alv
      CHANGING
        t_table = gt_alv_table ).

    CATCH cx_salv_msg.
      RETURN.
  ENDTRY.

  PERFORM top_of_page CHANGING go_alv.

  PERFORM set_columns CHANGING go_alv.

  TRY.
      go_alv->get_columns( )->set_color_column( 'COLOR' ).
    CATCH cx_salv_data_error.
      RETURN.
  ENDTRY.
  DATA(lo_display) = go_alv->get_display_settings( ).
  lo_display->set_striped_pattern( cl_salv_display_settings=>true ).

  DATA: lo_functions TYPE REF TO cl_salv_functions_list.

  lo_functions = go_alv->get_functions( ).
  lo_functions->set_all( ).

  PERFORM alv_layout.
  PERFORM alv_event.

  go_alv->display( ).

ENDFORM.

FORM alv_event.
  DATA: lr_events TYPE REF TO cl_salv_events_table.

  lr_events = go_alv->get_event( ).
  CREATE OBJECT gr_events.

  "register to the event DOUBLE_CLICK
  SET HANDLER gr_events->on_double_click FOR lr_events.

ENDFORM.

FORM alv_layout.
  DATA: ls_key          TYPE salv_s_layout_key,
        lr_layout       TYPE REF TO cl_salv_layout,
        ls_variant      TYPE disvariant,
        lv_default_vari TYPE slis_vari.

  "get layout
  lr_layout =  go_alv->get_layout( ).

  "Saving Layouts
  ls_key-report = sy-repid.
  lr_layout->set_key( ls_key ).
  lr_layout->set_save_restriction( cl_salv_layout=>restrict_none ).

  CLEAR ls_variant.
  ls_variant-report = sy-repid.
  ls_variant-username = sy-uname.
  CALL FUNCTION 'REUSE_ALV_VARIANT_DEFAULT_GET'
    CHANGING
      cs_variant = ls_variant
    EXCEPTIONS
      not_found  = 2.

  IF sy-subrc EQ 0 AND ls_variant-variant IS NOT INITIAL.
    lv_default_vari = ls_variant-variant.
    lr_layout->set_initial_layout( value = lv_default_vari  ).
  ENDIF.

*allow setting layouts as default layouts
*lo_alv->get_layout( )->set_default( abap_true ).

ENDFORM.

FORM top_of_page CHANGING co_alv TYPE REF TO cl_salv_table.
  DATA: lo_grid        TYPE REF TO cl_salv_form_layout_grid.

  DATA: lv_text             TYPE string,
        lv_count            TYPE int4,
        lv_ok_yesterday     TYPE int4,
        lv_failed_yesterday TYPE int4,
        lv_percentage_text  TYPE string,
        lv_percentage       TYPE p DECIMALS 3,
        lv_row              TYPE i,
        lv_1day_left        TYPE sy-datum,
        lv_yesterday_date   TYPE char20.

  CREATE OBJECT lo_grid.

  lo_grid->create_header_information(
    row     = 1
    column  = 1
    text    = 'Results of PTF Script Runs' ).

  lo_grid->add_row( ).

  "Which RadioButton was chosen
  CASE 'X'.
    WHEN p_all.
      lv_text = 'All'.
    WHEN p_massc.
      lv_text = 'MasterScenarios'.
    WHEN p_sdbil.
      lv_text = 'SDBIL'.
    WHEN p_selopt.
      lv_text = 'Select Options'.
  ENDCASE.
  lv_text = |Selection: { lv_text }|.

  DATA(lo_label) = lo_grid->create_label(
    row     = 3
    column  = 1
    text    = lv_text ).

  lv_row = 4.
  IF NOT p_firday IS INITIAL.
    lv_text = |Cut-off Date: { cl_reca_date=>as_char( EXPORTING id_date = p_firday ) }|.

    lo_grid->create_text(
      row     = lv_row
      column  = 1
      text    = lv_text ).
    lv_row = lv_row + 1.
  ENDIF.

  "How many scripts have been selected
  lv_count = lines( gt_alv_table[] ).
  IF lv_count > 0. lv_count = lv_count - 1. ENDIF. "-1 for agregated line

  lv_text = |Scripts found: { lv_count }|.

  lo_grid->create_text(
    row     = lv_row
    column  = 1
    text    = lv_text ).
  lv_row = lv_row + 1.

  "for the calculations of the Script Success Rate percentage, use only the scripts executed yesterday)
  LOOP AT gt_alv_table ASSIGNING FIELD-SYMBOL(<ls_alv_table>) FROM 2.
    CASE <ls_alv_table>-yesterday.
      WHEN c_ok.
        "How many of these scripts have run successfully yesterday at least once.
        lv_ok_yesterday = lv_ok_yesterday + 1.

      WHEN c_failed OR c_dump.
        "How many of these scripts have run yesterday and did not succeed at least once.
        lv_failed_yesterday = lv_failed_yesterday + 1.

    ENDCASE.
  ENDLOOP.
  DATA(lv_count_yesterday) = lv_ok_yesterday + lv_failed_yesterday.

  IF p_firday IS INITIAL.
    lv_yesterday_date = 'yesterday'.
  ELSE.
    lv_1day_left = p_firday - 1.
    WRITE lv_1day_left TO lv_yesterday_date MM/DD/YYYY.
    lv_yesterday_date = |on { lv_yesterday_date }|.
  ENDIF.

  lv_text = |{ lv_count_yesterday } Scripts executed { lv_yesterday_date }. Successful: { lv_ok_yesterday }, failed: { lv_failed_yesterday }.|.

  lv_percentage_text = lcl_report_utilites=>find_percentage( EXPORTING iv_count = lv_count_yesterday
                                                                       iv_count_s = lv_ok_yesterday ).

  lv_text = |{ lv_text }  Script Success Rate: { lv_percentage_text }|.

  lo_grid->create_text(
    row     = lv_row
    column  = 1
    text    = lv_text ).

  co_alv->set_top_of_list( lo_grid ).

ENDFORM.                    " TOP_OF_PAGE

FORM set_columns CHANGING co_alv TYPE REF TO cl_salv_table.
  DATA: lo_column         TYPE REF TO cl_salv_column,
        lo_column_list    TYPE REF TO cl_salv_column_list,
        lo_columns        TYPE REF TO cl_salv_columns_table, "cl_salv_columns,
        lo_column_one     TYPE REF TO cl_salv_column_table,
        ls_color_1week    TYPE lvc_s_colo,
        ls_color_2week    TYPE lvc_s_colo,
        ls_color_4week    TYPE lvc_s_colo,
        ls_color_8week    TYPE lvc_s_colo,
        ls_color_16week   TYPE lvc_s_colo,
        ls_color_6month   TYPE lvc_s_colo,
        ls_color_days     TYPE lvc_s_colo,
        ls_color_today    TYPE lvc_s_colo,
        ls_color_key      TYPE lvc_s_colo,
        lv_first_day_text TYPE string,
        lv_1dayleft_text  TYPE string,
        lv_1day_left      TYPE sy-datum.

  "1-light blue, 2-grey blue, 3 - yellow, 4 - green blue, 5 - green, 6 - red, 7 - orange
  ls_color_days-col = 1. ""
  ls_color_days-int = 0.

  ls_color_1week-col = 2. ""
  ls_color_1week-int = 0.

  ls_color_2week-col = 5.
  ls_color_2week-int = 0.

  ls_color_4week-col = 7.
  ls_color_4week-int = 0.

  ls_color_8week-col = 4.
  ls_color_8week-int = 1.

  ls_color_16week-col = 1.
  ls_color_16week-int = 1.

  ls_color_6month-col = 2.
  ls_color_6month-int = 1.

  ls_color_today-col = 4.
  ls_color_today-int = 0.

  ls_color_key-col = 1.
  ls_color_key-int = 1.

  lo_columns = co_alv->get_columns( ).
  TRY .
*1
      lo_column = lo_columns->get_column( 'PTF_SCRIPT' ).
      lo_column->set_optimized( abap_true ).
      lo_column->set_output_length( 40 ).
      lo_column_list ?= lo_column.
      lo_column_list->set_optimized( 'X' ).
      "lo_column_list->set_key( ).
      lo_column_one ?= lo_column.
      lo_column_one->set_color( ls_color_key ).
*2
      lo_column = lo_columns->get_column( 'HMDAYSUCC' ).
      lo_column->set_short_text( 'Succ days' ).
      lo_column->set_medium_text( 'Successful days' ).
      lo_column->set_long_text( 'How many days successful?' ).
      lo_column->set_optimized( abap_true ).
      lo_column->set_output_length( 8 ).
*3
      lo_column = lo_columns->get_column( 'LASTSUCC' ).
      lo_column->set_short_text( 'Last succ' ).
      lo_column->set_medium_text( 'When last successful' ).
      lo_column->set_long_text( 'When last successful?' ).
      lo_column->set_optimized( abap_true ).
      lo_column->set_output_length( 9 ).
*4
      lo_column = lo_columns->get_column( 'LASTFAIL' ).
      lo_column->set_short_text( 'Last fail' ).
      lo_column->set_medium_text( 'When last failed?' ).
      lo_column->set_long_text( 'When last failed?' ).
      lo_column->set_optimized( abap_true ).
      lo_column->set_output_length( 9 ).
*5
      lo_column = lo_columns->get_column( 'LASTDUMP' ).
      lo_column->set_short_text( 'Last dump' ).
      lo_column->set_medium_text( 'When last dumped?' ).
      lo_column->set_long_text( 'When last dumped?' ).
      lo_column->set_optimized( abap_true ).
      lo_column->set_output_length( 9 ).

      IF p_firday IS INITIAL.
        lv_first_day_text = 'Today'.
        lv_1dayleft_text = 'Yesterday'.
      ELSE.
        lv_first_day_text = lcl_report_utilites=>change_date_to_text( p_firday ).
        lv_1day_left = p_firday - 1.
        lv_1dayleft_text = lcl_report_utilites=>change_date_to_text( lv_1day_left ).
      ENDIF.

      lo_column = lo_columns->get_column( 'TODAY' ).
      lo_column->set_short_text( CONV scrtext_s( lv_first_day_text ) ).
      lo_column->set_medium_text( CONV scrtext_m( lv_first_day_text ) ).
      lo_column->set_long_text( CONV scrtext_l( lv_first_day_text ) ).
      lo_column->set_optimized( abap_true ).
      lo_column->set_output_length( 7 ).
      lo_column_one ?= lo_column.
      lo_column_one->set_color( ls_color_today ).
      lo_column->set_alignment( if_salv_c_alignment=>right ).

*6
      lo_column = lo_columns->get_column( 'YESTERDAY' ).
      lo_column->set_short_text( CONV scrtext_s( lv_1dayleft_text ) ).
      lo_column->set_medium_text( CONV scrtext_m( lv_1dayleft_text ) ).
      lo_column->set_long_text( CONV scrtext_l( lv_1dayleft_text ) ).
      lo_column->set_optimized( abap_true ).
      lo_column->set_output_length( 8 ).
      lo_column_one ?= lo_column.
      lo_column_one->set_color( ls_color_days ).
      lo_column->set_alignment( if_salv_c_alignment=>right ).
*7
      lo_column = lo_columns->get_column( '2DAYSBACK' ).
      lo_column->set_short_text( '2d back' ).
      lo_column->set_medium_text( '2 days back' ).
      lo_column->set_long_text( '2 days back' ).
      lo_column->set_optimized( abap_true ).
      lo_column->set_output_length( 6 ).
      lo_column_one ?= lo_column.
      lo_column_one->set_color( ls_color_days ).
      lo_column->set_alignment( if_salv_c_alignment=>right ).
*8
      lo_column = lo_columns->get_column( '3DAYSBACK' ).
      lo_column->set_short_text( '3d back' ).
      lo_column->set_medium_text( '3 days back' ).
      lo_column->set_long_text( '3 days back' ).
      lo_column->set_optimized( abap_true ).
      lo_column->set_output_length( 6 ).
      lo_column_one ?= lo_column.
      lo_column_one->set_color( ls_color_days ).
      lo_column->set_alignment( if_salv_c_alignment=>right ).
*9
      lo_column = lo_columns->get_column( '4DAYSBACK' ).
      lo_column->set_short_text( '4d back' ).
      lo_column->set_medium_text( '4 days back' ).
      lo_column->set_long_text( '4 days back' ).
      lo_column->set_optimized( abap_true ).
      lo_column->set_output_length( 6 ).
      lo_column_one ?= lo_column.
      lo_column_one->set_color( ls_color_days ).
      lo_column->set_alignment( if_salv_c_alignment=>right ).

      lo_column = lo_columns->get_column( '5DAYSBACK' ).
      lo_column->set_short_text( '5d back' ).
      lo_column->set_medium_text( '5 days back' ).
      lo_column->set_long_text( '5 days back' ).
      lo_column->set_output_length( 6 ).
      lo_column_one ?= lo_column.
      lo_column_one->set_color( ls_color_days ).
      lo_column->set_alignment( if_salv_c_alignment=>right ).

      lo_column = lo_columns->get_column( '6DAYSBACK' ).
      lo_column->set_short_text( '6d back' ).
      lo_column->set_medium_text( '6 days back' ).
      lo_column->set_long_text( '6 days back' ).
      lo_column->set_output_length( 6 ).
      lo_column_one ?= lo_column.
      lo_column_one->set_color( ls_color_days ).
      lo_column->set_alignment( if_salv_c_alignment=>right ).

      lo_column = lo_columns->get_column( '7DAYSBACK' ).
      lo_column->set_short_text( '7d back' ).
      lo_column->set_medium_text( '7 days back' ).
      lo_column->set_long_text( '7 days back' ).
      lo_column->set_output_length( 6 ).
      lo_column_one ?= lo_column.
      lo_column_one->set_color( ls_color_days ).
      lo_column->set_alignment( if_salv_c_alignment=>right ).

      lo_column = lo_columns->get_column( 'LASTWEEK_NUM' ).
      lo_column->set_short_text( 'Runs1week' ).
      lo_column->set_medium_text( 'Last week NumbRuns' ).
      lo_column->set_long_text( 'Last week number of runs' ).
      lo_column->set_output_length( 9 ).
      lo_column_one ?= lo_column.
      lo_column_one->set_color( ls_color_1week ).
      lo_column->set_zero( '' ).
*10
      lo_column = lo_columns->get_column( 'LASTWEEK_S' ).
      lo_column->set_short_text( 'S 1week' ).
      lo_column->set_medium_text( 'Last week successful' ).
      lo_column->set_long_text( 'Last week successful' ).
      lo_column->set_output_length( 7 ).
      lo_column_one ?= lo_column.
      lo_column_one->set_color( ls_color_1week ).
      lo_column->set_zero( '' ).
*11
      lo_column = lo_columns->get_column( 'LASTWEEK_F' ).
      lo_column->set_short_text( 'F 1week' ).
      lo_column->set_medium_text( 'Last week failed' ).
      lo_column->set_long_text( 'Last week failed' ).
      lo_column->set_output_length( 7 ).
      lo_column_one ?= lo_column.
      lo_column_one->set_color( ls_color_1week ).
      lo_column->set_zero( '' ).

      lo_column = lo_columns->get_column( 'LASTWEEK_SRATE' ).
      lo_column->set_short_text( 'SRate1week' ).
      lo_column->set_medium_text( 'Last week SuccRate' ).
      lo_column->set_long_text( 'Last week success rate' ).
      lo_column->set_output_length( 10 ).
      lo_column->set_visible( abap_false ).
      "lo_column->set_edit_mask( '___%' ).
      lo_column->set_alignment( if_salv_c_alignment=>right ).
      lo_column_one ?= lo_column.
      lo_column_one->set_color( ls_color_1week ).
*12
      lo_column = lo_columns->get_column( 'LAST2WEEKS_S' ).
      lo_column->set_short_text( 'S 2week' ).
      lo_column->set_medium_text( 'Last 2 weeks success' ).
      lo_column->set_long_text( 'Last 2 weeks successful' ).
      lo_column->set_output_length( 7 ).
      lo_column->set_visible( abap_false ).
      lo_column_one ?= lo_column.
      lo_column_one->set_color( ls_color_2week ).
      lo_column->set_zero( '' ).
*13
      lo_column = lo_columns->get_column( 'LAST2WEEKS_F' ).
      lo_column->set_short_text( 'F 2week' ).
      lo_column->set_medium_text( 'Last 2 weeks failed' ).
      lo_column->set_long_text( 'Last 2 weeks failed' ).
      lo_column->set_output_length( 7 ).
      lo_column->set_visible( abap_false ).
      lo_column_one ?= lo_column.
      lo_column_one->set_color( ls_color_2week ).
      lo_column->set_zero( '' ).
*14
      lo_column = lo_columns->get_column( 'LAST4WEEKS_S' ).
      lo_column->set_short_text( 'S 4week' ).
      lo_column->set_medium_text( 'Last 4 weeks succ' ).
      lo_column->set_long_text( 'Last 4 weeks successful' ).
      lo_column->set_output_length( 7 ).
      lo_column->set_visible( abap_false ).
      lo_column_one ?= lo_column.
      lo_column_one->set_color( ls_color_4week ).
      lo_column->set_zero( '' ).
*15
      lo_column = lo_columns->get_column( 'LAST4WEEKS_F' ).
      lo_column->set_short_text( 'F 4week' ).
      lo_column->set_medium_text( 'Last 4 weeks failed' ).
      lo_column->set_long_text( 'Last 4 weeks failed' ).
      lo_column->set_output_length( 7 ).
      lo_column->set_visible( abap_false ).
      lo_column_one ?= lo_column.
      lo_column_one->set_color( ls_color_4week ).
      lo_column->set_zero( '' ).
*16
      lo_column = lo_columns->get_column( 'LAST8WEEKS_S' ).
      lo_column->set_short_text( 'S 8week' ).
      lo_column->set_medium_text( 'Last 8 weeks succ' ).
      lo_column->set_long_text( 'Last 8 weeks successful' ).
      lo_column->set_output_length( 7 ).
      lo_column->set_visible( abap_false ).
      lo_column_one ?= lo_column.
      lo_column_one->set_color( ls_color_8week ).
      lo_column->set_zero( '' ).
*17
      lo_column = lo_columns->get_column( 'LAST8WEEKS_F' ).
      lo_column->set_short_text( 'F 8week' ).
      lo_column->set_medium_text( 'Last 8 weeks failed' ).
      lo_column->set_long_text( 'Last 8 weeks failed' ).
      lo_column->set_output_length( 7 ).
      lo_column->set_zero( '' ).
      lo_column->set_visible( abap_false ).
      lo_column_one ?= lo_column.
      lo_column_one->set_color( ls_color_8week ).
*18
      lo_column = lo_columns->get_column( 'LAST16WEEKS_S' ).
      lo_column->set_short_text( 'S 16week' ).
      lo_column->set_medium_text( 'Last 16 weeks succ' ).
      lo_column->set_long_text( 'Last 16 weeks successful' ).
      lo_column->set_output_length( 8 ).
      lo_column->set_visible( abap_false ).
      lo_column_one ?= lo_column.
      lo_column_one->set_color( ls_color_16week ).
      lo_column->set_zero( '' ).
*19
      lo_column = lo_columns->get_column( 'LAST16WEEKS_F' ).
      lo_column->set_short_text( 'F 16week' ).
      lo_column->set_medium_text( 'Last 16 weeks failed' ).
      lo_column->set_long_text( 'Last 16 weeks failed' ).
      lo_column->set_output_length( 8 ).
      lo_column->set_visible( abap_false ).
      lo_column_one ?= lo_column.
      lo_column_one->set_color( ls_color_16week ).
      "lo_column->set_alignment( if_salv_c_alignment=>left ).
      lo_column->set_zero( '' ).

      lo_column = lo_columns->get_column( 'RUNS6MONTH' ).
      lo_column->set_short_text( 'Runs6month' ).
      lo_column->set_medium_text( 'Runs last 6 months' ).
      lo_column->set_long_text( 'Runs in the last 6 months' ).
      lo_column->set_output_length( 10 ).
      lo_column_one ?= lo_column.
      lo_column_one->set_color( ls_color_6month ).
      lo_column->set_zero( '' ).

      lo_column = lo_columns->get_column( 'RUNS6MONTH_S' ).
      lo_column->set_short_text( 'S 6months' ).
      lo_column->set_medium_text( 'Last 6 months succ' ).
      lo_column->set_long_text( 'Last 6 months successful' ).
      lo_column->set_output_length( 9 ).
      lo_column_one ?= lo_column.
      lo_column_one->set_color( ls_color_6month ).
      lo_column->set_zero( '' ).

      lo_column = lo_columns->get_column( 'RUNS6MONTH_F' ).
      lo_column->set_short_text( 'F 6months' ).
      lo_column->set_medium_text( 'Last 6 months failed' ).
      lo_column->set_long_text( 'Last 6 months failed' ).
      lo_column->set_output_length( 9 ).
      lo_column_one ?= lo_column.
      lo_column_one->set_color( ls_color_6month ).
      lo_column->set_zero( '' ).

      lo_column = lo_columns->get_column( 'RUNS6MONTH_SRATE' ).
      lo_column->set_short_text( 'SRate6mon' ).
      lo_column->set_medium_text( 'SuccRate 6 months' ).
      lo_column->set_long_text( 'Success rate last 6 months' ).
      "lo_column->set_edit_mask( '___%' ).
      lo_column->set_alignment( if_salv_c_alignment=>right ).
      lo_column->set_output_length( 9 ).
      lo_column_one ?= lo_column.
      lo_column_one->set_color( ls_color_6month ).

    CATCH cx_salv_data_error INTO DATA(lv_data_error).
    CATCH cx_salv_not_found INTO DATA(lv_not_found).
  ENDTRY.
  "lo_columns->set_optimize( 'X' ).
  "lo_columns->set_cell_type_column( 'I_CELLTYPE' ).

ENDFORM.                    " SET_TITLE

FORM selopt_select CHANGING lt_selectoption LIKE gt_selectoption[].

  DATA lt_varname TYPE STANDARD TABLE OF ptf_varname.

  "1. param
  IF s_script[] IS NOT INITIAL.
    SELECT varname
      FROM ptf_varid
      INTO TABLE @lt_varname
      WHERE varname IN @s_script[].

  ENDIF.

  "2.param
  IF s_tags[] IS NOT INITIAL.
    SELECT varname
      FROM ptf_var_tag_map
      APPENDING TABLE @lt_varname
      WHERE tag IN @s_tags[].

  ENDIF.

  "3. param
  IF s_sitem[] IS NOT INITIAL.
    SELECT varname
      FROM ptf_varid
      APPENDING TABLE @lt_varname
      WHERE scope_item IN @s_sitem[].

  ENDIF.

  cl_ptf_util=>remove_duplicate_scripts(
    EXPORTING
      it_varname         = lt_varname
    IMPORTING
      et_varname_unique  = DATA(lt_varname_unique)
  ).

  LOOP AT lt_varname_unique ASSIGNING FIELD-SYMBOL(<ls_varname>).
    APPEND VALUE #( sign = 'I'
                    option = 'EQ'
                    low = <ls_varname> ) TO lt_selectoption.

  ENDLOOP.

ENDFORM.

FORM set_columns_for_details CHANGING co_alv TYPE REF TO cl_salv_table.
  DATA: lo_column      TYPE REF TO cl_salv_column,
        lo_column_list TYPE REF TO cl_salv_column_list,
        lo_columns     TYPE REF TO cl_salv_columns_table.

  lo_columns = co_alv->get_columns( ).
  TRY .
      lo_column = lo_columns->get_column( 'PTF_SCRIPT' ).
      lo_column_list ?= lo_column.
      lo_column_list->set_optimized( abap_true ).
      lo_column_list->set_key( ).

      lo_column = lo_columns->get_column( 'RUN_RESULT' ).
      lo_column->set_short_text( 'RunResult' ).
      lo_column->set_medium_text( 'Run Result' ).
      lo_column->set_long_text( 'Run Result' ).
      lo_column->set_technical( abap_true ).
      lo_column->set_output_length( 9 ).

      lo_column = lo_columns->get_column( 'RUN_RESULT_ICON' ).
      lo_column->set_short_text( 'RunResult' ).
      lo_column->set_medium_text( 'Run Result' ).
      lo_column->set_long_text( 'Run Result' ).
      lo_column->set_output_length( 9 ).
      lo_column->set_alignment( if_salv_c_alignment=>centered ).

      lo_column = lo_columns->get_column( 'FAILED_STEP_NUMBER' ).
      lo_column->set_short_text( 'FailStNum' ).
      lo_column->set_medium_text( 'Failed Step Number' ).
      lo_column->set_long_text( 'Step Number where the test failed' ).
      lo_column->set_output_length( 9 ).

      lo_column = lo_columns->get_column( 'DUMP_OCCURED' ).
      lo_column->set_short_text( 'Dumped' ).
      lo_column->set_medium_text( 'Dumped' ).
      lo_column->set_long_text( 'Dumped' ).
      lo_column->set_alignment( if_salv_c_alignment=>centered ).
      lo_column->set_output_length( 7 ).

      lo_column = lo_columns->get_column( 'IS_BATCH' ).
      lo_column->set_output_length( 5 ).

      lo_column = lo_columns->get_column( 'SESSION_TYPE' ).
      lo_column->set_output_length( 8 ).

      lo_column = lo_columns->get_column( 'FAILED_STEP_NUMBER' ).
      lo_column->set_output_length( 8 ).

    CATCH cx_salv_data_error INTO DATA(lv_data_error).
    CATCH cx_salv_not_found INTO DATA(lv_not_found).
  ENDTRY.
  lo_columns->set_optimize( '' ).

ENDFORM.                    " SET_TITLE

FORM top_of_page_for_details USING iv_ptf_script TYPE ptf_exec_log-ptf_script
                                   iv_runs       TYPE int4
                                   iv_successful TYPE int4
                                   iv_failed     TYPE int4
                                   iv_rate       TYPE char10
                          CHANGING co_alv TYPE REF TO cl_salv_table.

  DATA: lo_grid  TYPE REF TO cl_salv_form_layout_grid,
        lv_title TYPE string,
        lv_text  TYPE string.

  CREATE OBJECT lo_grid.

  lv_title = |Runs of PTF Script { iv_ptf_script }|.
  lo_grid->create_header_information(
    row     = 1
    column  = 1
    text    = lv_title ).

  lo_grid->add_row( ).


  "How many scripts have been selected
  lv_text = |Runs: { iv_runs }|.

  lo_grid->create_text(
    row     = 3
    column  = 1
    text    = lv_text ).

  lv_text = |Successful: { iv_successful }|.
  lo_grid->create_text(
  row     = 4
  column  = 1
  text    = lv_text ).

  lv_text = |Failed: { iv_failed }|.
  lo_grid->create_text(
  row     = 5
  column  = 1
  text    = lv_text ).

  lv_text = |Success rate: { iv_rate }|.
  lo_grid->create_text(
  row     = 6
  column  = 1
  text    = lv_text ).

  co_alv->set_top_of_list( lo_grid ).

ENDFORM.                    " TOP_OF_PAGE

FORM set_sort_details CHANGING co_alv TYPE REF TO cl_salv_table.
  DATA: lo_sort TYPE REF TO cl_salv_sorts.

  lo_sort = co_alv->get_sorts( ).

  IF lo_sort IS NOT INITIAL.
    TRY .
        lo_sort->add_sort(
          columnname  = 'START_DATE'
          position    = 1
          sequence    = if_salv_c_sort=>sort_down
          ).

      CATCH cx_salv_not_found.
      CATCH cx_salv_existing.
      CATCH cx_salv_data_error.
    ENDTRY.

    TRY .
        lo_sort->add_sort(
         columnname   = 'START_TIME'
          position    = 2
          sequence    = if_salv_c_sort=>sort_down
          ).

      CATCH cx_salv_not_found.
      CATCH cx_salv_existing.
      CATCH cx_salv_data_error.
    ENDTRY.
  ENDIF.

ENDFORM.                    " SET_SORT

FORM display_details TABLES t_details TYPE tt_alv_secondlevel
                      USING iv_ptf_script TYPE ptf_exec_log-ptf_script
                   CHANGING co_alv TYPE REF TO cl_salv_table.

  DATA: lo_functions  TYPE REF TO cl_salv_functions_list,
*        lv_rate_p     TYPE p DECIMALS 3,
        lv_rate       TYPE char10,
        lv_failed     TYPE int4,
        lv_successful TYPE int4.

  TRY.
      cl_salv_table=>factory(
                        EXPORTING
                          list_display = abap_false
                        IMPORTING
                          r_salv_table = co_alv
                        CHANGING
                          t_table = t_details[] ).
    CATCH cx_salv_msg.
      RETURN.
  ENDTRY.

  DATA(lv_runs) = lines( t_details[] ).
  LOOP AT t_details ASSIGNING FIELD-SYMBOL(<ls_details>).
    CASE <ls_details>-run_result.
      WHEN '0'.
        lv_successful = lv_successful + 1.
      WHEN '1'.
        lv_failed = lv_failed + 1.
    ENDCASE.
  ENDLOOP.

  lv_rate = lcl_report_utilites=>find_percentage( EXPORTING iv_count = lv_runs
                                                            iv_count_s = lv_successful ).

  PERFORM set_columns_for_details CHANGING co_alv.
  PERFORM top_of_page_for_details USING iv_ptf_script
                                        lv_runs
                                        lv_successful
                                        lv_failed
                                        lv_rate
                               CHANGING co_alv.

  DATA(lo_display) = co_alv->get_display_settings( ).
  lo_display->set_striped_pattern( cl_salv_display_settings=>true ).

  lo_functions = co_alv->get_functions( ).
  lo_functions->set_all( ).

  co_alv->display( ).

ENDFORM.

FORM show_double_click USING iv_row    TYPE i
                             iv_column TYPE lvc_fname.

  DATA lo_alv       TYPE REF TO cl_salv_table.

  CHECK iv_column <> c_aggregated.

  READ TABLE gt_alv_table ASSIGNING FIELD-SYMBOL(<ls_alv>) INDEX iv_row.
  IF sy-subrc EQ 0 AND <ls_alv>-ptf_script <> c_aggregated.
    PERFORM display_details TABLES <ls_alv>-t_details
                             USING <ls_alv>-ptf_script
                          CHANGING lo_alv.
  ENDIF.

ENDFORM.                    " show_cell_info
