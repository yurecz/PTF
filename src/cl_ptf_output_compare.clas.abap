class CL_PTF_OUTPUT_COMPARE definition
  public
  final
  create private .

public section.

  class-methods EXECUTE
    importing
      !IS_TDCV type PTF_S_OUTPUT_INVOCATION
      !IV_DOCUMENT_NUMBER type STRING .
  class-methods GET_TEST_RESULT
    exporting
      !EB_TEST_STATUS type ABAP_BOOL
      !ET_LOG type cl_ptf_util=>GT_PTF_RETURN_TAB .
  PROTECTED SECTION.
private section.

  data MS_OUTPUT_ENTITY type ref to DATA .
  data MS_TDCV_ENTITY type ref to DATA .
  data MS_TDCV type PTF_S_OUTPUT_INVOCATION .
  data MT_COMPONENT type PTF_T_STRING .
  class-data MT_LOG type cl_ptf_util=>GT_PTF_RETURN_TAB .
  data MV_DOCUMENT_NUMBER type STRING .
  data MB_ERROR_OCCURED type ABAP_BOOL value ABAP_FALSE ##NO_TEXT.
  constants MC_LANGUAGE type STRING value 'Language' ##NO_TEXT.
  constants MC_SENDERCOUNTRY type STRING value 'SenderCountry' ##NO_TEXT.
  data MO_STRUCDESC_ENTITY type ref to CL_ABAP_STRUCTDESCR .
  data MT_TDCV_METADATA type PTF_T_STRING .
  data MV_TDCV_METADATA_TABIX type I value 1 ##NO_TEXT.
  class-data MB_ERROR_OCCURED_COMPLETE_RUN type ABAP_BOOL value ABAP_FALSE ##NO_TEXT.
  class-data MO_COMPARISON type ref to CL_PTF_OUTPUT_COMPARE .
  class-data MV_OBJECT_COUNT type I value 0 ##NO_TEXT.

  methods READ_OUTPUT_DATA .
  methods COMPARE_METADATA
    importing
      !IV_COMPONENT_NAME type STRING
    returning
      value(RB_IRRELEVANT_COMPONENT) type ABAP_BOOL .
  methods READ_METADATA
    importing
      !IV_XSTRING type XSTRING .
  methods TRANSFORM_TDC_VARIANT .
  methods COMPARE_STRUCTURE
    importing
      !IS_OUTPUT_ENTITY type ANY
      !IS_TDCV_ENTITY type ANY .
  methods COMPARE_TABLE
    importing
      !IT_OUTPUT_ENTITY type TABLE
      !IT_TDCV_ENTITY type TABLE .
  methods COMPARE_VALUE
    importing
      !IV_OUTPUT_ENTITY type ANY
      !IV_TDCV_ENTITY type ANY
      !IV_PARAMETER_TYPE type ABAP_TYPEKIND .
  methods SET_TEST_STATUS .
  methods CLEAR_LAST_COMPONENT .
  methods CSTRING2XSTRING
    importing
      !IV_CSTRING type CSTRING
    exporting
      !EV_XSTRING type XSTRING .
  class-methods CREATE_OBJECT
    importing
      !IS_TDCV type PTF_S_OUTPUT_INVOCATION
      !IV_DOCUMENT_NUMBER type STRING .
  methods WRITE_LOG
    importing
      !IV_MESSAGE type STRING optional
      !IV_LOG_NO type BALOGNR optional
      !IV_LOG_MSG_NO type BALMNR optional
      !IV_MESSAGE_V1 type STRING optional
      !IV_MESSAGE_V2 type STRING optional
      !IV_MESSAGE_V3 type STRING optional
      !IV_MESSAGE_V4 type STRING optional
      !IV_PARAMETER type BAPI_PARAM optional
      !IV_ROW type BAPI_LINE optional
      !IV_FIELD type BAPI_FLD optional
      !IV_SYSTEM type BAPILOGSYS optional .
ENDCLASS.



