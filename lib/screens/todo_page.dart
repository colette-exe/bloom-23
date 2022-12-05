/*
    Author: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: December 1, 2022
    Program Description: bloom - Shared Todo App (CMSC 23 Project)
    File description: Todo Page
 */
import 'package:bloom/providers/todo_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bloom/models/todo_model.dart';

import '../models/screen_arguments.dart';
import 'modal_todo.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    String uid = args.uid;
    Stream<QuerySnapshot> todoStream = context.watch<TodoListProvider>().todos;
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
      body: StreamBuilder(
        stream: todoStream,
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("No Todos Yet!",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Colors.black87)),
            );
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (BuildContext context, int index) {
              Todo todo = Todo.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>);
              return Dismissible(
                  key: Key("${todo.id}"),
                  onDismissed: (direction) {},
                  background: Container(
                    color: Colors.amber,
                    child: const Icon(Icons.delete),
                  ),
                  child: Card(
                      margin: const EdgeInsets.all(5),
                      child: GridTile(
                        header: GridTileBar(
                            leading: Text(todo.title,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'Poppins',
                                    color: Colors.black87))),
                        footer: GridTileBar(
                          leading: Text("STATUS: ${todo.status}",
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w200,
                                  fontFamily: 'Poppins',
                                  color: Colors.black87)),
                          trailing: Row(children: const [Text("Buttons")]),
                        ),
                        child: Center(
                            child: Text(todo.description,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'Poppins',
                                    color: Colors.black87))),
                      )));
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => TodoModal(type: 'Add', uid: uid),
          );
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
