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

  TodoModal({super.key, required this.type, required this.uid});

  // Method to show the title of the modal depending on the functionality
  Text _buildTitle() {
    switch (type) {
      case 'Add':
        return const Text("Add new todo");
      case 'Edit':
        return const Text("Edit todo");
      case 'Delete':
        return const Text("Delete todo");
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
          );
        }
      // add
      default:
        return Column(mainAxisSize: MainAxisSize.min, children: [
          // title
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              // hintText: todoIndex != -1 ? todoItems[todoIndex].title : '',
              hintText: "Enter title",
            ),
          ),
          // description
          TextField(
            controller: descController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              // hintText: todoIndex != -1 ? todoItems[todoIndex].title : '',
              hintText: "Enter description",
            ),
          ),
          // status
          TextField(
            controller: statController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              // hintText: todoIndex != -1 ? todoItems[todoIndex].title : '',
              hintText: "Enter status",
            ),
          ),
        ]);
    }
  }

  TextButton _dialogAction(BuildContext context) {
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
                  status: statController.text,
                  history: "created",
                  ownerId: uid);

              context.read<TodoListProvider>().addTodo(temp);

              // Remove dialog after adding
              Navigator.of(context).pop();
              break;
            }
          // case 'Edit':
          //   {
          //     context
          //         .read<TodoListProvider>()
          //         .editTodo(todoIndex, _formFieldController.text);

          //     // Remove dialog after editing
          //     Navigator.of(context).pop();
          //     break;
          //   }
          case 'Delete':
            {
              context.read<TodoListProvider>().deleteTodo();

              // Remove dialog after editing
              Navigator.of(context).pop();
              break;
            }
        }
      },
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: Text(type),
    );
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
          child: Text("Cancel"),
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}
