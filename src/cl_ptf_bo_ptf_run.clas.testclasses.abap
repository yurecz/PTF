*"* use this source file for your ABAP unit test classes

* Local Test Class for method apply expectations
CLASS ltc_apply_expectations DEFINITION DEFERRED.
CLASS cl_ptf_bo_ptf_run DEFINITION LOCAL FRIENDS ltc_apply_expectations.

CLASS ltc_apply_expectations DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.

  PRIVATE SECTION.

    CLASS-METHODS class_setup.
    CLASS-METHODS class_teardown.

    METHODS setup.
    METHODS teardown.

    METHODS _01_msgid_pos FOR TESTING.
    METHODS _02_msgid_neg FOR TESTING.
    METHODS _03_ne_msgid_pos FOR TESTING.
    METHODS _04_ne_msgid_neg FOR TESTING.
    METHODS _05_msgid_msgtyp_pos FOR TESTING.
    METHODS _06_msgid_msgtyp_neg FOR TESTING.
    METHODS _07_msgid_msgtyp_msgno_low_pos FOR TESTING.
    METHODS _08_msgid_msgtyp_msgno_low_neg FOR TESTING.
    METHODS _09_msgid_msgtyp_msgno_lh_pos FOR TESTING.
    METHODS _10_msgid_msgtyp_msgno_lh_neg FOR TESTING.
    METHODS _11_msgid_msgv1_pos FOR TESTING.
    METHODS _12_msgid_msgv1_neg FOR TESTING.
    METHODS _13_msgid_msgno_or_pos FOR TESTING.
    METHODS _14_msgid_msgno_and_neg FOR TESTING.
    METHODS _15_msgid_ops_pos FOR TESTING.
    METHODS _16_msgid_ops_neg FOR TESTING.

    DATA mo_cut TYPE REF TO cl_ptf_bo_ptf_run.

ENDCLASS.

