PROGRAM process_test_framework_alv.

CLASS lcl_event_receiver DEFINITION DEFERRED.
CLASS lcl_event_receiver_tables DEFINITION DEFERRED.
CLASS lcl_event_receiver_exp_msg DEFINITION DEFERRED.
CLASS lcl_event_receiver_editor DEFINITION DEFERRED.
CLASS lcl_event_receiver_vardatasets DEFINITION DEFERRED.

TYPES: BEGIN OF ty_outtab_ref_step,
         ref_step_number TYPE n LENGTH 3,
       END OF ty_outtab_ref_step.

TYPES: BEGIN OF ty_doc_id,
         vbeln TYPE ptf_bo_id,
       END OF ty_doc_id.

*TYPES: BEGIN OF ty_varhead_dyn,
*         "dynamic part
*         just_loaded_from_file TYPE abap_bool,  "just loaded from file but not saved afterwards => current version might deviate from a version on db
*         name_exists_on_db     TYPE abap_bool,  "flag currently filled only after file upload. consistent would be to fill it also during load, whereUsedOpen, save
*       END OF ty_varhead_dyn.

TYPES: BEGIN OF ty_varhead,
         varname               TYPE ptf_varname,
         vardescr              TYPE rvart_vtxt,
         erdat                 TYPE vari_vdate,
         ernam                 TYPE uname,
         user_specific         TYPE ptf_user_specific,
         scope_item            TYPE ptf_scope_item,
         last_change_date      TYPE ptf_change_date,
         last_change_user      TYPE uname,
*         tag  should be a table if handled here
         "dynamic part
*         include               TYPE ty_varhead_dyn,
         just_loaded_from_file TYPE abap_bool,  "just loaded from file but not saved afterwards => current version might deviate from a version on db
         name_exists_on_db     TYPE abap_bool,  "flag currently filled only after file upload. consistent would be to fill it also during load, whereUsedOpen, save
       END OF ty_varhead.

* Types for for Message Validation ALV
TYPES: BEGIN OF ty_outtab_exp_msg.
         INCLUDE TYPE ptf_exp_message.
TYPES:   handle_style TYPE lvc_t_styl,
       END OF ty_outtab_exp_msg.

TYPES: ty_outtab_exp_msg_t TYPE STANDARD TABLE OF ty_outtab_exp_msg.

TYPES: BEGIN OF ty_outtab_act_msg.
         INCLUDE TYPE bapiret2.
TYPES:   full_text TYPE string,
       END OF ty_outtab_act_msg.

TYPES: ty_outtab_act_msg_t TYPE STANDARD TABLE OF ty_outtab_act_msg.

* Types for Variables and Data Sets
TYPES: ty_outtab_vardatasets_t TYPE ptf_vardataset_t.

DATA:
*UI************************************************************************
*Control Data
  ok_code                     LIKE sy-ucomm,
  more_ok                     LIKE sy-ucomm,
  repo_ok                     LIKE sy-ucomm,
*Container Step Table Data
  gc_container_step           TYPE scrfname VALUE 'PTF_STEP_TABLE',
  go_custom_container_step    TYPE REF TO cl_gui_custom_container,

*ALV Step Table Data
  g_grid_step                 TYPE REF TO cl_ptf_alv_grid_step,
  gt_fieldcatalog_step        TYPE lvc_t_fcat,
  gt_outtab_step              TYPE TABLE OF cl_ptf_util=>ty_outtab,
*  Event handler for Step Table
  go_step_event_receiver      TYPE REF TO lcl_event_receiver,


*Container for Reference Step, Document ID, Reference Document
*  gc_container_ref_step        TYPE scrfname VALUE 'TABLE_REF_STEP',
  g_custom_container_ref_step TYPE REF TO cl_gui_custom_container,
*  gc_container_doc_id          TYPE scrfname VALUE 'TABLE_DOC_ID',
*  go_custom_container_doc_id   TYPE REF TO cl_gui_custom_container,
*  gc_container_ref_doc         TYPE scrfname VALUE 'TABLE_REF_DOC',
*  go_custom_container_ref_doc  TYPE REF TO cl_gui_custom_container,

*  ALV Tables for Reference Step, Document ID (Screen 3001)
  g_grid_more                 TYPE REF TO cl_gui_alv_grid,
  gt_fieldcatalog_more        TYPE lvc_t_fcat,
  gt_outtab_ref_step          TYPE TABLE OF ty_outtab_ref_step,
  gt_outtab_doc_id            TYPE TABLE OF ty_doc_id,
  gs_outtab_doc_id            TYPE ty_doc_id,  "move to MODULE pbo_3001, or replace with INITIAL LINE
  gt_outtab_ref_doc_id        TYPE TABLE OF ty_doc_id,
*  Event handler for Reference Step, Document ID (Screen 3001)
  go_ptf_tables_event         TYPE REF TO lcl_event_receiver_tables,

* Data objects for Message Validation ALV
  g_grid_exp_msg              TYPE REF TO cl_gui_alv_grid   ##NEEDED,
  gt_fieldcatalog_exp_msg     TYPE lvc_t_fcat               ##NEEDED,
  gt_outtab_exp_msg           TYPE ty_outtab_exp_msg_t      ##NEEDED,
  go_ptf_exp_msg_event        TYPE REF TO lcl_event_receiver_exp_msg  ##NEEDED,

* Data objects for Actual Messages
  g_grid_act_msg              TYPE REF TO cl_gui_alv_grid   ##NEEDED,
  gt_fieldcatalog_act_msg     TYPE lvc_t_fcat               ##NEEDED,
  gt_outtab_act_msg           TYPE ty_outtab_act_msg_t      ##NEEDED,

* Data objects for JSON buttons
  go_json_buttons_container   TYPE REF TO cl_gui_custom_container ##NEEDED,
  go_json_toolbar             TYPE REF TO cl_gui_toolbar          ##NEEDED,
  gv_toolbar_button           TYPE ui_func                        ##NEEDED,

* Data objects for JSON Repository
  gs_ptf_input_repo           TYPE ptf_input_repo                 ##NEEDED,
  gv_repository_loaded        TYPE abap_bool                      ##NEEDED,
  gv_rep_input_source         TYPE char10                         ##NEEDED,

* Data objects for Variables and Data Sets
  g_grid_vardataset           TYPE REF TO cl_gui_alv_grid   ##NEEDED,
  gt_fieldcat_vardataset      TYPE lvc_t_fcat               ##NEEDED,
  gt_outtab_vardataset        TYPE ty_outtab_vardatasets_t  ##NEEDED,
  go_ptf_vardataset_event     TYPE REF TO lcl_event_receiver_vardatasets  ##NEEDED,

*For all screens
  gv_row_number               TYPE lvc_s_roid,
  gv_col_id                   TYPE lvc_s_col,

