CLASS cl_ptf_bo_billing_type DEFINITION
  PUBLIC
  INHERITING FROM cl_ptf_bo
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF gty_fkart,
        fkart TYPE tvfk-fkart,
      END OF gty_fkart .
    TYPES:
      gty_fkart_tab TYPE TABLE OF gty_fkart WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_check_bd_types,
        expected_bd_types TYPE gty_fkart_tab,
      END OF ty_check_bd_types .

    METHODS change
        REDEFINITION .
    METHODS check
        REDEFINITION .
    METHODS check_existence
        REDEFINITION .
    METHODS create
        REDEFINITION .
    METHODS delete
        REDEFINITION .
    METHODS execute_action
        REDEFINITION .
    METHODS execute_check
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS gc_check_billing_type TYPE string VALUE 'CHECK_ALL' ##NO_TEXT.
    CONSTANTS c_check_tvcpf_cbd2_missing TYPE string VALUE 'CHECK_TVCPF_CBD2_MISSING' ##NO_TEXT.
    CONSTANTS c_check_tvcpf_cbd2_deviating TYPE string VALUE 'CHECK_TVCPF_CBD2_DEVIATING' ##NO_TEXT.

    METHODS check_all
      IMPORTING
        !step_data           TYPE cl_ptf_util=>gt_ptf_step                                                                    "Parameter for better performance
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .
    METHODS check_tvcpf_cbd2_missing
      IMPORTING
        !step_data           TYPE cl_ptf_util=>gt_ptf_step
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .
    METHODS check_tvcpf_cbd2_deviating
      IMPORTING
        !step_data           TYPE cl_ptf_util=>gt_ptf_step
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .
ENDCLASS.



CLASS CL_PTF_BO_BILLING_TYPE IMPLEMENTATION.


  METHOD change.

  ENDMETHOD.


  METHOD check.

  ENDMETHOD.


  METHOD check_all.
    DATA: lt_fkart_db   TYPE HASHED TABLE OF gty_fkart WITH UNIQUE KEY fkart,
          lt_fkart_tdcv TYPE ty_check_bd_types,
          ls_fkart_db   TYPE REF TO gty_fkart,
          ls_fkart_tdcv TYPE REF TO gty_fkart,
          lb_mismatch   TYPE abap_bool VALUE abap_false,
          lv_lines_db   TYPE i,
          lv_lines_tdcv TYPE i.

    ev_check_status = abap_false.

    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
       es_testdata  = lt_fkart_tdcv ).

    SELECT fkart FROM tvfk INTO TABLE @lt_fkart_db
      WHERE fkart NE ''. "Do not selecht empty fkart; Sadly this billing type was inserted from an Aunit test

    ev_check_status = abap_true.
    LOOP AT lt_fkart_db ASSIGNING FIELD-SYMBOL(<fkart_db>).
      TRY.
          DATA(found_tdc_entry) = lt_fkart_tdcv-expected_bd_types[ fkart = <fkart_db> ].
        CATCH cx_root.
          ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement =  |Additional billing type { <fkart_db>-fkart } was defined| ).
      ENDTRY.
    ENDLOOP.

    LOOP AT lt_fkart_tdcv-expected_bd_types ASSIGNING FIELD-SYMBOL(<fkart_tdc>).
      TRY.
          DATA(found_db_entry) = lt_fkart_db[ fkart = <fkart_tdc>-fkart ].
        CATCH cx_root.
          "ev_check_status = abap_false.
          me->mo_run_environment->append_log( iv_log_statement = |Could not find billing type { <fkart_tdc>-fkart } in database.| ).
      ENDTRY.
    ENDLOOP.

    ev_execution_status = abap_true.

