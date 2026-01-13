class CL_PTF_ALV_GRID_STEP definition
  public
  inheriting from CL_GUI_ALV_GRID
  final
  create public .

public section.

  methods SET_SELECTED_CELLS_FOR
    importing
      !IO_ERROR type ref to CL_PTF_STATIC_SYNTAX_ERROR .
protected section.
private section.
ENDCLASS.



CLASS CL_PTF_ALV_GRID_STEP IMPLEMENTATION.


  METHOD set_selected_cells_for.

    "does nothing if there is no record returned or if one of the coordinates in the FIRST record is initial.

    DATA(ls_cell) = io_error->get_alv_cell( ).
    CHECK ls_cell IS NOT INITIAL.
    CHECK ls_cell[ 1 ]-col_id IS NOT INITIAL AND ls_cell[ 1 ]-row_id IS NOT INITIAL.
    me->set_selected_cells( ls_cell ).

  ENDMETHOD.
ENDCLASS.
