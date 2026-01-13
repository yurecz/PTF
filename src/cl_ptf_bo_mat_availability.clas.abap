CLASS cl_ptf_bo_mat_availability DEFINITION
  PUBLIC
  INHERITING FROM cl_ptf_bo
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS change
        REDEFINITION .
    METHODS check
        REDEFINITION .
    METHODS create
        REDEFINITION .
    METHODS delete
        REDEFINITION .
    METHODS execute_action
        REDEFINITION .
    METHODS execute_check
        REDEFINITION .
    METHODS check_existence
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS: c_unrestricted_stock_type TYPE nsdm_lbbsa VALUE '01',


              c_ensure_availability TYPE String VALUE 'ENSURE_AVAILABILITY'.

    METHODS: ensure_availability
      IMPORTING
        step_data           TYPE cl_ptf_util=>gt_ptf_step
        step_number         TYPE i
      EXPORTING
        ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        ev_execution_status TYPE abap_bool
        ev_check_status     TYPE abap_bool .

ENDCLASS.



CLASS CL_PTF_BO_MAT_AVAILABILITY IMPLEMENTATION.


  METHOD change.
  ENDMETHOD.


  METHOD check.
  ENDMETHOD.


  METHOD check_existence.
  ENDMETHOD.


  METHOD create.
  ENDMETHOD.


  METHOD delete.
  ENDMETHOD.


  METHOD ensure_availability.

    DATA: sales_orders     TYPE STANDARD TABLE OF vbeln WITH DEFAULT KEY,
          sales_order      TYPE vbeln,

          materials_to_add TYPE STANDARD TABLE OF bapi2017_gm_item_create,
          messages         TYPE STANDARD TABLE OF bapi_matreturn2,
          goodsmvt_headret TYPE  bapi2017_gm_head_ret,
          materialdocument TYPE  bapi2017_gm_head_ret-mat_doc,
          matdocumentyear  TYPE  bapi2017_gm_head_ret-doc_year,

          ranged_batches   TYPE RANGE OF charg_d.

    "Sales Order as Reference is required

    LOOP AT step_data-reference_step ASSIGNING FIELD-SYMBOL(<ref_step>).
      DATA(ref_docs) = me->mo_run_environment->get_keys_of_touch_doc_of_step( iv_step_number = <ref_step> ).
      APPEND LINES OF ref_docs TO sales_orders.
    ENDLOOP.

    IF sales_orders IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |No reference given.| ).
      RETURN.
    ENDIF.

    ev_execution_status = abap_true.

    LOOP AT sales_orders INTO sales_order.

      SELECT matnr, kwmeng, vrkme, werks FROM vbap WHERE vbeln = @sales_order INTO TABLE @DATA(order_items).

      IF order_items IS INITIAL.
        me->mo_run_environment->append_log( iv_log_statement = |Order { sales_order } not found.| ).
        me->mo_run_environment->append_log( iv_log_statement = |Method restricted to sales order reference.| ).
        EXIT.
      ENDIF.

      LOOP AT order_items ASSIGNING FIELD-SYMBOL(<order_item>).

        "get any storage location
        SELECT SINGLE lgort FROM t001l WHERE werks = @<order_item>-werks INTO @DATA(storage_location).

        IF storage_location IS  INITIAL.
          me->mo_run_environment->append_log( iv_log_statement = |Plant { <order_item>-werks } has no storage location assigned| ).
          EXIT.
        ENDIF.


        SELECT SINGLE xchpf FROM mara
          WHERE matnr = @<order_item>-matnr INTO @DATA(is_batch).

        IF is_batch EQ abap_false.

          SELECT SUM( i_materialstock_2~matlwrhsstkqtyinmatlbaseunit )
             FROM
            i_materialstock_2
          WHERE
            i_materialstock_2~material = @<order_item>-matnr
            AND
            i_materialstock_2~inventorystocktype = @c_unrestricted_stock_type
            AND
            i_materialstock_2~plant = @<order_item>-werks
            AND
            i_materialstock_2~storagelocation = @storage_location
          INTO @DATA(actual_quantity).

          "Substract non delivered materials see https://support.wdf.sap.corp/sap/support/message/2080226180

          SELECT SUM( lfimg ) FROM lips
            WHERE wbsta NE 'C'
            AND werks = @<order_item>-werks
            AND lgort = @storage_location
            AND matnr = @<order_item>-matnr
            INTO @DATA(non_delivered_quantities).

          actual_quantity = actual_quantity - non_delivered_quantities.

          IF actual_quantity < <order_item>-kwmeng.

            "Not enough material available
            CLEAR materials_to_add.
            CLEAR goodsmvt_headret.
            CLEAR matdocumentyear.
            CLEAR materialdocument.

            me->mo_run_environment->append_log( iv_log_statement = |Try to create goods issue for { <order_item>-matnr } in plant { <order_item>-werks }| ).

            INSERT VALUE #(
              line_id       = 0
              move_type     = '501'
              plant         = <order_item>-werks
              material_long = <order_item>-matnr
              stge_loc      = storage_location
              entry_qnt     = <order_item>-kwmeng
              entry_uom     = <order_item>-vrkme
              ) INTO TABLE materials_to_add.

            CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
              EXPORTING
                goodsmvt_header  = VALUE bapi2017_gm_head_01( pstng_date = sy-datum )
                goodsmvt_code    = VALUE bapi2017_gm_code( gm_code = '05' )
              IMPORTING
                goodsmvt_headret = goodsmvt_headret
                matdocumentyear  = matdocumentyear
                materialdocument = materialdocument
              TABLES
                goodsmvt_item    = materials_to_add
                return           = messages.

            COMMIT WORK AND WAIT.

            LOOP AT messages ASSIGNING FIELD-SYMBOL(<message>).
              IF <message>-type = 'E'.
                ev_execution_status = abap_false.
              ENDIF.
              me->mo_run_environment->append_log_structure( is_log = <message> ).
            ENDLOOP.

            IF materialdocument IS NOT INITIAL.
              me->mo_run_environment->append_log( iv_log_statement = |Created material document { materialdocument }| ).
            ENDIF.

          ENDIF.

        ELSE.
          "Batch item

          SELECT DISTINCT charg FROM mchb
            WHERE matnr = @<order_item>-matnr
            AND werks = @<order_item>-werks
            AND lgort = @storage_location
            INTO TABLE @DATA(batches).

          LOOP AT batches ASSIGNING FIELD-SYMBOL(<batch>).
            APPEND VALUE #( sign   = 'I' option = 'EQ' low = <batch> high = ''  ) TO ranged_batches.
          ENDLOOP.

          SELECT SUM( i_materialstock_2~matlwrhsstkqtyinmatlbaseunit )
          FROM
            i_materialstock_2
          WHERE
            i_materialstock_2~material = @<order_item>-matnr
            AND
            i_materialstock_2~inventorystocktype = @c_unrestricted_stock_type
            AND
            i_materialstock_2~plant = @<order_item>-werks
            AND
            i_materialstock_2~storagelocation = @storage_location
            AND
            i_materialstock_2~batch IN @ranged_batches
          INTO @actual_quantity.

          "Substract non delivered materials see https://support.wdf.sap.corp/sap/support/message/2080226180

          SELECT SUM( lfimg ) FROM lips
            WHERE wbsta NE 'C'
            AND werks = @<order_item>-werks
            AND lgort = @storage_location
            AND matnr = @<order_item>-matnr
            INTO @non_delivered_quantities.

          actual_quantity = actual_quantity - non_delivered_quantities.

          IF actual_quantity < <order_item>-kwmeng.

            "Not enough material available
            CLEAR materials_to_add.
            CLEAR goodsmvt_headret.
            CLEAR matdocumentyear.
            CLEAR materialdocument.

            me->mo_run_environment->append_log( iv_log_statement = |Try to create goods issue for { <order_item>-matnr } in plant { <order_item>-werks }| ).

            INSERT VALUE #(
              line_id       = 0
              move_type     = '501'
              plant         = <order_item>-werks
              material_long = <order_item>-matnr
              stge_loc      = storage_location
              entry_qnt     = <order_item>-kwmeng
              entry_uom     = <order_item>-vrkme
              ) INTO TABLE materials_to_add.

            CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
              EXPORTING
                goodsmvt_header  = VALUE bapi2017_gm_head_01( pstng_date = sy-datum )
                goodsmvt_code    = VALUE bapi2017_gm_code( gm_code = '05' )
              IMPORTING
                goodsmvt_headret = goodsmvt_headret
                matdocumentyear  = matdocumentyear
                materialdocument = materialdocument
              TABLES
                goodsmvt_item    = materials_to_add
                return           = messages.

            COMMIT WORK AND WAIT.

            LOOP AT messages ASSIGNING <message>.
              IF <message>-type = 'E'.
                ev_execution_status = abap_false.
              ENDIF.
              me->mo_run_environment->append_log_structure( is_log = <message> ).
            ENDLOOP.

            IF materialdocument IS NOT INITIAL.
              me->mo_run_environment->append_log( iv_log_statement = |Created material document { materialdocument }| ).
            ENDIF.

          ENDIF.

        ENDIF.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


  METHOD execute_action.

     DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).

    CASE ls_step_data-action.

      WHEN c_ensure_availability.
        me->ensure_availability(
          EXPORTING
            step_data        = ls_step_data
            step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status
        ).

      WHEN OTHERS.
        me->mo_run_environment->append_log( iv_log_statement =  |Could not find method { ls_step_data-action } for the BO { ls_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.

    ENDCASE.

  ENDMETHOD.


  METHOD execute_check.
  ENDMETHOD.
ENDCLASS.
