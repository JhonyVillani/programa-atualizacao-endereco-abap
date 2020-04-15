*&---------------------------------------------------------------------*
*&  Include           ZDESAFIO_JM_C01
*&---------------------------------------------------------------------*

CLASS lcl_atualiza DEFINITION.
  PUBLIC SECTION.

    TYPES:
           BEGIN OF ty_s_saida,
             checkbox    TYPE checkbox,
             matricula   TYPE p0001-pernr,
             empresa     TYPE p0001-bukrs,
             nome        TYPE p0002-cname,
             dt_atualiza TYPE zdesafiode03_jm, "Data de Atualização
             sts         TYPE icon_d,          "Ícone Aprovado
             dt_aprova   TYPE zdesafiode05_jm, "Data da Aprovação
             button      TYPE string,
           END OF ty_s_saida.

    "Tabela e estrutura de saída
    DATA: mt_saida TYPE TABLE OF ty_s_saida,
          ms_saida TYPE ty_s_saida.

    "Tabela para captura do Fieldcat
    DATA: mt_zdesafiot01 TYPE TABLE OF zdesafiot01_jm,
          ms_zdesafiot01 TYPE zdesafiot01_jm.

    "Estrutura do FieldCat
    DATA: mt_fcat TYPE lvc_t_fcat,
          ms_fcat TYPE lvc_s_fcat.

    METHODS:
      constructor,
      processa,
      exibe,
      verifica,
      build_fieldcatlog,
      display_alv,
      popula_tela
        CHANGING
          cv_cep_campo         TYPE char100
          cv_logra_campo       TYPE char100
          cv_numero_campo      TYPE char100
          cv_complemento_campo TYPE char100
          cv_bairro_campo      TYPE char100
          cv_cidade_campo      TYPE char100
          cv_estado_campo      TYPE char100
          cv_matricula_campo   TYPE char100
          cv_nome_campo        TYPE char100,
      aprovar,
      rejeitar,
      mail
        IMPORTING
          is_saida       TYPE ty_s_saida.
  PRIVATE SECTION.

    METHODS:
      valida_status
        IMPORTING
          iv_zdesafiot01 TYPE zdesafiot01_jm-status.

ENDCLASS.                    "lcl_atualiza DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_atualiza IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_atualiza IMPLEMENTATION.
  METHOD constructor.

    SELECT *
      FROM zdesafiot01_jm
      INTO TABLE mt_zdesafiot01.

  ENDMETHOD.                    "constructor

  METHOD processa.

    rp_provide_from_last p0001 space pn-begda pn-endda.
    rp_provide_from_last p0002 space pn-begda pn-endda.

    "Loop na tabela de dados populada pela Web Dynpro
    LOOP AT mt_zdesafiot01 INTO ms_zdesafiot01.

      "Verifica se o filtro STATUS foi preenchido
      IF so_sts EQ 'APROVADO' AND ms_zdesafiot01-status EQ abap_false.
        CONTINUE.
      ENDIF.

      IF so_sts EQ 'N APROVADO' AND ms_zdesafiot01-status EQ abap_true.
        CONTINUE.
      ENDIF.

      "Verifica se a matrícula do loop é a mesma do PNPCE
      IF ms_zdesafiot01-matricula EQ p0001-pernr.

        ms_saida-matricula   = ms_zdesafiot01-matricula   .
        ms_saida-empresa     = p0001-bukrs                .
        ms_saida-nome        = ms_zdesafiot01-nome        .
        ms_saida-dt_atualiza = ms_zdesafiot01-dt_atualiza .

        "Verifica se o status está OK, e converte em ícone
*        IF ms_zdesafiot01-flag EQ abap_true.
        IF ms_zdesafiot01-status EQ 'APROVADO'.
          ms_saida-sts      = icon_led_green.
        ELSE.
          ms_saida-sts      = icon_led_red.
        ENDIF.
        ms_saida-dt_aprova   = ms_zdesafiot01-dt_aprova   .
        ms_saida-button = '@10@'.

        APPEND ms_saida TO mt_saida.
        CLEAR ms_saida.
      ENDIF.
    ENDLOOP.

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

  METHOD verifica.

*     Verifica se a tabela está vazia e retorna para a tela de seleção
*---------------------------------------------------------------------
    IF mt_saida IS INITIAL.
      MESSAGE s208(00) WITH text-m01 DISPLAY LIKE 'E'.

      "Retorna à tela de seleção
      LEAVE LIST-PROCESSING.
    ENDIF.

  ENDMETHOD.                    "verifica

  METHOD valida_status.

