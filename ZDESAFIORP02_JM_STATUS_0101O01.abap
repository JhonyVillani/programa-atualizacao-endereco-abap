*----------------------------------------------------------------------*
***INCLUDE ZDESAFIORP02_JM_STATUS_0101O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0101  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0101 OUTPUT.
  SET PF-STATUS '1001'.

  DATA:
    cep_campo         TYPE c LENGTH 100,
    logra_campo       TYPE c LENGTH 100,
    numero_campo      TYPE c LENGTH 100,
    complemento_campo TYPE c LENGTH 100,
    bairro_campo      TYPE c LENGTH 100,
    cidade_campo      TYPE c LENGTH 100,
    estado_campo      TYPE c LENGTH 100,
    matricula_campo   TYPE c LENGTH 100,
    nome_campo        TYPE c LENGTH 100.

  go_atualiza->popula_tela(
     CHANGING
       cv_cep_campo         = cep_campo
       cv_logra_campo       = logra_campo
       cv_numero_campo      = numero_campo
       cv_complemento_campo = complemento_campo
       cv_bairro_campo      = bairro_campo
       cv_cidade_campo      = cidade_campo
       cv_estado_campo      = estado_campo
       cv_matricula_campo   = matricula_campo
       cv_nome_campo        = nome_campo ).

  CASE sy-ucomm.

    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE TO SCREEN 0.
    WHEN 'CANCEL'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.                 " STATUS_0101  OUTPUT