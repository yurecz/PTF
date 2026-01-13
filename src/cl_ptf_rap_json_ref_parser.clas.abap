class CL_PTF_RAP_JSON_REF_PARSER definition
  public
  final
  create public .

public section.

  interfaces IF_PTF_RAP_JSON_REF_PARSER .

  aliases PARSE_REFERENCE
    for IF_PTF_RAP_JSON_REF_PARSER~PARSE_REFERENCE .
  aliases PARSE_REFERENCES
    for IF_PTF_RAP_JSON_REF_PARSER~PARSE_REFERENCES .
  aliases TE_OPERATION
    for IF_PTF_RAP_JSON_REF_PARSER~TE_OPERATION .

  data MO_TRANSPORT type ref to CL_PTF_TRANSPORT .

  methods CONSTRUCTOR
    importing
      !IO_RUN_ENVIRONMENT type ref to CL_PTF_RUN .
protected section.
private section.

  types:
    BEGIN OF ts_data_cache,
        step_number TYPE i,
        data        TYPE REF TO data,
       END OF ts_data_cache .
  types:
    tt_data_cache TYPE STANDARD TABLE OF ts_data_cache WITH KEY step_number .
  types:
    BEGIN OF ENUM ts_reference_type,
          reference_mapping,
          system_variable,
          variable,
         END OF ENUM ts_reference_type .

  data MO_RUN_ENVIRONMENT type ref to CL_PTF_RUN .
  data MO_PTF_RAP_METADATA type ref to IF_PTF_RAP_METADATA .
  data MT_DATA_CACHE type TT_DATA_CACHE .
  data MT_VARDATASET type PTF_VARDATASET_T .
  constants MC_RESULTID type FIELDNAME value '%RESULTID' ##NO_TEXT.

  methods PARSE_REFERENCE_MAPPING
    importing
      !IV_ENTITY_NAME type ABP_ENTITY_NAME
      !IV_NAME type STRING
      !IV_STEP_NUMBER type I
      !IV_PARAM type ABAP_BOOL default ABAP_OFF
    exporting
      !EV_ERROR type ABAP_BOOL
    changing
      !CV_VALUE type ANY .
  methods GET_STEP_DATA
    importing
      !IV_ENTITY_NAME type ABP_ENTITY_NAME
      !IV_NAME type STRING
      !IV_STEP_NUMBER type I
      !IV_SPLIT type STRING
    exporting
      !ES_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
      !EV_ERROR type ABAP_BOOL .
  methods GET_RESULTID_REFERENCE
    importing
      !IV_ENTITY_NAME type ABP_ENTITY_NAME
      !IV_NAME type STRING
      !IV_LINE_INDEX type I
      !IV_FREE_KEY type STRING
      !IV_PARAM type ABAP_BOOL default ABAP_OFF
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_ERROR type ABAP_BOOL
    changing
      !CV_VALUE type ANY .
  methods GET_OTHER_REFERENCE
    importing
      !IV_ENTITY_NAME type ABP_ENTITY_NAME
      !IV_NAME type STRING
      !IV_COMPONENT_NAME type FIELDNAME
      !IV_LINE_INDEX type I
      !IV_FREE_KEY type STRING
      !IV_PARAM type ABAP_BOOL default ABAP_OFF
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !ER_DATA type ANY
      !EV_ERROR type ABAP_BOOL .
  methods TRAVERSE_REFERENCE_NODES
    importing
      !IV_ENTITY_NAME type ABP_ENTITY_NAME
      !IV_NAME type STRING
      !IV_COMPONENT_NAME type FIELDNAME
      !IV_TABIX type SYTABIX
      !IV_LINES type I
      !IV_LINE_INDEX type I
      !IV_FREE_KEY type STRING
      !IV_PARAM type ABAP_BOOL default ABAP_OFF
      !IS_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP
    exporting
      !EV_ERROR type ABAP_BOOL
    changing
      !CR_DATA type ref to DATA
      !CV_VALUE type ANY .
  methods READ_LINE_BY_INDEX
    importing
      !IV_ENTITY_NAME type ABP_ENTITY_NAME
      !IV_NAME type STRING
      !IV_COMPONENT_NAME type FIELDNAME
      !IV_LINE_INDEX type I
    exporting
      !EV_ERROR type ABAP_BOOL
    changing
      !CR_DATA type ref to DATA .
  methods READ_LINE_BY_ACCESS
    importing
      !IV_ENTITY_NAME type ABP_ENTITY_NAME
      !IV_NAME type STRING
      !IV_COMPONENT_NAME type FIELDNAME
      !IV_FREE_KEY type STRING
    exporting
      !EV_ERROR type ABAP_BOOL
    changing
      !CR_DATA type ref to DATA .
  methods SUBSTRING_VALUE
    importing
      !IV_ENTITY_NAME type ABP_ENTITY_NAME
      !IV_NAME type STRING
      !IV_COMPONENT_NAME type FIELDNAME
      !IV_OFFSET type I
      !IV_LENGTH type I
      !IV_REFERENCE_TYPE type TS_REFERENCE_TYPE
      !IV_PARAM type ABAP_BOOL default ABAP_OFF
    exporting
      !EV_ERROR type ABAP_BOOL
    changing
      !CV_VALUE type ANY .
  methods PARSE_SYSTEM_VARIABLE
    importing
      !IV_ENTITY_NAME type ABP_ENTITY_NAME
      !IV_NAME type STRING
      !IV_PARAM type ABAP_BOOL default ABAP_OFF
    exporting
      !EV_ERROR type ABAP_BOOL
    changing
      !CV_VALUE type ANY .
  methods PARSE_VARIABLE
    importing
      !IV_ENTITY_NAME type ABP_ENTITY_NAME
      !IV_NAME type STRING
      !IV_STEP_NUMBER type I
      !IV_PARAM type ABAP_BOOL default ABAP_OFF
    exporting
      !EV_ERROR type ABAP_BOOL
    changing
      !CV_VALUE type ANY .
ENDCLASS.



