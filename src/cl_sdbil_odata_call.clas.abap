class CL_SDBIL_ODATA_CALL definition
  public
  final
  create private .

public section.

  types:
    BEGIN OF t_requestline,
        method             TYPE string,
        request            TYPE string,
        accept             TYPE string,
        action_entity      TYPE string,
        is_function_import TYPE abap_bool,
        association        TYPE string,
        etag               TYPE string,
        parameters_t       TYPE /iwfnd/sutil_property_t,
      END OF t_requestline .
  types:
    tt_request TYPE STANDARD TABLE OF t_requestline WITH EMPTY KEY .

  class-methods GET_INSTANCE
    importing
      !IV_SERVICE_URL type STRING optional
    returning
      value(RO_INSTANCE) type ref to CL_SDBIL_ODATA_CALL .
  methods CALL_SERVICE
    importing
      !IV_METHOD type STRING default 'GET'
      !IV_URL type STRING optional
      !IV_SERVICE_URL type STRING optional
      !IV_REQUEST type STRING optional
      !IV_ACCEPT type STRING default 'application/json'
      !IV_ACTION_OR_ENTITY type STRING optional
      !IT_PARAMETERS type /IWFND/SUTIL_PROPERTY_T optional
      !IV_CONTENT_TYPE type STRING optional
      !IV_FUNCTION_IMPORT type ABAP_BOOL default ABAP_FALSE
      !IV_ASSOCIATION type STRING optional
      !IV_ETAG type STRING optional
      !IV_PAYLOAD type STRING optional
      !IV_FILTER_ONLY type ABAP_BOOL default ABAP_FALSE
    exporting
      !EV_STATUS_CODE type INTEGER
      !EV_STATUS_TEXT type STRING
      !EV_BODY type XSTRING
      !ES_JSON_RESPONSE type ANY .
  methods CONVERT_JSON_DATE
    importing
      !IV_JSON_DATE type STRING
    returning
      value(RV_DATE) type D .
  methods CALL_SERVICE_BATCH
    importing
      !IV_SERVICE_URL type STRING optional
      !IT_REQUESTS type TT_REQUEST
    exporting
      !EV_STATUS_CODE type INTEGER
      !EV_STATUS_TEXT type STRING
      !EV_BODY type XSTRING
      !ES_JSON_RESPONSE type ANY .
protected section.
private section.

  class-data MO_INSTANCE type ref to CL_SDBIL_ODATA_CALL .
  data MV_SERVICE_URL type STRING .
ENDCLASS.



CLASS CL_SDBIL_ODATA_CALL IMPLEMENTATION.


  METHOD call_service.
    DATA: lv_service_url TYPE string.
    DATA: lv_url TYPE string.
    DATA: lt_request_header  TYPE /iwfnd/sutil_property_t,
          lt_response_header TYPE /iwfnd/sutil_property_t,
          lo_client_proxy    TYPE REF TO /iwfnd/cl_sutil_client_proxy.
    DATA: ls_request_header TYPE /iwfnd/sutil_property.
    DATA: lv_csrf_token      TYPE string,
          lv_function_import TYPE abap_bool.
    DATA: lv_body TYPE xstring.

    lv_function_import = iv_function_import.
    IF iv_method EQ /iwcor/if_rest_request=>gc_method_post.
      lv_function_import = abap_true.
    ENDIF.
    IF iv_service_url IS INITIAL.
      IF mv_service_url IS NOT INITIAL.
        lv_service_url = mv_service_url.
      ELSEIF iv_url IS NOT INITIAL.
