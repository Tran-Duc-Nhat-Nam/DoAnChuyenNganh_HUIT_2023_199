import 'package:app_dac_san/Page/trang_chi_tiet_dac_san.dart';
import 'package:app_dac_san/Page/trang_dac_san.dart';
import 'package:app_dac_san/Page/trang_danh_sach_dac_san.dart';
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
final dacsanNavKey = GlobalKey<NavigatorState>();
final nguoiDungNavKey = GlobalKey<NavigatorState>();

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
          return const ManHinhGioiThieu();
        } else {
          return ManHinhDangNhap();
        }
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: dacsanNavKey,
          routes: [
            GoRoute(
              parentNavigatorKey: dacsanNavKey,
              path: '/dacsan',
              name: "Danh sách đặc sản",
              builder: (context, state) {
                return const TrangDacSan();
              },
              routes: [
                GoRoute(
                  path: "chitiet/:id",
                  builder: (context, state) {
                    return TrangChiTietDacSan(
                      maDS: int.parse(state.pathParameters['id']!),
                    );
                  },
                ),
                GoRoute(
                  path: "timkiem",
                  name: "timKiem",
                  builder: (context, state) {
                    int? xs = -1;

                    try {
                      xs = int.tryParse(state.pathParameters['xuatSu']!);
                    } catch (e) {
                      xs = null;
                    }

                    return TrangDanhSachDacSan(
                      ten: state.uri.queryParameters['ten'],
                      thanhPhan: state.uri.queryParameters['thanhPhan'],
                      xuatSu: xs,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: nguoiDungNavKey,
          routes: [
            GoRoute(
              parentNavigatorKey: nguoiDungNavKey,
              path: '/nguoidung',
              name: "Hồ sơ người dùng",
              builder: (context, state) {
                return TrangNguoiDung();
              },
            ),
          ],
        )
      ],
    ),
    GoRoute(
      path: "/",
      builder: (context, state) {
        if (ref.getBool("lanDau") == null) {
          return const ManHinhGioiThieu();
        } else {
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
