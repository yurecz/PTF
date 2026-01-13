class CX_PTF_VARDATASET definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

public section.

  interfaces IF_T100_MESSAGE .
  interfaces IF_T100_DYN_MSG .

  constants:
    begin of NOT_FOUND,
      msgid type symsgid value 'PTF',
      msgno type symsgno value '091',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of NOT_FOUND .
  constants:
    begin of SAVE_ERROR,
      msgid type symsgid value 'PTF',
      msgno type symsgno value '092',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of SAVE_ERROR .
  constants:
    begin of INITIAL_VARNAME,
      msgid type symsgid value 'PTF',
      msgno type symsgno value '093',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of INITIAL_VARNAME .
  constants:
    begin of DELETE_ERROR,
      msgid type symsgid value 'PTF',
      msgno type symsgno value '094',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of DELETE_ERROR .
  constants:
    begin of INITIAL_DATASET_ID,
      msgid type symsgid value 'PTF',
      msgno type symsgno value '095',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of INITIAL_DATASET_ID .
  constants:
    begin of INITIAL_VARIABLE_NAME,
      msgid type symsgid value 'PTF',
      msgno type symsgno value '096',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of INITIAL_VARIABLE_NAME .
  constants:
    begin of INITIAL_VARIABLE_VALUE,
      msgid type symsgid value 'PTF',
      msgno type symsgno value '097',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of INITIAL_VARIABLE_VALUE .
  constants:
    begin of INVALID_VARIABLE_NAME,
      msgid type symsgid value 'PTF',
      msgno type symsgno value '098',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of INVALID_VARIABLE_NAME .
  constants:
    begin of INCONSISTENT_VARNAME,
      msgid type symsgid value 'PTF',
      msgno type symsgno value '099',
      attr1 type scx_attrname value '',
      attr2 type scx_attrname value '',
      attr3 type scx_attrname value '',
      attr4 type scx_attrname value '',
    end of INCONSISTENT_VARNAME .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional .
protected section.
private section.
ENDCLASS.



CLASS CX_PTF_VARDATASET IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