* Testparameter************************************************************************
  gt_step_data                TYPE TABLE OF cl_ptf_util=>gt_ptf_step, "stores steps during script maintenance and during execution
  gt_full_log                 TYPE cl_ptf_util=>gt_ptf_return_tab,
  gv_step_index               TYPE i,   "here, 0 is the first step

* ECATT Parameter
  gv_log_rcode                TYPE sysubrc,
  gv_failed_bo                TYPE ptf_bo,
  gv_failed_bo_action         TYPE ptf_act,

  gv_cancel                   TYPE abap_bool.

* Object Persistence
DATA go_variant TYPE REF TO cl_ptf_variant.
DATA gt_selection TYPE STANDARD TABLE OF ptf_selection.

DATA gs_varhead TYPE ty_varhead.  "transient Model of variant attributes

DATA gt_variant_tab TYPE cl_ptf_variant=>gty_step_data_tab.  "itab for transfer to/from DB
*gt_variant_tab:
* needed in CL_PTF_VARIANT-SAVE to derive content for ptf_varcon and ptf_varref
* needed in Form move_data_to_alv (to build gt_outtab_step and gt_step_data)

DATA gt_text_table TYPE TABLE OF ptf_text.
DATA gt_ptf_var_tags TYPE TABLE OF ptf_variant_tag_input.

DATA gv_script_was_changed TYPE abap_bool.

* RAP BO Related data objects
DATA: gs_json_w_mkf       TYPE smp_dyntxt ##NEEDED,
      gs_json_w_kf        TYPE smp_dyntxt ##NEEDED,
      gs_json_w_af        TYPE smp_dyntxt ##NEEDED,
      gv_json_file        TYPE string     ##NEEDED,
      gv_retrieved_data   TYPE string     ##NEEDED,
      gv_json_editor_open TYPE abap_bool  ##NEEDED.
DATA  go_editor_event_receiver    TYPE REF TO lcl_event_receiver_editor ##NEEDED.  "JSON editor


gv_cancel = abap_false.

"Screen 6001
DATA p_vaname TYPE ptf_varname.
DATA p_descr  TYPE rvart_vtxt.
DATA p_user_s TYPE abap_bool.
DATA p_scpitm TYPE ptf_scope_item.

*CONSTANTS gc_execute       TYPE ptf_act VALUE 'EXECUTE_ACTION'.
*CONSTANTS gc_execute_check TYPE ptf_act VALUE 'EXECUTE_CHECK'.
CONSTANTS: gc_ecattdefault_varid TYPE etvar_id VALUE 'ECATTDEFAULT'.

* Selection screen************************************************************************
SELECTION-SCREEN BEGIN OF SCREEN 2001 AS WINDOW.  "Variant selection dialog
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(24) TEXT-001 FOR FIELD p_vname.
    PARAMETERS: p_vname  TYPE ptf_varname MATCHCODE OBJECT shptf_vname .
  SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(24) TEXT-002 FOR FIELD p_vdescr.
    PARAMETERS: p_vdescr TYPE rvart_vtxt MATCHCODE OBJECT shptf_vdescr.
  SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(24) TEXT-010 FOR FIELD p_usersp.
    PARAMETERS p_usersp TYPE abap_bool AS CHECKBOX.
  SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(24) TEXT-011 FOR FIELD p_nouser.
    PARAMETERS p_nouser TYPE abap_bool AS CHECKBOX.
  SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(24) TEXT-004 FOR FIELD p_name.
    PARAMETERS: p_name TYPE uname MATCHCODE OBJECT shptf_ernam.
  SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(24) TEXT-003 FOR FIELD p_date.
    PARAMETERS: p_date TYPE vari_vdate.
  SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(24) TEXT-015 FOR FIELD p_chname.
    PARAMETERS: p_chname TYPE uname MATCHCODE OBJECT shptf_ernam.
  SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(24) TEXT-016 FOR FIELD p_chdate.
    PARAMETERS: p_chdate TYPE ptf_change_date.
  SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(24) TEXT-014 FOR FIELD p_si.
    PARAMETERS: p_si TYPE ptf_scope_item.
  SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(24) TEXT-013 FOR FIELD p_tag.
    PARAMETERS: p_tag TYPE ptf_variant_tag MATCHCODE OBJECT shptf_ptf_var_tag.
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF SCREEN 2001.

"Screen 7001
DATA p_scpitm2 TYPE ptf_scope_item.
DATA p_vname2  TYPE ptf_varname.

SELECTION-SCREEN BEGIN OF SCREEN 4001 AS WINDOW. "4001 is not called but 7001 uses the parameters
*  SELECTION-SCREEN BEGIN OF LINE.
*    SELECTION-SCREEN COMMENT 1(60) TEXT-009.
*  SELECTION-SCREEN END OF LINE.
*  SELECTION-SCREEN BEGIN OF LINE.
*    SELECTION-SCREEN COMMENT 1(20) TEXT-007 FOR FIELD p_vname2.
  "  PARAMETERS: p_vname2(31) TYPE c DEFAULT ls_selection-varname.
*  SELECTION-SCREEN END OF LINE.
*  SELECTION-SCREEN BEGIN OF LINE.
*    SELECTION-SCREEN COMMENT 1(20) TEXT-008 FOR FIELD p_descr2.
  PARAMETERS:p_descr2 TYPE rvart_vtxt." DEFAULT ls_selection-vardescr.
*  SELECTION-SCREEN END OF LINE.
*  SELECTION-SCREEN BEGIN OF LINE.
*    SELECTION-SCREEN COMMENT 1(20) TEXT-010 FOR FIELD p_user.
  PARAMETERS p_user TYPE abap_bool AS CHECKBOX." DEFAULT ls_selection-user_specific.
*  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF SCREEN 4001.

"Screen 8002
SELECTION-SCREEN BEGIN OF SCREEN 8002 AS SUBSCREEN.
  SELECTION-SCREEN COMMENT 1(20) c_jsid FOR FIELD p_jsid.
  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: p_jsid    TYPE ptf_input_repo-input_id MODIF ID lod.
  SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN COMMENT 1(20) c_jsdscr FOR FIELD p_jsdscr.
  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: p_jsdscr  TYPE ptf_input_repo-descr MODIF ID sav.
  SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN COMMENT 1(20) c_bo FOR FIELD p_bo.
  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: p_bo      TYPE ptf_input_repo-bus_obj MODIF ID lod.
  SELECTION-SCREEN END OF LINE.
  SELECTION-SCREEN COMMENT 1(20) c_act FOR FIELD p_act.
  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: p_act     TYPE ptf_input_repo-action MODIF ID sav.
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF SCREEN 8002.

AT SELECTION-SCREEN.
  "reached for screen 2001
  IF sy-dynnr = 2001. "Added by BURNAR because it interferes with subscreen 8002
    CASE  sy-ucomm.
      WHEN 'CONTI'.
        LEAVE TO SCREEN 0.
      WHEN 'CANC2'. "status is SELECT_STATUS
        gv_cancel = abap_true.
        LEAVE TO SCREEN 0.
      WHEN OTHERS.
        LEAVE TO SCREEN 0.
    ENDCASE.

  ENDIF.