CLASS CL_PTF_OUTPUT_COMPARE IMPLEMENTATION.


  METHOD clear_last_component.
    DATA lv_length TYPE i.
    DESCRIBE TABLE mt_component LINES lv_length.
    DELETE mt_component INDEX lv_length.
  ENDMETHOD.


  METHOD compare_metadata.
    DATA: ls_tdcv_metadata TYPE string.

    READ TABLE mt_tdcv_metadata INTO ls_tdcv_metadata INDEX mv_tdcv_metadata_tabix.

    mv_tdcv_metadata_tabix = mv_tdcv_metadata_tabix + 1.

    IF ls_tdcv_metadata NE iv_component_name.
      mb_error_occured = abap_true.
      write_log(
  EXPORTING
    iv_message    = concat_lines_of( table = mt_component sep = ` ` )
    iv_message_v1 = 'Metadata are not equal.'
    iv_message_v2 = 'Metadata in TDCV: ' && ls_tdcv_metadata
    iv_message_v3 = 'Metadata in Output: ' && iv_component_name ).
    ENDIF.

    IF ms_tdcv-irrelevant_components IS NOT INITIAL.
      READ TABLE ms_tdcv-irrelevant_components WITH KEY name = iv_component_name TRANSPORTING NO FIELDS.
      IF sy-subrc EQ 0.
        rb_irrelevant_component = abap_true.
      ELSE.
        rb_irrelevant_component = abap_false.
      ENDIF.

      APPEND iv_component_name TO mt_component.
    ELSE.
      "relevant_components is filled
      READ TABLE ms_tdcv-relevant_components WITH KEY name = iv_component_name TRANSPORTING NO FIELDS.
      IF sy-subrc EQ 0.
        rb_irrelevant_component = abap_false.
      ELSE.
        rb_irrelevant_component = abap_true.
      ENDIF.
      APPEND iv_component_name TO mt_component.
    ENDIF.

  ENDMETHOD.


  METHOD compare_structure.
    DATA: lt_component            TYPE cl_abap_structdescr=>component_table,
          ls_component            TYPE cl_abap_structdescr=>component,
          lv_tdcv_typekind        TYPE abap_typekind,
          lv_output_typekind      TYPE abap_typekind,
          lo_strucdesc_entity	    TYPE REF TO	cl_abap_structdescr,
          lb_irrelevant_component TYPE abap_bool.

    FIELD-SYMBOLS: <ls_output_entity> TYPE any,
                   <ls_tdcv_entity>   TYPE any,
                   <lu_output_entity> TYPE any,
                   <lu_tdcv_entity>   TYPE any.

    lo_strucdesc_entity ?= cl_abap_typedescr=>describe_by_data( is_output_entity ).
    lt_component  = lo_strucdesc_entity->get_components( ).

    ASSIGN: is_output_entity TO <ls_output_entity>,
            is_tdcv_entity TO <ls_tdcv_entity>.
    IF <ls_output_entity> IS ASSIGNED AND <ls_tdcv_entity> IS ASSIGNED.
      LOOP AT lt_component INTO ls_component.
        ASSIGN COMPONENT: ls_component-name OF STRUCTURE <ls_output_entity> TO <lu_output_entity>,
                          ls_component-name OF STRUCTURE <ls_tdcv_entity> TO <lu_tdcv_entity>.
        lb_irrelevant_component = compare_metadata( iv_component_name = ls_component-name ).
        IF <lu_output_entity> IS ASSIGNED AND <lu_tdcv_entity> IS ASSIGNED AND lb_irrelevant_component EQ abap_false.
          lv_output_typekind = ls_component-type->get_data_type_kind( p_data = <lu_output_entity> ).
          lv_tdcv_typekind = ls_component-type->get_data_type_kind( p_data = <lu_tdcv_entity> ).

          IF lv_tdcv_typekind EQ lv_output_typekind.
            CASE lv_output_typekind.
              WHEN 'u' OR 'v'. "Structure or deep structure
                compare_structure(
                  EXPORTING
                    is_output_entity = <lu_output_entity>
                    is_tdcv_entity = <lu_tdcv_entity> ).
              WHEN 'h'. "table
                compare_table(
                  EXPORTING
                    it_output_entity = <lu_output_entity>
                    it_tdcv_entity  = <lu_tdcv_entity> ).
              WHEN 'l' OR 'j' OR 'r'. "References are not allowed
                cl_aunit_assert=>fail( msg = 'Exception has been raised. Component type is a reference.').
              WHEN OTHERS. "Rest are Parameter
                compare_value(
                  EXPORTING
                    iv_output_entity = <lu_output_entity>
                    iv_tdcv_entity = <lu_tdcv_entity>
                    iv_parameter_type = lv_output_typekind ).
            ENDCASE.
          ELSE.
            cl_aunit_assert=>fail( msg = 'Exception has been raised. Type of tdcv and output are not equal.'). "should not happen
          ENDIF.
        ELSEIF lb_irrelevant_component EQ abap_false.
          cl_aunit_assert=>fail( msg = 'Exception has been raised. Fieldsymbol not assigent to structure element.'). "should not happen
        ENDIF.
        clear_last_component( ).
      ENDLOOP.
    ELSE.
      cl_aunit_assert=>fail( msg = 'Exception has been raised. Fieldsymbol not assingend to input strcuture.'). "should not happen
    ENDIF.
  ENDMETHOD.


  METHOD compare_table.
    DATA: lv_tdcv_entity_tabix    TYPE i VALUE 1,
          lv_output_entity_length TYPE i,
          lv_tdcv_entity_length   TYPE i,
          lv_component            TYPE string,
          ls_log                  TYPE LINE OF cl_ptf_util=>gt_ptf_return_tab,
          lo_table_entity         TYPE REF TO	cl_abap_tabledescr,
          lr_output_entity        TYPE REF TO data,
          lr_tdcv_entity          TYPE REF TO data.

    FIELD-SYMBOLS:
      <ls_output_entity> TYPE any,
      <ls_tdcv_entity>   TYPE any,
      <lt_output_entity> TYPE ANY TABLE,
      <lt_tdcv_entity>   TYPE ANY TABLE.

    lo_table_entity ?= cl_abap_tabledescr=>describe_by_data( it_output_entity ).
    CREATE DATA lr_output_entity TYPE HANDLE lo_table_entity.
    CREATE DATA lr_tdcv_entity TYPE HANDLE lo_table_entity.
    ASSIGN lr_output_entity->* TO <lt_output_entity>.
    ASSIGN lr_tdcv_entity->* TO  <lt_tdcv_entity>.

    MOVE-CORRESPONDING it_output_entity TO <lt_output_entity>.
    MOVE-CORRESPONDING it_tdcv_entity TO <lt_tdcv_entity>.

    lv_output_entity_length = lines( <lt_output_entity> ).
    lv_tdcv_entity_length = lines( <lt_tdcv_entity> ).

    IF lv_tdcv_entity_length NE lv_output_entity_length.
      DATA(length) = lines( mt_component ).
      lv_component = mt_component[ length ].
      mb_error_occured = abap_true.
      write_log(
  EXPORTING
    iv_message    = concat_lines_of( table = mt_component sep = ` ` )
    iv_message_v1 = 'Table length are different'
    iv_message_v2 = 'Expected length: ' && lv_tdcv_entity_length
    iv_message_v3 = 'Actual length: ' && lv_output_entity_length
    iv_message_v4 = 'Document number: ' && mv_document_number ).
    ELSE.
      LOOP AT it_output_entity ASSIGNING <ls_output_entity>.
        ASSIGN it_tdcv_entity[ lv_tdcv_entity_tabix ] TO <ls_tdcv_entity>.
        IF <ls_tdcv_entity> IS ASSIGNED AND <ls_output_entity> IS ASSIGNED.
          compare_structure(
            EXPORTING
              is_output_entity = <ls_output_entity>
              is_tdcv_entity   = <ls_tdcv_entity> ).
        ELSE.
          cl_aunit_assert=>fail( msg = 'Exception has been raised. Line of table not assigned.').
        ENDIF.
        lv_tdcv_entity_tabix = lv_tdcv_entity_tabix + 1.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD compare_value.
    FIELD-SYMBOLS: <lv_output_entity> TYPE any,
                   <lv_tdcv_entity>   TYPE any.
    DATA: lo_data_entity   TYPE REF TO cl_abap_datadescr,
          lv_output_entity TYPE REF TO data,
          lv_tdcv_entity   TYPE REF TO data,
          regex_matches    TYPE match_result_tab.

    lo_data_entity ?= cl_abap_datadescr=>describe_by_data( p_data = iv_output_entity ).
    CREATE DATA lv_output_entity TYPE HANDLE lo_data_entity.
    CREATE DATA lv_tdcv_entity TYPE HANDLE lo_data_entity.

    ASSIGN: lv_output_entity->* TO <lv_output_entity>,
            lv_tdcv_entity->* TO <lv_tdcv_entity>.

    <lv_output_entity> = iv_output_entity.
    <lv_tdcv_entity> = iv_tdcv_entity.

    IF <lv_output_entity> IS ASSIGNED AND <lv_tdcv_entity> IS ASSIGNED.
      IF iv_parameter_type EQ 'g'.  "In case of String, remove carriage return, line break
        REPLACE ALL OCCURRENCES OF REGEX
        '(' && cl_abap_char_utilities=>newline && '|' && cl_abap_char_utilities=>cr_lf  && ')'
        IN <lv_output_entity> WITH ''.
        REPLACE ALL OCCURRENCES OF REGEX
        '(' && cl_abap_char_utilities=>newline && '|' && cl_abap_char_utilities=>cr_lf  && ')'
        IN <lv_tdcv_entity> WITH ''.
      ENDIF.


      DATA(current_field_name) = mt_component[ lines( mt_component ) ].

      TRY.
          DATA(regex_data) = mo_comparison->ms_tdcv-regex_checks[ fieldname = current_field_name ].

          IF regex_data-regex IS NOT INITIAL.
            IF matches( val = iv_output_entity regex = regex_data-regex ).
              write_log(
                EXPORTING
                  iv_message    = |Content of { current_field_name } matches regex { regex_data-regex }: { iv_output_entity } |
              ).
            ELSE.
              mb_error_occured = abap_true.
              write_log(
                EXPORTING
                  iv_message    = |Content of { current_field_name } doesn't match regex { regex_data-regex }: { iv_output_entity } |
              ).
            ENDIF.
          ENDIF.

          IF regex_data-substring_retrieval IS NOT INITIAL.
            DATA(matcher) = cl_abap_matcher=>create( pattern     = regex_data-substring_retrieval
                                                   text        = iv_output_entity
                                                   ignore_case = abap_true ).
            regex_matches = matcher->find_all( ).

            IF regex_matches IS INITIAL.
              mb_error_occured = abap_true.
              write_log(
                EXPORTING
                  iv_message    = |Could not find any substring in { current_field_name } that matches regex { regex_data-regex }: { iv_output_entity } |
              ).
            ELSE.
              write_log(
                EXPORTING
                  iv_message    = |Found { lines( regex_matches ) } substrings in { current_field_name } that matches regex { regex_data-regex }: { iv_output_entity } |
              ).
            ENDIF.
          ENDIF.

          IF regex_data-substring_regex IS NOT INITIAL.
            IF regex_matches IS INITIAL.
              mb_error_occured = abap_true.
              write_log(
                EXPORTING
                  iv_message    = |No substrings for { current_field_name } to check with regex { regex_data-regex }: { iv_output_entity } |
              ).
            ELSE.

              LOOP AT regex_matches ASSIGNING FIELD-SYMBOL(<regex_match>).
                DATA(substring) = substring( val = iv_output_entity off = <regex_match>-offset len = <regex_match>-length ).
                IF matches( val = substring regex = regex_data-substring_regex ).
                  write_log(
                  EXPORTING
                    iv_message    = |Substring of { current_field_name } { substring } matches regex { regex_data-substring_regex }: { iv_output_entity } |
                  ).
                ELSE.
                  mb_error_occured = abap_true.
                  write_log(
                  EXPORTING
                    iv_message    = |Substring of { current_field_name } { substring } doesn't match regex { regex_data-substring_regex }: { iv_output_entity } |
                  ).
                ENDIF.
              ENDLOOP.
            ENDIF.
          ENDIF.


        CATCH cx_root.
          IF <lv_output_entity> NE <lv_tdcv_entity>.
            mb_error_occured = abap_true.
            write_log(
              EXPORTING
                iv_message    = concat_lines_of( table = mt_component sep = ` ` )
                iv_message_v1 = 'Values are not equal.'
                iv_message_v2 = 'Expected value: ' && iv_tdcv_entity
                iv_message_v3 = 'Actual value: ' && iv_output_entity
                iv_message_v4 = 'Document number: ' && mv_document_number ).
          ENDIF.
      ENDTRY.

    ELSE.
      cl_aunit_assert=>fail( msg = 'Exception has been raised. Fieldsymbol not assingend.'). "should not happen
    ENDIF.
  ENDMETHOD.


  METHOD create_object.
    IF mo_comparison IS NOT BOUND.
      mo_comparison = NEW cl_ptf_output_compare( ).
      mo_comparison->mv_document_number = iv_document_number.
      mo_comparison->ms_tdcv = is_tdcv.
      mv_object_count = mv_object_count + 1.
    ENDIF.
  ENDMETHOD.


  METHOD cstring2xstring.
    DATA: l_conv TYPE REF TO cl_abap_conv_out_ce.

    l_conv = cl_abap_conv_out_ce=>create( ).
    l_conv->convert( EXPORTING data = iv_cstring
                     IMPORTING buffer = ev_xstring ).
  ENDMETHOD.


  METHOD execute.
    FIELD-SYMBOLS: <ls_output_entity> TYPE any,
                   <ls_tdcv_entity>   TYPE any.

    create_object(
      EXPORTING
        is_tdcv            = is_tdcv " Output  Invocation
        iv_document_number = iv_document_number ).

    mo_comparison->write_log( EXPORTING iv_message = 'Begin of output check. Document ID is: ' && mo_comparison->mv_document_number ).

    mo_comparison->read_output_data( ).

    IF mo_comparison->mb_error_occured EQ abap_false.
      mo_comparison->transform_tdc_variant( ).

      IF mo_comparison->mb_error_occured EQ abap_false.
        ASSIGN mo_comparison->ms_output_entity->* TO <ls_output_entity>.
        ASSIGN mo_comparison->ms_tdcv_entity->* TO <ls_tdcv_entity>.
        mo_comparison->compare_structure(
           EXPORTING
             is_output_entity = <ls_output_entity>
             is_tdcv_entity   = <ls_tdcv_entity> ).
      ENDIF.
    ENDIF.

    mo_comparison->set_test_status( ).
    FREE mo_comparison.
  ENDMETHOD.


  METHOD get_test_result.
    IF mb_error_occured_complete_run = abap_false AND mv_object_count GT 0.
      eb_test_status = abap_true.
    ELSE.
      eb_test_status = abap_false.
    ENDIF.
    APPEND LINES OF mt_log TO et_log.

    mb_error_occured_complete_run = abap_false.
    CLEAR mt_log.

  ENDMETHOD.


  METHOD read_metadata.
