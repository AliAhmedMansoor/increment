// // Error Box
// import 'package:flutter/material.dart';

// Future<void> showErrorDialog(
//   BuildContext context,
//   String text,
// ) {
//   return showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//             side: BorderSide(
//               color: Colors.white,
//             )),
//         title: const Text(
//           'Oops!',
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Color.fromARGB(255, 39, 22, 22),
//         content: Text(
//           text,
//           style: const TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text(
//               'OK',
//               style: TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }
