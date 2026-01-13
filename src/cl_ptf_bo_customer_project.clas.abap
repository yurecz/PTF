class CL_PTF_BO_CUSTOMER_PROJECT definition
  public
  inheriting from CL_PTF_TEMPLATE
  final
  create public .

public section.

  interfaces IF_PTF_BO .
protected section.
private section.
ENDCLASS.



CLASS CL_PTF_BO_CUSTOMER_PROJECT IMPLEMENTATION.


  method IF_PTF_BO~CHANGE.

  endmethod.


  method IF_PTF_BO~CHECK.

  endmethod.


  METHOD if_ptf_bo~create.

    DATA:
      ls_testdata   TYPE          if_ptf_param_types=>ty_gs_i_ptf_cust_proj_cr_td,
      lt_msg        TYPE          bal_t_msg,
      ls_msg        LIKE LINE OF  lt_msg,
      lr_mp_service TYPE REF TO   /cpd/cl_sc_mp_services,
      lt_fp_key     TYPE          /bobf/t_frw_key,
      ls_return     TYPE          bapiret2,
      lt_return     TYPE TABLE OF bapiret2,
      ls_project    TYPE          /cpd/s_sc_proj_engagement,
      mo_wp_api     TYPE REF TO   /cpd/cl_sc_wp_services.

******************************************************************************
* 1.  Get data from tdcv
    CALL METHOD get_testdata
      EXPORTING
        is_step_data = cs_step_data
      IMPORTING
        es_testdata  = ls_testdata.

*****************************************************************************
* 2.    Check and prepare data for method call

*-------------------------------------------------------------------------------------------------------
*                         Project Type should be 'C' for Cutomer Project
*-------------------------------------------------------------------------------------------------------

    ls_testdata-projecttype = /cpd/cl_sc_cpm_constants=>gc_customer_proj.

*-------------------------------------------------------------------------------------------------------
*                        Move corresponding to the appropiate structure
*-------------------------------------------------------------------------------------------------------

    MOVE-CORRESPONDING ls_testdata TO ls_project.

*****************************************************************************
* 3. Create Customer Project
*-------------------------------------------------------------------------------------------------------
*                      New Project creation
*-------------------------------------------------------------------------------------------------------

    IF lr_mp_service IS NOT BOUND.
      CREATE OBJECT lr_mp_service.
    ENDIF.


*-------------------------------------------------------------------------------------------------------
*                  Create Master Project
*-------------------------------------------------------------------------------------------------------

    lr_mp_service->/cpd/if_sc_mp_services~create_master_project( IMPORTING et_messages  =  lt_msg
                                                                           et_fp_key    =  lt_fp_key
                                                                 CHANGING  cs_mp_entity =  ls_project ).


    READ TABLE lt_msg TRANSPORTING NO FIELDS WITH KEY msgty = /cpd/cl_sc_cpm_constants=>gc_error_typ.
    IF sy-subrc <> 0.
*-----------------------------------------------------------------------
*               Commit transaction if no error exist.
*-----------------------------------------------------------------------
      IF mo_wp_api IS NOT BOUND.
        CREATE OBJECT mo_wp_api.
      ENDIF.
      REFRESH: lt_msg.

      mo_wp_api->commit_records(
        IMPORTING
          et_messages = lt_msg    " Application Log: Table with Messages
           ).

******************************************************************************
* 4.  Copy messages to et_return
      MOVE-CORRESPONDING lt_return TO et_return.
    ELSE.
      MOVE-CORRESPONDING lt_msg TO et_return.
    ENDIF.


  ENDMETHOD.


  method IF_PTF_BO~DELETE.

  endmethod.


  method IF_PTF_BO~EXECUTE_ACTION.

  endmethod.


  method IF_PTF_BO~EXECUTE_CHECK.

  endmethod.
ENDCLASS.
