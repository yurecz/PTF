CLASS cl_ptf_edi_util DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


    TYPES:
*  types TY_GS_MOCK_EDMAPPING .
      BEGIN OF ty_gs_mock_edsdc_td,
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF edsdc WITH DEFAULT KEY,
      END OF ty_gs_mock_edsdc_td .
    TYPES:
      ty_gt_mock_edsdc_td TYPE STANDARD TABLE OF ty_gs_mock_edsdc_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_t052_td,
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF t052 WITH DEFAULT KEY,
      END OF ty_gs_mock_t052_td .
    TYPES:
      ty_gt_mock_t052_td TYPE STANDARD TABLE OF ty_gs_mock_t052_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_edpar_td,
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF edpar WITH DEFAULT KEY,
      END OF ty_gs_mock_edpar_td .
    TYPES:
      ty_gt_mock_edpar_td TYPE STANDARD TABLE OF ty_gs_mock_edpar_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_tpaer_td,
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF tpaer WITH DEFAULT KEY,
      END OF ty_gs_mock_tpaer_td .
    TYPES:
      ty_gt_mock_tpaer_td TYPE STANDARD TABLE OF ty_gs_mock_tpaer_td WITH DEFAULT KEY .
    TYPES:
* CPF related
      BEGIN OF ty_gs_mock_cpfc_formulatask_td,
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF cpfc_formulatask WITH DEFAULT KEY,
      END OF ty_gs_mock_cpfc_formulatask_td .
    TYPES:
      ty_gt_mock_cpfc_formulatask_td TYPE STANDARD TABLE OF ty_gs_mock_cpfc_formulatask_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_cpfc_formula_td,
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF cpfc_formula WITH DEFAULT KEY,
      END OF ty_gs_mock_cpfc_formula_td .
    TYPES:
      ty_gt_mock_cpfc_formula_td TYPE STANDARD TABLE OF ty_gs_mock_cpfc_formula_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_cpfc_formulapar_td,
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF cpfc_formulapar WITH DEFAULT KEY,
      END OF ty_gs_mock_cpfc_formulapar_td .
    TYPES:
      ty_gt_mock_cpfc_formulapar_td TYPE STANDARD TABLE OF ty_gs_mock_cpfc_formulapar_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_cpfc_dect_setup_td,
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF cpfc_dect_setup WITH DEFAULT KEY,
      END OF ty_gs_mock_cpfc_dect_setup_td .
    TYPES:
      ty_gt_mock_cpfc_dect_setup_td TYPE STANDARD TABLE OF ty_gs_mock_cpfc_dect_setup_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_cpfc_dect_rows_td,
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF cpfc_dect_rows WITH DEFAULT KEY,
      END OF ty_gs_mock_cpfc_dect_rows_td .
    TYPES:
      ty_gt_mock_cpfc_dect_rows_td TYPE STANDARD TABLE OF ty_gs_mock_cpfc_dect_rows_td WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_edi_edpvw,
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF edi_edpvw WITH DEFAULT KEY,
      END OF ty_gs_mock_edi_edpvw .
    TYPES:
      ty_gt_mock_edi_edpvw_td TYPE STANDARD TABLE OF ty_gs_mock_edi_edpvw WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_edi_c_txtin_sup,
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF edi_c_txtin_sup WITH DEFAULT KEY,
      END OF ty_gs_mock_edi_c_txtin_sup .
    TYPES:
      ty_gt_mock_edi_c_txtin_sup  TYPE STANDARD TABLE OF ty_gs_mock_edi_c_txtin_sup WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_gs_mock_edmapping,
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF knaddr_edmapping WITH DEFAULT KEY,
      END OF ty_gs_mock_edmapping .
    TYPES:
      ty_gt_mock_edmapping TYPE STANDARD TABLE OF ty_gs_mock_edmapping WITH DEFAULT KEY .

    TYPES: BEGIN OF ty_gs_mock_ext,
             dbtable   TYPE tabname16,
             mock_mode TYPE ptf_mock_mode,
             content   TYPE STANDARD TABLE OF knaddr_ext WITH DEFAULT KEY,
           END OF ty_gs_mock_ext.
    TYPES ty_gt_mock_ext TYPE STANDARD TABLE OF ty_gs_mock_ext WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_gs_mock_edi_c_txtout_sup,
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF edi_c_txtout_sup WITH DEFAULT KEY,
      END OF ty_gs_mock_edi_c_txtout_sup .
    TYPES:
      ty_gt_mock_edi_c_txtout_sup  TYPE STANDARD TABLE OF ty_gs_mock_edi_c_txtout_sup WITH DEFAULT KEY .

    TYPES:
      BEGIN OF ty_gs_mock_but022,
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF but022 WITH DEFAULT KEY,
      END OF ty_gs_mock_but022 .
    TYPES:
      ty_gt_mock_but022  TYPE STANDARD TABLE OF ty_gs_mock_but022 WITH DEFAULT KEY .

    TYPES:
      BEGIN OF ty_gs_mock_but020,
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF but020 WITH DEFAULT KEY,
      END OF ty_gs_mock_but020 .
    TYPES:
      ty_gt_mock_but020  TYPE STANDARD TABLE OF ty_gs_mock_but020 WITH DEFAULT KEY .

    TYPES:
      BEGIN OF ty_gs_mock_knaddr_ext,
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF knaddr_ext WITH DEFAULT KEY,
      END OF ty_gs_mock_knaddr_ext .
    TYPES:
      ty_gt_mock_knaddr_ext  TYPE STANDARD TABLE OF ty_gs_mock_knaddr_ext WITH DEFAULT KEY .

    TYPES:
      BEGIN OF ty_gs_mock_tvau,
        dbtable   TYPE tabname16,
        mock_mode TYPE ptf_mock_mode,
        content   TYPE STANDARD TABLE OF tvau WITH DEFAULT KEY,
      END OF ty_gs_mock_tvau .
    TYPES:
      ty_gt_mock_tvau TYPE STANDARD TABLE OF ty_gs_mock_tvau WITH DEFAULT KEY .
  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.



CLASS CL_PTF_EDI_UTIL IMPLEMENTATION.
ENDCLASS.