*    DESCRIBE TABLE lt_fkart_db LINES lv_lines_db.
*    DESCRIBE TABLE lt_fkart_tdcv-expected_bd_types LINES lv_lines_tdcv.
*    IF lv_lines_db > lv_lines_tdcv.
*      lb_mismatch = abap_true.
*      LOOP AT lt_fkart_db REFERENCE INTO ls_fkart_db.
*        READ TABLE lt_fkart_tdcv-expected_bd_types WITH TABLE KEY fkart = ls_fkart_db->* TRANSPORTING NO FIELDS.
*        IF sy-subrc <> 0.
*          me->mo_run_environment->append_log( iv_log_statement =  |Additional billing type { ls_fkart_db->fkart } was defined| ).
*        ENDIF.
*      ENDLOOP.
*
*    ELSEIF lv_lines_db < lv_lines_tdcv.
*      lb_mismatch = abap_true.
*      LOOP AT lt_fkart_tdcv-expected_bd_types REFERENCE INTO ls_fkart_tdcv.
*        READ TABLE lt_fkart_db WITH TABLE KEY fkart = ls_fkart_tdcv->* TRANSPORTING NO FIELDS.
*        IF sy-subrc <> 0.
*          me->mo_run_environment->append_log( iv_log_statement =  |Could not find billing type { ls_fkart_tdcv->fkart } in database.| ).
*        ENDIF.
*      ENDLOOP.
*
*    ELSEIF lv_lines_db = lv_lines_tdcv.
*      LOOP AT lt_fkart_tdcv-expected_bd_types REFERENCE INTO ls_fkart_tdcv.
*        READ TABLE lt_fkart_db WITH TABLE KEY fkart = ls_fkart_tdcv->* TRANSPORTING NO FIELDS.
*        IF sy-subrc <> 0.
*          "lb_mismatch = abap_true. "Mail from Fr 02.08.2019 07:26
*          me->mo_run_environment->append_log( iv_log_statement =  |Mismatch in billing types. Type { ls_fkart_tdcv->fkart } could not find in Database.| ).
*        ENDIF.
*      ENDLOOP.
*    ENDIF.
*
*    ev_execution_status = abap_true.
*    IF lb_mismatch = abap_false.
*      ev_check_status = abap_true.
*    ELSEIF lb_mismatch = abap_true.
*      ev_check_status = abap_false.
*    ENDIF.
  ENDMETHOD.


  METHOD check_existence.
  ENDMETHOD.


  METHOD check_tvcpf_cbd2_deviating.
    DATA:
      lt_fkart_tdc     TYPE ty_check_bd_types,
      lt_tvcpf         TYPE STANDARD TABLE OF tvcpf,
      lt_tvcpf_cbd2    TYPE STANDARD TABLE OF tvcpf,
      lt_tvcpf_rest    TYPE STANDARD TABLE OF tvcpf,
      lt_tvcpf_missing TYPE STANDARD TABLE OF tvcpf.
*
*************************************************************************************************************************
**   1. Step: Get Testdata
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = lt_fkart_tdc
    ).

************************************************************************************************************************
**   2. Step: Execute check
    ev_check_status = abap_true.

    SELECT * FROM tvcpf INTO TABLE lt_tvcpf
                        FOR ALL ENTRIES IN lt_fkart_tdc-expected_bd_types
                        WHERE fkarn = lt_fkart_tdc-expected_bd_types-fkart
                        ORDER BY PRIMARY KEY.

    LOOP AT lt_tvcpf REFERENCE INTO DATA(lo_tvcpf).

      IF lo_tvcpf->auarv = 'TA'.
        lo_tvcpf->auarv = 'OR'.
      ENDIF.

      IF lo_tvcpf->fkarn EQ 'CBD2'.
        APPEND lo_tvcpf->* TO lt_tvcpf_cbd2.
      ELSE.
        APPEND lo_tvcpf->* TO lt_tvcpf_rest.
      ENDIF.

    ENDLOOP.

    LOOP AT lt_tvcpf_rest REFERENCE INTO DATA(lo_tvcpf_rest).
      DATA(lv_tabix) = sy-tabix.

      TRY.
          DATA(ls_matched_entry) = lt_tvcpf_cbd2[ auarv = lo_tvcpf_rest->auarv
                                                  lfarv = lo_tvcpf_rest->lfarv
                                                  fkarv = lo_tvcpf_rest->fkarv
                                                  pstyv = lo_tvcpf_rest->pstyv ].

          IF ls_matched_entry IS NOT INITIAL AND ls_matched_entry-auarv        NE lo_tvcpf_rest->auarv OR
                                       ls_matched_entry-lfarv                  NE lo_tvcpf_rest->lfarv OR
                                       ls_matched_entry-fkarv                  NE lo_tvcpf_rest->fkarv OR
                                       ls_matched_entry-pstyv                  NE lo_tvcpf_rest->pstyv OR
                                       ls_matched_entry-grbed                  NE lo_tvcpf_rest->grbed OR
                                       ls_matched_entry-grurk                  NE lo_tvcpf_rest->grurk OR
                                       ls_matched_entry-grurp                  NE lo_tvcpf_rest->grurp OR
                                       ls_matched_entry-gruko                  NE lo_tvcpf_rest->gruko OR
                                       ls_matched_entry-knprs                  NE lo_tvcpf_rest->knprs OR
                                       ls_matched_entry-plmin                  NE lo_tvcpf_rest->plmin OR
                                       ls_matched_entry-fkmgk                  NE lo_tvcpf_rest->fkmgk OR
                                       ls_matched_entry-posvo                  NE lo_tvcpf_rest->posvo OR
                                       ls_matched_entry-hineu                  NE lo_tvcpf_rest->hineu OR
                                       ls_matched_entry-pfkur                  NE lo_tvcpf_rest->pfkur OR
                                       ls_matched_entry-expim                  NE lo_tvcpf_rest->expim OR
                                       ls_matched_entry-ordnr_fi               NE lo_tvcpf_rest->ordnr_fi OR
                                       ls_matched_entry-xblnr_fi               NE lo_tvcpf_rest->xblnr_fi OR
                                       ls_matched_entry-prsqu                  NE lo_tvcpf_rest->prsqu OR
                                       ls_matched_entry-kvprs                  NE lo_tvcpf_rest->kvprs OR
                                       ls_matched_entry-pstyn                  NE lo_tvcpf_rest->pstyn OR
                                       ls_matched_entry-oiferp                 NE lo_tvcpf_rest->oiferp OR
                                       ls_matched_entry-oifeech                NE lo_tvcpf_rest->oifeech OR
                                       ls_matched_entry-grurp_2                NE lo_tvcpf_rest->grurp_2 OR
                                       ls_matched_entry-sdbil_grurp_routine_no NE lo_tvcpf_rest->sdbil_grurp_routine_no.

            APPEND ls_matched_entry TO lt_tvcpf_missing.

            IF lv_tabix EQ 1.
              me->mo_run_environment->append_log( iv_log_statement = 'The following CBD2 key combinations have deviating secondary values compared to their corresponding Billing Types:' ).
            ENDIF.

            me->mo_run_environment->append_log( iv_log_statement =
            |\| { ls_matched_entry-fkarn ALPHA = IN } \| { ls_matched_entry-auarv ALPHA = IN } \| { ls_matched_entry-lfarv ALPHA = IN } \| { ls_matched_entry-fkarv ALPHA = IN } \| { ls_matched_entry-pstyv ALPHA = IN } \|  deviates from corresponding {
            lo_tvcpf_rest->fkarn } entry | ).
            ev_check_status = abap_false.

          ENDIF.
        CATCH cx_sy_itab_line_not_found.
          CLEAR ls_matched_entry.
      ENDTRY.

    ENDLOOP.

  ENDMETHOD.


  METHOD check_tvcpf_cbd2_missing.
    DATA:
      lt_fkart_tdc     TYPE ty_check_bd_types,
      lt_tvcpf         TYPE STANDARD TABLE OF tvcpf,
      lt_tvcpf_cbd2    TYPE STANDARD TABLE OF tvcpf,
      lt_tvcpf_rest    TYPE STANDARD TABLE OF tvcpf,
      lt_tvcpf_missing TYPE STANDARD TABLE OF tvcpf,
      lv_count         TYPE i.
