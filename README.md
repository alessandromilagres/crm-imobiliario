# CRM Imobiliário

Sistema de gestão de clientes (CRM) para o mercado imobiliário, desenvolvido com **Flutter Web** e **Python FastAPI**.

## 🚀 Tecnologias

### Backend
- **Python 3.11** com FastAPI
- **PostgreSQL** (banco de dados relacional)
- **Redis** (cache e sessões)
- **SQLAlchemy** (ORM)
- **Pydantic** (validação de dados)
- **Docker** & **Docker Compose**

### Frontend
- **Flutter 3.27** (Web)
- **Material Design 3**
- **Google Fonts** (Inter)
- **HTTP Client**
- **Provider** (gerenciamento de estado)

## 📦 Estrutura do Projeto

```
crm-imobiliario/
├── backend/                    # API FastAPI
│   ├── app/
│   │   ├── models/            # SQLAlchemy models
│   │   ├── schemas/           # Pydantic schemas
│   │   ├── routes/            # API endpoints
│   │   ├── database.py        # Configuração do banco
│   │   └── main.py            # Aplicação FastAPI
│   ├── requirements.txt
│   └── Dockerfile
│
├── frontend/                   # Flutter Web
│   ├── lib/
│   │   ├── models/            # Data models
│   │   ├── services/          # API services
│   │   ├── screens/           # Telas
│   │   ├── widgets/           # Componentes
│   │   ├── theme/             # Dark theme
│   │   └── main.dart
│   └── pubspec.yaml
│
└── docker-compose.yml          # Orquestração de containers
```

## 🎯 Funcionalidades

### ✅ Implementado

#### Cadastro de Pessoas
- Pessoa Física (PF) ou Pessoa Jurídica (PJ)
- Dados pessoais completos (nome, email, telefone, CPF/CNPJ)
- Endereço completo
- Papel no sistema (Cliente, Corretor, Vendedor, Gestor, Admin)
- Validações em tempo real
- Formulário multi-step (wizard)

#### Cadastro de Imobiliárias
- Dados da empresa (Razão Social, Nome Fantasia, CNPJ)
- Informações de contato (email, telefone, website)
- Endereço completo
- CRECI
- Seleção de plano (Básico, Profissional, Enterprise)
- Formulário multi-step (wizard)

#### Interface
- **Dark Mode** nativo (não adaptação)
- Design moderno com **Glassmorphism**
- Paleta de cores vibrante (Indigo, Purple, Green)
- Tipografia Inter (Google Fonts)
- Animações suaves
- Responsivo

## 🚀 Como Executar

### Pré-requisitos
- Docker e Docker Compose
- Flutter SDK 3.27+ (para desenvolvimento frontend)
- Python 3.11+ (para desenvolvimento backend)

### 1. Iniciar Backend com Docker

```bash
cd crm-imobiliario
docker-compose up -d
```

Isso irá iniciar:
- PostgreSQL na porta 5432
- Redis na porta 6379
- FastAPI na porta 8000

### 2. Acessar API

- **API Docs (Swagger):** http://localhost:8000/docs
- **ReDoc:** http://localhost:8000/redoc
- **Health Check:** http://localhost:8000/health

### 3. Executar Frontend Flutter Web

```bash
cd frontend
flutter run -d chrome
```

Ou para build de produção:

```bash
flutter build web
```

## 📡 API Endpoints

### Persons (Pessoas)

- `POST /api/persons` - Criar pessoa
- `GET /api/persons` - Listar pessoas (com filtros)
- `GET /api/persons/{id}` - Buscar pessoa por ID
- `PUT /api/persons/{id}` - Atualizar pessoa
- `DELETE /api/persons/{id}` - Deletar pessoa (soft delete)
- `GET /api/persons/stats/summary` - Estatísticas

### Companies (Imobiliárias)

- `POST /api/companies` - Criar imobiliária
- `GET /api/companies` - Listar imobiliárias (com filtros)
- `GET /api/companies/{id}` - Buscar imobiliária por ID
- `PUT /api/companies/{id}` - Atualizar imobiliária
- `DELETE /api/companies/{id}` - Deletar imobiliária (soft delete)
- `GET /api/companies/{id}/employees` - Listar funcionários
- `GET /api/companies/stats/summary` - Estatísticas

## 🎨 Design System

### Cores

```dart
Primary:     #6366F1 (Indigo)
Secondary:   #8B5CF6 (Purple)
Accent:      #10B981 (Green)
Error:       #EF4444 (Red)

Background:  #0F172A (Slate 900)
Surface:     #1E293B (Slate 800)
Card:        #334155 (Slate 700)

Text Primary:   #F1F5F9 (Slate 100)
Text Secondary: #94A3B8 (Slate 400)
Text Disabled:  #475569 (Slate 600)
```

### Tipografia

- **Fonte:** Inter (Google Fonts)
- **Pesos:** 400 (Regular), 600 (SemiBold), 700 (Bold), 800 (ExtraBold)

## 🗄️ Banco de Dados

### Models

#### Person
- Tipo (PF/PJ)
- Dados pessoais (nome, email, telefone, CPF/CNPJ, RG)
- Endereço completo
- Papel no sistema
- Relacionamento com Company (opcional)
- Timestamps (created_at, updated_at)

#### Company
- Dados da empresa (Razão Social, Nome Fantasia, CNPJ)
- Contato (email, telefone, website)
- Endereço completo
- CRECI
- Plano contratado
- Relacionamento com Persons (employees)
- Timestamps (created_at, updated_at)

## 🔒 Segurança

- Validação de CPF/CNPJ
- Validação de email
- Soft delete (não remove dados do banco)
- CORS configurado
- Prepared statements (SQLAlchemy)

## 📈 Próximos Passos

- [ ] Autenticação e autorização (JWT)
- [ ] Upload de logo para imobiliárias
- [ ] Busca avançada com filtros
- [ ] Paginação otimizada
- [ ] Dashboard com gráficos
- [ ] Integração com CRMs externos
- [ ] Notificações por email
- [ ] Relatórios em PDF
- [ ] App mobile (iOS/Android)

## 📝 Licença

Projeto proprietário - Todos os direitos reservados

## 👥 Contato

Para dúvidas ou sugestões, entre em contato com a equipe de desenvolvimento.

---

**Desenvolvido com ❤️ usando Flutter e FastAPI**
