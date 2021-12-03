import 'package:filcnaplo/helpers/subject_icon.dart';
import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo_kreta_api/models/exam.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:flutter/material.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ExamTile extends StatelessWidget {
  const ExamTile(this.exam, {Key? key, this.onTap}) : super(key: key);

  final Exam exam;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      borderRadius: BorderRadius.circular(8.0),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.only(left: 8.0, right: 12.0),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        leading: Padding(
          padding: EdgeInsets.only(top: 2.0),
          child: Icon(
            SubjectIcon.lookup(subject: Subject.fromString(exam.subjectName)),
            size: 28.0,
            color: AppColors.of(context).text.withOpacity(.75),
          ),
        ),
        title: Text(
          exam.description != "" ? exam.description : (exam.mode?.description ?? "Számonkérés"),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          exam.subjectName.capital(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: Icon(
          FeatherIcons.edit,
          color: AppColors.of(context).text.withOpacity(.75),
        ),
        minLeadingWidth: 0,
      ),
    );
  }
}
