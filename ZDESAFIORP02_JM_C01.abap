*&---------------------------------------------------------------------*
*&  Include           ZDESAFIO_JM_C01
*&---------------------------------------------------------------------*

CLASS lcl_atualiza DEFINITION.
  PUBLIC SECTION.

    TYPES:
           BEGIN OF ty_s_saida,
             pernr TYPE p0001-pernr,
             bukrs TYPE p0001-bukrs,
             cname TYPE p0002-cname,
             logra TYPE hrpadbr_street_address_type, "Logradouro
             stras TYPE p0006-stras,   "Rua
             hsnmr TYPE p0006-hsnmr,   "Nº
             posta TYPE q0006br-posta, "Complemento
             ort02 TYPE p0006-ort02,   "Bairro
             ort01 TYPE p0006-ort01,   "Cidade
             pstlz TYPE p0006-pstlz,   "CEP
             land1 TYPE p0006-land1,   "País
             state TYPE p0006-state,   "Estado
             aedtm TYPE p0006-aedtm,   "Data de Modificação
             uname TYPE p0006-uname,   "Responsável
             usrid TYPE zdesafiode01_jm, "Usuário SAP
             email TYPE zdesafiode02_jm, "E-mail
           END OF ty_s_saida.

    DATA: mt_saida TYPE TABLE OF ty_s_saida,
          ms_saida TYPE ty_s_saida.

*    DATA: p0105 TYPE table of p0105.

    METHODS:
   processa,
   exibe.

ENDCLASS.                    "lcl_atualiza DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_atualiza IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_atualiza IMPLEMENTATION.
  METHOD processa.

    DATA: lt_p0105 TYPE TABLE OF p0105.

    "Função tipo logradouro
    DATA: lo_t7brconvrule TYPE REF TO cl_hrpadbr_t7brconvrule,
          lv_addr_type    TYPE hrpadbr_street_address_type,
          lv_street       TYPE string.

    ms_saida-pernr = p0001-pernr  .
    ms_saida-bukrs = p0001-bukrs  .
    ms_saida-cname = p0002-cname  .
    ms_saida-stras = p0006-stras  .
    ms_saida-hsnmr = p0006-hsnmr  .
    ms_saida-posta = p0006-posta  .
    ms_saida-ort02 = p0006-ort02  .
    ms_saida-ort01 = p0006-ort01  .
    ms_saida-pstlz = p0006-pstlz  .
    ms_saida-land1 = p0006-land1  .
    ms_saida-state = p0006-state  .
    ms_saida-aedtm = p0006-aedtm  .
    ms_saida-uname = p0006-uname  .
    ms_saida-usrid = p0105-usrid  .

    rp_provide_from_last p0105 '0010' pn-begda pn-endda.
    ms_saida-email = p0105-usrid_long  .

    IF ms_saida-stras IS NOT INITIAL.
      CREATE OBJECT lo_t7brconvrule.

      lv_street = ms_saida-stras.

      lv_addr_type = lo_t7brconvrule->convert_field(
        iv_appl = 'ESOC'
        iv_section = cl_hrpadbr_t7brconvrule=>gc_address_section
        iv_field = cl_hrpadbr_t7brconvrule=>gc_address_type
        iv_input = lv_street
      ).

      FREE lo_t7brconvrule.

      ms_saida-logra = lv_addr_type.
    ENDIF.

    APPEND ms_saida TO mt_saida.

  ENDMETHOD.                    "processa

  METHOD exibe.

    DATA: mo_alv     TYPE REF TO cl_salv_table,
          go_columns TYPE REF TO cl_salv_columns_table,
          go_zebra   TYPE REF TO cl_salv_display_settings.


*     Chama o método que constrói a saída ALV
*--------------------------------------------
    CALL METHOD cl_salv_table=>factory
      IMPORTING
        r_salv_table = mo_alv
      CHANGING
        t_table      = mt_saida.

    "Otimiza tamanho das colunas
    go_columns = mo_alv->get_columns( ). "Retorna o objeto tipo coluna INSTANCIADO
    go_columns->set_optimize( ).

    "Zebrar report
    go_zebra = mo_alv->get_display_settings( ).
    go_zebra->set_striped_pattern( abap_true ).

    "Mostra o ALV
    mo_alv->display( ). "Imprime na tela do relatório ALV

  ENDMETHOD.                    "exibe

ENDCLASS.                    "lcl_atualiza IMPLEMENTATION