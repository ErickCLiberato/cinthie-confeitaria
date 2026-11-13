# Validação da revisão — 13/11/2026

Executada pelo Codex em uma instância temporária de **MySQL 8.0.46**, usando apenas os dados fictícios do projeto. A revisão do grupo e a confirmação dos processos reais continuam necessárias.

## Execução e preservação

- O script completo executou sem erro em banco inicialmente vazio, criando as 12 tabelas.
- Uma segunda execução produziu a mesma saída, sem duplicar os exemplos.
- Os comandos do SQL anterior foram comparados com a versão revisada: todos foram preservados, na mesma ordem. Foram acrescentados dados e comandos de demonstração, consultas gerenciais e comentários.
- O UPDATE alterou a descrição de um produto fictício; o DELETE o removeu temporariamente. O ROLLBACK restaurou o produto e sua descrição original.
- G01–G07 retornaram resultados; A01–A06 retornaram zero linhas na massa válida.

## Quantidade de registros após a carga

| Tabela | Registros |
|---|---:|
| cliente | 11 |
| funcionario | 3 |
| produto | 8 |
| plataforma | 2 |
| pedido | 25 |
| pagamento | 17 |
| item_pedido | 49 |
| pedido_funcionario | 25 |
| estorno | 3 |
| compra | 4 |
| insumo | 6 |
| compra_insumo | 10 |

As contagens incluem os exemplos anteriores. O tamanho é didático e provisório: ainda falta justificar o volume com os números reais do levantamento.

## Resultados conferidos

| Mês | Vendas concluídas (G01) | Pedidos concluídos | Ticket médio |
|---|---:|---:|---:|
| 2026-08 | R$ 532,00 | 7 | R$ 76,00 |
| 2026-09 | R$ 450,00 | 6 | R$ 75,00 |
| 2026-10 | R$ 546,00 | 6 | R$ 91,00 |

G03 retornou recebimentos/devoluções/saldo de R$ 498,00/R$ 36,00/R$ 462,00 em agosto; R$ 430,00/R$ 0,00/R$ 430,00 em setembro; R$ 452,00/R$ 0,00/R$ 452,00 em outubro. O exemplo anterior acrescentou R$ 45,00 recebidos e R$ 45,00 devolvidos no mês da execução, ficando com saldo zero. Não são valores reais da confeitaria, nem lucro ou repasses dos aplicativos.

G06 retornou compras de R$ 188,00, R$ 240,40 e R$ 331,30 em agosto, setembro e outubro, respectivamente, além de R$ 15,00 no exemplo de novembro. Esses valores não medem consumo nem saldo de estoque.

## Auditorias com erro temporário

Para cada caso, a consulta retornou zero linhas antes, **uma linha** com a inconsistência e zero novamente após ROLLBACK. Os [blocos SQL](demonstracao_auditorias.sql) permitem reproduzir a demonstração no banco de estudo.

| Consulta | Erro simulado e desfeito |
|---|---|
| A01 | Inserido um pagamento interno de pedido de aplicativo. |
| A02 | Aumentado um estorno acima do pagamento original. |
| A03 | Removido o estorno de encomenda WhatsApp cancelada. |
| A04 | Removidos os itens de um pedido. |
| A05 | Removidos os insumos de uma compra. |
| A06 | Reduzido o valor recebido de pedido direto concluído. |

As auditorias detectam esses problemas, mas não bloqueiam a gravação. ROLLBACK desfaz alterações de dados; o contador AUTO_INCREMENT pode avançar durante testes e não precisa ser sequencial.

## Restrições conferidas

O MySQL rejeitou preço negativo, quantidade zero, encomenda sem data prevista e pedido de plataforma sem plataforma vinculada (erro 3819/CHECK); pagamento para pedido inexistente (1452/FK); segundo estorno para o mesmo pagamento (1062/UNIQUE). As tentativas ocorreram em transações de teste, sem manter dados inválidos.

## Limites desta validação

A execução verifica o SQL e os cenários descritos. Não comprova os volumes reais, a cobertura de todos os processos, o cumprimento de LGPD ou regras fiscais/sanitárias, a implementação de acessos/logs, nem a conformidade visual do DER com o material do professor. Slides, dados pendentes da entrevista e comparação do dicionário com o PDF de exemplo ainda precisam ser concluídos.
