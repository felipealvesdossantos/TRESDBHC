-- Gerado por Oracle SQL Developer Data Modeler 4.1.1.888
--   em:        2015-09-14 16:47:38 BRT
--   site:      Oracle Database 11g
--   tipo:      Oracle Database 11g

-- criação de tablespace para o sistema tresdbhc
--DROP TABLESPACE tresdbhc_dados INCLUDING CONTENTS;
--DROP TABLESPACE tresdbhc_indx INCLUDING CONTENTS;
--CREATE TABLESPACE tresdbhc_dados DATAFILE '$ORACLE_BASE/oradata/$ORACLE_SID/tresdbhc_dados01.dbf' SIZE 1000M AUTOEXTEND ON NEXT 100M MAXSIZE UNLIMITED;
--ALTER TABLESPACE tresdbhc_dados ADD DATAFILE '$ORACLE_BASE/oradata/$ORACLE_SID/tresdbhc_dados02.dbf' SIZE 1000M AUTOEXTEND ON NEXT 100M MAXSIZE UNLIMITED;
--CREATE TABLESPACE tresdbhc_indx DATAFILE '$ORACLE_BASE/oradata/$ORACLE_SID/tresdbhc_indx01.dbf' SIZE 1000M AUTOEXTEND ON NEXT 100M MAXSIZE UNLIMITED;
--ALTER TABLESPACE tresdbhc_indx ADD DATAFILE '$ORACLE_BASE/oradata/$ORACLE_SID/tresdbhc_indx02.dbf' SIZE 1000M AUTOEXTEND ON NEXT 100M MAXSIZE UNLIMITED;

--#####################################################################################################


-- criação do usuario tresdbhc que sera dono dos objetos 
CREATE USER tresdbhc IDENTIFIED BY tresdbhc DEFAULT TABLESPACE tresdbhc_dados;
ALTER USER tresdbhc QUOTA UNLIMITED ON tresdbhc_dados;
ALTER USER tresdbhc QUOTA UNLIMITED ON tresdbhc_indx;
GRANT connect, resource TO tresdbhc;
GRANT select on APEX_050000.apex_application_pages to tresdbhc;
GRANT create view to tresdbhc;
conn tresdbhc/tresdbhc;

--#####################################################################################################


-- criação da tabelas e seus relacionamentos do tresdbhc
--1
CREATE TABLE tresdbhc.ClienteContrato
  (
    ClienteContrato_PK NUMBER NOT NULL ,
    nomeCliente        VARCHAR2 (500 CHAR) NOT NULL ,
    apelidoCliente     VARCHAR2 (50 CHAR) NOT NULL ,
    telefone           VARCHAR2 (20 CHAR) NOT NULL ,
    tipoContrato       VARCHAR2 (20 CHAR) NOT NULL ,
    modalidade         VARCHAR2 (100 CHAR) NOT NULL ,
    diaFaturamento     NUMBER NOT NULL ,
    diaVencimento      NUMBER NOT NULL ,
    codigoSuperCash    VARCHAR2 (100 CHAR) NOT NULL ,
    cnpj               VARCHAR2 (20 CHAR) NOT NULL ,
    endereco           VARCHAR2 (300 CHAR) NOT NULL ,
    cep                VARCHAR2 (20 CHAR) NOT NULL ,
    cidade             VARCHAR2 (50 CHAR) NOT NULL ,
    estado             VARCHAR2 (30 CHAR) NOT NULL ,
    dataVencimentoCAC  DATE
  ) ;
COMMENT ON COLUMN tresdbhc.ClienteContrato.tipoContrato
IS
  'mensal, avulso, suspenso, cancelado, treinamento, parceria
' ;
  COMMENT ON COLUMN tresdbhc.ClienteContrato.modalidade
IS
  'modelo franquia horas, modelo frequencia variável, modelo frequencia fixo
' ;
  ALTER TABLE tresdbhc.ClienteContrato ADD CONSTRAINT diaVencimento_CK_1 CHECK (diaVencimento BETWEEN 1 AND 31) ;
  ALTER TABLE tresdbhc.ClienteContrato ADD CONSTRAINT diaFaturamento_CK_2 CHECK (diaFaturamento BETWEEN 1 AND 31) ;
  ALTER TABLE tresdbhc.ClienteContrato ADD CONSTRAINT CliCont_PK PRIMARY KEY ( ClienteContrato_PK ) ;
  ALTER TABLE tresdbhc.ClienteContrato ADD CONSTRAINT CliContApelidoCli_UN UNIQUE ( apelidoCliente , nomeCliente ) ;

