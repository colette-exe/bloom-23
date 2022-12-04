import 'package:bloom/models/screen_arguments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../providers/user_provider.dart';

class ViewProfile extends StatefulWidget {
  ViewProfile({super.key});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  TextEditingController bioController = TextEditingController();
  Widget bioWidget(BuildContext context, bio) {
    bioController.text = bio;

    return SizedBox(
        width: 500,
        height: 100,
        child: TextField(
          textAlign: TextAlign.center,
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 5,
          readOnly: true,
          controller: bioController,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              fontFamily: 'Poppins',
              color: Colors.black87),
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ));
    // check buttons to display
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    User? user = args.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            letterSpacing: 1.5,
            color: Colors.white),
      ),
      body: Center(
        widthFactor: MediaQuery.of(context).size.width,
        heightFactor: MediaQuery.of(context).size.height,
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.green.shade100),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Colors.green.shade400),
            width: 500,
            height: 1000,
            alignment: Alignment.center,
            margin: const EdgeInsets.all(50),
            padding: const EdgeInsets.all(20),
            child: SizedBox(
                height: 800,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("${user!.firstName} ${user.lastName}",
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            letterSpacing: 1,
                            color: Colors.white)),
                    Column(children: [
                      Text(user.userName,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              color: Colors.black87)),
                      Text("ID: ${user.userId}",
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              color: Colors.black54)),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(user.bday,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                    color: Colors.black87)),
                            Icon(
                              Icons.spa_rounded,
                              color: Colors.amber.shade400,
                            ),
                            Text(user.location,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                    color: Colors.black87)),
                          ]),
                    ]),
                    bioWidget(context, user.bio),
                    // friendsWidget(
                    // context, data['friends'], data['userId']),
                  ],
                ))),
      ),
    );
  }
}
