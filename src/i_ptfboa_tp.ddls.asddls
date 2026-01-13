@AbapCatalog.sqlViewName: 'PTFBOA_TP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'PTF business object action'
define view I_PTFBOA_TP
  as select from ptfboa
{
  key ptf_bo           as business_object,
  key ptf_act          as business_object_action,
      ptf_tdc          as test_data_container,
      ptf_tdcp         as test_data_container_parameter,
      ptf_check_action as is_check_action
}
