import 'dart:math';

import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo/helpers/average_helper.dart';
import 'package:filcnaplo/helpers/subject_icon.dart';
import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_mobile_ui/common/average_display.dart';
import 'package:filcnaplo_mobile_ui/common/bottom_sheet_menu/rounded_bottom_sheet.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/certification_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/grade_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/grade_view.dart';
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
  late ScrollController _scrollController;
  PersistentBottomSheetController? _sheetController;

  List<Widget> gradeTiles = [];

  // Providers
  late GradeProvider gradeProvider;
  late GradeCalculatorProvider calculatorProvider;

  late double average;
  late Widget gradeGraph;

  bool showBarTitle = false;
  bool gradeCalcMode = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.offset > 42.0) {
        if (showBarTitle == false) setState(() => showBarTitle = true);
      } else {
        if (showBarTitle == true) setState(() => showBarTitle = false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  List<Grade> getSubjectGrades(Subject subject) => !gradeCalcMode
      ? gradeProvider.grades.where((e) => e.subject == subject).toList()
      : calculatorProvider.grades.where((e) => e.subject == subject).toList();

  bool showGraph(List<Grade> subjectGrades) {
    final gradeDates = subjectGrades.map((e) => e.date.millisecondsSinceEpoch);
    final maxGradeDate = gradeDates.reduce(max);
    final minGradeDate = gradeDates.reduce(min);
    if (maxGradeDate - minGradeDate < const Duration(days: 5).inMilliseconds) return false; // naplo/#78

    return subjectGrades.where((e) => e.type == GradeType.midYear).length > 1 || gradeCalcMode;
  }

  void buildTiles(List<Grade> subjectGrades) {
    List<Widget> tiles = [];

    if (showGraph(subjectGrades)) {
      tiles.insert(0, gradeGraph);
    } else {
      tiles.insert(0, Container(height: 24.0));
    }

    if (!gradeCalcMode) {
      subjectGrades.sort((a, b) => -a.date.compareTo(b.date));
      for (var grade in subjectGrades) {
        if (grade.type == GradeType.midYear) {
          tiles.add(GradeTile(grade, onTap: () => GradeView.show(grade, context: context)));
        } else {
          tiles.add(CertificationTile(grade));
        }
      }
      tiles.insert(1, PanelTitle(title: Text("Grades".i18n)));
      tiles.insert(2, const PanelHeader(padding: EdgeInsets.only(top: 12.0)));
      tiles.add(const PanelFooter(padding: EdgeInsets.only(bottom: 12.0)));
    } else if (subjectGrades.isNotEmpty) {
      subjectGrades.sort((a, b) => -a.date.compareTo(b.date));
      for (var grade in subjectGrades) {
        tiles.add(GradeTile(grade));
      }
      tiles.insert(1, PanelTitle(title: Text("Ghost Grades".i18n)));
      tiles.insert(2, const PanelHeader(padding: EdgeInsets.only(top: 12.0)));
      tiles.add(const PanelFooter(padding: EdgeInsets.only(bottom: 12.0)));
    }

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
          child: GradeGraph(subjectGrades, dayThreshold: 5),
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
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {},
          color: Theme.of(context).colorScheme.secondary,
          child: NestedScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            headerSliverBuilder: (context, _) => [
              SliverAppBar(
                pinned: true,
                floating: false,
                snap: false,
                centerTitle: false,
                titleSpacing: 0,
                title: AnimatedOpacity(
                    opacity: showBarTitle ? 1.0 : 0.0,
                    child: Text(
                      widget.subject.name.capital(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(color: AppColors.of(context).text, fontWeight: FontWeight.w500),
                    ),
                    duration: const Duration(milliseconds: 200)),
                leading: BackButton(
                    color: AppColors.of(context).text,
                    onPressed: () {
                      if (_sheetController != null && gradeCalcMode) _sheetController!.close();
                      Navigator.of(context).pop();
                    }),
                actions: [
                  const SizedBox(width: 6.0),
                  if (widget.classAverage != 0) Center(child: AverageDisplay(average: widget.classAverage, border: true)),
                  const SizedBox(width: 6.0),
                  if (average != 0) Center(child: AverageDisplay(average: average)),
                  const SizedBox(width: 12.0),
                ],
                expandedHeight: 124.0,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Center(
                        child: Icon(
                          SubjectIcon.lookup(subject: widget.subject),
                          size: 100.0,
                          color: AppColors.of(context).text.withOpacity(.15),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          widget.subject.name.capital(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 36.0, color: AppColors.of(context).text.withOpacity(.9), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            body: SubjectGradesContainer(
              child: CupertinoScrollbar(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    EdgeInsetsGeometry panelPadding = const EdgeInsets.symmetric(horizontal: 24.0);

                    if ([GradeTile, CertificationTile].contains(gradeTiles[index].runtimeType)) {
                      return Padding(
                          padding: panelPadding,
                          child: PanelBody(
                            child: gradeTiles[index],
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          ));
                    } else {
                      return Padding(padding: panelPadding, child: gradeTiles[index]);
                    }
                  },
                  itemCount: gradeTiles.length,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void gradeCalc(BuildContext context) {
    // Scroll to the top of the page
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.ease);

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
