import 'package:flutter/material.dart';

import '../../domain/entities/user_entity.dart';
import '../providers/user_provider.dart';

class UserListScreen extends StatefulWidget {
  final UserProvider provider;

  const UserListScreen({
    super.key,
    required this.provider,
  });

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    widget.provider.loadUsers();
  }

  Future<void> createUser() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final age = int.tryParse(ageController.text.trim());

    if (name.isEmpty || email.isEmpty || age == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa todos los campos correctamente'),
        ),
      );

      return;
    }

    try {
      await widget.provider.addUser(
        name,
        email,
        age,
      );

      nameController.clear();
      emailController.clear();
      ageController.clear();

      if (mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuario creado correctamente'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear usuario: $e'),
          ),
        );
      }
    }
  }

  Future<void> editUser(UserEntity user) async {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final ageController = TextEditingController(text: user.age.toString());

    final formKey = GlobalKey<FormState>();

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Editar usuario'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Ingresa el nombre'
                          : null,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Correo'),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Ingresa el correo'
                          : null,
                ),
                TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Edad'),
                  validator: (value) =>
                      int.tryParse(value?.trim() ?? '') == null
                          ? 'Ingresa una edad válida'
                          : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(dialogContext, true);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (shouldSave != true || user.id == null) {
      nameController.dispose();
      emailController.dispose();
      ageController.dispose();
      return;
    }

    try {
      await widget.provider.updateExistingUser(
        user.id!,
        nameController.text.trim(),
        emailController.text.trim(),
        int.parse(ageController.text.trim()),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario actualizado correctamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar usuario: $e')),
        );
      }
    } finally {
      nameController.dispose();
      emailController.dispose();
      ageController.dispose();
    }
  }

  Future<void> deleteUser(UserEntity user) async {
    if (user.id == null) return;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar usuario'),
          content: Text('¿Deseas eliminar a ${user.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    try {
      await widget.provider.deleteUser(user.id!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario eliminado correctamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar usuario: $e')),
        );
      }
    }
  }

  void showCreateUserForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Agregar usuario',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Edad',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: createUser,
                  child: const Text('Guardar usuario'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    ageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
      ),

      body: AnimatedBuilder(
        animation: widget.provider,
        builder: (context, child) {
          if (widget.provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (widget.provider.users.isEmpty) {
            return const Center(
              child: Text(
                'No hay usuarios',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: widget.provider.users.length,
            itemBuilder: (context, index) {
              final UserEntity user = widget.provider.users[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(user.name),
                  subtitle: Text(
                    '${user.email}\nEdad: ${user.age}',
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Editar usuario',
                        onPressed: () => editUser(user),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        tooltip: 'Eliminar usuario',
                        onPressed: () => deleteUser(user),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: showCreateUserForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}