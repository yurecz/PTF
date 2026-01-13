CLASS cl_ptf_util DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      "the following 6 types are used only in CL_PTF_BO_CMR - why are they here? should be stored BO specififc or in the SD util class
** Structure for Item List
      BEGIN OF ty_gs_item_list_td,
        material_id TYPE matnr,
        quantity    TYPE dzmeng,
        posnr       TYPE posnr_va,
        fkdat       TYPE fkdat,
        werks       TYPE werks_d,
      END OF ty_gs_item_list_td .
    TYPES:
** Structure for extensibility field
      BEGIN OF ty_gs_ext_field_td,
        name           TYPE string,
        type           TYPE string,
        data_type      TYPE string,
        expected_input TYPE string,
      END OF ty_gs_ext_field_td .
    TYPES:
** Table for extensibility field
      ty_gt_ext_field_td      TYPE STANDARD TABLE OF ty_gs_ext_field_td WITH NON-UNIQUE KEY name .
    TYPES:
      lty_sales_conditions_in TYPE STANDARD TABLE OF bapicond  WITH DEFAULT KEY .
    TYPES:
** Table for Item List
      ty_gt_item_list_td      TYPE STANDARD TABLE OF ty_gs_item_list_td WITH NON-UNIQUE KEY posnr .
    TYPES:
      ty_order_partners       TYPE STANDARD TABLE OF bapiparnr WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_i_ptf_ext_field_check_td,   "never used?
        ext_fields TYPE ty_gt_ext_field_td,
      END OF ty_gs_i_ptf_ext_field_check_td .
    TYPES:
      ty_bapisdtext TYPE STANDARD TABLE OF bapisdtext WITH DEFAULT KEY . "not used??
    TYPES:
* Types for Testreport:********************************************************************************
      BEGIN OF ty_vbeln,
        vbeln TYPE ptfkey,
      END OF ty_vbeln .
    TYPES:
      ty_vbeln_tab      TYPE STANDARD TABLE OF ty_vbeln WITH NON-UNIQUE KEY vbeln .
    TYPES:
*Return Table for Application Log, it is inlucded in every Interface of all methods of the PTF
      gt_ptf_return_tab TYPE TABLE OF bapiret2 WITH DEFAULT KEY .
    TYPES gty_ref_step TYPE i .
    TYPES:
      gty_reference_tab TYPE STANDARD TABLE OF gty_ref_step WITH DEFAULT KEY .
    TYPES:  gt_ptf_step TYPE ptf_Step.

    TYPES:
      gt_ptf_step_tab TYPE TABLE OF gt_ptf_step WITH DEFAULT KEY .
    TYPES:
      BEGIN OF gty_sel_screen,
        ptf_bo       TYPE ptfbo,
        ptf_act      TYPE ptf_act,
        ptf_tdcv     TYPE ptf_tdcv,
        ptf_ref_step TYPE ptf_ref_step,
        ptf_var_step TYPE string,
      END OF gty_sel_screen .
    TYPES:
      BEGIN OF ty_outtab,                "all fields of the main ALV view
        step_number         TYPE i,
        bus_obj             TYPE ptf_bo,
        action              TYPE ptf_act,
        variant             TYPE ptf_tdcv,
        test_data_container TYPE etobj_name,
        reference_step      TYPE numc3,
        reference_step_more TYPE icon_d,
*         reference_document_id      TYPE vbeln,
*         reference_document_id_more TYPE icon_d,
        document_id         TYPE ptfkey,
        document_id_more    TYPE icon_d,
        is_manual           TYPE abap_bool,
        json_file           TYPE string,
        json_file_more      TYPE icon_d,
        exp_messages        TYPE ptf_exp_message_t,
        act_messages        TYPE bapirettab,
        execution_status    TYPE icon_d,
        check_status        TYPE icon_d,
        handle_style        TYPE lvc_t_styl,
      END OF ty_outtab .
    TYPES:
      ty_outtab_tab TYPE TABLE OF ty_outtab .
    TYPES:
      BEGIN OF gty_char_table,
        col TYPE c LENGTH 15,
      END OF gty_char_table .
    TYPES:
      BEGIN OF ty_result_key_data,
        step_number          TYPE i,
        bus_obj              TYPE ptf_bo,
        sbo_bo_type          TYPE sbo_bo_type,
        document_id_char70   TYPE ty_vbeln,
        document_id_key_type TYPE REF TO data,
      END OF ty_result_key_data .
    TYPES:
      ty_result_key_data_tab TYPE STANDARD TABLE OF ty_result_key_data WITH NON-UNIQUE DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_field,
        fieldname  TYPE name_feld,
        fieldvalue TYPE string,    "works for non-c-like types?
      END OF ty_gs_field .
    TYPES:
      ty_gt_field TYPE STANDARD TABLE OF ty_gs_field WITH DEFAULT KEY .
    TYPES:
* Structure for changes within one record
      BEGIN OF ty_gs_record,
        key_fields    TYPE ty_gt_field,
        mocked_fields TYPE ty_gt_field,
      END OF ty_gs_record .
    TYPES:
      ty_gt_record TYPE STANDARD TABLE OF ty_gs_record WITH DEFAULT KEY .
    TYPES:
