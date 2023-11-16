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
        backgroundColor: const Color.fromARGB(255, 148, 0, 211),
        actions: [
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Flexible(
                  flex: 1,
                  child: Text("Đặc sản VN"),
                ),
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextField(
                      controller: TextEditingController(),
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          suffixIcon: IconButton(
                              onPressed: () => widget.page.goBranch(1),
                              icon: const Icon(Icons.search_outlined))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
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
        selectedItemColor: Colors.purpleAccent,
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
