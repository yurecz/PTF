CLASS cl_ptf_bd_oc_vatsum_sign DEFINITION
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



CLASS CL_PTF_BD_OC_VATSUM_SIGN IMPLEMENTATION.


  METHOD validate.
    TYPES: BEGIN OF lty_vbrk,
             vbeln TYPE vbeln,
             bukrs TYPE bukrs,
             netwr TYPE vbrk-netwr,
             mwsbk TYPE vbrk-mwsbk,
             waerk TYPE vbrk-waerk,
           END OF lty_vbrk.

    DATA: ls_vbrk TYPE lty_vbrk.
    DATA: ls_vatsummary TYPE sdbil_odata_f_vat_summ_s.
    DATA: lv_rita_active TYPE abap_bool.
    FIELD-SYMBOLS <lv_value> TYPE any.

    clear differences.
    valid = abap_true.
    LOOP AT xml_nodes ASSIGNING FIELD-SYMBOL(<xml_node>).

      DATA(child_iterator) = <xml_node>->get_children( )->create_iterator( ).

      IF <xml_node>->get_children( )->get_length( ) EQ 0.
        APPEND |No children for the VAT summary node.| TO differences.
        valid = abap_false.
        RETURN.
      ENDIF.

      DATA(child) = child_iterator->get_next( ).
      CLEAR ls_vatsummary.
      WHILE child IS NOT INITIAL.
        DATA(lv_field) = child->get_name(  ).
        ASSIGN COMPONENT lv_field OF STRUCTURE ls_vatsummary TO <lv_value>.
        IF <lv_value> IS ASSIGNED.
          <lv_value> = child->get_value(  ).
          "Why are all values divided by 10?
          IF lv_field = 'CONDITION_BASE_VALUE' OR
             lv_field = 'CNDN_BASEAMOUNT_IN_COCODE_CRCY' OR
             lv_field = 'CNDN_BASEAMOUNT_IN_COUNTR_CRCY' OR
             lv_field = 'CONDITION_AMOUNT' OR
             lv_field = 'CNDN_AMOUNT_IN_COCODE_CRCY' OR
             lv_field = 'CNDN_AMOUNT_IN_COUNTRY_CRCY' OR
             lv_field = 'CONDITION_RATE_VALUE'.
            <lv_value> *= 10.
          ENDIF.
          UNASSIGN <lv_value>.
        ENDIF.
        child = child_iterator->get_next( ).
      ENDWHILE.
      IF ls_vbrk-vbeln <> ls_vatsummary-billing_document.
        SELECT SINGLE * FROM vbrk INTO CORRESPONDING FIELDS OF @ls_vbrk WHERE vbeln = @ls_vatsummary-billing_document.
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.
        APPEND |Net value: { ls_vbrk-netwr }{ ls_vbrk-waerk }, tax { ls_vbrk-mwsbk }{ ls_vbrk-waerk }| TO differences.
        lv_rita_active = cl_fot_txa_utilities=>agent->is_tax_abroad_active(
                     i_company_code =  ls_vbrk-bukrs
                     i_do_not_dump  = abap_true
                   ).
      ENDIF.

      APPEND |{ ls_vatsummary-tax_code }:{ ls_vatsummary-condition_base_value }{ ls_vatsummary-condition_base_value_unit }| &&
      |*{ ls_vatsummary-condition_rate_value }{ ls_vatsummary-condition_rate_value_unit } = | &&
      |{ ls_vatsummary-condition_amount }{ ls_vatsummary-document_currency }| TO differences.
      APPEND |{ ls_vatsummary-tax_code }:{ ls_vatsummary-cndn_baseamount_in_cocode_crcy }{ ls_vatsummary-company_code_currency }| &&
      |*{ ls_vatsummary-condition_rate_value }{ ls_vatsummary-condition_rate_value_unit } = | &&
      |{ ls_vatsummary-cndn_amount_in_cocode_crcy }{ ls_vatsummary-company_code_currency }| TO differences.
      IF lv_rita_active = abap_true.
        APPEND |{ ls_vatsummary-tax_code }:{ ls_vatsummary-cndn_amount_in_country_crcy }{ ls_vatsummary-country_currency }| &&
        |*{ ls_vatsummary-condition_rate_value }{ ls_vatsummary-condition_rate_value_unit } = | &&
        |{ ls_vatsummary-cndn_amount_in_country_crcy }{ ls_vatsummary-country_currency }| TO differences.
      ENDIF.
      IF ls_vatsummary-condition_base_value > 0.
        IF ls_vatsummary-condition_amount < 0 OR ls_vatsummary-cndn_baseamount_in_cocode_crcy < 0 OR ls_vatsummary-cndn_amount_in_cocode_crcy < 0
          OR ( lv_rita_active = abap_true AND ( ls_vatsummary-cndn_baseamount_in_countr_crcy < 0 OR ls_vatsummary-cndn_amount_in_country_crcy < 0 ) ).
          APPEND |Signs do not match (base > 0).| TO differences.
          valid = abap_false.
        ENDIF.
      ELSEIF ls_vatsummary-condition_base_value < 0.
        IF ls_vatsummary-condition_amount > 0 OR ls_vatsummary-cndn_baseamount_in_cocode_crcy > 0 OR ls_vatsummary-cndn_amount_in_cocode_crcy > 0
        OR ( lv_rita_active = abap_true AND ( ls_vatsummary-cndn_baseamount_in_countr_crcy > 0 OR ls_vatsummary-cndn_amount_in_country_crcy > 0 ) ).
          APPEND |Signs do not match (base < 0).| TO differences.
          valid = abap_false.
        ENDIF.
      ELSE.
        APPEND |Condition base value is 0).| TO differences.
      ENDIF.
      IF ls_vatsummary-document_currency = ls_vatsummary-company_code_currency AND (
         ls_vatsummary-condition_base_value <> ls_vatsummary-cndn_baseamount_in_cocode_crcy OR
           ls_vatsummary-condition_amount <> ls_vatsummary-cndn_amount_in_cocode_crcy ).
        APPEND |Same transaction & company currencies but different values.| TO differences.
        valid = abap_false.
      ENDIF.
      IF lv_rita_active = abap_true AND ( ls_vatsummary-document_currency = ls_vatsummary-country_currency AND (
         ls_vatsummary-condition_base_value <> ls_vatsummary-cndn_baseamount_in_countr_crcy OR
           ls_vatsummary-condition_amount <> ls_vatsummary-cndn_amount_in_country_crcy ) ).
        APPEND |Same transaction & country currencies but different values.| TO differences.
        valid = abap_false.
      ENDIF.
      IF ls_vbrk-netwr > 0 AND ls_vatsummary-condition_base_value < 0.
        APPEND |Net value is positive but condition base value is negative.| TO differences.
        valid = abap_false.
      ENDIF.
      IF ls_vbrk-netwr < 0 AND ls_vatsummary-condition_base_value > 0.
        APPEND |Net value is negative but condition base value is positive.| TO differences.
        valid = abap_false.
      ENDIF.
      IF ls_vbrk-waerk <> ls_vatsummary-document_currency.
        APPEND |Document currency mismatch ({ ls_vbrk-waerk }<>{ ls_vatsummary-document_currency }).| TO differences.
        valid = abap_false.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
