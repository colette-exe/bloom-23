import 'package:bloom/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController pwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    final email = TextFormField(
      key: const Key('email'),
      controller: emailController,
      decoration: const InputDecoration(
        hintText: "Email",
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
        hintText: 'Password',
      ),
      validator: (value) {
        RegExp re1 = RegExp(r'.{8,}');
        RegExp re2 = RegExp(r'[a-z]{1,}');
        RegExp re3 = RegExp(r'[0-9]{1,}');
        RegExp re4 = RegExp(r'[A-Z]{1,}');
        RegExp re5 = RegExp(r'\W{1,}');
        if (value!.length >= 8) {
          return "Password must be at least 8 characters.";
        }
      },
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
      ),
    );
    final loginButton = Padding(
      key: const Key('loginButton'),
      padding: const EdgeInsets.only(top: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff7dac66),
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            context
                .read<AuthProvider>()
                .signIn(emailController.text, pwordController.text);
          }
        },
        child: const Text('LOG IN',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold)),
      ),
    );

    final signUpButton = Padding(
      key: const Key('signUpButton'),
      padding: const EdgeInsets.only(top: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff7dac66),
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
        ),
        onPressed: () async {
          Navigator.of(context).pushNamed('/sign-up');
        },
        child: const Text('SIGN UP',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      key: const Key('loginPage'),
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 50.0, right: 50.0),
              children: <Widget>[
                const Text(
                  "LOG IN",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xff144c3b),
                      fontSize: 25,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold),
                ),
                email,
                password,
                loginButton,
                signUpButton
              ],
            )),
      ),
    );
  }
}
