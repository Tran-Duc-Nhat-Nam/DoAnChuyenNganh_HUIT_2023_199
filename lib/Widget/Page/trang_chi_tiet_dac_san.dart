// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vina_foods/Widget/hinh_cache.dart';

import '../../Model/dac_san.dart';
import '../../main.dart';
import '../preview_hinh.dart';

class TrangChiTietDacSan extends StatefulWidget {
  final String maDS;
  const TrangChiTietDacSan({super.key, required this.maDS});

  @override
  State<TrangChiTietDacSan> createState() => _TrangChiTietDacSanState();
}

class _TrangChiTietDacSanState extends State<TrangChiTietDacSan> {
  @override
  Widget build(BuildContext context) {
    DacSan dacSan =
        dsDacSan.firstWhere((element) => element.idDacSan == widget.maDS);
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
                    dsHinhAnh
                        .firstWhere(
                            (element) => element.idAnh == dacSan.idHinhDaiDien)
                        .link,
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
              child: Text(dacSan.tenDacSan,
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
                context.pushNamed(
                  "timKiem",
                  queryParameters: {"vungMien": dacSan.idVungMien.toString()},
                );
              },
              child: Text(
                  "Đặc sản ${dsVungMien.firstWhere((element) => element.idVungMien == dacSan.idVungMien).tenVungMien}",
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
                  itemCount: dsHinhAnh
                      .where((element) => element.idDacSan == dacSan.idDacSan)
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
                                  builder: (context) => PreviewHinh(dsHinhAnh
                                      .where((element) =>
                                          element.idDacSan == dacSan.idDacSan)
                                      .toList()[index]
                                      .link)),
                            );
                          },
                          child: Hero(
                            tag: 'hinhDS$index',
                            child: HinhCache(
                                dsHinhAnh
                                    .where((element) =>
                                        element.idDacSan == dacSan.idDacSan)
                                    .toList()[index]
                                    .link,
                                150),
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
                  child: SelectableText(dacSan.moTa ?? '',
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
                  child: SelectableText(dacSan.thanhPhan ?? '',
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
}
