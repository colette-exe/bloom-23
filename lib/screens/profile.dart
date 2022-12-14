/*
    Author: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: November 14, 2022 (from Exercise 6)
    Program Description: bloom - Shared Todo App (CMSC 23 Project)
 */
import 'package:bloom/models/screen_arguments.dart';
import 'package:bloom/providers/auth_provider.dart';
import 'package:bloom/providers/user_provider.dart';
import 'package:bloom/screens/user_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloom/models/user_model.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController bioController = TextEditingController();
  bool readOnly = true;
  List lst = [];

  Widget buttonWidget(BuildContext context, bioController, userId) {
    if (readOnly) {
      // edit button
      return ElevatedButton(
        onPressed: () {
          setState(() {
            readOnly = false;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffe8b69f),
        ),
        child: const Text(
          "EDIT",
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.normal,
              fontFamily: 'Poppins',
              color: Colors.black87),
        ),
      );
    } else {
      // save button
      return ElevatedButton(
        onPressed: () {
          setState(() {
            readOnly = true;
            // update bio from userlist provider
            context
                .read<UserListProvider>()
                .changeBio(userId, bioController.text);
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffe8b69f),
        ),
        child: const Text("SAVE",
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
                fontFamily: 'Poppins',
                color: Colors.black87)),
      );
    }
  }

  Widget bioWidget(BuildContext context, bio, userId) {
    bioController.text = bio;

    return Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
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
                readOnly: readOnly,
                controller: bioController,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Poppins',
                    color: Colors.black87),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ))),
      // check buttons to display
      buttonWidget(context, bioController, userId),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // final String userId = context.read<AuthProvider>().getCurrentUser();
    final profileKey = GlobalKey<ScaffoldState>();

    DocumentReference userDoc = context
        .watch<UserListProvider>()
        .getUserById(context.watch<AuthProvider>().user!.uid);
    print(userDoc);
    // ScreenArguments uid = ScreenArguments(userDoc.id, []);
    String uid = userDoc.id;
    return Scaffold(
      key: profileKey,
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        child: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff7dac66),
              ),
              child: Text('WHERE TO?',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      letterSpacing: 1,
                      color: Colors.white)),
            ),
            ListTile(
                key: const Key('profileFriend'),
                title: const Text(
                  'Friends',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      letterSpacing: 1,
                      color: Colors.black),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/friends',
                      arguments: ScreenArguments(uid, null));
                }),
            ListTile(
                key: const Key('profileRequest'),
                title: const Text(
                  'Friend Requests',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      letterSpacing: 1,
                      color: Colors.black),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/requests',
                      arguments: ScreenArguments(uid, null));
                }),
            ListTile(
                key: const Key('profileSearch'),
                title: const Text(
                  'Search Users',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      letterSpacing: 1,
                      color: Colors.black),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/search',
                      arguments: ScreenArguments(uid, null));
                }),
            ListTile(
                key: const Key('profileTodo'),
                title: const Text(
                  'Todos',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      letterSpacing: 1,
                      color: Colors.black),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/todos',
                      arguments:
                          ScreenArguments(uid, null)); // make a todo page
                }),
            ListTile(
                title: const Text(
                  'LOGOUT',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      letterSpacing: 1,
                      color: Colors.black),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.read<AuthProvider>().signOut();
                }),
          ]),
        ),
      ),
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: const Color(0xff7dac66),
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
          margin:
              const EdgeInsets.only(left: 25, right: 25, top: 100, bottom: 50),
          padding: const EdgeInsets.all(10),
          child: FutureBuilder<DocumentSnapshot>(
              future: userDoc.get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }
                if (snapshot.hasData && !snapshot.data!.exists) {
                  return const Text("Document does not exist");
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(data['firstName'] + " " + data['lastName'],
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
                            Text(data['userName'],
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                    color: Colors.black87)),
                            const SizedBox(
                              height: 10,
                            ),
                            Text("ID: ${data['userId']}",
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                    color: Colors.black54)),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(data['bday'],
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                          color: Colors.black87)),
                                  const Icon(
                                    Icons.spa_rounded,
                                    color: Color(0xffe8b69f),
                                  ),
                                  Text(data['location'],
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
                          bioWidget(context, data['bio'], data['userId']),
                        ],
                      ));
                }

                return const Text("LOADING",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        letterSpacing: 1.0,
                        color: Color(0xff7eb180)));
              }),
        ),
      ),
    );
  }
}
