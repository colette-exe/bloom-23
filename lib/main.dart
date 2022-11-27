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
import 'package:bloom/providers/user_provider.dart';
import 'package:bloom/screens/profile.dart';
import 'package:bloom/screens/search.dart';

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
      title: 'Exercise 6',
      initialRoute: '/',
      routes: {'/': (context) => Profile(), '/search': (context) => Search()},
    );
  }
}
