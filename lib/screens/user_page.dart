/*
    Author: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: November 13, 2022 (from Exercise 6)
    Program Description: bloom - Shared Todo App (CMSC 23 Project)
    File Description: Displays users
 */
import 'package:bloom/screens/modal_user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:bloom/providers/user_provider.dart';
import 'package:bloom/models/user_model.dart';
// screen import

class UserPage extends StatefulWidget {
  String regex;
  UserPage({
    super.key,
    required this.regex,
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
        return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: ((context, index) {
              // iterate through users
              User user = User.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>);
              // show all users except the current user
              if (user.userName != "user1") {
                // temporary basis for checking
                RegExp regex = RegExp(widget.regex, caseSensitive: false);
                // only return matched displayNames
                if (regex.hasMatch(user.displayName)) {
                  return Dismissible(
                      key: Key(user.userId.toString()),
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
                        title: Text(user.displayName,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Poppins',
                                color: Colors.black87)),
                        trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              iconButtonBuilder(context, 'user1', user)
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
      }),
    );
  }
}
