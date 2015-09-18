-- carga inicial tresdbhc

conn tresdbhc/tresdbhc;
-- 1  inserindo colaboradores
insert into colaborador(colaborador_pk,nome,funcao,telefone,celular,endereco,email, ativo) values(cliContrato_seq.nextval,'Daniel Brasil','Gerente de Tecnologia','6232210201','6292000000','avenida 85','daniel.brasil@3db.net.br',1);
insert into colaborador(colaborador_pk,nome,funcao,telefone,celular,endereco,email, ativo) values(cliContrato_seq.nextval,'Rogerio Di Magalhaes','Gerente Comercial','6232210201','6292000000','avenida 85','rogerio.dmagalhaes@3db.net.br',1);
insert into colaborador(colaborador_pk,nome,funcao,telefone,celular,endereco,email, ativo) values(cliContrato_seq.nextval,'Guilherme Poli','Gerente de Tecnologia','6232210201','6292000000','avenida 85','guilherme.poli@3db.net.br',1);
insert into colaborador(colaborador_pk,nome,funcao,telefone,celular,endereco,email, ativo, gerenteid_FK) values(cliContrato_seq.nextval,'Felipe Alves','Gerente Tecnico','6232210201','6292000000','avenida 85','felipe@3db.net.br',1,(select colaborador_pk from colaborador where nome = 'Daniel Brasil'));
insert into colaborador(colaborador_pk,nome,funcao,telefone,celular,endereco,email, ativo, gerenteid_FK) values(cliContrato_seq.nextval,'Carlos Bezerra Tanaka','tecnico','6232210201','6292000000','avenida 85','carlos@3db.net.br',1,(select colaborador_pk from colaborador where nome = 'Felipe Alves'));
insert into colaborador(colaborador_pk,nome,funcao,telefone,celular,endereco,email, ativo, gerenteid_FK) values(cliContrato_seq.nextval,'Guilherme Souza','tecnico','6232210201','6292000000','avenida 85','guilherme.souza@3db.net.br',1,(select colaborador_pk from colaborador where nome = 'Felipe Alves'));
insert into colaborador(colaborador_pk,nome,funcao,telefone,celular,endereco,email, ativo, gerenteid_FK) values(cliContrato_seq.nextval,'Paulo Henrique','tecnico','6232210201','6292000000','avenida 85','paulo@3db.net.br',1,(select colaborador_pk from colaborador where nome = 'Felipe Alves'));
commit;

-- 2 inserindo informações dos contratos
alter session set NLS_DATE_FORMAT = 'DD/MM/YYYY';
insert into ClienteContrato (ClienteContrato_PK,nomeCliente,apelidoCliente,tipoContrato,modalidade,diaFaturamento,diaVencimento,codigoSuperCash,cnpj,endereco,dataVencimentoCAC)
values(cliContrato_seq.nextval,'Polipecas', 'POLIPECAS','mensal','modelo franquia horas','05/10/2105','10/10/2105',35,'000.000.000.00','T 10','30/10/2107');
insert into ClienteContrato (ClienteContrato_PK,nomeCliente,apelidoCliente,tipoContrato,modalidade,diaFaturamento,diaVencimento,codigoSuperCash,cnpj,endereco,dataVencimentoCAC)
values(cliContrato_seq.nextval,'Grupo Jaime Camara','GJC','avulso','modelo franquia horas','15/10/2105','20/10/2105',45,'000.000.000.00','T 10','30/10/2107');
insert into ClienteContrato (ClienteContrato_PK,nomeCliente,apelidoCliente,tipoContrato,modalidade,diaFaturamento,diaVencimento,codigoSuperCash,cnpj,endereco,dataVencimentoCAC)
values(cliContrato_seq.nextval,'Terral Construtora','TERRAL','mensal','modelo franquia horas','10/10/2105','15/10/2105',40,'000.000.000.00','T 10','30/10/2107');
commit;

