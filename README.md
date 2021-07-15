# SpaceProbe

## Como Executar o Projeto

- Crie um Banco Postgres com Docker (ou na sua máquina):

  ```shell
  ➜ docker run --rm -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres
  ```

- Clone/Fork o projeto:

  ```shell
  ➜ git clone [url_do_projeto]
  ```

- Entre na pasta do projeto:

  ```shell
  ➜ cd space_probe
  ```

- Baixe as Dependências:

  ```shell
  ➜ mix deps.get
  ```

- Para rodar os testes execute o comando:

  ```shell
  ➜ mix test
  ```

- Para rodar o servidor execute os comandos:

  ```shell
  ➜ mix ecto.setup
  ...
  ➜ mix phx.server
  [info] Running SpaceProbeWeb.Endpoint with cowboy 2.9.0 at 0.0.0.0:4000 (http)
  [info] Access SpaceProbeWeb.Endpoint at http://localhost:4000
  ```

## Documentação da API

**Base URL**: localhost:4000/api

### POST /probes

Campos para ser enviados no Body em formato JSON:

- **instructions** (obrigatório):
  - Tipo: Lista de Strings
  - Instruções Válidas:
    - **M**: Para cada comando M a sonda se move uma posição na direção à qual sua **face** está apontada. A **Face** pode ter quatro direções válidas: **R** (Right), **U** (Up), **L** (Left), **D** (Down).
    - **TL**: Utilizado para girar 90 graus à esquerda.
    - **TR**: Utilizado para girar 90 graus à direita.

Exemplo de JSON que pode ser enviado:

```json
{
  "instructions": ["TL", "M", "M", "M", "TR", "M", "M"]
}
```

Exemplo de JSON que será retornado:

```json
{
  "x": 2,
  "y": 3
}
```

### GET /probes

Exemplo de JSON que será retornado:

```json
{
  "face": "R",
  "x": 2,
  "y": 3
}
```

### POST /probes/reset-position

Irá ser retornado o status code 204 (no content).
