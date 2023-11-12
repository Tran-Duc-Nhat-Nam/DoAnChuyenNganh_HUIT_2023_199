class NguoiDung
{
  String? email;
  String? matKhau;
  String? hoTen;
  String? gioiTinh;
  String? sdt;

  NguoiDung({
    this.email,
    this.matKhau,
    this.hoTen,
    this.gioiTinh,
    this.sdt,
  });

  factory NguoiDung.fromJson(Map<String, dynamic> json) {
    return NguoiDung(
      email: json['email'],
      matKhau: json['matkhau'],
      gioiTinh: json['gioitinh'],
      hoTen: json['hoten'],
      sdt: json['sdt'],
    );
  }
}