CLASS CL_PTF_RAP_JSON_REF_PARSER IMPLEMENTATION.


  METHOD constructor.
    me->mo_run_environment  = io_run_environment.
    me->mo_ptf_rap_metadata = NEW cl_ptf_rap_metadata( ).

  ENDMETHOD.


  METHOD get_other_reference.
    DATA: lo_datadescr  TYPE REF TO cl_abap_datadescr,
          lo_typedescr  TYPE REF TO cl_abap_typedescr,
          lv_fp_name    TYPE string,
          lv_line_index TYPE i.

    FIELD-SYMBOLS: <fs_data> TYPE any.

    CLEAR: er_data, ev_error.

    CASE iv_param.
      WHEN abap_off.
        lv_fp_name = 'field'.

      WHEN abap_on.
        lv_fp_name = 'parameter'.

    ENDCASE.

    lv_line_index = iv_line_index.

    "Check entity doesn't start with &
    IF iv_component_name CP '%*'.
      me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: Reference error| ).
      me->mo_run_environment->append_log( |Component { iv_component_name } is invalid| ).
      ev_error = abap_on.
      RETURN.

    ENDIF.

    "Check that path begins with BO name
    IF iv_component_name <> to_upper( is_step_data-bus_obj ) AND is_step_data-action <> 'RETRIEVE'. "do not check for RETRIEVE, which supports reverse associations, that start at a subentity
      me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: Reference error:| ).
      me->mo_run_environment->append_log( |Entity name { iv_component_name } doesn't match with BO from referenced step { is_step_data-step_number }| ).
      ev_error = abap_on.
      RETURN.
    ENDIF.

*   Retrieve data object
*   Check if it's in the internal cache
    IF line_exists( me->mt_data_cache[ step_number = is_step_data-step_number ] ).
*     Copy the data, not just the reference itself otherwise it will be changed
      lo_datadescr ?= cl_abap_datadescr=>describe_by_data( me->mt_data_cache[ step_number = is_step_data-step_number ]-data->* ).
      CREATE DATA er_data TYPE HANDLE lo_datadescr.
      ASSIGN er_data->* TO <fs_data>.

      <fs_data> = me->mt_data_cache[ step_number = is_step_data-step_number ]-data->* .

*      er_data = me->mt_data_cache[ step_number = is_step_data-step_number ]-data.

    ELSE.
      /ui2/cl_json=>deserialize(
          EXPORTING
            json          = is_step_data-data_object_json
            assoc_arrays  = abap_on
          CHANGING
            data          = er_data ).
      IF er_data IS NOT BOUND.
        me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: Reference error| ).
        me->mo_run_environment->append_log( |Step number { is_step_data-step_number } doesn't have data object json| ).
        ev_error = abap_on.
        RETURN.

      ENDIF.

*      lo_datadescr ?= cl_abap_datadescr=>describe_by_data( er_data->* ).
*      CREATE DATA lr_data TYPE HANDLE lo_datadescr.
*      ASSIGN lr_data->* TO <fs_data>.
*
*      <fs_data> = er_data->*.
*      APPEND VALUE #( step_number = is_step_data-step_number data = lr_data ) TO me->mt_data_cache.

      APPEND VALUE #( step_number = is_step_data-step_number data = er_data ) TO me->mt_data_cache.

    ENDIF.

*   Check if it's a standard table
    lo_typedescr = cl_abap_typedescr=>describe_by_data( er_data->* ).

    CASE lo_typedescr->type_kind.
      WHEN cl_abap_typedescr=>typekind_table. "itab -> multiple instances
        IF lv_line_index IS INITIAL AND iv_free_key IS INITIAL.
          lv_line_index = 1.
          me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: Reference warning| ).
          me->mo_run_environment->append_log( 'Line index not specified between square brackets. Defaulting to index 1' ).

        ENDIF.

        IF lv_line_index IS NOT INITIAL. "access by index
          me->read_line_by_index(
            EXPORTING
              iv_entity_name    = iv_entity_name
              iv_name           = iv_name
              iv_component_name = iv_component_name
              iv_line_index     = lv_line_index
            IMPORTING
              ev_error          = ev_error
            CHANGING
              cr_data           = er_data
          ).
          IF ev_error = abap_on.
            RETURN.

          ENDIF.

        ELSEIF iv_free_key IS NOT INITIAL. "access by components
          me->read_line_by_access(
            EXPORTING
              iv_entity_name    = iv_entity_name
              iv_name           = iv_name
              iv_component_name = iv_component_name
              iv_free_key       = iv_free_key
            IMPORTING
              ev_error          = ev_error
            CHANGING
              cr_data           = er_data
          ).
          IF ev_error = abap_on.
            RETURN.

          ENDIF.

        ENDIF.

      WHEN cl_abap_typedescr=>typekind_struct1
        OR cl_abap_typedescr=>typekind_struct2. "structure -> one instance
        IF lv_line_index IS NOT INITIAL AND lv_line_index <> 1.
          me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: Reference error| ).
          me->mo_run_environment->append_log( 'Line index is invalid' ).
          ev_error = abap_on.
          RETURN.

        ENDIF.

*        To be decided in the future
*        Sometimes the user could copy free access from another test even if not necessary*
*        IF iv_free_key IS NOT INITIAL.
*          me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: Reference error| ).
*          me->mo_run_environment->append_log( 'Access by free key is invalid' ).
*          ev_error = abap_on.
*          RETURN.
*
*        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD get_resultid_reference.
    DATA lv_fp_name TYPE string.
    DATA lv_line_index TYPE i.

    CLEAR ev_error.

    lv_line_index = iv_line_index.

    IF lv_line_index IS INITIAL.
      lv_line_index = 1.
      me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: Reference warning| ).
      me->mo_run_environment->append_log( '%ResultId index not specified between square brackets. Defaulting to index 1 .' ).

    ENDIF.

    CASE iv_param.
      WHEN abap_off.
        lv_fp_name = 'field'.

      WHEN abap_on.
        lv_fp_name = 'parameter'.

    ENDCASE.

    IF iv_free_key IS NOT INITIAL.
      me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: Reference error| ).
      me->mo_run_environment->append_log( 'Specify %ResultId index between square brackets' ).
      ev_error = abap_on.
      RETURN.

    ENDIF.

    DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = is_step_data-step_number ).

    IF lt_ptf_keys IS INITIAL.
      me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: Reference error| ).
      me->mo_run_environment->append_log( |No Result IDs exist at reference step { is_step_data-step_number } !| ).
      ev_error = abap_on.
      RETURN.

    ENDIF.

    TRY.
        DATA(lv_ptf_key) = lt_ptf_keys[ lv_line_index ].

      CATCH cx_sy_itab_line_not_found.
        me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: Reference error| ).
        me->mo_run_environment->append_log( |No Result ID exists with index { lv_line_index } at reference step { is_step_data-step_number } !| ).
        ev_error = abap_on.
        RETURN.

    ENDTRY.

    cv_value = lv_ptf_key.

