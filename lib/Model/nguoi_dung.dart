import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NguoiDung {
  String uid;
  String email;
  String hoTen;
  bool isNam;
  String? diaChi;
  String? soDienThoai;
  DateTime? ngaySinh;
  bool isAdmin;

  NguoiDung({
    required this.uid,
    required this.email,
    required this.hoTen,
    required this.isNam,
    this.isAdmin = false,
    this.diaChi,
    this.soDienThoai,
    this.ngaySinh,
  });

  factory NguoiDung.fromJson(Map<String, dynamic> json) {
    return NguoiDung(
      uid: json['uid'],
      email: json['email'],
      isNam: json['gioitinh'] == "Nam",
      hoTen: json['hoten'],
      diaChi: json['diachi'],
    );
  }

  static Future<NguoiDung?> docNguoiDung(String uid) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>;

    User user = FirebaseAuth.instance.currentUser!;

    return NguoiDung(
      uid: user.uid,
      email: user.email!,
      hoTen: data["hoTen"],
      isNam: data["isNam"],
      diaChi: data["diaChi"],
      soDienThoai: data["soDienThoai"],
      ngaySinh: (data["ngaySinh"] as Timestamp).toDate(),
      isAdmin: data["isAdmin"],
    );
  }

  static Future<List<NguoiDung>> docDanhSachNguoiDung() async {
    var query = await FirebaseFirestore.instance.collection("users").get();

    List<NguoiDung> dsNguoiDung = [];

    for (var doc in query.docs) {
      Map<String, dynamic>? data = doc.data();
      dsNguoiDung.add(NguoiDung(
        uid: doc.id,
        email: data["email"],
        hoTen: data["hoTen"],
        isNam: data["isNam"],
        diaChi: data["diaChi"],
        soDienThoai: data["soDienThoai"],
        ngaySinh: (data["ngaySinh"] as Timestamp).toDate(),
        isAdmin: data["isAdmin"],
      ));
    }

    return dsNguoiDung;
  }

  Future<void> themNguoiDung() {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return users
        .doc(uid)
        .set({
          'email': email,
          'hoTen': hoTen,
          'soDienThoai': soDienThoai,
          'diaChi': diaChi,
          'isNam': isNam,
          'ngaySinh': ngaySinh,
          'isAdmin': isAdmin,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<bool> xoaNguoiDung(String password) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    User user = FirebaseAuth.instance.currentUser!;
    await user.reauthenticateWithCredential(EmailAuthProvider.credential(
      email: email,
      password: password,
    ));
    bool kq = false;

    await user.delete();
    await users
        .doc(uid)
        .delete()
        .then((value) => kq = true)
        .catchError((error) => kq = false);

    return kq;
  }
}
