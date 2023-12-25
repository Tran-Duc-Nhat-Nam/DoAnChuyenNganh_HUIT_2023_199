import 'package:cloud_firestore/cloud_firestore.dart';

class DacSan {
  String idDacSan;
  String tenDacSan;
  String? idHinhDaiDien;
  String? moTa;
  String? thanhPhan;
  String idTinhThanh;
  String idVungMien;
  String idLoai;

  DacSan({
    required this.idDacSan,
    required this.tenDacSan,
    this.idHinhDaiDien,
    this.moTa,
    this.thanhPhan,
    required this.idTinhThanh,
    required this.idVungMien,
    required this.idLoai,
  });

  factory DacSan.fromJson(Map<String, dynamic> json) {
    return DacSan(
      idDacSan: json['iddacsan'],
      tenDacSan: json['tendacsan'],
      idHinhDaiDien: json['avatar'],
      moTa: json['mota'],
      thanhPhan: json['thanhphan'],
      idTinhThanh: json['xuatxu'],
      idVungMien: json['idmien'],
      idLoai: json['loaidacsan'],
    );
  }

  static Future<DacSan?> doc(String idHinhAnh) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("dacSan")
        .doc(idHinhAnh)
        .get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>;

    return DacSan(
      idDacSan: snapshot.id,
      tenDacSan: data['tenDacSan'],
      idHinhDaiDien: data['idHinhDaiDien'],
      moTa: data['moTa'],
      thanhPhan: data['thanhPhan'],
      idTinhThanh: data['idTinhThanh'],
      idVungMien: data['idVungMien'],
      idLoai: data['idLoai'],
    );
  }

  static Future<List<DacSan>> docDanhSach() async {
    var query = await FirebaseFirestore.instance.collection("dacSan").get();

    List<DacSan> ds = [];

    for (var doc in query.docs) {
      Map<String, dynamic>? data = doc.data();
      ds.add(DacSan(
        idDacSan: doc.id.toString(),
        tenDacSan: data['tenDacSan'],
        idHinhDaiDien: data['idHinhDaiDien'].toString(),
        moTa: data['moTa'],
        thanhPhan: data['thanhPhan'],
        idTinhThanh: data['idTinhThanh'].toString(),
        idVungMien: data['idVungMien'].toString(),
        idLoai: data['idLoai'].toString(),
      ));
    }

    ds.sort(
      (a, b) {
        return a.idDacSan.compareTo(b.idDacSan);
      },
    );

    return ds;
  }

  static Future<bool> them(String tenDacSan, int? idHinhDaiDien, String? moTa,
      String? thanhPhan, int idTinhThanh, int idVungMien, int idLoai) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('dacSan');
    bool kq = false;
    await collection
        .add({
          'tenDacSan': tenDacSan,
          'idHinhDaiDien': idHinhDaiDien,
          'moTa': moTa,
          'thanhPhan': thanhPhan,
          'idTinhThanh': idTinhThanh,
          'idVungMien': idVungMien,
          'idLoai': idLoai,
        })
        .then((value) => kq = true)
        .catchError((error) => kq = false);
    return kq;
  }

  static Future<bool> themDanhSach(List<DacSan> danhSachDacSan) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('dacSan');
    bool kq = false;
    for (var dacSan in danhSachDacSan) {
      await collection
          .add({
            'tenDacSan': dacSan.tenDacSan,
            'idHinhDaiDien': dacSan.idHinhDaiDien,
            'moTa': dacSan.moTa,
            'thanhPhan': dacSan.thanhPhan,
            'idTinhThanh': dacSan.idTinhThanh,
            'idVungMien': dacSan.idVungMien,
            'idLoai': dacSan.idLoai,
          })
          .then((value) => kq = true)
          .catchError((error) => kq = false);
    }
    print("Done");
    return kq;
  }

  Future<bool> capNhat() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('dacSan');
    bool kq = false;
    await collection
        .doc(idDacSan.toString())
        .set({
          'tenDacSan': tenDacSan,
          'idHinhDaiDien': idHinhDaiDien,
          'moTa': moTa,
          'thanhPhan': thanhPhan,
          'idTinhThanh': idTinhThanh,
          'idVungMien': idVungMien,
          'idLoai': idLoai,
        })
        .then((value) => kq = true)
        .catchError((error) => kq = false);
    return kq;
  }

  static Future<bool> capNhatDanhSach(List<DacSan> danhSachDacSan) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('dacSan');
    bool kq = false;
    for (var dacSan in danhSachDacSan) {
      await collection
          .doc(dacSan.idDacSan.toString())
          .set({
            'tenDacSan': dacSan.tenDacSan,
            'idHinhDaiDien': dacSan.idHinhDaiDien,
            'moTa': dacSan.moTa,
            'thanhPhan': dacSan.thanhPhan,
            'idTinhThanh': dacSan.idTinhThanh,
            'idVungMien': dacSan.idVungMien,
            'idLoai': dacSan.idLoai,
          })
          .then((value) => kq = true)
          .catchError((error) => kq = false);
    }
    print("Done");
    return kq;
  }

  Future<bool> xoa() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('dacSan');
    bool kq = false;
    await collection.doc(idDacSan.toString()).delete().then((value) {
      kq = true;
      print("Xóa đặc sản $tenDacSan thành công");
    }).catchError((error) {
      kq = false;
      print("Xóa đặc sản $tenDacSan thất bại");
      return null;
    });

    return kq;
  }
}
