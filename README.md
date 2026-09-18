# Entrega 1 — Modelo Conceitual (DER)
## Sistema de gestão de informações da Cinthiê Confeitaria

## Metadados

- **Integrantes e RGM:**
- Douglas Lourenço de Lima RGM: 47892919
- Erick Costa Liberato RGM: 48201693
- Giovanna Pereira Bispo da Silva RGM: 48065285
- João Lucas Moreira dos Reis RGM: 48162086
- Nicolas Nogueira Borges RGM: 48329266
###
- **Disciplina:** Modelagem de Banco de Dados
###
- **Organização analisada:** Cinthiê Confeitaria

---

## 1. Caracterização da Organização

### Nome e natureza da organização

A organização analisada é a **Cinthiê Confeitaria**, empresa do ramo alimentício que fabrica e comercializa produtos de confeitaria no mesmo estabelecimento.

### Contexto e porte

Segundo a entrevista realizada com o gerente, a confeitaria possui três funcionários. Foram identificadas funções relacionadas à gestão, produção, apoio na cozinha e atendimento: gerente, confeiteira, ajudante de cozinha e atendente. Como foram informados três funcionários e quatro funções, este trabalho registra apenas as funções identificadas, sem atribuir uma função específica a cada pessoa.

Os pedidos podem ser realizados diretamente pelo WhatsApp ou pelas plataformas iFood e Keeta. As entregas relacionadas às plataformas são realizadas por motoboys terceirizados; portanto, esses entregadores não são tratados como funcionários da confeitaria.

### Problemas e necessidades identificados

Atualmente, as informações da organização estão distribuídas entre WhatsApp, planilhas do Microsoft Excel e plataformas de venda. Parte do controle administrativo é realizada ao final do expediente, o que torna a organização e a consolidação das informações mais demoradas.

O sistema proposto busca centralizar os dados de clientes, pedidos, produtos, pagamentos, plataformas e funcionários envolvidos nas operações, reduzindo o tempo gasto na organização das informações e facilitando consultas e controles.

### Justificativa da escolha

A Cinthiê Confeitaria foi escolhida por sua presença na região e pela frequência de estudantes universitários da UNICID entre seu público. Além de ser acessível ao grupo para a realização da entrevista, a organização não utiliza um banco de dados próprio, o que a torna adequada para a proposta de centralização das informações por meio de um banco de dados.

### Evidências da organização

![Sucesso1](assets/imagem.jpeg)

---

## 2. Processos de Negócio

Os processos de negócio identificados foram:

1. **Atendimento e registro de clientes:** atendimento realizado principalmente pelo WhatsApp e registro das informações necessárias para os pedidos.
2. **Recebimento e registro de pedidos:** registro de pedidos originados pelo WhatsApp, iFood ou Keeta.
3. **Composição do pedido:** inclusão dos produtos e respectivas quantidades em cada pedido.
4. **Fabricação e venda dos produtos:** produção e comercialização dos produtos de confeitaria no estabelecimento.
5. **Registro de pagamentos:** registro dos pagamentos realizados em dinheiro, cartão ou Pix.
6. **Acompanhamento de vendas por plataforma:** identificação dos pedidos originados pelo iFood ou Keeta e acompanhamento dos repasses semanais dessas plataformas.
7. **Controle administrativo:** consolidação das informações administrativas, atualmente apoiada por planilhas Excel e parcialmente executada ao final do expediente.

---

## 3. Requisitos do Sistema

### 3.1 Requisitos Funcionais

| Código | Requisito funcional |
|---|---|
| RF01 | O sistema deve permitir cadastrar clientes. |
| RF02 | O sistema deve permitir consultar clientes cadastrados. |
| RF03 | O sistema deve permitir registrar pedidos. |
| RF04 | O sistema deve permitir consultar pedidos registrados. |
| RF05 | O sistema deve permitir cadastrar produtos. |
| RF06 | O sistema deve permitir consultar produtos cadastrados. |
| RF07 | O sistema deve permitir incluir um ou mais produtos em cada pedido. |
| RF08 | O sistema deve permitir registrar pagamentos. |
| RF09 | O sistema deve permitir registrar a forma de pagamento utilizada: dinheiro, cartão ou Pix. |
| RF10 | O sistema deve permitir identificar o canal de origem de cada pedido. |
| RF11 | O sistema deve permitir vincular um pedido originado por plataforma ao iFood ou à Keeta. |
| RF12 | O sistema deve permitir consultar informações de vendas por período, produto, canal e plataforma. |

---

## 4. Regras de Negócio

