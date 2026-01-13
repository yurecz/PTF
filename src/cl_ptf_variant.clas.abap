class CL_PTF_VARIANT definition
  public
  final
  create public .

public section.

  types:
*DDIC entry has to be created without check.
    BEGIN OF gty_ptf_variant,
        varname          TYPE ptf_varname,
        vtext            TYPE char30,
        erdat            TYPE vari_vdate,
        ernam            TYPE uname,
        last_change_date TYPE ptf_change_date,
        last_change_user TYPE ptf_change_user,
        user_specific    TYPE ptf_user_specific,
        scope_item       TYPE ptf_scope_item,
      END OF gty_ptf_variant .
  types:
    gty_ptf_variant_tab TYPE STANDARD TABLE OF ptf_selection .
  types:
    gty_varexpmess TYPE STANDARD TABLE OF ptf_varexpmess WITH DEFAULT KEY .
  types:
    gty_vardataset TYPE ptf_vardataset_t .
  types:
    BEGIN OF gty_step_data,
        bus_obj             TYPE ptf_bo,
        action              TYPE ptf_act,
        variant             TYPE ptf_tdcv,
        test_data_container TYPE etobj_name,
        reference_step      TYPE cl_ptf_util=>gty_reference_tab,   "gty_reference_tab TYPE STANDARD TABLE OF gty_ref_step   WITH DEFAULT KEY .
        exp_messages        TYPE ptf_exp_message_t,
        input_string        TYPE ptf_json_string,
      END OF gty_step_data .
  types:
    gty_step_data_tab TYPE STANDARD TABLE OF gty_step_data .      "step fields of PTF_VARCON, but with additional components: itab 'reference_step' and itab 'exp_messages'. Has no STEP_NUMBER.
  types:
    gty_ptf_text    TYPE STANDARD TABLE OF ptf_text .
  types:
    gty_ptf_cat     TYPE STANDARD TABLE OF ptf_varcat .
  types:
    gty_ptf_varcat  TYPE STANDARD TABLE OF ptf_varcat WITH DEFAULT KEY .
  types:
    gty_ptf_varcon  TYPE STANDARD TABLE OF ptf_varcon WITH DEFAULT KEY .
  types:
    gty_ptf_varref  TYPE STANDARD TABLE OF ptf_varref WITH DEFAULT KEY .
  types:
    gty_tags        TYPE STANDARD TABLE OF ptf_variant_tag_input WITH DEFAULT KEY .
  types:
    BEGIN OF gty_version,
        script_version TYPE ptf_script_version,
        src_system     TYPE srcsystem,
        modif_system   TYPE srcsystem,
      END OF gty_version .

  data GV_SEARCH type ABAP_BOOL value ABAP_FALSE ##NO_TEXT.
  class-data GS_PTF_VARID_OLD type PTF_VARID .
  constants GC_VARIANT_REGEX type STRING value '[a-zA-Z0-9_]*' ##NO_TEXT.
  data GO_TRANSPORT type ref to CL_PTF_TRANSPORT .

  methods READ
    importing
      !IV_VARNAME type PTF_VARNAME
    exporting
      !ET_VARIANT_TAB type GTY_STEP_DATA_TAB
      !ET_VARCAT type GTY_PTF_TEXT
      !ET_VARDATASET type GTY_VARDATASET .
  methods SAVE
    importing
      !IT_VARIANT_TAB type GTY_STEP_DATA_TAB
      !IV_VARNAME type PTF_VARNAME
      !IV_VARDESCR type RVART_VTXT
      !IV_USER_SPECIFIC type PTF_USER_SPECIFIC optional
      !IV_SCOPE_ITEM type PTF_SCOPE_ITEM
      !IV_UPDATE type ABAP_BOOL optional
      !IT_VARTEXT type GTY_PTF_TEXT optional
      !IT_TAGS type GTY_TAGS optional
      !IT_VARDATASET type GTY_VARDATASET optional .
  methods READ_FOR_SELECTION
    importing
      !IS_SEL_PARAM type PTF_SELECTION
    exporting
      !ET_SELECTION_TAB type GTY_PTF_VARIANT_TAB .
  methods DELETE
    importing
      !IV_VARNAME type PTF_VARNAME
    returning
      value(RV_DELETED) type ABAP_BOOL .
  methods UPDATE
    importing
      !IV_VARNAME type PTF_VARNAME
      !IV_VARNAME_NEW type PTF_VARNAME optional
      !IV_VARDESCR_NEW type RVART_VTXT optional
      !IT_VARIANT_TAB type GTY_STEP_DATA_TAB optional
      !IV_USER_SPECIFIC type PTF_USER_SPECIFIC optional
      !IV_SCOPE_ITEM type PTF_SCOPE_ITEM optional
      !IT_VARTEXT type GTY_PTF_TEXT optional
      !IT_TAGS type GTY_TAGS optional
      !IT_VARDATASET type GTY_VARDATASET optional
    returning
      value(RV_UPDATED) type ABAP_BOOL .
  methods CHECK_EXISTENCE
    importing
      !IV_VARNAME type PTF_VARNAME
    returning
      value(RV_EXISTS) type ABAP_BOOL .
  methods SEARCH
    importing
      !IS_SEL_PARAM type PTF_SELECTION
      !IT_VARIANT_TAB type GTY_PTF_VARIANT_TAB
    exporting
      !ET_SELECTION_TAB type GTY_PTF_VARIANT_TAB .
  methods GET_TIME
    returning
      value(RV_RESULT) type SYTIME .
  methods GET_DATE
    returning
      value(RV_RESULT) type SYDATS .
  methods IS_IN_CUSTOMER_NAMESPACE
    importing
      !IV_VARNAME type PTF_VARNAME optional
      !IV_TAG type PTF_VARIANT_TAG optional
      !IV_NAME type PTF_VARIANT_TAG optional
      !IV_2ND_NAME type PTF_VARIANT_TAG optional
    returning
      value(RV_RESULT) type ABAP_BOOL .
  methods IS_MAINTNCE_HERE_ALLOWED_FOR
    importing
      !IV_VARNAME type PTF_VARNAME
    returning
      value(RV_RESULT) type ABAP_BOOL .
  methods READ_SRC_SYSTEM_FOR
    importing
      !IV_VARNAME type PTF_VARNAME
    returning
      value(RV_SRC_SYSTEM) type SRCSYSTEM
    raising
      CX_PTF_VARIANT_NOT_FOUND .
  methods CHECK_SYNTAX
    importing
      !IT_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP_TAB
    returning
      value(RO_ERROR) type ref to CL_PTF_STATIC_SYNTAX_ERROR .
  methods IS_EMPTY
    importing
      !IT_STEP_DATA type CL_PTF_UTIL=>GT_PTF_STEP_TAB
    returning
      value(RV_RESULT) type ABAP_BOOL .
  PROTECTED SECTION.
private section.

  types:
    gty_cond TYPE c LENGTH 120 .
  types:
    gty_cond_tab TYPE STANDARD TABLE OF gty_cond .

  data GS_VERSION type GTY_VERSION .

  methods GET_WHERE_CLAUSE_FOR_READ
    importing
      !IS_SEL_PARAM type PTF_SELECTION
    exporting
      !ET_WHERE type GTY_COND_TAB .
  methods SAVE_PTF_TAGS
    importing
      !VARNAME type PTF_VARNAME
      !TAGS type GTY_TAGS .
  methods UPDATE_PTF_TAGS
    importing
      !VARNAME type PTF_VARNAME
      !TAGS type GTY_TAGS .
  methods SAVE_PTF_VARID
    importing
      !IV_VARNAME type PTF_VARNAME
      !IV_USER_SPECIFIC type PTF_USER_SPECIFIC
      !IV_SCOPE_ITEM type PTF_SCOPE_ITEM
      !IV_UPDATE type ABAP_BOOL optional
      !IS_VERSION type GTY_VERSION
    exporting
      !ES_PTF_VARID type PTF_VARID .
  methods SAVE_PTF_VARID_T
    importing
      !IV_VARNAME type PTF_VARNAME
      !IV_VARDESCR type RVART_VTXT
    exporting
      !ES_VARID_TEXT type PTF_VARID_T .
  methods SAVE_PTF_VARCON
    importing
      !IT_VARIANT_TAB type GTY_STEP_DATA_TAB
      !IV_VARNAME type PTF_VARNAME
      !IS_VERSION type GTY_VERSION
    exporting
      !ET_VARCON type GTY_PTF_VARCON .
  methods SAVE_PTF_VARREF
    importing
      !IT_VARIANT_TAB type GTY_STEP_DATA_TAB
      !IV_VARNAME type PTF_VARNAME
      !IS_VERSION type GTY_VERSION
    exporting
      !ET_VARREF type GTY_PTF_VARREF .
  methods SAVE_PTF_VARCAT
    importing
      !IV_VARNAME type PTF_VARNAME
      !IT_VARTEXT type GTY_PTF_TEXT
    exporting
      !ET_VARCAT type GTY_PTF_VARCAT .
  methods SAVE_PTF_VAREXPMESS
    importing
      !IV_VARNAME type PTF_VARNAME
      !IT_VARIANT_TAB type GTY_STEP_DATA_TAB
    exporting
      !ET_VAREXPMESS type GTY_VAREXPMESS .
  methods SAVE_PTF_VARDATASET
    importing
      !IV_VARNAME type PTF_VARNAME
      !IT_VARDATASET type GTY_VARDATASET
    exporting
      !ET_VARDATASET type GTY_VARDATASET .
  methods DELETE_PTF_TAGS
    importing
      !IV_VARNAME type PTF_VARNAME .
  methods PREPARE_TEXT
    importing
      !IT_VARCAT type GTY_PTF_CAT
    exporting
      !ET_VAR_TEXT type GTY_PTF_TEXT .
  methods ENRICH_WITH_VARREF_DATA
    importing
      !IT_VARREF type GTY_PTF_VARREF
    changing
      !CT_VARIANT_TAB type GTY_STEP_DATA_TAB .
  methods ENRICH_WITH_EXPMESS_DATA
    importing
      !IT_EXPMESS type GTY_VAREXPMESS
    changing
      !CT_VARIANT_TAB type GTY_STEP_DATA_TAB .
  methods BUILD_VERSION_DATA
    importing
      !IV_UPDATE type ABAP_BOOL
      !IV_CURRENT_SYSID type SYST_SYSID
      !IS_VERSION_OLD type GTY_VERSION
    returning
      value(RS_VERSION_NEW) type GTY_VERSION .
