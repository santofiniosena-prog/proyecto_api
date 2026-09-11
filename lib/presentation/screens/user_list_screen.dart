import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/presentation/providers/user_provider.dart';

import '../../domain/entities/user_entity.dart';


class UserListScreen extends StatelessWidget {

const UserListScreen({super.key});


@override

Widget build(BuildContext context) {

final userProvider = context.watch<UserProvider>();

return Scaffold(

appBar: AppBar(title: const Text("CRUD Usuarios")),

body: userProvider.isLoading

? const Center(child: CircularProgressIndicator())

: ListView.builder(

itemCount: userProvider.users.length,

itemBuilder: (context, i) {

final user = userProvider.users[i];

return ListTile(

title: Text(user.name),

subtitle: Text(user.email),

trailing: Row(

mainAxisSize: MainAxisSize.min,

children: [

IconButton(

icon: const Icon(Icons.edit, color: Colors.blue),

onPressed: () => _showUserDialog(context, user: user),

),

IconButton(

icon: const Icon(Icons.delete, color: Colors.red),

onPressed: () => userProvider.deleteUser(user.id!),

),

],

),

);

},

),

floatingActionButton: FloatingActionButton(

onPressed: () => _showUserDialog(context),

child: const Icon(Icons.add),

),

);

}


void _showUserDialog(BuildContext context, {UserEntity? user}) {

final isEditing = user != null;

final nameCtrl = TextEditingController(text: isEditing ? user.name : "");

final emailCtrl = TextEditingController(text: isEditing ? user.email : "");

final ageCtrl =

TextEditingController(text: isEditing ? user.age.toString() : "");


showDialog(

context: context,

builder: (context) => AlertDialog(

title: Text(isEditing ? "Editar Usuario" : "Nuevo Usuario"),

content: SingleChildScrollView(

// <--- PASO 1: Envolver aquí

child: Column(

mainAxisSize: MainAxisSize

.min, // Esto hace que el diálogo no ocupe toda la pantalla

children: [

TextField(

controller: nameCtrl,

decoration: const InputDecoration(labelText: "Nombre")),

const SizedBox(

height: 8), // Un pequeño espacio extra no viene mal

TextField(

controller: emailCtrl,

decoration: const InputDecoration(labelText: "Email")),

const SizedBox(height: 8),

TextField(

controller: ageCtrl,

decoration: const InputDecoration(labelText: "Edad"),

keyboardType: TextInputType.number),

],

),

),

actions: [

TextButton(

onPressed: () => Navigator.pop(context),

child: const Text("Cancelar")),

ElevatedButton(

onPressed: () {

final prov = context.read<UserProvider>();

if (isEditing) {

prov.updateExistingUser(user.id!, nameCtrl.text,

emailCtrl.text, int.parse(ageCtrl.text));

} else {

prov.addUser(

nameCtrl.text, emailCtrl.text, int.parse(ageCtrl.text));

}

Navigator.pop(context);

},

child: const Text("Aceptar")),

],

),

);

}

}