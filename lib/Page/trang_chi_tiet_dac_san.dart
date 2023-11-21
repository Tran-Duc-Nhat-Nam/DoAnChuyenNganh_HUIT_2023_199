import 'package:flutter/material.dart';
import '../Model/dac_san.dart';
import 'dart:convert';
import 'package:http/http.dart';
import '../Model/vung_mien.dart';
import 'package:app_dac_san/Model/hinh_anh.dart';



class TrangChiTietDacSan extends StatefulWidget {
  final DacSan Dacsan;
  const TrangChiTietDacSan({Key? key, required this.Dacsan}) : super(key: key);

  @override
  _TrangChiTietDacSanState createState() => _TrangChiTietDacSanState();
}

class _TrangChiTietDacSanState extends State<TrangChiTietDacSan> {

  List<VungMien> dsVungMien = [];
  List<HinhAnh> dsHinhAnh = [];
  late DacSan dacSan;
  @override
  void initState() {
    super.initState();
    dacSan = widget.Dacsan;
    getHinhAnh();
    getVungMien();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView (
      child: Container(
        color: Color.fromARGB(225, 162, 235, 230),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.network(
                  getURLImage(dacSan.avatar),
                  width: 500.0, // Điều chỉnh kích thước ảnh theo ý của bạn
                  height: 300,
                  fit: BoxFit.cover, // Có thể điều chỉnh để tùy chỉnh cách hình ảnh phù hợp trong Container
                ),
              ),
              SizedBox(height: 5),
              Text(dacSan.tenDacSan ?? '',
                  style: const TextStyle(fontWeight: FontWeight.w900, color: Color.fromARGB(255,67, 168, 140), fontSize: 35, fontFamily: 'RobotoBlack')),
              SizedBox(height: 5),
              Text(getMien(dacSan.idMien),
                  style: const TextStyle(fontWeight: FontWeight.w900, color: Color.fromARGB(225, 104, 143, 187) , fontSize: 24, fontFamily: 'ExtraBoldItalic')),
              SizedBox(height: 28),
              const Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text('Nội dung',
                        style: TextStyle(fontWeight: FontWeight.w600,decoration: TextDecoration.underline, color: Color.fromARGB(225, 100, 167, 130), fontSize: 28, fontFamily: "RobotoBlack")),
                  ),

                ],
              ),
              Card(
                  color: const Color.fromARGB(255,159, 205, 200),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text( dacSan.moTa ?? '',
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'RobotoLight',
                          wordSpacing: 1.3,
                          letterSpacing: 1,
                          color: Colors.black,
                          fontWeight: FontWeight.w600
                        )
                    ),
                  )
              ),
              SizedBox(height: 5)
            ],
          ),
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

class DataTinhThanh{
  static String URLhinhAnh = 'https://scontent.fsgn4-1.fna.fbcdn.net/v/t39.30808-1/346478097_926319708595639_8803439708074758567_n.jpg?stp=dst-jpg_p240x240&_nc_cat=101&ccb=1-7&_nc_sid=5f2048&_nc_ohc=7PcUg2Hw8GkAX_Snl2x&_nc_ht=scontent.fsgn4-1.fna&oh=00_AfANj6ThqGX8z2Ut2IghcGyydM2dSBjEi0mWt41eAgD7EA&oe=655FC0C2';
  static String tenTinhThanh = 'Củ Chi, TP.HCM';
  static String noiDung = 'Phở là một món ăn truyền thống của Việt Nam có xuất xứ từ Vân Cù, Nam Định. Phở được xem là một trong những món ăn tiêu biểu cho nền ẩm thực Việt Nam.'
      'Thành phần chính của phở là bánh phở và nước dùng cùng với thịt bò hoặc thịt gà cắt lát mỏng. Thịt bò thích hợp nhất để nấu phở là thịt, xương từ các giống bò ta (bò nội, bò vàng). Ngoài ra còn kèm theo các gia vị như: tương, tiêu, chanh, nước mắm, ớt, vân vân. Những gia vị này được thêm vào tùy theo khẩu vị của người dùng.';
  static String tenMon = 'Phở';
}