*       Parse service root from full url

      ENDIF.
    ELSE.
      lv_service_url = iv_service_url.
    ENDIF.
    DATA(lv_len) = strlen( lv_service_url ) - 1.
    IF lv_service_url+lv_len(1) <> '/'.
      lv_service_url = lv_service_url && '/'.
    ENDIF.
    IF iv_url IS NOT INITIAL.
      lv_url = iv_url.
    ELSEIF lv_service_url IS NOT INITIAL AND iv_action_or_entity IS NOT INITIAL.
      lv_url = lv_service_url && iv_action_or_entity.
      IF iv_filter_only = abap_false.
        IF lv_function_import = abap_false.
          IF it_parameters IS NOT INITIAL.
            lv_url = lv_url && |(|.
            IF lines( it_parameters ) = 1.
              READ TABLE it_parameters ASSIGNING FIELD-SYMBOL(<ls_param>) INDEX 1.
              IF <ls_param> IS ASSIGNED.
                lv_url = lv_url && |'{ <ls_param>-value }'|.
              ENDIF.
            ELSE.
              LOOP AT it_parameters ASSIGNING <ls_param>.
                IF sy-tabix > 1.
                  lv_url = lv_url && |,{ <ls_param>-name }='{ <ls_param>-value }'|.
                ELSE.
                  lv_url = lv_url && |{ <ls_param>-name }='{ <ls_param>-value }'|.
                ENDIF.
              ENDLOOP.
            ENDIF.
            lv_url = lv_url && |)|.
            IF iv_association IS NOT INITIAL.
              lv_url = lv_url && |/{ iv_association }|.
            ENDIF.
          ENDIF.
        ELSE.
          LOOP AT it_parameters ASSIGNING <ls_param>.
            IF sy-tabix > 1.
              lv_url = lv_url && |&{ <ls_param>-name }='{ <ls_param>-value }'|.
            ELSE.
              lv_url = lv_url && |?{ <ls_param>-name }='{ <ls_param>-value }'|.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ELSE.
        lv_url = lv_url && |?$filter=(|.
        LOOP AT it_parameters ASSIGNING <ls_param>.
          IF sy-tabix > 1.
            lv_url = lv_url && |%20and%20|.
          ENDIF.
          IF strlen( <ls_param>-value ) = 10 AND <ls_param>-value CP '++++-++-++'.
            lv_url = lv_url && |{ <ls_param>-name }%20eq%20datetime%27{ <ls_param>-value }T00%3a00%3a00%27|.
          ELSE.
            lv_url = lv_url && |{ <ls_param>-name }%20eq%20%27{ <ls_param>-value }%27|.
          ENDIF.
        ENDLOOP.
        lv_url = lv_url && |)|.
      ENDIF.
    ELSE.
*    Error - no data to display
    ENDIF.

    lo_client_proxy     = /iwfnd/cl_sutil_client_proxy=>get_instance( ).

    CASE iv_method.
      WHEN /iwcor/if_rest_request=>gc_method_get OR
           /iwcor/if_rest_request=>gc_method_head OR
           /iwcor/if_rest_request=>gc_method_options.
      WHEN OTHERS.
*     Get CSRF token
        lt_request_header = VALUE #(
          ( name = /iwcor/if_rest_request=>gc_header_csrf_token value = 'Fetch' )
          ( name = if_http_header_fields_sap=>request_method    value = 'HEAD' )
          ( name = if_http_header_fields_sap=>request_uri       value =  lv_service_url )
        ).


        lo_client_proxy->web_request(
          EXPORTING
            it_request_header   = lt_request_header
          IMPORTING
            ev_status_code      = ev_status_code
            et_response_header  = lt_response_header
        ).
        CLEAR lv_csrf_token.
        LOOP AT lt_response_header ASSIGNING FIELD-SYMBOL(<ls_response_header>).
          IF to_upper( <ls_response_header>-name ) = to_upper( /iwcor/if_rest_request=>gc_header_csrf_token ).
            lv_csrf_token = <ls_response_header>-value.
            EXIT.
          ENDIF.
        ENDLOOP.
    ENDCASE.


