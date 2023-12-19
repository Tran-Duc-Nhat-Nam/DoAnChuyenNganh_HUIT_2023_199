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
  );
}
