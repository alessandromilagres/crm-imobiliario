"""
Serviço de integração com BrasilAPI
https://brasilapi.com.br/
"""
import httpx
from fastapi import HTTPException
from typing import Dict, Any


class BrasilAPIService:
    """
    Cliente para integração com BrasilAPI
    """
    BASE_URL = "https://brasilapi.com.br/api"
    TIMEOUT = 10.0
    
    @staticmethod
    async def buscar_cnpj(cnpj: str) -> Dict[str, Any]:
        """
        Busca dados de uma empresa pelo CNPJ na BrasilAPI
        
        Args:
            cnpj: CNPJ da empresa (com ou sem formatação)
            
        Returns:
            Dicionário com dados da empresa
            
        Raises:
            HTTPException: Se houver erro na consulta
        """
        # Remove formatação do CNPJ
        cnpj_limpo = cnpj.replace(".", "").replace("/", "").replace("-", "").strip()
        
        # Valida se tem 14 dígitos
        if not cnpj_limpo.isdigit() or len(cnpj_limpo) != 14:
            raise HTTPException(
                status_code=400,
                detail="CNPJ inválido. Deve conter 14 dígitos."
            )
        
        # Faz requisição para BrasilAPI
        async with httpx.AsyncClient() as client:
            try:
                response = await client.get(
                    f"{BrasilAPIService.BASE_URL}/cnpj/v1/{cnpj_limpo}",
                    timeout=BrasilAPIService.TIMEOUT
                )
                
                if response.status_code == 200:
                    return response.json()
                elif response.status_code == 404:
                    raise HTTPException(
                        status_code=404,
                        detail="CNPJ não encontrado na base de dados da Receita Federal."
                    )
                elif response.status_code == 400:
                    raise HTTPException(
                        status_code=400,
                        detail="CNPJ inválido ou mal formatado."
                    )
                else:
                    raise HTTPException(
                        status_code=500,
                        detail=f"Erro ao consultar CNPJ na BrasilAPI. Status: {response.status_code}"
                    )
                    
            except httpx.TimeoutException:
                raise HTTPException(
                    status_code=504,
                    detail="Timeout ao consultar BrasilAPI. Tente novamente."
                )
            except httpx.RequestError as e:
                raise HTTPException(
                    status_code=503,
                    detail=f"Erro de conexão com BrasilAPI: {str(e)}"
                )
            except HTTPException:
                raise
            except Exception as e:
                raise HTTPException(
                    status_code=500,
                    detail=f"Erro inesperado ao consultar CNPJ: {str(e)}"
                )
    
    @staticmethod
    async def buscar_cep(cep: str) -> Dict[str, Any]:
        """
        Busca endereço pelo CEP na BrasilAPI
        
        Args:
            cep: CEP (com ou sem formatação)
            
        Returns:
            Dicionário com dados do endereço
            
        Raises:
            HTTPException: Se houver erro na consulta
        """
        # Remove formatação do CEP
        cep_limpo = cep.replace("-", "").replace(".", "").strip()
        
        # Valida se tem 8 dígitos
        if not cep_limpo.isdigit() or len(cep_limpo) != 8:
            raise HTTPException(
                status_code=400,
                detail="CEP inválido. Deve conter 8 dígitos."
            )
        
        # Faz requisição para BrasilAPI
        async with httpx.AsyncClient() as client:
            try:
                response = await client.get(
                    f"{BrasilAPIService.BASE_URL}/cep/v1/{cep_limpo}",
                    timeout=BrasilAPIService.TIMEOUT
                )
                
                if response.status_code == 200:
                    return response.json()
                elif response.status_code == 404:
                    raise HTTPException(
                        status_code=404,
                        detail="CEP não encontrado."
                    )
                else:
                    raise HTTPException(
                        status_code=500,
                        detail=f"Erro ao consultar CEP na BrasilAPI. Status: {response.status_code}"
                    )
                    
            except httpx.TimeoutException:
                raise HTTPException(
                    status_code=504,
                    detail="Timeout ao consultar BrasilAPI. Tente novamente."
                )
            except httpx.RequestError as e:
                raise HTTPException(
                    status_code=503,
                    detail=f"Erro de conexão com BrasilAPI: {str(e)}"
                )
            except HTTPException:
                raise
            except Exception as e:
                raise HTTPException(
                    status_code=500,
                    detail=f"Erro inesperado ao consultar CEP: {str(e)}"
                )
    
    @staticmethod
    def formatar_dados_empresa(dados: Dict[str, Any]) -> Dict[str, Any]:
        """
        Formata dados da empresa retornados pela BrasilAPI para o formato do CRM
        
        Args:
            dados: Dados brutos da BrasilAPI
            
        Returns:
            Dados formatados para o CRM
        """
        return {
            "company_name": dados.get("razao_social"),
            "trade_name": dados.get("nome_fantasia") or dados.get("razao_social"),
            "cnpj": dados.get("cnpj"),
            "email": dados.get("email"),
            "phone": dados.get("ddd_telefone_1"),
            "address_street": dados.get("logradouro"),
            "address_number": dados.get("numero"),
            "address_complement": dados.get("complemento"),
            "address_neighborhood": dados.get("bairro"),
            "address_city": dados.get("municipio"),
            "address_state": dados.get("uf"),
            "address_zipcode": dados.get("cep"),
            # Dados adicionais
            "capital_social": dados.get("capital_social"),
            "data_abertura": dados.get("data_inicio_atividade"),
            "situacao_cadastral": dados.get("descricao_situacao_cadastral"),
            "porte": dados.get("porte"),
            "cnae_fiscal": dados.get("cnae_fiscal"),
            "cnae_fiscal_descricao": dados.get("cnae_fiscal_descricao"),
            "natureza_juridica": dados.get("natureza_juridica"),
            "qsa": dados.get("qsa", []),  # Quadro de sócios e administradores
        }
    
    @staticmethod
    def formatar_dados_endereco(dados: Dict[str, Any]) -> Dict[str, Any]:
        """
        Formata dados de endereço retornados pela BrasilAPI
        
        Args:
            dados: Dados brutos da BrasilAPI
            
        Returns:
            Dados formatados para o CRM
        """
        return {
            "cep": dados.get("cep"),
            "state": dados.get("state"),
            "city": dados.get("city"),
            "neighborhood": dados.get("neighborhood"),
            "street": dados.get("street"),
            "location": dados.get("location"),
        }
