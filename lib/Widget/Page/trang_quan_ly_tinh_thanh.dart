import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:vina_foods/main.dart';

class TrangQuanLyTinhThanh extends StatefulWidget {
  const TrangQuanLyTinhThanh({super.key});

  @override
  _TrangQuanLyTinhThanhState createState() => _TrangQuanLyTinhThanhState();
}

class _TrangQuanLyTinhThanhState extends State<TrangQuanLyTinhThanh> {
  bool asc = true;
  int sortIndex = 0;
  @override
  void initState() {
    // Future.delayed(
    //   const Duration(milliseconds: 10),
    //   () async {
    //     for (var e in dsTinhThanh) {
    //       print(e.tenTinhThanh);
    //       await TinhThanh.them(e.tenTinhThanh);
    //     }
    //   },
    // );
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
            label: const Text("Mã tỉnh thành"),
            onSort: (columnIndex, ascending) {
              if (ascending) {
                dsTinhThanh.sort(
                  (a, b) => a.idTinhThanh.compareTo(b.idTinhThanh),
                );
              } else {
                dsTinhThanh.sort(
                  (a, b) => b.idTinhThanh.compareTo(a.idTinhThanh),
                );
              }
              setState(() {
                asc = ascending;
                sortIndex = columnIndex;
              });
            },
          ),
          DataColumn(
            label: const Text("Tên tỉnh thành"),
            onSort: (columnIndex, ascending) {
              if (ascending) {
                dsTinhThanh.sort(
                  (a, b) => a.tenTinhThanh.compareTo(b.tenTinhThanh),
                );
              } else {
                dsTinhThanh.sort(
                  (a, b) => b.tenTinhThanh.compareTo(a.tenTinhThanh),
                );
              }
              setState(() {
                asc = ascending;
                sortIndex = columnIndex;
              });
            },
          ),
        ],
        source: TinhThanhDataSource(),
      ),
    );
  }
}

class TinhThanhDataSource extends DataTableSource {
  List<bool> selectedRowIndexs = dsTinhThanh.map((e) => false).toList();
  @override
  int get rowCount => dsTinhThanh.length;
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
          Text(dsTinhThanh[index].idTinhThanh.toString()),
        ),
        DataCell(
          Text(dsTinhThanh[index].tenTinhThanh),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
