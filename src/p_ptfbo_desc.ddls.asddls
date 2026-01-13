@AbapCatalog.sqlViewName: 'PTFBO_DESC_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'PTF business object description'
define view P_PTFBO_DESC
  as select from I_PTFBO_DESC_TP
{
  key business_object as business_object,
  key langauge        as language,
      description     as description
}