ENDCLASS.



CLASS CL_PTF_VARIANT IMPLEMENTATION.


  METHOD build_version_data.

    CLEAR rs_version_new.

    IF iv_update IS INITIAL.
      "is script creation (first save of completely new entered script,  or Save,CreateNew of an existing one but now new with new name)
      rs_version_new-script_version = 1.
      rs_version_new-src_system     = iv_current_sysid.
*      rs_version_new-modif_system   = space
    ELSE.
      "is an update of already persisted script

      IF is_version_old-src_system EQ iv_current_sysid
       OR is_version_old IS INITIAL   "für bestehende skripte, gespeichert vor Einführung der Version Felder  "modification eines scripts, das vor Version-Einführung transportiert wurde, landet auch hier
       OR ( iv_current_sysid EQ 'ER1' AND is_version_old-src_system EQ 'ER9' ) "for scripts created in ER9, and changed in ER1, this is no modification, but we change the source system
       OR ( iv_current_sysid EQ 'ERX' AND is_version_old-src_system EQ 'ER9' ). "for scripts created in ER9, and changed in ER1, this is no modification, but we change the source system
        rs_version_new-script_version = is_version_old-script_version + 1.
        rs_version_new-src_system     = iv_current_sysid.
*        rs_version_new-modif_system   = space
      ELSE.
        "is a modification   (change of a transported script in a different system)
        TRY.
            IF is_version_old-modif_system EQ iv_current_sysid.
              rs_version_new-script_version = is_version_old-script_version + 1.
            ELSE.
              rs_version_new-script_version = is_version_old-script_version + 1000.
            ENDIF.
          CATCH cx_sy_conversion_overflow.
            rs_version_new-script_version = is_version_old-script_version.    "in this unlikely case, accept the limit
        ENDTRY.
        rs_version_new-src_system     = is_version_old-src_system.             "keep value
        rs_version_new-modif_system   = iv_current_sysid.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD check_existence.

    DATA lt_ptf_varid TYPE STANDARD TABLE OF ptf_varid WITH DEFAULT KEY.
*    CLEAR: gt_ptf_varid, gt_ptf_varid_t, gt_ptf_varcon.

    rv_exists = abap_false.

    TRY.
        SELECT * FROM ptf_varid
        INTO TABLE lt_ptf_varid
        WHERE varname = iv_varname.

        IF line_exists( lt_ptf_varid[ 1 ] ).
          rv_exists = abap_true.
        ENDIF.
      CATCH cx_root.
        rv_exists = abap_false.
    ENDTRY.

  ENDMETHOD.


  method check_syntax.

*Former comments:
*&---------------------------------------------------------------------*
*& Include          PTF_CHECK_ALV_INPUT
*
*  Sets ev_script_is_ok
*  Might raise a message and call Form set_focus
*&---------------------------------------------------------------------*
*FORM alv_value_check USING    it_step_data        TYPE cl_ptf_util=>gt_ptf_step_tab
*                     CHANGING ev_check_alv_status TYPE abap_bool.

    data: lv_alv_is_filled type abap_bool,
          lv_bo            type ptfboa-ptf_bo,
          lv_act           type ptfboa-ptf_act,
          lv_dummy         type string,
          lv_tdcp          type pname,
          lv_is_rap_bo     type abap_bool,
          lt_data_proof    type cl_ptf_util=>gt_ptf_step_tab,
          lt_step_data     type table of cl_ptf_util=>gt_ptf_step.

    data ev_script_is_ok  type abap_bool. "can be removed, not needed

    constants: c_column_bo       type lvc_fname value 'BUS_OBJ',
               c_column_action   type lvc_fname value 'ACTION',
               c_column_variant  type lvc_fname value 'VARIANT',
               c_column_ref_step type lvc_fname value 'REFERENCE_STEP'.

    clear ro_error.

    data(lo_ptf_rap_metadata) = new cl_ptf_rap_metadata( ).

    ev_script_is_ok = abap_true.

    move it_step_data to lt_data_proof.

    clear lv_alv_is_filled.
    loop at lt_data_proof assigning field-symbol(<ls_data_proof>).
      if <ls_data_proof>-bus_obj is not initial.
        lv_alv_is_filled = abap_true.
      endif.
    endloop.

    if lv_alv_is_filled eq abap_false.
      ev_script_is_ok = abap_false.
*      MESSAGE ID 'PTF' TYPE 'S' NUMBER 037 DISPLAY LIKE 'E'.
      ro_error = new cl_ptf_static_syntax_error( msgno = '037'
*                                                row_index   = sy-tabix
*                                                column_name = c_column_xxx
                                                ).
      return.
    endif.

    loop at lt_data_proof assigning <ls_data_proof>.
      data lv_step_number_as_char type symsgv.
      lv_step_number_as_char = <ls_data_proof>-step_number.

      "Empty lines should be ignored.
      if <ls_data_proof>-action is not initial
       or <ls_data_proof>-bus_obj is not initial
       or <ls_data_proof>-reference_step  is not initial
       or <ls_data_proof>-variant is not initial.

        "BO must not be initial
        if <ls_data_proof>-bus_obj is initial.
          ev_script_is_ok = abap_false.
          ro_error = new cl_ptf_static_syntax_error( msgno = '011'
                                                     msgv1 = lv_step_number_as_char
                                                     row_index   = sy-tabix
                                                     column_name = c_column_bo ).
*        lo_error->raise_message( display_type = 'E' ).
*        PERFORM set_focus USING c_column_bo sy-tabix.
*        MESSAGE ID 'PTF' TYPE 'S' NUMBER 011 WITH <ls_data_proof>-step_number  DISPLAY LIKE 'E'.
          return.
        endif.

        "ACTION must not be initial
        if <ls_data_proof>-bus_obj is not initial.
          if <ls_data_proof>-action is initial.
            ev_script_is_ok = abap_false.
*          PERFORM set_focus USING c_column_action sy-tabix.
*            MESSAGE ID 'PTF' TYPE 'S' NUMBER 010 WITH <ls_data_proof>-bus_obj <ls_data_proof>-step_number DISPLAY LIKE 'E'.
            ro_error = new cl_ptf_static_syntax_error( msgno = '010'
                                                       msgv1 = conv symsgv( <ls_data_proof>-bus_obj )
                                                       msgv2 = lv_step_number_as_char
                                                       row_index   = sy-tabix
                                                       column_name = c_column_action ).
            return.
          endif.
        endif.

*     Get name and category[?] for the test data container.      Currently only an PTFBOA entry existence check
        cl_ptf_util=>get_name_tdc(
          exporting
            iv_bo       = <ls_data_proof>-bus_obj
            iv_action   = <ls_data_proof>-action
          importing
            ev_name_tdc = data(lo_name_tdc__unused) ).

**    Check that reference steps are valid ********
        data number_of_entries type i.
        data(lv_tabix_proof) = sy-tabix.
        if <ls_data_proof>-reference_step is not initial.
          loop at <ls_data_proof>-reference_step assigning field-symbol(<lv_reference_step>).
            if <lv_reference_step> is assigned and <lv_reference_step> ne 0.
              number_of_entries = 0.

              loop at <ls_data_proof>-reference_step transporting no fields where table_line = <lv_reference_step>.
                number_of_entries = number_of_entries + 1.
              endloop.

              if number_of_entries gt 1.
                ev_script_is_ok = abap_false.
*                MESSAGE s057(ptf) WITH <lv_reference_step> <ls_data_proof>-step_number DISPLAY LIKE 'E'.
                ro_error = new cl_ptf_static_syntax_error( msgno = '057'
                                                           msgv1 = conv symsgv( <lv_reference_step> )
                                                           msgv2 = lv_step_number_as_char
*                                                           row_index   = sy-tabix
*                                                           column_name = c_column_xxx
                                                          ).
                return. "why is here not a call of set_focus??
              endif.

              if <lv_reference_step> ge <ls_data_proof>-step_number
                or lt_data_proof[ <lv_reference_step> ]-bus_obj is initial.
                ev_script_is_ok = abap_false.
*              PERFORM set_focus USING c_column_ref_step lv_tabix_proof.
*                MESSAGE ID 'PTF' TYPE 'S' NUMBER 002 WITH <ls_data_proof>-step_number  DISPLAY LIKE 'E'.
                ro_error = new cl_ptf_static_syntax_error( msgno = '002'
                                                           msgv1 = lv_step_number_as_char
*                                                           row_index   = sy-tabix
*                                                           column_name = c_column_xxx
                                                          ).
                return.
              endif.
            endif.
          endloop.
        endif.

**    Check if business object is valid ***************
        select single ptf_bo from ptfbo into lv_bo where ptf_bo = <ls_data_proof>-bus_obj.
        if sy-subrc <> 0.
          lv_is_rap_bo = lo_ptf_rap_metadata->check_rap_bo( iv_bus_obj = <ls_data_proof>-bus_obj ).
          if lv_is_rap_bo = abap_off.
            ev_script_is_ok = abap_false.
