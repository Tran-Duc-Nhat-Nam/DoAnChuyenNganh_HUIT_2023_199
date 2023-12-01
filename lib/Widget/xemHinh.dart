import 'package:app_dac_san/Service/thu_vien_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class xemHinh extends StatelessWidget{
  final String link;
  xemHinh(this.link);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return RotatedBox(
            quarterTurns: orientation == Orientation.landscape ? 4 : 0,
            child: InteractiveViewer(
              maxScale: 5.0, // Giới hạn tốc độ zoom-in
              minScale: 0.5, // Giới hạn tốc độ zoom-out
              child: Container(
                color: Color.fromARGB(225, 104, 163, 187),
                width: double.infinity,
                height: 300,
                alignment: Alignment.center,
                child: Hero(
                    tag: 'hinhDS',
                    child: Image.network(
                        link as String,
                        fit: BoxFit.cover,
                        width: double.infinity, // Đặt chiều rộng mong muốn
                        height: 300
                    )),
              ),
            ),
          );
        },
      ),
    );
  }

}