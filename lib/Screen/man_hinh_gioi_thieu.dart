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
      showBackButton: true,
      next: const Text("Tiếp theo"),
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
          body:
              "Chào mừng bạn đã tới với VinaFoods - ứng dụng quảng bá đặc sản ẩm thực Việt Nam.",
          image: const Center(
            child: Icon(Icons.waving_hand, size: 64.0),
          ),
        ),
        PageViewModel(
          title: "Mục tiêu",
          body:
              "VinaFoods sẽ mang đến cho bạn thông tin về các món đặc sản ẩm thực của 63 tỉnh thành Việt Nam.",
          image: const Center(
            child: Icon(Icons.food_bank, size: 64.0),
          ),
        ),
        PageViewModel(
          title: "Đăng nhập",
          body:
              "Bây giờ bạn có thể bắt đầu sử dụng VinaFoods bằng cách đăng ký tài khoản mới hoặc đăng nhập nếu đã có tài khoản rồi.",
          image: const Center(
            child: Icon(Icons.login, size: 64.0),
          ),
        ),
      ],
    );
  }
}
