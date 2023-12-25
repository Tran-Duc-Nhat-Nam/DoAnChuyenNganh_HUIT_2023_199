import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:vina_foods/main.dart';

import '../../Model/loai_dac_san.dart';
import '../../Service/thu_vien_style.dart';

class TrangQuanLyLoaiDacSan extends StatefulWidget {
  TrangQuanLyLoaiDacSan({super.key});
  final TextEditingController tenLoaiController = TextEditingController();

  @override
  _TrangQuanLyLoaiDacSanState createState() => _TrangQuanLyLoaiDacSanState();
}

class _TrangQuanLyLoaiDacSanState extends State<TrangQuanLyLoaiDacSan> {
  List<bool> selectedRowIndexs = dsLoaiDacSan.map((e) => false).toList();
  bool asc = true;
  int sortIndex = 0;
  bool loading = false;
  @override
  void initState() {
    // Future.delayed(
    //   const Duration(milliseconds: 10),
    //   () async {
    //     for (var e in dsLoaiDacSan) {
    //       print(e.tenLoai);
    //       await LoaiDacSan.them(e.tenLoai);
    //     }
    //   },
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: PaginatedDataTable2(
              showCheckboxColumn: true,
              rowsPerPage: 15,
              sortAscending: asc,
              sortColumnIndex: sortIndex,
              header: const Center(child: Text("Danh sách loại đặc sản")),
              columns: columnLoaiDacSan(),
              source: LoaiDacSanDataSource(selectedRowIndexs),
            ),
          ),
          Form(
            child: SizedBox(
              height: 100,
              child: Row(
                children: [
                  Flexible(
                    flex: 7,
                    child: TextField(
                      controller: widget.tenLoaiController,
                      decoration: RoundInputDecoration("Tên loại"),
                    ),
                  ),
                  Container(
                    width: 100,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        side:
                            const BorderSide(width: 1, color: Colors.lightBlue),
                      ),
                      child: const Text("Thêm"),
                      onPressed: () async {
                        bool kq = await LoaiDacSan.them(
                            widget.tenLoaiController.text);
                        if (kq) {
                          dsLoaiDacSan = await LoaiDacSan.docDanhSach();
                          selectedRowIndexs =
                              dsLoaiDacSan.map((e) => false).toList();
                          setState(() {});
                        } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Thêm thất bại"),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Container(
                    width: 150,
                    padding: const EdgeInsets.symmetric(),
                    child: ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        side:
                            const BorderSide(width: 1, color: Colors.lightBlue),
                      ),
                      onPressed: loading
                          ? null
                          : () async {
                              if (selectedRowIndexs
                                      .where((element) => element)
                                      .length >
                                  1) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Vui lòng chỉ chọn 1 loại đặc sản để cập nhật"),
                                    ),
                                  );
                                }
                              } else if (selectedRowIndexs
                                  .where((element) => element)
                                  .isEmpty) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Vui lòng chọn 1 loại đặc sản để cập nhật"),
                                    ),
                                  );
                                }
                              } else {
                                setState(() {
                                  loading = true;
                                });
                                for (int i = 0;
                                    i < selectedRowIndexs.length;
                                    i++) {
                                  if (selectedRowIndexs[i]) {
                                    dsLoaiDacSan[i].tenLoai =
                                        widget.tenLoaiController.text;
                                    await dsLoaiDacSan[i].capNhat();
                                  }
                                }

                                dsLoaiDacSan = await LoaiDacSan.docDanhSach();
                                selectedRowIndexs =
                                    dsLoaiDacSan.map((e) => false).toList();
                                setState(() {
                                  loading = false;
                                });
                              }
                            },
                      child: const Text("Cập nhật"),
                    ),
                  ),
                  Container(
                    width: 100,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        side: const BorderSide(width: 1, color: Colors.red),
                      ),
                      onPressed: loading
                          ? null
                          : () async {
                              setState(() {
                                loading = true;
                              });
                              for (int i = 0;
                                  i < selectedRowIndexs.length;
                                  i++) {
                                if (selectedRowIndexs[i]) {
                                  await dsLoaiDacSan[i].xoa();
                                }
                              }

                              dsLoaiDacSan = await LoaiDacSan.docDanhSach();
                              selectedRowIndexs =
                                  dsLoaiDacSan.map((e) => false).toList();
                              setState(() {
                                loading = false;
                              });
                            },
                      child: const Text(
                        "Xóa",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  List<DataColumn> columnLoaiDacSan() {
    return [
      DataColumn(
        label: const Text("Mã loại"),
        onSort: sapXepIdLoaiDacSan,
      ),
      DataColumn(
        label: const Text("Tên loại"),
        onSort: sapXepTenLoaiDacSan,
      ),
    ];
  }

  void sapXepTenLoaiDacSan(columnIndex, ascending) {
    if (ascending) {
      dsLoaiDacSan.sort(
        (a, b) => a.tenLoai.compareTo(b.tenLoai),
      );
    } else {
      dsLoaiDacSan.sort(
        (a, b) => b.tenLoai.compareTo(a.tenLoai),
      );
    }
    setState(() {
      asc = ascending;
      sortIndex = columnIndex;
    });
  }

  void sapXepIdLoaiDacSan(columnIndex, ascending) {
    if (ascending) {
      dsLoaiDacSan.sort(
        (a, b) => a.idLoai.compareTo(b.idLoai),
      );
    } else {
      dsLoaiDacSan.sort(
        (a, b) => b.idLoai.compareTo(a.idLoai),
      );
    }
    setState(() {
      asc = ascending;
      sortIndex = columnIndex;
    });
  }
}

class LoaiDacSanDataSource extends DataTableSource {
  LoaiDacSanDataSource(this.selectedRowIndexs);
  List<bool> selectedRowIndexs;
  @override
  int get rowCount => dsLoaiDacSan.length;
  @override
  DataRow? getRow(int index) {
    return DataRow(
      onSelectChanged: (value) {
        selectedRowIndexs[index] = value!;
        notifyListeners();
      },
      selected: selectedRowIndexs[index],
      cells: [
        DataCell(
          Text(
            dsLoaiDacSan[index].idLoai.toString(),
            overflow: TextOverflow.fade,
          ),
        ),
        DataCell(
          Text(dsLoaiDacSan[index].tenLoai),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
