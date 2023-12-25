import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:vina_foods/main.dart';

class TrangQuanLyVungMien extends StatefulWidget {
  const TrangQuanLyVungMien({super.key});

  @override
  _TrangQuanLyVungMienState createState() => _TrangQuanLyVungMienState();
}

class _TrangQuanLyVungMienState extends State<TrangQuanLyVungMien> {
  bool asc = true;
  int sortIndex = 0;
  @override
  void initState() {
    // Future.delayed(
    //   const Duration(milliseconds: 10),
    //   () async {
    //     for (var e in dsVungMien) {
    //       print(e.tenVungMien);
    //       await VungMien.them(e.tenVungMien);
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
            label: const Text("Mã vùng miền"),
            onSort: (columnIndex, ascending) {
              if (ascending) {
                dsVungMien.sort(
                  (a, b) => a.idVungMien.compareTo(b.idVungMien),
                );
              } else {
                dsVungMien.sort(
                  (a, b) => b.idVungMien.compareTo(a.idVungMien),
                );
              }
              setState(() {
                asc = ascending;
                sortIndex = columnIndex;
              });
            },
          ),
          DataColumn(
            label: const Text("Tên vùng miền"),
            onSort: (columnIndex, ascending) {
              if (ascending) {
                dsVungMien.sort(
                  (a, b) => a.tenVungMien.compareTo(b.tenVungMien),
                );
              } else {
                dsVungMien.sort(
                  (a, b) => b.tenVungMien.compareTo(a.tenVungMien),
                );
              }
              setState(() {
                asc = ascending;
                sortIndex = columnIndex;
              });
            },
          ),
        ],
        source: VungMienDataSource(),
      ),
    );
  }
}

class VungMienDataSource extends DataTableSource {
  List<bool> selectedRowIndexs = dsVungMien.map((e) => false).toList();
  @override
  int get rowCount => dsVungMien.length;
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
          Text(dsVungMien[index].idVungMien.toString()),
        ),
        DataCell(
          Text(dsVungMien[index].tenVungMien),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
