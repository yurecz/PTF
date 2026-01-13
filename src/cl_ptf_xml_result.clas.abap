CLASS cl_ptf_xml_result DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS: get_xml_result
      IMPORTING step_data         TYPE cl_ptf_util=>gt_ptf_step_tab
      RETURNING VALUE(xml_string) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-METHODS: concetanate
      IMPORTING string1       TYPE string
                string2       TYPE string
      RETURNING VALUE(result) TYPE string.

    CLASS-METHODS replace_not_allowed_chars
      IMPORTING string        TYPE string
      RETURNING VALUE(result) TYPE string.
ENDCLASS.



CLASS CL_PTF_XML_RESULT IMPLEMENTATION.


  METHOD concetanate.
    CONCATENATE string1 string2 INTO result.
  ENDMETHOD.


  METHOD get_xml_result.
    xml_string = |<ptfExecutionResult>|.

    LOOP AT step_data ASSIGNING FIELD-SYMBOL(<step_data>).
      IF <step_data>-bus_obj IS INITIAL AND
         <step_data>-action IS INITIAL.
        EXIT.
      ENDIF.
      xml_string = concetanate(
               string1 = xml_string
               string2 = '<stepResult>'
             ).

      xml_string = concetanate(
        string1 = xml_string
        string2 = |<stepNumber>{ <step_data>-step_number }</stepNumber>|
      ).

      xml_string = concetanate(
               string1 = xml_string
               string2 = '<log>'
      ).
      LOOP AT <step_data>-log ASSIGNING FIELD-SYMBOL(<log>).
        xml_string = concetanate(
          string1 = xml_string
          string2 = |<logEntry>{ cl_ptf_xml_result=>replace_not_allowed_chars( string = |{ <log>-message }| ) }</logEntry>|
        ).
      ENDLOOP.
      xml_string = concetanate(
         string1 = xml_string
         string2 = '</log>'
      ).


      xml_string = concetanate(
         string1 = xml_string
         string2 = '<results>'
      ).
      LOOP AT <step_data>-document_id ASSIGNING FIELD-SYMBOL(<result>).
        xml_string = concetanate(
          string1 = xml_string
          string2 = |<stepResult>{ <result>-vbeln }</stepResult>|
        ).
      ENDLOOP.
      xml_string = concetanate(
         string1 = xml_string
         string2 = '</results>'
      ).


      xml_string = concetanate(
           string1 = xml_string
           string2 = '</stepResult>'
      ).
    ENDLOOP.

    xml_string = concetanate(
                   string1 = xml_string
                   string2 = '</ptfExecutionResult>'
                 ).
  ENDMETHOD.


  METHOD replace_not_allowed_chars.
    "First solution: Just delete them
    "If that causes problems --> escape them https://stackoverflow.com/questions/730133/invalid-characters-in-xml
    result = string.
    REPLACE ALL OCCURRENCES OF '<' IN result WITH ''.
    REPLACE ALL OCCURRENCES OF '>' IN result WITH ''.
    REPLACE ALL OCCURRENCES OF '&' IN result WITH ''.
    REPLACE ALL OCCURRENCES OF '"' IN result WITH ''.
    REPLACE ALL OCCURRENCES OF |'| IN result WITH ''.
  ENDMETHOD.
ENDCLASS.
