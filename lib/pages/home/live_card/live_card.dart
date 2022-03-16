import 'package:filcnaplo/helpers/subject_icon.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_kreta_api/controllers/live_card_controller.dart';
import 'package:filcnaplo_mobile_ui/pages/home/live_card/live_card_widget.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:intl/intl.dart';
import 'live_card.i18n.dart';

class LiveCard extends StatefulWidget {
  const LiveCard({Key? key, required this.controller}) : super(key: key);

  final LiveCardController controller;

  @override
  _LiveCardState createState() => _LiveCardState();
}

class _LiveCardState extends State<LiveCard> {
  late void Function() listener;

  @override
  void initState() {
    super.initState();
    listener = () => setState(() {});
    widget.controller.addListener(listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.controller.show) return Container();

    switch (widget.controller.currentState) {
      case LiveCardState.morning:
        return LiveCardWidget(
          title: DateFormat("EEEE", I18n.of(context).locale.toString()).format(DateTime.now()).capital(),
          icon: FeatherIcons.sun,
          description: widget.controller.nextLesson != null
              ? Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: "Az első órád "),
                      TextSpan(
                        text: widget.controller.nextLesson!.subject.name.capital(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.secondary.withOpacity(.85),
                        ),
                      ),
                      TextSpan(
                        text: " (${widget.controller.nextLesson!.room.capital()}) ",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                      ),
                      const TextSpan(text: " lesz, "),
                      TextSpan(
                        text: DateFormat('H:mm').format(widget.controller.nextLesson!.start),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.secondary.withOpacity(.85),
                        ),
                      ),
                      const TextSpan(text: "-kor."),
                    ],
                  ),
                )
              : null,
        );
      case LiveCardState.duringLesson:
        return LiveCardWidget(
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
      case LiveCardState.duringPause:
        return LiveCardWidget(
          title: "pause".i18n,
          icon: FeatherIcons.chevronsRight,
          description: widget.controller.nextLesson!.room != widget.controller.prevLesson!.room
              ? Text("go to room".i18n.fill([widget.controller.nextLesson!.room]))
              : Text("stay".i18n),
          nextSubject: widget.controller.nextLesson?.subject.name.capital(),
          // nextRoom: widget.controller.nextLesson?.room,
          progressMax: widget.controller.nextLesson!.start.difference(widget.controller.prevLesson!.end).inMinutes.toDouble(),
          progressCurrent: DateTime.now().difference(widget.controller.prevLesson!.end).inMinutes.toDouble(),
        );
      case LiveCardState.afternoon:
        return LiveCardWidget(
          title: DateFormat("EEEE", I18n.of(context).locale.toString()).format(DateTime.now()).capital(),
          icon: FeatherIcons.coffee,
        );
      case LiveCardState.night:
        return LiveCardWidget(
          title: DateFormat("EEEE", I18n.of(context).locale.toString()).format(DateTime.now()).capital(),
          icon: FeatherIcons.moon,
        );
      default:
        return Container();
    }
  }
}
