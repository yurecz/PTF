CLASS cl_apoc_ptf_bo_preparation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_apoc_ptf_bo_preparation.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS CL_APOC_PTF_BO_PREPARATION IMPLEMENTATION.


  METHOD if_apoc_ptf_bo_preparation~prepare_root_data.

*    lt_data =
*     VALUE #(
*        (
*        appl_object_id = appl_object_id_as_i
*        appl_object_type = ls_testdata-root-appl_object_type
*        log_handle = ''
*        output_parameter = ls_testdata-root-output_parameter
*        )
*     ).

  ENDMETHOD.
ENDCLASS.
