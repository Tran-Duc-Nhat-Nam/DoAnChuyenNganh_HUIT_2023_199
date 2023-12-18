class DacSan {
  int idDacSan;
  String tenDacSan;
  int? avatar;
  String? moTa;
  String? thanhPhan;
  int xuatXu;
  int idMien;
  int loaiDacSan;

  DacSan({
    required this.idDacSan,
    required this.tenDacSan,
    this.avatar,
    this.moTa,
    this.thanhPhan,
    required this.xuatXu,
    required this.idMien,
    required this.loaiDacSan,
  });

  factory DacSan.fromJson(Map<String, dynamic> json) {
    return DacSan(
      idDacSan: json['iddacsan'],
      tenDacSan: json['tendacsan'],
      avatar: json['avatar'],
      moTa: json['mota'],
      thanhPhan: json['thanhphan'],
      xuatXu: json['xuatxu'],
      idMien: json['idmien'],
      loaiDacSan: json['loaidacsan'],
    );
  }
}