--sequence para chave primaria ClienteContrato
CREATE SEQUENCE tresdbhc.cliContrato_seq START WITH 1 NOCACHE ORDER ;

----------------------------------------------------------------------------
--2
CREATE TABLE tresdbhc.ContatoCliente
  (
    ContatoCliente_PK    NUMBER NOT NULL ,
    nomeContato          VARCHAR2 (100 CHAR) NOT NULL ,
    funcao               VARCHAR2 (50 CHAR) ,
    telefone             VARCHAR2 (100 CHAR) ,
    celular              VARCHAR2 (20 CHAR) ,
    email                VARCHAR2 (50 CHAR) NOT NULL ,
    departamento         VARCHAR2 (50 CHAR) ,
    ClienteContratoId_FK NUMBER NOT NULL
  ) ;
ALTER TABLE tresdbhc.ContatoCliente ADD CONSTRAINT ContCli_PK PRIMARY KEY ( ContatoCliente_PK ) ;
ALTER TABLE tresdbhc.ContatoCliente ADD CONSTRAINT ContCli_CliContrato_FK FOREIGN KEY ( ClienteContratoId_FK ) REFERENCES tresdbhc.ClienteContrato ( ClienteContrato_PK ) ON
DELETE CASCADE ;

-- sequence para chave primaria ContatoCliente
CREATE SEQUENCE tresdbhc.contatoCli_seq START WITH 1 NOCACHE ORDER ;

----------------------------------------------------------------------------
--3
CREATE TABLE tresdbhc.Colaborador
  (
    Colaborador_PK NUMBER NOT NULL ,
    nome           VARCHAR2 (100 CHAR) NOT NULL ,
    funcao         VARCHAR2 (50 CHAR) NOT NULL ,
    telefone       VARCHAR2 (30 CHAR) ,
    celular        VARCHAR2 (30 CHAR) ,
    endereco CLOB ,
    email           VARCHAR2 (100 CHAR) ,
    ativo           VARCHAR2 (10 CHAR) ,
    GerenteId_FK    NUMBER ,
    Departamento_FK NUMBER
  ) ;
COMMENT ON COLUMN tresdbhc.Colaborador.funcao
IS
  'dba, coordenador, diretor, estagiario, vendedor, assistente administrativo, secretaria' ;
  COMMENT ON COLUMN tresdbhc.Colaborador.ativo
IS
  ' inativo, ativo' ;
  ALTER TABLE tresdbhc.Colaborador ADD CONSTRAINT Colab_PK PRIMARY KEY ( Colaborador_PK ) ;
  ALTER TABLE tresdbhc.Colaborador ADD CONSTRAINT Gerente_Colab_FK FOREIGN KEY ( GerenteId_FK ) REFERENCES tresdbhc.Colaborador ( Colaborador_PK ) ON
  DELETE CASCADE ;

-- sequence para chave primaria Colaborador
CREATE SEQUENCE tresdbhc.colab_seq START WITH 1 NOCACHE ORDER ;

----------------------------------------------------------------------------
--4
CREATE TABLE tresdbhc.Departamento
  (
    Departamento_PK NUMBER NOT NULL ,
    nome            VARCHAR2 (50 CHAR) NOT NULL ,
    atribuicao      VARCHAR2 (500 CHAR) ,
    Gerente_FK      NUMBER NOT NULL
  ) ;
ALTER TABLE tresdbhc.Departamento ADD CONSTRAINT Departamento_PK PRIMARY KEY ( Departamento_PK ) ;
ALTER TABLE tresdbhc.Departamento ADD CONSTRAINT Depart_Colab_FK FOREIGN KEY ( Gerente_FK ) REFERENCES tresdbhc.Colaborador ( Colaborador_PK ) ;
ALTER TABLE tresdbhc.Colaborador ADD CONSTRAINT Colab_Depart_FK FOREIGN KEY ( Departamento_FK ) REFERENCES tresdbhc.Departamento ( Departamento_PK ) ON
  DELETE CASCADE ;

-- sequence para chave primaria Colaborador
CREATE SEQUENCE tresdbhc.depart_seq START WITH 1 NOCACHE ORDER ;

