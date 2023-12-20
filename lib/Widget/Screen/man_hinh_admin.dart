import 'package:async_builder/async_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vina_foods/Service/dich_vu_nguoi_dung.dart';
import 'package:vina_foods/main.dart';

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
        dsNguoiDung = await docDanhSachNguoiDung();
        nguoiDung =
            (await docNguoiDung(FirebaseAuth.instance.currentUser!.uid))!;
        return "";
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                constraints: BoxConstraints(maxWidth: 150),
                color: Colors.blueAccent,
                child: Column(
                  children: [
                    ListTile(
                      title: Text("Đặc sản"),
                      onTap: () {
                        setState(() {
                          widget.page.goBranch(0);
                          selectedIndex = 0;
                        });
                      },
                    ),
                    ListTile(
                      title: Text("Người dùng"),
                      onTap: () {
                        setState(() {
                          widget.page.goBranch(1);
                          selectedIndex = 1;
                        });
                      },
                    ),
                  ],
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
