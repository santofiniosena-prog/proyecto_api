import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  // GET - Obtener todos los usuarios
  Future<List<dynamic>> getUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener los usuarios');
    }
  }

  // POST - Crear un usuario
  Future<Map<String, dynamic>> createUser(
    String name,
    String email,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al crear el usuario');
    }
  }

  // PUT - Actualizar un usuario
  Future<Map<String, dynamic>> updateUser(
    String id,
    String name,
    String email,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al actualizar el usuario');
    }
  }

  // DELETE - Eliminar un usuario
  Future<void> deleteUser(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el usuario');
    }
  }
}