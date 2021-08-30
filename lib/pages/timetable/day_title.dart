import 'package:filcnaplo/theme.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/utils/format.dart';

class DayTitle extends StatefulWidget {
  DayTitle({Key? key, required this.dayTitle, required this.controller}) : super(key: key);

  final String Function(int) dayTitle;
  final TabController controller;

  @override
  State<DayTitle> createState() => _DayTitleState();
}

class _DayTitleState extends State<DayTitle> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
        animation: widget.controller.animation!,
        builder: (context, _) {
          double value = widget.controller.animation!.value;

          return Transform.translate(
            offset: Offset(-value * width / 1.5, 0),
            child: Row(
              children: List.generate(
                widget.controller.length,
                (index) {
                  double opacity = (value - index + 1).clamp(0, 1);

                  return SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Text(
                      widget.dayTitle(index).capital(),
                      style: TextStyle(color: AppColors.of(context).text.withOpacity(opacity), fontSize: 32.0, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}
