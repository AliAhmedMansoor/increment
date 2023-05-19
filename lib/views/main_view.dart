import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:incrementapp/constants/custom_drawer.dart';
import 'package:incrementapp/pages/habitsPage.dart';
import 'package:incrementapp/pages/progressPage.dart';
import 'package:incrementapp/pages/tasksPage.dart';

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
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: widget.currentIndex,
        children: [
          TasksPage(
            fetchedName: fetchedName,
            fetchedUuid: fetchedUuid,
          ),
          const HabitsPage(),
          const ProgressPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 28, 33, 41),
        unselectedItemColor: const Color.fromARGB(255, 106, 120, 143),
        selectedItemColor: Color.fromARGB(255, 116, 143, 249),
        currentIndex: widget.currentIndex,
        onTap: (index) {
          setState(() {
            widget.currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Habits'),
          BottomNavigationBarItem(
              icon: Icon(Icons.timeline), label: 'Progress'),
        ],
      ),
      drawer: CustomDrawer(name: fetchedName),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 80, 109, 224),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.circle_outlined),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        elevation: 0,
        title: Text('Hey, $fetchedName!'),
      ),
    );
  }
}
