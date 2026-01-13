class CL_PTF_HTTP_CALL definition
  public
  final
  create public .

public section.

  class-methods CALL_HTTP_CLIENT
    importing
      !IV_HOST type STRING
      !IV_REQUEST_URI type STRING
      !IV_USERNAME type STRING
      !IV_PASSWORD type STRING
      !IV_SOAPACTION type STRING
      !IV_PAYLOAD type STRING
    exporting
      !EV_STATUS_CODE type INTEGER
      !EV_STATUS_TEXT type STRING
      !EV_BODY type STRING .
  CLASS-METHODS convert_dates_in_xml
      CHANGING
        !cv_payload TYPE string .
  CLASS-METHODS convert_partner_in_xml
      CHANGING
        !cv_payload TYPE string .
protected section.
private section.
ENDCLASS.



CLASS CL_PTF_HTTP_CALL IMPLEMENTATION.


  method call_http_client.

    data: http_client type ref to if_http_client .
    data: lv_length  type i,
          lv_txt_len type string.

    clear :lv_length , lv_txt_len .
    lv_length = strlen( iv_payload ) .
    move: lv_length to lv_txt_len .

    call method cl_http_client=>create_by_url(
      exporting
        url    = iv_host
      importing
        client = http_client
    ).

    call method http_client->authenticate(
      exporting
        username = iv_username
        password = iv_password
    ).

    call method http_client->request->set_header_field
      exporting
        name  = '~request_method'
        value = 'POST'.

    call method http_client->request->set_header_field
      exporting
        name  = '~server_protocol'
        value = 'HTTP/1.1'.

    call method http_client->request->set_header_field
      exporting
        name  = '~request_uri'
        value = iv_request_uri.

    call method http_client->request->set_header_field
      exporting
        name  = 'Content-Type'
        value = 'application/soap+xml; charset=utf-8'.

    call method http_client->request->set_header_field
      exporting
        name  = 'Accept-Encoding'
        value = 'gzip,deflate'.

    call method http_client->request->set_header_field
      exporting
        name  = 'Connection'
        value = 'Keep-Alive'.

    call method http_client->request->set_header_field
      exporting
        name  = 'SOAPAction'
        value = iv_soapaction.

    call method http_client->request->set_cdata
      exporting
        data   = iv_payload
        offset = 0
        length = lv_length.

    call method http_client->send
      exceptions
        http_communication_failure = 1
        http_invalid_state         = 2.

    call method http_client->receive
      exceptions
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3.

    http_client->response->get_status(
      importing
        code   = ev_status_code
        reason = ev_status_text
    ).

  endmethod.


  METHOD convert_dates_in_xml.

    DATA: lv_payload_tmp       TYPE string,
          lv_placeholder       TYPE string,
          lv_placeholder_note  TYPE string,
          lv_date              TYPE string,
          lv_day               TYPE string,
          lv_day_offset        TYPE string,
          lv_month_offset      TYPE string,
          lv_start_date        TYPE sy-datum,
          lv_function_id       TYPE string,
          lv_function_value    TYPE string,
          lv_convert_to_tmstmp TYPE abap_boolean,
          lv_dateformat        TYPE string,
          lv_time              TYPE t,
          lv_tmstmp_l          TYPE utclong,
          lv_tmstmp_strg       TYPE string,
          lv_date_conv         TYPE d,
          lv_return            TYPE string,
          lv_days_in_month     TYPE numc2,
          lv_month             TYPE numc2,
          lv_year              TYPE numc4.

    FIELD-SYMBOLS: <lv_date_segment> TYPE string.


    DO.
      lv_payload_tmp = cv_payload.

      CLEAR: lv_dateformat,
             lv_month_offset,
             lv_day_offset,
             lv_convert_to_tmstmp.

      FIND FIRST OCCURRENCE OF '{DATE:' IN lv_payload_tmp MATCH OFFSET DATA(lv_start).
      IF sy-subrc NE 0.
        EXIT.
      ENDIF.

      SHIFT lv_payload_tmp BY lv_start PLACES.
      FIND FIRST OCCURRENCE OF '}' IN lv_payload_tmp MATCH OFFSET DATA(lv_end).

      IF sy-subrc EQ 0.
        lv_end = lv_end + 1.
        lv_placeholder_note = lv_payload_tmp(lv_end).
        lv_placeholder = lv_placeholder_note.

        REPLACE ALL OCCURRENCES OF '{' IN lv_placeholder WITH ''.
        REPLACE ALL OCCURRENCES OF '}' IN lv_placeholder WITH ''.

        SPLIT lv_placeholder AT ';' INTO TABLE DATA(lt_date_segments).
        LOOP AT lt_date_segments INTO DATA(lv_date_segment).
          CONDENSE lv_date_segment.
          SPLIT lv_date_segment AT ':' INTO TABLE DATA(lt_functions).
          READ TABLE lt_functions INTO lv_function_id INDEX 1.
          READ TABLE lt_functions INTO lv_function_value INDEX 2.
          CASE lv_function_id.
            WHEN 'DATE'.
              IF lv_function_value = 'TODAY'.
                lv_start_date = sy-datum.
              ELSE.
                lv_start_date = lv_function_value.
              ENDIF.
            WHEN 'MONTHOFFSET'.
              lv_month_offset = lv_function_value.
            WHEN 'DAY'.
              lv_day = lv_function_value.
              IF lv_day NE 'LAST'.
                IF strlen( lv_day ) = 1.
                  CONCATENATE '0' lv_day INTO lv_day.
                ELSEIF strlen( lv_day ) > 2.
                  CLEAR lv_day.
                ENDIF.
              ENDIF.
            WHEN 'DAYOFFSET'.
              lv_day_offset = lv_function_value.

            WHEN 'TMSTMP'.
              IF lv_function_value NE space.
                lv_convert_to_tmstmp = abap_true.
              ENDIF.
            WHEN 'DATEFORMAT'.
              lv_dateformat = lv_function_value.
          ENDCASE.
        ENDLOOP.

        CALL FUNCTION 'CALCULATE_DATE'
          EXPORTING
            days        = lv_day_offset
            months      = lv_month_offset
            start_date  = lv_start_date
          IMPORTING
            result_date = lv_date.

        IF lv_day NE 'LAST'.
          IF lv_day NE space.

            lv_month = lv_date+4(2).
            lv_year = lv_date(4).

