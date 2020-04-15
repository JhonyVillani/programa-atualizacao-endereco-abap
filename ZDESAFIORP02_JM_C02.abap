*----------------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION .
  PUBLIC SECTION .

    DATA: mv_row TYPE i.

    METHODS:
      handle_button_click FOR EVENT button_click OF cl_gui_alv_grid
              IMPORTING
                es_col_id
                es_row_no
                sender.
  PRIVATE SECTION.
ENDCLASS.                    "lcl_event_handler DEFINITION
*----------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION .

  METHOD handle_button_click.

    CALL SCREEN 0101
        STARTING AT 4 10
        ENDING AT 100 20.

  ENDMETHOD.                    "handle_hotspot_click

ENDCLASS .                    "lcl_event_handler IMPLEMENTATION