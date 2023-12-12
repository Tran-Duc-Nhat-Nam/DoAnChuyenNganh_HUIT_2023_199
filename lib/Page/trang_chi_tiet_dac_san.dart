// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:app_dac_san/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';

import '../Model/vung_mien.dart';
import '../Widget/xemHinh.dart';

class TrangChiTietDacSan extends StatefulWidget {
  final int maDS;
  const TrangChiTietDacSan({super.key, required this.maDS});

  @override
  _TrangChiTietDacSanState createState() => _TrangChiTietDacSanState();
}

class _TrangChiTietDacSanState extends State<TrangChiTietDacSan> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    getURLImage(dsDacSan[widget.maDS - 1].avatar),
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
              ),
              child: Text(dsDacSan[widget.maDS - 1].tenDacSan ?? '',
                  style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.teal,
                      fontSize: 35,
                      fontFamily: 'RobotoBlack')),
            ),
            // const SizedBox(height: 0),
            TextButton(
              style: const ButtonStyle(
                padding: MaterialStatePropertyAll(
                  EdgeInsetsDirectional.symmetric(
                    horizontal: 15,
                    vertical: 0,
                  ),
                ),
              ),
              onPressed: () {
                context.push(
                    "/dacsan/vungmien/${dsDacSan[widget.maDS - 1].idMien}");
              },
              child: Text(
                  "Đặc sản ${getMien(dsDacSan[widget.maDS - 1].idMien)}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.amber,
                      fontSize: 24,
                      fontFamily: 'ExtraBoldItalic')),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: const BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: Color.fromARGB(255, 211, 211, 211),
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              height: 230,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      getHinhAnhDS(dsDacSan[widget.maDS - 1].idDacSan ?? 0)
                          .length,
                  // itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 320,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(left: 8, right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => xemHinh(getHinhAnhDS(
                                      dsDacSan[widget.maDS - 1].idDacSan ??
                                          0)[index])),
                            );
                          },
                          child: Hero(
                            tag: 'hinhDS$index',
                            child: Image.network(
                                getHinhAnhDS(
                                    dsDacSan[widget.maDS - 1].idDacSan ??
                                        0)[index],
                                fit: BoxFit.cover,
                                width:
                                    double.infinity, // Đặt chiều rộng mong muốn
                                height: double.infinity),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(height: 25),
            const Padding(
              padding: EdgeInsets.only(
                left: 15,
              ),
              child: Text('Nội dung',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.teal,
                      fontSize: 28,
                      fontFamily: "RobotoBlack")),
            ),
            Card(
                color: const Color.fromARGB(255, 242, 242, 242),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText(dsDacSan[widget.maDS - 1].moTa ?? '',
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'RobotoLight',
                          wordSpacing: 1.3,
                          letterSpacing: 0.1,
                          color: Colors.black,
                          fontWeight: FontWeight.w900)),
                )),
            const SizedBox(height: 25),
            const Padding(
              padding: EdgeInsets.only(
                left: 15,
              ),
              child: Text('Nguyên liệu',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.teal,
                      fontSize: 28,
                      fontFamily: "RobotoBlack")),
            ),
            Card(
                color: const Color.fromARGB(255, 242, 242, 242),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText(
                      dsDacSan[widget.maDS - 1].thanhPhan ?? '',
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'RobotoLight',
                          wordSpacing: 1.3,
                          letterSpacing: 0.1,
                          color: Colors.black,
                          fontWeight: FontWeight.w900)),
                )),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  List<String> getHinhAnhDS(int idDacSan) {
    List<String> ds = [];
    for (var ha in dsHinhAnh) {
      if (ha.idDacSan == idDacSan) {
        ds.add(getURLImage(ha.idAnh));
      }
    }
    return ds;
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
