class NoiBat {
  int idNoiBat;
  int idDacSan;

  NoiBat({
    required this.idNoiBat,
    required this.idDacSan,
  });

  factory NoiBat.fromJson(Map<String, dynamic> json) {
    return NoiBat(
      idNoiBat: json['idnoibat'],
      idDacSan: json['iddacsan'],
    );
  }
}
