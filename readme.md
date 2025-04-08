# ABAP Batch Input Toolbox: Streamlined Processing

Despite the prevalence of newer technologies, batch input processing remains a relevant aspect of ABAP development. This document introduces a utility designed to enhance the clarity and maintainability of ABAP batch input programs.

## Conceptual Overview

The core idea is to encapsulate the steps of a transaction we aim to automate within a dedicated object.

For instance, to initiate automation for the 'SO10' transaction, you would instantiate the tool as follows:

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

* The `program( )` and `dynpro( )` methods specify the program and screen number, respectively.
* The `field( <name> )->value( <value> )`  method is used to set the value of a specific field on the screen. It intelligently handles various data types, including character strings, dates, and numerical values, automatically converting them to the appropriate $BDC\_FVAL$ format.
* For fields within table controls or loop structures, use `line( <index> )->field( <name> )->value( <value> )`, providing the specific line index.
* The `ok_code( )` method allows you to set the function code (user command) for the screen.

Once all screen inputs are defined, you can execute the transaction using either a batch input session or by running it directly:


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


This toolbox provides the flexibility to either generate a batch input session for later processing or to execute the automated transaction immediately.

The tool leverages the [ABAP logger](https://github.com/ABAP-Logger/ABAP-Logger) framework for comprehensive message logging. It accepts instances of both the modern ZIF_LOGGER and the legacy ZCL_LOGGER.

Prior to execution, you can configure various batch input parameters using the following methods:

Before running, you can set parameters with 
* `mode( )` - Sets the batch input processing mode (e.g., 'A' for display all screens, 'N' for no display, 'E' for display errors only)
* `no_bi_mode( )`, `no_bi_end( )` - Control the 'No Batch Input' flags
* `set_defsize( )` - Activates the use of the default window size.
* `update( )` - Defines the update mode 

For detailed usage examples and further exploration of the available functionalities, please refer to the accompanying demo report.

## dependencies

This tool relies on the [ABAP logger library](https://github.com/ABAP-Logger/ABAP-Logger) for its logging capabilities.
  
