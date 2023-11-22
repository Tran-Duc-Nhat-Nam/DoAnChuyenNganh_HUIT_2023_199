import 'package:app_dac_san/Page/trang_chi_tiet_dac_san.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../Model/dac_san.dart';
import '../Model/vung_mien.dart';
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
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 0.2,
            animateToClosest: true,
            pageSnapping: true,
            viewportFraction: 1.0,
          ),
          items: [1, 2, 3, 4, 5].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Card(
                    color: const Color.fromARGB(255, 65, 105, 225),
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              dsHinhAnh[i - 1].link!,
                            ),
                          ),
                          title: Text(dsDacSan[i - 1].tenDacSan!),
                          subtitle: Text(dsDacSan[i - 1].thanhPhan!),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton(
                              child: const Text(
                                'Xem chi tiết',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {/* ... */},
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              child: const Text(
                                'Xem sản phẩm cùng xuất sứ',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {/* ... */},
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        DropdownButton<int>(
          value: selectedVungMien,
          onChanged: (int? newValue) {
            setState(() {
              selectedVungMien = newValue!;
            });
          },
          items: dsVungMien.map<DropdownMenuItem<int>>((VungMien value) {
            return DropdownMenuItem<int>(
              value: value.idMien,
              child: Text(value.tenMien.toString()),
            );
          }).toList(),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: dsDacSan.length,
            itemBuilder: (context, index) {
              DacSan dacSan = dsDacSan[index];
              // if (selectedVungMien >= 0 || selectedVungMien == 'Tất cả' || selectedVungMien == dacSan.xuatXu) {
              if (selectedVungMien == 2) {
                return ListTile(
                  leading: Image.network(
                    getURLImage(dacSan.avatar),
                    width: 100,
                    height: 100,
                  ),
                  title: Text(dacSan.tenDacSan.toString()),
                  subtitle: Text(getNameTinh(dacSan.xuatXu)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TrangChiTietDacSan(Dacsan: dacSan),
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
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

  // Future<String> getURLImage(int? idImage) async {
  //   // con loi fix nay nha. Api get ve se duoc chuoi strring html
  //   var url = Uri.parse('https://cntt199.000webhostapp.com/getLinkImage.php');
  //   var reponse = await http.post(url, body: {
  //     'idanh': idImage.toString(),
  //   });
  //
  //   var result = json.decode(reponse.body);
  //   urlImage = result.toString();
  //   return urlImage;
  // }

// String getURLImage(int? idImage) {
//   var result = 'http://www.clker.com/cliparts/2/l/m/p/B/b/error-md.png';
//   var url = Uri.parse('https://cntt199.000webhostapp.com/getLinkImage.php');
//   http.post(url, body: {'idanh': idImage.toString()}).then((response) {
//     result = json.decode(response.body);
//     print(result.toString());
//     return result.toString();
//   }).catchError((error) {
//     print('Lỗi trong quá trình gửi yêu cầu: $error');
//     return "urlImage";
//   });
//   return result.toString();
// }
}