----------------------------------------------------------------------------
--5
CREATE TABLE tresdbhc.BancoMonitoradoTicket
  (
    BancoMonitoradoTicket_PK NUMBER NOT NULL ,
    frequenciaMonitoramento  VARCHAR2 (100 CHAR) ,
    valorHoraNormal          NUMBER ,
    valorHoraExtra           NUMBER ,
    rdbms                    NUMBER ,
    ClienteContrato_FK       NUMBER NOT NULL
  ) ;
COMMENT ON COLUMN tresdbhc.BancoMonitoradoTicket.rdbms
IS
  'oracle,  sqlserver' ;
  ALTER TABLE tresdbhc.BancoMonitoradoTicket ADD CONSTRAINT BdMonitTicket_PK PRIMARY KEY ( BancoMonitoradoTicket_PK ) ;
  ALTER TABLE tresdbhc.BancoMonitoradoTicket ADD CONSTRAINT BdMonitorTicket_CliCont_FK FOREIGN KEY ( ClienteContrato_FK ) REFERENCES tresdbhc.ClienteContrato ( ClienteContrato_PK ) ON
  DELETE CASCADE ;

-- sequence para chave primaria BancoMonitoradoTicket
CREATE SEQUENCE tresdbhc.bancoMonitTicket_seq START WITH 1 NOCACHE ORDER ;

----------------------------------------------------------------------------
--6
CREATE TABLE tresdbhc.ServidorRdbms
  (
    ServidorRdbms_PK   NUMBER NOT NULL ,
    nomeServidor       VARCHAR2 (50 CHAR) NOT NULL ,
    ipServidor         VARCHAR2 (30 CHAR) ,
    qtdCpu             NUMBER ,
    modeloCpu          VARCHAR2 (100 CHAR) ,
    sistemaOperacional VARCHAR2 (100 CHAR) ,
    qtdMemoriaRam      NUMBER ,
    qtdDisco           NUMBER ,
    hypervisor         VARCHAR2 (30 CHAR)
  ) ;
COMMENT ON COLUMN tresdbhc.ServidorRdbms.hypervisor
IS
  'nenhum, oracle vm, vmware, virtual box, hyper-v, xen server community, xen server citrix' ;
  ALTER TABLE tresdbhc.ServidorRdbms ADD CONSTRAINT SrvSQLSrv_PK PRIMARY KEY ( ServidorRdbms_PK ) ;

-- sequence para chave primaria ServidorRdbms
CREATE SEQUENCE tresdbhc.srvRdbms_seq START WITH 1 NOCACHE ORDER ;

----------------------------------------------------------------------------
--7
CREATE TABLE tresdbhc.DBOracle
  (
    DBOracle_PK              NUMBER NOT NULL ,
    nomeBanco                VARCHAR2 (30 CHAR) NOT NULL ,
    tipoBanco                VARCHAR2 (20 CHAR) NOT NULL ,
    ColaboradorPreAnalise_FK NUMBER NOT NULL ,
    ColaboradorAnalise_FK    NUMBER NOT NULL ,
    BancoMonitoradoTicket_FK NUMBER NOT NULL
  ) ;
COMMENT ON COLUMN tresdbhc.DBOracle.tipoBanco
IS
  'single, rac, extend rac, oda, exadata' ;
  ALTER TABLE tresdbhc.DBOracle ADD CONSTRAINT DBOracle_PK PRIMARY KEY ( DBOracle_PK ) ;
  ALTER TABLE tresdbhc.DBOracle ADD CONSTRAINT DBOracle_BdMonitTicket_FK FOREIGN KEY ( BancoMonitoradoTicket_FK ) REFERENCES tresdbhc.BancoMonitoradoTicket ( BancoMonitoradoTicket_PK ) ON
  DELETE CASCADE ;
  ALTER TABLE tresdbhc.DBOracle ADD CONSTRAINT DBOracle_Colab_FK1 FOREIGN KEY ( ColaboradorPreAnalise_FK ) REFERENCES tresdbhc.Colaborador ( Colaborador_PK ) ON
  DELETE CASCADE ;
  ALTER TABLE tresdbhc.DBOracle ADD CONSTRAINT DBOracle_Colab_FK2 FOREIGN KEY ( ColaboradorAnalise_FK ) REFERENCES tresdbhc.Colaborador ( Colaborador_PK ) ON
  DELETE CASCADE ;

-- sequence para chave primaria DBOracle
CREATE SEQUENCE tresdbhc.dbOracle_seq START WITH 1 NOCACHE ORDER ;
  
