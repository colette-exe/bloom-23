/*
    Author: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: December 14, 2022
    Program Description: bloom - Shared Todo App (CMSC 23 Project)
    File Description: Unit Testing
 */
import 'package:bloom/api/firebase_todo_api.dart';
import 'package:bloom/api/firebase_user_api.dart';
import 'package:bloom/models/todo_model.dart';
import 'package:bloom/models/user_model.dart';
import 'package:bloom/providers/auth_provider.dart';
import 'package:bloom/providers/todo_provider.dart';
import 'package:bloom/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloom/main.dart';

// functions
import 'package:bloom/api/firebase_auth_api.dart';

void main() {
  final authApi = FirebaseAuthAPI(); // AUTH API
  final userApi = FireBaseUserAPI();
  final todoApi = FirebaseTodoAPI();

  final authProv = AuthProvider();
  final userProv = UserListProvider();
  final todoProv = TodoListProvider();

  String firstName = "Angelica";
  String lastName = "Adoptante";
  String email = "angelica@gmail.com";
  String password = "123Abc!@";
  String bday = "05/30/2002";
  String location = "Batangas";
  String username = "angelica";

  User user = User(
      email: email,
      userId: "1",
      userName: username,
      firstName: firstName,
      lastName: lastName,
      bday: bday,
      location: location,
      bio: "",
      friends: [],
      receivedFriendRequests: [],
      sentFriendRequests: []);

  User otherUser = User(
      email: "otheruser@gmail.com",
      userId: "2",
      userName: "otherUser",
      firstName: "Other",
      lastName: "User",
      bday: "01/01/2001",
      location: "Otherverse",
      bio: "",
      friends: [],
      receivedFriendRequests: [],
      sentFriendRequests: []);

  Todo todo1 = Todo(
      id: '1',
      title: "todo1",
      description: "first todo",
      status: "ongoing",
      deadline: "12/15/2022",
      time: "09:30",
      ownerId: user.userId,
      history: ['created by ${user.userName} - 12/14/2022 10:55'],
      ownerFriends: [otherUser.userId]);

  Todo todo2 = Todo(
      id: '2',
      title: "todo2",
      description: "second todo",
      status: "ongoing",
      deadline: "12/15/2022",
      time: "09:30",
      ownerId: user.userId,
      history: ['created by ${user.userName} - 12/14/2022 11:00'],
      ownerFriends: [otherUser.userId]);

  var userMap = user.toJson(user);
  var todo1Map = todo1.toJson(todo1);
  var todo2Map = todo2.toJson(todo2);
  group("Sign Up Functions Test", () {
    test("Sign Up Function", () async {
      String status = await authApi.signUp(
          firstName, lastName, email, password, bday, location, username);
      expect(status, "Successfully signed up!");
    });

    test("saveUserToFirestore Test", () async {
      bool result = await authApi.saveUserToFirestore(
          "1", email, firstName, lastName, bday, location, username);
      expect(result, true);
    });
  });

  group("Log In, Log Out Functions Test", () {
    test("signIn Test", () async {
      String message = await authApi.signIn(email, password);
      expect(message, "Successfully logged in!");
    });

    test("signOut Test", () async {
      String message = await authApi.signOut();
      expect(message, "Successfully signed out!");
    });
  });

  group("User Actions Test", () {
    // getUserByUserId()
    test("getUserByUserId() Test", () {
      expect(userApi.getUserByUserId(user.userId),
          const TypeMatcher<DocumentReference>());
    });
    // add friend
    test("addFriend() Test", () async {
      expect(await userApi.addFriend(user.userId, otherUser.userId),
          "Successfully sent a friend request!");
    });
    // unfriend
    test("unfriend() test", () async {
      expect(await userApi.unfriend(user.userId, otherUser.userId),
          "Successfully unfriended!");
    });
    // acceptRequest
    test("acceptRequest() test", () async {
      expect(await userApi.acceptRequest(user.userId, otherUser.userId),
          "Successfully accepted friend request!");
    });
    // rejectFriend (request)
    test("rejectFriend() test", () async {
      expect(await userApi.rejectFriend(user.userId, otherUser.userId),
          "Successfully rejected friend request!");
    });
    // cancelRequest
    test("cancelRequest() test", () async {
      expect(await userApi.cancelRequest(user.userId, otherUser.userId),
          "Successfully cancelled friend request!");
    });
    // updateBio
    test("updateBio() test", () async {
      expect(await userApi.updateBio(user.userId, "hello"),
          "Successfully updated bio!");
    });
  });

  group("Todo Functions Test", () {
    test("addTodo() test", () async {
      expect(await todoApi.addTodo(todo1Map), "Successfully added todo!");
    });
    test("getAllTodods() test", () {
      expect(todoApi.getAllTodos(),
          const TypeMatcher<Stream<QuerySnapshot<Map<String, dynamic>>>>());
    });
    test("editTodo() test", () async {
      String status = "completed";
      // owner edits
      expect(
          await todoApi.editTodo(todo1.ownerId, todo1.id, status, todo1.title,
              todo1.description, todo1.deadline, todo1.time),
          "Owner successfully edited todo!");
      // a friend edits
      expect(
          await todoApi.editTodo(otherUser.userId, todo1.id, null, todo1.title,
              todo1.description, todo1.deadline, todo1.time),
          "A friend successfully edited todo!");
    });
    test("deleteTodo() test", () async {
      expect(await todoApi.deleteTodo(todo1.id), "Successfully deleted todo!");
    });

    test("unfriendUpdate() test", () async {
      expect(await todoApi.unfriendUpdate(todo1.ownerId, otherUser.userId),
          "Successfully updated todo!");
    });

    test("acceptUpdate() test", () async {
      expect(await todoApi.acceptUpdate(todo1.ownerId, otherUser.userId),
          "Successfully updated todo!");
    });

    test("completeTodo() test", () async {
      expect(await todoApi.completeTodo(todo1.id),
          "Successfully changed todo status!");
      // await todoApi.completeTodo(todo1.id);
      // expect(todo1.status, "completed");
    });
  });
}
