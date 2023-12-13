import 'package:flutter/material.dart';

ButtonStyle RoundButtonStyle() {
  return ButtonStyle(
    textStyle: MaterialStateProperty.all(
      const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    padding: MaterialStateProperty.all(const EdgeInsets.only(
      top: 20,
      bottom: 20,
      left: 30,
      right: 30,
    )),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
  );
}

InputDecoration RoundInputDecoration(String text) {
  return InputDecoration(
    filled: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
    labelText: text,
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(35),
      ),
    ),
  );
}
