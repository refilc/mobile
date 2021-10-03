import 'package:filcnaplo/models/settings.dart';
import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo/helpers/subject_icon.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:filcnaplo_mobile_ui/pages/grades/calculator/grade_calculator_provider.dart';
import 'package:filcnaplo_mobile_ui/pages/grades/subject_grades_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

class GradeTile extends StatelessWidget {
  const GradeTile(this.grade, {Key? key, this.onTap}) : super(key: key);

  final Grade grade;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    String title;
    String subtitle;
    EdgeInsets leadingPadding = EdgeInsets.zero;
    bool isSubjectView = SubjectGradesContainer.of(context) != null;
    String subjectName = grade.subject.name.capital();
    String modeDescription = grade.mode.description.capital();
    String description = grade.description.capital();

    GradeCalculatorProvider calculatorProvider = Provider.of<GradeCalculatorProvider>(context, listen: false);

    // Test order:
    // description
    // mode
    // value name
    if (grade.type == GradeType.midYear || grade.type == GradeType.ghost) {
      if (grade.description != "")
        title = description;
      else
        title = modeDescription != "" ? modeDescription : grade.value.valueName.split("(")[0];
    } else {
      title = subjectName;
    }

    // Test order:
    // subject name
    // mode + weight != 100
    if (grade.type == GradeType.midYear) {
      subtitle = isSubjectView
          ? description != ""
              ? modeDescription
              : ""
          : subjectName;
    } else {
      subtitle = grade.value.valueName.split("(")[0];
    }

    if (subtitle != "") leadingPadding = EdgeInsets.only(top: 2.0);

    return Material(
      color: Theme.of(context).backgroundColor,
      borderRadius: BorderRadius.circular(8.0),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        contentPadding: isSubjectView
            ? grade.type != GradeType.ghost
                ? EdgeInsets.symmetric(horizontal: 12.0)
                : EdgeInsets.only(left: 12.0, right: 4.0)
            : EdgeInsets.only(left: 8.0, right: 12.0),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        leading: isSubjectView
            ? SizedBox(
                width: 44,
                height: 44,
                child: Center(child: GradeValueWidget(grade.value)),
              )
            : Padding(
                padding: leadingPadding,
                child: Icon(SubjectIcon.lookup(subject: grade.subject), size: 28.0, color: AppColors.of(context).text.withOpacity(.75)),
              ),
        title: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: subtitle != ""
            ? Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w500),
              )
            : null,
        trailing: isSubjectView
            ? grade.type != GradeType.ghost
                ? Text(grade.date.format(context), style: TextStyle(fontWeight: FontWeight.w500))
                : IconButton(
                    splashRadius: 24.0,
                    icon: Icon(FeatherIcons.trash2, color: AppColors.of(context).red),
                    onPressed: () {
                      calculatorProvider.removeGrade(grade);
                    },
                  )
            : GradeValueWidget(grade.value),
        minLeadingWidth: isSubjectView ? 32.0 : 0,
      ),
    );
  }
}

class GradeValueWidget extends StatelessWidget {
  const GradeValueWidget(this.value, {Key? key, this.size = 38.0, this.fill = false}) : super(key: key);

  final GradeValue value;
  final double size;
  final bool fill;

  @override
  Widget build(BuildContext context) {
    Color color = gradeColor(context: context, value: value.value);
    Widget valueText;
    if (value.value != 0) {
      valueText = Text(
        value.value.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: size, color: color),
      );
    } else if (value.valueName.toLowerCase().specialChars() == 'nem irt') {
      valueText = Icon(FeatherIcons.slash);
    } else {
      valueText = Icon(FeatherIcons.type);
    }
    return fill
        ? Container(
            width: size * (fill ? 1.4 : 1.0),
            height: size * (fill ? 1.4 : 1.0),
            decoration: BoxDecoration(
              color: fill ? color.withOpacity(.25) : Color(0),
              shape: BoxShape.circle,
            ),
            child: Center(child: valueText),
          )
        : valueText;
  }
}

Color gradeColor({required BuildContext context, required num value}) {
  int valueInt;
  var settings = Provider.of<SettingsProvider>(context, listen: false);
  if (value > value.floor() + settings.rounding / 10) {
    valueInt = value.ceil();
  } else {
    valueInt = value.floor();
  }

  switch (valueInt) {
    case 5:
      return settings.gradeColors[4];
    case 4:
      return settings.gradeColors[3];
    case 3:
      return settings.gradeColors[2];
    case 2:
      return settings.gradeColors[1];
    case 1:
      return settings.gradeColors[0];
    default:
      return AppColors.of(context).text;
  }
}
