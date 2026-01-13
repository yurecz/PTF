*&---------------------------------------------------------------------*
*& Report PTF_CHECK_IF_SWC_DEV_CLIENT
*&---------------------------------------------------------------------*
*& accesses similar to FM TRINT_SEL_GSWCGRP
*&---------------------------------------------------------------------*
REPORT ptf_check_if_swc_dev_client.

DATA: strategy          TYPE cswcdetc,
      badi              TYPE REF TO if_ex_cts_request_check,
      attributes        TYPE trattributes,
      addon             TYPE e070a,
      compvers_planned  TYPE TABLE OF gswcgrp,
      compvers_fr_cmplx TYPE TABLE OF gswcgrp,
      compversions      TYPE TABLE OF gswcgrp,
      ompversions2      TYPE TABLE OF gswcgrp.

CONSTANTS: legacy  TYPE cswcdetc VALUE space,
*           addon   TYPE cswcdetc VALUE 'A',
           trans   TYPE cswcdetc VALUE 'T',
           client  TYPE cswcdetc VALUE 'C',
           system  TYPE cswcdetc VALUE 'S',
           nocheck TYPE cswcdetc VALUE 'N',
           complex TYPE cswcdetc VALUE 'K'.

WRITE: 'Client:', sy-sysid, sy-mandt, /.
ULINE.

SELECT SINGLE cswcdet FROM cswcdet INTO strategy.

WRITE: / 'Planned Changeability Check:'.
CASE strategy.
  WHEN legacy.
    SELECT * FROM gswcgrp INTO TABLE compvers_planned
      WHERE
      ( cdlvunit = 'SCORE_HOME'
        OR cdlvunit = 'S4CORE_HOME'   "OP maintenance systems
        OR cdlvunit = 'IS_HOME'     ) "for EMO (OP Inf)  et al.
      AND  tclient = sy-mandt.
  WHEN complex.
    SELECT * FROM gswcgrpc INTO CORRESPONDING FIELDS OF TABLE compvers_planned
      WHERE
      ( cdlvunit = 'SCORE_HOME'
        OR cdlvunit = 'S4CORE_HOME'   "OP maintenance systems
        OR cdlvunit = 'IS_HOME'     ) "for EMO (OP Inf)  et al.
      AND  tclient = sy-mandt.
ENDCASE.
IF compvers_planned IS INITIAL.
  WRITE: 'Scripts NOT changeable'.
ELSE.
  WRITE: 'Scripts CHANGEABLE'.
ENDIF.

ULINE.

" determine evaluation method (CSWCDET contains up to 1 entry per client)
SELECT SINGLE cswcdet FROM cswcdet INTO strategy.
IF sy-subrc IS NOT INITIAL.
  WRITE: 'cswcDET is initial in this client => I assume this is no dev client!!'.
ENDIF.
WRITE: / 'cswcdet says determination method in this client is:'.
CASE strategy.
  WHEN legacy.
    WRITE 'Legacy'.
  WHEN complex.
    WRITE 'Complex'.
  WHEN OTHERS.
    WRITE : '!!!!!!NOT CONSIDERED YET:', strategy.
ENDCASE.






ULINE.

*    when strategy=>legacy. " legacy mode

WRITE: / 'gswcgrp  "Component --- Group" :'.
IF strategy EQ legacy.
  WRITE: / '(RELEVANT PATH)', /.
ENDIF.

SELECT * FROM gswcgrp INTO TABLE @DATA(dummy1).
IF sy-subrc IS NOT INITIAL.
  WRITE: / 'gswcgrp is EMPTY.'.
ELSE.
  WRITE: / 'Number of all records in db table:', lines( dummy1 ).

  SELECT * FROM gswcgrp INTO TABLE compversions
    WHERE "tarsystem <> space AND
    ( tarsystem = '/SCEH_S4C/' OR tarsystem = '/SHH2_GRP/'   OR tarsystem =  '/SSEH_S4C/'   OR tarsystem = '/SCEH_SE1/'  ) "is_request-tarsystem
    "or aofattrib <> space and aofattrib = addon-reference
**HOME
*SAPOCORE_H
*SAPPCORE_H
    OR "tclient <> space AND
    tclient = sy-mandt. "is_request-client. "#EC CI_NOFIELD "#EC CI_CMPLX_WHERE

  IF sy-subrc <> 0. " no rows found, now check srcsid
    SELECT * FROM gswcgrp INTO TABLE compversions WHERE gsystem = sy-sysid. "#EC CI_NOFIELD            "GSYSTEM exists only in gswcgrp
    WRITE: / '!!!!!   Found other changeable stuff, but only via SYSID.'.     "never seen anywhere
  ENDIF.

  LOOP AT compversions ASSIGNING FIELD-SYMBOL(<record>).
    WRITE: / <record>.
  ENDLOOP.

ENDIF.

IF strategy EQ legacy.
  ULINE. ULINE. ULINE.
ENDIF.




ULINE.

*    when strategy=>complex. " complex evaluation method is used

WRITE: / 'gswcgrpC  "Complex Mapping  Transport Attribute -> SWC" :'.
IF strategy EQ complex.
  WRITE: / '(RELEVANT PATH)', /.
ENDIF.

SELECT * FROM gswcgrpc INTO TABLE @DATA(dummy).
IF sy-subrc IS NOT INITIAL.
  WRITE: / 'gswcgrpC is EMPTY.'.
