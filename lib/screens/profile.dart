/*
    Author: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: November 14, 2022 (from Exercise 6)
    Program Description: bloom - Shared Todo App (CMSC 23 Project)
 */
import 'package:bloom/models/current_user.dart';
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
          backgroundColor: Colors.green.shade500,
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
            (context as Element).reassemble();
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade500,
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
        width: 200,
        height: 200,
        child: ListView(children: [
          TextField(
            readOnly: readOnly,
            controller: bioController,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                fontFamily: 'Poppins',
                color: Colors.black87),
            decoration: const InputDecoration(border: OutlineInputBorder()),
          )
        ]),
      ),
      // check buttons to display
      buttonWidget(context, bioController, userId),
    ]);
  }

  Widget friendsWidget(BuildContext context, lst) {
    if (lst.length > 0) {
      return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("FRIENDS",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                        fontFamily: 'Poppins',
                        letterSpacing: 1.0,
                        color: Colors.black54)),
                SizedBox(
                    height: 200,
                    child: ListView.builder(
                      // try making this a streambuilder instead
                      itemCount: lst.length,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        var user = context
                            .watch<UserListProvider>()
                            .getNameByUserId(lst[index]);

                        print("in profile: $user");
                        return Text("${lst[index]}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w200,
                                fontFamily: 'Poppins',
                                letterSpacing: 1.0,
                                color: Colors.blueGrey.shade800));
                      }),
                    ))
              ]));
    } else {
      return Text("No Friends Yet",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.blue.shade700));
    }
  }

  @override
  Widget build(BuildContext context) {
    // final String userId = context.read<AuthProvider>().getCurrentUser();

    DocumentReference userDoc = context
        .watch<UserListProvider>()
        .getUserById(context.watch<AuthProvider>().user!.uid);
    CurrentUser uid = CurrentUser(userDoc.id);

    // final args = ModalRoute.of(context)!.settings.arguments as InputName;
    return Scaffold(
      drawer: Drawer(
        child: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
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
                title: const Text(
                  'Search Users',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Poppins',
                      letterSpacing: 1,
                      color: Colors.black),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/search', arguments: uid);
                }),
            ListTile(
                title: const Text(
                  'Todos',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Poppins',
                      letterSpacing: 1,
                      color: Colors.black),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/todos'); // make a todo page
                }),
            ListTile(
                title: const Text(
                  'LOGOUT',
                  style: TextStyle(
                      fontSize: 14,
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
                      height: 800,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(data['firstName'] + " " + data['lastName'],
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 1,
                                  color: Colors.white)),
                          Column(children: [
                            Text(data['userName'],
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                    color: Colors.black87)),
                            Text("ID: ${data['userId']}",
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                    color: Colors.black54)),
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
                                  Icon(
                                    Icons.spa_rounded,
                                    color: Colors.amber.shade400,
                                  ),
                                  Text(data['location'],
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                          color: Colors.black87)),
                                ]),
                          ]),
                          bioWidget(context, data['bio'], data['userId']),
                          friendsWidget(context, data['friends']),
                        ],
                      ));
                }

                return const Text("LOADING",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w200,
                        fontFamily: 'Poppins',
                        letterSpacing: 1.0,
                        color: Colors.black));
              }),
        ),
      ),
    );
  }
}