*           Check if given day fits into calculated month (e.g., if day = 31 and month = 04 adjust day to last day
*           of this particular month)
            CALL FUNCTION 'NUMBER_OF_DAYS_PER_MONTH_GET'
              EXPORTING
                par_month = lv_month
                par_year  = lv_year
              IMPORTING
                par_days  = lv_days_in_month.

            IF lv_day > lv_days_in_month.
              lv_day = lv_days_in_month.
            ENDIF.
            CONCATENATE lv_date(6) lv_day INTO lv_date.
          ENDIF.
        ELSE.
          lv_month_offset = lv_month_offset + 1.
          lv_day_offset = lv_date+6(2).
          lv_day_offset = - lv_day_offset.
          CALL FUNCTION 'CALCULATE_DATE'
            EXPORTING
              days        = lv_day_offset
              months      = lv_month_offset
              start_date  = lv_start_date
            IMPORTING
              result_date = lv_date.
        ENDIF.

        IF lv_convert_to_tmstmp NE space OR lv_dateformat EQ space OR lv_dateformat = 'EXT'.
          lv_date_conv = lv_date.
          CONVERT DATE lv_date_conv TIME lv_time TIME ZONE 'UTC' INTO UTCLONG lv_tmstmp_l.
          lv_tmstmp_strg = lv_tmstmp_l.
          IF lv_convert_to_tmstmp NE space.
            lv_return = |{ lv_tmstmp_strg(10) }| && |T00:00:00.12|.
          ELSE.
            lv_return = |{ lv_tmstmp_strg(10) }|.
          ENDIF.
        ELSE.
          lv_return = lv_date.
        ENDIF.
      ELSE.
        EXIT.
      ENDIF.

      REPLACE ALL OCCURRENCES OF lv_placeholder_note IN cv_payload WITH lv_return.

    ENDDO.


  ENDMETHOD.


   METHOD convert_partner_in_xml.

    DATA: lo_ixml           TYPE REF TO cl_ixml,
          lo_stream_factory TYPE REF TO if_ixml_stream_factory,
          lo_document       TYPE REF TO if_ixml_document,
          lo_iterator       TYPE REF TO if_ixml_node_iterator,
          lo_node           TYPE REF TO if_ixml_node,
          lo_node_iterator  TYPE REF TO if_ixml_node_iterator,
          lo_child_node     TYPE REF TO if_ixml_node,
          lo_istream        TYPE REF TO if_ixml_istream,
          lo_ostream        TYPE REF TO if_ixml_ostream,
          lo_parser         TYPE REF TO if_ixml_parser,
          lv_node_type      TYPE i,
          lv_node_name      TYPE string,
          lv_node_value     TYPE string,
          lv_ostream        TYPE xstring,
          lv_off            TYPE i,
          lv_len            TYPE i.


    lo_ixml ?= cl_ixml=>create( ).
    lo_stream_factory ?= lo_ixml->if_ixml~create_stream_factory( ).
    lo_document ?= lo_ixml->if_ixml~create_document( ).
    lo_istream ?= lo_stream_factory->create_istream_string( string = cv_payload  ).

    lo_parser = lo_ixml->if_ixml~create_parser( document       = lo_document
                                                istream        = lo_istream
                                                stream_factory = lo_stream_factory ).
    IF lo_parser->parse( ) <> 0.
      RETURN.
    ENDIF.
    lo_iterator ?= lo_document->create_iterator( ).

    DO.
      lo_node ?= lo_iterator->get_next( ).
      IF lo_node IS INITIAL.
        EXIT.
      ENDIF.
      lv_node_type  =  lo_node->get_type( ).
      lv_node_name  =  |{ lo_node->get_name( ) CASE = UPPER }|.
      lv_node_value =  lo_node->get_value( ).

      IF ( lv_node_name = 'PERSONRESPONSIBLE'
        OR lv_node_name = 'EXECUTINGSERVICEEMPLOYEE' )
        AND lv_node_value IS NOT INITIAL.

