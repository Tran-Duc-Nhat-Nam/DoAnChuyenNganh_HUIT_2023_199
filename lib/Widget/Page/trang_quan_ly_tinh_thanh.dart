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
              label: const Text("Mã tỉnh thành"),
              onSort: (columnIndex, ascending) {
                if (ascending) {
                  dsTinhThanh.sort(
                    (a, b) => a.maTT.compareTo(b.maTT),
                  );
                } else {
                  dsTinhThanh.sort(
                    (a, b) => b.maTT.compareTo(a.maTT),
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
                    (a, b) => a.ten.compareTo(b.ten),
                  );
                } else {
                  dsTinhThanh.sort(
                    (a, b) => b.ten.compareTo(a.ten),
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
          Text(dsTinhThanh[index].maTT.toString()),
        ),
        DataCell(
          Text(dsTinhThanh[index].ten),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
