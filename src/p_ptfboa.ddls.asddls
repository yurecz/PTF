@AbapCatalog.sqlViewName: 'PTFBOA_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'PTF business object action'
define view P_PTFBOA
  as select from I_PTFBOA_TP
{
  key business_object        as business_object,
  key business_object_action as action
}
