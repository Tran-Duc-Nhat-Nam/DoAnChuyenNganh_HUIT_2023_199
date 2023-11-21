class LoaiDacSan {
  String idLoai;
  String tenLoai;

  LoaiDacSan({
    required this.idLoai,
    required this.tenLoai
  });

  factory LoaiDacSan.fromJson(Map<String, dynamic> json) {
    return LoaiDacSan(
      idLoai: json['idloai'],
      tenLoai: json['tenloai'],
    );
  }
}
