import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:filcnaplo/api/providers/update_provider.dart';
import 'package:filcnaplo_kreta_api/models/absence.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_kreta_api/models/week.dart';
import 'package:filcnaplo_kreta_api/providers/absence_provider.dart';
import 'package:filcnaplo_kreta_api/providers/note_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:filcnaplo_mobile_ui/common/action_button.dart';
import 'package:filcnaplo_mobile_ui/common/empty.dart';
import 'package:filcnaplo_mobile_ui/common/filter/filter_bar.dart';
import 'package:filcnaplo_mobile_ui/common/filter/filter_controller.dart';
import 'package:filcnaplo_mobile_ui/common/filter/filter_item.dart';
import 'package:filcnaplo_mobile_ui/common/filter/filter_view.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_button.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_image.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence_subject_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence_view.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/statistics_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/miss_tile.dart';
import 'package:filcnaplo_mobile_ui/pages/absences/absence_subject_view.dart';
import 'package:filcnaplo_mobile_ui/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo/utils/color.dart';
import 'absences_page.i18n.dart';

enum AbsenceFilter { absences, delays, misses }

class SubjectAbsence {
  Subject subject;
  List<Absence> absences;
  double percentage;

  SubjectAbsence({required this.subject, this.absences = const [], this.percentage = 0.0});
}

class AbsencesPage extends StatefulWidget {
  const AbsencesPage({Key? key}) : super(key: key);

  @override
  _AbsencesPageState createState() => _AbsencesPageState();
}

class _AbsencesPageState extends State<AbsencesPage> {
  late UserProvider user;
  late AbsenceProvider absenceProvider;
  late TimetableProvider timetableProvider;
  late NoteProvider noteProvider;
  late UpdateProvider updateProvider;
  late String firstName;
  late FilterController filterController;
  late List<SubjectAbsence> absences = [];

  @override
  void initState() {
    super.initState();

    timetableProvider = Provider.of<TimetableProvider>(context, listen: false);
    timetableProvider.fetch(week: Week.fromId(3));

    filterController = FilterController(itemCount: 3);
  }

