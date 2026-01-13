@AbapCatalog.sqlViewName: 'PTFBO_DESC_TP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'PTF business object description'
define view I_PTFBO_DESC_TP
  as select from ptfbot
{
  key ptf_bo as business_object,
  key spras  as langauge,
      vtext  as description
}
