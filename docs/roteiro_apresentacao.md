# Roteiro de apresentação — 8 minutos

Apresentação do problema, da solução e dos resultados do banco de dados, com demonstração das consultas.

| Tempo | Slide/etapa | Conteúdo e demonstração |
|---|---|---|
| 0:00–1:00 | Problema | Cinthiê, três funcionários, canais e informações dispersas; P1–P3. |
| 1:00–2:00 | Solução | Centralizar pedidos, itens, pagamentos diretos, estornos e compras. |
| 2:00–3:15 | Modelo lógico | Mostrar as 12 tabelas; explicar ITEM_PEDIDO e o preço histórico; PK/FK e ESTORNO por pagamento. |
| 3:15–4:15 | SQL rodando | Banco de estudo previamente preparado; mostrar tabelas e executar o bloco UPDATE/DELETE inteiro, terminando em ROLLBACK. |
| 4:15–6:00 | Consultas | G01 (vendas/ticket), G03 (recebido e devolvido), G06 (compras) e A01/A03 (zero linhas na massa válida). |
| 6:00–7:00 | BI e IA | Comparar meses/canais e cancelamentos; previsão só depois de obter histórico real suficiente. |
| 7:00–8:00 | Benefícios | Menos consolidação manual, preservação do preço histórico e conferência de devoluções. |

## Falas de apoio: empresa, proposta e limites

Os trechos abaixo acompanham as etapas de problema, solução e benefícios.

**Situação atual:** “Hoje, a confeitaria recebe pedidos pelo WhatsApp, balcão, iFood e Keeta. Usa Excel e outros controles para organizar as informações e fazer a conferência administrativa ao final do expediente, incluindo pagamentos e repasses.”

**Proposta do grupo:** “Nosso projeto organiza os registros em um banco de dados, relacionando clientes, pedidos, produtos, pagamentos diretos e funcionários. As consultas SQL permitem consultar essas informações em conjunto.”

**Exemplo:** “Se um cliente encomenda um bolo pelo WhatsApp, registramos o cliente, a encomenda e sua data prevista, o bolo e a quantidade, o preço praticado, o pagamento antecipado e o funcionário que participou. No SQL, os itens ficam em `item_pedido` e a participação fica em `pedido_funcionario`.”

**Limites:** “Desenvolvemos a estrutura do banco e as consultas. Ainda não há telas, entrada automática de pedidos, controle de estoque em tempo real ou substituição automática das planilhas. O banco registra pagamentos diretos; pagamentos e estornos de aplicativos continuam nas plataformas, e seus repasses ainda não são registrados no nosso modelo. O projeto não realiza pagamentos nem entregas.”

O registro dos dados depende de inserção no banco. Telas e integrações podem utilizar o banco como base. No diagrama conceitual, CONTÉM é um relacionamento; no SQL, a tabela correspondente é `item_pedido`. 

A [comparação completa no README](../README.md#empresa-e-projeto) contém a tabela de melhorias e os seis passos do exemplo.

## Preparação

Executar o script completo em banco vazio de estudo e conferir os resultados descritos em validacao.md. Abrir o diagrama e as consultas antes da apresentação. Não executar sobre dados reais. Não apresentar saldo de recebimentos como lucro nem vendas de aplicativos como repasses recebidos.

## Defesa após o pitch

Todos os integrantes devem estar presentes. Cada aluno responde individualmente à pergunta dirigida a ele. Estudar: por que há tabela associativa; diferença entre preço atual e histórico; PK composta; cliente opcional; motivo de não haver pagamento interno de aplicativo; total derivado; limitações de CHECK; por que zero linhas na auditoria é o resultado esperado. Definir falas e contribuições com o grupo e ensaiar o tempo.
