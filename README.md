# Dictionary

## Introdução
Este projeto é parte de um desafio da Coodesh para desenvolver um aplicativo móvel que lista palavras em inglês utilizando a [Free Dictionary API](https://dictionaryapi.dev/).

## Tecnologias Utilizadas
- Flutter
- SQLite
- Free Dictionary API

## Processo de Investigação
### Pesquisa Inicial
- Pesquisei sobre a Free Dictionary API para entender o endpoint disponível e como é o seu retorno para realizar a integração necessária no App a ser desenvolvido.
- Analisei diferentes tecnologias de armazenamento local como SQLite, Drift e ObjectBox.

### Análise de Requisitos
- Os requisitos incluem listar palavras com rolagem infinita, visualizar detalhes das palavras, favoritar palavras e manter um histórico de visualizações.

## Estrutura do Projeto
- O projeto segue o padrão MVC para uma melhor organização do código.
- Utilizei o Flutter devido à sua capacidade de criar aplicativos nativos para iOS e Android com um único código base.

## Desenvolvimento
### Decisões de Design
- Utilizei o package **GetX** no Flutter por oferecer um ecossistema com várias funcionalidades como injeção de dependências, gerenciamento de estado, gerenciamento de rotas, gerenciamento de requisições http
- Optei por usar SQLite para armazenamento local devido à sua simplicidade e eficiência.

### Implementação de Funcionalidades
- **Cadastro de Usuário**: Implementei uma tela para realizar o cadastro de um novo usuário.
- **Login no Sistema**: Implementei uma tela para realizar o login no sistema.
- **Lista de Palavras**: Implementei uma lista com rolagem infinita usando `GridView.builder`.
- **Detalhes da Palavra**: Cada palavra pode ser visualizada em detalhes, incluindo significados e fonética.
- **Favoritos**: Os usuários podem favoritar e desfavoritar palavras, com os dados sendo armazenados localmente. O usuário poderá navegar para a aba onde é possível visualizar os favoritos.
- **Histórico de Visualizações**: Mantive um histórico de palavras visualizadas. O usuário poderá navegar para a aba onde é possível visualizar o histórico.

## Hipóteses e Decisões
### Problemas Encontrados
- Inicialmente havia colocado um sinalizador de sincronização onde mostrava o percentual de importação dos dados e um carregamento. Tendo em vista o grande volume de dados no arquivo fornecido achei inviável manter essa importação de forma síncrona. Então para resolver foi necessário fazer essa importação de forma assíncrona, porém essa não foi a principal dificuldade.
- Ao fazer a importação de forma assíncrona e ao mesmo tempo disponibilizar o login e cadastro de usuário, ao tentar fazer o cadastro do usuário no banco de dados ele finalizava a importação dos dados.
- Foi necessário implementar as **“Transaction“** no SQLite, com isso consegui resolver o problema da importação com o login ou cadastro.

### Testes e Validações
- Realizei testes manuais para garantir que todas as funcionalidades estavam funcionando conforme o esperado.
- Adicionei um único teste unitário na tela de login, realizei o teste de renderização dos componentes na tela quando é alterado da tela de login para a tela de cadastro.

### Melhorias Futuras
- Planejo adicionar mais testes unitários para contemplar todas as telas e funcionalidades do sistema.
- Pretendo adicionar um campo de pesquisa na tela de listagem de palavras, acho inviável o usuário ter que scrollar a página para encontrar uma determinada palavra para consultar, a usabilidade melhoraria bastante se houver um campo onde ela possa digitar a palavra que deseja pesquisar e ao consultar abrir diretamente a página de detalhes com a palavra informada.

## Resultados
O aplicativo atende aos requisitos do desafio e está funcionando conforme o esperado.

## Referência
This is a challenge by [Coodesh](https://coodesh.com/).

## Links
- [Repositório no GitHub](https://github.com/fisromildojr/dictionary)
- [Apresentação do Projeto](https://www.canva.com/design/DAGJbQ2PXlU/ryUgV3N4Gn5B9tcWPxlFFg/view?utm_content=DAGJbQ2PXlU&utm_campaign=designshare&utm_medium=link&utm_source=editor)
