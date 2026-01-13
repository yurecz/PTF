class CL_PTF_VARDATASET definition
  public
  final
  create public .

public section.

  interfaces IF_PTF_VARDATASET .

  aliases CHECK
    for IF_PTF_VARDATASET~CHECK .
  aliases DELETE
    for IF_PTF_VARDATASET~DELETE .
  aliases IS_IN_CUSTOMER_NS
    for IF_PTF_VARDATASET~IS_IN_CUSTOMER_NS .
  aliases IS_MAINTNCE_HERE_ALLOWED_FOR
    for IF_PTF_VARDATASET~IS_MAINTNCE_HERE_ALLOWED_FOR .
  aliases LOAD
    for IF_PTF_VARDATASET~LOAD .
  aliases LOAD_SINGLE
    for IF_PTF_VARDATASET~LOAD_SINGLE .
  aliases SAVE
    for IF_PTF_VARDATASET~SAVE .

  data GO_TRANSPORT type ref to CL_PTF_TRANSPORT .
  constants GC_INPUT_ID_PCRE type STRING value '[a-zA-Z0-9_]*' ##NO_TEXT.

  methods CONSTRUCTOR .
protected section.
private section.

  methods VALIDATE_INPUT
    importing
      !IS_PTF_VARDATASET type PTF_VARDATASET
    raising
      CX_PTF_VARDATASET .
ENDCLASS.



CLASS CL_PTF_VARDATASET IMPLEMENTATION.


  METHOD CONSTRUCTOR.
    go_transport = cl_ptf_transport=>factory( ).

  ENDMETHOD.


  METHOD if_ptf_vardataset~check.
    DATA ls_ptf_vardataset TYPE ptf_vardataset ##NEEDED.

    IF iv_dataset_id IS NOT SUPPLIED AND iv_variable_name IS NOT SUPPLIED.
      SELECT SINGLE * FROM ptf_vardataset
        INTO @ls_ptf_vardataset
        WHERE ptf_vardataset~varname = @iv_varname ##NEEDED ##WARN_OK.
      IF sy-subrc = 0.
        rv_vardataset = abap_on.

      ENDIF.

    ELSEIF iv_variable_name IS NOT SUPPLIED.
      SELECT SINGLE * FROM ptf_vardataset
        INTO @ls_ptf_vardataset
        WHERE ptf_vardataset~varname    = @iv_varname ##NEEDED
          AND ptf_vardataset~dataset_id = @iv_dataset_id ##NEEDED ##WARN_OK.
      IF sy-subrc = 0.
        rv_vardataset = abap_on.

      ENDIF.

    ELSE.
      SELECT SINGLE * FROM ptf_vardataset
        INTO @ls_ptf_vardataset
        WHERE ptf_vardataset~varname    = @iv_varname ##NEEDED
          AND ptf_vardataset~dataset_id = @iv_dataset_id ##NEEDED
          AND ptf_vardataset~variable_name = @iv_variable_name ##NEEDED.
      IF sy-subrc = 0.
        rv_vardataset = abap_on.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_vardataset~delete.
    DATA lv_key            TYPE string.
    DATA lv_table_name     TYPE string.

*   Validate Variant Name
    IF iv_varname IS INITIAL.
      RAISE EXCEPTION NEW cx_ptf_vardataset( textid = cx_ptf_vardataset=>initial_varname ).

    ENDIF.

    DELETE FROM ptf_vardataset WHERE ptf_vardataset~varname = iv_varname.
    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW cx_ptf_vardataset( textid = cx_ptf_vardataset=>delete_error ).

    ENDIF.

*   Save to transport if not in customer namespace
    IF me->is_in_customer_ns( iv_varname ) = abap_off.
      CONCATENATE sy-mandt iv_varname '*' INTO lv_key RESPECTING BLANKS.
      lv_table_name = 'PTF_INPUT_REPO'.

      me->go_transport->set_transport_entries(
        EXPORTING
          iv_key        = lv_key
          iv_table_name = lv_table_name ).

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_vardataset~is_in_customer_ns.
    IF matches( val = iv_varname pcre = '[YZ].*' ).
      rv_result = abap_true.
      RETURN.

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_vardataset~is_maintnce_here_allowed_for.
    " -Z scripts can be maintained everywhere
    " -in home dev clients, also standard scripts can be maintained
    IF iv_varname IS INITIAL.
      RETURN.

    ENDIF.

    DATA(lo_client) = NEW cl_ptf_client( ). "toDo: DoC must be a member variable

    IF me->is_in_customer_ns( iv_varname = iv_varname )
      OR lo_client->am_i_in_homedevclient( ).
      rv_result = abap_true.

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_vardataset~load.
*   Validate Variable Name
    IF iv_varname IS INITIAL.
      RAISE EXCEPTION NEW cx_ptf_vardataset( textid = cx_ptf_vardataset=>initial_varname ).

    ENDIF.

    SELECT * FROM ptf_vardataset
      INTO CORRESPONDING FIELDS OF TABLE @rt_ptf_vardataset
      WHERE ptf_vardataset~varname = @iv_varname.
    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW cx_ptf_vardataset( textid = cx_ptf_vardataset=>not_found ).

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_vardataset~load_single.
*   Validate Variable Name
    IF iv_varname IS INITIAL.
      RAISE EXCEPTION NEW cx_ptf_vardataset( textid = cx_ptf_vardataset=>initial_varname ).

    ENDIF.

