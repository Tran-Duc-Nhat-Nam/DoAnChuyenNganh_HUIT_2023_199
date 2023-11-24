import 'package:app_dac_san/Model/nguoi_dung.dart';
import 'package:app_dac_san/Service/thu_vien_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFieldNguoiDung(
                    controller: widget.uidController,
                    text: "Id người dùng",
                    isReadOnly: isReadOnly,
                  ),
                  TextFieldNguoiDung(
                    controller: widget.emailController,
                    text: "Email",
                    isReadOnly: isReadOnly,
                  ),
                  TextFieldNguoiDung(
                    controller: widget.hoTenController,
                    text: "Họ tên",
                    isReadOnly: isReadOnly,
                  ),
                  TextFieldNguoiDung(
                    controller: widget.diaChiController,
                    text: "Địa chỉ",
                    isReadOnly: isReadOnly,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: ListTile(
                          enabled: !isReadOnly,
                          title: const Text("Nam"),
                          leading: Radio(
                            value: true,
                            groupValue: isNam,
                            onChanged: (bool? value) {
                              setState(() {
                                isNam = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        child: ListTile(
                          enabled: !isReadOnly,
                          title: const Text("Nữ"),
                          leading: Radio(
                            value: false,
                            groupValue: isNam,
                            onChanged: (bool? value) {
                              setState(() {
                                isNam = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(35),
                        padding: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
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
                  ElevatedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(35),
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
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
                ],
              ),
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
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: TextFormField(
        readOnly: isReadOnly,
        controller: controller,
        decoration: RoundInputDecoration(text),
      ),
    );
  }
}
