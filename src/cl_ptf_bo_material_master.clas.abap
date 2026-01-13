CLASS cl_ptf_bo_material_master DEFINITION
  PUBLIC
  INHERITING FROM cl_ptf_bo
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: create REDEFINITION,
      change REDEFINITION,
      delete REDEFINITION,
      check REDEFINITION,
      execute_action REDEFINITION,
      execute_check REDEFINITION,
      check_existence REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_material_w_batch,
             !name     TYPE matbf,
             stocktype TYPE nsdm_lbbsa,
             plant     TYPE werks_d,
             sloc      TYPE lgort_d,
             batch     TYPE nsdm_charg,
           END OF ty_material_w_batch.
    TYPES: BEGIN OF ty_batch_order,
             quantity TYPE nsdm_stock_qty,
             batch    TYPE nsdm_charg,
           END OF ty_batch_order.
    TYPES: tt_batch_order TYPE TABLE OF ty_batch_order.

    CONSTANTS: BEGIN OF c_material_w_batch,
                 !name     TYPE matbf VALUE 'TG21',
                 stocktype TYPE nsdm_lbbsa VALUE '01',
                 plant     TYPE werks_d VALUE '1010',
                 sloc      TYPE lgort_d VALUE '101A',
                 batch1    TYPE nsdm_charg VALUE 'RED',
                 batch2    TYPE nsdm_charg VALUE 'GREEN',
                 batch3    TYPE nsdm_charg VALUE 'BLUE',
               END OF c_material_w_batch.

    CONSTANTS c_create_goods_move_in_batches TYPE string VALUE 'CREATE_GOODS_MOVEMENT_IN_BATCHES'.
    METHODS get_date_in_booking_period
      IMPORTING
        !iv_plant                     TYPE werks_d
        !iv_offset                    TYPE i OPTIONAL
      RETURNING
        VALUE(rv_booking_period_date) TYPE dats.
    METHODS create_goods_movement_batches.
    METHODS get_stock_info_batch
      IMPORTING
        !is_material TYPE ty_material_w_batch
      EXPORTING
        !ev_quantity TYPE nsdm_stock_qty
        !et_quantity TYPE tt_batch_order.
ENDCLASS.



CLASS CL_PTF_BO_MATERIAL_MASTER IMPLEMENTATION.


  METHOD change.

  ENDMETHOD.


  METHOD check.

  ENDMETHOD.


  METHOD check_existence.

  ENDMETHOD.


  METHOD create.

  ENDMETHOD.


  METHOD create_goods_movement_batches.
    DATA:
      lt_returnmessage    TYPE STANDARD TABLE OF bapi_matreturn2,
      lt_item             TYPE STANDARD TABLE OF bapi2017_gm_item_create,
      lt_item_remove      TYPE STANDARD TABLE OF bapi2017_gm_item_create,
      ev_mblnr            TYPE mblnr,
      ev_gjahr            TYPE gjahr,
      ls_material         TYPE ty_material_w_batch,
      lt_batch_quantities TYPE tt_batch_order,
      lt_tmp_quantities   TYPE tt_batch_order.

    CLEAR: ev_mblnr, ev_gjahr.

