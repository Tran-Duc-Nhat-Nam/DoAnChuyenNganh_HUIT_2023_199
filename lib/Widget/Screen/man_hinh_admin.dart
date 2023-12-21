import 'package:async_builder/async_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vina_foods/main.dart';

import '../../Model/nguoi_dung.dart';
import '../../Service/thu_vien_api.dart';
import '../thong_bao_xac_nhan_thoat.dart';
import 'man_hinh_loading.dart';

class ManHinhAdmin extends StatefulWidget {
  const ManHinhAdmin({
    super.key,
    required this.page,
  });
  final StatefulNavigationShell page;
  @override
  _ManHinhAdminState createState() => _ManHinhAdminState();
}

class _ManHinhAdminState extends State<ManHinhAdmin> {
  int selectedIndex = 0;
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
        dsNguoiDung = await NguoiDung.docDanhSachNguoiDung();
        nguoiDung = (await NguoiDung.docNguoiDung(
            FirebaseAuth.instance.currentUser!.uid))!;
        return "";
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> dsSidebar = [
      "Đặc sản",
      "Loại đặc sản",
      "Xuất sứ",
      "Vùng miền",
      "Người dùng",
    ];
    return AsyncBuilder(
      future: myFuture,
      waiting: (context) => const ManHinhLoading(),
      builder: (context, value) => PopScope(
        onPopInvoked: (popped) {
          ThongBaoXacNhanThoat(context);
        },
        canPop: false,
        child: Scaffold(
          body: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 150),
                color: const Color.fromARGB(255, 0, 114, 225),
                child: Column(
                  children: dsSidebar
                      .map((e) => ListTile(
                            title: Text(
                              e,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            shape: LinearBorder.bottom(
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                widget.page.goBranch(dsSidebar.indexOf(e));
                                selectedIndex = dsSidebar.indexOf(e);
                              });
                            },
                          ))
                      .toList(),
                ),
              ),
              Flexible(flex: 9, child: widget.page),
            ],
          ),
        ),
      ),
    );
  }
}