*       Consider subnodes of PERSONRESPONSIBLE (table-like with action code in start-tag) -> multiple
*       occurences of names 'PERSONRESPONSIBLE' exist, XML-conversion removes PERSONRESPONSIBLE open-
*       and closing-tags if value of parent-node is changed
        IF lv_node_name = 'PERSONRESPONSIBLE'.
          lo_node_iterator ?= lo_node->create_iterator( ).
          DO.
            lo_node ?= lo_node_iterator->get_next( ).
            IF lo_node IS INITIAL.
              lo_node = lo_child_node.
              EXIT.
            ENDIF.
            lo_child_node = lo_node.
          ENDDO.
        ENDIF.

        lv_off = strlen( lv_node_value ) - 1.
        lv_len = lv_off - 1.
        IF lv_node_value(1) = '{' AND lv_node_value+lv_off = '}'.
          DATA(lv_idnumber) = lv_node_value+1(lv_len).
          SELECT SINGLE partner FROM but0id INTO @DATA(lv_partner_no)
            WHERE idnumber = @lv_idnumber.
          IF sy-subrc = 0.
            lv_node_value = lv_partner_no.
            lo_node->set_value( lv_node_value ).
            DATA(lv_changed) = abap_true.
          ENDIF.
        ENDIF.
      ENDIF.


      IF lv_node_name = 'RESPYMGMTSERVICETEAM'.
        lv_off = strlen( lv_node_value ) - 1.
        lv_len = lv_off - 1.
        IF lv_node_value(1) = '{' AND lv_node_value+lv_off = '}'.
          DATA(lv_team_name) = lv_node_value+1(lv_len).
          SELECT SINGLE objid INTO  @DATA(lv_team_id) FROM hrp1000
                              WHERE stext = @lv_team_name.

          IF sy-subrc = 0.
            lv_node_value = lv_team_id.
            lo_node->set_value( lv_node_value ).
            lv_changed = abap_true.
          ENDIF.
        ENDIF.
      ENDIF.

      IF lv_node_name = 'REFSERVICEORDERTEMPLATE'.
        lv_off = strlen( lv_node_value ) - 1.
        lv_len = lv_off - 1.
        IF lv_node_value(1) = '{' AND lv_node_value+lv_off = '}'.
          DATA(lv_template_description) = lv_node_value+1(lv_len).
          SELECT SINGLE object_id INTO @DATA(lv_template_id) FROM crms4d_serv_h
                                  WHERE description_h = @lv_template_description.

          IF sy-subrc = 0.
            lv_node_value = lv_template_id.
            lo_node->set_value( lv_node_value ).
            lv_changed = abap_true.
          ENDIF.
        ENDIF.
      ENDIF.

    ENDDO.

    IF lv_changed = abap_true.
      lo_ostream ?=  lo_stream_factory->create_ostream_xstring( lv_ostream ) .
      lo_document->render( ostream = lo_ostream  ).

      CALL FUNCTION 'ECATT_CONV_XSTRING_TO_STRING'
        EXPORTING
          im_xstring = lv_ostream
        IMPORTING
          ex_string  = cv_payload.
    ENDIF.


  ENDMETHOD.
ENDCLASS.