----------------------------------------------------------------------------
--8
CREATE TABLE tresdbhc.InstanciaOracle
  (
    InstanciaOracle_PK NUMBER NOT NULL ,
    nomeInstancia      VARCHAR2 (30 CHAR) NOT NULL ,
    ServidorRdbms_FK   NUMBER NOT NULL ,
    DBOracle_FK        NUMBER NOT NULL
  ) ;
ALTER TABLE tresdbhc.InstanciaOracle ADD CONSTRAINT InstOracle_PK PRIMARY KEY ( InstanciaOracle_PK ) ;
ALTER TABLE tresdbhc.InstanciaOracle ADD CONSTRAINT InstOracle_DBOracle_FK FOREIGN KEY ( DBOracle_FK ) REFERENCES tresdbhc.DBOracle ( DBOracle_PK ) ON
DELETE CASCADE ;
ALTER TABLE tresdbhc.InstanciaOracle ADD CONSTRAINT InstOracle_SrvOracle_FK FOREIGN KEY ( ServidorRdbms_FK ) REFERENCES tresdbhc.ServidorRdbms ( ServidorRdbms_PK ) ON
DELETE CASCADE ;

-- sequence para chave primaria InstanciaOracle
CREATE SEQUENCE tresdbhc.instOracle_seq START WITH 1 NOCACHE ORDER ;

----------------------------------------------------------------------------
--9
CREATE TABLE tresdbhc.Parecer
  (
    Parecer_PK NUMBER NOT NULL ,
    preAnalise CLOB ,
    analise CLOB ,
    ColaboradorPreAnalise_FK NUMBER NOT NULL ,
    ColaboradorAnalise_FK    NUMBER NOT NULL
  ) ;
ALTER TABLE tresdbhc.Parecer ADD CONSTRAINT ParOracle_PK PRIMARY KEY ( Parecer_PK ) ;
ALTER TABLE tresdbhc.Parecer ADD CONSTRAINT ParOracle_ColabAnalise_FK FOREIGN KEY ( ColaboradorAnalise_FK ) REFERENCES tresdbhc.Colaborador ( Colaborador_PK ) ON
DELETE CASCADE ;
ALTER TABLE tresdbhc.Parecer ADD CONSTRAINT ParOracle_ColabPreAnalise_FK FOREIGN KEY ( ColaboradorPreAnalise_FK ) REFERENCES tresdbhc.Colaborador ( Colaborador_PK ) ON
DELETE CASCADE ;

-- sequence para chave primaria ParecerOracle
CREATE SEQUENCE tresdbhc.parecer_seq START WITH 1 NOCACHE ORDER ;

----------------------------------------------------------------------------
--10
CREATE TABLE tresdbhc.IndicadoresDBOracle
  (
    IndicadoresDBOracle_PK  NUMBER NOT NULL ,
    data                    DATE ,
    versao                  VARCHAR2 (10 CHAR) ,
    logMode                 VARCHAR2 (15 CHAR) ,
    tamanhoBanco            NUMBER ,
    tablespaceUsadoPct      NUMBER ,
    nomeTablesapaceUsadoPct VARCHAR2 (50 CHAR) ,
    asmUsadoPct             NUMBER ,
    nomeAsmUsadoPct         NUMBER ,
    objCriadosUltimoDia     NUMBER ,
    objSemEstatisticas      NUMBER ,
    dbfComProblemas         NUMBER ,
    dbfComProblemaNome      VARCHAR2 (50 CHAR) ,
    errosBackupLogico       NUMBER ,
    tamanhoBackupLogico     NUMBER ,
    errosBackupFisico       NUMBER ,
    tamanhoBackupFisico     NUMBER ,
    DBOracle_FK             NUMBER NOT NULL ,
    ParecerOracle_FK        NUMBER NOT NULL
  ) ;
COMMENT ON COLUMN tresdbhc.IndicadoresDBOracle.logMode
IS
  'archivelog, noarchivelog' ;
  ALTER TABLE tresdbhc.IndicadoresDBOracle ADD CONSTRAINT IndicDBOracle_PK PRIMARY KEY ( IndicadoresDBOracle_PK ) ;
  ALTER TABLE tresdbhc.IndicadoresDBOracle ADD CONSTRAINT IndicDBOracle_DBOracle_FK FOREIGN KEY ( DBOracle_FK ) REFERENCES tresdbhc.DBOracle ( DBOracle_PK ) ON
  DELETE CASCADE ;
  ALTER TABLE tresdbhc.IndicadoresDBOracle ADD CONSTRAINT IndicDBOracle_ParOracle_FK FOREIGN KEY ( ParecerOracle_FK ) REFERENCES tresdbhc.Parecer ( Parecer_PK ) ON
  DELETE CASCADE ;

