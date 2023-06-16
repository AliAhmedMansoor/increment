import 'dart:async';
import 'package:incrementapp/themes/colours.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:incrementapp/reusables/custom_drawer.dart';
import 'package:incrementapp/pages/habitsFolder/habits_page.dart';
import 'package:incrementapp/pages/progress_page.dart';
import 'package:incrementapp/pages/tasks_page.dart';
import 'package:incrementapp/main.dart';
import 'package:page_transition/page_transition.dart';
import 'package:incrementapp/pages/habitsFolder/alarmSettings.dart';

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
  static const IconData iconBeforeTap = Icons.calendar_today;
  static const IconData iconAfterTap = Icons.add_box_rounded;
  IconData currentIcon = iconBeforeTap;
  late Animation<double> primAnimation;
  late Animation<double> secAnimation;
  late AnimationController animationController;
  late AnimationController secondaryAnimationController;

  void updateAppBarText(String newText) {
    setState(() {
      appBarText = newText;
    });

    // Revert back to the original text after 2 seconds
    Timer(const Duration(seconds: 1), () {
      setState(() {
        appBarText = getGreeting(DateTime.now().hour);
      });
    });
  }

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
          ProgressPage(
            fetchedName: fetchedName,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colours.bottomFlexBackground,
        currentIndex: widget.currentIndex,
        onTap: (index) {
          setState(() {
            if (index == 1 &&
                currentIcon == iconAfterTap &&
                preferences.getStringList("habitName")!.length < 3) {
              Navigator.push(
                  context,
                  PageTransition(
                      child: const HabitSettings(),
                      type: PageTransitionType.fade,
                      curve: Curves.fastOutSlowIn,
                      reverseDuration: const Duration(milliseconds: 250),
                      duration: const Duration(milliseconds: 250)));
            } else {
              widget.currentIndex = index;
              currentIcon =
                  (index == 0 || index == 2) ? iconBeforeTap : iconAfterTap;
            }
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
              height: 28,
              child: Image.asset(
                'lib/icons/changes.png',
                color: Colours.navigationUnfocused,
              ),
            ),
            activeIcon: SizedBox(
              height: 28,
              child: Image.asset(
                'lib/icons/add.png',
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
          isProgressPage ? 'Overview' : appBarText ?? '',
        ),
      ),
    );
  }
}
