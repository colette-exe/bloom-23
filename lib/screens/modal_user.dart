/*
    Author: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: November 13, 2022 (from Exercise 6)
    Program Description: bloom - Shared Todo App (CMSC 23 Project)
    File Description: Used to provide the appropriate values to display in user_page,
              as well as the actions the user can perform
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bloom/providers/user_provider.dart';

class UserModal extends StatelessWidget {
  // view profile
  String action;
  String userId;
  UserModal({super.key, required this.action, required this.userId});

  // setting alertdialog title
  Text _buildTitle() {
    switch (action) {
      case 'Add Friend':
        {
          return const Text("Send Friend Request",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black87));
        }
      case 'Accept Request':
        {
          return const Text("Accept Friend Request",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black87));
        }
      case 'Reject Friend Request':
        {
          return const Text("Reject Friend Request",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black87));
        }
      case 'Cancel Friend Request':
        {
          return const Text("Cancel Friend Request",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black87));
        }
      case 'Unfriend':
        {
          return const Text("Unfriend",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black87));
        }
      default:
        return const Text("");
    }
  }

  // setting alertdialog content
  Widget _buildContent(BuildContext context) {
    switch (action) {
      case 'Add Friend':
        {
          return const Text("Are you sure you want to add them as a friend?",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black87));
        }
      case 'Accept Request':
        {
          return const Text(
              "Are you sure you want to accept the friend request?",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black87));
        }
      case 'Reject Friend Request':
        {
          return const Text(
              "Are you sure you want to reject the friend request?",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black87));
        }
      case 'Cancel Friend Request':
        {
          return const Text(
              "Are you sure you want to cancel the friend request?",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black87));
        }
      case 'Unfriend':
        {
          return const Text("Are you sure you want to unfriend them?",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black87));
        }
      default:
        return const Text("");
    }
  }

  // setting alertdialog text button action
  TextButton _dialogAction(BuildContext context) {
    return TextButton(
      onPressed: () {
        switch (action) {
          case 'Add Friend':
            {
              print("Add friend");
              context.read<UserListProvider>().addFriend(
                    userId,
                  );
              Navigator.of(context).pop();
              break;
            }
          case 'Accept Request':
            {
              print("Accept Request");
              context.read<UserListProvider>().acceptRequest(userId);
              Navigator.of(context).pop();
              break;
            }
          case 'Reject Friend Request':
            {
              print("Reject Friend Request");
              context.read<UserListProvider>().rejectRequest(userId);
              Navigator.of(context).pop();
              break;
            }
          case 'Cancel Friend Request':
            {
              print("Cancel Friend Request");
              context.read<UserListProvider>().cancelRequest(userId);
              Navigator.of(context).pop();
              break;
            }
          case 'Unfriend':
            {
              print("Unfriend");
              context.read<UserListProvider>().unfriend(userId);
              Navigator.of(context).pop();
              break;
            }
        }
      },
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: Text(action),
    );
  }

  // the alertdialog widget
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: _buildTitle(),
        content: _buildContent(context),
        actions: <Widget>[
          _dialogAction(context),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text("Cancel"),
          )
        ]);
  }
}