-- sequence para chave primaria IndicadoresDBOracle
CREATE SEQUENCE tresdbhc.indicDBOracle_seq START WITH 1 NOCACHE ORDER ;

----------------------------------------------------------------------------
--11
CREATE TABLE tresdbhc.IndicadoresInstanciaOracle
  (
    IndicadoresInstanciaOracle_PK NUMBER NOT NULL ,
    data                          DATE ,
    libraryCacheHit               NUMBER ,
    dictCacheHit                  NUMBER ,
    bufferCacheHit                NUMBER ,
    redoLogHit                    NUMBER ,
    sortAreaHit                   NUMBER ,
    espacoArchivePct              NUMBER ,
    fsMaisUsadoPct                NUMBER ,
    nomeFsMaisUsado               VARCHAR2 (100 CHAR) ,
    errosAlert                    NUMBER ,
    volumetriaTrace               NUMBER ,
    swapUsadoPct                  NUMBER ,
    statusAgentEm                 NUMBER ,
    tempoAtividadeInstancia       NUMBER ,
    InstanciaOracle_FK            NUMBER NOT NULL ,
    ParecerOracle_FK              NUMBER NOT NULL
  ) ;
COMMENT ON COLUMN tresdbhc.IndicadoresInstanciaOracle.statusAgentEm
IS
  '0 - inativo, 1 - ativo' ;
  ALTER TABLE tresdbhc.IndicadoresInstanciaOracle ADD CONSTRAINT statusAgentEm_CK_1 CHECK (statusAgentEm IN (0, 1)) ;
  ALTER TABLE tresdbhc.IndicadoresInstanciaOracle ADD CONSTRAINT IndicInstOracle_PK PRIMARY KEY ( IndicadoresInstanciaOracle_PK ) ;
  ALTER TABLE tresdbhc.IndicadoresInstanciaOracle ADD CONSTRAINT IndicInstOracle_InstOracle_FK FOREIGN KEY ( InstanciaOracle_FK ) REFERENCES tresdbhc.InstanciaOracle ( InstanciaOracle_PK ) ON
  DELETE CASCADE ;
  ALTER TABLE tresdbhc.IndicadoresInstanciaOracle ADD CONSTRAINT IndicInstOracle_ParOracle_FK FOREIGN KEY ( ParecerOracle_FK ) REFERENCES tresdbhc.Parecer ( Parecer_PK ) ON
  DELETE CASCADE ;

-- sequence para chave primaria IndicadoresInstanciaOracle
CREATE SEQUENCE tresdbhc.indicInstOracle_seq START WITH 1 NOCACHE ORDER ;  

----------------------------------------------------------------------------
--12
CREATE TABLE tresdbhc.IndicadoresDisasterRecover
  (
    DisasterRecover_PK NUMBER NOT NULL ,
    tipo               VARCHAR2 (20 CHAR) ,
    sincronizado       VARCHAR2 (20 CHAR) ,
    diferencaNo1       NUMBER ,
    diferencaNo2       NUMBER ,
    espacoNo1Pct       NUMBER ,
    espacoNo2Pct       NUMBER ,
    espacoAsmPct       NUMBER ,
    DBOracle_FK        NUMBER NOT NULL ,
    ParecerOracle_FK   NUMBER NOT NULL
  ) ;
COMMENT ON COLUMN tresdbhc.IndicadoresDisasterRecover.tipo
IS
  'standby, data guard' ;
  COMMENT ON COLUMN tresdbhc.IndicadoresDisasterRecover.sincronizado
IS
  ' não sincronizado, sincronizado' ;
  COMMENT ON COLUMN tresdbhc.IndicadoresDisasterRecover.diferencaNo1
IS
  'diferença entre produção e data guard ou standby' ;
  COMMENT ON COLUMN tresdbhc.IndicadoresDisasterRecover.diferencaNo2
IS
  'diferença entre produção e data guard ou standby' ;
  COMMENT ON COLUMN tresdbhc.IndicadoresDisasterRecover.espacoNo1Pct
IS
  'espaço em disco(NFS)' ;
  COMMENT ON COLUMN tresdbhc.IndicadoresDisasterRecover.espacoNo2Pct
IS
  'espaço em disco(NFS)' ;
  COMMENT ON COLUMN tresdbhc.IndicadoresDisasterRecover.espacoAsmPct
