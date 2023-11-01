import 'package:app_dac_san/Screen/man_hinh_xem_web.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TrangBaiViet extends StatefulWidget {
  const TrangBaiViet({super.key});

  @override
  _TrangBaiVietState createState() => _TrangBaiVietState();
}

class _TrangBaiVietState extends State<TrangBaiViet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManHinhXemWeb(
                      controller: WebViewController(),
                      url: "https://www.google.com",
                    ),
                  ),
                );
              },
              child: const Text("Xem web"),
            ),
          ],
        ),
      ),
    );
  }
}