* Structure for delta mocking, mode 'U' (table-indep. type, fields of existing record)
      BEGIN OF ty_gs_gen_delta_mock_td,
        dbtable            TYPE tabname16,
        mock_mode          TYPE ptf_mock_mode,
        changes_per_record TYPE ty_gt_record,
      END OF ty_gs_gen_delta_mock_td .
    TYPES:
          "typing tdc parameter
      ty_gt_gen_delta_mock_td TYPE STANDARD TABLE OF ty_gs_gen_delta_mock_td WITH DEFAULT KEY .
    TYPES: ty_run_head type ptf_run_head.
    TYPES:
      ty_gt_run_head TYPE SORTED TABLE OF ty_run_head WITH UNIQUE KEY run_uuid .
    TYPES:
      ty_t_varname TYPE STANDARD TABLE OF ptf_varname WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_i_ptf_generic_config, "used in CL_PTF_BO_INVOICE_MOCK
        config_name TYPE string,
        parameters  TYPE string,
      END OF ty_gs_i_ptf_generic_config .
    TYPES:
      BEGIN OF ty_true_false_td,   "seems too specific to be in this class
        trigger TYPE abap_bool,
      END OF ty_true_false_td .

    CONSTANTS gc_key_field_delimiter TYPE c VALUE '|' ##NO_TEXT.
    CONSTANTS gc_change TYPE ptf_act VALUE 'CHANGE' ##NO_TEXT.
    CONSTANTS gc_check TYPE ptf_act VALUE 'CHECK' ##NO_TEXT.
    CONSTANTS gc_create TYPE ptf_act VALUE 'CREATE' ##NO_TEXT.
    CONSTANTS gc_delete TYPE ptf_act VALUE 'DELETE' ##NO_TEXT.
    CONSTANTS gc_execute TYPE ptf_act VALUE 'EXECUTE_ACTION' ##NO_TEXT.
    CONSTANTS gc_execute_check TYPE ptf_act VALUE 'EXECUTE_CHECK' ##NO_TEXT.
    CONSTANTS gc_bo_ptfrun TYPE ptf_bo VALUE 'PTF_RUN' ##NO_TEXT.
    CONSTANTS gc_action_mock_db TYPE ptf_act VALUE 'START_DATA_MOCKING' ##NO_TEXT.
    CONSTANTS gc_action_end_mock_db TYPE ptf_act VALUE 'END_DATA_MOCKING' ##NO_TEXT.
    CONSTANTS gc_action_start_ftmock_active TYPE ptf_act VALUE 'START_MOCK_FT_IS_ACTIVE' ##NO_TEXT.
    CONSTANTS gc_action_start_ftmock_inactv TYPE ptf_act VALUE 'START_MOCK_FT_IS_INACTIVE' ##NO_TEXT.
    CONSTANTS gc_action_end_ftmock TYPE ptf_act VALUE 'END_FT_MOCKING' ##NO_TEXT.
    CONSTANTS gc_check_messages TYPE ptf_act VALUE 'CHECK_MESSAGES' ##NO_TEXT.
    CONSTANTS:
      gc_mock_mode_upd TYPE c LENGTH 1 VALUE 'U' ##NO_TEXT.                "UPD - Update of fields of existing records
    CONSTANTS:
      gc_mock_mode_ins TYPE c LENGTH 1 VALUE 'I' ##NO_TEXT.                "INS - Record insertion
    CONSTANTS:
      gc_mock_mode_del TYPE c LENGTH 1 VALUE 'D' ##NO_TEXT.                "DEL - Record deletion
    CONSTANTS:
      gc_mock_mode_all TYPE c LENGTH 1 VALUE 'F' ##NO_TEXT.                "ALL - Full replacement of table content

    METHODS constructor
      IMPORTING
        !iv_tdcv_name               TYPE ptf_tdcv OPTIONAL
        !iv_tdc                     TYPE etobj_name OPTIONAL
        !iv_bo                      TYPE ptf_bo
        !iv_action                  TYPE ptf_act
        !iv_ignore_local_substitute TYPE abap_boolean OPTIONAL
      RAISING
        cx_ecatt_tdc_access .
    CLASS-METHODS do_commitment
      IMPORTING
        !io_run_environment TYPE REF TO cl_ptf_run .
    CLASS-METHODS ensure_posnr_filled
      IMPORTING
        !iv_variant         TYPE ptf_tdcv
        !iv_run_environment TYPE REF TO cl_ptf_run
      CHANGING
        !is_data            TYPE cl_ptf_bo_dmr=>ty_gs_i_ptf_dmr_cr_td .
    CLASS-METHODS get_testdata
      IMPORTING
        !is_step_data TYPE cl_ptf_util=>gt_ptf_step
      EXPORTING
        !es_testdata  TYPE any .
    METHODS get_tdcp_name
      RETURNING
        VALUE(rv_name) TYPE string .
    METHODS get_tdc_name
      RETURNING
        VALUE(rv_name) TYPE string .
    METHODS get_testdata_value
      IMPORTING
        !iv_var_name           TYPE ptf_tdcv OPTIONAL
        !iv_bo                 TYPE ptf_bo
        !iv_act                TYPE ptf_act
      EXPORTING
        VALUE(es_tdcv_content) TYPE any
      RAISING
        cx_ecatt_tdc_access .
    CLASS-METHODS do_preperation
      CHANGING
        !is_step_data       TYPE gt_ptf_step
        !it_step_data       TYPE gt_ptf_step_tab
        !it_return          TYPE gt_ptf_return_tab
      RETURNING
        VALUE(rt_parameter) TYPE abap_parmbind_tab .
    METHODS ref_step_split
      IMPORTING
        !iv_step_to_split        TYPE char10
      RETURNING
        VALUE(rt_splitted_table) TYPE gty_reference_tab .
    CLASS-METHODS get_split
      IMPORTING
        !iv_step_to_split        TYPE char30
        !iv_table_index          TYPE i OPTIONAL
      RETURNING
        VALUE(rt_splitted_table) TYPE gty_reference_tab .
    CLASS-METHODS get_structure_type
      IMPORTING
        !is_ptf_tdcp             TYPE etp_name
      RETURNING
        VALUE(rs_structure_type) TYPE string .
    CLASS-METHODS get_name_tdc
      IMPORTING
        !iv_bo       TYPE ptf_bo
        !iv_action   TYPE ptf_act
      EXPORTING
        !ev_name_tdc TYPE etobj_name .
    CLASS-METHODS get_tdc_category
      IMPORTING
        !iv_tdc_name        TYPE etobj_name
      RETURNING
        VALUE(rv_cathegory) TYPE string .
    CLASS-METHODS set_cursor
      IMPORTING
        !is_cursor_table     TYPE gty_sel_screen
      RETURNING
        VALUE(rv_cursor_pos) TYPE char30 .
    CLASS-METHODS get_syst_field
      IMPORTING
        !iv_field_name  TYPE string
      EXPORTING
        !ev_field_value TYPE any .
