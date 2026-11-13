-- PROJETO CINTHIE CONFEITARIA
-- Script SQL para MySQL 8.0.16+
-- DDL: criação das tabelas | DML: dados de teste | SELECT: conferência
-- Os relacionamentos N:N são convertidos em tabelas associativas no modelo lógico.
-- Execute o arquivo inteiro no MySQL Workbench (MySQL 8.0.16 ou superior).
-- Usamos um banco novo, com final _v3, para preservar as tabelas da versão antiga.
-- CREATE TABLE IF NOT EXISTS não atualiza a estrutura de uma tabela já existente.

CREATE DATABASE IF NOT EXISTS cinthie_confeitaria_v3
  CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE cinthie_confeitaria_v3;

CREATE TABLE IF NOT EXISTS cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nome_cliente VARCHAR(120) NOT NULL,
  telefone_cliente VARCHAR(20) NOT NULL,
  INDEX idx_cliente_telefone (telefone_cliente)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS funcionario (
  id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
  nome_funcionario VARCHAR(120) NOT NULL,
  funcao_funcionario VARCHAR(80) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS produto (
  id_produto INT AUTO_INCREMENT PRIMARY KEY,
  nome_produto VARCHAR(120) NOT NULL,
  descricao_produto VARCHAR(300) NULL,
  preco_produto DECIMAL(10,2) NOT NULL,
  CONSTRAINT chk_produto_preco CHECK (preco_produto >= 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS plataforma (
  id_plataforma INT AUTO_INCREMENT PRIMARY KEY,
  nome_plataforma VARCHAR(60) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS pedido (
  id_pedido INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT NULL,
  id_plataforma INT NULL,
  data_hora_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  data_prevista_atendimento DATETIME NULL,
  data_hora_cancelamento DATETIME NULL,
  status_pedido VARCHAR(24) NOT NULL DEFAULT 'ABERTO',
  canal_pedido VARCHAR(24) NOT NULL,
  tipo_pedido VARCHAR(24) NOT NULL,
  modalidade_atendimento VARCHAR(24) NOT NULL,
  CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente)
    REFERENCES cliente(id_cliente),
  CONSTRAINT fk_pedido_plataforma FOREIGN KEY (id_plataforma)
    REFERENCES plataforma(id_plataforma),
  CONSTRAINT chk_pedido_status CHECK (
    status_pedido IN ('ABERTO','EM_PREPARO','CONCLUIDO','CANCELADO')
  ),
  CONSTRAINT chk_pedido_canal CHECK (
    canal_pedido IN ('WHATSAPP','BALCAO','PLATAFORMA')
  ),
  CONSTRAINT chk_pedido_tipo CHECK (tipo_pedido IN ('ENCOMENDA','IMEDIATO')),
  CONSTRAINT chk_pedido_modalidade CHECK (
    modalidade_atendimento IN ('CONSUMO_LOCAL','RETIRADA','ENTREGA')
  ),
  CONSTRAINT chk_pedido_encomenda CHECK (
    tipo_pedido <> 'ENCOMENDA' OR data_prevista_atendimento IS NOT NULL
  ),
  CONSTRAINT chk_pedido_app CHECK (
    canal_pedido <> 'PLATAFORMA'
    OR (tipo_pedido = 'IMEDIATO' AND modalidade_atendimento = 'ENTREGA')
  ),
  CONSTRAINT chk_pedido_plataforma CHECK (
    (canal_pedido = 'PLATAFORMA' AND id_plataforma IS NOT NULL)
    OR (canal_pedido IN ('WHATSAPP','BALCAO') AND id_plataforma IS NULL)
  ),
  INDEX idx_pedido_data (data_hora_pedido),
  INDEX idx_pedido_status (status_pedido),
  INDEX idx_pedido_canal (canal_pedido)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS pagamento (
  id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  data_pagamento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  forma_pagamento VARCHAR(24) NOT NULL,
  valor_pago DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_pagamento_pedido FOREIGN KEY (id_pedido)
    REFERENCES pedido(id_pedido),
  CONSTRAINT chk_pagamento_valor CHECK (valor_pago > 0),
  CONSTRAINT chk_pagamento_forma CHECK (
    forma_pagamento IN ('DINHEIRO','PIX','CARTAO')
  ),
  INDEX idx_pagamento_data (data_pagamento)
) ENGINE=InnoDB;

-- Relacionamento N:N PEDIDO-PRODUTO (CONTÉM).
-- quantidade e preco_unitario são atributos do relacionamento.
-- subtotal e total do pedido são calculados nas consultas.
CREATE TABLE IF NOT EXISTS item_pedido (
  id_pedido INT NOT NULL,
  id_produto INT NOT NULL,
  quantidade INT NOT NULL,
  preco_unitario DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id_pedido, id_produto),
  CONSTRAINT fk_contem_pedido FOREIGN KEY (id_pedido)
    REFERENCES pedido(id_pedido),
  CONSTRAINT fk_contem_produto FOREIGN KEY (id_produto)
    REFERENCES produto(id_produto),
  CONSTRAINT chk_contem_quantidade CHECK (quantidade > 0),
  CONSTRAINT chk_contem_preco CHECK (preco_unitario >= 0)
) ENGINE=InnoDB;

-- Relacionamento N:N FUNCIONARIO-PEDIDO (PARTICIPA DE).
CREATE TABLE IF NOT EXISTS pedido_funcionario (
  id_funcionario INT NOT NULL,
  id_pedido INT NOT NULL,
  papel_participacao VARCHAR(80) NOT NULL,
  PRIMARY KEY (id_pedido, id_funcionario),
  CONSTRAINT fk_participa_funcionario FOREIGN KEY (id_funcionario)
    REFERENCES funcionario(id_funcionario),
  CONSTRAINT fk_participa_pedido FOREIGN KEY (id_pedido)
    REFERENCES pedido(id_pedido),
  CONSTRAINT chk_papel_pedido CHECK (
    CHAR_LENGTH(TRIM(papel_participacao)) > 0
  )
) ENGINE=InnoDB;

-- Um funcionário pode ter seus papéis descritos juntos, por exemplo:
-- 'ATENDIMENTO E PRODUCAO', pois há uma linha por funcionário em cada pedido.

CREATE TABLE IF NOT EXISTS estorno (
  id_estorno INT AUTO_INCREMENT PRIMARY KEY,
  id_pagamento INT NOT NULL UNIQUE,
  data_estorno DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  valor_estornado DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_estorno_pagamento FOREIGN KEY (id_pagamento)
    REFERENCES pagamento(id_pagamento),
  CONSTRAINT chk_estorno_valor CHECK (valor_estornado > 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS compra (
  id_compra INT AUTO_INCREMENT PRIMARY KEY,
  data_compra DATE NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS insumo (
  id_insumo INT AUTO_INCREMENT PRIMARY KEY,
  nome_insumo VARCHAR(120) NOT NULL,
  unidade_medida VARCHAR(20) NOT NULL
) ENGINE=InnoDB;

-- Relacionamento N:N COMPRA-INSUMO (ADQUIRE). Não representa estoque.
CREATE TABLE IF NOT EXISTS compra_insumo (
  id_compra INT NOT NULL,
  id_insumo INT NOT NULL,
  quantidade DECIMAL(12,3) NOT NULL,
  custo_unitario DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (id_compra, id_insumo),
  CONSTRAINT fk_compra_insumo_compra FOREIGN KEY (id_compra)
    REFERENCES compra(id_compra),
  CONSTRAINT fk_compra_insumo_insumo FOREIGN KEY (id_insumo)
    REFERENCES insumo(id_insumo),
  CONSTRAINT chk_compra_quantidade CHECK (quantidade > 0),
  CONSTRAINT chk_compra_custo CHECK (custo_unitario >= 0)
) ENGINE=InnoDB;

-- Dados de referência para plataformas.
INSERT IGNORE INTO plataforma (nome_plataforma) VALUES ('iFood'), ('Keeta');

-- Dados fictícios para teste. Não representam cadastro real da empresa.
INSERT INTO produto (nome_produto, preco_produto)
SELECT 'Bolo de chocolate - exemplo', 45.00
WHERE NOT EXISTS (SELECT 1 FROM produto WHERE nome_produto = 'Bolo de chocolate - exemplo');

INSERT INTO produto (nome_produto, preco_produto)
SELECT 'Bolo de cenoura - exemplo', 38.00
WHERE NOT EXISTS (SELECT 1 FROM produto WHERE nome_produto = 'Bolo de cenoura - exemplo');

INSERT INTO funcionario (nome_funcionario, funcao_funcionario)
SELECT 'Funcionário teste 1', 'Gerente e confeiteira'
WHERE NOT EXISTS (SELECT 1 FROM funcionario WHERE nome_funcionario = 'Funcionário teste 1');

INSERT INTO funcionario (nome_funcionario, funcao_funcionario)
SELECT 'Funcionário teste 2', 'Ajudante de cozinha e atendente'
WHERE NOT EXISTS (SELECT 1 FROM funcionario WHERE nome_funcionario = 'Funcionário teste 2');

INSERT INTO funcionario (nome_funcionario, funcao_funcionario)
SELECT 'Funcionário teste 3', 'Entregador'
WHERE NOT EXISTS (SELECT 1 FROM funcionario WHERE nome_funcionario = 'Funcionário teste 3');

INSERT INTO cliente (nome_cliente, telefone_cliente)
SELECT 'Cliente de teste', '(11) 99999-0000'
WHERE NOT EXISTS (SELECT 1 FROM cliente WHERE telefone_cliente = '(11) 99999-0000');

SET @id_cliente_teste = (SELECT id_cliente FROM cliente WHERE telefone_cliente = '(11) 99999-0000' LIMIT 1);
SET @id_produto_teste = (SELECT id_produto FROM produto WHERE nome_produto = 'Bolo de chocolate - exemplo' LIMIT 1);
SET @id_funcionario_teste = (SELECT id_funcionario FROM funcionario WHERE nome_funcionario = 'Funcionário teste 1' LIMIT 1);

INSERT INTO pedido (id_cliente, id_plataforma, data_prevista_atendimento,
                    status_pedido, canal_pedido, tipo_pedido, modalidade_atendimento,
                    data_hora_cancelamento)
SELECT @id_cliente_teste, NULL, DATE_ADD(NOW(), INTERVAL 2 DAY),
       'CANCELADO', 'WHATSAPP', 'ENCOMENDA', 'RETIRADA', NOW()
WHERE NOT EXISTS (
  SELECT 1 FROM pedido
  WHERE id_cliente = @id_cliente_teste AND canal_pedido = 'WHATSAPP' AND status_pedido = 'CANCELADO'
);

SET @id_pedido_teste = (
  SELECT id_pedido FROM pedido
  WHERE id_cliente = @id_cliente_teste AND canal_pedido = 'WHATSAPP' AND status_pedido = 'CANCELADO'
  ORDER BY id_pedido DESC LIMIT 1
);

INSERT IGNORE INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario)
VALUES (@id_pedido_teste, @id_produto_teste, 1, 45.00);

INSERT IGNORE INTO pedido_funcionario (id_funcionario, id_pedido, papel_participacao)
VALUES (@id_funcionario_teste, @id_pedido_teste, 'ATENDIMENTO');

-- Exemplo: encomenda de R$ 45 paga em duas partes e depois cancelada.
-- Os filtros evitam repetir estes dados fictícios ao executar o arquivo novamente.
-- Não são uma regra de cadastro: pagamentos reais podem ter valores iguais.
INSERT INTO pagamento (id_pedido, forma_pagamento, valor_pago)
SELECT @id_pedido_teste, 'PIX', 20.00
WHERE NOT EXISTS (SELECT 1 FROM pagamento WHERE id_pedido = @id_pedido_teste AND valor_pago = 20.00);

INSERT INTO pagamento (id_pedido, forma_pagamento, valor_pago)
SELECT @id_pedido_teste, 'PIX', 25.00
WHERE NOT EXISTS (SELECT 1 FROM pagamento WHERE id_pedido = @id_pedido_teste AND valor_pago = 25.00);

-- Devolução integral: cada pagamento recebe seu próprio estorno.
INSERT INTO estorno (id_pagamento, valor_estornado)
SELECT pg.id_pagamento, pg.valor_pago FROM pagamento pg
WHERE pg.id_pedido = @id_pedido_teste
  AND NOT EXISTS (SELECT 1 FROM estorno e WHERE e.id_pagamento = pg.id_pagamento);

INSERT INTO insumo (nome_insumo, unidade_medida)
SELECT 'Farinha de trigo - exemplo', 'kg'
WHERE NOT EXISTS (SELECT 1 FROM insumo WHERE nome_insumo = 'Farinha de trigo - exemplo');

SET @id_insumo_teste = (SELECT id_insumo FROM insumo WHERE nome_insumo = 'Farinha de trigo - exemplo' LIMIT 1);

-- Data fixa apenas para identificar esta compra fictícia ao repetir o script.
INSERT INTO compra (data_compra)
SELECT '2026-11-01'
WHERE NOT EXISTS (SELECT 1 FROM compra WHERE data_compra = '2026-11-01');
SET @id_compra_teste = (SELECT id_compra FROM compra WHERE data_compra = '2026-11-01' LIMIT 1);

INSERT IGNORE INTO compra_insumo (id_compra, id_insumo, quantidade, custo_unitario)
VALUES (@id_compra_teste, @id_insumo_teste, 2.500, 6.00);

-- MASSA DIDÁTICA COMPLEMENTAR: dados totalmente fictícios.
-- IDs a partir de 10001 identificam os exemplos; execute somente no banco de estudo.
-- Os exemplos servem para testar as consultas e não representam o volume real da empresa.
-- INSERT IGNORE evita repetir os mesmos IDs; não corrige dados já cadastrados.
INSERT IGNORE INTO cliente (id_cliente, nome_cliente, telefone_cliente) VALUES
(10001, 'Cliente fictício 01', 'CONTATO-FICTICIO-01'),
(10002, 'Cliente fictício 02', 'CONTATO-FICTICIO-02'),
(10003, 'Cliente fictício 03', 'CONTATO-FICTICIO-03'),
(10004, 'Cliente fictício 04', 'CONTATO-FICTICIO-04'),
(10005, 'Cliente fictício 05', 'CONTATO-FICTICIO-05'),
(10006, 'Cliente fictício 06', 'CONTATO-FICTICIO-06'),
(10007, 'Cliente fictício 07', 'CONTATO-FICTICIO-07'),
(10008, 'Cliente fictício 08', 'CONTATO-FICTICIO-08'),
(10009, 'Cliente fictício 09', 'CONTATO-FICTICIO-09'),
(10010, 'Cliente fictício 10', 'CONTATO-FICTICIO-10');

INSERT IGNORE INTO produto (id_produto, nome_produto, preco_produto) VALUES
(10001, 'Brigadeiro - fictício', 5.00),
(10002, 'Brownie - fictício', 8.00),
(10003, 'Fatia de bolo - fictício', 12.00),
(10004, 'Bolo pequeno - fictício', 45.00),
(10005, 'Torta - fictícia', 60.00),
(10006, 'Doce sem vendas - fictício', 9.00);

INSERT IGNORE INTO insumo (id_insumo, nome_insumo, unidade_medida) VALUES
(10001, 'Açúcar - fictício', 'kg'),
(10002, 'Chocolate - fictício', 'kg'),
(10003, 'Ovos - fictícios', 'unidade'),
(10004, 'Leite - fictício', 'litro'),
(10005, 'Manteiga - fictícia', 'kg');

-- Três compras fictícias, uma em cada mês, para demonstrar relatórios por período.
INSERT IGNORE INTO compra (id_compra, data_compra) VALUES
(10001, '2026-08-01'), (10002, '2026-09-01'), (10003, '2026-10-01');
INSERT IGNORE INTO compra_insumo
(id_compra, id_insumo, quantidade, custo_unitario) VALUES
(10001, 10001, 10.000, 4.00), (10001, 10002, 4.000, 25.00),
(10001, 10003, 60.000, 0.80), (10002, 10001, 12.000, 4.20),
(10002, 10004, 20.000, 5.00), (10002, 10005, 3.000, 30.00),
(10003, 10002, 5.000, 26.00), (10003, 10003, 90.000, 0.85),
(10003, 10004, 24.000, 5.20);

INSERT IGNORE INTO pedido (id_pedido, id_cliente, id_plataforma, data_hora_pedido, data_prevista_atendimento, data_hora_cancelamento, status_pedido, canal_pedido, tipo_pedido, modalidade_atendimento) VALUES
(10001, NULL, NULL, '2026-08-02 10:00:00', NULL, NULL, 'CONCLUIDO', 'BALCAO', 'IMEDIATO', 'CONSUMO_LOCAL'),
(10002, 10002, NULL, '2026-08-05 10:00:00', '2026-08-05 17:00:00', '2026-08-05 11:00:00', 'CANCELADO', 'WHATSAPP', 'ENCOMENDA', 'RETIRADA'),
(10003, 10003, (SELECT id_plataforma FROM plataforma WHERE nome_plataforma = 'iFood'), '2026-08-08 10:00:00', NULL, NULL, 'CONCLUIDO', 'PLATAFORMA', 'IMEDIATO', 'ENTREGA'),
(10004, 10004, NULL, '2026-08-11 10:00:00', NULL, NULL, 'CONCLUIDO', 'BALCAO', 'IMEDIATO', 'CONSUMO_LOCAL'),
(10005, 10005, NULL, '2026-08-14 10:00:00', '2026-08-14 17:00:00', NULL, 'CONCLUIDO', 'WHATSAPP', 'ENCOMENDA', 'RETIRADA'),
(10006, 10006, (SELECT id_plataforma FROM plataforma WHERE nome_plataforma = 'Keeta'), '2026-08-17 10:00:00', NULL, NULL, 'CONCLUIDO', 'PLATAFORMA', 'IMEDIATO', 'ENTREGA'),
(10007, NULL, NULL, '2026-08-20 10:00:00', NULL, NULL, 'CONCLUIDO', 'BALCAO', 'IMEDIATO', 'CONSUMO_LOCAL'),
(10008, 10008, NULL, '2026-08-23 10:00:00', '2026-08-23 17:00:00', NULL, 'CONCLUIDO', 'WHATSAPP', 'ENCOMENDA', 'RETIRADA'),
(10009, 10001, (SELECT id_plataforma FROM plataforma WHERE nome_plataforma = 'iFood'), '2026-09-02 10:00:00', NULL, '2026-09-02 11:00:00', 'CANCELADO', 'PLATAFORMA', 'IMEDIATO', 'ENTREGA'),
(10010, 10002, NULL, '2026-09-05 10:00:00', NULL, NULL, 'CONCLUIDO', 'BALCAO', 'IMEDIATO', 'CONSUMO_LOCAL'),
(10011, 10003, NULL, '2026-09-08 10:00:00', '2026-09-08 17:00:00', NULL, 'CONCLUIDO', 'WHATSAPP', 'ENCOMENDA', 'RETIRADA'),
(10012, 10004, (SELECT id_plataforma FROM plataforma WHERE nome_plataforma = 'Keeta'), '2026-09-11 10:00:00', NULL, NULL, 'CONCLUIDO', 'PLATAFORMA', 'IMEDIATO', 'ENTREGA'),
(10013, NULL, NULL, '2026-09-14 10:00:00', NULL, NULL, 'CONCLUIDO', 'BALCAO', 'IMEDIATO', 'CONSUMO_LOCAL'),
(10014, 10006, NULL, '2026-09-17 10:00:00', '2026-09-17 17:00:00', NULL, 'CONCLUIDO', 'WHATSAPP', 'ENCOMENDA', 'RETIRADA'),
(10015, 10007, (SELECT id_plataforma FROM plataforma WHERE nome_plataforma = 'iFood'), '2026-09-20 10:00:00', NULL, '2026-09-20 11:00:00', 'CANCELADO', 'PLATAFORMA', 'IMEDIATO', 'ENTREGA'),
(10016, 10008, NULL, '2026-09-23 10:00:00', NULL, NULL, 'CONCLUIDO', 'BALCAO', 'IMEDIATO', 'CONSUMO_LOCAL'),
(10017, 10001, NULL, '2026-10-02 10:00:00', '2026-10-02 17:00:00', NULL, 'CONCLUIDO', 'WHATSAPP', 'ENCOMENDA', 'RETIRADA'),
(10018, 10002, (SELECT id_plataforma FROM plataforma WHERE nome_plataforma = 'Keeta'), '2026-10-05 10:00:00', NULL, NULL, 'CONCLUIDO', 'PLATAFORMA', 'IMEDIATO', 'ENTREGA'),
(10019, NULL, NULL, '2026-10-08 10:00:00', NULL, NULL, 'CONCLUIDO', 'BALCAO', 'IMEDIATO', 'CONSUMO_LOCAL'),
(10020, 10004, NULL, '2026-10-11 10:00:00', '2026-10-11 17:00:00', NULL, 'CONCLUIDO', 'WHATSAPP', 'ENCOMENDA', 'RETIRADA'),
(10021, 10005, (SELECT id_plataforma FROM plataforma WHERE nome_plataforma = 'iFood'), '2026-10-14 10:00:00', NULL, NULL, 'CONCLUIDO', 'PLATAFORMA', 'IMEDIATO', 'ENTREGA'),
(10022, 10006, NULL, '2026-10-17 10:00:00', NULL, NULL, 'ABERTO', 'BALCAO', 'IMEDIATO', 'CONSUMO_LOCAL'),
(10023, 10007, NULL, '2026-10-20 10:00:00', '2026-10-20 17:00:00', NULL, 'EM_PREPARO', 'WHATSAPP', 'ENCOMENDA', 'RETIRADA'),
(10024, 10008, (SELECT id_plataforma FROM plataforma WHERE nome_plataforma = 'Keeta'), '2026-10-23 10:00:00', NULL, NULL, 'CONCLUIDO', 'PLATAFORMA', 'IMEDIATO', 'ENTREGA');

INSERT IGNORE INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(10001, 10001, 2, 5.00),
(10001, 10002, 1, 8.00),
(10002, 10002, 3, 8.00),
(10002, 10003, 1, 12.00),
(10003, 10003, 1, 12.00),
(10003, 10004, 1, 45.00),
(10004, 10004, 2, 45.00),
(10004, 10005, 1, 60.00),
(10005, 10005, 3, 60.00),
(10005, 10001, 1, 5.00),
(10006, 10001, 1, 5.00),
(10006, 10002, 1, 8.00),
(10007, 10002, 2, 8.00),
(10007, 10003, 1, 12.00),
(10008, 10003, 3, 12.00),
(10008, 10004, 1, 45.00),
(10009, 10004, 1, 45.00),
(10009, 10005, 1, 60.00),
(10010, 10005, 2, 60.00),
(10010, 10001, 1, 5.00),
(10011, 10001, 3, 5.00),
(10011, 10002, 1, 8.00),
(10012, 10002, 1, 8.00),
(10012, 10003, 1, 12.00),
(10013, 10003, 2, 12.00),
(10013, 10004, 1, 45.00),
(10014, 10004, 3, 45.00),
(10014, 10005, 1, 60.00),
(10015, 10005, 1, 60.00),
(10015, 10001, 1, 5.00),
(10016, 10001, 2, 5.00),
(10016, 10002, 1, 8.00),
(10017, 10002, 3, 8.00),
(10017, 10003, 1, 12.00),
(10018, 10003, 1, 12.00),
(10018, 10004, 1, 45.00),
(10019, 10004, 2, 45.00),
(10019, 10005, 1, 60.00),
(10020, 10005, 3, 60.00),
(10020, 10001, 1, 5.00),
(10021, 10001, 1, 5.00),
(10021, 10002, 1, 8.00),
(10022, 10002, 2, 8.00),
(10022, 10003, 1, 12.00),
(10023, 10003, 3, 12.00),
(10023, 10004, 1, 45.00),
(10024, 10004, 1, 45.00),
(10024, 10005, 1, 60.00);

INSERT IGNORE INTO pedido_funcionario (id_funcionario, id_pedido, papel_participacao) VALUES
(@id_funcionario_teste, 10001, 'ATENDIMENTO E PRODUCAO'),
(@id_funcionario_teste, 10002, 'ATENDIMENTO E PRODUCAO'),
(@id_funcionario_teste, 10003, 'ATENDIMENTO E PRODUCAO'),
(@id_funcionario_teste, 10004, 'ATENDIMENTO E PRODUCAO'),
(@id_funcionario_teste, 10005, 'ATENDIMENTO E PRODUCAO'),
(@id_funcionario_teste, 10006, 'ATENDIMENTO E PRODUCAO'),
(@id_funcionario_teste, 10007, 'ATENDIMENTO E PRODUCAO'),
(@id_funcionario_teste, 10008, 'ATENDIMENTO E PRODUCAO'),
(@id_funcionario_teste, 10009, 'ATENDIMENTO E PRODUCAO'),
(@id_funcionario_teste, 10010, 'ATENDIMENTO E PRODUCAO'),
(@id_funcionario_teste, 10011, 'ATENDIMENTO E PRODUCAO'),
(@id_funcionario_teste, 10012, 'ATENDIMENTO E PRODUCAO'),
(@id_funcionario_teste, 10013, 'ATENDIMENTO E PRODUCAO'),
(@id_funcionario_teste, 10014, 'ATENDIMENTO E PRODUCAO'),
(@id_funcionario_teste, 10015, 'ATENDIMENTO E PRODUCAO'),
(@id_funcionario_teste, 10016, 'ATENDIMENTO E PRODUCAO'),
(@id_funcionario_teste, 10017, 'ATENDIMENTO E PRODUCAO'),
(@id_funcionario_teste, 10018, 'ATENDIMENTO E PRODUCAO'),
(@id_funcionario_teste, 10019, 'ATENDIMENTO E PRODUCAO'),
(@id_funcionario_teste, 10020, 'ATENDIMENTO E PRODUCAO'),
(@id_funcionario_teste, 10021, 'ATENDIMENTO E PRODUCAO'),
(@id_funcionario_teste, 10022, 'ATENDIMENTO E PRODUCAO'),
(@id_funcionario_teste, 10023, 'ATENDIMENTO E PRODUCAO'),
(@id_funcionario_teste, 10024, 'ATENDIMENTO E PRODUCAO');

INSERT IGNORE INTO pagamento (id_pagamento, id_pedido, data_pagamento, forma_pagamento, valor_pago) VALUES
(10001, 10001, '2026-08-02 10:05:00', 'PIX', 18.00),
(10002, 10002, '2026-08-05 10:05:00', 'CARTAO', 36.00),
(10004, 10004, '2026-08-11 10:05:00', 'PIX', 150.00),
(10005, 10005, '2026-08-14 10:05:00', 'CARTAO', 185.00),
(10007, 10007, '2026-08-20 10:05:00', 'PIX', 28.00),
(10008, 10008, '2026-08-23 10:05:00', 'CARTAO', 81.00),
(10010, 10010, '2026-09-05 10:05:00', 'PIX', 125.00),
(10011, 10011, '2026-09-08 10:05:00', 'CARTAO', 23.00),
(10013, 10013, '2026-09-14 10:05:00', 'PIX', 69.00),
(10014, 10014, '2026-09-17 10:05:00', 'CARTAO', 195.00),
(10016, 10016, '2026-09-23 10:05:00', 'PIX', 18.00),
(10017, 10017, '2026-10-02 10:05:00', 'CARTAO', 36.00),
(10019, 10019, '2026-10-08 10:05:00', 'PIX', 150.00),
(10020, 10020, '2026-10-11 10:05:00', 'CARTAO', 185.00),
(10023, 10023, '2026-10-20 10:05:00', 'CARTAO', 81.00);

INSERT IGNORE INTO estorno (id_estorno, id_pagamento, data_estorno, valor_estornado) VALUES
(10002, 10002, '2026-08-05 11:05:00', 36.00);

-- CONSULTAS DE CONFERÊNCIA (SELECT)
-- Mostra todos os clientes cadastrados, com nome e telefone.
-- Serve para conferir os dados de contato dos clientes.
SELECT * FROM cliente;
-- Mostra os produtos cadastrados em ordem de nome.
-- Serve para consultar o cardápio e os preços atuais.
SELECT * FROM produto ORDER BY nome_produto;

-- Mostra os pedidos com cliente, datas, canal, plataforma e situação, dos mais recentes aos mais antigos.
-- Serve para acompanhar os pedidos, inclusive os que não têm cliente cadastrado.
SELECT p.id_pedido, c.nome_cliente AS cliente, p.data_hora_pedido,
       p.data_prevista_atendimento, p.canal_pedido, pl.nome_plataforma,
       p.status_pedido
FROM pedido p
LEFT JOIN cliente c ON p.id_cliente = c.id_cliente
LEFT JOIN plataforma pl ON p.id_plataforma = pl.id_plataforma
ORDER BY p.data_hora_pedido DESC;

-- Mostra os produtos de cada pedido, com quantidade, preço unitário e subtotal.
-- Serve para conferir os itens e o valor de cada um no pedido.
SELECT co.id_pedido, pr.nome_produto, co.quantidade, co.preco_unitario,
       (co.quantidade * co.preco_unitario) AS subtotal
FROM item_pedido co
JOIN produto pr ON co.id_produto = pr.id_produto
ORDER BY co.id_pedido;

-- Mostra o valor total de cada pedido, somando os subtotais dos itens.
-- Serve para conferir o total usando os preços registrados na venda.
SELECT p.id_pedido,
       COALESCE(SUM(co.quantidade * co.preco_unitario), 0) AS total_pedido
FROM pedido p
LEFT JOIN item_pedido co ON p.id_pedido = co.id_pedido
GROUP BY p.id_pedido;

-- Mostra os funcionários que participam de cada pedido e o papel de cada um.
-- Serve para conferir quem ficou responsável pelas atividades do pedido.
SELECT p.id_pedido, f.nome_funcionario AS funcionario, pp.papel_participacao
FROM pedido_funcionario pp
JOIN funcionario f ON pp.id_funcionario = f.id_funcionario
JOIN pedido p ON pp.id_pedido = p.id_pedido
ORDER BY p.id_pedido, f.nome_funcionario;

-- Mostra os pagamentos registrados, dos mais recentes aos mais antigos.
-- Serve para conferir os valores recebidos e as formas de pagamento.
SELECT * FROM pagamento ORDER BY data_pagamento DESC;

-- Mostra a quantidade de pedidos de cada canal de venda.
-- Serve para comparar quantos pedidos vieram do WhatsApp, balcão e plataformas.
SELECT canal_pedido, COUNT(*) AS quantidade_pedidos
FROM pedido GROUP BY canal_pedido;

-- Mostra os estornos, com o pagamento, o pedido e o valor devolvido.
-- Serve para conferir as devoluções registradas nos pagamentos diretos.
SELECT e.id_estorno, pg.id_pedido, e.id_pagamento, e.valor_estornado
FROM estorno e
JOIN pagamento pg ON e.id_pagamento = pg.id_pagamento;

-- Mostra os insumos de cada compra, com unidade, quantidade, custo unitário e subtotal.
-- Serve para conferir os ingredientes comprados e o custo de cada item.
SELECT c.id_compra, c.data_compra, i.nome_insumo, i.unidade_medida,
       ci.quantidade, ci.custo_unitario,
       ci.quantidade * ci.custo_unitario AS subtotal_compra
FROM compra c
JOIN compra_insumo ci ON c.id_compra = ci.id_compra
JOIN insumo i ON ci.id_insumo = i.id_insumo;

-- Mostra o valor total de cada compra, somando os subtotais dos insumos.
-- Serve para conferir o gasto registrado em cada compra.
SELECT c.id_compra, COALESCE(SUM(ci.quantidade * ci.custo_unitario), 0) AS total_compra
FROM compra c
LEFT JOIN compra_insumo ci ON c.id_compra = ci.id_compra
GROUP BY c.id_compra;

-- EXEMPLOS DE UPDATE E DELETE
-- A transação desfaz os exemplos ao final, preservando os dados de estudo.
-- Execute o bloco inteiro, de START TRANSACTION até ROLLBACK.
START TRANSACTION;

-- Altera a descrição de um produto fictício para demonstrar uma atualização com filtro.
-- O ROLLBACK abaixo desfaz esta mudança; os preços históricos dos pedidos não mudam.
UPDATE produto
SET descricao_produto = 'Descrição de exemplo para a apresentação'
WHERE id_produto = 10006 AND nome_produto = 'Doce sem vendas - fictício';

-- Mostra a descrição alterada dentro da transação.
-- Serve para conferir o resultado do UPDATE antes de desfazê-lo.
SELECT id_produto, nome_produto, descricao_produto
FROM produto WHERE id_produto = 10006;

-- Remove somente o produto fictício sem venda e sem vínculo com itens de pedido.
-- O ROLLBACK restaura o produto; pedidos e pagamentos não são apagados.
DELETE FROM produto
WHERE id_produto = 10006 AND nome_produto = 'Doce sem vendas - fictício'
  AND NOT EXISTS (SELECT 1 FROM item_pedido WHERE id_produto = 10006);

-- Mostra se o produto fictício ainda existe após o DELETE.
-- Serve para conferir a exclusão temporária; neste ponto deve retornar zero linhas.
SELECT id_produto, nome_produto FROM produto WHERE id_produto = 10006;

ROLLBACK;

-- CONSULTAS GERENCIAIS
-- GROUP BY reúne linhas por mês, canal ou produto; SUM soma e COUNT conta.
-- DATE_FORMAT exibe ano e mês; ROUND arredonda o resultado.
-- Em G03, UNION ALL reúne entradas e devoluções antes de calcular o saldo.
-- G01 — Qual é o valor dos pedidos concluídos e o ticket médio por mês?
-- Atende: P1, KPI01 e KPI02; soma vendas concluídas, não o caixa recebido.
SELECT DATE_FORMAT(p.data_hora_pedido, '%Y-%m') AS mes,
       COUNT(DISTINCT p.id_pedido) AS pedidos_concluidos,
       SUM(ip.quantidade * ip.preco_unitario) AS valor_vendas,
       ROUND(SUM(ip.quantidade * ip.preco_unitario) / COUNT(DISTINCT p.id_pedido), 2) AS ticket_medio
FROM pedido p JOIN item_pedido ip ON p.id_pedido = ip.id_pedido
WHERE p.status_pedido = 'CONCLUIDO'
GROUP BY DATE_FORMAT(p.data_hora_pedido, '%Y-%m')
ORDER BY mes;

-- G02 — Quanto foi vendido por mês, canal e plataforma?
-- Atende: P1 e KPI03; ajuda a comparar a origem das vendas concluídas.
SELECT DATE_FORMAT(p.data_hora_pedido, '%Y-%m') AS mes,
       p.canal_pedido, pl.nome_plataforma,
       COUNT(DISTINCT p.id_pedido) AS quantidade_pedidos,
       SUM(ip.quantidade * ip.preco_unitario) AS valor_vendas
FROM pedido p JOIN item_pedido ip ON p.id_pedido = ip.id_pedido
LEFT JOIN plataforma pl ON p.id_plataforma = pl.id_plataforma
WHERE p.status_pedido = 'CONCLUIDO'
GROUP BY DATE_FORMAT(p.data_hora_pedido, '%Y-%m'), p.canal_pedido, pl.nome_plataforma
ORDER BY mes, p.canal_pedido, pl.nome_plataforma;

-- G03 — Quanto entrou e foi devolvido nos canais diretos em cada mês?
-- Atende: P2 e KPI04; o saldo é recebimentos menos estornos, sem repasses ou despesas.
SELECT mes, SUM(recebido) AS total_recebido, SUM(devolvido) AS total_devolvido,
       SUM(recebido) - SUM(devolvido) AS saldo_recebimentos_diretos
FROM (
  SELECT DATE_FORMAT(pg.data_pagamento, '%Y-%m') AS mes,
         pg.valor_pago AS recebido, 0 AS devolvido
  FROM pagamento pg JOIN pedido p ON pg.id_pedido = p.id_pedido
  WHERE p.canal_pedido IN ('WHATSAPP','BALCAO')
  UNION ALL
  SELECT DATE_FORMAT(e.data_estorno, '%Y-%m') AS mes,
         0 AS recebido, e.valor_estornado AS devolvido
  FROM estorno e JOIN pagamento pg ON e.id_pagamento = pg.id_pagamento
  JOIN pedido p ON pg.id_pedido = p.id_pedido
  WHERE p.canal_pedido IN ('WHATSAPP','BALCAO')
) movimentos
GROUP BY mes ORDER BY mes;

-- G04 — Quais produtos venderam mais em cada mês?
-- Atende: P1; mostra quantidades e valores dos itens de pedidos concluídos.
SELECT DATE_FORMAT(p.data_hora_pedido, '%Y-%m') AS mes, pr.nome_produto,
       SUM(ip.quantidade) AS unidades_vendidas,
       SUM(ip.quantidade * ip.preco_unitario) AS valor_vendas
FROM pedido p JOIN item_pedido ip ON p.id_pedido = ip.id_pedido
JOIN produto pr ON ip.id_produto = pr.id_produto
WHERE p.status_pedido = 'CONCLUIDO'
GROUP BY DATE_FORMAT(p.data_hora_pedido, '%Y-%m'), pr.id_produto, pr.nome_produto
ORDER BY mes, unidades_vendidas DESC, pr.nome_produto;

-- G05 — Qual é o percentual de pedidos cancelados por mês de origem?
-- Atende: P2 e KPI05; compara cancelados com todos os pedidos criados no mês.
SELECT DATE_FORMAT(data_hora_pedido, '%Y-%m') AS mes,
       COUNT(*) AS pedidos,
       SUM(CASE WHEN status_pedido = 'CANCELADO' THEN 1 ELSE 0 END) AS cancelados,
       ROUND(100.0 * SUM(CASE WHEN status_pedido = 'CANCELADO' THEN 1 ELSE 0 END) / COUNT(*), 2) AS percentual_cancelado
FROM pedido
GROUP BY DATE_FORMAT(data_hora_pedido, '%Y-%m') ORDER BY mes;

-- G06 — Qual é o gasto com insumos comprados em cada mês?
-- Atende: P3 e KPI06; mede compras, sem calcular estoque, consumo ou lucro.
SELECT DATE_FORMAT(c.data_compra, '%Y-%m') AS mes,
       COUNT(DISTINCT c.id_compra) AS quantidade_compras,
       SUM(ci.quantidade * ci.custo_unitario) AS gasto_com_insumos
FROM compra c JOIN compra_insumo ci ON c.id_compra = ci.id_compra
GROUP BY DATE_FORMAT(c.data_compra, '%Y-%m') ORDER BY mes;

-- G07 — Quais encomendas ainda precisam ser preparadas ou atendidas?
-- Atende: P1; organiza as encomendas abertas ou em preparo pela data prevista.
SELECT p.id_pedido, c.nome_cliente, p.data_prevista_atendimento,
       p.modalidade_atendimento, p.status_pedido
FROM pedido p LEFT JOIN cliente c ON p.id_cliente = c.id_cliente
WHERE p.tipo_pedido = 'ENCOMENDA' AND p.status_pedido IN ('ABERTO','EM_PREPARO')
ORDER BY p.data_prevista_atendimento, p.id_pedido;

-- CONFERÊNCIA DAS REGRAS ENTRE TABELAS
-- CHECK verifica a própria linha. Estas consultas verificam outras tabelas.
-- Elas devem retornar zero linhas nos exemplos abaixo. Não impedem gravações.
-- Antes de usar dados reais, essas regras também precisam ser validadas no cadastro.

-- Pedidos de aplicativo não podem ter pagamentos internos.
-- A01 — Há pagamento interno de pedido de aplicativo?
-- Verifica: RN11.
-- Mostra os pagamentos internos ligados a pedidos de aplicativo.
-- Serve para encontrar registros que não deveriam existir, pois o aplicativo cuida do pagamento.
SELECT pg.id_pagamento, pg.id_pedido
FROM pagamento pg JOIN pedido p ON pg.id_pedido = p.id_pedido
WHERE p.canal_pedido = 'PLATAFORMA';

-- Um estorno não pode superar o pagamento original.
-- A02 — Algum estorno é maior que o pagamento?
-- Verifica: RN21.
-- Mostra os estornos com valor maior que o pagamento original.
-- Serve para encontrar devoluções registradas acima do valor recebido.
SELECT e.id_estorno FROM estorno e
JOIN pagamento pg ON e.id_pagamento = pg.id_pagamento
WHERE e.valor_estornado > pg.valor_pago;

-- Cada recebimento de encomenda WhatsApp cancelada deve ser devolvido integralmente.
-- A03 — Falta devolver integralmente algum pagamento de encomenda WhatsApp cancelada?
-- Verifica: RN20.
-- Mostra os pagamentos de encomendas WhatsApp canceladas sem estorno ou com valor devolvido diferente do pago.
-- Serve para conferir se cada pagamento dessas encomendas foi devolvido integralmente.
SELECT pg.id_pagamento, pg.valor_pago, e.valor_estornado
FROM pedido p JOIN pagamento pg ON p.id_pedido = pg.id_pedido
LEFT JOIN estorno e ON pg.id_pagamento = e.id_pagamento
WHERE p.canal_pedido = 'WHATSAPP' AND p.tipo_pedido = 'ENCOMENDA'
  AND p.status_pedido = 'CANCELADO'
  AND (e.id_estorno IS NULL OR e.valor_estornado <> pg.valor_pago);

-- Todo pedido deve ter itens e toda compra deve ter insumos.
-- A04 — Existe pedido sem item?
-- Verifica: RN05.
-- Mostra os pedidos que não têm nenhum item registrado.
-- Serve para encontrar pedidos que precisam ter seus produtos conferidos.
SELECT p.id_pedido FROM pedido p
WHERE NOT EXISTS (SELECT 1 FROM item_pedido ip WHERE ip.id_pedido = p.id_pedido);
-- A05 — Existe compra sem insumo?
-- Verifica: RN25.
-- Mostra as compras que não têm nenhum insumo registrado.
-- Serve para encontrar compras que precisam ter seus itens conferidos.
SELECT c.id_compra FROM compra c
WHERE NOT EXISTS (SELECT 1 FROM compra_insumo ci WHERE ci.id_compra = c.id_compra);

-- Encomendas WhatsApp e pedidos diretos concluídos devem estar pagos integralmente.
-- Somamos pagamentos e itens separadamente para não multiplicar os valores no JOIN.
-- A06 — Existe encomenda WhatsApp ou pedido direto concluído sem pagamento integral?
-- Verifica: RN09, RN19 e RN29.
-- Mostra pedidos diretos não cancelados com pagamento diferente do total: encomendas WhatsApp ou pedidos concluídos.
-- Serve para conferir o pagamento integral exigido nesses casos; a consulta apenas aponta diferenças.
SELECT p.id_pedido FROM pedido p
WHERE p.canal_pedido IN ('WHATSAPP','BALCAO') AND p.status_pedido <> 'CANCELADO'
  AND (p.status_pedido = 'CONCLUIDO' OR
       (p.canal_pedido = 'WHATSAPP' AND p.tipo_pedido = 'ENCOMENDA'))
  AND COALESCE((SELECT SUM(pg.valor_pago) FROM pagamento pg WHERE pg.id_pedido = p.id_pedido), 0)
      <> COALESCE((SELECT SUM(ip.quantidade * ip.preco_unitario) FROM item_pedido ip WHERE ip.id_pedido = p.id_pedido), 0);

-- FIM DO SCRIPT
