class NguoiDung {
  String email;
  String hoTen;
  String gioiTinh;
  String? sdt;
  String? diaChi;

  NguoiDung({
    required this.email,
    required this.hoTen,
    required this.gioiTinh,
    this.sdt,
    this.diaChi,
  });

  factory NguoiDung.fromJson(Map<String, dynamic> json) {
    return NguoiDung(
      email: json['email'],
      gioiTinh: json['gioitinh'],
      hoTen: json['hoten'],
      sdt: json['sdt'],
      diaChi: json['diachi'],
    );
  }
}
