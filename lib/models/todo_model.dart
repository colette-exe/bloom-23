/*
    Author: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: December 4, 2022
    Program Description: bloom - Shared Todo App (CMSC 23 Project)
    File Description: Todo Model
 */

import 'dart:convert';

class Todo {
  String? id;
  String title;
  String description;
  String status; // ongoing, paused, completed
  List? history;
  String deadline;

  String ownerId;
  List? ownerFriends;

  Todo(
      {this.id,
      required this.title,
      required this.description,
      required this.status,
      this.history,
      required this.deadline,
      required this.ownerId,
      this.ownerFriends});

  // fetch todo info from database
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        status: json['status'],
        history: json['history'],
        deadline: json['deadline'],
        ownerId: json['ownerId'],
        ownerFriends: json['ownerFriends']);
  }
  // from object to json
  Map<String, dynamic> toJson(Todo todo) {
    return {
      'id': todo.id,
      'title': todo.title,
      'description': todo.description,
      'status': todo.status,
      'history': todo.history,
      'deadline': todo.deadline,
      'ownerId': todo.ownerId,
      'ownerFriends': todo.ownerFriends
    };
  }

  // returns a list of todos
  static List<Todo> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Todo>((dynamic d) => Todo.fromJson(d)).toList();
  }
}
