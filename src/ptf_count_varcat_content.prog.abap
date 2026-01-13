*&---------------------------------------------------------------------*
*& Report PTF_COUNT_VARCAT_CONTENT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ptf_count_varcat_content.

SELECT * FROM ptf_varcat INTO TABLE @DATA(lt_varcat) ORDER BY varname.  "#EC CI_NOWHERE.
WRITE: / 'Records in PTF_VARCAT:', lines( lt_varcat ).

SELECT DISTINCT varname FROM ptf_varcat INTO TABLE @DATA(lt_varname_unique) ORDER BY varname. "#EC CI_NOWHERE.
WRITE: / 'Unique VARNAMEs:', lines( lt_varname_unique ).
