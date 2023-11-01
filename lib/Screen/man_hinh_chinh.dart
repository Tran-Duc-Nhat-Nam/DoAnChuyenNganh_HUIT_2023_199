import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ManHinhChinh extends StatefulWidget {
  const ManHinhChinh({
    super.key,
    required this.page,
  });
  final StatefulNavigationShell page;
  @override
  State<ManHinhChinh> createState() => _ManHinhChinhState();
}

class _ManHinhChinhState extends State<ManHinhChinh> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
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
      body: widget.page,
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
            widget.page.goBranch(value);
            selectedIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
