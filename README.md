# Agenda CLI - Sistema de Gerenciamento de Contatos em Elixir

Este projeto consiste em uma aplicação de interface de linha de comando (CLI) desenvolvida para o gerenciamento de uma agenda de contatos pessoais. A aplicação foi construída utilizando o paradigma de programação funcional com a linguagem Elixir, atendendo aos requisitos de imutabilidade, recursão de cauda e persistência em formato JSON.

## Requisitos de Execução

Para a correta execução deste sistema, é necessária a instalação do ambiente Elixir e do gerenciador de projetos Mix.

### 1. Instalação de Dependências

O projeto utiliza a biblioteca `Jason` para a serialização e desserialização de dados. Adicione ao seu `mix.exs`:

```elixir
def deps do
  [
    {:jason, "~> 1.4"}
  ]
end
```

Em seguida, instale as dependências:

```bash
mix deps.get
```

### 2. Inicialização do Sistema

A aplicação deve ser executada através do shell interativo do Elixir (IEx):

```bash
iex -S mix
```

Após o carregamento, invoque o ponto de entrada principal:

```elixir
AgendaCli.main()
```

Alternativamente, via `mix run`:

```bash
mix run -e "AgendaCli.main()"
```

---

## Funcionalidades e Comandos

O sistema opera em um loop interativo que processa os seguintes comandos baseados em pattern matching:

| Comando | Sintaxe | Descrição |
|--------|---------|-----------|
| Adição | `add --name [NOME] --company [EMPRESA] --phone [DDD+NUM] --email [EMAIL]` | Adiciona um novo contato |
| Listagem | `list` | Exibe todos os registros persistidos |
| Pesquisa | `search --name [VALOR]` | Busca parcial e case-insensitive por nome, telefone ou e-mail |
| Edição | `edit [ID] --[FLAG] [NOVO_VALOR]` | Atualização parcial de campos via ID |
| Remoção | `del [ID]` | Exclui o contato pelo identificador único |
| Encerramento | `exit` | Encerra a aplicação |

---

## Organização Modular

A arquitetura do projeto foi segmentada em três módulos principais para garantir a separação de responsabilidades:

- **`AgendaCli`** — Ponto de entrada, loop interativo e parsing de comandos.
- **`AgendaCli.Contacts`** — Funções puras de manipulação da estrutura de dados (`add`, `delete`, `search`, `edit`).
- **`AgendaCli.Store`** — Gerencia as operações de leitura e escrita no arquivo `contacts.json`.

---

## Detalhes de Implementação

- **Identificação Única:** Os IDs são gerados automaticamente para cada contato.
- **Iteração:** O controle de repetição é realizado estritamente por recursão de cauda, conforme os princípios do paradigma funcional.
- **Persistência:** Os dados são armazenados em `contacts.json` no diretório da aplicação.
- **Parsing:** A análise das flags e comandos utiliza Pattern Matching em cláusulas de função.
