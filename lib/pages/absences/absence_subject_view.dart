import 'package:filcnaplo/helpers/subject_icon.dart';
import 'package:filcnaplo_kreta_api/models/absence.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence/absence_viewable.dart';
import 'package:filcnaplo_mobile_ui/common/hero_scrollview.dart';
import 'package:filcnaplo_mobile_ui/pages/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AbsenceSubjectView extends StatelessWidget {
  const AbsenceSubjectView(this.subject, {Key? key, this.absences = const []}) : super(key: key);

  final Subject subject;
  final List<Absence> absences;

  static void show(Subject subject, List<Absence> absences, {required BuildContext context}) {
    Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(builder: (context) => AbsenceSubjectView(subject, absences: absences)));
  }

  @override
  Widget build(BuildContext context) {
    final dateWidgets = absences
        .map((a) => DateWidget(
              widget: AbsenceViewable(a, padding: EdgeInsets.zero),
              date: a.date,
            ))
        .toList();
    List<Widget> absenceTiles = sortDateWidgets(context, dateWidgets: dateWidgets, padding: EdgeInsets.zero);

    return Scaffold(
      body: HeroScrollView(
        title: subject.name,
        icon: SubjectIcon.lookup(subject: subject),
        child: CupertinoScrollbar(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            shrinkWrap: true,
            itemBuilder: (context, index) => absenceTiles[index],
            itemCount: absenceTiles.length,
          ),
        ),
      ),
    );
  }
}
