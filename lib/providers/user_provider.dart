/*
    Author: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: November 13, 2022 (from Exercise 6)
    Program Description: bloom - Shared Todo App (CMSC 23 Project)
    File Description: User-related operations
 */
import 'package:bloom/api/firebase_auth_api.dart';
import 'package:bloom/api/firebase_todo_api.dart';
import 'package:bloom/providers/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bloom/api/firebase_user_api.dart';
import 'package:bloom/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserListProvider with ChangeNotifier {
  late FireBaseUserAPI firebaseService;
  late FirebaseAuthAPI firebaseAuthService;
  late FirebaseTodoAPI firebaseTodoAPI;
  late Stream<QuerySnapshot> _userStream;
  User? _selectedUser;

  UserListProvider() {
    firebaseService = FireBaseUserAPI();
    firebaseTodoAPI = FirebaseTodoAPI();
    fetchUsers();
  }

  // get users
  Stream<QuerySnapshot> get users => _userStream;
  User get selected => _selectedUser!;

  // changing selected user
  // probably not needed in thsi context
  // will maybe delete later if there's no use
  changeSelectedUser(User user) {
    _selectedUser = user;
  }

  // get users from the database
  void fetchUsers() {
    _userStream = firebaseService.getAllUsers();
    notifyListeners();
  }

  // parameter: userName
  // returns a DocumentReference to the entry with userName as its userName
  getUserById(String id) {
    return firebaseService.getUserByUserId(id);
  }

  // user actions ------------------------->>>>>>>>>>>>---
  void addFriend(String id) async {
    String message = await firebaseService.addFriend(id, _selectedUser!.userId);
    print(message);
    notifyListeners();
  }

  void unfriend(String id) async {
    String message1 = await firebaseService.unfriend(id, _selectedUser!.userId);
    // update todos
    String message2 =
        await firebaseTodoAPI.unfriendUpdate(id, _selectedUser!.userId);
    String message3 =
        await firebaseTodoAPI.unfriendUpdate(_selectedUser!.userId, id);
    print(message1);
    print(message2);
    print(message3);
    notifyListeners();
  }

  void acceptRequest(String id) async {
    String message1 =
        await firebaseService.acceptRequest(id, _selectedUser!.userId);
    // update todos
    String message2 =
        await firebaseTodoAPI.acceptUpdate(id, _selectedUser!.userId);
    String message3 =
        await firebaseTodoAPI.acceptUpdate(_selectedUser!.userId, id);
    print(message1);
    print(message2);
    print(message3);
    notifyListeners();
  }

  void rejectRequest(String id) async {
    String message =
        await firebaseService.rejectFriend(id, _selectedUser!.userId);
    print(message);
    notifyListeners();
  }

  void cancelRequest(String id) async {
    String message =
        await firebaseService.cancelRequest(id, _selectedUser!.userId);
    print(message);
    notifyListeners();
  }

  void changeBio(String id, String bio) async {
    String message = await firebaseService.updateBio(id, bio);
    print(message);
    notifyListeners();
  }
}
