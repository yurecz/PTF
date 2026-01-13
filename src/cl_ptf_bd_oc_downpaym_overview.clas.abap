class CL_PTF_BD_OC_DOWNPAYM_OVERVIEW definition
  public
  final
  inheriting from CL_PTF_OC_GEN_NODE_VALIDATOR
  create public .

public section.
methods VALIDATE
    redefinition .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS CL_PTF_BD_OC_DOWNPAYM_OVERVIEW IMPLEMENTATION.


  METHOD validate.

    DATA: index                   TYPE i,
          actual_number_of_childs TYPE i,
          expected_down_payments  TYPE TABLE OF vbeln,
          billing_plans           TYPE TABLE OF fplnr.

    "variant_content contains all previous steps of executed PTF variant
    DATA(variant_content) = run_environment->get_all_steps( ).

    "check which down_payments were expected
    "get F2 invoice
    TRY.
        DATA(f2_invoice) = variant_content[ bus_obj = 'INVOICE' action = 'CREATE' variant = 'BD_F2' ]-document_id.
      CATCH cx_root.
        APPEND |Could not find any F2 invoice.| TO differences.
        valid = abap_false.
        RETURN.
    ENDTRY.
    "get Billing Plans for F2
    LOOP AT f2_invoice ASSIGNING FIELD-SYMBOL(<invoice>).
      SELECT DISTINCT fplnr FROM vbrp WHERE vbeln = @<invoice>-vbeln AND fplnr <> '' INTO @DATA(billing_plan).
        APPEND billing_plan TO billing_plans.
      ENDSELECT.
      LOOP AT billing_plans ASSIGNING FIELD-SYMBOL(<bil_plan>).
        SELECT DISTINCT vbeln FROM vbrp WHERE fplnr = @<bil_plan> AND vbeln <> @<invoice>-vbeln INTO @DATA(faz_invoices).
          APPEND faz_invoices TO expected_down_payments.
        ENDSELECT.
      ENDLOOP.
    ENDLOOP.

    "Sort to right sequence (should be equal to XML sequence)
    SORT expected_down_payments ASCENDING.

    valid = abap_true.
    LOOP AT xml_nodes ASSIGNING FIELD-SYMBOL(<xml_node>).
      actual_number_of_childs = 0.

      DATA(xml_node_name) = <xml_node>->get_name( ).
      DATA(xml_node_content) = <xml_node>->get_content_as_string( ).
      DATA(xml_node_value) = <xml_node>->get_value( ).

      DATA(children_iterator) = <xml_node>->get_children( )->create_iterator( ).
      index = 1.
      DATA(child) = children_iterator->get_next( ).

      "Check at least one child
      WHILE child IS NOT INITIAL.
        actual_number_of_childs = actual_number_of_childs + 1.
        TRY.
            DATA(down_payment_item) = child->get_children( )->create_iterator( ).
            DATA(actual_down_payment) = down_payment_item->get_next( )->get_next( )->get_value( ).
            DATA(expected_down_payment) = expected_down_payments[ index ].
            index = index + 1.
            child = children_iterator->get_next( ).

            IF actual_down_payment NE expected_down_payment.
              APPEND |Down payment items do not match.| TO differences.
              valid = abap_false.
            ENDIF.

          CATCH cx_root.
            APPEND |Number of down payments in output does not match number of created down payments.| TO differences.
            valid = abap_false.
            EXIT.
        ENDTRY.
      ENDWHILE.

      DATA(expected_number_of_childs) = lines( expected_down_payments ).
      IF actual_number_of_childs NE expected_number_of_childs.
        APPEND |Number of down payments in output does not match number of created down payments.| TO differences.
        valid = abap_false.
        EXIT.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
