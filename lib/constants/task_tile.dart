import 'package:flutter/material.dart';

class TaskTile extends StatefulWidget {
  final String taskTitle;
  const TaskTile({Key? key, required this.taskTitle}) : super(key: key);

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool isGreen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
      height: isGreen ? 15 : null,
      decoration: BoxDecoration(
        color: isGreen ? Colors.green : const Color.fromARGB(255, 60, 60, 60),
        borderRadius:
            isGreen ? BorderRadius.circular(12) : BorderRadius.circular(20),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isGreen = !isGreen;
          });
        },
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          tileColor: const Color.fromARGB(255, 52, 52, 52),
          title: Text(
            isGreen ? '' : widget.taskTitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: isGreen ? 0 : 1.4,
            ),
          ),
        ),
      ),
    );
  }
}
