import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:incrementapp/themes/colours.dart';

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
  "\"Every action you take is a vote for the type of person you wish to become.\"\n― James Clear",
  "\"We are what we repeatedly do. Excellence, then, is not an act but a habit.\" ― Will Durant",
  "\"Your body will rust out long before you can wear it out.\"\n― A 79-year Old Ultra-Marathon Runner",
  "\"It is a shame for a man to grow old without seeing the beauty and strength of which his body is capable of.\"\n― Socrates",
  "\"Right now, you're living the past of your future self and the precise moment you ruin your life is right now.\" ― Anonymous",
  "\"Improvement goes hand in hand with dedication.\" ― Eliud Kipchoge",
  "\"Perfect is created through imperfect actions. The way you create something incredible is by first creating something not incredible.\" ― Andrew Kirby",
];

Random random = Random();

class _TasksPageState extends State<TasksPage> {
  final controller = TextEditingController();
  final confettiController = ConfettiController();
  bool hasConfettiPlayed = false;
  late  Timer myTimer;
  // For closing keyboard
  final FocusNode _focusNode = FocusNode();
  int tasksCount = 0;
  bool _isDelayCompleted = false;
  bool isTextFieldFocused = false;

  // Adding Tasks (Task Tile)
  Widget buildUser(Users user, Function() onChanged) =>
      Stack(alignment: Alignment.center, children: [
        Container(
          decoration: BoxDecoration(
            color: user.isChecked ? Colours.cardUnfocused : Colours.cardFocused,
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            trailing: Transform.scale(
              scale: 1.4,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Checkbox(
                  checkColor: Colours.checkBoxChecked,
                  fillColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colours.cardUnfocused; // When checkbox is checked
                    } else {
                      return Colours.mainIcon; // When checkbox is unchecked
                    }
                  }),
                  value: user.isChecked,
                  onChanged: (newValue) {
                    setState(
                      () {
                        user.toggleChecked();
                        if (user.isChecked && !hasConfettiPlayed) {
                          confettiController.play();
                          hasConfettiPlayed = true;
                          widget.updateAppBarText('Woohoo!');
                          // Start the timer for 2 seconds
                          Timer(
                            const Duration(seconds: 1),
                            () {
                              confettiController.stop();
                            },
                          );
                        }
                      },
                    );
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
            title: Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 3.0),
              child: Text(
                maxLines: user.isChecked ? 1 : null,
                user.task,
                style: user.isChecked
                    ? const TextStyle(
                        color: Colours.body,
                        decoration: TextDecoration.lineThrough,
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        overflow: TextOverflow.fade,
                        height: 1.5,
                      )
                    : const TextStyle(
                        color: Colours.mainText,
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        height: 1.5,
                      ),
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
    //Delay Timer

    myTimer=Timer(const Duration(milliseconds: 1500), () {
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
    // Floating Action Button
    _focusNode.addListener(() {
      setState(() {
        isTextFieldFocused = _focusNode.hasFocus;
      });
    });
  }

  String getRandomQuote() {
    return quotes[random.nextInt(quotes.length)];
  }

  @override
  void dispose() {
    confettiController.dispose();
    controller.dispose();
    //myTimer.cancel();
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
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colours.topFlexBackground1,
                    Colours.topFlexBackground2,
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
                            fontWeight: FontWeight.w500,
                            fontSize: 60,
                            color: Colours.counter,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colours.bottomFlexBackground,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: StreamBuilder<List<Users>>(
                        stream: readTask(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (_isDelayCompleted == false) {
                            return const Center(
                                child: CircularProgressIndicator(
                              color: Colours.navigationFocused,
                            ));
                          } else if (snapshot.hasData) {
                            final users = snapshot.data!;

                            return users.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          // Random Quotes
                                          selectedQuote,
                                          style: const TextStyle(
                                            height: 1.5,
                                            fontSize: 16,
                                            color: Colours.body,
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
                                              direction:
                                                  DismissDirection.endToStart,
                                              background: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colours.deleteGradient1,
                                                        Colours.deleteGradient2,
                                                      ],
                                                      begin:
                                                          Alignment.centerRight,
                                                      end: Alignment.centerLeft,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: const [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 16.0),
                                                        child: Icon(
                                                          Icons.delete,
                                                          color:
                                                              Colours.mainIcon,
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
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  ),

// Text Field For Adding Tasks
                  Container(
                    color: Colours.bottomFlexBackground,
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 17, bottom: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            focusNode: _focusNode,
                            controller: controller,
                            style: const TextStyle(color: Colours.mainText),
                            maxLength: 100,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            decoration: InputDecoration(
                              hintText: 'I want to...',
                              hintStyle: const TextStyle(color: Colours.body),
                              counterText: '',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 18),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                  color: Colours.unfocusedBorder,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                  color: Colours.floatingActionColour,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ),

// Increment Button
                        AnimatedOpacity(
                          opacity: isTextFieldFocused ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 150),
                          child: Visibility(
                            visible: isTextFieldFocused,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: SizedBox(
                                height: 48,
                                width: 110,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    final task = controller.text;
                                    createTask(task: task);
                                    controller.clear();
                                    _focusNode.unfocus();
                                  },
                                  backgroundColor: Colours.floatingActionColour,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 0,
                                  child: const Text(
                                    'increment',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colours.mainText,
                                    ),
                                  ),
                                ),
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
          ],
        ),
      ),
    );
  }
}
