CLASS cl_ptf_bd_oc_serial_numbers DEFINITION
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



CLASS CL_PTF_BD_OC_SERIAL_NUMBERS IMPLEMENTATION.


  METHOD validate.

    DATA: index                   TYPE i,
          actual_number_of_childs TYPE i,
          serial_number_step      TYPE i.

    DATA(variant_content) = run_environment->get_all_steps( ).

    TRY.
        serial_number_step = variant_content[ bus_obj = 'OUTB_DELIVERY' action = 'ADD_SERIAL_NUMBERS' ]-step_number.
      CATCH cx_root.
        APPEND |Could not find any step that creates serial numbers| TO differences.
        valid = abap_false.
        RETURN.
    ENDTRY.
    DATA(serial_numbers) = run_environment->get_keys_of_touch_doc_of_step( iv_step_number = serial_number_step ).

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
            DATA(actual_serial_number) = child->get_last_child( )->get_value( ).
            DATA(expected_serial_number) = serial_numbers[ index ].
            index = index + 1.
            child = children_iterator->get_next( ).

            IF actual_serial_number NE expected_serial_number.
              APPEND |Serial numbers do not match.| TO differences.
              valid = abap_false.
            ENDIF.

          CATCH cx_root.
            APPEND |Number of serial numbers in output does not match number of created serial numbers| TO differences.
            valid = abap_false.
            EXIT.
        ENDTRY.
      ENDWHILE.

      DATA(expected_number_of_childs) = lines( serial_numbers ).
      IF actual_number_of_childs NE expected_number_of_childs.
        APPEND |Number of serial numbers in output does not match number of created serial numbers| TO differences.
        valid = abap_false.
        EXIT.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
