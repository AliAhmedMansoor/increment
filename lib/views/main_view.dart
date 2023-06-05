import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:incrementapp/reusables/custom_drawer.dart';
import 'package:incrementapp/pages/habits_page.dart';
import 'package:incrementapp/pages/progress_page.dart';
import 'package:incrementapp/pages/tasks_page.dart';

class MainView extends StatefulWidget {
  MainView({required this.currentIndex, Key? key}) : super(key: key);

  int currentIndex;

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final firestoreInstance = FirebaseFirestore.instance;
  String? fetchedName;
  String? fetchedUuid;
  String? appBarText;

  void updateAppBarText(String newText) {
    setState(() {
      appBarText = newText;
    });

    // Revert back to the original text after 2 seconds
    Timer(const Duration(seconds: 1), () {
      setState(() {
        appBarText = '$fetchedName';
      });
    });
  }

  @override
  void initState() {
    super.initState();

    // Reading Name or Greeting
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user.email)
          .get()
          .then((querySnapshot) {
        final List<DocumentSnapshot> documentList = querySnapshot.docs;

        if (documentList.isNotEmpty) {
          final String uuid = documentList.first.id;
          final String name = documentList.first['name'];

          setState(() {
            fetchedName = name;
            fetchedUuid = uuid;
            appBarText = '$fetchedName';
          });
        }
      });
    }

    appBarText = '$fetchedName';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: IndexedStack(
        index: widget.currentIndex,
        children: [
          TasksPage(
            fetchedName: fetchedName,
            fetchedUuid: fetchedUuid,
            updateAppBarText: updateAppBarText, // Passing the callback function
          ),
          const HabitsPage(),
          const ProgressPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 22, 22, 22),
        unselectedItemColor: const Color.fromARGB(255, 136, 136, 136),
        selectedItemColor: const Color.fromARGB(255, 133, 105, 187),
        currentIndex: widget.currentIndex,
        onTap: (index) {
          setState(() {
            widget.currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.timeline), label: ''),
        ],
      ),
      drawer: CustomDrawer(name: fetchedName),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.circle_outlined),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        elevation: 0,
        title: Text('$appBarText'),
      ),
    );
  }
}
