import 'package:filcnaplo/theme.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
SnackBar CustomSnackBar({
  required Widget content,
  required BuildContext context,
  Brightness? brightness,
  Color? backgroundColor,
  Duration? duration,
}) {
  // backgroundColor > Brightness > Theme Background
  Color _backgroundColor = backgroundColor ??
      (((brightness ?? Theme.of(context).brightness) == Brightness.light) ? LightAppColors().highlight : DarkAppColors().highlight);

  Color textColor = ((brightness ?? Theme.of(context).brightness) == Brightness.light) ? LightAppColors().text : DarkAppColors().text;

  return SnackBar(
    duration: duration ?? const Duration(seconds: 4),
    content: Container(
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(6.0),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.15), blurRadius: 4.0)],
      ),
      padding: const EdgeInsets.all(12.0),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: textColor, fontWeight: FontWeight.w500),
        child: content,
      ),
    ),
    backgroundColor: const Color(0x00000000),
    elevation: 0,
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
  );
}
