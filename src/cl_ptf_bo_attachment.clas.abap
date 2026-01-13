CLASS cl_ptf_bo_attachment DEFINITION
  PUBLIC
  INHERITING FROM cl_ptf_bo
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS create REDEFINITION .
    METHODS change REDEFINITION .
    METHODS delete REDEFINITION .
    METHODS check REDEFINITION .
    METHODS execute_action REDEFINITION .
    METHODS execute_check REDEFINITION .
    METHODS check_existence REDEFINITION.

    TYPES:
** Structure for Attachment Upload
      BEGIN OF ty_gs_i_ptf_attch_upload_td,
        mime_type     TYPE string,
        value_xstring TYPE xstring,
        value_cstring TYPE cstring,
        filename      TYPE filep,
      END OF ty_gs_i_ptf_attch_upload_td .

  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS gc_action_upload TYPE string VALUE 'UPLOAD' ##NO_TEXT.

    METHODS upload
      IMPORTING
        !step_data           TYPE        cl_ptf_util=>gt_ptf_step "Parameter for better performance
        !iv_step_number      TYPE i
      EXPORTING
        !ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        !ev_execution_status TYPE abap_bool
        !ev_check_status     TYPE abap_bool .
ENDCLASS.



CLASS CL_PTF_BO_ATTACHMENT IMPLEMENTATION.


  METHOD change.

  ENDMETHOD.


  METHOD check.

  ENDMETHOD.


  METHOD check_existence.
  ENDMETHOD.


  METHOD create.
  ENDMETHOD.


  METHOD delete.

  ENDMETHOD.


  METHOD execute_action.
    DATA(lv_step_data) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).

    CASE lv_step_data-action.
      WHEN gc_action_upload.
        me->upload(
          EXPORTING
            step_data           = lv_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).
        RETURN.
      WHEN OTHERS.
        me->mo_run_environment->append_log( iv_log_statement =  |Could not find method { lv_step_data-action } for the BO { lv_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.
    ENDCASE.

  ENDMETHOD.


  METHOD execute_check.

  ENDMETHOD.


  METHOD upload.

    TYPES:
      BEGIN OF ty_ls_object,
        objectkey  TYPE objky,
        objecttype TYPE dokob,
      END OF ty_ls_object,
      ty_lt_object TYPE STANDARD TABLE OF ty_ls_object.

    DATA: ls_object   TYPE ty_ls_object,
          ls_testdata TYPE ty_gs_i_ptf_attch_upload_td,
          lt_object   TYPE ty_lt_object,
          lt_vbeln    TYPE cl_ptf_util=>ty_vbeln_tab, "TYPE CL_PTF_UTIL=>TY_VBELN_TAB
          lv_vbeln    TYPE vbeln.

*   Get the predecessor documents
    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    IF lt_vbeln IS INITIAL.
      ev_execution_status = abap_false.
      me->mo_run_environment->append_log( iv_log_statement = |No reference document exists!| ).
      RETURN.
    ENDIF.

    TYPES:
      BEGIN OF ty_vbeln_orig,
        vbeln TYPE vbeln,
      END OF ty_vbeln_orig.
    DATA: lt_vbeln_key TYPE TABLE OF ty_vbeln_orig.
    MOVE lt_vbeln TO lt_vbeln_key.

*   Determine VBTYP and subsequent the object type
    SELECT vbeln, vbtyp FROM vbrk INTO TABLE @DATA(lt_vbeln_vbtyp) FOR ALL ENTRIES IN @lt_vbeln_key WHERE vbeln = @lt_vbeln_key-vbeln.

*   Billing documents
    LOOP AT lt_vbeln_vbtyp REFERENCE INTO DATA(lr_vbeln_vbtyp).
      CALL FUNCTION 'SD_OBJECT_TYPE_DETERMINE'
        EXPORTING
          i_document_type   = lr_vbeln_vbtyp->vbtyp
*         i_tvak
        IMPORTING
          e_business_object = ls_object-objecttype.
      ls_object-objectkey = lr_vbeln_vbtyp->vbeln.
      INSERT ls_object INTO TABLE lt_object.
      DELETE TABLE lt_vbeln WITH TABLE KEY vbeln = lr_vbeln_vbtyp->vbeln.
    ENDLOOP.

*   Sales documents
    IF lt_vbeln IS NOT INITIAL.
      SELECT vbeln, vbtyp, auart FROM vbak INTO TABLE @DATA(lt_vbeln_vbtyp_auart) FOR ALL ENTRIES IN @lt_vbeln_key WHERE vbeln = @lt_vbeln_key-vbeln.
      LOOP AT lt_vbeln_vbtyp_auart REFERENCE INTO DATA(lr_vbeln_vbtyp_auart).
        SELECT SINGLE * FROM tvak INTO @DATA(ls_tvak) WHERE auart = @lr_vbeln_vbtyp_auart->auart.
        CALL FUNCTION 'SD_OBJECT_TYPE_DETERMINE'
          EXPORTING
            i_document_type   = lr_vbeln_vbtyp_auart->vbtyp
            i_tvak            = ls_tvak
          IMPORTING
            e_business_object = ls_object-objecttype.
        ls_object-objectkey = lr_vbeln_vbtyp_auart->vbeln.
        INSERT ls_object INTO TABLE lt_object.
        DELETE TABLE lt_vbeln WITH TABLE KEY vbeln = lr_vbeln_vbtyp_auart->vbeln.
      ENDLOOP.
    ENDIF.

*   Deliveries
    IF lt_vbeln IS NOT INITIAL.
      SELECT vbeln, vbtyp, lfart FROM likp INTO TABLE @DATA(lt_vbeln_vbtyp_lfart) FOR ALL ENTRIES IN @lt_vbeln_key WHERE vbeln = @lt_vbeln_key-vbeln.
      LOOP AT lt_vbeln_vbtyp_lfart REFERENCE INTO DATA(lr_vbeln_vbtyp_lfart).
        SELECT SINGLE * FROM tvlk INTO @DATA(ls_tvlk) WHERE lfart = @lr_vbeln_vbtyp_lfart->lfart.
        CALL FUNCTION 'SD_OBJECT_TYPE_DETERMINE'
          EXPORTING
            i_document_type   = lr_vbeln_vbtyp_lfart->vbtyp
            i_tvlk            = ls_tvlk
          IMPORTING
            e_business_object = ls_object-objecttype.
        ls_object-objectkey = lr_vbeln_vbtyp_lfart->vbeln.
        INSERT ls_object INTO TABLE lt_object.
      ENDLOOP.
    ENDIF.


*   Get test data
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = step_data
      IMPORTING
       es_testdata  = ls_testdata
    ).

    IF ls_testdata-value_cstring IS NOT INITIAL.
*       Content is maintained as CSTRING => Convert to XSTRING
      DATA(lo_converter) = cl_abap_conv_out_ce=>create( ).
      lo_converter->convert( EXPORTING data = ls_testdata-value_cstring IMPORTING buffer = ls_testdata-value_xstring ).
    ENDIF.

*   Upload attachments
    DATA(lo_attachment_api) = cl_odata_cv_attachment_api=>get_instance( ).
    DATA(lv_success) = abap_true.
    LOOP AT lt_object REFERENCE INTO DATA(lr_object).

      TRY.
          lo_attachment_api->if_odata_cv_attachment_api~mass_upload_attachments(
            EXPORTING
              iv_objecttype           = lr_object->objecttype
              iv_objectkey            = lr_object->objectkey
              it_media_content        = VALUE #( ( filename = ls_testdata-filename mime_type = ls_testdata-mime_type value = ls_testdata-value_xstring ) )
              iv_auto_commit          = abap_false
            IMPORTING
              et_attachment_url       = DATA(lt_attachment_url)
              et_attachments_uploaded = DATA(lt_attachment_uploaded)
              et_messages             = DATA(lt_message)
              et_failed_contents      = DATA(lt_failed_content)
          ).

          LOOP AT lt_message ASSIGNING FIELD-SYMBOL(<ls_message>).
            me->mo_run_environment->append_log( iv_log_statement =  |{ <ls_message>-message }| ).
          ENDLOOP.

          APPEND lr_object->objectkey TO ev_document_id.

          IF lt_failed_content IS NOT INITIAL.

            me->mo_run_environment->append_log( iv_log_statement = |Upload to document { lr_object->objectkey } failed| ).
            LOOP AT lt_failed_content REFERENCE INTO DATA(lr_failed_content).

              LOOP AT lr_failed_content->t_messages ASSIGNING FIELD-SYMBOL(<ls_message_failed>).
                me->mo_run_environment->append_log( iv_log_statement =  |{ <ls_message_failed>-message }| ).
              ENDLOOP.

            ENDLOOP.
            lv_success = abap_false.
            CONTINUE.
          ELSE.
            me->mo_run_environment->append_log( iv_log_statement = |Attachment has been uploaded to document { lr_object->objectkey } | ).
          ENDIF.

        CATCH cx_odata_cv_base_exception INTO DATA(lx_odata_cv_base).
          me->mo_run_environment->append_log( iv_log_statement = |Upload to document { lr_object->objectkey } failed: { lx_odata_cv_base->get_text( ) } | ).
          lv_success = abap_false.
          CONTINUE.
      ENDTRY.

    ENDLOOP.

    COMMIT WORK AND WAIT.

    ev_execution_status = lv_success.

  ENDMETHOD.
ENDCLASS.
