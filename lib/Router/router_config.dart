import 'package:app_dac_san/Page/trang_dac_san.dart';
import 'package:app_dac_san/Page/trang_nguoi_dung.dart';
import 'package:app_dac_san/Screen/man_hinh_chinh.dart';
import 'package:app_dac_san/Screen/man_hinh_dang_ky.dart';
import 'package:app_dac_san/Screen/man_hinh_dang_nhap.dart';
import 'package:app_dac_san/Screen/man_hinh_gioi_thieu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';

final rootNavKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: "/",
  navigatorKey: rootNavKey,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, child) {
        if (FirebaseAuth.instance.currentUser != null) {
          return ManHinhChinh(
            page: child,
          );
        }

        if (ref.getBool("lanDau") == null || ref.getBool("LanDau")!) {
          print("Check");
          return const ManHinhGioiThieu();
        } else {
          print("No Check");
          return ManHinhDangNhap();
        }
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dacsan',
              name: "Danh sách đặc sản",
              builder: (context, state) {
                return const TrangDacSan();
              },
            ),
          ],
        ),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/nguoidung',
            name: "Hồ sơ người dùng",
            builder: (context, state) {
              return TrangNguoiDung();
            },
          ),
        ])
      ],
    ),
    GoRoute(
      path: "/",
      builder: (context, state) {
        if (ref.getBool("lanDau") == null) {
          print("Check");
          return const ManHinhGioiThieu();
        } else {
          print("No Check");
          return ManHinhDangNhap();
        }
      },
      redirect: (context, state) {
        if (FirebaseAuth.instance.currentUser != null) {
          return "/dacsan";
        }
        return null;
      },
      routes: [
        GoRoute(
          path: "signup",
          builder: (context, state) {
            return ManHinhDangKy();
          },
          redirect: (context, state) {
            if (FirebaseAuth.instance.currentUser != null) {
              return null;
            }
          },
        ),
      ],
    ),
  ],
);
