METHOD onactionact_save .

  DATA ls_saida TYPE zdesafiot01_jm.
  DATA lv_flag  TYPE flag.

  DATA lo_nd_node TYPE REF TO if_wd_context_node.

  DATA lo_el_node TYPE REF TO if_wd_context_element.
  DATA ls_node    TYPE wd_this->element_node.

* get message manager
  DATA lo_api_controller     TYPE REF TO if_wd_controller.
  DATA lo_message_manager    TYPE REF TO if_wd_message_manager.

* navigate from <CONTEXT> to <NODE> via lead selection
  lo_nd_node = wd_context->get_child_node( name = wd_this->wdctx_node ).

* get element via lead selection
  lo_el_node = lo_nd_node->get_element( ).
* @TODO handle not set lead selection
  IF lo_el_node IS INITIAL.
  ENDIF.

* get all declared attributes
  lo_el_node->get_static_attributes(
    IMPORTING
      static_attributes = ls_node ).

  IF ls_node-flag EQ abap_false.

*     Validações de campos obrigatórios
*----------------------------------------------------------
    IF ls_node-cep IS INITIAL.

      lo_api_controller ?= wd_this->wd_get_api( ).

      CALL METHOD lo_api_controller->get_message_manager
        RECEIVING
          message_manager = lo_message_manager.

* report message
      CALL METHOD lo_message_manager->report_error_message
        EXPORTING
          message_text = 'O campo CEP é obrigatório'.
      EXIT.
    ENDIF.

    IF ls_node-logra IS INITIAL.

      lo_api_controller ?= wd_this->wd_get_api( ).

      CALL METHOD lo_api_controller->get_message_manager
        RECEIVING
          message_manager = lo_message_manager.

* report message
      CALL METHOD lo_message_manager->report_error_message
        EXPORTING
          message_text = 'O campo LOGRADOURO é obrigatório'.
      EXIT.
    ENDIF.

    IF ls_node-numero IS INITIAL.

      lo_api_controller ?= wd_this->wd_get_api( ).

      CALL METHOD lo_api_controller->get_message_manager
        RECEIVING
          message_manager = lo_message_manager.

* report message
      CALL METHOD lo_message_manager->report_error_message
        EXPORTING
          message_text = 'O campo NÚMERO é obrigatório'.
      EXIT.
    ENDIF.

    IF ls_node-bairro IS INITIAL.

      lo_api_controller ?= wd_this->wd_get_api( ).

      CALL METHOD lo_api_controller->get_message_manager
        RECEIVING
          message_manager = lo_message_manager.

* report message
      CALL METHOD lo_message_manager->report_error_message
        EXPORTING
          message_text = 'O campo BAIRRO é obrigatório'.
      EXIT.
    ENDIF.

    IF ls_node-cidade IS INITIAL.

      lo_api_controller ?= wd_this->wd_get_api( ).

      CALL METHOD lo_api_controller->get_message_manager
        RECEIVING
          message_manager = lo_message_manager.

* report message
      CALL METHOD lo_message_manager->report_error_message
        EXPORTING
          message_text = 'O campo CIDADE é obrigatório'.
      EXIT.
    ENDIF.

    IF ls_node-estado IS INITIAL.

      lo_api_controller ?= wd_this->wd_get_api( ).

      CALL METHOD lo_api_controller->get_message_manager
        RECEIVING
          message_manager = lo_message_manager.

* report message
      CALL METHOD lo_message_manager->report_error_message
        EXPORTING
          message_text = 'O campo ESTADO é obrigatório'.
      EXIT.
    ENDIF.

*     Verifica se há mudança entre o ultimo registro no infotipo
*--------------------------------------------------------------------
    IF ls_node-matricula   EQ wd_this->ms_zdesafios01-matricula   AND
       ls_node-nome        EQ wd_this->ms_zdesafios01-nome        AND
       ls_node-cep         EQ wd_this->ms_zdesafios01-cep         AND
       ls_node-logra       EQ wd_this->ms_zdesafios01-logra       AND
       ls_node-numero      EQ wd_this->ms_zdesafios01-numero      AND
       ls_node-complemento EQ wd_this->ms_zdesafios01-complemento AND
       ls_node-bairro      EQ wd_this->ms_zdesafios01-bairro      AND
       ls_node-cidade      EQ wd_this->ms_zdesafios01-cidade      AND
       ls_node-estado      EQ wd_this->ms_zdesafios01-estado.

      lo_api_controller ?= wd_this->wd_get_api( ).

      CALL METHOD lo_api_controller->get_message_manager
        RECEIVING
          message_manager = lo_message_manager.

* report message
      CALL METHOD lo_message_manager->report_error_message
        EXPORTING
          message_text = 'Não há dados a serem modificados!'.
      EXIT.

    ENDIF.

*     Validando se já foi enviado dados ao RH
*--------------------------------------------------------
    wd_this->check_table(
    IMPORTING
      ev_exists = lv_flag ).

    IF lv_flag = abap_true.

      lo_api_controller ?= wd_this->wd_get_api( ).

      CALL METHOD lo_api_controller->get_message_manager
        RECEIVING
          message_manager = lo_message_manager.

* report message
      CALL METHOD lo_message_manager->report_error_message
        EXPORTING
          message_text = 'Seus dados atualizados já foram enviados, aguarde o RH!'.
      EXIT.

    ENDIF.

*     Atribuições à saída
*-----------------------------------------------
    ls_saida-matricula    = ls_node-matricula.
    ls_saida-nome         = ls_node-nome.
    ls_saida-cep          = ls_node-cep.
    ls_saida-logra        = ls_node-logra.
    ls_saida-numero       = ls_node-numero.
    ls_saida-complemento  = ls_node-complemento.
    ls_saida-bairro       = ls_node-bairro.
    ls_saida-cidade       = ls_node-cidade.
    ls_saida-estado       = ls_node-estado.
    ls_saida-dt_atualiza  = sy-datum.

    MODIFY zdesafiot01_jm FROM ls_saida.

    lo_api_controller ?= wd_this->wd_get_api( ).

    CALL METHOD lo_api_controller->get_message_manager
      RECEIVING
        message_manager = lo_message_manager.

* Mensagem de sucesso.
    CALL METHOD lo_message_manager->report_success
      EXPORTING
        message_text = 'Atualização cadastrada com sucesso!'.
  ELSE.

    lo_api_controller ?= wd_this->wd_get_api( ).

    CALL METHOD lo_api_controller->get_message_manager
      RECEIVING
        message_manager = lo_message_manager.

* report message
    CALL METHOD lo_message_manager->report_error_message
      EXPORTING
        message_text = ' Não existem dados para serem atualizados !'.

    EXIT.

  ENDIF.

ENDMETHOD.