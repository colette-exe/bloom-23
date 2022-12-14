/*
  Created by: Claizel Coubeili Cepe
  Date: 27 October 2022
  Description: Sample todo app with networking

  Modified by: Angelica Nicolette U. Adoptante
  Section: D1L
  Date modified: November 20, 2022
  Exercise number: 07
*/
import 'package:flutter/material.dart';
import 'package:bloom/api/firebase_todo_api.dart';
import 'package:bloom/models/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoListProvider with ChangeNotifier {
  late FirebaseTodoAPI firebaseService;
  late Stream<QuerySnapshot> _todosStream;
  Todo? _selectedTodo;

  TodoListProvider() {
    firebaseService = FirebaseTodoAPI();
    fetchTodos();
  }

  // getter
  Stream<QuerySnapshot> get todos => _todosStream;
  Todo get selected => _selectedTodo!;

  changeSelectedTodo(Todo item) {
    _selectedTodo = item;
  }

  void fetchTodos() {
    _todosStream = firebaseService.getAllTodos();
    notifyListeners();
  }

  void addTodo(Todo item) async {
    String message = await firebaseService.addTodo(item.toJson(item));
    print(message);
    notifyListeners();
  }

  void editTodo(String userId, String? newStatus, String newTitle,
      String newDesc, String newDeadline, String newTime) async {
    String message = await firebaseService.editTodo(
        userId,
        "${_selectedTodo!.id}",
        newStatus,
        newTitle,
        newDesc,
        newDeadline,
        newTime);
    print(message);
    notifyListeners();
  }

  void deleteTodo() async {
    String message = await firebaseService.deleteTodo("${_selectedTodo!.id}");
    print(message);
    notifyListeners();
  }

  void toggleStatus() async {
    String message = await firebaseService.completeTodo("${_selectedTodo!.id}");
    print(message);
    notifyListeners();
  }
}
