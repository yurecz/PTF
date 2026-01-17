CLASS cl_ptf_rap_modify_formatter DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS format_json
      IMPORTING
        iv_entity TYPE abp_entity_name
      CHANGING
        cv_json   TYPE string .

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-METHODS pretty_print_json
      CHANGING
        cv_json TYPE string.
ENDCLASS.



CLASS cl_ptf_rap_modify_formatter IMPLEMENTATION.


  METHOD format_json.
*   Pretty printer for MODIFY action JSON format
*   MODIFY uses EML operations array: [{"op":"CREATE","entity":"...","instances":[...]}]
*   Uses /ui2/cl_json for formatting with entity/action/field name replacements
    DATA: lr_data             TYPE REF TO data,
          lt_entities_in_json TYPE STANDARD TABLE OF abp_entity_name,
          lv_entity_name      TYPE abp_entity_name.

*   Load entity metadata to replace internal names with external names
    cl_abap_behv_load=>get_load(
      EXPORTING
        entity   = iv_entity
        all      = abap_on
      IMPORTING
        entities = DATA(lt_entities)
        actions  = DATA(lt_actions) ).

*   Pretty print JSON while preserving field order
    pretty_print_json( CHANGING cv_json = cv_json ).

*   Replace internal entity names with external names in formatted JSON
*   Track which entities exist in the JSON for field replacement
    LOOP AT lt_entities ASSIGNING FIELD-SYMBOL(<fs_entity>).
      IF cv_json CS to_upper( <fs_entity>-name ).
        cv_json = replace( val = cv_json pcre = to_upper( <fs_entity>-name ) with = <fs_entity>-ext_name case = abap_false occ = 0 ).
        APPEND <fs_entity>-name TO lt_entities_in_json.
      ENDIF.
    ENDLOOP.

*   Replace internal action names with external names
    LOOP AT lt_actions ASSIGNING FIELD-SYMBOL(<fs_action>).
      cv_json = replace( val = cv_json pcre = to_upper( <fs_action>-name ) with = <fs_action>-ext_name case = abap_false occ = 0 ).
    ENDLOOP.

*   Replace internal field names with external names from CDS view definitions
*   Query DD03ND table directly to get field name mappings (internal vs external)
    LOOP AT lt_entities_in_json INTO lv_entity_name.

      DATA lt_fields TYPE STANDARD TABLE OF dd03nd.
      SELECT strucobjn, fieldname, fieldname_raw
        FROM dd03nd
        WHERE strucobjn = @lv_entity_name
          AND as4local = 'A'
          AND fieldname_raw IS NOT INITIAL
        INTO TABLE @DATA(cds_fields).

*     Replace each field: internal name (fieldname) -> external name (fieldname_raw)
*     Use case-insensitive regex (?i) to match PRODUCTTEXT, ProductTEXT, etc.
      LOOP AT cds_fields ASSIGNING FIELD-SYMBOL(<cds_field>).
        DATA(lv_pattern) = |(?i){ <cds_field>-fieldname }|.
        cv_json = replace( val = cv_json pcre = lv_pattern with = <cds_field>-fieldname_raw occ = 0 ).
      ENDLOOP.
      CLEAR lt_fields.
    ENDLOOP.

  ENDMETHOD.


  METHOD pretty_print_json.
*   Pretty print JSON while preserving field order and string content
*   Parse character by character, add indentation without deserialize/serialize
    DATA: lv_result TYPE string,
          lv_indent TYPE i VALUE 0,
          lv_char   TYPE c LENGTH 1,
          lv_next_char TYPE c LENGTH 1,
          lv_need_indent TYPE abap_bool VALUE abap_false,
          lv_in_string TYPE abap_bool VALUE abap_false,
          lv_escape TYPE abap_bool VALUE abap_false,
          lv_newline TYPE string,
          lv_len    TYPE i,
          lv_i      TYPE i,
          lv_j      TYPE i.

