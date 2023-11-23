import 'package:async_builder/async_builder.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Service/thu_vien_api.dart';
import '../Service/thu_vien_widget.dart';
import '../main.dart';

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
  late Future<String> myFuture;
  @override
  void initState() {
    // TODO: implement initState
    myFuture = Future.delayed(
      const Duration(milliseconds: 100),
      () async {
        await getTinhThanh();
        await getHinhAnh();
        await getVungMien();
        await getDacSan();
        nguoiDung = (await getUser(FirebaseAuth.instance.currentUser!.email!))!;
        return "";
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder(
      future: myFuture,
      waiting: (context) => LoadingScreen(),
      builder: (context, value) => PopScope(
        onPopInvoked: (popped) {
          XacNhanThoat(context);
        },
        canPop: false,
        child: Scaffold(
          appBar: buildEasySearchBar(),
          body: widget.page,
          bottomNavigationBar: buildBottomNavigationBar(),
        ),
      ),
    );
  }

  EasySearchBar buildEasySearchBar() {
    return EasySearchBar(
      backgroundColor: const Color.fromARGB(255, 30, 144, 255),
      foregroundColor: Colors.white,
      titleTextStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      title: const Text('App đặc sản VN'),
      onSearch: (value) {},
      asyncSuggestions: (value) => getTenDacSanTheoTen(value),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: const Color.fromARGB(255, 30, 144, 255),
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
      selectedItemColor: Colors.white,
      onTap: (value) {
        setState(() {
          widget.page.goBranch(value);
          selectedIndex = value;
        });
      },
      type: BottomNavigationBarType.fixed,
    );
  }
}
