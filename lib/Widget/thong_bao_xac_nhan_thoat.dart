import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<dynamic> ThongBaoXacNhanThoat(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Theme.of(context).textTheme.titleLarge!.color,
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
                Navigator.pop(dialogContext);
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
