class zcl_tool_bi_mode definition
  public
  final
  create public .

  public section.
    class-methods get_mode returning value(result) type bdc_mode.

    class-methods set_mode importing bi_mode type bdc_mode.
  private section.
    class-data mode type  bdc_mode value 'E'.
ENDCLASS.



CLASS ZCL_TOOL_BI_MODE IMPLEMENTATION.


  method get_mode.
    result = mode.
  endmethod.


  method set_mode.
    mode = bi_mode.
  endmethod.
ENDCLASS.
