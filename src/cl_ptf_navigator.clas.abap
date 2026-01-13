class CL_PTF_NAVIGATOR definition
  public
  abstract
  final
  create public .

public section.

  types:
    se16n_seltabs TYPE TABLE OF se16n_seltab .

  class-methods GO_TO_BDEF
    importing
      !BDEF type PTF_BO
      !NEW_WINDOW type ABAP_BOOL .
  class-methods GO_TO_RESSOURCE
    importing
      !RESOURCE type STRING
      !NEW_WINDOW type ABAP_BOOL
      !PTFBOA type PTFBOA optional .
  class-methods GO_TO_CONFIG
    importing
      !CONFIG_TABLE type STRING
      !FILTER type SE16N_SELTABS .
  class-methods GO_TO_TDC_VARIANT
    importing
      !IV_TDC type ETOBJ_NAME
      !IV_TDCP type ETP_NAME
      !IV_TDCV type PTF_TDCV .
  PROTECTED SECTION.
private section.
ENDCLASS.



CLASS CL_PTF_NAVIGATOR IMPLEMENTATION.


  METHOD go_to_config.
    DATA: table TYPE se16n_tab.
    table = config_table.

    CALL FUNCTION 'SE16N_INTERFACE'
      EXPORTING
        i_tab        = table
      TABLES
        it_selfields = filter
      EXCEPTIONS
        OTHERS       = 1.
    IF sy-subrc IS NOT INITIAL.
      MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno DISPLAY LIKE 'E'.
    ENDIF.
    RETURN.

  ENDMETHOD.


  METHOD go_to_ressource.
    FIND FIRST OCCURRENCE OF REGEX '(\S*)\S+>(\S*)' IN resource SUBMATCHES DATA(lv_classname) DATA(lv_methodname) IGNORING CASE.
    IF sy-subrc <> 0.
      lv_classname = resource.
    ENDIF.


    IF lv_methodname IS INITIAL.
      SELECT SINGLE object FROM tadir WHERE obj_name = @lv_classname INTO @DATA(lv_objtype).
      IF sy-subrc = 0.
        CALL FUNCTION 'RS_TOOL_ACCESS'
          EXPORTING
            operation     = 'SHOW'
            object_name   = lv_classname
            object_type   = lv_objtype
            in_new_window = new_window.
      ENDIF.
    ELSE.
      CALL FUNCTION 'RS_TOOL_ACCESS'
        EXPORTING
          operation           = 'SHOW'
          object_name         = lv_methodname
          object_type         = 'OM'
          enclosing_object    = lv_classname
          in_new_window       = new_window
        EXCEPTIONS
          invalid_object_type = 1
          not_executed        = 2.
      IF sy-subrc <> 0.
        SELECT SINGLE object FROM tadir WHERE obj_name = @lv_classname INTO @DATA(lv_objtype_ex).
        IF sy-subrc = 0.
          CALL FUNCTION 'RS_TOOL_ACCESS'
            EXPORTING
              operation     = 'SHOW'
              object_name   = lv_classname
              object_type   = lv_objtype_ex
              in_new_window = new_window.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD go_to_tdc_variant.

    "Opens TDC, tab 'Variants', and marks cell of given parameter in given variant
    " if parameter und variant do not match (i.e. nothing is maintained for this parameter in this variant), the navigation works anymway, cell is marked

    IF iv_tdc IS INITIAL
      OR iv_tdcp IS INITIAL
      OR iv_tdcv IS INITIAL.
      RETURN.
    ENDIF.

    "behaviour if the IF above would not be there:
    " if only tdc variant is empty, tab 'Variants' opens, the screen will still be at the right column (parameter)
    " if only tdc parameter is empty, tab 'Variants' opens, the screen will be at the first column, first line. Not at the given variant.

    EXPORT activetab FROM cl_gui_ecatt_const=>tr_data_variants TO MEMORY ID 'ACTIVETAB'.

* create object state
    DATA l_object_state            TYPE REF TO if_wb_object_state.
    DATA l_ver_str                 TYPE char8.
    DATA l_properties              TYPE REF TO cl_gui_ecatt_properties.
    DATA ls_cursor                 TYPE etcursor.
    DATA lt_cursortab                 TYPE etcursor_tabtype.
*set cursor
    ls_cursor-obj_part  = cl_apl_ecatt_const=>object_part_var.
    ls_cursor-obj_ref   = iv_tdcp.
    ls_cursor-obj_value = iv_tdcv.
    CLEAR lt_cursortab.
    APPEND ls_cursor TO lt_cursortab.
    CREATE OBJECT l_properties.
    l_properties->set_cursor( lt_cursortab ).
    l_object_state = l_properties.
* create workbench request for displaying
    DATA l_wb_request_set TYPE swbm_wb_request_set .
    DATA l_wb_request TYPE REF TO cl_wb_request.
    DATA l_startup TYPE REF TO cl_wb_startup .
    DATA p_wb_request_set TYPE swbm_wb_request_set .
    DATA p_wb_data_container TYPE REF TO cl_wb_data_container .
    DATA l_object_name TYPE seu_objkey.
* create startup object:
    CREATE OBJECT l_startup.
    l_object_name  = iv_tdc.
    CALL METHOD cl_wb_request=>create_from_fcode
      EXPORTING
        p_fcode        = swbm_c_fc_display
        p_object_type  = swbm_c_type_ecatt_test_data
        p_object_name  = l_object_name
        p_object_state = l_object_state
      RECEIVING
        p_wb_request   = l_wb_request
      EXCEPTIONS
        OTHERS         = 0.
    APPEND l_wb_request TO p_wb_request_set.
* start the Workbench Manager:
    CALL FUNCTION 'WB_MANAGER_START'
      EXPORTING
        startup        = l_startup
        request_set    = p_wb_request_set
      CHANGING
        data_container = p_wb_data_container.

  ENDMETHOD.


  METHOD go_to_bdef.

*    CALL FUNCTION 'RS_TOOL_ACCESS'
*      EXPORTING
*        operation     = 'SHOW'
*        object_name   = bdef
*        object_type   = 'BDEF'
*        in_new_window = new_window.

    DATA(lv_uri) = |adt://{ sy-sysid }/sap/bc/adt/bo/behaviordefinitions/{ bdef }/source/main|.

    CALL METHOD cl_gui_frontend_services=>execute
      EXPORTING
        document = lv_uri
      EXCEPTIONS
        OTHERS   = 1.

  ENDMETHOD.
ENDCLASS.
