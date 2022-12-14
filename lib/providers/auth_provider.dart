/*
    Code from: CMSC 23 Authentication and Testing Discussion Code
    Modified by: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: November 27, 2022
    Program Description: bloom - Shared Todo App (CMSC 23 Project)
    File Description: Firebase Authentication Provider
 */

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bloom/api/firebase_auth_api.dart';

// One change notifier
// late instantiation of auth service
// create user object from firebase_auth
class AuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  User? userObj; // keeping track of the user

  AuthProvider() {
    authService = FirebaseAuthAPI(); // connect to firebaseauthapi
    authService.getUser().listen((User? newUser) {
      // get user
      userObj = newUser;
      if (newUser != null) {
        print(
            'AuthProvider - FirebaseAuth - onAuthStateChanged - ${newUser.email}');
      }
      notifyListeners();
    }, onError: (e) {
      // provide a more useful error
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $e');
    });
  }

  User? get user => userObj;

  bool get isAuthenticated {
    return user != null;
  }

  void signIn(String email, String password) async {
    String message = await authService.signIn(email, password);
    print(message);
  }

  String getCurrentUser() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return userId;
  }

  void signOut() async {
    String message = await authService.signOut();
    print(message);
  }

  signUp(String firstName, String lastName, String email, String password,
      String bday, String location, String username) {
    return authService.signUp(
        firstName, lastName, email, password, bday, location, username);
  }
}
