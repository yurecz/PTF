interface IF_PTF_FILE
  public .


  types:
    tt_text_table TYPE TABLE OF ptf_text WITH NON-UNIQUE DEFAULT KEY .
  types:
    tt_ptf_var_tags TYPE TABLE OF ptf_variant_tag_input WITH NON-UNIQUE DEFAULT KEY .
  types:
    BEGIN OF ts_attributes,
      varname                 TYPE   ptf_varname,
      vardescr                TYPE   rvart_vtxt,
      erdat                   TYPE   ptf_creation_date,
      erzet                   TYPE   ptf_creation_time,
      ernam                   TYPE   uname,
      user_specific           TYPE   ptf_user_specific,
      scope_item              TYPE   ptf_scope_item,
      last_change_date        TYPE   ptf_change_date,
      last_change_time        TYPE   ptf_change_time,
      last_change_user        TYPE   uname,
      script_language_version TYPE   ptf_script_language_version,
      script_version          TYPE   ptf_script_version,
      src_system              TYPE   srcsystem,
      modif_system            TYPE   srcsystem,
      download_system         TYPE   srcsystem,
      download_client         TYPE   mandt,
      file_creation_date      TYPE   dats,
      file_format_version     TYPE   ptf_file_format_version,
      transient_change        TYPE   ptf_flag,
    END OF ts_attributes .

  methods DOWNLOAD
    importing
      !IS_ATTRIBUTES type TS_ATTRIBUTES
      !IT_TEXT_TABLE type TT_TEXT_TABLE
      !IT_TAG_TABLE type TT_PTF_VAR_TAGS
      !IT_VARIANT_DATA type CL_PTF_VARIANT=>GTY_STEP_DATA_TAB .
  methods UPLOAD
    exporting
      !ES_ATTRIBUTES type TS_ATTRIBUTES
      !ET_TEXT_TABLE type TT_TEXT_TABLE
      !ET_TAG_TABLE type TT_PTF_VAR_TAGS
      !ET_VARIANT_TAB type CL_PTF_VARIANT=>GTY_STEP_DATA_TAB
      !EV_ERROR type ABAP_BOOL
      !EV_ERROR_TEXT type STRING .
endinterface.
