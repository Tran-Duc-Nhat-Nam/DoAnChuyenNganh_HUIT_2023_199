import 'package:async_builder/async_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      waiting: (context) => Scaffold(
        body: Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.cyanAccent,
            size: 100,
          ),
        ),
      ),
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
                              focusColor:
                                  const Color.fromARGB(255, 65, 105, 225),
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
                                  onPressed: () {
                                    var routeList = GoRouter.of(context)
                                        .routerDelegate
                                        .currentConfiguration
                                        .matches;
                                    for (var route in routeList) {
                                      print(
                                          "Location: ${route.matchedLocation}");
                                      print("Page: ${route.pageKey}");
                                    }
                                  },
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
