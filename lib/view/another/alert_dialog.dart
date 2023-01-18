import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyAlertDialog extends StatelessWidget {
  String title, message;
  MyAlertDialog(this.title, this.message, {super.key});

  @override Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),  
    );
  }
}