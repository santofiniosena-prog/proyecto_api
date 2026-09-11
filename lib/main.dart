import 'package:flutter/material.dart';

import 'data/repositories/user_repository_imp.dart';
import 'presentation/providers/user_provider.dart';
import 'presentation/screens/user_list_screen.dart';

void main() {
  final repository = UserRepositoryImpl();

  final provider = UserProvider(repository);

  runApp(
    MyApp(provider: provider),
  );
}

class MyApp extends StatelessWidget {
  final UserProvider provider;

  const MyApp({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Proyecto API',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: UserListScreen(
        provider: provider,
      ),
    );
  }
}