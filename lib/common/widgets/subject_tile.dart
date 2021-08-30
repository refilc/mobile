import 'package:filcnaplo/helpers/subject_icon.dart';
import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_mobile_ui/common/average_display.dart';
import 'package:flutter/material.dart';

class SubjectTile extends StatelessWidget {
  const SubjectTile(this.subject, {Key? key, this.average = 0.0, this.groupAverage = 0.0, this.onTap}) : super(key: key);

  final Subject subject;
  final void Function()? onTap;
  final double average;
  final double groupAverage;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        minLeadingWidth: 32.0,
        dense: true,
        contentPadding: EdgeInsets.only(left: 8.0, right: 6.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        visualDensity: VisualDensity.compact,
        onTap: onTap,
        leading: Icon(SubjectIcon.lookup(subject: subject), color: AppColors.of(context).text.withOpacity(.75)),
        title: Text(
          subject.name.capital(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (groupAverage != 0) AverageDisplay(average: groupAverage, border: true),
            SizedBox(width: 6.0),
            if (average != 0) AverageDisplay(average: average)
          ],
        ),
      ),
    );
  }
}
