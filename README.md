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
   >

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

## Rotas Disponíveis

| Verbo HTTP          | Caminho (Path)                | Controller#Action        | Finalidade                        |
| :------------------ | :---------------------------- | :----------------------- | :-------------------------------- |
| **POST**      | `/signup`                   | `users#create`         | Criar novo usuário (cadastro)    |
| **GET**       | `/profile`                  | `users#show`           | Exibir perfil do usuário logado  |
| **POST**      | `/login`                    | `sessions#create`      | Realizar login (criar sessão)    |
| **GET**       | `/events`                   | `events#index`         | Listar eventos                    |
| **POST**      | `/events`                   | `events#create`        | Criar evento                      |
| **GET**       | `/events/:id`               | `events#show`          | Detalhes de um evento específico |
| **PATCH/PUT** | `/events/:id`               | `events#update`        | Atualizar evento                  |
| **DELETE**    | `/events/:id`               | `events#destroy`       | Remover evento                    |
| **GET**       | `/events/:id/checkin_rules` | `events#checkin_rules` | Regras de check-in                |
| **GET**       | `/participants`             | `participants#index`   | Listar participantes              |
| **POST**      | `/participants`             | `participants#create`  | Criar participante                |
| **GET**       | `/participants/:id`         | `participants#show`    | Detalhes de um participante       |
| **PATCH/PUT** | `/participants/:id`         | `participants#update`  | Atualizar participante            |
| **DELETE**    | `/participants/:id`         | `participants#destroy` | Remover participante              |
