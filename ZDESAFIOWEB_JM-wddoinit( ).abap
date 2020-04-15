METHOD wddoinit .

*     Declarações de Variáveis
*-------------------------------------------------------------------------
  DATA: lo_nd_node TYPE REF TO if_wd_context_node.
  DATA: lo_el_node TYPE REF TO if_wd_context_element.
  DATA: ls_node    TYPE wd_this->element_node.

  DATA: lo_componentcontroller TYPE REF TO ig_componentcontroller .

  DATA: lv_usrid TYPE p0105-usrid,
        lv_pernr TYPE p0105-pernr,
        ls_p0002 TYPE pa0002,
        ls_p0006 TYPE pa0006.

* navigate from <CONTEXT> to <NODE> via lead selection
  lo_nd_node = wd_context->get_child_node( name = wd_this->wdctx_node ).


* get element via lead selection
  lo_el_node = lo_nd_node->get_element( ).

  lo_componentcontroller =   wd_this->get_componentcontroller_ctr( ).

  lv_usrid = sy-uname.

*     Função que traz a matrícula
*--------------------------------------------------------
  lo_componentcontroller->execute_rp_get_pernr_from_user(
     EXPORTING
       begda =                           sy-datum
       endda =                           '99991231'
       usrid =                           lv_usrid
       usrty =                           '0001'
     IMPORTING
       usr_pernr =                       lv_pernr
   ).

*     Populando variáveis com dados dos infotipos
*------------------------------------------------
  SELECT SINGLE *
    FROM pa0002
    INTO ls_p0002
    WHERE pernr = lv_pernr.

  SELECT SINGLE *
    FROM pa0006
    INTO ls_p0006
    WHERE pernr = lv_pernr.

* set PERNR
  lo_el_node->set_attribute(
    name =  'MATRICULA'
    value = lv_pernr ).

* set NOME
  lo_el_node->set_attribute(
    name =  'NOME'
    value = ls_p0002-cname ).

* set CEP
  lo_el_node->set_attribute(
    name =  'CEP'
    value = ls_p0006-pstlz ).

* set LOGRA
  lo_el_node->set_attribute(
    name =  'LOGRA'
    value = ls_p0006-stras ).

* set NUMER
  lo_el_node->set_attribute(
    name =  'NUMERO'
    value = ls_p0006-hsnmr ).

* set POSTA
  lo_el_node->set_attribute(
    name =  'COMPLEMENTO'
    value = ls_p0006-posta ).

* set BAIRRO
  lo_el_node->set_attribute(
    name =  'BAIRRO'
    value = ls_p0006-ort02 ).

* set CIDADE
  lo_el_node->set_attribute(
    name =  'CIDADE'
    value = ls_p0006-ort01 ).

* set ESTADO
  lo_el_node->set_attribute(
    name =  'ESTADO'
    value = ls_p0006-state ).

*     Estrutura para comparação
*------------------------------------------------------
  wd_this->ms_zdesafios01-matricula   = lv_pernr      .
  wd_this->ms_zdesafios01-nome        = ls_p0002-cname.
  wd_this->ms_zdesafios01-cep         = ls_p0006-pstlz.
  wd_this->ms_zdesafios01-logra       = ls_p0006-stras.
  wd_this->ms_zdesafios01-numero      = ls_p0006-hsnmr.
  wd_this->ms_zdesafios01-complemento = ls_p0006-posta.
  wd_this->ms_zdesafios01-bairro      = ls_p0006-ort02.
  wd_this->ms_zdesafios01-cidade      = ls_p0006-ort01.
  wd_this->ms_zdesafios01-estado      = ls_p0006-state.

ENDMETHOD.