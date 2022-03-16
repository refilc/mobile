import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo_kreta_api/controllers/live_card_controller.dart';
import 'package:filcnaplo_mobile_ui/pages/home/live_card/live_card_widget.dart';
import 'package:flutter/material.dart';

class LiveCard extends StatefulWidget {
  const LiveCard({Key? key, this.onTap, required this.controller}) : super(key: key);

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
    if (widget.controller.currentLesson == null) {
      return Container(
        color: AppColors.of(context).background,
        width: MediaQuery.of(context).size.width,
        height: 200,
      );
    }

    return LiveCardWidget(
      onTap: widget.controller.nextLessons?.isNotEmpty ?? false ? widget.onTap : null,
      lesson: widget.controller.currentLesson!,
      next: widget.controller.nextLesson?.subject,
    );
  }
}
