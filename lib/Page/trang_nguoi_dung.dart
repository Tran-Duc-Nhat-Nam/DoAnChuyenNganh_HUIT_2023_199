import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

class TrangNguoiDung extends StatefulWidget {
  TrangNguoiDung({
    super.key,
  });
  final TextEditingController emailController = TextEditingController();
  final TextEditingController hoTenController = TextEditingController();
  final TextEditingController diaChiController = TextEditingController();

  @override
  State<TrangNguoiDung> createState() => _TrangNguoiDungState();
}

class _TrangNguoiDungState extends State<TrangNguoiDung> {
  @override
  Widget build(BuildContext context) {
    widget.emailController.text = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      const Flexible(
                        flex: 1,
                        child: Text("ID người dùng:"),
                      ),
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(FirebaseAuth.instance.currentUser!.uid),
                        ),
                      ),
                    ],
                  ),
                ),
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
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    child: const Text("Đăng xuất"),
                    onPressed: () async {
                      await FirebaseAuth.instance
                          .signOut()
                          .whenComplete(() async {
                        await FacebookAuth.instance.logOut();
                        await GoogleSignIn().signOut().whenComplete(() {
                          if (context.mounted) {
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
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          labelText: text,
        ),
      ),
    );
  }
}
