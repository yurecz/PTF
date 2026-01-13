@AbapCatalog.sqlViewName: 'PTFBOA_DESC_TP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'PTF business object action description'
define view I_PTFBOA_DESC_TP
  as select from ptfboat
{
  key ptf_bo  as business_object,
  key ptf_act as business_object_action,
  key spras   as language,
      vtext   as description
}