IS
  'espaço em disco(ASM)' ;
  ALTER TABLE tresdbhc.IndicadoresDisasterRecover ADD CONSTRAINT DisasterRecover_PK PRIMARY KEY ( DisasterRecover_PK ) ;
  ALTER TABLE tresdbhc.IndicadoresDisasterRecover ADD CONSTRAINT IndicDr_DBOracle_FK FOREIGN KEY ( DBOracle_FK ) REFERENCES tresdbhc.DBOracle ( DBOracle_PK ) ON
  DELETE CASCADE ;
  ALTER TABLE tresdbhc.IndicadoresDisasterRecover ADD CONSTRAINT IndicDr_ParOracle_FK FOREIGN KEY ( ParecerOracle_FK ) REFERENCES tresdbhc.Parecer ( Parecer_PK ) ON
  DELETE CASCADE ;

-- sequence para chave primaria IndicadoresDisasterRecover
CREATE SEQUENCE tresdbhc.indicDisasterRecover_seq START WITH 1 NOCACHE ORDER ;
  
----------------------------------------------------------------------------
--13
CREATE TABLE tresdbhc.TicketTecnico
  (
    TicketTecnico_PK NUMBER NOT NULL ,
    nomeCliente      VARCHAR2 (100 CHAR) ,
    quantidade       NUMBER
  ) ;
ALTER TABLE tresdbhc.TicketTecnico ADD CONSTRAINT TicketTecnico_PK PRIMARY KEY ( TicketTecnico_PK ) ;

-- sequence para chave primaria TicketTecnico
CREATE SEQUENCE tresdbhc.ticketTec_seq START WITH 1 NOCACHE ORDER ;

----------------------------------------------------------------------------
--14
CREATE TABLE tresdbhc.InstanciaSQLServer
  (
    InstanciaSQLServer_PK    NUMBER NOT NULL ,
    nomeInstancia            VARCHAR2 (50 CHAR) NOT NULL ,
    tipoInstancia            VARCHAR2 (20 CHAR) ,
    ServidorRdbms_FK         NUMBER NOT NULL ,
    BancoMonitorTicket_FK    NUMBER NOT NULL ,
    ColaboradorPreAnalise_FK NUMBER NOT NULL ,
    ColaboradorAnalise_FK    NUMBER NOT NULL
  ) ;
COMMENT ON COLUMN tresdbhc.InstanciaSQLServer.tipoInstancia
IS
  'single, always on ' ;
  ALTER TABLE tresdbhc.InstanciaSQLServer ADD CONSTRAINT InstSQLSrv_PK PRIMARY KEY ( InstanciaSQLServer_PK ) ;
  ALTER TABLE tresdbhc.InstanciaSQLServer ADD CONSTRAINT InstSQLSrv_BdMonitTicket_FK FOREIGN KEY ( BancoMonitorTicket_FK ) REFERENCES tresdbhc.BancoMonitoradoTicket ( BancoMonitoradoTicket_PK ) ON
  DELETE CASCADE ;
  ALTER TABLE tresdbhc.InstanciaSQLServer ADD CONSTRAINT InstSQLSrv_ColabAnalise_FK FOREIGN KEY ( ColaboradorAnalise_FK ) REFERENCES tresdbhc.Colaborador ( Colaborador_PK ) ON
  DELETE CASCADE ;
  ALTER TABLE tresdbhc.InstanciaSQLServer ADD CONSTRAINT InstSQLSrv_ColabPreAnalise_FK FOREIGN KEY ( ColaboradorPreAnalise_FK ) REFERENCES tresdbhc.Colaborador ( Colaborador_PK ) ON
  DELETE CASCADE ;
  ALTER TABLE tresdbhc.InstanciaSQLServer ADD CONSTRAINT InstSQLSrv_SrvRdbms_FK FOREIGN KEY ( ServidorRdbms_FK ) REFERENCES tresdbhc.ServidorRdbms ( ServidorRdbms_PK ) ON
  DELETE CASCADE ;

-- sequence para chave primaria InstanciaSQLServer
CREATE SEQUENCE tresdbhc.instSQLSrv_seq START WITH 1 NOCACHE ORDER ;

