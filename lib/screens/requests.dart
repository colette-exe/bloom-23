import 'package:bloom/screens/user_page.dart';
import 'package:flutter/material.dart';
import '../models/screen_arguments.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    String uid = args.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Received Requests',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: Container(
          padding: const EdgeInsets.all(30),
          height: MediaQuery.of(context).size.height,
          child: SizedBox(
              height: MediaQuery.of(context).size.height - 500,
              child: UserPage(regex: "", uid: uid, type: "requests"))),
    );
  }
}
