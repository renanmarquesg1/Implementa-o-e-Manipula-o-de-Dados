/* 
   PROJETO: ELETROCAR - SCRIPT COMPLETO
   Banco: MySQL
   Uso sugerido: Visual Studio Code + extensão SQLTools (MySQL)
*/

-- =========================================
-- 1) CRIAÇÃO DO BANCO DE DADOS
-- =========================================
DROP DATABASE IF EXISTS eletrocar_db;
CREATE DATABASE eletrocar_db;
USE eletrocar_db;

-- =========================================
-- 2) CRIAÇÃO DAS TABELAS (DDL)
-- =========================================

CREATE TABLE CLIENTE (
    id_cliente      INT PRIMARY KEY,
    nome            VARCHAR(100) NOT NULL,
    telefone        VARCHAR(15),
    cpf             CHAR(11) NOT NULL UNIQUE
);

CREATE TABLE VEICULO (
    id_veiculo  INT PRIMARY KEY,
    placa       VARCHAR(10) NOT NULL UNIQUE,
    modelo      VARCHAR(60) NOT NULL,
    ano         INT,
    id_cliente  INT NOT NULL,
    CONSTRAINT fk_veiculo_cliente
        FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente)
);

CREATE TABLE ORDEMSERVICO (
    id_os               INT PRIMARY KEY,
    data_entrada        DATE NOT NULL,
    data_saida_prevista DATE,
    status              VARCHAR(20) NOT NULL,
    valor_total         DECIMAL(10,2) DEFAULT 0,
    id_veiculo          INT NOT NULL,
    CONSTRAINT fk_os_veiculo
        FOREIGN KEY (id_veiculo) REFERENCES VEICULO(id_veiculo)
);

CREATE TABLE SERVICO (
    id_servico          INT PRIMARY KEY,
    nome_servico        VARCHAR(80) NOT NULL,
    valor_mao_de_obra   DECIMAL(10,2) NOT NULL
);

CREATE TABLE MECANICO (
    id_mecanico INT PRIMARY KEY,
    nome        VARCHAR(100) NOT NULL,
    especialidade VARCHAR(80)
);

CREATE TABLE PECA (
    id_peca             INT PRIMARY KEY,
    nome_peca           VARCHAR(100) NOT NULL,
    valor_unitario      DECIMAL(10,2) NOT NULL,
    quantidade_estoque  INT NOT NULL DEFAULT 0
);

CREATE TABLE SERVICO_OS (
    id_os       INT NOT NULL,
    id_servico  INT NOT NULL,
    PRIMARY KEY (id_os, id_servico),
    CONSTRAINT fk_servico_os_os
        FOREIGN KEY (id_os) REFERENCES ORDEMSERVICO(id_os),
    CONSTRAINT fk_servico_os_servico
        FOREIGN KEY (id_servico) REFERENCES SERVICO(id_servico)
);

CREATE TABLE MECANICO_SERVICO (
    id_servico  INT NOT NULL,
    id_mecanico INT NOT NULL,
    PRIMARY KEY (id_servico, id_mecanico),
    CONSTRAINT fk_mec_serv_servico
        FOREIGN KEY (id_servico) REFERENCES SERVICO(id_servico),
    CONSTRAINT fk_mec_serv_mecanico
        FOREIGN KEY (id_mecanico) REFERENCES MECANICO(id_mecanico)
);

CREATE TABLE PECA_OS (
    id_os          INT NOT NULL,
    id_peca        INT NOT NULL,
    quantidade     INT NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_os, id_peca),
    CONSTRAINT fk_peca_os_os
        FOREIGN KEY (id_os) REFERENCES ORDEMSERVICO(id_os),
    CONSTRAINT fk_peca_os_peca
        FOREIGN KEY (id_peca) REFERENCES PECA(id_peca)
);

-- =========================================
-- 3) INSERTS – POVOAMENTO DO BANCO
-- =========================================

-- CLIENTE
INSERT INTO CLIENTE (id_cliente, nome, telefone, cpf) VALUES
(1, 'Carlos Silva',  '54999990001', '12345678901'),
(2, 'Mariana Souza', '54999990002', '98765432100'),
(3, 'João Pereira',  '54999990003', '45678912300');

-- VEICULO
INSERT INTO VEICULO (id_veiculo, placa, modelo, ano, id_cliente) VALUES
(1, 'ABC1D23', 'Gol 1.0',    2014, 1),
(2, 'EFG4H56', 'Onix 1.4',   2018, 2),
(3, 'IJK7L89', 'HB20 1.6',   2020, 3);

-- MECANICO
INSERT INTO MECANICO (id_mecanico, nome, especialidade) VALUES
(1, 'Rafael Lima', 'Motor'),
(2, 'Bruno Costa', 'Suspensão'),
(3, 'Ana Paula',   'Elétrica');

-- PECA
INSERT INTO PECA (id_peca, nome_peca, valor_unitario, quantidade_estoque) VALUES
(1, 'Filtro de óleo',          35.00, 50),
(2, 'Pastilha de freio',      120.00, 30),
(3, 'Bateria 60Ah',           450.00, 15),
(4, 'Amortecedor dianteiro',  320.00, 20);