AT SELECTION-SCREEN ON p_jsid.
  IF sy-dynnr = 8002.
    IF sy-ucomm IS INITIAL.
      gv_rep_input_source = 'FIELD'.
      gv_repository_loaded = abap_off.

*      PERFORM reset_repository_load.

    ENDIF.

  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_jsid.
  IF sy-dynnr = 8002.
    IF gv_toolbar_button IS NOT INITIAL. "No toolbar button was pressed
      PERFORM f4_p_jsid.

    ENDIF.

  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_bo.
  IF sy-dynnr = 8002.
    IF gv_toolbar_button IS NOT INITIAL. "No toolbar button was pressed
      PERFORM f4_p_bo.

    ENDIF.

  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_act.
  IF sy-dynnr = 8002.
    IF gv_toolbar_button IS NOT INITIAL. "No toolbar button was pressed
      PERFORM f4_p_act.

    ENDIF.

  ENDIF.

AT SELECTION-SCREEN OUTPUT.
  IF sy-dynnr = 8002.
    PERFORM generate_data_8002 USING gv_rep_input_source.
    PERFORM screen_output_8002.

    SET CURSOR FIELD 'P_JSID'. "Always set focus on JSON ID

  ENDIF.

  INCLUDE ptf_step_alv_event.
  INCLUDE ptf_more_event.
  INCLUDE ptf_run.
  INCLUDE ptf_variant.
  INCLUDE ptf_check_alv_input.
  INCLUDE ptf_screens.
  INCLUDE ptf_save.
  INCLUDE ptf_catalog.
  INCLUDE ptf_json.
  INCLUDE ptf_exp_messages.
  INCLUDE ptf_act_messages.
  INCLUDE ptf_file.
  INCLUDE ptf_repository.
  INCLUDE ptf_vardatasets.

*---------------------------------------------------------------------*
*       MAIN                                                          *
*---------------------------------------------------------------------*
START-OF-SELECTION.
  CALL SCREEN 100. "STARTING AT 1 1.
*---------------------------------------------------------------------*
*       MODULE PBO OUTPUT  0100                                       *
*---------------------------------------------------------------------*
MODULE pbo OUTPUT.

  IF go_variant IS NOT BOUND.
    go_variant = NEW cl_ptf_variant( ).
  ENDIF.
  IF go_variant->go_transport IS BOUND.
    go_variant->go_transport->delete_transport_entries( ).
  ENDIF.

  SET TITLEBAR 'MAIN100' WITH gs_varhead-varname.

  "GUI Status
  DATA gt_exclude TYPE TABLE OF sy-ucomm.
  CLEAR gt_exclude.
  APPEND 'TRANS' TO gt_exclude.

*  IF NOT go_variant->is_maintnce_here_allowed_for( gs_varhead-varname ) OR
*         gs_varhead-just_loaded_from_file EQ abap_true.
*    APPEND 'DELETE' TO gt_exclude.
*  ENDIF.
  IF NOT go_variant->is_maintnce_here_allowed_for( gs_varhead-varname ) OR
         gs_varhead-just_loaded_from_file EQ abap_true.
    APPEND 'DELETE' TO gt_exclude.

  ELSE.
    APPEND 'DELETE_DUM' TO gt_exclude.

  ENDIF.

* Disable Data Sets and Variables for other users
  IF sy-uname <> 'BURNAR' AND sy-uname <> 'GRIESEC'.
    APPEND 'VARDATASET' TO gt_exclude.

  ENDIF.

  SET PF-STATUS 'MAIN100' EXCLUDING gt_exclude.


  IF go_custom_container_step IS INITIAL.

    "Start logic, only in first PBO execution

    "Check AUnit settings
    PERFORM check_au_settings.

    PERFORM init_container.
    PERFORM create_grid.
    PERFORM build_fieldcatalog.
    PERFORM set_table_for_first_display.

    CALL METHOD g_grid_step->register_edit_event( cl_gui_alv_grid=>mc_evt_enter ).
    CALL METHOD g_grid_step->set_ready_for_input( 1 ).

    "Register F4 helps
    DATA ls_f4_help TYPE lvc_s_f4.  "technically global, but only used here
    DATA lt_f4_help TYPE lvc_t_f4.
*   ls_f4_help-getbefore  = abap_true.    "Falls man Eingabedaten überprüfen will
*   ls_f4_help_action-chngeafter = abap_true.
    ls_f4_help-register   = 'X'.

    ls_f4_help-fieldname  = 'ACTION'.
    APPEND  ls_f4_help TO lt_f4_help.
    ls_f4_help-fieldname  = 'BUS_OBJ'.
    APPEND  ls_f4_help TO lt_f4_help.
    ls_f4_help-fieldname  = 'TEST_DATA_CONTAINER'.
    APPEND  ls_f4_help TO lt_f4_help.
    ls_f4_help-fieldname  = 'VARIANT'.
    APPEND  ls_f4_help TO lt_f4_help.
    g_grid_step->register_f4_for_fields( it_f4 = lt_f4_help ).

    PERFORM refresh_stepdata.

  ENDIF.

ENDMODULE.

*---------------------------------------------------------------------*
*       MODULE PAI INPUT  0100                                        *
*---------------------------------------------------------------------*
MODULE pai INPUT.
  CASE ok_code.
    WHEN 'BACK'.
      PERFORM exit_program.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANCEL'.
      LEAVE PROGRAM.
    WHEN 'SAVECONFIG'.
      PERFORM on_save_button.

    WHEN 'CONFIG'.  "'Open Script'
      PERFORM get_variants.
    WHEN 'EXECUTE'.
      g_grid_step->check_changed_data( ).
      PERFORM ptf_run.

    WHEN 'APLOG'.
      PERFORM ap_log.
    WHEN 'DELETE'.
      PERFORM delete_variant.
    WHEN 'TRANS'.

    WHEN 'VARCAT'.
      PERFORM get_catalog.
    WHEN 'DETAILS'.
      gb_property_display_only = abap_true.
      PERFORM create_displ_properties_popup.
      CLEAR gb_property_display_only.
    WHEN 'WIKI'.
      CALL METHOD cl_gui_frontend_services=>execute
        EXPORTING
          document               = 'https://wiki.wdf.sap.corp/wiki/pages/viewpage.action?spaceKey=SimplSuite&title=Process+Test+Framework'
        EXCEPTIONS
          cntl_error             = 1
          error_no_gui           = 2
          bad_parameter          = 3
          file_not_found         = 4
          path_not_found         = 5
          file_extension_unknown = 6
          error_execute_failed   = 7
          synchronous_failed     = 8
          not_supported_by_gui   = 9
          OTHERS                 = 10.
      IF sy-subrc <> 0.
      ENDIF.
    WHEN 'DOWNLOAD'.
      PERFORM download_script.
    WHEN 'UPLOAD'.
      PERFORM upload_script.

    WHEN 'VARDATASET'.
      PERFORM open_vardatasets.

    WHEN OTHERS.
