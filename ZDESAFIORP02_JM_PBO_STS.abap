*----------------------------------------------------------------------*
***INCLUDE ZDESAFIORP02_JM_PBO_STS.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS '1000'.
  SET TITLEBAR '1000'.

  CASE sy-ucomm.

    WHEN 'BACK'.
      LEAVE PROGRAM.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANCEL'.
      LEAVE PROGRAM.
  ENDCASE.

ENDMODULE.                 " STATUS_0100  OUTPUT

*----------------------------------------------------------------------*
*  MODULE user_command_0100 INPUT
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  SET PF-STATUS '1000'.

  CASE sy-ucomm.
    WHEN 'BTNAPROV'.
      go_atualiza->aprovar( ).
    WHEN 'BTNREJECT'.
      go_atualiza->rejeitar( ).
  ENDCASE.

ENDMODULE.                 " USER_COMMAND_0100  INPUT