*          PERFORM set_focus USING c_column_bo sy-tabix.
*            MESSAGE ID 'PTF' TYPE 'S' NUMBER 012 WITH <ls_data_proof>-step_number DISPLAY LIKE 'E'.
            ro_error = new cl_ptf_static_syntax_error( msgno = '012'
                                                             msgv1 = lv_step_number_as_char
                                                             row_index   = sy-tabix
                                                             column_name = c_column_bo ).
            return.

          endif.
        endif.

**    Check whether the combination of BO and Action is valid *******************************************
        select single ptf_act from ptfboa into lv_act where ptf_act = <ls_data_proof>-action  and ptf_bo = <ls_data_proof>-bus_obj.
        if sy-subrc <> 0.
          data(lv_is_rap_bo_action) = lo_ptf_rap_metadata->check_rap_bo_action(
                                        exporting
                                          iv_bus_obj = <ls_data_proof>-bus_obj
                                          iv_action  = <ls_data_proof>-action ).
          if lv_is_rap_bo_action = abap_off.
            ev_script_is_ok = abap_false.
*          PERFORM set_focus USING c_column_action sy-tabix.
*            MESSAGE ID 'PTF' TYPE 'S' NUMBER 042 WITH <ls_data_proof>-step_number DISPLAY LIKE 'E'.
            ro_error = new cl_ptf_static_syntax_error( msgno = '042'
                                                       msgv1 = lv_step_number_as_char
                                                       row_index   = sy-tabix
                                                       column_name = c_column_action ).
            return.

          endif.
        endif.

**    Check wether the combination of Business object, action and TDCV is valid **********************
        if <ls_data_proof>-variant is not initial.

          data lv_rfc type c length 32.
          get parameter id 'PTF_RFC_FOR_TDC' field lv_rfc.
          if lv_rfc is initial.    "only if nor RFC connection is set. else we skip the following validation

            lv_is_rap_bo = lo_ptf_rap_metadata->check_rap_bo( iv_bus_obj = <ls_data_proof>-bus_obj ).

            if <ls_data_proof>-bus_obj eq cl_ptf_util=>gc_bo_ptfrun and <ls_data_proof>-action eq cl_ptf_util=>gc_action_mock_db.
              "Special case START_DATA_MOCKING
              find ',' in <ls_data_proof>-variant.
              if sy-subrc eq 0.
                data: lv_tdc  type etobj_name,
                      lv_tdcv type etvar_id.
                split <ls_data_proof>-variant at ',' into lv_tdc lv_tdcv.
                if lv_tdcv is initial or lv_tdc is initial.
                  "bad input, std TDCV error message
                  ev_script_is_ok = abap_false.
                  ro_error = new cl_ptf_static_syntax_error( msgno = '041'
                                                             msgv1 = lv_step_number_as_char
                                                             row_index   = sy-tabix
                                                             column_name = c_column_variant ).
                  return.
                else.
                  if <ls_data_proof>-test_data_container is not initial.
                    if lv_tdc ne <ls_data_proof>-test_data_container.
                      "deviating TDCs, std TDCV error message
                      ev_script_is_ok = abap_false.
                      ro_error = new cl_ptf_static_syntax_error( msgno = '041'
                                                                 msgv1 = lv_step_number_as_char
                                                                 row_index   = sy-tabix
                                                                 column_name = c_column_variant ).
                      return.
                    endif.
                  endif.
*               SELECT SINGLE name FROM ectd_data INTO @DATA(lv_dummy_new) WHERE name = @lv_tdc AND varid = @lv_tdcv.
                  select single name from ectd_data into @lv_dummy where name = @lv_tdc and name like 'TDC_PTF_MOCK%' and varid = @lv_tdcv. "toDO: allow characters before TDC_PTF_MOCK
                  "pnames are endless for db mocking, not consindered here                 AND pname = lv_tdcp.   pname = 'generic' or pname like 'TABLE_%'
                endif.
              else.
                if <ls_data_proof>-test_data_container is not initial.
                  "Validate column TDC with full select (considering TDCV and TDC)
                  select single name from ectd_data into @lv_dummy where name = @<ls_data_proof>-test_data_container and varid = @<ls_data_proof>-variant.
                endif.
              endif.
              "if START_DATA_MOCKING and TDCV is filled (w/o ',') and TDC is empty, currently no SELECT is done at all. error comes anyway, as subrc is 4 from FIND
            elseif <ls_data_proof>-bus_obj eq cl_ptf_util=>gc_bo_ptfrun and ( <ls_data_proof>-action eq cl_ptf_util=>gc_action_start_ftmock_active or <ls_data_proof>-action eq cl_ptf_util=>gc_action_start_ftmock_inactv ).
              "Special case FT mocking
              "first, allow everything. ToDo later: allow Feature Toggle IDs, but also TDC+TDCV instead
            elseif <ls_data_proof>-bus_obj eq 'PTF_ID_GENERATOR' and <ls_data_proof>-action eq 'GET_NEXT_ID'.
              "Special case PTF_ID_GENERATOR-GET_NEXT_ID
              "Pattern in VARIANT is mandatory.     ToDo: validate the pattern
              if <ls_data_proof>-variant is initial. "never true, because the opposite is checked in line 178
                sy-subrc = 4.
              endif.
              "Special case 'number of max. seconds' for PTF_WAIT: field VARIANT used (if not empty) for a positive number, incl. 0
            elseif <ls_data_proof>-bus_obj eq 'PTF_WAIT' and ( <ls_data_proof>-action eq 'WAIT_FOR_BO_CREATION_ON_DB' or <ls_data_proof>-action eq 'WAIT_UNTIL_LOCK_ENDED' or <ls_data_proof>-action eq 'WAIT_FOR_FIELD_VALUE_ON_DB' ).
              if <ls_data_proof>-variant cn ' 1234567890'.
                sy-subrc = 4.
              endif.
              "Special case 'number of max. seconds' for CL_PTF_BO_WORKFLOW: field VARIANT used (if not empty) for a positive number, incl. 0
            elseif <ls_data_proof>-bus_obj eq 'WORKFLOW'.
              if <ls_data_proof>-variant cn ' 1234567890'.
                sy-subrc = 4.
              endif.
            elseif <ls_data_proof>-bus_obj eq 'OR' and <ls_data_proof>-action eq 'COMPARE_AGAINST_DB_DOC'.
              "Special case COMPARE_AGAINST_DB_DOC
              "currently we allow every value and also empty VARIANT field. might become more restrictive here in the future
            elseif lv_is_rap_bo = abap_off. "only if it is not RAP BO
              "STANDARD
              select single ptf_tdcp from ptfboa into lv_tdcp where ptf_act = <ls_data_proof>-action  and ptf_bo = <ls_data_proof>-bus_obj.
              if sy-subrc eq 0.
                select single varid from ectd_data into lv_dummy where varid = <ls_data_proof>-variant and pname = lv_tdcp.
              endif.
              "ToDO: checks only whether there is at least one variant for this TDCP in ANY TDC. NEEDED: consider TDC ID (from step-TDC, or if that is empty from PTFBOA)
            endif.
            if sy-subrc <> 0.
              ev_script_is_ok = abap_false.
*          PERFORM set_focus USING c_column_variant sy-tabix.
*            MESSAGE ID 'PTF' TYPE 'S' NUMBER 041 WITH <ls_data_proof>-step_number DISPLAY LIKE 'E'.
              ro_error = new cl_ptf_static_syntax_error( msgno = '041'
                                                         msgv1 = lv_step_number_as_char
                                                         row_index   = sy-tabix
                                                         column_name = c_column_variant ).
              return.
            endif.

*         Check if JSON ID is valid in case of RAP BO
            if lv_is_rap_bo = abap_on and <ls_data_proof>-test_data_container is initial.
              data(lo_ptf_repository) = new cl_ptf_json_repository( ).

              if lo_ptf_repository->check( <ls_data_proof>-variant ) = abap_off.
                ro_error = new cl_ptf_static_syntax_error( msgno       = '078'
                                                           row_index   = sy-tabix
                                                           column_name = c_column_variant ).
                return.

              endif.

            endif.

          endif.

        endif.

      endif.
    endloop.

