import 'package:cloud_firestore/cloud_firestore.dart';

class LoaiDacSan {
  String idLoai;
  String tenLoai;

  LoaiDacSan({
    required this.idLoai,
    required this.tenLoai,
  });

  factory LoaiDacSan.fromJson(Map<String, dynamic> json) {
    return LoaiDacSan(
      idLoai: json['idloai'],
      tenLoai: json['tenloai'],
    );
  }

  static Future<LoaiDacSan?> doc(String idLoai) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("loaiDacSan")
        .doc(idLoai)
        .get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>;

    return LoaiDacSan(
      idLoai: snapshot.id,
      tenLoai: data["tenLoai"],
    );
  }

  static Future<List<LoaiDacSan>> docDanhSach() async {
    var query = await FirebaseFirestore.instance.collection("loaiDacSan").get();

    List<LoaiDacSan> dsLoaiDacSan = [];

    for (var doc in query.docs) {
      Map<String, dynamic>? data = doc.data();
      dsLoaiDacSan.add(LoaiDacSan(
        idLoai: doc.id.toString(),
        tenLoai: data["tenLoai"],
      ));
    }

    dsLoaiDacSan.sort(
      (a, b) {
        return a.idLoai.compareTo(b.idLoai);
      },
    );

    return dsLoaiDacSan;
  }

  static Future<bool> them(String tenLoai) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('loaiDacSan');
    var query = await collection.get();
    bool kq = false;
    await collection
        .add({
          'tenLoai': tenLoai,
        })
        .then((value) => kq = true)
        .catchError((error) => kq = false);
    return kq;
  }

  Future<bool> capNhat() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('loaiDacSan');
    bool kq = false;
    await collection
        .doc(idLoai.toString())
        .set({
          'tenLoai': tenLoai,
        })
        .then((value) => kq = true)
        .catchError((error) => kq = false);
    return kq;
  }

  Future<bool> xoa() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('loaiDacSan');
    bool kq = false;
    await collection.doc(idLoai.toString()).delete().then((value) {
      kq = true;
      print("Xóa loại đặc sản $tenLoai thành công");
    }).catchError((error) {
      kq = false;
      print("Xóa loại đặc sản $tenLoai thất bại");
      return null;
    });

    return kq;
  }
}
