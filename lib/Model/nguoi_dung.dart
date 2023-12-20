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
}
