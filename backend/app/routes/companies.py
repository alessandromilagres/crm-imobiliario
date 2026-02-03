from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional

from ..database import get_db
from ..models.models import Company, Person
from ..schemas.schemas import CompanyCreate, CompanyUpdate, CompanyResponse

router = APIRouter(prefix="/api/companies", tags=["Companies"])


@router.post("/", response_model=CompanyResponse, status_code=201)
def create_company(company: CompanyCreate, db: Session = Depends(get_db)):
    """
    Criar nova imobiliária
    """
    # Verificar se CNPJ já existe
    existing = db.query(Company).filter(Company.cnpj == company.cnpj).first()
    if existing:
        raise HTTPException(status_code=400, detail="CNPJ já cadastrado")
    
    # Verificar se email já existe
    existing_email = db.query(Company).filter(Company.email == company.email).first()
    if existing_email:
        raise HTTPException(status_code=400, detail="Email já cadastrado")
    
    # Criar imobiliária
    db_company = Company(**company.model_dump())
    db.add(db_company)
    db.commit()
    db.refresh(db_company)
    
    return db_company


@router.get("/", response_model=List[CompanyResponse])
def list_companies(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    is_active: Optional[bool] = None,
    plan_type: Optional[str] = None,
    search: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """
    Listar imobiliárias com filtros e paginação
    """
    query = db.query(Company)
    
    # Filtros
    if is_active is not None:
        query = query.filter(Company.is_active == is_active)
    if plan_type:
        query = query.filter(Company.plan_type == plan_type)
    if search:
        search_filter = f"%{search}%"
        query = query.filter(
            (Company.company_name.ilike(search_filter)) |
            (Company.trade_name.ilike(search_filter)) |
            (Company.cnpj.ilike(search_filter)) |
            (Company.email.ilike(search_filter))
        )
    
    # Ordenar por data de criação (mais recente primeiro)
    query = query.order_by(Company.created_at.desc())
    
    # Paginação
    companies = query.offset(skip).limit(limit).all()
    
    return companies


@router.get("/{company_id}", response_model=CompanyResponse)
def get_company(company_id: int, db: Session = Depends(get_db)):
    """
    Buscar imobiliária por ID
    """
    company = db.query(Company).filter(Company.id == company_id).first()
    if not company:
        raise HTTPException(status_code=404, detail="Imobiliária não encontrada")
    return company


@router.put("/{company_id}", response_model=CompanyResponse)
def update_company(
    company_id: int,
    company_update: CompanyUpdate,
    db: Session = Depends(get_db)
):
    """
    Atualizar dados de uma imobiliária
    """
    company = db.query(Company).filter(Company.id == company_id).first()
    if not company:
        raise HTTPException(status_code=404, detail="Imobiliária não encontrada")
    
    # Verificar CNPJ duplicado
    if company_update.cnpj and company_update.cnpj != company.cnpj:
        existing = db.query(Company).filter(Company.cnpj == company_update.cnpj).first()
        if existing:
            raise HTTPException(status_code=400, detail="CNPJ já cadastrado")
    
    # Verificar email duplicado
    if company_update.email and company_update.email != company.email:
        existing = db.query(Company).filter(Company.email == company_update.email).first()
        if existing:
            raise HTTPException(status_code=400, detail="Email já cadastrado")
    
    # Atualizar campos
    update_data = company_update.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(company, field, value)
    
    db.commit()
    db.refresh(company)
    
    return company


@router.delete("/{company_id}")
def delete_company(company_id: int, db: Session = Depends(get_db)):
    """
    Deletar imobiliária (soft delete)
    """
    company = db.query(Company).filter(Company.id == company_id).first()
    if not company:
        raise HTTPException(status_code=404, detail="Imobiliária não encontrada")
    
    # Soft delete
    company.is_active = False
    db.commit()
    
    return {"message": "Imobiliária desativada com sucesso"}


@router.get("/{company_id}/employees")
def get_company_employees(
    company_id: int,
    db: Session = Depends(get_db)
):
    """
    Listar funcionários de uma imobiliária
    """
    company = db.query(Company).filter(Company.id == company_id).first()
    if not company:
        raise HTTPException(status_code=404, detail="Imobiliária não encontrada")
    
    employees = db.query(Person).filter(Person.company_id == company_id).all()
    
    return {
        "company_id": company_id,
        "company_name": company.trade_name,
        "total_employees": len(employees),
        "employees": employees
    }


@router.get("/stats/summary")
def get_companies_stats(db: Session = Depends(get_db)):
    """
    Estatísticas de imobiliárias cadastradas
    """
    total = db.query(Company).count()
    total_active = db.query(Company).filter(Company.is_active == True).count()
    total_basic = db.query(Company).filter(Company.plan_type == "basic").count()
    total_professional = db.query(Company).filter(Company.plan_type == "professional").count()
    total_enterprise = db.query(Company).filter(Company.plan_type == "enterprise").count()
    
    return {
        "total": total,
        "total_active": total_active,
        "total_inactive": total - total_active,
        "by_plan": {
            "basic": total_basic,
            "professional": total_professional,
            "enterprise": total_enterprise
        }
    }