CLASS ltc_apply_expectations IMPLEMENTATION.
  METHOD class_setup.

  ENDMETHOD.

  METHOD setup.

  ENDMETHOD.

  METHOD teardown.

  ENDMETHOD.

  METHOD class_teardown.

  ENDMETHOD.

  METHOD _01_msgid_pos.
    DATA lt_exp_messages TYPE ptf_exp_message_t.
    DATA lt_act_messages TYPE bapirettab.
    DATA lt_step_data    TYPE cl_ptf_util=>gt_ptf_step_tab.

    lt_exp_messages = VALUE #( ( msgid = 'PTF' ) ).
    lt_act_messages = VALUE #( ( id    = 'PTF' ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW #( lo_ptf_run ).

    "when
    mo_cut->apply_expectations(
      EXPORTING
        it_exp_messages = lt_exp_messages
        it_act_messages = lt_act_messages
        iv_bus_obj      = 'PTF_RUN'
        iv_step_number  = 1
      IMPORTING
        ev_check_status = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_check_status ).

  ENDMETHOD.

  METHOD _02_msgid_neg.
    DATA lt_exp_messages TYPE ptf_exp_message_t.
    DATA lt_act_messages TYPE bapirettab.
    DATA lt_step_data    TYPE cl_ptf_util=>gt_ptf_step_tab.

    lt_exp_messages = VALUE #( ( msgid = 'PTF' ) ).
    lt_act_messages = VALUE #( ( id    = 'NPTF' ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW #( lo_ptf_run ).

    "when
    mo_cut->apply_expectations(
      EXPORTING
        it_exp_messages = lt_exp_messages
        it_act_messages = lt_act_messages
        iv_bus_obj      = 'PTF_RUN'
        iv_step_number  = 1
      IMPORTING
        ev_check_status = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_check_status ).

  ENDMETHOD.

  METHOD _03_ne_msgid_pos.
    DATA lt_exp_messages TYPE ptf_exp_message_t.
    DATA lt_act_messages TYPE bapirettab.
    DATA lt_step_data    TYPE cl_ptf_util=>gt_ptf_step_tab.

    lt_exp_messages = VALUE #( ( opt = 'NOTCONTAIN' msgid = 'PTF' ) ).
    lt_act_messages = VALUE #( ( id  = 'NPTF' ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW #( lo_ptf_run ).

    "when
    mo_cut->apply_expectations(
      EXPORTING
        it_exp_messages = lt_exp_messages
        it_act_messages = lt_act_messages
        iv_bus_obj      = 'PTF_RUN'
        iv_step_number  = 1
      IMPORTING
        ev_check_status = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_check_status ).

  ENDMETHOD.

  METHOD _04_ne_msgid_neg.
    DATA lt_exp_messages TYPE ptf_exp_message_t.
    DATA lt_act_messages TYPE bapirettab.
    DATA lt_step_data    TYPE cl_ptf_util=>gt_ptf_step_tab.

    lt_exp_messages = VALUE #( ( opt = 'NOTCONTAIN' msgid = 'PTF' ) ).
    lt_act_messages = VALUE #( ( id  = 'PTF' ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW #( lo_ptf_run ).

    "when
    mo_cut->apply_expectations(
      EXPORTING
        it_exp_messages = lt_exp_messages
        it_act_messages = lt_act_messages
        iv_bus_obj      = 'PTF_RUN'
        iv_step_number  = 1
      IMPORTING
        ev_check_status = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_check_status ).

  ENDMETHOD.

  METHOD _05_msgid_msgtyp_pos.
    DATA lt_exp_messages TYPE ptf_exp_message_t.
    DATA lt_act_messages TYPE bapirettab.
    DATA lt_step_data    TYPE cl_ptf_util=>gt_ptf_step_tab.

    lt_exp_messages = VALUE #( ( msgid = 'PTF' msgty = 'I' ) ).
    lt_act_messages = VALUE #( ( id  = 'PTF' type = 'I' ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW #( lo_ptf_run ).

    "when
    mo_cut->apply_expectations(
      EXPORTING
        it_exp_messages = lt_exp_messages
        it_act_messages = lt_act_messages
        iv_bus_obj      = 'PTF_RUN'
        iv_step_number  = 1
      IMPORTING
        ev_check_status = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_check_status ).

  ENDMETHOD.

  METHOD _06_msgid_msgtyp_neg.
    DATA lt_exp_messages TYPE ptf_exp_message_t.
    DATA lt_act_messages TYPE bapirettab.
    DATA lt_step_data    TYPE cl_ptf_util=>gt_ptf_step_tab.

    lt_exp_messages = VALUE #( ( msgid = 'PTF' msgty = 'I' ) ).
    lt_act_messages = VALUE #( ( id  = 'PTF' type = 'E' ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW #( lo_ptf_run ).

    "when
    mo_cut->apply_expectations(
      EXPORTING
        it_exp_messages = lt_exp_messages
        it_act_messages = lt_act_messages
        iv_bus_obj      = 'PTF_RUN'
        iv_step_number  = 1
      IMPORTING
        ev_check_status = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_check_status ).

  ENDMETHOD.

  METHOD _07_msgid_msgtyp_msgno_low_pos.
    DATA lt_exp_messages TYPE ptf_exp_message_t.
    DATA lt_act_messages TYPE bapirettab.
    DATA lt_step_data    TYPE cl_ptf_util=>gt_ptf_step_tab.

    lt_exp_messages = VALUE #( ( msgid = 'PTF' msgty = 'I' msgno_low = '012' ) ).
    lt_act_messages = VALUE #( ( id  = 'PTF' type = 'I' number = '012' ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW #( lo_ptf_run ).

    "when
    mo_cut->apply_expectations(
      EXPORTING
        it_exp_messages = lt_exp_messages
        it_act_messages = lt_act_messages
        iv_bus_obj      = 'PTF_RUN'
        iv_step_number  = 1
      IMPORTING
        ev_check_status = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_check_status ).

  ENDMETHOD.

  METHOD _08_msgid_msgtyp_msgno_low_neg.
    DATA lt_exp_messages TYPE ptf_exp_message_t.
    DATA lt_act_messages TYPE bapirettab.
    DATA lt_step_data    TYPE cl_ptf_util=>gt_ptf_step_tab.

    lt_exp_messages = VALUE #( ( msgid = 'PTF' msgty = 'I' msgno_low = '012' ) ).
    lt_act_messages = VALUE #( ( id  = 'PTF' type = 'I' number = '014' ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW #( lo_ptf_run ).

    "when
    mo_cut->apply_expectations(
      EXPORTING
        it_exp_messages = lt_exp_messages
        it_act_messages = lt_act_messages
        iv_bus_obj      = 'PTF_RUN'
        iv_step_number  = 1
      IMPORTING
        ev_check_status = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_check_status ).

  ENDMETHOD.

  METHOD _09_msgid_msgtyp_msgno_lh_pos.
    DATA lt_exp_messages TYPE ptf_exp_message_t.
    DATA lt_act_messages TYPE bapirettab.
    DATA lt_step_data    TYPE cl_ptf_util=>gt_ptf_step_tab.

    lt_exp_messages = VALUE #( ( msgid = 'PTF' msgty = 'I' msgno_low = '012' msgno_high = '015' ) ).
    lt_act_messages = VALUE #( ( id  = 'PTF' type = 'I' number = '014' ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW #( lo_ptf_run ).

    "when
    mo_cut->apply_expectations(
      EXPORTING
        it_exp_messages = lt_exp_messages
        it_act_messages = lt_act_messages
        iv_bus_obj      = 'PTF_RUN'
        iv_step_number  = 1
      IMPORTING
        ev_check_status = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_check_status ).

  ENDMETHOD.

  METHOD _10_msgid_msgtyp_msgno_lh_neg.
    DATA lt_exp_messages TYPE ptf_exp_message_t.
    DATA lt_act_messages TYPE bapirettab.
    DATA lt_step_data    TYPE cl_ptf_util=>gt_ptf_step_tab.

    lt_exp_messages = VALUE #( ( msgid = 'PTF' msgty = 'I' msgno_low = '012' msgno_high = '015' ) ).
    lt_act_messages = VALUE #( ( id  = 'PTF' type = 'I' number = '016' ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW #( lo_ptf_run ).

    "when
    mo_cut->apply_expectations(
      EXPORTING
        it_exp_messages = lt_exp_messages
        it_act_messages = lt_act_messages
        iv_bus_obj      = 'PTF_RUN'
        iv_step_number  = 1
      IMPORTING
        ev_check_status = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_check_status ).

  ENDMETHOD.

  METHOD _11_msgid_msgv1_pos.
    DATA lt_exp_messages TYPE ptf_exp_message_t.
    DATA lt_act_messages TYPE bapirettab.
    DATA lt_step_data    TYPE cl_ptf_util=>gt_ptf_step_tab.

    lt_exp_messages = VALUE #( ( msgid = 'PTF' msgv1 = '%sy-uname' ) ).
    lt_act_messages = VALUE #( ( id  = 'PTF' message_v1 = sy-uname ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW #( lo_ptf_run ).

    "when
    mo_cut->apply_expectations(
      EXPORTING
        it_exp_messages = lt_exp_messages
        it_act_messages = lt_act_messages
        iv_bus_obj      = 'PTF_RUN'
        iv_step_number  = 1
      IMPORTING
        ev_check_status = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_check_status ).

  ENDMETHOD.

  METHOD _12_msgid_msgv1_neg.
    DATA lt_exp_messages TYPE ptf_exp_message_t.
    DATA lt_act_messages TYPE bapirettab.
    DATA lt_step_data    TYPE cl_ptf_util=>gt_ptf_step_tab.

    lt_exp_messages = VALUE #( ( msgid = 'PTF' msgv1 = '%sy-uname' ) ).
    lt_act_messages = VALUE #( ( id  = 'PTF' message_v1 = space ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW #( lo_ptf_run ).

    "when
    mo_cut->apply_expectations(
      EXPORTING
        it_exp_messages = lt_exp_messages
        it_act_messages = lt_act_messages
        iv_bus_obj      = 'PTF_RUN'
        iv_step_number  = 1
      IMPORTING
        ev_check_status = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_check_status ).

  ENDMETHOD.

  METHOD _13_msgid_msgno_or_pos.
    DATA lt_exp_messages TYPE ptf_exp_message_t.
    DATA lt_act_messages TYPE bapirettab.
    DATA lt_step_data    TYPE cl_ptf_util=>gt_ptf_step_tab.

    lt_exp_messages = VALUE #( ( msgid = 'PTF1' operator = 'OR' ) ( msgid = 'PTF2' ) ).
    lt_act_messages = VALUE #( ( id  = 'PTF2' ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW #( lo_ptf_run ).

    "when
    mo_cut->apply_expectations(
      EXPORTING
        it_exp_messages = lt_exp_messages
        it_act_messages = lt_act_messages
        iv_bus_obj      = 'PTF_RUN'
        iv_step_number  = 1
      IMPORTING
        ev_check_status = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_check_status ).

  ENDMETHOD.

  METHOD _14_msgid_msgno_and_neg.
    DATA lt_exp_messages TYPE ptf_exp_message_t.
    DATA lt_act_messages TYPE bapirettab.
    DATA lt_step_data    TYPE cl_ptf_util=>gt_ptf_step_tab.

    lt_exp_messages = VALUE #( ( msgid = 'PTF1' operator = 'AND' ) ( msgid = 'PTF2' ) ).
    lt_act_messages = VALUE #( ( id  = 'PTF2' ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW #( lo_ptf_run ).

    "when
    mo_cut->apply_expectations(
      EXPORTING
        it_exp_messages = lt_exp_messages
        it_act_messages = lt_act_messages
        iv_bus_obj      = 'PTF_RUN'
        iv_step_number  = 1
      IMPORTING
        ev_check_status = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_check_status ).

  ENDMETHOD.

  METHOD _15_msgid_ops_pos.
    DATA lt_exp_messages TYPE ptf_exp_message_t.
    DATA lt_act_messages TYPE bapirettab.
    DATA lt_step_data    TYPE cl_ptf_util=>gt_ptf_step_tab.

    lt_exp_messages = VALUE #(  ( msgid = 'PTF1' operator = 'OR' )
                                ( msgid = 'PTF2' operator = 'AND' )
                                ( msgid = 'PTF3' operator = 'OR' )
                                ( msgid = 'PTF4' operator = 'AND' )
                                ( msgid = 'PTF5' )
                             ).

    lt_act_messages = VALUE #( ( id  = 'PTF2' ) ( id  = 'PTF4' ) ( id  = 'PTF5' ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW #( lo_ptf_run ).

    "when
    mo_cut->apply_expectations(
      EXPORTING
        it_exp_messages = lt_exp_messages
        it_act_messages = lt_act_messages
        iv_bus_obj      = 'PTF_RUN'
        iv_step_number  = 1
      IMPORTING
        ev_check_status = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_true( act = lv_check_status ).

  ENDMETHOD.

  METHOD _16_msgid_ops_neg.
    DATA lt_exp_messages TYPE ptf_exp_message_t.
    DATA lt_act_messages TYPE bapirettab.
    DATA lt_step_data    TYPE cl_ptf_util=>gt_ptf_step_tab.

    lt_exp_messages = VALUE #(  ( msgid = 'PTF1' operator = 'OR' )
                                ( msgid = 'PTF2' operator = 'AND' )
                                ( msgid = 'PTF3' operator = 'OR' )
                                ( msgid = 'PTF4' operator = 'AND' )
                                ( msgid = 'PTF5' )
                             ).

    lt_act_messages = VALUE #( ( id  = 'PTF2' ) ( id  = 'PTF5' ) ).

    DATA(lo_ptf_run) = NEW cl_ptf_run( it_ptf_steps = lt_step_data ).

    "given
    mo_cut = NEW #( lo_ptf_run ).

    "when
    mo_cut->apply_expectations(
      EXPORTING
        it_exp_messages = lt_exp_messages
        it_act_messages = lt_act_messages
        iv_bus_obj      = 'PTF_RUN'
        iv_step_number  = 1
      IMPORTING
        ev_check_status = DATA(lv_check_status)
    ).

    "then
    cl_abap_unit_assert=>assert_false( act = lv_check_status ).

  ENDMETHOD.

ENDCLASS.
