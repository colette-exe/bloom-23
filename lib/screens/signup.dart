/* 
    Author: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: November 27, 2022
    Program Description: bloom - Shared Todo App (CMSC 23 Project)
    File Description: Sign Up Page
 */

import 'package:bloom/api/firebase_user_api.dart';
import 'package:bloom/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bloom/providers/auth_provider.dart';

import '../models/user_model.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // controllers
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController unameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController bdayController = TextEditingController();
  String bday = "";
  TextEditingController locationController = TextEditingController();
  TextEditingController pwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // final docs =
    //     User.fromJsonArray(context.read<UserListProvider>().getAllUserNames());

    // form fields -------------------
    final fname = TextFormField(
      key: const Key('fname'),
      controller: fnameController,
      decoration: const InputDecoration(labelText: "First Name"),
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
      decoration: const InputDecoration(labelText: "Last Name"),
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
      key: const Key('uname'),
      controller: unameController,
      decoration: const InputDecoration(
        labelText: "User Name",
      ),
      validator: (value) {
        // validator for last name field
        if (value!.isEmpty) {
          return "Enter your username";
        } else {
          return null;
        }
      },
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
    );

    final bdayField = TextFormField(
      controller: bdayController,
      key: const Key('bday'),
      decoration: const InputDecoration(labelText: "Birthday (MM/DD/YYYY)"),
      onTap: (() async {
        DateTime? date = await showDatePicker(
            fieldHintText: "Enter birthday",
            context: context,
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            initialDate: DateTime.now(),
            firstDate: DateTime(1800),
            lastDate: DateTime.now());

        if (date != null) {
          setState(() {
            bdayController.text = "${date.month}/${date.day}/${date.year}";
            bday = bdayController.text;
          });
        }
      }),
      validator: ((value) {
        if (bday.isEmpty) {
          return "Enter your birthday";
        } else {
          return null;
        }
      }),
    );

    final location = TextFormField(
      key: const Key('location'),
      controller: locationController,
      decoration: const InputDecoration(
        labelText: "Location",
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
        labelText: "Email",
      ),
      // regex for email validation from https://www.abstractapi.com/tools/email-regex-guide/
      validator: (value) {
        RegExp re = RegExp(
            r'^[a-zA-Z0-9.!#$%&’ +/=?^_`{|}~-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+$');
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
        labelText: 'Password',
      ),
      validator: (value) {
        RegExp re1 = RegExp(r'.{8,}');
        RegExp re2 = RegExp(r'[a-z]{1,}');
        RegExp re3 = RegExp(r'[0-9]{1,}');
        RegExp re4 = RegExp(r'[A-Z]{1,}');
        RegExp re5 = RegExp(r'\W{1,}');
        if (re1.hasMatch(value!)) {
          if (re2.hasMatch(value)) {
            if (re3.hasMatch(value)) {
              if (re4.hasMatch(value)) {
                if (re5.hasMatch(value)) {
                  return null;
                }
                return "Password must have at least one special character.";
              }
              return "Password must have at least one uppercase letter.";
            }
            return "Password must have at least 1 digit.";
          }
          return "Password must have atleast 1 lowercase letter.";
        }
        return "Password must be at least 8 characters.";
      },
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
    );

    final signupButton = Padding(
      key: const Key('signupBtn'),
      padding: const EdgeInsets.only(top: 20),
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
      padding: const EdgeInsets.only(top: 20),
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
