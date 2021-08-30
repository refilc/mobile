import 'package:filcnaplo_mobile_ui/pages/absences/absences_page.dart';
import 'package:filcnaplo_mobile_ui/pages/grades/grades_page.dart';
import 'package:filcnaplo_mobile_ui/pages/home/home_page.dart';
import 'package:filcnaplo_mobile_ui/pages/messages/messages_page.dart';
import 'package:filcnaplo_mobile_ui/pages/timetable/timetable_page.dart';
import 'package:flutter/material.dart';

Route navigationRouteHandler(RouteSettings settings) {
  switch (settings.name) {
    case "home":
      return _pageRoute((context) => HomePage());
    case "grades":
      return _pageRoute((context) => GradesPage());
    case "timetable":
      return _pageRoute((context) => TimetablePage());
    case "messages":
      return _pageRoute((context) => MessagesPage());
    case "absences":
      return _pageRoute((context) => AbsencesPage());
    default:
      return _pageRoute((context) => HomePage());
  }
}

_pageRoute(Widget Function(BuildContext) builder) {
  return PageRouteBuilder(
    pageBuilder: (context, _, __) => builder(context),
    transitionDuration: Duration(milliseconds: 100),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var tween = Tween(begin: 0.0, end: 1.0);
      var offsetAnimation = animation.drive(tween);

      return FadeTransition(
        opacity: offsetAnimation,
        child: child,
      );
    },
  );
}
