-- Gerado por Oracle SQL Developer Data Modeler 4.1.1.888
--   em:        2015-09-14 16:47:38 BRT
--   site:      Oracle Database 11g
--   tipo:      Oracle Database 11g

-- 1 procedure que envia todos os emails das analises realizadas que ainda nao foram enviadas para os clientes
create or replace procedure enviaTodosEmailsAnalises
is
cursor cur_caixa_saida is 
  select id_email, id_relatorio, cliente, responsavel_analise, data_analise, servidor, 
  nome_banco, NOME_RESPONSAVEL_BANCO, EMAIL_RESPONSAVEL_BANCO,corpo_email
  from caixa_de_saida_completa
  where EMAIL_RESPONSAVEL_BANCO is not null 
  and CORPO_EMAIL <> '0';

begin

for rec_caixa_saida in cur_caixa_saida loop
  SEND_MAIL_HTML(p_to=>rec_caixa_saida.EMAIL_RESPONSAVEL_BANCO, p_html_msg=>rec_caixa_saida.corpo_email, 
                p_id_email=>rec_caixa_saida.id_email);
end loop;

end;

--#####################################################################################################

-- 2 procedure que formata em html o email da analise que sera enviada
create or replace procedure formataHtmlEmail(
    p_to            in varchar2,
    p_from          in varchar2 DEFAULT 'monitoramento@3db.net.br',
    p_subject       in varchar2 DEFAULT '3DB Consultoria - Laudo do monitoramento diário',
    p_text          in varchar2 default null,
    p_html          in varchar2 default null,
    p_smtp_hostname in varchar2 DEFAULT 'localhost',
    p_smtp_portnum  in varchar2 DEFAULT '25')
is
    l_boundary      varchar2(255) default 'a1b2c3d4e3f2g1';
    l_connection    utl_smtp.connection;
    l_body_html     clob := empty_clob;  --This LOB will be the email message
    l_offset        number;
    l_ammount       number;
    l_temp          varchar2(32767) default null;
begin
    l_connection := utl_smtp.open_connection( p_smtp_hostname, p_smtp_portnum );
    utl_smtp.helo( l_connection, p_smtp_hostname );
    utl_smtp.mail( l_connection, p_from );
    utl_smtp.rcpt( l_connection, p_to );

    l_temp := l_temp || 'MIME-Version: 1.0' ||  chr(13) || chr(10);
    l_temp := l_temp || 'To: ' || p_to || chr(13) || chr(10);
    l_temp := l_temp || 'From: ' || p_from || chr(13) || chr(10);
    l_temp := l_temp || 'Subject: ' || p_subject || chr(13) || chr(10);
    l_temp := l_temp || 'Reply-To: ' || p_from ||  chr(13) || chr(10);
    l_temp := l_temp || 'Content-Type: multipart/alternative; boundary=' || 
                         chr(34) || l_boundary ||  chr(34) || chr(13) || 
                         chr(10);

    ----------------------------------------------------
    -- Write the headers
    dbms_lob.createtemporary( l_body_html, false, 10 );
    dbms_lob.write(l_body_html,length(l_temp),1,l_temp);


    ----------------------------------------------------
    -- Write the text boundary
    l_offset := dbms_lob.getlength(l_body_html) + 1;
    l_temp   := '--' || l_boundary || chr(13)||chr(10);
    l_temp   := l_temp || 'content-type: text/plain; charset=us-ascii' || 
                  chr(13) || chr(10) || chr(13) || chr(10);
    dbms_lob.write(l_body_html,length(l_temp),l_offset,l_temp);

    ----------------------------------------------------
    -- Write the plain text portion of the email
    --l_offset := dbms_lob.getlength(l_body_html) + 1;
    --dbms_lob.write(l_body_html,length(p_text),l_offset,p_text);

    ----------------------------------------------------
    -- Write the HTML boundary
    l_temp   := chr(13)||chr(10)||chr(13)||chr(10)||'--' || l_boundary || 
                    chr(13) || chr(10);
    l_temp   := l_temp || 'content-type: text/html;' || 
                   chr(13) || chr(10) || chr(13) || chr(10);
    l_offset := dbms_lob.getlength(l_body_html) + 1;
    dbms_lob.write(l_body_html,length(l_temp),l_offset,l_temp);

    ----------------------------------------------------
    -- Write the HTML portion of the message
    l_offset := dbms_lob.getlength(l_body_html) + 1;
    dbms_lob.write(l_body_html,length(p_html),l_offset,p_html);

    ----------------------------------------------------
    -- Write the final html boundary
    l_temp   := chr(13) || chr(10) || '--' ||  l_boundary || '--' || chr(13);
    l_offset := dbms_lob.getlength(l_body_html) + 1;
    dbms_lob.write(l_body_html,length(l_temp),l_offset,l_temp);


    ----------------------------------------------------
    -- Send the email in 1900 byte chunks to UTL_SMTP
    l_offset  := 1;
    l_ammount := 1900;
    utl_smtp.open_data(l_connection);
    while l_offset < dbms_lob.getlength(l_body_html) loop
        utl_smtp.write_data(l_connection,
                            dbms_lob.substr(l_body_html,l_ammount,l_offset));
        l_offset  := l_offset + l_ammount ;
        l_ammount := least(1900,dbms_lob.getlength(l_body_html) - l_ammount);
    end loop;
    utl_smtp.close_data(l_connection);
    utl_smtp.quit( l_connection );
    dbms_lob.freetemporary(l_body_html);
