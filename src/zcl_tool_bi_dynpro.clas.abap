class zcl_tool_bi_dynpro definition
  public
  final
  create public .

  public section.
    methods field
      importing
        name type bdc_fnam
      returning
        value(result) type ref to zcl_tool_bi_field.

    methods dynpro
      importing
        id type bdc_fval
      returning
        value(result) type ref to zcl_tool_bi_dynpro.

    methods program
      importing
        id type bdc_fval
      returning
        value(result) type ref to zcl_tool_bi_dynpro.

    methods ok_code
      importing
        code type sy-ucomm
      returning
        value(result) type ref to zcl_tool_bi_dynpro.

    methods cursor
      importing
        field type bdc_fnam
      returning
        value(result) type ref to zcl_tool_bi_dynpro.

    methods line
      importing
        index type i
      returning
        value(result) type ref to zcl_tool_bi_line.

    methods merge
      returning
        value(result) type zcl_tool_bi_types=>bdcdata_lines.
    methods add_field
      importing
        field type ref to zcl_tool_bi_abstr_field.
  protected section.
  private section.
    data fields type standard table of ref to zcl_tool_bi_abstr_field with empty key.
    data okcode type sy-ucomm.
    data bdc_cursor type bdc_fnam.
    data dynpro_id type bdc_fval.
    data program_id type bdc_fval.

    METHODS merge_fields
      returning
        value(result) type types=>bdcdata_lines.
endclass.



class zcl_tool_bi_dynpro implementation.
  method field.
    result = new #( i_name = name
                    i_dynpro = me ).
    insert result into table fields.
  endmethod.

  method merge.
    result =
      value #(
        ( dynpro = dynpro_id
          program = program_id
          dynbegin = abap_true )
        ( fnam = 'BDC_OKCODE'
          fval = okcode )
        ( lines of
            cond #(
              when bdc_cursor is not initial
              then value #( ( fnam = 'BDC_CURSOR'
                              fval = bdc_cursor ) ) ) )
        ( lines of merge_fields( ) ) ).
  endmethod.

  method ok_code.
    okcode = code.
    result = me.
  endmethod.

  method cursor.
    bdc_cursor = field.
    result = me.
  endmethod.

  method merge_fields.
    result =
      value #(
        for line in fields
        ( line->merge( ) ) ).
  endmethod.

  method dynpro.
    dynpro_id = id.
    result = me.
  endmethod.

  method program.
    program_id = id.
    result = me.
  endmethod.

  method line.
    result = new zcl_tool_bi_line( i_index = index
                                   i_dynpro = me ).
  endmethod.

  method add_field.
    insert field into table fields.
  endmethod.

endclass.
