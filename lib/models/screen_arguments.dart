/*
    Author: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: November 14, 2022 (from Exercise 6)
    Program Description: bloom - Shared Todo App (CMSC 23 Project)
 */
import 'package:bloom/models/user_model.dart';

class ScreenArguments {
  final String uid;
  final User? user;

  ScreenArguments(this.uid, this.user);
}
