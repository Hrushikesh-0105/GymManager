import 'package:flutter/material.dart';
import 'package:gym_app/style.dart';

SnackBar customSnackBar(String message) {
  return SnackBar(
    content: Center(
      child: Text(
        message,
        style: style3().copyWith(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    duration: const Duration(seconds: 1, milliseconds: 500),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    backgroundColor: Colors.grey[700],
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(40),
    // width: 20,
  );
}
