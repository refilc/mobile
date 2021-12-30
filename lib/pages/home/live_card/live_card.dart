import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo_kreta_api/controllers/live_card_controller.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/lesson_tile.dart';
import 'package:filcnaplo_mobile_ui/pages/home/live_card/live_card_widget.dart';
import 'package:flutter/material.dart';
import 'live_card.i18n.dart';

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
    if (widget.controller.currentLesson == null)
      return Container(
        color: AppColors.of(context).background,
        width: MediaQuery.of(context).size.width,
        height: 200,
      );

    return Padding(
        padding: EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          top: 58.0 + MediaQuery.of(context).padding.top,
          bottom: 52.0,
        ),
        child: LiveCardWidget(
          onTap: widget.controller.nextLessons?.length != 0 ? widget.onTap : null,
          lesson: widget.controller.currentLesson!,
          next: widget.controller.nextLesson?.subject,
          shadowColor: widget.expanded ? Color(0) : null,
          child: widget.expanded ? _buildBody() : null,
        ));
  }

  Widget _buildBody() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
        physics: BouncingScrollPhysics(),
        itemCount: (widget.controller.nextLessons?.length ?? 0) + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.only(left: 8.0, top: 12.0),
              child: Text(
                "upcoming".i18n,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17.0),
              ),
            );
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: LessonTile(widget.controller.nextLessons![index - 1]),
            );
          }
        },
      ),
    );
  }
}
