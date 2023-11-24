import 'dart:convert';

import 'package:app_dac_san/Model/hinh_anh.dart';
import 'package:app_dac_san/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../Model/vung_mien.dart';

class TrangChiTietDacSan extends StatefulWidget {
  final int maDS;
  const TrangChiTietDacSan({Key? key, required this.maDS}) : super(key: key);

  @override
  _TrangChiTietDacSanState createState() => _TrangChiTietDacSanState();
}

class _TrangChiTietDacSanState extends State<TrangChiTietDacSan> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(
                getURLImage(dsDacSan[widget.maDS - 1].avatar),
                width: 500.0, // Điều chỉnh kích thước ảnh theo ý của bạn
                height: 300,
                fit: BoxFit
                    .cover, // Có thể điều chỉnh để tùy chỉnh cách hình ảnh phù hợp trong Container
              ),
            ),
            const SizedBox(height: 5),
            Text(dsDacSan[widget.maDS - 1].tenDacSan ?? '',
                style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(255, 67, 168, 140),
                    fontSize: 35,
                    fontFamily: 'RobotoBlack')),
            const SizedBox(height: 5),
            Text(getMien(dsDacSan[widget.maDS - 1].idMien),
                style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(225, 104, 143, 187),
                    fontSize: 24,
                    fontFamily: 'ExtraBoldItalic')),
            const SizedBox(height: 28),
            const Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text('Nội dung',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          color: Color.fromARGB(225, 100, 167, 130),
                          fontSize: 28,
                          fontFamily: "RobotoBlack")),
                ),
              ],
            ),
            Card(
                color: const Color.fromARGB(255, 159, 205, 200),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(dsDacSan[widget.maDS - 1].moTa ?? '',
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'RobotoLight',
                          wordSpacing: 1.3,
                          letterSpacing: 1,
                          color: Colors.black,
                          fontWeight: FontWeight.w600)),
                )),
            const SizedBox(height: 5)
          ],
        ),
      ),
    );
  }

  Future<void> getHinhAnh() async {
    var reponse = await get(
        Uri.parse('https://cntt199.000webhostapp.com/getHinhAnh.php'));
    var result = json.decode(utf8.decode(reponse.bodyBytes));

    for (var document in result) {
      HinhAnh hinhAnh = HinhAnh.fromJson(document);
      dsHinhAnh.add(hinhAnh);
    }
    setState(() {});
  }

  Future<void> getVungMien() async {
    var reponse = await get(
        Uri.parse('https://cntt199.000webhostapp.com/getVungMien.php'));
    var result = json.decode(utf8.decode(reponse.bodyBytes));

    for (var document in result) {
      VungMien vungMien = VungMien.fromJson(document);
      dsVungMien.add(vungMien);
    }
    setState(() {});
  }

  String getURLImage(int? idImage) {
    //// cai nay dung duoc
    String url = 'http://www.clker.com/cliparts/2/l/m/p/B/b/error-md.png';
    int index = dsHinhAnh.indexWhere(
        (hinhAnh) => hinhAnh.idAnh.toString() == idImage.toString());
    if (index != -1) {
      return dsHinhAnh[index].link.toString();
    }
    return url;
  }

  String getMien(int? IdMien) {
    String name = '404';
    int index = dsVungMien.indexWhere((vungMien) => vungMien.idMien == IdMien);
    if (index != -1) {
      return dsVungMien[index].tenMien.toString();
    }
    return name;
  }
}
