// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:proyecto_api/main.dart';
import 'package:proyecto_api/domain/entities/user_entity.dart';
import 'package:proyecto_api/domain/repositories/user_repository.dart';
import 'package:proyecto_api/presentation/providers/user_provider.dart';

class FakeUserRepository implements UserRepository {
  @override
  Future<List<UserEntity>> getUsers() async => [];

  @override
  Future<void> createUser(UserEntity user) async {}

  @override
  Future<void> updateUser(UserEntity user) async {}

  @override
  Future<void> deleteUser(String id) async {}
}

void main() {
  testWidgets('Muestra la pantalla de usuarios', (WidgetTester tester) async {
    await tester.pumpWidget(
      MyApp(provider: UserProvider(FakeUserRepository())),
    );
    await tester.pump();

    expect(find.text('Usuarios'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