-- 3 inserindo contatos dos contratos
insert into ContatoCliente(ContatoCliente_PK,nomeContato,funcao,telefone,email,departamento,ClienteContratoId_FK)
values(contatoCli_seq.nextval,'Joao Pereira','cio','6292000000','joao@gmail.com','ti',(select ClienteContrato_PK from ClienteContrato where apelidoCliente = 'POLIPECAS'));
insert into ContatoCliente(ContatoCliente_PK,nomeContato,funcao,telefone,email,departamento,ClienteContratoId_FK)
values(contatoCli_seq.nextval,'Pedro Jose','suporte','6292000000','pedro@gmail.com','ti',(select ClienteContrato_PK from ClienteContrato where apelidoCliente = 'POLIPECAS'));
insert into ContatoCliente(ContatoCliente_PK,nomeContato,funcao,telefone,email,departamento,ClienteContratoId_FK)
values(contatoCli_seq.nextval,'Jose Almeida','analista','6292000000','jose@gmail.com','ti',(select ClienteContrato_PK from ClienteContrato where apelidoCliente = 'GJC'));
insert into ContatoCliente(ContatoCliente_PK,nomeContato,funcao,telefone,email,departamento,ClienteContratoId_FK)
values(contatoCli_seq.nextval,'Judas dos Santos','dba','6292000000','judas@gmail.com','ti',(select ClienteContrato_PK from ClienteContrato where apelidoCliente = 'GJC'));
insert into ContatoCliente(ContatoCliente_PK,nomeContato,funcao,telefone,email,departamento,ClienteContratoId_FK)
values(contatoCli_seq.nextval,'Jairo Gomes','cio','6292000000','jairo@gmail.com','ti',(select ClienteContrato_PK from ClienteContrato where apelidoCliente = 'TERRAL'));
commit;

-- 4 inserindo os tickets relacionados aos bancos do cliente
insert into BancoMonitoradoTicket(BancoMonitoradoTicket_PK,frequenciaMonitoramento,valorHoraNormal,valorHoraExtra,rdbms,ClienteContrato_FK)
values(bancoMonitTicket_seq.nextval,'',97, 150,'oracle',(select ClienteContrato_PK from ClienteContrato where apelidoCliente = 'GJC'));
insert into BancoMonitoradoTicket(BancoMonitoradoTicket_PK,frequenciaMonitoramento,valorHoraNormal,valorHoraExtra,rdbms,ClienteContrato_FK)
values(bancoMonitTicket_seq.nextval,'',97, 150,'oracle',(select ClienteContrato_PK from ClienteContrato where apelidoCliente = 'POLIPECAS'));
insert into BancoMonitoradoTicket(BancoMonitoradoTicket_PK,frequenciaMonitoramento,valorHoraNormal,valorHoraExtra,rdbms,ClienteContrato_FK)
values(bancoMonitTicket_seq.nextval,'seg,qua,sex',97, 150,'oracle',(select ClienteContrato_PK from ClienteContrato where apelidoCliente = 'TERRAL'));
insert into BancoMonitoradoTicket(BancoMonitoradoTicket_PK,frequenciaMonitoramento,valorHoraNormal,valorHoraExtra,rdbms,ClienteContrato_FK)
values(bancoMonitTicket_seq.nextval,'seg,qua,sex',97, 150,'sqlserver',(select ClienteContrato_PK from ClienteContrato where apelidoCliente = 'TERRAL'));
commit;

-- 5 inserindo informações dos servidores do cliente
insert into ServidorOracle(ServidorOracle_PK,nomeServidor,ipServidor,archivePath,tracePath)  
values(srvOracle_seq.nextval,'srv-oracle1','192.168.0.10','/u01/app/oracle/fast_recovery_area/archivelog','/u01/app/oracle/diag');     
insert into ServidorOracle(ServidorOracle_PK,nomeServidor,ipServidor,archivePath,tracePath)  
values(srvOracle_seq.nextval,'srv-oracle2','192.168.0.11','/u01/app/oracle/fast_recovery_area/archivelog','/u01/app/oracle/diag');
insert into ServidorOracle(ServidorOracle_PK,nomeServidor,ipServidor,archivePath,tracePath)  
values(srvOracle_seq.nextval,'srv-oracle3','192.168.0.12','/u01/app/oracle/fast_recovery_area/archivelog','/u01/app/oracle/diag');
insert into ServidorOracle(ServidorOracle_PK,nomeServidor,ipServidor,archivePath,tracePath)  
values(srvOracle_seq.nextval,'srv-oracle4','192.168.0.13','/u01/app/oracle/fast_recovery_area/archivelog','/u01/app/oracle/diag');
insert into ServidorOracle(ServidorOracle_PK,nomeServidor,ipServidor,archivePath,tracePath)  
values(srvOracle_seq.nextval,'srv-oracle5','192.168.0.14','/u01/app/oracle/fast_recovery_area/archivelog','/u01/app/oracle/diag');
commit;	
	