*      CHANGING
*        !cs_run_head type   TYPE cl_ptf_util=>ty_run_head
    CLASS-METHODS create_run_head
      IMPORTING
        !iv_variant         TYPE ptf_varname
        !iv_timestamp_start TYPE timestampl
        !iv_is_batch        TYPE abap_bool
      EXPORTING
        !es_run_head        TYPE cl_ptf_util=>ty_run_head .
    CLASS-METHODS remove_duplicate_scripts
      IMPORTING
        !it_varname        TYPE cl_ptf_util=>ty_t_varname
      EXPORTING
        !et_varname_unique TYPE cl_ptf_util=>ty_t_varname .
    CLASS-METHODS analyze_preceding_document
      IMPORTING
        !it_resultid     TYPE cl_ptf_util=>ty_vbeln_tab
        !it_result_keys  TYPE cl_ptf_util=>ty_result_key_data_tab
      RETURNING
        VALUE(rv_result) TYPE abap_bool .
  PRIVATE SECTION.

    DATA mv_tdcv_name TYPE etvar_id .
    DATA mo_access_tdc TYPE REF TO cl_apl_ecatt_tdc_api .
    DATA mv_tdc_name TYPE etobj_name .
    DATA mv_tdcp_name TYPE etpar_name .

    CLASS-METHODS testdata_include
      IMPORTING
        !it_component TYPE abap_compdescr_tab
      CHANGING
        !cs_tdcv      TYPE any .
    CLASS-METHODS testdata_structure
      CHANGING
        !cs_tdcv TYPE any .
    CLASS-METHODS testdata_table
      CHANGING
        !ct_tdcv TYPE ANY TABLE .
ENDCLASS.



CLASS cl_ptf_util IMPLEMENTATION.


METHOD analyze_preceding_document.
ENDMETHOD.


METHOD constructor.

  DATA: lv_tdc  TYPE etobj_name,
        lv_tdcp TYPE etpar_name.

  DATA(lo_client) = NEW cl_ptf_client( ). "toDO: Dependency isolation

  "TDC
  IF iv_tdc IS INITIAL.
    "Use Default TDC of this Action
    SELECT SINGLE ptf_tdc FROM ptfboa INTO lv_tdc WHERE ptf_bo = iv_bo AND ptf_act = iv_action.
      IF sy-subrc NE 0.
        TEST-SEAM bo_message.
          CONCATENATE: 'No Test data container found in database with BO' iv_bo 'and Action' iv_action INTO DATA(lv_error_1) SEPARATED BY space.
          MESSAGE lv_error_1 TYPE 'X'.
        END-TEST-SEAM.
      ENDIF.
    ELSE.
      lv_tdc = iv_tdc.
    ENDIF.

    "TDCP
    SELECT SINGLE ptf_tdcp FROM ptfboa INTO lv_tdcp WHERE ptf_bo = iv_bo AND ptf_act = iv_action.
      IF sy-subrc NE 0.
        TEST-SEAM act_message.
          CONCATENATE: 'No Test data container parameter found in database with BO' iv_bo 'and Action' iv_action INTO DATA(lv_error_2) SEPARATED BY space.
