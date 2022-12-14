/*
    Code from: CMSC 23 Authentication and Testing Discussion Code
    Modified by: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: November 27, 2022
    Program Description: bloom - Shared Todo App (CMSC 23 Project)
    File Description: Firebase Authentication API
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// imports for widget testing
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';

class FirebaseAuthAPI {
  // real database
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  //---- used for testing------------------------
  // final db = FakeFirebaseFirestore();

  // final auth = MockFirebaseAuth(
  //     mockUser: MockUser(
  //   isAnonymous: false,
  //   uid: 'mockuid',
  //   email: 'realuser@usersassociation.com',
  //   displayName: 'Mackenzee',
  // ));
  // ----------------------------------------------

  Stream<User?> getUser() {
    return auth.authStateChanges();
  }

  signIn(String email, String password) async {
    UserCredential credential;
    try {
      credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Successfully logged in!";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return e;
    }
  }

  signUp(String firstName, String lastName, String email, String password,
      String bday, String location, String username) async {
    UserCredential credential;
    try {
      credential = await auth.createUserWithEmailAndPassword(
        // firestore_auth
        email: email,
        password: password,
      );
      if (credential.user != null) {
        saveUserToFirestore(credential.user?.uid, email, firstName, lastName,
            bday, location, username); // save user to database
        try {
          // add email to emails collection
          await db.collection("emails").add({'email': email});
          return "Successfully signed up!";
        } on FirebaseException catch (e) {
          return "Failed with error '${e.code}: ${e.message}";
        }
      }
      return "Successfully signed up!";
    } on FirebaseAuthException catch (e) {
      //possible to return something more useful
      //than just print an error message to improve UI/UX
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return e;
    } catch (e) {
      return e;
    }
  }

  signOut() async {
    auth.signOut();
    return "Successfully signed out!";
  }

  // called in sign up
  saveUserToFirestore(String? uid, String email, String firstName,
      String lastName, String bday, String location, String username) async {
    try {
      await db.collection("users").doc(uid).set({
        "userId": uid,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "bday": bday,
        "location": location,
        "userName": username,
        "bio": "",
        "friends": [],
        "receivedFriendRequests": [],
        "sentFriendRequests": []
      });
      return true;
    } on FirebaseException catch (e) {
      print(e.message);
      return false;
    }
  }
}
