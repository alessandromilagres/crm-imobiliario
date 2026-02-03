from pydantic import BaseModel, EmailStr, Field, validator
from typing import Optional
from datetime import datetime
from enum import Enum


class PersonType(str, Enum):
    PF = "PF"
    PJ = "PJ"


class UserRole(str, Enum):
    ADMIN = "admin"
    CORRETOR = "corretor"
    VENDEDOR = "vendedor"
    CLIENTE = "cliente"
    GESTOR = "gestor"


# ============= PERSON SCHEMAS =============

class PersonBase(BaseModel):
    person_type: PersonType
    name: str = Field(..., min_length=3, max_length=255)
    email: EmailStr
    phone: Optional[str] = None
    mobile: Optional[str] = None
    cpf: Optional[str] = None
    cnpj: Optional[str] = None
    rg: Optional[str] = None
    address_street: Optional[str] = None
    address_number: Optional[str] = None
    address_complement: Optional[str] = None
    address_neighborhood: Optional[str] = None
    address_city: Optional[str] = None
    address_state: Optional[str] = Field(None, max_length=2)
    address_zipcode: Optional[str] = None
    role: UserRole = UserRole.CLIENTE
    company_id: Optional[int] = None
    notes: Optional[str] = None
    is_active: bool = True

    @validator('cpf')
    def validate_cpf(cls, v):
        if v:
            # Remove formatação
            v = v.replace('.', '').replace('-', '').replace('/', '')
            if len(v) != 11:
                raise ValueError('CPF deve ter 11 dígitos')
        return v

    @validator('cnpj')
    def validate_cnpj(cls, v):
        if v:
            # Remove formatação
            v = v.replace('.', '').replace('-', '').replace('/', '')
            if len(v) != 14:
                raise ValueError('CNPJ deve ter 14 dígitos')
        return v


class PersonCreate(PersonBase):
    pass


class PersonUpdate(BaseModel):
    person_type: Optional[PersonType] = None
    name: Optional[str] = Field(None, min_length=3, max_length=255)
    email: Optional[EmailStr] = None
    phone: Optional[str] = None
    mobile: Optional[str] = None
    cpf: Optional[str] = None
    cnpj: Optional[str] = None
    rg: Optional[str] = None
    address_street: Optional[str] = None
    address_number: Optional[str] = None
    address_complement: Optional[str] = None
    address_neighborhood: Optional[str] = None
    address_city: Optional[str] = None
    address_state: Optional[str] = Field(None, max_length=2)
    address_zipcode: Optional[str] = None
    role: Optional[UserRole] = None
    company_id: Optional[int] = None
    notes: Optional[str] = None
    is_active: Optional[bool] = None


class PersonResponse(PersonBase):
    id: int
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


# ============= COMPANY SCHEMAS =============

class CompanyBase(BaseModel):
    company_name: str = Field(..., min_length=3, max_length=255)
    trade_name: str = Field(..., min_length=3, max_length=255)
    cnpj: str = Field(..., min_length=14, max_length=18)
    email: EmailStr
    phone: Optional[str] = None
    website: Optional[str] = None
    address_street: Optional[str] = None
    address_number: Optional[str] = None
    address_complement: Optional[str] = None
    address_neighborhood: Optional[str] = None
    address_city: Optional[str] = None
    address_state: Optional[str] = Field(None, max_length=2)
    address_zipcode: Optional[str] = None
    logo_url: Optional[str] = None
    creci: Optional[str] = None
    plan_type: str = "basic"
    notes: Optional[str] = None
    is_active: bool = True

    @validator('cnpj')
    def validate_cnpj(cls, v):
        if v:
            # Remove formatação
            v = v.replace('.', '').replace('-', '').replace('/', '')
            if len(v) != 14:
                raise ValueError('CNPJ deve ter 14 dígitos')
        return v


class CompanyCreate(CompanyBase):
    pass


class CompanyUpdate(BaseModel):
    company_name: Optional[str] = Field(None, min_length=3, max_length=255)
    trade_name: Optional[str] = Field(None, min_length=3, max_length=255)
    cnpj: Optional[str] = Field(None, min_length=14, max_length=18)
    email: Optional[EmailStr] = None
    phone: Optional[str] = None
    website: Optional[str] = None
    address_street: Optional[str] = None
    address_number: Optional[str] = None
    address_complement: Optional[str] = None
    address_neighborhood: Optional[str] = None
    address_city: Optional[str] = None
    address_state: Optional[str] = Field(None, max_length=2)
    address_zipcode: Optional[str] = None
    logo_url: Optional[str] = None
    creci: Optional[str] = None
    plan_type: Optional[str] = None
    notes: Optional[str] = None
    is_active: Optional[bool] = None


class CompanyResponse(CompanyBase):
    id: int
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True


# ============= RESPONSE MODELS =============

class MessageResponse(BaseModel):
    message: str
    detail: Optional[str] = None


class PaginatedResponse(BaseModel):
    total: int
    page: int
    page_size: int
    items: list
