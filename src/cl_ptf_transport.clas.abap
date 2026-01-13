class CL_PTF_TRANSPORT definition
  public
  final
  create private .

public section.

  types:
    gty_e071k TYPE STANDARD TABLE OF e071k .
  types:
    gty_ko200 TYPE STANDARD TABLE OF ko200 .

  methods ADD_TRANSPORT_ENTRIES
    importing
      !E071K type E071K
      !KO200 type KO200 .
  methods GET_TRANSPORT_ENTRIES
    exporting
      !ET_KO200 type GTY_KO200
      !ET_E071K type GTY_E071K .
  methods SET_TRANSPORT_ENTRIES
    importing
      !IV_KEY type STRING
      !IV_TABLE_NAME type STRING .
  methods DELETE_TRANSPORT_ENTRIES .
  class-methods FACTORY
    returning
      value(RE_INTANCE) type ref to CL_PTF_TRANSPORT .
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA:
        mo_instance TYPE REF TO cl_ptf_transport.
    DATA gt_ko200 TYPE gty_ko200.
    DATA gt_e071k TYPE gty_e071k.
ENDCLASS.



CLASS CL_PTF_TRANSPORT IMPLEMENTATION.


  METHOD add_transport_entries.
    APPEND e071k TO gt_e071k.
    APPEND ko200 TO gt_ko200.
  ENDMETHOD.


  METHOD delete_transport_entries.
    CLEAR: gt_ko200, gt_e071k.
  ENDMETHOD.


  METHOD factory.
    IF mo_instance IS INITIAL.
      CREATE OBJECT mo_instance.
    ENDIF.
    re_intance = mo_instance.
  ENDMETHOD.


  METHOD get_transport_entries.

    SORT: gt_ko200, gt_e071k.
    DELETE ADJACENT DUPLICATES FROM gt_ko200.
    DELETE ADJACENT DUPLICATES FROM gt_e071k.

    et_ko200 = gt_ko200.
    et_e071k = gt_e071k.

  ENDMETHOD.


  METHOD set_transport_entries.

    DATA: ls_ko200 TYPE ko200,
          ls_e071k TYPE e071k.

    ASSERT IV_KEY is not initial.
    ASSERT IV_TABLE_NAME is not initial.

    ls_ko200-pgmid    = ls_e071k-pgmid   = 'R3TR'.
    ls_ko200-object   = ls_e071k-object  = ls_e071k-mastertype = 'TABU'.
    ls_ko200-obj_name = ls_e071k-objname = ls_e071k-mastername = iv_table_name.
    ls_ko200-objfunc  = 'K'.
    ls_e071k-tabkey = iv_key.
    APPEND ls_ko200 TO gt_ko200.
    APPEND ls_e071k TO gt_e071k.

  ENDMETHOD.
ENDCLASS.
