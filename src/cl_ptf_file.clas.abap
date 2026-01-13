class CL_PTF_FILE definition
  public
  final
  create public .

public section.

  interfaces IF_PTF_FILE .

  constants GC_NO_SCRIPT_NAME type PTF_VARNAME value 'DOWNLOAD_WITHOUT_NAME' ##NO_TEXT.
  constants GC_ABAP_STRUCTDESCR type STRING value 'CL_ABAP_STRUCTDESCR' ##NO_TEXT.
  constants GC_ABAP_ELEMDESCR type STRING value 'CL_ABAP_ELEMDESCR' ##NO_TEXT.
protected section.
private section.

  types:
    BEGIN OF ts_script,
      attributes TYPE if_ptf_file~ts_attributes,
      text_table TYPE if_ptf_file~tt_text_table,
      tag_table  TYPE if_ptf_file~tt_ptf_var_tags,
      step_table TYPE TABLE OF cl_ptf_variant=>gty_step_data WITH DEFAULT KEY,
    END OF ts_script .
  types:
    BEGIN OF ts_ptf_script,
      script     TYPE ts_script,
    END OF ts_ptf_script .

  methods SERIALIZE
    importing
      !IS_SCRIPT_FILE type TS_PTF_SCRIPT
    exporting
      !EV_JSON type STRING .
  methods DESERIALIZE
    importing
      !IV_JSON type STRING
    exporting
      !ES_ATTRIBUTES type IF_PTF_FILE~TS_ATTRIBUTES
      !ET_TEXT_TABLE type IF_PTF_FILE~TT_TEXT_TABLE
      !ET_TAG_TABLE type IF_PTF_FILE~TT_PTF_VAR_TAGS
      !ET_VARIANT_TAB type CL_PTF_VARIANT=>GTY_STEP_DATA_TAB
    raising
      CX_PTF_JSON .
ENDCLASS.



CLASS CL_PTF_FILE IMPLEMENTATION.


  METHOD deserialize.

    DATA: lr_data             TYPE REF TO data,
          lo_structdescr      TYPE REF TO cl_abap_structdescr,
          lo_refdescr         TYPE REF TO cl_abap_refdescr,
          lo_typedescr        TYPE REF TO cl_abap_typedescr,
          lt_components       TYPE abap_component_tab,
          lt_tab_comp         TYPE abap_component_tab,
          lv_comp_name_source TYPE string,
          lv_comp_name_target TYPE string,
          ls_ptf_var_tags     TYPE ptf_variant_tag_input.

    FIELD-SYMBOLS: <fs_step_table>     TYPE ANY TABLE,
                   <fs_ptf_file>       TYPE any,
                   <fs_var_tags_table> TYPE ANY TABLE,
                   <fs_table_source>   TYPE ANY TABLE,
                   <fs_text_table>     TYPE ANY TABLE,
*                   <fs_table_target>   TYPE cl_ptf_util=>gty_reference_tab,
                   <fs_line_target>    TYPE any,
                   <fs_table_target>   TYPE INDEX TABLE,
                   <fs_component>      TYPE abap_componentdescr.

    DATA(lv_json) = iv_json.

*   Cleanup JSON
    cl_ptf_json=>cleanup_json( CHANGING cv_json = lv_json ).

*   Validate JSON
    cl_ptf_json=>validate_json( iv_json = iv_json ).

