@AbapCatalog.sqlViewName: 'PTF_VAR_DESC_TP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'PTF test variant description'
define view I_PTF_VARIANT_DESC_TP
  as select from ptf_varid_t
{
  key varname as variant,
  key langu   as langu,
      vtext   as vtext
}
