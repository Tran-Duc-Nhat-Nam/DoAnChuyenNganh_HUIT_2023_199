import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vina_foods/Model/nguoi_dung.dart';

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
      })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}
