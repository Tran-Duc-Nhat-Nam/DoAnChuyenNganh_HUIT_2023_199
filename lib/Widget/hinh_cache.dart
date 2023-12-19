import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

CachedNetworkImage HinhCache(String url, double height) {
  return CachedNetworkImage(
    progressIndicatorBuilder: (context, url, downloadProgress) =>
        LinearProgressIndicator(value: downloadProgress.progress),
    errorWidget: (context, url, error) => const Icon(Icons.error),
    imageUrl: url,
    fit: BoxFit.cover,
    height: height,
  );
}
