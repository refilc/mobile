import 'package:flutter/widgets.dart';

class GradientStyles {
  static final tinta = Paint()
    ..shader = const LinearGradient(
      colors: [Color(0xffB816E0), Color(0xff17D1BB)],
    ).createShader(const Rect.fromLTWH(0, 0, 200, 70));

  static final kupak = Paint()
    ..shader = const LinearGradient(
      colors: [Color(0xffF0BD0C), Color(0xff0CD070)],
    ).createShader(const Rect.fromLTWH(0, 0, 200, 70));
}