end;

--#####################################################################################################

-- 3 procedure que move os emails ja enviados para a caixa de saida de enviados
create or replace procedure moveParaItensEnviados 
(
p_id_email in number,
p_enviado_sucesso in char default null,
p_cod_erro in number default null,
p_mesg_erro in varchar2 default null
)

is
cursor cur_caixa_saida is 
  select id_relatorio, criacao_mensagem
  from caixa_de_saida
  where id_email = p_id_email;

begin

for rec_caixa_saida in cur_caixa_saida loop
  insert into itens_enviados(id_email, id_relatorio, enviado_c_sucesso, criacao_mensagem, data_hora_envio,cod_erro,mensagem_erro)
  values (p_id_email, rec_caixa_saida.id_relatorio, p_enviado_sucesso, rec_caixa_saida.criacao_mensagem, SYSDATE, p_cod_erro, p_mesg_erro);
  delete from caixa_de_saida where id_email = p_id_email;
  commit;
end loop;

end;

--#####################################################################################################

-- 4 Procedure que envia o email em formato html da analise realizada para o cliente
create or replace PROCEDURE sendMailHtml (p_to   IN VARCHAR2,
                                       p_from      IN VARCHAR2 DEFAULT 'monitoramento@3db.net.br',
                                       p_subject   IN VARCHAR2 DEFAULT '3DB Consultoria - Laudo do monitoramento diário',
                                       p_text_msg  IN VARCHAR2 DEFAULT NULL,
                                       p_html_msg  IN VARCHAR2 DEFAULT NULL,
                                       p_smtp_host IN VARCHAR2 DEFAULT 'localhost',
                                       p_smtp_port IN NUMBER DEFAULT 25,
                                       p_id_email IN NUMBER DEFAULT NULL)
AS
  l_mail_conn   UTL_SMTP.connection;
  l_boundary    VARCHAR2(50) := '----=*#abc1234321cba#*=';
  v_err_code    NUMBER;
  v_err_msg     VARCHAR2(500);
  
BEGIN
  l_mail_conn := UTL_SMTP.open_connection(p_smtp_host, p_smtp_port);
  UTL_SMTP.helo(l_mail_conn, p_smtp_host);
  UTL_SMTP.mail(l_mail_conn, p_from);
  UTL_SMTP.rcpt(l_mail_conn, p_to);

  UTL_SMTP.open_data(l_mail_conn);

  UTL_SMTP.write_data(l_mail_conn, 'Date: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') || UTL_TCP.crlf);
  UTL_SMTP.write_data(l_mail_conn, 'To: ' || p_to || UTL_TCP.crlf);
  UTL_SMTP.write_data(l_mail_conn, 'From: ' || p_from || UTL_TCP.crlf);
  UTL_SMTP.write_data(l_mail_conn, 'Subject: ' || p_subject || UTL_TCP.crlf);
  UTL_SMTP.write_data(l_mail_conn, 'Reply-To: ' || p_from || UTL_TCP.crlf);
  UTL_SMTP.write_data(l_mail_conn, 'MIME-Version: 1.0' || UTL_TCP.crlf);
  UTL_SMTP.write_data(l_mail_conn, 'Content-Type: multipart/alternative; boundary="' || l_boundary || '"' || UTL_TCP.crlf || UTL_TCP.crlf);

  IF p_text_msg IS NOT NULL THEN
    UTL_SMTP.write_data(l_mail_conn, '--' || l_boundary || UTL_TCP.crlf);
    UTL_SMTP.write_data(l_mail_conn, 'Content-Type: text/plain; charset="iso-8859-1"' || UTL_TCP.crlf || UTL_TCP.crlf);

    UTL_SMTP.write_data(l_mail_conn, p_text_msg);
    UTL_SMTP.write_data(l_mail_conn, UTL_TCP.crlf || UTL_TCP.crlf);
  END IF;

  IF p_html_msg IS NOT NULL THEN
    UTL_SMTP.write_data(l_mail_conn, '--' || l_boundary || UTL_TCP.crlf);
    UTL_SMTP.write_data(l_mail_conn, 'Content-Type: text/html; charset="iso-8859-1"' || UTL_TCP.crlf || UTL_TCP.crlf);

    UTL_SMTP.write_data(l_mail_conn, p_html_msg);
    UTL_SMTP.write_data(l_mail_conn, UTL_TCP.crlf || UTL_TCP.crlf);
  END IF;

  UTL_SMTP.write_data(l_mail_conn, '--' || l_boundary || '--' || UTL_TCP.crlf);
  UTL_SMTP.close_data(l_mail_conn);

  UTL_SMTP.quit(l_mail_conn);
  
  -- Se chegou até aqui email enviado com sucesso
  -- apaga da caixa de saida e escreve em itens enviados
  move_p_itens_enviados(p_id_email,'S');

EXCEPTION
   WHEN OTHERS THEN
      v_err_code := SQLCODE;
      v_err_msg := SQLERRM;
      move_p_itens_enviados(p_id_email,'N',v_err_code,v_err_msg);
END;