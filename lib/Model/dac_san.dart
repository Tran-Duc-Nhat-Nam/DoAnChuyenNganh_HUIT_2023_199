class DacSan
{
  int? idDacSan;
  String? tenDacSan;
  int? avatar;
  String? moTa;
  String? thanhPhan;
  int? xuatXu;
  int? idMien;

  DacSan({
    this.idDacSan,
    this.tenDacSan,
    this.avatar,
    this.moTa,
    this.thanhPhan,
    this.xuatXu,
    this.idMien,
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
    );
  }
}