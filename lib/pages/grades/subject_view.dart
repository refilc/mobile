import 'dart:math';

import 'package:animations/animations.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo/helpers/average_helper.dart';
import 'package:filcnaplo/helpers/subject_icon.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_mobile_ui/common/average_display.dart';
import 'package:filcnaplo_mobile_ui/common/bottom_sheet_menu/rounded_bottom_sheet.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/certification_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/grade_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/grade_view.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/hero_scrollview.dart';
import 'package:filcnaplo_mobile_ui/pages/grades/calculator/grade_calculator.dart';
import 'package:filcnaplo_mobile_ui/pages/grades/calculator/grade_calculator_provider.dart';
import 'package:filcnaplo_mobile_ui/pages/grades/graph.dart';
import 'package:filcnaplo_mobile_ui/pages/grades/subject_grades_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'grades_page.i18n.dart';

class SubjectView extends StatefulWidget {
  const SubjectView(this.subject, {Key? key, this.classAverage = 0.0}) : super(key: key);

  final Subject subject;
  final double classAverage;

  void push(BuildContext context, {bool root = false}) {
    Navigator.of(context, rootNavigator: root).push(CupertinoPageRoute(builder: (context) => this));
  }

  @override
  State<SubjectView> createState() => _SubjectViewState();
}

class _SubjectViewState extends State<SubjectView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Controllers
  PersistentBottomSheetController? _sheetController;
  final ScrollController _scrollController = ScrollController();

  List<Widget> gradeTiles = [];

  // Providers
  late GradeProvider gradeProvider;
  late GradeCalculatorProvider calculatorProvider;

  late double average;
  late Widget gradeGraph;

  bool gradeCalcMode = false;

  List<Grade> getSubjectGrades(Subject subject) => !gradeCalcMode
      ? gradeProvider.grades.where((e) => e.subject == subject).toList()
      : calculatorProvider.grades.where((e) => e.subject == subject).toList();

  bool showGraph(List<Grade> subjectGrades) {
    if (gradeCalcMode) return true;

    final gradeDates = subjectGrades.map((e) => e.date.millisecondsSinceEpoch);
    final maxGradeDate = gradeDates.fold(0, max);
    final minGradeDate = gradeDates.fold(0, min);
    if (maxGradeDate - minGradeDate < const Duration(days: 5).inMilliseconds) return false; // naplo/#78

    return subjectGrades.where((e) => e.type == GradeType.midYear).length > 1;
  }

  void buildTiles(List<Grade> subjectGrades) {
    List<Widget> tiles = [];

    if (showGraph(subjectGrades)) {
      tiles.insert(0, gradeGraph);
    } else {
      tiles.insert(0, Container(height: 24.0));
    }

    List<Widget> _gradeTiles = [];

    if (!gradeCalcMode) {
      subjectGrades.sort((a, b) => -a.date.compareTo(b.date));
      for (var grade in subjectGrades) {
        if (grade.type == GradeType.midYear) {
          _gradeTiles.add(GradeTile(
            grade,
            onTap: () => GradeView.show(grade, context: context),
          ));
        } else {
          _gradeTiles.add(CertificationTile(grade));
        }
      }
    } else if (subjectGrades.isNotEmpty) {
      subjectGrades.sort((a, b) => -a.date.compareTo(b.date));
      for (var grade in subjectGrades) {
        _gradeTiles.add(GradeTile(grade));
      }
    }
    tiles.add(
      PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> primaryAnimation,
          Animation<double> secondaryAnimation,
        ) {
          return SharedAxisTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.vertical,
            child: child,
            fillColor: Colors.transparent,
          );
        },
        child: _gradeTiles.isNotEmpty
            ? Panel(
                key: ValueKey(gradeCalcMode),
                title: Text(
                  gradeCalcMode ? "Ghost Grades".i18n : "Grades".i18n,
                ),
                child: Column(
                  children: _gradeTiles,
                ))
            : const SizedBox(),
      ),
    );

    tiles.add(Padding(padding: EdgeInsets.only(bottom: !gradeCalcMode ? 24.0 : 250.0)));
    gradeTiles = List.castFrom(tiles);
  }

  @override
  Widget build(BuildContext context) {
    gradeProvider = Provider.of<GradeProvider>(context);
    calculatorProvider = Provider.of<GradeCalculatorProvider>(context);

    average = AverageHelper.averageEvals(getSubjectGrades(widget.subject));
    List<Grade> subjectGrades = getSubjectGrades(widget.subject).toList();

    gradeGraph = Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 24.0),
      child: Panel(
        child: Container(
          height: 175.0,
          padding: const EdgeInsets.only(top: 18.0, right: 16.0, bottom: 4.0),
          child: GradeGraph(subjectGrades, dayThreshold: 5, classAvg: widget.classAverage),
        ),
      ),
    );

    if (!gradeCalcMode) {
      buildTiles(subjectGrades);
    } else {
      List<Grade> ghostGrades = calculatorProvider.ghosts.where((e) => e.subject == widget.subject).toList();
      buildTiles(ghostGrades);
    }

    return Scaffold(
        key: _scaffoldKey,
        floatingActionButton: !gradeCalcMode && subjectGrades.where((e) => e.type == GradeType.midYear).isNotEmpty
            ? FloatingActionButton(
                child: const Icon(FeatherIcons.plus),
                onPressed: () => gradeCalc(context),
                backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.grey[900],
                foregroundColor: Theme.of(context).colorScheme.secondary,
              )
            : null,
        body: RefreshIndicator(
          onRefresh: () async {},
          color: Theme.of(context).colorScheme.secondary,
          child: HeroScrollView(
              onClose: () {
                if (_sheetController != null && gradeCalcMode) {
                  _sheetController!.close();
                } else {
                  Navigator.of(context).pop();
                }
              },
              navBarItems: [
                const SizedBox(width: 6.0),
                if (widget.classAverage != 0) Center(child: AverageDisplay(average: widget.classAverage, border: true)),
                const SizedBox(width: 6.0),
                if (average != 0) Center(child: AverageDisplay(average: average)),
                const SizedBox(width: 12.0),
              ],
              icon: SubjectIcon.lookup(subject: widget.subject),
              scrollController: _scrollController,
              title: widget.subject.name,
              child: SubjectGradesContainer(
                child: CupertinoScrollbar(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => gradeTiles[index],
                    itemCount: gradeTiles.length,
                  ),
                ),
              )),
        ));
  }

  void gradeCalc(BuildContext context) {
    // Scroll to the top of the page
    _scrollController.animateTo(75, duration: const Duration(milliseconds: 500), curve: Curves.ease);

    calculatorProvider.clear();
    calculatorProvider.addAllGrades(gradeProvider.grades);

    _sheetController = _scaffoldKey.currentState?.showBottomSheet(
      (context) => RoundedBottomSheet(child: GradeCalculator(widget.subject), borderRadius: 14.0),
      backgroundColor: const Color(0x00000000),
      elevation: 12.0,
    );

    // Hide the fab and grades
    setState(() {
      gradeCalcMode = true;
    });

    _sheetController!.closed.then((value) {
      // Show fab and grades
      if (mounted) {
        setState(() {
          gradeCalcMode = false;
        });
      }
    });
  }
}
