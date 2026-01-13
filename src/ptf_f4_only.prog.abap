*&---------------------------------------------------------------------*
*& Include          PTF_F4_ONLY
*&---------------------------------------------------------------------*
  DATA lt_vrm_values TYPE vrm_values.
  DATA ls_vrm_values LIKE LINE OF lt_vrm_values.

  CLEAR ls_vrm_values.
  ls_vrm_values-key = 'DMR'.
  ls_vrm_values-text = 'Debit Memo Request'.
  APPEND
    ls_vrm_values
  TO
    lt_vrm_values.

  ls_vrm_values-key = 'Invoice'.
  ls_vrm_values-text = 'Billing Document Invoice'.
  APPEND
    ls_vrm_values
  TO
    lt_vrm_values.

    CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = 'p_bo'
        values = lt_vrm_values.

       CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = 'p_bo1'
        values = lt_vrm_values.

       CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = 'p_bo2'
        values = lt_vrm_values.

       CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = 'p_bo3'
        values = lt_vrm_values.

       CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = 'p_bo4'
        values = lt_vrm_values.

       CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = 'p_bo5'
        values = lt_vrm_values.

       CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = 'p_bo6'
        values = lt_vrm_values.

       CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = 'p_bo7'
        values = lt_vrm_values.

       CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = 'p_bo8'
        values = lt_vrm_values.

       CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = 'p_bo9'
        values = lt_vrm_values.


       clear ls_vrm_values.
       clear lt_vrm_values.


       ls_vrm_values-key = 'Create'.
       ls_vrm_values-text = 'Creates a document '.
        APPEND
    ls_vrm_values
  TO
    lt_vrm_values.

  ls_vrm_values-key = 'Change'.
  ls_vrm_values-text = 'Change a document'.
  APPEND
    ls_vrm_values
  TO
    lt_vrm_values.


CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = 'p_act'
        values = lt_vrm_values.


       CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = 'p_act1'
        values = lt_vrm_values.

       CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = 'p_act2'
        values = lt_vrm_values.

       CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = 'p_act3'
        values = lt_vrm_values.

       CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = 'p_act4'
        values = lt_vrm_values.

       CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = 'p_act5'
        values = lt_vrm_values.

       CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = 'p_act6'
        values = lt_vrm_values.

       CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = 'p_act7'
        values = lt_vrm_values.

       CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = 'p_act8'
        values = lt_vrm_values.

       CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = 'p_act9'
        values = lt_vrm_values.
