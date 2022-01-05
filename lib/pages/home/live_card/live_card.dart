import 'package:filcnaplo_kreta_api/controllers/live_card_controller.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/lesson_tile.dart';
import 'package:filcnaplo_mobile_ui/pages/home/live_card/live_card_widget.dart';
import 'package:flutter/material.dart';
import 'live_card.i18n.dart';

class LiveCard extends StatefulWidget {
  const LiveCard({Key? key, this.expanded = false, this.onTap, required this.controller}) : super(key: key);

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
      onTap: widget.controller.nextLessons?.isNotEmpty ?? false ? widget.onTap : null,
      lesson: widget.controller.currentLesson!,
      next: widget.controller.nextLesson?.subject,
      shadowColor: widget.expanded ? const Color(0x00000000) : null,
      child: widget.expanded ? _buildBody() : null,
    );
  }

  Widget _buildBody() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
        physics: const BouncingScrollPhysics(),
        itemCount: (widget.controller.nextLessons?.length ?? 0) + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 12.0),
              child: Text(
                "upcoming".i18n,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17.0),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: LessonTile(widget.controller.nextLessons![index - 1]),
            );
          }
        },
      ),
    );
  }
}
