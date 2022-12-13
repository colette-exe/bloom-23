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
        backgroundColor: const Color(0xff7dac66),
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
                crossAxisCount: 2),
            padding: const EdgeInsets.all(10),
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, int index) {
              Todo todo = Todo.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>);

              // check if currently logged in user is the owner of the todo or a friend of the owner
              bool owner = (todo.ownerId == uid);
              bool friend =
                  todo.ownerFriends!.any((element) => element.contains(uid));
              Widget button;
              if (todo.status == 'ongoing') {
                // mark complete
                button = const Icon(Icons.check_box_rounded);
              } else {
                // mark ongoing
                button = const Icon(Icons.indeterminate_check_box_rounded);
              }
              if (owner) {
                return Dismissible(
                    key: Key("${todo.id}"),
                    onDismissed: (direction) {
                      context.read<TodoListProvider>().changeSelectedTodo(todo);
                      context.read<TodoListProvider>().deleteTodo();

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${todo.title} deleted')));
                    },
                    background: Container(
                      color: const Color(0xffd4cf69),
                      child: const Icon(Icons.delete),
                    ),
                    child: Card(
                        color: const Color(0xff96bfac),
                        margin: const EdgeInsets.all(5),
                        child: GridTile(
                          header: GridTileBar(
                            title: Text(todo.title,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                    color: Color(0xff676d16))),
                            subtitle: Text(todo.history![0],
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'Poppins',
                                    color: Colors.black54)),
                          ),
                          footer: GridTileBar(
                              leading: Row(
                            children: [
                              IconButton(
                                  color:
                                      const Color.fromARGB(255, 233, 227, 102),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          context
                                              .read<TodoListProvider>()
                                              .changeSelectedTodo(todo);
                                          return TodoModal(
                                              type: 'View',
                                              uid: uid,
                                              status: todo.status);
                                        });
                                  },
                                  icon: const Icon(
                                      Icons.remove_red_eye_outlined)),
                              IconButton(
                                  color:
                                      const Color.fromARGB(255, 233, 227, 102),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        context
                                            .read<TodoListProvider>()
                                            .changeSelectedTodo(todo);
                                        return TodoModal(
                                          type: 'Toggle-status',
                                          uid: uid,
                                        );
                                      },
                                    );
                                  },
                                  icon: button),
                              IconButton(
                                  color:
                                      const Color.fromARGB(255, 233, 227, 102),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        context
                                            .read<TodoListProvider>()
                                            .changeSelectedTodo(todo);
                                        return TodoModal(
                                            type: 'Edit-owner', uid: uid);
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.edit)),
                            ],
                          )),
                          child: Container(
                              padding: const EdgeInsets.only(
                                  top: 65, bottom: 60, left: 20, right: 20),
                              height: 100,
                              child: SizedBox(
                                  height: 80,
                                  child: ListView(
                                    children: [
                                      for (var word in [todo.description])
                                        Text(word,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                                fontFamily: 'Poppins',
                                                color: Colors.black87))
                                    ],
                                  ))),
                        )));
              } else if (friend) {
                return Card(
                    color: const Color(0xffe7b6a0),
                    margin: const EdgeInsets.all(5),
                    child: GridTile(
                      header: GridTileBar(
                          title: Text(todo.title,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                  color: Color(0xff676d16))),
                          subtitle: Text(todo.history![0],
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Poppins',
                                  color: Colors.black54))),
                      footer: GridTileBar(
                          leading: Row(
                        children: [
                          IconButton(
                              color: const Color(0xff676d16),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      context
                                          .read<TodoListProvider>()
                                          .changeSelectedTodo(todo);
                                      return TodoModal(
                                        type: 'View',
                                        uid: uid,
                                      );
                                    });
                              },
                              icon: const Icon(Icons.remove_red_eye_outlined)),
                          IconButton(
                              color: const Color(0xff676d16),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    context
                                        .read<TodoListProvider>()
                                        .changeSelectedTodo(todo);
                                    return TodoModal(
                                        type: 'Toggle-status',
                                        uid: uid,
                                        status: todo.status);
                                  },
                                );
                              },
                              icon: button),
                          IconButton(
                              color: const Color(0xff676d16),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    context
                                        .read<TodoListProvider>()
                                        .changeSelectedTodo(todo);
                                    return TodoModal(
                                        type: 'Edit-friend', uid: uid);
                                  },
                                );
                              },
                              icon: const Icon(Icons.edit)),
                        ],
                      )),
                      child: Container(
                          padding: const EdgeInsets.only(
                              top: 65, bottom: 60, left: 20, right: 20),
                          height: 100,
                          child: SizedBox(
                              height: 80,
                              child: ListView(
                                children: [
                                  for (var word in [todo.description])
                                    Text(word,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                            fontFamily: 'Poppins',
                                            color: Colors.black87))
                                ],
                              ))),
                    ));
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff7dac66),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => TodoModal(type: 'Add', uid: uid),
          );
        },
        child: const Icon(Icons.add_box_rounded,
            color: Color.fromARGB(255, 233, 201, 187)),
      ),
    );
  }
}
