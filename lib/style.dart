// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

Color highlightColor = const Color.fromARGB(255, 15, 154, 173);
Color lightgreen = const Color.fromARGB(255, 106, 190, 167);
Color darkcyan = const Color.fromARGB(100, 106, 190, 167);
Color lightGrey = const Color.fromARGB(255, 120, 120, 120);

TextStyle headlineLarge() {
  return const TextStyle(
    color: Colors.white,
    fontFamily: "poppins",
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
}

TextStyle bodyMeduim() {
  return const TextStyle(
    color: Colors.white,
    fontFamily: "poppins",
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
}

TextStyle style1({Color textcolor = Colors.white, double fsize = 24}) {
  return TextStyle(fontSize: fsize, fontFamily: "poppins", color: textcolor);
}

TextStyle style2() {
  //for text box and hint text
  return const TextStyle(
      fontSize: 16, fontFamily: "poppins", color: Colors.white60);
}

TextStyle style3() {
  //for text box and hint text
  return const TextStyle(
      fontSize: 14, fontFamily: "poppins", color: Colors.white);
}

TextStyle style4() {
  //for text box and hint text
  return const TextStyle(
      fontSize: 20,
      fontFamily: "poppins",
      color: Colors.white,
      fontWeight: FontWeight.bold);
}

TextStyle radioButtonStyle() {
  //for text box and hint text
  return const TextStyle(
      fontSize: 20,
      fontFamily: "poppins",
      color: Colors.white60,
      fontWeight: FontWeight.bold);
}

InputDecoration textfieldstyle1(
    IconData prefixicon, String hinttext, Color outlineColor) {
  return InputDecoration(
    // contentPadding: EdgeInsets.symmetric(vertical: 5.0),
    labelText: hinttext,
    labelStyle: style2(),
    filled: true,
    fillColor: const Color.fromARGB(255, 35, 35, 35),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color.fromARGB(255, 15, 154, 173))),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: outlineColor)),
    prefixIcon: Icon(prefixicon,
        size: 26, color: const Color.fromARGB(255, 120, 120, 120)),
  );
}

InputDecoration textfieldstyle2(
    IconData prefixicon, String hinttext, Color outlineColor) {
  return InputDecoration(
    // contentPadding: EdgeInsets.symmetric(vertical: 5.0),
    labelText: hinttext,
    labelStyle: style2(),
    filled: true,
    fillColor: const Color.fromARGB(255, 35, 35, 35),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: Color.fromARGB(255, 120, 120, 120))),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: outlineColor)),
    prefixIcon: Icon(prefixicon,
        size: 26, color: const Color.fromARGB(255, 120, 120, 120)),
  );
}

BoxDecoration UpperCard() {
  return const BoxDecoration(
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10), topRight: Radius.circular(10)),
  );
}

BoxDecoration LowerCard(String status) {
  return BoxDecoration(
    borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
    // color: status == "Active"
    //     ? Color.fromARGB(255, 106, 190, 167)
    //     : Colors.red[600]);
    color: status == "Active" ? Colors.teal[600] : Colors.red,
  );
}

TextStyle CardTextBlue() {
  return TextStyle(color: Colors.blue[900], fontSize: 16);
}

TextStyle CardTextBlack() {
  return const TextStyle(color: Colors.black, fontSize: 16);
}

TextStyle CardTextgrey() {
  return const TextStyle(color: Colors.grey, fontSize: 16);
}

BoxDecoration bottomNavBarSelected() {
  return BoxDecoration(
      gradient: const LinearGradient(colors: [
        Color.fromARGB(255, 15, 154, 173),
        Color.fromARGB(255, 123, 214, 92),
        // Color.fromARGB(255, 101, 0, 252),
        // Color.fromARGB(255, 0, 242, 255),
      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      borderRadius: BorderRadius.circular(42));
}

BoxDecoration bottomNavBarNotSelected() {
  return BoxDecoration(borderRadius: BorderRadius.circular(42));
}

BoxDecoration saveButtonStyle() {
  return BoxDecoration(
      gradient: const LinearGradient(colors: [
        Color.fromARGB(255, 15, 154, 173),
        Color.fromARGB(255, 123, 214, 92)
      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      borderRadius: BorderRadius.circular(10));
}

LinearGradient activeGradient() {
  return LinearGradient(colors: [
    Color.fromARGB(255, 15, 154, 173),
    Color.fromARGB(255, 123, 214, 92)
  ]);
}

LinearGradient expiredGradient() {
  return LinearGradient(colors: [Colors.red, Colors.orange]);
}
