import 'package:http/http.dart' as http;
import 'dart:convert';

class BrasilAPIService {
  // URL base da API (ajustar conforme ambiente)
  static const String baseUrl = 'http://localhost:8000/api/brasilapi';
  
  /// Busca dados de empresa pelo CNPJ
  Future<Map<String, dynamic>> buscarCNPJ(String cnpj) async {
    // Remove formatação
    final cnpjLimpo = cnpj.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cnpjLimpo.length != 14) {
      throw Exception('CNPJ inválido. Deve conter 14 dígitos.');
    }
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cnpj/$cnpjLimpo'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          return jsonData['data'];
        } else {
          throw Exception('Erro ao buscar CNPJ');
        }
      } else if (response.statusCode == 404) {
        throw Exception('CNPJ não encontrado na Receita Federal');
      } else if (response.statusCode == 400) {
        throw Exception('CNPJ inválido ou mal formatado');
      } else {
        throw Exception('Erro ao consultar CNPJ (${response.statusCode})');
      }
    } on http.ClientException {
      throw Exception('Erro de conexão. Verifique sua internet.');
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Timeout. A consulta demorou muito. Tente novamente.');
      }
      rethrow;
    }
  }
  
  /// Busca endereço pelo CEP
  Future<Map<String, dynamic>> buscarCEP(String cep) async {
    // Remove formatação
    final cepLimpo = cep.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cepLimpo.length != 8) {
      throw Exception('CEP inválido. Deve conter 8 dígitos.');
    }
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cep/$cepLimpo'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          return jsonData['data'];
        } else {
          throw Exception('Erro ao buscar CEP');
        }
      } else if (response.statusCode == 404) {
        throw Exception('CEP não encontrado');
      } else {
        throw Exception('Erro ao consultar CEP (${response.statusCode})');
      }
    } on http.ClientException {
      throw Exception('Erro de conexão. Verifique sua internet.');
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Timeout. Tente novamente.');
      }
      rethrow;
    }
  }
  
  /// Valida se CNPJ existe e está ativo
  Future<bool> validarCNPJ(String cnpj) async {
    final cnpjLimpo = cnpj.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cnpjLimpo.length != 14) {
      return false;
    }
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/validar-cnpj/$cnpjLimpo'),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['valid'] == true && jsonData['active'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  /// Valida CNPJ localmente (algoritmo)
  static bool validarCNPJLocal(String cnpj) {
    final cnpjLimpo = cnpj.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cnpjLimpo.length != 14) return false;
    
    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1{13}$').hasMatch(cnpjLimpo)) return false;
    
    // Calcula primeiro dígito verificador
    var soma = 0;
    var peso = 5;
    for (var i = 0; i < 12; i++) {
      soma += int.parse(cnpjLimpo[i]) * peso;
      peso = peso == 2 ? 9 : peso - 1;
    }
    var digito1 = soma % 11 < 2 ? 0 : 11 - (soma % 11);
    
    if (digito1 != int.parse(cnpjLimpo[12])) return false;
    
    // Calcula segundo dígito verificador
    soma = 0;
    peso = 6;
    for (var i = 0; i < 13; i++) {
      soma += int.parse(cnpjLimpo[i]) * peso;
      peso = peso == 2 ? 9 : peso - 1;
    }
    var digito2 = soma % 11 < 2 ? 0 : 11 - (soma % 11);
    
    return digito2 == int.parse(cnpjLimpo[13]);
  }
  
  /// Valida CPF localmente (algoritmo)
  static bool validarCPFLocal(String cpf) {
    final cpfLimpo = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cpfLimpo.length != 11) return false;
    
    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cpfLimpo)) return false;
    
    // Calcula primeiro dígito verificador
    var soma = 0;
    for (var i = 0; i < 9; i++) {
      soma += int.parse(cpfLimpo[i]) * (10 - i);
    }
    var digito1 = (soma * 10) % 11;
    if (digito1 == 10) digito1 = 0;
    
    if (digito1 != int.parse(cpfLimpo[9])) return false;
    
    // Calcula segundo dígito verificador
    soma = 0;
    for (var i = 0; i < 10; i++) {
      soma += int.parse(cpfLimpo[i]) * (11 - i);
    }
    var digito2 = (soma * 10) % 11;
    if (digito2 == 10) digito2 = 0;
    
    return digito2 == int.parse(cpfLimpo[10]);
  }
}
