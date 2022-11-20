import 'package:filcnaplo/ui/widgets/grade/grade_tile.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:flutter/material.dart';

class GradesCount extends StatelessWidget {
  const GradesCount({Key? key, required this.count, required this.value}) : super(key: key);

  final int count;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GradeValueWidget(GradeValue(count, "Count", "Count", 100), nocolor: true, size: 15.0),
        const SizedBox(width: 5.0),
        GradeValueWidget(GradeValue(value, "Value", "Value", 100), size: 19.0, fill: true, shadow: false),
      ],
    );
  }
}
