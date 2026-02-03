from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional

from ..database import get_db
from ..models.models import Person
from ..schemas.schemas import PersonCreate, PersonUpdate, PersonResponse, PaginatedResponse

router = APIRouter(prefix="/api/persons", tags=["Persons"])


@router.post("/", response_model=PersonResponse, status_code=201)
def create_person(person: PersonCreate, db: Session = Depends(get_db)):
    """
    Criar nova pessoa (PF ou PJ)
    """
    # Verificar se email já existe
    existing = db.query(Person).filter(Person.email == person.email).first()
    if existing:
        raise HTTPException(status_code=400, detail="Email já cadastrado")
    
    # Verificar CPF se for PF
    if person.person_type == "PF" and person.cpf:
        existing_cpf = db.query(Person).filter(Person.cpf == person.cpf).first()
        if existing_cpf:
            raise HTTPException(status_code=400, detail="CPF já cadastrado")
    
    # Verificar CNPJ se for PJ
    if person.person_type == "PJ" and person.cnpj:
        existing_cnpj = db.query(Person).filter(Person.cnpj == person.cnpj).first()
        if existing_cnpj:
            raise HTTPException(status_code=400, detail="CNPJ já cadastrado")
    
    # Criar pessoa
    db_person = Person(**person.model_dump())
    db.add(db_person)
    db.commit()
    db.refresh(db_person)
    
    return db_person


@router.get("/", response_model=List[PersonResponse])
def list_persons(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    person_type: Optional[str] = None,
    role: Optional[str] = None,
    is_active: Optional[bool] = None,
    search: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """
    Listar pessoas com filtros e paginação
    """
    query = db.query(Person)
    
    # Filtros
    if person_type:
        query = query.filter(Person.person_type == person_type)
    if role:
        query = query.filter(Person.role == role)
    if is_active is not None:
        query = query.filter(Person.is_active == is_active)
    if search:
        search_filter = f"%{search}%"
        query = query.filter(
            (Person.name.ilike(search_filter)) |
            (Person.email.ilike(search_filter)) |
            (Person.cpf.ilike(search_filter)) |
            (Person.cnpj.ilike(search_filter))
        )
    
    # Ordenar por data de criação (mais recente primeiro)
    query = query.order_by(Person.created_at.desc())
    
    # Paginação
    persons = query.offset(skip).limit(limit).all()
    
    return persons


@router.get("/{person_id}", response_model=PersonResponse)
def get_person(person_id: int, db: Session = Depends(get_db)):
    """
    Buscar pessoa por ID
    """
    person = db.query(Person).filter(Person.id == person_id).first()
    if not person:
        raise HTTPException(status_code=404, detail="Pessoa não encontrada")
    return person


@router.put("/{person_id}", response_model=PersonResponse)
def update_person(
    person_id: int,
    person_update: PersonUpdate,
    db: Session = Depends(get_db)
):
    """
    Atualizar dados de uma pessoa
    """
    person = db.query(Person).filter(Person.id == person_id).first()
    if not person:
        raise HTTPException(status_code=404, detail="Pessoa não encontrada")
    
    # Verificar email duplicado
    if person_update.email and person_update.email != person.email:
        existing = db.query(Person).filter(Person.email == person_update.email).first()
        if existing:
            raise HTTPException(status_code=400, detail="Email já cadastrado")
    
    # Atualizar campos
    update_data = person_update.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(person, field, value)
    
    db.commit()
    db.refresh(person)
    
    return person


@router.delete("/{person_id}")
def delete_person(person_id: int, db: Session = Depends(get_db)):
    """
    Deletar pessoa (soft delete)
    """
    person = db.query(Person).filter(Person.id == person_id).first()
    if not person:
        raise HTTPException(status_code=404, detail="Pessoa não encontrada")
    
    # Soft delete
    person.is_active = False
    db.commit()
    
    return {"message": "Pessoa desativada com sucesso"}


@router.get("/stats/summary")
def get_persons_stats(db: Session = Depends(get_db)):
    """
    Estatísticas de pessoas cadastradas
    """
    total = db.query(Person).count()
    total_pf = db.query(Person).filter(Person.person_type == "PF").count()
    total_pj = db.query(Person).filter(Person.person_type == "PJ").count()
    total_corretores = db.query(Person).filter(Person.role == "corretor").count()
    total_vendedores = db.query(Person).filter(Person.role == "vendedor").count()
    total_active = db.query(Person).filter(Person.is_active == True).count()
    
    return {
        "total": total,
        "total_pf": total_pf,
        "total_pj": total_pj,
        "total_corretores": total_corretores,
        "total_vendedores": total_vendedores,
        "total_active": total_active,
        "total_inactive": total - total_active
    }
