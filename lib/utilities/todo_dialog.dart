// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

// class TodoDialog extends StatelessWidget {
//   final controller;
//   final onSave;

//   const TodoDialog({
//     super.key,
//     required this.controller,
//     required this.onSave,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       backgroundColor: Colors.pink,
//       content: Container(
//           height: 120,
//           child: Column(children: [
//             // Get User Input
//             TextField(
//               controller: controller,
//             ),

//             // Save and Cancel Button
//             Row(
//               children: [
//                 MaterialButton(
//                   onPressed: onSave,
//                   child: const Text('Add Task'),
//                 )
//               ],
//             )
//           ])),
//     );
//   }
// }
