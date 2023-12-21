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
              label: const Text("Mã vùng miền"),
              onSort: (columnIndex, ascending) {
                if (ascending) {
                  dsVungMien.sort(
                    (a, b) => a.idMien.compareTo(b.idMien),
                  );
                } else {
                  dsVungMien.sort(
                    (a, b) => b.idMien.compareTo(a.idMien),
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
                    (a, b) => a.tenMien.compareTo(b.tenMien),
                  );
                } else {
                  dsVungMien.sort(
                    (a, b) => b.tenMien.compareTo(a.tenMien),
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
          Text(dsVungMien[index].idMien.toString()),
        ),
        DataCell(
          Text(dsVungMien[index].tenMien),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
