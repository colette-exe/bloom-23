/*
  Created by: Claizel Coubeili Cepe
  Date: 27 October 2022
  Description: Sample todo app with networking

  Modified by: Angelica Nicolette U. Adoptante
  Section: D1L
  Date modified: December 5, 2022
*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bloom/models/todo_model.dart';
import 'package:bloom/providers/todo_provider.dart';

class TodoModal extends StatelessWidget {
  String type;
  String uid;
  // int todoIndex;
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController statController = TextEditingController();
  bool? ongoing = false;
  bool? paused = false;
  bool? completed = false;

  TodoModal({super.key, required this.type, required this.uid});

  // Method to show the title of the modal depending on the functionality
  Text _buildTitle() {
    switch (type) {
      case 'Add':
        return const Text("Add new todo",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.black87));
      case 'Edit-owner':
        return const Text("Edit todo",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.black87));
      case 'Edit-friend':
        return const Text("Edit todo",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.black87));
      case 'Delete':
        return const Text("Delete todo",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.black87));
      default:
        return const Text("");
    }
  }

  // Method to build the content or body depending on the functionality
  Widget _buildContent(BuildContext context) {
    // Use context.read to get the last updated list of todos
    // List<Todo> todoItems = context.read<TodoListProvider>().todo;

    switch (type) {
      case 'Delete':
        {
          return Text(
            "Are you sure you want to delete '${context.read<TodoListProvider>().selected.title}'?",
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                fontFamily: 'Poppins',
                color: Colors.black87),
          );
        }
      // add
      case 'Add':
        {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            // title
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter title",
              ),
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Poppins',
                  color: Colors.black54),
            ),
            // description
            TextField(
              maxLines: 5,
              controller: descController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter description",
              ),
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Poppins',
                  color: Colors.black54),
            ),
          ]);
        }
      case 'Edit-owner':
        {
          // get title and descriptions from todo data
          Todo todo = context.read<TodoListProvider>().selected;
          titleController.text = todo.title;
          descController.text = todo.description;
          statController.text = todo.status;

          return SizedBox(
              height: 300,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // title
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Title"),
                      ),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Colors.black87),
                    ),
                    // description
                    TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        controller: descController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Description"),
                        ),
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Poppins',
                            color: Colors.black87)),
                    TextField(
                      controller: statController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Status"),
                      ),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Poppins',
                          color: Colors.black87),
                    ),
                  ]));
        }
      default:
        {
          // get title and descriptions from todo data
          Todo todo = context.read<TodoListProvider>().selected;
          titleController.text = todo.title;
          descController.text = todo.description;

          return SizedBox(
              height: 300,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // title
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Title"),
                      ),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Colors.black87),
                    ),
                    // description
                    TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      controller: descController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Description"),
                      ),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Poppins',
                          color: Colors.black87),
                    ),
                  ]));
        }
    }
  }

  TextButton _dialogAction(BuildContext context) {
    String buttonText = type;
    if (type == 'Edit-owner' || type == 'Edit-friend') {
      buttonText = 'Edit';
    }
    // List<Todo> todoItems = context.read<TodoListProvider>().todo;
    return TextButton(
        onPressed: () {
          switch (type) {
            case 'Add':
              {
                // Instantiate a todo objeect to be inserted, default userID will be 1, the id will be the next id in the list
                Todo temp = Todo(
                    title: titleController.text,
                    description: descController.text,
                    status: "ongoing",
                    ownerId: uid,
                    history: [],
                    ownerFriends: []);

                context.read<TodoListProvider>().addTodo(temp);

                // Remove dialog after adding
                Navigator.of(context).pop();
                break;
              }
            case 'Edit-owner': // can edit status
              {
                context.read<TodoListProvider>().editTodo(statController.text,
                    titleController.text, descController.text);

                // Remove dialog after editing
                Navigator.of(context).pop();
                break;
              }
            case 'Edit-friend': // can only edit the title and description
              {
                context
                    .read<TodoListProvider>()
                    .editTodo(null, titleController.text, descController.text);

                // Remove dialog after editing
                Navigator.of(context).pop();
                break;
              }
            case 'Delete':
              {
                context.read<TodoListProvider>().deleteTodo();
                Navigator.of(context).pop();
                break;
              }
          }
        },
        style: TextButton.styleFrom(
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.black87),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(context),

      // Contains two buttons - add/edit/delete, and cancel
      actions: <Widget>[
        _dialogAction(context),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text(
            "Cancel",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
