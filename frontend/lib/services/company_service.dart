import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/company.dart';

class CompanyService {
  // URL base da API - ajustar conforme ambiente
  static const String baseUrl = 'http://localhost:8000/api/companies';

  // Criar nova imobiliária
  Future<Company> createCompany(Company company) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(company.toJson()),
      );

      if (response.statusCode == 201) {
        return Company.fromJson(jsonDecode(response.body));
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Erro ao criar imobiliária');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Listar imobiliárias
  Future<List<Company>> listCompanies({
    int skip = 0,
    int limit = 100,
    bool? isActive,
    String? planType,
    String? search,
  }) async {
    try {
      final queryParams = <String, String>{
        'skip': skip.toString(),
        'limit': limit.toString(),
      };

      if (isActive != null) queryParams['is_active'] = isActive.toString();
      if (planType != null) queryParams['plan_type'] = planType;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Company.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao listar imobiliárias');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Buscar imobiliária por ID
  Future<Company> getCompany(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return Company.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Imobiliária não encontrada');
      } else {
        throw Exception('Erro ao buscar imobiliária');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Atualizar imobiliária
  Future<Company> updateCompany(int id, Map<String, dynamic> updates) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updates),
      );

      if (response.statusCode == 200) {
        return Company.fromJson(jsonDecode(response.body));
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Erro ao atualizar imobiliária');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Deletar imobiliária (soft delete)
  Future<void> deleteCompany(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Erro ao deletar imobiliária');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Listar funcionários de uma imobiliária
  Future<Map<String, dynamic>> getEmployees(int companyId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$companyId/employees'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erro ao buscar funcionários');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Estatísticas
  Future<Map<String, dynamic>> getStats() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/stats/summary'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erro ao buscar estatísticas');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