*        MESSAGE lv_error_2 TYPE 'X'.
          RAISE EXCEPTION TYPE cx_ecatt_tdc_access EXPORTING free_text = lv_error_2.
        END-TEST-SEAM.
      ENDIF.


      cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~set_substituted_tdc_name( space ).
      IF iv_ignore_local_substitute IS INITIAL
        AND NOT lo_client->is_blocklisted_against_z_tdc( ).
** get local Z TDC if existing, it has has priority before the productive TDC
        TRY.
            mo_access_tdc = cl_apl_ecatt_tdc_api=>get_instance( 'Z' && lv_tdc ).
            "but only if the requested TDC variant exists in the Z TDC
            DATA dummy TYPE c LENGTH 1.  "mapping not possible against C1 field, but here we just want to know whether there is an exception raised, when variant is missing
            mo_access_tdc->get_value(
              EXPORTING
                i_param_name   = lv_tdcp
                i_variant_name = CONV #( iv_tdcv_name )
              CHANGING
                e_param_value = dummy
                 ).
            "use the local Z TDC
            mv_tdc_name = 'Z' && lv_tdc.
            mv_tdcp_name = lv_tdcp.
            mv_tdcv_name = iv_tdcv_name.
            cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~set_substituted_tdc_name( mv_tdc_name ).
            EXIT.
          CATCH cx_ecatt_tdc_access INTO DATA(lx).
            "no problem, as local TDC is optional
        ENDTRY.
      ENDIF.

** get transported HOME TDC
*    TRY.
      DATA lv_rfc TYPE c LENGTH 32.
      GET PARAMETER ID 'PTF_RFC_FOR_TDC' FIELD lv_rfc.
*if sy-uname EQ 'GRIESEC'.
*  lv_rfc = 'ER1CLNT001_T'.
*ENDIF.
      IF lv_rfc IS NOT INITIAL.
        mo_access_tdc = cl_apl_ecatt_tdc_api=>get_instance( EXPORTING i_testdatacontainer = lv_tdc i_tdc_rfcdest = lv_rfc ).
      ELSE.
        mo_access_tdc = cl_apl_ecatt_tdc_api=>get_instance( lv_tdc ).
      ENDIF.
      mv_tdc_name  = lv_tdc.
      mv_tdcp_name = lv_tdcp.
      mv_tdcv_name = iv_tdcv_name.
*      CATCH cx_ecatt_tdc_access INTO DATA(lx2).
*        DATA(txt) = lx2->get_text( ).
*        ASSERT FIELDS 'Error occured while accessing' lv_tdc ': ' txt CONDITION lx2 IS NOT BOUND.
*    ENDTRY.

    ENDMETHOD.


    METHOD create_run_head.

