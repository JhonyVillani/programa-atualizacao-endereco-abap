*&---------------------------------------------------------------------*
*&  Include           ZDESAFIO_JM_TOP
*&---------------------------------------------------------------------*

INFOTYPES: 0001,
           0002.

TABLES: pernr,
        zdesafiot01_jm.

NODES peras.

"Classe local de tratamento de dados
CLASS lcl_atualiza      DEFINITION DEFERRED.

"Classe local de tratamento de eventos no ALV
CLASS lcl_event_handler DEFINITION DEFERRED.

"Declara uma variável do tipo da classe
DATA: go_atualiza      TYPE REF TO lcl_atualiza. "Classe local
DATA: gr_event_handler TYPE REF TO lcl_event_handler. "Classe de Eventos

"Componentes do ALV GRID
DATA: go_container_100  TYPE REF TO cl_gui_custom_container,
      go_grid           TYPE REF TO cl_gui_alv_grid.