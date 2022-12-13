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
    final email = TextFormField(
      key: const Key('email'),
      controller: emailController,
      decoration: const InputDecoration(
        hintText: "Email",
      ),
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
          backgroundColor: Colors.green,
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
        ),
        onPressed: () {
          context
              .read<AuthProvider>()
              .signIn(emailController.text, pwordController.text);
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
          backgroundColor: Colors.green,
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
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 50.0, right: 50.0),
          children: <Widget>[
            const Text(
              "LOG IN",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold),
            ),
            email,
            password,
            loginButton,
            signUpButton
          ],
        ),
      ),
    );
  }
}
