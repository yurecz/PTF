@AbapCatalog.sqlViewName: 'PTF_VAR_DESC_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'PTF test variant description'
define view P_PTF_VARIANT_DESC
  as select from I_PTF_VARIANT_DESC_TP
{
  key variant as variant,
  key langu   as language,
      vtext   as description

}