*     do nothing
  ENDCASE.
  CLEAR ok_code.
ENDMODULE.

*---------------------------------------------------------------------*
*       FORM Build Fieldcatalog                                           *
*---------------------------------------------------------------------*
FORM build_fieldcatalog.
  DATA ls_fieldcatalog  TYPE lvc_s_fcat.

* STEP_NUMBER***********************************************
  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'STEP_NUMBER'.
  ls_fieldcatalog-scrtext_l = 'Step'.
  ls_fieldcatalog-just = 'C'.
  INSERT ls_fieldcatalog INTO TABLE gt_fieldcatalog_step.
* Business Object***********************************************
  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'BUS_OBJ'.
  ls_fieldcatalog-scrtext_l = 'Business Object'.
  ls_fieldcatalog-outputlen = '30'.
  ls_fieldcatalog-just = 'C'.
  ls_fieldcatalog-edit = 'X'.
  ls_fieldcatalog-checktable = '!'.
  ls_fieldcatalog-f4availabl = 'X'.
  ls_fieldcatalog-convexit = 'PTFRB'.
  ls_fieldcatalog-rollname = 'PTF_BO'.
*  ls_fieldcatalog-hotspot  = abap_on.
  INSERT ls_fieldcatalog INTO TABLE gt_fieldcatalog_step.
* ACTION***********************************************
  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'ACTION'.
  ls_fieldcatalog-scrtext_l = 'Action'.
  ls_fieldcatalog-outputlen = '30'.
  ls_fieldcatalog-just = 'C'.
  ls_fieldcatalog-edit = 'X'.
  ls_fieldcatalog-checktable = '!'.
  ls_fieldcatalog-f4availabl = 'X'.
  ls_fieldcatalog-convexit = 'PTFRA'.
  ls_fieldcatalog-rollname = 'PTF_ACT'.
  INSERT ls_fieldcatalog INTO TABLE gt_fieldcatalog_step.
* VARIANT***********************************************
  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'VARIANT'.
  ls_fieldcatalog-scrtext_l = 'Variant'.
  DATA lv_rfc TYPE c LENGTH 32.                                   "ERX Nov 2023
  GET PARAMETER ID 'PTF_RFC_FOR_TDC' FIELD lv_rfc.                "ERX Nov 2023
  IF lv_rfc IS NOT INITIAL.                                       "ERX Nov 2023
    ls_fieldcatalog-scrtext_l = |Variant (uses RFC { lv_rfc } )|. "ERX Nov 2023
  ENDIF.                                                          "ERX Nov 2023
  ls_fieldcatalog-outputlen = '61'.
  ls_fieldcatalog-just = 'C'.
*  ls_fieldcatalog-edit = 'X'.
  ls_fieldcatalog-checktable = '!'.
  ls_fieldcatalog-f4availabl = 'X'.
  ls_fieldcatalog-rollname = 'PTF_TDCV'.
  INSERT ls_fieldcatalog INTO TABLE gt_fieldcatalog_step.
* Testdata Container***********************************************
  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'TEST_DATA_CONTAINER'.
  ls_fieldcatalog-scrtext_l = 'Testdata Container'.
  ls_fieldcatalog-outputlen = '31'.
  ls_fieldcatalog-just = 'C'.
*  ls_fieldcatalog-edit = 'X'.
  ls_fieldcatalog-checktable = '!'.
  ls_fieldcatalog-f4availabl = 'X'.
  ls_fieldcatalog-rollname = 'TEST_DATA_CONTAINER'.
  INSERT ls_fieldcatalog INTO TABLE gt_fieldcatalog_step.
* REFERENCE_STEP***********************************************
  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'REFERENCE_STEP'.
  ls_fieldcatalog-scrtext_l = 'Reference Step'.
  ls_fieldcatalog-just = 'C'.
  ls_fieldcatalog-outputlen = '16'.
  ls_fieldcatalog-edit = 'X'.
  ls_fieldcatalog-rollname = 'PTF_REF_STEP'.
  ls_fieldcatalog-no_zero = 'X'.
  INSERT ls_fieldcatalog INTO TABLE gt_fieldcatalog_step.
*********************************************************************
  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'REFERENCE_STEP_MORE'.
  ls_fieldcatalog-scrtext_l = ' '.
  ls_fieldcatalog-icon = 'X'.
  ls_fieldcatalog-just = 'C'.
  ls_fieldcatalog-outputlen = '2'.
  ls_fieldcatalog-style = cl_gui_alv_grid=>mc_style_button.
  ls_fieldcatalog-tooltip = 'Additional reference steps'.
  INSERT ls_fieldcatalog INTO TABLE gt_fieldcatalog_step.
* JSON***********************************************
*  CASE sy-uname.
*    WHEN 'GRIESEC' OR 'BURNAR' OR '_SAPD049099' OR '_SAPI550454'.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'JSON_FILE_MORE'.
  ls_fieldcatalog-scrtext_l = ' '.
  ls_fieldcatalog-icon = 'X'.
  ls_fieldcatalog-just = 'C'.
  ls_fieldcatalog-outputlen = '2'.
*  ls_fieldcatalog-style   = cl_gui_alv_grid=>mc_style_button.
  ls_fieldcatalog-tooltip = 'Manage JSON data container'.
  INSERT ls_fieldcatalog INTO TABLE gt_fieldcatalog_step.

*  ENDCASE.
* REFERENCE_Document ID***********************************************
*  CLEAR ls_fieldcatalog.
*  ls_fieldcatalog-fieldname = 'REFERENCE_DOCUMENT_ID'.
*  ls_fieldcatalog-scrtext_l = 'Reference Document ID'.
*  ls_fieldcatalog-just = 'C'.
*  ls_fieldcatalog-outputlen = '16'.
*  ls_fieldcatalog-edit = 'X'.
*  INSERT ls_fieldcatalog INTO TABLE gt_fieldcatalog_step.
*********************************************************************
*  CLEAR ls_fieldcatalog.
*  ls_fieldcatalog-fieldname = 'REFERENCE_DOCUMENT_ID_MORE'.
*  ls_fieldcatalog-scrtext_l = ' '.
*  ls_fieldcatalog-icon = 'X'.
*  ls_fieldcatalog-just = 'C'.
*  ls_fieldcatalog-outputlen = '2'.
*  ls_fieldcatalog-style = cl_gui_alv_grid=>mc_style_button.
*  ls_fieldcatalog-tooltip = 'Additional reference document IDs'.
*  INSERT ls_fieldcatalog INTO TABLE gt_fieldcatalog_step.
* Document ID***********************************************
  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'DOCUMENT_ID'.
  ls_fieldcatalog-scrtext_l = 'Document ID'.
  ls_fieldcatalog-outputlen = '11'.
