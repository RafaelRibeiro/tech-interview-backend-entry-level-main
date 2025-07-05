# 💼 RD Station - Desafio Técnico Backend (Júnior/Pleno)

Este projeto é uma API RESTful para gerenciamento de um carrinho de compras, desenvolvida em Ruby on Rails, como parte do processo seletivo para Pessoa Desenvolvedora Backend Júnior/Pleno da RD Station.

---

## 🧰 Tecnologias utilizadas

* **Ruby** 3.3.1
* **Rails** 7.1.3.2
* **PostgreSQL** 16
* **Redis** 7.0.15
* **Sidekiq** (para jobs background)
* **RSpec** (para testes automatizados)
* **Docker** e **Docker Compose**

---

## 📦 Como executar o projeto

### ✅ Utilizando Docker

1. Clone o repositório:

```bash
git clone https://github.com/RafaelRibeiro/tech-interview-backend-entry-level-main.git
cd tech-interview-backend-entry-level-main
```

2. Copie o arquivo de variáveis de ambiente:

```bash
cp .env.example .env
```

3. Suba os serviços com Docker Compose:

```bash
docker-compose up --build
```

4. Acesse:

* API: [http://localhost:3000](http://localhost:3000)
* Dashboard Sidekiq: [http://localhost:3000/sidekiq](http://localhost:3000/sidekiq)

5. Para rodar os testes:

```bash
docker-compose exec web bundle exec rspec
```

---

### ⚙️ Executando localmente (sem Docker)

> Requisitos: Ruby 3.3.1, Bundler, PostgreSQL, Redis

1. Instale as dependências:

```bash
bundle install
```

2. Crie e migre o banco de dados:

```bash
rails db:create db:migrate
```

3. Inicie o Sidekiq (em outro terminal):

```bash
bundle exec sidekiq
```

4. Suba a aplicação:

```bash
bundle exec rails server
```

5. Execute os testes:

```bash
bundle exec rspec
```

---

## 🔐 Variáveis de Ambiente

Crie um arquivo `.env` baseado no `.env.example`:

```env
# Variaveis de Ambiente

DATABASE_HOST=localhost      # Host do BD
DATABASE_USERNAME=postgres   # Username do BD
DATABASE_PASSWORD=12345      # Password do BD
RAILS_MAX_THREADS=5          # Tamanho da Conexão do BD. Obs: Padrão no database.yml é 5.
```

---

## 🔄 Funcionalidades da API

* **POST /cart**
  Adiciona um produto ao carrinho. Se não houver carrinho ativo, cria um novo.

* **GET /cart**
  Lista todos os produtos do carrinho atual.

* **POST /cart/add\_item**
  Altera a quantidade de um item no carrinho.

* **DELETE /cart/\:product\_id**
  Remove um produto específico do carrinho.

---

## ⏰ Job de Carrinhos Abandonados

* Um **Sidekiq Job** marca carrinhos como abandonados após 3h de inatividade.
* Carrinhos abandonados são excluídos automaticamente após 7 dias.
* O job é executado automaticamente a cada 30 minutos via agendamento (`cron`).

---

## ✅ Testes Automatizados

* Os testes utilizam **RSpec** e **FactoryBot**.
* Cobrem models, jobs e endpoints da API.
* Para rodar:

```bash
bundle exec rspec
```

---

## 🥪 Exemplo de Payloads

### Adicionar produto ao carrinho

**POST /cart**

```json
{
  "product_id": 123,
  "quantity": 2
}
```

### Alterar quantidade

**POST /cart/add\_item**

```json
{
  "product_id": 123,
  "quantity": 5
}
```

### Remover item

**DELETE /cart/123**

---

## 📁 Organização do Código

* `app/models/` → Models como `Cart`, `CartItem`, `Product`
* `app/controllers/` → Controllers REST da API
* `app/jobs/` → Job de limpeza de carrinhos abandonados
* `spec/` → Testes organizados por unidade e integração

---

## 🧊 Docker

A aplicação está totalmente dockerizada com `Dockerfile` e `docker-compose.yml`, permitindo execução simples e reprodutível com:

```bash
docker-compose up --build
```

---

## ✍️ Autor

**Rafael Ribeiro da Costa**
📧 \[rafael.ribeiro1705@gmail.com]
🔗 [https://www.linkedin.com/in/rafaelribeirodacosta/]

---

## 📌 Observações

* O projeto foi baseado na estrutura inicial fornecida pela RD Station.
* Todos os requisitos obrigatórios foram implementados.
* O código foi escrito com foco em legibilidade, boas práticas e testes.
