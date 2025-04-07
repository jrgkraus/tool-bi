# ABAP batch input toolbox
Unfortunately batch input processing still matters... Here is a tool to help keep batch input programming cleaner and more readable.

## How it works
The idea is to capture the transaction run we want to automate in an object. 

    ta = new zcl_tool_bi_transaction( 'SO10' ).

Pass the transaction to call as a parameter to the constructor.

Then create inputs screen by screen

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

Set the dynpro with `program( )` and `dynpro( )`.

`field( <name> )->value( <value> )` will set the value in a field. You can pass character-like values as well as date fields or numerical fields. The tool will try to convert the data to BDC_FVAL accordingly.

`line( <index> )->field( <name> )->value( <value> )` sets the value in a loop field, pass the line index as parameter.

Set the user command with `ok_code( )`.

After having set up all screen data, go on and run the transaction: 

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

  As you see, there is an option to use a batch input session as well as run the transaction directly.

  Before running, you can set parameters with 
  * `mode( )` - BI mode A/N/E
  * `no_bi_mode( )`, `no_bi_end( )`
  * `set_defsize( )` - use default size window
  * `update( )` - set update mode

## dependencies

This package uses [ABAP logger](https://github.com/ABAP-Logger/ABAP-Logger)
  