*  ls_fieldcatalog-outputlen = '16'.
  INSERT ls_fieldcatalog INTO TABLE gt_fieldcatalog_step.
*********************************************************************
  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'DOCUMENT_ID_MORE'.
  ls_fieldcatalog-scrtext_l = ' '.
  ls_fieldcatalog-icon = 'X'.
  ls_fieldcatalog-just = 'C'.
  ls_fieldcatalog-outputlen = '2'.
  ls_fieldcatalog-style = cl_gui_alv_grid=>mc_style_button.
  ls_fieldcatalog-tooltip = 'Additional document IDs'.
  INSERT ls_fieldcatalog INTO TABLE gt_fieldcatalog_step.
* Execution Status***********************************************
  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'EXECUTION_STATUS'.
  ls_fieldcatalog-scrtext_l = 'Execution Status'.
  ls_fieldcatalog-icon = 'X'.
  ls_fieldcatalog-just = 'C'.
  ls_fieldcatalog-outputlen = '16'.
  INSERT ls_fieldcatalog INTO TABLE gt_fieldcatalog_step.
* Check Status***********************************************
  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'CHECK_STATUS'.
  ls_fieldcatalog-scrtext_l = 'Check Status'.
  ls_fieldcatalog-icon = 'X'.
  ls_fieldcatalog-just = 'C'.
  ls_fieldcatalog-outputlen = '16'.
  INSERT ls_fieldcatalog INTO TABLE gt_fieldcatalog_step.
ENDFORM.
*---------------------------------------------------------------------*
*       FORM Init Container                                          *
*---------------------------------------------------------------------*
FORM init_container.
  CREATE OBJECT go_custom_container_step
    EXPORTING
      container_name = gc_container_step.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE GRID
*&---------------------------------------------------------------------*
FORM create_grid .
  CREATE OBJECT g_grid_step
    EXPORTING
      i_parent = go_custom_container_step.

  CALL METHOD g_grid_step->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_modified.

  CREATE OBJECT go_step_event_receiver.

  SET HANDLER go_step_event_receiver->on_f4 FOR g_grid_step.
  SET HANDLER go_step_event_receiver->on_toolbar FOR g_grid_step.
  SET HANDLER go_step_event_receiver->on_data_changed FOR g_grid_step.
  SET HANDLER go_step_event_receiver->on_data_changed_finished FOR g_grid_step.
  SET HANDLER go_step_event_receiver->on_button_click FOR g_grid_step.
  SET HANDLER go_step_event_receiver->on_double_click FOR g_grid_step.
  SET HANDLER go_step_event_receiver->button_click FOR g_grid_step.
  SET HANDLER go_step_event_receiver->on_double_click FOR g_grid_step.
  SET HANDLER go_step_event_receiver->on_context_menu FOR g_grid_step.
  SET HANDLER go_step_event_receiver->handle_context_enhancement FOR g_grid_step.

*  DATA lv_eligible TYPE abap_bool.
*  PERFORM check_user CHANGING lv_eligible.
*  IF lv_eligible = abap_on.
  SET HANDLER go_step_event_receiver->handle_delayed_changed_sel_cb FOR g_grid_step.

  CALL METHOD g_grid_step->register_delayed_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_delayed_change_select.
*  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_TABLE_FOR_FIRST_DISPLAY
*&---------------------------------------------------------------------*
FORM set_table_for_first_display .
  DATA: ls_variant TYPE disvariant,
        ls_layout  TYPE lvc_s_layo.
  ls_variant-report = sy-repid.

  ls_layout-stylefname = 'HANDLE_STYLE'. "Change editablity of columns

  CALL METHOD g_grid_step->set_table_for_first_display
    EXPORTING
      is_variant      = ls_variant   " Layout
      i_save          = 'U'   " Save Layout
      i_default       = 'X'    " Default Display Variant
      is_layout       = ls_layout
    CHANGING
      it_outtab       = gt_outtab_step
      it_fieldcatalog = gt_fieldcatalog_step.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM EXIT_PROGRAM                                             *
*---------------------------------------------------------------------*
FORM exit_program.

  DATA: lv_answer TYPE c.

  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'Y'              " Positioning the cursor on answer yes or no
      textline1      = 'Do you really want to leave PTF ?'                 " first line of dialog box
*     textline2      = space            " second line of dialog box
      titel          = 'EXIT'                 " Title line of dialog box
*     start_column   = 25               " Start column of the dialog box
*     start_row      = 6                " Start line of the dialog box
      cancel_display = ' '              " Display cancel button
    IMPORTING
      answer         = lv_answer.               " selected answer of end user

  IF lv_answer EQ 'J'.
    LEAVE PROGRAM.
  ENDIF.

ENDFORM.

**&---------------------------------------------------------------------*
**& Form create_popup
**&---------------------------------------------------------------------*
*FORM create_popup.
*
*  PERFORM popup_for_selection.
*
**  WHILE g_exit = 'X'.   "since version 40
**    CLEAR g_exit.
**    PERFORM popup_for_selection.
**  ENDWHILE.
*
*  CLEAR: p_vname, p_vdescr, p_name, p_date, p_usersp, p_nouser, p_si, p_tag.
*
*ENDFORM.

FORM popup_for_selection CHANGING cv_selection_index TYPE syst_tabix.

  DATA lt_dummy_exclude TYPE TABLE OF rsexfcode.
  DATA lv_user TYPE char1.

  CLEAR cv_selection_index.
  CLEAR: p_vname, p_vdescr, p_name, p_date, p_chname, p_chdate, p_usersp, p_nouser, p_si, p_tag.

  CALL FUNCTION 'RS_SET_SELSCREEN_STATUS'
    EXPORTING
      p_status  = 'SELECT_STATUS'   " Status To Be Set
      p_program = sy-repid   " Program to which the status belongs
    TABLES
      p_exclude = lt_dummy_exclude.

  CALL SELECTION-SCREEN '2001' STARTING AT 10 10.  "Parameter entry

  IF gv_cancel = abap_true.
    CLEAR gv_cancel.
    RETURN.
  ENDIF.

  IF p_vname    IS NOT INITIAL
    OR p_vdescr IS NOT INITIAL
    OR p_name   IS NOT INITIAL
    OR p_date   IS NOT INITIAL
    OR p_chname IS NOT INITIAL
    OR p_chdate IS NOT INITIAL
    OR p_usersp IS NOT INITIAL
    OR p_nouser IS NOT INITIAL
    OR p_si     IS NOT INITIAL
    OR p_tag    IS NOT INITIAL.

    PERFORM set_userspecific CHANGING lv_user. "reads p_usersp, p_nouser

    DATA ls_sel_param TYPE ptf_selection.
    ls_sel_param-varname          = p_vname.
    ls_sel_param-erdat            = p_date.
    ls_sel_param-vardescr         = p_vdescr.
    ls_sel_param-ernam            = p_name.
    ls_sel_param-last_change_date = p_chdate.
    ls_sel_param-last_change_user = p_chname.
    ls_sel_param-scope_item       = p_si.
    ls_sel_param-tag              = p_tag.
    ls_sel_param-user_specific    = lv_user.
  ENDIF.
  DATA(go_variants) = NEW cl_ptf_variant( ).
  go_variants->read_for_selection(
    EXPORTING
      is_sel_param     = ls_sel_param
    IMPORTING
      et_selection_tab = gt_selection ).


  "Call popup with found variants for selection
  DATA(variant_display) = NEW cl_ptf_alv_elements( ).
  TRY.
      variant_display->show_list_of_variants(
        IMPORTING
          selected_index = DATA(lv_index)
        CHANGING
          usages         = gt_selection
        RECEIVING
          selection      = DATA(selected_variant)
      ).
    CATCH cx_salv_msg.
      MESSAGE ID 'PTF' TYPE 'S' NUMBER 044 DISPLAY LIKE 'E'.
  ENDTRY.

  cv_selection_index = lv_index.
  DATA(lv_varname_found) = selected_variant-varname.

