import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../main.dart';

class ManHinhGioiThieu extends StatefulWidget {
  const ManHinhGioiThieu({super.key});

  @override
  _ManHinhGioiThieuState createState() => _ManHinhGioiThieuState();
}

class _ManHinhGioiThieuState extends State<ManHinhGioiThieu> {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      back: const Text("Quay lại"),
      next: const Text("Tiếp theo"),
      skip: const Text("Bỏ qua"),
      done: const Text("Hoàn tất"),
      onDone: () async {
        await ref.setBool("lanDau", false);
        if (context.mounted) {
          context.go("/");
        }
      },
      pages: [
        PageViewModel(
          title: "Chào mừng",
          body: "Chào mừng bạn đã tới với App đặc sản VN.",
          image: const Center(
            child: Icon(Icons.waving_hand, size: 64.0),
          ),
        ),
        PageViewModel(
          title: "Mục tiêu",
          body:
              "App đặc sản VN sẽ mang đến cho bạn thông tin đặc sản của 63 tỉnh thành Việt Nam.",
          image: const Center(
            child: Icon(Icons.food_bank, size: 64.0),
          ),
        ),
        PageViewModel(
          title: "Đăng nhập",
          body:
              "Bây giờ bạn có thể bắt đầu sử dụng bằng cách đăng ký tài khoản mới hoặc đăng nhập vào ứng dụng.",
          image: const Center(
            child: Icon(Icons.login, size: 64.0),
          ),
        ),
      ],
    );
  }
}
