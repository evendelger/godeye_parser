import 'package:flutter/material.dart';

// TODO: доделать вид
SnackBar messageSnackbar = SnackBar(
  duration: const Duration(seconds: 2),
  backgroundColor: Colors.transparent,
  elevation: 0,
  content: Align(
    alignment: Alignment.bottomLeft,
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromARGB(255, 0, 0, 0),
      ),
      child: Text(
        'Message',
        style: TextStyle(
          fontSize: 50,
        ),
      ),
    ),
  ),
);