*   Add log
    me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: Reference mapping| ).
    me->mo_run_environment->append_log( |Referenced ResultID: { cv_value }| ).

  ENDMETHOD.


  METHOD get_step_data.
    DATA: lv_step_number TYPE i.

    CLEAR: es_step_data, ev_error.

*   Check step number, (?<=^step\[) = step starts with step[ , -? = optional negative sign, \d+ = step number to extract , (?=\]%) = succeeded end ending with ]
    lv_step_number = match( val = iv_split pcre = '(?<=^step\[)-?\d+(?=\]$)' case = abap_false ).

    IF lv_step_number IS INITIAL.
      me->mo_run_environment->append_log( |Entity { iv_entity_name }, field { iv_name }: Reference error| ).
      me->mo_run_environment->append_log( 'Invalid step number' ).
      ev_error = abap_on.
      RETURN.

    ENDIF.

*   Check step number to not be greater or equal than current step
    IF lv_step_number >= iv_step_number.
      me->mo_run_environment->append_log( |Entity { iv_entity_name }, field { iv_name }| ).
      me->mo_run_environment->append_log( |Reference error - Step number { lv_step_number } is invalid, reference only steps before the current step| ).
      ev_error = abap_on.
      RETURN.

    ENDIF.

*   If negative step is negative then it means it's relative, convert it to absolute step number
    IF lv_step_number < 0.
      lv_step_number = iv_step_number + lv_step_number.

      IF lv_step_number <= 0. "If absolute step number is 0 or negative then issue log message
        me->mo_run_environment->append_log( |Entity { iv_entity_name }, field { iv_name }: Reference error| ).
        me->mo_run_environment->append_log( 'Invalid relative step number' ).
        ev_error = abap_on.
        RETURN.

      ENDIF.

    ENDIF.

*   Get step data
    es_step_data = me->mo_run_environment->get_step_data( iv_step_number = lv_step_number ).

    IF es_step_data-bus_obj IS INITIAL.
      me->mo_run_environment->append_log( |Entity { iv_entity_name }, field { iv_name }| ).
      me->mo_run_environment->append_log( |Reference error - Step number { lv_step_number } not found| ).
      ev_error = abap_on.
      RETURN.

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_rap_json_ref_parser~parse_reference.
    CLEAR ev_error.

*   Check if it's reference (starts with /step)
    IF matches( val = cv_value pcre = '^\/step.*$' case = abap_false ).
      me->parse_reference_mapping(
        EXPORTING
          iv_entity_name    = iv_entity_name
          iv_name           = iv_name
          iv_step_number    = iv_step_number
          iv_param          = iv_param
        IMPORTING
          ev_error          = ev_error
        CHANGING
          cv_value          = cv_value

      ).

*   Check if it's system variable (starts with %sy- )
    ELSEIF matches( val = cv_value pcre = '^%sy-.*$' case = abap_false ).
      me->parse_system_variable(
        EXPORTING
          iv_entity_name    = iv_entity_name
          iv_name           = iv_name
          iv_param          = iv_param
        IMPORTING
          ev_error          = ev_error
        CHANGING
          cv_value          = cv_value
      ).

*   Check if it is a Data Set Variable (starts with & )
    ELSEIF matches( val = cv_value pcre = '^\&.*$' case = abap_false ).
      me->parse_variable(
        EXPORTING
          iv_entity_name    = iv_entity_name
          iv_name           = iv_name
          iv_step_number    = iv_step_number
          iv_param          = iv_param
        IMPORTING
          ev_error          = ev_error
        CHANGING
          cv_value          = cv_value
      ).

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_rap_json_ref_parser~parse_references.
    DATA: lo_structdescr    TYPE REF TO cl_abap_structdescr,
          lv_entity_name    TYPE abp_entity_name,
          lv_error          TYPE abap_bool,
          lv_param          TYPE abap_bool.

    FIELD-SYMBOLS: <fs_test_data>     TYPE any,
                   <fs_value>         TYPE any.

    CLEAR ev_error.

    lo_structdescr ?= cl_abap_structdescr=>describe_by_data( cs_test_data ).
    DATA(lt_components) = me->mo_ptf_rap_metadata->recursive_get_components( lo_structdescr ).

    LOOP AT lt_components ASSIGNING FIELD-SYMBOL(<fs_component>).
*     Skip components that start with _ but not _PARAMS, and if the data to be parsed is not from parameters
      IF <fs_component>-name CP '_*' AND <fs_component>-name <> '_PARAMS' AND iv_param = abap_off.
        CONTINUE.

      ENDIF.

*     We use the following parameters for log messages depending if we have a field reference or a parameter reference
      IF <fs_component>-name = '_PARAMS'. "parameters
        lv_entity_name = iv_entity_name. "entity name
        lv_param       = abap_on.

      ELSE. "fields
        lv_entity_name = <fs_component>-name. "entity name
        lv_param       = iv_param.

      ENDIF.

*     Check the type of field
      CASE <fs_component>-type->type_kind.
        WHEN cl_abap_typedescr=>typekind_table. "itab
          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE cs_test_data TO FIELD-SYMBOL(<fs_test_data_t>).

          LOOP AT <fs_test_data_t> ASSIGNING <fs_test_data>.
*           Parse references
            me->if_ptf_rap_json_ref_parser~parse_references(
              EXPORTING
                iv_entity_name  = lv_entity_name
                iv_step_number  = iv_step_number
                iv_param        = lv_param
              IMPORTING
                ev_error        = lv_error
              CHANGING
                cs_test_data    = <fs_test_data> ).

            IF lv_error = abap_on.
              ev_error = abap_on.

            ENDIF.

          ENDLOOP.

        WHEN cl_abap_typedescr=>typekind_struct1
          OR cl_abap_typedescr=>typekind_struct2. "structure
          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE cs_test_data TO <fs_test_data>.

