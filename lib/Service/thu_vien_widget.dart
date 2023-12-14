// ignore_for_file: non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../Service/thu_vien_api.dart';

Widget LoadHinh(String duongDan) {
  return Image.asset(duongDan);
}

Widget LoadingScreen() {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    body: Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.cyanAccent,
        size: 100,
      ),
    ),
  );
}

CachedNetworkImage cachedImage(int id) {
  return CachedNetworkImage(
    progressIndicatorBuilder: (context, url, downloadProgress) =>
        LinearProgressIndicator(value: downloadProgress.progress),
    errorWidget: (context, url, error) => const Icon(Icons.error),
    imageUrl: getURLImage(id),
    fit: BoxFit.cover,
    height: 150,
  );
}

SnackBar snackBarFirebaseAuth(FirebaseAuthException e) {
  String thongBao = "Lỗi không xác định";
  switch (e.code) {
    case "invalid-email":
      thongBao = "Định dạng email không hợp lệ.";
    case "invalid-password":
      thongBao = "Mật khẩu quá yếu (mật khẩu phải có từ 6 ký tự trở lên).";
    case "email-already-exists":
      thongBao = "Email đã được sử dụng bởi một tài khoản khác.";
    case "user-not-found":
      thongBao = "Tài khoản không tồn tại.";
    case "account-exists-with-different-credential":
      thongBao = "Tài khoản đã được đăng ký bằng một phương thức khác.";
  }
  return SnackBar(
    backgroundColor: Colors.blue,
    content: Text(
      thongBao,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
  );
}
