class zcl_tool_bi_transaction definition
  public
  final
  create public .

  public section.
    methods constructor
      importing
        code type sy-tcode.

    methods new_dynpro
      returning
        value(result) type ref to zcl_tool_bi_dynpro.

    methods mode
      importing
        mode          type ctu_params-dismode
      returning
        value(result) type ref to zcl_tool_bi_transaction.

    methods update
      importing
        mode          type ctu_params-updmode
      returning
        value(result) type ref to zcl_tool_bi_transaction.

    methods no_bi_mode
      returning
        value(result) type ref to zcl_tool_bi_transaction.

    methods no_bi_end
      returning
        value(result) type ref to zcl_tool_bi_transaction.

    methods set_defsize
      returning
        value(result) type ref to zcl_tool_bi_transaction.

    methods run
      importing
        log           type ref to object
      returning
        value(result) type sysubrc.

    methods insert
      importing
        log           type ref to object
      returning
        value(result) type sysubrc.



  protected section.
  private section.
    data dynpros type standard table of ref to zcl_tool_bi_dynpro with empty key.
    data bdcdata_lines type bdcdata_tab.
    data tcode type sy-tcode.
    data options type ctu_params.
    data messages type tab_bdcmsgcoll.

    methods merge
      returning
        value(result) type bdcdata_tab.

    methods add_to_log
      importing
        log        type ref to object
        i_messages type tab_bdcmsgcoll optional.

endclass.



class zcl_tool_bi_transaction implementation.


  method constructor.
    tcode = code.
  endmethod.


  method insert.
    data(bdc_lines) = merge( ).
    call function 'BDC_INSERT'
      exporting
        tcode            = tcode
        ctuparams        = options
      tables
        dynprotab        = bdc_lines
      exceptions
        internal_error   = 1
        not_open         = 2
        queue_error      = 3
        tcode_invalid    = 4
        printing_invalid = 5
        posting_invalid  = 6
        others           = 7.
    result = sy-subrc.
    if result <> 0.
      add_to_log( log ).
    endif.
  endmethod.


  method merge.
    result =
      value #(
        for line in dynpros
        ( lines of line->merge( ) ) ).
  endmethod.


  method mode.
    options-dismode = mode.
    result = me.
  endmethod.


  method new_dynpro.
    result = new #( ).
    insert result into table dynpros.
  endmethod.


  method no_bi_end.
    options-nobiend = abap_true.
    result = me.
  endmethod.


  method no_bi_mode.
    options-nobinpt = abap_true.
    result = me.
  endmethod.


  method run.
    data(bdc_lines) = merge( ).
    call transaction tcode with authority-check
      using bdc_lines
      options from options
      messages into messages.
    result = sy-subrc.
    if messages is not initial.
      add_to_log(
        log = log
        i_messages = messages ).
    endif.
  endmethod.


  method set_defsize.
    options-defsize = abap_true.
    result = me.
  endmethod.


  method update.
    options-updmode = mode.
    result = me.
  endmethod.

  method add_to_log.
    data(local_log) = cast zif_logger( log ).
    if i_messages is not initial.
      local_log->add( i_messages ).
    else.
      local_log->add( ).
    endif.
  endmethod.

endclass.
