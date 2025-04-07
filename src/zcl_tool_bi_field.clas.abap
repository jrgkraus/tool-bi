class zcl_tool_bi_field definition
  public
  inheriting from zcl_tool_bi_abstr_field
  create public .

  public section.



    methods index
      importing
        in type i.

    methods merge redefinition.
  protected section.


    DATA tab_index TYPE i.

  private section.
endclass.



class zcl_tool_bi_field implementation.

  method merge.
    result = value #( fnam = name
                      fval = fieldvalue ).
  endmethod.

  method index.
    tab_index = in.
  endmethod.

endclass.
