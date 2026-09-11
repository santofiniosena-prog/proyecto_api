import 'package:flutter/material.dart';

import 'data/repositories/user_repository_imp.dart';

import 'presentation/screens/user_list_screen.dart';

import 'presentation/providers/user_provider.dart';

import 'package:provider/provider.dart';


void main() {

runApp(MultiProvider(

providers: [

ChangeNotifierProvider(

create: (_) => UserProvider(UserRepositoryImpl())..loadUsers(),

),

],

child: const MaterialApp(home:UserListScreen()),

));

}