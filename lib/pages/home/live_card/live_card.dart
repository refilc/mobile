import 'package:filcnaplo_kreta_api/controllers/live_card_controller.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/lesson_tile.dart';
import 'package:filcnaplo_mobile_ui/pages/home/live_card/live_card_widget.dart';
import 'package:flutter/material.dart';

class LiveCard extends StatefulWidget {
  LiveCard({Key? key, this.expanded = false, this.onTap, required this.controller}) : super(key: key);

  final bool expanded;
  final void Function()? onTap;
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
    if (widget.controller.currentLesson == null) return Container();

    return LiveCardWidget(
      onTap: widget.controller.nextLessons?.length != 0 ? widget.onTap : null,
      lesson: widget.controller.currentLesson!,
      next: widget.controller.nextLesson?.subject,
      shadowColor: widget.expanded ? Color(0) : null,
      child: widget.expanded ? _buildBody() : null,
    );
  }

  // TODO: add title (e.g. "Upcoming lessons:"), bit more padding
  Widget _buildBody() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        itemCount: widget.controller.nextLessons?.length ?? 0,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: LessonTile(widget.controller.nextLessons![index]),
          );
        },
      ),
    );
  }
}
