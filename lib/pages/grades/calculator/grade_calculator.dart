import 'dart:math';

import 'package:filcnaplo_kreta_api/models/category.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:filcnaplo_kreta_api/models/subject.dart';
import 'package:filcnaplo_mobile_ui/common/custom_snack_bar.dart';
import 'package:filcnaplo_mobile_ui/common/material_action_button.dart';
import 'package:filcnaplo_mobile_ui/common/widgets/grade_tile.dart';
import 'package:filcnaplo_mobile_ui/pages/grades/calculator/grade_calculator_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'grade_calculator.i18n.dart';

class GradeCalculator extends StatefulWidget {
  GradeCalculator(this.subject, {Key? key}) : super(key: key);

  final Subject subject;

  @override
  _GradeCalculatorState createState() => _GradeCalculatorState();
}

class _GradeCalculatorState extends State<GradeCalculator> {
  late GradeCalculatorProvider calculatorProvider;

  double newValue = 5.0;
  double newWeight = 100.0;

  @override
  Widget build(BuildContext context) {
    calculatorProvider = Provider.of<GradeCalculatorProvider>(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Grade Calculator".i18n,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
          ),

          // Grade value
          Row(children: [
            Expanded(
              child: Slider(
                thumbColor: Theme.of(context).colorScheme.secondary,
                activeColor: Theme.of(context).colorScheme.secondary,
                value: newValue,
                min: 1.0,
                max: 5.0,
                divisions: 4,
                label: "${newValue.toInt()}",
                onChanged: (value) => setState(() => newValue = value),
              ),
            ),
            Container(
              width: 70.0,
              padding: EdgeInsets.only(right: 12.0),
              child: Center(child: GradeValueWidget(GradeValue(newValue.toInt(), "", "", 0))),
            ),
          ]),

          // Grade weight
          Row(children: [
            Expanded(
              child: Slider(
                thumbColor: Theme.of(context).colorScheme.secondary,
                activeColor: Theme.of(context).colorScheme.secondary,
                value: newWeight,
                min: 50.0,
                max: 400.0,
                divisions: 7,
                label: "${newWeight.toInt()}%",
                onChanged: (value) => setState(() => newWeight = value),
              ),
            ),
            Container(
              width: 70.0,
              padding: EdgeInsets.only(right: 12.0),
              child: Center(
                child: Text(
                  "${newWeight.toInt()}%",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
                ),
              ),
            ),
          ]),
          Container(
            width: 120.0,
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: MaterialActionButton(
              child: Text("Add Grade".i18n),
              onPressed: () {
                if (calculatorProvider.ghosts.length >= 30) {
                  ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(content: Text("limit_reached".i18n), context: context));
                  return;
                }

                DateTime date;

                if (calculatorProvider.ghosts.length > 0) {
                  List<Grade> grades = calculatorProvider.ghosts;
                  grades.sort((a, b) => -a.writeDate.compareTo(b.writeDate));
                  date = grades.first.date.add(Duration(days: 7));
                } else {
                  List<Grade> grades = calculatorProvider.grades.where((e) => e.type == GradeType.midYear && e.subject == widget.subject).toList();
                  grades.sort((a, b) => -a.writeDate.compareTo(b.writeDate));
                  date = grades.first.date;
                }

                calculatorProvider.addGhost(Grade(
                  id: randomId(),
                  date: date,
                  writeDate: date,
                  description: "Ghost Grade".i18n,
                  value: GradeValue(newValue.toInt(), "", "", newWeight.toInt()),
                  teacher: "Ghost",
                  type: GradeType.ghost,
                  form: "",
                  subject: widget.subject,
                  mode: Category.fromJson({}),
                  seenDate: DateTime(0),
                  groupId: "",
                ));
              },
            ),
          ),
        ],
      ),
    );
  }

  String randomId() {
    var rng = Random();
    return rng.nextInt(1000000000).toString();
  }
}
