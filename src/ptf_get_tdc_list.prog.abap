*&---------------------------------------------------------------------*
*& Report PTF_GET_TDC_LIST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ptf_get_tdc_list.

DATA lt_all TYPE SORTED TABLE OF sobj_name"char 40, used in TADIR     "etobj_name "char 30
      WITH UNIQUE DEFAULT KEY.
DATA count__only_in_scripts TYPE i.

WRITE: 'Client:', sy-sysid, sy-mandt, /.
SELECT DISTINCT ptf_tdc FROM ptfboa INTO TABLE @DATA(tdcs_from_boactions) WHERE ptf_tdc <> @space .
WRITE: / 'TDCs from BO Action metadata:', sy-dbcnt.
SELECT DISTINCT test_data_container FROM ptf_varcon INTO TABLE @DATA(tdcs_from_scripts) WHERE test_data_container  <> @space.
WRITE: / 'TDCs from scripts           :', sy-dbcnt.

WRITE: /, / 'TDCs only found in scripts:'.

lt_all = tdcs_from_boactions.
LOOP AT tdcs_from_scripts INTO DATA(ls_tdc).
  INSERT CONV #( ls_tdc-test_data_container ) INTO TABLE lt_all.

  IF sy-subrc IS INITIAL.
    "TDC not already listed
    WRITE: / ls_tdc-test_data_container.
    ADD 1 TO count__only_in_scripts.
  ENDIF.
ENDLOOP.
WRITE: / ' TDCs only from scripts:', count__only_in_scripts.

WRITE: /, / 'Unique TDCs overall (', lines( lt_all ), '):'.

LOOP AT lt_all INTO ls_tdc.
  WRITE: / ls_tdc.
ENDLOOP.

ULINE.
WRITE: /, / 'Packages (of all listed TDCs):'.

SELECT DISTINCT devclass FROM tadir FOR ALL ENTRIES IN @lt_all
  WHERE PGMID = 'R3TR' AND object = 'ECTD' AND obj_name = @lt_all-table_line
  INTO TABLE @DATA(all_packages) .

SORT all_packages by devclass.
LOOP AT all_packages INTO DATA(lv_package).
  WRITE: / lv_package.
ENDLOOP.
