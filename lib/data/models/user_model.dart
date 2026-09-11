import '/domain/entities/user_entity.dart';


class UserModel extends UserEntity {

UserModel({super.id, required super.name, required super.email, required super.age});


factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(

id: json['_id'] ?? json['id'], // Depende de cómo lo mande tu API de Node

name: json['name'],

email: json['email'],

age: json['age'],

);


Map<String, dynamic> toJson() => {

"name": name,

"email": email,

"age": age,

};

}