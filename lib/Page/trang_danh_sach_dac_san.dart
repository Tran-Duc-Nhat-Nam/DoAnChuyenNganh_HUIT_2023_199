import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Model/dac_san.dart';
import '../Service/thu_vien_api.dart';
import '../Service/thu_vien_widget.dart';
import '../main.dart';

class TrangDanhSachDacSan extends StatefulWidget {
  const TrangDanhSachDacSan({
    super.key,
    this.ten,
    this.xuatSu,
    this.thanhPhan,
    this.noiBat,
  });
  final String? ten;
  final String? thanhPhan;
  final int? xuatSu;
  final bool? noiBat;
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
    if (widget.noiBat != null) {
      if (widget.noiBat!) {
        dsDacSanDaLoc = dsDacSanDaLoc
            .where((dacSan) => dsDacSanNoiBat
                .any((element) => element.idDacSan == dacSan.idDacSan))
            .toList();
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        context.go("/dacsan");
      },
      canPop: false,
      child: ListView.builder(
        itemCount: dsDacSanDaLoc.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => context.go("/dacsan/chitiet/${index + 1}"),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              shape: LinearBorder.bottom(
                side: BorderSide(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: Text(
                dsDacSanDaLoc[index].tenDacSan!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Thành phần: ${dsDacSanDaLoc[index].thanhPhan!}"),
                  Text('Xuất xứ: ${getTenTinh(dsDacSanDaLoc[index].xuatXu)}'),
                ],
              ),
              leading: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: cachedImage(dsDacSanDaLoc[index].avatar!),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
