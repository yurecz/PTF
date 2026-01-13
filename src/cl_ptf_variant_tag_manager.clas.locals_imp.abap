*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


CLASS lcl_pers_num_dao_impl IMPLEMENTATION.

  METHOD lif_pers_number_retrieval_dao~retrieve_pers_number.
    DATA: account_number TYPE usr02-accnt.

    CALL FUNCTION 'SUSR_RFC_USER_INTERFACE'
      EXPORTING
        user    = user
      IMPORTING
        account = account_number.

    pers_number = |{ account_number }|.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_pers_num_test_dao_impl IMPLEMENTATION.

  METHOD lif_pers_number_retrieval_dao~retrieve_pers_number.

    IF pers_number_to_return IS NOT INITIAL.

      pers_number = pers_number_to_return.

    ELSE.

      pers_number = user.

    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_trans_mgr_dao_impl IMPLEMENTATION.

  METHOD lif_transport_manager_dao~transport.

    DATA: trkorr TYPE e070-trkorr.

    CALL FUNCTION 'TR_OBJECTS_CHECK'
      TABLES
        wt_ko200                = ko200
      EXCEPTIONS
        cancel_edit_other_error = 1
        show_only_other_error   = 2
        OTHERS                  = 3.

    IF sy-subrc EQ 0.
      CALL FUNCTION 'TR_OBJECTS_INSERT'
        EXPORTING
          wi_order                = trkorr
        IMPORTING
          we_order                = trkorr
        TABLES
          wt_ko200                = ko200
          wt_e071k                = e071k
        EXCEPTIONS
          cancel_edit_other_error = 1
          show_only_other_error   = 2
          OTHERS                  = 3.

    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_trans_mgr_test_dao_impl IMPLEMENTATION.

  METHOD lif_transport_manager_dao~transport.

    me->e071k = e071k.
    me->ko200 = ko200.

  ENDMETHOD.

ENDCLASS.
