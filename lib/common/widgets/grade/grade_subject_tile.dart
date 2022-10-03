import 'package:filcnaplo/helpers/subject.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_mobile_ui/common/average_display.dart';
import 'package:flutter/material.dart';

class GradeSubjectTile extends StatelessWidget {
  const GradeSubjectTile(this.subject, {Key? key, this.average = 0.0, this.groupAverage = 0.0, this.onTap}) : super(key: key);

  final Subject subject;
  final void Function()? onTap;
  final double average;
  final double groupAverage;

  @override
  Widget build(BuildContext context) {
    Color textColor = AppColors.of(context).text;

    // Failing indicator
    if (average < 2.0 && average >= 1.0) {
      textColor = AppColors.of(context).red;
    }

    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        minLeadingWidth: 32.0,
        dense: true,
        contentPadding: const EdgeInsets.only(left: 8.0, right: 6.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        visualDensity: VisualDensity.compact,
        onTap: onTap,
        leading: Icon(SubjectIcon.resolve(subject: subject).data, color: textColor.withOpacity(.75)),
        title: Text(
          subject.name.capital(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0, color: textColor),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (groupAverage != 0) AverageDisplay(average: groupAverage, border: true),
            const SizedBox(width: 6.0),
            if (average != 0) AverageDisplay(average: average)
          ],
        ),
      ),
    );
  }
}
