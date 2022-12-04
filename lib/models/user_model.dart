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
  String firstName;
  String lastName;
  String bday;
  String location;
  String bio;

  // lists of string userIds
  List<dynamic> friends;
  List<dynamic> receivedFriendRequests;
  List<dynamic> sentFriendRequests;

  // constructor
  User({
    required this.userId,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.bday,
    required this.location,
    required this.bio,
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
      firstName: json['firstName'],
      lastName: json['lastName'],
      bday: json['bday'],
      location: json['location'],
      bio: json['bio'],
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
      'firstName': user.firstName,
      'lastName': user.lastName,
      'bday': user.bday,
      'location': user.location,
      'bio': user.bio,
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
