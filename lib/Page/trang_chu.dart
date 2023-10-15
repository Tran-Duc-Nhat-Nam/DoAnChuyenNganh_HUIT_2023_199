import 'package:flutter/material.dart';

class TrangChu extends StatefulWidget {
  const TrangChu({
    super.key,
    required this.text,
  });

  final String text;

  @override
  State<TrangChu> createState() => _TrangChuState();
}

class _TrangChuState extends State<TrangChu> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Text("Xin chào ${widget.text}")),
      ],
    );
  }
}
