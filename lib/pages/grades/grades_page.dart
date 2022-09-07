import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:filcnaplo/api/providers/update_provider.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_kreta_api/models/group_average.dart';
import 'package:filcnaplo_mobile_ui/common/average_display.dart';
import 'package:filcnaplo_mobile_ui/common/empty.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_button.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_image.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/statistics_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/grade/grade_subject_tile.dart';
import 'package:filcnaplo_mobile_ui/common/trend_display.dart';
import 'package:filcnaplo_mobile_ui/pages/grades/graph.dart';
import 'package:filcnaplo_mobile_ui/pages/grades/grade_subject_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo/utils/color.dart';
import 'package:filcnaplo/helpers/average_helper.dart';
import 'grades_page.i18n.dart';

class GradesPage extends StatefulWidget {
  const GradesPage({Key? key}) : super(key: key);

  @override
  _GradesPageState createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  late UserProvider user;
  late GradeProvider gradeProvider;
  late UpdateProvider updateProvider;
  late String firstName;
  late Widget yearlyGraph;
  List<Widget> subjectTiles = [];

  List<Grade> getSubjectGrades(Subject subject) => gradeProvider.grades.where((e) => e.subject == subject && e.type == GradeType.midYear).toList();

  void generateTiles() {
    List<Subject> subjects = gradeProvider.grades.map((e) => e.subject).toSet().toList()..sort((a, b) => a.name.compareTo(b.name));
    List<Widget> tiles = [];

    List<double> subjectAvgs = [];

    tiles.addAll(subjects.map((subject) {
      List<Grade> subjectGrades = getSubjectGrades(subject);

      double avg = AverageHelper.averageEvals(subjectGrades);
      var nullavg = GroupAverage(average: 0.0, subject: subject, uid: "0");
      double groupAverage = gradeProvider.groupAverages.firstWhere((e) => e.subject == subject, orElse: () => nullavg).average;

      if (avg != 0) subjectAvgs.add(avg);

      return GradeSubjectTile(subject, average: avg, groupAverage: groupAverage, onTap: () {
        GradeSubjectView(subject, groupAverage: groupAverage).push(context, root: true);
      });
    }));

    if (tiles.isNotEmpty) {
      tiles.insert(0, yearlyGraph);
      tiles.insert(1, PanelTitle(title: Text("Subjects".i18n)));
      tiles.insert(2, const PanelHeader(padding: EdgeInsets.only(top: 12.0)));
      tiles.add(const PanelFooter(padding: EdgeInsets.only(bottom: 12.0)));
      tiles.add(const Padding(padding: EdgeInsets.only(bottom: 24.0)));
    } else {
      tiles.insert(
        0,
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Empty(subtitle: "empty".i18n),
        ),
      );
    }

    double subjectAvg = subjectAvgs.isNotEmpty ? subjectAvgs.fold(0.0, (double a, double b) => a + b) / subjectAvgs.length : 0.0;
    final double classAvg = gradeProvider.groupAverages.isNotEmpty
        ? gradeProvider.groupAverages.map((e) => e.average).fold(0.0, (double a, double b) => a + b) / gradeProvider.groupAverages.length
        : 0.0;

    if (subjectAvg > 0) {
      tiles.add(Row(
        children: [
          Expanded(
            child: StatisticsTile(
              title: AutoSizeText(
                "subjectavg".i18n,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              value: subjectAvg,
            ),
          ),
          const SizedBox(width: 24.0),
          Expanded(
            child: StatisticsTile(
              title: AutoSizeText(
                "classavg".i18n,
                textAlign: TextAlign.center,
                maxLines: 2,
                wrapWords: false,
                overflow: TextOverflow.ellipsis,
              ),
              value: classAvg,
            ),
          ),
        ],
      ));
    }

    // padding
    tiles.add(const SizedBox(height: 32.0));

    subjectTiles = List.castFrom(tiles);
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    gradeProvider = Provider.of<GradeProvider>(context);
    updateProvider = Provider.of<UpdateProvider>(context);

    List<String> nameParts = user.name?.split(" ") ?? ["?"];
    firstName = nameParts.length > 1 ? nameParts[1] : nameParts[0];

    final double totalClassAvg = gradeProvider.groupAverages.isEmpty
        ? 0.0
        : gradeProvider.groupAverages.map((e) => e.average).fold(0.0, (double a, double b) => a + b) / gradeProvider.groupAverages.length;

    final now = gradeProvider.grades.isNotEmpty ? gradeProvider.grades.reduce((v, e) => e.date.isAfter(v.date) ? e : v).date : DateTime.now();

    final currentStudentAvg = AverageHelper.averageEvals(gradeProvider.grades.where((e) => e.type == GradeType.midYear).toList());
    final prevStudentAvg = AverageHelper.averageEvals(gradeProvider.grades
        .where((e) => e.type == GradeType.midYear)
        .where((e) => e.date.isBefore(now.subtract(const Duration(days: 30))))
        .toList());

    yearlyGraph = Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 24.0),
      child: Panel(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("annual_average".i18n),
            Row(
              children: [
                // if (totalClassAvg >= 1.0) AverageDisplay(average: totalClassAvg, border: true),
                // const SizedBox(width: 4.0),
                TrendDisplay(previous: prevStudentAvg, current: currentStudentAvg),
                if (gradeProvider.grades.where((e) => e.type == GradeType.midYear).isNotEmpty) AverageDisplay(average: currentStudentAvg),
              ],
            )
          ],
        ),
        child: Container(
          height: 165.0,
          padding: const EdgeInsets.only(top: 12.0, right: 12.0),
          child: GradeGraph(gradeProvider.grades.where((e) => e.type == GradeType.midYear).toList(), dayThreshold: 2, classAvg: totalClassAvg),
        ),
      ),
    );

    generateTiles();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 9.0),
        child: NestedScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              centerTitle: false,
              pinned: true,
              floating: false,
              snap: false,
              actions: [
                // Profile Icon
                Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: ProfileButton(
                    child: ProfileImage(
                      heroTag: "profile",
                      name: firstName,
                      backgroundColor: ColorUtils.stringToColor(user.name ?? "?"),
                      badge: updateProvider.available,
                      role: user.role,
                    ),
                  ),
                ),
              ],
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Grades".i18n,
                  style: TextStyle(color: AppColors.of(context).text, fontSize: 32.0, fontWeight: FontWeight.bold),
                ),
              ),
              shadowColor: AppColors.of(context).shadow.withOpacity(0.5),
            ),
          ],
          body: RefreshIndicator(
            onRefresh: () => gradeProvider.fetch(),
            color: Theme.of(context).colorScheme.secondary,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              itemCount: max(subjectTiles.length, 1),
              itemBuilder: (context, index) {
                if (subjectTiles.isNotEmpty) {
                  EdgeInsetsGeometry panelPadding = const EdgeInsets.symmetric(horizontal: 24.0);

                  if (subjectTiles[index].runtimeType == GradeSubjectTile) {
                    return Padding(
                        padding: panelPadding,
                        child: PanelBody(
                          child: subjectTiles[index],
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        ));
                  } else {
                    return Padding(padding: panelPadding, child: subjectTiles[index]);
                  }
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