*   Do the actual deserialization
    /ui2/cl_json=>deserialize(
        EXPORTING
          json          = lv_json
          assoc_arrays  = abap_on
        CHANGING
          data          = lr_data ).

    IF lr_data IS NOT BOUND.
      RAISE EXCEPTION NEW cx_ptf_json( textid = cx_ptf_json=>invalid_json ).
    ENDIF.

    ASSIGN lr_data->* TO <fs_ptf_file>.

    ASSIGN COMPONENT 'SCRIPT' OF STRUCTURE <fs_ptf_file> TO FIELD-SYMBOL(<fs_script>).
    IF <fs_script> IS ASSIGNED.

      ASSIGN COMPONENT 'ATTRIBUTES' OF STRUCTURE <fs_script>->* TO FIELD-SYMBOL(<fs_attributes>).
      IF <fs_attributes> IS ASSIGNED.
        lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_attributes>->* ).
        lt_components = lo_structdescr->get_components( ).

        LOOP AT lt_components ASSIGNING <fs_component>.
          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_attributes>->* TO FIELD-SYMBOL(<fs_value_source>).
          ASSIGN COMPONENT <fs_component>-name OF STRUCTURE es_attributes     TO FIELD-SYMBOL(<fs_value_target>).
          IF <fs_value_source> IS ASSIGNED AND <fs_value_target> IS ASSIGNED.
            lo_typedescr = cl_abap_typedescr=>describe_by_data( <fs_value_target> ).
            IF lo_typedescr->type_kind EQ cl_abap_typedescr=>typekind_date.
              REPLACE ALL OCCURRENCES OF SUBSTRING '-' IN <fs_value_source>->* WITH ''.
            ENDIF.
            <fs_value_target> = <fs_value_source>->*.
          ENDIF.
          UNASSIGN: <fs_value_target>, <fs_value_source>.
        ENDLOOP.
        CLEAR: lt_components.
      ENDIF.


      ASSIGN COMPONENT 'TEXT_TABLE' OF STRUCTURE <fs_script>->* TO FIELD-SYMBOL(<fs_table>).
      IF <fs_table> IS ASSIGNED.
        ASSIGN <fs_table>->* TO <fs_text_table>.
        LOOP AT <fs_text_table> ASSIGNING FIELD-SYMBOL(<fs_line>).
          APPEND INITIAL LINE TO et_text_table ASSIGNING FIELD-SYMBOL(<fs_text_line>).
          <fs_text_line> = <fs_line>->*.
        ENDLOOP.
        UNASSIGN <fs_table>.
      ENDIF.


      ASSIGN COMPONENT 'TAG_TABLE' OF STRUCTURE <fs_script>->* TO <fs_table>.
      IF <fs_table> IS ASSIGNED.
        ASSIGN <fs_table>->* TO <fs_var_tags_table>.
        lo_structdescr ?= cl_abap_structdescr=>describe_by_data( ls_ptf_var_tags ).
        lt_components = lo_structdescr->get_components( ).
        LOOP AT <fs_var_tags_table> ASSIGNING <fs_line>.
          APPEND INITIAL LINE TO et_tag_table ASSIGNING FIELD-SYMBOL(<fs_var_tags_line>).

          LOOP AT lt_components ASSIGNING <fs_component>.
            ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_line>->*        TO <fs_value_source>.
            ASSIGN COMPONENT <fs_component>-name OF STRUCTURE <fs_var_tags_line>  TO <fs_value_target>.
            IF <fs_value_target> IS ASSIGNED AND <fs_value_source> IS ASSIGNED.
              <fs_value_target> = <fs_value_source>->*.
            ENDIF.
            UNASSIGN: <fs_value_target>, <fs_value_source>.
          ENDLOOP.
        ENDLOOP.
        CLEAR: lt_components.
      ENDIF.

      ASSIGN COMPONENT 'STEP_TABLE' OF STRUCTURE <fs_script>->* TO FIELD-SYMBOL(<fs_body_tab>).
      IF <fs_body_tab> IS ASSIGNED.
        ASSIGN <fs_body_tab>->* TO <fs_step_table>.
        LOOP AT <fs_step_table> ASSIGNING FIELD-SYMBOL(<fs_step_line>).
          IF lt_components IS INITIAL.
            lo_structdescr ?= cl_abap_structdescr=>describe_by_data( <fs_step_line>->* ).
            lt_components = lo_structdescr->get_components( ).
          ENDIF.

          APPEND INITIAL LINE TO et_variant_tab ASSIGNING FIELD-SYMBOL(<fs_line_variant>).

          LOOP AT lt_components ASSIGNING <fs_component>.
            TRY.
                IF <fs_component>-name EQ 'JSON_FILE'.
                  lv_comp_name_target = 'INPUT_STRING'.
                  lv_comp_name_source = <fs_component>-name.
                ELSE.
                  lv_comp_name_source = lv_comp_name_target = <fs_component>-name.
                ENDIF.
                ASSIGN COMPONENT lv_comp_name_source OF STRUCTURE <fs_step_line>->* TO <fs_value_source>.
                ASSIGN COMPONENT lv_comp_name_target OF STRUCTURE <fs_line_variant> TO <fs_value_target>.

                IF <fs_value_source> IS ASSIGNED AND <fs_value_target> IS ASSIGNED.