*ENDFORM.

  endmethod.


  METHOD delete.

    "does not use global variables, except go_transport

    DATA: lt_ptf_varref     TYPE gty_ptf_varref,
          lt_ptf_varcat     TYPE STANDARD TABLE OF ptf_varcat,
          ls_ptf_varid      TYPE ptf_varid,
          ls_ptf_varid_t    TYPE ptf_varid_t,
          lt_ptf_varcon     TYPE STANDARD TABLE OF ptf_varcon,
          lt_ptf_varexpmess TYPE STANDARD TABLE OF ptf_varexpmess,
          lt_ptf_vardataset TYPE ptf_vardataset_t,
          lv_key            TYPE string,
          lv_table_name     TYPE string.

    go_transport = cl_ptf_transport=>factory( ).

    rv_deleted = abap_true.

    SELECT SINGLE * FROM ptf_varid   INTO   ls_ptf_varid   WHERE varname = iv_varname.
    SELECT SINGLE * FROM ptf_varid_t INTO   ls_ptf_varid_t WHERE varname = iv_varname.
    SELECT * FROM ptf_varcon INTO TABLE     lt_ptf_varcon  WHERE varname = iv_varname.
    SELECT * FROM ptf_varref INTO TABLE     lt_ptf_varref  WHERE varname = iv_varname.
    SELECT * FROM ptf_varcat INTO TABLE     lt_ptf_varcat  WHERE varname = iv_varname.
    SELECT * FROM ptf_varexpmess INTO TABLE lt_ptf_varexpmess WHERE varname = iv_varname.
    SELECT * FROM ptf_vardataset INTO TABLE lt_ptf_vardataset WHERE varname = iv_varname.

    CLEAR: lv_key, lv_table_name.
    CONCATENATE sy-mandt iv_varname INTO lv_key RESPECTING BLANKS.
    lv_table_name = 'PTF_VARID'.
    go_transport->set_transport_entries(
      EXPORTING
        iv_key        = lv_key
        iv_table_name = lv_table_name ).

    CLEAR: lv_key, lv_table_name.
    CONCATENATE sy-mandt ls_ptf_varid_t-langu iv_varname INTO lv_key RESPECTING BLANKS.
    lv_table_name = 'PTF_VARID_T'.
    go_transport->set_transport_entries(
      EXPORTING
        iv_key        = lv_key
        iv_table_name = lv_table_name ).

    LOOP AT lt_ptf_varcon INTO DATA(ls_ptf_varcon).
      CLEAR: lv_key, lv_table_name.
      CONCATENATE sy-mandt iv_varname ls_ptf_varcon-step_number INTO lv_key RESPECTING BLANKS.
      lv_table_name = 'PTF_VARCON'.
      go_transport->set_transport_entries(
        EXPORTING
          iv_key        = lv_key
          iv_table_name = lv_table_name ).
    ENDLOOP.

    LOOP AT lt_ptf_varref INTO DATA(ls_ptf_varref).
      CLEAR: lv_key, lv_table_name.
      CONCATENATE sy-mandt iv_varname ls_ptf_varref-step_number ls_ptf_varref-ref_index ls_ptf_varref-reference_step INTO lv_key RESPECTING BLANKS.
      lv_table_name = 'PTF_VARREF'.
      go_transport->set_transport_entries(
        EXPORTING
          iv_key        = lv_key
          iv_table_name = lv_table_name ).
    ENDLOOP.

    LOOP AT lt_ptf_varcat INTO DATA(ls_ptf_varcat).
      CLEAR: lv_key, lv_table_name.
      CONCATENATE sy-mandt iv_varname ls_ptf_varcat-step_number INTO lv_key RESPECTING BLANKS.
      lv_table_name = 'PTF_VARCAT'.
      go_transport->set_transport_entries(
        EXPORTING
          iv_key        = lv_key
          iv_table_name = lv_table_name ).
    ENDLOOP.

    CLEAR: lv_key, lv_table_name.
    CONCATENATE sy-mandt iv_varname '*' INTO lv_key.
    lv_table_name = 'PTF_VAREXPMESS'.
    go_transport->set_transport_entries(
      EXPORTING
        iv_key        = lv_key
        iv_table_name = lv_table_name ).

    CLEAR: lv_key, lv_table_name.
    CONCATENATE sy-mandt iv_varname '*' INTO lv_key.
    lv_table_name = 'PTF_VARDATASET'.
    go_transport->set_transport_entries(
      EXPORTING
        iv_key        = lv_key
        iv_table_name = lv_table_name ).

    me->delete_ptf_tags( iv_varname = iv_varname ).

    CALL FUNCTION 'PTF_DELETE_DB'
      EXPORTING
        is_ptf_varid      = ls_ptf_varid
        is_ptf_varid_t    = ls_ptf_varid_t
        it_ptf_varref     = lt_ptf_varref
        it_ptf_varcon     = lt_ptf_varcon
        it_ptf_varcat     = lt_ptf_varcat
        it_ptf_varexpmess = lt_ptf_varexpmess
        it_ptf_vardataset = lt_ptf_vardataset.

  ENDMETHOD.


  METHOD delete_ptf_tags.
    DATA: e071k TYPE e071k,
          ko200 TYPE ko200.

    SELECT * FROM ptf_var_tag_map WHERE varname = @iv_varname INTO TABLE @DATA(entries_to_transport).

    LOOP AT entries_to_transport ASSIGNING FIELD-SYMBOL(<tag_map_entry>).
      CLEAR e071k.
      CLEAR ko200.
      DATA(key_map_tag) = |{ sy-mandt WIDTH = 3 }{ <tag_map_entry>-tag WIDTH = 80 }{ <tag_map_entry>-varname WIDTH = 31 }|.
      e071k = VALUE #( pgmid = 'R3TR' object = 'TABU' objname = 'PTF_VAR_TAG_MAP'  mastertype = 'TABU' mastername = 'PTF_VAR_TAG_MAP' tabkey = key_map_tag  lang = sy-langu ).
      ko200 = VALUE #( pgmid = 'R3TR' object = 'TABU' obj_name = 'PTF_VAR_TAG_MAP' objfunc = 'K' lang = sy-langu ).
      go_transport->add_transport_entries(
        EXPORTING
          e071k = e071k
          ko200 = ko200
      ).
    ENDLOOP.

    cl_ptf_variant_tag_manager=>delete_tags_for_variant( variant = iv_varname ).
  ENDMETHOD.


  METHOD enrich_with_expmess_data.

    "Fill member itab exp_messages in lines of CT_VARIANT_TAB. Source is IT_EXPMESS.

    DATA lt_expmess         TYPE gty_varexpmess.
    DATA lt_expmess_of_step TYPE gty_varexpmess.

    lt_expmess = it_expmess.
    CHECK lt_expmess     IS NOT INITIAL.
    CHECK ct_variant_tab IS NOT INITIAL.

    DATA(lv_prev_step) = lt_expmess[ 1 ]-step_number.

    LOOP AT lt_expmess ASSIGNING FIELD-SYMBOL(<ls_expmess>).

      DATA(lv_step) = <ls_expmess>-step_number.
      IF lv_step NE lv_prev_step.
        "New group, add collected group
        READ TABLE ct_variant_tab INDEX lv_prev_step ASSIGNING FIELD-SYMBOL(<ls_step>).   "move-corr does not work with index [i], use Read Table, then move-corr
        MOVE-CORRESPONDING lt_expmess_of_step TO <ls_step>-exp_messages.   "from db format to internal format
        CLEAR lt_expmess_of_step.
      ENDIF.
      APPEND <ls_expmess> TO lt_expmess_of_step.  "still in db format
      lv_prev_step = lv_step.

    ENDLOOP.

    "Add last group
    READ TABLE ct_variant_tab INDEX lv_step ASSIGNING <ls_step>.
    MOVE-CORRESPONDING lt_expmess_of_step TO <ls_step>-exp_messages.

  ENDMETHOD.


  METHOD enrich_with_varref_data.

    "Fill member itab reference_step in lines of CT_VARIANT_TAB. Source is IT_VARREF.

    DATA lt_varref        TYPE gty_ptf_varref.
    DATA lt_ref_tab       TYPE STANDARD TABLE OF i.
    DATA lv_with_index    TYPE abap_bool.

    CHECK it_varref IS NOT INITIAL.

    lt_varref = it_varref.


    "Support both a variant with old records (ref_index initial) as well as a variant with new records (ref_index > 0). These cases require deviating SORT keys (use REF_INDEX in sort or not).

    LOOP AT lt_varref TRANSPORTING NO FIELDS  WHERE ref_index NE 0.
      lv_with_index = abap_true.
      EXIT.
    ENDLOOP.

    LOOP AT lt_varref TRANSPORTING NO FIELDS  WHERE ref_index EQ 0.
      ASSERT lv_with_index IS INITIAL.  "Open an incident for ACH Component SD-PTF, and include the name of the PTF script
      "Can never happen for always transported scripts, but in theory when a transported script has updated a manually created script
      EXIT.
    ENDLOOP.

    IF lv_with_index IS INITIAL.
      SORT lt_varref STABLE  ASCENDING BY step_number.
    ELSE.
      SORT lt_varref BY mandt varname step_number ref_index.
    ENDIF.

    "LOGIC

    DATA(lv_prev_step) = lt_varref[ 1 ]-step_number.

    LOOP AT lt_varref ASSIGNING FIELD-SYMBOL(<ls_varref>).

      DATA(lv_tabix) = sy-tabix.
      DATA(lv_step) = <ls_varref>-step_number.
      IF lv_step NE lv_prev_step.
        "New group
        ct_variant_tab[ lv_prev_step ]-reference_step = lt_ref_tab.
        CLEAR lt_ref_tab.
      ENDIF.
      APPEND <ls_varref>-reference_step TO lt_ref_tab.
      "End of last group
      IF lv_tabix = lines( lt_varref ).
        ct_variant_tab[ lv_step ]-reference_step = lt_ref_tab.
      ENDIF.

      lv_prev_step = lv_step.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_date.

    "July 2021: we use system time - not user time

    rv_result = sy-datum.

  ENDMETHOD.


  METHOD get_time.

    rv_result = sy-uzeit.

  ENDMETHOD.


  METHOD get_where_clause_for_read.

  types:
    BEGIN OF lty_where,
        fieldname TYPE fieldname,
        value     TYPE value,
      END OF lty_where .
  types:
    lty_where_tab TYPE STANDARD TABLE OF lty_where WITH DEFAULT KEY .

    DATA ls_where TYPE lty_where.
    DATA lt_where TYPE lty_where_tab.
    DATA: lr_descr      TYPE REF TO cl_abap_structdescr,
          ls_components TYPE abap_compdescr.
    DATA lv_where TYPE gty_cond.

    CONSTANTS lc_escape   TYPE c VALUE '@'.
    CONSTANTS lc_descr(2) TYPE c VALUE 'P~'.
    CONSTANTS lc_var(2)   TYPE c VALUE 'C~'.

    lr_descr ?= cl_abap_typedescr=>describe_by_data( is_sel_param ).
    LOOP AT lr_descr->components INTO ls_components.
      ASSIGN COMPONENT ls_components-name OF STRUCTURE is_sel_param TO FIELD-SYMBOL(<ls_value>).
      IF <ls_value> IS NOT INITIAL.
        ls_where-value    = <ls_value>.  "too short, local data loss. no problem currently as <ls_where>-value is only used in this method for comparison CA '*'
        ls_where-fieldname = ls_components-name.

        APPEND ls_where TO lt_where.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_where ASSIGNING FIELD-SYMBOL(<ls_where>).
      IF ( <ls_where>-fieldname = 'USER_SPECIFIC' AND is_sel_param-user_specific = 'c' )
        OR ( <ls_where>-value CA '*' AND <ls_where>-fieldname NE 'SCOPE_ITEM' AND <ls_where>-fieldname NE 'TAG' AND <ls_where>-fieldname NE 'LAST_CHANGE_USER' ).  "to ignore in this method all parameters with '*'
        DELETE lt_where INDEX sy-tabix.
      ELSE.
        DATA(lv_value_for_concat) = <ls_where>-fieldname.

        "Add table prefix
        IF <ls_where>-fieldname NE 'VARDESCR'.
          CONCATENATE lc_var <ls_where>-fieldname INTO <ls_where>-fieldname.
        ELSE.
          <ls_where>-fieldname = 'VTEXT'.
          CONCATENATE lc_descr <ls_where>-fieldname INTO <ls_where>-fieldname.
        ENDIF.

        IF <ls_where>-fieldname NE 'C~TAG'.
          CONCATENATE lc_escape 'LS_SEL_PARAM-' lv_value_for_concat INTO DATA(lv_value).
          CONCATENATE <ls_where>-fieldname 'EQ' lv_value INTO lv_where SEPARATED BY space.
        ELSE.
          CONCATENATE 'T~TAG' 'EQ' '@LS_SEL_PARAM-TAG' INTO lv_where SEPARATED BY space.
        ENDIF.

        IF <ls_where>-value CA '*'.
          REPLACE 'EQ' INTO lv_where WITH 'LIKE'.
        ENDIF.

        IF sy-tabix = 1.
          APPEND lv_where TO et_where.
        ELSE.
          CONCATENATE 'AND' lv_where INTO lv_where SEPARATED BY space.
          APPEND lv_where TO et_where.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD is_empty.

    DATA lv_alv_is_filled TYPE abap_bool.

    CLEAR lv_alv_is_filled.
    LOOP AT it_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data>).
      IF <ls_step_data>-bus_obj IS NOT INITIAL.
        lv_alv_is_filled = abap_true.
      ENDIF.
    ENDLOOP.

    IF lv_alv_is_filled EQ abap_false.
      rv_result = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD is_in_customer_namespace.

    "TODO: move lines to method is_first_letter_customer_namespace, add unit tests; remove iv_name and iv_2nd_name

    "returns TRUE, if at least one of the importing parameters starts with Y or Z

    CLEAR rv_result.

    IF iv_varname IS NOT INITIAL.

      IF matches( val = iv_varname  regex = '[YZ].*' ).
        rv_result = abap_true.
        RETURN.
      ENDIF.

    ENDIF.

    IF iv_tag IS NOT INITIAL.

      IF matches( val = iv_tag  regex = '[YZ].*' ).
        rv_result = abap_true.
        RETURN.
      ENDIF.

    ENDIF.

    IF iv_name IS NOT INITIAL.

      IF matches( val = iv_name  regex = '[YZ].*' ).
        rv_result = abap_true.
        RETURN.
      ENDIF.

    ENDIF.

    IF iv_2nd_name IS NOT INITIAL.

      IF matches( val = iv_2nd_name  regex = '[YZ].*' ).
        rv_result = abap_true.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD is_maintnce_here_allowed_for.

    " -Z scripts can be maintained everywhere
    " -in home dev clients, also standard scripts can be maintained
    " -special case: if iv_varname is initial, return false

    CLEAR rv_result.

    CHECK iv_varname IS NOT INITIAL.

    DATA(lo_client) = NEW cl_ptf_client( ). "toDo: DoC must be a member variable

    IF is_in_customer_namespace( iv_varname = iv_varname )
      OR lo_client->am_i_in_homedevclient( ).

      rv_result = abap_true.

    ENDIF.

  ENDMETHOD.


  METHOD prepare_text.

    DATA ls_varcat TYPE ptf_text.
    DATA lt_varcat TYPE STANDARD TABLE OF ptf_text.

    CLEAR et_var_text.

    LOOP AT it_varcat ASSIGNING FIELD-SYMBOL(<ls_varcat>).
      CLEAR ls_varcat.
      ls_varcat = <ls_varcat>-text.
      IF ls_varcat IS NOT INITIAL.
        APPEND ls_varcat TO lt_varcat.
      ENDIF.
    ENDLOOP.

    et_var_text = lt_varcat.

  ENDMETHOD.


  METHOD read.

    "Fills the et_* parameters, AND gs_version

    DATA ls_version TYPE gty_version.
    DATA lt_ptf_varcon TYPE STANDARD TABLE OF ptf_varcon WITH DEFAULT KEY.
    DATA lt_ptf_varref TYPE gty_ptf_varref.
    DATA lt_ptf_varcat TYPE STANDARD TABLE OF ptf_varcat.

    CLEAR: et_variant_tab, et_varcat.
    CLEAR gs_version.

    SELECT SINGLE script_version, src_system, modif_system FROM ptf_varid INTO CORRESPONDING FIELDS OF @ls_version WHERE varname = @iv_varname.
    IF sy-subrc = 0.

      gs_version = ls_version.  "export to member variable

      SELECT * FROM ptf_varcon INTO TABLE lt_ptf_varcon WHERE varname = iv_varname.
      IF sy-subrc = 0.

        LOOP AT lt_ptf_varcon ASSIGNING FIELD-SYMBOL(<step>) WHERE script_version NE ls_version-script_version OR src_system NE ls_version-src_system.
          DATA(lv_varcon_not_consistent) = abap_true.
          EXIT.
        ENDLOOP.
        DELETE lt_ptf_varcon WHERE script_version NE ls_version-script_version OR src_system NE ls_version-src_system.
        SORT lt_ptf_varcon ASCENDING BY step_number.
        MOVE-CORRESPONDING lt_ptf_varcon TO et_variant_tab.

        "VARREF
        SELECT * FROM ptf_varref INTO CORRESPONDING FIELDS OF TABLE lt_ptf_varref WHERE varname = iv_varname .
        IF sy-subrc = 0.

          LOOP AT lt_ptf_varref ASSIGNING FIELD-SYMBOL(<ls_varref>) WHERE script_version NE ls_version-script_version OR src_system NE ls_version-src_system.
            DATA(lv_varref_not_consistent) = abap_true.
            EXIT.
          ENDLOOP.
          DELETE lt_ptf_varref WHERE script_version NE ls_version-script_version OR src_system NE ls_version-src_system.
          enrich_with_varref_data(
            EXPORTING
              it_varref      = lt_ptf_varref
            CHANGING
              ct_variant_tab = et_variant_tab
               ).

        ENDIF.

      ENDIF.

    ENDIF.


    TRY.
        SELECT * FROM ptf_varcat INTO CORRESPONDING FIELDS OF TABLE lt_ptf_varcat WHERE varname = iv_varname.
        IF sy-subrc = 0.
          SORT lt_ptf_varcat BY step_number ASCENDING.
          prepare_text(
            EXPORTING
              it_varcat   = lt_ptf_varcat
            IMPORTING
              et_var_text = et_varcat
          ).
        ENDIF.
      CATCH cx_root.
    ENDTRY.


    "VAREXPMESS
    DATA lt_expmess TYPE gty_varexpmess.
    SELECT * FROM ptf_varexpmess INTO TABLE @lt_expmess WHERE varname = @iv_varname ORDER BY PRIMARY KEY.

    enrich_with_expmess_data(
      EXPORTING
        it_expmess     = lt_expmess
      CHANGING
        ct_variant_tab = et_variant_tab
    ).

    "VARDATASET
    SELECT * FROM ptf_vardataset INTO TABLE @et_vardataset WHERE varname = @iv_varname ORDER BY PRIMARY KEY.

  ENDMETHOD.


  METHOD read_for_selection.

    DATA lt_sel_tab TYPE STANDARD TABLE OF gty_ptf_variant.
    DATA lt_where TYPE gty_cond_tab.
    DATA lt_search_tab_filtered TYPE gty_ptf_variant_tab.

    CLEAR et_selection_tab.

    IF is_sel_param IS INITIAL.

      "no parameters given, select all existing variants
      SELECT DISTINCT c~varname, p~vtext, c~ernam, c~erdat, c~user_specific, c~scope_item, c~last_change_user, c~last_change_date
             FROM ( ptf_varid AS c
                LEFT OUTER JOIN ptf_varid_t AS p ON p~varname   = c~varname
                LEFT OUTER JOIN ptf_var_tag_map AS t ON p~varname = t~varname )
              INTO CORRESPONDING FIELDS OF TABLE @lt_sel_tab.
      SORT lt_sel_tab BY  varname.
      et_selection_tab = lt_sel_tab.

    ELSE.
