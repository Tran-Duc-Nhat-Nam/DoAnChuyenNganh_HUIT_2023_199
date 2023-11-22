import 'package:app_dac_san/Router/router_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Model/dac_san.dart';
import 'Model/hinh_anh.dart';
import 'Model/nguoi_dung.dart';
import 'Model/tinh_thanh.dart';
import 'Model/vung_mien.dart';

late final SharedPreferences ref;
List<VungMien> dsVungMien = [];
List<HinhAnh> dsHinhAnh = [];
List<TinhThanh> dsTinhThanh = [];
List<DacSan> dsDacSan = [];
late NguoiDung nguoiDung;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDbOO5dKhoiF8kmDrnbigTKsTmj_8xSPDg",
          authDomain: "musicplayerz-63f2e.firebaseapp.com",
          databaseURL:
              "https://musicplayerz-63f2e-default-rtdb.asia-southeast1.firebasedatabase.app",
          projectId: "musicplayerz-63f2e",
          storageBucket: "musicplayerz-63f2e.appspot.com",
          messagingSenderId: "132894885676",
          appId: "1:132894885676:web:659f463a6d8ac6aa3ece89",
          measurementId: "G-ES189ZW8QH"));

  ref = await SharedPreferences.getInstance();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    Widget bodyWidget;
    return MaterialApp.router(
      title: "App đặc sản",
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 30, 144, 255),
            background: Colors.black,
            brightness: Brightness.dark),
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          // ···
          titleLarge: GoogleFonts.robotoFlex(
            fontSize: 30,
            color: Colors.white,
          ),
          bodyMedium: GoogleFonts.robotoFlex(
            color: Colors.white,
          ),
          displaySmall: GoogleFonts.robotoFlex(
            color: Colors.white,
          ),
        ),
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 30, 144, 255),
            background: Colors.white),
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          // ···
          titleLarge: GoogleFonts.robotoFlex(
            fontSize: 30,
            color: Colors.black,
          ),
          bodyMedium: GoogleFonts.robotoFlex(
            color: Colors.black,
          ),
          displaySmall: GoogleFonts.robotoFlex(
            color: Colors.black,
          ),
        ),
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
