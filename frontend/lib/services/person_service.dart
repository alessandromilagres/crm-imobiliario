import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/person.dart';

class PersonService {
  // URL base da API - ajustar conforme ambiente
  static const String baseUrl = 'http://localhost:8000/api/persons';

  // Criar nova pessoa
  Future<Person> createPerson(Person person) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(person.toJson()),
      );

      if (response.statusCode == 201) {
        return Person.fromJson(jsonDecode(response.body));
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Erro ao criar pessoa');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Listar pessoas
  Future<List<Person>> listPersons({
    int skip = 0,
    int limit = 100,
    String? personType,
    String? role,
    bool? isActive,
    String? search,
  }) async {
    try {
      final queryParams = <String, String>{
        'skip': skip.toString(),
        'limit': limit.toString(),
      };

      if (personType != null) queryParams['person_type'] = personType;
      if (role != null) queryParams['role'] = role;
      if (isActive != null) queryParams['is_active'] = isActive.toString();
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Person.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao listar pessoas');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Buscar pessoa por ID
  Future<Person> getPerson(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return Person.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Pessoa não encontrada');
      } else {
        throw Exception('Erro ao buscar pessoa');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Atualizar pessoa
  Future<Person> updatePerson(int id, Map<String, dynamic> updates) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updates),
      );

      if (response.statusCode == 200) {
        return Person.fromJson(jsonDecode(response.body));
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Erro ao atualizar pessoa');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Deletar pessoa (soft delete)
  Future<void> deletePerson(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Erro ao deletar pessoa');
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
