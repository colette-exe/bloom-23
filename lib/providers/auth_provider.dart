/*
  From Exercise 7 Authentication and Testing Discussion Code
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
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $newUser');
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

  void signIn(String email, String password) {
    authService.signIn(email, password);
  }

  String getCurrentUser() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return userId;
  }

  void signOut() {
    authService.signOut();
  }

  void signUp(String firstName, String lastName, String email, String password,
      String bday, String location, String username) {
    authService.signUp(
        firstName, lastName, email, password, bday, location, username);
  }
}
