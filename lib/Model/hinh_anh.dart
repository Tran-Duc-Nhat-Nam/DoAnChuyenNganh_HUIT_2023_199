import 'package:cloud_firestore/cloud_firestore.dart';

class HinhAnh {
  String idAnh;
  String idDacSan;
  String link;
  String? moTa;

  HinhAnh({
    required this.idAnh,
    required this.idDacSan,
    required this.link,
    this.moTa,
  });

  factory HinhAnh.fromJson(Map<String, dynamic> json) {
    return HinhAnh(
      idAnh: json['idanh'],
      idDacSan: json['iddacsan'],
      link: json['link'],
      moTa: json['mota'],
    );
  }

  static Future<HinhAnh?> doc(String idHinhAnh) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("hinhAnh")
        .doc(idHinhAnh)
        .get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>;

    return HinhAnh(
      idAnh: snapshot.id,
      idDacSan: data["idDacSan"],
      link: data["link"],
      moTa: data["moTa"],
    );
  }

  static Future<List<HinhAnh>> docDanhSach() async {
    var query = await FirebaseFirestore.instance.collection("hinhAnh").get();

    List<HinhAnh> ds = [];

    for (var doc in query.docs) {
      Map<String, dynamic>? data = doc.data();
      ds.add(HinhAnh(
        idAnh: doc.id.toString(),
        idDacSan: data["idDacSan"].toString(),
        link: data["link"],
        moTa: data["moTa"],
      ));
    }

    ds.sort(
      (a, b) {
        return a.idAnh.compareTo(b.idAnh);
      },
    );

    return ds;
  }

  static Future<bool> them(int idDacSan, String link, String? moTa) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('hinhAnh');
    var query = await collection.get();
    bool kq = false;
    await collection
        .add({
          'idDacSan': idDacSan,
          'link': link,
          'moTa': moTa,
        })
        .then((value) => kq = true)
        .catchError((error) => kq = false);
    return kq;
  }

  static Future<bool> themDanhSach(List<HinhAnh> dachSachHinhAnh) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('hinhAnh');
    bool kq = false;
    for (var hinhAnh in dachSachHinhAnh) {
      await collection
          .add({
            'idDacSan': hinhAnh.idDacSan,
            'link': hinhAnh.link,
            'moTa': hinhAnh.moTa,
          })
          .then((value) => kq = true)
          .catchError((error) => kq = false);
    }
    print("Done");
    return kq;
  }

  Future<bool> capNhat() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('hinhAnh');
    bool kq = false;
    await collection
        .doc(idAnh.toString())
        .set({
          'idDacSan': idDacSan,
          'link': link,
          'moTa': moTa,
        })
        .then((value) => kq = true)
        .catchError((error) => kq = false);
    return kq;
  }

  static Future<bool> capNhatDanhSach(List<HinhAnh> dachSachHinhAnh) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('hinhAnh');
    bool kq = false;
    for (var hinhAnh in dachSachHinhAnh) {
      await collection
          .doc(hinhAnh.idAnh.toString())
          .set({
            'idDacSan': hinhAnh.idDacSan,
            'link': hinhAnh.link,
            'moTa': hinhAnh.moTa,
          })
          .then((value) => kq = true)
          .catchError((error) => kq = false);
    }
    print("Done");
    return kq;
  }

  Future<bool> xoa() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('hinhAnh');
    bool kq = false;
    await collection.doc(idAnh.toString()).delete().then((value) {
      kq = true;
      print("Xóa hình $idAnh thành công");
    }).catchError((error) {
      kq = false;
      print("Xóa hình $idAnh thất bại");
      return null;
    });

    return kq;
  }
}
