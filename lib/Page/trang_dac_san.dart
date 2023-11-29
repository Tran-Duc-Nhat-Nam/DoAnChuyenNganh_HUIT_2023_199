import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Model/dac_san.dart';
import '../Service/thu_vien_api.dart';
import '../Service/thu_vien_widget.dart';
import '../Widget/thong_bao_xac_nhan_thoat.dart';
import '../main.dart';

class TrangDacSan extends StatefulWidget {
  const TrangDacSan({super.key});

  @override
  _TrangDacSanState createState() => _TrangDacSanState();
}

class _TrangDacSanState extends State<TrangDacSan> {
  var urlImage = "";
  int selectedVungMien = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (popped) {
        ThongBaoXacNhanThoat(context);
      },
      canPop: false,
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.2 + 30,
                  animateToClosest: true,
                  pageSnapping: true,
                  enableInfiniteScroll: true,
                  viewportFraction: 1,
                ),
                items: buildBanner(5),
              ),
              headerVungMien("Miền Bắc"),
              DacSanList(lstDacSan: dsDacSan),
              headerVungMien("Miền Trung"),
              DacSanList(lstDacSan: dsDacSan),
              headerVungMien("Miền Nam"),
              DacSanList(lstDacSan: dsDacSan)
              // DropdownButton<int>(
              //   value: selectedVungMien,
              //   onChanged: (int? newValue) {
              //     setState(() {
              //       selectedVungMien = newValue!;
              //     });
              //   },
              //   items: dsVungMien.map<DropdownMenuItem<int>>((VungMien value) {
              //     return DropdownMenuItem<int>(
              //       value: value.idMien,
              //       child: Text(value.tenMien.toString()),
              //     );
              //   }).toList(),
              // ),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: dsDacSan.length,
              //     itemBuilder: (context, index) {
              //       DacSan dacSan = dsDacSan[index];
              //       // if (selectedVungMien >= 0 || selectedVungMien == 'Tất cả' || selectedVungMien == dacSan.xuatXu) {
              //       if (selectedVungMien == 2) {
              //         return ListTile(
              //           leading: Image.network(
              //             getURLImage(dacSan.avatar, dsHinhAnh),
              //             width: 100,
              //             height: 100,
              //           ),
              //           title: Text(dacSan.tenDacSan.toString()),
              //           subtitle: Text(getNameTinh(dacSan.xuatXu)),
              //           onTap: () => context.go("/dacsan/$index"),
              //         );
              //       }
              //       return const SizedBox.shrink();
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildBanner(int limit) {
    List<Widget> dsWidget = [];
    for (int i = 0; i < dsDacSan.length && i < limit; i++) {
      Widget temp = Builder(
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Container(
              color: Theme.of(context).splashColor,
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.15,
                  vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: cachedImage(dsDacSan[i].avatar!),
              ),
            ),
          );
        },
      );
      dsWidget.add(temp);
    }
    return dsWidget;
  }

  Padding headerVungMien(String mien) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Text(mien,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.lightBlue)),
          const Spacer(), // use Spacer
          TextButton(
            onPressed: () {
              context.goNamed(
                "timKiem",
                queryParameters: {"ten": "Mì"},
              );
            },
            child: const Text("Xem thêm",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.lightBlue)),
          ),
        ],
      ),
    );
  }
}

class DacSanList extends StatelessWidget {
  final List<DacSan> lstDacSan;

  const DacSanList({super.key, required this.lstDacSan});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: Container(
            color: Color.fromARGB(75, 0, 191, 255),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: lstDacSan.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () => context.go("/dacsan/chitiet/${index + 1}"),
                  child: Card(
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: 250,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: cachedImage(dsDacSan[index].avatar!),
                          ),
                          const SizedBox(height: 15),
                          Text(dsDacSan[index].tenDacSan!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              )),
                          Text(
                            'Xuất xứ: ${getTenTinh(dsDacSan[index].xuatXu)}',
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
