class CL_PTF_CLIENT definition
  public
  create public .

public section.

  methods AM_I_IN_MAIN_HOMEDEVCLIENT
    returning
      value(RV_RESULT) type ABAP_BOOL .
  methods AM_I_IN_HOMEDEVCLIENT
    returning
      value(RV_RESULT) type ABAP_BOOL .
  methods DOES_SYSTEM_BLOCK_MODIFICATION
    importing
      !IV_VARNAME type PTF_VARNAME
    returning
      value(RV_RESULT_MSGNO) type SYST_MSGNO .
  methods IS_VARIANT_FROM_THIS_SYSTEM
    importing
      !IV_VARNAME type PTF_VARNAME
    returning
      value(RV_RESULT) type ABAP_BOOL .
  methods IS_BLOCKLISTED_AGAINST_Z_TDC
    returning
      value(RV_RESULT) type ABAP_BOOL .
  methods CONSTRUCTOR
    importing
      !IV_SYSID type SYST_SYSID optional
      !IV_CLIENT type SYST_MANDT optional .
  methods IS_ALLOWLISTED_AS_HOMEDEV
    returning
      value(RV_RESULT) type ABAP_BOOL .
  methods IS_BLOCKLISTED_AGAINST_TR
    returning
      value(RV_RESULT) type ABAP_BOOL .
  methods HAS_USER_TADM_ROLE
    returning
      value(RV_RESULT) type ABAP_BOOL .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mv_sysid TYPE syst_sysid .
    DATA mv_client TYPE syst_mandt .
ENDCLASS.



CLASS CL_PTF_CLIENT IMPLEMENTATION.


  METHOD am_i_in_homedevclient.


    " Workaround: Allow maintenance also in in EMO-042 (but without transports).  Same in C50-100(only if user has Admin-Auth).
    IF me->is_allowlisted_as_homedev( ).
      rv_result = abap_true.
      RETURN.
    ENDIF.
*   "end workaround


    " Check whether the current client allows development for at least one of the relevant HOME components

    DATA: strategy    TYPE cswcdetc,
          lt_compvers TYPE TABLE OF gswcgrp.

    CONSTANTS: legacy  TYPE cswcdetc VALUE space,
               addon   TYPE cswcdetc VALUE 'A',
*               trans   TYPE cswcdetc VALUE 'T',
*               client  TYPE cswcdetc VALUE 'C',
*               system  TYPE cswcdetc VALUE 'S',
*               nocheck TYPE cswcdetc VALUE 'N',
               complex TYPE cswcdetc VALUE 'K'.

    CLEAR rv_result.

    SELECT SINGLE cswcdet FROM cswcdet INTO strategy.  "empty table is also interpreted as 'legacy'

    CASE strategy.
      WHEN legacy.
        SELECT * FROM gswcgrp INTO TABLE lt_compvers
          WHERE
          ( cdlvunit = 'SCORE_HOME'
            OR cdlvunit = 'S4CORE_HOME'   "OP maintenance systems
            OR cdlvunit = 'IS_HOME'     ) "for system EMO (OP Inf)  et al.
          AND  tclient = mv_client.
