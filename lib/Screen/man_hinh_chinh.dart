import 'package:async_builder/async_builder.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../Service/thu_vien_chung.dart';
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
      const Duration(seconds: 1),
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
          showDialog(
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
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
                        SystemChannels.platform
                            .invokeMethod('SystemNavigator.pop');
                      },
                      child: const Text("Có")),
                ],
              );
            },
          );
        },
        canPop: false,
        child: Scaffold(
          appBar: EasySearchBar(
            backgroundColor: const Color.fromARGB(255, 30, 144, 255),
            foregroundColor: Colors.white,
            titleTextStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            title: const Text('App đặc sản VN'),
            onSearch: (value) {},
          ),
          body: widget.page,
          bottomNavigationBar: BottomNavigationBar(
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
          ),
        ),
      ),
    );
  }
}
