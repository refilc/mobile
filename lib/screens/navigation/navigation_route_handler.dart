import 'package:filcnaplo_mobile_ui/pages/absences/absences_page.dart';
import 'package:filcnaplo_mobile_ui/pages/grades/grades_page.dart';
import 'package:filcnaplo_mobile_ui/pages/home/home_page.dart';
import 'package:filcnaplo_mobile_ui/pages/messages/messages_page.dart';
import 'package:filcnaplo_mobile_ui/pages/timetable/timetable_page.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

Route navigationRouteHandler(RouteSettings settings) {
  switch (settings.name) {
    case "home":
      return navigationPageRoute((context) => HomePage());
    case "grades":
      return navigationPageRoute((context) => GradesPage());
    case "timetable":
      return navigationPageRoute((context) => TimetablePage());
    case "messages":
      return navigationPageRoute((context) => MessagesPage());
    case "absences":
      return navigationPageRoute((context) => AbsencesPage());
    default:
      return navigationPageRoute((context) => HomePage());
  }
}

Route navigationPageRoute(Widget Function(BuildContext) builder) {
  return PageRouteBuilder(
    pageBuilder: (context, _, __) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeThroughTransition(
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: child,
      );
    },
  );
}
