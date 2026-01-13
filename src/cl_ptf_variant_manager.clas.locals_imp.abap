*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_ptf_variant_manager DEFINITION FINAL INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.
    METHODS finish IMPORTING p_task TYPE char32.
  PRIVATE SECTION.
    CLASS-DATA: is_finished      TYPE abap_bool,
                execution_result TYPE i_ptf_execution_result.
    METHODS read FOR BEHAVIOR variant2Read FOR READ p_ptf_variant RESULT variantRead.
    METHODS lock.
    "METHODS modify IMPORTING i_zmo_execute_variant_input TYPE i_zmo_execute_variant_input CHANGING I_ZMO_PTF_RUN_RESULT TYPE tt_ptf_result.
    METHODS execute_variant FOR MODIFY IMPORTING execute_variant FOR ACTION p_ptf_variant~execute_variant RESULT execution_result.
ENDCLASS.

CLASS lcl_ptf_variant_manager IMPLEMENTATION.

  METHOD read.

  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD finish.
    me->is_finished = abap_true.
    RECEIVE RESULTS FROM FUNCTION 'EXECUTE_PTF_VARIANT'
    IMPORTING
      execution_result = execution_result.
  ENDMETHOD.


  METHOD execute_variant.
    DATA: step_result         TYPE i_ptf_execution_result.


    LOOP AT execute_variant ASSIGNING FIELD-SYMBOL(<variant_to_exec>).
      is_finished = abap_false.


      CALL FUNCTION 'EXECUTE_PTF_VARIANT' STARTING NEW TASK 'ptf_thread' CALLING me->finish ON END OF TASK
        EXPORTING
          variant = <variant_to_exec>-variant.



      WHILE me->is_finished EQ abap_false.
        WAIT UP TO 2 SECONDS.
      ENDWHILE.

      INSERT VALUE #( variant = <variant_to_exec>-variant %param = me->execution_result ) INTO TABLE execution_result.


    ENDLOOP.



  ENDMETHOD.

ENDCLASS.