*      IF  is_sel_param-vardescr IS NOT INITIAL
*          AND is_sel_param-varname IS INITIAL
*          AND is_sel_param-erdat IS INITIAL
*          AND is_sel_param-ernam   IS INITIAL
*          AND is_sel_param-user_specific IS INITIAL.
*        TRY.
*            SELECT c~varname, p~vtext, c~ernam, c~erdat, c~user_specific
*                  FROM ( ptf_varid_t AS p
*                     INNER JOIN ptf_varid AS c ON p~varname   = c~varname )
*                   INTO CORRESPONDING FIELDS OF TABLE @lt_sel_tab WHERE c~varname = @is_sel_param-varname OR p~vtext = @is_sel_param-vardescr OR c~ernam = @is_sel_param-ernam OR c~erdat = @is_sel_param-erdat.
*
*            lt_search_tab = lt_sel_tab.
*            me->search(
*              EXPORTING
*                is_sel_param     = is_sel_param
*                it_variant_tab   = lt_search_tab
*              IMPORTING
*                et_selection_tab = lt_search_tab
*            ).
*            "c~varname = @is_sel_param-varname OR vtext = @is_sel_param-vardescr OR c~ernam = @is_sel_param-ernam OR c~erdat = @is_sel_param-erdat .
*          CATCH cx_root.
*        ENDTRY.
*        IF lt_search_tab IS NOT INITIAL.
*          et_selection_tab = lt_search_tab.
*        ELSE.
*          et_selection_tab = lt_sel_tab.
*        ENDIF.
*
*        et_selection_tab = lt_sel_tab.
*
*
*
*      ELSE.

      "build where clause, use EQ for full values and LIKE for parameters with '*'. For most parameters, records with '*' are ignored.
      me->get_where_clause_for_read( EXPORTING
                              is_sel_param = is_sel_param
                            IMPORTING
                              et_where     = lt_where
      ).

      DATA(ls_sel_param) = is_sel_param.
      REPLACE ALL OCCURRENCES OF '*' IN ls_sel_param WITH '%'.


      TRY.
          "SELECT matching records from db, into lt_sel_tab
          SELECT DISTINCT c~varname, p~vtext, c~ernam, c~erdat, c~user_specific, c~scope_item, c~last_change_user, c~last_change_date
                 FROM ( ptf_varid AS c
                    LEFT OUTER JOIN ptf_varid_t AS p ON p~varname   = c~varname
                    LEFT OUTER JOIN ptf_var_tag_map AS t ON p~varname = t~varname )
                      INTO CORRESPONDING FIELDS OF TABLE @lt_sel_tab WHERE (lt_where) ORDER BY c~varname ASCENDING.

          DELETE ADJACENT DUPLICATES FROM lt_sel_tab.

          IF is_sel_param-user_specific = 'c'.
            DELETE lt_sel_tab WHERE user_specific EQ abap_true.
          ENDIF.


          "copy lt_sel_tab into lt_search_tab_filtered and filter it with parameter values having '*'
          lt_search_tab_filtered = lt_sel_tab.
          me->search(    "removes records from lt_search_tab that do not match possible '*' values in varname, vardescr, ernam
                         "lt_search_tab_filtered is empty afterwards if there isn't a value with '*' in at least one of the 3 fields
                         "only in this method gv_search is changed    gv_search EQ true means: search( ) has reduced the itab (but clearing the itab completely (when no '*' is there) is not reflected in gv_search
            EXPORTING
              is_sel_param     = is_sel_param
              it_variant_tab   = lt_search_tab_filtered
            IMPORTING
              et_selection_tab = lt_search_tab_filtered
          ).
          "c~varname = @is_sel_param-varname OR vtext = @is_sel_param-vardescr OR c~ernam = @is_sel_param-ernam OR c~erdat = @is_sel_param-erdat .
        CATCH cx_root.
      ENDTRY.
      IF lt_search_tab_filtered IS NOT INITIAL.
        et_selection_tab = lt_search_tab_filtered. "there are 1-x records left, use them
      ELSEIF lt_search_tab_filtered IS INITIAL AND gv_search = abap_true.
        et_selection_tab = lt_search_tab_filtered. "nothing left after applied filtering, it is correct to have no result
      ELSE.
        et_selection_tab = lt_sel_tab.   "nothing left after filtering method, but no filtering applied -> return result before filtering (is this fixing the bug in search( ) ? why not just always fill et_ in search( ) ?
      ENDIF.
    ENDIF.


    "Enrich column TAG of ET_SELECTION_TAB

    SELECT ptf_var_tag~tag, ptf_var_tag_map~varname, ptf_var_tag~creator, ptf_var_tag~visibility
      FROM ptf_var_tag
      LEFT OUTER JOIN ptf_var_tag_map ON ptf_var_tag~tag = ptf_var_tag_map~tag
      FOR ALL ENTRIES IN @et_selection_tab
      WHERE ptf_var_tag_map~varname = @et_selection_tab-varname
      AND ( ptf_var_tag~visibility = 'PUBLIC' OR ptf_var_tag~creator = @et_selection_tab-ernam )
      INTO TABLE @DATA(lt_tags).
    SORT lt_tags BY tag ASCENDING.

    LOOP AT et_selection_tab ASSIGNING FIELD-SYMBOL(<ls_selection>).
      LOOP AT lt_tags ASSIGNING FIELD-SYMBOL(<ls_tag>) WHERE varname = <ls_selection>-varname AND
                                                            ( visibility = 'PUBLIC' OR
                                                              creator = <ls_selection>-ernam ).
        IF <ls_tag>-tag IS NOT INITIAL.
          IF <ls_selection>-tag IS INITIAL.
            <ls_selection>-tag = <ls_tag>-tag.
          ELSE.
            CONCATENATE <ls_selection>-tag ',' <ls_tag>-tag INTO <ls_selection>-tag.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.


  METHOD read_src_system_for.

    SELECT SINGLE src_system FROM ptf_varid INTO @rv_src_system WHERE varname = @iv_varname.

    IF sy-subrc IS INITIAL.
      RAISE EXCEPTION NEW cx_ptf_variant_not_found( ).
    ENDIF.

  ENDMETHOD.


  METHOD save.

    "Calculate version fields

    DATA(lv_current_sysid) = sy-sysid.

    DATA(ls_version_new) = build_version_data(
       EXPORTING
         iv_update        = iv_update
         iv_current_sysid = lv_current_sysid
         is_version_old   = gs_version
     ).

    "Remember the version data of the soon persisted script (gs_version is filled in READ and here in SAVE)
    gs_version           = ls_version_new.


    go_transport = cl_ptf_transport=>factory( ).

    CALL METHOD me->save_ptf_varid      "adds also transport entry
      EXPORTING
        iv_varname       = iv_varname
        iv_user_specific = iv_user_specific
        iv_scope_item    = iv_scope_item
        iv_update        = iv_update
        is_version       = ls_version_new
      IMPORTING
        es_ptf_varid     = DATA(ls_ptf_varid).

    CALL METHOD me->save_ptf_varid_t    "adds also transport entry
      EXPORTING
        iv_varname    = iv_varname
        iv_vardescr   = iv_vardescr
      IMPORTING
        es_varid_text = DATA(ls_ptf_varid_t).

    CALL METHOD me->save_ptf_varcon     "adds also transport entry
      EXPORTING
        it_variant_tab = it_variant_tab
        iv_varname     = iv_varname
        is_version     = ls_version_new
      IMPORTING
        et_varcon      = DATA(lt_ptf_varcon).

    CALL METHOD me->save_ptf_varref     "adds also transport entry
      EXPORTING
        it_variant_tab = it_variant_tab
        iv_varname     = iv_varname
        is_version     = ls_version_new
      IMPORTING
        et_varref      = DATA(lt_ptf_varref).

    CALL METHOD me->save_ptf_varcat     "adds also transport entries
      EXPORTING
        it_vartext = it_vartext
        iv_varname = iv_varname
      IMPORTING
        et_varcat  = DATA(lt_ptf_varcat).

    CALL METHOD me->save_ptf_varexpmess  "adds transport entry for table PTF_VAREXPMESS
      EXPORTING
        it_variant_tab = it_variant_tab
        iv_varname     = iv_varname
      IMPORTING
        et_varexpmess  = DATA(lt_ptf_varexpmess).

    CALL METHOD me->save_ptf_vardataset  "adds transport entry for table PTF_VARDATASET
      EXPORTING
        iv_varname    = iv_varname
        it_vardataset = it_vardataset
      IMPORTING
        et_vardataset = DATA(lt_vardataset).

