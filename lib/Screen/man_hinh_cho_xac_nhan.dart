import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
              LoadingAnimationWidget.discreteCircle(
                  color: Colors.cyan, size: 100),
            ],
          ),
        ),
      ),
    );
  }
}