*         Parse references
          me->if_ptf_rap_json_ref_parser~parse_references(
            EXPORTING
              iv_entity_name  = lv_entity_name
              iv_step_number  = iv_step_number
              iv_param        = lv_param
            IMPORTING
              ev_error        = lv_error
            CHANGING
              cs_test_data    = <fs_test_data> ).

          IF lv_error = abap_on.
            ev_error = abap_on.

          ENDIF.

        WHEN OTHERS. "element
          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE cs_test_data TO <fs_value>.

          me->if_ptf_rap_json_ref_parser~parse_reference(
            EXPORTING
              iv_entity_name = iv_entity_name
              iv_name        = <fs_component>-name
              iv_step_number = iv_step_number
              iv_param       = lv_param
            IMPORTING
              ev_error       = lv_error
            CHANGING
              cv_value       = <fs_value>
          ).

          IF lv_error = abap_on.
            ev_error = abap_on.

          ENDIF.

      ENDCASE.

    ENDLOOP.

  ENDMETHOD.


  METHOD parse_reference_mapping.
    DATA: lr_data           TYPE REF TO data,
*          lo_typedescr      TYPE REF TO cl_abap_typedescr,
          lv_component_name TYPE fieldname,
          lv_line_index     TYPE i,
          lv_free_key       TYPE string,
          lv_offset         TYPE i,
*          lv_addition       TYPE i,
*          lv_subtraction    TYPE i,
          lv_length         TYPE i.
*          lv_date           TYPE d,
*          lv_time           TYPE t.

    CLEAR ev_error.

*   Remove first slash
*    cv_value = cv_value+1.

    SPLIT cv_value+1 AT '/' INTO TABLE DATA(lt_split).

    DATA(lv_lines) = lines( lt_split ).

    LOOP AT lt_split ASSIGNING FIELD-SYMBOL(<fs_split>).
      DATA(lv_tabix) = sy-tabix.

      CLEAR: lv_free_key, lv_offset, lv_length.

      CASE lv_tabix.
        WHEN 1. "check step number
          me->get_step_data(
            EXPORTING
              iv_entity_name = iv_entity_name
              iv_name        = iv_name
              iv_step_number = iv_step_number
              iv_split       = <fs_split>
            IMPORTING
              es_step_data   = DATA(ls_step_data)
              ev_error       = ev_error
          ).
          IF ev_error = abap_on.
            EXIT.

          ENDIF.

        WHEN OTHERS.
*         Check if we have square brackets (?<=\[) = string preceding [, .+ = any characters to extract , (?=\]) = succeeded by ]
          TRY.
              lv_line_index = match( val = <fs_split> pcre = '(?<=\[).+(?=\])' case = abap_false ).

            CATCH cx_sy_conversion_no_number. "if .+ is not number it means we should have access by attributes
              lv_free_key = match( val = <fs_split> pcre = '(?<=\[).+(?=\])' case = abap_false ).

          ENDTRY.