*   Get stock information
    ls_material-name        = c_material_w_batch-name.
    ls_material-plant       = c_material_w_batch-plant.
    ls_material-sloc        = c_material_w_batch-sloc.
    ls_material-stocktype   = c_material_w_batch-stocktype.
    ls_material-batch       = c_material_w_batch-batch1.

    get_stock_info_batch(
      EXPORTING
        is_material = ls_material
      IMPORTING
        et_quantity = lt_tmp_quantities
    ).
    APPEND LINES OF lt_tmp_quantities TO lt_batch_quantities.
    ls_material-batch       = c_material_w_batch-batch2.
    get_stock_info_batch(
      EXPORTING
        is_material = ls_material
      IMPORTING
        et_quantity = lt_tmp_quantities
    ).
    APPEND LINES OF lt_tmp_quantities TO lt_batch_quantities.
    ls_material-batch       = c_material_w_batch-batch3.
    get_stock_info_batch(
       EXPORTING
         is_material = ls_material
       IMPORTING
         et_quantity = lt_tmp_quantities
     ).
    APPEND LINES OF lt_tmp_quantities TO lt_batch_quantities.
    SORT lt_batch_quantities.

    READ TABLE lt_batch_quantities WITH KEY batch = 'RED' INTO DATA(lv_res) BINARY SEARCH.
    IF sy-subrc EQ 0.
        IF lv_res-quantity < 5.
            Data(lv_tmp_quantity) = 5 - lv_res-quantity.
            INSERT VALUE #(
              line_id       = sy-tabix
              move_type     = '501'
              plant         = c_material_w_batch-plant
              material_long = c_material_w_batch-name
              stge_loc      = c_material_w_batch-sloc
              entry_qnt     = lv_tmp_quantity
              entry_uom     = 'PC'
              batch         = c_material_w_batch-batch1
            ) INTO TABLE lt_item.
        elseif lv_res-quantity > 5.
            CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
              EXPORTING
                goodsmvt_header  = VALUE bapi2017_gm_head_01( pstng_date = get_date_in_booking_period( '0001' ) )
                goodsmvt_code    = VALUE bapi2017_gm_code( gm_code = '05' )
              IMPORTING
                materialdocument = ev_mblnr
                matdocumentyear  = ev_gjahr
              TABLES
                goodsmvt_item    = lt_item
                return           = lt_returnmessage.
       ENDIF.
    ENDIF.

    READ TABLE lt_batch_quantities WITH KEY batch = 'GREEN' INTO lv_res BINARY SEARCH.
    IF sy-subrc EQ 0.
        IF lv_res-quantity < 4.
            lv_tmp_quantity = 4 - lv_res-quantity.
            INSERT VALUE #(
              line_id       = sy-tabix
              move_type     = '501'
              plant         = c_material_w_batch-plant
              material_long = c_material_w_batch-name
              stge_loc      = c_material_w_batch-sloc
              entry_qnt     = lv_tmp_quantity
              entry_uom     = 'PC'
              batch         = c_material_w_batch-batch2
            ) INTO TABLE lt_item.
        elseif lv_res-quantity > 4.
            "TODO
        ENDIF.
    ENDIF.

    READ TABLE lt_batch_quantities WITH KEY batch = 'BLUE' INTO lv_res BINARY SEARCH.
    IF sy-subrc EQ 0.
        IF lv_res-quantity < 3.
            lv_tmp_quantity = 3 - lv_res-quantity.
            INSERT VALUE #(
              line_id       = sy-tabix
              move_type     = '501'
              plant         = c_material_w_batch-plant
              material_long = c_material_w_batch-name
              stge_loc      = c_material_w_batch-sloc
              entry_qnt     = lv_tmp_quantity
              entry_uom     = 'PC'
              batch         = c_material_w_batch-batch3
            ) INTO TABLE lt_item.
        elseif lv_res-quantity > 3.
            "TODO
        ENDIF.
    ENDIF.

    "TODO

    CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
      EXPORTING
        goodsmvt_header  = VALUE bapi2017_gm_head_01( pstng_date = get_date_in_booking_period( '0001' ) )
        goodsmvt_code    = VALUE bapi2017_gm_code( gm_code = '05' )
      IMPORTING
        materialdocument = ev_mblnr
        matdocumentyear  = ev_gjahr
      TABLES
        goodsmvt_item    = lt_item
        return           = lt_returnmessage.

    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
  ENDMETHOD.


  METHOD delete.

  ENDMETHOD.


  METHOD execute_action.
    DATA(lv_step_data) = me->mo_run_environment->get_step_data( iv_step_number =  iv_step_number ).

    CASE lv_step_data-action.
      WHEN c_create_goods_move_in_batches.

      WHEN OTHERS.
        me->mo_run_environment->append_log( iv_log_statement =  |Could not find method { lv_step_data-action } for the BO { lv_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.
    ENDCASE.
  ENDMETHOD.


  METHOD execute_check.

  ENDMETHOD.


  METHOD get_date_in_booking_period.
    DATA: ls_marv              TYPE marv,
          lv_last_day_of_month TYPE dats.

    CALL FUNCTION 'MARV_READ'
      EXPORTING
        marv_werks = iv_plant
      IMPORTING
        wmarv      = ls_marv
      EXCEPTIONS
        OTHERS     = 3.
    IF sy-subrc <> 0.
      " check sy-msgid and sy-msgno for more details
      ASSERT 1 = 2.
    ENDIF.

    DATA lv_day(2) TYPE c.

    lv_day = CONV i( sy-datum+6(2) ).
    IF iv_offset IS NOT INITIAL.
*    IF iv_offset IS NOT SUPPLIED.
      IF lv_day + iv_offset > 28.
        lv_day = iv_offset.
      ELSE.
        lv_day = lv_day + iv_offset.
      ENDIF.
    ENDIF.
    IF lv_day < 10.
      lv_day = '0' && lv_day.
    ENDIF.
    rv_booking_period_date = ls_marv-lfgja && ls_marv-lfmon && lv_day.
    IF ls_marv-lfmon > 12.
      cl_abap_unit_assert=>fail( msg = `Plant: ` && iv_plant && ` configured with non-monthly periods!` ).
    ENDIF.

    "Potentially rv_booking_period_date could be something like 20170631...
    lv_last_day_of_month = ls_marv-lfgja && ls_marv-lfmon && '01'.
    CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
      EXPORTING
        day_in            = lv_last_day_of_month
      IMPORTING
        last_day_of_month = lv_last_day_of_month.

    IF lv_last_day_of_month < rv_booking_period_date.
      rv_booking_period_date = lv_last_day_of_month.
    ENDIF.

  ENDMETHOD.


  METHOD get_stock_info_batch.
    CLEAR et_quantity.
    IF is_material-batch IS INITIAL.
      SELECT FROM
        i_materialstock_2
      FIELDS
        SUM( i_materialstock_2~matlwrhsstkqtyinmatlbaseunit ),
        i_materialstock_2~batch
      WHERE
        i_materialstock_2~material = @is_material-name
        AND
        i_materialstock_2~inventorystocktype = @is_material-stocktype
        AND
        i_materialstock_2~plant = @is_material-plant
        AND
        i_materialstock_2~storagelocation = @is_material-sloc
        AND
        i_materialstock_2~batch IS NOT INITIAL
      GROUP BY
        i_materialstock_2~batch
      INTO TABLE @et_quantity.
    ELSEIF is_material-batch IS NOT INITIAL.
      SELECT FROM
        i_materialstock_2
      FIELDS
        SUM( i_materialstock_2~matlwrhsstkqtyinmatlbaseunit ),
        i_materialstock_2~batch
      WHERE
        i_materialstock_2~material = @is_material-name
        AND
        i_materialstock_2~inventorystocktype = @is_material-stocktype
        AND
        i_materialstock_2~plant = @is_material-plant
        AND
        i_materialstock_2~storagelocation = @is_material-sloc
        AND
        i_materialstock_2~batch = @is_material-batch
      GROUP BY
        i_materialstock_2~batch
      INTO TABLE @et_quantity.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
