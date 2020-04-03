*&---------------------------------------------------------------------*
*&  Include           ZDESAFIO_JM_EVE
*&---------------------------------------------------------------------*

* Declara uma variável do tipo da classe
  DATA: go_atualiza TYPE REF TO lcl_atualiza. "Classe local

  START-OF-SELECTION.

    CREATE OBJECT go_atualiza.

  GET peras.

    rp_provide_from_last p0001 space pn-begda pn-endda.
    rp_provide_from_last p0002 space pn-begda pn-endda.
    rp_provide_from_last p0006 space pn-begda pn-endda.
    rp_provide_from_last p0105 space pn-begda pn-endda.

*     Filtro para data de modificação e Usuário SAP
*-----------------------------------------------------------------
    IF p0006-aedtm NOT IN so_aedtm OR p0105-usrid NOT IN so_usrid.
      REJECT.
    ENDIF.

    go_atualiza->processa( ).

  END-OF-SELECTION.

    go_atualiza->exibe( ).