import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static String baseUrl = "http://localhost:3001";

  static Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));

    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }catch(e){
        return <String, String>{"message": response.body};
      }
    } else {
      throw Exception(response.body);
    }
  }

  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      try {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }catch(e){
        return <String, String>{"message": response.body};
      }
    } else {
      throw Exception(response.body);
    }
  }

  static Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }catch(e){
        return <String, String>{"message": response.body};
      }
    } else {
      throw Exception('Falha ao atualizar dados');
    }
  }

  static Future<void> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$baseUrl/$endpoint'));
    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }
}