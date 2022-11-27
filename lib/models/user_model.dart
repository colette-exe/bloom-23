/*
    Author: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: November 12, 2022 (from Exercise 6)
    Program Description: bloom - Shared Todo App (CMSC 23 Project)
    File Description: User Model
 */
import 'dart:convert';

class User {
  // user attributes
  String userId;
  String userName;
  String displayName;

  // lists of int userIds
  List<dynamic> friends;
  List<dynamic> receivedFriendRequests;
  List<dynamic> sentFriendRequests;

  // constructor
  User({
    required this.userId,
    required this.userName,
    required this.displayName,
    required this.friends,
    required this.receivedFriendRequests,
    required this.sentFriendRequests,
  });

  // instantiate object from json
  // for fetching user info from the database
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      userName: json['userName'],
      displayName: json['displayName'],
      friends: json['friends'],
      receivedFriendRequests: json['receivedFriendRequests'],
      sentFriendRequests: json['sentFriendRequests'],
    );
  }

  // from object to json
  Map<String, dynamic> toJson(User user) {
    return {
      'userId': user.userId,
      'userName': user.userName,
      'displayName': user.displayName,
      'friends': user.friends,
      'receivedFriendRequests': user.receivedFriendRequests,
      'sentFriendRequests': user.sentFriendRequests,
    };
  }

  // returns a list of users
  static List<User> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<User>((dynamic d) => User.fromJson(d)).toList();
  }
}
