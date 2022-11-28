/*
    Author: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: November 27, 2022
    Program Description: bloom - Shared Todo App (CMSC 23 Project)
    File Description: Sign Up Page
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bloom/providers/auth_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // controllers
    TextEditingController fnameController = TextEditingController();
    TextEditingController lnameController = TextEditingController();
    TextEditingController unameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    String bday = "";
    TextEditingController locationController = TextEditingController();
    TextEditingController pwordController = TextEditingController();

    final fname = TextFormField(
      key: const Key('fname'),
      controller: fnameController,
      decoration: const InputDecoration(
        hintText: "First Name",
      ),
      validator: (value) {
        // validator for first name field
        if (value!.isEmpty) {
          return "Enter your first name";
        } else {
          return null;
        }
      },
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
    );

    final lname = TextFormField(
      key: const Key('lname'),
      controller: lnameController,
      decoration: const InputDecoration(
        hintText: "Last Name",
      ),
      validator: (value) {
        // validator for last name field
        if (value!.isEmpty) {
          return "Enter your last name";
        } else {
          return null;
        }
      },
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
    );

    final uname = TextFormField(
      key: const Key('lname'),
      controller: unameController,
      decoration: const InputDecoration(
        hintText: "username",
      ),
      validator: (value) {
        // validator for last name field
        if (value!.isEmpty) {
          return "Enter your username";
        } else {
          RegExp re = RegExp(r"");
          return null;
        }
      },
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
    );

    final bdayField = InputDatePickerFormField(
      key: const Key('lname'),
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      onDateSaved: (value) {
        setState(() {
          bday = value.toString();
        });
      },
      fieldHintText: "MM/DD/YYYY",
    );

    final location = TextFormField(
      key: const Key('lname'),
      controller: locationController,
      decoration: const InputDecoration(
        hintText: "Location",
      ),
      validator: (value) {
        // validator for last name field
        if (value!.isEmpty) {
          return "Enter location";
        } else {
          return null;
        }
      },
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
    );

    final email = TextFormField(
      key: const Key('email'),
      controller: emailController,
      decoration: const InputDecoration(
        hintText: "Email",
      ),
      // regex for email validation from https://www.abstractapi.com/tools/email-regex-guide/
      validator: (value) {
        RegExp re = RegExp(
            r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+$');
        if (re.hasMatch(value!) && value.isNotEmpty) {
          return null;
        } else {
          return "Enter a valid email address";
        }
      },
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
    );

    final password = TextFormField(
      key: const Key('pword'),
      controller: pwordController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
      validator: (value) {
        RegExp re = RegExp(r'.{8,}');
        if (re.hasMatch(value!)) {
          return null;
        } else {
          return "Password must be at least 8 characters";
        }
      },
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
    );

    final signupButton = Padding(
      key: const Key('signupBtn'),
      padding: const EdgeInsets.only(left: 200, right: 200, top: 20),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<AuthProvider>().signUp(
                    fnameController.text,
                    lnameController.text,
                    emailController.text,
                    pwordController.text,
                    bday,
                    locationController.text,
                    unameController.text,
                  );
              Navigator.pop(context);
            }
          },
          child: const Text('SIGN UP',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold))),
    );

    final backButton = Padding(
      key: const Key('backBtn'),
      padding: const EdgeInsets.only(left: 200, right: 200, top: 20),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
          child: const Text('BACK',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold))),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 50.0, right: 50.0),
          children: <Widget>[
            const Text(
              "SIGN UP",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold),
            ),
            fname,
            lname,
            uname,
            bdayField,
            location,
            email,
            password,
            signupButton,
            backButton
          ],
        ),
      )),
    );
  }
}