*             Check if it's a standard table
                  lo_typedescr = cl_abap_typedescr=>describe_by_data( <fs_value_source>->* ).

                  DATA lo_tabledescr TYPE REF TO cl_abap_tabledescr.

                  CASE lo_typedescr->type_kind.
                    WHEN cl_abap_typedescr=>typekind_table. "itab.
                      ASSIGN <fs_value_source>->* TO <fs_table_source>.
                      ASSIGN <fs_value_target> TO <fs_table_target>.

                      IF lines( <fs_table_source> ) > 0.
                        lo_tabledescr ?= cl_abap_typedescr=>describe_by_data( <fs_table_target> ).

                        DATA(lo_line_type) = lo_tabledescr->get_table_line_type( ).
                        DATA(lo_ref_descr) = cl_abap_typedescr=>describe_by_object_ref( lo_line_type ).
                        DATA(lv_string) = lo_ref_descr->get_relative_name( ).

                        CASE lo_ref_descr->get_relative_name( ).
                          WHEN gc_abap_structdescr.
                            lo_structdescr ?= lo_tabledescr->get_table_line_type( ).
                            lt_tab_comp = lo_structdescr->get_components( ).

                            LOOP AT <fs_table_source> ASSIGNING FIELD-SYMBOL(<fs_line_source>).
                              APPEND INITIAL LINE TO <fs_table_target> ASSIGNING <fs_line_target>.

                              LOOP AT lt_tab_comp ASSIGNING FIELD-SYMBOL(<fs_tab_comp>).
                                ASSIGN COMPONENT <fs_tab_comp>-name OF STRUCTURE <fs_line_source>->* TO <fs_value_source>.
                                ASSIGN COMPONENT <fs_tab_comp>-name OF STRUCTURE <fs_line_target>    TO <fs_value_target>.
                                IF <fs_value_target> IS ASSIGNED AND <fs_value_source> IS ASSIGNED.
                                  <fs_value_target> = <fs_value_source>->*.
                                ENDIF.
                                UNASSIGN: <fs_value_target>, <fs_value_source>.
                              ENDLOOP.
                            ENDLOOP.

                          WHEN gc_abap_elemdescr.
                            LOOP AT <fs_table_source> ASSIGNING <fs_line_source>.
                              APPEND INITIAL LINE TO <fs_table_target> ASSIGNING <fs_line_target>.
                              <fs_line_target> = <fs_line_source>->*.
                            ENDLOOP.

                        ENDCASE.
                      ENDIF.
                    WHEN OTHERS.
                      <fs_value_target> = <fs_value_source>->*.
                  ENDCASE.

                ENDIF.

              CATCH cx_root.

            ENDTRY.
            UNASSIGN: <fs_value_source>, <fs_value_target>.
          ENDLOOP.
        ENDLOOP.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_file~download.

    DATA: lv_filename	       TYPE string,
          lv_defaultfilename TYPE string,
          lv_path	           TYPE string,
          lv_fullpath	       TYPE string,
          lv_user_action     TYPE i,
          lt_data_tab        TYPE stringtab,
          ls_ptf_script      TYPE ts_ptf_script.

    ls_ptf_script-script-attributes = is_attributes.
    IF ls_ptf_script-script-attributes-varname IS INITIAL.
      ls_ptf_script-script-attributes-varname = gc_no_script_name. "'DOWNLOAD_WITHOUT_NAME'
      ls_ptf_script-script-attributes-ernam   = sy-uname.
    ENDIF.

    ls_ptf_script-script-attributes-download_system     = sy-sysid.
    ls_ptf_script-script-attributes-download_client     = sy-mandt.
    ls_ptf_script-script-attributes-file_creation_date  = sy-datum.
    ls_ptf_script-script-attributes-file_format_version = 1.

    APPEND LINES OF it_text_table   TO ls_ptf_script-script-text_table.
    APPEND LINES OF it_tag_table    TO ls_ptf_script-script-tag_table.
    APPEND LINES OF it_variant_data TO ls_ptf_script-script-step_table.

    serialize(
      EXPORTING
        is_script_file = ls_ptf_script
      IMPORTING
        ev_json        = DATA(lv_json) ).

    APPEND lv_json TO lt_data_tab.

    IF is_attributes-varname IS NOT INITIAL.
      CONCATENATE is_attributes-varname '-' sy-sysid '-' sy-mandt '_' sy-datum '_' sy-timlo '.ptf' INTO lv_defaultfilename.
    ELSE.
      CONCATENATE 'newptfscript-'           sy-sysid '-' sy-mandt '_' sy-datum '_' sy-timlo '.ptf' INTO lv_defaultfilename.
    ENDIF.


