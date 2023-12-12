// ignore_for_file: non_constant_identifier_names

import 'package:app_dac_san/Service/thu_vien_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Widget LoadHinh(String duongDan) {
  return Image.asset(duongDan);
}

Widget LoadingScreen() {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    body: Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.cyanAccent,
        size: 100,
      ),
    ),
  );
}

CachedNetworkImage cachedImage(int id) {
  return CachedNetworkImage(
    progressIndicatorBuilder: (context, url, downloadProgress) =>
        LinearProgressIndicator(value: downloadProgress.progress),
    errorWidget: (context, url, error) => const Icon(Icons.error),
    imageUrl: getURLImage(id),
    fit: BoxFit.cover,
    height: 150,
  );
}
