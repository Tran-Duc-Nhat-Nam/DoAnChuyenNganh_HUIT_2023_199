class VungMien {
  int idMien;
  String tenMien;

  VungMien({
    required this.idMien,
    required this.tenMien,
  });

  factory VungMien.fromJson(Map<String, dynamic> json) {
    return VungMien(
      idMien: json['idmien'],
      tenMien: json['tenmien'],
    );
  }
}