*         Get offset (?<=\+) = string preceding + , \d+ = number to extract , (?=\() = succeeded by (
          lv_offset = match( val = <fs_split> pcre = '(?<=\+)\d+(?=\()' case = abap_false ).

*          lv_addition = lv_offset.

**         Get  - (?<=\-) = string preceding + , \d+ = number to extract , (?=\() = succeeded by (
*          lv_subtraction = match( val = <fs_split> pcre = '(?<=\-)\d+(?=\()' case = abap_false ).

*         Get length (?<=() = string preceding ( , \d+ = number to extract , (?=\)) = succeeded by )
          lv_length = match( val = <fs_split> pcre = '(?<=\()\d+(?=\)$)' case = abap_false ).

*         Get component name [\w\%]+ = string with any letter, digit or underscore, equivalent to [a-zA-Z0-9_] , and character %
          lv_component_name = match( val = <fs_split> pcre = '[\w\%]+' case = abap_false ).

*         Translate to uppercase
          lv_component_name = to_upper( lv_component_name ).

          CASE lv_tabix.
            WHEN 2.
              CASE lv_component_name.
                WHEN mc_resultid. "Reference to document id
                  me->get_resultid_reference(
                    EXPORTING
                      iv_entity_name  = iv_entity_name
                      iv_name         = iv_name
                      iv_line_index   = lv_line_index
                      iv_free_key     = lv_free_key
                      iv_param        = iv_param
                      is_step_data    = ls_step_data
                    IMPORTING
                      ev_error        = ev_error
                    CHANGING
                      cv_value        = cv_value
                  ).
                  IF ev_error = abap_on.
                    EXIT.

                  ENDIF.

                WHEN OTHERS. "Ref to data fields
                  me->get_other_reference(
                    EXPORTING
                      iv_entity_name    = iv_entity_name
                      iv_name           = iv_name
                      iv_component_name = lv_component_name
                      iv_line_index     = lv_line_index
                      iv_free_key       = lv_free_key
                      iv_param          = iv_param
                      is_step_data      = ls_step_data
                    IMPORTING
                      er_data           = lr_data
                      ev_error          = ev_error
                  ).
                  IF ev_error = abap_on.
                    EXIT.

                  ENDIF.

              ENDCASE.

            WHEN OTHERS. "Traverse the reference nodes
              me->traverse_reference_nodes(
                EXPORTING
                  iv_entity_name    = iv_entity_name
                  iv_name           = iv_name
                  iv_component_name = lv_component_name
                  iv_tabix          = lv_tabix
                  iv_lines          = lv_lines
                  iv_line_index     = lv_line_index
                  iv_free_key       = lv_free_key
                  iv_param          = iv_param
                  is_step_data      = ls_step_data
                IMPORTING
                  ev_error          = ev_error
                CHANGING
                  cr_data           = lr_data
                  cv_value          = cv_value
              ).
              IF ev_error = abap_on.
                EXIT.

              ENDIF.

          ENDCASE.

          IF lv_tabix = lv_lines.
            me->substring_value(
              EXPORTING
                iv_entity_name    = iv_entity_name
                iv_name           = iv_name
                iv_component_name = lv_component_name
                iv_offset         = lv_offset
                iv_length         = lv_length
                iv_reference_type = reference_mapping
                iv_param          = iv_param
             IMPORTING
                ev_error          = ev_error
             CHANGING
                cv_value          = cv_value
            ).

**           Check if it's a date or time
*            lo_typedescr = cl_abap_typedescr=>describe_by_data( cv_value ).
*
*            CASE lo_typedescr->type_kind.
*              WHEN cl_abap_typedescr=>typekind_date. "date
*                lv_date = cv_value.
*
*                IF lv_addition IS NOT INITIAL.
*                  lv_date = lv_date + lv_addition.
*
*                ENDIF.
*
*                IF lv_subtraction IS NOT INITIAL.
*                  lv_date = lv_date - lv_subtraction.
*
*                ENDIF.
*
*                cv_value = lv_date.
*
*              WHEN cl_abap_typedescr=>typekind_time. "time
*                lv_time = cv_value.
*
*                IF lv_addition IS NOT INITIAL.
*                  lv_time = lv_time + lv_addition.
*
*                ENDIF.
*
*                IF lv_subtraction IS NOT INITIAL.
*                  lv_time = lv_time - lv_subtraction.
*
*                ENDIF.
*
*                cv_value = lv_time.
*
*              WHEN OTHERS.
*                me->substring_value(
*                  EXPORTING
*                    iv_entity_name    = iv_entity_name
*                    iv_name           = iv_name
*                    iv_component_name = lv_component_name
*                    iv_offset         = lv_offset
*                    iv_length         = lv_length
*                    iv_reference_type = reference_mapping
*                 IMPORTING
*                    ev_error          = ev_error
*                 CHANGING
*                    cv_value          = cv_value
*                ).
*
*            ENDCASE.

          ENDIF.

      ENDCASE.

    ENDLOOP.

  ENDMETHOD.


  METHOD parse_system_variable.
    DATA: lo_typedescr      TYPE REF TO cl_abap_typedescr,
          lv_component_name TYPE fieldname,
          lv_value          TYPE string,
          lv_fp_name        TYPE string,
          lv_offset         TYPE i,
          lv_addition       TYPE i,
          lv_subtraction    TYPE i,
          lv_length         TYPE i,
          lv_date           TYPE d,
          lv_time           TYPE t.

    CLEAR ev_error.

    CASE iv_param.
      WHEN abap_off.
        lv_fp_name = 'field'.

      WHEN abap_on.
        lv_fp_name = 'parameter'.

    ENDCASE.

    lv_value = cv_value.

*   Remove spaces
    CONDENSE lv_value NO-GAPS.

    lv_component_name = lv_value.

*   Translate to uppercase
    lv_component_name = to_upper( lv_component_name ).

    DATA(lv_component) = match( val = lv_value pcre = '(?<=%sy-).*?(?=\+|\-|$)' case = abap_false ). "remove %SY- and + or -

*   Translate to uppercase
    lv_component = to_upper( lv_component ).

*   Add log
    me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: System variable assignment, %SY-{ lv_component }| ).

*   Get offset / + (?<=\+) = string preceding + , \d+ = number to extract
    lv_offset = match( val = lv_value pcre = '(?<=\+)\d+' case = abap_false ).

    lv_addition = lv_offset.

*   Get  - (?<=\-) = string preceding + , \d+ = number to extract
    lv_subtraction = match( val = lv_value pcre = '(?<=\-)\d+' case = abap_false ).

*   Get length (?<=() = string preceding ( , \d+ = number to extract , (?=\)) = succeeded by )
    lv_length = match( val = lv_value pcre = '(?<=\()\d+(?=\)$)' case = abap_false ).

    ASSIGN COMPONENT lv_component OF STRUCTURE sy TO FIELD-SYMBOL(<fs_value>).
    IF sy-subrc = 0.
      cv_value = <fs_value>.

*     Check if it's a date or time
      lo_typedescr = cl_abap_typedescr=>describe_by_data( <fs_value> ).

      CASE lo_typedescr->type_kind.
        WHEN cl_abap_typedescr=>typekind_date. "date
          lv_date = <fs_value>.

          IF lv_addition IS NOT INITIAL.
            lv_date = lv_date + lv_addition.

          ENDIF.

          IF lv_subtraction IS NOT INITIAL.
            lv_date = lv_date - lv_subtraction.

          ENDIF.

          cv_value = lv_date.

          me->mo_run_environment->append_log( |Referenced value: { cv_value }| ).

        WHEN cl_abap_typedescr=>typekind_time. "time
          lv_time = <fs_value>.

          IF lv_addition IS NOT INITIAL.
            lv_time = lv_time + lv_addition.

          ENDIF.

          IF lv_subtraction IS NOT INITIAL.
            lv_time = lv_time - lv_subtraction.

          ENDIF.

          cv_value = lv_time.

          me->mo_run_environment->append_log( |Referenced value: { cv_value }| ).

        WHEN OTHERS.
          me->mo_run_environment->append_log( |Referenced value: { cv_value }| ).

          me->substring_value(
            EXPORTING
              iv_entity_name    = iv_entity_name
              iv_name           = iv_name
              iv_component_name = lv_component_name
              iv_offset         = lv_offset
              iv_length         = lv_length
              iv_reference_type = system_variable
              iv_param          = iv_param
           IMPORTING
              ev_error          = ev_error
           CHANGING
              cv_value          = cv_value
          ).

      ENDCASE.

    ELSE.
      me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: System variable error| ).
      me->mo_run_environment->append_log( |Component { lv_component_name } is not a system variable| ).
      ev_error = abap_on.
      RETURN.

    ENDIF.

  ENDMETHOD.


  METHOD parse_variable.
    DATA: lv_component_name TYPE fieldname,
          lv_value          TYPE string,
          lv_fp_name        TYPE string,
          lv_offset         TYPE i,
          lv_length         TYPE i.

    CLEAR ev_error.

    CASE iv_param.
      WHEN abap_off.
        lv_fp_name = 'field'.

      WHEN abap_on.
        lv_fp_name = 'parameter'.

    ENDCASE.

*   Get step data
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

*   Get PTF Variant Name
    DATA(lv_ptf_variant_name) = me->mo_run_environment->get_variant_name( ).
    DATA(lo_ptf_vardataset) = NEW cl_ptf_vardataset( ).

*   Copy to local variable
    lv_value = cv_value.

*   Get offset / + (?<=\+) = string preceding + , \d+ = number to extract
    lv_offset = match( val = lv_value pcre = '(?<=\+)\d+' case = abap_false ).

*   Get length (?<=() = string preceding ( , \d+ = number to extract , (?=\)) = succeeded by )
    lv_length = match( val = lv_value pcre = '(?<=\()\d+(?=\)$)' case = abap_false ).

*   Get variable name [\w\&]+ = string with any letter, digit or underscore, equivalent to [a-zA-Z0-9_] , and character &
    lv_value = match( val = lv_value pcre = '[\w\&]+' case = abap_false ).

*   Remove spaces
    CONDENSE lv_value NO-GAPS.

*   Translate to uppercase
    lv_value = to_upper( lv_value ).

    lv_component_name = lv_value.

*   Add log
    me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: Variable assignment, { lv_value }| ).
    me->mo_run_environment->append_log( |Data Set ID { ls_step_data-test_data_container }, PTF Variant { lv_ptf_variant_name }| ).    "temp

*   Load full var data set if cache is empty
    IF me->mt_vardataset IS INITIAL.
      TRY.
        me->mt_vardataset = lo_ptf_vardataset->load( iv_varname = lv_ptf_variant_name ).

      CATCH cx_ptf_vardataset INTO DATA(lx_ptf_vardataset).
        me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: Variable error| ).
        me->mo_run_environment->append_log( lx_ptf_vardataset->get_text( ) ).
        ev_error = abap_on.
        RETURN.

      ENDTRY.

    ENDIF.

