import 'package:animations/animations.dart';
import 'package:filcnaplo/api/providers/user_provider.dart';
import 'package:filcnaplo/helpers/subject_icon.dart';
import 'package:filcnaplo/icons/filc_icons.dart';
import 'package:filcnaplo/theme.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_kreta_api/controllers/live_card_controller.dart';
import 'package:filcnaplo_mobile_ui/pages/home/live_card/live_card_widget.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'live_card.i18n.dart';

class LiveCard extends StatefulWidget {
  const LiveCard({Key? key, required this.controller}) : super(key: key);

  final LiveCardController controller;

  @override
  _LiveCardState createState() => _LiveCardState();
}

class _LiveCardState extends State<LiveCard> {
  late void Function() listener;
  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    listener = () => setState(() {});
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _userProvider.addListener(widget.controller.update);
    widget.controller.addListener(listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(listener);
    _userProvider.removeListener(widget.controller.update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.controller.show) return Container();

    Widget child;

    switch (widget.controller.currentState) {
      case LiveCardState.morning:
        child = LiveCardWidget(
          key: const Key('livecard.morning'),
          title: DateFormat("EEEE", I18n.of(context).locale.toString()).format(DateTime.now()).capital(),
          icon: FeatherIcons.sun,
          description: widget.controller.nextLesson != null
              ? Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "first_lesson_1".i18n),
                      TextSpan(
                        text: widget.controller.nextLesson!.subject.name.capital(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.secondary.withOpacity(.85),
                        ),
                      ),
                      TextSpan(text: "first_lesson_2".i18n),
                      TextSpan(
                        text: widget.controller.nextLesson!.room.capital(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.secondary.withOpacity(.85),
                        ),
                      ),
                      TextSpan(text: "first_lesson_3".i18n),
                      TextSpan(
                        text: DateFormat('H:mm').format(widget.controller.nextLesson!.start),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.secondary.withOpacity(.85),
                        ),
                      ),
                      TextSpan(text: "first_lesson_4".i18n),
                    ],
                  ),
                )
              : null,
        );
        break;
      case LiveCardState.duringLesson:
        child = LiveCardWidget(
          key: const Key('livecard.duringLesson'),
          leading: widget.controller.currentLesson!.lessonIndex + (RegExp(r'\d').hasMatch(widget.controller.currentLesson!.lessonIndex) ? "." : ""),
          title: widget.controller.currentLesson!.subject.name.capital(),
          subtitle: widget.controller.currentLesson!.room,
          icon: SubjectIcon.lookup(subject: widget.controller.currentLesson!.subject),
          description: widget.controller.currentLesson!.description != "" ? Text(widget.controller.currentLesson!.description) : null,
          nextSubject: widget.controller.nextLesson?.subject.name.capital(),
          nextRoom: widget.controller.nextLesson?.room,
          progressMax: widget.controller.currentLesson!.end.difference(widget.controller.currentLesson!.start).inMinutes.toDouble(),
          progressCurrent: DateTime.now().difference(widget.controller.currentLesson!.start).inMinutes.toDouble(),
        );
        break;
      case LiveCardState.duringBreak:
        String getFloorDifference() {
          final prevFloor = widget.controller.prevLesson!.getFloor();
          final nextFloor = widget.controller.nextLesson!.getFloor();

          if (prevFloor == null || nextFloor == null || prevFloor == nextFloor) {
            return "to room";
          }

          if (nextFloor == 0) {
            return "ground floor";
          }

          if (nextFloor > prevFloor) {
            return "up floor";
          } else {
            return "down floor";
          }
        }

        final iconFloorMap = {
          "to room": FeatherIcons.chevronsRight,
          "up floor": FilcIcons.upstairs,
          "down floor": FilcIcons.downstairs,
          "ground floor": FilcIcons.downstairs,
        };

        final diff = getFloorDifference();

        child = LiveCardWidget(
          key: const Key('livecard.duringBreak'),
          title: "break".i18n,
          icon: iconFloorMap[diff],
          description: widget.controller.nextLesson!.room != widget.controller.prevLesson!.room
              ? Text("go $diff".i18n.fill([diff != "to room" ? (widget.controller.nextLesson!.getFloor() ?? 0) : widget.controller.nextLesson!.room]))
              : Text("stay".i18n),
          nextSubject: widget.controller.nextLesson?.subject.name.capital(),
          nextRoom: diff != "to room" ? widget.controller.nextLesson?.room : null,
          progressMax: widget.controller.nextLesson!.start.difference(widget.controller.prevLesson!.end).inMinutes.toDouble(),
          progressCurrent: DateTime.now().difference(widget.controller.prevLesson!.end).inMinutes.toDouble(),
        );
        break;
      case LiveCardState.afternoon:
        child = LiveCardWidget(
          key: const Key('livecard.afternoon'),
          title: DateFormat("EEEE", I18n.of(context).locale.toString()).format(DateTime.now()).capital(),
          icon: FeatherIcons.coffee,
        );
        break;
      case LiveCardState.night:
        child = LiveCardWidget(
          key: const Key('livecard.night'),
          title: DateFormat("EEEE", I18n.of(context).locale.toString()).format(DateTime.now()).capital(),
          icon: FeatherIcons.moon,
        );
        break;
      default:
        child = Container();
    }

    return PageTransitionSwitcher(
      transitionBuilder: (
        Widget child,
        Animation<double> primaryAnimation,
        Animation<double> secondaryAnimation,
      ) {
        return SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
        );
      },
      child: child,
    );
  }
}
