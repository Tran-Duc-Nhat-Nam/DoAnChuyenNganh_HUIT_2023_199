import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Widget LoadHinh(String duongDan) {
  if (kIsWeb) {
    return Image.network(duongDan);
  } else {
    return Image.asset(duongDan);
  }
}

Widget LoadingScreen() {
  return Scaffold(
    body: Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.cyanAccent,
        size: 100,
      ),
    ),
  );
}
