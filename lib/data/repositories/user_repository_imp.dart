import 'dart:convert';

import 'package:http/http.dart' as http;

import '/domain/entities/user_entity.dart';
import '/domain/repositories/user_repository.dart';
import '/data/models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final String baseUrl = const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api/users',
  );

  @override
  Future<List<UserEntity>> getUsers() async {
    final response = await http.get(
      Uri.parse(baseUrl),
    );

    print("GET STATUS: ${response.statusCode}");
    print("GET RESPUESTA: ${response.body}");

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      return data
          .map((json) => UserModel.fromJson(json))
          .toList();
    }

    throw Exception(
      "Error al obtener usuarios: ${response.statusCode}",
    );
  }

  @override
  Future<void> createUser(UserEntity user) async {
    final model = UserModel(
      name: user.name,
      email: user.email,
      age: user.age,
    );

    final response = await http.post(
      Uri.parse(baseUrl),
      body: json.encode(model.toJson()),
      headers: {
        "Content-Type": "application/json",
      },
    );

    print("POST STATUS: ${response.statusCode}");
    print("POST RESPUESTA: ${response.body}");

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        "Error al crear usuario: ${response.statusCode} - ${response.body}",
      );
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final model = UserModel(
      name: user.name,
      email: user.email,
      age: user.age,
    );

    final response = await http.put(
      Uri.parse("$baseUrl/${user.id}"),
      body: json.encode(model.toJson()),
      headers: {
        "Content-Type": "application/json",
      },
    );

    print("PUT STATUS: ${response.statusCode}");
    print("PUT RESPUESTA: ${response.body}");

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        "Error al actualizar usuario: ${response.statusCode} - ${response.body}",
      );
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/$id"),
    );

    print("DELETE STATUS: ${response.statusCode}");
    print("DELETE RESPUESTA: ${response.body}");

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        "Error al eliminar usuario: ${response.statusCode} - ${response.body}",
      );
    }
  }
}