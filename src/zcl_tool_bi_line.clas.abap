class zcl_tool_bi_line definition
  public
  final
  create public .

  public section.
    methods constructor
      importing
        i_index type i
        i_dynpro type ref to zcl_tool_bi_dynpro.

    methods field
      importing
        name type bdc_fnam
      returning
        value(result) type ref to zcl_tool_bi_abstr_field.

    methods cursor
      importing
        name type bdc_fnam
      returning
        value(result) type ref to zcl_tool_bi_dynpro.

  protected section.
  private section.
    DATA index TYPE i.
    DATA dynpro TYPE REF TO zcl_tool_bi_dynpro.
endclass.



class zcl_tool_bi_line implementation.
  method constructor.
    index = i_index.
    dynpro = i_dynpro.
  endmethod.

  method field.
    result ?= new zcl_tool_bi_table_field(
                    i_name = name
                    i_dynpro = dynpro
                    i_index = index ).
    dynpro->add_field( result ).
  endmethod.

  method cursor.
    dynpro->cursor( |{ name }({ conv num2( index ) })| ).
    result = dynpro.
  endmethod.
endclass.
