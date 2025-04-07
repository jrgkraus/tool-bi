class zcl_tool_bi_table_field definition
  public
  inheriting from zcl_tool_bi_abstr_field
  create public .

  public section.
    methods constructor
      importing
        i_name type bdc_fnam
        i_dynpro type ref to zcl_tool_bi_dynpro
        i_index type i.



    methods merge redefinition.
  protected section.


    DATA tab_index TYPE n length 2.

  private section.
endclass.



class zcl_tool_bi_table_field implementation.
  method constructor.
    super->constructor( i_name = i_name
                        i_dynpro = i_dynpro ).
    tab_index = i_index.
  endmethod.



  method merge.
    result = value #( fnam = |{ name }({ tab_index })|
                      fval = fieldvalue ).
  endmethod.


endclass.
