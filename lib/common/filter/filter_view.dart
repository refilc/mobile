import 'package:filcnaplo_mobile_ui/common/filter/filter_controller.dart';
import 'package:flutter/material.dart';

class FilterView extends StatefulWidget {
  FilterView({Key? key, required this.controller, required this.builder}) : super(key: key);

  final FilterController controller;
  final Widget Function(BuildContext context, int activeData) builder;

  @override
  _FilterViewState createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  @override
  void initState() {
    super.initState();
    widget.controller.updateView = () => setState(() => null);
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, widget.controller.activeIndex);
}
