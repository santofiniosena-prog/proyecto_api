import 'dart:convert';

import 'package:http/http.dart' as http;

import '/domain/entities/user_entity.dart';

import '/domain/repositories/user_repository.dart';

import '/data/models/user_model.dart';


class UserRepositoryImpl implements UserRepository {

final String baseUrl = "https://node-api-1h5r.onrender.com/api/users";


@override

Future<List<UserEntity>> getUsers() async {

final response = await http.get(Uri.parse(baseUrl));

if (response.statusCode == 200) {

List data = json.decode(response.body);

return data.map((json) => UserModel.fromJson(json)).toList();

}

throw Exception("Error al obtener usuarios");

}


@override

Future<void> createUser(UserEntity user) async {

final model = UserModel(name: user.name, email: user.email, age: user.age);

await http.post(Uri.parse(baseUrl),

body: json.encode(model.toJson()),

headers: {"Content-Type": "application/json"});

}


@override

Future<void> updateUser(UserEntity user) async {

final model = UserModel(name: user.name, email: user.email, age: user.age);

await http.put(Uri.parse("$baseUrl/${user.id}"),

body: json.encode(model.toJson()),

headers: {"Content-Type": "application/json"});

}




@override

Future<void> deleteUser(String id) async {

await http.delete(Uri.parse("$baseUrl/$id"));

}

}