ENDFORM.

FORM set_userspecific CHANGING cv_user.
  IF p_usersp IS INITIAL
    AND p_nouser IS INITIAL.
    cv_user = abap_false.
  ELSEIF
    p_usersp IS NOT INITIAL
    AND p_nouser IS NOT INITIAL.
    cv_user = abap_false.
  ELSEIF
    p_usersp IS NOT INITIAL      "'User-specific only'  = X
    AND p_nouser IS INITIAL.
    cv_user = abap_true.
  ELSEIF
    p_usersp IS INITIAL
    AND p_nouser IS NOT INITIAL. "'Non user-specific only'  = X
    cv_user = 'c'.
  ENDIF.
ENDFORM.

FORM refresh_stepdata.    "clears and fills with 40 fresh lines both  gt_step_data  and gt_outtab_step(numbered)

  DATA ls_step_data    TYPE cl_ptf_util=>gt_ptf_step.
  DATA ls_outtab_step  TYPE cl_ptf_util=>ty_outtab.
  DATA ls_handle_style TYPE lvc_s_styl.

  CLEAR gt_step_data.
  CLEAR gt_outtab_step.

  " Prepare standard values in ls_outtab_step

***toDo: extract following lines to a reuse object to be called from here and from Form on_button_click
*  gs_outtab_step-reference_document_id_more = icon_enter_more.
  ls_outtab_step-reference_step_more = icon_enter_more.
  ls_outtab_step-json_file_more      = icon_text_ina.

  CLEAR ls_handle_style.
  ls_handle_style-fieldname = 'VARIANT'.
  ls_handle_style-style     = cl_gui_alv_grid=>mc_style_enabled.
  INSERT ls_handle_style INTO TABLE ls_outtab_step-handle_style.

  CLEAR ls_handle_style.
  ls_handle_style-fieldname = 'TEST_DATA_CONTAINER'.
  ls_handle_style-style     = cl_gui_alv_grid=>mc_style_enabled.
  INSERT ls_handle_style INTO TABLE ls_outtab_step-handle_style.

  CLEAR ls_handle_style.
  ls_handle_style-fieldname = 'JSON_FILE_MORE'.
*  ls_handle_style-style     = cl_gui_alv_grid=>mc_style_button.
*  ls_handle_style-style2    = cl_gui_alv_grid=>mc_style_disabled.
  INSERT ls_handle_style INTO TABLE ls_outtab_step-handle_style.

  DO 40 TIMES.
    ls_outtab_step-step_number = ls_outtab_step-step_number + 1.
    APPEND ls_outtab_step TO gt_outtab_step.
    ls_step_data-step_number = ls_outtab_step-step_number.
    APPEND ls_step_data TO gt_step_data.
  ENDDO.

  CALL METHOD g_grid_step->refresh_table_display.

ENDFORM.

FORM check_au_settings.

  "Execution of unit tests allowed in this client?
  IF ( NOT cl_aunit_permission_control=>is_test_enabled_client( ) ).
    MESSAGE e200(sabp_unit).
  ENDIF.

  "Check needed risk level - PTF AU classes have risk level Dangerous
  DATA(current_max_risk_level) = cl_aunit_permission_control=>get_max_risk_level( ).
  IF current_max_risk_level NE if_aunit_attribute_enums=>c_risk_level-critical AND
    current_max_risk_level NE if_aunit_attribute_enums=>c_risk_level-dangerous.
    MESSAGE e060(ptf).
  ENDIF.

ENDFORM.


*---------------------------- 3001 ---------------------------------------------------------------------
MODULE pai_3001 INPUT.

  FIELD-SYMBOLS <ls_outtab_step> TYPE cl_ptf_util=>ty_outtab.

  g_grid_more->check_changed_data( ).

  READ TABLE gt_step_data   ASSIGNING FIELD-SYMBOL(<ls_step_data_pai>) INDEX gv_row_number-row_id.
  READ TABLE gt_outtab_step ASSIGNING <ls_outtab_step> INDEX gv_row_number-row_id.

  CASE gv_col_id.
    WHEN  'REFERENCE_STEP_MORE'.

      LOOP AT gt_outtab_ref_step ASSIGNING FIELD-SYMBOL(<ls_outtab_ref_step>).

        "Fill/clear the field in the main view
        IF sy-tabix = 1 AND  <ls_outtab_ref_step>-ref_step_number IS NOT INITIAL AND <ls_outtab_ref_step>-ref_step_number NE 0.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
            EXPORTING
              input  = <ls_outtab_ref_step>
            IMPORTING
              output = <ls_outtab_step>-reference_step.
        ENDIF.
        IF sy-tabix = 1 AND  ( <ls_outtab_ref_step>-ref_step_number IS INITIAL OR <ls_outtab_ref_step>-ref_step_number EQ 0 ). "new
          CLEAR <ls_outtab_step>-reference_step. "field
        ENDIF.

        IF <ls_outtab_ref_step>-ref_step_number IS INITIAL OR <ls_outtab_ref_step>-ref_step_number EQ 0.
          DELETE gt_outtab_ref_step INDEX sy-tabix.
        ENDIF.

      ENDLOOP.

      "update gt_step_data
      <ls_step_data_pai>-reference_step = gt_outtab_ref_step.

      DESCRIBE TABLE gt_outtab_ref_step LINES DATA(lv_lines).
      IF lv_lines > 1.
        <ls_outtab_step>-reference_step_more = icon_display_more.
      ELSE.
        <ls_outtab_step>-reference_step_more = icon_enter_more.
      ENDIF.

