class zcl_tool_bi_types definition
  public
  abstract
  create public .

  public section.
    types bdcdata_lines type standard table of bdcdata with default key.
    types bdcmsgcoll_lines type standard table of bdcmsgcoll with default key.
  protected section.
  private section.
endclass.



class zcl_tool_bi_types implementation.
endclass.
