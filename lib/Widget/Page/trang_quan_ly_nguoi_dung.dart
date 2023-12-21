import 'package:flutter/material.dart';
import 'package:vina_foods/main.dart';

class TrangQuanLyNguoiDung extends StatefulWidget {
  const TrangQuanLyNguoiDung({super.key});

  @override
  State<TrangQuanLyNguoiDung> createState() => _TrangQuanLyNguoiDungState();
}

class _TrangQuanLyNguoiDungState extends State<TrangQuanLyNguoiDung> {
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
              label: const Text("UID"),
              onSort: (columnIndex, ascending) {
                if (ascending) {
                  dsNguoiDung.sort(
                    (a, b) => a.uid.compareTo(b.uid),
                  );
                } else {
                  dsNguoiDung.sort(
                    (a, b) => b.uid.compareTo(a.uid),
                  );
                }
                setState(() {
                  asc = ascending;
                  sortIndex = columnIndex;
                });
              },
            ),
            DataColumn(
              label: const Text("Email"),
              onSort: (columnIndex, ascending) {
                if (ascending) {
                  dsNguoiDung.sort(
                    (a, b) => a.email.compareTo(b.email),
                  );
                } else {
                  dsNguoiDung.sort(
                    (a, b) => b.email.compareTo(a.email),
                  );
                }
                setState(() {
                  asc = ascending;
                  sortIndex = columnIndex;
                });
              },
            ),
            DataColumn(
              label: const Text("Họ tên"),
              onSort: (columnIndex, ascending) {
                if (ascending) {
                  dsNguoiDung.sort(
                    (a, b) => a.hoTen.compareTo(b.hoTen),
                  );
                } else {
                  dsNguoiDung.sort(
                    (a, b) => b.hoTen.compareTo(a.hoTen),
                  );
                }
                setState(() {
                  asc = ascending;
                  sortIndex = columnIndex;
                });
              },
            ),
            DataColumn(
              label: const Text("Giới tính"),
              onSort: (columnIndex, ascending) {
                if (ascending) {
                  dsNguoiDung.sort(
                    (a, b) => a.isNam.toString().compareTo(b.isNam.toString()),
                  );
                } else {
                  dsNguoiDung.sort(
                    (a, b) => b.isNam.toString().compareTo(a.isNam.toString()),
                  );
                }
                setState(() {
                  asc = ascending;
                  sortIndex = columnIndex;
                });
              },
            ),
            DataColumn(
              label: const Text("Số điện thoại"),
              onSort: (columnIndex, ascending) {
                if (ascending) {
                  dsNguoiDung.sort(
                    (a, b) => a.soDienThoai!.compareTo(b.soDienThoai!),
                  );
                } else {
                  dsNguoiDung.sort(
                    (a, b) => b.soDienThoai!.compareTo(a.soDienThoai!),
                  );
                }
                setState(() {
                  asc = ascending;
                  sortIndex = columnIndex;
                });
              },
            ),
            DataColumn(
              label: const Text("Địa chỉ"),
              onSort: (columnIndex, ascending) {
                if (ascending) {
                  dsNguoiDung.sort(
                    (a, b) => a.diaChi!.compareTo(b.diaChi!),
                  );
                } else {
                  dsNguoiDung.sort(
                    (a, b) => b.diaChi!.compareTo(a.diaChi!),
                  );
                }
                setState(() {
                  asc = ascending;
                  sortIndex = columnIndex;
                });
              },
            ),
          ],
          source: NguoiDungDataSource(),
        ),
      ),
    );
  }
}

class NguoiDungDataSource extends DataTableSource {
  List<bool> selectedRowIndexs = dsNguoiDung.map((e) => false).toList();
  @override
  int get rowCount => dsNguoiDung.length;
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
          Text(dsNguoiDung[index].uid.toString()),
        ),
        DataCell(
          Text(dsNguoiDung[index].email),
        ),
        DataCell(
          Text(dsNguoiDung[index].hoTen),
        ),
        DataCell(
          Text(dsNguoiDung[index].isNam ? "Nam" : "Nữ"),
        ),
        DataCell(
          Text(dsNguoiDung[index].soDienThoai!),
        ),
        DataCell(
          Text(dsNguoiDung[index].diaChi!),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
