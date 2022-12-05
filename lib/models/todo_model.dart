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
  String history;

  String ownerId;

  Todo(
      {this.id,
      required this.title,
      required this.description,
      required this.status,
      required this.history,
      required this.ownerId});

  // fetch todo info from database
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        status: json['status'],
        history: json['history'],
        ownerId: json['ownerId']);
  }
  // from object to json
  Map<String, dynamic> toJson(Todo todo) {
    return {
      'id': todo.id,
      'title': todo.title,
      'description': todo.description,
      'status': todo.status,
      'history': todo.history,
      'ownerId': todo.ownerId
    };
  }

  // returns a list of todos
  static List<Todo> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Todo>((dynamic d) => Todo.fromJson(d)).toList();
  }
}