*    IF so_sts EQ 'APROVA'.
*      IF iv_zdesafiot01 = abap_false.
*        CONTINUE.
*      ENDIF.

  ENDMETHOD.                    "valida_status

  METHOD build_fieldcatlog.
*    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
*      EXPORTING
*        i_structure_name       = 'ZDESAFIOS01_JM'
*      CHANGING
*        ct_fieldcat            = mt_fcat
*      EXCEPTIONS
*        inconsistent_interface = 1
*        program_error          = 2
*        OTHERS                 = 3.
*    IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    ENDIF.

*   Build field catalog
    ms_fcat-fieldname  = 'CHECKBOX'.
    ms_fcat-scrtext_m  = 'Selecionar'.
    ms_fcat-col_pos    = 1.
    ms_fcat-checkbox   = 'X'.
    ms_fcat-edit       = 'X'.
    APPEND ms_fcat TO mt_fcat.
    CLEAR ms_fcat.

    ms_fcat-fieldname  = 'MATRICULA'.
    ms_fcat-scrtext_m  = 'Nº Pessoal'.
    ms_fcat-col_pos    = 2.
    APPEND ms_fcat TO mt_fcat.
    CLEAR ms_fcat.

    ms_fcat-fieldname  = 'NOME'.
    ms_fcat-scrtext_m  = 'Nome do Colaborador'.
    ms_fcat-col_pos    = 3.
    ms_fcat-col_opt    = 'X'.
    APPEND ms_fcat TO mt_fcat.
    CLEAR ms_fcat.

    ms_fcat-fieldname  = 'EMPRESA'.
    ms_fcat-scrtext_m  = 'Empresa'.
    ms_fcat-col_pos    = 4.
    APPEND ms_fcat TO mt_fcat.
    CLEAR ms_fcat.

    ms_fcat-fieldname  = 'DT_ATUALIZA'.
    ms_fcat-scrtext_m  = 'Data Atualização'.
    ms_fcat-col_pos    = 5.
    ms_fcat-col_opt    = 'X'.
    APPEND ms_fcat TO mt_fcat.
    CLEAR ms_fcat.

    ms_fcat-fieldname  = 'STS'.
    ms_fcat-scrtext_m  = 'Status Aprovação'.
    ms_fcat-col_pos    = 6.
    ms_fcat-col_opt    = 'X'.
    APPEND ms_fcat TO mt_fcat.
    CLEAR ms_fcat.

    ms_fcat-fieldname  = 'DT_APROVA'.
    ms_fcat-scrtext_m  = 'Data Aprovação'.
    ms_fcat-col_pos    = 7.
    ms_fcat-col_opt    = 'X'.
    APPEND ms_fcat TO mt_fcat.
    CLEAR ms_fcat.

    ms_fcat-fieldname  = 'BUTTON'.
    ms_fcat-scrtext_m  = 'Detalhes'.
    ms_fcat-col_pos    = 8.
    ms_fcat-style      = cl_gui_alv_grid=>mc_style_button.
    APPEND ms_fcat TO mt_fcat.
    CLEAR ms_fcat.

  ENDMETHOD.                    "build_fieldcatlog

  METHOD display_alv.

    IF go_grid IS INITIAL.

* 1.  CREATE container instance
      CREATE OBJECT go_container_100
        EXPORTING
          container_name = 'ALV'.

* 2. Create ALV grid instance by using the container instance
      CREATE OBJECT go_grid
        EXPORTING
          i_parent = go_container_100.

* 3. Build Field Catlog
      go_atualiza->build_fieldcatlog( ).

      SET HANDLER gr_event_handler->handle_button_click FOR go_grid .

