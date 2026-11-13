# Roteiro de apresentação — 8 minutos

Material de preparação; slides finais ainda precisam ser montados e ensaiados pelo grupo. Usar títulos curtos, diagrama e resultados de consultas em vez de parágrafos longos.

| Tempo | Slide/etapa | Conteúdo e demonstração |
|---|---|---|
| 0:00–1:00 | Problema | Cinthiê, três funcionários, canais e informações dispersas; P1–P3. |
| 1:00–2:00 | Solução | Centralizar pedidos, itens, pagamentos diretos, estornos e compras; explicar limites ainda em validação. |
| 2:00–3:15 | Modelo lógico | Mostrar as 12 tabelas; explicar ITEM_PEDIDO e o preço histórico; PK/FK e ESTORNO por pagamento. |
| 3:15–4:15 | SQL rodando | Banco de estudo previamente preparado; mostrar tabelas e executar o bloco UPDATE/DELETE inteiro, terminando em ROLLBACK. |
| 4:15–6:00 | Consultas | G01 (vendas/ticket), G03 (recebido e devolvido), G06 (compras) e A01/A03 (zero linhas na massa válida). |
| 6:00–7:00 | BI e IA | Comparar meses/canais e cancelamentos; previsão só depois de obter histórico real suficiente. |
| 7:00–8:00 | Benefícios | Menos consolidação manual, preço histórico e conferência de devoluções; apresentar as pendências com transparência. |

## Preparação

Executar o script completo em banco vazio de estudo e conferir os resultados descritos em validacao.md. Abrir o diagrama e as consultas antes da apresentação. Não executar sobre dados reais. Não apresentar saldo de recebimentos como lucro nem vendas de aplicativos como repasses recebidos.

## Defesa após o pitch

Todos os integrantes devem estar presentes. Cada aluno responde individualmente à pergunta dirigida a ele. Estudar: por que há tabela associativa; diferença entre preço atual e histórico; PK composta; cliente opcional; motivo de não haver pagamento interno de aplicativo; total derivado; limitações de CHECK; por que zero linhas na auditoria é o resultado esperado. Definir falas e contribuições com o grupo e ensaiar o tempo.
