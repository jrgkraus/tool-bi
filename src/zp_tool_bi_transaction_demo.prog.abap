*&---------------------------------------------------------------------*
*& Report zp_tool_bi_transaction_demo
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zp_tool_bi_transaction_demo.

parameters test1 as checkbox.
parameters demodate type d.
parameters demopack type p decimals 3.
parameters demofloa type decfloat34.
parameters demotext type text132.
parameters session type apq_grpn.
selection-screen skip.
parameters test2 as checkbox.
parameters textname type tdobname.
parameters mode type ctu_params-dismode.


data session_id type apq_quid.

start-of-selection.
  if test1 = abap_true.

    " demo for intrinsic type conversions
    data(ta) = new zcl_tool_bi_transaction( 'ZT_TOOL_BIDEMO' ).

    ta->new_dynpro(
      )->program( 'SAPMZTOOL_DEMO_TA'
      )->dynpro( '0001'
      )->field( 'DEMO_DATE' )->value( demodate
      )->field( 'DEMO_PACKED' )->value( demopack
      " convert a floating point number into a packed number on screen
      " make sure the input has not more decimals than the screen field!
      )->field( 'DEMO_PACKED_F' )->value( conv f( demofloa )
      )->field( 'DEMO_TEXT' )->value( demotext
      )->ok_code( '/11' ).
    data(logger) = zcl_logger_factory=>create_log( ).
    if session is not initial.
      call function 'BDC_OPEN_GROUP'
        exporting
          group = session
        importing
          qid   = session_id.
      if ta->insert( logger ) > 0.
        logger->popup( ).
      else.
        call function 'BDC_CLOSE_GROUP'.
      endif.
    else.
      if ta->mode( mode )->run( logger ) > 0.
        logger->popup( ).
      endif.
    endif.
  endif.

  if test2 = abap_true.
    " demo for various BI functions
    ta = new zcl_tool_bi_transaction( 'SO10' ).
    ta->new_dynpro(
      )->program( 'SAPMSSCE'
      )->dynpro( '1100'
      )->cursor( 'RSSCE-TDNAME'
      )->ok_code( '=CREA'
      )->field( 'RSSCE-TDNAME' )->value( |{ textname }|
      )->field( 'RSSCE-TDID' )->value( 'ST'
      )->field( 'RSSCE-TDSPRAS' )->value( 'EN' ).
    ta->new_dynpro(
      )->program( 'SAPLSTXX'
      )->dynpro( '1100'
      )->ok_code( '=TXSV'
      )->line( 2 )->field( 'RSTXT-TXLINE' )->value( 'First line'
      )->line( 2 )->cursor( 'RSTXT-TXLINE'
      )->line( 3 )->field( 'RSTXT-TXPARGRAPH' )->value( '*'
      )->line( 3 )->field( 'RSTXT-TXLINE' )->value( 'Second line'
      )->line( 4 )->field( 'RSTXT-TXPARGRAPH' )->value( '*'
      )->line( 4 )->field( 'RSTXT-TXLINE' )->value( 'third line'  ).
    ta->new_dynpro(
      )->program( 'SAPLSTXX'
      )->dynpro( '1100'
      )->ok_code( '=TXEX' ).
    ta->new_dynpro(
      )->program( 'SAPMSSCE'
      )->dynpro( '1100'
      )->ok_code( '=TXEX' ).

    data(log) = zcl_logger_factory=>create_log( ).
    if ta->mode( mode )->run( cast #( log ) ) > 0.
      log->popup( ).
    endif.
  endif.
