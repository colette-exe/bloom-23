/*
    Author: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: December 14, 2022
    Program Description: bloom - Shared Todo App (CMSC 23 Project)
    File Description: Widget Testing
 */
import 'package:bloom/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloom/main.dart' as app;

void main() {
  // Happy Paths
  // Making sure the pages for friends, friend requests, search, and todos are in profile's drawer
  group("Happy Paths", () {
    // Test 1
    testWidgets("Verifying that the Search Page is a part of Profile's drawer",
        (WidgetTester tester) async {
      // from main
      app.main();
      await tester.pumpAndSettle();
      final login = find.byKey(const Key('loginButton'));
      final signUp = find.byKey(const Key('signUpButton'));

      // expect to find login page
      expect(login, findsOneWidget);
      expect(signUp, findsOneWidget);

      // go to profile
      await tester.tap(login);
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);

      // drawer
      final ScaffoldState profilePage =
          tester.firstState(find.byType(Scaffold));
      profilePage.openDrawer();
      await tester.pumpAndSettle();

      // search option
      final profileSearch =
          find.byKey(const Key('profileSearch'), skipOffstage: false);
      expect(
        profileSearch,
        findsOneWidget,
      );
      await tester.tap(profileSearch);
      await tester.pumpAndSettle();
      final searchPage = find.byKey(const Key('searchPage'));
      expect(
        searchPage,
        findsOneWidget,
      );
    });
    // Test 2
    testWidgets("Verifying that the Friends Page is a part of Profile's drawer",
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final login = find.byKey(const Key('loginButton'));
      final signUp = find.byKey(const Key('signUpButton'));
      expect(login, findsOneWidget);
      expect(signUp, findsOneWidget);

      // go to profile
      await tester.tap(login);
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);

      // drawer
      final ScaffoldState profilePage =
          tester.firstState(find.byType(Scaffold));
      profilePage.openDrawer();
      await tester.pumpAndSettle();

      // friends option
      final profileFriend =
          find.byKey(const Key('profileFriend'), skipOffstage: false);
      expect(
        profileFriend,
        findsOneWidget,
      );
      await tester.tap(profileFriend);
      await tester.pumpAndSettle();
      final friendsPage = find.byKey(const Key('friendsPage'));
      expect(
        friendsPage,
        findsOneWidget,
      );
    });
    // Test 3
    testWidgets(
        "Verifying that the Friend Requests Page is a part of Profile's drawer",
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final login = find.byKey(const Key('loginButton'));
      final signUp = find.byKey(const Key('signUpButton'));
      expect(login, findsOneWidget);
      expect(signUp, findsOneWidget);

      // go to profile
      await tester.tap(login);
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);

      // drawer
      final ScaffoldState profilePage =
          tester.firstState(find.byType(Scaffold));
      profilePage.openDrawer();
      await tester.pumpAndSettle();

      // requests option
      final profileRequest =
          find.byKey(const Key('profileRequest'), skipOffstage: false);
      expect(
        profileRequest,
        findsOneWidget,
      );
      await tester.tap(profileRequest);
      await tester.pumpAndSettle();
      final requestsPage = find.byKey(const Key('requestsPage'));
      expect(
        requestsPage,
        findsOneWidget,
      );
    });
    // Test 4
    testWidgets(
        "Verifying that the Shared Todos Page is a part of Profile's drawer",
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final login = find.byKey(const Key('loginButton'));
      final signUp = find.byKey(const Key('signUpButton'));
      expect(login, findsOneWidget);
      expect(signUp, findsOneWidget);

      // go to profile
      await tester.tap(login);
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);

      // drawer
      final ScaffoldState profilePage =
          tester.firstState(find.byType(Scaffold));
      profilePage.openDrawer();
      await tester.pumpAndSettle();

      // todos option
      final profileTodo =
          find.byKey(const Key('profileTodo'), skipOffstage: false);
      expect(
        profileTodo,
        findsOneWidget,
      );
      await tester.tap(profileTodo);
      await tester.pumpAndSettle();
      final todosPage = find.byKey(const Key('todosPage'));
      expect(
        todosPage,
        findsOneWidget,
      );
    });
  });

  // Unhappy paths
  // Making sure the validators for the newly added fields in the Sign Up Page are working
  group("Unhappy Paths", () {
    // Test 1
    testWidgets('Birthday Field Validation Test', (WidgetTester tester) async {
      // from main
      app.main();
      await tester.pumpAndSettle();
      final login = find.byKey(const Key('loginButton'));
      final signUp = find.byKey(const Key('signUpButton'));

      // expect to find login page
      expect(login, findsOneWidget);
      expect(signUp, findsOneWidget);

      // go to the sign up page
      await tester.tap(signUp);
      await tester.pumpAndSettle();

      // make sure the sign up page is displayed
      final signUpPage = find.byKey(const Key('signUpPage'));
      expect(signUpPage, findsOneWidget);
      final signUpBtn = find.byKey(const Key('signupBtn'));
      expect(signUpBtn, findsOneWidget);

      // expect a birthday field
      final bday = find.byKey(const Key('bday'));
      expect(bday, findsOneWidget);

      await tester.tap(signUpBtn);
      await tester.pumpAndSettle();

      // expected errors to find
      final bdayError = find.text('Enter your birthday');
      final validation = find.descendant(of: bday, matching: bdayError);
      expect(validation, findsOneWidget);
    });
    // Test 2
    testWidgets('Password Pattern Validation Test',
        (WidgetTester tester) async {
      // from main
      app.main();
      await tester.pumpAndSettle();
      final login = find.byKey(const Key('loginButton'));
      final signUp = find.byKey(const Key('signUpButton'));

      // expect to find login page
      expect(login, findsOneWidget);
      expect(signUp, findsOneWidget);

      // go to the sign up page
      await tester.tap(signUp);
      await tester.pumpAndSettle();

      // make sure the sign up page is displayed
      final signUpPage = find.byKey(const Key('signUpPage'));
      expect(signUpPage, findsOneWidget);
      final signUpBtn = find.byKey(const Key('signupBtn'));
      expect(signUpBtn, findsOneWidget);

      // expect a password field
      final pword = find.byKey(const Key('pword'));
      expect(pword, findsOneWidget);

      // expected errors to find

      // 1. less than 8 characters
      final pwordError1 = find.text('Password must be at least 8 characters.');
      final validation1 = find.descendant(of: pword, matching: pwordError1);

      await tester.enterText(pword, "1234567");
      await tester.tap(signUpBtn);
      await tester.pumpAndSettle();
      expect(validation1, findsOneWidget);

      // 2. 8 or more characters, without a lowercase letter
      final pwordError2 =
          find.text('Password must have atleast 1 lowercase letter.');
      final validation2 = find.descendant(of: pword, matching: pwordError2);

      await tester.enterText(pword, "12345678AA");
      await tester.tap(signUpBtn);
      await tester.pumpAndSettle();
      expect(validation2, findsOneWidget);

      // 3. No digits
      final pwordError3 = find.text('Password must have at least 1 digit.');
      final validation3 = find.descendant(of: pword, matching: pwordError3);

      await tester.enterText(pword, "AAAAaaaf");
      await tester.tap(signUpBtn);
      await tester.pumpAndSettle();
      expect(validation3, findsOneWidget);

      // 4. No uppercase letters
      final pwordError4 =
          find.text('Password must have at least one uppercase letter.');
      final validation4 = find.descendant(of: pword, matching: pwordError4);

      await tester.enterText(pword, "aa11aaaf");
      await tester.tap(signUpBtn);
      await tester.pumpAndSettle();
      expect(validation4, findsOneWidget);

      // 5. No special characters
      final pwordError5 =
          find.text('Password must have at least one special character.');
      final validation5 = find.descendant(of: pword, matching: pwordError5);

      await tester.enterText(pword, "aa11AAaa");
      await tester.tap(signUpBtn);
      await tester.pumpAndSettle();
      expect(validation5, findsOneWidget);
    });
    // Test 3
    testWidgets('Location Field Validation Test', (WidgetTester tester) async {
      // from main
      app.main();
      await tester.pumpAndSettle();
      final login = find.byKey(const Key('loginButton'));
      final signUp = find.byKey(const Key('signUpButton'));

      // expect to find login page
      expect(login, findsOneWidget);
      expect(signUp, findsOneWidget);

      // go to the sign up page
      await tester.tap(signUp);
      await tester.pumpAndSettle();

      // make sure the sign up page is displayed
      final signUpPage = find.byKey(const Key('signUpPage'));
      expect(signUpPage, findsOneWidget);
      final signUpBtn = find.byKey(const Key('signupBtn'));
      expect(signUpBtn, findsOneWidget);

      // expect a location field
      final location = find.byKey(const Key('location'));
      expect(location, findsOneWidget);

      await tester.tap(signUpBtn);
      await tester.pumpAndSettle();

      // expected error to find
      final locationError = find.text('Enter location');
      final validation = find.descendant(of: location, matching: locationError);
      expect(validation, findsOneWidget);
    });
    // Test 4
    testWidgets('Username Field Validation Test', (WidgetTester tester) async {
      // from main
      app.main();
      await tester.pumpAndSettle();
      final login = find.byKey(const Key('loginButton'));
      final signUp = find.byKey(const Key('signUpButton'));

      // expect to find login page
      expect(login, findsOneWidget);
      expect(signUp, findsOneWidget);

      // go to the sign up page
      await tester.tap(signUp);
      await tester.pumpAndSettle();

      // make sure the sign up page is displayed
      final signUpPage = find.byKey(const Key('signUpPage'));
      expect(signUpPage, findsOneWidget);
      final signUpBtn = find.byKey(const Key('signupBtn'));
      expect(signUpBtn, findsOneWidget);

      // expect a username field
      final uname = find.byKey(const Key('uname'));
      expect(uname, findsOneWidget);

      await tester.tap(signUpBtn);
      await tester.pumpAndSettle();

      // expected error to find
      final unameError = find.text('Enter your username');
      final validation = find.descendant(of: uname, matching: unameError);
      expect(validation, findsOneWidget);
    });
  });
}
