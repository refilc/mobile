import 'dart:math';

import 'package:filcnaplo/api/providers/update_provider.dart';
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
import 'package:filcnaplo_mobile_ui/common/widgets/miss_tile.dart';
import 'package:filcnaplo_mobile_ui/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:filcnaplo/utils/color.dart';
import 'absences_page.i18n.dart';

enum AbsenceFilterItems { absences, delays, misses }

class AbsencesPage extends StatefulWidget {
  AbsencesPage({Key? key}) : super(key: key);

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
        padding: EdgeInsets.only(top: 12.0),
        child: NestedScrollView(
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              pinned: true,
              floating: false,
              snap: false,
              centerTitle: false,
              actions: [
                // Profile Icon
                Padding(
                  padding: EdgeInsets.only(right: 24.0),
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
              physics: BouncingScrollPhysics(), controller: _tabController, children: List.generate(3, (index) => filterViewBuilder(context, index))),
        ),
      ),
    );
  }

  List<DateWidget> getFilterWidgets(AbsenceFilterItems activeData) {
    List<DateWidget> items = [];
    switch (activeData) {
      case AbsenceFilterItems.absences:
        absenceProvider.absences.forEach((absence) {
          if (absence.delay == 0) {
            items.add(DateWidget(
              date: absence.date,
              widget: AbsenceTile(absence, onTap: () => AbsenceView.show(absence, context: context)),
            ));
          }
        });
        break;
      case AbsenceFilterItems.delays:
        absenceProvider.absences.forEach((absence) {
          if (absence.delay != 0) {
            items.add(DateWidget(
              date: absence.date,
              widget: AbsenceTile(absence, onTap: () => AbsenceView.show(absence, context: context)),
            ));
          }
        });
        break;
      case AbsenceFilterItems.misses:
        noteProvider.notes.forEach((note) {
          if (note.type?.name == "HaziFeladatHiany" || note.type?.name == "Felszereleshiany") {
            items.add(DateWidget(
              date: note.date,
              widget: MissTile(note),
            ));
          }
        });
        break;
    }
    return items;
  }

  Widget filterViewBuilder(context, int activeData) {
    List<Widget> filterWidgets = sortDateWidgets(
      context,
      dateWidgets: getFilterWidgets(AbsenceFilterItems.values[activeData]),
      // padding: EdgeInsets.zero,
    );

    return Padding(
      padding: EdgeInsets.only(top: 12.0),
      child: RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        onRefresh: () async {
          await absenceProvider.fetch();
          await noteProvider.fetch();
        },
        child: ListView.builder(
          padding: EdgeInsets.zero,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) => filterWidgets.length > 0
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: filterWidgets[index],
                )
              : Empty(subtitle: "empty".i18n),
          itemCount: max(filterWidgets.length, 1),
        ),
      ),
    );
  }
}
