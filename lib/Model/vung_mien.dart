class VungMien
{
  int? idMien;
  String? tenMien;

  VungMien({
    this.idMien,
    this.tenMien,
  });

  factory VungMien.fromJson(Map<String, dynamic> json) {
    return VungMien(
      idMien: json['idmien'],
      tenMien: json['tenmien'],
    );
  }
}