ELSE.
  WRITE: / 'Number of all records in db table:', lines( dummy ).
  SKIP.

  "do wildcards even occur anywhere? I have not seen any
  SELECT * FROM gswcgrpc INTO TABLE @DATA(compl_w_wildc)
    WHERE tarsystem = @space
    OR aofattrib = @space
    OR tclient = @space .
  IF sy-subrc IS INITIAL.
    WRITE: / '!gswcgrpc has WILDCARD entries!!!', /.
  ENDIF.


  " here, blank serves as wildcard!
  SELECT * FROM gswcgrpc INTO CORRESPONDING FIELDS OF TABLE compvers_fr_cmplx "compversions
    WHERE ( "tarsystem = space OR
    "                   ER9 etc                      HC5 (and OC5?)                ER1                          ER3                        /SCEH_S2*  OP maintenance systems
            tarsystem = '/SCEH_S4C/'  OR tarsystem = '/SHH2_GRP/'  OR tarsystem =  '/SSEH_S4C/'  OR tarsystem = '/SCEH_SE1/'    ) "is_request-tarsystem )
*        and ( aofattrib = space or aofattrib = addon-reference )
    "AND ( tclient = space
    OR tclient = sy-mandt ")  "is_request-client ) "#EC CI_NOFIELD "#EC CI_NOFIRST
    .

  IF compvers_fr_cmplx IS INITIAL.
    WRITE: 'Found no matches in complex table, but there are records.'.
    "just added:
    SELECT * FROM gswcgrpc INTO CORRESPONDING FIELDS OF TABLE compvers_fr_cmplx       WHERE tclient = space OR tclient = sy-mandt.
    IF sy-subrc IS INITIAL.
      WRITE: / '!!! Found other changeable stuff, but only via SY-MANDT.'.
    ENDIF.
  ELSE.
    SORT compvers_fr_cmplx BY cdlvunit crelease.

    DATA header TYPE gswcgrp.
    header = VALUE gswcgrp( aofattrib = 'AOFattrib' cdlvunit = 'CDLVUNIT' crelease = 'SAPRELEASE' tarsystem = 'TARSYSTEM' tclient = 'X'  as4user = 'X' "gsystem = 'X'
                         ).
    WRITE: / header, /.

    LOOP AT compvers_fr_cmplx ASSIGNING FIELD-SYMBOL(<recordx>).
      WRITE: / <recordx>.
    ENDLOOP.

    WRITE: /, / 'After DELETE ADJACENT DUPLICATES   COMPARING cdlvunit crelease :'.
    DATA(compvers_fr_cmplx_wo_du) = compvers_fr_cmplx.
    DELETE ADJACENT DUPLICATES FROM compvers_fr_cmplx_wo_du COMPARING cdlvunit crelease.

    IF lines( compvers_fr_cmplx_wo_du ) < lines( compvers_fr_cmplx ).
      LOOP AT compvers_fr_cmplx_wo_du ASSIGNING FIELD-SYMBOL(<recordy>).
        WRITE: / <recordy>.
      ENDLOOP.
    ELSE.
      WRITE '(UNCHANGED)'.
    ENDIF.
  ENDIF.


ENDIF.
*  endcase.





*ULINE.
*WRITE: '(For TARSYSTEMs)Allow changes to PTF scripts in SAP namespace?'.
*
*CASE strategy.
*  WHEN legacy.
*    IF compversions IS NOT INITIAL.
*      WRITE ' yes, if current client matches one of the hits'.
*    ELSE.
*      WRITE ' NO'.
*    ENDIF.
*  WHEN complex.
*    IF compvers_fr_cmplx IS NOT INITIAL.
*      WRITE ' maybe, look at the listed SW components'.
*    ELSE.
*      WRITE ' NO'.
*    ENDIF.
*  WHEN OTHERS.
*    WRITE : 'changeability not decided'.
*ENDCASE.

SKIP.
ULINE.

CASE strategy.
  WHEN legacy.
    SELECT * FROM gswcgrp INTO TABLE compversions
  WHERE tarsystem = '/SCEH_S4C/' OR tarsystem = '/SHH2_GRP/'   OR tarsystem =  '/SSEH_S4C/'   OR tarsystem = '/SCEH_SE1/'
  "or aofattrib <> space and aofattrib = addon-reference
**HOME
*SAPOCORE_H
*SAPPCORE_H
  AND  tclient = sy-mandt. "is_request-client. "#EC CI_NOFIELD "#EC CI_CMPLX_WHERE
    "IGNORING PURE SYSID!?!?
*  IF sy-subrc <> 0. " no rows found, now check srcsid
*    SELECT * FROM gswcgrp INTO TABLE compversions WHERE gsystem = sy-sysid. "#EC CI_NOFIELD
*    WRITE: / 'Found other changeable stuff, but only via SYSID.'.
*  ENDIF.
    IF sy-subrc IS INITIAL.
      WRITE: / 'TARSYSTEMbased check for legacy table would allow changeability in the current client.'.
    ELSE.
      WRITE: / 'TARSYSTEMbased check for legacy table would  NOT allow changeability in the current client.'.
    ENDIF.

  WHEN complex.
    SELECT * FROM gswcgrpc INTO CORRESPONDING FIELDS OF TABLE compvers_fr_cmplx "compversions
      WHERE ( "tarsystem = space OR
              tarsystem = '/SCEH_S4C/'  OR tarsystem = '/SHH2_GRP/'  OR tarsystem =  '/SSEH_S4C/'  OR tarsystem = '/SCEH_SE1/' )
*        and ( aofattrib = space or aofattrib = addon-reference )
      AND ( "tclient = space OR
      tclient = sy-mandt ).
    IF sy-subrc IS INITIAL.
      WRITE: / 'TARSYSTEMbased check for complex table would allow changeability in the current client.'.
    ELSE.
      WRITE: / 'TARSYSTEMbased check for complex table would  NOT  allow changeability in the current client.'.
    ENDIF.
ENDCASE.
