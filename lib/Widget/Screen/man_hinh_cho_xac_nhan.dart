// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ManHinhChoXacNhan extends StatefulWidget {
  const ManHinhChoXacNhan({
    super.key,
    required this.user,
  });
  final User user;
  @override
  _ManHinhChoXacNhanState createState() => _ManHinhChoXacNhanState();
}

class _ManHinhChoXacNhanState extends State<ManHinhChoXacNhan> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      FirebaseAuth.instance.currentUser!.reload();
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        if (context.mounted) {
          context.go("/");
        }
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Vui lòng xác nhận email để đăng nhập vào ứng dụng",
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 35,
                ),
                child: LoadingAnimationWidget.discreteCircle(
                    color: Colors.cyan, size: 100),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
                  minimumSize:
                      MaterialStateProperty.all(const Size.fromHeight(25)),
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  padding: MaterialStateProperty.all(const EdgeInsets.only(
                    top: 15,
                    bottom: 15,
                    left: 35,
                    right: 35,
                  )),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                onPressed: () {
                  FirebaseAuth.instance.currentUser!.sendEmailVerification();
                },
                child: const Text("Gửi lại thư xác nhận"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.lightBlue),
                    minimumSize:
                        MaterialStateProperty.all(const Size.fromHeight(25)),
                    textStyle: MaterialStateProperty.all(
                      const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    padding: MaterialStateProperty.all(const EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                      left: 35,
                      right: 35,
                    )),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance
                        .signOut()
                        .whenComplete(() async {
                      await FacebookAuth.instance.logOut();
                      await GoogleSignIn().signOut();
                    });
                    if (context.mounted) {
                      context.go("/");
                    }
                  },
                  child: const Text("Trở lại trang đăng nhập"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