*    CLEAR lt_request_header.
    lt_request_header = VALUE #(
      ( name = if_http_header_fields_sap=>request_method value = iv_method )
      ( name = if_http_header_fields_sap=>request_uri    value = lv_url )
    ).

    IF lv_csrf_token IS NOT INITIAL.
      APPEND VALUE #( name = /iwcor/if_rest_request=>gc_header_csrf_token value = lv_csrf_token ) TO lt_request_header.
    ENDIF.

    IF iv_accept <> ''.
      APPEND VALUE #( name = 'Accept' value = iv_accept ) TO lt_request_header.
    ENDIF.

    IF iv_content_type <> ''.
      APPEND VALUE #( name = 'Content-Type' value = iv_content_type ) TO lt_request_header.
    ENDIF.

    IF iv_etag IS NOT INITIAL.
      APPEND VALUE #( name = 'if-match' value = iv_etag ) TO lt_request_header.
    ENDIF.

    IF iv_payload IS NOT INITIAL.
      CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
        EXPORTING
          text   = iv_payload
*         MIMETYPE       = ' '
*         ENCODING       =
        IMPORTING
          buffer = lv_body
        EXCEPTIONS
          failed = 1
          OTHERS = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
      IF iv_content_type = ''.
        APPEND VALUE #( name = 'Content-Type' value = 'application/json' ) TO lt_request_header.
      ENDIF.
    ENDIF.

    lo_client_proxy->web_request(
    EXPORTING
      it_request_header   = lt_request_header
      iv_request_body     = lv_body
    IMPORTING
      ev_status_code      = ev_status_code
      ev_status_text      = ev_status_text
*    ev_content_type     = lv_content_type
      ev_response_body    = ev_body
*    ev_error_text       = lv_error_text
  ).

    IF es_json_response IS REQUESTED.
      CALL METHOD /ui2/cl_json=>deserialize
        EXPORTING
          jsonx = ev_body
*         assoc_arrays_opt = abap_true
        CHANGING
          data  = es_json_response.
    ENDIF.

    IF lv_function_import = abap_true. "POST request
      "Wait 5 seconds due to asynchronous commitment
      WAIT UP TO 5 SECONDS.
    ENDIF.

  ENDMETHOD.


  METHOD call_service_batch.
    DATA: lv_service_url      TYPE string.
    DATA: lv_url          TYPE string,
          lv_internal_url TYPE string.
    DATA: lt_request_header  TYPE /iwfnd/sutil_property_t,
          lt_response_header TYPE /iwfnd/sutil_property_t,
          lo_client_proxy    TYPE REF TO /iwfnd/cl_sutil_client_proxy.
    DATA: ls_request_header TYPE /iwfnd/sutil_property,
          lv_request_body   TYPE xstring,
          lv_body_str       TYPE string.
    DATA: lv_csrf_token      TYPE string,
          lv_function_import TYPE abap_bool.
    DATA: lv_len              TYPE i,
          lv_changeset_needed TYPE abap_bool.



*    lv_function_import = iv_function_import.
*    IF iv_method EQ /iwcor/if_rest_request=>gc_method_post.
*      lv_function_import = abap_true.
*    ENDIF.
    IF iv_service_url IS INITIAL.
      IF mv_service_url IS NOT INITIAL.
        lv_service_url = mv_service_url.
      ENDIF.
    ELSE.
      lv_service_url = iv_service_url.
    ENDIF.
    lv_len = strlen( lv_service_url ) - 1.
    IF lv_service_url+lv_len(1) = '/'.
      lv_url = lv_service_url && |$batch|.
    ELSE.
      lv_url = lv_service_url && |/$batch|.
    ENDIF.

    lo_client_proxy     = /iwfnd/cl_sutil_client_proxy=>get_instance( ).
*
*   Prepare header
*   Get CSRF token
    lt_request_header = VALUE #(
      ( name = /iwcor/if_rest_request=>gc_header_csrf_token value = 'Fetch' )
      ( name = if_http_header_fields_sap=>request_method    value = 'HEAD' )
      ( name = if_http_header_fields_sap=>request_uri       value =  lv_service_url )
    ).


    lo_client_proxy->web_request(
      EXPORTING
        it_request_header   = lt_request_header
      IMPORTING
        ev_status_code      = ev_status_code
        et_response_header  = lt_response_header
    ).
    CLEAR lv_csrf_token.
    LOOP AT lt_response_header ASSIGNING FIELD-SYMBOL(<ls_response_header>).
      IF to_upper( <ls_response_header>-name ) = to_upper( /iwcor/if_rest_request=>gc_header_csrf_token ).
        lv_csrf_token = <ls_response_header>-value.
        EXIT.
      ENDIF.
    ENDLOOP.
