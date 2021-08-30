import 'package:filcnaplo_mobile_ui/common/bottom_sheet_menu/bottom_sheet_menu_item.dart';
import 'package:filcnaplo_mobile_ui/common/bottom_sheet_menu/rounded_bottom_sheet.dart';
import 'package:flutter/material.dart';

class BottomSheetMenu extends StatelessWidget {
  const BottomSheetMenu({Key? key, this.items = const []}) : super(key: key);

  final List<BottomSheetMenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items,
      ),
    );
  }
}

void showBottomSheetMenu(BuildContext context, {List<BottomSheetMenuItem> items = const []}) =>
    showRoundedModalBottomSheet(context, child: BottomSheetMenu(items: items));