* Show the file download dialog
    cl_gui_frontend_services=>file_save_dialog(
      EXPORTING
        default_file_name    = lv_defaultfilename
        default_extension    = 'PTF'
      CHANGING
        filename             = lv_filename
        path                 = lv_path
        fullpath             = lv_fullpath
        user_action          = lv_user_action
      EXCEPTIONS
        cntl_error           = 1
        error_no_gui         = 2
        not_supported_by_gui = 3
        OTHERS               = 4 ).

    CHECK sy-subrc IS INITIAL AND lv_fullpath IS NOT INITIAL.

    cl_gui_frontend_services=>gui_download(
      EXPORTING
        filename                  = lv_fullpath                     " Name of file
        replacement               = ''
      CHANGING
        data_tab                  = lt_data_tab                     " Transfer table
      EXCEPTIONS
        file_write_error          = 1
        no_batch                  = 2
        gui_refuse_filetransfer   = 3
        invalid_type              = 4
        no_authority              = 5
        unknown_error             = 6
        header_not_allowed        = 7
        separator_not_allowed     = 8
        filesize_not_allowed      = 9
        header_too_long           = 10
        dp_error_create           = 11
        dp_error_send             = 12
        dp_error_write            = 13
        unknown_dp_error          = 14
        access_denied             = 15
        dp_out_of_memory          = 16
        disk_full                 = 17
        dp_timeout                = 18
        file_not_found            = 19
        dataprovider_exception    = 20
        control_flush_error       = 21
        not_supported_by_gui      = 22
        error_no_gui              = 23
        OTHERS                    = 24
    ).
    IF sy-subrc <> 0.
      CHECK sy-msgid IS NOT INITIAL.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDMETHOD.


  METHOD if_ptf_file~upload.

    DATA: lt_data_tab   TYPE stringtab,
          lt_file_table TYPE filetable,
          lv_json       TYPE string,
          lv_filename   TYPE string,
          lv_rc         TYPE i,
          lv_exists     TYPE abap_bool.

* Show the file upload dialog
    cl_gui_frontend_services=>file_open_dialog(
      CHANGING
        file_table              = lt_file_table                 " Table Holding Selected Files
        rc                      = lv_rc                 " Return Code, Number of Files or -1 If Error Occurred
    ).
    IF sy-subrc <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*       WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    READ TABLE lt_file_table ASSIGNING FIELD-SYMBOL(<fs_file_name>) INDEX 1.
    IF sy-subrc = 0.
      lv_filename = <fs_file_name>.

      cl_gui_frontend_services=>file_exist(
        EXPORTING
          file                 = lv_filename                 " File to Check
        RECEIVING
          result               = lv_exists                 " Result
*        EXCEPTIONS
*          cntl_error           = 1                " Control error
*          error_no_gui         = 2                " Error: No GUI
*          wrong_parameter      = 3                " Incorrect parameter
*          not_supported_by_gui = 4                " GUI does not support this
*          others               = 5
      ).
      IF sy-subrc <> 0.
*         MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*           WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.


      IF lv_exists = abap_true.
        cl_gui_frontend_services=>gui_upload(
          EXPORTING
            filename                = lv_filename            " Name of file
          CHANGING
            data_tab                = lt_data_tab                " Transfer table for file contents
        ).
        IF sy-subrc <> 0.
*           MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*             WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.

        LOOP AT lt_data_tab ASSIGNING FIELD-SYMBOL(<fs_data_tab>).
          CONCATENATE lv_json <fs_data_tab> INTO lv_json.
        ENDLOOP.

        TRY.
            deserialize(
              EXPORTING
                iv_json         = lv_json
              IMPORTING
                es_attributes   = es_attributes                " Selection attributes for PTF
                et_text_table   = et_text_table
                et_tag_table    = et_tag_table
                et_variant_tab  = et_variant_tab
            ).
          CATCH cx_ptf_json INTO DATA(lx_ptf_json).
            ev_error_text = lx_ptf_json->get_text( ).
            ev_error = abap_true.
        ENDTRY.
      ENDIF.
    ELSE.
      ev_error = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD serialize.

    DATA ls_ptf_script           TYPE ts_ptf_script.

    ASSIGN is_script_file TO FIELD-SYMBOL(<ft_data>).

*   Do the actual deserialization
    /ui2/cl_json=>serialize(                         "considers the domain values descriptions, at least e.g. Boolean 'X' became "true"
      EXPORTING
        data             = <ft_data>                 " Data to serialize
      RECEIVING
        r_json           = ev_json ).

  ENDMETHOD.
ENDCLASS.