*    WHEN 'REFERENCE_DOCUMENT_ID_MORE'.
*      LOOP AT gt_outtab_ref_doc_id ASSIGNING FIELD-SYMBOL(<ls_outtab_ref_doc_id>).
*        IF sy-tabix = 1 AND <ls_outtab_ref_doc_id>-vbeln IS INITIAL.
*          <ls_outtab_step>-reference_document_id = <ls_outtab_ref_doc_id>.
*        ENDIF.
*        IF <ls_outtab_ref_doc_id>-vbeln IS INITIAL.
*          DELETE gt_outtab_ref_doc_id INDEX sy-tabix.
*        ENDIF.
*      ENDLOOP.
*
*      <ls_step_data>-reference_document_id = gt_outtab_ref_doc_id.
*      DESCRIBE TABLE gt_outtab_ref_doc_id LINES lv_lines.
*      IF lv_lines > 1.
*        <ls_outtab_step>-reference_document_id_more = icon_display_more.
*      ELSE.
*        <ls_outtab_step>-reference_document_id_more = icon_enter_more.
*      ENDIF.

    WHEN  'DOCUMENT_ID_MORE'.
      LOOP AT gt_outtab_doc_id ASSIGNING FIELD-SYMBOL(<ls_outtab_doc_id>).

        "Fill/clear the field in the main view
        IF sy-tabix = 1 AND  <ls_outtab_doc_id>-vbeln IS NOT INITIAL AND <ls_outtab_doc_id>-vbeln NE '0'. "0 used as numeric dumps if key is not numeric
*          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*            EXPORTING
*              input  = <ls_outtab_doc_id>
*            IMPORTING
*              output = <ls_outtab_step>-document_id.
          <ls_outtab_step>-document_id = <ls_outtab_doc_id>.  "alpha conversion here looked weird, as non manual steps do not have it for field document_id in the main ALV
        ENDIF.
        IF sy-tabix = 1 AND  ( <ls_outtab_doc_id>-vbeln IS INITIAL OR <ls_outtab_doc_id>-vbeln EQ '0' ). "new "0 used as numeric dumps if key is not numeric
          CLEAR <ls_outtab_step>-document_id. "field
        ENDIF.

        IF <ls_outtab_doc_id>-vbeln IS INITIAL OR <ls_outtab_doc_id>-vbeln EQ '0'. "0 used as numeric dumps if key is not numeric
          DELETE gt_outtab_doc_id INDEX sy-tabix.
        ENDIF.

      ENDLOOP.

      "update gt_step_data
      <ls_step_data_pai>-document_id = gt_outtab_doc_id.

      IF <ls_outtab_step>-is_manual EQ abap_true.
        DESCRIBE TABLE gt_outtab_doc_id LINES DATA(lv_lines2).
        IF lv_lines2 > 1.
          <ls_outtab_step>-document_id_more = icon_display_more.
        ELSE.
          <ls_outtab_step>-document_id_more = icon_enter_more.
        ENDIF.
      ENDIF.

  ENDCASE.

  g_grid_more->free( ).
  g_custom_container_ref_step->free( ).
  CLEAR: gt_outtab_ref_step, gt_outtab_doc_id, gt_outtab_ref_doc_id, gt_fieldcatalog_more.

  g_grid_step->refresh_table_display( ).

  CASE more_ok.
    WHEN 'CONTI'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PAI_3001  INPUT
*&---------------------------------------------------------------------*
MODULE pbo_3001 OUTPUT.

  DATA ls_fieldcatalog   TYPE lvc_s_fcat.
  DATA step_id_2char     TYPE c LENGTH 2.
  DATA cnt_records_3char TYPE c LENGTH 3.

  step_id_2char = gv_row_number-row_id.

  SET PF-STATUS 'MORE3001'.
*******************************************************************************************
  CASE gv_col_id.
    WHEN  'REFERENCE_STEP_MORE'.
*      READ TABLE gt_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data_pbo>) INDEX gv_row_number-row_id.
*      cnt_records_3char = lines( <ls_step_data_pbo>-reference_step ).
      SET TITLEBAR 'MORE' WITH step_id_2char 'Reference Steps'.

      CLEAR ls_fieldcatalog.
      ls_fieldcatalog-fieldname = 'REF_STEP_NUMBER'.
      ls_fieldcatalog-scrtext_l = 'Reference Step'.
      ls_fieldcatalog-edit = 'X'.
      ls_fieldcatalog-checktable = '!'.
      ls_fieldcatalog-no_zero = 'X'.
      APPEND ls_fieldcatalog TO  gt_fieldcatalog_more.
*    WHEN 'REFERENCE_DOCUMENT_ID_MORE'.
*      CLEAR ls_fieldcatalog.
*      ls_fieldcatalog-fieldname = 'VBELN'.
*      ls_fieldcatalog-scrtext_l = 'Reference Document ID'.
*      ls_fieldcatalog-edit = 'X'.
*      ls_fieldcatalog-checktable = '!'.
*      APPEND ls_fieldcatalog TO  gt_fieldcatalog_more.

    WHEN 'DOCUMENT_ID_MORE'.
      READ TABLE gt_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data_pbo>) INDEX gv_row_number-row_id.
      cnt_records_3char = lines( <ls_step_data_pbo>-document_id ).
      SET TITLEBAR 'RESULT_ID' WITH step_id_2char cnt_records_3char.

      CLEAR ls_fieldcatalog.
      ls_fieldcatalog-fieldname = 'VBELN'.
      ls_fieldcatalog-scrtext_l = 'Document ID'.
      IF <ls_step_data_pbo>-is_manual EQ abap_true.
        ls_fieldcatalog-edit = 'X'.
*        ls_fieldcatalog-checktable = '!'.
*        ls_fieldcatalog-no_zero = 'X'.
      ENDIF.
      APPEND ls_fieldcatalog TO gt_fieldcatalog_more.

  ENDCASE.
*******************************************************************************************
  CREATE OBJECT g_custom_container_ref_step
    EXPORTING
      container_name = 'TABLE'.

  CREATE OBJECT g_grid_more
    EXPORTING
      i_parent = g_custom_container_ref_step.

  CALL METHOD g_grid_more->set_ready_for_input
    EXPORTING
      i_ready_for_input = 1.

  CALL METHOD g_grid_more->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_modified.
*******************************************************************************************
  CREATE OBJECT go_step_event_receiver.
  SET HANDLER go_step_event_receiver->on_data_changed FOR g_grid_more.

  CASE gv_col_id.
    WHEN  'REFERENCE_STEP_MORE'.
      CREATE OBJECT go_ptf_tables_event.
      SET HANDLER go_ptf_tables_event->on_toolbar FOR g_grid_more.
      SET HANDLER go_ptf_tables_event->on_button_click FOR g_grid_more.
      SET HANDLER go_ptf_tables_event->on_data_changed_ref_step FOR g_grid_more.
