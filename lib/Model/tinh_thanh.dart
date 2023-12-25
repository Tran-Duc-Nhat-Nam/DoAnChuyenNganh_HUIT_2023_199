import 'package:cloud_firestore/cloud_firestore.dart';

class TinhThanh {
  String idTinhThanh;
  String tenTinhThanh;

  TinhThanh({
    required this.idTinhThanh,
    required this.tenTinhThanh,
  });

  factory TinhThanh.fromJson(Map<String, dynamic> json) {
    return TinhThanh(
      idTinhThanh: json['idtinh'],
      tenTinhThanh: json['tentinh'],
    );
  }

  static Future<TinhThanh?> doc(String idLoai) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("tinhThanh")
        .doc(idLoai)
        .get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>;

    return TinhThanh(
      idTinhThanh: snapshot.id,
      tenTinhThanh: data["tenTinhThanh"],
    );
  }

  static Future<List<TinhThanh>> docDanhSach() async {
    var query = await FirebaseFirestore.instance.collection("tinhThanh").get();

    List<TinhThanh> dsLoaiDacSan = [];

    for (var doc in query.docs) {
      Map<String, dynamic>? data = doc.data();
      dsLoaiDacSan.add(TinhThanh(
        idTinhThanh: doc.id.toString(),
        tenTinhThanh: data["tenTinhThanh"],
      ));
    }

    dsLoaiDacSan.sort(
      (a, b) {
        return a.idTinhThanh.compareTo(b.idTinhThanh);
      },
    );

    return dsLoaiDacSan;
  }

  static Future<bool> them(String tenTinhThanh) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('tinhThanh');
    var query = await collection.get();
    bool kq = false;
    await collection
        .add({
          'tenTinhThanh': tenTinhThanh,
        })
        .then((value) => kq = true)
        .catchError((error) => kq = false);
    return kq;
  }

  Future<bool> capNhat() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('tinhThanh');
    bool kq = false;
    await collection
        .doc(idTinhThanh.toString())
        .set({
          'tenTinhThanh': tenTinhThanh,
        })
        .then((value) => kq = true)
        .catchError((error) => kq = false);
    return kq;
  }

  Future<bool> xoa() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('tinhThanh');
    bool kq = false;
    await collection.doc(idTinhThanh.toString()).delete().then((value) {
      kq = true;
      print("Xóa tỉnh thành $tenTinhThanh thành công");
    }).catchError((error) {
      kq = false;
      print("Xóa tỉnh thành $tenTinhThanh thất bại");
      return null;
    });

    return kq;
  }
}
