class CL_PTF_BO_WORKPACKAGE definition
  public
  inheriting from CL_PTF_TEMPLATE
  final
  create public .

public section.

  interfaces IF_PTF_BO .
protected section.
private section.
ENDCLASS.



CLASS CL_PTF_BO_WORKPACKAGE IMPLEMENTATION.


  method IF_PTF_BO~CHANGE.

  endmethod.


  method IF_PTF_BO~CHECK.

  endmethod.


  METHOD if_ptf_bo~create.
    DATA:
      ls_testdata      TYPE          if_ptf_param_types=>ty_gs_i_ptf_wp_cr_td,
      lt_msg           TYPE          bal_t_msg,
      ls_msg           LIKE LINE OF  lt_msg,
      ls_return        TYPE          bapiret2,
      lt_return        TYPE TABLE OF bapiret2,
      ls_workpackage   TYPE /cpd/cl_sc_proj_engmt__mpc=>ts_workpackage,
      lt_wi_entity     TYPE /cpd/cl_sc_proj_engmt__mpc=>tt_workitem,
      ls_wi_entity     LIKE LINE OF lt_wi_entity,
      lt_demand_entity TYPE /cpd/cl_sc_proj_engmt__mpc=>tt_demand,
      ls_demand_entity LIKE LINE OF lt_demand_entity,
      ls_wp_entity     TYPE /cpd/s_sc_work_packages,
      lt_workitem      TYPE /cpd/t_ss_workitem_mig,
      ls_workitem      LIKE LINE OF lt_workitem,
      lt_demand_data   TYPE /cpd/t_ss_plandata_mig,
      ls_demand_data   LIKE LINE OF lt_demand_data.

    MOVE-CORRESPONDING ls_testdata TO ls_wp_entity.
    MOVE-CORRESPONDING ls_testdata-workitemset TO lt_wi_entity.
    MOVE-CORRESPONDING ls_testdata-demandset   TO lt_demand_entity.
    LOOP AT lt_wi_entity INTO ls_wi_entity.
      ls_workitem-work_item_id    = ls_wi_entity-workitem.
      ls_workitem-work_item_name  = ls_wi_entity-workitemname.
      ls_workitem-workpackagename = ls_wi_entity-workpackagename.
      APPEND ls_workitem TO lt_workitem.
    ENDLOOP.

    DATA(lr_engproj_srv)  = /cpd/cl_sc_factory_service=>get_factory( )->get_api_service_instance( ).
    lr_engproj_srv->create_wp_ext_srv(
      EXPORTING
        it_workitem    = lt_workitem
        it_demand_data = lt_demand_entity
        is_wp_entity   = ls_wp_entity
      IMPORTING
        et_messages    =  lt_msg  " Application Log: Table with Messages
    ).

    MOVE-CORRESPONDING lt_msg TO et_return.

  ENDMETHOD.


  method IF_PTF_BO~DELETE.

  endmethod.


  method IF_PTF_BO~EXECUTE_ACTION.

  endmethod.


  method IF_PTF_BO~EXECUTE_CHECK.

  endmethod.
ENDCLASS.
