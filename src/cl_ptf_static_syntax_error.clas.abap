class CL_PTF_STATIC_SYNTAX_ERROR definition
  public
  final
  create public .

public section.

  methods GET_TEXT
    returning
      value(RESULT) type STRING .
  methods RAISE_MESSAGE
    importing
      !DISPLAY_TYPE type MSGTY .
  methods CONSTRUCTOR
    importing
      !MSGNO type SYMSGNO
      !MSGTY type SYMSGTY optional
      !MSGV1 type SYMSGV optional
      !MSGV2 type SYMSGV optional
      !MSGV3 type SYMSGV optional
      !MSGV4 type SYMSGV optional
      !ROW_INDEX type INT4 optional
      !COLUMN_NAME type LVC_FNAME optional .
  methods GET_ALV_CELL
    returning
      value(RT_CELL) type LVC_T_CELL .
  PROTECTED SECTION.
private section.

*  data MSGID type SYMSGID .
  data MSGNO type SYMSGNO .
  data MSGTY type SYMSGTY .
  data MSGV1 type SYMSGV .
  data MSGV2 type SYMSGV .
  data MSGV3 type SYMSGV .
  data MSGV4 type SYMSGV .
  data MV_COLUMN_NAME type LVC_FNAME .
  data MV_ROW_INDEX type INT4 .
ENDCLASS.



CLASS CL_PTF_STATIC_SYNTAX_ERROR IMPLEMENTATION.


  METHOD constructor.

    ASSERT msgno IS NOT INITIAL.

    me->msgno = msgno.
    IF msgty IS INITIAL.
      me->msgty	= 'S'.
    ELSE.
      me->msgty	= msgty.
    ENDIF.
    me->msgv1	= condense( msgv1 ).
    me->msgv2	= condense( msgv2 ).
    me->msgv3	= condense( msgv3 ).
    me->msgv4	= condense( msgv4 ).
    me->mv_row_index   = row_index.
    me->mv_column_name = column_name.

  ENDMETHOD.


  METHOD get_alv_cell.

    APPEND VALUE #( col_id = mv_column_name row_id = mv_row_index ) TO rt_cell.

  ENDMETHOD.


  METHOD get_text.

    MESSAGE ID 'PTF'
    TYPE msgty
    NUMBER msgno
    WITH msgv1 msgv2 msgv3 msgv4

    INTO result.

  ENDMETHOD.


  METHOD raise_message.

    MESSAGE ID 'PTF'
    TYPE msgty
    NUMBER msgno
    WITH msgv1 msgv2 msgv3 msgv4
    DISPLAY LIKE display_type.

  ENDMETHOD.
ENDCLASS.