*********************************************************************************
    CALL FUNCTION 'PTF_INSERT_DB'
      EXPORTING
        is_ptf_varid      = ls_ptf_varid
        is_ptf_varid_t    = ls_ptf_varid_t
        it_ptf_varref     = lt_ptf_varref
        it_ptf_varcon     = lt_ptf_varcon
        it_ptf_varcat     = lt_ptf_varcat
        it_ptf_varexpmess = lt_ptf_varexpmess
        it_ptf_vardataset = lt_vardataset.

    IF it_tags IS NOT INITIAL.
      me->save_ptf_tags(
        EXPORTING
          varname        = iv_varname
          tags           = it_tags
      ).
    ENDIF.

  ENDMETHOD.


  METHOD save_ptf_tags.

    "saves the mapping of Tags to the current variant, not the Tag itself

    DATA: ptf_tag_maps TYPE TABLE OF ptf_var_tag_map,
          e071k        TYPE e071k,
          ko200        TYPE ko200.

    LOOP AT tags ASSIGNING FIELD-SYMBOL(<tag>).
      APPEND VALUE #( tag = <tag> varname = varname ) TO ptf_tag_maps.
    ENDLOOP.
    INSERT ptf_var_tag_map FROM TABLE ptf_tag_maps.

    "<<<<<<<<<<< the following loop is identical to the one in CL_PTF_VARIANT_TAG_MANAGER-TRANSPORT_PTF_VAR_TAG_MAPS( ). should be centralized
    LOOP AT ptf_tag_maps ASSIGNING FIELD-SYMBOL(<tag_map_entry>).
      IF NOT me->is_in_customer_namespace( iv_tag = <tag_map_entry>-tag iv_varname = <tag_map_entry>-varname ).
        CLEAR e071k.
        CLEAR ko200.
        DATA(key_map_tag) = |{ sy-mandt WIDTH = 3 }{ <tag_map_entry>-tag WIDTH = 80 }{ <tag_map_entry>-varname WIDTH = 31 }|.
        e071k = VALUE #( pgmid = 'R3TR' object = 'TABU' objname = 'PTF_VAR_TAG_MAP'  mastertype = 'TABU' mastername = 'PTF_VAR_TAG_MAP' tabkey = key_map_tag  lang = sy-langu ).
        ko200 = VALUE #( pgmid = 'R3TR' object = 'TABU' obj_name = 'PTF_VAR_TAG_MAP' objfunc = 'K' lang = sy-langu ).
        go_transport->add_transport_entries(
          EXPORTING
            e071k = e071k
            ko200 = ko200
        ).
      ENDIF.
    ENDLOOP.
    ">>>>>>>>>>>

  ENDMETHOD.


  METHOD save_ptf_varcat.

    DATA: ls_varcat     TYPE ptf_varcat,
          lv_key        TYPE string,
          lv_table_name TYPE string.

    CLEAR et_varcat.

    DATA(lv_index) = 1.
    ls_varcat-varname = iv_varname.
    ls_varcat-mandt   = sy-mandt.

    LOOP AT it_vartext ASSIGNING FIELD-SYMBOL(<ls_vartext>).
      IF <ls_vartext> IS NOT INITIAL.
        ls_varcat-step_number = lv_index.
        ls_varcat-text = <ls_vartext>.
        APPEND ls_varcat TO et_varcat.
        ADD 1 TO lv_index.
      ENDIF.
    ENDLOOP.

    LOOP AT et_varcat INTO DATA(ls_ptf_varcat).
      CLEAR: lv_key, lv_table_name.
      CONCATENATE sy-mandt iv_varname ls_ptf_varcat-step_number INTO lv_key RESPECTING BLANKS.
      lv_table_name = 'PTF_VARCAT'.
      go_transport->set_transport_entries(
        EXPORTING
          iv_key        = lv_key
          iv_table_name = lv_table_name ).
    ENDLOOP.

  ENDMETHOD.


  METHOD save_ptf_varcon.

    DATA: ls_ptf_varcon TYPE ptf_varcon,
          lv_key        TYPE string,
          lv_table_name TYPE string.

    CLEAR et_varcon.

    ls_ptf_varcon-varname        = iv_varname.
    ls_ptf_varcon-mandt          = sy-mandt.
    ls_ptf_varcon-script_version = is_version-script_version.
    ls_ptf_varcon-src_system     = is_version-src_system.

    LOOP AT it_variant_tab ASSIGNING FIELD-SYMBOL(<ls_variant>).
      DATA(lv_index) = sy-tabix.
      IF <ls_variant>-bus_obj IS NOT INITIAL
      OR <ls_variant>-action IS NOT INITIAL.
        ls_ptf_varcon-step_number = lv_index.
        ls_ptf_varcon-bus_obj     = <ls_variant>-bus_obj.
        ls_ptf_varcon-action      = <ls_variant>-action.
        ls_ptf_varcon-variant     = <ls_variant>-variant.
        ls_ptf_varcon-test_data_container = <ls_variant>-test_data_container.
        ls_ptf_varcon-input_string        = <ls_variant>-input_string.
        APPEND ls_ptf_varcon TO et_varcon.
      ENDIF.
    ENDLOOP.

    CLEAR ls_ptf_varcon.
    LOOP AT et_varcon INTO ls_ptf_varcon.
      CLEAR: lv_key, lv_table_name.
      CONCATENATE sy-mandt iv_varname ls_ptf_varcon-step_number INTO lv_key RESPECTING BLANKS.
      lv_table_name = 'PTF_VARCON'.
      go_transport->set_transport_entries(
        EXPORTING
          iv_key        = lv_key
          iv_table_name = lv_table_name ).
    ENDLOOP.

  ENDMETHOD.


  METHOD save_ptf_vardataset.
    "Transport

    DATA: lv_key        TYPE string,
          lv_table_name TYPE string.

    CLEAR et_vardataset.

    CHECK it_vardataset IS NOT INITIAL.

    et_vardataset = it_vardataset.

    LOOP AT et_vardataset ASSIGNING FIELD-SYMBOL(<fs_vardataset>).
      <fs_vardataset>-varname = iv_varname.

    ENDLOOP.

    CONCATENATE sy-mandt iv_varname '*' INTO lv_key.  "'*' is added after the last filled char of the script name
    lv_table_name = 'PTF_VARDATASET'.
    go_transport->set_transport_entries(
      EXPORTING
        iv_key        = lv_key
        iv_table_name = lv_table_name ).

  ENDMETHOD.


  METHOD save_ptf_varexpmess.

    DATA ls_expmess    TYPE ptf_varexpmess.  "db format

    CLEAR et_varexpmess.

    "Create single itab with db format. Enrich db key fields.

    LOOP AT it_variant_tab ASSIGNING FIELD-SYMBOL(<ls_variant>) WHERE bus_obj EQ 'PTF_RUN' AND action EQ 'CHECK_MESSAGES'.
      DATA(lv_step_no) = sy-tabix.

      LOOP AT <ls_variant>-exp_messages ASSIGNING FIELD-SYMBOL(<ls_record>).
        DATA(lv_mess_line_no) = sy-tabix.

        CLEAR ls_expmess.
        MOVE-CORRESPONDING <ls_record> TO ls_expmess.
        ls_expmess-mandt   = sy-mandt.
        ls_expmess-varname = iv_varname.
        ls_expmess-step_number   = lv_step_no.
        ls_expmess-line_number   = lv_mess_line_no.
        APPEND ls_expmess TO et_varexpmess.

      ENDLOOP.

    ENDLOOP.


    "Transport

    DATA: lv_key        TYPE string,
          lv_table_name TYPE string.

    CHECK et_varexpmess IS NOT INITIAL.

    CONCATENATE sy-mandt iv_varname '*' INTO lv_key.  "'*' is added after the last filled char of the script name
    lv_table_name = 'PTF_VAREXPMESS'.
    go_transport->set_transport_entries(
      EXPORTING
        iv_key        = lv_key
        iv_table_name = lv_table_name ).

  ENDMETHOD.


  METHOD save_ptf_varid.

    CONSTANTS lc_script_language_version TYPE ptf_script_language_version VALUE '003'.      "value 003 since August 14, 2021

    CLEAR es_ptf_varid.

    es_ptf_varid-varname        = iv_varname.
    es_ptf_varid-mandt          = sy-mandt.
    es_ptf_varid-user_specific  = iv_user_specific.
    es_ptf_varid-scope_item     = iv_scope_item.

    es_ptf_varid-script_language_version = lc_script_language_version.
    es_ptf_varid-script_version = is_version-script_version.
    es_ptf_varid-src_system     = is_version-src_system.
    es_ptf_varid-modif_system   = is_version-modif_system.

    IF iv_update IS INITIAL.
      "for creation
      es_ptf_varid-ernam = sy-uname.
      es_ptf_varid-erdat = get_date( ).
      es_ptf_varid-erzet = get_time( ). "sy-uzeit.
    ELSE.
      "for update
      es_ptf_varid-ernam = gs_ptf_varid_old-ernam.
      es_ptf_varid-erdat = gs_ptf_varid_old-erdat.
      es_ptf_varid-erzet = gs_ptf_varid_old-erzet.
      es_ptf_varid-last_change_user = sy-uname.
      es_ptf_varid-last_change_date = get_date( ).
      es_ptf_varid-last_change_time = get_time( ). "sy-uzeit.
    ENDIF.


    DATA: lv_key        TYPE string,
          lv_table_name TYPE string.

    CONCATENATE sy-mandt iv_varname INTO lv_key RESPECTING BLANKS.
    lv_table_name = 'PTF_VARID'.
    go_transport->set_transport_entries(
      EXPORTING
        iv_key        = lv_key
        iv_table_name = lv_table_name ).

  ENDMETHOD.


  METHOD save_ptf_varid_t.

    DATA: lv_key        TYPE string,
          lv_table_name TYPE string.

    CLEAR es_varid_text.

    es_varid_text-varname = iv_varname.
    es_varid_text-vtext   = iv_vardescr.
    es_varid_text-langu   = sy-langu.
    es_varid_text-mandt   = sy-mandt.

    CONCATENATE sy-mandt es_varid_text-langu iv_varname INTO lv_key RESPECTING BLANKS.
    lv_table_name = 'PTF_VARID_T'.
    go_transport->set_transport_entries(
      EXPORTING
        iv_key        = lv_key
        iv_table_name = lv_table_name ).

  ENDMETHOD.


  METHOD save_ptf_varref.

    DATA: ls_ptf_varref TYPE ptf_varref,
          lt_ptf_varref TYPE gty_ptf_varref,
          lv_ref_index  TYPE n LENGTH 3,
          lv_key        TYPE string,
          lv_table_name TYPE string.

    CLEAR et_varref.

    "Build LT_PTF_VARREF reading IT_VARIANT_TAB
    ls_ptf_varref-mandt   = sy-mandt.
    ls_ptf_varref-varname = iv_varname.
    ls_ptf_varref-script_version = is_version-script_version.
    ls_ptf_varref-src_system     = is_version-src_system.
    "Steps
    LOOP AT it_variant_tab ASSIGNING FIELD-SYMBOL(<ls_varref>).
      ls_ptf_varref-step_number = sy-tabix.
      IF <ls_varref>-reference_step IS NOT INITIAL.
        CLEAR lv_ref_index.
        "Reference steps
        LOOP AT <ls_varref>-reference_step INTO DATA(lv_reference_step).
          ADD 1 TO lv_ref_index.
          ls_ptf_varref-ref_index      = lv_ref_index.
          ls_ptf_varref-reference_step = lv_reference_step.
          IF lv_reference_step IS NOT INITIAL AND lv_reference_step NE 0.
            APPEND ls_ptf_varref TO lt_ptf_varref.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDLOOP.


    LOOP AT lt_ptf_varref INTO DATA(ls_varref).
      CLEAR: lv_key, lv_table_name.
      CONCATENATE sy-mandt iv_varname ls_varref-step_number ls_varref-ref_index ls_varref-reference_step INTO lv_key RESPECTING BLANKS.
      lv_table_name = 'PTF_VARREF'.
      go_transport->set_transport_entries(
        EXPORTING
          iv_key        = lv_key
          iv_table_name = lv_table_name ).
    ENDLOOP.

    et_varref = lt_ptf_varref.

  ENDMETHOD.


  METHOD search.

    IF is_sel_param-varname CA '*' OR is_sel_param-vardescr CA '*' OR is_sel_param-ernam CA '*'.

      DATA(lt_sel_tab) = it_variant_tab.
      gv_search = abap_false.

      IF is_sel_param-varname CS '*'.
        SPLIT is_sel_param-varname AT '*' INTO TABLE DATA(lt_split_tab).
        LOOP AT lt_split_tab ASSIGNING FIELD-SYMBOL(<ls_split_tab>).
          DELETE lt_sel_tab WHERE varname NS <ls_split_tab>.
          gv_search = abap_true.
        ENDLOOP.
      ENDIF.

      CLEAR lt_split_tab.
      IF is_sel_param-vardescr CS '*'.
        SPLIT is_sel_param-vardescr AT '*' INTO TABLE lt_split_tab.
        LOOP AT lt_split_tab ASSIGNING <ls_split_tab>.
          DELETE lt_sel_tab WHERE vardescr NS <ls_split_tab>.
          gv_search = abap_true.
        ENDLOOP.
      ENDIF.

      CLEAR lt_split_tab.
      IF is_sel_param-ernam CS '*'.
        SPLIT is_sel_param-ernam AT '*' INTO TABLE lt_split_tab.
        LOOP AT lt_split_tab ASSIGNING <ls_split_tab>.
          DELETE lt_sel_tab WHERE ernam NS <ls_split_tab>.
          gv_search = abap_true.
        ENDLOOP.
      ENDIF.

    ENDIF.

    et_selection_tab = lt_sel_tab.

  ENDMETHOD.


  METHOD update.