  void buildSubjectAbsences() {
    Map<Subject, SubjectAbsence> _absences = {};

    for (final absence in absenceProvider.absences) {
      if (absence.delay != 0) continue;

      if (!_absences.containsKey(absence.subject)) {
        _absences[absence.subject] = SubjectAbsence(subject: absence.subject, absences: [absence]);
      } else {
        _absences[absence.subject]?.absences.add(absence);
      }
    }

    _absences.forEach((subject, absence) {
      final absentLessonsOfSubject = absenceProvider.absences.where((e) => e.subject == subject && e.delay == 0).length;
      final totalLessonsOfSubject = timetableProvider.lessons.where((e) => e.subject == subject).length * 35.5;
      final absentLessonsOfSubjectPercentage = absentLessonsOfSubject / totalLessonsOfSubject * 100;
      _absences[subject]?.percentage = absentLessonsOfSubjectPercentage.clamp(0.0, 100.0);
    });

    absences = _absences.values.toList();
    absences.sort((a, b) => -a.percentage.compareTo(b.percentage));
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    absenceProvider = Provider.of<AbsenceProvider>(context);
    timetableProvider = Provider.of<TimetableProvider>(context);
    noteProvider = Provider.of<NoteProvider>(context);
    updateProvider = Provider.of<UpdateProvider>(context);

    List<String> nameParts = user.name?.split(" ") ?? ["?"];
    firstName = nameParts.length > 1 ? nameParts[1] : nameParts[0];

    buildSubjectAbsences();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: NestedScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              pinned: true,
              floating: false,
              snap: false,
              centerTitle: false,
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
              shadowColor: AppColors.of(context).shadow.withOpacity(0.5),
              title: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Absences".i18n,
                  style: TextStyle(color: AppColors.of(context).text, fontSize: 32.0, fontWeight: FontWeight.bold),
                ),
              ),
              bottom: FilterBar(items: [
                //! DO NOT REORDER, IT WILL BREAK
                FilterItem(label: "Absences".i18n),
                FilterItem(label: "Delays".i18n),
                FilterItem(label: "Misses".i18n),
              ], controller: filterController),
            ),
          ],
          body: FilterView(controller: filterController, builder: filterViewBuilder),
        ),
      ),
    );
  }

  List<DateWidget> getFilterWidgets(AbsenceFilter activeData) {
    List<DateWidget> items = [];
    switch (activeData) {
      case AbsenceFilter.absences:
        for (var a in absences) {
          items.add(DateWidget(
            date: DateTime.fromMillisecondsSinceEpoch(0),
            widget: AbsenceSubjectTile(
              a.subject,
              percentage: a.percentage,
              excused: a.absences.where((a) => a.state == Justification.excused).length,
              unexcused: a.absences.where((a) => a.state == Justification.unexcused).length,
              pending: a.absences.where((a) => a.state == Justification.pending).length,
              onTap: () => AbsenceSubjectView.show(a.subject, a.absences, context: context),
            ),
          ));
        }
        break;
      case AbsenceFilter.delays:
        for (var absence in absenceProvider.absences) {
          if (absence.delay != 0) {
            items.add(DateWidget(
              date: absence.date,
              widget: AbsenceTile(absence, onTap: () => AbsenceView.show(absence, context: context)),
            ));
          }
        }
        break;
      case AbsenceFilter.misses:
        for (var note in noteProvider.notes) {
          if (note.type?.name == "HaziFeladatHiany" || note.type?.name == "Felszereleshiany") {
            items.add(DateWidget(
              date: note.date,
              widget: MissTile(note),
            ));
          }
        }
        break;
    }
    return items;
  }

  Widget filterViewBuilder(context, int activeData) {
    List<Widget> filterWidgets = [];

    if (activeData > 0) {
      filterWidgets = sortDateWidgets(
        context,
        dateWidgets: getFilterWidgets(AbsenceFilter.values[activeData]),
        padding: EdgeInsets.zero,
      );
    } else {
      filterWidgets = [
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Panel(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Subjects".i18n),
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                          title: Text("attention".i18n),
                          content: Text("attention_body".i18n),
                          actions: [ActionButton(label: "Ok", onTap: () => Navigator.of(context).pop())],
                        ),
                      );
                    },
                    padding: EdgeInsets.zero,
                    splashRadius: 24.0,
                    visualDensity: VisualDensity.compact,
                    constraints: BoxConstraints.tight(const Size(42.0, 42.0)),
                    icon: const Icon(FeatherIcons.info),
                  ),
                ),
              ],
            ),
            child: Column(children: getFilterWidgets(AbsenceFilter.values[activeData]).map((e) => e.widget).cast<Widget>().toList()),
          ),
        )
      ];
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        onRefresh: () async {
          await absenceProvider.fetch();
          await noteProvider.fetch();
        },
        child: ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          itemCount: max(filterWidgets.length + (activeData < 2 ? 1 : 0), 1),
          itemBuilder: (context, index) {
            if (filterWidgets.isNotEmpty) {
              if ((index == 0 && activeData == 1) || (index == filterWidgets.length && activeData == 0)) {
                int value1 = 0;
                int value2 = 0;
                String title1 = "";
                String title2 = "";
                String suffix = "";

                if (activeData == AbsenceFilter.absences.index) {
                  value1 = absenceProvider.absences.where((e) => e.delay == 0 && e.state == Justification.excused).length;
                  value2 = absenceProvider.absences.where((e) => e.delay == 0 && e.state == Justification.unexcused).length;
                  title1 = "stat_1".i18n;
                  title2 = "stat_2".i18n;
                  suffix = " " + "hr".i18n;
                } else if (activeData == AbsenceFilter.delays.index) {
                  value1 = absenceProvider.absences
                      .where((e) => e.delay != 0 && e.state == Justification.excused)
                      .map((e) => e.delay)
                      .fold(0, (a, b) => a + b);
                  value2 = absenceProvider.absences
                      .where((e) => e.delay != 0 && e.state == Justification.unexcused)
                      .map((e) => e.delay)
                      .fold(0, (a, b) => a + b);
                  title1 = "stat_3".i18n;
                  title2 = "stat_4".i18n;
                  suffix = " " + "min".i18n;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0, left: 24.0, right: 24.0),
                  child: Row(children: [
                    Expanded(
                      child: StatisticsTile(
                        title: AutoSizeText(
                          title1,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        valueSuffix: suffix,
                        value: value1.toDouble(),
                        decimal: false,
                        color: AppColors.of(context).green,
                      ),
                    ),
                    const SizedBox(width: 24.0),
                    Expanded(
                      child: StatisticsTile(
                        title: AutoSizeText(
                          title2,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        valueSuffix: suffix,
                        value: value2.toDouble(),
                        decimal: false,
                        color: AppColors.of(context).red,
                      ),
                    ),
                  ]),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: filterWidgets[index - (activeData == 1 ? 1 : 0)],
              );
            } else {
              return Empty(subtitle: "empty".i18n);
            }
          },
        ),
      ),
    );
  }
}
