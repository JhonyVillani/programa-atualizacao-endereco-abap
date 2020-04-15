*&---------------------------------------------------------------------*
*&  Include           ZDESAFIO_JM_EVE
*&---------------------------------------------------------------------*

START-OF-SELECTION.

  CREATE OBJECT go_atualiza.
  CREATE OBJECT gr_event_handler .

GET peras.

  go_atualiza->processa( ).

END-OF-SELECTION.

  CALL SCREEN 100.