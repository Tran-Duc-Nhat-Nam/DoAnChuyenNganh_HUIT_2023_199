import 'package:app_dac_san/Model/nguoi_dung.dart';
import 'package:app_dac_san/Service/thu_vien_api.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Model/tinh_thanh.dart';
import '../Service/thu_vien_style.dart';
import '../Widget/thong_bao_xac_nhan_thoat.dart';
import '../main.dart';

class TrangNguoiDung extends StatefulWidget {
  TrangNguoiDung({
    super.key,
  });
  NguoiDung? nguoiDung;
  final TextEditingController uidController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController hoTenController = TextEditingController();
  final TextEditingController diaChiController = TextEditingController();

  @override
  State<TrangNguoiDung> createState() => _TrangNguoiDungState();
}

class _TrangNguoiDungState extends State<TrangNguoiDung> {
  bool isReadOnly = true;
  String updateText = "Cập nhật thông tin";
  bool isNam = true;

  @override
  void initState() {
    widget.uidController.text = FirebaseAuth.instance.currentUser!.uid;
    widget.emailController.text = nguoiDung.email;
    widget.hoTenController.text = nguoiDung.hoTen;
    widget.diaChiController.text = nguoiDung.diaChi!;
    isNam = nguoiDung.gioiTinh == "Nam";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (popped) {
        ThongBaoXacNhanThoat(context);
      },
      canPop: false,
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            child: Column(
              children: [
                ListTile(
                  shape: LinearBorder.bottom(
                    side: const BorderSide(
                      color: Color.fromARGB(155, 211, 211, 211),
                    ),
                  ),
                  title: const Text(
                    "Thông tin người dùng",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                TextFieldNguoiDung(
                  controller: widget.uidController,
                  text: "Id người dùng",
                  isReadOnly: true,
                ),
                TextFieldNguoiDung(
                  controller: widget.emailController,
                  text: "Email",
                  isReadOnly: true,
                ),
                TextFieldNguoiDung(
                  controller: widget.hoTenController,
                  text: "Họ tên",
                  isReadOnly: isReadOnly,
                ),
                ListTile(
                  shape: LinearBorder.bottom(
                    side: const BorderSide(
                      color: Color.fromARGB(155, 211, 211, 211),
                    ),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: DropdownSearch<TinhThanh>(
                      enabled: !isReadOnly,
                      popupProps: const PopupProps.menu(
                        title: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: Text(
                              "Danh sách tỉnh thành",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        showSelectedItems: true,
                      ),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          contentPadding: const EdgeInsetsDirectional.only(
                            start: 25,
                            top: 15,
                            bottom: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                        ),
                      ),
                      compareFn: (item1, item2) {
                        return item1 == item2;
                      },
                      onChanged: (value) {
                        if (value != null) {
                          widget.diaChiController.text = value.ten!;
                        }
                      },
                      selectedItem: dsTinhThanh[0],
                      items: dsTinhThanh,
                      itemAsString: (value) {
                        return value.ten!;
                      },
                    ),
                  ),
                ),
                ListTile(
                  shape: LinearBorder.bottom(
                    side: const BorderSide(
                      color: Color.fromARGB(155, 211, 211, 211),
                    ),
                  ),
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: ListTile(
                          title: const Text("Nam"),
                          leading: Radio(
                            value: true,
                            groupValue: isNam,
                            onChanged: isReadOnly
                                ? null
                                : (bool? value) {
                                    setState(() {
                                      isNam = value!;
                                    });
                                  },
                          ),
                        ),
                      ),
                      Flexible(
                        child: ListTile(
                          title: const Text("Nữ"),
                          leading: Radio(
                            value: false,
                            groupValue: isNam,
                            onChanged: isReadOnly
                                ? null
                                : (bool? value) {
                                    setState(() {
                                      isNam = value!;
                                    });
                                  },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 25,
                    bottom: 15,
                    left: 25,
                    right: 25,
                  ),
                  child: ElevatedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(35),
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      side: const BorderSide(
                          width: 1, color: Colors.lightBlueAccent),
                    ),
                    onPressed: () {
                      setState(() {
                        if (isReadOnly) {
                          isReadOnly = false;
                          updateText = "Lưu thông tin";
                        } else {
                          isReadOnly = true;
                          updateUser(
                            widget.uidController.text,
                            widget.emailController.text,
                            widget.hoTenController.text,
                            isNam,
                            widget.diaChiController.text,
                          );
                          updateText = "Cập nhật thông tin";
                        }
                      });
                    },
                    child: Text(updateText),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 15,
                    left: 25,
                    right: 25,
                  ),
                  child: ElevatedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(35),
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      side: const BorderSide(
                          width: 1, color: Colors.lightBlueAccent),
                    ),
                    onPressed: !isReadOnly
                        ? null
                        : () {
                            context.go(
                                "/doimatkhau/${FirebaseAuth.instance.currentUser!.uid}");
                          },
                    child: const Text("Cập nhật mât khẩu"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                  ),
                  child: ElevatedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(35),
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      side: const BorderSide(width: 1, color: Colors.redAccent),
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance
                          .signOut()
                          .whenComplete(() async {
                        await FacebookAuth.instance.logOut();
                        await GoogleSignIn().signOut().whenComplete(() {
                          if (context.mounted) {
                            dsDacSan.clear();
                            dsHinhAnh.clear();
                            dsTinhThanh.clear();
                            dsVungMien.clear();
                            context.go("/");
                          }
                        });
                      });
                    },
                    child: const Text("Đăng xuất"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldNguoiDung extends StatelessWidget {
  const TextFieldNguoiDung({
    super.key,
    required this.controller,
    required this.text,
    this.isReadOnly = true,
  });

  final TextEditingController controller;
  final String text;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: TextFormField(
          readOnly: isReadOnly,
          controller: controller,
          decoration: RoundInputDecoration(text),
        ),
      ),
      shape: LinearBorder.bottom(
        side: const BorderSide(
          color: Color.fromARGB(155, 211, 211, 211),
        ),
      ),
    );
  }
}