* Deletes variant IV_VARNAME from DB and then saves IV_VARNAME_NEW (same or different name) to DB

    DATA:
      e071k                TYPE e071k,
      "tag_input            TYPE gty_tags,
      ko200                TYPE ko200,
      all_tags             TYPE gty_tags,
      user_tags            TYPE gty_tags,
      updated_ptf_tag_maps TYPE cl_ptf_variant_tag_manager=>ptf_var_tag_map_table.

    go_transport = cl_ptf_transport=>factory( ).

    SELECT SINGLE varname FROM ptf_varid  INTO @DATA(lv_varid_dummy)  WHERE varname = @iv_varname.
    CHECK sy-subrc IS INITIAL.


    "Tags
    IF iv_varname NE iv_varname_new.
      "delete entries in PTF_VAR_TAG_MAP for the old variant and transport that (if not in customer namespace)
      SELECT * FROM ptf_var_tag_map WHERE varname = @iv_varname INTO TABLE @DATA(changes). "better name: deletions
      cl_ptf_variant_tag_manager=>delete_tags_for_variant( variant = iv_varname ).
      "ToDo: the following loop is identical to the one at this method's end, and in methods SAVE_PTF_TAGS and CL_PTF_VARIANT_TAG_MANAGER-TRANSPORT_PTF_VAR_TAG_MAPS( ). should be centralized
      LOOP AT changes ASSIGNING FIELD-SYMBOL(<tag_map_entry>).
        APPEND <tag_map_entry>-tag TO all_tags.
        IF NOT me->is_in_customer_namespace( iv_tag = <tag_map_entry>-tag iv_varname = <tag_map_entry>-varname ).
          CLEAR e071k.
          CLEAR ko200.
          DATA(key_map_tag) = |{ sy-mandt WIDTH = 3 }{ <tag_map_entry>-tag WIDTH = 80 }{ <tag_map_entry>-varname WIDTH = 31 }|.
          e071k = VALUE #( pgmid = 'R3TR' object = 'TABU' objname = 'PTF_VAR_TAG_MAP'  mastertype = 'TABU' mastername = 'PTF_VAR_TAG_MAP' tabkey = key_map_tag  lang = sy-langu ).
          ko200 = VALUE #( pgmid = 'R3TR' object = 'TABU' obj_name = 'PTF_VAR_TAG_MAP' objfunc = 'K' lang = sy-langu ).
          go_transport->add_transport_entries(
            EXPORTING
              e071k = e071k
              ko200 = ko200  ).
        ENDIF.
        "APPEND <tag_map_entry>-tag TO tag_input.
      ENDLOOP.
    ENDIF.


    SELECT SINGLE
      ernam erdat erzet
      script_version src_system modif_system  "currently not evaluated, version fields can be removed from this select
      FROM ptf_varid
      INTO CORRESPONDING FIELDS OF gs_ptf_varid_old WHERE varname = iv_varname.

    me->delete( iv_varname ).   "includes  me->delete_ptf_tags( iv_varname = iv_varname ).

    me->save(
    "-consumes gs_ptf_varid_old in called method
    "-save() calls save_ptf_tags() but it_tags is not handed over here but save_ptf_tags() is called below directly
      EXPORTING
        it_variant_tab   = it_variant_tab
        iv_varname       = iv_varname_new
        iv_vardescr      = iv_vardescr_new
        iv_user_specific = iv_user_specific
        iv_scope_item    = iv_scope_item
        iv_update        = abap_true
        it_vartext       = it_vartext
        it_vardataset    = it_vardataset ).

    "Tags
    APPEND LINES OF it_tags TO user_tags.
    IF iv_varname NE iv_varname_new.
      "varname changed, user might have changed
      me->save_ptf_tags(
        EXPORTING
          varname        = iv_varname_new
          tags           = all_tags
      ).
      updated_ptf_tag_maps = cl_ptf_variant_tag_manager=>update_tags_by_var_and_user(
        EXPORTING
          user     = sy-uname
          varname  = iv_varname_new
        CHANGING
          tags     = user_tags
    ).
    ELSE.
      "varname unchanged, but user might have changed
      updated_ptf_tag_maps = cl_ptf_variant_tag_manager=>update_tags_by_var_and_user(
        EXPORTING
          user     = sy-uname
          varname  = iv_varname
        CHANGING
          tags     = user_tags
      ).
    ENDIF.
    LOOP AT updated_ptf_tag_maps ASSIGNING FIELD-SYMBOL(<tag_map_udpate>).
      IF NOT me->is_in_customer_namespace( iv_tag = <tag_map_udpate>-tag iv_varname = <tag_map_udpate>-varname ).
        CLEAR e071k.
        CLEAR ko200.
        key_map_tag = |{ sy-mandt WIDTH = 3 }{ <tag_map_udpate>-tag WIDTH = 80 }{ <tag_map_udpate>-varname WIDTH = 31 }|.
        e071k = VALUE #( pgmid = 'R3TR' object = 'TABU' objname = 'PTF_VAR_TAG_MAP'  mastertype = 'TABU' mastername = 'PTF_VAR_TAG_MAP' tabkey = key_map_tag  lang = sy-langu ).
        ko200 = VALUE #( pgmid = 'R3TR' object = 'TABU' obj_name = 'PTF_VAR_TAG_MAP' objfunc = 'K' lang = sy-langu ).
        go_transport->add_transport_entries(
          EXPORTING
            e071k = e071k
            ko200 = ko200
        ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD update_ptf_tags.

    DATA: maps_to_delete TYPE TABLE OF ptf_var_tag_map,
          maps_to_add    TYPE TABLE OF ptf_var_tag_map,
          changes        TYPE TABLE OF ptf_var_tag_map,
          e071k          TYPE e071k,
          ko200          TYPE ko200.

    SELECT * FROM ptf_var_tag_map WHERE varname = @varname INTO TABLE @DATA(ptf_tag_maps).

    LOOP AT tags ASSIGNING FIELD-SYMBOL(<tag>).
      TRY.
          DATA(entry_found) = ptf_tag_maps[ tag = <tag> ].
        CATCH cx_root.
          APPEND VALUE #( tag = <tag> varname = varname ) TO maps_to_add.
      ENDTRY.
    ENDLOOP.

    LOOP AT ptf_tag_maps ASSIGNING FIELD-SYMBOL(<old_tag>).
      TRY.
          entry_found = tags[ tag = <old_tag> ].
        CATCH cx_root.
          APPEND VALUE #( tag = <tag> varname = varname ) TO maps_to_delete.
      ENDTRY.
    ENDLOOP.


    DELETE ptf_var_tag_map FROM TABLE maps_to_delete.
    INSERT ptf_var_tag_map FROM TABLE maps_to_add.

    APPEND LINES OF maps_to_add TO changes.
    APPEND LINES OF maps_to_delete TO changes.

    LOOP AT changes ASSIGNING FIELD-SYMBOL(<tag_map_entry>).
      CLEAR e071k.
      CLEAR ko200.
      DATA(key_map_tag) = |{ sy-mandt WIDTH = 3 }{ <tag_map_entry>-tag WIDTH = 80 }{ <tag_map_entry>-varname WIDTH = 31 }|.
      e071k = VALUE #( pgmid = 'R3TR' object = 'TABU' objname = 'PTF_VAR_TAG_MAP'  mastertype = 'TABU' mastername = 'PTF_VAR_TAG_MAP' tabkey = key_map_tag  lang = sy-langu ).
      ko200 = VALUE #( pgmid = 'R3TR' object = 'TABU' obj_name = 'PTF_VAR_TAG_MAP' objfunc = 'K' lang = sy-langu ).
      go_transport->add_transport_entries(
        EXPORTING
          e071k = e071k
          ko200 = ko200
      ).
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
