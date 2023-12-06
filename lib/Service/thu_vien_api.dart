import 'dart:convert';

import 'package:http/http.dart';

import '../Model/dac_san.dart';
import '../Model/hinh_anh.dart';
import '../Model/loai_dac_san.dart';
import '../Model/nguoi_dung.dart';
import '../Model/tinh_thanh.dart';
import '../Model/vung_mien.dart';
import '../main.dart';

Future<void> addUser(
    String uid, String email, String hoTen, bool isNam, String diaChi) async {
  Map<String, dynamic> data = {
    'uid': uid,
    'email': email,
    'hoten': hoTen,
    'gioitinh': isNam ? "Nam" : "Nữ",
    'diachi': diaChi,
  };

  var url = Uri.parse('https://cntt199.000webhostapp.com/registerUser.php');
  await post(url, body: data);
}

Future<void> deleteUser(String uid) async {
  Map<String, dynamic> data = {
    'uid': uid,
  };

  var url = Uri.parse('https://cntt199.000webhostapp.com/deleteUser.php');
  await post(url, body: data);
}

Future<void> updateUser(
    String uid, String email, String hoTen, bool isNam, String diaChi) async {
  Map<String, dynamic> data = {
    'uid': uid,
    'email': email,
    'hoten': hoTen,
    'gioitinh': isNam ? "Nam" : "Nữ",
    'diachi': diaChi,
  };

  var url = Uri.parse('https://cntt199.000webhostapp.com/updateUser.php');
  await post(url, body: data);
}

Future<NguoiDung?> getUser(String uid) async {
  List<NguoiDung> dsNguoiDung = [];

  var reponse = await get(
      Uri.parse('https://cntt199.000webhostapp.com/getNguoiDung.php'));
  var result = json.decode(utf8.decode(reponse.bodyBytes));

  for (var document in result) {
    NguoiDung nguoiDung = NguoiDung.fromJson(document);
    dsNguoiDung.add(nguoiDung);
  }

  for (var nd in dsNguoiDung) {
    if (nd.uid == uid) {
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

Future<void> getLoaiDacSan() async {
  var reponse = await get(
      Uri.parse('https://cntt199.000webhostapp.com/getLoaiDacSan.php'));
  var result = json.decode(utf8.decode(reponse.bodyBytes));

  for (var document in result) {
    LoaiDacSan loaiDacSan = LoaiDacSan.fromJson(document);
    dsLoaiDacSan.add(loaiDacSan);
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

Future<void> getDacSanVungMien() async {
  dsDacSanMienBac = dsDacSan.where((dacSan) => dacSan.idMien == 1).toList();
  dsDacSanMienTrung = dsDacSan.where((dacSan) => dacSan.idMien == 2).toList();
  dsDacSanMienNam = dsDacSan.where((dacSan) => dacSan.idMien == 3).toList();
}

List<DacSan> getDanhSachDacSanTheoTen(String ten) {
  List<DacSan> kq = [];
  for (var dacSan in dsDacSan) {
    if (dacSan.tenDacSan!.toLowerCase().contains(ten.toLowerCase())) {
      kq.add(dacSan);
    }
  }

  return kq;
}

int? getDacSanTheoTen(String ten) {
  for (var dacSan in dsDacSan) {
    if (dacSan.tenDacSan! == ten) {
      return dacSan.idDacSan;
    }
  }

  return null;
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

String? getTenTinh(int? idTinh) {
  Iterable<TinhThanh> tt =
      dsTinhThanh.where((element) => element.maTT == idTinh);

  if (tt.isNotEmpty) {
    return tt.first.ten;
  } else {
    return "Không xác định";
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

String getURLImage(int? idImage) {
  String url = 'http://www.clker.com/cliparts/2/l/m/p/B/b/error-md.png';
  int index = dsHinhAnh
      .indexWhere((hinhAnh) => hinhAnh.idAnh.toString() == idImage.toString());
  if (index != -1) {
    return dsHinhAnh[index].link.toString();
  }
  return url;
}