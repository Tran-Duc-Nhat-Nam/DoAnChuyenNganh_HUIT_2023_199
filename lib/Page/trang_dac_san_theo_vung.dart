// ignore_for_file: library_private_types_in_public_api

import 'package:app_dac_san/Model/loai_dac_san.dart';
import 'package:app_dac_san/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Model/dac_san.dart';
import '../Service/thu_vien_api.dart';
import '../Service/thu_vien_widget.dart';

class TrangDacSanTheoVung extends StatefulWidget {
  final int maVung;

  const TrangDacSanTheoVung({super.key, required this.maVung});

  @override
  _TrangDacSanTheoVungState createState() => _TrangDacSanTheoVungState();
}

class _TrangDacSanTheoVungState extends State<TrangDacSanTheoVung> {
  List<DacSan> lstDacSan = [];
  List<DacSan> filteredDacSan = [];
  String selectedChip = dsLoaiDacSan[0].tenLoai;

  void selectChip(LoaiDacSan chip) {
    setState(() {
      selectedChip = chip.tenLoai;
    });
  }

  @override
  void initState() {
    super.initState();
    lstDacSan =
        dsDacSan.where((dacSan) => dacSan.idMien == widget.maVung).toList();
    filteredDacSan = lstDacSan
        .where((dacSan) => dacSan.loaiDacSan == dsLoaiDacSan[0].idLoai)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          headerLoaiDacSan(),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDacSan.length,
              itemBuilder: (context, index) {
                final dacSan = filteredDacSan[index];

                return InkWell(
                  onTap: () => context.go("/dacsan/chitiet/${dacSan.idDacSan}"),
                  child: SizedBox(
                    child: Card(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.blue[50]
                          : Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        title: Text(
                          dacSan.tenDacSan!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Thành phần: ${dacSan.thanhPhan!}",
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text('Xuất xứ: ${getTenTinh(dacSan.xuatXu)}'),
                          ],
                        ),
                        leading: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: SizedBox(
                              width: 100,
                              child: cachedImage(dacSan.avatar!),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Padding headerLoaiDacSan() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
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
                      filteredDacSan = lstDacSan
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
          ],
        ),
      ),
    );
  }
}