*  The node name DATA is determined by report PTF_GET_XML_OUTPUT
    CONSTANTS: lc_open_node_name TYPE string VALUE 'DATA'.
    DATA: lb_node_is_open TYPE abap_bool VALUE abap_false,
          lo_xml_reader   TYPE REF TO if_sxml_reader.

    lo_xml_reader = cl_sxml_string_reader=>create( iv_xstring ).
    DATA(node) = lo_xml_reader->read_next_node( ).

    WHILE node IS NOT INITIAL.
* Find node DATA
      IF lo_xml_reader->name EQ  lc_open_node_name AND lb_node_is_open EQ abap_false.
        lb_node_is_open = abap_true.
        node = lo_xml_reader->read_next_node( ).
      ELSEIF lo_xml_reader->name EQ  lc_open_node_name AND lb_node_is_open EQ abap_true.
        lb_node_is_open = abap_false.
      ENDIF.

      IF lb_node_is_open EQ abap_true AND lo_xml_reader->node_type EQ if_sxml_node=>co_nt_element_open.
        IF lo_xml_reader->name NE 'item'. " Filled table has extra lines with node name item
          APPEND lo_xml_reader->name TO mt_tdcv_metadata.
        ENDIF.
      ENDIF.

      node = lo_xml_reader->read_next_node( ).
    ENDWHILE.
  ENDMETHOD.


  METHOD read_output_data.
    TYPES:
      BEGIN OF ty_gs_key,
        name  TYPE string,
        value TYPE string,
      END OF ty_gs_key,
      ty_gt_key TYPE STANDARD TABLE OF ty_gs_key WITH EMPTY KEY.

    DATA: lt_key_tab          TYPE ty_gt_key,
          ls_key_tab          TYPE ty_gs_key,
          ls_print_parameters TYPE ptf_s_print_parameters,
          ls_log              TYPE LINE OF cl_ptf_util=>gt_ptf_return_tab.

    IF ms_tdcv-service_name <> 'FDP_OM_FORM_MASTER_SRV'.
      lt_key_tab = VALUE #( ( name  = ms_tdcv-application_business_key value = mv_document_number )
                            ( name  = mc_language              value = ms_tdcv-language )
                            ( name  = mc_sendercountry         value = ms_tdcv-sendercountry ) ).
    ELSE.

      "Convert Language (only for FDP_OM_FORM_MASTER_SRV)

      DATA: lv_langu TYPE string.

      CALL FUNCTION 'CONVERSION_EXIT_ISOLA_INPUT'
        EXPORTING
          input            = ms_tdcv-language
        IMPORTING
          output           = lv_langu
        EXCEPTIONS
          unknown_language = 1
          OTHERS           = 2.
      IF sy-subrc <> 0.
        lv_langu = ms_tdcv-language.
      ELSE.


        lt_key_tab = VALUE #( ( name = if_somu_fpd_om_form_master=>gc_query_parameters-applicationobjecttype value = ms_tdcv-application_business_key )
                              ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-applicationobjectid value = mv_document_number )
                              ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-localelanguage      value = lv_langu )
                              ( name  = mc_sendercountry         value = ms_tdcv-sendercountry ) ).
      ENDIF.
    ENDIF.

    LOOP AT ms_tdcv-print_parameters INTO ls_print_parameters.
      ls_key_tab-name = ls_print_parameters-component.
      ls_key_tab-value = ls_print_parameters-value.
      APPEND ls_key_tab TO lt_key_tab.
    ENDLOOP.

    TRY.
        cl_somu_form_services=>get_instance( )->get_data(
          EXPORTING
            iv_service_name          = ms_tdcv-service_name
            it_key                   = lt_key_tab
          IMPORTING
            er_data_container        = ms_output_entity ).
      CATCH cx_somu_error.
        mb_error_occured = abap_true.
        APPEND ls_log TO mt_log.
        write_log( EXPORTING iv_message    = 'Document number: ' && mv_document_number &&
        ' Exception has been raised. Output entity was not created.' ).
    ENDTRY.
    mo_strucdesc_entity ?= cl_abap_typedescr=>describe_by_data_ref( ms_output_entity ).
  ENDMETHOD.


  METHOD set_test_status.
    DATA: ls_log TYPE LINE OF cl_ptf_util=>gt_ptf_return_tab.
    IF mb_error_occured = abap_false.
      write_log( EXPORTING iv_message = 'Output test was successful. Document id: ' && mv_document_number ).
    ELSEIF mb_error_occured = abap_true.
      write_log( EXPORTING iv_message = 'Output test failed. Document id: ' && mv_document_number ).
      mb_error_occured_complete_run = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD transform_tdc_variant.
    DATA: lv_xstring TYPE xstring,
          ls_log     TYPE LINE OF cl_ptf_util=>gt_ptf_return_tab.

    FIELD-SYMBOLS: <ls_output>      TYPE string,
                   <ls_tdcv_entity> TYPE any.
