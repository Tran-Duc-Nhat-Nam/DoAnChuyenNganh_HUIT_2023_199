import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:vina_foods/Widget/Page/trang_quan_ly_dac_san.dart';
import 'package:vina_foods/Widget/Page/trang_quan_ly_hinh_anh.dart';
import 'package:vina_foods/Widget/Page/trang_quan_ly_loai_dac_san.dart';
import 'package:vina_foods/Widget/Page/trang_quan_ly_nguoi_dung.dart';
import 'package:vina_foods/Widget/Page/trang_quan_ly_tinh_thanh.dart';
import 'package:vina_foods/Widget/Screen/man_hinh_admin.dart';

import '../Widget/Page/trang_chi_tiet_dac_san.dart';
import '../Widget/Page/trang_dac_san.dart';
import '../Widget/Page/trang_danh_sach_dac_san.dart';
import '../Widget/Page/trang_doi_mat_khau.dart';
import '../Widget/Page/trang_nguoi_dung.dart';
import '../Widget/Page/trang_quan_ly_vung_mien.dart';
import '../Widget/Screen/man_hinh_chinh.dart';
import '../Widget/Screen/man_hinh_cho_xac_nhan.dart';
import '../Widget/Screen/man_hinh_dang_ky.dart';
import '../Widget/Screen/man_hinh_dang_nhap.dart';
import '../Widget/Screen/man_hinh_gioi_thieu.dart';
import '../main.dart';

final rootNavKey = GlobalKey<NavigatorState>();
final dacsanNavKey = GlobalKey<NavigatorState>();
final nguoiDungNavKey = GlobalKey<NavigatorState>();
final quanLyNavKey = GlobalKey<NavigatorState>();

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
                      maDS: state.pathParameters['id']!,
                    );
                  },
                  redirect: (context, state) {
                    if (state.pathParameters['id'] != null) {
                      return "/dacsan/chitiet/${state.pathParameters['id']}";
                    }
                    return null;
                  },
                ),
                GoRoute(
                  path: "timkiem",
                  name: "timKiem",
                  builder: (context, state) {
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
                      xuatSu: state.uri.queryParameters['xuatSu'],
                      vungMien: state.uri.queryParameters['vungMien'],
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
            return "signup";
          },
        ),
      ],
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, child) {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          return ManHinhAdmin(
            page: child,
          );
        }
        return ManHinhDangNhap();
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/admin/dacsan',
              name: "Quản lý đặc sản",
              builder: (context, state) {
                return const TrangQuanLyDacSan();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/admin/loaidacsan',
              name: "Quản lý loại đặc sản",
              builder: (context, state) {
                return TrangQuanLyLoaiDacSan();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/admin/xuatsu',
              name: "Quản lý xuất sứ",
              builder: (context, state) {
                return const TrangQuanLyTinhThanh();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/admin/vungmien',
              name: "Quản lý vùng miền",
              builder: (context, state) {
                return const TrangQuanLyVungMien();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/admin/hinhanh',
              name: "Quản lý hình đặc sản",
              builder: (context, state) {
                return const TrangQuanLyHinhAnh();
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/admin/nguoidung',
              name: "Quản lý người dùng",
              builder: (context, state) {
                return const TrangQuanLyNguoiDung();
              },
            ),
          ],
        )
      ],
    ),
  ],
);