*   Load the variable
    TRY.
      DATA(ls_ptf_vardataset) = me->mt_vardataset[ dataset_id = ls_step_data-test_data_container variable_name = CONV #( lv_value ) ].   "temp

    CATCH cx_sy_itab_line_not_found ##NO_HANDLER.
      me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: Variable error| ).
      me->mo_run_environment->append_log( |Variable { cv_value } not assigned to Data Set ID { ls_step_data-test_data_container }| ). "temp
      ev_error = abap_on.
      RETURN.

    ENDTRY.

    TRY.
      cv_value = ls_ptf_vardataset-variable_value.

    CATCH cx_sy_conversion_error INTO DATA(lx_sy_conversion_error).
      me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: Variable error| ).
      me->mo_run_environment->append_log( lx_sy_conversion_error->get_text( ) ).
      ev_error = abap_on.
      RETURN.

    ENDTRY.

    me->mo_run_environment->append_log( |Referenced value: { cv_value }| ).

*   Apply substring
    me->substring_value(
      EXPORTING
        iv_entity_name    = iv_entity_name
        iv_name           = iv_name
        iv_component_name = lv_component_name
        iv_offset         = lv_offset
        iv_length         = lv_length
        iv_reference_type = variable
        iv_param          = iv_param
     IMPORTING
        ev_error          = ev_error
     CHANGING
        cv_value          = cv_value
    ).

  ENDMETHOD.


  METHOD read_line_by_access.
    TYPES: BEGIN OF ts_free_key,
            operator  TYPE c LENGTH 3,
            component TYPE fieldname,
            value_ref TYPE REF TO data,
            "id        TYPE sysuuid_c32,
            "parent_id TYPE sysuuid_c32,
           END OF ts_free_key,
           tt_free_key TYPE STANDARD TABLE OF ts_free_key WITH DEFAULT KEY.

    DATA: lo_tabledescr TYPE REF TO cl_abap_tabledescr,
          lo_elemdescr  TYPE REF TO cl_abap_elemdescr,
          lr_table      TYPE REF TO data,
          lr_new_data   TYPE REF TO data,
          lt_free_key     TYPE tt_free_key,
          lt_pair       TYPE STANDARD TABLE OF string WITH DEFAULT KEY,
          ls_free_key     TYPE ts_free_key,
          lv_free_key     TYPE string.

    FIELD-SYMBOLS: <fs_table>     TYPE STANDARD TABLE,
                   <fs_table_f>   TYPE STANDARD TABLE,
                   <fs_data>      TYPE any,
                   <fs_data_ref>  TYPE any,
                   <fs_value>     TYPE any,
                   <fs_new_value> TYPE any,
                   <fs_free_key>    TYPE ts_free_key,
                   <fs_value_ref> TYPE any.

    CLEAR ev_error.

    lv_free_key = iv_free_key.

*   Check if there are parantheses and issue error
    IF lv_free_key CA '()'.
      me->mo_run_environment->append_log( |Entity { iv_entity_name }, field { iv_name }: Reference error| ).
      me->mo_run_environment->append_log( |Component { iv_component_name }, line free_key with precedence not supported| ).
      ev_error = abap_on.
      RETURN.

    ENDIF.

*   Check if we have negation operator
    IF lv_free_key CS '!=' OR lv_free_key CS '<>'.
      me->mo_run_environment->append_log( |Entity { iv_entity_name }, field { iv_name }: Reference error| ).
      me->mo_run_environment->append_log( |Component { iv_component_name }, negation not supported| ).
      ev_error = abap_on.
      RETURN.

    ENDIF.

*   Replace 'and' or 'or' with uppercase
    REPLACE ALL OCCURRENCES OF ' or ' IN lv_free_key WITH ' OR '.
    REPLACE ALL OCCURRENCES OF ' and ' IN lv_free_key WITH ' AND '.

*   Split by 'or' operator
    SPLIT lv_free_key AT ' OR ' INTO TABLE DATA(lt_or).

    LOOP AT lt_or ASSIGNING FIELD-SYMBOL(<fs_or>).
      CLEAR ls_free_key.

      ls_free_key-operator = 'OR'.

      IF <fs_or> NS ' AND '.
        SPLIT <fs_or> AT '=' INTO TABLE lt_pair.

        ls_free_key-component = to_upper( condense( lt_pair[ 1 ] ) ).
        REPLACE '@' IN ls_free_key-component WITH ''.
        ASSIGN lt_pair[ 2 ] TO <fs_value>.
        REPLACE ALL OCCURRENCES OF '''' IN <fs_value> WITH ''.
        <fs_value> = condense( <fs_value> ).
        lo_elemdescr ?= cl_abap_elemdescr=>describe_by_data( <fs_value> ).
        CREATE DATA lr_new_data TYPE HANDLE lo_elemdescr.
        ASSIGN lr_new_data->* TO <fs_new_value>.
        <fs_new_value> = <fs_value>.
        GET REFERENCE OF <fs_new_value> INTO ls_free_key-value_ref.

        APPEND ls_free_key TO lt_free_key.

      ELSE.
        SPLIT <fs_or> AT ' AND ' INTO TABLE DATA(lt_and).

        LOOP AT lt_and ASSIGNING FIELD-SYMBOL(<fs_and>).
          CLEAR ls_free_key.

          ls_free_key-operator = 'AND'.

          SPLIT <fs_and> AT '=' INTO TABLE lt_pair.

          ls_free_key-component = to_upper( condense( lt_pair[ 1 ] ) ).
          REPLACE '@' IN ls_free_key-component WITH ''.
          ASSIGN lt_pair[ 2 ] TO <fs_value>.
          REPLACE ALL OCCURRENCES OF '''' IN <fs_value> WITH ''.
          <fs_value> = condense( <fs_value> ).
          lo_elemdescr ?= cl_abap_elemdescr=>describe_by_data( <fs_value> ).
          CREATE DATA lr_new_data TYPE HANDLE lo_elemdescr.
          ASSIGN lr_new_data->* TO <fs_new_value>.
          <fs_new_value> = <fs_value>.
          GET REFERENCE OF <fs_new_value> INTO ls_free_key-value_ref.

          APPEND ls_free_key TO lt_free_key.

        ENDLOOP.

      ENDIF.

    ENDLOOP.

