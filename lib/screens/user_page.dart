/*
    Author: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: November 13, 2022 (from Exercise 6)
    Program Description: bloom - Shared Todo App (CMSC 23 Project)
    File Description: Displays users
 */
import 'package:bloom/models/screen_arguments.dart';
import 'package:bloom/screens/modal_user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:bloom/providers/user_provider.dart';
import 'package:bloom/models/user_model.dart';
import 'package:bloom/providers/auth_provider.dart';
// screen import

class UserPage extends StatefulWidget {
  String regex;
  String uid;
  String type;
  UserPage({
    super.key,
    required this.regex,
    required this.uid,
    required this.type,
  });

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  // returns IconButtons depending on the relationship between user and otherUser
  Widget iconButtonBuilder(
      BuildContext context, String userId, User otherUser) {
    List otherFriends = otherUser.friends;
    List otherRequests = otherUser.receivedFriendRequests;
    List otherSent = otherUser.sentFriendRequests;
    // user is in other user's friends list
    for (var element in otherFriends) {
      if (element == userId) {
        // unfriend
        return IconButton(
            onPressed: (() {
              context.read<UserListProvider>().changeSelectedUser(otherUser);
              // call function in modal_user
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      UserModal(userId: userId, action: 'Unfriend'));
            }),
            icon: const Icon(Icons.person_remove));
      }
    }
    // user sent other user a friend request
    for (var element in otherRequests) {
      if (element == userId) {
        // cancel friend request
        return IconButton(
            onPressed: (() {
              context.read<UserListProvider>().changeSelectedUser(otherUser);
              showDialog(
                  context: context,
                  builder: (BuildContext context) => UserModal(
                      userId: userId, action: 'Cancel Friend Request'));
            }),
            icon: const Icon(Icons.cancel_schedule_send_sharp));
      }
    }
    // user received a friend request from other user
    for (var element in otherSent) {
      if (element == userId) {
        return Row(children: [
          // accept friend request
          IconButton(
              onPressed: (() {
                context.read<UserListProvider>().changeSelectedUser(otherUser);
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        UserModal(userId: userId, action: 'Accept Request'));
              }),
              icon: const Icon(Icons.check_circle_outline)),
          // reject friend request
          IconButton(
              onPressed: (() {
                context.read<UserListProvider>().changeSelectedUser(otherUser);
                showDialog(
                    context: context,
                    builder: (BuildContext context) => UserModal(
                        userId: userId, action: 'Reject Friend Request'));
              }),
              icon: const Icon(Icons.cancel_outlined))
        ]);
      }
    }

    // else, strangers, user can add them as a friend
    return IconButton(
        onPressed: (() {
          context.read<UserListProvider>().changeSelectedUser(otherUser);
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  UserModal(userId: userId, action: 'Add Friend'));
        }),
        icon: const Icon(Icons.person_add));
  }

  @override
  Widget build(BuildContext context) {
    // get list of users
    // String uid = context.watch<AuthProvider>().userObj!.uid;
    Stream<QuerySnapshot> usersStream = context.watch<UserListProvider>().users;
    return StreamBuilder(
      stream: usersStream,
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error encountered! ${snapshot.error}"),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData) {
          return const Center(
            child: Text("No Users Yet!",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.black87)),
          );
        }
        if (widget.type == 'search') {
          // for search page
          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: ((context, index) {
                // iterate through users
                User user = User.fromJson(
                    snapshot.data?.docs[index].data() as Map<String, dynamic>);
                // show all users except the current user
                if (user.userId != widget.uid) {
                  // temporary basis for checking
                  RegExp regex = RegExp(widget.regex, caseSensitive: false);
                  // only return matched displayNames
                  if (regex.hasMatch(user.firstName) ||
                      regex.hasMatch(user.lastName)) {
                    return Dismissible(
                        key: Key(user.userId),
                        onDismissed: (direction) {
                          // context
                          //     .read<UserListProvider>()
                          //     .changeSelectedUser(user);
                        },
                        background: Container(
                          color: Colors.amber,
                          child: const Icon(Icons.delete),
                        ),
                        child: ListTile(
                          title: Text("${user.firstName} ${user.lastName}",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Poppins',
                                  color: Colors.black87)),
                          trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                iconButtonBuilder(context, widget.uid, user)
                              ]),
                        ));
                  } else {
                    return const SizedBox.shrink();
                  }
                } else {
                  return const SizedBox
                      .shrink(); // learned from https://stackoverflow.com/questions/53455358/how-to-present-an-empty-view-in-flutter
                }
              }));
        } else {
          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: ((context, index) {
                // iterate through users
                User user = User.fromJson(
                    snapshot.data?.docs[index].data() as Map<String, dynamic>);
                // see if current user is in this user's friends list
                bool element;
                // if for friends page, look for the id in the friends list
                if (widget.type == 'friends') {
                  element = user.friends.any((e) => e.contains(widget.uid));
                } else {
                  // else look in the sentFriendRequests list, since we are looking through each user's sfr list
                  // if the currently logged in user is in this list, then they receieved a friend request from this user
                  element = user.sentFriendRequests
                      .any((e) => e.contains(widget.uid));
                }
                if (element) {
                  return Dismissible(
                      key: Key(user.userId),
                      onDismissed: (direction) {},
                      background: Container(
                        color: Colors.amber,
                        child: const Icon(Icons.delete),
                      ),
                      child: ListTile(
                        title: Text("${user.firstName} ${user.lastName}",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Poppins',
                                color: Colors.black87)),
                        trailing:
                            Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/view-profile',
                                    arguments:
                                        ScreenArguments(user.userId, user));
                              },
                              icon: const Icon(Icons
                                  .remove_red_eye_outlined)), // view profile
                          iconButtonBuilder(
                              context, widget.uid, user) // user action
                        ]),
                      ));
                } else {
                  return const SizedBox.shrink();
                }
              }));
        }
      }),
    );
  }
}
