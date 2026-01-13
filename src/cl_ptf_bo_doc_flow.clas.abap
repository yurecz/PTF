class CL_PTF_BO_DOC_FLOW definition
  public
  inheriting from CL_PTF_BO
  final
  create public .

public section.

  types:
    BEGIN OF ty_gs_check_doc_flow,
        expected_depth TYPE i,
      END OF ty_gs_check_doc_flow .
  types:
    vbeln_tab TYPE STANDARD TABLE OF vbeln WITH DEFAULT KEY .
  types:
    BEGIN OF ty_gs_depth_elements_mapping,
        depth     TYPE i,
        documents TYPE cl_ptf_bo_doc_flow=>vbeln_tab,
      END OF ty_gs_depth_elements_mapping .
  types:
    depth_doc_mapping TYPE STANDARD TABLE OF ty_gs_depth_elements_mapping WITH DEFAULT KEY WITH UNIQUE SORTED KEY key COMPONENTS depth .
  types:
    BEGIN OF ty_gs_range_vbtyp_n,
        sign   TYPE c LENGTH 1,
        option TYPE c LENGTH 2,
        low    TYPE vbtyp_n,
        high   TYPE vbtyp_n,
      END OF ty_gs_range_vbtyp_n .
  types:
    BEGIN OF ty_gs_range_vbtyp_v,
        sign   TYPE c LENGTH 1,
        option TYPE c LENGTH 2,
        low    TYPE vbtyp_v,
        high   TYPE vbtyp_v,
      END OF ty_gs_range_vbtyp_v .
  types:
    BEGIN OF ty_gs_range_stufe,
        sign   TYPE c LENGTH 1,
        option TYPE c LENGTH 2,
        low    TYPE stufe_vbfa,
        high   TYPE stufe_vbfa,
      END OF ty_gs_range_stufe .
  types:
    ty_gt_vbtyp_n    TYPE STANDARD TABLE OF ty_gs_range_vbtyp_n WITH DEFAULT KEY .
  types:
    ty_gt_vbtyp_v    TYPE STANDARD TABLE OF ty_gs_range_vbtyp_v WITH DEFAULT KEY .
  types:
    ty_gt_stufe      TYPE STANDARD TABLE OF ty_gs_range_stufe WITH DEFAULT KEY .
  types:
** Types for TDC parameters
    BEGIN OF ty_gs_vbfa_docs_td,
        vbtyp_n_range       TYPE ty_gt_vbtyp_n,  "range table
*        vbtyp_n             TYPE vbtypl_n,  "CHAR 4,  Document Category of Subsequent Document
        vbtyp_v_range       TYPE ty_gt_vbtyp_v,  "range table
*        vbtyp_v             TYPE vbtypl_v,  "CHAR 4,  Document Category of Preceding SD Document
        stufe_range         TYPE ty_gt_stufe,  "range table
