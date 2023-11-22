import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../Model/dac_san.dart';
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
    return Scaffold(
      body: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.2 + 30,
              animateToClosest: true,
              pageSnapping: true,
              enableInfiniteScroll: true,
              viewportFraction: 1,
            ),
            items: [1, 2, 3, 4, 5].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.network(
                          dsHinhAnh[i - 1].link!,
                          height: MediaQuery.of(context).size.height * 0.15,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),

          const Row(
            children: <Widget>[
              Text(
                  "Miền Bắc",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)
              ),
              Spacer(), // use Spacer
              Text(
                  "Xem thêm",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)
              ),
            ],
          ),
          DacSanList(lstDacSan: dsDacSan),

          const Row(
            children: <Widget>[
              Text(
                  "Miền Trung",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)
              ),
              Spacer(), // use Spacer
              Text(
                  "Xem thêm",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)
              ),
            ],
          ),
          DacSanList(lstDacSan: dsDacSan),

          const Row(
            children: <Widget>[
              Text(
                  "Miền Nam",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)
              ),
              Spacer(), // use Spacer
              Text(
                  "Xem thêm",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)
              ),
            ],
          ),
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
    );
  }
}

String getNameTinh(int? idTinh) {
  String name = '404';
  int index = dsTinhThanh.indexWhere((tinhThanh) => tinhThanh.maTT == idTinh);
  if (index != -1) {
    return dsTinhThanh[index].ten.toString();
  }
  return name;
}

String getMien(int? IdMien) {
  String name = '404';
  int index = dsVungMien.indexWhere((vungMien) => vungMien.idMien == IdMien);
  if (index != -1) {
    return dsVungMien[index].tenMien.toString();
  }
  return name;
}

String getURLImage(int? idImage) {
  String url = 'http://www.clker.com/cliparts/2/l/m/p/B/b/error-md.png';
  int index = dsHinhAnh.indexWhere(
          (hinhAnh) => hinhAnh.idAnh.toString() == idImage.toString());
  if (index != -1) {
    return dsHinhAnh[index].link.toString();
  }
  return url;
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
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: lstDacSan.length,
            itemBuilder: (BuildContext context, int index) {
              return DacSanCard(dacSan: lstDacSan[index]);
            },
          ),
        ),
      ],
    );
  }
}

class DacSanCard extends StatelessWidget {
  final DacSan dacSan;
  const DacSanCard({super.key, required this.dacSan});

  @override
  Widget build(BuildContext context) {
    return Card(
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
              child: Image.network(
                getURLImage(dacSan.avatar),
                fit: BoxFit.cover,
                height: 150,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              dacSan.tenDacSan!,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)
            ),
            Text(
                'Xuất xứ: ${dacSan.xuatXu}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)
            ),
          ],
        ),
      ),
    );
  }
}