| Código | Regra de negócio |
|---|---|
| RN01 | Todo pagamento registrado deve possuir uma forma de pagamento. |
| RN02 | As formas de pagamento utilizadas pela organização são dinheiro, cartão e Pix. |
| RN03 | Todo pedido deve registrar seu canal de origem: WhatsApp ou plataforma de venda. |
| RN04 | WhatsApp é um canal de pedido direto e não é uma plataforma de venda. |
| RN05 | As plataformas utilizadas pela organização são iFood e Keeta. |
| RN06 | Todo pedido originado por plataforma deve identificar a plataforma correspondente. Pedidos originados pelo WhatsApp não possuem plataforma vinculada. |
| RN07 | Um pedido deve conter um ou mais itens de pedido. |
| RN08 | Cada item de pedido deve referir-se a um único produto e registrar quantidade e preço unitário praticado no pedido. |
| RN09 | O subtotal do item é calculado pela quantidade multiplicada pelo preço unitário. |
| RN10 | O total do pedido é calculado pela soma dos subtotais dos itens. |
| RN11 | Cada pedido finalizado possui um pagamento registrado. |
| RN12 | Os repasses das plataformas são acompanhados semanalmente, com ocorrência informada às quartas-feiras. |

> **Decisão de escopo:** o acompanhamento de repasses é uma informação confirmada na entrevista. Nesta Entrega 1, ele é registrado como regra de negócio; uma entidade específica para repasse só será criada se o grupo decidir incluí-la no modelo lógico da Entrega 2.

---

## 5. Dicionário de Dados Conceitual (Preliminar)

### CLIENTE

| Atributo | Descrição | Regra de negócio associada |
|---|---|---|
| id_cliente | Identificador único do cliente. | Chave primária da entidade. |
| nome | Nome do cliente. | — |
| telefone | Número de telefone utilizado no contato. | — |

### FUNCIONARIO

| Atributo | Descrição | Regra de negócio associada |
|---|---|---|
| id_funcionario | Identificador único do funcionário. | Chave primária da entidade. |
| nome | Nome do funcionário. | — |
| funcao | Função identificada durante a entrevista. | Pode representar gerente, confeiteira, ajudante de cozinha ou atendente. |

### PRODUTO

| Atributo | Descrição | Regra de negócio associada |
|---|---|---|
| id_produto | Identificador único do produto. | Chave primária da entidade. |
| nome_produto | Nome do produto comercializado. | — |
| preco | Preço atual do produto. | O preço praticado em uma venda é registrado em Item_Pedido. |

### PEDIDO

| Atributo | Descrição | Regra de negócio associada |
|---|---|---|
| id_pedido | Identificador único do pedido. | Chave primária da entidade. |
| data_hora_pedido | Data e horário do registro do pedido. | — |
| canal_pedido | Canal de origem do pedido. | Aceita WhatsApp ou Plataforma. |
| total_pedido | Valor total do pedido. | Atributo derivado da soma dos subtotais dos itens. |

### ITEM_PEDIDO

| Atributo | Descrição | Regra de negócio associada |
|---|---|---|
| id_item_pedido | Identificador único do item de pedido. | Chave primária da entidade. |
| quantidade | Quantidade do produto solicitada no item. | Deve ser maior que zero. |
| preco_unitario | Preço do produto praticado no momento do pedido. | Preserva o valor da venda, mesmo que o preço atual do produto seja alterado. |
| subtotal | Valor parcial do item. | Atributo derivado: quantidade × preco_unitario. |

### PAGAMENTO

| Atributo | Descrição | Regra de negócio associada |
|---|---|---|
| id_pagamento | Identificador único do pagamento. | Chave primária da entidade. |
| data_pagamento | Data do registro do pagamento. | — |
| forma_pagamento | Forma utilizada para pagamento. | Aceita dinheiro, cartão ou Pix. |
| valor_pago | Valor registrado no pagamento. | — |

### PLATAFORMA

| Atributo | Descrição | Regra de negócio associada |
|---|---|---|
| id_plataforma | Identificador único da plataforma. | Chave primária da entidade. |
| nome_plataforma | Nome da plataforma de venda. | Aceita iFood ou Keeta. |

---

## 6. Modelagem Conceitual

### Entidades reconhecidas

| Entidade | Justificativa |
|---|---|
| CLIENTE | Representa as pessoas atendidas pela confeitaria e permite organizar seus dados de contato. |
| FUNCIONARIO | Representa os colaboradores envolvidos na operação e no registro de pedidos. |
| PRODUTO | Representa os produtos comercializados pela confeitaria. |
| PEDIDO | Representa cada solicitação de compra realizada pelos clientes. |
| ITEM_PEDIDO | Resolve a relação muitos-para-muitos entre Pedido e Produto e registra quantidade e preço praticado. |
| PAGAMENTO | Representa o pagamento associado ao pedido. |
| PLATAFORMA | Identifica os pedidos originados por iFood ou Keeta. |

### Relacionamentos e cardinalidades

