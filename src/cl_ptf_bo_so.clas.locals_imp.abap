*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
interface lif_ptf_custom_check.
  class-methods custom_check
    importing
              iv_step                type i
              io_ptf_bo              type ref to cl_ptf_bo
    returning value(rv_check_status) type abap_bool.
endinterface.
