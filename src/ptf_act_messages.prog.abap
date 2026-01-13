*&---------------------------------------------------------------------*
*& Include          PTF_ACT_MESSAGES
*&---------------------------------------------------------------------*

MODULE pbo_3102 OUTPUT.
  PERFORM pbo_3102.

ENDMODULE.

MODULE pai_3102 INPUT.
  PERFORM pai_3102.

ENDMODULE.



FORM pbo_3102.
  DATA: ls_layout    TYPE lvc_s_layo,
        lv_step_id   TYPE c LENGTH 2.

  SET PF-STATUS 'ACT_MSG_STATUS'.

  lv_step_id = gv_row_number-row_id.

  SET TITLEBAR 'ACTUAL_MESSAGES' WITH lv_step_id.

  IF g_grid_act_msg IS NOT BOUND.
    PERFORM build_act_msg_fieldcatalog.

    CREATE OBJECT g_custom_container_ref_step
      EXPORTING
        container_name = 'TABLE'.

    CREATE OBJECT g_grid_act_msg
      EXPORTING
        i_parent = g_custom_container_ref_step.

*   Read main current Input of main alv
    READ TABLE gt_outtab_step ASSIGNING FIELD-SYMBOL(<fs_outtab_step>) INDEX gv_row_number-row_id.
    IF sy-subrc = 0.
      gt_outtab_act_msg = CORRESPONDING #( <fs_outtab_step>-act_messages ).

*     Fill fulltext
      LOOP AT gt_outtab_act_msg ASSIGNING FIELD-SYMBOL(<fs_outtab_act_msg>).
        IF <fs_outtab_act_msg>-id IS NOT INITIAL AND <fs_outtab_act_msg>-number IS NOT INITIAL.
          IF <fs_outtab_act_msg>-type IS NOT INITIAL.
            MESSAGE ID <fs_outtab_act_msg>-id TYPE <fs_outtab_act_msg>-type NUMBER <fs_outtab_act_msg>-number
            WITH <fs_outtab_act_msg>-message_v1 <fs_outtab_act_msg>-message_v2 <fs_outtab_act_msg>-message_v3 <fs_outtab_act_msg>-message_v4
            INTO <fs_outtab_act_msg>-full_text.

          ELSE.
            MESSAGE ID <fs_outtab_act_msg>-id TYPE 'S' NUMBER <fs_outtab_act_msg>-number
            WITH <fs_outtab_act_msg>-message_v1 <fs_outtab_act_msg>-message_v2 <fs_outtab_act_msg>-message_v3 <fs_outtab_act_msg>-message_v4
            INTO <fs_outtab_act_msg>-full_text.

          ENDIF.

        ENDIF.

      ENDLOOP.

    ENDIF.

    ls_layout-no_toolbar = abap_on.

    g_grid_act_msg->set_table_for_first_display(
      EXPORTING
        is_layout       = ls_layout
      CHANGING
        it_outtab       = gt_outtab_act_msg
        it_fieldcatalog = gt_fieldcatalog_act_msg ).

  ENDIF.

ENDFORM.

FORM pai_3102.
  CASE more_ok.
    WHEN 'CONTI'.
      g_grid_act_msg->free( ).
      g_custom_container_ref_step->free( ).
      CLEAR: g_grid_act_msg, g_custom_container_ref_step.
      CLEAR: gt_outtab_act_msg, gt_fieldcatalog_act_msg.

      CLEAR gv_row_number.

      LEAVE TO SCREEN 0.

  ENDCASE.

ENDFORM.

FORM build_act_msg_fieldcatalog.
  DATA: ls_fieldcatalog     TYPE lvc_s_fcat.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'ID'.
  ls_fieldcatalog-ref_table = 'BAPIRET2'.
  ls_fieldcatalog-outputlen = 20.
  APPEND ls_fieldcatalog TO gt_fieldcatalog_act_msg.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'TYPE'.
  ls_fieldcatalog-ref_table = 'BAPIRET2'.
  ls_fieldcatalog-outputlen = 10.
  APPEND ls_fieldcatalog TO gt_fieldcatalog_act_msg.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'NUMBER'.
  ls_fieldcatalog-ref_table = 'BAPIRET2'.
  ls_fieldcatalog-outputlen = 10.
  APPEND ls_fieldcatalog TO gt_fieldcatalog_act_msg.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'MESSAGE_V1'.
  ls_fieldcatalog-ref_table = 'BAPIRET2'.
  ls_fieldcatalog-outputlen = 10.
  APPEND ls_fieldcatalog TO gt_fieldcatalog_act_msg.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'MESSAGE_V2'.
  ls_fieldcatalog-ref_table = 'BAPIRET2'.
  ls_fieldcatalog-outputlen = 10.
  APPEND ls_fieldcatalog TO gt_fieldcatalog_act_msg.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'MESSAGE_V3'.
  ls_fieldcatalog-ref_table = 'BAPIRET2'.
  ls_fieldcatalog-outputlen = 10.
  APPEND ls_fieldcatalog TO gt_fieldcatalog_act_msg.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'MESSAGE_V4'.
  ls_fieldcatalog-ref_table = 'BAPIRET2'.
  ls_fieldcatalog-outputlen = 10.
  APPEND ls_fieldcatalog TO gt_fieldcatalog_act_msg.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname = 'FULL_TEXT'.
  ls_fieldcatalog-scrtext_m = 'Full Text'.
  ls_fieldcatalog-outputlen = 50.
  APPEND ls_fieldcatalog TO gt_fieldcatalog_act_msg.

ENDFORM.
