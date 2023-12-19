import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
