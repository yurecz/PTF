@AbapCatalog.sqlViewName: 'PTFBO_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'PTF business object'
define view P_PTFBO
  as select from I_ptfbo_TP
{
  key business_object as business_object
}
