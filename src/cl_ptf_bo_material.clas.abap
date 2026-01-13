CLASS cl_ptf_bo_material DEFINITION
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
    TYPES:
      ty_gt_ptf_materialdescription TYPE STANDARD TABLE OF bapi_makt WITH DEFAULT KEY,
      ty_gt_ptf_unitsofmeasure      TYPE STANDARD TABLE OF bapi_marm WITH DEFAULT KEY,
      ty_gt_ptf_unitsofmeasurex     TYPE STANDARD TABLE OF bapi_marmx WITH DEFAULT KEY,
      ty_gt_ptf_internationalartnos TYPE STANDARD TABLE OF bapi_mean WITH DEFAULT KEY,
      ty_gt_ptf_materiallongtext    TYPE STANDARD TABLE OF bapi_mltx WITH DEFAULT KEY,
      ty_gt_ptf_taxclassifications  TYPE STANDARD TABLE OF bapi_mlan WITH DEFAULT KEY,
      ty_gt_ptf_returnmessages      TYPE STANDARD TABLE OF bapi_matreturn2 WITH DEFAULT KEY,
      ty_gt_ptf_prtdata             TYPE STANDARD TABLE OF bapi_mfhm WITH DEFAULT KEY,
      ty_gt_ptf_prtdatax            TYPE STANDARD TABLE OF bapi_mfhmx WITH DEFAULT KEY,
      ty_gt_ptf_extensionin         TYPE STANDARD TABLE OF bapiparex WITH DEFAULT KEY,
      ty_gt_ptf_extensioninx        TYPE STANDARD TABLE OF bapiparexx WITH DEFAULT KEY,
      ty_gt_ptf_unitsofmeasurecwm   TYPE STANDARD TABLE OF /cwm/bapi_marm WITH DEFAULT KEY,
      ty_gt_ptf_unitsofmeasurecwmx  TYPE STANDARD TABLE OF /cwm/bapi_marmx WITH DEFAULT KEY,
      ty_gt_ptf_segmrpgeneraldata   TYPE STANDARD TABLE OF bapi_sgt_mrp_gn WITH DEFAULT KEY,
      ty_gt_ptf_segmrpgeneraldatax  TYPE STANDARD TABLE OF bapi_sgt_mrp_gnx WITH DEFAULT KEY,
      ty_gt_ptf_segmrpquantitydata  TYPE STANDARD TABLE OF bapi_sgt_mrp WITH DEFAULT KEY,
      ty_gt_ptf_segmrpquantitydatax TYPE STANDARD TABLE OF bapi_sgt_mrpx WITH DEFAULT KEY,
      ty_gt_ptf_segvaluationtype    TYPE STANDARD TABLE OF bapi_sgt_madka WITH DEFAULT KEY,
      ty_gt_ptf_segvaluationtypex   TYPE STANDARD TABLE OF bapi_sgt_madkax WITH DEFAULT KEY,
      ty_gt_ptf_segsalesstatus      TYPE STANDARD TABLE OF bapi_sgt_mvke WITH DEFAULT KEY,
      ty_gt_ptf_segsalesstatusx     TYPE STANDARD TABLE OF bapi_sgt_mvkex WITH DEFAULT KEY,
      ty_gt_ptf_segweightvolume     TYPE STANDARD TABLE OF bapi_sgt_marm WITH DEFAULT KEY,
      ty_gt_ptf_segweightvolumex    TYPE STANDARD TABLE OF bapi_sgt_marmx WITH DEFAULT KEY,
      ty_gt_ptf_demand_penaltydata  TYPE STANDARD TABLE OF bapi_ppo_dmnd_penalty WITH DEFAULT KEY,
      ty_gt_ptf_demand_penaltydatax TYPE STANDARD TABLE OF bapi_ppo_dmnd_penaltyx WITH DEFAULT KEY.
    TYPES:
      " Structure for create.
      BEGIN OF ty_gs_ptf_material_cr_td,
        material_prefix      TYPE char5,
        headdata             TYPE bapimathead,
        clientdata           TYPE bapi_mara,
        clientdatax          TYPE bapi_marax,
        plantdata            TYPE bapi_marc,
        plantdatax           TYPE bapi_marcx,
        forecastparameters   TYPE bapi_mpop,
        forecastparametersx  TYPE bapi_mpopx,
        planningdata         TYPE bapi_mpgd,
        planningdatax        TYPE bapi_mpgdx,
        storagelocationdata  TYPE bapi_mard,
        storagelocationdatax TYPE bapi_mardx,
        valuationdata        TYPE bapi_mbew,
        valuationdatax       TYPE bapi_mbewx,
        warehousenumberdata  TYPE bapi_mlgn,
        warehousenumberdatax TYPE bapi_mlgnx,
        salesdata            TYPE bapi_mvke,
        salesdatax           TYPE bapi_mvkex,
        storagetypedata      TYPE bapi_mlgt,
        storagetypedatax     TYPE bapi_mlgtx,
        clientdatacwm        TYPE /cwm/bapi_mara,
        clientdatacwmx       TYPE /cwm/bapi_marax,
        valuationdatacwm     TYPE /cwm/bapi_mbew,
        valuationdatacwmx    TYPE /cwm/bapi_mbewx,
        matplstadata         TYPE bapi_matplsta,
        matplstadatax        TYPE bapi_matplstax,
        marc_aps_extdata     TYPE bapi_marc_aps_ext,
        marc_aps_extdatax    TYPE bapi_marc_aps_extx,
        materialdescription  TYPE ty_gt_ptf_materialdescription,
        unitsofmeasure       TYPE ty_gt_ptf_unitsofmeasure,
        unitsofmeasurex      TYPE ty_gt_ptf_unitsofmeasurex,
        internationalartnos  TYPE ty_gt_ptf_internationalartnos,
        materiallongtext     TYPE ty_gt_ptf_materiallongtext,
        taxclassifications   TYPE ty_gt_ptf_taxclassifications,
        prtdata              TYPE ty_gt_ptf_prtdata,
        prtdatax             TYPE ty_gt_ptf_prtdatax,
        extensionin          TYPE ty_gt_ptf_extensionin,
        extensioninx         TYPE ty_gt_ptf_extensioninx,
        unitsofmeasurecwm    TYPE ty_gt_ptf_unitsofmeasurecwm,
        unitsofmeasurecwmx   TYPE ty_gt_ptf_unitsofmeasurecwmx,
        segmrpgeneraldata    TYPE ty_gt_ptf_segmrpgeneraldata,
        segmrpgeneraldatax   TYPE ty_gt_ptf_segmrpgeneraldatax,
        segmrpquantitydata   TYPE ty_gt_ptf_segmrpquantitydata,
        segmrpquantitydatax  TYPE ty_gt_ptf_segmrpquantitydatax,
        segvaluationtype     TYPE ty_gt_ptf_segvaluationtype,
        segvaluationtypex    TYPE ty_gt_ptf_segvaluationtypex,
        segsalesstatus       TYPE ty_gt_ptf_segsalesstatus,
        segsalesstatusx      TYPE ty_gt_ptf_segsalesstatusx,
        segweightvolume      TYPE ty_gt_ptf_segweightvolume,
        segweightvolumex     TYPE ty_gt_ptf_segweightvolumex,
        demand_penaltydata   TYPE ty_gt_ptf_demand_penaltydata,
        demand_penaltydatax  TYPE ty_gt_ptf_demand_penaltydatax,
      END OF ty_gs_ptf_material_cr_td.
    TYPES:
      " Structure for create condition.
      BEGIN OF ty_gs_ptf_condition_cr_td,
        komg      TYPE komg,
        komv      TYPE komv,
        date_from TYPE rv13a-datab,
        date_to   TYPE rv13a-datbi,
      END OF ty_gs_ptf_condition_cr_td.
    CONSTANTS c_bus_obj_material TYPE ptf_bo VALUE 'MATERIAL' ##NO_TEXT.
    CONSTANTS c_bus_obj_profit_center TYPE ptf_bo VALUE 'PROFIT_CENTER' ##NO_TEXT.
    CONSTANTS c_create_price_condition TYPE string VALUE 'CREATE_PRICE_CONDITION' ##NO_TEXT.
  PROTECTED SECTION.
  PRIVATE SECTION.
    "! Get material ID for a given prefix, not yet existing in table MARA.
    METHODS get_material_id
      IMPORTING iv_prefix          TYPE ty_gs_ptf_material_cr_td-material_prefix
      RETURNING VALUE(rv_material) TYPE matnr18.
    "! Create a price condition for a referenced material.
    METHODS create_price_condition
      IMPORTING
        step_data           TYPE cl_ptf_util=>gt_ptf_step
        iv_step_number      TYPE i
      EXPORTING
        ev_document_id      TYPE cl_ptf_util=>ty_vbeln_tab
        ev_execution_status TYPE abap_bool
        ev_check_status     TYPE abap_bool.
