/*
    Author: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: December 14, 2022
    Program Description: bloom - Shared Todo App (CMSC 23 Project)
    File Description: Integration Testing
 */

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:bloom/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test ( Happy Paths )', () {
    // Test 1
    testWidgets('Login In Successfully', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // log in page elements
      final email = find.byKey(const Key('email'));
      final pword = find.byKey(const Key('pword'));
      final loginBtn = find.byKey(const Key('loginButton'));
      final signUpBtn = find.byKey(const Key('signUpButton'));

      // expect Log In Page
      expect(email, findsOneWidget);
      expect(pword, findsOneWidget);
      expect(loginBtn, findsOneWidget);
      expect(signUpBtn, findsOneWidget);

      // enter credentials
      await tester.enterText(email, "angelica@gmail.com");
      await tester.enterText(pword, "12345678");

      await tester.tap(loginBtn);
      await tester.pumpAndSettle();

      // expect profile page
      final profilePage = find.byKey(const Key('profilePage'));
      expect(profilePage, findsOneWidget);
    });
    // Test 2
    testWidgets('Sign Up Successfully', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // log in page elements
      final e = find.byKey(const Key('email'));
      final p = find.byKey(const Key('pword'));
      final loginBtn = find.byKey(const Key('loginButton'));
      final signUpBtn = find.byKey(const Key('signUpButton'));

      // expect Log In Page
      expect(e, findsOneWidget);
      expect(p, findsOneWidget);
      expect(loginBtn, findsOneWidget);
      expect(signUpBtn, findsOneWidget);

      // go to the sign up page
      await tester.tap(signUpBtn);
      await tester.pumpAndSettle();

      // expect a sign up page
      // sign up page elements
      final fname = find.byKey(const Key('fname'));
      final lname = find.byKey(const Key('lname'));
      final uname = find.byKey(const Key('uname'));
      final location = find.byKey(const Key('location'));
      final bday = find.byKey(const Key('bday'));
      final email = find.byKey(const Key('email'));
      final pword = find.byKey(const Key('pword'));
      final signupBtn = find.byKey(const Key('signupBtn'));
      final back = find.byKey(const Key('backBtn'));

      // expect Sign Up Page
      expect(fname, findsOneWidget);
      expect(lname, findsOneWidget);
      expect(uname, findsOneWidget);
      expect(location, findsOneWidget);
      expect(bday, findsOneWidget);
      expect(email, findsOneWidget);
      expect(pword, findsOneWidget);
      expect(signupBtn, findsOneWidget);
      expect(back, findsOneWidget);

      // enter details
      await tester.enterText(fname, "Lune");
      await Future.delayed(const Duration(seconds: 1));
      await tester.enterText(lname, "Moon");
      await Future.delayed(const Duration(seconds: 1));
      await tester.enterText(uname, "tsuki");
      await Future.delayed(const Duration(seconds: 1));
      // await tester.enterText(bday, '01/01/2002');
      await tester.tap(bday);
      await Future.delayed(const Duration(seconds: 1));
      await tester.tap(find.text('10'));
      await Future.delayed(const Duration(seconds: 1));
      await tester.tap(find.text('OK'));
      await Future.delayed(const Duration(seconds: 1));
      await tester.enterText(location, "Stars");
      await Future.delayed(const Duration(seconds: 1));
      await tester.enterText(email, "lune_moon@gmail.com");
      await Future.delayed(const Duration(seconds: 1));
      await tester.enterText(pword, "123MOon()");
      await Future.delayed(const Duration(seconds: 1));
      await tester.tap(signupBtn);

      await tester.pumpAndSettle();
      // redirected to profile
      // expect profile page
      final profilePage = find.byKey(const Key('profilePage'));
      expect(profilePage, findsOneWidget);
    });
  });

  group('end-to-end test ( Unhappy Paths )', () {
    // Test 3
    testWidgets('Unsuccessful Sign Up, wrong user inputs',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // log in page elements
      final e = find.byKey(const Key('email'));
      final p = find.byKey(const Key('pword'));
      final loginBtn = find.byKey(const Key('loginButton'));
      final signUpBtn = find.byKey(const Key('signUpButton'));

      // expect Log In Page
      expect(e, findsOneWidget);
      expect(p, findsOneWidget);
      expect(loginBtn, findsOneWidget);
      expect(signUpBtn, findsOneWidget);

      // go to the sign up page
      await tester.tap(signUpBtn);
      await tester.pumpAndSettle();

      // sign up page elements
      final signUpPage = find.byKey(const Key('signUpPage'));
      final fname = find.byKey(const Key('fname'));
      final lname = find.byKey(const Key('lname'));
      final uname = find.byKey(const Key('uname'));
      final location = find.byKey(const Key('location'));
      final bday = find.byKey(const Key('bday'));
      final email = find.byKey(const Key('email'));
      final pword = find.byKey(const Key('pword'));
      final signupBtn = find.byKey(const Key('signupBtn'));
      final back = find.byKey(const Key('backBtn'));

      // expect Sign Up Page
      expect(fname, findsOneWidget);
      expect(lname, findsOneWidget);
      expect(uname, findsOneWidget);
      expect(location, findsOneWidget);
      expect(bday, findsOneWidget);
      expect(email, findsOneWidget);
      expect(pword, findsOneWidget);
      expect(signupBtn, findsOneWidget);
      expect(back, findsOneWidget);

      // enter details
      await tester.enterText(fname, "None");
      await Future.delayed(const Duration(seconds: 1));
      await tester.enterText(lname, "TheWiser");
      await Future.delayed(const Duration(seconds: 1));
      await tester.enterText(uname, "nononone");
      await Future.delayed(const Duration(seconds: 1));
      await tester.tap(bday);
      await Future.delayed(const Duration(seconds: 1));
      await tester.tap(find.text('12'));
      await Future.delayed(const Duration(seconds: 1));
      await tester.tap(find.text('OK'));
      await Future.delayed(const Duration(seconds: 1));
      await tester.enterText(location, "Nowhere");
      await Future.delayed(const Duration(seconds: 1));
      await tester.enterText(email, "nononone@gmail");
      await Future.delayed(const Duration(seconds: 1));
      await tester.enterText(pword, "123MM");
      await Future.delayed(const Duration(seconds: 1));
      await tester.tap(signupBtn);

      await tester.pumpAndSettle();
      // stay in the sign up page
      expect(signUpPage, findsOneWidget);
    });
    // test 4
    testWidgets('Unsuccessful Log In, wrong user inputs',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // log in page elements
      final e = find.byKey(const Key('email'));
      final p = find.byKey(const Key('pword'));
      final loginBtn = find.byKey(const Key('loginButton'));
      final signUpBtn = find.byKey(const Key('signUpButton'));

      // expect Log In Page
      expect(e, findsOneWidget);
      expect(p, findsOneWidget);
      expect(loginBtn, findsOneWidget);
      expect(signUpBtn, findsOneWidget);

      // empty fields
      await tester.enterText(e, "");
      await Future.delayed(const Duration(seconds: 1));
      await tester.enterText(p, "");
      await Future.delayed(const Duration(seconds: 1));
      await tester.tap(loginBtn);
      await tester.pumpAndSettle();

      // expect Log In Page
      final loginPage = find.byKey(const Key('loginPage'));
      expect(loginPage, findsOneWidget);

      // incorrect fields
      await tester.enterText(e, "angelica@gmail");
      await Future.delayed(const Duration(seconds: 1));
      await tester.enterText(p, "12312312");
      await Future.delayed(const Duration(seconds: 1));
      await tester.tap(loginBtn);
      await tester.pumpAndSettle();

      // expect Log In Page
      expect(loginPage, findsOneWidget);
    });
  });
}
