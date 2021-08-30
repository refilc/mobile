import 'dart:math';

import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_kreta_api/models/class_average.dart';
import 'package:filcnaplo_mobile_ui/common/empty.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_button.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_image.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/subject_tile.dart';
import 'package:filcnaplo_mobile_ui/pages/grades/graph.dart';
import 'package:filcnaplo_mobile_ui/pages/grades/subject_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo/utils/color.dart';
import 'package:filcnaplo/helpers/average_helper.dart';

// TODO: i18n
// TODO: maybe? statistics to the bottom

class GradesPage extends StatefulWidget {
  GradesPage({Key? key}) : super(key: key);

  @override
  _GradesPageState createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  late UserProvider user;
  late GradeProvider gradeProvider;
  late String firstName;
  late Widget yearlyGraph;
  List<Widget> subjectTiles = [];

  List<Grade> getSubjectGrades(Subject subject) => gradeProvider.grades.where((e) => e.subject == subject && e.type == GradeType.midYear).toList();

  void generateTiles() {
    List<Subject> subjects = gradeProvider.grades.map((e) => e.subject).toSet().toList()..sort((a, b) => a.name.compareTo(b.name));
    List<Widget> tiles = [];

    tiles.addAll(subjects.map((subject) {
      List<Grade> subjectGrades = getSubjectGrades(subject);

      double avg = AverageHelper.averageEvals(subjectGrades);
      var nullavg = ClassAverage(average: 0.0, subject: subject, uid: "0");
      double classAverage = gradeProvider.classAverages.firstWhere((e) => e.subject == subject, orElse: () => nullavg).average;

      return SubjectTile(subject, average: avg, groupAverage: classAverage, onTap: () {
        SubjectView(subject, classAverage: classAverage).push(context, root: true);
      });
    }));

    if (tiles.length > 0) {
      tiles.insert(0, yearlyGraph);
      tiles.insert(1, PanelTitle(title: Text("Subjects")));
      tiles.insert(2, PanelHeader(padding: EdgeInsets.only(top: 12.0)));
      tiles.add(PanelFooter(padding: EdgeInsets.only(bottom: 12.0)));
      tiles.add(Padding(padding: EdgeInsets.only(bottom: 24.0)));
    } else {
      tiles.insert(
        0,
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Empty(subtitle: "You don't have any subjects."),
        ),
      );
    }

    subjectTiles = List.castFrom(tiles);
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    gradeProvider = Provider.of<GradeProvider>(context);

    List<String> nameParts = user.name?.split(" ") ?? ["?"];
    firstName = nameParts.length > 1 ? nameParts[1] : nameParts[0];

    yearlyGraph = Padding(
      padding: EdgeInsets.only(top: 12.0, bottom: 24.0),
      child: Panel(
        title: Text("Yearly average"),
        child: Container(
          height: 175.0,
          padding: EdgeInsets.only(top: 24.0, right: 12.0),
          child: GradeGraph(gradeProvider.grades.where((e) => e.type == GradeType.midYear).toList(), dayThreshold: 2),
        ),
      ),
    );

    generateTiles();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 9.0),
          child: NestedScrollView(
            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            headerSliverBuilder: (context, _) => [
              SliverAppBar(
                centerTitle: false,
                pinned: true,
                floating: false,
                snap: false,
                actions: [
                  // Profile Icon
                  Padding(
                    padding: EdgeInsets.only(right: 24.0),
                    child: ProfileButton(
                      child: ProfileImage(
                        heroTag: "profile",
                        name: firstName,
                        backgroundColor: ColorUtils.stringToColor(user.name ?? "?"),
                      ),
                    ),
                  ),
                ],
                automaticallyImplyLeading: false,
                title: Text(
                  "Grades", // TODO: i18n
                  style: TextStyle(color: AppColors.of(context).text, fontSize: 32.0, fontWeight: FontWeight.bold),
                ),
                shadowColor: AppColors.of(context).shadow.withOpacity(0.5),
              ),
            ],
            body: RefreshIndicator(
              onRefresh: () => gradeProvider.fetch(),
              color: Theme.of(context).colorScheme.secondary,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: max(subjectTiles.length, 1),
                itemBuilder: (context, index) {
                  if (subjectTiles.length > 0) {
                    EdgeInsetsGeometry panelPadding = EdgeInsets.symmetric(horizontal: 24.0);

                    if (subjectTiles[index].runtimeType == SubjectTile)
                      return Padding(
                          padding: panelPadding,
                          child: PanelBody(
                            child: subjectTiles[index],
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                          ));
                    else
                      return Padding(padding: panelPadding, child: subjectTiles[index]);
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
