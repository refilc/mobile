import 'dart:math';

import 'package:filcnaplo/api/providers/update_provider.dart';
import 'package:filcnaplo_kreta_api/providers/absence_provider.dart';
import 'package:filcnaplo_kreta_api/providers/event_provider.dart';
import 'package:filcnaplo_kreta_api/providers/exam_provider.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_kreta_api/providers/homework_provider.dart';
import 'package:filcnaplo_kreta_api/providers/message_provider.dart';
import 'package:filcnaplo_kreta_api/providers/note_provider.dart';
import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/message.dart';
import 'package:filcnaplo_kreta_api/models/week.dart';
import 'package:filcnaplo_mobile_ui/common/empty.dart';
import 'package:filcnaplo_mobile_ui/common/filter/filter_bar.dart';
import 'package:filcnaplo_mobile_ui/common/filter/filter_controller.dart';
import 'package:filcnaplo_mobile_ui/common/filter/filter_item.dart';
import 'package:filcnaplo_mobile_ui/common/filter/filter_view.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_button.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_image.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence_group_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence_view.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/grade_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/grade_view.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/message_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/message_view/message_view.dart';
import 'package:filcnaplo_mobile_ui/pages/home/live_card/live_card.dart';
import 'package:filcnaplo_mobile_ui/common/hero_dialog_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.i18n.dart';
import 'package:filcnaplo/utils/color.dart';
import 'package:filcnaplo/utils/format.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FilterController filterController;
  late UserProvider user;
  late UpdateProvider updateProvider;
  late GradeProvider gradeProvider;
  late MessageProvider messageProvider;
  late AbsenceProvider absenceProvider;
  late String greeting;
  late String firstName;

  @override
  void initState() {
    super.initState();
    filterController = FilterController(itemCount: 4);
    DateTime now = DateTime.now();
    if (now.hour >= 18)
      greeting = "goodevening";
    else if (now.hour >= 10)
      greeting = "goodafternoon";
    else if (now.hour >= 4)
      greeting = "goodmorning";
    else
      greeting = "goodevening";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    updateProvider = Provider.of<UpdateProvider>(context);
    gradeProvider = Provider.of<GradeProvider>(context);
    messageProvider = Provider.of<MessageProvider>(context);
    absenceProvider = Provider.of<AbsenceProvider>(context);

    List<String> nameParts = user.name?.split(" ") ?? ["?"];
    firstName = nameParts.length > 1 ? nameParts[1] : nameParts[0];

    const bool showLiveCard = false;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: NestedScrollView(
            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            headerSliverBuilder: (context, _) => [
              SliverAppBar(
                automaticallyImplyLeading: false,
                centerTitle: false,
                titleSpacing: 0.0,
                // Welcome text
                title: Padding(
                  padding: EdgeInsets.only(left: 24.0),
                  child: Text(
                    greeting.i18n.fill([firstName]),
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Theme.of(context).textTheme.bodyText1?.color,
                    ),
                  ),
                ),
                actions: [
                  // TODO: Search Button
                  // IconButton(
                  //   icon: Icon(FeatherIcons.search),
                  //   color: Theme.of(context).textTheme.bodyText1?.color,
                  //   splashRadius: 24.0,
                  //   onPressed: () {},
                  // ),

                  // Profile Icon
                  Padding(
                    padding: EdgeInsets.only(right: 24.0),
                    child: ProfileButton(
                      child: ProfileImage(
                        heroTag: "profile",
                        name: firstName,
                        backgroundColor: ColorUtils.stringToColor(user.name ?? "?"),
                        newContent: updateProvider.available,
                      ),
                    ),
                  ),
                ],
                expandedHeight: showLiveCard ? 234.0 : 0,

                // Live Card
                flexibleSpace: showLiveCard
                    ? FlexibleSpaceBar(
                        background: Padding(
                          padding: EdgeInsets.only(
                            left: 24.0,
                            right: 24.0,
                            top: 64.0,
                            bottom: 52.0,
                          ),
                          child: LiveCard(
                            onTap: openLiveCard,
                          ),
                        ),
                      )
                    : null,
                shadowColor: Color(0),

                // Filter Bar
                bottom: FilterBar(items: [
                  FilterItem(label: "Összes"),
                  FilterItem(label: "Jegyek"),
                  FilterItem(label: "Üzenetek"),
                  FilterItem(label: "Hiányok"),
                ], controller: filterController),
                pinned: true,
                floating: false,
                snap: false,
              ),
            ],
            body: FilterView(
              controller: filterController,
              builder: filterViewBuilder,
            ),
          ),
        ),
      ),
    );
  }

  void openLiveCard() {
    Navigator.of(context, rootNavigator: true).push(
      HeroDialogRoute(
        builder: (context) => Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: LiveCard(
                shadowColor: Color(0),
                child: Expanded(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 12.0),
                        child: Text("Upcoming lessons:"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<DateWidget> getFilterWidgets(HomeFilterItems activeData) {
    List<DateWidget> items = [];
    switch (activeData) {
      case HomeFilterItems.all:
        items.addAll(getFilterWidgets(HomeFilterItems.grades));
        items.addAll(getFilterWidgets(HomeFilterItems.messages));
        items.addAll(getFilterWidgets(HomeFilterItems.absences));
        break;
      case HomeFilterItems.grades:
        gradeProvider.grades.forEach((grade) {
          if (grade.type == GradeType.midYear) {
            items.add(DateWidget(
              date: grade.date,
              widget: GradeTile(grade, onTap: () => GradeView.show(grade, context: context)),
            ));
          }
        });
        break;
      case HomeFilterItems.messages:
        messageProvider.messages.forEach((message) {
          if (message.type == MessageType.inbox) {
            items.add(DateWidget(
                date: message.date,
                widget: MessageTile(
                  message,
                  onTap: () => MessageView.show([message], context: context),
                )));
          }
        });
        break;
      case HomeFilterItems.absences:
        absenceProvider.absences.forEach((absence) {
          items.add(DateWidget(
              date: absence.date,
              widget: AbsenceTile(
                absence,
                onTap: () => AbsenceView.show(absence, context: context),
              ))); // TODO: group absences
        });
        break;
    }
    return items;
  }

  Widget filterViewBuilder(context, int activeData) {
    List<Widget> filterWidgets = sortDateWidgets(context, dateWidgets: getFilterWidgets(HomeFilterItems.values[activeData]));

    return Padding(
      padding: EdgeInsets.only(top: 12.0),
      child: RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        onRefresh: () async {
          // TODO: implement waitgroup
          await Provider.of<GradeProvider>(context, listen: false).fetch();
          await Provider.of<TimetableProvider>(context, listen: false).fetch(week: Week.current());
          await Provider.of<ExamProvider>(context, listen: false).fetch();
          await Provider.of<HomeworkProvider>(context, listen: false).fetch(from: DateTime.now().subtract(Duration(days: 30)));
          await Provider.of<MessageProvider>(context, listen: false).fetch(type: MessageType.inbox);
          await Provider.of<NoteProvider>(context, listen: false).fetch();
          await Provider.of<EventProvider>(context, listen: false).fetch();
          await Provider.of<AbsenceProvider>(context, listen: false).fetch();
        },
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            if (filterWidgets.length > 0)
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: filterWidgets[index],
              );
            else
              return Empty(subtitle: "Nothing to see here"); // TODO: i18n
          },
          itemCount: max(filterWidgets.length, 1),
        ),
      ),
    );
  }
}

