*&---------------------------------------------------------------------*
*&  Include           ZDESAFIO_JM_SRC
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-t01.
SELECT-OPTIONS so_dtat FOR sy-datum NO INTERVALS.
SELECT-OPTIONS so_sts  FOR zdesafiot01_jm-status NO INTERVALS.
SELECT-OPTIONS so_dtap FOR sy-datum NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b1.