* 4. Call the ALV
      CALL METHOD go_grid->set_table_for_first_display
        CHANGING
          it_outtab                     = mt_saida
          it_fieldcatalog               = mt_fcat
        EXCEPTIONS
          invalid_parameter_combination = 1
          program_error                 = 2
          too_many_lines                = 3
          OTHERS                        = 4.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      go_grid->refresh_table_display( ).

    ELSE.
      "Se o alv já tiver sido criado
      go_grid->refresh_table_display( ).

    ENDIF.

  ENDMETHOD.                    "display_alv

  METHOD popula_tela.

    DATA: ls_aprova TYPE zdesafiot01_jm.
    DATA: lt_sel_cells TYPE lvc_t_cell.
    DATA: ls_sel_cell TYPE lvc_s_cell.

    go_grid->get_selected_cells(
        IMPORTING
            et_cell = lt_sel_cells ).

    READ TABLE lt_sel_cells INTO ls_sel_cell WITH KEY col_id-fieldname = 'BUTTON'.

    READ TABLE mt_zdesafiot01 INTO ls_aprova INDEX ls_sel_cell-row_id.

    cv_cep_campo          = ls_aprova-cep.
    cv_logra_campo        = ls_aprova-logra.
    cv_numero_campo       = ls_aprova-numero.
    cv_complemento_campo  = ls_aprova-complemento.
    cv_bairro_campo       = ls_aprova-bairro.
    cv_cidade_campo       = ls_aprova-cidade.
    cv_estado_campo       = ls_aprova-estado.
    cv_matricula_campo    = ls_aprova-matricula.
    cv_nome_campo         = ls_aprova-nome.

  ENDMETHOD.                    "popula_tela

  METHOD aprovar.

    DATA: ls_return TYPE bapireturn1,
          ls_key    TYPE bapipakey,
          ls_p0006  TYPE p0006,
          ls_pa0006 TYPE pa0006.

    "Verifica se houve mudança na tela
    go_grid->check_changed_data( ).

    "Loop na tabela do ALV
    LOOP AT mt_saida INTO ms_saida.

      "Se o Checkbox do ALV foi selecionado
      IF ms_saida-checkbox IS NOT INITIAL.

        "Faz a leitura da tabela gerada pela Dynpro
        CLEAR ms_zdesafiot01.
        READ TABLE mt_zdesafiot01 INTO ms_zdesafiot01 WITH KEY matricula = ms_saida-matricula.

        SELECT SINGLE *
         FROM pa0006
         INTO ls_pa0006
         WHERE pernr = ms_saida-matricula
           AND aedtm = ms_zdesafiot01-dt_atualiza.

        IF ls_pa0006-begda IS INITIAL.
          ls_p0006-begda = '18000101'.
        ELSE.
          ls_p0006-begda = ls_pa0006-begda.
        ENDIF.

        IF ls_pa0006-endda IS INITIAL.
          ls_p0006-endda = '99991231'.
        ELSE.
          ls_p0006-endda = ls_pa0006-endda.
        ENDIF.

        ls_p0006-pernr = ms_zdesafiot01-matricula.
        ls_p0006-infty = '0006'.
        ls_p0006-subty = '1'.
        ls_p0006-pstlz = ms_zdesafiot01-cep.
        ls_p0006-stras = ms_zdesafiot01-logra.
        ls_p0006-hsnmr = ms_zdesafiot01-numero.
        ls_p0006-posta = ms_zdesafiot01-complemento.
        ls_p0006-ort02 = ms_zdesafiot01-bairro.
        ls_p0006-ort01 = ms_zdesafiot01-cidade.
        ls_p0006-state = ms_zdesafiot01-estado.
        ls_p0006-aedtm = ms_zdesafiot01-dt_atualiza.

        CALL FUNCTION 'HR_EMPLOYEE_ENQUEUE'
          EXPORTING
            number = ls_p0006-pernr
          IMPORTING
            return = ls_return.

        CALL FUNCTION 'HR_INFOTYPE_OPERATION'
          EXPORTING
            infty         = '0006'
            number        = ls_p0006-pernr
            subtype       = '1'
            validityend   = ls_p0006-endda
            validitybegin = ls_p0006-begda
            record        = ls_p0006
            operation     = 'INS'
          IMPORTING
            return        = ls_return
            key           = ls_key.

        IF sy-subrc = 0.
          MESSAGE s208(00) WITH text-t03 DISPLAY LIKE 'S'.
        ENDIF.

        CALL FUNCTION 'HR_EMPLOYEE_DEQUEUE'
          EXPORTING
            number = ls_p0006-pernr
          IMPORTING
            return = ls_return.

        "Atualiza a tabela de cadastros
        ms_zdesafiot01-status = 'APROVADO'.
        ms_zdesafiot01-dt_aprova = sy-datum.
        UPDATE zdesafiot01_jm FROM ms_zdesafiot01.

        "Atualiza o ALV GRID
        ms_saida-sts       = icon_led_green.
        ms_saida-dt_aprova = sy-datum.
        MODIFY mt_saida FROM ms_saida.

        go_grid->refresh_table_display( ).

      ENDIF.

      CLEAR: ls_p0006,
             ls_pa0006.

    ENDLOOP.

  ENDMETHOD.                    "aprovar

  METHOD rejeitar.

    DATA: ls_pa0105        TYPE pa0105,
          ls_email_assunto TYPE sodocchgi1,
          lt_email_recebe  TYPE TABLE OF somlreci1,
          ls_email_recebe  TYPE somlreci1,
          lt_email_txt     TYPE TABLE OF solisti1,
          ls_email_txt     TYPE solisti1.

    IF go_grid IS NOT INITIAL.

      go_grid->check_changed_data( ).

      "Loop na tabela do ALV
      LOOP AT mt_saida INTO ms_saida.

        IF ms_saida-checkbox IS INITIAL.
          CONTINUE.
        ENDIF.

        READ TABLE mt_zdesafiot01 INTO ms_zdesafiot01 WITH KEY matricula = ms_saida-matricula
                                                             dt_atualiza = ms_saida-dt_atualiza.

