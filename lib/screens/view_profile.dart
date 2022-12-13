/*
    Author: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: December 4, 2022
    Program Description: bloom - Shared Todo App (CMSC 23 Project)
    File Description: Views a user's profile
 */

import 'package:bloom/models/screen_arguments.dart';
import 'package:flutter/material.dart';
import 'package:bloom/models/user_model.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({super.key});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  TextEditingController bioController = TextEditingController();
  Widget bioWidget(BuildContext context, bio) {
    bioController.text = bio;

    if (bio.isNotEmpty) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
                width: 500,
                height: 100,
                child: DecoratedBox(
                    decoration: const BoxDecoration(color: Color(0xffb5c698)),
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.multiline,
                      minLines: 5,
                      maxLines: 5,
                      controller: bioController,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Poppins',
                          color: Colors.black87),
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                    ))),
          ]);
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    User? user = args.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 216, 161, 136),
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
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
                left: 25, right: 25, top: 100, bottom: 50),
            padding: const EdgeInsets.all(10),
            child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("${user!.firstName} ${user.lastName}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            wordSpacing: 1.0,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            letterSpacing: 1,
                            color: Color(0xff676d16))),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(children: [
                      Text(user.userName,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              color: Colors.black87)),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("ID: ${user.userId}",
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              color: Colors.black54)),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(user.bday,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                    color: Colors.black87)),
                            const Icon(
                              Icons.spa_rounded,
                              color: Color(0xff7dac66),
                            ),
                            Text(user.location,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                    color: Colors.black87)),
                          ]),
                    ]),
                    const SizedBox(
                      height: 20,
                    ),
                    bioWidget(context, user.bio),
                    // friendsWidget(
                    // context, data['friends'], data['userId']),
                  ],
                ))),
      ),
    );
  }
}
