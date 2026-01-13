*&---------------------------------------------------------------------*
*& Report PTF_COUNT_USAGE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ptf_count_usage.

*PARAMETERS btch_onl TYPE abap_bool DEFAULT space.  "batch only

WRITE: 'Client:', sy-sysid, sy-mandt, /.

DATA gc_mb TYPE syst_uname VALUE '_SAPD066605'.
DATA gc_es TYPE syst_uname VALUE '_SAPI517452'.

DATA start_of_week TYPE d.
DATA yesterday TYPE d.
DATA date_15days_back TYPE d.
DATA date_36days_back TYPE d.
date_36days_back = sy-datum - 36.
date_15days_back = sy-datum - 15.
start_of_week = sy-datum - 7.
yesterday = sy-datum - 1.

WRITE: 'Considered until:', yesterday DDMMYY , /.



PERFORM select_data USING abap_true.

SKIP.
 SKIP.

PERFORM select_data USING abap_false.




FORM select_data USING iv_btch_only TYPE abap_bool.

  WRITE: /,/ 'Flag OnlyBatch  : <', iv_btch_only, '>', /.

  DATA lt_batch_range TYPE RANGE OF abap_bool.
  CLEAR lt_batch_range.

  IF iv_btch_only IS NOT INITIAL.
    APPEND VALUE #( sign = 'I' option = 'EQ'  low = 'X' ) TO lt_batch_range.
  ENDIF.


  SELECT DISTINCT ptf_script FROM ptf_exec_log INTO TABLE @DATA(lt_day) WHERE start_date = @yesterday
    AND is_batch IN @lt_batch_range.

  SELECT DISTINCT ptf_script FROM ptf_exec_log INTO TABLE @DATA(lt_week)   WHERE start_date BETWEEN @start_of_week AND @yesterday       "The interval limits are included.
    AND is_batch IN @lt_batch_range.

  SELECT DISTINCT ptf_script FROM ptf_exec_log INTO TABLE @DATA(lt_2weeks) WHERE start_date BETWEEN @date_15days_back AND @yesterday
    AND is_batch IN @lt_batch_range.

  SELECT DISTINCT ptf_script FROM ptf_exec_log INTO TABLE @DATA(lt_5weeks) WHERE start_date BETWEEN @date_36days_back AND @yesterday
    AND is_batch IN @lt_batch_range.

  WRITE: / 'No of distinct executed PTF scripts yesterday    :', lines( lt_day ).
  WRITE: / 'No of distinct executed PTF scripts last  7 days :', lines( lt_week ).
  WRITE: / 'No of distinct executed PTF scripts last 14 days :', lines( lt_2weeks ).
  WRITE: / 'No of distinct executed PTF scripts last 35 days :', lines( lt_5weeks ).



  SELECT DISTINCT ptf_script FROM ptf_exec_log INTO TABLE @DATA(lt_day_bil) WHERE start_date = @yesterday
    AND ( userid = @gc_mb OR userid = @gc_es ) AND is_batch IN @lt_batch_range.

  SELECT DISTINCT ptf_script FROM ptf_exec_log INTO TABLE @DATA(lt_week_bil)   WHERE start_date BETWEEN @start_of_week AND @yesterday
    AND ( userid = @gc_mb OR userid = @gc_es ) AND is_batch IN @lt_batch_range.

  SELECT DISTINCT ptf_script FROM ptf_exec_log INTO TABLE @DATA(lt_2weeks_bil) WHERE start_date BETWEEN @date_15days_back AND @yesterday
    AND ( userid = @gc_mb OR userid = @gc_es ) AND is_batch IN @lt_batch_range.

  SELECT DISTINCT ptf_script FROM ptf_exec_log INTO TABLE @DATA(lt_5weeks_bil) WHERE start_date BETWEEN @date_36days_back AND @yesterday
    AND ( userid = @gc_mb OR userid = @gc_es ) AND is_batch IN @lt_batch_range.

  WRITE: /, / 'BIL user:'.

  WRITE: / 'No of distinct executed PTF scripts yesterday    :', lines( lt_day_bil ).
  WRITE: / 'No of distinct executed PTF scripts last  7 days :', lines( lt_week_bil ).
  WRITE: / 'No of distinct executed PTF scripts last 14 days :', lines( lt_2weeks_bil ).
  WRITE: / 'No of distinct executed PTF scripts last 35 days :', lines( lt_5weeks_bil ).


ENDFORM.