List<Widget> sortDateWidgets(
  BuildContext context, {
  required List<DateWidget> dateWidgets,
  bool showTitle = true,
  EdgeInsetsGeometry? padding,
}) {
  dateWidgets.sort((a, b) => -a.date.compareTo(b.date));

  List<Conversation> conversations = [];
  List<DateWidget> convMessages = [];

  // Group messages into conversations
  dateWidgets.forEach((w) {
    if (w.widget.runtimeType == MessageTile) {
      Message message = (w.widget as MessageTile).message;

      if (message.conversationId != null) {
        convMessages.add(w);

        Conversation conv = conversations.firstWhere((e) => e.id == message.conversationId, orElse: () => Conversation(id: message.conversationId!));
        conv.add(message);
        if (conv.messages.length == 1) conversations.add(conv);
      }

      if (conversations.any((c) => c.id == message.messageId)) {
        Conversation conv = conversations.firstWhere((e) => e.id == message.messageId);
        convMessages.add(w);
        conv.add(message);
      }
    }
  });

  // remove individual messages
  convMessages.forEach((e) => dateWidgets.remove(e));

  // Add conversations
  conversations.forEach((conv) {
    conv.sort();

    dateWidgets.add(DateWidget(
      date: conv.newest.date,
      widget: MessageTile(
        conv.newest,
        onTap: () => MessageView.show(conv.messages, context: context),
      ),
    ));
  });

  List<Widget> items = [];
  dateWidgets.sort((a, b) => -a.date.compareTo(b.date));

  List<List<DateWidget>> groupedDateWidgets = [[]];
  dateWidgets.forEach((element) {
    if (groupedDateWidgets.last.length > 0) {
      if (element.date.difference(groupedDateWidgets.last.last.date).inDays != 0) {
        groupedDateWidgets.add([element]);
        return;
      }
    }
    groupedDateWidgets.last.add(element);
  });

  if (groupedDateWidgets.first.length > 0) {
    groupedDateWidgets.forEach((elements) {
      bool _showTitle = showTitle;

      // Group Absence Tiles
      List<DateWidget> absenceTileWidgets = elements.where((element) {
        return element.widget.runtimeType == AbsenceTile && (element.widget as AbsenceTile).absence.delay == 0;
      }).toList();
      List<AbsenceTile> absenceTiles = absenceTileWidgets.map((e) => e.widget as AbsenceTile).toList();
      if (absenceTiles.length > 1) {
        elements.removeWhere((element) => element.widget.runtimeType == AbsenceTile && (element.widget as AbsenceTile).absence.delay == 0);

        if (elements.length == 0) {
          _showTitle = false;
        }

        elements.add(DateWidget(widget: AbsenceGroupTile(absenceTiles, showDate: !_showTitle), date: absenceTileWidgets.first.date));
      }

      items.add(Padding(
        padding: EdgeInsets.only(bottom: 12.0),
        child: Panel(
          padding: padding,
          title: _showTitle ? Text((elements + absenceTileWidgets).first.date.format(context)) : null,
          child: Column(children: elements.map((e) => e.widget).toList()),
        ),
      ));
    });
  }
  return items;
}

class DateWidget {
  DateTime date;
  Widget widget;
  DateWidget({required this.date, required this.widget});
}

enum HomeFilterItems { all, grades, messages, absences }
