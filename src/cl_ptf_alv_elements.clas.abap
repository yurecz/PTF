CLASS cl_ptf_alv_elements DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_test_data_container_result,
             tdc_name  TYPE etobj_name,
             tdc_title TYPE et_title,
           END OF ty_test_data_container_result.
    TYPES: ty_test_data_container_results TYPE STANDARD TABLE OF ty_test_data_container_result WITH DEFAULT KEY.

    METHODS: show_list_of_variants
      EXPORTING selected_index   TYPE i
      CHANGING  usages           TYPE cl_ptf_usage=>ptf_selections
      RETURNING VALUE(selection) TYPE ptf_selection
      RAISING   cx_salv_msg,

      show_list_of_ptf_tags
        RETURNING VALUE(ptf_tag) TYPE v_ptf_var_tag
        RAISING   cx_salv_msg.

    METHODS:
      on_double_click FOR EVENT double_click OF cl_salv_events_table
        IMPORTING row column.
    METHODS:
      on_BEFORE_SALV_FUNCTION FOR EVENT BEFORE_SALV_FUNCTION OF CL_SALV_EVENTS
        IMPORTING e_SALV_FUNCTION.

    METHODS: show_list_of_log_statements
      CHANGING statements TYPE cl_ptf_util=>gt_ptf_return_tab
      RAISING  cx_salv_msg.

    METHODS show_list_of_tdcs
      EXPORTING selected_index   TYPE i
      CHANGING  tdcs             TYPE ty_test_data_container_results
      RETURNING VALUE(selection) TYPE ty_test_data_container_result
      RAISING   cx_salv_msg.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: gr_table   TYPE REF TO cl_salv_table,
          selections TYPE salv_t_row.
ENDCLASS.



CLASS CL_PTF_ALV_ELEMENTS IMPLEMENTATION.


  METHOD on_BEFORE_SALV_FUNCTION.
    "when 'Continue' is pressed
    check e_SALV_FUNCTION EQ '&ONT'.
    me->selections = me->gr_table->get_selections( )->get_selected_rows( ).
    me->gr_table->close_screen( ).
  ENDMETHOD.


  METHOD on_double_click.
    me->selections = me->gr_table->get_selections( )->get_selected_rows( ).  "there is also method parameter column
    me->gr_table->close_screen( ).
  ENDMETHOD.


  METHOD show_list_of_log_statements.
    cl_salv_table=>factory(
    EXPORTING
       list_display = ' '
    IMPORTING
       r_salv_table = me->gr_table
    CHANGING
       t_table      = statements
       ).

    me->gr_table->set_screen_popup(
        start_column = 1
        end_column   = 130
        start_line   = 1
        end_line     = 25
      ).

    me->gr_table->set_modus( value = 1 ).

    me->gr_table->get_selections( )->set_selection_mode(
      if_salv_c_selection_mode=>none
    ).

    me->gr_table->get_columns( )->set_optimize(
        value = abap_true
    ).

    me->gr_table->display( ).
    CLEAR me->gr_table.

  ENDMETHOD.


  METHOD show_list_of_ptf_tags.

    DATA(vtags) = cl_ptf_variant_tag_manager=>get_editable_tags_for_user(
      EXPORTING
        user     = sy-uname
        language = sy-langu
    ).

    cl_salv_table=>factory(
    EXPORTING
       list_display = ' '
    IMPORTING
       r_salv_table = me->gr_table
    CHANGING
       t_table      = vtags
       ).
    SET HANDLER me->on_double_click FOR me->gr_table->get_event( ).
    me->gr_table->set_screen_popup(
        start_column = 1
        end_column   = 100
        start_line   = 1
        end_line     = 20
      ).

    me->gr_table->set_modus( value = 1 ).

    me->gr_table->get_selections( )->set_selection_mode(
      if_salv_c_selection_mode=>single
    ).

    me->gr_table->get_columns( )->set_optimize(
        value = abap_true
    ).

    me->gr_table->display( ).

    IF me->selections IS INITIAL.
      me->selections = me->gr_table->get_selections( )->get_selected_rows( ).
    ENDIF.

    IF lines( me->selections ) <> 1.
      RETURN.
    ELSE.
      READ TABLE me->selections INTO DATA(index) INDEX 1.
      READ TABLE vtags INTO ptf_tag INDEX index.
    ENDIF.

    CLEAR me->gr_table.
    CLEAR me->selections.
  ENDMETHOD.


  METHOD show_list_of_tdcs.
    cl_salv_table=>factory(
      EXPORTING
         list_display = ' '
      IMPORTING
         r_salv_table = me->gr_table
      CHANGING
         t_table      = tdcs
    ).
    me->gr_table->set_screen_popup(
        start_column = 1
        end_column   = 93
        start_line   = 1
        end_line     = 20
      ).

    SET HANDLER me->on_double_click FOR me->gr_table->get_event( ).
    me->gr_table->set_modus( value = 1 ).

    me->gr_table->get_selections( )->set_selection_mode(
      if_salv_c_selection_mode=>single
    ).

    me->gr_table->get_columns( )->set_optimize(
        value = abap_true
    ).

    me->gr_table->display( ).

    IF me->selections IS INITIAL.
      me->selections = me->gr_table->get_selections( )->get_selected_rows( ).
    ENDIF.

    IF lines( me->selections ) <> 1.
      RETURN.
    ELSE.
      READ TABLE me->selections INTO DATA(index) INDEX 1.
      selected_index = index.
      READ TABLE tdcs INTO selection INDEX index.
    ENDIF.

    CLEAR me->selections.

  ENDMETHOD.


  METHOD show_list_of_variants.

    cl_salv_table=>factory(
      EXPORTING
         list_display = ' '
      IMPORTING
         r_salv_table = me->gr_table
      CHANGING
         t_table      = usages
    ).
    me->gr_table->set_screen_popup(
        start_column = 1
        end_column   = 140
        start_line   = 1
        end_line     = 25
      ).

    SET HANDLER me->on_before_salv_function FOR me->gr_table->get_event( ).
    SET HANDLER me->on_double_click FOR me->gr_table->get_event( ).
    me->gr_table->set_modus( value = 1 ).

    me->gr_table->get_selections( )->set_selection_mode(
      if_salv_c_selection_mode=>single
    ).

*    data(event) = me->gr_table->get_event( ).

    me->gr_table->get_columns( )->set_optimize(
        value = abap_true
    ).

    me->gr_table->display( ).

    "me->selections is now filled only via events, to leave it initial if the popup is closed with 'Close'(X)

*    IF me->selections IS INITIAL.
*      me->selections = me->gr_table->get_selections( )->get_selected_rows( ).
*    ENDIF.

    IF lines( me->selections ) <> 1.
      RETURN.
    ELSE.
      READ TABLE me->selections INTO DATA(index) INDEX 1.
      selected_index = index.
      READ TABLE usages INTO selection INDEX index.
    ENDIF.

    CLEAR me->gr_table.
    CLEAR me->selections.
  ENDMETHOD.
ENDCLASS.
