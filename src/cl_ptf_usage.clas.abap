CLASS cl_ptf_usage DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: ptf_selections TYPE TABLE OF ptf_selection WITH DEFAULT KEY.
    CLASS-METHODS get_usage_of_bo
      IMPORTING bo            TYPE string
      RETURNING VALUE(usages) TYPE ptf_selections.
    CLASS-METHODS get_usage_of_bo_action
      IMPORTING bo            TYPE string
                action        TYPE string
      RETURNING VALUE(usages) TYPE ptf_selections.
    CLASS-METHODS get_usage_of_variant
      IMPORTING bo            TYPE string
                action        TYPE string
                variant       TYPE string
      RETURNING VALUE(usages) TYPE ptf_selections.
    CLASS-METHODS get_usage_of_tdc
      IMPORTING bo            TYPE string
                action        TYPE string
                tdc           TYPE string
      RETURNING VALUE(usages) TYPE ptf_selections.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS CL_PTF_USAGE IMPLEMENTATION.


  METHOD get_usage_of_bo.

    DATA: variants      TYPE TABLE OF ptf_varcon,
          varname       TYPE string,
          ptf_selection TYPE ptf_selection.

    IF bo IS INITIAL.
      RETURN.
    ENDIF.

    SELECT DISTINCT varname FROM ptf_varcon INTO CORRESPONDING FIELDS OF TABLE @variants WHERE bus_obj = @bo ORDER BY varname.
    LOOP AT variants ASSIGNING FIELD-SYMBOL(<variant>).
      SELECT SINGLE * FROM ptf_varid WHERE varname = @<variant>-varname INTO @DATA(varid).
      SELECT SINGLE * FROM ptf_varid_t WHERE varname = @<variant>-varname AND langu = 'E' INTO @DATA(var_description).
      ptf_selection-varname = <variant>-varname.
      ptf_selection-erdat = varid-erdat.
      ptf_selection-ernam = varid-ernam.
      ptf_selection-user_specific = varid-user_specific.
      ptf_selection-scope_item    = varid-scope_item.
      ptf_selection-vardescr = var_description-vtext.
      APPEND ptf_selection TO usages.
      CLEAR ptf_selection.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_usage_of_bo_action.

    DATA: variants      TYPE TABLE OF ptf_varcon,
          ptf_selection TYPE ptf_selection.

    IF bo IS INITIAL OR action IS INITIAL.
      RETURN.
    ENDIF.

    SELECT DISTINCT varname FROM ptf_varcon INTO CORRESPONDING FIELDS OF TABLE @variants WHERE bus_obj = @bo AND action = @action ORDER BY varname.
    LOOP AT variants ASSIGNING FIELD-SYMBOL(<variant>).
      SELECT SINGLE * FROM ptf_varid WHERE varname = @<variant>-varname INTO @DATA(varid).
      SELECT SINGLE * FROM ptf_varid_t WHERE varname = @<variant>-varname AND langu = 'E' INTO @DATA(var_description).
      ptf_selection-varname = <variant>-varname.
      ptf_selection-erdat = varid-erdat.
      ptf_selection-ernam = varid-ernam.
      ptf_selection-user_specific = varid-user_specific.
      ptf_selection-scope_item    = varid-scope_item.
      ptf_selection-vardescr = var_description-vtext.
      APPEND ptf_selection TO usages.
      CLEAR ptf_selection.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_usage_of_tdc.

    DATA: variants      TYPE TABLE OF ptf_varcon,
          ptf_selection TYPE ptf_selection.

    IF bo IS INITIAL OR action IS INITIAL OR tdc IS INITIAL.
      RETURN.
    ENDIF.

    SELECT DISTINCT varname FROM ptf_varcon INTO CORRESPONDING FIELDS OF TABLE @variants WHERE bus_obj = @bo AND action = @action AND test_data_container = @tdc ORDER BY varname.
    LOOP AT variants ASSIGNING FIELD-SYMBOL(<variant>).
      SELECT SINGLE * FROM ptf_varid WHERE varname = @<variant>-varname INTO @DATA(varid).
      SELECT SINGLE * FROM ptf_varid_t WHERE varname = @<variant>-varname AND langu = 'E' INTO @DATA(var_description).
      ptf_selection-varname = <variant>-varname.
      ptf_selection-erdat = varid-erdat.
      ptf_selection-ernam = varid-ernam.
      ptf_selection-user_specific = varid-user_specific.
      ptf_selection-scope_item    = varid-scope_item.
      ptf_selection-vardescr = var_description-vtext.
      APPEND ptf_selection TO usages.
      CLEAR ptf_selection.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_usage_of_variant.

    DATA: variants      TYPE TABLE OF ptf_varcon,
          ptf_selection TYPE ptf_selection.

    IF bo IS INITIAL OR action IS INITIAL OR variant IS INITIAL.
      RETURN.
    ENDIF.

    SELECT DISTINCT varname FROM ptf_varcon INTO CORRESPONDING FIELDS OF TABLE @variants WHERE bus_obj = @bo AND action = @action AND variant = @variant ORDER BY varname.
    LOOP AT variants ASSIGNING FIELD-SYMBOL(<variant>).
      SELECT SINGLE * FROM ptf_varid WHERE varname = @<variant>-varname INTO @DATA(varid).
      SELECT SINGLE * FROM ptf_varid_t WHERE varname = @<variant>-varname AND langu = 'E' INTO @DATA(var_description).
      ptf_selection-varname = <variant>-varname.
      ptf_selection-erdat = varid-erdat.
      ptf_selection-ernam = varid-ernam.
      ptf_selection-user_specific = varid-user_specific.
      ptf_selection-scope_item    = varid-scope_item.
      ptf_selection-vardescr = var_description-vtext.
      APPEND ptf_selection TO usages.
      CLEAR ptf_selection.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