----------------------------------------------------------------------------
--15
CREATE TABLE tresdbhc.IndicadoresBancosSQLServer
  (
    IndicadoresBancosSQLServer_PK  NUMBER NOT NULL ,
    data                           DATE ,
    nomeBanco                      VARCHAR2 (100 CHAR) ,
    tamanhoBanco                   NUMBER ,
    recoveryMode                   VARCHAR2 (30 CHAR) ,
    tamanhoBkpBancoFull            NUMBER ,
    statusBkpBancoFull             VARCHAR2 (30 CHAR) ,
    dataUltimoBkpFull              DATE ,
    qtdErrosBkpFull                NUMBER ,
    qtdErrosBkpDiferencial         NUMBER ,
    qtdErrosBkpLog                 NUMBER ,
    tabelaEstatisticaDesatualizada VARCHAR2 (30 CHAR) ,
    checkDb                        VARCHAR2 (30 CHAR) ,
    indexDesativada                VARCHAR2 (30 CHAR) ,
    mirrorExiste                   VARCHAR2 (5 CHAR) ,
    mirrorSincronizado             VARCHAR2 (5 CHAR) ,
    mirrorTipoSincronismo          VARCHAR2 (30 CHAR) ,
    mirrorFailover                 VARCHAR2 (30 CHAR) ,
    mirrorWitness                  VARCHAR2 (5 CHAR) ,
    mirrorOpMode                   VARCHAR2 (30 CHAR) ,
    InstanciaSQLServer_FK          NUMBER NOT NULL ,
    Parecer_FK                     NUMBER NOT NULL
  ) ;
COMMENT ON COLUMN tresdbhc.IndicadoresBancosSQLServer.recoveryMode
IS
  'simple, full, bulk_logged' ;
  COMMENT ON COLUMN tresdbhc.IndicadoresBancosSQLServer.mirrorExiste
IS
  'sim, nao' ;
  COMMENT ON COLUMN tresdbhc.IndicadoresBancosSQLServer.mirrorSincronizado
IS
  'sim, nao' ;
  COMMENT ON COLUMN tresdbhc.IndicadoresBancosSQLServer.mirrorTipoSincronismo
IS
  'sincrono, assincrono' ;
  COMMENT ON COLUMN tresdbhc.IndicadoresBancosSQLServer.mirrorFailover
IS
  'automatico,  manual,  forced' ;
  COMMENT ON COLUMN tresdbhc.IndicadoresBancosSQLServer.mirrorWitness
IS
  'sim, nao' ;
  COMMENT ON COLUMN tresdbhc.IndicadoresBancosSQLServer.mirrorOpMode
IS
  'high availability,  high-protection,  high-performance' ;
  ALTER TABLE tresdbhc.IndicadoresBancosSQLServer ADD CONSTRAINT IndicBdSQLSrv_PK PRIMARY KEY ( IndicadoresBancosSQLServer_PK ) ;
  ALTER TABLE tresdbhc.IndicadoresBancosSQLServer ADD CONSTRAINT IndBdSQLSrv_BdInstSQLSrv_FK FOREIGN KEY ( InstanciaSQLServer_FK ) REFERENCES tresdbhc.InstanciaSQLServer ( InstanciaSQLServer_PK ) ON
  DELETE CASCADE ;
  ALTER TABLE tresdbhc.IndicadoresBancosSQLServer ADD CONSTRAINT IndicBdSQLSrv_ParSQLSrv_FK FOREIGN KEY ( Parecer_FK ) REFERENCES tresdbhc.Parecer ( Parecer_PK ) ON
  DELETE CASCADE ;

-- sequence para chave primaria IndicadoresBancosSQLServer
CREATE SEQUENCE tresdbhc.indicBdSQLSrv_seq START WITH 1 NOCACHE ORDER ;

----------------------------------------------------------------------------
--16
CREATE TABLE tresdbhc.IndicadoresInstanciaSQLServer
  (
    IndicadoresInstSQLServer_PK NUMBER NOT NULL ,
    data                        DATE ,
    edicao                      VARCHAR2 (30 CHAR) ,
    versao                      VARCHAR2 (30 CHAR) ,
    configPageFiles             NUMBER ,
    jobErros                    NUMBER ,
    errosAlert                  NUMBER ,
    picoCpuPct                  NUMBER ,
    dataPicoCpu                 DATE ,
    tamanhoInstancia            NUMBER ,
    discoMaisUsado              VARCHAR2 (10 CHAR) ,
    discoMaisUsadoPct           NUMBER ,
    maximoMemoria               NUMBER ,
    memoriaUsada                NUMBER ,
    InstanciaSQLServer_FK       NUMBER NOT NULL ,
    ParecerSQLServer_FK         NUMBER NOT NULL ,
    Parecer_FK                  NUMBER NOT NULL
  ) ;
