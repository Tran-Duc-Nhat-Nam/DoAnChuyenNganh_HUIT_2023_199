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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: PaginatedDataTable(
          showCheckboxColumn: true,
          checkboxHorizontalMargin: 0,
          rowsPerPage: 20,
          sortAscending: asc,
          sortColumnIndex: sortIndex,
          columns: [
            DataColumn(
              label: Text("Mã đặc sản"),
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
              label: Text("Tên đặc sản"),
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
              label: Text("Vùng miền"),
              onSort: (columnIndex, ascending) {
                setState(() {
                  asc = ascending;
                  sortIndex = columnIndex;

                  if (ascending) {
                    dsDacSan.sort(
                      (a, b) => dsVungMien
                          .firstWhere((element) => element.idMien == a.idMien)
                          .tenMien
                          .compareTo(dsVungMien
                              .firstWhere(
                                  (element) => element.idMien == b.idMien)
                              .tenMien),
                    );
                  } else {
                    dsDacSan.sort(
                      (a, b) => dsVungMien
                          .firstWhere((element) => element.idMien == b.idMien)
                          .tenMien
                          .compareTo(dsVungMien
                              .firstWhere(
                                  (element) => element.idMien == a.idMien)
                              .tenMien),
                    );
                  }
                });
              },
            ),
            DataColumn(
              label: Text("Xuất sứ"),
              onSort: (columnIndex, ascending) {
                setState(() {
                  asc = ascending;
                  sortIndex = columnIndex;

                  if (ascending) {
                    dsDacSan.sort(
                      (a, b) => dsTinhThanh
                          .firstWhere((element) => element.maTT == a.xuatXu)
                          .ten
                          .compareTo(dsTinhThanh
                              .firstWhere((element) => element.maTT == b.xuatXu)
                              .ten),
                    );
                  } else {
                    dsDacSan.sort(
                      (a, b) => dsTinhThanh
                          .firstWhere((element) => element.maTT == b.xuatXu)
                          .ten
                          .compareTo(dsTinhThanh
                              .firstWhere((element) => element.maTT == a.xuatXu)
                              .ten),
                    );
                  }
                });
              },
            ),
            DataColumn(
              label: Text("Thành phần"),
            ),
          ],
          source: DacSanDataSource(),
        ),
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
              .firstWhere((element) => element.idMien == dsDacSan[index].idMien)
              .tenMien),
        ),
        DataCell(
          Text(dsTinhThanh
              .firstWhere((element) => element.maTT == dsDacSan[index].xuatXu)
              .ten),
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
