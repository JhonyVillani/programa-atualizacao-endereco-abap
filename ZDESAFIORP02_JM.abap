*---------------------------------------------------------------------*
*                         INTELLIGENZA                                *
*---------------------------------------------------------------------*
* Cliente....:                                                        *
* Autor......: Jhony Villani                                          *
* Data.......: 03/04/2020                                             *
* Descrição..: Treinamento ABAP - Atualização de Endereços            *
* Transação..:                                                        *
* Projeto....: Treinamento ABAP                                       *
*---------------------------------------------------------------------*
* Histórico das modificações                                          *
*---------------------------------------------------------------------*
* Autor :                                                             *
* Observações:                                                        *
*---------------------------------------------------------------------*

REPORT zdesafiorp02_jm.

INCLUDE zdesafiorp02_jm_top. "Declarações Globais
INCLUDE zdesafiorp02_jm_c02. "Classe EVENT HANDLER
INCLUDE zdesafiorp02_jm_src. "Tela de seleção
INCLUDE zdesafiorp02_jm_c01. "Classe
INCLUDE zdesafiorp02_jm_eve. "Eventos

INCLUDE zdesafiorp02_jm_pbo.

INCLUDE zdesafiorp02_jm_pbo_sts.

INCLUDE zdesafiorp02_jm_status_0101o01.

INCLUDE zdesafiorp02_jm_pai.