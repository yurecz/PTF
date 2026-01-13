CLASS cl_ptf_bo_act_alloc DEFINITION
  PUBLIC
  INHERITING FROM cl_ptf_bo
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_gs_act_alloc_items,
        send_cctr  TYPE skost,
        acttype    TYPE lstar,
        actvty_qty TYPE lstxx,
        activityun TYPE co_meinh_l,
        price      TYPE bapitag,
        currency   TYPE waers,
        rec_wbs_el TYPE e_ps_posid,
      END OF ty_gs_act_alloc_items.
    TYPES:
      ty_gt_act_alloc_items TYPE STANDARD TABLE OF ty_gs_act_alloc_items WITH DEFAULT KEY.

    TYPES:
*Structure Activity Allocation Create
      BEGIN OF ty_gs_ptf_act_alloc_cr_td,
        header TYPE bapidochdrp,
        items  TYPE ty_gt_act_alloc_items,
      END OF ty_gs_ptf_act_alloc_cr_td.

    METHODS:
      create REDEFINITION,
      change REDEFINITION,
      delete REDEFINITION,
      check REDEFINITION,
      execute_action REDEFINITION,
      execute_check REDEFINITION,
      check_existence REDEFINITION.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS CL_PTF_BO_ACT_ALLOC IMPLEMENTATION.


  METHOD change.

  ENDMETHOD.


  METHOD check.

  ENDMETHOD.


  METHOD check_existence.

  ENDMETHOD.


  METHOD create.

    DATA: ls_testdata          TYPE ty_gs_ptf_act_alloc_cr_td,
          lt_customerproject   TYPE cl_ptf_util=>ty_vbeln_tab,
          lv_customerprojectid TYPE /cpd/mp_id.

    DATA: ls_doc_header TYPE bapidochdrp,
          ls_doc_item   TYPE bapiaaitm,
          lt_doc_item   TYPE TABLE OF bapiaaitm,
          lt_messages   TYPE TABLE OF bapiret2,
          lv_doc_no TYPE bapidochdrp-doc_no.

*************************************************************************

    ev_execution_status = abap_false.

    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    IF ls_step_data-variant IS NOT INITIAL.
      cl_ptf_util=>get_testdata(
        EXPORTING
          is_step_data = ls_step_data
        IMPORTING
          es_testdata  = ls_testdata
      ).
    ENDIF.

    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_customerproject.
    ENDLOOP.

    IF lines( lt_customerproject ) <> 1.
      me->mo_run_environment->append_log( iv_log_statement = |Only one customer project can be referenced.| ).
      RETURN.
    ENDIF.
    lv_customerprojectid = lt_customerproject[ 1 ].

*************************************************************************

    "Enrich testdata and fill header and item structure
    LOOP AT ls_testdata-items ASSIGNING FIELD-SYMBOL(<item>).
      CONCATENATE lv_customerprojectid '.0.' <item>-rec_wbs_el INTO <item>-rec_wbs_el.
      MOVE-CORRESPONDING <item> TO ls_doc_item.
      APPEND ls_doc_item TO lt_doc_item.
    ENDLOOP.

    DATA(lv_wbs_elmnt) = lt_doc_item[ 1 ]-rec_wbs_el.
    SELECT SINGLE pkokr FROM prps WHERE posid = @lv_wbs_elmnt INTO @DATA(lv_co_area).
    IF sy-subrc <> 0.
      me->mo_run_environment->append_log( iv_log_statement = |WBS Element { lv_wbs_elmnt } not found.| ).
      RETURN.
    ENDIF.

    ls_testdata-header-docdate = COND #( WHEN ls_testdata-header-docdate IS INITIAL THEN sy-datum ).
    ls_testdata-header-postgdate = COND #( WHEN ls_testdata-header-postgdate IS INITIAL THEN sy-datum ).
    ls_testdata-header-valuedate = COND #( WHEN ls_testdata-header-valuedate IS INITIAL THEN sy-datum ).
    ls_testdata-header-username = COND #( WHEN ls_testdata-header-username IS INITIAL THEN sy-uname ).
    MOVE-CORRESPONDING ls_testdata-header TO ls_doc_header.
    ls_doc_header-co_area = lv_co_area.

*************************************************************************

    CALL FUNCTION 'BAPI_ACC_ACTIVITY_ALLOC_POST'
      EXPORTING
        doc_header      = ls_doc_header
        ignore_warnings = 'X'
      IMPORTING
        doc_no          = lv_doc_no
      TABLES
        doc_items       = lt_doc_item
        return          = lt_messages.

    IF lv_doc_no IS INITIAL.
      LOOP AT lt_messages ASSIGNING FIELD-SYMBOL(<ls_msg>).
        IF <ls_msg>-type CO 'E'.
          me->mo_run_environment->append_log( iv_log_statement = |{ <ls_msg>-message }| ).
        ENDIF.
      ENDLOOP.
      RETURN.
    ELSE.
      ev_execution_status = abap_true.
      me->mo_run_environment->append_log( iv_log_statement = |Document { lv_doc_no } created.| ).

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.
    ENDIF.

  ENDMETHOD.


  METHOD delete.

  ENDMETHOD.


  METHOD execute_action.

  ENDMETHOD.


  METHOD execute_check.

  ENDMETHOD.
ENDCLASS.
