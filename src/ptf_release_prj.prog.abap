*&---------------------------------------------------------------------*
*& Report PTF_RELEASE_PRJ
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT PTF_RELEASE_PRJ.

*PARAMETERS p_prj_id type ps_pspid.
*
*DATA: lo_class        TYPE REF TO cl_sd_eppm_int_tst_automn,
*      iv_project_id   TYPE ps_pspid,
**      iv_project_guid TYPE /s4ppm/tv_entity_guid,
*      io_message_hdlr TYPE REF TO /s4ppm/if_ent_message_hdlr,
*      rv_msgtyp       TYPE symsgty.
**      rb_ok           TYPE abap_bool.
*
*CREATE OBJECT lo_class.
*
*
*iv_project_id = p_prj_id.
*
*CALL METHOD lo_class->release_project
*    EXPORTING
*      iv_project_id   = iv_project_id
*      iv_object_type  = 'DPO'
*      io_message_hdlr = io_message_hdlr
*    RECEIVING
*      rv_msgtyp       = rv_msgtyp.
*
*
*write: 'rv_msgtyp: ', rv_msgtyp.
