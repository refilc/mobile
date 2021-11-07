// ignore_for_file: dead_code
import 'package:filcnaplo/theme.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:filcnaplo/api/providers/update_provider.dart';
import 'package:filcnaplo/api/providers/sync.dart';
import 'package:filcnaplo_kreta_api/models/absence.dart';
import 'package:filcnaplo_kreta_api/providers/absence_provider.dart';
import 'package:filcnaplo_kreta_api/providers/event_provider.dart';
import 'package:filcnaplo_kreta_api/providers/exam_provider.dart';
import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_kreta_api/providers/homework_provider.dart';
import 'package:filcnaplo_kreta_api/providers/message_provider.dart';
import 'package:filcnaplo_kreta_api/providers/note_provider.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/api/providers/status_provider.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/message.dart';
import 'package:filcnaplo_kreta_api/providers/timetable_provider.dart';
import 'package:filcnaplo_mobile_ui/common/empty.dart';
import 'package:filcnaplo_mobile_ui/common/filter_bar.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_button.dart';
import 'package:filcnaplo_mobile_ui/common/profile_image/profile_image.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence_group_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence_view.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/changed_lesson_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/event_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/event_view.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/exam_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/exam_view.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/grade_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/grade_view.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/homework_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/homework_view.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/message_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/message_view/message_view.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/note_tile.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/note_view.dart';
import 'package:filcnaplo_mobile_ui/pages/home/live_card/live_card.dart';
import 'package:filcnaplo_kreta_api/controllers/live_card_controller.dart';
import 'package:filcnaplo_mobile_ui/common/hero_dialog_route.dart';
import 'package:filcnaplo_mobile_ui/pages/timetable/timetable_page.dart';
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

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  late UserProvider user;
  late UpdateProvider updateProvider;
  late StatusProvider statusProvider;
  late GradeProvider gradeProvider;
  late TimetableProvider timetableProvider;
  late MessageProvider messageProvider;
  late AbsenceProvider absenceProvider;
  late HomeworkProvider homeworkProvider;
  late ExamProvider examProvider;
  late NoteProvider noteProvider;
  late EventProvider eventProvider;
  late String greeting;
  late String firstName;
  late LiveCardController _liveController;
  late bool showLiveCard;
  late PageController _pageController;
  List<List<Widget>> widgetsByTab = [[], [], [], []];
  List<String> listOrder = ['A', 'B', 'C', 'D'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _pageController = PageController();

    DateTime now = DateTime.now();
    if (now.hour >= 18)
      greeting = "goodevening";
    else if (now.hour >= 10)
      greeting = "goodafternoon";
    else if (now.hour >= 4)
      greeting = "goodmorning";
    else
      greeting = "goodevening";

    _liveController = LiveCardController(context: context, vsync: this);
  }

  @override
  void dispose() {
    _liveController.dispose();
    _pageController.dispose();
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context);
    updateProvider = Provider.of<UpdateProvider>(context);
    statusProvider = Provider.of<StatusProvider>(context, listen: false);
    gradeProvider = Provider.of<GradeProvider>(context);
    timetableProvider = Provider.of<TimetableProvider>(context);
    messageProvider = Provider.of<MessageProvider>(context);
    absenceProvider = Provider.of<AbsenceProvider>(context);
    homeworkProvider = Provider.of<HomeworkProvider>(context);
    examProvider = Provider.of<ExamProvider>(context);
    noteProvider = Provider.of<NoteProvider>(context);
    eventProvider = Provider.of<EventProvider>(context);

    List<String> nameParts = user.name?.split(" ") ?? ["?"];
    firstName = nameParts.length > 1 ? nameParts[1] : nameParts[0];

    List.generate(
        4, (i) => getFilterWidgets(HomeFilterItems.values[i]).then((widgets) => widgetsByTab[i] = sortDateWidgets(context, dateWidgets: widgets)));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: NestedScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            headerSliverBuilder: (context, _) => [
                  AnimatedBuilder(
                    animation: _liveController.animation,
                    builder: (context, child) {
                      return SliverAppBar(
                        automaticallyImplyLeading: false,
                        centerTitle: false,
                        titleSpacing: 0.0,
                        // Welcome text
                        title: Padding(
                          padding: const EdgeInsets.only(left: 24.0),
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

                        expandedHeight: _liveController.animation.value * 234.0,

                        // Live Card
                        flexibleSpace: FlexibleSpaceBar(
                          background: Padding(
                            padding: EdgeInsets.only(
                              left: 24.0,
                              right: 24.0,
                              top: 58.0 + MediaQuery.of(context).padding.top,
                              bottom: 52.0,
                            ),
                            child: LiveCard(
                              onTap: openLiveCard,
                              controller: _liveController,
                            ),
                          ),
                        ),
                        shadowColor: Color(0),

                        // Filter Bar
                        bottom: FilterBar(
                          items: [
                            Tab(text: "All".i18n),
                            Tab(text: "Grades".i18n),
                            Tab(text: "Messages".i18n),
                            Tab(text: "Absences".i18n),
                          ],
                          controller: _tabController,
                          onTap: (i) async {
                            int selectedPage = _pageController.page!.round();

                            if (i == selectedPage) return;
                            if (_pageController.page?.roundToDouble() != _pageController.page) {
                              _pageController.animateToPage(i, curve: Curves.easeIn, duration: kTabScrollDuration);
                              return;
                            }

                            // swap current page with target page
                            setState(() {
                              _pageController.jumpToPage(i);
                              String currentList = listOrder[selectedPage];
                              listOrder[selectedPage] = listOrder[i];
                              listOrder[i] = currentList;
                            });
                          },
                        ),
                        pinned: true,
                        floating: false,
                        snap: false,
                      );
                    },
                  ),
                ],
            body: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  // from flutter source
                  if (notification is ScrollUpdateNotification && !_tabController.indexIsChanging) {
                    if ((_pageController.page! - _tabController.index).abs() > 1.0) {
                      _tabController.index = _pageController.page!.floor();
                    }
                    _tabController.offset = (_pageController.page! - _tabController.index).clamp(-1.0, 1.0);
                  } else if (notification is ScrollEndNotification) {
                    _tabController.index = _pageController.page!.round();
                    if (!_tabController.indexIsChanging) _tabController.offset = (_pageController.page! - _tabController.index).clamp(-1.0, 1.0);
                  }
                  return false;
                },
                child: PageView.custom(
                  controller: _pageController,
                  childrenDelegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return RefreshIndicator(
                            key: ValueKey<String>(listOrder[index]),
                            color: Theme.of(context).colorScheme.secondary,
                            onRefresh: () => syncAll(context),
                            child: ImplicitlyAnimatedList<Widget>(
                              items: widgetsByTab[index],
                              itemBuilder: _itemBuilder,
                              spawnIsolate: false,
                              areItemsTheSame: (a, b) => a.key == b.key,
                              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            ));
                      },
                      childCount: 4,
                      findChildIndexCallback: (Key key) {
                        final ValueKey<String> valueKey = key as ValueKey<String>;
                        final String data = valueKey.value;
                        return listOrder.indexOf(data);
                      }),
                  physics: const PageScrollPhysics().applyTo(const BouncingScrollPhysics()),
                ),
              ),
            )),
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
              child: LiveCard(expanded: true, onTap: () => Navigator.pop(context), controller: _liveController),
            ),
          ),
        ),
      ),
    );
  }

  Future<List<DateWidget>> getFilterWidgets(HomeFilterItems activeData, {bool absencesNoExcused = false}) async {
    List<DateWidget> items = [];

    switch (activeData) {
      // All
      case HomeFilterItems.all:
        final all = await Future.wait<List<DateWidget>>([
          getFilterWidgets(HomeFilterItems.grades),
          getFilterWidgets(HomeFilterItems.lessons),
          getFilterWidgets(HomeFilterItems.messages),
          getFilterWidgets(HomeFilterItems.absences, absencesNoExcused: true),
          getFilterWidgets(HomeFilterItems.homework),
          getFilterWidgets(HomeFilterItems.exams),
        ]);
        items.addAll(all.expand((x) => x));
        break;

      // Grades
      case HomeFilterItems.grades:
        gradeProvider.grades.forEach((grade) {
          if (grade.type == GradeType.midYear) {
            items.add(DateWidget(
              key: grade.id,
              date: grade.date,
              widget: GradeTile(grade, onTap: () => GradeView.show(grade, context: context)),
            ));
          }
        });
        break;

      // Messages
      case HomeFilterItems.messages:
        messageProvider.messages.forEach((message) {
          if (message.type == MessageType.inbox) {
            items.add(DateWidget(
                key: "${message.id}",
                date: message.date,
                widget: MessageTile(
                  message,
                  onTap: () => MessageView.show([message], context: context),
                )));
          }
        });
        items.addAll(await getFilterWidgets(HomeFilterItems.notes));
        items.addAll(await getFilterWidgets(HomeFilterItems.events));
        break;

      // Absences
      case HomeFilterItems.absences:
        absenceProvider.absences.where((a) => !absencesNoExcused || a.state != Justification.Excused).forEach((absence) {
          items.add(DateWidget(
              key: absence.id,
              date: absence.date,
              widget: AbsenceTile(
                absence,
                onTap: () => AbsenceView.show(absence, context: context),
              )));
        });
        break;

      // Homework
      case HomeFilterItems.homework:
        homeworkProvider.homework.where((h) => h.deadline.isAfter(DateTime.now())).forEach((homework) {
          items.add(DateWidget(
              key: homework.id,
              date: homework.deadline.year != 0 ? homework.deadline : homework.date,
              widget: HomeworkTile(
                homework,
                onTap: () => HomeworkView.show(homework, context: context),
              )));
        });
        break;

      // Exams
      case HomeFilterItems.exams:
        examProvider.exams.forEach((exam) {
          items.add(DateWidget(
              key: exam.id,
              date: exam.writeDate.year != 0 ? exam.writeDate : exam.date,
              widget: ExamTile(
                exam,
                onTap: () => ExamView.show(exam, context: context),
              )));
        });
        break;

      // Notes
      case HomeFilterItems.notes:
        noteProvider.notes.forEach((note) {
          items.add(DateWidget(
              key: note.id,
              date: note.date,
              widget: NoteTile(
                note,
                onTap: () => NoteView.show(note, context: context),
              )));
        });
        break;

      // Events
      case HomeFilterItems.events:
        eventProvider.events.forEach((event) {
          items.add(DateWidget(
              key: event.id,
              date: event.start,
              widget: EventTile(
                event,
                onTap: () => EventView.show(event, context: context),
              )));
        });
        break;

      // Changed Lessons
      case HomeFilterItems.lessons:
        timetableProvider.lessons.where((l) => l.isChanged && l.start.isAfter(DateTime.now())).forEach((lesson) {
          items.add(DateWidget(
              key: lesson.id,
              date: lesson.date,
              widget: ChangedLessonTile(
                lesson,
                onTap: () => TimetablePage.jump(context, lesson: lesson),
              )));
        });
        break;
    }
    return items;
  }
}

