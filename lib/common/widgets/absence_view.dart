import 'package:filcnaplo_kreta_api/models/absence.dart';
import 'package:filcnaplo_mobile_ui/common/bottom_card.dart';
import 'package:filcnaplo_mobile_ui/common/detail.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/absence_tile.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';
import 'absence_view.i18n.dart';

class AbsenceView extends StatelessWidget {
  const AbsenceView(this.absence, {Key? key}) : super(key: key);

  final Absence absence;

  static show(Absence absence, {required BuildContext context}) {
    showBottomCard(context: context, child: AbsenceView(absence));
  }

  @override
  Widget build(BuildContext context) {
    Color color = AbsenceTile.justificationColor(absence.state, context: context);

    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            visualDensity: VisualDensity.compact,
            contentPadding: EdgeInsets.only(left: 16.0, right: 12.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            leading: Container(
              width: 44.0,
              height: 44.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(.25),
              ),
              child: Center(
                child: Icon(
                  AbsenceTile.justificationIcon(absence.state),
                  color: color,
                ),
              ),
            ),
            title: Text(
              absence.subject.name.capital(),
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              absence.teacher,
              // DateFormat("MM. dd. (EEEEE)", I18n.of(context).locale.toString()).format(absence.date),
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: Text(
              absence.date.format(context),
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          // Absence Details
          if (absence.lessonIndex != null)
            Detail(
              title: "Lesson".i18n,
              description: "${absence.lessonIndex}. (${absence.lessonStart.format(context, timeOnly: true)}"
                  " - "
                  "${absence.lessonEnd.format(context, timeOnly: true)})",
            ),
          if (absence.justification != null)
            Detail(
              title: "Excuse".i18n,
              description: absence.justification?.description ?? "",
            ),
          if (absence.mode != "") Detail(title: "Mode".i18n, description: absence.mode?.description ?? ""),
          Detail(title: "Submit date".i18n, description: absence.submitDate.format(context))
        ],
      ),
    );
  }
}
