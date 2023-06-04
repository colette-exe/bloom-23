/*
  Created by: Claizel Coubeili Cepe
  Date: 27 October 2022
  Description: Sample todo app with networking

  Modified by: Angelica Nicolette U. Adoptante
  Section: D1L
  Date modified: December 5, 2022
  Program Description: bloom - Shared Todo App (CMSC 23 Project)
  File description: Handles todo functions and operations the 
          currently logged in user can perform.
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
  TextEditingController deadlineController = TextEditingController();
  TextEditingController timeController = TextEditingController();
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
      case 'Toggle-status':
        return const Text("Todo Status",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.black87));
      case 'View':
        return const Text("View Todo",
            style: TextStyle(
                fontSize: 16,
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
          timeController.text =
              "${DateTime.now().hour}:${DateTime.now().minute + 5}";
          deadlineController.text =
              "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}";
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
                  color: Colors.black87),
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
                  color: Colors.black87),
            ),
            // deadline
            TextFormField(
              controller: deadlineController,
              key: const Key('deadline'),
              decoration: const InputDecoration(
                labelText: "Deadline",
                labelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Poppins',
                    color: Colors.black54),
              ),
              onTap: (() async {
                DateTime? date = await showDatePicker(
                    fieldHintText: "Enter deadline",
                    context: context,
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2050));

                if (date == null || date == "") {
                  deadlineController.text =
                      "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}";
                } else {
                  deadlineController.text =
                      "${date.month}/${date.day}/${date.year}";
                }
              }),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
            ),
            // time
            TextFormField(
              controller: timeController,
              key: const Key('time'),
              decoration: const InputDecoration(
                labelText: "Time",
                labelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Poppins',
                    color: Colors.black54),
              ),
              onTap: (() async {
                TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                        hour: DateTime.now().hour,
                        minute: DateTime.now().minute));

                if (time == null || time == "") {
                  timeController.text =
                      "${DateTime.now().hour}:${DateTime.now().minute + 5}"; // due in 5 minutes
                } else {
                  timeController.text = "${time.hour}:${time.minute}";
                }
              }),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
            )
          ]);
        }
      case 'Edit-owner':
        {
          // get title and descriptions from todo data
          Todo todo = context.read<TodoListProvider>().selected;
          titleController.text = todo.title;
          descController.text = todo.description;
          statController.text = todo.status;
          deadlineController.text = todo.deadline;
          timeController.text = todo.time;

          return Column(
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
                const SizedBox(height: 7),
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
                const SizedBox(height: 7),
                // status
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
                // deadline
                const SizedBox(height: 7),
                TextFormField(
                  controller: deadlineController,
                  key: const Key('deadline'),
                  decoration: const InputDecoration(
                    labelText: "Deadline",
                    labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Poppins',
                        color: Colors.black54),
                  ),
                  onTap: (() async {
                    DateTime? date = await showDatePicker(
                        fieldHintText: "Enter deadline",
                        context: context,
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2050));

                    if (date == null) {
                      deadlineController.text =
                          "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}";
                    } else {
                      deadlineController.text =
                          "${date.month}/${date.day}/${date.year}";
                    }
                  }),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  ),
                ),
                // time
                TextFormField(
                  controller: timeController,
                  key: const Key('time'),
                  decoration: const InputDecoration(
                    labelText: "Time",
                    labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Poppins',
                        color: Colors.black54),
                  ),
                  onTap: (() async {
                    TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                            hour: DateTime.now().hour,
                            minute: DateTime.now().minute));

                    if (time == null || time == "") {
                      timeController.text =
                          "${DateTime.now().hour}:${DateTime.now().minute + 5}"; // due in 5 minutes
                    } else {
                      timeController.text = "${time.hour}:${time.minute}";
                    }
                  }),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  ),
                )
              ]);
        }
      case "Edit-friend":
        {
          // get title and descriptions from todo data
          Todo todo = context.read<TodoListProvider>().selected;
          titleController.text = todo.title;
          descController.text = todo.description;
          deadlineController.text = todo.deadline;
          timeController.text = todo.time;

          return Column(
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
                const SizedBox(height: 7),
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
                const SizedBox(height: 7),
                // deadline
                TextFormField(
                  controller: deadlineController,
                  key: const Key('deadline'),
                  decoration: const InputDecoration(
                    labelText: "Deadline",
                    labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Poppins',
                        color: Colors.black54),
                  ),
                  onTap: (() async {
                    DateTime? date = await showDatePicker(
                        fieldHintText: "Enter deadline",
                        context: context,
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2050));

                    if (date == null) {
                      deadlineController.text =
                          "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}";
                    } else {
                      deadlineController.text =
                          "${date.month}/${date.day}/${date.year}";
                    }
                  }),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  ),
                ),
                // time
                TextFormField(
                  controller: timeController,
                  key: const Key('time'),
                  decoration: const InputDecoration(
                    labelText: "Time",
                    labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Poppins',
                        color: Colors.black54),
                  ),
                  onTap: (() async {
                    TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                            hour: DateTime.now().hour,
                            minute: DateTime.now().minute));

                    if (time == null || time == "") {
                      timeController.text =
                          "${DateTime.now().hour}:${DateTime.now().minute + 5}"; // due in 5 minutes
                    } else {
                      timeController.text = "${time.hour}:${time.minute}";
                    }
                  }),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  ),
                )
              ]);
        }
      case 'View':
        {
          Todo todo = context.read<TodoListProvider>().selected;
          TextEditingController description = TextEditingController();
          description.text = todo.description;

          return Column(mainAxisSize: MainAxisSize.min, children: [
            // title
            Text(
              todo.title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black87),
            ),
            const SizedBox(
              height: 10,
            ),

            const SizedBox(
              height: 10,
            ),
            Text(
              todo.history?[0],
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Poppins',
                  color: Colors.black54),
            ),
            const SizedBox(
              height: 15,
            ), // description
            DecoratedBox(
                decoration: const BoxDecoration(),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  readOnly: true,
                  controller: description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Poppins',
                      color: Colors.black87),
                )),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  todo.deadline,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Poppins',
                      color: Colors.black87),
                ),
                Text(
                  todo.time,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Poppins',
                      color: Colors.black87),
                ),
                Text(
                  todo.status,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Poppins',
                      color: Colors.black87),
                ),
              ],
            )
          ]);
        }
      default:
        String status = "";
        if (context.read<TodoListProvider>().selected.status == 'completed') {
          status = 'ongoing';
        } else {
          status = 'completed';
        }
        // print(status);
        return Text(
          "Mark '${context.read<TodoListProvider>().selected.title}' as $status?",
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              fontFamily: 'Poppins',
              color: Colors.black87),
        );
    }
  }

  TextButton _dialogAction(BuildContext context) {
    String buttonText = type;
    if (type == 'Edit-owner' || type == 'Edit-friend') {
      buttonText = 'Edit';
    }
    if (type == 'Toggle-status') {
      buttonText = 'Yes';
    }
    if (type == 'View') {
      buttonText = 'Done';
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
                    ownerFriends: [],
                    deadline: deadlineController.text,
                    time: timeController.text);

                context.read<TodoListProvider>().addTodo(temp);

                // Remove dialog after adding
                Navigator.of(context).pop();
                break;
              }
            case 'Edit-owner': // can edit status
              {
                context.read<TodoListProvider>().editTodo(
                    uid,
                    statController.text,
                    titleController.text,
                    descController.text,
                    deadlineController.text,
                    timeController.text);

                // Remove dialog after editing
                Navigator.of(context).pop();
                break;
              }
            case 'Edit-friend': // can only edit the title and description
              {
                context.read<TodoListProvider>().editTodo(
                    uid,
                    null,
                    titleController.text,
                    descController.text,
                    deadlineController.text,
                    timeController.text);

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
            case 'Toggle-status':
              {
                context.read<TodoListProvider>().toggleStatus();
                Navigator.of(context).pop();
                break;
              }
            case 'View':
              {
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
    if (type != 'View') {
      return AlertDialog(
        scrollable: true,
        title: _buildTitle(),
        content: _buildContent(context),

        // Contains two buttons - add/edit, and cancel
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
    } else {
      return AlertDialog(
        scrollable: true,
        title: _buildTitle(),
        content: _buildContent(context),

        // Contains one button - Done
        actions: <Widget>[
          _dialogAction(context),
        ],
      );
    }
  }
}