*        stufe               TYPE stufe_vbfa,  "NUMC 2,  Level of the document flow record
        expected_no_of_docs TYPE string,   "initial if not to be validated. number if it shall be validated
      END OF ty_gs_vbfa_docs_td .
  types:
    ty_gt_vbfa_docs_td      TYPE STANDARD TABLE OF ty_gs_vbfa_docs_td WITH DEFAULT KEY .

  methods CHECK_CONSISTENCY
    importing
      !CHECK_TABLE type DEPTH_DOC_MAPPING
    exporting
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_SUCCESSORS_VBFA
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods PASS_ID
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !IV_STEP_NUMBER type I
    exporting
      !EV_DOCUMENT_ID type CL_PTF_UTIL=>TY_VBELN_TAB
      !EV_EXECUTION_STATUS type ABAP_BOOL
      !EV_CHECK_STATUS type ABAP_BOOL .
  methods CHECK_THAT_NO_RESULTID
    importing
      !STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
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
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS CL_PTF_BO_DOC_FLOW IMPLEMENTATION.


  METHOD change.

  ENDMETHOD.


  METHOD check.
    DATA: doc_ids              TYPE TABLE OF vbeln,
          check_table          TYPE depth_doc_mapping,
          first_level          TYPE ty_gs_depth_elements_mapping,
          second_level         TYPE ty_gs_depth_elements_mapping,
          nth_level            TYPE ty_gs_depth_elements_mapping,
          dont_stop            TYPE abap_bool,
          current_depth        TYPE i,
          current_mapping      TYPE ty_gs_depth_elements_mapping,
          current_check_status TYPE abap_bool.

    DATA(step) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    LOOP AT step-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(ref_doc_ids) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      LOOP AT ref_doc_ids ASSIGNING FIELD-SYMBOL(<ref_doc_id>).
        APPEND <ref_doc_id> TO doc_ids.
      ENDLOOP.
    ENDLOOP.

    IF doc_ids IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No referenced doc ids found| ).
      ev_execution_status = abap_false.
      ev_check_status = abap_false.
      RETURN.
    ENDIF.

    ev_execution_status = abap_false.
    ev_check_status = abap_true.
    LOOP AT doc_ids ASSIGNING FIELD-SYMBOL(<doc>).
      CLEAR check_table.
      CLEAR first_level.
      CLEAR second_level.
      CLEAR nth_level.

      first_level-depth = 1.
      APPEND  <doc> TO first_level-documents.
      APPEND first_level TO check_table.

      second_level-depth = 2.
      SELECT vbeln FROM vbfa WHERE vbelv = @<doc> ORDER BY vbeln INTO TABLE @second_level-documents.
      DELETE ADJACENT DUPLICATES FROM second_level-documents.


      APPEND second_level TO check_table.


      dont_stop = abap_true.
      current_depth = 3.
      WHILE dont_stop EQ abap_true.
        CLEAR nth_level.
        nth_level-depth = current_depth.
        READ TABLE check_table INTO current_mapping WITH KEY depth = ( current_depth - 1 ).

        IF current_mapping IS INITIAL.
          me->mo_run_environment->append_log( iv_log_statement = |Current mapping for depth { ( current_depth - 1 ) } is initial.| ).
          ev_execution_status = abap_false.
          ev_check_status = abap_false.
          RETURN.
        ENDIF.
        LOOP AT current_mapping-documents ASSIGNING FIELD-SYMBOL(<vbeln>).
          SELECT vbeln FROM vbfa WHERE vbelv = @<vbeln> ORDER BY vbeln APPENDING TABLE @nth_level-documents.
        ENDLOOP.
        SORT nth_level-documents BY table_line.
        DELETE ADJACENT DUPLICATES FROM nth_level-documents.

        IF nth_level-documents IS INITIAL.
          dont_stop = abap_false.
        ELSE.
          APPEND nth_level TO check_table.
        ENDIF.

        current_depth = current_depth + 1.
      ENDWHILE.

      me->check_consistency(
        EXPORTING
          check_table     = check_table
        IMPORTING
          ev_check_status = current_check_status
      ).

      IF current_check_status = abap_false.
        ev_check_status = abap_false.
        me->mo_run_environment->append_log( iv_log_statement = |Doc flow of { <doc> } is not consistent.| ).
      ENDIF.

    ENDLOOP.

    ev_execution_status = abap_true.

  ENDMETHOD.


  METHOD check_consistency.
    "Check consistency for Em with m >= 3
    "There must be an entry in vbfa for vbeln = En vbelv = Em n = {1 .. m-2 } M = {3...max depth}
    DATA: current_depth_m TYPE i,
          current_depth_n TYPE i,
          mapping_m       TYPE ty_gs_depth_elements_mapping,
          mapping_n       TYPE ty_gs_depth_elements_mapping.

    ev_check_status = abap_true.

    LOOP AT check_table ASSIGNING FIELD-SYMBOL(<check_table_entry_m>).
      IF <check_table_entry_m>-depth - 2 < 1.
        "In this case we have no preceding documents to check.
      ELSE.
        current_depth_m = <check_table_entry_m>-depth.
        current_depth_n = current_depth_m - 2.
        READ TABLE check_table INTO mapping_n WITH KEY depth = current_depth_n.
        READ TABLE check_table INTO mapping_m WITH KEY depth = current_depth_m.

        LOOP AT mapping_m-documents ASSIGNING FIELD-SYMBOL(<doc_m>).
          LOOP AT mapping_n-documents ASSIGNING FIELD-SYMBOL(<doc_n>).
            IF <doc_m> NE <doc_n>.
              SELECT SINGLE * FROM vbfa WHERE vbelv = @<doc_n> AND vbeln = @<doc_m> INTO @DATA(vbfa_entry).
              IF vbfa_entry IS INITIAL.
                ev_check_status = abap_false.
                me->mo_run_environment->append_log( iv_log_statement = |No Docflow between documents { <doc_n> } and { <doc_m> }| ).
              ELSE.
                me->mo_run_environment->append_log( iv_log_statement = |Docflow between documents { <doc_n> } and { <doc_m> } exists correctly.| ).
              ENDIF.
            ENDIF.
          ENDLOOP.
        ENDLOOP.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD check_existence.
  ENDMETHOD.


  METHOD check_successors_vbfa.

