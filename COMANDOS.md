# 🛠️ COMANDOS ÚTEIS - CRM IMOBILIÁRIO

## 🐘 PostgreSQL

### Iniciar PostgreSQL
```bash
sudo service postgresql start
```

### Conectar ao banco
```bash
sudo -u postgres psql -d crm_imobiliario
```

### Ver tabelas
```sql
\dt
```

### Ver estrutura de uma tabela
```sql
\d persons
\d companies
```

### Queries úteis
```sql
-- Contar pessoas
SELECT COUNT(*) FROM persons;

-- Contar imobiliárias
SELECT COUNT(*) FROM companies;

-- Listar pessoas com imobiliárias
SELECT p.name, p.role, c.trade_name 
FROM persons p 
LEFT JOIN companies c ON p.company_id = c.id;
```

---

## 🐍 Backend (FastAPI)

### Instalar dependências
```bash
cd backend
sudo pip3 install -r requirements.txt
```

### Iniciar servidor (desenvolvimento)
```bash
cd backend
export DATABASE_URL="postgresql://crm_user:crm_password@localhost:5432/crm_imobiliario"
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### Iniciar servidor (produção)
```bash
cd backend
export DATABASE_URL="postgresql://crm_user:crm_password@localhost:5432/crm_imobiliario"
uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 4
```

### Verificar health
```bash
curl http://localhost:8000/health
```

### Ver logs
```bash
tail -f /tmp/backend.log
```

---

## 🎨 Frontend (Flutter Web)

### Instalar dependências
```bash
cd frontend
flutter pub get
```

### Executar em modo desenvolvimento
```bash
cd frontend
flutter run -d chrome --web-port=3000
```

### Build de produção
```bash
cd frontend
flutter build web --release
```

### Servir build local
```bash
cd frontend/build/web
python3 -m http.server 3000
```

---

## 🧪 Testes da API

### Criar Pessoa (PF)
```bash
curl -X POST http://localhost:8000/api/persons/ \
  -H "Content-Type: application/json" \
  -d '{
    "person_type": "PF",
    "name": "Maria Santos",
    "email": "maria@example.com",
    "cpf": "98765432100",
    "mobile": "(11) 99999-8888",
    "role": "corretor"
  }'
```

### Criar Pessoa (PJ)
```bash
curl -X POST http://localhost:8000/api/persons/ \
  -H "Content-Type: application/json" \
  -d '{
    "person_type": "PJ",
    "name": "Empresa XYZ Ltda",
    "email": "empresa@xyz.com",
    "cnpj": "11222333000144",
    "role": "cliente"
  }'
```

### Criar Imobiliária
```bash
curl -X POST http://localhost:8000/api/companies/ \
  -H "Content-Type: application/json" \
  -d '{
    "company_name": "Imobiliária Premium Ltda",
    "trade_name": "Premium Imóveis",
    "cnpj": "99888777000166",
    "email": "contato@premium.com.br",
    "phone": "(11) 3000-4000",
    "creci": "CRECI-SP 54321",
    "plan_type": "enterprise"
  }'
```

### Listar Pessoas
```bash
curl http://localhost:8000/api/persons/
```

### Listar Imobiliárias
```bash
curl http://localhost:8000/api/companies/
```

### Buscar Pessoa por ID
```bash
curl http://localhost:8000/api/persons/1
```

### Atualizar Pessoa
```bash
curl -X PUT http://localhost:8000/api/persons/1 \
  -H "Content-Type: application/json" \
  -d '{
    "phone": "(11) 3333-4444"
  }'
```

### Deletar Pessoa (soft delete)
```bash
curl -X DELETE http://localhost:8000/api/persons/1
```

### Estatísticas de Pessoas
```bash
curl http://localhost:8000/api/persons/stats/summary
```

### Estatísticas de Imobiliárias
```bash
curl http://localhost:8000/api/companies/stats/summary
```

### Buscar com filtros
```bash
# Filtrar por tipo
curl "http://localhost:8000/api/persons/?person_type=PF"

# Filtrar por papel
curl "http://localhost:8000/api/persons/?role=corretor"

# Buscar por texto
curl "http://localhost:8000/api/persons/?search=maria"

# Combinar filtros
curl "http://localhost:8000/api/persons/?person_type=PF&role=corretor&is_active=true"
```

---

## 🐳 Docker

### Iniciar todos os serviços
```bash
docker-compose up -d
```

### Ver logs
```bash
docker-compose logs -f
```

### Parar serviços
```bash
docker-compose down
```

### Rebuild
```bash
docker-compose up -d --build
```

### Limpar volumes
```bash
docker-compose down -v
```

---

## 🔧 Desenvolvimento

### Criar nova migration (Alembic)
```bash
cd backend
alembic revision --autogenerate -m "descrição da mudança"
```

### Aplicar migrations
```bash
cd backend
alembic upgrade head
```

### Reverter migration
```bash
cd backend
alembic downgrade -1
```

### Formatar código Python
```bash
cd backend
black app/
```

### Formatar código Dart
```bash
cd frontend
dart format lib/
```

---

## 📊 Monitoramento

### Ver processos
```bash
ps aux | grep uvicorn
ps aux | grep postgres
```

### Ver portas em uso
```bash
sudo netstat -tulpn | grep 8000
sudo netstat -tulpn | grep 5432
```

### Matar processo
```bash
kill -9 <PID>
```

---

## 🚀 Deploy

### Build Docker
```bash
docker build -t crm-backend:latest ./backend
```

### Run Docker
```bash
docker run -d -p 8000:8000 \
  -e DATABASE_URL="postgresql://user:pass@host:5432/db" \
  crm-backend:latest
```

### Deploy Flutter Web
```bash
cd frontend
flutter build web --release
# Copiar conteúdo de build/web para servidor web
```

---

## 🧹 Limpeza

### Limpar cache Python
```bash
find . -type d -name "__pycache__" -exec rm -r {} +
find . -type f -name "*.pyc" -delete
```

### Limpar cache Flutter
```bash
cd frontend
flutter clean
```

### Limpar logs
```bash
rm /tmp/backend.log
```

---

## 📝 Notas

- Sempre use `sudo` para comandos do PostgreSQL
- Backend roda na porta 8000
- Frontend roda na porta 3000 (ou escolhida)
- PostgreSQL roda na porta 5432
- Redis roda na porta 6379 (se configurado)