*
*
*    CLEAR lt_request_header.
    lt_request_header = VALUE #(
      ( name = if_http_header_fields_sap=>request_method value = /iwcor/if_rest_request=>gc_method_post )
      ( name = if_http_header_fields_sap=>request_uri    value = lv_url )
    ).



    APPEND VALUE #( name = 'Accept' value = |application/json| ) TO lt_request_header.
    APPEND VALUE #( name = 'Content-Type' value = |multipart/mixed; boundary=batch| ) TO lt_request_header.

*   Prepare body
*   Check if changeset is needed
    lv_changeset_needed = abap_false.
    LOOP AT it_requests ASSIGNING FIELD-SYMBOL(<ls_request>).
      IF <ls_request>-method IS NOT INITIAL AND <ls_request>-method <> /iwcor/if_rest_request=>gc_method_get.
        lv_changeset_needed = abap_true.
      ENDIF.
    ENDLOOP.
    IF lv_changeset_needed = abap_true.
      lv_body_str = |--batch\nContent-Type: multipart/mixed; boundary=changeset\n\n|.
    ENDIF.
    LOOP AT it_requests ASSIGNING <ls_request>.
      IF lv_changeset_needed = abap_false.
        lv_body_str = lv_body_str && |--batch\nContent-Type: application/http\nContent-Transfer-Encoding: binary\n\n|.
      ELSE.
        lv_body_str = lv_body_str && |--changeset\n\nContent-Type: application/http\nContent-Transfer-Encoding: binary\n\n\n|.
      ENDIF.
      IF <ls_request>-method IS INITIAL.
        lv_body_str = lv_body_str && |GET |.
      ELSE.
        lv_body_str = lv_body_str && <ls_request>-method.
      ENDIF.
      lv_body_str = lv_body_str && <ls_request>-action_entity.

      IF <ls_request>-is_function_import = abap_false.
        IF <ls_request>-parameters_t IS NOT INITIAL.
          lv_body_str = lv_body_str && |(|.
          IF lines( <ls_request>-parameters_t ) = 1.
            READ TABLE <ls_request>-parameters_t ASSIGNING FIELD-SYMBOL(<ls_param>) INDEX 1.
            IF <ls_param> IS ASSIGNED.
              lv_body_str = lv_body_str && |'{ <ls_param>-value }'|.
            ENDIF.
          ELSE.
            LOOP AT <ls_request>-parameters_t ASSIGNING <ls_param>.
              IF sy-tabix > 1.
                lv_body_str = lv_body_str && |,{ <ls_param>-name }='{ <ls_param>-value }'|.
              ELSE.
                lv_body_str = lv_body_str && |{ <ls_param>-name }='{ <ls_param>-value }'|.
              ENDIF.
            ENDLOOP.
          ENDIF.
          lv_body_str = lv_body_str && |)|.
          IF <ls_request>-association IS NOT INITIAL.
            lv_body_str = lv_body_str && |/{ <ls_request>-association }|.
          ENDIF.
        ENDIF.
      ELSE.
        LOOP AT <ls_request>-parameters_t ASSIGNING <ls_param>.
          IF sy-tabix > 1.
            lv_body_str = lv_body_str && |&{ <ls_param>-name }='{ <ls_param>-value }'|.
          ELSE.
            lv_body_str = lv_body_str && |?{ <ls_param>-name }='{ <ls_param>-value }'|.
          ENDIF.
        ENDLOOP.
      ENDIF.
      lv_body_str = lv_body_str && | HTTP/1.1| && cl_abap_char_utilities=>newline.
      IF <ls_request>-accept IS NOT INITIAL.
        lv_body_str = lv_body_str && |Accept: { <ls_request>-accept }| &&  cl_abap_char_utilities=>newline..
      ELSE.
        lv_body_str = lv_body_str && |Accept: application/json| && cl_abap_char_utilities=>newline.
      ENDIF.
      IF lv_csrf_token IS NOT INITIAL.
        lv_body_str = lv_body_str && |x-csrf-token: { lv_csrf_token }| && cl_abap_char_utilities=>newline.
      ENDIF.
      IF <ls_request>-etag IS NOT INITIAL.
        lv_body_str = lv_body_str && |if-match: { <ls_request>-etag }| && cl_abap_char_utilities=>newline.
      ENDIF.
      lv_body_str = lv_body_str && cl_abap_char_utilities=>newline && |Content-Type: application/json|  && cl_abap_char_utilities=>newline  && cl_abap_char_utilities=>newline.
    ENDLOOP.
    IF lv_changeset_needed = abap_true.
      lv_body_str = lv_body_str &&  cl_abap_char_utilities=>newline && |--changeset--| &&  cl_abap_char_utilities=>newline &&  cl_abap_char_utilities=>newline.
    ENDIF.
    lv_body_str = lv_body_str &&  cl_abap_char_utilities=>newline && |--batch--|.

    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
      EXPORTING
        text   = lv_body_str