ALTER TABLE tresdbhc.IndicadoresInstanciaSQLServer ADD CONSTRAINT InsdicInstSQLSrv_PK PRIMARY KEY ( IndicadoresInstSQLServer_PK ) ;
ALTER TABLE tresdbhc.IndicadoresInstanciaSQLServer ADD CONSTRAINT IndInstSQLSrv_InstSQLSrv_FK FOREIGN KEY ( InstanciaSQLServer_FK ) REFERENCES tresdbhc.InstanciaSQLServer ( InstanciaSQLServer_PK ) ON
DELETE CASCADE ;
ALTER TABLE tresdbhc.IndicadoresInstanciaSQLServer ADD CONSTRAINT IndInstSQLSrv_ParSQLSrv_FK FOREIGN KEY ( Parecer_FK ) REFERENCES tresdbhc.Parecer ( Parecer_PK ) ON
DELETE CASCADE ;

-- sequence para chave primaria IndicadoresInstanciaSQLServer
CREATE SEQUENCE tresdbhc.indicInstSQLSrv_seq START WITH 1 NOCACHE ORDER ;

----------------------------------------------------------------------------
--17
CREATE OR REPLACE VIEW tresdbhc.paginas (paginas_PK, idAplicacao, nomeAplicacao, nomePagina, tituloPagina, 
CONSTRAINT Paginas_PK PRIMARY KEY (paginas_PK) RELY DISABLE NOVALIDATE)
AS 
	SELECT page_id, 
	application_id, 
	application_name, 
	page_name, 
	page_title 
FROM apex_050000.apex_application_pages 
WHERE application_id = 102;

-- sequence para chave primaria IndicadoresInstanciaSQLServer
CREATE SEQUENCE tresdbhc.paginas_seq START WITH 1 NOCACHE ORDER ;

----------------------------------------------------------------------------
--18
CREATE TABLE tresdbhc.ControleAcessoPaginas
  (
    ControleAcesso_PK NUMBER NOT NULL ,
    Colaborador_FK    NUMBER NOT NULL ,
    PaginasAcessos_FK NUMBER NOT NULL
  ) ;
ALTER TABLE tresdbhc.ControleAcessoPaginas ADD CONSTRAINT ControleAcesso_PK PRIMARY KEY ( ControleAcesso_PK ) ;
ALTER TABLE tresdbhc.ControleAcessoPaginas ADD CONSTRAINT ControleAcesso_Paginas_FK FOREIGN KEY ( PaginasAcessos_FK ) REFERENCES tresdbhc.Paginas ( paginas_PK ) ;
ALTER TABLE tresdbhc.ControleAcessoPaginas ADD CONSTRAINT ControleAcesso_Colab_FK FOREIGN KEY ( Colaborador_FK ) REFERENCES tresdbhc.Colaborador ( Colaborador_PK ) ;

-- sequence para chave primaria IndicadoresInstanciaSQLServer
CREATE SEQUENCE tresdbhc.controleAcesso_seq START WITH 1 NOCACHE ORDER ;

----------------------------------------------------------------------------
--19
CREATE TABLE tresdbhc.itensEnviados 
   (
    ItensEnviados_PK NUMBER NOT NULL ,
    id_email NUMBER, 
	id_relatorio NUMBER, 
	enviado_c_sucesso CHAR(1 BYTE), 
	criacao_mensagem DATE, 
	data_hora_envio DATE, 
	cod_erro NUMBER, 
	mensagem_erro VARCHAR2(600 BYTE)
  );
ALTER TABLE tresdbhc.itensEnviados  ADD CONSTRAINT itensEnviados_PK PRIMARY KEY ( ItensEnviados_PK ) ;

-- sequence para chave primaria IndicadoresInstanciaSQLServer
CREATE SEQUENCE tresdbhc.itensEnviados_seq START WITH 1 NOCACHE ORDER ;

----------------------------------------------------------------------------
--20
CREATE TABLE tresdbhc.caixaSaida 
(
  CaixaSaida_PK NUMBER NOT NULL, 
  id_relatorio NUMBER, 
  criacao_mensagem DATE 
 );
ALTER TABLE tresdbhc.caixaSaida ADD CONSTRAINT caixaSaida_PK PRIMARY KEY ( CaixaSaida_PK ) ;

-- sequence para chave primaria IndicadoresInstanciaSQLServer
CREATE SEQUENCE tresdbhc.caixaSaida_seq START WITH 1 NOCACHE ORDER ;