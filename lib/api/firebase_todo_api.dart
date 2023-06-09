/*
    Code from: CMSC 23 Authentication and Testing Discussion Code
    Modified by: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: November 27, 2022
    Program Description: bloom - Shared Todo App (CMSC 23 Project)
    File Description: Firebase Todo API
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
// import for testing
// import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

class FirebaseTodoAPI {
  // commented out for testing
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  //---- used for testing------------------------
  // final db = FakeFirebaseFirestore();
  // ----------------------------------------------

  Future<String> addTodo(Map<String, dynamic> todo) async {
    try {
      final docRef = await db.collection("todos").add(todo);
      await db.collection("todos").doc(docRef.id).update({'id': docRef.id});
      // update ownerFriends
      docRef.get().then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          String ownerId = documentSnapshot.get(FieldPath(const ['ownerId']));
          try {
            final userRef = db.collection("users").doc(ownerId);
            userRef.get().then((value) async {
              if (value.exists) {
                List ownerFriends = value.get(FieldPath(const ['friends']));
                String name = value.get(FieldPath(const ['userName']));
                var now = DateTime.now();
                var date =
                    "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}";
                await docRef.update({
                  'ownerFriends': ownerFriends,
                  'history': ['created by $name - $date']
                });

                return "Successfully added todo!";
              } else {
                return "Todo owner not found.";
              }
            });
          } on FirebaseException catch (e) {
            return "Failed with error '${e.code}: ${e.message}";
          }
        } else {
          return "Todo not found.";
        }
      });
      return "Successfully added todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllTodos() {
    return db.collection("todos").snapshots();
  }

  Future<String> editTodo(String editedBy, String? id, String? status,
      String title, String description, String deadline, String time) async {
    try {
      final docRef = db.collection("todos").doc(id);
      if (status != null) {
        // format date
        var now = DateTime.now();
        var date =
            "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}";
        docRef.get().then((docValue) async {
          if (docValue.exists) {
            List history = docValue.get(FieldPath(const ['history']));
            String ownerId = docValue.get(FieldPath(const ['ownerId']));
            final userRef = db.collection("users").doc(ownerId);
            userRef.get().then((value) async {
              String name = value.get(FieldPath(const ['userName']));
              history.insert(0, 'edited by $name - $date');
              await db.collection("todos").doc(docRef.id).update({
                'status': status,
                'title': title,
                'description': description,
                'history': history,
                'deadline': deadline,
                'time': time
              });
            });
          }
        });
        return "Owner successfully edited todo!";
      } else {
        // friend editing
        var now = DateTime.now();
        var date =
            "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}";
        docRef.get().then((value) async {
          if (value.exists) {
            final userRef = db.collection("users").doc(editedBy);
            userRef.get().then((user) async {
              List history = value.get(FieldPath(const ['history']));
              String name = user.get(FieldPath(const ['userName']));
              history.insert(0, 'edited by $name - $date');
              await db.collection("todos").doc(docRef.id).update({
                'title': title,
                'description': description,
                'history': history,
                'deadline': deadline,
                'time': time
              });
            });
          }
        });
        return "A friend successfully edited todo!";
      }
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> deleteTodo(String? id) async {
    try {
      await db.collection("todos").doc(id).delete();

      return "Successfully deleted todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  // update all of userId's todos' ownerFriends list
  // remove otherId
  Future<String> unfriendUpdate(String? userId, String? otherId) async {
    WriteBatch batch = db.batch();
    try {
      final userRef = db.collection("users").doc(userId);
      List friends = [];
      userRef.get().then((user) async {
        if (user.exists) {
          friends = user.get(FieldPath(const ['friends']));
          friends.remove(otherId);
        }
        try {
          db
              .collection("todos")
              .where("ownerId", isEqualTo: userId)
              .get()
              .then((todo) async {
            todo.docs.forEach((element) {
              try {
                // element.data().update("ownerFriends", (value) => friends);
                batch.update(element.reference, {"ownerFriends": friends});
              } on FirebaseException catch (e) {
                print("Failed with error '${e.code}: ${e.message}");
                return;
              }
            });
            return batch.commit();
          });
          return "Successfully updated todo!";
        } on FirebaseException catch (e) {
          return "Failed with error '${e.code}: ${e.message}";
        }
      });
      return "Successfully updated todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  // update all of userId's todos' ownerFriends list
  // make sure otherId is included to the list
  Future<String> acceptUpdate(String? userId, String? otherId) async {
    WriteBatch batch = db.batch();
    try {
      final userRef = db.collection("users").doc(userId);
      List friends = [];
      userRef.get().then((user) async {
        if (user.exists) {
          friends = user.get(FieldPath(const ['friends']));
          if (!friends.any((element) => element.contains(otherId))) {
            friends.add(otherId);
          }
        }
        try {
          db
              .collection("todos")
              .where("ownerId", isEqualTo: userId)
              .get()
              .then((todo) async {
            todo.docs.forEach((element) {
              try {
                // element.data().update("ownerFriends", (value) => friends);
                batch.update(element.reference, {"ownerFriends": friends});
              } on FirebaseException catch (e) {
                print("Failed with error '${e.code}: ${e.message}");
                return;
              }
            });
            return batch.commit();
          });
          return "Successfully updated todo!";
        } on FirebaseException catch (e) {
          return "Failed with error '${e.code}: ${e.message}";
        }
      });
      return "Successfully updated todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> completeTodo(String? id) async {
    try {
      final todoRef = db.collection("todos").doc(id);
      todoRef.get().then((value) async {
        if (value.exists) {
          String status = value.get(FieldPath(const ['status']));
          if (status == 'ongoing') {
            status = 'completed';
          } else {
            status = 'ongoing';
          }
          await db.collection("todos").doc(id).update({'status': status});
          return "Changed status to $status!";
        } else {
          return "Todo not found.";
        }
      });
      return "Successfully changed todo status!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
