import 'dart:math';

import 'package:filcnaplo/api/providers/update_provider.dart';
import 'package:filcnaplo_kreta_api/models/absence.dart';
import 'package:filcnaplo_kreta_api/providers/absence_provider.dart';
import 'package:filcnaplo_kreta_api/providers/note_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo_mobile_ui/common/empty.dart';
import 'package:filcnaplo_mobile_ui/common/filter_bar.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_button.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_image.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence_view.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/statistics_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/miss_tile.dart';
import 'package:filcnaplo_mobile_ui/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo/utils/color.dart';
import 'absences_page.i18n.dart';

enum AbsenceFilter { absences, delays, misses }

class AbsencesPage extends StatefulWidget {
  const AbsencesPage({Key? key}) : super(key: key);

  @override
  _AbsencesPageState createState() => _AbsencesPageState();
}

class _AbsencesPageState extends State<AbsencesPage> with TickerProviderStateMixin {
  late UserProvider user;
  late AbsenceProvider absenceProvider;
  late NoteProvider noteProvider;
  late UpdateProvider updateProvider;
  late String firstName;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    absenceProvider = Provider.of<AbsenceProvider>(context);
    noteProvider = Provider.of<NoteProvider>(context);
    updateProvider = Provider.of<UpdateProvider>(context);

    List<String> nameParts = user.name?.split(" ") ?? ["?"];
    firstName = nameParts.length > 1 ? nameParts[1] : nameParts[0];

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
              title: Text(
                "Absences".i18n,
                style: TextStyle(color: AppColors.of(context).text, fontSize: 32.0, fontWeight: FontWeight.bold),
              ),
              bottom: FilterBar(items: [
                Tab(text: "Absences".i18n),
                Tab(text: "Delays".i18n),
                Tab(text: "Misses".i18n),
              ], controller: _tabController, disableFading: true),
            ),
          ],
          body: TabBarView(
              physics: const BouncingScrollPhysics(),
              controller: _tabController,
              children: List.generate(3, (index) => filterViewBuilder(context, index))),
        ),
      ),
    );
  }

  List<DateWidget> getFilterWidgets(AbsenceFilter activeData) {
    List<DateWidget> items = [];
    switch (activeData) {
      case AbsenceFilter.absences:
        for (var absence in absenceProvider.absences) {
          if (absence.delay == 0) {
            items.add(DateWidget(
              date: absence.date,
              widget: AbsenceTile(absence, onTap: () => AbsenceView.show(absence, context: context)),
            ));
          }
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
    List<Widget> filterWidgets = sortDateWidgets(
      context,
      dateWidgets: getFilterWidgets(AbsenceFilter.values[activeData]),
      // padding: EdgeInsets.zero,
    );

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
          itemBuilder: (context, index) {
            if (filterWidgets.isNotEmpty) {
              if (index == 0 && activeData < 2) {
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
                } else if (activeData == AbsenceFilter.delays.index) {
                  value1 = absenceProvider.absences
                      .where((e) => e.delay != 0 && e.state == Justification.excused)
                      .map((e) => e.delay)
                      .reduce((a, b) => a + b);
                  value2 = absenceProvider.absences
                      .where((e) => e.delay != 0 && e.state == Justification.unexcused)
                      .map((e) => e.delay)
                      .reduce((a, b) => a + b);
                  title1 = "stat_3".i18n;
                  title2 = "stat_4".i18n;
                  suffix = " " + "min".i18n;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0, left: 24.0, right: 24.0),
                  child: Row(children: [
                    Expanded(
                      child: StatisticsTile(
                        title: Text(
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
                        title: Text(
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
                child: filterWidgets[index - (activeData < 2 ? 1 : 0)],
              );
            } else {
              return Empty(subtitle: "empty".i18n);
            }
          },
          itemCount: max(filterWidgets.length + (activeData < 2 ? 1 : 0), 1),
        ),
      ),
    );
  }
}
