import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:incrementapp/reusables/app_colours.dart';

class TasksPage extends StatefulWidget {
  const TasksPage(
      {required this.fetchedName,
      required this.fetchedUuid,
      Key? key,
      required this.updateAppBarText})
      : super(key: key);

  final String? fetchedName;
  final String? fetchedUuid;
  final Function(String) updateAppBarText;

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class Users {
  final String name;
  String taskId;
  String task;
  bool isChecked;
  DateTime time;

  Users({
    this.taskId = '',
    required this.task,
    required this.name,
    this.isChecked = false,
    required this.time,
  });

  // Writing
  Map<String, dynamic> toJson() => {
        'name': name,
        'taskId': taskId,
        'task': task,
        'isChecked': isChecked,
        'time': Timestamp.fromDate(time),
      };

  // Reading
  static Users fromJson(Map<String, dynamic> json) {
    return Users(
      name: json['name'],
      taskId: json['taskId'],
      task: json['task'],
      isChecked: json['isChecked'],
      time: (json['time'] as Timestamp).toDate(),
    );
  }

  void toggleChecked() {
    isChecked = !isChecked;
  }
}

// Random Quotes
List<String> quotes = [
  "\"The secret to getting ahead is getting started.\" ― Mark Twain",
  "\"Don't watch the clock; do what it does. Keep going.\" ― Sam Levenson",
  "\"The only way to do great work is to love what you do.\" ― Steve Jobs",
  "\"Success is not the key to happiness. Happiness is the key to success. If you love what you are doing, you will be successful.\" ― Albert Schweitzer",
  "\"The future depends on what you do today.\" ―  Mahatma Gandhi",
  "\"With faith, discipline and selfless devotion to duty, there is nothing worthwhile that you cannot achieve.\" ― Muhammad Ali Jinnah",
  "\"Be the change that you wish to see in the world.\" ― Mahatma Gandhi",
];
Random random = Random();

class _TasksPageState extends State<TasksPage> {
  final controller = TextEditingController();
  final confettiController = ConfettiController();
  bool hasConfettiPlayed = false;
  // For closing keyboard
  final FocusNode _focusNode = FocusNode();
  int tasksCount = 0;
  bool _isDelayCompleted = false;

  // Adding Tasks (Task Tile)
  Widget buildUser(Users user, Function() onChanged) =>
      Stack(alignment: Alignment.center, children: [
        Container(
          decoration: BoxDecoration(
            color: user.isChecked
                ? const Color.fromARGB(232, 30, 30, 30)
                : const Color.fromARGB(255, 34, 34, 34),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            trailing: Transform.scale(
              scale: 1.4,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Checkbox(
                  checkColor: const Color.fromARGB(255, 228, 167, 197),
                  fillColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return const Color.fromARGB(
                          232, 30, 30, 30); // When checkbox is checked
                    } else {
                      return const Color.fromARGB(
                          255, 197, 197, 197); // When checkbox is unchecked
                    }
                  }),
                  value: user.isChecked,
                  onChanged: (newValue) {
                    setState(() {
                      user.toggleChecked();
                      if (user.isChecked && !hasConfettiPlayed) {
                        confettiController.play();
                        hasConfettiPlayed = true;
                        widget.updateAppBarText('Woohoo!');
                        // Start the timer for 2 seconds
                        Timer(const Duration(seconds: 1), () {
                          confettiController.stop();
                        });
                      }
                    });
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.taskId)
                        .update({'isChecked': user.isChecked});
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            title: Text(
              user.task,
              style: user.isChecked
                  ? const TextStyle(
                      color: Color.fromARGB(255, 144, 144, 144),
                      decoration: TextDecoration.lineThrough,
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    )
                  : const TextStyle(
                      color: Color.fromARGB(255, 242, 242, 242),
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
            ),
          ),
        ),
        if (user.isChecked)
          Transform.scale(
            scale: 0.7,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0,
              gravity: 0.8,
              maxBlastForce: 50,
              numberOfParticles: 10,
              shouldLoop: false,
              colors: const [
                Colors.red,
                Colors.blue,
                Colors.yellow,
                Colors.green,
              ],
            ),
          ),
      ]);

