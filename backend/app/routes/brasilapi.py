"""
Rotas para integração com BrasilAPI
"""
from fastapi import APIRouter, HTTPException
from app.services.brasilapi import BrasilAPIService

router = APIRouter(prefix="/api/brasilapi", tags=["BrasilAPI"])


@router.get("/cnpj/{cnpj}")
async def buscar_cnpj(cnpj: str):
    """
    Busca dados de uma empresa pelo CNPJ
    
    Retorna informações completas da empresa incluindo:
    - Razão social e nome fantasia
    - Endereço completo
    - Situação cadastral
    - Capital social
    - Quadro de sócios
    - CNAE (atividade econômica)
    - E muito mais!
    
    **Fonte:** BrasilAPI (dados da Receita Federal)
    """
    dados_brutos = await BrasilAPIService.buscar_cnpj(cnpj)
    dados_formatados = BrasilAPIService.formatar_dados_empresa(dados_brutos)
    
    return {
        "success": True,
        "data": dados_formatados,
        "raw_data": dados_brutos  # Dados completos para referência
    }


@router.get("/cep/{cep}")
async def buscar_cep(cep: str):
    """
    Busca endereço pelo CEP
    
    Retorna informações de endereço incluindo:
    - Estado (UF)
    - Cidade
    - Bairro
    - Rua/Logradouro
    - Coordenadas geográficas (quando disponível)
    
    **Fonte:** BrasilAPI (dados dos Correios)
    """
    dados_brutos = await BrasilAPIService.buscar_cep(cep)
    dados_formatados = BrasilAPIService.formatar_dados_endereco(dados_brutos)
    
    return {
        "success": True,
        "data": dados_formatados,
        "raw_data": dados_brutos
    }


@router.get("/validar-cnpj/{cnpj}")
async def validar_cnpj(cnpj: str):
    """
    Valida se um CNPJ existe e está ativo
    
    Retorna apenas informações básicas:
    - Razão social
    - Situação cadastral
    - Data de abertura
    """
    try:
        dados = await BrasilAPIService.buscar_cnpj(cnpj)
        
        return {
            "success": True,
            "valid": True,
            "active": dados.get("situacao_cadastral") == 2,  # 2 = ATIVA
            "razao_social": dados.get("razao_social"),
            "situacao": dados.get("descricao_situacao_cadastral"),
            "data_abertura": dados.get("data_inicio_atividade")
        }
    except HTTPException as e:
        if e.status_code == 404:
            return {
                "success": False,
                "valid": False,
                "message": "CNPJ não encontrado"
            }
        raise
