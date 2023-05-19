// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';

// class TodoTile extends StatelessWidget {
//   final String taskName;
//   final bool taskCompleted;
//   Function(bool?)? onChanged;

//   Function(BuildContext)? deleteFunction;

//   // Constructor
//   TodoTile({
//     super.key,
//     required this.taskName,
//     required this.taskCompleted,
//     required this.onChanged,
//     required this.deleteFunction,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Slidable(
//         endActionPane: ActionPane(
//           motion: const StretchMotion(),
//           children: [
//             SlidableAction(
//               onPressed: deleteFunction,
//               icon: Icons.delete,
//               backgroundColor: Colors.red,
//               borderRadius: BorderRadius.circular(12),
//             )
//           ],
//         ),
//         child: Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: Colors.grey,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Row(
//             children: [
//               // Checkbox
//               Transform.scale(
//                 scale: 1.15,
//                 child: Checkbox(
//                   value: taskCompleted,
//                   onChanged: onChanged,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(6)),
//                   visualDensity: VisualDensity.adaptivePlatformDensity,
//                   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                 ),
//               ),
//               // Task Name
//               Text(taskName,
//                   style: TextStyle(
//                       decoration: taskCompleted
//                           ? TextDecoration.lineThrough
//                           : TextDecoration.none)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
