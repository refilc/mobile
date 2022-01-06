import 'package:filcnaplo_kreta_api/providers/grade_provider.dart';
import 'package:filcnaplo_kreta_api/models/grade.dart';
import 'package:flutter/widgets.dart';

class GradeCalculatorProvider extends GradeProvider {
  GradeCalculatorProvider(BuildContext context, {List<Grade> initialGrades = const []}) : super(context: context, initialGrades: initialGrades);

  List<Grade> _grades = [];
  List<Grade> _ghosts = [];
  @override
  List<Grade> get grades => _grades + _ghosts;
  List<Grade> get ghosts => _ghosts;

  void addGhost(Grade grade) {
    _ghosts.add(grade);
    notifyListeners();
  }

  void addGrade(Grade grade) {
    _grades.add(grade);
    notifyListeners();
  }

  void removeGrade(Grade ghost) {
    _ghosts.removeWhere((e) => ghost.id == e.id);
    notifyListeners();
  }

  void addAllGrades(List<Grade> grades) {
    _grades.addAll(grades);
    notifyListeners();
  }

  void clear() {
    _grades = [];
    _ghosts = [];
  }
}
