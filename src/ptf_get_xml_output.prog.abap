*&---------------------------------------------------------------------*
*& Report PTF_GET_XML_OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ptf_get_xml_output.

TYPES:
  BEGIN OF ty_gs_key,
    name  TYPE string,
    value TYPE string,
  END OF ty_gs_key,
  ty_gt_key TYPE STANDARD TABLE OF ty_gs_key WITH EMPTY KEY.

CONSTANTS: lc_language      TYPE string VALUE 'Language',
           lc_sendercountry TYPE string VALUE 'SenderCountry',
           lc_title         TYPE string VALUE 'XML'.

DATA: ls_entity      TYPE REF TO data,
      lt_key         TYPE ty_gt_key,
      lv_xml_cstring TYPE string,
      lt_xml_cstring TYPE TABLE OF string,
      lv_filename    TYPE string,
      lv_path	       TYPE string,
      lv_fullpath	   TYPE string.

FIELD-SYMBOLS: <ls_entity> TYPE any.

INCLUDE input_screen.

**********************************************************************
AT SELECTION-SCREEN OUTPUT.
**********************************************************************
  IF p_serv IS INITIAL.
    CLEAR: p_fdp11, p_fdp21, p_fdp31, p_fdp41, p_fdp51,
           p_fdp61, p_fdp71, p_fdp81, p_fdp91, p_fdp101,
           p_fdp111, p_fdp121, p_fdp131, p_fdp141, p_fdp151.

    CLEAR: p_fdp12, p_fdp22, p_fdp32, p_fdp42, p_fdp52,
           p_fdp62, p_fdp72, p_fdp82, p_fdp92, p_fdp102,
           p_fdp112, p_fdp122, p_fdp132, p_fdp142, p_fdp152.
  ENDIF.

**********************************************************************
AT SELECTION-SCREEN ON p_serv.
**********************************************************************

  IF p_serv = 'FDP_OM_FORM_MASTER_SRV'.

    CLEAR: p_fdp11, p_fdp21, p_fdp31, p_fdp41, p_fdp51,
               p_fdp61, p_fdp71, p_fdp81, p_fdp91, p_fdp101,
               p_fdp111, p_fdp121, p_fdp131, p_fdp141, p_fdp151.

    CLEAR: p_fdp12, p_fdp22, p_fdp32, p_fdp42, p_fdp52,
           p_fdp62, p_fdp72, p_fdp82, p_fdp92, p_fdp102,
           p_fdp112, p_fdp122, p_fdp132, p_fdp142, p_fdp152.

    p_fdp11 = 'LocaleCountry'.
    p_fdp21 = 'WatermarkText'.
    p_fdp31 = 'Recipient'.
    p_fdp41 = 'RecipientRole'.
    p_fdp51 = 'PrintFormDerivationRule'.
    p_fdp61 = 'OutputDocumentType'.
    p_fdp71 = 'OutputRequestItem'.

    p_fdp22 = 'PTF is the best!'.
    p_fdp32 = 'BP ID'.
    p_fdp42 = 'RE'.
    p_fdp52 = 'Dummy'.
    p_fdp62 = 'BILLING_DOCUMENT'.
    p_fdp72 = '000000'.


  ENDIF.


START-OF-SELECTION.

*******************************************************************************************
* 1. Read output management

  IF p_serv = 'FDP_OM_FORM_MASTER_SRV'.
*  IF  p_locc IS NOT INITIAL AND
*      p_wmtext IS NOT INITIAL AND
*      p_recid IS NOT INITIAL AND
*      p_rrole IS NOT INITIAL AND
*      p_pfdr IS NOT INITIAL AND
*      p_outpt IS NOT INITIAL AND
*      p_itemid IS NOT INITIAL.
*    AND p_apptyp = 'BILLING_DOCUMENT'.

    lt_key = VALUE #( ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-applicationobjecttype     value = p_apptyp  )
                      ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-applicationobjectid       value = p_appid  )
                      ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-localelanguage            value = p_lang )
                      ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-sendercountry             value = p_sendc )
*                      ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-localecountry             value = p_locc     )
*                      ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-watermarktext             value = p_wmtext  )
*                      ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-recipientid               value = p_recid )
*                      ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-recipientrole             value = p_rrole )
*                      ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-printformderivationrule   value = p_pfdr )
*                      ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-outputtype                value = p_outpt )
*                      ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-itemid                    value = p_itemid )
*                                                                                  ).
                      ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-localecountry             value = p_fdp12 )
                      ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-watermarktext             value = p_fdp22 )
                      ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-recipientid               value = p_fdp32 )
                      ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-recipientrole             value = p_fdp42 )
                      ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-printformderivationrule   value = p_fdp52 )
                      ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-outputtype                value = p_fdp62 )
                      ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-itemid                    value = p_fdp72 )
                                                                                  ).
