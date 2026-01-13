CLASS cx_apoc_ptf_exception DEFINITION
  PUBLIC
  INHERITING FROM cx_apoc_static_root
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS:
      constructor
        IMPORTING
          !textid            LIKE if_t100_message=>t100key OPTIONAL
          !previous          LIKE previous OPTIONAL
          !previous_severity TYPE symsgty OPTIONAL
          !msgid             TYPE symsgid DEFAULT sy-msgid
          !msgno             TYPE symsgno DEFAULT sy-msgno
          !msgty             TYPE symsgty DEFAULT sy-msgty
          !msgv1             TYPE symsgv DEFAULT sy-msgv1
          !msgv2             TYPE symsgv DEFAULT sy-msgv2
          !msgv3             TYPE symsgv DEFAULT sy-msgv3
          !msgv4             TYPE symsgv DEFAULT sy-msgv4
            PREFERRED PARAMETER previous.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS CX_APOC_PTF_EXCEPTION IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous          = previous
        previous_severity = previous_severity
        msgid             = msgid
        msgno             = msgno
        msgty             = msgty
        msgv1             = msgv1
        msgv2             = msgv2
        msgv3             = msgv3
        msgv4             = msgv4.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
