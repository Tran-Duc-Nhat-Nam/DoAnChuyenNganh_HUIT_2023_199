import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../Model/dac_san.dart';
import '../../main.dart';
import '../hinh_cache.dart';

class TrangDanhSachDacSan extends StatefulWidget {
  const TrangDanhSachDacSan({
    super.key,
    this.ten,
    this.xuatSu,
    this.thanhPhan,
    this.noiBat,
    this.vungMien,
  });
  final String? ten;
  final String? thanhPhan;
  final String? xuatSu;
  final String? vungMien;
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
          .where((element) => element.tenDacSan
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
          .where((element) => element.idTinhThanh == widget.xuatSu)
          .toList();
    }
    if (widget.vungMien != null) {
      dsDacSanDaLoc = dsDacSanDaLoc
          .where((element) => element.idVungMien == widget.vungMien)
          .toList();
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
                vertical: 10,
              ),
              shape: LinearBorder.bottom(
                side: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
              title: Text(
                dsDacSanDaLoc[index].tenDacSan,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(
                  right: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Thành phần: ${dsDacSanDaLoc[index].thanhPhan!}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Xuất xứ: ${dsTinhThanh.firstWhere((element) => element.idTinhThanh == dsDacSanDaLoc[index].idTinhThanh)}',
                    ),
                  ],
                ),
              ),
              leading: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: SizedBox(
                    width: 100,
                    height: 85,
                    child: HinhCache(
                        dsHinhAnh
                            .firstWhere((element) =>
                                element.idAnh ==
                                dsDacSanDaLoc[index].idHinhDaiDien!)
                            .link,
                        150),
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
