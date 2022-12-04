/*
    Author: Angelica Nicolette U. Adoptante
    Section: D1L
    Date created: November 14, 2022 (from Exercise 6)
    Program Description: bloom - Shared Todo App (CMSC 23 Project)
 */
import 'package:bloom/screens/user_page.dart';
import 'package:flutter/material.dart';

import '../models/current_user.dart';

class Search extends StatefulWidget {
  Search({super.key});
  String text = "";

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CurrentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search',
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
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(width: 500),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Enter Name",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Colors.black87),
                      controller: _controller,
                      onChanged: ((value) => setState(() {
                            widget.text = _controller.text;
                          })),
                    )),
                OutlinedButton(
                  onPressed: () {
                    _controller.text = "";
                    setState(() {
                      widget.text = _controller.text;
                    });
                  },
                  child: const Text('CLEAR'),
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: UserPage(regex: widget.text, uid: args.uid)),
              ])),
    );
  }
}
