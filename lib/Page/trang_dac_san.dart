import 'package:app_dac_san/Model/loai_dac_san.dart';
import 'package:app_dac_san/Model/vung_mien.dart';
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
  String selectedChip = dsLoaiDacSan[0].tenLoai;
  List<DacSan> lstDacSan = dsDacSan;

  void selectChip(LoaiDacSan chip) {
    setState(() {
      selectedChip = chip.tenLoai;
    });
  }

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
              headerLoaiDacSan(),
              headerVungMien(dsVungMien[0]),
              DacSanList(
                  lstDacSan:
                      lstDacSan.where((dacSan) => dacSan.idMien == 1).toList()),
              headerVungMien(dsVungMien[1]),
              DacSanList(
                  lstDacSan:
                      lstDacSan.where((dacSan) => dacSan.idMien == 2).toList()),
              headerVungMien(dsVungMien[2]),
              DacSanList(
                  lstDacSan:
                      lstDacSan.where((dacSan) => dacSan.idMien == 3).toList())
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

  Padding headerLoaiDacSan() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text("Loại đặc sản: ",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.lightBlue)),
          const SizedBox(width: 30.0),
          Wrap(
            spacing: 20.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: dsLoaiDacSan.map((loaiDacSan) {
              bool isSelected = loaiDacSan.tenLoai == selectedChip;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: FilterChip(
                  label: Text(
                    loaiDacSan.tenLoai,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    selectChip(loaiDacSan);
                    lstDacSan = dsDacSan
                        .where(
                            (dacSan) => dacSan.loaiDacSan == loaiDacSan.idLoai)
                        .toList();
                  },
                  selectedColor: Colors.blue,
                  checkmarkColor: Colors.white,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Padding headerVungMien(VungMien vungMien) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Text(vungMien.tenMien!,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.lightBlue)),
          const Spacer(), // use Spacer
          TextButton(
            onPressed: () {
              // context.goNamed(
              //   "timKiem",
              //   queryParameters: {"ten": "Mì"},
              // );
              context.go("/dacsan/vungmien/${vungMien.idMien}");
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
            color: const Color.fromARGB(75, 0, 191, 255),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: lstDacSan.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () => context.go("/dacsan/chitiet/${index + 1}"),
                  child: Card(
                    margin: const EdgeInsets.all(10),
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
