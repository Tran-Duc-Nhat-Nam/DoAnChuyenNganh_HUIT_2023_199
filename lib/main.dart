import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Screen/man_hinh_chinh.dart';
import 'Screen/man_hinh_dang_nhap.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDbOO5dKhoiF8kmDrnbigTKsTmj_8xSPDg",
          authDomain: "musicplayerz-63f2e.firebaseapp.com",
          databaseURL: "https://musicplayerz-63f2e-default-rtdb.asia-southeast1.firebasedatabase.app",
          projectId: "musicplayerz-63f2e",
          storageBucket: "musicplayerz-63f2e.appspot.com",
          messagingSenderId: "132894885676",
          appId: "1:132894885676:web:659f463a6d8ac6aa3ece89",
          measurementId: "G-ES189ZW8QH"
      )
  );

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  void notifyParent() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget;

    if (_auth.currentUser != null) {
      bodyWidget = ManHinhChinh(
        title: "App đặc sản",
        notifyParent: notifyParent,
        auth: _auth,
      );
    } else {
      bodyWidget = ManHinhDangNhap(
        notifyParent: notifyParent,
        auth: _auth,
      );
    }

    return MaterialApp(
      title: "App đặc sản",
      home: bodyWidget,
      debugShowCheckedModeBanner: false,
    );
  }
}