  String selectedQuote = '';

  @override
  void initState() {
    super.initState();
    // Delay Timer
    Timer(const Duration(seconds: 1), () {
      setState(() {
        _isDelayCompleted = true;
      });
    });
    // Random Quote
    selectedQuote = getRandomQuote();
    confettiController.addListener(() {
      if (confettiController.state == ConfettiControllerState.stopped) {
        setState(() {
          hasConfettiPlayed = false;
        });
      }
    });
  }

  String getRandomQuote() {
    return quotes[random.nextInt(quotes.length)];
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  // Reading Task
  Stream<List<Users>> readTask() {
    return FirebaseFirestore.instance
        .collection('users')
        .orderBy('time', descending: true)
        .where('name', isEqualTo: widget.fetchedUuid)
        .snapshots()
        .map((querySnapshot) {
      int count = 0;
      final List<Users> users = querySnapshot.docs.map((docSnapshot) {
        final user = Users.fromJson(docSnapshot.data());
        if (!user.isChecked) {
          count++; // Unchecked tasks count
        }
        return user;
      }).toList();

      setState(() {
        if (!_isDelayCompleted) {
          tasksCount = 0;
        } else {
          tasksCount = count;
        }
      });

      return users;
    });
  }

  // Creating Task
  Future createTask({required String task}) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();

    // Validating Empty Input
    if (task.trim().isEmpty) {
      return;
    }

    final user = Users(
      name: widget.fetchedUuid!,
      taskId: docUser.id,
      task: task,
      time: DateTime.now(),
    );
    final json = user.toJson();

    await docUser.set(json);
  }

  // Deleting Task
  void _onDismissed(String taskId) {
    final docUser = FirebaseFirestore.instance.collection('users').doc(taskId);
    docUser.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 109, 81, 165),
              Color.fromARGB(255, 228, 167, 197)
            ],
            begin: Alignment.topCenter,
            end: Alignment.center,
          ),
        ),
      ),
      SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    '$tasksCount',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 60,
                      color: Color.fromARGB(192, 255, 255, 255),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 22, 22, 22),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: StreamBuilder<List<Users>>(
                  stream: readTask(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (_isDelayCompleted == false) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      final users = snapshot.data!;

                      return users.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    // Random Quotes
                                    selectedQuote,

                                    style: const TextStyle(
                                      height: 1.5,
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 228, 167, 197),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: ListView.builder(
                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  final user = users[index];
                                  return Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 7,
                                      ),
                                      child: Dismissible(
                                        key: Key(user.taskId),
                                        onDismissed: (direction) {
                                          _onDismissed(user.taskId);
                                        },
                                        direction: DismissDirection.endToStart,
                                        background: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color.fromARGB(
                                                      255, 168, 71, 71),
                                                  Color.fromARGB(
                                                      255, 222, 133, 133)
                                                ],
                                                begin: Alignment.centerRight,
                                                end: Alignment.centerLeft,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: const [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 16.0),
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        child: buildUser(user, () {
                                          setState(() {
                                            user.toggleChecked();
                                          });
                                        }),
                                      ));
                                },
                              ),
                            );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
            Container(
              color: const Color.fromARGB(255, 22, 22, 22),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: _focusNode,
                      controller: controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'I want to...',
                        hintStyle: const TextStyle(color: Colors.white54),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: PurpleTheme.primaryColor,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 128, 101, 183),
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Increment Button
                  SizedBox(
                    height: 48,
                    width: 100,
                    child: FloatingActionButton(
                      onPressed: () {
                        final task = controller.text;
                        createTask(task: task);
                        controller.clear();
                        _focusNode.unfocus();
                      },
                      backgroundColor: const Color.fromARGB(255, 128, 101, 183),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                      child: const Text(
                        'increment',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 240, 240, 240),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ]));
  }
}
