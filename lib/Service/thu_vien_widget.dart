import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

Future<dynamic> XacNhanThoat(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        titlePadding: const EdgeInsets.only(
          left: 25,
          top: 25,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        actionsPadding: const EdgeInsets.only(
          right: 15,
          bottom: 10,
        ),
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text("Xác nhận thoát"),
        content: const Text(
          "Bạn có muốn thoát khỏi ứng dụng không?",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Không")),
          TextButton(
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              child: const Text("Có")),
        ],
      );
    },
  );
}
