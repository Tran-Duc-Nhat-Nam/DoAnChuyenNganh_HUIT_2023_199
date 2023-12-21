import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Model/nguoi_dung.dart';

Future<NguoiDung?> docNguoiDung(String uid) async {
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

Future<List<NguoiDung>> docDanhSachNguoiDung() async {
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

Future<void> themNguoiDung(NguoiDung nguoiDung) {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  // Call the user's CollectionReference to add a new user
  return users
      .doc(nguoiDung.uid)
      .set({
        'email': nguoiDung.email,
        'hoTen': nguoiDung.hoTen,
        'soDienThoai': nguoiDung.soDienThoai,
        'diaChi': nguoiDung.diaChi,
        'isNam': nguoiDung.isNam,
        'ngaySinh': nguoiDung.ngaySinh,
        'isAdmin': nguoiDung.isAdmin,
      })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}
