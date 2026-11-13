-- Exemplos de auditoria: somente no banco fictício de estudo.
-- Execute cada bloco inteiro. O ROLLBACK desfaz o erro criado para demonstração.
USE cinthie_confeitaria_v3;

-- A01: cria uma inconsistência temporária para a consulta encontrar.
START TRANSACTION;
INSERT INTO pagamento (id_pedido, forma_pagamento, valor_pago) VALUES (10003, 'PIX', 10);
SELECT pg.id_pagamento, pg.id_pedido
FROM pagamento pg JOIN pedido p ON pg.id_pedido = p.id_pedido
WHERE p.canal_pedido = 'PLATAFORMA';
ROLLBACK;

-- A02: cria uma inconsistência temporária para a consulta encontrar.
START TRANSACTION;
UPDATE estorno SET valor_estornado=9999 WHERE id_estorno=10002;
SELECT e.id_estorno FROM estorno e
JOIN pagamento pg ON e.id_pagamento = pg.id_pagamento
WHERE e.valor_estornado > pg.valor_pago;
ROLLBACK;

-- A03: cria uma inconsistência temporária para a consulta encontrar.
START TRANSACTION;
DELETE FROM estorno WHERE id_estorno=10002;
SELECT pg.id_pagamento, pg.valor_pago, e.valor_estornado
FROM pedido p JOIN pagamento pg ON p.id_pedido = pg.id_pedido
LEFT JOIN estorno e ON pg.id_pagamento = e.id_pagamento
WHERE p.canal_pedido = 'WHATSAPP' AND p.tipo_pedido = 'ENCOMENDA'
  AND p.status_pedido = 'CANCELADO'
  AND (e.id_estorno IS NULL OR e.valor_estornado <> pg.valor_pago);
ROLLBACK;

-- A04: cria uma inconsistência temporária para a consulta encontrar.
START TRANSACTION;
DELETE FROM item_pedido WHERE id_pedido=10001;
SELECT p.id_pedido FROM pedido p
WHERE NOT EXISTS (SELECT 1 FROM item_pedido ip WHERE ip.id_pedido = p.id_pedido);
ROLLBACK;

-- A05: cria uma inconsistência temporária para a consulta encontrar.
START TRANSACTION;
DELETE FROM compra_insumo WHERE id_compra=10001;
SELECT c.id_compra FROM compra c
WHERE NOT EXISTS (SELECT 1 FROM compra_insumo ci WHERE ci.id_compra = c.id_compra);
ROLLBACK;

-- A06: cria uma inconsistência temporária para a consulta encontrar.
START TRANSACTION;
UPDATE pagamento SET valor_pago=valor_pago-1 WHERE id_pagamento=10001;
SELECT p.id_pedido FROM pedido p
WHERE p.canal_pedido IN ('WHATSAPP','BALCAO') AND p.status_pedido <> 'CANCELADO'
  AND (p.status_pedido = 'CONCLUIDO' OR
       (p.canal_pedido = 'WHATSAPP' AND p.tipo_pedido = 'ENCOMENDA'))
  AND COALESCE((SELECT SUM(pg.valor_pago) FROM pagamento pg WHERE pg.id_pedido = p.id_pedido), 0)
      <> COALESCE((SELECT SUM(ip.quantidade * ip.preco_unitario) FROM item_pedido ip WHERE ip.id_pedido = p.id_pedido), 0);
ROLLBACK;
