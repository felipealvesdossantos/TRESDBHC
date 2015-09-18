-- Gerado por Oracle SQL Developer Data Modeler 4.1.1.888
--   em:        2015-09-14 16:47:38 BRT
--   site:      Oracle Database 11g
--   tipo:      Oracle Database 11g

-- 1 função que diz se hoje e dia de analise de um determinado cliente.
CREATE OR REPLACE FUNCTION tresdbhc.capturaFrenqMonitor(v_input varchar2) RETURN NUMBER
IS
  --v_input varchar2(4000) := 'seg,qua,sex';
  v_count binary_integer;
  v_array dbms_utility.lname_array;
  v_hoje char(3);
  v_retorno number := 0;
begin
  -- se o input for nulo sigifica que precisa ser analiado todo dia
  if v_input is null then
    v_retorno := 1;
  --checar se é dia 20
  elsif v_input = 'dia 20' then
    select to_char(sysdate, 'dd') into v_hoje from dual;
    if v_hoje = '20' then
      v_retorno := 1;
    end if;
  else
    --pega o nome do dia da semana
    select to_char(sysdate, 'dy') into v_hoje from dual;
  
    dbms_utility.comma_to_table( list   => v_input, tablen => v_count, tab    => v_array);
    dbms_output.put_line(v_count);
    for i in 1 .. v_count
    loop
      dbms_output.put_line( 'Elemento ' || to_char(i) ||' do array: ' ||v_array(i));
      
      if v_array(i) = v_hoje then
        v_retorno := 1;
      end if;
      
    end loop;
  end if;
  return v_retorno;
end;
/

--#####################################################################################################

-- 2 função que envia email das analises ja realizadas
create or replace function enviaEmailAnaliseCliente
(p_id_relatorio number)
return varchar2
is
  v_EMAIL_RESPONSAVEL_BANCO varchar2(300);
begin
  select c.EMAIL_RESPONSAVEL_BANCO
  into v_EMAIL_RESPONSAVEL_BANCO
  from relatorio_diario rd, clientes c
  where rd.servidor = c.servidor
  and    rd.cliente = c.cliente
  and    rd.id_relatorio = p_id_relatorio;

return(v_EMAIL_RESPONSAVEL_BANCO);
EXCEPTION
   WHEN OTHERS THEN
      return('suporte@3db.net.br');
END;

--#####################################################################################################

-- 3 função que gera o corpo do email que sera enviado para o cliente
create or replace function geraCorpoEmailAnalise
(p_id_relatorio number)
return varchar2
is
v_CLIENTE varchar2(255);
v_responsavel_analise varchar2(50);
v_DATA_ANALISE varchar2(30);
v_servidor varchar2(50);
v_nome_banco varchar2(300);
v_analise varchar2(4000);

v_html_email varchar2(32767);

begin

SELECT 
  rd.CLIENTE,
  c.responsavel_analise,
  to_char(rd.DATA_ANALISE, 'DD/MM/YYYY HH24:MI') DATA_ANALISE,
  rd.servidor,
  rd.nome_banco,
  rd.analise
INTO
	v_cliente,
	v_responsavel_analise,
	v_data_analise,
	v_servidor,
	v_nome_banco,
	v_analise
FROM relatorio_diario rd,
  clientes c
WHERE rd.servidor = c.servidor
AND rd.cliente    = c.cliente
AND ID_RELATORIO  = p_id_relatorio;

v_html_email:='
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
<style type="text/css">
<!--
.style3 {color: #FF0000; font-weight: bold; }
.style4 {font-size: small}
-->
</style>
</head>
<body>
<p>Caro senhor gestor, abaixo encontra-se o laudo emitido pela <span class="style3"><a href="http://www.3db.net.br">3DB Consultoria</a></span> conforme contratado. </p>
<table width="100%" border="1" bgcolor="#F0F0F0">
  <tr>
    <th scope="row"><div align="left"><span class="style3">Cliente:</span></div></th>
    <td>'||v_cliente||'</td>
  </tr>
  <tr>
    <th scope="row"><div align="left"><span class="style3">Respons&aacute;vel an&aacute;lise:</span></div></th>
    <td>'||v_responsavel_analise||'</td>
  </tr>
  <tr>
    <th scope="row"><div align="left"><span class="style3">Data da an&aacute;lise:</span></div></th>
    <td>'||v_data_analise||'</td>
  </tr>
  <tr>
    <th scope="row"><div align="left"><span class="style3">Servidor: </span></div></th>
    <td>'||v_servidor||'</td>
  </tr>
  <tr>
    <th scope="row"><div align="left"><span class="style3">Banco: </span></div></th>
    <td>'||v_nome_banco||'</td>
  </tr>    
  <tr>
    <th scope="row"><div align="left"><span class="style3">Laudo:</span></div></th>
    <td>'||v_analise||'</td>
  </tr>
</table>
<p class="style4">Para ver todos os dados da an&aacute;lise acesse nosso <a href="http://3db.net.br:8080/apex/f?p=104">Sistema de Monitoramento Di&aacute;rio</a>.</p>
<p class="style4">Caso precise de alguma ajuda abra um chamado atrav&eacute;s <a href="http://portaldocliente.3db.net.br">do link</a> ou  do email <a href="mailto:suporte@3db.net.br">suporte@3db.net.br</a> </p>
<p class="style4">Voc&ecirc; est&aacute; recebendo esse email porque est&aacute; cadastrado em nosso sistema como respons&aacute;vel pelo banco de dados, caso n&atilde;o seja a pessoa correta entre em contato com nossa &aacute;rea administrativa atrav&eacute;s do email <a href="mailto:atendimento@3db.net.br">atendimento@3db.net.br</a> ou pelo telefone (62)  3642-0201. </p>
</body>
</html>
';
return (replace(v_html_email,CHR(10),UTL_TCP.CRLF));
EXCEPTION
   WHEN OTHERS THEN
      return('0');
end;