*   Validate Data Set ID
    IF iv_dataset_id IS INITIAL.
      RAISE EXCEPTION NEW cx_ptf_vardataset( textid = cx_ptf_vardataset=>initial_dataset_id ).

    ENDIF.

*   Validate Variable Name
    IF iv_variable_name IS INITIAL.
      RAISE EXCEPTION NEW cx_ptf_vardataset( textid = cx_ptf_vardataset=>initial_variable_name ).

    ENDIF.

    SELECT SINGLE * FROM ptf_vardataset
      INTO CORRESPONDING FIELDS OF @rs_ptf_vardataset
      WHERE ptf_vardataset~varname = @iv_varname
        AND ptf_vardataset~dataset_id = @iv_dataset_id
        AND ptf_vardataset~variable_name = @iv_variable_name.
    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW cx_ptf_vardataset( textid = cx_ptf_vardataset=>not_found ).

    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_vardataset~save.
    DATA lv_varname        TYPE ptf_vardataset-varname.
    DATA lv_key            TYPE string.
    DATA lv_table_name     TYPE string.

    FIELD-SYMBOLS <fs_ptf_vardataset> TYPE ptf_vardataset.

    IF it_ptf_vardataset IS INITIAL.
      RETURN.

    ENDIF.

    LOOP AT it_ptf_vardataset ASSIGNING <fs_ptf_vardataset>.
      me->validate_input( <fs_ptf_vardataset> ).

    ENDLOOP.

*   Check consistency of variant name
    LOOP AT it_ptf_vardataset ASSIGNING <fs_ptf_vardataset>.
      DATA(lv_tabix) = sy-tabix.

      IF lv_tabix > 1 AND lv_varname <> <fs_ptf_vardataset>-varname.
        RAISE EXCEPTION NEW cx_ptf_vardataset( textid = cx_ptf_vardataset=>inconsistent_varname ).

      ENDIF.

      lv_varname = <fs_ptf_vardataset>-varname.

    ENDLOOP.

*   Delete entries if they exist
    DELETE FROM ptf_vardataset WHERE ptf_vardataset~varname = lv_varname.

*   Insert entries
    INSERT ptf_vardataset FROM TABLE it_ptf_vardataset.
    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW cx_ptf_vardataset( textid = cx_ptf_vardataset=>save_error ).

    ENDIF.

*   Save to transport if not in customer namespace
    IF me->is_in_customer_ns( lv_varname ) = abap_off.
      CONCATENATE sy-mandt <fs_ptf_vardataset>-varname '*' INTO lv_key RESPECTING BLANKS.
      lv_table_name = 'PTF_VARDATASET'.

      me->go_transport->set_transport_entries(
        EXPORTING
          iv_key        = lv_key
          iv_table_name = lv_table_name ).

    ENDIF.

  ENDMETHOD.


  METHOD validate_input.
*   Validate Variable Name
    IF is_ptf_vardataset-varname IS INITIAL.
      RAISE EXCEPTION NEW cx_ptf_vardataset( textid = cx_ptf_vardataset=>initial_varname ).

    ENDIF.

*   Validate Data Set ID
    IF is_ptf_vardataset-dataset_id IS INITIAL.
      RAISE EXCEPTION NEW cx_ptf_vardataset( textid = cx_ptf_vardataset=>initial_dataset_id ).

    ENDIF.

*   Validate Variable Name
    IF is_ptf_vardataset-variable_name IS INITIAL.
      RAISE EXCEPTION NEW cx_ptf_vardataset( textid = cx_ptf_vardataset=>initial_variable_name ).

    ENDIF.

    IF is_ptf_vardataset-variable_name NP '&*'.
      RAISE EXCEPTION NEW cx_ptf_vardataset( textid = cx_ptf_vardataset=>invalid_variable_name ).

    ENDIF.

*   Validate Variable Value
    IF is_ptf_vardataset-variable_value IS INITIAL.
      RAISE EXCEPTION NEW cx_ptf_vardataset( textid = cx_ptf_vardataset=>initial_variable_value ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
