*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section
INTERFACE lif_pers_number_retrieval_dao.

  METHODS retrieve_pers_number
  IMPORTING user TYPE sy-uname RETURNING VALUE(pers_number) TYPE String.

ENDINTERFACE.

INTERFACE lif_transport_manager_dao.
  TYPES: tt_e071k TYPE STANDARD TABLE OF e071k WITH DEFAULT KEY,
         tt_ko200 TYPE STANDARD TABLE OF ko200 WITH DEFAULT KEY.

  METHODS transport CHANGING ko200 TYPE tt_ko200
                             e071k TYPE tt_e071k.
ENDINTERFACE.


CLASS lcl_pers_num_dao_impl DEFINITION.
  PUBLIC SECTION.
    INTERFACES: lif_pers_number_retrieval_dao.

ENDCLASS.

CLASS lcl_pers_num_test_dao_impl DEFINITION.

  PUBLIC SECTION.
    INTERFACES: lif_pers_number_retrieval_dao.

    DATA: pers_number_to_return TYPE string.

ENDCLASS.

CLASS lcl_trans_mgr_dao_impl DEFINITION.
  PUBLIC SECTION.
    INTERFACES: lif_transport_manager_dao.
ENDCLASS.

CLASS lcl_trans_mgr_test_dao_impl DEFINITION.
  PUBLIC SECTION.

    INTERFACES: lif_transport_manager_dao.

    DATA: e071k TYPE lif_transport_manager_dao=>tt_e071k,
          ko200 TYPE lif_transport_manager_dao=>tt_ko200.

ENDCLASS.