| Relacionamento | Cardinalidade | Justificativa |
|---|---|---|
| Cliente realiza Pedido | Cliente (0,N) — Pedido (0,1) | Um cliente pode realizar vários pedidos; o modelo não obriga que todo pedido tenha cliente cadastrado. |
| Funcionário registra Pedido | Funcionário (0,N) — Pedido (0,1) | Um funcionário pode registrar vários pedidos; o vínculo é opcional porque essa obrigatoriedade não foi confirmada na entrevista. |
| Pedido contém Item_Pedido | Pedido (1,N) — Item_Pedido (1,1) | Todo pedido possui um ou mais itens; cada item pertence a um único pedido. |
| Item_Pedido refere-se a Produto | Item_Pedido (1,1) — Produto (0,N) | Cada item representa um produto; um produto pode aparecer em vários itens de pedidos. |
| Pedido possui Pagamento | Pedido (1,1) — Pagamento (1,1) | Decisão de modelagem: cada pedido finalizado possui um pagamento registrado. |
| Pedido origina-se de Plataforma | Pedido (0,1) — Plataforma (0,N) | Um pedido pode não estar vinculado a plataforma quando for recebido por WhatsApp; uma plataforma pode originar diversos pedidos. |

### Restrições aplicadas ao modelo

- WhatsApp é tratado como canal de pedido direto, não como plataforma.
- iFood e Keeta são as plataformas identificadas na entrevista.
- Motoboys não são entidades ou funcionários, pois são terceirizados pelas plataformas.
- Não foram incluídas entidades de estoque, ingredientes, fornecedor, categoria ou entrega porque não houve confirmação de necessidade para este escopo.
- Gerente, confeiteira, ajudante de cozinha e atendente foram tratados como valores possíveis de `funcao` em FUNCIONARIO, sem criar entidades separadas.

---

## 7. Diagrama Entidade-Relacionamento (DER)

O diagrama conceitual utiliza a notação de Chen e apresenta as entidades, atributos, relacionamentos e cardinalidades descritos neste documento.

> Inserir no repositório a imagem `diagramas/der_conceitual_cinthie_confeitaria_fundo_branco.png` e ajustar o caminho abaixo, se necessário.

![DER conceitual da Cinthiê Confeitaria](diagramas/der_conceitual_cinthie_confeitaria_fundo_branco.png)

---

## 8. Justificativa Técnica

O modelo foi elaborado para centralizar as informações que hoje estão distribuídas entre WhatsApp, Excel, iFood e Keeta, sem adicionar processos que não foram confirmados na entrevista.

A entidade **Item_Pedido** foi necessária para representar corretamente a relação entre pedidos e produtos. Um pedido pode conter vários produtos e um produto pode aparecer em vários pedidos. Além disso, quantidade e preço unitário pertencem à ocorrência de venda, e não apenas ao produto cadastrado.

As entidades **Gerente**, **Confeiteiro** e **Entregador** não foram mantidas como entidades independentes. Gerente, confeiteira, ajudante de cozinha e atendente são funções identificadas e foram representadas pelo atributo `funcao` de FUNCIONARIO. Os motoboys são terceirizados pelas plataformas, não funcionários da confeitaria.

A entidade **Plataforma** foi mantida para diferenciar pedidos originados por iFood e Keeta. O WhatsApp foi representado pelo atributo `canal_pedido`, pois é um canal de pedido direto e não uma plataforma de vendas.

Os atributos `subtotal` e `total_pedido` são derivados, pois podem ser calculados a partir dos itens do pedido. Essa decisão evita inconsistências entre quantidade, preço unitário e valores totais.

---

## 9. Uso de Inteligência Artificial

| Item | Registro |
|---|---|
| Ferramenta e etapa | ChatGPT/Codex foi utilizado para organizar informações da entrevista, revisar requisitos, discutir regras de negócio e apoiar a elaboração do DER e deste README. |
| Motivação | Estruturar o trabalho conforme o esqueleto da disciplina e verificar a coerência do modelo. |
| Prompt(s) utilizados | _Inserir os prompts principais utilizados pelo grupo._ |
| Sugestões recebidas | Foram sugeridas entidades, relacionamentos, cardinalidades e melhorias de redação. |
| Trechos rejeitados ou corrigidos | Foram rejeitadas sugestões que adicionavam entidades sem confirmação, como estoque, ingredientes, fornecedor, categoria, entrega e entregador. |
| Justificativa da escolha final | O grupo manteve apenas as decisões compatíveis com a entrevista realizada com o gerente. |
| Reflexão crítica | A IA foi usada como apoio de organização e revisão. O grupo verificou as sugestões e corrigiu informações que não estavam confirmadas pela entrevista, como o tratamento do WhatsApp como canal de pedido e não como plataforma. |

---

## Próximas Etapas

Para a Entrega 2, o grupo deverá converter este modelo conceitual em modelo lógico relacional, definir PKs e FKs, normalizar as tabelas, criar o script SQL, elaborar massa de dados fictícia, executar consultas e documentar os resultados no repositório GitHub.