* All document IDs from all reference steps of this Check Step are used together here
* Each line from the TDCV is one 'VBFA check', resulting in one SELECT to VBFA, considering all the document IDs, with 0..* VBTYP_N RANGE lines, 0..* VBTYP_V RANGE lines, 0..* STUFE RANGE lines and possibly (0..1) one number of expected documents
* If at least one line from the TDCV defines an expected number that is not matched by the SELECT result for this line, the whole Check Step fails.
* All succeeding documents are returned in itab EV_DOCUMENT_ID, this is not affected by expected_no_of_docs .
* If called without TDCV, all succeeding documents are returned.

    DATA lt_testdata TYPE ty_gt_vbfa_docs_td.
    DATA ls_testdata TYPE ty_gs_vbfa_docs_td.

    DATA ls_vbtyp_range TYPE ty_gs_range_vbtyp_v.
    DATA ls_stufe_range TYPE ty_gs_range_stufe.

    DATA lt_vbfa TYPE STANDARD TABLE OF vbfa.
    TYPES: BEGIN OF ty_pair,
             vbelv TYPE vbeln_von,
             vbeln TYPE vbeln,
           END OF ty_pair.
    DATA lt_pairs TYPE STANDARD TABLE OF ty_pair.

    DATA lt_sub_result TYPE cl_ptf_util=>ty_vbeln_tab.
    DATA lt_result TYPE cl_ptf_util=>ty_vbeln_tab.


    ev_execution_status = abap_false.
    ev_check_status = abap_false.

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    "Get preceding documents
    DATA(lt_prec_docs) = me->mo_run_environment->get_result_key_data( it_step_number = ls_step_data-reference_step ).
    IF lt_prec_docs IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No reference document exists!| ).
      RETURN.
    ENDIF.
    IF lt_prec_docs[ 1 ]-document_id_char70 IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Unexpected input!| ).
    ENDIF.

    "TDC access
    IF ls_step_data-variant IS NOT INITIAL.
      cl_ptf_util=>get_testdata(
        EXPORTING
          is_step_data = ls_step_data
        IMPORTING
          es_testdata  = lt_testdata
      ).
    ELSE.
      INSERT INITIAL LINE INTO TABLE lt_testdata.    "Action can also be used without TDCV
    ENDIF.

    ev_execution_status = abap_true.
    ev_check_status = abap_true.


    LOOP AT lt_testdata INTO ls_testdata.

      CLEAR: lt_vbfa, lt_pairs, lt_sub_result.

      "Delete empty range lines that would cause a SQL dump
      LOOP AT ls_testdata-vbtyp_n_range INTO ls_vbtyp_range.
        IF ls_vbtyp_range IS INITIAL.
          DELETE ls_testdata-vbtyp_n_range INDEX sy-tabix.
        ENDIF.
      ENDLOOP.
      LOOP AT ls_testdata-vbtyp_v_range INTO ls_vbtyp_range.
        IF ls_vbtyp_range IS INITIAL.
          DELETE ls_testdata-vbtyp_v_range INDEX sy-tabix.
        ENDIF.
      ENDLOOP.
      LOOP AT ls_testdata-stufe_range INTO ls_stufe_range.
        IF ls_stufe_range IS INITIAL.
          DELETE ls_testdata-stufe_range INDEX sy-tabix.
        ENDIF.
      ENDLOOP.

      LOOP AT ls_testdata-vbtyp_n_range INTO ls_vbtyp_range.
        AT FIRST.
          me->mo_run_environment->append_log( iv_log_statement = |Filter for VBTYP_N:| ).
        ENDAT.
        me->mo_run_environment->append_log( iv_log_statement = CONV #( ls_vbtyp_range ) ).
      ENDLOOP.
      LOOP AT ls_testdata-vbtyp_v_range INTO ls_vbtyp_range.
        AT FIRST.
          me->mo_run_environment->append_log( iv_log_statement = |Filter for VBTYP_V:| ).
        ENDAT.
        me->mo_run_environment->append_log( iv_log_statement = CONV #( ls_vbtyp_range ) ).
      ENDLOOP.
      LOOP AT ls_testdata-stufe_range INTO ls_stufe_range.
        AT FIRST.
          me->mo_run_environment->append_log( iv_log_statement = |Filter for STUFE:| ).
        ENDAT.
        me->mo_run_environment->append_log( iv_log_statement = CONV #( ls_stufe_range ) ).
      ENDLOOP.


      SELECT * FROM vbfa
        INTO TABLE @lt_vbfa
        FOR ALL ENTRIES IN @lt_prec_docs
        WHERE
        vbelv = @lt_prec_docs-document_id_char70(10) AND
        vbtyp_n IN @ls_testdata-vbtyp_n_range AND
        vbtyp_v IN @ls_testdata-vbtyp_v_range AND
        stufe   IN @ls_testdata-stufe_range.

*      ORDER BY vbeln.
      SORT lt_vbfa BY vbeln.


      MOVE-CORRESPONDING lt_vbfa TO lt_pairs.
      DELETE ADJACENT DUPLICATES FROM lt_pairs COMPARING vbeln.

      IF ls_testdata-expected_no_of_docs IS INITIAL.  "if string field is empty (also no 0 in it), then we do not validate the number of documents for this TDCV line
        me->mo_run_environment->append_log( iv_log_statement = |{ lines( lt_pairs ) } docs found. Expectation was not defined.| ).
      ELSE.

        IF ls_testdata-expected_no_of_docs NE lines( lt_pairs ).
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |Fail. { lines( lt_pairs ) } docs found, expected were: { ls_testdata-expected_no_of_docs }| ).
        ELSE.
          me->mo_run_environment->append_log( iv_log_statement = |{ lines( lt_pairs ) } docs found, as expected.| ).
        ENDIF.

      ENDIF.

      MOVE-CORRESPONDING lt_pairs TO lt_sub_result.
      APPEND LINES OF lt_sub_result TO lt_result.

    ENDLOOP. "lt_testdata

    IF ev_check_status EQ abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |Check failed.| ).
    ENDIF.

    SORT lt_result.
    DELETE ADJACENT DUPLICATES FROM lt_result.
    ev_document_id = lt_result.

  ENDMETHOD.


  METHOD check_that_no_resultid.

* Check that a reference Step returned zero resultIDs
* Workaround for Krishnanunni

    ev_execution_status = abap_true.
    ev_check_status = abap_false.

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    "Get preceding documents
*    DATA(lt_prec_docs) = me->mo_run_environment->get_result_key_data( it_step_number = ls_step_data-reference_step ).
*    IF lt_prec_docs IS INITIAL.
*      me->mo_run_environment->append_log( iv_log_statement = |No reference document exists!| ).
*      RETURN.
*    ENDIF.
    DATA lt_prec_docs TYPE cl_ptf_util=>ty_vbeln_tab.
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_prec_docs.
    ENDLOOP.

    IF lt_prec_docs IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Check ok, there are no documents at the referenced steps!| ).
      ev_check_status = abap_true.
    ELSE.

      IF lt_prec_docs[ 1 ]-vbeln IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |Unexpected input!| ).
        RETURN.
      ENDIF.

      me->mo_run_environment->append_log( iv_log_statement = |Unexpected reference documents exist!| ).
      RETURN.

    ENDIF.

  ENDMETHOD.


  METHOD create.
  ENDMETHOD.


  METHOD delete.

  ENDMETHOD.


  METHOD execute_action.

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    CASE ls_step_data-action.
      WHEN 'PASS_ID__DO_NOT_USE'.
        me->pass_id(
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
        me->mo_run_environment->append_log( iv_log_statement =  |Could not find method { ls_step_data-action } for the BO { ls_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.
    ENDCASE.

  ENDMETHOD.


  METHOD execute_check.

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    CASE ls_step_data-action.
      WHEN 'CHECK_SUCCESSORS_VBFA'.
        me->check_successors_vbfa(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN 'CHECK_THAT_NO_RESULTID___TEMP'.
        me->check_that_no_resultid(
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
        me->mo_run_environment->append_log( iv_log_statement =  |Could not find method { ls_step_data-action } for the BO { ls_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.
    ENDCASE.

  ENDMETHOD.


  METHOD pass_id.

* Return all documents from all precedings steps
* Workaround for PTF Script SDBIL_BD_ICO_W_ACC_RETURN_TG21

    ev_execution_status = abap_false.

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    "Get preceding documents
    DATA(lt_prec_docs) = me->mo_run_environment->get_result_key_data( it_step_number = ls_step_data-reference_step ).
    IF lt_prec_docs IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No reference document exists!| ).
      RETURN.
    ENDIF.
    IF lt_prec_docs[ 1 ]-document_id_char70 IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Unexpected input!| ).
      RETURN.
    ENDIF.

    ev_execution_status = abap_true.

    LOOP AT lt_prec_docs INTO DATA(ls_prec_doc).
      APPEND ls_prec_doc-document_id_char70 TO ev_document_id.
    ENDLOOP.
    me->mo_run_environment->append_log( iv_log_statement = |Passed { lines( ev_document_id ) } IDs.| ).

  ENDMETHOD.
ENDCLASS.
