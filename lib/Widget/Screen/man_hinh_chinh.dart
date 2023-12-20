import 'package:async_builder/async_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:vina_foods/Service/doc_nguoi_dung.dart';

import '../../Service/thu_vien_api.dart';
import '../../Widget/thong_bao_xac_nhan_thoat.dart';
import '../../main.dart';
import 'man_hinh_loading.dart';

class ManHinhChinh extends StatefulWidget {
  ManHinhChinh({
    super.key,
    required this.page,
  });
  final StatefulNavigationShell page;
  final TextEditingController controller = TextEditingController();

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
        await getDacSanNoiBat();
        nguoiDung =
            (await docNguoiDung(FirebaseAuth.instance.currentUser!.uid))!;
        return "";
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget page = widget.page;
    if (kIsWeb) {
      page = Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: widget.page,
        ),
      );
    }
    return AsyncBuilder(
      future: myFuture,
      waiting: (context) => const ManHinhLoading(),
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
      actions: [
        Flexible(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  context.go('/');
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: Image.asset("assets/images/logo_pho.png"),
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      left: 20,
                      right: 20,
                    ),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 400),
                      child: buildSearchAnchor(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  Widget buildSearchAnchor() {
    return TypeAheadField(
      builder: (context, controller, focusNode) {
        return TextField(
          style: const TextStyle(color: Colors.white),
          textAlignVertical: TextAlignVertical.center,
          controller: widget.controller,
          decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.white70),
                borderRadius: BorderRadius.all(
                  Radius.circular(35),
                ),
              ),
              focusColor: const Color.fromARGB(255, 65, 105, 225),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.white60),
                borderRadius: BorderRadius.all(
                  Radius.circular(35),
                ),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 0, 114, 225),
              contentPadding: const EdgeInsets.symmetric(horizontal: 25),
              suffixIcon: IconButton(
                onPressed: () {
                  if (widget.controller.text.isNotEmpty) {
                    context.goNamed(
                      "timKiem",
                      queryParameters: {"ten": widget.controller.text},
                    );
                  }
                },
                icon: const Icon(Icons.search_outlined),
              ),
              suffixIconColor: Colors.white),
          onSubmitted: (value) {
            context.goNamed(
              "timKiem",
              queryParameters: {"ten": value},
            );
          },
        );
      },
      decorationBuilder: (context, child) {
        return Material(
          borderRadius: BorderRadius.circular(15),
        );
      },
      suggestionsCallback: (String pattern) {
        print("Test");
        return dsDacSan
            .where((element) =>
                element.tenDacSan.toLowerCase().contains(pattern.toLowerCase()))
            .toList();
      },
      itemBuilder: (BuildContext context, item) {
        print("Test");
        return ListTile(
          title: Text(item.tenDacSan),
        );
      },
      onSelected: (item) {
        context.go("/dacsan/chitiet/${item.idDacSan}");
      },
      emptyBuilder: (context) {
        return const ListTile(
          title: Text("Không tìm thấy đặc sản"),
        );
      },
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
