CLASS cl_ptf_session_configer DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  FOR TESTING .

  PUBLIC SECTION.

    CLASS-METHODS make_configurations
      IMPORTING
        !run_environment     TYPE REF TO cl_ptf_run
        !current_step_number TYPE i
        !config              TYPE string
        !parameters          TYPE string OPTIONAL .
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS: c_downpayment_c1 TYPE String VALUE 'dpy_c1',
               c_downpayment_c2 TYPE String VALUE 'dpy_c2'.

    TYPES: BEGIN OF ty_bsid_bsad_mocking,
             ref_step TYPE i,
           END OF ty_bsid_bsad_mocking.

    CLASS-METHODS bsid_bsad_mocking_c1
      IMPORTING parameters      TYPE String
                run_environment TYPE REF TO cl_ptf_run.

    CLASS-METHODS bsid_bsad_mocking_c2
      IMPORTING parameters      TYPE String
                run_environment TYPE REF TO cl_ptf_run.
ENDCLASS.



CLASS CL_PTF_SESSION_CONFIGER IMPLEMENTATION.


  METHOD bsid_bsad_mocking_c1.
    DATA: bsid                     TYPE bsid,
          bsid_entries             TYPE STANDARD TABLE OF bsid WITH DEFAULT KEY,
          bsad                     TYPE bsad,
          bsad_entries             TYPE STANDARD TABLE OF bsad WITH DEFAULT KEY,
          bsid_bsad_mocking_params TYPE cl_ptf_session_configer=>ty_bsid_bsad_mocking.


    /ui2/cl_json=>deserialize(
      EXPORTING
        json             =    parameters
      CHANGING
        data             =     bsid_bsad_mocking_params
    ).



    DATA(doc_ids) = run_environment->get_step_data( iv_step_number = bsid_bsad_mocking_params-ref_step )-document_id.

    LOOP AT doc_ids ASSIGNING FIELD-SYMBOL(<doc_id>).

      SELECT SINGLE * FROM vbak WHERE vbeln = @<doc_id>-vbeln INTO @DATA(vbak).
      SELECT SINGLE vbeln FROM vbrp WHERE vgbel = @<doc_id>-vbeln INTO @DATA(ref_bd).
      SELECT SINGLE *  FROM vbrk WHERE vbeln = @ref_bd INTO @DATA(vbrk).

      SELECT * FROM bsid WHERE vbel2 = @<doc_id>-vbeln INTO TABLE @DATA(buffered_bsid).
      SELECT * FROM bsad WHERE vbel2 = @<doc_id>-vbeln INTO TABLE @DATA(buffered_bsad).

      "Rücknahme von FIN Anzahlungen (Ohne Storno)

      SELECT posnr FROM vbap WHERE vbeln = @<doc_id>-vbeln INTO TABLE @DATA(positions).

      LOOP AT positions ASSIGNING FIELD-SYMBOL(<position>).
        bsid = VALUE #(
        mandt = sy-mandt
        bukrs = vbrk-bukrs
        kunnr = vbrk-kunrg
        umsks = 'A'
        umskz = 'F'
        augdt = sy-datum
        augbl = ''
        zuonr = vbrk-vbeln
        gjahr = vbrk-gjahr
        belnr = vbrk-belnr
        "buzei = '001'
        budat = sy-datum
        waers = vbrk-waerk
        xblnr = vbrk-vbeln
        zumsk = 'A'
        shkzg = 'S'
        dmbtr = vbrk-netwr + vbrk-mwsbk
        wrbtr = vbrk-netwr + vbrk-mwsbk
        mwsts = vbrk-mwsbk
        wmwst = vbrk-mwsbk
        rebzg = ''
        xanet = ''
        vbel2 = vbak-vbeln
        posn2 = <position>
        bschl = '09'
       ).
        APPEND bsid TO bsid_entries.

        bsid = VALUE #(
          mandt = sy-mandt
          bukrs = vbrk-bukrs
          kunnr = vbrk-kunrg
          umsks = 'A'
          umskz = 'A'
          augdt = sy-datum
          augbl = ''
          zuonr = vbrk-vbeln
          gjahr = vbrk-gjahr
          belnr = '1400000001'
          "buzei = '001'
          budat = sy-datum
          waers = vbrk-waerk
          xblnr = ''
          zumsk = ''
          shkzg = 'H'
          dmbtr = vbrk-netwr + vbrk-mwsbk
          wrbtr = vbrk-netwr + vbrk-mwsbk
          mwsts = vbrk-mwsbk
          wmwst = vbrk-mwsbk
          rebzg = ''
          xanet = ''
          vbel2 = vbak-vbeln
          posn2 = <position>
          bschl = '19'
        ).
        APPEND bsid TO bsid_entries.

      ENDLOOP.

    ENDLOOP.

    DATA(environment) = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'BSID' ) ( 'BSAD' ) ) ).

    environment->insert_test_data(
      EXPORTING
        i_data             =   bsid_entries
    ).

    environment->insert_test_data(
    EXPORTING
      i_data             =   bsad_entries
    ).

    SELECT * FROM bsad WHERE vbel2 = @<doc_id>-vbeln INTO TABLE @DATA(bsad_entries_act).
    SELECT * FROM bsid WHERE vbel2 = @<doc_id>-vbeln INTO TABLE @DATA(bsid_entries_act).

  ENDMETHOD.


  METHOD bsid_bsad_mocking_c2.
    "Rücknahme und Storno von Merkposten und FIN Anzahlungen
    "(SD Merkposten nur über Storno FAZ !

    DATA: bsid                     TYPE bsid,
          bsid_entries             TYPE STANDARD TABLE OF bsid WITH DEFAULT KEY,
          bsad                     TYPE bsad,
          bsad_entries             TYPE STANDARD TABLE OF bsad WITH DEFAULT KEY,
          bsid_bsad_mocking_params TYPE cl_ptf_session_configer=>ty_bsid_bsad_mocking.


    /ui2/cl_json=>deserialize(
      EXPORTING
        json             =    parameters
      CHANGING
        data             =     bsid_bsad_mocking_params
    ).



    DATA(doc_ids) = run_environment->get_step_data( iv_step_number = bsid_bsad_mocking_params-ref_step )-document_id.

    LOOP AT doc_ids ASSIGNING FIELD-SYMBOL(<doc_id>).

      SELECT SINGLE * FROM vbak WHERE vbeln = @<doc_id>-vbeln INTO @DATA(vbak).
      SELECT SINGLE vbeln FROM vbrp WHERE vgbel = @<doc_id>-vbeln INTO @DATA(ref_bd).
      SELECT SINGLE *  FROM vbrk WHERE vbeln = @ref_bd INTO @DATA(vbrk).

      SELECT * FROM bsid WHERE vbel2 = @<doc_id>-vbeln INTO TABLE @DATA(buffered_bsid).
      SELECT * FROM bsad WHERE vbel2 = @<doc_id>-vbeln INTO TABLE @DATA(buffered_bsad).

      "Rücknahme & Storno von FIN Anzahlungen

      SELECT posnr FROM vbap WHERE vbeln = @<doc_id>-vbeln INTO TABLE @DATA(positions).

      LOOP AT positions ASSIGNING FIELD-SYMBOL(<position>).
        bsid = VALUE #(
        mandt = sy-mandt
        bukrs = vbrk-bukrs
        kunnr = vbrk-kunrg
        umsks = 'A'
        umskz = 'F'
        augdt = sy-datum
        augbl = ''
        zuonr = vbrk-vbeln
        gjahr = vbrk-gjahr
        belnr = vbrk-belnr
        "buzei = '001'
        budat = sy-datum
        waers = vbrk-waerk
        xblnr = vbrk-vbeln
        zumsk = 'A'
        shkzg = 'S'
        dmbtr = vbrk-netwr + vbrk-mwsbk
        wrbtr = vbrk-netwr + vbrk-mwsbk
        mwsts = vbrk-mwsbk
        wmwst = vbrk-mwsbk
        rebzg = ''
        xanet = ''
        vbel2 = vbak-vbeln
        posn2 = <position>
        bschl = '09'
       ).
        APPEND bsid TO bsid_entries.

        bsad = VALUE #(
          blart = 'DA'
          mandt = sy-mandt
          bukrs = vbrk-bukrs
          kunnr = vbrk-kunrg
          umsks = 'A'
          umskz = 'A'
          augdt = sy-datum
          augbl = '1600000001'
          zuonr = vbrk-vbeln
          gjahr = vbrk-gjahr
          belnr = '1400000001'
          "buzei = '001'
          budat = sy-datum
          waers = vbrk-waerk
          xblnr = vbrk-vbeln
          zumsk = ''
          shkzg = 'H'
          dmbtr = vbrk-netwr + vbrk-mwsbk
          wrbtr = vbrk-netwr + vbrk-mwsbk
          mwsts = vbrk-mwsbk
          wmwst = vbrk-mwsbk
          rebzg = ''
          xanet = ''
          vbel2 = vbak-vbeln
          posn2 = <position>
          bschl = '19'
        ).
        APPEND bsad TO bsad_entries.

        bsad = VALUE #(
          blart = 'DZ'
          mandt = sy-mandt
          bukrs = vbrk-bukrs
          kunnr = vbrk-kunrg
          umsks = 'A'
          umskz = 'A'
          augdt = sy-datum
          augbl = '1600000002'
          zuonr = vbrk-vbeln
          gjahr = vbrk-gjahr
          belnr = '1600000002'
          "buzei = '001'
          budat = sy-datum
          waers = vbrk-waerk
          xblnr = vbrk-vbeln
          zumsk = ''
          shkzg = 'H'
          dmbtr = vbrk-netwr + vbrk-mwsbk
          wrbtr = vbrk-netwr + vbrk-mwsbk
          mwsts = vbrk-mwsbk
          wmwst = vbrk-mwsbk
          rebzg = ''
          xanet = ''
          vbel2 = vbak-vbeln
          posn2 = <position>
          bschl = '09'
        ).
        APPEND bsad TO bsad_entries.

      ENDLOOP.

    ENDLOOP.

    DATA(environment) = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'BSID' ) ( 'BSAD' ) ) ).

    environment->insert_test_data(
      EXPORTING
        i_data             =   bsid_entries
    ).

    environment->insert_test_data(
    EXPORTING
      i_data             =   bsad_entries
    ).

    SELECT * FROM bsad WHERE vbel2 = @<doc_id>-vbeln INTO TABLE @DATA(bsad_entries_act).
    SELECT * FROM bsid WHERE vbel2 = @<doc_id>-vbeln INTO TABLE @DATA(bsid_entries_act).

  ENDMETHOD.


  METHOD make_configurations.
    DATA: continue TYPE abap_bool.

    run_environment->append_log( iv_log_statement = |This class is deprecated.| ).
    run_environment->append_log( iv_log_statement = |Only use it when you know what you are doing.| ).

    "It's not needed to check weather mocking is enabled as I need to create an mock environment anyway

    CASE config.
      WHEN c_downpayment_c1.
        cl_ptf_session_configer=>bsid_bsad_mocking_c1(
          EXPORTING
            parameters      = parameters
            run_environment = run_environment
        ).
      WHEN c_downpayment_c2.
        cl_ptf_session_configer=>bsid_bsad_mocking_c2(
          EXPORTING
            parameters      = parameters
            run_environment = run_environment
        ).
      WHEN OTHERS.
        run_environment->append_log( iv_log_statement = |Unknown config { config }.| ).
        RETURN.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
