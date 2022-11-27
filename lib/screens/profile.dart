/*
    Author: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: November 14, 2022
    Exercise number: 06
    Program Description: 
          A Firebase Project that uses the database 
          to store users, access it when looking up users,
          and for adding, unfriending, sending, rejecting, and accepting
          friend requests
 */
import 'package:bloom/providers/user_provider.dart';
import 'package:bloom/screens/user_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloom/models/user_model.dart';

class Profile extends StatefulWidget {
  Profile({super.key});
  String userName = "user1";

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
    DocumentReference userDoc =
        context.watch<UserListProvider>().getUserByUserName(widget.userName);
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
                            Text(data['displayName'],
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                    letterSpacing: 1.5,
                                    color: Colors.white)),
                            Text(data['userName'],
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
