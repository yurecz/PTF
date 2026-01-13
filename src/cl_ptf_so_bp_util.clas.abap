class CL_PTF_SO_BP_UTIL definition
  public
  final
  create public .

public section.

**************FPLA

  types:
    BEGIN OF TY_GS_MOCK_FPLA,
         dbtable   TYPE tabname16,
         mock_mode TYPE ptf_mock_mode,
         content   TYPE STANDARD TABLE OF FPLA WITH DEFAULT KEY,
        END OF TY_GS_MOCK_FPLA .
  types:
    TY_GT_MOCK_FPLA TYPE STANDARD TABLE OF TY_GS_MOCK_FPLA WITH DEFAULT KEY .

************************FPLT
  types:
    BEGIN OF TY_GS_MOCK_FPLT,
         dbtable   TYPE tabname16,
         mock_mode TYPE ptf_mock_mode,
         content   TYPE STANDARD TABLE OF FPLT WITH DEFAULT KEY,
        END OF TY_GS_MOCK_FPLT.
  types:
    TY_GT_MOCK_FPLT TYPE STANDARD TABLE OF TY_GS_MOCK_FPLT WITH DEFAULT KEY .

*********************************TFPLA
  types:
    BEGIN OF TY_GS_MOCK_TFPLA_TD,
         dbtable   TYPE tabname16,
         mock_mode TYPE ptf_mock_mode,
         content   TYPE STANDARD TABLE OF TFPLA WITH DEFAULT KEY,
        END OF TY_GS_MOCK_TFPLA_TD .
  types:
    TY_GT_MOCK_TFPLA_TD TYPE STANDARD TABLE OF TY_GS_MOCK_TFPLA_TD WITH DEFAULT KEY .

***********************************TFPLT
  types:
    BEGIN OF TY_GS_MOCK_TFPLT_TD,
         dbtable   TYPE tabname16,
         mock_mode TYPE ptf_mock_mode,
         content   TYPE STANDARD TABLE OF TFPLT WITH DEFAULT KEY,
        END OF TY_GS_MOCK_TFPLT_TD .
  types:
    TY_GT_MOCK_TFPLT_TD TYPE STANDARD TABLE OF TY_GS_MOCK_TFPLT_TD WITH DEFAULT KEY .


***TVAK MOCK
  types:
    BEGIN OF TY_GS_MOCK_TVAK_TD,
         dbtable   TYPE tabname16,
         mock_mode TYPE ptf_mock_mode,
         content   TYPE STANDARD TABLE OF TVAK WITH DEFAULT KEY,
        END OF TY_GS_MOCK_TVAK_TD .
  types:
    TY_GT_MOCK_TVAK_TD TYPE STANDARD TABLE OF TY_GS_MOCK_TVAK_TD WITH DEFAULT KEY .
protected section.
private section.
ENDCLASS.



CLASS CL_PTF_SO_BP_UTIL IMPLEMENTATION.
ENDCLASS.