*      SET HANDLER go_ptf_tables_event->on_data_ch_finished_ref_step FOR g_grid_more.
*    WHEN 'REFERENCE_DOCUMENT_ID_MORE'.
*      CREATE OBJECT go_ptf_tables_event.
*      SET HANDLER go_ptf_tables_event->on_toolbar FOR g_grid_more.
*      SET HANDLER go_ptf_tables_event->on_button_click FOR g_grid_more.
*      SET HANDLER go_ptf_tables_event->on_data_changed_ref_step FOR g_grid_more.  "??
**      SET HANDLER go_ptf_tables_event->on_data_ch_finished_ref_step FOR g_grid_more.
  ENDCASE.
*******************************************************************************************
  CASE gv_col_id.

    WHEN  'REFERENCE_STEP_MORE'.

      "Build gt_outtab_ref_step, mainly from gt_step_data.

      CLEAR gt_outtab_ref_step.

      CALL METHOD g_grid_more->set_table_for_first_display
        CHANGING
          it_outtab       = gt_outtab_ref_step
          it_fieldcatalog = gt_fieldcatalog_more.

      DO 20 TIMES.
        APPEND INITIAL LINE TO gt_outtab_ref_step.
      ENDDO.

*Read main current Input of main alv
      READ TABLE gt_outtab_step INTO DATA(ls_outtab_step_pbo) INDEX gv_row_number-row_id.
*Read old input of reference step
      READ TABLE gt_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data>) INDEX gv_row_number-row_id.
      IF <ls_step_data> IS NOT ASSIGNED.
        BREAK griesec.
      ENDIF.
*Add new input main alv to old input
      IF <ls_step_data>-reference_step IS INITIAL.
        APPEND INITIAL LINE TO <ls_step_data>-reference_step.
      ENDIF.
*       IF gs_outtab_step-reference_step CN '0123456789'.
*          MESSAGE ID 'PTF' TYPE 'S' NUMBER 040 DISPLAY LIKE 'E'.
*         RETURN.
*       ENDIF.
      MODIFY <ls_step_data>-reference_step FROM ls_outtab_step_pbo-reference_step INDEX 1.    "outtab field reference_step is written to index 1 of itab reference_step in step_data

*Move content to reference step outtab
      LOOP AT <ls_step_data>-reference_step ASSIGNING FIELD-SYMBOL(<ls_reference_step>).
        IF <ls_reference_step> IS NOT INITIAL.
          MODIFY gt_outtab_ref_step FROM <ls_reference_step> INDEX sy-tabix.
        ENDIF.
      ENDLOOP.


*    WHEN 'REFERENCE_DOCUMENT_ID_MORE'.
*
*      CALL METHOD g_grid_more->set_table_for_first_display
*        CHANGING
*          it_outtab       = gt_outtab_ref_doc_id
*          it_fieldcatalog = gt_fieldcatalog_more.
*
*      DO 20 TIMES.
*        APPEND gs_outtab_ref_doc_id TO gt_outtab_ref_doc_id.
*      ENDDO.
*
**Read main current Input of main alv
*      READ TABLE gt_outtab_step INTO gs_outtab_step INDEX gv_row_number-row_id.
**Read old input of reference doc id
*      READ TABLE gt_step_data ASSIGNING <ls_step_data> INDEX gv_row_number-row_id.
**Add new input main alv to old input
*      IF <ls_step_data>-reference_step IS INITIAL.
*        APPEND INITIAL LINE TO <ls_step_data>-reference_step.
*      ENDIF.
*      MODIFY <ls_step_data>-reference_document_id FROM gs_outtab_step-reference_document_id   INDEX 1.
**Move content to reference doc id outtab
*      LOOP AT <ls_step_data>-reference_step ASSIGNING FIELD-SYMBOL(<reference_document_id>).
*        IF <reference_document_id> IS NOT INITIAL.
*          MODIFY gt_outtab_ref_doc_id FROM <reference_document_id> INDEX sy-tabix.
*        ENDIF.
*      ENDLOOP.


    WHEN 'DOCUMENT_ID_MORE'.

      DATA: ls_layout_doc_id  TYPE lvc_s_layo,
            lt_toolbar_doc_id TYPE ui_functions.

      CLEAR gt_outtab_doc_id.

      READ TABLE gt_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data_pbo_2>) INDEX gv_row_number-row_id.

      "Enable toolbar for add/delete line
      IF sy-subrc = 0 AND <ls_step_data_pbo_2>-is_manual EQ abap_true."    AND 1 = 2.
        CREATE OBJECT go_ptf_tables_event.
        SET HANDLER go_ptf_tables_event->on_toolbar FOR g_grid_more.
        SET HANDLER go_ptf_tables_event->on_button_click FOR g_grid_more.
        SET HANDLER go_ptf_tables_event->on_data_changed_ref_step FOR g_grid_more.
        ls_layout_doc_id-no_toolbar = ''.
      ELSE.
        ls_layout_doc_id-no_toolbar = 'X'.
      ENDIF.

      CALL METHOD g_grid_more->set_table_for_first_display
        EXPORTING
          is_layout            = ls_layout_doc_id
          it_toolbar_excluding = lt_toolbar_doc_id
        CHANGING
          it_outtab            = gt_outtab_doc_id
          it_fieldcatalog      = gt_fieldcatalog_more.

      "Fill gt_outtab_doc_id for the current step, from gt_step_data

      DO 20 TIMES.
        APPEND gs_outtab_doc_id TO gt_outtab_doc_id.  "initial line
      ENDDO.

*                                                following coding seems to be copied from this above:     WHEN  'REFERENCE_STEP_MORE'.
*Read main current Input of main alv
      READ TABLE gt_outtab_step INTO DATA(ls_outtab_step_pbo2) INDEX gv_row_number-row_id.
**Read old input
*      READ TABLE gt_step_data ASSIGNING FIELD-SYMBOL(<ls_step_data_2>) INDEX gv_row_number-row_id.
*Add new input main alv to old input
      IF <ls_step_data_pbo_2> IS NOT ASSIGNED.
        BREAK griesec.
      ENDIF.
      IF <ls_step_data_pbo_2>-document_id IS INITIAL.
        APPEND INITIAL LINE TO <ls_step_data_pbo_2>-document_id.
      ENDIF.
      MODIFY <ls_step_data_pbo_2>-document_id FROM ls_outtab_step_pbo2-document_id INDEX 1.     "outtab docID is a field, this is written at pos 1 of itab document_id in step_data

*Move content to outtab
      LOOP AT <ls_step_data_pbo_2>-document_id ASSIGNING FIELD-SYMBOL(<ls_document_id>).
        "We always show at least 20 lines. Or as many as filled.
        IF sy-tabix GT 20.
          APPEND gs_outtab_doc_id TO gt_outtab_doc_id.
        ENDIF.

        IF <ls_document_id> IS NOT INITIAL.
          MODIFY gt_outtab_doc_id FROM <ls_document_id> INDEX sy-tabix.
          IF sy-subrc IS NOT INITIAL.
            BREAK griesec.
          ENDIF.
        ENDIF.
      ENDLOOP.

  ENDCASE.


  CALL METHOD g_grid_more->refresh_table_display.

ENDMODULE.
