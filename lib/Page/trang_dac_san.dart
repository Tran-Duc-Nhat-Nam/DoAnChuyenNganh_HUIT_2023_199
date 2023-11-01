import 'package:flutter/material.dart';

class TrangDacSan extends StatefulWidget {
  const TrangDacSan({super.key});

  @override
  _TrangDacSanState createState() => _TrangDacSanState();
}

class _TrangDacSanState extends State<TrangDacSan> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            ListNgang(),
            ListNgang(),
            ListNgang(),
            ListNgang(),
            ListNgang(),
            ListNgang(),
            ListNgang(),
            ListNgang(),
            ListNgang(),
            ListNgang(),
            ListNgang(),
            ListNgang(),
            ListNgang(),
          ],
        ),
      ),
    );
  }
}

class ListNgang extends StatelessWidget {
  const ListNgang({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              ListNgangItem(),
              ListNgangItem(),
              ListNgangItem(),
              ListNgangItem(),
              ListNgangItem(),
              ListNgangItem(),
              ListNgangItem(),
              ListNgangItem(),
              ListNgangItem(),
              ListNgangItem(),
            ],
          ),
        ),
      ),
    );
  }
}

class ListNgangItem extends StatelessWidget {
  const ListNgangItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: ElevatedButton(onPressed: () {}, child: const Text("Item")),
    );
  }
}
