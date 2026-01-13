@AbapCatalog.sqlViewName: 'PTFBO_TP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'PTF business object'
define view I_ptfbo_TP
  as select from ptfbo
{
  key ptf_bo      as business_object,
      sbo_bo_type as sap_bo_type
}
