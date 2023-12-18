class NguoiDung {
  String uid;
  String email;
  String hoTen;
  bool isNam;
  String? diaChi;
  String? soDienThoat;
  DateTime? ngaySinh;

  NguoiDung({
    required this.uid,
    required this.email,
    required this.hoTen,
    required this.isNam,
    this.diaChi,
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
}
