import 'dart:io';

import 'package:filcnaplo/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void setSystemChrome(BuildContext context) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,
    systemNavigationBarColor: AppColors.of(context).background,
    systemNavigationBarIconBrightness: Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light,
    statusBarBrightness: Platform.isIOS ? Theme.of(context).brightness : null,
  ));
}
