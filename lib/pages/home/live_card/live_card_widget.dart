import 'dart:math';

import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo/helpers/subject_icon.dart';
import 'package:filcnaplo_kreta_api/models/lesson.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_mobile_ui/common/progress_bar.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'live_card.i18n.dart';

class LiveCardWidget extends StatelessWidget {
  const LiveCardWidget({Key? key, this.onTap, this.child, this.shadowColor, required this.lesson, this.next}) : super(key: key);

  final void Function()? onTap;
  final Widget? child;
  final Color? shadowColor;
  final Lesson lesson;
  final Subject? next;

  @override
  Widget build(BuildContext context) {
    String lessonIndexTrailing = "";
    if (RegExp(r'\d').hasMatch(lesson.lessonIndex)) lessonIndexTrailing = ".";

    int length = lesson.end.difference(lesson.start).inMinutes;
    int progress = lesson.end.difference(DateTime.now()).inMinutes + 1;

    return Hero(
      tag: "livecard",
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0),
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 21),
              blurRadius: 23.0,
              color: shadowColor ?? AppColors.of(context).shadow,
            )
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  visualDensity: VisualDensity.compact,
                  dense: true,
                  minLeadingWidth: 0.0,
                  leading: Padding(
                    padding: EdgeInsets.only(top: 6.0),
                    child: Icon(
                      SubjectIcon.lookup(subject: lesson.subject),
                      color: Theme.of(context).colorScheme.secondary,
                      size: 28.0,
                    ),
                  ),
                  title: Text.rich(
                    TextSpan(children: [
                      TextSpan(text: "${lesson.lessonIndex}$lessonIndexTrailing ", style: TextStyle(fontWeight: FontWeight.w700)),
                      TextSpan(
                          text: lesson.subject.name.capital(),
                          style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.of(context).text.withOpacity(0.8)))
                    ]),
                    style: TextStyle(fontSize: 16.0),
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                  subtitle: lesson.description != ""
                      ? Text(
                          lesson.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0),
                        )
                      : null,
                  trailing: Text(
                    lesson.room.replaceAll("_", " "),
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.of(context).text.withOpacity(0.7)),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                    child: Row(
                      children: [
                        if (next != null)
                          Expanded(
                            flex: 2,
                            child: Text.rich(
                              TextSpan(
                                  text: "next".i18n + ": ",
                                  style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.of(context).text.withOpacity(0.65)),
                                  children: [
                                    TextSpan(
                                        text: next?.name.capital(),
                                        style: TextStyle(fontWeight: FontWeight.w400, color: AppColors.of(context).text.withOpacity(0.65)))
                                  ]),
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            "remaining".plural(max(progress, 0.0).round()),
                            maxLines: 1,
                            softWrap: false,
                            textAlign: TextAlign.right,
                            style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.of(context).text.withOpacity(0.65)),
                          ),
                        ),
                      ],
                    )),

                // Progress Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: ProgressBar(value: (length - progress) / length, backgroundColor: Theme.of(context).colorScheme.secondary),
                ),

                // Body
                if (child != null) child!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
