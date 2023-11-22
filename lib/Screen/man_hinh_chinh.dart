import 'package:async_builder/async_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
      Duration(seconds: 1),
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
      waiting: (context) => Scaffold(
        body: Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.cyanAccent,
            size: 100,
          ),
        ),
      ),
      builder: (context, value) => Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 30, 144, 255),
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
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.white60),
                              borderRadius: BorderRadius.all(
                                Radius.circular(35),
                              ),
                            ),
                            focusColor: const Color.fromARGB(255, 65, 105, 225),
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.white60),
                              borderRadius: BorderRadius.all(
                                Radius.circular(35),
                              ),
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 0, 114, 225),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 12),
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
          selectedItemColor: const Color.fromARGB(255, 30, 144, 255),
          onTap: (value) {
            setState(() {
              widget.page.goBranch(value);
              selectedIndex = value;
            });
          },
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
