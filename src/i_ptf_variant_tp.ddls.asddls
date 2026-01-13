@AbapCatalog.sqlViewName: 'PTF_VARIANT_TP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'PTF test variant'
define view I_PTF_VARIANT_TP
  as select from ptf_varid
{
  key varname    as variant,
      scope_item as scope_item
}
