@AbapCatalog.sqlViewName: 'PTF_VARIANT_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'PTF test variant'
define root view P_PTF_VARIANT
  as select from I_PTF_VARIANT_TP
{
  key variant as variant
}
