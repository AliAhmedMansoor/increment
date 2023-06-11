import 'dart:async';
import 'package:incrementapp/themes/colours.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:incrementapp/reusables/custom_drawer.dart';
import 'package:incrementapp/pages/habits_page.dart';
import 'package:incrementapp/pages/progress_page.dart';
import 'package:incrementapp/pages/tasks_page.dart';

// User Greeting Method and Date ----------
var hour = DateTime.now().hour;

String getGreeting(int hour) {
  if (hour > 3 && hour < 12) {
    return 'Good Morning';
  } else if (hour > 11 && hour < 18) {
    return 'Good Afternoon';
  } else if (hour > 18 && hour < 22) {
    return 'Good Evening';
  } else {
    return 'Plan Ahead';
  }
}

var now = DateTime.now();
var formatter = DateFormat('EEEE, MMMM d');
String formattedDate = formatter.format(now);

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
  bool isProgressPage = false;

  void updateAppBarText(String newText) {
    setState(() {
      appBarText = newText;
    });

    // Revert back to the original text after 2 seconds
    Timer(const Duration(seconds: 1), () {
      setState(() {
        appBarText = getGreeting(hour);
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
            appBarText = getGreeting(hour);
          });
        }
      });
    }

    // appBarText = '$fetchedName';
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
        backgroundColor: Colours.bottomFlexBackground,
        currentIndex: widget.currentIndex,
        onTap: (index) {
          setState(() {
            widget.currentIndex = index;
            isProgressPage =
                index == 2; // Changing App Bar Text If on Progress Page
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 27,
              child: Image.asset(
                'lib/icons/tasks.png',
                color: Colours.navigationUnfocused,
              ),
            ),
            activeIcon: SizedBox(
              height: 27,
              child: Image.asset(
                'lib/icons/tasks.png',
                color: Colours.navigationFocused,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 29,
              child: Image.asset(
                'lib/icons/changes.png',
                color: Colours.navigationUnfocused,
              ),
            ),
            activeIcon: SizedBox(
              height: 27,
              child: Image.asset(
                'lib/icons/changes.png',
                color: Colours.navigationFocused,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              height: 27,
              child: Image.asset(
                'lib/icons/calendar.png',
                color: Colours.navigationUnfocused,
              ),
            ),
            activeIcon: SizedBox(
              height: 27,
              child: Image.asset(
                'lib/icons/calendar.png',
                color: Colours.navigationFocused,
              ),
            ),
            label: '',
          ),
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
        title: Text(
          isProgressPage ? fetchedName ?? '' : appBarText ?? '',
        ),
      ),
    );
  }
}
