import 'package:app_dac_san/Page/trang_dac_san.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Page/trang_nguoi_dung.dart';

class ManHinhChinh extends StatefulWidget {
  const ManHinhChinh({
    super.key,
    required this.title,
    required this.auth,
  });
  final FirebaseAuth auth;
  final String title;

  @override
  State<ManHinhChinh> createState() => _ManHinhChinhState();
}

class _ManHinhChinhState extends State<ManHinhChinh> {
  Widget? page;
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.auth.currentUser == null) {
      context.go("/login");
    }

    page ??= const TrangDacSan();

    return Scaffold(
      appBar: AppBar(
        actions: [
          SizedBox(
            width: 200,
            child: TextField(
              controller: TextEditingController(),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color.fromRGBO(30, 144, 255, 1),
                  Color.fromRGBO(148, 0, 211, 1),
                ]),
          ),
        ),
      ),
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Đặc sản',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Người dùng',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: const Color.fromRGBO(148, 0, 211, 1),
        onTap: (value) {
          setState(() {
            switch (value) {
              case 0:
                page = const TrangDacSan();
                break;
              case 1:
                page = TrangNguoiDung();
                break;
            }
            selectedIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