*        ms_zdesafiot01-status = 'N APROVADO'.

        UPDATE zdesafiot01_jm
            SET status        = 'N APROVADO'
                dt_aprova     = space
            WHERE matricula   = ms_saida-matricula         AND
                  cep         = ms_zdesafiot01-cep         AND
                  logra       = ms_zdesafiot01-logra       AND
                  numero      = ms_zdesafiot01-numero      AND
                  complemento = ms_zdesafiot01-complemento AND
                  bairro      = ms_zdesafiot01-bairro      AND
                  cidade      = ms_zdesafiot01-cidade      AND
                  estado      = ms_zdesafiot01-estado      AND
                  dt_atualiza = ms_zdesafiot01-dt_atualiza.

*        ms_saida-status     = lv_icon_reject.
        ms_saida-sts         = '@5C@'.
        ms_saida-dt_atualiza = space.

        "Atualiza o ALV GRID
        ms_saida-sts       = icon_led_red.
        ms_saida-dt_aprova = space.
        MODIFY mt_saida FROM ms_saida.

        go_grid->refresh_table_display( ).

        me->mail(
          EXPORTING
            is_saida     = ms_saida ).

      ENDLOOP.

    ENDIF.

  ENDMETHOD.                    "rejeitar

  METHOD mail.

    "Declarações necessárias para envio de e-mail na transação SOST
    DATA: ls_pa0105        TYPE pa0105,
          ls_email_assunto TYPE sodocchgi1,
          lt_email_recebe  TYPE TABLE OF somlreci1,
          ls_email_recebe  TYPE somlreci1,
          lt_email_txt     TYPE TABLE OF solisti1,
          ls_email_txt     TYPE solisti1.

    SELECT SINGLE *
      FROM pa0105
      INTO ls_pa0105
      WHERE  pernr = is_saida-matricula
      AND    subty = '0010'.

    ls_email_recebe-receiver   = ls_pa0105-usrid_long.
    ls_email_recebe-rec_type   = 'U'. "Usuário
    ls_email_recebe-no_print   = 'X'. "Não permite imprimir
    ls_email_recebe-notif_del  = 'X'. "Notifica de exclusão
    ls_email_recebe-notif_read = 'X'. "Notificação de leitura
    APPEND ls_email_recebe TO lt_email_recebe.
    CLEAR  ls_email_recebe .

    ls_email_assunto-obj_name   = 'TITLE'.
    ls_email_assunto-obj_langu  = sy-langu.
    ls_email_assunto-obj_descr  = 'Atualização Cadastral Negada'. "Título do e-mail
    ls_email_assunto-sensitivty = 'P'.
    ls_email_txt = 'Seus dados não foram aprovados, entre em contato com o RH.'.
    APPEND ls_email_txt TO lt_email_txt.
    CLEAR ls_email_txt.

    ls_email_txt = 'Acesse o link para atualizar seus dados: http://srvux102.basisoneit.com.br:8000/sap/bc/webdynpro/sap/zdesafioweb_jm?sap-language=PT'.
    APPEND ls_email_txt TO lt_email_txt.
    CLEAR ls_email_txt.

    CALL FUNCTION 'SO_NEW_DOCUMENT_SEND_API1'
      EXPORTING
        document_data              = ls_email_assunto
        put_in_outbox              = 'X'
        commit_work                = 'X'
      TABLES
        object_content             = lt_email_txt
        receivers                  = lt_email_recebe
      EXCEPTIONS
        too_many_receivers         = 1
        document_not_sent          = 2
        document_type_not_exist    = 3
        operation_no_authorization = 4
        parameter_error            = 5
        x_error                    = 6
        enqueue_error              = 7
        OTHERS                     = 8.

    IF sy-subrc EQ 0.
      SUBMIT rsconn01 WITH mode = 'INT' AND RETURN.
    ENDIF.

  ENDMETHOD.                    "email

ENDCLASS.                    "lcl_atualiza IMPLEMENTATION