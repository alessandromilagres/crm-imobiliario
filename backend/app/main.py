from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

from .database import engine, Base
from .routes import persons, companies, brasilapi


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: Criar tabelas
    print("🚀 Criando tabelas do banco de dados...")
    Base.metadata.create_all(bind=engine)
    print("✅ Tabelas criadas com sucesso!")
    yield
    # Shutdown
    print("👋 Encerrando aplicação...")


# Criar aplicação FastAPI
app = FastAPI(
    title="CRM Imobiliário API",
    description="API REST para sistema de CRM imobiliário com cadastro de pessoas e imobiliárias",
    version="1.0.0",
    lifespan=lifespan
)

# Configurar CORS para Flutter Web
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Em produção, especificar domínios
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Incluir rotas
app.include_router(persons.router)
app.include_router(companies.router)
app.include_router(brasilapi.router)


@app.get("/")
def root():
    """
    Endpoint raiz - Health check
    """
    return {
        "message": "CRM Imobiliário API",
        "version": "1.0.0",
        "status": "online",
        "docs": "/docs",
        "redoc": "/redoc"
    }


@app.get("/health")
def health_check():
    """
    Health check endpoint
    """
    return {
        "status": "healthy",
        "database": "connected"
    }
