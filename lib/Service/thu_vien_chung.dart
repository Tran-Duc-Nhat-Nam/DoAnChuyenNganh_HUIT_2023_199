import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void doiTenTab(String title, BuildContext context) {
  SystemChrome.setApplicationSwitcherDescription(ApplicationSwitcherDescription(
    label: "App đặc sản - $title",
    primaryColor: Theme.of(context).primaryColor.value, // This line is required
  ));
}
