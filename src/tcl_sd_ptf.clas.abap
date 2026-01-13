class TCL_SD_PTF definition
  public
  inheriting from TCL_PTF_TEST_CLASS_SUPER
  final
  create public
  for testing
  duration long
  risk level critical .

public section.

  interfaces IF_SD_VA_PTF .
  protected section.
  private section.

    methods execute_ptf_scripts_via_aunit for testing.
ENDCLASS.



CLASS TCL_SD_PTF IMPLEMENTATION.


  method EXECUTE_PTF_SCRIPTS_VIA_AUNIT.

    return.

  endmethod.


  method IF_SD_VA_PTF~EXECUTE_PTF_SCRIPTS_VIA_AUNIT.

    data: lo_tag_mgr type ref to cl_ptf_variant_tag_manager.
    data: lt_tag type cl_ptf_variant_tag_manager=>ptf_simple_tags.
    data: lv_tag like line of lt_tag.
    data: lt_var_name type tcl_ptf_starter=>ty_t_varname.
    data: ls_var_name like line of lt_var_name.
    data: lv_switch_ptf_execution type char1.

    " check user parameter whether script execution is allowed
    get parameter id 'SD_PTF_AUNIT' field lv_switch_ptf_execution.
    check sy-subrc = 0 and lv_switch_ptf_execution = abap_true. " not set => do not run PTF scripts

    " in case other tag shall be used, use it
    get parameter id 'SD_PTF_AUNIT_TAG' field lv_tag.
    if sy-subrc <> 0 or lv_tag is initial.
      lv_tag = iv_ptf_tag.
    endif.
    check lv_tag is not initial.

    " get scripts for the tag
    create object lo_tag_mgr.
    check lo_tag_mgr is bound.

    insert lv_tag into table lt_tag.

    lo_tag_mgr->get_variant_for_tags(
      exporting
        tags     = lt_tag
        user     = sy-uname
      receiving
        variants = data(lt_ptf_variant)
    ).
    check lt_ptf_variant is not initial.

    " run the scripts
    loop at lt_ptf_variant assigning field-symbol(<ls_ptf_variant>).
      insert <ls_ptf_variant>-varname into table lt_var_name.
    endloop.
    _call_named_scripts(
      it_varname = lt_var_name
      iv_add_full_log = 'X' ).

  endmethod.
ENDCLASS.
