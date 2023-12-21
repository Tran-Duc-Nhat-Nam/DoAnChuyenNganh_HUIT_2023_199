import 'package:flutter/material.dart';
import 'package:vina_foods/main.dart';

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