*  "Define new run header in ABAP memory     "toDO: move to other class?

      DATA ls_run_head TYPE cl_ptf_util=>ty_run_head.

      TRY.
          ls_run_head-run_uuid = NEW cl_system_uuid( )->if_system_uuid~create_uuid_c26( ).
        CATCH cx_uuid_error.
          ls_run_head-run_uuid = 'NO_UUID'.
      ENDTRY.
      IF iv_variant IS NOT INITIAL.
        ls_run_head-variant = iv_variant.
      ELSE.
        ls_run_head-variant = '-PTF variant unknown-'.
      ENDIF.
      ls_run_head-start_timestamp = cl_abap_tstmp=>move_to_short( iv_timestamp_start ).
      ls_run_head-start_date      = sy-datum.
      ls_run_head-start_time      = sy-uzeit.
      ls_run_head-user            = sy-uname.
      ls_run_head-is_batch        = iv_is_batch.

      es_run_head = ls_run_head.

      "I Do the insertion here - should my caller do this?      ES_RUN_HEAD is needed at least to return the uuid

      DATA(lo_mem) = NEW cl_ptf_abap_memory( ).
      lo_mem->insert_run_head( ls_run_head ).

    ENDMETHOD.


    METHOD do_commitment.
      DATA ls_return TYPE bapiret2.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait   = abap_true  " Use of Command `COMMIT AND WAIT`
        IMPORTING
          return = ls_return.
      IF ls_return IS NOT INITIAL.
        io_run_environment->append_log( iv_log_statement =  |{ ls_return-message }| ).
      ENDIF.
    ENDMETHOD.


    METHOD do_preperation.
      DATA: lt_parameter TYPE   abap_parmbind_tab,
            ls_parameter TYPE   abap_parmbind.

      ls_parameter-kind = cl_abap_objectdescr=>changing.
      ls_parameter-name =  'CS_STEP_DATA'.
      GET REFERENCE OF is_step_data INTO ls_parameter-value.
      INSERT ls_parameter INTO TABLE lt_parameter.

      ls_parameter-kind = cl_abap_objectdescr=>changing.
      ls_parameter-name =  'CT_STEP_DATA'.
      GET REFERENCE OF it_step_data INTO ls_parameter-value.
      INSERT ls_parameter INTO TABLE lt_parameter.

      ls_parameter-kind = cl_abap_objectdescr=>importing.
      ls_parameter-name =  'ET_RETURN'.
      GET REFERENCE OF it_return INTO ls_parameter-value.
      INSERT ls_parameter INTO TABLE lt_parameter.

      rt_parameter = lt_parameter.
      CLEAR: lt_parameter, ls_parameter.


    ENDMETHOD.


    METHOD ensure_posnr_filled.
      DATA: error_message TYPE bapi_msg,
            ls_return     TYPE bapiret2.

      DATA: lv_init_posnr TYPE i.
      LOOP AT is_data-item_list ASSIGNING FIELD-SYMBOL(<ls_item_list>).
        IF <ls_item_list>-posnr IS INITIAL.
          ADD 1 TO lv_init_posnr.
        ENDIF.
      ENDLOOP.

      IF lv_init_posnr = 0.
        "if Postionnumber is filled for every Item, check for Duplicates
        SORT is_data-item_list  BY posnr.
        DELETE ADJACENT DUPLICATES FROM is_data-item_list  COMPARING posnr.
        IF sy-subrc = 0.
          iv_run_environment->append_log( iv_log_statement =  |Duplicates in column PostionNumber are not allowed! The variant is: { iv_variant } | ).
        ENDIF.
      ELSEIF lv_init_posnr = lines( is_data-item_list ).
        "if Postionnumber is never filled, determine Postionnumber for every Item
        LOOP AT is_data-item_list  ASSIGNING  <ls_item_list>.
          <ls_item_list>-posnr = sy-tabix * 10.
        ENDLOOP.
      ELSEIF lv_init_posnr < lines( is_data-item_list ).
        iv_run_environment->append_log( iv_log_statement = |You have to fill every or no field in column PositionNumber! Variant is: { iv_variant }| ).
      ELSE.
        iv_run_environment->append_log( iv_log_statement = |Error in the input data. The variant is: { iv_variant }| ).
      ENDIF.
    ENDMETHOD.


    METHOD get_name_tdc.
      CLEAR ev_name_tdc.
      SELECT SINGLE ptf_tdc FROM ptfboa INTO ev_name_tdc WHERE ptf_act = iv_action  AND ptf_bo = iv_bo.
        IF sy-subrc NE 0.
          DATA(lv_is_rap_bo) = NEW cl_ptf_rap_metadata( )->check_rap_bo( iv_bo ). "not checking th RAP action existence here...
          CHECK lv_is_rap_bo IS INITIAL.
          MESSAGE ID 'PTF' TYPE 'S' NUMBER 008.
        ENDIF.
      ENDMETHOD.


      METHOD get_split.
        DATA lt_ref_step_tab TYPE STANDARD TABLE OF gty_char_table.
        DATA lv_string_old TYPE c LENGTH 10 VALUE '1'.
        DATA(lv_count) = iv_table_index - 1.

        SPLIT iv_step_to_split AT ';' INTO TABLE lt_ref_step_tab.
        DO lv_count TIMES.
          CONCATENATE   lv_result lv_string_old
                      INTO DATA(lv_result) SEPARATED BY space.
          ADD 1 TO lv_string_old.
        ENDDO.

        LOOP AT lt_ref_step_tab ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
          IF lv_result NS <ls_ref_step>-col.
            rt_splitted_table = VALUE #( ( 0 ) ).
            RETURN.
          ENDIF.
        ENDLOOP.

        DELETE ADJACENT DUPLICATES FROM lt_ref_step_tab.
        rt_splitted_table = lt_ref_step_tab.

      ENDMETHOD.


      METHOD get_structure_type.
*    CASE is_ptf_tdcp.
*      WHEN 'I_PTF_DL'.
*        rs_structure_type = 'cl_ptf_util=>ty_gs_ptf_dl_check_td'.
*      WHEN 'I_PTF_OL'.
*        rs_structure_type = 'cl_ptf_util=>ty_gs_ptf_sd_check_td'.
*      WHEN 'I_PTF_BD'.
*        rs_structure_type = 'cl_ptf_util=>ty_gs_ptf_bd_check_td'.
*    ENDCASE.
      ENDMETHOD.


      METHOD get_syst_field.

* If the field value is a placeholder (CDAT*, IDAT*, or SY-fieldname), it is replaced with the respective value (Addition and subtraction of integers is also supported for dates).
* If not, an initial value (actually, if EV_FIELD_VALUE is called with an filled field as actual parameter, the UNCHANGED value) is returned. all consumers of this method have EV_FIELD_VALUE filled before the call.

