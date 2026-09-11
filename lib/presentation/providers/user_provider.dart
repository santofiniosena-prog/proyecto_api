import 'package:flutter/material.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';


class UserProvider extends ChangeNotifier {

final UserRepository repository;

UserProvider(this.repository);


List<UserEntity> users = [];

bool isLoading = false;


Future<void> loadUsers() async {

isLoading = true;

notifyListeners();

try {

users = await repository.getUsers();

} catch (e) {

debugPrint(e.toString());

}

isLoading = false;

notifyListeners();

}


Future<void> addUser(String name, String email, int age) async {

await repository.createUser(UserEntity(name: name, email: email, age: age));

await loadUsers();

}


Future<void> updateExistingUser(String id, String name, String email, int age) async {

await repository.updateUser(UserEntity(id: id, name: name, email: email, age: age));

await loadUsers();

}


Future<void> deleteUser(String id) async {

await repository.deleteUser(id);

await loadUsers();

}

}