// difference.inDays is not reliable
bool _sameDate(DateTime a, DateTime b) => (a.year == b.year && a.month == b.month && a.day == b.day);

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
      key: "${conv.newest.date.millisecondsSinceEpoch}-msg",
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
      if (!_sameDate(element.date, groupedDateWidgets.last.last.date)) {
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
        elements.add(DateWidget(
            widget: AbsenceGroupTile(absenceTiles, showDate: !_showTitle),
            date: absenceTileWidgets.first.date,
            key: "${absenceTileWidgets.first.date.millisecondsSinceEpoch}-absence-group"));
      }

      final String date = (elements + absenceTileWidgets).first.date.format(context);
      if (_showTitle) items.add(PanelTitle(title: Text(date), key: ValueKey("$date-title")));
      items.add(Panel(
        key: ValueKey("$date"),
        hasShadow: false,
        child: ImplicitlyAnimatedList<DateWidget>(
            areItemsTheSame: (a, b) => a.key == b.key,
            spawnIsolate: false,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, animation, item, index) => _itemBuilder(context, animation, item.widget, index),
            items: elements),
        padding: padding,
      ));

      items.add(Padding(padding: EdgeInsets.only(bottom: 12.0), key: ValueKey("$date-padding")));
    });
  }
  if (items.isEmpty) items.addAll([Empty(subtitle: "empty".i18n, key: ValueKey("empty")), Container()]);
  return items;
}

class DateWidget {
  final DateTime date;
  final Widget widget;
  final String? key;
  const DateWidget({required this.date, required this.widget, this.key});
}

enum HomeFilterItems { all, grades, messages, absences, homework, exams, notes, events, lessons }

Widget _itemBuilder(BuildContext context, Animation<double> animation, Widget item, int index) {
  final wrappedItem = SizeFadeTransition(
    curve: Curves.easeInOutCubic,
    animation: animation,
    child: item,
  );
  return item is Panel
      // Re-add & animate shadow
      ? AnimatedBuilder(
          animation: animation,
          child: wrappedItem,
          builder: (context, child) {
            return DecoratedBox(
              child: child,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 21),
                      blurRadius: 23.0,
                      color: AppColors.of(context).shadow.withOpacity(
                          CurvedAnimation(parent: CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic), curve: Interval(2 / 3, 1.0))
                              .value))
                ],
              ),
            );
          })
      : wrappedItem;
}
