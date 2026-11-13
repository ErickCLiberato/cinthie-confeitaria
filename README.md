# Cinthiê Confeitaria — Entrega 2

Modelo lógico, implementação SQL e apresentação final — Modelagem de Banco de Dados.

**Revisão:** 13/11/2026. Este README é o Relatório Técnico Final em elaboração, organizado conforme o esqueleto do professor. Os itens pendentes são indicados explicitamente; não representam levantamento concluído.

## 1. Relatório Técnico Final

### Integrantes

| Nome completo | RGM | Usuário do GitHub |
|---|---|---|
| Douglas Lourenço de Lima | 47892919 | [Douglastail](https://github.com/Douglastail) |
| Erick Costa Liberato | 48201693 | ErickCLiberato |
| João Lucas Moreira dos Reis | 48162086 | [JoaoReeis](https://github.com/JoaoReeis) |
| Nicolas Nogueira Borges | 48329266 | [nogueiranicolas95-bot](https://github.com/nogueiranicolas95-bot) |

### 1.1 Revisão do Modelo Conceitual

#### Nome e natureza da organização

A organização analisada é a **Cinthiê Confeitaria**, empresa do ramo alimentício que fabrica e comercializa produtos de confeitaria no próprio estabelecimento.

#### Contexto e porte

Segundo a entrevista realizada com a responsável pelo estabelecimento, a confeitaria possui três funcionários. As atividades são distribuídas da seguinte forma:

- uma funcionária exerce as funções de **gerente e confeiteira**;
- um funcionário exerce as funções de **ajudante de cozinha e responsável pelo atendimento no balcão**;
- um funcionário exerce a função de **motoboy/entregador**.

A confeitaria atende clientes **no próprio salão, com mesas para consumo no local**, além de realizar vendas no **balcão**, receber **encomendas pelo WhatsApp** e receber **pedidos de entrega no mesmo dia pelos aplicativos iFood e Keeta**. WhatsApp e balcão são canais diretos; iFood e Keeta são plataformas de venda. **Os aplicativos não são utilizados para encomendas agendadas.**

Há **produtos prontos para venda no balcão e consumo nas mesas**, além de encomendas contratadas pelo WhatsApp e pedidos de entrega no dia pelos aplicativos. A produção relatada inclui atividades aos **domingos e às quartas-feiras**, sem pressupor que toda a produção se limite a esses dias. A **compra de insumos é realizada uma vez por mês**. O modelo registra compras mensais e itens adquiridos, mas não implementa controle de estoque de ingredientes ou produtos prontos; essa é uma delimitação do sistema proposto, e não a afirmação de inexistência de mercadorias disponíveis no estabelecimento.

#### Problemas e necessidades identificados

Atualmente, as informações da organização estão distribuídas entre WhatsApp, planilhas do Microsoft Excel e plataformas de venda. Parte do controle administrativo é realizada ao final do expediente, o que torna a organização e a consolidação das informações mais demoradas.

O sistema proposto busca centralizar os dados de clientes, pedidos, produtos, pagamentos diretos, eventuais estornos, plataformas, funcionários, insumos e compras, reduzindo o tempo gasto na consolidação de informações.

#### Empresa e projeto

**Como funciona atualmente — Cinthiê Confeitaria.** Conforme a explicação fornecida pelo grupo, o controle administrativo é feito em planilhas Excel. Os pedidos chegam pelo WhatsApp, balcão, iFood e Keeta, deixando informações distribuídas entre canais. A conferência e a organização administrativa são realizadas ao final do expediente e incluem pagamentos e repasses das plataformas.

**O que propomos — projeto do grupo.** Um banco de dados para centralizar os registros de clientes, pedidos, produtos, pagamentos diretos, plataformas e funcionários envolvidos. As consultas SQL permitem buscar e relacionar essas informações. A estrutura também inclui compras, insumos e estornos diretos, conforme o modelo já documentado.

| Situação identificada pelo grupo | Melhoria proposta no banco |
|---|---|
| Informações de clientes em controles diferentes | Cadastro em `cliente`, relacionado aos pedidos quando houver cliente identificado. |
| Pedidos recebidos por vários canais | `pedido` com identificação do canal e da plataforma, quando aplicável. |
| Necessidade de relacionar produtos aos pedidos | `item_pedido` com produto, quantidade e preço praticado na venda. |
| Conferência de pagamentos diretos | `pagamento` com valor, data e forma de pagamento; `estorno` quando houver devolução. |
| Vendas pelo iFood e Keeta | `plataforma` vinculada ao pedido; pagamentos e estornos continuam nos aplicativos. |
| Participação dos funcionários nos pedidos | `pedido_funcionario` com o papel de cada participante. |
| Consulta em diferentes controles | Consultas SQL sobre os registros centralizados. |

**Nomes no conceitual e no SQL:** o relacionamento CONTÉM é representado pela tabela lógica `item_pedido`; a participação de funcionários é representada por `pedido_funcionario`. Portanto, `CONTEM` e `PARTICIPA_PEDIDO` não são nomes de tabelas do script atual.

**Exemplo para explicar ao professor.** Um cliente encomenda um bolo pelo WhatsApp. No funcionamento atual, as informações podem ser acompanhadas em controles diferentes. Na proposta do grupo, o registro relaciona:

1. O cliente em `cliente`.
2. A encomenda, sua data prevista e situação em `pedido`.
3. O bolo e sua quantidade em `item_pedido`, vinculado a `produto`.
4. O preço unitário praticado na encomenda, preservado em `item_pedido`.
5. O pagamento antecipado, seu valor e forma de recebimento em `pagamento`.
6. O funcionário envolvido e seu papel em `pedido_funcionario`.

Assim, as informações registradas podem ser consultadas em conjunto por SQL. Esses registros precisam ser inseridos no banco; não há integração automática com o WhatsApp.

**O que o projeto ainda não faz.** A entrega atual é uma estrutura de banco de dados com script e consultas, sem telas para os funcionários utilizarem. Ela não importa pedidos automaticamente do WhatsApp, iFood ou Keeta, não controla estoque em tempo real, não substitui automaticamente as planilhas e não realiza pagamentos nem entregas. A conferência de repasses existe na rotina administrativa descrita pelo grupo, mas o banco atual não registra repasses ou taxas dos aplicativos.

Telas e integrações podem ser desenvolvidas futuramente usando o banco como base. Isso não elimina a pendência de validar a cobertura dos dados exigida pelo professor: representar os dados de um processo e automatizar sua execução são trabalhos diferentes.

#### Justificativa da escolha

A Cinthiê Confeitaria foi escolhida por ser uma organização real de pequeno porte e por permitir ao grupo a realização de pesquisa de campo. O estabelecimento possui uma rotina que envolve atendimento ao cliente, recebimento de pedidos por diferentes canais, fabricação sob demanda, pagamentos, entregas e controle administrativo, o que possibilita identificar entidades, atributos e relacionamentos relevantes para a elaboração de um modelo conceitual de dados.

Além disso, a utilização de WhatsApp, planilhas e plataformas de venda demonstra a existência de diferentes fontes de informação que podem ser organizadas de forma centralizada por meio de um banco de dados.

#### Evidências da organização

Como evidências da pesquisa de campo, foram realizadas fotografias do estabelecimento e uma gravação de áudio da entrevista com a responsável pela confeitaria. Esses materiais foram utilizados para apoiar o levantamento das informações, respeitando a autorização e a privacidade das pessoas envolvidas.

![Evidência da organização](assets/imagem.jpeg)

**Endereço do estabelecimento:** R. Césario Galero, 262, Tatuapé — São Paulo — SP, CEP 03071-000.

#### Problemas de gestão e escopo

Os códigos abaixo organizam as necessidades já descritas no levantamento; não acrescentam novos fatos sobre a organização.

| Código | Problema ou necessidade identificada | Resposta do modelo |
|---|---|---|
| P1 | Informações de pedidos e vendas dispersas entre WhatsApp, Excel e plataformas, dificultando a consolidação ao final do expediente. | Centralizar pedidos, itens, produtos, canais, plataformas e datas. |
| P2 | Necessidade de centralizar a conferência de pagamentos diretos e eventuais devoluções. | Relacionar pedido, pagamento e estorno, mantendo o histórico. |
| P3 | Necessidade de reunir os registros de compras e insumos mencionados na proposta. | Registrar compra, insumo, quantidade e custo unitário. |

**Escopo a validar:** o modelo atual cobre clientes, vendas, equipe participante, pagamentos diretos, devoluções e compras. Estoque, fornecedores, dados de endereço de entrega, repasses, obrigações fiscais e escalas ainda não estão modelados. O roteiro exige cobertura de todos os dados da organização; portanto, essa cobertura permanece uma pendência e as exclusões anteriores não comprovam atendimento à exigência. O grupo precisa confirmar os processos e ampliar o modelo quando necessário, sem criar fornecedores, taxas ou práticas inexistentes.

#### Resumo da entrevista e das evidências

O README anterior relata entrevista presencial com a responsável e gravação de áudio. A foto existente está em [assets/imagem.jpeg](assets/imagem.jpeg); a correção da Entrega 1 reconhece nela o contato presencial. A data, o nome e contato da entrevistada, os participantes e a separação dos achados de observação e de entrevista não estão documentados. O [levantamento organizado](levantamento/levantamento.md) reúne o que já foi registrado e as perguntas que faltam responder. O áudio não substitui esse texto.

**Volumes conhecidos:** três funcionários e compras mensais. Pedidos por mês, clientes ativos e valores médios ainda precisam ser informados. Não é possível justificar o tamanho final da massa com esses dados incompletos.

#### Processos de negócio

Os processos a seguir combinam **rotinas relatadas no levantamento** com **etapas que precisam ser confirmadas na entrevista complementar**. O fluxo descreve operações reais ou relevantes à caracterização da confeitaria; sua inclusão nesta seção **não significa** que todas serão implementadas no banco de dados do modelo atual.

##### 1.1.1 Atendimento e identificação de clientes

- **Entrada:** solicitação presencial, mensagem de WhatsApp ou pedido recebido pela plataforma.
- **Atividades:** entender a solicitação; identificar o cliente quando necessário e quando os dados estiverem disponíveis; esclarecer produto, quantidade e condições do atendimento.
- **Saída:** informações que permitem registrar o pedido. No balcão, pode haver pedido sem cliente cadastrado, como admite a cardinalidade do DER.

##### 1.1.2 Recebimento de pedidos multicanal e consumo no local

- **Entrada:** compra para consumo no local, solicitação no balcão, encomenda pelo WhatsApp ou pedido de entrega no dia via iFood ou Keeta.
- **Atividades:** identificar a origem; diferenciar venda presencial, encomenda e pedido imediato do aplicativo; se for plataforma, registrar qual delas; selecionar produtos; informar quantidades e preços praticados; registrar o status inicial.
- **Limite do DER:** a distinção entre balcão e consumo nas mesas é operacional; o modelo atual não possui atributo específico para número de mesa ou atendimento no salão.
- **Saída:** pedido registrado e associado a pelo menos um produto.

##### 1.1.3 Cardápio e preços

- **Entrada:** catálogo de produtos e preços definidos pela confeitaria.
- **Atividades propostas para o sistema:** cadastrar e consultar produtos e seus preços atuais; ao vender, preservar o preço unitário praticado no vínculo entre produto e pedido.
- **Saída:** pedido com valores históricos coerentes, mesmo se o preço cadastrado do produto mudar.
- **A confirmar:** quem altera o cardápio, com qual frequência e se os preços diferem entre canais.

##### 1.1.4 Encomendas pelo WhatsApp e agendamento

- **Entrada:** solicitação de encomenda pelo WhatsApp; os aplicativos não recebem encomendas agendadas.
- **Atividades:** confirmar itens e quantidades; negociar a data e a modalidade de recebimento; verificar disponibilidade de produção; informar o valor total e as condições de pagamento. **As encomendas feitas pelo WhatsApp exigem pagamento antecipado**, conforme informação complementar da responsável.
- **Saída:** encomenda aceita e acompanhada pelo pedido.
- **Confirmado:** pagamento antecipado nas encomendas por WhatsApp; cancelamentos de encomendas pelo WhatsApp, inclusive com menos de sete dias de antecedência da entrega, não geram multa nem retenção, com **devolução integral (100%) do valor pago**.
- **A confirmar:** a antecedência mínima para **fazer** a encomenda e os procedimentos operacionais de estorno. O prazo de sete dias não altera o percentual devolvido. O DER revisado registra a data prevista de atendimento, mas o prazo de sete dias não altera a regra de reembolso integral.

##### 1.1.5 Produção sob demanda

- **Entrada:** pedidos e encomendas aceitos.
- **Atividades:** planejar o preparo em função da demanda, produzir os itens e atualizar o andamento do pedido. O levantamento relata produção aos domingos e quartas-feiras.
- **Saída:** pedido preparado para entrega ou retirada.
- **Limite de escopo:** não há módulo de estoque ou ficha técnica de ingredientes na modelagem atual.

##### 1.1.6 Entrega dos pedidos no dia e de encomendas

- **Entrada:** pedido pronto para envio.
- **Atividades:** organizar o encaminhamento e a participação do funcionário que executa a entrega; acompanhar o estado do pedido.
- **Saída:** pedido entregue e concluído.
- **A confirmar:** área atendida, cálculo de taxa, registro de endereço, comprovante e tratamento de entregas intermediadas por plataformas. O DER não possui entidade ENTREGA.

##### 1.1.7 Retirada no balcão e consumo no estabelecimento

- **Entrada:** produto selecionado para consumo no local ou pedido pronto para retirada.
- **Atividades:** disponibilizar o produto, atender clientes nas mesas quando aplicável, conferir dados do pedido quando necessários e concluir o atendimento.
- **Saída:** pedido retirado e situação atualizada.
- **A confirmar:** procedimento utilizado para comunicar que a encomenda está pronta.

##### 1.1.8 Pagamento dos pedidos diretos

- **Canais:** WhatsApp e balcão, com dinheiro, Pix ou cartão (incluindo maquininha).
- **Regra confirmada:** não há taxa ou multa de cancelamento para pagamentos nos canais diretos. Maquininha é meio de processamento de cartão, não um aplicativo de venda.
- **Encomendas por WhatsApp:** exigem pagamento antecipado; em caso de cancelamento, a devolução é integral (100% do valor pago), inclusive com menos de sete dias de antecedência.
- **Modelagem:** PEDIDO pode possuir zero ou vários PAGAMENTOS (ex.: recebimentos em etapas, se ocorrerem); um PAGAMENTO pertence a um único PEDIDO. ESTORNO representa uma devolução vinculada a um PAGAMENTO direto, quando realizada; no máximo um estorno por pagamento nesta versão.
- **Limite:** não se presume parcelamento/sinal e saldo como prática confirmada; a cardinalidade permite expansão futura, sem obrigar seu uso.

##### 1.1.9 Pedidos de aplicativo e repasses

- iFood e Keeta recebem pedidos para entrega no mesmo dia, sem encomendas agendadas.
- O PEDIDO registra o canal e qual PLATAFORMA o originou; **o pagamento, eventual cancelamento, estorno e possíveis taxas são processados pelo próprio aplicativo**, conforme suas políticas.
- O sistema da confeitaria **não cria PAGAMENTO nem ESTORNO internos para esses pedidos de aplicativo**. A conferência de repasses é descrita como processo administrativo, ainda sem entidade REPASSE.

##### 1.1.10 Cancelamento e reembolso por canal

- **WhatsApp, balcão e pagamentos na maquininha:** não existe taxa ou multa de cancelamento cobrada pela confeitaria.
- **Encomendas por WhatsApp:** quando há cancelamento de encomenda já paga, devolve-se **100% do valor pago**, independentemente de faltarem mais ou menos de sete dias para a data prevista.
- **Balcão:** o cancelamento não possui taxa; se ainda não houve recebimento, não há estorno a registrar. Quando um valor tiver sido recebido e devolvido, é possível registrar ESTORNO com o valor efetivamente devolvido. A forma concreta de devolução no balcão deve ser validada na entrevista.
- **iFood e Keeta:** pagamento, cancelamento e eventual devolução são tratados exclusivamente no aplicativo, sem lançamento de estorno interno pela confeitaria.
- **Dados:** PEDIDO guarda status e data/hora de cancelamento; o histórico financeiro direto é mantido em PAGAMENTO e ESTORNO. Não há atributo `taxa_cancelamento` pois a taxa direta é zero e as taxas dos apps são externas.

##### 1.1.11 Compra de ingredientes e relacionamento com fornecedores

- **Entrada:** necessidade de ingredientes e embalagens para atender à produção.
- **Atividades:** aquisição de insumos **uma vez por mês**, para atender à produção de encomendas e de produtos comercializados no balcão. As etapas específicas de seleção de fornecedores, recebimento e conferência de validades ainda precisam ser confirmadas.
- **Saída:** insumos disponíveis para a produção.
- **Confirmado:** periodicidade mensal das compras e existência de produtos para venda no balcão. **A confirmar:** nomes dos fornecedores, responsáveis pelas compras, armazenamento e controle de validade. **INSUMO e COMPRA estão no DER revisado; FORNECEDOR e ESTOQUE permanecem fora do escopo**, embora seu processo operacional esteja documentado.

**Modelagem confirmada como proposta:** COMPRA contém uma data e um ou mais INSUMOS adquiridos, com quantidade e custo unitário. O cadastro descreve compras, não consumo, saldo de estoque nem controle de validade. O valor total da compra é derivado da soma dos subtotais.

##### 1.1.12 Controle administrativo e caixa

- **Entrada:** pedidos, pagamentos e dados de vendas por canais e plataformas.
- **Atividades:** conferir os registros, consultar vendas por período e consolidar informações; atualmente, parte desse trabalho utiliza Excel e acontece ao final do expediente.
- **Saída:** visão administrativa das operações e dos valores recebidos ou a receber.
- **A confirmar:** abertura/fechamento de caixa, conciliação, despesas e periodicidade dos relatórios.

##### 1.1.13 Fluxo geral dos dados

```mermaid
flowchart TD
    A[Solicitação de compra] --> B{Canal e modalidade}
    B -->|Salão ou balcão| C[Venda de produto disponível]
    B -->|WhatsApp: encomenda| D[Definir produtos e data de entrega]
    B -->|iFood ou Keeta| E[Pedido para entrega no mesmo dia]
    D --> F[Receber pagamento antecipado]
    F --> G{Cancelamento solicitado?}
    G -->|Sim, inclusive a menos de 7 dias| H["Devolução integral (100%), sem multa"]
    G -->|Não| I[Produzir encomenda]
    C --> J[Concluir atendimento presencial]
    E --> K[Preparar e encaminhar entrega no dia]
    I --> L[Entregar ou disponibilizar retirada]
    H --> M[Atualizar status e controle financeiro]
    J --> M
    K --> M
    L --> M
```

> **Observação:** a ausência de multa nos canais diretos e o reembolso integral das encomendas WhatsApp foram informados pelo grupo. Os procedimentos de estorno, entrega e atendimento nas mesas ainda precisam de detalhamento com a responsável.

#### Requisitos Funcionais

| Código | Requisito funcional |
|---|---|
| RF01 | O sistema deve permitir cadastrar cliente com `id_cliente`, `nome_cliente` e `telefone_cliente` obrigatórios. |
| RF02 | O sistema deve consultar cliente por identificador, nome e telefone; o telefone possui índice, sem unicidade obrigatória. |
| RF03 | O sistema deve registrar pedido com identificador, cliente opcional, plataforma conforme o canal, data/hora, data prevista, cancelamento, status, canal, tipo e modalidade de atendimento. |
| RF04 | O sistema deve consultar pedidos com cliente, origem, datas e situação, inclusive pedidos sem cliente cadastrado. |
| RF05 | O sistema deve cadastrar produto com identificador, nome, descrição opcional e preço atual não negativo. |
| RF06 | O sistema deve consultar nome, descrição e preço atual dos produtos, em ordem de nome. |
| RF07 | O sistema deve associar produtos a pedidos com `id_pedido`, `id_produto`, `quantidade` positiva e `preco_unitario` histórico não negativo. |
| RF08 | O sistema deve permitir registrar e consultar o status do pedido. |
| RF09 | O sistema deve registrar pagamentos de pedidos diretos com identificador, pedido, data/hora, forma e valor positivo. |
| RF10 | O sistema deve permitir registrar a forma de pagamento dos pedidos realizados pelo WhatsApp ou balcão: dinheiro, cartão ou Pix. |
| RF11 | O sistema deve registrar o pedido e a plataforma de origem, mantendo os pagamentos e estornos de aplicativos fora do controle financeiro interno. |
| RF12 | O sistema deve permitir identificar o canal de origem de cada pedido: WhatsApp, balcão ou plataforma. |
| RF13 | O sistema deve permitir vincular pedidos realizados por plataforma ao iFood ou à Keeta. |
| RF14 | O sistema deve permitir consultar informações de vendas por período, produto, canal e plataforma. |
| RF15 | O sistema deve cadastrar funcionário com identificador, nome e função obrigatórios. |
| RF16 | O sistema deve consultar identificador, nome e função dos funcionários. |
| RF17 | O sistema deve permitir associar ao pedido os funcionários que participaram do atendimento, produção ou entrega, registrando os identificadores do pedido e do funcionário e o `papel_participacao` não vazio. |
| RF18 | O sistema deve registrar a data prevista de atendimento de encomendas e o momento de cancelamento, quando aplicável. |
| RF19 | O sistema deve registrar pagamentos diretos vinculados aos pedidos por WhatsApp ou balcão, sem taxa de cancelamento. |
| RF20 | O sistema deve registrar estorno com identificador, pagamento original, data/hora e valor positivo, com no máximo um estorno por pagamento. |
| RF21 | O sistema deve impedir lançamentos internos de PAGAMENTO e ESTORNO para pedidos processados integralmente por iFood ou Keeta. |
| RF22 | O sistema deve cadastrar INSUMO com identificador, nome e unidade de medida obrigatórios. |
| RF23 | O sistema deve registrar COMPRA com identificador e data; cada insumo adquirido informa seu identificador, quantidade positiva e custo unitário não negativo. |
| RF24 | O sistema deve permitir apurar subtotais e totais derivados de PEDIDO e COMPRA a partir das relações correspondentes. |


---

#### Requisitos não funcionais

Os requisitos abaixo são propostas para o sistema a desenvolver. Não representam funcionalidades já implementadas pelo script SQL.

| Código | Requisito | Como conferir |
|---|---|---|
| RNF01 | Cada usuário deve ter uma conta individual e permissões conforme sua função. | Testar se um entregador não consegue alterar preços ou pagamentos. |
| RNF02 | Os dados pessoais devem ser consultados somente por quem precisa deles para atender o pedido. | Conferir os acessos conforme a matriz do dicionário. |
| RNF03 | O sistema deve permitir backup diário e recuperação dos dados. | Restaurar um backup em um banco separado e conferir os registros. |
| RNF04 | As telas devem usar termos simples e explicar erros de preenchimento. | Simular um cadastro com quantidade inválida e conferir a mensagem. |
| RNF05 | Alterações financeiras e acessos a dados pessoais devem ter registro de usuário, data, operação e resultado. | Conferir o registro após uma operação de teste. |
| RNF06 | A implementação SQL deve funcionar no MySQL 8.0.16 ou superior, com caracteres acentuados e valores monetários em DECIMAL. | Executar o script completo e conferir os exemplos. |

#### Regras de Negócio

As regras abaixo consolidam o levantamento anterior com as informações recentes do grupo. Os códigos originais são mantidos sempre que possível, e a revisão é datada para rastreabilidade.

| Código | Regra atualizada |
|---|---|
| RN01 | Todo PEDIDO possui canal de origem: WhatsApp, balcão ou plataforma. |
| RN02 | WhatsApp e balcão são canais diretos; não pertencem à entidade PLATAFORMA. |
| RN03 | As plataformas atualmente utilizadas são iFood e Keeta (informação da operação, não limite permanente). |
| RN04 | PEDIDO de plataforma identifica uma PLATAFORMA; PEDIDO direto não possui plataforma vinculada. |
| RN05 | Cada PEDIDO deve conter pelo menos um PRODUTO. |
| RN06 | A relação CONTÉM registra `quantidade` e `preco_unitario` praticado, preservando o preço histórico. |
| RN07 | O `total_pedido` é derivado da soma de `quantidade × preco_unitario`. |
| RN08 | O PEDIDO mantém `status_pedido`; se cancelado, pode registrar `data_hora_cancelamento`. |
| RN09 | PEDIDO direto pode possuir zero ou vários PAGAMENTOS; cada PAGAMENTO corresponde a um único PEDIDO direto. A confirmação de encomenda por WhatsApp requer pagamento antecipado. |
| RN10 | Nos pagamentos diretos, registrar forma de pagamento como dinheiro, Pix ou cartão (inclusive maquininha). **Não existe taxa de cancelamento** nesses canais. |
| RN11 | Em iFood/Keeta, pagamento, cancelamento e eventual estorno permanecem na própria plataforma. Não registrar transações PAGAMENTO ou ESTORNO internas para esses pedidos. |
| RN12 | O sistema registra COMPRA e INSUMO da aquisição mensal, mas não calcula saldo de estoque nem consumo de ingredientes. |
| RN13 | Foi relatada produção aos domingos e quartas-feiras, sem presumir exclusividade desses dias. |
| RN14 | Há três funcionários na operação observada; isso não impõe limite de cadastro no banco. |
| RN15 | FUNCIONÁRIO e PEDIDO possuem relacionamento N:N, com `papel_participacao`. |
| RN16 | Repasses dos aplicativos são conferidos administrativamente; não há módulo próprio de REPASSE. |
| RN17 | Encomenda via WhatsApp possui data prevista de entrega ou retirada. |
| RN18 | A antecedência mínima para contratar encomenda ainda precisa ser confirmada; isso não significa que ela inexista. O prazo de sete dias **não gera multa de cancelamento**. |
| RN19 | Encomenda WhatsApp tem pagamento antecipado. |
| RN20 | No cancelamento de encomenda via WhatsApp paga, o cliente recebe **100% do valor pago**, inclusive com menos de sete dias de antecedência. |
| RN21 | O pagamento direto já recebido pode gerar ESTORNO; o valor devolvido é registrado e relacionado ao pagamento original. |
| RN22 | Dados pessoais requerem acesso controlado e proteção conforme LGPD. |
| RN23 | Compras e manipulação de alimentos seguem regras sanitárias aplicáveis, cuja execução local deve ser confirmada. |
| RN24 | Obrigações fiscais e comprovantes da operação dependem do enquadramento a confirmar na organização. |
| RN25 | Cada COMPRA possui um ou mais INSUMOS, registrando `quantidade` e `custo_unitario` no relacionamento ADQUIRE. |
| RN26 | `subtotal_compra` e `total_compra` são derivados dos custos de compra; não são dados de estoque. |
| RN27 | Para um mesmo PAGAMENTO direto, esta versão admite no máximo um ESTORNO; devoluções parceladas exigiriam ampliação posterior. |
| RN28 | O modelo não armazena taxas de cancelamento de aplicativos como se fossem cobradas pela confeitaria. |
| RN29 | Pedido direto concluído deve ter a soma dos pagamentos igual ao total dos itens. A auditoria A06 também confere o pagamento antecipado das encomendas WhatsApp não canceladas (RN19). |

**Pendências de validação com a responsável:** volume mensal de compras e pedidos, identificação de fornecedores, quem realiza compras, eventual devolução de compras no balcão, e procedimentos/timing de estornos em Pix, dinheiro e cartão. Não foram inventadas taxas, fornecedores nem quantidades.

#### Classificação e informações pendentes

- **Regras operacionais e de integridade:** canais, produtos por pedido, preço histórico, pagamentos, cancelamentos, compras e seus relacionamentos.
- **Fatos observados:** plataformas atuais (RN03), dias de produção relatados (RN13) e equipe atual (RN14). Não são limites permanentes de cadastro.
- **Restrições externas:** privacidade/LGPD (RN22), cuidados sanitários (RN23) e obrigações fiscais (RN24). O enquadramento e os procedimentos concretos precisam ser confirmados.

| Pergunta para a responsável | Motivo |
|---|---|
| Qual é a antecedência mínima para encomendar? | Definir a regra de agendamento sem confundir com o prazo de cancelamento. |
| Quais bairros são atendidos e como se calcula a taxa? | Completar o processo de entrega. |
| Quem compra, de quem compra e como confere validade e recebimento? | Completar o processo de compras e cuidados sanitários. |
| Como são feitos o fechamento do caixa e os comprovantes fiscais? | Detalhar o controle administrativo. |
| Quem pode consultar dados pessoais e por quanto tempo são guardados? | Validar permissões e retenção, considerando obrigações aplicáveis. |

As respostas não foram inventadas. As propostas de acesso e registro estão no [dicionário de dados](dicionario-dados.html#acesso).

#### Resposta aos apontamentos da Entrega 1

Fonte: [correção do professor, issue 1](https://github.com/ErickCLiberato/cinthie-confeitaria/issues/1). A tabela registra a situação atual, sem afirmar que o professor já validou a revisão.

| Apontamento | Alteração ou situação atual | Motivo e pendência |
|---|---|---|
| Falta de endereço e contato | Endereço acrescentado; nome e telefone da responsável pendentes. | Permitir confirmar o contato com a organização. |
| Processos superficiais; compras, preços, cancelamentos e encomendas incompletos | Processos detalhados e fluxo incluído; COMPRA e INSUMO incluídos no modelo revisado. | Antecedência, fornecedores, entrega e caixa ainda precisam de confirmação. |
| Ausência de RNF | RNF01 a RNF06 documentados como propostas. | Acesso, logs e backup não são implementados pelo script. |
| Regras sem classificação e sem restrições externas | Separadas regras, fatos e restrições; RN22 a RN24 tratam de privacidade, cuidados sanitários e obrigações fiscais. | Procedimentos locais e cobertura dos dados dessas áreas continuam pendentes. |
| Dicionário incompleto | HTML existente contém definições, fluxo, convenções, índices, permissões e proposta de log. | Comparar o formato com o PDF de exemplo do professor, ainda não fornecido. |
| Prompts e respostas genéricos | Mantido o histórico disponível e acrescentado o registro desta revisão. | Não reconstruir prompts antigos como se fossem transcrições. |
| Falta de data prevista e papel do funcionário | Campos de data prevista/cancelamento e papel de participação incorporados. | Apoiar encomendas e registrar a atuação da equipe. |
| Pagamentos de plataformas inconsistentes | Pagamentos internos restritos conceitualmente aos canais diretos; A01 detecta lançamentos indevidos. | A consulta não bloqueia a gravação. |
| Lista de integrantes e situação de Giovanna | Mantidos os quatro integrantes do README revisado, conforme alteração anterior do grupo. | Confirmar cadastro dos atuais integrantes e seus usuários no GitHub. |

#### Modelo conceitual revisado

#### Entidades e justificativas

| Entidade | Informação representada |
|---|---|
| CLIENTE | Identificação e contato quando disponíveis. |
| FUNCIONÁRIO | Equipe de atendimento, produção ou entrega. |
| PRODUTO | Catálogo de produtos comercializados. |
| PEDIDO | Origem, tipo, modalidade, datas e situação da venda/encomenda. |
| PLATAFORMA | Identifica iFood ou Keeta, quando pedido é originado por aplicativo. |
| PAGAMENTO | Recebimentos de pedidos **diretos**, vinculados ao pedido. |
| ESTORNO | Devolução de valores recebidos em pagamento **direto**. |
| COMPRA | Aquisição de insumos registrada por data. |
| INSUMO | Item comprado para produção, sem monitoramento de estoque. |

#### Relacionamentos e cardinalidades

| Relação | Cardinalidades (máximo de ocorrências do outro lado) | Observação |
|---|---|---|
| CLIENTE **FAZ** PEDIDO | CLIENTE (0,N) — PEDIDO (0,1) | Pedido pode não ter cliente cadastrado. |
| FUNCIONÁRIO **PARTICIPA DE** PEDIDO | FUNCIONÁRIO (0,N) — PEDIDO (0,N) | Atributo `papel_participacao`. |
| PEDIDO **ORIGINA EM** PLATAFORMA | PEDIDO (0,1) — PLATAFORMA (0,N) | Obrigatório somente para canal plataforma. |
| PEDIDO **POSSUI** PAGAMENTO | PEDIDO (0,N) — PAGAMENTO (1,1) | Pagamentos internos somente para canais diretos. |
| PAGAMENTO **GERA** ESTORNO | PAGAMENTO (0,1) — ESTORNO (1,1) | Um estorno, no máximo, por recebimento nesta versão. |
| PEDIDO **CONTÉM** PRODUTO | PEDIDO (1,N) — PRODUTO (0,N) | `quantidade`, `preco_unitario` e subtotal derivado. |
| COMPRA **ADQUIRE** INSUMO | COMPRA (1,N) — INSUMO (0,N) | `quantidade`, `custo_unitario` e subtotal derivado. |

**Convenções:** entidades em retângulos, relacionamentos em losangos e cardinalidades (mínimo, máximo). Os identificadores estão sublinhados. Os atributos próprios dos relacionamentos aparecem em elipses. `total_pedido` e `total_compra` estão fora dos retângulos e representados por elipses tracejadas, assim como os subtotais derivados. Não há chaves estrangeiras no DER conceitual.

#### Limites assumidos

- Sem saldo de estoque, ficha técnica de receitas, fornecedor ou controle de entrada e saída de ingrediente.
- A entidade COMPRA registra a **aquisição**, não o consumo nem a quantidade disponível de INSUMO.
- Pagamentos e estornos de aplicativo continuam na plataforma; apenas o PEDIDO e sua origem são registrados internamente.
- O estorno de pagamento direto é operação distinta do cancelamento do PEDIDO; cancelar antes de pagar não gera estorno.

![DER conceitual corrigido — Cinthiê Confeitaria](assets/der_conceitual_corrigido.png)

**Revisões incorporadas:** compras e insumos; totais derivados ligados externamente; cancelamento direto sem taxa; ESTORNO para recebimentos diretos; vínculo PEDIDO–PAGAMENTO ajustado de (0,1) para (0,N); aplicativos mantidos como plataformas externas.

**Software de criação do DER:** a confirmar pelo grupo; não consta dos arquivos existentes.

### 1.2 Conversão do Modelo Conceitual para o Modelo Lógico

A notação relacional exige tabelas associativas para cada N:N. Assim, a decisão de **não criar ITEM_PEDIDO como entidade conceitual** é preservada, enquanto `ITEM_PEDIDO` aparece necessariamente no **modelo lógico**. O mesmo acontece com `PEDIDO_FUNCIONARIO` e `COMPRA_INSUMO`.

O [script SQL do projeto](cinthie_confeitaria-2.sql) implementa 12 tabelas no banco `cinthie_confeitaria_v3`. O nome separado preserva o banco da versão anterior. Para estudar os exemplos, abra o arquivo no MySQL Workbench e execute-o inteiro usando MySQL 8.0.16 ou superior.

O script usa chaves, `NOT NULL`, `UNIQUE` e `CHECK` para regras simples. Regras que envolvem várias tabelas são verificadas pelas consultas finais: elas apontam inconsistências, mas não bloqueiam gravações. Portanto, o RF21 é um requisito do sistema completo; o script atual oferece conferência, não bloqueio automático. Também dependem de conferência o pagamento integral, o reembolso e a existência de itens em pedidos e compras.

#### Principais regras de conversão

- Relacionamentos N:N → tabelas próprias com PK composta e FKs: `ITEM_PEDIDO`, `PEDIDO_FUNCIONARIO`, `COMPRA_INSUMO`.
- Relacionamentos 1:N → chave estrangeira no lado N (`PEDIDO.id_cliente`, `PAGAMENTO.id_pedido`, por exemplo).
- Relacionamento 1:1 opcional `PAGAMENTO`–`ESTORNO` → FK `ESTORNO.id_pagamento` com restrição `UNIQUE`.
- `total_pedido`, `subtotal`, `total_compra` e `subtotal_compra` são derivados, calculados por consultas (não armazenados como dados redundantes).
- Para PEDIDO de PLATAFORMA, `id_plataforma` é informado; não se gera PAGAMENTO interno.

### 1.3 Definição de Chaves Primárias e Estrangeiras

| Tabela | Chave primária (PK) | Chaves estrangeiras (FK) |
|---|---|---|
| cliente | id_cliente | — |
| funcionario | id_funcionario | — |
| produto | id_produto | — |
| plataforma | id_plataforma | — |
| pedido | id_pedido | id_cliente → cliente; id_plataforma → plataforma |
| pagamento | id_pagamento | id_pedido → pedido |
| item_pedido | (id_pedido, id_produto) | id_pedido → pedido; id_produto → produto |
| pedido_funcionario | (id_pedido, id_funcionario) | id_pedido → pedido; id_funcionario → funcionario |
| estorno | id_estorno | id_pagamento → pagamento (também UNIQUE) |
| compra | id_compra | — |
| insumo | id_insumo | — |
| compra_insumo | (id_compra, id_insumo) | id_compra → compra; id_insumo → insumo |

### 1.4 Processo de Normalização (1FN, 2FN e 3FN)

**1FN — um valor por campo e nenhuma lista de itens na mesma coluna.** Em vez de guardar produtos e quantidades como uma lista em PEDIDO, cada produto ocupa uma linha em ITEM_PEDIDO. O mesmo vale para insumos de uma compra e funcionários participantes. `papel_participacao` é uma descrição textual da atuação; os papéis não são um catálogo de valores que possam ser consultados separadamente nesta versão. Se isso for necessário, o modelo precisará de uma tabela própria.

**2FN — os atributos de tabelas com chave composta dependem da chave inteira.** Em ITEM_PEDIDO, `(id_pedido, id_produto)` determina quantidade e preço praticado: o mesmo produto pode ter outro preço em outro pedido. O nome do produto depende só de `id_produto` e permanece em PRODUTO. Em COMPRA_INSUMO, quantidade e custo unitário dependem da compra e do insumo juntos. Em PEDIDO_FUNCIONARIO, o papel descreve a participação daquele funcionário naquele pedido; seu nome e função ficam em FUNCIONARIO.

**3FN — um dado não chave não determina outro dado não chave na mesma tabela.** O nome da plataforma fica em PLATAFORMA; PEDIDO guarda somente sua FK. Os dados de contato ficam em CLIENTE e os nomes dos insumos em INSUMO. PAGAMENTO guarda a FK do pedido, sem repetir o cliente ou a plataforma. ESTORNO aponta para PAGAMENTO, sem repetir os dados do pedido.

Exemplos de dependências: `id_cliente → nome_cliente, telefone_cliente`; `id_pedido → datas, canal, tipo, modalidade, status, id_cliente, id_plataforma`; `(id_pedido, id_produto) → quantidade, preco_unitario`; `id_pagamento → id_pedido, data_pagamento, forma_pagamento, valor_pago`. As demais entidades seguem suas PKs e os atributos listados no dicionário. Não se presume que telefone, nome de cliente ou nome de produto sejam únicos.

Os totais são calculados em consultas, evitando diferenças entre o total salvo e os itens. Essa escolha reduz redundância, mas sozinha não prova normalização. A análise se baseia nas dependências descritas e nas regras atuais, que ainda devem ser validadas pelo grupo.

### 1.5 Justificativas Técnicas das Decisões

| Decisão | Justificativa | Regras relacionadas |
|---|---|---|
| IDs inteiros como PK das entidades | Identificar registros sem depender de nomes ou telefones que podem mudar. | Identificação das entidades |
| PK composta nas três tabelas associativas | Evitar repetir a mesma combinação; agregar a quantidade do mesmo produto no pedido. | RN05, RN06, RN15, RN25 |
| FKs | Exigir que cliente, plataforma, pagamento, produto, funcionário, compra e insumo referenciados existam. | RN04, RN09, RN15, RN21, RN25 |
| Cliente opcional em pedido | Permitir venda no balcão sem cadastro de cliente. | Processo de atendimento |
| NOT NULL nos dados obrigatórios | Exigir nome e contato do cliente, nomes e funções, datas de compra, dados financeiros e valores dos itens. | RN01, RN06, RN10, RN17, RN25 |
| CHECK de canal, status, tipo e modalidade | Evitar valores fora das opções adotadas no modelo. | RN01, RN08, RN17 |
| CHECK do canal e plataforma | Exigir plataforma para aplicativo e impedir plataforma em canal direto. Aplicativo é pedido imediato para entrega. | RN02, RN04, RN11 |
| CHECK de data prevista | Exigir data prevista para encomenda. | RN17 |
| CHECK de quantidades, preços, valores e papel | Quantidades e recebimentos positivos; preços e custos não negativos; participação não vazia. | RN06, RN15, RN21, RN25 |
| UNIQUE em nome da plataforma e pagamento do estorno | Não duplicar plataforma; permitir no máximo um estorno por pagamento. | RN03, RN27 |
| DECIMAL e utf8mb4 | Evitar imprecisão de ponto flutuante em dinheiro e aceitar acentos. | RNF06 |
| DEFAULT em datas e status | Facilitar o cadastro; pedido inicia ABERTO se status não for informado. | RN08 |
| Índices por telefone e por data/status/canal | Apoiar buscas comuns. Não tornam telefone único. | RF02, RF04, RF14 |
| Sem exclusão em cascata | Evitar apagar automaticamente pedidos e registros financeiros relacionados. | Preservação de histórico |
| Sem triggers ou rotinas avançadas nesta versão | Manter o SQL compatível com o nível de estudo; auditorias detectam violações entre tabelas. | RN05, RN09, RN11, RN19, RN20, RN21, RN25, RN29 |

As auditorias A01–A06 **não impedem gravações**. Acesso por usuário, logs, backup e regras entre tabelas ainda dependem de implementação no sistema completo. Nenhuma consulta calcula taxas de aplicativo, lucro, saldo de estoque ou tempo de entrega, pois faltam esses dados.

### 1.6 Proposta de Arquitetura Analítica para BI e IA

Proposta simples: banco MySQL operacional → consultas G01–G07 → relatórios mensais ou exportação agregada para painel. Ainda não há painel, data warehouse ou modelo de IA implementado. A análise deve usar valores agregados e evitar expor nomes e telefones de clientes.

| KPI | Fórmula e período | Consulta |
|---|---|---|
| KPI01 — valor de vendas concluídas | Soma de quantidade × preço praticado dos pedidos concluídos, por mês de criação do pedido. Não equivale a caixa ou repasse. | G01 |
| KPI02 — ticket médio | Valor das vendas concluídas ÷ número de pedidos concluídos, por mês. | G01 |
| KPI03 — vendas por canal | Quantidade de pedidos concluídos e valor dos seus itens por mês, canal e plataforma. | G02 |
| KPI04 — saldo de recebimentos diretos | Valores recebidos no mês menos estornos feitos no mês, cada um pela própria data; sem despesas nem apps. | G03 |
| KPI05 — percentual de cancelamento | 100 × pedidos cancelados ÷ pedidos criados no mês; considera a situação atual desses pedidos. | G05 |
| KPI06 — gasto com compras | Soma de quantidade × custo unitário por mês da compra. Não representa consumo. | G06 |

Metas não foram informadas pela organização. Todos os indicadores são propostas a validar com a responsável.

| Problema ou KPI | Tabelas envolvidas | Consulta no script |
|---|---|---|
| P1 | pedido, item_pedido, produto, plataforma, cliente | G01, G02, G04, G07 |
| P2 | pedido, pagamento, estorno | G03, G05 |
| P3 | compra, compra_insumo | G06 |
| KPI01 e KPI02 | pedido, item_pedido | G01 |
| KPI03 | pedido, item_pedido, plataforma | G02 |
| KPI04 | pedido, pagamento, estorno | G03 |
| KPI05 | pedido | G05 |
| KPI06 | compra, compra_insumo | G06 |

Um painel pode comparar meses, canais e produtos, além de acompanhar cancelamentos e devoluções. Previsão de demanda seria uma evolução após reunir histórico suficiente e confiável; a pequena massa fictícia serve para testar consultas, não para treinar uma previsão útil. Recomendações de produção não podem usar estoque ou receitas que o banco ainda não registra.


## 2. Modelo Lógico Relacional

![Modelo lógico relacional](assets/modelo_logico.svg)

[Abrir o diagrama em SVG](assets/modelo_logico.svg) · [Fonte editável](docs/modelo_logico.dot).

**Ferramenta:** Graphviz, gerado nesta revisão, com tabelas, tipos, marcas PK/FK e cardinalidades mínima e máxima no estilo solicitado para o modelo lógico. O arquivo não é um projeto nativo do brModelo. Cada cardinalidade junto a uma tabela indica quantas linhas dela podem se relacionar com uma linha da tabela oposta. A opcionalidade de cliente e plataforma é condicional ao pedido; as regras detalhadas estão no dicionário e no SQL.

As tabelas associativas convertem os N:N. Um pedido e uma compra devem ter ao menos um item, mas a FK sozinha não garante isso; A04 e A05 fazem essa conferência. Não há generalização/especialização no modelo atual.

## 3. Script SQL Completo

[Script MySQL](cinthie_confeitaria-2.sql), mantido na raiz para preservar o link existente. Use MySQL 8.0.16 ou superior. O arquivo contém criação do banco e das 12 tabelas, restrições, dados fictícios, SELECT com JOIN, exemplos de UPDATE/DELETE, G01–G07 e A01–A06, nessa sequência.

**Como estudar:** execute em um banco vazio de estudo. O script cria `cinthie_confeitaria_v3`; não o execute sobre dados reais. Os exemplos de UPDATE e DELETE ficam em uma transação encerrada com ROLLBACK: execute o bloco completo para desfazer as mudanças. A massa usa IDs fictícios de 10001 em diante; não deve ser misturada com cadastros reais. `CREATE TABLE IF NOT EXISTS` não atualiza tabelas antigas.

| Auditoria | O que confere | Regra |
|---|---|---|
| A01 | Pagamento interno de aplicativo | RN11 |
| A02 | Estorno maior que pagamento | RN21 |
| A03 | Reembolso integral de encomenda WhatsApp cancelada | RN20 |
| A04 | Pedido sem item | RN05 |
| A05 | Compra sem insumo | RN25 |
| A06 | Pagamento integral exigido nas encomendas WhatsApp e pedidos diretos concluídos | RN09, RN19, RN29 |

Na massa válida, A01–A06 devem retornar zero linhas. Para demonstrar a detecção de um erro, use uma transação no banco de estudo e desfaça com ROLLBACK. Consulte o [registro de validação](docs/validacao.md) e os [blocos de demonstração das auditorias](docs/demonstracao_auditorias.sql).

## 4. Massa de Dados

Os INSERTs estão no próprio script, antes das consultas. Todos os nomes, contatos, produtos, preços e valores da massa são fictícios; os novos contatos usam textos como `CONTATO-FICTICIO-01`, sem telefone real.

Além dos exemplos anteriores, a massa acrescenta 10 clientes, 6 produtos, 24 pedidos com 48 itens, 24 participações, 15 pagamentos, um estorno, 5 insumos, 3 compras e 9 itens de compra. A contagem final, em banco vazio, está no registro de validação. Há pedidos de balcão sem cliente, clientes sem compras, produto sem vendas, três canais, duas plataformas, dinheiro/Pix/cartão, pedidos concluídos/cancelados/abertos/em preparo e datas em meses diferentes. O exemplo anterior preserva o caso de dois pagamentos para a mesma encomenda e seus dois estornos.

**Justificativa provisória:** os 24 pedidos distribuídos de agosto a outubro foram escolhidos para exercitar os relatórios, sem afirmar que representam o movimento real. As três compras complementares representam uma compra mensal nos três meses simulados, conforme a periodicidade relatada. O grupo ainda precisa informar volumes reais para ajustar a quantidade por tabela e justificar a massa final. Esse requisito do professor permanece pendente.

## 5. Repositório GitHub

| Artefato | Arquivo ou situação |
|---|---|
| Relatório Técnico | Este README na main |
| Dicionário único em HTML | [dicionario-dados.html](dicionario-dados.html) |
| DER revisado | [PNG existente](assets/der_conceitual_corrigido.png) |
| Modelo lógico | [SVG](assets/modelo_logico.svg) e [fonte](docs/modelo_logico.dot) |
| Levantamento organizado | [levantamento/levantamento.md](levantamento/levantamento.md) |
| Foto existente da visita | [assets/imagem.jpeg](assets/imagem.jpeg) |
| SQL e massa fictícia | [cinthie_confeitaria-2.sql](cinthie_confeitaria-2.sql) |
| Validação | [docs/validacao.md](docs/validacao.md) |
| Preparação da apresentação | [docs/roteiro_apresentacao.md](docs/roteiro_apresentacao.md); slides ainda pendentes |

O formato do dicionário ainda deve ser comparado ao PDF de exemplo do professor, não disponível nesta revisão. O histórico deve registrar contribuições reais de cada integrante com a própria conta; esta revisão assistida não substitui essa colaboração nem cria commits em nome dos colegas.

## 6. Uso de Inteligência Artificial

| Item | Registro |
|---|---|
| Ferramenta e etapa | ChatGPT/Codex foi utilizado para organizar informações da entrevista, revisar requisitos, discutir regras de negócio, identificar inconsistências e apoiar a elaboração do DER e deste README. |
| Motivação | Estruturar o trabalho conforme as orientações da disciplina, melhorar a coerência entre as seções e revisar a modelagem conceitual. |
| Prompt(s) utilizados | O texto exato dos prompts da fase inicial não foi preservado neste repositório; não é adequado reconstruí-los como se fossem transcrições. Registrar abaixo prompts documentados a partir desta revisão, com data e finalidade. |
| Sugestões recebidas | Foram sugeridas revisões de entidades, relacionamentos, cardinalidades, requisitos, regras de negócio e redação. |
| Trechos rejeitados ou corrigidos | Foram corrigidas sugestões anteriores que tratavam o motoboy como terceirizado, que incluíam controle de estoque e que criavam ITEM_PEDIDO diretamente no DER conceitual. No modelo lógico, a tabela associativa é necessária. Também foram revistas informações sobre canais de pedido e formas de pagamento. |
| Justificativa da escolha final | O grupo manteve as decisões compatíveis com a entrevista, com as informações posteriormente confirmadas sobre o funcionamento da confeitaria e com a orientação do professor para a modelagem conceitual. |
| Reflexão crítica | A IA foi utilizada como ferramenta de apoio à organização e revisão do trabalho. As informações sobre a organização foram obtidas na pesquisa de campo, e o grupo permaneceu responsável por verificar as sugestões e decidir quais alterações eram compatíveis com a realidade observada. |

### 6.1 Registro verificável da revisão assistida por IA

- **Data:** 30/10/2026.
- **Ferramenta:** ChatGPT.
- **Prompt do usuário (resumo fiel do pedido recebido nesta revisão, não transcrição da primeira fase):** "Corrija o README e remova uma integrante da lista de participantes", acompanhado da avaliação detalhada do professor e dos critérios de desconto.
- **Material de entrada:** `README.md` do projeto e parecer com critérios 1 a 12, lacunas de processos, regras de negócio, dicionário e uso de IA.
- **Saída adotada:** retirada de uma integrante da lista; ampliação de processos e fluxos; separação entre regras operacionais, fatos organizacionais e políticas a validar; explicitação das limitações do DER e do escopo.
- **Conferência humana necessária:** validar os detalhes ainda desconhecidos de agendamento, fornecedores, cancelamentos e reembolsos, entrega, impostos e uso de dados pessoais com a responsável e o professor; revisar esta versão antes da entrega.
- **Propostas não adotadas automaticamente:** inventar porcentagem de sinal ou novas condições de devolução, prazo fixo de encomenda, tarifas de entrega ou fornecedores inexistentes no levantamento.

### 6.2 Complemento do levantamento durante a revisão

- **Informações fornecidas pelo grupo:** a confeitaria dispõe de mesas para consumo; os aplicativos recebem apenas pedidos para entrega no dia; as encomendas são feitas pelo WhatsApp, com pagamento antecipado; cancelamentos das encomendas via WhatsApp, inclusive quando solicitados com menos de sete dias de antecedência da entrega, têm devolução integral (100%) do valor antecipadamente pago, sem ônus para cliente e estabelecimento.
- **Interpretação documental:** a regra foi atualizada para explicitar que o prazo de sete dias **não impõe retenção ou multa**; tanto antes quanto dentro dos sete dias prévios à entrega, o reembolso informado é de 100% do pagamento antecipado. A forma e o prazo operacional do estorno ainda precisam ser definidos.
- **Alteração aplicada:** atualização da caracterização, dos processos, do fluxo e das regras; posterior revisão do DER em 05/11/2026, em conjunto com o dicionário e o modelo lógico.

> **Transparência:** os prompts originais anteriores à revisão não constam dos arquivos fornecidos. Para documentar o histórico completo, anexar suas transcrições originais quando disponíveis; não substituir por exemplos fictícios.

---

### 6.3 Registro da atualização do SQL e da revisão documental

Transcrições de solicitações presentes na conversa com o Codex:

> Atualize o SQL porém lembre que sou um anulo que não sabe mexer muito em SQL nem em banco de dados. Mantenha meio que o "padrão" que já estava sendo usado na versão já presente do SQL no github, como se aínda fosse eu fazendo ele

> Veja se tudo está correto com o issues que o professor deixou

> Arruma as coisas

- **Ferramenta:** ChatGPT/Codex. Revisão documental em 06/11/2026.
- **Resposta adotada, em resumo:** inclusão de compras, insumos e estornos, atualização dos campos e exemplos, comparação com a issue #1 e complementação dos requisitos e do dicionário.
- **Exemplo concreto:** o pagamento deixou de ter `UNIQUE` em `id_pedido`, permitindo dois recebimentos para o mesmo pedido. O estorno manteve `UNIQUE` em `id_pagamento`, limitando a um estorno por recebimento.
- **Escolha e limite:** foram mantidos comandos SQL simples. Consultas detectam algumas violações entre tabelas, sem impedir a gravação; isso foi explicitado em vez de apresentar o script como um sistema completo.
- **Correção documental:** o RF11 foi alinhado ao RF21 para não registrar pagamentos de aplicativos internamente.
- **Validação:** execução e testes do SQL pelo Codex; o grupo ainda deve revisar as regras com a responsável e conferir os resultados antes da entrega. Os prompts antigos que não foram preservados continuam indisponíveis.

### 6.4 Registro da revisão de 05/11/2026 com apoio de IA

- **Solicitação do grupo:** corrigir modelagem de compras e insumos, representar `total_pedido` como atributo derivado externo, registrar estornos e atualizar a conversão N:N para o modelo lógico.
- **Correção adicional fornecida pelo grupo:** cancelamentos em WhatsApp, balcão e pagamentos via maquininha não têm cobrança de taxa; pagamentos, cancelamentos e estornos por aplicativos continuam nos próprios apps.
- **Solução adotada:** inclusão de COMPRA, INSUMO e ESTORNO; cardinalidades financeiras revisadas; totais calculados; modelo lógico com tabelas associativas; documentos compatibilizados.
- **Limites preservados:** não se presumem taxa de aplicativo, forma de reembolso do balcão, fornecedor, saldo de estoque nem volume mensal de compras; essas informações precisam de confirmação com a organização.
- **Ferramenta:** ChatGPT, em 05/11/2026, como assistência para a modelagem e revisão documental. Todo material deve ser validado pelo grupo antes da entrega.


### 6.5 Adequação ao esqueleto da Entrega 2 — 13/11/2026

| Item | Registro |
|---|---|
| Ferramenta e etapa | ChatGPT/Codex: comparação com o esqueleto, reorganização do README, normalização, diagrama lógico, consultas, dados fictícios e roteiro de apresentação. |
| Motivação | Adequar a estrutura e tornar explícitas as exigências ainda não atendidas. |
| Prompts disponíveis | “Este é o esqueleto de como deve ser, segundo o professor”; “Pode começar as alterações”. O usuário forneceu o arquivo `00-d_Esqueleto_Entrega_2.md` e pediu anteriormente SQL simples e preservação das regras. |
| Resposta recebida | Relatório reorganizado, consultas G01–G07/A01–A06, demonstrações reversíveis, massa de estudo e diagrama gerado a partir das tabelas. |
| Fontes consultadas | Esqueleto fornecido no Drive, README/SQL/dicionário e issue 1 do professor. A revisão técnica comparou esses materiais; o grupo ainda deve validar o conteúdo e os resultados. |
| Ajustes e limites | Não foram criados dados de entrevista, volumes reais, fornecedores, taxas, contatos pessoais ou contribuições dos colegas. A massa é fictícia e seu volume é provisório. Nenhum ajuste humano desta rodada foi informado até o registro. |
| Escolha final proposta | Manter comandos simples e auditorias, sem introduzir triggers; submeter ao grupo as decisões e pendências. |
| Reflexão crítica | A IA não substitui a visita, a confirmação do escopo ou a revisão do professor. Um script executável não prova que o banco representa todos os processos da organização. |

Também foram acrescentadas, em solicitação anterior desta conversa, duas linhas explicativas às 17 consultas de conferência. Prompt: “No repositório ErickCLiberato/cinthie-confeitaria, confira se todos os processos de negócio no README.md estão numerados em sequência. Depois, no arquivo cinthie_confeitaria-2.sql, acrescente duas linhas de comentários antes de cada consulta da parte de SELECT, explicando de forma simples o que ela mostra e para que serve.” A numeração já estava correta; foram mantidas as consultas e acrescentados 34 comentários.

Complemento fornecido pelo grupo nesta conversa: explicação intitulada “Diferença entre a empresa e o nosso projeto”, com melhorias propostas, exemplo de encomenda WhatsApp e limites da implementação. O texto foi incorporado ao relatório e ao roteiro, ajustando os nomes das tabelas ao SQL e distinguindo o controle administrativo de repasses da ausência desses registros no banco. Nenhuma consulta ou regra SQL foi alterada nessa complementação. A explicação não fornece data ou identificação da entrevistada nem substitui os dados de entrevista ainda pendentes.

## 7. Apresentação Corporativa Final

O [roteiro de oito minutos](docs/roteiro_apresentacao.md) segue a ordem exigida: problema, solução, modelo lógico, SQL em execução, consultas gerenciais/auditorias, BI/IA e benefícios. Ele orienta a montagem dos slides, mas não substitui os slides finais, ainda pendentes.

Todos os integrantes devem estar presentes e preparados para responder individualmente na defesa após o pitch. O grupo deve ensaiar a demonstração no MySQL e confirmar a distribuição das falas.

### Pendências para concluir a entrega

- Confirmar nome/contato da responsável, data e participantes da entrevista, achados de observação e volumes reais.
- Validar a cobertura de todos os dados da organização: fornecedores, entrega, estoque, caixa, fiscal e demais processos a confirmar.
- Informar o software de criação do DER e conferir a notação da imagem existente.
- Ajustar e justificar a massa de dados com os números do levantamento.
- Comparar o dicionário com o PDF de exemplo exigido e revisar a coerência após qualquer ampliação do modelo.
- Produzir os slides finais e ensaiar a demonstração e a defesa, com contribuições reais dos integrantes no repositório.
