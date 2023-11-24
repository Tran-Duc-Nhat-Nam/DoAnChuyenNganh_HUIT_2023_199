class NguoiDung {
  String uid;
  String email;
  String hoTen;
  String gioiTinh;
  String? diaChi;

  NguoiDung({
    required this.uid,
    required this.email,
    required this.hoTen,
    required this.gioiTinh,
    this.diaChi,
  });

  factory NguoiDung.fromJson(Map<String, dynamic> json) {
    return NguoiDung(
      uid: json['uid'],
      email: json['email'],
      gioiTinh: json['gioitinh'],
      hoTen: json['hoten'],
      diaChi: json['diachi'],
    );
  }
}
