# Event Manager API

A **Event Manager API** é o backend responsável pela lógica de negócio e persistência de dados da aplicação **Event Manager**. Este documento fornece uma visão geral do projeto e instruções passo a passo para configurar e executar o ambiente de desenvolvimento.

## 🚀 Como Executar

Para simplificar o desenvolvimento e a execução, o projeto utiliza **Docker**. Todas as dependências (Ruby, Rails, PostgreSQL) são gerenciadas automaticamente através dos arquivos `Dockerfile` e `docker-compose.yml`.

### Pré-requisitos

- [Docker](https://www.docker.com/get-started) e Docker Compose instalados.

### Passo a Passo

1. **Configuração de Variáveis de Ambiente**

   Crie um arquivo chamado `.env` na raiz do projeto e adicione as seguintes configurações:

   ```bash
   # Configurações do PostgreSQL
   POSTGRES_USER=postgres
   POSTGRES_PASSWORD=postgres
   POSTGRES_DB_DEV=event_manager_development
   POSTGRES_DB_TEST=event_manager_test
   DB_HOST=db
   DB_PORT=5432

   # Configurações do Rails
   RAILS_ENV=development
   RAILS_MAX_THREADS=5

   # Configuração de Autenticação
   JWT_SECRET=shhhh_é_segredo
   ```

2. **Inicialização dos Containers**

   Execute o comando abaixo para construir as imagens e iniciar os serviços em segundo plano:

   ```bash
   docker compose up -d --build
   ```

3. **Preparação do Banco de Dados**

   Com os containers em execução, configure o banco de dados (criação e migrações):

   ```bash
   docker compose exec web rails db:prepare
   ```

4. **Popular o Banco de Dados (Seeds)**

   Para carregar os dados iniciais (usuários, eventos, regras de check-in e participantes):

   ```bash
   docker compose exec web rails db:seed
   ```

   > **Dados criados pelo seed:**
   >
   > - 3 usuários (login: `admin@eventmanager.com` / senha: `password123`)
   > - 10 eventos com diferentes status
   > - 22 regras de check-in (2+ por evento)
   > - 44 participantes

   > **Nota:** A API estará acessível em `http://localhost:3000`.

5. Usuario de teste:
   ```bash
        name: "Admin",
        email: "admin@eventmanager.com",
        password: "password123"
   ```
6. **Encerrando a Aplicação**

   Para parar e remover os containers, execute:

   ```bash
   docker compose down
   ```

7. **Executando o frontend**

   ```bash
      git clone https://github.com/breno-gabriel/event-manager-frontend.git
   ```

## Solução de Problemas

### Erro de conexão com o banco de dados

Se ao executar `rails db:prepare` você receber o erro:

```
ActiveRecord::DatabaseConnectionError: There is an issue connecting to your database
with your username/password, username: postgres.
Caused by: PG::ConnectionBad: password authentication failed for user "postgres"
```

Isso ocorre porque o diretório `./tmp/db` contém dados de uma inicialização anterior do PostgreSQL. Quando o Postgres encontra um data directory já existente, ele **ignora** as variáveis de ambiente (`POSTGRES_USER` / `POSTGRES_PASSWORD`), mantendo as credenciais antigas.

**Para resolver**, pare os containers, remova o diretório de dados e suba novamente:

```bash
docker compose down
rm -rf tmp/db            # Linux/Mac
# ou no Windows PowerShell:
# Remove-Item -Recurse -Force tmp\db
docker compose up -d --build
docker compose exec web rails db:prepare
```

## Lógica de Janela de Validação (Check-in Rules)

Cada evento possui uma ou mais **regras de check-in** (`checkin_rules`) que definem **janelas de tempo** durante as quais o check-in do participante é permitido. Essas janelas são configuradas através de dois campos: `start_minutes` e `end_minutes`.

### Como funciona

Os campos `start_minutes` e `end_minutes` representam **deslocamentos em minutos** relativos à **data/hora do evento** (`date`):

| Valor                 | Significado                                   |
| :-------------------- | :-------------------------------------------- |
| `0`                   | Exatamente no horário do evento               |
| Positivo (ex: `60`)   | **Depois** do início do evento (60 min após)  |
| Negativo (ex: `-120`) | **Antes** do início do evento (120 min antes) |

A **janela de check-in** se abre em `date + start_minutes` e se fecha em `date + end_minutes`.

#### Exemplo prático

Considere um evento marcado para **17/06/2026 às 13:00**:

| Regra              | `start_minutes` | `end_minutes` | Janela resultante                 |
| :----------------- | :-------------: | :-----------: | :-------------------------------- |
| QR Code            |     `-240`      |    `-150`     | 09:00 às 10:30 (antes do evento)  |
| RG                 |     `-150`      |     `-90`     | 10:30 às 11:30 (antes do evento)  |
| Check-in Entrada   |       `0`       |     `60`      | 13:00 às 14:00 (após início)      |
| Check-in Intervalo |      `120`      |     `150`     | 15:00 às 15:30 (durante o evento) |

### Propriedades de cada regra

| Campo           | Tipo      | Descrição                                                  |
| :-------------- | :-------- | :--------------------------------------------------------- |
| `name`          | `string`  | Nome identificador da regra                                |
| `start_minutes` | `integer` | Minuto de abertura da janela (relativo à data do evento)   |
| `end_minutes`   | `integer` | Minuto de fechamento da janela (relativo à data do evento) |
| `is_active`     | `boolean` | Se a regra está ativa (`true` por padrão)                  |
| `is_mandatory`  | `boolean` | Se a regra é obrigatória (`false` por padrão)              |

### Validações aplicadas

O modelo `Event` aplica duas validações sobre as regras de check-in:

1. **Ao menos uma regra ativa:** Todo evento deve possuir pelo menos 1 regra de check-in com `is_active: true`.

2. **Sem conflito entre janelas obrigatórias:** Todas as regras que são simultaneamente **ativas** e **obrigatórias** devem possuir um **período de tempo em comum** (interseção). Isso garante que exista ao menos um momento em que o participante consiga cumprir todas as regras obrigatórias. A validação calcula o maior `start_minutes` e o menor `end_minutes` entre as regras obrigatórias — se `max(start) > min(end)`, não há sobreposição e o evento é recusado.

#### Exemplo de conflito

```
Regra A (obrigatória): start_minutes = 0,   end_minutes = 30   → 13:00–13:30
Regra B (obrigatória): start_minutes = 60,  end_minutes = 90   → 14:00–14:30
```

Não há período em comum entre 13:00–13:30 e 14:00–14:30, logo o evento **não será salvo** e retornará erro de conflito de janela.

#### Exemplo válido

```
Regra A (obrigatória): start_minutes = 0,   end_minutes = 60   → 13:00–14:00
Regra B (obrigatória): start_minutes = 30,  end_minutes = 90   → 13:30–14:30
```

O período em comum é 13:30–14:00, então as regras são compatíveis e o evento é aceito.

## Rotas Disponíveis

| Verbo HTTP    | Caminho (Path)              | Controller#Action      | Finalidade                       |
| :------------ | :-------------------------- | :--------------------- | :------------------------------- |
| **POST**      | `/signup`                   | `users#create`         | Criar novo usuário (cadastro)    |
| **GET**       | `/profile`                  | `users#show`           | Exibir perfil do usuário logado  |
| **POST**      | `/login`                    | `sessions#create`      | Realizar login (criar sessão)    |
| **GET**       | `/events`                   | `events#index`         | Listar eventos                   |
| **POST**      | `/events`                   | `events#create`        | Criar evento                     |
| **GET**       | `/events/:id`               | `events#show`          | Detalhes de um evento específico |
| **PATCH/PUT** | `/events/:id`               | `events#update`        | Atualizar evento                 |
| **DELETE**    | `/events/:id`               | `events#destroy`       | Remover evento                   |
| **GET**       | `/events/:id/checkin_rules` | `events#checkin_rules` | Regras de check-in               |
| **GET**       | `/participants`             | `participants#index`   | Listar participantes             |
| **POST**      | `/participants`             | `participants#create`  | Criar participante               |
| **GET**       | `/participants/:id`         | `participants#show`    | Detalhes de um participante      |
| **PATCH/PUT** | `/participants/:id`         | `participants#update`  | Atualizar participante           |
| **DELETE**    | `/participants/:id`         | `participants#destroy` | Remover participante             |
