import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ManHinhLoading extends StatelessWidget {
  const ManHinhLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
}
