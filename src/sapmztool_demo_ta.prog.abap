*&---------------------------------------------------------------------*
*& Report sapmztool_demo_ta
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report sapmztool_demo_ta.

data demo_date type ersda.
data demo_packed type p DECIMALS 2.
data demo_packed_f type p decimals 3.
data demo_text type text132.
data user_command type syucomm.

data logger type ref to zif_logger.
module status_0001 output.
  SET PF-STATUS '1'.
  SET TITLEBAR '1'.
endmodule.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_0001 input.
  if user_command = 'SAVE'.
    logger = zcl_logger_factory=>create_log( object = 'ZDEV' ).
    logger->add(
      |Date: { demo_date date = user } packed: { demo_packed number = user DECIMALS = 2 } | &
      |float: { demo_packed_f number = user DECIMALS = 3 } text: { demo_text }| ).
    set screen 0.
  endif.
endmodule.