* Note that if the TDC field is typed as DATE field, then e.g. 'sy-datum' becomes 'sydatum' at runtime already when the value is read from the TDC


        DATA lv_field TYPE string.
        DATA lv_key_word_sy TYPE abap_bool.
        DATA lv_key_word_dat TYPE abap_bool.
        DATA lv_inverted_format TYPE abap_bool.
        DATA lv_split_ok TYPE abap_bool.

        CHECK iv_field_name NE 'SYSTEM'.

        lv_field = iv_field_name.
        TRANSLATE lv_field TO UPPER CASE.

        lv_split_ok = abap_false.

        IF lv_field CS 'CDATM' OR lv_field CS 'CDATP'.
          lv_key_word_dat = abap_true.
        ELSEIF lv_field CS 'IDATM' OR lv_field CS 'IDATP'.
          lv_key_word_dat = abap_true.
          lv_inverted_format = abap_true.
        ELSEIF lv_field CS 'SY'.
          IF lv_field(2) EQ 'SY'.
            lv_key_word_sy = abap_true.
          ENDIF.
        ENDIF.

        CHECK lv_key_word_dat EQ abap_true OR lv_key_word_sy EQ abap_true.

        "Fill lv_fieldname
        IF lv_key_word_dat EQ abap_true.
          "xDATx: Transform code into SY-DATLO and operator (if found) into +/-
          DATA lv_operator(1) TYPE c.
          SPLIT lv_field AT 'T' INTO DATA(lv_prefix) DATA(lv_content).
          lv_prefix = 'SY-DATLO'.
          IF lv_content CS 'M'.
            SPLIT lv_content AT 'M' INTO DATA(lv_opr) DATA(lv_number).
            lv_operator = '-'.
          ELSEIF lv_content CS 'P'.
            lv_operator = '+'.
            SPLIT lv_content AT 'P' INTO lv_opr lv_number.
          ENDIF.
          CONCATENATE lv_prefix lv_operator lv_number INTO DATA(lv_fieldname) SEPARATED BY space.
          lv_split_ok = abap_true.
        ELSEIF lv_field(2) EQ 'SY'.
          "SY*: Rename SY to SY-
          SPLIT lv_field AT 'Y' INTO lv_prefix lv_content.
          CONCATENATE 'SY-' lv_content INTO lv_fieldname.
          lv_split_ok = abap_true.
        ENDIF.

        ASSERT lv_split_ok EQ abap_true. "ToDo: remove lv_split_ok as it is never abap_false

        "Identify SYST field and take over it's value
        DATA lv_variable(20) TYPE c.
        SPLIT lv_fieldname AT space INTO TABLE DATA(lt_splitted_fields).
        lv_variable = lt_splitted_fields[ 1 ].
        TRY.
            DATA(components) = CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_name( 'SYST' ) )->components.
            IF NOT line_exists( components[ name = replace( val = lv_variable
                                            sub  = `SY-`
                                            with = `` ) ] ).
              MESSAGE 'Invalid field name' TYPE 'S' DISPLAY LIKE 'E'.
              RETURN.
            ENDIF.
            ASSIGN (lv_variable) TO FIELD-SYMBOL(<syfield>).
            ev_field_value = <syfield>.

          CATCH  cx_sy_conversion_overflow cx_sy_conversion_no_number.
        ENDTRY.

        "Add/subtract
        DATA lv_result_date TYPE dats.
        CHECK lines( lt_splitted_fields ) > 1
         AND ( lt_splitted_fields[ 1 ] = 'SY-DATLO' OR lt_splitted_fields[ 1 ] = 'SY-DATUM' ).
        CHECK lt_splitted_fields[ 3 ] CO ' 0123456789'.
        CASE lt_splitted_fields[ 2 ].
          WHEN '+' .
            lv_result_date = <syfield> + lt_splitted_fields[ 3 ] .
          WHEN '-'.
            lv_result_date = <syfield> - lt_splitted_fields[ 3 ] .
          WHEN OTHERS.
            MESSAGE 'Invalid values given' TYPE 'S' DISPLAY LIKE 'E'.
        ENDCASE.
        ev_field_value = lv_result_date.

        IF lv_inverted_format EQ abap_true.
          "Convert date to inverted date format
          DATA lv_date_char15 TYPE char15.
          DATA lv_date_inverted TYPE gdatu_inv.
          WRITE lv_result_date TO lv_date_char15.
          CALL FUNCTION 'CONVERSION_EXIT_INVDT_INPUT'
            EXPORTING
              input  = lv_date_char15
            IMPORTING
              output = lv_date_inverted.
          ev_field_value = lv_date_inverted.
        ENDIF.

      ENDMETHOD.


      METHOD get_tdcp_name.
        rv_name = mv_tdcp_name.
      ENDMETHOD.


      METHOD get_tdc_category.
        SPLIT iv_tdc_name AT '_' INTO: DATA(lv_begin) DATA(lv_middle) DATA(lv_end).
        rv_cathegory = lv_end.
      ENDMETHOD.


      METHOD get_tdc_name.
        rv_name = mv_tdc_name.
      ENDMETHOD.


      METHOD get_testdata.

        DATA: lo_cl_ptf_util TYPE REF TO cl_ptf_util,
              lv_input       TYPE string.


        IF is_step_data-variant IS INITIAL.
          RETURN.
        ENDIF.

        TRY.
            CREATE OBJECT lo_cl_ptf_util
              EXPORTING
                iv_tdc       = is_step_data-test_data_container
                iv_tdcv_name = is_step_data-variant
                iv_bo        = is_step_data-bus_obj
                iv_action    = is_step_data-action.
          CATCH cx_ecatt_tdc_access INTO DATA(lx).
            DATA(txt) = lx->get_text( ).
            cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~set_tdc_error( abap_true ).
            RETURN.
        ENDTRY.

        TRY.
            lo_cl_ptf_util->get_testdata_value(
              EXPORTING
*            iv_var_name     =  is_step_data-variant  "parameter is ignored, only mv_tdcv_name is used
                iv_bo           =  is_step_data-bus_obj
                iv_act          =  is_step_data-action
              IMPORTING
                es_tdcv_content = es_testdata ).
          CATCH cx_ecatt_tdc_access INTO DATA(lx_getvalue).
            cl_ptf_step_attr=>get_instance( )->if_ptf_step_attr~set_tdc_error( abap_true ).
            RETURN.
        ENDTRY.

        DATA(lo_type_desc) = cl_abap_typedescr=>describe_by_data( es_testdata ).
        IF ( lo_type_desc->kind = cl_abap_typedescr=>kind_struct ).
          testdata_structure(
            CHANGING
              cs_tdcv = es_testdata ).
        ELSEIF ( lo_type_desc->kind = cl_abap_typedescr=>kind_table ).
          testdata_table(
              CHANGING
                ct_tdcv = es_testdata ).
        ELSE.
          lv_input = ( es_testdata  ).

          "special logic, date field
          cl_ptf_util=>get_syst_field(
            EXPORTING
              iv_field_name  = lv_input
            IMPORTING
              ev_field_value = es_testdata  ).

        ENDIF.

      ENDMETHOD.


      METHOD get_testdata_value.
        "IV_VAR_NAME IS IGNORED !
        "mv_tdcp_name is not read, but newly determined.    consider to just use mv_tdcp_name (filled in constructor) and remove all paramaters from the signature

