class HinhAnh
{
  int? idAnh;
  int? idDacSan;
  String? link;
  String? moTa;

  HinhAnh({
    this.idAnh,
    this.idDacSan,
    this.link,
    this.moTa,
  });

  factory HinhAnh.fromJson(Map<String, dynamic> json) {
    return HinhAnh(
      idAnh: json['idanh'],
      idDacSan: json['iddacsan'],
      link: json['link'],
      moTa: json['mota'],
    );
  }
}