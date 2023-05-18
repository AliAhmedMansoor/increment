import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  Users({
    this.taskId = '',
    required this.task,
    required this.name,
  });

// Writing
  Map<String, dynamic> toJson() => {
        'name': name,
        'taskId': taskId,
        'task': task,
      };

// Reading
  static Users fromJson(Map<String, dynamic> json) => Users(
        name: json['name'],
        taskId: json['taskId'],
        task: json['task'],
      );
}

// Adding Tasks (Task Tile)
Widget buildUser(Users user) => Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 40, 46, 55),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: Text(
          user.task,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

class _TasksPageState extends State<TasksPage> {
  final controller = TextEditingController();

  // Reading Task
  Stream<List<Users>> readTask() {
    return FirebaseFirestore.instance
        .collection('users')
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
        color: Colors.red,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Column(
                  children: const [
                    Image(
                      image: NetworkImage(
                          'https://res.cloudinary.com/dw095oyal/image/upload/w_1000,h_1000,c_limit,q_auto/v1684174717/IMAGE_eoaowr.png'),
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: 400,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 28, 33, 41),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                child: StreamBuilder<List<Users>>(
                  stream: readTask(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      final users = snapshot.data!;
                      return users.isEmpty
                          ? const Center(
                              child: Text('No Tasks',
                                  style: TextStyle(color: Colors.white)))
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
                                        borderRadius: BorderRadius.circular(15),
                                        child: Container(
                                          color: Colors.red,
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
                                      child: buildUser(user),
                                    ),
                                  );
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
                            color: Colors.red,
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
                            color: Colors.red,
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
                      },
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                      child: Text(
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
