import 'package:app_dac_san/Screen/man_hinh_chinh.dart';
import 'package:app_dac_san/Screen/man_hinh_dang_ky.dart';
import 'package:app_dac_san/Screen/man_hinh_dang_nhap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) {
        return ManHinhChinh(title: "Test", auth: FirebaseAuth.instance);
      },
    ),
    GoRoute(
        path: "/login",
        builder: (context, state) {
          return ManHinhDangNhap();
        },
        routes: [
          GoRoute(
            path: "signup",
            builder: (context, state) {
              return ManHinhDangKy();
            },
          ),
        ]),
  ],
);
