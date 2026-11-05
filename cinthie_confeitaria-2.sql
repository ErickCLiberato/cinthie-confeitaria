-- PROJETO CINTHIE CONFEITARIA
-- Script SQL para MySQL 8.0.16+
-- DDL: criação das tabelas | DML: dados de teste | SELECT: conferência
-- Os relacionamentos N:N são convertidos em tabelas associativas no modelo lógico.

CREATE DATABASE IF NOT EXISTS cinthie_confeitaria
  CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE cinthie_confeitaria;

CREATE TABLE IF NOT EXISTS cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  telefone VARCHAR(20) NOT NULL,
  INDEX idx_cliente_telefone (telefone)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS funcionario (
  id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  funcao VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS produto (
  id_produto INT AUTO_INCREMENT PRIMARY KEY,
  nome_produto VARCHAR(100) NOT NULL,
  preco DECIMAL(10,2) NOT NULL,
  CONSTRAINT chk_produto_preco CHECK (preco >= 0)
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
  data_entrega_retirada DATETIME NULL,
  status_pedido VARCHAR(30) NOT NULL DEFAULT 'PENDENTE',
  canal_pedido VARCHAR(30) NOT NULL,
  CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente)
    REFERENCES cliente(id_cliente),
  CONSTRAINT fk_pedido_plataforma FOREIGN KEY (id_plataforma)
    REFERENCES plataforma(id_plataforma),
  CONSTRAINT chk_pedido_status CHECK (
    status_pedido IN ('PENDENTE','EM_PREPARO','PRONTO','FINALIZADO','CANCELADO')
  ),
  CONSTRAINT chk_pedido_canal CHECK (
    canal_pedido IN ('WHATSAPP','BALCAO','PLATAFORMA')
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
  id_pedido INT NOT NULL UNIQUE,
  data_pagamento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  forma_pagamento VARCHAR(40) NULL,
  valor_pago DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_pagamento_pedido FOREIGN KEY (id_pedido)
    REFERENCES pedido(id_pedido),
  CONSTRAINT chk_pagamento_valor CHECK (valor_pago >= 0),
  CONSTRAINT chk_pagamento_forma CHECK (
    forma_pagamento IS NULL OR
    forma_pagamento IN ('DINHEIRO','PIX','CARTAO')
  ),
  INDEX idx_pagamento_data (data_pagamento)
) ENGINE=InnoDB;

-- Relacionamento N:N PEDIDO-PRODUTO (CONTÉM).
-- quantidade e preco_unitario são atributos do relacionamento.
-- subtotal e total do pedido são calculados nas consultas.
CREATE TABLE IF NOT EXISTS contem (
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
CREATE TABLE IF NOT EXISTS participa_pedido (
  id_funcionario INT NOT NULL,
  id_pedido INT NOT NULL,
  papel_no_pedido VARCHAR(30) NOT NULL,
  PRIMARY KEY (id_funcionario, id_pedido, papel_no_pedido),
  CONSTRAINT fk_participa_funcionario FOREIGN KEY (id_funcionario)
    REFERENCES funcionario(id_funcionario),
  CONSTRAINT fk_participa_pedido FOREIGN KEY (id_pedido)
    REFERENCES pedido(id_pedido),
  CONSTRAINT chk_papel_pedido CHECK (
    papel_no_pedido IN ('ATENDIMENTO','PRODUCAO','ENTREGA')
  )
) ENGINE=InnoDB;

-- Dados de referência para plataformas.
INSERT IGNORE INTO plataforma (nome_plataforma) VALUES ('iFood'), ('Keeta');

-- Dados fictícios para teste. Não representam cadastro real da empresa.
INSERT INTO produto (nome_produto, preco)
SELECT 'Bolo de chocolate - exemplo', 45.00
WHERE NOT EXISTS (SELECT 1 FROM produto WHERE nome_produto = 'Bolo de chocolate - exemplo');

INSERT INTO produto (nome_produto, preco)
SELECT 'Bolo de cenoura - exemplo', 38.00
WHERE NOT EXISTS (SELECT 1 FROM produto WHERE nome_produto = 'Bolo de cenoura - exemplo');

INSERT INTO funcionario (nome, funcao)
SELECT 'Funcionário teste 1', 'Gerente e confeiteira'
WHERE NOT EXISTS (SELECT 1 FROM funcionario WHERE nome = 'Funcionário teste 1');

INSERT INTO funcionario (nome, funcao)
SELECT 'Funcionário teste 2', 'Ajudante de cozinha e atendente'
WHERE NOT EXISTS (SELECT 1 FROM funcionario WHERE nome = 'Funcionário teste 2');

INSERT INTO funcionario (nome, funcao)
SELECT 'Funcionário teste 3', 'Entregador'
WHERE NOT EXISTS (SELECT 1 FROM funcionario WHERE nome = 'Funcionário teste 3');

INSERT INTO cliente (nome, telefone)
SELECT 'Cliente de teste', '(11) 99999-0000'
WHERE NOT EXISTS (SELECT 1 FROM cliente WHERE telefone = '(11) 99999-0000');

SET @id_cliente_teste = (SELECT id_cliente FROM cliente WHERE telefone = '(11) 99999-0000' LIMIT 1);
SET @id_produto_teste = (SELECT id_produto FROM produto WHERE nome_produto = 'Bolo de chocolate - exemplo' LIMIT 1);
SET @id_funcionario_teste = (SELECT id_funcionario FROM funcionario WHERE nome = 'Funcionário teste 1' LIMIT 1);

INSERT INTO pedido (id_cliente, id_plataforma, data_entrega_retirada, status_pedido, canal_pedido)
SELECT @id_cliente_teste, NULL, DATE_ADD(NOW(), INTERVAL 2 DAY), 'PENDENTE', 'WHATSAPP'
WHERE NOT EXISTS (
  SELECT 1 FROM pedido
  WHERE id_cliente = @id_cliente_teste AND canal_pedido = 'WHATSAPP' AND status_pedido = 'PENDENTE'
);

SET @id_pedido_teste = (
  SELECT id_pedido FROM pedido
  WHERE id_cliente = @id_cliente_teste AND canal_pedido = 'WHATSAPP' AND status_pedido = 'PENDENTE'
  ORDER BY id_pedido DESC LIMIT 1
);

INSERT IGNORE INTO contem (id_pedido, id_produto, quantidade, preco_unitario)
VALUES (@id_pedido_teste, @id_produto_teste, 1, 45.00);

INSERT IGNORE INTO participa_pedido (id_funcionario, id_pedido, papel_no_pedido)
VALUES (@id_funcionario_teste, @id_pedido_teste, 'ATENDIMENTO');

INSERT INTO pagamento (id_pedido, forma_pagamento, valor_pago)
SELECT @id_pedido_teste, 'PIX', 45.00
WHERE NOT EXISTS (SELECT 1 FROM pagamento WHERE id_pedido = @id_pedido_teste);

-- CONSULTAS DE CONFERÊNCIA (SELECT)
SELECT * FROM cliente;
SELECT * FROM produto ORDER BY nome_produto;

SELECT p.id_pedido, c.nome AS cliente, p.data_hora_pedido,
       p.data_entrega_retirada, p.canal_pedido, pl.nome_plataforma,
       p.status_pedido
FROM pedido p
LEFT JOIN cliente c ON p.id_cliente = c.id_cliente
LEFT JOIN plataforma pl ON p.id_plataforma = pl.id_plataforma
ORDER BY p.data_hora_pedido DESC;

SELECT co.id_pedido, pr.nome_produto, co.quantidade, co.preco_unitario,
       (co.quantidade * co.preco_unitario) AS subtotal
FROM contem co
JOIN produto pr ON co.id_produto = pr.id_produto
ORDER BY co.id_pedido;

SELECT p.id_pedido,
       COALESCE(SUM(co.quantidade * co.preco_unitario), 0) AS total_pedido
FROM pedido p
LEFT JOIN contem co ON p.id_pedido = co.id_pedido
GROUP BY p.id_pedido;

SELECT p.id_pedido, f.nome AS funcionario, pp.papel_no_pedido
FROM participa_pedido pp
JOIN funcionario f ON pp.id_funcionario = f.id_funcionario
JOIN pedido p ON pp.id_pedido = p.id_pedido
ORDER BY p.id_pedido, f.nome;

SELECT * FROM pagamento ORDER BY data_pagamento DESC;

SELECT canal_pedido, COUNT(*) AS quantidade_pedidos
FROM pedido GROUP BY canal_pedido;

-- FIM DO SCRIPT