ENDCLASS.



CLASS CL_PTF_BO_MATERIAL IMPLEMENTATION.


  METHOD change.
  ENDMETHOD.


  METHOD check.
  ENDMETHOD.


  METHOD check_existence.
    DATA:
      lv_matnr TYPE matnr.
    MOVE iv_id TO lv_matnr.
    DO 30 TIMES.
      SELECT SINGLE * FROM mara WHERE matnr = @lv_matnr INTO @DATA(ls_mara).
      IF sy-subrc IS INITIAL.
        EXIT.
      ELSE.
        WAIT UP TO 1 SECONDS.
      ENDIF.
    ENDDO.
    IF ls_mara IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Material { lv_matnr } does not exist.| ).
      rv_exists = abap_false.
    ELSE.
      rv_exists = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD create.
    DATA:
      lt_matnr    TYPE STANDARD TABLE OF matnr18 WITH DEFAULT KEY,
      lt_prctr    TYPE STANDARD TABLE OF prctr WITH DEFAULT KEY,
      ls_testdata TYPE ty_gs_ptf_material_cr_td,
      ls_message  TYPE bapiret2,
      lt_message  TYPE ty_gt_ptf_returnmessages,
      lv_ptf_key  TYPE ptfkey.
    " Get content of test data container variant.
    DATA(ls_step_data) = me->mo_run_environment->get_step_data(
      iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata ).
    " Create a unique key.
    IF ls_testdata-headdata-material IS INITIAL.
      ls_testdata-headdata-material = get_material_id(
        EXPORTING
          iv_prefix = COND #( WHEN ls_testdata-material_prefix IS NOT INITIAL THEN ls_testdata-material_prefix ELSE |PTFM_| ) ).
    ENDIF.
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(ls_ref_step_data) = me->mo_run_environment->get_step_data( iv_step_number = <lv_ref_step> ).
      IF ls_ref_step_data-bus_obj = c_bus_obj_profit_center.
        " If a profit center BO is referenced, take it as attribute of the material.
        LOOP AT ls_ref_step_data-document_id INTO DATA(ls_ptf_key).
          APPEND CONV #( ls_ptf_key-vbeln ) TO lt_prctr.
        ENDLOOP.
      ELSEIF ls_ref_step_data-bus_obj = c_bus_obj_material.
        " If a material is referenced, take it as ID of the material.
        " (this can be useful if you want to create a material in more than one plant)
        LOOP AT ls_ref_step_data-document_id INTO ls_ptf_key.
          APPEND CONV #( ls_ptf_key-vbeln ) TO lt_matnr.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
    READ TABLE lt_prctr INTO DATA(lv_prctr) INDEX 1.
    IF sy-subrc IS INITIAL.
      ls_testdata-plantdata-profit_ctr  = lv_prctr.
      ls_testdata-plantdatax-profit_ctr = abap_true.
    ENDIF.
    READ TABLE lt_matnr INTO DATA(lv_matnr) INDEX 1.
    IF sy-subrc IS INITIAL.
      ls_testdata-headdata-material = lv_matnr.
    ENDIF.
    " Create a new material via BAPI.
    CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
      EXPORTING
        headdata             = ls_testdata-headdata
        clientdata           = ls_testdata-clientdata
        clientdatax          = ls_testdata-clientdatax
        plantdata            = ls_testdata-plantdata
        plantdatax           = ls_testdata-plantdatax
        forecastparameters   = ls_testdata-forecastparameters
        forecastparametersx  = ls_testdata-forecastparametersx
        planningdata         = ls_testdata-planningdata
        planningdatax        = ls_testdata-planningdatax
        storagelocationdata  = ls_testdata-storagelocationdata
        storagelocationdatax = ls_testdata-storagelocationdatax
        valuationdata        = ls_testdata-valuationdata
        valuationdatax       = ls_testdata-valuationdatax
        warehousenumberdata  = ls_testdata-warehousenumberdata
        warehousenumberdatax = ls_testdata-warehousenumberdatax
        salesdata            = ls_testdata-salesdata
        salesdatax           = ls_testdata-salesdatax
        storagetypedata      = ls_testdata-storagetypedata
        storagetypedatax     = ls_testdata-storagetypedatax
        clientdatacwm        = ls_testdata-clientdatacwm
        clientdatacwmx       = ls_testdata-clientdatacwmx
        valuationdatacwm     = ls_testdata-valuationdatacwm
        valuationdatacwmx    = ls_testdata-valuationdatacwmx
        matplstadata         = ls_testdata-matplstadata
        matplstadatax        = ls_testdata-matplstadatax
        marc_aps_extdata     = ls_testdata-marc_aps_extdata
        marc_aps_extdatax    = ls_testdata-marc_aps_extdatax
      IMPORTING
        return               = ls_message
      TABLES
        materialdescription  = ls_testdata-materialdescription
        unitsofmeasure       = ls_testdata-unitsofmeasure
        unitsofmeasurex      = ls_testdata-unitsofmeasurex
        internationalartnos  = ls_testdata-internationalartnos
        materiallongtext     = ls_testdata-materiallongtext
        taxclassifications   = ls_testdata-taxclassifications
        returnmessages       = lt_message
        prtdata              = ls_testdata-prtdata
        prtdatax             = ls_testdata-prtdatax
        extensionin          = ls_testdata-extensionin
        extensioninx         = ls_testdata-extensioninx
        unitsofmeasurecwm    = ls_testdata-unitsofmeasurecwm
        unitsofmeasurecwmx   = ls_testdata-unitsofmeasurecwmx
        segmrpgeneraldata    = ls_testdata-segmrpgeneraldata
        segmrpgeneraldatax   = ls_testdata-segmrpgeneraldatax
        segmrpquantitydata   = ls_testdata-segmrpquantitydata
        segmrpquantitydatax  = ls_testdata-segmrpquantitydatax
        segvaluationtype     = ls_testdata-segvaluationtype
        segvaluationtypex    = ls_testdata-segvaluationtypex
        segsalesstatus       = ls_testdata-segsalesstatus
        segsalesstatusx      = ls_testdata-segsalesstatusx
        segweightvolume      = ls_testdata-segweightvolume
        segweightvolumex     = ls_testdata-segweightvolumex
        demand_penaltydata   = ls_testdata-demand_penaltydata
        demand_penaltydatax  = ls_testdata-demand_penaltydatax.
    cl_ptf_util=>do_commitment( io_run_environment = me->mo_run_environment ).
    IF ls_message IS NOT INITIAL.
      me->mo_run_environment->append_log_structure( is_log = ls_message ).
    ENDIF.
    LOOP AT lt_message ASSIGNING FIELD-SYMBOL(<ls_message>).
      me->mo_run_environment->append_log_structure( is_log = <ls_message> ).
    ENDLOOP.
    " Check if the new material has really been created.
    MOVE ls_testdata-headdata-material TO lv_ptf_key.
    DATA(lv_does_exist) = me->check_existence( iv_id = lv_ptf_key ).
    IF lv_does_exist EQ abap_true.
      ev_execution_status = abap_true.
      APPEND lv_ptf_key TO ev_document_id.
    ELSE.
      ev_execution_status = abap_false.
    ENDIF.
  ENDMETHOD.


  METHOD create_price_condition.
    DATA:
      ls_testdata   TYPE ty_gs_ptf_condition_cr_td,
      lt_matnr18    TYPE STANDARD TABLE OF matnr18,
      lv_new_record TYPE char1,
      ls_komk       TYPE komk,
      ls_komp       TYPE komp,
      lt_komv       TYPE STANDARD TABLE OF komv WITH DEFAULT KEY.
    CLEAR ev_document_id.
    ev_execution_status = abap_true.
    " Get content of test data container variant.
    DATA(ls_step_data) = me->mo_run_environment->get_step_data(
      iv_step_number = iv_step_number ).
    cl_ptf_util=>get_testdata(
      EXPORTING
        is_step_data = ls_step_data
      IMPORTING
        es_testdata  = ls_testdata ).
    " Get referenced material and check that exactly one material is referenced.
    LOOP AT ls_step_data-reference_step ASSIGNING FIELD-SYMBOL(<lv_ref_step>).
      DATA(ls_ref_step_data) = me->mo_run_environment->get_step_data( iv_step_number = <lv_ref_step> ).
      IF ls_ref_step_data-bus_obj = c_bus_obj_material.
        LOOP AT ls_ref_step_data-document_id INTO DATA(ls_ptf_key).
          APPEND CONV #( ls_ptf_key-vbeln ) TO lt_matnr18.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
    IF lines( lt_matnr18 ) <> 1 OR lt_matnr18[ 1 ] IS INITIAL.
      me->mo_run_environment->append_log( iv_log_statement = |Refer to one material!| ).
      ev_execution_status = abap_false.
      RETURN.
    ENDIF.
    " Create price condition.
    ls_testdata-komg-matnr = lt_matnr18[ 1 ].
    APPEND ls_testdata-komv TO lt_komv.
    CALL FUNCTION 'RV_CONDITION_RESET'
      EXPORTING
        clear_number_change = abap_true.
    CALL FUNCTION 'RV_CONDITION_COPY'
      EXPORTING
        application        = 'V'
        condition_table    = '304'
        condition_type     = ls_testdata-komv-kschl
        date_from          = ls_testdata-date_from
        date_to            = ls_testdata-date_to
        enqueue            = abap_true
        i_komk             = ls_komk
        i_komp             = ls_komp
        key_fields         = ls_testdata-komg
        maintain_mode      = 'A'
        no_authority_check = abap_true
        keep_old_records   = abap_true
        overlap_confirmed  = abap_true
        no_db_update       = abap_false
      IMPORTING
        e_komk             = ls_komk
        e_komp             = ls_komp
        new_record         = lv_new_record
      TABLES
        copy_records       = lt_komv
      EXCEPTIONS
        OTHERS             = 1.
    IF sy-subrc IS NOT INITIAL.
      me->mo_run_environment->append_log_structure( is_log = VALUE #( id = sy-msgid type = sy-msgty number = sy-msgno
                                                                      message_v1 = sy-msgv1  message_v2 = sy-msgv2
                                                                      message_v3 = sy-msgv3  message_v4 = sy-msgv4 ) ).
    ELSE.
      CALL FUNCTION 'RV_CONDITION_SAVE'.
      COMMIT WORK AND WAIT.
    ENDIF.
  ENDMETHOD.


  METHOD delete.
  ENDMETHOD.


  METHOD execute_action.
    DATA(ls_step_data) = me->mo_run_environment->get_step_data( iv_step_number = iv_step_number ).
    CASE ls_step_data-action.
      WHEN c_create_price_condition.
        me->create_price_condition(
          EXPORTING
            step_data           = ls_step_data
            iv_step_number      = iv_step_number
          IMPORTING
            ev_document_id      = ev_document_id
            ev_execution_status = ev_execution_status
            ev_check_status     = ev_check_status ).
        RETURN.
      WHEN OTHERS.
        me->mo_run_environment->append_log( iv_log_statement = |Could not find method { ls_step_data-action } for the BO { ls_step_data-bus_obj }.| ).
        ev_execution_status = abap_false.
        ev_check_status = abap_false.
        RETURN.
    ENDCASE.
  ENDMETHOD.


  METHOD execute_check.
  ENDMETHOD.


  METHOD get_material_id.
    DATA: lv_matnr_pattern  TYPE string.
    DATA: lv_matnr      TYPE matnr18.
    DATA: lv_string1    TYPE string,
          lv_string2(6) TYPE n.
    CONCATENATE iv_prefix '%' INTO lv_matnr_pattern.
    SELECT MAX( matnr ) INTO (lv_matnr) FROM mara WHERE matnr LIKE lv_matnr_pattern. "#EC CI_BYPASS
    IF lv_matnr IS INITIAL.
      rv_material = iv_prefix && '000001'.
    ELSE.
      lv_string1 = lv_matnr+0(5).
      lv_string2 = lv_matnr+5.
      lv_string2 = lv_string2 + 1.
      CONCATENATE lv_string1 lv_string2 INTO rv_material.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
