*&---------------------------------------------------------------------*
*& Report PTF_CHECK_AU_AUTH
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ptf_check_au_auth MESSAGE-ID sabp_unit.

WRITE: 'Client:', sy-sysid, sy-mandt, /.

" testing allowed at all ?
IF ( NOT cl_aunit_permission_control=>is_test_enabled_client( ) ).
  MESSAGE e200.
ENDIF.

*   "stop those that are not allowed to debug
*  if ( not cl_Aunit_Permission_Control=>permitted_2_Exec_Tests( ) ).
*    message 'Insufficient Authorization' type 'E' ##no_Text.
*  endif.

" risk level allowed ? PTF AU classes have risk level Dangerous
DATA(currentmax_risk_level) = cl_aunit_permission_control=>get_max_risk_level( ).

IF currentmax_risk_level EQ if_aunit_attribute_enums=>c_risk_level-critical OR currentmax_risk_level EQ if_aunit_attribute_enums=>c_risk_level-dangerous.
  "ok

ELSE.
  MESSAGE e199.
ENDIF.
