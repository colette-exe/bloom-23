/*
    Author: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: November 26, 2022
    Shared Todo App Project: bloom
    Program Description: 
        A shared todo app where you can see your friends' todos. 
        Bloom together as all of you complete your tasks 
        step-by-step, little-by-little :>
    File Description: main
 */
import 'package:bloom/providers/todo_provider.dart';
import 'package:bloom/providers/user_provider.dart';
import 'package:bloom/screens/friends_page.dart';
import 'package:bloom/screens/login.dart';
import 'package:bloom/screens/profile.dart';
import 'package:bloom/screens/requests.dart';
import 'package:bloom/screens/search.dart';
import 'package:bloom/providers/auth_provider.dart';
import 'package:bloom/screens/signup.dart';
import 'package:bloom/screens/todo_page.dart';
import 'package:bloom/screens/view_profile.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => UserListProvider())),
        ChangeNotifierProvider(create: ((context) => AuthProvider())),
        ChangeNotifierProvider(create: ((context) => TodoListProvider())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bloom',
      initialRoute: '/',
      routes: {
        '/login': (context) => const Login(),
        '/sign-up': (context) => const SignUpPage(),
        '/': (context) => AuthWrapper(),
        '/search': (context) => Search(),
        '/todos': (context) => const TodoPage(),
        '/friends': (context) => const FriendsPage(),
        '/requests': (context) => const RequestsPage(),
        '/view-profile': ((context) => ViewProfile()),
      },
      // color: Colors.green.shade600,
      theme: ThemeData(primarySwatch: Colors.green),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.watch<AuthProvider>().isAuthenticated) {
      return const Profile();
    } else {
      return const Login();
    }
  }
}