*       MIMETYPE       = ' '
*       ENCODING       =
      IMPORTING
        buffer = lv_request_body
      EXCEPTIONS
        failed = 1
        OTHERS = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

*
    lo_client_proxy->web_request(
    EXPORTING
      it_request_header   = lt_request_header
      iv_request_body     = lv_request_body
    IMPORTING
      ev_status_code      = ev_status_code
      ev_status_text      = ev_status_text
*    ev_content_type     = lv_content_type
      ev_response_body    = ev_body
*    ev_error_text       = lv_error_text
    ).

    IF es_json_response IS REQUESTED.
      CALL METHOD /ui2/cl_json=>deserialize
        EXPORTING
          jsonx = ev_body
*         assoc_arrays_opt = abap_true
        CHANGING
          data  = es_json_response.
    ENDIF.


  ENDMETHOD.


  METHOD convert_json_date.
    CONSTANTS: lc_day_in_sec TYPE i VALUE 86400.
    DATA: lv_timestamp TYPE timestampl,
          lv_days_i    TYPE i,
          lv_offset_i  TYPE i,
          lv_date      TYPE sydate.
    IF iv_json_date IS NOT INITIAL.
      FIND FIRST OCCURRENCE OF REGEX 'Date\((-?\d+)([+-]\d{1,4})?\)' IN iv_json_date SUBMATCHES DATA(lv_epochdate) DATA(lv_offset) IGNORING CASE. "Edm.DateTime or Edm.DateTimeOffset format
      IF lv_epochdate IS NOT INITIAL.
        lv_timestamp = lv_epochdate / 1000.   "timestamp in seconds
        IF lv_offset IS NOT INITIAL.
          lv_offset_i = lv_offset. "offset in minutes
          lv_timestamp = lv_timestamp - lv_offset_i * 60.
        ENDIF.
        lv_days_i    = lv_timestamp DIV lc_day_in_sec.
        lv_date      = '19700101'.
        lv_date      = lv_date + lv_days_i.
      ELSE.
        FIND FIRST OCCURRENCE OF REGEX '(\d{4})-(\d{2})-(\d{2})' IN iv_json_date SUBMATCHES DATA(lv_year) DATA(lv_month) DATA(lv_day). "Edm.Date format
        CONCATENATE lv_year lv_month lv_day INTO lv_date.
      ENDIF.
      rv_date      = lv_date.
    ELSE.
      CLEAR rv_date.
    ENDIF.
  ENDMETHOD.


  METHOD get_instance.
    IF mo_instance IS NOT BOUND.
      mo_instance = NEW cl_sdbil_odata_call( ).
    ENDIF.
    IF iv_service_url IS NOT INITIAL.
      mo_instance->mv_service_url = iv_service_url.
    ENDIF.
    ro_instance = mo_instance.
  ENDMETHOD.
ENDCLASS.
