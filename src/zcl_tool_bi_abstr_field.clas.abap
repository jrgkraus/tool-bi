class zcl_tool_bi_abstr_field definition
  public
  abstract
  create public .

  public section.
    methods constructor
      importing
        i_name   type bdc_fnam
        i_dynpro type ref to zcl_tool_bi_dynpro.

    methods value
      importing
        i_value       type any
      returning
        value(result) type ref to zcl_tool_bi_dynpro.

    methods merge abstract
      returning
        value(result) type bdcdata.
  protected section.
    data name type bdc_fnam.
    data fieldvalue type bdc_fval.
    data dynpro type ref to zcl_tool_bi_dynpro.

  private section.
endclass.



class zcl_tool_bi_abstr_field implementation.
  method constructor.
    name = i_name.
    dynpro = i_dynpro.
  endmethod.

  method value.
    fieldvalue =
      switch #(
        cl_abap_typedescr=>describe_by_data( i_value
          )->type_kind
        when cl_abap_typedescr=>typekind_date
          then |{ conv d( i_value ) date = user }|
        when  cl_abap_typedescr=>typekind_packed or
              cl_abap_typedescr=>typekind_float or
              cl_abap_typedescr=>typekind_int
          then condense(
                 val = condense( |{ conv f( i_value ) number = user decimals = 6 }| )
                 del = '0' )
        else i_value ).
    result = dynpro.
  endmethod.
endclass.
