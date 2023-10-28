import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class TrangNguoiDung extends StatefulWidget {
  TrangNguoiDung({
    super.key,
    required this.auth,
    required this.notifyParent,
  });

  final Function() notifyParent;
  final FirebaseAuth auth;
  final TextEditingController emailController = TextEditingController();

  @override
  State<TrangNguoiDung> createState() => _TrangNguoiDungState();
}

class _TrangNguoiDungState extends State<TrangNguoiDung> {
  @override
  Widget build(BuildContext context) {
    widget.emailController.text = widget.auth.currentUser!.uid;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: widget.emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    child: const Text("Đăng xuất"),
                    onPressed: () async {
                      await widget.auth.signOut().whenComplete(() async =>
                          await GoogleSignIn()
                              .signOut()
                              .whenComplete(() => widget.notifyParent()));
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
