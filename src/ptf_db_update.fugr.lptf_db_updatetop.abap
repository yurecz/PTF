FUNCTION-POOL ptf_db_update.                "MESSAGE-ID ..
*
*TYPES:
*  BEGIN OF lty_ref_step,
*    stepnr   TYPE numc3,
*    ref_step TYPE numc3,
*  END OF lty_ref_step,
*
*  BEGIN OF gty_ptf_variant,
*    varname       TYPE ptf_varname,
*    vtext         TYPE char30,
*    erdat         TYPE vari_vdate,
*    ernam         TYPE uname,
*    user_specific TYPE ptf_user_specific,
*  END OF gty_ptf_variant,
*  BEGIN OF gty_step_data,
*    bus_obj        TYPE ptf_bo,
*    action         TYPE ptf_act,
*    variant        TYPE etp_name,
*    reference_step TYPE cl_ptf_util=>gty_reference_tab,
*  END OF gty_step_data.
*TYPES:
*gty_ptf_variant_tab TYPE STANDARD TABLE OF ptf_selection .
*TYPES:
*  gty_step_data_tab TYPE STANDARD TABLE OF gty_step_data .
*TYPES:
*  gt_step_tab TYPE STANDARD TABLE OF gty_step_data .
*TYPES:
*  lty_ref_tab TYPE STANDARD TABLE OF i .
*TYPES:
*  lty_cond TYPE c LENGTH 120 .
*TYPES:
*  lty_cond_tab TYPE STANDARD TABLE OF lty_cond .
*TYPES:
*  lty_ptf_text TYPE STANDARD TABLE OF ptf_text .
*TYPES:
*  gty_ptf_cat TYPE STANDARD TABLE OF ptf_varcat .
*types:
*  gty_ptf_varid     TYPE STANDARD TABLE OF ptf_varid WITH DEFAULT KEY.
*  types:
*  gty_ptf_varcon    TYPE STANDARD TABLE OF ptf_varcon WITH DEFAULT KEY.
*  types:
*  gyt_ptf_varref    TYPE STANDARD TABLE OF ptf_varref WITH DEFAULT KEY.
*DATA:
*  gt_ref_step      TYPE STANDARD TABLE OF lty_ref_step,
*  gt_ref_tab       TYPE STANDARD TABLE OF i,
*  gt_ptf_step      TYPE gt_step_tab,
*  gv_search        TYPE abap_bool VALUE abap_false,
*  gs_ptf_varid     TYPE ptf_varid,
*  gs_ptf_varid_old TYPE ptf_varid,
*  gs_ptf_varcat    TYPE ptf_varcat,
*  gs_ptf_varid_t   TYPE ptf_varid_t,
*  gt_ptf_varid_t   TYPE STANDARD TABLE OF ptf_varid_t WITH DEFAULT KEY.
*  gt_selection_tab TYPE gty_ptf_variant_tab,
*  gs_selection     TYPE ptf_selection,
*  gt_ptf_varcat    TYPE STANDARD TABLE OF ptf_varcat WITH DEFAULT KEY,
*  go_transport     TYPE REF TO cl_ptf_transport,
*  gs_ptf_varcon    TYPE ptf_varcon,
*  gs_ptf_varref    TYPE ptf_varref,
*  gs_varcon        TYPE ptf_varcon,
*  gs_varcat        TYPE ptf_varcat.



* INCLUDE LPTF_DB_UPDATED...                 " Local class definition
