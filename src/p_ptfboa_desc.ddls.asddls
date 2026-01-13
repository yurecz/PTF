@AbapCatalog.sqlViewName: 'PTFBOA_DESC_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'PTF business object action description'
define view P_PTFBOA_DESC
  as select from I_PTFBOA_DESC_TP
{
  key business_object        as business_object,
  key business_object_action as action,
  key language               as language,
      description            as description
}
