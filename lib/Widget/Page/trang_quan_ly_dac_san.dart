import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class TrangQuanLyDacSan extends StatefulWidget {
  const TrangQuanLyDacSan({super.key});

  @override
  State<TrangQuanLyDacSan> createState() => _TrangQuanLyDacSanState();
}

class _TrangQuanLyDacSanState extends State<TrangQuanLyDacSan> {
  bool asc = true;
  int sortIndex = 0;
  @override
  void initState() {
    // Future.delayed(
    //   const Duration(milliseconds: 100),
    //   () async {
    //     await DacSan.themDanhSach(dsDacSan);
    //   },
    // );
    // print(dsDacSan.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: PaginatedDataTable2(
        showCheckboxColumn: true,
        checkboxHorizontalMargin: 0,
        rowsPerPage: 20,
        sortAscending: asc,
        sortColumnIndex: sortIndex,
        columns: [
          DataColumn(
            label: const Text("Mã đặc sản"),
            onSort: (columnIndex, ascending) {
              if (ascending) {
                dsDacSan.sort(
                  (a, b) => a.idDacSan.compareTo(b.idDacSan),
                );
              } else {
                dsDacSan.sort(
                  (a, b) => b.idDacSan.compareTo(a.idDacSan),
                );
              }
              setState(() {
                asc = ascending;
                sortIndex = columnIndex;
              });
            },
          ),
          DataColumn(
            label: const Text("Tên đặc sản"),
            onSort: (columnIndex, ascending) {
              setState(() {
                asc = ascending;
                sortIndex = columnIndex;

                if (ascending) {
                  dsDacSan.sort(
                    (a, b) => a.tenDacSan.compareTo(b.tenDacSan),
                  );
                } else {
                  dsDacSan.sort(
                    (a, b) => b.tenDacSan.compareTo(a.tenDacSan),
                  );
                }
              });
            },
          ),
          DataColumn(
            label: const Text("Vùng miền"),
            onSort: (columnIndex, ascending) {
              setState(() {
                asc = ascending;
                sortIndex = columnIndex;

                if (ascending) {
                  dsDacSan.sort(
                    (a, b) => dsVungMien
                        .firstWhere(
                            (element) => element.idVungMien == a.idVungMien)
                        .tenVungMien
                        .compareTo(dsVungMien
                            .firstWhere(
                                (element) => element.idVungMien == b.idVungMien)
                            .tenVungMien),
                  );
                } else {
                  dsDacSan.sort(
                    (a, b) => dsVungMien
                        .firstWhere(
                            (element) => element.idVungMien == b.idVungMien)
                        .tenVungMien
                        .compareTo(dsVungMien
                            .firstWhere(
                                (element) => element.idVungMien == a.idVungMien)
                            .tenVungMien),
                  );
                }
              });
            },
          ),
          DataColumn(
            label: const Text("Xuất sứ"),
            onSort: (columnIndex, ascending) {
              setState(() {
                asc = ascending;
                sortIndex = columnIndex;

                if (ascending) {
                  dsDacSan.sort(
                    (a, b) => dsTinhThanh
                        .firstWhere(
                            (element) => element.idTinhThanh == a.idTinhThanh)
                        .tenTinhThanh
                        .compareTo(dsTinhThanh
                            .firstWhere((element) =>
                                element.idTinhThanh == b.idTinhThanh)
                            .tenTinhThanh),
                  );
                } else {
                  dsDacSan.sort(
                    (a, b) => dsTinhThanh
                        .firstWhere(
                            (element) => element.idTinhThanh == b.idTinhThanh)
                        .tenTinhThanh
                        .compareTo(dsTinhThanh
                            .firstWhere((element) =>
                                element.idTinhThanh == a.idTinhThanh)
                            .tenTinhThanh),
                  );
                }
              });
            },
          ),
          const DataColumn(
            label: Text("Thành phần"),
          ),
        ],
        source: DacSanDataSource(),
      ),
    );
  }
}

class DacSanDataSource extends DataTableSource {
  List<bool> selectedRowIndexs = dsDacSan.map((e) => false).toList();
  @override
  int get rowCount => dsDacSan.length;
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
          Text(dsDacSan[index].idDacSan.toString()),
        ),
        DataCell(
          Text(dsDacSan[index].tenDacSan),
        ),
        DataCell(
          Text(dsVungMien
              .firstWhere(
                  (element) => element.idVungMien == dsDacSan[index].idVungMien)
              .tenVungMien),
        ),
        DataCell(
          Text(dsTinhThanh
              .firstWhere((element) =>
                  element.idTinhThanh == dsDacSan[index].idTinhThanh)
              .tenTinhThanh),
        ),
        DataCell(
          Text(dsDacSan[index].thanhPhan ?? "Chưa cập nhật"),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
