from sqlalchemy import Column, Integer, String, DateTime, Boolean, ForeignKey, Enum, Text, Numeric
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from datetime import datetime
import enum

from ..database import Base


class PersonType(str, enum.Enum):
    """Tipo de pessoa"""
    PF = "PF"  # Pessoa Física
    PJ = "PJ"  # Pessoa Jurídica


class UserRole(str, enum.Enum):
    """Papel do usuário no sistema"""
    ADMIN = "admin"
    CORRETOR = "corretor"
    VENDEDOR = "vendedor"
    CLIENTE = "cliente"
    GESTOR = "gestor"


class Person(Base):
    """
    Modelo de Pessoa (PF ou PJ)
    Armazena clientes, corretores, vendedores, etc.
    """
    __tablename__ = "persons"

    id = Column(Integer, primary_key=True, index=True)
    
    # Tipo de pessoa
    person_type = Column(Enum(PersonType), nullable=False, default=PersonType.PF)
    
    # Dados básicos
    name = Column(String(255), nullable=False, index=True)
    email = Column(String(255), unique=True, nullable=False, index=True)
    phone = Column(String(20), nullable=True)
    mobile = Column(String(20), nullable=True)
    
    # Documentos
    cpf = Column(String(14), unique=True, nullable=True, index=True)  # Para PF
    cnpj = Column(String(18), unique=True, nullable=True, index=True)  # Para PJ
    rg = Column(String(20), nullable=True)
    
    # Endereço
    address_street = Column(String(255), nullable=True)
    address_number = Column(String(20), nullable=True)
    address_complement = Column(String(100), nullable=True)
    address_neighborhood = Column(String(100), nullable=True)
    address_city = Column(String(100), nullable=True)
    address_state = Column(String(2), nullable=True)
    address_zipcode = Column(String(10), nullable=True)
    
    # Papel no sistema
    role = Column(Enum(UserRole), nullable=False, default=UserRole.CLIENTE)
    
    # Relacionamento com imobiliária (se for corretor/vendedor)
    company_id = Column(Integer, ForeignKey("companies.id"), nullable=True)
    company = relationship("Company", back_populates="employees")
    
    # Observações
    notes = Column(Text, nullable=True)
    
    # Status
    is_active = Column(Boolean, default=True)
    
    # Timestamps
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    def __repr__(self):
        return f"<Person {self.name} ({self.person_type})>"


class Company(Base):
    """
    Modelo de Imobiliária
    Empresa que usa a plataforma
    """
    __tablename__ = "companies"

    id = Column(Integer, primary_key=True, index=True)
    
    # Dados básicos
    company_name = Column(String(255), nullable=False)  # Razão Social
    trade_name = Column(String(255), nullable=False, index=True)  # Nome Fantasia
    cnpj = Column(String(18), unique=True, nullable=False, index=True)
    
    # Contato
    email = Column(String(255), nullable=False)
    phone = Column(String(20), nullable=True)
    website = Column(String(255), nullable=True)
    
    # Endereço
    address_street = Column(String(255), nullable=True)
    address_number = Column(String(20), nullable=True)
    address_complement = Column(String(100), nullable=True)
    address_neighborhood = Column(String(100), nullable=True)
    address_city = Column(String(100), nullable=True)
    address_state = Column(String(2), nullable=True)
    address_zipcode = Column(String(10), nullable=True)
    
    # Logo
    logo_url = Column(String(500), nullable=True)
    
    # CRECI (registro profissional)
    creci = Column(String(20), nullable=True)
    
    # Plano contratado
    plan_type = Column(String(50), default="basic")  # basic, professional, enterprise
    
    # Relacionamentos
    employees = relationship("Person", back_populates="company")
    
    # Observações
    notes = Column(Text, nullable=True)
    
    # Status
    is_active = Column(Boolean, default=True)
    
    # Timestamps
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    def __repr__(self):
        return f"<Company {self.trade_name}>"
