FUNCTION ptf_insert_db.
*"----------------------------------------------------------------------
*"*"Update Function Module:
*"
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IS_PTF_VARID) TYPE  PTF_VARID
*"     VALUE(IS_PTF_VARID_T) TYPE  PTF_VARID_T
*"     VALUE(IT_PTF_VARREF) TYPE  CL_PTF_VARIANT=>GTY_PTF_VARREF
*"     VALUE(IT_PTF_VARCON) TYPE  CL_PTF_VARIANT=>GTY_PTF_VARCON
*"     VALUE(IT_PTF_VARCAT) TYPE  CL_PTF_VARIANT=>GTY_PTF_VARCAT
*"     VALUE(IT_PTF_VAREXPMESS) TYPE  CL_PTF_VARIANT=>GTY_VAREXPMESS
*"     VALUE(IT_PTF_VARDATASET) TYPE  CL_PTF_VARIANT=>GTY_VARDATASET
*"----------------------------------------------------------------------

  INSERT ptf_varid   FROM is_ptf_varid.
  INSERT ptf_varid_t FROM is_ptf_varid_t.
  INSERT ptf_varcon  FROM TABLE it_ptf_varcon.
  INSERT ptf_varref  FROM TABLE it_ptf_varref.
  INSERT ptf_varcat  FROM TABLE it_ptf_varcat.
  INSERT ptf_varexpmess FROM TABLE it_ptf_varexpmess.
  INSERT ptf_vardataset FROM TABLE it_ptf_vardataset.

ENDFUNCTION.