* Copy output entity type. call transformation needs the suitable type and it must output entity type
    CREATE DATA ms_tdcv_entity TYPE HANDLE mo_strucdesc_entity.
    ASSIGN ms_tdcv_entity->* TO <ls_tdcv_entity>.
* Create xstring to create lo_xml_reader(xml parser)
    READ TABLE ms_tdcv-output ASSIGNING <ls_output> INDEX 1.
    cstring2xstring(
       EXPORTING
         iv_cstring =  <ls_output>
       IMPORTING
         ev_xstring = lv_xstring ).
* Read metadata
    read_metadata(
      EXPORTING
        iv_xstring = lv_xstring ).
* Transformation
    TRY.
        CALL TRANSFORMATION id
          SOURCE XML lv_xstring
          RESULT data = <ls_tdcv_entity>.
      CATCH cx_transformation_error INTO DATA(lx_root).
        mb_error_occured = abap_true.
        write_log( EXPORTING iv_message = 'Document number: ' && mv_document_number &&
          ' Exception has been raised. XML transformation faild.' ).
    ENDTRY.
  ENDMETHOD.


  METHOD write_log.
    DATA: ls_log        TYPE LINE OF cl_ptf_util=>gt_ptf_return_tab,
          lv_message    TYPE string,
          lv_message_v1 TYPE string,
          lv_message_v2 TYPE string,
          lv_message_v3 TYPE string,
          lv_message_v4 TYPE string.

    lv_message = iv_message.
    lv_message_v1  = iv_message_v1.
    lv_message_v2  = iv_message_v2.
    lv_message_v3  = iv_message_v3.
    lv_message_v4  = iv_message_v4.

    WHILE lv_message IS NOT INITIAL OR lv_message_v1 IS NOT INITIAL OR
          lv_message_v2 IS NOT INITIAL OR lv_message_v3 IS NOT INITIAL OR
          lv_message_v4 IS NOT INITIAL.
      ls_log-message = lv_message.
      SHIFT lv_message BY 220 PLACES.
      ls_log-message_v1 = lv_message_v1.
      SHIFT lv_message_v1 BY 50 PLACES.
      ls_log-message_v2 = lv_message_v2.
      SHIFT lv_message_v2 BY 50 PLACES.
      ls_log-message_v3 = lv_message_v3.
      SHIFT lv_message_v3 BY 50 PLACES.
      ls_log-message_v4 = lv_message_v4.
      SHIFT lv_message_v4 BY 50 PLACES.
      APPEND ls_log TO mt_log.
    ENDWHILE.

  ENDMETHOD.
ENDCLASS.