*   Actually read the data
    ASSIGN cr_data->* TO <fs_table>.
    IF sy-subrc = 0.
      lo_tabledescr ?= cl_abap_tabledescr=>describe_by_data( <fs_table> ).
      CREATE DATA lr_table TYPE HANDLE lo_tabledescr.
      ASSIGN lr_table->* TO <fs_table_f>.

      LOOP AT lt_free_key ASSIGNING <fs_free_key> WHERE operator = 'OR'.
        LOOP AT <fs_table> ASSIGNING <fs_data_ref>.
          ASSIGN <fs_data_ref>->* TO <fs_data>.
          cr_data = <fs_data_ref>.

          ASSIGN COMPONENT <fs_free_key>-component OF STRUCTURE <fs_data> TO <fs_value_ref>.
          IF sy-subrc = 0.
            IF <fs_value_ref>->* = <fs_free_key>-value_ref->*.
              APPEND <fs_data_ref> TO <fs_table_f>.

            ENDIF.

          ELSE.
            me->mo_run_environment->append_log( |Entity { iv_entity_name }, field { iv_name }: Reference error| ).
            me->mo_run_environment->append_log( |Component { iv_component_name }, attribute { <fs_free_key>-component } is invalid| ).
            ev_error = abap_on.
            RETURN.

          ENDIF.

        ENDLOOP.

      ENDLOOP.
      IF sy-subrc = 0.
        <fs_table> = <fs_table_f>.

      ENDIF.

      LOOP AT lt_free_key ASSIGNING <fs_free_key> WHERE operator = 'AND'.
        CLEAR <fs_table_f>.

        LOOP AT <fs_table> ASSIGNING <fs_data_ref>.
          ASSIGN <fs_data_ref>->* TO <fs_data>.
          cr_data = <fs_data_ref>.

          ASSIGN COMPONENT <fs_free_key>-component OF STRUCTURE <fs_data> TO <fs_value_ref>.
          IF sy-subrc = 0.
            IF <fs_value_ref>->* = <fs_free_key>-value_ref->*.
              APPEND <fs_data_ref> TO <fs_table_f>.

            ENDIF.

          ELSE.
            me->mo_run_environment->append_log( |Entity { iv_entity_name }, field { iv_name }: Reference error| ).
            me->mo_run_environment->append_log( |Component { iv_component_name }, attribute { <fs_free_key>-component } is invalid| ).
            ev_error = abap_on.
            RETURN.

          ENDIF.

        ENDLOOP.

        <fs_table> = <fs_table_f>.

      ENDLOOP.

*     Check how many lines are left
      CASE lines( <fs_table> ).
        WHEN 0.
          me->mo_run_environment->append_log( |Entity { iv_entity_name }, field { iv_name }: Reference error| ).
          me->mo_run_environment->append_log( |Component { iv_component_name }, no valid line found| ).
          ev_error = abap_on.
          RETURN.

        WHEN 1.
          READ TABLE <fs_table> ASSIGNING <fs_data_ref> INDEX 1.
          IF sy-subrc = 0.
            cr_data = <fs_data_ref>.

          ENDIF.

        WHEN OTHERS.
          me->mo_run_environment->append_log( |Entity { iv_entity_name }, field { iv_name }: Reference warning| ).
          me->mo_run_environment->append_log( |Component { iv_component_name }, { lines( <fs_table> ) } entries found, only the 1st entry is chosen| ).

          READ TABLE <fs_table> ASSIGNING <fs_data_ref> INDEX 1.
          IF sy-subrc = 0.
            cr_data = <fs_data_ref>.

          ENDIF.

      ENDCASE.

    ENDIF.

  ENDMETHOD.


  METHOD read_line_by_index.
    FIELD-SYMBOLS: <fs_table>    TYPE STANDARD TABLE,
                   <fs_data_ref> TYPE any.

    CLEAR ev_error.

    ASSIGN cr_data->* TO <fs_table>.
    IF sy-subrc = 0.
      READ TABLE <fs_table> ASSIGNING <fs_data_ref> INDEX iv_line_index.
      IF sy-subrc = 0.
        cr_data = <fs_data_ref>.

      ELSE.
        me->mo_run_environment->append_log( |Entity { iv_entity_name }, field { iv_name }: Reference error| ).
        me->mo_run_environment->append_log( |Line { iv_line_index } of internal table { iv_component_name } not found| ).
        ev_error = abap_on.
        RETURN.

      ENDIF.

    ELSE.
      me->mo_run_environment->append_log( |Entity { iv_entity_name }, field { iv_name }: Reference error| ).
      me->mo_run_environment->append_log( |Component { iv_component_name } is not a standard table| ).
      ev_error = abap_on.
      RETURN.

    ENDIF.

  ENDMETHOD.


  METHOD substring_value.
    DATA lv_fp_name TYPE string.

    CLEAR ev_error.

    CASE iv_param.
      WHEN abap_off.
        lv_fp_name = 'field'.

      WHEN abap_on.
        lv_fp_name = 'parameter'.

    ENDCASE.

*   Use offset and length if available
    IF iv_offset IS NOT INITIAL.
      TRY.
          cv_value = cv_value+iv_offset.

