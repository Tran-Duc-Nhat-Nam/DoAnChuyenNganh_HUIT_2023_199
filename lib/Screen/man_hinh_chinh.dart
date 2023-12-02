import 'package:async_builder/async_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Model/dac_san.dart';
import '../Service/thu_vien_api.dart';
import '../Service/thu_vien_widget.dart';
import '../Widget/thong_bao_xac_nhan_thoat.dart';
import '../main.dart';

class ManHinhChinh extends StatefulWidget {
  ManHinhChinh({
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
        await getLoaiDacSan();
        await getDacSan();
        await getDacSanVungMien();
        nguoiDung = (await getUser(FirebaseAuth.instance.currentUser!.uid))!;
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
          ThongBaoXacNhanThoat(context);
        },
        canPop: false,
        child: Scaffold(
          appBar: buildAppBar(),
          body: widget.page,
          bottomNavigationBar: buildBottomNavigationBar(),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 30, 144, 255),
      flexibleSpace: Container(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
      ),
      actions: [
        Flexible(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  context.go("/dacsan");
                },
                child: const Flexible(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Text(
                      "ADSVN",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildSearchAnchor(),
                ),
              ),
            ],
          ),
        ),
      ],
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  SearchAnchor buildSearchAnchor() {
    return SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
      return IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          setState(() {
            controller.openView();
          });
        },
      );
    }, suggestionsBuilder: (BuildContext context, SearchController controller) {
      List<DacSan> dsDacSanDaLoc = dsDacSan;
      if (controller.text.isNotEmpty) {
        dsDacSanDaLoc = getDanhSachDacSanTheoTen(controller.text);
      }
      return List<ListTile>.generate(dsDacSanDaLoc.length, (int index) {
        return ListTile(
          title: Text(dsDacSanDaLoc[index].tenDacSan!),
          onTap: () {
            setState(() {
              controller.closeView(dsDacSanDaLoc[index].tenDacSan!);
              context.go("/dacsan/chitiet/${dsDacSanDaLoc[index].idDacSan!}");
            });
          },
        );
      });
    });
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
      unselectedItemColor: Colors.white60,
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
