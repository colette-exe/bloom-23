import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// imports for widget testing
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

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

  void signIn(String email, String password) async {
    UserCredential credential;
    try {
      credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  void signUp(String firstName, String lastName, String email, String password,
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
      }
    } on FirebaseAuthException catch (e) {
      //possible to return something more useful
      //than just print an error message to improve UI/UX
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void signOut() async {
    auth.signOut();
  }

  // called in sign up
  void saveUserToFirestore(String? uid, String email, String firstName,
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
        "friends": [],
        "receivedFriendRequests": [],
        "sentFriendRequests": []
      });
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }
}
