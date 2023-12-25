import 'package:cloud_firestore/cloud_firestore.dart';

class VungMien {
  String idVungMien;
  String tenVungMien;

  VungMien({
    required this.idVungMien,
    required this.tenVungMien,
  });

  factory VungMien.fromJson(Map<String, dynamic> json) {
    return VungMien(
      idVungMien: json['idmien'],
      tenVungMien: json['tenmien'],
    );
  }

  static Future<VungMien?> doc(String idVungMien) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("vungMien")
        .doc(idVungMien)
        .get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>;

    return VungMien(
      idVungMien: snapshot.id,
      tenVungMien: data["tenVungMien"],
    );
  }

  static Future<List<VungMien>> docDanhSach() async {
    var query = await FirebaseFirestore.instance.collection("vungMien").get();

    List<VungMien> ds = [];

    for (var doc in query.docs) {
      Map<String, dynamic>? data = doc.data();
      ds.add(VungMien(
        idVungMien: doc.id.toString(),
        tenVungMien: data["tenVungMien"],
      ));
    }

    ds.sort(
      (a, b) {
        return a.idVungMien.compareTo(b.idVungMien);
      },
    );

    return ds;
  }

  static Future<bool> them(String tenVungMien) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('vungMien');
    var query = await collection.get();
    bool kq = false;
    await collection
        .add({
          'tenVungMien': tenVungMien,
        })
        .then((value) => kq = true)
        .catchError((error) => kq = false);
    return kq;
  }

  Future<bool> capNhat() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('vungMien');
    bool kq = false;
    await collection
        .doc(idVungMien.toString())
        .set({
          'tenVungMien': tenVungMien,
        })
        .then((value) => kq = true)
        .catchError((error) => kq = false);
    return kq;
  }

  Future<bool> xoa() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('vungMien');
    bool kq = false;
    await collection.doc(idVungMien.toString()).delete().then((value) {
      kq = true;
      print("Xóa vùng miền $tenVungMien thành công");
    }).catchError((error) {
      kq = false;
      print("Xóa vùng miền $tenVungMien thất bại");
      return null;
    });

    return kq;
  }
}
