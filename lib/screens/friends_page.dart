/*
    Author: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: December 4, 2022
    Program Description: bloom - Shared Todo App (CMSC 23 Project)
    File Description: Views the currently logged in user's friends list
 */
import 'package:bloom/models/screen_arguments.dart';
import 'package:flutter/material.dart';
import 'user_page.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    String uid = args.uid;
    return Scaffold(
      key: const Key('friendsPage'),
      appBar: AppBar(
        title: const Text('Friends',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.white)),
        backgroundColor: const Color(0xff7dac66),
      ),
      body: Container(
          padding: const EdgeInsets.all(30),
          height: MediaQuery.of(context).size.height,
          child: SizedBox(
              height: MediaQuery.of(context).size.height - 500,
              child: UserPage(regex: "", uid: uid, type: "friends"))),
    );
  }
}
