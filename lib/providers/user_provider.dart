/*
    Author: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: November 13, 2022 (from Exercise 6)
    Program Description: bloom - Shared Todo App (CMSC 23 Project)
    File Description: User-related operations
 */
import 'package:bloom/api/firebase_auth_api.dart';
import 'package:bloom/providers/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bloom/api/firebase_user_api.dart';
import 'package:bloom/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserListProvider with ChangeNotifier {
  late FireBaseUserAPI firebaseService;
  late FirebaseAuthAPI firebaseAuthService;
  late Stream<QuerySnapshot> _userStream;
  User? _selectedUser;

  UserListProvider() {
    firebaseService = FireBaseUserAPI();
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

  getUsersByIds(List ids) {
    return firebaseService.getAllUsersByIds(ids);
  }

  // get users from the database
  void fetchUsers() {
    _userStream = firebaseService.getAllUsers();
    notifyListeners();
  }

  // parameter: userName
  // returns a DocumentReference to the entry with userName as its userName
  getUserByUserName(String userName) {
    return firebaseService.getUserByUserName(userName);
  }

  // parameter: userId
  // returns a DocumentReference to the entry with userName as its userId
  List getUserByUserId(String userId) {
    DocumentReference userRef = firebaseService.getUserByUserId(userId);
    userRef.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map<String, dynamic>;
        User user = User.fromJson(data);
        return [user.displayName, user.userName];
      }
    });
    return [];
  }

  checkStatus(String userId, String otherId) {
    // get userId's friends, receivedFriendRequests, and sentFriendRequests lists
    DocumentReference userRef = firebaseService.getUserByUserName(userId);
    userRef.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        // .data() returns a Map<String, dynamic>
        // look for otherId
        // in friends
        List friends = documentSnapshot.get(FieldPath(const ['friends']));
        for (var friend in friends) {
          if (friend == otherId) {
            // found in friends list
            // options: Unfriend
            return "Unfriend";
          }
        }
        // in received requests
        List requests =
            documentSnapshot.get(FieldPath(const ['receivedFriendRequests']));
        for (var user in requests) {
          if (user == otherId) {
            // found in received requests list
            // options: Accept, Reject
            return "Accept Friend Request, Reject Friend Request";
          }
        }
        // in sent requests
        List sent =
            documentSnapshot.get(FieldPath(const ['sentFriendRequests']));
        for (var s in sent) {
          if (s == otherId) {
            // found in sent requests list
            // options: Cancel Request
            return "Cancel Request";
          }
        }
        // else : complete strangers
        return "Strangers";
      } else {
        return "";
      }
    });
  }

  // adding a user to the database
  // called when signing up
  void addUser(User user) async {
    String message = await firebaseService.addUser(user.toJson(user));
    print(message);
    notifyListeners();
  }

  // user actions ------------------------->>>>>>>>>>>>---
  void addFriend(String id) async {
    String message = await firebaseService.addFriend(id, _selectedUser!.userId);
    print(message);
    notifyListeners();
  }

  void unfriend(String id) async {
    String message = await firebaseService.unfriend(id, _selectedUser!.userId);
    print(message);
    notifyListeners();
  }

  void acceptRequest(String id) async {
    String message =
        await firebaseService.acceptRequest(id, _selectedUser!.userId);
    print(message);
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
}
