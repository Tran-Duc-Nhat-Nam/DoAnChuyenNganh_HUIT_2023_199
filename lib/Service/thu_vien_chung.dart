import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../Model/dac_san.dart';
import '../Model/hinh_anh.dart';
import '../Model/nguoi_dung.dart';
import '../Model/tinh_thanh.dart';
import '../Model/vung_mien.dart';
import '../main.dart';

void doiTenTab(String title, BuildContext context) {
  SystemChrome.setApplicationSwitcherDescription(ApplicationSwitcherDescription(
    label: "App đặc sản - $title",
    primaryColor: Theme.of(context).primaryColor.value, // This line is required
  ));
}

Widget loadHinh(String duongDan) {
  if (kIsWeb) {
    return Image.network(duongDan);
  } else {
    return Image.asset(duongDan);
  }
}

ButtonStyle RoundButtonStyle() {
  return ButtonStyle(
    textStyle: MaterialStateProperty.all(
      const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    padding: MaterialStateProperty.all(const EdgeInsets.only(
      top: 20,
      bottom: 20,
      left: 30,
      right: 30,
    )),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
    ),
  );
}

InputDecoration RoundInputDecoration(String text) {
  return InputDecoration(
    filled: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
    labelText: text,
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(35),
      ),
    ),
  );
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: Colors.cyanAccent,
          size: 100,
        ),
      ),
    );
  }
}

Future<void> addUser(
    String email, String hoTen, bool isNam, String diaChi) async {
  Map<String, dynamic> data = {
    'email': email,
    'hoten': hoTen,
    'gioitinh': isNam ? "Nam" : "Nữ",
    'diachi': diaChi,
  };

  var url = Uri.parse('https://cntt199.000webhostapp.com/registerUser.php');
  await post(url, body: data);
}

Future<NguoiDung?> getUser(String email) async {
  List<NguoiDung> dsNguoiDung = [];

  var reponse = await get(
      Uri.parse('https://cntt199.000webhostapp.com/getNguoiDung.php'));
  var result = json.decode(utf8.decode(reponse.bodyBytes));

  for (var document in result) {
    NguoiDung nguoiDung = NguoiDung.fromJson(document);
    dsNguoiDung.add(nguoiDung);
  }

  for (var nd in dsNguoiDung) {
    if (nd.email == email) {
      return nd;
    }
  }

  return null;
}

Future<void> getVungMien() async {
  var reponse =
      await get(Uri.parse('https://cntt199.000webhostapp.com/getVungMien.php'));
  var result = json.decode(utf8.decode(reponse.bodyBytes));

  for (var document in result) {
    VungMien vungMien = VungMien.fromJson(document);
    dsVungMien.add(vungMien);
  }
}

Future<void> getDacSan() async {
  var reponse =
      await get(Uri.parse('https://cntt199.000webhostapp.com/getDacSan.php'));
  var result = json.decode(utf8.decode(reponse.bodyBytes));

  for (var document in result) {
    DacSan dacSan = DacSan.fromJson(document);
    dsDacSan.add(dacSan);
  }
}

Future<void> getHinhAnh() async {
  var reponse =
      await get(Uri.parse('https://cntt199.000webhostapp.com/getHinhAnh.php'));
  var result = json.decode(utf8.decode(reponse.bodyBytes));

  for (var document in result) {
    HinhAnh hinhAnh = HinhAnh.fromJson(document);
    dsHinhAnh.add(hinhAnh);
  }
}

Future<void> getTinhThanh() async {
  var reponse = await get(
      Uri.parse('https://cntt199.000webhostapp.com/getTinhThanh.php'));
  var result = json.decode(utf8.decode(reponse.bodyBytes));

  for (var document in result) {
    TinhThanh tinhThanh = TinhThanh.fromJson(document);
    dsTinhThanh.add(tinhThanh);
  }
}
