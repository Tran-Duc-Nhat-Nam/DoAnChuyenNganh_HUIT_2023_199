// ignore_for_file: library_private_types_in_public_api

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Model/dac_san.dart';
import '../Model/loai_dac_san.dart';
import '../Model/vung_mien.dart';
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
              buildDacSanNoiBat(),
              headerLoaiDacSan(),
              Column(
                children: buildDanhSachDacSan(),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildDanhSachDacSan() {
    List<Widget> dsWidget = [];
    dsWidget = dsVungMien.map((vungMien) {
      return buildRowDacSan(vungMien);
    }).toList();
    return dsWidget;
  }

  Column buildRowDacSan(VungMien vungMien) {
    return Column(
      children: [
        headerVungMien(vungMien),
        DacSanList(
            lstDacSan: lstDacSan
                .where((dacSan) => dacSan.idMien == vungMien.idMien)
                .toList()),
      ],
    );
  }

  Column buildDacSanNoiBat() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextButton(
            onPressed: () {
              context.goNamed(
                "timKiem",
                queryParameters: {"noiBat": "true"},
              );
            },
            child: const Text("Những đặc sản Việt Nam bạn không thể bỏ qua",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue,
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 10,
          ),
          child: DacSanList(
              lstDacSan: lstDacSan
                  .where((dacSan) => dsDacSanNoiBat
                      .any((element) => element.idDacSan == dacSan.idDacSan))
                  .toList()),
        ),
      ],
    );
  }

  List<Widget> buildBanner(int limit) {
    List<Widget> dsWidget = [];
    for (int i = 0; i < dsDacSan.length && i < limit; i++) {
      Widget temp = Builder(
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 15,
              top: 10,
            ),
            child: Container(
              decoration: const BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: Color.fromARGB(155, 211, 211, 211),
                  ),
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1,
                  vertical: 10),
              child: InkWell(
                onTap: () {
                  context.push("/dacsan/chitiet/${dsDacSan[i].idDacSan}");
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: cachedImage(dsDacSan[i].avatar!),
                ),
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
      padding: const EdgeInsets.only(
        top: 10.0,
        bottom: 10.0,
        left: 15.0,
        right: 0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Loại đặc sản: ",
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue),
            maxLines: 1,
          ),
          const SizedBox(width: 10.0),
          Flexible(
            flex: 4,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: dsLoaiDacSan.map((loaiDacSan) {
                  bool isSelected = loaiDacSan.tenLoai == selectedChip;
                  return AnimatedContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: FilterChip(
                      label: Text(
                        loaiDacSan.tenLoai,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).disabledColor,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        selectChip(loaiDacSan);
                        lstDacSan = dsDacSan
                            .where((dacSan) =>
                                dacSan.loaiDacSan == loaiDacSan.idLoai)
                            .toList();
                      },
                      selectedColor: Colors.blue,
                      checkmarkColor: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
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
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue,
              )),
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
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.lightBlue.shade100
                : const Color.fromARGB(155, 135, 206, 250),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: lstDacSan.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () => context
                      .go("/dacsan/chitiet/${lstDacSan[index].idDacSan}"),
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
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: cachedImage(lstDacSan[index].avatar!),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(lstDacSan[index].tenDacSan!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              )),
                          Text(
                            'Xuất xứ: ${getTenTinh(lstDacSan[index].xuatXu)}',
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
