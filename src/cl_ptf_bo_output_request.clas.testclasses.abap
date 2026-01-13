class lcl_ptf_environment definition create public.

  public section.
  protected section.
  private section.

endclass.

class lcl_ptf_environment implementation.

endclass.


class ltcl_ptf_bo_output_request definition final for testing
  duration short
  risk level harmless.

  private section.
    methods:
      setup,
      modify_1_emailitem_positive for testing raising cx_static_check.
    data:
          mo_cut type ref to cl_ptf_bo_output_request.
endclass.


class ltcl_ptf_bo_output_request implementation.

  method setup.
    DATA(lo_test) = NEW lcl_ptf_environment( ).
*    mo_cut->mo_run_environment = lo_test.
  endmethod.


  method modify_1_emailitem_positive.


  endmethod.
endclass.
