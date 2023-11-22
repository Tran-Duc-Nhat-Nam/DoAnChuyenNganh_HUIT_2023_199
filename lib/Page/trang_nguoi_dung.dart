import 'package:app_dac_san/Model/nguoi_dung.dart';
import 'package:app_dac_san/Service/thu_vien_chung.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  @override
  Widget build(BuildContext context) {
    widget.uidController.text = FirebaseAuth.instance.currentUser!.uid;
    widget.emailController.text = nguoiDung.email;
    widget.hoTenController.text = nguoiDung.hoTen;
    widget.diaChiController.text = nguoiDung.diaChi!;

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFieldNguoiDung(
                    controller: widget.uidController, text: "Id người dùng"),
                TextFieldNguoiDung(
                  controller: widget.emailController,
                  text: "Email",
                ),
                TextFieldNguoiDung(
                  controller: widget.hoTenController,
                  text: "Họ tên",
                ),
                TextFieldNguoiDung(
                  controller: widget.diaChiController,
                  text: "Địa chỉ",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: ElevatedButton(
                    child: const Text("Đăng xuất"),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(35),
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      side: const BorderSide(
                          width: 1, color: Colors.lightBlueAccent),
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
                  ),
                )
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