*                      ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-watermarktext             value = 'PTF is the best!'  )
*                      ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-recipientid               value = 'BP ID' )
*                      ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-recipientrole             value = 'RE' )
*                      ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-printformderivationrule   value = 'Dummy' )
*                      ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-outputtype                value = 'BILLING_DOCUMENT' )
*                      ( name  = if_somu_fpd_om_form_master=>gc_query_parameters-itemid                    value = '000000' )
*                                                                                  ).

  ELSE.

    lt_key = VALUE #( ( name  = p_apptyp         value = p_appid  )
                      ( name  = lc_language      value = p_lang )
                      ( name  = lc_sendercountry value = p_sendc )
                      ( name = p_fdp11           value = p_fdp12 )
                      ( name = p_fdp21           value = p_fdp22 )
                      ( name = p_fdp31           value = p_fdp32 )
                      ( name = p_fdp41           value = p_fdp42 )
                      ( name = p_fdp51           value = p_fdp52 )
                      ( name = p_fdp61           value = p_fdp62 )
                      ( name = p_fdp71           value = p_fdp72 )
                      ( name = p_fdp81           value = p_fdp82 )
                      ( name = p_fdp91           value = p_fdp92 )
                      ( name = p_fdp101          value = p_fdp102 )
                      ( name = p_fdp111          value = p_fdp112 )
                      ( name = p_fdp121          value = p_fdp122 )
                      ( name = p_fdp131          value = p_fdp132 )
                      ( name = p_fdp141          value = p_fdp142 )
                      ( name = p_fdp151          value = p_fdp152 )  ).
  ENDIF.

  DELETE lt_key WHERE name = space OR value = space.
*******************************************************************************************
* 2. Read output management
  TRY.
      cl_somu_form_services=>get_instance( )->get_data(
        EXPORTING
          iv_service_name          = p_serv
          it_key                   = lt_key
        IMPORTING
          er_data_container        = ls_entity ).
    CATCH cx_somu_error.
      cl_aunit_assert=>fail( msg = 'Exception has been raised.').
  ENDTRY.
  ASSIGN ls_entity->* TO <ls_entity>.
*******************************************************************************************
* 3. Transform output to XML
  TRY.
      CALL TRANSFORMATION id
      SOURCE data = <ls_entity>
      RESULT XML DATA(lv_xml_xstring).
    CATCH cx_transformation_error INTO DATA(lx_root).
      cl_aunit_assert=>fail( msg = 'Exception has been raised.').
  ENDTRY.

  lv_xml_cstring = cl_proxy_service=>xstring2cstring( xstring = lv_xml_xstring ).
*******************************************************************************************
* 4. Get path and file
  cl_gui_frontend_services=>file_save_dialog(
    EXPORTING
      window_title              =  lc_title          " Window Title
      file_filter               =  cl_gui_frontend_services=>filetype_xml
    CHANGING
      filename                  =  lv_filename      " File Name to Save
      path                      =  lv_path          " Path to File
      fullpath                  =  lv_fullpath      " Path + File Name
    EXCEPTIONS
      cntl_error                = 1                " Control error
      error_no_gui              = 2                " No GUI available
      not_supported_by_gui      = 3                " GUI does not support this
      invalid_default_file_name = 4                " Invalid default file name
      OTHERS                    = 5 ).
  IF sy-subrc <> 0.
    cl_aunit_assert=>fail( msg = 'Exception has been raised.').
  ENDIF.
*******************************************************************************************
* 5. Save in TXT file
  APPEND lv_xml_cstring TO lt_xml_cstring.

  CALL METHOD cl_gui_frontend_services=>gui_download
    EXPORTING
      filename                = lv_fullpath
      codepage                = '4110'
    CHANGING
      data_tab                = lt_xml_cstring
    EXCEPTIONS
      file_write_error        = 1                    " Cannot write to file
      no_batch                = 2                    " Cannot execute front-end function in background
      gui_refuse_filetransfer = 3                    " Incorrect Front End
      invalid_type            = 4                    " Invalid value for parameter FILETYPE
      no_authority            = 5                    " No Download Authorization
      unknown_error           = 6                    " Unknown error
      header_not_allowed      = 7                    " Invalid header
      separator_not_allowed   = 8                    " Invalid separator
      filesize_not_allowed    = 9                    " Invalid file size
      header_too_long         = 10                   " Header information currently restricted to 1023 bytes
      dp_error_create         = 11                   " Cannot create DataProvider
      dp_error_send           = 12                   " Error Sending Data with DataProvider
      dp_error_write          = 13                   " Error Writing Data with DataProvider
      unknown_dp_error        = 14                   " Error when calling data provider
      access_denied           = 15                   " Access to file denied.
      dp_out_of_memory        = 16                   " Not enough memory in data provider
      disk_full               = 17                   " Storage medium is full.
      dp_timeout              = 18                   " Data provider timeout
      file_not_found          = 19                   " Could not find file
      dataprovider_exception  = 20                   " General Exception Error in DataProvider
      control_flush_error     = 21                   " Error in Control Framework
      not_supported_by_gui    = 22                   " GUI does not support this
      error_no_gui            = 23                   " GUI not available
      OTHERS                  = 24.
  IF sy-subrc <> 0.
    cl_aunit_assert=>fail( msg = 'Exception has been raised.').
  ENDIF.

  WRITE: 'XML saved successfuly to file: ' , lv_filename.
