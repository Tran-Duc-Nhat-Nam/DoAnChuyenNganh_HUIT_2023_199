import '../Page/trang_chu.dart';
import '../Page/trang_nguoi_dung.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ManHinhChinh extends StatefulWidget {
  const ManHinhChinh({
    super.key,
    required this.title,
    required this.notifyParent,
    required this.auth,
  });

  final Function() notifyParent;
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
    page ??= TrangChu(text: widget.auth.currentUser!.email!);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
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
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'User',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cancel),
            label: 'Placeholder',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: const Color.fromRGBO(148, 0, 211, 1),
        onTap: (value) {
          setState(() {
            switch (value) {
              case 0:
                page = TrangChu(text: widget.auth.currentUser!.email!);
                break;
              case 1:
                page = TrangNguoiDung(auth: widget.auth, notifyParent: widget.notifyParent,);
                break;
              case 2:
                page = const Placeholder();
                break;
            }
            selectedIndex = value;
          });
        },
      ),
    );
  }
}
