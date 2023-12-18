class TinhThanh {
  int maTT;
  String ten;

  TinhThanh({
    required this.maTT,
    required this.ten,
  });

  factory TinhThanh.fromJson(Map<String, dynamic> json) {
    return TinhThanh(
      maTT: json['idtinh'],
      ten: json['tentinh'],
    );
  }
}
