import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void doiTenTab(String title, BuildContext context) {
  SystemChrome.setApplicationSwitcherDescription(ApplicationSwitcherDescription(
    label: "App đặc sản - $title",
    primaryColor: Theme.of(context).primaryColor.value, // This line is required
  ));
}

Widget loadHinh(String duongDan) {
  if (kIsWeb) {
    return Image.network(duongDan);
  } else {
    return Image.asset(duongDan);
  }
}

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
        borderRadius: BorderRadius.circular(25.0),
      ),
    ),
  );
}

InputDecoration RoundInputDecoration(String text) {
  return InputDecoration(
    filled: true,
    fillColor: const Color.fromARGB(255, 16, 16, 16),
    contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
    labelText: text,
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(35),
      ),
    ),
  );
}
