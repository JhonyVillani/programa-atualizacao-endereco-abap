*&---------------------------------------------------------------------*
*&  Include           ZDESAFIO_JM_SRC
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-t01.
SELECT-OPTIONS so_aedtm FOR sy-datum NO INTERVALS.
SELECT-OPTIONS so_usrid FOR p0105-usrid NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b1.