import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../Widget/Page/trang_chi_tiet_dac_san.dart';
import '../Widget/Page/trang_dac_san.dart';
import '../Widget/Page/trang_danh_sach_dac_san.dart';
import '../Widget/Page/trang_doi_mat_khau.dart';
import '../Widget/Page/trang_nguoi_dung.dart';
import '../Widget/Screen/man_hinh_chinh.dart';
import '../Widget/Screen/man_hinh_cho_xac_nhan.dart';
import '../Widget/Screen/man_hinh_dang_ky.dart';
import '../Widget/Screen/man_hinh_dang_nhap.dart';
import '../Widget/Screen/man_hinh_gioi_thieu.dart';
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
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          if (user.emailVerified) {
            return ManHinhChinh(
              page: child,
            );
          } else {
            return ManHinhChoXacNhan(user: user);
          }
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
                return TrangDacSan();
              },
              routes: [
                GoRoute(
                  path: "chitiet/:id",
                  name: "Chi tiết đặc sản",
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
                      xs = int.tryParse(state.uri.queryParameters['xuatSu']!);
                    } catch (e) {
                      xs = null;
                    }

                    int? vm = -1;

                    try {
                      vm = int.tryParse(state.uri.queryParameters['vungMien']!);
                    } catch (e) {
                      vm = null;
                    }

                    bool? noiBat = false;

                    try {
                      noiBat =
                          bool.tryParse(state.uri.queryParameters['noiBat']!);
                    } catch (e) {
                      noiBat = null;
                    }

                    return TrangDanhSachDacSan(
                      ten: state.uri.queryParameters['ten'],
                      thanhPhan: state.uri.queryParameters['thanhPhan'],
                      xuatSu: xs,
                      vungMien: vm,
                      noiBat: noiBat,
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
            GoRoute(
              path: "/doimatkhau/:id",
              builder: (context, state) {
                return TrangDoiMatKhau(
                  uid: state.pathParameters['id'],
                );
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
            return null;
          },
        ),
      ],
    ),
  ],
);
