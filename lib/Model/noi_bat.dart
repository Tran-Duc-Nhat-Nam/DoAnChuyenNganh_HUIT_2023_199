class NoiBat
{
  int? idNoiBat;
  int? idDacSan;

  NoiBat({
    this.idNoiBat,
    this.idDacSan,
  });

  factory NoiBat.fromJson(Map<String, dynamic> json) {
    return NoiBat(
      idNoiBat: json['idnoibat'],
      idDacSan: json['iddacsan'],
    );
  }
}