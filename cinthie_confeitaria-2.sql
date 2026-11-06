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

-- CONSULTAS DE CONFERÊNCIA (SELECT)
SELECT * FROM cliente;
SELECT * FROM produto ORDER BY nome_produto;

SELECT p.id_pedido, c.nome_cliente AS cliente, p.data_hora_pedido,
       p.data_prevista_atendimento, p.canal_pedido, pl.nome_plataforma,
       p.status_pedido
FROM pedido p
LEFT JOIN cliente c ON p.id_cliente = c.id_cliente
LEFT JOIN plataforma pl ON p.id_plataforma = pl.id_plataforma
ORDER BY p.data_hora_pedido DESC;

SELECT co.id_pedido, pr.nome_produto, co.quantidade, co.preco_unitario,
       (co.quantidade * co.preco_unitario) AS subtotal
FROM item_pedido co
JOIN produto pr ON co.id_produto = pr.id_produto
ORDER BY co.id_pedido;

SELECT p.id_pedido,
       COALESCE(SUM(co.quantidade * co.preco_unitario), 0) AS total_pedido
FROM pedido p
LEFT JOIN item_pedido co ON p.id_pedido = co.id_pedido
GROUP BY p.id_pedido;

SELECT p.id_pedido, f.nome_funcionario AS funcionario, pp.papel_participacao
FROM pedido_funcionario pp
JOIN funcionario f ON pp.id_funcionario = f.id_funcionario
JOIN pedido p ON pp.id_pedido = p.id_pedido
ORDER BY p.id_pedido, f.nome_funcionario;

SELECT * FROM pagamento ORDER BY data_pagamento DESC;

SELECT canal_pedido, COUNT(*) AS quantidade_pedidos
FROM pedido GROUP BY canal_pedido;

SELECT e.id_estorno, pg.id_pedido, e.id_pagamento, e.valor_estornado
FROM estorno e
JOIN pagamento pg ON e.id_pagamento = pg.id_pagamento;

SELECT c.id_compra, c.data_compra, i.nome_insumo, i.unidade_medida,
       ci.quantidade, ci.custo_unitario,
       ci.quantidade * ci.custo_unitario AS subtotal_compra
FROM compra c
JOIN compra_insumo ci ON c.id_compra = ci.id_compra
JOIN insumo i ON ci.id_insumo = i.id_insumo;

SELECT c.id_compra, COALESCE(SUM(ci.quantidade * ci.custo_unitario), 0) AS total_compra
FROM compra c
LEFT JOIN compra_insumo ci ON c.id_compra = ci.id_compra
GROUP BY c.id_compra;

-- CONFERÊNCIA DAS REGRAS ENTRE TABELAS
-- CHECK verifica a própria linha. Estas consultas verificam outras tabelas.
-- Elas devem retornar zero linhas nos exemplos abaixo. Não impedem gravações.
-- Antes de usar dados reais, essas regras também precisam ser validadas no cadastro.

-- Pedidos de aplicativo não podem ter pagamentos internos.
SELECT pg.id_pagamento, pg.id_pedido
FROM pagamento pg JOIN pedido p ON pg.id_pedido = p.id_pedido
WHERE p.canal_pedido = 'PLATAFORMA';

-- Um estorno não pode superar o pagamento original.
SELECT e.id_estorno FROM estorno e
JOIN pagamento pg ON e.id_pagamento = pg.id_pagamento
WHERE e.valor_estornado > pg.valor_pago;

-- Cada recebimento de encomenda WhatsApp cancelada deve ser devolvido integralmente.
SELECT pg.id_pagamento, pg.valor_pago, e.valor_estornado
FROM pedido p JOIN pagamento pg ON p.id_pedido = pg.id_pedido
LEFT JOIN estorno e ON pg.id_pagamento = e.id_pagamento
WHERE p.canal_pedido = 'WHATSAPP' AND p.tipo_pedido = 'ENCOMENDA'
  AND p.status_pedido = 'CANCELADO'
  AND (e.id_estorno IS NULL OR e.valor_estornado <> pg.valor_pago);

-- Todo pedido deve ter itens e toda compra deve ter insumos.
SELECT p.id_pedido FROM pedido p
WHERE NOT EXISTS (SELECT 1 FROM item_pedido ip WHERE ip.id_pedido = p.id_pedido);
SELECT c.id_compra FROM compra c
WHERE NOT EXISTS (SELECT 1 FROM compra_insumo ci WHERE ci.id_compra = c.id_compra);

-- Encomendas WhatsApp e pedidos diretos concluídos devem estar pagos integralmente.
-- Somamos pagamentos e itens separadamente para não multiplicar os valores no JOIN.
SELECT p.id_pedido FROM pedido p
WHERE p.canal_pedido IN ('WHATSAPP','BALCAO') AND p.status_pedido <> 'CANCELADO'
  AND (p.status_pedido = 'CONCLUIDO' OR
       (p.canal_pedido = 'WHATSAPP' AND p.tipo_pedido = 'ENCOMENDA'))
  AND COALESCE((SELECT SUM(pg.valor_pago) FROM pagamento pg WHERE pg.id_pedido = p.id_pedido), 0)
      <> COALESCE((SELECT SUM(ip.quantidade * ip.preco_unitario) FROM item_pedido ip WHERE ip.id_pedido = p.id_pedido), 0);

-- FIM DO SCRIPT