*         Add log
          CASE iv_reference_type.
            WHEN reference_mapping.
              me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: Reference mapping| ).

            WHEN system_variable.
              me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: System variable assignment| ).

          ENDCASE.

          CASE iv_component_name.
            WHEN mc_resultid. "Reference to document id
              me->mo_run_environment->append_log( |New %ResultID offsetted: { cv_value } !| ).

            WHEN OTHERS.
              me->mo_run_environment->append_log( |New value offsetted: { cv_value } !| ).

          ENDCASE.

        CATCH cx_sy_range_out_of_bounds.
          CASE iv_reference_type.
            WHEN reference_mapping.
              me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: Reference error| ).

            WHEN system_variable.
              me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: System variable error| ).

          ENDCASE.

          me->mo_run_environment->append_log( |Component name { iv_component_name } has wrong offset| ).
          ev_error = abap_on.
          RETURN.

      ENDTRY.

    ENDIF.

    IF iv_length IS NOT INITIAL.
      TRY.
          cv_value = cv_value(iv_length).

*         Add log
          CASE iv_reference_type.
            WHEN reference_mapping.
              me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: Reference mapping| ).

            WHEN system_variable.
              me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: System variable assignment| ).

          ENDCASE.

          CASE iv_component_name.
            WHEN mc_resultid. "Reference to document id
              me->mo_run_environment->append_log( |Referenced %ResultID trimmed with ({ iv_length }): { cv_value } !| ).

            WHEN OTHERS.
              me->mo_run_environment->append_log( |Referenced value trimmed with ({ iv_length }): { cv_value } !| ).

          ENDCASE.

        CATCH cx_sy_range_out_of_bounds.
          CASE iv_reference_type.
            WHEN reference_mapping.
              me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: Reference error| ).

            WHEN system_variable.
              me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: System variable error| ).

          ENDCASE.

          me->mo_run_environment->append_log( |Entity name { iv_component_name } has wrong length| ).
          ev_error = abap_on.
          RETURN.

      ENDTRY.

    ENDIF.

  ENDMETHOD.


  METHOD traverse_reference_nodes.
    DATA: lo_typedescr  TYPE REF TO cl_abap_typedescr,
          lv_fp_name    TYPE string,
          lv_line_index TYPE i.

    FIELD-SYMBOLS: <fs_data>      TYPE any,
                   <fs_data_ref>  TYPE any.

    CLEAR ev_error.

    CASE iv_param.
      WHEN abap_off.
        lv_fp_name = 'field'.

      WHEN abap_on.
        lv_fp_name = 'parameter'.

    ENDCASE.

    lv_line_index = iv_line_index.

    ASSIGN cr_data->* TO <fs_data>.

    ASSIGN COMPONENT iv_component_name OF STRUCTURE <fs_data> TO <fs_data_ref>.
    IF sy-subrc = 0.
      ASSIGN <fs_data_ref>->* TO <fs_data>.
      cr_data = <fs_data_ref>.

*     Check if it's a standard table
      lo_typedescr = cl_abap_typedescr=>describe_by_data( <fs_data> ).

      CASE lo_typedescr->type_kind.
        WHEN cl_abap_typedescr=>typekind_table. "itab
          IF iv_tabix = iv_lines. "lines( lt_split ).
            me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: Reference error| ).
            me->mo_run_environment->append_log( |Component { iv_component_name } is not a simple data object| ).
            ev_error = abap_on.
            RETURN.

          ENDIF.

          IF lv_line_index IS INITIAL AND iv_free_key IS INITIAL.
            lv_line_index = 1. "default to 1 the line index

          ENDIF.

          IF lv_line_index IS NOT INITIAL. "access by index
            me->read_line_by_index(
              EXPORTING
                iv_entity_name    = iv_entity_name
                iv_name           = iv_name
                iv_component_name = iv_component_name
                iv_line_index     = lv_line_index
              IMPORTING
                ev_error          = ev_error
              CHANGING
                cr_data           = cr_data
            ).
            IF ev_error = abap_on.
              RETURN.

            ENDIF.

          ELSEIF iv_free_key IS NOT INITIAL. "access by components
            me->read_line_by_access(
              EXPORTING
                iv_entity_name    = iv_entity_name
                iv_name           = iv_name
                iv_component_name = iv_component_name
                iv_free_key       = iv_free_key
              IMPORTING
                ev_error          = ev_error
              CHANGING
                cr_data           = cr_data
            ).
            IF ev_error = abap_on.
              RETURN.

            ENDIF.

          ENDIF.

        WHEN cl_abap_typedescr=>typekind_struct1
          OR cl_abap_typedescr=>typekind_struct2. "structure
          IF iv_tabix = iv_lines. "lines( lt_split ).
            me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: Reference error| ).
            me->mo_run_environment->append_log( |Component { iv_component_name } is not a simple data object| ).
            ev_error = abap_on.
            RETURN.

          ENDIF.

        WHEN OTHERS. "element
          IF lv_line_index IS NOT INITIAL OR iv_free_key IS NOT INITIAL.
            me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: Reference error| ).
            me->mo_run_environment->append_log( |Component { iv_component_name } is not a standard table| ).
            ev_error = abap_on.
            RETURN.

          ENDIF.

          IF iv_tabix = iv_lines. "lines( lt_split ).
            cv_value = <fs_data>.

*           Add log
            me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: Reference mapping| ).

            CASE iv_component_name.
              WHEN mc_resultid. "Reference to document id
                me->mo_run_environment->append_log( |Referenced ResultID: { cv_value }| ).

              WHEN OTHERS.
                me->mo_run_environment->append_log( |Referenced value: { cv_value }| ).

            ENDCASE.

            IF is_step_data-action <> 'RETRIEVE' AND is_step_data-action <> 'RETRIEVE_ALL'.
              me->mo_run_environment->append_log( 'Warning: The referenced data comes from JSON, not from RETRIEVE' ).

            ENDIF.

          ELSE.
            me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: Reference error| ).
            me->mo_run_environment->append_log( |Component { iv_component_name } is not a simple data object| ).
            ev_error = abap_on.
            RETURN.

          ENDIF.

      ENDCASE.

    ELSE.
      me->mo_run_environment->append_log( |Entity { iv_entity_name }, { lv_fp_name } { iv_name }: Reference error| ).
      me->mo_run_environment->append_log( |Component { iv_component_name } is invalid| ).
      ev_error = abap_on.
      RETURN.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
