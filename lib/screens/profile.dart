/*
    Author: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: November 14, 2022 (from Exercise 6)
    Program Description: bloom - Shared Todo App (CMSC 23 Project)
 */
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
  Widget friendsWidget(BuildContext context, lst) {
    if (lst.length > 0) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text("FRIENDS",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w200,
                    fontFamily: 'Poppins',
                    letterSpacing: 1.0,
                    color: Colors.black54)),
            SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: lst.length,
                  shrinkWrap: true,
                  itemBuilder: ((context, index) {
                    // List f = context
                    //     .read<UserListProvider>()
                    //     .getUserByUserId(lst[index]);
                    return Text(lst[index],
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w200,
                            fontFamily: 'Poppins',
                            letterSpacing: 1.0,
                            color: Colors.blueGrey.shade800));
                  }),
                ))
          ]);
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
        .getUserByUserName(context.watch<AuthProvider>().user!.uid);
    // print("\nprint: ${userDoc}\n");

    // final args = ModalRoute.of(context)!.settings.arguments as InputName;
    return Scaffold(
      drawer: Drawer(
        child: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Text('WHERE TO?'),
            ),
            ListTile(
                title: const Text('Search Friends'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/search');
                }),
            ListTile(
                title: const Text('LOGOUT'),
                onTap: () {
                  Navigator.pop(context);
                  context.read<AuthProvider>().signOut();
                })
          ]),
        ),
      ),
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        widthFactor: MediaQuery.of(context).size.width,
        heightFactor: MediaQuery.of(context).size.height,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade100),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Colors.blue.shade400),
          width: 400,
          height: 500,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(50),
          padding: const EdgeInsets.all(50),
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
                      height: 500,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(children: [
                            Text(data['firstName'] + " " + data['lastName'],
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                    letterSpacing: 1.5,
                                    color: Colors.white)),
                            Text(data['username'],
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                    color: Colors.black87)),
                            Text(data['bday'],
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                    color: Colors.black87)),
                            Text(data['location'],
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                    color: Colors.black87))
                          ]),
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
