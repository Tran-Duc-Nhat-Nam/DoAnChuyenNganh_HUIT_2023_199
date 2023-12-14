import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../Page/trang_chi_tiet_dac_san.dart';
import '../Page/trang_dac_san.dart';
import '../Page/trang_dac_san_theo_vung.dart';
import '../Page/trang_danh_sach_dac_san.dart';
import '../Page/trang_doi_mat_khau.dart';
import '../Page/trang_nguoi_dung.dart';
import '../Screen/man_hinh_chinh.dart';
import '../Screen/man_hinh_cho_xac_nhan.dart';
import '../Screen/man_hinh_dang_ky.dart';
import '../Screen/man_hinh_dang_nhap.dart';
import '../Screen/man_hinh_gioi_thieu.dart';
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
                return const TrangDacSan();
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
                  path: "vungmien/:id",
                  name: "Danh sách đặc sản theo vùng",
                  builder: (context, state) {
                    return TrangDacSanTheoVung(
                      maVung: int.parse(state.pathParameters['id']!),
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
          },
        ),
      ],
    ),
  ],
);
