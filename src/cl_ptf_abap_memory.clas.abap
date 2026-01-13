CLASS cl_ptf_abap_memory DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS get_run_head
      IMPORTING
        !iv_run_uuid     TYPE sysuuid_c26
      RETURNING
        VALUE(rs_result) TYPE cl_ptf_util=>ty_run_head .
    METHODS update_run_head
      IMPORTING
        VALUE(is_run_head) TYPE cl_ptf_util=>ty_run_head .
    METHODS insert_run_head
      IMPORTING
        VALUE(is_run_head) TYPE cl_ptf_util=>ty_run_head .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS cl_ptf_abap_memory IMPLEMENTATION.


  METHOD get_run_head.

    DATA lt_run_head TYPE cl_ptf_util=>ty_gt_run_head.

    CLEAR rs_result.

    IMPORT t_run_head = lt_run_head FROM MEMORY ID 'PTF_RUNS'.
    ASSERT sy-subrc IS INITIAL.

    READ TABLE lt_run_head WITH TABLE KEY run_uuid = iv_run_uuid INTO rs_result.
    ASSERT sy-subrc IS INITIAL.

  ENDMETHOD.


  METHOD insert_run_head.

    DATA lt_run_head TYPE cl_ptf_util=>ty_gt_run_head.

    IMPORT t_run_head = lt_run_head FROM MEMORY ID 'PTF_RUNS'.

    READ TABLE lt_run_head WITH TABLE KEY run_uuid = is_run_head-run_uuid TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.

      INSERT is_run_head INTO TABLE lt_run_head.

      EXPORT t_run_head = lt_run_head TO MEMORY ID 'PTF_RUNS'.

    ENDIF.

  ENDMETHOD.


  METHOD update_run_head.

    DATA lt_run_head TYPE cl_ptf_util=>ty_gt_run_head.  "has UNIQUE KEY run_uuid

    IMPORT t_run_head = lt_run_head FROM MEMORY ID 'PTF_RUNS'.
    ASSERT sy-subrc IS INITIAL.

    READ TABLE lt_run_head WITH TABLE KEY run_uuid = is_run_head-run_uuid TRANSPORTING NO FIELDS.
    ASSERT sy-subrc IS INITIAL.

    MODIFY TABLE lt_run_head FROM is_run_head.

    EXPORT t_run_head = lt_run_head TO MEMORY ID 'PTF_RUNS'.

  ENDMETHOD.
ENDCLASS.
