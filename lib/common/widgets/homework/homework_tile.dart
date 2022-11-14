import 'package:filcnaplo/helpers/subject.dart';
import 'package:filcnaplo/theme/colors/colors.dart';
import 'package:filcnaplo_kreta_api/models/homework.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class HomeworkTile extends StatelessWidget {
  const HomeworkTile(this.homework, {Key? key, this.onTap, this.padding}) : super(key: key);

  final Homework homework;
  final void Function()? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      borderRadius: BorderRadius.circular(8.0),
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListTile(
          visualDensity: VisualDensity.compact,
          contentPadding: const EdgeInsets.only(left: 8.0, right: 12.0),
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          leading: SizedBox(
            width: 44,
            height: 44,
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Icon(
                SubjectIcon.resolveVariant(subjectName: homework.subjectName, context: context),
                size: 28.0,
                color: AppColors.of(context).text.withOpacity(.75),
              ),
            ),
          ),
          title: Text(
            homework.subjectName.capital(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            homework.content.escapeHtml().replaceAll('\n', ' '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          trailing: Icon(
            FeatherIcons.home,
            color: AppColors.of(context).text.withOpacity(.75),
          ),
          minLeadingWidth: 0,
        ),
      ),
    );
  }
}
