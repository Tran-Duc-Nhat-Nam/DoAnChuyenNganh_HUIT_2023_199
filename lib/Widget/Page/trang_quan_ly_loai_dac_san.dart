import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:vina_foods/main.dart';

import '../../Service/thu_vien_style.dart';

class TrangQuanLyLoaiDacSan extends StatefulWidget {
  const TrangQuanLyLoaiDacSan({super.key});

  @override
  _TrangQuanLyLoaiDacSanState createState() => _TrangQuanLyLoaiDacSanState();
}

class _TrangQuanLyLoaiDacSanState extends State<TrangQuanLyLoaiDacSan> {
  bool asc = true;
  int sortIndex = 0;
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
              header: const Center(child: Text("Test")),
              columns: [
                DataColumn(
                  label: const Text("Mã loại"),
                  onSort: (columnIndex, ascending) {
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
                  },
                ),
                DataColumn(
                  label: const Text("Tên loại"),
                  onSort: (columnIndex, ascending) {
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
                  },
                ),
              ],
              source: LoaiDacSanDataSource(),
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
                      decoration: RoundInputDecoration("Tên loại"),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
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
                          side: const BorderSide(
                              width: 1, color: Colors.lightBlue),
                        ),
                        child: const Text("Thêm"),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
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
                          side: const BorderSide(
                              width: 1, color: Colors.lightBlue),
                        ),
                        child: const Text("Cập nhật"),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
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
                        child: const Text(
                          "Xóa",
                          style: TextStyle(color: Colors.redAccent),
                        ),
                        onPressed: () {},
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
}

class LoaiDacSanDataSource extends DataTableSource {
  List<bool> selectedRowIndexs = dsLoaiDacSan.map((e) => false).toList();
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
          Text(dsLoaiDacSan[index].idLoai.toString()),
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
