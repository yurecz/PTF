*&---------------------------------------------------------------------*
*& Include          INPUT_SCREEN
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Include          APOC_RENDER_INIT_SCREEN
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK om_block WITH FRAME TITLE TEXT-003.
  PARAMETERS: p_apptyp TYPE apoc_appl_object_type LOWER CASE,
              p_appid  TYPE apoc_appl_object_id LOWER CASE,
              p_serv   TYPE string,
              p_lang   TYPE spras                 DEFAULT 'E',
              p_sendc  TYPE land1                 DEFAULT 'US'.
*              p_locc   TYPE string                ,"DEFAULT 'US',
*              p_wmtext TYPE string                ,"DEFAULT 'PTF is the best!',
*              p_recid  TYPE string                ,"DEFAULT 'BP ID',
*              p_rrole  TYPE string                ,"DEFAULT 'RE',
*              p_pfdr   TYPE string                ,"DEFAULT 'Dummy',
*              p_outpt  TYPE string                ,"DEFAULT 'BILLING_DOCUMENT',
*              p_itemid TYPE string                ."DEFAULT '000000'.
SELECTION-SCREEN END OF BLOCK om_block.

" 15 Key/Value pairs for the FDP
SELECTION-SCREEN BEGIN OF BLOCK fdp_block WITH FRAME TITLE TEXT-004.
  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: p_fdp11  TYPE /iwbep/med_external_name LOWER CASE.
    PARAMETERS: p_fdp12  TYPE char80 LOWER CASE.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: p_fdp21  TYPE /iwbep/med_external_name LOWER CASE.
    PARAMETERS: p_fdp22  TYPE char80 LOWER CASE.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: p_fdp31  TYPE /iwbep/med_external_name LOWER CASE.
    PARAMETERS: p_fdp32  TYPE char80 LOWER CASE.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: p_fdp41  TYPE /iwbep/med_external_name LOWER CASE.
    PARAMETERS: p_fdp42  TYPE char80 LOWER CASE.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: p_fdp51  TYPE /iwbep/med_external_name LOWER CASE.
    PARAMETERS: p_fdp52  TYPE char80 LOWER CASE.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: p_fdp61  TYPE /iwbep/med_external_name LOWER CASE.
    PARAMETERS: p_fdp62  TYPE char80 LOWER CASE.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: p_fdp71  TYPE /iwbep/med_external_name LOWER CASE.
    PARAMETERS: p_fdp72  TYPE char80 LOWER CASE.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: p_fdp81  TYPE /iwbep/med_external_name LOWER CASE.
    PARAMETERS: p_fdp82  TYPE char80 LOWER CASE.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: p_fdp91  TYPE /iwbep/med_external_name LOWER CASE.
    PARAMETERS: p_fdp92  TYPE char80 LOWER CASE.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: p_fdp101  TYPE /iwbep/med_external_name LOWER CASE.
    PARAMETERS: p_fdp102  TYPE char80 LOWER CASE.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: p_fdp111  TYPE /iwbep/med_external_name LOWER CASE.
    PARAMETERS: p_fdp112  TYPE char80 LOWER CASE.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: p_fdp121  TYPE /iwbep/med_external_name LOWER CASE.
    PARAMETERS: p_fdp122  TYPE char80 LOWER CASE.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: p_fdp131  TYPE /iwbep/med_external_name LOWER CASE.
    PARAMETERS: p_fdp132  TYPE char80 LOWER CASE.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: p_fdp141  TYPE /iwbep/med_external_name LOWER CASE.
    PARAMETERS: p_fdp142  TYPE char80 LOWER CASE.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: p_fdp151  TYPE /iwbep/med_external_name LOWER CASE.
    PARAMETERS: p_fdp152  TYPE char80 LOWER CASE.
  SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK fdp_block.
