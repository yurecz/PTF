CLASS cl_ptf_bd_oc_sepa_mandate DEFINITION
  PUBLIC
  INHERITING FROM cl_ptf_oc_gen_node_validator
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS validate
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS CL_PTF_BD_OC_SEPA_MANDATE IMPLEMENTATION.


  METHOD validate.
    DATA: lt_vbeln        TYPE cl_ptf_util=>ty_vbeln_tab,
          ls_sel_criteria TYPE sepa_get_criteria_mandate,
          lt_mandates     TYPE sepa_tab_data_mandate_data,
          sepa_mandate    TYPE string,
          bank_name       TYPE string,
          iban            TYPE string,
          bic_number      TYPE string
          .

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(lt_ptf_keys) = run_environment->get_keys_of_touch_doc_of_step( iv_step_number =  <lv_ref_step> ).
      APPEND LINES OF lt_ptf_keys TO lt_vbeln.
    ENDLOOP.

    IF lines( lt_vbeln ) EQ 0.
      APPEND |Nothing to check.| TO differences.
      valid = abap_false.
      RETURN.
    ENDIF.

    ls_sel_criteria-mvers = '0000'.
    ls_sel_criteria-anwnd = 'F'.
    ls_sel_criteria-snd_type = 'BUS3007'.   "Debitor

    valid = abap_true.
    LOOP AT lt_vbeln ASSIGNING FIELD-SYMBOL(<document>).
      SELECT SINGLE kunrg, mndid FROM vbrk INTO @DATA(customer) WHERE vbeln = @<document>-vbeln.
      ls_sel_criteria-mndid = customer-mndid.
      ls_sel_criteria-snd_id = customer-kunrg.

      CALL FUNCTION 'SEPA_MANDATES_API_GET'
        EXPORTING
          i_sel_criteria = ls_sel_criteria
        IMPORTING
          et_mandates    = lt_mandates.


      LOOP AT xml_nodes ASSIGNING FIELD-SYMBOL(<xml_node>).
        CLEAR sepa_mandate.
        CLEAR bank_name.
        CLEAR iban.
        CLEAR bic_number.

        DATA(child_iterator) = <xml_node>->get_children( )->create_iterator( ).

        IF <xml_node>->get_children( )->get_length( ) EQ 0.
          APPEND |No children for the SEPA node.| TO differences.
          valid = abap_false.
          RETURN.
        ENDIF.

        DATA(child) = child_iterator->get_next( ).

        WHILE child IS NOT INITIAL.
          IF child->get_value( ) IS INITIAL.
            APPEND |{ child->get_name( ) } is initial| TO differences.
            valid = abap_false.
            RETURN.
          ENDIF.
          CASE child->get_name( ).
            WHEN 'BILLING_DOCUMENT'.
              "No additional checks required currently
            WHEN 'SEPA_MANDATE'.
              sepa_mandate = child->get_value( ).
            WHEN 'BANK_NAME'.
              bank_name = child->get_value( ).
            WHEN 'IBAN'.
              iban = child->get_value( ).
            WHEN 'BIC_NUMBER'.
              bic_number = child->get_value( ).
            WHEN 'PAYMENT_DUE_DATE'.
              "No additional checks required currently
            WHEN OTHERS.
              APPEND |SEPA XML structure changed. Please update test.| TO differences.
              valid = abap_false.
              RETURN.
          ENDCASE.
          child = child_iterator->get_next( ).
        ENDWHILE.

        TRY.
            DATA(mandate) = lt_mandates[ mndid = sepa_mandate snd_iban = iban snd_bic = bic_number ].
          CATCH cx_root.
            APPEND |No mandate found.| TO differences.
            valid = abap_false.
            RETURN.
        ENDTRY.

        "Is bic unique? Not sure about that
        SELECT SINGLE banka FROM bnka WHERE swift = @bic_number INTO @DATA(actual_bank_name).
        IF actual_bank_name NE bank_name.
          APPEND |Wrong bank name.| TO differences.
          valid = abap_false.
          RETURN.
        ENDIF.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