*      WHEN addon.
*        SELECT * FROM gswcgrp INTO TABLE lt_compvers
*          WHERE
*          ( cdlvunit = 'SCORE_HOME'
*            OR cdlvunit = 'S4CORE_HOME'   "OP maintenance systems
*            OR cdlvunit = 'IS_HOME'       "for system EMO (OP Inf)  et al.
*            OR cdlvunit = 'S4HCM_HOME'  ) "for system EHP
*          AND aofattrib = 'S4HCM_HOME'
*          AND  tclient = mv_client.
      WHEN complex.
        SELECT * FROM gswcgrpc INTO CORRESPONDING FIELDS OF TABLE lt_compvers
          WHERE
          ( cdlvunit = 'SCORE_HOME'
            OR cdlvunit = 'S4CORE_HOME'   "OP maintenance systems
            OR cdlvunit = 'IS_HOME'     ) "for EMO (OP Inf)  et al.
          AND  tclient = mv_client.
      WHEN OTHERS.
        "this is not expected
        RETURN.
    ENDCASE.

    IF lt_compvers IS NOT INITIAL.
      rv_result = abap_true.
    ENDIF.




  ENDMETHOD.


  method AM_I_IN_MAIN_HOMEDEVCLIENT.

    CLEAR rv_result.

    IF mv_sysid EQ 'ERX' AND mv_client EQ '815'.
      rv_result = abap_true.
    ENDIF.

  endmethod.


  METHOD constructor.

    IF iv_sysid IS NOT INITIAL.
      mv_sysid  = iv_sysid.
    ELSE.
      mv_sysid  = sy-sysid.
    ENDIF.

    IF iv_client IS NOT INITIAL.
      mv_client = iv_client.
    ELSE.
      mv_client = sy-mandt.
    ENDIF.

  ENDMETHOD.


  METHOD does_system_block_modification.

    "Rules to block modification in certain cases
    "returns a msgno if modification of the script shall be blocked
    "special cases:
    "returns initial value if variant does not exist on DB                      TODO: raise exception CX_PTF_variant_not_found, or dump.  more important dept is: we read far too often src_system from DB
    "returns initial value if src_system on DB is initial (actually guessing)

    CLEAR rv_result_msgno.

    SELECT SINGLE src_system FROM ptf_varid INTO @DATA(lv_src_system) WHERE varname = @iv_varname.
    CHECK sy-subrc IS INITIAL AND lv_src_system IS NOT INITIAL.

    IF mv_sysid EQ 'ER6' AND lv_src_system NE 'ER6'.
      rv_result_msgno = '063'.
    ELSEIF
       mv_sysid EQ 'ER9' AND lv_src_system EQ 'ER1'.   "OR
       "mv_sysid EQ 'ER1' AND lv_src_system EQ 'ER9'.
      rv_result_msgno = '062'.
    ENDIF.

  ENDMETHOD.


  METHOD has_user_tadm_role.

    CLEAR rv_result.

    CALL FUNCTION 'TR_AUTHORITY_CHECK_ADMIN'
      EXPORTING
        iv_user          = sy-uname
        iv_adminfunction = 'TADM' "Special transport functions in TMS
      EXCEPTIONS
        e_no_authority   = 1
        e_invalid_user   = 2
        OTHERS           = 3.
    CASE sy-subrc.
      WHEN 1.
*        WRITE: / 'No authority'.
        RETURN.
      WHEN 2.
*        WRITE: / 'Invalid user'.
        RETURN.
      WHEN 3.
*        WRITE: / 'Error checking authorization'.
        RETURN.
    ENDCASE.

    rv_result = abap_true.

  ENDMETHOD.


  METHOD is_allowlisted_as_homedev.

    CLEAR rv_result.

    IF mv_sysid EQ 'EMO' AND mv_client EQ '042'.
      rv_result = abap_true.
    ENDIF.

    IF mv_sysid EQ 'C50' AND mv_client EQ '100' AND has_user_tadm_role( ).
      rv_result = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD is_blocklisted_against_tr.

    CLEAR rv_result.

    IF mv_sysid EQ 'EMO' AND mv_client EQ '042'.
      rv_result = abap_true.
    ENDIF.

    IF mv_sysid EQ 'C50' AND mv_client EQ '100' AND has_user_tadm_role( ).
      rv_result = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD is_blocklisted_against_z_tdc.

    CLEAR rv_result.

    IF mv_sysid EQ 'ER9' AND mv_client EQ '503'
      OR
       mv_sysid EQ 'ER9' AND mv_client EQ '504'
      OR
       mv_sysid EQ 'ER1' AND mv_client EQ '013'
      OR
       mv_sysid EQ 'ER1' AND mv_client EQ '715'
      .

      rv_result = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD is_variant_from_this_system.

    "returns true if 'PTF_VARID-src_system on DB' eq 'current system ID'
    "
    "PTF_VARID-MODIF_SYSTEM is not considered
    "
    "special cases:
    "false if variant does not exist on DB                         "toDO: replace with exception CX_PTF_variant_not_found
    "true if src_system on DB is initial

    CLEAR: rv_result.", ev_src_system.

    SELECT SINGLE src_system FROM ptf_varid INTO @DATA(lv_src_system) WHERE varname = @iv_varname.
    IF sy-subrc IS INITIAL.
      IF lv_src_system EQ mv_sysid
       OR  lv_src_system IS INITIAL "we do not know the src_system for scripts created before introduction of field src_system. assume that it is the original system, do not block anything
       OR  ( mv_sysid EQ 'ER1' AND lv_src_system EQ 'ER9' )
       OR  ( mv_sysid EQ 'ERX' AND lv_src_system EQ 'ER9' ).
        rv_result = abap_true.
      ENDIF.
    ENDIF.

*    ev_src_system = lv_src_system.

  ENDMETHOD.
ENDCLASS.
