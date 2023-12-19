import 'package:flutter/material.dart';
import 'package:vina_foods/Widget/hinh_cache.dart';

class PreviewHinh extends StatelessWidget {
  final String link;
  const PreviewHinh(this.link, {super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return RotatedBox(
            quarterTurns: orientation == Orientation.landscape ? 4 : 0,
            child: InteractiveViewer(
              maxScale: 2.0,
              minScale: 0.5,
              child: Container(
                color: Theme.of(context).shadowColor,
                width: double.infinity,
                height: 300,
                alignment: Alignment.center,
                child: HinhCache(link, 300),
              ),
            ),
          );
        },
      ),
    );
  }
}