-- 6 inserindo informações dos bancos ligados as instancias
insert into DBOracle(DBOracle_PK,nomeBanco,tipoBanco,ColaboradorPreAnalise_FK,ColaboradorAnalise_FK,BancoMonitoradoTicket_FK)
values(dbOracle_seq.nextval,'gjc','rac',(select colaborador_pk from colaborador where nome = 'Felipe Alves'),(select colaborador_pk from colaborador where nome = 'Paulo Henrique'),(select a.BancoMonitoradoTicket_PK from BancoMonitoradoTicket a, ClienteContrato b where a.ClienteContrato_FK = b.ClienteContrato_PK and b.apelidoCliente = 'GJC'));
insert into DBOracle(DBOracle_PK,nomeBanco,tipoBanco,ColaboradorPreAnalise_FK,ColaboradorAnalise_FK,BancoMonitoradoTicket_FK)
values(dbOracle_seq.nextval,'plp','rac',(select colaborador_pk from colaborador where nome = 'Felipe Alves'),(select colaborador_pk from colaborador where nome = 'Carlos Bezerra Tanaka'),(select a.BancoMonitoradoTicket_PK from BancoMonitoradoTicket a, ClienteContrato b where a.ClienteContrato_FK = b.ClienteContrato_PK and b.apelidoCliente = 'POLIPECAS'));
insert into DBOracle(DBOracle_PK,nomeBanco,tipoBanco,ColaboradorPreAnalise_FK,ColaboradorAnalise_FK,BancoMonitoradoTicket_FK)
values(dbOracle_seq.nextval,'mega','single',(select colaborador_pk from colaborador where nome = 'Felipe Alves'),(select colaborador_pk from colaborador where nome = 'Guilherme Souza'),(select a.BancoMonitoradoTicket_PK from BancoMonitoradoTicket a, ClienteContrato b where a.ClienteContrato_FK = b.ClienteContrato_PK and b.apelidoCliente = 'TERRAL' and a.BancoMonitoradoTicket_PK = 3));
insert into DBOracle(DBOracle_PK,nomeBanco,tipoBanco,ColaboradorPreAnalise_FK,ColaboradorAnalise_FK,BancoMonitoradoTicket_FK)
values(dbOracle_seq.nextval,'fpw','single',(select colaborador_pk from colaborador where nome = 'Felipe Alves'),(select colaborador_pk from colaborador where nome = 'Guilherme Souza'),(select a.BancoMonitoradoTicket_PK from BancoMonitoradoTicket a, ClienteContrato b where a.ClienteContrato_FK = b.ClienteContrato_PK and b.apelidoCliente = 'TERRAL' and a.BancoMonitoradoTicket_PK = 4));
commit;

-- 7 inserindo informações da instancia ligada ao servidor do cliente
insert into InstanciaOracle(InstanciaOracle_PK,nomeInstancia,ServidorOracle_FK,DBOracle_FK)  
values(instOracle_seq.nextval,'gjc1',(select ServidorOracle_PK from ServidorOracle where ServidorOracle_PK = 1),(select DBOracle_PK from DBOracle where DBOracle_PK = 1));   
insert into InstanciaOracle(InstanciaOracle_PK,nomeInstancia,ServidorOracle_FK,DBOracle_FK)  
values(instOracle_seq.nextval,'gjc2',(select ServidorOracle_PK from ServidorOracle where ServidorOracle_PK = 2),(select DBOracle_PK from DBOracle where DBOracle_PK = 1)); 
insert into InstanciaOracle(InstanciaOracle_PK,nomeInstancia,ServidorOracle_FK,DBOracle_FK)  
values(instOracle_seq.nextval,'plp1',(select ServidorOracle_PK from ServidorOracle where ServidorOracle_PK = 3),(select DBOracle_PK from DBOracle where DBOracle_PK = 2)); 
insert into InstanciaOracle(InstanciaOracle_PK,nomeInstancia,ServidorOracle_FK,DBOracle_FK)  
values(instOracle_seq.nextval,'plp2',(select ServidorOracle_PK from ServidorOracle where ServidorOracle_PK = 4),(select DBOracle_PK from DBOracle where DBOracle_PK = 2)); 
insert into InstanciaOracle(InstanciaOracle_PK,nomeInstancia,ServidorOracle_FK,DBOracle_FK)  
values(instOracle_seq.nextval,'mega',(select ServidorOracle_PK from ServidorOracle where ServidorOracle_PK = 5),(select DBOracle_PK from DBOracle where DBOracle_PK = 5)); 
insert into InstanciaOracle(InstanciaOracle_PK,nomeInstancia,ServidorOracle_FK,DBOracle_FK)  
values(instOracle_seq.nextval,'fpw',(select ServidorOracle_PK from ServidorOracle where ServidorOracle_PK = 5),(select DBOracle_PK from DBOracle where DBOracle_PK = 6)); 
commit;   
	
-- 8 
set pagesize 1000;
set linesize 250;
select BancoMonitoradoTicket_PK, frequenciaMonitoramento from BancoMonitoradoTicket;
select BancoMonitoradoTicket_PK from BancoMonitoradoTicket where BancoMonitoradoTicket_PK = 1;

select capturaFrenqMonitor(select frequenciaMonitoramento from BancoMonitoradoTicket where BancoMonitoradoTicket_PK = 1) from dual;