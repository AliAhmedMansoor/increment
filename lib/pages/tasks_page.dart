import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:incrementapp/reusables/app_colours.dart';

class TasksPage extends StatefulWidget {
  const TasksPage(
      {required this.fetchedName, required this.fetchedUuid, Key? key})
      : super(key: key);

  final String? fetchedName;
  final String? fetchedUuid;

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

class _TasksPageState extends State<TasksPage> {
  final controller = TextEditingController();
  final confettiController = ConfettiController();
  bool hasConfettiPlayed = false;
  // For closing keyboard
  final FocusNode _focusNode = FocusNode();

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

  // Adding Tasks (Task Tile)
  Widget buildUser(Users user, Function() onChanged) =>
      Stack(alignment: Alignment.center, children: [
        Container(
          decoration: BoxDecoration(
            color: user.isChecked
                ? PurpleTheme.isChecked
                : const Color.fromARGB(255, 40, 46, 55),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            trailing: Transform.scale(
              scale: 1.29,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Checkbox(
                  fillColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return PurpleTheme
                          .primaryColor; // When checkbox is checked
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
                      color: Color.fromARGB(255, 139, 148, 172),
                      decoration: TextDecoration.lineThrough,
                    )
                  : const TextStyle(color: Colors.white),
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
              maxBlastForce: 30,
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

  @override
  void initState() {
    super.initState();
    confettiController.addListener(() {
      if (confettiController.state == ConfettiControllerState.stopped) {
        setState(() {
          hasConfettiPlayed = false;
        });
      }
    });
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
      return querySnapshot.docs.map((docSnapshot) {
        return Users.fromJson(docSnapshot.data());
      }).toList();
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
      body: Container(
        color: const Color.fromARGB(255, 80, 109, 224),
        child: Column(
          children: [
            const Expanded(
              flex: 1,
              child: SizedBox(
                child: Padding(
                  padding: EdgeInsets.only(top: 1.025),
                  child: Image(
                    image: NetworkImage(
                        'https://res.cloudinary.com/dw095oyal/image/upload/w_1000,h_1000,c_limit,q_auto/v1684428601/IMAGE_u5ohjg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 28, 33, 41),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    )),
                child: StreamBuilder<List<Users>>(
                  stream: readTask(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
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
                                    quotes[random.nextInt(quotes.length)],
                                    style: const TextStyle(
                                      height: 1.5,
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 165, 185, 213),
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
                                        vertical: 10,
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
                                            color: const Color.fromARGB(
                                                255, 80, 109, 224),
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
              color: const Color.fromARGB(255, 28, 33, 41),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                            color: PurpleTheme.primaryColor,
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
                      backgroundColor: PurpleTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                      child: const Text(
                        'increment',
                        style: TextStyle(
                          color: Colors.white,
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
    );
  }
}
