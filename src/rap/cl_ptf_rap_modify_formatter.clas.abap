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
ENDCLASS.



CLASS cl_ptf_rap_modify_formatter IMPLEMENTATION.


  METHOD format_json.
*   Pretty printer for MODIFY action JSON format
*   MODIFY uses EML operations array: [{"op":"CREATE","entity":"...","instances":[...]}]
*   This is different from traditional PTF JSON with fields/associations structure
    DATA: lv_json            TYPE string,
          lv_indent          TYPE i VALUE 0,
          lv_char            TYPE c LENGTH 1,
          lv_prev_char       TYPE c LENGTH 1,
          lv_next_char       TYPE c LENGTH 1,
          lv_in_string       TYPE abap_bool VALUE abap_false,
          lv_escape          TYPE abap_bool VALUE abap_false.

    CONSTANTS: lc_tab    TYPE string VALUE '  ',
               lc_newline TYPE c LENGTH 1 VALUE cl_abap_char_utilities=>newline.

    lv_json = cv_json.

*   Load entity metadata to replace internal names with external names
    cl_abap_behv_load=>get_load(
      EXPORTING
        entity   = iv_entity
        all      = abap_on
      IMPORTING
        entities = DATA(lt_entities)
        actions  = DATA(lt_actions) ).

*   Replace internal entity names with external names in JSON
    LOOP AT lt_entities ASSIGNING FIELD-SYMBOL(<fs_entity>).
      lv_json = replace( val = lv_json pcre = <fs_entity>-name with = <fs_entity>-ext_name case = abap_false occ = 0 ).
    ENDLOOP.

*   Replace internal action names with external names
    LOOP AT lt_actions ASSIGNING FIELD-SYMBOL(<fs_action>).
      lv_json = replace( val = lv_json pcre = <fs_action>-name with = <fs_action>-ext_name case = abap_false occ = 0 ).
    ENDLOOP.

*   Remove all existing whitespace
    lv_json = replace( val = lv_json sub = cl_abap_char_utilities=>cr_lf with = '' occ = 0 ).
    lv_json = replace( val = lv_json sub = cl_abap_char_utilities=>newline with = '' occ = 0 ).
    lv_json = replace( val = lv_json sub = cl_abap_char_utilities=>horizontal_tab with = '' occ = 0 ).
    lv_json = replace( val = lv_json pcre = '(?<=\,|\"|\{|\[|\]|\}|\:)\s+(?=|\"|\{|\[|\]|\}|\:)' with = '' occ = 0 ).

*   Build formatted output character by character
    DATA(lv_output) = ||.
    DATA(lv_len) = strlen( lv_json ).

    DO lv_len TIMES.
      DATA(lv_pos) = sy-index - 1.
      lv_char = lv_json+lv_pos(1).

*     Get previous and next characters
      IF lv_pos > 0.
        lv_prev_char = lv_json+0(lv_pos).
        lv_prev_char = substring( val = lv_prev_char off = strlen( lv_prev_char ) - 1 len = 1 ).
      ELSE.
        CLEAR lv_prev_char.
      ENDIF.

      IF lv_pos < lv_len - 1.
        lv_next_char = lv_json+lv_pos(2).
        lv_next_char = substring( val = lv_next_char off = 1 len = 1 ).
      ELSE.
        CLEAR lv_next_char.
      ENDIF.

*     Track string context (don't format inside quoted strings)
      IF lv_char = '"' AND lv_escape = abap_false.
        lv_in_string = xsym( lv_in_string ).
      ENDIF.

      IF lv_char = '\'.
        lv_escape = xsym( lv_escape ).
      ELSEIF lv_escape = abap_on.
        lv_escape = abap_off.
      ENDIF.

*     Apply formatting rules (only outside strings)
      IF lv_in_string = abap_false.
        CASE lv_char.
          WHEN '['.
            lv_indent = lv_indent + 1.
            lv_output = |{ lv_output }[{ lc_newline }{ repeat( val = lc_tab occ = lv_indent ) }|.

          WHEN ']'.
            lv_indent = lv_indent - 1.
            lv_output = |{ lv_output }{ lc_newline }{ repeat( val = lc_tab occ = lv_indent ) }]|.

          WHEN '{'.
            lv_indent = lv_indent + 1.
            lv_output = |{ lv_output }\{{ lc_newline }{ repeat( val = lc_tab occ = lv_indent ) }|.

          WHEN '}'.
            lv_indent = lv_indent - 1.
            lv_output = |{ lv_output }{ lc_newline }{ repeat( val = lc_tab occ = lv_indent ) }\}|.

          WHEN ','.
            lv_output = |{ lv_output },{ lc_newline }{ repeat( val = lc_tab occ = lv_indent ) }|.

          WHEN ':'.
            lv_output = |{ lv_output }: |.

          WHEN OTHERS.
*           Skip standalone spaces (already handled by context)
            IF lv_char <> ' ' OR lv_prev_char <> ':'.
              lv_output = |{ lv_output }{ lv_char }|.
            ENDIF.
        ENDCASE.
      ELSE.
*       Inside string - preserve as-is
        lv_output = |{ lv_output }{ lv_char }|.
      ENDIF.
    ENDDO.

    cv_json = lv_output.

  ENDMETHOD.
ENDCLASS.
