CLASS cl_ptf_bd_oc_node_validator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sd_bil_xml_nodes_validator .

    METHODS: constructor
      IMPORTING step_data       TYPE cl_ptf_util=>gt_ptf_step
                iv_step_number  TYPE i
                run_environment TYPE REF TO cl_ptf_run
                validator       TYPE REF TO cl_ptf_oc_gen_node_validator.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA: step_data       TYPE cl_ptf_util=>gt_ptf_step,
          iv_step_number  TYPE i,
          run_environment TYPE REF TO cl_ptf_run,
          validator       TYPE REF TO cl_ptf_oc_gen_node_validator.

ENDCLASS.



CLASS CL_PTF_BD_OC_NODE_VALIDATOR IMPLEMENTATION.


  METHOD constructor.
    me->step_data = step_data.
    me->iv_step_number = iv_step_number.
    me->run_environment = run_environment.
    me->validator = validator.
  ENDMETHOD.


  METHOD if_sd_bil_xml_nodes_validator~validate.
    valid = validator->validate(
      EXPORTING
        xml_nodes       = xml_nodes
        step_data       = me->step_data
        iv_step_number  = me->iv_step_number
        run_environment = me->run_environment
        CHANGING
          differences     = differences
    ).
  ENDMETHOD.
ENDCLASS.
