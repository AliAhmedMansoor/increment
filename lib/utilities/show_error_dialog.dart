// Error Box
import 'package:flutter/material.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text('Oops!',
                style: TextStyle(
                  color: Colors.white,
                )),
            backgroundColor: const Color.fromARGB(255, 37, 37, 37),
            content: Text(text,
                style: const TextStyle(
                  color: Colors.white,
                )),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
            ]);
      });
}
