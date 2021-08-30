import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/grade_tile.dart';
import 'package:filcnaplo_mobile_ui/pages/grades/subject_grades_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class CertificationTile extends StatelessWidget {
  const CertificationTile(this.grade, {Key? key, this.onTap}) : super(key: key);

  final Function()? onTap;
  final Grade grade;

  @override
  Widget build(BuildContext context) {
    bool isSubjectView = SubjectGradesContainer.of(context) != null;
    String certificationName;

    // TODO: i18n
    switch (grade.type) {
      case GradeType.endYear:
        certificationName = "Év vége";
        break;
      case GradeType.halfYear:
        certificationName = "Félév";
        break;
      case GradeType.firstQ:
        certificationName = "1. Negyedév";
        break;
      case GradeType.secondQ:
        certificationName = "2. Negyedév";
        break;
      case GradeType.thirdQ:
        certificationName = "3. Negyedév";
        break;
      case GradeType.fourthQ:
        certificationName = "4. Negyedév";
        break;
      case GradeType.levelExam:
        certificationName = "Osztályozó";
        break;
      case GradeType.unknown:
      default:
        certificationName = "?";
    }

    return Material(
      color: Theme.of(context).backgroundColor,
      borderRadius: BorderRadius.circular(8.0),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        contentPadding: isSubjectView ? EdgeInsets.only(left: 12.0, right: 12.0, top: 2.0, bottom: 8.0) : EdgeInsets.only(left: 8.0, right: 12.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        onTap: onTap,
        leading: GradeValueWidget(grade.value),
        minLeadingWidth: 32.0,
        trailing: Icon(FeatherIcons.award),
        title: Text(certificationName, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0)),
        subtitle: Text(grade.value.valueName, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0)),
      ),
    );
  }
}
