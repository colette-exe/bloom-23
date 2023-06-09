/*
    Author: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: November 12, 2022 (from Exercise 6)
    Program Description: bloom - Shared Todo App (CMSC 23 Project)
    File Description: Used to access database
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

class FireBaseUserAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static const String RECEIVED = "receivedFriendRequests";
  static const String SENT = "sentFriendRequests";
  static const String FRIENDS = "friends";
  static const String BIO = "bio";

  //---- used for testing------------------------
  // final db = FakeFirebaseFirestore();
  // ----------------------------------------------

  // getting users
  // returns snapshots / documents
  Stream<QuerySnapshot> getAllUsers() {
    return db.collection("users").snapshots();
  }

  DocumentReference<Map<String, dynamic>> checkEmail(String email) {
    return db.collection("emails").doc(email);
  }

  getEmails() async {
    QuerySnapshot querySnapshot = await db.collection("emails").get();

    final data = querySnapshot.docs.map((e) => e.id).toList();
    return data;
  }

  // get a user based on their userId
  DocumentReference<Map<String, dynamic>> getUserByUserId(String userId) {
    return db.collection("users").doc(userId);
  }

  // Add Friend (user to otherUser)
  // put userId to otherId's received list
  Future<String> addFriend(String? userId, String? otherId) async {
    try {
      DocumentReference otherUser = db.collection("users").doc(otherId);
      List otherReceived = [];
      otherUser.get().then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
// ----- perform operations only when the documentSnapshot has been checked to be existing -------
          // update otherUser's receivedFriendRequests list
          otherReceived = documentSnapshot.get(FieldPath(const [RECEIVED]));
          otherReceived.add(userId);
          await otherUser.update({RECEIVED: otherReceived});
          try {
            DocumentReference user = db.collection("users").doc(userId);
            List userSent = [];
            user.get().then((DocumentSnapshot documentSnapshot) async {
              if (documentSnapshot.exists) {
                // update user's sentFriendRequests list
                userSent = documentSnapshot.get(FieldPath(const [SENT]));
                userSent.add(otherId);
                await user.update({SENT: userSent});
                return "Successfully sent a friend request!";
              } else {
                return "[2] An error occurred :/";
              }
            });
            // return "Successfully sent a friend request!";
          } on FirebaseException catch (e) {
            return "Failed with error '${e.code}: ${e.message}";
          }
        } else {
          return "[1] An error occurred :/";
        }
      });
      return "Successfully sent a friend request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  // remove otherUser from user's friends list
  // remove user from otherUser's friends list
  Future<String> unfriend(String? userId, String? otherId) async {
    try {
      DocumentReference otherUser = db.collection("users").doc(otherId);
      List otherFriends = [];
      otherUser.get().then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
// ----- perform operations only when the documentSnapshot has been checked to be existing -------
          // update otherUser's friends list
          otherFriends = documentSnapshot.get(FieldPath(const [FRIENDS]));
          otherFriends.remove(userId);
          await otherUser.update({FRIENDS: otherFriends});
          try {
            DocumentReference user = db.collection("users").doc(userId);
            List userFriends = [];
            user.get().then((DocumentSnapshot documentSnapshot) async {
              if (documentSnapshot.exists) {
                // update user's friends lisr
                userFriends = documentSnapshot.get(FieldPath(const [FRIENDS]));
                userFriends.remove(otherId);
                await user.update({FRIENDS: userFriends});
                return "Successfully unfriended!";
              } else {
                return "[2] An error occurred :/";
              }
            });
            // return "Successfully unfriended!";
          } on FirebaseException catch (e) {
            return "Failed with error '${e.code}: ${e.message}";
          }
        } else {
          return "[1] An error occurred :/";
        }
      });
      return "Successfully unfriended!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  // Accept Friend Request
  // add otherUser to user's friends list; remove otherUser from user's received list
  // add user to otherUser's friends list; remove user from otherUser's sent list
  Future<String> acceptRequest(String? userId, String? otherId) async {
    try {
      DocumentReference otherUser = db.collection("users").doc(otherId);
      // add to friends list -------------
      List otherFriends = [];
      otherUser.get().then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
// ----- perform operations only when the documentSnapshot has been checked to be existing -------
          // update otherUser's friends list
          otherFriends = documentSnapshot.get(FieldPath(const [FRIENDS]));
          otherFriends.add(userId);
          await otherUser.update({FRIENDS: otherFriends});
          try {
            DocumentReference user = db.collection("users").doc(userId);
            List userFriends = [];
            user.get().then((DocumentSnapshot documentSnapshot) async {
              if (documentSnapshot.exists) {
                // update user's friends list
                userFriends = documentSnapshot.get(FieldPath(const [FRIENDS]));
                userFriends.add(otherId);
                await user.update({FRIENDS: userFriends});
                try {
                  List userReceived = [];
                  user.get().then((DocumentSnapshot documentSnapshot) async {
                    if (documentSnapshot.exists) {
                      // update user's receivedFriendRequests list
                      userReceived =
                          documentSnapshot.get(FieldPath(const [RECEIVED]));
                      userReceived.remove(otherId);
                      await user.update({RECEIVED: userReceived});
                      try {
                        // remove from received and sent ------------
                        List otherSent = [];
                        otherUser
                            .get()
                            .then((DocumentSnapshot documentSnapshot) async {
                          if (documentSnapshot.exists) {
                            // update otherUser's sentFriendRequests list
                            otherSent =
                                documentSnapshot.get(FieldPath(const [SENT]));
                            otherSent.remove(userId);
                            await otherUser.update({SENT: otherSent});
                            return "Successfully accepted friend request!";
                          } else {
                            return "[4] An error occurred :/";
                          }
                        });
                        // return "Successfully accepted friend request!";
                      } on FirebaseException catch (e) {
                        return "Failed with error '${e.code}: ${e.message}";
                      }
                    } else {
                      return "[3] An error occurred :/";
                    }
                  });
                  return "Successfully accepted friend request!";
                } on FirebaseException catch (e) {
                  return "Failed with error '${e.code}: ${e.message}";
                }
              } else {
                return "[2] An error occurred :/";
              }
            });
            return "Successfully accepted friend request!";
          } on FirebaseException catch (e) {
            return "Failed with error '${e.code}: ${e.message}";
          }
        } else {
          return "[1] An error occurred :/";
        }
      });
      return "Successfully accepted friend request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  // reject friend request
  // remove otherUser from user's received list
  // remove user from otherUser's sent list
  Future<String> rejectFriend(String? userId, String? otherId) async {
    try {
      DocumentReference otherUser = db.collection("users").doc(otherId);
      List otherSent = [];
      otherUser.get().then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
// ----- perform operations only when the documentSnapshot has been checked to be existing -------
          // update otherUser's sentFriendRequests list
          otherSent = documentSnapshot.get(FieldPath(const [SENT]));
          otherSent.remove(userId);
          await otherUser.update({SENT: otherSent});
          try {
            DocumentReference user = db.collection("users").doc(userId);
            List userReceived = [];
            user.get().then((DocumentSnapshot documentSnapshot) async {
              if (documentSnapshot.exists) {
                // update user's receivedFriendRequests list
                userReceived =
                    documentSnapshot.get(FieldPath(const [RECEIVED]));
                userReceived.remove(otherId);
                await user.update({RECEIVED: userReceived});
                return "Successfully rejected friend request!";
              } else {
                return "[3] An error occurred :/";
              }
            });
          } on FirebaseException catch (e) {
            return "Failed with error '${e.code}: ${e.message}";
          }
        } else {
          return "[4] An error occurred :/";
        }
      });
      return "Successfully rejected friend request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  // cancel friend request
  // remove otherUser from user's sent list
  // remove user from otherUser's received list
  Future<String> cancelRequest(String? userId, String? otherId) async {
    try {
      DocumentReference otherUser = db.collection("users").doc(otherId);
      List otherReceived = [];
      otherUser.get().then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
// ----- perform operations only when the documentSnapshot has been checked to be existing -------
          // update otherUser's receivedFriendRequests list
          otherReceived = documentSnapshot.get(FieldPath(const [RECEIVED]));
          otherReceived.remove(userId);
          await otherUser.update({RECEIVED: otherReceived});
          try {
            DocumentReference user = db.collection("users").doc(userId);
            List userSent = [];
            user.get().then((DocumentSnapshot documentSnapshot) async {
              if (documentSnapshot.exists) {
                // update user's sentFriendRequests list
                userSent = documentSnapshot.get(FieldPath(const [SENT]));
                userSent.remove(otherId);
                await user.update({SENT: userSent});
                return "Successfully cancelled friend request!";
              } else {
                return "[3] An error occurred :/";
              }
            });
          } on FirebaseException catch (e) {
            return "Failed with error '${e.code}: ${e.message}";
          }
          // return "Successfully cancelled friend request!";
        } else {
          return "[4] An error occurred :/";
        }
      });
      return "Successfully cancelled friend request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  // udate bio
  Future<String> updateBio(String? id, String? bio) async {
    try {
      DocumentReference user = db.collection("users").doc(id);
      user.get().then(((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          await user.update({BIO: bio});
        } else {
          return "User document doesn't exist!";
        }
      }));
      return "Successfully updated bio!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