-- SERVICO
INSERT INTO SERVICO (id_servico, nome_servico, valor_mao_de_obra) VALUES
(1, 'Troca de óleo',                80.00),
(2, 'Revisão de freios',           150.00),
(3, 'Revisão elétrica',            200.00),
(4, 'Substituição de amortecedores', 250.00);

-- ORDEMSERVICO
INSERT INTO ORDEMSERVICO (id_os, data_entrada, data_saida_prevista, status, valor_total, id_veiculo) VALUES
(1, '2025-03-01', '2025-03-02', 'Finalizada', 115.00, 1), -- 80 + 35
(2, '2025-03-05', '2025-03-06', 'Finalizada', 270.00, 2), -- 150 + 120
(3, '2025-03-10', '2025-03-12', 'Em execução', 770.00, 3); -- 200 + 250 + peças

-- SERVICO_OS (quais serviços em cada OS)
INSERT INTO SERVICO_OS (id_os, id_servico) VALUES
(1, 1), -- Troca de óleo na OS 1
(2, 2), -- Revisão de freios na OS 2
(3, 3), -- Revisão elétrica na OS 3
(3, 4); -- Substituição de amortecedores na OS 3

-- MECANICO_SERVICO (quem executou cada serviço)
INSERT INTO MECANICO_SERVICO (id_servico, id_mecanico) VALUES
(1, 1), -- Rafael fez Troca de óleo
(2, 2), -- Bruno fez Revisão de freios
(3, 3), -- Ana fez Revisão elétrica
(4, 2), -- Bruno nos amortecedores
(4, 1); -- Rafael também nos amortecedores

-- PECA_OS (quais peças em cada OS)
INSERT INTO PECA_OS (id_os, id_peca, quantidade, valor_unitario) VALUES
(1, 1, 1, 35.00),   -- 1 filtro de óleo na OS 1
(2, 2, 1, 120.00),  -- 1 jogo de pastilhas na OS 2
(3, 3, 1, 450.00),  -- 1 bateria na OS 3
(3, 4, 2, 320.00);  -- 2 amortecedores dianteiros na OS 3

-- =========================================
-- 4) CONSULTAS (SELECT)
-- =========================================

-- 4.1 Listar ordens de serviço com cliente, veículo e valor total
SELECT
    os.id_os,
    c.nome        AS cliente,
    v.placa       AS placa_veiculo,
    os.status,
    os.valor_total,
    os.data_entrada,
    os.data_saida_prevista
FROM ORDEMSERVICO os
JOIN VEICULO v   ON v.id_veiculo = os.id_veiculo
JOIN CLIENTE c   ON c.id_cliente = v.id_cliente
ORDER BY os.data_entrada DESC;

-- 4.2 Listar peças com estoque baixo (menos de 20 unidades)
SELECT
    id_peca,
    nome_peca,
    quantidade_estoque
FROM PECA
WHERE quantidade_estoque < 20
ORDER BY quantidade_estoque ASC;

-- 4.3 Listar serviços realizados na OS 3
SELECT
    os.id_os,
    s.nome_servico,
    s.valor_mao_de_obra
FROM SERVICO_OS so
JOIN ORDEMSERVICO os ON os.id_os = so.id_os
JOIN SERVICO s       ON s.id_servico = so.id_servico
WHERE os.id_os = 3;

-- 4.4 Valor total de peças utilizadas em cada OS
SELECT
    po.id_os,
    SUM(po.quantidade * po.valor_unitario) AS total_pecas
FROM PECA_OS po
GROUP BY po.id_os
ORDER BY total_pecas DESC;

-- 4.5 Listar mecânicos e os serviços em que já trabalharam
SELECT
    m.nome AS mecanico,
    s.nome_servico
FROM MECANICO_SERVICO ms
JOIN MECANICO m ON m.id_mecanico = ms.id_mecanico
JOIN SERVICO s  ON s.id_servico  = ms.id_servico
ORDER BY m.nome, s.nome_servico;

-- =========================================
-- 5) UPDATES
-- =========================================

-- 5.1 Atualizar o telefone de um cliente
UPDATE CLIENTE
SET telefone = '54999990099'
WHERE id_cliente = 1;

-- 5.2 Atualizar o status de uma OS em execução para finalizada
UPDATE ORDEMSERVICO
SET status = 'Finalizada'
WHERE id_os = 3;

-- 5.3 Dar baixa no estoque de amortecedores (id_peca = 4)
UPDATE PECA
SET quantidade_estoque = quantidade_estoque - 2
WHERE id_peca = 4;

-- =========================================
-- 6) DELETES
-- =========================================

-- 6.1 Remover a associação de um mecânico a um serviço
DELETE FROM MECANICO_SERVICO
WHERE id_servico = 4
  AND id_mecanico = 1;

-- 6.2 Remover uma peça utilizada em determinada OS (bateria na OS 3)
DELETE FROM PECA_OS
WHERE id_os = 3
  AND id_peca = 3;

-- 6.3 Remover o vínculo de um serviço de uma OS (tirar serviço 1 da OS 1)
DELETE FROM SERVICO_OS
WHERE id_os = 1
  AND id_servico = 1;
