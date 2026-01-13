*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: V_PTF_TAG_MAP...................................*
TABLES: V_PTF_TAG_MAP, *V_PTF_TAG_MAP. "view work areas
CONTROLS: TCTRL_V_PTF_TAG_MAP
TYPE TABLEVIEW USING SCREEN '0200'.
DATA: BEGIN OF STATUS_V_PTF_TAG_MAP. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_V_PTF_TAG_MAP.
* Table for entries selected to show on screen
DATA: BEGIN OF V_PTF_TAG_MAP_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE V_PTF_TAG_MAP.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF V_PTF_TAG_MAP_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF V_PTF_TAG_MAP_TOTAL OCCURS 0010.
INCLUDE STRUCTURE V_PTF_TAG_MAP.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF V_PTF_TAG_MAP_TOTAL.

*...processing: V_PTF_VAR_TAG...................................*
TABLES: V_PTF_VAR_TAG, *V_PTF_VAR_TAG. "view work areas
CONTROLS: TCTRL_V_PTF_VAR_TAG
TYPE TABLEVIEW USING SCREEN '0100'.
DATA: BEGIN OF STATUS_V_PTF_VAR_TAG. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_V_PTF_VAR_TAG.
* Table for entries selected to show on screen
DATA: BEGIN OF V_PTF_VAR_TAG_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE V_PTF_VAR_TAG.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF V_PTF_VAR_TAG_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF V_PTF_VAR_TAG_TOTAL OCCURS 0010.
INCLUDE STRUCTURE V_PTF_VAR_TAG.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF V_PTF_VAR_TAG_TOTAL.

*.........table declarations:.................................*
TABLES: PTF_VARID                      .
TABLES: PTF_VAR_TAG                    .
TABLES: PTF_VAR_TAGT                   .
TABLES: PTF_VAR_TAG_MAP                .
