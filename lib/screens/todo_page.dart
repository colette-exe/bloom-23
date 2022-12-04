/*
    Author: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: December 1, 2022
    Program Description: bloom - Shared Todo App (CMSC 23 Project)
    File description: Todo Page
 */
import 'package:flutter/material.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      // body: StreamBuilder(
      //   builder: ,
      // ),
    );
  }
}
