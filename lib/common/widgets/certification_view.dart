import 'package:filcnaplo/theme.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_mobile_ui/common/panel/panel.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/certification_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'certification_card.i18n.dart';

class CertificationView extends StatelessWidget {
  const CertificationView(this.grades, {Key? key, required this.gradeType}) : super(key: key);

  final List<Grade> grades;
  final GradeType gradeType;

  static show(List<Grade> grades, {required BuildContext context, required GradeType gradeType}) =>
      Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(builder: (context) => CertificationView(grades, gradeType: gradeType)));

  String getGradeTypeTitle() {
    String title;

    switch (gradeType) {
      case GradeType.halfYear:
        title = "mid".i18n;
        break;
      case GradeType.firstQ:
        title = "1q".i18n;
        break;
      case GradeType.secondQ:
        title = "2q".i18n;
        break;
      case GradeType.thirdQ:
        title = "3q".i18n;
        break;
      case GradeType.fourthQ:
        title = "4q".i18n;
        break;
      default:
        title = "final".i18n;
    }

    return title;
  }

  @override
  Widget build(BuildContext context) {
    String title = getGradeTypeTitle();

    grades.sort((a, b) => a.subject.name.compareTo(b.subject.name));
    List<Widget> tiles = grades.map((e) => CertificationTile(e)).toList();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: AppColors.of(context).text),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Icon(FeatherIcons.award, size: 26.0),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 32.0),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            child: Panel(
              child: Column(children: tiles),
            ),
          ),
        ],
      ),
    );
  }
}