*   Normalize input by removing real line breaks (JSON strings should not contain literal newlines)
    REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf IN cv_json WITH ''.
    REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>newline IN cv_json WITH ''.

    lv_newline = cl_abap_char_utilities=>newline.
    lv_len = strlen( cv_json ).
    
    DO lv_len TIMES.
      lv_i = sy-index - 1.
      lv_char = cv_json+lv_i(1).

*     Handle escape sequences in strings only
      IF lv_in_string = abap_true AND lv_escape = abap_true.
        lv_result = lv_result && lv_char.
        lv_escape = abap_false.
        CONTINUE.
      ENDIF.

      IF lv_in_string = abap_true AND lv_char = '\'.
        lv_result = lv_result && lv_char.
        lv_escape = abap_true.
        CONTINUE.
      ENDIF.

*     Track string boundaries
      IF lv_char = '"'.
*       Add pending indentation before string
        IF lv_need_indent = abap_true.
          DO lv_indent TIMES.
            lv_result = lv_result && | |.
          ENDDO.
          lv_need_indent = abap_false.
        ENDIF.
        lv_result = lv_result && lv_char.
*       Toggle string state
        IF lv_in_string = abap_true.
          lv_in_string = abap_false.
        ELSE.
          lv_in_string = abap_true.
        ENDIF.
        CONTINUE.
      ENDIF.

*     Inside strings, preserve everything as-is (including spaces)
      IF lv_in_string = abap_true.
        lv_result = |{ lv_result }{ lv_char WIDTH = 1 }|.
        CONTINUE.
      ENDIF.

*     Skip whitespace outside strings
      IF lv_char CA ` \t\n\r`.
        CONTINUE.
      ENDIF.

*     Lookahead to next non-whitespace character
      CLEAR lv_next_char.
      lv_j = lv_i + 1.
      WHILE lv_j < lv_len.
        lv_next_char = cv_json+lv_j(1).
        IF lv_next_char NA ` \t\n\r`.
          EXIT.
        ENDIF.
        lv_j = lv_j + 1.
      ENDWHILE.

*     Handle structural characters
      CASE lv_char.
        WHEN '{' OR '['.
*         Add pending indentation before bracket
          IF lv_need_indent = abap_true.
            DO lv_indent TIMES.
              lv_result = lv_result && | |.
            ENDDO.
            lv_need_indent = abap_false.
          ENDIF.
          lv_result = lv_result && lv_char.
          IF lv_next_char <> '}' AND lv_next_char <> ']'.
            lv_result = lv_result && lv_newline.
            lv_indent = lv_indent + 2.
            lv_need_indent = abap_true.
          ENDIF.

        WHEN '}' OR ']'.
*         Check if we need to outdent (not for empty {}/[])
          IF strlen( lv_result ) > 0.
            DATA(lv_last) = substring( val = lv_result off = strlen( lv_result ) - 1 len = 1 ).
            IF lv_last <> '{' AND lv_last <> '['.
              lv_result = lv_result && lv_newline.
              lv_indent = lv_indent - 2.
              lv_need_indent = abap_true.
            ENDIF.
          ENDIF.
*         Add pending indentation before closing bracket
          IF lv_need_indent = abap_true.
            DO lv_indent TIMES.
              lv_result = lv_result && | |.
            ENDDO.
            lv_need_indent = abap_false.
          ENDIF.
          lv_result = lv_result && lv_char.

        WHEN ','.
          lv_result = lv_result && lv_char && lv_newline.
          lv_need_indent = abap_true.

        WHEN ':'.
          lv_result = lv_result && lv_char && | |.

        WHEN OTHERS.
*         Add pending indentation before other characters
          IF lv_need_indent = abap_true.
            DO lv_indent TIMES.
              lv_result = lv_result && | |.
            ENDDO.
            lv_need_indent = abap_false.
          ENDIF.
          lv_result = lv_result && lv_char.
      ENDCASE.
    ENDDO.

    cv_json = lv_result.
  ENDMETHOD.
ENDCLASS.
