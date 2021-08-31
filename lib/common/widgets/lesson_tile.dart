import 'package:filcnaplo_kreta_api/providers/exam_provider.dart';
import 'package:filcnaplo_kreta_api/providers/homework_provider.dart';
import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo_kreta_api/models/exam.dart';
import 'package:filcnaplo_kreta_api/models/homework.dart';
import 'package:filcnaplo_kreta_api/models/lesson.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/exam_view.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/homework_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'lesson_tile.i18n.dart';

class LessonTile extends StatelessWidget {
  const LessonTile(this.lesson, {Key? key, this.onTap}) : super(key: key);

  final Lesson lesson;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    List<Widget> subtiles = [];

    Color accent = Theme.of(context).colorScheme.secondary;
    bool fill = false;
    String lessonIndexTrailing = "";

    // Only put a trailing . if its a digit
    if (RegExp(r'\d').hasMatch(lesson.lessonIndex)) lessonIndexTrailing = ".";

    if (lesson.substituteTeacher != "") {
      fill = true;
      accent = AppColors.of(context).yellow;
    }

    if (lesson.status?.name == "Elmaradt") {
      fill = true;
      accent = AppColors.of(context).red;
    }

    if (lesson.isEmpty) {
      accent = AppColors.of(context).text.withOpacity(0.6);
    }

    if (lesson.homeworkId != "") {
      Homework homework = Provider.of<HomeworkProvider>(context, listen: false)
          .homework
          .firstWhere((h) => h.id == lesson.homeworkId,
              orElse: () => Homework.fromJson({}));

      if (homework.id != "")
        subtiles.add(LessonSubtile(
          type: LessonSubtileType.homework,
          title: homework.content,
          onPressed: () => HomeworkView.show(homework, context: context),
        ));
    }

    lesson.exams.forEach((e) {
      Exam exam = Provider.of<ExamProvider>(context, listen: false)
          .exams
          .firstWhere((t) => t.id == e, orElse: () => Exam.fromJson({}));
      if (exam.id != "")
        subtiles.add(LessonSubtile(
          type: LessonSubtileType.exam,
          title: exam.description,
          onPressed: () => ExamView.show(exam, context: context),
        ));
    });

    return Material(
      type: MaterialType.transparency,
      child: Visibility(
        visible: lesson.subject.id != '' || lesson.isEmpty,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                tileColor: fill ? accent.withOpacity(0.25) : Color(0),
                minVerticalPadding: 12.0,
                dense: true,
                onTap: onTap,
                visualDensity: VisualDensity.compact,
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                title: Text(
                  !lesson.isEmpty
                      ? lesson.subject.name.capital()
                      : "empty".i18n,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.5,
                    color: AppColors.of(context)
                        .text
                        .withOpacity(!lesson.isEmpty ? 1.0 : 0.5),
                  ),
                ),
                subtitle: lesson.description != ""
                    ? Text(
                        lesson.description,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                minLeadingWidth: 34.0,
                leading: SizedBox(
                  width: 30.0,
                  child: Center(
                    child: Text(lesson.lessonIndex + lessonIndexTrailing,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w600,
                          color: accent,
                        )),
                  ),
                ),
                trailing: !lesson.isEmpty
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 48.0,
                            child: Padding(
                              padding: EdgeInsets.only(right: 6.0),
                              child: Text(
                                lesson.room,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.fade,
                                maxLines: 2,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.of(context)
                                        .text
                                        .withOpacity(.75)),
                              ),
                            ),
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Fix alignment hack
                              Opacity(child: Text("EE:EE"), opacity: 0),
                              Text(
                                DateFormat("H:mm").format(lesson.start) +
                                    "\n" +
                                    DateFormat("H:mm").format(lesson.end),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.of(context)
                                      .text
                                      .withOpacity(.9),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : null,
              ),

              // Homework & Exams
              ...subtiles,
            ],
          ),
        ),
        replacement: Padding(
          padding: EdgeInsets.only(top: 6.0),
          child: PanelTitle(title: Text(lesson.name)),
        ),
      ),
    );
  }
}

enum LessonSubtileType { homework, exam }

class LessonSubtile extends StatelessWidget {
  const LessonSubtile(
      {Key? key, this.onPressed, required this.title, required this.type})
      : super(key: key);

  final Function()? onPressed;
  final String title;
  final LessonSubtileType type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6.0),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Center(
                child: SizedBox(
                  width: 30.0,
                  child: Icon(
                      type == LessonSubtileType.homework
                          ? FeatherIcons.home
                          : FeatherIcons.file,
                      size: 20.0),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    title.escapeHtml(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