*    TRY.
        SELECT SINGLE ptf_tdcp FROM ptfboa INTO me->mv_tdcp_name WHERE ptf_act = iv_act  AND ptf_bo = iv_bo.

          mo_access_tdc->get_value(
            EXPORTING
              i_param_name = me->mv_tdcp_name
              i_variant_name = me->mv_tdcv_name
            CHANGING
              e_param_value = es_tdcv_content ).
*      CATCH cx_ecatt_tdc_access.
*        MESSAGE ID 'PTF' TYPE 'S' NUMBER 009 DISPLAY LIKE 'E'.
*    ENDTRY.
        ENDMETHOD.


        METHOD ref_step_split. " obsolet
          DATA lt_ref_step_tab TYPE STANDARD TABLE OF gty_char_table.
          DATA(lv_string) = '0 1 2 3 4 5 6 7 8 9 30'.
          SPLIT iv_step_to_split AT ';' INTO TABLE lt_ref_step_tab.
          LOOP AT lt_ref_step_tab ASSIGNING FIELD-SYMBOL(<ls_ref_step>).
            IF lv_string NS <ls_ref_step>-col.
              RETURN.
            ENDIF.
          ENDLOOP.
          rt_splitted_table = lt_ref_step_tab.
        ENDMETHOD.


        METHOD remove_duplicate_scripts.

          "remove duplicates while keeping the order. remove also all empty records.

          DATA lt_varname TYPE STANDARD TABLE OF ptf_varname WITH EMPTY KEY WITH UNIQUE HASHED KEY k2_unique COMPONENTS table_line.

          LOOP AT it_varname INTO DATA(lv_varname).
            READ TABLE lt_varname
              TRANSPORTING NO FIELDS
              WITH TABLE KEY k2_unique COMPONENTS table_line = lv_varname.
            CHECK sy-subrc IS NOT INITIAL.
            CHECK lv_varname IS NOT INITIAL.  "do not keep empty lines
            APPEND lv_varname TO lt_varname.
          ENDLOOP.

          et_varname_unique = lt_varname.

        ENDMETHOD.


        METHOD set_cursor.

          ASSERT 1 = 1.

          IF is_cursor_table IS NOT INITIAL.
            IF is_cursor_table-ptf_bo IS NOT INITIAL.
              CONCATENATE 'P_BO' is_cursor_table-ptf_var_step INTO DATA(lv_cursor_pos).
            ELSEIF
              is_cursor_table-ptf_act IS NOT INITIAL.
              CONCATENATE 'P_ACT' is_cursor_table-ptf_var_step INTO lv_cursor_pos.
            ELSEIF
               is_cursor_table-ptf_tdcv IS NOT INITIAL.
              CONCATENATE 'P_TEST' is_cursor_table-ptf_var_step INTO lv_cursor_pos.
            ELSEIF
            is_cursor_table-ptf_ref_step IS NOT INITIAL.
              IF is_cursor_table-ptf_var_step = 10.
                CONCATENATE 'P_V_BO' is_cursor_table-ptf_var_step INTO lv_cursor_pos.
              ELSE.
                CONCATENATE 'P_VO_BO' is_cursor_table-ptf_var_step INTO lv_cursor_pos.
              ENDIF.
            ENDIF.
            rv_cursor_pos = lv_cursor_pos.
          ENDIF.

        ENDMETHOD.


        METHOD testdata_include.
          DATA:
            lv_tdcv_typekind TYPE abap_typekind,
            lv_value_string  TYPE string,
            ls_component     TYPE LINE OF abap_compdescr_tab.

          FIELD-SYMBOLS: <lu_tdcv> TYPE any.

          LOOP AT it_component INTO ls_component.
            ASSIGN COMPONENT: ls_component-name OF STRUCTURE cs_tdcv TO <lu_tdcv>.
            IF <lu_tdcv> IS ASSIGNED.
              CASE ls_component-type_kind.
                WHEN 'u' OR 'v'. "Structure or deep structure
                  testdata_structure(
                    CHANGING
                      cs_tdcv = <lu_tdcv> ).
                WHEN 'h'. "table
                  testdata_table(
                    CHANGING
                      ct_tdcv  = <lu_tdcv> ).
                WHEN 'l' OR 'j' OR 'r'. "References are not allowed
                  cl_aunit_assert=>fail( msg = 'Exception has been raised. Component type is a reference.' ).
                WHEN OTHERS. "Rest are Parameter
                  TRY.
                      lv_value_string = ( <lu_tdcv> ).
                    CATCH cx_root.
                  ENDTRY.
                  cl_ptf_util=>get_syst_field(
                    EXPORTING
                      iv_field_name  = lv_value_string
                    IMPORTING
                      ev_field_value = <lu_tdcv>  ).
              ENDCASE.
            ELSE.
              cl_aunit_assert=>fail( msg = 'Exception has been raised. Unpossible to loop at structure include.' ).
            ENDIF.
          ENDLOOP.

        ENDMETHOD.


        METHOD testdata_structure.
          DATA: lt_component     TYPE cl_abap_structdescr=>component_table,
                ls_component     TYPE cl_abap_structdescr=>component,
                lv_tdcv_typekind TYPE abap_typekind,
                lo_strucdesc     TYPE REF TO cl_abap_structdescr,
                lv_value_string  TYPE string.

          FIELD-SYMBOLS: <lt_component> TYPE abap_compdescr_tab,
                         <lu_tdcv>      TYPE any.

          lo_strucdesc ?= cl_abap_structdescr=>describe_by_data( cs_tdcv ).
          lt_component  = lo_strucdesc->get_components( ).

          LOOP AT lt_component INTO ls_component.
            ASSIGN COMPONENT: ls_component-name OF STRUCTURE cs_tdcv TO <lu_tdcv>.
            IF <lu_tdcv> IS ASSIGNED.
              lv_tdcv_typekind = ls_component-type->get_data_type_kind( p_data = <lu_tdcv> ).
              CASE lv_tdcv_typekind.
                WHEN 'u' OR 'v'. "Structure or deep structure
                  testdata_structure(
                    CHANGING
                      cs_tdcv = <lu_tdcv> ).
                WHEN 'h'. "table
                  testdata_table(
                    CHANGING
                      ct_tdcv  = <lu_tdcv> ).
                WHEN 'l' OR 'j' OR 'r'. "References are not allowed
                  cl_aunit_assert=>fail( msg = 'Exception has been raised. Component type is a reference.' ).
                WHEN OTHERS. "Rest are Parameter
                  TRY.
                      lv_value_string = ( <lu_tdcv> ).
                    CATCH cx_root.
                  ENDTRY.
                  cl_ptf_util=>get_syst_field(
                    EXPORTING
                      iv_field_name  = lv_value_string
                    IMPORTING
                      ev_field_value = <lu_tdcv>  ).
              ENDCASE.
            ELSE.
              ASSIGN ls_component-type->('COMPONENTS') TO <lt_component>.
              testdata_include(
                EXPORTING
                  it_component =  <lt_component>
                CHANGING
                  cs_tdcv      = cs_tdcv ).
            ENDIF.
          ENDLOOP.

        ENDMETHOD.


        METHOD testdata_table.
          DATA: lv_input TYPE string.
          LOOP AT ct_tdcv ASSIGNING FIELD-SYMBOL(<ls_tdcv>).
            DATA(lo_type_desc) = cl_abap_typedescr=>describe_by_data( <ls_tdcv> ).
            IF ( lo_type_desc->kind = cl_abap_typedescr=>kind_struct ).
              testdata_structure(
                CHANGING
                  cs_tdcv  = <ls_tdcv> ).
            ELSE.
              lv_input = ( <ls_tdcv>  ).
              cl_ptf_util=>get_syst_field(
                EXPORTING
                  iv_field_name  = lv_input
                IMPORTING
                  ev_field_value = <ls_tdcv>  ).
            ENDIF.
          ENDLOOP.
        ENDMETHOD.
ENDCLASS.