*
*************************************************************************************************************************
**   1. Step: Get Testdata
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
        es_testdata  = lt_fkart_tdc
    ).

************************************************************************************************************************
**   2. Step: Execute check
    ev_check_status = abap_true.
    lt_fkart_tdc-expected_bd_types = VALUE #( ( fkart = 'F2' ) ).

    SELECT * FROM tvcpf INTO TABLE lt_tvcpf
                        FOR ALL ENTRIES IN lt_fkart_tdc-expected_bd_types
                        WHERE fkarn = lt_fkart_tdc-expected_bd_types-fkart
                        ORDER BY PRIMARY KEY.

    LOOP AT lt_tvcpf REFERENCE INTO DATA(lo_tvcpf).

      IF lo_tvcpf->auarv = 'TA'.
        lo_tvcpf->auarv = 'OR'.
      ENDIF.

      IF lo_tvcpf->fkarn EQ 'CBD2'.
        APPEND lo_tvcpf->* TO lt_tvcpf_cbd2.
      ELSE.
        APPEND lo_tvcpf->* TO lt_tvcpf_rest.
      ENDIF.

    ENDLOOP.

    LOOP AT lt_tvcpf_rest REFERENCE INTO DATA(lo_tvcpf_rest).

      TRY.
          DATA(ls_matched_entry) = lt_tvcpf_cbd2[ auarv = lo_tvcpf_rest->auarv
                                                  lfarv = lo_tvcpf_rest->lfarv
                                                  fkarv = lo_tvcpf_rest->fkarv
                                                  pstyv = lo_tvcpf_rest->pstyv ].
        CATCH cx_sy_itab_line_not_found.
          lv_count = lv_count + 1.

          APPEND lo_tvcpf_rest->* TO lt_tvcpf_missing.
          DATA(ls_tvcpf_rest) = lo_tvcpf_rest->*.

          IF lv_count = 1.
            me->mo_run_environment->append_log( iv_log_statement = 'The following keys are not represented in copying control for Billing Type CBD2:' ).
          ENDIF.

          me->mo_run_environment->append_log( iv_log_statement =
          |\| { lo_tvcpf_rest->fkarn ALPHA = IN } \| { lo_tvcpf_rest->auarv ALPHA = IN } \| { lo_tvcpf_rest->lfarv ALPHA = IN } \| { lo_tvcpf_rest->fkarv ALPHA = IN } \| { lo_tvcpf_rest->pstyv ALPHA = IN } \|| ).
          ev_check_status = abap_false.

      ENDTRY.
    ENDLOOP.

  ENDMETHOD.


  METHOD create.
  ENDMETHOD.


  METHOD delete.

  ENDMETHOD.


  METHOD execute_action.

  ENDMETHOD.


  METHOD execute_check.
    DATA(lv_step_data) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).

    CASE lv_step_data-action.
      WHEN gc_check_billing_type.
        me->check_all(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN c_check_tvcpf_cbd2_missing.
        me->check_tvcpf_cbd2_missing(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN c_check_tvcpf_cbd2_deviating.
        me->check_tvcpf_cbd2_deviating(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
      WHEN OTHERS.
        me->mo_run_environment->append_log( iv_log_statement =  |Could not find method { lv_step_data-action } for the BO { lv_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
