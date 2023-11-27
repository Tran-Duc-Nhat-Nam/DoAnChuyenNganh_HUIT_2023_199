import 'package:app_dac_san/Service/thu_vien_widget.dart';
import 'package:app_dac_san/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Model/dac_san.dart';
import '../Service/thu_vien_api.dart';

class TrangDanhSachDacSan extends StatefulWidget {
  const TrangDanhSachDacSan({
    Key? key,
    this.ten,
    this.xuatSu,
    this.thanhPhan,
  }) : super(key: key);
  final String? ten;
  final String? thanhPhan;
  final int? xuatSu;
  @override
  State<TrangDanhSachDacSan> createState() => _TrangDanhSachDacSanState();
}

class _TrangDanhSachDacSanState extends State<TrangDanhSachDacSan> {
  List<DacSan> dsDacSanDaLoc = dsDacSan;
  @override
  void initState() {
    // TODO: implement initState
    if (widget.ten != null) {
      dsDacSanDaLoc = dsDacSanDaLoc
          .where((element) => element.tenDacSan!
              .toLowerCase()
              .contains(widget.ten!.toLowerCase()))
          .toList();
    }
    if (widget.thanhPhan != null) {
      dsDacSanDaLoc = dsDacSanDaLoc
          .where((element) => element.thanhPhan!
              .toLowerCase()
              .contains(widget.thanhPhan!.toLowerCase()))
          .toList();
    }
    if (widget.xuatSu != null) {
      dsDacSanDaLoc = dsDacSanDaLoc
          .where((element) => element.xuatXu! == widget.xuatSu)
          .toList();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dsDacSanDaLoc.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => context.go("/dacsan/chitiet/${index + 1}"),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            shape: LinearBorder.bottom(
              side: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            ),
            title: Text(dsDacSanDaLoc[index].tenDacSan!),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Thành phần: ${dsDacSanDaLoc[index].thanhPhan!}"),
                Text('Xuất xứ: ${getTenTinh(dsDacSanDaLoc[index].xuatXu)}'),
              ],
            ),
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: SizedBox(
                  width: 100,
                  height: 75,
                  child: cachedImage(dsDacSanDaLoc[index].avatar!),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
