CLASS cl_ptf_json_repository DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_ptf_json_repository .

    ALIASES check
      FOR if_ptf_json_repository~check .
    ALIASES delete
      FOR if_ptf_json_repository~delete .
    ALIASES is_in_customer_ns
      FOR if_ptf_json_repository~is_in_customer_ns .
    ALIASES is_maintnce_here_allowed_for
      FOR if_ptf_json_repository~is_maintnce_here_allowed_for .
    ALIASES load
      FOR if_ptf_json_repository~load .
    ALIASES save
      FOR if_ptf_json_repository~save .

    DATA go_transport TYPE REF TO cl_ptf_transport .
    CONSTANTS gc_input_id_pcre TYPE string VALUE '[a-zA-Z0-9_]*' ##NO_TEXT.

    METHODS constructor .
  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS validate_input
      IMPORTING
        !is_ptf_input_repo TYPE ptf_input_repo
      RAISING
        cx_ptf_json_repository .


      methods GET_TIME
    returning
      value(RV_RESULT) type SYTIME .
  methods GET_DATE
    returning
      value(RV_RESULT) type SYDATS .

ENDCLASS.



CLASS CL_PTF_JSON_REPOSITORY IMPLEMENTATION.


  METHOD constructor.
    go_transport = cl_ptf_transport=>factory( ).

  ENDMETHOD.


  METHOD get_date.

    "we use system time - not user time

    rv_result = sy-datum.

  ENDMETHOD.


  METHOD get_time.

    rv_result = sy-uzeit.

  ENDMETHOD.


  METHOD if_ptf_json_repository~check.
    SELECT SINGLE * FROM ptf_input_repo
      INTO @DATA(ls_ptf_input_repo)
      WHERE ptf_input_repo~input_id = @iv_variant ##NEEDED.
    IF sy-subrc = 0.
      rv_json_repository = abap_on.

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_json_repository~delete.

    DATA lv_key            TYPE string.
    DATA lv_table_name     TYPE string.

*   Validate INPUT ID
    IF iv_input_id IS INITIAL.
      RAISE EXCEPTION NEW cx_ptf_json_repository( textid = cx_ptf_json_repository=>initial_input_id ).
    ENDIF.

    DELETE FROM ptf_input_repo WHERE ptf_input_repo~input_id = iv_input_id.
    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW cx_ptf_json_repository( textid = cx_ptf_json_repository=>delete_error ).
    ENDIF.

*   Save to transport if not in customer namespace
    IF me->is_in_customer_ns( iv_input_id ) = abap_off.
      MOVE iv_input_id TO lv_key.
      lv_table_name = 'PTF_INPUT_REPO'.

      me->go_transport->set_transport_entries(
        EXPORTING
          iv_key        = lv_key
          iv_table_name = lv_table_name ).

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_json_repository~is_in_customer_ns.
    IF matches( val = iv_input_id pcre = '[YZ].*' ).
      rv_result = abap_true.
      RETURN.

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_json_repository~is_maintnce_here_allowed_for.
    " -Z scripts can be maintained everywhere
    " -in home dev clients, also standard scripts can be maintained
    IF iv_input_id IS INITIAL.
      RETURN.

    ENDIF.

    DATA(lo_client) = NEW cl_ptf_client( ). "toDo: DoC must be a member variable

    IF me->is_in_customer_ns( iv_input_id = iv_input_id )
      OR lo_client->am_i_in_homedevclient( ).
      rv_result = abap_true.

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_json_repository~load.
*   Validate INPUT ID
    IF iv_input_id IS INITIAL.
      RAISE EXCEPTION NEW cx_ptf_json_repository( textid = cx_ptf_json_repository=>initial_input_id ).

    ENDIF.

    SELECT SINGLE * FROM ptf_input_repo
      INTO CORRESPONDING FIELDS OF @rs_ptf_input_repo
      WHERE ptf_input_repo~input_id = @iv_input_id.
    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW cx_ptf_json_repository( textid = cx_ptf_json_repository=>not_found ).

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_json_repository~save.

    DATA ls_input_repo TYPE ptf_input_repo.
    DATA lv_key            TYPE string.
    DATA lv_table_name     TYPE string.

    DATA(lv_current_sysid) = sy-sysid.

    ls_input_repo-input_id      = iv_input_id.
    ls_input_repo-bus_obj       = iv_bus_obj.
    ls_input_repo-action        = iv_action.
    ls_input_repo-descr         = iv_descr.
    ls_input_repo-input_string  = iv_input_string.

    me->validate_input( ls_input_repo ).

    IF iv_update IS INITIAL.
      "for creation
      ls_input_repo-creation_user = sy-uname.
      ls_input_repo-creation_date = get_date( ).
      ls_input_repo-creation_time = get_time( ).
      ls_input_repo-src_system    = lv_current_sysid.
      ls_input_repo-modif_system  = space.
    ELSE.

      "for update
      SELECT SINGLE * FROM ptf_input_repo INTO @DATA(ls_db_before) WHERE input_id = @iv_input_id.

      ls_input_repo-creation_user  = ls_db_before-creation_user.
      ls_input_repo-creation_date  = ls_db_before-creation_date.
      ls_input_repo-creation_time  = ls_db_before-creation_time.
      ls_input_repo-last_change_user = sy-uname.
      ls_input_repo-last_change_date = get_date( ).
      ls_input_repo-last_change_time = get_time( ).

      IF ls_db_before-src_system EQ lv_current_sysid     OR ls_db_before-src_system is initial. "2nd condition at least for the records created in ER9 in my first tests
        ls_input_repo-src_system     = lv_current_sysid.
        ls_input_repo-modif_system   = space.
      ELSE.
        "is modification (change of a transported JSON in a different system)
        ls_input_repo-src_system     = ls_db_before-src_system.    "keep value
        ls_input_repo-modif_system   = lv_current_sysid.
      ENDIF.

    ENDIF.


    "DB change
    MODIFY ptf_input_repo FROM ls_input_repo.
    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW cx_ptf_json_repository( textid = cx_ptf_json_repository=>save_error ).
    ENDIF.

*   Save to transport if not in customer namespace
    IF me->is_in_customer_ns( iv_input_id ) = abap_off.
      MOVE iv_input_id TO lv_key.
      lv_table_name = 'PTF_INPUT_REPO'.
      me->go_transport->set_transport_entries(
        EXPORTING
          iv_key        = lv_key
          iv_table_name = lv_table_name ).
    ENDIF.

  ENDMETHOD.


  METHOD validate_input.
*   Validate INPUT ID
    IF is_ptf_input_repo-input_id IS INITIAL.
      RAISE EXCEPTION NEW cx_ptf_json_repository( textid = cx_ptf_json_repository=>initial_input_id ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
